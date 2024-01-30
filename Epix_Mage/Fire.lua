local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3737 - (561 + 677)) == (8695 - 6196)) and not v5) then
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
		if (v88.RemoveCurse:IsAvailable() or ((1050 + 1205) < (5 + 17))) then
			v92.DispellableDebuffs = v92.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v93();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v94 = not v34;
	local v95 = v88.SunKingsBlessing:IsAvailable();
	local v96 = ((v88.FlamePatch:IsAvailable()) and (4 + 0)) or (3369 - 2370);
	local v97 = 2993 - (109 + 1885);
	local v98 = v96;
	local v99 = ((1472 - (1269 + 200)) * v27(v88.FueltheFire:IsAvailable())) + ((1914 - 915) * v27(not v88.FueltheFire:IsAvailable()));
	local v100 = 1814 - (98 + 717);
	local v101 = 866 - (802 + 24);
	local v102 = 1722 - 723;
	local v103 = 0.3 - 0;
	local v104 = 0 + 0;
	local v105 = 5 + 1;
	local v106 = false;
	local v107 = (v106 and (4 + 16)) or (0 + 0);
	local v108;
	local v109 = ((v88.Kindling:IsAvailable()) and (0.4 - 0)) or (3 - 2);
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = 0 + 0;
	local v114 = 0 + 0;
	local v115 = 7 + 1;
	local v116 = 3 + 0;
	local v117;
	local v118;
	local v119;
	local v120 = 2 + 1;
	local v121 = 12544 - (797 + 636);
	local v122 = 53947 - 42836;
	local v123;
	local v124, v125, v126;
	local v127;
	local v128;
	local v129;
	local v130;
	v9:RegisterForEvent(function()
		local v154 = 1619 - (1427 + 192);
		while true do
			if ((v154 == (0 + 0)) or ((2521 - 1435) >= (1263 + 142))) then
				v106 = false;
				v107 = (v106 and (10 + 10)) or (326 - (192 + 134));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v88.Pyroblast:RegisterInFlight();
		v88.Fireball:RegisterInFlight();
		v88.Meteor:RegisterInFlightEffect(352416 - (316 + 960));
		v88.Meteor:RegisterInFlight();
		v88.PhoenixFlames:RegisterInFlightEffect(143322 + 114220);
		v88.PhoenixFlames:RegisterInFlight();
		v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
		v88.Fireball:RegisterInFlight(v88.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v88.Pyroblast:RegisterInFlight();
	v88.Fireball:RegisterInFlight();
	v88.Meteor:RegisterInFlightEffect(270981 + 80159);
	v88.Meteor:RegisterInFlight();
	v88.PhoenixFlames:RegisterInFlightEffect(238049 + 19493);
	v88.PhoenixFlames:RegisterInFlight();
	v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
	v88.Fireball:RegisterInFlight(v88.CombustionBuff);
	v9:RegisterForEvent(function()
		v121 = 42477 - 31366;
		v122 = 11662 - (83 + 468);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v155 = 1806 - (1202 + 604);
		while true do
			if ((v155 == (0 - 0)) or ((3942 - 1573) == (1179 - 753))) then
				v95 = v88.SunKingsBlessing:IsAvailable();
				v96 = ((v88.FlamePatch:IsAvailable()) and (328 - (45 + 280))) or (965 + 34);
				v155 = 1 + 0;
			end
			if ((v155 == (1 + 0)) or ((1703 + 1373) > (560 + 2623))) then
				v98 = v96;
				v109 = ((v88.Kindling:IsAvailable()) and (0.4 - 0)) or (1912 - (340 + 1571));
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v131()
		return v88.Firestarter:IsAvailable() and (v14:HealthPercentage() > (36 + 54));
	end
	local function v132()
		return (v88.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (1862 - (1733 + 39))) and v14:TimeToX(247 - 157)) or (1034 - (125 + 909)))) or (1948 - (1096 + 852));
	end
	local function v133()
		return v88.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (14 + 16));
	end
	local function v134()
		return v88.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (42 - 12));
	end
	local function v135()
		return (v120 * v88.ShiftingPower:BaseDuration()) / v88.ShiftingPower:BaseTickTime();
	end
	local function v136()
		local v156 = 0 + 0;
		local v157;
		while true do
			if (((1714 - (409 + 103)) > (1294 - (46 + 190))) and ((96 - (51 + 44)) == v156)) then
				return v13:BuffUp(v88.HotStreakBuff) or v13:BuffUp(v88.HyperthermiaBuff) or (v13:BuffUp(v88.HeatingUpBuff) and ((v134() and v13:IsCasting(v88.Scorch)) or (v131() and (v13:IsCasting(v88.Fireball) or v13:IsCasting(v88.Pyroblast) or (v157 > (0 + 0))))));
			end
			if (((5028 - (1114 + 203)) > (4081 - (228 + 498))) and (v156 == (0 + 0))) then
				v157 = (v131() and (v27(v88.Pyroblast:InFlight()) + v27(v88.Fireball:InFlight()))) or (0 + 0);
				v157 = v157 + v27(v88.PhoenixFlames:InFlight() or v13:PrevGCDP(664 - (174 + 489), v88.PhoenixFlames));
				v156 = 2 - 1;
			end
		end
	end
	local function v137(v158)
		local v159 = 1905 - (830 + 1075);
		local v160;
		while true do
			if ((v159 == (525 - (303 + 221))) or ((2175 - (231 + 1038)) >= (1858 + 371))) then
				return v160;
			end
			if (((2450 - (171 + 991)) > (5155 - 3904)) and (v159 == (0 - 0))) then
				v160 = 0 - 0;
				for v221, v222 in pairs(v158) do
					if (v222:DebuffUp(v88.IgniteDebuff) or ((3612 + 901) < (11749 - 8397))) then
						v160 = v160 + (2 - 1);
					end
				end
				v159 = 1 - 0;
			end
		end
	end
	local function v138()
		local v161 = 0 - 0;
		local v162;
		while true do
			if ((v161 == (1249 - (111 + 1137))) or ((2223 - (91 + 67)) >= (9512 - 6316))) then
				return v162;
			end
			if ((v161 == (0 + 0)) or ((4899 - (423 + 100)) <= (11 + 1470))) then
				v162 = 0 - 0;
				if (v88.Fireball:InFlight() or v88.PhoenixFlames:InFlight() or ((1768 + 1624) >= (5512 - (326 + 445)))) then
					v162 = v162 + (4 - 3);
				end
				v161 = 2 - 1;
			end
		end
	end
	local function v139()
		local v163 = 0 - 0;
		while true do
			if (((4036 - (530 + 181)) >= (3035 - (614 + 267))) and (v163 == (32 - (19 + 13)))) then
				v31 = v92.HandleTopTrinket(v91, v34, 65 - 25, nil);
				if (v31 or ((3017 - 1722) >= (9235 - 6002))) then
					return v31;
				end
				v163 = 1 + 0;
			end
			if (((7697 - 3320) > (3404 - 1762)) and (v163 == (1813 - (1293 + 519)))) then
				v31 = v92.HandleBottomTrinket(v91, v34, 81 - 41, nil);
				if (((12331 - 7608) > (2592 - 1236)) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v140()
		if ((v88.RemoveCurse:IsReady() and v92.DispellableFriendlyUnit(86 - 66)) or ((9743 - 5607) <= (1819 + 1614))) then
			if (((867 + 3378) <= (10759 - 6128)) and v23(v90.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v141()
		local v164 = 0 + 0;
		while true do
			if (((1421 + 2855) >= (2446 + 1468)) and ((1097 - (709 + 387)) == v164)) then
				if (((2056 - (673 + 1185)) <= (12659 - 8294)) and v88.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) then
					if (((15355 - 10573) > (7693 - 3017)) and v23(v88.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((3480 + 1384) > (1642 + 555)) and v88.IceColdTalent:IsAvailable() and v88.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
					if (v23(v88.IceColdAbility) or ((4995 - 1295) == (616 + 1891))) then
						return "ice_cold defensive 3";
					end
				end
				v164 = 3 - 1;
			end
			if (((8782 - 4308) >= (2154 - (446 + 1434))) and (v164 == (1285 - (1040 + 243)))) then
				if ((v88.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((5652 - 3758) <= (3253 - (559 + 1288)))) then
					if (((3503 - (609 + 1322)) >= (1985 - (13 + 441))) and v23(v88.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v88.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) or ((17514 - 12827) < (11897 - 7355))) then
					if (((16390 - 13099) > (63 + 1604)) and v23(v88.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v164 = 10 - 7;
			end
			if ((v164 == (2 + 1)) or ((383 + 490) == (6035 - 4001))) then
				if ((v88.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) or ((1541 + 1275) < (20 - 9))) then
					if (((2446 + 1253) < (2618 + 2088)) and v23(v88.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if (((1902 + 744) >= (736 + 140)) and v89.Healthstone:IsReady() and v76 and (v13:HealthPercentage() <= v78)) then
					if (((601 + 13) <= (3617 - (153 + 280))) and v23(v90.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v164 = 11 - 7;
			end
			if (((2807 + 319) == (1235 + 1891)) and ((0 + 0) == v164)) then
				if ((v88.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v88.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((1985 + 202) >= (3590 + 1364))) then
					if (v23(v88.BlazingBarrier) or ((5902 - 2025) == (2210 + 1365))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((1374 - (89 + 578)) > (452 + 180)) and v88.MassBarrier:IsCastable() and v59 and v13:BuffDown(v88.BlazingBarrier) and v92.AreUnitsBelowHealthPercentage(v66, 3 - 1)) then
					if (v23(v88.MassBarrier) or ((1595 - (572 + 477)) >= (362 + 2322))) then
						return "mass_barrier defensive 2";
					end
				end
				v164 = 1 + 0;
			end
			if (((175 + 1290) <= (4387 - (84 + 2))) and (v164 == (6 - 2))) then
				if (((1228 + 476) > (2267 - (497 + 345))) and v75 and (v13:HealthPercentage() <= v77)) then
					local v226 = 0 + 0;
					while true do
						if ((v226 == (0 + 0)) or ((2020 - (605 + 728)) == (3021 + 1213))) then
							if ((v79 == "Refreshing Healing Potion") or ((7403 - 4073) < (66 + 1363))) then
								if (((4240 - 3093) >= (303 + 32)) and v89.RefreshingHealingPotion:IsReady()) then
									if (((9516 - 6081) > (1584 + 513)) and v23(v90.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v79 == "Dreamwalker's Healing Potion") or ((4259 - (457 + 32)) >= (1715 + 2326))) then
								if (v89.DreamwalkersHealingPotion:IsReady() or ((5193 - (832 + 570)) <= (1518 + 93))) then
									if (v23(v90.RefreshingHealingPotion) or ((1194 + 3384) <= (7105 - 5097))) then
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
	local function v142()
		if (((542 + 583) <= (2872 - (588 + 208))) and v88.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v88.ArcaneIntellect, true) or v92.GroupBuffMissing(v88.ArcaneIntellect))) then
			if (v23(v88.ArcaneIntellect) or ((2002 - 1259) >= (6199 - (884 + 916)))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((2418 - 1263) < (971 + 702)) and v88.MirrorImage:IsCastable() and v92.TargetIsValid() and v58 and v84) then
			if (v23(v88.MirrorImage) or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
				return "mirror_image precombat 2";
			end
		end
		if (((925 + 2842) == (716 + 3051)) and v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast)) then
			if (((13778 - 9689) == (4694 - (316 + 289))) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true)) then
				return "pyroblast precombat 4";
			end
		end
		if (((11669 - 7211) >= (78 + 1596)) and v88.Fireball:IsReady() and v40) then
			if (((2425 - (666 + 787)) <= (1843 - (360 + 65))) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v143()
		local v165 = 0 + 0;
		while true do
			if ((v165 == (255 - (79 + 175))) or ((7785 - 2847) < (3716 + 1046))) then
				if ((v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v13:BuffDown(v88.HotStreakBuff) and (v13:BuffUp(v88.FeeltheBurnBuff) or (v9.CombatTime() > (45 - 30))) and not v134() and (v132() == (0 - 0)) and not v88.TemperedFlames:IsAvailable()) or ((3403 - (503 + 396)) > (4445 - (92 + 89)))) then
					if (((4175 - 2022) == (1105 + 1048)) and v23(v88.DragonsBreath, not v14:IsInRange(6 + 4))) then
						return "dragons_breath active_talents 6";
					end
				end
				if ((v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v13:BuffDown(v88.HotStreakBuff) and (v13:BuffUp(v88.FeeltheBurnBuff) or (v9.CombatTime() > (58 - 43))) and not v134() and v88.TemperedFlames:IsAvailable()) or ((70 + 437) >= (5907 - 3316))) then
					if (((3910 + 571) == (2141 + 2340)) and v23(v88.DragonsBreath, not v14:IsInRange(30 - 20))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v165 == (0 + 0)) or ((3550 - 1222) < (1937 - (485 + 759)))) then
				if (((10014 - 5686) == (5517 - (442 + 747))) and v88.LivingBomb:IsReady() and v42 and (v125 > (1136 - (832 + 303))) and v118 and ((v108 > v88.LivingBomb:CooldownRemains()) or (v108 <= (946 - (88 + 858))))) then
					if (((484 + 1104) >= (1103 + 229)) and v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb))) then
						return "living_bomb active_talents 2";
					end
				end
				if ((v88.Meteor:IsReady() and v43 and (v74 < v122) and ((v108 <= (0 + 0)) or (v13:BuffRemains(v88.CombustionBuff) > v88.Meteor:TravelTime()) or (not v88.SunKingsBlessing:IsAvailable() and (((834 - (766 + 23)) < v108) or (v122 < v108))))) or ((20605 - 16431) > (5809 - 1561))) then
					if (v23(v90.MeteorCursor, not v14:IsInRange(105 - 65)) or ((15564 - 10978) <= (1155 - (1036 + 37)))) then
						return "meteor active_talents 4";
					end
				end
				v165 = 1 + 0;
			end
		end
	end
	local function v144()
		local v166 = 0 - 0;
		local v167;
		while true do
			if (((3039 + 824) == (5343 - (641 + 839))) and (v166 == (914 - (910 + 3)))) then
				if ((v80 and ((v83 and v34) or not v83) and (v74 < v122)) or ((718 - 436) <= (1726 - (1466 + 218)))) then
					local v227 = 0 + 0;
					while true do
						if (((5757 - (556 + 592)) >= (273 + 493)) and (v227 == (808 - (329 + 479)))) then
							if (v88.BloodFury:IsCastable() or ((2006 - (174 + 680)) == (8548 - 6060))) then
								if (((7092 - 3670) > (2392 + 958)) and v23(v88.BloodFury)) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if (((1616 - (396 + 343)) > (34 + 342)) and v88.Berserking:IsCastable() and v117) then
								if (v23(v88.Berserking) or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v227 = 3 - 2;
						end
						if ((v227 == (4 - 3)) or ((110 + 55) >= (5019 - (389 + 1138)))) then
							if (((4523 - (102 + 472)) < (4583 + 273)) and v88.Fireblood:IsCastable()) then
								if (v23(v88.Fireblood) or ((2372 + 1904) < (2813 + 203))) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (((6235 - (320 + 1225)) > (7343 - 3218)) and v88.AncestralCall:IsCastable()) then
								if (v23(v88.AncestralCall) or ((31 + 19) >= (2360 - (157 + 1307)))) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if ((v86 and v88.TimeWarp:IsReady() and v88.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) or ((3573 - (821 + 1038)) >= (7380 - 4422))) then
					if (v23(v88.TimeWarp, nil, nil, true) or ((164 + 1327) < (1143 - 499))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v166 = 1 + 1;
			end
			if (((1744 - 1040) < (2013 - (834 + 192))) and (v166 == (1 + 1))) then
				if (((955 + 2763) > (41 + 1865)) and (v74 < v122)) then
					if ((v81 and ((v34 and v82) or not v82)) or ((1483 - 525) > (3939 - (300 + 4)))) then
						v31 = v139();
						if (((936 + 2565) <= (11758 - 7266)) and v31) then
							return v31;
						end
					end
				end
				break;
			end
			if ((v166 == (362 - (112 + 250))) or ((1373 + 2069) < (6382 - 3834))) then
				v167 = v92.HandleDPSPotion(v13:BuffUp(v88.CombustionBuff));
				if (((1648 + 1227) >= (758 + 706)) and v167) then
					return v167;
				end
				v166 = 1 + 0;
			end
		end
	end
	local function v145()
		if ((v88.LightsJudgment:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) or ((2379 + 2418) >= (3635 + 1258))) then
			if (v23(v88.LightsJudgment, not v14:IsSpellInRange(v88.LightsJudgment)) or ((1965 - (1001 + 413)) > (4611 - 2543))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((2996 - (244 + 638)) > (1637 - (627 + 66))) and v88.BagofTricks:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) then
			if (v23(v88.BagofTricks) or ((6739 - 4477) >= (3698 - (512 + 90)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if ((v88.LivingBomb:IsReady() and v33 and v42 and (v125 > (1907 - (1665 + 241))) and v118) or ((2972 - (373 + 344)) >= (1596 + 1941))) then
			if (v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb)) or ((1016 + 2821) < (3444 - 2138))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if (((4992 - 2042) == (4049 - (35 + 1064))) and ((v13:BuffRemains(v88.CombustionBuff) > v105) or (v122 < (15 + 5)))) then
			local v203 = 0 - 0;
			while true do
				if ((v203 == (0 + 0)) or ((5959 - (298 + 938)) < (4557 - (233 + 1026)))) then
					v31 = v144();
					if (((2802 - (636 + 1030)) >= (79 + 75)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v88.CombustionBuff) and v13:HasTier(30 + 0, 1 + 1) and not v88.PhoenixFlames:InFlight() and (v14:DebuffRemains(v88.CharringEmbersDebuff) < ((1 + 3) * v123)) and v13:BuffDown(v88.HotStreakBuff)) or ((492 - (55 + 166)) > (921 + 3827))) then
			if (((477 + 4263) >= (12037 - 8885)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v31 = v143();
		if (v31 or ((2875 - (36 + 261)) >= (5928 - 2538))) then
			return v31;
		end
		if (((1409 - (34 + 1334)) <= (639 + 1022)) and v88.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v122) and (v138() == (0 + 0)) and v118 and (v108 <= (1283 - (1035 + 248))) and ((v13:IsCasting(v88.Scorch) and (v88.Scorch:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Fireball) and (v88.Fireball:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Pyroblast) and (v88.Pyroblast:ExecuteRemains() < v103)) or (v13:IsCasting(v88.Flamestrike) and (v88.Flamestrike:ExecuteRemains() < v103)) or (v88.Meteor:InFlight() and (v88.Meteor:InFlightRemains() < v103)))) then
			if (((622 - (20 + 1)) < (1855 + 1705)) and v23(v88.Combustion, not v14:IsInRange(359 - (134 + 185)), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if (((1368 - (549 + 584)) < (1372 - (314 + 371))) and v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and v118 and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v88.Combustion:CooldownRemains() < v88.Flamestrike:CastTime()) and (v124 >= v99)) then
			if (((15616 - 11067) > (2121 - (478 + 490))) and v23(v90.FlamestrikeCursor, not v14:IsInRange(22 + 18))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and v118 and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) or ((5846 - (786 + 386)) < (15132 - 10460))) then
			if (((5047 - (1055 + 324)) < (5901 - (1093 + 247))) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if ((v88.Fireball:IsReady() and v40 and v118 and (v88.Combustion:CooldownRemains() < v88.Fireball:CastTime()) and (v124 < (2 + 0)) and not v134()) or ((48 + 407) == (14312 - 10707))) then
			if (v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball)) or ((9037 - 6374) == (9424 - 6112))) then
				return "fireball combustion_phase 16";
			end
		end
		if (((10747 - 6470) <= (1592 + 2883)) and v88.Scorch:IsReady() and v46 and v118 and (v88.Combustion:CooldownRemains() < v88.Scorch:CastTime())) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((3351 - 2481) == (4098 - 2909))) then
				return "scorch combustion_phase 18";
			end
		end
		if (((1172 + 381) <= (8011 - 4878)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (not v134() or v13:IsCasting(v88.Scorch) or (v14:DebuffRemains(v88.ImprovedScorchDebuff) > ((692 - (364 + 324)) * v123))) and (v13:BuffDown(v88.FuryoftheSunKingBuff) or v13:IsCasting(v88.Pyroblast)) and v117 and v13:BuffDown(v88.HyperthermiaBuff) and v13:BuffDown(v88.HotStreakBuff) and ((v138() + (v27(v13:BuffUp(v88.HeatingUpBuff)) * v27(v13:GCDRemains() > (0 - 0)))) < (4 - 2))) then
			if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((742 + 1495) >= (14691 - 11180))) then
				return "fire_blast combustion_phase 20";
			end
		end
		if ((v33 and v88.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v88.HotStreakBuff) and (v124 >= v98)) or (v13:BuffUp(v88.HyperthermiaBuff) and (v124 >= (v98 - v27(v88.Hyperthermia:IsAvailable())))))) or ((2119 - 795) > (9172 - 6152))) then
			if (v23(v90.FlamestrikeCursor, not v14:IsInRange(1308 - (1249 + 19))) or ((2701 + 291) == (7321 - 5440))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((4192 - (686 + 400)) > (1198 + 328)) and v88.Pyroblast:IsReady() and v45 and (v13:BuffUp(v88.HyperthermiaBuff))) then
			if (((3252 - (73 + 156)) < (19 + 3851)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if (((954 - (721 + 90)) > (1 + 73)) and v88.Pyroblast:IsReady() and v45 and v13:BuffUp(v88.HotStreakBuff) and v117) then
			if (((58 - 40) < (2582 - (224 + 246))) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if (((1776 - 679) <= (2997 - 1369)) and v88.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v88.Scorch) and v13:BuffUp(v88.HeatingUpBuff) and (v124 < v98) and v117) then
			if (((111 + 4519) == (3401 + 1229)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((7038 - 3498) > (8928 - 6245)) and v88.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v122) and v117 and (v88.FireBlast:Charges() == (513 - (203 + 310))) and ((v88.PhoenixFlames:Charges() < v88.PhoenixFlames:MaxCharges()) or v88.AlexstraszasFury:IsAvailable()) and (v102 <= v124)) then
			if (((6787 - (1238 + 755)) >= (229 + 3046)) and v23(v88.ShiftingPower, not v14:IsInRange(1574 - (709 + 825)))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((2734 - 1250) == (2161 - 677)) and v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v124 >= v99)) then
			if (((2296 - (196 + 668)) < (14036 - 10481)) and v23(v90.FlamestrikeCursor, not v14:IsInRange(82 - 42))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and v13:BuffUp(v88.FuryoftheSunKingBuff) and (v13:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) or ((1898 - (171 + 662)) > (3671 - (4 + 89)))) then
			if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast)) or ((16806 - 12011) < (513 + 894))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if (((8138 - 6285) < (1888 + 2925)) and v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < ((1490 - (35 + 1451)) * v123)) and (v126 < v98)) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((4274 - (28 + 1425)) < (4424 - (941 + 1052)))) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and v13:HasTier(29 + 1, 1516 - (822 + 692)) and (v88.PhoenixFlames:TravelTime() < v13:BuffRemains(v88.CombustionBuff)) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) < (2 - 0)) and ((v14:DebuffRemains(v88.CharringEmbersDebuff) < ((2 + 2) * v123)) or (v13:BuffStack(v88.FlamesFuryBuff) > (298 - (45 + 252))) or v13:BuffUp(v88.FlamesFuryBuff))) or ((2844 + 30) < (751 + 1430))) then
			if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((6544 - 3855) <= (776 - (114 + 319)))) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if ((v88.Fireball:IsReady() and v40 and (v13:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime()) and v13:BuffUp(v88.FlameAccelerantBuff)) or ((2682 - 813) == (2573 - 564))) then
			if (v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball)) or ((2261 + 1285) < (3458 - 1136))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(62 - 32, 1965 - (556 + 1407)) and not v88.AlexstraszasFury:IsAvailable() and (v88.PhoenixFlames:TravelTime() < v13:BuffRemains(v88.CombustionBuff)) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) < (1208 - (741 + 465)))) or ((2547 - (170 + 295)) == (2515 + 2258))) then
			if (((2980 + 264) > (2597 - 1542)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v88.Scorch:IsReady() and v46 and (v13:BuffRemains(v88.CombustionBuff) > v88.Scorch:CastTime()) and (v88.Scorch:CastTime() >= v123)) or ((2747 + 566) <= (1141 + 637))) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((805 + 616) >= (3334 - (957 + 273)))) then
				return "scorch combustion_phase 44";
			end
		end
		if (((485 + 1327) <= (1301 + 1948)) and v88.Fireball:IsReady() and v40 and (v13:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime())) then
			if (((6184 - 4561) <= (5156 - 3199)) and v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((13476 - 9064) == (21846 - 17434)) and v88.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v88.CombustionBuff) < v123) and (v125 > (1781 - (389 + 1391)))) then
			if (((1098 + 652) >= (88 + 754)) and v23(v88.LivingBomb, not v14:IsSpellInRange(v88.LivingBomb))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v146()
		v113 = v88.Combustion:CooldownRemains() * v109;
		v114 = ((v88.Fireball:CastTime() * v27(v124 < v98)) + (v88.Flamestrike:CastTime() * v27(v124 >= v98))) - v103;
		v108 = v113;
		if (((9953 - 5581) > (2801 - (783 + 168))) and v88.Firestarter:IsAvailable() and not v95) then
			v108 = v29(v132(), v108);
		end
		if (((778 - 546) < (808 + 13)) and v88.SunKingsBlessing:IsAvailable() and v131() and v13:BuffDown(v88.FuryoftheSunKingBuff)) then
			v108 = v29((v115 - v13:BuffStack(v88.SunKingsBlessingBuff)) * (314 - (309 + 2)) * v123, v108);
		end
		v108 = v29(v13:BuffRemains(v88.CombustionBuff), v108);
		if (((1590 - 1072) < (2114 - (1090 + 122))) and (((v113 + ((39 + 81) * ((3 - 2) - ((0.4 + 0 + ((1118.2 - (628 + 490)) * v27(v88.Firestarter:IsAvailable()))) * v27(v88.Kindling:IsAvailable()))))) <= v108) or (v108 > (v122 - (4 + 16))))) then
			v108 = v113;
		end
	end
	local function v147()
		if (((7412 - 4418) > (3920 - 3062)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and v13:BuffDown(v88.HotStreakBuff) and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) == (775 - (431 + 343))) and (v88.ShiftingPower:CooldownUp() or (v88.FireBlast:Charges() > (1 - 0)) or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((5 - 3) * v123)))) then
			if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((2967 + 788) <= (118 + 797))) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if (((5641 - (556 + 1139)) > (3758 - (6 + 9))) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and ((v27(v13:BuffUp(v88.HeatingUpBuff)) + v138()) == (1 + 0)) and v88.ShiftingPower:CooldownUp() and (not v13:HasTier(16 + 14, 171 - (28 + 141)) or (v14:DebuffRemains(v88.CharringEmbersDebuff) > ((1 + 1) * v123)))) then
			if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((1647 - 312) >= (2342 + 964))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v148()
		if (((6161 - (486 + 831)) > (5862 - 3609)) and v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v96) and v136()) then
			if (((1591 - 1139) == (86 + 366)) and v23(v90.FlamestrikeCursor, not v14:IsInRange(126 - 86))) then
				return "flamestrike standard_rotation 2";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and (v136())) or ((5820 - (668 + 595)) < (1878 + 209))) then
			if (((782 + 3092) == (10564 - 6690)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true)) then
				return "pyroblast standard_rotation 4";
			end
		end
		if ((v33 and v88.Flamestrike:IsReady() and v41 and not v13:IsCasting(v88.Flamestrike) and (v124 >= v99) and v13:BuffUp(v88.FuryoftheSunKingBuff)) or ((2228 - (23 + 267)) > (6879 - (1129 + 815)))) then
			if (v23(v90.FlamestrikeCursor, not v14:IsInRange(427 - (371 + 16))) or ((6005 - (1326 + 424)) < (6482 - 3059))) then
				return "flamestrike standard_rotation 12";
			end
		end
		if (((5313 - 3859) <= (2609 - (88 + 30))) and v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < (v88.Pyroblast:CastTime() + ((776 - (720 + 51)) * v123))) and v13:BuffUp(v88.FuryoftheSunKingBuff) and not v13:IsCasting(v88.Scorch)) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((9247 - 5090) <= (4579 - (421 + 1355)))) then
				return "scorch standard_rotation 13";
			end
		end
		if (((8006 - 3153) >= (1465 + 1517)) and v88.Pyroblast:IsReady() and v45 and not v13:IsCasting(v88.Pyroblast) and (v13:BuffUp(v88.FuryoftheSunKingBuff))) then
			if (((5217 - (286 + 797)) > (12271 - 8914)) and v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true)) then
				return "pyroblast standard_rotation 14";
			end
		end
		if ((v88.FireBlast:IsReady() and v39 and not v136() and not v131() and not v112 and v13:BuffDown(v88.FuryoftheSunKingBuff) and ((((v13:IsCasting(v88.Fireball) and ((v88.Fireball:ExecuteRemains() < (0.5 - 0)) or not v88.Hyperthermia:IsAvailable())) or (v13:IsCasting(v88.Pyroblast) and ((v88.Pyroblast:ExecuteRemains() < (439.5 - (397 + 42))) or not v88.Hyperthermia:IsAvailable()))) and v13:BuffUp(v88.HeatingUpBuff)) or (v133() and (not v134() or (v14:DebuffStack(v88.ImprovedScorchDebuff) == v116) or (v88.FireBlast:FullRechargeTime() < (1 + 2))) and ((v13:BuffUp(v88.HeatingUpBuff) and not v13:IsCasting(v88.Scorch)) or (v13:BuffDown(v88.HotStreakBuff) and v13:BuffDown(v88.HeatingUpBuff) and v13:IsCasting(v88.Scorch) and (v138() == (800 - (24 + 776)))))))) or ((5263 - 1846) < (3319 - (222 + 563)))) then
			if (v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true) or ((5996 - 3274) <= (119 + 45))) then
				return "fire_blast standard_rotation 16";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and (v13:IsCasting(v88.Scorch) or v13:PrevGCDP(191 - (23 + 167), v88.Scorch)) and v13:BuffUp(v88.HeatingUpBuff) and v133() and (v124 < v96)) or ((4206 - (690 + 1108)) < (761 + 1348))) then
			if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true) or ((28 + 5) == (2303 - (40 + 808)))) then
				return "pyroblast standard_rotation 18";
			end
		end
		if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffRemains(v88.ImprovedScorchDebuff) < ((1 + 3) * v123))) or ((1693 - 1250) >= (3838 + 177))) then
			if (((1790 + 1592) > (92 + 74)) and v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch))) then
				return "scorch standard_rotation 19";
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and (not v88.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((573 - (47 + 524)) * v123)))) or ((182 + 98) == (8361 - 5302))) then
			if (((2812 - 931) > (2948 - 1655)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 20";
			end
		end
		if (((4083 - (1165 + 561)) == (71 + 2286)) and v88.PhoenixFlames:IsCastable() and v44 and v13:HasTier(92 - 62, 1 + 1) and (v14:DebuffRemains(v88.CharringEmbersDebuff) < ((481 - (341 + 138)) * v123)) and v13:BuffDown(v88.HotStreakBuff)) then
			if (((34 + 89) == (253 - 130)) and v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 21";
			end
		end
		if ((v88.Scorch:IsReady() and v46 and v134() and (v14:DebuffStack(v88.ImprovedScorchDebuff) < v116)) or ((1382 - (89 + 237)) >= (10911 - 7519))) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((2275 - 1194) < (1956 - (581 + 300)))) then
				return "scorch standard_rotation 22";
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and not v88.AlexstraszasFury:IsAvailable() and v13:BuffDown(v88.HotStreakBuff) and not v111 and v13:BuffUp(v88.FlamesFuryBuff)) or ((2269 - (855 + 365)) >= (10526 - 6094))) then
			if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((1557 + 3211) <= (2081 - (1030 + 205)))) then
				return "phoenix_flames standard_rotation 24";
			end
		end
		if ((v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and v13:BuffDown(v88.HotStreakBuff) and (v138() == (0 + 0)) and ((not v111 and v13:BuffUp(v88.FlamesFuryBuff)) or (v88.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v88.PhoenixFlames:ChargesFractional() > (287.5 - (156 + 130))) and (not v88.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v88.FeeltheBurnBuff) < ((6 - 3) * v123)))))) or ((5659 - 2301) <= (2908 - 1488))) then
			if (v23(v88.PhoenixFlames, not v14:IsSpellInRange(v88.PhoenixFlames)) or ((986 + 2753) <= (1753 + 1252))) then
				return "phoenix_flames standard_rotation 26";
			end
		end
		v31 = v143();
		if (v31 or ((1728 - (10 + 59)) >= (604 + 1530))) then
			return v31;
		end
		if ((v33 and v88.DragonsBreath:IsReady() and v38 and (v126 > (4 - 3)) and v88.AlexstraszasFury:IsAvailable()) or ((4423 - (671 + 492)) < (1875 + 480))) then
			if (v23(v88.DragonsBreath, not v14:IsInRange(1225 - (369 + 846))) or ((178 + 491) == (3604 + 619))) then
				return "dragons_breath standard_rotation 28";
			end
		end
		if ((v88.Scorch:IsReady() and v46 and (v133())) or ((3637 - (1036 + 909)) < (468 + 120))) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((8053 - 3256) < (3854 - (11 + 192)))) then
				return "scorch standard_rotation 30";
			end
		end
		if ((v33 and v88.ArcaneExplosion:IsReady() and v36 and (v127 >= v100) and (v13:ManaPercentageP() >= v101)) or ((2111 + 2066) > (5025 - (135 + 40)))) then
			if (v23(v88.ArcaneExplosion, not v14:IsInRange(19 - 11)) or ((242 + 158) > (2447 - 1336))) then
				return "arcane_explosion standard_rotation 32";
			end
		end
		if (((4573 - 1522) > (1181 - (50 + 126))) and v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v97)) then
			if (((10283 - 6590) <= (970 + 3412)) and v23(v90.FlamestrikeCursor, not v14:IsInRange(1453 - (1233 + 180)))) then
				return "flamestrike standard_rotation 34";
			end
		end
		if ((v88.Pyroblast:IsReady() and v45 and v88.TemperedFlames:IsAvailable() and v13:BuffDown(v88.FlameAccelerantBuff)) or ((4251 - (522 + 447)) > (5521 - (107 + 1314)))) then
			if (v23(v88.Pyroblast, not v14:IsSpellInRange(v88.Pyroblast), true) or ((1662 + 1918) < (8665 - 5821))) then
				return "pyroblast standard_rotation 35";
			end
		end
		if (((38 + 51) < (8916 - 4426)) and v88.Fireball:IsReady() and v40 and not v136()) then
			if (v23(v88.Fireball, not v14:IsSpellInRange(v88.Fireball), true) or ((19715 - 14732) < (3718 - (716 + 1194)))) then
				return "fireball standard_rotation 36";
			end
		end
	end
	local function v149()
		if (((66 + 3763) > (404 + 3365)) and not v94) then
			v146();
		end
		if (((1988 - (74 + 429)) <= (5601 - 2697)) and v34 and v86 and v88.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v88.TemporalWarp:IsAvailable() and (v131() or (v122 < (20 + 20)))) then
			if (((9771 - 5502) == (3021 + 1248)) and v23(v88.TimeWarp, not v14:IsInRange(123 - 83))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if (((956 - 569) <= (3215 - (279 + 154))) and (v74 < v122)) then
			if ((v81 and ((v34 and v82) or not v82)) or ((2677 - (454 + 324)) <= (722 + 195))) then
				v31 = v139();
				if (v31 or ((4329 - (12 + 5)) <= (473 + 403))) then
					return v31;
				end
			end
		end
		v110 = v108 > v88.ShiftingPower:CooldownRemains();
		v112 = v118 and (((v88.FireBlast:ChargesFractional() + ((v108 + (v135() * v27(v110))) / v88.FireBlast:Cooldown())) - (2 - 1)) < ((v88.FireBlast:MaxCharges() + (v104 / v88.FireBlast:Cooldown())) - (((5 + 7) / v88.FireBlast:Cooldown()) % (1094 - (277 + 816))))) and (v108 < v122);
		if (((9537 - 7305) <= (3779 - (1058 + 125))) and not v94 and ((v108 <= (0 + 0)) or v117 or ((v108 < v114) and (v88.Combustion:CooldownRemains() < v114)))) then
			local v204 = 975 - (815 + 160);
			while true do
				if (((8988 - 6893) < (8749 - 5063)) and ((0 + 0) == v204)) then
					v31 = v145();
					if (v31 or ((4662 - 3067) >= (6372 - (41 + 1857)))) then
						return v31;
					end
					break;
				end
			end
		end
		if ((not v112 and v88.SunKingsBlessing:IsAvailable()) or ((6512 - (1222 + 671)) < (7448 - 4566))) then
			v112 = v133() and (v88.FireBlast:FullRechargeTime() > ((3 - 0) * v123));
		end
		if ((v88.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v122) and v118 and ((v88.FireBlast:Charges() == (1182 - (229 + 953))) or v112) and (not v134() or ((v14:DebuffRemains(v88.ImprovedScorchDebuff) > (v88.ShiftingPower:CastTime() + v88.Scorch:CastTime())) and v13:BuffDown(v88.FuryoftheSunKingBuff))) and v13:BuffDown(v88.HotStreakBuff) and v110) or ((2068 - (1111 + 663)) >= (6410 - (874 + 705)))) then
			if (((285 + 1744) <= (2105 + 979)) and v23(v88.ShiftingPower, not v14:IsInRange(83 - 43), true)) then
				return "shifting_power main 12";
			end
		end
		if ((v124 < v98) or ((58 + 1979) == (3099 - (642 + 37)))) then
			v111 = (v88.SunKingsBlessing:IsAvailable() or (((v108 + 2 + 5) < ((v88.PhoenixFlames:FullRechargeTime() + v88.PhoenixFlames:Cooldown()) - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
		end
		if (((714 + 3744) > (9801 - 5897)) and (v124 >= v98)) then
			v111 = (v88.SunKingsBlessing:IsAvailable() or ((v108 < (v88.PhoenixFlames:FullRechargeTime() - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
		end
		if (((890 - (233 + 221)) >= (284 - 161)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (v108 > (0 + 0)) and (v124 >= v97) and not v131() and v13:BuffDown(v88.HotStreakBuff) and ((v13:BuffUp(v88.HeatingUpBuff) and (v88.Flamestrike:ExecuteRemains() < (1541.5 - (718 + 823)))) or (v88.FireBlast:ChargesFractional() >= (2 + 0)))) then
			if (((1305 - (266 + 539)) < (5141 - 3325)) and v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true)) then
				return "fire_blast main 14";
			end
		end
		if (((4799 - (636 + 589)) == (8483 - 4909)) and v118 and v131() and (v108 > (0 - 0))) then
			v31 = v147();
			if (((176 + 45) < (142 + 248)) and v31) then
				return v31;
			end
		end
		if ((v88.FireBlast:IsReady() and v39 and not v136() and v13:IsCasting(v88.ShiftingPower) and (v88.FireBlast:FullRechargeTime() < v120)) or ((3228 - (657 + 358)) <= (3762 - 2341))) then
			if (((6966 - 3908) < (6047 - (1151 + 36))) and v23(v88.FireBlast, not v14:IsSpellInRange(v88.FireBlast), nil, true)) then
				return "fire_blast main 16";
			end
		end
		if (((v108 > (0 + 0)) and v118) or ((341 + 955) >= (13277 - 8831))) then
			local v205 = 1832 - (1552 + 280);
			while true do
				if (((834 - (64 + 770)) == v205) or ((946 + 447) > (10190 - 5701))) then
					v31 = v148();
					if (v31 or ((786 + 3638) < (1270 - (157 + 1086)))) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v88.IceNova:IsCastable() and not v133()) or ((3996 - 1999) > (16708 - 12893))) then
			if (((5314 - 1849) > (2610 - 697)) and v23(v88.IceNova, not v14:IsSpellInRange(v88.IceNova))) then
				return "ice_nova main 18";
			end
		end
		if (((1552 - (599 + 220)) < (3621 - 1802)) and v88.Scorch:IsReady() and v46) then
			if (v23(v88.Scorch, not v14:IsSpellInRange(v88.Scorch)) or ((6326 - (1813 + 118)) == (3476 + 1279))) then
				return "scorch main 20";
			end
		end
	end
	local function v150()
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
		v60 = EpicSettings.Settings['alterTimeHP'] or (1217 - (841 + 376));
		v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v64 = EpicSettings.Settings['iceColdHP'] or (859 - (464 + 395));
		v65 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v66 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v84 = EpicSettings.Settings['mirrorImageBeforePull'];
		v85 = EpicSettings.Settings['useSpellStealTarget'];
		v86 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v87 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v151()
		local v196 = 837 - (467 + 370);
		while true do
			if ((v196 == (0 - 0)) or ((2785 + 1008) < (8120 - 5751))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v196 = 2 - 1;
			end
			if ((v196 == (523 - (150 + 370))) or ((5366 - (74 + 1208)) == (651 - 386))) then
				v83 = EpicSettings.Settings['racialsWithCD'];
				v76 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v196 = 18 - 14;
			end
			if (((3101 + 1257) == (4748 - (14 + 376))) and ((8 - 3) == v196)) then
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v196 == (2 + 0)) or ((2757 + 381) < (948 + 45))) then
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v196 = 8 - 5;
			end
			if (((2506 + 824) > (2401 - (23 + 55))) and (v196 == (9 - 5))) then
				v78 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v77 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v79 = EpicSettings.Settings['HealingPotionName'] or "";
				v196 = 7 - 2;
			end
			if ((v196 == (1 + 0)) or ((4527 - (652 + 249)) == (10675 - 6686))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v67 = EpicSettings.Settings['DispelBuffs'];
				v196 = 1870 - (708 + 1160);
			end
		end
	end
	local function v152()
		v150();
		v151();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (v13:IsDeadOrGhost() or ((2486 - 1570) == (4869 - 2198))) then
			return v31;
		end
		v129 = v14:GetEnemiesInSplashRange(32 - (10 + 17));
		v128 = v13:GetEnemiesInRange(9 + 31);
		if (((2004 - (1400 + 332)) == (521 - 249)) and v33) then
			local v206 = 1908 - (242 + 1666);
			while true do
				if (((1819 + 2430) <= (1774 + 3065)) and ((0 + 0) == v206)) then
					v124 = v29(v14:GetEnemiesInSplashRangeCount(945 - (850 + 90)), #v128);
					v125 = v29(v14:GetEnemiesInSplashRangeCount(8 - 3), #v128);
					v206 = 1391 - (360 + 1030);
				end
				if (((2458 + 319) < (9032 - 5832)) and ((1 - 0) == v206)) then
					v126 = v29(v14:GetEnemiesInSplashRangeCount(1666 - (909 + 752)), #v128);
					v127 = #v128;
					break;
				end
			end
		else
			v124 = 1224 - (109 + 1114);
			v125 = 1 - 0;
			v126 = 1 + 0;
			v127 = 243 - (6 + 236);
		end
		if (((60 + 35) < (1576 + 381)) and (v92.TargetIsValid() or v13:AffectingCombat())) then
			if (((1947 - 1121) < (2998 - 1281)) and (v13:AffectingCombat() or v68)) then
				local v223 = v68 and v88.RemoveCurse:IsReady() and v35;
				v31 = v92.FocusUnit(v223, v90, 1153 - (1076 + 57), nil, 4 + 16);
				if (((2115 - (579 + 110)) >= (88 + 1017)) and v31) then
					return v31;
				end
			end
			v121 = v9.BossFightRemains(nil, true);
			v122 = v121;
			if (((2435 + 319) <= (1794 + 1585)) and (v122 == (11518 - (174 + 233)))) then
				v122 = v9.FightRemains(v128, false);
			end
			v130 = v137(v128);
			v94 = not v34;
			if (v94 or ((10969 - 7042) == (2479 - 1066))) then
				v108 = 44468 + 55531;
			end
			v123 = v13:GCD();
			v117 = v13:BuffUp(v88.CombustionBuff);
			v118 = not v117;
		end
		if ((not v13:AffectingCombat() and v32) or ((2328 - (663 + 511)) <= (703 + 85))) then
			local v207 = 0 + 0;
			while true do
				if ((v207 == (0 - 0)) or ((995 + 648) > (7954 - 4575))) then
					v31 = v142();
					if (v31 or ((6785 - 3982) > (2171 + 2378))) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v13:AffectingCombat() and v92.TargetIsValid()) or ((428 - 208) >= (2154 + 868))) then
			if (((258 + 2564) == (3544 - (478 + 244))) and v68 and v35 and v88.RemoveCurse:IsAvailable()) then
				local v224 = 517 - (440 + 77);
				while true do
					if ((v224 == (0 + 0)) or ((3883 - 2822) == (3413 - (655 + 901)))) then
						if (((512 + 2248) > (1045 + 319)) and v15) then
							v31 = v140();
							if (v31 or ((3310 + 1592) <= (14482 - 10887))) then
								return v31;
							end
						end
						if ((v17 and v17:Exists() and v17:IsAPlayer() and v92.UnitHasCurseDebuff(v17)) or ((5297 - (695 + 750)) == (1000 - 707))) then
							if (v88.RemoveCurse:IsReady() or ((2405 - 846) == (18451 - 13863))) then
								if (v23(v90.RemoveCurseMouseover) or ((4835 - (285 + 66)) == (1836 - 1048))) then
									return "remove_curse dispel";
								end
							end
						end
						break;
					end
				end
			end
			v31 = v141();
			if (((5878 - (682 + 628)) >= (630 + 3277)) and v31) then
				return v31;
			end
			if (((1545 - (176 + 123)) < (1452 + 2018)) and v69) then
				if (((2951 + 1117) >= (1241 - (239 + 30))) and v87) then
					local v228 = 0 + 0;
					while true do
						if (((474 + 19) < (6889 - 2996)) and (v228 == (0 - 0))) then
							v31 = v92.HandleAfflicted(v88.RemoveCurse, v90.RemoveCurseMouseover, 345 - (306 + 9));
							if (v31 or ((5140 - 3667) >= (580 + 2752))) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if (v70 or ((2486 + 1565) <= (557 + 600))) then
				local v225 = 0 - 0;
				while true do
					if (((1979 - (1140 + 235)) < (1834 + 1047)) and (v225 == (0 + 0))) then
						v31 = v92.HandleIncorporeal(v88.Polymorph, v90.PolymorphMouseOver, 8 + 22, true);
						if (v31 or ((952 - (33 + 19)) == (1220 + 2157))) then
							return v31;
						end
						break;
					end
				end
			end
			if (((13364 - 8905) > (261 + 330)) and v88.Spellsteal:IsAvailable() and v85 and v88.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v92.UnitHasMagicBuff(v14)) then
				if (((6663 - 3265) >= (2246 + 149)) and v23(v88.Spellsteal, not v14:IsSpellInRange(v88.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if (((v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v88.HotStreakBuff)) or ((2872 - (586 + 103)) >= (258 + 2566))) then
				if (((5960 - 4024) == (3424 - (1309 + 179))) and v23(v90.StopCasting, not v14:IsSpellInRange(v88.Pyroblast))) then
					return "Stop Casting";
				end
			end
			if ((v13:IsMoving() and v88.IceFloes:IsReady()) or ((8722 - 3890) < (1878 + 2435))) then
				if (((10978 - 6890) > (2927 + 947)) and v23(v88.IceFloes)) then
					return "ice_floes movement";
				end
			end
			v31 = v149();
			if (((9203 - 4871) == (8631 - 4299)) and v31) then
				return v31;
			end
		end
	end
	local function v153()
		v93();
		v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(672 - (295 + 314), v152, v153);
end;
return v0["Epix_Mage_Fire.lua"]();

