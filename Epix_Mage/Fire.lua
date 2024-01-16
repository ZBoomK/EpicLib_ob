local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1761 - (927 + 834);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((1518 - (317 + 115)) >= (2825 - 1420))) then
			v6 = v0[v4];
			if (not v6 or ((1931 + 438) == (377 + 49))) then
				return v1(v4, ...);
			end
			v5 = 827 - (802 + 24);
		end
		if ((v5 == (1 - 0)) or ((3884 - 808) > (471 + 2712))) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Fire.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.Pet;
	local v18 = v12.Mouseover;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.PressCursor;
	local v26 = v22.Macro;
	local v27 = v22.Bind;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = math.max;
	local v31 = math.ceil;
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v89 = v19.Mage.Fire;
	local v90 = v21.Mage.Fire;
	local v91 = v26.Mage.Fire;
	local v92 = {};
	local v93 = v22.Commons.Everyone;
	local function v94()
		if (((924 + 278) > (174 + 884)) and v89.RemoveCurse:IsAvailable()) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v35;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (1 + 3)) or (2779 - 1780);
	local v98 = 3331 - 2332;
	local v99 = v97;
	local v100 = ((2 + 1) * v28(v89.FueltheFire:IsAvailable())) + ((407 + 592) * v28(not v89.FueltheFire:IsAvailable()));
	local v101 = 825 + 174;
	local v102 = 30 + 10;
	local v103 = 467 + 532;
	local v104 = 1433.3 - (797 + 636);
	local v105 = 0 - 0;
	local v106 = 1625 - (1427 + 192);
	local v107 = false;
	local v108 = (v107 and (7 + 13)) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (1 + 0);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 326 - (192 + 134);
	local v115 = 1276 - (316 + 960);
	local v116 = 5 + 3;
	local v117 = 3 + 0;
	local v118;
	local v119;
	local v120;
	local v121 = 3 + 0;
	local v122 = 42477 - 31366;
	local v123 = 11662 - (83 + 468);
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v10:RegisterForEvent(function()
		local v155 = 1806 - (1202 + 604);
		while true do
			if (((17323 - 13612) > (5583 - 2228)) and (v155 == (0 - 0))) then
				v107 = false;
				v108 = (v107 and (345 - (45 + 280))) or (0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (2 + 1)) or ((502 + 404) >= (393 + 1836))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if (((2384 - 1096) > (3162 - (340 + 1571))) and (v156 == (1 + 1))) then
				v89.PhoenixFlames:RegisterInFlightEffect(259314 - (1733 + 39));
				v89.PhoenixFlames:RegisterInFlight();
				v156 = 8 - 5;
			end
			if ((v156 == (1035 - (125 + 909))) or ((6461 - (1096 + 852)) < (1504 + 1848))) then
				v89.Meteor:RegisterInFlightEffect(501465 - 150325);
				v89.Meteor:RegisterInFlight();
				v156 = 2 + 0;
			end
			if ((v156 == (512 - (409 + 103))) or ((2301 - (46 + 190)) >= (3291 - (51 + 44)))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v156 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(352457 - (1114 + 203));
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(258268 - (228 + 498));
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v10:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 + 0)) or ((5039 - (174 + 489)) <= (3858 - 2377))) then
				v122 = 13016 - (830 + 1075);
				v123 = 11635 - (303 + 221);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v158 = 1269 - (231 + 1038);
		while true do
			if ((v158 == (0 + 0)) or ((4554 - (171 + 991)) >= (19538 - 14797))) then
				v96 = v89.SunKingsBlessing:IsAvailable();
				v97 = ((v89.FlamePatch:IsAvailable()) and (7 - 4)) or (2492 - 1493);
				v158 = 1 + 0;
			end
			if (((11655 - 8330) >= (6213 - 4059)) and (v158 == (1 - 0))) then
				v99 = v97;
				v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (1249 - (111 + 1137));
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v15:HealthPercentage() > (248 - (91 + 67)));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (267 - 177)) and v15:TimeToX(23 + 67)) or (523 - (423 + 100)))) or (0 + 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (83 - 53));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (16 + 14));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v159 = (v132() and (v28(v89.Pyroblast:InFlight()) + v28(v89.Fireball:InFlight()))) or (771 - (326 + 445));
		v159 = v159 + v28(v89.PhoenixFlames:InFlight() or v14:PrevGCDP(4 - 3, v89.PhoenixFlames));
		return v14:BuffUp(v89.HotStreakBuff) or v14:BuffUp(v89.HyperthermiaBuff) or (v14:BuffUp(v89.HeatingUpBuff) and ((v135() and v14:IsCasting(v89.Scorch)) or (v132() and (v14:IsCasting(v89.Fireball) or v14:IsCasting(v89.Pyroblast) or (v159 > (0 - 0))))));
	end
	local function v138(v160)
		local v161 = 0 - 0;
		local v162;
		while true do
			if (((712 - (530 + 181)) == v161) or ((2176 - (614 + 267)) >= (3265 - (19 + 13)))) then
				return v162;
			end
			if (((7123 - 2746) > (3825 - 2183)) and ((0 - 0) == v161)) then
				v162 = 0 + 0;
				for v221, v222 in pairs(v160) do
					if (((8305 - 3582) > (2811 - 1455)) and v222:DebuffUp(v89.IgniteDebuff)) then
						v162 = v162 + (1813 - (1293 + 519));
					end
				end
				v161 = 1 - 0;
			end
		end
	end
	local function v139()
		local v163 = 0 - 0;
		if (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight() or ((7909 - 3773) <= (14803 - 11370))) then
			v163 = v163 + (2 - 1);
		end
		return v163;
	end
	local function v140()
		local v164 = 0 + 0;
		while true do
			if (((867 + 3378) <= (10759 - 6128)) and (v164 == (1 + 0))) then
				v32 = v93.HandleBottomTrinket(v92, v35, 14 + 26, nil);
				if (((2673 + 1603) >= (5010 - (709 + 387))) and v32) then
					return v32;
				end
				break;
			end
			if (((2056 - (673 + 1185)) <= (12659 - 8294)) and (v164 == (0 - 0))) then
				v32 = v93.HandleTopTrinket(v92, v35, 65 - 25, nil);
				if (((3421 + 1361) > (3494 + 1182)) and v32) then
					return v32;
				end
				v164 = 1 - 0;
			end
		end
	end
	local function v141()
		if (((1195 + 3669) > (4380 - 2183)) and v89.RemoveCurse:IsReady() and v93.DispellableFriendlyUnit(39 - 19)) then
			if (v24(v91.RemoveCurseFocus) or ((5580 - (446 + 1434)) == (3790 - (1040 + 243)))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v142()
		if (((13353 - 8879) >= (2121 - (559 + 1288))) and v89.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v89.BlazingBarrier) and (v14:HealthPercentage() <= v62)) then
			if (v24(v89.BlazingBarrier) or ((3825 - (609 + 1322)) <= (1860 - (13 + 441)))) then
				return "blazing_barrier defensive 1";
			end
		end
		if (((5874 - 4302) >= (4010 - 2479)) and v89.MassBarrier:IsCastable() and v60 and v14:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v67, 9 - 7)) then
			if (v24(v89.MassBarrier) or ((175 + 4512) < (16495 - 11953))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((1169 + 2122) > (731 + 936)) and v89.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
			if (v24(v89.IceBlock) or ((2590 - 1717) == (1114 + 920))) then
				return "ice_block defensive 3";
			end
		end
		if ((v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) or ((5178 - 2362) < (8 + 3))) then
			if (((2058 + 1641) < (3382 + 1324)) and v24(v89.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((2222 + 424) >= (858 + 18)) and v89.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) then
			if (((1047 - (153 + 280)) <= (9193 - 6009)) and v24(v89.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if (((2807 + 319) == (1235 + 1891)) and v89.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
			if (v24(v89.GreaterInvisibility) or ((1145 + 1042) >= (4496 + 458))) then
				return "greater_invisibility defensive 5";
			end
		end
		if ((v89.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) or ((2810 + 1067) == (5443 - 1868))) then
			if (((437 + 270) > (1299 - (89 + 578))) and v24(v89.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v90.Healthstone:IsReady() and v77 and (v14:HealthPercentage() <= v79)) or ((391 + 155) >= (5579 - 2895))) then
			if (((2514 - (572 + 477)) <= (581 + 3720)) and v24(v91.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((1023 + 681) > (171 + 1254)) and v76 and (v14:HealthPercentage() <= v78)) then
			local v214 = 86 - (84 + 2);
			while true do
				if (((0 - 0) == v214) or ((495 + 192) == (5076 - (497 + 345)))) then
					if ((v80 == "Refreshing Healing Potion") or ((86 + 3244) < (242 + 1187))) then
						if (((2480 - (605 + 728)) >= (240 + 95)) and v90.RefreshingHealingPotion:IsReady()) then
							if (((7636 - 4201) > (97 + 2000)) and v24(v91.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v80 == "Dreamwalker's Healing Potion") or ((13938 - 10168) >= (3643 + 398))) then
						if (v90.DreamwalkersHealingPotion:IsReady() or ((10503 - 6712) <= (1217 + 394))) then
							if (v24(v91.RefreshingHealingPotion) or ((5067 - (457 + 32)) <= (852 + 1156))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v143()
		if (((2527 - (832 + 570)) <= (1956 + 120)) and v89.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
			if (v24(v89.ArcaneIntellect) or ((194 + 549) >= (15567 - 11168))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((557 + 598) < (2469 - (588 + 208))) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v59 and v85) then
			if (v24(v89.MirrorImage) or ((6263 - 3939) <= (2378 - (884 + 916)))) then
				return "mirror_image precombat 2";
			end
		end
		if (((7886 - 4119) == (2185 + 1582)) and v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast)) then
			if (((4742 - (232 + 421)) == (5978 - (1569 + 320))) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
				return "pyroblast precombat 4";
			end
		end
		if (((1094 + 3364) >= (319 + 1355)) and v89.Fireball:IsReady() and v41) then
			if (((3275 - 2303) <= (2023 - (316 + 289))) and v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v144()
		if ((v89.LivingBomb:IsReady() and v43 and (v126 > (2 - 1)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 + 0)))) or ((6391 - (666 + 787)) < (5187 - (360 + 65)))) then
			if (v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb)) or ((2341 + 163) > (4518 - (79 + 175)))) then
				return "living_bomb active_talents 2";
			end
		end
		if (((3394 - 1241) == (1681 + 472)) and v89.Meteor:IsReady() and v44 and (v75 < v123) and ((v109 <= (0 - 0)) or (v14:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((86 - 41) < v109) or (v123 < v109))))) then
			if (v24(v91.MeteorCursor, not v15:IsInRange(939 - (503 + 396))) or ((688 - (92 + 89)) >= (5026 - 2435))) then
				return "meteor active_talents 4";
			end
		end
		if (((2299 + 2182) == (2653 + 1828)) and v89.DragonsBreath:IsReady() and v39 and v89.AlexstraszasFury:IsAvailable() and v119 and v14:BuffDown(v89.HotStreakBuff) and (v14:BuffUp(v89.FeeltheBurnBuff) or (v10.CombatTime() > (58 - 43))) and not v135() and (v133() == (0 + 0)) and not v89.TemperedFlames:IsAvailable()) then
			if (v24(v89.DragonsBreath, not v15:IsInRange(22 - 12)) or ((2032 + 296) < (331 + 362))) then
				return "dragons_breath active_talents 6";
			end
		end
		if (((13181 - 8853) == (541 + 3787)) and v89.DragonsBreath:IsReady() and v39 and v89.AlexstraszasFury:IsAvailable() and v119 and v14:BuffDown(v89.HotStreakBuff) and (v14:BuffUp(v89.FeeltheBurnBuff) or (v10.CombatTime() > (22 - 7))) and not v135() and v89.TemperedFlames:IsAvailable()) then
			if (((2832 - (485 + 759)) >= (3081 - 1749)) and v24(v89.DragonsBreath, not v15:IsInRange(1199 - (442 + 747)))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v145()
		local v165 = 1135 - (832 + 303);
		local v166;
		while true do
			if ((v165 == (948 - (88 + 858))) or ((1273 + 2901) > (3516 + 732))) then
				if ((v75 < v123) or ((189 + 4397) <= (871 - (766 + 23)))) then
					if (((19070 - 15207) == (5282 - 1419)) and v82 and ((v35 and v83) or not v83)) then
						local v226 = 0 - 0;
						while true do
							if ((v226 == (0 - 0)) or ((1355 - (1036 + 37)) <= (30 + 12))) then
								v32 = v140();
								if (((8975 - 4366) >= (603 + 163)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v165 == (1481 - (641 + 839))) or ((2065 - (910 + 3)) == (6342 - 3854))) then
				if (((5106 - (1466 + 218)) > (1540 + 1810)) and v81 and ((v84 and v35) or not v84) and (v75 < v123)) then
					local v223 = 1148 - (556 + 592);
					while true do
						if (((312 + 565) > (1184 - (329 + 479))) and (v223 == (855 - (174 + 680)))) then
							if (v89.Fireblood:IsCastable() or ((10713 - 7595) <= (3836 - 1985))) then
								if (v24(v89.Fireblood) or ((118 + 47) >= (4231 - (396 + 343)))) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (((350 + 3599) < (6333 - (29 + 1448))) and v89.AncestralCall:IsCastable()) then
								if (v24(v89.AncestralCall) or ((5665 - (135 + 1254)) < (11361 - 8345))) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
						if (((21898 - 17208) > (2750 + 1375)) and (v223 == (1527 - (389 + 1138)))) then
							if (v89.BloodFury:IsCastable() or ((624 - (102 + 472)) >= (846 + 50))) then
								if (v24(v89.BloodFury) or ((951 + 763) >= (2759 + 199))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v89.Berserking:IsCastable() and v118) or ((3036 - (320 + 1225)) < (1145 - 501))) then
								if (((431 + 273) < (2451 - (157 + 1307))) and v24(v89.Berserking)) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v223 = 1860 - (821 + 1038);
						end
					end
				end
				if (((9276 - 5558) > (209 + 1697)) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
					if (v24(v89.TimeWarp, nil, nil, true) or ((1701 - 743) > (1353 + 2282))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v165 = 4 - 2;
			end
			if (((4527 - (834 + 192)) <= (286 + 4206)) and (v165 == (0 + 0))) then
				v166 = v93.HandleDPSPotion(v14:BuffUp(v89.CombustionBuff));
				if (v166 or ((74 + 3368) < (3947 - 1399))) then
					return v166;
				end
				v165 = 305 - (300 + 4);
			end
		end
	end
	local function v146()
		if (((768 + 2107) >= (3832 - 2368)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v35) or not v84) and (v75 < v123) and v119) then
			if (v24(v89.LightsJudgment, not v15:IsSpellInRange(v89.LightsJudgment)) or ((5159 - (112 + 250)) >= (1951 + 2942))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if ((v89.BagofTricks:IsCastable() and v81 and ((v84 and v35) or not v84) and (v75 < v123) and v119) or ((1380 - 829) > (1185 + 883))) then
			if (((1094 + 1020) > (707 + 237)) and v24(v89.BagofTricks)) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if ((v89.LivingBomb:IsReady() and v34 and v43 and (v126 > (1 + 0)) and v119) or ((1681 + 581) >= (4510 - (1001 + 413)))) then
			if (v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb)) or ((5028 - 2773) >= (4419 - (244 + 638)))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v14:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (713 - (627 + 66))) or ((11432 - 7595) < (1908 - (512 + 90)))) then
			local v215 = 1906 - (1665 + 241);
			while true do
				if (((3667 - (373 + 344)) == (1331 + 1619)) and (v215 == (0 + 0))) then
					v32 = v145();
					if (v32 or ((12457 - 7734) < (5580 - 2282))) then
						return v32;
					end
					break;
				end
			end
		end
		if (((2235 - (35 + 1064)) >= (113 + 41)) and v89.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v89.CombustionBuff) and v14:HasTier(64 - 34, 1 + 1) and not v89.PhoenixFlames:InFlight() and (v15:DebuffRemains(v89.CharringEmbersDebuff) < ((1240 - (298 + 938)) * v124)) and v14:BuffDown(v89.HotStreakBuff)) then
			if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((1530 - (233 + 1026)) > (6414 - (636 + 1030)))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v32 = v144();
		if (((2424 + 2316) >= (3079 + 73)) and v32) then
			return v32;
		end
		if ((v89.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v123) and (v139() == (0 + 0)) and v119 and (v109 <= (0 + 0)) and ((v14:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((2799 - (55 + 166)) >= (657 + 2733))) then
			if (((5 + 36) <= (6343 - 4682)) and v24(v89.Combustion, not v15:IsInRange(337 - (36 + 261)), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if (((1050 - 449) < (4928 - (34 + 1334))) and v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and v119 and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) then
			if (((91 + 144) < (534 + 153)) and v24(v91.FlamestrikeCursor, not v15:IsInRange(1323 - (1035 + 248)))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if (((4570 - (20 + 1)) > (601 + 552)) and v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and v119 and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
			if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast)) or ((4993 - (134 + 185)) < (5805 - (549 + 584)))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((4353 - (314 + 371)) < (15657 - 11096)) and v89.Fireball:IsReady() and v41 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (970 - (478 + 490))) and not v135()) then
			if (v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball)) or ((242 + 213) == (4777 - (786 + 386)))) then
				return "fireball combustion_phase 16";
			end
		end
		if ((v89.Scorch:IsReady() and v47 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) or ((8625 - 5962) == (4691 - (1055 + 324)))) then
			if (((5617 - (1093 + 247)) <= (3977 + 498)) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v89.FireBlast:IsReady() and v40 and not v137() and not v113 and (not v135() or v14:IsCasting(v89.Scorch) or (v15:DebuffRemains(v89.ImprovedScorchDebuff) > ((1 + 3) * v124))) and (v14:BuffDown(v89.FuryoftheSunKingBuff) or v14:IsCasting(v89.Pyroblast)) and v118 and v14:BuffDown(v89.HyperthermiaBuff) and v14:BuffDown(v89.HotStreakBuff) and ((v139() + (v28(v14:BuffUp(v89.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (6 - 4))) or ((2475 - 1605) == (2987 - 1798))) then
			if (((553 + 1000) <= (12069 - 8936)) and v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast combustion_phase 20";
			end
		end
		if ((v34 and v89.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v14:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v28(v89.Hyperthermia:IsAvailable())))))) or ((7710 - 5473) >= (2648 + 863))) then
			if (v24(v91.FlamestrikeCursor, not v15:IsInRange(102 - 62)) or ((2012 - (364 + 324)) > (8278 - 5258))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if ((v89.Pyroblast:IsReady() and v46 and (v14:BuffUp(v89.HyperthermiaBuff))) or ((7179 - 4187) == (624 + 1257))) then
			if (((12996 - 9890) > (2443 - 917)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if (((9181 - 6158) < (5138 - (1249 + 19))) and v89.Pyroblast:IsReady() and v46 and v14:BuffUp(v89.HotStreakBuff) and v118) then
			if (((130 + 13) > (287 - 213)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if (((1104 - (686 + 400)) < (1658 + 454)) and v89.Pyroblast:IsReady() and v46 and v14:PrevGCDP(230 - (73 + 156), v89.Scorch) and v14:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) then
			if (((6 + 1091) <= (2439 - (721 + 90))) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((53 + 4577) == (15033 - 10403)) and v89.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v123) and v118 and (v89.FireBlast:Charges() == (470 - (224 + 246))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
			if (((5734 - 2194) > (4939 - 2256)) and v24(v89.ShiftingPower, not v15:IsInRange(8 + 32))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((115 + 4679) >= (2406 + 869)) and v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) then
			if (((2949 - 1465) == (4938 - 3454)) and v24(v91.FlamestrikeCursor, not v15:IsInRange(553 - (203 + 310)))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if (((3425 - (1238 + 755)) < (249 + 3306)) and v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
			if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast)) or ((2599 - (709 + 825)) > (6593 - 3015))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < ((5 - 1) * v124)) and (v127 < v99)) or ((5659 - (196 + 668)) < (5555 - 4148))) then
			if (((3838 - 1985) < (5646 - (171 + 662))) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v45 and v14:HasTier(123 - (4 + 89), 6 - 4) and (v89.PhoenixFlames:TravelTime() < v14:BuffRemains(v89.CombustionBuff)) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) < (1 + 1)) and ((v15:DebuffRemains(v89.CharringEmbersDebuff) < ((17 - 13) * v124)) or (v14:BuffStack(v89.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v89.FlamesFuryBuff))) or ((4307 - (35 + 1451)) < (3884 - (28 + 1425)))) then
			if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((4867 - (941 + 1052)) < (2092 + 89))) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if ((v89.Fireball:IsReady() and v41 and (v14:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v14:BuffUp(v89.FlameAccelerantBuff)) or ((4203 - (822 + 692)) <= (488 - 145))) then
			if (v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball)) or ((881 + 988) == (2306 - (45 + 252)))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(30 + 0, 1 + 1) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v14:BuffRemains(v89.CombustionBuff)) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) < (4 - 2))) or ((3979 - (114 + 319)) < (3333 - 1011))) then
			if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((2667 - 585) == (3043 + 1730))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if (((4832 - 1588) > (2210 - 1155)) and v89.Scorch:IsReady() and v47 and (v14:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
			if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((5276 - (556 + 1407)) <= (2984 - (741 + 465)))) then
				return "scorch combustion_phase 44";
			end
		end
		if ((v89.Fireball:IsReady() and v41 and (v14:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) or ((1886 - (170 + 295)) >= (1109 + 995))) then
			if (((1665 + 147) <= (7998 - 4749)) and v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((1346 + 277) <= (1256 + 701)) and v89.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (1 + 0))) then
			if (((5642 - (957 + 273)) == (1181 + 3231)) and v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v147()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v28(v125 < v99)) + (v89.Flamestrike:CastTime() * v28(v125 >= v99))) - v104;
		v109 = v114;
		if (((701 + 1049) >= (3208 - 2366)) and v89.Firestarter:IsAvailable() and not v96) then
			v109 = v30(v133(), v109);
		end
		if (((11521 - 7149) > (5650 - 3800)) and v89.SunKingsBlessing:IsAvailable() and v132() and v14:BuffDown(v89.FuryoftheSunKingBuff)) then
			v109 = v30((v116 - v14:BuffStack(v89.SunKingsBlessingBuff)) * (14 - 11) * v124, v109);
		end
		v109 = v30(v14:BuffRemains(v89.CombustionBuff), v109);
		if (((2012 - (389 + 1391)) < (516 + 305)) and (((v114 + ((13 + 107) * ((2 - 1) - (((951.4 - (783 + 168)) + ((0.2 - 0) * v28(v89.Firestarter:IsAvailable()))) * v28(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (20 + 0))))) then
			v109 = v114;
		end
	end
	local function v148()
		local v167 = 311 - (309 + 2);
		while true do
			if (((1590 - 1072) < (2114 - (1090 + 122))) and (v167 == (0 + 0))) then
				if (((10055 - 7061) > (588 + 270)) and v89.FireBlast:IsReady() and v40 and not v137() and not v113 and v14:BuffDown(v89.HotStreakBuff) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) == (1119 - (628 + 490))) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (1 + 0)) or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((4 - 2) * v124)))) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((17160 - 13405) <= (1689 - (431 + 343)))) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((7969 - 4023) > (10828 - 7085)) and v89.FireBlast:IsReady() and v40 and not v137() and not v113 and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and v89.ShiftingPower:CooldownUp() and (not v14:HasTier(4 + 26, 1697 - (556 + 1139)) or (v15:DebuffRemains(v89.CharringEmbersDebuff) > ((17 - (6 + 9)) * v124)))) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((245 + 1090) >= (1694 + 1612))) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v149()
		local v168 = 169 - (28 + 141);
		while true do
			if (((1877 + 2967) > (2780 - 527)) and (v168 == (3 + 1))) then
				if (((1769 - (486 + 831)) == (1176 - 724)) and v89.Scorch:IsReady() and v47 and (v134())) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((16043 - 11486) < (395 + 1692))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((12249 - 8375) == (5137 - (668 + 595))) and v34 and v89.ArcaneExplosion:IsReady() and v37 and (v128 >= v101) and (v14:ManaPercentageP() >= v102)) then
					if (v24(v89.ArcaneExplosion, not v15:IsInRange(8 + 0)) or ((391 + 1547) > (13458 - 8523))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and (v125 >= v98)) or ((4545 - (23 + 267)) < (5367 - (1129 + 815)))) then
					if (((1841 - (371 + 16)) <= (4241 - (1326 + 424))) and v24(v91.FlamestrikeCursor, not v15:IsInRange(75 - 35))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and v89.TemperedFlames:IsAvailable() and v14:BuffDown(v89.FlameAccelerantBuff)) or ((15190 - 11033) <= (2921 - (88 + 30)))) then
					if (((5624 - (720 + 51)) >= (6633 - 3651)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 35";
					end
				end
				v168 = 1781 - (421 + 1355);
			end
			if (((6819 - 2685) > (1650 + 1707)) and (v168 == (1086 - (286 + 797)))) then
				if ((v89.PhoenixFlames:IsCastable() and v45 and v89.AlexstraszasFury:IsAvailable() and v14:BuffDown(v89.HotStreakBuff) and (v139() == (0 - 0)) and ((not v112 and v14:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (2.5 - 0)) or ((v89.PhoenixFlames:ChargesFractional() > (440.5 - (397 + 42))) and (not v89.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((1 + 2) * v124)))))) or ((4217 - (24 + 776)) < (3903 - 1369))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((3507 - (222 + 563)) <= (360 - 196))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v144();
				if (v32 or ((1734 + 674) < (2299 - (23 + 167)))) then
					return v32;
				end
				if ((v34 and v89.DragonsBreath:IsReady() and v39 and (v127 > (1799 - (690 + 1108))) and v89.AlexstraszasFury:IsAvailable()) or ((12 + 21) == (1201 + 254))) then
					if (v24(v89.DragonsBreath, not v15:IsInRange(858 - (40 + 808))) or ((73 + 370) >= (15353 - 11338))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v168 = 4 + 0;
			end
			if (((1790 + 1592) > (92 + 74)) and ((571 - (47 + 524)) == v168)) then
				if ((v34 and v89.Flamestrike:IsReady() and v42 and (v125 >= v97) and v137()) or ((182 + 98) == (8361 - 5302))) then
					if (((2812 - 931) > (2948 - 1655)) and v24(v91.FlamestrikeCursor, not v15:IsInRange(1766 - (1165 + 561)))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((71 + 2286) == (7299 - 4942)) and v89.Pyroblast:IsReady() and v46 and (v137())) then
					if (((47 + 76) == (602 - (341 + 138))) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and (v125 >= v100) and v14:BuffUp(v89.FuryoftheSunKingBuff)) or ((286 + 770) >= (6999 - 3607))) then
					if (v24(v91.FlamestrikeCursor, not v15:IsInRange(366 - (89 + 237))) or ((3477 - 2396) < (2263 - 1188))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((886 - (581 + 300)) * v124))) and v14:BuffUp(v89.FuryoftheSunKingBuff) and not v14:IsCasting(v89.Scorch)) or ((2269 - (855 + 365)) >= (10526 - 6094))) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((1557 + 3211) <= (2081 - (1030 + 205)))) then
						return "scorch standard_rotation 13";
					end
				end
				v168 = 1 + 0;
			end
			if (((2 + 0) == v168) or ((3644 - (156 + 130)) <= (3226 - 1806))) then
				if ((v89.PhoenixFlames:IsCastable() and v45 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((2 - 0) * v124)))) or ((7657 - 3918) <= (792 + 2213))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((968 + 691) >= (2203 - (10 + 59)))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v45 and v14:HasTier(9 + 21, 9 - 7) and (v15:DebuffRemains(v89.CharringEmbersDebuff) < ((1165 - (671 + 492)) * v124)) and v14:BuffDown(v89.HotStreakBuff)) or ((2596 + 664) < (3570 - (369 + 846)))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((178 + 491) == (3604 + 619))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((3637 - (1036 + 909)) < (468 + 120))) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((8053 - 3256) < (3854 - (11 + 192)))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v45 and not v89.AlexstraszasFury:IsAvailable() and v14:BuffDown(v89.HotStreakBuff) and not v112 and v14:BuffUp(v89.FlamesFuryBuff)) or ((2111 + 2066) > (5025 - (135 + 40)))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((969 - 569) > (670 + 441))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v168 = 6 - 3;
			end
			if (((4573 - 1522) > (1181 - (50 + 126))) and (v168 == (2 - 1))) then
				if (((818 + 2875) <= (5795 - (1233 + 180))) and v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and (v14:BuffUp(v89.FuryoftheSunKingBuff))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true) or ((4251 - (522 + 447)) > (5521 - (107 + 1314)))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v89.FireBlast:IsReady() and v40 and not v137() and not v132() and not v113 and v14:BuffDown(v89.FuryoftheSunKingBuff) and ((((v14:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 + 0)) or not v89.Hyperthermia:IsAvailable())) or (v14:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (0.5 - 0)) or not v89.Hyperthermia:IsAvailable()))) and v14:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v15:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (2 + 1))) and ((v14:BuffUp(v89.HeatingUpBuff) and not v14:IsCasting(v89.Scorch)) or (v14:BuffDown(v89.HotStreakBuff) and v14:BuffDown(v89.HeatingUpBuff) and v14:IsCasting(v89.Scorch) and (v139() == (0 - 0))))))) or ((14164 - 10584) < (4754 - (716 + 1194)))) then
					if (((2 + 87) < (481 + 4009)) and v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and (v14:IsCasting(v89.Scorch) or v14:PrevGCDP(504 - (74 + 429), v89.Scorch)) and v14:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((9612 - 4629) < (897 + 911))) then
					if (((8764 - 4935) > (2667 + 1102)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((4577 - 3092) <= (7180 - 4276)) and v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < ((437 - (279 + 154)) * v124))) then
					if (((5047 - (454 + 324)) == (3359 + 910)) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
						return "scorch standard_rotation 19";
					end
				end
				v168 = 19 - (12 + 5);
			end
			if (((209 + 178) <= (7088 - 4306)) and (v168 == (2 + 3))) then
				if ((v89.Fireball:IsReady() and v41 and not v137()) or ((2992 - (277 + 816)) <= (3918 - 3001))) then
					if (v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball), true) or ((5495 - (1058 + 125)) <= (165 + 711))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
		end
	end
	local function v150()
		if (((3207 - (815 + 160)) <= (11138 - 8542)) and not v95) then
			v147();
		end
		if (((4973 - 2878) < (880 + 2806)) and v35 and v87 and v89.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (116 - 76)))) then
			if (v24(v89.TimeWarp, not v15:IsInRange(1938 - (41 + 1857))) or ((3488 - (1222 + 671)) >= (11563 - 7089))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v75 < v123) or ((6638 - 2019) < (4064 - (229 + 953)))) then
			if ((v82 and ((v35 and v83) or not v83)) or ((2068 - (1111 + 663)) >= (6410 - (874 + 705)))) then
				v32 = v140();
				if (((285 + 1744) <= (2105 + 979)) and v32) then
					return v32;
				end
			end
		end
		v111 = v109 > v89.ShiftingPower:CooldownRemains();
		v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v28(v111))) / v89.FireBlast:Cooldown())) - (1 - 0)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((1 + 11) / v89.FireBlast:Cooldown()) % (680 - (642 + 37))))) and (v109 < v123);
		if ((not v95 and ((v109 <= (0 + 0)) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) or ((326 + 1711) == (6076 - 3656))) then
			v32 = v146();
			if (((4912 - (233 + 221)) > (9027 - 5123)) and v32) then
				return v32;
			end
		end
		if (((384 + 52) >= (1664 - (718 + 823))) and not v113 and v89.SunKingsBlessing:IsAvailable()) then
			v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((2 + 1) * v124));
		end
		if (((1305 - (266 + 539)) < (5141 - 3325)) and v89.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v123) and v119 and ((v89.FireBlast:Charges() == (1225 - (636 + 589))) or v113) and (not v135() or ((v15:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v14:BuffDown(v89.FuryoftheSunKingBuff))) and v14:BuffDown(v89.HotStreakBuff) and v111) then
			if (((8483 - 4909) == (7371 - 3797)) and v24(v89.ShiftingPower, not v15:IsInRange(32 + 8), true)) then
				return "shifting_power main 12";
			end
		end
		if (((81 + 140) < (1405 - (657 + 358))) and (v125 < v99)) then
			v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (18 - 11)) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v28(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
		end
		if ((v125 >= v99) or ((5041 - 2828) <= (2608 - (1151 + 36)))) then
			v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v28(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
		end
		if (((2954 + 104) < (1278 + 3582)) and v89.FireBlast:IsReady() and v40 and not v137() and not v113 and (v109 > (0 - 0)) and (v125 >= v98) and not v132() and v14:BuffDown(v89.HotStreakBuff) and ((v14:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (1832.5 - (1552 + 280)))) or (v89.FireBlast:ChargesFractional() >= (836 - (64 + 770))))) then
			if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((880 + 416) >= (10092 - 5646))) then
				return "fire_blast main 14";
			end
		end
		if ((v119 and v132() and (v109 > (0 + 0))) or ((2636 - (157 + 1086)) > (8984 - 4495))) then
			v32 = v148();
			if (v32 or ((19375 - 14951) < (41 - 14))) then
				return v32;
			end
		end
		if ((v89.FireBlast:IsReady() and v40 and not v137() and v14:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) or ((2725 - 728) > (4634 - (599 + 220)))) then
			if (((6899 - 3434) > (3844 - (1813 + 118))) and v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast main 16";
			end
		end
		if (((536 + 197) < (3036 - (841 + 376))) and (v109 > (0 - 0)) and v119) then
			local v216 = 0 + 0;
			while true do
				if (((0 - 0) == v216) or ((5254 - (464 + 395)) == (12203 - 7448))) then
					v32 = v149();
					if (v32 or ((1822 + 1971) < (3206 - (467 + 370)))) then
						return v32;
					end
					break;
				end
			end
		end
		if ((v89.IceNova:IsCastable() and not v134()) or ((8439 - 4355) == (195 + 70))) then
			if (((14939 - 10581) == (680 + 3678)) and v24(v89.IceNova, not v15:IsSpellInRange(v89.IceNova))) then
				return "ice_nova main 18";
			end
		end
		if ((v89.Scorch:IsReady() and v47) or ((7300 - 4162) < (1513 - (150 + 370)))) then
			if (((4612 - (74 + 1208)) > (5713 - 3390)) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
				return "scorch main 20";
			end
		end
	end
	local function v151()
		v37 = EpicSettings.Settings['useArcaneExplosion'];
		v38 = EpicSettings.Settings['useArcaneIntellect'];
		v39 = EpicSettings.Settings['useDragonsBreath'];
		v40 = EpicSettings.Settings['useFireBlast'];
		v41 = EpicSettings.Settings['useFireball'];
		v42 = EpicSettings.Settings['useFlamestrike'];
		v43 = EpicSettings.Settings['useLivingBomb'];
		v44 = EpicSettings.Settings['useMeteor'];
		v45 = EpicSettings.Settings['usePhoenixFlames'];
		v46 = EpicSettings.Settings['usePyroblast'];
		v47 = EpicSettings.Settings['useScorch'];
		v48 = EpicSettings.Settings['useCounterspell'];
		v49 = EpicSettings.Settings['useBlastWave'];
		v50 = EpicSettings.Settings['useCombustion'];
		v51 = EpicSettings.Settings['useShiftingPower'];
		v52 = EpicSettings.Settings['combustionWithCD'];
		v53 = EpicSettings.Settings['shiftingPowerWithCD'];
		v54 = EpicSettings.Settings['useAlterTime'];
		v55 = EpicSettings.Settings['useBlazingBarrier'];
		v56 = EpicSettings.Settings['useGreaterInvisibility'];
		v57 = EpicSettings.Settings['useIceBlock'];
		v58 = EpicSettings.Settings['useIceCold'];
		v60 = EpicSettings.Settings['useMassBarrier'];
		v59 = EpicSettings.Settings['useMirrorImage'];
		v61 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
		v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (390 - (14 + 376));
		v64 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v65 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v66 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v67 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v152()
		v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v72 = EpicSettings.Settings['InterruptWithStun'];
		v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v74 = EpicSettings.Settings['InterruptThreshold'];
		v69 = EpicSettings.Settings['DispelDebuffs'];
		v68 = EpicSettings.Settings['DispelBuffs'];
		v82 = EpicSettings.Settings['useTrinkets'];
		v81 = EpicSettings.Settings['useRacials'];
		v83 = EpicSettings.Settings['trinketsWithCD'];
		v84 = EpicSettings.Settings['racialsWithCD'];
		v77 = EpicSettings.Settings['useHealthstone'];
		v76 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v78 = EpicSettings.Settings['healingPotionHP'] or (78 - (23 + 55));
		v80 = EpicSettings.Settings['HealingPotionName'] or "";
		v70 = EpicSettings.Settings['handleAfflicted'];
		v71 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v153()
		local v210 = 0 - 0;
		while true do
			if ((v210 == (0 + 0)) or ((3257 + 369) == (6184 - 2195))) then
				v151();
				v152();
				v33 = EpicSettings.Toggles['ooc'];
				v34 = EpicSettings.Toggles['aoe'];
				v210 = 1 + 0;
			end
			if (((902 - (652 + 249)) == v210) or ((2451 - 1535) == (4539 - (708 + 1160)))) then
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				if (((738 - 466) == (495 - 223)) and v14:IsDeadOrGhost()) then
					return v32;
				end
				v130 = v15:GetEnemiesInSplashRange(32 - (10 + 17));
				v210 = 1 + 1;
			end
			if (((5981 - (1400 + 332)) <= (9281 - 4442)) and ((1911 - (242 + 1666)) == v210)) then
				if (((1189 + 1588) < (1173 + 2027)) and v14:AffectingCombat() and v93.TargetIsValid()) then
					if (((81 + 14) < (2897 - (850 + 90))) and v69 and v36 and v89.RemoveCurse:IsAvailable()) then
						if (((1446 - 620) < (3107 - (360 + 1030))) and v16) then
							v32 = v141();
							if (((1262 + 164) >= (3118 - 2013)) and v32) then
								return v32;
							end
						end
						if (((3788 - 1034) <= (5040 - (909 + 752))) and v18 and v18:Exists() and v18:IsAPlayer() and v93.UnitHasCurseDebuff(v18)) then
							if (v89.RemoveCurse:IsReady() or ((5150 - (109 + 1114)) == (2586 - 1173))) then
								if (v24(v91.RemoveCurseMouseover) or ((450 + 704) <= (1030 - (6 + 236)))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					v32 = v142();
					if (v32 or ((1036 + 607) > (2720 + 659))) then
						return v32;
					end
					if (v70 or ((6610 - 3807) > (7945 - 3396))) then
						if (v88 or ((1353 - (1076 + 57)) >= (497 + 2525))) then
							local v227 = 689 - (579 + 110);
							while true do
								if (((223 + 2599) == (2496 + 326)) and ((0 + 0) == v227)) then
									v32 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 437 - (174 + 233));
									if (v32 or ((2963 - 1902) == (3259 - 1402))) then
										return v32;
									end
									break;
								end
							end
						end
					end
					if (((1228 + 1532) > (2538 - (663 + 511))) and v71) then
						v32 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseOver, 27 + 3, true);
						if (v32 or ((1065 + 3837) <= (11083 - 7488))) then
							return v32;
						end
					end
					if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v93.UnitHasMagicBuff(v15)) or ((2333 + 1519) == (689 - 396))) then
						if (v24(v89.Spellsteal, not v15:IsSpellInRange(v89.Spellsteal)) or ((3773 - 2214) == (2190 + 2398))) then
							return "spellsteal damage";
						end
					end
					if (((v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v89.HotStreakBuff)) or ((8727 - 4243) == (562 + 226))) then
						if (((418 + 4150) >= (4629 - (478 + 244))) and v24(v91.StopCasting, not v15:IsSpellInRange(v89.Pyroblast))) then
							return "Stop Casting";
						end
					end
					v32 = v150();
					if (((1763 - (440 + 77)) < (1578 + 1892)) and v32) then
						return v32;
					end
				end
				break;
			end
			if (((14889 - 10821) >= (2528 - (655 + 901))) and ((1 + 1) == v210)) then
				v129 = v14:GetEnemiesInRange(31 + 9);
				if (((333 + 160) < (15683 - 11790)) and v34) then
					v125 = v30(v15:GetEnemiesInSplashRangeCount(1450 - (695 + 750)), #v129);
					v126 = v30(v15:GetEnemiesInSplashRangeCount(16 - 11), #v129);
					v127 = v30(v15:GetEnemiesInSplashRangeCount(7 - 2), #v129);
					v128 = #v129;
				else
					v125 = 3 - 2;
					v126 = 352 - (285 + 66);
					v127 = 2 - 1;
					v128 = 1311 - (682 + 628);
				end
				if (v93.TargetIsValid() or v14:AffectingCombat() or ((238 + 1235) >= (3631 - (176 + 123)))) then
					local v224 = 0 + 0;
					while true do
						if ((v224 == (2 + 0)) or ((4320 - (239 + 30)) <= (315 + 842))) then
							v131 = v138(v129);
							v95 = not v35;
							v224 = 3 + 0;
						end
						if (((1068 - 464) < (8988 - 6107)) and (v224 == (319 - (306 + 9)))) then
							v118 = v14:BuffUp(v89.CombustionBuff);
							v119 = not v118;
							break;
						end
						if ((v224 == (10 - 7)) or ((157 + 743) == (2072 + 1305))) then
							if (((2147 + 2312) > (1689 - 1098)) and v95) then
								v109 = 101374 - (1140 + 235);
							end
							v124 = v14:GCD();
							v224 = 3 + 1;
						end
						if (((3117 + 281) >= (615 + 1780)) and (v224 == (53 - (33 + 19)))) then
							v123 = v122;
							if ((v123 == (4012 + 7099)) or ((6542 - 4359) >= (1245 + 1579))) then
								v123 = v10.FightRemains(v129, false);
							end
							v224 = 3 - 1;
						end
						if (((1816 + 120) == (2625 - (586 + 103))) and ((0 + 0) == v224)) then
							if (v14:AffectingCombat() or v69 or ((14875 - 10043) < (5801 - (1309 + 179)))) then
								local v228 = v69 and v89.RemoveCurse:IsReady() and v36;
								v32 = v93.FocusUnit(v228, v91, 36 - 16, nil, 9 + 11);
								if (((10978 - 6890) > (2927 + 947)) and v32) then
									return v32;
								end
							end
							v122 = v10.BossFightRemains(nil, true);
							v224 = 1 - 0;
						end
					end
				end
				if (((8631 - 4299) == (4941 - (295 + 314))) and not v14:AffectingCombat() and v33) then
					local v225 = 0 - 0;
					while true do
						if (((5961 - (1300 + 662)) >= (9106 - 6206)) and (v225 == (1755 - (1178 + 577)))) then
							v32 = v143();
							if (v32 or ((1312 + 1213) > (12014 - 7950))) then
								return v32;
							end
							break;
						end
					end
				end
				v210 = 1408 - (851 + 554);
			end
		end
	end
	local function v154()
		v94();
		v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(56 + 7, v153, v154);
end;
return v0["Epix_Mage_Fire.lua"]();

