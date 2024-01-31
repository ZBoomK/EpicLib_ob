local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((772 - 574) <= (3271 + 1094)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Fire.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.Pet;
	local v17 = v11.Mouseover;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.PressCursor;
	local v25 = v21.Macro;
	local v26 = v21.Bind;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = math.ceil;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v88 = v18.Mage.Fire;
	local v89 = v20.Mage.Fire;
	local v90 = v25.Mage.Fire;
	local v91 = {};
	local v92 = v21.Commons.Everyone;
	local function v93()
		if (((11161 - 6379) > (5387 - (530 + 181))) and v88.RemoveCurse:IsAvailable()) then
			v92.DispellableDebuffs = v92.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v93();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v94 = not v34;
	local v95 = v88.SunKingsBlessing:IsAvailable();
	local v96 = ((v88.FlamePatch:IsAvailable()) and (885 - (614 + 267))) or (1031 - (19 + 13));
	local v97 = 1625 - 626;
	local v98 = v96;
	local v99 = ((6 - 3) * v27(v88.FueltheFire:IsAvailable())) + ((2853 - 1854) * v27(not v88.FueltheFire:IsAvailable()));
	local v100 = 260 + 739;
	local v101 = 70 - 30;
	local v102 = 2071 - 1072;
	local v103 = 1812.3 - (1293 + 519);
	local v104 = 0 - 0;
	local v105 = 15 - 9;
	local v106 = false;
	local v107 = (v106 and (38 - 18)) or (0 - 0);
	local v108;
	local v109 = ((v88.Kindling:IsAvailable()) and (0.4 - 0)) or (1 + 0);
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = 0 + 0;
	local v114 = 0 - 0;
	local v115 = 2 + 6;
	local v116 = 1 + 2;
	local v117;
	local v118;
	local v119;
	local v120 = 2 + 1;
	local v121 = 12207 - (709 + 387);
	local v122 = 12969 - (673 + 1185);
	local v123;
	local v124, v125, v126;
	local v127;
	local v128;
	local v129;
	local v130;
	v9:RegisterForEvent(function()
		v106 = false;
		v107 = (v106 and (58 - 38)) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v88.Pyroblast:RegisterInFlight();
		v88.Fireball:RegisterInFlight();
		v88.Meteor:RegisterInFlightEffect(577744 - 226604);
		v88.Meteor:RegisterInFlight();
		v88.PhoenixFlames:RegisterInFlightEffect(184209 + 73333);
		v88.PhoenixFlames:RegisterInFlight();
		v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
		v88.Fireball:RegisterInFlight(v88.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v88.Pyroblast:RegisterInFlight();
	v88.Fireball:RegisterInFlight();
	v88.Meteor:RegisterInFlightEffect(262372 + 88768);
	v88.Meteor:RegisterInFlight();
	v88.PhoenixFlames:RegisterInFlightEffect(347722 - 90180);
	v88.PhoenixFlames:RegisterInFlight();
	v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
	v88.Fireball:RegisterInFlight(v88.CombustionBuff);
	v9:RegisterForEvent(function()
		local v155 = 0 + 0;
		while true do
			if (((9698 - 4834) > (4312 - 2115)) and (v155 == (1880 - (446 + 1434)))) then
				v121 = 12394 - (1040 + 243);
				v122 = 33162 - 22051;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v156 = 1847 - (559 + 1288);
		while true do
			if ((v156 == (1932 - (609 + 1322))) or ((4154 - (13 + 441)) == (9368 - 6861))) then
				v98 = v96;
				v109 = ((v88.Kindling:IsAvailable()) and (0.4 - 0)) or (4 - 3);
				break;
			end
			if (((167 + 4307) >= (995 - 721)) and (v156 == (0 + 0))) then
				v95 = v88.SunKingsBlessing:IsAvailable();
				v96 = ((v88.FlamePatch:IsAvailable()) and (2 + 1)) or (2964 - 1965);
				v156 = 1 + 0;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v131()
		return v88.Firestarter:IsAvailable() and (v14:HealthPercentage() > (165 - 75));
	end
	local function v132()
		return (v88.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (60 + 30)) and v14:TimeToX(51 + 39)) or (0 + 0))) or (0 + 0);
	end
	local function v133()
		return v88.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (30 + 0));
	end
	local function v134()
		return v88.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (463 - (153 + 280)));
	end
	local function v135()
		return (v120 * v88.ShiftingPower:BaseDuration()) / v88.ShiftingPower:BaseTickTime();
	end
	local function v136()
		local v157 = 0 - 0;
		local v158;
		while true do
			if ((v157 == (1 + 0)) or ((748 + 1146) <= (736 + 670))) then
				return v13:BuffUp(v88.HotStreakBuff) or v13:BuffUp(v88.HyperthermiaBuff) or (v13:BuffUp(v88.HeatingUpBuff) and ((v134() and v13:IsCasting(v88.Scorch)) or (v131() and (v13:IsCasting(v88.Fireball) or v13:IsCasting(v88.Pyroblast) or (v158 > (0 + 0))))));
			end
			if (((1140 + 432) >= (2330 - 799)) and (v157 == (0 + 0))) then
				v158 = (v131() and (v27(v88.Pyroblast:InFlight()) + v27(v88.Fireball:InFlight()))) or (667 - (89 + 578));
				v158 = v158 + v27(v88.PhoenixFlames:InFlight() or v13:PrevGCDP(1 + 0, v88.PhoenixFlames));
				v157 = 1 - 0;
			end
		end
	end
	local function v137(v159)
		local v160 = 1049 - (572 + 477);
		local v161;
		while true do
			if ((v160 == (0 + 0)) or ((2813 + 1874) < (543 + 3999))) then
				v161 = 86 - (84 + 2);
				for v221, v222 in pairs(v159) do
					if (((5423 - 2132) > (1201 + 466)) and v222:DebuffUp(v88.IgniteDebuff)) then
						v161 = v161 + (843 - (497 + 345));
					end
				end
				v160 = 1 + 0;
			end
			if ((v160 == (1 + 0)) or ((2206 - (605 + 728)) == (1452 + 582))) then
				return v161;
			end
		end
	end
	local function v138()
		local v162 = 0 - 0;
		if (v88.Fireball:InFlight() or v88.PhoenixFlames:InFlight() or ((130 + 2686) < (40 - 29))) then
			v162 = v162 + 1 + 0;
		end
		return v162;
	end
	local function v139()
		v31 = v92.HandleTopTrinket(v91, v34, 110 - 70, nil);
		if (((2793 + 906) < (5195 - (457 + 32))) and v31) then
			return v31;
		end
		v31 = v92.HandleBottomTrinket(v91, v34, 17 + 23, nil);
		if (((4048 - (832 + 570)) >= (826 + 50)) and v31) then
			return v31;
		end
	end
	local v140 = 0 + 0;
	local function v141()
		if (((2172 - 1558) <= (1534 + 1650)) and v88.RemoveCurse:IsReady() and v92.DispellableFriendlyUnit(816 - (588 + 208))) then
			local v202 = 0 - 0;
			while true do
				if (((4926 - (884 + 916)) == (6544 - 3418)) and (v202 == (0 + 0))) then
					if ((v140 == (653 - (232 + 421))) or ((4076 - (1569 + 320)) >= (1216 + 3738))) then
						v140 = GetTime();
					end
					if (v92.Wait(95 + 405, v140) or ((13064 - 9187) == (4180 - (316 + 289)))) then
						local v229 = 0 - 0;
						while true do
							if (((33 + 674) > (2085 - (666 + 787))) and (v229 == (425 - (360 + 65)))) then
								if (v23(v90.RemoveCurseFocus) or ((511 + 35) >= (2938 - (79 + 175)))) then
									return "remove_curse dispel";
								end
								v140 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v142()
		local v163 = 0 + 0;
		while true do
			if (((4490 - 3025) <= (8282 - 3981)) and ((900 - (503 + 396)) == v163)) then
				if (((1885 - (92 + 89)) > (2764 - 1339)) and v88.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) then
					if (v23(v88.IceBlock) or ((353 + 334) == (2506 + 1728))) then
						return "ice_block defensive 3";
					end
				end
				if ((v88.IceColdTalent:IsAvailable() and v88.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) or ((13040 - 9710) < (196 + 1233))) then
					if (((2615 - 1468) >= (293 + 42)) and v23(v88.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v163 = 1 + 1;
			end
			if (((10461 - 7026) > (262 + 1835)) and (v163 == (4 - 1))) then
				if ((v88.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) or ((5014 - (485 + 759)) >= (9350 - 5309))) then
					if (v23(v88.AlterTime) or ((4980 - (442 + 747)) <= (2746 - (832 + 303)))) then
						return "alter_time defensive 6";
					end
				end
				if ((v89.Healthstone:IsReady() and v76 and (v13:HealthPercentage() <= v78)) or ((5524 - (88 + 858)) <= (612 + 1396))) then
					if (((932 + 193) <= (86 + 1990)) and v23(v90.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v163 = 793 - (766 + 23);
			end
			if (((9 - 7) == v163) or ((1015 - 272) >= (11589 - 7190))) then
				if (((3920 - 2765) < (2746 - (1036 + 37))) and v88.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) then
					if (v23(v88.MirrorImage) or ((1648 + 676) <= (1125 - 547))) then
						return "mirror_image defensive 4";
					end
				end
				if (((2964 + 803) == (5247 - (641 + 839))) and v88.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
					if (((5002 - (910 + 3)) == (10423 - 6334)) and v23(v88.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v163 = 1687 - (1466 + 218);
			end
			if (((2049 + 2409) >= (2822 - (556 + 592))) and (v163 == (0 + 0))) then
				if (((1780 - (329 + 479)) <= (2272 - (174 + 680))) and v88.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v88.BlazingBarrier) and (v13:HealthPercentage() <= v61)) then
					if (v23(v88.BlazingBarrier) or ((16967 - 12029) < (9869 - 5107))) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v88.MassBarrier:IsCastable() and v59 and v13:BuffDown(v88.BlazingBarrier) and v92.AreUnitsBelowHealthPercentage(v66, 2 + 0)) or ((3243 - (396 + 343)) > (378 + 3886))) then
					if (((3630 - (29 + 1448)) == (3542 - (135 + 1254))) and v23(v88.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v163 = 3 - 2;
			end
			if ((v163 == (18 - 14)) or ((338 + 169) >= (4118 - (389 + 1138)))) then
				if (((5055 - (102 + 472)) == (4229 + 252)) and v75 and (v13:HealthPercentage() <= v77)) then
					local v223 = 0 + 0;
					while true do
						if (((0 + 0) == v223) or ((3873 - (320 + 1225)) < (1233 - 540))) then
							if (((2649 + 1679) == (5792 - (157 + 1307))) and (v79 == "Refreshing Healing Potion")) then
								if (((3447 - (821 + 1038)) >= (3323 - 1991)) and v89.RefreshingHealingPotion:IsReady()) then
									if (v23(v90.RefreshingHealingPotion) or ((457 + 3717) > (7545 - 3297))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v79 == "Dreamwalker's Healing Potion") or ((1707 + 2879) <= (202 - 120))) then
								if (((4889 - (834 + 192)) == (246 + 3617)) and v89.DreamwalkersHealingPotion:IsReady()) then
									if (v23(v90.RefreshingHealingPotion) or ((73 + 209) <= (1 + 41))) then
										return "dreamwalkers healing potion defensive";
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
	local function v143()
		if (((7139 - 2530) >= (1070 - (300 + 4))) and v88.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v88.ArcaneIntellect, true) or v92.GroupBuffMissing(v88.ArcaneIntellect))) then
			if (v23(v88.ArcaneIntellect) or ((308 + 844) == (6512 - 4024))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((3784 - (112 + 250)) > (1336 + 2014)) and v88.MirrorImage:IsCastable() and v92.TargetIsValid() and v58 and v84) then
			if (((2196 - 1319) > (216 + 160)) and v23(v88.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast)) or ((1613 + 1505) <= (1385 + 466))) then
			if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true) or ((82 + 83) >= (2595 + 897))) then
				return "pyroblast precombat 4";
			end
		end
		if (((5363 - (1001 + 413)) < (10828 - 5972)) and v88.Fireball:IsReady() and v40) then
			if (v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball), true) or ((5158 - (244 + 638)) < (3709 - (627 + 66)))) then
				return "fireball precombat 6";
			end
		end
	end
	local function v144()
		local v164 = 0 - 0;
		while true do
			if (((5292 - (512 + 90)) > (6031 - (1665 + 241))) and (v164 == (717 - (373 + 344)))) then
				if ((v88.LivingBomb:IsReady() and v42 and (v125 > (1 + 0)) and v118 and ((v108 > v88.LivingBomb:CooldownRemains()) or (v108 <= (0 + 0)))) or ((131 - 81) >= (1515 - 619))) then
					if (v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb)) or ((2813 - (35 + 1064)) >= (2153 + 805))) then
						return "living_bomb active_talents 2";
					end
				end
				if ((v88.Meteor:IsReady() and v43 and (v74 < v122) and ((v108 <= (0 - 0)) or (v13:BuffRemains(v88.CombustionBuff) > v88.Meteor:TravelTime()) or (not v88.SunKingsBlessing:IsAvailable() and (((1 + 44) < v108) or (v122 < v108))))) or ((2727 - (298 + 938)) < (1903 - (233 + 1026)))) then
					if (((2370 - (636 + 1030)) < (505 + 482)) and v23(v90.MeteorCursor, not v14:IsInRange(40 + 0))) then
						return "meteor active_talents 4";
					end
				end
				v164 = 1 + 0;
			end
			if (((252 + 3466) > (2127 - (55 + 166))) and (v164 == (1 + 0))) then
				if ((v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v13:BuffDown(v88.HotStreakBuff) and (v13:BuffUp(v88.FeeltheBurnBuff) or (v9.CombatTime() > (2 + 13))) and not v134() and (v132() == (0 - 0)) and not v88.TemperedFlames:IsAvailable()) or ((1255 - (36 + 261)) > (6356 - 2721))) then
					if (((4869 - (34 + 1334)) <= (1727 + 2765)) and v23(v88.DragonsBreath, not v14:IsInRange(8 + 2))) then
						return "dragons_breath active_talents 6";
					end
				end
				if ((v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v13:BuffDown(v88.HotStreakBuff) and (v13:BuffUp(v88.FeeltheBurnBuff) or (v9.CombatTime() > (1298 - (1035 + 248)))) and not v134() and v88.TemperedFlames:IsAvailable()) or ((3463 - (20 + 1)) < (1328 + 1220))) then
					if (((3194 - (134 + 185)) >= (2597 - (549 + 584))) and v23(v88.DragonsBreath, not v14:IsInRange(695 - (314 + 371)))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v165 = v92.HandleDPSPotion(v13:BuffUp(v88.CombustionBuff));
		if (v165 or ((16467 - 11670) >= (5861 - (478 + 490)))) then
			return v165;
		end
		if ((v80 and ((v83 and v34) or not v83) and (v74 < v122)) or ((292 + 259) > (3240 - (786 + 386)))) then
			local v203 = 0 - 0;
			while true do
				if (((3493 - (1055 + 324)) > (2284 - (1093 + 247))) and (v203 == (0 + 0))) then
					if (v88.BloodFury:IsCastable() or ((238 + 2024) >= (12291 - 9195))) then
						if (v23(v88.BloodFury) or ((7652 - 5397) >= (10064 - 6527))) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if ((v88.Berserking:IsCastable() and v117) or ((9641 - 5804) < (465 + 841))) then
						if (((11364 - 8414) == (10168 - 7218)) and v23(v88.Berserking)) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v203 = 1 + 0;
				end
				if ((v203 == (2 - 1)) or ((5411 - (364 + 324)) < (9040 - 5742))) then
					if (((2725 - 1589) >= (52 + 102)) and v88.Fireblood:IsCastable()) then
						if (v23(v88.Fireblood) or ((1133 - 862) > (7603 - 2855))) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((14395 - 9655) >= (4420 - (1249 + 19))) and v88.AncestralCall:IsCastable()) then
						if (v23(v88.AncestralCall) or ((2327 + 251) >= (13195 - 9805))) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
			end
		end
		if (((1127 - (686 + 400)) <= (1304 + 357)) and v86 and v88.TimeWarp:IsReady() and v88.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) then
			if (((830 - (73 + 156)) < (17 + 3543)) and v23(v88.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if (((1046 - (721 + 90)) < (8 + 679)) and (v74 < v122)) then
			if (((14769 - 10220) > (1623 - (224 + 246))) and v81 and ((v34 and v82) or not v82)) then
				v31 = v139();
				if (v31 or ((7571 - 2897) < (8601 - 3929))) then
					return v31;
				end
			end
		end
	end
	local function v146()
		local v166 = 0 + 0;
		while true do
			if (((88 + 3580) < (3350 + 1211)) and (v166 == (0 - 0))) then
				if ((v88.LightsJudgment:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) or ((1514 - 1059) == (4118 - (203 + 310)))) then
					if (v23(v88.LightsJudgment, not v14:IsSpellInRange(v88.LightsJudgment)) or ((4656 - (1238 + 755)) == (232 + 3080))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((5811 - (709 + 825)) <= (8245 - 3770)) and v88.BagofTricks:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) then
					if (v23(v88.BagofTricks) or ((1267 - 397) == (2053 - (196 + 668)))) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if (((6131 - 4578) <= (6489 - 3356)) and v88.LivingBomb:IsReady() and v33 and v42 and (v125 > (834 - (171 + 662))) and v118) then
					if (v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb)) or ((2330 - (4 + 89)) >= (12305 - 8794))) then
						return "living_bomb combustion_phase 6";
					end
				end
				v166 = 1 + 0;
			end
			if ((v166 == (35 - 27)) or ((520 + 804) > (4506 - (35 + 1451)))) then
				if ((v88.Scorch:IsReady() and v46 and (v13:BuffRemains(v88.CombustionBuff) > v88.Scorch:CastTime()) and (v88.Scorch:CastTime() >= v123)) or ((4445 - (28 + 1425)) == (3874 - (941 + 1052)))) then
					if (((2979 + 127) > (3040 - (822 + 692))) and v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((4314 - 1291) < (1823 + 2047)) and v88.Fireball:IsReady() and v40 and (v13:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime())) then
					if (((440 - (45 + 252)) > (74 + 0)) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((7 + 11) < (5139 - 3027)) and v88.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v88.CombustionBuff) < v123) and (v125 > (434 - (114 + 319)))) then
					if (((1574 - 477) <= (2085 - 457)) and v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if (((2952 + 1678) == (6898 - 2268)) and (v166 == (14 - 7))) then
				if (((5503 - (556 + 1407)) > (3889 - (741 + 465))) and v88.PhoenixFlames:IsCastable() and v44 and v13:HasTier(495 - (170 + 295), 2 + 0) and (v88.PhoenixFlames:TravelTime() < v13:BuffRemains(v88.CombustionBuff)) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) < (2 + 0)) and ((v14:DebuffRemains(v88.CharringEmbersDebuff) < ((9 - 5) * v123)) or (v13:BuffStack(v88.FlamesFuryBuff) > (1 + 0)) or v13:BuffUp(v88.FlamesFuryBuff))) then
					if (((3075 + 1719) >= (1855 + 1420)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((2714 - (957 + 273)) == (397 + 1087)) and v88.Fireball:IsReady() and v40 and (v13:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime()) and v13:BuffUp(v88.FlameAccelerantBuff)) then
					if (((574 + 858) < (13546 - 9991)) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball))) then
						return "fireball combustion_phase 40";
					end
				end
				if ((v88.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(79 - 49, 5 - 3) and not v88.AlexstraszasFury:IsAvailable() and (v88.PhoenixFlames:TravelTime() < v13:BuffRemains(v88.CombustionBuff)) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) < (9 - 7))) or ((2845 - (389 + 1391)) > (2245 + 1333))) then
					if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((500 + 4295) < (3202 - 1795))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v166 = 959 - (783 + 168);
			end
			if (((6218 - 4365) < (4735 + 78)) and (v166 == (317 - (309 + 2)))) then
				if ((v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v124 >= v99)) or ((8662 - 5841) < (3643 - (1090 + 122)))) then
					if (v23(v90.FlamestrikeCursor, not v14:IsInRange(13 + 27)) or ((9652 - 6778) < (1493 + 688))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) or ((3807 - (628 + 490)) <= (62 + 281))) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast)) or ((4627 - 2758) == (9181 - 7172))) then
						return "pyroblast combustion_phase 34";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < ((778 - (431 + 343)) * v123)) and (v126 < v98)) or ((7161 - 3615) < (6717 - 4395))) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((1645 + 437) == (611 + 4162))) then
						return "scorch combustion_phase 36";
					end
				end
				v166 = 1702 - (556 + 1139);
			end
			if (((3259 - (6 + 9)) > (194 + 861)) and (v166 == (1 + 0))) then
				if ((v13:BuffRemains(v88.CombustionBuff) > v105) or (v122 < (189 - (28 + 141))) or ((1284 + 2029) <= (2194 - 416))) then
					v31 = v145();
					if (v31 or ((1007 + 414) >= (3421 - (486 + 831)))) then
						return v31;
					end
				end
				if (((4715 - 2903) <= (11438 - 8189)) and v88.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v88.CombustionBuff) and v13:HasTier(6 + 24, 6 - 4) and not v88.PhoenixFlames:InFlight() and (v14:DebuffRemains(v88.CharringEmbersDebuff) < ((1267 - (668 + 595)) * v123)) and v13:BuffDown(v88.HotStreakBuff)) then
					if (((1461 + 162) <= (395 + 1562)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v144();
				v166 = 5 - 3;
			end
			if (((4702 - (23 + 267)) == (6356 - (1129 + 815))) and (v166 == (391 - (371 + 16)))) then
				if (((3500 - (1326 + 424)) >= (1594 - 752)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (not v134() or v13:IsCasting(v88.Scorch) or (v14:DebuffRemains(v88.ImprovedScorchDebuff) > ((14 - 10) * v123))) and (v13:BuffDown(v88.FuryoftheSunKingBuff) or v13:IsCasting(v88.Pyroblast)) and v117 and v13:BuffDown(v88.HyperthermiaBuff) and v13:BuffDown(v88.HotStreakBuff) and ((v138() + (v27(v13:BuffUp(v88.HeatingUpBuff)) * v27(v13:GCDRemains() > (118 - (88 + 30))))) < (773 - (720 + 51)))) then
					if (((9725 - 5353) > (3626 - (421 + 1355))) and v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((381 - 149) < (404 + 417)) and v33 and v88.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v88.HotStreakBuff) and (v124 >= v98)) or (v13:BuffUp(v88.HyperthermiaBuff) and (v124 >= (v98 - v27(v88.Hyperthermia:IsAvailable())))))) then
					if (((1601 - (286 + 797)) < (3297 - 2395)) and v23(v90.FlamestrikeCursor, not v14:IsInRange(66 - 26))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if (((3433 - (397 + 42)) > (268 + 590)) and v88.Pyroblast:IsReady() and v45 and (v13:BuffUp(v88.HyperthermiaBuff))) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast)) or ((4555 - (24 + 776)) <= (1409 - 494))) then
						return "pyroblast combustion_phase 24";
					end
				end
				v166 = 790 - (222 + 563);
			end
			if (((8694 - 4748) > (2695 + 1048)) and (v166 == (195 - (23 + 167)))) then
				if ((v88.Pyroblast:IsReady() and v45 and v13:BuffUp(v88.HotStreakBuff) and v117) or ((3133 - (690 + 1108)) >= (1193 + 2113))) then
					if (((3996 + 848) > (3101 - (40 + 808))) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast))) then
						return "pyroblast combustion_phase 26";
					end
				end
				if (((75 + 377) == (1728 - 1276)) and v88.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v88.Scorch) and v13:BuffUp(v88.HeatingUpBuff) and (v124 < v98) and v117) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast)) or ((2411 + 2146) < (1145 + 942))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((4445 - (47 + 524)) == (2515 + 1359)) and v88.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v122) and v117 and (v88.FireBlast:Charges() == (0 - 0)) and ((v88.PhoenixFlames:Charges() < v88.PhoenixFlames:MaxCharges()) or v88.AlexstraszasFury:IsAvailable()) and (v102 <= v124)) then
					if (v23(v88.ShiftingPower, not v14:IsInRange(59 - 19)) or ((4419 - 2481) > (6661 - (1165 + 561)))) then
						return "shifting_power combustion_phase 30";
					end
				end
				v166 = 1 + 5;
			end
			if ((v166 == (9 - 6)) or ((1624 + 2631) < (3902 - (341 + 138)))) then
				if (((393 + 1061) <= (5140 - 2649)) and v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and v118 and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast)) or ((4483 - (89 + 237)) <= (9017 - 6214))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((10217 - 5364) >= (3863 - (581 + 300))) and v88.Fireball:IsReady() and v40 and v118 and (v88.Combustion:CooldownRemains() < v88.Fireball:CastTime()) and (v124 < (1222 - (855 + 365))) and not v134()) then
					if (((9819 - 5685) > (1097 + 2260)) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball))) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v118 and (v88.Combustion:CooldownRemains() < v88.Scorch:CastTime())) or ((4652 - (1030 + 205)) < (2379 + 155))) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((2533 + 189) <= (450 - (156 + 130)))) then
						return "scorch combustion_phase 18";
					end
				end
				v166 = 8 - 4;
			end
			if ((v166 == (2 - 0)) or ((4931 - 2523) < (556 + 1553))) then
				if (v31 or ((20 + 13) == (1524 - (10 + 59)))) then
					return v31;
				end
				if ((v88.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v122) and (v138() == (0 + 0)) and v118 and (v108 <= (0 - 0)) and ((v13:IsCasting(v88.Scorch) and (v88.Scorch:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Fireball) and (v88.Fireball:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Pyroblast) and (v88.Pyroblast:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Flamestrike) and (v88.Flamestrike:ExecuteRemains() < v103)) or (v88.Meteor:InFlight() and (v88.Meteor:InFlightRemains() < v103)))) or ((1606 - (671 + 492)) >= (3197 + 818))) then
					if (((4597 - (369 + 846)) > (44 + 122)) and v23(v88.Combustion, not v14:IsInRange(35 + 5), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				if ((v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and v118 and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v88.Combustion:CooldownRemains() < v88.Flamestrike:CastTime()) and (v124 >= v99)) or ((2225 - (1036 + 909)) == (2433 + 626))) then
					if (((3157 - 1276) > (1496 - (11 + 192))) and v23(v90.FlamestrikeCursor, not v14:IsInRange(21 + 19))) then
						return "flamestrike combustion_phase 12";
					end
				end
				v166 = 178 - (135 + 40);
			end
		end
	end
	local function v147()
		v113 = v88.Combustion:CooldownRemains() * v109;
		v114 = ((v88.Fireball:CastTime() * v27(v124 < v98)) + (v88.Flamestrike:CastTime() * v27(v124 >= v98))) - v103;
		v108 = v113;
		if (((5710 - 3353) == (1421 + 936)) and v88.Firestarter:IsAvailable() and not v95) then
			v108 = v29(v132(), v108);
		end
		if (((270 - 147) == (184 - 61)) and v88.SunKingsBlessing:IsAvailable() and v131() and v13:BuffDown(v88.FuryoftheSunKingBuff)) then
			v108 = v29((v115 - v13:BuffStack(v88.SunKingsBlessingBuff)) * (179 - (50 + 126)) * v123, v108);
		end
		v108 = v29(v13:BuffRemains(v88.CombustionBuff), v108);
		if (((v113 + ((334 - 214) * ((1 + 0) - (((1413.4 - (1233 + 180)) + ((969.2 - (522 + 447)) * v27(v88.Firestarter:IsAvailable()))) * v27(v88.Kindling:IsAvailable()))))) <= v108) or (v108 > (v122 - (1441 - (107 + 1314)))) or ((491 + 565) >= (10335 - 6943))) then
			v108 = v113;
		end
	end
	local function v148()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (0 - 0)) or ((4277 - 3196) < (2985 - (716 + 1194)))) then
				if ((v88.FireBlast:IsReady() and v39 and not v136() and not v112 and v13:BuffDown(v88.HotStreakBuff) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) == (1 + 0)) and (v88.ShiftingPower:CooldownUp() or (v88.FireBlast:Charges() > (1 + 0)) or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((505 - (74 + 429)) * v123)))) or ((2022 - 973) >= (2197 + 2235))) then
					if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((10914 - 6146) <= (599 + 247))) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if ((v88.FireBlast:IsReady() and v39 and not v136() and not v112 and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) == (2 - 1)) and v88.ShiftingPower:CooldownUp() and (not v13:HasTier(74 - 44, 435 - (279 + 154)) or (v14:DebuffRemains(v88.CharringEmbersDebuff) > ((780 - (454 + 324)) * v123)))) or ((2642 + 716) <= (1437 - (12 + 5)))) then
					if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((2016 + 1723) <= (7656 - 4651))) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v149()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (1096 - (277 + 816))) or ((7088 - 5429) >= (3317 - (1058 + 125)))) then
				if ((v88.PhoenixFlames:IsCastable() and v44 and v13:HasTier(6 + 24, 977 - (815 + 160)) and (v14:DebuffRemains(v88.CharringEmbersDebuff) < ((8 - 6) * v123)) and v13:BuffDown(v88.HotStreakBuff)) or ((7738 - 4478) < (562 + 1793))) then
					if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((1955 - 1286) == (6121 - (41 + 1857)))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffStack(v88.ImprovedScorchDebuff) < v116)) or ((3585 - (1222 + 671)) < (1519 - 931))) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((6895 - 2098) < (4833 - (229 + 953)))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v88.PhoenixFlames:IsCastable() and v44 and not v88.AlexstraszasFury:IsAvailable() and v13:BuffDown(v88.HotStreakBuff) and not v111 and v13:BuffUp(v88.FlamesFuryBuff)) or ((5951 - (1111 + 663)) > (6429 - (874 + 705)))) then
					if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((56 + 344) > (759 + 352))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v168 = 7 - 3;
			end
			if (((86 + 2965) > (1684 - (642 + 37))) and (v168 == (0 + 0))) then
				if (((591 + 3102) <= (11002 - 6620)) and v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v96) and v136()) then
					if (v23(v90.FlamestrikeCursor, not v14:IsInRange(494 - (233 + 221))) or ((7588 - 4306) > (3609 + 491))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and (v136())) or ((5121 - (718 + 823)) < (1790 + 1054))) then
					if (((894 - (266 + 539)) < (12712 - 8222)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and (v124 >= v99) and v13:BuffUp(v88.FuryoftheSunKingBuff)) or ((6208 - (636 + 589)) < (4291 - 2483))) then
					if (((7897 - 4068) > (2987 + 782)) and v23(v90.FlamestrikeCursor, not v14:IsInRange(15 + 25))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v168 = 1016 - (657 + 358);
			end
			if (((3931 - 2446) <= (6615 - 3711)) and ((1193 - (1151 + 36)) == v168)) then
				if (((4123 + 146) == (1123 + 3146)) and v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v97)) then
					if (((1155 - 768) <= (4614 - (1552 + 280))) and v23(v90.FlamestrikeCursor, not v14:IsInRange(874 - (64 + 770)))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and v88.TemperedFlames:IsAvailable() and v13:BuffDown(v88.FlameAccelerantBuff)) or ((1290 + 609) <= (2081 - 1164))) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true) or ((766 + 3546) <= (2119 - (157 + 1086)))) then
						return "pyroblast standard_rotation 35";
					end
				end
				if (((4466 - 2234) <= (11369 - 8773)) and v88.Fireball:IsReady() and v40 and not v136()) then
					if (((3213 - 1118) < (5030 - 1344)) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball), true)) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v168 == (820 - (599 + 220))) or ((3175 - 1580) >= (6405 - (1813 + 118)))) then
				if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < (v88.Pyroblast:CastTime() + ((4 + 1) * v123))) and v13:BuffUp(v88.FuryoftheSunKingBuff) and not v13:IsCasting(v88.Scorch)) or ((5836 - (841 + 376)) < (4037 - 1155))) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((69 + 225) >= (13186 - 8355))) then
						return "scorch standard_rotation 13";
					end
				end
				if (((2888 - (464 + 395)) <= (7914 - 4830)) and v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and (v13:BuffUp(v88.FuryoftheSunKingBuff))) then
					if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true) or ((979 + 1058) == (3257 - (467 + 370)))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((9212 - 4754) > (2866 + 1038)) and v88.FireBlast:IsReady() and v39 and not v136() and not v131() and not v112 and v13:BuffDown(v88.FuryoftheSunKingBuff) and ((((v13:IsCasting(v88.Fireball) and ((v88.Fireball:ExecuteRemains() < (0.5 - 0)) or not v88.Hyperthermia:IsAvailable())) or (v13:IsCasting(v88.Pyroblast) and ((v88.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v88.Hyperthermia:IsAvailable()))) and v13:BuffUp(v88.HeatingUpBuff)) or (v133() and (not v134() or (v14:DebuffStack(v88.ImprovedScorchDebuff) == v116) or (v88.FireBlast:FullRechargeTime() < (6 - 3))) and ((v13:BuffUp(v88.HeatingUpBuff) and not v13:IsCasting(v88.Scorch)) or (v13:BuffDown(v88.HotStreakBuff) and v13:BuffDown(v88.HeatingUpBuff) and v13:IsCasting(v88.Scorch) and (v138() == (520 - (150 + 370)))))))) then
					if (((1718 - (74 + 1208)) >= (302 - 179)) and v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				v168 = 9 - 7;
			end
			if (((356 + 144) < (2206 - (14 + 376))) and (v168 == (3 - 1))) then
				if (((2313 + 1261) == (3140 + 434)) and v88.Pyroblast:IsReady() and v45 and (v13:IsCasting(v88.Scorch) or v13:PrevGCDP(1 + 0, v88.Scorch)) and v13:BuffUp(v88.HeatingUpBuff) and v133() and (v124 < v96)) then
					if (((647 - 426) < (294 + 96)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < ((82 - (23 + 55)) * v123))) or ((5244 - 3031) <= (949 + 472))) then
					if (((2747 + 311) < (7535 - 2675)) and v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch))) then
						return "scorch standard_rotation 19";
					end
				end
				if ((v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and (not v88.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((1 + 1) * v123)))) or ((2197 - (652 + 249)) >= (11898 - 7452))) then
					if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((3261 - (708 + 1160)) > (12184 - 7695))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v168 = 5 - 2;
			end
			if (((32 - (10 + 17)) == v168) or ((994 + 3430) < (1759 - (1400 + 332)))) then
				if ((v33 and v88.DragonsBreath:IsReady() and v38 and (v126 > (1 - 0)) and v88.AlexstraszasFury:IsAvailable()) or ((3905 - (242 + 1666)) > (1633 + 2182))) then
					if (((1270 + 2195) > (1631 + 282)) and v23(v88.DragonsBreath, not v14:IsInRange(950 - (850 + 90)))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if (((1283 - 550) < (3209 - (360 + 1030))) and v88.Scorch:IsReady() and v46 and (v133())) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((3890 + 505) == (13420 - 8665))) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v33 and v88.ArcaneExplosion:IsReady() and v36 and (v127 >= v100) and (v13:ManaPercentageP() >= v101)) or ((5217 - 1424) < (4030 - (909 + 752)))) then
					if (v23(v88.ArcaneExplosion, not v14:IsInRange(1231 - (109 + 1114))) or ((7476 - 3392) == (104 + 161))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v168 = 248 - (6 + 236);
			end
			if (((2746 + 1612) == (3508 + 850)) and ((8 - 4) == v168)) then
				if ((v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and v13:BuffDown(v88.HotStreakBuff) and (v138() == (0 - 0)) and ((not v111 and v13:BuffUp(v88.FlamesFuryBuff)) or (v88.PhoenixFlames:ChargesFractional() > (1135.5 - (1076 + 57))) or ((v88.PhoenixFlames:ChargesFractional() > (1.5 + 0)) and (not v88.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((692 - (579 + 110)) * v123)))))) or ((248 + 2890) < (878 + 115))) then
					if (((1768 + 1562) > (2730 - (174 + 233))) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v144();
				if (v31 or ((10128 - 6502) == (7000 - 3011))) then
					return v31;
				end
				v168 = 3 + 2;
			end
		end
	end
	local function v150()
		local v169 = 1174 - (663 + 511);
		while true do
			if ((v169 == (0 + 0)) or ((199 + 717) == (8234 - 5563))) then
				if (((165 + 107) == (640 - 368)) and not v94) then
					v147();
				end
				if (((10285 - 6036) <= (2310 + 2529)) and v34 and v86 and v88.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v88.TemporalWarp:IsAvailable() and (v131() or (v122 < (77 - 37)))) then
					if (((1980 + 797) < (293 + 2907)) and v23(v88.TimeWarp, not v14:IsInRange(762 - (478 + 244)))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((612 - (440 + 77)) < (890 + 1067)) and (v74 < v122)) then
					if (((3022 - 2196) < (3273 - (655 + 901))) and v81 and ((v34 and v82) or not v82)) then
						local v230 = 0 + 0;
						while true do
							if (((1092 + 334) >= (747 + 358)) and (v230 == (0 - 0))) then
								v31 = v139();
								if (((4199 - (695 + 750)) <= (11538 - 8159)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				v110 = v108 > v88.ShiftingPower:CooldownRemains();
				v169 = 1 - 0;
			end
			if ((v169 == (7 - 5)) or ((4278 - (285 + 66)) == (3293 - 1880))) then
				if ((v124 < v98) or ((2464 - (682 + 628)) <= (128 + 660))) then
					v111 = (v88.SunKingsBlessing:IsAvailable() or (((v108 + (306 - (176 + 123))) < ((v88.PhoenixFlames:FullRechargeTime() + v88.PhoenixFlames:Cooldown()) - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
				end
				if ((v124 >= v98) or ((688 + 955) > (2452 + 927))) then
					v111 = (v88.SunKingsBlessing:IsAvailable() or ((v108 < (v88.PhoenixFlames:FullRechargeTime() - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
				end
				if ((v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (v108 > (269 - (239 + 30))) and (v124 >= v97) and not v131() and v13:BuffDown(v88.HotStreakBuff) and ((v13:BuffUp(v88.HeatingUpBuff) and (v88.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v88.FireBlast:ChargesFractional() >= (2 + 0)))) or ((4960 - 2157) > (14192 - 9643))) then
					if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((535 - (306 + 9)) >= (10545 - 7523))) then
						return "fire_blast main 14";
					end
				end
				if (((491 + 2331) == (1732 + 1090)) and v118 and v131() and (v108 > (0 + 0))) then
					local v224 = 0 - 0;
					while true do
						if ((v224 == (1375 - (1140 + 235))) or ((676 + 385) == (1703 + 154))) then
							v31 = v148();
							if (((709 + 2051) > (1416 - (33 + 19))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v169 = 2 + 1;
			end
			if ((v169 == (8 - 5)) or ((2160 + 2742) <= (7049 - 3454))) then
				if ((v88.FireBlast:IsReady() and v39 and not v136() and v13:IsCasting(v88.ShiftingPower) and (v88.FireBlast:FullRechargeTime() < v120)) or ((3612 + 240) == (982 - (586 + 103)))) then
					if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((142 + 1417) == (14124 - 9536))) then
						return "fire_blast main 16";
					end
				end
				if (((v108 > (1488 - (1309 + 179))) and v118) or ((8094 - 3610) == (343 + 445))) then
					v31 = v149();
					if (((12267 - 7699) >= (2952 + 955)) and v31) then
						return v31;
					end
				end
				if (((2647 - 1401) < (6914 - 3444)) and v88.IceNova:IsCastable() and not v133()) then
					if (((4677 - (295 + 314)) >= (2387 - 1415)) and v23(v88.IceNova, not v14:IsSpellInRange(v88.IceNova))) then
						return "ice_nova main 18";
					end
				end
				if (((2455 - (1300 + 662)) < (12224 - 8331)) and v88.Scorch:IsReady() and v46) then
					if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((3228 - (1178 + 577)) >= (1731 + 1601))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v169 == (2 - 1)) or ((5456 - (851 + 554)) <= (1024 + 133))) then
				v112 = v118 and (((v88.FireBlast:ChargesFractional() + ((v108 + (v135() * v27(v110))) / v88.FireBlast:Cooldown())) - (2 - 1)) < ((v88.FireBlast:MaxCharges() + (v104 / v88.FireBlast:Cooldown())) - (((25 - 13) / v88.FireBlast:Cooldown()) % (303 - (115 + 187))))) and (v108 < v122);
				if (((463 + 141) < (2728 + 153)) and not v94 and ((v108 <= (0 - 0)) or v117 or ((v108 < v114) and (v88.Combustion:CooldownRemains() < v114)))) then
					v31 = v146();
					if (v31 or ((2061 - (160 + 1001)) == (2955 + 422))) then
						return v31;
					end
				end
				if (((3077 + 1382) > (1209 - 618)) and not v112 and v88.SunKingsBlessing:IsAvailable()) then
					v112 = v133() and (v88.FireBlast:FullRechargeTime() > ((361 - (237 + 121)) * v123));
				end
				if (((4295 - (525 + 372)) >= (4540 - 2145)) and v88.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v122) and v118 and ((v88.FireBlast:Charges() == (0 - 0)) or v112) and (not v134() or ((v14:DebuffRemains(v88.ImprovedScorchDebuff) > (v88.ShiftingPower:CastTime() + v88.Scorch:CastTime())) and v13:BuffDown(v88.FuryoftheSunKingBuff))) and v13:BuffDown(v88.HotStreakBuff) and v110) then
					if (v23(v88.ShiftingPower, not v14:IsInRange(182 - (96 + 46)), true) or ((2960 - (643 + 134)) >= (1020 + 1804))) then
						return "shifting_power main 12";
					end
				end
				v169 = 4 - 2;
			end
		end
	end
	local function v151()
		v36 = EpicSettings.Settings['useArcaneExplosion'];
		v37 = EpicSettings.Settings['useArcaneIntellect'];
		v38 = EpicSettings.Settings['useDragonsBreath'];
		v39 = EpicSettings.Settings['useFireBlast'];
		v40 = EpicSettings.Settings['useFireball'];
		v41 = EpicSettings.Settings['useFlamestrike'];
		v42 = EpicSettings.Settings['useLivingBomb'];
		v43 = EpicSettings.Settings['useMeteor'];
		v44 = EpicSettings.Settings['usePhoenixFlames'];
		v45 = EpicSettings.Settings['usePyroblast'];
		v46 = EpicSettings.Settings['useScorch'];
		v47 = EpicSettings.Settings['useCounterspell'];
		v48 = EpicSettings.Settings['useBlastWave'];
		v49 = EpicSettings.Settings['useCombustion'];
		v50 = EpicSettings.Settings['useShiftingPower'];
		v51 = EpicSettings.Settings['combustionWithCD'];
		v52 = EpicSettings.Settings['shiftingPowerWithCD'];
		v53 = EpicSettings.Settings['useAlterTime'];
		v54 = EpicSettings.Settings['useBlazingBarrier'];
		v55 = EpicSettings.Settings['useGreaterInvisibility'];
		v56 = EpicSettings.Settings['useIceBlock'];
		v57 = EpicSettings.Settings['useIceCold'];
		v59 = EpicSettings.Settings['useMassBarrier'];
		v58 = EpicSettings.Settings['useMirrorImage'];
		v60 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v64 = EpicSettings.Settings['iceColdHP'] or (719 - (316 + 403));
		v65 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v66 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v84 = EpicSettings.Settings['mirrorImageBeforePull'];
		v85 = EpicSettings.Settings['useSpellStealTarget'];
		v86 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v87 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v152()
		local v198 = 0 + 0;
		while true do
			if (((4875 - 2939) == (1372 + 564)) and (v198 == (1 + 2))) then
				v83 = EpicSettings.Settings['racialsWithCD'];
				v76 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v198 = 13 - 9;
			end
			if ((v198 == (9 - 7)) or ((10037 - 5205) < (247 + 4066))) then
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v198 = 5 - 2;
			end
			if (((200 + 3888) > (11397 - 7523)) and (v198 == (17 - (12 + 5)))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v198 = 1 - 0;
			end
			if (((9208 - 4876) == (10742 - 6410)) and (v198 == (1 + 3))) then
				v78 = EpicSettings.Settings['healthstoneHP'] or (1973 - (1656 + 317));
				v77 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v79 = EpicSettings.Settings['HealingPotionName'] or "";
				v198 = 5 + 0;
			end
			if (((10633 - 6634) >= (14272 - 11372)) and (v198 == (359 - (5 + 349)))) then
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v198 == (4 - 3)) or ((3796 - (266 + 1005)) > (2679 + 1385))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v67 = EpicSettings.Settings['DispelBuffs'];
				v198 = 6 - 4;
			end
		end
	end
	local function v153()
		local v199 = 0 - 0;
		while true do
			if (((6067 - (561 + 1135)) == (5695 - 1324)) and (v199 == (6 - 4))) then
				v128 = v13:GetEnemiesInRange(1106 - (507 + 559));
				if (v33 or ((667 - 401) > (15420 - 10434))) then
					local v225 = 388 - (212 + 176);
					while true do
						if (((2896 - (250 + 655)) >= (2522 - 1597)) and (v225 == (0 - 0))) then
							v124 = v29(v14:GetEnemiesInSplashRangeCount(7 - 2), #v128);
							v125 = v29(v14:GetEnemiesInSplashRangeCount(1961 - (1869 + 87)), #v128);
							v225 = 3 - 2;
						end
						if (((2356 - (484 + 1417)) < (4400 - 2347)) and (v225 == (1 - 0))) then
							v126 = v29(v14:GetEnemiesInSplashRangeCount(778 - (48 + 725)), #v128);
							v127 = #v128;
							break;
						end
					end
				else
					local v226 = 0 - 0;
					while true do
						if ((v226 == (0 - 0)) or ((481 + 345) == (12963 - 8112))) then
							v124 = 1 + 0;
							v125 = 1 + 0;
							v226 = 854 - (152 + 701);
						end
						if (((1494 - (430 + 881)) == (71 + 112)) and (v226 == (896 - (557 + 338)))) then
							v126 = 1 + 0;
							v127 = 2 - 1;
							break;
						end
					end
				end
				if (((4058 - 2899) <= (4750 - 2962)) and (v92.TargetIsValid() or v13:AffectingCombat())) then
					local v227 = 0 - 0;
					while true do
						if ((v227 == (804 - (499 + 302))) or ((4373 - (39 + 827)) > (11919 - 7601))) then
							if (v94 or ((6867 - 3792) <= (11776 - 8811))) then
								v108 = 153528 - 53529;
							end
							v123 = v13:GCD();
							v227 = 1 + 3;
						end
						if (((3995 - 2630) <= (322 + 1689)) and (v227 == (0 - 0))) then
							if (v13:AffectingCombat() or v68 or ((2880 - (103 + 1)) > (4129 - (475 + 79)))) then
								local v233 = 0 - 0;
								local v234;
								while true do
									if ((v233 == (0 - 0)) or ((331 + 2223) == (4228 + 576))) then
										v234 = v68 and v88.RemoveCurse:IsReady() and v35;
										v31 = v92.FocusUnit(v234, v90, 1523 - (1395 + 108), nil, 58 - 38);
										v233 = 1205 - (7 + 1197);
									end
									if (((1124 + 1453) == (900 + 1677)) and (v233 == (320 - (27 + 292)))) then
										if (v31 or ((17 - 11) >= (2408 - 519))) then
											return v31;
										end
										break;
									end
								end
							end
							v121 = v9.BossFightRemains(nil, true);
							v227 = 4 - 3;
						end
						if (((997 - 491) <= (3603 - 1711)) and (v227 == (143 - (43 + 96)))) then
							v117 = v13:BuffUp(v88.CombustionBuff);
							v118 = not v117;
							break;
						end
						if ((v227 == (4 - 3)) or ((4539 - 2531) > (1841 + 377))) then
							v122 = v121;
							if (((108 + 271) <= (8195 - 4048)) and (v122 == (4259 + 6852))) then
								v122 = v9.FightRemains(v128, false);
							end
							v227 = 3 - 1;
						end
						if ((v227 == (1 + 1)) or ((332 + 4182) <= (2760 - (1414 + 337)))) then
							v130 = v137(v128);
							v94 = not v34;
							v227 = 1943 - (1642 + 298);
						end
					end
				end
				if ((not v13:AffectingCombat() and v32) or ((9113 - 5617) == (3428 - 2236))) then
					local v228 = 0 - 0;
					while true do
						if ((v228 == (0 + 0)) or ((162 + 46) == (3931 - (357 + 615)))) then
							v31 = v143();
							if (((3003 + 1274) >= (3221 - 1908)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v199 = 3 + 0;
			end
			if (((5543 - 2956) < (2539 + 635)) and (v199 == (0 + 0))) then
				v151();
				v152();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v199 = 1 + 0;
			end
			if ((v199 == (1304 - (384 + 917))) or ((4817 - (128 + 569)) <= (3741 - (1407 + 136)))) then
				if ((v13:AffectingCombat() and v92.TargetIsValid()) or ((3483 - (687 + 1200)) == (2568 - (556 + 1154)))) then
					if (((11328 - 8108) == (3315 - (9 + 86))) and v68 and v35 and v88.RemoveCurse:IsAvailable()) then
						local v231 = 421 - (275 + 146);
						while true do
							if (((0 + 0) == v231) or ((1466 - (29 + 35)) > (16043 - 12423))) then
								if (((7687 - 5113) == (11362 - 8788)) and v15) then
									v31 = v141();
									if (((1172 + 626) < (3769 - (53 + 959))) and v31) then
										return v31;
									end
								end
								if ((v17 and v17:Exists() and v17:IsAPlayer() and v92.UnitHasCurseDebuff(v17)) or ((785 - (312 + 96)) > (4519 - 1915))) then
									if (((853 - (147 + 138)) < (1810 - (813 + 86))) and v88.RemoveCurse:IsReady()) then
										if (((2969 + 316) < (7833 - 3605)) and v23(v90.RemoveCurseMouseover)) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					v31 = v142();
					if (((4408 - (18 + 474)) > (1123 + 2205)) and v31) then
						return v31;
					end
					if (((8159 - 5659) < (4925 - (860 + 226))) and v69) then
						if (((810 - (121 + 182)) == (63 + 444)) and v87) then
							local v232 = 1240 - (988 + 252);
							while true do
								if (((28 + 212) <= (992 + 2173)) and ((1970 - (49 + 1921)) == v232)) then
									v31 = v92.HandleAfflicted(v88.RemoveCurse, v90.RemoveCurseMouseover, 920 - (223 + 667));
									if (((886 - (51 + 1)) >= (1385 - 580)) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if (v70 or ((8162 - 4350) < (3441 - (146 + 979)))) then
						v31 = v92.HandleIncorporeal(v88.Polymorph, v90.PolymorphMouseOver, 9 + 21, true);
						if (v31 or ((3257 - (311 + 294)) <= (4274 - 2741))) then
							return v31;
						end
					end
					if ((v88.Spellsteal:IsAvailable() and v85 and v88.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v92.UnitHasMagicBuff(v14)) or ((1525 + 2073) < (2903 - (496 + 947)))) then
						if (v23(v88.Spellsteal, not v14:IsSpellInRange(v88.Spellsteal)) or ((5474 - (1233 + 125)) < (484 + 708))) then
							return "spellsteal damage";
						end
					end
					if (((v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v88.HotStreakBuff)) or ((3030 + 347) <= (172 + 731))) then
						if (((5621 - (963 + 682)) >= (367 + 72)) and v23(v90.StopCasting, not v14:IsSpellInRange(v88.Pyroblast))) then
							return "Stop Casting";
						end
					end
					if (((5256 - (504 + 1000)) == (2527 + 1225)) and v13:IsMoving() and v88.IceFloes:IsReady()) then
						if (((3685 + 361) > (255 + 2440)) and v23(v88.IceFloes)) then
							return "ice_floes movement";
						end
					end
					v31 = v150();
					if (v31 or ((5227 - 1682) == (2732 + 465))) then
						return v31;
					end
				end
				break;
			end
			if (((1393 + 1001) > (555 - (156 + 26))) and (v199 == (1 + 0))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (((6500 - 2345) <= (4396 - (149 + 15))) and v13:IsDeadOrGhost()) then
					return v31;
				end
				v129 = v14:GetEnemiesInSplashRange(965 - (890 + 70));
				v199 = 119 - (39 + 78);
			end
		end
	end
	local function v154()
		v93();
		v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(545 - (14 + 468), v153, v154);
end;
return v0["Epix_Mage_Fire.lua"]();

