local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (3791 <= 1611)) then
			v6 = v0[v4];
			if (not v6 or (4578 <= 2008)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1125 <= 2076) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_Shaman_Elemental.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['MouseOver'];
	local v16 = v12['Pet'];
	local v17 = v12['Target'];
	local v18 = v10['Spell'];
	local v19 = v10['MultiSpell'];
	local v20 = v10['Item'];
	local v21 = EpicLib;
	local v22 = v21['Cast'];
	local v23 = v21['Macro'];
	local v24 = v21['Press'];
	local v25 = v21['Commons']['Everyone']['num'];
	local v26 = v21['Commons']['Everyone']['bool'];
	local v27 = GetTimelocal;
	local v28 = GetWeaponEnchantInfo;
	local v29;
	local v30 = false;
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
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98 = v18['Shaman']['Elemental'];
	local v99 = v20['Shaman']['Elemental'];
	local v100 = v23['Shaman']['Elemental'];
	local v101 = {};
	local v102 = v21['Commons']['Everyone'];
	local function v103()
		if (v98['CleanseSpirit']:IsAvailable() or (743 >= 4399)) then
			v102['DispellableDebuffs'] = v102['DispellableCurseDebuffs'];
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v137 = 0;
		while true do
			if ((1155 < 1673) and (1 == v137)) then
				v98['LavaBurst']:RegisterInFlight();
				break;
			end
			if ((v137 == 0) or (2324 <= 578)) then
				v98['PrimordialWave']:RegisterInFlightEffect(327162);
				v98['PrimordialWave']:RegisterInFlight();
				v137 = 1;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v98['PrimordialWave']:RegisterInFlightEffect(327162);
	v98['PrimordialWave']:RegisterInFlight();
	v98['LavaBurst']:RegisterInFlight();
	local v104 = 11111;
	local v105 = 11111;
	local v106, v107;
	local v108, v109;
	local v110 = 0;
	local v111 = 0;
	local function v112()
		return 40 - (v27() - Shaman['LastT302pcBuff']);
	end
	local function v113(v138)
		return (v138:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v114(v139)
		return v139:DebuffRefreshable(v98.FlameShockDebuff) and (v139:DebuffRemains(v98.FlameShockDebuff) < (v139:TimeToDie() - 5));
	end
	local function v115(v140)
		return v140:DebuffRefreshable(v98.FlameShockDebuff) and (v140:DebuffRemains(v98.FlameShockDebuff) < (v140:TimeToDie() - 5)) and (v140:DebuffRemains(v98.FlameShockDebuff) > 0);
	end
	local function v116(v141)
		return (v141:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v117(v142)
		return v142:DebuffRemains(v98.FlameShockDebuff) > 2;
	end
	local function v118(v143)
		return (v143:DebuffRemains(v98.LightningRodDebuff));
	end
	local function v119()
		local v144 = 0;
		local v145;
		while true do
			if ((3767 == 3767) and (v144 == 0)) then
				v145 = v14:Maelstrom();
				if ((4089 == 4089) and not v14:IsCasting()) then
					return v145;
				elseif ((4458 >= 1674) and v14:IsCasting(v98.ElementalBlast)) then
					return v145 - 75;
				elseif ((972 <= 1418) and v14:IsCasting(v98.Icefury)) then
					return v145 + 25;
				elseif (v14:IsCasting(v98.LightningBolt) or (4938 < 4762)) then
					return v145 + 10;
				elseif (v14:IsCasting(v98.LavaBurst) or (2504 > 4264)) then
					return v145 + 12;
				elseif ((2153 == 2153) and v14:IsCasting(v98.ChainLightning)) then
					return v145 + (4 * v111);
				else
					return v145;
				end
				break;
			end
		end
	end
	local function v120()
		local v146 = 0;
		local v147;
		while true do
			if ((v146 == 0) or (507 >= 2591)) then
				if ((4481 == 4481) and not v98['MasteroftheElements']:IsAvailable()) then
					return false;
				end
				v147 = v14:BuffUp(v98.MasteroftheElementsBuff);
				v146 = 1;
			end
			if ((v146 == 1) or (2328 < 693)) then
				if ((4328 == 4328) and not v14:IsCasting()) then
					return v147;
				elseif ((1588 >= 1332) and v14:IsCasting(v98.LavaBurst)) then
					return true;
				elseif (v14:IsCasting(v98.ElementalBlast) or (4174 > 4248)) then
					return false;
				elseif (v14:IsCasting(v98.Icefury) or (4586 <= 82)) then
					return false;
				elseif ((3863 == 3863) and v14:IsCasting(v98.LightningBolt)) then
					return false;
				elseif (v14:IsCasting(v98.ChainLightning) or (282 <= 42)) then
					return false;
				else
					return v147;
				end
				break;
			end
		end
	end
	local function v121()
		local v148 = 0;
		local v149;
		while true do
			if ((4609 >= 766) and (v148 == 0)) then
				if (not v98['Stormkeeper']:IsAvailable() or (1152 == 2488)) then
					return false;
				end
				v149 = v14:BuffUp(v98.StormkeeperBuff);
				v148 = 1;
			end
			if ((3422 > 3350) and (v148 == 1)) then
				if ((877 > 376) and not v14:IsCasting()) then
					return v149;
				elseif (v14:IsCasting(v98.Stormkeeper) or (3118 <= 1851)) then
					return true;
				else
					return v149;
				end
				break;
			end
		end
	end
	local function v122()
		local v150 = 0;
		local v151;
		while true do
			if ((1 == v150) or (165 >= 3492)) then
				if ((3949 < 4856) and not v14:IsCasting()) then
					return v151;
				elseif (v14:IsCasting(v98.Icefury) or (4276 < 3016)) then
					return true;
				else
					return v151;
				end
				break;
			end
			if ((4690 > 4125) and (v150 == 0)) then
				if (not v98['Icefury']:IsAvailable() or (50 >= 896)) then
					return false;
				end
				v151 = v14:BuffUp(v98.IcefuryBuff);
				v150 = 1;
			end
		end
	end
	local function v123()
		if ((v98['CleanseSpirit']:IsReady() and v34 and v102.DispellableFriendlyUnit(25)) or (1714 >= 2958)) then
			if (v24(v100.CleanseSpiritFocus) or (1491 < 644)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v124()
		if ((704 < 987) and v96 and (v14:HealthPercentage() <= v97)) then
			if ((3718 > 1906) and v98['HealingSurge']:IsReady()) then
				if (v24(v98.HealingSurge) or (958 > 3635)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v125()
		local v152 = 0;
		while true do
			if ((3501 <= 4492) and (v152 == 1)) then
				if ((v98['HealingStreamTotem']:IsReady() and v71 and v102.AreUnitsBelowHealthPercentage(v77, v78)) or (3442 < 2548)) then
					if ((2875 >= 1464) and v24(v98.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v99['Healthstone']:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or (4797 >= 4893)) then
					if (v24(v100.Healthstone) or (551 > 2068)) then
						return "healthstone defensive 3";
					end
				end
				v152 = 2;
			end
			if ((2114 > 944) and (v152 == 0)) then
				if ((v98['AstralShift']:IsReady() and v70 and (v14:HealthPercentage() <= v76)) or (2262 >= 3096)) then
					if (v24(v98.AstralShift) or (2255 >= 3537)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v98['AncestralGuidance']:IsReady() and v69 and v102.AreUnitsBelowHealthPercentage(v74, v75)) or (3837 < 1306)) then
					if ((2950 == 2950) and v24(v98.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v152 = 1;
			end
			if ((v152 == 2) or (4723 < 3298)) then
				if ((1136 >= 154) and v90 and (v14:HealthPercentage() <= v92)) then
					local v222 = 0;
					while true do
						if ((0 == v222) or (271 > 4748)) then
							if ((4740 >= 3152) and (v94 == "Refreshing Healing Potion")) then
								if (v99['RefreshingHealingPotion']:IsReady() or (2578 >= 3390)) then
									if ((41 <= 1661) and v24(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((601 < 3560) and (v94 == "Dreamwalker's Healing Potion")) then
								if ((235 < 687) and v99['DreamwalkersHealingPotion']:IsReady()) then
									if ((4549 > 1153) and v24(v100.RefreshingHealingPotion)) then
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
	local function v126()
		local v153 = 0;
		while true do
			if ((v153 == 0) or (4674 < 4672)) then
				v29 = v102.HandleTopTrinket(v101, v32, 40, nil);
				if ((3668 < 4561) and v29) then
					return v29;
				end
				v153 = 1;
			end
			if ((v153 == 1) or (455 == 3605)) then
				v29 = v102.HandleBottomTrinket(v101, v32, 40, nil);
				if (v29 or (2663 == 3312)) then
					return v29;
				end
				break;
			end
		end
	end
	local function v127()
		local v154 = 0;
		while true do
			if ((4277 <= 4475) and (v154 == 3)) then
				if ((v14:IsCasting(v98.LavaBurst) and UseFlameShock and v98['FlameShock']:IsReady()) or (870 == 1189)) then
					if ((1553 <= 3133) and v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v98.LavaBurst) and v46 and ((v63 and v33) or not v63) and v98['PrimordialWave']:IsAvailable()) or (2237 >= 3511)) then
					if (v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave)) or (1324 > 3020)) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if ((v154 == 2) or (2992 == 1881)) then
				if ((3106 > 1526) and v14:IsCasting(v98.ElementalBlast) and UseFlameShock and not v98['PrimordialWave']:IsAvailable() and v98['FlameShock']:IsReady()) then
					if ((3023 < 3870) and v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if ((143 > 74) and v98['LavaBurst']:IsCastable() and v43 and not v14:IsCasting(v98.LavaBurst) and (not v98['ElementalBlast']:IsAvailable() or (v98['ElementalBlast']:IsAvailable() and not v98['ElementalBlast']:IsAvailable()))) then
					if ((18 < 2112) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v154 = 3;
			end
			if ((1097 <= 1628) and (v154 == 0)) then
				if ((4630 == 4630) and v98['Stormkeeper']:IsCastable() and (v98['Stormkeeper']:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105)) then
					if ((3540 > 2683) and v24(v98.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if ((4794 >= 3275) and v98['Icefury']:IsCastable() and (v98['Icefury']:CooldownRemains() == 0) and v41) then
					if ((1484 == 1484) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v154 = 1;
			end
			if ((1432 < 3555) and (v154 == 1)) then
				if ((v98['ElementalBlast']:IsCastable() and v38) or (1065 > 3578)) then
					if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or (4795 < 1407)) then
						return "elemental_blast precombat 6";
					end
				end
				if ((1853 < 4813) and v14:IsCasting(v98.ElementalBlast) and v46 and ((v63 and v33) or not v63) and v98['PrimordialWave']:IsAvailable()) then
					if (v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave)) or (2821 < 2431)) then
						return "primordial_wave precombat 8";
					end
				end
				v154 = 2;
			end
		end
	end
	local function v128()
		local v155 = 0;
		while true do
			if ((v155 == 8) or (2874 < 2181)) then
				if ((v98['FlameShock']:IsCastable() and UseFlameShock) or (2689 <= 343)) then
					if (v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock)) or (1869 == 2009)) then
						return "flame_shock moving aoe 86";
					end
				end
				if ((v98['FrostShock']:IsCastable() and v40) or (3546 < 2322)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (2082 == 4773)) then
						return "frost_shock moving aoe 88";
					end
				end
				break;
			end
			if ((3244 > 1055) and (v155 == 3)) then
				if ((v98['Earthquake']:IsReady() and v36 and (v50 == "player") and not v98['EchoesofGreatSundering']:IsAvailable() and not v98['ElementalBlast']:IsAvailable() and (v110 == 3) and (v111 == 3)) or (3313 <= 1778)) then
					if (v24(v100.EarthquakePlayer, not v17:IsInRange(40)) or (1421 >= 2104)) then
						return "earthquake aoe 38";
					end
				end
				if ((1812 <= 3249) and v98['Earthquake']:IsReady() and v36 and (v50 == "cursor") and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
					if ((1623 <= 1957) and v24(v100.EarthquakeCursor, not v17:IsInRange(40))) then
						return "earthquake aoe 40";
					end
				end
				if ((4412 == 4412) and v98['Earthquake']:IsReady() and v36 and (v50 == "player") and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
					if ((1750 >= 842) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return "earthquake aoe 40";
					end
				end
				if ((4372 > 1850) and v98['ElementalBlast']:IsAvailable() and v38 and (v98['EchoesofGreatSundering']:IsAvailable())) then
					if ((232 < 821) and v102.CastTargetIf(v98.ElementalBlast, v109, "min", v118, nil, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast aoe 42";
					end
				end
				if ((518 < 902) and v98['ElementalBlast']:IsAvailable() and v38 and (v98['EchoesofGreatSundering']:IsAvailable())) then
					if ((2994 > 858) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast aoe 44";
					end
				end
				v155 = 4;
			end
			if ((v155 == 0) or (3755 <= 915)) then
				if ((3946 > 3743) and v98['FireElemental']:IsReady() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) then
					if (v24(v98.FireElemental) or (1335 >= 3306)) then
						return "fire_elemental aoe 2";
					end
				end
				if ((4844 > 2253) and v98['StormElemental']:IsReady() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) then
					if ((452 == 452) and v24(v98.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v98['Stormkeeper']:IsAvailable() and (v98['Stormkeeper']:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and not v121()) or (4557 < 2087)) then
					if ((3874 == 3874) and v24(v98.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v98['TotemicRecall']:IsCastable() and (v98['LiquidMagmaTotem']:CooldownRemains() > 45) and v48) or (1938 > 4935)) then
					if (v24(v98.TotemicRecall) or (4255 < 3423)) then
						return "totemic_recall aoe 8";
					end
				end
				if ((1454 <= 2491) and v98['LiquidMagmaTotem']:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "cursor")) then
					if (v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(40)) or (4157 <= 2803)) then
						return "liquid_magma_totem aoe 10";
					end
				end
				v155 = 1;
			end
			if ((4853 >= 2982) and (v155 == 2)) then
				if ((4134 > 3357) and v98['Ascendance']:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105)) then
					if (v24(v98.Ascendance) or (3417 < 2534)) then
						return "ascendance aoe 32";
					end
				end
				if ((v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98['MasteroftheElements']:IsAvailable() and not v120() and (v119() >= ((60 - (5 * v98['EyeoftheStorm']:TalentRank())) - (2 * v25(v98['FlowofPower']:IsAvailable())))) and ((not v98['EchoesofGreatSundering']:IsAvailable() and not v98['LightningRod']:IsAvailable()) or v14:BuffUp(v98.EchoesofGreatSunderingBuff)) and ((v14:BuffDown(v98.AscendanceBuff) and (v110 > 3) and not v98['UnrelentingCalamity']:IsAvailable()) or (v111 == 3))) or (2722 <= 164)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or (2408 < 2109)) then
						return "lava_burst aoe 34";
					end
				end
				if ((v98['Earthquake']:IsReady() and v36 and (v50 == "cursor") and not v98['EchoesofGreatSundering']:IsAvailable() and (v110 > 3) and (v111 > 3)) or (33 == 1455)) then
					if (v24(v100.EarthquakeCursor, not v17:IsInRange(40)) or (443 >= 4015)) then
						return "earthquake aoe 36";
					end
				end
				if ((3382 > 166) and v98['Earthquake']:IsReady() and v36 and (v50 == "player") and not v98['EchoesofGreatSundering']:IsAvailable() and (v110 > 3) and (v111 > 3)) then
					if (v24(v100.EarthquakePlayer, not v17:IsInRange(40)) or (280 == 3059)) then
						return "earthquake aoe 36";
					end
				end
				if ((1881 > 1293) and v98['Earthquake']:IsReady() and v36 and (v50 == "cursor") and not v98['EchoesofGreatSundering']:IsAvailable() and not v98['ElementalBlast']:IsAvailable() and (v110 == 3) and (v111 == 3)) then
					if ((2357 == 2357) and v24(v100.EarthquakeCursor, not v17:IsInRange(40))) then
						return "earthquake aoe 38";
					end
				end
				v155 = 3;
			end
			if ((123 == 123) and (v155 == 7)) then
				if ((v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98['DeeplyRootedElements']:IsAvailable()) or (1056 >= 3392)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or (1081 < 1075)) then
						return "lava_burst aoe 76";
					end
				end
				if ((v98['Icefury']:IsAvailable() and (v98['Icefury']:CooldownRemains() == 0) and v41 and v98['ElectrifiedShocks']:IsAvailable() and (v111 < 5)) or (1049 >= 4432)) then
					if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or (4768 <= 846)) then
						return "icefury aoe 78";
					end
				end
				if ((v98['FrostShock']:IsCastable() and v40 and v122() and v98['ElectrifiedShocks']:IsAvailable() and v17:DebuffDown(v98.ElectrifiedShocksDebuff) and (v110 < 5) and v98['UnrelentingCalamity']:IsAvailable()) or (3358 <= 1420)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (3739 <= 3005)) then
						return "frost_shock aoe 80";
					end
				end
				if ((v98['LavaBeam']:IsAvailable() and v42 and (v14:BuffRemains(v98.AscendanceBuff) > v98['LavaBeam']:CastTime())) or (1659 >= 2134)) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (3260 < 2355)) then
						return "lava_beam aoe 82";
					end
				end
				if ((v98['ChainLightning']:IsAvailable() and v35) or (669 == 4223)) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (1692 < 588)) then
						return "chain_lightning aoe 84";
					end
				end
				v155 = 8;
			end
			if ((v155 == 5) or (4797 < 3651)) then
				if ((v98['LavaBurst']:IsAvailable() and v43 and v98['MasteroftheElements']:IsAvailable() and not v120() and (v121() or (v14:HasTier(30, 2) and (v112() < 3))) and (v119() < (((60 - (5 * v98['EyeoftheStorm']:TalentRank())) - (2 * v25(v98['FlowofPower']:IsAvailable()))) - 10)) and (v110 < 5)) or (4177 > 4850)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or (400 > 1111)) then
						return "lava_burst aoe 56";
					end
				end
				if ((3051 > 1005) and v98['LavaBeam']:IsAvailable() and v42 and (v121())) then
					if ((3693 <= 4382) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return "lava_beam aoe 58";
					end
				end
				if ((v98['ChainLightning']:IsAvailable() and v35 and (v121())) or (3282 > 4100)) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (3580 < 2844)) then
						return "chain_lightning aoe 60";
					end
				end
				if ((89 < 4490) and v98['LavaBeam']:IsAvailable() and v42 and v14:BuffUp(v98.Power) and (v14:BuffRemains(v98.AscendanceBuff) > v98['LavaBeam']:CastTime())) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (4983 < 1808)) then
						return "lava_beam aoe 62";
					end
				end
				if ((3829 > 3769) and v98['ChainLightning']:IsAvailable() and v35 and (v120())) then
					if ((1485 <= 2904) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning aoe 64";
					end
				end
				v155 = 6;
			end
			if ((4269 == 4269) and (v155 == 1)) then
				if ((387 <= 2782) and v98['LiquidMagmaTotem']:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "player")) then
					if (v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(40)) or (1899 <= 917)) then
						return "liquid_magma_totem aoe 11";
					end
				end
				if ((v98['PrimordialWave']:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffUp(v98.SurgeofPowerBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) or (4312 <= 876)) then
					if ((2232 <= 2596) and v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings['Commons']['DisplayStyle'].Signature)) then
						return "primordial_wave aoe 12";
					end
				end
				if ((2095 < 3686) and v98['PrimordialWave']:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98['DeeplyRootedElements']:IsAvailable() and not v98['SurgeofPower']:IsAvailable() and v14:BuffDown(v98.SplinteredElementsBuff)) then
					if (v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings['Commons']['DisplayStyle'].Signature) or (1595 >= 4474)) then
						return "primordial_wave aoe 14";
					end
				end
				if ((v98['PrimordialWave']:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98['MasteroftheElements']:IsAvailable() and not v98['LightningRod']:IsAvailable()) or (4619 < 2882)) then
					if (v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings['Commons']['DisplayStyle'].Signature) or (294 >= 4831)) then
						return "primordial_wave aoe 16";
					end
				end
				if ((2029 <= 3084) and v98['FlameShock']:IsCastable()) then
					local v223 = 0;
					while true do
						if ((1 == v223) or (2037 == 2420)) then
							if ((4458 > 3904) and v98['MasteroftheElements']:IsAvailable() and v39 and not v98['LightningRod']:IsAvailable() and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) then
								if ((436 >= 123) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return "flame_shock aoe 22";
								end
							end
							if ((500 < 1816) and v98['DeeplyRootedElements']:IsAvailable() and v39 and not v98['SurgeofPower']:IsAvailable() and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) then
								if ((3574 == 3574) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return "flame_shock aoe 24";
								end
							end
							v223 = 2;
						end
						if ((221 < 390) and (v223 == 2)) then
							if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98['LightningRod']:IsAvailable() or v98['SkybreakersFieryDemise']:IsAvailable())) or (2213 <= 1421)) then
								if ((3058 < 4860) and v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock))) then
									return "flame_shock aoe 26";
								end
							end
							if ((v98['MasteroftheElements']:IsAvailable() and v39 and not v98['LightningRod']:IsAvailable()) or (1296 >= 4446)) then
								if (v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock)) or (1393 > 4489)) then
									return "flame_shock aoe 28";
								end
							end
							v223 = 3;
						end
						if ((v223 == 3) or (4424 < 27)) then
							if ((v98['DeeplyRootedElements']:IsAvailable() and v39 and not v98['SurgeofPower']:IsAvailable()) or (1997 > 3815)) then
								if ((3465 > 1913) and v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock))) then
									return "flame_shock aoe 30";
								end
							end
							break;
						end
						if ((733 < 1819) and (0 == v223)) then
							if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and v98['LightningRod']:IsAvailable() and v98['WindspeakersLavaResurgence']:IsAvailable() and (v17:DebuffRemains(v98.FlameShockDebuff) < (v17:TimeToDie() - 1))) or (4395 == 4755)) then
								if (v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock)) or (3793 < 2369)) then
									return "flame_shock aoe 18";
								end
							end
							if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98['LightningRod']:IsAvailable() or v98['SkybreakersFieryDemise']:IsAvailable()) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) or (4084 == 265)) then
								if ((4358 == 4358) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return "flame_shock aoe 20";
								end
							end
							v223 = 1;
						end
					end
				end
				v155 = 2;
			end
			if ((v155 == 6) or (3138 < 993)) then
				if ((3330 > 2323) and v98['LavaBeam']:IsAvailable() and v42 and (v110 >= 6) and v14:BuffUp(v98.SurgeofPowerBuff) and (v14:BuffRemains(v98.AscendanceBuff) > v98['LavaBeam']:CastTime())) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (3626 == 3989)) then
						return "lava_beam aoe 66";
					end
				end
				if ((v98['ChainLightning']:IsAvailable() and v35 and (v110 >= 6) and v14:BuffUp(v98.SurgeofPowerBuff)) or (916 == 2671)) then
					if ((272 == 272) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning aoe 68";
					end
				end
				if ((4249 <= 4839) and v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98['DeeplyRootedElements']:IsAvailable() and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff)) then
					if ((2777 < 3200) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst aoe 70";
					end
				end
				if ((95 < 1957) and v98['LavaBeam']:IsAvailable() and v42 and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98['LavaBeam']:CastTime())) then
					if ((826 < 1717) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if ((1426 >= 1105) and v98['LavaBurst']:IsAvailable() and v43 and (v110 == 3) and v98['MasteroftheElements']:IsAvailable()) then
					if ((2754 <= 3379) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst aoe 74";
					end
				end
				v155 = 7;
			end
			if ((v155 == 4) or (3927 == 1413)) then
				if ((v98['ElementalBlast']:IsAvailable() and v38 and (v110 == 3) and not v98['EchoesofGreatSundering']:IsAvailable()) or (1154 <= 788)) then
					if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or (1643 > 3379)) then
						return "elemental_blast aoe 46";
					end
				end
				if ((v98['EarthShock']:IsReady() and v37 and (v98['EchoesofGreatSundering']:IsAvailable())) or (2803 > 4549)) then
					if (v102.CastTargetIf(v98.EarthShock, v109, "min", v118, nil, not v17:IsSpellInRange(v98.EarthShock)) or (220 >= 3022)) then
						return "earth_shock aoe 48";
					end
				end
				if ((2822 == 2822) and v98['EarthShock']:IsReady() and v37 and (v98['EchoesofGreatSundering']:IsAvailable())) then
					if (v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock)) or (1061 == 1857)) then
						return "earth_shock aoe 50";
					end
				end
				if ((2760 > 1364) and v98['Icefury']:IsAvailable() and (v98['Icefury']:CooldownRemains() == 0) and v41 and v14:BuffDown(v98.AscendanceBuff) and v98['ElectrifiedShocks']:IsAvailable() and ((v98['LightningRod']:IsAvailable() and (v110 < 5) and not v120()) or (v98['DeeplyRootedElements']:IsAvailable() and (v110 == 3)))) then
					if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or (4902 <= 3595)) then
						return "icefury aoe 52";
					end
				end
				if ((v98['FrostShock']:IsCastable() and v40 and v14:BuffDown(v98.AscendanceBuff) and v122() and v98['ElectrifiedShocks']:IsAvailable() and (v17:DebuffDown(v98.ElectrifiedShocksDebuff) or (v14:BuffRemains(v98.IcefuryBuff) < v14:GCD())) and ((v98['LightningRod']:IsAvailable() and (v110 < 5) and not v120()) or (v98['DeeplyRootedElements']:IsAvailable() and (v110 == 3)))) or (3852 == 293)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (1559 == 4588)) then
						return "frost_shock moving aoe 54";
					end
				end
				v155 = 5;
			end
		end
	end
	local function v129()
		local v156 = 0;
		while true do
			if ((v156 == 6) or (4484 == 788)) then
				if ((4568 >= 3907) and v98['Icefury']:IsAvailable() and (v98['Icefury']:CooldownRemains() == 0) and v41) then
					if ((1246 < 3470) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((4068 >= 972) and v98['ChainLightning']:IsAvailable() and v35 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120()) and (v110 > 1) and (v111 > 1)) then
					if ((493 < 3893) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning single_target 94";
					end
				end
				if ((v98['LightningBolt']:IsAvailable() and v44 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120())) or (1473 >= 3332)) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (4051 <= 1157)) then
						return "lightning_bolt single_target 96";
					end
				end
				if ((604 < 2881) and v98['FrostShock']:IsCastable() and v40 and v122() and v120() and v14:BuffDown(v98.LavaSurgeBuff) and not v98['ElectrifiedShocks']:IsAvailable() and not v98['FluxMelting']:IsAvailable() and (v98['LavaBurst']:ChargesFractional() < 1) and v98['EchooftheElements']:IsAvailable()) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (900 == 3377)) then
						return "frost_shock single_target 98";
					end
				end
				if ((4459 > 591) and v98['FrostShock']:IsCastable() and v40 and v122() and (v98['FluxMelting']:IsAvailable() or (v98['ElectrifiedShocks']:IsAvailable() and not v98['LightningRod']:IsAvailable()))) then
					if ((3398 >= 2395) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v98['ChainLightning']:IsAvailable() and v35 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98['LavaBurst']:ChargesFractional() < 1) and v98['EchooftheElements']:IsAvailable() and (v110 > 1) and (v111 > 1)) or (2183 >= 2824)) then
					if ((1936 == 1936) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning single_target 102";
					end
				end
				if ((v98['LightningBolt']:IsAvailable() and v44 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98['LavaBurst']:ChargesFractional() < 1) and v98['EchooftheElements']:IsAvailable()) or (4832 < 4313)) then
					if ((4088 > 3874) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((4332 == 4332) and v98['FrostShock']:IsCastable() and v40 and v122() and not v98['ElectrifiedShocks']:IsAvailable() and not v98['FluxMelting']:IsAvailable()) then
					if ((3999 >= 2900) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single_target 106";
					end
				end
				v156 = 7;
			end
			if ((v156 == 0) or (2525 > 4064)) then
				if ((4371 == 4371) and v98['FireElemental']:IsCastable() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) then
					if (v24(v98.FireElemental) or (266 > 4986)) then
						return "fire_elemental single_target 2";
					end
				end
				if ((1991 >= 925) and v98['StormElemental']:IsCastable() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) then
					if ((455 < 2053) and v24(v98.StormElemental)) then
						return "storm_elemental single_target 4";
					end
				end
				if ((v98['TotemicRecall']:IsCastable() and v48 and (v98['LiquidMagmaTotem']:CooldownRemains() > 45) and ((v98['LavaSurge']:IsAvailable() and v98['SplinteredElements']:IsAvailable()) or ((v110 > 1) and (v111 > 1)))) or (826 == 4851)) then
					if ((183 == 183) and v24(v98.TotemicRecall)) then
						return "totemic_recall single_target 7";
					end
				end
				if ((1159 <= 1788) and v98['LiquidMagmaTotem']:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "cursor") and ((v98['LavaSurge']:IsAvailable() and v98['SplinteredElements']:IsAvailable()) or (v98['FlameShockDebuff']:AuraActiveCount() == 0) or (v17:DebuffRemains(v98.FlameShockDebuff) < 6) or ((v110 > 1) and (v111 > 1)))) then
					if (v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(40)) or (3507 > 4318)) then
						return "liquid_magma_totem single_target 8";
					end
				end
				if ((v98['LiquidMagmaTotem']:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "player") and ((v98['LavaSurge']:IsAvailable() and v98['SplinteredElements']:IsAvailable()) or (v98['FlameShockDebuff']:AuraActiveCount() == 0) or (v17:DebuffRemains(v98.FlameShockDebuff) < 6) or ((v110 > 1) and (v111 > 1)))) or (3075 <= 2965)) then
					if ((1365 <= 2011) and v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(40))) then
						return "liquid_magma_totem single_target 8";
					end
				end
				if ((v98['PrimordialWave']:IsAvailable() and v46 and v63 and (v89 < v105) and v33 and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) or (2776 > 3575)) then
					if (v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings['Commons']['DisplayStyle'].Signature) or (2554 == 4804)) then
						return "primordial_wave single_target 10";
					end
				end
				if ((2577 == 2577) and v98['FlameShock']:IsCastable() and UseFlameShock and (v110 == 1) and v17:DebuffRefreshable(v98.FlameShockDebuff) and v14:BuffDown(v98.SurgeofPowerBuff) and (not v120() or (not v121() and ((v98['ElementalBlast']:IsAvailable() and (v119() < (90 - (8 * v98['EyeoftheStorm']:TalentRank())))) or (v119() < (60 - (5 * v98['EyeoftheStorm']:TalentRank()))))))) then
					if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or (6 >= 1889)) then
						return "flame_shock single_target 12";
					end
				end
				if ((506 <= 1892) and v98['FlameShock']:IsCastable() and UseFlameShock and (v98['FlameShockDebuff']:AuraActiveCount() == 0) and (v110 > 1) and (v111 > 1) and (v98['DeeplyRootedElements']:IsAvailable() or v98['Ascendance']:IsAvailable() or v98['PrimordialWave']:IsAvailable() or v98['SearingFlames']:IsAvailable() or v98['MagmaChamber']:IsAvailable()) and ((not v120() and (v121() or (v98['Stormkeeper']:CooldownRemains() > 0))) or not v98['SurgeofPower']:IsAvailable())) then
					if (v102.CastTargetIf(v98.FlameShock, v109, "min", v116, nil, not v17:IsSpellInRange(v98.FlameShock)) or (2008 > 2218)) then
						return "flame_shock single_target 14";
					end
				end
				v156 = 1;
			end
			if ((379 <= 4147) and (v156 == 4)) then
				if ((v98['Earthquake']:IsReady() and v36 and (v50 == "cursor") and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98['ElementalBlast']:IsAvailable() and (v110 < 2)) or (v110 > 1))) or (4514 <= 1009)) then
					if (v24(v100.EarthquakeCursor, not v17:IsInRange(40)) or (3496 == 1192)) then
						return "earthquake single_target 64";
					end
				end
				if ((v98['Earthquake']:IsReady() and v36 and (v50 == "player") and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98['ElementalBlast']:IsAvailable() and (v110 < 2)) or (v110 > 1))) or (208 == 2959)) then
					if ((4277 >= 1313) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return "earthquake single_target 64";
					end
				end
				if ((2587 < 3174) and v98['Earthquake']:IsReady() and v36 and (v50 == "cursor") and (v110 > 1) and (v111 > 1) and not v98['EchoesofGreatSundering']:IsAvailable() and not v98['ElementalBlast']:IsAvailable()) then
					if (v24(v100.EarthquakeCursor, not v17:IsInRange(40)) or (4120 <= 2198)) then
						return "earthquake single_target 66";
					end
				end
				if ((v98['Earthquake']:IsReady() and v36 and (v50 == "player") and (v110 > 1) and (v111 > 1) and not v98['EchoesofGreatSundering']:IsAvailable() and not v98['ElementalBlast']:IsAvailable()) or (1596 == 858)) then
					if ((3220 == 3220) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return "earthquake single_target 66";
					end
				end
				if ((v98['ElementalBlast']:IsAvailable() and v38 and (not v98['MasteroftheElements']:IsAvailable() or (v120() and v17:DebuffUp(v98.ElectrifiedShocksDebuff)))) or (1402 > 3620)) then
					if ((2574 == 2574) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((1798 < 2757) and v98['FrostShock']:IsCastable() and v40 and v122() and v120() and (v119() < 110) and (v98['LavaBurst']:ChargesFractional() < 1) and v98['ElectrifiedShocks']:IsAvailable() and v98['ElementalBlast']:IsAvailable() and not v98['LightningRod']:IsAvailable()) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (377 > 2604)) then
						return "frost_shock single_target 70";
					end
				end
				if ((568 < 911) and v98['ElementalBlast']:IsAvailable() and v38 and (v120() or v98['LightningRod']:IsAvailable())) then
					if ((3285 < 4228) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast single_target 72";
					end
				end
				if ((3916 > 3328) and v98['EarthShock']:IsReady() and v37) then
					if ((2500 < 3839) and v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock))) then
						return "earth_shock single_target 74";
					end
				end
				v156 = 5;
			end
			if ((507 == 507) and (v156 == 1)) then
				if ((240 <= 3165) and v98['FlameShock']:IsCastable() and UseFlameShock and (v110 > 1) and (v111 > 1) and (v98['DeeplyRootedElements']:IsAvailable() or v98['Ascendance']:IsAvailable() or v98['PrimordialWave']:IsAvailable() or v98['SearingFlames']:IsAvailable() or v98['MagmaChamber']:IsAvailable()) and ((v14:BuffUp(v98.SurgeofPowerBuff) and not v121() and v98['Stormkeeper']:IsAvailable()) or not v98['SurgeofPower']:IsAvailable())) then
					if ((834 >= 805) and v102.CastTargetIf(v98.FlameShock, v109, "min", v116, v113, not v17:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock single_target 16";
					end
				end
				if ((v98['Stormkeeper']:IsAvailable() and (v98['Stormkeeper']:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (v119() >= 116) and v98['ElementalBlast']:IsAvailable() and v98['SurgeofPower']:IsAvailable() and v98['SwellingMaelstrom']:IsAvailable() and not v98['LavaSurge']:IsAvailable() and not v98['EchooftheElements']:IsAvailable() and not v98['PrimordialSurge']:IsAvailable()) or (3812 < 2316)) then
					if (v24(v98.Stormkeeper) or (2652 <= 1533)) then
						return "stormkeeper single_target 18";
					end
				end
				if ((v98['Stormkeeper']:IsAvailable() and (v98['Stormkeeper']:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and v14:BuffUp(v98.SurgeofPowerBuff) and not v98['LavaSurge']:IsAvailable() and not v98['EchooftheElements']:IsAvailable() and not v98['PrimordialSurge']:IsAvailable()) or (3598 < 1460)) then
					if (v24(v98.Stormkeeper) or (4116 < 1192)) then
						return "stormkeeper single_target 20";
					end
				end
				if ((v98['Stormkeeper']:IsAvailable() and (v98['Stormkeeper']:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (not v98['SurgeofPower']:IsAvailable() or not v98['ElementalBlast']:IsAvailable() or v98['LavaSurge']:IsAvailable() or v98['EchooftheElements']:IsAvailable() or v98['PrimordialSurge']:IsAvailable())) or (3377 <= 903)) then
					if ((3976 >= 439) and v24(v98.Stormkeeper)) then
						return "stormkeeper single_target 22";
					end
				end
				if ((3752 == 3752) and v98['Ascendance']:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105) and not v121()) then
					if ((4046 > 2695) and v24(v98.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				if ((v98['LightningBolt']:IsAvailable() and v44 and v121() and v14:BuffUp(v98.SurgeofPowerBuff)) or (3545 == 3197)) then
					if ((2394 > 373) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single_target 26";
					end
				end
				if ((4155 <= 4232) and v98['LavaBeam']:IsCastable() and v42 and (v110 > 1) and (v111 > 1) and v121() and not v98['SurgeofPower']:IsAvailable()) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (3581 == 3473)) then
						return "lava_beam single_target 28";
					end
				end
				if ((4995 > 3348) and v98['ChainLightning']:IsAvailable() and v35 and (v110 > 1) and (v111 > 1) and v121() and not v98['SurgeofPower']:IsAvailable()) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (754 > 3724)) then
						return "chain_lightning single_target 30";
					end
				end
				v156 = 2;
			end
			if ((217 >= 57) and (2 == v156)) then
				if ((v98['LavaBurst']:IsAvailable() and v43 and v121() and not v120() and not v98['SurgeofPower']:IsAvailable() and v98['MasteroftheElements']:IsAvailable()) or (2070 >= 4037)) then
					if ((2705 == 2705) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single_target 32";
					end
				end
				if ((61 == 61) and v98['LightningBolt']:IsAvailable() and v44 and v121() and not v98['SurgeofPower']:IsAvailable() and v120()) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (699 >= 1296)) then
						return "lightning_bolt single_target 34";
					end
				end
				if ((v98['LightningBolt']:IsAvailable() and v44 and v121() and not v98['SurgeofPower']:IsAvailable() and not v98['MasteroftheElements']:IsAvailable()) or (1783 >= 3616)) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (3913 > 4527)) then
						return "lightning_bolt single_target 36";
					end
				end
				if ((4376 > 817) and v98['LightningBolt']:IsAvailable() and v44 and v14:BuffUp(v98.SurgeofPowerBuff) and v98['LightningRod']:IsAvailable()) then
					if ((4861 > 824) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single_target 38";
					end
				end
				if ((v98['Icefury']:IsAvailable() and (v98['Icefury']:CooldownRemains() == 0) and v41 and v98['ElectrifiedShocks']:IsAvailable() and v98['LightningRod']:IsAvailable() and v98['LightningRod']:IsAvailable()) or (1383 >= 2131)) then
					if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or (1876 >= 2541)) then
						return "icefury single_target 40";
					end
				end
				if ((1782 <= 3772) and v98['FrostShock']:IsCastable() and v40 and v122() and v98['ElectrifiedShocks']:IsAvailable() and ((v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < 2) or (v14:BuffRemains(v98.IcefuryBuff) <= v14:GCD())) and v98['LightningRod']:IsAvailable()) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (4700 < 813)) then
						return "frost_shock single_target 42";
					end
				end
				if ((3199 < 4050) and v98['FrostShock']:IsCastable() and v40 and v122() and v98['ElectrifiedShocks']:IsAvailable() and (v119() >= 50) and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < (2 * v14:GCD())) and v121() and v98['LightningRod']:IsAvailable()) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (4951 < 4430)) then
						return "frost_shock single_target 44";
					end
				end
				if ((96 == 96) and v98['LavaBeam']:IsCastable() and v42 and (v110 > 1) and (v111 > 1) and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98['LavaBeam']:CastTime()) and not v14:HasTier(31, 4)) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (2739 > 4008)) then
						return "lava_beam single_target 46";
					end
				end
				v156 = 3;
			end
			if ((v156 == 5) or (23 == 1134)) then
				if ((v98['FrostShock']:IsCastable() and v40 and v122() and v98['ElectrifiedShocks']:IsAvailable() and v120() and not v98['LightningRod']:IsAvailable() and (v110 > 1) and (v111 > 1)) or (2693 >= 4111)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (4316 <= 2146)) then
						return "frost_shock single_target 76";
					end
				end
				if ((v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.FluxMeltingBuff) and (v110 > 1)) or (3546 <= 2809)) then
					if ((4904 > 2166) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single_target 78";
					end
				end
				if ((109 >= 90) and v98['FrostShock']:IsCastable() and v40 and v122() and v98['FluxMelting']:IsAvailable() and v14:BuffDown(v98.FluxMeltingBuff)) then
					if ((4978 > 2905) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single_target 80";
					end
				end
				if ((v98['FrostShock']:IsCastable() and v40 and v122() and ((v98['ElectrifiedShocks']:IsAvailable() and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < 2)) or (v14:BuffRemains(v98.IcefuryBuff) < 6))) or (3026 <= 2280)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (1653 <= 1108)) then
						return "frost_shock single_target 82";
					end
				end
				if ((2909 > 2609) and v98['LavaBurst']:IsAvailable() and v43 and (v98['EchooftheElements']:IsAvailable() or v98['LavaSurge']:IsAvailable() or v98['PrimordialSurge']:IsAvailable() or not v98['ElementalBlast']:IsAvailable() or not v98['MasteroftheElements']:IsAvailable() or v121())) then
					if ((757 > 194) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single_target 84";
					end
				end
				if ((v98['ElementalBlast']:IsAvailable() and v38) or (31 >= 1398)) then
					if ((3196 <= 4872) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((3326 == 3326) and v98['ChainLightning']:IsAvailable() and v35 and v120() and v98['UnrelentingCalamity']:IsAvailable() and (v110 > 1) and (v111 > 1)) then
					if ((1433 <= 3878) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning single_target 88";
					end
				end
				if ((v98['LightningBolt']:IsAvailable() and v44 and v120() and v98['UnrelentingCalamity']:IsAvailable()) or (1583 == 1735)) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (2981 == 2350)) then
						return "lightning_bolt single_target 90";
					end
				end
				v156 = 6;
			end
			if ((v156 == 7) or (4466 <= 493)) then
				if ((v98['ChainLightning']:IsAvailable() and v35 and (v110 > 1) and (v111 > 1)) or (2547 <= 1987)) then
					if ((2961 > 2740) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				if ((3696 >= 3612) and v98['LightningBolt']:IsAvailable() and v44) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (2970 == 1878)) then
						return "lightning_bolt single_target 110";
					end
				end
				if ((v98['FlameShock']:IsCastable() and UseFlameShock and (v14:IsMoving())) or (3693 < 1977)) then
					if (v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock)) or (930 > 2101)) then
						return "flame_shock single_target 112";
					end
				end
				if ((4153 > 3086) and v98['FlameShock']:IsCastable() and UseFlameShock) then
					if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or (4654 <= 4050)) then
						return "flame_shock single_target 114";
					end
				end
				if ((v98['FrostShock']:IsCastable() and v40) or (2602 < 1496)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (1020 > 2288)) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if ((328 == 328) and (v156 == 3)) then
				if ((1511 < 3808) and v98['FrostShock']:IsCastable() and v40 and v122() and v121() and not v98['LavaSurge']:IsAvailable() and not v98['EchooftheElements']:IsAvailable() and not v98['PrimordialSurge']:IsAvailable() and v98['ElementalBlast']:IsAvailable() and (((v119() >= 61) and (v119() < 75) and (v98['LavaBurst']:CooldownRemains() > v14:GCD())) or ((v119() >= 49) and (v119() < 63) and (v98['LavaBurst']:CooldownRemains() > 0)))) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (2510 > 4919)) then
						return "frost_shock single_target 48";
					end
				end
				if ((4763 == 4763) and v98['FrostShock']:IsCastable() and v40 and v122() and not v98['LavaSurge']:IsAvailable() and not v98['EchooftheElements']:IsAvailable() and not v98['ElementalBlast']:IsAvailable() and (((v119() >= 36) and (v119() < 50) and (v98['LavaBurst']:CooldownRemains() > v14:GCD())) or ((v119() >= 24) and (v119() < 38) and (v98['LavaBurst']:CooldownRemains() > 0)))) then
					if ((4137 > 1848) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single_target 50";
					end
				end
				if ((2436 <= 3134) and v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff) and (v98['EchooftheElements']:IsAvailable() or v98['LavaSurge']:IsAvailable() or v98['PrimordialSurge']:IsAvailable() or ((v119() >= 63) and v98['MasteroftheElements']:IsAvailable()) or ((v119() >= 38) and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and (v110 > 1) and (v111 > 1)) or not v98['ElementalBlast']:IsAvailable())) then
					if ((3723 == 3723) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and (v98['EchooftheElements']:IsAvailable() or v98['LavaSurge']:IsAvailable() or v98['PrimordialSurge']:IsAvailable() or not v98['MasteroftheElements']:IsAvailable() or not v98['ElementalBlast']:IsAvailable())) or (4046 >= 4316)) then
					if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or (2008 < 1929)) then
						return "lava_burst single_target 54";
					end
				end
				if ((2384 > 1775) and v98['LavaBurst']:IsAvailable() and v43 and v14:BuffUp(v98.AscendanceBuff) and (v14:HasTier(31, 4) or not v98['ElementalBlast']:IsAvailable())) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (4543 <= 4376)) then
						return "lava_burst single_target 56";
					end
				end
				if ((728 == 728) and v98['LavaBurst']:IsAvailable() and v43 and v14:BuffDown(v98.AscendanceBuff) and (not v98['ElementalBlast']:IsAvailable() or not v98['MountainsWillFall']:IsAvailable()) and not v98['LightningRod']:IsAvailable() and v14:HasTier(31, 4)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (1076 > 4671)) then
						return "lava_burst single_target 58";
					end
				end
				if ((1851 >= 378) and v98['LavaBurst']:IsAvailable() and v43 and v98['MasteroftheElements']:IsAvailable() and not v120() and not v98['LightningRod']:IsAvailable()) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (1948 >= 3476)) then
						return "lava_burst single_target 60";
					end
				end
				if ((4794 >= 833) and v98['LavaBurst']:IsAvailable() and v43 and v98['MasteroftheElements']:IsAvailable() and not v120() and ((v119() >= 75) or ((v119() >= 50) and not v98['ElementalBlast']:IsAvailable())) and v98['SwellingMaelstrom']:IsAvailable() and (v119() <= 130)) then
					if ((4090 == 4090) and v22(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				v156 = 4;
			end
		end
	end
	local function v130()
		local v157 = 0;
		while true do
			if ((v157 == 2) or (3758 == 2498)) then
				if ((v98['AncestralSpirit']:IsCastable() and v98['AncestralSpirit']:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or (2673 < 1575)) then
					if (v24(v100.AncestralSpiritMouseover) or (3721 <= 1455)) then
						return "ancestral_spirit mouseover";
					end
				end
				v106, v107 = v28();
				v157 = 3;
			end
			if ((934 < 2270) and (3 == v157)) then
				if ((v98['ImprovedFlametongueWeapon']:IsAvailable() and v49 and (not v106 or (v107 < 600000)) and v98['FlametongueWeapon']:IsAvailable()) or (1612 == 1255)) then
					if (v24(v98.FlamentongueWeapon) or (4352 < 4206)) then
						return "flametongue_weapon enchant";
					end
				end
				if ((not v14:AffectingCombat() and v30 and v102.TargetIsValid()) or (2860 <= 181)) then
					local v224 = 0;
					while true do
						if ((3222 >= 1527) and (v224 == 0)) then
							v29 = v127();
							if ((1505 <= 2121) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if ((744 == 744) and (v157 == 0)) then
				if ((v72 and v98['EarthShield']:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == "Earth Shield") or (v98['ElementalOrbit']:IsAvailable() and v14:BuffUp(v98.LightningShield)))) or (1979 >= 2836)) then
					if ((1833 <= 2668) and v24(v98.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((3686 == 3686) and v72 and v98['LightningShield']:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == "Lightning Shield") or (v98['ElementalOrbit']:IsAvailable() and v14:BuffUp(v98.EarthShield)))) then
					if ((3467 > 477) and v24(v98.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v29 = v124();
				v157 = 1;
			end
			if ((v157 == 1) or (3288 >= 3541)) then
				if (v29 or (3557 == 4540)) then
					return v29;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or (261 > 1267)) then
					if ((1272 < 3858) and v24(v98.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v157 = 2;
			end
		end
	end
	local function v131()
		local v158 = 0;
		while true do
			if ((3664 == 3664) and (v158 == 0)) then
				v29 = v125();
				if ((1941 >= 450) and v29) then
					return v29;
				end
				v158 = 1;
			end
			if ((v158 == 3) or (4646 < 324)) then
				if ((3833 == 3833) and v98['Purge']:IsReady() and v95 and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) then
					if (v24(v98.Purge, not v17:IsSpellInRange(v98.Purge)) or (1240 > 3370)) then
						return "purge damage";
					end
				end
				if ((v102.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or (2481 == 4682)) then
					local v225 = 0;
					local v226;
					while true do
						if ((4727 >= 208) and (3 == v225)) then
							if ((280 < 3851) and true) then
								local v236 = 0;
								while true do
									if ((v236 == 1) or (3007 > 3194)) then
										if (v24(v98.Pool) or (2136 >= 2946)) then
											return "Pool for SingleTarget()";
										end
										break;
									end
									if ((2165 <= 2521) and (v236 == 0)) then
										v29 = v129();
										if ((2861 > 661) and v29) then
											return v29;
										end
										v236 = 1;
									end
								end
							end
							break;
						end
						if ((4525 > 4519) and (v225 == 2)) then
							if ((3178 > 972) and v226) then
								return v226;
							end
							if ((4766 == 4766) and v31 and (v110 > 2) and (v111 > 2)) then
								local v237 = 0;
								while true do
									if ((v237 == 1) or (2745 > 3128)) then
										if (v24(v98.Pool) or (1144 >= 4606)) then
											return "Pool for Aoe()";
										end
										break;
									end
									if ((3338 >= 277) and (v237 == 0)) then
										v29 = v128();
										if ((2610 > 2560) and v29) then
											return v29;
										end
										v237 = 1;
									end
								end
							end
							v225 = 3;
						end
						if ((v225 == 0) or (1194 > 3083)) then
							if ((916 >= 747) and (v89 < v105) and v56 and ((v62 and v32) or not v62)) then
								local v238 = 0;
								while true do
									if ((v238 == 0) or (2444 > 2954)) then
										if ((2892 < 3514) and v98['BloodFury']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) then
											if ((533 == 533) and v24(v98.BloodFury)) then
												return "blood_fury main 2";
											end
										end
										if ((595 <= 3413) and v98['Berserking']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
											if ((3078 >= 2591) and v24(v98.Berserking)) then
												return "berserking main 4";
											end
										end
										v238 = 1;
									end
									if ((3199 < 4030) and (v238 == 2)) then
										if ((777 < 2078) and v98['BagofTricks']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
											if ((1696 <= 2282) and v24(v98.BagofTricks)) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if ((v238 == 1) or (1761 >= 2462)) then
										if ((4551 > 2328) and v98['Fireblood']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) then
											if ((3825 >= 467) and v24(v98.Fireblood)) then
												return "fireblood main 6";
											end
										end
										if ((v98['AncestralCall']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) or (2890 == 557)) then
											if (v24(v98.AncestralCall) or (4770 == 2904)) then
												return "ancestral_call main 8";
											end
										end
										v238 = 2;
									end
								end
							end
							if ((v89 < v105) or (3903 == 4536)) then
								if ((4093 <= 4845) and v55 and ((v32 and v61) or not v61)) then
									local v245 = 0;
									while true do
										if ((1569 <= 3647) and (v245 == 0)) then
											v29 = v126();
											if (v29 or (4046 >= 4927)) then
												return v29;
											end
											break;
										end
									end
								end
							end
							v225 = 1;
						end
						if ((4623 >= 2787) and (v225 == 1)) then
							if ((2234 >= 1230) and v98['NaturesSwiftness']:IsCastable() and v45) then
								if (v24(v98.NaturesSwiftness) or (343 == 1786)) then
									return "natures_swiftness main 12";
								end
							end
							v226 = v102.HandleDPSPotion(v14:BuffUp(v98.AscendanceBuff));
							v225 = 2;
						end
					end
				end
				break;
			end
			if ((2570 > 2409) and (v158 == 1)) then
				if (v84 or (2609 >= 3234)) then
					local v227 = 0;
					while true do
						if ((v227 == 0) or (3033 >= 4031)) then
							if (v79 or (1401 == 4668)) then
								local v239 = 0;
								while true do
									if ((2776 >= 1321) and (v239 == 0)) then
										v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
										if (v29 or (487 > 2303)) then
											return v29;
										end
										break;
									end
								end
							end
							if (v80 or (4503 == 3462)) then
								local v240 = 0;
								while true do
									if ((553 <= 1543) and (v240 == 0)) then
										v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
										if ((2015 == 2015) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							v227 = 1;
						end
						if ((v227 == 1) or (4241 <= 2332)) then
							if (v81 or (2364 < 1157)) then
								local v241 = 0;
								while true do
									if ((v241 == 0) or (1167 > 1278)) then
										v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
										if (v29 or (1145 <= 1082)) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v85 or (3105 == 4881)) then
					local v228 = 0;
					while true do
						if ((v228 == 0) or (1887 > 4878)) then
							v29 = v102.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 30, true);
							if (v29 or (4087 > 4116)) then
								return v29;
							end
							break;
						end
					end
				end
				v158 = 2;
			end
			if ((1106 <= 1266) and (v158 == 2)) then
				if ((3155 < 4650) and Focus) then
					if ((3774 >= 1839) and v83) then
						local v235 = 0;
						while true do
							if ((2811 == 2811) and (v235 == 0)) then
								v29 = v123();
								if ((2146 > 1122) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				if ((v98['GreaterPurge']:IsAvailable() and v95 and v98['GreaterPurge']:IsReady() and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) or (56 == 3616)) then
					if (v24(v98.GreaterPurge, not v17:IsSpellInRange(v98.GreaterPurge)) or (2421 < 622)) then
						return "greater_purge damage";
					end
				end
				v158 = 3;
			end
		end
	end
	local function v132()
		local v159 = 0;
		while true do
			if ((1009 <= 1130) and (v159 == 1)) then
				UseFlameShock = EpicSettings['Settings']['useFlameShock'];
				v40 = EpicSettings['Settings']['useFrostShock'];
				v41 = EpicSettings['Settings']['useIceFury'];
				v42 = EpicSettings['Settings']['useLavaBeam'];
				v159 = 2;
			end
			if ((2758 < 2980) and (v159 == 6)) then
				v64 = EpicSettings['Settings']['stormkeeperWithMiniCD'];
				break;
			end
			if ((2 == v159) or (86 >= 3626)) then
				v43 = EpicSettings['Settings']['useLavaBurst'];
				v44 = EpicSettings['Settings']['useLightningBolt'];
				v45 = EpicSettings['Settings']['useNaturesSwiftness'];
				v46 = EpicSettings['Settings']['usePrimordialWave'];
				v159 = 3;
			end
			if ((2395 == 2395) and (v159 == 5)) then
				v60 = EpicSettings['Settings']['liquidMagmaTotemWithCD'];
				v58 = EpicSettings['Settings']['fireElementalWithCD'];
				v59 = EpicSettings['Settings']['stormElementalWithCD'];
				v63 = EpicSettings['Settings']['primordialWaveWithMiniCD'];
				v159 = 6;
			end
			if ((3780 > 2709) and (v159 == 3)) then
				v47 = EpicSettings['Settings']['useStormkeeper'];
				v48 = EpicSettings['Settings']['useTotemicRecall'];
				v49 = EpicSettings['Settings']['useWeaponEnchant'];
				v51 = EpicSettings['Settings']['useAscendance'];
				v159 = 4;
			end
			if ((v159 == 4) or (237 >= 2273)) then
				v53 = EpicSettings['Settings']['useLiquidMagmaTotem'];
				v52 = EpicSettings['Settings']['useFireElemental'];
				v54 = EpicSettings['Settings']['useStormElemental'];
				v57 = EpicSettings['Settings']['ascendanceWithCD'];
				v159 = 5;
			end
			if ((v159 == 0) or (2040 <= 703)) then
				v35 = EpicSettings['Settings']['useChainlightning'];
				v36 = EpicSettings['Settings']['useEarthquake'];
				v37 = EpicSettings['Settings']['useEarthshock'];
				v38 = EpicSettings['Settings']['useElementalBlast'];
				v159 = 1;
			end
		end
	end
	local function v133()
		local v160 = 0;
		while true do
			if ((3279 <= 3967) and (v160 == 5)) then
				v81 = EpicSettings['Settings']['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((4 == v160) or (1988 == 877)) then
				v97 = EpicSettings['Settings']['healOOCHP'] or 0;
				v95 = EpicSettings['Settings']['usePurgeTarget'];
				v79 = EpicSettings['Settings']['useCleanseSpiritWithAfflicted'];
				v80 = EpicSettings['Settings']['useTremorTotemWithAfflicted'];
				v160 = 5;
			end
			if ((4291 > 1912) and (v160 == 3)) then
				v65 = EpicSettings['Settings']['liquidMagmaTotemSetting'] or "";
				v72 = EpicSettings['Settings']['autoShield'];
				v73 = EpicSettings['Settings']['shieldUse'] or "Lightning Shield";
				v96 = EpicSettings['Settings']['healOOC'];
				v160 = 4;
			end
			if ((2003 < 2339) and (v160 == 2)) then
				v76 = EpicSettings['Settings']['astralShiftHP'] or 0;
				v77 = EpicSettings['Settings']['healingStreamTotemHP'] or 0;
				v78 = EpicSettings['Settings']['healingStreamTotemGroup'] or 0;
				v50 = EpicSettings['Settings']['earthquakeSetting'] or "";
				v160 = 3;
			end
			if ((432 == 432) and (v160 == 1)) then
				v70 = EpicSettings['Settings']['useAstralShift'];
				v71 = EpicSettings['Settings']['useHealingStreamTotem'];
				v74 = EpicSettings['Settings']['ancestralGuidanceHP'] or 0;
				v75 = EpicSettings['Settings']['ancestralGuidanceGroup'] or 0;
				v160 = 2;
			end
			if ((v160 == 0) or (1145 >= 1253)) then
				v66 = EpicSettings['Settings']['useWindShear'];
				v67 = EpicSettings['Settings']['useCapacitorTotem'];
				v68 = EpicSettings['Settings']['useThunderstorm'];
				v69 = EpicSettings['Settings']['useAncestralGuidance'];
				v160 = 1;
			end
		end
	end
	local function v134()
		local v161 = 0;
		while true do
			if ((3418 > 2118) and (v161 == 1)) then
				v83 = EpicSettings['Settings']['DispelDebuffs'];
				v82 = EpicSettings['Settings']['DispelBuffs'];
				v55 = EpicSettings['Settings']['useTrinkets'];
				v56 = EpicSettings['Settings']['useRacials'];
				v161 = 2;
			end
			if ((3066 <= 3890) and (v161 == 3)) then
				v93 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v92 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v94 = EpicSettings['Settings']['HealingPotionName'] or "";
				v84 = EpicSettings['Settings']['handleAfflicted'];
				v161 = 4;
			end
			if ((v161 == 4) or (2998 >= 3281)) then
				v85 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((2 == v161) or (4649 <= 2632)) then
				v61 = EpicSettings['Settings']['trinketsWithCD'];
				v62 = EpicSettings['Settings']['racialsWithCD'];
				v91 = EpicSettings['Settings']['useHealthstone'];
				v90 = EpicSettings['Settings']['useHealingPotion'];
				v161 = 3;
			end
			if ((v161 == 0) or (3860 > 4872)) then
				v89 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v86 = EpicSettings['Settings']['InterruptWithStun'];
				v87 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v88 = EpicSettings['Settings']['InterruptThreshold'];
				v161 = 1;
			end
		end
	end
	local function v135()
		local v162 = 0;
		while true do
			if ((v162 == 1) or (3998 == 2298)) then
				v31 = EpicSettings['Toggles']['aoe'];
				v32 = EpicSettings['Toggles']['cds'];
				v34 = EpicSettings['Toggles']['dispel'];
				v33 = EpicSettings['Toggles']['minicds'];
				v162 = 2;
			end
			if ((v162 == 0) or (8 >= 2739)) then
				v133();
				v132();
				v134();
				v30 = EpicSettings['Toggles']['ooc'];
				v162 = 1;
			end
			if ((2590 == 2590) and (v162 == 3)) then
				if (v14:AffectingCombat() or v83 or (82 >= 1870)) then
					local v229 = 0;
					local v230;
					while true do
						if ((2624 < 4557) and (v229 == 0)) then
							v230 = v83 and v98['CleanseSpirit']:IsReady() and v34;
							v29 = v102.FocusUnit(v230, v100, 20, nil, 25);
							v229 = 1;
						end
						if ((1 == v229) or (3131 > 3542)) then
							if ((2577 >= 1578) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((4103 <= 4571) and (v102.TargetIsValid() or v14:AffectingCombat())) then
					local v231 = 0;
					while true do
						if ((0 == v231) or (1495 == 4787)) then
							v104 = v10.BossFightRemains();
							v105 = v104;
							v231 = 1;
						end
						if ((v231 == 1) or (310 > 4434)) then
							if ((2168 <= 4360) and (v105 == 11111)) then
								v105 = v10.FightRemains(v108, false);
							end
							break;
						end
					end
				end
				if ((994 == 994) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v232 = 0;
					while true do
						if ((1655 > 401) and (1 == v232)) then
							if ((3063 <= 3426) and v14:AffectingCombat()) then
								local v242 = 0;
								while true do
									if ((1459 > 764) and (v242 == 0)) then
										v29 = v131();
										if (v29 or (641 > 4334)) then
											return v29;
										end
										break;
									end
								end
							else
								local v243 = 0;
								while true do
									if ((3399 >= 2260) and (0 == v243)) then
										v29 = v130();
										if (v29 or (393 >= 4242)) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if ((989 < 4859) and (v232 == 0)) then
							if (Focus or (4795 < 949)) then
								if ((3842 == 3842) and v83) then
									local v246 = 0;
									while true do
										if ((1747 <= 3601) and (v246 == 0)) then
											v29 = v123();
											if (v29 or (804 > 4359)) then
												return v29;
											end
											break;
										end
									end
								end
							end
							if ((4670 >= 3623) and v84) then
								local v244 = 0;
								while true do
									if ((2065 < 2544) and (v244 == 1)) then
										if ((1311 <= 3359) and v81) then
											local v247 = 0;
											while true do
												if ((2717 <= 3156) and (0 == v247)) then
													v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
													if ((1081 < 4524) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										break;
									end
									if ((440 >= 71) and (0 == v244)) then
										if ((4934 > 2607) and v79) then
											local v248 = 0;
											while true do
												if ((0 == v248) or (1400 > 3116)) then
													v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
													if ((525 < 1662) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if (v80 or (876 > 2550)) then
											local v249 = 0;
											while true do
												if ((219 <= 2456) and (v249 == 0)) then
													v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
													if (v29 or (4219 == 1150)) then
														return v29;
													end
													break;
												end
											end
										end
										v244 = 1;
									end
								end
							end
							v232 = 1;
						end
					end
				end
				break;
			end
			if ((v162 == 2) or (2989 <= 222)) then
				if ((2258 > 1241) and v14:IsDeadOrGhost()) then
					return;
				end
				v108 = v14:GetEnemiesInRange(40);
				v109 = v17:GetEnemiesInSplashRange(5);
				if ((41 < 4259) and v31) then
					local v233 = 0;
					while true do
						if ((v233 == 0) or (1930 < 56)) then
							v110 = #v108;
							v111 = max(v17:GetEnemiesInSplashRangeCount(5), v110);
							break;
						end
					end
				else
					local v234 = 0;
					while true do
						if ((3333 == 3333) and (v234 == 0)) then
							v110 = 1;
							v111 = 1;
							break;
						end
					end
				end
				v162 = 3;
			end
		end
	end
	local function v136()
		local v163 = 0;
		while true do
			if ((v163 == 0) or (2225 == 20)) then
				v98['FlameShockDebuff']:RegisterAuraTracking();
				v103();
				v163 = 1;
			end
			if ((1 == v163) or (872 >= 3092)) then
				v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(262, v135, v136);
end;
return v0["Epix_Shaman_Elemental.lua"]();

