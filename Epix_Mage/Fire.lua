local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((2271 - (1466 + 218)) > (1880 + 2209))) then
			return v6(...);
		end
		if ((v5 == (1148 - (556 + 592))) or ((1586 + 2872) < (1738 - (329 + 479)))) then
			v6 = v0[v4];
			if (((1516 - (174 + 680)) <= (3339 - 2367)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
		if (((3121 + 1249) == (5109 - (396 + 343))) and v90.RemoveCurse:IsAvailable()) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (1 + 3)) or (2476 - (29 + 1448));
	local v99 = 2388 - (135 + 1254);
	local v100 = v98;
	local v101 = ((11 - 8) * v28(v90.FueltheFire:IsAvailable())) + ((4664 - 3665) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 666 + 333;
	local v103 = 1567 - (389 + 1138);
	local v104 = 1573 - (102 + 472);
	local v105 = 0.3 + 0;
	local v106 = 0 + 0;
	local v107 = 6 + 0;
	local v108 = false;
	local v109 = (v108 and (1565 - (320 + 1225))) or (0 - 0);
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (0.4 + 0)) or (1465 - (157 + 1307));
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 1859 - (821 + 1038);
	local v116 = 0 - 0;
	local v117 = 1 + 7;
	local v118 = 4 - 1;
	local v119;
	local v120;
	local v121;
	local v122 = 2 + 1;
	local v123 = 27539 - 16428;
	local v124 = 12137 - (834 + 192);
	local v125;
	local v126, v127, v128, v129;
	local v130, v131;
	local v132;
	v10:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 + 0)) or ((103 + 4659) <= (1333 - 472))) then
				v108 = false;
				v109 = (v108 and (324 - (300 + 4))) or (0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v158 = 0 - 0;
		while true do
			if ((v158 == (362 - (112 + 250))) or ((563 + 849) == (10681 - 6417))) then
				v90.Pyroblast:RegisterInFlight();
				v90.Fireball:RegisterInFlight();
				v158 = 1 + 0;
			end
			if (((1 + 0) == v158) or ((2370 + 798) < (1068 + 1085))) then
				v90.Meteor:RegisterInFlightEffect(260854 + 90286);
				v90.Meteor:RegisterInFlight();
				v158 = 1416 - (1001 + 413);
			end
			if ((v158 == (6 - 3)) or ((5858 - (244 + 638)) < (2025 - (627 + 66)))) then
				v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
				v90.Fireball:RegisterInFlight(v90.CombustionBuff);
				break;
			end
			if (((13789 - 9161) == (5230 - (512 + 90))) and ((1908 - (1665 + 241)) == v158)) then
				v90.PhoenixFlames:RegisterInFlightEffect(258259 - (373 + 344));
				v90.PhoenixFlames:RegisterInFlight();
				v158 = 2 + 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(92909 + 258231);
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(679324 - 421782);
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		v123 = 18802 - 7691;
		v124 = 12210 - (35 + 1064);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (2 - 1)) or ((1 + 53) == (1631 - (298 + 938)))) then
				v100 = v98;
				v111 = ((v90.Kindling:IsAvailable()) and (1259.4 - (233 + 1026))) or (1667 - (636 + 1030));
				break;
			end
			if (((42 + 40) == (81 + 1)) and (v159 == (0 + 0))) then
				v97 = v90.SunKingsBlessing:IsAvailable();
				v98 = ((v90.FlamePatch:IsAvailable()) and (1 + 2)) or (1220 - (55 + 166));
				v159 = 1 + 0;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (10 + 80));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (343 - 253)) and v15:TimeToX(387 - (36 + 261))) or (0 - 0))) or (1368 - (34 + 1334));
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (12 + 18));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (24 + 6));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v160 = 1283 - (1035 + 248);
		local v161;
		while true do
			if ((v160 == (22 - (20 + 1))) or ((303 + 278) < (601 - (134 + 185)))) then
				return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or (v161 > (1133 - (549 + 584)))))));
			end
			if ((v160 == (685 - (314 + 371))) or ((15822 - 11213) < (3463 - (478 + 490)))) then
				v161 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (0 + 0);
				v161 = v161 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1173 - (786 + 386), v90.PhoenixFlames));
				v160 = 3 - 2;
			end
		end
	end
	local function v139(v162)
		local v163 = 1379 - (1055 + 324);
		local v164;
		while true do
			if (((2492 - (1093 + 247)) == (1024 + 128)) and (v163 == (0 + 0))) then
				v164 = 0 - 0;
				for v230, v231 in pairs(v162) do
					if (((6434 - 4538) <= (9737 - 6315)) and v231:DebuffUp(v90.IgniteDebuff)) then
						v164 = v164 + (2 - 1);
					end
				end
				v163 = 1 + 0;
			end
			if ((v163 == (3 - 2)) or ((3412 - 2422) > (1222 + 398))) then
				return v164;
			end
		end
	end
	local function v140()
		local v165 = 0 - 0;
		local v166;
		while true do
			if ((v165 == (688 - (364 + 324))) or ((2404 - 1527) > (11266 - 6571))) then
				v166 = 0 + 0;
				if (((11259 - 8568) >= (2964 - 1113)) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
					v166 = v166 + (2 - 1);
				end
				v165 = 1269 - (1249 + 19);
			end
			if ((v165 == (1 + 0)) or ((11619 - 8634) >= (5942 - (686 + 400)))) then
				return v166;
			end
		end
	end
	local function v141()
		local v167 = 0 + 0;
		while true do
			if (((4505 - (73 + 156)) >= (6 + 1189)) and ((812 - (721 + 90)) == v167)) then
				v32 = v94.HandleBottomTrinket(v93, v35, 1 + 39, nil);
				if (((10493 - 7261) <= (5160 - (224 + 246))) and v32) then
					return v32;
				end
				break;
			end
			if ((v167 == (0 - 0)) or ((1649 - 753) >= (571 + 2575))) then
				v32 = v94.HandleTopTrinket(v93, v35, 1 + 39, nil);
				if (((2249 + 812) >= (5880 - 2922)) and v32) then
					return v32;
				end
				v167 = 3 - 2;
			end
		end
	end
	local v142 = 513 - (203 + 310);
	local function v143()
		if (((5180 - (1238 + 755)) >= (45 + 599)) and v90.RemoveCurse:IsReady() and (v94.UnitHasDispellableDebuffByPlayer(v16) or v94.DispellableFriendlyUnit(1559 - (709 + 825)) or v94.UnitHasCurseDebuff(v16))) then
			local v183 = 0 - 0;
			while true do
				if (((937 - 293) <= (1568 - (196 + 668))) and (v183 == (0 - 0))) then
					if (((1984 - 1026) > (1780 - (171 + 662))) and (v142 == (93 - (4 + 89)))) then
						v142 = GetTime();
					end
					if (((15744 - 11252) >= (967 + 1687)) and v94.Wait(2196 - 1696, v142)) then
						local v241 = 0 + 0;
						while true do
							if (((4928 - (35 + 1451)) >= (2956 - (28 + 1425))) and (v241 == (1993 - (941 + 1052)))) then
								if (v24(v92.RemoveCurseFocus) or ((3040 + 130) <= (2978 - (822 + 692)))) then
									return "remove_curse dispel";
								end
								v142 = 0 - 0;
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
		local v168 = 0 + 0;
		while true do
			if (((300 - (45 + 252)) == v168) or ((4747 + 50) == (1511 + 2877))) then
				if (((1340 - 789) <= (1114 - (114 + 319))) and v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
					if (((4705 - 1428) > (521 - 114)) and v24(v90.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if (((2993 + 1702) >= (2108 - 693)) and v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) then
					if (v24(v92.Healthstone) or ((6729 - 3517) <= (2907 - (556 + 1407)))) then
						return "healthstone defensive";
					end
				end
				v168 = 1210 - (741 + 465);
			end
			if ((v168 == (469 - (170 + 295))) or ((1632 + 1464) <= (1652 + 146))) then
				if (((8708 - 5171) == (2933 + 604)) and v77 and (v14:HealthPercentage() <= v79)) then
					local v232 = 0 + 0;
					while true do
						if (((2173 + 1664) >= (2800 - (957 + 273))) and (v232 == (0 + 0))) then
							if ((v81 == "Refreshing Healing Potion") or ((1181 + 1769) == (14525 - 10713))) then
								if (((12446 - 7723) >= (7080 - 4762)) and v91.RefreshingHealingPotion:IsReady()) then
									if (v24(v92.RefreshingHealingPotion) or ((10037 - 8010) > (4632 - (389 + 1391)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v81 == "Dreamwalker's Healing Potion") or ((713 + 423) > (450 + 3867))) then
								if (((10809 - 6061) == (5699 - (783 + 168))) and v91.DreamwalkersHealingPotion:IsReady()) then
									if (((12538 - 8802) <= (4663 + 77)) and v24(v92.RefreshingHealingPotion)) then
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
			if ((v168 == (312 - (309 + 2))) or ((10410 - 7020) <= (4272 - (1090 + 122)))) then
				if ((v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) or ((324 + 675) > (9044 - 6351))) then
					if (((317 + 146) < (1719 - (628 + 490))) and v24(v90.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) or ((392 + 1791) < (1700 - 1013))) then
					if (((20788 - 16239) == (5323 - (431 + 343))) and v24(v90.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v168 = 3 - 1;
			end
			if (((13515 - 8843) == (3691 + 981)) and (v168 == (0 + 0))) then
				if ((v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) or ((5363 - (556 + 1139)) < (410 - (6 + 9)))) then
					if (v24(v90.BlazingBarrier) or ((763 + 3403) == (234 + 221))) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 171 - (28 + 141), v90.ArcaneIntellect)) or ((1724 + 2725) == (3286 - 623))) then
					if (v24(v90.MassBarrier) or ((3030 + 1247) < (4306 - (486 + 831)))) then
						return "mass_barrier defensive 2";
					end
				end
				v168 = 2 - 1;
			end
			if ((v168 == (6 - 4)) or ((165 + 705) >= (13118 - 8969))) then
				if (((3475 - (668 + 595)) < (2865 + 318)) and v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) then
					if (((937 + 3709) > (8159 - 5167)) and v24(v90.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if (((1724 - (23 + 267)) < (5050 - (1129 + 815))) and v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
					if (((1173 - (371 + 16)) < (4773 - (1326 + 424))) and v24(v90.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v168 = 5 - 2;
			end
		end
	end
	local function v145()
		if ((v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) or ((8923 - 6481) < (192 - (88 + 30)))) then
			if (((5306 - (720 + 51)) == (10088 - 5553)) and v24(v90.ArcaneIntellect)) then
				return "arcane_intellect precombat 2";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) or ((4785 - (421 + 1355)) <= (3472 - 1367))) then
			if (((899 + 931) < (4752 - (286 + 797))) and v24(v90.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) or ((5227 - 3797) >= (5982 - 2370))) then
			if (((3122 - (397 + 42)) >= (769 + 1691)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true)) then
				return "pyroblast precombat 4";
			end
		end
		if ((v90.Fireball:IsReady() and v41) or ((2604 - (24 + 776)) >= (5045 - 1770))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true) or ((2202 - (222 + 563)) > (7995 - 4366))) then
				return "fireball precombat 6";
			end
		end
	end
	local function v146()
		local v169 = 0 + 0;
		while true do
			if (((4985 - (23 + 167)) > (2200 - (690 + 1108))) and (v169 == (1 + 0))) then
				if (((3970 + 843) > (4413 - (40 + 808))) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (3 + 12))) and not v136() and (v134() == (0 - 0)) and not v90.TemperedFlames:IsAvailable()) then
					if (((3739 + 173) == (2070 + 1842)) and v24(v90.DragonsBreath, not v15:IsInRange(6 + 4))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((3392 - (47 + 524)) <= (3131 + 1693)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (41 - 26))) and not v136() and v90.TemperedFlames:IsAvailable()) then
					if (((2598 - 860) <= (5006 - 2811)) and v24(v90.DragonsBreath, not v15:IsInRange(1736 - (1165 + 561)))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if (((2 + 39) <= (9347 - 6329)) and (v169 == (0 + 0))) then
				if (((2624 - (341 + 138)) <= (1108 + 2996)) and v90.LivingBomb:IsReady() and v43 and (v128 > (1 - 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (326 - (89 + 237))))) then
					if (((8650 - 5961) < (10200 - 5355)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
						return "living_bomb active_talents 2";
					end
				end
				if ((v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (881 - (581 + 300))) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((1265 - (855 + 365)) < v110) or (v124 < v110))))) or ((5515 - 3193) > (857 + 1765))) then
					if (v24(v92.MeteorCursor, not v15:IsInRange(1275 - (1030 + 205))) or ((4257 + 277) == (1937 + 145))) then
						return "meteor active_talents 4";
					end
				end
				v169 = 287 - (156 + 130);
			end
		end
	end
	local function v147()
		local v170 = 0 - 0;
		local v171;
		while true do
			if (((0 - 0) == v170) or ((3217 - 1646) > (492 + 1375))) then
				v171 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (v171 or ((1548 + 1106) >= (3065 - (10 + 59)))) then
					return v171;
				end
				v170 = 1 + 0;
			end
			if (((19590 - 15612) > (3267 - (671 + 492))) and (v170 == (2 + 0))) then
				if (((4210 - (369 + 846)) > (408 + 1133)) and (v75 < v124)) then
					if (((2773 + 476) > (2898 - (1036 + 909))) and v83 and ((v35 and v84) or not v84)) then
						local v242 = 0 + 0;
						while true do
							if ((v242 == (0 - 0)) or ((3476 - (11 + 192)) > (2311 + 2262))) then
								v32 = v141();
								if (v32 or ((3326 - (135 + 40)) < (3110 - 1826))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v170 == (1 + 0)) or ((4075 - 2225) == (2291 - 762))) then
				if (((997 - (50 + 126)) < (5911 - 3788)) and v82 and ((v85 and v35) or not v85) and (v75 < v124)) then
					local v233 = 0 + 0;
					while true do
						if (((2315 - (1233 + 180)) < (3294 - (522 + 447))) and (v233 == (1421 - (107 + 1314)))) then
							if (((399 + 459) <= (9025 - 6063)) and v90.BloodFury:IsCastable()) then
								if (v24(v90.BloodFury) or ((1676 + 2270) < (2557 - 1269))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v90.Berserking:IsCastable() and v119) or ((12827 - 9585) == (2477 - (716 + 1194)))) then
								if (v24(v90.Berserking) or ((15 + 832) >= (136 + 1127))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v233 = 504 - (74 + 429);
						end
						if ((v233 == (1 - 0)) or ((1117 + 1136) == (4236 - 2385))) then
							if (v90.Fireblood:IsCastable() or ((1477 + 610) > (7312 - 4940))) then
								if (v24(v90.Fireblood) or ((10990 - 6545) < (4582 - (279 + 154)))) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (v90.AncestralCall:IsCastable() or ((2596 - (454 + 324)) == (67 + 18))) then
								if (((647 - (12 + 5)) < (1147 + 980)) and v24(v90.AncestralCall)) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if ((v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) or ((4937 - 2999) == (929 + 1585))) then
					if (((5348 - (277 + 816)) >= (234 - 179)) and v24(v90.TimeWarp, nil, nil, true)) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v170 = 1185 - (1058 + 125);
			end
		end
	end
	local function v148()
		if (((563 + 2436) > (2131 - (815 + 160))) and v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
			if (((10083 - 7733) > (2741 - 1586)) and v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((962 + 3067) <= (14186 - 9333)) and v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
			if (v24(v90.BagofTricks) or ((2414 - (41 + 1857)) > (5327 - (1222 + 671)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((10456 - 6410) >= (4358 - 1325)) and v90.LivingBomb:IsReady() and v34 and v43 and (v128 > (1183 - (229 + 953))) and v120) then
			if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((4493 - (1111 + 663)) <= (3026 - (874 + 705)))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (3 + 17)) or ((2821 + 1313) < (8160 - 4234))) then
			v32 = v147();
			if (v32 or ((5 + 159) >= (3464 - (642 + 37)))) then
				return v32;
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(7 + 23, 1 + 1) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((9 - 5) * v125)) and v14:BuffDown(v90.HotStreakBuff)) or ((979 - (233 + 221)) == (4876 - 2767))) then
			if (((30 + 3) == (1574 - (718 + 823))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v32 = v146();
		if (((1922 + 1132) <= (4820 - (266 + 539))) and v32) then
			return v32;
		end
		if (((5297 - 3426) < (4607 - (636 + 589))) and v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (0 - 0)) and v120 and (v110 <= (0 - 0)) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) then
			if (((1025 + 268) <= (787 + 1379)) and v24(v90.Combustion, not v15:IsInRange(1055 - (657 + 358)), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((10 - 6) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (1189 - (1151 + 36)))) or ((2491 + 88) < (33 + 90))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((2526 - 1680) >= (4200 - (1552 + 280)))) then
				return "fire_blast combustion_phase 12";
			end
		end
		if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v127 >= v101)) or ((4846 - (64 + 770)) <= (2280 + 1078))) then
			if (((3391 - 1897) <= (534 + 2471)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(1283 - (157 + 1086)), v14:BuffDown(v90.IceFloes))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((6226 - 3115) == (9346 - 7212))) then
			if (((3612 - 1257) == (3213 - 858)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v127 < (821 - (599 + 220))) and not v136()) or ((1170 - 582) <= (2363 - (1813 + 118)))) then
			if (((3507 + 1290) >= (5112 - (841 + 376))) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
				return "fireball combustion_phase 16";
			end
		end
		if (((5012 - 1435) == (831 + 2746)) and v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) then
			if (((10355 - 6561) > (4552 - (464 + 395))) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((10 - 6) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 + 0)))) < (839 - (467 + 370)))) or ((2634 - 1359) == (3010 + 1090))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((5453 - 3862) >= (559 + 3021))) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((2286 - 1303) <= (2328 - (150 + 370))) and v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v127 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v127 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1322 - (74 + 1208)), v14:BuffDown(v90.IceFloes)) or ((5288 - 3138) <= (5676 - 4479))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((2682 + 1087) >= (1563 - (14 + 376))) and v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) then
			if (((2575 - 1090) == (961 + 524)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) or ((2913 + 402) <= (2654 + 128))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((2566 - 1690) >= (2230 + 734))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(79 - (23 + 55), v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v127 < v100) and v119) or ((5289 - 3057) > (1667 + 830))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((1895 + 215) <= (514 - 182))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((1160 + 2526) > (4073 - (652 + 249))) and v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (0 - 0)) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v127)) then
			if (v24(v90.ShiftingPower, not v15:IsInRange(1908 - (708 + 1160))) or ((12144 - 7670) < (1495 - 675))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((4306 - (10 + 17)) >= (648 + 2234)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v127 >= v101)) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1772 - (1400 + 332)), v14:BuffDown(v90.IceFloes)) or ((3891 - 1862) >= (5429 - (242 + 1666)))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((872 + 1165) >= (1702 + 2940))) then
			if (((1466 + 254) < (5398 - (850 + 90))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((6 - 2) * v125)) and (v129 < v100)) or ((1826 - (360 + 1030)) > (2674 + 347))) then
			if (((2011 - 1298) <= (1165 - 318)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 36";
			end
		end
		if (((3815 - (909 + 752)) <= (5254 - (109 + 1114))) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(54 - 24, 1 + 1) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (244 - (6 + 236))) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((3 + 1) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v90.FlamesFuryBuff))) then
			if (((10884 - 6269) == (8061 - 3446)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) or ((4923 - (1076 + 57)) == (83 + 417))) then
			if (((778 - (579 + 110)) < (18 + 203)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
				return "fireball combustion_phase 40";
			end
		end
		if (((1817 + 237) >= (755 + 666)) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(437 - (174 + 233), 5 - 3) and (v90.PhoenixFlames:TravelTime() < v121) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (3 - 1)) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((2 + 2) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1175 - (663 + 511))) or v14:BuffUp(v90.FlamesFuryBuff))) then
			if (((618 + 74) < (664 + 2394)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) or ((10031 - 6777) == (1003 + 652))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((3050 - 1754) == (11886 - 6976))) then
				return "scorch combustion_phase 44";
			end
		end
		if (((1608 + 1760) == (6554 - 3186)) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) then
			if (((1884 + 759) < (349 + 3466)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((2635 - (478 + 244)) > (1010 - (440 + 77))) and v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v128 > (1 + 0))) then
			if (((17403 - 12648) > (4984 - (655 + 901))) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v149()
		local v172 = 0 + 0;
		while true do
			if (((1058 + 323) <= (1600 + 769)) and (v172 == (7 - 5))) then
				if ((v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) or ((6288 - (695 + 750)) == (13945 - 9861))) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (3 - 0) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v172 = 11 - 8;
			end
			if (((5020 - (285 + 66)) > (846 - 483)) and (v172 == (1310 - (682 + 628)))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v127 < v100)) + (v90.Flamestrike:CastTime() * v28(v127 >= v100))) - v105;
				v172 = 1 + 0;
			end
			if ((v172 == (300 - (176 + 123))) or ((786 + 1091) >= (2277 + 861))) then
				v110 = v115;
				if (((5011 - (239 + 30)) >= (986 + 2640)) and v90.Firestarter:IsAvailable() and not v97) then
					v110 = v30(v134(), v110);
				end
				v172 = 2 + 0;
			end
			if ((v172 == (4 - 1)) or ((14164 - 9624) == (1231 - (306 + 9)))) then
				if (((v115 + ((418 - 298) * ((1 + 0) - ((0.4 + 0 + ((0.2 + 0) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (57 - 37))) or ((2531 - (1140 + 235)) > (2766 + 1579))) then
					v110 = v115;
				end
				break;
			end
		end
	end
	local function v150()
		local v173 = 0 + 0;
		while true do
			if (((575 + 1662) < (4301 - (33 + 19))) and ((0 + 0) == v173)) then
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (2 - 1)) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (1 + 0)) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((3 - 1) * v125)))) or ((2516 + 167) < (712 - (586 + 103)))) then
					if (((64 + 633) <= (2542 - 1716)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((2593 - (1309 + 179)) <= (2122 - 946)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 + 0)) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(80 - 50, 2 + 0) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((3 - 1) * v125)))) then
					if (((6732 - 3353) <= (4421 - (295 + 314))) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v151()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (1964 - (1300 + 662))) or ((2474 - 1686) >= (3371 - (1178 + 577)))) then
				if (((963 + 891) <= (9988 - 6609)) and v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(1406 - (851 + 554), v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v127 < v98)) then
					if (((4023 + 526) == (12615 - 8066)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((8 - 4) * v125))) or ((3324 - (115 + 187)) >= (2316 + 708))) then
					if (((4564 + 256) > (8661 - 6463)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 19";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1163 - (160 + 1001)) * v125)))) or ((929 + 132) >= (3375 + 1516))) then
					if (((2791 - 1427) <= (4831 - (237 + 121))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v174 = 900 - (525 + 372);
			end
			if ((v174 == (10 - 4)) or ((11811 - 8216) <= (145 - (96 + 46)))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v127 >= v99)) or ((5449 - (643 + 134)) == (1391 + 2461))) then
					if (((3737 - 2178) == (5787 - 4228)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(39 + 1))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) or ((3438 - 1686) <= (1610 - 822))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((4626 - (316 + 403)) == (118 + 59))) then
						return "pyroblast standard_rotation 35";
					end
				end
				if (((9540 - 6070) > (201 + 354)) and v90.Fireball:IsReady() and v41 and not v138()) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((2447 - 1475) == (458 + 187))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((1026 + 2156) >= (7328 - 5213)) and (v174 == (19 - 15))) then
				if (((8087 - 4194) < (254 + 4175)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (0 - 0)) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (1.5 + 1)) or ((v90.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((20 - (12 + 5)) * v125)))))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((11135 - 8268) < (4064 - 2159))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (v32 or ((3817 - 2021) >= (10045 - 5994))) then
					return v32;
				end
				v174 = 2 + 3;
			end
			if (((3592 - (1656 + 317)) <= (3347 + 409)) and (v174 == (3 + 0))) then
				if (((1605 - 1001) == (2972 - 2368)) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(384 - (5 + 349), 9 - 7) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((1273 - (266 + 1005)) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((2955 + 1529) == (3070 - 2170))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) or ((5869 - 1410) <= (2809 - (561 + 1135)))) then
					if (((4732 - 1100) > (11169 - 7771)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 22";
					end
				end
				if (((5148 - (507 + 559)) <= (12338 - 7421)) and v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) then
					if (((14943 - 10111) >= (1774 - (212 + 176))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v174 = 909 - (250 + 655);
			end
			if (((373 - 236) == (238 - 101)) and (v174 == (1 - 0))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v127 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) or ((3526 - (1869 + 87)) >= (15025 - 10693))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1941 - (484 + 1417)), v14:BuffDown(v90.IceFloes)) or ((8710 - 4646) <= (3047 - 1228))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((778 - (48 + 725)) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) or ((8145 - 3159) < (4222 - 2648))) then
					if (((2573 + 1853) > (459 - 287)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 13";
					end
				end
				if (((164 + 422) > (133 + 322)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) then
					if (((1679 - (152 + 701)) == (2137 - (430 + 881))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 14";
					end
				end
				v174 = 1 + 1;
			end
			if ((v174 == (895 - (557 + 338))) or ((1188 + 2831) > (12514 - 8073))) then
				if (((7063 - 5046) < (11320 - 7059)) and v34 and v90.Flamestrike:IsReady() and v42 and (v127 >= v98) and v138()) then
					if (((10163 - 5447) > (881 - (499 + 302))) and v24(v92.FlamestrikeCursor, not v15:IsInRange(906 - (39 + 827)), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v138())) or ((9681 - 6174) == (7307 - 4035))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((3479 - 2603) >= (4720 - 1645))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((373 + 3979) > (7475 - 4921)) and v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and (((v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast)) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (1 + 2))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (0 - 0))))))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((4510 - (103 + 1)) < (4597 - (475 + 79)))) then
						return "fire_blast standard_rotation 6";
					end
				end
				v174 = 2 - 1;
			end
			if ((v174 == (16 - 11)) or ((245 + 1644) >= (2978 + 405))) then
				if (((3395 - (1395 + 108)) <= (7955 - 5221)) and v34 and v90.DragonsBreath:IsReady() and v39 and (v129 > (1205 - (7 + 1197))) and v90.AlexstraszasFury:IsAvailable()) then
					if (((839 + 1084) < (774 + 1444)) and v24(v90.DragonsBreath, not v15:IsInRange(329 - (27 + 292)))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if (((6367 - 4194) > (482 - 103)) and v90.Scorch:IsReady() and v47 and (v135())) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((10866 - 8275) == (6722 - 3313))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((8596 - 4082) > (3463 - (43 + 96))) and v34 and v90.ArcaneExplosion:IsReady() and v37 and (v131 >= v102) and (v14:ManaPercentageP() >= v103)) then
					if (v24(v90.ArcaneExplosion, not v15:IsInRange(32 - 24)) or ((470 - 262) >= (4007 + 821))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v174 = 2 + 4;
			end
		end
	end
	local function v152()
		local v175 = 0 - 0;
		while true do
			if (((1 + 1) == v175) or ((2966 - 1383) > (1123 + 2444))) then
				if ((not v114 and v90.SunKingsBlessing:IsAvailable()) or ((97 + 1216) == (2545 - (1414 + 337)))) then
					v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((1943 - (1642 + 298)) * v125));
				end
				if (((8274 - 5100) > (8348 - 5446)) and v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (0 - 0)) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) then
					if (((1356 + 2764) <= (3315 + 945)) and v24(v90.ShiftingPower, not v15:IsInRange(990 - (357 + 615)), true)) then
						return "shifting_power main 12";
					end
				end
				if ((v127 < v100) or ((620 + 263) > (11723 - 6945))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + 6 + 1) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				v175 = 6 - 3;
			end
			if (((0 + 0) == v175) or ((246 + 3374) >= (3075 + 1816))) then
				if (((5559 - (384 + 917)) > (1634 - (128 + 569))) and not v96) then
					v149();
				end
				if ((v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (1583 - (1407 + 136))))) or ((6756 - (687 + 1200)) < (2616 - (556 + 1154)))) then
					if (v24(v90.TimeWarp, not v15:IsInRange(140 - 100)) or ((1320 - (9 + 86)) > (4649 - (275 + 146)))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((542 + 2786) > (2302 - (29 + 35))) and (v75 < v124)) then
					if (((17014 - 13175) > (4196 - 2791)) and v83 and ((v35 and v84) or not v84)) then
						local v243 = 0 - 0;
						while true do
							if ((v243 == (0 + 0)) or ((2305 - (53 + 959)) <= (915 - (312 + 96)))) then
								v32 = v141();
								if (v32 or ((5026 - 2130) < (1090 - (147 + 138)))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				v175 = 900 - (813 + 86);
			end
			if (((2093 + 223) == (4290 - 1974)) and ((493 - (18 + 474)) == v175)) then
				v112 = v110 > v90.ShiftingPower:CooldownRemains();
				v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (1 + 0)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((39 - 27) / v90.FireBlast:Cooldown()) % (1087 - (860 + 226))))) and (v110 < v124);
				if ((not v96 and ((v110 <= (303 - (121 + 182))) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) or ((317 + 2253) == (2773 - (988 + 252)))) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (0 + 0)) or ((2853 - (49 + 1921)) == (2350 - (223 + 667)))) then
							v32 = v148();
							if (v32 or ((4671 - (51 + 1)) <= (1718 - 719))) then
								return v32;
							end
							break;
						end
					end
				end
				v175 = 3 - 1;
			end
			if ((v175 == (1130 - (146 + 979))) or ((963 + 2447) > (4721 - (311 + 294)))) then
				if ((v90.Scorch:IsReady() and v47) or ((2518 - 1615) >= (1296 + 1763))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((5419 - (496 + 947)) < (4215 - (1233 + 125)))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((2001 + 2929) > (2070 + 237)) and (v175 == (1 + 3))) then
				if ((v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) or ((5691 - (963 + 682)) < (1078 + 213))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((5745 - (504 + 1000)) == (2388 + 1157))) then
						return "fire_blast main 16";
					end
				end
				if (((v110 > (0 + 0)) and v120) or ((382 + 3666) > (6239 - 2007))) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (0 + 0)) or ((1932 - (156 + 26)) >= (2001 + 1472))) then
							v32 = v151();
							if (((4952 - 1786) == (3330 - (149 + 15))) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				if (((2723 - (890 + 70)) < (3841 - (39 + 78))) and v90.IceNova:IsCastable() and not v135()) then
					if (((539 - (14 + 468)) <= (5987 - 3264)) and v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v175 = 13 - 8;
			end
			if ((v175 == (2 + 1)) or ((1244 + 826) == (95 + 348))) then
				if ((v127 >= v100) or ((1222 + 1483) == (365 + 1028))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 - 0)) and (v127 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v90.FireBlast:ChargesFractional() >= (6 - 4)))) or ((117 + 4484) < (112 - (12 + 39)))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((1294 + 96) >= (14684 - 9940))) then
						return "fire_blast main 14";
					end
				end
				if ((v120 and v133() and (v110 > (0 - 0))) or ((594 + 1409) > (2019 + 1815))) then
					local v236 = 0 - 0;
					while true do
						if (((0 + 0) == v236) or ((753 - 597) > (5623 - (1596 + 114)))) then
							v32 = v150();
							if (((508 - 313) == (908 - (164 + 549))) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v175 = 1442 - (1059 + 379);
			end
		end
	end
	local function v153()
		local v176 = 0 - 0;
		while true do
			if (((1610 + 1495) >= (303 + 1493)) and ((396 - (145 + 247)) == v176)) then
				v57 = EpicSettings.Settings['useIceBlock'];
				v58 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v59 = EpicSettings.Settings['useMirrorImage'];
				v61 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v176 = 3 + 2;
			end
			if (((12982 - 8603) >= (409 + 1722)) and ((1 + 0) == v176)) then
				v42 = EpicSettings.Settings['useFlamestrike'];
				v43 = EpicSettings.Settings['useLivingBomb'];
				v44 = EpicSettings.Settings['useMeteor'];
				v45 = EpicSettings.Settings['usePhoenixFlames'];
				v46 = EpicSettings.Settings['usePyroblast'];
				v176 = 2 - 0;
			end
			if (((4564 - (254 + 466)) >= (2603 - (544 + 16))) and (v176 == (9 - 6))) then
				v52 = EpicSettings.Settings['combustionWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['useAlterTime'];
				v55 = EpicSettings.Settings['useBlazingBarrier'];
				v56 = EpicSettings.Settings['useGreaterInvisibility'];
				v176 = 632 - (294 + 334);
			end
			if (((258 - (236 + 17)) == v176) or ((1394 + 1838) <= (2126 + 605))) then
				v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
				v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v64 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v65 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v66 = EpicSettings.Settings['mirrorImageHP'] or (794 - (413 + 381));
				v176 = 1 + 5;
			end
			if (((10431 - 5526) == (12741 - 7836)) and ((1972 - (582 + 1388)) == v176)) then
				v47 = EpicSettings.Settings['useScorch'];
				v48 = EpicSettings.Settings['useCounterspell'];
				v49 = EpicSettings.Settings['useBlastWave'];
				v50 = EpicSettings.Settings['useCombustion'];
				v51 = EpicSettings.Settings['useShiftingPower'];
				v176 = 4 - 1;
			end
			if ((v176 == (0 + 0)) or ((4500 - (326 + 38)) >= (13048 - 8637))) then
				v37 = EpicSettings.Settings['useArcaneExplosion'];
				v38 = EpicSettings.Settings['useArcaneIntellect'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFireball'];
				v176 = 1 - 0;
			end
			if ((v176 == (626 - (47 + 573))) or ((1043 + 1915) == (17060 - 13043))) then
				v67 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v86 = EpicSettings.Settings['mirrorImageBeforePull'];
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v154()
		local v177 = 1664 - (1269 + 395);
		while true do
			if (((1720 - (76 + 416)) >= (1256 - (319 + 124))) and (v177 == (0 - 0))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (1007 - (564 + 443));
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v177 = 2 - 1;
			end
			if ((v177 == (462 - (337 + 121))) or ((10123 - 6668) > (13491 - 9441))) then
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2154 - (1261 + 650)) == (103 + 140)) and (v177 == (1 - 0))) then
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v177 = 1819 - (772 + 1045);
			end
			if ((v177 == (1 + 2)) or ((415 - (102 + 42)) > (3416 - (1524 + 320)))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (1270 - (1049 + 221));
				v79 = EpicSettings.Settings['healingPotionHP'] or (156 - (18 + 138));
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v177 = 9 - 5;
			end
			if (((3841 - (67 + 1035)) < (3641 - (136 + 212))) and ((8 - 6) == v177)) then
				v82 = EpicSettings.Settings['useRacials'];
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v177 = 3 + 0;
			end
		end
	end
	local function v155()
		local v178 = 0 + 0;
		while true do
			if ((v178 == (1604 - (240 + 1364))) or ((5024 - (1050 + 32)) < (4048 - 2914))) then
				v153();
				v154();
				v33 = EpicSettings.Toggles['ooc'];
				v178 = 1 + 0;
			end
			if (((1058 - (331 + 724)) == v178) or ((218 + 2475) == (5617 - (269 + 375)))) then
				if (((2871 - (267 + 458)) == (668 + 1478)) and v34) then
					v127 = v30(v15:GetEnemiesInSplashRangeCount(9 - 4), #v130);
					v128 = v30(v15:GetEnemiesInSplashRangeCount(823 - (667 + 151)), #v130);
					v129 = v30(v15:GetEnemiesInSplashRangeCount(1502 - (1410 + 87)), #v130);
					v131 = #v130;
				else
					local v237 = 1897 - (1504 + 393);
					while true do
						if ((v237 == (2 - 1)) or ((5821 - 3577) == (4020 - (461 + 335)))) then
							v129 = 1 + 0;
							v131 = 1762 - (1730 + 31);
							break;
						end
						if ((v237 == (1667 - (728 + 939))) or ((17368 - 12464) <= (3885 - 1969))) then
							v127 = 2 - 1;
							v128 = 1069 - (138 + 930);
							v237 = 1 + 0;
						end
					end
				end
				if (((71 + 19) <= (913 + 152)) and (v94.TargetIsValid() or v14:AffectingCombat())) then
					local v238 = 0 - 0;
					while true do
						if (((6568 - (459 + 1307)) == (6672 - (474 + 1396))) and (v238 == (6 - 2))) then
							v119 = v14:BuffUp(v90.CombustionBuff);
							v120 = not v119;
							break;
						end
						if ((v238 == (1 + 0)) or ((8 + 2272) <= (1463 - 952))) then
							v124 = v123;
							if ((v124 == (1408 + 9703)) or ((5594 - 3918) <= (2019 - 1556))) then
								v124 = v10.FightRemains(v130, false);
							end
							v238 = 593 - (562 + 29);
						end
						if (((3299 + 570) == (5288 - (374 + 1045))) and (v238 == (3 + 0))) then
							if (((3595 - 2437) <= (3251 - (448 + 190))) and v96) then
								v110 = 32284 + 67715;
							end
							v125 = v14:GCD();
							v238 = 2 + 2;
						end
						if ((v238 == (2 + 0)) or ((9089 - 6725) <= (6211 - 4212))) then
							UnitsWithIgniteCount = v139(v130);
							v96 = not v35;
							v238 = 1497 - (1307 + 187);
						end
						if ((v238 == (0 - 0)) or ((11524 - 6602) < (594 - 400))) then
							if (v14:AffectingCombat() or v69 or ((2774 - (232 + 451)) < (30 + 1))) then
								local v244 = 0 + 0;
								local v245;
								while true do
									if ((v244 == (564 - (510 + 54))) or ((4895 - 2465) >= (4908 - (13 + 23)))) then
										v245 = v69 and v90.RemoveCurse:IsReady() and v36;
										v32 = v94.FocusUnit(v245, nil, 38 - 18, nil, 28 - 8, v90.ArcaneIntellect);
										v244 = 1 - 0;
									end
									if ((v244 == (1089 - (830 + 258))) or ((16826 - 12056) < (1086 + 649))) then
										if (v32 or ((3777 + 662) <= (3791 - (860 + 581)))) then
											return v32;
										end
										break;
									end
								end
							end
							v123 = v10.BossFightRemains(nil, true);
							v238 = 3 - 2;
						end
					end
				end
				if ((not v14:AffectingCombat() and v33) or ((3555 + 924) < (4707 - (237 + 4)))) then
					local v239 = 0 - 0;
					while true do
						if (((6444 - 3897) > (2322 - 1097)) and (v239 == (0 + 0))) then
							v32 = v145();
							if (((2683 + 1988) > (10095 - 7421)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v178 = 2 + 2;
			end
			if ((v178 == (2 + 0)) or ((5122 - (85 + 1341)) < (5676 - 2349))) then
				if (v14:IsDeadOrGhost() or ((12827 - 8285) == (3342 - (45 + 327)))) then
					return v32;
				end
				v126 = v15:GetEnemiesInSplashRange(9 - 4);
				v130 = v14:GetEnemiesInRange(542 - (444 + 58));
				v178 = 2 + 1;
			end
			if (((44 + 208) <= (967 + 1010)) and (v178 == (11 - 7))) then
				if ((v14:AffectingCombat() and v94.TargetIsValid()) or ((3168 - (64 + 1668)) == (5748 - (1227 + 746)))) then
					local v240 = 0 - 0;
					while true do
						if ((v240 == (1 - 0)) or ((2112 - (415 + 79)) < (24 + 906))) then
							if (((5214 - (142 + 349)) > (1780 + 2373)) and v32) then
								return v32;
							end
							if (v70 or ((5023 - 1369) >= (2313 + 2341))) then
								if (((671 + 280) <= (4073 - 2577)) and v89) then
									local v248 = 1864 - (1710 + 154);
									while true do
										if ((v248 == (318 - (200 + 118))) or ((688 + 1048) == (998 - 427))) then
											v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 44 - 14);
											if (v32 or ((797 + 99) > (4718 + 51))) then
												return v32;
											end
											break;
										end
									end
								end
							end
							if (v71 or ((561 + 484) <= (163 + 857))) then
								local v246 = 0 - 0;
								while true do
									if ((v246 == (1250 - (363 + 887))) or ((2025 - 865) <= (1561 - 1233))) then
										v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseover, 5 + 25);
										if (((8910 - 5102) > (1998 + 926)) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							v240 = 1666 - (674 + 990);
						end
						if (((1116 + 2775) < (2014 + 2905)) and (v240 == (2 - 0))) then
							if ((v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) or ((3289 - (507 + 548)) <= (2339 - (289 + 548)))) then
								if (v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal)) or ((4330 - (821 + 997)) < (687 - (195 + 60)))) then
									return "spellsteal damage";
								end
							end
							if (((v14:IsCasting(v90.Pyroblast) or v14:IsChanneling(v90.Pyroblast) or v14:IsCasting(v90.Flamestrike) or v14:IsChanneling(v90.Flamestrike)) and v14:BuffUp(v90.HotStreakBuff)) or ((497 + 1351) == (2366 - (251 + 1250)))) then
								if (v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast), false, true) or ((13716 - 9034) <= (3121 + 1420))) then
									return "Stop Casting";
								end
							end
							if ((v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes) and not v14:PrevOffGCDP(1033 - (809 + 223), v90.IceFloes)) or ((4415 - 1389) >= (12150 - 8104))) then
								if (((6639 - 4631) > (470 + 168)) and v24(v90.IceFloes)) then
									return "ice_floes movement";
								end
							end
							v240 = 2 + 1;
						end
						if (((2392 - (14 + 603)) <= (3362 - (118 + 11))) and ((1 + 2) == v240)) then
							v32 = v152();
							if (v32 or ((3784 + 759) == (5819 - 3822))) then
								return v32;
							end
							break;
						end
						if ((v240 == (949 - (551 + 398))) or ((1961 + 1141) < (260 + 468))) then
							if (((281 + 64) == (1283 - 938)) and v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) then
								if (v24(v92.UseWeapon, nil) or ((6513 - 3686) < (123 + 255))) then
									return "Using Weapon Macro";
								end
							end
							if ((v69 and v36 and v90.RemoveCurse:IsAvailable()) or ((13799 - 10323) < (718 + 1879))) then
								local v247 = 89 - (40 + 49);
								while true do
									if (((11725 - 8646) < (5284 - (99 + 391))) and ((0 + 0) == v247)) then
										if (((21337 - 16483) > (11054 - 6590)) and v16) then
											local v249 = 0 + 0;
											while true do
												if ((v249 == (0 - 0)) or ((6516 - (1032 + 572)) == (4175 - (203 + 214)))) then
													v32 = v143();
													if (((1943 - (568 + 1249)) <= (2724 + 758)) and v32) then
														return v32;
													end
													break;
												end
											end
										end
										if ((v18 and v18:Exists() and not v14:CanAttack(v18) and v94.UnitHasCurseDebuff(v18)) or ((5701 - 3327) == (16894 - 12520))) then
											if (((2881 - (913 + 393)) == (4447 - 2872)) and v90.RemoveCurse:IsReady()) then
												if (v24(v92.RemoveCurseMouseover) or ((3156 - 922) == (1865 - (269 + 141)))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							v32 = v144();
							v240 = 2 - 1;
						end
					end
				end
				break;
			end
			if ((v178 == (1982 - (362 + 1619))) or ((2692 - (950 + 675)) > (686 + 1093))) then
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v178 = 1181 - (216 + 963);
			end
		end
	end
	local function v156()
		local v179 = 1287 - (485 + 802);
		while true do
			if (((2720 - (432 + 127)) >= (2007 - (1065 + 8))) and (v179 == (0 + 0))) then
				v95();
				v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1664 - (635 + 966), v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

