local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 797 - (586 + 211);
	local v6;
	while true do
		if (((1822 - 1450) <= (1977 - (657 + 399))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((755 + 2944) < (10933 - 6227)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((880 + 1766) >= (548 + 328)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1097 - (709 + 387);
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
		if (((2472 - (673 + 1185)) <= (9233 - 6049)) and v90.RemoveCurse:IsAvailable()) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (12 - 8)) or (1643 - 644);
	local v99 = 715 + 284;
	local v100 = v98;
	local v101 = ((3 + 0) * v28(v90.FueltheFire:IsAvailable())) + ((1348 - 349) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 246 + 753;
	local v103 = 79 - 39;
	local v104 = 1960 - 961;
	local v105 = 1880.3 - (446 + 1434);
	local v106 = 1283 - (1040 + 243);
	local v107 = 17 - 11;
	local v108 = false;
	local v109 = (v108 and (1867 - (559 + 1288))) or (1931 - (609 + 1322));
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (454.4 - (13 + 441))) or (3 - 2);
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 0 - 0;
	local v116 = 0 - 0;
	local v117 = 1 + 7;
	local v118 = 10 - 7;
	local v119;
	local v120;
	local v121;
	local v122 = 2 + 1;
	local v123 = 4869 + 6242;
	local v124 = 32972 - 21861;
	local v125;
	local v126, v127, v128;
	local v129;
	local v130;
	local v131;
	local v132;
	v10:RegisterForEvent(function()
		v108 = false;
		v109 = (v108 and (11 + 9)) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v90.Pyroblast:RegisterInFlight();
		v90.Fireball:RegisterInFlight();
		v90.Meteor:RegisterInFlightEffect(232143 + 118997);
		v90.Meteor:RegisterInFlight();
		v90.PhoenixFlames:RegisterInFlightEffect(143240 + 114302);
		v90.PhoenixFlames:RegisterInFlight();
		v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
		v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(252297 + 98843);
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(216246 + 41296);
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if (((3559 - (153 + 280)) == (9026 - 5900)) and (v157 == (0 + 0))) then
				v123 = 4388 + 6723;
				v124 = 5815 + 5296;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v97 = v90.SunKingsBlessing:IsAvailable();
		v98 = ((v90.FlamePatch:IsAvailable()) and (3 + 0)) or (724 + 275);
		v100 = v98;
		v111 = ((v90.Kindling:IsAvailable()) and (0.4 - 0)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (757 - (89 + 578)));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (65 + 25)) and v15:TimeToX(187 - 97)) or (1049 - (572 + 477)))) or (0 + 0);
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (19 + 11));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (4 + 26));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v158 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (86 - (84 + 2));
		v158 = v158 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1 - 0, v90.PhoenixFlames));
		return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast) or (v158 > (0 + 0))))));
	end
	local function v139(v159)
		local v160 = 842 - (497 + 345);
		local v161;
		while true do
			if ((v160 == (1 + 0)) or ((370 + 1817) >= (6287 - (605 + 728)))) then
				return v161;
			end
			if ((v160 == (0 + 0)) or ((8619 - 4742) == (164 + 3411))) then
				v161 = 0 - 0;
				for v228, v229 in pairs(v159) do
					if (((638 + 69) > (1750 - 1118)) and v229:DebuffUp(v90.IgniteDebuff)) then
						v161 = v161 + 1 + 0;
					end
				end
				v160 = 490 - (457 + 32);
			end
		end
	end
	local function v140()
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (1402 - (832 + 570))) or ((515 + 31) >= (700 + 1984))) then
				v163 = 0 - 0;
				if (((706 + 759) <= (5097 - (588 + 208))) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
					v163 = v163 + (2 - 1);
				end
				v162 = 1801 - (884 + 916);
			end
			if (((3567 - 1863) > (827 + 598)) and (v162 == (654 - (232 + 421)))) then
				return v163;
			end
		end
	end
	local function v141()
		v32 = v94.HandleTopTrinket(v93, v35, 1929 - (1569 + 320), nil);
		if (v32 or ((169 + 518) == (805 + 3429))) then
			return v32;
		end
		v32 = v94.HandleBottomTrinket(v93, v35, 134 - 94, nil);
		if (v32 or ((3935 - (316 + 289)) < (3740 - 2311))) then
			return v32;
		end
	end
	local v142 = 0 + 0;
	local function v143()
		if (((2600 - (666 + 787)) >= (760 - (360 + 65))) and v90.RemoveCurse:IsReady() and v94.UnitHasDispellableDebuffByPlayer(v16)) then
			local v179 = 0 + 0;
			while true do
				if (((3689 - (79 + 175)) > (3306 - 1209)) and (v179 == (0 + 0))) then
					if ((v142 == (0 - 0)) or ((7260 - 3490) >= (4940 - (503 + 396)))) then
						v142 = GetTime();
					end
					if (v94.Wait(681 - (92 + 89), v142) or ((7354 - 3563) <= (827 + 784))) then
						if (v24(v92.RemoveCurseFocus) or ((2710 + 1868) <= (7863 - 5855))) then
							return "remove_curse dispel";
						end
						v142 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v144()
		if (((2565 - 1440) <= (1812 + 264)) and v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) then
			if (v24(v90.BlazingBarrier) or ((355 + 388) >= (13397 - 8998))) then
				return "blazing_barrier defensive 1";
			end
		end
		if (((145 + 1010) < (2551 - 878)) and v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 1246 - (485 + 759), v90.ArcaneIntellect)) then
			if (v24(v90.MassBarrier) or ((5377 - 3053) <= (1767 - (442 + 747)))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((4902 - (832 + 303)) == (4713 - (88 + 858))) and v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
			if (((1247 + 2842) == (3385 + 704)) and v24(v90.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if (((184 + 4274) >= (2463 - (766 + 23))) and v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) then
			if (((4798 - 3826) <= (1938 - 520)) and v24(v90.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) or ((13010 - 8072) < (16162 - 11400))) then
			if (v24(v90.MirrorImage) or ((3577 - (1036 + 37)) > (3024 + 1240))) then
				return "mirror_image defensive 4";
			end
		end
		if (((4192 - 2039) == (1694 + 459)) and v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
			if (v24(v90.GreaterInvisibility) or ((1987 - (641 + 839)) >= (3504 - (910 + 3)))) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((11423 - 6942) == (6165 - (1466 + 218))) and v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
			if (v24(v90.AlterTime) or ((1070 + 1258) < (1841 - (556 + 592)))) then
				return "alter_time defensive 6";
			end
		end
		if (((1540 + 2788) == (5136 - (329 + 479))) and v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) then
			if (((2442 - (174 + 680)) >= (4576 - 3244)) and v24(v92.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v77 and (v14:HealthPercentage() <= v79)) or ((8651 - 4477) > (3033 + 1215))) then
			if ((v81 == "Refreshing Healing Potion") or ((5325 - (396 + 343)) <= (8 + 74))) then
				if (((5340 - (29 + 1448)) == (5252 - (135 + 1254))) and v91.RefreshingHealingPotion:IsReady()) then
					if (v24(v92.RefreshingHealingPotion) or ((1062 - 780) <= (196 - 154))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((3072 + 1537) >= (2293 - (389 + 1138))) and (v81 == "Dreamwalker's Healing Potion")) then
				if (v91.DreamwalkersHealingPotion:IsReady() or ((1726 - (102 + 472)) == (2348 + 140))) then
					if (((1898 + 1524) > (3124 + 226)) and v24(v92.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v145()
		if (((2422 - (320 + 1225)) > (669 - 293)) and v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) then
			if (v24(v90.ArcaneIntellect) or ((1908 + 1210) <= (3315 - (157 + 1307)))) then
				return "arcane_intellect precombat 2";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) or ((2024 - (821 + 1038)) >= (8712 - 5220))) then
			if (((432 + 3517) < (8624 - 3768)) and v24(v90.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) or ((1591 + 2685) < (7475 - 4459))) then
			if (((5716 - (834 + 192)) > (263 + 3862)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true)) then
				return "pyroblast precombat 4";
			end
		end
		if ((v90.Fireball:IsReady() and v41) or ((13 + 37) >= (20 + 876))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true) or ((2654 - 940) >= (3262 - (300 + 4)))) then
				return "fireball precombat 6";
			end
		end
	end
	local function v146()
		if ((v90.LivingBomb:IsReady() and v43 and (v127 > (1 + 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (0 - 0)))) or ((1853 - (112 + 250)) < (257 + 387))) then
			if (((1763 - 1059) < (566 + 421)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
				return "living_bomb active_talents 2";
			end
		end
		if (((1923 + 1795) > (1426 + 480)) and v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (0 + 0)) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((34 + 11) < v110) or (v124 < v110))))) then
			if (v24(v92.MeteorCursor, not v15:IsInRange(1454 - (1001 + 413))) or ((2136 - 1178) > (4517 - (244 + 638)))) then
				return "meteor active_talents 4";
			end
		end
		if (((4194 - (627 + 66)) <= (13384 - 8892)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (617 - (512 + 90)))) and not v136() and (v134() == (1906 - (1665 + 241))) and not v90.TemperedFlames:IsAvailable()) then
			if (v24(v90.DragonsBreath, not v15:IsInRange(727 - (373 + 344))) or ((1553 + 1889) < (675 + 1873))) then
				return "dragons_breath active_talents 6";
			end
		end
		if (((7583 - 4708) >= (2477 - 1013)) and v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (1114 - (35 + 1064)))) and not v136() and v90.TemperedFlames:IsAvailable()) then
			if (v24(v90.DragonsBreath, not v15:IsInRange(8 + 2)) or ((10263 - 5466) >= (20 + 4873))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v147()
		local v164 = 1236 - (298 + 938);
		local v165;
		while true do
			if ((v164 == (1259 - (233 + 1026))) or ((2217 - (636 + 1030)) > (1058 + 1010))) then
				v165 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (((2065 + 49) > (281 + 663)) and v165) then
					return v165;
				end
				v164 = 1 + 0;
			end
			if ((v164 == (222 - (55 + 166))) or ((439 + 1823) >= (312 + 2784))) then
				if ((v82 and ((v85 and v35) or not v85) and (v75 < v124)) or ((8611 - 6356) >= (3834 - (36 + 261)))) then
					local v230 = 0 - 0;
					while true do
						if ((v230 == (1368 - (34 + 1334))) or ((1476 + 2361) < (1015 + 291))) then
							if (((4233 - (1035 + 248)) == (2971 - (20 + 1))) and v90.BloodFury:IsCastable()) then
								if (v24(v90.BloodFury) or ((2461 + 2262) < (3617 - (134 + 185)))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if (((2269 - (549 + 584)) >= (839 - (314 + 371))) and v90.Berserking:IsCastable() and v119) then
								if (v24(v90.Berserking) or ((930 - 659) > (5716 - (478 + 490)))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v230 = 1 + 0;
						end
						if (((5912 - (786 + 386)) >= (10209 - 7057)) and (v230 == (1380 - (1055 + 324)))) then
							if (v90.Fireblood:IsCastable() or ((3918 - (1093 + 247)) >= (3013 + 377))) then
								if (((5 + 36) <= (6594 - 4933)) and v24(v90.Fireblood)) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (((2039 - 1438) < (10130 - 6570)) and v90.AncestralCall:IsCastable()) then
								if (((590 - 355) < (245 + 442)) and v24(v90.AncestralCall)) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if (((17524 - 12975) > (3973 - 2820)) and v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
					if (v24(v90.TimeWarp, nil, nil, true) or ((3525 + 1149) < (11947 - 7275))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v164 = 690 - (364 + 324);
			end
			if (((10055 - 6387) < (10944 - 6383)) and (v164 == (1 + 1))) then
				if ((v75 < v124) or ((1903 - 1448) == (5773 - 2168))) then
					if ((v83 and ((v35 and v84) or not v84)) or ((8087 - 5424) == (4580 - (1249 + 19)))) then
						v32 = v141();
						if (((3861 + 416) <= (17418 - 12943)) and v32) then
							return v32;
						end
					end
				end
				break;
			end
		end
	end
	local function v148()
		if ((v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) or ((1956 - (686 + 400)) == (933 + 256))) then
			if (((1782 - (73 + 156)) <= (15 + 3118)) and v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if ((v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) or ((3048 - (721 + 90)) >= (40 + 3471))) then
			if (v24(v90.BagofTricks) or ((4298 - 2974) > (3490 - (224 + 246)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if ((v90.LivingBomb:IsReady() and v34 and v43 and (v127 > (1 - 0)) and v120) or ((5508 - 2516) == (342 + 1539))) then
			if (((74 + 3032) > (1121 + 405)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if (((6010 - 2987) < (12878 - 9008)) and ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (533 - (203 + 310))))) then
			local v180 = 1993 - (1238 + 755);
			while true do
				if (((10 + 133) > (1608 - (709 + 825))) and (v180 == (0 - 0))) then
					v32 = v147();
					if (((25 - 7) < (2976 - (196 + 668))) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if (((4331 - 3234) <= (3371 - 1743)) and v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(863 - (171 + 662), 95 - (4 + 89)) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((13 - 9) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
			if (((1686 + 2944) == (20336 - 15706)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v32 = v146();
		if (((1389 + 2151) > (4169 - (35 + 1451))) and v32) then
			return v32;
		end
		if (((6247 - (28 + 1425)) >= (5268 - (941 + 1052))) and v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (0 + 0)) and v120 and (v110 <= (1514 - (822 + 692))) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) then
			if (((2118 - 634) == (699 + 785)) and v24(v90.Combustion, not v15:IsInRange(337 - (45 + 252)), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if (((1417 + 15) < (1224 + 2331)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v126 >= v101)) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(97 - 57), v14:BuffDown(v90.IceFloes)) or ((1498 - (114 + 319)) > (5136 - 1558))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((6144 - 1349) < (897 + 510))) then
			if (((2760 - 907) < (10084 - 5271)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v126 < (1965 - (556 + 1407))) and not v136()) or ((4027 - (741 + 465)) < (2896 - (170 + 295)))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((1515 + 1359) < (2004 + 177))) then
				return "fireball combustion_phase 16";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) or ((6620 - 3931) <= (285 + 58))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((1199 + 670) == (1138 + 871))) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((1234 - (957 + 273)) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 + 0)))) < (1 + 1))) or ((13511 - 9965) < (6118 - 3796))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((6359 - 4277) == (23634 - 18861))) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((5024 - (389 + 1391)) > (662 + 393)) and v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v126 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v126 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(5 + 35), v14:BuffDown(v90.IceFloes)) or ((7542 - 4229) <= (2729 - (783 + 168)))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) or ((4769 - 3348) >= (2070 + 34))) then
			if (((2123 - (309 + 2)) <= (9977 - 6728)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if (((2835 - (1090 + 122)) <= (635 + 1322)) and v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) then
			if (((14817 - 10405) == (3020 + 1392)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if (((2868 - (628 + 490)) >= (151 + 691)) and v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(2 - 1, v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v126 < v100) and v119) then
			if (((19980 - 15608) > (2624 - (431 + 343))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((468 - 236) < (2374 - 1553)) and v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (0 + 0)) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v126)) then
			if (((67 + 451) < (2597 - (556 + 1139))) and v24(v90.ShiftingPower, not v15:IsInRange(55 - (6 + 9)))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((549 + 2445) > (440 + 418)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v126 >= v101)) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(209 - (28 + 141)), v14:BuffDown(v90.IceFloes)) or ((1455 + 2300) <= (1129 - 214))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if (((2795 + 1151) > (5060 - (486 + 831))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((3473 - 2138) >= (11639 - 8333))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if (((916 + 3928) > (7123 - 4870)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((1267 - (668 + 595)) * v125)) and (v128 < v100)) then
			if (((407 + 45) == (92 + 360)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(81 - 51, 292 - (23 + 267)) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (1946 - (1129 + 815))) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((391 - (371 + 16)) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1751 - (1326 + 424))) or v14:BuffUp(v90.FlamesFuryBuff))) or ((8630 - 4073) < (7626 - 5539))) then
			if (((3992 - (88 + 30)) == (4645 - (720 + 51))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) or ((4310 - 2372) > (6711 - (421 + 1355)))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((7019 - 2764) < (1682 + 1741))) then
				return "fireball combustion_phase 40";
			end
		end
		if (((2537 - (286 + 797)) <= (9106 - 6615)) and v90.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(49 - 19, 441 - (397 + 42)) and not v90.AlexstraszasFury:IsAvailable() and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (1 + 1))) then
			if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((4957 - (24 + 776)) <= (4318 - 1515))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if (((5638 - (222 + 563)) >= (6569 - 3587)) and v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) then
			if (((2977 + 1157) > (3547 - (23 + 167))) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 44";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) or ((5215 - (690 + 1108)) < (915 + 1619))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((2246 + 476) <= (1012 - (40 + 808)))) then
				return "fireball combustion_phase 46";
			end
		end
		if ((v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v127 > (1 + 0))) or ((9208 - 6800) < (2016 + 93))) then
			if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((18 + 15) == (798 + 657))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v149()
		local v166 = 571 - (47 + 524);
		while true do
			if ((v166 == (1 + 0)) or ((1210 - 767) >= (6003 - 1988))) then
				v110 = v115;
				if (((7712 - 4330) > (1892 - (1165 + 561))) and v90.Firestarter:IsAvailable() and not v97) then
					v110 = v30(v134(), v110);
				end
				v166 = 1 + 1;
			end
			if ((v166 == (9 - 6)) or ((107 + 173) == (3538 - (341 + 138)))) then
				if (((508 + 1373) > (2668 - 1375)) and (((v115 + ((446 - (89 + 237)) * ((3 - 2) - (((0.4 - 0) + ((881.2 - (581 + 300)) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (1240 - (855 + 365)))))) then
					v110 = v115;
				end
				break;
			end
			if (((5598 - 3241) == (770 + 1587)) and (v166 == (1237 - (1030 + 205)))) then
				if (((116 + 7) == (115 + 8)) and v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (289 - (156 + 130)) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v166 = 6 - 3;
			end
			if ((v166 == (0 - 0)) or ((2162 - 1106) >= (894 + 2498))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v126 < v100)) + (v90.Flamestrike:CastTime() * v28(v126 >= v100))) - v105;
				v166 = 1 + 0;
			end
		end
	end
	local function v150()
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (70 - (10 + 59))) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (1 + 0)) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((9 - 7) * v125)))) or ((2244 - (671 + 492)) < (856 + 219))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((2264 - (369 + 846)) >= (1174 + 3258))) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 + 0)) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(1975 - (1036 + 909), 2 + 0) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((2 - 0) * v125)))) or ((4971 - (11 + 192)) <= (428 + 418))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((3533 - (135 + 40)) <= (3440 - 2020))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v151()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (12 - 6)) or ((5604 - 1865) <= (3181 - (50 + 126)))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v99)) or ((4619 - 2960) >= (473 + 1661))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1453 - (1233 + 180))) or ((4229 - (522 + 447)) < (3776 - (107 + 1314)))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) or ((311 + 358) == (12867 - 8644))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((719 + 973) < (1167 - 579))) then
						return "pyroblast standard_rotation 35";
					end
				end
				if ((v90.Fireball:IsReady() and v41 and not v138()) or ((18979 - 14182) < (5561 - (716 + 1194)))) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((72 + 4105) > (520 + 4330))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v167 == (503 - (74 + 429))) or ((771 - 371) > (551 + 560))) then
				if (((6983 - 3932) > (712 + 293)) and v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v98) and v138()) then
					if (((11384 - 7691) <= (10834 - 6452)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(473 - (279 + 154)), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v138())) or ((4060 - (454 + 324)) > (3226 + 874))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((3597 - (12 + 5)) < (1534 + 1310))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((226 - 137) < (1660 + 2830)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v126 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1133 - (277 + 816)), v14:BuffDown(v90.IceFloes)) or ((21292 - 16309) < (2991 - (1058 + 125)))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v167 = 1 + 0;
			end
			if (((4804 - (815 + 160)) > (16171 - 12402)) and (v167 == (2 - 1))) then
				if (((355 + 1130) <= (8488 - 5584)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((1903 - (41 + 1857)) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) then
					if (((6162 - (1222 + 671)) == (11033 - 6764)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 13";
					end
				end
				if (((556 - 169) <= (3964 - (229 + 953))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((3673 - (1111 + 663)) <= (2496 - (874 + 705)))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and ((((v14:IsCasting(v90.Fireball) and ((v90.Fireball:ExecuteRemains() < (0.5 + 0)) or not v90.Hyperthermia:IsAvailable())) or (v14:IsCasting(v90.Pyroblast) and ((v90.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v90.Hyperthermia:IsAvailable()))) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (6 - 3))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (0 + 0))))))) or ((4991 - (642 + 37)) <= (200 + 676))) then
					if (((358 + 1874) <= (6517 - 3921)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				v167 = 456 - (233 + 221);
			end
			if (((4844 - 2749) < (3245 + 441)) and (v167 == (1544 - (718 + 823)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(19 + 11, 807 - (266 + 539)) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((5 - 3) * v125)) and v14:BuffDown(v90.HotStreakBuff)) or ((2820 - (636 + 589)) >= (10619 - 6145))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((9526 - 4907) < (2284 + 598))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) or ((107 + 187) >= (5846 - (657 + 358)))) then
					if (((5372 - 3343) <= (7025 - 3941)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or ((3224 - (1151 + 36)) == (2337 + 83))) then
					if (((1173 + 3285) > (11658 - 7754)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v167 = 1836 - (1552 + 280);
			end
			if (((1270 - (64 + 770)) >= (84 + 39)) and (v167 == (4 - 2))) then
				if (((89 + 411) < (3059 - (157 + 1086))) and v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(1 - 0, v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v126 < v98)) then
					if (((15653 - 12079) == (5482 - 1908)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((301 - 80) < (1209 - (599 + 220))) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((7 - 3) * v125))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((4144 - (1813 + 118)) <= (1039 + 382))) then
						return "scorch standard_rotation 19";
					end
				end
				if (((4275 - (841 + 376)) < (6810 - 1950)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((3537 - 2241) >= (5305 - (464 + 395)))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v167 = 7 - 4;
			end
			if ((v167 == (3 + 2)) or ((2230 - (467 + 370)) > (9276 - 4787))) then
				if ((v34 and v90.DragonsBreath:IsReady() and v39 and (v128 > (1 + 0)) and v90.AlexstraszasFury:IsAvailable()) or ((15165 - 10741) < (5 + 22))) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(23 - 13)) or ((2517 - (150 + 370)) > (5097 - (74 + 1208)))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if (((8522 - 5057) > (9072 - 7159)) and v90.Scorch:IsReady() and v47 and (v135())) then
					if (((522 + 211) < (2209 - (14 + 376))) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v34 and v90.ArcaneExplosion:IsReady() and v37 and (v129 >= v102) and (v14:ManaPercentageP() >= v103)) or ((7623 - 3228) == (3077 + 1678))) then
					if (v24(v90.ArcaneExplosion, not v15:IsInRange(8 + 0)) or ((3618 + 175) < (6941 - 4572))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v167 = 5 + 1;
			end
			if ((v167 == (82 - (23 + 55))) or ((9678 - 5594) == (177 + 88))) then
				if (((3914 + 444) == (6756 - 2398)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (0 + 0)) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (903.5 - (652 + 249))) or ((v90.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1871 - (708 + 1160)) * v125)))))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((8517 - 5379) < (1810 - 817))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (((3357 - (10 + 17)) > (522 + 1801)) and v32) then
					return v32;
				end
				v167 = 1737 - (1400 + 332);
			end
		end
	end
	local function v152()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (1911 - (242 + 1666))) or ((1552 + 2074) == (1462 + 2527))) then
				if ((v126 >= v100) or ((781 + 135) == (3611 - (850 + 90)))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				if (((475 - 203) == (1662 - (360 + 1030))) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 + 0)) and (v126 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v90.FireBlast:ChargesFractional() >= (2 - 0)))) then
					if (((5910 - (909 + 752)) <= (6062 - (109 + 1114))) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast main 14";
					end
				end
				if (((5083 - 2306) < (1246 + 1954)) and v120 and v133() and (v110 > (242 - (6 + 236)))) then
					local v231 = 0 + 0;
					while true do
						if (((77 + 18) < (4614 - 2657)) and (v231 == (0 - 0))) then
							v32 = v150();
							if (((1959 - (1076 + 57)) < (283 + 1434)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v168 = 693 - (579 + 110);
			end
			if (((113 + 1313) >= (977 + 128)) and (v168 == (0 + 0))) then
				if (((3161 - (174 + 233)) <= (9438 - 6059)) and not v96) then
					v149();
				end
				if ((v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (70 - 30)))) or ((1747 + 2180) == (2587 - (663 + 511)))) then
					if (v24(v90.TimeWarp, not v15:IsInRange(36 + 4)) or ((251 + 903) <= (2429 - 1641))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v75 < v124) or ((995 + 648) > (7954 - 4575))) then
					if ((v83 and ((v35 and v84) or not v84)) or ((6785 - 3982) > (2171 + 2378))) then
						v32 = v141();
						if (v32 or ((428 - 208) >= (2154 + 868))) then
							return v32;
						end
					end
				end
				v168 = 1 + 0;
			end
			if (((3544 - (478 + 244)) == (3339 - (440 + 77))) and (v168 == (1 + 0))) then
				v112 = v110 > v90.ShiftingPower:CooldownRemains();
				v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (3 - 2)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((1568 - (655 + 901)) / v90.FireBlast:Cooldown()) % (1 + 0)))) and (v110 < v124);
				if ((not v96 and ((v110 <= (0 + 0)) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) or ((717 + 344) == (7481 - 5624))) then
					local v232 = 1445 - (695 + 750);
					while true do
						if (((9424 - 6664) > (2104 - 740)) and ((0 - 0) == v232)) then
							v32 = v148();
							if (v32 or ((5253 - (285 + 66)) <= (8380 - 4785))) then
								return v32;
							end
							break;
						end
					end
				end
				v168 = 1312 - (682 + 628);
			end
			if ((v168 == (1 + 4)) or ((4151 - (176 + 123)) == (123 + 170))) then
				if ((v90.Scorch:IsReady() and v47) or ((1131 + 428) == (4857 - (239 + 30)))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((1219 + 3265) == (758 + 30))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((8084 - 3516) >= (12189 - 8282)) and (v168 == (319 - (306 + 9)))) then
				if (((4347 - 3101) < (604 + 2866)) and v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) then
					if (((2496 + 1572) >= (468 + 504)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
						return "fire_blast main 16";
					end
				end
				if (((1409 - 916) < (5268 - (1140 + 235))) and (v110 > (0 + 0)) and v120) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (0 + 0)) or ((1525 - (33 + 19)) >= (1204 + 2128))) then
							v32 = v151();
							if (v32 or ((12141 - 8090) <= (510 + 647))) then
								return v32;
							end
							break;
						end
					end
				end
				if (((1184 - 580) < (2702 + 179)) and v90.IceNova:IsCastable() and not v135()) then
					if (v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova)) or ((1589 - (586 + 103)) == (308 + 3069))) then
						return "ice_nova main 18";
					end
				end
				v168 = 15 - 10;
			end
			if (((5947 - (1309 + 179)) > (1066 - 475)) and (v168 == (1 + 1))) then
				if (((9125 - 5727) >= (1810 + 585)) and not v114 and v90.SunKingsBlessing:IsAvailable()) then
					v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((5 - 2) * v125));
				end
				if ((v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (0 - 0)) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) or ((2792 - (295 + 314)) >= (6935 - 4111))) then
					if (((3898 - (1300 + 662)) == (6079 - 4143)) and v24(v90.ShiftingPower, not v15:IsInRange(1795 - (1178 + 577)), true)) then
						return "shifting_power main 12";
					end
				end
				if ((v126 < v100) or ((2510 + 2322) < (12749 - 8436))) then
					v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + (1412 - (851 + 554))) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
				end
				v168 = 3 + 0;
			end
		end
	end
	local function v153()
		local v169 = 0 - 0;
		while true do
			if (((8878 - 4790) > (4176 - (115 + 187))) and (v169 == (2 + 0))) then
				v47 = EpicSettings.Settings['useScorch'];
				v48 = EpicSettings.Settings['useCounterspell'];
				v49 = EpicSettings.Settings['useBlastWave'];
				v50 = EpicSettings.Settings['useCombustion'];
				v51 = EpicSettings.Settings['useShiftingPower'];
				v169 = 3 + 0;
			end
			if (((17070 - 12738) == (5493 - (160 + 1001))) and (v169 == (0 + 0))) then
				v37 = EpicSettings.Settings['useArcaneExplosion'];
				v38 = EpicSettings.Settings['useArcaneIntellect'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFireball'];
				v169 = 1 + 0;
			end
			if (((8185 - 4186) >= (3258 - (237 + 121))) and (v169 == (901 - (525 + 372)))) then
				v57 = EpicSettings.Settings['useIceBlock'];
				v58 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v59 = EpicSettings.Settings['useMirrorImage'];
				v61 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v169 = 16 - 11;
			end
			if ((v169 == (143 - (96 + 46))) or ((3302 - (643 + 134)) > (1468 + 2596))) then
				v42 = EpicSettings.Settings['useFlamestrike'];
				v43 = EpicSettings.Settings['useLivingBomb'];
				v44 = EpicSettings.Settings['useMeteor'];
				v45 = EpicSettings.Settings['usePhoenixFlames'];
				v46 = EpicSettings.Settings['usePyroblast'];
				v169 = 4 - 2;
			end
			if (((16228 - 11857) == (4192 + 179)) and (v169 == (9 - 4))) then
				v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
				v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (719 - (316 + 403));
				v64 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v65 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v66 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v169 = 14 - 8;
			end
			if ((v169 == (3 + 0)) or ((86 + 180) > (17276 - 12290))) then
				v52 = EpicSettings.Settings['combustionWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['useAlterTime'];
				v55 = EpicSettings.Settings['useBlazingBarrier'];
				v56 = EpicSettings.Settings['useGreaterInvisibility'];
				v169 = 19 - 15;
			end
			if (((4136 - 2145) >= (53 + 872)) and (v169 == (11 - 5))) then
				v67 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v86 = EpicSettings.Settings['mirrorImageBeforePull'];
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v154()
		local v170 = 0 - 0;
		while true do
			if (((472 - (12 + 5)) < (7973 - 5920)) and ((5 - 2) == v170)) then
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v170 = 8 - 4;
			end
			if ((v170 == (12 - 7)) or ((168 + 658) == (6824 - (1656 + 317)))) then
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((164 + 19) == (147 + 36)) and (v170 == (10 - 6))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (354 - (5 + 349));
				v170 = 23 - 18;
			end
			if (((2430 - (266 + 1005)) <= (1179 + 609)) and (v170 == (6 - 4))) then
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v82 = EpicSettings.Settings['useRacials'];
				v170 = 3 - 0;
			end
			if ((v170 == (1696 - (561 + 1135))) or ((4570 - 1063) > (14193 - 9875))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (1066 - (507 + 559));
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v170 = 2 - 1;
			end
			if ((v170 == (3 - 2)) or ((3463 - (212 + 176)) <= (3870 - (250 + 655)))) then
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v170 = 5 - 3;
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
		if (((2385 - 1020) <= (3146 - 1135)) and v14:IsDeadOrGhost()) then
			return v32;
		end
		v131 = v15:GetEnemiesInSplashRange(1961 - (1869 + 87));
		v130 = v14:GetEnemiesInRange(138 - 98);
		if (v34 or ((4677 - (484 + 1417)) > (7662 - 4087))) then
			local v181 = 0 - 0;
			while true do
				if ((v181 == (773 - (48 + 725))) or ((4171 - 1617) == (12888 - 8084))) then
					v126 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v130);
					v127 = v30(v15:GetEnemiesInSplashRangeCount(13 - 8), #v130);
					v181 = 1 + 0;
				end
				if (((752 + 1825) == (3430 - (152 + 701))) and ((1312 - (430 + 881)) == v181)) then
					v128 = v30(v15:GetEnemiesInSplashRangeCount(2 + 3), #v130);
					v129 = #v130;
					break;
				end
			end
		else
			local v182 = 895 - (557 + 338);
			while true do
				if ((v182 == (1 + 0)) or ((16 - 10) >= (6614 - 4725))) then
					v128 = 2 - 1;
					v129 = 2 - 1;
					break;
				end
				if (((1307 - (499 + 302)) <= (2758 - (39 + 827))) and (v182 == (0 - 0))) then
					v126 = 2 - 1;
					v127 = 3 - 2;
					v182 = 1 - 0;
				end
			end
		end
		if (v94.TargetIsValid() or v14:AffectingCombat() or ((172 + 1836) > (6491 - 4273))) then
			local v183 = 0 + 0;
			while true do
				if (((599 - 220) <= (4251 - (103 + 1))) and (v183 == (556 - (475 + 79)))) then
					v132 = v139(v130);
					v96 = not v35;
					v183 = 6 - 3;
				end
				if ((v183 == (3 - 2)) or ((584 + 3930) <= (888 + 121))) then
					v124 = v123;
					if ((v124 == (12614 - (1395 + 108))) or ((10173 - 6677) == (2396 - (7 + 1197)))) then
						v124 = v10.FightRemains(v130, false);
					end
					v183 = 1 + 1;
				end
				if ((v183 == (2 + 2)) or ((527 - (27 + 292)) == (8670 - 5711))) then
					v119 = v14:BuffUp(v90.CombustionBuff);
					v120 = not v119;
					break;
				end
				if (((5453 - 1176) >= (5506 - 4193)) and (v183 == (5 - 2))) then
					if (((4926 - 2339) < (3313 - (43 + 96))) and v96) then
						v110 = 407908 - 307909;
					end
					v125 = v14:GCD();
					v183 = 8 - 4;
				end
				if ((v183 == (0 + 0)) or ((1164 + 2956) <= (4344 - 2146))) then
					if (v14:AffectingCombat() or v69 or ((612 + 984) == (1607 - 749))) then
						local v234 = v69 and v90.RemoveCurse:IsReady() and v36;
						v32 = v94.FocusUnit(v234, nil, 7 + 13, nil, 2 + 18, v90.ArcaneIntellect);
						if (((4971 - (1414 + 337)) == (5160 - (1642 + 298))) and v32) then
							return v32;
						end
					end
					v123 = v10.BossFightRemains(nil, true);
					v183 = 2 - 1;
				end
			end
		end
		if ((not v14:AffectingCombat() and v33) or ((4033 - 2631) > (10742 - 7122))) then
			local v184 = 0 + 0;
			while true do
				if (((2003 + 571) == (3546 - (357 + 615))) and ((0 + 0) == v184)) then
					v32 = v145();
					if (((4411 - 2613) < (2363 + 394)) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if ((v14:AffectingCombat() and v94.TargetIsValid()) or ((807 - 430) > (2083 + 521))) then
			local v185 = 0 + 0;
			while true do
				if (((358 + 210) < (2212 - (384 + 917))) and (v185 == (697 - (128 + 569)))) then
					if (((4828 - (1407 + 136)) < (6115 - (687 + 1200))) and v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) then
						if (((5626 - (556 + 1154)) > (11708 - 8380)) and v24(v92.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((2595 - (9 + 86)) < (4260 - (275 + 146))) and v69 and v36 and v90.RemoveCurse:IsAvailable()) then
						local v235 = 0 + 0;
						while true do
							if (((571 - (29 + 35)) == (2246 - 1739)) and (v235 == (0 - 0))) then
								if (((1059 - 819) <= (2062 + 1103)) and v16) then
									local v237 = 1012 - (53 + 959);
									while true do
										if (((1242 - (312 + 96)) >= (1397 - 592)) and ((285 - (147 + 138)) == v237)) then
											v32 = v143();
											if (v32 or ((4711 - (813 + 86)) < (2093 + 223))) then
												return v32;
											end
											break;
										end
									end
								end
								if ((v18 and v18:Exists() and v18:IsAPlayer() and v94.UnitHasCurseDebuff(v18)) or ((4913 - 2261) <= (2025 - (18 + 474)))) then
									if (v90.RemoveCurse:IsReady() or ((1214 + 2384) < (4765 - 3305))) then
										if (v24(v92.RemoveCurseMouseover) or ((5202 - (860 + 226)) < (1495 - (121 + 182)))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					v32 = v144();
					v185 = 1 + 0;
				end
				if ((v185 == (1243 - (988 + 252))) or ((382 + 2995) <= (283 + 620))) then
					v32 = v152();
					if (((5946 - (49 + 1921)) >= (1329 - (223 + 667))) and v32) then
						return v32;
					end
					break;
				end
				if (((3804 - (51 + 1)) == (6457 - 2705)) and (v185 == (1 - 0))) then
					if (((5171 - (146 + 979)) > (761 + 1934)) and v32) then
						return v32;
					end
					if (v70 or ((4150 - (311 + 294)) == (8915 - 5718))) then
						if (((1015 + 1379) > (1816 - (496 + 947))) and v89) then
							v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 1388 - (1233 + 125));
							if (((1687 + 2468) <= (3797 + 435)) and v32) then
								return v32;
							end
						end
					end
					if (v71 or ((681 + 2900) == (5118 - (963 + 682)))) then
						local v236 = 0 + 0;
						while true do
							if (((6499 - (504 + 1000)) > (2255 + 1093)) and (v236 == (0 + 0))) then
								v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseover, 3 + 27);
								if (v32 or ((1111 - 357) > (3182 + 542))) then
									return v32;
								end
								break;
							end
						end
					end
					v185 = 2 + 0;
				end
				if (((399 - (156 + 26)) >= (33 + 24)) and (v185 == (2 - 0))) then
					if ((v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) or ((2234 - (149 + 15)) >= (4997 - (890 + 70)))) then
						if (((2822 - (39 + 78)) == (3187 - (14 + 468))) and v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((134 - 73) == (170 - 109)) and (v14:IsCasting(v90.Pyroblast) or v14:IsChanneling(v90.Pyroblast) or v14:IsCasting(v90.Flamestrike) or v14:IsChanneling(v90.Flamestrike)) and v14:BuffUp(v90.HotStreakBuff)) then
						if (v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast), false, true) or ((361 + 338) >= (779 + 517))) then
							return "Stop Casting";
						end
					end
					if ((v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes)) or ((379 + 1404) >= (1634 + 1982))) then
						if (v24(v90.IceFloes) or ((1026 + 2887) > (8665 - 4138))) then
							return "ice_floes movement";
						end
					end
					v185 = 3 + 0;
				end
			end
		end
	end
	local function v156()
		local v175 = 0 - 0;
		while true do
			if (((111 + 4265) > (868 - (12 + 39))) and (v175 == (0 + 0))) then
				v95();
				v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(194 - 131, v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

