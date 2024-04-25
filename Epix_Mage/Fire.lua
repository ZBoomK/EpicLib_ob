local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((573 + 62) > (12985 - 8298))) then
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
		if (((2547 + 826) <= (4045 - (457 + 32))) and v89.RemoveCurse:IsAvailable()) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (2 + 2)) or (2401 - (832 + 570));
	local v98 = 942 + 57;
	local v99 = v97;
	local v100 = ((1 + 2) * v27(v89.FueltheFire:IsAvailable())) + ((3535 - 2536) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 482 + 517;
	local v102 = 836 - (588 + 208);
	local v103 = 2692 - 1693;
	local v104 = 1800.3 - (884 + 916);
	local v105 = 0 - 0;
	local v106 = 4 + 2;
	local v107 = false;
	local v108 = (v107 and (673 - (232 + 421))) or (1889 - (1569 + 320));
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (1 + 0);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 - 0;
	local v115 = 605 - (316 + 289);
	local v116 = 20 - 12;
	local v117 = 1 + 2;
	local v118;
	local v119;
	local v120;
	local v121 = 1456 - (666 + 787);
	local v122 = 11536 - (360 + 65);
	local v123 = 10384 + 727;
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v9:RegisterForEvent(function()
		local v156 = 254 - (79 + 175);
		while true do
			if ((v156 == (0 - 0)) or ((2569 + 722) < (10054 - 6774))) then
				v107 = false;
				v108 = (v107 and (38 - 18)) or (899 - (503 + 396));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v157 = 181 - (92 + 89);
		while true do
			if (((8507 - 4121) >= (448 + 425)) and (v157 == (2 + 1))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if (((3606 - 2685) <= (151 + 951)) and (v157 == (0 - 0))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v157 = 1 + 0;
			end
			if (((2248 + 2458) >= (2932 - 1969)) and (v157 == (1 + 1))) then
				v89.PhoenixFlames:RegisterInFlightEffect(392754 - 135212);
				v89.PhoenixFlames:RegisterInFlight();
				v157 = 1247 - (485 + 759);
			end
			if ((v157 == (2 - 1)) or ((2149 - (442 + 747)) <= (2011 - (832 + 303)))) then
				v89.Meteor:RegisterInFlightEffect(352086 - (88 + 858));
				v89.Meteor:RegisterInFlight();
				v157 = 1 + 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(290604 + 60536);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(10608 + 246934);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		local v158 = 789 - (766 + 23);
		while true do
			if ((v158 == (0 - 0)) or ((2824 - 758) == (2455 - 1523))) then
				v122 = 37711 - 26600;
				v123 = 12184 - (1036 + 37);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v159 = 0 + 0;
		while true do
			if (((9396 - 4571) < (3810 + 1033)) and (v159 == (1481 - (641 + 839)))) then
				v99 = v97;
				v110 = ((v89.Kindling:IsAvailable()) and (913.4 - (910 + 3))) or (2 - 1);
				break;
			end
			if ((v159 == (1684 - (1466 + 218))) or ((1782 + 2095) >= (5685 - (556 + 592)))) then
				v96 = v89.SunKingsBlessing:IsAvailable();
				v97 = ((v89.FlamePatch:IsAvailable()) and (2 + 1)) or (1807 - (329 + 479));
				v159 = 855 - (174 + 680);
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (309 - 219));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (186 - 96)) and v14:TimeToX(65 + 25)) or (739 - (396 + 343)))) or (0 + 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (1507 - (29 + 1448)));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (1419 - (135 + 1254)));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v160 = 0 - 0;
		local v161;
		while true do
			if ((v160 == (0 - 0)) or ((2876 + 1439) < (3253 - (389 + 1138)))) then
				v161 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (574 - (102 + 472));
				v161 = v161 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(1 + 0, v89.PhoenixFlames));
				v160 = 1 + 0;
			end
			if ((v160 == (1 + 0)) or ((5224 - (320 + 1225)) < (1112 - 487))) then
				return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast) or (v161 > (0 + 0))))));
			end
		end
	end
	local function v138(v162)
		local v163 = 1464 - (157 + 1307);
		local v164;
		while true do
			if (((1860 - (821 + 1038)) == v163) or ((11539 - 6914) < (70 + 562))) then
				return v164;
			end
			if (((0 - 0) == v163) or ((31 + 52) > (4411 - 2631))) then
				v164 = 1026 - (834 + 192);
				for v224, v225 in pairs(v162) do
					if (((35 + 511) <= (277 + 800)) and v225:DebuffUp(v89.IgniteDebuff)) then
						v164 = v164 + 1 + 0;
					end
				end
				v163 = 1 - 0;
			end
		end
	end
	local function v139()
		local v165 = 304 - (300 + 4);
		if (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight() or ((266 + 730) > (11258 - 6957))) then
			v165 = v165 + (363 - (112 + 250));
		end
		return v165;
	end
	local function v140()
		v31 = v93.HandleTopTrinket(v92, v34, 16 + 24, nil);
		if (((10196 - 6126) > (394 + 293)) and v31) then
			return v31;
		end
		v31 = v93.HandleBottomTrinket(v92, v34, 21 + 19, nil);
		if (v31 or ((491 + 165) >= (1652 + 1678))) then
			return v31;
		end
	end
	local v141 = 0 + 0;
	local function v142()
		if ((v89.RemoveCurse:IsReady() and (v93.UnitHasDispellableDebuffByPlayer(v15) or v93.DispellableFriendlyUnit(1439 - (1001 + 413)) or v93.UnitHasCurseDebuff(v15))) or ((5556 - 3064) <= (1217 - (244 + 638)))) then
			if (((5015 - (627 + 66)) >= (7633 - 5071)) and (v141 == (602 - (512 + 90)))) then
				v141 = GetTime();
			end
			if (v93.Wait(2406 - (1665 + 241), v141) or ((4354 - (373 + 344)) >= (1701 + 2069))) then
				local v226 = 0 + 0;
				while true do
					if ((v226 == (0 - 0)) or ((4025 - 1646) > (5677 - (35 + 1064)))) then
						if (v23(v91.RemoveCurseFocus) or ((352 + 131) > (1589 - 846))) then
							return "remove_curse dispel";
						end
						v141 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v143()
		local v166 = 1236 - (298 + 938);
		while true do
			if (((3713 - (233 + 1026)) > (2244 - (636 + 1030))) and (v166 == (1 + 0))) then
				if (((909 + 21) < (1325 + 3133)) and v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) then
					if (((45 + 617) <= (1193 - (55 + 166))) and v23(v89.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((847 + 3523) == (440 + 3930)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
					if (v23(v89.IceColdAbility) or ((18186 - 13424) <= (1158 - (36 + 261)))) then
						return "ice_cold defensive 3";
					end
				end
				v166 = 3 - 1;
			end
			if (((1368 - (34 + 1334)) == v166) or ((543 + 869) == (3314 + 950))) then
				if ((v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((4451 - (1035 + 248)) < (2174 - (20 + 1)))) then
					if (v23(v89.BlazingBarrier) or ((2593 + 2383) < (1651 - (134 + 185)))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((5761 - (549 + 584)) == (5313 - (314 + 371))) and v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 6 - 4, v89.ArcaneIntellect)) then
					if (v23(v89.MassBarrier) or ((1022 - (478 + 490)) == (210 + 185))) then
						return "mass_barrier defensive 2";
					end
				end
				v166 = 1173 - (786 + 386);
			end
			if (((265 - 183) == (1461 - (1055 + 324))) and (v166 == (1342 - (1093 + 247)))) then
				if ((v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((517 + 64) < (30 + 252))) then
					if (v23(v89.MirrorImage) or ((18298 - 13689) < (8467 - 5972))) then
						return "mirror_image defensive 4";
					end
				end
				if (((3277 - 2125) == (2894 - 1742)) and v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
					if (((675 + 1221) <= (13182 - 9760)) and v23(v89.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v166 = 10 - 7;
			end
			if ((v166 == (4 + 0)) or ((2531 - 1541) > (2308 - (364 + 324)))) then
				if ((v76 and (v13:HealthPercentage() <= v78)) or ((2404 - 1527) > (11266 - 6571))) then
					if (((892 + 1799) >= (7745 - 5894)) and (v80 == "Refreshing Healing Potion")) then
						if (v90.RefreshingHealingPotion:IsReady() or ((4780 - 1795) >= (14748 - 9892))) then
							if (((5544 - (1249 + 19)) >= (1079 + 116)) and v23(v91.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((12580 - 9348) <= (5776 - (686 + 400))) and (v80 == "Dreamwalker's Healing Potion")) then
						if (v90.DreamwalkersHealingPotion:IsReady() or ((704 + 192) >= (3375 - (73 + 156)))) then
							if (((15 + 3046) >= (3769 - (721 + 90))) and v23(v91.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((36 + 3151) >= (2090 - 1446)) and (v166 == (473 - (224 + 246)))) then
				if (((1042 - 398) <= (1295 - 591)) and v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
					if (((174 + 784) > (23 + 924)) and v23(v89.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if (((3300 + 1192) >= (5276 - 2622)) and v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) then
					if (((11454 - 8012) >= (2016 - (203 + 310))) and v23(v91.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v166 = 1997 - (1238 + 755);
			end
		end
	end
	local function v144()
		if ((v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) or ((222 + 2948) <= (2998 - (709 + 825)))) then
			if (v23(v89.ArcaneIntellect) or ((8839 - 4042) == (6391 - 2003))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((1415 - (196 + 668)) <= (2688 - 2007)) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) then
			if (((6787 - 3510) > (1240 - (171 + 662))) and v23(v89.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if (((4788 - (4 + 89)) >= (4959 - 3544)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((1170 + 2042) <= (4146 - 3202))) then
				return "pyroblast precombat 4";
			end
		end
		if ((v89.Fireball:IsReady() and v40) or ((1215 + 1881) <= (3284 - (35 + 1451)))) then
			if (((4990 - (28 + 1425)) == (5530 - (941 + 1052))) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v145()
		if (((3680 + 157) >= (3084 - (822 + 692))) and v89.LivingBomb:IsReady() and v42 and (v126 > (1 - 0)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 + 0)))) then
			if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes)) or ((3247 - (45 + 252)) == (3772 + 40))) then
				return "living_bomb active_talents 2";
			end
		end
		if (((1626 + 3097) >= (5641 - 3323)) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (433 - (114 + 319))) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((64 - 19) < v109) or (v123 < v109))))) then
			if (v23(v91.MeteorCursor, not v14:IsInRange(51 - 11)) or ((1293 + 734) > (4248 - 1396))) then
				return "meteor active_talents 4";
			end
		end
		if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (31 - 16))) and not v135() and (v133() == (1963 - (556 + 1407))) and not v89.TemperedFlames:IsAvailable()) or ((2342 - (741 + 465)) > (4782 - (170 + 295)))) then
			if (((2502 + 2246) == (4362 + 386)) and v23(v89.DragonsBreath, not v14:IsInRange(24 - 14))) then
				return "dragons_breath active_talents 6";
			end
		end
		if (((3098 + 638) <= (3040 + 1700)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (9 + 6))) and not v135() and v89.TemperedFlames:IsAvailable()) then
			if (v23(v89.DragonsBreath, not v14:IsInRange(1240 - (957 + 273))) or ((907 + 2483) <= (1225 + 1835))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v146()
		local v167 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
		if (v167 or ((3806 - 2807) > (7096 - 4403))) then
			return v167;
		end
		if (((1414 - 951) < (2975 - 2374)) and v81 and ((v84 and v34) or not v84) and (v74 < v123)) then
			local v177 = 1780 - (389 + 1391);
			while true do
				if ((v177 == (1 + 0)) or ((228 + 1955) < (1563 - 876))) then
					if (((5500 - (783 + 168)) == (15267 - 10718)) and v89.Fireblood:IsCastable()) then
						if (((4596 + 76) == (4983 - (309 + 2))) and v23(v89.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (v89.AncestralCall:IsCastable() or ((11264 - 7596) < (1607 - (1090 + 122)))) then
						if (v23(v89.AncestralCall) or ((1351 + 2815) == (1527 - 1072))) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
				if ((v177 == (0 + 0)) or ((5567 - (628 + 490)) == (478 + 2185))) then
					if (v89.BloodFury:IsCastable() or ((10588 - 6311) < (13659 - 10670))) then
						if (v23(v89.BloodFury) or ((1644 - (431 + 343)) >= (8378 - 4229))) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if (((6398 - 4186) < (2515 + 668)) and v89.Berserking:IsCastable() and v118) then
						if (((595 + 4051) > (4687 - (556 + 1139))) and v23(v89.Berserking)) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v177 = 16 - (6 + 9);
				end
			end
		end
		if (((263 + 1171) < (1592 + 1514)) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) then
			if (((955 - (28 + 141)) < (1171 + 1852)) and v23(v89.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v74 < v123) or ((3013 - 571) < (53 + 21))) then
			if (((5852 - (486 + 831)) == (11801 - 7266)) and v82 and ((v34 and v83) or not v83)) then
				local v227 = 0 - 0;
				while true do
					if ((v227 == (0 + 0)) or ((9514 - 6505) <= (3368 - (668 + 595)))) then
						v31 = v140();
						if (((1647 + 183) < (740 + 2929)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v147()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (298 - (23 + 267))) or ((3374 - (1129 + 815)) >= (3999 - (371 + 16)))) then
				if (((4433 - (1326 + 424)) >= (4659 - 2199)) and v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((6592 - 4788) >= (3393 - (88 + 30)))) then
						return "scorch combustion_phase 44";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) or ((2188 - (720 + 51)) > (8072 - 4443))) then
					if (((6571 - (421 + 1355)) > (662 - 260)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((2365 + 2448) > (4648 - (286 + 797))) and v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (3 - 2))) then
					if (((6479 - 2567) == (4351 - (397 + 42))) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if (((882 + 1939) <= (5624 - (24 + 776))) and (v168 == (4 - 1))) then
				if (((2523 - (222 + 563)) <= (4836 - 2641)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (((30 + 11) <= (3208 - (23 + 167))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((3943 - (690 + 1108)) <= (1481 + 2623)) and v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (2 + 0)) and not v135()) then
					if (((3537 - (40 + 808)) < (798 + 4047)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) or ((8879 - 6557) > (2507 + 115))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((2399 + 2135) == (1142 + 940))) then
						return "scorch combustion_phase 18";
					end
				end
				v168 = 575 - (47 + 524);
			end
			if ((v168 == (0 + 0)) or ((4294 - 2723) > (2790 - 923))) then
				if ((v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) or ((6052 - 3398) >= (4722 - (1165 + 561)))) then
					if (((119 + 3859) > (6516 - 4412)) and v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((1143 + 1852) > (2020 - (341 + 138))) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (((878 + 2371) > (1966 - 1013)) and v23(v89.BagofTricks)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v89.LivingBomb:IsReady() and v33 and v42 and (v126 > (327 - (89 + 237))) and v119) or ((10529 - 7256) > (9627 - 5054))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes)) or ((4032 - (581 + 300)) < (2504 - (855 + 365)))) then
						return "living_bomb combustion_phase 6";
					end
				end
				v168 = 2 - 1;
			end
			if ((v168 == (1 + 1)) or ((3085 - (1030 + 205)) == (1436 + 93))) then
				if (((764 + 57) < (2409 - (156 + 130))) and v31) then
					return v31;
				end
				if (((2049 - 1147) < (3918 - 1593)) and v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 + 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) then
					if (((501 + 357) <= (3031 - (10 + 59))) and v23(v89.Combustion, not v14:IsInRange(12 + 28), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((19433 - 15487) < (2451 - (671 + 492)))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(32 + 8), v13:BuffDown(v89.IceFloes)) or ((4457 - (369 + 846)) == (151 + 416))) then
						return "flamestrike combustion_phase 12";
					end
				end
				v168 = 3 + 0;
			end
			if ((v168 == (1952 - (1036 + 909))) or ((674 + 173) >= (2120 - 857))) then
				if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(233 - (11 + 192), 2 + 0) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (177 - (135 + 40))) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((9 - 5) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (1 + 0)) or v13:BuffUp(v89.FlamesFuryBuff))) or ((4963 - 2710) == (2774 - 923))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((2263 - (50 + 126)) > (6604 - 4232))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) or ((984 + 3461) < (5562 - (1233 + 180)))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((2787 - (522 + 447)) == (1506 - (107 + 1314)))) then
						return "fireball combustion_phase 40";
					end
				end
				if (((293 + 337) < (6481 - 4354)) and v89.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(13 + 17, 3 - 1) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (7 - 5))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((3848 - (716 + 1194)) == (43 + 2471))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v168 = 1 + 7;
			end
			if (((4758 - (74 + 429)) >= (106 - 51)) and (v168 == (3 + 2))) then
				if (((6864 - 3865) > (818 + 338)) and v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) then
					if (((7244 - 4894) > (2855 - 1700)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast combustion_phase 26";
					end
				end
				if (((4462 - (279 + 154)) <= (5631 - (454 + 324))) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((533 - (12 + 5)) > (1852 + 1582))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((10308 - 6262) >= (1121 + 1912)) and v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (1093 - (277 + 816))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(170 - 130)) or ((3902 - (1058 + 125)) <= (272 + 1175))) then
						return "shifting_power combustion_phase 30";
					end
				end
				v168 = 981 - (815 + 160);
			end
			if ((v168 == (4 - 3)) or ((9813 - 5679) < (937 + 2989))) then
				if ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (58 - 38)) or ((2062 - (41 + 1857)) >= (4678 - (1222 + 671)))) then
					v31 = v146();
					if (v31 or ((1356 - 831) == (3030 - 921))) then
						return v31;
					end
				end
				if (((1215 - (229 + 953)) == (1807 - (1111 + 663))) and v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(1609 - (874 + 705), 1 + 1) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((3 + 1) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((6347 - 3293) <= (113 + 3902)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v145();
				v168 = 681 - (642 + 37);
			end
			if (((427 + 1444) < (542 + 2840)) and (v168 == (14 - 8))) then
				if (((1747 - (233 + 221)) <= (5008 - 2842)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(36 + 4), v13:BuffDown(v89.IceFloes)) or ((4120 - (718 + 823)) < (78 + 45))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((1651 - (266 + 539)) >= (6704 - 4336))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((5237 - (636 + 589)) <= (7970 - 4612))) then
						return "pyroblast combustion_phase 34";
					end
				end
				if (((3081 - 1587) <= (2382 + 623)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((2 + 2) * v124)) and (v127 < v99)) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((4126 - (657 + 358)) == (5650 - 3516))) then
						return "scorch combustion_phase 36";
					end
				end
				v168 = 15 - 8;
			end
			if (((3542 - (1151 + 36)) == (2275 + 80)) and (v168 == (2 + 2))) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((11 - 7) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (1832 - (1552 + 280))))) < (836 - (64 + 770)))) or ((400 + 188) <= (980 - 548))) then
					if (((852 + 3945) >= (5138 - (157 + 1086))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((7159 - 3582) == (15666 - 12089)) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
					if (((5819 - 2025) > (5039 - 1346)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(859 - (599 + 220)), v13:BuffDown(v89.IceFloes))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) or ((2538 - 1263) == (6031 - (1813 + 118)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((1163 + 428) >= (4797 - (841 + 376)))) then
						return "pyroblast combustion_phase 24";
					end
				end
				v168 = 6 - 1;
			end
		end
	end
	local function v148()
		local v169 = 0 + 0;
		while true do
			if (((2683 - 1700) <= (2667 - (464 + 395))) and ((2 - 1) == v169)) then
				v109 = v114;
				if ((v89.Firestarter:IsAvailable() and not v96) or ((1033 + 1117) <= (2034 - (467 + 370)))) then
					v109 = v29(v133(), v109);
				end
				v169 = 3 - 1;
			end
			if (((2767 + 1002) >= (4021 - 2848)) and (v169 == (1 + 1))) then
				if (((3454 - 1969) == (2005 - (150 + 370))) and v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) then
					v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (1285 - (74 + 1208)) * v124, v109);
				end
				v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
				v169 = 7 - 4;
			end
			if ((v169 == (14 - 11)) or ((2359 + 956) <= (3172 - (14 + 376)))) then
				if (((v114 + ((208 - 88) * ((1 + 0) - ((0.4 + 0 + ((0.2 + 0) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (58 - 38))) or ((660 + 216) >= (3042 - (23 + 55)))) then
					v109 = v114;
				end
				break;
			end
			if (((0 - 0) == v169) or ((1490 + 742) > (2243 + 254))) then
				v114 = v89.Combustion:CooldownRemains() * v110;
				v115 = ((v89.Fireball:CastTime() * v27(v125 < v99)) + (v89.Flamestrike:CastTime() * v27(v125 >= v99))) - v104;
				v169 = 1 - 0;
			end
		end
	end
	local function v149()
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (902 - (652 + 249))) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((5 - 3) * v124)))) or ((3978 - (708 + 1160)) <= (901 - 569))) then
			if (((6720 - 3034) > (3199 - (10 + 17))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(1762 - (1400 + 332), 3 - 1) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((1910 - (242 + 1666)) * v124)))) or ((1915 + 2559) < (301 + 519))) then
			if (((3647 + 632) >= (3822 - (850 + 90))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v150()
		if ((v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v97) and v137()) or ((3553 - 1524) >= (4911 - (360 + 1030)))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(36 + 4), v13:BuffDown(v89.IceFloes)) or ((5749 - 3712) >= (6386 - 1744))) then
				return "flamestrike standard_rotation 2";
			end
		end
		if (((3381 - (909 + 752)) < (5681 - (109 + 1114))) and v89.Pyroblast:IsReady() and v45 and (v137())) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((797 - 361) > (1176 + 1845))) then
				return "pyroblast standard_rotation 4";
			end
		end
		if (((955 - (6 + 236)) <= (534 + 313)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v125 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) then
			if (((1734 + 420) <= (9506 - 5475)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(69 - 29), v13:BuffDown(v89.IceFloes))) then
				return "flamestrike standard_rotation 12";
			end
		end
		if (((5748 - (1076 + 57)) == (759 + 3856)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((694 - (579 + 110)) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((300 + 3490) == (443 + 57))) then
				return "scorch standard_rotation 13";
			end
		end
		if (((48 + 41) < (628 - (174 + 233))) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) then
			if (((5737 - 3683) >= (2493 - 1072)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast standard_rotation 14";
			end
		end
		if (((308 + 384) < (4232 - (663 + 511))) and v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and ((((v13:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 + 0)) or not v89.Hyperthermia:IsAvailable())) or (v13:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v89.Hyperthermia:IsAvailable()))) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (9 - 6))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (0 + 0))))))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((7660 - 4406) == (4006 - 2351))) then
				return "fire_blast standard_rotation 16";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(1 + 0, v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((2522 - 1226) == (3500 + 1410))) then
			if (((308 + 3060) == (4090 - (478 + 244))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast standard_rotation 18";
			end
		end
		if (((3160 - (440 + 77)) < (1735 + 2080)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((14 - 10) * v124))) then
			if (((3469 - (655 + 901)) > (92 + 401)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch standard_rotation 19";
			end
		end
		if (((3641 + 1114) > (2315 + 1113)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((7 - 5) * v124)))) then
			if (((2826 - (695 + 750)) <= (8089 - 5720)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames standard_rotation 20";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(46 - 16, 7 - 5) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((353 - (285 + 66)) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((11289 - 6446) == (5394 - (682 + 628)))) then
			if (((753 + 3916) > (662 - (176 + 123))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames standard_rotation 21";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((786 + 1091) >= (2277 + 861))) then
			if (((5011 - (239 + 30)) >= (986 + 2640)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch standard_rotation 22";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or ((4364 + 176) == (1620 - 704))) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((3606 - 2450) > (4660 - (306 + 9)))) then
				return "phoenix_flames standard_rotation 24";
			end
		end
		if (((7806 - 5569) < (739 + 3510)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (0 + 0)) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (1.5 + 1)) or ((v89.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((1378 - (1140 + 235)) * v124)))))) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((1708 + 975) < (22 + 1))) then
				return "phoenix_flames standard_rotation 26";
			end
		end
		v31 = v145();
		if (((179 + 518) <= (878 - (33 + 19))) and v31) then
			return v31;
		end
		if (((399 + 706) <= (3524 - 2348)) and v33 and v89.DragonsBreath:IsReady() and v38 and (v127 > (1 + 0)) and v89.AlexstraszasFury:IsAvailable()) then
			if (((6626 - 3247) <= (3575 + 237)) and v23(v89.DragonsBreath, not v14:IsInRange(699 - (586 + 103)))) then
				return "dragons_breath standard_rotation 28";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and (v134())) or ((72 + 716) >= (4974 - 3358))) then
			if (((3342 - (1309 + 179)) <= (6099 - 2720)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch standard_rotation 30";
			end
		end
		if (((1980 + 2569) == (12216 - 7667)) and v33 and v89.ArcaneExplosion:IsReady() and v36 and (v128 >= v101) and (v13:ManaPercentageP() >= v102)) then
			if (v23(v89.ArcaneExplosion, not v14:IsInRange(7 + 1)) or ((6420 - 3398) >= (6025 - 3001))) then
				return "arcane_explosion standard_rotation 32";
			end
		end
		if (((5429 - (295 + 314)) > (5398 - 3200)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v98)) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(2002 - (1300 + 662))) or ((3331 - 2270) >= (6646 - (1178 + 577)))) then
				return "flamestrike standard_rotation 34";
			end
		end
		if (((709 + 655) <= (13222 - 8749)) and v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((5000 - (851 + 554)) <= (3 + 0))) then
				return "pyroblast standard_rotation 35";
			end
		end
		if ((v89.Fireball:IsReady() and v40 and not v137()) or ((12956 - 8284) == (8365 - 4513))) then
			if (((1861 - (115 + 187)) == (1194 + 365)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
				return "fireball standard_rotation 36";
			end
		end
	end
	local function v151()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (0 - 0)) or ((2913 - (160 + 1001)) <= (690 + 98))) then
				if (not v95 or ((2696 + 1211) == (361 - 184))) then
					v148();
				end
				if (((3828 - (237 + 121)) > (1452 - (525 + 372))) and v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (75 - 35)))) then
					if (v23(v89.TimeWarp, not v14:IsInRange(131 - 91)) or ((1114 - (96 + 46)) == (1422 - (643 + 134)))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((1149 + 2033) >= (5071 - 2956)) and (v74 < v123)) then
					if (((14453 - 10560) < (4248 + 181)) and v82 and ((v34 and v83) or not v83)) then
						local v236 = 0 - 0;
						while true do
							if (((0 - 0) == v236) or ((3586 - (316 + 403)) < (1267 + 638))) then
								v31 = v140();
								if (v31 or ((4937 - 3141) >= (1465 + 2586))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v170 = 2 - 1;
			end
			if (((1148 + 471) <= (1211 + 2545)) and (v170 == (3 - 2))) then
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (4 - 3)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((24 - 12) / v89.FireBlast:Cooldown()) % (1 + 0)))) and (v109 < v123);
				if (((1188 - 584) == (30 + 574)) and not v95 and ((v109 <= (0 - 0)) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) then
					local v228 = 17 - (12 + 5);
					while true do
						if (((0 - 0) == v228) or ((9567 - 5083) == (1913 - 1013))) then
							v31 = v147();
							if (v31 or ((11057 - 6598) <= (226 + 887))) then
								return v31;
							end
							break;
						end
					end
				end
				if (((5605 - (1656 + 317)) > (3028 + 370)) and not v113 and v89.SunKingsBlessing:IsAvailable()) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((3 + 0) * v124));
				end
				if (((10853 - 6771) <= (24199 - 19282)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (354 - (5 + 349))) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
					if (((22951 - 18119) >= (2657 - (266 + 1005))) and v23(v89.ShiftingPower, not v14:IsInRange(27 + 13), true)) then
						return "shifting_power main 12";
					end
				end
				v170 = 6 - 4;
			end
			if (((179 - 42) == (1833 - (561 + 1135))) and ((2 - 0) == v170)) then
				if ((v125 < v99) or ((5160 - 3590) >= (5398 - (507 + 559)))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (17 - 10)) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v125 >= v99) or ((12568 - 8504) <= (2207 - (212 + 176)))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (905 - (250 + 655))) and (v125 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (2 - 0)))) or ((7800 - 2814) < (3530 - (1869 + 87)))) then
					if (((15351 - 10925) > (2073 - (484 + 1417))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast main 14";
					end
				end
				if (((1255 - 669) > (762 - 307)) and v119 and v132() and (v109 > (773 - (48 + 725)))) then
					local v229 = 0 - 0;
					while true do
						if (((2215 - 1389) == (481 + 345)) and (v229 == (0 - 0))) then
							v31 = v149();
							if (v31 or ((1125 + 2894) > (1295 + 3146))) then
								return v31;
							end
							break;
						end
					end
				end
				v170 = 856 - (152 + 701);
			end
			if (((3328 - (430 + 881)) < (1632 + 2629)) and (v170 == (898 - (557 + 338)))) then
				if (((1394 + 3322) > (225 - 145)) and v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((12280 - 8773) == (8692 - 5420))) then
						return "fire_blast main 16";
					end
				end
				if (((v109 > (0 - 0)) and v119) or ((1677 - (499 + 302)) >= (3941 - (39 + 827)))) then
					local v230 = 0 - 0;
					while true do
						if (((9719 - 5367) > (10144 - 7590)) and (v230 == (0 - 0))) then
							v31 = v150();
							if (v31 or ((378 + 4028) < (11833 - 7790))) then
								return v31;
							end
							break;
						end
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((303 + 1586) >= (5353 - 1970))) then
					if (((1996 - (103 + 1)) <= (3288 - (475 + 79))) and v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova))) then
						return "ice_nova main 18";
					end
				end
				if (((4156 - 2233) < (7097 - 4879)) and v89.Scorch:IsReady() and v46) then
					if (((281 + 1892) > (334 + 45)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch main 20";
					end
				end
				break;
			end
		end
	end
	local function v152()
		local v171 = 1503 - (1395 + 108);
		while true do
			if ((v171 == (17 - 11)) or ((3795 - (7 + 1197)) == (1487 + 1922))) then
				v60 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v61 = EpicSettings.Settings['blazingBarrierHP'] or (319 - (27 + 292));
				v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v171 = 29 - 22;
			end
			if (((8901 - 4387) > (6330 - 3006)) and (v171 == (141 - (43 + 96)))) then
				v44 = EpicSettings.Settings['usePhoenixFlames'];
				v45 = EpicSettings.Settings['usePyroblast'];
				v46 = EpicSettings.Settings['useScorch'];
				v47 = EpicSettings.Settings['useCounterspell'];
				v171 = 12 - 9;
			end
			if ((v171 == (0 - 0)) or ((173 + 35) >= (1364 + 3464))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v39 = EpicSettings.Settings['useFireBlast'];
				v171 = 1 - 0;
			end
			if ((v171 == (4 + 4)) or ((2966 - 1383) > (1123 + 2444))) then
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v171 == (1 + 6)) or ((3064 - (1414 + 337)) == (2734 - (1642 + 298)))) then
				v64 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v65 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v66 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v85 = EpicSettings.Settings['mirrorImageBeforePull'];
				v171 = 3 + 5;
			end
			if (((2470 + 704) > (3874 - (357 + 615))) and (v171 == (3 + 0))) then
				v48 = EpicSettings.Settings['useBlastWave'];
				v49 = EpicSettings.Settings['useCombustion'];
				v50 = EpicSettings.Settings['useShiftingPower'];
				v51 = EpicSettings.Settings['combustionWithCD'];
				v171 = 9 - 5;
			end
			if (((3531 + 589) <= (9129 - 4869)) and (v171 == (4 + 0))) then
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['useAlterTime'];
				v54 = EpicSettings.Settings['useBlazingBarrier'];
				v55 = EpicSettings.Settings['useGreaterInvisibility'];
				v171 = 1 + 4;
			end
			if ((v171 == (4 + 1)) or ((2184 - (384 + 917)) > (5475 - (128 + 569)))) then
				v56 = EpicSettings.Settings['useIceBlock'];
				v57 = EpicSettings.Settings['useIceCold'];
				v59 = EpicSettings.Settings['useMassBarrier'];
				v58 = EpicSettings.Settings['useMirrorImage'];
				v171 = 1549 - (1407 + 136);
			end
			if ((v171 == (1888 - (687 + 1200))) or ((5330 - (556 + 1154)) >= (17206 - 12315))) then
				v40 = EpicSettings.Settings['useFireball'];
				v41 = EpicSettings.Settings['useFlamestrike'];
				v42 = EpicSettings.Settings['useLivingBomb'];
				v43 = EpicSettings.Settings['useMeteor'];
				v171 = 97 - (9 + 86);
			end
		end
	end
	local function v153()
		local v172 = 421 - (275 + 146);
		while true do
			if (((693 + 3565) > (1001 - (29 + 35))) and ((22 - 17) == v172)) then
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v172 == (0 - 0)) or ((21494 - 16625) < (591 + 315))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (1012 - (53 + 959));
				v75 = EpicSettings.Settings['useWeapon'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v172 = 409 - (312 + 96);
			end
			if ((v172 == (3 - 1)) or ((1510 - (147 + 138)) > (5127 - (813 + 86)))) then
				v67 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v81 = EpicSettings.Settings['useRacials'];
				v172 = 3 + 0;
			end
			if (((6165 - 2837) > (2730 - (18 + 474))) and ((1 + 0) == v172)) then
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v172 = 6 - 4;
			end
			if (((4925 - (860 + 226)) > (1708 - (121 + 182))) and (v172 == (1 + 2))) then
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v172 = 1244 - (988 + 252);
			end
			if ((v172 == (1 + 3)) or ((406 + 887) <= (2477 - (49 + 1921)))) then
				v76 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (890 - (223 + 667));
				v78 = EpicSettings.Settings['healingPotionHP'] or (52 - (51 + 1));
				v172 = 8 - 3;
			end
		end
	end
	local function v154()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (1127 - (146 + 979))) or ((818 + 2078) < (1410 - (311 + 294)))) then
				v129 = v13:GetEnemiesInRange(111 - 71);
				if (((982 + 1334) == (3759 - (496 + 947))) and v33) then
					local v231 = 1358 - (1233 + 125);
					while true do
						if ((v231 == (1 + 0)) or ((2306 + 264) == (292 + 1241))) then
							v127 = v29(v14:GetEnemiesInSplashRangeCount(1650 - (963 + 682)), #v129);
							v128 = #v129;
							break;
						end
						if ((v231 == (0 + 0)) or ((2387 - (504 + 1000)) == (984 + 476))) then
							v125 = v29(v14:GetEnemiesInSplashRangeCount(5 + 0), #v129);
							v126 = v29(v14:GetEnemiesInSplashRangeCount(1 + 4), #v129);
							v231 = 1 - 0;
						end
					end
				else
					local v232 = 0 + 0;
					while true do
						if ((v232 == (0 + 0)) or ((4801 - (156 + 26)) <= (576 + 423))) then
							v125 = 1 - 0;
							v126 = 165 - (149 + 15);
							v232 = 961 - (890 + 70);
						end
						if ((v232 == (118 - (39 + 78))) or ((3892 - (14 + 468)) > (9051 - 4935))) then
							v127 = 2 - 1;
							v128 = 1 + 0;
							break;
						end
					end
				end
				if (v93.TargetIsValid() or v13:AffectingCombat() or ((543 + 360) >= (650 + 2409))) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (2 + 2)) or ((7610 - 3634) < (2824 + 33))) then
							v118 = v13:BuffUp(v89.CombustionBuff);
							v119 = not v118;
							break;
						end
						if (((17324 - 12394) > (59 + 2248)) and (v233 == (51 - (12 + 39)))) then
							if (v13:AffectingCombat() or v68 or ((3765 + 281) < (3995 - 2704))) then
								local v237 = v68 and v89.RemoveCurse:IsReady() and v35;
								v31 = v93.FocusUnit(v237, nil, 71 - 51, nil, 6 + 14, v89.ArcaneIntellect);
								if (v31 or ((2233 + 2008) == (8989 - 5444))) then
									return v31;
								end
							end
							v122 = v9.BossFightRemains(nil, true);
							v233 = 1 + 0;
						end
						if ((v233 == (9 - 7)) or ((5758 - (1596 + 114)) > (11048 - 6816))) then
							v131 = v138(v129);
							v95 = not v34;
							v233 = 716 - (164 + 549);
						end
						if (((1441 - (1059 + 379)) == v233) or ((2173 - 423) >= (1800 + 1673))) then
							if (((534 + 2632) == (3558 - (145 + 247))) and v95) then
								v109 = 82053 + 17946;
							end
							v124 = v13:GCD();
							v233 = 2 + 2;
						end
						if (((5226 - 3463) < (715 + 3009)) and ((1 + 0) == v233)) then
							v123 = v122;
							if (((92 - 35) <= (3443 - (254 + 466))) and (v123 == (11671 - (544 + 16)))) then
								v123 = v9.FightRemains(v129, false);
							end
							v233 = 5 - 3;
						end
					end
				end
				if ((not v13:AffectingCombat() and v32) or ((2698 - (294 + 334)) == (696 - (236 + 17)))) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (0 + 0)) or ((10187 - 7482) == (6595 - 5202))) then
							v31 = v144();
							if (v31 or ((2369 + 2232) < (51 + 10))) then
								return v31;
							end
							break;
						end
					end
				end
				v173 = 797 - (413 + 381);
			end
			if ((v173 == (1 + 2)) or ((2956 - 1566) >= (12322 - 7578))) then
				if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((3973 - (582 + 1388)) > (6532 - 2698))) then
					local v235 = 0 + 0;
					while true do
						if (((365 - (326 + 38)) == v235) or ((461 - 305) > (5585 - 1672))) then
							if (((815 - (47 + 573)) == (69 + 126)) and v69) then
								if (((13187 - 10082) >= (2914 - 1118)) and v88) then
									v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 1694 - (1269 + 395));
									if (((4871 - (76 + 416)) >= (2574 - (319 + 124))) and v31) then
										return v31;
									end
								end
							end
							if (((8786 - 4942) >= (3050 - (564 + 443))) and v70) then
								local v238 = 0 - 0;
								while true do
									if ((v238 == (458 - (337 + 121))) or ((9469 - 6237) <= (9097 - 6366))) then
										v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 1941 - (1261 + 650));
										if (((2076 + 2829) == (7816 - 2911)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) or ((5953 - (772 + 1045)) >= (623 + 3788))) then
								if (v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal)) or ((3102 - (102 + 42)) == (5861 - (1524 + 320)))) then
									return "spellsteal damage";
								end
							end
							if (((2498 - (1049 + 221)) >= (969 - (18 + 138))) and (v13:IsCasting(v89.Pyroblast) or v13:IsChanneling(v89.Pyroblast) or v13:IsCasting(v89.Flamestrike) or v13:IsChanneling(v89.Flamestrike)) and v13:BuffUp(v89.HotStreakBuff)) then
								if (v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast), false, true) or ((8456 - 5001) > (5152 - (67 + 1035)))) then
									return "Stop Casting";
								end
							end
							v235 = 350 - (136 + 212);
						end
						if (((1032 - 789) == (195 + 48)) and (v235 == (0 + 0))) then
							if ((v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) or ((1875 - (240 + 1364)) > (2654 - (1050 + 32)))) then
								if (((9779 - 7040) < (1948 + 1345)) and v23(v91.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if ((v68 and v35 and v89.RemoveCurse:IsAvailable()) or ((4997 - (331 + 724)) < (92 + 1042))) then
								local v239 = 644 - (269 + 375);
								while true do
									if (((725 - (267 + 458)) == v239) or ((838 + 1855) == (9563 - 4590))) then
										if (((2964 - (667 + 151)) == (3643 - (1410 + 87))) and v15) then
											local v240 = 1897 - (1504 + 393);
											while true do
												if (((0 - 0) == v240) or ((5821 - 3577) == (4020 - (461 + 335)))) then
													v31 = v142();
													if (v31 or ((627 + 4277) <= (3677 - (1730 + 31)))) then
														return v31;
													end
													break;
												end
											end
										end
										if (((1757 - (728 + 939)) <= (3771 - 2706)) and v17 and v17:Exists() and not v13:CanAttack(v17) and v93.UnitHasCurseDebuff(v17)) then
											if (((9740 - 4938) == (11002 - 6200)) and v89.RemoveCurse:IsReady()) then
												if (v23(v91.RemoveCurseMouseover) or ((3348 - (138 + 930)) <= (467 + 44))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							v31 = v143();
							if (v31 or ((1311 + 365) <= (397 + 66))) then
								return v31;
							end
							v235 = 4 - 3;
						end
						if (((5635 - (459 + 1307)) == (5739 - (474 + 1396))) and (v235 == (2 - 0))) then
							if (((1086 + 72) <= (9 + 2604)) and v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) then
								if (v23(v89.IceFloes) or ((6771 - 4407) <= (254 + 1745))) then
									return "ice_floes movement";
								end
							end
							v31 = v151();
							if (v31 or ((16430 - 11508) < (846 - 652))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v173 == (591 - (562 + 29))) or ((1783 + 308) < (1450 - (374 + 1045)))) then
				v152();
				v153();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v173 = 1 + 0;
			end
			if ((v173 == (2 - 1)) or ((3068 - (448 + 190)) >= (1573 + 3299))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((2154 + 2616) < (1131 + 604))) then
					return v31;
				end
				v130 = v14:GetEnemiesInSplashRange(19 - 14);
				v173 = 5 - 3;
			end
		end
	end
	local function v155()
		local v174 = 1494 - (1307 + 187);
		while true do
			if ((v174 == (0 - 0)) or ((10393 - 5954) <= (7205 - 4855))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(746 - (232 + 451), v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

