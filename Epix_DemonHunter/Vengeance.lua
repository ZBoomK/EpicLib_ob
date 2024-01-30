local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (763 - (418 + 344))) or ((3402 - (192 + 134)) > (4459 - (316 + 960)))) then
			return v6(...);
		end
		if (((669 + 533) > (817 + 241)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((14187 - 10476) > (3906 - (83 + 468))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1807 - (1202 + 604);
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
	local v81 = v17.DemonHunter.Vengeance;
	local v82 = v18.DemonHunter.Vengeance;
	local v83 = v21.DemonHunter.Vengeance;
	local v84 = {};
	local v85, v86;
	local v87 = 0 - 0;
	local v88, v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94 = true;
	local v95 = 18492 - 7381;
	local v96 = 30763 - 19652;
	local v97 = {(163525 + 5896),(61864 + 107561),(29714 + 139218),(171337 - (340 + 1571)),(171201 - (1733 + 39)),(170462 - (125 + 909)),(76002 + 93428)};
	v10:RegisterForEvent(function()
		local v113 = 0 - 0;
		while true do
			if ((v113 == (0 + 0)) or ((1418 - (409 + 103)) >= (2465 - (46 + 190)))) then
				v95 = 11206 - (51 + 44);
				v96 = 3134 + 7977;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v98()
		v85 = v14:BuffStack(v81.SoulFragments);
		if (((2605 - (1114 + 203)) > (1977 - (228 + 498))) and (v81.SpiritBomb:TimeSinceLastCast() < v14:GCD())) then
			v87 = 0 + 0;
		end
		if ((v87 == (0 + 0)) or ((5176 - (174 + 489)) < (8732 - 5380))) then
			local v154 = 1905 - (830 + 1075);
			local v155;
			while true do
				if ((v154 == (524 - (303 + 221))) or ((3334 - (231 + 1038)) >= (2664 + 532))) then
					v155 = ((v14:BuffUp(v81.MetamorphosisBuff)) and (1163 - (171 + 991))) or (0 - 0);
					if ((v81.SoulCarver:IsAvailable() and (v81.SoulCarver:TimeSinceLastCast() < v14:GCD()) and (v81.SoulCarver.LastCastTime ~= v86)) or ((11750 - 7374) <= (3695 - 2214))) then
						local v176 = 0 + 0;
						while true do
							if ((v176 == (0 - 0)) or ((9784 - 6392) >= (7641 - 2900))) then
								v87 = v28(v85 + (6 - 4), 1253 - (111 + 1137));
								v86 = v81.SoulCarver.LastCastTime;
								break;
							end
						end
					elseif (((3483 - (91 + 67)) >= (6410 - 4256)) and v81.Fracture:IsAvailable() and (v81.Fracture:TimeSinceLastCast() < v14:GCD()) and (v81.Fracture.LastCastTime ~= v86)) then
						local v182 = 0 + 0;
						while true do
							if ((v182 == (523 - (423 + 100))) or ((10 + 1285) >= (8951 - 5718))) then
								v87 = v28(v85 + 2 + 0 + v155, 776 - (326 + 445));
								v86 = v81.Fracture.LastCastTime;
								break;
							end
						end
					elseif (((19100 - 14723) > (3657 - 2015)) and (v81.Shear:TimeSinceLastCast() < v14:GCD()) and (v81.Fracture.Shear ~= v86)) then
						v87 = v28(v85 + (2 - 1) + v155, 716 - (530 + 181));
						v86 = v81.Shear.LastCastTime;
					elseif (((5604 - (614 + 267)) > (1388 - (19 + 13))) and v81.SoulSigils:IsAvailable()) then
						local v186 = 0 - 0;
						local v187;
						local v188;
						while true do
							if (((2 - 1) == v186) or ((11814 - 7678) <= (892 + 2541))) then
								if (((7465 - 3220) <= (9603 - 4972)) and v81.ElysianDecree:IsAvailable() and (v187 == v81.ElysianDecree.LastCastTime) and (v188 < v14:GCD()) and (v187 ~= v86)) then
									local v193 = v28(v93, 1815 - (1293 + 519));
									v87 = v28(v85 + v193, 10 - 5);
									v86 = v187;
								elseif (((11164 - 6888) >= (7484 - 3570)) and (v188 < v14:GCD()) and (v187 ~= v86)) then
									local v194 = 0 - 0;
									while true do
										if (((466 - 268) <= (2312 + 2053)) and (v194 == (0 + 0))) then
											v87 = v28(v85 + (2 - 1), 2 + 3);
											v86 = v187;
											break;
										end
									end
								end
								break;
							end
							if (((1589 + 3193) > (2923 + 1753)) and (v186 == (1096 - (709 + 387)))) then
								v187 = v27(v81.SigilOfFlame.LastCastTime, v81.SigilOfSilence.LastCastTime, v81.SigilOfChains.LastCastTime, v81.ElysianDecree.LastCastTime);
								v188 = v28(v81.SigilOfFlame:TimeSinceLastCast(), v81.SigilOfSilence:TimeSinceLastCast(), v81.SigilOfChains:TimeSinceLastCast(), v81.ElysianDecree:TimeSinceLastCast());
								v186 = 1859 - (673 + 1185);
							end
						end
					elseif (((14106 - 9242) > (7054 - 4857)) and v81.Fallout:IsAvailable() and (v81.ImmolationAura:TimeSinceLastCast() < v14:GCD()) and (v81.ImmolationAura.LastCastTime ~= v86)) then
						local v189 = (0.6 - 0) * v28(v93, 4 + 1);
						v87 = v28(v85 + v189, 4 + 1);
						v86 = v81.ImmolationAura.LastCastTime;
					elseif ((v81.BulkExtraction:IsAvailable() and (v81.BulkExtraction:TimeSinceLastCast() < v14:GCD()) and (v81.BulkExtraction.LastCastTime ~= v86)) or ((4995 - 1295) == (616 + 1891))) then
						local v191 = v28(v93, 9 - 4);
						v87 = v28(v85 + v191, 9 - 4);
						v86 = v81.BulkExtraction.LastCastTime;
					end
					break;
				end
			end
		else
			local v156 = 1880 - (446 + 1434);
			local v157;
			local v158;
			while true do
				if (((5757 - (1040 + 243)) >= (817 - 543)) and ((1849 - (559 + 1288)) == v156)) then
					for v174, v175 in pairs(v158) do
						if (((v157 == v175:ID()) and (v175:TimeSinceLastCast() >= v14:GCD())) or ((3825 - (609 + 1322)) <= (1860 - (13 + 441)))) then
							v87 = 0 - 0;
							break;
						end
					end
					break;
				end
				if (((4117 - 2545) >= (7625 - 6094)) and (v156 == (0 + 0))) then
					v157 = v14:PrevGCD(3 - 2);
					v158 = {v81.SoulCarver,v81.Fracture,v81.Shear,v81.BulkExtraction};
					v156 = 1 - 0;
				end
				if ((v156 == (1 + 0)) or ((2607 + 2080) < (3264 + 1278))) then
					if (((2764 + 527) > (1631 + 36)) and v81.SoulSigils:IsAvailable()) then
						v23(v158, v81.SigilOfFlame);
						v23(v158, v81.SigilOfSilence);
						v23(v158, v81.SigilOfChains);
						v23(v158, v81.ElysianDecree);
					end
					if (v81.Fallout:IsAvailable() or ((1306 - (153 + 280)) == (5873 - 3839))) then
						v23(v158, v81.ImmolationAura);
					end
					v156 = 2 + 0;
				end
			end
		end
		if ((v87 > v85) or ((1112 + 1704) < (6 + 5))) then
			v85 = v87;
		elseif (((3357 + 342) < (3410 + 1296)) and (v87 > (0 - 0))) then
			v87 = 0 + 0;
		end
	end
	local function v99()
		if (((3313 - (89 + 578)) >= (626 + 250)) and ((v81.Felblade:TimeSinceLastCast() < v14:GCD()) or (v81.InfernalStrike:TimeSinceLastCast() < v14:GCD()))) then
			v88 = true;
			v89 = true;
			return;
		end
		v88 = v15:IsInMeleeRange(10 - 5);
		v89 = v88 or (v93 > (1049 - (572 + 477)));
	end
	local function v100()
		v29 = v22.HandleTopTrinket(v84, v32, 6 + 34, nil);
		if (((369 + 245) <= (381 + 2803)) and v29) then
			return v29;
		end
		v29 = v22.HandleBottomTrinket(v84, v32, 126 - (84 + 2), nil);
		if (((5151 - 2025) == (2253 + 873)) and v29) then
			return v29;
		end
	end
	local function v101()
		local v114 = 842 - (497 + 345);
		while true do
			if ((v114 == (1 + 0)) or ((370 + 1817) >= (6287 - (605 + 728)))) then
				if ((v81.InfernalStrike:IsCastable() and v38 and (v81.InfernalStrike:ChargesFractional() > (1.7 + 0))) or ((8619 - 4742) == (164 + 3411))) then
					if (((2613 - 1906) > (570 + 62)) and v20(v83.InfernalStrikePlayer, not v15:IsInMeleeRange(21 - 13))) then
						return "infernal_strike precombat 6";
					end
				end
				if ((v81.Fracture:IsCastable() and v36 and v88) or ((413 + 133) >= (3173 - (457 + 32)))) then
					if (((622 + 843) <= (5703 - (832 + 570))) and v20(v81.Fracture)) then
						return "fracture precombat 8";
					end
				end
				v114 = 2 + 0;
			end
			if (((445 + 1259) > (5042 - 3617)) and ((1 + 1) == v114)) then
				if ((v81.Shear:IsCastable() and v39 and v88) or ((1483 - (588 + 208)) == (11411 - 7177))) then
					if (v20(v81.Shear) or ((5130 - (884 + 916)) < (2991 - 1562))) then
						return "shear precombat 10";
					end
				end
				break;
			end
			if (((666 + 481) >= (988 - (232 + 421))) and (v114 == (1889 - (1569 + 320)))) then
				if (((843 + 2592) > (399 + 1698)) and v40 and not v14:IsMoving() and v81.SigilOfFlame:IsCastable()) then
					if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((12704 - 8934) >= (4646 - (316 + 289)))) then
						if (v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(20 - 12)) or ((176 + 3615) <= (3064 - (666 + 787)))) then
							return "sigil_of_flame precombat 2";
						end
					elseif ((v78 == "cursor") or ((5003 - (360 + 65)) <= (1877 + 131))) then
						if (((1379 - (79 + 175)) <= (3273 - 1197)) and v20(v83.SigilOfFlameCursor, not v15:IsInRange(24 + 6))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if ((v81.ImmolationAura:IsCastable() and v37) or ((2277 - 1534) >= (8471 - 4072))) then
					if (((2054 - (503 + 396)) < (1854 - (92 + 89))) and v20(v81.ImmolationAura, not v15:IsInMeleeRange(15 - 7))) then
						return "immolation_aura precombat 4";
					end
				end
				v114 = 1 + 0;
			end
		end
	end
	local function v102()
		local v115 = 0 + 0;
		while true do
			if ((v115 == (0 - 0)) or ((318 + 2006) <= (1317 - 739))) then
				if (((3287 + 480) == (1800 + 1967)) and v81.DemonSpikes:IsCastable() and v59 and v14:BuffDown(v81.DemonSpikesBuff) and v14:BuffDown(v81.MetamorphosisBuff) and (((v93 == (2 - 1)) and v14:BuffDown(v81.FieryBrandDebuff)) or (v93 > (1 + 0)))) then
					if (((6235 - 2146) == (5333 - (485 + 759))) and (v81.DemonSpikes:ChargesFractional() > (2.9 - 1))) then
						if (((5647 - (442 + 747)) >= (2809 - (832 + 303))) and v20(v81.DemonSpikes)) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (((1918 - (88 + 858)) <= (433 + 985)) and (v90 or (v14:HealthPercentage() <= v62))) then
						if (v20(v81.DemonSpikes) or ((4087 + 851) < (197 + 4565))) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if ((v81.Metamorphosis:IsCastable() and v61 and (v14:HealthPercentage() <= v64) and (v14:BuffDown(v81.MetamorphosisBuff) or (v15:TimeToDie() < (804 - (766 + 23))))) or ((12361 - 9857) > (5831 - 1567))) then
					if (((5672 - 3519) == (7307 - 5154)) and v20(v83.MetamorphosisPlayer)) then
						return "metamorphosis defensives";
					end
				end
				v115 = 1074 - (1036 + 37);
			end
			if ((v115 == (1 + 0)) or ((987 - 480) >= (2039 + 552))) then
				if (((5961 - (641 + 839)) == (5394 - (910 + 3))) and v81.FieryBrand:IsCastable() and v60 and (v90 or (v14:HealthPercentage() <= v63))) then
					if (v20(v81.FieryBrand, not v15:IsSpellInRange(v81.FieryBrand)) or ((5934 - 3606) < (2377 - (1466 + 218)))) then
						return "fiery_brand defensives";
					end
				end
				if (((1990 + 2338) == (5476 - (556 + 592))) and v82.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) then
					if (((565 + 1023) >= (2140 - (329 + 479))) and v20(v83.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v115 = 856 - (174 + 680);
			end
			if ((v115 == (6 - 4)) or ((8651 - 4477) > (3033 + 1215))) then
				if ((v73 and (v14:HealthPercentage() <= v75)) or ((5325 - (396 + 343)) <= (8 + 74))) then
					local v173 = 1477 - (29 + 1448);
					while true do
						if (((5252 - (135 + 1254)) == (14552 - 10689)) and (v173 == (0 - 0))) then
							if ((v77 == "Refreshing Healing Potion") or ((188 + 94) <= (1569 - (389 + 1138)))) then
								if (((5183 - (102 + 472)) >= (723 + 43)) and v82.RefreshingHealingPotion:IsReady()) then
									if (v20(v83.RefreshingHealingPotion) or ((639 + 513) == (2320 + 168))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((4967 - (320 + 1225)) > (5963 - 2613)) and (v77 == "Dreamwalker's Healing Potion")) then
								if (((537 + 340) > (1840 - (157 + 1307))) and v82.DreamwalkersHealingPotion:IsReady()) then
									if (v20(v83.RefreshingHealingPotion) or ((4977 - (821 + 1038)) <= (4618 - 2767))) then
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
	local function v103()
		local v116 = 0 + 0;
		while true do
			if ((v116 == (1 - 0)) or ((62 + 103) >= (8654 - 5162))) then
				if (((4975 - (834 + 192)) < (309 + 4547)) and v81.SigilOfSilence:IsCastable() and v46 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfSilence:IsAvailable()) then
					if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((1098 + 3178) < (65 + 2951))) then
						if (((7265 - 2575) > (4429 - (300 + 4))) and v20(v83.SigilOfSilencePlayer, not v15:IsInMeleeRange(3 + 5))) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((v78 == "cursor") or ((130 - 80) >= (1258 - (112 + 250)))) then
						if (v20(v83.SigilOfSilenceCursor, not v15:IsInRange(12 + 18)) or ((4293 - 2579) >= (1695 + 1263))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v81.ThrowGlaive:IsCastable() and v43) or ((772 + 719) < (482 + 162))) then
					if (((350 + 354) < (734 + 253)) and v20(v81.ThrowGlaive, not v15:IsSpellInRange(v81.ThrowGlaive))) then
						return "throw_glaive filler 8";
					end
				end
				break;
			end
			if (((5132 - (1001 + 413)) > (4250 - 2344)) and (v116 == (882 - (244 + 638)))) then
				if ((v81.SigilOfChains:IsCastable() and v47 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfChains:IsAvailable()) or ((1651 - (627 + 66)) > (10830 - 7195))) then
					if (((4103 - (512 + 90)) <= (6398 - (1665 + 241))) and ((v78 == "player") or v81.ConcentratedSigils:IsAvailable())) then
						if (v20(v83.SigilOfChainsPlayer, not v15:IsInMeleeRange(725 - (373 + 344))) or ((1553 + 1889) < (675 + 1873))) then
							return "sigil_of_chains player filler 2";
						end
					elseif (((7583 - 4708) >= (2477 - 1013)) and (v78 == "cursor")) then
						if (v20(v83.SigilOfChainsCursor, not v15:IsInRange(1129 - (35 + 1064))) or ((3491 + 1306) >= (10468 - 5575))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if ((v81.SigilOfMisery:IsCastable() and v48 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfMisery:IsAvailable()) or ((3 + 548) > (3304 - (298 + 938)))) then
					if (((3373 - (233 + 1026)) > (2610 - (636 + 1030))) and ((v78 == "player") or v81.ConcentratedSigils:IsAvailable())) then
						if (v20(v83.SigilOfMiseryPlayer, not v15:IsInMeleeRange(5 + 3)) or ((2210 + 52) >= (920 + 2176))) then
							return "sigil_of_misery player filler 4";
						end
					elseif ((v78 == "cursor") or ((153 + 2102) >= (3758 - (55 + 166)))) then
						if (v20(v83.SigilOfMiseryCursor, not v15:IsInRange(6 + 24)) or ((386 + 3451) < (4987 - 3681))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v116 = 298 - (36 + 261);
			end
		end
	end
	local function v104()
		if (((5159 - 2209) == (4318 - (34 + 1334))) and v81.FelDevastation:IsReady() and (v70 < v96) and v50 and ((v32 and v54) or not v54) and (v81.CollectiveAnguish:IsAvailable() or v81.StoketheFlames:IsAvailable())) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(4 + 4)) or ((3670 + 1053) < (4581 - (1035 + 248)))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if (((1157 - (20 + 1)) >= (81 + 73)) and v81.TheHunt:IsCastable() and (v70 < v96) and v52 and ((v32 and v56) or not v56)) then
			if (v20(v81.TheHunt, not v15:IsInRange(369 - (134 + 185))) or ((1404 - (549 + 584)) > (5433 - (314 + 371)))) then
				return "the_hunt big_aoe 4";
			end
		end
		if (((16272 - 11532) >= (4120 - (478 + 490))) and v81.ElysianDecree:IsCastable() and (v70 < v96) and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v93 > v58)) then
			if ((v57 == "player") or ((1366 + 1212) >= (4562 - (786 + 386)))) then
				if (((132 - 91) <= (3040 - (1055 + 324))) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(1348 - (1093 + 247)))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif (((535 + 66) < (375 + 3185)) and (v57 == "cursor")) then
				if (((932 - 697) < (2331 - 1644)) and v20(v83.ElysianDecreeCursor, not v15:IsInRange(85 - 55))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if (((11431 - 6882) > (411 + 742)) and v81.FelDevastation:IsReady() and (v70 < v96) and v50 and ((v32 and v54) or not v54)) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(30 - 22)) or ((16110 - 11436) < (3523 + 1149))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if (((9380 - 5712) < (5249 - (364 + 324))) and v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) then
			if (v20(v81.SoulCarver, not v88) or ((1247 - 792) == (8650 - 5045))) then
				return "soul_carver big_aoe 10";
			end
		end
		if ((v81.SpiritBomb:IsReady() and (v85 >= (2 + 2)) and v42) or ((11142 - 8479) == (5303 - 1991))) then
			if (((12989 - 8712) <= (5743 - (1249 + 19))) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(8 + 0))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if ((v81.Fracture:IsCastable() and v36) or ((3386 - 2516) == (2275 - (686 + 400)))) then
			if (((1219 + 334) <= (3362 - (73 + 156))) and v20(v81.Fracture, not v88)) then
				return "fracture big_aoe 14";
			end
		end
		if ((v81.Shear:IsCastable() and v39) or ((11 + 2226) >= (4322 - (721 + 90)))) then
			if (v20(v81.Shear, not v88) or ((15 + 1309) > (9805 - 6785))) then
				return "shear big_aoe 16";
			end
		end
		if ((v81.SoulCleave:IsReady() and (v85 < (471 - (224 + 246))) and v41) or ((4846 - 1854) == (3463 - 1582))) then
			if (((564 + 2542) > (37 + 1489)) and v20(v81.SoulCleave, not v88)) then
				return "soul_cleave big_aoe 18";
			end
		end
		local v117 = v103();
		if (((2221 + 802) < (7694 - 3824)) and v117) then
			return v117;
		end
	end
	local function v105()
		local v118 = 0 - 0;
		while true do
			if (((656 - (203 + 310)) > (2067 - (1238 + 755))) and (v118 == (1 + 2))) then
				if (((1552 - (709 + 825)) < (3891 - 1779)) and v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) then
					if (((1597 - 500) <= (2492 - (196 + 668))) and (v57 == "player")) then
						if (((18280 - 13650) == (9590 - 4960)) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(841 - (171 + 662)))) then
							return "elysian_decree fiery_demise 20 (Player)";
						end
					elseif (((3633 - (4 + 89)) > (9403 - 6720)) and (v57 == "cursor")) then
						if (((1746 + 3048) >= (14384 - 11109)) and v20(v83.ElysianDecreeCursor, not v15:IsInRange(12 + 18))) then
							return "elysian_decree fiery_demise 20 (Cursor)";
						end
					end
				end
				if (((2970 - (35 + 1451)) == (2937 - (28 + 1425))) and v81.SoulCleave:IsReady() and (v14:FuryDeficit() <= (2023 - (941 + 1052))) and not v94 and v41) then
					if (((1374 + 58) < (5069 - (822 + 692))) and v20(v81.SoulCleave, not v88)) then
						return "soul_cleave fiery_demise 22";
					end
				end
				break;
			end
			if ((v118 == (0 - 0)) or ((502 + 563) > (3875 - (45 + 252)))) then
				if ((v81.ImmolationAura:IsCastable() and v37) or ((4745 + 50) < (485 + 922))) then
					if (((4509 - 2656) < (5246 - (114 + 319))) and v20(v81.ImmolationAura, not v15:IsInMeleeRange(11 - 3))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if ((v81.SigilOfFlame:IsCastable() and v40 and not v14:IsMoving() and (v89 or not v81.ConcentratedSigils:IsAvailable()) and v15:DebuffRefreshable(v81.SigilOfFlameDebuff)) or ((3614 - 793) < (1550 + 881))) then
					if (v81.ConcentratedSigils:IsAvailable() or (v78 == "player") or ((4281 - 1407) < (4569 - 2388))) then
						if (v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(1971 - (556 + 1407))) or ((3895 - (741 + 465)) <= (808 - (170 + 295)))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif ((v78 == "cursor") or ((985 + 884) == (1846 + 163))) then
						if (v20(v83.SigilOfFlameCursor, not v15:IsInRange(73 - 43)) or ((2940 + 606) < (1490 + 832))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				if ((v81.Felblade:IsCastable() and v35 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (29 + 21))) or ((3312 - (957 + 273)) == (1277 + 3496))) then
					if (((1299 + 1945) > (4019 - 2964)) and v20(v81.Felblade, not v88)) then
						return "felblade fiery_demise 6";
					end
				end
				v118 = 2 - 1;
			end
			if ((v118 == (5 - 3)) or ((16404 - 13091) <= (3558 - (389 + 1391)))) then
				if ((v81.SpiritBomb:IsReady() and (v93 > (1 + 0)) and (v93 <= (1 + 4)) and (v85 >= (8 - 4)) and v42) or ((2372 - (783 + 168)) >= (7061 - 4957))) then
					if (((1783 + 29) <= (3560 - (309 + 2))) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(24 - 16))) then
						return "spirit_bomb fiery_demise 14";
					end
				end
				if (((2835 - (1090 + 122)) <= (635 + 1322)) and v81.SpiritBomb:IsReady() and (v93 >= (19 - 13)) and (v85 >= (3 + 0)) and v42) then
					if (((5530 - (628 + 490)) == (792 + 3620)) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(19 - 11))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				if (((7997 - 6247) >= (1616 - (431 + 343))) and v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) then
					if (((8829 - 4457) > (5351 - 3501)) and v20(v81.TheHunt, not v15:IsInRange(24 + 6))) then
						return "the_hunt fiery_demise 18";
					end
				end
				v118 = 1 + 2;
			end
			if (((1927 - (556 + 1139)) < (836 - (6 + 9))) and (v118 == (1 + 0))) then
				if (((266 + 252) < (1071 - (28 + 141))) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) then
					if (((1160 + 1834) > (1058 - 200)) and v20(v81.FelDevastation, not v15:IsInMeleeRange(6 + 2))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				if ((v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((5072 - (486 + 831)) <= (2380 - 1465))) then
					if (((13892 - 9946) > (708 + 3035)) and v20(v81.SoulCarver, not v15:IsInMeleeRange(25 - 17))) then
						return "soul_carver fiery_demise 10";
					end
				end
				if ((v81.SpiritBomb:IsReady() and (v93 == (1264 - (668 + 595))) and (v85 >= (5 + 0)) and v42) or ((270 + 1065) >= (9015 - 5709))) then
					if (((5134 - (23 + 267)) > (4197 - (1129 + 815))) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(395 - (371 + 16)))) then
						return "spirit_bomb fiery_demise 12";
					end
				end
				v118 = 1752 - (1326 + 424);
			end
		end
	end
	local function v106()
		if (((855 - 403) == (1651 - 1199)) and v81.FieryBrand:IsCastable() and v79 and v60 and ((v15:DebuffDown(v81.FieryBrandDebuff) and ((v81.SigilOfFlame:CooldownRemains() < (v81.SigilOfFlame:ExecuteTime() + v14:GCDRemains())) or (v81.SoulCarver:CooldownRemains() < (v81.SoulCarver:ExecuteTime() + v14:GCDRemains())) or (v81.FelDevastation:CooldownRemains() < (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())))) or (v81.DownInFlames:IsAvailable() and (v81.FieryBrand:FullRechargeTime() < (v81.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) then
			if (v20(v81.FieryBrand, not v15:IsSpellInRange(v81.FieryBrand)) or ((4675 - (88 + 30)) < (2858 - (720 + 51)))) then
				return "fiery_brand maintenance 2";
			end
		end
		if (((8617 - 4743) == (5650 - (421 + 1355))) and v81.SigilOfFlame:IsCastable() and not v14:IsMoving()) then
			if (v81.ConcentratedSigils:IsAvailable() or (v78 == "player") or ((3197 - 1259) > (2425 + 2510))) then
				if (v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(1091 - (286 + 797))) or ((15554 - 11299) < (5668 - 2245))) then
					return "sigil_of_flame maintenance 4 (Player)";
				end
			elseif (((1893 - (397 + 42)) <= (779 + 1712)) and (v78 == "cursor")) then
				if (v20(v83.SigilOfFlameCursor, not v15:IsInRange(830 - (24 + 776))) or ((6403 - 2246) <= (3588 - (222 + 563)))) then
					return "sigil_of_flame maintenance 4 (Cursor)";
				end
			end
		end
		if (((10692 - 5839) >= (2147 + 835)) and v81.SpiritBomb:IsReady() and (v85 >= (195 - (23 + 167))) and v42) then
			if (((5932 - (690 + 1108)) > (1212 + 2145)) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(7 + 1))) then
				return "spirit_bomb maintenance 6";
			end
		end
		if ((v81.ImmolationAura:IsCastable() and v37) or ((4265 - (40 + 808)) < (418 + 2116))) then
			if (v20(v81.ImmolationAura, not v15:IsInMeleeRange(30 - 22)) or ((2602 + 120) <= (87 + 77))) then
				return "immolation_aura maintenance 8";
			end
		end
		if ((v81.BulkExtraction:IsCastable() and v33 and v14:PrevGCD(1 + 0, v81.SpiritBomb)) or ((2979 - (47 + 524)) < (1369 + 740))) then
			if (v20(v81.BulkExtraction, not v88) or ((90 - 57) == (2175 - 720))) then
				return "bulk_extraction maintenance 10";
			end
		end
		if ((v81.Felblade:IsCastable() and v35 and (v14:FuryDeficit() >= (91 - 51))) or ((2169 - (1165 + 561)) >= (120 + 3895))) then
			if (((10474 - 7092) > (64 + 102)) and v20(v81.Felblade, not v88)) then
				return "felblade maintenance 12";
			end
		end
		if ((v81.Fracture:IsCastable() and v36 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (529 - (341 + 138)))) or ((76 + 204) == (6312 - 3253))) then
			if (((2207 - (89 + 237)) > (4159 - 2866)) and v20(v81.Fracture, not v88)) then
				return "fracture maintenance 14";
			end
		end
		if (((4961 - 2604) == (3238 - (581 + 300))) and v81.Shear:IsCastable() and v39 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1270 - (855 + 365)))) then
			if (((291 - 168) == (41 + 82)) and v20(v81.Shear, not v88)) then
				return "shear maintenance 16";
			end
		end
		if ((v81.SpiritBomb:IsReady() and (v14:FuryDeficit() < (1265 - (1030 + 205))) and (((v93 >= (2 + 0)) and (v85 >= (5 + 0))) or ((v93 >= (292 - (156 + 130))) and (v85 >= (8 - 4)))) and not v94 and v42) or ((1779 - 723) >= (6946 - 3554))) then
			if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(3 + 5)) or ((631 + 450) < (1144 - (10 + 59)))) then
				return "spirit_bomb maintenance 18";
			end
		end
		if ((v81.SoulCleave:IsReady() and (v14:FuryDeficit() < (9 + 21)) and (v85 <= (14 - 11)) and not v94 and v41) or ((2212 - (671 + 492)) >= (3529 + 903))) then
			if (v20(v81.SoulCleave, not v88) or ((5983 - (369 + 846)) <= (224 + 622))) then
				return "soul_cleave maintenance 20";
			end
		end
	end
	local function v107()
		local v119 = 0 + 0;
		while true do
			if ((v119 == (1947 - (1036 + 909))) or ((2670 + 688) <= (2384 - 964))) then
				if ((v81.Fracture:IsCastable() and v36) or ((3942 - (11 + 192)) <= (1519 + 1486))) then
					if (v20(v81.Fracture, not v88) or ((1834 - (135 + 40)) >= (5170 - 3036))) then
						return "fracture single_target 14";
					end
				end
				if ((v81.Shear:IsCastable() and v39) or ((1966 + 1294) < (5187 - 2832))) then
					if (v20(v81.Shear, not v88) or ((1002 - 333) == (4399 - (50 + 126)))) then
						return "shear single_target 16";
					end
				end
				if ((v81.SoulCleave:IsReady() and not v94 and v41) or ((4711 - 3019) < (131 + 457))) then
					if (v20(v81.SoulCleave, not v88) or ((6210 - (1233 + 180)) < (4620 - (522 + 447)))) then
						return "soul_cleave single_target 18";
					end
				end
				v119 = 1424 - (107 + 1314);
			end
			if ((v119 == (1 + 0)) or ((12727 - 8550) > (2060 + 2790))) then
				if ((v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) or ((794 - 394) > (4395 - 3284))) then
					if (((4961 - (716 + 1194)) > (18 + 987)) and (v57 == "player")) then
						if (((396 + 3297) <= (4885 - (74 + 429))) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(14 - 6))) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif ((v57 == "cursor") or ((1627 + 1655) > (9385 - 5285))) then
						if (v20(v83.ElysianDecreeCursor, not v15:IsInRange(22 + 8)) or ((11036 - 7456) < (7031 - 4187))) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				if (((522 - (279 + 154)) < (5268 - (454 + 324))) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) then
					if (v20(v81.FelDevastation, not v15:IsInMeleeRange(7 + 1)) or ((5000 - (12 + 5)) < (975 + 833))) then
						return "fel_devastation single_target 10";
					end
				end
				if (((9756 - 5927) > (1393 + 2376)) and v81.SoulCleave:IsReady() and v81.FocusedCleave:IsAvailable() and not v94 and v41) then
					if (((2578 - (277 + 816)) <= (12409 - 9505)) and v20(v81.SoulCleave, not v88)) then
						return "soul_cleave single_target 12";
					end
				end
				v119 = 1185 - (1058 + 125);
			end
			if (((801 + 3468) == (5244 - (815 + 160))) and ((0 - 0) == v119)) then
				if (((918 - 531) <= (664 + 2118)) and v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) then
					if (v20(v81.TheHunt, not v15:IsInRange(87 - 57)) or ((3797 - (41 + 1857)) <= (2810 - (1222 + 671)))) then
						return "the_hunt single_target 2";
					end
				end
				if ((v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((11144 - 6832) <= (1258 - 382))) then
					if (((3414 - (229 + 953)) <= (4370 - (1111 + 663))) and v20(v81.SoulCarver, not v88)) then
						return "soul_carver single_target 4";
					end
				end
				if (((3674 - (874 + 705)) < (516 + 3170)) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96) and (v81.CollectiveAnguish:IsAvailable() or (v81.StoketheFlames:IsAvailable() and v81.BurningBlood:IsAvailable()))) then
					if (v20(v81.FelDevastation, not v15:IsInMeleeRange(6 + 2)) or ((3315 - 1720) >= (126 + 4348))) then
						return "fel_devastation single_target 6";
					end
				end
				v119 = 680 - (642 + 37);
			end
			if ((v119 == (1 + 2)) or ((739 + 3880) < (7235 - 4353))) then
				v29 = v103();
				if (v29 or ((748 - (233 + 221)) >= (11171 - 6340))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v108()
		if (((1786 + 243) <= (4625 - (718 + 823))) and v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) then
			if (v20(v81.TheHunt, not v15:IsInRange(19 + 11)) or ((2842 - (266 + 539)) == (6851 - 4431))) then
				return "the_hunt small_aoe 2";
			end
		end
		if (((5683 - (636 + 589)) > (9266 - 5362)) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96) and (v81.CollectiveAnguish:IsAvailable() or (v81.StoketheFlames:IsAvailable() and v81.BurningBlood:IsAvailable()))) then
			if (((898 - 462) >= (98 + 25)) and v20(v81.FelDevastation, not v15:IsInMeleeRange(3 + 5))) then
				return "fel_devastation small_aoe 4";
			end
		end
		if (((1515 - (657 + 358)) < (4808 - 2992)) and v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) then
			if (((8142 - 4568) == (4761 - (1151 + 36))) and (v57 == "player")) then
				if (((214 + 7) < (103 + 287)) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(23 - 15))) then
					return "elysian_decree small_aoe 6 (Player)";
				end
			elseif ((v57 == "cursor") or ((4045 - (1552 + 280)) <= (2255 - (64 + 770)))) then
				if (((2077 + 981) < (11032 - 6172)) and v20(v83.ElysianDecreeCursor, not v15:IsInRange(6 + 24))) then
					return "elysian_decree small_aoe 6 (Cursor)";
				end
			end
		end
		if ((v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) or ((2539 - (157 + 1086)) >= (8898 - 4452))) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(35 - 27)) or ((2136 - 743) > (6126 - 1637))) then
				return "fel_devastation small_aoe 8";
			end
		end
		if ((v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((5243 - (599 + 220)) < (53 - 26))) then
			if (v20(v81.SoulCarver, not v88) or ((3928 - (1813 + 118)) > (2789 + 1026))) then
				return "soul_carver small_aoe 10";
			end
		end
		if (((4682 - (841 + 376)) > (2679 - 766)) and v81.SpiritBomb:IsReady() and (v85 >= (2 + 3)) and v42) then
			if (((2000 - 1267) < (2678 - (464 + 395))) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(20 - 12))) then
				return "spirit_bomb small_aoe 12";
			end
		end
		if ((v81.SoulCleave:IsReady() and v81.FocusedCleave:IsAvailable() and (v85 <= (1 + 1)) and v41) or ((5232 - (467 + 370)) == (9825 - 5070))) then
			if (v20(v81.SoulCleave, not v88) or ((2785 + 1008) < (8120 - 5751))) then
				return "soul_cleave small_aoe 14";
			end
		end
		if ((v81.Fracture:IsCastable() and v36) or ((638 + 3446) == (616 - 351))) then
			if (((4878 - (150 + 370)) == (5640 - (74 + 1208))) and v20(v81.Fracture, not v88)) then
				return "fracture small_aoe 16";
			end
		end
		if ((v81.Shear:IsCastable() and v39) or ((7718 - 4580) < (4709 - 3716))) then
			if (((2370 + 960) > (2713 - (14 + 376))) and v20(v81.Shear, not v88)) then
				return "shear small_aoe 18";
			end
		end
		if ((v81.SoulCleave:IsReady() and (v85 <= (3 - 1)) and v41) or ((2347 + 1279) == (3505 + 484))) then
			if (v20(v81.SoulCleave, not v88) or ((874 + 42) == (7826 - 5155))) then
				return "soul_cleave small_aoe 20";
			end
		end
		v29 = v103();
		if (((205 + 67) == (350 - (23 + 55))) and v29) then
			return v29;
		end
	end
	local function v109()
		v33 = EpicSettings.Settings['useBulkExtraction'];
		v34 = EpicSettings.Settings['useConsumeMagic'];
		v35 = EpicSettings.Settings['useFelblade'];
		v36 = EpicSettings.Settings['useFracture'];
		v37 = EpicSettings.Settings['useImmolationAura'];
		v38 = EpicSettings.Settings['useInfernalStrike'];
		v39 = EpicSettings.Settings['useShear'];
		v40 = EpicSettings.Settings['useSigilOfFlame'];
		v41 = EpicSettings.Settings['useSoulCleave'];
		v42 = EpicSettings.Settings['useSpiritBomb'];
		v43 = EpicSettings.Settings['useThrowGlaive'];
		v44 = EpicSettings.Settings['useChaosNova'];
		v45 = EpicSettings.Settings['useDisrupt'];
		v46 = EpicSettings.Settings['useSigilOfSilence'];
		v47 = EpicSettings.Settings['useSigilOfChains'];
		v48 = EpicSettings.Settings['useSigilOfMisery'];
		v49 = EpicSettings.Settings['useElysianDecree'];
		v50 = EpicSettings.Settings['useFelDevastation'];
		v51 = EpicSettings.Settings['useSoulCarver'];
		v52 = EpicSettings.Settings['useTheHunt'];
		v53 = EpicSettings.Settings['elysianDecreeWithCD'];
		v54 = EpicSettings.Settings['felDevastationWithCD'];
		v55 = EpicSettings.Settings['soulCarverWithCD'];
		v56 = EpicSettings.Settings['theHuntWithCD'];
		v59 = EpicSettings.Settings['useDemonSpikes'];
		v60 = EpicSettings.Settings['useFieryBrand'];
		v61 = EpicSettings.Settings['useMetamorphosis'];
		v62 = EpicSettings.Settings['demonSpikesHP'] or (0 - 0);
		v63 = EpicSettings.Settings['fieryBrandHP'] or (0 + 0);
		v64 = EpicSettings.Settings['metamorphosisHP'] or (0 + 0);
		v78 = EpicSettings.Settings['sigilSetting'] or "player";
		v57 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v58 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
		v79 = EpicSettings.Settings['fieryBrandOffensively'];
		v80 = EpicSettings.Settings['metamorphosisOffensively'];
	end
	local function v110()
		local v149 = 0 + 0;
		while true do
			if (((5150 - (652 + 249)) <= (12949 - 8110)) and (v149 == (1871 - (708 + 1160)))) then
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v149 = 31 - (10 + 17);
			end
			if (((624 + 2153) < (4932 - (1400 + 332))) and (v149 == (3 - 1))) then
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v149 = 1911 - (242 + 1666);
			end
			if (((41 + 54) < (718 + 1239)) and (v149 == (1 + 0))) then
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v149 = 942 - (850 + 90);
			end
			if (((1446 - 620) < (3107 - (360 + 1030))) and ((4 + 0) == v149)) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((4024 - 2598) >= (1519 - 414)) and (v149 == (1661 - (909 + 752)))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (1223 - (109 + 1114));
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v149 = 1 - 0;
			end
		end
	end
	local function v111()
		v109();
		v110();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		if (((1073 + 1681) <= (3621 - (6 + 236))) and v14:IsDeadOrGhost()) then
			return v29;
		end
		v92 = v14:GetEnemiesInMeleeRange(6 + 2);
		if (v31 or ((3161 + 766) == (3332 - 1919))) then
			v93 = #v92;
		else
			v93 = 1 - 0;
		end
		v98();
		v99();
		v90 = v14:ActiveMitigationNeeded();
		v91 = v14:IsTankingAoE(1141 - (1076 + 57)) or v14:IsTanking(v15);
		if (v22.TargetIsValid() or v14:AffectingCombat() or ((190 + 964) <= (1477 - (579 + 110)))) then
			local v159 = 0 + 0;
			while true do
				if ((v159 == (0 + 0)) or ((872 + 771) > (3786 - (174 + 233)))) then
					v95 = v10.BossFightRemains(nil, true);
					v96 = v95;
					v159 = 2 - 1;
				end
				if ((v159 == (1 - 0)) or ((1247 + 1556) > (5723 - (663 + 511)))) then
					if ((v96 == (9913 + 1198)) or ((48 + 172) >= (9316 - 6294))) then
						v96 = v10.FightRemains(v92, false);
					end
					break;
				end
			end
		end
		if (((1709 + 1113) == (6643 - 3821)) and v66) then
			local v160 = 0 - 0;
			while true do
				if ((v160 == (0 + 0)) or ((2064 - 1003) == (1324 + 533))) then
					v29 = v22.HandleIncorporeal(v81.Imprison, v83.ImprisonMouseover, 2 + 18);
					if (((3482 - (478 + 244)) > (1881 - (440 + 77))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v22.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2229 + 2673) <= (13157 - 9562))) then
			local v161 = 1556 - (655 + 901);
			local v162;
			local v163;
			while true do
				if ((v161 == (1 + 0)) or ((2949 + 903) == (198 + 95))) then
					if ((not v14:AffectingCombat() and v30) or ((6280 - 4721) == (6033 - (695 + 750)))) then
						v163 = v101();
						if (v163 or ((15311 - 10827) == (1215 - 427))) then
							return v163;
						end
					end
					if (((18371 - 13803) >= (4258 - (285 + 66))) and v81.ConsumeMagic:IsAvailable() and v34 and v81.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v22.UnitHasMagicBuff(v15)) then
						if (((2904 - 1658) < (4780 - (682 + 628))) and v20(v81.ConsumeMagic, not v15:IsSpellInRange(v81.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((656 + 3412) >= (1271 - (176 + 123))) and v91) then
						v163 = v102();
						if (((207 + 286) < (2824 + 1069)) and v163) then
							return v163;
						end
					end
					v161 = 271 - (239 + 30);
				end
				if (((0 + 0) == v161) or ((1416 + 57) >= (5897 - 2565))) then
					v94 = (v81.FelDevastation:CooldownRemains() < (v81.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (155 - 105));
					if ((v81.ThrowGlaive:IsCastable() and v43 and v12.ValueIsInArray(v97, v15:NPCID())) or ((4366 - (306 + 9)) <= (4037 - 2880))) then
						if (((106 + 498) < (1768 + 1113)) and v20(v81.ThrowGlaive, not v15:IsSpellInRange(v81.ThrowGlaive))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if ((v81.ThrowGlaive:IsReady() and v43 and v12.ValueIsInArray(v97, v16:NPCID())) or ((434 + 466) == (9656 - 6279))) then
						if (((5834 - (1140 + 235)) > (377 + 214)) and v20(v83.ThrowGlaiveMouseover, not v15:IsSpellInRange(v81.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v161 = 1 + 0;
				end
				if (((873 + 2525) >= (2447 - (33 + 19))) and (v161 == (2 + 2))) then
					v163 = v106();
					if (v163 or ((6542 - 4359) >= (1245 + 1579))) then
						return v163;
					end
					if (((3796 - 1860) == (1816 + 120)) and (v93 <= (690 - (586 + 103)))) then
						local v177 = v107();
						if (v177 or ((440 + 4392) < (13278 - 8965))) then
							return v177;
						end
					end
					v161 = 1493 - (1309 + 179);
				end
				if (((7379 - 3291) > (1687 + 2187)) and ((5 - 3) == v161)) then
					if (((3273 + 1059) == (9203 - 4871)) and v81.InfernalStrike:IsCastable() and v38 and (v81.InfernalStrike:ChargesFractional() > (1.7 - 0)) and (v81.InfernalStrike:TimeSinceLastCast() > (611 - (295 + 314)))) then
						if (((9821 - 5822) >= (4862 - (1300 + 662))) and v20(v83.InfernalStrikePlayer, not v15:IsInMeleeRange(24 - 16))) then
							return "infernal_strike main 2";
						end
					end
					if (((v70 < v96) and v81.Metamorphosis:IsCastable() and v61 and v80 and v14:BuffDown(v81.MetamorphosisBuff) and v15:DebuffDown(v81.FieryBrandDebuff)) or ((4280 - (1178 + 577)) > (2111 + 1953))) then
						if (((12921 - 8550) == (5776 - (851 + 554))) and v20(v83.MetamorphosisPlayer, not v88)) then
							return "metamorphosis main 4";
						end
					end
					v162 = v22.HandleDPSPotion();
					v161 = 3 + 0;
				end
				if ((v161 == (8 - 5)) or ((577 - 311) > (5288 - (115 + 187)))) then
					if (((1525 + 466) >= (876 + 49)) and v162) then
						return v162;
					end
					if (((1793 - 1338) < (3214 - (160 + 1001))) and (v70 < v96)) then
						if ((v71 and ((v32 and v72) or not v72)) or ((723 + 103) == (3348 + 1503))) then
							v163 = v100();
							if (((374 - 191) == (541 - (237 + 121))) and v163) then
								return v163;
							end
						end
					end
					if (((2056 - (525 + 372)) <= (3389 - 1601)) and v81.FieryDemise:IsAvailable() and (v81.FieryBrandDebuff:AuraActiveCount() > (3 - 2))) then
						local v178 = v105();
						if (v178 or ((3649 - (96 + 46)) > (5095 - (643 + 134)))) then
							return v178;
						end
					end
					v161 = 2 + 2;
				end
				if ((v161 == (11 - 6)) or ((11416 - 8341) <= (2844 + 121))) then
					if (((2678 - 1313) <= (4110 - 2099)) and (v93 > (720 - (316 + 403))) and (v93 <= (4 + 1))) then
						local v179 = 0 - 0;
						local v180;
						while true do
							if ((v179 == (0 + 0)) or ((6990 - 4214) > (2534 + 1041))) then
								v180 = v108();
								if (v180 or ((824 + 1730) == (16645 - 11841))) then
									return v180;
								end
								break;
							end
						end
					end
					if (((12307 - 9730) == (5353 - 2776)) and (v93 >= (1 + 5))) then
						local v181 = v104();
						if (v181 or ((11 - 5) >= (93 + 1796))) then
							return v181;
						end
					end
					break;
				end
			end
		end
	end
	local function v112()
		v19.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v81.FieryBrandDebuff:RegisterAuraTracking();
	end
	v19.SetAPL(1709 - 1128, v111, v112);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

