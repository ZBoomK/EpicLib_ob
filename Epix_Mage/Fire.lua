local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((2577 - (409 + 103)) >= (3432 - (46 + 190)))) then
			return v6(...);
		end
		if ((v5 == (95 - (51 + 44))) or ((1235 + 3141) <= (2798 - (1114 + 203)))) then
			v6 = v0[v4];
			if (not v6 or ((4118 - (228 + 498)) >= (1028 + 3713))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		if (((3988 - (174 + 489)) >= (5611 - 3457)) and v90.RemoveCurse:IsAvailable()) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (1909 - (830 + 1075))) or (1523 - (303 + 221));
	local v99 = 2268 - (231 + 1038);
	local v100 = v98;
	local v101 = ((3 + 0) * v28(v90.FueltheFire:IsAvailable())) + ((2161 - (171 + 991)) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 4116 - 3117;
	local v103 = 107 - 67;
	local v104 = 2492 - 1493;
	local v105 = 0.3 + 0;
	local v106 = 0 - 0;
	local v107 = 17 - 11;
	local v108 = false;
	local v109 = (v108 and (32 - 12)) or (0 - 0);
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (1248.4 - (111 + 1137))) or (159 - (91 + 67));
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 0 - 0;
	local v116 = 0 + 0;
	local v117 = 531 - (423 + 100);
	local v118 = 1 + 2;
	local v119;
	local v120;
	local v121;
	local v122 = 7 - 4;
	local v123 = 5792 + 5319;
	local v124 = 11882 - (326 + 445);
	local v125;
	local v126, v127, v128;
	local v129;
	local v130;
	local v131;
	local v132;
	v10:RegisterForEvent(function()
		v108 = false;
		v109 = (v108 and (87 - 67)) or (0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v90.Pyroblast:RegisterInFlight();
		v90.Fireball:RegisterInFlight();
		v90.Meteor:RegisterInFlightEffect(819640 - 468500);
		v90.Meteor:RegisterInFlight();
		v90.PhoenixFlames:RegisterInFlightEffect(258253 - (530 + 181));
		v90.PhoenixFlames:RegisterInFlight();
		v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
		v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(352021 - (614 + 267));
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(257574 - (19 + 13));
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (0 - 0)) or ((3699 - 2404) >= (840 + 2393))) then
				v123 = 19540 - 8429;
				v124 = 23042 - 11931;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v97 = v90.SunKingsBlessing:IsAvailable();
		v98 = ((v90.FlamePatch:IsAvailable()) and (1815 - (1293 + 519))) or (2037 - 1038);
		v100 = v98;
		v111 = ((v90.Kindling:IsAvailable()) and (0.4 - 0)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (388 - 298));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (212 - 122)) and v15:TimeToX(48 + 42)) or (0 + 0))) or (0 - 0);
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (7 + 23));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (10 + 20));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v158 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (0 + 0);
		v158 = v158 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1097 - (709 + 387), v90.PhoenixFlames));
		return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast) or (v158 > (1858 - (673 + 1185)))))));
	end
	local function v139(v159)
		local v160 = 0 - 0;
		local v161;
		while true do
			if (((14054 - 9677) > (2700 - 1058)) and (v160 == (1 + 0))) then
				return v161;
			end
			if (((3530 + 1193) > (1830 - 474)) and (v160 == (0 + 0))) then
				v161 = 0 - 0;
				for v223, v224 in pairs(v159) do
					if (v224:DebuffUp(v90.IgniteDebuff) or ((8118 - 3982) <= (5313 - (446 + 1434)))) then
						v161 = v161 + (1284 - (1040 + 243));
					end
				end
				v160 = 2 - 1;
			end
		end
	end
	local function v140()
		local v162 = 1847 - (559 + 1288);
		if (((6176 - (609 + 1322)) <= (5085 - (13 + 441))) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
			v162 = v162 + (3 - 2);
		end
		return v162;
	end
	local function v141()
		local v163 = 0 - 0;
		while true do
			if (((21296 - 17020) >= (146 + 3768)) and (v163 == (3 - 2))) then
				v32 = v94.HandleBottomTrinket(v93, v35, 15 + 25, nil);
				if (((87 + 111) <= (12953 - 8588)) and v32) then
					return v32;
				end
				break;
			end
			if (((2617 + 2165) > (8599 - 3923)) and (v163 == (0 + 0))) then
				v32 = v94.HandleTopTrinket(v93, v35, 23 + 17, nil);
				if (((3495 + 1369) > (1845 + 352)) and v32) then
					return v32;
				end
				v163 = 1 + 0;
			end
		end
	end
	local v142 = 433 - (153 + 280);
	local function v143()
		if ((v90.RemoveCurse:IsReady() and v94.DispellableFriendlyUnit(57 - 37)) or ((3322 + 378) == (990 + 1517))) then
			local v203 = 0 + 0;
			while true do
				if (((4061 + 413) >= (199 + 75)) and ((0 - 0) == v203)) then
					if ((v142 == (0 + 0)) or ((2561 - (89 + 578)) <= (1005 + 401))) then
						v142 = GetTime();
					end
					if (((3267 - 1695) >= (2580 - (572 + 477))) and v94.Wait(68 + 432, v142)) then
						if (v24(v92.RemoveCurseFocus) or ((2813 + 1874) < (543 + 3999))) then
							return "remove_curse dispel";
						end
						v142 = 86 - (84 + 2);
					end
					break;
				end
			end
		end
	end
	local function v144()
		if (((5423 - 2132) > (1201 + 466)) and v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) then
			if (v24(v90.BlazingBarrier) or ((1715 - (497 + 345)) == (53 + 1981))) then
				return "blazing_barrier defensive 1";
			end
		end
		if ((v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 1 + 1)) or ((4149 - (605 + 728)) < (8 + 3))) then
			if (((8223 - 4524) < (216 + 4490)) and v24(v90.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if (((9782 - 7136) >= (790 + 86)) and v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
			if (((1701 - 1087) <= (2405 + 779)) and v24(v90.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if (((3615 - (457 + 32)) == (1327 + 1799)) and v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) then
			if (v24(v90.IceColdAbility) or ((3589 - (832 + 570)) >= (4668 + 286))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) or ((1012 + 2865) == (12651 - 9076))) then
			if (((341 + 366) > (1428 - (588 + 208))) and v24(v90.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if ((v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) or ((1471 - 925) >= (4484 - (884 + 916)))) then
			if (((3067 - 1602) <= (2494 + 1807)) and v24(v90.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((2357 - (232 + 421)) > (3314 - (1569 + 320))) and v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
			if (v24(v90.AlterTime) or ((169 + 518) == (805 + 3429))) then
				return "alter_time defensive 6";
			end
		end
		if ((v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) or ((11221 - 7891) < (2034 - (316 + 289)))) then
			if (((3002 - 1855) >= (16 + 319)) and v24(v92.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((4888 - (666 + 787)) > (2522 - (360 + 65))) and v77 and (v14:HealthPercentage() <= v79)) then
			if ((v81 == "Refreshing Healing Potion") or ((3524 + 246) >= (4295 - (79 + 175)))) then
				if (v91.RefreshingHealingPotion:IsReady() or ((5977 - 2186) <= (1258 + 353))) then
					if (v24(v92.RefreshingHealingPotion) or ((14032 - 9454) <= (3866 - 1858))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((2024 - (503 + 396)) <= (2257 - (92 + 89))) and (v81 == "Dreamwalker's Healing Potion")) then
				if (v91.DreamwalkersHealingPotion:IsReady() or ((1440 - 697) >= (2256 + 2143))) then
					if (((684 + 471) < (6551 - 4878)) and v24(v92.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v145()
		if ((v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) or ((318 + 2006) <= (1317 - 739))) then
			if (((3287 + 480) == (1800 + 1967)) and v24(v90.ArcaneIntellect)) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((12453 - 8364) == (511 + 3578)) and v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) then
			if (((6798 - 2340) >= (2918 - (485 + 759))) and v24(v90.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if (((2248 - 1276) <= (2607 - (442 + 747))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((6073 - (832 + 303)) < (5708 - (88 + 858)))) then
				return "pyroblast precombat 4";
			end
		end
		if ((v90.Fireball:IsReady() and v41) or ((764 + 1740) > (3529 + 735))) then
			if (((89 + 2064) == (2942 - (766 + 23))) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v146()
		local v164 = 0 - 0;
		while true do
			if (((0 - 0) == v164) or ((1335 - 828) >= (8793 - 6202))) then
				if (((5554 - (1036 + 37)) == (3177 + 1304)) and v90.LivingBomb:IsReady() and v43 and (v127 > (1 - 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (0 + 0)))) then
					if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb)) or ((3808 - (641 + 839)) < (1606 - (910 + 3)))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((11033 - 6705) == (6012 - (1466 + 218))) and v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (0 + 0)) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((1193 - (556 + 592)) < v110) or (v124 < v110))))) then
					if (((565 + 1023) >= (2140 - (329 + 479))) and v24(v92.MeteorCursor, not v15:IsInRange(894 - (174 + 680)))) then
						return "meteor active_talents 4";
					end
				end
				v164 = 3 - 2;
			end
			if ((v164 == (1 - 0)) or ((2981 + 1193) > (4987 - (396 + 343)))) then
				if ((v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (2 + 13))) and not v136() and (v134() == (1477 - (29 + 1448))) and not v90.TemperedFlames:IsAvailable()) or ((5975 - (135 + 1254)) <= (308 - 226))) then
					if (((18036 - 14173) == (2575 + 1288)) and v24(v90.DragonsBreath, not v15:IsInRange(1537 - (389 + 1138)))) then
						return "dragons_breath active_talents 6";
					end
				end
				if ((v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (589 - (102 + 472)))) and not v136() and v90.TemperedFlames:IsAvailable()) or ((267 + 15) <= (24 + 18))) then
					if (((4298 + 311) >= (2311 - (320 + 1225))) and v24(v90.DragonsBreath, not v15:IsInRange(17 - 7))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
		end
	end
	local function v147()
		local v165 = 0 + 0;
		local v166;
		while true do
			if (((1466 - (157 + 1307)) == v165) or ((3011 - (821 + 1038)) == (6207 - 3719))) then
				if (((375 + 3047) > (5950 - 2600)) and (v75 < v124)) then
					if (((327 + 550) > (931 - 555)) and v83 and ((v35 and v84) or not v84)) then
						v32 = v141();
						if (v32 or ((4144 - (834 + 192)) <= (118 + 1733))) then
							return v32;
						end
					end
				end
				break;
			end
			if (((1 + 0) == v165) or ((4 + 161) >= (5409 - 1917))) then
				if (((4253 - (300 + 4)) < (1297 + 3559)) and v82 and ((v85 and v35) or not v85) and (v75 < v124)) then
					if (v90.BloodFury:IsCastable() or ((11193 - 6917) < (3378 - (112 + 250)))) then
						if (((1870 + 2820) > (10334 - 6209)) and v24(v90.BloodFury)) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if ((v90.Berserking:IsCastable() and v119) or ((29 + 21) >= (464 + 432))) then
						if (v24(v90.Berserking) or ((1282 + 432) >= (1467 + 1491))) then
							return "berserking combustion_cooldowns 6";
						end
					end
					if (v90.Fireblood:IsCastable() or ((1108 + 383) < (2058 - (1001 + 413)))) then
						if (((1569 - 865) < (1869 - (244 + 638))) and v24(v90.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((4411 - (627 + 66)) > (5679 - 3773)) and v90.AncestralCall:IsCastable()) then
						if (v24(v90.AncestralCall) or ((1560 - (512 + 90)) > (5541 - (1665 + 241)))) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
				end
				if (((4218 - (373 + 344)) <= (2026 + 2466)) and v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
					if (v24(v90.TimeWarp, nil, nil, true) or ((911 + 2531) < (6720 - 4172))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v165 = 2 - 0;
			end
			if (((3974 - (35 + 1064)) >= (1066 + 398)) and (v165 == (0 - 0))) then
				v166 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (v166 or ((20 + 4777) >= (6129 - (298 + 938)))) then
					return v166;
				end
				v165 = 1260 - (233 + 1026);
			end
		end
	end
	local function v148()
		local v167 = 1666 - (636 + 1030);
		while true do
			if ((v167 == (3 + 2)) or ((539 + 12) > (615 + 1453))) then
				if (((143 + 1971) > (1165 - (55 + 166))) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((1 + 3) * v125)) and (v128 < v100)) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch)) or ((228 + 2034) >= (11823 - 8727))) then
						return "scorch combustion_phase 36";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(327 - (36 + 261), 3 - 1) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (1370 - (34 + 1334))) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((2 + 2) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1 + 0)) or v14:BuffUp(v90.FlamesFuryBuff))) or ((3538 - (1035 + 248)) >= (3558 - (20 + 1)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((2000 + 1837) < (1625 - (134 + 185)))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((4083 - (549 + 584)) == (3635 - (314 + 371))) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball)) or ((16213 - 11490) < (4266 - (478 + 490)))) then
						return "fireball combustion_phase 40";
					end
				end
				if (((602 + 534) >= (1326 - (786 + 386))) and v90.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(97 - 67, 1381 - (1055 + 324)) and not v90.AlexstraszasFury:IsAvailable() and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (1342 - (1093 + 247)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((241 + 30) > (500 + 4248))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v167 = 23 - 17;
			end
			if (((16086 - 11346) >= (8968 - 5816)) and (v167 == (0 - 0))) then
				if ((v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) or ((918 + 1660) >= (13059 - 9669))) then
					if (((141 - 100) <= (1253 + 408)) and v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((1536 - 935) < (4248 - (364 + 324))) and v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
					if (((643 - 408) < (1648 - 961)) and v24(v90.BagofTricks)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if (((1508 + 3041) > (4824 - 3671)) and v90.LivingBomb:IsReady() and v34 and v43 and (v127 > (1 - 0)) and v120) then
					if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb)) or ((14195 - 9521) < (5940 - (1249 + 19)))) then
						return "living_bomb combustion_phase 6";
					end
				end
				if (((3311 + 357) < (17753 - 13192)) and ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (1106 - (686 + 400))))) then
					v32 = v147();
					if (v32 or ((357 + 98) == (3834 - (73 + 156)))) then
						return v32;
					end
				end
				v167 = 1 + 0;
			end
			if ((v167 == (814 - (721 + 90))) or ((30 + 2633) == (10753 - 7441))) then
				if (((4747 - (224 + 246)) <= (7249 - 2774)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((6 - 2) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 + 0)))) < (1 + 1))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true) or ((639 + 231) == (2363 - 1174))) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((5167 - 3614) <= (3646 - (203 + 310))) and v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v126 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v126 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(2033 - (1238 + 755))) or ((157 + 2080) >= (5045 - (709 + 825)))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) or ((2439 - 1115) > (4399 - 1379))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast)) or ((3856 - (196 + 668)) == (7426 - 5545))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if (((6433 - 3327) > (2359 - (171 + 662))) and v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) then
					if (((3116 - (4 + 89)) < (13564 - 9694)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast))) then
						return "pyroblast combustion_phase 26";
					end
				end
				v167 = 2 + 2;
			end
			if (((627 - 484) > (30 + 44)) and (v167 == (1488 - (35 + 1451)))) then
				if (((1471 - (28 + 1425)) < (4105 - (941 + 1052))) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v126 >= v101)) then
					if (((1052 + 45) <= (3142 - (822 + 692))) and v24(v92.FlamestrikeCursor, not v15:IsInRange(57 - 17))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if (((2181 + 2449) == (4927 - (45 + 252))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) then
					if (((3503 + 37) > (924 + 1759)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((11667 - 6873) >= (3708 - (114 + 319))) and v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v126 < (2 - 0)) and not v136()) then
					if (((1900 - 416) == (947 + 537)) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball))) then
						return "fireball combustion_phase 16";
					end
				end
				if (((2132 - 700) < (7448 - 3893)) and v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch)) or ((3028 - (556 + 1407)) > (4784 - (741 + 465)))) then
						return "scorch combustion_phase 18";
					end
				end
				v167 = 468 - (170 + 295);
			end
			if ((v167 == (3 + 1)) or ((4405 + 390) < (3464 - 2057))) then
				if (((1537 + 316) < (3087 + 1726)) and v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(1 + 0, v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v126 < v100) and v119) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast)) or ((4051 - (957 + 273)) < (651 + 1780))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if ((v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (0 + 0)) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v126)) or ((10951 - 8077) < (5747 - 3566))) then
					if (v24(v90.ShiftingPower, not v15:IsInRange(122 - 82)) or ((13315 - 10626) <= (2123 - (389 + 1391)))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v126 >= v101)) or ((1173 + 696) == (210 + 1799))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(91 - 51)) or ((4497 - (783 + 168)) < (7792 - 5470))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((2048 + 34) == (5084 - (309 + 2)))) then
					if (((9961 - 6717) > (2267 - (1090 + 122))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v167 = 2 + 3;
			end
			if (((3 - 2) == v167) or ((2268 + 1045) <= (2896 - (628 + 490)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(6 + 24, 4 - 2) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((18 - 14) * v125)) and v14:BuffDown(v90.HotStreakBuff)) or ((2195 - (431 + 343)) >= (4248 - 2144))) then
					if (((5241 - 3429) <= (2567 + 682)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v32 = v146();
				if (((208 + 1415) <= (3652 - (556 + 1139))) and v32) then
					return v32;
				end
				if (((4427 - (6 + 9)) == (808 + 3604)) and v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (0 + 0)) and v120 and (v110 <= (169 - (28 + 141))) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) then
					if (((678 + 1072) >= (1038 - 196)) and v24(v90.Combustion, not v15:IsInRange(29 + 11), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				v167 = 1319 - (486 + 831);
			end
			if (((11376 - 7004) > (6513 - 4663)) and (v167 == (2 + 4))) then
				if (((733 - 501) < (2084 - (668 + 595))) and v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) then
					if (((467 + 51) < (182 + 720)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((8164 - 5170) > (1148 - (23 + 267))) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball)) or ((5699 - (1129 + 815)) <= (1302 - (371 + 16)))) then
						return "fireball combustion_phase 46";
					end
				end
				if (((5696 - (1326 + 424)) > (7088 - 3345)) and v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v127 > (3 - 2))) then
					if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb)) or ((1453 - (88 + 30)) >= (4077 - (720 + 51)))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
		end
	end
	local function v149()
		local v168 = 0 - 0;
		while true do
			if (((6620 - (421 + 1355)) > (3716 - 1463)) and (v168 == (2 + 1))) then
				if (((1535 - (286 + 797)) == (1652 - 1200)) and (((v115 + ((198 - 78) * ((440 - (397 + 42)) - ((0.4 + 0 + ((800.2 - (24 + 776)) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (30 - 10))))) then
					v110 = v115;
				end
				break;
			end
			if ((v168 == (786 - (222 + 563))) or ((10040 - 5483) < (1503 + 584))) then
				v110 = v115;
				if (((4064 - (23 + 167)) == (5672 - (690 + 1108))) and v90.Firestarter:IsAvailable() and not v97) then
					v110 = v30(v134(), v110);
				end
				v168 = 1 + 1;
			end
			if ((v168 == (0 + 0)) or ((2786 - (40 + 808)) > (813 + 4122))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v126 < v100)) + (v90.Flamestrike:CastTime() * v28(v126 >= v100))) - v105;
				v168 = 3 - 2;
			end
			if ((v168 == (2 + 0)) or ((2251 + 2004) < (1878 + 1545))) then
				if (((2025 - (47 + 524)) <= (1617 + 874)) and v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (8 - 5) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v168 = 4 - 1;
			end
		end
	end
	local function v150()
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (2 - 1)) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (1727 - (1165 + 561))) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) or ((12874 - 8717) <= (1070 + 1733))) then
			if (((5332 - (341 + 138)) >= (805 + 2177)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if (((8530 - 4396) > (3683 - (89 + 237))) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (3 - 2)) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(63 - 33, 883 - (581 + 300)) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((1222 - (855 + 365)) * v125)))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true) or ((8116 - 4699) < (828 + 1706))) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v151()
		local v169 = 1235 - (1030 + 205);
		while true do
			if ((v169 == (4 + 0)) or ((2533 + 189) <= (450 - (156 + 130)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (0 - 0)) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (2.5 - 0)) or ((v90.PhoenixFlames:ChargesFractional() > (1.5 - 0)) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 2) * v125)))))) or ((1405 + 1003) < (2178 - (10 + 59)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((10 + 23) == (7165 - 5710))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (v32 or ((1606 - (671 + 492)) >= (3197 + 818))) then
					return v32;
				end
				v169 = 1220 - (369 + 846);
			end
			if (((896 + 2486) > (142 + 24)) and (v169 == (1948 - (1036 + 909)))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(24 + 6, 2 - 0) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((205 - (11 + 192)) * v125)) and v14:BuffDown(v90.HotStreakBuff)) or ((142 + 138) == (3234 - (135 + 40)))) then
					if (((4557 - 2676) > (780 + 513)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if (((5192 - 2835) == (3532 - 1175)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) then
					if (((299 - (50 + 126)) == (342 - 219)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or ((234 + 822) >= (4805 - (1233 + 180)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((2050 - (522 + 447)) < (2496 - (107 + 1314)))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v169 = 2 + 2;
			end
			if ((v169 == (0 - 0)) or ((446 + 603) >= (8800 - 4368))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v98) and v138()) or ((18865 - 14097) <= (2756 - (716 + 1194)))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1 + 39)) or ((360 + 2998) <= (1923 - (74 + 429)))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and (v138())) or ((7212 - 3473) <= (1490 + 1515))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((3797 - 2138) >= (1510 + 624))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v126 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) or ((10050 - 6790) < (5822 - 3467))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(473 - (279 + 154))) or ((1447 - (454 + 324)) == (3323 + 900))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v169 = 18 - (12 + 5);
			end
			if ((v169 == (2 + 0)) or ((4310 - 2618) < (218 + 370))) then
				if ((v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(1094 - (277 + 816), v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v126 < v98)) or ((20497 - 15700) < (4834 - (1058 + 125)))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((784 + 3393) > (5825 - (815 + 160)))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((17 - 13) * v125))) or ((949 - 549) > (266 + 845))) then
					if (((8918 - 5867) > (2903 - (41 + 1857))) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch))) then
						return "scorch standard_rotation 19";
					end
				end
				if (((5586 - (1222 + 671)) <= (11325 - 6943)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((2 - 0) * v125)))) then
					if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames)) or ((4464 - (229 + 953)) > (5874 - (1111 + 663)))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v169 = 1582 - (874 + 705);
			end
			if ((v169 == (1 + 5)) or ((2443 + 1137) < (5911 - 3067))) then
				if (((3 + 86) < (5169 - (642 + 37))) and v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v99)) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(10 + 30)) or ((798 + 4185) < (4539 - 2731))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if (((4283 - (233 + 221)) > (8715 - 4946)) and v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) then
					if (((1308 + 177) <= (4445 - (718 + 823))) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true)) then
						return "pyroblast standard_rotation 35";
					end
				end
				if (((2687 + 1582) == (5074 - (266 + 539))) and v90.Fireball:IsReady() and v41 and not v138()) then
					if (((1095 - 708) <= (4007 - (636 + 589))) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true)) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v169 == (11 - 6)) or ((3916 - 2017) <= (727 + 190))) then
				if ((v34 and v90.DragonsBreath:IsReady() and v39 and (v128 > (1 + 0)) and v90.AlexstraszasFury:IsAvailable()) or ((5327 - (657 + 358)) <= (2319 - 1443))) then
					if (((5084 - 2852) <= (3783 - (1151 + 36))) and v24(v90.DragonsBreath, not v15:IsInRange(10 + 0))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if (((551 + 1544) < (11007 - 7321)) and v90.Scorch:IsReady() and v47 and (v135())) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch)) or ((3427 - (1552 + 280)) >= (5308 - (64 + 770)))) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v34 and v90.ArcaneExplosion:IsReady() and v37 and (v129 >= v102) and (v14:ManaPercentageP() >= v103)) or ((3137 + 1482) < (6541 - 3659))) then
					if (v24(v90.ArcaneExplosion, not v15:IsInRange(2 + 6)) or ((1537 - (157 + 1086)) >= (9669 - 4838))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v169 = 26 - 20;
			end
			if (((3111 - 1082) <= (4209 - 1125)) and (v169 == (820 - (599 + 220)))) then
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((9 - 4) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) or ((3968 - (1813 + 118)) == (1769 + 651))) then
					if (((5675 - (841 + 376)) > (5470 - 1566)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch))) then
						return "scorch standard_rotation 13";
					end
				end
				if (((102 + 334) >= (335 - 212)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) then
					if (((1359 - (464 + 395)) < (4660 - 2844)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true)) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((1717 + 1857) == (4411 - (467 + 370))) and v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and ((((v14:IsCasting(v90.Fireball) and ((v90.Fireball:ExecuteRemains() < (0.5 - 0)) or not v90.Hyperthermia:IsAvailable())) or (v14:IsCasting(v90.Pyroblast) and ((v90.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v90.Hyperthermia:IsAvailable()))) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (10 - 7))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (0 + 0))))))) then
					if (((514 - 293) < (910 - (150 + 370))) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				v169 = 1284 - (74 + 1208);
			end
		end
	end
	local function v152()
		if (not v96 or ((5443 - 3230) <= (6739 - 5318))) then
			v149();
		end
		if (((2176 + 882) < (5250 - (14 + 376))) and v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (69 - 29)))) then
			if (v24(v90.TimeWarp, not v15:IsInRange(26 + 14)) or ((1139 + 157) >= (4241 + 205))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v75 < v124) or ((4081 - 2688) > (3378 + 1111))) then
			if ((v83 and ((v35 and v84) or not v84)) or ((4502 - (23 + 55)) < (63 - 36))) then
				v32 = v141();
				if (v32 or ((1333 + 664) > (3426 + 389))) then
					return v32;
				end
			end
		end
		v112 = v110 > v90.ShiftingPower:CooldownRemains();
		v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (1 - 0)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((4 + 8) / v90.FireBlast:Cooldown()) % (902 - (652 + 249))))) and (v110 < v124);
		if (((9272 - 5807) > (3781 - (708 + 1160))) and not v96 and ((v110 <= (0 - 0)) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) then
			local v204 = 0 - 0;
			while true do
				if (((760 - (10 + 17)) < (409 + 1410)) and ((1732 - (1400 + 332)) == v204)) then
					v32 = v148();
					if (v32 or ((8429 - 4034) == (6663 - (242 + 1666)))) then
						return v32;
					end
					break;
				end
			end
		end
		if ((not v114 and v90.SunKingsBlessing:IsAvailable()) or ((1624 + 2169) < (869 + 1500))) then
			v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((3 + 0) * v125));
		end
		if ((v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (940 - (850 + 90))) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) or ((7152 - 3068) == (1655 - (360 + 1030)))) then
			if (((3857 + 501) == (12300 - 7942)) and v24(v90.ShiftingPower, not v15:IsInRange(55 - 15), true)) then
				return "shifting_power main 12";
			end
		end
		if ((v126 < v100) or ((4799 - (909 + 752)) < (2216 - (109 + 1114)))) then
			v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + (12 - 5)) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
		end
		if (((1297 + 2033) > (2565 - (6 + 236))) and (v126 >= v100)) then
			v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 + 0)) and (v126 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (0.5 + 0))) or (v90.FireBlast:ChargesFractional() >= (4 - 2)))) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
			if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true) or ((151 + 765) == (3360 - (579 + 110)))) then
				return "fire_blast main 14";
			end
		end
		if (((22 + 250) == (241 + 31)) and v120 and v133() and (v110 > (0 + 0))) then
			v32 = v150();
			if (((4656 - (174 + 233)) <= (13516 - 8677)) and v32) then
				return v32;
			end
		end
		if (((4873 - 2096) < (1423 + 1777)) and v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) then
			if (((1269 - (663 + 511)) < (1746 + 211)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), nil, true)) then
				return "fire_blast main 16";
			end
		end
		if (((180 + 646) < (5293 - 3576)) and (v110 > (0 + 0)) and v120) then
			v32 = v151();
			if (((3356 - 1930) >= (2675 - 1570)) and v32) then
				return v32;
			end
		end
		if (((1315 + 1439) <= (6576 - 3197)) and v90.IceNova:IsCastable() and not v135()) then
			if (v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova)) or ((2799 + 1128) == (130 + 1283))) then
				return "ice_nova main 18";
			end
		end
		if ((v90.Scorch:IsReady() and v47) or ((1876 - (478 + 244)) <= (1305 - (440 + 77)))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch)) or ((748 + 895) > (12367 - 8988))) then
				return "scorch main 20";
			end
		end
	end
	local function v153()
		v37 = EpicSettings.Settings['useArcaneExplosion'];
		v38 = EpicSettings.Settings['useArcaneIntellect'];
		v39 = EpicSettings.Settings['useDragonsBreath'];
		v40 = EpicSettings.Settings['useFireBlast'];
		v41 = EpicSettings.Settings['useFireball'];
		v42 = EpicSettings.Settings['useFlamestrike'];
		v43 = EpicSettings.Settings['useLivingBomb'];
		v44 = EpicSettings.Settings['useMeteor'];
		v45 = EpicSettings.Settings['usePhoenixFlames'];
		v46 = EpicSettings.Settings['usePyroblast'];
		v47 = EpicSettings.Settings['useScorch'];
		v48 = EpicSettings.Settings['useCounterspell'];
		v49 = EpicSettings.Settings['useBlastWave'];
		v50 = EpicSettings.Settings['useCombustion'];
		v51 = EpicSettings.Settings['useShiftingPower'];
		v52 = EpicSettings.Settings['combustionWithCD'];
		v53 = EpicSettings.Settings['shiftingPowerWithCD'];
		v54 = EpicSettings.Settings['useAlterTime'];
		v55 = EpicSettings.Settings['useBlazingBarrier'];
		v56 = EpicSettings.Settings['useGreaterInvisibility'];
		v57 = EpicSettings.Settings['useIceBlock'];
		v58 = EpicSettings.Settings['useIceCold'];
		v60 = EpicSettings.Settings['useMassBarrier'];
		v59 = EpicSettings.Settings['useMirrorImage'];
		v61 = EpicSettings.Settings['alterTimeHP'] or (1556 - (655 + 901));
		v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 + 0);
		v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v64 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v65 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v66 = EpicSettings.Settings['mirrorImageHP'] or (1445 - (695 + 750));
		v67 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v86 = EpicSettings.Settings['mirrorImageBeforePull'];
		v87 = EpicSettings.Settings['useSpellStealTarget'];
		v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v154()
		local v198 = 0 - 0;
		while true do
			if (((11 - 8) == v198) or ((3154 - (285 + 66)) > (10603 - 6054))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (1310 - (682 + 628));
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v198 = 303 - (176 + 123);
			end
			if ((v198 == (0 + 0)) or ((160 + 60) >= (3291 - (239 + 30)))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v198 = 1 + 0;
			end
			if (((4994 - 2172) == (8804 - 5982)) and ((319 - (306 + 9)) == v198)) then
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((3 - 2) == v198) or ((185 + 876) == (1140 + 717))) then
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v198 = 1 + 1;
			end
			if (((7892 - 5132) > (2739 - (1140 + 235))) and ((2 + 0) == v198)) then
				v82 = EpicSettings.Settings['useRacials'];
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v198 = 3 + 0;
			end
		end
	end
	local function v155()
		local v199 = 0 + 0;
		while true do
			if ((v199 == (52 - (33 + 19))) or ((1770 + 3132) <= (10775 - 7180))) then
				v153();
				v154();
				v33 = EpicSettings.Toggles['ooc'];
				v34 = EpicSettings.Toggles['aoe'];
				v199 = 1 + 0;
			end
			if ((v199 == (3 - 1)) or ((3612 + 240) == (982 - (586 + 103)))) then
				v130 = v14:GetEnemiesInRange(4 + 36);
				if (v34 or ((4799 - 3240) == (6076 - (1309 + 179)))) then
					v126 = v30(v15:GetEnemiesInSplashRangeCount(9 - 4), #v130);
					v127 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v130);
					v128 = v30(v15:GetEnemiesInSplashRangeCount(13 - 8), #v130);
					v129 = #v130;
				else
					v126 = 1 + 0;
					v127 = 1 - 0;
					v128 = 1 - 0;
					v129 = 610 - (295 + 314);
				end
				if (v94.TargetIsValid() or v14:AffectingCombat() or ((11013 - 6529) == (2750 - (1300 + 662)))) then
					local v225 = 0 - 0;
					while true do
						if (((6323 - (1178 + 577)) >= (2030 + 1877)) and (v225 == (5 - 3))) then
							v132 = v139(v130);
							v96 = not v35;
							v225 = 1408 - (851 + 554);
						end
						if (((1102 + 144) < (9623 - 6153)) and (v225 == (0 - 0))) then
							if (((4370 - (115 + 187)) >= (745 + 227)) and (v14:AffectingCombat() or v69)) then
								local v227 = v69 and v90.RemoveCurse:IsReady() and v36;
								v32 = v94.FocusUnit(v227, v92, 19 + 1, nil, 78 - 58);
								if (((1654 - (160 + 1001)) < (3406 + 487)) and v32) then
									return v32;
								end
							end
							v123 = v10.BossFightRemains(nil, true);
							v225 = 1 + 0;
						end
						if ((v225 == (1 - 0)) or ((1831 - (237 + 121)) >= (4229 - (525 + 372)))) then
							v124 = v123;
							if ((v124 == (21064 - 9953)) or ((13309 - 9258) <= (1299 - (96 + 46)))) then
								v124 = v10.FightRemains(v130, false);
							end
							v225 = 779 - (643 + 134);
						end
						if (((219 + 385) < (6907 - 4026)) and (v225 == (11 - 8))) then
							if (v96 or ((864 + 36) == (6627 - 3250))) then
								v110 = 204410 - 104411;
							end
							v125 = v14:GCD();
							v225 = 723 - (316 + 403);
						end
						if (((2964 + 1495) > (1624 - 1033)) and (v225 == (2 + 2))) then
							v119 = v14:BuffUp(v90.CombustionBuff);
							v120 = not v119;
							break;
						end
					end
				end
				if (((8557 - 5159) >= (1698 + 697)) and not v14:AffectingCombat() and v33) then
					v32 = v145();
					if (v32 or ((704 + 1479) >= (9784 - 6960))) then
						return v32;
					end
				end
				v199 = 14 - 11;
			end
			if (((4021 - 2085) == (111 + 1825)) and (v199 == (5 - 2))) then
				if ((v14:AffectingCombat() and v94.TargetIsValid()) or ((237 + 4595) < (12689 - 8376))) then
					local v226 = 17 - (12 + 5);
					while true do
						if (((15877 - 11789) > (8265 - 4391)) and (v226 == (1 - 0))) then
							if (((10742 - 6410) == (880 + 3452)) and v70) then
								if (((5972 - (1656 + 317)) >= (2585 + 315)) and v89) then
									local v230 = 0 + 0;
									while true do
										if ((v230 == (0 - 0)) or ((12426 - 9901) > (4418 - (5 + 349)))) then
											v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 142 - 112);
											if (((5642 - (266 + 1005)) == (2881 + 1490)) and v32) then
												return v32;
											end
											break;
										end
									end
								end
							end
							if (v71 or ((907 - 641) > (6564 - 1578))) then
								local v228 = 1696 - (561 + 1135);
								while true do
									if (((2594 - 603) >= (3040 - 2115)) and (v228 == (1066 - (507 + 559)))) then
										v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseOver, 75 - 45, true);
										if (((1407 - 952) < (2441 - (212 + 176))) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if ((v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) or ((1731 - (250 + 655)) == (13228 - 8377))) then
								if (((319 - 136) == (285 - 102)) and v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							if (((3115 - (1869 + 87)) <= (6201 - 4413)) and (v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v90.HotStreakBuff)) then
								if (v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast)) or ((5408 - (484 + 1417)) > (9254 - 4936))) then
									return "Stop Casting";
								end
							end
							v226 = 2 - 0;
						end
						if ((v226 == (775 - (48 + 725))) or ((5023 - 1948) <= (7954 - 4989))) then
							if (((794 + 571) <= (5374 - 3363)) and v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes)) then
								if (v24(v90.IceFloes) or ((777 + 1999) > (1042 + 2533))) then
									return "ice_floes movement";
								end
							end
							if ((v14:IsMoving() and not v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes)) or ((3407 - (152 + 701)) == (6115 - (430 + 881)))) then
								if (((987 + 1590) == (3472 - (557 + 338))) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch))) then
									return "scorch movement";
								end
							end
							v32 = v152();
							if (v32 or ((2 + 4) >= (5322 - 3433))) then
								return v32;
							end
							break;
						end
						if (((1771 - 1265) <= (5026 - 3134)) and (v226 == (0 - 0))) then
							if ((v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) or ((2809 - (499 + 302)) > (3084 - (39 + 827)))) then
								if (((1045 - 666) <= (9261 - 5114)) and v24(v92.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if ((v69 and v36 and v90.RemoveCurse:IsAvailable()) or ((17928 - 13414) <= (1548 - 539))) then
								local v229 = 0 + 0;
								while true do
									if ((v229 == (0 - 0)) or ((560 + 2936) == (1885 - 693))) then
										if (v16 or ((312 - (103 + 1)) == (3513 - (475 + 79)))) then
											local v231 = 0 - 0;
											while true do
												if (((13686 - 9409) >= (170 + 1143)) and (v231 == (0 + 0))) then
													v32 = v143();
													if (((4090 - (1395 + 108)) < (9235 - 6061)) and v32) then
														return v32;
													end
													break;
												end
											end
										end
										if ((v18 and v18:Exists() and v18:IsAPlayer() and v94.UnitHasCurseDebuff(v18)) or ((5324 - (7 + 1197)) <= (959 + 1239))) then
											if (v90.RemoveCurse:IsReady() or ((557 + 1039) == (1177 - (27 + 292)))) then
												if (((9435 - 6215) == (4106 - 886)) and v24(v92.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							v32 = v144();
							if (v32 or ((5879 - 4477) > (7138 - 3518))) then
								return v32;
							end
							v226 = 1 - 0;
						end
					end
				end
				break;
			end
			if (((2713 - (43 + 96)) == (10499 - 7925)) and (v199 == (1 - 0))) then
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				if (((1492 + 306) < (779 + 1978)) and v14:IsDeadOrGhost()) then
					return v32;
				end
				v131 = v15:GetEnemiesInSplashRange(9 - 4);
				v199 = 1 + 1;
			end
		end
	end
	local function v156()
		v95();
		v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(117 - 54, v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

