local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((7039 - 4343) >= (2816 + 1716))) then
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
	local v15 = v11.Pet;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.Press;
	local v22 = v19.PressCursor;
	local v23 = v19.Macro;
	local v24 = v19.Bind;
	local v25 = v19.Commons.Everyone.num;
	local v26 = v19.Commons.Everyone.bool;
	local v27 = math.max;
	local v28 = math.ceil;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34;
	local v35;
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
	local v86 = v16.Mage.Fire;
	local v87 = v18.Mage.Fire;
	local v88 = v23.Mage.Fire;
	local v89 = {};
	local v90 = v19.Commons.Everyone;
	local function v91()
		if (((2215 - (645 + 522)) >= (1842 - (1010 + 780))) and v86.RemoveCurse:IsAvailable()) then
			v90.DispellableDebuffs = v90.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v91();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v92 = not v32;
	local v93 = v86.SunKingsBlessing:IsAvailable();
	local v94 = ((v86.FlamePatch:IsAvailable()) and (4 + 0)) or (4759 - 3760);
	local v95 = 2927 - 1928;
	local v96 = v94;
	local v97 = ((1839 - (1045 + 791)) * v25(v86.FueltheFire:IsAvailable())) + ((2528 - 1529) * v25(not v86.FueltheFire:IsAvailable()));
	local v98 = 1524 - 525;
	local v99 = 545 - (351 + 154);
	local v100 = 2573 - (1281 + 293);
	local v101 = 266.3 - (28 + 238);
	local v102 = 0 - 0;
	local v103 = 1565 - (1381 + 178);
	local v104 = false;
	local v105 = (v104 and (19 + 1)) or (0 + 0);
	local v106;
	local v107 = ((v86.Kindling:IsAvailable()) and (0.4 + 0)) or (3 - 2);
	local v108 = false;
	local v109 = false;
	local v110 = false;
	local v111 = 0 + 0;
	local v112 = 470 - (381 + 89);
	local v113 = 8 + 0;
	local v114 = 3 + 0;
	local v115;
	local v116;
	local v117;
	local v118 = 4 - 1;
	local v119 = 12267 - (1074 + 82);
	local v120 = 24349 - 13238;
	local v121;
	local v122, v123, v124;
	local v125;
	local v126;
	local v127;
	local v128;
	v9:RegisterForEvent(function()
		v104 = false;
		v105 = (v104 and (1804 - (214 + 1570))) or (1455 - (990 + 465));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v86.Pyroblast:RegisterInFlight();
		v86.Fireball:RegisterInFlight();
		v86.Meteor:RegisterInFlightEffect(144755 + 206385);
		v86.Meteor:RegisterInFlight();
		v86.PhoenixFlames:RegisterInFlightEffect(112063 + 145479);
		v86.PhoenixFlames:RegisterInFlight();
		v86.Pyroblast:RegisterInFlight(v86.CombustionBuff);
		v86.Fireball:RegisterInFlight(v86.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v86.Pyroblast:RegisterInFlight();
	v86.Fireball:RegisterInFlight();
	v86.Meteor:RegisterInFlightEffect(341466 + 9674);
	v86.Meteor:RegisterInFlight();
	v86.PhoenixFlames:RegisterInFlightEffect(1013564 - 756022);
	v86.PhoenixFlames:RegisterInFlight();
	v86.Pyroblast:RegisterInFlight(v86.CombustionBuff);
	v86.Fireball:RegisterInFlight(v86.CombustionBuff);
	v9:RegisterForEvent(function()
		local v152 = 1726 - (1668 + 58);
		while true do
			if (((3584 - (512 + 114)) < (11739 - 7236)) and (v152 == (0 - 0))) then
				v119 = 38662 - 27551;
				v120 = 5169 + 5942;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v153 = 0 + 0;
		while true do
			if ((v153 == (1 + 0)) or ((9225 - 6490) == (3303 - (109 + 1885)))) then
				v96 = v94;
				v107 = ((v86.Kindling:IsAvailable()) and (1469.4 - (1269 + 200))) or (1 - 0);
				break;
			end
			if ((v153 == (815 - (98 + 717))) or ((4956 - (802 + 24)) <= (5095 - 2140))) then
				v93 = v86.SunKingsBlessing:IsAvailable();
				v94 = ((v86.FlamePatch:IsAvailable()) and (3 - 0)) or (148 + 851);
				v153 = 1 + 0;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v129()
		return v86.Firestarter:IsAvailable() and (v14:HealthPercentage() > (15 + 75));
	end
	local function v130()
		return (v86.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (20 + 70)) and v14:TimeToX(250 - 160)) or (0 - 0))) or (0 + 0);
	end
	local function v131()
		return v86.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (13 + 17));
	end
	local function v132()
		return v86.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (25 + 5));
	end
	local function v133()
		return (v118 * v86.ShiftingPower:BaseDuration()) / v86.ShiftingPower:BaseTickTime();
	end
	local function v134()
		local v154 = 0 + 0;
		local v155;
		while true do
			if ((v154 == (1 + 0)) or ((3397 - (797 + 636)) <= (6506 - 5166))) then
				return v13:BuffUp(v86.HotStreakBuff) or v13:BuffUp(v86.HyperthermiaBuff) or (v13:BuffUp(v86.HeatingUpBuff) and ((v132() and v13:IsCasting(v86.Scorch)) or (v129() and (v13:IsCasting(v86.Fireball) or v13:IsCasting(v86.Pyroblast) or (v155 > (1619 - (1427 + 192)))))));
			end
			if (((866 + 1633) == (5801 - 3302)) and (v154 == (0 + 0))) then
				v155 = (v129() and (v25(v86.Pyroblast:InFlight()) + v25(v86.Fireball:InFlight()))) or (0 + 0);
				v155 = v155 + v25(v86.PhoenixFlames:InFlight() or v13:PrevGCDP(327 - (192 + 134), v86.PhoenixFlames));
				v154 = 1277 - (316 + 960);
			end
		end
	end
	local function v135(v156)
		local v157 = 0 + 0;
		for v183, v184 in pairs(v156) do
			if (v184:DebuffUp(v86.IgniteDebuff) or ((1741 + 514) < (21 + 1))) then
				v157 = v157 + (3 - 2);
			end
		end
		return v157;
	end
	local function v136()
		local v158 = 551 - (83 + 468);
		local v159;
		while true do
			if ((v158 == (1806 - (1202 + 604))) or ((5069 - 3983) >= (2337 - 932))) then
				v159 = 0 - 0;
				if (v86.Fireball:InFlight() or v86.PhoenixFlames:InFlight() or ((2694 - (45 + 280)) == (412 + 14))) then
					v159 = v159 + 1 + 0;
				end
				v158 = 1 + 0;
			end
			if ((v158 == (1 + 0)) or ((542 + 2534) > (5893 - 2710))) then
				return v159;
			end
		end
	end
	local function v137()
		v29 = v90.HandleTopTrinket(v89, v32, 1951 - (340 + 1571), nil);
		if (((475 + 727) > (2830 - (1733 + 39))) and v29) then
			return v29;
		end
		v29 = v90.HandleBottomTrinket(v89, v32, 109 - 69, nil);
		if (((4745 - (125 + 909)) > (5303 - (1096 + 852))) and v29) then
			return v29;
		end
	end
	local function v138()
		if ((v86.RemoveCurse:IsReady() and v33 and v90.DispellableFriendlyUnit(9 + 11)) or ((1293 - 387) >= (2162 + 67))) then
			if (((1800 - (409 + 103)) > (1487 - (46 + 190))) and v21(v88.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v139()
		if ((v86.BlazingBarrier:IsCastable() and v52 and v13:BuffDown(v86.BlazingBarrier) and (v13:HealthPercentage() <= v59)) or ((4608 - (51 + 44)) < (946 + 2406))) then
			if (v21(v86.BlazingBarrier) or ((3382 - (1114 + 203)) >= (3922 - (228 + 498)))) then
				return "blazing_barrier defensive 1";
			end
		end
		if ((v86.MassBarrier:IsCastable() and v57 and v13:BuffDown(v86.BlazingBarrier) and v90.AreUnitsBelowHealthPercentage(v64, 1 + 1)) or ((2418 + 1958) <= (2144 - (174 + 489)))) then
			if (v21(v86.MassBarrier) or ((8837 - 5445) >= (6646 - (830 + 1075)))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((3849 - (303 + 221)) >= (3423 - (231 + 1038))) and v86.IceBlock:IsCastable() and v54 and (v13:HealthPercentage() <= v61)) then
			if (v21(v86.IceBlock) or ((1080 + 215) >= (4395 - (171 + 991)))) then
				return "ice_block defensive 3";
			end
		end
		if (((18038 - 13661) > (4408 - 2766)) and v86.IceColdTalent:IsAvailable() and v86.IceColdAbility:IsCastable() and v55 and (v13:HealthPercentage() <= v62)) then
			if (((11785 - 7062) > (1086 + 270)) and v21(v86.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v86.MirrorImage:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) or ((14498 - 10362) <= (9903 - 6470))) then
			if (((6842 - 2597) <= (14315 - 9684)) and v21(v86.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if (((5524 - (111 + 1137)) >= (4072 - (91 + 67))) and v86.GreaterInvisibility:IsReady() and v53 and (v13:HealthPercentage() <= v60)) then
			if (((589 - 391) <= (1090 + 3275)) and v21(v86.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((5305 - (423 + 100)) > (33 + 4643)) and v86.AlterTime:IsReady() and v51 and (v13:HealthPercentage() <= v58)) then
			if (((13467 - 8603) > (1146 + 1051)) and v21(v86.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v87.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v76)) or ((4471 - (326 + 445)) == (10940 - 8433))) then
			if (((9967 - 5493) >= (639 - 365)) and v21(v88.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v73 and (v13:HealthPercentage() <= v75)) or ((2605 - (530 + 181)) <= (2287 - (614 + 267)))) then
			local v187 = 32 - (19 + 13);
			while true do
				if (((2558 - 986) >= (3567 - 2036)) and (v187 == (0 - 0))) then
					if ((v77 == "Refreshing Healing Potion") or ((1218 + 3469) < (7987 - 3445))) then
						if (((6824 - 3533) > (3479 - (1293 + 519))) and v87.RefreshingHealingPotion:IsReady()) then
							if (v21(v88.RefreshingHealingPotion) or ((1781 - 908) == (5310 - 3276))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v77 == "Dreamwalker's Healing Potion") or ((5384 - 2568) < (47 - 36))) then
						if (((8713 - 5014) < (2493 + 2213)) and v87.DreamwalkersHealingPotion:IsReady()) then
							if (((540 + 2106) >= (2034 - 1158)) and v21(v88.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v140()
		if (((142 + 472) <= (1058 + 2126)) and v86.ArcaneIntellect:IsCastable() and v35 and (v13:BuffDown(v86.ArcaneIntellect, true) or v90.GroupBuffMissing(v86.ArcaneIntellect))) then
			if (((1954 + 1172) == (4222 - (709 + 387))) and v21(v86.ArcaneIntellect)) then
				return "arcane_intellect precombat 2";
			end
		end
		if ((v86.MirrorImage:IsCastable() and v90.TargetIsValid() and v56 and v82) or ((4045 - (673 + 1185)) >= (14367 - 9413))) then
			if (v21(v86.MirrorImage) or ((12449 - 8572) == (5882 - 2307))) then
				return "mirror_image precombat 2";
			end
		end
		if (((506 + 201) > (473 + 159)) and v86.Pyroblast:IsReady() and v43 and not v13:IsCasting(v86.Pyroblast)) then
			if (v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast), true) or ((736 - 190) >= (660 + 2024))) then
				return "pyroblast precombat 4";
			end
		end
		if (((2921 - 1456) <= (8442 - 4141)) and v86.Fireball:IsReady() and v38) then
			if (((3584 - (446 + 1434)) > (2708 - (1040 + 243))) and v21(v86.Fireball, not v14:IsSpellInRange(v86.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v141()
		local v160 = 0 - 0;
		while true do
			if ((v160 == (1848 - (559 + 1288))) or ((2618 - (609 + 1322)) == (4688 - (13 + 441)))) then
				if ((v86.DragonsBreath:IsReady() and v36 and v86.AlexstraszasFury:IsAvailable() and v116 and v13:BuffDown(v86.HotStreakBuff) and (v13:BuffUp(v86.FeeltheBurnBuff) or (v9.CombatTime() > (55 - 40))) and not v132() and (v130() == (0 - 0)) and not v86.TemperedFlames:IsAvailable()) or ((16584 - 13254) < (54 + 1375))) then
					if (((4165 - 3018) >= (119 + 216)) and v21(v86.DragonsBreath)) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((1506 + 1929) > (6222 - 4125)) and v86.DragonsBreath:IsReady() and v36 and v86.AlexstraszasFury:IsAvailable() and v116 and v13:BuffDown(v86.HotStreakBuff) and (v13:BuffUp(v86.FeeltheBurnBuff) or (v9.CombatTime() > (9 + 6))) and not v132() and v86.TemperedFlames:IsAvailable()) then
					if (v21(v86.DragonsBreath) or ((6933 - 3163) >= (2672 + 1369))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v160 == (0 + 0)) or ((2724 + 1067) <= (1353 + 258))) then
				if ((v86.LivingBomb:IsReady() and v40 and (v123 > (1 + 0)) and v116 and ((v106 > v86.LivingBomb:CooldownRemains()) or (v106 <= (433 - (153 + 280))))) or ((13219 - 8641) <= (1803 + 205))) then
					if (((445 + 680) <= (1087 + 989)) and v21(v86.LivingBomb, not v14:IsSpellInRange(v86.LivingBomb))) then
						return "living_bomb active_talents 2";
					end
				end
				if ((v86.Meteor:IsReady() and v41 and (v72 < v120) and ((v106 <= (0 + 0)) or (v13:BuffRemains(v86.CombustionBuff) > v86.Meteor:TravelTime()) or (not v86.SunKingsBlessing:IsAvailable() and (((33 + 12) < v106) or (v120 < v106))))) or ((1131 - 388) >= (2719 + 1680))) then
					if (((1822 - (89 + 578)) < (1196 + 477)) and v21(v88.MeteorCursor, not v14:IsInRange(83 - 43))) then
						return "meteor active_talents 4";
					end
				end
				v160 = 1050 - (572 + 477);
			end
		end
	end
	local function v142()
		local v161 = v90.HandleDPSPotion(v13:BuffUp(v86.CombustionBuff));
		if (v161 or ((314 + 2010) <= (347 + 231))) then
			return v161;
		end
		if (((450 + 3317) == (3853 - (84 + 2))) and v78 and ((v81 and v32) or not v81) and (v72 < v120)) then
			if (((6738 - 2649) == (2946 + 1143)) and v86.BloodFury:IsCastable()) then
				if (((5300 - (497 + 345)) >= (43 + 1631)) and v21(v86.BloodFury)) then
					return "blood_fury combustion_cooldowns 4";
				end
			end
			if (((165 + 807) <= (2751 - (605 + 728))) and v86.Berserking:IsCastable() and v115) then
				if (v21(v86.Berserking) or ((3524 + 1414) < (10586 - 5824))) then
					return "berserking combustion_cooldowns 6";
				end
			end
			if (v86.Fireblood:IsCastable() or ((115 + 2389) > (15764 - 11500))) then
				if (((1941 + 212) == (5964 - 3811)) and v21(v86.Fireblood)) then
					return "fireblood combustion_cooldowns 8";
				end
			end
			if (v86.AncestralCall:IsCastable() or ((383 + 124) >= (3080 - (457 + 32)))) then
				if (((1902 + 2579) == (5883 - (832 + 570))) and v21(v86.AncestralCall)) then
					return "ancestral_call combustion_cooldowns 10";
				end
			end
		end
		if ((v84 and v86.TimeWarp:IsReady() and v86.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) or ((2194 + 134) < (181 + 512))) then
			if (((15315 - 10987) == (2085 + 2243)) and v21(v86.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if (((2384 - (588 + 208)) >= (3589 - 2257)) and (v72 < v120)) then
			if ((v79 and ((v32 and v80) or not v80)) or ((5974 - (884 + 916)) > (8893 - 4645))) then
				v29 = v137();
				if (v29 or ((2660 + 1926) <= (735 - (232 + 421)))) then
					return v29;
				end
			end
		end
	end
	local function v143()
		if (((5752 - (1569 + 320)) == (948 + 2915)) and v86.LightsJudgment:IsCastable() and v78 and ((v81 and v32) or not v81) and (v72 < v120) and v116) then
			if (v21(v86.LightsJudgment, not v14:IsSpellInRange(v86.LightsJudgment)) or ((54 + 228) <= (141 - 99))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((5214 - (316 + 289)) >= (2005 - 1239)) and v86.BagofTricks:IsCastable() and v78 and ((v81 and v32) or not v81) and (v72 < v120) and v116) then
			if (v21(v86.BagofTricks) or ((54 + 1098) == (3941 - (666 + 787)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if (((3847 - (360 + 65)) > (3131 + 219)) and v86.LivingBomb:IsReady() and v31 and v40 and (v123 > (255 - (79 + 175))) and v116) then
			if (((1382 - 505) > (294 + 82)) and v21(v86.LivingBomb, not v14:IsSpellInRange(v86.LivingBomb))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v13:BuffRemains(v86.CombustionBuff) > v103) or (v120 < (61 - 41)) or ((6004 - 2886) <= (2750 - (503 + 396)))) then
			v29 = v142();
			if (v29 or ((346 - (92 + 89)) >= (6773 - 3281))) then
				return v29;
			end
		end
		if (((2026 + 1923) < (2875 + 1981)) and v86.PhoenixFlames:IsCastable() and v42 and v13:BuffDown(v86.CombustionBuff) and v13:HasTier(117 - 87, 1 + 1) and not v86.PhoenixFlames:InFlight() and (v14:DebuffRemains(v86.CharringEmbersDebuff) < ((8 - 4) * v121)) and v13:BuffDown(v86.HotStreakBuff)) then
			if (v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames)) or ((3731 + 545) < (1441 + 1575))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v29 = v141();
		if (((14284 - 9594) > (515 + 3610)) and v29) then
			return v29;
		end
		if ((v86.Combustion:IsReady() and v47 and ((v49 and v32) or not v49) and (v72 < v120) and (v136() == (0 - 0)) and v116 and (v106 <= (1244 - (485 + 759))) and ((v13:IsCasting(v86.Scorch) and (v86.Scorch:ExecuteRemains() < v101)) or (v13:IsCasting(v86.Fireball) and (v86.Fireball:ExecuteRemains() < v101)) or (v13:IsCasting(v86.Pyroblast) and (v86.Pyroblast:ExecuteRemains() < v101)) or (v13:IsCasting(v86.Flamestrike) and (v86.Flamestrike:ExecuteRemains() < v101)) or (v86.Meteor:InFlight() and (v86.Meteor:InFlightRemains() < v101)))) or ((115 - 65) >= (2085 - (442 + 747)))) then
			if (v21(v86.Combustion, not v14:IsInRange(1175 - (832 + 303)), nil, true) or ((2660 - (88 + 858)) >= (902 + 2056))) then
				return "combustion combustion_phase 10";
			end
		end
		if ((v31 and v86.Flamestrike:IsReady() and v39 and not v13:IsCasting(v86.Flamestrike) and v116 and v13:BuffUp(v86.FuryoftheSunKingBuff) and (v13:BuffRemains(v86.FuryoftheSunKingBuff) > v86.Flamestrike:CastTime()) and (v86.Combustion:CooldownRemains() < v86.Flamestrike:CastTime()) and (v122 >= v97)) or ((1234 + 257) < (27 + 617))) then
			if (((1493 - (766 + 23)) < (4872 - 3885)) and v21(v88.FlamestrikeCursor, not v14:IsInRange(54 - 14))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if (((9795 - 6077) > (6468 - 4562)) and v86.Pyroblast:IsReady() and v43 and not v13:IsCasting(v86.Pyroblast) and v116 and v13:BuffUp(v86.FuryoftheSunKingBuff) and (v13:BuffRemains(v86.FuryoftheSunKingBuff) > v86.Pyroblast:CastTime())) then
			if (v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast)) or ((2031 - (1036 + 37)) > (2578 + 1057))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((6817 - 3316) <= (3534 + 958)) and v86.Fireball:IsReady() and v38 and v116 and (v86.Combustion:CooldownRemains() < v86.Fireball:CastTime()) and (v122 < (1482 - (641 + 839))) and not v132()) then
			if (v21(v86.Fireball, not v14:IsSpellInRange(v86.Fireball)) or ((4355 - (910 + 3)) < (6495 - 3947))) then
				return "fireball combustion_phase 16";
			end
		end
		if (((4559 - (1466 + 218)) >= (673 + 791)) and v86.Scorch:IsReady() and v44 and v116 and (v86.Combustion:CooldownRemains() < v86.Scorch:CastTime())) then
			if (v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch)) or ((5945 - (556 + 592)) >= (1740 + 3153))) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v86.FireBlast:IsReady() and v37 and not v134() and not v110 and (not v132() or v13:IsCasting(v86.Scorch) or (v14:DebuffRemains(v86.ImprovedScorchDebuff) > ((812 - (329 + 479)) * v121))) and (v13:BuffDown(v86.FuryoftheSunKingBuff) or v13:IsCasting(v86.Pyroblast)) and v115 and v13:BuffDown(v86.HyperthermiaBuff) and v13:BuffDown(v86.HotStreakBuff) and ((v136() + (v25(v13:BuffUp(v86.HeatingUpBuff)) * v25(v13:GCDRemains() > (854 - (174 + 680))))) < (6 - 4))) or ((1141 - 590) > (1477 + 591))) then
			if (((2853 - (396 + 343)) > (84 + 860)) and v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true)) then
				return "fire_blast combustion_phase 20";
			end
		end
		if ((v31 and v86.Flamestrike:IsReady() and v39 and ((v13:BuffUp(v86.HotStreakBuff) and (v122 >= v96)) or (v13:BuffUp(v86.HyperthermiaBuff) and (v122 >= (v96 - v25(v86.Hyperthermia:IsAvailable())))))) or ((3739 - (29 + 1448)) >= (4485 - (135 + 1254)))) then
			if (v21(v88.FlamestrikeCursor, not v14:IsInRange(150 - 110)) or ((10528 - 8273) >= (2358 + 1179))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and (v13:BuffUp(v86.HyperthermiaBuff))) or ((5364 - (389 + 1138)) < (1880 - (102 + 472)))) then
			if (((2784 + 166) == (1636 + 1314)) and v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and v13:BuffUp(v86.HotStreakBuff) and v115) or ((4404 + 319) < (4843 - (320 + 1225)))) then
			if (((2021 - 885) >= (95 + 59)) and v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and v13:PrevGCDP(1465 - (157 + 1307), v86.Scorch) and v13:BuffUp(v86.HeatingUpBuff) and (v122 < v96) and v115) or ((2130 - (821 + 1038)) > (11846 - 7098))) then
			if (((519 + 4221) >= (5598 - 2446)) and v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if ((v86.ShiftingPower:IsReady() and v48 and ((v50 and v32) or not v50) and (v72 < v120) and v115 and (v86.FireBlast:Charges() == (0 + 0)) and ((v86.PhoenixFlames:Charges() < v86.PhoenixFlames:MaxCharges()) or v86.AlexstraszasFury:IsAvailable()) and (v100 <= v122)) or ((6389 - 3811) >= (4416 - (834 + 192)))) then
			if (((3 + 38) <= (427 + 1234)) and v21(v86.ShiftingPower, not v14:IsInRange(1 + 39))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if (((930 - 329) < (3864 - (300 + 4))) and v31 and v86.Flamestrike:IsReady() and v39 and not v13:IsCasting(v86.Flamestrike) and v13:BuffUp(v86.FuryoftheSunKingBuff) and (v13:BuffRemains(v86.FuryoftheSunKingBuff) > v86.Flamestrike:CastTime()) and (v122 >= v97)) then
			if (((63 + 172) < (1798 - 1111)) and v21(v88.FlamestrikeCursor, not v14:IsInRange(402 - (112 + 250)))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if (((1814 + 2735) > (2888 - 1735)) and v86.Pyroblast:IsReady() and v43 and not v13:IsCasting(v86.Pyroblast) and v13:BuffUp(v86.FuryoftheSunKingBuff) and (v13:BuffRemains(v86.FuryoftheSunKingBuff) > v86.Pyroblast:CastTime())) then
			if (v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast)) or ((2678 + 1996) < (2417 + 2255))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if (((2744 + 924) < (2262 + 2299)) and v86.Scorch:IsReady() and v44 and v132() and (v14:DebuffRemains(v86.ImprovedScorchDebuff) < ((3 + 1) * v121)) and (v124 < v96)) then
			if (v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch)) or ((1869 - (1001 + 413)) == (8039 - 4434))) then
				return "scorch combustion_phase 36";
			end
		end
		if ((v86.PhoenixFlames:IsCastable() and v42 and v13:HasTier(912 - (244 + 638), 695 - (627 + 66)) and (v86.PhoenixFlames:TravelTime() < v13:BuffRemains(v86.CombustionBuff)) and ((v25(v13:BuffUp(v86.HeatingUpBuff)) + v136()) < (5 - 3)) and ((v14:DebuffRemains(v86.CharringEmbersDebuff) < ((606 - (512 + 90)) * v121)) or (v13:BuffStack(v86.FlamesFuryBuff) > (1907 - (1665 + 241))) or v13:BuffUp(v86.FlamesFuryBuff))) or ((3380 - (373 + 344)) == (1494 + 1818))) then
			if (((1132 + 3145) <= (11803 - 7328)) and v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames))) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if ((v86.Fireball:IsReady() and v38 and (v13:BuffRemains(v86.CombustionBuff) > v86.Fireball:CastTime()) and v13:BuffUp(v86.FlameAccelerantBuff)) or ((1472 - 602) == (2288 - (35 + 1064)))) then
			if (((1130 + 423) <= (6702 - 3569)) and v21(v86.Fireball, not v14:IsSpellInRange(v86.Fireball))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v86.PhoenixFlames:IsCastable() and v42 and not v13:HasTier(1 + 29, 1238 - (298 + 938)) and not v86.AlexstraszasFury:IsAvailable() and (v86.PhoenixFlames:TravelTime() < v13:BuffRemains(v86.CombustionBuff)) and ((v25(v13:BuffUp(v86.HeatingUpBuff)) + v136()) < (1261 - (233 + 1026)))) or ((3903 - (636 + 1030)) >= (1796 + 1715))) then
			if (v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames)) or ((1294 + 30) > (898 + 2122))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v86.Scorch:IsReady() and v44 and (v13:BuffRemains(v86.CombustionBuff) > v86.Scorch:CastTime()) and (v86.Scorch:CastTime() >= v121)) or ((203 + 2789) == (2102 - (55 + 166)))) then
			if (((602 + 2504) > (154 + 1372)) and v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch))) then
				return "scorch combustion_phase 44";
			end
		end
		if (((11544 - 8521) < (4167 - (36 + 261))) and v86.Fireball:IsReady() and v38 and (v13:BuffRemains(v86.CombustionBuff) > v86.Fireball:CastTime())) then
			if (((249 - 106) > (1442 - (34 + 1334))) and v21(v86.Fireball, not v14:IsSpellInRange(v86.Fireball))) then
				return "fireball combustion_phase 46";
			end
		end
		if (((7 + 11) < (1641 + 471)) and v86.LivingBomb:IsReady() and v40 and (v13:BuffRemains(v86.CombustionBuff) < v121) and (v123 > (1284 - (1035 + 248)))) then
			if (((1118 - (20 + 1)) <= (849 + 779)) and v21(v86.LivingBomb, not v14:IsSpellInRange(v86.LivingBomb))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v144()
		v111 = v86.Combustion:CooldownRemains() * v107;
		v112 = ((v86.Fireball:CastTime() * v25(v122 < v96)) + (v86.Flamestrike:CastTime() * v25(v122 >= v96))) - v101;
		v106 = v111;
		if (((4949 - (134 + 185)) == (5763 - (549 + 584))) and v86.Firestarter:IsAvailable() and not v93) then
			v106 = v27(v130(), v106);
		end
		if (((4225 - (314 + 371)) > (9210 - 6527)) and v86.SunKingsBlessing:IsAvailable() and v129() and v13:BuffDown(v86.FuryoftheSunKingBuff)) then
			v106 = v27((v113 - v13:BuffStack(v86.SunKingsBlessingBuff)) * (971 - (478 + 490)) * v121, v106);
		end
		v106 = v27(v13:BuffRemains(v86.CombustionBuff), v106);
		if (((2540 + 2254) >= (4447 - (786 + 386))) and (((v111 + ((388 - 268) * ((1380 - (1055 + 324)) - (((1340.4 - (1093 + 247)) + ((0.2 + 0) * v25(v86.Firestarter:IsAvailable()))) * v25(v86.Kindling:IsAvailable()))))) <= v106) or (v106 > (v120 - (3 + 17))))) then
			v106 = v111;
		end
	end
	local function v145()
		if (((5891 - 4407) == (5036 - 3552)) and v86.FireBlast:IsReady() and v37 and not v134() and not v110 and v13:BuffDown(v86.HotStreakBuff) and ((v25(v13:BuffUp(v86.HeatingUpBuff)) + v136()) == (2 - 1)) and (v86.ShiftingPower:CooldownUp() or (v86.FireBlast:Charges() > (2 - 1)) or (v13:BuffRemains(v86.FeeltheBurnBuff) < ((1 + 1) * v121)))) then
			if (((5516 - 4084) < (12253 - 8698)) and v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v86.FireBlast:IsReady() and v37 and not v134() and not v110 and ((v25(v13:BuffUp(v86.HeatingUpBuff)) + v136()) == (1 + 0)) and v86.ShiftingPower:CooldownUp() and (not v13:HasTier(76 - 46, 690 - (364 + 324)) or (v14:DebuffRemains(v86.CharringEmbersDebuff) > ((5 - 3) * v121)))) or ((2555 - 1490) > (1186 + 2392))) then
			if (v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true) or ((20063 - 15268) < (2252 - 845))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v146()
		if (((5627 - 3774) < (6081 - (1249 + 19))) and v31 and v86.Flamestrike:IsReady() and v39 and (v122 >= v94) and v134()) then
			if (v21(v88.FlamestrikeCursor, not v14:IsInRange(37 + 3)) or ((10980 - 8159) < (3517 - (686 + 400)))) then
				return "flamestrike standard_rotation 2";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and (v134())) or ((2255 + 619) < (2410 - (73 + 156)))) then
			if (v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast), true) or ((13 + 2676) <= (1154 - (721 + 90)))) then
				return "pyroblast standard_rotation 4";
			end
		end
		if ((v31 and v86.Flamestrike:IsReady() and v39 and not v13:IsCasting(v86.Flamestrike) and (v122 >= v97) and v13:BuffUp(v86.FuryoftheSunKingBuff)) or ((22 + 1847) == (6522 - 4513))) then
			if (v21(v88.FlamestrikeCursor, not v14:IsInRange(510 - (224 + 246))) or ((5744 - 2198) < (4275 - 1953))) then
				return "flamestrike standard_rotation 12";
			end
		end
		if ((v86.Scorch:IsReady() and v44 and v132() and (v14:DebuffRemains(v86.ImprovedScorchDebuff) < (v86.Pyroblast:CastTime() + ((1 + 4) * v121))) and v13:BuffUp(v86.FuryoftheSunKingBuff) and not v13:IsCasting(v86.Scorch)) or ((50 + 2032) == (3506 + 1267))) then
			if (((6449 - 3205) > (3510 - 2455)) and v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch))) then
				return "scorch standard_rotation 13";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and not v13:IsCasting(v86.Pyroblast) and (v13:BuffUp(v86.FuryoftheSunKingBuff))) or ((3826 - (203 + 310)) <= (3771 - (1238 + 755)))) then
			if (v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast), true) or ((100 + 1321) >= (3638 - (709 + 825)))) then
				return "pyroblast standard_rotation 14";
			end
		end
		if (((3338 - 1526) <= (4732 - 1483)) and v86.FireBlast:IsReady() and v37 and not v134() and not v129() and not v110 and v13:BuffDown(v86.FuryoftheSunKingBuff) and ((((v13:IsCasting(v86.Fireball) and ((v86.Fireball:ExecuteRemains() < (864.5 - (196 + 668))) or not v86.Hyperthermia:IsAvailable())) or (v13:IsCasting(v86.Pyroblast) and ((v86.Pyroblast:ExecuteRemains() < (0.5 - 0)) or not v86.Hyperthermia:IsAvailable()))) and v13:BuffUp(v86.HeatingUpBuff)) or (v131() and (not v132() or (v14:DebuffStack(v86.ImprovedScorchDebuff) == v114) or (v86.FireBlast:FullRechargeTime() < (5 - 2))) and ((v13:BuffUp(v86.HeatingUpBuff) and not v13:IsCasting(v86.Scorch)) or (v13:BuffDown(v86.HotStreakBuff) and v13:BuffDown(v86.HeatingUpBuff) and v13:IsCasting(v86.Scorch) and (v136() == (833 - (171 + 662)))))))) then
			if (((1716 - (4 + 89)) <= (6859 - 4902)) and v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true)) then
				return "fire_blast standard_rotation 16";
			end
		end
		if (((1607 + 2805) == (19378 - 14966)) and v86.Pyroblast:IsReady() and v43 and (v13:IsCasting(v86.Scorch) or v13:PrevGCDP(1 + 0, v86.Scorch)) and v13:BuffUp(v86.HeatingUpBuff) and v131() and (v122 < v94)) then
			if (((3236 - (35 + 1451)) >= (2295 - (28 + 1425))) and v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast), true)) then
				return "pyroblast standard_rotation 18";
			end
		end
		if (((6365 - (941 + 1052)) > (1774 + 76)) and v86.Scorch:IsReady() and v44 and v132() and (v14:DebuffRemains(v86.ImprovedScorchDebuff) < ((1518 - (822 + 692)) * v121))) then
			if (((330 - 98) < (387 + 434)) and v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch))) then
				return "scorch standard_rotation 19";
			end
		end
		if (((815 - (45 + 252)) < (893 + 9)) and v86.PhoenixFlames:IsCastable() and v42 and v86.AlexstraszasFury:IsAvailable() and (not v86.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v86.FeeltheBurnBuff) < ((1 + 1) * v121)))) then
			if (((7286 - 4292) > (1291 - (114 + 319))) and v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 20";
			end
		end
		if ((v86.PhoenixFlames:IsCastable() and v42 and v13:HasTier(43 - 13, 2 - 0) and (v14:DebuffRemains(v86.CharringEmbersDebuff) < ((2 + 0) * v121)) and v13:BuffDown(v86.HotStreakBuff)) or ((5594 - 1839) <= (1916 - 1001))) then
			if (((5909 - (556 + 1407)) > (4949 - (741 + 465))) and v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames))) then
				return "phoenix_flames standard_rotation 21";
			end
		end
		if ((v86.Scorch:IsReady() and v44 and v132() and (v14:DebuffStack(v86.ImprovedScorchDebuff) < v114)) or ((1800 - (170 + 295)) >= (1742 + 1564))) then
			if (((4450 + 394) > (5546 - 3293)) and v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch))) then
				return "scorch standard_rotation 22";
			end
		end
		if (((375 + 77) == (290 + 162)) and v86.PhoenixFlames:IsCastable() and v42 and not v86.AlexstraszasFury:IsAvailable() and v13:BuffDown(v86.HotStreakBuff) and not v109 and v13:BuffUp(v86.FlamesFuryBuff)) then
			if (v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames)) or ((2581 + 1976) < (3317 - (957 + 273)))) then
				return "phoenix_flames standard_rotation 24";
			end
		end
		if (((1037 + 2837) == (1551 + 2323)) and v86.PhoenixFlames:IsCastable() and v42 and v86.AlexstraszasFury:IsAvailable() and v13:BuffDown(v86.HotStreakBuff) and (v136() == (0 - 0)) and ((not v109 and v13:BuffUp(v86.FlamesFuryBuff)) or (v86.PhoenixFlames:ChargesFractional() > (5.5 - 3)) or ((v86.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v86.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v86.FeeltheBurnBuff) < ((14 - 11) * v121)))))) then
			if (v21(v86.PhoenixFlames, not v14:IsSpellInRange(v86.PhoenixFlames)) or ((3718 - (389 + 1391)) > (3097 + 1838))) then
				return "phoenix_flames standard_rotation 26";
			end
		end
		v29 = v141();
		if (v29 or ((443 + 3812) < (7792 - 4369))) then
			return v29;
		end
		if (((2405 - (783 + 168)) <= (8360 - 5869)) and v31 and v86.DragonsBreath:IsReady() and v36 and (v124 > (1 + 0)) and v86.AlexstraszasFury:IsAvailable()) then
			if (v21(v86.DragonsBreath) or ((4468 - (309 + 2)) <= (8607 - 5804))) then
				return "dragons_breath standard_rotation 28";
			end
		end
		if (((6065 - (1090 + 122)) >= (967 + 2015)) and v86.Scorch:IsReady() and v44 and (v131())) then
			if (((13883 - 9749) > (2298 + 1059)) and v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch))) then
				return "scorch standard_rotation 30";
			end
		end
		if ((v31 and v86.ArcaneExplosion:IsReady() and v34 and (v125 >= v98) and (v13:ManaPercentageP() >= v99)) or ((4535 - (628 + 490)) < (455 + 2079))) then
			if (v21(v86.ArcaneExplosion, not v14:IsInRange(74 - 44)) or ((12439 - 9717) <= (938 - (431 + 343)))) then
				return "arcane_explosion standard_rotation 32";
			end
		end
		if ((v31 and v86.Flamestrike:IsReady() and v39 and (v122 >= v95)) or ((4863 - 2455) < (6100 - 3991))) then
			if (v21(v88.FlamestrikeCursor, not v14:IsInRange(32 + 8)) or ((5 + 28) == (3150 - (556 + 1139)))) then
				return "flamestrike standard_rotation 34";
			end
		end
		if ((v86.Pyroblast:IsReady() and v43 and v86.TemperedFlames:IsAvailable() and v13:BuffDown(v86.FlameAccelerantBuff)) or ((458 - (6 + 9)) >= (736 + 3279))) then
			if (((1733 + 1649) > (335 - (28 + 141))) and v21(v86.Pyroblast, not v14:IsSpellInRange(v86.Pyroblast), true)) then
				return "pyroblast standard_rotation 35";
			end
		end
		if ((v86.Fireball:IsReady() and v38 and not v134()) or ((109 + 171) == (3775 - 716))) then
			if (((1333 + 548) > (2610 - (486 + 831))) and v21(v86.Fireball, not v14:IsSpellInRange(v86.Fireball), true)) then
				return "fireball standard_rotation 36";
			end
		end
	end
	local function v147()
		local v162 = 0 - 0;
		while true do
			if (((8297 - 5940) == (446 + 1911)) and (v162 == (3 - 2))) then
				v108 = v106 > v86.ShiftingPower:CooldownRemains();
				v110 = v116 and (((v86.FireBlast:ChargesFractional() + ((v106 + (v133() * v25(v108))) / v86.FireBlast:Cooldown())) - (1264 - (668 + 595))) < ((v86.FireBlast:MaxCharges() + (v102 / v86.FireBlast:Cooldown())) - (((11 + 1) / v86.FireBlast:Cooldown()) % (1 + 0)))) and (v106 < v120);
				if (((335 - 212) == (413 - (23 + 267))) and not v92 and ((v106 <= (1944 - (1129 + 815))) or v115 or ((v106 < v112) and (v86.Combustion:CooldownRemains() < v112)))) then
					v29 = v143();
					if (v29 or ((1443 - (371 + 16)) >= (5142 - (1326 + 424)))) then
						return v29;
					end
				end
				v162 = 3 - 1;
			end
			if (((14 - 10) == v162) or ((1199 - (88 + 30)) < (1846 - (720 + 51)))) then
				if ((v86.FireBlast:IsReady() and v37 and not v134() and v13:IsCasting(v86.ShiftingPower) and (v86.FireBlast:FullRechargeTime() < v118)) or ((2333 - 1284) >= (6208 - (421 + 1355)))) then
					if (v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true) or ((7865 - 3097) <= (416 + 430))) then
						return "fire_blast main 16";
					end
				end
				if (((v106 > (1083 - (286 + 797))) and v116) or ((12275 - 8917) <= (2352 - 932))) then
					local v219 = 439 - (397 + 42);
					while true do
						if ((v219 == (0 + 0)) or ((4539 - (24 + 776)) <= (4629 - 1624))) then
							v29 = v146();
							if (v29 or ((2444 - (222 + 563)) >= (4701 - 2567))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v86.IceNova:IsCastable() and UseIceNova and not v131()) or ((2348 + 912) < (2545 - (23 + 167)))) then
					if (v21(v86.IceNova, not v14:IsSpellInRange(v86.IceNova)) or ((2467 - (690 + 1108)) == (1524 + 2699))) then
						return "ice_nova main 18";
					end
				end
				v162 = 5 + 0;
			end
			if ((v162 == (851 - (40 + 808))) or ((279 + 1413) < (2248 - 1660))) then
				if ((v122 >= v96) or ((4585 + 212) < (1932 + 1719))) then
					v109 = (v86.SunKingsBlessing:IsAvailable() or ((v106 < (v86.PhoenixFlames:FullRechargeTime() - (v133() * v25(v108)))) and (v106 < v120))) and not v86.AlexstraszasFury:IsAvailable();
				end
				if ((v86.FireBlast:IsReady() and v37 and not v134() and not v110 and (v106 > (0 + 0)) and (v122 >= v95) and not v129() and v13:BuffDown(v86.HotStreakBuff) and ((v13:BuffUp(v86.HeatingUpBuff) and (v86.Flamestrike:ExecuteRemains() < (571.5 - (47 + 524)))) or (v86.FireBlast:ChargesFractional() >= (2 + 0)))) or ((11417 - 7240) > (7252 - 2402))) then
					if (v21(v86.FireBlast, not v14:IsSpellInRange(v86.FireBlast), nil, true) or ((912 - 512) > (2837 - (1165 + 561)))) then
						return "fire_blast main 14";
					end
				end
				if (((91 + 2960) > (3112 - 2107)) and v116 and v129() and (v106 > (0 + 0))) then
					local v220 = 479 - (341 + 138);
					while true do
						if (((997 + 2696) <= (9043 - 4661)) and (v220 == (326 - (89 + 237)))) then
							v29 = v145();
							if (v29 or ((10558 - 7276) > (8631 - 4531))) then
								return v29;
							end
							break;
						end
					end
				end
				v162 = 885 - (581 + 300);
			end
			if ((v162 == (1225 - (855 + 365))) or ((8503 - 4923) < (929 + 1915))) then
				if (((1324 - (1030 + 205)) < (4216 + 274)) and v86.Scorch:IsReady() and v44) then
					if (v21(v86.Scorch, not v14:IsSpellInRange(v86.Scorch)) or ((4636 + 347) < (2094 - (156 + 130)))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((8699 - 4870) > (6351 - 2582)) and ((0 - 0) == v162)) then
				if (((392 + 1093) <= (1694 + 1210)) and not v92) then
					v144();
				end
				if (((4338 - (10 + 59)) == (1208 + 3061)) and v32 and v84 and v86.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v86.TemporalWarp:IsAvailable() and (v129() or (v120 < (196 - 156)))) then
					if (((1550 - (671 + 492)) <= (2215 + 567)) and v21(v86.TimeWarp, not v14:IsInRange(1255 - (369 + 846)))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v72 < v120) or ((503 + 1396) <= (783 + 134))) then
					if ((v79 and ((v32 and v80) or not v80)) or ((6257 - (1036 + 909)) <= (697 + 179))) then
						v29 = v137();
						if (((3746 - 1514) <= (2799 - (11 + 192))) and v29) then
							return v29;
						end
					end
				end
				v162 = 1 + 0;
			end
			if (((2270 - (135 + 40)) < (8930 - 5244)) and (v162 == (2 + 0))) then
				if ((not v110 and v86.SunKingsBlessing:IsAvailable()) or ((3513 - 1918) >= (6706 - 2232))) then
					v110 = v131() and (v86.FireBlast:FullRechargeTime() > ((179 - (50 + 126)) * v121));
				end
				if ((v86.ShiftingPower:IsReady() and ((v32 and v50) or not v50) and v48 and (v72 < v120) and v116 and ((v86.FireBlast:Charges() == (0 - 0)) or v110) and (not v132() or ((v14:DebuffRemains(v86.ImprovedScorchDebuff) > (v86.ShiftingPower:CastTime() + v86.Scorch:CastTime())) and v13:BuffDown(v86.FuryoftheSunKingBuff))) and v13:BuffDown(v86.HotStreakBuff) and v108) or ((1023 + 3596) < (4295 - (1233 + 180)))) then
					if (v21(v86.ShiftingPower, not v14:IsInRange(1009 - (522 + 447)), true) or ((1715 - (107 + 1314)) >= (2242 + 2589))) then
						return "shifting_power main 12";
					end
				end
				if (((6182 - 4153) <= (1310 + 1774)) and (v122 < v96)) then
					v109 = (v86.SunKingsBlessing:IsAvailable() or (((v106 + (13 - 6)) < ((v86.PhoenixFlames:FullRechargeTime() + v86.PhoenixFlames:Cooldown()) - (v133() * v25(v108)))) and (v106 < v120))) and not v86.AlexstraszasFury:IsAvailable();
				end
				v162 = 11 - 8;
			end
		end
	end
	local function v148()
		local v163 = 1910 - (716 + 1194);
		while true do
			if ((v163 == (1 + 1)) or ((219 + 1818) == (2923 - (74 + 429)))) then
				v46 = EpicSettings.Settings['useBlastWave'];
				v47 = EpicSettings.Settings['useCombustion'];
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['combustionWithCD'];
				v50 = EpicSettings.Settings['shiftingPowerWithCD'];
				v51 = EpicSettings.Settings['useAlterTime'];
				v163 = 5 - 2;
			end
			if (((2210 + 2248) > (8936 - 5032)) and (v163 == (0 + 0))) then
				v34 = EpicSettings.Settings['useArcaneExplosion'];
				v35 = EpicSettings.Settings['useArcaneIntellect'];
				v36 = EpicSettings.Settings['useDragonsBreath'];
				v37 = EpicSettings.Settings['useFireBlast'];
				v38 = EpicSettings.Settings['useFireball'];
				v39 = EpicSettings.Settings['useFlamestrike'];
				v163 = 2 - 1;
			end
			if (((1077 - 641) >= (556 - (279 + 154))) and (v163 == (782 - (454 + 324)))) then
				v58 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v59 = EpicSettings.Settings['blazingBarrierHP'] or (17 - (12 + 5));
				v60 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v61 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v62 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v63 = EpicSettings.Settings['mirrorImageHP'] or (1093 - (277 + 816));
				v163 = 21 - 16;
			end
			if (((1683 - (1058 + 125)) < (341 + 1475)) and (v163 == (976 - (815 + 160)))) then
				v40 = EpicSettings.Settings['useLivingBomb'];
				v41 = EpicSettings.Settings['useMeteor'];
				v42 = EpicSettings.Settings['usePhoenixFlames'];
				v43 = EpicSettings.Settings['usePyroblast'];
				v44 = EpicSettings.Settings['useScorch'];
				v45 = EpicSettings.Settings['useCounterspell'];
				v163 = 8 - 6;
			end
			if (((8483 - 4909) == (853 + 2721)) and (v163 == (14 - 9))) then
				v64 = EpicSettings.Settings['massBarrierHP'] or (1898 - (41 + 1857));
				v82 = EpicSettings.Settings['mirrorImageBeforePull'];
				v83 = EpicSettings.Settings['useSpellStealTarget'];
				v84 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v85 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((2114 - (1222 + 671)) < (1007 - 617)) and (v163 == (3 - 0))) then
				v52 = EpicSettings.Settings['useBlazingBarrier'];
				v53 = EpicSettings.Settings['useGreaterInvisibility'];
				v54 = EpicSettings.Settings['useIceBlock'];
				v55 = EpicSettings.Settings['useIceCold'];
				v57 = EpicSettings.Settings['useMassBarrier'];
				v56 = EpicSettings.Settings['useMirrorImage'];
				v163 = 1186 - (229 + 953);
			end
		end
	end
	local function v149()
		v72 = EpicSettings.Settings['fightRemainsCheck'] or (1774 - (1111 + 663));
		v69 = EpicSettings.Settings['InterruptWithStun'];
		v70 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v71 = EpicSettings.Settings['InterruptThreshold'];
		v66 = EpicSettings.Settings['DispelDebuffs'];
		v65 = EpicSettings.Settings['DispelBuffs'];
		v79 = EpicSettings.Settings['useTrinkets'];
		v78 = EpicSettings.Settings['useRacials'];
		v80 = EpicSettings.Settings['trinketsWithCD'];
		v81 = EpicSettings.Settings['racialsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v73 = EpicSettings.Settings['useHealingPotion'];
		v76 = EpicSettings.Settings['healthstoneHP'] or (1579 - (874 + 705));
		v75 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v77 = EpicSettings.Settings['HealingPotionName'] or "";
		v67 = EpicSettings.Settings['handleAfflicted'];
		v68 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v150()
		v148();
		v149();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		Kick = EpicSettings.Toggles['kick'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v13:IsDeadOrGhost() or ((1510 + 703) <= (2953 - 1532))) then
			return;
		end
		v127 = v14:GetEnemiesInSplashRange(1 + 4);
		v126 = v13:GetEnemiesInRange(719 - (642 + 37));
		if (((698 + 2360) < (778 + 4082)) and v31) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (454 - (233 + 221))) or ((2996 - 1700) >= (3914 + 532))) then
					v122 = v27(v14:GetEnemiesInSplashRangeCount(1546 - (718 + 823)), #v126);
					v123 = v27(v14:GetEnemiesInSplashRangeCount(4 + 1), #v126);
					v188 = 806 - (266 + 539);
				end
				if ((v188 == (2 - 1)) or ((2618 - (636 + 589)) > (10655 - 6166))) then
					v124 = v27(v14:GetEnemiesInSplashRangeCount(10 - 5), #v126);
					v125 = #v126;
					break;
				end
			end
		else
			v122 = 1 + 0;
			v123 = 1 + 0;
			v124 = 1016 - (657 + 358);
			v125 = 2 - 1;
		end
		if (v90.TargetIsValid() or v13:AffectingCombat() or ((10078 - 5654) < (1214 - (1151 + 36)))) then
			if (v13:AffectingCombat() or v66 or ((1929 + 68) > (1003 + 2812))) then
				local v217 = 0 - 0;
				local v218;
				while true do
					if (((5297 - (1552 + 280)) > (2747 - (64 + 770))) and (v217 == (0 + 0))) then
						v218 = v66 and v86.RemoveCurse:IsReady() and v33;
						v29 = v90.FocusUnit(v218, v88, 45 - 25, nil, 4 + 16);
						v217 = 1244 - (157 + 1086);
					end
					if (((1467 - 734) < (7966 - 6147)) and (v217 == (1 - 0))) then
						if (v29 or ((5998 - 1603) == (5574 - (599 + 220)))) then
							return v29;
						end
						break;
					end
				end
			end
			v119 = v9.BossFightRemains(nil, true);
			v120 = v119;
			if ((v120 == (22126 - 11015)) or ((5724 - (1813 + 118)) < (1732 + 637))) then
				v120 = v9.FightRemains(v126, false);
			end
			v128 = v135(v126);
			v92 = not v32;
			if (v92 or ((5301 - (841 + 376)) == (370 - 105))) then
				v106 = 23230 + 76769;
			end
			v121 = v13:GCD();
			v115 = v13:BuffUp(v86.CombustionBuff);
			v116 = not v115;
		end
		if (((11895 - 7537) == (5217 - (464 + 395))) and not v13:AffectingCombat() and v30) then
			v29 = v140();
			if (v29 or ((8053 - 4915) < (477 + 516))) then
				return v29;
			end
		end
		if (((4167 - (467 + 370)) > (4799 - 2476)) and v13:AffectingCombat() and v90.TargetIsValid()) then
			if (Focus or ((2662 + 964) == (13674 - 9685))) then
				if (v66 or ((143 + 773) == (6214 - 3543))) then
					v29 = v138();
					if (((792 - (150 + 370)) == (1554 - (74 + 1208))) and v29) then
						return v29;
					end
				end
			end
			v29 = v139();
			if (((10450 - 6201) <= (22949 - 18110)) and v29) then
				return v29;
			end
			if (((1976 + 801) < (3590 - (14 + 376))) and v67) then
				if (((164 - 69) < (1267 + 690)) and v85) then
					v29 = v90.HandleAfflicted(v86.RemoveCurse, v88.RemoveCurseMouseover, 27 + 3);
					if (((788 + 38) < (5030 - 3313)) and v29) then
						return v29;
					end
				end
			end
			if (((1073 + 353) >= (1183 - (23 + 55))) and v68) then
				v29 = v90.HandleIncorporeal(v86.Polymorph, v88.PolymorphMouseOver, 71 - 41, true);
				if (((1838 + 916) <= (3035 + 344)) and v29) then
					return v29;
				end
			end
			if ((v86.Spellsteal:IsAvailable() and v83 and v86.Spellsteal:IsReady() and v33 and v65 and not v13:IsCasting() and not v13:IsChanneling() and v90.UnitHasMagicBuff(v14)) or ((6088 - 2161) == (445 + 968))) then
				if (v21(v86.Spellsteal, not v14:IsSpellInRange(v86.Spellsteal)) or ((2055 - (652 + 249)) <= (2108 - 1320))) then
					return "spellsteal damage";
				end
			end
			if (((v13:IsCasting() or v13:IsChanneling()) and v13:BuffUp(v86.HotStreakBuff)) or ((3511 - (708 + 1160)) > (9171 - 5792))) then
				if (v21(v88.StopCasting, not v14:IsSpellInRange(v86.Pyroblast)) or ((5110 - 2307) > (4576 - (10 + 17)))) then
					return "Stop Casting";
				end
			end
			v29 = v147();
			if (v29 or ((50 + 170) >= (4754 - (1400 + 332)))) then
				return v29;
			end
		end
	end
	local function v151()
		local v182 = 0 - 0;
		while true do
			if (((4730 - (242 + 1666)) == (1208 + 1614)) and (v182 == (0 + 0))) then
				v91();
				v19.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(54 + 9, v150, v151);
end;
return v0["Epix_Mage_Fire.lua"]();

