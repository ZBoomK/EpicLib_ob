local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((3126 == 3126) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (2187 >= 4954)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (3877 == 3575)) then
			return v6(...);
		end
	end
end
v0["Epix_DemonHunter_Vengeance.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Utils'];
	local v13 = v10['Unit'];
	local v14 = v13['Player'];
	local v15 = v13['Target'];
	local v16 = v13['MouseOver'];
	local v17 = v13['Pet'];
	local v18 = v10['Spell'];
	local v19 = v10['Item'];
	local v20 = EpicLib;
	local v21 = v20['Bind'];
	local v22 = v20['Cast'];
	local v23 = v20['CastSuggested'];
	local v24 = v20['CastAnnotated'];
	local v25 = v20['Press'];
	local v26 = v20['Macro'];
	local v27 = v20['Commons']['Everyone'];
	local v28 = v10['Utils']['MergeTableByKey'];
	local v29 = v27['num'];
	local v30 = v27['bool'];
	local v31 = GetTime;
	local v32 = math['max'];
	local v33 = math['ceil'];
	local v34 = math['min'];
	local v35 = 5;
	local v36;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v90 = v18['DemonHunter']['Vengeance'];
	local v91 = v19['DemonHunter']['Vengeance'];
	local v92 = v26['DemonHunter']['Vengeance'];
	local v93 = {};
	local v94, v95;
	local v96 = 0;
	local v97, v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103 = true;
	local v104 = 11111;
	local v105 = 11111;
	local v106 = {169421,169425,168932,169426,169429,169428,169430};
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((707 > 632) and (v124 == 0)) then
				v104 = 11111;
				v105 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v107()
		local v125 = 0;
		while true do
			if ((v125 == 1) or (546 >= 2684)) then
				if ((1465 <= 4301) and (v96 == 0)) then
					local v187 = 0;
					local v188;
					while true do
						if ((1704 > 1425) and (v187 == 0)) then
							v188 = ((v14:BuffUp(v90.MetamorphosisBuff)) and 1) or 0;
							if ((v90['SoulCarver']:IsAvailable() and (v90['SoulCarver']:TimeSinceLastCast() < v14:GCD()) and (v90['SoulCarver']['LastCastTime'] ~= v95)) or (687 == 4234)) then
								local v201 = 0;
								while true do
									if ((0 == v201) or (3330 < 1429)) then
										v96 = v34(v94 + 2, 5);
										v95 = v90['SoulCarver']['LastCastTime'];
										break;
									end
								end
							elseif ((1147 >= 335) and v90['Fracture']:IsAvailable() and (v90['Fracture']:TimeSinceLastCast() < v14:GCD()) and (v90['Fracture']['LastCastTime'] ~= v95)) then
								local v213 = 0;
								while true do
									if ((3435 > 2097) and (0 == v213)) then
										v96 = v34(v94 + 2 + v188, 5);
										v95 = v90['Fracture']['LastCastTime'];
										break;
									end
								end
							elseif (((v90['Shear']:TimeSinceLastCast() < v14:GCD()) and (v90['Fracture']['Shear'] ~= v95)) or (3770 >= 4041)) then
								local v216 = 0;
								while true do
									if ((v216 == 0) or (3791 <= 1611)) then
										v96 = v34(v94 + 1 + v188, 5);
										v95 = v90['Shear']['LastCastTime'];
										break;
									end
								end
							elseif (v90['SoulSigils']:IsAvailable() or (4578 <= 2008)) then
								local v218 = 0;
								local v219;
								local v220;
								while true do
									if ((1125 <= 2076) and (v218 == 1)) then
										if ((v90['ElysianDecree']:IsAvailable() and (v219 == v90['ElysianDecree']['LastCastTime']) and (v220 < v14:GCD()) and (v219 ~= v95)) or (743 >= 4399)) then
											local v226 = 0;
											local v227;
											while true do
												if ((1155 < 1673) and (v226 == 0)) then
													v227 = v34(v102, 3);
													v96 = v34(v94 + v227, 5);
													v226 = 1;
												end
												if ((v226 == 1) or (2324 <= 578)) then
													v95 = v219;
													break;
												end
											end
										elseif ((3767 == 3767) and (v220 < v14:GCD()) and (v219 ~= v95)) then
											local v229 = 0;
											while true do
												if ((4089 == 4089) and (v229 == 0)) then
													v96 = v34(v94 + 1, 5);
													v95 = v219;
													break;
												end
											end
										end
										break;
									end
									if ((4458 >= 1674) and (0 == v218)) then
										v219 = v32(v90['SigilOfFlame'].LastCastTime, v90['SigilOfSilence'].LastCastTime, v90['SigilOfChains'].LastCastTime, v90['ElysianDecree'].LastCastTime);
										v220 = v34(v90['SigilOfFlame']:TimeSinceLastCast(), v90['SigilOfSilence']:TimeSinceLastCast(), v90['SigilOfChains']:TimeSinceLastCast(), v90['ElysianDecree']:TimeSinceLastCast());
										v218 = 1;
									end
								end
							elseif ((972 <= 1418) and v90['Fallout']:IsAvailable() and (v90['ImmolationAura']:TimeSinceLastCast() < v14:GCD()) and (v90['ImmolationAura']['LastCastTime'] ~= v95)) then
								local v222 = 0;
								local v223;
								while true do
									if ((v222 == 0) or (4938 < 4762)) then
										v223 = 0.6 * v34(v102, 5);
										v96 = v34(v94 + v223, 5);
										v222 = 1;
									end
									if ((v222 == 1) or (2504 > 4264)) then
										v95 = v90['ImmolationAura']['LastCastTime'];
										break;
									end
								end
							elseif ((2153 == 2153) and v90['BulkExtraction']:IsAvailable() and (v90['BulkExtraction']:TimeSinceLastCast() < v14:GCD()) and (v90['BulkExtraction']['LastCastTime'] ~= v95)) then
								local v224 = 0;
								local v225;
								while true do
									if ((v224 == 1) or (507 >= 2591)) then
										v95 = v90['BulkExtraction']['LastCastTime'];
										break;
									end
									if ((4481 == 4481) and (v224 == 0)) then
										v225 = v34(v102, 5);
										v96 = v34(v94 + v225, 5);
										v224 = 1;
									end
								end
							end
							break;
						end
					end
				else
					local v189 = 0;
					local v190;
					local v191;
					while true do
						if ((v189 == 1) or (2328 < 693)) then
							if ((4328 == 4328) and v90['SoulSigils']:IsAvailable()) then
								local v202 = 0;
								while true do
									if ((1588 >= 1332) and (v202 == 1)) then
										v28(v191, v90.SigilOfChains);
										v28(v191, v90.ElysianDecree);
										break;
									end
									if ((v202 == 0) or (4174 > 4248)) then
										v28(v191, v90.SigilOfFlame);
										v28(v191, v90.SigilOfSilence);
										v202 = 1;
									end
								end
							end
							if (v90['Fallout']:IsAvailable() or (4586 <= 82)) then
								v28(v191, v90.ImmolationAura);
							end
							v189 = 2;
						end
						if ((3863 == 3863) and (v189 == 2)) then
							for v199, v200 in pairs(v191) do
								if (((v190 == v200:ID()) and (v200:TimeSinceLastCast() >= v14:GCD())) or (282 <= 42)) then
									v96 = 0;
									break;
								end
							end
							break;
						end
						if ((4609 >= 766) and (v189 == 0)) then
							v190 = v14:PrevGCD(1);
							v191 = {v90['SoulCarver'],v90['Fracture'],v90['Shear'],v90['BulkExtraction']};
							v189 = 1;
						end
					end
				end
				if ((v96 > v94) or (1152 == 2488)) then
					v94 = v96;
				elseif ((3422 > 3350) and (v96 > 0)) then
					v96 = 0;
				end
				break;
			end
			if ((877 > 376) and (v125 == 0)) then
				v94 = v14:BuffStack(v90.SoulFragments);
				if ((v90['SpiritBomb']:TimeSinceLastCast() < v14:GCD()) or (3118 <= 1851)) then
					v96 = 0;
				end
				v125 = 1;
			end
		end
	end
	local function v108()
		local v126 = 0;
		while true do
			if ((v126 == 0) or (165 >= 3492)) then
				if ((3949 < 4856) and ((v90['Felblade']:TimeSinceLastCast() < v14:GCD()) or (v90['InfernalStrike']:TimeSinceLastCast() < v14:GCD()))) then
					local v192 = 0;
					while true do
						if ((v192 == 0) or (4276 < 3016)) then
							v97 = true;
							v98 = true;
							v192 = 1;
						end
						if ((4690 > 4125) and (v192 == 1)) then
							return;
						end
					end
				end
				v97 = v15:IsInMeleeRange(5);
				v126 = 1;
			end
			if ((v126 == 1) or (50 >= 896)) then
				v98 = v97 or (v102 > 0);
				break;
			end
		end
	end
	local function v109(v127)
		return (v127:DebuffRemains(v90.FieryBrandDebuff));
	end
	local function v110(v128)
		return (v128:DebuffUp(v90.FieryBrandDebuff));
	end
	local function v111()
		local v129 = 0;
		while true do
			if ((v129 == 0) or (1714 >= 2958)) then
				v36 = v27.HandleTopTrinket(v93, v39, 40, nil);
				if (v36 or (1491 < 644)) then
					return v36;
				end
				v129 = 1;
			end
			if ((704 < 987) and (v129 == 1)) then
				v36 = v27.HandleBottomTrinket(v93, v39, 40, nil);
				if ((3718 > 1906) and v36) then
					return v36;
				end
				break;
			end
		end
	end
	local function v112()
		local v130 = 0;
		while true do
			if ((v130 == 1) or (958 > 3635)) then
				if ((3501 <= 4492) and v90['InfernalStrike']:IsCastable() and v45) then
					if (v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35)) or (3442 < 2548)) then
						return "infernal_strike precombat 6";
					end
				end
				if ((2875 >= 1464) and v90['Fracture']:IsCastable() and v43 and v97) then
					if (v25(v90.Fracture) or (4797 >= 4893)) then
						return "fracture precombat 8";
					end
				end
				v130 = 2;
			end
			if ((2 == v130) or (551 > 2068)) then
				if ((2114 > 944) and v90['Shear']:IsCastable() and v46 and v97) then
					if (v25(v90.Shear) or (2262 >= 3096)) then
						return "shear precombat 10";
					end
				end
				break;
			end
			if ((v130 == 0) or (2255 >= 3537)) then
				if ((v47 and not v14:IsMoving() and v90['SigilOfFlame']:IsCastable()) or (3837 < 1306)) then
					if ((2950 == 2950) and ((v87 == "player") or v90['ConcentratedSigils']:IsAvailable())) then
						if (v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35)) or (4723 < 3298)) then
							return "sigil_of_flame precombat 2";
						end
					elseif ((1136 >= 154) and (v87 == "cursor")) then
						if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(30)) or (271 > 4748)) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if ((4740 >= 3152) and v90['ImmolationAura']:IsCastable() and v44) then
					if (v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35)) or (2578 >= 3390)) then
						return "immolation_aura precombat 4";
					end
				end
				v130 = 1;
			end
		end
	end
	local function v113()
		local v131 = 0;
		while true do
			if ((41 <= 1661) and (v131 == 1)) then
				if ((601 < 3560) and v90['FieryBrand']:IsCastable() and v67 and (v99 or (v14:HealthPercentage() <= v70))) then
					if ((235 < 687) and v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand))) then
						return "fiery_brand defensives";
					end
				end
				if ((4549 > 1153) and v91['Healthstone']:IsReady() and v83 and (v14:HealthPercentage() <= v85)) then
					if (v25(v92.Healthstone) or (4674 < 4672)) then
						return "healthstone defensive";
					end
				end
				v131 = 2;
			end
			if ((3668 < 4561) and (0 == v131)) then
				if ((v90['DemonSpikes']:IsCastable() and v66 and v14:BuffDown(v90.DemonSpikesBuff) and v14:BuffDown(v90.MetamorphosisBuff) and (((v102 == 1) and v14:BuffDown(v90.FieryBrandDebuff)) or (v102 > 1))) or (455 == 3605)) then
					if ((v90['DemonSpikes']:ChargesFractional() > 1.9) or (2663 == 3312)) then
						if ((4277 <= 4475) and v25(v90.DemonSpikes)) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (v99 or (v14:HealthPercentage() <= v69) or (870 == 1189)) then
						if ((1553 <= 3133) and v25(v90.DemonSpikes)) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if ((v90['Metamorphosis']:IsCastable() and v68 and (v14:HealthPercentage() <= v71) and (v14:BuffDown(v90.MetamorphosisBuff) or (v15:TimeToDie() < 15))) or (2237 >= 3511)) then
					if (v25(v92.MetamorphosisPlayer) or (1324 > 3020)) then
						return "metamorphosis defensives";
					end
				end
				v131 = 1;
			end
			if ((v131 == 2) or (2992 == 1881)) then
				if ((3106 > 1526) and v82 and (v14:HealthPercentage() <= v84)) then
					local v193 = 0;
					while true do
						if ((3023 < 3870) and (v193 == 0)) then
							if ((143 > 74) and (v86 == "Refreshing Healing Potion")) then
								if ((18 < 2112) and v91['RefreshingHealingPotion']:IsReady()) then
									if ((1097 <= 1628) and v25(v92.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((4630 == 4630) and (v86 == "Dreamwalker's Healing Potion")) then
								if ((3540 > 2683) and v91['DreamwalkersHealingPotion']:IsReady()) then
									if ((4794 >= 3275) and v25(v92.RefreshingHealingPotion)) then
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
	local function v114()
		local v132 = 0;
		while true do
			if ((1484 == 1484) and (v132 == 1)) then
				if ((1432 < 3555) and v90['SigilOfSilence']:IsCastable() and v53 and not v14:IsMoving() and v90['CycleofBinding']:IsAvailable() and v90['SigilOfSilence']:IsAvailable()) then
					if ((v87 == "player") or v90['ConcentratedSigils']:IsAvailable() or (1065 > 3578)) then
						if (v25(v92.SigilOfSilencePlayer, not v15:IsInMeleeRange(v35)) or (4795 < 1407)) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((1853 < 4813) and (v87 == "cursor")) then
						if (v25(v92.SigilOfSilenceCursor, not v15:IsInRange(30)) or (2821 < 2431)) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v90['ThrowGlaive']:IsCastable() and v50) or (2874 < 2181)) then
					if (v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive)) or (2689 <= 343)) then
						return "throw_glaive filler 8";
					end
				end
				break;
			end
			if ((0 == v132) or (1869 == 2009)) then
				if ((v90['SigilOfChains']:IsCastable() and v54 and not v14:IsMoving() and v90['CycleofBinding']:IsAvailable() and v90['SigilOfChains']:IsAvailable()) or (3546 < 2322)) then
					if ((v87 == "player") or v90['ConcentratedSigils']:IsAvailable() or (2082 == 4773)) then
						if ((3244 > 1055) and v25(v92.SigilOfChainsPlayer, not v15:IsInMeleeRange(v35))) then
							return "sigil_of_chains player filler 2";
						end
					elseif ((v87 == "cursor") or (3313 <= 1778)) then
						if (v25(v92.SigilOfChainsCursor, not v15:IsInRange(30)) or (1421 >= 2104)) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if ((1812 <= 3249) and v90['SigilOfMisery']:IsCastable() and v55 and not v14:IsMoving() and v90['CycleofBinding']:IsAvailable() and v90['SigilOfMisery']:IsAvailable()) then
					if ((1623 <= 1957) and ((v87 == "player") or v90['ConcentratedSigils']:IsAvailable())) then
						if ((4412 == 4412) and v25(v92.SigilOfMiseryPlayer, not v15:IsInMeleeRange(v35))) then
							return "sigil_of_misery player filler 4";
						end
					elseif ((1750 >= 842) and (v87 == "cursor")) then
						if ((4372 > 1850) and v25(v92.SigilOfMiseryCursor, not v15:IsInRange(30))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v132 = 1;
			end
		end
	end
	local function v115()
		local v133 = 0;
		local v134;
		while true do
			if ((232 < 821) and (v133 == 2)) then
				if ((518 < 902) and v90['Fracture']:IsCastable() and v43) then
					if ((2994 > 858) and v25(v90.Fracture, not v97)) then
						return "fracture big_aoe 14";
					end
				end
				if ((v90['Shear']:IsCastable() and v46) or (3755 <= 915)) then
					if ((3946 > 3743) and v25(v90.Shear, not v97)) then
						return "shear big_aoe 16";
					end
				end
				if ((v90['SoulCleave']:IsReady() and (v94 < 1) and v48) or (1335 >= 3306)) then
					if ((4844 > 2253) and v25(v90.SoulCleave, not v97)) then
						return "soul_cleave big_aoe 18";
					end
				end
				v133 = 3;
			end
			if ((452 == 452) and (v133 == 3)) then
				v134 = v114();
				if (v134 or (4557 < 2087)) then
					return v134;
				end
				break;
			end
			if ((3874 == 3874) and (v133 == 0)) then
				if ((v90['FelDevastation']:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61) and (v90['CollectiveAnguish']:IsAvailable() or v90['StoketheFlames']:IsAvailable())) or (1938 > 4935)) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (4255 < 3423)) then
						return "fel_devastation big_aoe 2";
					end
				end
				if ((1454 <= 2491) and v90['TheHunt']:IsCastable() and (v79 < v105) and v59 and ((v39 and v63) or not v63)) then
					if (v25(v90.TheHunt, not v15:IsInRange(50)) or (4157 <= 2803)) then
						return "the_hunt big_aoe 4";
					end
				end
				if ((4853 >= 2982) and v90['ElysianDecree']:IsCastable() and (v79 < v105) and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v102 > v65)) then
					if ((4134 > 3357) and (v64 == "player")) then
						if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or (3417 < 2534)) then
							return "elysian_decree big_aoe 6 (Player)";
						end
					elseif ((v64 == "cursor") or (2722 <= 164)) then
						if (v25(v92.ElysianDecreeCursor, not v15:IsInRange(30)) or (2408 < 2109)) then
							return "elysian_decree big_aoe 6 (Cursor)";
						end
					end
				end
				v133 = 1;
			end
			if ((v133 == 1) or (33 == 1455)) then
				if ((v90['FelDevastation']:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61)) or (443 >= 4015)) then
					if ((3382 > 166) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return "fel_devastation big_aoe 8";
					end
				end
				if ((v90['SoulCarver']:IsCastable() and v58) or (280 == 3059)) then
					if ((1881 > 1293) and v25(v90.SoulCarver, not v97)) then
						return "soul_carver big_aoe 10";
					end
				end
				if ((2357 == 2357) and v90['SpiritBomb']:IsReady() and (v94 >= 4) and v49) then
					if ((123 == 123) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return "spirit_bomb big_aoe 12";
					end
				end
				v133 = 2;
			end
		end
	end
	local function v116()
		local v135 = 0;
		while true do
			if ((v135 == 1) or (1056 >= 3392)) then
				if ((v90['FelDevastation']:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) or (1081 < 1075)) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (1049 >= 4432)) then
						return "fel_devastation fiery_demise 8";
					end
				end
				if ((v90['SoulCarver']:IsCastable() and v58) or (4768 <= 846)) then
					if (v25(v90.SoulCarver, not v15:IsInMeleeRange(v35)) or (3358 <= 1420)) then
						return "soul_carver fiery_demise 10";
					end
				end
				if ((v90['SpiritBomb']:IsReady() and (v102 == 1) and (v94 >= 5) and v49) or (3739 <= 3005)) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (1659 >= 2134)) then
						return "spirit_bomb fiery_demise 12";
					end
				end
				v135 = 2;
			end
			if ((v135 == 2) or (3260 < 2355)) then
				if ((v90['SpiritBomb']:IsReady() and (v102 > 1) and (v102 <= 5) and (v94 >= 4) and v49) or (669 == 4223)) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (1692 < 588)) then
						return "spirit_bomb fiery_demise 14";
					end
				end
				if ((v90['SpiritBomb']:IsReady() and (v102 >= 6) and (v94 >= 3) and v49) or (4797 < 3651)) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (4177 > 4850)) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				if ((v90['TheHunt']:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) or (400 > 1111)) then
					if ((3051 > 1005) and v25(v90.TheHunt, not v15:IsInRange(30))) then
						return "the_hunt fiery_demise 18";
					end
				end
				v135 = 3;
			end
			if ((3693 <= 4382) and (v135 == 3)) then
				if ((v90['ElysianDecree']:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or (3282 > 4100)) then
					if ((v64 == "player") or (3580 < 2844)) then
						if ((89 < 4490) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
							return "elysian_decree fiery_demise 20 (Player)";
						end
					elseif ((v64 == "cursor") or (4983 < 1808)) then
						if ((3829 > 3769) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return "elysian_decree fiery_demise 20 (Cursor)";
						end
					end
				end
				if ((1485 <= 2904) and v90['SoulCleave']:IsReady() and (v14:FuryDeficit() <= 30) and not v103 and v48) then
					if ((4269 == 4269) and v25(v90.SoulCleave, not v97)) then
						return "soul_cleave fiery_demise 22";
					end
				end
				break;
			end
			if ((387 <= 2782) and (v135 == 0)) then
				if ((v90['ImmolationAura']:IsCastable() and v44) or (1899 <= 917)) then
					if (v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35)) or (4312 <= 876)) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if ((2232 <= 2596) and v90['SigilOfFlame']:IsCastable() and v47 and not v14:IsMoving() and (v98 or not v90['ConcentratedSigils']:IsAvailable()) and v15:DebuffRefreshable(v90.SigilOfFlameDebuff)) then
					if ((2095 < 3686) and (v90['ConcentratedSigils']:IsAvailable() or (v87 == "player"))) then
						if (v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35)) or (1595 >= 4474)) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif ((v87 == "cursor") or (4619 < 2882)) then
						if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(30)) or (294 >= 4831)) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				if ((2029 <= 3084) and v90['Felblade']:IsCastable() and v42 and (v90['FelDevastation']:CooldownRemains() <= (v90['FelDevastation']:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) then
					if (v25(v90.Felblade, not v97) or (2037 == 2420)) then
						return "felblade fiery_demise 6";
					end
				end
				v135 = 1;
			end
		end
	end
	local function v117()
		local v136 = 0;
		while true do
			if ((4458 > 3904) and (v136 == 3)) then
				if ((436 >= 123) and v90['Fracture']:IsCastable() and v43 and (v90['FelDevastation']:CooldownRemains() <= (v90['FelDevastation']:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) then
					if ((500 < 1816) and v25(v90.Fracture, not v97)) then
						return "fracture maintenance 14";
					end
				end
				if ((3574 == 3574) and v90['Shear']:IsCastable() and v46 and (v90['FelDevastation']:CooldownRemains() <= (v90['FelDevastation']:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) then
					if ((221 < 390) and v25(v90.Shear, not v97)) then
						return "shear maintenance 16";
					end
				end
				v136 = 4;
			end
			if ((v136 == 4) or (2213 <= 1421)) then
				if ((3058 < 4860) and v90['SpiritBomb']:IsReady() and (v14:FuryDeficit() < 30) and (((v102 >= 2) and (v94 >= 5)) or ((v102 >= 6) and (v94 >= 4))) and not v103 and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (1296 >= 4446)) then
						return "spirit_bomb maintenance 18";
					end
				end
				if ((v90['SoulCleave']:IsReady() and (v14:FuryDeficit() < 30) and (v94 <= 3) and not v103 and v48) or (1393 > 4489)) then
					if (v25(v90.SoulCleave, not v97) or (4424 < 27)) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if ((v136 == 0) or (1997 > 3815)) then
				if ((3465 > 1913) and v90['FieryBrand']:IsCastable() and v67 and ((v15:DebuffDown(v90.FieryBrandDebuff) and ((v90['SigilOfFlame']:CooldownRemains() < (v90['SigilOfFlame']:ExecuteTime() + v14:GCDRemains())) or (v90['SoulCarver']:CooldownRemains() < (v90['SoulCarver']:ExecuteTime() + v14:GCDRemains())) or (v90['FelDevastation']:CooldownRemains() < (v90['FelDevastation']:ExecuteTime() + v14:GCDRemains())))) or (v90['DownInFlames']:IsAvailable() and (v90['FieryBrand']:FullRechargeTime() < (v90['FieryBrand']:ExecuteTime() + v14:GCDRemains()))))) then
					if ((733 < 1819) and v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand))) then
						return "fiery_brand maintenance 2";
					end
				end
				if ((v90['SigilOfFlame']:IsCastable() and not v14:IsMoving()) or (4395 == 4755)) then
					if (v90['ConcentratedSigils']:IsAvailable() or (v87 == "player") or (3793 < 2369)) then
						if (v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35)) or (4084 == 265)) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((4358 == 4358) and (v87 == "cursor")) then
						if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(30)) or (3138 < 993)) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v136 = 1;
			end
			if ((3330 > 2323) and (v136 == 2)) then
				if ((v90['BulkExtraction']:IsCastable() and v40 and v14:PrevGCD(1, v90.SpiritBomb)) or (3626 == 3989)) then
					if (v25(v90.BulkExtraction, not v97) or (916 == 2671)) then
						return "bulk_extraction maintenance 10";
					end
				end
				if ((272 == 272) and v90['Felblade']:IsCastable() and v42 and (v14:FuryDeficit() >= 40)) then
					if ((4249 <= 4839) and v25(v90.Felblade, not v97)) then
						return "felblade maintenance 12";
					end
				end
				v136 = 3;
			end
			if ((2777 < 3200) and (v136 == 1)) then
				if ((95 < 1957) and v90['SpiritBomb']:IsReady() and (v94 >= 5) and v49) then
					if ((826 < 1717) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return "spirit_bomb maintenance 6";
					end
				end
				if ((1426 >= 1105) and v90['ImmolationAura']:IsCastable() and v44) then
					if ((2754 <= 3379) and v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35))) then
						return "immolation_aura maintenance 8";
					end
				end
				v136 = 2;
			end
		end
	end
	local function v118()
		local v137 = 0;
		local v138;
		while true do
			if ((v137 == 0) or (3927 == 1413)) then
				if ((v90['TheHunt']:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) or (1154 <= 788)) then
					if (v25(v90.TheHunt, not v15:IsInRange(30)) or (1643 > 3379)) then
						return "the_hunt single_target 2";
					end
				end
				if ((v90['SoulCarver']:IsCastable() and v58) or (2803 > 4549)) then
					if (v25(v90.SoulCarver, not v97) or (220 >= 3022)) then
						return "soul_carver single_target 4";
					end
				end
				if ((2822 == 2822) and v90['FelDevastation']:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90['CollectiveAnguish']:IsAvailable() or (v90['StoketheFlames']:IsAvailable() and v90['BurningBlood']:IsAvailable()))) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (1061 == 1857)) then
						return "fel_devastation single_target 6";
					end
				end
				if ((2760 > 1364) and v90['ElysianDecree']:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) then
					if ((v64 == "player") or (4902 <= 3595)) then
						if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or (3852 == 293)) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif ((v64 == "cursor") or (1559 == 4588)) then
						if (v25(v92.ElysianDecreeCursor, not v15:IsInRange(30)) or (4484 == 788)) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				v137 = 1;
			end
			if ((4568 >= 3907) and (v137 == 1)) then
				if ((1246 < 3470) and v90['FelDevastation']:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
					if ((4068 >= 972) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return "fel_devastation single_target 10";
					end
				end
				if ((493 < 3893) and v90['SoulCleave']:IsReady() and v90['FocusedCleave']:IsAvailable() and not v103 and v48) then
					if (v25(v90.SoulCleave, not v97) or (1473 >= 3332)) then
						return "soul_cleave single_target 12";
					end
				end
				if ((v90['Fracture']:IsCastable() and v43) or (4051 <= 1157)) then
					if ((604 < 2881) and v25(v90.Fracture, not v97)) then
						return "fracture single_target 14";
					end
				end
				if ((v90['Shear']:IsCastable() and v46) or (900 == 3377)) then
					if ((4459 > 591) and v25(v90.Shear, not v97)) then
						return "shear single_target 16";
					end
				end
				v137 = 2;
			end
			if ((3398 >= 2395) and (2 == v137)) then
				if ((v90['SoulCleave']:IsReady() and not v103 and v48) or (2183 >= 2824)) then
					if ((1936 == 1936) and v25(v90.SoulCleave, not v97)) then
						return "soul_cleave single_target 18";
					end
				end
				v138 = v114();
				if (v138 or (4832 < 4313)) then
					return v138;
				end
				break;
			end
		end
	end
	local function v119()
		local v139 = 0;
		local v140;
		while true do
			if ((4088 > 3874) and (v139 == 3)) then
				if ((4332 == 4332) and v90['SoulCleave']:IsReady() and (v94 <= 2) and v48) then
					if ((3999 >= 2900) and v25(v90.SoulCleave, not v97)) then
						return "soul_cleave small_aoe 20";
					end
				end
				v140 = v114();
				if (v140 or (2525 > 4064)) then
					return v140;
				end
				break;
			end
			if ((4371 == 4371) and (v139 == 0)) then
				if ((v90['TheHunt']:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) or (266 > 4986)) then
					if ((1991 >= 925) and v25(v90.TheHunt, not v15:IsInRange(30))) then
						return "the_hunt small_aoe 2";
					end
				end
				if ((455 < 2053) and v90['FelDevastation']:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90['CollectiveAnguish']:IsAvailable() or (v90['StoketheFlames']:IsAvailable() and v90['BurningBlood']:IsAvailable()))) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (826 == 4851)) then
						return "fel_devastation small_aoe 4";
					end
				end
				if ((183 == 183) and v90['ElysianDecree']:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) then
					if ((1159 <= 1788) and (v64 == "player")) then
						if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or (3507 > 4318)) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif ((v64 == "cursor") or (3075 <= 2965)) then
						if ((1365 <= 2011) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				v139 = 1;
			end
			if ((v139 == 1) or (2776 > 3575)) then
				if ((v90['FelDevastation']:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) or (2554 == 4804)) then
					if ((2577 == 2577) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return "fel_devastation small_aoe 8";
					end
				end
				if ((v90['SoulCarver']:IsCastable() and v58) or (6 >= 1889)) then
					if ((506 <= 1892) and v25(v90.SoulCarver, not v97)) then
						return "soul_carver small_aoe 10";
					end
				end
				if ((v90['SpiritBomb']:IsReady() and (v94 >= 5) and v49) or (2008 > 2218)) then
					if ((379 <= 4147) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return "spirit_bomb small_aoe 12";
					end
				end
				v139 = 2;
			end
			if ((v139 == 2) or (4514 <= 1009)) then
				if ((v90['SoulCleave']:IsReady() and v90['FocusedCleave']:IsAvailable() and (v94 <= 2) and v48) or (3496 == 1192)) then
					if (v25(v90.SoulCleave, not v97) or (208 == 2959)) then
						return "soul_cleave small_aoe 14";
					end
				end
				if ((4277 >= 1313) and v90['Fracture']:IsCastable() and v43) then
					if ((2587 < 3174) and v25(v90.Fracture, not v97)) then
						return "fracture small_aoe 16";
					end
				end
				if ((v90['Shear']:IsCastable() and v46) or (4120 <= 2198)) then
					if (v25(v90.Shear, not v97) or (1596 == 858)) then
						return "shear small_aoe 18";
					end
				end
				v139 = 3;
			end
		end
	end
	local function v120()
		local v141 = 0;
		while true do
			if ((3220 == 3220) and (v141 == 0)) then
				v40 = EpicSettings['Settings']['useBulkExtraction'];
				v41 = EpicSettings['Settings']['useConsumeMagic'];
				v42 = EpicSettings['Settings']['useFelblade'];
				v43 = EpicSettings['Settings']['useFracture'];
				v44 = EpicSettings['Settings']['useImmolationAura'];
				v45 = EpicSettings['Settings']['useInfernalStrike'];
				v141 = 1;
			end
			if ((v141 == 1) or (1402 > 3620)) then
				v46 = EpicSettings['Settings']['useShear'];
				v47 = EpicSettings['Settings']['useSigilOfFlame'];
				v48 = EpicSettings['Settings']['useSoulCleave'];
				v49 = EpicSettings['Settings']['useSpiritBomb'];
				v50 = EpicSettings['Settings']['useThrowGlaive'];
				v51 = EpicSettings['Settings']['useChaosNova'];
				v141 = 2;
			end
			if ((2574 == 2574) and (v141 == 2)) then
				v52 = EpicSettings['Settings']['useDisrupt'];
				v53 = EpicSettings['Settings']['useSigilOfSilence'];
				v54 = EpicSettings['Settings']['useSigilOfChains'];
				v55 = EpicSettings['Settings']['useSigilOfMisery'];
				v56 = EpicSettings['Settings']['useElysianDecree'];
				v57 = EpicSettings['Settings']['useFelDevastation'];
				v141 = 3;
			end
			if ((1798 < 2757) and (v141 == 5)) then
				v87 = EpicSettings['Settings']['sigilSetting'] or "player";
				v64 = EpicSettings['Settings']['elysianDecreeSetting'] or "player";
				v65 = EpicSettings['Settings']['elysianDecreeSlider'] or 0;
				v88 = EpicSettings['Settings']['fieryBrandOffensively'];
				v89 = EpicSettings['Settings']['metamorphosisOffensively'];
				break;
			end
			if ((v141 == 4) or (377 > 2604)) then
				v66 = EpicSettings['Settings']['useDemonSpikes'];
				v67 = EpicSettings['Settings']['useFieryBrand'];
				v68 = EpicSettings['Settings']['useMetamorphosis'];
				v69 = EpicSettings['Settings']['demonSpikesHP'] or 0;
				v70 = EpicSettings['Settings']['fieryBrandHP'] or 0;
				v71 = EpicSettings['Settings']['metamorphosisHP'] or 0;
				v141 = 5;
			end
			if ((568 < 911) and (v141 == 3)) then
				v58 = EpicSettings['Settings']['useSoulCarver'];
				v59 = EpicSettings['Settings']['useTheHunt'];
				v60 = EpicSettings['Settings']['elysianDecreeWithCD'];
				v61 = EpicSettings['Settings']['felDevastationWithCD'];
				v62 = EpicSettings['Settings']['soulCarverWithCD'];
				v63 = EpicSettings['Settings']['theHuntWithCD'];
				v141 = 4;
			end
		end
	end
	local function v121()
		local v142 = 0;
		while true do
			if ((3285 < 4228) and (1 == v142)) then
				v78 = EpicSettings['Settings']['InterruptThreshold'];
				v80 = EpicSettings['Settings']['useTrinkets'];
				v81 = EpicSettings['Settings']['trinketsWithCD'];
				v83 = EpicSettings['Settings']['useHealthstone'];
				v142 = 2;
			end
			if ((3916 > 3328) and (v142 == 2)) then
				v82 = EpicSettings['Settings']['useHealingPotion'];
				v85 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v84 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v86 = EpicSettings['Settings']['HealingPotionName'] or "";
				v142 = 3;
			end
			if ((2500 < 3839) and (v142 == 0)) then
				v79 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v72 = EpicSettings['Settings']['dispelBuffs'];
				v76 = EpicSettings['Settings']['InterruptWithStun'];
				v77 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v142 = 1;
			end
			if ((507 == 507) and (v142 == 3)) then
				v75 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v122()
		local v143 = 0;
		while true do
			if ((240 <= 3165) and (v143 == 1)) then
				v39 = EpicSettings['Toggles']['cds'];
				if ((834 >= 805) and v14:IsDeadOrGhost()) then
					return;
				end
				if (v90['ImprovedDisrupt']:IsAvailable() or (3812 < 2316)) then
					v35 = 10;
				end
				v101 = v14:GetEnemiesInMeleeRange(v35);
				v143 = 2;
			end
			if ((v143 == 0) or (2652 <= 1533)) then
				v120();
				v121();
				v37 = EpicSettings['Toggles']['ooc'];
				v38 = EpicSettings['Toggles']['aoe'];
				v143 = 1;
			end
			if ((v143 == 3) or (3598 < 1460)) then
				v100 = v14:IsTankingAoE(8) or v14:IsTanking(v15);
				if (v27.TargetIsValid() or v14:AffectingCombat() or (4116 < 1192)) then
					local v194 = 0;
					while true do
						if ((0 == v194) or (3377 <= 903)) then
							v104 = v10.BossFightRemains(nil, true);
							v105 = v104;
							v194 = 1;
						end
						if ((3976 >= 439) and (v194 == 1)) then
							if ((3752 == 3752) and (v105 == 11111)) then
								v105 = v10.FightRemains(v101, false);
							end
							break;
						end
					end
				end
				if ((4046 > 2695) and v75) then
					local v195 = 0;
					while true do
						if ((0 == v195) or (3545 == 3197)) then
							v36 = v27.HandleIncorporeal(v90.Imprison, v92.ImprisonMouseover, 20);
							if ((2394 > 373) and v36) then
								return v36;
							end
							break;
						end
					end
				end
				if ((4155 <= 4232) and v27.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v196 = 0;
					local v197;
					local v198;
					while true do
						if ((v196 == 1) or (3581 == 3473)) then
							if ((4995 > 3348) and not v14:AffectingCombat() and v37) then
								local v203 = 0;
								while true do
									if ((v203 == 0) or (754 > 3724)) then
										v198 = v112();
										if ((217 >= 57) and v198) then
											return v198;
										end
										break;
									end
								end
							end
							if ((v90['ConsumeMagic']:IsAvailable() and v41 and v90['ConsumeMagic']:IsReady() and v72 and not v14:IsCasting() and not v14:IsChanneling() and v27.UnitHasMagicBuff(v15)) or (2070 >= 4037)) then
								if ((2705 == 2705) and v25(v90.ConsumeMagic, not v15:IsSpellInRange(v90.ConsumeMagic))) then
									return "greater_purge damage";
								end
							end
							if ((61 == 61) and v100) then
								local v204 = 0;
								while true do
									if ((v204 == 0) or (699 >= 1296)) then
										v198 = v113();
										if (v198 or (1783 >= 3616)) then
											return v198;
										end
										break;
									end
								end
							end
							v196 = 2;
						end
						if ((v196 == 0) or (3913 > 4527)) then
							v103 = (v90['FelDevastation']:CooldownRemains() < (v90['SoulCleave']:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50);
							if ((4376 > 817) and v90['ThrowGlaive']:IsCastable() and v50 and v12.ValueIsInArray(v106, v15:NPCID())) then
								if ((4861 > 824) and v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive))) then
									return "fodder to the flames on those filthy demons";
								end
							end
							if ((v90['ThrowGlaive']:IsReady() and v50 and v12.ValueIsInArray(v106, v16:NPCID())) or (1383 >= 2131)) then
								if (v25(v92.ThrowGlaiveMouseover, not v15:IsSpellInRange(v90.ThrowGlaive)) or (1876 >= 2541)) then
									return "fodder to the flames react per mouseover";
								end
							end
							v196 = 1;
						end
						if ((1782 <= 3772) and (v196 == 4)) then
							v198 = v117();
							if (v198 or (4700 < 813)) then
								return v198;
							end
							if ((3199 < 4050) and (v102 <= 1)) then
								local v205 = 0;
								local v206;
								while true do
									if ((v205 == 0) or (4951 < 4430)) then
										v206 = v118();
										if ((96 == 96) and v206) then
											return v206;
										end
										break;
									end
								end
							end
							v196 = 5;
						end
						if ((v196 == 2) or (2739 > 4008)) then
							if ((v90['InfernalStrike']:IsCastable() and (v45 or (v90['InfernalStrike']:ChargesFractional() > 1.9)) and (v90['InfernalStrike']:TimeSinceLastCast() > 2)) or (23 == 1134)) then
								if (v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35)) or (2693 >= 4111)) then
									return "infernal_strike main 2";
								end
							end
							if (((v79 < v105) and v90['Metamorphosis']:IsCastable() and v68 and v89 and v14:BuffDown(v90.MetamorphosisBuff) and v15:DebuffDown(v90.FieryBrandDebuff)) or (4316 <= 2146)) then
								if (v25(v92.MetamorphosisPlayer, not v97) or (3546 <= 2809)) then
									return "metamorphosis main 4";
								end
							end
							v197 = v27.HandleDPSPotion();
							v196 = 3;
						end
						if ((4904 > 2166) and (v196 == 5)) then
							if ((109 >= 90) and (v102 > 1) and (v102 <= 5)) then
								local v207 = 0;
								local v208;
								while true do
									if ((4978 > 2905) and (v207 == 0)) then
										v208 = v119();
										if (v208 or (3026 <= 2280)) then
											return v208;
										end
										break;
									end
								end
							end
							if ((v102 >= 6) or (1653 <= 1108)) then
								local v209 = 0;
								local v210;
								while true do
									if ((2909 > 2609) and (v209 == 0)) then
										v210 = v115();
										if ((757 > 194) and v210) then
											return v210;
										end
										break;
									end
								end
							end
							break;
						end
						if ((3 == v196) or (31 >= 1398)) then
							if ((3196 <= 4872) and v197) then
								return v197;
							end
							if ((3326 == 3326) and (v79 < v105)) then
								if ((1433 <= 3878) and v80 and ((v39 and v81) or not v81)) then
									local v214 = 0;
									while true do
										if ((0 == v214) or (1583 == 1735)) then
											v198 = v111();
											if (v198 or (2981 == 2350)) then
												return v198;
											end
											break;
										end
									end
								end
							end
							if ((v90['FieryDemise']:IsAvailable() and (v90['FieryBrandDebuff']:AuraActiveCount() > 1)) or (4466 <= 493)) then
								local v211 = 0;
								local v212;
								while true do
									if ((v211 == 0) or (2547 <= 1987)) then
										v212 = v116();
										if ((2961 > 2740) and v212) then
											return v212;
										end
										break;
									end
								end
							end
							v196 = 4;
						end
					end
				end
				break;
			end
			if ((3696 >= 3612) and (2 == v143)) then
				if (v38 or (2970 == 1878)) then
					v102 = #v101;
				else
					v102 = 1;
				end
				v107();
				v108();
				v99 = v14:ActiveMitigationNeeded();
				v143 = 3;
			end
		end
	end
	local function v123()
		local v144 = 0;
		while true do
			if ((v144 == 0) or (3693 < 1977)) then
				v20.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
				v90['FieryBrandDebuff']:RegisterAuraTracking();
				break;
			end
		end
	end
	v20.SetAPL(581, v122, v123);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

