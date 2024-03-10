local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2361 + 872) == (6704 - 3471)) and not v5) then
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
		if (((3276 - (1293 + 519)) <= (8929 - 4552)) and v89.RemoveCurse:IsAvailable()) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (9 - 5)) or (1909 - 910);
	local v98 = 4307 - 3308;
	local v99 = v97;
	local v100 = ((6 - 3) * v27(v89.FueltheFire:IsAvailable())) + ((530 + 469) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 204 + 795;
	local v102 = 92 - 52;
	local v103 = 231 + 768;
	local v104 = 0.3 + 0;
	local v105 = 0 + 0;
	local v106 = 1102 - (709 + 387);
	local v107 = false;
	local v108 = (v107 and (1878 - (673 + 1185))) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (1 - 0);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 + 0;
	local v115 = 0 + 0;
	local v116 = 10 - 2;
	local v117 = 1 + 2;
	local v118;
	local v119;
	local v120;
	local v121 = 5 - 2;
	local v122 = 21810 - 10699;
	local v123 = 12991 - (446 + 1434);
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v9:RegisterForEvent(function()
		local v156 = 1283 - (1040 + 243);
		while true do
			if (((8025 - 5336) < (6570 - (559 + 1288))) and (v156 == (1931 - (609 + 1322)))) then
				v107 = false;
				v108 = (v107 and (474 - (13 + 441))) or (0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v157 = 0 - 0;
		while true do
			if (((20599 - 16463) >= (90 + 2307)) and (v157 == (10 - 7))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if ((v157 == (0 + 0)) or ((1900 + 2434) == (12597 - 8352))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v157 = 1 + 0;
			end
			if ((v157 == (3 - 1)) or ((2827 + 1449) <= (1686 + 1345))) then
				v89.PhoenixFlames:RegisterInFlightEffect(185047 + 72495);
				v89.PhoenixFlames:RegisterInFlight();
				v157 = 3 + 0;
			end
			if ((v157 == (1 + 0)) or ((5215 - (153 + 280)) <= (3461 - 2262))) then
				v89.Meteor:RegisterInFlightEffect(315254 + 35886);
				v89.Meteor:RegisterInFlight();
				v157 = 1 + 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(183758 + 167382);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(233715 + 23827);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (0 - 0)) or ((3007 + 1857) < (2569 - (89 + 578)))) then
				v122 = 7938 + 3173;
				v123 = 23099 - 11988;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v159 = 1049 - (572 + 477);
		while true do
			if (((653 + 4186) >= (2221 + 1479)) and (v159 == (1 + 0))) then
				v99 = v97;
				v110 = ((v89.Kindling:IsAvailable()) and (86.4 - (84 + 2))) or (1 - 0);
				break;
			end
			if ((v159 == (0 + 0)) or ((1917 - (497 + 345)) > (50 + 1868))) then
				v96 = v89.SunKingsBlessing:IsAvailable();
				v97 = ((v89.FlamePatch:IsAvailable()) and (1 + 2)) or (2332 - (605 + 728));
				v159 = 1 + 0;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (200 - 110));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (5 + 85)) and v14:TimeToX(332 - 242)) or (0 + 0))) or (0 - 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (23 + 7));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (519 - (457 + 32)));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((1798 - (832 + 570)) <= (3584 + 220)) and (v160 == (0 + 0))) then
				v161 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 - 0);
				v161 = v161 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(1 + 0, v89.PhoenixFlames));
				v160 = 797 - (588 + 208);
			end
			if ((v160 == (2 - 1)) or ((5969 - (884 + 916)) == (4578 - 2391))) then
				return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast) or (v161 > (0 + 0))))));
			end
		end
	end
	local function v138(v162)
		local v163 = 653 - (232 + 421);
		local v164;
		while true do
			if (((3295 - (1569 + 320)) == (345 + 1061)) and ((1 + 0) == v163)) then
				return v164;
			end
			if (((5159 - 3628) < (4876 - (316 + 289))) and ((0 - 0) == v163)) then
				v164 = 0 + 0;
				for v227, v228 in pairs(v162) do
					if (((2088 - (666 + 787)) == (1060 - (360 + 65))) and v228:DebuffUp(v89.IgniteDebuff)) then
						v164 = v164 + 1 + 0;
					end
				end
				v163 = 255 - (79 + 175);
			end
		end
	end
	local function v139()
		local v165 = 0 - 0;
		local v166;
		while true do
			if (((2633 + 740) <= (10899 - 7343)) and (v165 == (1 - 0))) then
				return v166;
			end
			if ((v165 == (899 - (503 + 396))) or ((3472 - (92 + 89)) < (6363 - 3083))) then
				v166 = 0 + 0;
				if (((2596 + 1790) >= (3418 - 2545)) and (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight())) then
					v166 = v166 + 1 + 0;
				end
				v165 = 2 - 1;
			end
		end
	end
	local function v140()
		local v167 = 0 + 0;
		while true do
			if (((440 + 481) <= (3356 - 2254)) and (v167 == (1 + 0))) then
				v31 = v93.HandleBottomTrinket(v92, v34, 61 - 21, nil);
				if (((5950 - (485 + 759)) >= (2228 - 1265)) and v31) then
					return v31;
				end
				break;
			end
			if (((1189 - (442 + 747)) == v167) or ((2095 - (832 + 303)) <= (1822 - (88 + 858)))) then
				v31 = v93.HandleTopTrinket(v92, v34, 13 + 27, nil);
				if (v31 or ((1710 + 356) == (39 + 893))) then
					return v31;
				end
				v167 = 790 - (766 + 23);
			end
		end
	end
	local v141 = 0 - 0;
	local function v142()
		if (((6598 - 1773) < (12759 - 7916)) and v89.RemoveCurse:IsReady() and v93.UnitHasDispellableDebuffByPlayer(v15)) then
			local v207 = 0 - 0;
			while true do
				if ((v207 == (1073 - (1036 + 37))) or ((2749 + 1128) >= (8835 - 4298))) then
					if ((v141 == (0 + 0)) or ((5795 - (641 + 839)) < (2639 - (910 + 3)))) then
						v141 = GetTime();
					end
					if (v93.Wait(1274 - 774, v141) or ((5363 - (1466 + 218)) < (288 + 337))) then
						if (v23(v91.RemoveCurseFocus) or ((5773 - (556 + 592)) < (225 + 407))) then
							return "remove_curse dispel";
						end
						v141 = 808 - (329 + 479);
					end
					break;
				end
			end
		end
	end
	local function v143()
		if ((v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((937 - (174 + 680)) > (6116 - 4336))) then
			if (((1131 - 585) <= (769 + 308)) and v23(v89.BlazingBarrier)) then
				return "blazing_barrier defensive 1";
			end
		end
		if ((v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 741 - (396 + 343), v89.ArcaneIntellect)) or ((89 + 907) > (5778 - (29 + 1448)))) then
			if (((5459 - (135 + 1254)) > (2587 - 1900)) and v23(v89.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) or ((3062 - 2406) >= (2220 + 1110))) then
			if (v23(v89.IceBlock) or ((4019 - (389 + 1138)) <= (909 - (102 + 472)))) then
				return "ice_block defensive 3";
			end
		end
		if (((4079 + 243) >= (1421 + 1141)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
			if (v23(v89.IceColdAbility) or ((3392 + 245) >= (5315 - (320 + 1225)))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((4234 - 1855) > (2802 + 1776))) then
			if (v23(v89.MirrorImage) or ((1947 - (157 + 1307)) > (2602 - (821 + 1038)))) then
				return "mirror_image defensive 4";
			end
		end
		if (((6122 - 3668) > (64 + 514)) and v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
			if (((1651 - 721) < (1659 + 2799)) and v23(v89.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((1640 - 978) <= (1998 - (834 + 192))) and v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
			if (((278 + 4092) == (1122 + 3248)) and v23(v89.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) or ((103 + 4659) <= (1333 - 472))) then
			if (v23(v91.Healthstone) or ((1716 - (300 + 4)) == (1139 + 3125))) then
				return "healthstone defensive";
			end
		end
		if ((v76 and (v13:HealthPercentage() <= v78)) or ((8293 - 5125) < (2515 - (112 + 250)))) then
			if ((v80 == "Refreshing Healing Potion") or ((1984 + 2992) < (3336 - 2004))) then
				if (((2652 + 1976) == (2394 + 2234)) and v90.RefreshingHealingPotion:IsReady()) then
					if (v23(v91.RefreshingHealingPotion) or ((41 + 13) == (196 + 199))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((61 + 21) == (1496 - (1001 + 413))) and (v80 == "Dreamwalker's Healing Potion")) then
				if (v90.DreamwalkersHealingPotion:IsReady() or ((1295 - 714) < (1164 - (244 + 638)))) then
					if (v23(v91.RefreshingHealingPotion) or ((5302 - (627 + 66)) < (7434 - 4939))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v144()
		local v168 = 602 - (512 + 90);
		while true do
			if (((3058 - (1665 + 241)) == (1869 - (373 + 344))) and (v168 == (0 + 0))) then
				if (((502 + 1394) <= (9026 - 5604)) and v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
					if (v23(v89.ArcaneIntellect) or ((1675 - 685) > (2719 - (35 + 1064)))) then
						return "arcane_intellect precombat 2";
					end
				end
				if ((v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) or ((639 + 238) > (10045 - 5350))) then
					if (((11 + 2680) >= (3087 - (298 + 938))) and v23(v89.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				v168 = 1260 - (233 + 1026);
			end
			if ((v168 == (1667 - (636 + 1030))) or ((1527 + 1458) >= (4744 + 112))) then
				if (((1271 + 3005) >= (81 + 1114)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) then
					if (((3453 - (55 + 166)) <= (909 + 3781)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast precombat 4";
					end
				end
				if ((v89.Fireball:IsReady() and v40) or ((91 + 805) >= (12014 - 8868))) then
					if (((3358 - (36 + 261)) >= (5172 - 2214)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v169 = 1368 - (34 + 1334);
		while true do
			if (((1226 + 1961) >= (501 + 143)) and (v169 == (1284 - (1035 + 248)))) then
				if (((665 - (20 + 1)) <= (367 + 337)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (334 - (134 + 185)))) and not v135() and (v133() == (1133 - (549 + 584))) and not v89.TemperedFlames:IsAvailable()) then
					if (((1643 - (314 + 371)) > (3250 - 2303)) and v23(v89.DragonsBreath, not v14:IsInRange(978 - (478 + 490)))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((2380 + 2112) >= (3826 - (786 + 386))) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (48 - 33))) and not v135() and v89.TemperedFlames:IsAvailable()) then
					if (((4821 - (1055 + 324)) >= (2843 - (1093 + 247))) and v23(v89.DragonsBreath, not v14:IsInRange(9 + 1))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v169 == (0 + 0)) or ((12585 - 9415) <= (4968 - 3504))) then
				if ((v89.LivingBomb:IsReady() and v42 and (v126 > (2 - 1)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 - 0)))) or ((1707 + 3090) == (16904 - 12516))) then
					if (((1899 - 1348) <= (514 + 167)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((8380 - 5103) > (1095 - (364 + 324))) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (0 - 0)) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((107 - 62) < v109) or (v123 < v109))))) then
					if (((1557 + 3138) >= (5920 - 4505)) and v23(v91.MeteorCursor, not v14:IsInRange(64 - 24))) then
						return "meteor active_talents 4";
					end
				end
				v169 = 2 - 1;
			end
		end
	end
	local function v146()
		local v170 = 1268 - (1249 + 19);
		local v171;
		while true do
			if ((v170 == (2 + 0)) or ((12502 - 9290) <= (2030 - (686 + 400)))) then
				if ((v74 < v123) or ((2430 + 666) <= (2027 - (73 + 156)))) then
					if (((17 + 3520) == (4348 - (721 + 90))) and v82 and ((v34 and v83) or not v83)) then
						v31 = v140();
						if (((44 + 3793) >= (5097 - 3527)) and v31) then
							return v31;
						end
					end
				end
				break;
			end
			if ((v170 == (470 - (224 + 246))) or ((4779 - 1829) == (7018 - 3206))) then
				v171 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
				if (((857 + 3866) >= (56 + 2262)) and v171) then
					return v171;
				end
				v170 = 1 + 0;
			end
			if ((v170 == (1 - 0)) or ((6745 - 4718) > (3365 - (203 + 310)))) then
				if ((v81 and ((v84 and v34) or not v84) and (v74 < v123)) or ((3129 - (1238 + 755)) > (302 + 4015))) then
					local v229 = 1534 - (709 + 825);
					while true do
						if (((8749 - 4001) == (6916 - 2168)) and (v229 == (864 - (196 + 668)))) then
							if (((14750 - 11014) <= (9818 - 5078)) and v89.BloodFury:IsCastable()) then
								if (v23(v89.BloodFury) or ((4223 - (171 + 662)) <= (3153 - (4 + 89)))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v89.Berserking:IsCastable() and v118) or ((3501 - 2502) > (981 + 1712))) then
								if (((2033 - 1570) < (236 + 365)) and v23(v89.Berserking)) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v229 = 1487 - (35 + 1451);
						end
						if ((v229 == (1454 - (28 + 1425))) or ((4176 - (941 + 1052)) < (659 + 28))) then
							if (((6063 - (822 + 692)) == (6493 - 1944)) and v89.Fireblood:IsCastable()) then
								if (((2201 + 2471) == (4969 - (45 + 252))) and v23(v89.Fireblood)) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (v89.AncestralCall:IsCastable() or ((3630 + 38) < (136 + 259))) then
								if (v23(v89.AncestralCall) or ((10138 - 5972) == (888 - (114 + 319)))) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if ((v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) or ((6387 - 1938) == (3411 - 748))) then
					if (v23(v89.TimeWarp, nil, nil, true) or ((2727 + 1550) < (4452 - 1463))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v170 = 3 - 1;
			end
		end
	end
	local function v147()
		local v172 = 1963 - (556 + 1407);
		while true do
			if (((1212 - (741 + 465)) == v172) or ((1335 - (170 + 295)) >= (2187 + 1962))) then
				if (((2032 + 180) < (7836 - 4653)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) then
					if (((3852 + 794) > (1919 + 1073)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(23 + 17))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if (((2664 - (957 + 273)) < (831 + 2275)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (((315 + 471) < (11518 - 8495)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 34";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((10 - 6) * v124)) and (v127 < v99)) or ((7458 - 5016) < (366 - 292))) then
					if (((6315 - (389 + 1391)) == (2846 + 1689)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch combustion_phase 36";
					end
				end
				v172 = 1 + 6;
			end
			if ((v172 == (2 - 1)) or ((3960 - (783 + 168)) <= (7064 - 4959))) then
				if (((1801 + 29) < (3980 - (309 + 2))) and ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (61 - 41)))) then
					v31 = v146();
					if (v31 or ((2642 - (1090 + 122)) >= (1172 + 2440))) then
						return v31;
					end
				end
				if (((9010 - 6327) >= (1684 + 776)) and v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(1148 - (628 + 490), 1 + 1) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((9 - 5) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((8244 - 6440) >= (4049 - (431 + 343)))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v145();
				v172 = 3 - 1;
			end
			if (((14 - 9) == v172) or ((1120 + 297) > (465 + 3164))) then
				if (((6490 - (556 + 1139)) > (417 - (6 + 9))) and v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) then
					if (((882 + 3931) > (1827 + 1738)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 26";
					end
				end
				if (((4081 - (28 + 141)) == (1516 + 2396)) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 - 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) then
					if (((1998 + 823) <= (6141 - (486 + 831))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((4522 - 2784) <= (7727 - 5532)) and v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (0 + 0)) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
					if (((129 - 88) <= (4281 - (668 + 595))) and v23(v89.ShiftingPower, not v14:IsInRange(36 + 4))) then
						return "shifting_power combustion_phase 30";
					end
				end
				v172 = 2 + 4;
			end
			if (((5849 - 3704) <= (4394 - (23 + 267))) and (v172 == (1946 - (1129 + 815)))) then
				if (((3076 - (371 + 16)) < (6595 - (1326 + 424))) and v31) then
					return v31;
				end
				if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 - 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((2440 - (88 + 30)) > (3393 - (720 + 51)))) then
					if (v23(v89.Combustion, not v14:IsInRange(88 - 48), nil, true) or ((6310 - (421 + 1355)) == (3434 - 1352))) then
						return "combustion combustion_phase 10";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((772 + 799) > (2950 - (286 + 797)))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(146 - 106)) or ((4395 - 1741) >= (3435 - (397 + 42)))) then
						return "flamestrike combustion_phase 12";
					end
				end
				v172 = 1 + 2;
			end
			if (((4778 - (24 + 776)) > (3240 - 1136)) and (v172 == (789 - (222 + 563)))) then
				if (((6598 - 3603) > (1110 + 431)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((194 - (23 + 167)) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (1798 - (690 + 1108))))) < (1 + 1))) then
					if (((2680 + 569) > (1801 - (40 + 808))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) or ((539 + 2734) > (17486 - 12913))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(39 + 1)) or ((1667 + 1484) < (705 + 579))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) or ((2421 - (47 + 524)) == (993 + 536))) then
					if (((2244 - 1423) < (3174 - 1051)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 24";
					end
				end
				v172 = 11 - 6;
			end
			if (((2628 - (1165 + 561)) < (70 + 2255)) and (v172 == (9 - 6))) then
				if (((328 + 530) <= (3441 - (341 + 138))) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast)) or ((1066 + 2880) < (2657 - 1369))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (328 - (89 + 237))) and not v135()) or ((10429 - 7187) == (1193 - 626))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball)) or ((1728 - (581 + 300)) >= (2483 - (855 + 365)))) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) or ((5351 - 3098) == (605 + 1246))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((3322 - (1030 + 205)) > (2227 + 145))) then
						return "scorch combustion_phase 18";
					end
				end
				v172 = 4 + 0;
			end
			if ((v172 == (293 - (156 + 130))) or ((10099 - 5654) < (6992 - 2843))) then
				if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(61 - 31, 1 + 1) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (2 + 0)) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((73 - (10 + 59)) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (1 + 0)) or v13:BuffUp(v89.FlamesFuryBuff))) or ((8953 - 7135) == (1248 - (671 + 492)))) then
					if (((502 + 128) < (3342 - (369 + 846))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) or ((514 + 1424) == (2146 + 368))) then
					if (((6200 - (1036 + 909)) >= (44 + 11)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
						return "fireball combustion_phase 40";
					end
				end
				if (((5034 - 2035) > (1359 - (11 + 192))) and v89.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(16 + 14, 177 - (135 + 40)) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (4 - 2))) then
					if (((1417 + 933) > (2544 - 1389)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v172 = 11 - 3;
			end
			if (((4205 - (50 + 126)) <= (13513 - 8660)) and (v172 == (2 + 6))) then
				if ((v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) or ((1929 - (1233 + 180)) > (4403 - (522 + 447)))) then
					if (((5467 - (107 + 1314)) >= (1408 + 1625)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch combustion_phase 44";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) or ((8284 - 5565) <= (615 + 832))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball)) or ((8208 - 4074) < (15533 - 11607))) then
						return "fireball combustion_phase 46";
					end
				end
				if ((v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (1911 - (716 + 1194)))) or ((3 + 161) >= (299 + 2486))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((1028 - (74 + 429)) == (4067 - 1958))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if (((17 + 16) == (75 - 42)) and (v172 == (0 + 0))) then
				if (((9415 - 6361) <= (9927 - 5912)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (((2304 - (279 + 154)) < (4160 - (454 + 324))) and v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((1018 + 275) <= (2183 - (12 + 5))) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (v23(v89.BagofTricks) or ((1391 + 1188) < (312 - 189))) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v89.LivingBomb:IsReady() and v33 and v42 and (v126 > (1 + 0)) and v119) or ((1939 - (277 + 816)) >= (10118 - 7750))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((5195 - (1058 + 125)) <= (630 + 2728))) then
						return "living_bomb combustion_phase 6";
					end
				end
				v172 = 976 - (815 + 160);
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v125 < v99)) + (v89.Flamestrike:CastTime() * v27(v125 >= v99))) - v104;
		v109 = v114;
		if (((6410 - 4916) <= (7133 - 4128)) and v89.Firestarter:IsAvailable() and not v96) then
			v109 = v29(v133(), v109);
		end
		if ((v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) or ((743 + 2368) == (6237 - 4103))) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (1901 - (41 + 1857)) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((4248 - (1222 + 671)) == (6086 - 3731)) and (((v114 + ((172 - 52) * ((1183 - (229 + 953)) - (((1774.4 - (1111 + 663)) + ((1579.2 - (874 + 705)) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (3 + 17))))) then
			v109 = v114;
		end
	end
	local function v149()
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (1 - 0)) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((1 + 1) * v124)))) or ((1267 - (642 + 37)) <= (99 + 333))) then
			if (((768 + 4029) >= (9779 - 5884)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if (((4031 - (233 + 221)) == (8271 - 4694)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(1571 - (718 + 823), 2 + 0) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((807 - (266 + 539)) * v124)))) then
			if (((10741 - 6947) > (4918 - (636 + 589))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v150()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (1 - 0)) or ((1011 + 264) == (1490 + 2610))) then
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((1020 - (657 + 358)) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((4212 - 2621) >= (8156 - 4576))) then
					if (((2170 - (1151 + 36)) <= (1746 + 62)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch standard_rotation 13";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((566 + 1584) <= (3574 - 2377))) then
					if (((5601 - (1552 + 280)) >= (2007 - (64 + 770))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((1009 + 476) == (3371 - 1886)) and v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and ((((v13:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 + 0)) or not v89.Hyperthermia:IsAvailable())) or (v13:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (1243.5 - (157 + 1086))) or not v89.Hyperthermia:IsAvailable()))) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (5 - 2))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (0 - 0))))))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((5084 - 1769) <= (3796 - 1014))) then
						return "fire_blast standard_rotation 16";
					end
				end
				v173 = 821 - (599 + 220);
			end
			if ((v173 == (9 - 4)) or ((2807 - (1813 + 118)) >= (2167 + 797))) then
				if ((v33 and v89.DragonsBreath:IsReady() and v38 and (v127 > (1218 - (841 + 376))) and v89.AlexstraszasFury:IsAvailable()) or ((3127 - 895) > (581 + 1916))) then
					if (v23(v89.DragonsBreath, not v14:IsInRange(27 - 17)) or ((2969 - (464 + 395)) <= (851 - 519))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if (((1771 + 1915) > (4009 - (467 + 370))) and v89.Scorch:IsReady() and v46 and (v134())) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((9245 - 4771) < (602 + 218))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((14668 - 10389) >= (450 + 2432)) and v33 and v89.ArcaneExplosion:IsReady() and v36 and (v128 >= v101) and (v13:ManaPercentageP() >= v102)) then
					if (v23(v89.ArcaneExplosion, not v14:IsInRange(18 - 10)) or ((2549 - (150 + 370)) >= (4803 - (74 + 1208)))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v173 = 14 - 8;
			end
			if (((18 - 14) == v173) or ((1450 + 587) >= (5032 - (14 + 376)))) then
				if (((2983 - 1263) < (2885 + 1573)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (0 + 0)) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v89.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((3 + 0) * v124)))))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((514 - (23 + 55)) > (7159 - 4138))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v145();
				if (((476 + 237) <= (761 + 86)) and v31) then
					return v31;
				end
				v173 = 7 - 2;
			end
			if (((678 + 1476) <= (4932 - (652 + 249))) and (v173 == (0 - 0))) then
				if (((6483 - (708 + 1160)) == (12527 - 7912)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v97) and v137()) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(72 - 32)) or ((3817 - (10 + 17)) == (113 + 387))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((1821 - (1400 + 332)) < (423 - 202)) and v89.Pyroblast:IsReady() and v45 and (v137())) then
					if (((3962 - (242 + 1666)) >= (609 + 812)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((254 + 438) < (2607 + 451)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v125 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(980 - (850 + 90))) or ((5699 - 2445) == (3045 - (360 + 1030)))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v173 = 1 + 0;
			end
			if (((16 - 10) == v173) or ((1782 - 486) == (6571 - (909 + 752)))) then
				if (((4591 - (109 + 1114)) == (6166 - 2798)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v98)) then
					if (((1029 + 1614) < (4057 - (6 + 236))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(26 + 14))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((1540 + 373) > (1162 - 669)) and v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) then
					if (((8305 - 3550) > (4561 - (1076 + 57))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 35";
					end
				end
				if (((228 + 1153) <= (3058 - (579 + 110))) and v89.Fireball:IsReady() and v40 and not v137()) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true) or ((383 + 4460) == (3611 + 473))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((2478 + 2191) > (770 - (174 + 233))) and (v173 == (5 - 3))) then
				if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(1 - 0, v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((835 + 1042) >= (4312 - (663 + 511)))) then
					if (((4231 + 511) >= (788 + 2838)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((12 - 8) * v124))) or ((2750 + 1790) == (2156 - 1240))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((2798 - 1642) > (2074 + 2271))) then
						return "scorch standard_rotation 19";
					end
				end
				if (((4353 - 2116) < (3029 + 1220)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((1 + 1) * v124)))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((3405 - (478 + 244)) < (540 - (440 + 77)))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v173 = 2 + 1;
			end
			if (((2551 - 1854) <= (2382 - (655 + 901))) and (v173 == (1 + 2))) then
				if (((846 + 259) <= (795 + 381)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(120 - 90, 1447 - (695 + 750)) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((6 - 4) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((5214 - 1835) <= (15330 - 11518)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((1139 - (285 + 66)) >= (3766 - 2150))) then
					if (((3164 - (682 + 628)) <= (545 + 2834)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch standard_rotation 22";
					end
				end
				if (((4848 - (176 + 123)) == (1903 + 2646)) and v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((2193 + 829) >= (3293 - (239 + 30)))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v173 = 2 + 2;
			end
		end
	end
	local function v151()
		if (((4633 + 187) > (3890 - 1692)) and not v95) then
			v148();
		end
		if ((v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (124 - 84)))) or ((1376 - (306 + 9)) >= (17067 - 12176))) then
			if (((238 + 1126) <= (2745 + 1728)) and v23(v89.TimeWarp, not v14:IsInRange(20 + 20))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v74 < v123) or ((10280 - 6685) <= (1378 - (1140 + 235)))) then
			if ((v82 and ((v34 and v83) or not v83)) or ((2974 + 1698) == (3533 + 319))) then
				v31 = v140();
				if (((401 + 1158) == (1611 - (33 + 19))) and v31) then
					return v31;
				end
			end
		end
		v111 = v109 > v89.ShiftingPower:CooldownRemains();
		v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (1 + 0)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((35 - 23) / v89.FireBlast:Cooldown()) % (1 + 0)))) and (v109 < v123);
		if ((not v95 and ((v109 <= (0 - 0)) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) or ((1643 + 109) <= (1477 - (586 + 103)))) then
			local v208 = 0 + 0;
			while true do
				if ((v208 == (0 - 0)) or ((5395 - (1309 + 179)) == (318 - 141))) then
					v31 = v147();
					if (((1511 + 1959) > (1490 - 935)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((not v113 and v89.SunKingsBlessing:IsAvailable()) or ((735 + 237) == (1370 - 725))) then
			v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((5 - 2) * v124));
		end
		if (((3791 - (295 + 314)) >= (5194 - 3079)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (1962 - (1300 + 662))) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
			if (((12224 - 8331) < (6184 - (1178 + 577))) and v23(v89.ShiftingPower, not v14:IsInRange(21 + 19), true)) then
				return "shifting_power main 12";
			end
		end
		if ((v125 < v99) or ((8475 - 5608) < (3310 - (851 + 554)))) then
			v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + 7 + 0) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
		end
		if ((v125 >= v99) or ((4980 - 3184) >= (8797 - 4746))) then
			v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
		end
		if (((1921 - (115 + 187)) <= (2877 + 879)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (0 + 0)) and (v125 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (1163 - (160 + 1001))))) then
			if (((529 + 75) == (417 + 187)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast main 14";
			end
		end
		if ((v119 and v132() and (v109 > (0 - 0))) or ((4842 - (237 + 121)) == (1797 - (525 + 372)))) then
			v31 = v149();
			if (v31 or ((8453 - 3994) <= (3656 - 2543))) then
				return v31;
			end
		end
		if (((3774 - (96 + 46)) > (4175 - (643 + 134))) and v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) then
			if (((1474 + 2608) <= (11789 - 6872)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
				return "fire_blast main 16";
			end
		end
		if (((17939 - 13107) >= (1330 + 56)) and (v109 > (0 - 0)) and v119) then
			v31 = v150();
			if (((279 - 142) == (856 - (316 + 403))) and v31) then
				return v31;
			end
		end
		if ((v89.IceNova:IsCastable() and not v134()) or ((1044 + 526) >= (11910 - 7578))) then
			if (v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova)) or ((1469 + 2595) <= (4580 - 2761))) then
				return "ice_nova main 18";
			end
		end
		if ((v89.Scorch:IsReady() and v46) or ((3534 + 1452) < (508 + 1066))) then
			if (((15335 - 10909) > (821 - 649)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
				return "scorch main 20";
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
		v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v64 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v65 = EpicSettings.Settings['mirrorImageHP'] or (17 - (12 + 5));
		v66 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v153()
		local v202 = 0 - 0;
		while true do
			if (((1245 - 659) > (1128 - 673)) and (v202 == (1 + 3))) then
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2799 - (1656 + 317)) == (737 + 89)) and (v202 == (2 + 0))) then
				v81 = EpicSettings.Settings['useRacials'];
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v202 = 7 - 4;
			end
			if ((v202 == (14 - 11)) or ((4373 - (5 + 349)) > (21094 - 16653))) then
				v76 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (1271 - (266 + 1005));
				v78 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v202 = 13 - 9;
			end
			if (((2655 - 638) < (5957 - (561 + 1135))) and (v202 == (0 - 0))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v75 = EpicSettings.Settings['useWeapon'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v202 = 1067 - (507 + 559);
			end
			if (((11833 - 7117) > (247 - 167)) and (v202 == (389 - (212 + 176)))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v67 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v202 = 907 - (250 + 655);
			end
		end
	end
	local function v154()
		local v203 = 0 - 0;
		while true do
			if ((v203 == (5 - 2)) or ((5486 - 1979) == (5228 - (1869 + 87)))) then
				if (v33 or ((3038 - 2162) >= (4976 - (484 + 1417)))) then
					local v230 = 0 - 0;
					while true do
						if (((7293 - 2941) > (3327 - (48 + 725))) and (v230 == (1 - 0))) then
							v127 = v29(v14:GetEnemiesInSplashRangeCount(13 - 8), #v129);
							v128 = #v129;
							break;
						end
						if ((v230 == (0 + 0)) or ((11774 - 7368) < (1132 + 2911))) then
							v125 = v29(v14:GetEnemiesInSplashRangeCount(2 + 3), #v129);
							v126 = v29(v14:GetEnemiesInSplashRangeCount(858 - (152 + 701)), #v129);
							v230 = 1312 - (430 + 881);
						end
					end
				else
					local v231 = 0 + 0;
					while true do
						if ((v231 == (896 - (557 + 338))) or ((559 + 1330) >= (9533 - 6150))) then
							v127 = 3 - 2;
							v128 = 2 - 1;
							break;
						end
						if (((4077 - 2185) <= (3535 - (499 + 302))) and (v231 == (866 - (39 + 827)))) then
							v125 = 2 - 1;
							v126 = 2 - 1;
							v231 = 3 - 2;
						end
					end
				end
				if (((2951 - 1028) < (190 + 2028)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
					if (((6360 - 4187) > (61 + 318)) and (v13:AffectingCombat() or v68)) then
						local v232 = v68 and v89.RemoveCurse:IsReady() and v35;
						v31 = v93.FocusUnit(v232, nil, 31 - 11, nil, 124 - (103 + 1), v89.ArcaneIntellect);
						if (v31 or ((3145 - (475 + 79)) == (7369 - 3960))) then
							return v31;
						end
					end
					v122 = v9.BossFightRemains(nil, true);
					v123 = v122;
					if (((14444 - 9930) > (430 + 2894)) and (v123 == (9779 + 1332))) then
						v123 = v9.FightRemains(v129, false);
					end
					v131 = v138(v129);
					v95 = not v34;
					if (v95 or ((1711 - (1395 + 108)) >= (14049 - 9221))) then
						v109 = 101203 - (7 + 1197);
					end
					v124 = v13:GCD();
					v118 = v13:BuffUp(v89.CombustionBuff);
					v119 = not v118;
				end
				if ((not v13:AffectingCombat() and v32) or ((691 + 892) > (1245 + 2322))) then
					v31 = v144();
					if (v31 or ((1632 - (27 + 292)) == (2326 - 1532))) then
						return v31;
					end
				end
				v203 = 4 - 0;
			end
			if (((13310 - 10136) > (5722 - 2820)) and (v203 == (1 - 0))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v203 = 141 - (43 + 96);
			end
			if (((16805 - 12685) <= (9631 - 5371)) and (v203 == (4 + 0))) then
				if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((250 + 633) > (9443 - 4665))) then
					if ((v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) or ((1388 + 2232) >= (9165 - 4274))) then
						if (((1341 + 2917) > (69 + 868)) and v23(v91.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if ((v68 and v35 and v89.RemoveCurse:IsAvailable()) or ((6620 - (1414 + 337)) < (2846 - (1642 + 298)))) then
						if (v15 or ((3193 - 1968) > (12163 - 7935))) then
							v31 = v142();
							if (((9875 - 6547) > (737 + 1501)) and v31) then
								return v31;
							end
						end
						if (((2987 + 852) > (2377 - (357 + 615))) and v17 and v17:Exists() and v17:IsAPlayer() and v93.UnitHasCurseDebuff(v17)) then
							if (v89.RemoveCurse:IsReady() or ((908 + 385) <= (1243 - 736))) then
								if (v23(v91.RemoveCurseMouseover) or ((2482 + 414) < (1725 - 920))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					v31 = v143();
					if (((1853 + 463) == (158 + 2158)) and v31) then
						return v31;
					end
					if (v69 or ((1616 + 954) == (2834 - (384 + 917)))) then
						if (v88 or ((1580 - (128 + 569)) == (3003 - (1407 + 136)))) then
							v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 1917 - (687 + 1200));
							if (v31 or ((6329 - (556 + 1154)) <= (3514 - 2515))) then
								return v31;
							end
						end
					end
					if (v70 or ((3505 - (9 + 86)) > (4537 - (275 + 146)))) then
						v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 5 + 25);
						if (v31 or ((967 - (29 + 35)) >= (13557 - 10498))) then
							return v31;
						end
					end
					if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) or ((11875 - 7899) < (12612 - 9755))) then
						if (((3212 + 1718) > (3319 - (53 + 959))) and v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v89.HotStreakBuff)) or ((4454 - (312 + 96)) < (2240 - 949))) then
						if (v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast)) or ((4526 - (147 + 138)) == (4444 - (813 + 86)))) then
							return "Stop Casting";
						end
					end
					if ((v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) or ((3659 + 389) > (7840 - 3608))) then
						if (v23(v89.IceFloes) or ((2242 - (18 + 474)) >= (1172 + 2301))) then
							return "ice_floes movement";
						end
					end
					if (((10333 - 7167) == (4252 - (860 + 226))) and v13:IsMoving() and not v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) then
						if (((2066 - (121 + 182)) < (459 + 3265)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
							return "scorch movement";
						end
					end
					v31 = v151();
					if (((1297 - (988 + 252)) <= (308 + 2415)) and v31) then
						return v31;
					end
				end
				break;
			end
			if ((v203 == (0 + 0)) or ((4040 - (49 + 1921)) == (1333 - (223 + 667)))) then
				v152();
				v153();
				v32 = EpicSettings.Toggles['ooc'];
				v203 = 53 - (51 + 1);
			end
			if ((v203 == (2 - 0)) or ((5792 - 3087) == (2518 - (146 + 979)))) then
				if (v13:IsDeadOrGhost() or ((1299 + 3302) < (666 - (311 + 294)))) then
					return v31;
				end
				v130 = v14:GetEnemiesInSplashRange(13 - 8);
				v129 = v13:GetEnemiesInRange(17 + 23);
				v203 = 1446 - (496 + 947);
			end
		end
	end
	local function v155()
		local v204 = 1358 - (1233 + 125);
		while true do
			if ((v204 == (0 + 0)) or ((1248 + 142) >= (902 + 3842))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(1708 - (963 + 682), v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

