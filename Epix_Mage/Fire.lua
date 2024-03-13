local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2860 - (228 + 498)) == (463 + 1671)) and not v5) then
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
		if (v89.RemoveCurse:IsAvailable() or ((1190 + 964) >= (3988 - (174 + 489)))) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (10 - 6)) or (2904 - (830 + 1075));
	local v98 = 1523 - (303 + 221);
	local v99 = v97;
	local v100 = ((1272 - (231 + 1038)) * v27(v89.FueltheFire:IsAvailable())) + ((833 + 166) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 2161 - (171 + 991);
	local v102 = 164 - 124;
	local v103 = 2682 - 1683;
	local v104 = 0.3 - 0;
	local v105 = 0 + 0;
	local v106 = 20 - 14;
	local v107 = false;
	local v108 = (v107 and (57 - 37)) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (1249 - (111 + 1137));
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 158 - (91 + 67);
	local v115 = 0 - 0;
	local v116 = 2 + 6;
	local v117 = 526 - (423 + 100);
	local v118;
	local v119;
	local v120;
	local v121 = 1 + 2;
	local v122 = 30764 - 19653;
	local v123 = 5792 + 5319;
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v9:RegisterForEvent(function()
		v107 = false;
		v108 = (v107 and (791 - (326 + 445))) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (0 - 0)) or ((2006 - (530 + 181)) >= (4114 - (614 + 267)))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v156 = 33 - (19 + 13);
			end
			if (((7123 - 2746) > (3825 - 2183)) and (v156 == (8 - 5))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if (((1227 + 3496) > (2384 - 1028)) and (v156 == (3 - 1))) then
				v89.PhoenixFlames:RegisterInFlightEffect(259354 - (1293 + 519));
				v89.PhoenixFlames:RegisterInFlight();
				v156 = 5 - 2;
			end
			if ((v156 == (2 - 1)) or ((7909 - 3773) <= (14803 - 11370))) then
				v89.Meteor:RegisterInFlightEffect(827193 - 476053);
				v89.Meteor:RegisterInFlight();
				v156 = 2 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(71639 + 279501);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(598402 - 340860);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if (((1411 + 2834) <= (2894 + 1737)) and (v157 == (1096 - (709 + 387)))) then
				v122 = 12969 - (673 + 1185);
				v123 = 32223 - 21112;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v96 = v89.SunKingsBlessing:IsAvailable();
		v97 = ((v89.FlamePatch:IsAvailable()) and (9 - 6)) or (1643 - 644);
		v99 = v97;
		v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (121 - 31));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (23 + 67)) and v14:TimeToX(179 - 89)) or (0 - 0))) or (1880 - (446 + 1434));
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (1313 - (1040 + 243)));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (89 - 59));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v158 = 1847 - (559 + 1288);
		local v159;
		while true do
			if (((6207 - (609 + 1322)) >= (4368 - (13 + 441))) and (v158 == (3 - 2))) then
				return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast) or (v159 > (0 - 0))))));
			end
			if (((986 - 788) <= (163 + 4202)) and (v158 == (0 - 0))) then
				v159 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 + 0);
				v159 = v159 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(1 + 0, v89.PhoenixFlames));
				v158 = 2 - 1;
			end
		end
	end
	local function v138(v160)
		local v161 = 0 + 0;
		for v200, v201 in pairs(v160) do
			if (((8794 - 4012) > (3092 + 1584)) and v201:DebuffUp(v89.IgniteDebuff)) then
				v161 = v161 + 1 + 0;
			end
		end
		return v161;
	end
	local function v139()
		local v162 = 0 + 0;
		local v163;
		while true do
			if (((4085 + 779) > (2150 + 47)) and (v162 == (434 - (153 + 280)))) then
				return v163;
			end
			if ((v162 == (0 - 0)) or ((3322 + 378) == (990 + 1517))) then
				v163 = 0 + 0;
				if (((4061 + 413) >= (199 + 75)) and (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight())) then
					v163 = v163 + (1 - 0);
				end
				v162 = 1 + 0;
			end
		end
	end
	local function v140()
		v31 = v93.HandleTopTrinket(v92, v34, 707 - (89 + 578), nil);
		if (v31 or ((1354 + 540) <= (2922 - 1516))) then
			return v31;
		end
		v31 = v93.HandleBottomTrinket(v92, v34, 1089 - (572 + 477), nil);
		if (((213 + 1359) >= (919 + 612)) and v31) then
			return v31;
		end
	end
	local v141 = 0 + 0;
	local function v142()
		if ((v89.RemoveCurse:IsReady() and v93.UnitHasDispellableDebuffByPlayer(v15)) or ((4773 - (84 + 2)) < (7484 - 2942))) then
			if (((2371 + 920) > (2509 - (497 + 345))) and (v141 == (0 + 0))) then
				v141 = GetTime();
			end
			if (v93.Wait(85 + 415, v141) or ((2206 - (605 + 728)) == (1452 + 582))) then
				local v222 = 0 - 0;
				while true do
					if ((v222 == (0 + 0)) or ((10411 - 7595) < (10 + 1))) then
						if (((10248 - 6549) < (3554 + 1152)) and v23(v91.RemoveCurseFocus)) then
							return "remove_curse dispel";
						end
						v141 = 489 - (457 + 32);
						break;
					end
				end
			end
		end
	end
	local function v143()
		local v164 = 0 + 0;
		while true do
			if (((4048 - (832 + 570)) >= (826 + 50)) and (v164 == (1 + 1))) then
				if (((2172 - 1558) <= (1534 + 1650)) and v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) then
					if (((3922 - (588 + 208)) == (8425 - 5299)) and v23(v89.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) or ((3987 - (884 + 916)) >= (10371 - 5417))) then
					if (v23(v89.GreaterInvisibility) or ((2248 + 1629) == (4228 - (232 + 421)))) then
						return "greater_invisibility defensive 5";
					end
				end
				v164 = 1892 - (1569 + 320);
			end
			if (((174 + 533) > (121 + 511)) and ((3 - 2) == v164)) then
				if ((v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) or ((1151 - (316 + 289)) >= (7025 - 4341))) then
					if (((68 + 1397) <= (5754 - (666 + 787))) and v23(v89.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((2129 - (360 + 65)) > (1332 + 93)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
					if (v23(v89.IceColdAbility) or ((941 - (79 + 175)) == (6675 - 2441))) then
						return "ice_cold defensive 3";
					end
				end
				v164 = 2 + 0;
			end
			if ((v164 == (0 - 0)) or ((6413 - 3083) < (2328 - (503 + 396)))) then
				if (((1328 - (92 + 89)) >= (649 - 314)) and v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) then
					if (((1762 + 1673) > (1242 + 855)) and v23(v89.BlazingBarrier)) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 7 - 5, v89.ArcaneIntellect)) or ((516 + 3254) >= (9213 - 5172))) then
					if (v23(v89.MassBarrier) or ((3308 + 483) <= (770 + 841))) then
						return "mass_barrier defensive 2";
					end
				end
				v164 = 2 - 1;
			end
			if ((v164 == (1 + 2)) or ((6981 - 2403) <= (3252 - (485 + 759)))) then
				if (((2603 - 1478) <= (3265 - (442 + 747))) and v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
					if (v23(v89.AlterTime) or ((1878 - (832 + 303)) >= (5345 - (88 + 858)))) then
						return "alter_time defensive 6";
					end
				end
				if (((353 + 802) < (1385 + 288)) and v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) then
					if (v23(v91.Healthstone) or ((96 + 2228) <= (1367 - (766 + 23)))) then
						return "healthstone defensive";
					end
				end
				v164 = 19 - 15;
			end
			if (((5151 - 1384) == (9924 - 6157)) and (v164 == (13 - 9))) then
				if (((5162 - (1036 + 37)) == (2900 + 1189)) and v76 and (v13:HealthPercentage() <= v78)) then
					if (((8681 - 4223) >= (1317 + 357)) and (v80 == "Refreshing Healing Potion")) then
						if (((2452 - (641 + 839)) <= (2331 - (910 + 3))) and v90.RefreshingHealingPotion:IsReady()) then
							if (v23(v91.RefreshingHealingPotion) or ((12588 - 7650) < (6446 - (1466 + 218)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v80 == "Dreamwalker's Healing Potion") or ((1151 + 1353) > (5412 - (556 + 592)))) then
						if (((766 + 1387) == (2961 - (329 + 479))) and v90.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v91.RefreshingHealingPotion) or ((1361 - (174 + 680)) >= (8903 - 6312))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v144()
		if (((9287 - 4806) == (3200 + 1281)) and v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
			if (v23(v89.ArcaneIntellect) or ((3067 - (396 + 343)) < (62 + 631))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((5805 - (29 + 1448)) == (5717 - (135 + 1254))) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) then
			if (((5982 - 4394) >= (6219 - 4887)) and v23(v89.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) or ((2782 + 1392) > (5775 - (389 + 1138)))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((5160 - (102 + 472)) <= (78 + 4))) then
				return "pyroblast precombat 4";
			end
		end
		if (((2143 + 1720) == (3602 + 261)) and v89.Fireball:IsReady() and v40) then
			if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true) or ((1827 - (320 + 1225)) <= (74 - 32))) then
				return "fireball precombat 6";
			end
		end
	end
	local function v145()
		if (((2821 + 1788) >= (2230 - (157 + 1307))) and v89.LivingBomb:IsReady() and v42 and (v126 > (1860 - (821 + 1038))) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 - 0)))) then
			if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes)) or ((126 + 1026) == (4419 - 1931))) then
				return "living_bomb active_talents 2";
			end
		end
		if (((1274 + 2148) > (8303 - 4953)) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (1026 - (834 + 192))) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((3 + 42) < v109) or (v123 < v109))))) then
			if (((226 + 651) > (9 + 367)) and v23(v91.MeteorCursor, not v14:IsInRange(61 - 21))) then
				return "meteor active_talents 4";
			end
		end
		if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (319 - (300 + 4)))) and not v135() and (v133() == (0 + 0)) and not v89.TemperedFlames:IsAvailable()) or ((8162 - 5044) <= (2213 - (112 + 250)))) then
			if (v23(v89.DragonsBreath, not v14:IsInRange(4 + 6)) or ((413 - 248) >= (2001 + 1491))) then
				return "dragons_breath active_talents 6";
			end
		end
		if (((2043 + 1906) < (3632 + 1224)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (8 + 7))) and not v135() and v89.TemperedFlames:IsAvailable()) then
			if (v23(v89.DragonsBreath, not v14:IsInRange(8 + 2)) or ((5690 - (1001 + 413)) < (6725 - 3709))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v146()
		local v165 = 882 - (244 + 638);
		local v166;
		while true do
			if (((5383 - (627 + 66)) > (12291 - 8166)) and (v165 == (602 - (512 + 90)))) then
				v166 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
				if (v166 or ((1956 - (1665 + 241)) >= (1613 - (373 + 344)))) then
					return v166;
				end
				v165 = 1 + 0;
			end
			if ((v165 == (1 + 1)) or ((4520 - 2806) >= (5005 - 2047))) then
				if ((v74 < v123) or ((2590 - (35 + 1064)) < (469 + 175))) then
					if (((1505 - 801) < (4 + 983)) and v82 and ((v34 and v83) or not v83)) then
						v31 = v140();
						if (((4954 - (298 + 938)) > (3165 - (233 + 1026))) and v31) then
							return v31;
						end
					end
				end
				break;
			end
			if ((v165 == (1667 - (636 + 1030))) or ((490 + 468) > (3551 + 84))) then
				if (((1041 + 2460) <= (304 + 4188)) and v81 and ((v84 and v34) or not v84) and (v74 < v123)) then
					local v223 = 221 - (55 + 166);
					while true do
						if ((v223 == (0 + 0)) or ((347 + 3095) < (9730 - 7182))) then
							if (((3172 - (36 + 261)) >= (2560 - 1096)) and v89.BloodFury:IsCastable()) then
								if (v23(v89.BloodFury) or ((6165 - (34 + 1334)) >= (1881 + 3012))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v89.Berserking:IsCastable() and v118) or ((429 + 122) > (3351 - (1035 + 248)))) then
								if (((2135 - (20 + 1)) > (492 + 452)) and v23(v89.Berserking)) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v223 = 320 - (134 + 185);
						end
						if ((v223 == (1134 - (549 + 584))) or ((2947 - (314 + 371)) >= (10628 - 7532))) then
							if (v89.Fireblood:IsCastable() or ((3223 - (478 + 490)) >= (1874 + 1663))) then
								if (v23(v89.Fireblood) or ((5009 - (786 + 386)) < (4229 - 2923))) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (((4329 - (1055 + 324)) == (4290 - (1093 + 247))) and v89.AncestralCall:IsCastable()) then
								if (v23(v89.AncestralCall) or ((4198 + 525) < (347 + 2951))) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if (((4510 - 3374) >= (522 - 368)) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) then
					if (v23(v89.TimeWarp, nil, nil, true) or ((771 - 500) > (11931 - 7183))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v165 = 1 + 1;
			end
		end
	end
	local function v147()
		if (((18260 - 13520) >= (10864 - 7712)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
			if (v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment)) or ((1944 + 634) >= (8669 - 5279))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((729 - (364 + 324)) <= (4553 - 2892)) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
			if (((1442 - 841) < (1180 + 2380)) and v23(v89.BagofTricks)) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((983 - 748) < (1099 - 412)) and v89.LivingBomb:IsReady() and v33 and v42 and (v126 > (2 - 1)) and v119) then
			if (((5817 - (1249 + 19)) > (1041 + 112)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (77 - 57)) or ((5760 - (686 + 400)) < (3666 + 1006))) then
			v31 = v146();
			if (((3897 - (73 + 156)) < (22 + 4539)) and v31) then
				return v31;
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(841 - (721 + 90), 1 + 1) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((12 - 8) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((925 - (224 + 246)) == (5840 - 2235))) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((4902 - 2239) == (601 + 2711))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v31 = v145();
		if (((102 + 4175) <= (3287 + 1188)) and v31) then
			return v31;
		end
		if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 - 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((1383 - (203 + 310)) == (3182 - (1238 + 755)))) then
			if (((109 + 1444) <= (4667 - (709 + 825))) and v23(v89.Combustion, not v14:IsInRange(73 - 33), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((3258 - 1021) >= (4375 - (196 + 668)))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(157 - 117), v13:BuffDown(v89.IceFloes)) or ((2742 - 1418) > (3853 - (171 + 662)))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((3085 - (4 + 89)) == (6592 - 4711))) then
			if (((1131 + 1975) > (6702 - 5176)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((1186 + 1837) < (5356 - (35 + 1451))) and v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (1455 - (28 + 1425))) and not v135()) then
			if (((2136 - (941 + 1052)) > (71 + 3)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
				return "fireball combustion_phase 16";
			end
		end
		if (((1532 - (822 + 692)) < (3014 - 902)) and v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) then
			if (((517 + 580) <= (1925 - (45 + 252))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch combustion_phase 18";
			end
		end
		if (((4582 + 48) == (1594 + 3036)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((9 - 5) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (433 - (114 + 319))))) < (2 - 0))) then
			if (((4536 - 996) > (1711 + 972)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((7141 - 2347) >= (6861 - 3586)) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
			if (((3447 - (556 + 1407)) == (2690 - (741 + 465))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(505 - (170 + 295)), v13:BuffDown(v89.IceFloes))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((755 + 677) < (3266 + 289)) and v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((2621 - 1556) > (2967 + 611))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) or ((3076 + 1719) < (797 + 610))) then
			if (((3083 - (957 + 273)) < (1288 + 3525)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) or ((10749 - 7928) < (6406 - 3975))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((8778 - 5904) < (10799 - 8618))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if ((v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (1780 - (389 + 1391))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) or ((1688 + 1001) <= (36 + 307))) then
			if (v23(v89.ShiftingPower, not v14:IsInRange(91 - 51)) or ((2820 - (783 + 168)) == (6742 - 4733))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((3488 + 58) < (2633 - (309 + 2)))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(122 - 82), v13:BuffDown(v89.IceFloes)) or ((3294 - (1090 + 122)) == (1548 + 3225))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if (((10894 - 7650) > (723 + 332)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((4431 - (628 + 490)) <= (319 + 1459))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((9 - 5) * v124)) and (v127 < v99)) or ((6493 - 5072) >= (2878 - (431 + 343)))) then
			if (((3659 - 1847) <= (9398 - 6149)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch combustion_phase 36";
			end
		end
		if (((1283 + 340) <= (251 + 1706)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(1725 - (556 + 1139), 17 - (6 + 9)) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1 + 1)) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((3 + 1) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (170 - (28 + 141))) or v13:BuffUp(v89.FlamesFuryBuff))) then
			if (((1709 + 2703) == (5445 - 1033)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if (((1240 + 510) >= (2159 - (486 + 831))) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) then
			if (((11376 - 7004) > (6513 - 4663)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
				return "fireball combustion_phase 40";
			end
		end
		if (((44 + 188) < (2595 - 1774)) and v89.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(1293 - (668 + 595), 2 + 0) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1 + 1))) then
			if (((1412 - 894) < (1192 - (23 + 267))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if (((4938 - (1129 + 815)) > (1245 - (371 + 16))) and v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((5505 - (1326 + 424)) <= (1732 - 817))) then
				return "scorch combustion_phase 44";
			end
		end
		if (((14419 - 10473) > (3861 - (88 + 30))) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) then
			if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((2106 - (720 + 51)) >= (7354 - 4048))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((6620 - (421 + 1355)) > (3716 - 1463)) and v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (1 + 0))) then
			if (((1535 - (286 + 797)) == (1652 - 1200)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v125 < v99)) + (v89.Flamestrike:CastTime() * v27(v125 >= v99))) - v104;
		v109 = v114;
		if ((v89.Firestarter:IsAvailable() and not v96) or ((7548 - 2991) < (2526 - (397 + 42)))) then
			v109 = v29(v133(), v109);
		end
		if (((1210 + 2664) == (4674 - (24 + 776))) and v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (4 - 1) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((v114 + ((905 - (222 + 563)) * ((1 - 0) - ((0.4 + 0 + ((190.2 - (23 + 167)) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (1818 - (690 + 1108)))) or ((700 + 1238) > (4071 + 864))) then
			v109 = v114;
		end
	end
	local function v149()
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (849 - (40 + 808))) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (1 + 0)) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((7 - 5) * v124)))) or ((4067 + 188) < (1811 + 1612))) then
			if (((798 + 656) <= (3062 - (47 + 524))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(82 - 52, 2 - 0) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((4 - 2) * v124)))) or ((5883 - (1165 + 561)) <= (84 + 2719))) then
			if (((15030 - 10177) >= (1138 + 1844)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v150()
		local v167 = 479 - (341 + 138);
		while true do
			if (((1116 + 3018) > (6927 - 3570)) and (v167 == (331 - (89 + 237)))) then
				if ((v89.Fireball:IsReady() and v40 and not v137()) or ((10992 - 7575) < (5334 - 2800))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((3603 - (581 + 300)) <= (1384 - (855 + 365)))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v167 == (6 - 3)) or ((787 + 1621) < (3344 - (1030 + 205)))) then
				if ((v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (0 + 0)) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v89.PhoenixFlames:ChargesFractional() > (287.5 - (156 + 130))) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((6 - 3) * v124)))))) or ((55 - 22) == (2980 - 1525))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((117 + 326) >= (2342 + 1673))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v145();
				if (((3451 - (10 + 59)) > (47 + 119)) and v31) then
					return v31;
				end
				if ((v33 and v89.DragonsBreath:IsReady() and v38 and (v127 > (4 - 3)) and v89.AlexstraszasFury:IsAvailable()) or ((1443 - (671 + 492)) == (2436 + 623))) then
					if (((3096 - (369 + 846)) > (343 + 950)) and v23(v89.DragonsBreath, not v14:IsInRange(9 + 1))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v167 = 1949 - (1036 + 909);
			end
			if (((1874 + 483) == (3956 - 1599)) and (v167 == (203 - (11 + 192)))) then
				if (((63 + 60) == (298 - (135 + 40))) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v97) and v137()) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(96 - 56), v13:BuffDown(v89.IceFloes)) or ((637 + 419) >= (7472 - 4080))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v137())) or ((1620 - 539) < (1251 - (50 + 126)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((2920 - 1871) >= (981 + 3451))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v125 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) or ((6181 - (1233 + 180)) <= (1815 - (522 + 447)))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(1461 - (107 + 1314)), v13:BuffDown(v89.IceFloes)) or ((1559 + 1799) <= (4326 - 2906))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((3 + 2) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((7424 - 3685) <= (11889 - 8884))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((3569 - (716 + 1194)) >= (37 + 2097))) then
						return "scorch standard_rotation 13";
					end
				end
				v167 = 1 + 0;
			end
			if ((v167 == (504 - (74 + 429))) or ((6288 - 3028) < (1168 + 1187))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((1531 - 862) == (2988 + 1235))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((5216 - 3524) < (1453 - 865))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and ((((v13:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (433.5 - (279 + 154))) or not v89.Hyperthermia:IsAvailable())) or (v13:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (778.5 - (454 + 324))) or not v89.Hyperthermia:IsAvailable()))) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (3 + 0))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (17 - (12 + 5)))))))) or ((2587 + 2210) < (9302 - 5651))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((1544 + 2633) > (5943 - (277 + 816)))) then
						return "fire_blast standard_rotation 16";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(4 - 3, v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((1583 - (1058 + 125)) > (209 + 902))) then
					if (((4026 - (815 + 160)) > (4312 - 3307)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((8766 - 5073) <= (1046 + 3336)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((11 - 7) * v124))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((5180 - (41 + 1857)) > (5993 - (1222 + 671)))) then
						return "scorch standard_rotation 19";
					end
				end
				v167 = 5 - 3;
			end
			if ((v167 == (2 - 0)) or ((4762 - (229 + 953)) < (4618 - (1111 + 663)))) then
				if (((1668 - (874 + 705)) < (629 + 3861)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 0) * v124)))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((10357 - 5374) < (51 + 1757))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((4508 - (642 + 37)) > (860 + 2909)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(5 + 25, 4 - 2) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((456 - (233 + 221)) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((3433 - 1948) <= (2557 + 347)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if (((5810 - (718 + 823)) == (2687 + 1582)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) then
					if (((1192 - (266 + 539)) <= (7876 - 5094)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or ((3124 - (636 + 589)) <= (2176 - 1259))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((8893 - 4581) <= (695 + 181))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v167 = 2 + 1;
			end
			if (((3247 - (657 + 358)) <= (6873 - 4277)) and (v167 == (8 - 4))) then
				if (((3282 - (1151 + 36)) < (3560 + 126)) and v89.Scorch:IsReady() and v46 and (v134())) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((420 + 1175) >= (13361 - 8887))) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v33 and v89.ArcaneExplosion:IsReady() and v36 and (v128 >= v101) and (v13:ManaPercentageP() >= v102)) or ((6451 - (1552 + 280)) < (3716 - (64 + 770)))) then
					if (v23(v89.ArcaneExplosion, not v14:IsInRange(6 + 2)) or ((667 - 373) >= (858 + 3973))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if (((3272 - (157 + 1086)) <= (6172 - 3088)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v98)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(175 - 135)) or ((3124 - 1087) == (3303 - 883))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((5277 - (599 + 220)) > (7774 - 3870)) and v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) then
					if (((2367 - (1813 + 118)) >= (90 + 33)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v167 = 1222 - (841 + 376);
			end
		end
	end
	local function v151()
		local v168 = 0 - 0;
		while true do
			if (((117 + 383) < (4956 - 3140)) and (v168 == (860 - (464 + 395)))) then
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (2 - 1)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((6 + 6) / v89.FireBlast:Cooldown()) % (838 - (467 + 370))))) and (v109 < v123);
				if (((7385 - 3811) == (2624 + 950)) and not v95 and ((v109 <= (0 - 0)) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) then
					v31 = v147();
					if (((35 + 186) < (907 - 517)) and v31) then
						return v31;
					end
				end
				if ((not v113 and v89.SunKingsBlessing:IsAvailable()) or ((2733 - (150 + 370)) <= (2703 - (74 + 1208)))) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((7 - 4) * v124));
				end
				if (((14502 - 11444) < (3459 + 1401)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (390 - (14 + 376))) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(69 - 29), true) or ((839 + 457) >= (3906 + 540))) then
						return "shifting_power main 12";
					end
				end
				v168 = 2 + 0;
			end
			if ((v168 == (8 - 5)) or ((1048 + 345) > (4567 - (23 + 55)))) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) or ((10484 - 6060) < (19 + 8))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((1794 + 203) > (5915 - 2100))) then
						return "fire_blast main 16";
					end
				end
				if (((1090 + 2375) > (2814 - (652 + 249))) and (v109 > (0 - 0)) and v119) then
					v31 = v150();
					if (((2601 - (708 + 1160)) < (4937 - 3118)) and v31) then
						return v31;
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((8013 - 3618) == (4782 - (10 + 17)))) then
					if (v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova)) or ((852 + 2941) < (4101 - (1400 + 332)))) then
						return "ice_nova main 18";
					end
				end
				if ((v89.Scorch:IsReady() and v46) or ((7833 - 3749) == (2173 - (242 + 1666)))) then
					if (((1865 + 2493) == (1598 + 2760)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v168 == (2 + 0)) or ((4078 - (850 + 90)) < (1738 - 745))) then
				if (((4720 - (360 + 1030)) > (2056 + 267)) and (v125 < v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (19 - 12)) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v125 >= v99) or ((4988 - 1362) == (5650 - (909 + 752)))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (1223 - (109 + 1114))) and (v125 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (1 + 1)))) or ((1158 - (6 + 236)) == (1683 + 988))) then
					if (((219 + 53) == (640 - 368)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast main 14";
					end
				end
				if (((7421 - 3172) <= (5972 - (1076 + 57))) and v119 and v132() and (v109 > (0 + 0))) then
					local v224 = 689 - (579 + 110);
					while true do
						if (((220 + 2557) < (2830 + 370)) and (v224 == (0 + 0))) then
							v31 = v149();
							if (((502 - (174 + 233)) < (5466 - 3509)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v168 = 4 - 1;
			end
			if (((368 + 458) < (2891 - (663 + 511))) and (v168 == (0 + 0))) then
				if (((310 + 1116) >= (3406 - 2301)) and not v95) then
					v148();
				end
				if (((1668 + 1086) <= (7954 - 4575)) and v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (96 - 56)))) then
					if (v23(v89.TimeWarp, not v14:IsInRange(20 + 20)) or ((7643 - 3716) == (1008 + 405))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v74 < v123) or ((106 + 1048) <= (1510 - (478 + 244)))) then
					if ((v82 and ((v34 and v83) or not v83)) or ((2160 - (440 + 77)) > (1537 + 1842))) then
						local v228 = 0 - 0;
						while true do
							if ((v228 == (1556 - (655 + 901))) or ((520 + 2283) > (3483 + 1066))) then
								v31 = v140();
								if (v31 or ((149 + 71) >= (12174 - 9152))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v168 = 1446 - (695 + 750);
			end
		end
	end
	local function v152()
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
		v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (351 - (285 + 66));
		v64 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v65 = EpicSettings.Settings['mirrorImageHP'] or (1310 - (682 + 628));
		v66 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v153()
		local v197 = 299 - (176 + 123);
		while true do
			if (((1181 + 1641) == (2048 + 774)) and (v197 == (269 - (239 + 30)))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v75 = EpicSettings.Settings['useWeapon'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v197 = 1 + 0;
			end
			if ((v197 == (8 - 3)) or ((3310 - 2249) == (2172 - (306 + 9)))) then
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((9631 - 6871) > (238 + 1126)) and (v197 == (2 + 1))) then
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v197 = 2 + 2;
			end
			if (((2 - 1) == v197) or ((6277 - (1140 + 235)) <= (2288 + 1307))) then
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v197 = 2 + 0;
			end
			if ((v197 == (2 + 2)) or ((3904 - (33 + 19)) == (106 + 187))) then
				v76 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v78 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v197 = 9 - 4;
			end
			if ((v197 == (2 + 0)) or ((2248 - (586 + 103)) == (418 + 4170))) then
				v67 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v81 = EpicSettings.Settings['useRacials'];
				v197 = 9 - 6;
			end
		end
	end
	local function v154()
		local v198 = 1488 - (1309 + 179);
		while true do
			if ((v198 == (5 - 2)) or ((1952 + 2532) == (2116 - 1328))) then
				if (((3451 + 1117) >= (8300 - 4393)) and v33) then
					local v225 = 0 - 0;
					while true do
						if (((1855 - (295 + 314)) < (8523 - 5053)) and (v225 == (1962 - (1300 + 662)))) then
							v125 = v29(v14:GetEnemiesInSplashRangeCount(15 - 10), #v129);
							v126 = v29(v14:GetEnemiesInSplashRangeCount(1760 - (1178 + 577)), #v129);
							v225 = 1 + 0;
						end
						if (((12025 - 7957) >= (2377 - (851 + 554))) and (v225 == (1 + 0))) then
							v127 = v29(v14:GetEnemiesInSplashRangeCount(13 - 8), #v129);
							v128 = #v129;
							break;
						end
					end
				else
					v125 = 1 - 0;
					v126 = 303 - (115 + 187);
					v127 = 1 + 0;
					v128 = 1 + 0;
				end
				if (((1942 - 1449) < (5054 - (160 + 1001))) and (v93.TargetIsValid() or v13:AffectingCombat())) then
					local v226 = 0 + 0;
					while true do
						if ((v226 == (3 + 1)) or ((3015 - 1542) >= (3690 - (237 + 121)))) then
							v118 = v13:BuffUp(v89.CombustionBuff);
							v119 = not v118;
							break;
						end
						if ((v226 == (899 - (525 + 372))) or ((7680 - 3629) <= (3801 - 2644))) then
							v131 = v138(v129);
							v95 = not v34;
							v226 = 145 - (96 + 46);
						end
						if (((1381 - (643 + 134)) < (1041 + 1840)) and (v226 == (6 - 3))) then
							if (v95 or ((3341 - 2441) == (3239 + 138))) then
								v109 = 196251 - 96252;
							end
							v124 = v13:GCD();
							v226 = 7 - 3;
						end
						if (((5178 - (316 + 403)) > (393 + 198)) and (v226 == (0 - 0))) then
							if (((1229 + 2169) >= (6031 - 3636)) and (v13:AffectingCombat() or v68)) then
								local v231 = 0 + 0;
								local v232;
								while true do
									if ((v231 == (1 + 0)) or ((7564 - 5381) >= (13486 - 10662))) then
										if (((4021 - 2085) == (111 + 1825)) and v31) then
											return v31;
										end
										break;
									end
									if ((v231 == (0 - 0)) or ((237 + 4595) < (12689 - 8376))) then
										v232 = v68 and v89.RemoveCurse:IsReady() and v35;
										v31 = v93.FocusUnit(v232, nil, 37 - (12 + 5), nil, 77 - 57, v89.ArcaneIntellect);
										v231 = 1 - 0;
									end
								end
							end
							v122 = v9.BossFightRemains(nil, true);
							v226 = 1 - 0;
						end
						if (((10137 - 6049) > (787 + 3087)) and (v226 == (1974 - (1656 + 317)))) then
							v123 = v122;
							if (((3861 + 471) == (3472 + 860)) and (v123 == (29544 - 18433))) then
								v123 = v9.FightRemains(v129, false);
							end
							v226 = 9 - 7;
						end
					end
				end
				if (((4353 - (5 + 349)) >= (13774 - 10874)) and not v13:AffectingCombat() and v32) then
					local v227 = 1271 - (266 + 1005);
					while true do
						if ((v227 == (0 + 0)) or ((8615 - 6090) > (5349 - 1285))) then
							v31 = v144();
							if (((6067 - (561 + 1135)) == (5695 - 1324)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v198 = 12 - 8;
			end
			if ((v198 == (1068 - (507 + 559))) or ((667 - 401) > (15420 - 10434))) then
				if (((2379 - (212 + 176)) >= (1830 - (250 + 655))) and v13:IsDeadOrGhost()) then
					return v31;
				end
				v130 = v14:GetEnemiesInSplashRange(13 - 8);
				v129 = v13:GetEnemiesInRange(69 - 29);
				v198 = 4 - 1;
			end
			if (((2411 - (1869 + 87)) < (7120 - 5067)) and (v198 == (1902 - (484 + 1417)))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v198 = 4 - 2;
			end
			if ((v198 == (6 - 2)) or ((1599 - (48 + 725)) == (7924 - 3073))) then
				if (((490 - 307) == (107 + 76)) and v13:AffectingCombat() and v93.TargetIsValid()) then
					if (((3097 - 1938) <= (501 + 1287)) and v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) then
						if (v23(v91.UseWeapon, nil) or ((1023 + 2484) > (5171 - (152 + 701)))) then
							return "Using Weapon Macro";
						end
					end
					if ((v68 and v35 and v89.RemoveCurse:IsAvailable()) or ((4386 - (430 + 881)) <= (1136 + 1829))) then
						if (((2260 - (557 + 338)) <= (595 + 1416)) and v15) then
							v31 = v142();
							if (v31 or ((7822 - 5046) > (12518 - 8943))) then
								return v31;
							end
						end
						if ((v17 and v17:Exists() and v17:IsAPlayer() and v93.UnitHasCurseDebuff(v17)) or ((6785 - 4231) == (10353 - 5549))) then
							if (((3378 - (499 + 302)) == (3443 - (39 + 827))) and v89.RemoveCurse:IsReady()) then
								if (v23(v91.RemoveCurseMouseover) or ((16 - 10) >= (4218 - 2329))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					v31 = v143();
					if (((2009 - 1503) <= (2904 - 1012)) and v31) then
						return v31;
					end
					if (v69 or ((172 + 1836) > (6491 - 4273))) then
						if (((61 + 318) <= (6561 - 2414)) and v88) then
							local v230 = 104 - (103 + 1);
							while true do
								if ((v230 == (554 - (475 + 79))) or ((9758 - 5244) <= (3228 - 2219))) then
									v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 4 + 26);
									if (v31 or ((3077 + 419) == (2695 - (1395 + 108)))) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if (v70 or ((605 - 397) == (4163 - (7 + 1197)))) then
						local v229 = 0 + 0;
						while true do
							if (((1493 + 2784) >= (1632 - (27 + 292))) and (v229 == (0 - 0))) then
								v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 38 - 8);
								if (((10849 - 8262) < (6259 - 3085)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) or ((7846 - 3726) <= (2337 - (43 + 96)))) then
						if (v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal)) or ((6510 - 4914) == (1939 - 1081))) then
							return "spellsteal damage";
						end
					end
					if (((2672 + 548) == (910 + 2310)) and (v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v89.HotStreakBuff)) then
						if (v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast)) or ((2770 - 1368) > (1388 + 2232))) then
							return "Stop Casting";
						end
					end
					if (((4823 - 2249) == (811 + 1763)) and v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) then
						if (((132 + 1666) < (4508 - (1414 + 337))) and v23(v89.IceFloes)) then
							return "ice_floes movement";
						end
					end
					v31 = v151();
					if (v31 or ((2317 - (1642 + 298)) > (6788 - 4184))) then
						return v31;
					end
				end
				break;
			end
			if (((1633 - 1065) < (2703 - 1792)) and (v198 == (0 + 0))) then
				v152();
				v153();
				v32 = EpicSettings.Toggles['ooc'];
				v198 = 1 + 0;
			end
		end
	end
	local function v155()
		local v199 = 972 - (357 + 615);
		while true do
			if (((2306 + 979) < (10374 - 6146)) and (v199 == (0 + 0))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(134 - 71, v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

