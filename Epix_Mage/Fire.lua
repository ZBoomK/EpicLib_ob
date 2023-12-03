local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (83 > 1780)) then
			v6 = v0[v4];
			if ((546 <= 1077) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (996 > 4301)) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Fire.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['Target'];
	local v16 = v12['Pet'];
	local v17 = v10['Spell'];
	local v18 = v10['MultiSpell'];
	local v19 = v10['Item'];
	local v20 = EpicLib;
	local v21 = v20['Cast'];
	local v22 = v20['Press'];
	local v23 = v20['PressCursor'];
	local v24 = v20['Macro'];
	local v25 = v20['Bind'];
	local v26 = v20['Commons']['Everyone']['num'];
	local v27 = v20['Commons']['Everyone']['bool'];
	local v28 = math['max'];
	local v29 = math['ceil'];
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v86;
	local v87 = v17['Mage']['Fire'];
	local v88 = v19['Mage']['Fire'];
	local v89 = v24['Mage']['Fire'];
	local v90 = {};
	local v91 = v20['Commons']['Everyone'];
	local function v92()
		if ((4070 > 687) and v87['RemoveCurse']:IsAvailable()) then
			v91['DispellableDebuffs'] = v91['DispellableCurseDebuffs'];
		end
	end
	v10:RegisterForEvent(function()
		v92();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v93 = not v33;
	local v94 = v87['SunKingsBlessing']:IsAvailable();
	local v95 = ((v87['FlamePatch']:IsAvailable()) and 4) or 999;
	local v96 = 999;
	local v97 = v95;
	local v98 = (3 * v26(v87['FueltheFire']:IsAvailable())) + (999 * v26(not v87['FueltheFire']:IsAvailable()));
	local v99 = 999;
	local v100 = 40;
	local v101 = 999;
	local v102 = 0.3;
	local v103 = 0;
	local v104 = 6;
	local v105 = false;
	local v106 = (v105 and 20) or 0;
	local v107;
	local v108 = ((v87['Kindling']:IsAvailable()) and 0.4) or 1;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = 0;
	local v113 = 0;
	local v114 = 8;
	local v115 = 3;
	local v116;
	local v117;
	local v118;
	local v119 = 3;
	local v120 = 11111;
	local v121 = 11111;
	local v122;
	local v123, v124, v125;
	local v126;
	local v127;
	local v128;
	local v129;
	v10:RegisterForEvent(function()
		local v153 = 0;
		while true do
			if ((v153 == 0) or (656 >= 3330)) then
				v105 = false;
				v106 = (v105 and 20) or 0;
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v154 = 0;
		while true do
			if ((v154 == 3) or (2492 <= 335)) then
				v87['Pyroblast']:RegisterInFlight(v87.CombustionBuff);
				v87['Fireball']:RegisterInFlight(v87.CombustionBuff);
				break;
			end
			if ((4322 >= 2562) and (v154 == 2)) then
				v87['PhoenixFlames']:RegisterInFlightEffect(257542);
				v87['PhoenixFlames']:RegisterInFlight();
				v154 = 3;
			end
			if ((v154 == 1) or (3637 >= 3770)) then
				v87['Meteor']:RegisterInFlightEffect(351140);
				v87['Meteor']:RegisterInFlight();
				v154 = 2;
			end
			if ((v154 == 0) or (2379 > 4578)) then
				v87['Pyroblast']:RegisterInFlight();
				v87['Fireball']:RegisterInFlight();
				v154 = 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v87['Pyroblast']:RegisterInFlight();
	v87['Fireball']:RegisterInFlight();
	v87['Meteor']:RegisterInFlightEffect(351140);
	v87['Meteor']:RegisterInFlight();
	v87['PhoenixFlames']:RegisterInFlightEffect(257542);
	v87['PhoenixFlames']:RegisterInFlight();
	v87['Pyroblast']:RegisterInFlight(v87.CombustionBuff);
	v87['Fireball']:RegisterInFlight(v87.CombustionBuff);
	v10:RegisterForEvent(function()
		local v155 = 0;
		while true do
			if ((v155 == 0) or (483 > 743)) then
				v120 = 11111;
				v121 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v156 = 0;
		while true do
			if ((2454 > 578) and (v156 == 0)) then
				v94 = v87['SunKingsBlessing']:IsAvailable();
				v95 = ((v87['FlamePatch']:IsAvailable()) and 3) or 999;
				v156 = 1;
			end
			if ((930 < 4458) and (v156 == 1)) then
				v97 = v95;
				v108 = ((v87['Kindling']:IsAvailable()) and 0.4) or 1;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v130()
		return v87['Firestarter']:IsAvailable() and (v15:HealthPercentage() > 90);
	end
	local function v131()
		return (v87['Firestarter']:IsAvailable() and (((v15:HealthPercentage() > 90) and v15:TimeToX(90)) or 0)) or 0;
	end
	local function v132()
		return v87['SearingTouch']:IsAvailable() and (v15:HealthPercentage() < 30);
	end
	local function v133()
		return v87['ImprovedScorch']:IsAvailable() and (v15:HealthPercentage() < 30);
	end
	local function v134()
		return (v119 * v87['ShiftingPower']:BaseDuration()) / v87['ShiftingPower']:BaseTickTime();
	end
	local function v135()
		local v157 = 0;
		local v158;
		while true do
			if ((662 <= 972) and (1 == v157)) then
				return v14:BuffUp(v87.HotStreakBuff) or v14:BuffUp(v87.HyperthermiaBuff) or (v14:BuffUp(v87.HeatingUpBuff) and ((v133() and v14:IsCasting(v87.Scorch)) or (v130() and (v14:IsCasting(v87.Fireball) or v14:IsCasting(v87.Pyroblast) or (v158 > 0)))));
			end
			if ((4370 == 4370) and (0 == v157)) then
				v158 = (v130() and (v26(v87['Pyroblast']:InFlight()) + v26(v87['Fireball']:InFlight()))) or 0;
				v158 = v158 + v26(v87['PhoenixFlames']:InFlight() or v14:PrevGCDP(1, v87.PhoenixFlames));
				v157 = 1;
			end
		end
	end
	local function v136(v159)
		local v160 = 0;
		local v161;
		while true do
			if ((v160 == 1) or (4762 <= 861)) then
				return v161;
			end
			if ((v160 == 0) or (1412 == 4264)) then
				v161 = 0;
				for v228, v229 in pairs(v159) do
					if (v229:DebuffUp(v87.IgniteDebuff) or (3168 < 2153)) then
						v161 = v161 + 1;
					end
				end
				v160 = 1;
			end
		end
	end
	local function v137()
		local v162 = 0;
		local v163;
		while true do
			if ((v162 == 1) or (4976 < 1332)) then
				return v163;
			end
			if ((4628 == 4628) and (0 == v162)) then
				v163 = 0;
				if (v87['Fireball']:InFlight() or v87['PhoenixFlames']:InFlight() or (54 == 395)) then
					v163 = v163 + 1;
				end
				v162 = 1;
			end
		end
	end
	local function v138()
		local v164 = 0;
		while true do
			if ((82 == 82) and (v164 == 0)) then
				v30 = v91.HandleTopTrinket(v90, v33, 40, nil);
				if (v30 or (581 < 282)) then
					return v30;
				end
				v164 = 1;
			end
			if ((v164 == 1) or (4609 < 2495)) then
				v30 = v91.HandleBottomTrinket(v90, v33, 40, nil);
				if ((1152 == 1152) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v139()
		if ((1896 <= 3422) and v87['RemoveCurse']:IsReady() and v34 and v91.DispellableFriendlyUnit(20)) then
			if (v22(v89.RemoveCurseFocus) or (990 > 1620)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v140()
		local v165 = 0;
		while true do
			if ((v165 == 3) or (877 > 4695)) then
				if ((2691 >= 1851) and v87['AlterTime']:IsReady() and v52 and (v14:HealthPercentage() <= v59)) then
					if (v22(v87.AlterTime) or (2985 >= 4856)) then
						return "alter_time defensive 6";
					end
				end
				if ((4276 >= 1195) and v88['Healthstone']:IsReady() and v75 and (v14:HealthPercentage() <= v77)) then
					if ((3232 <= 4690) and v22(v89.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v165 = 4;
			end
			if ((v165 == 4) or (896 >= 3146)) then
				if ((3061 >= 2958) and v74 and (v14:HealthPercentage() <= v76)) then
					local v230 = 0;
					while true do
						if ((3187 >= 644) and (v230 == 0)) then
							if ((644 <= 704) and (v78 == "Refreshing Healing Potion")) then
								if ((958 > 947) and v88['RefreshingHealingPotion']:IsReady()) then
									if ((4492 >= 2654) and v22(v89.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((3442 >= 1503) and (v78 == "Dreamwalker's Healing Potion")) then
								if (v88['DreamwalkersHealingPotion']:IsReady() or (3170 <= 1464)) then
									if (v22(v89.RefreshingHealingPotion) or (4797 == 4388)) then
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
			if ((551 <= 681) and (v165 == 0)) then
				if ((3277 > 407) and v87['BlazingBarrier']:IsCastable() and v53 and v14:BuffDown(v87.BlazingBarrier) and (v14:HealthPercentage() <= v60)) then
					if ((4695 >= 1415) and v22(v87.BlazingBarrier)) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v87['MassBarrier']:IsCastable() and v58 and v14:BuffDown(v87.BlazingBarrier) and v91.AreUnitsBelowHealthPercentage(v65, 2)) or (3212 <= 944)) then
					if (v22(v87.MassBarrier) or (3096 <= 1798)) then
						return "mass_barrier defensive 2";
					end
				end
				v165 = 1;
			end
			if ((3537 == 3537) and (v165 == 2)) then
				if ((3837 >= 1570) and v87['MirrorImage']:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) then
					if (v22(v87.MirrorImage) or (2950 == 3812)) then
						return "mirror_image defensive 4";
					end
				end
				if ((4723 >= 2318) and v87['GreaterInvisibility']:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
					if (v22(v87.GreaterInvisibility) or (2027 > 2852)) then
						return "greater_invisibility defensive 5";
					end
				end
				v165 = 3;
			end
			if ((v165 == 1) or (1136 > 4317)) then
				if ((4748 == 4748) and v87['IceBlock']:IsCastable() and v55 and (v14:HealthPercentage() <= v62)) then
					if ((3736 <= 4740) and v22(v87.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v87['IceColdTalent']:IsAvailable() and v87['IceColdAbility']:IsCastable() and v56 and (v14:HealthPercentage() <= v63)) or (3390 <= 3060)) then
					if (v22(v87.IceColdAbility) or (999 > 2693)) then
						return "ice_cold defensive 3";
					end
				end
				v165 = 2;
			end
		end
	end
	local function v141()
		local v166 = 0;
		while true do
			if ((463 < 601) and (v166 == 1)) then
				if ((v87['Pyroblast']:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast)) or (2183 < 687)) then
					if ((4549 == 4549) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return "pyroblast precombat 4";
					end
				end
				if ((4672 == 4672) and v87['Fireball']:IsReady() and v39) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true) or (3668 < 395)) then
						return "fireball precombat 6";
					end
				end
				break;
			end
			if ((0 == v166) or (4166 == 455)) then
				if ((v87['ArcaneIntellect']:IsCastable() and v36 and (v14:BuffDown(v87.ArcaneIntellect, true) or v91.GroupBuffMissing(v87.ArcaneIntellect))) or (4449 == 2663)) then
					if (v22(v87.ArcaneIntellect) or (4277 < 2989)) then
						return "arcane_intellect precombat 2";
					end
				end
				if ((v87['MirrorImage']:IsCastable() and v91.TargetIsValid() and v57 and v83) or (870 >= 4149)) then
					if ((2212 < 3183) and v22(v87.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				v166 = 1;
			end
		end
	end
	local function v142()
		local v167 = 0;
		while true do
			if ((4646 > 2992) and (v167 == 1)) then
				if ((1434 < 3106) and v87['DragonsBreath']:IsReady() and v37 and v87['AlexstraszasFury']:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > 15)) and not v133() and (v131() == 0) and not v87['TemperedFlames']:IsAvailable()) then
					if ((786 < 3023) and v22(v87.DragonsBreath)) then
						return "dragons_breath active_talents 6";
					end
				end
				if ((v87['DragonsBreath']:IsReady() and v37 and v87['AlexstraszasFury']:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > 15)) and not v133() and v87['TemperedFlames']:IsAvailable()) or (2442 < 74)) then
					if ((4535 == 4535) and v22(v87.DragonsBreath)) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v167 == 0) or (3009 <= 2105)) then
				if ((1830 < 3669) and v87['LivingBomb']:IsReady() and v41 and (v124 > 1) and v117 and ((v107 > v87['LivingBomb']:CooldownRemains()) or (v107 <= 0))) then
					if (v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb)) or (1430 >= 3612)) then
						return "living_bomb active_talents 2";
					end
				end
				if ((2683 >= 2460) and v87['Meteor']:IsReady() and v42 and (v73 < v121) and ((v107 <= 0) or (v14:BuffRemains(v87.CombustionBuff) > v87['Meteor']:TravelTime()) or (not v87['SunKingsBlessing']:IsAvailable() and ((45 < v107) or (v121 < v107))))) then
					if (v22(v89.MeteorCursor, not v15:IsInRange(40)) or (1804 >= 3275)) then
						return "meteor active_talents 4";
					end
				end
				v167 = 1;
			end
		end
	end
	local function v143()
		local v168 = 0;
		local v169;
		while true do
			if ((v168 == 1) or (1417 > 3629)) then
				if ((4795 > 402) and v79 and ((v82 and v33) or not v82) and (v73 < v121)) then
					local v231 = 0;
					while true do
						if ((4813 > 3565) and (1 == v231)) then
							if ((3912 == 3912) and v87['Fireblood']:IsCastable()) then
								if ((2821 <= 4824) and v22(v87.Fireblood)) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if ((1738 <= 2195) and v87['AncestralCall']:IsCastable()) then
								if ((41 <= 3018) and v22(v87.AncestralCall)) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
						if ((2145 <= 4104) and (v231 == 0)) then
							if ((2689 < 4845) and v87['BloodFury']:IsCastable()) then
								if (v22(v87.BloodFury) or (2322 > 2622)) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v87['Berserking']:IsCastable() and v116) or (4534 == 2082)) then
								if (v22(v87.Berserking) or (1571 > 1867)) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v231 = 1;
						end
					end
				end
				if ((v85 and v87['TimeWarp']:IsReady() and v87['TemporalWarp']:IsAvailable() and v14:BloodlustExhaustUp()) or (2654 >= 2996)) then
					if ((3978 > 2104) and v22(v87.TimeWarp, nil, nil, true)) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v168 = 2;
			end
			if ((2995 > 1541) and (v168 == 2)) then
				if ((3249 > 953) and (v73 < v121)) then
					if ((v80 and ((v33 and v81) or not v81)) or (3273 > 4573)) then
						local v241 = 0;
						while true do
							if ((v241 == 0) or (3151 < 1284)) then
								v30 = v138();
								if (v30 or (1850 == 1529)) then
									return v30;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((821 < 2123) and (v168 == 0)) then
				v169 = v91.HandleDPSPotion(v14:BuffUp(v87.CombustionBuff));
				if ((902 < 2325) and v169) then
					return v169;
				end
				v168 = 1;
			end
		end
	end
	local function v144()
		local v170 = 0;
		while true do
			if ((858 <= 2962) and (v170 == 8)) then
				if ((v87['Scorch']:IsReady() and v45 and (v14:BuffRemains(v87.CombustionBuff) > v87['Scorch']:CastTime()) and (v87['Scorch']:CastTime() >= v122)) or (3946 < 1288)) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or (3242 == 567)) then
						return "scorch combustion_phase 44";
					end
				end
				if ((v87['Fireball']:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87['Fireball']:CastTime())) or (847 >= 1263)) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball)) or (2253 == 1851)) then
						return "fireball combustion_phase 46";
					end
				end
				if ((v87['LivingBomb']:IsReady() and v41 and (v14:BuffRemains(v87.CombustionBuff) < v122) and (v124 > 1)) or (2087 > 2372)) then
					if (v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb)) or (4445 < 4149)) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if ((5 == v170) or (1818 == 85)) then
				if ((630 < 2127) and v87['Pyroblast']:IsReady() and v44 and v14:BuffUp(v87.HotStreakBuff) and v116) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (1938 == 2514)) then
						return "pyroblast combustion_phase 26";
					end
				end
				if ((4255 >= 55) and v87['Pyroblast']:IsReady() and v44 and v14:PrevGCDP(1, v87.Scorch) and v14:BuffUp(v87.HeatingUpBuff) and (v123 < v97) and v116) then
					if ((2999 > 1156) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if ((2350 > 1155) and v87['ShiftingPower']:IsReady() and v49 and ((v51 and v33) or not v51) and (v73 < v121) and v116 and (v87['FireBlast']:Charges() == 0) and ((v87['PhoenixFlames']:Charges() < v87['PhoenixFlames']:MaxCharges()) or v87['AlexstraszasFury']:IsAvailable()) and (v101 <= v123)) then
					if ((4029 <= 4853) and v22(v87.ShiftingPower, not v15:IsInRange(40))) then
						return "shifting_power combustion_phase 30";
					end
				end
				v170 = 6;
			end
			if ((7 == v170) or (516 > 3434)) then
				if ((4046 >= 3033) and v87['PhoenixFlames']:IsCastable() and v43 and v14:HasTier(30, 2) and (v87['PhoenixFlames']:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < 2) and ((v15:DebuffRemains(v87.CharringEmbersDebuff) < (4 * v122)) or (v14:BuffStack(v87.FlamesFuryBuff) > 1) or v14:BuffUp(v87.FlamesFuryBuff))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (2719 <= 1447)) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if ((v87['Fireball']:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87['Fireball']:CastTime()) and v14:BuffUp(v87.FlameAccelerantBuff)) or (4134 < 3926)) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball)) or (164 >= 2785)) then
						return "fireball combustion_phase 40";
					end
				end
				if ((v87['PhoenixFlames']:IsCastable() and v43 and not v14:HasTier(30, 2) and not v87['AlexstraszasFury']:IsAvailable() and (v87['PhoenixFlames']:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < 2)) or (525 == 2109)) then
					if ((33 == 33) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v170 = 8;
			end
			if ((3054 <= 4015) and (v170 == 3)) then
				if ((1871 < 3382) and v87['Pyroblast']:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87['Pyroblast']:CastTime())) then
					if ((1293 <= 2166) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if ((v87['Fireball']:IsReady() and v39 and v117 and (v87['Combustion']:CooldownRemains() < v87['Fireball']:CastTime()) and (v123 < 2) and not v133()) or (2579 < 123)) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball)) or (846 >= 2368)) then
						return "fireball combustion_phase 16";
					end
				end
				if ((v87['Scorch']:IsReady() and v45 and v117 and (v87['Combustion']:CooldownRemains() < v87['Scorch']:CastTime())) or (4012 <= 3358)) then
					if ((1494 <= 3005) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch combustion_phase 18";
					end
				end
				v170 = 4;
			end
			if ((v170 == 4) or (3111 == 2134)) then
				if ((2355 == 2355) and v87['FireBlast']:IsReady() and v38 and not v135() and not v111 and (not v133() or v14:IsCasting(v87.Scorch) or (v15:DebuffRemains(v87.ImprovedScorchDebuff) > (4 * v122))) and (v14:BuffDown(v87.FuryoftheSunKingBuff) or v14:IsCasting(v87.Pyroblast)) and v116 and v14:BuffDown(v87.HyperthermiaBuff) and v14:BuffDown(v87.HotStreakBuff) and ((v137() + (v26(v14:BuffUp(v87.HeatingUpBuff)) * v26(v14:GCDRemains() > 0))) < 2)) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (588 <= 432)) then
						return "fire_blast combustion_phase 20";
					end
				end
				if ((4797 >= 3895) and v32 and v87['Flamestrike']:IsReady() and v40 and ((v14:BuffUp(v87.HotStreakBuff) and (v123 >= v97)) or (v14:BuffUp(v87.HyperthermiaBuff) and (v123 >= (v97 - v26(v87['Hyperthermia']:IsAvailable())))))) then
					if ((3577 == 3577) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((3794 > 3693) and v87['Pyroblast']:IsReady() and v44 and (v14:BuffUp(v87.HyperthermiaBuff))) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (1275 == 4100)) then
						return "pyroblast combustion_phase 24";
					end
				end
				v170 = 5;
			end
			if ((v170 == 2) or (1591 >= 3580)) then
				if ((983 <= 1808) and v30) then
					return v30;
				end
				if ((v87['Combustion']:IsReady() and v48 and ((v50 and v33) or not v50) and (v73 < v121) and (v137() == 0) and v117 and (v107 <= 0) and ((v14:IsCasting(v87.Scorch) and (v87['Scorch']:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Fireball) and (v87['Fireball']:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Pyroblast) and (v87['Pyroblast']:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Flamestrike) and (v87['Flamestrike']:ExecuteRemains() < v102)) or (v87['Meteor']:InFlight() and (v87['Meteor']:InFlightRemains() < v102)))) or (2150 <= 1197)) then
					if ((3769 >= 1173) and v22(v87.Combustion, not v15:IsInRange(40), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				if ((1485 == 1485) and v32 and v87['Flamestrike']:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87['Flamestrike']:CastTime()) and (v87['Combustion']:CooldownRemains() < v87['Flamestrike']:CastTime()) and (v123 >= v98)) then
					if (v22(v89.FlamestrikeCursor, not v15:IsInRange(40)) or (3315 <= 2782)) then
						return "flamestrike combustion_phase 12";
					end
				end
				v170 = 3;
			end
			if ((v170 == 0) or (876 >= 2964)) then
				if ((v87['LightsJudgment']:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) or (2232 > 2497)) then
					if (v22(v87.LightsJudgment, not v15:IsSpellInRange(v87.LightsJudgment)) or (2110 <= 332)) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if ((3686 > 3172) and v87['BagofTricks']:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) then
					if (v22(v87.BagofTricks) or (4474 < 820)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((4279 >= 2882) and v87['LivingBomb']:IsReady() and v32 and v41 and (v124 > 1) and v117) then
					if (v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb)) or (2029 >= 3521)) then
						return "living_bomb combustion_phase 6";
					end
				end
				v170 = 1;
			end
			if ((v170 == 1) or (2037 >= 4642)) then
				if ((1720 < 4458) and ((v14:BuffRemains(v87.CombustionBuff) > v104) or (v121 < 20))) then
					local v232 = 0;
					while true do
						if ((0 == v232) or (436 > 3021)) then
							v30 = v143();
							if ((713 <= 847) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((2154 <= 4031) and v87['PhoenixFlames']:IsCastable() and v43 and v14:BuffDown(v87.CombustionBuff) and v14:HasTier(30, 2) and not v87['PhoenixFlames']:InFlight() and (v15:DebuffRemains(v87.CharringEmbersDebuff) < (4 * v122)) and v14:BuffDown(v87.HotStreakBuff)) then
					if ((4615 == 4615) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v30 = v142();
				v170 = 2;
			end
			if ((v170 == 6) or (3790 == 500)) then
				if ((89 < 221) and v32 and v87['Flamestrike']:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87['Flamestrike']:CastTime()) and (v123 >= v98)) then
					if ((2054 >= 1421) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((692 < 3058) and v87['Pyroblast']:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87['Pyroblast']:CastTime())) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (3254 == 1655)) then
						return "pyroblast combustion_phase 34";
					end
				end
				if ((v87['Scorch']:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (4 * v122)) and (v125 < v97)) or (1296 == 4910)) then
					if ((3368 == 3368) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch combustion_phase 36";
					end
				end
				v170 = 7;
			end
		end
	end
	local function v145()
		local v171 = 0;
		while true do
			if ((2643 < 3815) and (v171 == 1)) then
				v107 = v112;
				if ((1913 > 493) and v87['Firestarter']:IsAvailable() and not v94) then
					v107 = v28(v131(), v107);
				end
				v171 = 2;
			end
			if ((4755 > 3428) and (v171 == 2)) then
				if ((1381 <= 2369) and v87['SunKingsBlessing']:IsAvailable() and v130() and v14:BuffDown(v87.FuryoftheSunKingBuff)) then
					v107 = v28((v114 - v14:BuffStack(v87.SunKingsBlessingBuff)) * 3 * v122, v107);
				end
				v107 = v28(v14:BuffRemains(v87.CombustionBuff), v107);
				v171 = 3;
			end
			if ((v171 == 3) or (4843 == 4084)) then
				if ((4669 > 363) and (((v112 + (120 * (1 - ((0.4 + (0.2 * v26(v87['Firestarter']:IsAvailable()))) * v26(v87['Kindling']:IsAvailable()))))) <= v107) or (v107 > (v121 - 20)))) then
					v107 = v112;
				end
				break;
			end
			if ((v171 == 0) or (1877 >= 3138)) then
				v112 = v87['Combustion']:CooldownRemains() * v108;
				v113 = ((v87['Fireball']:CastTime() * v26(v123 < v97)) + (v87['Flamestrike']:CastTime() * v26(v123 >= v97))) - v102;
				v171 = 1;
			end
		end
	end
	local function v146()
		local v172 = 0;
		while true do
			if ((4742 >= 3626) and (v172 == 0)) then
				if ((v87['FireBlast']:IsReady() and v38 and not v135() and not v111 and v14:BuffDown(v87.HotStreakBuff) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == 1) and (v87['ShiftingPower']:CooldownUp() or (v87['FireBlast']:Charges() > 1) or (v14:BuffRemains(v87.FeeltheBurnBuff) < (2 * v122)))) or (4540 == 916)) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (1156 > 4345)) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if ((2237 < 4249) and v87['FireBlast']:IsReady() and v38 and not v135() and not v111 and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == 1) and v87['ShiftingPower']:CooldownUp() and (not v14:HasTier(30, 2) or (v15:DebuffRemains(v87.CharringEmbersDebuff) > (2 * v122)))) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (2683 < 23)) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v147()
		local v173 = 0;
		while true do
			if ((697 <= 826) and (v173 == 5)) then
				if ((1105 <= 1176) and v87['Fireball']:IsReady() and v39 and not v135()) then
					if ((3379 <= 3812) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true)) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v173 == 0) or (788 >= 1616)) then
				if ((1854 <= 3379) and v32 and v87['Flamestrike']:IsReady() and v40 and (v123 >= v95) and v135()) then
					if ((4549 == 4549) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if ((v87['Pyroblast']:IsReady() and v44 and (v135())) or (3022 >= 3024)) then
					if ((4820 > 2198) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v32 and v87['Flamestrike']:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and (v123 >= v98) and v14:BuffUp(v87.FuryoftheSunKingBuff)) or (1061 >= 4891)) then
					if ((1364 <= 4473) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v87['Scorch']:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (v87['Pyroblast']:CastTime() + (5 * v122))) and v14:BuffUp(v87.FuryoftheSunKingBuff) and not v14:IsCasting(v87.Scorch)) or (3595 <= 3)) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or (4672 == 3852)) then
						return "scorch standard_rotation 13";
					end
				end
				v173 = 1;
			end
			if ((1559 == 1559) and (v173 == 1)) then
				if ((v87['Pyroblast']:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and (v14:BuffUp(v87.FuryoftheSunKingBuff))) or (1752 <= 788)) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or (3907 == 177)) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((3470 > 555) and v87['FireBlast']:IsReady() and v38 and not v135() and not v130() and not v111 and v14:BuffDown(v87.FuryoftheSunKingBuff) and ((((v14:IsCasting(v87.Fireball) and ((v87['Fireball']:ExecuteRemains() < 0.5) or not v87['Hyperthermia']:IsAvailable())) or (v14:IsCasting(v87.Pyroblast) and ((v87['Pyroblast']:ExecuteRemains() < 0.5) or not v87['Hyperthermia']:IsAvailable()))) and v14:BuffUp(v87.HeatingUpBuff)) or (v132() and (not v133() or (v15:DebuffStack(v87.ImprovedScorchDebuff) == v115) or (v87['FireBlast']:FullRechargeTime() < 3)) and ((v14:BuffUp(v87.HeatingUpBuff) and not v14:IsCasting(v87.Scorch)) or (v14:BuffDown(v87.HotStreakBuff) and v14:BuffDown(v87.HeatingUpBuff) and v14:IsCasting(v87.Scorch) and (v137() == 0)))))) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (972 == 645)) then
						return "fire_blast standard_rotation 16";
					end
				end
				if ((3182 >= 2115) and v87['Pyroblast']:IsReady() and v44 and (v14:IsCasting(v87.Scorch) or v14:PrevGCDP(1, v87.Scorch)) and v14:BuffUp(v87.HeatingUpBuff) and v132() and (v123 < v95)) then
					if ((3893 < 4429) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if ((v87['Scorch']:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (4 * v122))) or (2867 < 1905)) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or (1796 >= 4051)) then
						return "scorch standard_rotation 19";
					end
				end
				v173 = 2;
			end
			if ((1619 <= 3756) and (4 == v173)) then
				if ((604 == 604) and v87['Scorch']:IsReady() and v45 and (v132())) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or (4484 == 900)) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v32 and v87['ArcaneExplosion']:IsReady() and v35 and (v126 >= v99) and (v14:ManaPercentageP() >= v100)) or (4459 <= 1113)) then
					if ((3632 > 3398) and v22(v87.ArcaneExplosion, not v15:IsInRange(30))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((4082 <= 4917) and v32 and v87['Flamestrike']:IsReady() and v40 and (v123 >= v96)) then
					if ((4832 >= 1386) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((137 == 137) and v87['Pyroblast']:IsReady() and v44 and v87['TemperedFlames']:IsAvailable() and v14:BuffDown(v87.FlameAccelerantBuff)) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or (1570 >= 4332)) then
						return "pyroblast standard_rotation 35";
					end
				end
				v173 = 5;
			end
			if ((v173 == 2) or (4064 <= 1819)) then
				if ((v87['PhoenixFlames']:IsCastable() and v43 and v87['AlexstraszasFury']:IsAvailable() and (not v87['FeeltheBurn']:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < (2 * v122)))) or (4986 < 1574)) then
					if ((4426 > 172) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if ((586 > 455) and v87['PhoenixFlames']:IsCastable() and v43 and v14:HasTier(30, 2) and (v15:DebuffRemains(v87.CharringEmbersDebuff) < (2 * v122)) and v14:BuffDown(v87.HotStreakBuff)) then
					if ((826 == 826) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v87['Scorch']:IsReady() and v45 and v133() and (v15:DebuffStack(v87.ImprovedScorchDebuff) < v115)) or (4019 > 4441)) then
					if ((2017 < 4261) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch standard_rotation 22";
					end
				end
				if ((4716 > 80) and v87['PhoenixFlames']:IsCastable() and v43 and not v87['AlexstraszasFury']:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and not v110 and v14:BuffUp(v87.FlamesFuryBuff)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (3507 == 3272)) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v173 = 3;
			end
			if ((v173 == 3) or (876 >= 3075)) then
				if ((4352 > 2554) and v87['PhoenixFlames']:IsCastable() and v43 and v87['AlexstraszasFury']:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and (v137() == 0) and ((not v110 and v14:BuffUp(v87.FlamesFuryBuff)) or (v87['PhoenixFlames']:ChargesFractional() > 2.5) or ((v87['PhoenixFlames']:ChargesFractional() > 1.5) and (not v87['FeeltheBurn']:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < (3 * v122)))))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (4406 < 4043)) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v30 = v142();
				if (v30 or (1889 >= 3383)) then
					return v30;
				end
				if ((1892 <= 2734) and v32 and v87['DragonsBreath']:IsReady() and v37 and (v125 > 1) and v87['AlexstraszasFury']:IsAvailable()) then
					if ((1923 < 2218) and v22(v87.DragonsBreath)) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v173 = 4;
			end
		end
	end
	local function v148()
		local v174 = 0;
		while true do
			if ((2173 > 379) and (0 == v174)) then
				if (not v93 or (2591 == 3409)) then
					v145();
				end
				if ((4514 > 3324) and v33 and v85 and v87['TimeWarp']:IsReady() and v14:BloodlustExhaustUp() and v87['TemporalWarp']:IsAvailable() and (v130() or (v121 < 40))) then
					if (v22(v87.TimeWarp, not v15:IsInRange(40)) or (208 >= 4828)) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if ((v73 < v121) or (1583 > 3567)) then
					if ((v80 and ((v33 and v81) or not v81)) or (1313 == 794)) then
						local v242 = 0;
						while true do
							if ((3174 > 2902) and (v242 == 0)) then
								v30 = v138();
								if ((4120 <= 4260) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v109 = v107 > v87['ShiftingPower']:CooldownRemains();
				v174 = 1;
			end
			if ((v174 == 3) or (883 > 4778)) then
				if ((v87['FireBlast']:IsReady() and v38 and not v135() and v14:IsCasting(v87.ShiftingPower) and (v87['FireBlast']:FullRechargeTime() < v119)) or (3620 >= 4891)) then
					if ((4258 > 937) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast main 16";
					end
				end
				if (((v107 > 0) and v117) or (4869 < 906)) then
					local v233 = 0;
					while true do
						if ((v233 == 0) or (1225 > 4228)) then
							v30 = v147();
							if ((3328 > 2238) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((3839 > 1405) and v87['IceNova']:IsCastable() and UseIceNova and not v132()) then
					if (v22(v87.IceNova, not v15:IsSpellInRange(v87.IceNova)) or (1293 <= 507)) then
						return "ice_nova main 18";
					end
				end
				if ((v87['Scorch']:IsReady() and v45) or (2896 < 805)) then
					if ((2316 == 2316) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return "scorch main 20";
					end
				end
				break;
			end
			if ((v174 == 1) or (2570 == 1533)) then
				v111 = v117 and (((v87['FireBlast']:ChargesFractional() + ((v107 + (v134() * v26(v109))) / v87['FireBlast']:Cooldown())) - 1) < ((v87['FireBlast']:MaxCharges() + (v103 / v87['FireBlast']:Cooldown())) - ((12 / v87['FireBlast']:Cooldown()) % 1))) and (v107 < v121);
				if ((not v93 and ((v107 <= 0) or v116 or ((v107 < v113) and (v87['Combustion']:CooldownRemains() < v113)))) or (883 == 1460)) then
					local v234 = 0;
					while true do
						if ((v234 == 0) or (4619 <= 999)) then
							v30 = v144();
							if (v30 or (3410 > 4116)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((not v111 and v87['SunKingsBlessing']:IsAvailable()) or (903 >= 3059)) then
					v111 = v132() and (v87['FireBlast']:FullRechargeTime() > (3 * v122));
				end
				if ((v87['ShiftingPower']:IsReady() and ((v33 and v51) or not v51) and v49 and (v73 < v121) and v117 and ((v87['FireBlast']:Charges() == 0) or v111) and (not v133() or ((v15:DebuffRemains(v87.ImprovedScorchDebuff) > (v87['ShiftingPower']:CastTime() + v87['Scorch']:CastTime())) and v14:BuffDown(v87.FuryoftheSunKingBuff))) and v14:BuffDown(v87.HotStreakBuff) and v109) or (3976 < 2857)) then
					if ((4930 > 2307) and v22(v87.ShiftingPower, not v15:IsInRange(40), true)) then
						return "shifting_power main 12";
					end
				end
				v174 = 2;
			end
			if ((v174 == 2) or (4046 < 1291)) then
				if ((v123 < v97) or (4241 == 3545)) then
					v110 = (v87['SunKingsBlessing']:IsAvailable() or (((v107 + 7) < ((v87['PhoenixFlames']:FullRechargeTime() + v87['PhoenixFlames']:Cooldown()) - (v134() * v26(v109)))) and (v107 < v121))) and not v87['AlexstraszasFury']:IsAvailable();
				end
				if ((v123 >= v97) or (4048 > 4232)) then
					v110 = (v87['SunKingsBlessing']:IsAvailable() or ((v107 < (v87['PhoenixFlames']:FullRechargeTime() - (v134() * v26(v109)))) and (v107 < v121))) and not v87['AlexstraszasFury']:IsAvailable();
				end
				if ((v87['FireBlast']:IsReady() and v38 and not v135() and not v111 and (v107 > 0) and (v123 >= v96) and not v130() and v14:BuffDown(v87.HotStreakBuff) and ((v14:BuffUp(v87.HeatingUpBuff) and (v87['Flamestrike']:ExecuteRemains() < 0.5)) or (v87['FireBlast']:ChargesFractional() >= 2))) or (1750 >= 3473)) then
					if ((3166 == 3166) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return "fire_blast main 14";
					end
				end
				if ((1763 < 3724) and v117 and v130() and (v107 > 0)) then
					local v235 = 0;
					while true do
						if ((57 <= 2723) and (v235 == 0)) then
							v30 = v146();
							if (v30 or (2070 == 443)) then
								return v30;
							end
							break;
						end
					end
				end
				v174 = 3;
			end
		end
	end
	local function v149()
		local v175 = 0;
		while true do
			if ((v175 == 3) or (2705 == 1393)) then
				v50 = EpicSettings['Settings']['combustionWithCD'];
				v51 = EpicSettings['Settings']['shiftingPowerWithCD'];
				v52 = EpicSettings['Settings']['useAlterTime'];
				v53 = EpicSettings['Settings']['useBlazingBarrier'];
				v54 = EpicSettings['Settings']['useGreaterInvisibility'];
				v175 = 4;
			end
			if ((v175 == 4) or (4601 < 61)) then
				v55 = EpicSettings['Settings']['useIceBlock'];
				v56 = EpicSettings['Settings']['useIceCold'];
				v58 = EpicSettings['Settings']['useMassBarrier'];
				v57 = EpicSettings['Settings']['useMirrorImage'];
				v59 = EpicSettings['Settings']['alterTimeHP'] or 0;
				v175 = 5;
			end
			if ((v175 == 2) or (1390 >= 4744)) then
				v45 = EpicSettings['Settings']['useScorch'];
				v46 = EpicSettings['Settings']['useCounterspell'];
				v47 = EpicSettings['Settings']['useBlastWave'];
				v48 = EpicSettings['Settings']['useCombustion'];
				v49 = EpicSettings['Settings']['useShiftingPower'];
				v175 = 3;
			end
			if ((v175 == 1) or (2003 > 3834)) then
				v40 = EpicSettings['Settings']['useFlamestrike'];
				v41 = EpicSettings['Settings']['useLivingBomb'];
				v42 = EpicSettings['Settings']['useMeteor'];
				v43 = EpicSettings['Settings']['usePhoenixFlames'];
				v44 = EpicSettings['Settings']['usePyroblast'];
				v175 = 2;
			end
			if ((0 == v175) or (156 > 3913)) then
				v35 = EpicSettings['Settings']['useArcaneExplosion'];
				v36 = EpicSettings['Settings']['useArcaneIntellect'];
				v37 = EpicSettings['Settings']['useDragonsBreath'];
				v38 = EpicSettings['Settings']['useFireBlast'];
				v39 = EpicSettings['Settings']['useFireball'];
				v175 = 1;
			end
			if ((195 == 195) and (5 == v175)) then
				v60 = EpicSettings['Settings']['blazingBarrierHP'] or 0;
				v61 = EpicSettings['Settings']['greaterInvisibilityHP'] or 0;
				v62 = EpicSettings['Settings']['iceBlockHP'] or 0;
				v63 = EpicSettings['Settings']['iceColdHP'] or 0;
				v64 = EpicSettings['Settings']['mirrorImageHP'] or 0;
				v175 = 6;
			end
			if ((3105 >= 1796) and (v175 == 6)) then
				v65 = EpicSettings['Settings']['massBarrierHP'] or 0;
				v83 = EpicSettings['Settings']['mirrorImageBeforePull'];
				v84 = EpicSettings['Settings']['useSpellStealTarget'];
				v85 = EpicSettings['Settings']['useTimeWarpWithTalent'];
				v86 = EpicSettings['Settings']['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v150()
		local v176 = 0;
		while true do
			if ((4379 >= 2131) and (v176 == 3)) then
				v77 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v76 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v78 = EpicSettings['Settings']['HealingPotionName'] or "";
				v68 = EpicSettings['Settings']['handleAfflicted'];
				v176 = 4;
			end
			if ((3844 >= 2043) and (1 == v176)) then
				v67 = EpicSettings['Settings']['DispelDebuffs'];
				v66 = EpicSettings['Settings']['DispelBuffs'];
				v80 = EpicSettings['Settings']['useTrinkets'];
				v79 = EpicSettings['Settings']['useRacials'];
				v176 = 2;
			end
			if ((v176 == 4) or (3232 <= 2731)) then
				v69 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((4905 == 4905) and (v176 == 2)) then
				v81 = EpicSettings['Settings']['trinketsWithCD'];
				v82 = EpicSettings['Settings']['racialsWithCD'];
				v75 = EpicSettings['Settings']['useHealthstone'];
				v74 = EpicSettings['Settings']['useHealingPotion'];
				v176 = 3;
			end
			if ((v176 == 0) or (4136 >= 4411)) then
				v73 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v70 = EpicSettings['Settings']['InterruptWithStun'];
				v71 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v72 = EpicSettings['Settings']['InterruptThreshold'];
				v176 = 1;
			end
		end
	end
	local function v151()
		local v177 = 0;
		while true do
			if ((v177 == 3) or (2958 == 4017)) then
				if ((1228 >= 813) and not v14:AffectingCombat() and v31) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (3455 > 4050)) then
							v30 = v141();
							if ((243 == 243) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v14:AffectingCombat() and v91.TargetIsValid()) or (271 > 1572)) then
					local v237 = 0;
					while true do
						if ((2739 < 3293) and (v237 == 0)) then
							if (Focus or (3942 < 1134)) then
								if (v67 or (2693 == 4973)) then
									local v246 = 0;
									while true do
										if ((2146 == 2146) and (v246 == 0)) then
											v30 = v139();
											if (v30 or (2244 == 3224)) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v30 = v140();
							v237 = 1;
						end
						if ((v237 == 1) or (4904 <= 1916)) then
							if ((90 <= 1065) and v30) then
								return v30;
							end
							if ((4802 == 4802) and v68) then
								if (v86 or (2280 <= 511)) then
									local v247 = 0;
									while true do
										if ((v247 == 0) or (1676 <= 463)) then
											v30 = v91.HandleAfflicted(v87.RemoveCurse, v89.RemoveCurseMouseover, 30);
											if ((3869 == 3869) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v237 = 2;
						end
						if ((1158 <= 2613) and (v237 == 2)) then
							if (v69 or (2364 <= 1999)) then
								local v243 = 0;
								while true do
									if ((0 == v243) or (4922 < 194)) then
										v30 = v91.HandleIncorporeal(v87.Polymorph, v89.PolymorphMouseOver, 30, true);
										if (v30 or (2091 < 31)) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v87['Spellsteal']:IsAvailable() and v84 and v87['Spellsteal']:IsReady() and v34 and v66 and not v14:IsCasting() and not v14:IsChanneling() and v91.UnitHasMagicBuff(v15)) or (2430 >= 4872)) then
								if (v22(v87.Spellsteal, not v15:IsSpellInRange(v87.Spellsteal)) or (4770 < 1735)) then
									return "spellsteal damage";
								end
							end
							v237 = 3;
						end
						if ((v237 == 4) or (4439 <= 2350)) then
							if (v30 or (4479 < 4466)) then
								return v30;
							end
							break;
						end
						if ((2547 > 1225) and (v237 == 3)) then
							if ((4671 > 2674) and (v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v87.HotStreakBuff)) then
								if (v22(v89.StopCasting, not v15:IsSpellInRange(v87.Pyroblast)) or (3696 < 3327)) then
									return "Stop Casting";
								end
							end
							v30 = v148();
							v237 = 4;
						end
					end
				end
				break;
			end
			if ((v177 == 0) or (4542 == 2970)) then
				v149();
				v150();
				v31 = EpicSettings['Toggles']['ooc'];
				v32 = EpicSettings['Toggles']['aoe'];
				v177 = 1;
			end
			if ((252 <= 1977) and (v177 == 2)) then
				v128 = v15:GetEnemiesInSplashRange(5);
				v127 = v14:GetEnemiesInRange(40);
				if (v32 or (1436 == 3775)) then
					local v238 = 0;
					while true do
						if ((v238 == 1) or (1618 < 930)) then
							v125 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v126 = #v127;
							break;
						end
						if ((4723 > 4153) and (0 == v238)) then
							v123 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v124 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v238 = 1;
						end
					end
				else
					local v239 = 0;
					while true do
						if ((v239 == 0) or (3654 >= 4654)) then
							v123 = 1;
							v124 = 1;
							v239 = 1;
						end
						if ((951 <= 1496) and (v239 == 1)) then
							v125 = 1;
							v126 = 1;
							break;
						end
					end
				end
				if (v91.TargetIsValid() or v14:AffectingCombat() or (1736 == 571)) then
					local v240 = 0;
					while true do
						if ((v240 == 2) or (896 > 4769)) then
							v129 = v136(v127);
							v93 = not v33;
							v240 = 3;
						end
						if ((v240 == 1) or (1045 <= 1020)) then
							v121 = v120;
							if ((v121 == 11111) or (1160 <= 328)) then
								v121 = v10.FightRemains(v127, false);
							end
							v240 = 2;
						end
						if ((3808 > 2924) and (3 == v240)) then
							if ((3891 < 4919) and v93) then
								v107 = 99999;
							end
							v122 = v14:GCD();
							v240 = 4;
						end
						if ((4 == v240) or (2234 <= 1502)) then
							v116 = v14:BuffUp(v87.CombustionBuff);
							v117 = not v116;
							break;
						end
						if ((v240 == 0) or (2512 < 432)) then
							if (v14:AffectingCombat() or v67 or (1848 == 865)) then
								local v244 = 0;
								local v245;
								while true do
									if ((v244 == 1) or (4682 <= 4541)) then
										if (v30 or (3026 >= 4046)) then
											return v30;
										end
										break;
									end
									if ((2008 > 638) and (v244 == 0)) then
										v245 = v67 and v87['RemoveCurse']:IsReady() and v34;
										v30 = v91.FocusUnit(v245, v89, 20, nil, 20);
										v244 = 1;
									end
								end
							end
							v120 = v10.BossFightRemains(nil, true);
							v240 = 1;
						end
					end
				end
				v177 = 3;
			end
			if ((1775 <= 3233) and (v177 == 1)) then
				v33 = EpicSettings['Toggles']['cds'];
				Kick = EpicSettings['Toggles']['kick'];
				v34 = EpicSettings['Toggles']['dispel'];
				if (v14:IsDeadOrGhost() or (4543 == 1997)) then
					return;
				end
				v177 = 2;
			end
		end
	end
	local function v152()
		local v178 = 0;
		while true do
			if ((v178 == 0) or (3102 < 728)) then
				v92();
				v20.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(63, v151, v152);
end;
return v0["Epix_Mage_Fire.lua"]();

