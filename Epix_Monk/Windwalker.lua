local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1554 - (837 + 87)) < (3606 - 1479)) and ((1670 - (837 + 833)) == v5)) then
			v6 = v0[v4];
			if (not v6 or ((414 + 1524) == (3901 - (356 + 1031)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((5901 - (73 + 1573)) >= (1443 - (1307 + 81))) and (v5 == (235 - (7 + 227)))) then
			return v6(...);
		end
	end
end
v0["Epix_Monk_Windwalker.lua"] = function(...)
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
	local v26 = pairs;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = false;
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
	local v60 = v18.Monk.Windwalker;
	local v61 = v20.Monk.Windwalker;
	local v62 = v23.Monk.Windwalker;
	local v63 = {v61.AlgetharPuzzleBox:ID(),v61.BeacontotheBeyond:ID(),v61.Djaruun:ID(),v61.DragonfireBombDispenser:ID(),v61.EruptingSpearFragment:ID(),v61.ManicGrieftorch:ID()};
	local v64;
	local v65;
	local v66;
	local v67 = 43519 - 32408;
	local v68 = 11371 - (197 + 63);
	local v69;
	local v70 = false;
	local v71 = false;
	local v72 = false;
	local v73 = v61.NeltharionsCalltoDominance:IsEquipped() or v61.AshesoftheEmbersoul:IsEquipped() or v61.MirrorofFracturedTomorrows:IsEquipped() or v61.WitherbarksBranch:IsEquipped();
	local v74 = false;
	local v75 = false;
	local v76 = false;
	local v77 = ((v60.Serenity:IsAvailable()) and (1 + 0)) or (1 + 1);
	local v78 = {{v60.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v60.RingOfPeace,"Cast Ring Of Peace (Stun)",function()
		return true;
	end},{v60.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v79 = false;
	local v80 = 0 + 0;
	local v81 = v13:GetEquipment();
	local v82 = (v81[10 + 3] and v20(v81[12 + 1])) or v20(976 - (230 + 746));
	local v83 = (v81[615 - (473 + 128)] and v20(v81[62 - (39 + 9)])) or v20(266 - (38 + 228));
	local v84 = v21.Commons.Everyone;
	local v85 = v21.Commons.Monk;
	local function v86()
		v84.DispellableDebuffs = v25.MergeTable(v84.DispellablePoisonDebuffs, v84.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v86();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v80 = 0 - 0;
		v67 = 11584 - (106 + 367);
		v68 = 981 + 10130;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v77 = ((v60.Serenity:IsAvailable()) and (1863 - (354 + 1508))) or (6 - 4);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if (((1758 + 1241) > (1554 - 398)) and ((1244 - (334 + 910)) == v130)) then
				v81 = v13:GetEquipment();
				v82 = (v81[908 - (92 + 803)] and v20(v81[8 + 5])) or v20(1181 - (1035 + 146));
				v130 = 617 - (230 + 386);
			end
			if (((1366 + 984) > (2665 - (353 + 1157))) and (v130 == (1115 - (53 + 1061)))) then
				v83 = (v81[1649 - (1568 + 67)] and v20(v81[7 + 7])) or v20(0 + 0);
				v73 = v61.NeltharionsCalltoDominance:IsEquipped() or v61.AshesoftheEmbersoul:IsEquipped() or v61.MirrorofFracturedTomorrows:IsEquipped() or v61.WitherbarksBranch:IsEquipped();
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v87()
		return math.floor((v13:EnergyTimeToMaxPredicted() * (25 - 15)) + (0.5 - 0)) / (25 - 15);
	end
	local function v88()
		return math.floor(v13:EnergyPredicted() + 0.5 + 0);
	end
	local function v89(v131)
		return not v13:PrevGCD(1213 - (615 + 597), v131);
	end
	local function v90()
		if (((3605 + 424) <= (7258 - 2405)) and not v60.MarkoftheCrane:IsAvailable()) then
			return 0 + 0;
		end
		local v132 = 0 + 0;
		for v172, v173 in v26(v65) do
			if (v173:DebuffUp(v60.MarkoftheCraneDebuff) or ((284 + 232) > (5333 - (1056 + 843)))) then
				v132 = v132 + (1 - 0);
			end
		end
		return v132;
	end
	local function v91()
		local v133 = 0 - 0;
		local v134;
		local v135;
		local v136;
		while true do
			if (((11609 - 7563) >= (1774 + 1259)) and (v133 == (1978 - (286 + 1690)))) then
				if ((v134 > (911 - (98 + 813))) or ((720 + 1999) <= (3509 - 2062))) then
					v135 = v135 * (1 + 0 + (v134 * v136));
				end
				v135 = v135 * ((508 - (263 + 244)) + ((0.1 + 0) * v60.CraneVortex:TalentRank()));
				v133 = 1690 - (1502 + 185);
			end
			if ((v133 == (1 + 0)) or ((20209 - 16075) < (10416 - 6490))) then
				v135 = 1528 - (629 + 898);
				v136 = 0.18 - 0;
				v133 = 5 - 3;
			end
			if ((v133 == (369 - (12 + 353))) or ((2075 - (1680 + 231)) >= (178 + 2607))) then
				return v135;
			end
			if ((v133 == (0 + 0)) or ((1674 - (212 + 937)) == (1406 + 703))) then
				if (((1095 - (111 + 951)) == (7 + 26)) and not v60.MarkoftheCrane:IsAvailable()) then
					return 27 - (18 + 9);
				end
				v134 = v90();
				v133 = 1 + 0;
			end
			if (((3588 - (31 + 503)) <= (5647 - (595 + 1037))) and (v133 == (1447 - (189 + 1255)))) then
				v135 = v135 * (1 + 0 + ((0.3 - 0) * v27(v13:BuffUp(v60.KicksofFlowingMomentumBuff))));
				v135 = v135 * ((1280 - (1170 + 109)) + ((1817.05 - (348 + 1469)) * v60.FastFeet:TalentRank()));
				v133 = 1293 - (1115 + 174);
			end
		end
	end
	local function v92()
		local v137 = 0 - 0;
		local v138;
		while true do
			if (((2885 - (85 + 929)) < (1984 + 1398)) and (v137 == (1868 - (1151 + 716)))) then
				if (((444 + 849) <= (2114 + 52)) and ((v66 == v138) or (v138 >= (1709 - (95 + 1609))))) then
					return true;
				end
				return false;
			end
			if ((v137 == (0 - 0)) or ((3337 - (364 + 394)) < (112 + 11))) then
				if (not v60.MarkoftheCrane:IsAvailable() or ((253 + 593) >= (488 + 1880))) then
					return true;
				end
				v138 = v90();
				v137 = 1 + 0;
			end
		end
	end
	local function v93()
		local v139 = 0 + 0;
		local v140;
		local v141;
		while true do
			if (((1 + 0) == v139) or ((1510 + 2502) <= (3089 + 269))) then
				for v205, v206 in v26(v64) do
					if (((472 + 1022) <= (3961 - (719 + 237))) and not v206:IsFacingBlacklisted() and not v206:IsUserCycleBlacklisted() and (v206:AffectingCombat() or v206:IsDummy()) and ((v60.ImpTouchofDeath:IsAvailable() and (v206:HealthPercentage() <= (41 - 26))) or (v206:Health() < v13:Health())) and (not v141 or v25.CompareThis("max", v206:Health(), v141))) then
						v140, v141 = v206, v206:Health();
					end
				end
				if ((v140 and (v140 == v14)) or ((2569 + 542) == (5289 - 3155))) then
					if (((6636 - 4281) == (5596 - 3241)) and not v60.TouchofDeath:IsReady()) then
						return nil;
					end
				end
				v139 = 1993 - (761 + 1230);
			end
			if ((v139 == (195 - (80 + 113))) or ((320 + 268) <= (290 + 142))) then
				return v140;
			end
			if (((143 + 4654) >= (15635 - 11740)) and (v139 == (0 + 0))) then
				if (((654 + 2923) == (4820 - (965 + 278))) and not (v60.TouchofDeath:CooldownUp() or v13:BuffUp(v60.HiddenMastersForbiddenTouchBuff))) then
					return nil;
				end
				v140, v141 = nil, nil;
				v139 = 1730 - (1391 + 338);
			end
		end
	end
	local function v94()
		local v142, v143 = nil, nil;
		for v174, v175 in v26(v65) do
			if (((9688 - 5894) > (3595 + 98)) and not v175:IsFacingBlacklisted() and not v175:IsUserCycleBlacklisted() and (v175:AffectingCombat() or v175:IsDummy()) and (not v143 or v25.CompareThis("max", v175:TimeToDie(), v143))) then
				v142, v143 = v175, v175:TimeToDie();
			end
		end
		return v142;
	end
	local function v95(v144)
		return v144:DebuffRemains(v60.MarkoftheCraneDebuff);
	end
	local function v96(v145)
		return v145:DebuffRemains(v60.MarkoftheCraneDebuff) + (v27(v145:DebuffUp(v60.SkyreachExhaustionDebuff)) * (43 - 23));
	end
	local function v97(v146)
		return v146:DebuffRemains(v60.MarkoftheCraneDebuff) + (v27(v14:DebuffDown(v60.SkyreachExhaustionDebuff)) * (7 + 13));
	end
	local function v98(v147)
		return v147:DebuffRemains(v60.MarkoftheCraneDebuff) - (v27(v92()) * (v147:TimeToDie() + (v147:DebuffRemains(v60.SkyreachCritDebuff) * (1428 - (496 + 912)))));
	end
	local function v99(v148)
		return v148:DebuffRemains(v60.FaeExposureDebuff);
	end
	local function v100(v149)
		return v149:TimeToDie();
	end
	local function v101(v150)
		return v150:DebuffRemains(v60.SkyreachCritDebuff);
	end
	local function v102(v151)
		return v151:DebuffRemains(v60.FaeExposureDebuff);
	end
	local function v103(v152)
		return v152:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff);
	end
	local function v104(v153)
		return v153:DebuffRemains(v60.SkyreachExhaustionDebuff) > (180 - 125);
	end
	local function v105()
		if ((v60.SummonWhiteTigerStatue:IsCastable() and v32) or ((315 + 960) == (7772 - 3672))) then
			if ((v59 == "Player") or ((2921 - (1190 + 140)) >= (1722 + 1858))) then
				if (((1701 - (317 + 401)) <= (2757 - (303 + 646))) and v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(17 - 12))) then
					return "summon_white_tiger_statue precombat 2";
				end
			elseif ((v59 == "Cursor") or ((3882 - (1675 + 57)) <= (772 + 425))) then
				if (((9848 - 6079) >= (147 + 1026)) and v24(v62.SummonWhiteTigerStatueCursor)) then
					return "summon_white_tiger_statue precombat 2";
				end
			end
		end
		if (((2462 - (338 + 639)) == (1864 - (320 + 59))) and v60.ExpelHarm:IsReady() and (v13:Chi() < v13:ChiMax())) then
			if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(5 + 3)) or ((4047 - (628 + 104)) <= (3447 - 665))) then
				return "expel_harm precombat 4";
			end
		end
		if ((v60.ChiBurst:IsReady() and not v60.FaelineStomp:IsAvailable()) or ((2767 - (439 + 1452)) >= (4911 - (105 + 1842)))) then
			if (v24(v60.ChiBurst, not v14:IsInRange(182 - 142), true) or ((5443 - 3211) > (12017 - 9520))) then
				return "chi_burst precombat 6";
			end
		end
		if (v60.ChiWave:IsReady() or ((90 + 2020) <= (569 - 237))) then
			if (((1909 + 1777) > (4336 - (274 + 890))) and v22(v60.ChiWave, nil, nil, not v14:IsInRange(35 + 5))) then
				return "chi_wave precombat 8";
			end
		end
	end
	local function v106()
		local v154 = 0 + 0;
		while true do
			if (((1 + 1) == v154) or ((2433 + 2041) < (479 + 341))) then
				if (((6048 - 1769) >= (3701 - (731 + 88))) and v61.Healthstone:IsReady() and v42 and (v13:HealthPercentage() <= v43)) then
					if (v24(v62.Healthstone, nil, nil, true) or ((1623 + 406) >= (2160 + 1361))) then
						return "healthstone defensive 3";
					end
				end
				if ((v39 and (v13:HealthPercentage() <= v41)) or ((437 + 1600) >= (6781 - 2139))) then
					if (((5361 - 3641) < (12956 - 8498)) and (v40 == "Refreshing Healing Potion")) then
						if (v61.RefreshingHealingPotion:IsReady() or ((905 - 469) > (2744 + 277))) then
							if (((4 + 709) <= (153 + 694)) and v24(v62.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((1453 + 701) <= (4189 - (139 + 19))) and (v154 == (1 + 0))) then
				if (((6608 - (1687 + 306)) == (16728 - 12113)) and v60.FortifyingBrew:IsCastable() and v50 and v13:BuffDown(v60.DampenHarmBuff) and (v13:HealthPercentage() <= v51)) then
					if (v24(v60.FortifyingBrew) or ((4944 - (1018 + 136)) == (66 + 434))) then
						return "Fortifying Brew";
					end
				end
				if (((390 - 301) < (1036 - (117 + 698))) and v60.DiffuseMagic:IsCastable() and v56 and (v13:HealthPercentage() <= v57)) then
					if (((2535 - (305 + 176)) >= (190 + 1231)) and v24(v60.DiffuseMagic)) then
						return "Diffuse Magic";
					end
				end
				v154 = 2 + 0;
			end
			if (((1198 - 506) < (2863 + 195)) and (v154 == (0 - 0))) then
				if ((v60.ExpelHarm:IsCastable() and v52 and (v13:HealthPercentage() <= v53)) or ((7358 - 4104) == (2873 - 1218))) then
					if (v24(v60.ExpelHarm) or ((1556 - (159 + 101)) == (23672 - 18762))) then
						return "Expel Harm";
					end
				end
				if (((11665 - 8297) == (1667 + 1701)) and v60.DampenHarm:IsCastable() and v54 and v13:BuffDown(v60.FortifyingBrewBuff) and (v13:HealthPercentage() <= v55)) then
					if (((8424 - 5781) < (7513 - 3698)) and v24(v60.DampenHarm)) then
						return "Dampen Harm";
					end
				end
				v154 = 1 + 0;
			end
		end
	end
	local function v107()
		local v155 = EpicSettings.Settings['TopTrinketCondition'] ~= "Don't Use";
		if (((2179 - (112 + 154)) > (1143 - 650)) and v155 and v61.ManicGrieftorch:IsEquippedAndReady()) then
			local v177 = 31 - (21 + 10);
			while true do
				if (((6474 - (531 + 1188)) > (2930 + 498)) and (v177 == (663 - (96 + 567)))) then
					if (((1993 - 612) <= (980 + 1389)) and (v82:ID() == v61.ManicGrieftorch:ID()) and not v83:HasUseBuff()) then
						if (v24(v62.TrinketTop, not v14:IsInRange(143 - 103)) or ((6538 - (867 + 828)) == (8935 - 4851))) then
							return "manic_grieftorch trinkets 2";
						end
					end
					if (((16930 - 12261) > (810 - 447)) and (v83:ID() == v61.ManicGrieftorch:ID()) and not v82:HasUseBuff()) then
						if (v24(v62.TrinketBottom, not v14:IsInRange(61 - 21)) or ((818 + 1059) >= (5594 - 2456))) then
							return "manic_grieftorch trinkets 2";
						end
					end
					break;
				end
			end
		end
		if (((5513 - (134 + 637)) >= (631 + 2995)) and (v77 == (1158 - (775 + 382)))) then
			local v178 = 0 - 0;
			while true do
				if ((v178 == (608 - (45 + 562))) or ((5402 - (545 + 317)) == (1360 - 444))) then
					if (v155 or ((2182 - (763 + 263)) > (1037 + 3308))) then
						local v218 = 1750 - (512 + 1238);
						while true do
							if (((3831 - (272 + 1322)) < (7959 - 3710)) and (v218 == (1247 - (533 + 713)))) then
								if (((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (58 - (14 + 14))) and v60.Serenity:CooldownDown()) or ((3508 - (499 + 326)) < (40 - 17))) then
									local v230 = 424 - (104 + 320);
									while true do
										if (((2694 - (1929 + 68)) <= (2149 - (1206 + 117))) and (v230 == (0 + 0))) then
											ShouldReturn = v84.HandleTopTrinket(v63, v32, 1632 - (683 + 909), nil);
											if (((3389 - 2284) <= (2186 - 1010)) and ShouldReturn) then
												return ShouldReturn;
											end
											v230 = 778 - (772 + 5);
										end
										if (((4806 - (19 + 1408)) <= (4100 - (134 + 154))) and (v230 == (1 - 0))) then
											ShouldReturn = v84.HandleBottomTrinket(v63, v32, 124 - 84, nil);
											if (ShouldReturn or ((268 + 520) >= (1372 + 244))) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								break;
							end
							if (((2056 - (10 + 192)) <= (3426 - (13 + 34))) and ((1289 - (342 + 947)) == v218)) then
								if (((18766 - 14217) == (6257 - (119 + 1589))) and v61.DragonfireBombDispenser:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff()) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (22 - 12)) and v60.Serenity:CooldownDown()) or (v68 < (13 - 3)))) then
									local v231 = 552 - (545 + 7);
									while true do
										if ((v231 == (0 - 0)) or ((1248 + 1774) >= (4727 - (494 + 1209)))) then
											if (((12886 - 8066) > (3196 - (197 + 801))) and (v82:ID() == v61.DragonfireBombDispenser:ID())) then
												if (v24(v62.TrinketTop, not v14:IsInRange(92 - 46)) or ((5129 - 4068) >= (5845 - (919 + 35)))) then
													return "dragonfire_bomb_dispenser trinkets 14";
												end
											end
											if (((1156 + 208) <= (18049 - 13576)) and (v83:ID() == v61.DragonfireBombDispenser:ID())) then
												if (v24(v62.TrinketBottom, not v14:IsInRange(513 - (369 + 98))) or ((4710 - (400 + 715)) <= (2 + 1))) then
													return "dragonfire_bomb_dispenser trinkets 14";
												end
											end
											break;
										end
									end
								end
								if (((v69 or not v60.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffUp(v60.SerenityBuff)) or (v68 < (11 + 14)) or ((5997 - (744 + 581)) == (1929 + 1923))) then
									ShouldReturn = v84.HandleTopTrinket(v63, v32, 1662 - (653 + 969), nil);
									if (((3046 - 1487) == (3190 - (12 + 1619))) and ShouldReturn) then
										return ShouldReturn;
									end
									ShouldReturn = v84.HandleBottomTrinket(v63, v32, 203 - (103 + 60), nil);
									if (ShouldReturn or ((8634 - 6882) <= (3442 - 2654))) then
										return ShouldReturn;
									end
								end
								v218 = 4 - 3;
							end
						end
					end
					break;
				end
				if (((1662 - (710 + 952)) == v178) or ((5775 - (555 + 1313)) == (162 + 15))) then
					if (((3106 + 364) > (385 + 170)) and v155) then
						local v219 = 1468 - (1261 + 207);
						while true do
							if ((v219 == (252 - (245 + 7))) or ((1719 - (212 + 535)) == (3186 - 2541))) then
								if (((4658 - (905 + 571)) >= (9919 - 7804)) and v61.AlgetharPuzzleBox:IsEquippedAndReady() and (((v69 or not v60.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffDown(v60.SerenityBuff)) or (v68 < (35 - 10)))) then
									local v232 = 0 - 0;
									while true do
										if (((30 + 3863) < (5892 - (522 + 941))) and (v232 == (1511 - (292 + 1219)))) then
											if (((v82:ID() == v61.AlgetharPuzzleBox:ID()) and not v83:HasUseBuff()) or ((3979 - (787 + 325)) < (5788 - 3883))) then
												if (v24(v62.TrinketTop, not v14:IsInRange(36 + 4)) or ((4120 - 2324) >= (4585 - (424 + 110)))) then
													return "algethar_puzzle_box serenity_trinkets 4";
												end
											end
											if (((929 + 690) <= (2228 + 1528)) and (v83:ID() == v61.AlgetharPuzzleBox:ID()) and not v82:HasUseBuff()) then
												if (((120 + 484) == (916 - (33 + 279))) and v24(v62.TrinketBottom, not v14:IsInRange(7 + 33))) then
													return "algethar_puzzle_box serenity_trinkets 4";
												end
											end
											break;
										end
									end
								end
								if ((v61.EruptingSpearFragment:IsEquippedAndReady() and (v13:BuffUp(v60.SerenityBuff))) or ((5837 - (1338 + 15)) == (2323 - (528 + 895)))) then
									local v233 = 0 + 0;
									while true do
										if ((v233 == (1924 - (1606 + 318))) or ((6278 - (298 + 1521)) <= (4784 - 3671))) then
											if (((3942 - (154 + 156)) > (12915 - 9517)) and (v82:ID() == v61.EruptingSpearFragment:ID()) and not v83:HasUseBuff()) then
												if (((8463 - 4381) <= (6032 - (712 + 403))) and v24(v62.TrinketTop, not v14:IsInRange(490 - (168 + 282)))) then
													return "erupting_spear_fragment serenity_trinkets 6";
												end
											end
											if (((9930 - 5098) >= (1368 + 18)) and (v83:ID() == v61.EruptingSpearFragment:ID()) and not v82:HasUseBuff()) then
												if (((1 + 136) == (386 - 249)) and v24(v62.TrinketBottom, not v14:IsInRange(1491 - (1242 + 209)))) then
													return "erupting_spear_fragment serenity_trinkets 6";
												end
											end
											break;
										end
									end
								end
								v219 = 680 - (20 + 659);
							end
							if ((v219 == (1 + 0)) or ((1085 + 485) >= (6313 - 1981))) then
								if ((v61.ManicGrieftorch:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.SerenityBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (61 - 31)) and v60.Serenity:CooldownDown()) or (v68 < (624 - (427 + 192))))) or ((9128 - 5064) <= (673 + 1146))) then
									local v234 = 1947 - (1427 + 520);
									while true do
										if ((v234 == (0 + 0)) or ((18922 - 13936) < (1401 + 173))) then
											if (((5658 - (712 + 520)) > (429 - 257)) and (v82:ID() == v61.ManicGrieftorch:ID())) then
												if (((1932 - (565 + 781)) > (1020 - (35 + 530))) and v24(v62.TrinketTop, not v14:IsInRange(20 + 20))) then
													return "manic_grieftorch serenity_trinkets 8";
												end
											end
											if (((2939 - 2113) == (2204 - (1330 + 48))) and (v83:ID() == v61.ManicGrieftorch:ID())) then
												if (v24(v62.TrinketBottom, not v14:IsInRange(29 + 11)) or ((701 + 3318) > (7754 - 3313))) then
													return "manic_grieftorch serenity_trinkets 8";
												end
											end
											break;
										end
									end
								end
								if (((8854 - 6837) < (5430 - (854 + 315))) and v61.BeacontotheBeyond:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.SerenityBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (96 - 66)) and v60.Serenity:CooldownDown()) or (v68 < (4 + 6)))) then
									if (((4760 - (31 + 13)) > (114 - 34)) and (v82:ID() == v61.BeacontotheBeyond:ID())) then
										if (v24(v62.TrinketTop, not v14:IsInRange(104 - 59)) or ((2618 + 889) == (3835 - (281 + 282)))) then
											return "beacon_to_the_beyond serenity_trinkets 8";
										end
									end
									if ((v83:ID() == v61.BeacontotheBeyond:ID()) or ((2453 - 1577) >= (1542 + 1533))) then
										if (((5301 - (216 + 733)) > (4401 - (137 + 1710))) and v24(v62.TrinketBottom, not v14:IsInRange(125 - 80))) then
											return "beacon_to_the_beyond serenity_trinkets 8";
										end
									end
								end
								break;
							end
						end
					end
					if ((v35 and v61.Djaruun:IsEquippedAndReady() and (((v60.FistsofFury:CooldownRemains() < (540 - (100 + 438))) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (1375 - (205 + 1160)))) or (v68 < (9 + 3)))) or ((2244 + 2162) < (5348 - (535 + 770)))) then
						if (v24(v62.Djaruun, not v14:IsInRange(1 + 7)) or ((1037 + 852) >= (5377 - (211 + 1783)))) then
							return "djaruun_pillar_of_the_elder_flame serenity_trinkets 12";
						end
					end
					v178 = 1 + 0;
				end
			end
		else
			if (((3321 - (1236 + 193)) <= (3644 - (793 + 117))) and v155) then
				local v207 = 1892 - (1607 + 285);
				while true do
					if (((2783 - (747 + 113)) < (4194 - (80 + 1896))) and ((0 - 0) == v207)) then
						if (((3844 - 1671) > (355 + 24)) and v61.AlgetharPuzzleBox:IsEquippedAndReady() and (((v69 or not v60.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffDown(v60.StormEarthAndFireBuff)) or (v68 < (58 - 33)))) then
							if ((v82:ID() == v61.AlgetharPuzzleBox:ID()) or ((1369 + 1222) == (10079 - 6670))) then
								if (((2635 + 1879) > (1011 + 2313)) and v24(v62.TrinketTop)) then
									return "algethar_puzzle_box sef_trinkets 16";
								end
							end
							if ((v83:ID() == v61.AlgetharPuzzleBox:ID()) or ((497 - 289) >= (5282 - (246 + 208)))) then
								if (v24(v62.TrinketBottom) or ((3475 - (614 + 1278)) > (1769 + 1798))) then
									return "algethar_puzzle_box sef_trinkets 16";
								end
							end
						end
						if ((v61.EruptingSpearFragment:IsEquippedAndReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or ((1627 - (249 + 65)) == (1809 - 1015))) then
							local v221 = 1275 - (726 + 549);
							while true do
								if (((2143 + 1031) > (4326 - (916 + 508))) and (v221 == (0 - 0))) then
									if (((2650 + 1470) <= (4583 - (140 + 183))) and (v82:ID() == v61.EruptingSpearFragment:ID())) then
										if (v24(v62.TrinketTop, not v14:IsInRange(29 + 11)) or ((1447 - (297 + 267)) > (3071 + 1707))) then
											return "erupting_spear_fragment sef_trinkets 18";
										end
									end
									if ((v83:ID() == v61.EruptingSpearFragment:ID()) or ((3962 - (37 + 305)) >= (6157 - (323 + 943)))) then
										if (((1696 + 2562) > (1225 - 288)) and v24(v62.TrinketBottom, not v14:IsInRange(1575 - (394 + 1141)))) then
											return "erupting_spear_fragment sef_trinkets 18";
										end
									end
									break;
								end
							end
						end
						v207 = 1 + 0;
					end
					if ((v207 == (1 + 0)) or ((331 + 4538) < (1154 - 248))) then
						if ((v61.ManicGrieftorch:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.StormEarthAndFireBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (44 - 14))) or (v68 < (5 + 0)))) or ((1128 + 97) > (4757 - (87 + 442)))) then
							local v222 = 805 - (13 + 792);
							while true do
								if (((3080 + 248) > (930 + 1308)) and (v222 == (0 + 0))) then
									if (((5704 - (1231 + 634)) > (3171 - (1362 + 404))) and (v82:ID() == v61.ManicGrieftorch:ID())) then
										if (v24(v62.TrinketTop) or ((3640 - 2347) <= (359 + 148))) then
											return "manic_grieftorch sef_trinkets 20";
										end
									end
									if ((v83:ID() == v61.ManicGrieftorch:ID()) or ((8128 - 5232) < (1821 - (660 + 356)))) then
										if (((3324 - 1008) == (2091 + 225)) and v24(v62.TrinketBottom)) then
											return "manic_grieftorch sef_trinkets 20";
										end
									end
									break;
								end
							end
						end
						if ((v61.BeacontotheBeyond:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.StormEarthAndFireBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (1980 - (1111 + 839)))) or (v68 < (961 - (496 + 455))))) or ((3268 - (66 + 632)) == (2444 - 911))) then
							local v223 = 1136 - (441 + 695);
							while true do
								if ((v223 == (0 - 0)) or ((1655 - 772) == (6961 - 5501))) then
									if ((v82:ID() == v61.BeacontotheBeyond:ID()) or ((2807 + 1812) <= (2837 - (286 + 1552)))) then
										if (v24(v62.TrinketTop, not v14:IsInRange(1322 - (1016 + 261))) or ((4730 - (708 + 612)) > (11429 - 7313))) then
											return "beacon_to_the_beyond sef_trinkets 22";
										end
									end
									if ((v83:ID() == v61.BeacontotheBeyond:ID()) or ((386 + 517) >= (3438 - (113 + 266)))) then
										if (v24(v62.TrinketBottom, not v14:IsInRange(1215 - (979 + 191))) or ((7047 - 3071) < (4592 - (339 + 1396)))) then
											return "beacon_to_the_beyond sef_trinkets 22";
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
			if (((1450 + 3480) > (1771 + 536)) and v35 and v61.Djaruun:IsEquippedAndReady() and (((v60.FistsofFury:CooldownRemains() < (3 - 1)) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (10 + 0))) or (v68 < (3 + 9)))) then
				if (v24(v62.Djaruun, not v14:IsInRange(355 - (187 + 160))) or ((9213 - 5167) < (4455 - 3164))) then
					return "djaruun_pillar_of_the_elder_flame sef_trinkets 24";
				end
			end
			if (v155 or ((625 + 3616) == (11113 - 7568))) then
				local v208 = 0 + 0;
				while true do
					if ((v208 == (1 + 0)) or ((7555 - 3507) > (4560 - (56 + 272)))) then
						if ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (18 + 12)) or ((1442 + 308) >= (8334 - 4861))) then
							local v224 = 0 + 0;
							while true do
								if (((3806 - (455 + 185)) == (3954 - (757 + 31))) and (v224 == (1999 - (762 + 1237)))) then
									ShouldReturn = v84.HandleTopTrinket(v63, v32, 82 - 42, nil);
									if (((2032 - (265 + 4)) < (9424 - 5700)) and ShouldReturn) then
										return ShouldReturn;
									end
									v224 = 1 + 0;
								end
								if (((106 - 49) <= (7637 - 4914)) and (v224 == (1 + 0))) then
									ShouldReturn = v84.HandleBottomTrinket(v63, v32, 110 - 70, nil);
									if (ShouldReturn or ((4475 - 2405) == (865 - 422))) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						break;
					end
					if ((v208 == (1734 - (1691 + 43))) or ((2582 + 123) == (4365 - 2972))) then
						if ((v61.DragonfireBombDispenser:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff()) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (3 + 7))) or (v68 < (36 - 26)))) or ((4777 - (127 + 49)) < (1741 - (281 + 1399)))) then
							if ((v82:ID() == v61.DragonfireBombDispenser:ID()) or ((3049 - (184 + 1475)) >= (6032 - 1288))) then
								if (v24(v62.TrinketTop, not v14:IsInRange(107 - 61)) or ((4505 - 2502) > (2384 + 1450))) then
									return "dragonfire_bomb_dispenser sef_trinkets 26";
								end
							end
							if ((v83:ID() == v61.DragonfireBombDispenser:ID()) or ((130 + 26) > (5204 - (260 + 1031)))) then
								if (((1372 - (313 + 864)) == (887 - (655 + 37))) and v24(v62.TrinketBottom, not v14:IsInRange(40 + 6))) then
									return "dragonfire_bomb_dispenser sef_trinkets 26";
								end
							end
						end
						if (((5246 - 2141) >= (4028 - 2232)) and (((v69 or not v60.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffUp(v60.StormEarthAndFireBuff)) or (v68 < (10 + 15)))) then
							ShouldReturn = v84.HandleTopTrinket(v63, v32, 31 + 9, nil);
							if (((8280 - 3901) >= (2901 - (383 + 387))) and ShouldReturn) then
								return ShouldReturn;
							end
							ShouldReturn = v84.HandleBottomTrinket(v63, v32, 12 + 28, nil);
							if (((263 + 3581) >= (6323 - 4280)) and ShouldReturn) then
								return ShouldReturn;
							end
						end
						v208 = 1 + 0;
					end
				end
			end
		end
	end
	local function v108()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (510 - (304 + 206))) or ((3457 - (182 + 43)) <= (3506 - (264 + 511)))) then
				if (((729 + 4176) == (11901 - 6996)) and v60.SummonWhiteTigerStatue:IsCastable() and v32) then
					if ((v59 == "Player") or ((5117 - (128 + 853)) >= (6113 - (1635 + 67)))) then
						if (v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(1 + 4)) or ((1108 + 1850) == (4214 - (131 + 66)))) then
							return "summon_white_tiger_statue opener 2";
						end
					elseif (((4309 - 3081) >= (3989 - 3176)) and (v59 == "Cursor")) then
						if (v24(v62.SummonWhiteTigerStatueCursor) or ((1220 + 2235) > (2393 + 1657))) then
							return "summon_white_tiger_statue opener 2";
						end
					end
				end
				if (((371 - 128) == (409 - 166)) and v60.ExpelHarm:IsReady() and v60.ChiBurst:IsAvailable() and (v13:ChiDeficit() >= (1608 - (306 + 1299)))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((697 - 426) > (2361 - (671 + 118)))) then
						return "expel_harm opener 4";
					end
				end
				v156 = 3 - 2;
			end
			if (((2815 - (73 + 3)) < (9304 - 6011)) and (v156 == (9 - 7))) then
				if ((v60.ChiWave:IsReady() and (v13:ChiDeficit() >= (4 - 2))) or ((5697 - (1668 + 87)) < (98 + 1036))) then
					if (v22(v60.ChiWave, nil, nil, not v14:IsInRange(1939 - (296 + 1603))) or ((2799 - (79 + 27)) == (3960 + 1013))) then
						return "chi_wave opener 10";
					end
				end
				if (((3153 - (700 + 307)) == (1442 + 704)) and v60.ExpelHarm:IsReady()) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(1807 - (1477 + 322))) or ((712 + 1532) == (7426 - 4202))) then
						return "expel_harm opener 12";
					end
				end
				v156 = 3 + 0;
			end
			if ((v156 == (9 - 6)) or ((3708 + 1196) <= (7799 - 5883))) then
				if (((237 - 147) <= (508 + 557)) and v60.ChiBurst:IsReady() and (v13:Chi() > (2 - 1)) and (v13:ChiDeficit() >= (2 - 0))) then
					if (((9692 - 4890) == (6588 - (20 + 1766))) and v24(v60.ChiBurst, not v14:IsInRange(77 - 37), true)) then
						return "chi_burst opener 14";
					end
				end
				break;
			end
			if ((v156 == (810 - (88 + 721))) or ((2255 + 25) <= (36 + 475))) then
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 1)) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) or ((569 + 1107) <= (1187 - 724))) then
					if (((7550 - 3681) == (4306 - (93 + 344))) and v22(v60.FaelineStomp, nil, nil, not v14:IsInMeleeRange(1218 - (960 + 253)))) then
						return "tiger_palm opener 6";
					end
				end
				if (((257 + 901) <= (7758 - 5145)) and v60.ExpelHarm:IsReady() and v60.ChiBurst:IsAvailable() and (v13:Chi() == (8 - 5))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(1424 - (74 + 1342))) or ((601 + 1763) <= (2473 - (33 + 441)))) then
						return "expel_harm opener 8";
					end
				end
				v156 = 5 - 3;
			end
		end
	end
	local function v109()
		if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and (v66 > (1422 - (64 + 1355)))) or ((7190 - 2268) < (205 - (5 + 6)))) then
			if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(2 + 7)) or ((524 + 1567) < (477 - (369 + 77)))) then
				return "strike_of_the_windlord bdb_setup 2";
			end
		end
		if ((v60.BonedustBrew:IsCastable() and v92() and (v13:Chi() >= (1 + 3))) or ((3168 - (438 + 300)) >= (5166 - (50 + 244)))) then
			if ((v58 == "Player") or ((5971 - (95 + 1106)) < (3273 - 1538))) then
				if (v24(v62.BonedustBrewPlayer, not v14:IsInRange(39 - 31)) or ((6335 - (1741 + 155)) <= (6762 - 4412))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif ((v58 == "Confirmation") or ((6721 - 2242) < (9363 - 4897))) then
				if (((1258 + 1289) > (563 + 662)) and v24(v60.BonedustBrew, not v14:IsInRange(22 + 18))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif (((11233 - 6562) > (6696 - 4022)) and (v58 == "Cursor")) then
				if (v24(v62.BonedustBrewCursor, not v14:IsInRange(1817 - (1263 + 514))) or ((4193 - (73 + 424)) < (8758 - 5431))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif ((v58 == "Enemy under Cursor") or ((4850 - (93 + 215)) == (10367 - 7397))) then
				if (((2187 - (1756 + 179)) <= (3656 - (550 + 1129))) and v16 and v16:Exists() and v13:CanAttack(v16)) then
					if (v24(v62.BonedustBrewCursor, not v14:IsInRange(147 - (57 + 50))) or ((2065 - (30 + 599)) == (934 + 2841))) then
						return "bonedust_brew bdb_setup 4";
					end
				end
			end
		end
		if ((v60.RisingSunKick:IsReady() and v89(v60.RisingSunKick) and (v13:Chi() >= (6 - 1)) and v60.WhirlingDragonPunch:IsAvailable()) or ((2536 - (794 + 124)) < (119 + 811))) then
			if (((648 + 4075) > (8359 - 4206)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1932 - (1299 + 628)))) then
				return "rising_sun_kick bdb_setup 10";
			end
		end
		if ((v60.RisingSunKick:IsReady() and v89(v60.RisingSunKick) and (v66 >= (3 - 1)) and v60.WhirlingDragonPunch:IsAvailable()) or ((10136 - 6482) >= (4270 + 384))) then
			if (((2763 - 1812) <= (2941 - (335 + 1110))) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "rising_sun_kick bdb_setup 12";
			end
		end
		if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and not v60.WhirlingDragonPunch:IsAvailable() and not v92()) or ((5716 - 3980) == (1018 - 447))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(337 - (268 + 64))) or ((593 + 303) > (6047 - (243 + 1035)))) then
				return "blackout_kick bdb_setup 8";
			end
		end
		if ((v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:ChiDeficit() >= (4 - 2)) and v13:BuffUp(v60.StormEarthAndFireBuff)) or ((4854 - 3809) <= (4330 - 3310))) then
			if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(4 + 1)) or ((1022 + 138) <= (404 - 76))) then
				return "tiger_palm bdb_setup 6";
			end
		end
	end
	local function v110()
		if (((3908 - (90 + 10)) > (3728 - (209 + 595))) and v60.SummonWhiteTigerStatue:IsCastable() and (v60.InvokeXuenTheWhiteTiger:CooldownUp() or (v66 > (809 - (603 + 202))) or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (31 + 19)) or (v68 <= (97 - 67)))) then
			if (((1900 + 1991) < (13938 - 9019)) and (v59 == "Player")) then
				if (v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(1 + 4)) or ((6188 - 3954) <= (6296 - 4794))) then
					return "summon_white_tiger_statue cd_sef 2";
				end
			elseif ((v59 == "Cursor") or ((2791 - (174 + 105)) < (1451 - 1019))) then
				if (v24(v62.SummonWhiteTigerStatueCursor) or ((2761 - (532 + 381)) == (733 + 132))) then
					return "summon_white_tiger_statue cd_sef 2";
				end
			end
		end
		if ((v60.InvokeXuenTheWhiteTiger:IsCastable() and ((not v71 and (v14:TimeToDie() > (864 - (137 + 702))) and v60.BonedustBrew:IsAvailable() and (v60.BonedustBrew:CooldownRemains() <= (13 - 8)) and (((v66 < (1 + 2)) and (v13:Chi() >= (10 - 7))) or ((v66 >= (1889 - (1819 + 67))) and (v13:Chi() >= (2 + 0))))) or (v68 < (8 + 17)))) or ((6039 - (259 + 1098)) <= (3129 + 1412))) then
			if (v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(7 + 33)) or ((172 + 2854) >= (13652 - 9606))) then
				return "invoke_xuen_the_white_tiger cd_sef 4";
			end
		end
		if (((750 + 1258) > (622 + 16)) and v60.InvokeXuenTheWhiteTiger:IsCastable() and (((v14:TimeToDie() > (116 - 91)) and (v68 > (1826 - (667 + 1039)))) or ((v68 < (1079 - (274 + 745))) and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (2 + 0)) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (23 + 32))) and v60.Serenity:CooldownUp() and (v66 < (433 - (288 + 142)))) or v13:BloodlustUp() or (v68 < (1329 - (301 + 1005))))) then
			if (((800 + 975) <= (7850 - 4617)) and v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(1913 - (674 + 1199)))) then
				return "invoke_xuen_the_white_tiger cd_sef 6";
			end
		end
		if ((v60.StormEarthAndFire:IsCastable() and v60.BonedustBrew:IsAvailable() and (((v68 < (27 + 3)) and (v60.BonedustBrew:CooldownRemains() < (3 + 1)) and (v13:Chi() >= (11 - 7))) or v13:BuffUp(v60.BonedustBrewBuff) or (not v92() and (v66 >= (12 - 9)) and (v60.BonedustBrew:CooldownRemains() <= (1 + 1)) and (v13:Chi() >= (447 - (92 + 353))))) and (v69 or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > v60.StormEarthAndFire:FullRechargeTime()))) or ((4091 + 452) == (4952 - 2955))) then
			if (v22(v60.StormEarthAndFire, nil) or ((5871 - 2769) < (2068 - 1340))) then
				return "storm_earth_and_fire cd_sef 8";
			end
		end
		if (((189 + 156) == (616 - 271)) and v60.StormEarthAndFire:IsCastable() and not v60.BonedustBrew:IsAvailable() and (v69 or ((v14:TimeToDie() > (33 - 18)) and (v60.StormEarthAndFire:FullRechargeTime() < v60.InvokeXuenTheWhiteTiger:CooldownRemains())))) then
			if (v22(v60.StormEarthAndFire, nil) or ((12274 - 9447) < (326 + 52))) then
				return "storm_earth_and_fire cd_sef 9";
			end
		end
		if ((v60.BonedustBrew:IsCastable() and ((v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.StormEarthAndFireBuff) and (v13:BuffRemains(v60.StormEarthAndFireBuff) < (21 - 10)) and v92()) or (v13:BuffDown(v60.BonedustBrewBuff) and (v68 < (295 - (34 + 231))) and (v68 > (1327 - (930 + 387))) and v92() and (v13:Chi() >= (4 + 0))) or (v68 < (7 + 3)) or (v14:DebuffDown(v60.SkyreachExhaustionDebuff) and (v66 >= (10 - 6)) and (v91() >= (699 - (389 + 308)))) or (v69 and v92() and (v66 >= (9 - 5))))) or ((7908 - 4432) < (7245 - 4648))) then
			if (((1223 + 1856) < (5116 - (125 + 197))) and (v58 == "Player")) then
				if (((5851 - (339 + 658)) > (10866 - 6402)) and v24(v62.BonedustBrewPlayer, not v14:IsInRange(16 - 8))) then
					return "bonedust_brew cd_sef 10";
				end
			elseif ((v58 == "Confirmation") or ((6260 - (743 + 605)) == (3443 + 315))) then
				if (((13 + 113) <= (13020 - 9538)) and v24(v60.BonedustBrew, not v14:IsInRange(123 - 83))) then
					return "bonedust_brew cd_sef 10";
				end
			elseif ((v58 == "Cursor") or ((1570 + 804) == (4623 - (197 + 52)))) then
				if (((3390 - 1815) == (3587 - 2012)) and v24(v62.BonedustBrewCursor, not v14:IsInRange(25 + 15))) then
					return "bonedust_brew cd_sef 10";
				end
			elseif ((v58 == "Enemy under Cursor") or ((1187 + 1047) == (2595 - 1140))) then
				if ((v16 and v16:Exists() and v13:CanAttack(v16)) or ((3591 - 2524) > (4058 - 2279))) then
					if (((837 + 1324) >= (1306 - 372)) and v24(v62.BonedustBrewCursor, not v14:IsInRange(1137 - (97 + 1000)))) then
						return "bonedust_brew cd_sef 10";
					end
				end
			end
		end
		if (((5740 - 4128) == (3457 - (143 + 1702))) and v13:BuffDown(v60.BonedustBrewBuff) and v60.BonedustBrew:IsAvailable() and (v60.BonedustBrew:CooldownRemains() <= (3 - 1)) and (((v68 > (429 - (40 + 329))) and ((v60.StormEarthAndFire:Charges() > (0 + 0)) or (v60.StormEarthAndFire:CooldownRemains() > (4 + 6))) and (v69 or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (15 - 5)) or v71)) or ((v69 or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (2 + 11))) and ((v60.StormEarthAndFire:Charges() > (65 - (9 + 56))) or (v60.StormEarthAndFire:CooldownRemains() > (597 - (531 + 53))) or v13:BuffUp(v60.StormEarthAndFireBuff))))) then
			local v179 = 0 + 0;
			local v180;
			while true do
				if (((5125 - (89 + 684)) >= (1967 + 866)) and (v179 == (0 + 0))) then
					v180 = v109();
					if (v180 or ((891 + 2331) < (5221 - 2148))) then
						return v180;
					end
					break;
				end
			end
		end
		if (((550 + 194) <= (2503 + 439)) and v60.StormEarthAndFire:IsCastable() and ((v68 < (633 - (238 + 375))) or ((v60.StormEarthAndFire:Charges() == (2 + 0)) and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > v60.StormEarthAndFire:FullRechargeTime()) and (v60.FistsofFury:CooldownRemains() <= (12 - 3)) and (v13:Chi() >= (2 + 0)) and (v60.WhirlingDragonPunch:CooldownRemains() <= (34 - 22))))) then
			if (v22(v60.StormEarthAndFire, nil) or ((4829 - 2996) <= (3633 - 2311))) then
				return "storm_earth_and_fire cd_sef 12";
			end
		end
		if ((v60.TouchofDeath:CooldownUp() and v49) or ((7524 - 4057) <= (3910 - 2855))) then
			local v181 = 0 - 0;
			local v182;
			local v183;
			while true do
				if (((3276 + 265) == (288 + 3253)) and (v181 == (0 + 0))) then
					v182 = v13:IsInParty() and not v13:IsInRaid();
					v183 = nil;
					v181 = 463 - (428 + 34);
				end
				if ((v181 == (1 + 0)) or ((5567 - 2010) >= (8766 - 4763))) then
					if ((v30 and v31) or ((1574 - 917) >= (2586 - (223 + 695)))) then
						v183 = v93();
					elseif (v60.TouchofDeath:IsReady() or ((3186 - 2159) > (4369 - (329 + 182)))) then
						v183 = v14;
					end
					if (v183 or ((604 + 3050) < (770 - 320))) then
						if (((254 + 1637) < (372 + 4081)) and ((v182 and v13:BuffDown(v60.SerenityBuff) and v89(v60.TouchofDeath) and (v183:Health() < v13:Health())) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) < (2 + 0)) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) > v183:TimeToDie()))) then
							if ((v183:GUID() == v14:GUID()) or ((6688 - 3548) < (2882 - 753))) then
								if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(1205 - (177 + 1023))) or ((5155 - 2600) < (341 + 899))) then
									return "touch_of_death cd_sef main-target 14";
								end
							elseif ((((GetTime() - v84.LastTargetSwap) * (2178 - 1178)) >= v34) or ((6192 - (120 + 1345)) <= (5059 - (8 + 329)))) then
								v84.LastTargetSwap = GetTime();
								if (((865 - (19 + 106)) < (17617 - 12680)) and v24(v23(139 - 39))) then
									return "touch_of_death cd_sef off-target 14";
								end
							end
						end
					end
					v181 = 2 + 0;
				end
				if (((10769 - 7111) >= (725 - 445)) and (v181 == (7 - 5))) then
					if ((v183 and v89(v60.TouchofDeath)) or ((1868 - 983) >= (274 + 757))) then
						if (((5057 - (957 + 546)) >= (2217 - 1692)) and v182) then
							if (((913 + 1501) <= (747 + 2225)) and ((v183:TimeToDie() > (23 + 37)) or v183:DebuffUp(v60.BonedustBrewDebuff) or (v68 < (5 + 5)))) then
								if (((4232 - (227 + 476)) <= (7337 - 3799)) and (v183:GUID() == v14:GUID())) then
									if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(8 - 3)) or ((4104 - 1243) < (835 - 377))) then
										return "touch_of_death cd_sef main-target 16";
									end
								elseif (((2301 - 584) <= (5479 - (166 + 788))) and (((GetTime() - v84.LastTargetSwap) * (1986 - (21 + 965))) >= v34)) then
									local v237 = 696 - (127 + 569);
									while true do
										if ((v237 == (0 + 0)) or ((1028 + 2150) <= (551 + 973))) then
											v84.LastTargetSwap = GetTime();
											if (((6177 - 1923) > (240 + 130)) and v24(v23(256 - 156))) then
												return "touch_of_death cd_sef off-target 16";
											end
											break;
										end
									end
								end
							end
						elseif ((v183:GUID() == v14:GUID()) or ((814 + 821) == (417 + 1360))) then
							if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(1297 - (1162 + 130))) or ((7097 - 3759) >= (2792 + 1201))) then
								return "touch_of_death cd_sef main-target 18";
							end
						elseif (((2581 - 1427) <= (2411 - (889 + 47))) and (((GetTime() - v84.LastTargetSwap) * (656 + 344)) >= v34)) then
							local v236 = 1264 - (1153 + 111);
							while true do
								if (((0 - 0) == v236) or ((1409 + 1201) < (635 + 595))) then
									v84.LastTargetSwap = GetTime();
									if (v24(v23(11 + 89)) or ((678 + 770) == (411 + 2672))) then
										return "touch_of_death cd_sef off-target 18";
									end
									break;
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((5912 - 2773) > (635 + 281)) and v60.TouchofKarma:IsCastable() and v48 and ((v60.InvokeXuenTheWhiteTiger:IsAvailable() and ((v68 > (186 - (23 + 73))) or v69 or v71 or (v68 < (301 - (26 + 259))))) or (not v60.InvokeXuenTheWhiteTiger:IsAvailable() and ((v68 > (70 + 89)) or v71)))) then
			if (((4611 - 1657) == (10364 - 7410)) and v22(v60.TouchofKarma, nil, nil, not v14:IsInRange(1649 - (1094 + 535)))) then
				return "touch_of_karma cd_sef 20";
			end
		end
		if (((14 + 103) <= (4768 - (1554 + 322))) and v60.AncestralCall:IsCastable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (1455 - (989 + 436))) or v71 or (v68 < (1198 - (816 + 362))))) then
			if (v22(v60.AncestralCall, nil) or ((868 - 415) > (11728 - 7066))) then
				return "ancestral_call cd_sef 22";
			end
		end
		if (((4866 - 3546) > (1090 - 495)) and v60.BloodFury:IsCastable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (70 - 40)) or v71 or (v68 < (87 - 67)))) then
			if (v22(v60.BloodFury, nil) or ((41 + 3158) < (1353 - (86 + 677)))) then
				return "blood_fury cd_sef 24";
			end
		end
		if ((v60.Fireblood:IsCastable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (19 + 11)) or v71 or (v68 < (1 + 9)))) or ((5819 - (263 + 763)) < (15 + 15))) then
			if (v22(v60.Fireblood, nil) or ((2554 - (649 + 209)) <= (4732 - 3673))) then
				return "fireblood cd_sef 26";
			end
		end
		if (((3074 - (643 + 88)) == (4112 - (54 + 1715))) and v60.Berserking:IsCastable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (117 - 87)) or v71 or (v68 < (42 - 27)))) then
			if (v22(v60.Berserking, nil) or ((2129 - 1086) > (2885 + 706))) then
				return "berserking cd_sef 28";
			end
		end
		if ((v60.BagofTricks:IsCastable() and (v13:BuffDown(v60.StormEarthAndFireBuff))) or ((284 + 2606) >= (15470 - 11391))) then
			if (((5857 - (132 + 1251)) <= (4750 + 20)) and v22(v60.BagofTricks, nil)) then
				return "bag_of_tricks cd_sef 30";
			end
		end
		if (v60.LightsJudgment:IsCastable() or ((12245 - 7303) == (3023 + 880))) then
			if (v22(v60.LightsJudgment, nil) or ((706 - (185 + 273)) > (1176 + 3669))) then
				return "lights_judgment cd_sef 32";
			end
		end
	end
	local function v111()
		local v157 = 0 - 0;
		while true do
			if (((590 + 979) == (2793 - (361 + 863))) and ((0 - 0) == v157)) then
				if ((v60.SummonWhiteTigerStatue:IsCastable() and (v60.InvokeXuenTheWhiteTiger:CooldownUp() or (v66 > (1331 - (443 + 884))) or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (119 - 69)) or (v68 <= (7 + 23)))) or ((6934 - 2007) <= (2563 + 658))) then
					if ((v59 == "Player") or ((1287 + 493) > (6543 - 3756))) then
						if (v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(752 - (16 + 731))) or ((1931 + 2006) <= (637 + 593))) then
							return "summon_white_tiger_statue cd_serenity 2";
						end
					elseif ((v59 == "Cursor") or ((2025 + 612) < (2466 - (527 + 233)))) then
						if (v24(v62.SummonWhiteTigerStatueCursor) or ((1843 + 826) <= (5487 - 3078))) then
							return "summon_white_tiger_statue cd_serenity 2";
						end
					end
				end
				if ((v60.InvokeXuenTheWhiteTiger:IsCastable() and ((not v71 and v60.BonedustBrew:IsAvailable() and (v60.BonedustBrew:CooldownRemains() <= (5 + 0)) and (v14:TimeToDie() > (1810 - (1107 + 678)))) or v13:BloodlustUp() or (v68 < (21 + 4)))) or ((1209 + 192) > (4746 - (4 + 46)))) then
					if (v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(150 - 110)) or ((6031 - 2751) < (874 + 447))) then
						return "invoke_xuen_the_white_tiger cd_serenity 4";
					end
				end
				v157 = 1 - 0;
			end
			if (((7890 - 2963) >= (3699 - (1262 + 134))) and ((2 - 1) == v157)) then
				if (((863 + 2599) >= (745 + 287)) and v60.InvokeXuenTheWhiteTiger:IsCastable() and (((v14:TimeToDie() > (820 - (383 + 412))) and (v68 > (94 + 26))) or ((v68 < (5 + 55)) and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (1 + 1)) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (19 + 36))) and v60.Serenity:CooldownUp() and (v66 < (3 + 0))) or v13:BloodlustUp() or (v68 < (30 - 7)))) then
					if (v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(35 + 5)) or ((3162 - 2085) >= (2719 - 708))) then
						return "invoke_xuen_the_white_tiger cd_serenity 6";
					end
				end
				if (((4246 - 2703) < (670 + 1745)) and v60.BonedustBrew:IsCastable() and (v13:BuffUp(v60.InvokersDelightBuff) or (v13:BuffDown(v60.BonedustBrewBuff) and (v60.Serenity:CooldownUp() or (v60.Serenity:CooldownRemains() > (722 - (667 + 40))) or ((v68 < (1340 - (436 + 874))) and (v68 > (1616 - (762 + 844)))))) or (v68 < (17 - 7)))) then
					if ((v58 == "Player") or ((10185 - 5741) < (15 + 2000))) then
						if (v24(v62.BonedustBrewPlayer, not v14:IsInRange(1 + 7)) or ((4676 - (209 + 267)) == (4278 - 1946))) then
							return "bonedust_brew cd_serenity 8";
						end
					elseif ((v58 == "Confirmation") or ((3594 - 2316) >= (3027 - (1611 + 100)))) then
						if (((818 + 264) == (1866 - (14 + 770))) and v24(v60.BonedustBrew, not v14:IsInRange(1824 - (1165 + 619)))) then
							return "bonedust_brew cd_serenity 8";
						end
					elseif (((2083 - 755) <= (5259 - (229 + 152))) and (v58 == "Cursor")) then
						if (((4281 - (107 + 87)) >= (2463 - 1108)) and v24(v62.BonedustBrewCursor, not v14:IsInRange(17 + 23))) then
							return "bonedust_brew cd_serenity 8";
						end
					elseif ((v58 == "Enemy under Cursor") or ((457 + 133) > (22205 - 17555))) then
						if ((v16 and v16:Exists() and v13:CanAttack(v16)) or ((14503 - 10729) <= (3348 + 319))) then
							if (((1284 - (13 + 1)) < (2131 + 15)) and v24(v62.BonedustBrewCursor, not v14:IsInRange(26 + 14))) then
								return "bonedust_brew cd_serenity 8";
							end
						end
					end
				end
				v157 = 1060 - (987 + 71);
			end
			if (((12991 - 8428) >= (71 - 15)) and (v157 == (703 - (514 + 185)))) then
				if (v13:BuffUp(v60.SerenityBuff) or (v68 < (3 + 17)) or ((884 - 438) == (2393 - 1771))) then
					local v209 = 1504 - (771 + 733);
					while true do
						if (((4174 - 2105) > (2179 - 1170)) and ((1167 - (407 + 760)) == v209)) then
							if (((8 + 4) < (116 + 4092)) and v60.AncestralCall:IsCastable()) then
								if (v22(v60.AncestralCall, nil) or ((2271 + 719) <= (4834 - (169 + 1685)))) then
									return "ancestral_call cd_serenity 20";
								end
							end
							if (v60.BloodFury:IsCastable() or ((468 + 2107) >= (4666 - (41 + 350)))) then
								if (v22(v60.BloodFury, nil) or ((9934 - 6308) <= (3702 - 2396))) then
									return "blood_fury cd_serenity 22";
								end
							end
							v209 = 4 - 3;
						end
						if (((3168 - 1800) < (2398 + 1382)) and (v209 == (889 - (790 + 97)))) then
							if (v60.BagofTricks:IsCastable() or ((14408 - 11239) == (662 + 1611))) then
								if (((840 + 1641) <= (3524 - (235 + 10))) and v22(v60.BagofTricks, nil)) then
									return "bag_of_tricks cd_serenity 28";
								end
							end
							break;
						end
						if ((v209 == (1 + 0)) or ((2127 - 1064) <= (2060 - (887 + 296)))) then
							if (((3359 - (512 + 533)) == (3738 - (662 + 762))) and v60.Fireblood:IsCastable()) then
								if (((1601 - (334 + 343)) >= (1598 - 1121)) and v22(v60.Fireblood, nil)) then
									return "fireblood cd_serenity 24";
								end
							end
							if (((2302 - (198 + 291)) <= (103 + 3675)) and v60.Berserking:IsCastable()) then
								if (((4724 - (141 + 433)) == (19469 - 15319)) and v22(v60.Berserking, nil)) then
									return "berserking cd_serenity 26";
								end
							end
							v209 = 2 + 0;
						end
					end
				end
				if (((1209 - (227 + 550)) <= (7535 - 4528)) and v60.LightsJudgment:IsCastable()) then
					if (v22(v60.LightsJudgment, nil) or ((1120 - 712) > (2824 - (72 + 31)))) then
						return "lights_judgment cd_serenity 30";
					end
				end
				break;
			end
			if ((v157 == (351 - (89 + 259))) or ((2989 + 429) < (2195 + 302))) then
				if (((341 + 1394) < (4460 - 2291)) and v60.TouchofDeath:CooldownUp() and v49) then
					local v210 = 0 + 0;
					local v211;
					local v212;
					while true do
						if (((7937 - 4047) >= (4665 - (1333 + 70))) and ((1834 - (701 + 1131)) == v210)) then
							if ((v212 and v89(v60.TouchofDeath)) or ((4483 - (55 + 72)) >= (4805 - (99 + 57)))) then
								if (((6552 - 2648) == (2031 + 1873)) and v211) then
									if ((((v212:TimeToDie() > (1639 - (1243 + 336))) or v212:DebuffUp(v60.BonedustBrewDebuff) or (v68 < (1339 - (774 + 555)))) and v13:BuffDown(v60.SerenityBuff)) or ((1364 + 1496) >= (4588 - (150 + 649)))) then
										if ((v212:GUID() == v14:GUID()) or ((689 + 397) > (6771 - 2322))) then
											if (((9618 - 4637) > (2530 - (1122 + 862))) and v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(9 - 4))) then
												return "touch_of_death cd_sef main-target 14";
											end
										elseif ((((GetTime() - v84.LastTargetSwap) * (190 + 810)) >= v34) or ((4498 - 2132) <= (5 + 3))) then
											local v272 = 0 + 0;
											while true do
												if ((v272 == (743 - (549 + 194))) or ((1712 + 878) == (11396 - 8532))) then
													v84.LastTargetSwap = GetTime();
													if (v24(v23(6 + 94)) or ((4095 - 1471) > (3536 + 613))) then
														return "touch_of_death cd_sef off-target 14";
													end
													break;
												end
											end
										end
									end
								elseif (v13:BuffDown(v60.SerenityBuff) or ((9414 - 6796) >= (6198 - (453 + 1250)))) then
									if ((v212:GUID() == v14:GUID()) or ((7052 - 4567) >= (2968 + 163))) then
										if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(580 - (203 + 372))) or ((133 + 2671) <= (8110 - 5325))) then
											return "touch_of_death cd_sef main-target 16";
										end
									elseif ((((GetTime() - v84.LastTargetSwap) * (2382 - (978 + 404))) >= v34) or ((14650 - 10079) == (3039 + 376))) then
										local v273 = 318 - (56 + 262);
										while true do
											if ((v273 == (0 + 0)) or ((4555 - (108 + 6)) > (2517 + 2270))) then
												v84.LastTargetSwap = GetTime();
												if (((1716 + 204) == (3872 - (653 + 1299))) and v24(v23(88 + 12))) then
													return "touch_of_death cd_sef off-target 16";
												end
												break;
											end
										end
									end
								end
							end
							break;
						end
						if (((0 + 0) == v210) or ((1517 - 870) == (6399 - (1042 + 880)))) then
							v211 = v13:IsInParty() and not v13:IsInRaid();
							v212 = nil;
							v210 = 1 + 0;
						end
						if (((4821 - (16 + 986)) == (5037 - (700 + 518))) and (v210 == (3 - 2))) then
							if ((v30 and v31) or ((1773 - 307) > (5871 - (617 + 894)))) then
								v212 = v93();
							elseif (v60.TouchofDeath:IsReady() or ((27 - 13) > (1452 - (271 + 187)))) then
								v212 = v14;
							end
							if (((1985 - (731 + 853)) <= (2551 - 1817)) and v212) then
								if ((v211 and v13:BuffDown(v60.SerenityBuff) and v89(v60.TouchofDeath) and (v212:Health() < v13:Health())) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) < (1523 - (199 + 1322))) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) > v212:TimeToDie()) or ((4246 - 2079) >= (1782 + 1644))) then
									if (((2424 - (1291 + 369)) < (80 + 3205)) and (v212:GUID() == v14:GUID())) then
										if (((1159 + 1340) == (1823 + 676)) and v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
											return "touch_of_death cd_sef main-target 12";
										end
									elseif ((((GetTime() - v84.LastTargetSwap) * (1685 - (561 + 124))) >= v34) or ((664 + 28) >= (5786 - (25 + 828)))) then
										v84.LastTargetSwap = GetTime();
										if (v24(v23(252 - 152)) or ((5700 - 2546) <= (2850 - (99 + 491)))) then
											return "touch_of_death cd_sef off-target 12";
										end
									end
								end
							end
							v210 = 50 - (18 + 30);
						end
					end
				end
				if ((v48 and v60.TouchofKarma:IsCastable() and ((v68 > (217 - 127)) or (v68 < (19 - 9)))) or ((4316 - 1679) > (896 + 2253))) then
					if (v22(v60.TouchofKarma, nil) or ((13335 - 9343) < (3139 - (501 + 231)))) then
						return "touch_of_karma cd_serenity 18";
					end
				end
				v157 = 4 + 0;
			end
			if ((v157 == (1700 - (470 + 1228))) or ((2204 + 698) > (3145 + 1714))) then
				if (((2365 - (537 + 149)) < (5299 - 940)) and v60.Serenity:IsCastable() and ((v73 and (v13:BuffUp(v60.InvokersDelightBuff) or (v71 and ((v60.DrinkingHornCover:IsAvailable() and (v68 > (60 + 50))) or (not v60.DrinkingHornCover:IsAvailable() and (v68 > (220 - 115))))))) or not v60.InvokeXuenTheWhiteTiger:IsAvailable() or (v68 < (47 - 32)))) then
					if (((5683 - 3770) < (3483 + 1187)) and v22(v60.Serenity, nil)) then
						return "serenity cd_serenity 10";
					end
				end
				if ((v60.Serenity:IsCastable() and not v73 and (v13:BuffUp(v60.InvokersDelightBuff) or (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > v68) or ((v68 > (v60.InvokeXuenTheWhiteTiger:CooldownRemains() + 4 + 6)) and (v68 > (56 + 34))))) or ((1235 + 1611) < (643 + 236))) then
					if (((516 + 4072) == (3211 + 1377)) and v22(v60.Serenity, nil)) then
						return "serenity cd_serenity 12";
					end
				end
				v157 = 4 - 1;
			end
		end
	end
	local function v112()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (580 - (134 + 445))) or ((690 - 343) == (1911 + 154))) then
				if (v13:IsCasting(v60.FistsofFury) or ((752 + 559) > (10483 - 7786))) then
					if (v24(v62.StopFoF) or ((2977 - (36 + 224)) > (5655 - (1033 + 827)))) then
						return "fists_of_fury_cancel serenity_aoelust 8";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and not v92() and v60.ShadowboxingTreads:IsAvailable()) or ((2927 - (1002 + 844)) < (1741 - (1126 + 224)))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((120 + 1) > (11609 - 8171))) then
						return "blackout_kick serenity_aoelust 10";
					end
				end
				if (((135 - (48 + 16)) < (1393 + 556)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (14 - 11)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (3 - 2))) then
					if (((1236 + 3018) == (5343 - (910 + 179))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(9 - 4))) then
						return "blackout_kick serenity_aoelust 12";
					end
				end
				v158 = 3 - 1;
			end
			if (((4575 - (933 + 446)) >= (1002 + 1548)) and (v158 == (1532 - (248 + 1276)))) then
				if (((2314 + 142) < (1691 + 2485)) and v60.SpinningCraneKick:IsReady() and (v89(v60.SpinningCraneKick))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(27 - 19)) or ((3892 - 2742) == (4997 - (151 + 1394)))) then
						return "spinning_crane_kick serenity_aoelust 50";
					end
				end
				if (((2819 - (929 + 15)) < (4254 - (1173 + 823))) and v60.WhirlingDragonPunch:IsReady()) then
					if (((1898 - 725) > (1817 - (482 + 1294))) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(10 - 5))) then
						return "whirling_dragon_punch serenity_aoelust 52";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((25 + 31) >= (4514 - (1125 + 181)))) then
					if (((12581 - 8268) > (2074 + 1299)) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(12 - 4))) then
						return "rushing_jade_wind serenity_aoelust 54";
					end
				end
				v158 = 1198 - (626 + 563);
			end
			if ((v158 == (1250 - (153 + 1097))) or ((14644 - 10151) == (1088 + 1137))) then
				if (((7932 - 4828) >= (1656 + 1436)) and v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 0))) then
					if (((985 + 2563) > (2202 + 896)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(27 + 3))) then
						return "faeline_stomp serenity_aoelust 2";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v13:HasTier(1188 - (199 + 958), 3 + 1) and v60.Thunderfist:IsAvailable()) or ((7682 - 4430) == (1157 - 654))) then
					if (((5909 - (1169 + 7)) > (3939 - (751 + 1122))) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(1 + 8))) then
						return "strike_of_the_windlord serenity_aoelust 4";
					end
				end
				if (((3215 + 334) >= (210 + 706)) and v60.FistsofFury:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(6 + 24, 2 - 0)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(1189 - (589 + 592))) or ((4375 - 2186) <= (75 + 170))) then
						return "fists_of_fury serenity_aoelust 6";
					end
				end
				v158 = 25 - (13 + 11);
			end
			if ((v158 == (4 + 3)) or ((205 + 1184) > (5185 - (684 + 576)))) then
				if (((2053 + 2116) >= (7592 - 4511)) and v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (((173 + 176) <= (145 + 749)) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(9 - 1))) then
						return "rushing_jade_wind serenity_aoelust 44";
					end
				end
				if (((692 + 39) <= (2637 + 341)) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and (v66 >= (2 + 1)) and v89(v60.BlackoutKick)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((266 + 626) > (5740 - (230 + 1618)))) then
						return "blackout_kick serenity_aoelust 46";
					end
				end
				if (v60.StrikeoftheWindlord:IsReady() or ((3569 + 897) == (300 + 600))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(9 + 0)) or ((2287 - (131 + 72)) >= (1435 + 1453))) then
						return "strike_of_the_windlord serenity_aoelust 48";
					end
				end
				v158 = 212 - (144 + 60);
			end
			if (((1953 - 1474) < (3254 - 1391)) and (v158 == (2 + 4))) then
				if ((v60.BlackoutKick:IsReady() and (v66 < (28 - 22)) and v89(v60.BlackoutKick) and v13:HasTier(3 + 27, 1924 - (523 + 1399))) or ((2337 + 91) >= (4442 - (72 + 332)))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(981 - (269 + 707))) or ((5705 - 2827) > (7260 - 4363))) then
						return "blackout_kick serenity_aoelust 38";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v92()) or ((2599 - (123 + 7)) > (2786 + 890))) then
					if (((158 + 75) < (2215 - 1728)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(19 - 11))) then
						return "spinning_crane_kick serenity_aoelust 40";
					end
				end
				if (((3561 - (38 + 1050)) >= (68 + 133)) and v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v66 == (2 + 3))) then
					if (((2233 + 1887) >= (956 - (426 + 397))) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v97, nil, not v14:IsInMeleeRange(1411 - (751 + 655)))) then
						return "tiger_palm serenity_aoelust 42";
					end
				end
				v158 = 13 - 6;
			end
			if (((408 + 2672) >= (3231 - (39 + 1206))) and (v158 == (8 - 5))) then
				if ((v60.SpinningCraneKick:IsReady() and v13:HasTier(872 - (566 + 275), 937 - (167 + 768)) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((547 + 892) > (5550 - 2012))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((402 + 17) < (9 - 2))) then
						return "spinning_crane_kick serenity_aoelust 20";
					end
				end
				if (((2835 - (8 + 7)) == (4503 - (1510 + 173))) and v60.BlackoutKick:IsReady() and (v66 < (8 - 2)) and v89(v60.BlackoutKick) and v13:HasTier(2 + 29, 255 - (30 + 223))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1261 - (300 + 956))) or ((4484 - (22 + 100)) <= (7775 - 4248))) then
						return "blackout_kick serenity_aoelust 22";
					end
				end
				if (((2895 - (47 + 235)) <= (8940 - 6260)) and v60.RisingSunKick:IsReady() and (v13:HasTier(18 + 12, 488 - (21 + 465)))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(4 + 1)) or ((992 + 490) >= (1291 + 2997))) then
						return "rising_sun_kick serenity_aoelust 24";
					end
				end
				v158 = 4 - 0;
			end
			if (((1219 - (553 + 664)) == v158) or ((994 + 1468) > (4504 - (73 + 5)))) then
				if (((6489 - (1128 + 587)) == (18535 - 13761)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((1256 - (558 + 132)) <= (2595 - 1635)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(22 - 14))) then
						return "spinning_crane_kick serenity_aoelust 14";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v13:HasTier(9 + 22, 2 + 0) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) or ((2481 + 429) <= (3198 - 1268))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((10 + 9) > (1223 - (294 + 477)))) then
						return "spinning_crane_kick serenity_aoelust 16";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v13:HasTier(11 + 20, 4 - 2) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or ((1785 - 878) > (818 + 2334))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0)) or ((5839 - 3334) > (5452 - (97 + 885)))) then
						return "blackout_kick serenity_aoelust 18";
					end
				end
				v158 = 2 + 1;
			end
			if ((v158 == (8 - 3)) or ((4076 - (271 + 94)) > (5665 - (777 + 826)))) then
				if (((159 + 261) == (1775 - (117 + 1238))) and v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(1723 - (686 + 1029))) or ((1389 - (1074 + 282)) >= (5111 - (1359 + 258)))) then
						return "fists_of_fury serenity_aoelust 32";
					end
				end
				if (v13:IsCasting(v60.FistsofFury) or ((2865 - 1598) == (6679 - (1730 + 205)))) then
					if (((2956 - (67 + 461)) < (6731 - 2953)) and v24(v62.StopFoF)) then
						return "fists_of_fury_cancel serenity_aoelust 34";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) or ((4499 - 1553) <= (3660 - 2064))) then
					if (((267 + 4166) > (3756 - (129 + 500))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1719 - (1157 + 554)))) then
						return "spinning_crane_kick serenity_aoelust 36";
					end
				end
				v158 = 7 - 1;
			end
			if (((4907 - (82 + 525)) >= (2484 + 249)) and (v158 == (8 - 4))) then
				if (((6452 - (948 + 675)) == (1553 + 3276)) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v66 < (10 + 0))) then
					if (((4690 - 3007) <= (5579 - (406 + 447))) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, v103, not v14:IsInMeleeRange(125 - (91 + 26)))) then
						return "strike_of_the_windlord serenity_aoelust 26";
					end
				end
				if (((16740 - 11905) >= (2756 + 913)) and v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (988 - (968 + 18)))) then
					if (((2817 + 34) > (1691 + 168)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(60 - 30))) then
						return "faeline_stomp serenity_aoelust 28";
					end
				end
				if (((4115 - (172 + 95)) > (7772 - 5449)) and v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) then
					if (((3101 - (260 + 5)) > (1276 - 807)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v65, "max", v101, nil, not v14:IsInMeleeRange(827 - (265 + 554)))) then
						return "strike_of_the_windlord serenity_aoelust 30";
					end
				end
				v158 = 1576 - (1440 + 131);
			end
			if ((v158 == (25 - 16)) or ((3491 - (253 + 1142)) <= (793 - (133 + 120)))) then
				if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((6809 - 3626) < (4601 - (809 + 1147)))) then
					if (((3727 - (178 + 319)) <= (7315 - 3555)) and v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick serenity_aoelust 56";
					end
				end
				if (((5098 - (1255 + 15)) == (5370 - (1221 + 321))) and v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (7 - 4))) then
					if (((430 + 124) == (2079 - 1525)) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(18 - 13))) then
						return "tiger_palm serenity_aoelust 58";
					end
				end
				break;
			end
		end
	end
	local function v113()
		if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 0))) or ((2448 + 115) == (358 - 186))) then
			if (((4296 - (204 + 203)) >= (209 - (48 + 30))) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(14 + 16))) then
				return "faeline_stomp serenity_lust 2";
			end
		end
		if ((v60.SpinningCraneKick:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < (1965.5 - (1472 + 492))) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(83 - 52, 2 + 0)) or ((1103 - (258 + 353)) == (6572 - (1382 + 612)))) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((158 + 3954) < (38 + 1778))) then
				return "spinning_crane_kick serenity_lust 4";
			end
		end
		if (((13344 - 8819) >= (841 + 382)) and v60.FistsofFury:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < (120 - (35 + 84)))) then
			if (((1305 - (75 + 140)) <= (17546 - 12719)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(1807 - (923 + 876)))) then
				return "fists_of_fury serenity_lust 4";
			end
		end
		if (v60.RisingSunKick:IsReady() or ((637 - 398) > (2157 - (284 + 528)))) then
			if (v84.CastTargetIf(v60.RisingSunKick, v64, "max", v101, nil, not v14:IsInMeleeRange(1024 - (867 + 152))) or ((4816 - (709 + 397)) >= (13242 - 9504))) then
				return "rising_sun_kick serenity_lust 8";
			end
		end
		if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (39 - (21 + 15))) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (1 - 0))) or ((7075 - 3237) < (433 + 1628))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(14 - 9)) or ((1719 - 1029) > (508 + 664))) then
				return "blackout_kick serenity_lust 6";
			end
		end
		if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((1727 - (97 + 38)) > (2679 - (52 + 28)))) then
			if (((1720 + 1854) <= (5246 - (59 + 790))) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(8 + 1))) then
				return "strike_of_the_windlord serenity_lust 10";
			end
		end
		if (((490 + 2645) > (2270 - (467 + 473))) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(4 - 3, v60.FistsofFury) and v60.ShadowboxingTreads:IsAvailable() and v13:HasTier(84 - 53, 4 - 2) and not v60.DanceofChiji:IsAvailable()) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(12 - 7)) or ((1539 + 2361) <= (8032 - 4391))) then
				return "blackout_kick serenity_lust 14";
			end
		end
		if (((6894 - 5170) == (2924 - 1200)) and v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
			if (((102 + 353) <= (240 + 1042)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(3 + 5))) then
				return "fists_of_fury serenity_lust 12";
			end
		end
		if (((4843 - (58 + 179)) < (11908 - 7032)) and v13:IsCasting(v60.FistsofFury)) then
			if (v24(v62.StopFoF) or ((2695 - (677 + 576)) > (1138 + 1502))) then
				return "fists_of_fury_cancel serenity_lust 14";
			end
		end
		if (((306 - 170) < (3888 - (88 + 132))) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0)) or ((8871 - 7087) > (16771 - 11990))) then
				return "blackout_kick serenity_lust 18";
			end
		end
		if (((4876 - (12 + 279)) > (5913 - 2615)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1 + 7)) or ((2611 - (652 + 295)) > (111 + 1587))) then
				return "spinning_crane_kick serenity_lust 20";
			end
		end
		if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((1982 + 1445) < (3838 - (848 + 141)))) then
			if (((4356 - (372 + 368)) <= (2564 + 1865)) and v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(1135 - (542 + 588)))) then
				return "blackout_kick serenity_lust 22";
			end
		end
		if (((4806 - (6 + 812)) >= (1771 - (1599 + 106))) and v60.WhirlingDragonPunch:IsReady()) then
			if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(13 - 8)) or ((415 + 447) > (1963 + 2681))) then
				return "whirling_dragon_punch serenity_lust 24";
			end
		end
		if (((4634 - 3413) == (2129 - 908)) and v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (1 + 2))) then
			if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(1 + 4)) or ((36 + 9) > (295 + 976))) then
				return "tiger_palm serenity_lust 26";
			end
		end
	end
	local function v114()
		local v159 = 0 + 0;
		while true do
			if (((1066 + 2811) > (3459 - (1690 + 239))) and (v159 == (3 - 2))) then
				if ((v13:IsCasting(v60.FistsofFury) and not v13:HasTier(23 + 7, 3 - 1)) or ((12358 - 7560) == (850 + 405))) then
					if (v24(v62.StopFoF) or ((10159 - 7618) > (4728 - (1736 + 132)))) then
						return "fists_of_fury_cancel serenity_aoe 8";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((1546 + 1356) > (11914 - 8285))) then
					if (((1981 - 1554) < (183 + 3285)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(40 - (27 + 5)))) then
						return "spinning_crane_kick serenity_aoe 14";
					end
				end
				if (((543 + 3647) >= (2002 + 802)) and v60.SpinningCraneKick:IsReady() and v13:HasTier(12 + 19, 1 + 1) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (((3203 - (771 + 346)) == (3720 - (1577 + 57))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(13 - 5))) then
						return "spinning_crane_kick serenity_aoe 16";
					end
				end
				v159 = 1082 - (684 + 396);
			end
			if (((12219 - 8071) > (3929 - (700 + 496))) and (v159 == (7 + 1))) then
				if (((3306 - (65 + 187)) >= (2544 - (827 + 112))) and v60.StrikeoftheWindlord:IsReady()) then
					if (((729 + 315) < (3954 - 2435)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(12 - 7))) then
						return "strike_of_the_windlord serenity_aoe 50";
					end
				end
				if (((8209 - 6502) <= (873 + 3327)) and v60.SpinningCraneKick:IsReady() and (v89(v60.SpinningCraneKick))) then
					if (((80 + 500) == (1776 - (551 + 645))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(351 - (166 + 177)))) then
						return "spinning_crane_kick serenity_aoe 52";
					end
				end
				if (((2457 - (1361 + 495)) <= (2706 - 1707)) and v60.WhirlingDragonPunch:IsReady()) then
					if (((1991 + 1979) == (8883 - 4913)) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "whirling_dragon_punch serenity_aoe 54";
					end
				end
				v159 = 233 - (148 + 76);
			end
			if (((33 - 24) == v159) or ((264 - 166) == (129 + 79))) then
				if (((3748 - (735 + 1007)) <= (4193 - (111 + 168))) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(3 + 2)) or ((264 + 2837) <= (6150 - 3179))) then
						return "blackout_kick serenity_aoe 56";
					end
				end
				if ((v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (1 + 2))) or ((1603 + 470) <= (29 + 642))) then
					if (((14084 - 10779) > (51 + 44)) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(937 - (147 + 785)))) then
						return "tiger_palm serenity_aoe 58";
					end
				end
				break;
			end
			if (((3393 - (483 + 183)) == (8169 - 5442)) and (v159 == (5 + 0))) then
				if ((v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or ((4881 - (1790 + 121)) >= (13277 - 9205))) then
					if (((5420 - (259 + 1280)) > (2398 - (160 + 1424))) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(8 + 0))) then
						return "fists_of_fury serenity_aoe 32";
					end
				end
				if (v13:IsCasting(v60.FistsofFury) or ((1576 + 3356) < (5638 - (479 + 291)))) then
					if (((6962 - 3295) <= (5773 - (569 + 402))) and v24(v62.StopFoF)) then
						return "fists_of_fury_cancel serenity_aoe 34";
					end
				end
				if (((2565 - (635 + 670)) >= (2115 - 1257)) and v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(35 - 26)) or ((4509 - (42 + 556)) == (6101 - (1246 + 155)))) then
						return "strike_of_the_windlord serenity_aoe 36";
					end
				end
				v159 = 738 - (31 + 701);
			end
			if (((10022 - 7022) < (4693 - (393 + 106))) and (v159 == (1177 - (727 + 444)))) then
				if (((1888 - 1237) < (1585 + 2857)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(661 - (269 + 384))) or ((1764 - (598 + 971)) >= (682 + 1122))) then
						return "spinning_crane_kick serenity_aoe 38";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v66 < (19 - 13)) and v89(v60.BlackoutKick) and v13:HasTier(140 - 110, 5 - 3)) or ((2827 - (800 + 645)) > (475 + 1741))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(795 - (687 + 103))) or ((4023 - (142 + 1020)) == (5958 - 3499))) then
						return "blackout_kick serenity_aoe 40";
					end
				end
				if (((316 + 1587) < (4534 - (306 + 207))) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v92()) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1412 - (112 + 1292))) or ((1909 + 361) >= (5082 - (587 + 365)))) then
						return "spinning_crane_kick serenity_aoe 42";
					end
				end
				v159 = 1722 - (829 + 886);
			end
			if (((6576 - 3983) <= (908 + 3050)) and (v159 == (15 - 11))) then
				if (((3740 - 2564) == (1143 + 33)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and not v92() and v60.ShadowboxingTreads:IsAvailable()) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2)) or ((5230 - 2168) == (2795 - (613 + 364)))) then
						return "blackout_kick serenity_aoe 10";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v66 < (10 + 0))) or ((1657 + 2060) < (704 + 2445))) then
					if (((7299 - 4104) < (13397 - 9667)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v103, not v14:IsInMeleeRange(15 - 10))) then
						return "strike_of_the_windlord serenity_aoe 28";
					end
				end
				if (((1826 + 971) <= (5919 - (1467 + 472))) and v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (2 - 0))) then
					if (((3491 - (1077 + 470)) <= (46 + 2322)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(10 + 20))) then
						return "faeline_stomp serenity_aoe 30";
					end
				end
				v159 = 22 - 17;
			end
			if (((2138 - (12 + 417)) < (10508 - 6260)) and (v159 == (6 + 1))) then
				if ((v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v66 == (6 - 1))) or ((8128 - 4158) == (6073 - 2871))) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v97, nil, not v14:IsInMeleeRange(2 + 3)) or ((1504 + 2414) >= (668 + 3729))) then
						return "tiger_palm serenity_aoe 44";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((2254 - 1474) == (4290 - (924 + 181)))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(805 - (263 + 534))) or ((133 + 3069) >= (3859 + 216))) then
						return "rushing_jade_wind serenity_aoe 46";
					end
				end
				if (((132 - 68) == (184 - 120)) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and (v66 >= (2 + 1)) and v89(v60.BlackoutKick)) then
					if (((2909 - (562 + 145)) >= (178 + 516)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick serenity_aoe 48";
					end
				end
				v159 = 4 + 4;
			end
			if (((10 + 3696) <= (663 + 3237)) and (v159 == (0 - 0))) then
				if (((2851 + 39) > (12102 - 9485)) and v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 0))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(20 + 10)) or ((5231 - (1459 + 417)) > (4671 - (194 + 92)))) then
						return "faeline_stomp serenity_aoe 2";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v13:HasTier(1416 - (1057 + 328), 11 - 7) and v60.Thunderfist:IsAvailable()) or ((14932 - 11865) <= (2727 - (5 + 527)))) then
					if (((2306 + 719) >= (3593 - (342 + 438))) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(5 + 4))) then
						return "strike_of_the_windlord serenity_aoe 4";
					end
				end
				if (((1135 + 1277) >= (284 + 72)) and v60.FistsofFury:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(58 - 28, 1 + 1)) then
					if (((293 + 1777) > (2332 - 1161)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(14 - 6))) then
						return "fists_of_fury serenity_aoe 6";
					end
				end
				v159 = 13 - (6 + 6);
			end
			if ((v159 == (5 - 3)) or ((11523 - 7415) < (1646 + 2288))) then
				if (((4752 - (206 + 1047)) >= (4551 - (470 + 642))) and v60.BlackoutKick:IsReady() and v13:HasTier(8 + 23, 1069 - (552 + 515)) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if (((704 + 172) < (2587 + 716)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "blackout_kick serenity_aoe 18";
					end
				end
				if (((1575 + 1347) <= (1988 + 1574)) and v60.SpinningCraneKick:IsReady() and v13:HasTier(19 + 12, 1053 - (701 + 350)) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((1331 + 1288) >= (705 + 617)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(5 + 3))) then
						return "spinning_crane_kick serenity_aoe 20";
					end
				end
				if (((6499 - 2366) >= (7495 - 5091)) and v60.SpinningCraneKick:IsReady() and v13:HasTier(20 + 11, 4 - 2) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v60.BlackoutKick)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((5711 - 4278) == (4032 - (281 + 1065)))) then
						return "spinning_crane_kick serenity_aoe 22";
					end
				end
				v159 = 13 - 10;
			end
			if ((v159 == (11 - 8)) or ((5334 - (1114 + 97)) == (6774 - 2317))) then
				if ((v60.RisingSunKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(1943 - (279 + 1634), 1282 - (1213 + 67))) or ((4163 - (65 + 126)) <= (188 + 17))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1090 - (189 + 896))) or ((374 + 3392) < (2967 - (1872 + 91)))) then
						return "rising_sun_kick serenity_aoe 24";
					end
				end
				if (((4131 - 2347) < (2140 + 44)) and v60.RisingSunKick:IsReady() and (v13:HasTier(106 - 76, 2 + 0))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2)) or ((5953 - 4304) > (4307 - (22 + 54)))) then
						return "rising_sun_kick serenity_aoe 26";
					end
				end
				if (((7485 - 4292) == (8028 - 4835)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 2)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (3 - 2))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1539 - (553 + 981))) or ((3302 + 193) > (2671 + 1635))) then
						return "blackout_kick serenity_aoe 12";
					end
				end
				v159 = 3 + 1;
			end
		end
	end
	local function v115()
		local v160 = 0 - 0;
		while true do
			if (((5950 - 1949) > (5695 - (1320 + 577))) and (v160 == (853 - (667 + 182)))) then
				if (v13:IsCasting(v60.FistsofFury) or ((5976 - (1115 + 173)) <= (7544 - 3045))) then
					if (v24(v62.StopFoF) or ((1245 + 322) <= (2074 - (1375 + 380)))) then
						return "fists_of_fury_cancel serenity_4t 34";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((1772 + 2811) == (3787 - (12 + 14)))) then
					if (((8329 - 4875) > (3495 - 1915)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(22 - 13))) then
						return "strike_of_the_windlord serenity_4t 36";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((4657 - 3050) == (30 - 10))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(12 - 4)) or ((1693 - (354 + 377)) >= (22043 - 17377))) then
						return "spinning_crane_kick serenity_4t 38";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) or ((5096 - 3200) == (3690 - (263 + 1719)))) then
					if (((1908 + 2077) >= (1643 - (335 + 24))) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(956 - (882 + 69)))) then
						return "rising_sun_kick serenity_4t 40";
					end
				end
				v160 = 1691 - (657 + 1029);
			end
			if (((1201 - (685 + 515)) == v160) or ((3625 - (745 + 893)) == (92 + 453))) then
				if ((v60.FistsofFury:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(802 - (274 + 498), 1 + 1)) or ((1676 + 3220) < (2867 - (1035 + 571)))) then
					if (((10 + 13) < (1442 + 2168)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(29 - 21))) then
						return "fists_of_fury serenity_4t 10";
					end
				end
				if ((v13:IsCasting(v60.FistsofFury) and not v13:HasTier(91 - 61, 2 + 0)) or ((2600 + 1311) < (7918 - 5340))) then
					if (v24(v62.StopFoF) or ((4462 - (109 + 115)) < (1486 - (1047 + 352)))) then
						return "fists_of_fury_cancel serenity_4t 12";
					end
				end
				if (((4303 - (852 + 913)) == (1839 + 699)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:HasTier(1376 - (384 + 961), 4 - 2) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((11974 - 7852) == (15108 - 10986)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(600 - (591 + 1)))) then
						return "spinning_crane_kick serenity_4t 14";
					end
				end
				if ((v60.RisingSunKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and not v60.BonedustBrew:IsAvailable()) or ((458 + 1913) > (4124 - (218 + 1252)))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(4 + 1)) or ((3822 - (321 + 35)) > (4914 - (239 + 155)))) then
						return "rising_sun_kick serenity_4t 20";
					end
				end
				v160 = 2 + 0;
			end
			if ((v160 == (47 - (41 + 1))) or ((1151 - (80 + 120)) >= (844 + 183))) then
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(56 - 26, 1 + 1)) or ((1275 + 94) > (11143 - 8893))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(10 - 5)) or ((3967 - 3030) > (6328 - 2542))) then
						return "blackout_kick serenity_4t 42";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v92()) or ((417 + 484) > (1291 + 2927))) then
					if (((89 + 4690) > (5273 - (165 + 1061))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
						return "spinning_crane_kick serenity_4t 44";
					end
				end
				if (((3248 + 802) > (3016 - (596 + 1047))) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((792 + 245) > (6488 - 2098))) then
						return "blackout_kick serenity_4t 46";
					end
				end
				if (((748 + 659) <= (2656 - (185 + 552))) and v60.StrikeoftheWindlord:IsReady()) then
					if (((1287 + 1239) >= (2318 - (507 + 94))) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(39 - 30))) then
						return "strike_of_the_windlord serenity_4t 48";
					end
				end
				v160 = 2 + 4;
			end
			if ((v160 == (2 - 0)) or ((5357 - (569 + 1168)) <= (4099 - 2005))) then
				if ((v60.RisingSunKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(60 - 30, 353 - (118 + 233))) or ((2067 - (279 + 65)) >= (4090 - 1643))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(8 - 3)) or ((2447 - 1248) > (9913 - 6370))) then
						return "rising_sun_kick serenity_4t 22";
					end
				end
				if (((3435 - (1414 + 404)) < (4027 - (347 + 409))) and v60.RisingSunKick:IsReady() and (v13:HasTier(18 + 12, 2 + 0))) then
					if (((1667 + 1418) > (347 + 819)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1583 - (420 + 1158)))) then
						return "rising_sun_kick serenity_4t 24";
					end
				end
				if (((10927 - 6434) >= (4214 - (406 + 205))) and v60.SpinningCraneKick:IsReady() and v13:HasTier(105 - 74, 2 + 0) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((2216 + 627) <= (7431 - 4456)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(69 - (28 + 33)))) then
						return "spinning_crane_kick serenity_4t 26";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 2)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (1008 - (858 + 149)))) or ((210 + 1779) <= (248 - 74))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1512 - (829 + 678))) or ((153 + 56) > (3369 - (143 + 1073)))) then
						return "blackout_kick serenity_4t 16";
					end
				end
				v160 = 1818 - (898 + 917);
			end
			if (((0 - 0) == v160) or ((961 + 1059) == (3443 - (882 + 587)))) then
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 0))) or ((602 + 745) == (1624 - (140 + 124)))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(29 + 1)) or ((5996 - (1105 + 430)) == (9622 - 6050))) then
						return "faeline_stomp serenity_4t 2";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < (3.5 - 2)) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(69 - 38, 3 - 1)) or ((2221 + 651) == (111 + 207))) then
					if (((349 + 219) == (59 + 509)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1999 - (1047 + 944)))) then
						return "spinning_crane_kick serenity_4t 4";
					end
				end
				if (((5502 - (206 + 1096)) == (4394 - (30 + 164))) and v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and not v13:HasTier(139 - 108, 1 + 1)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v97, nil, not v14:IsInMeleeRange(1479 - (1383 + 91))) or ((16604 - 12319) < (2715 - 1346))) then
						return "tiger_palm serenity_4t 6";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v13:HasTier(1691 - (1174 + 486), 431 - (172 + 255)) and v60.Thunderfist:IsAvailable()) or ((11001 - 7481) > (11727 - 6817))) then
					if (((4370 - (594 + 934)) <= (4921 - (211 + 357))) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(2 + 7))) then
						return "strike_of_the_windlord serenity_4t 8";
					end
				end
				v160 = 1 + 0;
			end
			if ((v160 == (9 - 3)) or ((2560 + 1191) < (3057 - (159 + 1255)))) then
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((4242 + 669) == (4311 - (24 + 753)))) then
					if (((1451 + 1550) > (20 - 4)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1140 - (898 + 234)))) then
						return "spinning_crane_kick serenity_4t 50";
					end
				end
				if (((3410 - (333 + 202)) <= (1410 + 1845)) and v60.WhirlingDragonPunch:IsReady()) then
					if (((125 + 243) < (8674 - 4420)) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1284 - (1018 + 261)))) then
						return "whirling_dragon_punch serenity_4t 52";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((12309 - 7468) <= (2334 - (93 + 38)))) then
					if (((617 + 4044) > (395 + 221)) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "rushing_jade_wind serenity_4t 54";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((1928 + 15) == (6289 - 3577))) then
					if (((15724 - 11505) >= (112 - 73)) and v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(23 - 18))) then
						return "blackout_kick serenity_4t 56";
					end
				end
				v160 = 14 - 7;
			end
			if (((830 + 3137) > (3328 - 1039)) and (v160 == (2 + 1))) then
				if ((v60.BlackoutKick:IsReady() and v13:HasTier(451 - (14 + 406), 3 - 1) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or ((3092 - 2241) > (4617 - (20 + 1610)))) then
					if (((1970 + 2923) >= (376 - 241)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(14 - 9))) then
						return "blackout_kick serenity_4t 18";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) or ((3601 - (243 + 274)) > (4836 - (1437 + 185)))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v103, not v14:IsInMeleeRange(27 - 18)) or ((1560 + 1866) < (10185 - 7538))) then
						return "strike_of_the_windlord serenity_4t 28";
					end
				end
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (2 + 0))) or ((16 + 1560) == (5191 - (326 + 490)))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(21 + 9)) or ((3123 - (181 + 22)) < (2667 - (35 + 40)))) then
						return "faeline_stomp serenity_4t 30";
					end
				end
				if ((v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or ((4453 - 3343) >= (3717 - 898))) then
					if (((16 + 1808) <= (3721 - (297 + 581))) and v84.CastTargetIf(v60.FistsofFury, v64, "max", v101, nil, not v14:IsInMeleeRange(1 + 7))) then
						return "fists_of_fury serenity_4t 32";
					end
				end
				v160 = 5 - 1;
			end
			if (((9933 - 6871) == (1111 + 1951)) and ((27 - 20) == v160)) then
				if (((3174 - 2458) <= (6071 - (1505 + 232))) and v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (1321 - (415 + 903)))) then
					if (((2707 - 1706) < (4919 - 1885)) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(722 - (155 + 562)))) then
						return "tiger_palm serenity_4t 58";
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v161 = 0 + 0;
		while true do
			if ((v161 == (122 - (71 + 46))) or ((1516 - 539) > (2542 - (436 + 249)))) then
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((2489 - (56 + 1565)) > (369 + 528))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(992 - (80 + 904))) or ((57 + 1058) == (5517 - (595 + 205)))) then
						return "spinning_crane_kick serenity_3t 30";
					end
				end
				if (((6593 - 3853) < (11088 - 6981)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (2 + 0))) then
					if (((116 + 168) < (2263 - 1563)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick serenity_3t 32";
					end
				end
				if (((1051 - (400 + 265)) >= (264 - 127)) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick)) then
					if (((226 + 697) == (2046 - 1123)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick serenity_3t 34";
					end
				end
				v161 = 1677 - (962 + 709);
			end
			if ((v161 == (6 + 1)) or ((2980 + 1193) == (261 + 98))) then
				if (((6737 - 5015) == (4481 - 2759)) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(786 - (636 + 145))) or ((4289 - (282 + 13)) <= (4968 - (366 + 782)))) then
						return "blackout_kick serenity_3t 42";
					end
				end
				if (((1577 - (10 + 79)) < (3348 - (1297 + 410))) and v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (10 - 7))) then
					if (((379 + 54) <= (2513 - (262 + 16))) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(10 - 5))) then
						return "tiger_palm serenity_3t 44";
					end
				end
				break;
			end
			if ((v161 == (1 + 0)) or ((216 + 1622) > (4321 - (1056 + 794)))) then
				if (((3792 - (741 + 607)) < (5069 - (730 + 1026))) and v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1798 - (248 + 1545))) or ((4677 - (191 + 801)) <= (917 - 732))) then
						return "rising_sun_kick serenity_3t 8";
					end
				end
				if (((1298 - (478 + 82)) <= (3666 - (434 + 1273))) and v60.RisingSunKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(85 - 55, 2 + 0)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(20 - 15)) or ((1890 - (349 + 224)) == (3957 - (275 + 589)))) then
						return "rising_sun_kick serenity_3t 10";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v13:HasTier(54 - 24, 3 - 1))) or ((4143 - (1064 + 468)) >= (3246 + 1189))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2)) or ((501 - 384) > (5628 - (676 + 27)))) then
						return "rising_sun_kick serenity_3t 12";
					end
				end
				v161 = 5 - 3;
			end
			if (((1534 - (48 + 1379)) <= (4200 + 705)) and (v161 == (2 + 2))) then
				if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((1745 - 741) > (3009 + 1026))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(124 - (79 + 36))) or ((9599 - 6797) < (166 + 203))) then
						return "strike_of_the_windlord serenity_3t 24";
					end
				end
				if (((808 + 689) <= (750 + 1811)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((1901 - 1085) > (738 + 974))) then
						return "spinning_crane_kick serenity_3t 26";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(14 + 16, 1016 - (631 + 383))) or ((4368 - (445 + 1190)) == (4396 - (810 + 615)))) then
					if (((3893 - (819 + 475)) < (5385 - (243 + 1092))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(14 - 9))) then
						return "blackout_kick serenity_3t 28";
					end
				end
				v161 = 4 + 1;
			end
			if (((1909 + 125) == (130 + 1904)) and (v161 == (6 + 0))) then
				if (((5108 - 2068) < (12952 - 8424)) and v60.StrikeoftheWindlord:IsReady()) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(533 - (119 + 405))) or ((4935 - 2843) <= (7243 - 5190))) then
						return "strike_of_the_windlord serenity_3t 36";
					end
				end
				if (((2729 - (352 + 257)) < (106 + 4693)) and v60.WhirlingDragonPunch:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1168 - (88 + 1075))) or ((5609 - (477 + 594)) <= (1112 - (328 + 395)))) then
						return "whirling_dragon_punch serenity_3t 38";
					end
				end
				if (((774 - (164 + 340)) <= (2409 - 819)) and v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (((3917 - 2292) > (2494 - (1008 + 221))) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(1519 - (1025 + 486)))) then
						return "rushing_jade_wind serenity_3t 40";
					end
				end
				v161 = 15 - 8;
			end
			if ((v161 == (0 - 0)) or ((270 - (108 + 111)) >= (1018 - (82 + 16)))) then
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1730 - (533 + 1196)))) or ((4506 - 1538) <= (2210 - (161 + 51)))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(464 - (294 + 140))) or ((12681 - 9596) <= (3580 - (717 + 121)))) then
						return "faeline_stomp serenity_3t 2";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v13:HasTier(48 - 17, 2 + 0) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or ((60 + 316) >= (3793 - (1001 + 709)))) then
					if (((4008 + 183) > (2352 - (242 + 878))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1788 - (1395 + 388)))) then
						return "blackout_kick serenity_3t 4";
					end
				end
				if ((v60.TigerPalm:IsReady() and (v89(v60.TigerPalm))) or ((752 + 753) > (3544 + 1329))) then
					if (((3800 + 80) < (2045 + 2489)) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v97, nil, not v14:IsInMeleeRange(1952 - (1289 + 658)))) then
						return "tiger_palm serenity_3t 6";
					end
				end
				v161 = 1 + 0;
			end
			if ((v161 == (4 - 1)) or ((1871 + 497) >= (1960 + 581))) then
				if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((8952 - 4219) <= (6079 - (337 + 1639)))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v104, not v14:IsInMeleeRange(7 + 2)) or ((2182 - 975) == (11553 - 7280))) then
						return "strike_of_the_windlord serenity_3t 18";
					end
				end
				if ((v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or ((4333 - 2328) == (4266 - (630 + 1107)))) then
					if (((853 + 133) < (521 + 3068)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(11 - 3))) then
						return "fists_of_fury serenity_3t 20";
					end
				end
				if (v13:IsCasting(v60.FistsofFury) or ((1394 + 1725) == (359 + 71))) then
					if (((2470 - (13 + 48)) <= (3918 - (658 + 41))) and v24(v62.StopFoF)) then
						return "fists_of_fury_cancel serenity_3t 22";
					end
				end
				v161 = 8 - 4;
			end
			if ((v161 == (1909 - (1591 + 316))) or ((1690 - 792) > (688 + 2094))) then
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (2 + 1)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (3 - 2))) or ((3526 - (1241 + 35)) <= (1804 - (18 + 22)))) then
					if (((960 - 267) == (182 + 511)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1307 - (697 + 605)))) then
						return "blackout_kick serenity_3t 6";
					end
				end
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1 + 1))) or ((5460 - 2931) == (767 - (188 + 141)))) then
					if (((7426 - 5675) > (3337 - 1926)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(980 - (34 + 916)))) then
						return "faeline_stomp serenity_3t 14";
					end
				end
				if (((5919 - (357 + 1380)) == (3836 + 346)) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v103, not v14:IsInMeleeRange(5 + 4)) or ((1199 + 3467) <= (2538 - (178 + 1749)))) then
						return "strike_of_the_windlord serenity_3t 16";
					end
				end
				v161 = 8 - 5;
			end
		end
	end
	local function v117()
		if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (1417 - (142 + 1273))) and (not v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (595 - (284 + 309))) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) or ((3875 + 862) <= (5215 - (622 + 68)))) then
			if (((2229 + 2138) >= (8480 - 4745)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(24 + 6))) then
				return "faeline_stomp serenity_2t 2";
			end
		end
		if (((1512 + 914) == (4324 - (855 + 1043))) and v60.TigerPalm:IsReady() and (v89(v60.TigerPalm))) then
			if (((47 - 26) < (6719 - 4748)) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v97, nil, not v14:IsInMeleeRange(17 - 12))) then
				return "tiger_palm serenity_2t 4";
			end
		end
		if ((v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) or ((3701 - (576 + 203)) <= (1123 - 682))) then
			if (((5924 - 2300) >= (3120 - (709 + 1275))) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "rising_sun_kick serenity_2t 8";
			end
		end
		if (((6966 - 4923) < (9976 - 7329)) and v60.RisingSunKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(148 - (31 + 87), 133 - (44 + 87))) then
			if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(18 - 13)) or ((289 + 65) >= (3364 - 1830))) then
				return "rising_sun_kick serenity_2t 10";
			end
		end
		if ((v60.RisingSunKick:IsReady() and (v13:HasTier(86 - 56, 788 - (284 + 502)))) or ((2440 + 1324) >= (6062 - (124 + 1062)))) then
			if (((4703 - (847 + 180)) >= (531 + 172)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(20 - 15))) then
				return "rising_sun_kick serenity_2t 12";
			end
		end
		if (((5174 - (369 + 994)) > (1282 - (583 + 380))) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 2)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (1 + 0))) then
			if (((24 + 23) < (3063 - (1085 + 888))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(12 - 7))) then
				return "blackout_kick serenity_2t 6";
			end
		end
		if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (7 - 5))) or ((6409 - 5038) >= (4327 - 1427))) then
			if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(9 + 21)) or ((569 + 557) <= (207 + 297))) then
				return "faeline_stomp serenity_2t 14";
			end
		end
		if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) or ((5341 - 1609) == (270 - 77))) then
			if (((2842 + 502) >= (2398 + 907)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v103, not v14:IsInMeleeRange(9 + 0))) then
				return "strike_of_the_windlord serenity_2t 16";
			end
		end
		if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((3099 - (153 + 61)) < (2868 - (704 + 239)))) then
			if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, v104, not v14:IsInMeleeRange(5 + 4)) or ((5928 - (740 + 646)) <= (963 + 631))) then
				return "strike_of_the_windlord serenity_2t 18";
			end
		end
		if (((2260 - (1547 + 375)) <= (1784 + 1721)) and v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
			if (((472 - (211 + 192)) == (311 - 242)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(12 - 4))) then
				return "fists_of_fury serenity_2t 20";
			end
		end
		if (v13:IsCasting(v60.FistsofFury) or ((1453 - (425 + 356)) == (33 + 335))) then
			if (((2655 - 1636) == (2585 - (83 + 1483))) and v24(v62.StopFoF)) then
				return "fists_of_fury_cancel serenity_2t 22";
			end
		end
		if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((1562 - (123 + 1149)) > (2171 + 575))) then
			if (((705 + 1218) < (6181 - (908 + 672))) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(522 - (206 + 307)))) then
				return "strike_of_the_windlord serenity_2t 24";
			end
		end
		if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(25 + 5, 64 - (18 + 44))) or ((1334 + 2623) == (4598 - 2499))) then
			if (((9421 - 5415) > (138 + 603)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(940 - (226 + 709)))) then
				return "blackout_kick serenity_2t 26";
			end
		end
		if (((3085 - (235 + 491)) <= (6083 - 2350)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 1))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1304 - (463 + 836))) or ((5000 - (166 + 238)) <= (4185 - 1783))) then
				return "blackout_kick serenity_2t 28";
			end
		end
		if (((1831 + 247) > (1604 - (1080 + 361))) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v60.FistsofFury:CooldownRemains() > (7 - 2)) and v60.ShadowboxingTreads:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 0))) then
			if (((5503 - 1387) > (1037 - (254 + 46))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "blackout_kick serenity_2t 30";
			end
		end
		if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((634 + 541) > (4330 - (37 + 219)))) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1907 - (1330 + 569))) or ((2067 - 706) == (7856 - 3114))) then
				return "spinning_crane_kick serenity_2t 32";
			end
		end
		if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((16017 - 12005) >= (6021 - 1949))) then
			if (((4477 - (128 + 542)) >= (2317 - 1041)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(28 - 20))) then
				return "spinning_crane_kick serenity_2t 34";
			end
		end
		if (((7598 - 5378) <= (696 + 3665)) and v60.WhirlingDragonPunch:IsReady()) then
			if (((803 - 575) == (200 + 28)) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(3 + 2))) then
				return "whirling_dragon_punch serenity_2t 36";
			end
		end
		if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((8413 - 4295) <= (3251 + 327))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "max", v101, nil, not v14:IsInMeleeRange(817 - (96 + 716))) or ((4522 - (85 + 1522)) < (2762 - (724 + 129)))) then
				return "blackout_kick serenity_2t 38";
			end
		end
		if (((2008 - 1374) <= (2648 - (83 + 290))) and v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (3 - 0))) then
			if (((1997 - 906) <= (2205 + 580)) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(4 + 1))) then
				return "tiger_palm serenity_2t 40";
			end
		end
	end
	local function v118()
		local v162 = 0 + 0;
		while true do
			if (((6737 - 2099) >= (1400 + 1440)) and (v162 == (8 - 4))) then
				if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((2522 - 1230) > (4861 - (190 + 257)))) then
					if (((4102 - (402 + 189)) == (1934 + 1577)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(571 - (90 + 476)))) then
						return "blackout_kick serenity_st 34";
					end
				end
				if (((2946 - (688 + 126)) == (865 + 1267)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (((138 + 794) <= (4471 - (34 + 465))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(34 - 26))) then
						return "spinning_crane_kick serenity_st 36";
					end
				end
				if (v60.WhirlingDragonPunch:IsReady() or ((9628 - 5068) <= (1402 + 1292))) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(3 + 2)) or ((6680 - 4149) >= (3894 + 75))) then
						return "whirling_dragon_punch serenity_st 38";
					end
				end
				if ((v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (5 - 2))) or ((2545 - (587 + 1220)) > (4085 - (1211 + 681)))) then
					if (((4683 - (64 + 13)) >= (4053 - (121 + 534))) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(808 - (622 + 181)))) then
						return "tiger_palm serenity_st 40";
					end
				end
				break;
			end
			if (((711 + 1142) > (3411 - (296 + 1373))) and (v162 == (1 + 0))) then
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 2)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (1 + 0))) or ((4056 - (143 + 1471)) > (8502 - 5938))) then
					if (((1468 + 2906) >= (10807 - 6639)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(185 - (103 + 77)))) then
						return "blackout_kick serenity_st 8";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:HasTier(24 + 7, 1161 - (895 + 262))) or ((9352 - 4776) > (3862 + 1076))) then
					if (((4556 - (581 + 1045)) > (1924 - (582 + 693))) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(1195 - (454 + 732)))) then
						return "strike_of_the_windlord serenity_st 10";
					end
				end
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (3 - 1))) or ((368 + 1026) < (195 - 62))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(41 - 11)) or ((1082 - (367 + 283)) == (563 - (7 + 61)))) then
						return "faeline_stomp serenity_st 14";
					end
				end
				if (((185 - 119) < (3204 - 1748)) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff))) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(2 + 7)) or ((1556 - (332 + 346)) >= (6553 - 3331))) then
						return "strike_of_the_windlord serenity_st 16";
					end
				end
				v162 = 3 - 1;
			end
			if ((v162 == (7 - 5)) or ((244 + 10) >= (4379 - 1090))) then
				if ((v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (49 + 6))) or ((1115 + 1596) <= (1150 - 445))) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(20 - 11)) or ((4360 - (815 + 1039)) >= (4142 - (336 + 440)))) then
						return "strike_of_the_windlord serenity_st 18";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v60.RisingSunKick) and v13:HasTier(3 + 28, 4 - 2)) or ((553 - (222 + 208)) > (33 + 713))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(838 - (652 + 178))) or ((7043 - 2599) <= (2426 - 1532))) then
						return "spinning_crane_kick serenity_st 20";
					end
				end
				if (((1348 + 28) > (1469 - 886)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(425 - (259 + 135), 1462 - (1393 + 67)) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v60.RisingSunKick)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1453 - (1129 + 319))) or ((1241 + 1186) == (3360 - 905))) then
						return "blackout_kick serenity_st 22";
					end
				end
				if (((3805 - (137 + 275)) >= (3168 - (140 + 299))) and v60.FistsofFury:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
					if (((5276 - (421 + 680)) == (20437 - 16262)) and v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(24 - 16))) then
						return "fists_of_fury serenity_st 24";
					end
				end
				v162 = 7 - 4;
			end
			if (((2487 + 2097) > (2426 - (58 + 482))) and (v162 == (679 - (310 + 369)))) then
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < (2 + 0)) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) or ((1329 - (274 + 12)) >= (1901 + 379))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(23 + 7)) or ((2429 - (681 + 1081)) < (240 - 169))) then
						return "faeline_stomp serenity_st 2";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < (1.5 - 0)) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(78 - 47, 881 - (842 + 35))) or ((7089 - 2607) < (4660 - (180 + 1687)))) then
					if (((1374 - 813) < (5490 - (269 + 702))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(822 - (776 + 38)))) then
						return "spinning_crane_kick serenity_st 4";
					end
				end
				if ((v60.TigerPalm:IsReady() and v14:DebuffDown(v60.SkyreachExhaustionDebuff) and v89(v60.TigerPalm)) or ((309 + 368) == (3082 - 1648))) then
					if (((134 + 2693) == (6 + 2821)) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "tiger_palm serenity_st 6";
					end
				end
				if (((305 + 2251) == (6232 - 3676)) and v60.RisingSunKick:IsReady()) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(4 + 1)) or ((11959 - 8853) >= (2487 + 2445))) then
						return "rising_sun_kick serenity_st 12";
					end
				end
				v162 = 956 - (135 + 820);
			end
			if ((v162 == (139 - (118 + 18))) or ((52 + 1165) <= (2404 - 1901))) then
				if (v13:IsCasting(v60.FistsofFury) or ((200 + 241) >= (4087 + 784))) then
					if (((243 + 3508) > (730 + 1)) and v24(v62.StopFoF)) then
						return "fists_of_fury_cancel serenity_st 26";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(1324 - (741 + 552), 1 + 1)) or ((3338 - 823) < (1639 + 165))) then
					if (((3892 - (779 + 105)) > (3705 - (1451 + 330))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1877 - (1259 + 610)))) then
						return "spinning_crane_kick serenity_st 28";
					end
				end
				if (((1145 - (4 + 846)) == (2152 - (1108 + 749))) and v60.StrikeoftheWindlord:IsReady() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff))) then
					if (((6569 - (1301 + 440)) >= (2634 - 909)) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(7 + 2))) then
						return "strike_of_the_windlord serenity_st 30";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(3 + 27, 2 + 0)) or ((4677 - (168 + 308)) < (4421 - 2271))) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(3 + 2)) or ((4423 - (469 + 878)) >= (4663 + 3))) then
						return "blackout_kick serenity_st 32";
					end
				end
				v162 = 14 - 10;
			end
		end
	end
	local function v119()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (1 + 0)) or ((4858 - 2831) >= (2979 + 51))) then
				if (((12871 - 9626) <= (5406 - (1332 + 508))) and v60.FistsofFury:IsReady()) then
					if (v84.CastTargetIf(v60.FistsofFury, v64, "max", v101, nil, not v14:IsInMeleeRange(1 + 7)) or ((630 + 1997) <= (197 + 184))) then
						return "fists_of_fury default_aoe 10";
					end
				end
				if (((1425 - (650 + 492)) < (5350 - (689 + 117))) and v60.SpinningCraneKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((463 + 155) < (9742 - 5922)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1931 - (794 + 1129)))) then
						return "spinning_crane_kick default_aoe 12";
					end
				end
				if (((4285 + 2) >= (24 + 100)) and v60.RisingSunKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(891 - (553 + 308), 3 - 1)) then
					if (((1858 + 711) <= (1153 + 2765)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1773 - (1764 + 4)))) then
						return "rising_sun_kick default_aoe 14";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (520 - (121 + 396))) and v60.ShadowboxingTreads:IsAvailable()) or ((3708 - (498 + 56)) <= (1912 + 118))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(18 - 13)) or ((3490 + 271) <= (2016 - 1334))) then
						return "blackout_kick default_aoe 16";
					end
				end
				v163 = 2 - 0;
			end
			if (((695 + 1433) > (1982 - 1146)) and (v163 == (1616 - (316 + 1300)))) then
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((2533 - (78 + 94)) <= (2479 - (261 + 1155)))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1464 - (1040 + 416))) or ((1833 - (29 + 14)) >= (6126 - 2905))) then
						return "spinning_crane_kick default_aoe 2";
					end
				end
				if (((5421 - (928 + 34)) >= (1031 + 2820)) and v60.SpinningCraneKick:IsReady() and not v60.HitCombo:IsAvailable() and v92() and v13:BuffUp(v60.BonedustBrewBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1 + 7)) or ((2909 + 60) <= (6833 - 4973))) then
						return "spinning_crane_kick default_aoe 4";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((6227 - 4104) == (64 - 25))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(519 - (69 + 441))) or ((5271 - 3139) <= (122 + 79))) then
						return "strike_of_the_windlord default_aoe 6";
					end
				end
				if ((v60.WhirlingDragonPunch:IsReady() and (v66 > (18 - 10))) or ((6218 - (517 + 1363)) >= (5405 - (802 + 126)))) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1673 - (1660 + 8))) or ((6222 - 4490) >= (3726 - (38 + 143)))) then
						return "whirling_dragon_punch default_aoe 8";
					end
				end
				v163 = 2 - 1;
			end
			if (((1242 - (29 + 88)) >= (128 - 64)) and (v163 == (492 - (308 + 181)))) then
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (v60.FistsofFury:CooldownRemains() < (1402 - (537 + 860))) and (v13:BuffStack(v60.ChiEnergyBuff) > (5 + 5))) or ((4310 - (691 + 404)) > (5959 - (870 + 1084)))) then
					if (((2544 - (47 + 82)) > (203 + 462)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1))) then
						return "spinning_crane_kick default_aoe 26";
					end
				end
				if ((v60.ChiBurst:IsCastable() and (v13:Chi() < (5 + 0)) and (v13:BloodlustUp() or (v13:Energy() < (160 - 110)))) or ((1206 - (84 + 33)) > (1027 + 1178))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(141 - 101), true) or ((257 + 1889) <= (1563 - 935))) then
						return "chi_burst default_aoe 28";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and ((v60.FistsofFury:CooldownRemains() > (8 - 5)) or (v13:Chi() > (9 - 7))) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff) and (v13:BloodlustUp() or v13:BuffUp(v60.InvokersDelightBuff))) or ((4897 - 1482) >= (5669 - (87 + 1133)))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(22 - 14)) or ((850 + 915) > (3845 + 465))) then
						return "spinning_crane_kick default_aoe 30";
					end
				end
				if (((1573 - (205 + 462)) > (66 + 134)) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick) and v13:HasTier(46 - 16, 1383 - (1035 + 346)) and v13:BuffDown(v60.BonedustBrewBuff) and (((v66 < (6 + 9)) and not v60.CraneVortex:IsAvailable()) or (v66 < (1788 - (970 + 810))))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0)) or ((8649 - 5577) <= (1476 + 657))) then
						return "blackout_kick default_aoe 32";
					end
				end
				v163 = 3 + 1;
			end
			if (((2405 - 1501) <= (5519 - 4119)) and (v163 == (1393 - (601 + 787)))) then
				if ((v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick) and not v92()) or ((1328 - (256 + 354)) > (7578 - 3715))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(18 - 13)) or ((6435 - 3952) == (4547 - 2324))) then
						return "blackout_kick default_aoe 42";
					end
				end
				if (((2346 - 941) >= (1981 - 1152)) and v60.ChiBurst:IsReady() and (((v13:ChiDeficit() >= (2 - 1)) and (v66 == (1 - 0))) or (v13:ChiDeficit() >= (4 - 2)))) then
					if (((3913 - (259 + 313)) < (6615 - 2752)) and v24(v60.ChiBurst, not v14:IsInRange(8 + 32), true)) then
						return "chi_burst default_aoe 44";
					end
				end
				break;
			end
			if (((1153 + 2687) > (681 + 319)) and (v163 == (5 - 3))) then
				if ((v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or ((3998 - (413 + 925)) < (979 + 929))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2)) or ((720 + 1568) > (9126 - 6615))) then
						return "blackout_kick default_aoe 18";
					end
				end
				if ((v60.WhirlingDragonPunch:IsReady() and (v66 >= (8 - 3))) or ((2203 + 1389) >= (12774 - 8365))) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1949 - (1164 + 780))) or ((6201 - (596 + 764)) < (3273 - (52 + 230)))) then
						return "whirling_dragon_punch default_aoe 20";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v13:HasTier(100 - 70, 1568 - (806 + 760)) or (v60.WhirlingDragonPunch:IsAvailable() and (v60.WhirlingDragonPunch:CooldownRemains() < (8 - 5)) and (v60.FistsofFury:CooldownRemains() > (4 - 1)) and v13:BuffDown(v60.KicksofFlowingMomentumBuff)))) or ((4662 - 1799) <= (924 + 1616))) then
					if (((694 + 2363) <= (18115 - 13293)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(8 - 3))) then
						return "rising_sun_kick default_aoe 22";
					end
				end
				if ((v60.ExpelHarm:IsReady() and (((v13:Chi() == (1 + 0)) and (v60.RisingSunKick:CooldownUp() or v60.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (2 + 0)) and v60.FistsofFury:CooldownUp()))) or ((6653 - (1000 + 965)) < (820 + 669))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(33 - 25)) or ((2234 - 1402) >= (2479 + 2291))) then
						return "expel_harm default_aoe 24";
					end
				end
				v163 = 1129 - (261 + 865);
			end
			if (((5757 - 3823) == (3045 - 1111)) and (v163 == (3 + 1))) then
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and ((v60.FistsofFury:CooldownRemains() > (548 - (33 + 512))) or (v13:Chi() > (1840 - (1555 + 281)))) and v92()) or ((10363 - 5839) <= (1373 + 1245))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(12 - 4)) or ((3089 + 1077) >= (11984 - 7815))) then
						return "spinning_crane_kick default_aoe 34";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((3207 + 518) < (125 - (34 + 5)))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((1725 + 3097) <= (108 + 45))) then
						return "rushing_jade_wind default_aoe 36";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (2 + 1))) or ((587 + 1229) > (7452 - 5159))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(11 - 6)) or ((4044 - (999 + 222)) >= (1048 + 2165))) then
						return "blackout_kick default_aoe 38";
					end
				end
				if (((1280 + 3422) > (2477 - (166 + 178))) and v60.StrikeoftheWindlord:IsReady()) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(3 + 6)) or ((9917 - 6582) <= (4501 - (587 + 713)))) then
						return "strike_of_the_windlord default_aoe 40";
					end
				end
				v163 = 4 + 1;
			end
		end
	end
	local function v120()
		local v164 = 1122 - (11 + 1111);
		while true do
			if (((3 + 1) == v164) or ((2053 + 1294) < (3245 - 1785))) then
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(1130 - (882 + 218), 2 + 0)) or ((5653 - (115 + 847)) < (12250 - 7879))) then
					if (((2227 - (1231 + 384)) == (1341 - 729)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1701 - (1202 + 494)))) then
						return "blackout_kick default_4t 26";
					end
				end
				if ((v60.ChiBurst:IsCastable() and (v13:Chi() < (183 - (12 + 166))) and (v13:BloodlustUp() or (v13:Energy() < (124 - 74)))) or ((3256 + 1584) <= (4774 - (202 + 402)))) then
					if (((853 + 493) == (2344 - (936 + 62))) and v24(v60.ChiBurst, not v14:IsInRange(388 - (119 + 229)), true)) then
						return "chi_burst default_4t 28";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and ((v60.FistsofFury:CooldownRemains() > (7 - 4)) or (v13:Chi() > (14 - 10))) and v92()) or ((183 + 2837) <= (6158 - 3407))) then
					if (((5260 - (513 + 923)) > (5444 - (507 + 1270))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(4 + 4))) then
						return "spinning_crane_kick default_4t 30";
					end
				end
				v164 = 19 - 14;
			end
			if ((v164 == (4 + 1)) or ((11623 - 8575) > (5608 - 1778))) then
				if (v60.WhirlingDragonPunch:IsReady() or ((2886 - (644 + 125)) < (550 + 500))) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1852 - (718 + 1129))) or ((935 + 164) == (5560 - 3750))) then
						return "whirling_dragon_punch default_4t 32";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1412 - (564 + 845)))) or ((13780 - 8888) == (3870 - (46 + 116)))) then
					if (((3043 - (575 + 75)) > (1503 - 886)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(15 - 10))) then
						return "blackout_kick default_4t 34";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((4703 - 3351) > (845 + 1569))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(5 + 3)) or ((328 + 1256) == (1635 + 648))) then
						return "rushing_jade_wind default_4t 36";
					end
				end
				v164 = 676 - (224 + 446);
			end
			if (((53 + 2020) < (284 + 2561)) and (v164 == (0 - 0))) then
				if (((3212 - (56 + 262)) <= (11985 - 8692)) and v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < (703 - (666 + 35))) and ((v60.FistsofFury:CooldownRemains() < (2 - 1)) or (v60.StrikeoftheWindlord:CooldownRemains() < (1181 - (553 + 627)))) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (1476 - (936 + 537)))) then
					if (((215 + 1060) > (2142 - (737 + 463))) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "tiger_palm default_4t 2";
					end
				end
				if (((1857 - (424 + 243)) < (941 + 3167)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((8927 - 6523) <= (3821 - (1213 + 133))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(13 - 5))) then
						return "spinning_crane_kick default_4t 4";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) or ((1115 + 985) <= (695 - (37 + 23)))) then
					if (((10753 - 7786) > (1539 - (122 + 1221))) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(251 - (139 + 103)))) then
						return "strike_of_the_windlord default_4t 6";
					end
				end
				v164 = 1 + 0;
			end
			if ((v164 == (1 + 0)) or ((6900 - 2211) < (1598 + 1449))) then
				if (v60.FistsofFury:IsReady() or ((242 + 180) <= (85 + 326))) then
					if (v84.CastTargetIf(v60.FistsofFury, v64, "max", v101, nil, not v14:IsInMeleeRange(114 - (9 + 97))) or ((4618 - 2142) > (1312 + 1587))) then
						return "fists_of_fury default_4t 8";
					end
				end
				if (((765 + 547) == (1049 + 263)) and v60.RisingSunKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(99 - 69, 1077 - (657 + 418))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1985 - (448 + 1532))) or ((3756 - (110 + 143)) == (9627 - 6223))) then
						return "rising_sun_kick default_4t 10";
					end
				end
				if (((3227 - (549 + 394)) < (2179 + 2081)) and v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if (((1872 - (500 + 734)) <= (635 + 445)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "blackout_kick default_4t 12";
					end
				end
				v164 = 1 + 1;
			end
			if ((v164 == (671 - (343 + 322))) or ((1356 + 1084) == (1102 + 3039))) then
				if (((477 + 3899) > (10373 - 7414)) and v60.StrikeoftheWindlord:IsReady()) then
					if (((2799 - (297 + 834)) == (8328 - 6660)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(1 + 8))) then
						return "strike_of_the_windlord default_4t 38";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and ((v60.FistsofFury:CooldownRemains() > (7 - 4)) or (v13:Chi() > (3 + 1)))) or ((2946 + 412) >= (5690 - (494 + 292)))) then
					if (((283 + 2602) > (14144 - 11268)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1640 - (888 + 744)))) then
						return "spinning_crane_kick default_4t 40";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) or ((552 + 1973) == (3642 - (206 + 479)))) then
					if (((638 + 3345) > (1822 - (861 + 312))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(741 - (135 + 601)))) then
						return "blackout_kick default_4t 42";
					end
				end
				break;
			end
			if (((3058 - (1085 + 57)) == (3841 - (224 + 1701))) and (v164 == (1 + 1))) then
				if (((11307 - 7060) >= (3276 + 447)) and v60.SpinningCraneKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and v92()) then
					if (((4722 - 3276) < (2453 + 548)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(754 - (730 + 16)))) then
						return "spinning_crane_kick default_4t 14";
					end
				end
				if ((v60.RisingSunKick:IsReady() and v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and (v60.FistsofFury:CooldownRemains() > (5 + 0))) or ((4962 - (790 + 792)) < (1280 - (474 + 607)))) then
					if (((2024 - (129 + 401)) <= (6849 - 2285)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(123 - (51 + 67)))) then
						return "rising_sun_kick default_4t 16";
					end
				end
				if (((809 + 3447) > (582 - (93 + 20))) and v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (11 - 8)) and v60.ShadowboxingTreads:IsAvailable()) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(25 - (12 + 8))) or ((3925 - (161 + 37)) < (41 + 46))) then
						return "blackout_kick default_4t 18";
					end
				end
				v164 = 1560 - (507 + 1050);
			end
			if (((1172 - 563) <= (7470 - 3581)) and ((2 + 1) == v164)) then
				if ((v60.RisingSunKick:IsReady() and (v13:HasTier(9 + 21, 1 + 1))) or ((1157 + 1471) < (4401 - 2226))) then
					if (((3863 - (184 + 680)) == (1704 + 1295)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(14 - 9))) then
						return "rising_sun_kick default_4t 20";
					end
				end
				if ((v60.ExpelHarm:IsReady() and (((v13:Chi() == (1 + 0)) and (v60.RisingSunKick:CooldownUp() or v60.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (4 - 2)) and v60.FistsofFury:CooldownUp()))) or ((5766 - 2798) == (20 + 51))) then
					if (((4479 - (629 + 421)) < (2450 + 1014)) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(15 - 7))) then
						return "expel_harm default_4t 22";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (v60.FistsofFury:CooldownRemains() > (6 - 3)) and (v13:BuffStack(v60.ChiEnergyBuff) > (950 - (544 + 396)))) or ((4417 - 2080) <= (1414 - (904 + 87)))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(28 - 20)) or ((6249 - (1443 + 31)) == (1624 - 909))) then
						return "spinning_crane_kick default_4t 24";
					end
				end
				v164 = 1817 - (1110 + 703);
			end
		end
	end
	local function v121()
		if (((8926 - 5290) >= (629 + 1190)) and v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < (5 - 3)) and ((v60.RisingSunKick:CooldownRemains() < (2 - 1)) or (v60.FistsofFury:CooldownRemains() < (204 - (78 + 125))) or (v60.StrikeoftheWindlord:CooldownRemains() < (2 - 1))) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (5 - 2))) then
			if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(7 - 2)) or ((2925 - (1392 + 432)) >= (82 + 2311))) then
				return "tiger_palm default_3t 2";
			end
		end
		if (((3650 - 2303) == (218 + 1129)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
			if (((5145 - (963 + 439)) > (5035 - 2703)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1333 - (76 + 1249)))) then
				return "spinning_crane_kick default_3t 4";
			end
		end
		if (((4971 - (1165 + 586)) <= (6660 - (1916 + 12))) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:HasTier(1287 - (604 + 652), 7 - 3)) then
			if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(2 + 7)) or ((6213 - 1731) >= (1237 + 3725))) then
				return "strike_of_the_windlord default_3t 6";
			end
		end
		if (((7995 - 4528) >= (3066 - 636)) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (32 - 12)) or (v68 < (6 - 1)))) then
			if (((539 - (11 + 2)) > (1953 - (64 + 1378))) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(22 - 13))) then
				return "strike_of_the_windlord default_3t 8";
			end
		end
		if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1756 - (256 + 1497))) and v60.ShadowboxingTreads:IsAvailable()) or ((2859 - 729) == (2745 - (562 + 315)))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(19 - 14)) or ((3271 - (577 + 611)) > (2948 + 919))) then
				return "blackout_kick default_3t 10";
			end
		end
		if (v60.FistsofFury:IsReady() or ((8251 - 5161) >= (6118 - 2514))) then
			if (((3441 - (58 + 13)) < (2973 + 1180)) and v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(5 + 3))) then
				return "fists_of_fury default_3t 12";
			end
		end
		if (((4586 - (404 + 50)) == (4168 - (6 + 30))) and v60.RisingSunKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(1363 - (770 + 563), 2 + 0)) then
			if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((261 - (25 + 145)) >= (1850 + 898))) then
				return "rising_sun_kick default_3t 14";
			end
		end
		if (((2506 - (153 + 546)) >= (1604 + 121)) and v60.SpinningCraneKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick)) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(935 - (60 + 867))) or ((2264 - 1631) >= (3885 - (309 + 974)))) then
				return "spinning_crane_kick default_3t 16";
			end
		end
		if ((v60.RisingSunKick:IsReady() and v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff)) or ((176 + 201) >= (12648 - 7991))) then
			if (((6009 - (677 + 464)) > (1878 - (567 + 255))) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(7 - 2))) then
				return "rising_sun_kick default_3t 18";
			end
		end
		if ((v60.RisingSunKick:IsReady() and (v13:HasTier(39 - 9, 530 - (384 + 144)))) or ((2593 - (1030 + 191)) < (1495 - 734))) then
			if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(8 - 3)) or ((1792 + 1984) < (4167 - (326 + 531)))) then
				return "rising_sun_kick default_3t 20";
			end
		end
		if (((9561 - 5570) == (1351 + 2640)) and v60.ExpelHarm:IsReady() and (((v13:Chi() == (1 + 0)) and (v60.RisingSunKick:CooldownUp() or v60.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (4 - 2)) and v60.FistsofFury:CooldownUp()))) then
			if (((94 + 3444) >= (2994 + 311)) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(1629 - (1367 + 254)))) then
				return "expel_harm default_3t 22";
			end
		end
		if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (680 - (305 + 373)))) or ((1554 - 389) < (1410 - (129 + 190)))) then
			if (((11392 - 7610) == (7034 - 3252)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(4 + 1))) then
				return "blackout_kick default_3t 24";
			end
		end
		if (v60.StrikeoftheWindlord:IsReady() or ((2792 + 46) < (3025 - (210 + 79)))) then
			if (((6490 - 2839) == (9084 - 5433)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(677 - (32 + 640)))) then
				return "strike_of_the_windlord default_3t 26";
			end
		end
		if (((1103 + 279) > (392 + 285)) and v60.BlackoutKick:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60.ShadowboxingTreads:IsAvailable() or (v60.RisingSunKick:CooldownRemains() > (1 + 0)))) then
			if (((571 + 332) < (4480 - (847 + 914))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(14 - 9))) then
				return "blackout_kick default_3t 28";
			end
		end
		if (v60.WhirlingDragonPunch:IsReady() or ((4823 - 2678) > (5235 - (163 + 361)))) then
			if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(890 - (162 + 723))) or ((618 + 4230) <= (4718 - (258 + 143)))) then
				return "whirling_dragon_punch default_3t 30";
			end
		end
		if (((2796 - 2155) < (10453 - 5658)) and v60.ChiBurst:IsCastable() and (v13:Chi() < (19 - 14)) and (v13:BloodlustUp() or (v13:Energy() < (1741 - (486 + 1205))))) then
			if (v24(v60.ChiBurst, not v14:IsInRange(205 - (92 + 73)), true) or ((1860 + 1678) <= (961 + 223))) then
				return "chi_burst default_3t 32";
			end
		end
		if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (v60.FistsofFury:CooldownRemains() < (4 - 1)) and (v13:BuffStack(v60.ChiEnergyBuff) > (287 - (68 + 204)))) or ((6404 - 2594) > (450 + 4325))) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((16183 - 12782) <= (862 + 1353))) then
				return "spinning_crane_kick default_3t 36";
			end
		end
		if (((1286 + 1271) == (2114 + 443)) and v60.RisingSunKick:IsReady() and (v60.FistsofFury:CooldownRemains() > (320 - (20 + 296))) and (v13:Chi() > (3 + 0))) then
			if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(20 - 15)) or ((7937 - 5619) <= (2936 - 1001))) then
				return "rising_sun_kick default_3t 38";
			end
		end
		if (((2282 + 1167) == (808 + 2641)) and v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (7 - 4))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3)) or ((1219 + 130) >= (651 + 709))) then
				return "blackout_kick default_3t 34";
			end
		end
		if (((9894 - 6084) >= (1424 - 645)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v60.RisingSunKick:CooldownDown() and v60.FistsofFury:CooldownDown() and (v13:Chi() > (3 + 1)) and ((v60.StormEarthAndFire:IsAvailable() and not v60.BonedustBrew:IsAvailable()) or v60.Serenity:IsAvailable())) then
			if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(257 - (155 + 94))) or ((3393 - 970) == (2042 - (515 + 392)))) then
				return "spinning_crane_kick default_3t 40";
			end
		end
		if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v60.FistsofFury:CooldownDown()) or ((5038 - (7 + 319)) <= (1911 + 1033))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3)) or ((6083 - (292 + 1205)) <= (2115 - (13 + 39)))) then
				return "blackout_kick default_3t 42";
			end
		end
		if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((3129 + 460) <= (10328 - 7081))) then
			if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(29 - 21)) or ((2801 - (850 + 188)) < (2791 - (822 + 214)))) then
				return "rushing_jade_wind default_3t 44";
			end
		end
		if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v60.ShadowboxingTreads:IsAvailable() and not v92()) or ((4588 - (317 + 844)) < (2126 + 25))) then
			if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3)) or ((5019 - (508 + 682)) == (1478 + 1582))) then
				return "blackout_kick default_3t 46";
			end
		end
		if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (((v13:Chi() > (3 + 2)) and v60.StormEarthAndFire:IsAvailable()) or ((v13:Chi() > (549 - (127 + 418))) and v60.Serenity:IsAvailable()))) or ((671 - 421) == (902 - 531))) then
			if (((20618 - 16244) > (2363 - 993)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1128 - (690 + 430)))) then
				return "spinning_crane_kick default_3t 48";
			end
		end
	end
	local function v122()
		local v165 = 0 - 0;
		while true do
			if (((1431 + 2088) > (6103 - 2970)) and (v165 == (958 - (637 + 315)))) then
				if (((14293 - 9297) > (14854 - 10133)) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
					if (((12792 - 8769) >= (1913 + 806)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(12 - 7))) then
						return "blackout_kick default_2t 50";
					end
				end
				if (((263 - (13 + 7)) <= (665 + 3851)) and v60.FaelineStomp:IsCastable() and (v89(v60.FaelineStomp))) then
					if (((5907 - 2164) >= (4446 - 2576)) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(47 - 17))) then
						return "faeline_stomp default_2t 52";
					end
				end
				break;
			end
			if (((112 + 186) <= (2073 + 1245)) and (v165 == (356 - (44 + 307)))) then
				if (((1953 - (127 + 670)) < (2650 + 582)) and v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and v60.RisingSunKick:CooldownDown() and v60.FistsofFury:CooldownDown() and (v13:BuffDown(v60.BonedustBrewBuff) or (v91() < (585.5 - (375 + 209))))) then
					if (((2593 - (1673 + 143)) < (2416 + 114)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick default_2t 42";
					end
				end
				if (((5194 - (836 + 613)) >= (5779 - 3064)) and v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((6472 - (295 + 1235)) == (2255 - (328 + 212)))) then
						return "rushing_jade_wind default_2t 44";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and (v91() >= (4.7 - 2))) or ((3894 - (517 + 402)) > (9897 - 5473))) then
					if (((8204 - 5306) >= (2166 - (700 + 382))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(887 - (677 + 202)))) then
						return "spinning_crane_kick default_2t 46";
					end
				end
				if (v60.RisingSunKick:IsReady() or ((178 - 75) == (12018 - 7931))) then
					if (((2715 + 321) > (3335 - (360 + 393))) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v95, nil, not v14:IsInMeleeRange(16 - 11))) then
						return "rising_sun_kick default_2t 48";
					end
				end
				v165 = 1963 - (1231 + 726);
			end
			if ((v165 == (4 - 1)) or ((2165 - (173 + 1737)) > (2555 - (441 + 1506)))) then
				if ((v60.BlackoutKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and (v13:Chi() > (1 + 1)) and v13:PrevGCD(3 - 2, v60.RisingSunKick)) or ((4676 - (136 + 558)) <= (1111 + 1829))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1227 - (988 + 234))) or ((1774 + 2017) > (11486 - 6802))) then
						return "blackout_kick default_2t 26";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or ((3578 - (125 + 526)) <= (3298 - 2331))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((1880 - 1249) > (4055 - (290 + 836)))) then
						return "spinning_crane_kick default_2t 28";
					end
				end
				if ((v60.ChiBurst:IsCastable() and (v13:Chi() < (2 + 3)) and (v13:Energy() < (91 - 41))) or ((1021 - (8 + 672)) > (235 + 3721))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(1476 - (740 + 696)), true) or ((5888 - (353 + 693)) <= (1162 + 336))) then
						return "chi_burst default_2t 30";
					end
				end
				if (v60.StrikeoftheWindlord:IsReady() or ((2805 - (35 + 1458)) > (6820 - (1821 + 49)))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(25 - 16)) or ((2574 - (727 + 1007)) == (1378 - (165 + 2)))) then
						return "strike_of_the_windlord default_2t 32";
					end
				end
				v165 = 1663 - (1028 + 631);
			end
			if (((6114 - (311 + 1304)) > (3759 - 2175)) and (v165 == (1 + 0))) then
				if (((436 + 3272) <= (4800 - (512 + 67))) and v60.FistsofFury:IsReady() and not v13:HasTier(81 - 51, 1 + 1)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, "max", v101, nil, not v14:IsInMeleeRange(3 + 5)) or ((4860 - 1180) <= (1477 - 994))) then
						return "fists_of_fury default_2t 10";
					end
				end
				if (((148 + 1281) <= (9081 - 5888)) and v60.RisingSunKick:IsReady() and (v60.FistsofFury:CooldownUp())) then
					if (((4418 - (395 + 1394)) > (1768 - 1281)) and v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "rising_sun_kick default_2t 12";
					end
				end
				if (v60.FistsofFury:IsReady() or ((13229 - 8857) < (8546 - 5641))) then
					if (((1601 - (143 + 324)) > (1361 - 848)) and v84.CastTargetIf(v60.FistsofFury, v64, "max", v101, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "fists_of_fury default_2t 14";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v13:HasTier(89 - 59, 1 + 1))) or ((4536 - (342 + 761)) == (1777 + 773))) then
					if (((1118 - 711) <= (787 + 1210)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(7 - 2))) then
						return "rising_sun_kick default_2t 16";
					end
				end
				v165 = 3 - 1;
			end
			if (((3 + 1) == v165) or ((2612 - (889 + 268)) >= (1196 + 877))) then
				if ((v60.BlackoutKick:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60.ShadowboxingTreads:IsAvailable() or (v60.RisingSunKick:CooldownRemains() > (1 + 0)))) or ((8822 - 5349) > (4875 - (196 + 101)))) then
					if (((4586 - 2067) < (9388 - 6195)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick default_2t 34";
					end
				end
				if (v60.WhirlingDragonPunch:IsReady() or ((1496 - 1033) >= (12125 - 7188))) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(14 - 9)) or ((3386 + 605) <= (6196 - 2438))) then
						return "whirling_dragon_punch default_2t 36";
					end
				end
				if ((v60.RisingSunKick:IsReady() and not v60.ShadowboxingTreads:IsAvailable() and (v60.FistsofFury:CooldownRemains() > (1587 - (431 + 1152))) and v60.XuensBattlegear:IsAvailable()) or ((3743 + 644) <= (2644 - (107 + 237)))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1805 - (690 + 1110))) or ((6552 - 2251) == (4157 - (1374 + 123)))) then
						return "rising_sun_kick default_2t 40";
					end
				end
				if (((3629 - 2039) <= (1116 + 1961)) and v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (3 + 0))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((5710 - (454 + 1149)) <= (2063 - 1034))) then
						return "blackout_kick default_2t 38";
					end
				end
				v165 = 11 - 6;
			end
			if ((v165 == (1 + 1)) or ((1835 + 8) == (4513 - (21 + 616)))) then
				if (((9842 - 5127) >= (45 + 1113)) and v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.KicksofFlowingMomentumBuff) or v13:BuffUp(v60.PressurePointBuff))) then
					if (((2426 - (125 + 312)) == (1484 + 505)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "rising_sun_kick default_2t 18";
					end
				end
				if ((v60.ExpelHarm:IsReady() and (((v13:Chi() == (1109 - (266 + 842))) and (v60.RisingSunKick:CooldownUp() or v60.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (640 - (395 + 243))) and v60.FistsofFury:CooldownUp()))) or ((2180 + 982) == (5138 - (383 + 652)))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(23 - 15)) or ((1895 + 1352) == (2543 + 1857))) then
						return "expel_harm default_2t 20";
					end
				end
				if (((4404 - (114 + 529)) > (2650 + 95)) and v60.ChiBurst:IsCastable() and v13:BloodlustUp() and (v13:Chi() < (4 + 1))) then
					if (((1961 - (352 + 837)) < (17063 - 12887)) and v24(v60.ChiBurst, not v14:IsInRange(590 - (465 + 85)), true)) then
						return "chi_burst default_2t 22";
					end
				end
				if (((3297 - (366 + 165)) >= (208 + 446)) and v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (6 - 4))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(16 - 11)) or ((652 + 4175) == (4035 - (521 + 1144)))) then
						return "blackout_kick default_2t 24";
					end
				end
				v165 = 5 - 2;
			end
			if ((v165 == (0 + 0)) or ((2576 - (5 + 85)) > (4544 - (1547 + 146)))) then
				if ((v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < (6 - 4)) and ((v60.RisingSunKick:CooldownRemains() < (318 - (272 + 45))) or (v60.FistsofFury:CooldownRemains() < (2 - 1)) or (v60.StrikeoftheWindlord:CooldownRemains() < (1 + 0))) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (4 - 1))) or ((247 + 3737) == (615 + 1014))) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(5 + 0)) or ((914 + 1559) > (4671 - (997 + 299)))) then
						return "tiger_palm default_2t 2";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1290 - (903 + 384))) and v60.ShadowboxingTreads:IsAvailable()) or ((500 + 4386) == (524 + 1447))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(5 + 0)) or ((5065 - 2471) <= (4525 - 3095))) then
						return "blackout_kick default_2t 4";
					end
				end
				if (((1464 + 3349) > (5940 - 1395)) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and v13:HasTier(20 + 11, 593 - (313 + 276))) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(1 + 8)) or ((5243 - (168 + 160)) < (6349 - (1452 + 4)))) then
						return "strike_of_the_windlord default_2t 6";
					end
				end
				if (((19137 - 14994) == (4563 - (338 + 82))) and v60.StrikeoftheWindlord:IsReady() and v60.Thunderfist:IsAvailable() and ((v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (593 - (133 + 440))) or (v68 < (2 + 3)))) then
					if (((1751 - 528) < (155 + 3259)) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, "max", v101, nil, not v14:IsInMeleeRange(2 + 7))) then
						return "strike_of_the_windlord default_2t 8";
					end
				end
				v165 = 1 + 0;
			end
		end
	end
	local function v123()
		local v166 = 1302 - (422 + 880);
		while true do
			if (((2430 - (365 + 1615)) < (3577 - 1060)) and (v166 == (1356 - (479 + 873)))) then
				if (((166 + 2069) == (6272 - 4037)) and v60.BlackoutKick:IsReady() and v13:BuffUp(v60.BlackoutReinforcementBuff) and v60.RisingSunKick:CooldownDown() and v60.StrikeoftheWindlord:CooldownDown() and v89(v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (((2553 - 1626) <= (606 + 1911)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "blackout_kick default_st 26";
					end
				end
				if (v60.FistsofFury:IsReady() or ((3575 - (832 + 670)) > (13864 - 9747))) then
					if (v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(23 - 15)) or ((4262 - (707 + 540)) > (4725 - (18 + 41)))) then
						return "fists_of_fury default_st 28";
					end
				end
				if (((940 + 99) < (3187 + 1083)) and v60.BlackoutKick:IsReady() and v13:BuffUp(v60.BlackoutReinforcementBuff) and v89(v60.BlackoutKick)) then
					if (((1345 - (554 + 666)) < (2581 - (438 + 62))) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1910 - (1497 + 408)))) then
						return "blackout_kick default_st 30";
					end
				end
				v166 = 7 - 2;
			end
			if (((5 + 3) == v166) or ((1075 + 794) == (5540 - (508 + 132)))) then
				if ((v60.RushingJadeWind:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or ((5623 - 3846) >= (4066 - 754))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(1215 - (49 + 1158))) or ((176 + 994) > (2619 - 722))) then
						return "rushing_jade_wind default_st 50";
					end
				end
				if (((302 + 586) >= (530 + 222)) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(11 - 6)) or ((1458 + 1631) > (5244 - (460 + 761)))) then
						return "blackout_kick default_st 52";
					end
				end
				break;
			end
			if (((15 - 9) == v166) or ((3865 + 985) == (94 + 1352))) then
				if ((v60.ChiBurst:IsCastable() and (v13:Chi() < (601 - (405 + 191))) and (v13:Energy() < (1720 - (311 + 1359)))) or ((7229 - 4125) == (694 + 327))) then
					if (((84 + 1500) < (733 + 3695)) and v24(v60.ChiBurst, not v14:IsInRange(6 + 34), true)) then
						return "chi_burst default_st 38";
					end
				end
				if (((789 + 535) < (3118 - 1190)) and v60.StrikeoftheWindlord:IsReady() and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (8 + 22)) or (v68 < (8 - 3)))) then
					if (((783 + 3846) == (8600 - 3971)) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(11 - 2))) then
						return "strike_of_the_windlord default_st 40";
					end
				end
				if (((4431 - (1408 + 112)) < (4883 - (285 + 697))) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and not v13:HasTier(148 - 117, 1262 - (737 + 523))) then
					if (((1719 - 1340) < (195 + 1162)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(852 - (789 + 55)))) then
						return "spinning_crane_kick default_st 42";
					end
				end
				v166 = 22 - 15;
			end
			if ((v166 == (1 + 0)) or ((2815 - 1422) <= (655 - 293))) then
				if (((1237 + 223) == (4088 - 2628)) and v60.RisingSunKick:IsReady() and (v60.FistsofFury:CooldownUp())) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(1887 - (1492 + 390))) or ((6083 - 2567) <= (2353 - (312 + 681)))) then
						return "rising_sun_kick default_st 8";
					end
				end
				if ((v60.FistsofFury:IsReady() and v13:BuffDown(v60.PressurePointBuff) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (1966 - (1255 + 656)))) or ((3617 - (485 + 1242)) <= (25 + 98))) then
					if (v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(18 - 10)) or ((2600 - 917) >= (12162 - 9089))) then
						return "fists_of_fury default_st 10";
					end
				end
				if ((v60.FaelineStomp:IsCastable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (3 - 2)) and (v14:DebuffRemains(v60.FaeExposureDebuff) < (6 - 3))) or ((446 + 1476) >= (3628 - (722 + 237)))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(84 - 54)) or ((846 - (77 + 639)) == (10012 - 6732))) then
						return "faeline_stomp default_st 12";
					end
				end
				v166 = 9 - 7;
			end
			if ((v166 == (5 - 2)) or ((14415 - 9485) <= (11914 - 7725))) then
				if (((1015 + 152) < (56 + 1433)) and v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.KicksofFlowingMomentumBuff) or v13:BuffUp(v60.PressurePointBuff) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (1414 - (888 + 471))))) then
					if (((5165 - (1034 + 75)) >= (1827 - (448 + 709))) and v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "rising_sun_kick default_st 20";
					end
				end
				if (((1165 - 836) < (2317 - (1643 + 212))) and v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (483 - (320 + 160)))) then
					if (((6960 - 3677) > (2804 - 1719)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick default_st 22";
					end
				end
				if (v60.RisingSunKick:IsReady() or ((1413 - 654) > (4256 - (114 + 22)))) then
					if (((6 + 196) < (4122 - (89 + 970))) and v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(1733 - (1083 + 645)))) then
						return "rising_sun_kick default_st 24";
					end
				end
				v166 = 170 - (50 + 116);
			end
			if (((1962 - (1058 + 904)) == v166) or ((3521 - 1918) > (18381 - 13777))) then
				if ((v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < (7 - 5)) and ((v60.RisingSunKick:CooldownRemains() < (2 - 1)) or (v60.FistsofFury:CooldownRemains() < (1 + 0)) or (v60.StrikeoftheWindlord:CooldownRemains() < (197 - (94 + 102)))) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (3 + 0))) or ((3856 - (735 + 529)) <= (2745 - (875 + 276)))) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(984 - (461 + 518))) or ((1888 + 307) >= (15153 - 10157))) then
						return "tiger_palm default_st 2";
					end
				end
				if ((v60.ExpelHarm:IsReady() and (((v13:Chi() == (782 - (656 + 125))) and (v60.RisingSunKick:CooldownUp() or v60.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (4 - 2)) and v60.FistsofFury:CooldownUp() and v60.RisingSunKick:CooldownDown()))) or ((1778 - (532 + 316)) <= (1064 - (150 + 104)))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(16 + 4)) or ((13849 - 9055) < (4545 - (564 + 1283)))) then
						return "expel_harm default_st 4";
					end
				end
				if ((v60.StrikeoftheWindlord:IsReady() and ((v13:BuffUp(v60.DomineeringArroganceBuff) and v60.Thunderfist:IsAvailable() and v60.Serenity:IsAvailable() and (v60.InvokeXuenTheWhiteTiger:CooldownRemains() > (12 + 8))) or (v68 < (13 - 8)) or (v60.Thunderfist:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (4 + 6)) and v13:BuffDown(v60.DomineeringArroganceBuff)) or (v60.Thunderfist:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (3 + 32)) and not v60.Serenity:IsAvailable()))) or ((2045 - 1490) <= (2099 - (330 + 1218)))) then
					if (((145 + 116) < (3254 + 615)) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(7 + 2))) then
						return "strike_of_the_windlord default_st 6";
					end
				end
				v166 = 1 + 0;
			end
			if ((v166 == (9 - 2)) or ((170 + 164) > (13330 - 10280))) then
				if (((965 + 2688) <= (6376 - (511 + 1058))) and v60.BlackoutKick:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60.RisingSunKick:CooldownRemains() > (2 - 1))) then
					if (((4864 - (1315 + 183)) <= (1329 + 2294)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(547 - (233 + 309)))) then
						return "blackout_kick default_st 44";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and (v91() >= (2.7 - 0))) or ((5277 - (267 + 386)) == (4473 - 2552))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(861 - (744 + 109))) or ((3638 - (1271 + 279)) < (5154 - 3140))) then
						return "spinning_crane_kick default_st 46";
					end
				end
				if (v60.WhirlingDragonPunch:IsReady() or ((4941 - (642 + 1002)) > (6553 - (643 + 1220)))) then
					if (((1138 - 746) <= (5390 - 2098)) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1422 - (1063 + 354)))) then
						return "whirling_dragon_punch default_st 48";
					end
				end
				v166 = 838 - (739 + 91);
			end
			if ((v166 == (2 - 0)) or ((1996 - (790 + 1087)) >= (4062 + 469))) then
				if ((v60.RisingSunKick:IsReady() and (v13:BuffUp(v60.PressurePointBuff) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (139 - 84)))) or ((8267 - 5792) > (9917 - 6054))) then
					if (((7649 - 5460) >= (6010 - 4285)) and v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(154 - (82 + 67)))) then
						return "rising_sun_kick default_st 14";
					end
				end
				if (((1676 + 41) < (6676 - 3271)) and v60.BlackoutKick:IsReady() and v13:BuffUp(v60.PressurePointBuff) and (v13:Chi() > (1987 - (1835 + 150))) and v13:PrevGCD(15 - (12 + 2), v60.RisingSunKick)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1041 - (784 + 252))) or ((42 + 76) == (3282 - 1402))) then
						return "blackout_kick default_st 16";
					end
				end
				if (((2713 + 519) > (2474 - (1134 + 250))) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:HasTier(21 + 10, 1 + 1) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (((5824 - 2599) > (1237 + 607)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(22 - 14))) then
						return "spinning_crane_kick default_st 18";
					end
				end
				v166 = 7 - 4;
			end
			if ((v166 == (10 - 5)) or ((4703 - (1940 + 41)) >= (5011 - (39 + 199)))) then
				if (((1416 + 335) > (795 - 412)) and v60.WhirlingDragonPunch:IsReady() and (v13:BuffDown(v60.PressurePointBuff))) then
					if (((2102 - 838) < (6156 - (313 + 1616))) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(15 - 10))) then
						return "whirling_dragon_punch default_st 32";
					end
				end
				if (((1392 - 428) == (1964 - 1000)) and v60.ChiBurst:IsCastable() and v13:BloodlustUp() and (v13:Chi() < (42 - (7 + 30)))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(1226 - (961 + 225)), true) or ((19686 - 15089) == (1456 + 1270))) then
						return "chi_burst default_st 34";
					end
				end
				if ((v60.BlackoutKick:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (842 - (281 + 559))) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > (2 - 1))) or ((710 + 3598) == (406 + 4217))) then
					if (((650 + 1599) > (7 + 539)) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1445 - (102 + 1338)))) then
						return "blackout_kick default_st 36";
					end
				end
				v166 = 2 + 4;
			end
		end
	end
	local function v124()
		local v167 = 0 + 0;
		while true do
			if (((3145 - (319 + 122)) <= (658 + 2983)) and (v167 == (999 - (45 + 951)))) then
				if ((v60.ArcaneTorrent:IsCastable() and (v13:ChiDeficit() >= (1 + 0))) or ((166 + 4111) <= (596 + 800))) then
					if (v22(v60.ArcaneTorrent, nil) or ((6951 - 2771) <= (9 + 357))) then
						return "arcane_torrent fallthru 20";
					end
				end
				if (v60.TigerPalm:IsReady() or ((62 + 87) >= (5861 - (684 + 691)))) then
					if (((2290 - (1161 + 483)) < (2003 - (245 + 721))) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "tiger_palm fallthru 24";
					end
				end
				break;
			end
			if (((2764 + 834) <= (3780 - (31 + 11))) and (v167 == (3 - 2))) then
				if ((v60.ExpelHarm:IsReady() and (v13:ChiDeficit() >= (3 - 2)) and (v66 > (838 - (179 + 657)))) or ((1150 - (150 + 177)) >= (531 + 384))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(1213 - (142 + 1063))) or ((6867 - (1346 + 559)) <= (917 + 3448))) then
						return "expel_harm fallthru 8";
					end
				end
				if ((v60.ChiBurst:IsCastable() and (((v13:ChiDeficit() >= (2 - 1)) and (v66 == (3 - 2))) or ((v13:ChiDeficit() >= (2 + 0)) and (v66 >= (1728 - (1695 + 31)))))) or ((179 + 464) >= (2926 - (1073 + 364)))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(857 - (405 + 412)), true) or ((1124 - (518 + 131)) == (5477 - (667 + 635)))) then
						return "chi_burst fallthru 10";
					end
				end
				if (v60.ChiWave:IsCastable() or ((2 + 2784) < (187 - 66))) then
					if (((3806 - (1397 + 513)) <= (4757 - 1942)) and v22(v60.ChiWave, nil, nil, not v14:IsInRange(1115 - (454 + 621)))) then
						return "chi_wave fallthru 12";
					end
				end
				v167 = 3 - 1;
			end
			if ((v167 == (1 + 1)) or ((4820 - 2762) == (2946 - (417 + 181)))) then
				if ((v60.ExpelHarm:IsReady() and (v13:ChiDeficit() >= (1 - 0))) or ((1024 + 2505) <= (6381 - 4622))) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(39 - 31)) or ((1478 - (995 + 125)) == (4804 - 2923))) then
						return "expel_harm fallthru 14";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v66 >= (3 + 2))) or ((5121 - 3118) == (4096 - (754 + 571)))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v98, nil, not v14:IsInMeleeRange(1 + 4)) or ((7601 - 5002) < (911 + 1457))) then
						return "blackout_kick fallthru 16";
					end
				end
				if (((9312 - 6555) >= (1123 + 967)) and v60.SpinningCraneKick:IsReady() and ((v89(v60.SpinningCraneKick) and (v13:BuffStack(v60.ChiEnergyBuff) > ((111 - 81) - ((2 + 3) * v66))) and v13:BuffDown(v60.StormEarthAndFireBuff) and (((v60.RisingSunKick:CooldownRemains() > (1493 - (1141 + 350))) and (v60.FistsofFury:CooldownRemains() > (1 + 1))) or ((v60.RisingSunKick:CooldownRemains() < (2 + 1)) and (v60.FistsofFury:CooldownRemains() > (8 - 5)) and (v13:Chi() > (1 + 2))) or ((v60.RisingSunKick:CooldownRemains() > (8 - 5)) and (v60.FistsofFury:CooldownRemains() < (3 + 0)) and (v13:Chi() > (1873 - (513 + 1356)))) or ((v13:ChiDeficit() <= (1937 - (196 + 1740))) and (v87() < (2 - 0))))) or ((v13:BuffStack(v60.ChiEnergyBuff) > (7 + 3)) and (v68 < (13 - 6))))) then
					if (((1294 - 568) < (948 + 603)) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(18 - 10))) then
						return "spinning_crane_kick fallthru 18";
					end
				end
				v167 = 1 + 2;
			end
			if (((6368 - 3980) >= (3577 - (362 + 1269))) and (v167 == (0 - 0))) then
				if ((v60.CracklingJadeLightning:IsReady() and (((v13:BuffStack(v60.TheEmperorsCapacitorBuff) > (56 - (26 + 11))) and (v87() > (v60.CracklingJadeLightning:ExecuteTime() - (1 + 0))) and (v60.RisingSunKick:CooldownRemains() > v60.CracklingJadeLightning:ExecuteTime())) or ((v13:BuffStack(v60.TheEmperorsCapacitorBuff) > (2 + 12)) and (((v60.Serenity:CooldownRemains() < (1824 - (183 + 1636))) and v60.Serenity:IsAvailable()) or (v68 < (4 + 1)))))) or ((3355 + 1416) == (4470 - (1161 + 69)))) then
					if (v22(v60.CracklingJadeLightning, nil, nil, not v14:IsSpellInRange(v60.CracklingJadeLightning)) or ((3260 - (672 + 706)) <= (24 + 74))) then
						return "crackling_jade_lightning fallthru 2";
					end
				end
				if (((4403 - (82 + 23)) > (5818 - (100 + 1421))) and v60.FaelineStomp:IsCastable() and (v89(v60.FaelineStomp))) then
					if (((2982 - (61 + 719)) < (5380 - (180 + 232))) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(22 + 8))) then
						return "faeline_stomp fallthru 4";
					end
				end
				if (((621 - 233) >= (405 - 238)) and v60.TigerPalm:IsReady() and v89(v60.TigerPalm) and (v13:ChiDeficit() >= ((1783 - (728 + 1053)) + v27(v13:BuffUp(v60.PowerStrikesBuff))))) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(5 + 0)) or ((1214 - (427 + 132)) == (2564 + 637))) then
						return "tiger_palm fallthru 6";
					end
				end
				v167 = 966 - (786 + 179);
			end
		end
	end
	local function v125()
		local v168 = 0 + 0;
		while true do
			if (((1014 + 2597) >= (1285 - 327)) and ((5 + 0) == v168)) then
				if (((5543 - (1685 + 239)) == (8435 - 4816)) and v60.StrikeoftheWindlord:IsReady() and (v66 >= (6 - 3))) then
					if (((8981 - 5164) >= (4671 - 2712)) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(24 - 15))) then
						return "strike_of_the_windlord serenity 28";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v66 == (2 + 0)) and (v60.FistsofFury:CooldownRemains() > (1182 - (457 + 720)))) or ((7146 - 4194) > (12249 - 8450))) then
					if (((897 - (124 + 597)) <= (8269 - 6612)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v95, nil, not v14:IsInMeleeRange(569 - (414 + 150)))) then
						return "rising_sun_kick serenity 30";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v66 == (9 - 7)) and (v60.FistsofFury:CooldownRemains() > (834 - (592 + 237))) and v60.ShadowboxingTreads:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 0))) or ((4065 - 2449) >= (4699 - (122 + 491)))) then
					if (((12251 - 9601) >= (1861 - (116 + 169))) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(19 - 14))) then
						return "blackout_kick serenity 32";
					end
				end
				v168 = 6 + 0;
			end
			if (((254 + 63) < (5900 - 2204)) and (v168 == (2 - 0))) then
				if (((253 + 3131) == (4614 - (477 + 753))) and v60.StrikeoftheWindlord:IsReady() and (v60.Thunderfist:IsAvailable())) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(2 + 7)) or ((3271 + 456) < (902 + 1240))) then
						return "strike_of_the_windlord serenity 2";
					end
				end
				if (((1606 + 74) < (8577 - 5994)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and (v66 >= (1 + 1))) then
					if (((3389 - (649 + 728)) < (3072 - (478 + 434))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(16 - 8))) then
						return "spinning_crane_kick serenity 14";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (v66 == (4 - 0)) and v13:BuffUp(v60.PressurePointBuff)) or ((11044 - 8702) == (3633 + 58))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v95, nil, not v14:IsInMeleeRange(1565 - (1329 + 231))) or ((9594 - 4808) <= (2148 - (1523 + 387)))) then
						return "rising_sun_kick serenity 16";
					end
				end
				v168 = 4 - 1;
			end
			if (((2010 + 1440) <= (5870 - (1013 + 294))) and ((1348 - (25 + 1323)) == v168)) then
				if (((178 + 84) <= (5086 - (611 + 1319))) and v60.FistsofFury:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < (1 + 0))) then
					if (((4538 - 2154) < (2385 + 1697)) and v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "fists_of_fury serenity 2";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and not v92() and (v66 > (3 + 1)) and v60.ShadowboxingTreads:IsAvailable()) or ((7993 - 4136) < (1073 + 1094))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(4 + 1)) or ((5254 - (353 + 463)) == (3824 - 1894))) then
						return "blackout_kick serenity 4";
					end
				end
				if ((v60.RisingSunKick:IsReady() and (((v66 == (3 + 1)) and v13:BuffUp(v60.PressurePointBuff) and not v60.BonedustBrew:IsAvailable()) or (v66 == (1062 - (605 + 456))) or ((v66 <= (8 - 5)) and v13:BuffUp(v60.PressurePointBuff)) or (v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(814 - (122 + 662), 1494 - (1184 + 308))))) or ((2012 - (445 + 723)) < (1924 - (1245 + 395)))) then
					if (((2238 - (191 + 936)) <= (2821 - 1577)) and v84.CastTargetIf(v60.RisingSunKick, v64, "min", v95, nil, not v14:IsInMeleeRange(8 - 3))) then
						return "rising_sun_kick serenity 8";
					end
				end
				v168 = 1 + 0;
			end
			if ((v168 == (264 - (90 + 168))) or ((4141 - (87 + 84)) <= (5101 - 2772))) then
				if (((1901 - (176 + 536)) < (2234 + 787)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (v66 > (1699 - (858 + 840)))) then
					if (((4828 - (447 + 213)) > (5091 - (1458 + 2))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(37 - 29))) then
						return "spinning_crane_kick serenity 34";
					end
				end
				if (((5087 - 2171) <= (2364 + 1663)) and v60.WhirlingDragonPunch:IsReady() and (v66 > (1 + 0))) then
					if (((4014 - 2442) <= (4555 - (248 + 232))) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(235 - (109 + 121)))) then
						return "whirling_dragon_punch serenity 36";
					end
				end
				if ((v60.RushingJadeWind:IsReady() and v13:BuffDown(v60.RushingJadeWindBuff) and (v66 >= (1 + 2))) or ((3214 - (1288 + 116)) > (4789 + 75))) then
					if (((1765 - (212 + 24)) < (2978 + 1542)) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(6 + 2))) then
						return "rushing_jade_wind serenity 38";
					end
				end
				v168 = 1714 - (1175 + 532);
			end
			if ((v168 == (7 + 1)) or ((2952 - 972) == (728 + 681))) then
				if (((1640 + 425) == (2634 - (252 + 317))) and v60.WhirlingDragonPunch:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(10 - 5)) or ((2475 - (738 + 65)) >= (5141 - (410 + 147)))) then
						return "whirling_dragon_punch serenity 46";
					end
				end
				if ((v60.TigerPalm:IsReady() and v60.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (903 - (272 + 628)))) or ((3093 - 1832) < (2885 - 1830))) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(173 - (62 + 106))) or ((1880 - 1225) <= (1204 - (167 + 527)))) then
						return "tiger_palm serenity 48";
					end
				end
				break;
			end
			if (((8501 - 4357) >= (3714 - 1401)) and (v168 == (4 - 1))) then
				if (((1319 + 1153) <= (4319 - (326 + 740))) and v60.BlackoutKick:IsReady() and (v66 == (79 - (68 + 8))) and v89(v60.BlackoutKick) and v13:HasTier(1501 - (133 + 1338), 5 - 3)) then
					if (((821 + 735) < (1561 + 1631)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(17 - 12))) then
						return "blackout_kick serenity ";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and (v66 >= (2 + 1)) and v92()) or ((2991 + 1784) < (3950 - 2490))) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1995 - (1930 + 57))) or ((56 + 451) >= (2758 + 688))) then
						return "spinning_crane_kick serenity 20";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v66 > (1 + 0)) and (v66 < (908 - (14 + 890))) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (6 - 4))) or ((253 + 3023) < (5219 - 3028))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(4 + 1)) or ((16037 - 12596) <= (11392 - 8000))) then
						return "blackout_kick serenity 18";
					end
				end
				v168 = 1 + 3;
			end
			if (((3825 - 2890) < (925 + 15)) and (v168 == (1788 - (755 + 1026)))) then
				if (((4429 - 2952) < (11554 - 9049)) and v60.RisingSunKick:IsReady()) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, "min", v95, nil, not v14:IsInMeleeRange(951 - (217 + 729))) or ((668 + 3430) < (493 + 1646))) then
						return "rising_sun_kick serenity 40";
					end
				end
				if (((183 - 85) == (273 - 175)) and v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((8375 - 6290) == (4137 - (619 + 1061)))) then
						return "spinning_crane_kick serenity 42";
					end
				end
				if (((1 + 471) < (4633 - 2538)) and v60.BlackoutKick:IsReady() and (v89(v60.BlackoutKick))) then
					if (((3362 - (108 + 28)) < (5477 - (191 + 1736))) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(768 - (757 + 6)))) then
						return "blackout_kick serenity 44";
					end
				end
				v168 = 2 + 6;
			end
			if ((v168 == (1256 - (337 + 918))) or ((869 - 483) > (153 + 760))) then
				if ((v60.BlackoutKick:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == (1 + 2)) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < (2 - 1))) or ((674 + 4121) < (2779 - (754 + 922)))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(639 - (487 + 147))) or ((6633 - 1749) <= (6241 - (825 + 744)))) then
						return "blackout_kick serenity 6";
					end
				end
				if (((12 + 4525) >= (2818 + 179)) and v60.FistsofFury:IsReady() and ((v13:BuffUp(v60.InvokersDelightBuff) and (((v66 < (6 - 3)) and v60.JadeIgnition:IsAvailable()) or (v66 > (2 + 2)))) or v13:BloodlustUp() or (v66 == (251 - (150 + 99))))) then
					if (v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(6 + 2)) or ((2347 - (1335 + 168)) >= (5521 - (256 + 683)))) then
						return "fists_of_fury serenity 10";
					end
				end
				if (((5120 - (33 + 285)) == (15796 - 10994)) and v60.FistsofFury:IsReady()) then
					local v213 = 0 - 0;
					local v214;
					while true do
						if (((12244 - 7487) >= (86 + 4428)) and (v213 == (0 + 0))) then
							v214 = v94();
							if (((5393 - (776 + 171)) <= (4723 - (244 + 19))) and v214) then
								if (((1273 - 429) >= (993 - (8 + 398))) and (v214:GUID() == v14:GUID())) then
									if (((985 - (228 + 288)) >= (284 - 54)) and v24(v60.FistsofFury)) then
										return "fists_of_fury one_gcd serenity 14";
									end
								elseif (((4720 - 2191) < (257 + 2940)) and v31) then
									if ((((GetTime() - v84.LastTargetSwap) * (1588 - (434 + 154))) >= v34) or ((35 + 34) >= (6646 - 3813))) then
										local v258 = 0 - 0;
										while true do
											if (((3715 - 1419) < (1325 + 3151)) and (v258 == (0 - 0))) then
												v84.LastTargetSwap = GetTime();
												if (v24(v23(11 + 89)) or ((1036 + 2977) < (2234 + 1126))) then
													return "fists_of_fury one_gcd off-target serenity 14";
												end
												break;
											end
										end
									end
								end
							end
							break;
						end
					end
				end
				v168 = 1667 - (810 + 855);
			end
			if ((v168 == (4 + 0)) or ((793 + 583) >= (367 + 4257))) then
				if (((151 + 168) <= (5160 - 3462)) and v60.RushingJadeWind:IsReady() and v13:BuffDown(v60.RushingJadeWindBuff) and (v66 >= (1619 - (463 + 1151)))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((6637 - (29 + 1946)) > (2335 + 2664))) then
						return "rushing_jade_wind serenity 22";
					end
				end
				if ((v60.BlackoutKick:IsReady() and v60.ShadowboxingTreads:IsAvailable() and (v66 >= (1 + 2)) and v89(v60.BlackoutKick)) or ((4408 - (337 + 178)) <= (3178 - (4 + 60)))) then
					if (((17664 - 13007) >= (255 + 799)) and v84.CastTargetIf(v60.BlackoutKick, v64, "min", v95, nil, not v14:IsInMeleeRange(1121 - (425 + 691)))) then
						return "blackout_kick serenity 24";
					end
				end
				if ((v60.SpinningCraneKick:IsReady() and v89(v60.SpinningCraneKick) and ((v66 > (2001 - (354 + 1644))) or ((v66 > (843 - (499 + 342))) and (v91() >= (2.3 + 0))))) or ((880 - (65 + 95)) >= (1546 + 618))) then
					if (((2244 - (1403 + 236)) < (5458 - (1117 + 243))) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(250 - (67 + 175)))) then
						return "spinning_crane_kick serenity 26";
					end
				end
				v168 = 3 + 2;
			end
		end
	end
	local function v126()
		local v169 = 0 - 0;
		while true do
			if (((1068 - (387 + 344)) < (2773 - (654 + 320))) and ((7 - 3) == v169)) then
				v51 = EpicSettings.Settings['FortifyingBrewHP'] or (431 - (276 + 155));
				v52 = EpicSettings.Settings['UseExpelHarm'];
				v53 = EpicSettings.Settings['ExpelHarmHP'] or (0 - 0);
				v54 = EpicSettings.Settings['UseDampenHarm'];
				v169 = 3 + 2;
			end
			if (((907 + 158) < (3082 - (65 + 709))) and ((1 + 0) == v169)) then
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v41 = EpicSettings.Settings['HealingPotionHP'] or (1744 - (884 + 860));
				v42 = EpicSettings.Settings['UseHealthstone'];
				v169 = 2 - 0;
			end
			if (((2043 - (492 + 188)) < (2840 + 1299)) and (v169 == (10 - 7))) then
				v47 = EpicSettings.Settings['HandleIncorporeal'];
				v48 = EpicSettings.Settings['UseTouchOfKarma'];
				v49 = EpicSettings.Settings['UseTouchOfDeath'];
				v50 = EpicSettings.Settings['UseFortifyingBrew'];
				v169 = 1 + 3;
			end
			if (((2 + 3) == v169) or ((1494 + 679) < (1724 - 711))) then
				v55 = EpicSettings.Settings['DampenHarmHP'] or (0 - 0);
				v56 = EpicSettings.Settings['UseDiffuseMagic'];
				v57 = EpicSettings.Settings['DiffuseMagicHP'] or (0 - 0);
				v58 = EpicSettings.Settings['BonedustBrewUsage'] or "";
				v169 = 1 + 5;
			end
			if (((1 + 1) == v169) or ((13842 - 9528) <= (81 + 439))) then
				v43 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v46 = EpicSettings.Settings['HandleAfflicted'];
				v169 = 7 - 4;
			end
			if (((627 + 1038) <= (657 + 3359)) and (v169 == (0 - 0))) then
				v35 = EpicSettings.Settings['UseDjaruun'];
				v36 = EpicSettings.Settings['InterruptWithStun'];
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v38 = EpicSettings.Settings['InterruptThreshold'];
				v169 = 3 - 2;
			end
			if ((v169 == (9 - 3)) or ((2127 - 1037) > (4485 - (1190 + 61)))) then
				v59 = EpicSettings.Settings['SummonWhiteTigerStatueUsage'] or "";
				v34 = EpicSettings.Settings['cycleDelay'] or "";
				break;
			end
		end
	end
	local function v127()
		local v170 = 0 + 0;
		while true do
			if (((3831 - (1448 + 245)) == (3069 - 931)) and (v170 == (0 - 0))) then
				v126();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v170 = 2 - 1;
			end
			if (((7 - 4) == v170) or ((3701 - 1506) > (3336 - (528 + 295)))) then
				if (((4034 - 1007) < (5629 - (1224 + 123))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v84.TargetIsValid() or v13:AffectingCombat() or ((664 + 2667) <= (2513 - (97 + 540)))) then
					local v215 = 1968 - (484 + 1484);
					while true do
						if (((4590 - (1398 + 154)) < (2757 + 549)) and (v215 == (2 - 1))) then
							if ((v68 == (42516 - 31405)) or ((1858 - (354 + 176)) < (1480 - 901))) then
								v68 = v10.FightRemains(v65, false);
							end
							break;
						end
						if (((0 + 0) == v215) or ((354 - 112) > (911 + 890))) then
							v67 = v10.BossFightRemains();
							v68 = v67;
							v215 = 1 + 0;
						end
					end
				end
				if (((4148 - (649 + 781)) <= (4083 + 661)) and (v84.TargetIsValid() or v13:AffectingCombat())) then
					v69 = v60.InvokeXuenTheWhiteTiger:TimeSinceLastCast() <= (42 - 18);
				end
				v170 = 11 - 7;
			end
			if (((1354 - (126 + 651)) <= (5061 - 2582)) and (v170 == (1 + 1))) then
				v64 = v13:GetEnemiesInMeleeRange(3 + 2);
				v65 = v13:GetEnemiesInMeleeRange(18 - 10);
				if (v30 or ((6013 - 4003) >= (372 + 3405))) then
					local v216 = 0 + 0;
					while true do
						if (((3641 - (179 + 850)) > (1625 - (34 + 750))) and ((305 - (302 + 3)) == v216)) then
							v66 = #v65;
							v66 = ((#v65 > (0 + 0)) and #v65) or (1 - 0);
							break;
						end
					end
				else
					v66 = 1 + 0;
				end
				v170 = 7 - 4;
			end
			if ((v170 == (5 - 1)) or ((3889 - 1707) < (894 + 762))) then
				if ((v13:AffectingCombat() and v44) or ((1064 - 381) == (273 + 1863))) then
					if ((v60.Detox:IsReady() and v33) or ((4740 - (56 + 48)) <= (2092 + 525))) then
						local v220 = 0 + 0;
						while true do
							if ((v220 == (0 - 0)) or ((4817 - (7 + 75)) == (1 + 23))) then
								ShouldReturn = v84.FocusUnit(true, nil, nil, nil);
								if (((2458 - 1787) < (2771 - (170 + 85))) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				if (((988 - (288 + 61)) == (548 + 91)) and v84.TargetIsValid()) then
					local v217 = 0 + 0;
					while true do
						if ((v217 == (0 + 0)) or ((2348 + 2621) < (6318 - 3689))) then
							if ((not v13:AffectingCombat() and v29) or ((1273 - (330 + 407)) >= (4474 - (29 + 159)))) then
								local v225 = 0 - 0;
								local v226;
								while true do
									if (((16020 - 12495) > (449 - 193)) and (v225 == (0 + 0))) then
										v226 = v105();
										if (((3556 - (15 + 742)) == (3249 - (414 + 36))) and v226) then
											return v226;
										end
										break;
									end
								end
							end
							if (v13:AffectingCombat() or v29 or ((2093 - (745 + 761)) > (2312 + 1219))) then
								local v227 = 0 + 0;
								local v228;
								local v229;
								while true do
									if ((v227 == (0 + 0)) or ((807 - 264) == (3866 + 982))) then
										if (((1247 - (126 + 953)) < (4226 - (759 + 941))) and not v13:IsCasting() and not v13:IsChanneling()) then
											local v238 = 0 + 0;
											local v239;
											while true do
												if (((1955 - (896 + 708)) <= (262 + 2812)) and (v238 == (1577 - (555 + 1022)))) then
													v239 = v84.Interrupt(v60.SpearHandStrike, 1 + 7, true);
													if (v239 or ((3660 - (14 + 127)) <= (735 + 2585))) then
														return v239;
													end
													v238 = 796 - (141 + 654);
												end
												if (((2497 - (156 + 775)) < (4115 - (167 + 1423))) and (v238 == (5 - 3))) then
													v239 = v84.Interrupt(v60.SpearHandStrike, 122 - 82, true, v16, v62.SpearHandStrikeMouseover);
													if (v239 or ((1595 + 592) < (365 + 881))) then
														return v239;
													end
													break;
												end
												if ((v238 == (2 - 1)) or ((2192 + 1672) == (2340 - (1625 + 255)))) then
													v239 = v84.InterruptWithStun(v60.LegSweep, 7 + 1);
													if (v239 or ((401 + 1259) < (2545 - (1026 + 490)))) then
														return v239;
													end
													v238 = 2 + 0;
												end
											end
										end
										if (v15 or ((5158 - (16 + 1718)) < (34 + 55))) then
											if (((747 + 63) <= (13390 - 8889)) and v44 and v33 and v60.Detox:IsReady() and v84.DispellableFriendlyUnit()) then
												if (v24(v62.DetoxFocus) or ((19 - 6) >= (801 - (168 + 410)))) then
													return "detox main";
												end
											end
										end
										if (v46 or ((1088 + 1486) == (13415 - 10397))) then
											local v240 = 807 - (134 + 673);
											while true do
												if ((v240 == (0 + 0)) or ((492 - 180) < (2206 - (1174 + 734)))) then
													v229 = v84.HandleAfflicted(v60.Detox, v62.DetoxMouseover, 53 - 13);
													if (v229 or ((67 + 138) > (6997 - 2822))) then
														return v229;
													end
													break;
												end
											end
										end
										v227 = 2 - 1;
									end
									if ((v227 == (6 - 4)) or ((754 + 1061) == (2673 - 1012))) then
										v228 = v84.HandleDPSPotion(v13:BuffUp(v60.BonedustBrewBuff) or v13:BuffUp(v60.Serenity) or v13:BuffUp(v60.FaelineStomp) or v69);
										if (v228 or ((98 + 204) > (10672 - 7861))) then
											return v228;
										end
										if (((1160 + 728) >= (2335 - 1732)) and (v10.CombatTime() < (5 - 1)) and (v13:Chi() < (6 - 1)) and not v60.Serenity:IsAvailable() and (not v69 or not v60.InvokeXuenTheWhiteTiger:IsAvailable())) then
											local v241 = 0 + 0;
											local v242;
											while true do
												if (((14676 - 9881) == (3224 + 1571)) and (v241 == (0 - 0))) then
													v242 = v108();
													if (v242 or ((5289 - (289 + 223)) > (9004 - 4115))) then
														return v242;
													end
													break;
												end
											end
										end
										v227 = 2 + 1;
									end
									if ((v227 == (3 + 2)) or ((3986 - (514 + 126)) < (487 + 933))) then
										if (((1998 + 420) >= (3485 - 1238)) and v60.TigerPalm:IsReady() and v13:BuffDown(v60.SerenityBuff) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (2 + 1)) and v89(v60.TigerPalm) and (v13:ChiDeficit() >= ((6 - 4) + v27(v13:BuffUp(v60.PowerStrikesBuff)))) and ((not v60.InvokeXuenTheWhiteTiger:IsAvailable() and not v60.Serenity:IsAvailable()) or (not v60.Skyreach:IsAvailable() and not v60.Skytouch:IsAvailable()) or (v10.CombatTime() > (4 + 1)) or v69) and not v72) then
											if (((1772 + 1651) >= (540 + 2519)) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(12 - 7))) then
												return "tiger_palm main 12";
											end
										end
										if (((1698 + 935) >= (952 + 154)) and v60.ChiBurst:IsCastable() and v60.FaelineStomp:IsAvailable() and v60.FaelineStomp:CooldownDown() and (((v13:ChiDeficit() >= (1 + 0)) and (v66 == (1 + 0))) or ((v13:ChiDeficit() >= (610 - (4 + 604))) and (v66 >= (6 - 4)))) and not v60.FaelineHarmony:IsAvailable()) then
											if (v24(v60.ChiBurst, not v14:IsInRange(142 - 102), true) or ((18541 - 14549) < (3368 + 40))) then
												return "chi_burst main 14";
											end
										end
										if ((v32 and not v60.Serenity:IsAvailable()) or ((138 + 3403) < (8282 - 6163))) then
											local v243 = 1445 - (344 + 1101);
											local v244;
											while true do
												if ((v243 == (0 - 0)) or ((913 - 420) > (3020 + 687))) then
													v244 = v110();
													if (((15013 - 10456) >= (13518 - 10530)) and v244) then
														return v244;
													end
													break;
												end
											end
										end
										v227 = 7 - 1;
									end
									if ((v227 == (8 + 0)) or ((3126 - (57 + 244)) == (3019 + 112))) then
										if (((2463 + 1239) > (3573 - 2329)) and (v66 == (1964 - (883 + 1080)))) then
											local v245 = v123();
											if (((1253 - (138 + 62)) <= (159 + 1853)) and v245) then
												return v245;
											end
										end
										v229 = v124();
										if (v229 or ((18506 - 14053) >= (5046 - (62 + 21)))) then
											return v229;
										end
										break;
									end
									if ((v227 == (3 + 0)) or ((5353 - (1036 + 413)) == (9455 - 4638))) then
										v229 = v107();
										if (v229 or ((942 + 457) > (4276 - 2727))) then
											return v229;
										end
										v229 = v106();
										v227 = 13 - 9;
									end
									if (((13161 - 9285) == (6143 - 2267)) and (v227 == (11 - 5))) then
										if ((v32 and v60.Serenity:IsAvailable()) or ((4526 - 3381) > (3736 - (649 + 823)))) then
											local v246 = v111();
											if (v246 or ((5986 - 2449) > (6144 - (1202 + 361)))) then
												return v246;
											end
										end
										if (((15088 - 10939) >= (1017 - 507)) and v13:BuffUp(v60.SerenityBuff)) then
											if ((v13:BloodlustUp() and (v66 >= (1713 - (263 + 1446)))) or ((1028 + 444) >= (574 + 2918))) then
												local v259 = v112();
												if (v259 or ((91 + 39) >= (499 + 1402))) then
													return v259;
												end
											end
											if ((v13:BloodlustUp() and (v66 < (747 - (387 + 356)))) or ((4110 - 1548) >= (13856 - 10091))) then
												local v260 = v113();
												if (v260 or ((1092 + 583) < (628 - 319))) then
													return v260;
												end
											end
											if (((4621 - (646 + 1070)) >= (282 + 684)) and (v66 > (4 + 0))) then
												local v261 = 0 + 0;
												local v262;
												while true do
													if (((8406 - 6156) > (451 + 1119)) and (v261 == (0 - 0))) then
														v262 = v114();
														if (((3820 - (288 + 809)) == (4376 - (471 + 1182))) and v262) then
															return v262;
														end
														break;
													end
												end
											end
											if ((v66 == (1499 - (385 + 1110))) or ((3744 - (1201 + 408)) <= (2110 - (747 + 1100)))) then
												local v263 = 0 + 0;
												local v264;
												while true do
													if (((2631 - (269 + 342)) == (2653 - 633)) and (v263 == (0 - 0))) then
														v264 = v115();
														if (v264 or ((517 - (263 + 83)) > (1765 - 726))) then
															return v264;
														end
														break;
													end
												end
											end
											if ((v66 == (9 - 6)) or ((3295 - (659 + 162)) <= (6540 - 4304))) then
												local v265 = 215 - (109 + 106);
												local v266;
												while true do
													if (((0 - 0) == v265) or ((3597 - (1157 + 8)) < (1681 - (179 + 332)))) then
														v266 = v116();
														if (((1906 - (705 + 132)) < (4346 + 414)) and v266) then
															return v266;
														end
														break;
													end
												end
											end
											if (((889 + 3904) > (1546 + 1736)) and (v66 == (7 - 5))) then
												local v267 = 0 + 0;
												local v268;
												while true do
													if (((4969 - (17 + 26)) > (2497 - (1866 + 96))) and (v267 == (0 + 0))) then
														v268 = v117();
														if (v268 or ((5191 - 3422) == (9234 - 4459))) then
															return v268;
														end
														break;
													end
												end
											end
											if (((10600 - 5876) == (17141 - 12417)) and (v66 == (2 - 1))) then
												local v269 = 0 + 0;
												local v270;
												while true do
													if (((10127 - 7417) > (1669 - (725 + 406))) and (v269 == (0 - 0))) then
														v270 = v118();
														if (v270 or ((108 + 838) >= (5206 - (198 + 177)))) then
															return v270;
														end
														break;
													end
												end
											end
										end
										if (((1906 - 1217) == (1130 - 441)) and (v66 > (3 + 1))) then
											local v247 = 0 - 0;
											local v248;
											while true do
												if ((v247 == (0 + 0)) or ((25 + 841) == (1490 + 1398))) then
													v248 = v119();
													if (((3788 + 102) == (15151 - 11261)) and v248) then
														return v248;
													end
													break;
												end
											end
										end
										v227 = 1727 - (1082 + 638);
									end
									if ((v227 == (1369 - (1322 + 40))) or ((1341 - 804) > (4640 - (435 + 1213)))) then
										if ((v66 == (8 + 35)) or ((5042 - (696 + 292)) < (277 - 145))) then
											local v249 = 0 - 0;
											local v250;
											while true do
												if (((7057 - 5482) <= (9681 - 7342)) and ((1465 - (731 + 734)) == v249)) then
													v250 = v120();
													if (((4062 - (1286 + 285)) > (7366 - 5343)) and v250) then
														return v250;
													end
													break;
												end
											end
										end
										if ((v66 == (2 + 1)) or ((11310 - 7645) > (3546 + 313))) then
											local v251 = 0 - 0;
											local v252;
											while true do
												if ((v251 == (1261 - (1048 + 213))) or ((7326 - 3506) <= (452 + 2865))) then
													v252 = v121();
													if (v252 or ((75 + 370) > (1757 + 1341))) then
														return v252;
													end
													break;
												end
											end
										end
										if ((v66 == (1359 - (223 + 1134))) or ((3899 - 3085) == (5035 - (982 + 899)))) then
											local v253 = 0 - 0;
											local v254;
											while true do
												if ((v253 == (0 + 0)) or ((5062 - 1591) >= (1462 + 3094))) then
													v254 = v122();
													if (((15554 - 10830) == (6636 - 1912)) and v254) then
														return v254;
													end
													break;
												end
											end
										end
										v227 = 1491 - (310 + 1173);
									end
									if ((v227 == (1 + 0)) or ((11080 - 7893) == (6220 - (968 + 483)))) then
										if (v47 or ((3806 - (37 + 187)) < (100 + 1722))) then
											local v255 = 0 - 0;
											while true do
												if (((2250 - (204 + 290)) > (2308 - (680 + 161))) and (v255 == (0 + 0))) then
													v229 = v84.HandleIncorporeal(v60.Paralysis, v62.ParalysisMouseover, 1088 - (979 + 89));
													if (v229 or ((4186 - (802 + 1072)) >= (11854 - 8086))) then
														return v229;
													end
													break;
												end
											end
										end
										v71 = not v60.InvokeXuenTheWhiteTiger:IsAvailable() or ((7 + 113) > v68);
										v72 = not (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < (1 + 0)) and (v60.RisingSunKick:CooldownRemains() < (1 + 0)) and (v13:HasTier(69 - 39, 1 + 1) or (v66 < (14 - 9)));
										v227 = 3 - 1;
									end
									if ((v227 == (1998 - (1413 + 581))) or ((5798 - (630 + 584)) <= (13174 - 8933))) then
										if (v229 or ((2847 - (184 + 944)) > (1147 + 646))) then
											return v229;
										end
										if ((v60.FaelineStomp:IsCastable() and v89(v60.FaelineStomp) and v60.FaelineHarmony:IsAvailable()) or ((3305 - (927 + 26)) == (12716 - 8060))) then
											if (v84.CastTargetIf(v60.FaelineStomp, v65, "min", v99, v102, not v14:IsInRange(670 - (284 + 356))) or ((761 + 1440) >= (10960 - 6172))) then
												return "faeline_stomp main 8";
											end
										end
										if (((503 + 125) == (412 + 216)) and v60.TigerPalm:IsReady() and v13:BuffDown(v60.SerenityBuff) and (v13:Energy() > (38 + 12)) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < (1 + 2)) and v89(v60.TigerPalm) and (v13:ChiDeficit() >= ((1130 - (211 + 917)) + v27(v13:BuffUp(v60.PowerStrikesBuff)))) and ((not v60.InvokeXuenTheWhiteTiger:IsAvailable() and not v60.Serenity:IsAvailable()) or (not v60.Skyreach:IsAvailable() and not v60.Skytouch:IsAvailable()) or (v10.CombatTime() > (5 + 0)) or v69) and not v72) then
											if (((2127 - (1151 + 644)) <= (851 + 2255)) and v84.CastTargetIf(v60.TigerPalm, v64, "min", v96, nil, not v14:IsInMeleeRange(3 + 2))) then
												return "tiger_palm main 10";
											end
										end
										v227 = 8 - 3;
									end
								end
							end
							v217 = 1901 - (745 + 1155);
						end
						if ((v217 == (2 - 1)) or ((2014 - (27 + 287)) < (2193 - 895))) then
							if (((4710 - 2628) == (5170 - 3088)) and v22(v60.PoolEnergy)) then
								return "Pool Energy";
							end
							break;
						end
					end
				end
				break;
			end
			if (((8032 - 4944) >= (2466 - (148 + 68))) and (v170 == (1 + 0))) then
				v31 = EpicSettings.Toggles['cycle'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v170 = 2 + 0;
			end
		end
	end
	local function v128()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (1 + 0)) or ((2453 + 2400) < (2094 - (1064 + 110)))) then
				EpicSettings.SetupVersion("Windwalker Monk X v 10.2.00 By BoomK");
				break;
			end
			if (((1072 - (9 + 10)) < (294 + 4431)) and ((1895 - (1219 + 676)) == v171)) then
				v86();
				v21.Print("Windwalker Monk rotation by Epic BoomK");
				v171 = 1142 - (130 + 1011);
			end
		end
	end
	v21.SetAPL(2240 - (1639 + 332), v127, v128);
end;
return v0["Epix_Monk_Windwalker.lua"]();

