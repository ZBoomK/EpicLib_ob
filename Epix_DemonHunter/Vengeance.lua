local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 470 - (247 + 223);
	local v6;
	while true do
		if (((738 + 727) <= (11081 - 6780)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((2807 - 1103) > (1027 + 398)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 843 - (497 + 345);
		end
		if ((v5 == (1 + 0)) or ((117 + 570) == (5567 - (605 + 728)))) then
			return v6(...);
		end
	end
end
v0["Epix_DemonHunter_Vengeance.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.MouseOver;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Press;
	local v21 = v19.Macro;
	local v22 = v19.Commons.Everyone;
	local v23 = v10.Utils.MergeTableByKey;
	local v24 = v22.num;
	local v25 = v22.bool;
	local v26 = GetTime;
	local v27 = math.max;
	local v28 = math.min;
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
	local v84 = v17.DemonHunter.Vengeance;
	local v85 = v18.DemonHunter.Vengeance;
	local v86 = v21.DemonHunter.Vengeance;
	local v87 = {};
	local v88, v89;
	local v90 = 0 + 0;
	local v91, v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97 = true;
	local v98 = 24702 - 13591;
	local v99 = 510 + 10601;
	local v100 = {(152733 + 16688),(127925 + 41500),(71674 + 97258),(159615 + 9811),(599577 - 430148),(170224 - (588 + 208)),(171230 - (884 + 916))};
	v10:RegisterForEvent(function()
		local v116 = 0 - 0;
		while true do
			if ((v116 == (0 + 0)) or ((3983 - (232 + 421)) < (3318 - (1569 + 320)))) then
				v98 = 2727 + 8384;
				v99 = 2111 + 9000;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v101()
		v88 = v14:BuffStack(v84.SoulFragments);
		if (((3865 - 2718) >= (940 - (316 + 289))) and (v84.SpiritBomb:TimeSinceLastCast() < v14:GCD())) then
			v90 = 0 - 0;
		end
		if (((159 + 3276) > (3550 - (666 + 787))) and (v90 == (425 - (360 + 65)))) then
			local v133 = 0 + 0;
			local v134;
			while true do
				if ((v133 == (254 - (79 + 175))) or ((5944 - 2174) >= (3154 + 887))) then
					v134 = ((v14:BuffUp(v84.MetamorphosisBuff)) and (2 - 1)) or (0 - 0);
					if ((v84.SoulCarver:IsAvailable() and (v84.SoulCarver:TimeSinceLastCast() < v14:GCD()) and (v84.SoulCarver.LastCastTime ~= v89)) or ((4690 - (503 + 396)) <= (1792 - (92 + 89)))) then
						v90 = v28(v88 + (3 - 1), 3 + 2);
						v89 = v84.SoulCarver.LastCastTime;
					elseif ((v84.Fracture:IsAvailable() and (v84.Fracture:TimeSinceLastCast() < v14:GCD()) and (v84.Fracture.LastCastTime ~= v89)) or ((2710 + 1868) <= (7863 - 5855))) then
						v90 = v28(v88 + 1 + 1 + v134, 11 - 6);
						v89 = v84.Fracture.LastCastTime;
					elseif (((982 + 143) <= (992 + 1084)) and (v84.Shear:TimeSinceLastCast() < v14:GCD()) and (v84.Fracture.Shear ~= v89)) then
						local v199 = 0 - 0;
						while true do
							if ((v199 == (0 + 0)) or ((1132 - 389) >= (5643 - (485 + 759)))) then
								v90 = v28(v88 + (2 - 1) + v134, 1194 - (442 + 747));
								v89 = v84.Shear.LastCastTime;
								break;
							end
						end
					elseif (((2290 - (832 + 303)) < (2619 - (88 + 858))) and v84.SoulSigils:IsAvailable()) then
						local v200 = 0 + 0;
						local v201;
						local v202;
						while true do
							if ((v200 == (1 + 0)) or ((96 + 2228) <= (1367 - (766 + 23)))) then
								if (((18596 - 14829) == (5151 - 1384)) and v84.ElysianDecree:IsAvailable() and (v201 == v84.ElysianDecree.LastCastTime) and (v202 < v14:GCD()) and (v201 ~= v89)) then
									local v208 = 0 - 0;
									local v209;
									while true do
										if (((13878 - 9789) == (5162 - (1036 + 37))) and ((0 + 0) == v208)) then
											v209 = v28(v96, 5 - 2);
											v90 = v28(v88 + v209, 4 + 1);
											v208 = 1481 - (641 + 839);
										end
										if (((5371 - (910 + 3)) >= (4267 - 2593)) and (v208 == (1685 - (1466 + 218)))) then
											v89 = v201;
											break;
										end
									end
								elseif (((447 + 525) <= (2566 - (556 + 592))) and (v202 < v14:GCD()) and (v201 ~= v89)) then
									local v211 = 0 + 0;
									while true do
										if ((v211 == (808 - (329 + 479))) or ((5792 - (174 + 680)) < (16362 - 11600))) then
											v90 = v28(v88 + (1 - 0), 4 + 1);
											v89 = v201;
											break;
										end
									end
								end
								break;
							end
							if ((v200 == (739 - (396 + 343))) or ((222 + 2282) > (5741 - (29 + 1448)))) then
								v201 = v27(v84.SigilOfFlame.LastCastTime, v84.SigilOfSilence.LastCastTime, v84.SigilOfChains.LastCastTime, v84.ElysianDecree.LastCastTime);
								v202 = v28(v84.SigilOfFlame:TimeSinceLastCast(), v84.SigilOfSilence:TimeSinceLastCast(), v84.SigilOfChains:TimeSinceLastCast(), v84.ElysianDecree:TimeSinceLastCast());
								v200 = 1390 - (135 + 1254);
							end
						end
					elseif (((8110 - 5957) == (10052 - 7899)) and v84.Fallout:IsAvailable() and (v84.ImmolationAura:TimeSinceLastCast() < v14:GCD()) and (v84.ImmolationAura.LastCastTime ~= v89)) then
						local v204 = 0 + 0;
						local v205;
						while true do
							if ((v204 == (1528 - (389 + 1138))) or ((1081 - (102 + 472)) >= (2446 + 145))) then
								v89 = v84.ImmolationAura.LastCastTime;
								break;
							end
							if (((2485 + 1996) == (4179 + 302)) and (v204 == (1545 - (320 + 1225)))) then
								v205 = (0.6 - 0) * v28(v96, 4 + 1);
								v90 = v28(v88 + v205, 1469 - (157 + 1307));
								v204 = 1860 - (821 + 1038);
							end
						end
					elseif ((v84.BulkExtraction:IsAvailable() and (v84.BulkExtraction:TimeSinceLastCast() < v14:GCD()) and (v84.BulkExtraction.LastCastTime ~= v89)) or ((5808 - 3480) < (76 + 617))) then
						local v206 = 0 - 0;
						local v207;
						while true do
							if (((1611 + 2717) == (10727 - 6399)) and (v206 == (1026 - (834 + 192)))) then
								v207 = v28(v96, 1 + 4);
								v90 = v28(v88 + v207, 2 + 3);
								v206 = 1 + 0;
							end
							if (((2459 - 871) >= (1636 - (300 + 4))) and (v206 == (1 + 0))) then
								v89 = v84.BulkExtraction.LastCastTime;
								break;
							end
						end
					end
					break;
				end
			end
		else
			local v135 = 0 - 0;
			local v136;
			local v137;
			while true do
				if (((362 - (112 + 250)) == v135) or ((1664 + 2510) > (10641 - 6393))) then
					v136 = v14:PrevGCD(1 + 0);
					v137 = {v84.SoulCarver,v84.Fracture,v84.Shear,v84.BulkExtraction};
					v135 = 1415 - (1001 + 413);
				end
				if ((v135 == (2 - 1)) or ((5468 - (244 + 638)) <= (775 - (627 + 66)))) then
					if (((11510 - 7647) == (4465 - (512 + 90))) and v84.SoulSigils:IsAvailable()) then
						local v188 = 1906 - (1665 + 241);
						while true do
							if ((v188 == (718 - (373 + 344))) or ((128 + 154) <= (12 + 30))) then
								v23(v137, v84.SigilOfChains);
								v23(v137, v84.ElysianDecree);
								break;
							end
							if (((12157 - 7548) >= (1295 - 529)) and (v188 == (1099 - (35 + 1064)))) then
								v23(v137, v84.SigilOfFlame);
								v23(v137, v84.SigilOfSilence);
								v188 = 1 + 0;
							end
						end
					end
					if (v84.Fallout:IsAvailable() or ((2464 - 1312) == (10 + 2478))) then
						v23(v137, v84.ImmolationAura);
					end
					v135 = 1238 - (298 + 938);
				end
				if (((4681 - (233 + 1026)) > (5016 - (636 + 1030))) and ((2 + 0) == v135)) then
					for v185, v186 in pairs(v137) do
						if (((857 + 20) > (112 + 264)) and (v136 == v186:ID()) and (v186:TimeSinceLastCast() >= v14:GCD())) then
							v90 = 0 + 0;
							break;
						end
					end
					break;
				end
			end
		end
		if ((v90 > v88) or ((3339 - (55 + 166)) <= (359 + 1492))) then
			v88 = v90;
		elseif ((v90 > (0 + 0)) or ((629 - 464) >= (3789 - (36 + 261)))) then
			v90 = 0 - 0;
		end
	end
	local function v102()
		local v117 = 1368 - (34 + 1334);
		while true do
			if (((1519 + 2430) < (3774 + 1082)) and (v117 == (1283 - (1035 + 248)))) then
				if ((v84.Felblade:TimeSinceLastCast() < v14:GCD()) or (v84.InfernalStrike:TimeSinceLastCast() < v14:GCD()) or ((4297 - (20 + 1)) < (1572 + 1444))) then
					local v183 = 319 - (134 + 185);
					while true do
						if (((5823 - (549 + 584)) > (4810 - (314 + 371))) and (v183 == (0 - 0))) then
							v91 = true;
							v92 = true;
							v183 = 969 - (478 + 490);
						end
						if (((1 + 0) == v183) or ((1222 - (786 + 386)) >= (2901 - 2005))) then
							return;
						end
					end
				end
				v91 = v15:IsInMeleeRange(1384 - (1055 + 324));
				v117 = 1341 - (1093 + 247);
			end
			if ((v117 == (1 + 0)) or ((181 + 1533) >= (11743 - 8785))) then
				v92 = v91 or (v96 > (0 - 0));
				break;
			end
		end
	end
	local function v103()
		local v118 = 0 - 0;
		while true do
			if ((v118 == (0 - 0)) or ((531 + 960) < (2480 - 1836))) then
				v29 = v22.HandleTopTrinket(v87, v32, 137 - 97, nil);
				if (((531 + 173) < (2523 - 1536)) and v29) then
					return v29;
				end
				v118 = 689 - (364 + 324);
			end
			if (((10192 - 6474) > (4573 - 2667)) and (v118 == (1 + 0))) then
				v29 = v22.HandleBottomTrinket(v87, v32, 167 - 127, nil);
				if (v29 or ((1534 - 576) > (11039 - 7404))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v104()
		local v119 = 1268 - (1249 + 19);
		while true do
			if (((3161 + 340) <= (17484 - 12992)) and ((1087 - (686 + 400)) == v119)) then
				if ((v84.InfernalStrike:IsCastable() and v39 and ((not v33 and v82) or not v82) and (v84.InfernalStrike:ChargesFractional() > (1.7 + 0))) or ((3671 - (73 + 156)) < (13 + 2535))) then
					if (((3686 - (721 + 90)) >= (17 + 1447)) and v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(25 - 17))) then
						return "infernal_strike precombat 6";
					end
				end
				if ((v84.Fracture:IsCastable() and v37 and v91) or ((5267 - (224 + 246)) >= (7926 - 3033))) then
					if (v20(v84.Fracture) or ((1014 - 463) > (376 + 1692))) then
						return "fracture precombat 8";
					end
				end
				v119 = 1 + 1;
			end
			if (((1553 + 561) > (1876 - 932)) and (v119 == (6 - 4))) then
				if ((v84.Shear:IsCastable() and v40 and v91) or ((2775 - (203 + 310)) >= (5089 - (1238 + 755)))) then
					if (v20(v84.Shear) or ((158 + 2097) >= (5071 - (709 + 825)))) then
						return "shear precombat 10";
					end
				end
				break;
			end
			if ((v119 == (0 - 0)) or ((5589 - 1752) < (2170 - (196 + 668)))) then
				if (((11647 - 8697) == (6110 - 3160)) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and v84.SigilOfFlame:IsCastable()) then
					if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((5556 - (171 + 662)) < (3391 - (4 + 89)))) then
						if (((3981 - 2845) >= (57 + 97)) and v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(35 - 27))) then
							return "sigil_of_flame precombat 2";
						end
					elseif ((v79 == "cursor") or ((107 + 164) > (6234 - (35 + 1451)))) then
						if (((6193 - (28 + 1425)) >= (5145 - (941 + 1052))) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(29 + 1))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if ((v84.ImmolationAura:IsCastable() and v38) or ((4092 - (822 + 692)) >= (4839 - 1449))) then
					if (((20 + 21) <= (1958 - (45 + 252))) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(8 + 0))) then
						return "immolation_aura precombat 4";
					end
				end
				v119 = 1 + 0;
			end
		end
	end
	local function v105()
		local v120 = 0 - 0;
		while true do
			if (((1034 - (114 + 319)) < (5111 - 1551)) and (v120 == (1 - 0))) then
				if (((150 + 85) < (1022 - 335)) and v84.FieryBrand:IsCastable() and v61 and (v93 or (v14:HealthPercentage() <= v64))) then
					if (((9531 - 4982) > (3116 - (556 + 1407))) and v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand))) then
						return "fiery_brand defensives";
					end
				end
				if ((v85.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or ((5880 - (741 + 465)) < (5137 - (170 + 295)))) then
					if (((1933 + 1735) < (4190 + 371)) and v20(v86.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v120 = 4 - 2;
			end
			if ((v120 == (0 + 0)) or ((292 + 163) == (2042 + 1563))) then
				if ((v84.DemonSpikes:IsCastable() and v60 and v14:BuffDown(v84.DemonSpikesBuff) and v14:BuffDown(v84.MetamorphosisBuff) and (((v96 == (1231 - (957 + 273))) and v14:BuffDown(v84.FieryBrandDebuff)) or (v96 > (1 + 0)))) or ((1067 + 1596) == (12620 - 9308))) then
					if (((11270 - 6993) <= (13668 - 9193)) and (v84.DemonSpikes:ChargesFractional() > (4.9 - 3))) then
						if (v20(v84.DemonSpikes) or ((2650 - (389 + 1391)) == (746 + 443))) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (((162 + 1391) <= (7132 - 3999)) and (v93 or (v14:HealthPercentage() <= v63))) then
						if (v20(v84.DemonSpikes) or ((3188 - (783 + 168)) >= (11783 - 8272))) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if ((v84.Metamorphosis:IsCastable() and v62 and (v14:HealthPercentage() <= v65) and (v14:BuffDown(v84.MetamorphosisBuff) or (v15:TimeToDie() < (15 + 0)))) or ((1635 - (309 + 2)) > (9274 - 6254))) then
					if (v20(v86.MetamorphosisPlayer) or ((4204 - (1090 + 122)) == (610 + 1271))) then
						return "metamorphosis defensives";
					end
				end
				v120 = 3 - 2;
			end
			if (((2126 + 980) > (2644 - (628 + 490))) and (v120 == (1 + 1))) then
				if (((7484 - 4461) < (17685 - 13815)) and v74 and (v14:HealthPercentage() <= v76)) then
					local v184 = 774 - (431 + 343);
					while true do
						if (((288 - 145) > (213 - 139)) and (v184 == (0 + 0))) then
							if (((3 + 15) < (3807 - (556 + 1139))) and (v78 == "Refreshing Healing Potion")) then
								if (((1112 - (6 + 9)) <= (299 + 1329)) and v85.RefreshingHealingPotion:IsReady()) then
									if (((2372 + 2258) == (4799 - (28 + 141))) and v20(v86.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((1372 + 2168) > (3311 - 628)) and (v78 == "Dreamwalker's Healing Potion")) then
								if (((3396 + 1398) >= (4592 - (486 + 831))) and v85.DreamwalkersHealingPotion:IsReady()) then
									if (((3861 - 2377) == (5224 - 3740)) and v20(v86.RefreshingHealingPotion)) then
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
	local function v106()
		local v121 = 0 + 0;
		while true do
			if (((4527 - 3095) < (4818 - (668 + 595))) and (v121 == (1 + 0))) then
				if ((v84.SigilOfSilence:IsCastable() and v47 and not v14:IsMoving() and v84.CycleofBinding:IsAvailable() and v84.SigilOfSilence:IsAvailable()) or ((215 + 850) > (9757 - 6179))) then
					if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((5085 - (23 + 267)) < (3351 - (1129 + 815)))) then
						if (((2240 - (371 + 16)) < (6563 - (1326 + 424))) and v20(v86.SigilOfSilencePlayer, not v15:IsInMeleeRange(14 - 6))) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((v79 == "cursor") or ((10308 - 7487) < (2549 - (88 + 30)))) then
						if (v20(v86.SigilOfSilenceCursor, not v15:IsInRange(801 - (720 + 51))) or ((6392 - 3518) < (3957 - (421 + 1355)))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v84.ThrowGlaive:IsCastable() and v44) or ((4435 - 1746) <= (169 + 174))) then
					if (v20(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((2952 - (286 + 797)) == (7344 - 5335))) then
						return "throw_glaive filler 8";
					end
				end
				break;
			end
			if ((v121 == (0 - 0)) or ((3985 - (397 + 42)) < (726 + 1596))) then
				if ((v84.SigilOfChains:IsCastable() and v48 and not v14:IsMoving() and v84.CycleofBinding:IsAvailable() and v84.SigilOfChains:IsAvailable()) or ((2882 - (24 + 776)) == (7353 - 2580))) then
					if (((4029 - (222 + 563)) > (2324 - 1269)) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
						if (v20(v86.SigilOfChainsPlayer, not v15:IsInMeleeRange(6 + 2)) or ((3503 - (23 + 167)) <= (3576 - (690 + 1108)))) then
							return "sigil_of_chains player filler 2";
						end
					elseif ((v79 == "cursor") or ((513 + 908) >= (1736 + 368))) then
						if (((2660 - (40 + 808)) <= (535 + 2714)) and v20(v86.SigilOfChainsCursor, not v15:IsInRange(114 - 84))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if (((1552 + 71) <= (1036 + 921)) and v84.SigilOfMisery:IsCastable() and v49 and not v14:IsMoving() and v84.CycleofBinding:IsAvailable() and v84.SigilOfMisery:IsAvailable()) then
					if (((2420 + 1992) == (4983 - (47 + 524))) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
						if (((1136 + 614) >= (2301 - 1459)) and v20(v86.SigilOfMiseryPlayer, not v15:IsInMeleeRange(11 - 3))) then
							return "sigil_of_misery player filler 4";
						end
					elseif (((9970 - 5598) > (3576 - (1165 + 561))) and (v79 == "cursor")) then
						if (((7 + 225) < (2542 - 1721)) and v20(v86.SigilOfMiseryCursor, not v15:IsInRange(12 + 18))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v121 = 480 - (341 + 138);
			end
		end
	end
	local function v107()
		if (((140 + 378) < (1861 - 959)) and v84.FelDevastation:IsReady() and ((not v33 and v82) or not v82) and (v71 < v99) and v51 and ((v32 and v55) or not v55) and (v84.CollectiveAnguish:IsAvailable() or v84.StoketheFlames:IsAvailable())) then
			if (((3320 - (89 + 237)) > (2760 - 1902)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(16 - 8))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if ((v84.TheHunt:IsCastable() and ((not v33 and v82) or not v82) and (v71 < v99) and v53 and ((v32 and v57) or not v57)) or ((4636 - (581 + 300)) <= (2135 - (855 + 365)))) then
			if (((9372 - 5426) > (1223 + 2520)) and v20(v84.TheHunt, not v15:IsInRange(1285 - (1030 + 205)))) then
				return "the_hunt big_aoe 4";
			end
		end
		if ((v84.ElysianDecree:IsCastable() and (v71 < v99) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v96 > v59)) or ((1254 + 81) >= (3076 + 230))) then
			if (((5130 - (156 + 130)) > (5119 - 2866)) and (v58 == "player")) then
				if (((761 - 309) == (925 - 473)) and v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(3 + 5))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif ((v58 == "cursor") or ((2658 + 1899) < (2156 - (10 + 59)))) then
				if (((1096 + 2778) == (19078 - 15204)) and v20(v86.ElysianDecreeCursor, not v15:IsInRange(1193 - (671 + 492)))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if ((v84.FelDevastation:IsReady() and ((not v33 and v82) or not v82) and (v71 < v99) and v51 and ((v32 and v55) or not v55)) or ((1543 + 395) > (6150 - (369 + 846)))) then
			if (v20(v84.FelDevastation, not v15:IsInMeleeRange(3 + 5)) or ((3632 + 623) < (5368 - (1036 + 909)))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if (((1157 + 297) <= (4181 - 1690)) and v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56)) then
			if (v20(v84.SoulCarver, not v91) or ((4360 - (11 + 192)) <= (1417 + 1386))) then
				return "soul_carver big_aoe 10";
			end
		end
		if (((5028 - (135 + 40)) >= (7224 - 4242)) and v84.SpiritBomb:IsReady() and (v88 >= (3 + 1)) and v43) then
			if (((9107 - 4973) > (5031 - 1674)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(184 - (50 + 126)))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if ((v84.Fracture:IsCastable() and v37) or ((9514 - 6097) < (561 + 1973))) then
			if (v20(v84.Fracture, not v91) or ((4135 - (1233 + 180)) <= (1133 - (522 + 447)))) then
				return "fracture big_aoe 14";
			end
		end
		if ((v84.Shear:IsCastable() and v40) or ((3829 - (107 + 1314)) < (979 + 1130))) then
			if (v20(v84.Shear, not v91) or ((100 - 67) == (618 + 837))) then
				return "shear big_aoe 16";
			end
		end
		if ((v84.SoulCleave:IsReady() and (v88 < (1 - 0)) and v42) or ((1752 - 1309) >= (5925 - (716 + 1194)))) then
			if (((58 + 3324) > (18 + 148)) and v20(v84.SoulCleave, not v91)) then
				return "soul_cleave big_aoe 18";
			end
		end
		local v122 = v106();
		if (v122 or ((783 - (74 + 429)) == (5900 - 2841))) then
			return v122;
		end
	end
	local function v108()
		local v123 = 0 + 0;
		while true do
			if (((4305 - 2424) > (915 + 378)) and (v123 == (2 - 1))) then
				if (((5827 - 3470) == (2790 - (279 + 154))) and v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56)) then
					if (((901 - (454 + 324)) == (97 + 26)) and v20(v84.SoulCarver, not v15:IsInMeleeRange(25 - (12 + 5)))) then
						return "soul_carver fiery_demise 10";
					end
				end
				if ((v84.SpiritBomb:IsReady() and (v96 == (1 + 0)) and (v88 >= (12 - 7)) and v43) or ((391 + 665) >= (4485 - (277 + 816)))) then
					if (v20(v84.SpiritBomb, not v15:IsInMeleeRange(34 - 26)) or ((2264 - (1058 + 125)) < (202 + 873))) then
						return "spirit_bomb fiery_demise 12";
					end
				end
				if ((v84.SpiritBomb:IsReady() and (v96 > (976 - (815 + 160))) and (v96 <= (21 - 16)) and (v88 >= (9 - 5)) and v43) or ((251 + 798) >= (12955 - 8523))) then
					if (v20(v84.SpiritBomb, not v15:IsInMeleeRange(1906 - (41 + 1857))) or ((6661 - (1222 + 671)) <= (2186 - 1340))) then
						return "spirit_bomb fiery_demise 14";
					end
				end
				if ((v84.SpiritBomb:IsReady() and (v96 >= (7 - 1)) and (v88 >= (1185 - (229 + 953))) and v43) or ((5132 - (1111 + 663)) <= (2999 - (874 + 705)))) then
					if (v20(v84.SpiritBomb, not v15:IsInMeleeRange(2 + 6)) or ((2552 + 1187) <= (6246 - 3241))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				v123 = 1 + 1;
			end
			if ((v123 == (681 - (642 + 37))) or ((379 + 1280) >= (342 + 1792))) then
				if ((v84.TheHunt:IsCastable() and ((not v33 and v82) or not v82) and v53 and ((v32 and v57) or not v57) and (v71 < v99)) or ((8185 - 4925) < (2809 - (233 + 221)))) then
					if (v20(v84.TheHunt, not v15:IsInRange(69 - 39)) or ((589 + 80) == (5764 - (718 + 823)))) then
						return "the_hunt fiery_demise 18";
					end
				end
				if ((v84.ElysianDecree:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v99) and (v96 > v59)) or ((1065 + 627) < (1393 - (266 + 539)))) then
					if ((v58 == "player") or ((13581 - 8784) < (4876 - (636 + 589)))) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(18 - 10)) or ((8615 - 4438) > (3844 + 1006))) then
							return "elysian_decree fiery_demise 20 (Player)";
						end
					elseif ((v58 == "cursor") or ((146 + 254) > (2126 - (657 + 358)))) then
						if (((8078 - 5027) > (2289 - 1284)) and v20(v86.ElysianDecreeCursor, not v15:IsInRange(1217 - (1151 + 36)))) then
							return "elysian_decree fiery_demise 20 (Cursor)";
						end
					end
				end
				if (((3567 + 126) <= (1153 + 3229)) and v84.SoulCleave:IsReady() and (v14:FuryDeficit() <= (89 - 59)) and not v97 and v42) then
					if (v20(v84.SoulCleave, not v91) or ((5114 - (1552 + 280)) > (4934 - (64 + 770)))) then
						return "soul_cleave fiery_demise 22";
					end
				end
				break;
			end
			if (((0 + 0) == v123) or ((8126 - 4546) < (505 + 2339))) then
				if (((1332 - (157 + 1086)) < (8987 - 4497)) and v84.ImmolationAura:IsCastable() and v38) then
					if (v20(v84.ImmolationAura, not v15:IsInMeleeRange(35 - 27)) or ((7643 - 2660) < (2467 - 659))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if (((4648 - (599 + 220)) > (7505 - 3736)) and v84.SigilOfFlame:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and (v92 or not v84.ConcentratedSigils:IsAvailable()) and v15:DebuffRefreshable(v84.SigilOfFlameDebuff)) then
					if (((3416 - (1813 + 118)) <= (2123 + 781)) and (v84.ConcentratedSigils:IsAvailable() or (v79 == "player"))) then
						if (((5486 - (841 + 376)) == (5981 - 1712)) and v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(2 + 6))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif (((1056 - 669) <= (3641 - (464 + 395))) and (v79 == "cursor")) then
						if (v20(v86.SigilOfFlameCursor, not v15:IsInRange(76 - 46)) or ((912 + 987) <= (1754 - (467 + 370)))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				if ((v84.Felblade:IsCastable() and v36 and (v84.FelDevastation:CooldownRemains() <= (v84.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (103 - 53))) or ((3166 + 1146) <= (3002 - 2126))) then
					if (((349 + 1883) <= (6039 - 3443)) and v20(v84.Felblade, not v91)) then
						return "felblade fiery_demise 6";
					end
				end
				if (((2615 - (150 + 370)) < (4968 - (74 + 1208))) and v84.FelDevastation:IsReady() and ((not v33 and v82) or not v82) and v51 and ((v32 and v55) or not v55) and (v71 < v99)) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(19 - 11)) or ((7564 - 5969) >= (3184 + 1290))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v123 = 391 - (14 + 376);
			end
		end
	end
	local function v109()
		if ((v84.FieryBrand:IsCastable() and v80 and v61 and ((v15:DebuffDown(v84.FieryBrandDebuff) and ((v84.SigilOfFlame:CooldownRemains() < (v84.SigilOfFlame:ExecuteTime() + v14:GCDRemains())) or (v84.SoulCarver:CooldownRemains() < (v84.SoulCarver:ExecuteTime() + v14:GCDRemains())) or (v84.FelDevastation:CooldownRemains() < (v84.FelDevastation:ExecuteTime() + v14:GCDRemains())))) or (v84.DownInFlames:IsAvailable() and (v84.FieryBrand:FullRechargeTime() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) or ((8011 - 3392) < (1865 + 1017))) then
			if (v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand)) or ((259 + 35) >= (4608 + 223))) then
				return "fiery_brand maintenance 2";
			end
		end
		if (((5945 - 3916) <= (2321 + 763)) and v84.SigilOfFlame:IsCastable() and not v14:IsMoving()) then
			if (v84.ConcentratedSigils:IsAvailable() or (v79 == "player") or ((2115 - (23 + 55)) == (5735 - 3315))) then
				if (((2975 + 1483) > (3506 + 398)) and v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(11 - 3))) then
					return "sigil_of_flame maintenance 4 (Player)";
				end
			elseif (((138 + 298) >= (1024 - (652 + 249))) and (v79 == "cursor")) then
				if (((1338 - 838) < (3684 - (708 + 1160))) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(81 - 51))) then
					return "sigil_of_flame maintenance 4 (Cursor)";
				end
			end
		end
		if (((6515 - 2941) == (3601 - (10 + 17))) and v84.SpiritBomb:IsReady() and (v88 >= (2 + 3)) and v43) then
			if (((1953 - (1400 + 332)) < (748 - 358)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(1916 - (242 + 1666)))) then
				return "spirit_bomb maintenance 6";
			end
		end
		if ((v84.ImmolationAura:IsCastable() and v38) or ((947 + 1266) <= (521 + 900))) then
			if (((2607 + 451) < (5800 - (850 + 90))) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(13 - 5))) then
				return "immolation_aura maintenance 8";
			end
		end
		if ((v84.BulkExtraction:IsCastable() and v34 and v14:PrevGCD(1391 - (360 + 1030), v84.SpiritBomb)) or ((1147 + 149) >= (12548 - 8102))) then
			if (v20(v84.BulkExtraction, not v91) or ((1915 - 522) > (6150 - (909 + 752)))) then
				return "bulk_extraction maintenance 10";
			end
		end
		if ((v84.Felblade:IsCastable() and v36 and (v14:FuryDeficit() >= (1263 - (109 + 1114)))) or ((8099 - 3675) < (11 + 16))) then
			if (v20(v84.Felblade, not v91) or ((2239 - (6 + 236)) > (2404 + 1411))) then
				return "felblade maintenance 12";
			end
		end
		if (((2790 + 675) > (4511 - 2598)) and v84.Fracture:IsCastable() and v37 and (v84.FelDevastation:CooldownRemains() <= (v84.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (87 - 37))) then
			if (((1866 - (1076 + 57)) < (300 + 1519)) and v20(v84.Fracture, not v91)) then
				return "fracture maintenance 14";
			end
		end
		if ((v84.Shear:IsCastable() and v40 and (v84.FelDevastation:CooldownRemains() <= (v84.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (739 - (579 + 110)))) or ((347 + 4048) == (4205 + 550))) then
			if (v20(v84.Shear, not v91) or ((2014 + 1779) < (2776 - (174 + 233)))) then
				return "shear maintenance 16";
			end
		end
		if ((v84.SpiritBomb:IsReady() and (v14:FuryDeficit() < (83 - 53)) and (((v96 >= (3 - 1)) and (v88 >= (3 + 2))) or ((v96 >= (1180 - (663 + 511))) and (v88 >= (4 + 0)))) and not v97 and v43) or ((887 + 3197) == (816 - 551))) then
			if (((2640 + 1718) == (10259 - 5901)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(19 - 11))) then
				return "spirit_bomb maintenance 18";
			end
		end
		if ((v84.SoulCleave:IsReady() and (v14:FuryDeficit() < (15 + 15)) and (v88 <= (5 - 2)) and not v97 and v42) or ((2237 + 901) < (91 + 902))) then
			if (((4052 - (478 + 244)) > (2840 - (440 + 77))) and v20(v84.SoulCleave, not v91)) then
				return "soul_cleave maintenance 20";
			end
		end
	end
	local function v110()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (7 - 5)) or ((5182 - (655 + 901)) == (740 + 3249))) then
				if ((v84.Fracture:IsCastable() and v37) or ((702 + 214) == (1804 + 867))) then
					if (((1095 - 823) == (1717 - (695 + 750))) and v20(v84.Fracture, not v91)) then
						return "fracture single_target 14";
					end
				end
				if (((14508 - 10259) <= (7467 - 2628)) and v84.Shear:IsCastable() and v40) then
					if (((11168 - 8391) < (3551 - (285 + 66))) and v20(v84.Shear, not v91)) then
						return "shear single_target 16";
					end
				end
				if (((221 - 126) < (3267 - (682 + 628))) and v84.SoulCleave:IsReady() and not v97 and v42) then
					if (((134 + 692) < (2016 - (176 + 123))) and v20(v84.SoulCleave, not v91)) then
						return "soul_cleave single_target 18";
					end
				end
				v124 = 2 + 1;
			end
			if (((1035 + 391) >= (1374 - (239 + 30))) and (v124 == (1 + 0))) then
				if (((2647 + 107) <= (5980 - 2601)) and v84.ElysianDecree:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v99) and (v96 > v59)) then
					if ((v58 == "player") or ((12251 - 8324) == (1728 - (306 + 9)))) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(27 - 19)) or ((201 + 953) <= (484 + 304))) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif ((v58 == "cursor") or ((791 + 852) > (9662 - 6283))) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(1405 - (1140 + 235))) or ((1784 + 1019) > (4172 + 377))) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				if ((v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v99)) or ((57 + 163) >= (3074 - (33 + 19)))) then
					if (((1019 + 1803) == (8458 - 5636)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(4 + 4))) then
						return "fel_devastation single_target 10";
					end
				end
				if ((v84.SoulCleave:IsReady() and v84.FocusedCleave:IsAvailable() and not v97 and v42) or ((2080 - 1019) == (1742 + 115))) then
					if (((3449 - (586 + 103)) > (125 + 1239)) and v20(v84.SoulCleave, not v91)) then
						return "soul_cleave single_target 12";
					end
				end
				v124 = 5 - 3;
			end
			if ((v124 == (1488 - (1309 + 179))) or ((8848 - 3946) <= (1565 + 2030))) then
				if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v99)) or ((10344 - 6492) == (222 + 71))) then
					if (v20(v84.TheHunt, not v15:IsInRange(63 - 33)) or ((3106 - 1547) == (5197 - (295 + 314)))) then
						return "the_hunt single_target 2";
					end
				end
				if ((v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56)) or ((11013 - 6529) == (2750 - (1300 + 662)))) then
					if (((14344 - 9776) >= (5662 - (1178 + 577))) and v20(v84.SoulCarver, not v91)) then
						return "soul_carver single_target 4";
					end
				end
				if (((648 + 598) < (10258 - 6788)) and v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v99) and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable()))) then
					if (((5473 - (851 + 554)) >= (860 + 112)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(22 - 14))) then
						return "fel_devastation single_target 6";
					end
				end
				v124 = 1 - 0;
			end
			if (((795 - (115 + 187)) < (2982 + 911)) and (v124 == (3 + 0))) then
				v29 = v106();
				if (v29 or ((5804 - 4331) >= (4493 - (160 + 1001)))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v111()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (3 + 0)) or ((8292 - 4241) <= (1515 - (237 + 121)))) then
				if (((1501 - (525 + 372)) < (5461 - 2580)) and v84.SoulCleave:IsReady() and (v88 <= (6 - 4)) and v42) then
					if (v20(v84.SoulCleave, not v91) or ((1042 - (96 + 46)) == (4154 - (643 + 134)))) then
						return "soul_cleave small_aoe 20";
					end
				end
				v29 = v106();
				if (((1610 + 2849) > (1416 - 825)) and v29) then
					return v29;
				end
				break;
			end
			if (((12615 - 9217) >= (2297 + 98)) and (v125 == (3 - 1))) then
				if ((v84.SoulCleave:IsReady() and v84.FocusedCleave:IsAvailable() and (v88 <= (3 - 1)) and v42) or ((2902 - (316 + 403)) >= (1878 + 946))) then
					if (((5322 - 3386) == (700 + 1236)) and v20(v84.SoulCleave, not v91)) then
						return "soul_cleave small_aoe 14";
					end
				end
				if ((v84.Fracture:IsCastable() and v37) or ((12168 - 7336) < (3057 + 1256))) then
					if (((1318 + 2770) > (13423 - 9549)) and v20(v84.Fracture, not v91)) then
						return "fracture small_aoe 16";
					end
				end
				if (((20688 - 16356) == (8999 - 4667)) and v84.Shear:IsCastable() and v40) then
					if (((229 + 3770) >= (5709 - 2809)) and v20(v84.Shear, not v91)) then
						return "shear small_aoe 18";
					end
				end
				v125 = 1 + 2;
			end
			if ((v125 == (2 - 1)) or ((2542 - (12 + 5)) > (15784 - 11720))) then
				if (((9325 - 4954) == (9291 - 4920)) and v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v99)) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(19 - 11)) or ((54 + 212) > (6959 - (1656 + 317)))) then
						return "fel_devastation small_aoe 8";
					end
				end
				if (((1775 + 216) >= (742 + 183)) and v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56)) then
					if (((1209 - 754) < (10103 - 8050)) and v20(v84.SoulCarver, not v91)) then
						return "soul_carver small_aoe 10";
					end
				end
				if ((v84.SpiritBomb:IsReady() and (v88 >= (359 - (5 + 349))) and v43) or ((3923 - 3097) == (6122 - (266 + 1005)))) then
					if (((121 + 62) == (624 - 441)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(9 - 1))) then
						return "spirit_bomb small_aoe 12";
					end
				end
				v125 = 1698 - (561 + 1135);
			end
			if (((1509 - 350) <= (5877 - 4089)) and (v125 == (1066 - (507 + 559)))) then
				if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v99)) or ((8799 - 5292) > (13354 - 9036))) then
					if (v20(v84.TheHunt, not v15:IsInRange(418 - (212 + 176))) or ((3980 - (250 + 655)) <= (8085 - 5120))) then
						return "the_hunt small_aoe 2";
					end
				end
				if (((2385 - 1020) <= (3146 - 1135)) and v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v99) and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable()))) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(1964 - (1869 + 87))) or ((9628 - 6852) > (5476 - (484 + 1417)))) then
						return "fel_devastation small_aoe 4";
					end
				end
				if ((v84.ElysianDecree:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v99) and (v96 > v59)) or ((5473 - 2919) == (8050 - 3246))) then
					if (((3350 - (48 + 725)) == (4209 - 1632)) and (v58 == "player")) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(21 - 13)) or ((4 + 2) >= (5047 - 3158))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif (((142 + 364) <= (552 + 1340)) and (v58 == "cursor")) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(883 - (152 + 701))) or ((3319 - (430 + 881)) > (850 + 1368))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				v125 = 896 - (557 + 338);
			end
		end
	end
	local function v112()
		local v126 = 0 + 0;
		while true do
			if (((1067 - 688) <= (14521 - 10374)) and (v126 == (4 - 2))) then
				v44 = EpicSettings.Settings['useThrowGlaive'];
				v45 = EpicSettings.Settings['useChaosNova'];
				v46 = EpicSettings.Settings['useDisrupt'];
				v47 = EpicSettings.Settings['useSigilOfSilence'];
				v48 = EpicSettings.Settings['useSigilOfChains'];
				v126 = 6 - 3;
			end
			if ((v126 == (802 - (499 + 302))) or ((5380 - (39 + 827)) <= (2784 - 1775))) then
				v39 = EpicSettings.Settings['useInfernalStrike'];
				v40 = EpicSettings.Settings['useShear'];
				v41 = EpicSettings.Settings['useSigilOfFlame'];
				v42 = EpicSettings.Settings['useSoulCleave'];
				v43 = EpicSettings.Settings['useSpiritBomb'];
				v126 = 4 - 2;
			end
			if ((v126 == (19 - 14)) or ((5366 - 1870) == (103 + 1089))) then
				v61 = EpicSettings.Settings['useFieryBrand'];
				v62 = EpicSettings.Settings['useMetamorphosis'];
				v63 = EpicSettings.Settings['demonSpikesHP'] or (0 - 0);
				v64 = EpicSettings.Settings['fieryBrandHP'] or (0 + 0);
				v65 = EpicSettings.Settings['metamorphosisHP'] or (0 - 0);
				v126 = 110 - (103 + 1);
			end
			if ((v126 == (560 - (475 + 79))) or ((449 - 241) == (9468 - 6509))) then
				v79 = EpicSettings.Settings['sigilSetting'] or "player";
				v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				v80 = EpicSettings.Settings['fieryBrandOffensively'];
				v81 = EpicSettings.Settings['metamorphosisOffensively'];
				break;
			end
			if (((3765 + 512) >= (2816 - (1395 + 108))) and (v126 == (0 - 0))) then
				v34 = EpicSettings.Settings['useBulkExtraction'];
				v35 = EpicSettings.Settings['useConsumeMagic'];
				v36 = EpicSettings.Settings['useFelblade'];
				v37 = EpicSettings.Settings['useFracture'];
				v38 = EpicSettings.Settings['useImmolationAura'];
				v126 = 1205 - (7 + 1197);
			end
			if (((1128 + 1459) < (1108 + 2066)) and (v126 == (323 - (27 + 292)))) then
				v54 = EpicSettings.Settings['elysianDecreeWithCD'];
				v55 = EpicSettings.Settings['felDevastationWithCD'];
				v56 = EpicSettings.Settings['soulCarverWithCD'];
				v57 = EpicSettings.Settings['theHuntWithCD'];
				v60 = EpicSettings.Settings['useDemonSpikes'];
				v126 = 14 - 9;
			end
			if ((v126 == (3 - 0)) or ((17278 - 13158) <= (4334 - 2136))) then
				v49 = EpicSettings.Settings['useSigilOfMisery'];
				v50 = EpicSettings.Settings['useElysianDecree'];
				v51 = EpicSettings.Settings['useFelDevastation'];
				v52 = EpicSettings.Settings['useSoulCarver'];
				v53 = EpicSettings.Settings['useTheHunt'];
				v126 = 6 - 2;
			end
		end
	end
	local function v113()
		local v127 = 139 - (43 + 96);
		while true do
			if ((v127 == (4 - 3)) or ((3608 - 2012) == (712 + 146))) then
				v70 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['useTrinkets'];
				v73 = EpicSettings.Settings['trinketsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v127 = 1 + 1;
			end
			if (((6364 - 3144) == (1235 + 1985)) and ((3 - 1) == v127)) then
				v74 = EpicSettings.Settings['useHealingPotion'];
				v77 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v76 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v127 = 1754 - (1414 + 337);
			end
			if (((1943 - (1642 + 298)) == v127) or ((3654 - 2252) > (10414 - 6794))) then
				v67 = EpicSettings.Settings['HandleIncorporeal'];
				v83 = EpicSettings.Settings['RMBAOE'];
				v82 = EpicSettings.Settings['RMBMovement'];
				break;
			end
			if (((7638 - 5064) == (848 + 1726)) and (v127 == (0 + 0))) then
				v71 = EpicSettings.Settings['fightRemainsCheck'] or (972 - (357 + 615));
				v66 = EpicSettings.Settings['dispelBuffs'];
				v68 = EpicSettings.Settings['InterruptWithStun'];
				v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v127 = 1 + 0;
			end
		end
	end
	local function v114()
		v112();
		v113();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		if (((4411 - 2613) < (2363 + 394)) and v14:IsDeadOrGhost()) then
			return v29;
		end
		if (IsMouseButtonDown("RightButton") or ((807 - 430) > (2083 + 521))) then
			v33 = true;
		else
			v33 = false;
		end
		v95 = v14:GetEnemiesInMeleeRange(1 + 7);
		if (((358 + 210) < (2212 - (384 + 917))) and v31) then
			v96 = #v95;
		else
			v96 = 698 - (128 + 569);
		end
		v101();
		v102();
		v93 = v14:ActiveMitigationNeeded();
		v94 = v14:IsTankingAoE(1551 - (1407 + 136)) or v14:IsTanking(v15);
		if (((5172 - (687 + 1200)) < (5938 - (556 + 1154))) and (v22.TargetIsValid() or v14:AffectingCombat())) then
			local v138 = 0 - 0;
			while true do
				if (((4011 - (9 + 86)) > (3749 - (275 + 146))) and ((1 + 0) == v138)) then
					if (((2564 - (29 + 35)) < (17014 - 13175)) and (v99 == (33187 - 22076))) then
						v99 = v10.FightRemains(v95, false);
					end
					break;
				end
				if (((2238 - 1731) == (331 + 176)) and (v138 == (1012 - (53 + 959)))) then
					v98 = v10.BossFightRemains(nil, true);
					v99 = v98;
					v138 = 409 - (312 + 96);
				end
			end
		end
		if (((416 - 176) <= (3450 - (147 + 138))) and v67) then
			local v139 = 899 - (813 + 86);
			while true do
				if (((754 + 80) >= (1491 - 686)) and (v139 == (492 - (18 + 474)))) then
					v29 = v22.HandleIncorporeal(v84.Imprison, v86.ImprisonMouseover, 7 + 13);
					if (v29 or ((12441 - 8629) < (3402 - (860 + 226)))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v22.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2955 - (121 + 182)) <= (189 + 1344))) then
			local v140 = 1240 - (988 + 252);
			local v141;
			local v142;
			while true do
				if ((v140 == (1 + 0)) or ((1127 + 2471) < (3430 - (49 + 1921)))) then
					if ((not v14:AffectingCombat() and v30) or ((5006 - (223 + 667)) < (1244 - (51 + 1)))) then
						local v189 = 0 - 0;
						while true do
							if (((0 - 0) == v189) or ((4502 - (146 + 979)) <= (255 + 648))) then
								v142 = v104();
								if (((4581 - (311 + 294)) >= (1224 - 785)) and v142) then
									return v142;
								end
								break;
							end
						end
					end
					if (((1590 + 2162) == (5195 - (496 + 947))) and v84.ConsumeMagic:IsAvailable() and v35 and v84.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v22.UnitHasMagicBuff(v15)) then
						if (((5404 - (1233 + 125)) > (1094 + 1601)) and v20(v84.ConsumeMagic, not v15:IsSpellInRange(v84.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (v94 or ((3181 + 364) == (608 + 2589))) then
						local v190 = 1645 - (963 + 682);
						while true do
							if (((1998 + 396) > (1877 - (504 + 1000))) and (v190 == (0 + 0))) then
								v142 = v105();
								if (((3784 + 371) <= (400 + 3832)) and v142) then
									return v142;
								end
								break;
							end
						end
					end
					v140 = 2 - 0;
				end
				if ((v140 == (3 + 0)) or ((2083 + 1498) == (3655 - (156 + 26)))) then
					if (((2878 + 2117) > (5237 - 1889)) and v141) then
						return v141;
					end
					if ((v71 < v99) or ((918 - (149 + 15)) > (4684 - (890 + 70)))) then
						if (((334 - (39 + 78)) >= (539 - (14 + 468))) and v72 and ((v32 and v73) or not v73)) then
							local v198 = 0 - 0;
							while true do
								if ((v198 == (0 - 0)) or ((1069 + 1001) >= (2425 + 1612))) then
									v142 = v103();
									if (((575 + 2130) == (1222 + 1483)) and v142) then
										return v142;
									end
									break;
								end
							end
						end
					end
					if (((16 + 45) == (116 - 55)) and v84.FieryDemise:IsAvailable() and (v84.FieryBrandDebuff:AuraActiveCount() > (1 + 0))) then
						local v191 = v108();
						if (v191 or ((2455 - 1756) >= (33 + 1263))) then
							return v191;
						end
					end
					v140 = 55 - (12 + 39);
				end
				if ((v140 == (0 + 0)) or ((5518 - 3735) >= (12878 - 9262))) then
					v97 = (v84.FelDevastation:CooldownRemains() < (v84.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (15 + 35));
					if ((v84.ThrowGlaive:IsCastable() and v44 and v12.ValueIsInArray(v100, v15:NPCID())) or ((2060 + 1853) > (11479 - 6952))) then
						if (((2915 + 1461) > (3948 - 3131)) and v20(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if (((6571 - (1596 + 114)) > (2151 - 1327)) and v84.ThrowGlaive:IsReady() and v44 and v12.ValueIsInArray(v100, v16:NPCID())) then
						if (v20(v86.ThrowGlaiveMouseover, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((2096 - (164 + 549)) >= (3569 - (1059 + 379)))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v140 = 1 - 0;
				end
				if ((v140 == (2 + 0)) or ((317 + 1559) >= (2933 - (145 + 247)))) then
					if (((1463 + 319) <= (1743 + 2029)) and v84.InfernalStrike:IsCastable() and v39 and (v84.InfernalStrike:ChargesFractional() > (2.7 - 1)) and (v84.InfernalStrike:TimeSinceLastCast() > (1 + 1))) then
						if (v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(7 + 1)) or ((7631 - 2931) < (1533 - (254 + 466)))) then
							return "infernal_strike main 2";
						end
					end
					if (((3759 - (544 + 16)) < (12871 - 8821)) and (v71 < v99) and v84.Metamorphosis:IsCastable() and v62 and v81 and v14:BuffDown(v84.MetamorphosisBuff) and v15:DebuffDown(v84.FieryBrandDebuff)) then
						if (v20(v86.MetamorphosisPlayer, not v91) or ((5579 - (294 + 334)) < (4683 - (236 + 17)))) then
							return "metamorphosis main 4";
						end
					end
					v141 = v22.HandleDPSPotion();
					v140 = 2 + 1;
				end
				if (((75 + 21) == (361 - 265)) and (v140 == (23 - 18))) then
					if (((v96 > (1 + 0)) and (v96 <= (5 + 0))) or ((3533 - (413 + 381)) > (169 + 3839))) then
						local v192 = 0 - 0;
						local v193;
						while true do
							if ((v192 == (0 - 0)) or ((1993 - (582 + 1388)) == (1931 - 797))) then
								v193 = v111();
								if (v193 or ((1928 + 765) >= (4475 - (326 + 38)))) then
									return v193;
								end
								break;
							end
						end
					end
					if ((v96 >= (17 - 11)) or ((6161 - 1845) <= (2766 - (47 + 573)))) then
						local v194 = 0 + 0;
						local v195;
						while true do
							if ((v194 == (0 - 0)) or ((5755 - 2209) <= (4473 - (1269 + 395)))) then
								v195 = v107();
								if (((5396 - (76 + 416)) > (2609 - (319 + 124))) and v195) then
									return v195;
								end
								break;
							end
						end
					end
					break;
				end
				if (((248 - 139) >= (1097 - (564 + 443))) and ((10 - 6) == v140)) then
					v142 = v109();
					if (((5436 - (337 + 121)) > (8511 - 5606)) and v142) then
						return v142;
					end
					if ((v96 <= (3 - 2)) or ((4937 - (1261 + 650)) <= (965 + 1315))) then
						local v196 = v110();
						if (v196 or ((2633 - 980) <= (2925 - (772 + 1045)))) then
							return v196;
						end
					end
					v140 = 1 + 4;
				end
			end
		end
	end
	local function v115()
		local v131 = 144 - (102 + 42);
		while true do
			if (((4753 - (1524 + 320)) > (3879 - (1049 + 221))) and (v131 == (156 - (18 + 138)))) then
				v19.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
				v84.FieryBrandDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v19.SetAPL(1422 - 841, v114, v115);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

