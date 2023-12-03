local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((1147 >= 335) and (v5 == 0)) then
			v6 = v0[v4];
			if ((3435 > 2097) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (3770 >= 4041)) then
			return v6(...);
		end
	end
end
v0["Epix_Shaman_Enhancement.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['Target'];
	local v16 = v10['Spell'];
	local v17 = v10['MultiSpell'];
	local v18 = v10['Item'];
	local v19 = EpicLib;
	local v20 = v19['Cast'];
	local v21 = v19['Macro'];
	local v22 = v19['Press'];
	local v23 = v19['Commons']['Everyone']['num'];
	local v24 = v19['Commons']['Everyone']['bool'];
	local v25 = GetWeaponEnchantInfo;
	local v26 = math['max'];
	local v27 = string['match'];
	local v28;
	local v29 = false;
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
	local v34;
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
	local v98 = v16['Shaman']['Enhancement'];
	local v99 = v18['Shaman']['Enhancement'];
	local v100 = v21['Shaman']['Enhancement'];
	local v101 = {};
	local v102, v103;
	local v104, v105;
	local v106, v107, v108, v109;
	local v110 = (v98['LavaBurst']:IsAvailable() and 2) or 1;
	local v111 = "Lightning Bolt";
	local v112 = 11111;
	local v113 = 11111;
	v10:RegisterForEvent(function()
		v110 = (v98['LavaBurst']:IsAvailable() and 2) or 1;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v141 = 0;
		while true do
			if ((1 == v141) or (3791 <= 1611)) then
				v113 = 11111;
				break;
			end
			if ((v141 == 0) or (4578 <= 2008)) then
				v111 = "Lightning Bolt";
				v112 = 11111;
				v141 = 1;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v114 = v19['Commons']['Everyone'];
	local function v115()
		if ((1125 <= 2076) and v98['CleanseSpirit']:IsAvailable()) then
			v114['DispellableDebuffs'] = v114['DispellableCurseDebuffs'];
		end
	end
	v10:RegisterForEvent(function()
		v115();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v116()
		for v165 = 1, 6, 1 do
			if (v27(v14:TotemName(v165), "Totem") or (743 >= 4399)) then
				return v165;
			end
		end
	end
	local function v117()
		local v142 = 0;
		local v143;
		while true do
			if ((1155 < 1673) and (v142 == 1)) then
				if ((v143 > 8) or (v143 > v98['FeralSpirit']:TimeSinceLastCast()) or (2324 <= 578)) then
					return 0;
				end
				return 8 - v143;
			end
			if ((3767 == 3767) and (v142 == 0)) then
				if ((4089 == 4089) and (not v98['AlphaWolf']:IsAvailable() or v14:BuffDown(v98.FeralSpiritBuff))) then
					return 0;
				end
				v143 = mathmin(v98['CrashLightning']:TimeSinceLastCast(), v98['ChainLightning']:TimeSinceLastCast());
				v142 = 1;
			end
		end
	end
	local function v118(v144)
		return (v144:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v119(v145)
		return (v145:DebuffRefreshable(v98.LashingFlamesDebuff));
	end
	local function v120(v146)
		return (v146:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v121(v147)
		return (v14:BuffDown(v98.PrimordialWaveBuff));
	end
	local function v122(v148)
		return (v15:DebuffRemains(v98.LashingFlamesDebuff));
	end
	local function v123(v149)
		return (v98['LashingFlames']:IsAvailable());
	end
	local function v124(v150)
		return v150:DebuffUp(v98.FlameShockDebuff) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6);
	end
	local function v125()
		if ((4458 >= 1674) and v98['CleanseSpirit']:IsReady() and v33 and v114.DispellableFriendlyUnit(25)) then
			if ((972 <= 1418) and v22(v100.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v126()
		local v151 = 0;
		while true do
			if ((v151 == 0) or (4938 < 4762)) then
				if (not Focus or not Focus:Exists() or not Focus:IsInRange(40) or (2504 > 4264)) then
					return;
				end
				if ((2153 == 2153) and Focus) then
					if (((Focus:HealthPercentage() <= v79) and v69 and v98['HealingSurge']:IsReady() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (507 >= 2591)) then
						if ((4481 == 4481) and v22(v100.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		if ((v14:HealthPercentage() <= v83) or (2328 < 693)) then
			if ((4328 == 4328) and v98['HealingSurge']:IsReady()) then
				if ((1588 >= 1332) and v22(v98.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v128()
		local v152 = 0;
		while true do
			if ((v152 == 2) or (4174 > 4248)) then
				if ((v99['Healthstone']:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or (4586 <= 82)) then
					if ((3863 == 3863) and v22(v100.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v71 and (v14:HealthPercentage() <= v81)) or (282 <= 42)) then
					local v225 = 0;
					while true do
						if ((4609 >= 766) and (0 == v225)) then
							if ((v92 == "Refreshing Healing Potion") or (1152 == 2488)) then
								if ((3422 > 3350) and v99['RefreshingHealingPotion']:IsReady()) then
									if ((877 > 376) and v22(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v92 == "Dreamwalker's Healing Potion") or (3118 <= 1851)) then
								if (v99['DreamwalkersHealingPotion']:IsReady() or (165 >= 3492)) then
									if ((3949 < 4856) and v22(v100.RefreshingHealingPotion)) then
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
			if ((v152 == 1) or (4276 < 3016)) then
				if ((4690 > 4125) and v98['HealingStreamTotem']:IsReady() and v68 and v114.AreUnitsBelowHealthPercentage(v77, v78)) then
					if (v22(v98.HealingStreamTotem) or (50 >= 896)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v98['HealingSurge']:IsReady() and v69 and (v14:HealthPercentage() <= v79) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (1714 >= 2958)) then
					if (v22(v98.HealingSurge) or (1491 < 644)) then
						return "healing_surge defensive 4";
					end
				end
				v152 = 2;
			end
			if ((704 < 987) and (v152 == 0)) then
				if ((3718 > 1906) and v98['AstralShift']:IsReady() and v66 and (v14:HealthPercentage() <= v74)) then
					if (v22(v98.AstralShift) or (958 > 3635)) then
						return "astral_shift defensive 1";
					end
				end
				if ((3501 <= 4492) and v98['AncestralGuidance']:IsReady() and v67 and v114.AreUnitsBelowHealthPercentage(v75, v76)) then
					if (v22(v98.AncestralGuidance) or (3442 < 2548)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v152 = 1;
			end
		end
	end
	local function v129()
		local v153 = 0;
		while true do
			if ((2875 >= 1464) and (v153 == 0)) then
				v28 = v114.HandleTopTrinket(v101, v31, 40, nil);
				if (v28 or (4797 >= 4893)) then
					return v28;
				end
				v153 = 1;
			end
			if ((v153 == 1) or (551 > 2068)) then
				v28 = v114.HandleBottomTrinket(v101, v31, 40, nil);
				if ((2114 > 944) and v28) then
					return v28;
				end
				break;
			end
		end
	end
	local function v130()
		local v154 = 0;
		while true do
			if ((v154 == 1) or (2262 >= 3096)) then
				if ((v98['DoomWinds']:IsCastable() and v53 and ((v58 and v31) or not v58)) or (2255 >= 3537)) then
					if (v22(v98.DoomWinds, not v15:IsSpellInRange(v98.DoomWinds)) or (3837 < 1306)) then
						return "doom_winds precombat 8";
					end
				end
				if ((2950 == 2950) and v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59)) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (4723 < 3298)) then
						return "sundering precombat 10";
					end
				end
				v154 = 2;
			end
			if ((1136 >= 154) and (0 == v154)) then
				if ((v98['WindfuryTotem']:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98['WindfuryTotem']:TimeSinceLastCast() > 90))) or (271 > 4748)) then
					if ((4740 >= 3152) and v22(v98.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v98['FeralSpirit']:IsCastable() and v52 and ((v57 and v31) or not v57)) or (2578 >= 3390)) then
					if ((41 <= 1661) and v22(v98.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v154 = 1;
			end
			if ((601 < 3560) and (v154 == 2)) then
				if ((235 < 687) and v98['Stormstrike']:IsReady() and v46) then
					if ((4549 > 1153) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v155 = 0;
		while true do
			if ((v155 == 4) or (4674 < 4672)) then
				if ((3668 < 4561) and v98['Stormstrike']:IsReady() and v46) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (455 == 3605)) then
						return "stormstrike single 25";
					end
				end
				if ((v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) or (2663 == 3312)) then
					if ((4277 <= 4475) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return "sundering single 26";
					end
				end
				if ((v98['BagofTricks']:IsReady() and v55 and ((v62 and v31) or not v62)) or (870 == 1189)) then
					if ((1553 <= 3133) and v22(v98.BagofTricks)) then
						return "bag_of_tricks single 27";
					end
				end
				if ((v98['FireNova']:IsReady() and v38 and v98['SwirlingMaelstrom']:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) < (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable()))))) or (2237 >= 3511)) then
					if (v22(v98.FireNova) or (1324 > 3020)) then
						return "fire_nova single 28";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and v98['Hailstorm']:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.PrimordialWaveBuff)) or (2992 == 1881)) then
					if ((3106 > 1526) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if ((3023 < 3870) and v98['FrostShock']:IsReady() and v40) then
					if ((143 > 74) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				v155 = 5;
			end
			if ((18 < 2112) and (v155 == 2)) then
				if ((1097 <= 1628) and v98['LavaBurst']:IsReady() and v42 and not v98['ThorimsInvocation']:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) then
					if ((4630 == 4630) and v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst single 13";
					end
				end
				if ((3540 > 2683) and v98['LightningBolt']:IsReady() and v44 and ((v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) or (v98['StaticAccumulation']:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5))) and v14:BuffDown(v98.PrimordialWaveBuff)) then
					if ((4794 >= 3275) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if ((1484 == 1484) and v98['CrashLightning']:IsReady() and v36 and v98['AlphaWolf']:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)) then
					if ((1432 < 3555) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return "crash_lightning single 15";
					end
				end
				if ((v98['PrimordialWave']:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113)) or (1065 > 3578)) then
					if (v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave)) or (4795 < 1407)) then
						return "primordial_wave single 16";
					end
				end
				if ((1853 < 4813) and v98['FlameShock']:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (2821 < 2431)) then
						return "flame_shock single 17";
					end
				end
				if ((v98['IceStrike']:IsReady() and v41 and v98['ElementalAssault']:IsAvailable() and v98['SwirlingMaelstrom']:IsAvailable()) or (2874 < 2181)) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (2689 <= 343)) then
						return "ice_strike single 18";
					end
				end
				v155 = 3;
			end
			if ((v155 == 3) or (1869 == 2009)) then
				if ((v98['LavaLash']:IsReady() and v43 and (v98['LashingFlames']:IsAvailable())) or (3546 < 2322)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (2082 == 4773)) then
						return "lava_lash single 19";
					end
				end
				if ((3244 > 1055) and v98['IceStrike']:IsReady() and v41 and (v14:BuffDown(v98.IceStrikeBuff))) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (3313 <= 1778)) then
						return "ice_strike single 20";
					end
				end
				if ((v98['FrostShock']:IsReady() and v40 and (v14:BuffUp(v98.HailstormBuff))) or (1421 >= 2104)) then
					if ((1812 <= 3249) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if ((1623 <= 1957) and v98['LavaLash']:IsReady() and v43) then
					if ((4412 == 4412) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if ((1750 >= 842) and v98['IceStrike']:IsReady() and v41) then
					if ((4372 > 1850) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return "ice_strike single 23";
					end
				end
				if ((232 < 821) and v98['Windstrike']:IsCastable() and v49) then
					if ((518 < 902) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v155 = 4;
			end
			if ((2994 > 858) and (v155 == 0)) then
				if ((v98['PrimordialWave']:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and v15:DebuffDown(v98.FlameShockDebuff) and v98['LashingFlames']:IsAvailable()) or (3755 <= 915)) then
					if ((3946 > 3743) and v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if ((v98['FlameShock']:IsReady() and v39 and v15:DebuffDown(v98.FlameShockDebuff) and v98['LashingFlames']:IsAvailable()) or (1335 >= 3306)) then
					if ((4844 > 2253) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if ((452 == 452) and v98['ElementalBlast']:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v98['ElementalSpirits']:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (4557 < 2087)) then
						return "elemental_blast single 3";
					end
				end
				if ((3874 == 3874) and v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:HasTier(30, 2))) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (1938 > 4935)) then
						return "sundering single 4";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.CracklingThunderBuff) and v14:BuffUp(v98.AscendanceBuff) and (v111 == "Chain Lightning") and (v14:BuffRemains(v98.AscendanceBuff) > (v98['ChainLightning']:CooldownRemains() + v14:GCD()))) or (4255 < 3423)) then
					if ((1454 <= 2491) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if ((v98['Stormstrike']:IsReady() and v46 and (v14:BuffUp(v98.DoomWindsBuff) or v98['DeeplyRootedElements']:IsAvailable() or (v98['Stormblast']:IsAvailable() and v14:BuffUp(v98.StormbringerBuff)))) or (4157 <= 2803)) then
					if ((4853 >= 2982) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				v155 = 1;
			end
			if ((4134 > 3357) and (v155 == 5)) then
				if ((v98['CrashLightning']:IsReady() and v36) or (3417 < 2534)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (2722 <= 164)) then
						return "crash_lightning single 31";
					end
				end
				if ((v98['FireNova']:IsReady() and v38 and (v15:DebuffUp(v98.FlameShockDebuff))) or (2408 < 2109)) then
					if (v22(v98.FireNova) or (33 == 1455)) then
						return "fire_nova single 32";
					end
				end
				if ((v98['FlameShock']:IsReady() and v39) or (443 >= 4015)) then
					if ((3382 > 166) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock single 33";
					end
				end
				if ((v98['ChainLightning']:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffUp(v98.CracklingThunderBuff) and v98['ElementalSpirits']:IsAvailable()) or (280 == 3059)) then
					if ((1881 > 1293) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning single 34";
					end
				end
				if ((2357 == 2357) and v98['LightningBolt']:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.PrimordialWaveBuff)) then
					if ((123 == 123) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 35";
					end
				end
				if ((v98['WindfuryTotem']:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98['WindfuryTotem']:TimeSinceLastCast() > 90))) or (1056 >= 3392)) then
					if (v22(v98.WindfuryTotem) or (1081 < 1075)) then
						return "windfury_totem single 36";
					end
				end
				break;
			end
			if ((v155 == 1) or (1049 >= 4432)) then
				if ((v98['LavaLash']:IsReady() and v43 and (v14:BuffUp(v98.HotHandBuff))) or (4768 <= 846)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (3358 <= 1420)) then
						return "lava_lash single 7";
					end
				end
				if ((v98['WindfuryTotem']:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true))) or (3739 <= 3005)) then
					if (v22(v98.WindfuryTotem) or (1659 >= 2134)) then
						return "windfury_totem single 8";
					end
				end
				if ((v98['ElementalBlast']:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and (v98['ElementalBlast']:Charges() == v110)) or (3260 < 2355)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (669 == 4223)) then
						return "elemental_blast single 9";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12))) or (1692 < 588)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (4797 < 3651)) then
						return "lightning_bolt single 10";
					end
				end
				if ((v98['ChainLightning']:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and v14:BuffUp(v98.CracklingThunderBuff) and v98['ElementalSpirits']:IsAvailable()) or (4177 > 4850)) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or (400 > 1111)) then
						return "chain_lightning single 11";
					end
				end
				if ((3051 > 1005) and v98['ElementalBlast']:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and (v14:BuffUp(v98.FeralSpiritBuff) or not v98['ElementalSpirits']:IsAvailable())) then
					if ((3693 <= 4382) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				v155 = 2;
			end
		end
	end
	local function v132()
		local v156 = 0;
		while true do
			if ((v156 == 0) or (3282 > 4100)) then
				if ((v98['CrashLightning']:IsReady() and v36 and v98['CrashingStorms']:IsAvailable() and ((v98['UnrulyWinds']:IsAvailable() and (v108 >= 10)) or (v108 >= 15))) or (3580 < 2844)) then
					if ((89 < 4490) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) >= 6)) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12) or (v96 <= v14:GCD()))) or (4983 < 1808)) then
					if ((3829 > 3769) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt aoe 2";
					end
				end
				if ((1485 <= 2904) and v98['LavaLash']:IsReady() and v43 and v98['MoltenAssault']:IsAvailable() and (v98['PrimordialWave']:IsAvailable() or v98['FireNova']:IsAvailable()) and v15:DebuffUp(v98.FlameShockDebuff) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) then
					if ((4269 == 4269) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if ((387 <= 2782) and v98['PrimordialWave']:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) then
					if (v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave)) or (1899 <= 917)) then
						return "primordial_wave aoe 4";
					end
				end
				if ((v98['FlameShock']:IsReady() and v39 and (v98['PrimordialWave']:IsAvailable() or v98['FireNova']:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) or (4312 <= 876)) then
					if ((2232 <= 2596) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((2095 < 3686) and v98['ElementalBlast']:IsReady() and v37 and (not v98['ElementalSpirits']:IsAvailable() or (v98['ElementalSpirits']:IsAvailable() and ((v98['ElementalBlast']:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (1595 >= 4474)) then
						return "elemental_blast aoe 6";
					end
				end
				v156 = 1;
			end
			if ((v156 == 2) or (4619 < 2882)) then
				if ((v98['IceStrike']:IsReady() and v41 and (v98['Hailstorm']:IsAvailable())) or (294 >= 4831)) then
					if ((2029 <= 3084) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v98['FrostShock']:IsReady() and v40 and v98['Hailstorm']:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) or (2037 == 2420)) then
					if ((4458 > 3904) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if ((436 >= 123) and v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
					if ((500 < 1816) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return "sundering aoe 15";
					end
				end
				if ((3574 == 3574) and v98['FlameShock']:IsReady() and v39 and v98['MoltenAssault']:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) then
					if ((221 < 390) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v98['FlameShock']:IsReady() and v39 and v15:DebuffRefreshable(v98.FlameShockDebuff) and (v98['FireNova']:IsAvailable() or v98['PrimordialWave']:IsAvailable()) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) or (2213 <= 1421)) then
					if ((3058 < 4860) and v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock aoe 17";
					end
				end
				if ((v98['FireNova']:IsReady() and v38 and (v98['FlameShockDebuff']:AuraActiveCount() >= 3)) or (1296 >= 4446)) then
					if (v22(v98.FireNova) or (1393 > 4489)) then
						return "fire_nova aoe 18";
					end
				end
				v156 = 3;
			end
			if ((3 == v156) or (4424 < 27)) then
				if ((v98['Stormstrike']:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and (v98['DeeplyRootedElements']:IsAvailable() or (v14:BuffStack(v98.ConvergingStormsBuff) == 6))) or (1997 > 3815)) then
					if ((3465 > 1913) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if ((733 < 1819) and v98['CrashLightning']:IsReady() and v36 and v98['CrashingStorms']:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= 4)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (4395 == 4755)) then
						return "crash_lightning aoe 20";
					end
				end
				if ((v98['Windstrike']:IsCastable() and v49) or (3793 < 2369)) then
					if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or (4084 == 265)) then
						return "windstrike aoe 21";
					end
				end
				if ((4358 == 4358) and v98['Stormstrike']:IsReady() and v46) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (3138 < 993)) then
						return "stormstrike aoe 22";
					end
				end
				if ((3330 > 2323) and v98['IceStrike']:IsReady() and v41) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (3626 == 3989)) then
						return "ice_strike aoe 23";
					end
				end
				if ((v98['LavaLash']:IsReady() and v43) or (916 == 2671)) then
					if ((272 == 272) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v156 = 4;
			end
			if ((4249 <= 4839) and (5 == v156)) then
				if ((2777 < 3200) and v98['FrostShock']:IsReady() and v40 and not v98['Hailstorm']:IsAvailable()) then
					if ((95 < 1957) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((826 < 1717) and (v156 == 1)) then
				if ((1426 >= 1105) and v98['ChainLightning']:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable()))))) then
					if ((2754 <= 3379) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v98['CrashLightning']:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98['AlphaWolf']:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)))) or (3927 == 1413)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (1154 <= 788)) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(30, 2))) or (1643 > 3379)) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (2803 > 4549)) then
						return "sundering aoe 9";
					end
				end
				if ((v98['FireNova']:IsReady() and v38 and ((v98['FlameShockDebuff']:AuraActiveCount() >= 6) or ((v98['FlameShockDebuff']:AuraActiveCount() >= 4) and (v98['FlameShockDebuff']:AuraActiveCount() >= v108)))) or (220 >= 3022)) then
					if ((2822 == 2822) and v22(v98.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if ((v98['LavaLash']:IsReady() and v43 and (v98['LashingFlames']:IsAvailable())) or (1061 == 1857)) then
					if ((2760 > 1364) and v114.CastCycle(v98.LavaLash, v107, v119, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 11";
					end
				end
				if ((v98['LavaLash']:IsReady() and v43 and ((v98['MoltenAssault']:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) or (v98['AshenCatalyst']:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == 5)))) or (4902 <= 3595)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (3852 == 293)) then
						return "lava_lash aoe 12";
					end
				end
				v156 = 2;
			end
			if ((v156 == 4) or (1559 == 4588)) then
				if ((v98['CrashLightning']:IsReady() and v36) or (4484 == 788)) then
					if ((4568 >= 3907) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return "crash_lightning aoe 25";
					end
				end
				if ((1246 < 3470) and v98['FireNova']:IsReady() and v38 and (v98['FlameShockDebuff']:AuraActiveCount() >= 2)) then
					if ((4068 >= 972) and v22(v98.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if ((493 < 3893) and v98['ElementalBlast']:IsReady() and v37 and (not v98['ElementalSpirits']:IsAvailable() or (v98['ElementalSpirits']:IsAvailable() and ((v98['ElementalBlast']:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (1473 >= 3332)) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v98['ChainLightning']:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (4051 <= 1157)) then
					if ((604 < 2881) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v98['WindfuryTotem']:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98['WindfuryTotem']:TimeSinceLastCast() > 90))) or (900 == 3377)) then
					if ((4459 > 591) and v22(v98.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if ((3398 >= 2395) and v98['FlameShock']:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (2183 >= 2824)) then
						return "flame_shock aoe 30";
					end
				end
				v156 = 5;
			end
		end
	end
	local function v133()
		local v157 = 0;
		while true do
			if ((1936 == 1936) and (v157 == 4)) then
				if ((v98['FlameShock']:IsReady() and v39 and v98['MoltenAssault']:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) or (4832 < 4313)) then
					if ((4088 > 3874) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock funnel 17";
					end
				end
				if ((4332 == 4332) and v98['FlameShock']:IsReady() and v39 and (v98['FireNova']:IsAvailable() or v98['PrimordialWave']:IsAvailable()) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) then
					if ((3999 >= 2900) and v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock funnel 18";
					end
				end
				if ((v98['FireNova']:IsReady() and v38 and (v98['FlameShockDebuff']:AuraActiveCount() >= 3)) or (2525 > 4064)) then
					if ((4371 == 4371) and v22(v98.FireNova)) then
						return "fire_nova funnel 19";
					end
				end
				if ((v98['Stormstrike']:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and v98['DeeplyRootedElements']:IsAvailable()) or (266 > 4986)) then
					if ((1991 >= 925) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike funnel 20";
					end
				end
				v157 = 5;
			end
			if ((455 < 2053) and (v157 == 0)) then
				if ((v98['LightningBolt']:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) == 6)) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12) or (v96 <= v14:GCD()))) or (826 == 4851)) then
					if ((183 == 183) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt funnel 1";
					end
				end
				if ((1159 <= 1788) and v98['LavaLash']:IsReady() and v43 and ((v98['MoltenAssault']:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98['FlameShockDebuff']:AuraActiveCount() < v108) and (v98['FlameShockDebuff']:AuraActiveCount() < 6)) or (v98['AshenCatalyst']:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == 5)))) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (3507 > 4318)) then
						return "lava_lash funnel 2";
					end
				end
				if ((v98['PrimordialWave']:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) or (3075 <= 2965)) then
					if ((1365 <= 2011) and v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave))) then
						return "primordial_wave funnel 3";
					end
				end
				if ((v98['FlameShock']:IsReady() and v39 and (v98['PrimordialWave']:IsAvailable() or v98['FireNova']:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) or (2776 > 3575)) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (2554 == 4804)) then
						return "flame_shock funnel 4";
					end
				end
				v157 = 1;
			end
			if ((2577 == 2577) and (v157 == 2)) then
				if ((v98['LavaBurst']:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable()))))) or (6 >= 1889)) then
					if ((506 <= 1892) and v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst funnel 9";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable()))))) or (2008 > 2218)) then
					if ((379 <= 4147) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt funnel 10";
					end
				end
				if ((v98['CrashLightning']:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98['AlphaWolf']:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)) or (v98['ConvergingStorms']:IsAvailable() and (v14:BuffStack(v98.ConvergingStormsBuff) < 6)))) or (4514 <= 1009)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (3496 == 1192)) then
						return "crash_lightning funnel 11";
					end
				end
				if ((v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(30, 2))) or (208 == 2959)) then
					if ((4277 >= 1313) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return "sundering funnel 12";
					end
				end
				v157 = 3;
			end
			if ((2587 < 3174) and (v157 == 5)) then
				if ((v98['CrashLightning']:IsReady() and v36 and v98['CrashingStorms']:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= 4)) or (4120 <= 2198)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (1596 == 858)) then
						return "crash_lightning funnel 21";
					end
				end
				if ((3220 == 3220) and v98['Windstrike']:IsCastable() and v49) then
					if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or (1402 > 3620)) then
						return "windstrike funnel 22";
					end
				end
				if ((2574 == 2574) and v98['Stormstrike']:IsReady() and v46) then
					if ((1798 < 2757) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike funnel 23";
					end
				end
				if ((v98['IceStrike']:IsReady() and v41) or (377 > 2604)) then
					if ((568 < 911) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return "ice_strike funnel 24";
					end
				end
				v157 = 6;
			end
			if ((3285 < 4228) and (8 == v157)) then
				if ((3916 > 3328) and v98['FrostShock']:IsReady() and v40 and not v98['Hailstorm']:IsAvailable()) then
					if ((2500 < 3839) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock funnel 33";
					end
				end
				break;
			end
			if ((507 == 507) and (v157 == 1)) then
				if ((240 <= 3165) and v98['ElementalBlast']:IsReady() and v37 and (not v98['ElementalSpirits']:IsAvailable() or (v98['ElementalSpirits']:IsAvailable() and ((v98['ElementalBlast']:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
					if ((834 >= 805) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast funnel 5";
					end
				end
				if ((v98['Windstrike']:IsCastable() and v49 and ((v98['ThorimsInvocation']:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) > 1)) or (v14:BuffStack(v98.ConvergingStormsBuff) == 6))) or (3812 < 2316)) then
					if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or (2652 <= 1533)) then
						return "windstrike funnel 6";
					end
				end
				if ((v98['Stormstrike']:IsReady() and v46 and (v14:BuffStack(v98.ConvergingStormsBuff) == 6)) or (3598 < 1460)) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (4116 < 1192)) then
						return "stormstrike funnel 7";
					end
				end
				if ((v98['ChainLightning']:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98['OverflowingMaelstrom']:IsAvailable())))) and v14:BuffUp(v98.CracklingThunderBuff)) or (3377 <= 903)) then
					if ((3976 >= 439) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return "chain_lightning funnel 8";
					end
				end
				v157 = 2;
			end
			if ((3752 == 3752) and (v157 == 3)) then
				if ((4046 > 2695) and v98['FireNova']:IsReady() and v38 and ((v98['FlameShockDebuff']:AuraActiveCount() == 6) or ((v98['FlameShockDebuff']:AuraActiveCount() >= 4) and (v98['FlameShockDebuff']:AuraActiveCount() >= v108)))) then
					if (v22(v98.FireNova) or (3545 == 3197)) then
						return "fire_nova funnel 13";
					end
				end
				if ((2394 > 373) and v98['IceStrike']:IsReady() and v41 and v98['Hailstorm']:IsAvailable() and v14:BuffDown(v98.IceStrikeBuff)) then
					if ((4155 <= 4232) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return "ice_strike funnel 14";
					end
				end
				if ((v98['FrostShock']:IsReady() and v40 and v98['Hailstorm']:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) or (3581 == 3473)) then
					if ((4995 > 3348) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock funnel 15";
					end
				end
				if ((v98['Sundering']:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) or (754 > 3724)) then
					if ((217 >= 57) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return "sundering funnel 16";
					end
				end
				v157 = 4;
			end
			if ((7 == v157) or (2070 >= 4037)) then
				if ((2705 == 2705) and v98['LavaBurst']:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) then
					if ((61 == 61) and v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst))) then
						return "lava_burst funnel 29";
					end
				end
				if ((v98['LightningBolt']:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (699 >= 1296)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (1783 >= 3616)) then
						return "lightning_bolt funnel 30";
					end
				end
				if ((v98['WindfuryTotem']:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98['WindfuryTotem']:TimeSinceLastCast() > 90))) or (3913 > 4527)) then
					if ((4376 > 817) and v22(v98.WindfuryTotem)) then
						return "windfury_totem funnel 31";
					end
				end
				if ((4861 > 824) and v98['FlameShock']:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (1383 >= 2131)) then
						return "flame_shock funnel 32";
					end
				end
				v157 = 8;
			end
			if ((6 == v157) or (1876 >= 2541)) then
				if ((1782 <= 3772) and v98['LavaLash']:IsReady() and v43) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (4700 < 813)) then
						return "lava_lash funnel 25";
					end
				end
				if ((3199 < 4050) and v98['CrashLightning']:IsReady() and v36) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (4951 < 4430)) then
						return "crash_lightning funnel 26";
					end
				end
				if ((96 == 96) and v98['FireNova']:IsReady() and v38 and (v98['FlameShockDebuff']:AuraActiveCount() >= 2)) then
					if (v22(v98.FireNova) or (2739 > 4008)) then
						return "fire_nova funnel 27";
					end
				end
				if ((v98['ElementalBlast']:IsReady() and v37 and (not v98['ElementalSpirits']:IsAvailable() or (v98['ElementalSpirits']:IsAvailable() and ((v98['ElementalBlast']:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or (23 == 1134)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (2693 >= 4111)) then
						return "elemental_blast funnel 28";
					end
				end
				v157 = 7;
			end
		end
	end
	local function v134()
		local v158 = 0;
		while true do
			if ((v158 == 1) or (4316 <= 2146)) then
				if (((not v103 or (v105 < 600000)) and v50 and v98['FlamentongueWeapon']:IsCastable()) or (3546 <= 2809)) then
					if ((4904 > 2166) and v22(v98.FlamentongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if ((109 >= 90) and v82) then
					local v226 = 0;
					while true do
						if ((4978 > 2905) and (v226 == 0)) then
							v28 = v127();
							if (v28 or (3026 <= 2280)) then
								return v28;
							end
							break;
						end
					end
				end
				v158 = 2;
			end
			if ((2 == v158) or (1653 <= 1108)) then
				if ((2909 > 2609) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					if ((757 > 194) and v22(v98.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v114.TargetIsValid() and v29) or (31 >= 1398)) then
					if ((3196 <= 4872) and not v14:AffectingCombat()) then
						local v237 = 0;
						local v238;
						while true do
							if ((3326 == 3326) and (v237 == 0)) then
								v238 = v130();
								if ((1433 <= 3878) and v238) then
									return v238;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v158 == 0) or (1583 == 1735)) then
				if ((v72 and v98['EarthShield']:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == "Earth Shield") or (v98['ElementalOrbit']:IsAvailable() and v14:BuffUp(v98.LightningShield)))) or (2981 == 2350)) then
					if (v22(v98.EarthShield) or (4466 <= 493)) then
						return "earth_shield main 2";
					end
				elseif ((v72 and v98['LightningShield']:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == "Lightning Shield") or (v98['ElementalOrbit']:IsAvailable() and v14:BuffUp(v98.EarthShield)))) or (2547 <= 1987)) then
					if ((2961 > 2740) and v22(v98.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if ((3696 >= 3612) and (not v102 or (v104 < 600000)) and v50 and v98['WindfuryWeapon']:IsCastable()) then
					if (v22(v98.WindfuryWeapon) or (2970 == 1878)) then
						return "windfury_weapon enchant";
					end
				end
				v158 = 1;
			end
		end
	end
	local function v135()
		local v159 = 0;
		while true do
			if ((v159 == 0) or (3693 < 1977)) then
				v28 = v128();
				if (v28 or (930 > 2101)) then
					return v28;
				end
				v159 = 1;
			end
			if ((4153 > 3086) and (v159 == 4)) then
				if (v28 or (4654 <= 4050)) then
					return v28;
				end
				if (v114.TargetIsValid() or (2602 < 1496)) then
					local v227 = 0;
					local v228;
					while true do
						if ((v227 == 2) or (1020 > 2288)) then
							if ((328 == 328) and v98['DoomWinds']:IsCastable() and v53 and ((v58 and v31) or not v58) and (v96 < v113)) then
								if ((1511 < 3808) and v22(v98.DoomWinds, not v15:IsInMeleeRange(5))) then
									return "doom_winds main 5";
								end
							end
							if ((v108 == 1) or (2510 > 4919)) then
								local v240 = 0;
								local v241;
								while true do
									if ((4763 == 4763) and (v240 == 0)) then
										v241 = v131();
										if ((4137 > 1848) and v241) then
											return v241;
										end
										break;
									end
								end
							end
							if ((2436 <= 3134) and v30 and (v108 > 1)) then
								local v242 = 0;
								local v243;
								while true do
									if ((3723 == 3723) and (v242 == 0)) then
										v243 = v132();
										if (v243 or (4046 >= 4316)) then
											return v243;
										end
										break;
									end
								end
							end
							if (v19.CastAnnotated(v98.Pool, false, "WAIT") or (2008 < 1929)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((2384 > 1775) and (v227 == 0)) then
							v228 = v114.HandleDPSPotion(v14:BuffUp(v98.FeralSpiritBuff));
							if (v228 or (4543 <= 4376)) then
								return v228;
							end
							if ((728 == 728) and (v96 < v113)) then
								if ((v54 and ((v31 and v61) or not v61)) or (1076 > 4671)) then
									local v252 = 0;
									while true do
										if ((1851 >= 378) and (v252 == 0)) then
											v28 = v129();
											if (v28 or (1948 >= 3476)) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if ((4794 >= 833) and (v96 < v113) and v55 and ((v62 and v31) or not v62)) then
								local v244 = 0;
								while true do
									if ((4090 == 4090) and (v244 == 1)) then
										if ((v98['Fireblood']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) or (3758 == 2498)) then
											if (v22(v98.Fireblood) or (2673 < 1575)) then
												return "fireblood racial";
											end
										end
										if ((v98['AncestralCall']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) or (3721 <= 1455)) then
											if ((934 < 2270) and v22(v98.AncestralCall)) then
												return "ancestral_call racial";
											end
										end
										break;
									end
									if ((v244 == 0) or (1612 == 1255)) then
										if ((v98['BloodFury']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98['Ascendance']:CooldownRemains() > 50))) or (4352 < 4206)) then
											if (v22(v98.BloodFury) or (2860 <= 181)) then
												return "blood_fury racial";
											end
										end
										if ((3222 >= 1527) and v98['Berserking']:IsCastable() and (not v98['Ascendance']:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
											if ((1505 <= 2121) and v22(v98.Berserking)) then
												return "berserking racial";
											end
										end
										v244 = 1;
									end
								end
							end
							v227 = 1;
						end
						if ((744 == 744) and (v227 == 1)) then
							if ((v98['Windstrike']:IsCastable() and v49) or (1979 >= 2836)) then
								if ((1833 <= 2668) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
									return "windstrike main 1";
								end
							end
							if ((3686 == 3686) and v98['PrimordialWave']:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:HasTier(31, 2))) then
								if ((3467 > 477) and v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if ((v98['FeralSpirit']:IsCastable() and v52 and ((v57 and v31) or not v57) and (v96 < v113)) or (3288 >= 3541)) then
								if (v22(v98.FeralSpirit) or (3557 == 4540)) then
									return "feral_spirit main 3";
								end
							end
							if ((v98['Ascendance']:IsCastable() and v51 and ((v56 and v31) or not v56) and (v96 < v113) and v15:DebuffUp(v98.FlameShockDebuff) and (((v111 == "Lightning Bolt") and (v108 == 1)) or ((v111 == "Chain Lightning") and (v108 > 1)))) or (261 > 1267)) then
								if ((1272 < 3858) and v22(v98.Ascendance)) then
									return "ascendance main 4";
								end
							end
							v227 = 2;
						end
					end
				end
				break;
			end
			if ((3664 == 3664) and (v159 == 1)) then
				if ((1941 >= 450) and v90) then
					local v229 = 0;
					while true do
						if ((v229 == 1) or (4646 < 324)) then
							if ((3833 == 3833) and v86) then
								local v245 = 0;
								while true do
									if ((v245 == 0) or (1240 > 3370)) then
										v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
										if (v28 or (2481 == 4682)) then
											return v28;
										end
										break;
									end
								end
							end
							if ((4727 >= 208) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v87) then
								local v246 = 0;
								while true do
									if ((280 < 3851) and (v246 == 0)) then
										v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 40, true);
										if (v28 or (3007 > 3194)) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v229 == 0) or (2136 >= 2946)) then
							if ((2165 <= 2521) and v84) then
								local v247 = 0;
								while true do
									if ((2861 > 661) and (v247 == 0)) then
										v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
										if ((4525 > 4519) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if ((3178 > 972) and v85) then
								local v248 = 0;
								while true do
									if ((4766 == 4766) and (v248 == 0)) then
										v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
										if (v28 or (2745 > 3128)) then
											return v28;
										end
										break;
									end
								end
							end
							v229 = 1;
						end
					end
				end
				if (v91 or (1144 >= 4606)) then
					local v230 = 0;
					while true do
						if ((3338 >= 277) and (v230 == 0)) then
							v28 = v114.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 30, true);
							if ((2610 > 2560) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v159 = 2;
			end
			if ((v159 == 3) or (1194 > 3083)) then
				if ((916 >= 747) and v98['Purge']:IsReady() and v97 and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) then
					if (v22(v98.Purge, not v15:IsSpellInRange(v98.Purge)) or (2444 > 2954)) then
						return "purge damage";
					end
				end
				v28 = v126();
				v159 = 4;
			end
			if ((2892 < 3514) and (2 == v159)) then
				if ((533 == 533) and Focus) then
					if ((595 <= 3413) and v89) then
						local v239 = 0;
						while true do
							if ((3078 >= 2591) and (v239 == 0)) then
								v28 = v125();
								if ((3199 < 4030) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if ((777 < 2078) and v98['GreaterPurge']:IsAvailable() and v97 and v98['GreaterPurge']:IsReady() and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) then
					if ((1696 <= 2282) and v22(v98.GreaterPurge, not v15:IsSpellInRange(v98.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v159 = 3;
			end
		end
	end
	local function v136()
		local v160 = 0;
		while true do
			if ((v160 == 3) or (1761 >= 2462)) then
				v44 = EpicSettings['Settings']['useLightningBolt'];
				v45 = EpicSettings['Settings']['usePrimordialWave'];
				v46 = EpicSettings['Settings']['useStormStrike'];
				v47 = EpicSettings['Settings']['useSundering'];
				v160 = 4;
			end
			if ((4551 > 2328) and (v160 == 2)) then
				v40 = EpicSettings['Settings']['useFrostShock'];
				v41 = EpicSettings['Settings']['useIceStrike'];
				v42 = EpicSettings['Settings']['useLavaBurst'];
				v43 = EpicSettings['Settings']['useLavaLash'];
				v160 = 3;
			end
			if ((3825 >= 467) and (v160 == 1)) then
				v36 = EpicSettings['Settings']['useCrashLightning'];
				v37 = EpicSettings['Settings']['useElementalBlast'];
				v38 = EpicSettings['Settings']['useFireNova'];
				v39 = EpicSettings['Settings']['useFlameShock'];
				v160 = 2;
			end
			if ((v160 == 0) or (2890 == 557)) then
				v51 = EpicSettings['Settings']['useAscendance'];
				v53 = EpicSettings['Settings']['useDoomWinds'];
				v52 = EpicSettings['Settings']['useFeralSpirit'];
				v35 = EpicSettings['Settings']['useChainlightning'];
				v160 = 1;
			end
			if ((4 == v160) or (4770 == 2904)) then
				v49 = EpicSettings['Settings']['useWindstrike'];
				v48 = EpicSettings['Settings']['useWindfuryTotem'];
				v50 = EpicSettings['Settings']['useWeaponEnchant'];
				v56 = EpicSettings['Settings']['ascendanceWithCD'];
				v160 = 5;
			end
			if ((v160 == 5) or (3903 == 4536)) then
				v58 = EpicSettings['Settings']['doomWindsWithCD'];
				v57 = EpicSettings['Settings']['feralSpiritWithCD'];
				v60 = EpicSettings['Settings']['primordialWaveWithMiniCD'];
				v59 = EpicSettings['Settings']['sunderingWithMiniCD'];
				break;
			end
		end
	end
	local function v137()
		local v161 = 0;
		while true do
			if ((4093 <= 4845) and (v161 == 4)) then
				v83 = EpicSettings['Settings']['healOOCHP'] or 0;
				v97 = EpicSettings['Settings']['usePurgeTarget'];
				v84 = EpicSettings['Settings']['useCleanseSpiritWithAfflicted'];
				v85 = EpicSettings['Settings']['useTremorTotemWithAfflicted'];
				v161 = 5;
			end
			if ((1569 <= 3647) and (v161 == 1)) then
				v66 = EpicSettings['Settings']['useAstralShift'];
				v69 = EpicSettings['Settings']['useMaelstromHealingSurge'];
				v68 = EpicSettings['Settings']['useHealingStreamTotem'];
				v75 = EpicSettings['Settings']['ancestralGuidanceHP'] or 0;
				v161 = 2;
			end
			if ((2 == v161) or (4046 >= 4927)) then
				v76 = EpicSettings['Settings']['ancestralGuidanceGroup'] or 0;
				v74 = EpicSettings['Settings']['astralShiftHP'] or 0;
				v77 = EpicSettings['Settings']['healingStreamTotemHP'] or 0;
				v78 = EpicSettings['Settings']['healingStreamTotemGroup'] or 0;
				v161 = 3;
			end
			if ((4623 >= 2787) and (v161 == 5)) then
				v86 = EpicSettings['Settings']['usePoisonCleansingTotemWithAfflicted'];
				v87 = EpicSettings['Settings']['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if ((2234 >= 1230) and (v161 == 0)) then
				v63 = EpicSettings['Settings']['useWindShear'];
				v34 = EpicSettings['Settings']['useCapacitorTotem'];
				v64 = EpicSettings['Settings']['useThunderstorm'];
				v67 = EpicSettings['Settings']['useAncestralGuidance'];
				v161 = 1;
			end
			if ((v161 == 3) or (343 == 1786)) then
				v79 = EpicSettings['Settings']['maelstromHealingSurgeCriticalHP'] or 0;
				v72 = EpicSettings['Settings']['autoShield'];
				v73 = EpicSettings['Settings']['shieldUse'] or "Lightning Shield";
				v82 = EpicSettings['Settings']['healOOC'];
				v161 = 4;
			end
		end
	end
	local function v138()
		local v162 = 0;
		while true do
			if ((2570 > 2409) and (v162 == 3)) then
				v62 = EpicSettings['Settings']['racialsWithCD'];
				v70 = EpicSettings['Settings']['useHealthstone'];
				v71 = EpicSettings['Settings']['useHealingPotion'];
				v162 = 4;
			end
			if ((v162 == 2) or (2609 >= 3234)) then
				v54 = EpicSettings['Settings']['useTrinkets'];
				v55 = EpicSettings['Settings']['useRacials'];
				v61 = EpicSettings['Settings']['trinketsWithCD'];
				v162 = 3;
			end
			if ((v162 == 1) or (3033 >= 4031)) then
				v95 = EpicSettings['Settings']['InterruptThreshold'];
				v89 = EpicSettings['Settings']['DispelDebuffs'];
				v88 = EpicSettings['Settings']['DispelBuffs'];
				v162 = 2;
			end
			if ((v162 == 0) or (1401 == 4668)) then
				v96 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v93 = EpicSettings['Settings']['InterruptWithStun'];
				v94 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v162 = 1;
			end
			if ((2776 >= 1321) and (v162 == 4)) then
				v80 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v81 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v92 = EpicSettings['Settings']['HealingPotionName'] or "";
				v162 = 5;
			end
			if ((5 == v162) or (487 > 2303)) then
				v90 = EpicSettings['Settings']['handleAfflicted'];
				v91 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v139()
		local v163 = 0;
		while true do
			if ((v163 == 4) or (4503 == 3462)) then
				if ((553 <= 1543) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v231 = 0;
					while true do
						if ((2015 == 2015) and (v231 == 0)) then
							if (Focus or (4241 <= 2332)) then
								if (v89 or (2364 < 1157)) then
									local v253 = 0;
									while true do
										if ((0 == v253) or (1167 > 1278)) then
											v28 = v125();
											if (v28 or (1145 <= 1082)) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if (v90 or (3105 == 4881)) then
								local v249 = 0;
								while true do
									if ((v249 == 0) or (1887 > 4878)) then
										if (v84 or (4087 > 4116)) then
											local v254 = 0;
											while true do
												if ((1106 <= 1266) and (0 == v254)) then
													v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
													if ((3155 < 4650) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if ((3774 >= 1839) and v85) then
											local v255 = 0;
											while true do
												if ((2811 == 2811) and (v255 == 0)) then
													v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
													if ((2146 > 1122) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										v249 = 1;
									end
									if ((1 == v249) or (56 == 3616)) then
										if (v86 or (2421 < 622)) then
											local v256 = 0;
											while true do
												if ((1009 <= 1130) and (v256 == 0)) then
													v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
													if ((2758 < 2980) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if (((v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v87) or (86 >= 3626)) then
											local v257 = 0;
											while true do
												if ((2395 == 2395) and (v257 == 0)) then
													v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 40, true);
													if ((3780 > 2709) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							v231 = 1;
						end
						if ((v231 == 1) or (237 >= 2273)) then
							if (v14:AffectingCombat() or (2040 <= 703)) then
								local v250 = 0;
								while true do
									if ((3279 <= 3967) and (0 == v250)) then
										v28 = v135();
										if (v28 or (1988 == 877)) then
											return v28;
										end
										break;
									end
								end
							else
								local v251 = 0;
								while true do
									if ((4291 > 1912) and (v251 == 0)) then
										v28 = v134();
										if ((2003 < 2339) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((432 == 432) and (v163 == 1)) then
				v30 = EpicSettings['Toggles']['aoe'];
				v31 = EpicSettings['Toggles']['cds'];
				v33 = EpicSettings['Toggles']['dispel'];
				v32 = EpicSettings['Toggles']['minicds'];
				v163 = 2;
			end
			if ((3 == v163) or (1145 >= 1253)) then
				if ((3418 > 2118) and v30) then
					local v232 = 0;
					while true do
						if ((3066 <= 3890) and (0 == v232)) then
							v109 = #v106;
							v108 = #v107;
							break;
						end
					end
				else
					local v233 = 0;
					while true do
						if ((v233 == 0) or (2998 >= 3281)) then
							v109 = 1;
							v108 = 1;
							break;
						end
					end
				end
				if (v14:AffectingCombat() or v89 or (4649 <= 2632)) then
					local v234 = 0;
					local v235;
					while true do
						if ((v234 == 0) or (3860 > 4872)) then
							v235 = v89 and v98['CleanseSpirit']:IsReady() and v33;
							v28 = v114.FocusUnit(v235, v100, 20, nil, 25);
							v234 = 1;
						end
						if ((v234 == 1) or (3998 == 2298)) then
							if (v28 or (8 >= 2739)) then
								return v28;
							end
							break;
						end
					end
				end
				if ((2590 == 2590) and (v114.TargetIsValid() or v14:AffectingCombat())) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (82 >= 1870)) then
							v112 = v10.BossFightRemains(nil, true);
							v113 = v112;
							v236 = 1;
						end
						if ((2624 < 4557) and (1 == v236)) then
							if ((v113 == 11111) or (3131 > 3542)) then
								v113 = v10.FightRemains(v107, false);
							end
							break;
						end
					end
				end
				if ((2577 >= 1578) and v14:AffectingCombat()) then
					if ((4103 <= 4571) and v14:PrevGCD(1, v98.ChainLightning)) then
						v111 = "Chain Lightning";
					elseif (v14:PrevGCD(1, v98.LightningBolt) or (1495 == 4787)) then
						v111 = "Lightning Bolt";
					end
				end
				v163 = 4;
			end
			if ((v163 == 0) or (310 > 4434)) then
				v137();
				v136();
				v138();
				v29 = EpicSettings['Toggles']['ooc'];
				v163 = 1;
			end
			if ((2168 <= 4360) and (v163 == 2)) then
				if ((994 == 994) and v14:IsDeadOrGhost()) then
					return;
				end
				v102, v104, _, _, v103, v105 = v25();
				v106 = v14:GetEnemiesInRange(40);
				v107 = v14:GetEnemiesInMeleeRange(5);
				v163 = 3;
			end
		end
	end
	local function v140()
		local v164 = 0;
		while true do
			if ((1655 > 401) and (1 == v164)) then
				v19.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((3063 <= 3426) and (0 == v164)) then
				v98['FlameShockDebuff']:RegisterAuraTracking();
				v115();
				v164 = 1;
			end
		end
	end
	v19.SetAPL(263, v139, v140);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

