local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5994 - (673 + 1185)) > (6951 - 4554)) and not v5) then
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
		if (v89.RemoveCurse:IsAvailable() or ((13917 - 9583) == (6984 - 2739))) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (3 + 1)) or (747 + 252);
	local v98 = 1348 - 349;
	local v99 = v97;
	local v100 = ((1 + 2) * v27(v89.FueltheFire:IsAvailable())) + ((1991 - 992) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 1960 - 961;
	local v102 = 1920 - (446 + 1434);
	local v103 = 2282 - (1040 + 243);
	local v104 = 0.3 - 0;
	local v105 = 1847 - (559 + 1288);
	local v106 = 1937 - (609 + 1322);
	local v107 = false;
	local v108 = (v107 and (474 - (13 + 441))) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (4 - 3);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 + 0;
	local v115 = 0 - 0;
	local v116 = 3 + 5;
	local v117 = 2 + 1;
	local v118;
	local v119;
	local v120 = v13:BuffRemains(v89.CombustionBuff);
	local v121 = 8 - 5;
	local v122 = 6081 + 5030;
	local v123 = 20435 - 9324;
	local v124;
	local v125, v126, v127, v128;
	local v129, v130;
	local v131;
	v9:RegisterForEvent(function()
		v107 = false;
		v108 = (v107 and (14 + 6)) or (0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (2 + 0)) or ((4184 + 92) <= (3464 - (153 + 280)))) then
				v89.PhoenixFlames:RegisterInFlightEffect(743678 - 486136);
				v89.PhoenixFlames:RegisterInFlight();
				v156 = 3 + 0;
			end
			if ((v156 == (0 + 0)) or ((2503 + 2279) <= (1089 + 110))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v156 = 1 + 0;
			end
			if ((v156 == (4 - 1)) or ((3007 + 1857) < (2569 - (89 + 578)))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if (((3457 + 1382) >= (7692 - 3992)) and (v156 == (1050 - (572 + 477)))) then
				v89.Meteor:RegisterInFlightEffect(47358 + 303782);
				v89.Meteor:RegisterInFlight();
				v156 = 2 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(41914 + 309226);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(257628 - (84 + 2));
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (0 + 0)) or ((1917 - (497 + 345)) > (50 + 1868))) then
				v122 = 1879 + 9232;
				v123 = 12444 - (605 + 728);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v158 = 0 + 0;
		while true do
			if (((880 - 484) <= (175 + 3629)) and (v158 == (3 - 2))) then
				v99 = v97;
				v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (2 - 1);
				break;
			end
			if ((v158 == (0 + 0)) or ((4658 - (457 + 32)) == (928 + 1259))) then
				v96 = v89.SunKingsBlessing:IsAvailable();
				v97 = ((v89.FlamePatch:IsAvailable()) and (1405 - (832 + 570))) or (942 + 57);
				v158 = 1 + 0;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (318 - 228));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (44 + 46)) and v14:TimeToX(886 - (588 + 208))) or (0 - 0))) or (1800 - (884 + 916));
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (62 - 32));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (18 + 12));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v159 = 653 - (232 + 421);
		local v160;
		while true do
			if (((3295 - (1569 + 320)) == (345 + 1061)) and (v159 == (0 + 0))) then
				v160 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 - 0);
				v160 = v160 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(606 - (316 + 289), v89.PhoenixFlames));
				v159 = 2 - 1;
			end
			if (((71 + 1460) < (5724 - (666 + 787))) and (v159 == (426 - (360 + 65)))) then
				return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or (v160 > (0 + 0))))));
			end
		end
	end
	local function v138(v161)
		local v162 = 254 - (79 + 175);
		local v163;
		while true do
			if (((1001 - 366) == (496 + 139)) and (v162 == (0 - 0))) then
				v163 = 0 - 0;
				for v226, v227 in pairs(v161) do
					if (((4272 - (503 + 396)) <= (3737 - (92 + 89))) and v227:DebuffUp(v89.IgniteDebuff)) then
						v163 = v163 + (1 - 0);
					end
				end
				v162 = 1 + 0;
			end
			if (((1 + 0) == v162) or ((12887 - 9596) < (449 + 2831))) then
				return v163;
			end
		end
	end
	local function v139()
		local v164 = 0 - 0;
		local v165;
		while true do
			if (((3827 + 559) >= (417 + 456)) and (v164 == (2 - 1))) then
				return v165;
			end
			if (((115 + 806) <= (1679 - 577)) and (v164 == (1244 - (485 + 759)))) then
				v165 = 0 - 0;
				if (((5895 - (442 + 747)) >= (2098 - (832 + 303))) and (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight())) then
					v165 = v165 + (947 - (88 + 858));
				end
				v164 = 1 + 0;
			end
		end
	end
	local function v140()
		v31 = v93.HandleTopTrinket(v92, v34, 34 + 6, nil);
		if (v31 or ((40 + 920) <= (1665 - (766 + 23)))) then
			return v31;
		end
		v31 = v93.HandleBottomTrinket(v92, v34, 197 - 157, nil);
		if (v31 or ((2824 - 758) == (2455 - 1523))) then
			return v31;
		end
	end
	local v141 = 0 - 0;
	local function v142()
		if (((5898 - (1036 + 37)) < (3434 + 1409)) and v89.RemoveCurse:IsReady() and (v93.UnitHasDispellableDebuffByPlayer(v15) or v93.DispellableFriendlyUnit(48 - 23) or v93.UnitHasCurseDebuff(v15))) then
			local v176 = 0 + 0;
			while true do
				if ((v176 == (1480 - (641 + 839))) or ((4790 - (910 + 3)) >= (11566 - 7029))) then
					if ((v141 == (1684 - (1466 + 218))) or ((1984 + 2331) < (2874 - (556 + 592)))) then
						v141 = GetTime();
					end
					if (v93.Wait(178 + 322, v141) or ((4487 - (329 + 479)) < (1479 - (174 + 680)))) then
						if (v23(v91.RemoveCurseFocus) or ((15892 - 11267) < (1309 - 677))) then
							return "remove_curse dispel";
						end
						v141 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v143()
		if ((v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((822 - (396 + 343)) > (158 + 1622))) then
			if (((2023 - (29 + 1448)) <= (2466 - (135 + 1254))) and v23(v89.BlazingBarrier)) then
				return "blazing_barrier defensive 1";
			end
		end
		if ((v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 7 - 5, v89.ArcaneIntellect)) or ((4650 - 3654) > (2867 + 1434))) then
			if (((5597 - (389 + 1138)) > (1261 - (102 + 472))) and v23(v89.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) or ((620 + 36) >= (1847 + 1483))) then
			if (v23(v89.IceBlock) or ((2324 + 168) <= (1880 - (320 + 1225)))) then
				return "ice_block defensive 3";
			end
		end
		if (((7693 - 3371) >= (1568 + 994)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
			if (v23(v89.IceColdAbility) or ((5101 - (157 + 1307)) >= (5629 - (821 + 1038)))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((5935 - 3556) > (501 + 4077))) then
			if (v23(v89.MirrorImage) or ((857 - 374) > (277 + 466))) then
				return "mirror_image defensive 4";
			end
		end
		if (((6082 - 3628) > (1604 - (834 + 192))) and v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
			if (((60 + 870) < (1145 + 3313)) and v23(v89.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((15 + 647) <= (1505 - 533)) and v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
			if (((4674 - (300 + 4)) == (1168 + 3202)) and v23(v89.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) or ((12465 - 7703) <= (1223 - (112 + 250)))) then
			if (v23(v91.Healthstone) or ((563 + 849) == (10681 - 6417))) then
				return "healthstone defensive";
			end
		end
		if ((v76 and (v13:HealthPercentage() <= v78)) or ((1815 + 1353) < (1114 + 1039))) then
			local v177 = 0 + 0;
			while true do
				if ((v177 == (0 + 0)) or ((3697 + 1279) < (2746 - (1001 + 413)))) then
					if (((10320 - 5692) == (5510 - (244 + 638))) and (v80 == "Refreshing Healing Potion")) then
						if (v90.RefreshingHealingPotion:IsReady() or ((747 - (627 + 66)) == (1176 - 781))) then
							if (((684 - (512 + 90)) == (1988 - (1665 + 241))) and v23(v91.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v80 == "Dreamwalker's Healing Potion") or ((1298 - (373 + 344)) < (128 + 154))) then
						if (v90.DreamwalkersHealingPotion:IsReady() or ((1220 + 3389) < (6581 - 4086))) then
							if (((1949 - 797) == (2251 - (35 + 1064))) and v23(v91.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v144()
		local v166 = 0 + 0;
		while true do
			if (((4056 - 2160) <= (14 + 3408)) and (v166 == (1237 - (298 + 938)))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) or ((2249 - (233 + 1026)) > (3286 - (636 + 1030)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((449 + 428) > (4586 + 109))) then
						return "pyroblast precombat 4";
					end
				end
				if (((800 + 1891) >= (126 + 1725)) and v89.Fireball:IsReady() and v40) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true) or ((3206 - (55 + 166)) >= (942 + 3914))) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if (((430 + 3846) >= (4563 - 3368)) and ((297 - (36 + 261)) == v166)) then
				if (((5651 - 2419) <= (6058 - (34 + 1334))) and v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
					if (v23(v89.ArcaneIntellect) or ((345 + 551) >= (2445 + 701))) then
						return "arcane_intellect precombat 2";
					end
				end
				if (((4344 - (1035 + 248)) >= (2979 - (20 + 1))) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) then
					if (((1661 + 1526) >= (963 - (134 + 185))) and v23(v89.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				v166 = 1134 - (549 + 584);
			end
		end
	end
	local function v145()
		local v167 = 685 - (314 + 371);
		while true do
			if (((2210 - 1566) <= (1672 - (478 + 490))) and (v167 == (0 + 0))) then
				if (((2130 - (786 + 386)) > (3067 - 2120)) and v89.LivingBomb:IsReady() and v42 and (v127 > (1380 - (1055 + 324))) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (1340 - (1093 + 247))))) then
					if (((3992 + 500) >= (280 + 2374)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((13665 - 10223) >= (5100 - 3597)) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (0 - 0)) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((113 - 68) < v109) or (v123 < v109))))) then
					if (v23(v91.MeteorCursor, not v14:IsInRange(15 + 25)) or ((12212 - 9042) <= (5046 - 3582))) then
						return "meteor active_talents 4";
					end
				end
				v167 = 1 + 0;
			end
			if ((v167 == (2 - 1)) or ((5485 - (364 + 324)) == (12028 - 7640))) then
				if (((1322 - 771) <= (226 + 455)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (62 - 47))) and not v135() and (v133() == (0 - 0)) and not v89.TemperedFlames:IsAvailable()) then
					if (((9952 - 6675) > (1675 - (1249 + 19))) and v23(v89.DragonsBreath, not v14:IsInRange(10 + 0))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((18275 - 13580) >= (2501 - (686 + 400))) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (12 + 3))) and not v135() and v89.TemperedFlames:IsAvailable()) then
					if (v23(v89.DragonsBreath, not v14:IsInRange(239 - (73 + 156))) or ((16 + 3196) <= (1755 - (721 + 90)))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
		end
	end
	local function v146()
		local v168 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
		if (v168 or ((35 + 3061) <= (5837 - 4039))) then
			return v168;
		end
		if (((4007 - (224 + 246)) == (5729 - 2192)) and v81 and ((v84 and v34) or not v84) and (v74 < v123)) then
			local v178 = 0 - 0;
			while true do
				if (((696 + 3141) >= (38 + 1532)) and (v178 == (0 + 0))) then
					if (v89.BloodFury:IsCastable() or ((5865 - 2915) == (12685 - 8873))) then
						if (((5236 - (203 + 310)) >= (4311 - (1238 + 755))) and v23(v89.BloodFury)) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if ((v89.Berserking:IsCastable() and v118) or ((142 + 1885) > (4386 - (709 + 825)))) then
						if (v23(v89.Berserking) or ((2092 - 956) > (6288 - 1971))) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v178 = 865 - (196 + 668);
				end
				if (((18746 - 13998) == (9834 - 5086)) and (v178 == (834 - (171 + 662)))) then
					if (((3829 - (4 + 89)) <= (16613 - 11873)) and v89.Fireblood:IsCastable()) then
						if (v23(v89.Fireblood) or ((1235 + 2155) <= (13440 - 10380))) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (v89.AncestralCall:IsCastable() or ((392 + 607) > (4179 - (35 + 1451)))) then
						if (((1916 - (28 + 1425)) < (2594 - (941 + 1052))) and v23(v89.AncestralCall)) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
			end
		end
		if ((v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) or ((2094 + 89) < (2201 - (822 + 692)))) then
			if (((6493 - 1944) == (2143 + 2406)) and v23(v89.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if (((4969 - (45 + 252)) == (4623 + 49)) and (v74 < v123)) then
			if ((v82 and ((v34 and v83) or not v83)) or ((1263 + 2405) < (961 - 566))) then
				local v228 = 433 - (114 + 319);
				while true do
					if ((v228 == (0 - 0)) or ((5338 - 1172) == (291 + 164))) then
						v31 = v140();
						if (v31 or ((6627 - 2178) == (5579 - 2916))) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v147()
		if ((v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) or ((6240 - (556 + 1407)) < (4195 - (741 + 465)))) then
			if (v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment)) or ((1335 - (170 + 295)) >= (2187 + 1962))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((2032 + 180) < (7836 - 4653)) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
			if (((3852 + 794) > (1919 + 1073)) and v23(v89.BagofTricks)) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((813 + 621) < (4336 - (957 + 273))) and v89.LivingBomb:IsReady() and v33 and v42 and (v127 > (1 + 0)) and v119) then
			if (((315 + 471) < (11518 - 8495)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (52 - 32)) or ((7458 - 5016) < (366 - 292))) then
			local v179 = 1780 - (389 + 1391);
			while true do
				if (((2846 + 1689) == (473 + 4062)) and (v179 == (0 - 0))) then
					v31 = v146();
					if (v31 or ((3960 - (783 + 168)) <= (7064 - 4959))) then
						return v31;
					end
					break;
				end
			end
		end
		if (((1801 + 29) < (3980 - (309 + 2))) and v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(92 - 62, 1214 - (1090 + 122)) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((2 + 2) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((4802 - 3372) >= (2472 + 1140))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v31 = v145();
		if (((3801 - (628 + 490)) >= (442 + 2018)) and v31) then
			return v31;
		end
		if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 - 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((2578 - (431 + 343)) >= (6614 - 3339))) then
			if (v23(v89.Combustion, not v14:IsInRange(115 - 75), nil, true) or ((1120 + 297) > (465 + 3164))) then
				return "combustion combustion_phase 10";
			end
		end
		if (((6490 - (556 + 1139)) > (417 - (6 + 9))) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((1 + 3) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (0 + 0)))) < (171 - (28 + 141)))) then
			if (((1865 + 2948) > (4400 - 835)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast combustion_phase 12";
			end
		end
		if (((2771 + 1141) == (5229 - (486 + 831))) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v126 >= v100)) then
			if (((7340 - 4519) <= (16983 - 12159)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(8 + 32), v13:BuffDown(v89.IceFloes))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if (((5495 - 3757) <= (3458 - (668 + 595))) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
			if (((37 + 4) <= (609 + 2409)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((5849 - 3704) <= (4394 - (23 + 267))) and v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v126 < (1946 - (1129 + 815))) and not v135()) then
			if (((3076 - (371 + 16)) < (6595 - (1326 + 424))) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
				return "fireball combustion_phase 16";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) or ((4397 - 2075) > (9581 - 6959))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((4652 - (88 + 30)) == (2853 - (720 + 51)))) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((8 - 4) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (1776 - (421 + 1355))))) < (2 - 0))) or ((772 + 799) > (2950 - (286 + 797)))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((9702 - 7048) >= (4961 - 1965))) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((4417 - (397 + 42)) > (658 + 1446)) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v126 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v126 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
			if (((3795 - (24 + 776)) > (2373 - 832)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(825 - (222 + 563)), v13:BuffDown(v89.IceFloes))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((7158 - 3909) > (687 + 266)) and v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((3463 - (23 + 167)) > (6371 - (690 + 1108)))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) or ((1137 + 2014) < (1060 + 224))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((2698 - (40 + 808)) == (252 + 1277))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if (((3139 - 2318) < (2030 + 93)) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v126 < v99) and v118) then
			if (((495 + 407) < (2896 - (47 + 524))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((557 + 301) <= (8096 - 5134)) and v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (0 - 0)) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v126)) then
			if (v23(v89.ShiftingPower, not v14:IsInRange(91 - 51)) or ((5672 - (1165 + 561)) < (39 + 1249))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v126 >= v100)) or ((10040 - 6798) == (217 + 350))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(519 - (341 + 138)), v13:BuffDown(v89.IceFloes)) or ((229 + 618) >= (2606 - 1343))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((2579 - (89 + 237)) == (5954 - 4103))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((4393 - 2306) > (3253 - (581 + 300)))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((1224 - (855 + 365)) * v124)) and (v128 < v99)) or ((10557 - 6112) < (1355 + 2794))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((3053 - (1030 + 205)) == (80 + 5))) then
				return "scorch combustion_phase 36";
			end
		end
		if (((587 + 43) < (2413 - (156 + 130))) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(68 - 38, 2 - 0) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (3 - 1)) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((2 + 2) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (1 + 0)) or v13:BuffUp(v89.FlamesFuryBuff))) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((2007 - (10 + 59)) == (712 + 1802))) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if (((20954 - 16699) >= (1218 - (671 + 492))) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) then
			if (((2388 + 611) > (2371 - (369 + 846))) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes))) then
				return "fireball combustion_phase 40";
			end
		end
		if (((623 + 1727) > (986 + 169)) and v89.PhoenixFlames:IsCastable() and v44 and ((not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff))) or v89.AlexstraszasFury:IsAvailable()) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1947 - (1036 + 909)))) then
			if (((3204 + 825) <= (8147 - 3294)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) or ((719 - (11 + 192)) > (1736 + 1698))) then
			if (((4221 - (135 + 40)) >= (7348 - 4315)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch combustion_phase 44";
			end
		end
		if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) or ((1639 + 1080) <= (3187 - 1740))) then
			if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((6196 - 2062) < (4102 - (50 + 126)))) then
				return "fireball combustion_phase 46";
			end
		end
		if ((v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v127 > (2 - 1))) or ((37 + 127) >= (4198 - (1233 + 180)))) then
			if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes)) or ((1494 - (522 + 447)) == (3530 - (107 + 1314)))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v126 < v99)) + (v89.Flamestrike:CastTime() * v27(v126 >= v99))) - v104;
		v109 = v114;
		if (((16 + 17) == (100 - 67)) and v89.Firestarter:IsAvailable() and not v96) then
			v109 = v29(v133(), v109);
		end
		if (((1298 + 1756) <= (7973 - 3958)) and v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (11 - 8) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((3781 - (716 + 1194)) < (58 + 3324)) and (((v114 + ((13 + 107) * ((504 - (74 + 429)) - (((0.4 - 0) + ((0.2 + 0) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (45 - 25))))) then
			v109 = v114;
		end
	end
	local function v149()
		if (((915 + 378) <= (6677 - 4511)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (2 - 1)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (434 - (279 + 154))) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((780 - (454 + 324)) * v124)))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((2030 + 549) < (140 - (12 + 5)))) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(76 - 46, 1 + 1) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((1095 - (277 + 816)) * v124)))) or ((3614 - 2768) >= (3551 - (1058 + 125)))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((753 + 3259) <= (4333 - (815 + 160)))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v150()
		if (((6410 - 4916) <= (7133 - 4128)) and v33 and v89.Flamestrike:IsReady() and v41 and (v126 >= v97) and v137()) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(10 + 30), v13:BuffDown(v89.IceFloes)) or ((9093 - 5982) == (4032 - (41 + 1857)))) then
				return "flamestrike standard_rotation 2";
			end
		end
		if (((4248 - (1222 + 671)) == (6086 - 3731)) and v89.Pyroblast:IsReady() and v45 and (v137())) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((844 - 256) <= (1614 - (229 + 953)))) then
				return "pyroblast standard_rotation 4";
			end
		end
		if (((6571 - (1111 + 663)) >= (5474 - (874 + 705))) and v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and (((v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast)) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (1 + 2))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (0 + 0))))))) then
			if (((7434 - 3857) == (101 + 3476)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
				return "fire_blast standard_rotation 6";
			end
		end
		if (((4473 - (642 + 37)) > (843 + 2850)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v126 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(7 + 33), v13:BuffDown(v89.IceFloes)) or ((3201 - 1926) == (4554 - (233 + 221)))) then
				return "flamestrike standard_rotation 12";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((11 - 6) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((1401 + 190) >= (5121 - (718 + 823)))) then
			if (((619 + 364) <= (2613 - (266 + 539))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch standard_rotation 13";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
			if (((8946 - 5177) >= (2418 - 1245)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast standard_rotation 14";
			end
		end
		if (((1177 + 308) == (540 + 945)) and v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(1016 - (657 + 358), v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v126 < v97)) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((8777 - 5462) <= (6337 - 3555))) then
				return "pyroblast standard_rotation 18";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((1191 - (1151 + 36)) * v124))) or ((846 + 30) >= (780 + 2184))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((6665 - 4433) > (4329 - (1552 + 280)))) then
				return "scorch standard_rotation 19";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((836 - (64 + 770)) * v124)))) or ((1433 + 677) <= (753 - 421))) then
			if (((655 + 3031) > (4415 - (157 + 1086))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames standard_rotation 20";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(60 - 30, 8 - 6) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((2 - 0) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((6106 - 1632) < (1639 - (599 + 220)))) then
			if (((8520 - 4241) >= (4813 - (1813 + 118))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames standard_rotation 21";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((1484 + 545) >= (4738 - (841 + 376)))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((2854 - 817) >= (1079 + 3563))) then
				return "scorch standard_rotation 22";
			end
		end
		if (((4694 - 2974) < (5317 - (464 + 395))) and v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((1118 - 682) > (1451 + 1570))) then
				return "phoenix_flames standard_rotation 24";
			end
		end
		if (((1550 - (467 + 370)) <= (1750 - 903)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (0 + 0)) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (6.5 - 4)) or ((v89.PhoenixFlames:ChargesFractional() > (1.5 + 0)) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((6 - 3) * v124)))))) then
			if (((2674 - (150 + 370)) <= (5313 - (74 + 1208))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
				return "phoenix_flames standard_rotation 26";
			end
		end
		v31 = v145();
		if (((11351 - 6736) == (21887 - 17272)) and v31) then
			return v31;
		end
		if ((v33 and v89.DragonsBreath:IsReady() and v38 and (v128 > (1 + 0)) and v89.AlexstraszasFury:IsAvailable()) or ((4180 - (14 + 376)) == (867 - 367))) then
			if (((58 + 31) < (195 + 26)) and v23(v89.DragonsBreath, not v14:IsInRange(10 + 0))) then
				return "dragons_breath standard_rotation 28";
			end
		end
		if (((6018 - 3964) >= (1070 + 351)) and v89.Scorch:IsReady() and v46 and (v134())) then
			if (((770 - (23 + 55)) < (7247 - 4189)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
				return "scorch standard_rotation 30";
			end
		end
		if ((v33 and v89.ArcaneExplosion:IsReady() and v36 and (v130 >= v101) and (v13:ManaPercentageP() >= v102)) or ((2172 + 1082) == (1487 + 168))) then
			if (v23(v89.ArcaneExplosion, not v14:IsInRange(11 - 3)) or ((408 + 888) == (5811 - (652 + 249)))) then
				return "arcane_explosion standard_rotation 32";
			end
		end
		if (((9013 - 5645) == (5236 - (708 + 1160))) and v33 and v89.Flamestrike:IsReady() and v41 and (v126 >= v98)) then
			if (((7174 - 4531) < (6955 - 3140)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(67 - (10 + 17)))) then
				return "flamestrike standard_rotation 34";
			end
		end
		if (((430 + 1483) > (2225 - (1400 + 332))) and v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) then
			if (((9120 - 4365) > (5336 - (242 + 1666))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
				return "pyroblast standard_rotation 35";
			end
		end
		if (((591 + 790) <= (869 + 1500)) and v89.Fireball:IsReady() and v40 and not v137()) then
			if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((4128 + 715) == (5024 - (850 + 90)))) then
				return "fireball standard_rotation 36";
			end
		end
	end
	local function v151()
		local v169 = 0 - 0;
		while true do
			if (((6059 - (360 + 1030)) > (322 + 41)) and (v169 == (5 - 3))) then
				if ((not v113 and v89.SunKingsBlessing:IsAvailable()) or ((2582 - 705) >= (4799 - (909 + 752)))) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((1226 - (109 + 1114)) * v124));
				end
				if (((8681 - 3939) >= (1412 + 2214)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (242 - (6 + 236))) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(12 + 6), true) or ((3655 + 885) == (2160 - 1244))) then
						return "shifting_power main 12";
					end
				end
				if ((v126 < v99) or ((2019 - 863) > (5478 - (1076 + 57)))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + 2 + 5) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				v169 = 692 - (579 + 110);
			end
			if (((177 + 2060) < (3757 + 492)) and (v169 == (3 + 1))) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) or ((3090 - (174 + 233)) < (64 - 41))) then
					if (((1223 - 526) <= (368 + 458)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast main 16";
					end
				end
				if (((2279 - (663 + 511)) <= (1050 + 126)) and (v109 > (0 + 0)) and v119) then
					v31 = v150();
					if (((10417 - 7038) <= (2309 + 1503)) and v31) then
						return v31;
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((1855 - 1067) >= (3911 - 2295))) then
					if (((885 + 969) <= (6576 - 3197)) and v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v169 = 4 + 1;
			end
			if (((416 + 4133) == (5271 - (478 + 244))) and (v169 == (517 - (440 + 77)))) then
				if (not v95 or ((1375 + 1647) >= (11067 - 8043))) then
					v148();
				end
				if (((6376 - (655 + 901)) > (408 + 1790)) and v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (31 + 9)))) then
					if (v23(v89.TimeWarp, not v14:IsInRange(28 + 12)) or ((4274 - 3213) >= (6336 - (695 + 750)))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((4657 - 3293) <= (6902 - 2429)) and (v74 < v123)) then
					if ((v82 and ((v34 and v83) or not v83)) or ((14458 - 10863) <= (354 - (285 + 66)))) then
						local v233 = 0 - 0;
						while true do
							if ((v233 == (1310 - (682 + 628))) or ((754 + 3918) == (4151 - (176 + 123)))) then
								v31 = v140();
								if (((653 + 906) == (1131 + 428)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				v169 = 270 - (239 + 30);
			end
			if ((v169 == (1 + 0)) or ((1684 + 68) <= (1394 - 606))) then
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (2 - 1)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((327 - (306 + 9)) / v89.FireBlast:Cooldown()) % (3 - 2)))) and (v109 < v123);
				if ((not v95 and ((v109 <= (0 + 0)) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) or ((2398 + 1509) == (86 + 91))) then
					local v229 = 0 - 0;
					while true do
						if (((4845 - (1140 + 235)) > (354 + 201)) and (v229 == (0 + 0))) then
							v31 = v147();
							if (v31 or ((250 + 722) == (697 - (33 + 19)))) then
								return v31;
							end
							break;
						end
					end
				end
				v169 = 1 + 1;
			end
			if (((9537 - 6355) >= (932 + 1183)) and (v169 == (5 - 2))) then
				if (((3651 + 242) < (5118 - (586 + 103))) and (v126 >= v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (0 + 0)) and (v126 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (1490 - (1309 + 179))))) or ((5175 - 2308) < (830 + 1075))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((4823 - 3027) >= (3060 + 991))) then
						return "fire_blast main 14";
					end
				end
				if (((3439 - 1820) <= (7484 - 3728)) and v119 and v132() and (v109 > (609 - (295 + 314)))) then
					v31 = v149();
					if (((1483 - 879) == (2566 - (1300 + 662))) and v31) then
						return v31;
					end
				end
				v169 = 12 - 8;
			end
			if ((v169 == (1760 - (1178 + 577))) or ((2329 + 2155) == (2660 - 1760))) then
				if ((v89.Scorch:IsReady() and v46) or ((5864 - (851 + 554)) <= (985 + 128))) then
					if (((10072 - 6440) > (7379 - 3981)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch main 20";
					end
				end
				break;
			end
		end
	end
	local function v152()
		local v170 = 302 - (115 + 187);
		while true do
			if (((3127 + 955) <= (4655 + 262)) and (v170 == (27 - 20))) then
				v64 = EpicSettings.Settings['iceColdHP'] or (1161 - (160 + 1001));
				v65 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v66 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v85 = EpicSettings.Settings['mirrorImageBeforePull'];
				v170 = 16 - 8;
			end
			if (((5190 - (237 + 121)) >= (2283 - (525 + 372))) and ((4 - 1) == v170)) then
				v48 = EpicSettings.Settings['useBlastWave'];
				v49 = EpicSettings.Settings['useCombustion'];
				v50 = EpicSettings.Settings['useShiftingPower'];
				v51 = EpicSettings.Settings['combustionWithCD'];
				v170 = 12 - 8;
			end
			if (((279 - (96 + 46)) == (914 - (643 + 134))) and ((0 + 0) == v170)) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v39 = EpicSettings.Settings['useFireBlast'];
				v170 = 2 - 1;
			end
			if ((v170 == (3 - 2)) or ((1506 + 64) >= (8501 - 4169))) then
				v40 = EpicSettings.Settings['useFireball'];
				v41 = EpicSettings.Settings['useFlamestrike'];
				v42 = EpicSettings.Settings['useLivingBomb'];
				v43 = EpicSettings.Settings['useMeteor'];
				v170 = 3 - 1;
			end
			if (((727 - (316 + 403)) == v170) or ((2702 + 1362) <= (5001 - 3182))) then
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v170 == (3 + 3)) or ((12556 - 7570) < (1116 + 458))) then
				v60 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v61 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
				v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v170 = 1 + 6;
			end
			if (((8712 - 4286) > (9 + 163)) and (v170 == (14 - 9))) then
				v56 = EpicSettings.Settings['useIceBlock'];
				v57 = EpicSettings.Settings['useIceCold'];
				v59 = EpicSettings.Settings['useMassBarrier'];
				v58 = EpicSettings.Settings['useMirrorImage'];
				v170 = 23 - (12 + 5);
			end
			if (((2275 - 1689) > (970 - 515)) and (v170 == (8 - 4))) then
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['useAlterTime'];
				v54 = EpicSettings.Settings['useBlazingBarrier'];
				v55 = EpicSettings.Settings['useGreaterInvisibility'];
				v170 = 12 - 7;
			end
			if (((168 + 658) == (2799 - (1656 + 317))) and (v170 == (2 + 0))) then
				v44 = EpicSettings.Settings['usePhoenixFlames'];
				v45 = EpicSettings.Settings['usePyroblast'];
				v46 = EpicSettings.Settings['useScorch'];
				v47 = EpicSettings.Settings['useCounterspell'];
				v170 = 3 + 0;
			end
		end
	end
	local function v153()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (19 - 15)) or ((4373 - (5 + 349)) > (21094 - 16653))) then
				v76 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (1271 - (266 + 1005));
				v78 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v171 = 16 - 11;
			end
			if (((2655 - 638) < (5957 - (561 + 1135))) and ((0 - 0) == v171)) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v75 = EpicSettings.Settings['useWeapon'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v171 = 1067 - (507 + 559);
			end
			if (((11833 - 7117) > (247 - 167)) and (v171 == (390 - (212 + 176)))) then
				v67 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v81 = EpicSettings.Settings['useRacials'];
				v171 = 908 - (250 + 655);
			end
			if ((v171 == (8 - 5)) or ((6127 - 2620) == (5118 - 1846))) then
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v171 = 1960 - (1869 + 87);
			end
			if ((v171 == (17 - 12)) or ((2777 - (484 + 1417)) >= (6590 - 3515))) then
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((7293 - 2941) > (3327 - (48 + 725))) and (v171 == (1 - 0))) then
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v171 = 5 - 3;
			end
		end
	end
	local function v154()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (7 - 4)) or ((1234 + 3172) < (1179 + 2864))) then
				if (v33 or ((2742 - (152 + 701)) >= (4694 - (430 + 881)))) then
					local v230 = 0 + 0;
					while true do
						if (((2787 - (557 + 338)) <= (809 + 1925)) and (v230 == (2 - 1))) then
							v128 = v29(v14:GetEnemiesInSplashRangeCount(17 - 12), #v129);
							v130 = #v129;
							break;
						end
						if (((5108 - 3185) < (4779 - 2561)) and (v230 == (801 - (499 + 302)))) then
							v126 = v29(v14:GetEnemiesInSplashRangeCount(871 - (39 + 827)), #v129);
							v127 = v29(v14:GetEnemiesInSplashRangeCount(13 - 8), #v129);
							v230 = 2 - 1;
						end
					end
				else
					v126 = 3 - 2;
					v127 = 1 - 0;
					v128 = 1 + 0;
					v130 = 2 - 1;
				end
				if (((348 + 1825) > (599 - 220)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
					local v231 = 104 - (103 + 1);
					while true do
						if (((554 - (475 + 79)) == v231) or ((5601 - 3010) == (10908 - 7499))) then
							if (((584 + 3930) > (2926 + 398)) and (v13:AffectingCombat() or v68)) then
								local v234 = v68 and v89.RemoveCurse:IsReady() and v35;
								v31 = v93.FocusUnit(v234, nil, 1523 - (1395 + 108), nil, 58 - 38, v89.ArcaneIntellect);
								if (v31 or ((1412 - (7 + 1197)) >= (2106 + 2722))) then
									return v31;
								end
							end
							v122 = v9.BossFightRemains(nil, true);
							v123 = v122;
							v231 = 1 + 0;
						end
						if ((v231 == (322 - (27 + 292))) or ((4638 - 3055) > (4548 - 981))) then
							v119 = not v118;
							v120 = v13:BuffRemains(v89.CombustionBuff);
							break;
						end
						if ((v231 == (8 - 6)) or ((2588 - 1275) == (1511 - 717))) then
							if (((3313 - (43 + 96)) > (11837 - 8935)) and v95) then
								v109 = 226085 - 126086;
							end
							v124 = v13:GCD();
							v118 = v13:BuffUp(v89.CombustionBuff);
							v231 = 3 + 0;
						end
						if (((1164 + 2956) <= (8419 - 4159)) and (v231 == (1 + 0))) then
							if ((v123 == (20822 - 9711)) or ((278 + 605) > (351 + 4427))) then
								v123 = v9.FightRemains(v129, false);
							end
							UnitsWithIgniteCount = v138(v129);
							v95 = not v34;
							v231 = 1753 - (1414 + 337);
						end
					end
				end
				if ((not v13:AffectingCombat() and v32) or ((5560 - (1642 + 298)) >= (12749 - 7858))) then
					v31 = v144();
					if (((12249 - 7991) > (2780 - 1843)) and v31) then
						return v31;
					end
				end
				v172 = 2 + 2;
			end
			if ((v172 == (1 + 0)) or ((5841 - (357 + 615)) < (636 + 270))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v172 = 4 - 2;
			end
			if ((v172 == (2 + 0)) or ((2625 - 1400) > (3382 + 846))) then
				if (((227 + 3101) > (1407 + 831)) and v13:IsDeadOrGhost()) then
					return v31;
				end
				v125 = v14:GetEnemiesInSplashRange(1306 - (384 + 917));
				v129 = v13:GetEnemiesInRange(737 - (128 + 569));
				v172 = 1546 - (1407 + 136);
			end
			if (((5726 - (687 + 1200)) > (3115 - (556 + 1154))) and (v172 == (14 - 10))) then
				if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((1388 - (9 + 86)) <= (928 - (275 + 146)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (66 - (29 + 35))) or ((12834 - 9938) < (2404 - 1599))) then
							if (((10223 - 7907) == (1509 + 807)) and v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes) and not v13:PrevOffGCDP(1013 - (53 + 959), v89.IceFloes)) then
								if (v23(v89.IceFloes) or ((2978 - (312 + 96)) == (2660 - 1127))) then
									return "ice_floes movement";
								end
							end
							v31 = v151();
							if (v31 or ((1168 - (147 + 138)) == (2359 - (813 + 86)))) then
								return v31;
							end
							break;
						end
						if ((v232 == (0 + 0)) or ((8557 - 3938) <= (1491 - (18 + 474)))) then
							if ((v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) or ((1151 + 2259) > (13434 - 9318))) then
								if (v23(v91.UseWeapon, nil) or ((1989 - (860 + 226)) >= (3362 - (121 + 182)))) then
									return "Using Weapon Macro";
								end
							end
							if ((v68 and v35 and v89.RemoveCurse:IsAvailable()) or ((490 + 3486) < (4097 - (988 + 252)))) then
								if (((557 + 4373) > (723 + 1584)) and v15) then
									local v235 = 1970 - (49 + 1921);
									while true do
										if ((v235 == (890 - (223 + 667))) or ((4098 - (51 + 1)) < (2221 - 930))) then
											v31 = v142();
											if (v31 or ((9081 - 4840) == (4670 - (146 + 979)))) then
												return v31;
											end
											break;
										end
									end
								end
								if ((v17 and v17:Exists() and not v13:CanAttack(v17) and v93.UnitHasCurseDebuff(v17)) or ((1143 + 2905) > (4837 - (311 + 294)))) then
									if (v89.RemoveCurse:IsReady() or ((4880 - 3130) >= (1472 + 2001))) then
										if (((4609 - (496 + 947)) == (4524 - (1233 + 125))) and v23(v91.RemoveCurseMouseover)) then
											return "remove_curse dispel";
										end
									end
								end
							end
							v31 = v143();
							if (((716 + 1047) < (3342 + 382)) and v31) then
								return v31;
							end
							v232 = 1 + 0;
						end
						if (((1702 - (963 + 682)) <= (2273 + 450)) and (v232 == (1505 - (504 + 1000)))) then
							if (v69 or ((1395 + 675) == (404 + 39))) then
								if (v88 or ((256 + 2449) == (2053 - 660))) then
									v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 26 + 4);
									if (v31 or ((2676 + 1925) < (243 - (156 + 26)))) then
										return v31;
									end
								end
							end
							if (v70 or ((801 + 589) >= (7422 - 2678))) then
								v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 194 - (149 + 15));
								if (v31 or ((2963 - (890 + 70)) > (3951 - (39 + 78)))) then
									return v31;
								end
							end
							if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) or ((638 - (14 + 468)) > (8604 - 4691))) then
								if (((545 - 350) == (101 + 94)) and v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							if (((1865 + 1240) >= (382 + 1414)) and (v13:IsCasting(v89.Pyroblast) or v13:IsChanneling(v89.Pyroblast) or v13:IsCasting(v89.Flamestrike) or v13:IsChanneling(v89.Flamestrike)) and v13:BuffUp(v89.HotStreakBuff)) then
								if (((1978 + 2401) >= (559 + 1572)) and v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast), false, true)) then
									return "Stop Casting";
								end
							end
							v232 = 3 - 1;
						end
					end
				end
				break;
			end
			if (((3800 + 44) >= (7178 - 5135)) and (v172 == (0 + 0))) then
				v152();
				v153();
				v32 = EpicSettings.Toggles['ooc'];
				v172 = 52 - (12 + 39);
			end
		end
	end
	local function v155()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (0 - 0)) or ((11510 - 8278) <= (810 + 1921))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(34 + 29, v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

