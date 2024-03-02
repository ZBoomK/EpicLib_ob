local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1994 + 140) == (2658 - (446 + 78))) and not v5) then
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
	local v88;
	local v89 = v18.Mage.Fire;
	local v90 = v20.Mage.Fire;
	local v91 = v25.Mage.Fire;
	local v92 = {};
	local v93 = v21.Commons.Everyone;
	local function v94()
		if (v89.RemoveCurse:IsAvailable() or ((3158 - (771 + 233)) >= (5230 - (830 + 1075)))) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (528 - (303 + 221))) or (2268 - (231 + 1038));
	local v98 = 833 + 166;
	local v99 = v97;
	local v100 = ((1165 - (171 + 991)) * v27(v89.FueltheFire:IsAvailable())) + ((4116 - 3117) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 2682 - 1683;
	local v102 = 99 - 59;
	local v103 = 800 + 199;
	local v104 = 0.3 - 0;
	local v105 = 0 - 0;
	local v106 = 9 - 3;
	local v107 = false;
	local v108 = (v107 and (61 - 41)) or (1248 - (111 + 1137));
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (158.4 - (91 + 67))) or (2 - 1);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 + 0;
	local v115 = 523 - (423 + 100);
	local v116 = 1 + 7;
	local v117 = 7 - 4;
	local v118;
	local v119;
	local v120;
	local v121 = 2 + 1;
	local v122 = 11882 - (326 + 445);
	local v123 = 48488 - 37377;
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v9:RegisterForEvent(function()
		v107 = false;
		v108 = (v107 and (44 - 24)) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v156 = 711 - (530 + 181);
		while true do
			if ((v156 == (883 - (614 + 267))) or ((1327 - (19 + 13)) >= (5261 - 2028))) then
				v89.PhoenixFlames:RegisterInFlightEffect(600160 - 342618);
				v89.PhoenixFlames:RegisterInFlight();
				v156 = 8 - 5;
			end
			if (((1137 + 3240) > (2887 - 1245)) and (v156 == (1 - 0))) then
				v89.Meteor:RegisterInFlightEffect(352952 - (1293 + 519));
				v89.Meteor:RegisterInFlight();
				v156 = 3 - 1;
			end
			if (((12331 - 7608) > (2592 - 1236)) and (v156 == (12 - 9))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if ((v156 == (0 - 0)) or ((2191 + 1945) <= (701 + 2732))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v156 = 2 - 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(81142 + 269998);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(85558 + 171984);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		v122 = 6944 + 4167;
		v123 = 12207 - (709 + 387);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v96 = v89.SunKingsBlessing:IsAvailable();
		v97 = ((v89.FlamePatch:IsAvailable()) and (1861 - (673 + 1185))) or (2896 - 1897);
		v99 = v97;
		v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (65 + 25));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (68 + 22)) and v14:TimeToX(121 - 31)) or (0 + 0))) or (0 - 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (58 - 28));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (1910 - (446 + 1434)));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v157 = 1283 - (1040 + 243);
		local v158;
		while true do
			if (((12669 - 8424) <= (6478 - (559 + 1288))) and (v157 == (1932 - (609 + 1322)))) then
				return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast) or (v158 > (454 - (13 + 441)))))));
			end
			if (((15978 - 11702) >= (10252 - 6338)) and (v157 == (0 - 0))) then
				v158 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 + 0);
				v158 = v158 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(3 - 2, v89.PhoenixFlames));
				v157 = 1 + 0;
			end
		end
	end
	local function v138(v159)
		local v160 = 0 + 0;
		for v190, v191 in pairs(v159) do
			if (((587 - 389) <= (2389 + 1976)) and v191:DebuffUp(v89.IgniteDebuff)) then
				v160 = v160 + (1 - 0);
			end
		end
		return v160;
	end
	local function v139()
		local v161 = 0 + 0;
		local v162;
		while true do
			if (((2660 + 2122) > (3360 + 1316)) and ((1 + 0) == v161)) then
				return v162;
			end
			if (((4759 + 105) > (2630 - (153 + 280))) and (v161 == (0 - 0))) then
				v162 = 0 + 0;
				if (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight() or ((1461 + 2239) == (1312 + 1195))) then
					v162 = v162 + 1 + 0;
				end
				v161 = 1 + 0;
			end
		end
	end
	local function v140()
		local v163 = 0 - 0;
		while true do
			if (((2766 + 1708) >= (941 - (89 + 578))) and (v163 == (1 + 0))) then
				v31 = v93.HandleBottomTrinket(v92, v34, 83 - 43, nil);
				if (v31 or ((2943 - (572 + 477)) <= (190 + 1216))) then
					return v31;
				end
				break;
			end
			if (((944 + 628) >= (183 + 1348)) and (v163 == (86 - (84 + 2)))) then
				v31 = v93.HandleTopTrinket(v92, v34, 65 - 25, nil);
				if (v31 or ((3377 + 1310) < (5384 - (497 + 345)))) then
					return v31;
				end
				v163 = 1 + 0;
			end
		end
	end
	local v141 = 0 + 0;
	local function v142()
		if (((4624 - (605 + 728)) > (1190 + 477)) and v89.RemoveCurse:IsReady() and v93.DispellableFriendlyUnit(44 - 24)) then
			local v194 = 0 + 0;
			while true do
				if (((0 - 0) == v194) or ((788 + 85) == (5635 - 3601))) then
					if ((v141 == (0 + 0)) or ((3305 - (457 + 32)) < (5 + 6))) then
						v141 = GetTime();
					end
					if (((5101 - (832 + 570)) < (4434 + 272)) and v93.Wait(131 + 369, v141)) then
						local v230 = 0 - 0;
						while true do
							if (((1275 + 1371) >= (1672 - (588 + 208))) and (v230 == (0 - 0))) then
								if (((2414 - (884 + 916)) <= (6665 - 3481)) and v23(v91.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v141 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v143()
		local v164 = 653 - (232 + 421);
		while true do
			if (((5015 - (1569 + 320)) == (767 + 2359)) and (v164 == (0 + 0))) then
				if ((v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((7369 - 5182) >= (5559 - (316 + 289)))) then
					if (v23(v89.BlazingBarrier) or ((10148 - 6271) == (166 + 3409))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((2160 - (666 + 787)) > (1057 - (360 + 65))) and v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 2 + 0, v89.ArcaneIntellect)) then
					if (v23(v89.MassBarrier) or ((800 - (79 + 175)) >= (4231 - 1547))) then
						return "mass_barrier defensive 2";
					end
				end
				v164 = 1 + 0;
			end
			if (((4490 - 3025) <= (8282 - 3981)) and ((901 - (503 + 396)) == v164)) then
				if (((1885 - (92 + 89)) > (2764 - 1339)) and v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) then
					if (v23(v89.MirrorImage) or ((353 + 334) == (2506 + 1728))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) or ((13040 - 9710) < (196 + 1233))) then
					if (((2615 - 1468) >= (293 + 42)) and v23(v89.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v164 = 2 + 1;
			end
			if (((10461 - 7026) > (262 + 1835)) and (v164 == (5 - 1))) then
				if ((v76 and (v13:HealthPercentage() <= v78)) or ((5014 - (485 + 759)) >= (9350 - 5309))) then
					local v227 = 1189 - (442 + 747);
					while true do
						if ((v227 == (1135 - (832 + 303))) or ((4737 - (88 + 858)) <= (492 + 1119))) then
							if ((v80 == "Refreshing Healing Potion") or ((3789 + 789) <= (83 + 1925))) then
								if (((1914 - (766 + 23)) <= (10248 - 8172)) and v90.RefreshingHealingPotion:IsReady()) then
									if (v23(v91.RefreshingHealingPotion) or ((1015 - 272) >= (11589 - 7190))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((3920 - 2765) < (2746 - (1036 + 37))) and (v80 == "Dreamwalker's Healing Potion")) then
								if (v90.DreamwalkersHealingPotion:IsReady() or ((1648 + 676) <= (1125 - 547))) then
									if (((2964 + 803) == (5247 - (641 + 839))) and v23(v91.RefreshingHealingPotion)) then
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
			if (((5002 - (910 + 3)) == (10423 - 6334)) and (v164 == (1685 - (1466 + 218)))) then
				if (((2049 + 2409) >= (2822 - (556 + 592))) and v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) then
					if (((346 + 626) <= (2226 - (329 + 479))) and v23(v89.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) or ((5792 - (174 + 680)) < (16362 - 11600))) then
					if (v23(v89.IceColdAbility) or ((5189 - 2685) > (3045 + 1219))) then
						return "ice_cold defensive 3";
					end
				end
				v164 = 741 - (396 + 343);
			end
			if (((191 + 1962) == (3630 - (29 + 1448))) and (v164 == (1392 - (135 + 1254)))) then
				if ((v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) or ((1909 - 1402) >= (12097 - 9506))) then
					if (((2987 + 1494) == (6008 - (389 + 1138))) and v23(v89.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) or ((2902 - (102 + 472)) < (654 + 39))) then
					if (((2401 + 1927) == (4036 + 292)) and v23(v91.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v164 = 1549 - (320 + 1225);
			end
		end
	end
	local function v144()
		local v165 = 0 - 0;
		while true do
			if (((972 + 616) >= (2796 - (157 + 1307))) and (v165 == (1860 - (821 + 1038)))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) or ((10413 - 6239) > (465 + 3783))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((8145 - 3559) <= (31 + 51))) then
						return "pyroblast precombat 4";
					end
				end
				if (((9574 - 5711) == (4889 - (834 + 192))) and v89.Fireball:IsReady() and v40) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true) or ((18 + 264) <= (11 + 31))) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if (((99 + 4510) >= (1186 - 420)) and (v165 == (304 - (300 + 4)))) then
				if ((v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) or ((308 + 844) == (6512 - 4024))) then
					if (((3784 - (112 + 250)) > (1336 + 2014)) and v23(v89.ArcaneIntellect)) then
						return "arcane_intellect precombat 2";
					end
				end
				if (((2196 - 1319) > (216 + 160)) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) then
					if (v23(v89.MirrorImage) or ((1613 + 1505) <= (1385 + 466))) then
						return "mirror_image precombat 2";
					end
				end
				v165 = 1 + 0;
			end
		end
	end
	local function v145()
		if ((v89.LivingBomb:IsReady() and v42 and (v126 > (1 + 0)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (1414 - (1001 + 413))))) or ((367 - 202) >= (4374 - (244 + 638)))) then
			if (((4642 - (627 + 66)) < (14469 - 9613)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb))) then
				return "living_bomb active_talents 2";
			end
		end
		if ((v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (602 - (512 + 90))) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((1951 - (1665 + 241)) < v109) or (v123 < v109))))) or ((4993 - (373 + 344)) < (1361 + 1655))) then
			if (((1241 + 3449) > (10880 - 6755)) and v23(v91.MeteorCursor, not v14:IsInRange(67 - 27))) then
				return "meteor active_talents 4";
			end
		end
		if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (1114 - (35 + 1064)))) and not v135() and (v133() == (0 + 0)) and not v89.TemperedFlames:IsAvailable()) or ((106 - 56) >= (4 + 892))) then
			if (v23(v89.DragonsBreath, not v14:IsInRange(1246 - (298 + 938))) or ((2973 - (233 + 1026)) >= (4624 - (636 + 1030)))) then
				return "dragons_breath active_talents 6";
			end
		end
		if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (8 + 7))) and not v135() and v89.TemperedFlames:IsAvailable()) or ((1457 + 34) < (192 + 452))) then
			if (((48 + 656) < (1208 - (55 + 166))) and v23(v89.DragonsBreath, not v14:IsInRange(2 + 8))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v146()
		local v166 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
		if (((374 + 3344) > (7278 - 5372)) and v166) then
			return v166;
		end
		if ((v81 and ((v84 and v34) or not v84) and (v74 < v123)) or ((1255 - (36 + 261)) > (6356 - 2721))) then
			local v195 = 1368 - (34 + 1334);
			while true do
				if (((1346 + 2155) <= (3491 + 1001)) and (v195 == (1284 - (1035 + 248)))) then
					if (v89.Fireblood:IsCastable() or ((3463 - (20 + 1)) < (1328 + 1220))) then
						if (((3194 - (134 + 185)) >= (2597 - (549 + 584))) and v23(v89.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (v89.AncestralCall:IsCastable() or ((5482 - (314 + 371)) >= (16797 - 11904))) then
						if (v23(v89.AncestralCall) or ((1519 - (478 + 490)) > (1096 + 972))) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
				if (((3286 - (786 + 386)) > (3057 - 2113)) and (v195 == (1379 - (1055 + 324)))) then
					if (v89.BloodFury:IsCastable() or ((3602 - (1093 + 247)) >= (2752 + 344))) then
						if (v23(v89.BloodFury) or ((238 + 2017) >= (14042 - 10505))) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if ((v89.Berserking:IsCastable() and v118) or ((13021 - 9184) < (3716 - 2410))) then
						if (((7413 - 4463) == (1050 + 1900)) and v23(v89.Berserking)) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v195 = 3 - 2;
				end
			end
		end
		if ((v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) or ((16278 - 11555) < (2487 + 811))) then
			if (((2905 - 1769) >= (842 - (364 + 324))) and v23(v89.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v74 < v123) or ((742 - 471) > (11393 - 6645))) then
			if (((1571 + 3169) >= (13188 - 10036)) and v82 and ((v34 and v83) or not v83)) then
				v31 = v140();
				if (v31 or ((4128 - 1550) >= (10295 - 6905))) then
					return v31;
				end
			end
		end
	end
	local function v147()
		local v167 = 1268 - (1249 + 19);
		while true do
			if (((38 + 3) <= (6465 - 4804)) and (v167 == (1092 - (686 + 400)))) then
				if (((472 + 129) < (3789 - (73 + 156))) and v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
					if (((2 + 233) < (1498 - (721 + 90))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((52 + 4497) > (3743 - 2590)) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball)) or ((5144 - (224 + 246)) < (7568 - 2896))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((6753 - 3085) < (828 + 3733)) and v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (1 + 0))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((335 + 120) == (7167 - 3562))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if ((v167 == (12 - 8)) or ((3176 - (203 + 310)) == (5305 - (1238 + 755)))) then
				if (((299 + 3978) <= (6009 - (709 + 825))) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 - 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast)) or ((1267 - 397) == (2053 - (196 + 668)))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((6131 - 4578) <= (6489 - 3356)) and v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (833 - (171 + 662))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(133 - (4 + 89))) or ((7840 - 5603) >= (1279 + 2232))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((5815 - 4491) > (1185 + 1835))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(1526 - (35 + 1451))) or ((4445 - (28 + 1425)) == (3874 - (941 + 1052)))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if (((2979 + 127) > (3040 - (822 + 692))) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (((4314 - 1291) < (1823 + 2047)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v167 = 302 - (45 + 252);
			end
			if (((142 + 1) > (26 + 48)) and (v167 == (4 - 2))) then
				if (((451 - (114 + 319)) < (3031 - 919)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) then
					if (((1405 - 308) <= (1038 + 590)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(59 - 19))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if (((9701 - 5071) == (6593 - (556 + 1407))) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (((4746 - (741 + 465)) > (3148 - (170 + 295))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((2526 + 2268) >= (3009 + 266)) and v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (4 - 2)) and not v135()) then
					if (((1231 + 253) == (952 + 532)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
						return "fireball combustion_phase 16";
					end
				end
				if (((811 + 621) < (4785 - (957 + 273))) and v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((285 + 780) > (1433 + 2145))) then
						return "scorch combustion_phase 18";
					end
				end
				v167 = 11 - 8;
			end
			if ((v167 == (0 - 0)) or ((14646 - 9851) < (6967 - 5560))) then
				if (((3633 - (389 + 1391)) < (3020 + 1793)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment)) or ((294 + 2527) < (5534 - 3103))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if ((v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) or ((3825 - (783 + 168)) < (7319 - 5138))) then
					if (v23(v89.BagofTricks) or ((2645 + 44) <= (654 - (309 + 2)))) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v89.LivingBomb:IsReady() and v33 and v42 and (v126 > (2 - 1)) and v119) or ((3081 - (1090 + 122)) == (652 + 1357))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((11909 - 8363) < (1590 + 732))) then
						return "living_bomb combustion_phase 6";
					end
				end
				if ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (1138 - (628 + 490))) or ((374 + 1708) == (11817 - 7044))) then
					local v228 = 0 - 0;
					while true do
						if (((4018 - (431 + 343)) > (2130 - 1075)) and (v228 == (0 - 0))) then
							v31 = v146();
							if (v31 or ((2618 + 695) <= (228 + 1550))) then
								return v31;
							end
							break;
						end
					end
				end
				v167 = 1696 - (556 + 1139);
			end
			if (((20 - (6 + 9)) == v167) or ((261 + 1160) >= (1078 + 1026))) then
				if (((1981 - (28 + 141)) <= (1259 + 1990)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((4 - 0) * v124)) and (v127 < v99)) then
					if (((1150 + 473) <= (3274 - (486 + 831))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch combustion_phase 36";
					end
				end
				if (((11480 - 7068) == (15532 - 11120)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(6 + 24, 6 - 4) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1265 - (668 + 595))) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((4 + 0) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (1 + 0)) or v13:BuffUp(v89.FlamesFuryBuff))) then
					if (((4772 - 3022) >= (1132 - (23 + 267))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((6316 - (1129 + 815)) > (2237 - (371 + 16))) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) then
					if (((1982 - (1326 + 424)) < (1554 - 733)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
						return "fireball combustion_phase 40";
					end
				end
				if (((1892 - 1374) < (1020 - (88 + 30))) and v89.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(801 - (720 + 51), 4 - 2) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1778 - (421 + 1355)))) then
					if (((4938 - 1944) > (422 + 436)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v167 = 1089 - (286 + 797);
			end
			if (((10 - 7) == v167) or ((6219 - 2464) <= (1354 - (397 + 42)))) then
				if (((1233 + 2713) > (4543 - (24 + 776))) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((5 - 1) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (785 - (222 + 563))))) < (3 - 1))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((962 + 373) >= (3496 - (23 + 167)))) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((6642 - (690 + 1108)) > (813 + 1440)) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
					if (((373 + 79) == (1300 - (40 + 808))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(7 + 33))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) or ((17425 - 12868) < (1995 + 92))) then
					if (((2050 + 1824) == (2125 + 1749)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) or ((2509 - (47 + 524)) > (3203 + 1732))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast)) or ((11631 - 7376) < (5118 - 1695))) then
						return "pyroblast combustion_phase 26";
					end
				end
				v167 = 8 - 4;
			end
			if (((3180 - (1165 + 561)) <= (74 + 2417)) and (v167 == (3 - 2))) then
				if ((v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(12 + 18, 481 - (341 + 138)) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((2 + 2) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((8578 - 4421) <= (3129 - (89 + 237)))) then
					if (((15611 - 10758) >= (6277 - 3295)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v145();
				if (((5015 - (581 + 300)) > (4577 - (855 + 365))) and v31) then
					return v31;
				end
				if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 + 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((4652 - (1030 + 205)) < (2379 + 155))) then
					if (v23(v89.Combustion, not v14:IsInRange(38 + 2), nil, true) or ((3008 - (156 + 130)) <= (372 - 208))) then
						return "combustion combustion_phase 10";
					end
				end
				v167 = 2 - 0;
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v125 < v99)) + (v89.Flamestrike:CastTime() * v27(v125 >= v99))) - v104;
		v109 = v114;
		if ((v89.Firestarter:IsAvailable() and not v96) or ((4931 - 2523) < (556 + 1553))) then
			v109 = v29(v133(), v109);
		end
		if ((v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) or ((20 + 13) == (1524 - (10 + 59)))) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (1 + 2) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((v114 + ((590 - 470) * ((1164 - (671 + 492)) - ((0.4 + 0 + ((1215.2 - (369 + 846)) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (6 + 14))) or ((379 + 64) >= (5960 - (1036 + 909)))) then
			v109 = v114;
		end
	end
	local function v149()
		local v168 = 0 + 0;
		while true do
			if (((5677 - 2295) > (369 - (11 + 192))) and (v168 == (0 + 0))) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (176 - (135 + 40))) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (2 - 1)) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 0) * v124)))) or ((616 - 336) == (4585 - 1526))) then
					if (((2057 - (50 + 126)) > (3600 - 2307)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((522 + 1835) == (3770 - (1233 + 180))) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (970 - (522 + 447))) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(1451 - (107 + 1314), 1 + 1) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((5 - 3) * v124)))) then
					if (((53 + 70) == (244 - 121)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v150()
		if ((v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v97) and v137()) or ((4178 - 3122) >= (5302 - (716 + 1194)))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(1 + 39)) or ((116 + 965) < (1578 - (74 + 429)))) then
				return "flamestrike standard_rotation 2";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and (v137())) or ((2022 - 973) >= (2197 + 2235))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((10914 - 6146) <= (599 + 247))) then
				return "pyroblast standard_rotation 4";
			end
		end
		if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v125 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) or ((10352 - 6994) <= (3511 - 2091))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(473 - (279 + 154))) or ((4517 - (454 + 324)) <= (2365 + 640))) then
				return "flamestrike standard_rotation 12";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((22 - (12 + 5)) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((895 + 764) >= (5437 - 3303))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((1205 + 2055) < (3448 - (277 + 816)))) then
				return "scorch standard_rotation 13";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((2858 - 2189) == (5406 - (1058 + 125)))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((318 + 1374) < (1563 - (815 + 160)))) then
				return "pyroblast standard_rotation 14";
			end
		end
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and ((((v13:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 - 0)) or not v89.Hyperthermia:IsAvailable())) or (v13:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (0.5 - 0)) or not v89.Hyperthermia:IsAvailable()))) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (1 + 2))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (0 - 0))))))) or ((6695 - (41 + 1857)) < (5544 - (1222 + 671)))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((10795 - 6618) > (6971 - 2121))) then
				return "fire_blast standard_rotation 16";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(1183 - (229 + 953), v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((2174 - (1111 + 663)) > (2690 - (874 + 705)))) then
			if (((428 + 2623) > (686 + 319)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
				return "pyroblast standard_rotation 18";
			end
		end
		if (((7676 - 3983) <= (124 + 4258)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((683 - (642 + 37)) * v124))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((749 + 2533) > (656 + 3444))) then
				return "scorch standard_rotation 19";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((4 - 2) * v124)))) or ((4034 - (233 + 221)) < (6576 - 3732))) then
			if (((79 + 10) < (6031 - (718 + 823))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 20";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(19 + 11, 807 - (266 + 539)) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((5 - 3) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((6208 - (636 + 589)) < (4291 - 2483))) then
			if (((7897 - 4068) > (2987 + 782)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 21";
			end
		end
		if (((540 + 945) <= (3919 - (657 + 358))) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) then
			if (((11303 - 7034) == (9725 - 5456)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
				return "scorch standard_rotation 22";
			end
		end
		if (((1574 - (1151 + 36)) <= (2687 + 95)) and v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((500 + 1399) <= (2738 - 1821))) then
				return "phoenix_flames standard_rotation 24";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (1832 - (1552 + 280))) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (836.5 - (64 + 770))) or ((v89.PhoenixFlames:ChargesFractional() > (1.5 + 0)) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((6 - 3) * v124)))))) or ((766 + 3546) <= (2119 - (157 + 1086)))) then
			if (((4466 - 2234) <= (11369 - 8773)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 26";
			end
		end
		v31 = v145();
		if (((3213 - 1118) < (5030 - 1344)) and v31) then
			return v31;
		end
		if ((v33 and v89.DragonsBreath:IsReady() and v38 and (v127 > (820 - (599 + 220))) and v89.AlexstraszasFury:IsAvailable()) or ((3175 - 1580) >= (6405 - (1813 + 118)))) then
			if (v23(v89.DragonsBreath, not v14:IsInRange(8 + 2)) or ((5836 - (841 + 376)) < (4037 - 1155))) then
				return "dragons_breath standard_rotation 28";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and (v134())) or ((69 + 225) >= (13186 - 8355))) then
			if (((2888 - (464 + 395)) <= (7914 - 4830)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
				return "scorch standard_rotation 30";
			end
		end
		if ((v33 and v89.ArcaneExplosion:IsReady() and v36 and (v128 >= v101) and (v13:ManaPercentageP() >= v102)) or ((979 + 1058) == (3257 - (467 + 370)))) then
			if (((9212 - 4754) > (2866 + 1038)) and v23(v89.ArcaneExplosion, not v14:IsInRange(27 - 19))) then
				return "arcane_explosion standard_rotation 32";
			end
		end
		if (((69 + 367) >= (285 - 162)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v98)) then
			if (((1020 - (150 + 370)) < (3098 - (74 + 1208))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(98 - 58))) then
				return "flamestrike standard_rotation 34";
			end
		end
		if (((16950 - 13376) == (2544 + 1030)) and v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) then
			if (((611 - (14 + 376)) < (676 - 286)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
				return "pyroblast standard_rotation 35";
			end
		end
		if ((v89.Fireball:IsReady() and v40 and not v137()) or ((1432 + 781) <= (1249 + 172))) then
			if (((2917 + 141) < (14240 - 9380)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true)) then
				return "fireball standard_rotation 36";
			end
		end
	end
	local function v151()
		local v169 = 0 + 0;
		while true do
			if ((v169 == (78 - (23 + 55))) or ((3071 - 1775) >= (2967 + 1479))) then
				if (not v95 or ((1251 + 142) > (6959 - 2470))) then
					v148();
				end
				if ((v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (13 + 27)))) or ((5325 - (652 + 249)) < (72 - 45))) then
					if (v23(v89.TimeWarp, not v14:IsInRange(1908 - (708 + 1160))) or ((5420 - 3423) > (6955 - 3140))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((3492 - (10 + 17)) > (430 + 1483)) and (v74 < v123)) then
					if (((2465 - (1400 + 332)) < (3488 - 1669)) and v82 and ((v34 and v83) or not v83)) then
						v31 = v140();
						if (v31 or ((6303 - (242 + 1666)) == (2035 + 2720))) then
							return v31;
						end
					end
				end
				v169 = 1 + 0;
			end
			if ((v169 == (5 + 0)) or ((4733 - (850 + 90)) < (4148 - 1779))) then
				if ((v89.Scorch:IsReady() and v46) or ((5474 - (360 + 1030)) == (235 + 30))) then
					if (((12300 - 7942) == (5995 - 1637)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v169 == (1664 - (909 + 752))) or ((4361 - (109 + 1114)) < (1817 - 824))) then
				if (((1297 + 2033) > (2565 - (6 + 236))) and (v125 >= v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (0 + 0)) and (v125 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v89.FireBlast:ChargesFractional() >= (4 - 2)))) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((151 + 765) == (3360 - (579 + 110)))) then
						return "fire_blast main 14";
					end
				end
				if (((22 + 250) == (241 + 31)) and v119 and v132() and (v109 > (0 + 0))) then
					local v229 = 407 - (174 + 233);
					while true do
						if (((11868 - 7619) <= (8492 - 3653)) and (v229 == (0 + 0))) then
							v31 = v149();
							if (((3951 - (663 + 511)) < (2855 + 345)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v169 = 1 + 3;
			end
			if (((292 - 197) < (1186 + 771)) and ((2 - 1) == v169)) then
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (2 - 1)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((6 + 6) / v89.FireBlast:Cooldown()) % (1 - 0)))) and (v109 < v123);
				if (((589 + 237) < (157 + 1560)) and not v95 and ((v109 <= (722 - (478 + 244))) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) then
					v31 = v147();
					if (((1943 - (440 + 77)) >= (503 + 602)) and v31) then
						return v31;
					end
				end
				v169 = 7 - 5;
			end
			if (((4310 - (655 + 901)) <= (627 + 2752)) and (v169 == (4 + 0))) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) or ((2652 + 1275) == (5692 - 4279))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((2599 - (695 + 750)) <= (2690 - 1902))) then
						return "fire_blast main 16";
					end
				end
				if (((v109 > (0 - 0)) and v119) or ((6607 - 4964) > (3730 - (285 + 66)))) then
					v31 = v150();
					if (v31 or ((6533 - 3730) > (5859 - (682 + 628)))) then
						return v31;
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((36 + 184) >= (3321 - (176 + 123)))) then
					if (((1181 + 1641) == (2048 + 774)) and v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v169 = 274 - (239 + 30);
			end
			if ((v169 == (1 + 1)) or ((1020 + 41) == (3286 - 1429))) then
				if (((8610 - 5850) > (1679 - (306 + 9))) and not v113 and v89.SunKingsBlessing:IsAvailable()) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((10 - 7) * v124));
				end
				if ((v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (0 + 0)) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) or ((3008 + 1894) <= (1731 + 1864))) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(114 - 74), true) or ((5227 - (1140 + 235)) == (187 + 106))) then
						return "shifting_power main 12";
					end
				end
				if ((v125 < v99) or ((1430 + 129) == (1178 + 3410))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (59 - (33 + 19))) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				v169 = 2 + 1;
			end
		end
	end
	local function v152()
		local v170 = 0 - 0;
		while true do
			if ((v170 == (4 + 3)) or ((8793 - 4309) == (739 + 49))) then
				v64 = EpicSettings.Settings['iceColdHP'] or (689 - (586 + 103));
				v65 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v66 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v85 = EpicSettings.Settings['mirrorImageBeforePull'];
				v170 = 1496 - (1309 + 179);
			end
			if (((8246 - 3678) >= (1701 + 2206)) and (v170 == (21 - 13))) then
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((942 + 304) < (7372 - 3902)) and (v170 == (1 - 0))) then
				v40 = EpicSettings.Settings['useFireball'];
				v41 = EpicSettings.Settings['useFlamestrike'];
				v42 = EpicSettings.Settings['useLivingBomb'];
				v43 = EpicSettings.Settings['useMeteor'];
				v170 = 611 - (295 + 314);
			end
			if (((9991 - 5923) >= (2934 - (1300 + 662))) and (v170 == (18 - 12))) then
				v60 = EpicSettings.Settings['alterTimeHP'] or (1755 - (1178 + 577));
				v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
				v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v63 = EpicSettings.Settings['iceBlockHP'] or (1405 - (851 + 554));
				v170 = 7 + 0;
			end
			if (((1367 - 874) < (8454 - 4561)) and ((306 - (115 + 187)) == v170)) then
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['useAlterTime'];
				v54 = EpicSettings.Settings['useBlazingBarrier'];
				v55 = EpicSettings.Settings['useGreaterInvisibility'];
				v170 = 4 + 1;
			end
			if (((3 + 0) == v170) or ((5804 - 4331) >= (4493 - (160 + 1001)))) then
				v48 = EpicSettings.Settings['useBlastWave'];
				v49 = EpicSettings.Settings['useCombustion'];
				v50 = EpicSettings.Settings['useShiftingPower'];
				v51 = EpicSettings.Settings['combustionWithCD'];
				v170 = 4 + 0;
			end
			if ((v170 == (2 + 0)) or ((8292 - 4241) <= (1515 - (237 + 121)))) then
				v44 = EpicSettings.Settings['usePhoenixFlames'];
				v45 = EpicSettings.Settings['usePyroblast'];
				v46 = EpicSettings.Settings['useScorch'];
				v47 = EpicSettings.Settings['useCounterspell'];
				v170 = 900 - (525 + 372);
			end
			if (((1144 - 540) < (9465 - 6584)) and (v170 == (147 - (96 + 46)))) then
				v56 = EpicSettings.Settings['useIceBlock'];
				v57 = EpicSettings.Settings['useIceCold'];
				v59 = EpicSettings.Settings['useMassBarrier'];
				v58 = EpicSettings.Settings['useMirrorImage'];
				v170 = 783 - (643 + 134);
			end
			if ((v170 == (0 + 0)) or ((2158 - 1258) == (12537 - 9160))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v39 = EpicSettings.Settings['useFireBlast'];
				v170 = 1 + 0;
			end
		end
	end
	local function v153()
		v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v75 = EpicSettings.Settings['useWeapon'];
		v71 = EpicSettings.Settings['InterruptWithStun'];
		v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v73 = EpicSettings.Settings['InterruptThreshold'];
		v68 = EpicSettings.Settings['DispelDebuffs'];
		v67 = EpicSettings.Settings['DispelBuffs'];
		v82 = EpicSettings.Settings['useTrinkets'];
		v81 = EpicSettings.Settings['useRacials'];
		v83 = EpicSettings.Settings['trinketsWithCD'];
		v84 = EpicSettings.Settings['racialsWithCD'];
		v77 = EpicSettings.Settings['useHealthstone'];
		v76 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v78 = EpicSettings.Settings['healingPotionHP'] or (719 - (316 + 403));
		v80 = EpicSettings.Settings['HealingPotionName'] or "";
		v69 = EpicSettings.Settings['handleAfflicted'];
		v70 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v154()
		v152();
		v153();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((2964 + 1495) > (1624 - 1033)) and v13:IsDeadOrGhost()) then
			return v31;
		end
		v130 = v14:GetEnemiesInSplashRange(2 + 3);
		v129 = v13:GetEnemiesInRange(100 - 60);
		if (((2408 + 990) >= (772 + 1623)) and v33) then
			v125 = v29(v14:GetEnemiesInSplashRangeCount(17 - 12), #v129);
			v126 = v29(v14:GetEnemiesInSplashRangeCount(23 - 18), #v129);
			v127 = v29(v14:GetEnemiesInSplashRangeCount(10 - 5), #v129);
			v128 = #v129;
		else
			v125 = 1 + 0;
			v126 = 1 - 0;
			v127 = 1 + 0;
			v128 = 2 - 1;
		end
		if (v93.TargetIsValid() or v13:AffectingCombat() or ((2200 - (12 + 5)) >= (10968 - 8144))) then
			if (((4130 - 2194) == (4115 - 2179)) and (v13:AffectingCombat() or v68)) then
				local v226 = v68 and v89.RemoveCurse:IsReady() and v35;
				v31 = v93.FocusUnit(v226, nil, 49 - 29, nil, 5 + 15, v89.ArcaneIntellect);
				if (v31 or ((6805 - (1656 + 317)) < (3844 + 469))) then
					return v31;
				end
			end
			v122 = v9.BossFightRemains(nil, true);
			v123 = v122;
			if (((3276 + 812) > (10300 - 6426)) and (v123 == (54683 - 43572))) then
				v123 = v9.FightRemains(v129, false);
			end
			v131 = v138(v129);
			v95 = not v34;
			if (((4686 - (5 + 349)) == (20576 - 16244)) and v95) then
				v109 = 101270 - (266 + 1005);
			end
			v124 = v13:GCD();
			v118 = v13:BuffUp(v89.CombustionBuff);
			v119 = not v118;
		end
		if (((2636 + 1363) >= (9895 - 6995)) and not v13:AffectingCombat() and v32) then
			local v196 = 0 - 0;
			while true do
				if ((v196 == (1696 - (561 + 1135))) or ((3290 - 765) > (13358 - 9294))) then
					v31 = v144();
					if (((5437 - (507 + 559)) == (10968 - 6597)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((822 - 556) > (5374 - (212 + 176)))) then
			local v197 = 905 - (250 + 655);
			while true do
				if (((5429 - 3438) >= (1616 - 691)) and (v197 == (2 - 0))) then
					if (((2411 - (1869 + 87)) < (7120 - 5067)) and v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) then
						if (v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal)) or ((2727 - (484 + 1417)) == (10397 - 5546))) then
							return "spellsteal damage";
						end
					end
					if (((305 - 122) == (956 - (48 + 725))) and (v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v89.HotStreakBuff)) then
						if (((1892 - 733) <= (4796 - 3008)) and v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast))) then
							return "Stop Casting";
						end
					end
					if ((v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) or ((2039 + 1468) > (11539 - 7221))) then
						if (v23(v89.IceFloes) or ((861 + 2214) <= (865 + 2100))) then
							return "ice_floes movement";
						end
					end
					v197 = 856 - (152 + 701);
				end
				if (((2676 - (430 + 881)) <= (771 + 1240)) and (v197 == (898 - (557 + 338)))) then
					if ((v13:IsMoving() and not v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) or ((821 + 1955) > (10074 - 6499))) then
						if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((8943 - 6389) == (12762 - 7958))) then
							return "scorch movement";
						end
					end
					v31 = v151();
					if (((5553 - 2976) == (3378 - (499 + 302))) and v31) then
						return v31;
					end
					break;
				end
				if ((v197 == (866 - (39 + 827))) or ((16 - 10) >= (4218 - 2329))) then
					if (((2009 - 1503) <= (2904 - 1012)) and v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) then
						if (v23(v91.UseWeapon, nil) or ((172 + 1836) > (6491 - 4273))) then
							return "Using Weapon Macro";
						end
					end
					if (((61 + 318) <= (6561 - 2414)) and v68 and v35 and v89.RemoveCurse:IsAvailable()) then
						local v231 = 104 - (103 + 1);
						while true do
							if ((v231 == (554 - (475 + 79))) or ((9758 - 5244) <= (3228 - 2219))) then
								if (v15 or ((452 + 3044) == (1050 + 142))) then
									local v232 = 1503 - (1395 + 108);
									while true do
										if ((v232 == (0 - 0)) or ((1412 - (7 + 1197)) == (1291 + 1668))) then
											v31 = v142();
											if (((1493 + 2784) >= (1632 - (27 + 292))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if (((7580 - 4993) < (4046 - 872)) and v17 and v17:Exists() and v17:IsAPlayer() and v93.UnitHasCurseDebuff(v17)) then
									if (v89.RemoveCurse:IsReady() or ((17278 - 13158) <= (4334 - 2136))) then
										if (v23(v91.RemoveCurseMouseover) or ((3039 - 1443) == (997 - (43 + 96)))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					v31 = v143();
					v197 = 4 - 3;
				end
				if (((7280 - 4060) == (2672 + 548)) and (v197 == (1 + 0))) then
					if (v31 or ((2770 - 1368) > (1388 + 2232))) then
						return v31;
					end
					if (((4823 - 2249) == (811 + 1763)) and v69) then
						if (((132 + 1666) < (4508 - (1414 + 337))) and v88) then
							v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 1970 - (1642 + 298));
							if (v31 or ((982 - 605) > (7491 - 4887))) then
								return v31;
							end
						end
					end
					if (((1685 - 1117) < (300 + 611)) and v70) then
						v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseOver, 24 + 6, true);
						if (((4257 - (357 + 615)) < (2968 + 1260)) and v31) then
							return v31;
						end
					end
					v197 = 4 - 2;
				end
			end
		end
	end
	local function v155()
		local v189 = 0 + 0;
		while true do
			if (((8392 - 4476) > (2662 + 666)) and (v189 == (0 + 0))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(40 + 23, v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

