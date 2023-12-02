local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((4864 > 2197) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3700 == 2507)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((4474 >= 274) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['Target'];
	local v16 = v12['MouseOver'];
	local v17 = v12['Pet'];
	local v18 = v10['Spell'];
	local v19 = v10['Item'];
	local v20 = EpicLib;
	local v21 = v20['Bind'];
	local v22 = v20['Cast'];
	local v23 = v20['CastSuggested'];
	local v24 = v20['Press'];
	local v25 = v20['Macro'];
	local v26 = v20['Commons']['Everyone'];
	local v27 = v26['num'];
	local v28 = v26['bool'];
	local v29 = math['min'];
	local v30 = math['max'];
	local v31 = 5;
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
	local v85 = v18['DemonHunter']['Havoc'];
	local v86 = v19['DemonHunter']['Havoc'];
	local v87 = v25['DemonHunter']['Havoc'];
	local v88 = {};
	local v89 = v14:GetEquipment();
	local v90 = (v89[13] and v19(v89[13])) or v19(0);
	local v91 = (v89[14] and v19(v89[14])) or v19(0);
	local v92, v93;
	local v94, v95;
	local v96 = {{v85['FelEruption']},{v85['ChaosNova']}};
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = false;
	local v102 = false;
	local v103 = ((v85['AFireInside']:IsAvailable()) and 5) or 1;
	local v104 = v14:GCD() + 0.25;
	local v105 = 0;
	local v106 = false;
	local v107 = 11111;
	local v108 = 11111;
	local v109 = {169421,169425,168932,169426,169429,169428,169430};
	v10:RegisterForEvent(function()
		local v123 = 0;
		while true do
			if ((v123 == 2) or (1894 <= 1406)) then
				v101 = false;
				v107 = 11111;
				v123 = 3;
			end
			if ((1572 >= 1531) and (v123 == 0)) then
				v97 = false;
				v98 = false;
				v123 = 1;
			end
			if ((v123 == 3) or (4687 < 4542)) then
				v108 = 11111;
				break;
			end
			if ((3291 > 1667) and (1 == v123)) then
				v99 = false;
				v100 = false;
				v123 = 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((1 == v124) or (873 == 2034)) then
				v91 = (v89[14] and v19(v89[14])) or v19(0);
				break;
			end
			if ((v124 == 0) or (2816 < 11)) then
				v89 = v14:GetEquipment();
				v90 = (v89[13] and v19(v89[13])) or v19(0);
				v124 = 1;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v103 = ((v85['AFireInside']:IsAvailable()) and 5) or 1;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v110(v125)
		return v125:DebuffRemains(v85.BurningWoundDebuff) or v125:DebuffRemains(v85.BurningWoundLegDebuff);
	end
	local function v111(v126)
		return v85['BurningWound']:IsAvailable() and (v126:DebuffRemains(v85.BurningWoundDebuff) < 4) and (v85['BurningWoundDebuff']:AuraActiveCount() < v29(v94, 3));
	end
	local function v112()
		local v127 = 0;
		while true do
			if ((3699 < 4706) and (v127 == 1)) then
				v32 = v26.HandleBottomTrinket(v88, v35, 40, nil);
				if ((2646 >= 876) and v32) then
					return v32;
				end
				break;
			end
			if ((614 <= 3184) and (v127 == 0)) then
				v32 = v26.HandleTopTrinket(v88, v35, 40, nil);
				if ((3126 == 3126) and v32) then
					return v32;
				end
				v127 = 1;
			end
		end
	end
	local function v113()
		local v128 = 0;
		while true do
			if ((v128 == 1) or (2187 >= 4954)) then
				if ((v86['Healthstone']:IsReady() and v80 and (v14:HealthPercentage() <= v82)) or (3877 == 3575)) then
					if ((707 > 632) and v24(v87.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v79 and (v14:HealthPercentage() <= v81)) or (546 >= 2684)) then
					local v181 = 0;
					while true do
						if ((1465 <= 4301) and (v181 == 0)) then
							if ((1704 > 1425) and (v83 == "Refreshing Healing Potion")) then
								if (v86['RefreshingHealingPotion']:IsReady() or (687 == 4234)) then
									if (v24(v87.RefreshingHealingPotion) or (3330 < 1429)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((1147 >= 335) and (v83 == "Dreamwalker's Healing Potion")) then
								if ((3435 > 2097) and v86['DreamwalkersHealingPotion']:IsReady()) then
									if (v24(v87.RefreshingHealingPotion) or (3770 >= 4041)) then
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
			if ((0 == v128) or (3791 <= 1611)) then
				if ((v85['Blur']:IsCastable() and v65 and (v14:HealthPercentage() <= v67)) or (4578 <= 2008)) then
					if ((1125 <= 2076) and v24(v85.Blur)) then
						return "blur defensive";
					end
				end
				if ((v85['Netherwalk']:IsCastable() and v66 and (v14:HealthPercentage() <= v68)) or (743 >= 4399)) then
					if ((1155 < 1673) and v24(v85.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v128 = 1;
			end
		end
	end
	local function v114()
		local v129 = 0;
		while true do
			if ((0 == v129) or (2324 <= 578)) then
				if ((3767 == 3767) and v85['ImmolationAura']:IsCastable() and v49) then
					if ((4089 == 4089) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
						return "immolation_aura precombat 8";
					end
				end
				if ((4458 >= 1674) and v50 and not v14:IsMoving() and (v94 > 1) and v85['SigilOfFlame']:IsCastable()) then
					if ((972 <= 1418) and ((v84 == "player") or v85['ConcentratedSigils']:IsAvailable())) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (4938 < 4762)) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v84 == "cursor") or (2504 > 4264)) then
						if ((2153 == 2153) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(40))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v129 = 1;
			end
			if ((2 == v129) or (507 >= 2591)) then
				if ((4481 == 4481) and v15:IsInMeleeRange(5) and v42 and (v85['DemonsBite']:IsCastable() or v85['DemonBlades']:IsAvailable())) then
					if (v24(v85.DemonsBite, not v15:IsInMeleeRange(5)) or (2328 < 693)) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if ((4328 == 4328) and (v129 == 1)) then
				if ((1588 >= 1332) and not v15:IsInMeleeRange(5) and v85['Felblade']:IsCastable()) then
					if (v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade)) or (4174 > 4248)) then
						return "felblade precombat 9";
					end
				end
				if ((not v15:IsInMeleeRange(5) and v85['FelRush']:IsCastable() and (not v85['Felblade']:IsAvailable() or (v85['Felblade']:CooldownDown() and not v14:PrevGCDP(1, v85.Felblade))) and v36 and v47) or (4586 <= 82)) then
					if ((3863 == 3863) and v24(v85.FelRush, not v15:IsInRange(15))) then
						return "fel_rush precombat 10";
					end
				end
				v129 = 2;
			end
		end
	end
	local function v115()
		if (v14:BuffDown(v85.FelBarrage) or (282 <= 42)) then
			local v139 = 0;
			while true do
				if ((4609 >= 766) and (v139 == 0)) then
					if ((v85['DeathSweep']:IsReady() and v41) or (1152 == 2488)) then
						if ((3422 > 3350) and v24(v85.DeathSweep, not v15:IsInRange(v31))) then
							return "death_sweep meta_end 2";
						end
					end
					if ((877 > 376) and v85['Annihilation']:IsReady() and v37) then
						if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (3118 <= 1851)) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v130 = 0;
		local v131;
		while true do
			if ((v130 == 1) or (165 >= 3492)) then
				v131 = v26.HandleDPSPotion(v14:BuffUp(v85.MetamorphosisBuff));
				if ((3949 < 4856) and v131) then
					return v131;
				end
				v130 = 2;
			end
			if ((v130 == 0) or (4276 < 3016)) then
				if ((4690 > 4125) and ((v35 and v61) or not v61) and v85['Metamorphosis']:IsCastable() and v58 and not v85['Demonic']:IsAvailable()) then
					if (v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31)) or (50 >= 896)) then
						return "metamorphosis cooldown 4";
					end
				end
				if ((((v35 and v61) or not v61) and v85['Metamorphosis']:IsCastable() and v58 and v85['Demonic']:IsAvailable() and ((not v85['ChaoticTransformation']:IsAvailable() and v85['EyeBeam']:CooldownDown()) or ((v85['EyeBeam']:CooldownRemains() > 20) and (not v97 or v14:PrevGCDP(1, v85.DeathSweep) or v14:PrevGCDP(2, v85.DeathSweep))) or ((v108 < (25 + (v27(v85['ShatteredDestiny']:IsAvailable()) * 70))) and v85['EyeBeam']:CooldownDown() and v85['BladeDance']:CooldownDown())) and v14:BuffDown(v85.InnerDemonBuff)) or (1714 >= 2958)) then
					if (v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31)) or (1491 < 644)) then
						return "metamorphosis cooldown 6";
					end
				end
				v130 = 1;
			end
			if ((704 < 987) and (v130 == 2)) then
				if ((3718 > 1906) and v57 and not v14:IsMoving() and ((v35 and v60) or not v60) and v85['ElysianDecree']:IsCastable() and (v15:DebuffDown(v85.EssenceBreakDebuff)) and (v94 > v64)) then
					if ((v63 == "player") or (958 > 3635)) then
						if ((3501 <= 4492) and v24(v87.ElysianDecreePlayer, not v15:IsInRange(v31))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif ((v63 == "cursor") or (3442 < 2548)) then
						if ((2875 >= 1464) and v24(v87.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if ((v76 < v108) or (4797 >= 4893)) then
					if ((v77 and ((v35 and v78) or not v78)) or (551 > 2068)) then
						local v188 = 0;
						while true do
							if ((2114 > 944) and (v188 == 0)) then
								v32 = v112();
								if (v32 or (2262 >= 3096)) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v132 = 0;
		while true do
			if ((v132 == 6) or (2255 >= 3537)) then
				if ((v85['FelRush']:IsCastable() and v36 and v47 and not v85['Momentum']:IsAvailable() and not v85['DemonBlades']:IsAvailable() and (v94 > 1) and v14:BuffDown(v85.UnboundChaosBuff)) or (3837 < 1306)) then
					if ((2950 == 2950) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 56";
					end
				end
				if ((v85['SigilOfFlame']:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= 30) and v15:IsInRange(30)) or (4723 < 3298)) then
					if ((1136 >= 154) and ((v84 == "player") or v85['ConcentratedSigils']:IsAvailable())) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (271 > 4748)) then
							return "sigil_of_flame rotation player 58";
						end
					elseif ((4740 >= 3152) and (v84 == "cursor")) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(30)) or (2578 >= 3390)) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				if ((41 <= 1661) and v85['DemonsBite']:IsCastable() and v42) then
					if ((601 < 3560) and v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite))) then
						return "demons_bite rotation 57";
					end
				end
				if ((235 < 687) and v85['FelRush']:IsReady() and v36 and v47 and not v85['Momentum']:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) <= 20)) then
					if ((4549 > 1153) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 58";
					end
				end
				if ((v85['FelRush']:IsReady() and v36 and v47 and not v15:IsInRange(v31) and not v85['Momentum']:IsAvailable()) or (4674 < 4672)) then
					if ((3668 < 4561) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				v132 = 7;
			end
			if ((v132 == 4) or (455 == 3605)) then
				if ((v85['Felblade']:IsCastable() and v46 and not v14:PrevGCDP(1, v85.VengefulRetreat) and (((v14:FuryDeficit() >= 40) and v85['AnyMeansNecessary']:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v85['AnyMeansNecessary']:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)))) or (2663 == 3312)) then
					if ((4277 <= 4475) and v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade))) then
						return "felblade rotation 38";
					end
				end
				if ((v85['SigilOfFlame']:IsCastable() and not v14:IsMoving() and v50 and v85['AnyMeansNecessary']:IsAvailable() and (v14:FuryDeficit() >= 30)) or (870 == 1189)) then
					if ((1553 <= 3133) and ((v84 == "player") or v85['ConcentratedSigils']:IsAvailable())) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (2237 >= 3511)) then
							return "sigil_of_flame rotation player 39";
						end
					elseif ((v84 == "cursor") or (1324 > 3020)) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(40)) or (2992 == 1881)) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				if ((3106 > 1526) and v85['ThrowGlaive']:IsReady() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85['Soulscar']:IsAvailable() and (v95 >= (2 - v27(v85['FuriousThrows']:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and not v14:HasTier(31, 2)) then
					if ((3023 < 3870) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "throw_glaive rotation 40";
					end
				end
				if ((143 > 74) and v85['ImmolationAura']:IsCastable() and v49 and (v14:BuffStack(v85.ImmolationAuraBuff) < v103) and v15:IsInRange(8) and (v14:BuffDown(v85.UnboundChaosBuff) or not v85['UnboundChaos']:IsAvailable()) and ((v85['ImmolationAura']:Recharge() < v85['EssenceBreak']:CooldownRemains()) or (not v85['EssenceBreak']:IsAvailable() and (v85['EyeBeam']:CooldownRemains() > v85['ImmolationAura']:Recharge())))) then
					if ((18 < 2112) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
						return "immolation_aura rotation 42";
					end
				end
				if ((1097 <= 1628) and v85['ThrowGlaive']:IsReady() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85['Soulscar']:IsAvailable() and (v85['ThrowGlaive']:FullRechargeTime() < v85['BladeDance']:CooldownRemains()) and v14:HasTier(31, 2) and v14:BuffDown(v85.FelBarrage) and not v99) then
					if ((4630 == 4630) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "throw_glaive rotation 44";
					end
				end
				v132 = 5;
			end
			if ((3540 > 2683) and (v132 == 7)) then
				if ((4794 >= 3275) and v85['VengefulRetreat']:IsCastable() and v36 and v52 and v85['Felblade']:CooldownDown() and not v85['Initiative']:IsAvailable() and not v15:IsInRange(v31)) then
					if ((1484 == 1484) and v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true)) then
						return "vengeful_retreat rotation 60";
					end
				end
				if ((1432 < 3555) and v85['ThrowGlaive']:IsCastable() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and (v85['DemonBlades']:IsAvailable() or not v15:IsInRange(12)) and v15:DebuffDown(v85.EssenceBreakDebuff) and v15:IsSpellInRange(v85.ThrowGlaive) and not v14:HasTier(31, 2)) then
					if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or (1065 > 3578)) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if ((v132 == 0) or (4795 < 1407)) then
				if ((1853 < 4813) and v85['Annihilation']:IsCastable() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85['Metamorphosis']:CooldownRemains() <= (v14:GCD() * 3))) then
					if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (2821 < 2431)) then
						return "annihilation rotation 2";
					end
				end
				if ((v85['VengefulRetreat']:IsCastable() and v36 and v52 and v85['Felblade']:CooldownDown() and (v85['EyeBeam']:CooldownRemains() < 0.3) and (v85['EssenceBreak']:CooldownRemains() < (v104 * 2)) and (v10.CombatTime() > 5) and (v14:Fury() >= 30) and v85['Inertia']:IsAvailable()) or (2874 < 2181)) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (2689 <= 343)) then
						return "vengeful_retreat rotation 3";
					end
				end
				if ((v85['VengefulRetreat']:IsCastable() and v36 and v52 and v85['Felblade']:CooldownDown() and v85['Initiative']:IsAvailable() and v85['EssenceBreak']:IsAvailable() and (v10.CombatTime() > 1) and ((v85['EssenceBreak']:CooldownRemains() > 15) or ((v85['EssenceBreak']:CooldownRemains() < v104) and (not v85['Demonic']:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85['EyeBeam']:CooldownRemains() > (15 + (10 * v27(v85['CycleOfHatred']:IsAvailable()))))))) and ((v10.CombatTime() < 30) or ((v14:GCDRemains() - 1) < 0)) and (not v85['Initiative']:IsAvailable() or (v14:BuffRemains(v85.InitiativeBuff) < v104) or (v10.CombatTime() > 4))) or (1869 == 2009)) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (3546 < 2322)) then
						return "vengeful_retreat rotation 4";
					end
				end
				if ((v85['VengefulRetreat']:IsCastable() and v36 and v52 and v85['Felblade']:CooldownDown() and v85['Initiative']:IsAvailable() and v85['EssenceBreak']:IsAvailable() and (v10.CombatTime() > 1) and ((v85['EssenceBreak']:CooldownRemains() > 15) or ((v85['EssenceBreak']:CooldownRemains() < (v104 * 2)) and (((v14:BuffRemains(v85.InitiativeBuff) < v104) and not v102 and (v85['EyeBeam']:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > 30)) or not v85['Demonic']:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85['EyeBeam']:CooldownRemains() > (15 + (10 * v27(v85['CycleofHatred']:IsAvailable()))))))) and (v14:BuffDown(v85.UnboundChaosBuff) or v14:BuffUp(v85.InertiaBuff))) or (2082 == 4773)) then
					if ((3244 > 1055) and v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true)) then
						return "vengeful_retreat rotation 6";
					end
				end
				if ((v85['VengefulRetreat']:IsCastable() and v36 and v52 and v85['Felblade']:CooldownDown() and v85['Initiative']:IsAvailable() and not v85['EssenceBreak']:IsAvailable() and (v10.CombatTime() > 1) and (v14:BuffDown(v85.InitiativeBuff) or (v14:PrevGCDP(1, v85.DeathSweep) and v85['Metamorphosis']:CooldownUp() and v85['ChaoticTransformation']:IsAvailable())) and v85['Initiative']:IsAvailable()) or (3313 <= 1778)) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (1421 >= 2104)) then
						return "vengeful_retreat rotation 8";
					end
				end
				v132 = 1;
			end
			if ((1812 <= 3249) and (v132 == 5)) then
				if ((1623 <= 1957) and v85['ChaosStrike']:IsReady() and v39 and not v98 and not v99 and v14:BuffDown(v85.FelBarrage)) then
					if ((4412 == 4412) and v24(v85.ChaosStrike, not v15:IsSpellInRange(v85.ChaosStrike))) then
						return "chaos_strike rotation 46";
					end
				end
				if ((1750 >= 842) and v85['SigilOfFlame']:IsCastable() and not v14:IsMoving() and v50 and (v14:FuryDeficit() >= 30)) then
					if ((4372 > 1850) and ((v84 == "player") or v85['ConcentratedSigils']:IsAvailable())) then
						if ((232 < 821) and v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif ((518 < 902) and (v84 == "cursor")) then
						if ((2994 > 858) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(30))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				if ((v85['Felblade']:IsCastable() and v46 and (v14:FuryDeficit() >= 40) and not v14:PrevGCDP(1, v85.VengefulRetreat)) or (3755 <= 915)) then
					if ((3946 > 3743) and v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade))) then
						return "felblade rotation 50";
					end
				end
				if ((v85['FelRush']:IsCastable() and v36 and v47 and not v85['Momentum']:IsAvailable() and v85['DemonBlades']:IsAvailable() and v85['EyeBeam']:CooldownDown() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85['FelRush']:Recharge() < v85['EssenceBreak']:CooldownRemains()) or not v85['EssenceBreak']:IsAvailable())) or (1335 >= 3306)) then
					if ((4844 > 2253) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 52";
					end
				end
				if ((452 == 452) and v85['DemonsBite']:IsCastable() and v42 and v85['BurningWound']:IsAvailable() and (v15:DebuffRemains(v85.BurningWoundDebuff) < 4)) then
					if (v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite)) or (4557 < 2087)) then
						return "demons_bite rotation 54";
					end
				end
				v132 = 6;
			end
			if ((3874 == 3874) and (v132 == 3)) then
				if ((v85['BladeDance']:IsCastable() and v38 and v97 and ((v85['EyeBeam']:CooldownRemains() > 5) or not v85['Demonic']:IsAvailable() or v14:HasTier(31, 2))) or (1938 > 4935)) then
					if (v24(v85.BladeDance, not v15:IsInRange(v31)) or (4255 < 3423)) then
						return "blade_dance rotation 28";
					end
				end
				if ((1454 <= 2491) and v85['SigilOfFlame']:IsCastable() and not v14:IsMoving() and v50 and v85['AnyMeansNecessary']:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff) and (v94 >= 4)) then
					if ((v84 == "player") or v85['ConcentratedSigils']:IsAvailable() or (4157 <= 2803)) then
						if ((4853 >= 2982) and v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif ((4134 > 3357) and (v84 == "cursor")) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(40)) or (3417 < 2534)) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				if ((v85['ThrowGlaive']:IsCastable() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85['Soulscar']:IsAvailable() and (v94 >= (2 - v27(v85['FuriousThrows']:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85['ThrowGlaive']:FullRechargeTime() < (v104 * 3)) or (v94 > 1)) and not v14:HasTier(31, 2)) or (2722 <= 164)) then
					if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or (2408 < 2109)) then
						return "throw_glaive rotation 32";
					end
				end
				if ((v85['ImmolationAura']:IsCastable() and v49 and (v94 >= 2) and (v14:Fury() < 70) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (33 == 1455)) then
					if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or (443 >= 4015)) then
						return "immolation_aura rotation 34";
					end
				end
				if ((3382 > 166) and ((v85['Annihilation']:IsCastable() and v37 and not v98 and ((v85['EssenceBreak']:CooldownRemains() > 0) or not v85['EssenceBreak']:IsAvailable()) and v14:BuffDown(v85.FelBarrage)) or v14:HasTier(30, 2))) then
					if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (280 == 3059)) then
						return "annihilation rotation 36";
					end
				end
				v132 = 4;
			end
			if ((1881 > 1293) and (v132 == 1)) then
				if ((2357 == 2357) and v85['FelRush']:IsCastable() and v36 and v47 and v85['Momentum']:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) < (v104 * 2)) and (v85['EyeBeam']:CooldownRemains() <= v104) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85['BladeDance']:CooldownDown()) then
					if ((123 == 123) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 10";
					end
				end
				if ((v85['FelRush']:IsCastable() and v36 and v47 and v85['Inertia']:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or ((v85['EyeBeam']:CooldownRemains() > v85['ImmolationAura']:Recharge()) and (v85['EyeBeam']:CooldownRemains() > 4))) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85['BladeDance']:CooldownDown()) or (1056 >= 3392)) then
					if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (1081 < 1075)) then
						return "fel_rush rotation 11";
					end
				end
				if ((v85['EssenceBreak']:IsCastable() and v43 and ((((v14:BuffRemains(v85.MetamorphosisBuff) > (v104 * 3)) or (v85['EyeBeam']:CooldownRemains() > 10)) and (not v85['TacticalRetreat']:IsAvailable() or v14:BuffUp(v85.TacticalRetreatBuff) or (v10.CombatTime() < 10)) and (v85['BladeDance']:CooldownRemains() <= (3.1 * v104))) or (v108 < 6))) or (1049 >= 4432)) then
					if (v24(v85.EssenceBreak, not v15:IsInRange(v31)) or (4768 <= 846)) then
						return "essence_break rotation 13";
					end
				end
				if ((v85['DeathSweep']:IsCastable() and v41 and v97 and (not v85['EssenceBreak']:IsAvailable() or (v85['EssenceBreak']:CooldownRemains() > (v104 * 2))) and v14:BuffDown(v85.FelBarrage)) or (3358 <= 1420)) then
					if (v24(v85.DeathSweep, not v15:IsInRange(v31)) or (3739 <= 3005)) then
						return "death_sweep rotation 14";
					end
				end
				if ((v85['TheHunt']:IsCastable() and v36 and v59 and (v76 < v108) and ((v35 and v62) or not v62) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v10.CombatTime() < 10) or (v85['Metamorphosis']:CooldownRemains() > 10)) and ((v94 == 1) or (v94 > 3) or (v108 < 10)) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and (not v85['FuriousGaze']:IsAvailable() or v14:BuffUp(v85.FuriousGazeBuff) or v14:HasTier(31, 4))) or not v14:HasTier(30, 2)) and (v10.CombatTime() > 10)) or (1659 >= 2134)) then
					if (v24(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt)) or (3260 < 2355)) then
						return "the_hunt main 12";
					end
				end
				v132 = 2;
			end
			if ((v132 == 2) or (669 == 4223)) then
				if ((v85['FelBarrage']:IsCastable() and v45 and ((v94 > 1) or ((v94 == 1) and (v14:FuryDeficit() < 20) and v14:BuffDown(v85.MetamorphosisBuff)))) or (1692 < 588)) then
					if (v24(v85.FelBarrage, not v15:IsInRange(v31)) or (4797 < 3651)) then
						return "fel_barrage rotation 16";
					end
				end
				if ((v85['GlaiveTempest']:IsReady() and v48 and (v15:DebuffDown(v85.EssenceBreakDebuff) or (v94 > 1)) and v14:BuffDown(v85.FelBarrage)) or (4177 > 4850)) then
					if (v24(v85.GlaiveTempest, not v15:IsInRange(v31)) or (400 > 1111)) then
						return "glaive_tempest rotation 18";
					end
				end
				if ((3051 > 1005) and v85['Annihilation']:IsReady() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85['EyeBeam']:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v85.FelBarrage)) then
					if ((3693 <= 4382) and v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation))) then
						return "annihilation rotation 20";
					end
				end
				if ((v85['FelRush']:IsReady() and v36 and v47 and v85['Momentum']:IsAvailable() and (v85['EyeBeam']:CooldownRemains() < (v104 * 3)) and (v14:BuffRemains(v85.MomentumBuff) < 5) and v14:BuffDown(v85.MetamorphosisBuff)) or (3282 > 4100)) then
					if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (3580 < 2844)) then
						return "fel_rush rotation 22";
					end
				end
				if ((89 < 4490) and v85['EyeBeam']:IsCastable() and v44 and not v14:PrevGCDP(1, v85.VengefulRetreat) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85['Metamorphosis']:CooldownRemains() > (30 - (v27(v85['CycleOfHatred']:IsAvailable()) * 15))) or ((v85['Metamorphosis']:CooldownRemains() < (v104 * 2)) and (not v85['EssenceBreak']:IsAvailable() or (v85['EssenceBreak']:CooldownRemains() < (v104 * 1.5))))) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > v104) or not v85['RestlessHunter']:IsAvailable()) and (v85['CycleOfHatred']:IsAvailable() or not v85['Initiative']:IsAvailable() or (v85['VengefulRetreat']:CooldownRemains() > 5) or not v52 or (v10.CombatTime() < 10)) and v14:BuffDown(v85.InnerDemonBuff)) or (v108 < 15))) then
					if (v24(v85.EyeBeam, not v15:IsInRange(v31)) or (4983 < 1808)) then
						return "eye_beam rotation 26";
					end
				end
				v132 = 3;
			end
		end
	end
	local function v118()
		local v133 = 0;
		while true do
			if ((3829 > 3769) and (v133 == 4)) then
				v49 = EpicSettings['Settings']['useImmolationAura'];
				v50 = EpicSettings['Settings']['useSigilOfFlame'];
				v51 = EpicSettings['Settings']['useThrowGlaive'];
				v133 = 5;
			end
			if ((1485 <= 2904) and (v133 == 0)) then
				v37 = EpicSettings['Settings']['useAnnihilation'];
				v38 = EpicSettings['Settings']['useBladeDance'];
				v39 = EpicSettings['Settings']['useChaosStrike'];
				v133 = 1;
			end
			if ((4269 == 4269) and (2 == v133)) then
				v43 = EpicSettings['Settings']['useEssenceBreak'];
				v44 = EpicSettings['Settings']['useEyeBeam'];
				v45 = EpicSettings['Settings']['useFelBarrage'];
				v133 = 3;
			end
			if ((387 <= 2782) and (5 == v133)) then
				v52 = EpicSettings['Settings']['useVengefulRetreat'];
				v57 = EpicSettings['Settings']['useElysianDecree'];
				v58 = EpicSettings['Settings']['useMetamorphosis'];
				v133 = 6;
			end
			if ((v133 == 6) or (1899 <= 917)) then
				v59 = EpicSettings['Settings']['useTheHunt'];
				v60 = EpicSettings['Settings']['elysianDecreeWithCD'];
				v61 = EpicSettings['Settings']['metamorphosisWithCD'];
				v133 = 7;
			end
			if ((1 == v133) or (4312 <= 876)) then
				v40 = EpicSettings['Settings']['useConsumeMagic'];
				v41 = EpicSettings['Settings']['useDeathSweep'];
				v42 = EpicSettings['Settings']['useDemonsBite'];
				v133 = 2;
			end
			if ((2232 <= 2596) and (v133 == 3)) then
				v46 = EpicSettings['Settings']['useFelblade'];
				v47 = EpicSettings['Settings']['useFelRush'];
				v48 = EpicSettings['Settings']['useGlaiveTempest'];
				v133 = 4;
			end
			if ((2095 < 3686) and (v133 == 7)) then
				v62 = EpicSettings['Settings']['theHuntWithCD'];
				v63 = EpicSettings['Settings']['elysianDecreeSetting'] or "player";
				v64 = EpicSettings['Settings']['elysianDecreeSlider'] or 0;
				break;
			end
		end
	end
	local function v119()
		local v134 = 0;
		while true do
			if ((v134 == 3) or (1595 >= 4474)) then
				v67 = EpicSettings['Settings']['blurHP'] or 0;
				v68 = EpicSettings['Settings']['netherwalkHP'] or 0;
				v134 = 4;
			end
			if ((v134 == 0) or (4619 < 2882)) then
				v53 = EpicSettings['Settings']['useChaosNova'];
				v54 = EpicSettings['Settings']['useDisrupt'];
				v134 = 1;
			end
			if ((4 == v134) or (294 >= 4831)) then
				v84 = EpicSettings['Settings']['sigilSetting'] or "";
				break;
			end
			if ((2029 <= 3084) and (v134 == 1)) then
				v55 = EpicSettings['Settings']['useFelEruption'];
				v56 = EpicSettings['Settings']['useSigilOfMisery'];
				v134 = 2;
			end
			if ((2 == v134) or (2037 == 2420)) then
				v65 = EpicSettings['Settings']['useBlur'];
				v66 = EpicSettings['Settings']['useNetherwalk'];
				v134 = 3;
			end
		end
	end
	local function v120()
		local v135 = 0;
		while true do
			if ((4458 > 3904) and (v135 == 1)) then
				v75 = EpicSettings['Settings']['InterruptThreshold'];
				v77 = EpicSettings['Settings']['useTrinkets'];
				v78 = EpicSettings['Settings']['trinketsWithCD'];
				v80 = EpicSettings['Settings']['useHealthstone'];
				v135 = 2;
			end
			if ((436 >= 123) and (v135 == 3)) then
				v72 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((500 < 1816) and (v135 == 2)) then
				v79 = EpicSettings['Settings']['useHealingPotion'];
				v82 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v81 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v83 = EpicSettings['Settings']['HealingPotionName'] or "";
				v135 = 3;
			end
			if ((3574 == 3574) and (v135 == 0)) then
				v76 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v69 = EpicSettings['Settings']['dispelBuffs'];
				v73 = EpicSettings['Settings']['InterruptWithStun'];
				v74 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v135 = 1;
			end
		end
	end
	local function v121()
		local v136 = 0;
		while true do
			if ((221 < 390) and (v136 == 1)) then
				v34 = EpicSettings['Toggles']['aoe'];
				v35 = EpicSettings['Toggles']['cds'];
				v36 = EpicSettings['Toggles']['movement'];
				if (v14:IsDeadOrGhost() or (2213 <= 1421)) then
					return;
				end
				v136 = 2;
			end
			if ((3058 < 4860) and (v136 == 0)) then
				v119();
				v118();
				v120();
				v33 = EpicSettings['Toggles']['ooc'];
				v136 = 1;
			end
			if ((v136 == 4) or (1296 >= 4446)) then
				if (v72 or (1393 > 4489)) then
					local v182 = 0;
					while true do
						if ((v182 == 0) or (4424 < 27)) then
							v32 = v26.HandleIncorporeal(v85.Imprison, v87.ImprisonMouseover, 30, true);
							if (v32 or (1997 > 3815)) then
								return v32;
							end
							break;
						end
					end
				end
				if ((3465 > 1913) and v26.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v183 = 0;
					local v184;
					while true do
						if ((733 < 1819) and (6 == v183)) then
							if ((v85['FelRush']:IsCastable() and v36 and v47 and v85['Inertia']:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and ((v85['EyeBeam']:CooldownRemains() + 3) > v14:BuffRemains(v85.UnboundChaosBuff)) and (v85['BladeDance']:CooldownDown() or v85['EssenceBreak']:CooldownUp())) or (4395 == 4755)) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (3793 < 2369)) then
									return "fel_rush main 9";
								end
							end
							if ((v85['FelRush']:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and v85['Inertia']:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or (v85['EssenceBreak']:CooldownRemains() > 10))) or (4084 == 265)) then
								if ((4358 == 4358) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return "fel_rush main 10";
								end
							end
							if (((v76 < v108) and v35) or (3138 < 993)) then
								local v189 = 0;
								while true do
									if ((3330 > 2323) and (0 == v189)) then
										v32 = v116();
										if (v32 or (3626 == 3989)) then
											return v32;
										end
										break;
									end
								end
							end
							v183 = 7;
						end
						if ((v183 == 0) or (916 == 2671)) then
							if ((272 == 272) and not v14:AffectingCombat()) then
								local v190 = 0;
								while true do
									if ((4249 <= 4839) and (0 == v190)) then
										v32 = v114();
										if ((2777 < 3200) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if ((95 < 1957) and v85['ConsumeMagic']:IsAvailable() and v40 and v85['ConsumeMagic']:IsReady() and v69 and not v14:IsCasting() and not v14:IsChanneling() and v26.UnitHasMagicBuff(v15)) then
								if ((826 < 1717) and v24(v85.ConsumeMagic, not v15:IsSpellInRange(v85.ConsumeMagic))) then
									return "greater_purge damage";
								end
							end
							if ((1426 >= 1105) and v85['FelRush']:IsReady() and v36 and v47 and not v15:IsInRange(v31)) then
								if ((2754 <= 3379) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return "fel_rush rotation when OOR";
								end
							end
							v183 = 1;
						end
						if ((v183 == 3) or (3927 == 1413)) then
							v184 = v30(v85['EyeBeam']:BaseDuration(), v14:GCD());
							v102 = v85['Demonic']:IsAvailable() and v85['EssenceBreak']:IsAvailable() and Var3MinTrinket and (v108 > (v85['Metamorphosis']:CooldownRemains() + 30 + (v27(v85['ShatteredDestiny']:IsAvailable()) * 60))) and (v85['Metamorphosis']:CooldownRemains() < 20) and (v85['Metamorphosis']:CooldownRemains() > (v184 + (v104 * (v27(v85['InnerDemon']:IsAvailable()) + 2))));
							if ((v85['ImmolationAura']:IsCastable() and v49 and v85['Ragefire']:IsAvailable() and (v94 >= 3) and (v85['BladeDance']:CooldownDown() or v15:DebuffDown(v85.EssenceBreakDebuff))) or (1154 <= 788)) then
								if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or (1643 > 3379)) then
									return "immolation_aura main 2";
								end
							end
							v183 = 4;
						end
						if ((v183 == 5) or (2803 > 4549)) then
							if ((v85['ImmolationAura']:IsCastable() and v49 and v85['Inertia']:IsAvailable() and ((v85['EyeBeam']:CooldownRemains() < (v104 * 2)) or v14:BuffUp(v85.MetamorphosisBuff)) and (v85['EssenceBreak']:CooldownRemains() < (v104 * 3)) and v14:BuffDown(v85.UnboundChaosBuff) and v14:BuffDown(v85.InertiaBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (220 >= 3022)) then
								if ((2822 == 2822) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return "immolation_aura main 5";
								end
							end
							if ((v85['ImmolationAura']:IsCastable() and v49 and v85['Inertia']:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85['ImmolationAura']:FullRechargeTime() < v85['EssenceBreak']:CooldownRemains()) or not v85['EssenceBreak']:IsAvailable()) and v15:DebuffDown(v85.EssenceBreakDebuff) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > 6)) and v85['BladeDance']:CooldownDown() and ((v14:Fury() < 75) or (v85['BladeDance']:CooldownRemains() < (v104 * 2)))) or (1061 == 1857)) then
								if ((2760 > 1364) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return "immolation_aura main 6";
								end
							end
							if ((v85['FelRush']:IsCastable() and v36 and v47 and ((v14:BuffRemains(v85.UnboundChaosBuff) < (v104 * 2)) or (v15:TimeToDie() < (v104 * 2)))) or (4902 <= 3595)) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (3852 == 293)) then
									return "fel_rush main 8";
								end
							end
							v183 = 6;
						end
						if ((v183 == 2) or (1559 == 4588)) then
							v98 = v97 and (v14:Fury() < (75 - (v27(v85['DemonBlades']:IsAvailable()) * 20))) and (v85['BladeDance']:CooldownRemains() < v104);
							v99 = v85['Demonic']:IsAvailable() and not v85['BlindFury']:IsAvailable() and (v85['EyeBeam']:CooldownRemains() < (v104 * 2)) and (v14:FuryDeficit() > 30);
							v101 = (v85['Momentum']:IsAvailable() and v14:BuffDown(v85.MomentumBuff)) or (v85['Inertia']:IsAvailable() and v14:BuffDown(v85.InertiaBuff));
							v183 = 3;
						end
						if ((v183 == 8) or (4484 == 788)) then
							if ((4568 >= 3907) and (v85['DemonBlades']:IsAvailable())) then
								if ((1246 < 3470) and v24(v85.Pool)) then
									return "pool demon_blades";
								end
							end
							break;
						end
						if ((4068 >= 972) and (v183 == 1)) then
							if ((493 < 3893) and v85['ThrowGlaive']:IsReady() and v51 and v13.ValueIsInArray(v109, v15:NPCID())) then
								if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or (1473 >= 3332)) then
									return "fodder to the flames react per target";
								end
							end
							if ((v85['ThrowGlaive']:IsReady() and v51 and v13.ValueIsInArray(v109, v16:NPCID())) or (4051 <= 1157)) then
								if ((604 < 2881) and v24(v87.ThrowGlaiveMouseover, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v97 = v85['FirstBlood']:IsAvailable() or v85['TrailofRuin']:IsAvailable() or (v85['ChaosTheory']:IsAvailable() and v14:BuffDown(v85.ChaosTheoryBuff)) or (v94 > 1);
							v183 = 2;
						end
						if ((v183 == 7) or (900 == 3377)) then
							if ((4459 > 591) and v14:BuffUp(v85.MetamorphosisBuff) and (v14:BuffRemains(v85.MetamorphosisBuff) < v104) and (v94 < 3)) then
								local v191 = 0;
								while true do
									if ((3398 >= 2395) and (0 == v191)) then
										v32 = v115();
										if (v32 or (2183 >= 2824)) then
											return v32;
										end
										break;
									end
								end
							end
							v32 = v117();
							if ((1936 == 1936) and v32) then
								return v32;
							end
							v183 = 8;
						end
						if ((v183 == 4) or (4832 < 4313)) then
							if ((4088 > 3874) and v85['ImmolationAura']:IsCastable() and v49 and v85['AFireInside']:IsAvailable() and v85['Inertia']:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and (v85['ImmolationAura']:FullRechargeTime() < (v104 * 2)) and v15:DebuffDown(v85.EssenceBreakDebuff)) then
								if ((4332 == 4332) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return "immolation_aura main 3";
								end
							end
							if ((3999 >= 2900) and v85['FelRush']:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and (((v85['ImmolationAura']:Charges() == 2) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v14:PrevGCDP(1, v85.EyeBeam) and v14:BuffUp(v85.InertiaBuff) and (v14:BuffRemains(v85.InertiaBuff) < 3)))) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (2525 > 4064)) then
									return "fel_rush main 4";
								end
							end
							if ((4371 == 4371) and v85['TheHunt']:IsCastable() and (v10.CombatTime() < 10) and (not v85['Inertia']:IsAvailable() or (v14:BuffUp(v85.MetamorphosisBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)))) then
								if (v22(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt)) or (266 > 4986)) then
									return "the_hunt main 6";
								end
							end
							v183 = 5;
						end
					end
				end
				break;
			end
			if ((1991 >= 925) and (v136 == 2)) then
				if ((455 < 2053) and v85['ImprovedDisrupt']:IsAvailable()) then
					v31 = 10;
				end
				v92 = v14:GetEnemiesInMeleeRange(v31);
				v93 = v14:GetEnemiesInMeleeRange(20);
				if (v34 or (826 == 4851)) then
					local v185 = 0;
					while true do
						if ((183 == 183) and (v185 == 0)) then
							v94 = ((#v92 > 0) and #v92) or 1;
							v95 = #v93;
							break;
						end
					end
				else
					local v186 = 0;
					while true do
						if ((1159 <= 1788) and (v186 == 0)) then
							v94 = 1;
							v95 = 1;
							break;
						end
					end
				end
				v136 = 3;
			end
			if ((v136 == 3) or (3507 > 4318)) then
				v104 = v14:GCD() + 0.05;
				if (v26.TargetIsValid() or v14:AffectingCombat() or (3075 <= 2965)) then
					local v187 = 0;
					while true do
						if ((1365 <= 2011) and (v187 == 0)) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v187 = 1;
						end
						if ((v187 == 1) or (2776 > 3575)) then
							if ((v108 == 11111) or (2554 == 4804)) then
								v108 = v10.FightRemains(Enemies8y, false);
							end
							break;
						end
					end
				end
				v32 = v113();
				if ((2577 == 2577) and v32) then
					return v32;
				end
				v136 = 4;
			end
		end
	end
	local function v122()
		local v137 = 0;
		while true do
			if ((v137 == 0) or (6 >= 1889)) then
				v85['BurningWoundDebuff']:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(577, v121, v122);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

