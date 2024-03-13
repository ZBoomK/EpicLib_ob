local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (710 - (201 + 508))) or ((1474 - (497 + 345)) >= (19 + 688))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((1879 - (605 + 728)) >= (1915 + 769))) then
			v6 = v0[v4];
			if (((3257 - 1792) <= (198 + 4103)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
	local v89;
	local v90 = v19.Mage.Fire;
	local v91 = v21.Mage.Fire;
	local v92 = v26.Mage.Fire;
	local v93 = {};
	local v94 = v22.Commons.Everyone;
	local function v95()
		if (((1537 + 167) > (3947 - 2522)) and v90.RemoveCurse:IsAvailable()) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (4 + 0)) or (1488 - (457 + 32));
	local v99 = 424 + 575;
	local v100 = v98;
	local v101 = ((1405 - (832 + 570)) * v28(v90.FueltheFire:IsAvailable())) + ((942 + 57) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 261 + 738;
	local v103 = 141 - 101;
	local v104 = 482 + 517;
	local v105 = 796.3 - (588 + 208);
	local v106 = 0 - 0;
	local v107 = 1806 - (884 + 916);
	local v108 = false;
	local v109 = (v108 and (41 - 21)) or (0 + 0);
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (653.4 - (232 + 421))) or (1890 - (1569 + 320));
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 0 + 0;
	local v116 = 0 + 0;
	local v117 = 26 - 18;
	local v118 = 608 - (316 + 289);
	local v119;
	local v120;
	local v121;
	local v122 = 7 - 4;
	local v123 = 514 + 10597;
	local v124 = 12564 - (666 + 787);
	local v125;
	local v126, v127, v128;
	local v129;
	local v130;
	local v131;
	local v132;
	v10:RegisterForEvent(function()
		local v157 = 425 - (360 + 65);
		while true do
			if ((v157 == (0 + 0)) or ((941 - (79 + 175)) == (6675 - 2441))) then
				v108 = false;
				v109 = (v108 and (16 + 4)) or (0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v158 = 0 - 0;
		while true do
			if ((v158 == (902 - (503 + 396))) or ((3511 - (92 + 89)) < (2771 - 1342))) then
				v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
				v90.Fireball:RegisterInFlight(v90.CombustionBuff);
				break;
			end
			if (((589 + 558) >= (199 + 136)) and (v158 == (0 - 0))) then
				v90.Pyroblast:RegisterInFlight();
				v90.Fireball:RegisterInFlight();
				v158 = 1 + 0;
			end
			if (((7832 - 4397) > (1830 + 267)) and (v158 == (1 + 1))) then
				v90.PhoenixFlames:RegisterInFlightEffect(784388 - 526846);
				v90.PhoenixFlames:RegisterInFlight();
				v158 = 1 + 2;
			end
			if ((v158 == (1 - 0)) or ((5014 - (485 + 759)) >= (9350 - 5309))) then
				v90.Meteor:RegisterInFlightEffect(352329 - (442 + 747));
				v90.Meteor:RegisterInFlight();
				v158 = 1137 - (832 + 303);
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(352086 - (88 + 858));
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(78494 + 179048);
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		v123 = 9196 + 1915;
		v124 = 458 + 10653;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v159 = 789 - (766 + 23);
		while true do
			if ((v159 == (4 - 3)) or ((5184 - 1393) <= (4244 - 2633))) then
				v100 = v98;
				v111 = ((v90.Kindling:IsAvailable()) and (0.4 - 0)) or (1074 - (1036 + 37));
				break;
			end
			if ((v159 == (0 + 0)) or ((8914 - 4336) <= (1580 + 428))) then
				v97 = v90.SunKingsBlessing:IsAvailable();
				v98 = ((v90.FlamePatch:IsAvailable()) and (1483 - (641 + 839))) or (1912 - (910 + 3));
				v159 = 2 - 1;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (1774 - (1466 + 218)));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (42 + 48)) and v15:TimeToX(1238 - (556 + 592))) or (0 + 0))) or (808 - (329 + 479));
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (884 - (174 + 680)));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (103 - 73));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v160 = 0 - 0;
		local v161;
		while true do
			if (((804 + 321) <= (2815 - (396 + 343))) and ((0 + 0) == v160)) then
				v161 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (1477 - (29 + 1448));
				v161 = v161 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1390 - (135 + 1254), v90.PhoenixFlames));
				v160 = 3 - 2;
			end
			if ((v160 == (4 - 3)) or ((496 + 247) >= (5926 - (389 + 1138)))) then
				return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast) or (v161 > (574 - (102 + 472)))))));
			end
		end
	end
	local function v139(v162)
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((641 + 514) < (1560 + 113)) and (v163 == (1545 - (320 + 1225)))) then
				v164 = 0 - 0;
				for v230, v231 in pairs(v162) do
					if (v231:DebuffUp(v90.IgniteDebuff) or ((1422 + 902) <= (2042 - (157 + 1307)))) then
						v164 = v164 + (1860 - (821 + 1038));
					end
				end
				v163 = 2 - 1;
			end
			if (((412 + 3355) == (6691 - 2924)) and (v163 == (1 + 0))) then
				return v164;
			end
		end
	end
	local function v140()
		local v165 = 0 - 0;
		local v166;
		while true do
			if (((5115 - (834 + 192)) == (260 + 3829)) and (v165 == (0 + 0))) then
				v166 = 0 + 0;
				if (((6906 - 2448) >= (1978 - (300 + 4))) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
					v166 = v166 + 1 + 0;
				end
				v165 = 2 - 1;
			end
			if (((1334 - (112 + 250)) <= (566 + 852)) and (v165 == (2 - 1))) then
				return v166;
			end
		end
	end
	local function v141()
		v32 = v94.HandleTopTrinket(v93, v35, 23 + 17, nil);
		if (v32 or ((2554 + 2384) < (3562 + 1200))) then
			return v32;
		end
		v32 = v94.HandleBottomTrinket(v93, v35, 20 + 20, nil);
		if (v32 or ((1861 + 643) > (5678 - (1001 + 413)))) then
			return v32;
		end
	end
	local v142 = 0 - 0;
	local function v143()
		if (((3035 - (244 + 638)) == (2846 - (627 + 66))) and v90.RemoveCurse:IsReady() and v94.UnitHasDispellableDebuffByPlayer(v16)) then
			local v182 = 0 - 0;
			while true do
				if ((v182 == (602 - (512 + 90))) or ((2413 - (1665 + 241)) >= (3308 - (373 + 344)))) then
					if (((2022 + 2459) == (1186 + 3295)) and (v142 == (0 - 0))) then
						v142 = GetTime();
					end
					if (v94.Wait(846 - 346, v142) or ((3427 - (35 + 1064)) < (505 + 188))) then
						local v236 = 0 - 0;
						while true do
							if (((18 + 4310) == (5564 - (298 + 938))) and (v236 == (1259 - (233 + 1026)))) then
								if (((3254 - (636 + 1030)) >= (682 + 650)) and v24(v92.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v142 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v144()
		if ((v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) or ((1240 + 2934) > (288 + 3960))) then
			if (v24(v90.BlazingBarrier) or ((4807 - (55 + 166)) <= (16 + 66))) then
				return "blazing_barrier defensive 1";
			end
		end
		if (((389 + 3474) == (14752 - 10889)) and v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 299 - (36 + 261), v90.ArcaneIntellect)) then
			if (v24(v90.MassBarrier) or ((492 - 210) <= (1410 - (34 + 1334)))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((1772 + 2837) >= (596 + 170)) and v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
			if (v24(v90.IceBlock) or ((2435 - (1035 + 248)) == (2509 - (20 + 1)))) then
				return "ice_block defensive 3";
			end
		end
		if (((1783 + 1639) > (3669 - (134 + 185))) and v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) then
			if (((2010 - (549 + 584)) > (1061 - (314 + 371))) and v24(v90.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) or ((10703 - 7585) <= (2819 - (478 + 490)))) then
			if (v24(v90.MirrorImage) or ((88 + 77) >= (4664 - (786 + 386)))) then
				return "mirror_image defensive 4";
			end
		end
		if (((12790 - 8841) < (6235 - (1055 + 324))) and v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
			if (v24(v90.GreaterInvisibility) or ((5616 - (1093 + 247)) < (2681 + 335))) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((494 + 4196) > (16376 - 12251)) and v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
			if (v24(v90.AlterTime) or ((169 - 119) >= (2549 - 1653))) then
				return "alter_time defensive 6";
			end
		end
		if ((v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) or ((4306 - 2592) >= (1053 + 1905))) then
			if (v24(v92.Healthstone) or ((5743 - 4252) < (2219 - 1575))) then
				return "healthstone defensive";
			end
		end
		if (((531 + 173) < (2523 - 1536)) and v77 and (v14:HealthPercentage() <= v79)) then
			local v183 = 688 - (364 + 324);
			while true do
				if (((10192 - 6474) > (4573 - 2667)) and (v183 == (0 + 0))) then
					if ((v81 == "Refreshing Healing Potion") or ((4008 - 3050) > (5821 - 2186))) then
						if (((10632 - 7131) <= (5760 - (1249 + 19))) and v91.RefreshingHealingPotion:IsReady()) then
							if (v24(v92.RefreshingHealingPotion) or ((3107 + 335) < (9918 - 7370))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((3961 - (686 + 400)) >= (1149 + 315)) and (v81 == "Dreamwalker's Healing Potion")) then
						if (v91.DreamwalkersHealingPotion:IsReady() or ((5026 - (73 + 156)) >= (24 + 4869))) then
							if (v24(v92.RefreshingHealingPotion) or ((1362 - (721 + 90)) > (24 + 2044))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v145()
		local v167 = 0 - 0;
		while true do
			if (((2584 - (224 + 246)) > (1528 - 584)) and (v167 == (1 - 0))) then
				if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) or ((411 + 1851) >= (74 + 3022))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((1657 + 598) >= (7031 - 3494))) then
						return "pyroblast precombat 4";
					end
				end
				if ((v90.Fireball:IsReady() and v41) or ((12768 - 8931) < (1819 - (203 + 310)))) then
					if (((4943 - (1238 + 755)) == (207 + 2743)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if ((v167 == (1534 - (709 + 825))) or ((8702 - 3979) < (4803 - 1505))) then
				if (((2000 - (196 + 668)) >= (607 - 453)) and v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) then
					if (v24(v90.ArcaneIntellect) or ((561 - 290) > (5581 - (171 + 662)))) then
						return "arcane_intellect precombat 2";
					end
				end
				if (((4833 - (4 + 89)) >= (11047 - 7895)) and v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) then
					if (v24(v90.MirrorImage) or ((939 + 1639) >= (14889 - 11499))) then
						return "mirror_image precombat 2";
					end
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v146()
		local v168 = 1486 - (35 + 1451);
		while true do
			if (((1494 - (28 + 1425)) <= (3654 - (941 + 1052))) and ((1 + 0) == v168)) then
				if (((2115 - (822 + 692)) < (5082 - 1522)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (8 + 7))) and not v136() and (v134() == (297 - (45 + 252))) and not v90.TemperedFlames:IsAvailable()) then
					if (((233 + 2) < (237 + 450)) and v24(v90.DragonsBreath, not v15:IsInRange(24 - 14))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((4982 - (114 + 319)) > (1654 - 501)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (19 - 4))) and not v136() and v90.TemperedFlames:IsAvailable()) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(7 + 3)) or ((6963 - 2289) < (9788 - 5116))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if (((5631 - (556 + 1407)) < (5767 - (741 + 465))) and (v168 == (465 - (170 + 295)))) then
				if ((v90.LivingBomb:IsReady() and v43 and (v127 > (1 + 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (0 + 0)))) or ((1120 - 665) == (2989 + 616))) then
					if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((1708 + 955) == (1876 + 1436))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((5507 - (957 + 273)) <= (1197 + 3278)) and v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (0 + 0)) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((171 - 126) < v110) or (v124 < v110))))) then
					if (v24(v92.MeteorCursor, not v15:IsInRange(105 - 65)) or ((2657 - 1787) == (5887 - 4698))) then
						return "meteor active_talents 4";
					end
				end
				v168 = 1781 - (389 + 1391);
			end
		end
	end
	local function v147()
		local v169 = 0 + 0;
		local v170;
		while true do
			if (((162 + 1391) <= (7132 - 3999)) and (v169 == (952 - (783 + 168)))) then
				if ((v82 and ((v85 and v35) or not v85) and (v75 < v124)) or ((7507 - 5270) >= (3454 + 57))) then
					if (v90.BloodFury:IsCastable() or ((1635 - (309 + 2)) > (9274 - 6254))) then
						if (v24(v90.BloodFury) or ((4204 - (1090 + 122)) == (610 + 1271))) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if (((10431 - 7325) > (1045 + 481)) and v90.Berserking:IsCastable() and v119) then
						if (((4141 - (628 + 490)) < (694 + 3176)) and v24(v90.Berserking)) then
							return "berserking combustion_cooldowns 6";
						end
					end
					if (((353 - 210) > (338 - 264)) and v90.Fireblood:IsCastable()) then
						if (((792 - (431 + 343)) < (4264 - 2152)) and v24(v90.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((3173 - 2076) <= (1287 + 341)) and v90.AncestralCall:IsCastable()) then
						if (((593 + 4037) == (6325 - (556 + 1139))) and v24(v90.AncestralCall)) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
				end
				if (((3555 - (6 + 9)) > (492 + 2191)) and v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
					if (((2456 + 2338) >= (3444 - (28 + 141))) and v24(v90.TimeWarp, nil, nil, true)) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v169 = 1 + 1;
			end
			if (((1830 - 346) == (1052 + 432)) and (v169 == (1317 - (486 + 831)))) then
				v170 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (((3726 - 2294) < (12515 - 8960)) and v170) then
					return v170;
				end
				v169 = 1 + 0;
			end
			if ((v169 == (6 - 4)) or ((2328 - (668 + 595)) > (3220 + 358))) then
				if ((v75 < v124) or ((967 + 3828) < (3836 - 2429))) then
					if (((2143 - (23 + 267)) < (6757 - (1129 + 815))) and v83 and ((v35 and v84) or not v84)) then
						local v237 = 387 - (371 + 16);
						while true do
							if (((1750 - (1326 + 424)) == v237) or ((5342 - 2521) < (8883 - 6452))) then
								v32 = v141();
								if (v32 or ((2992 - (88 + 30)) < (2952 - (720 + 51)))) then
									return v32;
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
	local function v148()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (1779 - (421 + 1355))) or ((4435 - 1746) <= (169 + 174))) then
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((1087 - (286 + 797)) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (2 - 0))) or ((2308 - (397 + 42)) == (628 + 1381))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((4346 - (24 + 776)) < (3576 - 1254))) then
						return "fire_blast combustion_phase 20";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v126 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v126 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) or ((2867 - (222 + 563)) == (10516 - 5743))) then
					if (((2336 + 908) > (1245 - (23 + 167))) and v24(v92.FlamestrikeCursor, not v15:IsInRange(1838 - (690 + 1108)), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) or ((1196 + 2117) <= (1467 + 311))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes)) or ((2269 - (40 + 808)) >= (347 + 1757))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if (((6928 - 5116) <= (3106 + 143)) and v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) then
					if (((859 + 764) <= (1074 + 883)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes))) then
						return "pyroblast combustion_phase 26";
					end
				end
				v171 = 575 - (47 + 524);
			end
			if (((2864 + 1548) == (12060 - 7648)) and (v171 == (1 - 0))) then
				if (((3991 - 2241) >= (2568 - (1165 + 561))) and v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(1 + 29, 6 - 4) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((2 + 2) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
					if (((4851 - (341 + 138)) > (500 + 1350)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v32 = v146();
				if (((478 - 246) < (1147 - (89 + 237))) and v32) then
					return v32;
				end
				if (((1666 - 1148) < (1898 - 996)) and v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (881 - (581 + 300))) and v120 and (v110 <= (1220 - (855 + 365))) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) then
					if (((7111 - 4117) > (281 + 577)) and v24(v90.Combustion, not v15:IsInRange(1275 - (1030 + 205)), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				v171 = 2 + 0;
			end
			if ((v171 == (0 + 0)) or ((4041 - (156 + 130)) <= (2079 - 1164))) then
				if (((6650 - 2704) > (7665 - 3922)) and v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
					if (v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment)) or ((352 + 983) >= (1928 + 1378))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((4913 - (10 + 59)) > (638 + 1615)) and v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
					if (((2225 - 1773) == (1615 - (671 + 492))) and v24(v90.BagofTricks)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v90.LivingBomb:IsReady() and v34 and v43 and (v127 > (1 + 0)) and v120) or ((5772 - (369 + 846)) < (553 + 1534))) then
					if (((3307 + 567) == (5819 - (1036 + 909))) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
						return "living_bomb combustion_phase 6";
					end
				end
				if ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (16 + 4)) or ((3253 - 1315) > (5138 - (11 + 192)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (175 - (135 + 40))) or ((10309 - 6054) < (2064 + 1359))) then
							v32 = v147();
							if (((3203 - 1749) <= (3733 - 1242)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v171 = 177 - (50 + 126);
			end
			if ((v171 == (16 - 10)) or ((921 + 3236) <= (4216 - (1233 + 180)))) then
				if (((5822 - (522 + 447)) >= (4403 - (107 + 1314))) and v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) then
					if (((1919 + 2215) > (10229 - 6872)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch combustion_phase 44";
					end
				end
				if ((v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) or ((1452 + 1965) < (5031 - 2497))) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((10769 - 8047) <= (2074 - (716 + 1194)))) then
						return "fireball combustion_phase 46";
					end
				end
				if ((v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v127 > (1 + 0))) or ((258 + 2150) < (2612 - (74 + 429)))) then
					if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((63 - 30) == (722 + 733))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if ((v171 == (4 - 2)) or ((314 + 129) >= (12377 - 8362))) then
				if (((8361 - 4979) > (599 - (279 + 154))) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v126 >= v101)) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(818 - (454 + 324)), v14:BuffDown(v90.IceFloes)) or ((221 + 59) == (3076 - (12 + 5)))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if (((1015 + 866) > (3294 - 2001)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) then
					if (((871 + 1486) == (3450 - (277 + 816))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((525 - 402) == (1306 - (1058 + 125))) and v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v126 < (1 + 1)) and not v136()) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((2031 - (815 + 160)) >= (14553 - 11161))) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) or ((2565 - 1484) < (257 + 818))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((3066 - 2017) >= (6330 - (41 + 1857)))) then
						return "scorch combustion_phase 18";
					end
				end
				v171 = 1896 - (1222 + 671);
			end
			if (((10 - 6) == v171) or ((6853 - 2085) <= (2028 - (229 + 953)))) then
				if ((v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(1775 - (1111 + 663), v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v126 < v100) and v119) or ((4937 - (874 + 705)) <= (199 + 1221))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes)) or ((2552 + 1187) <= (6246 - 3241))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if ((v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (0 + 0)) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v126)) or ((2338 - (642 + 37)) >= (487 + 1647))) then
					if (v24(v90.ShiftingPower, not v15:IsInRange(7 + 33)) or ((8185 - 4925) < (2809 - (233 + 221)))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v126 >= v101)) or ((1546 - 877) == (3717 + 506))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1581 - (718 + 823)), v14:BuffDown(v90.IceFloes)) or ((1065 + 627) < (1393 - (266 + 539)))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((13581 - 8784) < (4876 - (636 + 589)))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes)) or ((9914 - 5737) > (10003 - 5153))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v171 = 4 + 1;
			end
			if ((v171 == (2 + 3)) or ((1415 - (657 + 358)) > (2941 - 1830))) then
				if (((6950 - 3899) > (2192 - (1151 + 36))) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((4 + 0) * v125)) and (v128 < v100)) then
					if (((971 + 2722) <= (13086 - 8704)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch combustion_phase 36";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(1862 - (1552 + 280), 836 - (64 + 770)) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (2 + 0)) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((8 - 4) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v90.FlamesFuryBuff))) or ((4525 - (157 + 1086)) > (8206 - 4106))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((15679 - 12099) < (4362 - 1518))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((120 - 31) < (5309 - (599 + 220))) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((9922 - 4939) < (3739 - (1813 + 118)))) then
						return "fireball combustion_phase 40";
					end
				end
				if (((2799 + 1030) > (4986 - (841 + 376))) and v90.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(42 - 12, 1 + 1) and not v90.AlexstraszasFury:IsAvailable() and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (5 - 3))) then
					if (((2344 - (464 + 395)) <= (7452 - 4548)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v171 = 3 + 3;
			end
		end
	end
	local function v149()
		local v172 = 837 - (467 + 370);
		while true do
			if (((8821 - 4552) == (3134 + 1135)) and (v172 == (6 - 4))) then
				if (((61 + 326) <= (6472 - 3690)) and v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (523 - (150 + 370)) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v172 = 1285 - (74 + 1208);
			end
			if ((v172 == (0 - 0)) or ((9006 - 7107) <= (653 + 264))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v126 < v100)) + (v90.Flamestrike:CastTime() * v28(v126 >= v100))) - v105;
				v172 = 391 - (14 + 376);
			end
			if ((v172 == (1 - 0)) or ((2791 + 1521) <= (770 + 106))) then
				v110 = v115;
				if (((2129 + 103) <= (7606 - 5010)) and v90.Firestarter:IsAvailable() and not v97) then
					v110 = v30(v134(), v110);
				end
				v172 = 2 + 0;
			end
			if (((2173 - (23 + 55)) < (8735 - 5049)) and (v172 == (3 + 0))) then
				if (((v115 + ((108 + 12) * ((1 - 0) - ((0.4 + 0 + ((901.2 - (652 + 249)) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (53 - 33))) or ((3463 - (708 + 1160)) >= (12144 - 7670))) then
					v110 = v115;
				end
				break;
			end
		end
	end
	local function v150()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (27 - (10 + 17))) or ((1038 + 3581) < (4614 - (1400 + 332)))) then
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 - 0)) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (1909 - (242 + 1666))) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) or ((108 + 186) >= (4118 + 713))) then
					if (((2969 - (850 + 90)) <= (5401 - 2317)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1391 - (360 + 1030))) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(27 + 3, 5 - 3) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((2 - 0) * v125)))) or ((3698 - (909 + 752)) == (3643 - (109 + 1114)))) then
					if (((8161 - 3703) > (1520 + 2384)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v151()
		local v174 = 242 - (6 + 236);
		while true do
			if (((275 + 161) >= (100 + 23)) and (v174 == (6 - 3))) then
				if (((873 - 373) < (2949 - (1076 + 57))) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (0 + 0)) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (691.5 - (579 + 110))) or ((v90.PhoenixFlames:ChargesFractional() > (1.5 + 0)) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((3 + 0) * v125)))))) then
					if (((1897 + 1677) == (3981 - (174 + 233))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (((617 - 396) < (684 - 294)) and v32) then
					return v32;
				end
				if ((v34 and v90.DragonsBreath:IsReady() and v39 and (v128 > (1 + 0)) and v90.AlexstraszasFury:IsAvailable()) or ((3387 - (663 + 511)) <= (1268 + 153))) then
					if (((664 + 2394) < (14983 - 10123)) and v24(v90.DragonsBreath, not v15:IsInRange(7 + 3))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v174 = 9 - 5;
			end
			if ((v174 == (0 - 0)) or ((619 + 677) >= (8653 - 4207))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v98) and v138()) or ((993 + 400) > (411 + 4078))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(762 - (478 + 244)), v14:BuffDown(v90.IceFloes)) or ((4941 - (440 + 77)) < (13 + 14))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v138())) or ((7309 - 5312) > (5371 - (655 + 901)))) then
					if (((643 + 2822) > (1465 + 448)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((495 + 238) < (7327 - 5508)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v126 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1485 - (695 + 750)), v14:BuffDown(v90.IceFloes)) or ((15007 - 10612) == (7337 - 2582))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((20 - 15) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) or ((4144 - (285 + 66)) < (5521 - 3152))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((5394 - (682 + 628)) == (43 + 222))) then
						return "scorch standard_rotation 13";
					end
				end
				v174 = 300 - (176 + 123);
			end
			if (((1823 + 2535) == (3162 + 1196)) and (v174 == (270 - (239 + 30)))) then
				if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) or ((854 + 2284) < (955 + 38))) then
					if (((5893 - 2563) > (7247 - 4924)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and ((((v14:IsCasting(v90.Fireball) and ((v90.Fireball:ExecuteRemains() < (315.5 - (306 + 9))) or not v90.Hyperthermia:IsAvailable())) or (v14:IsCasting(v90.Pyroblast) and ((v90.Pyroblast:ExecuteRemains() < (0.5 - 0)) or not v90.Hyperthermia:IsAvailable()))) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (1 + 2))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (0 + 0))))))) or ((1746 + 1880) == (11406 - 7417))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((2291 - (1140 + 235)) == (1700 + 971))) then
						return "fire_blast standard_rotation 16";
					end
				end
				if (((250 + 22) == (70 + 202)) and v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(53 - (33 + 19), v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v126 < v98)) then
					if (((1535 + 2714) <= (14503 - 9664)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((1224 + 1553) < (6275 - 3075)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((4 + 0) * v125))) then
					if (((784 - (586 + 103)) < (179 + 1778)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 19";
					end
				end
				v174 = 5 - 3;
			end
			if (((2314 - (1309 + 179)) < (3099 - 1382)) and (v174 == (3 + 2))) then
				if (((3829 - 2403) >= (835 + 270)) and v90.Fireball:IsReady() and v41 and not v138()) then
					if (((5850 - 3096) <= (6732 - 3353)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((613 - (295 + 314)) == v174) or ((9645 - 5718) == (3375 - (1300 + 662)))) then
				if ((v90.Scorch:IsReady() and v47 and (v135())) or ((3623 - 2469) <= (2543 - (1178 + 577)))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((854 + 789) > (9988 - 6609))) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v34 and v90.ArcaneExplosion:IsReady() and v37 and (v129 >= v102) and (v14:ManaPercentageP() >= v103)) or ((4208 - (851 + 554)) > (4023 + 526))) then
					if (v24(v90.ArcaneExplosion, not v15:IsInRange(22 - 14)) or ((477 - 257) >= (3324 - (115 + 187)))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if (((2162 + 660) == (2672 + 150)) and v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v99)) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(157 - 117)) or ((2222 - (160 + 1001)) == (1625 + 232))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((1905 + 855) > (2791 - 1427)) and v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes)) or ((5260 - (237 + 121)) <= (4492 - (525 + 372)))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v174 = 9 - 4;
			end
			if ((v174 == (6 - 4)) or ((3994 - (96 + 46)) == (1070 - (643 + 134)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) or ((3737 - 2178) == (17033 - 12445))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((4301 + 183) == (1546 - 758))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((9337 - 4769) >= (4626 - (316 + 403))) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(20 + 10, 5 - 3) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((1 + 1) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
					if (((3137 - 1891) < (2459 + 1011)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if (((1312 + 2756) >= (3367 - 2395)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) then
					if (((2354 - 1861) < (8087 - 4194)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or ((85 + 1388) >= (6559 - 3227))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((198 + 3853) <= (3403 - 2246))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v174 = 20 - (12 + 5);
			end
		end
	end
	local function v152()
		local v175 = 0 - 0;
		while true do
			if (((1288 - 684) < (6123 - 3242)) and (v175 == (2 - 1))) then
				v112 = v110 > v90.ShiftingPower:CooldownRemains();
				v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (1 + 0)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((1985 - (1656 + 317)) / v90.FireBlast:Cooldown()) % (1 + 0)))) and (v110 < v124);
				if ((not v96 and ((v110 <= (0 + 0)) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) or ((2393 - 1493) == (16620 - 13243))) then
					local v233 = 354 - (5 + 349);
					while true do
						if (((21179 - 16720) > (1862 - (266 + 1005))) and (v233 == (0 + 0))) then
							v32 = v148();
							if (((11594 - 8196) >= (3153 - 758)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v175 = 1698 - (561 + 1135);
			end
			if ((v175 == (6 - 1)) or ((7175 - 4992) >= (3890 - (507 + 559)))) then
				if (((4857 - 2921) == (5987 - 4051)) and v90.Scorch:IsReady() and v47) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((5220 - (212 + 176)) < (5218 - (250 + 655)))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((11147 - 7059) > (6768 - 2894)) and (v175 == (5 - 1))) then
				if (((6288 - (1869 + 87)) == (15025 - 10693)) and v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) then
					if (((5900 - (484 + 1417)) >= (6215 - 3315)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast main 16";
					end
				end
				if (((v110 > (0 - 0)) and v120) or ((3298 - (48 + 725)) > (6638 - 2574))) then
					local v234 = 0 - 0;
					while true do
						if (((2541 + 1830) == (11681 - 7310)) and (v234 == (0 + 0))) then
							v32 = v151();
							if (v32 or ((78 + 188) > (5839 - (152 + 701)))) then
								return v32;
							end
							break;
						end
					end
				end
				if (((3302 - (430 + 881)) >= (355 + 570)) and v90.IceNova:IsCastable() and not v135()) then
					if (((1350 - (557 + 338)) < (607 + 1446)) and v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v175 = 14 - 9;
			end
			if ((v175 == (0 - 0)) or ((2194 - 1368) == (10454 - 5603))) then
				if (((984 - (499 + 302)) == (1049 - (39 + 827))) and not v96) then
					v149();
				end
				if (((3199 - 2040) <= (3992 - 2204)) and v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (158 - 118)))) then
					if (v24(v90.TimeWarp, not v15:IsInRange(61 - 21)) or ((301 + 3206) > (12638 - 8320))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v75 < v124) or ((492 + 2583) <= (4691 - 1726))) then
					if (((1469 - (103 + 1)) <= (2565 - (475 + 79))) and v83 and ((v35 and v84) or not v84)) then
						local v238 = 0 - 0;
						while true do
							if ((v238 == (0 - 0)) or ((359 + 2417) > (3147 + 428))) then
								v32 = v141();
								if (v32 or ((4057 - (1395 + 108)) == (13979 - 9175))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				v175 = 1205 - (7 + 1197);
			end
			if (((1124 + 1453) == (900 + 1677)) and (v175 == (322 - (27 + 292)))) then
				if ((v126 >= v100) or ((17 - 11) >= (2408 - 519))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				if (((2122 - 1616) <= (3730 - 1838)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 - 0)) and (v126 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (139.5 - (43 + 96)))) or (v90.FireBlast:ChargesFractional() >= (8 - 6)))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((4539 - 2531) > (1841 + 377))) then
						return "fire_blast main 14";
					end
				end
				if (((108 + 271) <= (8195 - 4048)) and v120 and v133() and (v110 > (0 + 0))) then
					local v235 = 0 - 0;
					while true do
						if ((v235 == (0 + 0)) or ((332 + 4182) <= (2760 - (1414 + 337)))) then
							v32 = v150();
							if (v32 or ((5436 - (1642 + 298)) == (3107 - 1915))) then
								return v32;
							end
							break;
						end
					end
				end
				v175 = 11 - 7;
			end
			if ((v175 == (5 - 3)) or ((69 + 139) == (2303 + 656))) then
				if (((5249 - (357 + 615)) >= (922 + 391)) and not v114 and v90.SunKingsBlessing:IsAvailable()) then
					v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((6 - 3) * v125));
				end
				if (((2217 + 370) < (6801 - 3627)) and v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (0 + 0)) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) then
					if (v24(v90.ShiftingPower, not v15:IsInRange(3 + 37), true) or ((2590 + 1530) <= (3499 - (384 + 917)))) then
						return "shifting_power main 12";
					end
				end
				if ((v126 < v100) or ((2293 - (128 + 569)) == (2401 - (1407 + 136)))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + (1894 - (687 + 1200))) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				v175 = 1713 - (556 + 1154);
			end
		end
	end
	local function v153()
		local v176 = 0 - 0;
		while true do
			if (((3315 - (9 + 86)) == (3641 - (275 + 146))) and (v176 == (1 + 2))) then
				v55 = EpicSettings.Settings['useBlazingBarrier'];
				v56 = EpicSettings.Settings['useGreaterInvisibility'];
				v57 = EpicSettings.Settings['useIceBlock'];
				v58 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v59 = EpicSettings.Settings['useMirrorImage'];
				v176 = 68 - (29 + 35);
			end
			if ((v176 == (4 - 3)) or ((4187 - 2785) > (15980 - 12360))) then
				v43 = EpicSettings.Settings['useLivingBomb'];
				v44 = EpicSettings.Settings['useMeteor'];
				v45 = EpicSettings.Settings['usePhoenixFlames'];
				v46 = EpicSettings.Settings['usePyroblast'];
				v47 = EpicSettings.Settings['useScorch'];
				v48 = EpicSettings.Settings['useCounterspell'];
				v176 = 2 + 0;
			end
			if (((3586 - (53 + 959)) == (2982 - (312 + 96))) and ((3 - 1) == v176)) then
				v49 = EpicSettings.Settings['useBlastWave'];
				v50 = EpicSettings.Settings['useCombustion'];
				v51 = EpicSettings.Settings['useShiftingPower'];
				v52 = EpicSettings.Settings['combustionWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['useAlterTime'];
				v176 = 288 - (147 + 138);
			end
			if (((2697 - (813 + 86)) < (2492 + 265)) and (v176 == (0 - 0))) then
				v37 = EpicSettings.Settings['useArcaneExplosion'];
				v38 = EpicSettings.Settings['useArcaneIntellect'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFireball'];
				v42 = EpicSettings.Settings['useFlamestrike'];
				v176 = 493 - (18 + 474);
			end
			if ((v176 == (2 + 3)) or ((1230 - 853) > (3690 - (860 + 226)))) then
				v67 = EpicSettings.Settings['massBarrierHP'] or (303 - (121 + 182));
				v86 = EpicSettings.Settings['mirrorImageBeforePull'];
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((70 + 498) < (2151 - (988 + 252))) and (v176 == (1 + 3))) then
				v61 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v62 = EpicSettings.Settings['blazingBarrierHP'] or (1970 - (49 + 1921));
				v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (890 - (223 + 667));
				v64 = EpicSettings.Settings['iceBlockHP'] or (52 - (51 + 1));
				v65 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v66 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v176 = 1130 - (146 + 979);
			end
		end
	end
	local function v154()
		local v177 = 0 + 0;
		while true do
			if (((3890 - (311 + 294)) < (11790 - 7562)) and (v177 == (1 + 0))) then
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v177 = 1445 - (496 + 947);
			end
			if (((5274 - (1233 + 125)) > (1351 + 1977)) and ((3 + 0) == v177)) then
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v177 = 1 + 3;
			end
			if (((4145 - (963 + 682)) < (3204 + 635)) and (v177 == (1504 - (504 + 1000)))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v177 = 1 + 0;
			end
			if (((48 + 459) == (746 - 239)) and (v177 == (4 + 0))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (182 - (156 + 26));
				v177 = 3 + 2;
			end
			if (((375 - 135) <= (3329 - (149 + 15))) and ((965 - (890 + 70)) == v177)) then
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((951 - (39 + 78)) >= (1287 - (14 + 468))) and (v177 == (4 - 2))) then
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v82 = EpicSettings.Settings['useRacials'];
				v177 = 8 - 5;
			end
		end
	end
	local function v155()
		local v178 = 0 + 0;
		while true do
			if ((v178 == (2 + 0)) or ((810 + 3002) < (1046 + 1270))) then
				if (v14:IsDeadOrGhost() or ((695 + 1957) <= (2933 - 1400))) then
					return v32;
				end
				v131 = v15:GetEnemiesInSplashRange(5 + 0);
				v130 = v14:GetEnemiesInRange(140 - 100);
				v178 = 1 + 2;
			end
			if ((v178 == (54 - (12 + 39))) or ((3348 + 250) < (4519 - 3059))) then
				if (v34 or ((14659 - 10543) < (354 + 838))) then
					v126 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v130);
					v127 = v30(v15:GetEnemiesInSplashRangeCount(12 - 7), #v130);
					v128 = v30(v15:GetEnemiesInSplashRangeCount(4 + 1), #v130);
					v129 = #v130;
				else
					v126 = 4 - 3;
					v127 = 1711 - (1596 + 114);
					v128 = 2 - 1;
					v129 = 714 - (164 + 549);
				end
				if (v94.TargetIsValid() or v14:AffectingCombat() or ((4815 - (1059 + 379)) <= (1120 - 217))) then
					if (((2061 + 1915) >= (75 + 364)) and (v14:AffectingCombat() or v69)) then
						local v239 = 392 - (145 + 247);
						local v240;
						while true do
							if (((3079 + 673) == (1734 + 2018)) and (v239 == (2 - 1))) then
								if (((777 + 3269) > (2322 + 373)) and v32) then
									return v32;
								end
								break;
							end
							if ((v239 == (0 - 0)) or ((4265 - (254 + 466)) == (3757 - (544 + 16)))) then
								v240 = v69 and v90.RemoveCurse:IsReady() and v36;
								v32 = v94.FocusUnit(v240, nil, 63 - 43, nil, 648 - (294 + 334), v90.ArcaneIntellect);
								v239 = 254 - (236 + 17);
							end
						end
					end
					v123 = v10.BossFightRemains(nil, true);
					v124 = v123;
					if (((1033 + 1361) > (291 + 82)) and (v124 == (41845 - 30734))) then
						v124 = v10.FightRemains(v130, false);
					end
					v132 = v139(v130);
					v96 = not v35;
					if (((19671 - 15516) <= (2179 + 2053)) and v96) then
						v110 = 82361 + 17638;
					end
					v125 = v14:GCD();
					v119 = v14:BuffUp(v90.CombustionBuff);
					v120 = not v119;
				end
				if ((not v14:AffectingCombat() and v33) or ((4375 - (413 + 381)) == (147 + 3326))) then
					v32 = v145();
					if (((10623 - 5628) > (8696 - 5348)) and v32) then
						return v32;
					end
				end
				v178 = 1974 - (582 + 1388);
			end
			if ((v178 == (6 - 2)) or ((540 + 214) > (4088 - (326 + 38)))) then
				if (((641 - 424) >= (81 - 24)) and v14:AffectingCombat() and v94.TargetIsValid()) then
					if ((v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) or ((2690 - (47 + 573)) >= (1424 + 2613))) then
						if (((11488 - 8783) == (4390 - 1685)) and v24(v92.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((1725 - (1269 + 395)) == (553 - (76 + 416))) and v69 and v36 and v90.RemoveCurse:IsAvailable()) then
						local v241 = 443 - (319 + 124);
						while true do
							if ((v241 == (0 - 0)) or ((1706 - (564 + 443)) >= (3587 - 2291))) then
								if (v16 or ((2241 - (337 + 121)) >= (10595 - 6979))) then
									local v244 = 0 - 0;
									while true do
										if (((1911 - (1261 + 650)) == v244) or ((1656 + 2257) > (7214 - 2687))) then
											v32 = v143();
											if (((6193 - (772 + 1045)) > (116 + 701)) and v32) then
												return v32;
											end
											break;
										end
									end
								end
								if (((5005 - (102 + 42)) > (2668 - (1524 + 320))) and v18 and v18:Exists() and v18:IsAPlayer() and v94.UnitHasCurseDebuff(v18)) then
									if (v90.RemoveCurse:IsReady() or ((2653 - (1049 + 221)) >= (2287 - (18 + 138)))) then
										if (v24(v92.RemoveCurseMouseover) or ((4591 - 2715) >= (3643 - (67 + 1035)))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					v32 = v144();
					if (((2130 - (136 + 212)) <= (16028 - 12256)) and v32) then
						return v32;
					end
					if (v70 or ((3766 + 934) < (750 + 63))) then
						if (((4803 - (240 + 1364)) < (5132 - (1050 + 32))) and v89) then
							local v243 = 0 - 0;
							while true do
								if ((v243 == (0 + 0)) or ((6006 - (331 + 724)) < (358 + 4072))) then
									v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 674 - (269 + 375));
									if (((821 - (267 + 458)) == (30 + 66)) and v32) then
										return v32;
									end
									break;
								end
							end
						end
					end
					if (v71 or ((5266 - 2527) > (4826 - (667 + 151)))) then
						local v242 = 1497 - (1410 + 87);
						while true do
							if ((v242 == (1897 - (1504 + 393))) or ((62 - 39) == (2941 - 1807))) then
								v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseover, 826 - (461 + 335));
								if (v32 or ((345 + 2348) >= (5872 - (1730 + 31)))) then
									return v32;
								end
								break;
							end
						end
					end
					if ((v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) or ((5983 - (728 + 939)) <= (7600 - 5454))) then
						if (v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal)) or ((7192 - 3646) <= (6435 - 3626))) then
							return "spellsteal damage";
						end
					end
					if (((5972 - (138 + 930)) > (1980 + 186)) and (v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v90.HotStreakBuff)) then
						if (((86 + 23) >= (78 + 12)) and v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast))) then
							return "Stop Casting";
						end
					end
					if (((20326 - 15348) > (4671 - (459 + 1307))) and v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes)) then
						if (v24(v90.IceFloes) or ((4896 - (474 + 1396)) <= (3981 - 1701))) then
							return "ice_floes movement";
						end
					end
					v32 = v152();
					if (v32 or ((1550 + 103) <= (4 + 1104))) then
						return v32;
					end
				end
				break;
			end
			if (((8332 - 5423) > (331 + 2278)) and ((0 - 0) == v178)) then
				v153();
				v154();
				v33 = EpicSettings.Toggles['ooc'];
				v178 = 4 - 3;
			end
			if (((1348 - (562 + 29)) > (166 + 28)) and (v178 == (1420 - (374 + 1045)))) then
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v178 = 2 + 0;
			end
		end
	end
	local function v156()
		v95();
		v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(195 - 132, v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

