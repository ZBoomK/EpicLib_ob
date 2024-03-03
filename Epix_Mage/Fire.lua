local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2026 + 1136) == (346 + 2816)) and not v5) then
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
		if (v89.RemoveCurse:IsAvailable() or ((3415 - (82 + 964)) > (4296 + 133))) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (516 - (409 + 103))) or (1235 - (46 + 190));
	local v98 = 1094 - (51 + 44);
	local v99 = v97;
	local v100 = ((1 + 2) * v27(v89.FueltheFire:IsAvailable())) + ((2316 - (1114 + 203)) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 1725 - (228 + 498);
	local v102 = 9 + 31;
	local v103 = 552 + 447;
	local v104 = 663.3 - (174 + 489);
	local v105 = 0 - 0;
	local v106 = 1911 - (830 + 1075);
	local v107 = false;
	local v108 = (v107 and (544 - (303 + 221))) or (1269 - (231 + 1038));
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (1163 - (171 + 991));
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 - 0;
	local v115 = 0 - 0;
	local v116 = 19 - 11;
	local v117 = 3 + 0;
	local v118;
	local v119;
	local v120;
	local v121 = 10 - 7;
	local v122 = 32052 - 20941;
	local v123 = 17910 - 6799;
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v9:RegisterForEvent(function()
		v107 = false;
		v108 = (v107 and (61 - 41)) or (1248 - (111 + 1137));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v89.Pyroblast:RegisterInFlight();
		v89.Fireball:RegisterInFlight();
		v89.Meteor:RegisterInFlightEffect(351298 - (91 + 67));
		v89.Meteor:RegisterInFlight();
		v89.PhoenixFlames:RegisterInFlightEffect(766509 - 508967);
		v89.PhoenixFlames:RegisterInFlight();
		v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
		v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(87612 + 263528);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(258065 - (423 + 100));
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		v122 = 78 + 11033;
		v123 = 30764 - 19653;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v96 = v89.SunKingsBlessing:IsAvailable();
		v97 = ((v89.FlamePatch:IsAvailable()) and (2 + 1)) or (1770 - (326 + 445));
		v99 = v97;
		v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (210 - 120));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (801 - (530 + 181))) and v14:TimeToX(971 - (614 + 267))) or (32 - (19 + 13)))) or (0 - 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (69 - 39));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (85 - 55));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v156 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 + 0);
		v156 = v156 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(1 - 0, v89.PhoenixFlames));
		return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast) or (v156 > (0 - 0))))));
	end
	local function v138(v157)
		local v158 = 1812 - (1293 + 519);
		for v212, v213 in pairs(v157) do
			if (((8355 - 4260) >= (8310 - 5127)) and v213:DebuffUp(v89.IgniteDebuff)) then
				v158 = v158 + (1 - 0);
			end
		end
		return v158;
	end
	local function v139()
		local v159 = 0 - 0;
		local v160;
		while true do
			if ((v159 == (2 - 1)) or ((1966 + 1745) < (206 + 802))) then
				return v160;
			end
			if ((v159 == (0 - 0)) or ((243 + 806) <= (301 + 605))) then
				v160 = 0 + 0;
				if (((5609 - (709 + 387)) > (4584 - (673 + 1185))) and (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight())) then
					v160 = v160 + (2 - 1);
				end
				v159 = 3 - 2;
			end
		end
	end
	local function v140()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (1 + 0)) or ((1107 + 374) >= (3588 - 930))) then
				v31 = v93.HandleBottomTrinket(v92, v34, 10 + 30, nil);
				if (v31 or ((6420 - 3200) == (2677 - 1313))) then
					return v31;
				end
				break;
			end
			if ((v161 == (1880 - (446 + 1434))) or ((2337 - (1040 + 243)) > (10123 - 6731))) then
				v31 = v93.HandleTopTrinket(v92, v34, 1887 - (559 + 1288), nil);
				if (v31 or ((2607 - (609 + 1322)) >= (2096 - (13 + 441)))) then
					return v31;
				end
				v161 = 3 - 2;
			end
		end
	end
	local v141 = 0 - 0;
	local function v142()
		if (((20599 - 16463) > (90 + 2307)) and v89.RemoveCurse:IsReady() and v93.DispellableFriendlyUnit(72 - 52)) then
			local v216 = 0 + 0;
			while true do
				if ((v216 == (0 + 0)) or ((12861 - 8527) == (2323 + 1922))) then
					if ((v141 == (0 - 0)) or ((2827 + 1449) <= (1686 + 1345))) then
						v141 = GetTime();
					end
					if (v93.Wait(360 + 140, v141) or ((4016 + 766) <= (1174 + 25))) then
						local v226 = 433 - (153 + 280);
						while true do
							if ((v226 == (0 - 0)) or ((4367 + 497) < (751 + 1151))) then
								if (((2533 + 2306) >= (3358 + 342)) and v23(v91.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v141 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v143()
		local v162 = 0 - 0;
		while true do
			if ((v162 == (2 + 1)) or ((1742 - (89 + 578)) > (1371 + 547))) then
				if (((822 - 426) <= (4853 - (572 + 477))) and v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
					if (v23(v89.AlterTime) or ((563 + 3606) == (1313 + 874))) then
						return "alter_time defensive 6";
					end
				end
				if (((168 + 1238) == (1492 - (84 + 2))) and v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) then
					if (((2522 - 991) < (3077 + 1194)) and v23(v91.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v162 = 846 - (497 + 345);
			end
			if (((17 + 618) == (108 + 527)) and (v162 == (1334 - (605 + 728)))) then
				if (((2407 + 966) <= (7905 - 4349)) and v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) then
					if (v23(v89.IceBlock) or ((151 + 3140) < (12126 - 8846))) then
						return "ice_block defensive 3";
					end
				end
				if (((3954 + 432) >= (2418 - 1545)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
					if (((696 + 225) <= (1591 - (457 + 32))) and v23(v89.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v162 = 1 + 1;
			end
			if (((6108 - (832 + 570)) >= (908 + 55)) and (v162 == (0 + 0))) then
				if ((v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) or ((3397 - 2437) <= (422 + 454))) then
					if (v23(v89.BlazingBarrier) or ((2862 - (588 + 208)) == (2511 - 1579))) then
						return "blazing_barrier defensive 1";
					end
				end
				if (((6625 - (884 + 916)) < (10139 - 5296)) and v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 2 + 0, v89.ArcaneIntellect)) then
					if (v23(v89.MassBarrier) or ((4530 - (232 + 421)) >= (6426 - (1569 + 320)))) then
						return "mass_barrier defensive 2";
					end
				end
				v162 = 1 + 0;
			end
			if ((v162 == (1 + 1)) or ((14540 - 10225) < (2331 - (316 + 289)))) then
				if ((v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((9630 - 5951) < (29 + 596))) then
					if (v23(v89.MirrorImage) or ((6078 - (666 + 787)) < (1057 - (360 + 65)))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) or ((78 + 5) > (2034 - (79 + 175)))) then
					if (((860 - 314) <= (841 + 236)) and v23(v89.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v162 = 8 - 5;
			end
			if ((v162 == (7 - 3)) or ((1895 - (503 + 396)) > (4482 - (92 + 89)))) then
				if (((7895 - 3825) > (353 + 334)) and v76 and (v13:HealthPercentage() <= v78)) then
					local v223 = 0 + 0;
					while true do
						if (((0 - 0) == v223) or ((90 + 566) >= (7592 - 4262))) then
							if ((v80 == "Refreshing Healing Potion") or ((2175 + 317) <= (161 + 174))) then
								if (((13163 - 8841) >= (320 + 2242)) and v90.RefreshingHealingPotion:IsReady()) then
									if (v23(v91.RefreshingHealingPotion) or ((5545 - 1908) >= (5014 - (485 + 759)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v80 == "Dreamwalker's Healing Potion") or ((5504 - 3125) > (5767 - (442 + 747)))) then
								if (v90.DreamwalkersHealingPotion:IsReady() or ((1618 - (832 + 303)) > (1689 - (88 + 858)))) then
									if (((748 + 1706) > (479 + 99)) and v23(v91.RefreshingHealingPotion)) then
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
		end
	end
	local function v144()
		local v163 = 0 + 0;
		while true do
			if (((1719 - (766 + 23)) < (22007 - 17549)) and (v163 == (0 - 0))) then
				if (((1743 - 1081) <= (3298 - 2326)) and v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
					if (((5443 - (1036 + 37)) == (3099 + 1271)) and v23(v89.ArcaneIntellect)) then
						return "arcane_intellect precombat 2";
					end
				end
				if ((v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) or ((9273 - 4511) <= (678 + 183))) then
					if (v23(v89.MirrorImage) or ((2892 - (641 + 839)) == (5177 - (910 + 3)))) then
						return "mirror_image precombat 2";
					end
				end
				v163 = 2 - 1;
			end
			if ((v163 == (1685 - (1466 + 218))) or ((1456 + 1712) < (3301 - (556 + 592)))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) or ((1770 + 3206) < (2140 - (329 + 479)))) then
					if (((5482 - (174 + 680)) == (15902 - 11274)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast precombat 4";
					end
				end
				if ((v89.Fireball:IsReady() and v40) or ((111 - 57) == (283 + 112))) then
					if (((821 - (396 + 343)) == (8 + 74)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v164 = 1477 - (29 + 1448);
		while true do
			if ((v164 == (1390 - (135 + 1254))) or ((2188 - 1607) < (1316 - 1034))) then
				if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (10 + 5))) and not v135() and (v133() == (1527 - (389 + 1138))) and not v89.TemperedFlames:IsAvailable()) or ((5183 - (102 + 472)) < (2355 + 140))) then
					if (((639 + 513) == (1075 + 77)) and v23(v89.DragonsBreath, not v14:IsInRange(1555 - (320 + 1225)))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((3374 - 1478) <= (2094 + 1328)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (1479 - (157 + 1307)))) and not v135() and v89.TemperedFlames:IsAvailable()) then
					if (v23(v89.DragonsBreath, not v14:IsInRange(1869 - (821 + 1038))) or ((2470 - 1480) > (178 + 1442))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if (((0 - 0) == v164) or ((327 + 550) > (11636 - 6941))) then
				if (((3717 - (834 + 192)) >= (118 + 1733)) and v89.LivingBomb:IsReady() and v42 and (v126 > (1 + 0)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 + 0)))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((4624 - 1639) >= (5160 - (300 + 4)))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((1142 + 3134) >= (3128 - 1933)) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (362 - (112 + 250))) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((18 + 27) < v109) or (v123 < v109))))) then
					if (((8096 - 4864) <= (2687 + 2003)) and v23(v91.MeteorCursor, not v14:IsInRange(21 + 19))) then
						return "meteor active_talents 4";
					end
				end
				v164 = 1 + 0;
			end
		end
	end
	local function v146()
		local v165 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
		if (v165 or ((445 + 451) >= (2338 + 808))) then
			return v165;
		end
		if (((4475 - (1001 + 413)) >= (6596 - 3638)) and v81 and ((v84 and v34) or not v84) and (v74 < v123)) then
			if (((4069 - (244 + 638)) >= (1337 - (627 + 66))) and v89.BloodFury:IsCastable()) then
				if (((1918 - 1274) <= (1306 - (512 + 90))) and v23(v89.BloodFury)) then
					return "blood_fury combustion_cooldowns 4";
				end
			end
			if (((2864 - (1665 + 241)) > (1664 - (373 + 344))) and v89.Berserking:IsCastable() and v118) then
				if (((2026 + 2466) >= (703 + 1951)) and v23(v89.Berserking)) then
					return "berserking combustion_cooldowns 6";
				end
			end
			if (((9078 - 5636) >= (2542 - 1039)) and v89.Fireblood:IsCastable()) then
				if (v23(v89.Fireblood) or ((4269 - (35 + 1064)) <= (1066 + 398))) then
					return "fireblood combustion_cooldowns 8";
				end
			end
			if (v89.AncestralCall:IsCastable() or ((10263 - 5466) == (18 + 4370))) then
				if (((1787 - (298 + 938)) <= (1940 - (233 + 1026))) and v23(v89.AncestralCall)) then
					return "ancestral_call combustion_cooldowns 10";
				end
			end
		end
		if (((4943 - (636 + 1030)) > (209 + 198)) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) then
			if (((4586 + 109) >= (421 + 994)) and v23(v89.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v74 < v123) or ((218 + 2994) <= (1165 - (55 + 166)))) then
			if ((v82 and ((v34 and v83) or not v83)) or ((600 + 2496) <= (181 + 1617))) then
				local v222 = 0 - 0;
				while true do
					if (((3834 - (36 + 261)) == (6185 - 2648)) and (v222 == (1368 - (34 + 1334)))) then
						v31 = v140();
						if (((1476 + 2361) >= (1220 + 350)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v147()
		if ((v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) or ((4233 - (1035 + 248)) == (3833 - (20 + 1)))) then
			if (((2461 + 2262) >= (2637 - (134 + 185))) and v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if ((v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) or ((3160 - (549 + 584)) > (3537 - (314 + 371)))) then
			if (v23(v89.BagofTricks) or ((3899 - 2763) > (5285 - (478 + 490)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((2516 + 2232) == (5920 - (786 + 386))) and v89.LivingBomb:IsReady() and v33 and v42 and (v126 > (3 - 2)) and v119) then
			if (((5115 - (1055 + 324)) <= (6080 - (1093 + 247))) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (18 + 2)) or ((357 + 3033) <= (12148 - 9088))) then
			local v217 = 0 - 0;
			while true do
				if ((v217 == (0 - 0)) or ((2510 - 1511) > (958 + 1735))) then
					v31 = v146();
					if (((1783 - 1320) < (2071 - 1470)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(23 + 7, 4 - 2) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((692 - (364 + 324)) * v124)) and v13:BuffDown(v89.HotStreakBuff)) or ((5983 - 3800) < (1648 - 961))) then
			if (((1508 + 3041) == (19034 - 14485)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v31 = v145();
		if (((7481 - 2809) == (14189 - 9517)) and v31) then
			return v31;
		end
		if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (1268 - (1249 + 19))) and v119 and (v109 <= (0 + 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((14277 - 10609) < (1481 - (686 + 400)))) then
			if (v23(v89.Combustion, not v14:IsInRange(32 + 8), nil, true) or ((4395 - (73 + 156)) == (3 + 452))) then
				return "combustion combustion_phase 10";
			end
		end
		if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((5260 - (721 + 90)) == (30 + 2633))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(129 - 89)) or ((4747 - (224 + 246)) < (4841 - 1852))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((1601 - 731) >= (753 + 3396))) then
			if (((53 + 2159) < (2338 + 845)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((9236 - 4590) > (9956 - 6964)) and v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (515 - (203 + 310))) and not v135()) then
			if (((3427 - (1238 + 755)) < (217 + 2889)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
				return "fireball combustion_phase 16";
			end
		end
		if (((2320 - (709 + 825)) < (5569 - 2546)) and v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((3556 - 1114) < (938 - (196 + 668)))) then
				return "scorch combustion_phase 18";
			end
		end
		if (((17905 - 13370) == (9393 - 4858)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((837 - (171 + 662)) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (93 - (4 + 89))))) < (6 - 4))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((1096 + 1913) <= (9245 - 7140))) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((718 + 1112) < (5155 - (35 + 1451))) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
			if (v23(v91.FlamestrikeCursor, not v14:IsInRange(1493 - (28 + 1425))) or ((3423 - (941 + 1052)) >= (3464 + 148))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((4197 - (822 + 692)) >= (3512 - 1052)) and v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast)) or ((850 + 954) >= (3572 - (45 + 252)))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) or ((1403 + 14) > (1249 + 2380))) then
			if (((11669 - 6874) > (835 - (114 + 319))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if (((6909 - 2096) > (4568 - 1003)) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(1 + 0, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) then
			if (((5827 - 1915) == (8196 - 4284)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((4784 - (556 + 1407)) <= (6030 - (741 + 465))) and v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (465 - (170 + 295))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
			if (((916 + 822) <= (2017 + 178)) and v23(v89.ShiftingPower, not v14:IsInRange(98 - 58))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((34 + 7) <= (1936 + 1082)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) then
			if (((1215 + 930) <= (5334 - (957 + 273))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(11 + 29))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if (((1077 + 1612) < (18461 - 13616)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
			if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast)) or ((6118 - 3796) > (8008 - 5386))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((19 - 15) * v124)) and (v127 < v99)) or ((6314 - (389 + 1391)) == (1307 + 775))) then
			if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((164 + 1407) > (4250 - 2383))) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(981 - (783 + 168), 6 - 4) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (2 + 0)) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((315 - (309 + 2)) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (2 - 1)) or v13:BuffUp(v89.FlamesFuryBuff))) or ((3866 - (1090 + 122)) >= (972 + 2024))) then
			if (((13359 - 9381) > (1440 + 664)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if (((4113 - (628 + 490)) > (277 + 1264)) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) then
			if (((8043 - 4794) > (4355 - 3402)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v89.PhoenixFlames:IsCastable() and v44 and not v13:HasTier(804 - (431 + 343), 3 - 1) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (5 - 3))) or ((2586 + 687) > (585 + 3988))) then
			if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames)) or ((4846 - (556 + 1139)) < (1299 - (6 + 9)))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) or ((339 + 1511) == (784 + 745))) then
			if (((990 - (28 + 141)) < (823 + 1300)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
				return "scorch combustion_phase 44";
			end
		end
		if (((1112 - 210) < (1647 + 678)) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) then
			if (((2175 - (486 + 831)) <= (7707 - 4745)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball))) then
				return "fireball combustion_phase 46";
			end
		end
		if ((v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (3 - 2))) or ((746 + 3200) < (4072 - 2784))) then
			if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb)) or ((4505 - (668 + 595)) == (511 + 56))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v125 < v99)) + (v89.Flamestrike:CastTime() * v27(v125 >= v99))) - v104;
		v109 = v114;
		if ((v89.Firestarter:IsAvailable() and not v96) or ((171 + 676) >= (3444 - 2181))) then
			v109 = v29(v133(), v109);
		end
		if ((v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) or ((2543 - (23 + 267)) == (3795 - (1129 + 815)))) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (390 - (371 + 16)) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((v114 + ((1870 - (1326 + 424)) * ((1 - 0) - (((0.4 - 0) + ((118.2 - (88 + 30)) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (791 - (720 + 51)))) or ((4642 - 2555) > (4148 - (421 + 1355)))) then
			v109 = v114;
		end
	end
	local function v149()
		if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 - 0)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (1 + 0)) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((1085 - (286 + 797)) * v124)))) or ((16249 - 11804) < (6871 - 2722))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((2257 - (397 + 42)) == (27 + 58))) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if (((1430 - (24 + 776)) < (3276 - 1149)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (786 - (222 + 563))) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(66 - 36, 2 + 0) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((192 - (23 + 167)) * v124)))) then
			if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true) or ((3736 - (690 + 1108)) == (908 + 1606))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v150()
		local v166 = 0 + 0;
		while true do
			if (((5103 - (40 + 808)) >= (10 + 45)) and (v166 == (0 - 0))) then
				if (((2867 + 132) > (612 + 544)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v97) and v137()) then
					if (((1289 + 1061) > (1726 - (47 + 524))) and v23(v91.FlamestrikeCursor, not v14:IsInRange(26 + 14))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((11013 - 6984) <= (7256 - 2403)) and v89.Pyroblast:IsReady() and v45 and (v137())) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((1176 - 660) > (5160 - (1165 + 561)))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((121 + 3925) >= (9393 - 6360)) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v125 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(16 + 24)) or ((3198 - (341 + 138)) <= (391 + 1056))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((10 - 5) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((4460 - (89 + 237)) < (12629 - 8703))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((344 - 180) >= (3666 - (581 + 300)))) then
						return "scorch standard_rotation 13";
					end
				end
				v166 = 1221 - (855 + 365);
			end
			if ((v166 == (4 - 2)) or ((172 + 353) == (3344 - (1030 + 205)))) then
				if (((31 + 2) == (31 + 2)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((288 - (156 + 130)) * v124)))) then
					if (((6938 - 3884) <= (6766 - 2751)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((3831 - 1960) < (892 + 2490)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(18 + 12, 71 - (10 + 59)) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((1 + 1) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((6367 - 5074) <= (3329 - (671 + 492))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((2054 + 525) < (1338 - (369 + 846)))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((224 + 622) >= (2021 + 347))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or ((5957 - (1036 + 909)) <= (2670 + 688))) then
					if (((2507 - 1013) <= (3208 - (11 + 192))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v166 = 2 + 1;
			end
			if ((v166 == (179 - (135 + 40))) or ((7537 - 4426) == (1287 + 847))) then
				if (((5187 - 2832) == (3530 - 1175)) and v89.Scorch:IsReady() and v46 and (v134())) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((764 - (50 + 126)) <= (1202 - 770))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((1062 + 3735) >= (5308 - (1233 + 180))) and v33 and v89.ArcaneExplosion:IsReady() and v36 and (v128 >= v101) and (v13:ManaPercentageP() >= v102)) then
					if (((4546 - (522 + 447)) == (4998 - (107 + 1314))) and v23(v89.ArcaneExplosion, not v14:IsInRange(4 + 4))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if (((11560 - 7766) > (1569 + 2124)) and v33 and v89.Flamestrike:IsReady() and v41 and (v125 >= v98)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(79 - 39)) or ((5044 - 3769) == (6010 - (716 + 1194)))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) or ((28 + 1563) >= (384 + 3196))) then
					if (((1486 - (74 + 429)) <= (3487 - 1679)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 35";
					end
				end
				v166 = 3 + 2;
			end
			if ((v166 == (11 - 6)) or ((1522 + 628) <= (3690 - 2493))) then
				if (((9318 - 5549) >= (1606 - (279 + 154))) and v89.Fireball:IsReady() and v40 and not v137()) then
					if (((2263 - (454 + 324)) == (1169 + 316)) and v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true)) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v166 == (18 - (12 + 5))) or ((1788 + 1527) <= (7088 - 4306))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((324 + 552) >= (4057 - (277 + 816)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((9537 - 7305) > (3680 - (1058 + 125)))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and ((((v13:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 + 0)) or not v89.Hyperthermia:IsAvailable())) or (v13:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (975.5 - (815 + 160))) or not v89.Hyperthermia:IsAvailable()))) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (12 - 9))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (0 - 0))))))) or ((504 + 1606) <= (970 - 638))) then
					if (((5584 - (41 + 1857)) > (5065 - (1222 + 671))) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(2 - 1, v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) or ((6430 - 1956) < (2002 - (229 + 953)))) then
					if (((6053 - (1111 + 663)) >= (4461 - (874 + 705))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((1 + 3) * v124))) or ((1385 + 644) >= (7318 - 3797))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((58 + 1979) >= (5321 - (642 + 37)))) then
						return "scorch standard_rotation 19";
					end
				end
				v166 = 1 + 1;
			end
			if (((276 + 1444) < (11192 - 6734)) and (v166 == (457 - (233 + 221)))) then
				if ((v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (0 - 0)) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (2.5 + 0)) or ((v89.PhoenixFlames:ChargesFractional() > (1542.5 - (718 + 823))) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 1) * v124)))))) or ((1241 - (266 + 539)) > (8553 - 5532))) then
					if (((1938 - (636 + 589)) <= (2010 - 1163)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v145();
				if (((4442 - 2288) <= (3195 + 836)) and v31) then
					return v31;
				end
				if (((1677 + 2938) == (5630 - (657 + 358))) and v33 and v89.DragonsBreath:IsReady() and v38 and (v127 > (2 - 1)) and v89.AlexstraszasFury:IsAvailable()) then
					if (v23(v89.DragonsBreath, not v14:IsInRange(22 - 12)) or ((4977 - (1151 + 36)) == (483 + 17))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v166 = 2 + 2;
			end
		end
	end
	local function v151()
		local v167 = 0 - 0;
		while true do
			if (((1921 - (1552 + 280)) < (1055 - (64 + 770))) and (v167 == (2 + 0))) then
				if (((4662 - 2608) >= (253 + 1168)) and not v113 and v89.SunKingsBlessing:IsAvailable()) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((1246 - (157 + 1086)) * v124));
				end
				if (((1384 - 692) < (13393 - 10335)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (0 - 0)) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(54 - 14), true) or ((4073 - (599 + 220)) == (3295 - 1640))) then
						return "shifting_power main 12";
					end
				end
				if ((v125 < v99) or ((3227 - (1813 + 118)) == (3590 + 1320))) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (1224 - (841 + 376))) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				v167 = 3 - 0;
			end
			if (((783 + 2585) == (9192 - 5824)) and (v167 == (864 - (464 + 395)))) then
				if (((6782 - 4139) < (1833 + 1982)) and v89.Scorch:IsReady() and v46) then
					if (((2750 - (467 + 370)) > (1018 - 525)) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((3491 + 1264) > (11751 - 8323)) and (v167 == (1 + 2))) then
				if (((3212 - 1831) <= (2889 - (150 + 370))) and (v125 >= v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (1282 - (74 + 1208))) and (v125 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (9 - 7)))) or ((3447 + 1396) == (4474 - (14 + 376)))) then
					if (((8097 - 3428) > (235 + 128)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast main 14";
					end
				end
				if ((v119 and v132() and (v109 > (0 + 0))) or ((1791 + 86) >= (9194 - 6056))) then
					v31 = v149();
					if (((3568 + 1174) >= (3704 - (23 + 55))) and v31) then
						return v31;
					end
				end
				v167 = 9 - 5;
			end
			if ((v167 == (1 + 0)) or ((4077 + 463) == (1420 - 504))) then
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (1 + 0)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((913 - (652 + 249)) / v89.FireBlast:Cooldown()) % (2 - 1)))) and (v109 < v123);
				if ((not v95 and ((v109 <= (1868 - (708 + 1160))) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) or ((3137 - 1981) > (7921 - 3576))) then
					v31 = v147();
					if (((2264 - (10 + 17)) < (955 + 3294)) and v31) then
						return v31;
					end
				end
				v167 = 1734 - (1400 + 332);
			end
			if ((v167 == (7 - 3)) or ((4591 - (242 + 1666)) < (10 + 13))) then
				if (((256 + 441) <= (704 + 122)) and v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) then
					if (((2045 - (850 + 90)) <= (2059 - 883)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast main 16";
					end
				end
				if (((4769 - (360 + 1030)) <= (3374 + 438)) and (v109 > (0 - 0)) and v119) then
					v31 = v150();
					if (v31 or ((1083 - 295) >= (3277 - (909 + 752)))) then
						return v31;
					end
				end
				if (((3077 - (109 + 1114)) <= (6185 - 2806)) and v89.IceNova:IsCastable() and not v134()) then
					if (((1771 + 2778) == (4791 - (6 + 236))) and v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova))) then
						return "ice_nova main 18";
					end
				end
				v167 = 4 + 1;
			end
			if ((v167 == (0 + 0)) or ((7126 - 4104) >= (5281 - 2257))) then
				if (((5953 - (1076 + 57)) > (362 + 1836)) and not v95) then
					v148();
				end
				if ((v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (729 - (579 + 110))))) or ((84 + 977) >= (4325 + 566))) then
					if (((724 + 640) <= (4880 - (174 + 233))) and v23(v89.TimeWarp, not v14:IsInRange(111 - 71))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v74 < v123) or ((6309 - 2714) <= (2 + 1))) then
					if ((v82 and ((v34 and v83) or not v83)) or ((5846 - (663 + 511)) == (3437 + 415))) then
						v31 = v140();
						if (((339 + 1220) == (4806 - 3247)) and v31) then
							return v31;
						end
					end
				end
				v167 = 1 + 0;
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
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v64 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v65 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v66 = EpicSettings.Settings['massBarrierHP'] or (722 - (478 + 244));
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v153()
		v74 = EpicSettings.Settings['fightRemainsCheck'] or (517 - (440 + 77));
		v75 = EpicSettings.Settings['useWeapon'];
		v71 = EpicSettings.Settings['InterruptWithStun'];
		v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v73 = EpicSettings.Settings['InterruptThreshold'];
		v68 = EpicSettings.Settings['DispelDebuffs'];
		v67 = EpicSettings.Settings['DispelBuffs'];
		v82 = EpicSettings.Settings['useTrinkets'];
		v81 = EpicSettings.Settings['useRacials'];
		v83 = EpicSettings.Settings['trinketsWithCD'];
		v84 = EpicSettings.Settings['racialsWithCD'];
		v77 = EpicSettings.Settings['useHealthstone'];
		v76 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v78 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v80 = EpicSettings.Settings['HealingPotionName'] or "";
		v69 = EpicSettings.Settings['handleAfflicted'];
		v70 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v154()
		local v210 = 1556 - (655 + 901);
		while true do
			if (((1 + 0) == v210) or ((1342 + 410) <= (533 + 255))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((15739 - 11832) == (1622 - (695 + 750)))) then
					return v31;
				end
				v130 = v14:GetEnemiesInSplashRange(16 - 11);
				v210 = 2 - 0;
			end
			if (((13955 - 10485) > (906 - (285 + 66))) and (v210 == (4 - 2))) then
				v129 = v13:GetEnemiesInRange(1350 - (682 + 628));
				if (v33 or ((157 + 815) == (944 - (176 + 123)))) then
					local v224 = 0 + 0;
					while true do
						if (((2309 + 873) >= (2384 - (239 + 30))) and ((0 + 0) == v224)) then
							v125 = v29(v14:GetEnemiesInSplashRangeCount(5 + 0), #v129);
							v126 = v29(v14:GetEnemiesInSplashRangeCount(8 - 3), #v129);
							v224 = 2 - 1;
						end
						if (((4208 - (306 + 9)) < (15455 - 11026)) and (v224 == (1 + 0))) then
							v127 = v29(v14:GetEnemiesInSplashRangeCount(4 + 1), #v129);
							v128 = #v129;
							break;
						end
					end
				else
					v125 = 1 + 0;
					v126 = 2 - 1;
					v127 = 1376 - (1140 + 235);
					v128 = 1 + 0;
				end
				if (v93.TargetIsValid() or v13:AffectingCombat() or ((2630 + 237) < (489 + 1416))) then
					if (v13:AffectingCombat() or v68 or ((1848 - (33 + 19)) >= (1463 + 2588))) then
						local v227 = 0 - 0;
						local v228;
						while true do
							if (((714 + 905) <= (7365 - 3609)) and (v227 == (0 + 0))) then
								v228 = v68 and v89.RemoveCurse:IsReady() and v35;
								v31 = v93.FocusUnit(v228, nil, 709 - (586 + 103), nil, 2 + 18, v89.ArcaneIntellect);
								v227 = 2 - 1;
							end
							if (((2092 - (1309 + 179)) == (1089 - 485)) and (v227 == (1 + 0))) then
								if (v31 or ((12042 - 7558) == (680 + 220))) then
									return v31;
								end
								break;
							end
						end
					end
					v122 = v9.BossFightRemains(nil, true);
					v123 = v122;
					if ((v123 == (23607 - 12496)) or ((8884 - 4425) <= (1722 - (295 + 314)))) then
						v123 = v9.FightRemains(v129, false);
					end
					v131 = v138(v129);
					v95 = not v34;
					if (((8920 - 5288) > (5360 - (1300 + 662))) and v95) then
						v109 = 314013 - 214014;
					end
					v124 = v13:GCD();
					v118 = v13:BuffUp(v89.CombustionBuff);
					v119 = not v118;
				end
				if (((5837 - (1178 + 577)) <= (2554 + 2363)) and not v13:AffectingCombat() and v32) then
					local v225 = 0 - 0;
					while true do
						if (((6237 - (851 + 554)) >= (1226 + 160)) and ((0 - 0) == v225)) then
							v31 = v144();
							if (((297 - 160) == (439 - (115 + 187))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v210 = 3 + 0;
			end
			if ((v210 == (3 + 0)) or ((6186 - 4616) >= (5493 - (160 + 1001)))) then
				if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((3556 + 508) <= (1256 + 563))) then
					if ((v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) or ((10206 - 5220) < (1932 - (237 + 121)))) then
						if (((5323 - (525 + 372)) > (325 - 153)) and v23(v91.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((1925 - 1339) > (597 - (96 + 46))) and v68 and v35 and v89.RemoveCurse:IsAvailable()) then
						if (((1603 - (643 + 134)) == (299 + 527)) and v15) then
							v31 = v142();
							if (v31 or ((9636 - 5617) > (16488 - 12047))) then
								return v31;
							end
						end
						if (((1935 + 82) < (8362 - 4101)) and v17 and v17:Exists() and v17:IsAPlayer() and v93.UnitHasCurseDebuff(v17)) then
							if (((9639 - 4923) > (799 - (316 + 403))) and v89.RemoveCurse:IsReady()) then
								if (v23(v91.RemoveCurseMouseover) or ((2332 + 1175) == (8995 - 5723))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					v31 = v143();
					if (v31 or ((317 + 559) >= (7743 - 4668))) then
						return v31;
					end
					if (((3085 + 1267) > (824 + 1730)) and v69) then
						if (v88 or ((15266 - 10860) < (19308 - 15265))) then
							v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 62 - 32);
							if (v31 or ((109 + 1780) >= (6659 - 3276))) then
								return v31;
							end
						end
					end
					if (((93 + 1799) <= (8043 - 5309)) and v70) then
						local v229 = 17 - (12 + 5);
						while true do
							if (((7468 - 5545) < (4732 - 2514)) and ((0 - 0) == v229)) then
								v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 74 - 44);
								if (((442 + 1731) > (2352 - (1656 + 317))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) or ((2309 + 282) == (2732 + 677))) then
						if (((12002 - 7488) > (16359 - 13035)) and v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v89.HotStreakBuff)) or ((562 - (5 + 349)) >= (22932 - 18104))) then
						if (v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast)) or ((2854 - (266 + 1005)) > (2351 + 1216))) then
							return "Stop Casting";
						end
					end
					if ((v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) or ((4479 - 3166) == (1044 - 250))) then
						if (((4870 - (561 + 1135)) > (3781 - 879)) and v23(v89.IceFloes)) then
							return "ice_floes movement";
						end
					end
					if (((13542 - 9422) <= (5326 - (507 + 559))) and v13:IsMoving() and not v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes)) then
						if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch)) or ((2215 - 1332) > (14776 - 9998))) then
							return "scorch movement";
						end
					end
					v31 = v151();
					if (v31 or ((4008 - (212 + 176)) >= (5796 - (250 + 655)))) then
						return v31;
					end
				end
				break;
			end
			if (((11611 - 7353) > (1636 - 699)) and ((0 - 0) == v210)) then
				v152();
				v153();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v210 = 1957 - (1869 + 87);
			end
		end
	end
	local function v155()
		local v211 = 0 - 0;
		while true do
			if ((v211 == (1901 - (484 + 1417))) or ((10435 - 5566) < (1517 - 611))) then
				v94();
				v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(836 - (48 + 725), v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

