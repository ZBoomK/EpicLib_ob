local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((869 + 1386) < (863 - (232 + 609)))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2519 - (797 + 636)) >= (6821 - 5416))) then
			v6 = v0[v4];
			if (not v6 or ((3988 - (1427 + 192)) == (148 + 278))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v17 = v13.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.CastSuggested;
	local v24 = v20.CastAnnotated;
	local v25 = v20.Press;
	local v26 = v20.Macro;
	local v27 = v20.Commons.Everyone;
	local v28 = v10.Utils.MergeTableByKey;
	local v29 = v27.num;
	local v30 = v27.bool;
	local v31 = GetTime;
	local v32 = math.max;
	local v33 = math.ceil;
	local v34 = math.min;
	local v35;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v89 = v18.DemonHunter.Vengeance;
	local v90 = v19.DemonHunter.Vengeance;
	local v91 = v26.DemonHunter.Vengeance;
	local v92 = {};
	local v93, v94;
	local v95 = 0 + 0;
	local v96, v97;
	local v98;
	local v99;
	local v100;
	local v101;
	local v102 = true;
	local v103 = 5036 + 6075;
	local v104 = 11437 - (192 + 134);
	local v105 = {(94283 + 75138),(156602 + 12823),(169483 - (83 + 468)),(790913 - 621487),(469104 - 299675),(163531 + 5897),(61866 + 107564)};
	v10:RegisterForEvent(function()
		local v123 = 0 + 0;
		while true do
			if ((v123 == (0 + 0)) or ((5695 - 2619) > (5094 - (340 + 1571)))) then
				v103 = 4383 + 6728;
				v104 = 12883 - (1733 + 39);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v106()
		local v124 = 0 - 0;
		while true do
			if (((2236 - (125 + 909)) > (3006 - (1096 + 852))) and (v124 == (1 + 0))) then
				if (((5299 - 1588) > (3255 + 100)) and (v95 == (512 - (409 + 103)))) then
					local v181 = ((v14:BuffUp(v89.MetamorphosisBuff)) and (237 - (46 + 190))) or (95 - (51 + 44));
					if ((v89.SoulCarver:IsAvailable() and (v89.SoulCarver:TimeSinceLastCast() < v14:GCD()) and (v89.SoulCarver.LastCastTime ~= v94)) or ((256 + 650) >= (3546 - (1114 + 203)))) then
						v95 = v34(v93 + (728 - (228 + 498)), 2 + 3);
						v94 = v89.SoulCarver.LastCastTime;
					elseif (((712 + 576) > (1914 - (174 + 489))) and v89.Fracture:IsAvailable() and (v89.Fracture:TimeSinceLastCast() < v14:GCD()) and (v89.Fracture.LastCastTime ~= v94)) then
						v95 = v34(v93 + (5 - 3) + v181, 1910 - (830 + 1075));
						v94 = v89.Fracture.LastCastTime;
					elseif (((v89.Shear:TimeSinceLastCast() < v14:GCD()) and (v89.Fracture.Shear ~= v94)) or ((5037 - (303 + 221)) < (4621 - (231 + 1038)))) then
						local v198 = 0 + 0;
						while true do
							if ((v198 == (1162 - (171 + 991))) or ((8510 - 6445) >= (8581 - 5385))) then
								v95 = v34(v93 + (2 - 1) + v181, 5 + 0);
								v94 = v89.Shear.LastCastTime;
								break;
							end
						end
					elseif (v89.SoulSigils:IsAvailable() or ((15339 - 10963) <= (4272 - 2791))) then
						local v199 = 0 - 0;
						local v200;
						local v201;
						while true do
							if ((v199 == (3 - 2)) or ((4640 - (111 + 1137)) >= (4899 - (91 + 67)))) then
								if (((9896 - 6571) >= (538 + 1616)) and v89.ElysianDecree:IsAvailable() and (v200 == v89.ElysianDecree.LastCastTime) and (v201 < v14:GCD()) and (v200 ~= v94)) then
									local v207 = 523 - (423 + 100);
									local v208;
									while true do
										if ((v207 == (1 + 0)) or ((3585 - 2290) >= (1686 + 1547))) then
											v94 = v200;
											break;
										end
										if (((5148 - (326 + 445)) > (7165 - 5523)) and ((0 - 0) == v207)) then
											v208 = v34(v101, 6 - 3);
											v95 = v34(v93 + v208, 716 - (530 + 181));
											v207 = 882 - (614 + 267);
										end
									end
								elseif (((4755 - (19 + 13)) > (2206 - 850)) and (v201 < v14:GCD()) and (v200 ~= v94)) then
									v95 = v34(v93 + (2 - 1), 14 - 9);
									v94 = v200;
								end
								break;
							end
							if ((v199 == (0 + 0)) or ((7273 - 3137) <= (7119 - 3686))) then
								v200 = v32(v89.SigilOfFlame.LastCastTime, v89.SigilOfSilence.LastCastTime, v89.SigilOfChains.LastCastTime, v89.ElysianDecree.LastCastTime);
								v201 = v34(v89.SigilOfFlame:TimeSinceLastCast(), v89.SigilOfSilence:TimeSinceLastCast(), v89.SigilOfChains:TimeSinceLastCast(), v89.ElysianDecree:TimeSinceLastCast());
								v199 = 1813 - (1293 + 519);
							end
						end
					elseif (((8661 - 4416) <= (12091 - 7460)) and v89.Fallout:IsAvailable() and (v89.ImmolationAura:TimeSinceLastCast() < v14:GCD()) and (v89.ImmolationAura.LastCastTime ~= v94)) then
						local v203 = (0.6 - 0) * v34(v101, 21 - 16);
						v95 = v34(v93 + v203, 11 - 6);
						v94 = v89.ImmolationAura.LastCastTime;
					elseif (((2265 + 2011) >= (799 + 3115)) and v89.BulkExtraction:IsAvailable() and (v89.BulkExtraction:TimeSinceLastCast() < v14:GCD()) and (v89.BulkExtraction.LastCastTime ~= v94)) then
						local v205 = v34(v101, 11 - 6);
						v95 = v34(v93 + v205, 2 + 3);
						v94 = v89.BulkExtraction.LastCastTime;
					end
				else
					local v182 = v14:PrevGCD(1 + 0);
					local v183 = {v89.SoulCarver,v89.Fracture,v89.Shear,v89.BulkExtraction};
					if (((635 - 437) <= (7181 - 2816)) and v89.SoulSigils:IsAvailable()) then
						local v188 = 0 + 0;
						while true do
							if (((3574 + 1208) > (6312 - 1636)) and (v188 == (1 + 0))) then
								v28(v183, v89.SigilOfChains);
								v28(v183, v89.ElysianDecree);
								break;
							end
							if (((9698 - 4834) > (4312 - 2115)) and (v188 == (1880 - (446 + 1434)))) then
								v28(v183, v89.SigilOfFlame);
								v28(v183, v89.SigilOfSilence);
								v188 = 1284 - (1040 + 243);
							end
						end
					end
					if (v89.Fallout:IsAvailable() or ((11043 - 7343) == (4354 - (559 + 1288)))) then
						v28(v183, v89.ImmolationAura);
					end
					for v185, v186 in pairs(v183) do
						if (((6405 - (609 + 1322)) >= (728 - (13 + 441))) and (v182 == v186:ID()) and (v186:TimeSinceLastCast() >= v14:GCD())) then
							v95 = 0 - 0;
							break;
						end
					end
				end
				if ((v95 > v93) or ((4960 - 3066) <= (7002 - 5596))) then
					v93 = v95;
				elseif (((59 + 1513) >= (5560 - 4029)) and (v95 > (0 + 0))) then
					v95 = 0 + 0;
				end
				break;
			end
			if ((v124 == (0 - 0)) or ((2565 + 2122) < (8353 - 3811))) then
				v93 = v14:BuffStack(v89.SoulFragments);
				if (((2176 + 1115) > (928 + 739)) and (v89.SpiritBomb:TimeSinceLastCast() < v14:GCD())) then
					v95 = 0 + 0;
				end
				v124 = 1 + 0;
			end
		end
	end
	local function v107()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (434 - (153 + 280))) or ((2520 - 1647) == (1827 + 207))) then
				v97 = v96 or (v101 > (0 + 0));
				break;
			end
			if (((0 + 0) == v125) or ((2556 + 260) < (8 + 3))) then
				if (((5631 - 1932) < (2909 + 1797)) and ((v89.Felblade:TimeSinceLastCast() < v14:GCD()) or (v89.InfernalStrike:TimeSinceLastCast() < v14:GCD()))) then
					v96 = true;
					v97 = true;
					return;
				end
				v96 = v15:IsInMeleeRange(672 - (89 + 578));
				v125 = 1 + 0;
			end
		end
	end
	local function v108(v126)
		return (v126:DebuffRemains(v89.FieryBrandDebuff));
	end
	local function v109(v127)
		return (v127:DebuffUp(v89.FieryBrandDebuff));
	end
	local function v110()
		local v128 = 0 - 0;
		while true do
			if (((3695 - (572 + 477)) >= (119 + 757)) and ((1 + 0) == v128)) then
				v35 = v27.HandleBottomTrinket(v92, v38, 5 + 35, nil);
				if (((700 - (84 + 2)) <= (5246 - 2062)) and v35) then
					return v35;
				end
				break;
			end
			if (((2253 + 873) == (3968 - (497 + 345))) and (v128 == (0 + 0))) then
				v35 = v27.HandleTopTrinket(v92, v38, 7 + 33, nil);
				if (v35 or ((3520 - (605 + 728)) >= (3535 + 1419))) then
					return v35;
				end
				v128 = 1 - 0;
			end
		end
	end
	local function v111()
		if ((v46 and not v14:IsMoving() and v89.SigilOfFlame:IsCastable()) or ((178 + 3699) == (13217 - 9642))) then
			if (((638 + 69) > (1750 - 1118)) and ((v86 == "player") or v89.ConcentratedSigils:IsAvailable())) then
				if (v25(v91.SigilOfFlamePlayer, not v15:IsInMeleeRange(7 + 1)) or ((1035 - (457 + 32)) >= (1139 + 1545))) then
					return "sigil_of_flame precombat 2";
				end
			elseif (((2867 - (832 + 570)) <= (4052 + 249)) and (v86 == "cursor")) then
				if (((445 + 1259) > (5042 - 3617)) and v25(v91.SigilOfFlameCursor, not v15:IsInRange(15 + 15))) then
					return "sigil_of_flame precombat 2";
				end
			end
		end
		if ((v89.ImmolationAura:IsCastable() and v43) or ((1483 - (588 + 208)) == (11411 - 7177))) then
			if (v25(v89.ImmolationAura, not v15:IsInMeleeRange(1808 - (884 + 916))) or ((6971 - 3641) < (829 + 600))) then
				return "immolation_aura precombat 4";
			end
		end
		if (((1800 - (232 + 421)) >= (2224 - (1569 + 320))) and v89.InfernalStrike:IsCastable() and v44) then
			if (((843 + 2592) > (399 + 1698)) and v25(v91.InfernalStrikePlayer, not v15:IsInMeleeRange(26 - 18))) then
				return "infernal_strike precombat 6";
			end
		end
		if ((v89.Fracture:IsCastable() and v42 and v96) or ((4375 - (316 + 289)) >= (10578 - 6537))) then
			if (v25(v89.Fracture) or ((176 + 3615) <= (3064 - (666 + 787)))) then
				return "fracture precombat 8";
			end
		end
		if ((v89.Shear:IsCastable() and v45 and v96) or ((5003 - (360 + 65)) <= (1877 + 131))) then
			if (((1379 - (79 + 175)) <= (3273 - 1197)) and v25(v89.Shear)) then
				return "shear precombat 10";
			end
		end
	end
	local function v112()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (0 - 0)) or ((1430 - 687) >= (5298 - (503 + 396)))) then
				if (((1336 - (92 + 89)) < (3244 - 1571)) and v89.DemonSpikes:IsCastable() and v65 and v14:BuffDown(v89.DemonSpikesBuff) and v14:BuffDown(v89.MetamorphosisBuff) and (((v101 == (1 + 0)) and v14:BuffDown(v89.FieryBrandDebuff)) or (v101 > (1 + 0)))) then
					if ((v89.DemonSpikes:ChargesFractional() > (3.9 - 2)) or ((318 + 2006) <= (1317 - 739))) then
						if (((3287 + 480) == (1800 + 1967)) and v25(v89.DemonSpikes)) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (((12453 - 8364) == (511 + 3578)) and (v98 or (v14:HealthPercentage() <= v68))) then
						if (((6798 - 2340) >= (2918 - (485 + 759))) and v25(v89.DemonSpikes)) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if (((2248 - 1276) <= (2607 - (442 + 747))) and v89.Metamorphosis:IsCastable() and v67 and (v14:HealthPercentage() <= v70) and (v14:BuffDown(v89.MetamorphosisBuff) or (v15:TimeToDie() < (1150 - (832 + 303))))) then
					if (v25(v91.MetamorphosisPlayer) or ((5884 - (88 + 858)) < (1452 + 3310))) then
						return "metamorphosis defensives";
					end
				end
				v129 = 1 + 0;
			end
			if ((v129 == (1 + 0)) or ((3293 - (766 + 23)) > (21050 - 16786))) then
				if (((2943 - 790) == (5672 - 3519)) and v89.FieryBrand:IsCastable() and v66 and (v98 or (v14:HealthPercentage() <= v69))) then
					if (v25(v89.FieryBrand, not v15:IsSpellInRange(v89.FieryBrand)) or ((1720 - 1213) >= (3664 - (1036 + 37)))) then
						return "fiery_brand defensives";
					end
				end
				if (((3177 + 1304) == (8726 - 4245)) and v90.Healthstone:IsReady() and v82 and (v14:HealthPercentage() <= v84)) then
					if (v25(v91.Healthstone) or ((1832 + 496) < (2173 - (641 + 839)))) then
						return "healthstone defensive";
					end
				end
				v129 = 915 - (910 + 3);
			end
			if (((11033 - 6705) == (6012 - (1466 + 218))) and (v129 == (1 + 1))) then
				if (((2736 - (556 + 592)) >= (474 + 858)) and v81 and (v14:HealthPercentage() <= v83)) then
					local v184 = 808 - (329 + 479);
					while true do
						if ((v184 == (854 - (174 + 680))) or ((14342 - 10168) > (8804 - 4556))) then
							if ((v85 == "Refreshing Healing Potion") or ((3275 + 1311) <= (821 - (396 + 343)))) then
								if (((342 + 3521) == (5340 - (29 + 1448))) and v90.RefreshingHealingPotion:IsReady()) then
									if (v25(v91.RefreshingHealingPotion) or ((1671 - (135 + 1254)) <= (157 - 115))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((21519 - 16910) >= (511 + 255)) and (v85 == "Dreamwalker's Healing Potion")) then
								if (v90.DreamwalkersHealingPotion:IsReady() or ((2679 - (389 + 1138)) == (3062 - (102 + 472)))) then
									if (((3230 + 192) > (1858 + 1492)) and v25(v91.RefreshingHealingPotion)) then
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
	local function v113()
		local v130 = 0 + 0;
		while true do
			if (((2422 - (320 + 1225)) > (669 - 293)) and (v130 == (1 + 0))) then
				if ((v89.SigilOfSilence:IsCastable() and v52 and not v14:IsMoving() and v89.CycleofBinding:IsAvailable() and v89.SigilOfSilence:IsAvailable()) or ((4582 - (157 + 1307)) <= (3710 - (821 + 1038)))) then
					if ((v86 == "player") or v89.ConcentratedSigils:IsAvailable() or ((411 - 246) >= (382 + 3110))) then
						if (((7013 - 3064) < (1807 + 3049)) and v25(v91.SigilOfSilencePlayer, not v15:IsInMeleeRange(19 - 11))) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((v86 == "cursor") or ((5302 - (834 + 192)) < (192 + 2824))) then
						if (((1204 + 3486) > (89 + 4036)) and v25(v91.SigilOfSilenceCursor, not v15:IsInRange(46 - 16))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v89.ThrowGlaive:IsCastable() and v49) or ((354 - (300 + 4)) >= (240 + 656))) then
					if (v25(v89.ThrowGlaive, not v15:IsSpellInRange(v89.ThrowGlaive)) or ((4486 - 2772) >= (3320 - (112 + 250)))) then
						return "throw_glaive filler 8";
					end
				end
				break;
			end
			if ((v130 == (0 + 0)) or ((3735 - 2244) < (369 + 275))) then
				if (((365 + 339) < (739 + 248)) and v89.SigilOfChains:IsCastable() and v53 and not v14:IsMoving() and v89.CycleofBinding:IsAvailable() and v89.SigilOfChains:IsAvailable()) then
					if (((1844 + 1874) > (1416 + 490)) and ((v86 == "player") or v89.ConcentratedSigils:IsAvailable())) then
						if (v25(v91.SigilOfChainsPlayer, not v15:IsInMeleeRange(1422 - (1001 + 413))) or ((2136 - 1178) > (4517 - (244 + 638)))) then
							return "sigil_of_chains player filler 2";
						end
					elseif (((4194 - (627 + 66)) <= (13384 - 8892)) and (v86 == "cursor")) then
						if (v25(v91.SigilOfChainsCursor, not v15:IsInRange(632 - (512 + 90))) or ((5348 - (1665 + 241)) < (3265 - (373 + 344)))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if (((1297 + 1578) >= (388 + 1076)) and v89.SigilOfMisery:IsCastable() and v54 and not v14:IsMoving() and v89.CycleofBinding:IsAvailable() and v89.SigilOfMisery:IsAvailable()) then
					if ((v86 == "player") or v89.ConcentratedSigils:IsAvailable() or ((12653 - 7856) >= (8279 - 3386))) then
						if (v25(v91.SigilOfMiseryPlayer, not v15:IsInMeleeRange(1107 - (35 + 1064))) or ((401 + 150) > (4424 - 2356))) then
							return "sigil_of_misery player filler 4";
						end
					elseif (((9 + 2105) > (2180 - (298 + 938))) and (v86 == "cursor")) then
						if (v25(v91.SigilOfMiseryCursor, not v15:IsInRange(1289 - (233 + 1026))) or ((3928 - (636 + 1030)) >= (1583 + 1513))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v114()
		if ((v89.FelDevastation:IsReady() and (v78 < v104) and v56 and ((v38 and v60) or not v60) and (v89.CollectiveAnguish:IsAvailable() or v89.StoketheFlames:IsAvailable())) or ((670 + 1585) >= (239 + 3298))) then
			if (v25(v89.FelDevastation, not v15:IsInMeleeRange(229 - (55 + 166))) or ((744 + 3093) < (132 + 1174))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if (((11266 - 8316) == (3247 - (36 + 261))) and v89.TheHunt:IsCastable() and (v78 < v104) and v58 and ((v38 and v62) or not v62)) then
			if (v25(v89.TheHunt, not v15:IsInRange(87 - 37)) or ((6091 - (34 + 1334)) < (1268 + 2030))) then
				return "the_hunt big_aoe 4";
			end
		end
		if (((883 + 253) >= (1437 - (1035 + 248))) and v89.ElysianDecree:IsCastable() and (v78 < v104) and v55 and not v14:IsMoving() and ((v38 and v59) or not v59) and (v101 > v64)) then
			if ((v63 == "player") or ((292 - (20 + 1)) > (2474 + 2274))) then
				if (((5059 - (134 + 185)) >= (4285 - (549 + 584))) and v25(v91.ElysianDecreePlayer, not v15:IsInMeleeRange(693 - (314 + 371)))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif ((v63 == "cursor") or ((8850 - 6272) >= (4358 - (478 + 490)))) then
				if (((22 + 19) <= (2833 - (786 + 386))) and v25(v91.ElysianDecreeCursor, not v15:IsInRange(97 - 67))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if (((1980 - (1055 + 324)) < (4900 - (1093 + 247))) and v89.FelDevastation:IsReady() and (v78 < v104) and v56 and ((v38 and v60) or not v60)) then
			if (((209 + 26) < (73 + 614)) and v25(v89.FelDevastation, not v15:IsInMeleeRange(31 - 23))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if (((15438 - 10889) > (3280 - 2127)) and v89.SoulCarver:IsCastable() and v57) then
			if (v25(v89.SoulCarver, not v96) or ((11745 - 7071) < (1662 + 3010))) then
				return "soul_carver big_aoe 10";
			end
		end
		if (((14130 - 10462) < (15720 - 11159)) and v89.SpiritBomb:IsReady() and (v93 >= (4 + 0)) and v48) then
			if (v25(v89.SpiritBomb, not v15:IsInMeleeRange(20 - 12)) or ((1143 - (364 + 324)) == (9882 - 6277))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if ((v89.Fracture:IsCastable() and v42) or ((6389 - 3726) == (1098 + 2214))) then
			if (((17896 - 13619) <= (7166 - 2691)) and v25(v89.Fracture, not v96)) then
				return "fracture big_aoe 14";
			end
		end
		if ((v89.Shear:IsCastable() and v45) or ((2642 - 1772) == (2457 - (1249 + 19)))) then
			if (((1402 + 151) <= (12195 - 9062)) and v25(v89.Shear, not v96)) then
				return "shear big_aoe 16";
			end
		end
		if ((v89.SoulCleave:IsReady() and (v93 < (1087 - (686 + 400))) and v47) or ((1756 + 481) >= (3740 - (73 + 156)))) then
			if (v25(v89.SoulCleave, not v96) or ((7 + 1317) > (3831 - (721 + 90)))) then
				return "soul_cleave big_aoe 18";
			end
		end
		local v131 = v113();
		if (v131 or ((34 + 2958) == (6107 - 4226))) then
			return v131;
		end
	end
	local function v115()
		if (((3576 - (224 + 246)) > (2471 - 945)) and v89.ImmolationAura:IsCastable() and v43) then
			if (((5565 - 2542) < (702 + 3168)) and v25(v89.ImmolationAura, not v15:IsInMeleeRange(1 + 7))) then
				return "immolation_aura fiery_demise 2";
			end
		end
		if (((106 + 37) > (146 - 72)) and v89.SigilOfFlame:IsCastable() and v46 and not v14:IsMoving() and (v97 or not v89.ConcentratedSigils:IsAvailable()) and v15:DebuffRefreshable(v89.SigilOfFlameDebuff)) then
			if (((59 - 41) < (2625 - (203 + 310))) and (v89.ConcentratedSigils:IsAvailable() or (v86 == "player"))) then
				if (((3090 - (1238 + 755)) <= (114 + 1514)) and v25(v91.SigilOfFlamePlayer, not v15:IsInMeleeRange(1542 - (709 + 825)))) then
					return "sigil_of_flame fiery_demise 4 (Player)";
				end
			elseif (((8532 - 3902) == (6744 - 2114)) and (v86 == "cursor")) then
				if (((4404 - (196 + 668)) > (10593 - 7910)) and v25(v91.SigilOfFlameCursor, not v15:IsInRange(62 - 32))) then
					return "sigil_of_flame fiery_demise 4 (Cursor)";
				end
			end
		end
		if (((5627 - (171 + 662)) >= (3368 - (4 + 89))) and v89.Felblade:IsCastable() and v41 and (v89.FelDevastation:CooldownRemains() <= (v89.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (175 - 125))) then
			if (((541 + 943) == (6518 - 5034)) and v25(v89.Felblade, not v96)) then
				return "felblade fiery_demise 6";
			end
		end
		if (((562 + 870) < (5041 - (35 + 1451))) and v89.FelDevastation:IsReady() and v56 and ((v38 and v60) or not v60) and (v78 < v104)) then
			if (v25(v89.FelDevastation, not v15:IsInMeleeRange(1461 - (28 + 1425))) or ((3058 - (941 + 1052)) > (3431 + 147))) then
				return "fel_devastation fiery_demise 8";
			end
		end
		if ((v89.SoulCarver:IsCastable() and v57) or ((6309 - (822 + 692)) < (2008 - 601))) then
			if (((873 + 980) < (5110 - (45 + 252))) and v25(v89.SoulCarver, not v15:IsInMeleeRange(8 + 0))) then
				return "soul_carver fiery_demise 10";
			end
		end
		if ((v89.SpiritBomb:IsReady() and (v101 == (1 + 0)) and (v93 >= (12 - 7)) and v48) or ((3254 - (114 + 319)) < (3490 - 1059))) then
			if (v25(v89.SpiritBomb, not v15:IsInMeleeRange(9 - 1)) or ((1833 + 1041) < (3249 - 1068))) then
				return "spirit_bomb fiery_demise 12";
			end
		end
		if ((v89.SpiritBomb:IsReady() and (v101 > (1 - 0)) and (v101 <= (1968 - (556 + 1407))) and (v93 >= (1210 - (741 + 465))) and v48) or ((3154 - (170 + 295)) <= (181 + 162))) then
			if (v25(v89.SpiritBomb, not v15:IsInMeleeRange(8 + 0)) or ((4601 - 2732) == (1666 + 343))) then
				return "spirit_bomb fiery_demise 14";
			end
		end
		if ((v89.SpiritBomb:IsReady() and (v101 >= (4 + 2)) and (v93 >= (2 + 1)) and v48) or ((4776 - (957 + 273)) < (622 + 1700))) then
			if (v25(v89.SpiritBomb, not v15:IsInMeleeRange(4 + 4)) or ((7933 - 5851) == (12577 - 7804))) then
				return "spirit_bomb fiery_demise 16";
			end
		end
		if (((9908 - 6664) > (5224 - 4169)) and v89.TheHunt:IsCastable() and v58 and ((v38 and v62) or not v62) and (v78 < v104)) then
			if (v25(v89.TheHunt, not v15:IsInRange(1810 - (389 + 1391))) or ((2079 + 1234) <= (186 + 1592))) then
				return "the_hunt fiery_demise 18";
			end
		end
		if ((v89.ElysianDecree:IsCastable() and v55 and not v14:IsMoving() and ((v38 and v59) or not v59) and (v78 < v104) and (v101 > v64)) or ((3234 - 1813) >= (3055 - (783 + 168)))) then
			if (((6081 - 4269) <= (3196 + 53)) and (v63 == "player")) then
				if (((1934 - (309 + 2)) <= (6009 - 4052)) and v25(v91.ElysianDecreePlayer, not v15:IsInMeleeRange(1220 - (1090 + 122)))) then
					return "elysian_decree fiery_demise 20 (Player)";
				end
			elseif (((1431 + 2981) == (14817 - 10405)) and (v63 == "cursor")) then
				if (((1198 + 552) >= (1960 - (628 + 490))) and v25(v91.ElysianDecreeCursor, not v15:IsInRange(6 + 24))) then
					return "elysian_decree fiery_demise 20 (Cursor)";
				end
			end
		end
		if (((10824 - 6452) > (8454 - 6604)) and v89.SoulCleave:IsReady() and (v14:FuryDeficit() <= (804 - (431 + 343))) and not v102 and v47) then
			if (((468 - 236) < (2374 - 1553)) and v25(v89.SoulCleave, not v96)) then
				return "soul_cleave fiery_demise 22";
			end
		end
	end
	local function v116()
		if (((410 + 108) < (116 + 786)) and v89.FieryBrand:IsCastable() and v66 and ((v15:DebuffDown(v89.FieryBrandDebuff) and ((v89.SigilOfFlame:CooldownRemains() < (v89.SigilOfFlame:ExecuteTime() + v14:GCDRemains())) or (v89.SoulCarver:CooldownRemains() < (v89.SoulCarver:ExecuteTime() + v14:GCDRemains())) or (v89.FelDevastation:CooldownRemains() < (v89.FelDevastation:ExecuteTime() + v14:GCDRemains())))) or (v89.DownInFlames:IsAvailable() and (v89.FieryBrand:FullRechargeTime() < (v89.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) then
			if (((4689 - (556 + 1139)) > (873 - (6 + 9))) and v25(v89.FieryBrand, not v15:IsSpellInRange(v89.FieryBrand))) then
				return "fiery_brand maintenance 2";
			end
		end
		if ((v89.SigilOfFlame:IsCastable() and not v14:IsMoving()) or ((688 + 3067) <= (469 + 446))) then
			if (((4115 - (28 + 141)) > (1450 + 2293)) and (v89.ConcentratedSigils:IsAvailable() or (v86 == "player"))) then
				if (v25(v91.SigilOfFlamePlayer, not v15:IsInMeleeRange(9 - 1)) or ((946 + 389) >= (4623 - (486 + 831)))) then
					return "sigil_of_flame maintenance 4 (Player)";
				end
			elseif (((12605 - 7761) > (7931 - 5678)) and (v86 == "cursor")) then
				if (((86 + 366) == (1429 - 977)) and v25(v91.SigilOfFlameCursor, not v15:IsInRange(1293 - (668 + 595)))) then
					return "sigil_of_flame maintenance 4 (Cursor)";
				end
			end
		end
		if ((v89.SpiritBomb:IsReady() and (v93 >= (5 + 0)) and v48) or ((919 + 3638) < (5691 - 3604))) then
			if (((4164 - (23 + 267)) == (5818 - (1129 + 815))) and v25(v89.SpiritBomb, not v15:IsInMeleeRange(395 - (371 + 16)))) then
				return "spirit_bomb maintenance 6";
			end
		end
		if ((v89.ImmolationAura:IsCastable() and v43) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
			if (v25(v89.ImmolationAura, not v15:IsInMeleeRange(29 - 21)) or ((4373 - (88 + 30)) < (4194 - (720 + 51)))) then
				return "immolation_aura maintenance 8";
			end
		end
		if (((3234 - 1780) <= (4267 - (421 + 1355))) and v89.BulkExtraction:IsCastable() and v39 and v14:PrevGCD(1 - 0, v89.SpiritBomb)) then
			if (v25(v89.BulkExtraction, not v96) or ((2042 + 2115) <= (3886 - (286 + 797)))) then
				return "bulk_extraction maintenance 10";
			end
		end
		if (((17740 - 12887) >= (4938 - 1956)) and v89.Felblade:IsCastable() and v41 and (v14:FuryDeficit() >= (479 - (397 + 42)))) then
			if (((1292 + 2842) > (4157 - (24 + 776))) and v25(v89.Felblade, not v96)) then
				return "felblade maintenance 12";
			end
		end
		if ((v89.Fracture:IsCastable() and v42 and (v89.FelDevastation:CooldownRemains() <= (v89.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (77 - 27))) or ((4202 - (222 + 563)) < (5582 - 3048))) then
			if (v25(v89.Fracture, not v96) or ((1960 + 762) <= (354 - (23 + 167)))) then
				return "fracture maintenance 14";
			end
		end
		if ((v89.Shear:IsCastable() and v45 and (v89.FelDevastation:CooldownRemains() <= (v89.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1848 - (690 + 1108)))) or ((869 + 1539) < (1740 + 369))) then
			if (v25(v89.Shear, not v96) or ((881 - (40 + 808)) == (240 + 1215))) then
				return "shear maintenance 16";
			end
		end
		if ((v89.SpiritBomb:IsReady() and (v14:FuryDeficit() < (114 - 84)) and (((v101 >= (2 + 0)) and (v93 >= (3 + 2))) or ((v101 >= (4 + 2)) and (v93 >= (575 - (47 + 524))))) and not v102 and v48) or ((288 + 155) >= (10975 - 6960))) then
			if (((5056 - 1674) > (378 - 212)) and v25(v89.SpiritBomb, not v15:IsInMeleeRange(1734 - (1165 + 561)))) then
				return "spirit_bomb maintenance 18";
			end
		end
		if ((v89.SoulCleave:IsReady() and (v14:FuryDeficit() < (1 + 29)) and (v93 <= (9 - 6)) and not v102 and v47) or ((107 + 173) == (3538 - (341 + 138)))) then
			if (((508 + 1373) > (2668 - 1375)) and v25(v89.SoulCleave, not v96)) then
				return "soul_cleave maintenance 20";
			end
		end
	end
	local function v117()
		if (((2683 - (89 + 237)) == (7582 - 5225)) and v89.TheHunt:IsCastable() and v58 and ((v38 and v62) or not v62) and (v78 < v104)) then
			if (((258 - 135) == (1004 - (581 + 300))) and v25(v89.TheHunt, not v15:IsInRange(1250 - (855 + 365)))) then
				return "the_hunt single_target 2";
			end
		end
		if ((v89.SoulCarver:IsCastable() and v57) or ((2507 - 1451) >= (1108 + 2284))) then
			if (v25(v89.SoulCarver, not v96) or ((2316 - (1030 + 205)) < (1010 + 65))) then
				return "soul_carver single_target 4";
			end
		end
		if ((v89.FelDevastation:IsReady() and v56 and ((v38 and v60) or not v60) and (v78 < v104) and (v89.CollectiveAnguish:IsAvailable() or (v89.StoketheFlames:IsAvailable() and v89.BurningBlood:IsAvailable()))) or ((976 + 73) >= (4718 - (156 + 130)))) then
			if (v25(v89.FelDevastation, not v15:IsInMeleeRange(17 - 9)) or ((8035 - 3267) <= (1732 - 886))) then
				return "fel_devastation single_target 6";
			end
		end
		if ((v89.ElysianDecree:IsCastable() and v55 and not v14:IsMoving() and ((v38 and v59) or not v59) and (v78 < v104) and (v101 > v64)) or ((885 + 2473) <= (829 + 591))) then
			if ((v63 == "player") or ((3808 - (10 + 59)) <= (850 + 2155))) then
				if (v25(v91.ElysianDecreePlayer, not v15:IsInMeleeRange(39 - 31)) or ((2822 - (671 + 492)) >= (1699 + 435))) then
					return "elysian_decree single_target 8 (Player)";
				end
			elseif ((v63 == "cursor") or ((4475 - (369 + 846)) < (624 + 1731))) then
				if (v25(v91.ElysianDecreeCursor, not v15:IsInRange(26 + 4)) or ((2614 - (1036 + 909)) == (3358 + 865))) then
					return "elysian_decree single_target 8 (Cursor)";
				end
			end
		end
		if ((v89.FelDevastation:IsReady() and v56 and ((v38 and v60) or not v60) and (v78 < v104)) or ((2840 - 1148) < (791 - (11 + 192)))) then
			if (v25(v89.FelDevastation, not v15:IsInMeleeRange(5 + 3)) or ((4972 - (135 + 40)) < (8845 - 5194))) then
				return "fel_devastation single_target 10";
			end
		end
		if ((v89.SoulCleave:IsReady() and v89.FocusedCleave:IsAvailable() and not v102 and v47) or ((2518 + 1659) > (10684 - 5834))) then
			if (v25(v89.SoulCleave, not v96) or ((599 - 199) > (1287 - (50 + 126)))) then
				return "soul_cleave single_target 12";
			end
		end
		if (((8495 - 5444) > (223 + 782)) and v89.Fracture:IsCastable() and v42) then
			if (((5106 - (1233 + 180)) <= (5351 - (522 + 447))) and v25(v89.Fracture, not v96)) then
				return "fracture single_target 14";
			end
		end
		if ((v89.Shear:IsCastable() and v45) or ((4703 - (107 + 1314)) > (1903 + 2197))) then
			if (v25(v89.Shear, not v96) or ((10908 - 7328) < (1208 + 1636))) then
				return "shear single_target 16";
			end
		end
		if (((176 - 87) < (17765 - 13275)) and v89.SoulCleave:IsReady() and not v102 and v47) then
			if (v25(v89.SoulCleave, not v96) or ((6893 - (716 + 1194)) < (31 + 1777))) then
				return "soul_cleave single_target 18";
			end
		end
		local v132 = v113();
		if (((411 + 3418) > (4272 - (74 + 429))) and v132) then
			return v132;
		end
	end
	local function v118()
		if (((2864 - 1379) <= (1440 + 1464)) and v89.TheHunt:IsCastable() and v58 and ((v38 and v62) or not v62) and (v78 < v104)) then
			if (((9771 - 5502) == (3021 + 1248)) and v25(v89.TheHunt, not v15:IsInRange(92 - 62))) then
				return "the_hunt small_aoe 2";
			end
		end
		if (((956 - 569) <= (3215 - (279 + 154))) and v89.FelDevastation:IsReady() and v56 and ((v38 and v60) or not v60) and (v78 < v104) and (v89.CollectiveAnguish:IsAvailable() or (v89.StoketheFlames:IsAvailable() and v89.BurningBlood:IsAvailable()))) then
			if (v25(v89.FelDevastation, not v15:IsInMeleeRange(786 - (454 + 324))) or ((1495 + 404) <= (934 - (12 + 5)))) then
				return "fel_devastation small_aoe 4";
			end
		end
		if ((v89.ElysianDecree:IsCastable() and v55 and not v14:IsMoving() and ((v38 and v59) or not v59) and (v78 < v104) and (v101 > v64)) or ((2325 + 1987) <= (2231 - 1355))) then
			if (((825 + 1407) <= (3689 - (277 + 816))) and (v63 == "player")) then
				if (((8952 - 6857) < (4869 - (1058 + 125))) and v25(v91.ElysianDecreePlayer, not v15:IsInMeleeRange(2 + 6))) then
					return "elysian_decree small_aoe 6 (Player)";
				end
			elseif ((v63 == "cursor") or ((2570 - (815 + 160)) >= (19196 - 14722))) then
				if (v25(v91.ElysianDecreeCursor, not v15:IsInRange(71 - 41)) or ((1102 + 3517) < (8424 - 5542))) then
					return "elysian_decree small_aoe 6 (Cursor)";
				end
			end
		end
		if ((v89.FelDevastation:IsReady() and v56 and ((v38 and v60) or not v60) and (v78 < v104)) or ((2192 - (41 + 1857)) >= (6724 - (1222 + 671)))) then
			if (((5243 - 3214) <= (4432 - 1348)) and v25(v89.FelDevastation, not v15:IsInMeleeRange(1190 - (229 + 953)))) then
				return "fel_devastation small_aoe 8";
			end
		end
		if ((v89.SoulCarver:IsCastable() and v57) or ((3811 - (1111 + 663)) == (3999 - (874 + 705)))) then
			if (((625 + 3833) > (2664 + 1240)) and v25(v89.SoulCarver, not v96)) then
				return "soul_carver small_aoe 10";
			end
		end
		if (((905 - 469) >= (4 + 119)) and v89.SpiritBomb:IsReady() and (v93 >= (684 - (642 + 37))) and v48) then
			if (((115 + 385) < (291 + 1525)) and v25(v89.SpiritBomb, not v15:IsInMeleeRange(19 - 11))) then
				return "spirit_bomb small_aoe 12";
			end
		end
		if (((4028 - (233 + 221)) == (8264 - 4690)) and v89.SoulCleave:IsReady() and v89.FocusedCleave:IsAvailable() and (v93 <= (2 + 0)) and v47) then
			if (((1762 - (718 + 823)) < (246 + 144)) and v25(v89.SoulCleave, not v96)) then
				return "soul_cleave small_aoe 14";
			end
		end
		if ((v89.Fracture:IsCastable() and v42) or ((3018 - (266 + 539)) <= (4023 - 2602))) then
			if (((4283 - (636 + 589)) < (11536 - 6676)) and v25(v89.Fracture, not v96)) then
				return "fracture small_aoe 16";
			end
		end
		if ((v89.Shear:IsCastable() and v45) or ((2672 - 1376) >= (3524 + 922))) then
			if (v25(v89.Shear, not v96) or ((507 + 886) > (5504 - (657 + 358)))) then
				return "shear small_aoe 18";
			end
		end
		if ((v89.SoulCleave:IsReady() and (v93 <= (4 - 2)) and v47) or ((10078 - 5654) < (1214 - (1151 + 36)))) then
			if (v25(v89.SoulCleave, not v96) or ((1929 + 68) > (1003 + 2812))) then
				return "soul_cleave small_aoe 20";
			end
		end
		local v133 = v113();
		if (((10347 - 6882) > (3745 - (1552 + 280))) and v133) then
			return v133;
		end
	end
	local function v119()
		local v134 = 834 - (64 + 770);
		while true do
			if (((498 + 235) < (4128 - 2309)) and (v134 == (2 + 6))) then
				v64 = EpicSettings.Settings['elysianDecreeSlider'] or (1243 - (157 + 1086));
				v87 = EpicSettings.Settings['fieryBrandOffensively'];
				v88 = EpicSettings.Settings['metamorphosisOffensively'];
				break;
			end
			if ((v134 == (11 - 5)) or ((19248 - 14853) == (7293 - 2538))) then
				v65 = EpicSettings.Settings['useDemonSpikes'];
				v66 = EpicSettings.Settings['useFieryBrand'];
				v67 = EpicSettings.Settings['useMetamorphosis'];
				v68 = EpicSettings.Settings['demonSpikesHP'] or (0 - 0);
				v134 = 826 - (599 + 220);
			end
			if ((v134 == (5 - 2)) or ((5724 - (1813 + 118)) < (1732 + 637))) then
				v51 = EpicSettings.Settings['useDisrupt'];
				v52 = EpicSettings.Settings['useSigilOfSilence'];
				v53 = EpicSettings.Settings['useSigilOfChains'];
				v54 = EpicSettings.Settings['useSigilOfMisery'];
				v134 = 1221 - (841 + 376);
			end
			if ((v134 == (1 - 0)) or ((949 + 3135) == (723 - 458))) then
				v43 = EpicSettings.Settings['useImmolationAura'];
				v44 = EpicSettings.Settings['useInfernalStrike'];
				v45 = EpicSettings.Settings['useShear'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v134 = 861 - (464 + 395);
			end
			if (((11184 - 6826) == (2093 + 2265)) and ((844 - (467 + 370)) == v134)) then
				v69 = EpicSettings.Settings['fieryBrandHP'] or (0 - 0);
				v70 = EpicSettings.Settings['metamorphosisHP'] or (0 + 0);
				v86 = EpicSettings.Settings['sigilSetting'] or "player";
				v63 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v134 = 27 - 19;
			end
			if ((v134 == (0 + 0)) or ((7300 - 4162) < (1513 - (150 + 370)))) then
				v39 = EpicSettings.Settings['useBulkExtraction'];
				v40 = EpicSettings.Settings['useConsumeMagic'];
				v41 = EpicSettings.Settings['useFelblade'];
				v42 = EpicSettings.Settings['useFracture'];
				v134 = 1283 - (74 + 1208);
			end
			if (((8190 - 4860) > (11016 - 8693)) and ((4 + 1) == v134)) then
				v59 = EpicSettings.Settings['elysianDecreeWithCD'];
				v60 = EpicSettings.Settings['felDevastationWithCD'];
				v61 = EpicSettings.Settings['soulCarverWithCD'];
				v62 = EpicSettings.Settings['theHuntWithCD'];
				v134 = 396 - (14 + 376);
			end
			if ((v134 == (6 - 2)) or ((2347 + 1279) == (3505 + 484))) then
				v55 = EpicSettings.Settings['useElysianDecree'];
				v56 = EpicSettings.Settings['useFelDevastation'];
				v57 = EpicSettings.Settings['useSoulCarver'];
				v58 = EpicSettings.Settings['useTheHunt'];
				v134 = 5 + 0;
			end
			if ((v134 == (5 - 3)) or ((690 + 226) == (2749 - (23 + 55)))) then
				v47 = EpicSettings.Settings['useSoulCleave'];
				v48 = EpicSettings.Settings['useSpiritBomb'];
				v49 = EpicSettings.Settings['useThrowGlaive'];
				v50 = EpicSettings.Settings['useChaosNova'];
				v134 = 6 - 3;
			end
		end
	end
	local function v120()
		v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v71 = EpicSettings.Settings['dispelBuffs'];
		v75 = EpicSettings.Settings['InterruptWithStun'];
		v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v77 = EpicSettings.Settings['InterruptThreshold'];
		v79 = EpicSettings.Settings['useTrinkets'];
		v80 = EpicSettings.Settings['trinketsWithCD'];
		v82 = EpicSettings.Settings['useHealthstone'];
		v81 = EpicSettings.Settings['useHealingPotion'];
		v84 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v83 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v74 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v121()
		v119();
		v120();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		if (((86 + 186) == (1173 - (652 + 249))) and v14:IsDeadOrGhost()) then
			return;
		end
		v100 = v14:GetEnemiesInMeleeRange(21 - 13);
		if (((6117 - (708 + 1160)) <= (13135 - 8296)) and v37) then
			v101 = #v100;
		else
			v101 = 1 - 0;
		end
		v106();
		v107();
		v98 = v14:ActiveMitigationNeeded();
		v99 = v14:IsTankingAoE(35 - (10 + 17)) or v14:IsTanking(v15);
		if (((624 + 2153) < (4932 - (1400 + 332))) and (v27.TargetIsValid() or v14:AffectingCombat())) then
			v103 = v10.BossFightRemains(nil, true);
			v104 = v103;
			if (((182 - 87) < (3865 - (242 + 1666))) and (v104 == (4755 + 6356))) then
				v104 = v10.FightRemains(v100, false);
			end
		end
		if (((303 + 523) < (1464 + 253)) and v74) then
			local v148 = 940 - (850 + 90);
			while true do
				if (((2496 - 1070) >= (2495 - (360 + 1030))) and (v148 == (0 + 0))) then
					v35 = v27.HandleIncorporeal(v89.Imprison, v91.ImprisonMouseover, 56 - 36);
					if (((3788 - 1034) <= (5040 - (909 + 752))) and v35) then
						return v35;
					end
					break;
				end
			end
		end
		if ((v27.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((5150 - (109 + 1114)) == (2586 - 1173))) then
			local v149 = 0 + 0;
			local v150;
			local v151;
			while true do
				if ((v149 == (245 - (6 + 236))) or ((728 + 426) <= (635 + 153))) then
					v151 = v116();
					if (v151 or ((3874 - 2231) > (5901 - 2522))) then
						return v151;
					end
					if ((v101 <= (1134 - (1076 + 57))) or ((461 + 2342) > (5238 - (579 + 110)))) then
						local v189 = 0 + 0;
						local v190;
						while true do
							if ((v189 == (0 + 0)) or ((117 + 103) >= (3429 - (174 + 233)))) then
								v190 = v117();
								if (((7882 - 5060) == (4952 - 2130)) and v190) then
									return v190;
								end
								break;
							end
						end
					end
					if (((v101 > (1 + 0)) and (v101 <= (1179 - (663 + 511)))) or ((947 + 114) == (404 + 1453))) then
						local v191 = v118();
						if (((8509 - 5749) > (826 + 538)) and v191) then
							return v191;
						end
					end
					v149 = 9 - 5;
				end
				if ((v149 == (2 - 1)) or ((2340 + 2562) <= (6997 - 3402))) then
					if ((v89.ConsumeMagic:IsAvailable() and v40 and v89.ConsumeMagic:IsReady() and v71 and not v14:IsCasting() and not v14:IsChanneling() and v27.UnitHasMagicBuff(v15)) or ((2746 + 1106) == (27 + 266))) then
						if (v25(v89.ConsumeMagic, not v15:IsSpellInRange(v89.ConsumeMagic)) or ((2281 - (478 + 244)) == (5105 - (440 + 77)))) then
							return "greater_purge damage";
						end
					end
					if (v99 or ((2039 + 2445) == (2883 - 2095))) then
						local v192 = 1556 - (655 + 901);
						while true do
							if (((848 + 3720) >= (2992 + 915)) and (v192 == (0 + 0))) then
								v151 = v112();
								if (((5019 - 3773) < (4915 - (695 + 750))) and v151) then
									return v151;
								end
								break;
							end
						end
					end
					if (((13890 - 9822) >= (1499 - 527)) and v89.InfernalStrike:IsCastable() and (v44 or (v89.InfernalStrike:ChargesFractional() > (3.9 - 2))) and (v89.InfernalStrike:TimeSinceLastCast() > (353 - (285 + 66)))) then
						if (((1149 - 656) < (5203 - (682 + 628))) and v25(v91.InfernalStrikePlayer, not v15:IsInMeleeRange(2 + 6))) then
							return "infernal_strike main 2";
						end
					end
					if (((v78 < v104) and v89.Metamorphosis:IsCastable() and v67 and v88 and v14:BuffDown(v89.MetamorphosisBuff) and v15:DebuffDown(v89.FieryBrandDebuff)) or ((1772 - (176 + 123)) >= (1394 + 1938))) then
						if (v25(v91.MetamorphosisPlayer, not v96) or ((2939 + 1112) <= (1426 - (239 + 30)))) then
							return "metamorphosis main 4";
						end
					end
					v149 = 1 + 1;
				end
				if (((581 + 23) < (5099 - 2218)) and (v149 == (0 - 0))) then
					v102 = (v89.FelDevastation:CooldownRemains() < (v89.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (365 - (306 + 9)));
					if ((v89.ThrowGlaive:IsCastable() and v49 and v12.ValueIsInArray(v105, v15:NPCID())) or ((3140 - 2240) == (588 + 2789))) then
						if (((2736 + 1723) > (285 + 306)) and v25(v89.ThrowGlaive, not v15:IsSpellInRange(v89.ThrowGlaive))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if (((9716 - 6318) >= (3770 - (1140 + 235))) and v89.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v105, v16:NPCID())) then
						if (v25(v91.ThrowGlaiveMouseover, not v15:IsSpellInRange(v89.ThrowGlaive)) or ((1390 + 793) >= (2590 + 234))) then
							return "fodder to the flames react per mouseover";
						end
					end
					if (((497 + 1439) == (1988 - (33 + 19))) and not v14:AffectingCombat() and v36) then
						v151 = v111();
						if (v151 or ((1745 + 3087) < (12927 - 8614))) then
							return v151;
						end
					end
					v149 = 1 + 0;
				end
				if (((8016 - 3928) > (3633 + 241)) and ((691 - (586 + 103)) == v149)) then
					v150 = v27.HandleDPSPotion();
					if (((395 + 3937) == (13336 - 9004)) and v150) then
						return v150;
					end
					if (((5487 - (1309 + 179)) >= (5235 - 2335)) and (v78 < v104)) then
						if ((v79 and ((v38 and v80) or not v80)) or ((1100 + 1425) > (10914 - 6850))) then
							local v197 = 0 + 0;
							while true do
								if (((9286 - 4915) == (8709 - 4338)) and (v197 == (609 - (295 + 314)))) then
									v151 = v110();
									if (v151 or ((653 - 387) > (6948 - (1300 + 662)))) then
										return v151;
									end
									break;
								end
							end
						end
					end
					if (((6251 - 4260) >= (2680 - (1178 + 577))) and v89.FieryDemise:IsAvailable() and (v89.FieryBrandDebuff:AuraActiveCount() > (1 + 0))) then
						local v193 = v115();
						if (((1344 - 889) < (3458 - (851 + 554))) and v193) then
							return v193;
						end
					end
					v149 = 3 + 0;
				end
				if ((v149 == (10 - 6)) or ((1793 - 967) == (5153 - (115 + 187)))) then
					if (((141 + 42) == (174 + 9)) and (v101 >= (23 - 17))) then
						local v194 = 1161 - (160 + 1001);
						local v195;
						while true do
							if (((1014 + 145) <= (1234 + 554)) and (v194 == (0 - 0))) then
								v195 = v114();
								if (v195 or ((3865 - (237 + 121)) > (5215 - (525 + 372)))) then
									return v195;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		v20.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v89.FieryBrandDebuff:RegisterAuraTracking();
	end
	v20.SetAPL(1101 - 520, v121, v122);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

