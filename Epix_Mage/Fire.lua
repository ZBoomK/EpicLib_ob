local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3398 + 847) <= (16233 - 11602)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if (((6892 - 2616) >= (12099 - 8185)) and (v5 == (1248 - (111 + 1137)))) then
			v6 = v0[v4];
			if (((356 - (91 + 67)) <= (12991 - 8626)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v16 = v12.Pet;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Press;
	local v23 = v20.PressCursor;
	local v24 = v20.Macro;
	local v25 = v20.Bind;
	local v26 = v20.Commons.Everyone.num;
	local v27 = v20.Commons.Everyone.bool;
	local v28 = math.max;
	local v29 = math.ceil;
	local v30;
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
	local v87 = v17.Mage.Fire;
	local v88 = v19.Mage.Fire;
	local v89 = v24.Mage.Fire;
	local v90 = {};
	local v91 = v20.Commons.Everyone;
	local function v92()
		if (((5305 - (423 + 100)) > (33 + 4643)) and v87.RemoveCurse:IsAvailable()) then
			v91.DispellableDebuffs = v91.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v92();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v93 = not v33;
	local v94 = v87.SunKingsBlessing:IsAvailable();
	local v95 = ((v87.FlamePatch:IsAvailable()) and (10 - 6)) or (521 + 478);
	local v96 = 1770 - (326 + 445);
	local v97 = v95;
	local v98 = ((13 - 10) * v26(v87.FueltheFire:IsAvailable())) + ((2225 - 1226) * v26(not v87.FueltheFire:IsAvailable()));
	local v99 = 2331 - 1332;
	local v100 = 751 - (530 + 181);
	local v101 = 1880 - (614 + 267);
	local v102 = 32.3 - (19 + 13);
	local v103 = 0 - 0;
	local v104 = 13 - 7;
	local v105 = false;
	local v106 = (v105 and (57 - 37)) or (0 + 0);
	local v107;
	local v108 = ((v87.Kindling:IsAvailable()) and (0.4 - 0)) or (1 - 0);
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = 1812 - (1293 + 519);
	local v113 = 0 - 0;
	local v114 = 20 - 12;
	local v115 = 5 - 2;
	local v116;
	local v117;
	local v118;
	local v119 = 12 - 9;
	local v120 = 26174 - 15063;
	local v121 = 5885 + 5226;
	local v122;
	local v123, v124, v125;
	local v126;
	local v127;
	local v128;
	local v129;
	v10:RegisterForEvent(function()
		v105 = false;
		v106 = (v105 and (5 + 15)) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v87.Pyroblast:RegisterInFlight();
		v87.Fireball:RegisterInFlight();
		v87.Meteor:RegisterInFlightEffect(81142 + 269998);
		v87.Meteor:RegisterInFlight();
		v87.PhoenixFlames:RegisterInFlightEffect(85558 + 171984);
		v87.PhoenixFlames:RegisterInFlight();
		v87.Pyroblast:RegisterInFlight(v87.CombustionBuff);
		v87.Fireball:RegisterInFlight(v87.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v87.Pyroblast:RegisterInFlight();
	v87.Fireball:RegisterInFlight();
	v87.Meteor:RegisterInFlightEffect(219433 + 131707);
	v87.Meteor:RegisterInFlight();
	v87.PhoenixFlames:RegisterInFlightEffect(258638 - (709 + 387));
	v87.PhoenixFlames:RegisterInFlight();
	v87.Pyroblast:RegisterInFlight(v87.CombustionBuff);
	v87.Fireball:RegisterInFlight(v87.CombustionBuff);
	v10:RegisterForEvent(function()
		local v153 = 1858 - (673 + 1185);
		while true do
			if (((14106 - 9242) > (7054 - 4857)) and (v153 == (0 - 0))) then
				v120 = 7948 + 3163;
				v121 = 8303 + 2808;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v94 = v87.SunKingsBlessing:IsAvailable();
		v95 = ((v87.FlamePatch:IsAvailable()) and (3 - 0)) or (246 + 753);
		v97 = v95;
		v108 = ((v87.Kindling:IsAvailable()) and (0.4 - 0)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v130()
		return v87.Firestarter:IsAvailable() and (v15:HealthPercentage() > (1970 - (446 + 1434)));
	end
	local function v131()
		return (v87.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (1373 - (1040 + 243))) and v15:TimeToX(268 - 178)) or (1847 - (559 + 1288)))) or (1931 - (609 + 1322));
	end
	local function v132()
		return v87.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (484 - (13 + 441)));
	end
	local function v133()
		return v87.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (112 - 82));
	end
	local function v134()
		return (v119 * v87.ShiftingPower:BaseDuration()) / v87.ShiftingPower:BaseTickTime();
	end
	local function v135()
		local v154 = (v130() and (v26(v87.Pyroblast:InFlight()) + v26(v87.Fireball:InFlight()))) or (0 - 0);
		v154 = v154 + v26(v87.PhoenixFlames:InFlight() or v14:PrevGCDP(4 - 3, v87.PhoenixFlames));
		return v14:BuffUp(v87.HotStreakBuff) or v14:BuffUp(v87.HyperthermiaBuff) or (v14:BuffUp(v87.HeatingUpBuff) and ((v133() and v14:IsCasting(v87.Scorch)) or (v130() and (v14:IsCasting(v87.Fireball) or v14:IsCasting(v87.Pyroblast) or (v154 > (0 + 0))))));
	end
	local function v136(v155)
		local v156 = 0 - 0;
		for v196, v197 in pairs(v155) do
			if (v197:DebuffUp(v87.IgniteDebuff) or ((1315 + 2385) == (1099 + 1408))) then
				v156 = v156 + (2 - 1);
			end
		end
		return v156;
	end
	local function v137()
		local v157 = 0 + 0;
		if (((8228 - 3754) >= (182 + 92)) and (v87.Fireball:InFlight() or v87.PhoenixFlames:InFlight())) then
			v157 = v157 + 1 + 0;
		end
		return v157;
	end
	local function v138()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (1 + 0)) or ((1854 + 40) <= (1839 - (153 + 280)))) then
				v30 = v91.HandleBottomTrinket(v90, v33, 115 - 75, nil);
				if (((1412 + 160) >= (605 + 926)) and v30) then
					return v30;
				end
				break;
			end
			if ((v158 == (0 + 0)) or ((4254 + 433) < (3292 + 1250))) then
				v30 = v91.HandleTopTrinket(v90, v33, 60 - 20, nil);
				if (((2035 + 1256) > (2334 - (89 + 578))) and v30) then
					return v30;
				end
				v158 = 1 + 0;
			end
		end
	end
	local function v139()
		if ((v87.RemoveCurse:IsReady() and v34 and v91.DispellableFriendlyUnit(41 - 21)) or ((1922 - (572 + 477)) == (275 + 1759))) then
			if (v22(v89.RemoveCurseFocus) or ((1690 + 1126) < (2 + 9))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v140()
		local v159 = 86 - (84 + 2);
		while true do
			if (((6095 - 2396) < (3391 + 1315)) and (v159 == (843 - (497 + 345)))) then
				if (((68 + 2578) >= (149 + 727)) and v87.IceBlock:IsCastable() and v55 and (v14:HealthPercentage() <= v62)) then
					if (((1947 - (605 + 728)) <= (2272 + 912)) and v22(v87.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((6949 - 3823) == (144 + 2982)) and v87.IceColdTalent:IsAvailable() and v87.IceColdAbility:IsCastable() and v56 and (v14:HealthPercentage() <= v63)) then
					if (v22(v87.IceColdAbility) or ((8085 - 5898) >= (4467 + 487))) then
						return "ice_cold defensive 3";
					end
				end
				v159 = 5 - 3;
			end
			if ((v159 == (0 + 0)) or ((4366 - (457 + 32)) == (1517 + 2058))) then
				if (((2109 - (832 + 570)) > (596 + 36)) and v87.BlazingBarrier:IsCastable() and v53 and v14:BuffDown(v87.BlazingBarrier) and (v14:HealthPercentage() <= v60)) then
					if (v22(v87.BlazingBarrier) or ((143 + 403) >= (9497 - 6813))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((706 + 759) <= (5097 - (588 + 208))) and v87.MassBarrier:IsCastable() and v58 and v14:BuffDown(v87.BlazingBarrier) and v91.AreUnitsBelowHealthPercentage(v65, 5 - 3)) then
					if (((3504 - (884 + 916)) > (2983 - 1558)) and v22(v87.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v159 = 1 + 0;
			end
			if ((v159 == (657 - (232 + 421))) or ((2576 - (1569 + 320)) == (1039 + 3195))) then
				if ((v74 and (v14:HealthPercentage() <= v76)) or ((633 + 2697) < (4815 - 3386))) then
					if (((1752 - (316 + 289)) >= (876 - 541)) and (v78 == "Refreshing Healing Potion")) then
						if (((159 + 3276) > (3550 - (666 + 787))) and v88.RefreshingHealingPotion:IsReady()) then
							if (v22(v89.RefreshingHealingPotion) or ((4195 - (360 + 65)) >= (3777 + 264))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v78 == "Dreamwalker's Healing Potion") or ((4045 - (79 + 175)) <= (2540 - 929))) then
						if (v88.DreamwalkersHealingPotion:IsReady() or ((3573 + 1005) <= (6154 - 4146))) then
							if (((2166 - 1041) <= (2975 - (503 + 396))) and v22(v89.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v159 == (183 - (92 + 89))) or ((1440 - 697) >= (2256 + 2143))) then
				if (((684 + 471) < (6551 - 4878)) and v87.MirrorImage:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
					if (v22(v87.MirrorImage) or ((318 + 2006) <= (1317 - 739))) then
						return "mirror_image defensive 4";
					end
				end
				if (((3287 + 480) == (1800 + 1967)) and v87.GreaterInvisibility:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
					if (((12453 - 8364) == (511 + 3578)) and v22(v87.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v159 = 4 - 1;
			end
			if (((5702 - (485 + 759)) >= (3873 - 2199)) and (v159 == (1192 - (442 + 747)))) then
				if (((2107 - (832 + 303)) <= (2364 - (88 + 858))) and v87.AlterTime:IsReady() and v52 and (v14:HealthPercentage() <= v59)) then
					if (v22(v87.AlterTime) or ((1506 + 3432) < (3942 + 820))) then
						return "alter_time defensive 6";
					end
				end
				if ((v88.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or ((104 + 2400) > (5053 - (766 + 23)))) then
					if (((10628 - 8475) == (2943 - 790)) and v22(v89.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v159 = 10 - 6;
			end
		end
	end
	local function v141()
		if ((v87.ArcaneIntellect:IsCastable() and v36 and (v14:BuffDown(v87.ArcaneIntellect, true) or v91.GroupBuffMissing(v87.ArcaneIntellect))) or ((1720 - 1213) >= (3664 - (1036 + 37)))) then
			if (((3177 + 1304) == (8726 - 4245)) and v22(v87.ArcaneIntellect)) then
				return "arcane_intellect precombat 2";
			end
		end
		if ((v87.MirrorImage:IsCastable() and v91.TargetIsValid() and v57 and v83) or ((1832 + 496) < (2173 - (641 + 839)))) then
			if (((5241 - (910 + 3)) == (11033 - 6705)) and v22(v87.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if (((3272 - (1466 + 218)) >= (613 + 719)) and v87.Pyroblast:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast)) then
			if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or ((5322 - (556 + 592)) > (1511 + 2737))) then
				return "pyroblast precombat 4";
			end
		end
		if ((v87.Fireball:IsReady() and v39) or ((5394 - (329 + 479)) <= (936 - (174 + 680)))) then
			if (((13273 - 9410) == (8006 - 4143)) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v142()
		if ((v87.LivingBomb:IsReady() and v41 and (v124 > (1 + 0)) and v117 and ((v107 > v87.LivingBomb:CooldownRemains()) or (v107 <= (739 - (396 + 343))))) or ((25 + 257) <= (1519 - (29 + 1448)))) then
			if (((5998 - (135 + 1254)) >= (2885 - 2119)) and v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb))) then
				return "living_bomb active_talents 2";
			end
		end
		if ((v87.Meteor:IsReady() and v42 and (v73 < v121) and ((v107 <= (0 - 0)) or (v14:BuffRemains(v87.CombustionBuff) > v87.Meteor:TravelTime()) or (not v87.SunKingsBlessing:IsAvailable() and (((30 + 15) < v107) or (v121 < v107))))) or ((2679 - (389 + 1138)) == (3062 - (102 + 472)))) then
			if (((3230 + 192) > (1858 + 1492)) and v22(v89.MeteorCursor, not v15:IsInRange(38 + 2))) then
				return "meteor active_talents 4";
			end
		end
		if (((2422 - (320 + 1225)) > (669 - 293)) and v87.DragonsBreath:IsReady() and v37 and v87.AlexstraszasFury:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > (10 + 5))) and not v133() and (v131() == (1464 - (157 + 1307))) and not v87.TemperedFlames:IsAvailable()) then
			if (v22(v87.DragonsBreath, not v15:IsInRange(1869 - (821 + 1038))) or ((7779 - 4661) <= (203 + 1648))) then
				return "dragons_breath active_talents 6";
			end
		end
		if ((v87.DragonsBreath:IsReady() and v37 and v87.AlexstraszasFury:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > (26 - 11))) and not v133() and v87.TemperedFlames:IsAvailable()) or ((62 + 103) >= (8654 - 5162))) then
			if (((4975 - (834 + 192)) < (309 + 4547)) and v22(v87.DragonsBreath, not v15:IsInRange(3 + 7))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v143()
		local v160 = v91.HandleDPSPotion(v14:BuffUp(v87.CombustionBuff));
		if (v160 or ((92 + 4184) < (4672 - 1656))) then
			return v160;
		end
		if (((4994 - (300 + 4)) > (1102 + 3023)) and v79 and ((v82 and v33) or not v82) and (v73 < v121)) then
			local v201 = 0 - 0;
			while true do
				if ((v201 == (363 - (112 + 250))) or ((20 + 30) >= (2244 - 1348))) then
					if (v87.Fireblood:IsCastable() or ((982 + 732) >= (1530 + 1428))) then
						if (v22(v87.Fireblood) or ((1116 + 375) < (320 + 324))) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((523 + 181) < (2401 - (1001 + 413))) and v87.AncestralCall:IsCastable()) then
						if (((8290 - 4572) > (2788 - (244 + 638))) and v22(v87.AncestralCall)) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
				if ((v201 == (693 - (627 + 66))) or ((2854 - 1896) > (4237 - (512 + 90)))) then
					if (((5407 - (1665 + 241)) <= (5209 - (373 + 344))) and v87.BloodFury:IsCastable()) then
						if (v22(v87.BloodFury) or ((1553 + 1889) < (675 + 1873))) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if (((7583 - 4708) >= (2477 - 1013)) and v87.Berserking:IsCastable() and v116) then
						if (v22(v87.Berserking) or ((5896 - (35 + 1064)) >= (3561 + 1332))) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v201 = 2 - 1;
				end
			end
		end
		if ((v85 and v87.TimeWarp:IsReady() and v87.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) or ((3 + 548) > (3304 - (298 + 938)))) then
			if (((3373 - (233 + 1026)) > (2610 - (636 + 1030))) and v22(v87.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v73 < v121) or ((1157 + 1105) >= (3025 + 71))) then
			if ((v80 and ((v33 and v81) or not v81)) or ((670 + 1585) >= (239 + 3298))) then
				local v220 = 221 - (55 + 166);
				while true do
					if (((0 + 0) == v220) or ((386 + 3451) < (4987 - 3681))) then
						v30 = v138();
						if (((3247 - (36 + 261)) == (5159 - 2209)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
	end
	local function v144()
		local v161 = 1368 - (34 + 1334);
		while true do
			if ((v161 == (1 + 1)) or ((3670 + 1053) < (4581 - (1035 + 248)))) then
				if (((1157 - (20 + 1)) >= (81 + 73)) and v30) then
					return v30;
				end
				if ((v87.Combustion:IsReady() and v48 and ((v50 and v33) or not v50) and (v73 < v121) and (v137() == (319 - (134 + 185))) and v117 and (v107 <= (1133 - (549 + 584))) and ((v14:IsCasting(v87.Scorch) and (v87.Scorch:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Fireball) and (v87.Fireball:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Pyroblast) and (v87.Pyroblast:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Flamestrike) and (v87.Flamestrike:ExecuteRemains() < v102)) or (v87.Meteor:InFlight() and (v87.Meteor:InFlightRemains() < v102)))) or ((956 - (314 + 371)) > (16299 - 11551))) then
					if (((5708 - (478 + 490)) >= (1670 + 1482)) and v22(v87.Combustion, not v15:IsInRange(1212 - (786 + 386)), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				if ((v32 and v87.Flamestrike:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87.Flamestrike:CastTime()) and (v87.Combustion:CooldownRemains() < v87.Flamestrike:CastTime()) and (v123 >= v98)) or ((8350 - 5772) >= (4769 - (1055 + 324)))) then
					if (((1381 - (1093 + 247)) <= (1477 + 184)) and v22(v89.FlamestrikeCursor, not v15:IsInRange(5 + 35))) then
						return "flamestrike combustion_phase 12";
					end
				end
				v161 = 11 - 8;
			end
			if (((2039 - 1438) < (10130 - 6570)) and (v161 == (15 - 9))) then
				if (((84 + 151) < (2646 - 1959)) and v32 and v87.Flamestrike:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87.Flamestrike:CastTime()) and (v123 >= v98)) then
					if (((15679 - 11130) > (870 + 283)) and v22(v89.FlamestrikeCursor, not v15:IsInRange(102 - 62))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v87.Pyroblast:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87.Pyroblast:CastTime())) or ((5362 - (364 + 324)) < (12807 - 8135))) then
					if (((8801 - 5133) < (1512 + 3049)) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return "pyroblast combustion_phase 34";
					end
				end
				if ((v87.Scorch:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < ((16 - 12) * v122)) and (v125 < v97)) or ((728 - 273) == (10948 - 7343))) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or ((3931 - (1249 + 19)) == (2990 + 322))) then
						return "scorch combustion_phase 36";
					end
				end
				v161 = 27 - 20;
			end
			if (((5363 - (686 + 400)) <= (3512 + 963)) and (v161 == (229 - (73 + 156)))) then
				if ((v87.LightsJudgment:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) or ((5 + 865) == (2000 - (721 + 90)))) then
					if (((18 + 1535) <= (10172 - 7039)) and v22(v87.LightsJudgment, not v15:IsSpellInRange(v87.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if ((v87.BagofTricks:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) or ((2707 - (224 + 246)) >= (5687 - 2176))) then
					if (v22(v87.BagofTricks) or ((2437 - 1113) > (548 + 2472))) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v87.LivingBomb:IsReady() and v32 and v41 and (v124 > (1 + 0)) and v117) or ((2198 + 794) == (3739 - 1858))) then
					if (((10336 - 7230) > (2039 - (203 + 310))) and v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb))) then
						return "living_bomb combustion_phase 6";
					end
				end
				v161 = 1994 - (1238 + 755);
			end
			if (((212 + 2811) < (5404 - (709 + 825))) and (v161 == (7 - 3))) then
				if (((207 - 64) > (938 - (196 + 668))) and v87.FireBlast:IsReady() and v38 and not v135() and not v111 and (not v133() or v14:IsCasting(v87.Scorch) or (v15:DebuffRemains(v87.ImprovedScorchDebuff) > ((15 - 11) * v122))) and (v14:BuffDown(v87.FuryoftheSunKingBuff) or v14:IsCasting(v87.Pyroblast)) and v116 and v14:BuffDown(v87.HyperthermiaBuff) and v14:BuffDown(v87.HotStreakBuff) and ((v137() + (v26(v14:BuffUp(v87.HeatingUpBuff)) * v26(v14:GCDRemains() > (0 - 0)))) < (835 - (171 + 662)))) then
					if (((111 - (4 + 89)) < (7402 - 5290)) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((400 + 697) <= (7150 - 5522)) and v32 and v87.Flamestrike:IsReady() and v40 and ((v14:BuffUp(v87.HotStreakBuff) and (v123 >= v97)) or (v14:BuffUp(v87.HyperthermiaBuff) and (v123 >= (v97 - v26(v87.Hyperthermia:IsAvailable())))))) then
					if (((1816 + 2814) == (6116 - (35 + 1451))) and v22(v89.FlamestrikeCursor, not v15:IsInRange(1493 - (28 + 1425)))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if (((5533 - (941 + 1052)) > (2573 + 110)) and v87.Pyroblast:IsReady() and v44 and (v14:BuffUp(v87.HyperthermiaBuff))) then
					if (((6308 - (822 + 692)) >= (4675 - 1400)) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return "pyroblast combustion_phase 24";
					end
				end
				v161 = 3 + 2;
			end
			if (((1781 - (45 + 252)) == (1469 + 15)) and ((2 + 1) == v161)) then
				if (((3484 - 2052) < (3988 - (114 + 319))) and v87.Pyroblast:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87.Pyroblast:CastTime())) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or ((1528 - 463) > (4584 - 1006))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if ((v87.Fireball:IsReady() and v39 and v117 and (v87.Combustion:CooldownRemains() < v87.Fireball:CastTime()) and (v123 < (2 + 0)) and not v133()) or ((7143 - 2348) < (2947 - 1540))) then
					if (((3816 - (556 + 1407)) < (6019 - (741 + 465))) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball))) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v87.Scorch:IsReady() and v45 and v117 and (v87.Combustion:CooldownRemains() < v87.Scorch:CastTime())) or ((3286 - (170 + 295)) < (1281 + 1150))) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or ((2640 + 234) < (5369 - 3188))) then
						return "scorch combustion_phase 18";
					end
				end
				v161 = 4 + 0;
			end
			if (((4 + 1) == v161) or ((1523 + 1166) <= (1573 - (957 + 273)))) then
				if ((v87.Pyroblast:IsReady() and v44 and v14:BuffUp(v87.HotStreakBuff) and v116) or ((500 + 1369) == (805 + 1204))) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or ((13511 - 9965) < (6118 - 3796))) then
						return "pyroblast combustion_phase 26";
					end
				end
				if ((v87.Pyroblast:IsReady() and v44 and v14:PrevGCDP(2 - 1, v87.Scorch) and v14:BuffUp(v87.HeatingUpBuff) and (v123 < v97) and v116) or ((10309 - 8227) == (6553 - (389 + 1391)))) then
					if (((2036 + 1208) > (110 + 945)) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if ((v87.ShiftingPower:IsReady() and v49 and ((v51 and v33) or not v51) and (v73 < v121) and v116 and (v87.FireBlast:Charges() == (0 - 0)) and ((v87.PhoenixFlames:Charges() < v87.PhoenixFlames:MaxCharges()) or v87.AlexstraszasFury:IsAvailable()) and (v101 <= v123)) or ((4264 - (783 + 168)) <= (5967 - 4189))) then
					if (v22(v87.ShiftingPower, not v15:IsInRange(40 + 0)) or ((1732 - (309 + 2)) >= (6460 - 4356))) then
						return "shifting_power combustion_phase 30";
					end
				end
				v161 = 1218 - (1090 + 122);
			end
			if (((588 + 1224) <= (10911 - 7662)) and (v161 == (1 + 0))) then
				if (((2741 - (628 + 490)) <= (351 + 1606)) and ((v14:BuffRemains(v87.CombustionBuff) > v104) or (v121 < (49 - 29)))) then
					local v221 = 0 - 0;
					while true do
						if (((5186 - (431 + 343)) == (8910 - 4498)) and (v221 == (0 - 0))) then
							v30 = v143();
							if (((1383 + 367) >= (108 + 734)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((6067 - (556 + 1139)) > (1865 - (6 + 9))) and v87.PhoenixFlames:IsCastable() and v43 and v14:BuffDown(v87.CombustionBuff) and v14:HasTier(6 + 24, 2 + 0) and not v87.PhoenixFlames:InFlight() and (v15:DebuffRemains(v87.CharringEmbersDebuff) < ((173 - (28 + 141)) * v122)) and v14:BuffDown(v87.HotStreakBuff)) then
					if (((90 + 142) < (1013 - 192)) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v30 = v142();
				v161 = 2 + 0;
			end
			if (((1835 - (486 + 831)) < (2347 - 1445)) and (v161 == (27 - 19))) then
				if (((566 + 2428) > (2712 - 1854)) and v87.Scorch:IsReady() and v45 and (v14:BuffRemains(v87.CombustionBuff) > v87.Scorch:CastTime()) and (v87.Scorch:CastTime() >= v122)) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or ((5018 - (668 + 595)) <= (824 + 91))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((796 + 3150) > (10207 - 6464)) and v87.Fireball:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87.Fireball:CastTime())) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball)) or ((1625 - (23 + 267)) >= (5250 - (1129 + 815)))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((5231 - (371 + 16)) > (4003 - (1326 + 424))) and v87.LivingBomb:IsReady() and v41 and (v14:BuffRemains(v87.CombustionBuff) < v122) and (v124 > (1 - 0))) then
					if (((1651 - 1199) == (570 - (88 + 30))) and v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if ((v161 == (778 - (720 + 51))) or ((10136 - 5579) < (3863 - (421 + 1355)))) then
				if (((6390 - 2516) == (1903 + 1971)) and v87.PhoenixFlames:IsCastable() and v43 and v14:HasTier(1113 - (286 + 797), 7 - 5) and (v87.PhoenixFlames:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < (2 - 0)) and ((v15:DebuffRemains(v87.CharringEmbersDebuff) < ((443 - (397 + 42)) * v122)) or (v14:BuffStack(v87.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v87.FlamesFuryBuff))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or ((2738 - (24 + 776)) > (7602 - 2667))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if ((v87.Fireball:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87.Fireball:CastTime()) and v14:BuffUp(v87.FlameAccelerantBuff)) or ((5040 - (222 + 563)) < (7541 - 4118))) then
					if (((1047 + 407) <= (2681 - (23 + 167))) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball))) then
						return "fireball combustion_phase 40";
					end
				end
				if ((v87.PhoenixFlames:IsCastable() and v43 and not v14:HasTier(1828 - (690 + 1108), 1 + 1) and not v87.AlexstraszasFury:IsAvailable() and (v87.PhoenixFlames:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < (2 + 0))) or ((5005 - (40 + 808)) <= (462 + 2341))) then
					if (((18557 - 13704) >= (2851 + 131)) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v161 = 5 + 3;
			end
		end
	end
	local function v145()
		local v162 = 0 + 0;
		while true do
			if (((4705 - (47 + 524)) > (2179 + 1178)) and (v162 == (5 - 3))) then
				if ((v87.SunKingsBlessing:IsAvailable() and v130() and v14:BuffDown(v87.FuryoftheSunKingBuff)) or ((5108 - 1691) < (5778 - 3244))) then
					v107 = v28((v114 - v14:BuffStack(v87.SunKingsBlessingBuff)) * (1729 - (1165 + 561)) * v122, v107);
				end
				v107 = v28(v14:BuffRemains(v87.CombustionBuff), v107);
				v162 = 1 + 2;
			end
			if ((v162 == (0 - 0)) or ((1039 + 1683) <= (643 - (341 + 138)))) then
				v112 = v87.Combustion:CooldownRemains() * v108;
				v113 = ((v87.Fireball:CastTime() * v26(v123 < v97)) + (v87.Flamestrike:CastTime() * v26(v123 >= v97))) - v102;
				v162 = 1 + 0;
			end
			if ((v162 == (5 - 2)) or ((2734 - (89 + 237)) < (6784 - 4675))) then
				if (((v112 + ((252 - 132) * ((882 - (581 + 300)) - (((1220.4 - (855 + 365)) + ((0.2 - 0) * v26(v87.Firestarter:IsAvailable()))) * v26(v87.Kindling:IsAvailable()))))) <= v107) or (v107 > (v121 - (7 + 13))) or ((1268 - (1030 + 205)) == (1366 + 89))) then
					v107 = v112;
				end
				break;
			end
			if ((v162 == (1 + 0)) or ((729 - (156 + 130)) >= (9122 - 5107))) then
				v107 = v112;
				if (((5699 - 2317) > (339 - 173)) and v87.Firestarter:IsAvailable() and not v94) then
					v107 = v28(v131(), v107);
				end
				v162 = 1 + 1;
			end
		end
	end
	local function v146()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (69 - (10 + 59))) or ((80 + 200) == (15064 - 12005))) then
				if (((3044 - (671 + 492)) > (1030 + 263)) and v87.FireBlast:IsReady() and v38 and not v135() and not v111 and v14:BuffDown(v87.HotStreakBuff) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == (1216 - (369 + 846))) and (v87.ShiftingPower:CooldownUp() or (v87.FireBlast:Charges() > (1 + 0)) or (v14:BuffRemains(v87.FeeltheBurnBuff) < ((2 + 0) * v122)))) then
					if (((4302 - (1036 + 909)) == (1874 + 483)) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((206 - 83) == (326 - (11 + 192))) and v87.FireBlast:IsReady() and v38 and not v135() and not v111 and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == (1 + 0)) and v87.ShiftingPower:CooldownUp() and (not v14:HasTier(205 - (135 + 40), 4 - 2) or (v15:DebuffRemains(v87.CharringEmbersDebuff) > ((2 + 0) * v122)))) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or ((2326 - 1270) >= (5084 - 1692))) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v147()
		local v164 = 176 - (50 + 126);
		while true do
			if ((v164 == (5 - 3)) or ((240 + 841) < (2488 - (1233 + 180)))) then
				if ((v87.PhoenixFlames:IsCastable() and v43 and v87.AlexstraszasFury:IsAvailable() and (not v87.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < ((971 - (522 + 447)) * v122)))) or ((2470 - (107 + 1314)) >= (2057 + 2375))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or ((14528 - 9760) <= (360 + 486))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if ((v87.PhoenixFlames:IsCastable() and v43 and v14:HasTier(59 - 29, 7 - 5) and (v15:DebuffRemains(v87.CharringEmbersDebuff) < ((1912 - (716 + 1194)) * v122)) and v14:BuffDown(v87.HotStreakBuff)) or ((58 + 3300) <= (153 + 1267))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or ((4242 - (74 + 429)) <= (5796 - 2791))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v87.Scorch:IsReady() and v45 and v133() and (v15:DebuffStack(v87.ImprovedScorchDebuff) < v115)) or ((823 + 836) >= (4884 - 2750))) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or ((2307 + 953) < (7260 - 4905))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v87.PhoenixFlames:IsCastable() and v43 and not v87.AlexstraszasFury:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and not v110 and v14:BuffUp(v87.FlamesFuryBuff)) or ((1653 - 984) == (4656 - (279 + 154)))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or ((2470 - (454 + 324)) < (463 + 125))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v164 = 20 - (12 + 5);
			end
			if ((v164 == (1 + 0)) or ((12222 - 7425) < (1350 + 2301))) then
				if ((v87.Pyroblast:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and (v14:BuffUp(v87.FuryoftheSunKingBuff))) or ((5270 - (277 + 816)) > (20724 - 15874))) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or ((1583 - (1058 + 125)) > (209 + 902))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((4026 - (815 + 160)) > (4312 - 3307)) and v87.FireBlast:IsReady() and v38 and not v135() and not v130() and not v111 and v14:BuffDown(v87.FuryoftheSunKingBuff) and ((((v14:IsCasting(v87.Fireball) and ((v87.Fireball:ExecuteRemains() < (0.5 - 0)) or not v87.Hyperthermia:IsAvailable())) or (v14:IsCasting(v87.Pyroblast) and ((v87.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v87.Hyperthermia:IsAvailable()))) and v14:BuffUp(v87.HeatingUpBuff)) or (v132() and (not v133() or (v15:DebuffStack(v87.ImprovedScorchDebuff) == v115) or (v87.FireBlast:FullRechargeTime() < (8 - 5))) and ((v14:BuffUp(v87.HeatingUpBuff) and not v14:IsCasting(v87.Scorch)) or (v14:BuffDown(v87.HotStreakBuff) and v14:BuffDown(v87.HeatingUpBuff) and v14:IsCasting(v87.Scorch) and (v137() == (1898 - (41 + 1857)))))))) then
					if (((5586 - (1222 + 671)) <= (11325 - 6943)) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				if ((v87.Pyroblast:IsReady() and v44 and (v14:IsCasting(v87.Scorch) or v14:PrevGCDP(1 - 0, v87.Scorch)) and v14:BuffUp(v87.HeatingUpBuff) and v132() and (v123 < v95)) or ((4464 - (229 + 953)) > (5874 - (1111 + 663)))) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or ((5159 - (874 + 705)) < (399 + 2445))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((61 + 28) < (9333 - 4843)) and v87.Scorch:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < ((1 + 3) * v122))) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or ((5662 - (642 + 37)) < (413 + 1395))) then
						return "scorch standard_rotation 19";
					end
				end
				v164 = 1 + 1;
			end
			if (((9613 - 5784) > (4223 - (233 + 221))) and (v164 == (8 - 4))) then
				if (((1308 + 177) <= (4445 - (718 + 823))) and v87.Scorch:IsReady() and v45 and (v132())) then
					if (((2687 + 1582) == (5074 - (266 + 539))) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((1095 - 708) <= (4007 - (636 + 589))) and v32 and v87.ArcaneExplosion:IsReady() and v35 and (v126 >= v99) and (v14:ManaPercentageP() >= v100)) then
					if (v22(v87.ArcaneExplosion, not v15:IsInRange(18 - 10)) or ((3916 - 2017) <= (727 + 190))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((v32 and v87.Flamestrike:IsReady() and v40 and (v123 >= v96)) or ((1567 + 2745) <= (1891 - (657 + 358)))) then
					if (((5909 - 3677) <= (5914 - 3318)) and v22(v89.FlamestrikeCursor, not v15:IsInRange(1227 - (1151 + 36)))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((2024 + 71) < (970 + 2716)) and v87.Pyroblast:IsReady() and v44 and v87.TemperedFlames:IsAvailable() and v14:BuffDown(v87.FlameAccelerantBuff)) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or ((4763 - 3168) >= (6306 - (1552 + 280)))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v164 = 839 - (64 + 770);
			end
			if ((v164 == (0 + 0)) or ((10485 - 5866) < (512 + 2370))) then
				if ((v32 and v87.Flamestrike:IsReady() and v40 and (v123 >= v95) and v135()) or ((1537 - (157 + 1086)) >= (9669 - 4838))) then
					if (((8886 - 6857) <= (4730 - 1646)) and v22(v89.FlamestrikeCursor, not v15:IsInRange(54 - 14))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v87.Pyroblast:IsReady() and v44 and (v135())) or ((2856 - (599 + 220)) == (4819 - 2399))) then
					if (((6389 - (1813 + 118)) > (2854 + 1050)) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((1653 - (841 + 376)) >= (171 - 48)) and v32 and v87.Flamestrike:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and (v123 >= v98) and v14:BuffUp(v87.FuryoftheSunKingBuff)) then
					if (((117 + 383) < (4956 - 3140)) and v22(v89.FlamestrikeCursor, not v15:IsInRange(899 - (464 + 395)))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if (((9172 - 5598) == (1717 + 1857)) and v87.Scorch:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (v87.Pyroblast:CastTime() + ((842 - (467 + 370)) * v122))) and v14:BuffUp(v87.FuryoftheSunKingBuff) and not v14:IsCasting(v87.Scorch)) then
					if (((456 - 235) < (287 + 103)) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch standard_rotation 13";
					end
				end
				v164 = 3 - 2;
			end
			if ((v164 == (1 + 2)) or ((5148 - 2935) <= (1941 - (150 + 370)))) then
				if (((4340 - (74 + 1208)) < (11953 - 7093)) and v87.PhoenixFlames:IsCastable() and v43 and v87.AlexstraszasFury:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and (v137() == (0 - 0)) and ((not v110 and v14:BuffUp(v87.FlamesFuryBuff)) or (v87.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v87.PhoenixFlames:ChargesFractional() > (391.5 - (14 + 376))) and (not v87.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < ((4 - 1) * v122)))))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or ((839 + 457) >= (3906 + 540))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v30 = v142();
				if (v30 or ((1329 + 64) > (13153 - 8664))) then
					return v30;
				end
				if ((v32 and v87.DragonsBreath:IsReady() and v37 and (v125 > (1 + 0)) and v87.AlexstraszasFury:IsAvailable()) or ((4502 - (23 + 55)) < (63 - 36))) then
					if (v22(v87.DragonsBreath, not v15:IsInRange(7 + 3)) or ((1794 + 203) > (5915 - 2100))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v164 = 2 + 2;
			end
			if (((4366 - (652 + 249)) > (5119 - 3206)) and (v164 == (1873 - (708 + 1160)))) then
				if (((1989 - 1256) < (3315 - 1496)) and v87.Fireball:IsReady() and v39 and not v135()) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true) or ((4422 - (10 + 17)) == (1068 + 3687))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
		end
	end
	local function v148()
		local v165 = 1732 - (1400 + 332);
		while true do
			if (((5 - 2) == v165) or ((5701 - (242 + 1666)) < (1014 + 1355))) then
				if ((v87.FireBlast:IsReady() and v38 and not v135() and v14:IsCasting(v87.ShiftingPower) and (v87.FireBlast:FullRechargeTime() < v119)) or ((1497 + 2587) == (226 + 39))) then
					if (((5298 - (850 + 90)) == (7632 - 3274)) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast main 16";
					end
				end
				if (((v107 > (1390 - (360 + 1030))) and v117) or ((2778 + 360) < (2802 - 1809))) then
					local v222 = 0 - 0;
					while true do
						if (((4991 - (909 + 752)) > (3546 - (109 + 1114))) and (v222 == (0 - 0))) then
							v30 = v147();
							if (v30 or ((1412 + 2214) == (4231 - (6 + 236)))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v87.IceNova:IsCastable() and UseIceNova and not v132()) or ((578 + 338) == (2150 + 521))) then
					if (((640 - 368) == (474 - 202)) and v22(v87.IceNova, not v15:IsSpellInRange(v87.IceNova))) then
						return "ice_nova main 18";
					end
				end
				if (((5382 - (1076 + 57)) <= (796 + 4043)) and v87.Scorch:IsReady() and v45) then
					if (((3466 - (579 + 110)) < (253 + 2947)) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((84 + 11) < (1039 + 918)) and ((408 - (174 + 233)) == v165)) then
				v111 = v117 and (((v87.FireBlast:ChargesFractional() + ((v107 + (v134() * v26(v109))) / v87.FireBlast:Cooldown())) - (2 - 1)) < ((v87.FireBlast:MaxCharges() + (v103 / v87.FireBlast:Cooldown())) - (((20 - 8) / v87.FireBlast:Cooldown()) % (1 + 0)))) and (v107 < v121);
				if (((2000 - (663 + 511)) < (1532 + 185)) and not v93 and ((v107 <= (0 + 0)) or v116 or ((v107 < v113) and (v87.Combustion:CooldownRemains() < v113)))) then
					v30 = v144();
					if (((4396 - 2970) >= (670 + 435)) and v30) then
						return v30;
					end
				end
				if (((6483 - 3729) <= (8179 - 4800)) and not v111 and v87.SunKingsBlessing:IsAvailable()) then
					v111 = v132() and (v87.FireBlast:FullRechargeTime() > ((2 + 1) * v122));
				end
				if ((v87.ShiftingPower:IsReady() and ((v33 and v51) or not v51) and v49 and (v73 < v121) and v117 and ((v87.FireBlast:Charges() == (0 - 0)) or v111) and (not v133() or ((v15:DebuffRemains(v87.ImprovedScorchDebuff) > (v87.ShiftingPower:CastTime() + v87.Scorch:CastTime())) and v14:BuffDown(v87.FuryoftheSunKingBuff))) and v14:BuffDown(v87.HotStreakBuff) and v109) or ((2799 + 1128) == (130 + 1283))) then
					if (v22(v87.ShiftingPower, not v15:IsInRange(762 - (478 + 244)), true) or ((1671 - (440 + 77)) <= (359 + 429))) then
						return "shifting_power main 12";
					end
				end
				v165 = 7 - 5;
			end
			if (((1556 - (655 + 901)) == v165) or ((305 + 1338) > (2587 + 792))) then
				if (not v93 or ((1893 + 910) > (18326 - 13777))) then
					v145();
				end
				if ((v33 and v85 and v87.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v87.TemporalWarp:IsAvailable() and (v130() or (v121 < (1485 - (695 + 750))))) or ((751 - 531) >= (4663 - 1641))) then
					if (((11349 - 8527) == (3173 - (285 + 66))) and v22(v87.TimeWarp, not v15:IsInRange(93 - 53))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v73 < v121) or ((2371 - (682 + 628)) == (300 + 1557))) then
					if (((3059 - (176 + 123)) > (571 + 793)) and v80 and ((v33 and v81) or not v81)) then
						v30 = v138();
						if (v30 or ((3556 + 1346) <= (3864 - (239 + 30)))) then
							return v30;
						end
					end
				end
				v109 = v107 > v87.ShiftingPower:CooldownRemains();
				v165 = 1 + 0;
			end
			if (((2 + 0) == v165) or ((6817 - 2965) == (913 - 620))) then
				if ((v123 < v97) or ((1874 - (306 + 9)) == (16010 - 11422))) then
					v110 = (v87.SunKingsBlessing:IsAvailable() or (((v107 + 2 + 5) < ((v87.PhoenixFlames:FullRechargeTime() + v87.PhoenixFlames:Cooldown()) - (v134() * v26(v109)))) and (v107 < v121))) and not v87.AlexstraszasFury:IsAvailable();
				end
				if ((v123 >= v97) or ((2752 + 1732) == (380 + 408))) then
					v110 = (v87.SunKingsBlessing:IsAvailable() or ((v107 < (v87.PhoenixFlames:FullRechargeTime() - (v134() * v26(v109)))) and (v107 < v121))) and not v87.AlexstraszasFury:IsAvailable();
				end
				if (((13062 - 8494) >= (5282 - (1140 + 235))) and v87.FireBlast:IsReady() and v38 and not v135() and not v111 and (v107 > (0 + 0)) and (v123 >= v96) and not v130() and v14:BuffDown(v87.HotStreakBuff) and ((v14:BuffUp(v87.HeatingUpBuff) and (v87.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v87.FireBlast:ChargesFractional() >= (1 + 1)))) then
					if (((1298 - (33 + 19)) < (1253 + 2217)) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast main 14";
					end
				end
				if (((12192 - 8124) >= (429 + 543)) and v117 and v130() and (v107 > (0 - 0))) then
					v30 = v146();
					if (((463 + 30) < (4582 - (586 + 103))) and v30) then
						return v30;
					end
				end
				v165 = 1 + 2;
			end
		end
	end
	local function v149()
		v35 = EpicSettings.Settings['useArcaneExplosion'];
		v36 = EpicSettings.Settings['useArcaneIntellect'];
		v37 = EpicSettings.Settings['useDragonsBreath'];
		v38 = EpicSettings.Settings['useFireBlast'];
		v39 = EpicSettings.Settings['useFireball'];
		v40 = EpicSettings.Settings['useFlamestrike'];
		v41 = EpicSettings.Settings['useLivingBomb'];
		v42 = EpicSettings.Settings['useMeteor'];
		v43 = EpicSettings.Settings['usePhoenixFlames'];
		v44 = EpicSettings.Settings['usePyroblast'];
		v45 = EpicSettings.Settings['useScorch'];
		v46 = EpicSettings.Settings['useCounterspell'];
		v47 = EpicSettings.Settings['useBlastWave'];
		v48 = EpicSettings.Settings['useCombustion'];
		v49 = EpicSettings.Settings['useShiftingPower'];
		v50 = EpicSettings.Settings['combustionWithCD'];
		v51 = EpicSettings.Settings['shiftingPowerWithCD'];
		v52 = EpicSettings.Settings['useAlterTime'];
		v53 = EpicSettings.Settings['useBlazingBarrier'];
		v54 = EpicSettings.Settings['useGreaterInvisibility'];
		v55 = EpicSettings.Settings['useIceBlock'];
		v56 = EpicSettings.Settings['useIceCold'];
		v58 = EpicSettings.Settings['useMassBarrier'];
		v57 = EpicSettings.Settings['useMirrorImage'];
		v59 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v60 = EpicSettings.Settings['blazingBarrierHP'] or (1488 - (1309 + 179));
		v61 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v62 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v63 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v64 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v65 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v83 = EpicSettings.Settings['mirrorImageBeforePull'];
		v84 = EpicSettings.Settings['useSpellStealTarget'];
		v85 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v86 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v150()
		local v194 = 0 - 0;
		while true do
			if (((610 - (295 + 314)) == v194) or ((3617 - 2144) >= (5294 - (1300 + 662)))) then
				v67 = EpicSettings.Settings['DispelDebuffs'];
				v66 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v79 = EpicSettings.Settings['useRacials'];
				v194 = 6 - 4;
			end
			if ((v194 == (1757 - (1178 + 577))) or ((2104 + 1947) <= (3420 - 2263))) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v194 = 1408 - (851 + 554);
			end
			if (((535 + 69) < (7989 - 5108)) and (v194 == (8 - 4))) then
				v69 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v194 == (302 - (115 + 187))) or ((690 + 210) == (3197 + 180))) then
				v73 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v70 = EpicSettings.Settings['InterruptWithStun'];
				v71 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v72 = EpicSettings.Settings['InterruptThreshold'];
				v194 = 1162 - (160 + 1001);
			end
			if (((3901 + 558) > (408 + 183)) and ((5 - 2) == v194)) then
				v77 = EpicSettings.Settings['healthstoneHP'] or (358 - (237 + 121));
				v76 = EpicSettings.Settings['healingPotionHP'] or (897 - (525 + 372));
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v68 = EpicSettings.Settings['handleAfflicted'];
				v194 = 7 - 3;
			end
		end
	end
	local function v151()
		local v195 = 0 - 0;
		while true do
			if (((3540 - (96 + 46)) >= (3172 - (643 + 134))) and (v195 == (0 + 0))) then
				v149();
				v150();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v195 = 2 - 1;
			end
			if ((v195 == (7 - 5)) or ((2094 + 89) >= (5541 - 2717))) then
				v128 = v15:GetEnemiesInSplashRange(10 - 5);
				v127 = v14:GetEnemiesInRange(759 - (316 + 403));
				if (((1287 + 649) == (5322 - 3386)) and v32) then
					local v223 = 0 + 0;
					while true do
						if ((v223 == (2 - 1)) or ((3425 + 1407) < (1391 + 2922))) then
							v125 = v28(v15:GetEnemiesInSplashRangeCount(17 - 12), #v127);
							v126 = #v127;
							break;
						end
						if (((19523 - 15435) > (8047 - 4173)) and (v223 == (0 + 0))) then
							v123 = v28(v15:GetEnemiesInSplashRangeCount(9 - 4), #v127);
							v124 = v28(v15:GetEnemiesInSplashRangeCount(1 + 4), #v127);
							v223 = 2 - 1;
						end
					end
				else
					local v224 = 17 - (12 + 5);
					while true do
						if (((16825 - 12493) == (9242 - 4910)) and (v224 == (0 - 0))) then
							v123 = 2 - 1;
							v124 = 1 + 0;
							v224 = 1974 - (1656 + 317);
						end
						if (((3564 + 435) >= (2324 + 576)) and (v224 == (2 - 1))) then
							v125 = 4 - 3;
							v126 = 355 - (5 + 349);
							break;
						end
					end
				end
				if (v91.TargetIsValid() or v14:AffectingCombat() or ((11993 - 9468) > (5335 - (266 + 1005)))) then
					local v225 = 0 + 0;
					while true do
						if (((14914 - 10543) == (5754 - 1383)) and (v225 == (1696 - (561 + 1135)))) then
							if (v14:AffectingCombat() or v67 or ((345 - 79) > (16389 - 11403))) then
								local v228 = 1066 - (507 + 559);
								local v229;
								while true do
									if (((4995 - 3004) >= (2860 - 1935)) and ((389 - (212 + 176)) == v228)) then
										if (((1360 - (250 + 655)) < (5598 - 3545)) and v30) then
											return v30;
										end
										break;
									end
									if ((v228 == (0 - 0)) or ((1292 - 466) == (6807 - (1869 + 87)))) then
										v229 = v67 and v87.RemoveCurse:IsReady() and v34;
										v30 = v91.FocusUnit(v229, v89, 69 - 49, nil, 1921 - (484 + 1417));
										v228 = 2 - 1;
									end
								end
							end
							v120 = v10.BossFightRemains(nil, true);
							v225 = 1 - 0;
						end
						if (((956 - (48 + 725)) == (298 - 115)) and (v225 == (10 - 6))) then
							v116 = v14:BuffUp(v87.CombustionBuff);
							v117 = not v116;
							break;
						end
						if (((674 + 485) <= (4778 - 2990)) and (v225 == (1 + 1))) then
							v129 = v136(v127);
							v93 = not v33;
							v225 = 1 + 2;
						end
						if ((v225 == (854 - (152 + 701))) or ((4818 - (430 + 881)) > (1654 + 2664))) then
							v121 = v120;
							if ((v121 == (12006 - (557 + 338))) or ((909 + 2166) <= (8355 - 5390))) then
								v121 = v10.FightRemains(v127, false);
							end
							v225 = 6 - 4;
						end
						if (((3626 - 2261) <= (4333 - 2322)) and ((804 - (499 + 302)) == v225)) then
							if (v93 or ((3642 - (39 + 827)) > (9868 - 6293))) then
								v107 = 223335 - 123336;
							end
							v122 = v14:GCD();
							v225 = 15 - 11;
						end
					end
				end
				v195 = 3 - 0;
			end
			if ((v195 == (1 + 2)) or ((7475 - 4921) == (769 + 4035))) then
				if (((4077 - 1500) == (2681 - (103 + 1))) and not v14:AffectingCombat() and v31) then
					local v226 = 554 - (475 + 79);
					while true do
						if ((v226 == (0 - 0)) or ((19 - 13) >= (245 + 1644))) then
							v30 = v141();
							if (((446 + 60) <= (3395 - (1395 + 108))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v14:AffectingCombat() and v91.TargetIsValid()) or ((5843 - 3835) > (3422 - (7 + 1197)))) then
					local v227 = 0 + 0;
					while true do
						if (((133 + 246) <= (4466 - (27 + 292))) and (v227 == (0 - 0))) then
							if (Focus or ((5755 - 1241) <= (4231 - 3222))) then
								if (v67 or ((6893 - 3397) == (2269 - 1077))) then
									local v230 = 139 - (43 + 96);
									while true do
										if ((v230 == (0 - 0)) or ((470 - 262) == (2456 + 503))) then
											v30 = v139();
											if (((1208 + 3069) >= (2595 - 1282)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v30 = v140();
							v227 = 1 + 0;
						end
						if (((4847 - 2260) < (1000 + 2174)) and (v227 == (1 + 1))) then
							if (v69 or ((5871 - (1414 + 337)) <= (4138 - (1642 + 298)))) then
								v30 = v91.HandleIncorporeal(v87.Polymorph, v89.PolymorphMouseOver, 78 - 48, true);
								if (v30 or ((4591 - 2995) == (2546 - 1688))) then
									return v30;
								end
							end
							if (((1060 + 2160) == (2506 + 714)) and v87.Spellsteal:IsAvailable() and v84 and v87.Spellsteal:IsReady() and v34 and v66 and not v14:IsCasting() and not v14:IsChanneling() and v91.UnitHasMagicBuff(v15)) then
								if (v22(v87.Spellsteal, not v15:IsSpellInRange(v87.Spellsteal)) or ((2374 - (357 + 615)) > (2542 + 1078))) then
									return "spellsteal damage";
								end
							end
							v227 = 6 - 3;
						end
						if (((2206 + 368) == (5515 - 2941)) and ((3 + 0) == v227)) then
							if (((123 + 1675) < (1733 + 1024)) and (v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v87.HotStreakBuff)) then
								if (v22(v89.StopCasting, not v15:IsSpellInRange(v87.Pyroblast)) or ((1678 - (384 + 917)) > (3301 - (128 + 569)))) then
									return "Stop Casting";
								end
							end
							v30 = v148();
							v227 = 1547 - (1407 + 136);
						end
						if (((2455 - (687 + 1200)) < (2621 - (556 + 1154))) and (v227 == (14 - 10))) then
							if (((3380 - (9 + 86)) < (4649 - (275 + 146))) and v30) then
								return v30;
							end
							break;
						end
						if (((637 + 3279) > (3392 - (29 + 35))) and (v227 == (4 - 3))) then
							if (((7467 - 4967) < (16947 - 13108)) and v30) then
								return v30;
							end
							if (((331 + 176) == (1519 - (53 + 959))) and v68) then
								if (((648 - (312 + 96)) <= (5493 - 2328)) and v86) then
									v30 = v91.HandleAfflicted(v87.RemoveCurse, v89.RemoveCurseMouseover, 315 - (147 + 138));
									if (((1733 - (813 + 86)) >= (728 + 77)) and v30) then
										return v30;
									end
								end
							end
							v227 = 3 - 1;
						end
					end
				end
				break;
			end
			if ((v195 == (493 - (18 + 474))) or ((1287 + 2525) < (7559 - 5243))) then
				v33 = EpicSettings.Toggles['cds'];
				Kick = EpicSettings.Toggles['kick'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((3738 - (860 + 226)) <= (1836 - (121 + 182)))) then
					return;
				end
				v195 = 1 + 1;
			end
		end
	end
	local function v152()
		v92();
		v20.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(1303 - (988 + 252), v151, v152);
end;
return v0["Epix_Mage_Fire.lua"]();

