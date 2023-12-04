local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((7554 - 3763) <= (2454 - 843))) then
			return v6(...);
		end
		if ((v5 == (1785 - (1476 + 309))) or ((5862 - (299 + 985)) <= (478 + 1530))) then
			v6 = v0[v4];
			if (((3687 - 2562) <= (2169 - (86 + 7))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 4 - 3;
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
	local v58 = v18.Monk.Windwalker;
	local v59 = v20.Monk.Windwalker;
	local v60 = v23.Monk.Windwalker;
	local v61 = {v59.AlgetharPuzzleBox:ID(),v59.BeacontotheBeyond:ID(),v59.Djaruun:ID(),v59.DragonfireBombDispenser:ID(),v59.EruptingSpearFragment:ID(),v59.ManicGrieftorch:ID()};
	local v62;
	local v63;
	local v64;
	local v65 = 5589 + 5522;
	local v66 = 12506 - (440 + 955);
	local v67;
	local v68 = false;
	local v69 = false;
	local v70 = false;
	local v71 = v59.NeltharionsCalltoDominance:IsEquipped() or v59.AshesoftheEmbersoul:IsEquipped() or v59.MirrorofFracturedTomorrows:IsEquipped() or v59.WitherbarksBranch:IsEquipped();
	local v72 = false;
	local v73 = false;
	local v74 = false;
	local v75 = ((v58.Serenity:IsAvailable()) and (1 + 0)) or (3 - 1);
	local v76 = {{v58.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v58.RingOfPeace,"Cast Ring Of Peace (Stun)",function()
		return true;
	end},{v58.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v77 = false;
	local v78 = 0 - 0;
	local v79 = v13:GetEquipment();
	local v80 = (v79[33 - 20] and v20(v79[13 + 0])) or v20(0 - 0);
	local v81 = (v79[963 - (438 + 511)] and v20(v79[1397 - (1262 + 121)])) or v20(1068 - (728 + 340));
	local v82 = v21.Commons.Everyone;
	local v83 = v21.Commons.Monk;
	local function v84()
		v82.DispellableDebuffs = v25.MergeTable(v82.DispellablePoisonDebuffs, v82.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v84();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v128 = 1790 - (816 + 974);
		while true do
			if ((v128 == (0 - 0)) or ((2673 - 1930) >= (4738 - (163 + 176)))) then
				v78 = 0 - 0;
				v65 = 51061 - 39950;
				v128 = 1 + 0;
			end
			if (((2965 - (1564 + 246)) < (2018 - (124 + 221))) and (v128 == (1 + 0))) then
				v66 = 11562 - (115 + 336);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v75 = ((v58.Serenity:IsAvailable()) and (1 - 0)) or (1 + 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v79 = v13:GetEquipment();
		v80 = (v79[59 - (45 + 1)] and v20(v79[1 + 12])) or v20(1990 - (1282 + 708));
		v81 = (v79[1226 - (583 + 629)] and v20(v79[3 + 11])) or v20(0 - 0);
		v71 = v59.NeltharionsCalltoDominance:IsEquipped() or v59.AshesoftheEmbersoul:IsEquipped() or v59.MirrorofFracturedTomorrows:IsEquipped() or v59.WitherbarksBranch:IsEquipped();
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v85()
		return math.floor((v13:EnergyTimeToMaxPredicted() * (6 + 4)) + (1170.5 - (943 + 227))) / (5 + 5);
	end
	local function v86()
		return math.floor(v13:EnergyPredicted() + (1631.5 - (1539 + 92)));
	end
	local function v87(v129)
		return not v13:PrevGCD(1947 - (706 + 1240), v129);
	end
	local function v88()
		if (not v58.MarkoftheCrane:IsAvailable() or ((2582 - (81 + 177)) <= (1632 - 1054))) then
			return 257 - (212 + 45);
		end
		local v130 = 0 - 0;
		for v169, v170 in v26(v63) do
			if (((5713 - (708 + 1238)) == (314 + 3453)) and v170:DebuffUp(v58.MarkoftheCraneDebuff)) then
				v130 = v130 + 1 + 0;
			end
		end
		return v130;
	end
	local function v89()
		if (((5756 - (586 + 1081)) == (4600 - (348 + 163))) and not v58.MarkoftheCrane:IsAvailable()) then
			return 0 + 0;
		end
		local v131 = v88();
		local v132 = 281 - (215 + 65);
		local v133 = 0.18 - 0;
		if (((6317 - (1541 + 318)) >= (1485 + 189)) and (v131 > (0 + 0))) then
			v132 = v132 * (1 + 0 + (v131 * v133));
		end
		v132 = v132 * ((1751 - (1036 + 714)) + ((0.1 + 0) * v58.CraneVortex:TalentRank()));
		v132 = v132 * (1 + 0 + ((1280.3 - (883 + 397)) * v27(v13:BuffUp(v58.KicksofFlowingMomentumBuff))));
		v132 = v132 * ((591 - (563 + 27)) + ((0.05 - 0) * v58.FastFeet:TalentRank()));
		return v132;
	end
	local function v90()
		local v134 = 1986 - (1369 + 617);
		local v135;
		while true do
			if (((2459 - (85 + 1402)) <= (489 + 929)) and ((2 - 1) == v134)) then
				if ((v64 == v135) or (v135 >= (408 - (274 + 129))) or ((5155 - (12 + 205)) < (4346 + 416))) then
					return true;
				end
				return false;
			end
			if ((v134 == (0 - 0)) or ((2424 + 80) > (4648 - (27 + 357)))) then
				if (((2633 - (91 + 389)) == (2450 - (90 + 207))) and not v58.MarkoftheCrane:IsAvailable()) then
					return true;
				end
				v135 = v88();
				v134 = 1 + 0;
			end
		end
	end
	local function v91()
		if (not (v58.TouchofDeath:CooldownUp() or v13:BuffUp(v58.HiddenMastersForbiddenTouchBuff)) or ((1368 - (706 + 155)) >= (4386 - (730 + 1065)))) then
			return nil;
		end
		local v136, v137 = nil, nil;
		for v171, v172 in v26(v62) do
			if (((6044 - (1339 + 224)) == (2280 + 2201)) and not v172:IsFacingBlacklisted() and not v172:IsUserCycleBlacklisted() and (v172:AffectingCombat() or v172:IsDummy()) and ((v58.ImpTouchofDeath:IsAvailable() and (v172:HealthPercentage() <= (14 + 1))) or (v172:Health() < v13:Health())) and (not v137 or v25.CompareThis("max", v172:Health(), v137))) then
				v136, v137 = v172, v172:Health();
			end
		end
		if ((v136 and (v136 == v14)) or ((3465 - 1137) < (1536 - (268 + 575)))) then
			if (((5622 - (919 + 375)) == (11901 - 7573)) and not v58.TouchofDeath:IsReady()) then
				return nil;
			end
		end
		return v136;
	end
	local function v92()
		local v138 = 971 - (180 + 791);
		local v139;
		local v140;
		while true do
			if (((3393 - (323 + 1482)) >= (3250 - (1177 + 741))) and (v138 == (1 + 0))) then
				return v139;
			end
			if ((v138 == (0 - 0)) or ((1607 + 2567) > (9488 - 5240))) then
				v139, v140 = nil, nil;
				for v194, v195 in v26(v63) do
					if ((not v195:IsFacingBlacklisted() and not v195:IsUserCycleBlacklisted() and (v195:AffectingCombat() or v195:IsDummy()) and (not v140 or v25.CompareThis("max", v195:TimeToDie(), v140))) or ((384 + 4202) <= (191 - (96 + 13)))) then
						v139, v140 = v195, v195:TimeToDie();
					end
				end
				v138 = 1922 - (962 + 959);
			end
		end
	end
	local function v93(v141)
		return v141:DebuffRemains(v58.MarkoftheCraneDebuff);
	end
	local function v94(v142)
		return v142:DebuffRemains(v58.MarkoftheCraneDebuff) + (v27(v142:DebuffUp(v58.SkyreachExhaustionDebuff)) * (49 - 29));
	end
	local function v95(v143)
		return v143:DebuffRemains(v58.MarkoftheCraneDebuff) + (v27(v14:DebuffDown(v58.SkyreachExhaustionDebuff)) * (4 + 16));
	end
	local function v96(v144)
		return v144:DebuffRemains(v58.MarkoftheCraneDebuff) - (v27(v90()) * (v144:TimeToDie() + (v144:DebuffRemains(v58.SkyreachCritDebuff) * (1371 - (461 + 890)))));
	end
	local function v97(v145)
		return v145:DebuffRemains(v58.FaeExposureDebuff);
	end
	local function v98(v146)
		return v146:TimeToDie();
	end
	local function v99(v147)
		return v147:DebuffRemains(v58.SkyreachCritDebuff);
	end
	local function v100(v148)
		return v148:DebuffRemains(v58.FaeExposureDebuff);
	end
	local function v101(v149)
		return v149:DebuffRemains(v58.SkyreachExhaustionDebuff) > v13:BuffRemains(v58.CalltoDominanceBuff);
	end
	local function v102(v150)
		return v150:DebuffRemains(v58.SkyreachExhaustionDebuff) > (41 + 14);
	end
	local function v103()
		local v151 = 0 - 0;
		while true do
			if (((4106 - (19 + 224)) == (3502 + 361)) and (v151 == (199 - (37 + 161)))) then
				if ((v58.ChiBurst:IsReady() and not v58.FaelineStomp:IsAvailable()) or ((102 + 180) <= (17 + 25))) then
					if (((4546 + 63) >= (827 - (60 + 1))) and v24(v58.ChiBurst, not v14:IsInRange(963 - (826 + 97)), true)) then
						return "chi_burst precombat 6";
					end
				end
				if (v58.ChiWave:IsReady() or ((1116 + 36) == (8943 - 6455))) then
					if (((7049 - 3627) > (4035 - (375 + 310))) and v22(v58.ChiWave, nil, nil, not v14:IsInRange(2039 - (1864 + 135)))) then
						return "chi_wave precombat 8";
					end
				end
				break;
			end
			if (((2262 - 1385) > (84 + 292)) and (v151 == (0 + 0))) then
				if ((v58.SummonWhiteTigerStatue:IsCastable() and v32) or ((7660 - 4542) <= (2982 - (314 + 817)))) then
					if ((v57 == "Player") or ((94 + 71) >= (3706 - (32 + 182)))) then
						if (((2919 + 1030) < (16971 - 12115)) and v24(v60.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(70 - (39 + 26)))) then
							return "summon_white_tiger_statue precombat 2";
						end
					elseif ((v57 == "Cursor") or ((4420 - (54 + 90)) < (3214 - (45 + 153)))) then
						if (((2847 + 1843) > (4677 - (457 + 95))) and v24(v60.SummonWhiteTigerStatueCursor)) then
							return "summon_white_tiger_statue precombat 2";
						end
					end
				end
				if ((v58.ExpelHarm:IsReady() and (v13:Chi() < v13:ChiMax())) or ((50 + 0) >= (1869 - 973))) then
					if (v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(18 - 10)) or ((6197 - 4483) >= (1326 + 1632))) then
						return "expel_harm precombat 4";
					end
				end
				v151 = 3 - 2;
			end
		end
	end
	local function v104()
		if ((v58.ExpelHarm:IsCastable() and v50 and (v13:HealthPercentage() <= v51)) or ((4501 - 3010) < (1392 - (485 + 263)))) then
			if (((1411 - (575 + 132)) < (1848 - (750 + 111))) and v24(v58.ExpelHarm)) then
				return "Expel Harm";
			end
		end
		if (((4728 - (445 + 565)) > (1534 + 372)) and v58.DampenHarm:IsCastable() and v52 and v13:BuffDown(v58.FortifyingBrewBuff) and (v13:HealthPercentage() <= v53)) then
			if (v24(v58.DampenHarm) or ((138 + 820) > (6421 - 2786))) then
				return "Dampen Harm";
			end
		end
		if (((1169 + 2332) <= (4802 - (189 + 121))) and v58.FortifyingBrew:IsCastable() and v48 and v13:BuffDown(v58.DampenHarmBuff) and (v13:HealthPercentage() <= v49)) then
			if (v24(v58.FortifyingBrew) or ((853 + 2589) < (3895 - (634 + 713)))) then
				return "Fortifying Brew";
			end
		end
		if (((3413 - (493 + 45)) >= (2432 - (493 + 475))) and v58.DiffuseMagic:IsCastable() and v54 and (v13:HealthPercentage() <= v55)) then
			if (v24(v58.DiffuseMagic) or ((1226 + 3571) >= (5677 - (158 + 626)))) then
				return "Diffuse Magic";
			end
		end
		if ((v59.Healthstone:IsReady() and v42 and (v13:HealthPercentage() <= v43)) or ((260 + 291) > (3419 - 1351))) then
			if (((471 + 1643) > (51 + 893)) and v24(v60.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if ((v39 and (v13:HealthPercentage() <= v41)) or ((3353 - (1035 + 56)) >= (4055 - (114 + 845)))) then
			if ((v40 == "Refreshing Healing Potion") or ((879 + 1376) >= (9054 - 5517))) then
				if (v59.RefreshingHealingPotion:IsReady() or ((3226 + 611) < (2355 - (179 + 870)))) then
					if (((4138 - 1188) == (3828 - (827 + 51))) and v24(v60.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v105()
		local v152 = 0 - 0;
		local v153;
		while true do
			if ((v152 == (0 + 0)) or ((5196 - (95 + 378)) < (240 + 3058))) then
				v153 = EpicSettings.Settings['TopTrinketCondition'] ~= "Don't Use";
				if (((1609 - 473) >= (136 + 18)) and v153 and v59.ManicGrieftorch:IsEquippedAndReady()) then
					local v201 = 1011 - (334 + 677);
					while true do
						if (((0 - 0) == v201) or ((1327 - (1049 + 7)) > (20733 - 15985))) then
							if (((8916 - 4176) >= (983 + 2169)) and (v80:ID() == v59.ManicGrieftorch:ID()) and not v81:HasUseBuff()) then
								if (v24(v60.TrinketTop, not v14:IsInRange(107 - 67)) or ((5164 - 2586) >= (1510 + 1880))) then
									return "manic_grieftorch trinkets 2";
								end
							end
							if (((1461 - (1004 + 416)) <= (3618 - (1621 + 336))) and (v81:ID() == v59.ManicGrieftorch:ID()) and not v80:HasUseBuff()) then
								if (((2540 - (337 + 1602)) < (5077 - (1014 + 503))) and v24(v60.TrinketBottom, not v14:IsInRange(1055 - (446 + 569)))) then
									return "manic_grieftorch trinkets 2";
								end
							end
							break;
						end
					end
				end
				v152 = 1 + 0;
			end
			if (((689 - 454) < (231 + 456)) and (v152 == (1 - 0))) then
				if (((92 + 4457) > (1658 - (223 + 282))) and (v75 == (1 + 0))) then
					if (v153 or ((7442 - 2768) < (6815 - 2143))) then
						if (((4338 - (623 + 47)) < (4606 - (32 + 13))) and v59.AlgetharPuzzleBox:IsEquippedAndReady() and (((v67 or not v58.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffDown(v58.SerenityBuff)) or (v66 < (15 + 10)))) then
							if (((v80:ID() == v59.AlgetharPuzzleBox:ID()) and not v81:HasUseBuff()) or ((370 + 85) == (5406 - (1070 + 731)))) then
								if (v24(v60.TrinketTop, not v14:IsInRange(39 + 1)) or ((4067 - (1257 + 147)) == (1313 + 1999))) then
									return "algethar_puzzle_box serenity_trinkets 4";
								end
							end
							if (((8179 - 3902) <= (4608 - (98 + 35))) and (v81:ID() == v59.AlgetharPuzzleBox:ID()) and not v80:HasUseBuff()) then
								if (v24(v60.TrinketBottom, not v14:IsInRange(17 + 23)) or ((3081 - 2211) == (4001 - 2812))) then
									return "algethar_puzzle_box serenity_trinkets 4";
								end
							end
						end
						if (((1452 + 101) <= (2757 + 376)) and v59.EruptingSpearFragment:IsEquippedAndReady() and (v13:BuffUp(v58.SerenityBuff))) then
							local v235 = 0 + 0;
							while true do
								if ((v235 == (557 - (395 + 162))) or ((1968 + 269) >= (5452 - (816 + 1125)))) then
									if (((v80:ID() == v59.EruptingSpearFragment:ID()) and not v81:HasUseBuff()) or ((1889 - 565) > (4168 - (701 + 447)))) then
										if (v24(v60.TrinketTop, not v14:IsInRange(61 - 21)) or ((5229 - 2237) == (3222 - (391 + 950)))) then
											return "erupting_spear_fragment serenity_trinkets 6";
										end
									end
									if (((8370 - 5264) > (3824 - 2298)) and (v81:ID() == v59.EruptingSpearFragment:ID()) and not v80:HasUseBuff()) then
										if (((7448 - 4425) < (2715 + 1155)) and v24(v60.TrinketBottom, not v14:IsInRange(24 + 16))) then
											return "erupting_spear_fragment serenity_trinkets 6";
										end
									end
									break;
								end
							end
						end
						if (((522 - 379) > (1596 - (251 + 1271))) and v59.ManicGrieftorch:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff() and v13:BuffDown(v58.SerenityBuff) and not v67) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (27 + 3)) and v58.Serenity:CooldownDown()) or (v66 < (13 - 8)))) then
							local v236 = 0 - 0;
							while true do
								if (((29 - 11) < (3371 - (1147 + 112))) and (v236 == (0 + 0))) then
									if (((2227 - 1130) <= (423 + 1205)) and (v80:ID() == v59.ManicGrieftorch:ID())) then
										if (((5327 - (335 + 362)) == (4340 + 290)) and v24(v60.TrinketTop, not v14:IsInRange(60 - 20))) then
											return "manic_grieftorch serenity_trinkets 8";
										end
									end
									if (((9662 - 6122) > (9969 - 7286)) and (v81:ID() == v59.ManicGrieftorch:ID())) then
										if (((23341 - 18547) >= (9295 - 6020)) and v24(v60.TrinketBottom, not v14:IsInRange(606 - (237 + 329)))) then
											return "manic_grieftorch serenity_trinkets 8";
										end
									end
									break;
								end
							end
						end
						if (((5314 - 3830) == (979 + 505)) and v59.BeacontotheBeyond:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff() and v13:BuffDown(v58.SerenityBuff) and not v67) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (17 + 13)) and v58.Serenity:CooldownDown()) or (v66 < (1134 - (408 + 716))))) then
							if (((5440 - 4008) < (4376 - (344 + 477))) and (v80:ID() == v59.BeacontotheBeyond:ID())) then
								if (v24(v60.TrinketTop, not v14:IsInRange(8 + 37)) or ((2826 - (1188 + 573)) > (9376 - 5798))) then
									return "beacon_to_the_beyond serenity_trinkets 8";
								end
							end
							if ((v81:ID() == v59.BeacontotheBeyond:ID()) or ((4671 + 124) < (4564 - 3157))) then
								if (((2863 - 1010) < (11903 - 7090)) and v24(v60.TrinketBottom, not v14:IsInRange(1574 - (508 + 1021)))) then
									return "beacon_to_the_beyond serenity_trinkets 8";
								end
							end
						end
					end
					if ((v35 and v59.Djaruun:IsEquippedAndReady() and (((v58.FistsofFury:CooldownRemains() < (2 + 0)) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (1176 - (228 + 938)))) or (v66 < (697 - (332 + 353))))) or ((3436 - 615) < (6364 - 3933))) then
						if (v24(v60.Djaruun, not v14:IsInRange(8 + 0)) or ((1442 + 1432) < (8722 - 6541))) then
							return "djaruun_pillar_of_the_elder_flame serenity_trinkets 12";
						end
					end
					if (v153 or ((3112 - (18 + 405)) <= (158 + 185))) then
						if ((v59.DragonfireBombDispenser:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff()) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (6 + 4)) and v58.Serenity:CooldownDown()) or (v66 < (15 - 5)))) or ((2847 - (194 + 784)) == (3779 - (694 + 1076)))) then
							local v237 = 1904 - (122 + 1782);
							while true do
								if ((v237 == (0 + 0)) or ((3306 + 240) < (2090 + 232))) then
									if ((v80:ID() == v59.DragonfireBombDispenser:ID()) or ((1494 + 588) == (13982 - 9209))) then
										if (((3006 + 238) > (3025 - (214 + 1756))) and v24(v60.TrinketTop, not v14:IsInRange(222 - 176))) then
											return "dragonfire_bomb_dispenser trinkets 14";
										end
									end
									if ((v81:ID() == v59.DragonfireBombDispenser:ID()) or ((366 + 2947) <= (98 + 1680))) then
										if (v24(v60.TrinketBottom, not v14:IsInRange(631 - (217 + 368))) or ((4293 - 2872) >= (1386 + 718))) then
											return "dragonfire_bomb_dispenser trinkets 14";
										end
									end
									break;
								end
							end
						end
						if (((1345 + 467) <= (110 + 3139)) and (((v67 or not v58.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffUp(v58.SerenityBuff)) or (v66 < (914 - (844 + 45))))) then
							ShouldReturn = v82.HandleTopTrinket(v61, v32, 324 - (242 + 42), nil);
							if (((3248 - 1625) <= (4549 - 2592)) and ShouldReturn) then
								return ShouldReturn;
							end
							ShouldReturn = v82.HandleBottomTrinket(v61, v32, 1240 - (132 + 1068), nil);
							if (((7043 - 2631) == (6035 - (214 + 1409))) and ShouldReturn) then
								return ShouldReturn;
							end
						end
						if (((1354 + 396) >= (2476 - (497 + 1137))) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (970 - (9 + 931))) and v58.Serenity:CooldownDown()) then
							local v238 = 289 - (181 + 108);
							while true do
								if (((2604 + 1768) > (4562 - 2712)) and (v238 == (0 - 0))) then
									ShouldReturn = v82.HandleTopTrinket(v61, v32, 10 + 30, nil);
									if (((145 + 87) < (1297 - (296 + 180))) and ShouldReturn) then
										return ShouldReturn;
									end
									v238 = 1404 - (1183 + 220);
								end
								if (((1783 - (1037 + 228)) < (1459 - 557)) and (v238 == (2 - 1))) then
									ShouldReturn = v82.HandleBottomTrinket(v61, v32, 136 - 96, nil);
									if (((3728 - (527 + 207)) > (1385 - (187 + 340))) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
					end
				else
					local v202 = 1870 - (1298 + 572);
					while true do
						if ((v202 == (0 - 0)) or ((3925 - (144 + 26)) <= (2280 - 1365))) then
							if (((9202 - 5256) > (1338 + 2405)) and v153) then
								if ((v59.AlgetharPuzzleBox:IsEquippedAndReady() and (((v67 or not v58.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffDown(v58.StormEarthAndFireBuff)) or (v66 < (68 - 43)))) or ((3098 - 1763) >= (16026 - 12720))) then
									if (((2461 + 2383) > (3057 - 804)) and (v80:ID() == v59.AlgetharPuzzleBox:ID())) then
										if (((423 + 29) == (170 + 282)) and v24(v60.TrinketTop)) then
											return "algethar_puzzle_box sef_trinkets 16";
										end
									end
									if ((v81:ID() == v59.AlgetharPuzzleBox:ID()) or ((4759 - (5 + 197)) < (2773 - (339 + 347)))) then
										if (((8779 - 4905) == (13643 - 9769)) and v24(v60.TrinketBottom)) then
											return "algethar_puzzle_box sef_trinkets 16";
										end
									end
								end
								if ((v59.EruptingSpearFragment:IsEquippedAndReady() and (v13:BuffUp(v58.InvokersDelightBuff))) or ((2314 - (365 + 11)) > (4677 + 258))) then
									local v240 = 0 - 0;
									while true do
										if ((v240 == (0 - 0)) or ((5179 - (837 + 87)) < (5804 - 2381))) then
											if (((3124 - (837 + 833)) <= (532 + 1959)) and (v80:ID() == v59.EruptingSpearFragment:ID())) then
												if (v24(v60.TrinketTop, not v14:IsInRange(1427 - (356 + 1031))) or ((1891 + 2266) <= (4449 - (73 + 1573)))) then
													return "erupting_spear_fragment sef_trinkets 18";
												end
											end
											if (((6241 - (1307 + 81)) >= (3216 - (7 + 227))) and (v81:ID() == v59.EruptingSpearFragment:ID())) then
												if (((6790 - 2656) > (3523 - (90 + 76))) and v24(v60.TrinketBottom, not v14:IsInRange(125 - 85))) then
													return "erupting_spear_fragment sef_trinkets 18";
												end
											end
											break;
										end
									end
								end
								if ((v59.ManicGrieftorch:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff() and v13:BuffDown(v58.StormEarthAndFireBuff) and not v67) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (15 + 15))) or (v66 < (5 + 0)))) or ((2841 + 576) < (9925 - 7391))) then
									if ((v80:ID() == v59.ManicGrieftorch:ID()) or ((2982 - (197 + 63)) <= (35 + 129))) then
										if (v24(v60.TrinketTop) or ((571 + 1837) < (1101 + 1008))) then
											return "manic_grieftorch sef_trinkets 20";
										end
									end
									if ((v81:ID() == v59.ManicGrieftorch:ID()) or ((6 + 27) == (1826 - 371))) then
										if (v24(v60.TrinketBottom) or ((1812 - (618 + 751)) >= (3004 + 1011))) then
											return "manic_grieftorch sef_trinkets 20";
										end
									end
								end
								if (((5292 - (206 + 1704)) > (279 - 113)) and v59.BeacontotheBeyond:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff() and v13:BuffDown(v58.StormEarthAndFireBuff) and not v67) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (59 - 29))) or (v66 < (5 + 5)))) then
									local v241 = 1275 - (155 + 1120);
									while true do
										if ((v241 == (1506 - (396 + 1110))) or ((632 - 352) == (997 + 2062))) then
											if (((1418 + 463) > (1107 + 186)) and (v80:ID() == v59.BeacontotheBeyond:ID())) then
												if (((3333 - (230 + 746)) == (2958 - (473 + 128))) and v24(v60.TrinketTop, not v14:IsInRange(93 - (39 + 9)))) then
													return "beacon_to_the_beyond sef_trinkets 22";
												end
											end
											if (((389 - (38 + 228)) == (223 - 100)) and (v81:ID() == v59.BeacontotheBeyond:ID())) then
												if (v24(v60.TrinketBottom, not v14:IsInRange(518 - (106 + 367))) or ((94 + 962) >= (5254 - (354 + 1508)))) then
													return "beacon_to_the_beyond sef_trinkets 22";
												end
											end
											break;
										end
									end
								end
							end
							if ((v35 and v59.Djaruun:IsEquippedAndReady() and (((v58.FistsofFury:CooldownRemains() < (6 - 4)) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (8 + 2))) or (v66 < (8 + 4)))) or ((1453 - 372) < (2319 - (334 + 910)))) then
								if (v24(v60.Djaruun, not v14:IsInRange(903 - (92 + 803))) or ((578 + 471) >= (5613 - (1035 + 146)))) then
									return "djaruun_pillar_of_the_elder_flame sef_trinkets 24";
								end
							end
							v202 = 617 - (230 + 386);
						end
						if ((v202 == (1 + 0)) or ((6278 - (353 + 1157)) <= (1960 - (53 + 1061)))) then
							if (v153 or ((4993 - (1568 + 67)) <= (648 + 772))) then
								local v239 = 0 + 0;
								while true do
									if ((v239 == (0 - 0)) or ((11001 - 7262) <= (7575 - 4570))) then
										if ((v59.DragonfireBombDispenser:IsEquippedAndReady() and ((not v80:HasUseBuff() and not v81:HasUseBuff()) or ((v80:HasUseBuff() or v81:HasUseBuff()) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (10 + 0))) or (v66 < (1222 - (615 + 597))))) or ((1485 + 174) >= (3191 - 1057))) then
											local v244 = 0 + 0;
											while true do
												if ((v244 == (0 + 0)) or ((1794 + 1466) < (4254 - (1056 + 843)))) then
													if ((v80:ID() == v59.DragonfireBombDispenser:ID()) or ((1458 - 789) == (7024 - 2801))) then
														if (v24(v60.TrinketTop, not v14:IsInRange(131 - 85)) or ((990 + 702) < (2564 - (286 + 1690)))) then
															return "dragonfire_bomb_dispenser sef_trinkets 26";
														end
													end
													if ((v81:ID() == v59.DragonfireBombDispenser:ID()) or ((5708 - (98 + 813)) < (966 + 2685))) then
														if (v24(v60.TrinketBottom, not v14:IsInRange(111 - 65)) or ((2369 + 1808) > (5357 - (263 + 244)))) then
															return "dragonfire_bomb_dispenser sef_trinkets 26";
														end
													end
													break;
												end
											end
										end
										if (((v67 or not v58.InvokeXuenTheWhiteTiger:IsAvailable()) and v13:BuffUp(v58.StormEarthAndFireBuff)) or (v66 < (20 + 5)) or ((2087 - (1502 + 185)) > (212 + 899))) then
											ShouldReturn = v82.HandleTopTrinket(v61, v32, 195 - 155, nil);
											if (((8094 - 5043) > (2532 - (629 + 898))) and ShouldReturn) then
												return ShouldReturn;
											end
											ShouldReturn = v82.HandleBottomTrinket(v61, v32, 108 - 68, nil);
											if (((9492 - 5799) <= (4747 - (12 + 353))) and ShouldReturn) then
												return ShouldReturn;
											end
										end
										v239 = 1912 - (1680 + 231);
									end
									if ((v239 == (1 + 0)) or ((2010 + 1272) > (5249 - (212 + 937)))) then
										if ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (20 + 10)) or ((4642 - (111 + 951)) < (578 + 2266))) then
											ShouldReturn = v82.HandleTopTrinket(v61, v32, 67 - (18 + 9), nil);
											if (((18 + 71) < (5024 - (31 + 503))) and ShouldReturn) then
												return ShouldReturn;
											end
											ShouldReturn = v82.HandleBottomTrinket(v61, v32, 1672 - (595 + 1037), nil);
											if (ShouldReturn or ((6427 - (189 + 1255)) < (668 + 1140))) then
												return ShouldReturn;
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
				break;
			end
		end
	end
	local function v106()
		if (((5925 - 2096) > (5048 - (1170 + 109))) and v58.SummonWhiteTigerStatue:IsCastable() and v32) then
			if (((3302 - (348 + 1469)) <= (4193 - (1115 + 174))) and (v57 == "Player")) then
				if (((10411 - 6142) == (5283 - (85 + 929))) and v24(v60.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(3 + 2))) then
					return "summon_white_tiger_statue opener 2";
				end
			elseif (((2254 - (1151 + 716)) <= (955 + 1827)) and (v57 == "Cursor")) then
				if (v24(v60.SummonWhiteTigerStatueCursor) or ((1853 + 46) <= (2621 - (95 + 1609)))) then
					return "summon_white_tiger_statue opener 2";
				end
			end
		end
		if ((v58.ExpelHarm:IsReady() and v58.ChiBurst:IsAvailable() and (v13:ChiDeficit() >= (10 - 7))) or ((5070 - (364 + 394)) <= (794 + 82))) then
			if (((667 + 1565) <= (535 + 2061)) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(7 + 1))) then
				return "expel_harm opener 4";
			end
		end
		if (((1053 + 1042) < (1880 + 1806)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 1)) and v14:DebuffDown(v58.SkyreachExhaustionDebuff)) then
			if (v22(v58.FaelineStomp, nil, nil, not v14:IsInMeleeRange(5 + 0)) or ((504 + 1091) >= (5430 - (719 + 237)))) then
				return "tiger_palm opener 6";
			end
		end
		if ((v58.ExpelHarm:IsReady() and v58.ChiBurst:IsAvailable() and (v13:Chi() == (8 - 5))) or ((3814 + 805) < (7143 - 4261))) then
			if (v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(22 - 14)) or ((698 - 404) >= (6822 - (761 + 1230)))) then
				return "expel_harm opener 8";
			end
		end
		if (((2222 - (80 + 113)) <= (1677 + 1407)) and v58.ChiWave:IsReady() and (v13:ChiDeficit() >= (2 + 0))) then
			if (v22(v58.ChiWave, nil, nil, not v14:IsInRange(2 + 38)) or ((8176 - 6139) == (560 + 1860))) then
				return "chi_wave opener 10";
			end
		end
		if (((815 + 3643) > (5147 - (965 + 278))) and v58.ExpelHarm:IsReady()) then
			if (((2165 - (1391 + 338)) >= (313 - 190)) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
				return "expel_harm opener 12";
			end
		end
		if (((1084 - 584) < (585 + 1231)) and v58.ChiBurst:IsReady() and (v13:Chi() > (1409 - (496 + 912))) and (v13:ChiDeficit() >= (6 - 4))) then
			if (((881 + 2693) == (6774 - 3200)) and v24(v58.ChiBurst, not v14:IsInRange(1370 - (1190 + 140)), true)) then
				return "chi_burst opener 14";
			end
		end
	end
	local function v107()
		if (((107 + 114) < (1108 - (317 + 401))) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and (v64 > (952 - (303 + 646)))) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(31 - 22)) or ((3945 - (1675 + 57)) <= (916 + 505))) then
				return "strike_of_the_windlord bdb_setup 2";
			end
		end
		if (((7990 - 4932) < (606 + 4254)) and v58.BonedustBrew:IsCastable() and v90() and (v13:Chi() >= (981 - (338 + 639)))) then
			if ((v56 == "Player") or ((1675 - (320 + 59)) >= (2272 + 2174))) then
				if (v24(v60.BonedustBrewPlayer, not v14:IsInRange(740 - (628 + 104))) or ((1725 - 332) > (6380 - (439 + 1452)))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif ((v56 == "Confirmation") or ((6371 - (105 + 1842)) < (123 - 96))) then
				if (v24(v58.BonedustBrew, not v14:IsInRange(97 - 57)) or ((9610 - 7613) > (162 + 3653))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif (((5946 - 2481) > (991 + 922)) and (v56 == "Cursor")) then
				if (((1897 - (274 + 890)) < (1583 + 236)) and v24(v60.BonedustBrewCursor, not v14:IsInRange(34 + 6))) then
					return "bonedust_brew bdb_setup 4";
				end
			elseif ((v56 == "Enemy under Cursor") or ((1230 + 3165) == (2585 + 2170))) then
				if ((v16 and v16:Exists() and v13:CanAttack(v16)) or ((2215 + 1578) < (3348 - 979))) then
					if (v24(v60.BonedustBrewCursor, not v14:IsInRange(859 - (731 + 88))) or ((3266 + 818) == (163 + 102))) then
						return "bonedust_brew bdb_setup 4";
					end
				end
			end
		end
		if (((933 + 3425) == (6366 - 2008)) and v58.RisingSunKick:IsReady() and v87(v58.RisingSunKick) and (v13:Chi() >= (15 - 10)) and v58.WhirlingDragonPunch:IsAvailable()) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(14 - 9)) or ((6520 - 3382) < (902 + 91))) then
				return "rising_sun_kick bdb_setup 10";
			end
		end
		if (((15 + 3315) > (418 + 1905)) and v58.RisingSunKick:IsReady() and v87(v58.RisingSunKick) and (v64 >= (2 + 0)) and v58.WhirlingDragonPunch:IsAvailable()) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(163 - (139 + 19))) or ((647 + 2979) == (5982 - (1687 + 306)))) then
				return "rising_sun_kick bdb_setup 12";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and not v58.WhirlingDragonPunch:IsAvailable() and not v90()) or ((3320 - 2404) == (3825 - (1018 + 136)))) then
			if (((36 + 236) == (1194 - 922)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(820 - (117 + 698)))) then
				return "blackout_kick bdb_setup 8";
			end
		end
		if (((4730 - (305 + 176)) <= (646 + 4193)) and v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:ChiDeficit() >= (2 + 0)) and v13:BuffUp(v58.StormEarthAndFireBuff)) then
			if (((4813 - 2036) < (2996 + 204)) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(8 - 3))) then
				return "tiger_palm bdb_setup 6";
			end
		end
	end
	local function v108()
		local v154 = 0 - 0;
		while true do
			if (((164 - 69) < (2217 - (159 + 101))) and (v154 == (9 - 7))) then
				if (((2860 - 2034) < (850 + 867)) and v58.TouchofDeath:CooldownUp() and v47) then
					local v203 = 0 - 0;
					local v204;
					local v205;
					while true do
						if (((2808 - 1382) >= (126 + 979)) and ((267 - (112 + 154)) == v203)) then
							if (((6387 - 3633) <= (3410 - (21 + 10))) and v30 and v31) then
								v205 = v91();
							elseif (v58.TouchofDeath:IsReady() or ((5646 - (531 + 1188)) == (1208 + 205))) then
								v205 = v14;
							end
							if (v205 or ((1817 - (96 + 567)) <= (1137 - 349))) then
								if ((v204 and v13:BuffDown(v58.SerenityBuff) and v87(v58.TouchofDeath) and (v205:Health() < v13:Health())) or (v13:BuffRemains(v58.HiddenMastersForbiddenTouchBuff) < (1 + 1)) or (v13:BuffRemains(v58.HiddenMastersForbiddenTouchBuff) > v205:TimeToDie()) or ((5908 - 4265) > (5074 - (867 + 828)))) then
									if ((v205:GUID() == v14:GUID()) or ((6132 - 3329) > (16495 - 11946))) then
										if (v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(11 - 6)) or ((338 - 118) >= (1316 + 1706))) then
											return "touch_of_death cd_sef main-target 14";
										end
									elseif (((5030 - 2208) == (3593 - (134 + 637))) and (((GetTime() - v82.LastTargetSwap) * (174 + 826)) >= v34)) then
										v82.LastTargetSwap = GetTime();
										if (v24(v23(1257 - (775 + 382))) or ((1518 - 457) == (2464 - (45 + 562)))) then
											return "touch_of_death cd_sef off-target 14";
										end
									end
								end
							end
							v203 = 864 - (545 + 317);
						end
						if (((4100 - 1340) > (2390 - (763 + 263))) and ((0 + 0) == v203)) then
							v204 = v13:IsInParty() and not v13:IsInRaid();
							v205 = nil;
							v203 = 1751 - (512 + 1238);
						end
						if ((v203 == (1596 - (272 + 1322))) or ((9182 - 4280) <= (4841 - (533 + 713)))) then
							if ((v205 and v87(v58.TouchofDeath)) or ((3880 - (14 + 14)) == (1118 - (499 + 326)))) then
								if (v204 or ((2794 - 1235) == (5012 - (104 + 320)))) then
									if ((v205:TimeToDie() > (2057 - (1929 + 68))) or v205:DebuffUp(v58.BonedustBrewDebuff) or (v66 < (1333 - (1206 + 117))) or ((3008 + 1476) == (2380 - (683 + 909)))) then
										if (((14011 - 9443) >= (7262 - 3355)) and (v205:GUID() == v14:GUID())) then
											if (((2023 - (772 + 5)) < (4897 - (19 + 1408))) and v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(293 - (134 + 154)))) then
												return "touch_of_death cd_sef main-target 16";
											end
										elseif (((6705 - 2637) >= (3015 - 2043)) and (((GetTime() - v82.LastTargetSwap) * (340 + 660)) >= v34)) then
											v82.LastTargetSwap = GetTime();
											if (((419 + 74) < (4095 - (10 + 192))) and v24(v23(147 - (13 + 34)))) then
												return "touch_of_death cd_sef off-target 16";
											end
										end
									end
								elseif ((v205:GUID() == v14:GUID()) or ((2762 - (342 + 947)) >= (13746 - 10414))) then
									if (v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(1713 - (119 + 1589))) or ((8936 - 4885) <= (1602 - 445))) then
										return "touch_of_death cd_sef main-target 18";
									end
								elseif (((1156 - (545 + 7)) < (8167 - 5286)) and (((GetTime() - v82.LastTargetSwap) * (413 + 587)) >= v34)) then
									v82.LastTargetSwap = GetTime();
									if (v24(v23(1803 - (494 + 1209))) or ((2406 - 1506) == (4375 - (197 + 801)))) then
										return "touch_of_death cd_sef off-target 18";
									end
								end
							end
							break;
						end
					end
				end
				if (((8991 - 4532) > (2857 - 2266)) and v58.TouchofKarma:IsCastable() and v46 and ((v58.InvokeXuenTheWhiteTiger:IsAvailable() and ((v66 > (1044 - (919 + 35))) or v67 or v69 or (v66 < (14 + 2)))) or (not v58.InvokeXuenTheWhiteTiger:IsAvailable() and ((v66 > (641 - 482)) or v69)))) then
					if (((3865 - (369 + 98)) >= (3510 - (400 + 715))) and v22(v58.TouchofKarma, nil, nil, not v14:IsInRange(9 + 11))) then
						return "touch_of_karma cd_sef 20";
					end
				end
				if ((v58.AncestralCall:IsCastable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (14 + 16)) or v69 or (v66 < (1345 - (744 + 581))))) or ((1094 + 1089) >= (4446 - (653 + 969)))) then
					if (((3783 - 1847) == (3567 - (12 + 1619))) and v22(v58.AncestralCall, nil)) then
						return "ancestral_call cd_sef 22";
					end
				end
				if ((v58.BloodFury:IsCastable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (193 - (103 + 60))) or v69 or (v66 < (98 - 78)))) or ((21110 - 16278) < (20554 - 16241))) then
					if (((5750 - (710 + 952)) > (5742 - (555 + 1313))) and v22(v58.BloodFury, nil)) then
						return "blood_fury cd_sef 24";
					end
				end
				v154 = 3 + 0;
			end
			if (((3877 + 455) == (3004 + 1328)) and ((1469 - (1261 + 207)) == v154)) then
				if (((4251 - (245 + 7)) >= (3647 - (212 + 535))) and v58.StormEarthAndFire:IsCastable() and not v58.BonedustBrew:IsAvailable() and (v67 or ((v14:TimeToDie() > (74 - 59)) and (v58.StormEarthAndFire:FullRechargeTime() < v58.InvokeXuenTheWhiteTiger:CooldownRemains())))) then
					if (v22(v58.StormEarthAndFire, nil) or ((4001 - (905 + 571)) > (19059 - 14995))) then
						return "storm_earth_and_fire cd_sef 9";
					end
				end
				if (((6187 - 1816) == (17287 - 12916)) and v58.BonedustBrew:IsCastable() and ((v13:BuffDown(v58.BonedustBrewBuff) and v13:BuffUp(v58.StormEarthAndFireBuff) and (v13:BuffRemains(v58.StormEarthAndFireBuff) < (1 + 10)) and v90()) or (v13:BuffDown(v58.BonedustBrewBuff) and (v66 < (1493 - (522 + 941))) and (v66 > (1521 - (292 + 1219))) and v90() and (v13:Chi() >= (1116 - (787 + 325)))) or (v66 < (30 - 20)) or (v14:DebuffDown(v58.SkyreachExhaustionDebuff) and (v64 >= (4 + 0)) and (v89() >= (4 - 2))) or (v67 and v90() and (v64 >= (538 - (424 + 110)))))) then
					if ((v56 == "Player") or ((153 + 113) > (2957 + 2029))) then
						if (((394 + 1597) >= (1237 - (33 + 279))) and v24(v60.BonedustBrewPlayer, not v14:IsInRange(2 + 6))) then
							return "bonedust_brew cd_sef 10";
						end
					elseif (((1808 - (1338 + 15)) < (3476 - (528 + 895))) and (v56 == "Confirmation")) then
						if (v24(v58.BonedustBrew, not v14:IsInRange(20 + 20)) or ((2750 - (1606 + 318)) == (6670 - (298 + 1521)))) then
							return "bonedust_brew cd_sef 10";
						end
					elseif (((786 - 603) == (493 - (154 + 156))) and (v56 == "Cursor")) then
						if (((4405 - 3246) <= (3707 - 1919)) and v24(v60.BonedustBrewCursor, not v14:IsInRange(1155 - (712 + 403)))) then
							return "bonedust_brew cd_sef 10";
						end
					elseif ((v56 == "Enemy under Cursor") or ((3957 - (168 + 282)) > (8873 - 4555))) then
						if ((v16 and v16:Exists() and v13:CanAttack(v16)) or ((3033 + 42) <= (12 + 2953))) then
							if (((3852 - 2487) <= (3462 - (1242 + 209))) and v24(v60.BonedustBrewCursor, not v14:IsInRange(719 - (20 + 659)))) then
								return "bonedust_brew cd_sef 10";
							end
						end
					end
				end
				if ((v13:BuffDown(v58.BonedustBrewBuff) and v58.BonedustBrew:IsAvailable() and (v58.BonedustBrew:CooldownRemains() <= (2 + 0)) and (((v66 > (42 + 18)) and ((v58.StormEarthAndFire:Charges() > (0 - 0)) or (v58.StormEarthAndFire:CooldownRemains() > (20 - 10))) and (v67 or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (629 - (427 + 192))) or v69)) or ((v67 or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (29 - 16))) and ((v58.StormEarthAndFire:Charges() > (0 + 0)) or (v58.StormEarthAndFire:CooldownRemains() > (1960 - (1427 + 520))) or v13:BuffUp(v58.StormEarthAndFireBuff))))) or ((1418 + 1358) > (13567 - 9992))) then
					local v206 = 0 + 0;
					local v207;
					while true do
						if ((v206 == (1232 - (712 + 520))) or ((6382 - 3828) == (6150 - (565 + 781)))) then
							v207 = v107();
							if (((3142 - (35 + 530)) == (1273 + 1304)) and v207) then
								return v207;
							end
							break;
						end
					end
				end
				if ((v58.StormEarthAndFire:IsCastable() and ((v66 < (71 - 51)) or ((v58.StormEarthAndFire:Charges() == (1380 - (1330 + 48))) and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > v58.StormEarthAndFire:FullRechargeTime()) and (v58.FistsofFury:CooldownRemains() <= (7 + 2)) and (v13:Chi() >= (1 + 1)) and (v58.WhirlingDragonPunch:CooldownRemains() <= (20 - 8))))) or ((26 - 20) >= (3058 - (854 + 315)))) then
					if (((1620 - 1114) <= (568 + 1324)) and v22(v58.StormEarthAndFire, nil)) then
						return "storm_earth_and_fire cd_sef 12";
					end
				end
				v154 = 46 - (31 + 13);
			end
			if ((v154 == (0 - 0)) or ((4652 - 2644) > (1656 + 562))) then
				if (((942 - (281 + 282)) <= (11613 - 7466)) and v58.SummonWhiteTigerStatue:IsCastable() and (v58.InvokeXuenTheWhiteTiger:CooldownUp() or (v64 > (3 + 1)) or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (999 - (216 + 733))) or (v66 <= (1877 - (137 + 1710))))) then
					if ((v57 == "Player") or ((12546 - 8032) <= (1547 - (100 + 438)))) then
						if (v24(v60.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(1370 - (205 + 1160))) or ((2361 + 1135) == (608 + 584))) then
							return "summon_white_tiger_statue cd_sef 2";
						end
					elseif ((v57 == "Cursor") or ((1513 - (535 + 770)) == (195 + 2764))) then
						if (((2347 + 1930) >= (3307 - (211 + 1783))) and v24(v60.SummonWhiteTigerStatueCursor)) then
							return "summon_white_tiger_statue cd_sef 2";
						end
					end
				end
				if (((412 + 2175) < (4603 - (1236 + 193))) and v58.InvokeXuenTheWhiteTiger:IsCastable() and ((not v69 and (v14:TimeToDie() > (935 - (793 + 117))) and v58.BonedustBrew:IsAvailable() and (v58.BonedustBrew:CooldownRemains() <= (1897 - (1607 + 285))) and (((v64 < (863 - (747 + 113))) and (v13:Chi() >= (1979 - (80 + 1896)))) or ((v64 >= (14 - 11)) and (v13:Chi() >= (2 - 0))))) or (v66 < (24 + 1)))) then
					if (v22(v58.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(94 - 54)) or ((2177 + 1943) <= (6498 - 4300))) then
						return "invoke_xuen_the_white_tiger cd_sef 4";
					end
				end
				if ((v58.InvokeXuenTheWhiteTiger:IsCastable() and (((v14:TimeToDie() > (15 + 10)) and (v66 > (37 + 83))) or ((v66 < (143 - 83)) and ((v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (456 - (246 + 208))) or (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (1947 - (614 + 1278)))) and v58.Serenity:CooldownUp() and (v64 < (2 + 1))) or v13:BloodlustUp() or (v66 < (337 - (249 + 65))))) or ((3637 - 2041) == (2133 - (726 + 549)))) then
					if (((2174 + 1046) == (4644 - (916 + 508))) and v22(v58.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(134 - 94))) then
						return "invoke_xuen_the_white_tiger cd_sef 6";
					end
				end
				if ((v58.StormEarthAndFire:IsCastable() and v58.BonedustBrew:IsAvailable() and (((v66 < (20 + 10)) and (v58.BonedustBrew:CooldownRemains() < (327 - (140 + 183))) and (v13:Chi() >= (3 + 1))) or v13:BuffUp(v58.BonedustBrewBuff) or (not v90() and (v64 >= (567 - (297 + 267))) and (v58.BonedustBrew:CooldownRemains() <= (2 + 0)) and (v13:Chi() >= (344 - (37 + 305))))) and (v67 or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > v58.StormEarthAndFire:FullRechargeTime()))) or ((2668 - (323 + 943)) > (1442 + 2178))) then
					if (((3366 - 792) == (4109 - (394 + 1141))) and v22(v58.StormEarthAndFire, nil)) then
						return "storm_earth_and_fire cd_sef 8";
					end
				end
				v154 = 1 + 0;
			end
			if (((509 + 1289) < (188 + 2569)) and (v154 == (3 - 0))) then
				if ((v58.Fireblood:IsCastable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (44 - 14)) or v69 or (v66 < (10 + 0)))) or ((347 + 30) > (3133 - (87 + 442)))) then
					if (((1373 - (13 + 792)) < (844 + 67)) and v22(v58.Fireblood, nil)) then
						return "fireblood cd_sef 26";
					end
				end
				if (((1365 + 1920) < (3987 + 241)) and v58.Berserking:IsCastable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (1895 - (1231 + 634))) or v69 or (v66 < (1781 - (1362 + 404))))) then
					if (((11027 - 7111) > (2351 + 977)) and v22(v58.Berserking, nil)) then
						return "berserking cd_sef 28";
					end
				end
				if (((7016 - 4516) < (4855 - (660 + 356))) and v58.BagofTricks:IsCastable() and (v13:BuffDown(v58.StormEarthAndFireBuff))) then
					if (((727 - 220) == (458 + 49)) and v22(v58.BagofTricks, nil)) then
						return "bag_of_tricks cd_sef 30";
					end
				end
				if (((2190 - (1111 + 839)) <= (4116 - (496 + 455))) and v58.LightsJudgment:IsCastable()) then
					if (((1532 - (66 + 632)) >= (1283 - 478)) and v22(v58.LightsJudgment, nil)) then
						return "lights_judgment cd_sef 32";
					end
				end
				break;
			end
		end
	end
	local function v109()
		if ((v58.SummonWhiteTigerStatue:IsCastable() and (v58.InvokeXuenTheWhiteTiger:CooldownUp() or (v64 > (1140 - (441 + 695))) or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (132 - 82)) or (v66 <= (56 - 26)))) or ((18176 - 14364) < (1408 + 908))) then
			if ((v57 == "Player") or ((4490 - (286 + 1552)) <= (2810 - (1016 + 261)))) then
				if (v24(v60.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(1325 - (708 + 612))) or ((9991 - 6393) < (624 + 836))) then
					return "summon_white_tiger_statue cd_serenity 2";
				end
			elseif ((v57 == "Cursor") or ((4495 - (113 + 266)) < (2362 - (979 + 191)))) then
				if (v24(v60.SummonWhiteTigerStatueCursor) or ((5985 - 2608) <= (2638 - (339 + 1396)))) then
					return "summon_white_tiger_statue cd_serenity 2";
				end
			end
		end
		if (((1169 + 2807) >= (337 + 102)) and v58.InvokeXuenTheWhiteTiger:IsCastable() and ((not v69 and v58.BonedustBrew:IsAvailable() and (v58.BonedustBrew:CooldownRemains() <= (9 - 4)) and (v14:TimeToDie() > (25 + 0))) or v13:BloodlustUp() or (v66 < (6 + 19)))) then
			if (((4099 - (187 + 160)) == (8543 - 4791)) and v22(v58.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(138 - 98))) then
				return "invoke_xuen_the_white_tiger cd_serenity 4";
			end
		end
		if (((596 + 3450) > (8448 - 5753)) and v58.InvokeXuenTheWhiteTiger:IsCastable() and (((v14:TimeToDie() > (4 + 21)) and (v66 > (9 + 111))) or ((v66 < (111 - 51)) and ((v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (330 - (56 + 272))) or (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (32 + 23))) and v58.Serenity:CooldownUp() and (v64 < (3 + 0))) or v13:BloodlustUp() or (v66 < (54 - 31)))) then
			if (v22(v58.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(27 + 13)) or ((4185 - (455 + 185)) == (3985 - (757 + 31)))) then
				return "invoke_xuen_the_white_tiger cd_serenity 6";
			end
		end
		if (((4393 - (762 + 1237)) > (771 - 398)) and v58.BonedustBrew:IsCastable() and (v13:BuffUp(v58.InvokersDelightBuff) or (v13:BuffDown(v58.BonedustBrewBuff) and (v58.Serenity:CooldownUp() or (v58.Serenity:CooldownRemains() > (284 - (265 + 4))) or ((v66 < (75 - 45)) and (v66 > (7 + 3))))) or (v66 < (18 - 8)))) then
			if (((11654 - 7499) <= (468 + 3764)) and (v56 == "Player")) then
				if (v24(v60.BonedustBrewPlayer, not v14:IsInRange(21 - 13)) or ((7741 - 4160) == (6787 - 3314))) then
					return "bonedust_brew cd_serenity 8";
				end
			elseif (((6729 - (1691 + 43)) > (3196 + 152)) and (v56 == "Confirmation")) then
				if (v24(v58.BonedustBrew, not v14:IsInRange(125 - 85)) or ((183 + 571) > (13591 - 9867))) then
					return "bonedust_brew cd_serenity 8";
				end
			elseif (((393 - (127 + 49)) >= (1737 - (281 + 1399))) and (v56 == "Cursor")) then
				if (v24(v60.BonedustBrewCursor, not v14:IsInRange(1699 - (184 + 1475))) or ((2632 - 562) >= (9412 - 5375))) then
					return "bonedust_brew cd_serenity 8";
				end
			elseif (((6085 - 3380) == (1682 + 1023)) and (v56 == "Enemy under Cursor")) then
				if (((51 + 10) == (1352 - (260 + 1031))) and v16 and v16:Exists() and v13:CanAttack(v16)) then
					if (v24(v60.BonedustBrewCursor, not v14:IsInRange(1217 - (313 + 864))) or ((1391 - (655 + 37)) >= (1103 + 193))) then
						return "bonedust_brew cd_serenity 8";
					end
				end
			end
		end
		if ((v58.Serenity:IsCastable() and ((v71 and (v13:BuffUp(v58.InvokersDelightBuff) or (v69 and ((v58.DrinkingHornCover:IsAvailable() and (v66 > (185 - 75))) or (not v58.DrinkingHornCover:IsAvailable() and (v66 > (235 - 130))))))) or not v58.InvokeXuenTheWhiteTiger:IsAvailable() or (v66 < (6 + 9)))) or ((1380 + 403) >= (6837 - 3221))) then
			if (v22(v58.Serenity, nil) or ((4683 - (383 + 387)) > (1334 + 3193))) then
				return "serenity cd_serenity 10";
			end
		end
		if (((299 + 4077) > (2528 - 1711)) and v58.Serenity:IsCastable() and not v71 and (v13:BuffUp(v58.InvokersDelightBuff) or (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > v66) or ((v66 > (v58.InvokeXuenTheWhiteTiger:CooldownRemains() + 3 + 7)) and (v66 > (22 + 68))))) then
			if (((5371 - (304 + 206)) > (1049 - (182 + 43))) and v22(v58.Serenity, nil)) then
				return "serenity cd_serenity 12";
			end
		end
		if ((v58.TouchofDeath:CooldownUp() and v47) or ((2158 - (264 + 511)) >= (317 + 1814))) then
			local v174 = 0 - 0;
			local v175;
			local v176;
			while true do
				if ((v174 == (983 - (128 + 853))) or ((3578 - (1635 + 67)) >= (237 + 2304))) then
					if (((668 + 1114) <= (3969 - (131 + 66))) and v176 and v87(v58.TouchofDeath)) then
						if (v175 or ((16494 - 11794) < (3989 - 3176))) then
							if (((1130 + 2069) < (2393 + 1657)) and ((v176:TimeToDie() > (91 - 31)) or v176:DebuffUp(v58.BonedustBrewDebuff) or (v66 < (16 - 6))) and v13:BuffDown(v58.SerenityBuff)) then
								if ((v176:GUID() == v14:GUID()) or ((6556 - (306 + 1299)) < (1489 + 2941))) then
									if (((246 - 150) == (885 - (671 + 118))) and v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(19 - 14))) then
										return "touch_of_death cd_sef main-target 14";
									end
								elseif ((((GetTime() - v82.LastTargetSwap) * (1076 - (73 + 3))) >= v34) or ((7739 - 5000) > (18965 - 14957))) then
									v82.LastTargetSwap = GetTime();
									if (v24(v23(234 - 134)) or ((1778 - (1668 + 87)) == (98 + 1036))) then
										return "touch_of_death cd_sef off-target 14";
									end
								end
							end
						elseif (v13:BuffDown(v58.SerenityBuff) or ((4592 - (296 + 1603)) >= (4217 - (79 + 27)))) then
							if ((v176:GUID() == v14:GUID()) or ((3437 + 879) <= (3153 - (700 + 307)))) then
								if (v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(4 + 1)) or ((5345 - (1477 + 322)) <= (891 + 1918))) then
									return "touch_of_death cd_sef main-target 16";
								end
							elseif (((11297 - 6393) > (2104 + 62)) and (((GetTime() - v82.LastTargetSwap) * (3242 - 2242)) >= v34)) then
								local v246 = 0 + 0;
								while true do
									if (((443 - 334) >= (237 - 147)) and (v246 == (0 + 0))) then
										v82.LastTargetSwap = GetTime();
										if (((11523 - 6545) > (4652 - 1747)) and v24(v23(201 - 101))) then
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
				if ((v174 == (1787 - (20 + 1766))) or ((5851 - 2825) <= (3089 - (88 + 721)))) then
					if ((v30 and v31) or ((1635 + 18) <= (78 + 1030))) then
						v176 = v91();
					elseif (((1243 + 1666) > (885 + 1724)) and v58.TouchofDeath:IsReady()) then
						v176 = v14;
					end
					if (((1941 - 1184) > (378 - 184)) and v176) then
						if ((v175 and v13:BuffDown(v58.SerenityBuff) and v87(v58.TouchofDeath) and (v176:Health() < v13:Health())) or (v13:BuffRemains(v58.HiddenMastersForbiddenTouchBuff) < (439 - (93 + 344))) or (v13:BuffRemains(v58.HiddenMastersForbiddenTouchBuff) > v176:TimeToDie()) or ((1244 - (960 + 253)) >= (310 + 1088))) then
							if (((9489 - 6293) <= (14307 - 9435)) and (v176:GUID() == v14:GUID())) then
								if (((4742 - (74 + 1342)) == (846 + 2480)) and v22(v58.TouchofDeath, nil, nil, not v14:IsInMeleeRange(479 - (33 + 441)))) then
									return "touch_of_death cd_sef main-target 12";
								end
							elseif (((4086 - 2653) <= (5297 - (64 + 1355))) and (((GetTime() - v82.LastTargetSwap) * (1461 - 461)) >= v34)) then
								v82.LastTargetSwap = GetTime();
								if (v24(v23(111 - (5 + 6))) or ((234 + 1349) == (435 + 1300))) then
									return "touch_of_death cd_sef off-target 12";
								end
							end
						end
					end
					v174 = 448 - (369 + 77);
				end
				if ((v174 == (0 + 0)) or ((3719 - (438 + 300)) == (2644 - (50 + 244)))) then
					v175 = v13:IsInParty() and not v13:IsInRaid();
					v176 = nil;
					v174 = 1202 - (95 + 1106);
				end
			end
		end
		if ((v46 and v58.TouchofKarma:IsCastable() and ((v66 > (169 - 79)) or (v66 < (49 - 39)))) or ((6362 - (1741 + 155)) <= (1418 - 925))) then
			if (v22(v58.TouchofKarma, nil) or ((3822 - 1275) <= (4165 - 2178))) then
				return "touch_of_karma cd_serenity 18";
			end
		end
		if (((1462 + 1499) > (1258 + 1482)) and (v13:BuffUp(v58.SerenityBuff) or (v66 < (11 + 9)))) then
			local v177 = 0 - 0;
			while true do
				if (((9255 - 5559) >= (5389 - (1263 + 514))) and (v177 == (499 - (73 + 424)))) then
					if (v58.BagofTricks:IsCastable() or ((7819 - 4849) == (2186 - (93 + 215)))) then
						if (v22(v58.BagofTricks, nil) or ((12890 - 9197) < (3912 - (1756 + 179)))) then
							return "bag_of_tricks cd_serenity 28";
						end
					end
					break;
				end
				if ((v177 == (1679 - (550 + 1129))) or ((1037 - (57 + 50)) > (2730 - (30 + 599)))) then
					if (((1027 + 3126) > (4144 - 1058)) and v58.AncestralCall:IsCastable()) then
						if (v22(v58.AncestralCall, nil) or ((5572 - (794 + 124)) <= (516 + 3534))) then
							return "ancestral_call cd_serenity 20";
						end
					end
					if (v58.BloodFury:IsCastable() or ((357 + 2245) < (3010 - 1514))) then
						if (v22(v58.BloodFury, nil) or ((2947 - (1299 + 628)) > (5041 - 2753))) then
							return "blood_fury cd_serenity 22";
						end
					end
					v177 = 2 - 1;
				end
				if (((301 + 27) == (952 - 624)) and (v177 == (1446 - (335 + 1110)))) then
					if (((1452 + 59) < (12539 - 8731)) and v58.Fireblood:IsCastable()) then
						if (v22(v58.Fireblood, nil) or ((4479 - 1969) > (5251 - (268 + 64)))) then
							return "fireblood cd_serenity 24";
						end
					end
					if (((3150 + 1613) == (6041 - (243 + 1035))) and v58.Berserking:IsCastable()) then
						if (((9993 - 5856) > (8585 - 6737)) and v22(v58.Berserking, nil)) then
							return "berserking cd_serenity 26";
						end
					end
					v177 = 8 - 6;
				end
			end
		end
		if (((1508 + 928) <= (2761 + 373)) and v58.LightsJudgment:IsCastable()) then
			if (((4594 - 871) == (3823 - (90 + 10))) and v22(v58.LightsJudgment, nil)) then
				return "lights_judgment cd_serenity 30";
			end
		end
	end
	local function v110()
		if ((v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (805 - (209 + 595)))) or ((4851 - (603 + 202)) >= (2637 + 1679))) then
			if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(97 - 67)) or ((981 + 1027) < (5466 - 3537))) then
				return "faeline_stomp serenity_aoelust 2";
			end
		end
		if (((105 + 2279) > (4916 - 3141)) and v58.StrikeoftheWindlord:IsReady() and v13:HasTier(129 - 98, 283 - (174 + 105)) and v58.Thunderfist:IsAvailable()) then
			if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(29 - 20)) or ((5456 - (532 + 381)) <= (3705 + 671))) then
				return "strike_of_the_windlord serenity_aoelust 4";
			end
		end
		if (((1567 - (137 + 702)) == (1962 - 1234)) and v58.FistsofFury:IsReady() and v13:BuffUp(v58.InvokersDelightBuff) and not v13:HasTier(3 + 27, 7 - 5)) then
			if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(1894 - (1819 + 67))) or ((645 + 431) > (1495 + 3176))) then
				return "fists_of_fury serenity_aoelust 6";
			end
		end
		if (((3208 - (259 + 1098)) >= (261 + 117)) and v13:IsCasting(v58.FistsofFury)) then
			if (v24(v60.StopFoF) or ((320 + 1628) >= (197 + 3279))) then
				return "fists_of_fury_cancel serenity_aoelust 8";
			end
		end
		if (((16176 - 11382) >= (311 + 522)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and not v90() and v58.ShadowboxingTreads:IsAvailable()) then
			if (((3987 + 103) == (19127 - 15037)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1711 - (667 + 1039)))) then
				return "blackout_kick serenity_aoelust 10";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (1022 - (274 + 745))) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1 + 0))) or ((1520 + 2238) == (2928 - (288 + 142)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1311 - (301 + 1005))) or ((1204 + 1469) < (3824 - 2249))) then
				return "blackout_kick serenity_aoelust 12";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((5594 - (674 + 1199)) <= (1279 + 176))) then
			if (((559 + 375) < (6666 - 4396)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(34 - 26))) then
				return "spinning_crane_kick serenity_aoelust 14";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v13:HasTier(7 + 24, 447 - (92 + 353)) and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v58.BlackoutKick) and v13:BuffUp(v58.DanceofChijiBuff)) or ((3997 - 2385) == (2375 - 1120))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(22 - 14)) or ((2379 + 1973) < (7516 - 3310))) then
				return "spinning_crane_kick serenity_aoelust 16";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v13:HasTier(69 - 38, 8 - 6) and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) or ((2460 + 400) <= (359 - 178))) then
			if (((3487 - (34 + 231)) >= (2844 - (930 + 387))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "blackout_kick serenity_aoelust 18";
			end
		end
		if (((915 + 590) <= (5888 - 3767)) and v58.SpinningCraneKick:IsReady() and v13:HasTier(728 - (389 + 308), 4 - 2) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (((1692 - 948) == (2075 - 1331)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(4 + 4))) then
				return "spinning_crane_kick serenity_aoelust 20";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v64 < (328 - (125 + 197))) and v87(v58.BlackoutKick) and v13:HasTier(1028 - (339 + 658), 4 - 2)) or ((4050 - 2071) >= (4184 - (743 + 605)))) then
			if (((1680 + 153) <= (273 + 2395)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(18 - 13))) then
				return "blackout_kick serenity_aoelust 22";
			end
		end
		if (((11360 - 7674) == (2438 + 1248)) and v58.RisingSunKick:IsReady() and (v13:HasTier(279 - (197 + 52), 3 - 1))) then
			if (((7895 - 4428) > (288 + 189)) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2))) then
				return "rising_sun_kick serenity_aoelust 24";
			end
		end
		if ((v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff) and (v64 < (17 - 7))) or ((11069 - 7781) >= (8077 - 4536))) then
			if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, v101, not v14:IsInMeleeRange(4 + 4)) or ((4975 - 1418) == (5637 - (97 + 1000)))) then
				return "strike_of_the_windlord serenity_aoelust 26";
			end
		end
		if ((v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (6 - 4))) or ((2106 - (143 + 1702)) > (2664 - 1397))) then
			if (((1641 - (40 + 329)) < (3271 + 587)) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(11 + 19))) then
				return "faeline_stomp serenity_aoelust 28";
			end
		end
		if (((5600 - 1936) == (400 + 3264)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
			if (((2006 - (9 + 56)) >= (1034 - (531 + 53))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v63, "max", v99, nil, not v14:IsInMeleeRange(8 + 0))) then
				return "strike_of_the_windlord serenity_aoelust 30";
			end
		end
		if ((v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) or ((5419 - (89 + 684)) < (225 + 99))) then
			if (((1257 + 2576) == (1060 + 2773)) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(13 - 5))) then
				return "fists_of_fury serenity_aoelust 32";
			end
		end
		if (v13:IsCasting(v58.FistsofFury) or ((916 + 324) > (2867 + 503))) then
			if (v24(v60.StopFoF) or ((3094 - (238 + 375)) == (4028 + 654))) then
				return "fists_of_fury_cancel serenity_aoelust 34";
			end
		end
		if (((6711 - 1984) >= (198 + 10)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff)) then
			if (((820 - 540) < (10145 - 6294)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(21 - 13))) then
				return "spinning_crane_kick serenity_aoelust 36";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v64 < (12 - 6)) and v87(v58.BlackoutKick) and v13:HasTier(111 - 81, 2 - 0)) or ((2782 + 225) > (259 + 2935))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((2598 - (428 + 34)) >= (682 + 2264))) then
				return "blackout_kick serenity_aoelust 38";
			end
		end
		if (((3389 - 1224) <= (5521 - 3000)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v90()) then
			if (((6855 - 3994) > (1579 - (223 + 695))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(24 - 16))) then
				return "spinning_crane_kick serenity_aoelust 40";
			end
		end
		if (((5036 - (329 + 182)) > (747 + 3772)) and v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v64 == (8 - 3))) then
			if (((427 + 2751) > (82 + 890)) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v95, nil, not v14:IsInMeleeRange(3 + 2))) then
				return "tiger_palm serenity_aoelust 42";
			end
		end
		if (((10151 - 5385) == (6454 - 1688)) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
			if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(1208 - (177 + 1023))) or ((5539 - 2794) > (860 + 2268))) then
				return "rushing_jade_wind serenity_aoelust 44";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and (v64 >= (6 - 3)) and v87(v58.BlackoutKick)) or ((2609 - (120 + 1345)) >= (4943 - (8 + 329)))) then
			if (((3463 - (19 + 106)) >= (988 - 711)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(6 - 1))) then
				return "blackout_kick serenity_aoelust 46";
			end
		end
		if (((2534 + 76) > (7536 - 4976)) and v58.StrikeoftheWindlord:IsReady()) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(23 - 14)) or ((4584 - 3390) > (6507 - 3424))) then
				return "strike_of_the_windlord serenity_aoelust 48";
			end
		end
		if (((244 + 672) >= (2250 - (957 + 546))) and v58.SpinningCraneKick:IsReady() and (v87(v58.SpinningCraneKick))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(33 - 25)) or ((924 + 1520) > (743 + 2211))) then
				return "spinning_crane_kick serenity_aoelust 50";
			end
		end
		if (((1095 + 1797) < (1628 + 1886)) and v58.WhirlingDragonPunch:IsReady()) then
			if (((1236 - (227 + 476)) == (1104 - 571)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(8 - 3))) then
				return "whirling_dragon_punch serenity_aoelust 52";
			end
		end
		if (((853 - 258) <= (6230 - 2817)) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
			if (((4124 - 1046) >= (3545 - (166 + 788))) and v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(994 - (21 + 965)))) then
				return "rushing_jade_wind serenity_aoelust 54";
			end
		end
		if (((3895 - (127 + 569)) < (3395 + 635)) and v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) then
			if (((252 + 525) < (751 + 1327)) and v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(7 - 2))) then
				return "blackout_kick serenity_aoelust 56";
			end
		end
		if (((1099 + 597) <= (5846 - 3564)) and v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (2 + 1))) then
			if (v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(2 + 3)) or ((3053 - (1162 + 130)) >= (5235 - 2773))) then
				return "tiger_palm serenity_aoelust 58";
			end
		end
	end
	local function v111()
		local v155 = 0 + 0;
		while true do
			if (((10182 - 5631) > (3264 - (889 + 47))) and (v155 == (2 + 0))) then
				if (((5089 - (1153 + 111)) >= (615 - 148)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v58.FistsofFury) and v58.ShadowboxingTreads:IsAvailable() and v13:HasTier(17 + 14, 1 + 1) and not v58.DanceofChiji:IsAvailable()) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((385 + 2505) == (1049 - 492))) then
						return "blackout_kick serenity_lust 14";
					end
				end
				if ((v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) or ((3302 + 1468) == (3000 - (23 + 73)))) then
					if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(293 - (26 + 259))) or ((1699 + 2204) == (7081 - 2545))) then
						return "fists_of_fury serenity_lust 12";
					end
				end
				if (((14360 - 10267) <= (6474 - (1094 + 535))) and v13:IsCasting(v58.FistsofFury)) then
					if (((179 + 1390) <= (5523 - (1554 + 322))) and v24(v60.StopFoF)) then
						return "fists_of_fury_cancel serenity_lust 14";
					end
				end
				v155 = 1428 - (989 + 436);
			end
			if ((v155 == (1178 - (816 + 362))) or ((7753 - 3707) >= (12395 - 7468))) then
				if (((17044 - 12421) >= (5110 - 2323)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (2 - 1))) then
					if (((9824 - 7590) >= (16 + 1214)) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(793 - (86 + 677)))) then
						return "faeline_stomp serenity_lust 2";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and (v13:BuffRemains(v58.SerenityBuff) < (1.5 + 0)) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff) and v13:HasTier(1 + 30, 1028 - (263 + 763))) or ((163 + 180) == (2644 - (649 + 209)))) then
					if (((11485 - 8915) > (3140 - (643 + 88))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1777 - (54 + 1715)))) then
						return "spinning_crane_kick serenity_lust 4";
					end
				end
				if ((v58.FistsofFury:IsReady() and (v13:BuffRemains(v58.SerenityBuff) < (3 - 2))) or ((7415 - 4806) >= (6605 - 3371))) then
					if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(7 + 1)) or ((298 + 2735) >= (15288 - 11257))) then
						return "fists_of_fury serenity_lust 4";
					end
				end
				v155 = 1384 - (132 + 1251);
			end
			if ((v155 == (1 + 0)) or ((3471 - 2070) == (3615 + 1053))) then
				if (((3234 - (185 + 273)) >= (321 + 1000)) and v58.RisingSunKick:IsReady()) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "max", v99, nil, not v14:IsInMeleeRange(14 - 9)) or ((183 + 304) > (3527 - (361 + 863)))) then
						return "rising_sun_kick serenity_lust 8";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (8 - 5)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1328 - (443 + 884)))) or ((10791 - 6288) == (762 + 2700))) then
					if (((778 - 225) <= (1228 + 315)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "blackout_kick serenity_lust 6";
					end
				end
				if (((4731 - 2716) == (2762 - (16 + 731))) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(5 + 4)) or ((2195 + 2046) <= (1790 + 542))) then
						return "strike_of_the_windlord serenity_lust 10";
					end
				end
				v155 = 762 - (527 + 233);
			end
			if ((v155 == (3 + 0)) or ((5385 - 3021) < (993 + 164))) then
				if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((2952 - (1107 + 678)) > (1050 + 228))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(5 + 0)) or ((1195 - (4 + 46)) <= (4079 - 2997))) then
						return "blackout_kick serenity_lust 18";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff)) or ((5709 - 2604) == (3227 + 1654))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(16 - 8)) or ((3021 - 1134) > (6274 - (1262 + 134)))) then
						return "spinning_crane_kick serenity_lust 20";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((10100 - 6013) > (1025 + 3091))) then
					if (((799 + 307) <= (2061 - (383 + 412))) and v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "blackout_kick serenity_lust 22";
					end
				end
				v155 = 1 + 3;
			end
			if (((1440 + 1715) < (1530 + 3120)) and (v155 == (4 + 0))) then
				if (((5179 - 1405) >= (1579 + 260)) and v58.WhirlingDragonPunch:IsReady()) then
					if (((8254 - 5443) == (3801 - 990)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(13 - 8))) then
						return "whirling_dragon_punch serenity_lust 24";
					end
				end
				if (((596 + 1550) > (1829 - (667 + 40))) and v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (1313 - (436 + 874)))) then
					if (v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(1611 - (762 + 844))) or ((96 - 40) == (8287 - 4671))) then
						return "tiger_palm serenity_lust 26";
					end
				end
				break;
			end
		end
	end
	local function v112()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (1 + 4)) or ((2897 - (209 + 267)) < (1140 - 518))) then
				if (((2838 - 1829) <= (2841 - (1611 + 100))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v90()) then
					if (((2086 + 672) < (3764 - (14 + 770))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1792 - (1165 + 619)))) then
						return "spinning_crane_kick serenity_aoe 42";
					end
				end
				if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v64 == (7 - 2))) or ((467 - (229 + 152)) >= (3820 - (107 + 87)))) then
					if (((4353 - 1958) == (965 + 1430)) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v95, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "tiger_palm serenity_aoe 44";
					end
				end
				if (((18050 - 14270) > (10410 - 7701)) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
					if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((251 - (13 + 1)) >= (2257 + 16))) then
						return "rushing_jade_wind serenity_aoe 46";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and (v64 >= (2 + 1)) and v87(v58.BlackoutKick)) or ((3098 - (987 + 71)) <= (2001 - 1298))) then
					if (((4219 - 940) <= (4666 - (514 + 185))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "blackout_kick serenity_aoe 48";
					end
				end
				v156 = 11 - 5;
			end
			if ((v156 == (0 - 0)) or ((3492 - (771 + 733)) == (1769 - 892))) then
				if (((9272 - 4981) > (3079 - (407 + 760))) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 0))) then
					if (((56 + 1947) < (1777 + 562)) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(1884 - (169 + 1685)))) then
						return "faeline_stomp serenity_aoe 2";
					end
				end
				if (((79 + 353) == (823 - (41 + 350))) and v58.StrikeoftheWindlord:IsReady() and v13:HasTier(84 - 53, 11 - 7) and v58.Thunderfist:IsAvailable()) then
					if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(37 - 28)) or ((2651 - 1506) >= (795 + 458))) then
						return "strike_of_the_windlord serenity_aoe 4";
					end
				end
				if (((4305 - (790 + 97)) > (9629 - 7511)) and v58.FistsofFury:IsReady() and v13:BuffUp(v58.InvokersDelightBuff) and not v13:HasTier(9 + 21, 1 + 1)) then
					if (((3311 - (235 + 10)) <= (2621 + 1269)) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(15 - 7))) then
						return "fists_of_fury serenity_aoe 6";
					end
				end
				if ((v13:IsCasting(v58.FistsofFury) and not v13:HasTier(1213 - (887 + 296), 1047 - (512 + 533))) or ((4422 - (662 + 762)) >= (3958 - (334 + 343)))) then
					if (v24(v60.StopFoF) or ((15578 - 10929) <= (3121 - (198 + 291)))) then
						return "fists_of_fury_cancel serenity_aoe 8";
					end
				end
				v156 = 1 + 0;
			end
			if ((v156 == (577 - (141 + 433))) or ((18109 - 14249) > (2677 + 2195))) then
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and not v90() and v58.ShadowboxingTreads:IsAvailable()) or ((4775 - (227 + 550)) == (5759 - 3461))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(13 - 8)) or ((111 - (72 + 31)) >= (3087 - (89 + 259)))) then
						return "blackout_kick serenity_aoe 10";
					end
				end
				if (((2265 + 325) == (2277 + 313)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff) and (v64 < (2 + 8))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v101, not v14:IsInMeleeRange(10 - 5)) or ((53 + 29) >= (3815 - 1945))) then
						return "strike_of_the_windlord serenity_aoe 28";
					end
				end
				if (((4027 - (1333 + 70)) < (6389 - (701 + 1131))) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (129 - (55 + 72)))) then
					if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(186 - (99 + 57))) or ((5255 - 2124) > (1843 + 1699))) then
						return "faeline_stomp serenity_aoe 30";
					end
				end
				if (((4156 - (1243 + 336)) >= (2907 - (774 + 555))) and v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) then
					if (((1957 + 2146) <= (5370 - (150 + 649))) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(6 + 2))) then
						return "fists_of_fury serenity_aoe 32";
					end
				end
				v156 = 5 - 1;
			end
			if ((v156 == (7 - 3)) or ((3479 - (1122 + 862)) == (9186 - 4399))) then
				if (v13:IsCasting(v58.FistsofFury) or ((59 + 251) > (8431 - 3997))) then
					if (((1316 + 852) <= (1381 + 2979)) and v24(v60.StopFoF)) then
						return "fists_of_fury_cancel serenity_aoe 34";
					end
				end
				if (((1737 - (549 + 194)) == (658 + 336)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
					if (((6585 - 4930) > (21 + 380)) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(13 - 4))) then
						return "strike_of_the_windlord serenity_aoe 36";
					end
				end
				if (((2611 + 452) <= (12319 - 8893)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff)) then
					if (((3162 - (453 + 1250)) > (2168 - 1404)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
						return "spinning_crane_kick serenity_aoe 38";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v64 < (581 - (203 + 372))) and v87(v58.BlackoutKick) and v13:HasTier(2 + 28, 5 - 3)) or ((2023 - (978 + 404)) > (13890 - 9556))) then
					if (((3025 + 374) >= (2578 - (56 + 262))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick serenity_aoe 40";
					end
				end
				v156 = 119 - (108 + 6);
			end
			if ((v156 == (4 + 2)) or ((352 + 41) >= (6194 - (653 + 1299)))) then
				if (((864 + 125) < (1958 + 2901)) and v58.StrikeoftheWindlord:IsReady()) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(11 - 6)) or ((6717 - (1042 + 880)) < (73 + 876))) then
						return "strike_of_the_windlord serenity_aoe 50";
					end
				end
				if (((4844 - (16 + 986)) == (5060 - (700 + 518))) and v58.SpinningCraneKick:IsReady() and (v87(v58.SpinningCraneKick))) then
					if (((5688 - 3941) <= (4356 - 755)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1519 - (617 + 894)))) then
						return "spinning_crane_kick serenity_aoe 52";
					end
				end
				if (v58.WhirlingDragonPunch:IsReady() or ((1605 - 801) > (4817 - (271 + 187)))) then
					if (((6254 - (731 + 853)) >= (12594 - 8971)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1526 - (199 + 1322)))) then
						return "whirling_dragon_punch serenity_aoe 54";
					end
				end
				if (((4046 - 1981) < (1324 + 1220)) and v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) then
					if (((2971 - (1291 + 369)) <= (81 + 3278)) and v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick serenity_aoe 56";
					end
				end
				v156 = 6 + 1;
			end
			if (((541 + 2176) <= (3841 - (561 + 124))) and (v156 == (2 + 0))) then
				if (((1934 - (25 + 828)) < (11420 - 6896)) and v58.SpinningCraneKick:IsReady() and v13:HasTier(55 - 24, 592 - (99 + 491)) and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.BlackoutReinforcementBuff) and v13:PrevGCD(49 - (18 + 30), v58.BlackoutKick)) then
					if (((1064 - 624) >= (140 - 69)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(12 - 4))) then
						return "spinning_crane_kick serenity_aoe 22";
					end
				end
				if (((1404 + 3530) > (8708 - 6101)) and v58.RisingSunKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(762 - (501 + 231), 2 + 0)) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1703 - (470 + 1228))) or ((1064 + 336) > (2017 + 1099))) then
						return "rising_sun_kick serenity_aoe 24";
					end
				end
				if (((1211 - (537 + 149)) < (2020 - 358)) and v58.RisingSunKick:IsReady() and (v13:HasTier(17 + 13, 3 - 1))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(15 - 10)) or ((2602 - 1726) > (1902 + 648))) then
						return "rising_sun_kick serenity_aoe 26";
					end
				end
				if (((76 + 143) <= (1512 + 944)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (2 + 1)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1 + 0))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4)) or ((2953 + 1266) == (1902 - 752))) then
						return "blackout_kick serenity_aoe 12";
					end
				end
				v156 = 2 + 1;
			end
			if ((v156 == (586 - (134 + 445))) or ((5946 - 2957) <= (206 + 16))) then
				if (((1295 + 963) > (4823 - 3582)) and v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (263 - (36 + 224)))) then
					if (((1901 - (1033 + 827)) < (6105 - (1002 + 844))) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(1355 - (1126 + 224)))) then
						return "tiger_palm serenity_aoe 58";
					end
				end
				break;
			end
			if ((v156 == (1 + 0)) or ((1907 + 23) < (189 - 133))) then
				if (((3397 - (48 + 16)) == (2382 + 951)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(38 - 30)) or ((7213 - 4988) == (6 + 14))) then
						return "spinning_crane_kick serenity_aoe 14";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v13:HasTier(1120 - (910 + 179), 3 - 1) and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.BlackoutReinforcementBuff) and v13:PrevGCD(1 - 0, v58.BlackoutKick) and v13:BuffUp(v58.DanceofChijiBuff)) or ((2251 - (933 + 446)) >= (1214 + 1878))) then
					if (((5928 - (248 + 1276)) >= (3063 + 189)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(4 + 4))) then
						return "spinning_crane_kick serenity_aoe 16";
					end
				end
				if (((3768 - 2661) > (2694 - 1898)) and v58.BlackoutKick:IsReady() and v13:HasTier(1576 - (151 + 1394), 946 - (929 + 15)) and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) then
					if (((2955 - (1173 + 823)) == (1551 - 592)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1781 - (482 + 1294)))) then
						return "blackout_kick serenity_aoe 18";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v13:HasTier(63 - 32, 1 + 1) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((1551 - (1125 + 181)) >= (6429 - 4225))) then
					if (((1944 + 1218) >= (3328 - 1259)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1197 - (626 + 563)))) then
						return "spinning_crane_kick serenity_aoe 20";
					end
				end
				v156 = 1252 - (153 + 1097);
			end
		end
	end
	local function v113()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (2 + 1)) or ((782 - 476) > (1650 + 1431))) then
				if ((v58.BlackoutKick:IsReady() and v13:HasTier(25 + 6, 1 + 1) and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) or ((2497 + 1016) < (2365 + 341))) then
					if (((4135 - (199 + 958)) < (2336 + 1303)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6))) then
						return "blackout_kick serenity_4t 18";
					end
				end
				if (((8472 - 4790) >= (4064 - (1169 + 7))) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff)) then
					if (((2022 - (751 + 1122)) < (33 + 446)) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v101, not v14:IsInMeleeRange(9 + 0))) then
						return "strike_of_the_windlord serenity_4t 28";
					end
				end
				if (((233 + 787) >= (104 + 463)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (2 - 0))) then
					if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(1211 - (589 + 592))) or ((1464 - 731) > (747 + 1722))) then
						return "faeline_stomp serenity_4t 30";
					end
				end
				if (((2521 - (13 + 11)) == (1341 + 1156)) and v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) then
					if (((574 + 3327) == (5161 - (684 + 576))) and v82.CastTargetIf(v58.FistsofFury, v62, "max", v99, nil, not v14:IsInMeleeRange(4 + 4))) then
						return "fists_of_fury serenity_4t 32";
					end
				end
				v157 = 9 - 5;
			end
			if (((100 + 101) < (68 + 347)) and (v157 == (0 - 0))) then
				if ((v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 0))) or ((118 + 15) == (1071 + 713))) then
					if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(5 + 25)) or ((3 + 4) >= (2158 - (230 + 1618)))) then
						return "faeline_stomp serenity_4t 2";
					end
				end
				if (((3989 + 1003) > (96 + 190)) and v58.SpinningCraneKick:IsReady() and (v13:BuffRemains(v58.SerenityBuff) < (1.5 + 0)) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff) and v13:HasTier(234 - (131 + 72), 1 + 1)) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(212 - (144 + 60))) or ((10444 - 7883) == (6800 - 2907))) then
						return "spinning_crane_kick serenity_4t 4";
					end
				end
				if (((1332 + 3030) >= (6842 - 5421)) and v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and not v13:HasTier(3 + 28, 1924 - (523 + 1399))) then
					if (((73 + 2) <= (3950 - (72 + 332))) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v95, nil, not v14:IsInMeleeRange(981 - (269 + 707)))) then
						return "tiger_palm serenity_4t 6";
					end
				end
				if (((5313 - 2633) <= (8566 - 5148)) and v58.StrikeoftheWindlord:IsReady() and v13:HasTier(161 - (123 + 7), 4 + 0) and v58.Thunderfist:IsAvailable()) then
					if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(7 + 2)) or ((19512 - 15224) < (7221 - 4345))) then
						return "strike_of_the_windlord serenity_4t 8";
					end
				end
				v157 = 1089 - (38 + 1050);
			end
			if (((822 + 1640) >= (456 + 691)) and (v157 == (1 + 0))) then
				if ((v58.FistsofFury:IsReady() and v13:BuffUp(v58.InvokersDelightBuff) and not v13:HasTier(853 - (426 + 397), 1408 - (751 + 655))) or ((9837 - 4923) < (329 + 2151))) then
					if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(1253 - (39 + 1206))) or ((4799 - 3240) == (2081 - (566 + 275)))) then
						return "fists_of_fury serenity_4t 10";
					end
				end
				if (((1501 - (167 + 768)) == (216 + 350)) and v13:IsCasting(v58.FistsofFury) and not v13:HasTier(47 - 17, 1 + 1)) then
					if (((3757 + 164) >= (4099 - 1090)) and v24(v60.StopFoF)) then
						return "fists_of_fury_cancel serenity_4t 12";
					end
				end
				if (((2078 - (8 + 7)) >= (3331 - (1510 + 173))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:HasTier(43 - 12, 1 + 1) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
					if (((1319 - (30 + 223)) >= (1708 - (300 + 956))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(130 - (22 + 100)))) then
						return "spinning_crane_kick serenity_4t 14";
					end
				end
				if (((10966 - 5992) >= (2937 - (47 + 235))) and v58.RisingSunKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and not v58.BonedustBrew:IsAvailable()) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(16 - 11)) or ((1573 + 1148) <= (1393 - (21 + 465)))) then
						return "rising_sun_kick serenity_4t 20";
					end
				end
				v157 = 2 + 0;
			end
			if (((2968 + 1469) >= (913 + 2118)) and (v157 == (8 - 1))) then
				if ((v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (1220 - (553 + 664)))) or ((1805 + 2665) < (3027 - (73 + 5)))) then
					if (v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(1720 - (1128 + 587))) or ((6134 - 4554) == (3116 - (558 + 132)))) then
						return "tiger_palm serenity_4t 58";
					end
				end
				break;
			end
			if ((v157 == (16 - 10)) or ((10509 - 6798) == (139 + 364))) then
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((331 + 89) == (1893 + 2425))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((6889 - 2731) <= (12 + 21))) then
						return "spinning_crane_kick serenity_4t 50";
					end
				end
				if (v58.WhirlingDragonPunch:IsReady() or ((51 + 48) > (5515 - (294 + 477)))) then
					if (((1511 + 2830) == (9828 - 5487)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(9 - 4))) then
						return "whirling_dragon_punch serenity_4t 52";
					end
				end
				if (((67 + 188) <= (1308 + 288)) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
					if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(18 - 10)) or ((5415 - (97 + 885)) < (768 + 867))) then
						return "rushing_jade_wind serenity_4t 54";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((7249 - 2949) < (3609 - (271 + 94)))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(1608 - (777 + 826))) or ((1336 + 2198) > (6032 - (117 + 1238)))) then
						return "blackout_kick serenity_4t 56";
					end
				end
				v157 = 1722 - (686 + 1029);
			end
			if ((v157 == (1358 - (1074 + 282))) or ((6476 - (1359 + 258)) < (6783 - 3784))) then
				if (((6661 - (1730 + 205)) > (2935 - (67 + 461))) and v58.RisingSunKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(53 - 23, 2 - 0)) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6)) or ((78 + 1206) > (4298 - (129 + 500)))) then
						return "rising_sun_kick serenity_4t 22";
					end
				end
				if (((2828 - (1157 + 554)) < (3685 - 1136)) and v58.RisingSunKick:IsReady() and (v13:HasTier(637 - (82 + 525), 2 + 0))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6)) or ((4474 - (948 + 675)) > (1536 + 3238))) then
						return "rising_sun_kick serenity_4t 24";
					end
				end
				if (((931 + 100) < (10724 - 6876)) and v58.SpinningCraneKick:IsReady() and v13:HasTier(884 - (406 + 447), 119 - (91 + 26)) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
					if (((6419 - 4565) > (679 + 224)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(994 - (968 + 18)))) then
						return "spinning_crane_kick serenity_4t 26";
					end
				end
				if (((4608 + 55) > (1692 + 168)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (5 - 2)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (268 - (172 + 95)))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(16 - 11)) or ((3318 - (260 + 5)) <= (1276 - 807))) then
						return "blackout_kick serenity_4t 16";
					end
				end
				v157 = 822 - (265 + 554);
			end
			if ((v157 == (1575 - (1440 + 131))) or ((1535 - 995) >= (3264 - (253 + 1142)))) then
				if (((3545 - (133 + 120)) == (7043 - 3751)) and v13:IsCasting(v58.FistsofFury)) then
					if (((2994 - (809 + 1147)) <= (3142 - (178 + 319))) and v24(v60.StopFoF)) then
						return "fists_of_fury_cancel serenity_4t 34";
					end
				end
				if ((v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) or ((6283 - 3053) < (1376 + 1149))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(1279 - (1255 + 15))) or ((3942 - (1221 + 321)) > (11386 - 7303))) then
						return "strike_of_the_windlord serenity_4t 36";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((2130 + 615) > (16366 - 12007))) then
					if (((639 - 467) <= (824 + 986)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
						return "spinning_crane_kick serenity_4t 38";
					end
				end
				if ((v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.PressurePointBuff))) or ((1027 - 535) >= (5366 - (204 + 203)))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(83 - (48 + 30))) or ((344 + 412) == (4036 - (1472 + 492)))) then
						return "rising_sun_kick serenity_4t 40";
					end
				end
				v157 = 13 - 8;
			end
			if (((946 + 659) <= (5275 - (258 + 353))) and (v157 == (1999 - (1382 + 612)))) then
				if (((1710 + 106) == (70 + 1746)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(1 + 29, 5 - 3)) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(4 + 1)) or ((740 - (35 + 84)) > (3315 - (75 + 140)))) then
						return "blackout_kick serenity_4t 42";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v90()) or ((4205 - 3048) >= (6024 - (923 + 876)))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(21 - 13)) or ((5798 - (284 + 528)) == (5157 - (867 + 152)))) then
						return "spinning_crane_kick serenity_4t 44";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick)) or ((3139 - (709 + 397)) <= (793 - 569))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(41 - (21 + 15))) or ((2046 - 823) == (3707 - 1696))) then
						return "blackout_kick serenity_4t 46";
					end
				end
				if (((1013 + 3814) > (13911 - 9216)) and v58.StrikeoftheWindlord:IsReady()) then
					if (((9243 - 5533) > (1328 + 1737)) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(144 - (97 + 38)))) then
						return "strike_of_the_windlord serenity_4t 48";
					end
				end
				v157 = 86 - (52 + 28);
			end
		end
	end
	local function v114()
		if (((1028 + 1107) <= (3545 - (59 + 790))) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 0))) then
			if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(5 + 25)) or ((2682 - (467 + 473)) > (21819 - 17422))) then
				return "faeline_stomp serenity_3t 2";
			end
		end
		if (((10650 - 6750) >= (4554 - 2650)) and v58.BlackoutKick:IsReady() and v13:HasTier(79 - 48, 1 + 1) and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6)) or ((6894 - 5170) == (1541 - 632))) then
				return "blackout_kick serenity_3t 4";
			end
		end
		if (((287 + 995) < (265 + 1156)) and v58.TigerPalm:IsReady() and (v87(v58.TigerPalm))) then
			if (((1769 + 3107) >= (4574 - (58 + 179))) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v95, nil, not v14:IsInMeleeRange(12 - 7))) then
				return "tiger_palm serenity_3t 6";
			end
		end
		if (((5258 - (677 + 576)) >= (1296 + 1709)) and v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.PressurePointBuff))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6)) or ((5001 - (88 + 132)) <= (4118 + 330))) then
				return "rising_sun_kick serenity_3t 8";
			end
		end
		if (((6548 - 5231) > (603 - 431)) and v58.RisingSunKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(321 - (12 + 279), 3 - 1)) then
			if (((579 + 4212) == (5738 - (652 + 295))) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "rising_sun_kick serenity_3t 10";
			end
		end
		if (((2306 + 1682) > (2250 - (848 + 141))) and v58.RisingSunKick:IsReady() and (v13:HasTier(770 - (372 + 368), 2 + 0))) then
			if (((3370 - (542 + 588)) <= (4434 - (6 + 812))) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1710 - (1599 + 106)))) then
				return "rising_sun_kick serenity_3t 12";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (7 - 4)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1 + 0))) or ((1686 + 2302) < (14982 - 11035))) then
			if (((8098 - 3454) == (758 + 3886)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "blackout_kick serenity_3t 6";
			end
		end
		if (((1034 + 289) > (295 + 976)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 1))) then
			if (((445 + 1174) > (3386 - (1690 + 239))) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(102 - 72))) then
				return "faeline_stomp serenity_3t 14";
			end
		end
		if ((v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff)) or ((2112 + 748) < (3921 - 2113))) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v101, not v14:IsInMeleeRange(22 - 13)) or ((500 + 239) >= (7232 - 5423))) then
				return "strike_of_the_windlord serenity_3t 16";
			end
		end
		if (((3407 - (1736 + 132)) <= (2209 + 1939)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v102, not v14:IsInMeleeRange(29 - 20)) or ((2014 - 1580) > (161 + 2889))) then
				return "strike_of_the_windlord serenity_3t 18";
			end
		end
		if ((v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) or ((3086 - (27 + 5)) < (218 + 1465))) then
			if (((34 + 13) < (1010 + 1696)) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(3 + 5))) then
				return "fists_of_fury serenity_3t 20";
			end
		end
		if (((1099 + 420) >= (1697 - (771 + 346))) and v13:IsCasting(v58.FistsofFury)) then
			if (v24(v60.StopFoF) or ((4744 - (1577 + 57)) == (7311 - 3134))) then
				return "fists_of_fury_cancel serenity_3t 22";
			end
		end
		if (((5280 - (684 + 396)) > (6115 - 4039)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(1205 - (700 + 496))) or ((483 + 118) >= (2598 - (65 + 187)))) then
				return "strike_of_the_windlord serenity_3t 24";
			end
		end
		if (((4909 - (827 + 112)) <= (3037 + 1317)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v90() and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(20 - 12)) or ((3959 - 2417) < (1000 - 792))) then
				return "spinning_crane_kick serenity_3t 26";
			end
		end
		if (((336 + 1276) <= (400 + 2526)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(1226 - (551 + 645), 345 - (166 + 177))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1861 - (1361 + 495))) or ((5435 - 3429) <= (271 + 269))) then
				return "blackout_kick serenity_3t 28";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((5396 - 2984) == (3929 + 748))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(232 - (148 + 76))) or ((18307 - 13410) <= (5332 - 3360))) then
				return "spinning_crane_kick serenity_3t 30";
			end
		end
		if (((1911 + 1190) <= (5326 - (735 + 1007))) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (281 - (111 + 168)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((134 + 1434) >= (9405 - 4862))) then
				return "blackout_kick serenity_3t 32";
			end
		end
		if (((78 + 4180) >= (1423 + 418)) and v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick)) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4)) or ((13006 - 9954) >= (1892 + 1662))) then
				return "blackout_kick serenity_3t 34";
			end
		end
		if (v58.StrikeoftheWindlord:IsReady() or ((3030 - (147 + 785)) > (4551 - (483 + 183)))) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(26 - 17)) or ((2428 + 542) == (3083 - (1790 + 121)))) then
				return "strike_of_the_windlord serenity_3t 36";
			end
		end
		if (((12758 - 8845) > (5420 - (259 + 1280))) and v58.WhirlingDragonPunch:IsReady()) then
			if (((6516 - (160 + 1424)) >= (1619 + 131)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
				return "whirling_dragon_punch serenity_3t 38";
			end
		end
		if ((v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) or ((905 - (479 + 291)) == (3168 - 1499))) then
			if (((5773 - (569 + 402)) >= (1414 - (635 + 670))) and v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(19 - 11))) then
				return "rushing_jade_wind serenity_3t 40";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((15573 - 11662) > (5550 - (42 + 556)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(1406 - (1246 + 155))) or ((997 - (31 + 701)) > (14011 - 9817))) then
				return "blackout_kick serenity_3t 42";
			end
		end
		if (((3154 - (393 + 106)) <= (4079 - (727 + 444))) and v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (8 - 5))) then
			if (((344 + 619) > (1304 - (269 + 384))) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(1574 - (598 + 971)))) then
				return "tiger_palm serenity_3t 44";
			end
		end
	end
	local function v115()
		if ((v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (1 + 1)) and (not v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (6 - 4)) and v14:DebuffDown(v58.SkyreachExhaustionDebuff)) or ((16455 - 12952) <= (542 - 347))) then
			if (((2827 - (800 + 645)) <= (943 + 3461)) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(820 - (687 + 103)))) then
				return "faeline_stomp serenity_2t 2";
			end
		end
		if ((v58.TigerPalm:IsReady() and (v87(v58.TigerPalm))) or ((6019 - (142 + 1020)) <= (1858 - 1091))) then
			if (v82.CastTargetIf(v58.TigerPalm, v62, "min", v95, nil, not v14:IsInMeleeRange(1 + 4)) or ((4531 - (306 + 207)) > (5425 - (112 + 1292)))) then
				return "tiger_palm serenity_2t 4";
			end
		end
		if ((v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.PressurePointBuff))) or ((1909 + 361) == (2884 - (587 + 365)))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1720 - (829 + 886))) or ((8699 - 5269) <= (270 + 906))) then
				return "rising_sun_kick serenity_2t 8";
			end
		end
		if ((v58.RisingSunKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(119 - 89, 6 - 4)) or ((1164 + 34) >= (1665 + 2052))) then
			if (((6372 - 2642) >= (2310 - (613 + 364))) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "rising_sun_kick serenity_2t 10";
			end
		end
		if ((v58.RisingSunKick:IsReady() and (v13:HasTier(14 + 16, 1 + 1))) or ((4916 - 2764) == (10046 - 7249))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(15 - 10)) or ((1116 + 593) < (2527 - (1467 + 472)))) then
				return "rising_sun_kick serenity_2t 12";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (3 - 0)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1548 - (1077 + 470)))) or ((69 + 3506) <= (997 + 2205))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(22 - 17)) or ((4826 - (12 + 417)) < (9190 - 5475))) then
				return "blackout_kick serenity_2t 6";
			end
		end
		if ((v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (2 + 0))) or ((5422 - 1347) <= (4596 - 2351))) then
			if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(56 - 26)) or ((1137 + 2829) > (1838 + 2950))) then
				return "faeline_stomp serenity_2t 14";
			end
		end
		if (((581 + 3245) > (1699 - 1111)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff)) then
			if (((1799 - (924 + 181)) <= (2304 - (263 + 534))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v101, not v14:IsInMeleeRange(1 + 8))) then
				return "strike_of_the_windlord serenity_2t 16";
			end
		end
		if (((3694 + 206) >= (2313 - 1197)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
			if (((14156 - 9249) > (2033 + 1278)) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, v102, not v14:IsInMeleeRange(716 - (562 + 145)))) then
				return "strike_of_the_windlord serenity_2t 18";
			end
		end
		if ((v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) or ((870 + 2538) <= (1003 + 1614))) then
			if (((1248 + 1953) == (8 + 3193)) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(2 + 6))) then
				return "fists_of_fury serenity_2t 20";
			end
		end
		if (((4770 - 2575) == (2165 + 30)) and v13:IsCasting(v58.FistsofFury)) then
			if (v24(v60.StopFoF) or ((13988 - 10963) > (1272 + 2234))) then
				return "fists_of_fury_cancel serenity_2t 22";
			end
		end
		if ((v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) or ((480 + 256) < (2232 - (1459 + 417)))) then
			if (((1457 - (194 + 92)) <= (4159 - (1057 + 328))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(25 - 16))) then
				return "strike_of_the_windlord serenity_2t 24";
			end
		end
		if (((20000 - 15892) >= (844 - (5 + 527))) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(23 + 7, 782 - (342 + 438))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((320 + 359) > (2308 + 585))) then
				return "blackout_kick serenity_2t 26";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (3 - 1))) or ((147 + 729) < (29 + 171))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(9 - 4)) or ((4220 - 1895) > (3574 - (6 + 6)))) then
				return "blackout_kick serenity_2t 28";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v58.FistsofFury:CooldownRemains() > (14 - 9)) and v58.ShadowboxingTreads:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (2 - 1))) or ((1532 + 2129) > (5957 - (206 + 1047)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1117 - (470 + 642))) or ((1037 + 3096) <= (2995 - (552 + 515)))) then
				return "blackout_kick serenity_2t 30";
			end
		end
		if (((3549 + 869) >= (1123 + 310)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((2222 + 1901) >= (2301 + 1822))) then
				return "spinning_crane_kick serenity_2t 32";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((120 + 85) >= (3396 - (701 + 350)))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(5 + 3)) or ((287 + 250) == (560 + 444))) then
				return "spinning_crane_kick serenity_2t 34";
			end
		end
		if (v58.WhirlingDragonPunch:IsReady() or ((3687 - 1342) < (1699 - 1154))) then
			if (((1046 + 603) > (613 - 370)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "whirling_dragon_punch serenity_2t 36";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((3077 + 833) <= (12726 - 9533))) then
			if (((3351 - (281 + 1065)) == (9355 - 7350)) and v82.CastTargetIf(v58.BlackoutKick, v62, "max", v99, nil, not v14:IsInMeleeRange(18 - 13))) then
				return "blackout_kick serenity_2t 38";
			end
		end
		if (((5899 - (1114 + 97)) > (6948 - 2376)) and v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (1916 - (279 + 1634)))) then
			if (((2847 - (1213 + 67)) < (3451 - (65 + 126))) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "tiger_palm serenity_2t 40";
			end
		end
	end
	local function v116()
		local v158 = 1085 - (189 + 896);
		while true do
			if ((v158 == (0 + 0)) or ((5724 - (1872 + 91)) == (1437 - 816))) then
				if (((4658 + 97) > (12275 - 8821)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (2 + 0)) and v14:DebuffDown(v58.SkyreachExhaustionDebuff)) then
					if (((1977 + 2842) >= (5801 - 4194)) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(106 - (22 + 54)))) then
						return "faeline_stomp serenity_st 2";
					end
				end
				if (((10657 - 6111) >= (4767 - 2871)) and v58.SpinningCraneKick:IsReady() and (v13:BuffRemains(v58.SerenityBuff) < (1.5 + 0)) and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff) and v13:HasTier(121 - 90, 1538 - (553 + 981))) then
					if (((3350 + 196) > (579 + 354)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(6 + 2))) then
						return "spinning_crane_kick serenity_st 4";
					end
				end
				if ((v58.TigerPalm:IsReady() and v14:DebuffDown(v58.SkyreachExhaustionDebuff) and v87(v58.TigerPalm)) or ((11804 - 7819) <= (4700 - 1540))) then
					if (((3884 - (1320 + 577)) == (2836 - (667 + 182))) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(1293 - (1115 + 173)))) then
						return "tiger_palm serenity_st 6";
					end
				end
				if (((1666 - 672) <= (3606 + 934)) and v58.RisingSunKick:IsReady()) then
					if (((6672 - (1375 + 380)) == (1901 + 3016)) and v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(31 - (12 + 14)))) then
						return "rising_sun_kick serenity_st 12";
					end
				end
				v158 = 2 - 1;
			end
			if ((v158 == (4 - 2)) or ((811 - 487) > (14190 - 9294))) then
				if (((1189 - 417) < (7399 - 2729)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (786 - (354 + 377)))) then
					if (((14985 - 11813) >= (6929 - 4351)) and v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(1991 - (263 + 1719)))) then
						return "strike_of_the_windlord serenity_st 18";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v58.RisingSunKick) and v13:HasTier(390 - (335 + 24), 953 - (882 + 69))) or ((2407 - (657 + 1029)) == (2034 - (685 + 515)))) then
					if (((2950 - (745 + 893)) < (446 + 2208)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(780 - (274 + 498)))) then
						return "spinning_crane_kick serenity_st 20";
					end
				end
				if (((546 + 2667) >= (552 + 1061)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(1637 - (1035 + 571), 1 + 1) and v13:BuffUp(v58.BlackoutReinforcementBuff) and v13:PrevGCD(1 + 0, v58.RisingSunKick)) then
					if (v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(18 - 13)) or ((11581 - 7795) > (3951 + 245))) then
						return "blackout_kick serenity_st 22";
					end
				end
				if (((2804 + 1414) == (12955 - 8737)) and v58.FistsofFury:IsReady() and (v13:BuffUp(v58.InvokersDelightBuff))) then
					if (((1741 - (109 + 115)) < (5449 - (1047 + 352))) and v22(v58.FistsofFury, nil, nil, not v14:IsInMeleeRange(1773 - (852 + 913)))) then
						return "fists_of_fury serenity_st 24";
					end
				end
				v158 = 3 + 0;
			end
			if (((5735 - (384 + 961)) == (10293 - 5903)) and (v158 == (8 - 5))) then
				if (((7033 - 5114) > (881 - (591 + 1))) and v13:IsCasting(v58.FistsofFury)) then
					if (v24(v60.StopFoF) or ((233 + 972) < (2221 - (218 + 1252)))) then
						return "fists_of_fury_cancel serenity_st 26";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffDown(v58.BlackoutReinforcementBuff) and v13:HasTier(24 + 7, 358 - (321 + 35))) or ((2955 - (239 + 155)) <= (1446 + 271))) then
					if (((1765 - (41 + 1)) <= (3800 - (80 + 120))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1))) then
						return "spinning_crane_kick serenity_st 28";
					end
				end
				if (((6181 - 2910) >= (409 + 1224)) and v58.StrikeoftheWindlord:IsReady() and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > v13:BuffRemains(v58.CalltoDominanceBuff))) then
					if (((2890 + 213) >= (14228 - 11355)) and v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(19 - 10))) then
						return "strike_of_the_windlord serenity_st 30";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(127 - 97, 2 - 0)) or ((1667 + 1936) == (222 + 503))) then
					if (((53 + 2790) == (4069 - (165 + 1061))) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "blackout_kick serenity_st 32";
					end
				end
				v158 = 4 + 0;
			end
			if ((v158 == (1644 - (596 + 1047))) or ((29 + 145) >= (1921 + 594))) then
				if (((6518 - 2107) >= (1074 + 946)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (740 - (185 + 552))) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (1 + 0))) then
					if (((1948 - (507 + 94)) == (5921 - 4574)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick serenity_st 8";
					end
				end
				if (((7417 - 2956) == (6198 - (569 + 1168))) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:HasTier(60 - 29, 7 - 3)) then
					if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(360 - (118 + 233))) or ((4684 - (279 + 65)) == (4799 - 1927))) then
						return "strike_of_the_windlord serenity_st 10";
					end
				end
				if (((1055 - 487) <= (4505 - 2298)) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.FaeExposureDebuff) < (5 - 3))) then
					if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(1848 - (1414 + 404))) or ((4545 - (347 + 409)) <= (510 + 353))) then
						return "faeline_stomp serenity_st 14";
					end
				end
				if (((238 + 0) < (2700 + 2297)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:BuffUp(v58.CalltoDominanceBuff) and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > v13:BuffRemains(v58.CalltoDominanceBuff))) then
					if (((1272 + 3013) > (5381 - (420 + 1158))) and v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(21 - 12))) then
						return "strike_of_the_windlord serenity_st 16";
					end
				end
				v158 = 613 - (406 + 205);
			end
			if (((9092 - 6420) < (2683 + 2227)) and (v158 == (4 + 0))) then
				if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((7383 - 4427) > (4414 - (28 + 33)))) then
					if (((376 + 3158) > (3104 - (858 + 149))) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "blackout_kick serenity_st 34";
					end
				end
				if (((4651 - 1396) >= (2041 - (829 + 678))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff)) then
					if (((3114 + 1140) < (5676 - (143 + 1073))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1823 - (898 + 917)))) then
						return "spinning_crane_kick serenity_st 36";
					end
				end
				if (v58.WhirlingDragonPunch:IsReady() or ((9120 - 4459) <= (2095 + 2310))) then
					if (((6044 - (882 + 587)) >= (1480 + 463)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "whirling_dragon_punch serenity_st 38";
					end
				end
				if ((v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (267 - (140 + 124)))) or ((308 + 18) > (2672 - (1105 + 430)))) then
					if (((3458 - 2174) == (4398 - 3114)) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(11 - 6))) then
						return "tiger_palm serenity_st 40";
					end
				end
				break;
			end
		end
	end
	local function v117()
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v90() and v13:BuffDown(v58.BlackoutReinforcementBuff)) or ((5449 - 2377) >= (2649 + 777))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((2477 + 1559) > (449 + 3926))) then
				return "spinning_crane_kick default_aoe 2";
			end
		end
		if (((5919 - (1047 + 944)) == (5230 - (206 + 1096))) and v58.SpinningCraneKick:IsReady() and not v58.HitCombo:IsAvailable() and v90() and v13:BuffUp(v58.BonedustBrewBuff)) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(202 - (30 + 164))) or ((11869 - 9240) >= (880 + 2125))) then
				return "spinning_crane_kick default_aoe 4";
			end
		end
		if ((v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) or ((4094 - (1383 + 91)) <= (1635 - 1213))) then
			if (((3762 - 1866) > (3517 - (1174 + 486))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(436 - (172 + 255)))) then
				return "strike_of_the_windlord default_aoe 6";
			end
		end
		if (((4581 - 3115) >= (1175 - 683)) and v58.WhirlingDragonPunch:IsReady() and (v64 > (1536 - (594 + 934)))) then
			if (((1436 - (211 + 357)) < (614 + 3239)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(4 + 1))) then
				return "whirling_dragon_punch default_aoe 8";
			end
		end
		if (v58.FistsofFury:IsReady() or ((3043 - 1228) > (3220 + 1497))) then
			if (((5085 - (159 + 1255)) == (3171 + 500)) and v82.CastTargetIf(v58.FistsofFury, v62, "max", v99, nil, not v14:IsInMeleeRange(785 - (24 + 753)))) then
				return "fists_of_fury default_aoe 10";
			end
		end
		if (((105 + 111) <= (364 - 80)) and v58.SpinningCraneKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v87(v58.SpinningCraneKick) and v90() and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (((4389 - (898 + 234)) > (2742 - (333 + 202))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(4 + 4))) then
				return "spinning_crane_kick default_aoe 12";
			end
		end
		if ((v58.RisingSunKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(11 + 19, 3 - 1)) or ((3366 - (1018 + 261)) < (348 - 211))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(136 - (93 + 38))) or ((520 + 3403) >= (3048 + 1715))) then
				return "rising_sun_kick default_aoe 14";
			end
		end
		if (((412 + 1332) == (1730 + 14)) and v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (6 - 3)) and v58.ShadowboxingTreads:IsAvailable()) then
			if (((924 - 676) <= (3341 - 2191)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(23 - 18))) then
				return "blackout_kick default_aoe 16";
			end
		end
		if (((8632 - 4638) >= (62 + 232)) and v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) then
			if (((2386 - 745) > (419 + 274)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(425 - (14 + 406)))) then
				return "blackout_kick default_aoe 18";
			end
		end
		if ((v58.WhirlingDragonPunch:IsReady() and (v64 >= (9 - 4))) or ((16421 - 11902) < (3865 - (20 + 1610)))) then
			if (((359 + 533) < (3379 - 2166)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(14 - 9))) then
				return "whirling_dragon_punch default_aoe 20";
			end
		end
		if (((3830 - (243 + 274)) <= (6277 - (1437 + 185))) and v58.RisingSunKick:IsReady() and (v13:HasTier(93 - 63, 1 + 1) or (v58.WhirlingDragonPunch:IsAvailable() and (v58.WhirlingDragonPunch:CooldownRemains() < (11 - 8)) and (v58.FistsofFury:CooldownRemains() > (3 + 0)) and v13:BuffDown(v58.KicksofFlowingMomentumBuff)))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4)) or ((4772 - (326 + 490)) < (1891 + 814))) then
				return "rising_sun_kick default_aoe 22";
			end
		end
		if (((2162 - (181 + 22)) < (3112 - (35 + 40))) and v58.ExpelHarm:IsReady() and (((v13:Chi() == (3 - 2)) and (v58.RisingSunKick:CooldownUp() or v58.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (2 - 0)) and v58.FistsofFury:CooldownUp()))) then
			if (v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(1 + 7)) or ((2119 - (297 + 581)) > (122 + 2091))) then
				return "expel_harm default_aoe 24";
			end
		end
		if (((7246 - 2341) < (16135 - 11161)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (v58.FistsofFury:CooldownRemains() < (2 + 3)) and (v13:BuffStack(v58.ChiEnergyBuff) > (40 - 30))) then
			if (((15769 - 12212) == (5294 - (1505 + 232))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1326 - (415 + 903)))) then
				return "spinning_crane_kick default_aoe 26";
			end
		end
		if (((997 - 628) == (597 - 228)) and v58.ChiBurst:IsCastable() and (v13:Chi() < (722 - (155 + 562))) and (v13:BloodlustUp() or (v13:Energy() < (24 + 26)))) then
			if (v24(v58.ChiBurst, not v14:IsInRange(157 - (71 + 46)), true) or ((5573 - 1984) < (3672 - (436 + 249)))) then
				return "chi_burst default_aoe 28";
			end
		end
		if (((5999 - (56 + 1565)) > (1171 + 1682)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and ((v58.FistsofFury:CooldownRemains() > (987 - (80 + 904))) or (v13:Chi() > (1 + 1))) and v90() and v13:BuffDown(v58.BlackoutReinforcementBuff) and (v13:BloodlustUp() or v13:BuffUp(v58.InvokersDelightBuff))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(808 - (595 + 205))) or ((4119 - 2407) > (9725 - 6123))) then
				return "spinning_crane_kick default_aoe 30";
			end
		end
		if (((3181 + 1358) >= (1107 + 1626)) and v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick) and v13:HasTier(97 - 67, 1 + 1) and v13:BuffDown(v58.BonedustBrewBuff) and (((v64 < (680 - (400 + 265))) and not v58.CraneVortex:IsAvailable()) or (v64 < (15 - 7)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(2 + 3)) or ((5764 - 3165) <= (198 + 317))) then
				return "blackout_kick default_aoe 32";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and ((v58.FistsofFury:CooldownRemains() > (1674 - (962 + 709))) or (v13:Chi() > (4 + 0))) and v90()) or ((2681 + 1073) < (588 + 222))) then
			if (((6389 - 4756) <= (5145 - 3168)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(789 - (636 + 145)))) then
				return "spinning_crane_kick default_aoe 34";
			end
		end
		if (((4823 - (282 + 13)) >= (4767 - (366 + 782))) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
			if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(97 - (10 + 79))) or ((1879 - (1297 + 410)) >= (7339 - 5247))) then
				return "rushing_jade_wind default_aoe 36";
			end
		end
		if (((1855 + 265) == (2398 - (262 + 16))) and v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (6 - 3))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(4 + 1)) or ((282 + 2116) == (2208 - (1056 + 794)))) then
				return "blackout_kick default_aoe 38";
			end
		end
		if (((3735 - (741 + 607)) < (6393 - (730 + 1026))) and v58.StrikeoftheWindlord:IsReady()) then
			if (((3058 - (248 + 1545)) < (3767 - (191 + 801))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(44 - 35))) then
				return "strike_of_the_windlord default_aoe 40";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick) and not v90()) or ((4990 - (478 + 82)) < (1758 - (434 + 1273)))) then
			if (((5358 - 3487) <= (1576 + 422)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(20 - 15))) then
				return "blackout_kick default_aoe 42";
			end
		end
		if ((v58.ChiBurst:IsReady() and (((v13:ChiDeficit() >= (574 - (349 + 224))) and (v64 == (865 - (275 + 589)))) or (v13:ChiDeficit() >= (3 - 1)))) or ((3572 - 1489) >= (5486 - (1064 + 468)))) then
			if (((1360 + 497) > (33 + 26)) and v24(v58.ChiBurst, not v14:IsInRange(171 - 131), true)) then
				return "chi_burst default_aoe 44";
			end
		end
	end
	local function v118()
		if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:Chi() < (705 - (676 + 27))) and ((v58.FistsofFury:CooldownRemains() < (2 - 1)) or (v58.StrikeoftheWindlord:CooldownRemains() < (1428 - (48 + 1379)))) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (3 + 0))) or ((543 + 689) == (5296 - 2251))) then
			if (((78 + 26) == (219 - (79 + 36))) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(16 - 11))) then
				return "tiger_palm default_4t 2";
			end
		end
		if (((2036 + 2498) > (1601 + 1366)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v90() and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((2780 + 669) <= (5519 - 3151))) then
				return "spinning_crane_kick default_4t 4";
			end
		end
		if (((2040 + 2693) >= (1602 + 1946)) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(1023 - (631 + 383))) or ((3640 - (445 + 1190)) > (6112 - (810 + 615)))) then
				return "strike_of_the_windlord default_4t 6";
			end
		end
		if (v58.FistsofFury:IsReady() or ((3061 - (819 + 475)) <= (2251 - (243 + 1092)))) then
			if (((10702 - 7113) < (2292 + 1390)) and v82.CastTargetIf(v58.FistsofFury, v62, "max", v99, nil, not v14:IsInMeleeRange(8 + 0))) then
				return "fists_of_fury default_4t 8";
			end
		end
		if ((v58.RisingSunKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(2 + 28, 2 + 0)) or ((126 - 51) >= (1230 - 800))) then
			if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(529 - (119 + 405))) or ((9808 - 5651) <= (11357 - 8138))) then
				return "rising_sun_kick default_4t 10";
			end
		end
		if (((2432 - (352 + 257)) < (61 + 2721)) and v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and v87(v58.BlackoutKick) and v13:BuffUp(v58.BlackoutReinforcementBuff)) then
			if (((4597 - (88 + 1075)) >= (2835 - (477 + 594))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(728 - (328 + 395)))) then
				return "blackout_kick default_4t 12";
			end
		end
		if (((4544 - (164 + 340)) > (2757 - 937)) and v58.SpinningCraneKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v87(v58.SpinningCraneKick) and v90()) then
			if (((10105 - 5913) >= (3758 - (1008 + 221))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1519 - (1025 + 486)))) then
				return "spinning_crane_kick default_4t 14";
			end
		end
		if (((3405 - 1851) < (6505 - 4180)) and v58.RisingSunKick:IsReady() and v13:BuffDown(v58.BonedustBrewBuff) and v13:BuffUp(v58.PressurePointBuff) and (v58.FistsofFury:CooldownRemains() > (224 - (108 + 111)))) then
			if (((1206 - (82 + 16)) < (6254 - (533 + 1196))) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(7 - 2))) then
				return "rising_sun_kick default_4t 16";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (215 - (161 + 51))) and v58.ShadowboxingTreads:IsAvailable()) or ((4801 - (294 + 140)) <= (13696 - 10364))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(843 - (717 + 121))) or ((4541 - 1645) > (4527 + 114))) then
				return "blackout_kick default_4t 18";
			end
		end
		if (((140 + 742) > (1731 - (1001 + 709))) and v58.RisingSunKick:IsReady() and (v13:HasTier(29 + 1, 1122 - (242 + 878)))) then
			if (((4156 - (1395 + 388)) <= (2391 + 2398)) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(4 + 1))) then
				return "rising_sun_kick default_4t 20";
			end
		end
		if ((v58.ExpelHarm:IsReady() and (((v13:Chi() == (1 + 0)) and (v58.RisingSunKick:CooldownUp() or v58.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (1 + 1)) and v58.FistsofFury:CooldownUp()))) or ((3786 - (1289 + 658)) < (626 + 510))) then
			if (((5745 - 2315) == (2710 + 720)) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(7 + 1))) then
				return "expel_harm default_4t 22";
			end
		end
		if (((1414 - 666) <= (4264 - (337 + 1639))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (v58.FistsofFury:CooldownRemains() > (3 + 0)) and (v13:BuffStack(v58.ChiEnergyBuff) > (18 - 8))) then
			if (((2409 - 1518) < (9666 - 5193)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1745 - (630 + 1107)))) then
				return "spinning_crane_kick default_4t 24";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v13:HasTier(26 + 4, 1 + 1)) or ((4492 - 1421) <= (1183 + 1464))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(5 + 0)) or ((694 - (13 + 48)) > (2339 - (658 + 41)))) then
				return "blackout_kick default_4t 26";
			end
		end
		if (((7947 - 4183) > (4311 - (1591 + 316))) and v58.ChiBurst:IsCastable() and (v13:Chi() < (9 - 4)) and (v13:BloodlustUp() or (v13:Energy() < (13 + 37)))) then
			if (v24(v58.ChiBurst, not v14:IsInRange(22 + 18), true) or ((12685 - 8874) >= (5434 - (1241 + 35)))) then
				return "chi_burst default_4t 28";
			end
		end
		if (((783 - (18 + 22)) > (64 - 17)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and ((v58.FistsofFury:CooldownRemains() > (1 + 2)) or (v13:Chi() > (1306 - (697 + 605)))) and v90()) then
			if (((1509 + 2090) >= (2286 - 1227)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(337 - (188 + 141)))) then
				return "spinning_crane_kick default_4t 30";
			end
		end
		if (((5814 - 4443) <= (5929 - 3422)) and v58.WhirlingDragonPunch:IsReady()) then
			if (v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(955 - (34 + 916))) or ((5344 - (357 + 1380)) == (2327 + 209))) then
				return "whirling_dragon_punch default_4t 32";
			end
		end
		if (((528 + 598) < (944 + 2731)) and v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (1930 - (178 + 1749)))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(13 - 8)) or ((4759 - (142 + 1273)) >= (4208 - (284 + 309)))) then
				return "blackout_kick default_4t 34";
			end
		end
		if ((v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) or ((3907 + 869) <= (900 - (622 + 68)))) then
			if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(5 + 3)) or ((5932 - 3319) > (2122 + 630))) then
				return "rushing_jade_wind default_4t 36";
			end
		end
		if (((2831 + 1711) > (4017 - (855 + 1043))) and v58.StrikeoftheWindlord:IsReady()) then
			if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(19 - 10)) or ((3541 - 2502) == (1152 - 814))) then
				return "strike_of_the_windlord default_4t 38";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and ((v58.FistsofFury:CooldownRemains() > (782 - (576 + 203))) or (v13:Chi() > (9 - 5)))) or ((6754 - 2623) > (6594 - (709 + 1275)))) then
			if (((3493 + 636) >= (2291 - 1619)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(30 - 22))) then
				return "spinning_crane_kick default_4t 40";
			end
		end
		if (((1137 - (31 + 87)) < (3597 - (44 + 87))) and v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) then
			if (((1065 - 775) <= (698 + 157)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(10 - 5))) then
				return "blackout_kick default_4t 42";
			end
		end
	end
	local function v119()
		local v159 = 0 - 0;
		while true do
			if (((5387 - (284 + 502)) > (2882 + 1564)) and (v159 == (1191 - (124 + 1062)))) then
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v58.FistsofFury:CooldownDown()) or ((2022 - (847 + 180)) >= (1586 + 513))) then
					if (((4012 - 3051) < (5369 - (369 + 994))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(968 - (583 + 380)))) then
						return "blackout_kick default_3t 42";
					end
				end
				if (((590 + 2104) < (3518 + 1336)) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
					if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(4 + 4)) or ((6147 - (1085 + 888)) <= (9216 - 5483))) then
						return "rushing_jade_wind default_3t 44";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v58.ShadowboxingTreads:IsAvailable() and not v90()) or ((10054 - 7428) <= (3029 - 2381))) then
					if (((2379 - 784) <= (618 + 1460)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick default_3t 46";
					end
				end
				if (((669 + 966) > (934 - 281)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (((v13:Chi() > (7 - 2)) and v58.StormEarthAndFire:IsAvailable()) or ((v13:Chi() > (4 + 0)) and v58.Serenity:IsAvailable()))) then
					if (((2712 + 1026) == (3638 + 100)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(222 - (153 + 61)))) then
						return "spinning_crane_kick default_3t 48";
					end
				end
				break;
			end
			if ((v159 == (945 - (704 + 239))) or ((1836 + 2127) > (6128 - (740 + 646)))) then
				if ((v58.RisingSunKick:IsReady() and v13:BuffDown(v58.BonedustBrewBuff) and v13:BuffUp(v58.PressurePointBuff)) or ((2459 + 1613) > (6617 - (1547 + 375)))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((2623 - (211 + 192)) > (13028 - 10139))) then
						return "rising_sun_kick default_3t 18";
					end
				end
				if ((v58.RisingSunKick:IsReady() and (v13:HasTier(46 - 16, 783 - (425 + 356)))) or ((431 + 4483) < (11465 - 7066))) then
					if (((5226 - (83 + 1483)) == (4932 - (123 + 1149))) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "rising_sun_kick default_3t 20";
					end
				end
				if (((1068 + 1847) >= (1776 - (908 + 672))) and v58.ExpelHarm:IsReady() and (((v13:Chi() == (514 - (206 + 307))) and (v58.RisingSunKick:CooldownUp() or v58.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (2 + 0)) and v58.FistsofFury:CooldownUp()))) then
					if (v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(70 - (18 + 44))) or ((1563 + 3075) < (8548 - 4646))) then
						return "expel_harm default_3t 22";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (4 - 2))) or ((204 + 896) >= (2227 - (226 + 709)))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(731 - (235 + 491))) or ((891 - 344) > (1096 + 2415))) then
						return "blackout_kick default_3t 24";
					end
				end
				v159 = 1302 - (463 + 836);
			end
			if ((v159 == (408 - (166 + 238))) or ((546 - 232) > (1879 + 253))) then
				if (((2373 - (1080 + 361)) == (1473 - 541)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (v58.FistsofFury:CooldownRemains() < (2 + 1)) and (v13:BuffStack(v58.ChiEnergyBuff) > (19 - 4))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(308 - (254 + 46))) or ((542 + 2397) == (2354 + 2012))) then
						return "spinning_crane_kick default_3t 36";
					end
				end
				if ((v58.RisingSunKick:IsReady() and (v58.FistsofFury:CooldownRemains() > (260 - (37 + 219))) and (v13:Chi() > (1902 - (1330 + 569)))) or ((6029 - 2060) <= (6058 - 2401))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(19 - 14)) or ((2038 - 659) == (2132 - (128 + 542)))) then
						return "rising_sun_kick default_3t 38";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (5 - 2))) or ((16353 - 11747) <= (13440 - 9513))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1 + 4)) or ((5560 - 3982) <= (888 + 124))) then
						return "blackout_kick default_3t 34";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v58.RisingSunKick:CooldownDown() and v58.FistsofFury:CooldownDown() and (v13:Chi() > (3 + 1)) and ((v58.StormEarthAndFire:IsAvailable() and not v58.BonedustBrew:IsAvailable()) or v58.Serenity:IsAvailable())) or ((4900 - 2501) > (3077 + 309))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(820 - (96 + 716))) or ((5083 - (85 + 1522)) > (5554 - (724 + 129)))) then
						return "spinning_crane_kick default_3t 40";
					end
				end
				v159 = 15 - 10;
			end
			if (((376 - (83 + 290)) == v159) or ((6481 - 2107) <= (6829 - 3100))) then
				if (v58.StrikeoftheWindlord:IsReady() or ((3910 + 1028) <= (913 + 412))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(2 + 3)) or ((4256 - 1326) > (2041 + 2101))) then
						return "strike_of_the_windlord default_3t 26";
					end
				end
				if (((1246 - 663) >= (259 - 126)) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.TeachingsoftheMonasteryBuff) and (v58.ShadowboxingTreads:IsAvailable() or (v58.RisingSunKick:CooldownRemains() > (448 - (190 + 257))))) then
					if (((1023 - (402 + 189)) == (238 + 194)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(571 - (90 + 476)))) then
						return "blackout_kick default_3t 28";
					end
				end
				if (((2270 - (688 + 126)) <= (1714 + 2510)) and v58.WhirlingDragonPunch:IsReady()) then
					if (v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(1 + 4)) or ((2197 - (34 + 465)) >= (10316 - 7932))) then
						return "whirling_dragon_punch default_3t 30";
					end
				end
				if (((5724 - 3013) < (1984 + 1828)) and v58.ChiBurst:IsCastable() and (v13:Chi() < (3 + 2)) and (v13:BloodlustUp() or (v13:Energy() < (131 - 81)))) then
					if (v24(v58.ChiBurst, not v14:IsInRange(40 + 0), true) or ((1469 - 723) >= (4146 - (587 + 1220)))) then
						return "chi_burst default_3t 32";
					end
				end
				v159 = 1896 - (1211 + 681);
			end
			if (((3079 - (64 + 13)) >= (1549 - (121 + 534))) and (v159 == (804 - (622 + 181)))) then
				if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (2 + 1)) and v58.ShadowboxingTreads:IsAvailable()) or ((3045 - (296 + 1373)) <= (207 + 825))) then
					if (((758 + 1669) == (479 + 1948)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1619 - (143 + 1471)))) then
						return "blackout_kick default_3t 10";
					end
				end
				if (((11576 - 8085) > (1139 + 2254)) and v58.FistsofFury:IsReady()) then
					if (v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(20 - 12)) or ((4065 - (103 + 77)) > (3212 + 1100))) then
						return "fists_of_fury default_3t 12";
					end
				end
				if ((v58.RisingSunKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(1187 - (895 + 262), 3 - 1)) or ((1665 + 463) < (3380 - (581 + 1045)))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(1280 - (582 + 693))) or ((5770 - (454 + 732)) <= (6113 - 2841))) then
						return "rising_sun_kick default_3t 14";
					end
				end
				if (((276 + 767) <= (5232 - 1674)) and v58.SpinningCraneKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v87(v58.SpinningCraneKick)) then
					if (((98 - 27) == (721 - (367 + 283))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(76 - (7 + 61)))) then
						return "spinning_crane_kick default_3t 16";
					end
				end
				v159 = 5 - 3;
			end
			if (((6147 - 3354) == (396 + 2397)) and (v159 == (678 - (332 + 346)))) then
				if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:Chi() < (3 - 1)) and ((v58.RisingSunKick:CooldownRemains() < (1 - 0)) or (v58.FistsofFury:CooldownRemains() < (3 - 2)) or (v58.StrikeoftheWindlord:CooldownRemains() < (1 + 0))) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (3 - 0))) or ((498 + 63) > (375 + 536))) then
					if (v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(8 - 3)) or ((1587 - 910) >= (5997 - (815 + 1039)))) then
						return "tiger_palm default_3t 2";
					end
				end
				if (((5198 - (336 + 440)) > (2178 + 114)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1 + 7)) or ((8479 - 5093) <= (2986 - (222 + 208)))) then
						return "spinning_crane_kick default_3t 4";
					end
				end
				if ((v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:HasTier(2 + 29, 834 - (652 + 178))) or ((7816 - 2884) < (2447 - 1545))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(9 + 0)) or ((1268 - 765) >= (1819 - (259 + 135)))) then
						return "strike_of_the_windlord default_3t 6";
					end
				end
				if (((6331 - (1393 + 67)) == (2601 + 2270)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (1468 - (1129 + 319))) or (v66 < (3 + 2)))) then
					if (((3442 - 927) > (2692 - (137 + 275))) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(448 - (140 + 299)))) then
						return "strike_of_the_windlord default_3t 8";
					end
				end
				v159 = 1102 - (421 + 680);
			end
		end
	end
	local function v120()
		local v160 = 0 - 0;
		while true do
			if (((9117 - 6109) == (7215 - 4207)) and (v160 == (2 + 1))) then
				if (((835 - (58 + 482)) < (1454 - (310 + 369))) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and (v13:Chi() > (2 + 0)) and v13:PrevGCD(287 - (274 + 12), v58.RisingSunKick)) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(5 + 0)) or ((3684 + 1144) <= (4781 - (681 + 1081)))) then
						return "blackout_kick default_2t 26";
					end
				end
				if (((7838 - 5521) >= (4173 - 2023)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(20 - 12)) or ((4025 - (842 + 35)) == (1168 - 429))) then
						return "spinning_crane_kick default_2t 28";
					end
				end
				if (((6443 - (180 + 1687)) < (11434 - 6768)) and v58.ChiBurst:IsCastable() and (v13:Chi() < (976 - (269 + 702))) and (v13:Energy() < (864 - (776 + 38)))) then
					if (v24(v58.ChiBurst, not v14:IsInRange(19 + 21), true) or ((8259 - 4416) == (144 + 2886))) then
						return "chi_burst default_2t 30";
					end
				end
				if (((5 + 2517) > (372 + 1212)) and v58.StrikeoftheWindlord:IsReady()) then
					if (((388 + 2857) == (7912 - 4667)) and v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(7 + 2))) then
						return "strike_of_the_windlord default_2t 32";
					end
				end
				v160 = 15 - 11;
			end
			if (((1 + 0) == v160) or ((5413 - (135 + 820)) <= (3090 - (118 + 18)))) then
				if ((v58.FistsofFury:IsReady() and not v13:HasTier(2 + 28, 9 - 7)) or ((941 + 1139) <= (392 + 75))) then
					if (((4 + 54) < (617 + 1)) and v82.CastTargetIf(v58.FistsofFury, v63, "max", v99, nil, not v14:IsInMeleeRange(1301 - (741 + 552)))) then
						return "fists_of_fury default_2t 10";
					end
				end
				if ((v58.RisingSunKick:IsReady() and (v58.FistsofFury:CooldownUp())) or ((48 + 843) > (4851 - 1196))) then
					if (v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5 + 0)) or ((5171 - (779 + 105)) < (5403 - (1451 + 330)))) then
						return "rising_sun_kick default_2t 12";
					end
				end
				if (((1903 - (1259 + 610)) <= (3419 - (4 + 846))) and v58.FistsofFury:IsReady()) then
					if (v82.CastTargetIf(v58.FistsofFury, v62, "max", v99, nil, not v14:IsInMeleeRange(1865 - (1108 + 749))) or ((4617 - (1301 + 440)) == (2019 - 696))) then
						return "fists_of_fury default_2t 14";
					end
				end
				if (((1439 + 591) == (198 + 1832)) and v58.RisingSunKick:IsReady() and (v13:HasTier(21 + 9, 478 - (168 + 308)))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(10 - 5)) or ((1050 + 990) == (2029 - (469 + 878)))) then
						return "rising_sun_kick default_2t 16";
					end
				end
				v160 = 2 + 0;
			end
			if ((v160 == (14 - 10)) or ((119 + 150) > (480 + 1902))) then
				if (((2003 - 1167) < (4062 + 70)) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.TeachingsoftheMonasteryBuff) and (v58.ShadowboxingTreads:IsAvailable() or (v58.RisingSunKick:CooldownRemains() > (3 - 2)))) then
					if (((4829 - (1332 + 508)) >= (28 + 1035)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick default_2t 34";
					end
				end
				if (((1244 + 1162) <= (4363 - (650 + 492))) and v58.WhirlingDragonPunch:IsReady()) then
					if (((4373 - (689 + 117)) < (3339 + 1120)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(12 - 7))) then
						return "whirling_dragon_punch default_2t 36";
					end
				end
				if ((v58.RisingSunKick:IsReady() and not v58.ShadowboxingTreads:IsAvailable() and (v58.FistsofFury:CooldownRemains() > (1927 - (794 + 1129))) and v58.XuensBattlegear:IsAvailable()) or ((1860 + 0) >= (387 + 1678))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(866 - (553 + 308))) or ((3977 - 1854) >= (3539 + 1355))) then
						return "rising_sun_kick default_2t 40";
					end
				end
				if (((1065 + 2554) == (5387 - (1764 + 4))) and v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (520 - (121 + 396)))) then
					if (((2686 - (498 + 56)) < (3141 + 194)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(18 - 13))) then
						return "blackout_kick default_2t 38";
					end
				end
				v160 = 5 + 0;
			end
			if ((v160 == (0 - 0)) or ((6734 - 2257) <= (1176 + 2425))) then
				if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:Chi() < (4 - 2)) and ((v58.RisingSunKick:CooldownRemains() < (1617 - (316 + 1300))) or (v58.FistsofFury:CooldownRemains() < (173 - (78 + 94))) or (v58.StrikeoftheWindlord:CooldownRemains() < (1417 - (261 + 1155)))) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (1459 - (1040 + 416)))) or ((3521 - (29 + 14)) == (1119 - 530))) then
					if (((2694 - (928 + 34)) >= (35 + 95)) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "tiger_palm default_2t 2";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (3 + 0)) and v58.ShadowboxingTreads:IsAvailable()) or ((3185 - 2318) > (9431 - 6216))) then
					if (((1111 - 446) <= (5051 - (69 + 441))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(12 - 7))) then
						return "blackout_kick default_2t 4";
					end
				end
				if (((661 + 428) <= (7951 - 4496)) and v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and v13:HasTier(1911 - (517 + 1363), 932 - (802 + 126))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(1677 - (1660 + 8))) or ((12654 - 9132) < (2327 - (38 + 143)))) then
						return "strike_of_the_windlord default_2t 6";
					end
				end
				if ((v58.StrikeoftheWindlord:IsReady() and v58.Thunderfist:IsAvailable() and ((v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (57 - 37)) or (v66 < (122 - (29 + 88))))) or ((6997 - 3506) <= (3747 - (308 + 181)))) then
					if (v82.CastTargetIf(v58.StrikeoftheWindlord, v62, "max", v99, nil, not v14:IsInMeleeRange(1406 - (537 + 860))) or ((1902 + 2547) < (4739 - (691 + 404)))) then
						return "strike_of_the_windlord default_2t 8";
					end
				end
				v160 = 1955 - (870 + 1084);
			end
			if ((v160 == (131 - (47 + 82))) or ((47 + 106) >= (1604 + 283))) then
				if (((1461 + 304) > (2056 - 1416)) and v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.KicksofFlowingMomentumBuff) or v13:BuffUp(v58.PressurePointBuff))) then
					if (((317 - (84 + 33)) < (1890 + 2169)) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v96, nil, not v14:IsInMeleeRange(17 - 12))) then
						return "rising_sun_kick default_2t 18";
					end
				end
				if ((v58.ExpelHarm:IsReady() and (((v13:Chi() == (1 + 0)) and (v58.RisingSunKick:CooldownUp() or v58.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (4 - 2)) and v58.FistsofFury:CooldownUp()))) or ((9316 - 6106) <= (6968 - 5568))) then
					if (((1979 - 599) < (5083 - (87 + 1133))) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(22 - 14))) then
						return "expel_harm default_2t 20";
					end
				end
				if (((89 + 94) <= (2981 + 360)) and v58.ChiBurst:IsCastable() and v13:BloodlustUp() and (v13:Chi() < (672 - (205 + 462)))) then
					if (v24(v58.ChiBurst, not v14:IsInRange(14 + 26), true) or ((656 - 230) > (4657 - (1035 + 346)))) then
						return "chi_burst default_2t 22";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (1 + 1))) or ((5372 - (970 + 810)) == (3846 + 246))) then
					if (((9516 - 6136) == (2338 + 1042)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "blackout_kick default_2t 24";
					end
				end
				v160 = 7 - 4;
			end
			if (((19085 - 14244) >= (5985 - (601 + 787))) and (v160 == (616 - (256 + 354)))) then
				if (((7772 - 3810) == (14857 - 10895)) and v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(12 - 7)) or ((6254 - 3197) <= (3509 - 1408))) then
						return "blackout_kick default_2t 50";
					end
				end
				if ((v58.FaelineStomp:IsCastable() and (v87(v58.FaelineStomp))) or ((9509 - 5532) >= (14324 - 9636))) then
					if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(54 - 24)) or ((1899 - 1125) < (1027 - (259 + 313)))) then
						return "faeline_stomp default_2t 52";
					end
				end
				break;
			end
			if (((8 - 3) == v160) or ((162 + 670) == (705 + 1642))) then
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and v58.RisingSunKick:CooldownDown() and v58.FistsofFury:CooldownDown() and (v13:BuffDown(v58.BonedustBrewBuff) or (v89() < (1.5 + 0)))) or ((5619 - 3685) == (4115 - (413 + 925)))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(3 + 2)) or ((314 + 290) == (1468 + 3201))) then
						return "blackout_kick default_2t 42";
					end
				end
				if ((v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) or ((7589 - 5501) > (4056 - 1661))) then
					if (((1222 + 770) <= (7585 - 4967)) and v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(1952 - (1164 + 780)))) then
						return "rushing_jade_wind default_2t 44";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v87(v58.SpinningCraneKick) and (v89() >= (1362.7 - (596 + 764)))) or ((3600 - (52 + 230)) == (1397 - 979))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1574 - (806 + 760))) or ((11643 - 7576) <= (4218 - 1681))) then
						return "spinning_crane_kick default_2t 46";
					end
				end
				if (v58.RisingSunKick:IsReady() or ((6788 - 2619) <= (1477 + 2583))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v93, nil, not v14:IsInMeleeRange(2 + 3)) or ((323 - 237) >= (1060 - 454))) then
						return "rising_sun_kick default_2t 48";
					end
				end
				v160 = 2 + 4;
			end
		end
	end
	local function v121()
		if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:Chi() < (2 + 0)) and ((v58.RisingSunKick:CooldownRemains() < (1966 - (1000 + 965))) or (v58.FistsofFury:CooldownRemains() < (1 + 0)) or (v58.StrikeoftheWindlord:CooldownRemains() < (4 - 3))) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (8 - 5))) or ((80 + 73) >= (3579 - (261 + 865)))) then
			if (v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(14 - 9)) or ((4214 - 1538) >= (2796 + 1431))) then
				return "tiger_palm default_st 2";
			end
		end
		if ((v58.ExpelHarm:IsReady() and (((v13:Chi() == (546 - (33 + 512))) and (v58.RisingSunKick:CooldownUp() or v58.StrikeoftheWindlord:CooldownUp())) or ((v13:Chi() == (1838 - (1555 + 281))) and v58.FistsofFury:CooldownUp() and v58.RisingSunKick:CooldownDown()))) or ((648 - 365) >= (1480 + 1343))) then
			if (((6948 - 2706) > (272 + 94)) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(57 - 37))) then
				return "expel_harm default_st 4";
			end
		end
		if (((4057 + 655) == (4751 - (34 + 5))) and v58.StrikeoftheWindlord:IsReady() and ((v13:BuffUp(v58.DomineeringArroganceBuff) and v58.Thunderfist:IsAvailable() and v58.Serenity:IsAvailable() and (v58.InvokeXuenTheWhiteTiger:CooldownRemains() > (17 + 3))) or (v66 < (2 + 3)) or (v58.Thunderfist:IsAvailable() and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (7 + 3)) and v13:BuffDown(v58.DomineeringArroganceBuff)) or (v58.Thunderfist:IsAvailable() and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (13 + 22)) and not v58.Serenity:IsAvailable()))) then
			if (((1078 + 2257) >= (9723 - 6731)) and v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(20 - 11))) then
				return "strike_of_the_windlord default_st 6";
			end
		end
		if (((2703 - (999 + 222)) >= (477 + 983)) and v58.RisingSunKick:IsReady() and (v58.FistsofFury:CooldownUp())) then
			if (v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(2 + 3)) or ((515 - (166 + 178)) >= (1431 + 3260))) then
				return "rising_sun_kick default_st 8";
			end
		end
		if ((v58.FistsofFury:IsReady() and v13:BuffDown(v58.PressurePointBuff) and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (163 - 108))) or ((3473 - (587 + 713)) > (3397 + 1443))) then
			if (v22(v58.FistsofFury, nil, nil, not v14:IsInMeleeRange(1130 - (11 + 1111))) or ((2022 + 1862) < (826 + 520))) then
				return "fists_of_fury default_st 10";
			end
		end
		if (((7469 - 4109) == (4460 - (882 + 218))) and v58.FaelineStomp:IsCastable() and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (1 + 0)) and (v14:DebuffRemains(v58.FaeExposureDebuff) < (965 - (115 + 847)))) then
			if (((3032 - 1950) <= (4431 - (1231 + 384))) and v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(65 - 35))) then
				return "faeline_stomp default_st 12";
			end
		end
		if ((v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.PressurePointBuff) or (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (1751 - (1202 + 494))))) or ((4008 - (12 + 166)) >= (10777 - 6449))) then
			if (v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(4 + 1)) or ((1703 - (202 + 402)) >= (3011 + 1743))) then
				return "rising_sun_kick default_st 14";
			end
		end
		if (((5869 - (936 + 62)) <= (5240 - (119 + 229))) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.PressurePointBuff) and (v13:Chi() > (4 - 2)) and v13:PrevGCD(3 - 2, v58.RisingSunKick)) then
			if (v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1 + 4)) or ((5357 - 2964) <= (3068 - (513 + 923)))) then
				return "blackout_kick default_st 16";
			end
		end
		if (((4191 - (507 + 1270)) == (1030 + 1384)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and v13:HasTier(120 - 89, 2 + 0) and v13:BuffDown(v58.BlackoutReinforcementBuff)) then
			if (((6040 - 4456) == (2318 - 734)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(777 - (644 + 125)))) then
				return "spinning_crane_kick default_st 18";
			end
		end
		if (((1196 + 1089) > (3920 - (718 + 1129))) and v58.RisingSunKick:IsReady() and (v13:BuffUp(v58.KicksofFlowingMomentumBuff) or v13:BuffUp(v58.PressurePointBuff) or (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (47 + 8)))) then
			if (v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(15 - 10)) or ((4303 - (564 + 845)) < (7884 - 5085))) then
				return "rising_sun_kick default_st 20";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (165 - (46 + 116)))) or ((1925 - (575 + 75)) > (8787 - 5182))) then
			if (((741 - 501) < (4140 - 2950)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
				return "blackout_kick default_st 22";
			end
		end
		if (v58.RisingSunKick:IsReady() or ((380 + 255) > (467 + 1790))) then
			if (((1404 + 557) > (1204 - (224 + 446))) and v22(v58.RisingSunKick, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "rising_sun_kick default_st 24";
			end
		end
		if (((20 + 176) <= (10135 - 7112)) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.BlackoutReinforcementBuff) and v58.RisingSunKick:CooldownDown() and v58.StrikeoftheWindlord:CooldownDown() and v87(v58.BlackoutKick) and v13:BuffUp(v58.DanceofChijiBuff)) then
			if (((2366 - (56 + 262)) <= (11090 - 8043)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(706 - (666 + 35)))) then
				return "blackout_kick default_st 26";
			end
		end
		if (v58.FistsofFury:IsReady() or ((1184 - 773) >= (4150 - (553 + 627)))) then
			if (((2785 - (936 + 537)) <= (471 + 2322)) and v22(v58.FistsofFury, nil, nil, not v14:IsInMeleeRange(1208 - (737 + 463)))) then
				return "fists_of_fury default_st 28";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v13:BuffUp(v58.BlackoutReinforcementBuff) and v87(v58.BlackoutKick)) or ((1615 + 549) >= (4071 - (424 + 243)))) then
			if (((248 + 832) <= (10836 - 7918)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(1351 - (1213 + 133)))) then
				return "blackout_kick default_st 30";
			end
		end
		if ((v58.WhirlingDragonPunch:IsReady() and (v13:BuffDown(v58.PressurePointBuff))) or ((6064 - 2638) <= (946 + 835))) then
			if (v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(65 - (37 + 23))) or ((15859 - 11483) <= (5413 - (122 + 1221)))) then
				return "whirling_dragon_punch default_st 32";
			end
		end
		if ((v58.ChiBurst:IsCastable() and v13:BloodlustUp() and (v13:Chi() < (247 - (139 + 103)))) or ((72 + 733) > (1882 + 2280))) then
			if (((7216 - 2312) == (2571 + 2333)) and v24(v58.ChiBurst, not v14:IsInRange(23 + 17), true)) then
				return "chi_burst default_st 34";
			end
		end
		if ((v58.BlackoutKick:IsReady() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (1 + 1)) and (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (107 - (9 + 97)))) or ((4710 - 2185) > (2102 + 2541))) then
			if (v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(3 + 2)) or ((3184 + 799) < (3828 - 2678))) then
				return "blackout_kick default_st 36";
			end
		end
		if (((5141 - (657 + 418)) < (6227 - (448 + 1532))) and v58.ChiBurst:IsCastable() and (v13:Chi() < (258 - (110 + 143))) and (v13:Energy() < (141 - 91))) then
			if (v24(v58.ChiBurst, not v14:IsInRange(983 - (549 + 394)), true) or ((740 + 706) < (1779 - (500 + 734)))) then
				return "chi_burst default_st 38";
			end
		end
		if ((v58.StrikeoftheWindlord:IsReady() and ((v14:DebuffRemains(v58.SkyreachExhaustionDebuff) > (18 + 12)) or (v66 < (1 + 4)))) or ((119 + 497) == (864 - (343 + 322)))) then
			if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(6 + 3)) or ((1166 + 3218) <= (249 + 2031))) then
				return "strike_of_the_windlord default_st 40";
			end
		end
		if (((16001 - 11437) > (1729 - (297 + 834))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and not v13:HasTier(154 - 123, 1 + 1)) then
			if (((9744 - 5997) == (2479 + 1268)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
				return "spinning_crane_kick default_st 42";
			end
		end
		if (((4675 - (494 + 292)) < (468 + 4298)) and v58.BlackoutKick:IsReady() and v13:BuffUp(v58.TeachingsoftheMonasteryBuff) and (v58.RisingSunKick:CooldownRemains() > (4 - 3))) then
			if (((4260 - (888 + 744)) > (539 + 1925)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(690 - (206 + 479)))) then
				return "blackout_kick default_st 44";
			end
		end
		if ((v58.SpinningCraneKick:IsReady() and v13:BuffUp(v58.BonedustBrewBuff) and v87(v58.SpinningCraneKick) and (v89() >= (1.7000000000000002 + 1))) or ((4370 - (861 + 312)) <= (3735 - (135 + 601)))) then
			if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(1150 - (1085 + 57))) or ((2877 - (224 + 1701)) <= (2 + 69))) then
				return "spinning_crane_kick default_st 46";
			end
		end
		if (((6249 - 3902) >= (373 + 50)) and v58.WhirlingDragonPunch:IsReady()) then
			if (((16319 - 11322) >= (3903 + 872)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(751 - (730 + 16)))) then
				return "whirling_dragon_punch default_st 48";
			end
		end
		if (((3214 + 119) < (5218 - (790 + 792))) and v58.RushingJadeWind:IsReady() and (v13:BuffDown(v58.RushingJadeWindBuff))) then
			if (((4787 - (474 + 607)) >= (2923 - (129 + 401))) and v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(11 - 3))) then
				return "rushing_jade_wind default_st 50";
			end
		end
		if (((1874 - (51 + 67)) < (711 + 3032)) and v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) then
			if (((2711 - (93 + 20)) <= (12673 - 9453)) and v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(25 - (12 + 8)))) then
				return "blackout_kick default_st 52";
			end
		end
	end
	local function v122()
		if ((v58.CracklingJadeLightning:IsReady() and (((v13:BuffStack(v58.TheEmperorsCapacitorBuff) > (217 - (161 + 37))) and (v85() > (v58.CracklingJadeLightning:ExecuteTime() - (1 + 0))) and (v58.RisingSunKick:CooldownRemains() > v58.CracklingJadeLightning:ExecuteTime())) or ((v13:BuffStack(v58.TheEmperorsCapacitorBuff) > (1571 - (507 + 1050))) and (((v58.Serenity:CooldownRemains() < (9 - 4)) and v58.Serenity:IsAvailable()) or (v66 < (9 - 4)))))) or ((3083 + 1879) <= (1059 + 2617))) then
			if (v22(v58.CracklingJadeLightning, nil, nil, not v14:IsSpellInRange(v58.CracklingJadeLightning)) or ((822 + 2645) < (1436 + 1825))) then
				return "crackling_jade_lightning fallthru 2";
			end
		end
		if (((2956 - 1495) <= (3173 - (184 + 680))) and v58.FaelineStomp:IsCastable() and (v87(v58.FaelineStomp))) then
			if (v22(v58.FaelineStomp, nil, nil, not v14:IsInRange(18 + 12)) or ((13227 - 8558) < (293 + 218))) then
				return "faeline_stomp fallthru 4";
			end
		end
		if ((v58.TigerPalm:IsReady() and v87(v58.TigerPalm) and (v13:ChiDeficit() >= ((4 - 2) + v27(v13:BuffUp(v58.PowerStrikesBuff))))) or ((8202 - 3980) <= (519 + 1349))) then
			if (((4140 - (629 + 421)) >= (73 + 29)) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(9 - 4))) then
				return "tiger_palm fallthru 6";
			end
		end
		if (((9026 - 4873) > (2461 - (544 + 396))) and v58.ExpelHarm:IsReady() and (v13:ChiDeficit() >= (1 - 0)) and (v64 > (993 - (904 + 87)))) then
			if (v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(28 - 20)) or ((1723 - (1443 + 31)) < (206 - 115))) then
				return "expel_harm fallthru 8";
			end
		end
		if ((v58.ChiBurst:IsCastable() and (((v13:ChiDeficit() >= (1814 - (1110 + 703))) and (v64 == (2 - 1))) or ((v13:ChiDeficit() >= (1 + 1)) and (v64 >= (5 - 3))))) or ((12595 - 7983) == (2010 - (78 + 125)))) then
			if (((1929 - 1296) <= (8385 - 3931)) and v24(v58.ChiBurst, not v14:IsInRange(57 - 17), true)) then
				return "chi_burst fallthru 10";
			end
		end
		if (v58.ChiWave:IsCastable() or ((4152 - (1392 + 432)) < (13 + 364))) then
			if (((8798 - 5551) == (525 + 2722)) and v22(v58.ChiWave, nil, nil, not v14:IsInRange(1442 - (963 + 439)))) then
				return "chi_wave fallthru 12";
			end
		end
		if (((2962 - 1590) < (5314 - (76 + 1249))) and v58.ExpelHarm:IsReady() and (v13:ChiDeficit() >= (1752 - (1165 + 586)))) then
			if (((5704 - (1916 + 12)) >= (3090 - (604 + 652))) and v22(v58.ExpelHarm, nil, nil, not v14:IsInMeleeRange(15 - 7))) then
				return "expel_harm fallthru 14";
			end
		end
		if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v64 >= (1 + 4))) or ((1779 - 495) >= (995 + 2996))) then
			if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v96, nil, not v14:IsInMeleeRange(11 - 6)) or ((5283 - 1096) <= (5391 - 2086))) then
				return "blackout_kick fallthru 16";
			end
		end
		if (((1500 - 409) == (1104 - (11 + 2))) and v58.SpinningCraneKick:IsReady() and ((v87(v58.SpinningCraneKick) and (v13:BuffStack(v58.ChiEnergyBuff) > ((1472 - (64 + 1378)) - ((12 - 7) * v64))) and v13:BuffDown(v58.StormEarthAndFireBuff) and (((v58.RisingSunKick:CooldownRemains() > (1755 - (256 + 1497))) and (v58.FistsofFury:CooldownRemains() > (2 - 0))) or ((v58.RisingSunKick:CooldownRemains() < (880 - (562 + 315))) and (v58.FistsofFury:CooldownRemains() > (11 - 8)) and (v13:Chi() > (1191 - (577 + 611)))) or ((v58.RisingSunKick:CooldownRemains() > (3 + 0)) and (v58.FistsofFury:CooldownRemains() < (7 - 4)) and (v13:Chi() > (6 - 2))) or ((v13:ChiDeficit() <= (72 - (58 + 13))) and (v85() < (2 + 0))))) or ((v13:BuffStack(v58.ChiEnergyBuff) > (6 + 4)) and (v66 < (461 - (404 + 50)))))) then
			if (((3818 - (6 + 30)) < (5184 - (770 + 563))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(7 + 1))) then
				return "spinning_crane_kick fallthru 18";
			end
		end
		if (((10 + 667) <= (1367 - (25 + 145))) and v58.ArcaneTorrent:IsCastable() and (v13:ChiDeficit() >= (1 + 0))) then
			if (((4649 - (153 + 546)) == (3673 + 277)) and v22(v58.ArcaneTorrent, nil)) then
				return "arcane_torrent fallthru 20";
			end
		end
		if (((5775 - (60 + 867)) >= (504 - 363)) and v58.TigerPalm:IsReady()) then
			if (((4821 - (309 + 974)) < (1799 + 2072)) and v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(13 - 8))) then
				return "tiger_palm fallthru 24";
			end
		end
	end
	local function v123()
		local v161 = 1141 - (677 + 464);
		while true do
			if (((4632 - (567 + 255)) > (4940 - 1776)) and ((3 - 0) == v161)) then
				if (((3085 - (384 + 144)) <= (3822 - (1030 + 191))) and v58.BlackoutKick:IsReady() and (v64 == (5 - 2)) and v87(v58.BlackoutKick) and v13:HasTier(54 - 24, 1 + 1)) then
					if (((3175 - (326 + 531)) > (2591 - 1509)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "blackout_kick serenity ";
					end
				end
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (v64 >= (1 + 2)) and v90()) or ((7555 - 4270) >= (92 + 3357))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8 + 0)) or ((2146 - (1367 + 254)) > (2027 - (305 + 373)))) then
						return "spinning_crane_kick serenity 20";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v64 > (1 - 0)) and (v64 < (323 - (129 + 190))) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (5 - 3))) or ((7086 - 3276) >= (2978 + 1176))) then
					if (((2384 + 39) == (2712 - (210 + 79))) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(8 - 3))) then
						return "blackout_kick serenity 18";
					end
				end
				v161 = 9 - 5;
			end
			if (((5384 - (32 + 640)) >= (3043 + 770)) and (v161 == (4 + 2))) then
				if ((v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and (v64 > (1 + 0))) or ((97 + 56) == (3824 - (847 + 914)))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(23 - 15)) or ((5811 - 3227) == (3771 - (163 + 361)))) then
						return "spinning_crane_kick serenity 34";
					end
				end
				if ((v58.WhirlingDragonPunch:IsReady() and (v64 > (886 - (162 + 723)))) or ((224 + 1531) <= (1094 - (258 + 143)))) then
					if (((14887 - 11474) == (7440 - 4027)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(19 - 14))) then
						return "whirling_dragon_punch serenity 36";
					end
				end
				if ((v58.RushingJadeWind:IsReady() and v13:BuffDown(v58.RushingJadeWindBuff) and (v64 >= (1694 - (486 + 1205)))) or ((4756 - (92 + 73)) <= (1609 + 1451))) then
					if (v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(7 + 1)) or ((5528 - 2236) < (1739 - (68 + 204)))) then
						return "rushing_jade_wind serenity 38";
					end
				end
				v161 = 11 - 4;
			end
			if ((v161 == (1 + 0)) or ((343 + 1027) == (2893 - 2285))) then
				if (((1219 + 1914) >= (844 + 834)) and v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (3 + 0)) and (v13:BuffRemains(v58.TeachingsoftheMonasteryBuff) < (317 - (20 + 296)))) then
					if (((3192 + 1529) > (5414 - 4120)) and v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(17 - 12))) then
						return "blackout_kick serenity 6";
					end
				end
				if ((v58.FistsofFury:IsReady() and ((v13:BuffUp(v58.InvokersDelightBuff) and (((v64 < (4 - 1)) and v58.JadeIgnition:IsAvailable()) or (v64 > (3 + 1)))) or v13:BloodlustUp() or (v64 == (1 + 1)))) or ((7671 - 4952) == (130 + 208))) then
					if (((2045 + 218) <= (2074 + 2262)) and v22(v58.FistsofFury, nil, nil, not v14:IsInMeleeRange(20 - 12))) then
						return "fists_of_fury serenity 10";
					end
				end
				if (v58.FistsofFury:IsReady() or ((2113 - 957) <= (212 + 173))) then
					local v208 = v92();
					if (v208 or ((2016 - (155 + 94)) > (5753 - 1645))) then
						if (((4039 - (515 + 392)) < (4071 - (7 + 319))) and (v208:GUID() == v14:GUID())) then
							if (v24(v58.FistsofFury) or ((3153 + 1705) == (1615 + 3327))) then
								return "fists_of_fury one_gcd serenity 14";
							end
						elseif (((3146 - (292 + 1205)) <= (2624 - (13 + 39))) and v31) then
							if ((((GetTime() - v82.LastTargetSwap) * (872 + 128)) >= v34) or ((14073 - 9649) <= (12023 - 8807))) then
								v82.LastTargetSwap = GetTime();
								if (v24(v23(1138 - (850 + 188))) or ((2600 - (822 + 214)) > (4799 - (317 + 844)))) then
									return "fists_of_fury one_gcd off-target serenity 14";
								end
							end
						end
					end
				end
				v161 = 2 + 0;
			end
			if (((977 + 1465) < (5260 - (508 + 682))) and (v161 == (0 + 0))) then
				if ((v58.FistsofFury:IsReady() and (v13:BuffRemains(v58.SerenityBuff) < (1 + 0))) or ((4513 - (127 + 418)) <= (2911 - 1827))) then
					if (v22(v58.FistsofFury, nil, nil, not v14:IsInMeleeRange(19 - 11)) or ((19501 - 15364) < (3116 - 1309))) then
						return "fists_of_fury serenity 2";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and not v90() and (v64 > (1124 - (690 + 430))) and v58.ShadowboxingTreads:IsAvailable()) or ((1725 - 1282) >= (594 + 866))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(9 - 4)) or ((3659 - (637 + 315)) < (729 - 474))) then
						return "blackout_kick serenity 4";
					end
				end
				if (((12529 - 8547) <= (15429 - 10577)) and v58.RisingSunKick:IsReady() and (((v64 == (3 + 1)) and v13:BuffUp(v58.PressurePointBuff) and not v58.BonedustBrew:IsAvailable()) or (v64 == (2 - 1)) or ((v64 <= (23 - (13 + 7))) and v13:BuffUp(v58.PressurePointBuff)) or (v13:BuffUp(v58.PressurePointBuff) and v13:HasTier(5 + 25, 2 - 0)))) then
					if (((11111 - 6438) == (7410 - 2737)) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v93, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "rising_sun_kick serenity 8";
					end
				end
				v161 = 1 + 0;
			end
			if (((3278 - (44 + 307)) < (3832 - (127 + 670))) and ((6 + 1) == v161)) then
				if (((5019 - (375 + 209)) >= (3777 - (1673 + 143))) and v58.RisingSunKick:IsReady()) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v93, nil, not v14:IsInMeleeRange(5 + 0)) or ((1975 + 1525) <= (2080 - (836 + 613)))) then
						return "rising_sun_kick serenity 40";
					end
				end
				if (((3920 - 2078) < (3095 + 861)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff)) then
					if (((3653 - (295 + 1235)) >= (2038 - (328 + 212))) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(17 - 9))) then
						return "spinning_crane_kick serenity 42";
					end
				end
				if ((v58.BlackoutKick:IsReady() and (v87(v58.BlackoutKick))) or ((2898 - (517 + 402)) == (4304 - 2380))) then
					if (v22(v58.BlackoutKick, nil, nil, not v14:IsInMeleeRange(14 - 9)) or ((1922 - (700 + 382)) > (5227 - (677 + 202)))) then
						return "blackout_kick serenity 44";
					end
				end
				v161 = 13 - 5;
			end
			if (((13477 - 8894) > (4024 + 475)) and (v161 == (757 - (360 + 393)))) then
				if (((13887 - 9666) > (6119 - (1231 + 726))) and v58.RushingJadeWind:IsReady() and v13:BuffDown(v58.RushingJadeWindBuff) and (v64 >= (7 - 2))) then
					if (((4752 - (173 + 1737)) < (6782 - (441 + 1506))) and v22(v58.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(1 + 7))) then
						return "rushing_jade_wind serenity 22";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v58.ShadowboxingTreads:IsAvailable() and (v64 >= (9 - 6)) and v87(v58.BlackoutKick)) or ((2123 - (136 + 558)) >= (1452 + 2391))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(1227 - (988 + 234))) or ((1230 + 1399) > (7467 - 4422))) then
						return "blackout_kick serenity 24";
					end
				end
				if (((4098 - (125 + 526)) >= (9910 - 7005)) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and ((v64 > (3 + 0)) or ((v64 > (5 - 3)) and (v89() >= (1128.3 - (290 + 836)))))) then
					if (v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(3 + 5)) or ((5136 - 2319) < (1193 - (8 + 672)))) then
						return "spinning_crane_kick serenity 26";
					end
				end
				v161 = 1 + 4;
			end
			if (((1438 - (740 + 696)) == v161) or ((1778 - (353 + 693)) >= (1978 + 572))) then
				if (((4582 - (35 + 1458)) > (2034 - (1821 + 49))) and v58.StrikeoftheWindlord:IsReady() and (v58.Thunderfist:IsAvailable())) then
					if (((4142 - 2687) <= (5688 - (727 + 1007))) and v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(176 - (165 + 2)))) then
						return "strike_of_the_windlord serenity 2";
					end
				end
				if (((1809 - (1028 + 631)) == (1765 - (311 + 1304))) and v58.SpinningCraneKick:IsReady() and v87(v58.SpinningCraneKick) and v13:BuffUp(v58.DanceofChijiBuff) and (v64 >= (4 - 2))) then
					if (((548 + 2645) <= (445 + 3345)) and v22(v58.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(587 - (512 + 67)))) then
						return "spinning_crane_kick serenity 14";
					end
				end
				if ((v58.RisingSunKick:IsReady() and (v64 == (10 - 6)) and v13:BuffUp(v58.PressurePointBuff)) or ((91 + 372) == (1027 + 2464))) then
					if (((3366 - 817) >= (6300 - 4240)) and v82.CastTargetIf(v58.RisingSunKick, v62, "min", v93, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "rising_sun_kick serenity 16";
					end
				end
				v161 = 8 - 5;
			end
			if (((5780 - (395 + 1394)) >= (11523 - 8349)) and (v161 == (6 + 2))) then
				if (v58.WhirlingDragonPunch:IsReady() or ((9937 - 6653) <= (5298 - 3497))) then
					if (((4686 - (143 + 324)) <= (11412 - 7111)) and v22(v58.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "whirling_dragon_punch serenity 46";
					end
				end
				if ((v58.TigerPalm:IsReady() and v58.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (8 - 5))) or ((1617 + 2143) < (1344 - (342 + 761)))) then
					if (v22(v58.TigerPalm, nil, nil, not v14:IsInMeleeRange(4 + 1)) or ((4370 - 2780) <= (400 + 614))) then
						return "tiger_palm serenity 48";
					end
				end
				break;
			end
			if ((v161 == (7 - 2)) or ((1768 - 739) >= (1147 + 1085))) then
				if ((v58.StrikeoftheWindlord:IsReady() and (v64 >= (1160 - (889 + 268)))) or ((1063 + 780) >= (670 + 3506))) then
					if (v22(v58.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(22 - 13)) or ((982 - (196 + 101)) > (8603 - 3878))) then
						return "strike_of_the_windlord serenity 28";
					end
				end
				if (((9297 - 6135) == (1084 + 2078)) and v58.RisingSunKick:IsReady() and (v64 == (6 - 4)) and (v58.FistsofFury:CooldownRemains() > (12 - 7))) then
					if (v82.CastTargetIf(v58.RisingSunKick, v62, "min", v93, nil, not v14:IsInMeleeRange(14 - 9)) or ((3559 + 636) == (5354 - 2107))) then
						return "rising_sun_kick serenity 30";
					end
				end
				if ((v58.BlackoutKick:IsReady() and v87(v58.BlackoutKick) and (v64 == (1585 - (431 + 1152))) and (v58.FistsofFury:CooldownRemains() > (5 + 0)) and v58.ShadowboxingTreads:IsAvailable() and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) == (345 - (107 + 237)))) or ((5561 - (690 + 1110)) < (3203 - 1100))) then
					if (v82.CastTargetIf(v58.BlackoutKick, v62, "min", v93, nil, not v14:IsInMeleeRange(1502 - (1374 + 123))) or ((9613 - 5401) <= (36 + 62))) then
						return "blackout_kick serenity 32";
					end
				end
				v161 = 6 + 0;
			end
		end
	end
	local function v124()
		local v162 = 0 + 0;
		while true do
			if (((2257 - (454 + 1149)) < (5907 - 2962)) and (v162 == (8 - 4))) then
				v51 = EpicSettings.Settings['ExpelHarmHP'] or (0 + 0);
				v52 = EpicSettings.Settings['UseDampenHarm'];
				v53 = EpicSettings.Settings['DampenHarmHP'] or (0 + 0);
				v54 = EpicSettings.Settings['UseDiffuseMagic'];
				v162 = 642 - (21 + 616);
			end
			if ((v162 == (0 - 0)) or ((91 + 2279) == (4993 - (125 + 312)))) then
				v35 = EpicSettings.Settings['UseDjaruun'];
				v36 = EpicSettings.Settings['InterruptWithStun'];
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v38 = EpicSettings.Settings['InterruptThreshold'];
				v162 = 1 + 0;
			end
			if (((2062 + 424) <= (4514 - (266 + 842))) and (v162 == (643 - (395 + 243)))) then
				v55 = EpicSettings.Settings['DiffuseMagicHP'] or (0 + 0);
				v56 = EpicSettings.Settings['BonedustBrewUsage'] or "";
				v57 = EpicSettings.Settings['SummonWhiteTigerStatueUsage'] or "";
				v34 = EpicSettings.Settings['cycleDelay'] or "";
				break;
			end
			if ((v162 == (1038 - (383 + 652))) or ((1503 - 989) >= (1349 + 962))) then
				v47 = EpicSettings.Settings['UseTouchOfDeath'];
				v48 = EpicSettings.Settings['UseFortifyingBrew'];
				v49 = EpicSettings.Settings['FortifyingBrewHP'] or (0 + 0);
				v50 = EpicSettings.Settings['UseExpelHarm'];
				v162 = 647 - (114 + 529);
			end
			if (((2505 + 89) > (878 + 577)) and (v162 == (1191 - (352 + 837)))) then
				v43 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v46 = EpicSettings.Settings['UseTouchOfKarma'];
				v162 = 553 - (465 + 85);
			end
			if (((5076 - (366 + 165)) > (1349 + 2899)) and ((3 - 2) == v162)) then
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v41 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v42 = EpicSettings.Settings['UseHealthstone'];
				v162 = 1 + 1;
			end
		end
	end
	local function v125()
		v124();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cycle'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v62 = v13:GetEnemiesInMeleeRange(1670 - (521 + 1144));
		v63 = v13:GetEnemiesInMeleeRange(15 - 7);
		if (((137 + 1554) == (1781 - (5 + 85))) and v30) then
			local v178 = 1693 - (1547 + 146);
			while true do
				if (((0 - 0) == v178) or ((1080 - (272 + 45)) > (9824 - 5681))) then
					v64 = #v63;
					v64 = ((#v63 > (0 + 0)) and #v63) or (1 - 0);
					break;
				end
			end
		else
			v64 = 1 + 0;
		end
		if (((462 + 761) == (1009 + 214)) and v13:IsDeadOrGhost()) then
			return;
		end
		if (v82.TargetIsValid() or v13:AffectingCombat() or ((1093 + 1864) < (3813 - (997 + 299)))) then
			local v179 = 1287 - (903 + 384);
			while true do
				if (((71 + 616) < (1095 + 3022)) and (v179 == (1 + 0))) then
					if (((569 - 277) == (923 - 631)) and (v66 == (3379 + 7732))) then
						v66 = v10.FightRemains(v63, false);
					end
					break;
				end
				if (((2386 - 560) == (1149 + 677)) and (v179 == (589 - (313 + 276)))) then
					v65 = v10.BossFightRemains();
					v66 = v65;
					v179 = 1 + 0;
				end
			end
		end
		if (((4598 - (168 + 160)) > (3031 - (1452 + 4))) and (v82.TargetIsValid() or v13:AffectingCombat())) then
			v67 = v58.InvokeXuenTheWhiteTiger:TimeSinceLastCast() <= (110 - 86);
		end
		if (((2434 - (338 + 82)) >= (698 - (133 + 440))) and v13:AffectingCombat() and v44) then
			if (((1185 + 2988) >= (2675 - 806)) and v58.Detox:IsReady() and v33) then
				local v196 = 0 + 0;
				while true do
					if ((v196 == (0 + 0)) or ((252 + 129) >= (5138 - (422 + 880)))) then
						ShouldReturn = v82.FocusUnit(true, nil, nil, nil);
						if (ShouldReturn or ((5292 - (365 + 1615)) <= (4560 - 1351))) then
							return ShouldReturn;
						end
						break;
					end
				end
			end
		end
		if (((2522 - (479 + 873)) >= (3 + 29)) and v82.TargetIsValid()) then
			if ((not v13:AffectingCombat() and v29) or ((9451 - 6083) <= (2071 - 1319))) then
				local v197 = 0 + 0;
				local v198;
				while true do
					if (((3521 + 345) == (5368 - (832 + 670))) and (v197 == (0 - 0))) then
						v198 = v103();
						if (v198 or ((4301 - 2855) == (5064 - (707 + 540)))) then
							return v198;
						end
						break;
					end
				end
			end
			if (v13:AffectingCombat() or v29 or ((2432 - (18 + 41)) >= (4006 + 422))) then
				if (((380 + 128) < (5856 - (554 + 666))) and not v13:IsCasting() and not v13:IsChanneling()) then
					local v209 = 500 - (438 + 62);
					local v210;
					while true do
						if (((3229 - (1497 + 408)) == (2056 - 732)) and (v209 == (1 + 0))) then
							v210 = v82.InterruptWithStun(v58.LegSweep, 5 + 3);
							if (((1057 - (508 + 132)) < (13245 - 9060)) and v210) then
								return v210;
							end
							v209 = 2 - 0;
						end
						if (((1658 - (49 + 1158)) <= (354 + 1998)) and ((2 - 0) == v209)) then
							v210 = v82.Interrupt(v58.SpearHandStrike, 14 + 26, true, v16, v60.SpearHandStrikeMouseover);
							if (((955 + 402) < (6263 - 3496)) and v210) then
								return v210;
							end
							break;
						end
						if (((689 + 771) < (4599 - (460 + 761))) and (v209 == (0 - 0))) then
							v210 = v82.Interrupt(v58.SpearHandStrike, 7 + 1, true);
							if (v210 or ((223 + 3229) > (4112 - (405 + 191)))) then
								return v210;
							end
							v209 = 1671 - (311 + 1359);
						end
					end
				end
				if (v15 or ((9039 - 5158) < (1285 + 605))) then
					if ((v44 and v33 and v58.Detox:IsReady() and v82.DispellableFriendlyUnit()) or ((120 + 2152) >= (606 + 3054))) then
						if (v24(v60.DetoxFocus) or ((391 + 2663) <= (1144 + 778))) then
							return "detox main";
						end
					end
				end
				v69 = not v58.InvokeXuenTheWhiteTiger:IsAvailable() or ((194 - 74) > v66);
				v70 = not (v14:DebuffRemains(v58.SkyreachExhaustionDebuff) < (1 + 0)) and (v58.RisingSunKick:CooldownRemains() < (1 - 0)) and (v13:HasTier(6 + 24, 3 - 1) or (v64 < (6 - 1)));
				local v199 = v82.HandleDPSPotion(v13:BuffUp(v58.BonedustBrewBuff) or v13:BuffUp(v58.Serenity) or v13:BuffUp(v58.FaelineStomp) or v67);
				if (v199 or ((5709 - (1408 + 112)) < (3508 - (285 + 697)))) then
					return v199;
				end
				if (((v10.CombatTime() < (19 - 15)) and (v13:Chi() < (1265 - (737 + 523))) and not v58.Serenity:IsAvailable() and (not v67 or not v58.InvokeXuenTheWhiteTiger:IsAvailable())) or ((5676 - 4425) > (214 + 1275))) then
					local v211 = 844 - (789 + 55);
					local v212;
					while true do
						if ((v211 == (0 - 0)) or ((413 + 257) == (3579 - 1808))) then
							v212 = v106();
							if (((2641 - 1182) >= (279 + 50)) and v212) then
								return v212;
							end
							break;
						end
					end
				end
				local v200 = v105();
				if (((8148 - 5238) > (2994 - (1492 + 390))) and v200) then
					return v200;
				end
				v200 = v104();
				if (((1001 - 422) < (5597 - (312 + 681))) and v200) then
					return v200;
				end
				if (((3957 - (1255 + 656)) <= (5945 - (485 + 1242))) and v58.FaelineStomp:IsCastable() and v87(v58.FaelineStomp) and v58.FaelineHarmony:IsAvailable()) then
					if (((504 + 1984) > (1891 - 1081)) and v82.CastTargetIf(v58.FaelineStomp, v63, "min", v97, v100, not v14:IsInRange(46 - 16))) then
						return "faeline_stomp main 8";
					end
				end
				if (((18973 - 14179) >= (11649 - 8085)) and v58.TigerPalm:IsReady() and v13:BuffDown(v58.SerenityBuff) and (v13:Energy() > (108 - 58)) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (1 + 2)) and v87(v58.TigerPalm) and (v13:ChiDeficit() >= ((961 - (722 + 237)) + v27(v13:BuffUp(v58.PowerStrikesBuff)))) and ((not v58.InvokeXuenTheWhiteTiger:IsAvailable() and not v58.Serenity:IsAvailable()) or (not v58.Skyreach:IsAvailable() and not v58.Skytouch:IsAvailable()) or (v10.CombatTime() > (14 - 9)) or v67) and not v70) then
					if (v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(721 - (77 + 639))) or ((796 - 535) <= (668 - 531))) then
						return "tiger_palm main 10";
					end
				end
				if ((v58.TigerPalm:IsReady() and v13:BuffDown(v58.SerenityBuff) and (v13:BuffStack(v58.TeachingsoftheMonasteryBuff) < (5 - 2)) and v87(v58.TigerPalm) and (v13:ChiDeficit() >= ((5 - 3) + v27(v13:BuffUp(v58.PowerStrikesBuff)))) and ((not v58.InvokeXuenTheWhiteTiger:IsAvailable() and not v58.Serenity:IsAvailable()) or (not v58.Skyreach:IsAvailable() and not v58.Skytouch:IsAvailable()) or (v10.CombatTime() > (14 - 9)) or v67) and not v70) or ((568 + 85) >= (64 + 1635))) then
					if (((3877 - (888 + 471)) <= (4159 - (1034 + 75))) and v82.CastTargetIf(v58.TigerPalm, v62, "min", v94, nil, not v14:IsInMeleeRange(1162 - (448 + 709)))) then
						return "tiger_palm main 12";
					end
				end
				if (((422 + 4385) > (627 - 450)) and v58.ChiBurst:IsCastable() and v58.FaelineStomp:IsAvailable() and v58.FaelineStomp:CooldownDown() and (((v13:ChiDeficit() >= (1856 - (1643 + 212))) and (v64 == (481 - (320 + 160)))) or ((v13:ChiDeficit() >= (3 - 1)) and (v64 >= (4 - 2)))) and not v58.FaelineHarmony:IsAvailable()) then
					if (((1178 + 2485) >= (1607 - 744)) and v24(v58.ChiBurst, not v14:IsInRange(176 - (114 + 22)), true)) then
						return "chi_burst main 14";
					end
				end
				if (((115 + 3903) <= (5749 - (89 + 970))) and v32 and not v58.Serenity:IsAvailable()) then
					local v213 = 1728 - (1083 + 645);
					local v214;
					while true do
						if ((v213 == (166 - (50 + 116))) or ((2354 - (1058 + 904)) > (4701 - 2561))) then
							v214 = v108();
							if (v214 or ((18089 - 13558) <= (11928 - 8823))) then
								return v214;
							end
							break;
						end
					end
				end
				if (((11256 - 7393) == (838 + 3025)) and v32 and v58.Serenity:IsAvailable()) then
					local v215 = v109();
					if (((3399 - (94 + 102)) > (1789 + 400)) and v215) then
						return v215;
					end
				end
				if (((2253 - (735 + 529)) < (5396 - (875 + 276))) and v13:BuffUp(v58.SerenityBuff)) then
					if (((994 - (461 + 518)) <= (336 + 54)) and v13:BloodlustUp() and (v64 >= (11 - 7))) then
						local v225 = 781 - (656 + 125);
						local v226;
						while true do
							if (((6376 - 3831) >= (2565 - (532 + 316))) and (v225 == (254 - (150 + 104)))) then
								v226 = v110();
								if (v226 or ((3531 + 1104) == (340 - 222))) then
									return v226;
								end
								break;
							end
						end
					end
					if (((3073 - (564 + 1283)) < (1873 + 1359)) and v13:BloodlustUp() and (v64 < (10 - 6))) then
						local v227 = 0 + 0;
						local v228;
						while true do
							if (((310 + 3457) > (2602 - 1896)) and (v227 == (1548 - (330 + 1218)))) then
								v228 = v111();
								if (((1824 + 1468) >= (1241 + 234)) and v228) then
									return v228;
								end
								break;
							end
						end
					end
					if ((v64 > (3 + 1)) or ((2745 + 2028) < (1907 - 564))) then
						local v229 = v112();
						if (v229 or ((887 + 864) < (6678 - 5150))) then
							return v229;
						end
					end
					if (((249 + 692) < (5836 - (511 + 1058))) and (v64 == (9 - 5))) then
						local v230 = v113();
						if (((3024 - (1315 + 183)) >= (464 + 800)) and v230) then
							return v230;
						end
					end
					if ((v64 == (545 - (233 + 309))) or ((4928 - 1436) <= (1617 - (267 + 386)))) then
						local v231 = v114();
						if (v231 or ((6348 - 3622) == (5431 - (744 + 109)))) then
							return v231;
						end
					end
					if ((v64 == (1552 - (1271 + 279))) or ((11832 - 7209) == (3428 - (642 + 1002)))) then
						local v232 = 1863 - (643 + 1220);
						local v233;
						while true do
							if (((1586 - 1040) <= (1753 - 682)) and (v232 == (1417 - (1063 + 354)))) then
								v233 = v115();
								if (v233 or ((5692 - (739 + 91)) <= (6199 - 2558))) then
									return v233;
								end
								break;
							end
						end
					end
					if (((4727 - (790 + 1087)) > (894 + 103)) and (v64 == (2 - 1))) then
						local v234 = v116();
						if (((13963 - 9783) <= (11558 - 7056)) and v234) then
							return v234;
						end
					end
				end
				if ((v64 > (13 - 9)) or ((519 - 370) == (1042 - (82 + 67)))) then
					local v216 = 0 + 0;
					local v217;
					while true do
						if (((2032 - 995) < (3731 - (1835 + 150))) and ((14 - (12 + 2)) == v216)) then
							v217 = v117();
							if (((4774 - (784 + 252)) >= (1292 + 2400)) and v217) then
								return v217;
							end
							break;
						end
					end
				end
				if ((v64 == (74 - 31)) or ((3208 + 614) < (2207 - (1134 + 250)))) then
					local v218 = 0 + 0;
					local v219;
					while true do
						if ((v218 == (0 + 0)) or ((8961 - 3999) == (2111 + 1035))) then
							v219 = v118();
							if (v219 or ((1329 - 854) > (10153 - 6007))) then
								return v219;
							end
							break;
						end
					end
				end
				if ((v64 == (6 - 3)) or ((2102 - (1940 + 41)) >= (367 - (39 + 199)))) then
					local v220 = 0 + 0;
					local v221;
					while true do
						if (((0 - 0) == v220) or ((3423 - 1365) > (6887 - (313 + 1616)))) then
							v221 = v119();
							if (((5624 - 3865) == (2539 - 780)) and v221) then
								return v221;
							end
							break;
						end
					end
				end
				if ((v64 == (3 - 1)) or ((4580 - (7 + 30)) == (1544 - (961 + 225)))) then
					local v222 = 0 - 0;
					local v223;
					while true do
						if (((1070 + 933) == (2843 - (281 + 559))) and ((0 - 0) == v222)) then
							v223 = v120();
							if (v223 or ((1 + 2) == (208 + 2160))) then
								return v223;
							end
							break;
						end
					end
				end
				if ((v64 == (1 + 0)) or ((31 + 2726) > (5408 - (102 + 1338)))) then
					local v224 = v121();
					if (((152 + 660) <= (931 + 939)) and v224) then
						return v224;
					end
				end
				local v200 = v122();
				if (((4330 - (319 + 122)) == (702 + 3187)) and v200) then
					return v200;
				end
			end
			if (((2407 - (45 + 951)) < (2181 + 207)) and v22(v58.PoolEnergy)) then
				return "Pool Energy";
			end
		end
	end
	local function v126()
		local v168 = 0 + 0;
		while true do
			if (((2036 + 2735) == (7933 - 3162)) and (v168 == (0 + 0))) then
				v84();
				v21.Print("Windwalker Monk rotation by Epic BoomK");
				v168 = 1 + 0;
			end
			if ((v168 == (1376 - (684 + 691))) or ((1742 - (1161 + 483)) >= (3311 - (245 + 721)))) then
				EpicSettings.SetupVersion("Windwalker Monk X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v21.SetAPL(251 + 18, v125, v126);
end;
return v0["Epix_Monk_Windwalker.lua"]();

