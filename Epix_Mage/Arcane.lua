local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (3770 == 3637)) then
			v6 = v0[v4];
			if (not v6 or (2379 > 4578)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (483 > 743)) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Arcane.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = v10['Unit'];
	local v12 = v10['Utils'];
	local v13 = v11['Player'];
	local v14 = v11['Target'];
	local v15 = v10['Spell'];
	local v16 = v10['Item'];
	local v17 = EpicLib;
	local v18 = v17['Cast'];
	local v19 = v17['Press'];
	local v20 = v17['Macro'];
	local v21 = v17['Bind'];
	local v22 = v17['Commons']['Everyone']['num'];
	local v23 = v17['Commons']['Everyone']['bool'];
	local v24 = GetItemCount;
	local v25;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31;
	local v32;
	local v33;
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
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91 = v15['Mage']['Arcane'];
	local v92 = v16['Mage']['Arcane'];
	local v93 = v20['Mage']['Arcane'];
	local v94 = {};
	local v95 = v17['Commons']['Everyone'];
	local function v96()
		if ((2454 > 578) and v91['RemoveCurse']:IsAvailable()) then
			v95['DispellableDebuffs'] = v95['DispellableCurseDebuffs'];
		end
	end
	v10:RegisterForEvent(function()
		v96();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v91['ArcaneBlast']:RegisterInFlight();
	v91['ArcaneBarrage']:RegisterInFlight();
	local v97, v98;
	local v99, v100;
	local v101 = 3;
	local v102 = false;
	local v103 = false;
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = v13:HasTier(29, 4);
	local v108 = 225000 - ((25000 * v22(not v91['ArcaneHarmony']:IsAvailable())) + (200000 * v22(not v107)));
	local v109 = 3;
	local v110 = 11111;
	local v111 = 11111;
	local v112;
	v10:RegisterForEvent(function()
		local v130 = 0;
		while true do
			if ((930 < 4458) and (1 == v130)) then
				v108 = 225000 - ((25000 * v22(not v91['ArcaneHarmony']:IsAvailable())) + (200000 * v22(not v107)));
				v110 = 11111;
				v130 = 2;
			end
			if ((662 <= 972) and (v130 == 0)) then
				v102 = false;
				v105 = true;
				v130 = 1;
			end
			if ((4370 == 4370) and (v130 == 2)) then
				v111 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v107 = not v13:HasTier(29, 4);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v113()
		local v131 = 0;
		while true do
			if ((v131 == 4) or (4762 <= 861)) then
				if ((v81 and (v13:HealthPercentage() <= v83)) or (1412 == 4264)) then
					local v205 = 0;
					while true do
						if ((v205 == 0) or (3168 < 2153)) then
							if ((v85 == "Refreshing Healing Potion") or (4976 < 1332)) then
								if ((4628 == 4628) and v92['RefreshingHealingPotion']:IsReady()) then
									if (v19(v93.RefreshingHealingPotion) or (54 == 395)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((82 == 82) and (v85 == "Dreamwalker's Healing Potion")) then
								if (v92['DreamwalkersHealingPotion']:IsReady() or (581 < 282)) then
									if (v19(v93.RefreshingHealingPotion) or (4609 < 2495)) then
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
			if ((1152 == 1152) and (v131 == 1)) then
				if ((1896 <= 3422) and v91['IceBlock']:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) then
					if (v19(v91.IceBlock) or (990 > 1620)) then
						return "ice_block defensive 3";
					end
				end
				if ((v91['IceColdTalent']:IsAvailable() and v91['IceColdAbility']:IsCastable() and v59 and (v13:HealthPercentage() <= v66)) or (877 > 4695)) then
					if ((2691 >= 1851) and v19(v91.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v131 = 2;
			end
			if ((v131 == 2) or (2985 >= 4856)) then
				if ((4276 >= 1195) and v91['MirrorImage']:IsCastable() and v61 and (v13:HealthPercentage() <= v67)) then
					if ((3232 <= 4690) and v19(v91.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v91['GreaterInvisibility']:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or (896 >= 3146)) then
					if ((3061 >= 2958) and v19(v91.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v131 = 3;
			end
			if ((3187 >= 644) and (v131 == 3)) then
				if ((644 <= 704) and v91['AlterTime']:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
					if ((958 > 947) and v19(v91.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((4492 >= 2654) and v92['Healthstone']:IsReady() and v82 and (v13:HealthPercentage() <= v84)) then
					if ((3442 >= 1503) and v19(v93.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v131 = 4;
			end
			if ((v131 == 0) or (3170 <= 1464)) then
				if ((v91['PrismaticBarrier']:IsCastable() and v56 and v13:BuffDown(v91.PrismaticBarrier) and (v13:HealthPercentage() <= v63)) or (4797 == 4388)) then
					if ((551 <= 681) and v19(v91.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((3277 > 407) and v91['MassBarrier']:IsCastable() and v60 and v13:BuffDown(v91.PrismaticBarrier) and v95.AreUnitsBelowHealthPercentage(v68, 2)) then
					if ((4695 >= 1415) and v19(v91.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v131 = 1;
			end
		end
	end
	local function v114()
		if ((v91['RemoveCurse']:IsReady() and v30 and v95.DispellableFriendlyUnit(20)) or (3212 <= 944)) then
			if (v19(v93.RemoveCurseFocus) or (3096 <= 1798)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v115()
		local v132 = 0;
		while true do
			if ((3537 == 3537) and (v132 == 1)) then
				v25 = v95.HandleBottomTrinket(v94, v28, 40, nil);
				if ((3837 >= 1570) and v25) then
					return v25;
				end
				break;
			end
			if ((0 == v132) or (2950 == 3812)) then
				v25 = v95.HandleTopTrinket(v94, v28, 40, nil);
				if ((4723 >= 2318) and v25) then
					return v25;
				end
				v132 = 1;
			end
		end
	end
	local function v116()
		local v133 = 0;
		while true do
			if ((v133 == 2) or (2027 > 2852)) then
				if ((v91['ArcaneBlast']:IsReady() and v31) or (1136 > 4317)) then
					if ((4748 == 4748) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if ((3736 <= 4740) and (1 == v133)) then
				if ((v91['Evocation']:IsReady() and v39 and (v91['SiphonStorm']:IsAvailable())) or (3390 <= 3060)) then
					if (v19(v91.Evocation) or (999 > 2693)) then
						return "evocation precombat 6";
					end
				end
				if ((463 < 601) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (2183 < 687)) then
						return "arcane_orb precombat 8";
					end
				end
				v133 = 2;
			end
			if ((4549 == 4549) and (v133 == 0)) then
				if ((4672 == 4672) and v91['MirrorImage']:IsCastable() and v88 and v61) then
					if (v19(v91.MirrorImage) or (3668 < 395)) then
						return "mirror_image precombat 2";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and not v91['SiphonStorm']:IsAvailable()) or (4166 == 455)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (4449 == 2663)) then
						return "arcane_blast precombat 4";
					end
				end
				v133 = 1;
			end
		end
	end
	local function v117()
		local v134 = 0;
		while true do
			if ((v134 == 0) or (4277 < 2989)) then
				if ((((v98 >= v101) or (v99 >= v101)) and ((v91['ArcaneOrb']:Charges() > 0) or (v13:ArcaneCharges() >= 3)) and v91['RadiantSpark']:CooldownUp() and (v91['TouchoftheMagi']:CooldownRemains() <= (v112 * 2))) or (870 >= 4149)) then
					v103 = true;
				elseif ((2212 < 3183) and v103 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < 7) and v91['RadiantSpark']:CooldownDown()) then
					v103 = false;
				end
				if ((4646 > 2992) and (v13:ArcaneCharges() > 3) and ((v98 < v101) or (v99 < v101)) and v91['RadiantSpark']:CooldownUp() and (v91['TouchoftheMagi']:CooldownRemains() <= (v112 * 7)) and ((v91['ArcaneSurge']:CooldownRemains() <= (v112 * 5)) or (v91['ArcaneSurge']:CooldownRemains() > 40))) then
					v104 = true;
				elseif ((1434 < 3106) and v104 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < 7) and v91['RadiantSpark']:CooldownDown()) then
					v104 = false;
				end
				v134 = 1;
			end
			if ((786 < 3023) and (v134 == 1)) then
				if ((v14:DebuffUp(v91.TouchoftheMagiDebuff) and v105) or (2442 < 74)) then
					v105 = false;
				end
				v106 = v91['ArcaneBlast']:CastTime() < v112;
				break;
			end
		end
	end
	local function v118()
		local v135 = 0;
		while true do
			if ((4535 == 4535) and (v135 == 2)) then
				if ((v91['ArcaneMissiles']:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= 2) and (v91['RadiantSpark']:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and not v13:HasTier(30, 4)) or (3009 <= 2105)) then
					if ((1830 < 3669) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if ((v91['ArcaneMissiles']:IsReady() and v36 and v91['ArcaneHarmony']:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < 15) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91['RadiantSpark']:CooldownRemains() < 5))) and (v91['ArcaneSurge']:CooldownRemains() < 30)) or (1430 >= 3612)) then
					if ((2683 >= 2460) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if ((v91['ArcaneMissiles']:IsReady() and v36 and v91['RadiantSpark']:CooldownUp() and v13:BuffUp(v91.ClearcastingBuff) and v91['NetherPrecision']:IsAvailable() and (v13:BuffDown(v91.NetherPrecisionBuff) or (v13:BuffRemains(v91.NetherPrecisionBuff) < v112)) and v13:HasTier(30, 4)) or (1804 >= 3275)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (1417 > 3629)) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if ((4795 > 402) and v91['RadiantSpark']:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
					if ((4813 > 3565) and v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true)) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v135 = 3;
			end
			if ((3912 == 3912) and (v135 == 4)) then
				if ((2821 <= 4824) and v91['PresenceofMind']:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if ((1738 <= 2195) and v19(v91.PresenceofMind)) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((41 <= 3018) and v91['ArcaneBlast']:IsReady() and v31 and (v13:BuffUp(v91.PresenceofMindBuff))) then
					if ((2145 <= 4104) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				if ((2689 < 4845) and v91['ArcaneMissiles']:IsReady() and v36 and v13:BuffDown(v91.NetherPrecisionBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v14:DebuffDown(v91.RadiantSparkVulnerability) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and v13:PrevGCDP(1, v91.ArcaneBlast)))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2322 > 2622)) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31) or (4534 == 2082)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (1571 > 1867)) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v135 == 3) or (2654 >= 2996)) then
				if ((3978 > 2104) and v91['NetherTempest']:IsReady() and v41 and (v91['NetherTempest']:TimeSinceLastCast() >= 30) and (v91['ArcaneEcho']:IsAvailable())) then
					if ((2995 > 1541) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if ((3249 > 953) and v91['ArcaneSurge']:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
					if (v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge)) or (3273 > 4573)) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v13:PrevGCDP(1, v91.ArcaneSurge) or v13:PrevGCDP(1, v91.NetherTempest) or v13:PrevGCDP(1, v91.RadiantSpark))) or (3151 < 1284)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (1850 == 1529)) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				if ((821 < 2123) and v91['ArcaneBlast']:IsReady() and v31 and v14:DebuffUp(v91.RadiantSparkVulnerability) and (v14:DebuffStack(v91.RadiantSparkVulnerability) < 4)) then
					if ((902 < 2325) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				v135 = 4;
			end
			if ((858 <= 2962) and (v135 == 1)) then
				if ((v91['ArcaneBlast']:IsReady() and v31 and v91['RadiantSpark']:CooldownUp() and ((v13:ArcaneCharges() < 2) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v91['ArcaneOrb']:CooldownRemains() >= v112)))) or (3946 < 1288)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (3242 == 567)) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and (v13:ManaPercentage() > 30) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (847 >= 1263)) then
					if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2253 == 1851)) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				if ((v91['ArcaneMissiles']:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91['RadiantSpark']:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and v13:HasTier(31, 4)) or (2087 > 2372)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (4445 < 4149)) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and v105 and v91['ArcaneSurge']:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > 17) and not v13:HasTier(30, 4)) or (1818 == 85)) then
					if ((630 < 2127) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				v135 = 2;
			end
			if ((v135 == 0) or (1938 == 2514)) then
				if ((4255 >= 55) and v91['TouchoftheMagi']:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) then
					if ((2999 > 1156) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if ((2350 > 1155) and v91['RadiantSpark']:CooldownUp()) then
					v102 = v91['ArcaneSurge']:CooldownRemains() < 10;
				end
				if ((4029 <= 4853) and v91['ShiftingPower']:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91['RadiantSpark']:IsAvailable()) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40), true) or (516 > 3434)) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if ((4046 >= 3033) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and v91['RadiantSpark']:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (2719 <= 1447)) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				v135 = 1;
			end
		end
	end
	local function v119()
		local v136 = 0;
		while true do
			if ((v136 == 0) or (4134 < 3926)) then
				if ((v91['NetherTempest']:IsReady() and v41 and (v91['NetherTempest']:TimeSinceLastCast() >= 45) and v14:DebuffDown(v91.NetherTempestDebuff) and v105 and v13:BloodlustUp()) or (164 >= 2785)) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or (525 == 2109)) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((33 == 33) and v105 and v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) then
					if ((3054 <= 4015) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((1871 < 3382) and v91['ArcaneMissiles']:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91['RadiantSpark']:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and v13:HasTier(31, 4)) then
					if ((1293 <= 2166) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and v105 and v91['ArcaneSurge']:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > 15)) or (2579 < 123)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (846 >= 2368)) then
						return "arcane_blast spark_phase 6";
					end
				end
				v136 = 1;
			end
			if ((v136 == 3) or (4012 <= 3358)) then
				if ((1494 <= 3005) and v91['ArcaneBlast']:IsReady() and v31) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (3111 == 2134)) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((2355 == 2355) and v91['ArcaneBarrage']:IsReady() and v32) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (588 <= 432)) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if ((4797 >= 3895) and (2 == v136)) then
				if ((3577 == 3577) and v91['ArcaneSurge']:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111) and ((not v91['NetherTempest']:IsAvailable() and ((v13:PrevGCDP(4, v91.RadiantSpark) and not v106) or v13:PrevGCDP(5, v91.RadiantSpark))) or v13:PrevGCDP(1, v91.NetherTempest))) then
					if ((3794 > 3693) and v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and (v91['ArcaneBlast']:CastTime() >= v13:GCD()) and (v91['ArcaneBlast']:ExecuteTime() < v14:DebuffRemains(v91.RadiantSparkVulnerability)) and (not v91['ArcaneBombardment']:IsAvailable() or (v14:HealthPercentage() >= 35)) and ((v91['NetherTempest']:IsAvailable() and v13:PrevGCDP(6, v91.RadiantSpark)) or (not v91['NetherTempest']:IsAvailable() and v13:PrevGCDP(5, v91.RadiantSpark))) and not (v13:IsCasting(v91.ArcaneSurge) and (v13:CastRemains() < 0.5) and not v106)) or (1275 == 4100)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (1591 >= 3580)) then
						return "arcane_blast spark_phase 20";
					end
				end
				if ((983 <= 1808) and v91['ArcaneBarrage']:IsReady() and v32 and (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (2150 <= 1197)) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if ((3769 >= 1173) and v91['TouchoftheMagi']:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and v13:PrevGCDP(1, v91.ArcaneBarrage) and ((v91['ArcaneBarrage']:InFlight() and ((v91['ArcaneBarrage']:TravelTime() - v91['ArcaneBarrage']:TimeSinceLastCast()) <= 0.2)) or (v13:GCDRemains() <= 0.2))) then
					if ((1485 == 1485) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v136 = 3;
			end
			if ((v136 == 1) or (3315 <= 2782)) then
				if ((v91['ArcaneMissiles']:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= 2) and (v91['RadiantSpark']:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) or (876 >= 2964)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2232 > 2497)) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v91['ArcaneMissiles']:IsReady() and v36 and v91['ArcaneHarmony']:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < 15) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91['RadiantSpark']:CooldownRemains() < 5))) and (v91['ArcaneSurge']:CooldownRemains() < 30)) or (2110 <= 332)) then
					if ((3686 > 3172) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if ((v91['RadiantSpark']:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or (4474 < 820)) then
					if ((4279 >= 2882) and v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if ((v91['NetherTempest']:IsReady() and v41 and not v106 and (v91['NetherTempest']:TimeSinceLastCast() >= 15) and ((not v106 and v13:PrevGCDP(4, v91.RadiantSpark) and (v91['ArcaneSurge']:CooldownRemains() <= v91['NetherTempest']:ExecuteTime())) or v13:PrevGCDP(5, v91.RadiantSpark))) or (2029 >= 3521)) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or (2037 >= 4642)) then
						return "nether_tempest spark_phase 16";
					end
				end
				v136 = 2;
			end
		end
	end
	local function v120()
		local v137 = 0;
		while true do
			if ((1720 < 4458) and (v137 == 1)) then
				if ((v91['NetherTempest']:IsReady() and v41 and (v91['NetherTempest']:TimeSinceLastCast() >= 15) and (v91['ArcaneEcho']:IsAvailable())) or (436 > 3021)) then
					if ((713 <= 847) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if ((2154 <= 4031) and v91['ArcaneSurge']:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
					if ((4615 == 4615) and v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v91['ArcaneSurge']:CooldownRemains() < 75) and (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and not v91['OrbBarrage']:IsAvailable()) or (3790 == 500)) then
					if ((89 < 221) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((2054 >= 1421) and v91['ArcaneBarrage']:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) and (v91['ArcaneSurge']:CooldownRemains() > 75)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 1) and (v91['ArcaneSurge']:CooldownRemains() < 75) and not v91['OrbBarrage']:IsAvailable()))) then
					if ((692 < 3058) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				v137 = 2;
			end
			if ((v137 == 2) or (3254 == 1655)) then
				if ((v91['ArcaneBarrage']:IsReady() and v32 and ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 1) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 3) and ((v98 > 5) or (v99 > 5))) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4)) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v91['OrbBarrage']:IsAvailable()) or (1296 == 4910)) then
					if ((3368 == 3368) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				if ((2643 < 3815) and v91['PresenceofMind']:IsCastable() and v42) then
					if ((1913 > 493) and v19(v91.PresenceofMind)) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((4755 > 3428) and v91['ArcaneBlast']:IsReady() and v31 and ((((v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 3)) and not v91['OrbBarrage']:IsAvailable()) or (v14:DebuffUp(v91.RadiantSparkVulnerability) and v91['OrbBarrage']:IsAvailable()))) then
					if ((1381 <= 2369) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and v13:BuffUp(v91.ArcaneSurgeBuff)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 3) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91['OrbBarrage']:IsAvailable()))) or (4843 == 4084)) then
					if ((4669 > 363) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v137 == 0) or (1877 >= 3138)) then
				if ((4742 >= 3626) and v13:BuffUp(v91.PresenceofMindBuff) and v89 and (v13:PrevGCDP(1, v91.ArcaneBlast)) and (v13:CooldownRemains(v91.ArcaneSurge) > 75)) then
					if (v19(v93.CancelPOM) or (4540 == 916)) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if ((v91['TouchoftheMagi']:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) or (1156 > 4345)) then
					if ((2237 < 4249) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v91['RadiantSpark']:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or (2683 < 23)) then
					if ((697 <= 826) and v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true)) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				if ((1105 <= 1176) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v91['ArcaneOrb']:TimeSinceLastCast() >= 15) and (v13:ArcaneCharges() < 3)) then
					if ((3379 <= 3812) and v19(v91.ArcaneOrb, not v14:IsInRange(40))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				v137 = 1;
			end
		end
	end
	local function v121()
		local v138 = 0;
		while true do
			if ((3 == v138) or (788 >= 1616)) then
				if ((1854 <= 3379) and v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and ((v14:DebuffRemains(v91.TouchoftheMagiDebuff) > v91['ArcaneMissiles']:CastTime()) or not v91['PresenceofMind']:IsAvailable())) then
					if ((4549 == 4549) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31) or (3022 >= 3024)) then
					if ((4820 > 2198) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32) or (1061 >= 4891)) then
					if ((1364 <= 4473) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if ((v138 == 2) or (3595 <= 3)) then
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > 30) and (v91['TouchoftheMagi']:CooldownRemains() > 30)) or (v13:ManaPercentage() > 70)) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (4672 == 3852)) then
					if ((1559 == 1559) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v91['ArcaneMissiles']:IsCastable() and v36 and (v13:BuffStack(v91.ClearcastingBuff) > 1) and v91['ConjureManaGem']:IsAvailable() and v92['ManaGem']:CooldownUp()) or (1752 <= 788)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3907 == 177)) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((3470 > 555) and v91['ArcaneBlast']:IsReady() and v31 and (v13:BuffUp(v91.NetherPrecisionBuff))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (972 == 645)) then
						return "arcane_blast touch_phase 14";
					end
				end
				v138 = 3;
			end
			if ((3182 >= 2115) and (v138 == 1)) then
				if ((3893 < 4429) and v91['PresenceofMind']:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if (v19(v91.PresenceofMind) or (2867 < 1905)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or (1796 >= 4051)) then
					if ((1619 <= 3756) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((604 == 604) and v91['ArcaneBarrage']:IsReady() and v32 and (v13:BuffUp(v91.ArcaneHarmonyBuff) or (v91['ArcaneBombardment']:IsAvailable() and (v14:HealthPercentage() < 35))) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (4484 == 900)) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v138 = 2;
			end
			if ((0 == v138) or (4459 <= 1113)) then
				if ((3632 > 3398) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) > 9)) then
					v102 = not v102;
				end
				if ((4082 <= 4917) and v91['NetherTempest']:IsReady() and v41 and (v14:DebuffRefreshable(v91.NetherTempestDebuff) or not v14:DebuffUp(v91.NetherTempestDebuff)) and (v13:ArcaneCharges() == 4) and (v13:ManaPercentage() < 30) and (v13:SpellHaste() < 0.667) and v13:BuffDown(v91.ArcaneSurgeBuff)) then
					if ((4832 >= 1386) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((137 == 137) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v13:ArcaneCharges() < 2) and (v13:ManaPercentage() < 30) and (v13:SpellHaste() < 0.667) and v13:BuffDown(v91.ArcaneSurgeBuff)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (1570 >= 4332)) then
						return "arcane_orb touch_phase 4";
					end
				end
				v138 = 1;
			end
		end
	end
	local function v122()
		local v139 = 0;
		while true do
			if ((v139 == 0) or (4064 <= 1819)) then
				if ((v14:DebuffRemains(v91.TouchoftheMagiDebuff) > 9) or (4986 < 1574)) then
					v102 = not v102;
				end
				if ((4426 > 172) and v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff)) then
					if ((586 > 455) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v139 = 1;
			end
			if ((826 == 826) and (v139 == 2)) then
				if ((v91['ArcaneExplosion']:IsReady() and v33) or (4019 > 4441)) then
					if ((2017 < 4261) and v19(v91.ArcaneExplosion, not v14:IsInRange(30))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((4716 > 80) and (v139 == 1)) then
				if ((v91['ArcaneBarrage']:IsReady() and v32 and ((((v98 <= 4) or (v99 <= 4)) and (v13:ArcaneCharges() == 3)) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or (3507 == 3272)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (876 >= 3075)) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((4352 > 2554) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < 2)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (4406 < 4043)) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v139 = 2;
			end
		end
	end
	local function v123()
		local v140 = 0;
		while true do
			if ((v140 == 0) or (1889 >= 3383)) then
				if ((1892 <= 2734) and v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < 3) and (v13:BloodlustDown() or (v13:ManaPercentage() > 70) or (v107 and (v91['TouchoftheMagi']:CooldownRemains() > 30)))) then
					if ((1923 < 2218) and v19(v91.ArcaneOrb, not v14:IsInRange(40))) then
						return "arcane_orb rotation 2";
					end
				end
				v102 = ((v91['ArcaneSurge']:CooldownRemains() > 30) and (v91['TouchoftheMagi']:CooldownRemains() > 10)) or false;
				if ((2173 > 379) and v91['ShiftingPower']:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v107 and (not v91['Evocation']:IsAvailable() or (v91['Evocation']:CooldownRemains() > 12)) and (not v91['ArcaneSurge']:IsAvailable() or (v91['ArcaneSurge']:CooldownRemains() > 12)) and (not v91['TouchoftheMagi']:IsAvailable() or (v91['TouchoftheMagi']:CooldownRemains() > 12)) and (v111 > 15)) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40)) or (2591 == 3409)) then
						return "shifting_power rotation 4";
					end
				end
				v140 = 1;
			end
			if ((4514 > 3324) and (5 == v140)) then
				if ((v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffDown(v91.NetherPrecisionBuff) and (not v107 or not v105)) or (208 >= 4828)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (1583 > 3567)) then
						return "arcane_missiles rotation 30";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31) or (1313 == 794)) then
					if ((3174 > 2902) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((4120 <= 4260) and v91['ArcaneBarrage']:IsReady() and v32) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (883 > 4778)) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if ((v140 == 1) or (3620 >= 4891)) then
				if ((4258 > 937) and v91['ShiftingPower']:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and not v107 and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91['ArcaneSurge']:CooldownRemains() > 45) and (v111 > 15)) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40)) or (4869 < 906)) then
						return "shifting_power rotation 6";
					end
				end
				if ((v91['PresenceofMind']:IsCastable() and v42 and (v13:ArcaneCharges() < 3) and (v14:HealthPercentage() < 35) and v91['ArcaneBombardment']:IsAvailable()) or (1225 > 4228)) then
					if ((3328 > 2238) and v19(v91.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if ((3839 > 1405) and v91['ArcaneBlast']:IsReady() and v31 and v91['TimeAnomaly']:IsAvailable() and v13:BuffUp(v91.ArcaneSurgeBuff) and (v13:BuffRemains(v91.ArcaneSurgeBuff) <= 6)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (1293 <= 507)) then
						return "arcane_blast rotation 10";
					end
				end
				v140 = 2;
			end
			if ((v140 == 3) or (2896 < 805)) then
				if ((2316 == 2316) and v91['NetherTempest']:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v91.TemporalWarpBuff) or (v13:ManaPercentage() < 10) or not v91['ShiftingPower']:IsAvailable()) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v111 >= 12)) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or (2570 == 1533)) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 50) and not v91['Evocation']:IsAvailable() and (v111 > 20)) or (883 == 1460)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (4619 <= 999)) then
						return "arcane_barrage rotation 18";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 70) and v102 and v13:BloodlustUp() and (v91['TouchoftheMagi']:CooldownRemains() > 5) and (v111 > 20)) or (3410 > 4116)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (903 >= 3059)) then
						return "arcane_barrage rotation 20";
					end
				end
				v140 = 4;
			end
			if ((v140 == 4) or (3976 < 2857)) then
				if ((4930 > 2307) and v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffUp(v91.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (4046 < 1291)) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v91['ArcaneBlast']:IsReady() and v31 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v91.NetherPrecisionBuff)) or (4241 == 3545)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (4048 > 4232)) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 60) and v102 and (v91['TouchoftheMagi']:CooldownRemains() > 10) and (v91['Evocation']:CooldownRemains() > 40) and (v111 > 20)) or (1750 >= 3473)) then
					if ((3166 == 3166) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage rotation 26";
					end
				end
				v140 = 5;
			end
			if ((1763 < 3724) and (v140 == 2)) then
				if ((57 <= 2723) and v91['ArcaneBlast']:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v14:HealthPercentage() < 35) and v91['ArcaneBombardment']:IsAvailable() and (v13:ArcaneCharges() < 3)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (2070 == 443)) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > 30) and (v91['TouchoftheMagi']:CooldownRemains() > 30)) or (v13:ManaPercentage() > 70)) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (2705 == 1393)) then
					if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (4601 < 61)) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if ((v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) == v109)) or (1390 >= 4744)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2003 > 3834)) then
						return "arcane_missiles rotation 14";
					end
				end
				v140 = 3;
			end
		end
	end
	local function v124()
		local v141 = 0;
		while true do
			if ((v141 == 3) or (156 > 3913)) then
				if ((195 == 195) and v91['ArcaneExplosion']:IsReady() and v33) then
					if ((3105 >= 1796) and v19(v91.ArcaneExplosion, not v14:IsInRange(30))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if ((4379 >= 2131) and (0 == v141)) then
				if ((3844 >= 2043) and v91['ShiftingPower']:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and (not v91['Evocation']:IsAvailable() or (v91['Evocation']:CooldownRemains() > 12)) and (not v91['ArcaneSurge']:IsAvailable() or (v91['ArcaneSurge']:CooldownRemains() > 12)) and (not v91['TouchoftheMagi']:IsAvailable() or (v91['TouchoftheMagi']:CooldownRemains() > 12)) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((not v91['ChargedOrb']:IsAvailable() and (v91['ArcaneOrb']:CooldownRemains() > 12)) or (v91['ArcaneOrb']:Charges() == 0) or (v91['ArcaneOrb']:CooldownRemains() > 12))) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40), true) or (3232 <= 2731)) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((4905 == 4905) and v91['NetherTempest']:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((v98 > 6) or (v99 > 6) or not v91['OrbBarrage']:IsAvailable())) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or (4136 >= 4411)) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v141 = 1;
			end
			if ((v141 == 1) or (2958 == 4017)) then
				if ((1228 >= 813) and v91['ArcaneMissiles']:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v91['TouchoftheMagi']:CooldownRemains() > (v13:BuffRemains(v91.ArcaneArtilleryBuff) + 5))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3455 > 4050)) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((243 == 243) and v91['ArcaneBarrage']:IsReady() and v32 and ((v98 <= 4) or (v99 <= 4) or v13:BuffUp(v91.ClearcastingBuff)) and (v13:ArcaneCharges() == 3)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (271 > 1572)) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v141 = 2;
			end
			if ((2739 < 3293) and (v141 == 2)) then
				if ((v91['ArcaneOrb']:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() == 0) and (v91['TouchoftheMagi']:CooldownRemains() > 18)) or (3942 < 1134)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (2693 == 4973)) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if ((2146 == 2146) and v91['ArcaneBarrage']:IsReady() and v32 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < 10))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (2244 == 3224)) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v141 = 3;
			end
		end
	end
	local function v125()
		local v142 = 0;
		local v143;
		while true do
			if ((v142 == 3) or (4904 <= 1916)) then
				if ((90 <= 1065) and v28 and v91['RadiantSpark']:IsAvailable() and v103) then
					local v206 = 0;
					local v207;
					while true do
						if ((4802 == 4802) and (v206 == 0)) then
							v207 = v120();
							if (v207 or (2280 <= 511)) then
								return v207;
							end
							break;
						end
					end
				end
				if ((v28 and v107 and v91['RadiantSpark']:IsAvailable() and v104) or (1676 <= 463)) then
					local v208 = 0;
					local v209;
					while true do
						if ((3869 == 3869) and (v208 == 0)) then
							v209 = v119();
							if ((1158 <= 2613) and v209) then
								return v209;
							end
							break;
						end
					end
				end
				if ((v28 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 >= v101) or (v99 >= v101))) or (2364 <= 1999)) then
					local v210 = 0;
					local v211;
					while true do
						if ((v210 == 0) or (4922 < 194)) then
							v211 = v122();
							if (v211 or (2091 < 31)) then
								return v211;
							end
							break;
						end
					end
				end
				v142 = 4;
			end
			if ((v142 == 4) or (2430 >= 4872)) then
				if ((v28 and v107 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 < v101) or (v99 < v101))) or (4770 < 1735)) then
					local v212 = 0;
					local v213;
					while true do
						if ((v212 == 0) or (4439 <= 2350)) then
							v213 = v121();
							if (v213 or (4479 < 4466)) then
								return v213;
							end
							break;
						end
					end
				end
				if ((2547 > 1225) and ((v98 >= v101) or (v99 >= v101))) then
					local v214 = 0;
					local v215;
					while true do
						if ((4671 > 2674) and (0 == v214)) then
							v215 = v124();
							if (v215 or (3696 < 3327)) then
								return v215;
							end
							break;
						end
					end
				end
				v143 = v123();
				v142 = 5;
			end
			if ((v142 == 0) or (4542 == 2970)) then
				if ((252 <= 1977) and v91['TouchoftheMagi']:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) then
					if (v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi)) or (1436 == 3775)) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v13:IsChanneling(v91.Evocation) and (((v13:ManaPercentage() >= 95) and not v91['SiphonStorm']:IsAvailable()) or ((v13:ManaPercentage() > (v111 * 4)) and not ((v111 > 10) and (v91['ArcaneSurge']:CooldownRemains() < 1))))) or (1618 < 930)) then
					if ((4723 > 4153) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v91['ArcaneBarrage']:IsReady() and v32 and (v111 < 2)) or (3654 >= 4654)) then
					if ((951 <= 1496) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage main 34";
					end
				end
				v142 = 1;
			end
			if ((v142 == 2) or (1736 == 571)) then
				if ((v92['ManaGem']:IsReady() and v40 and not v91['CascadingPower']:IsAvailable() and v13:PrevGCDP(1, v91.ArcaneSurge) and (not v106 or (v106 and v13:PrevGCDP(2, v91.ArcaneSurge)))) or (896 > 4769)) then
					if (v19(v93.ManaGem) or (1045 <= 1020)) then
						return "mana_gem main 42";
					end
				end
				if ((not v107 and ((v91['ArcaneSurge']:CooldownRemains() <= (v112 * (1 + v22(v91['NetherTempest']:IsAvailable() and v91['ArcaneEcho']:IsAvailable())))) or (v13:BuffRemains(v91.ArcaneSurgeBuff) > (3 * v22(v13:HasTier(30, 2) and not v13:HasTier(30, 4)))) or v13:BuffUp(v91.ArcaneOverloadBuff)) and (v91['Evocation']:CooldownRemains() > 45) and ((v91['TouchoftheMagi']:CooldownRemains() < (v112 * 4)) or (v91['TouchoftheMagi']:CooldownRemains() > 20)) and ((v98 < v101) or (v99 < v101))) or (1160 <= 328)) then
					local v216 = 0;
					local v217;
					while true do
						if ((3808 > 2924) and (v216 == 0)) then
							v217 = v118();
							if ((3891 < 4919) and v217) then
								return v217;
							end
							break;
						end
					end
				end
				if ((not v107 and (v91['ArcaneSurge']:CooldownRemains() > 30) and (v91['RadiantSpark']:CooldownUp() or v14:DebuffUp(v91.RadiantSparkDebuff) or v14:DebuffUp(v91.RadiantSparkVulnerability)) and ((v91['TouchoftheMagi']:CooldownRemains() <= (v112 * 3)) or v14:DebuffUp(v91.TouchoftheMagiDebuff)) and ((v98 < v101) or (v99 < v101))) or (2234 <= 1502)) then
					local v218 = 0;
					local v219;
					while true do
						if ((v218 == 0) or (2512 < 432)) then
							v219 = v118();
							if (v219 or (1848 == 865)) then
								return v219;
							end
							break;
						end
					end
				end
				v142 = 3;
			end
			if ((v142 == 5) or (4682 <= 4541)) then
				if (v143 or (3026 >= 4046)) then
					return v143;
				end
				break;
			end
			if ((2008 > 638) and (v142 == 1)) then
				if ((1775 <= 3233) and v91['Evocation']:IsCastable() and v39 and not v105 and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < 10) and (v91['TouchoftheMagi']:CooldownRemains() < 20)) or (v91['TouchoftheMagi']:CooldownRemains() < 15)) and (v13:ManaPercentage() < (v111 * 4))) then
					if (v19(v91.Evocation) or (4543 == 1997)) then
						return "evocation main 36";
					end
				end
				if ((v91['ConjureManaGem']:IsCastable() and v37 and v14:DebuffDown(v91.TouchoftheMagiDebuff) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91['ArcaneSurge']:CooldownRemains() < 30) and (v91['ArcaneSurge']:CooldownRemains() < v111) and not v92['ManaGem']:Exists()) or (3102 < 728)) then
					if ((345 == 345) and v19(v91.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v92['ManaGem']:IsReady() and v40 and v91['CascadingPower']:IsAvailable() and (v13:BuffStack(v91.ClearcastingBuff) < 2) and v13:BuffUp(v91.ArcaneSurgeBuff)) or (2827 < 378)) then
					if (v19(v93.ManaGem) or (3476 < 2597)) then
						return "mana_gem main 40";
					end
				end
				v142 = 2;
			end
		end
	end
	local function v126()
		local v144 = 0;
		while true do
			if ((3079 < 4794) and (v144 == 6)) then
				v54 = EpicSettings['Settings']['touchOfTheMagiWithMiniCD'];
				v55 = EpicSettings['Settings']['useAlterTime'];
				v56 = EpicSettings['Settings']['usePrismaticBarrier'];
				v57 = EpicSettings['Settings']['useGreaterInvisibility'];
				v144 = 7;
			end
			if ((4854 > 4464) and (5 == v144)) then
				v50 = EpicSettings['Settings']['arcaneSurgeWithCD'];
				v51 = EpicSettings['Settings']['shiftingPowerWithCD'];
				v52 = EpicSettings['Settings']['arcaneOrbWithMiniCD'];
				v53 = EpicSettings['Settings']['radiantSparkWithMiniCD'];
				v144 = 6;
			end
			if ((v144 == 3) or (4912 == 3758)) then
				v43 = EpicSettings['Settings']['useCounterspell'];
				v44 = EpicSettings['Settings']['useBlastWave'];
				v38 = EpicSettings['Settings']['useDragonsBreath'];
				v45 = EpicSettings['Settings']['useArcaneSurge'];
				v144 = 4;
			end
			if ((126 <= 3482) and (v144 == 1)) then
				v35 = EpicSettings['Settings']['useArcaneIntellect'];
				v36 = EpicSettings['Settings']['useArcaneMissiles'];
				v37 = EpicSettings['Settings']['useConjureManaGem'];
				v39 = EpicSettings['Settings']['useEvocation'];
				v144 = 2;
			end
			if ((10 == v144) or (2374 == 4374)) then
				v87 = EpicSettings['Settings']['useTimeWarpWithTalent'];
				v88 = EpicSettings['Settings']['mirrorImageBeforePull'];
				v90 = EpicSettings['Settings']['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((1575 == 1575) and (v144 == 9)) then
				v66 = EpicSettings['Settings']['iceColdHP'] or 0;
				v67 = EpicSettings['Settings']['mirrorImageHP'] or 0;
				v68 = EpicSettings['Settings']['massBarrierHP'] or 0;
				v86 = EpicSettings['Settings']['useSpellStealTarget'];
				v144 = 10;
			end
			if ((v144 == 0) or (2234 == 1455)) then
				v31 = EpicSettings['Settings']['useArcaneBlast'];
				v32 = EpicSettings['Settings']['useArcaneBarrage'];
				v33 = EpicSettings['Settings']['useArcaneExplosion'];
				v34 = EpicSettings['Settings']['useArcaneFamiliar'];
				v144 = 1;
			end
			if ((v144 == 7) or (1067 > 1779)) then
				v58 = EpicSettings['Settings']['useIceBlock'];
				v59 = EpicSettings['Settings']['useIceCold'];
				v60 = EpicSettings['Settings']['useMassBarrier'];
				v61 = EpicSettings['Settings']['useMirrorImage'];
				v144 = 8;
			end
			if ((2161 >= 934) and (v144 == 8)) then
				v62 = EpicSettings['Settings']['alterTimeHP'] or 0;
				v63 = EpicSettings['Settings']['prismaticBarrierHP'] or 0;
				v64 = EpicSettings['Settings']['greaterInvisibilityHP'] or 0;
				v65 = EpicSettings['Settings']['iceBlockHP'] or 0;
				v144 = 9;
			end
			if ((1612 == 1612) and (v144 == 2)) then
				v40 = EpicSettings['Settings']['useManaGem'];
				v41 = EpicSettings['Settings']['useNetherTempest'];
				v42 = EpicSettings['Settings']['usePresenceOfMind'];
				v89 = EpicSettings['Settings']['cancelPOM'];
				v144 = 3;
			end
			if ((4352 >= 2833) and (v144 == 4)) then
				v46 = EpicSettings['Settings']['useShiftingPower'];
				v47 = EpicSettings['Settings']['useArcaneOrb'];
				v48 = EpicSettings['Settings']['useRadiantSpark'];
				v49 = EpicSettings['Settings']['useTouchOfTheMagi'];
				v144 = 5;
			end
		end
	end
	local function v127()
		local v145 = 0;
		while true do
			if ((v145 == 2) or (3222 < 3073)) then
				v78 = EpicSettings['Settings']['useTrinkets'];
				v77 = EpicSettings['Settings']['useRacials'];
				v79 = EpicSettings['Settings']['trinketsWithCD'];
				v145 = 3;
			end
			if ((744 <= 2942) and (0 == v145)) then
				v76 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v73 = EpicSettings['Settings']['InterruptWithStun'];
				v74 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v145 = 1;
			end
			if ((v145 == 1) or (1833 <= 1322)) then
				v75 = EpicSettings['Settings']['InterruptThreshold'];
				v70 = EpicSettings['Settings']['DispelDebuffs'];
				v69 = EpicSettings['Settings']['DispelBuffs'];
				v145 = 2;
			end
			if ((v145 == 3) or (3467 <= 1055)) then
				v80 = EpicSettings['Settings']['racialsWithCD'];
				v82 = EpicSettings['Settings']['useHealthstone'];
				v81 = EpicSettings['Settings']['useHealingPotion'];
				v145 = 4;
			end
			if ((3541 == 3541) and (v145 == 5)) then
				v71 = EpicSettings['Settings']['handleAfflicted'];
				v72 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((v145 == 4) or (3557 >= 4003)) then
				v84 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v83 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v85 = EpicSettings['Settings']['HealingPotionName'] or "";
				v145 = 5;
			end
		end
	end
	local function v128()
		local v146 = 0;
		while true do
			if ((v146 == 0) or (657 >= 1668)) then
				v126();
				v127();
				v26 = EpicSettings['Toggles']['ooc'];
				v146 = 1;
			end
			if ((v146 == 1) or (1027 > 3858)) then
				v27 = EpicSettings['Toggles']['aoe'];
				v28 = EpicSettings['Toggles']['cds'];
				v29 = EpicSettings['Toggles']['minicds'];
				v146 = 2;
			end
			if ((3 == v146) or (3654 < 450)) then
				v100 = v13:GetEnemiesInRange(40);
				if ((1891 < 4453) and v27) then
					local v220 = 0;
					while true do
						if ((v220 == 0) or (3140 < 2129)) then
							v98 = max(v14:GetEnemiesInSplashRangeCount(5), #v100);
							v99 = #v100;
							break;
						end
					end
				else
					local v221 = 0;
					while true do
						if ((0 == v221) or (2555 < 1240)) then
							v98 = 1;
							v99 = 1;
							break;
						end
					end
				end
				if (v95.TargetIsValid() or v13:AffectingCombat() or (4727 <= 4722)) then
					local v222 = 0;
					while true do
						if ((740 < 4937) and (v222 == 1)) then
							v111 = v110;
							if ((3658 >= 280) and (v111 == 11111)) then
								v111 = v10.FightRemains(v100, false);
							end
							break;
						end
						if ((v222 == 0) or (885 >= 1031)) then
							if ((3554 >= 525) and (v13:AffectingCombat() or v70)) then
								local v226 = 0;
								local v227;
								while true do
									if ((2414 <= 2972) and (v226 == 0)) then
										v227 = v70 and v91['RemoveCurse']:IsReady() and v30;
										v25 = v95.FocusUnit(v227, v93, 20, nil, 20);
										v226 = 1;
									end
									if ((3529 <= 3538) and (v226 == 1)) then
										if (v25 or (2861 < 458)) then
											return v25;
										end
										break;
									end
								end
							end
							v110 = v10.BossFightRemains(nil, true);
							v222 = 1;
						end
					end
				end
				v146 = 4;
			end
			if ((1717 <= 4525) and (4 == v146)) then
				v112 = v13:GCD();
				if (v71 or (3178 <= 1524)) then
					if ((4254 > 370) and v90) then
						local v225 = 0;
						while true do
							if ((v225 == 0) or (1635 == 1777)) then
								v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 30);
								if (v25 or (3338 >= 3993)) then
									return v25;
								end
								break;
							end
						end
					end
				end
				if ((1154 <= 1475) and not v13:AffectingCombat()) then
					local v223 = 0;
					while true do
						if ((v223 == 1) or (2610 < 1230)) then
							if ((v91['ConjureManaGem']:IsCastable() and v37) or (1448 == 3083)) then
								if ((3139 > 916) and v19(v91.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
						if ((2954 == 2954) and (v223 == 0)) then
							if ((117 <= 2892) and v91['ArcaneIntellect']:IsCastable() and v35 and (v13:BuffDown(v91.ArcaneIntellect, true) or v95.GroupBuffMissing(v91.ArcaneIntellect))) then
								if (v19(v91.ArcaneIntellect) or (453 > 4662)) then
									return "arcane_intellect group_buff";
								end
							end
							if ((1320 > 595) and v91['ArcaneFamiliar']:IsReady() and v34 and v13:BuffDown(v91.ArcaneFamiliarBuff)) then
								if (v19(v91.ArcaneFamiliar) or (3199 < 590)) then
									return "arcane_familiar precombat 2";
								end
							end
							v223 = 1;
						end
					end
				end
				v146 = 5;
			end
			if ((v146 == 5) or (4793 < 30)) then
				if (v95.TargetIsValid() or (1696 <= 1059)) then
					local v224 = 0;
					while true do
						if ((2343 == 2343) and (v224 == 0)) then
							if (Focus or (1043 > 3591)) then
								if (v70 or (2890 >= 4079)) then
									local v232 = 0;
									while true do
										if ((4474 <= 4770) and (v232 == 0)) then
											v25 = v114();
											if (v25 or (4942 == 3903)) then
												return v25;
											end
											break;
										end
									end
								end
							end
							if ((not v13:AffectingCombat() and v26) or (248 > 4845)) then
								local v228 = 0;
								while true do
									if ((1569 == 1569) and (v228 == 0)) then
										v25 = v116();
										if (v25 or (4927 <= 3221)) then
											return v25;
										end
										break;
									end
								end
							end
							v224 = 1;
						end
						if ((v224 == 1) or (1780 > 2787)) then
							v25 = v113();
							if (v25 or (3937 <= 1230)) then
								return v25;
							end
							v224 = 2;
						end
						if ((v224 == 2) or (2637 < 1706)) then
							if (v71 or (2669 <= 2409)) then
								if (v90 or (1401 > 4696)) then
									local v233 = 0;
									while true do
										if ((0 == v233) or (3280 < 1321)) then
											v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 30);
											if ((4927 >= 2303) and v25) then
												return v25;
											end
											break;
										end
									end
								end
							end
							if ((3462 >= 1032) and v72) then
								local v229 = 0;
								while true do
									if ((v229 == 0) or (1077 >= 2011)) then
										v25 = v95.HandleIncorporeal(v91.Polymorph, v93.PolymorphMouseOver, 30, true);
										if ((1543 < 2415) and v25) then
											return v25;
										end
										break;
									end
								end
							end
							v224 = 3;
						end
						if ((v224 == 3) or (4444 < 2015)) then
							if ((v91['Spellsteal']:IsAvailable() and v86 and v91['Spellsteal']:IsReady() and v30 and v69 and not v13:IsCasting() and not v13:IsChanneling() and v95.UnitHasMagicBuff(v14)) or (4200 == 2332)) then
								if (v19(v91.Spellsteal, not v14:IsSpellInRange(v91.Spellsteal)) or (1278 >= 1316)) then
									return "spellsteal damage";
								end
							end
							if ((1082 == 1082) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v95.TargetIsValid()) then
								local v230 = 0;
								local v231;
								while true do
									if ((1328 <= 4878) and (v230 == 2)) then
										if ((4087 >= 1355) and (v76 < v111)) then
											if ((v78 and ((v28 and v79) or not v79)) or (590 > 4650)) then
												local v235 = 0;
												while true do
													if ((0 == v235) or (3774 <= 3667)) then
														v25 = v115();
														if ((1270 < 2146) and v25) then
															return v25;
														end
														break;
													end
												end
											end
										end
										v25 = v117();
										v230 = 3;
									end
									if ((4563 >= 56) and (4 == v230)) then
										if (v25 or (446 == 622)) then
											return v25;
										end
										break;
									end
									if ((2069 > 1009) and (v230 == 3)) then
										if ((12 < 4208) and v25) then
											return v25;
										end
										v25 = v125();
										v230 = 4;
									end
									if ((v230 == 1) or (2990 <= 2980)) then
										if ((v87 and v91['TimeWarp']:IsReady() and v91['TemporalWarp']:IsAvailable() and v13:BloodlustExhaustUp() and (v91['ArcaneSurge']:CooldownUp() or (v111 <= 40) or (v13:BuffUp(v91.ArcaneSurgeBuff) and (v111 <= (v91['ArcaneSurge']:CooldownRemains() + 14))))) or (2575 >= 4275)) then
											if (v19(v91.TimeWarp, not v14:IsInRange(40)) or (3626 <= 1306)) then
												return "time_warp main 4";
											end
										end
										if ((1368 < 3780) and v77 and ((v80 and v28) or not v80) and (v76 < v111)) then
											local v234 = 0;
											while true do
												if ((1 == v234) or (3169 == 2273)) then
													if ((2481 <= 3279) and v13:PrevGCDP(1, v91.ArcaneSurge)) then
														local v236 = 0;
														while true do
															if ((v236 == 1) or (1063 <= 877)) then
																if ((2314 == 2314) and v91['AncestralCall']:IsCastable()) then
																	if ((924 >= 477) and v19(v91.AncestralCall)) then
																		return "ancestral_call main 14";
																	end
																end
																break;
															end
															if ((1813 <= 3778) and (v236 == 0)) then
																if ((4150 == 4150) and v91['BloodFury']:IsCastable()) then
																	if ((432 <= 3007) and v19(v91.BloodFury)) then
																		return "blood_fury main 10";
																	end
																end
																if (v91['Fireblood']:IsCastable() or (408 > 2721)) then
																	if (v19(v91.Fireblood) or (3418 < 2497)) then
																		return "fireblood main 12";
																	end
																end
																v236 = 1;
															end
														end
													end
													break;
												end
												if ((1735 < 2169) and (0 == v234)) then
													if ((3890 >= 3262) and v91['LightsJudgment']:IsCastable() and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and ((v98 >= 2) or (v99 >= 2))) then
														if (v19(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment)) or (4356 >= 4649)) then
															return "lights_judgment main 6";
														end
													end
													if ((3904 == 3904) and v91['Berserking']:IsCastable() and ((v13:PrevGCDP(1, v91.ArcaneSurge) and not (v13:BuffUp(v91.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v91.ArcaneSurgeBuff) and v14:DebuffUp(v91.TouchoftheMagiDebuff)))) then
														if (v19(v91.Berserking) or (2860 >= 3789)) then
															return "berserking main 8";
														end
													end
													v234 = 1;
												end
											end
										end
										v230 = 2;
									end
									if ((v230 == 0) or (1086 > 4449)) then
										v231 = v95.HandleDPSPotion(not v91['ArcaneSurge']:IsReady());
										if ((4981 > 546) and v231) then
											return v231;
										end
										v230 = 1;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v146 == 2) or (2366 <= 8)) then
				v30 = EpicSettings['Toggles']['dispel'];
				if (v13:IsDeadOrGhost() or (2590 == 2864)) then
					return;
				end
				v97 = v14:GetEnemiesInSplashRange(5);
				v146 = 3;
			end
		end
	end
	local function v129()
		local v147 = 0;
		while true do
			if ((v147 == 0) or (2624 > 4149)) then
				v96();
				v17.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v17.SetAPL(62, v128, v129);
end;
return v0["Epix_Mage_Arcane.lua"]();

