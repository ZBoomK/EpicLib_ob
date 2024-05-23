local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((5851 - 3664) >= (5494 - (133 + 407)))) then
			v6 = v0[v4];
			if (not v6 or ((6123 - 2246) == (5206 - 1631))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((2501 - 1794) > (305 + 327)) and (v5 == (797 - (588 + 208)))) then
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
	local v89;
	local v90 = v19.Mage.Fire;
	local v91 = v21.Mage.Fire;
	local v92 = v26.Mage.Fire;
	local v93 = {};
	local v94 = v22.Commons.Everyone;
	local function v95()
		if (v90.RemoveCurse:IsAvailable() or ((1471 - 925) >= (4484 - (884 + 916)))) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (8 - 4)) or (580 + 419);
	local v99 = 1652 - (232 + 421);
	local v100 = v98;
	local v101 = ((1892 - (1569 + 320)) * v28(v90.FueltheFire:IsAvailable())) + ((246 + 753) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 190 + 809;
	local v103 = 134 - 94;
	local v104 = 1604 - (316 + 289);
	local v105 = 0.3 - 0;
	local v106 = 0 + 0;
	local v107 = 1459 - (666 + 787);
	local v108 = false;
	local v109 = (v108 and (445 - (360 + 65))) or (0 + 0);
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (254.4 - (79 + 175))) or (1 - 0);
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 15 - 7;
	local v118 = 902 - (503 + 396);
	local v119;
	local v120;
	local v121 = v14:BuffRemains(v90.CombustionBuff);
	local v122 = 184 - (92 + 89);
	local v123 = 21554 - 10443;
	local v124 = 5699 + 5412;
	local v125;
	local v126, v127, v128, v129;
	local v130, v131;
	local v132;
	v10:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if (((5737 - 4272) <= (589 + 3712)) and (v157 == (0 - 0))) then
				v108 = false;
				v109 = (v108 and (18 + 2)) or (0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v158 = 0 - 0;
		while true do
			if (((213 + 1491) > (2173 - 748)) and (v158 == (1244 - (485 + 759)))) then
				v90.Pyroblast:RegisterInFlight();
				v90.Fireball:RegisterInFlight();
				v158 = 2 - 1;
			end
			if ((v158 == (1192 - (442 + 747))) or ((1822 - (832 + 303)) == (5180 - (88 + 858)))) then
				v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
				v90.Fireball:RegisterInFlight(v90.CombustionBuff);
				break;
			end
			if ((v158 == (1 + 1)) or ((2756 + 574) < (59 + 1370))) then
				v90.PhoenixFlames:RegisterInFlightEffect(258331 - (766 + 23));
				v90.PhoenixFlames:RegisterInFlight();
				v158 = 14 - 11;
			end
			if (((1568 - 421) >= (882 - 547)) and (v158 == (3 - 2))) then
				v90.Meteor:RegisterInFlightEffect(352213 - (1036 + 37));
				v90.Meteor:RegisterInFlight();
				v158 = 2 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(683806 - 332666);
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(202591 + 54951);
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		local v159 = 1480 - (641 + 839);
		while true do
			if (((4348 - (910 + 3)) > (5345 - 3248)) and (v159 == (1684 - (1466 + 218)))) then
				v123 = 5107 + 6004;
				v124 = 12259 - (556 + 592);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v160 = 0 + 0;
		while true do
			if ((v160 == (809 - (329 + 479))) or ((4624 - (174 + 680)) >= (13885 - 9844))) then
				v100 = v98;
				v111 = ((v90.Kindling:IsAvailable()) and (0.4 - 0)) or (1 + 0);
				break;
			end
			if ((v160 == (739 - (396 + 343))) or ((336 + 3455) <= (3088 - (29 + 1448)))) then
				v97 = v90.SunKingsBlessing:IsAvailable();
				v98 = ((v90.FlamePatch:IsAvailable()) and (1392 - (135 + 1254))) or (3763 - 2764);
				v160 = 4 - 3;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (60 + 30));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (1617 - (389 + 1138))) and v15:TimeToX(664 - (102 + 472))) or (0 + 0))) or (0 + 0);
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (28 + 2));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (1575 - (320 + 1225)));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v161 = 0 - 0;
		local v162;
		while true do
			if ((v161 == (0 + 0)) or ((6042 - (157 + 1307)) <= (3867 - (821 + 1038)))) then
				v162 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (0 - 0);
				v162 = v162 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1 + 0, v90.PhoenixFlames));
				v161 = 1 - 0;
			end
			if (((419 + 706) <= (5145 - 3069)) and (v161 == (1027 - (834 + 192)))) then
				return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or (v162 > (0 + 0))))));
			end
		end
	end
	local function v139(v163)
		local v164 = 0 + 0;
		local v165;
		while true do
			if ((v164 == (0 + 0)) or ((1150 - 407) >= (4703 - (300 + 4)))) then
				v165 = 0 + 0;
				for v234, v235 in pairs(v163) do
					if (((3023 - 1868) < (2035 - (112 + 250))) and v235:DebuffUp(v90.IgniteDebuff)) then
						v165 = v165 + 1 + 0;
					end
				end
				v164 = 2 - 1;
			end
			if ((v164 == (1 + 0)) or ((1202 + 1122) <= (433 + 145))) then
				return v165;
			end
		end
	end
	local function v140()
		local v166 = 0 + 0;
		local v167;
		while true do
			if (((2799 + 968) == (5181 - (1001 + 413))) and (v166 == (0 - 0))) then
				v167 = 882 - (244 + 638);
				if (((4782 - (627 + 66)) == (12183 - 8094)) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
					v167 = v167 + (603 - (512 + 90));
				end
				v166 = 1907 - (1665 + 241);
			end
			if (((5175 - (373 + 344)) >= (756 + 918)) and ((1 + 0) == v166)) then
				return v167;
			end
		end
	end
	local function v141()
		v32 = v94.HandleTopTrinket(v93, v35, 105 - 65, nil);
		if (((1644 - 672) <= (2517 - (35 + 1064))) and v32) then
			return v32;
		end
		v32 = v94.HandleBottomTrinket(v93, v35, 30 + 10, nil);
		if (v32 or ((10564 - 5626) < (20 + 4742))) then
			return v32;
		end
	end
	local v142 = 1236 - (298 + 938);
	local function v143()
		if ((v90.RemoveCurse:IsReady() and (v94.UnitHasDispellableDebuffByPlayer(v16) or v94.DispellableFriendlyUnit(1279 - (233 + 1026)) or v94.UnitHasCurseDebuff(v16))) or ((4170 - (636 + 1030)) > (2181 + 2083))) then
			local v187 = 0 + 0;
			while true do
				if (((640 + 1513) == (146 + 2007)) and (v187 == (221 - (55 + 166)))) then
					if ((v142 == (0 + 0)) or ((51 + 456) >= (9895 - 7304))) then
						v142 = GetTime();
					end
					if (((4778 - (36 + 261)) == (7836 - 3355)) and v94.Wait(1868 - (34 + 1334), v142)) then
						if (v24(v92.RemoveCurseFocus) or ((895 + 1433) < (539 + 154))) then
							return "remove_curse dispel";
						end
						v142 = 1283 - (1035 + 248);
					end
					break;
				end
			end
		end
	end
	local function v144()
		local v168 = 21 - (20 + 1);
		while true do
			if (((2255 + 2073) == (4647 - (134 + 185))) and (v168 == (1136 - (549 + 584)))) then
				if (((2273 - (314 + 371)) >= (4572 - 3240)) and v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
					if (v24(v90.AlterTime) or ((5142 - (478 + 490)) > (2251 + 1997))) then
						return "alter_time defensive 6";
					end
				end
				if ((v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) or ((5758 - (786 + 386)) <= (265 - 183))) then
					if (((5242 - (1055 + 324)) == (5203 - (1093 + 247))) and v24(v92.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v168 = 4 + 0;
			end
			if ((v168 == (1 + 3)) or ((1119 - 837) <= (142 - 100))) then
				if (((13114 - 8505) >= (1924 - 1158)) and v77 and (v14:HealthPercentage() <= v79)) then
					local v236 = 0 + 0;
					while true do
						if ((v236 == (0 - 0)) or ((3970 - 2818) == (1877 + 611))) then
							if (((8751 - 5329) > (4038 - (364 + 324))) and (v81 == "Refreshing Healing Potion")) then
								if (((2404 - 1527) > (901 - 525)) and v91.RefreshingHealingPotion:IsReady()) then
									if (v24(v92.RefreshingHealingPotion) or ((1034 + 2084) <= (7745 - 5894))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v81 == "Dreamwalker's Healing Potion") or ((264 - 99) >= (10605 - 7113))) then
								if (((5217 - (1249 + 19)) < (4384 + 472)) and v91.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v92.RefreshingHealingPotion) or ((16644 - 12368) < (4102 - (686 + 400)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v236 = 1 + 0;
						end
						if (((4919 - (73 + 156)) > (20 + 4105)) and (v236 == (812 - (721 + 90)))) then
							if ((v81 == "Potion of Withering Dreams") or ((1 + 49) >= (2909 - 2013))) then
								if (v91.PotionOfWitheringDreams:IsReady() or ((2184 - (224 + 246)) >= (4791 - 1833))) then
									if (v24(v92.RefreshingHealingPotion) or ((2745 - 1254) < (117 + 527))) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((17 + 687) < (725 + 262)) and ((3 - 1) == v168)) then
				if (((12372 - 8654) > (2419 - (203 + 310))) and v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) then
					if (v24(v90.MirrorImage) or ((2951 - (1238 + 755)) > (254 + 3381))) then
						return "mirror_image defensive 4";
					end
				end
				if (((5035 - (709 + 825)) <= (8277 - 3785)) and v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
					if (v24(v90.GreaterInvisibility) or ((5013 - 1571) < (3412 - (196 + 668)))) then
						return "greater_invisibility defensive 5";
					end
				end
				v168 = 11 - 8;
			end
			if (((5955 - 3080) >= (2297 - (171 + 662))) and (v168 == (94 - (4 + 89)))) then
				if ((v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) or ((16813 - 12016) >= (1782 + 3111))) then
					if (v24(v90.IceBlock) or ((2420 - 1869) > (811 + 1257))) then
						return "ice_block defensive 3";
					end
				end
				if (((3600 - (35 + 1451)) > (2397 - (28 + 1425))) and v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) then
					if (v24(v90.IceColdAbility) or ((4255 - (941 + 1052)) >= (2969 + 127))) then
						return "ice_cold defensive 3";
					end
				end
				v168 = 1516 - (822 + 692);
			end
			if ((v168 == (0 - 0)) or ((1063 + 1192) >= (3834 - (45 + 252)))) then
				if ((v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) or ((3797 + 40) < (450 + 856))) then
					if (((7179 - 4229) == (3383 - (114 + 319))) and v24(v90.BlazingBarrier)) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 2 - 0, v90.ArcaneIntellect)) or ((6051 - 1328) < (2103 + 1195))) then
					if (((1692 - 556) >= (322 - 168)) and v24(v90.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v168 = 1964 - (556 + 1407);
			end
		end
	end
	local function v145()
		local v169 = 1206 - (741 + 465);
		while true do
			if (((466 - (170 + 295)) == v169) or ((143 + 128) > (4362 + 386))) then
				if (((11670 - 6930) >= (2613 + 539)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((1654 + 924) >= (1920 + 1470))) then
						return "pyroblast precombat 4";
					end
				end
				if (((1271 - (957 + 273)) <= (445 + 1216)) and v90.Fireball:IsReady() and v41) then
					if (((241 + 360) < (13565 - 10005)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if (((619 - 384) < (2098 - 1411)) and ((0 - 0) == v169)) then
				if (((6329 - (389 + 1391)) > (724 + 429)) and v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) then
					if (v24(v90.ArcaneIntellect) or ((487 + 4187) < (10635 - 5963))) then
						return "arcane_intellect precombat 2";
					end
				end
				if (((4619 - (783 + 168)) < (15307 - 10746)) and v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) then
					if (v24(v90.MirrorImage) or ((448 + 7) == (3916 - (309 + 2)))) then
						return "mirror_image precombat 2";
					end
				end
				v169 = 2 - 1;
			end
		end
	end
	local function v146()
		local v170 = 1212 - (1090 + 122);
		while true do
			if ((v170 == (1 + 0)) or ((8943 - 6280) == (2267 + 1045))) then
				if (((5395 - (628 + 490)) <= (803 + 3672)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (37 - 22))) and not v136() and (v134() == (0 - 0)) and not v90.TemperedFlames:IsAvailable()) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(784 - (431 + 343))) or ((1757 - 887) == (3439 - 2250))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((1227 + 326) <= (401 + 2732)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (1710 - (556 + 1139)))) and not v136() and v90.TemperedFlames:IsAvailable()) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(25 - (6 + 9))) or ((410 + 1827) >= (1799 + 1712))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v170 == (169 - (28 + 141))) or ((513 + 811) > (3727 - 707))) then
				if ((v90.LivingBomb:IsReady() and v43 and (v128 > (1 + 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (1317 - (486 + 831))))) or ((7785 - 4793) == (6622 - 4741))) then
					if (((587 + 2519) > (4824 - 3298)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((4286 - (668 + 595)) < (3483 + 387)) and v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (0 + 0)) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((122 - 77) < v110) or (v124 < v110))))) then
					if (((433 - (23 + 267)) > (2018 - (1129 + 815))) and v24(v92.MeteorCursor, not v15:IsInRange(427 - (371 + 16)))) then
						return "meteor active_talents 4";
					end
				end
				v170 = 1751 - (1326 + 424);
			end
		end
	end
	local function v147()
		local v171 = 0 - 0;
		local v172;
		while true do
			if (((65 - 47) < (2230 - (88 + 30))) and ((771 - (720 + 51)) == v171)) then
				v172 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (((2440 - 1343) <= (3404 - (421 + 1355))) and v172) then
					return v172;
				end
				v171 = 1 - 0;
			end
			if (((2275 + 2355) == (5713 - (286 + 797))) and (v171 == (3 - 2))) then
				if (((5863 - 2323) > (3122 - (397 + 42))) and v82 and ((v85 and v35) or not v85) and (v75 < v124)) then
					local v237 = 0 + 0;
					while true do
						if (((5594 - (24 + 776)) >= (5045 - 1770)) and (v237 == (786 - (222 + 563)))) then
							if (((3269 - 1785) == (1069 + 415)) and v90.Fireblood:IsCastable()) then
								if (((1622 - (23 + 167)) < (5353 - (690 + 1108))) and v24(v90.Fireblood)) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (v90.AncestralCall:IsCastable() or ((385 + 680) > (2952 + 626))) then
								if (v24(v90.AncestralCall) or ((5643 - (40 + 808)) < (232 + 1175))) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
						if (((7085 - 5232) < (4601 + 212)) and (v237 == (0 + 0))) then
							if (v90.BloodFury:IsCastable() or ((1547 + 1274) < (3002 - (47 + 524)))) then
								if (v24(v90.BloodFury) or ((1866 + 1008) < (5961 - 3780))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v90.Berserking:IsCastable() and v119) or ((4020 - 1331) <= (781 - 438))) then
								if (v24(v90.Berserking) or ((3595 - (1165 + 561)) == (60 + 1949))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v237 = 3 - 2;
						end
					end
				end
				if ((v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) or ((1353 + 2193) < (2801 - (341 + 138)))) then
					if (v24(v90.TimeWarp, nil, nil, true) or ((563 + 1519) == (9849 - 5076))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v171 = 328 - (89 + 237);
			end
			if (((10435 - 7191) > (2221 - 1166)) and (v171 == (883 - (581 + 300)))) then
				if ((v75 < v124) or ((4533 - (855 + 365)) <= (4222 - 2444))) then
					if ((v83 and ((v35 and v84) or not v84)) or ((464 + 957) >= (3339 - (1030 + 205)))) then
						v32 = v141();
						if (((1702 + 110) <= (3023 + 226)) and v32) then
							return v32;
						end
					end
				end
				break;
			end
		end
	end
	local function v148()
		if (((1909 - (156 + 130)) <= (4446 - 2489)) and v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
			if (((7435 - 3023) == (9035 - 4623)) and v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((462 + 1288) >= (491 + 351)) and v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
			if (((4441 - (10 + 59)) > (524 + 1326)) and v24(v90.BagofTricks)) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((1142 - 910) < (1984 - (671 + 492))) and v90.LivingBomb:IsReady() and v34 and v43 and (v128 > (1 + 0)) and v120) then
			if (((1733 - (369 + 846)) < (239 + 663)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if (((2556 + 438) > (2803 - (1036 + 909))) and ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (16 + 4)))) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (203 - (11 + 192))) or ((1898 + 1857) <= (1090 - (135 + 40)))) then
					v32 = v147();
					if (((9560 - 5614) > (2257 + 1486)) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(66 - 36, 2 - 0) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((180 - (50 + 126)) * v125)) and v14:BuffDown(v90.HotStreakBuff)) or ((3717 - 2382) >= (732 + 2574))) then
			if (((6257 - (1233 + 180)) > (3222 - (522 + 447))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v32 = v146();
		if (((1873 - (107 + 1314)) == (210 + 242)) and v32) then
			return v32;
		end
		if ((v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (0 - 0)) and v120 and (v110 <= (0 + 0)) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) or ((9048 - 4491) < (8257 - 6170))) then
			if (((5784 - (716 + 1194)) == (67 + 3807)) and v24(v90.Combustion, not v15:IsInRange(5 + 35), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((507 - (74 + 429)) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (1 + 1))) or ((4436 - 2498) > (3492 + 1443))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((13117 - 8862) < (8463 - 5040))) then
				return "fire_blast combustion_phase 12";
			end
		end
		if (((1887 - (279 + 154)) <= (3269 - (454 + 324))) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v127 >= v101)) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(32 + 8), v14:BuffDown(v90.IceFloes)) or ((4174 - (12 + 5)) <= (1512 + 1291))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if (((12365 - 7512) >= (1102 + 1880)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) then
			if (((5227 - (277 + 816)) > (14344 - 10987)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v127 < (1185 - (1058 + 125))) and not v136()) or ((641 + 2776) < (3509 - (815 + 160)))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((11679 - 8957) <= (389 - 225))) then
				return "fireball combustion_phase 16";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) or ((575 + 1833) < (6164 - 4055))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((1931 - (41 + 1857)) == (3348 - (1222 + 671)))) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((10 - 6) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (1184 - (229 + 953)))) or ((2217 - (1111 + 663)) >= (5594 - (874 + 705)))) then
			if (((474 + 2908) > (114 + 52)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast combustion_phase 20";
			end
		end
		if ((v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v127 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v127 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) or ((582 - 302) == (87 + 2972))) then
			if (((2560 - (642 + 37)) > (295 + 998)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(7 + 33), v14:BuffDown(v90.IceFloes))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((5917 - 3560) == (2811 - (233 + 221))) and v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) then
			if (((284 - 161) == (109 + 14)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) or ((2597 - (718 + 823)) >= (2135 + 1257))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((1886 - (266 + 539)) < (3043 - 1968))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(1226 - (636 + 589), v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v127 < v100) and v119) or ((2489 - 1440) >= (9140 - 4708))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((3779 + 989) <= (308 + 538))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if ((v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (1015 - (657 + 358))) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v127)) or ((8891 - 5533) <= (3235 - 1815))) then
			if (v24(v90.ShiftingPower, not v15:IsInRange(1227 - (1151 + 36))) or ((3611 + 128) <= (791 + 2214))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v127 >= v101)) or ((4954 - 3295) >= (3966 - (1552 + 280)))) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(874 - (64 + 770)), v14:BuffDown(v90.IceFloes)) or ((2214 + 1046) < (5346 - 2991))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((119 + 550) == (5466 - (157 + 1086)))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((3386 - 1694) < (2575 - 1987))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((5 - 1) * v125)) and (v129 < v100)) or ((6547 - 1750) < (4470 - (599 + 220)))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((8317 - 4140) > (6781 - (1813 + 118)))) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(22 + 8, 1219 - (841 + 376)) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (2 - 0)) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((1 + 3) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (2 - 1)) or v14:BuffUp(v90.FlamesFuryBuff))) or ((1259 - (464 + 395)) > (2851 - 1740))) then
			if (((1466 + 1585) > (1842 - (467 + 370))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if (((7630 - 3937) <= (3217 + 1165)) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((11250 - 7968) > (640 + 3460))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and ((not v90.AlexstraszasFury:IsAvailable() and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff))) or v90.AlexstraszasFury:IsAvailable()) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (4 - 2))) or ((4100 - (150 + 370)) < (4126 - (74 + 1208)))) then
			if (((218 - 129) < (21294 - 16804)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) or ((3546 + 1437) < (2198 - (14 + 376)))) then
			if (((6640 - 2811) > (2439 + 1330)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 44";
			end
		end
		if (((1305 + 180) <= (2770 + 134)) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) then
			if (((12508 - 8239) == (3212 + 1057)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((465 - (23 + 55)) <= (6592 - 3810)) and v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v128 > (1 + 0))) then
			if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((1706 + 193) <= (1421 - 504))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v149()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (904 - (652 + 249))) or ((11539 - 7227) <= (2744 - (708 + 1160)))) then
				if (((6058 - 3826) <= (4732 - 2136)) and (((v115 + ((147 - (10 + 17)) * ((1 + 0) - (((1732.4 - (1400 + 332)) + ((0.2 - 0) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (1928 - (242 + 1666)))))) then
					v110 = v115;
				end
				break;
			end
			if (((897 + 1198) < (1351 + 2335)) and (v173 == (1 + 0))) then
				v110 = v115;
				if ((v90.Firestarter:IsAvailable() and not v97) or ((2535 - (850 + 90)) >= (7835 - 3361))) then
					v110 = v30(v134(), v110);
				end
				v173 = 1392 - (360 + 1030);
			end
			if (((2 + 0) == v173) or ((13036 - 8417) < (3964 - 1082))) then
				if ((v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) or ((1955 - (909 + 752)) >= (6054 - (109 + 1114)))) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (5 - 2) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v173 = 2 + 1;
			end
			if (((2271 - (6 + 236)) <= (1944 + 1140)) and (v173 == (0 + 0))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v127 < v100)) + (v90.Flamestrike:CastTime() * v28(v127 >= v100))) - v105;
				v173 = 2 - 1;
			end
		end
	end
	local function v150()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (1133 - (1076 + 57))) or ((335 + 1702) == (3109 - (579 + 110)))) then
				if (((352 + 4106) > (3452 + 452)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 + 0)) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (408 - (174 + 233))) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((5 - 3) * v125)))) then
					if (((765 - 329) >= (55 + 68)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((1674 - (663 + 511)) < (1621 + 195)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 + 0)) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(92 - 62, 2 + 0) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((4 - 2) * v125)))) then
					if (((8651 - 5077) == (1706 + 1868)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v151()
		local v175 = 0 - 0;
		while true do
			if (((158 + 63) < (36 + 354)) and (v175 == (725 - (478 + 244)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (517 - (440 + 77))) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (1.5 + 1)) or ((v90.PhoenixFlames:ChargesFractional() > (3.5 - 2)) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1559 - (655 + 901)) * v125)))))) or ((411 + 1802) <= (1088 + 333))) then
					if (((2065 + 993) < (19579 - 14719)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (v32 or ((2741 - (695 + 750)) >= (15181 - 10735))) then
					return v32;
				end
				if ((v34 and v90.DragonsBreath:IsReady() and v39 and (v129 > (1 - 0)) and v90.AlexstraszasFury:IsAvailable()) or ((5602 - 4209) > (4840 - (285 + 66)))) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(23 - 13)) or ((5734 - (682 + 628)) < (5 + 22))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v175 = 303 - (176 + 123);
			end
			if ((v175 == (0 + 0)) or ((1449 + 548) > (4084 - (239 + 30)))) then
				if (((942 + 2523) > (1839 + 74)) and v34 and v90.Flamestrike:IsReady() and v42 and (v127 >= v98) and v138()) then
					if (((1296 - 563) < (5674 - 3855)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(355 - (306 + 9)), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v138())) or ((15336 - 10941) == (827 + 3928))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((2328 + 1465) < (1141 + 1228))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and (((v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast)) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (8 - 5))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (1375 - (1140 + 235)))))))) or ((2599 + 1485) == (244 + 21))) then
					if (((1119 + 3239) == (4410 - (33 + 19))) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast standard_rotation 6";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v127 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) or ((1134 + 2004) < (2976 - 1983))) then
					if (((1467 + 1863) > (4555 - 2232)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(38 + 2), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v175 = 690 - (586 + 103);
			end
			if ((v175 == (1 + 0)) or ((11163 - 7537) == (5477 - (1309 + 179)))) then
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((9 - 4) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) or ((399 + 517) == (7173 - 4502))) then
					if (((206 + 66) == (577 - 305)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 13";
					end
				end
				if (((8466 - 4217) <= (5448 - (295 + 314))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) then
					if (((6820 - 4043) < (5162 - (1300 + 662))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((298 - 203) < (3712 - (1178 + 577))) and v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(1 + 0, v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v127 < v98)) then
					if (((2441 - 1615) < (3122 - (851 + 554))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((1261 + 165) >= (3064 - 1959)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((8 - 4) * v125))) then
					if (((3056 - (115 + 187)) <= (2588 + 791)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 19";
					end
				end
				v175 = 2 + 0;
			end
			if ((v175 == (19 - 14)) or ((5088 - (160 + 1001)) == (1237 + 176))) then
				if ((v90.Fireball:IsReady() and v41 and not v138()) or ((797 + 357) <= (1612 - 824))) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((2001 - (237 + 121)) > (4276 - (525 + 372)))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((7 - 3) == v175) or ((9209 - 6406) > (4691 - (96 + 46)))) then
				if ((v90.Scorch:IsReady() and v47 and (v135())) or ((997 - (643 + 134)) >= (1091 + 1931))) then
					if (((6766 - 3944) == (10477 - 7655)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v34 and v90.ArcaneExplosion:IsReady() and v37 and (v131 >= v102) and (v14:ManaPercentageP() >= v103)) or ((1018 + 43) == (3644 - 1787))) then
					if (((5641 - 2881) > (2083 - (316 + 403))) and v24(v90.ArcaneExplosion, not v15:IsInRange(6 + 2))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v127 >= v99)) or ((13477 - 8575) <= (1300 + 2295))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(100 - 60)) or ((2730 + 1122) == (95 + 198))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) or ((5401 - 3842) == (21911 - 17323))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((9314 - 4830) == (46 + 742))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v175 = 9 - 4;
			end
			if (((224 + 4344) >= (11494 - 7587)) and (v175 == (19 - (12 + 5)))) then
				if (((4839 - 3593) < (7403 - 3933)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((3 - 1) * v125)))) then
					if (((10088 - 6020) >= (198 + 774)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((2466 - (1656 + 317)) < (3470 + 423)) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(25 + 5, 4 - 2) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((9 - 7) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((1827 - (5 + 349)) >= (15826 - 12494))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) or ((5322 - (266 + 1005)) <= (763 + 394))) then
					if (((2060 - 1456) < (3792 - 911)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or ((2596 - (561 + 1135)) == (4400 - 1023))) then
					if (((14657 - 10198) > (1657 - (507 + 559))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v175 = 7 - 4;
			end
		end
	end
	local function v152()
		local v176 = 0 - 0;
		while true do
			if (((3786 - (212 + 176)) >= (3300 - (250 + 655))) and (v176 == (2 - 1))) then
				v112 = v110 > v90.ShiftingPower:CooldownRemains();
				v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (1 - 0)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((18 - 6) / v90.FireBlast:Cooldown()) % (1957 - (1869 + 87))))) and (v110 < v124);
				if ((not v96 and ((v110 <= (0 - 0)) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) or ((4084 - (484 + 1417)) >= (6052 - 3228))) then
					local v238 = 0 - 0;
					while true do
						if (((2709 - (48 + 725)) == (3162 - 1226)) and (v238 == (0 - 0))) then
							v32 = v148();
							if (v32 or ((2809 + 2023) < (11526 - 7213))) then
								return v32;
							end
							break;
						end
					end
				end
				v176 = 1 + 1;
			end
			if (((1192 + 2896) > (4727 - (152 + 701))) and (v176 == (1316 - (430 + 881)))) then
				if (((1659 + 2673) == (5227 - (557 + 338))) and v90.Scorch:IsReady() and v47) then
					if (((1182 + 2817) >= (8172 - 5272)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v176 == (13 - 9)) or ((6708 - 4183) > (8758 - 4694))) then
				if (((5172 - (499 + 302)) == (5237 - (39 + 827))) and v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((733 - 467) > (11135 - 6149))) then
						return "fire_blast main 16";
					end
				end
				if (((7907 - 5916) >= (1419 - 494)) and (v110 > (0 + 0)) and v120) then
					local v239 = 0 - 0;
					while true do
						if (((73 + 382) < (3248 - 1195)) and (v239 == (104 - (103 + 1)))) then
							v32 = v151();
							if (v32 or ((1380 - (475 + 79)) == (10486 - 5635))) then
								return v32;
							end
							break;
						end
					end
				end
				if (((585 - 402) == (24 + 159)) and v90.IceNova:IsCastable() and not v135()) then
					if (((1021 + 138) <= (3291 - (1395 + 108))) and v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v176 = 14 - 9;
			end
			if ((v176 == (1204 - (7 + 1197))) or ((1530 + 1977) > (1507 + 2811))) then
				if (not v96 or ((3394 - (27 + 292)) <= (8688 - 5723))) then
					v149();
				end
				if (((1740 - 375) <= (8433 - 6422)) and v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (78 - 38)))) then
					if (v24(v90.TimeWarp, not v15:IsInRange(76 - 36)) or ((2915 - (43 + 96)) > (14582 - 11007))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v75 < v124) or ((5773 - 3219) == (3987 + 817))) then
					if (((728 + 1849) == (5092 - 2515)) and v83 and ((v35 and v84) or not v84)) then
						local v240 = 0 + 0;
						while true do
							if ((v240 == (0 - 0)) or ((2 + 4) >= (139 + 1750))) then
								v32 = v141();
								if (((2257 - (1414 + 337)) <= (3832 - (1642 + 298))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				v176 = 2 - 1;
			end
			if ((v176 == (8 - 5)) or ((5958 - 3950) > (730 + 1488))) then
				if (((295 + 84) <= (5119 - (357 + 615))) and (v127 >= v100)) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 + 0)) and (v127 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v90.FireBlast:ChargesFractional() >= (2 + 0)))) or ((9673 - 5159) <= (807 + 202))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((238 + 3258) == (750 + 442))) then
						return "fire_blast main 14";
					end
				end
				if ((v120 and v133() and (v110 > (1301 - (384 + 917)))) or ((905 - (128 + 569)) == (4502 - (1407 + 136)))) then
					v32 = v150();
					if (((6164 - (687 + 1200)) >= (3023 - (556 + 1154))) and v32) then
						return v32;
					end
				end
				v176 = 14 - 10;
			end
			if (((2682 - (9 + 86)) < (3595 - (275 + 146))) and (v176 == (1 + 1))) then
				if ((not v114 and v90.SunKingsBlessing:IsAvailable()) or ((4184 - (29 + 35)) <= (9741 - 7543))) then
					v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((8 - 5) * v125));
				end
				if ((v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (0 - 0)) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) or ((1040 + 556) == (1870 - (53 + 959)))) then
					if (((3628 - (312 + 96)) == (5588 - 2368)) and v24(v90.ShiftingPower, not v15:IsInRange(303 - (147 + 138)), true)) then
						return "shifting_power main 12";
					end
				end
				if ((v127 < v100) or ((2301 - (813 + 86)) > (3272 + 348))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + (12 - 5)) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				v176 = 495 - (18 + 474);
			end
		end
	end
	local function v153()
		local v177 = 0 + 0;
		while true do
			if (((8401 - 5827) == (3660 - (860 + 226))) and ((304 - (121 + 182)) == v177)) then
				v42 = EpicSettings.Settings['useFlamestrike'];
				v43 = EpicSettings.Settings['useLivingBomb'];
				v44 = EpicSettings.Settings['useMeteor'];
				v45 = EpicSettings.Settings['usePhoenixFlames'];
				v46 = EpicSettings.Settings['usePyroblast'];
				v177 = 1 + 1;
			end
			if (((3038 - (988 + 252)) < (312 + 2445)) and (v177 == (2 + 2))) then
				v57 = EpicSettings.Settings['useIceBlock'];
				v58 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v59 = EpicSettings.Settings['useMirrorImage'];
				v61 = EpicSettings.Settings['alterTimeHP'] or (1970 - (49 + 1921));
				v177 = 895 - (223 + 667);
			end
			if ((v177 == (55 - (51 + 1))) or ((648 - 271) > (5575 - 2971))) then
				v52 = EpicSettings.Settings['combustionWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['useAlterTime'];
				v55 = EpicSettings.Settings['useBlazingBarrier'];
				v56 = EpicSettings.Settings['useGreaterInvisibility'];
				v177 = 1129 - (146 + 979);
			end
			if (((161 + 407) < (1516 - (311 + 294))) and (v177 == (13 - 8))) then
				v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
				v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (1443 - (496 + 947));
				v64 = EpicSettings.Settings['iceBlockHP'] or (1358 - (1233 + 125));
				v65 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v66 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v177 = 2 + 4;
			end
			if (((4930 - (963 + 682)) < (3529 + 699)) and (v177 == (1506 - (504 + 1000)))) then
				v47 = EpicSettings.Settings['useScorch'];
				v48 = EpicSettings.Settings['useCounterspell'];
				v49 = EpicSettings.Settings['useBlastWave'];
				v50 = EpicSettings.Settings['useCombustion'];
				v51 = EpicSettings.Settings['useShiftingPower'];
				v177 = 3 + 0;
			end
			if (((3567 + 349) > (315 + 3013)) and (v177 == (8 - 2))) then
				v67 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v86 = EpicSettings.Settings['mirrorImageBeforePull'];
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((1454 + 1046) < (4021 - (156 + 26))) and (v177 == (0 + 0))) then
				v37 = EpicSettings.Settings['useArcaneExplosion'];
				v38 = EpicSettings.Settings['useArcaneIntellect'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFireball'];
				v177 = 1 - 0;
			end
		end
	end
	local function v154()
		local v178 = 164 - (149 + 15);
		while true do
			if (((1467 - (890 + 70)) == (624 - (39 + 78))) and (v178 == (485 - (14 + 468)))) then
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v178 = 8 - 4;
			end
			if (((670 - 430) <= (1633 + 1532)) and (v178 == (0 + 0))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v178 = 1 + 0;
			end
			if (((219 + 615) >= (1540 - 735)) and (v178 == (2 + 0))) then
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v82 = EpicSettings.Settings['useRacials'];
				v178 = 10 - 7;
			end
			if ((v178 == (1 + 3)) or ((3863 - (12 + 39)) < (2155 + 161))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v178 = 2 + 3;
			end
			if (((3 + 2) == v178) or ((6724 - 4072) <= (1022 + 511))) then
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v178 == (4 - 3)) or ((5308 - (1596 + 114)) < (3811 - 2351))) then
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v178 = 715 - (164 + 549);
			end
		end
	end
	local function v155()
		v153();
		v154();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		if (v14:IsDeadOrGhost() or ((5554 - (1059 + 379)) < (1479 - 287))) then
			return v32;
		end
		v126 = v15:GetEnemiesInSplashRange(3 + 2);
		v130 = v14:GetEnemiesInRange(7 + 33);
		if (v34 or ((3769 - (145 + 247)) <= (741 + 162))) then
			v127 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v130);
			v128 = v30(v15:GetEnemiesInSplashRangeCount(14 - 9), #v130);
			v129 = v30(v15:GetEnemiesInSplashRangeCount(1 + 4), #v130);
			v131 = #v130;
		else
			v127 = 1 + 0;
			v128 = 1 - 0;
			v129 = 721 - (254 + 466);
			v131 = 561 - (544 + 16);
		end
		if (((12635 - 8659) >= (1067 - (294 + 334))) and (v94.TargetIsValid() or v14:AffectingCombat())) then
			local v189 = 253 - (236 + 17);
			while true do
				if (((1618 + 2134) == (2921 + 831)) and (v189 == (7 - 5))) then
					if (((19155 - 15109) > (1388 + 1307)) and v96) then
						v110 = 82361 + 17638;
					end
					v125 = v14:GCD();
					v119 = v14:BuffUp(v90.CombustionBuff);
					v189 = 797 - (413 + 381);
				end
				if ((v189 == (0 + 0)) or ((7539 - 3994) == (8304 - 5107))) then
					if (((4364 - (582 + 1388)) > (634 - 261)) and (v14:AffectingCombat() or v69)) then
						local v241 = v69 and v90.RemoveCurse:IsReady() and v36;
						v32 = v94.FocusUnit(v241, nil, 15 + 5, nil, 384 - (326 + 38), v90.ArcaneIntellect);
						if (((12291 - 8136) <= (6041 - 1809)) and v32) then
							return v32;
						end
					end
					v123 = v10.BossFightRemains(nil, true);
					v124 = v123;
					v189 = 621 - (47 + 573);
				end
				if ((v189 == (1 + 0)) or ((15208 - 11627) == (5636 - 2163))) then
					if (((6659 - (1269 + 395)) > (3840 - (76 + 416))) and (v124 == (11554 - (319 + 124)))) then
						v124 = v10.FightRemains(v130, false);
					end
					UnitsWithIgniteCount = v139(v130);
					v96 = not v35;
					v189 = 4 - 2;
				end
				if ((v189 == (1010 - (564 + 443))) or ((2087 - 1333) > (4182 - (337 + 121)))) then
					v120 = not v119;
					v121 = v14:BuffRemains(v90.CombustionBuff);
					break;
				end
			end
		end
		if (((635 - 418) >= (189 - 132)) and not v14:AffectingCombat() and v33) then
			local v190 = 1911 - (1261 + 650);
			while true do
				if (((0 + 0) == v190) or ((3298 - 1228) >= (5854 - (772 + 1045)))) then
					v32 = v145();
					if (((382 + 2323) == (2849 - (102 + 42))) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if (((1905 - (1524 + 320)) == (1331 - (1049 + 221))) and v14:AffectingCombat() and v94.TargetIsValid()) then
			local v191 = 156 - (18 + 138);
			while true do
				if (((4 - 2) == v191) or ((1801 - (67 + 1035)) >= (1644 - (136 + 212)))) then
					if ((v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes) and not v14:PrevOffGCDP(4 - 3, v90.IceFloes)) or ((1429 + 354) >= (3334 + 282))) then
						if (v24(v90.IceFloes) or ((5517 - (240 + 1364)) > (5609 - (1050 + 32)))) then
							return "ice_floes movement";
						end
					end
					v32 = v152();
					if (((15624 - 11248) > (484 + 333)) and v32) then
						return v32;
					end
					break;
				end
				if (((5916 - (331 + 724)) > (67 + 757)) and (v191 == (644 - (269 + 375)))) then
					if ((v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) or ((2108 - (267 + 458)) >= (663 + 1468))) then
						if (v24(v92.UseWeapon, nil) or ((3607 - 1731) >= (3359 - (667 + 151)))) then
							return "Using Weapon Macro";
						end
					end
					if (((3279 - (1410 + 87)) <= (5669 - (1504 + 393))) and v69 and v36 and v90.RemoveCurse:IsAvailable()) then
						local v242 = 0 - 0;
						while true do
							if ((v242 == (0 - 0)) or ((5496 - (461 + 335)) < (104 + 709))) then
								if (((4960 - (1730 + 31)) < (5717 - (728 + 939))) and v16) then
									local v245 = 0 - 0;
									while true do
										if ((v245 == (0 - 0)) or ((11343 - 6392) < (5498 - (138 + 930)))) then
											v32 = v143();
											if (((88 + 8) == (76 + 20)) and v32) then
												return v32;
											end
											break;
										end
									end
								end
								if ((v18 and v18:Exists() and not v14:CanAttack(v18) and v94.UnitHasCurseDebuff(v18)) or ((2348 + 391) > (16365 - 12357))) then
									if (v90.RemoveCurse:IsReady() or ((1789 - (459 + 1307)) == (3004 - (474 + 1396)))) then
										if (v24(v92.RemoveCurseMouseover) or ((4702 - 2009) >= (3853 + 258))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					v32 = v144();
					if (v32 or ((15 + 4301) <= (6146 - 4000))) then
						return v32;
					end
					v191 = 1 + 0;
				end
				if ((v191 == (3 - 2)) or ((15464 - 11918) <= (3400 - (562 + 29)))) then
					if (((4181 + 723) > (3585 - (374 + 1045))) and v70) then
						if (((87 + 22) >= (279 - 189)) and v89) then
							local v244 = 638 - (448 + 190);
							while true do
								if (((1608 + 3370) > (1312 + 1593)) and (v244 == (0 + 0))) then
									v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 115 - 85);
									if (v32 or ((9402 - 6376) <= (3774 - (1307 + 187)))) then
										return v32;
									end
									break;
								end
							end
						end
					end
					if (v71 or ((6555 - 4902) <= (2593 - 1485))) then
						local v243 = 0 - 0;
						while true do
							if (((3592 - (232 + 451)) > (2492 + 117)) and (v243 == (0 + 0))) then
								v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseover, 594 - (510 + 54));
								if (((1524 - 767) > (230 - (13 + 23))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					if ((v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) or ((60 - 29) >= (2008 - 610))) then
						if (((5806 - 2610) <= (5960 - (830 + 258))) and v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((11732 - 8406) == (2081 + 1245)) and (v14:IsCasting(v90.Pyroblast) or v14:IsChanneling(v90.Pyroblast) or v14:IsCasting(v90.Flamestrike) or v14:IsChanneling(v90.Flamestrike)) and v14:BuffUp(v90.HotStreakBuff)) then
						if (((1220 + 213) <= (5319 - (860 + 581))) and v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast), false, true)) then
							return "Stop Casting";
						end
					end
					v191 = 7 - 5;
				end
			end
		end
	end
	local function v156()
		local v183 = 0 + 0;
		while true do
			if ((v183 == (241 - (237 + 4))) or ((3719 - 2136) == (4389 - 2654))) then
				v95();
				v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(119 - 56, v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

