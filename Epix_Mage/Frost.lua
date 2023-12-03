local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (2187 >= 4954)) then
			v6 = v0[v4];
			if (not v6 or (3877 == 3575)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((707 > 632) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['Target'];
	local v16 = v12['Focus'];
	local v17 = v12['MouseOver'];
	local v18 = v12['Pet'];
	local v19 = v10['Spell'];
	local v20 = v10['MultiSpell'];
	local v21 = v10['Item'];
	local v22 = EpicLib;
	local v23 = v22['Cast'];
	local v24 = v22['Press'];
	local v25 = v22['PressCursor'];
	local v26 = v22['Macro'];
	local v27 = v22['Bind'];
	local v28 = v22['Commons']['Everyone']['num'];
	local v29 = v22['Commons']['Everyone']['bool'];
	local v30 = math['max'];
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
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98 = v19['Mage']['Frost'];
	local v99 = v21['Mage']['Frost'];
	local v100 = v26['Mage']['Frost'];
	local v101 = {};
	local v102, v103;
	local v104;
	local v105;
	local v106 = 0;
	local v107 = 0;
	local v108 = 15;
	local v109 = 11111;
	local v110 = 11111;
	local v111;
	local v112 = v22['Commons']['Everyone'];
	local function v113()
		if (v98['RemoveCurse']:IsAvailable() or (546 >= 2684)) then
			v112['DispellableDebuffs'] = v112['DispellableCurseDebuffs'];
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98['FrozenOrb']:RegisterInFlightEffect(84721);
	v98['FrozenOrb']:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98['FrozenOrb']:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98['Frostbolt']:RegisterInFlightEffect(228597);
	v98['Frostbolt']:RegisterInFlight();
	v98['Flurry']:RegisterInFlightEffect(228354);
	v98['Flurry']:RegisterInFlight();
	v98['IceLance']:RegisterInFlightEffect(228598);
	v98['IceLance']:RegisterInFlight();
	v98['GlacialSpike']:RegisterInFlightEffect(228600);
	v98['GlacialSpike']:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v132 = 0;
		while true do
			if ((1465 <= 4301) and (1 == v132)) then
				v106 = 0;
				break;
			end
			if ((1704 > 1425) and (v132 == 0)) then
				v109 = 11111;
				v110 = 11111;
				v132 = 1;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v133)
		local v134 = 0;
		while true do
			if ((v134 == 0) or (687 == 4234)) then
				if ((v133 == nil) or (3330 < 1429)) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < 73);
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v135)
		local v136 = 0;
		local v137;
		while true do
			if ((1147 >= 335) and (v136 == 0)) then
				if ((3435 > 2097) and (v98['WintersChillDebuff']:AuraActiveCount() == 0)) then
					return 0;
				end
				v137 = 0;
				v136 = 1;
			end
			if ((v136 == 1) or (3770 >= 4041)) then
				for v211, v212 in pairs(v135) do
					v137 = v137 + v212:DebuffStack(v98.WintersChillDebuff);
				end
				return v137;
			end
		end
	end
	local function v117(v138)
		return (v138:DebuffStack(v98.WintersChillDebuff));
	end
	local function v118(v139)
		return (v139:DebuffDown(v98.WintersChillDebuff));
	end
	local function v119()
		local v140 = 0;
		while true do
			if ((v140 == 2) or (3791 <= 1611)) then
				if ((v98['MirrorImage']:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or (4578 <= 2008)) then
					if ((1125 <= 2076) and v24(v98.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v98['GreaterInvisibility']:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or (743 >= 4399)) then
					if ((1155 < 1673) and v24(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v140 = 3;
			end
			if ((v140 == 3) or (2324 <= 578)) then
				if ((3767 == 3767) and v98['AlterTime']:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
					if ((4089 == 4089) and v24(v98.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((4458 >= 1674) and v99['Healthstone']:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
					if ((972 <= 1418) and v24(v100.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v140 = 4;
			end
			if ((v140 == 1) or (4938 < 4762)) then
				if ((v98['IceColdTalent']:IsAvailable() and v98['IceColdAbility']:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or (2504 > 4264)) then
					if ((2153 == 2153) and v24(v98.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98['IceBlock']:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or (507 >= 2591)) then
					if ((4481 == 4481) and v24(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v140 = 2;
			end
			if ((v140 == 4) or (2328 < 693)) then
				if ((4328 == 4328) and v84 and (v14:HealthPercentage() <= v86)) then
					local v213 = 0;
					while true do
						if ((1588 >= 1332) and (v213 == 0)) then
							if ((v88 == "Refreshing Healing Potion") or (4174 > 4248)) then
								if (v99['RefreshingHealingPotion']:IsReady() or (4586 <= 82)) then
									if ((3863 == 3863) and v24(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or (282 <= 42)) then
								if ((4609 >= 766) and v99['DreamwalkersHealingPotion']:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or (1152 == 2488)) then
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
			if ((3422 > 3350) and (v140 == 0)) then
				if ((877 > 376) and v98['IceBarrier']:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v98.IceBarrier) or (3118 <= 1851)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98['MassBarrier']:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2)) or (165 >= 3492)) then
					if ((3949 < 4856) and v24(v98.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v140 = 1;
			end
		end
	end
	local function v120()
		if ((v98['RemoveCurse']:IsReady() and v35 and v112.DispellableFriendlyUnit(20)) or (4276 < 3016)) then
			if ((4690 > 4125) and v24(v100.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v121()
		local v141 = 0;
		while true do
			if ((v141 == 1) or (50 >= 896)) then
				v31 = v112.HandleBottomTrinket(v101, v34, 40, nil);
				if (v31 or (1714 >= 2958)) then
					return v31;
				end
				break;
			end
			if ((0 == v141) or (1491 < 644)) then
				v31 = v112.HandleTopTrinket(v101, v34, 40, nil);
				if ((704 < 987) and v31) then
					return v31;
				end
				v141 = 1;
			end
		end
	end
	local function v122()
		if ((3718 > 1906) and v112.TargetIsValid()) then
			local v155 = 0;
			while true do
				if ((v155 == 0) or (958 > 3635)) then
					if ((3501 <= 4492) and v98['MirrorImage']:IsCastable() and v68 and v96) then
						if (v24(v98.MirrorImage) or (3442 < 2548)) then
							return "mirror_image precombat 2";
						end
					end
					if ((2875 >= 1464) and v98['Frostbolt']:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
						if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt)) or (4797 >= 4893)) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v142 = 0;
		local v143;
		while true do
			if ((v142 == 1) or (551 > 2068)) then
				if ((2114 > 944) and v143) then
					return v143;
				end
				if ((v98['IcyVeins']:IsCastable() and v34 and v52 and v57 and (v83 < v110)) or (2262 >= 3096)) then
					if (v24(v98.IcyVeins) or (2255 >= 3537)) then
						return "icy_veins cd 6";
					end
				end
				v142 = 2;
			end
			if ((v142 == 0) or (3837 < 1306)) then
				if ((2950 == 2950) and v95 and v98['TimeWarp']:IsCastable() and v14:BloodlustExhaustUp() and v98['TemporalWarp']:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1, v98.IcyVeins)) then
					if (v24(v98.TimeWarp, not v15:IsInRange(40)) or (4723 < 3298)) then
						return "time_warp cd 2";
					end
				end
				v143 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v142 = 1;
			end
			if ((1136 >= 154) and (v142 == 2)) then
				if ((v83 < v110) or (271 > 4748)) then
					if ((4740 >= 3152) and v90 and ((v34 and v91) or not v91)) then
						local v225 = 0;
						while true do
							if ((v225 == 0) or (2578 >= 3390)) then
								v31 = v121();
								if ((41 <= 1661) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((601 < 3560) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
					local v214 = 0;
					while true do
						if ((235 < 687) and (v214 == 0)) then
							if ((4549 > 1153) and v98['BloodFury']:IsCastable()) then
								if (v24(v98.BloodFury) or (4674 < 4672)) then
									return "blood_fury cd 10";
								end
							end
							if ((3668 < 4561) and v98['Berserking']:IsCastable()) then
								if (v24(v98.Berserking) or (455 == 3605)) then
									return "berserking cd 12";
								end
							end
							v214 = 1;
						end
						if ((v214 == 1) or (2663 == 3312)) then
							if ((4277 <= 4475) and v98['LightsJudgment']:IsCastable()) then
								if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or (870 == 1189)) then
									return "lights_judgment cd 14";
								end
							end
							if ((1553 <= 3133) and v98['Fireblood']:IsCastable()) then
								if (v24(v98.Fireblood) or (2237 >= 3511)) then
									return "fireblood cd 16";
								end
							end
							v214 = 2;
						end
						if ((v214 == 2) or (1324 > 3020)) then
							if (v98['AncestralCall']:IsCastable() or (2992 == 1881)) then
								if ((3106 > 1526) and v24(v98.AncestralCall)) then
									return "ancestral_call cd 18";
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
	local function v124()
		local v144 = 0;
		while true do
			if ((3023 < 3870) and (v144 == 1)) then
				if ((143 > 74) and v98['ArcaneExplosion']:IsCastable() and v36 and (v14:ManaPercentage() > 30) and (v103 >= 2)) then
					if ((18 < 2112) and v24(v98.ArcaneExplosion, not v15:IsInRange(30))) then
						return "arcane_explosion movement";
					end
				end
				if ((1097 <= 1628) and v98['FireBlast']:IsCastable() and UseFireblast) then
					if ((4630 == 4630) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v144 = 2;
			end
			if ((3540 > 2683) and (v144 == 2)) then
				if ((4794 >= 3275) and v98['IceLance']:IsCastable() and v47) then
					if ((1484 == 1484) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if ((1432 < 3555) and (v144 == 0)) then
				if ((v98['IceFloes']:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or (1065 > 3578)) then
					if (v24(v98.IceFloes) or (4795 < 1407)) then
						return "ice_floes movement";
					end
				end
				if ((1853 < 4813) and v98['IceNova']:IsCastable() and v48) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or (2821 < 2431)) then
						return "ice_nova movement";
					end
				end
				v144 = 1;
			end
		end
	end
	local function v125()
		local v145 = 0;
		while true do
			if ((v145 == 2) or (2874 < 2181)) then
				if ((v98['FrostNova']:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1, v98.Freeze) and ((v14:PrevGCDP(1, v98.GlacialSpike) and (v106 == 0)) or (v98['ConeofCold']:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < 1)))) or (2689 <= 343)) then
					if (v24(v98.FrostNova) or (1869 == 2009)) then
						return "frost_nova aoe 12";
					end
				end
				if ((v98['ConeofCold']:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or (3546 < 2322)) then
					if (v24(v98.ConeofCold) or (2082 == 4773)) then
						return "cone_of_cold aoe 14";
					end
				end
				if ((3244 > 1055) and v98['ShiftingPower']:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(40), true) or (3313 <= 1778)) then
						return "shifting_power aoe 16";
					end
				end
				v145 = 3;
			end
			if ((v145 == 5) or (1421 >= 2104)) then
				if ((1812 <= 3249) and v98['ArcaneExplosion']:IsCastable() and v36 and (v14:ManaPercentage() > 30) and (v103 >= 7)) then
					if ((1623 <= 1957) and v24(v98.ArcaneExplosion, not v15:IsInRange(30))) then
						return "arcane_explosion aoe 28";
					end
				end
				if ((4412 == 4412) and v98['Frostbolt']:IsCastable() and v41) then
					if ((1750 >= 842) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if ((4372 > 1850) and v14:IsMoving() and v94) then
					local v215 = 0;
					local v216;
					while true do
						if ((232 < 821) and (0 == v215)) then
							v216 = v124();
							if ((518 < 902) and v216) then
								return v216;
							end
							break;
						end
					end
				end
				break;
			end
			if ((2994 > 858) and (v145 == 4)) then
				if ((v98['IceLance']:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98['IceLance']:TravelTime()) or v29(v106))) or (3755 <= 915)) then
					if ((3946 > 3743) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v98['IceNova']:IsCastable() and v48 and (v102 >= 4) and ((not v98['Snowstorm']:IsAvailable() and not v98['GlacialSpike']:IsAvailable()) or not v114())) or (1335 >= 3306)) then
					if ((4844 > 2253) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if ((452 == 452) and v98['DragonsBreath']:IsCastable() and v39 and (v103 >= 7)) then
					if (v24(v98.DragonsBreath) or (4557 < 2087)) then
						return "dragons_breath aoe 26";
					end
				end
				v145 = 5;
			end
			if ((3874 == 3874) and (v145 == 3)) then
				if ((v98['GlacialSpike']:IsReady() and v45 and (v107 == 5) and (v98['Blizzard']:CooldownRemains() > v111)) or (1938 > 4935)) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (4255 < 3423)) then
						return "glacial_spike aoe 18";
					end
				end
				if ((1454 <= 2491) and v98['Flurry']:IsCastable() and v43 and not v114() and (v106 == 0) and (v14:PrevGCDP(1, v98.GlacialSpike) or (v98['Flurry']:ChargesFractional() > 1.8))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or (4157 <= 2803)) then
						return "flurry aoe 20";
					end
				end
				if ((4853 >= 2982) and v98['Flurry']:IsCastable() and v43 and (v106 == 0) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if ((4134 > 3357) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 21";
					end
				end
				v145 = 4;
			end
			if ((v145 == 1) or (3417 < 2534)) then
				if ((v98['CometStorm']:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1, v98.GlacialSpike) and (not v98['ColdestSnap']:IsAvailable() or (v98['ConeofCold']:CooldownUp() and (v98['FrozenOrb']:CooldownRemains() > 25)) or (v98['ConeofCold']:CooldownRemains() > 20))) or (2722 <= 164)) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or (2408 < 2109)) then
						return "comet_storm aoe 8";
					end
				end
				if ((v18:IsActive() and v44 and v98['Freeze']:IsReady() and v114() and (v115() == 0) and ((not v98['GlacialSpike']:IsAvailable() and not v98['Snowstorm']:IsAvailable()) or v14:PrevGCDP(1, v98.GlacialSpike) or (v98['ConeofCold']:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or (33 == 1455)) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or (443 >= 4015)) then
						return "freeze aoe 10";
					end
				end
				if ((3382 > 166) and v98['IceNova']:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1, v98.Freeze) and (v14:PrevGCDP(1, v98.GlacialSpike) or (v98['ConeofCold']:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < 1)))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or (280 == 3059)) then
						return "ice_nova aoe 11";
					end
				end
				v145 = 2;
			end
			if ((1881 > 1293) and (v145 == 0)) then
				if ((2357 == 2357) and v98['ConeofCold']:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98['ColdestSnap']:IsAvailable() and (v14:PrevGCDP(1, v98.CometStorm) or (v14:PrevGCDP(1, v98.FrozenOrb) and not v98['CometStorm']:IsAvailable()))) then
					if ((123 == 123) and v24(v98.ConeofCold)) then
						return "cone_of_cold aoe 2";
					end
				end
				if ((v98['FrozenOrb']:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1, v98.GlacialSpike) or not v114())) or (1056 >= 3392)) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(40)) or (1081 < 1075)) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v98['Blizzard']:IsCastable() and v38 and (not v14:PrevGCDP(1, v98.GlacialSpike) or not v114())) or (1049 >= 4432)) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(40)) or (4768 <= 846)) then
						return "blizzard aoe 6";
					end
				end
				v145 = 1;
			end
		end
	end
	local function v126()
		local v146 = 0;
		while true do
			if ((0 == v146) or (3358 <= 1420)) then
				if ((v98['CometStorm']:IsCastable() and (v14:PrevGCDP(1, v98.Flurry) or v14:PrevGCDP(1, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or (3739 <= 3005)) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or (1659 >= 2134)) then
						return "comet_storm cleave 2";
					end
				end
				if ((v98['Flurry']:IsCastable() and v43 and ((v14:PrevGCDP(1, v98.Frostbolt) and (v107 >= 3)) or v14:PrevGCDP(1, v98.GlacialSpike) or ((v107 >= 3) and (v107 < 5) and (v98['Flurry']:ChargesFractional() == 2)))) or (3260 < 2355)) then
					if (v112.CastTargetIf(v98.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v98.Flurry)) or (669 == 4223)) then
						return "flurry cleave 4";
					end
				end
				if ((v98['IceLance']:IsReady() and v47 and v98['GlacialSpike']:IsAvailable() and (v98['WintersChillDebuff']:AuraActiveCount() == 0) and (v107 == 4) and v14:BuffUp(v98.FingersofFrostBuff)) or (1692 < 588)) then
					if (v112.CastTargetIf(v98.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v98.IceLance)) or (4797 < 3651)) then
						return "ice_lance cleave 6";
					end
				end
				if ((v98['RayofFrost']:IsCastable() and (v106 == 1) and v49) or (4177 > 4850)) then
					if (v112.CastTargetIf(v98.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v98.RayofFrost)) or (400 > 1111)) then
						return "ray_of_frost cleave 8";
					end
				end
				v146 = 1;
			end
			if ((3051 > 1005) and (v146 == 1)) then
				if ((3693 <= 4382) and v98['GlacialSpike']:IsReady() and v45 and (v107 == 5) and (v98['Flurry']:CooldownUp() or (v106 > 0))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (3282 > 4100)) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v98['FrozenOrb']:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < 2) and (not v98['RayofFrost']:IsAvailable() or v98['RayofFrost']:CooldownDown())) or (3580 < 2844)) then
					if ((89 < 4490) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v98['ConeofCold']:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98['ColdestSnap']:IsAvailable() and (v98['CometStorm']:CooldownRemains() > 10) and (v98['FrozenOrb']:CooldownRemains() > 10) and (v106 == 0) and (v103 >= 3)) or (4983 < 1808)) then
					if ((3829 > 3769) and v24(v98.ConeofCold, not v15:IsSpellInRange(v98.ConeofCold))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((1485 <= 2904) and v98['Blizzard']:IsCastable() and v38 and (v103 >= 2) and v98['IceCaller']:IsAvailable() and v98['FreezingRain']:IsAvailable() and ((not v98['SplinteringCold']:IsAvailable() and not v98['RayofFrost']:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= 3))) then
					if ((4269 == 4269) and v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard))) then
						return "blizzard cleave 16";
					end
				end
				v146 = 2;
			end
			if ((387 <= 2782) and (v146 == 3)) then
				if ((v98['Frostbolt']:IsCastable() and v41) or (1899 <= 917)) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or (4312 <= 876)) then
						return "frostbolt cleave 26";
					end
				end
				if ((2232 <= 2596) and v14:IsMoving() and v94) then
					local v217 = 0;
					local v218;
					while true do
						if ((2095 < 3686) and (v217 == 0)) then
							v218 = v124();
							if (v218 or (1595 >= 4474)) then
								return v218;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v146 == 2) or (4619 < 2882)) then
				if ((v98['ShiftingPower']:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98['FrozenOrb']:CooldownRemains() > 10) and (not v98['CometStorm']:IsAvailable() or (v98['CometStorm']:CooldownRemains() > 10)) and (not v98['RayofFrost']:IsAvailable() or (v98['RayofFrost']:CooldownRemains() > 10))) or (v98['IcyVeins']:CooldownRemains() < 20))) or (294 >= 4831)) then
					if ((2029 <= 3084) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if ((v98['GlacialSpike']:IsReady() and v45 and (v107 == 5)) or (2037 == 2420)) then
					if ((4458 > 3904) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((436 >= 123) and v98['IceLance']:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(1, v98.GlacialSpike)) or (v106 > 0))) then
					if ((500 < 1816) and v112.CastTargetIf(v98.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
				end
				if ((3574 == 3574) and v98['IceNova']:IsCastable() and v48 and (v103 >= 4)) then
					if ((221 < 390) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v146 = 3;
			end
		end
	end
	local function v127()
		local v147 = 0;
		while true do
			if ((v147 == 1) or (2213 <= 1421)) then
				if ((3058 < 4860) and v98['RayofFrost']:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98['RayofFrost']:CastTime()) and (v106 == 1)) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or (1296 >= 4446)) then
						return "ray_of_frost single 8";
					end
				end
				if ((v98['GlacialSpike']:IsReady() and v45 and (v107 == 5) and ((v98['Flurry']:Charges() >= 1) or ((v106 > 0) and (v98['GlacialSpike']:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or (1393 > 4489)) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (4424 < 27)) then
						return "glacial_spike single 10";
					end
				end
				if ((v98['FrozenOrb']:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == 0) and (v14:BuffStackP(v98.FingersofFrostBuff) < 2) and (not v98['RayofFrost']:IsAvailable() or v98['RayofFrost']:CooldownDown())) or (1997 > 3815)) then
					if ((3465 > 1913) and v24(v100.FrozenOrbCast, not v15:IsInRange(40))) then
						return "frozen_orb single 12";
					end
				end
				v147 = 2;
			end
			if ((733 < 1819) and (v147 == 4)) then
				if ((v89 and ((v92 and v34) or not v92)) or (4395 == 4755)) then
					if (v98['BagofTricks']:IsCastable() or (3793 < 2369)) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or (4084 == 265)) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((4358 == 4358) and v98['Frostbolt']:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or (3138 < 993)) then
						return "frostbolt single 26";
					end
				end
				if ((3330 > 2323) and v14:IsMoving() and v94) then
					local v219 = 0;
					local v220;
					while true do
						if ((v219 == 0) or (3626 == 3989)) then
							v220 = v124();
							if (v220 or (916 == 2671)) then
								return v220;
							end
							break;
						end
					end
				end
				break;
			end
			if ((272 == 272) and (0 == v147)) then
				if ((4249 <= 4839) and v98['CometStorm']:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1, v98.Flurry) or v14:PrevGCDP(1, v98.ConeofCold))) then
					if ((2777 < 3200) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if ((95 < 1957) and v98['Flurry']:IsCastable() and (v106 == 0) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1, v98.Frostbolt) and (v107 >= 3)) or (v14:PrevGCDP(1, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1, v98.GlacialSpike) or (v98['GlacialSpike']:IsAvailable() and (v107 == 4) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if ((826 < 1717) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if ((1426 >= 1105) and v98['IceLance']:IsReady() and v47 and v98['GlacialSpike']:IsAvailable() and not v98['GlacialSpike']:InFlight() and (v106 == 0) and (v107 == 4) and v14:BuffUp(v98.FingersofFrostBuff)) then
					if ((2754 <= 3379) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v147 = 1;
			end
			if ((v147 == 2) or (3927 == 1413)) then
				if ((v98['ConeofCold']:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98['ColdestSnap']:IsAvailable() and (v98['CometStorm']:CooldownRemains() > 10) and (v98['FrozenOrb']:CooldownRemains() > 10) and (v106 == 0) and (v102 >= 3)) or (1154 <= 788)) then
					if (v24(v98.ConeofCold) or (1643 > 3379)) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98['Blizzard']:IsCastable() and v38 and (v102 >= 2) and v98['IceCaller']:IsAvailable() and v98['FreezingRain']:IsAvailable() and ((not v98['SplinteringCold']:IsAvailable() and not v98['RayofFrost']:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= 3))) or (2803 > 4549)) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(40)) or (220 >= 3022)) then
						return "blizzard single 16";
					end
				end
				if ((2822 == 2822) and v98['ShiftingPower']:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == 0) and (((v98['FrozenOrb']:CooldownRemains() > 10) and (not v98['CometStorm']:IsAvailable() or (v98['CometStorm']:CooldownRemains() > 10)) and (not v98['RayofFrost']:IsAvailable() or (v98['RayofFrost']:CooldownRemains() > 10))) or (v98['IcyVeins']:CooldownRemains() < 20))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(40)) or (1061 == 1857)) then
						return "shifting_power single 18";
					end
				end
				v147 = 3;
			end
			if ((2760 > 1364) and (v147 == 3)) then
				if ((v98['GlacialSpike']:IsReady() and v45 and (v107 == 5)) or (4902 <= 3595)) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (3852 == 293)) then
						return "glacial_spike single 20";
					end
				end
				if ((v98['IceLance']:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1, v98.GlacialSpike) and not v98['GlacialSpike']:InFlight()) or v29(v106))) or (1559 == 4588)) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or (4484 == 788)) then
						return "ice_lance single 22";
					end
				end
				if ((4568 >= 3907) and v98['IceNova']:IsCastable() and v48 and (v103 >= 4)) then
					if ((1246 < 3470) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v147 = 4;
			end
		end
	end
	local function v128()
		local v148 = 0;
		while true do
			if ((4068 >= 972) and (v148 == 4)) then
				v56 = EpicSettings['Settings']['useShiftingPower'];
				v57 = EpicSettings['Settings']['icyVeinsWithCD'];
				v58 = EpicSettings['Settings']['frozenOrbWithCD'];
				v59 = EpicSettings['Settings']['cometStormWithCD'];
				v60 = EpicSettings['Settings']['coneOfColdWithCD'];
				v148 = 5;
			end
			if ((493 < 3893) and (v148 == 6)) then
				v66 = EpicSettings['Settings']['useIceCold'];
				v67 = EpicSettings['Settings']['useMassBarrier'];
				v68 = EpicSettings['Settings']['useMirrorImage'];
				v69 = EpicSettings['Settings']['alterTimeHP'] or 0;
				v70 = EpicSettings['Settings']['iceBarrierHP'] or 0;
				v148 = 7;
			end
			if ((v148 == 5) or (1473 >= 3332)) then
				v61 = EpicSettings['Settings']['shiftingPowerWithCD'];
				v62 = EpicSettings['Settings']['useAlterTime'];
				v63 = EpicSettings['Settings']['useIceBarrier'];
				v64 = EpicSettings['Settings']['useGreaterInvisibility'];
				v65 = EpicSettings['Settings']['useIceBlock'];
				v148 = 6;
			end
			if ((v148 == 7) or (4051 <= 1157)) then
				v73 = EpicSettings['Settings']['iceColdHP'] or 0;
				v71 = EpicSettings['Settings']['greaterInvisibilityHP'] or 0;
				v72 = EpicSettings['Settings']['iceBlockHP'] or 0;
				v74 = EpicSettings['Settings']['mirrorImageHP'] or 0;
				v75 = EpicSettings['Settings']['massBarrierHP'] or 0;
				v148 = 8;
			end
			if ((604 < 2881) and (v148 == 0)) then
				v36 = EpicSettings['Settings']['useArcaneExplosion'];
				v37 = EpicSettings['Settings']['useArcaneIntellect'];
				v38 = EpicSettings['Settings']['useBlizzard'];
				v39 = EpicSettings['Settings']['useDragonsBreath'];
				v40 = EpicSettings['Settings']['useFireBlast'];
				v148 = 1;
			end
			if ((v148 == 8) or (900 == 3377)) then
				v93 = EpicSettings['Settings']['useSpellStealTarget'];
				v94 = EpicSettings['Settings']['useSpellsWhileMoving'];
				v95 = EpicSettings['Settings']['useTimeWarpWithTalent'];
				v96 = EpicSettings['Settings']['mirrorImageBeforePull'];
				v97 = EpicSettings['Settings']['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((4459 > 591) and (v148 == 1)) then
				v41 = EpicSettings['Settings']['useFrostbolt'];
				v42 = EpicSettings['Settings']['useFrostNova'];
				v43 = EpicSettings['Settings']['useFlurry'];
				v44 = EpicSettings['Settings']['useFreezePet'];
				v45 = EpicSettings['Settings']['useGlacialSpike'];
				v148 = 2;
			end
			if ((3398 >= 2395) and (v148 == 2)) then
				v46 = EpicSettings['Settings']['useIceFloes'];
				v47 = EpicSettings['Settings']['useIceLance'];
				v48 = EpicSettings['Settings']['useIceNova'];
				v49 = EpicSettings['Settings']['useRayOfFrost'];
				v50 = EpicSettings['Settings']['useCounterspell'];
				v148 = 3;
			end
			if ((v148 == 3) or (2183 >= 2824)) then
				v51 = EpicSettings['Settings']['useBlastWave'];
				v52 = EpicSettings['Settings']['useIcyVeins'];
				v53 = EpicSettings['Settings']['useFrozenOrb'];
				v54 = EpicSettings['Settings']['useCometStorm'];
				v55 = EpicSettings['Settings']['useConeOfCold'];
				v148 = 4;
			end
		end
	end
	local function v129()
		local v149 = 0;
		while true do
			if ((1936 == 1936) and (v149 == 0)) then
				v83 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v80 = EpicSettings['Settings']['InterruptWithStun'];
				v81 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v149 = 1;
			end
			if ((v149 == 4) or (4832 < 4313)) then
				v87 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v86 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v88 = EpicSettings['Settings']['HealingPotionName'] or "";
				v149 = 5;
			end
			if ((4088 > 3874) and (v149 == 5)) then
				v78 = EpicSettings['Settings']['handleAfflicted'];
				v79 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((4332 == 4332) and (v149 == 2)) then
				v90 = EpicSettings['Settings']['useTrinkets'];
				v89 = EpicSettings['Settings']['useRacials'];
				v91 = EpicSettings['Settings']['trinketsWithCD'];
				v149 = 3;
			end
			if ((3999 >= 2900) and (3 == v149)) then
				v92 = EpicSettings['Settings']['racialsWithCD'];
				v85 = EpicSettings['Settings']['useHealthstone'];
				v84 = EpicSettings['Settings']['useHealingPotion'];
				v149 = 4;
			end
			if ((1 == v149) or (2525 > 4064)) then
				v82 = EpicSettings['Settings']['InterruptThreshold'];
				v77 = EpicSettings['Settings']['DispelDebuffs'];
				v76 = EpicSettings['Settings']['DispelBuffs'];
				v149 = 2;
			end
		end
	end
	local function v130()
		local v150 = 0;
		while true do
			if ((4371 == 4371) and (v150 == 0)) then
				v128();
				v129();
				v32 = EpicSettings['Toggles']['ooc'];
				v150 = 1;
			end
			if ((v150 == 4) or (266 > 4986)) then
				if ((1991 >= 925) and v112.TargetIsValid()) then
					local v221 = 0;
					while true do
						if ((455 < 2053) and (2 == v221)) then
							if (v14:AffectingCombat() or v77 or (826 == 4851)) then
								local v226 = 0;
								local v227;
								while true do
									if ((183 == 183) and (v226 == 0)) then
										v227 = v77 and v98['RemoveCurse']:IsReady() and v35;
										v31 = v112.FocusUnit(v227, v100, 20, nil, 20);
										v226 = 1;
									end
									if ((1159 <= 1788) and (v226 == 1)) then
										if (v31 or (3507 > 4318)) then
											return v31;
										end
										break;
									end
								end
							end
							if (v78 or (3075 <= 2965)) then
								if ((1365 <= 2011) and v97) then
									local v231 = 0;
									while true do
										if ((0 == v231) or (2776 > 3575)) then
											v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 30);
											if (v31 or (2554 == 4804)) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v221 = 3;
						end
						if ((2577 == 2577) and (v221 == 4)) then
							if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or (6 >= 1889)) then
								local v228 = 0;
								while true do
									if ((506 <= 1892) and (v228 == 1)) then
										if ((v33 and (v103 == 2)) or (2008 > 2218)) then
											local v233 = 0;
											while true do
												if ((379 <= 4147) and (v233 == 1)) then
													if (v24(v98.Pool) or (4514 <= 1009)) then
														return "pool for Cleave()";
													end
													break;
												end
												if ((v233 == 0) or (3496 == 1192)) then
													v31 = v126();
													if (v31 or (208 == 2959)) then
														return v31;
													end
													v233 = 1;
												end
											end
										end
										v31 = v127();
										v228 = 2;
									end
									if ((4277 >= 1313) and (v228 == 0)) then
										if ((2587 < 3174) and v34) then
											local v234 = 0;
											while true do
												if ((0 == v234) or (4120 <= 2198)) then
													v31 = v123();
													if (v31 or (1596 == 858)) then
														return v31;
													end
													break;
												end
											end
										end
										if ((3220 == 3220) and v33 and (((v103 >= 7) and not v14:HasTier(30, 2)) or ((v103 >= 3) and v98['IceCaller']:IsAvailable()))) then
											local v235 = 0;
											while true do
												if ((v235 == 1) or (1402 > 3620)) then
													if ((2574 == 2574) and v24(v98.Pool)) then
														return "pool for Aoe()";
													end
													break;
												end
												if ((1798 < 2757) and (v235 == 0)) then
													v31 = v125();
													if (v31 or (377 > 2604)) then
														return v31;
													end
													v235 = 1;
												end
											end
										end
										v228 = 1;
									end
									if ((568 < 911) and (v228 == 3)) then
										if ((3285 < 4228) and v94) then
											local v236 = 0;
											while true do
												if ((3916 > 3328) and (v236 == 0)) then
													v31 = v124();
													if ((2500 < 3839) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
									if ((507 == 507) and (v228 == 2)) then
										if ((240 <= 3165) and v31) then
											return v31;
										end
										if ((834 >= 805) and v24(v98.Pool)) then
											return "pool for ST()";
										end
										v228 = 3;
									end
								end
							end
							break;
						end
						if ((v221 == 3) or (3812 < 2316)) then
							if (v79 or (2652 <= 1533)) then
								local v229 = 0;
								while true do
									if ((v229 == 0) or (3598 < 1460)) then
										v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 30, true);
										if (v31 or (4116 < 1192)) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v98['Spellsteal']:IsAvailable() and v93 and v98['Spellsteal']:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) or (3377 <= 903)) then
								if ((3976 >= 439) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v221 = 4;
						end
						if ((3752 == 3752) and (v221 == 0)) then
							if ((4046 > 2695) and v16) then
								if (v77 or (3545 == 3197)) then
									local v232 = 0;
									while true do
										if ((2394 > 373) and (0 == v232)) then
											v31 = v120();
											if ((4155 <= 4232) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or (3581 == 3473)) then
								local v230 = 0;
								while true do
									if ((4995 > 3348) and (0 == v230)) then
										v31 = v122();
										if (v31 or (754 > 3724)) then
											return v31;
										end
										break;
									end
								end
							end
							v221 = 1;
						end
						if ((217 >= 57) and (v221 == 1)) then
							v31 = v119();
							if (v31 or (2070 >= 4037)) then
								return v31;
							end
							v221 = 2;
						end
					end
				end
				break;
			end
			if ((2705 == 2705) and (v150 == 2)) then
				if ((61 == 61) and v14:IsDeadOrGhost()) then
					return;
				end
				v105 = v15:GetEnemiesInSplashRange(5);
				Enemies40yRange = v14:GetEnemiesInRange(40);
				v150 = 3;
			end
			if ((v150 == 1) or (699 >= 1296)) then
				v33 = EpicSettings['Toggles']['aoe'];
				v34 = EpicSettings['Toggles']['cds'];
				v35 = EpicSettings['Toggles']['dispel'];
				v150 = 2;
			end
			if ((v150 == 3) or (1783 >= 3616)) then
				if (v33 or (3913 > 4527)) then
					local v222 = 0;
					while true do
						if ((4376 > 817) and (0 == v222)) then
							v102 = v30(v15:GetEnemiesInSplashRangeCount(5), #Enemies40yRange);
							v103 = v30(v15:GetEnemiesInSplashRangeCount(5), #Enemies40yRange);
							break;
						end
					end
				else
					local v223 = 0;
					while true do
						if ((4861 > 824) and (v223 == 1)) then
							v103 = 1;
							break;
						end
						if ((v223 == 0) or (1383 >= 2131)) then
							v104 = 1;
							v102 = 1;
							v223 = 1;
						end
					end
				end
				if (not v14:AffectingCombat() or (1876 >= 2541)) then
					if ((1782 <= 3772) and v98['ArcaneIntellect']:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
						if (v24(v98.ArcaneIntellect) or (4700 < 813)) then
							return "arcane_intellect";
						end
					end
				end
				if ((3199 < 4050) and (v112.TargetIsValid() or v14:AffectingCombat())) then
					local v224 = 0;
					while true do
						if ((v224 == 0) or (4951 < 4430)) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v224 = 1;
						end
						if ((96 == 96) and (v224 == 2)) then
							v107 = v14:BuffStackP(v98.IciclesBuff);
							v111 = v14:GCD();
							break;
						end
						if ((v224 == 1) or (2739 > 4008)) then
							if ((v110 == 11111) or (23 == 1134)) then
								v110 = v10.FightRemains(Enemies40yRange, false);
							end
							v106 = v15:DebuffStack(v98.WintersChillDebuff);
							v224 = 2;
						end
					end
				end
				v150 = 4;
			end
		end
	end
	local function v131()
		local v151 = 0;
		while true do
			if ((0 == v151) or (2693 >= 4111)) then
				v113();
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(64, v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

