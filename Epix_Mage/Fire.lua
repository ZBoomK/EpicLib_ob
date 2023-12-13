local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 789 - (766 + 23);
	local v6;
	while true do
		if ((v5 == (4 - 3)) or ((6096 - 1638) <= (2450 - 1520))) then
			return v6(...);
		end
		if (((2246 - 1584) <= (2045 - (1036 + 37))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((8510 - 4140) == (3438 + 932)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1481 - (641 + 839);
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
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
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
		if (v88.RemoveCurse:IsAvailable() or ((5675 - (910 + 3)) <= (2194 - 1333))) then
			v92.DispellableDebuffs = v92.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v93();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v94 = not v34;
	local v95 = v88.SunKingsBlessing:IsAvailable();
	local v96 = ((v88.FlamePatch:IsAvailable()) and (1688 - (1466 + 218))) or (460 + 539);
	local v97 = 2147 - (556 + 592);
	local v98 = v96;
	local v99 = ((2 + 1) * v27(v88.FueltheFire:IsAvailable())) + ((1807 - (329 + 479)) * v27(not v88.FueltheFire:IsAvailable()));
	local v100 = 1853 - (174 + 680);
	local v101 = 137 - 97;
	local v102 = 2070 - 1071;
	local v103 = 0.3 + 0;
	local v104 = 739 - (396 + 343);
	local v105 = 1 + 5;
	local v106 = false;
	local v107 = (v106 and (1497 - (29 + 1448))) or (1389 - (135 + 1254));
	local v108;
	local v109 = ((v88.Kindling:IsAvailable()) and (0.4 - 0)) or (4 - 3);
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = 0 + 0;
	local v114 = 1527 - (389 + 1138);
	local v115 = 582 - (102 + 472);
	local v116 = 3 + 0;
	local v117;
	local v118;
	local v119;
	local v120 = 2 + 1;
	local v121 = 10361 + 750;
	local v122 = 12656 - (320 + 1225);
	local v123;
	local v124, v125, v126;
	local v127;
	local v128;
	local v129;
	local v130;
	v10:RegisterForEvent(function()
		local v154 = 0 - 0;
		while true do
			if ((v154 == (0 + 0)) or ((2876 - (157 + 1307)) == (6123 - (821 + 1038)))) then
				v106 = false;
				v107 = (v106 and (49 - 29)) or (0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v155 = 0 - 0;
		while true do
			if ((v155 == (2 + 1)) or ((7852 - 4684) < (3179 - (834 + 192)))) then
				v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
				v88.Fireball:RegisterInFlight(v88.CombustionBuff);
				break;
			end
			if ((v155 == (0 + 0)) or ((1278 + 3698) < (29 + 1303))) then
				v88.Pyroblast:RegisterInFlight();
				v88.Fireball:RegisterInFlight();
				v155 = 1 - 0;
			end
			if (((4932 - (300 + 4)) == (1236 + 3392)) and (v155 == (5 - 3))) then
				v88.PhoenixFlames:RegisterInFlightEffect(257904 - (112 + 250));
				v88.PhoenixFlames:RegisterInFlight();
				v155 = 2 + 1;
			end
			if ((v155 == (2 - 1)) or ((31 + 23) == (205 + 190))) then
				v88.Meteor:RegisterInFlightEffect(262614 + 88526);
				v88.Meteor:RegisterInFlight();
				v155 = 1 + 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v88.Pyroblast:RegisterInFlight();
	v88.Fireball:RegisterInFlight();
	v88.Meteor:RegisterInFlightEffect(260854 + 90286);
	v88.Meteor:RegisterInFlight();
	v88.PhoenixFlames:RegisterInFlightEffect(258956 - (1001 + 413));
	v88.PhoenixFlames:RegisterInFlight();
	v88.Pyroblast:RegisterInFlight(v88.CombustionBuff);
	v88.Fireball:RegisterInFlight(v88.CombustionBuff);
	v10:RegisterForEvent(function()
		local v156 = 0 - 0;
		while true do
			if (((964 - (244 + 638)) == (775 - (627 + 66))) and ((0 - 0) == v156)) then
				v121 = 11713 - (512 + 90);
				v122 = 13017 - (1665 + 241);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v157 = 717 - (373 + 344);
		while true do
			if ((v157 == (0 + 0)) or ((154 + 427) < (743 - 461))) then
				v95 = v88.SunKingsBlessing:IsAvailable();
				v96 = ((v88.FlamePatch:IsAvailable()) and (4 - 1)) or (2098 - (35 + 1064));
				v157 = 1 + 0;
			end
			if ((v157 == (2 - 1)) or ((19 + 4590) < (3731 - (298 + 938)))) then
				v98 = v96;
				v109 = ((v88.Kindling:IsAvailable()) and (1259.4 - (233 + 1026))) or (1667 - (636 + 1030));
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v131()
		return v88.Firestarter:IsAvailable() and (v15:HealthPercentage() > (47 + 43));
	end
	local function v132()
		return (v88.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (88 + 2)) and v15:TimeToX(27 + 63)) or (0 + 0))) or (221 - (55 + 166));
	end
	local function v133()
		return v88.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (6 + 24));
	end
	local function v134()
		return v88.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (4 + 26));
	end
	local function v135()
		return (v120 * v88.ShiftingPower:BaseDuration()) / v88.ShiftingPower:BaseTickTime();
	end
	local function v136()
		local v158 = 0 - 0;
		local v159;
		while true do
			if (((1449 - (36 + 261)) == (2014 - 862)) and (v158 == (1369 - (34 + 1334)))) then
				return v14:BuffUp(v88.HotStreakBuff) or v14:BuffUp(v88.HyperthermiaBuff) or (v14:BuffUp(v88.HeatingUpBuff) and ((v134() and v14:IsCasting(v88.Scorch)) or (v131() and (v14:IsCasting(v88.Fireball) or v14:IsCasting(v88.Pyroblast) or (v159 > (0 + 0))))));
			end
			if (((1474 + 422) <= (4705 - (1035 + 248))) and (v158 == (21 - (20 + 1)))) then
				v159 = (v131() and (v27(v88.Pyroblast:InFlight()) + v27(v88.Fireball:InFlight()))) or (0 + 0);
				v159 = v159 + v27(v88.PhoenixFlames:InFlight() or v14:PrevGCDP(320 - (134 + 185), v88.PhoenixFlames));
				v158 = 1134 - (549 + 584);
			end
		end
	end
	local function v137(v160)
		local v161 = 685 - (314 + 371);
		local v162;
		while true do
			if ((v161 == (0 - 0)) or ((1958 - (478 + 490)) > (859 + 761))) then
				v162 = 1172 - (786 + 386);
				for v226, v227 in pairs(v160) do
					if (v227:DebuffUp(v88.IgniteDebuff) or ((2840 - 1963) > (6074 - (1055 + 324)))) then
						v162 = v162 + (1341 - (1093 + 247));
					end
				end
				v161 = 1 + 0;
			end
			if (((283 + 2408) >= (7348 - 5497)) and ((3 - 2) == v161)) then
				return v162;
			end
		end
	end
	local function v138()
		local v163 = 0 - 0;
		local v164;
		while true do
			if ((v163 == (0 - 0)) or ((1062 + 1923) >= (18707 - 13851))) then
				v164 = 0 - 0;
				if (((3225 + 1051) >= (3056 - 1861)) and (v88.Fireball:InFlight() or v88.PhoenixFlames:InFlight())) then
					v164 = v164 + (689 - (364 + 324));
				end
				v163 = 2 - 1;
			end
			if (((7755 - 4523) <= (1555 + 3135)) and (v163 == (4 - 3))) then
				return v164;
			end
		end
	end
	local function v139()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (0 - 0)) or ((2164 - (1249 + 19)) >= (2840 + 306))) then
				v31 = v92.HandleTopTrinket(v91, v34, 155 - 115, nil);
				if (((4147 - (686 + 400)) >= (2321 + 637)) and v31) then
					return v31;
				end
				v165 = 230 - (73 + 156);
			end
			if (((16 + 3171) >= (1455 - (721 + 90))) and (v165 == (1 + 0))) then
				v31 = v92.HandleBottomTrinket(v91, v34, 129 - 89, nil);
				if (((1114 - (224 + 246)) <= (1139 - 435)) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v140()
		if (((1763 - 805) > (172 + 775)) and v88.RemoveCurse:IsReady() and v35 and v92.DispellableFriendlyUnit(1 + 19)) then
			if (((3300 + 1192) >= (5276 - 2622)) and v23(v90.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v141()
		local v166 = 0 - 0;
		while true do
			if (((3955 - (203 + 310)) >= (3496 - (1238 + 755))) and ((0 + 0) == v166)) then
				if ((v88.BlazingBarrier:IsCastable() and v54 and v14:BuffDown(v88.BlazingBarrier) and (v14:HealthPercentage() <= v61)) or ((4704 - (709 + 825)) <= (2697 - 1233))) then
					if (v23(v88.BlazingBarrier) or ((6987 - 2190) == (5252 - (196 + 668)))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((2175 - 1624) <= (1410 - 729)) and v88.MassBarrier:IsCastable() and v59 and v14:BuffDown(v88.BlazingBarrier) and v92.AreUnitsBelowHealthPercentage(v66, 835 - (171 + 662))) then
					if (((3370 - (4 + 89)) > (1426 - 1019)) and v23(v88.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v166 = 1 + 0;
			end
			if (((20621 - 15926) >= (555 + 860)) and (v166 == (1487 - (35 + 1451)))) then
				if ((v88.IceBlock:IsCastable() and v56 and (v14:HealthPercentage() <= v63)) or ((4665 - (28 + 1425)) <= (2937 - (941 + 1052)))) then
					if (v23(v88.IceBlock) or ((2969 + 127) <= (3312 - (822 + 692)))) then
						return "ice_block defensive 3";
					end
				end
				if (((5049 - 1512) == (1666 + 1871)) and v88.IceColdTalent:IsAvailable() and v88.IceColdAbility:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
					if (((4134 - (45 + 252)) >= (1554 + 16)) and v23(v88.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v166 = 1 + 1;
			end
			if ((v166 == (7 - 4)) or ((3383 - (114 + 319)) == (5472 - 1660))) then
				if (((6051 - 1328) >= (1478 + 840)) and v88.AlterTime:IsReady() and v53 and (v14:HealthPercentage() <= v60)) then
					if (v23(v88.AlterTime) or ((3019 - 992) > (5975 - 3123))) then
						return "alter_time defensive 6";
					end
				end
				if ((v89.Healthstone:IsReady() and v76 and (v14:HealthPercentage() <= v78)) or ((3099 - (556 + 1407)) > (5523 - (741 + 465)))) then
					if (((5213 - (170 + 295)) == (2502 + 2246)) and v23(v90.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v166 = 4 + 0;
			end
			if (((9197 - 5461) <= (3930 + 810)) and (v166 == (3 + 1))) then
				if ((v75 and (v14:HealthPercentage() <= v77)) or ((1920 + 1470) <= (4290 - (957 + 273)))) then
					if ((v79 == "Refreshing Healing Potion") or ((268 + 731) > (1079 + 1614))) then
						if (((1764 - 1301) < (1583 - 982)) and v89.RefreshingHealingPotion:IsReady()) then
							if (v23(v90.RefreshingHealingPotion) or ((6667 - 4484) < (3401 - 2714))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((6329 - (389 + 1391)) == (2855 + 1694)) and (v79 == "Dreamwalker's Healing Potion")) then
						if (((487 + 4185) == (10635 - 5963)) and v89.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v90.RefreshingHealingPotion) or ((4619 - (783 + 168)) < (1325 - 930))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v166 == (2 + 0)) or ((4477 - (309 + 2)) == (1397 - 942))) then
				if ((v88.MirrorImage:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) or ((5661 - (1090 + 122)) == (864 + 1799))) then
					if (v23(v88.MirrorImage) or ((14364 - 10087) < (2046 + 943))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v88.GreaterInvisibility:IsReady() and v55 and (v14:HealthPercentage() <= v62)) or ((1988 - (628 + 490)) >= (744 + 3405))) then
					if (((5476 - 3264) < (14546 - 11363)) and v23(v88.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v166 = 777 - (431 + 343);
			end
		end
	end
	local function v142()
		local v167 = 0 - 0;
		while true do
			if (((13440 - 8794) > (2364 + 628)) and (v167 == (1 + 0))) then
				if (((3129 - (556 + 1139)) < (3121 - (6 + 9))) and v88.Pyroblast:IsReady() and v45 and not v14:IsCasting(v88.Pyroblast)) then
					if (((144 + 642) < (1549 + 1474)) and v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast), true)) then
						return "pyroblast precombat 4";
					end
				end
				if ((v88.Fireball:IsReady() and v40) or ((2611 - (28 + 141)) < (29 + 45))) then
					if (((5597 - 1062) == (3212 + 1323)) and v23(v88.Fireball, not v15:IsSpellInRange(v88.Fireball), true)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if ((v167 == (1317 - (486 + 831))) or ((7829 - 4820) <= (7410 - 5305))) then
				if (((346 + 1484) < (11601 - 7932)) and v88.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v88.ArcaneIntellect, true) or v92.GroupBuffMissing(v88.ArcaneIntellect))) then
					if (v23(v88.ArcaneIntellect) or ((2693 - (668 + 595)) >= (3251 + 361))) then
						return "arcane_intellect precombat 2";
					end
				end
				if (((541 + 2142) >= (6708 - 4248)) and v88.MirrorImage:IsCastable() and v92.TargetIsValid() and v58 and v84) then
					if (v23(v88.MirrorImage) or ((2094 - (23 + 267)) >= (5219 - (1129 + 815)))) then
						return "mirror_image precombat 2";
					end
				end
				v167 = 388 - (371 + 16);
			end
		end
	end
	local function v143()
		local v168 = 1750 - (1326 + 424);
		while true do
			if ((v168 == (0 - 0)) or ((5178 - 3761) > (3747 - (88 + 30)))) then
				if (((5566 - (720 + 51)) > (894 - 492)) and v88.LivingBomb:IsReady() and v42 and (v125 > (1777 - (421 + 1355))) and v118 and ((v108 > v88.LivingBomb:CooldownRemains()) or (v108 <= (0 - 0)))) then
					if (((2365 + 2448) > (4648 - (286 + 797))) and v23(v88.LivingBomb, not v15:IsSpellInRange(v88.LivingBomb))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((14300 - 10388) == (6479 - 2567)) and v88.Meteor:IsReady() and v43 and (v74 < v122) and ((v108 <= (439 - (397 + 42))) or (v14:BuffRemains(v88.CombustionBuff) > v88.Meteor:TravelTime()) or (not v88.SunKingsBlessing:IsAvailable() and (((15 + 30) < v108) or (v122 < v108))))) then
					if (((3621 - (24 + 776)) <= (7431 - 2607)) and v23(v90.MeteorCursor, not v15:IsInRange(825 - (222 + 563)))) then
						return "meteor active_talents 4";
					end
				end
				v168 = 1 - 0;
			end
			if (((1252 + 486) <= (2385 - (23 + 167))) and (v168 == (1799 - (690 + 1108)))) then
				if (((15 + 26) <= (2490 + 528)) and v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v14:BuffDown(v88.HotStreakBuff) and (v14:BuffUp(v88.FeeltheBurnBuff) or (v10.CombatTime() > (863 - (40 + 808)))) and not v134() and (v132() == (0 + 0)) and not v88.TemperedFlames:IsAvailable()) then
					if (((8202 - 6057) <= (3923 + 181)) and v23(v88.DragonsBreath, not v15:IsInRange(6 + 4))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((1475 + 1214) < (5416 - (47 + 524))) and v88.DragonsBreath:IsReady() and v38 and v88.AlexstraszasFury:IsAvailable() and v118 and v14:BuffDown(v88.HotStreakBuff) and (v14:BuffUp(v88.FeeltheBurnBuff) or (v10.CombatTime() > (10 + 5))) and not v134() and v88.TemperedFlames:IsAvailable()) then
					if (v23(v88.DragonsBreath, not v15:IsInRange(27 - 17)) or ((3471 - 1149) > (5979 - 3357))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
		end
	end
	local function v144()
		local v169 = v92.HandleDPSPotion(v14:BuffUp(v88.CombustionBuff));
		if (v169 or ((6260 - (1165 + 561)) == (62 + 2020))) then
			return v169;
		end
		if ((v80 and ((v83 and v34) or not v83) and (v74 < v122)) or ((4865 - 3294) > (713 + 1154))) then
			local v180 = 479 - (341 + 138);
			while true do
				if ((v180 == (0 + 0)) or ((5476 - 2822) >= (3322 - (89 + 237)))) then
					if (((12797 - 8819) > (4429 - 2325)) and v88.BloodFury:IsCastable()) then
						if (((3876 - (581 + 300)) > (2761 - (855 + 365))) and v23(v88.BloodFury)) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if (((7716 - 4467) > (312 + 641)) and v88.Berserking:IsCastable() and v117) then
						if (v23(v88.Berserking) or ((4508 - (1030 + 205)) > (4294 + 279))) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v180 = 1 + 0;
				end
				if (((287 - (156 + 130)) == v180) or ((7159 - 4008) < (2163 - 879))) then
					if (v88.Fireblood:IsCastable() or ((3789 - 1939) == (403 + 1126))) then
						if (((479 + 342) < (2192 - (10 + 59))) and v23(v88.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((256 + 646) < (11450 - 9125)) and v88.AncestralCall:IsCastable()) then
						if (((2021 - (671 + 492)) <= (2358 + 604)) and v23(v88.AncestralCall)) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
			end
		end
		if ((v86 and v88.TimeWarp:IsReady() and v88.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) or ((5161 - (369 + 846)) < (341 + 947))) then
			if (v23(v88.TimeWarp, nil, nil, true) or ((2767 + 475) == (2512 - (1036 + 909)))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v74 < v122) or ((674 + 173) >= (2120 - 857))) then
			if ((v81 and ((v34 and v82) or not v82)) or ((2456 - (11 + 192)) == (936 + 915))) then
				local v228 = 175 - (135 + 40);
				while true do
					if ((v228 == (0 - 0)) or ((1258 + 829) > (5225 - 2853))) then
						v31 = v139();
						if (v31 or ((6663 - 2218) < (4325 - (50 + 126)))) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v145()
		local v170 = 0 - 0;
		while true do
			if ((v170 == (2 + 3)) or ((3231 - (1233 + 180)) == (1054 - (522 + 447)))) then
				if (((2051 - (107 + 1314)) < (988 + 1139)) and v88.Scorch:IsReady() and v46 and v134() and (v15:DebuffRemains(v88.ImprovedScorchDebuff) < ((11 - 7) * v123)) and (v126 < v98)) then
					if (v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch)) or ((824 + 1114) == (4991 - 2477))) then
						return "scorch combustion_phase 36";
					end
				end
				if (((16835 - 12580) >= (1965 - (716 + 1194))) and v88.PhoenixFlames:IsCastable() and v44 and v14:HasTier(1 + 29, 1 + 1) and (v88.PhoenixFlames:TravelTime() < v14:BuffRemains(v88.CombustionBuff)) and ((v27(v14:BuffUp(v88.HeatingUpBuff)) + v138()) < (505 - (74 + 429))) and ((v15:DebuffRemains(v88.CharringEmbersDebuff) < ((7 - 3) * v123)) or (v14:BuffStack(v88.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v88.FlamesFuryBuff))) then
					if (((6864 - 3865) > (818 + 338)) and v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((7244 - 4894) > (2855 - 1700)) and v88.Fireball:IsReady() and v40 and (v14:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime()) and v14:BuffUp(v88.FlameAccelerantBuff)) then
					if (((4462 - (279 + 154)) <= (5631 - (454 + 324))) and v23(v88.Fireball, not v15:IsSpellInRange(v88.Fireball))) then
						return "fireball combustion_phase 40";
					end
				end
				if ((v88.PhoenixFlames:IsCastable() and v44 and not v14:HasTier(24 + 6, 19 - (12 + 5)) and not v88.AlexstraszasFury:IsAvailable() and (v88.PhoenixFlames:TravelTime() < v14:BuffRemains(v88.CombustionBuff)) and ((v27(v14:BuffUp(v88.HeatingUpBuff)) + v138()) < (2 + 0))) or ((1314 - 798) > (1269 + 2165))) then
					if (((5139 - (277 + 816)) >= (12960 - 9927)) and v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v170 = 1189 - (1058 + 125);
			end
			if ((v170 == (1 + 0)) or ((3694 - (815 + 160)) <= (6208 - 4761))) then
				if ((v88.PhoenixFlames:IsCastable() and v44 and v14:BuffDown(v88.CombustionBuff) and v14:HasTier(71 - 41, 1 + 1) and not v88.PhoenixFlames:InFlight() and (v15:DebuffRemains(v88.CharringEmbersDebuff) < ((11 - 7) * v123)) and v14:BuffDown(v88.HotStreakBuff)) or ((6032 - (41 + 1857)) < (5819 - (1222 + 671)))) then
					if (v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames)) or ((423 - 259) >= (4002 - 1217))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v143();
				if (v31 or ((1707 - (229 + 953)) == (3883 - (1111 + 663)))) then
					return v31;
				end
				if (((1612 - (874 + 705)) == (5 + 28)) and v88.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v122) and (v138() == (0 + 0)) and v118 and (v108 <= (0 - 0)) and ((v14:IsCasting(v88.Scorch) and (v88.Scorch:ExecuteRemains() < v103)) or (v14:IsCasting(v88.Fireball) and (v88.Fireball:ExecuteRemains() < v103)) or (v14:IsCasting(v88.Pyroblast) and (v88.Pyroblast:ExecuteRemains() < v103)) or (v14:IsCasting(v88.Flamestrike) and (v88.Flamestrike:ExecuteRemains() < v103)) or (v88.Meteor:InFlight() and (v88.Meteor:InFlightRemains() < v103)))) then
					if (((86 + 2968) <= (4694 - (642 + 37))) and v23(v88.Combustion, not v15:IsInRange(10 + 30), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				v170 = 1 + 1;
			end
			if (((4697 - 2826) < (3836 - (233 + 221))) and (v170 == (4 - 2))) then
				if (((1139 + 154) <= (3707 - (718 + 823))) and v33 and v88.Flamestrike:IsReady() and v41 and not v14:IsCasting(v88.Flamestrike) and v118 and v14:BuffUp(v88.FuryoftheSunKingBuff) and (v14:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v88.Combustion:CooldownRemains() < v88.Flamestrike:CastTime()) and (v124 >= v99)) then
					if (v23(v90.FlamestrikeCursor, not v15:IsInRange(26 + 14)) or ((3384 - (266 + 539)) < (347 - 224))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and not v14:IsCasting(v88.Pyroblast) and v118 and v14:BuffUp(v88.FuryoftheSunKingBuff) and (v14:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) or ((2071 - (636 + 589)) >= (5620 - 3252))) then
					if (v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast)) or ((8274 - 4262) <= (2662 + 696))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((543 + 951) <= (4020 - (657 + 358))) and v88.Fireball:IsReady() and v40 and v118 and (v88.Combustion:CooldownRemains() < v88.Fireball:CastTime()) and (v124 < (4 - 2)) and not v134()) then
					if (v23(v88.Fireball, not v15:IsSpellInRange(v88.Fireball)) or ((7087 - 3976) == (3321 - (1151 + 36)))) then
						return "fireball combustion_phase 16";
					end
				end
				if (((2275 + 80) == (620 + 1735)) and v88.Scorch:IsReady() and v46 and v118 and (v88.Combustion:CooldownRemains() < v88.Scorch:CastTime())) then
					if (v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch)) or ((1755 - 1167) <= (2264 - (1552 + 280)))) then
						return "scorch combustion_phase 18";
					end
				end
				v170 = 837 - (64 + 770);
			end
			if (((3257 + 1540) >= (8841 - 4946)) and ((0 + 0) == v170)) then
				if (((4820 - (157 + 1086)) == (7159 - 3582)) and v88.LightsJudgment:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) then
					if (((16616 - 12822) > (5664 - 1971)) and v23(v88.LightsJudgment, not v15:IsSpellInRange(v88.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if ((v88.BagofTricks:IsCastable() and v80 and ((v83 and v34) or not v83) and (v74 < v122) and v118) or ((1739 - 464) == (4919 - (599 + 220)))) then
					if (v23(v88.BagofTricks) or ((3168 - 1577) >= (5511 - (1813 + 118)))) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if (((719 + 264) <= (3025 - (841 + 376))) and v88.LivingBomb:IsReady() and v33 and v42 and (v125 > (1 - 0)) and v118) then
					if (v23(v88.LivingBomb, not v15:IsSpellInRange(v88.LivingBomb)) or ((500 + 1650) <= (3267 - 2070))) then
						return "living_bomb combustion_phase 6";
					end
				end
				if (((4628 - (464 + 395)) >= (3010 - 1837)) and ((v14:BuffRemains(v88.CombustionBuff) > v105) or (v122 < (10 + 10)))) then
					local v229 = 837 - (467 + 370);
					while true do
						if (((3068 - 1583) == (1091 + 394)) and (v229 == (0 - 0))) then
							v31 = v144();
							if (v31 or ((518 + 2797) <= (6472 - 3690))) then
								return v31;
							end
							break;
						end
					end
				end
				v170 = 521 - (150 + 370);
			end
			if ((v170 == (1286 - (74 + 1208))) or ((2154 - 1278) >= (14057 - 11093))) then
				if ((v88.Pyroblast:IsReady() and v45 and v14:PrevGCDP(1 + 0, v88.Scorch) and v14:BuffUp(v88.HeatingUpBuff) and (v124 < v98) and v117) or ((2622 - (14 + 376)) > (4330 - 1833))) then
					if (v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast)) or ((1366 + 744) <= (292 + 40))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((3516 + 170) > (9294 - 6122)) and v88.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v122) and v117 and (v88.FireBlast:Charges() == (0 + 0)) and ((v88.PhoenixFlames:Charges() < v88.PhoenixFlames:MaxCharges()) or v88.AlexstraszasFury:IsAvailable()) and (v102 <= v124)) then
					if (v23(v88.ShiftingPower, not v15:IsInRange(118 - (23 + 55))) or ((10602 - 6128) < (548 + 272))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if (((3843 + 436) >= (4468 - 1586)) and v33 and v88.Flamestrike:IsReady() and v41 and not v14:IsCasting(v88.Flamestrike) and v14:BuffUp(v88.FuryoftheSunKingBuff) and (v14:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Flamestrike:CastTime()) and (v124 >= v99)) then
					if (v23(v90.FlamestrikeCursor, not v15:IsInRange(13 + 27)) or ((2930 - (652 + 249)) >= (9422 - 5901))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and not v14:IsCasting(v88.Pyroblast) and v14:BuffUp(v88.FuryoftheSunKingBuff) and (v14:BuffRemains(v88.FuryoftheSunKingBuff) > v88.Pyroblast:CastTime())) or ((3905 - (708 + 1160)) >= (12600 - 7958))) then
					if (((3135 - 1415) < (4485 - (10 + 17))) and v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v170 = 2 + 3;
			end
			if ((v170 == (1735 - (1400 + 332))) or ((836 - 400) > (4929 - (242 + 1666)))) then
				if (((306 + 407) <= (311 + 536)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (not v134() or v14:IsCasting(v88.Scorch) or (v15:DebuffRemains(v88.ImprovedScorchDebuff) > ((4 + 0) * v123))) and (v14:BuffDown(v88.FuryoftheSunKingBuff) or v14:IsCasting(v88.Pyroblast)) and v117 and v14:BuffDown(v88.HyperthermiaBuff) and v14:BuffDown(v88.HotStreakBuff) and ((v138() + (v27(v14:BuffUp(v88.HeatingUpBuff)) * v27(v14:GCDRemains() > (940 - (850 + 90))))) < (3 - 1))) then
					if (((3544 - (360 + 1030)) <= (3568 + 463)) and v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((13025 - 8410) == (6349 - 1734)) and v33 and v88.Flamestrike:IsReady() and v41 and ((v14:BuffUp(v88.HotStreakBuff) and (v124 >= v98)) or (v14:BuffUp(v88.HyperthermiaBuff) and (v124 >= (v98 - v27(v88.Hyperthermia:IsAvailable())))))) then
					if (v23(v90.FlamestrikeCursor, not v15:IsInRange(1701 - (909 + 752))) or ((5013 - (109 + 1114)) == (915 - 415))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if (((35 + 54) < (463 - (6 + 236))) and v88.Pyroblast:IsReady() and v45 and (v14:BuffUp(v88.HyperthermiaBuff))) then
					if (((1295 + 759) >= (1144 + 277)) and v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if (((1631 - 939) < (5340 - 2282)) and v88.Pyroblast:IsReady() and v45 and v14:BuffUp(v88.HotStreakBuff) and v117) then
					if (v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast)) or ((4387 - (1076 + 57)) == (273 + 1382))) then
						return "pyroblast combustion_phase 26";
					end
				end
				v170 = 693 - (579 + 110);
			end
			if ((v170 == (1 + 5)) or ((1146 + 150) == (2606 + 2304))) then
				if (((3775 - (174 + 233)) == (9407 - 6039)) and v88.Scorch:IsReady() and v46 and (v14:BuffRemains(v88.CombustionBuff) > v88.Scorch:CastTime()) and (v88.Scorch:CastTime() >= v123)) then
					if (((4638 - 1995) < (1697 + 2118)) and v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((3087 - (663 + 511)) > (440 + 53)) and v88.Fireball:IsReady() and v40 and (v14:BuffRemains(v88.CombustionBuff) > v88.Fireball:CastTime())) then
					if (((1033 + 3722) > (10568 - 7140)) and v23(v88.Fireball, not v15:IsSpellInRange(v88.Fireball))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((837 + 544) <= (5577 - 3208)) and v88.LivingBomb:IsReady() and v42 and (v14:BuffRemains(v88.CombustionBuff) < v123) and (v125 > (2 - 1))) then
					if (v23(v88.LivingBomb, not v15:IsSpellInRange(v88.LivingBomb)) or ((2311 + 2532) == (7948 - 3864))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
		end
	end
	local function v146()
		local v171 = 0 + 0;
		while true do
			if (((427 + 4242) > (1085 - (478 + 244))) and (v171 == (517 - (440 + 77)))) then
				v113 = v88.Combustion:CooldownRemains() * v109;
				v114 = ((v88.Fireball:CastTime() * v27(v124 < v98)) + (v88.Flamestrike:CastTime() * v27(v124 >= v98))) - v103;
				v171 = 1 + 0;
			end
			if ((v171 == (7 - 5)) or ((3433 - (655 + 901)) >= (582 + 2556))) then
				if (((3631 + 1111) >= (2449 + 1177)) and v88.SunKingsBlessing:IsAvailable() and v131() and v14:BuffDown(v88.FuryoftheSunKingBuff)) then
					v108 = v29((v115 - v14:BuffStack(v88.SunKingsBlessingBuff)) * (11 - 8) * v123, v108);
				end
				v108 = v29(v14:BuffRemains(v88.CombustionBuff), v108);
				v171 = 1448 - (695 + 750);
			end
			if ((v171 == (3 - 2)) or ((7006 - 2466) == (3683 - 2767))) then
				v108 = v113;
				if ((v88.Firestarter:IsAvailable() and not v95) or ((1507 - (285 + 66)) > (10128 - 5783))) then
					v108 = v29(v132(), v108);
				end
				v171 = 1312 - (682 + 628);
			end
			if (((361 + 1876) < (4548 - (176 + 123))) and (v171 == (2 + 1))) then
				if (((v113 + ((88 + 32) * ((270 - (239 + 30)) - ((0.4 + 0 + ((0.2 + 0) * v27(v88.Firestarter:IsAvailable()))) * v27(v88.Kindling:IsAvailable()))))) <= v108) or (v108 > (v122 - (35 - 15))) or ((8370 - 5687) < (338 - (306 + 9)))) then
					v108 = v113;
				end
				break;
			end
		end
	end
	local function v147()
		if (((2432 - 1735) <= (144 + 682)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and v14:BuffDown(v88.HotStreakBuff) and ((v27(v14:BuffUp(v88.HeatingUpBuff)) + v138()) == (1 + 0)) and (v88.ShiftingPower:CooldownUp() or (v88.FireBlast:Charges() > (1 + 0)) or (v14:BuffRemains(v88.FeeltheBurnBuff) < ((5 - 3) * v123)))) then
			if (((2480 - (1140 + 235)) <= (749 + 427)) and v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if (((3099 + 280) <= (979 + 2833)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and ((v27(v14:BuffUp(v88.HeatingUpBuff)) + v138()) == (53 - (33 + 19))) and v88.ShiftingPower:CooldownUp() and (not v14:HasTier(11 + 19, 5 - 3) or (v15:DebuffRemains(v88.CharringEmbersDebuff) > ((1 + 1) * v123)))) then
			if (v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true) or ((1545 - 757) >= (1516 + 100))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v148()
		local v172 = 689 - (586 + 103);
		while true do
			if (((169 + 1685) <= (10402 - 7023)) and (v172 == (1491 - (1309 + 179)))) then
				if (((8211 - 3662) == (1980 + 2569)) and v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and v14:BuffDown(v88.HotStreakBuff) and (v138() == (0 - 0)) and ((not v111 and v14:BuffUp(v88.FlamesFuryBuff)) or (v88.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v88.PhoenixFlames:ChargesFractional() > (1.5 - 0)) and (not v88.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v88.FeeltheBurnBuff) < ((5 - 2) * v123)))))) then
					if (v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames)) or ((3631 - (295 + 314)) >= (7427 - 4403))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v143();
				if (((6782 - (1300 + 662)) > (6901 - 4703)) and v31) then
					return v31;
				end
				if ((v33 and v88.DragonsBreath:IsReady() and v38 and (v126 > (1756 - (1178 + 577))) and v88.AlexstraszasFury:IsAvailable()) or ((552 + 509) >= (14458 - 9567))) then
					if (((2769 - (851 + 554)) <= (3956 + 517)) and v23(v88.DragonsBreath, not v15:IsInRange(27 - 17))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v172 = 8 - 4;
			end
			if ((v172 == (303 - (115 + 187))) or ((2754 + 841) <= (3 + 0))) then
				if ((v88.Pyroblast:IsReady() and v45 and not v14:IsCasting(v88.Pyroblast) and (v14:BuffUp(v88.FuryoftheSunKingBuff))) or ((18410 - 13738) == (5013 - (160 + 1001)))) then
					if (((1364 + 195) == (1076 + 483)) and v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast), true)) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v88.FireBlast:IsReady() and v39 and not v136() and not v131() and not v112 and v14:BuffDown(v88.FuryoftheSunKingBuff) and ((((v14:IsCasting(v88.Fireball) and ((v88.Fireball:ExecuteRemains() < (0.5 - 0)) or not v88.Hyperthermia:IsAvailable())) or (v14:IsCasting(v88.Pyroblast) and ((v88.Pyroblast:ExecuteRemains() < (358.5 - (237 + 121))) or not v88.Hyperthermia:IsAvailable()))) and v14:BuffUp(v88.HeatingUpBuff)) or (v133() and (not v134() or (v15:DebuffStack(v88.ImprovedScorchDebuff) == v116) or (v88.FireBlast:FullRechargeTime() < (900 - (525 + 372)))) and ((v14:BuffUp(v88.HeatingUpBuff) and not v14:IsCasting(v88.Scorch)) or (v14:BuffDown(v88.HotStreakBuff) and v14:BuffDown(v88.HeatingUpBuff) and v14:IsCasting(v88.Scorch) and (v138() == (0 - 0))))))) or ((5756 - 4004) <= (930 - (96 + 46)))) then
					if (v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true) or ((4684 - (643 + 134)) == (64 + 113))) then
						return "fire_blast standard_rotation 16";
					end
				end
				if (((8320 - 4850) > (2060 - 1505)) and v88.Pyroblast:IsReady() and v45 and (v14:IsCasting(v88.Scorch) or v14:PrevGCDP(1 + 0, v88.Scorch)) and v14:BuffUp(v88.HeatingUpBuff) and v133() and (v124 < v96)) then
					if (v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast), true) or ((1907 - 935) == (1318 - 673))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((3901 - (316 + 403)) >= (1406 + 709)) and v88.Scorch:IsReady() and v46 and v134() and (v15:DebuffRemains(v88.ImprovedScorchDebuff) < ((10 - 6) * v123))) then
					if (((1407 + 2486) < (11153 - 6724)) and v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch))) then
						return "scorch standard_rotation 19";
					end
				end
				v172 = 2 + 0;
			end
			if (((1 + 1) == v172) or ((9933 - 7066) < (9097 - 7192))) then
				if ((v88.PhoenixFlames:IsCastable() and v44 and v88.AlexstraszasFury:IsAvailable() and (not v88.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v88.FeeltheBurnBuff) < ((3 - 1) * v123)))) or ((103 + 1693) >= (7974 - 3923))) then
					if (((80 + 1539) <= (11050 - 7294)) and v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((621 - (12 + 5)) == (2345 - 1741)) and v88.PhoenixFlames:IsCastable() and v44 and v14:HasTier(64 - 34, 3 - 1) and (v15:DebuffRemains(v88.CharringEmbersDebuff) < ((4 - 2) * v123)) and v14:BuffDown(v88.HotStreakBuff)) then
					if (v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames)) or ((911 + 3573) == (2873 - (1656 + 317)))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v134() and (v15:DebuffStack(v88.ImprovedScorchDebuff) < v116)) or ((3974 + 485) <= (892 + 221))) then
					if (((9657 - 6025) > (16723 - 13325)) and v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch))) then
						return "scorch standard_rotation 22";
					end
				end
				if (((4436 - (5 + 349)) <= (23354 - 18437)) and v88.PhoenixFlames:IsCastable() and v44 and not v88.AlexstraszasFury:IsAvailable() and v14:BuffDown(v88.HotStreakBuff) and not v111 and v14:BuffUp(v88.FlamesFuryBuff)) then
					if (((6103 - (266 + 1005)) >= (914 + 472)) and v23(v88.PhoenixFlames, not v15:IsSpellInRange(v88.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v172 = 10 - 7;
			end
			if (((179 - 42) == (1833 - (561 + 1135))) and (v172 == (0 - 0))) then
				if ((v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v96) and v136()) or ((5160 - 3590) >= (5398 - (507 + 559)))) then
					if (v23(v90.FlamestrikeCursor, not v15:IsInRange(100 - 60)) or ((12568 - 8504) <= (2207 - (212 + 176)))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v88.Pyroblast:IsReady() and v45 and (v136())) or ((5891 - (250 + 655)) < (4292 - 2718))) then
					if (((7733 - 3307) > (268 - 96)) and v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((2542 - (1869 + 87)) > (1578 - 1123)) and v33 and v88.Flamestrike:IsReady() and v41 and not v14:IsCasting(v88.Flamestrike) and (v124 >= v99) and v14:BuffUp(v88.FuryoftheSunKingBuff)) then
					if (((2727 - (484 + 1417)) == (1770 - 944)) and v23(v90.FlamestrikeCursor, not v15:IsInRange(67 - 27))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v88.Scorch:IsReady() and v46 and v134() and (v15:DebuffRemains(v88.ImprovedScorchDebuff) < (v88.Pyroblast:CastTime() + ((778 - (48 + 725)) * v123))) and v14:BuffUp(v88.FuryoftheSunKingBuff) and not v14:IsCasting(v88.Scorch)) or ((6564 - 2545) > (11914 - 7473))) then
					if (((1173 + 844) < (11387 - 7126)) and v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch))) then
						return "scorch standard_rotation 13";
					end
				end
				v172 = 1 + 0;
			end
			if (((1375 + 3341) > (933 - (152 + 701))) and (v172 == (1316 - (430 + 881)))) then
				if ((v88.Fireball:IsReady() and v40 and not v136()) or ((1344 + 2163) == (4167 - (557 + 338)))) then
					if (v23(v88.Fireball, not v15:IsSpellInRange(v88.Fireball), true) or ((259 + 617) >= (8665 - 5590))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((15239 - 10887) > (6785 - 4231)) and (v172 == (8 - 4))) then
				if ((v88.Scorch:IsReady() and v46 and (v133())) or ((5207 - (499 + 302)) < (4909 - (39 + 827)))) then
					if (v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch)) or ((5214 - 3325) >= (7555 - 4172))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((7514 - 5622) <= (4197 - 1463)) and v33 and v88.ArcaneExplosion:IsReady() and v36 and (v127 >= v100) and (v14:ManaPercentageP() >= v101)) then
					if (((165 + 1758) < (6491 - 4273)) and v23(v88.ArcaneExplosion, not v15:IsInRange(2 + 6))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if (((3438 - 1265) > (483 - (103 + 1))) and v33 and v88.Flamestrike:IsReady() and v41 and (v124 >= v97)) then
					if (v23(v90.FlamestrikeCursor, not v15:IsInRange(594 - (475 + 79))) or ((5601 - 3010) == (10908 - 7499))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((584 + 3930) > (2926 + 398)) and v88.Pyroblast:IsReady() and v45 and v88.TemperedFlames:IsAvailable() and v14:BuffDown(v88.FlameAccelerantBuff)) then
					if (v23(v88.Pyroblast, not v15:IsSpellInRange(v88.Pyroblast), true) or ((1711 - (1395 + 108)) >= (14049 - 9221))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v172 = 1209 - (7 + 1197);
			end
		end
	end
	local function v149()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (1 + 1)) or ((1902 - (27 + 292)) > (10452 - 6885))) then
				if ((not v112 and v88.SunKingsBlessing:IsAvailable()) or ((1673 - 360) == (3329 - 2535))) then
					v112 = v133() and (v88.FireBlast:FullRechargeTime() > ((5 - 2) * v123));
				end
				if (((6044 - 2870) > (3041 - (43 + 96))) and v88.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v122) and v118 and ((v88.FireBlast:Charges() == (0 - 0)) or v112) and (not v134() or ((v15:DebuffRemains(v88.ImprovedScorchDebuff) > (v88.ShiftingPower:CastTime() + v88.Scorch:CastTime())) and v14:BuffDown(v88.FuryoftheSunKingBuff))) and v14:BuffDown(v88.HotStreakBuff) and v110) then
					if (((9314 - 5194) <= (3535 + 725)) and v23(v88.ShiftingPower, not v15:IsInRange(12 + 28), true)) then
						return "shifting_power main 12";
					end
				end
				if ((v124 < v98) or ((1745 - 862) > (1832 + 2946))) then
					v111 = (v88.SunKingsBlessing:IsAvailable() or (((v108 + (12 - 5)) < ((v88.PhoenixFlames:FullRechargeTime() + v88.PhoenixFlames:Cooldown()) - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
				end
				v173 = 1 + 2;
			end
			if ((v173 == (1 + 4)) or ((5371 - (1414 + 337)) >= (6831 - (1642 + 298)))) then
				if (((11099 - 6841) > (2695 - 1758)) and v88.Scorch:IsReady() and v46) then
					if (v23(v88.Scorch, not v15:IsSpellInRange(v88.Scorch)) or ((14448 - 9579) < (299 + 607))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v173 == (3 + 0)) or ((2197 - (357 + 615)) > (2968 + 1260))) then
				if (((8165 - 4837) > (1918 + 320)) and (v124 >= v98)) then
					v111 = (v88.SunKingsBlessing:IsAvailable() or ((v108 < (v88.PhoenixFlames:FullRechargeTime() - (v135() * v27(v110)))) and (v108 < v122))) and not v88.AlexstraszasFury:IsAvailable();
				end
				if (((8226 - 4387) > (1124 + 281)) and v88.FireBlast:IsReady() and v39 and not v136() and not v112 and (v108 > (0 + 0)) and (v124 >= v97) and not v131() and v14:BuffDown(v88.HotStreakBuff) and ((v14:BuffUp(v88.HeatingUpBuff) and (v88.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v88.FireBlast:ChargesFractional() >= (1303 - (384 + 917))))) then
					if (v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true) or ((1990 - (128 + 569)) <= (2050 - (1407 + 136)))) then
						return "fire_blast main 14";
					end
				end
				if ((v118 and v131() and (v108 > (1887 - (687 + 1200)))) or ((4606 - (556 + 1154)) < (2831 - 2026))) then
					v31 = v147();
					if (((2411 - (9 + 86)) == (2737 - (275 + 146))) and v31) then
						return v31;
					end
				end
				v173 = 1 + 3;
			end
			if ((v173 == (65 - (29 + 35))) or ((11390 - 8820) == (4578 - 3045))) then
				v110 = v108 > v88.ShiftingPower:CooldownRemains();
				v112 = v118 and (((v88.FireBlast:ChargesFractional() + ((v108 + (v135() * v27(v110))) / v88.FireBlast:Cooldown())) - (4 - 3)) < ((v88.FireBlast:MaxCharges() + (v104 / v88.FireBlast:Cooldown())) - (((8 + 4) / v88.FireBlast:Cooldown()) % (1013 - (53 + 959))))) and (v108 < v122);
				if ((not v94 and ((v108 <= (408 - (312 + 96))) or v117 or ((v108 < v114) and (v88.Combustion:CooldownRemains() < v114)))) or ((1532 - 649) == (1745 - (147 + 138)))) then
					local v230 = 899 - (813 + 86);
					while true do
						if ((v230 == (0 + 0)) or ((8557 - 3938) <= (1491 - (18 + 474)))) then
							v31 = v145();
							if (v31 or ((1151 + 2259) > (13434 - 9318))) then
								return v31;
							end
							break;
						end
					end
				end
				v173 = 1088 - (860 + 226);
			end
			if ((v173 == (307 - (121 + 182))) or ((112 + 791) >= (4299 - (988 + 252)))) then
				if ((v88.FireBlast:IsReady() and v39 and not v136() and v14:IsCasting(v88.ShiftingPower) and (v88.FireBlast:FullRechargeTime() < v120)) or ((450 + 3526) < (895 + 1962))) then
					if (((6900 - (49 + 1921)) > (3197 - (223 + 667))) and v23(v88.FireBlast, not v15:IsSpellInRange(v88.FireBlast), nil, true)) then
						return "fire_blast main 16";
					end
				end
				if (((v108 > (52 - (51 + 1))) and v118) or ((6963 - 2917) < (2764 - 1473))) then
					local v231 = 1125 - (146 + 979);
					while true do
						if (((0 + 0) == v231) or ((4846 - (311 + 294)) == (9885 - 6340))) then
							v31 = v148();
							if (v31 or ((1715 + 2333) > (5675 - (496 + 947)))) then
								return v31;
							end
							break;
						end
					end
				end
				if ((v88.IceNova:IsCastable() and not v133()) or ((3108 - (1233 + 125)) >= (1410 + 2063))) then
					if (((2841 + 325) == (602 + 2564)) and v23(v88.IceNova, not v15:IsSpellInRange(v88.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v173 = 1650 - (963 + 682);
			end
			if (((1472 + 291) < (5228 - (504 + 1000))) and (v173 == (0 + 0))) then
				if (((52 + 5) <= (257 + 2466)) and not v94) then
					v146();
				end
				if ((v34 and v86 and v88.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v88.TemporalWarp:IsAvailable() and (v131() or (v122 < (58 - 18)))) or ((1769 + 301) == (258 + 185))) then
					if (v23(v88.TimeWarp, not v15:IsInRange(222 - (156 + 26))) or ((1559 + 1146) == (2178 - 785))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v74 < v122) or ((4765 - (149 + 15)) < (1021 - (890 + 70)))) then
					if ((v81 and ((v34 and v82) or not v82)) or ((1507 - (39 + 78)) >= (5226 - (14 + 468)))) then
						local v235 = 0 - 0;
						while true do
							if ((v235 == (0 - 0)) or ((1034 + 969) > (2303 + 1531))) then
								v31 = v139();
								if (v31 or ((34 + 122) > (1768 + 2145))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				v173 = 1 + 0;
			end
		end
	end
	local function v150()
		local v174 = 0 - 0;
		while true do
			if (((193 + 2) == (685 - 490)) and (v174 == (1 + 2))) then
				v48 = EpicSettings.Settings['useBlastWave'];
				v49 = EpicSettings.Settings['useCombustion'];
				v50 = EpicSettings.Settings['useShiftingPower'];
				v51 = EpicSettings.Settings['combustionWithCD'];
				v174 = 55 - (12 + 39);
			end
			if (((2889 + 216) >= (5559 - 3763)) and (v174 == (21 - 15))) then
				v60 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
				v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v63 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v174 = 33 - 26;
			end
			if (((6089 - (1596 + 114)) >= (5563 - 3432)) and (v174 == (715 - (164 + 549)))) then
				v44 = EpicSettings.Settings['usePhoenixFlames'];
				v45 = EpicSettings.Settings['usePyroblast'];
				v46 = EpicSettings.Settings['useScorch'];
				v47 = EpicSettings.Settings['useCounterspell'];
				v174 = 1441 - (1059 + 379);
			end
			if (((4772 - 928) >= (1059 + 984)) and (v174 == (2 + 5))) then
				v64 = EpicSettings.Settings['iceColdHP'] or (392 - (145 + 247));
				v65 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v66 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v84 = EpicSettings.Settings['mirrorImageBeforePull'];
				v174 = 23 - 15;
			end
			if (((1 + 4) == v174) or ((2784 + 448) <= (4434 - 1703))) then
				v56 = EpicSettings.Settings['useIceBlock'];
				v57 = EpicSettings.Settings['useIceCold'];
				v59 = EpicSettings.Settings['useMassBarrier'];
				v58 = EpicSettings.Settings['useMirrorImage'];
				v174 = 726 - (254 + 466);
			end
			if (((5465 - (544 + 16)) == (15588 - 10683)) and (v174 == (636 - (294 + 334)))) then
				v85 = EpicSettings.Settings['useSpellStealTarget'];
				v86 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v87 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((253 - (236 + 17)) == v174) or ((1783 + 2353) >= (3434 + 977))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v39 = EpicSettings.Settings['useFireBlast'];
				v174 = 3 - 2;
			end
			if ((v174 == (18 - 14)) or ((1523 + 1435) == (3309 + 708))) then
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['useAlterTime'];
				v54 = EpicSettings.Settings['useBlazingBarrier'];
				v55 = EpicSettings.Settings['useGreaterInvisibility'];
				v174 = 799 - (413 + 381);
			end
			if (((52 + 1176) >= (1728 - 915)) and (v174 == (2 - 1))) then
				v40 = EpicSettings.Settings['useFireball'];
				v41 = EpicSettings.Settings['useFlamestrike'];
				v42 = EpicSettings.Settings['useLivingBomb'];
				v43 = EpicSettings.Settings['useMeteor'];
				v174 = 1972 - (582 + 1388);
			end
		end
	end
	local function v151()
		local v175 = 0 - 0;
		while true do
			if (((2 + 0) == v175) or ((3819 - (326 + 38)) > (11980 - 7930))) then
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v175 = 3 - 0;
			end
			if (((863 - (47 + 573)) == (86 + 157)) and (v175 == (16 - 12))) then
				v78 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v77 = EpicSettings.Settings['healingPotionHP'] or (1664 - (1269 + 395));
				v79 = EpicSettings.Settings['HealingPotionName'] or "";
				v175 = 497 - (76 + 416);
			end
			if ((v175 == (446 - (319 + 124))) or ((619 - 348) > (2579 - (564 + 443)))) then
				v83 = EpicSettings.Settings['racialsWithCD'];
				v76 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v175 = 10 - 6;
			end
			if (((3197 - (337 + 121)) < (9648 - 6355)) and (v175 == (3 - 2))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v67 = EpicSettings.Settings['DispelBuffs'];
				v175 = 1913 - (1261 + 650);
			end
			if ((v175 == (0 + 0)) or ((6281 - 2339) < (2951 - (772 + 1045)))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v175 = 145 - (102 + 42);
			end
			if ((v175 == (1849 - (1524 + 320))) or ((3963 - (1049 + 221)) == (5129 - (18 + 138)))) then
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v152()
		local v176 = 0 - 0;
		while true do
			if (((3248 - (67 + 1035)) == (2494 - (136 + 212))) and (v176 == (4 - 3))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v176 = 2 + 0;
			end
			if ((v176 == (3 + 0)) or ((3848 - (240 + 1364)) == (4306 - (1050 + 32)))) then
				if (v33 or ((17510 - 12606) <= (1134 + 782))) then
					v124 = v29(v15:GetEnemiesInSplashRangeCount(1060 - (331 + 724)), #v128);
					v125 = v29(v15:GetEnemiesInSplashRangeCount(1 + 4), #v128);
					v126 = v29(v15:GetEnemiesInSplashRangeCount(649 - (269 + 375)), #v128);
					v127 = #v128;
				else
					local v232 = 725 - (267 + 458);
					while true do
						if (((28 + 62) <= (2048 - 983)) and (v232 == (818 - (667 + 151)))) then
							v124 = 1498 - (1410 + 87);
							v125 = 1898 - (1504 + 393);
							v232 = 2 - 1;
						end
						if (((12458 - 7656) == (5598 - (461 + 335))) and (v232 == (1 + 0))) then
							v126 = 1762 - (1730 + 31);
							v127 = 1668 - (728 + 939);
							break;
						end
					end
				end
				if (v92.TargetIsValid() or v14:AffectingCombat() or ((8074 - 5794) <= (1036 - 525))) then
					local v233 = 0 - 0;
					while true do
						if ((v233 == (1068 - (138 + 930))) or ((1532 + 144) <= (362 + 101))) then
							if (((3316 + 553) == (15797 - 11928)) and (v14:AffectingCombat() or v68)) then
								local v236 = 1766 - (459 + 1307);
								local v237;
								while true do
									if (((3028 - (474 + 1396)) <= (4562 - 1949)) and (v236 == (1 + 0))) then
										if (v31 or ((8 + 2356) <= (5725 - 3726))) then
											return v31;
										end
										break;
									end
									if ((v236 == (0 + 0)) or ((16430 - 11508) < (846 - 652))) then
										v237 = v68 and v88.RemoveCurse:IsReady() and v35;
										v31 = v92.FocusUnit(v237, v90, 611 - (562 + 29), nil, 18 + 2);
										v236 = 1420 - (374 + 1045);
									end
								end
							end
							v121 = v10.BossFightRemains(nil, true);
							v233 = 1 + 0;
						end
						if ((v233 == (5 - 3)) or ((2729 - (448 + 190)) < (11 + 20))) then
							v130 = v137(v128);
							v94 = not v34;
							v233 = 2 + 1;
						end
						if ((v233 == (2 + 1)) or ((9342 - 6912) >= (15138 - 10266))) then
							if (v94 or ((6264 - (1307 + 187)) < (6880 - 5145))) then
								v108 = 234139 - 134140;
							end
							v123 = v14:GCD();
							v233 = 11 - 7;
						end
						if ((v233 == (687 - (232 + 451))) or ((4239 + 200) <= (2076 + 274))) then
							v117 = v14:BuffUp(v88.CombustionBuff);
							v118 = not v117;
							break;
						end
						if ((v233 == (565 - (510 + 54))) or ((9023 - 4544) < (4502 - (13 + 23)))) then
							v122 = v121;
							if (((4964 - 2417) > (1759 - 534)) and (v122 == (20187 - 9076))) then
								v122 = v10.FightRemains(v128, false);
							end
							v233 = 1090 - (830 + 258);
						end
					end
				end
				if (((16477 - 11806) > (1674 + 1000)) and not v14:AffectingCombat() and v32) then
					v31 = v142();
					if (v31 or ((3145 + 551) < (4768 - (860 + 581)))) then
						return v31;
					end
				end
				v176 = 14 - 10;
			end
			if (((4 + 0) == v176) or ((4783 - (237 + 4)) == (6980 - 4010))) then
				if (((637 - 385) <= (3747 - 1770)) and v14:AffectingCombat() and v92.TargetIsValid()) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (3 + 1)) or ((5421 - 3985) == (1620 + 2155))) then
							if (v31 or ((881 + 737) < (2356 - (85 + 1341)))) then
								return v31;
							end
							break;
						end
						if (((8058 - 3335) > (11728 - 7575)) and (v234 == (372 - (45 + 327)))) then
							if (v16 or ((6894 - 3240) >= (5156 - (444 + 58)))) then
								if (((414 + 537) <= (258 + 1238)) and v68) then
									v31 = v140();
									if (v31 or ((849 + 887) == (1654 - 1083))) then
										return v31;
									end
								end
							end
							v31 = v141();
							v234 = 1733 - (64 + 1668);
						end
						if ((v234 == (1974 - (1227 + 746))) or ((2753 - 1857) > (8850 - 4081))) then
							if (v31 or ((1539 - (415 + 79)) <= (27 + 993))) then
								return v31;
							end
							if (v69 or ((1651 - (142 + 349)) <= (141 + 187))) then
								if (((5235 - 1427) > (1454 + 1470)) and v87) then
									local v239 = 0 + 0;
									while true do
										if (((10596 - 6705) < (6783 - (1710 + 154))) and (v239 == (318 - (200 + 118)))) then
											v31 = v92.HandleAfflicted(v88.RemoveCurse, v90.RemoveCurseMouseover, 12 + 18);
											if (v31 or ((3905 - 1671) <= (2227 - 725))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v234 = 2 + 0;
						end
						if ((v234 == (2 + 0)) or ((1349 + 1163) < (69 + 363))) then
							if (v70 or ((4003 - 2155) == (2115 - (363 + 887)))) then
								local v238 = 0 - 0;
								while true do
									if ((v238 == (0 - 0)) or ((723 + 3959) <= (10625 - 6084))) then
										v31 = v92.HandleIncorporeal(v88.Polymorph, v90.PolymorphMouseOver, 21 + 9, true);
										if (v31 or ((4690 - (674 + 990)) >= (1160 + 2886))) then
											return v31;
										end
										break;
									end
								end
							end
							if (((822 + 1186) > (1010 - 372)) and v88.Spellsteal:IsAvailable() and v85 and v88.Spellsteal:IsReady() and v35 and v67 and not v14:IsCasting() and not v14:IsChanneling() and v92.UnitHasMagicBuff(v15)) then
								if (((2830 - (507 + 548)) <= (4070 - (289 + 548))) and v23(v88.Spellsteal, not v15:IsSpellInRange(v88.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v234 = 1821 - (821 + 997);
						end
						if (((258 - (195 + 60)) == v234) or ((1222 + 3321) == (3498 - (251 + 1250)))) then
							if (((v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v88.HotStreakBuff)) or ((9087 - 5985) < (501 + 227))) then
								if (((1377 - (809 + 223)) == (503 - 158)) and v23(v90.StopCasting, not v15:IsSpellInRange(v88.Pyroblast))) then
									return "Stop Casting";
								end
							end
							v31 = v149();
							v234 = 11 - 7;
						end
					end
				end
				break;
			end
			if ((v176 == (0 - 0)) or ((2082 + 745) < (198 + 180))) then
				v150();
				v151();
				v32 = EpicSettings.Toggles['ooc'];
				v176 = 618 - (14 + 603);
			end
			if ((v176 == (131 - (118 + 11))) or ((563 + 2913) < (2164 + 433))) then
				if (((8972 - 5893) < (5743 - (551 + 398))) and v14:IsDeadOrGhost()) then
					return v31;
				end
				v129 = v15:GetEnemiesInSplashRange(4 + 1);
				v128 = v14:GetEnemiesInRange(15 + 25);
				v176 = 3 + 0;
			end
		end
	end
	local function v153()
		v93();
		v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(234 - 171, v152, v153);
end;
return v0["Epix_Mage_Fire.lua"]();

