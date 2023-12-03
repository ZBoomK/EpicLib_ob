local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1619 - (1427 + 192);
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((5499 - 3130) == (383 + 43))) then
			v6 = v0[v4];
			if (not v6 or ((1394 + 1682) > (3509 - (192 + 134)))) then
				return v1(v4, ...);
			end
			v5 = 1277 - (316 + 960);
		end
		if (((669 + 533) > (817 + 241)) and (v5 == (1 + 0))) then
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
	local v35 = 18 - 13;
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
	local v90 = v18.DemonHunter.Vengeance;
	local v91 = v19.DemonHunter.Vengeance;
	local v92 = v26.DemonHunter.Vengeance;
	local v93 = {};
	local v94, v95;
	local v96 = 551 - (83 + 468);
	local v97, v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103 = true;
	local v104 = 12917 - (1202 + 604);
	local v105 = 51868 - 40757;
	local v106 = {(469082 - 299661),(163528 + 5897),(61684 + 107248),(29801 + 139625),(171340 - (340 + 1571)),(171200 - (1733 + 39)),(170464 - (125 + 909))};
	v10:RegisterForEvent(function()
		local v124 = 1948 - (1096 + 852);
		while true do
			if (((1665 + 2046) > (4790 - 1435)) and (v124 == (0 + 0))) then
				v104 = 11623 - (409 + 103);
				v105 = 11347 - (46 + 190);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v107()
		local v125 = 95 - (51 + 44);
		while true do
			if (((1 + 0) == v125) or ((2223 - (1114 + 203)) >= (2955 - (228 + 498)))) then
				if (((280 + 1008) > (692 + 559)) and (v96 == (663 - (174 + 489)))) then
					local v183 = 0 - 0;
					local v184;
					while true do
						if ((v183 == (1905 - (830 + 1075))) or ((5037 - (303 + 221)) < (4621 - (231 + 1038)))) then
							v184 = ((v14:BuffUp(v90.MetamorphosisBuff)) and (1 + 0)) or (1162 - (171 + 991));
							if ((v90.SoulCarver:IsAvailable() and (v90.SoulCarver:TimeSinceLastCast() < v14:GCD()) and (v90.SoulCarver.LastCastTime ~= v95)) or ((8510 - 6445) >= (8581 - 5385))) then
								local v198 = 0 - 0;
								while true do
									if ((v198 == (0 + 0)) or ((15339 - 10963) <= (4272 - 2791))) then
										v96 = v34(v94 + (2 - 0), 15 - 10);
										v95 = v90.SoulCarver.LastCastTime;
										break;
									end
								end
							elseif ((v90.Fracture:IsAvailable() and (v90.Fracture:TimeSinceLastCast() < v14:GCD()) and (v90.Fracture.LastCastTime ~= v95)) or ((4640 - (111 + 1137)) >= (4899 - (91 + 67)))) then
								local v199 = 0 - 0;
								while true do
									if (((830 + 2495) >= (2677 - (423 + 100))) and ((0 + 0) == v199)) then
										v96 = v34(v94 + (5 - 3) + v184, 3 + 2);
										v95 = v90.Fracture.LastCastTime;
										break;
									end
								end
							elseif (((v90.Shear:TimeSinceLastCast() < v14:GCD()) and (v90.Fracture.Shear ~= v95)) or ((2066 - (326 + 445)) >= (14108 - 10875))) then
								local v201 = 0 - 0;
								while true do
									if (((10216 - 5839) > (2353 - (530 + 181))) and ((881 - (614 + 267)) == v201)) then
										v96 = v34(v94 + (33 - (19 + 13)) + v184, 7 - 2);
										v95 = v90.Shear.LastCastTime;
										break;
									end
								end
							elseif (((11005 - 6282) > (3873 - 2517)) and v90.SoulSigils:IsAvailable()) then
								local v203 = 0 + 0;
								local v204;
								local v205;
								while true do
									if ((v203 == (0 - 0)) or ((8577 - 4441) <= (5245 - (1293 + 519)))) then
										v204 = v32(v90.SigilOfFlame.LastCastTime, v90.SigilOfSilence.LastCastTime, v90.SigilOfChains.LastCastTime, v90.ElysianDecree.LastCastTime);
										v205 = v34(v90.SigilOfFlame:TimeSinceLastCast(), v90.SigilOfSilence:TimeSinceLastCast(), v90.SigilOfChains:TimeSinceLastCast(), v90.ElysianDecree:TimeSinceLastCast());
										v203 = 1 - 0;
									end
									if (((11083 - 6838) <= (8855 - 4224)) and (v203 == (4 - 3))) then
										if (((10072 - 5796) >= (2074 + 1840)) and v90.ElysianDecree:IsAvailable() and (v204 == v90.ElysianDecree.LastCastTime) and (v205 < v14:GCD()) and (v204 ~= v95)) then
											local v211 = v34(v102, 1 + 2);
											v96 = v34(v94 + v211, 11 - 6);
											v95 = v204;
										elseif (((46 + 152) <= (1451 + 2914)) and (v205 < v14:GCD()) and (v204 ~= v95)) then
											local v212 = 0 + 0;
											while true do
												if (((5878 - (709 + 387)) > (6534 - (673 + 1185))) and ((0 - 0) == v212)) then
													v96 = v34(v94 + (3 - 2), 8 - 3);
													v95 = v204;
													break;
												end
											end
										end
										break;
									end
								end
							elseif (((3480 + 1384) > (1642 + 555)) and v90.Fallout:IsAvailable() and (v90.ImmolationAura:TimeSinceLastCast() < v14:GCD()) and (v90.ImmolationAura.LastCastTime ~= v95)) then
								local v207 = (0.6 - 0) * v34(v102, 2 + 3);
								v96 = v34(v94 + v207, 9 - 4);
								v95 = v90.ImmolationAura.LastCastTime;
							elseif ((v90.BulkExtraction:IsAvailable() and (v90.BulkExtraction:TimeSinceLastCast() < v14:GCD()) and (v90.BulkExtraction.LastCastTime ~= v95)) or ((7263 - 3563) == (4387 - (446 + 1434)))) then
								local v209 = v34(v102, 1288 - (1040 + 243));
								v96 = v34(v94 + v209, 14 - 9);
								v95 = v90.BulkExtraction.LastCastTime;
							end
							break;
						end
					end
				else
					local v185 = v14:PrevGCD(1848 - (559 + 1288));
					local v186 = {v90.SoulCarver,v90.Fracture,v90.Shear,v90.BulkExtraction};
					if (((22282 - 17808) >= (11 + 263)) and v90.SoulSigils:IsAvailable()) then
						local v189 = 0 - 0;
						while true do
							if ((v189 == (0 + 0)) or ((830 + 1064) <= (4172 - 2766))) then
								v28(v186, v90.SigilOfFlame);
								v28(v186, v90.SigilOfSilence);
								v189 = 1 + 0;
							end
							if (((2890 - 1318) >= (1013 + 518)) and (v189 == (1 + 0))) then
								v28(v186, v90.SigilOfChains);
								v28(v186, v90.ElysianDecree);
								break;
							end
						end
					end
					if (v90.Fallout:IsAvailable() or ((3368 + 1319) < (3814 + 728))) then
						v28(v186, v90.ImmolationAura);
					end
					for v187, v188 in pairs(v186) do
						if (((3220 + 71) > (2100 - (153 + 280))) and (v185 == v188:ID()) and (v188:TimeSinceLastCast() >= v14:GCD())) then
							v96 = 0 - 0;
							break;
						end
					end
				end
				if ((v96 > v94) or ((784 + 89) == (804 + 1230))) then
					v94 = v96;
				elseif ((v96 > (0 + 0)) or ((2556 + 260) < (8 + 3))) then
					v96 = 0 - 0;
				end
				break;
			end
			if (((2287 + 1412) < (5373 - (89 + 578))) and (v125 == (0 + 0))) then
				v94 = v14:BuffStack(v90.SoulFragments);
				if (((5500 - 2854) >= (1925 - (572 + 477))) and (v90.SpiritBomb:TimeSinceLastCast() < v14:GCD())) then
					v96 = 0 + 0;
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v108()
		if (((74 + 540) <= (3270 - (84 + 2))) and ((v90.Felblade:TimeSinceLastCast() < v14:GCD()) or (v90.InfernalStrike:TimeSinceLastCast() < v14:GCD()))) then
			local v167 = 0 - 0;
			while true do
				if (((2253 + 873) == (3968 - (497 + 345))) and (v167 == (1 + 0))) then
					return;
				end
				if (((0 + 0) == v167) or ((3520 - (605 + 728)) >= (3535 + 1419))) then
					v97 = true;
					v98 = true;
					v167 = 1 - 0;
				end
			end
		end
		v97 = v15:IsInMeleeRange(1 + 4);
		v98 = v97 or (v102 > (0 - 0));
	end
	local function v109(v126)
		return (v126:DebuffRemains(v90.FieryBrandDebuff));
	end
	local function v110(v127)
		return (v127:DebuffUp(v90.FieryBrandDebuff));
	end
	local function v111()
		v36 = v27.HandleTopTrinket(v93, v39, 37 + 3, nil);
		if (v36 or ((10741 - 6864) == (2700 + 875))) then
			return v36;
		end
		v36 = v27.HandleBottomTrinket(v93, v39, 529 - (457 + 32), nil);
		if (((300 + 407) > (2034 - (832 + 570))) and v36) then
			return v36;
		end
	end
	local function v112()
		if ((v47 and not v14:IsMoving() and v90.SigilOfFlame:IsCastable()) or ((515 + 31) >= (700 + 1984))) then
			if (((5184 - 3719) <= (2072 + 2229)) and ((v87 == "player") or v90.ConcentratedSigils:IsAvailable())) then
				if (((2500 - (588 + 208)) > (3840 - 2415)) and v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35))) then
					return "sigil_of_flame precombat 2";
				end
			elseif ((v87 == "cursor") or ((2487 - (884 + 916)) == (8863 - 4629))) then
				if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(18 + 12)) or ((3983 - (232 + 421)) < (3318 - (1569 + 320)))) then
					return "sigil_of_flame precombat 2";
				end
			end
		end
		if (((282 + 865) >= (64 + 271)) and v90.ImmolationAura:IsCastable() and v44) then
			if (((11575 - 8140) > (2702 - (316 + 289))) and v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35))) then
				return "immolation_aura precombat 4";
			end
		end
		if ((v90.InfernalStrike:IsCastable() and v45) or ((9868 - 6098) >= (187 + 3854))) then
			if (v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35)) or ((5244 - (666 + 787)) <= (2036 - (360 + 65)))) then
				return "infernal_strike precombat 6";
			end
		end
		if ((v90.Fracture:IsCastable() and v43 and v97) or ((4279 + 299) <= (2262 - (79 + 175)))) then
			if (((1773 - 648) <= (1620 + 456)) and v25(v90.Fracture)) then
				return "fracture precombat 8";
			end
		end
		if ((v90.Shear:IsCastable() and v46 and v97) or ((2277 - 1534) >= (8471 - 4072))) then
			if (((2054 - (503 + 396)) < (1854 - (92 + 89))) and v25(v90.Shear)) then
				return "shear precombat 10";
			end
		end
	end
	local function v113()
		if ((v90.DemonSpikes:IsCastable() and v66 and v14:BuffDown(v90.DemonSpikesBuff) and v14:BuffDown(v90.MetamorphosisBuff) and (((v102 == (1 - 0)) and v14:BuffDown(v90.FieryBrandDebuff)) or (v102 > (1 + 0)))) or ((1376 + 948) <= (2263 - 1685))) then
			if (((516 + 3251) == (8589 - 4822)) and (v90.DemonSpikes:ChargesFractional() > (1.9 + 0))) then
				if (((1954 + 2135) == (12453 - 8364)) and v25(v90.DemonSpikes)) then
					return "demon_spikes defensives (Capped)";
				end
			elseif (((557 + 3901) >= (2552 - 878)) and (v99 or (v14:HealthPercentage() <= v69))) then
				if (((2216 - (485 + 759)) <= (3280 - 1862)) and v25(v90.DemonSpikes)) then
					return "demon_spikes defensives (Danger)";
				end
			end
		end
		if ((v90.Metamorphosis:IsCastable() and v68 and (v14:HealthPercentage() <= v71) and (v14:BuffDown(v90.MetamorphosisBuff) or (v15:TimeToDie() < (1204 - (442 + 747))))) or ((6073 - (832 + 303)) < (5708 - (88 + 858)))) then
			if (v25(v92.MetamorphosisPlayer) or ((764 + 1740) > (3529 + 735))) then
				return "metamorphosis defensives";
			end
		end
		if (((89 + 2064) == (2942 - (766 + 23))) and v90.FieryBrand:IsCastable() and v67 and (v99 or (v14:HealthPercentage() <= v70))) then
			if (v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand)) or ((2502 - 1995) >= (3543 - 952))) then
				return "fiery_brand defensives";
			end
		end
		if (((11805 - 7324) == (15208 - 10727)) and v91.Healthstone:IsReady() and v83 and (v14:HealthPercentage() <= v85)) then
			if (v25(v92.Healthstone) or ((3401 - (1036 + 37)) < (492 + 201))) then
				return "healthstone defensive";
			end
		end
		if (((8427 - 4099) == (3405 + 923)) and v82 and (v14:HealthPercentage() <= v84)) then
			local v168 = 1480 - (641 + 839);
			while true do
				if (((2501 - (910 + 3)) >= (3395 - 2063)) and (v168 == (1684 - (1466 + 218)))) then
					if ((v86 == "Refreshing Healing Potion") or ((1919 + 2255) > (5396 - (556 + 592)))) then
						if (v91.RefreshingHealingPotion:IsReady() or ((1631 + 2955) <= (890 - (329 + 479)))) then
							if (((4717 - (174 + 680)) == (13273 - 9410)) and v25(v92.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v86 == "Dreamwalker's Healing Potion") or ((584 - 302) <= (30 + 12))) then
						if (((5348 - (396 + 343)) >= (68 + 698)) and v91.DreamwalkersHealingPotion:IsReady()) then
							if (v25(v92.RefreshingHealingPotion) or ((2629 - (29 + 1448)) == (3877 - (135 + 1254)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v114()
		if (((12891 - 9469) > (15641 - 12291)) and v90.SigilOfChains:IsCastable() and v54 and not v14:IsMoving() and v90.CycleofBinding:IsAvailable() and v90.SigilOfChains:IsAvailable()) then
			if (((585 + 292) > (1903 - (389 + 1138))) and ((v87 == "player") or v90.ConcentratedSigils:IsAvailable())) then
				if (v25(v92.SigilOfChainsPlayer, not v15:IsInMeleeRange(v35)) or ((3692 - (102 + 472)) <= (1747 + 104))) then
					return "sigil_of_chains player filler 2";
				end
			elseif ((v87 == "cursor") or ((92 + 73) >= (3257 + 235))) then
				if (((5494 - (320 + 1225)) < (8644 - 3788)) and v25(v92.SigilOfChainsCursor, not v15:IsInRange(19 + 11))) then
					return "sigil_of_chains cursor filler 2";
				end
			end
		end
		if ((v90.SigilOfMisery:IsCastable() and v55 and not v14:IsMoving() and v90.CycleofBinding:IsAvailable() and v90.SigilOfMisery:IsAvailable()) or ((5740 - (157 + 1307)) < (4875 - (821 + 1038)))) then
			if (((11701 - 7011) > (452 + 3673)) and ((v87 == "player") or v90.ConcentratedSigils:IsAvailable())) then
				if (v25(v92.SigilOfMiseryPlayer, not v15:IsInMeleeRange(v35)) or ((88 - 38) >= (334 + 562))) then
					return "sigil_of_misery player filler 4";
				end
			elseif ((v87 == "cursor") or ((4248 - 2534) >= (3984 - (834 + 192)))) then
				if (v25(v92.SigilOfMiseryCursor, not v15:IsInRange(2 + 28)) or ((383 + 1108) < (14 + 630))) then
					return "sigil_of_misery cursor filler 4";
				end
			end
		end
		if (((1090 - 386) < (1291 - (300 + 4))) and v90.SigilOfSilence:IsCastable() and v53 and not v14:IsMoving() and v90.CycleofBinding:IsAvailable() and v90.SigilOfSilence:IsAvailable()) then
			if (((993 + 2725) > (4989 - 3083)) and ((v87 == "player") or v90.ConcentratedSigils:IsAvailable())) then
				if (v25(v92.SigilOfSilencePlayer, not v15:IsInMeleeRange(v35)) or ((1320 - (112 + 250)) > (1450 + 2185))) then
					return "sigil_of_silence player filler 6";
				end
			elseif (((8770 - 5269) <= (2574 + 1918)) and (v87 == "cursor")) then
				if (v25(v92.SigilOfSilenceCursor, not v15:IsInRange(16 + 14)) or ((2575 + 867) < (1264 + 1284))) then
					return "sigil_of_silence cursor filler 6";
				end
			end
		end
		if (((2136 + 739) >= (2878 - (1001 + 413))) and v90.ThrowGlaive:IsCastable() and v50) then
			if (v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive)) or ((10697 - 5900) >= (5775 - (244 + 638)))) then
				return "throw_glaive filler 8";
			end
		end
	end
	local function v115()
		local v128 = 693 - (627 + 66);
		local v129;
		while true do
			if ((v128 == (2 - 1)) or ((1153 - (512 + 90)) > (3974 - (1665 + 241)))) then
				if (((2831 - (373 + 344)) > (426 + 518)) and v90.SoulCarver:IsCastable() and v58) then
					if (v25(v90.SoulCarver, not v97) or ((599 + 1663) >= (8166 - 5070))) then
						return "soul_carver big_aoe 10";
					end
				end
				if ((v90.SpiritBomb:IsReady() and (v94 >= (6 - 2)) and v49) or ((3354 - (35 + 1064)) >= (2574 + 963))) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((8209 - 4372) < (6 + 1300))) then
						return "spirit_bomb big_aoe 12";
					end
				end
				if (((4186 - (298 + 938)) == (4209 - (233 + 1026))) and v90.Fracture:IsCastable() and v43) then
					if (v25(v90.Fracture, not v97) or ((6389 - (636 + 1030)) < (1687 + 1611))) then
						return "fracture big_aoe 14";
					end
				end
				if (((1110 + 26) >= (46 + 108)) and v90.Shear:IsCastable() and v46) then
					if (v25(v90.Shear, not v97) or ((19 + 252) > (4969 - (55 + 166)))) then
						return "shear big_aoe 16";
					end
				end
				v128 = 1 + 1;
			end
			if (((477 + 4263) >= (12037 - 8885)) and (v128 == (299 - (36 + 261)))) then
				if ((v90.SoulCleave:IsReady() and (v94 < (1 - 0)) and v48) or ((3946 - (34 + 1334)) >= (1304 + 2086))) then
					if (((32 + 9) <= (2944 - (1035 + 248))) and v25(v90.SoulCleave, not v97)) then
						return "soul_cleave big_aoe 18";
					end
				end
				v129 = v114();
				if (((622 - (20 + 1)) < (1855 + 1705)) and v129) then
					return v129;
				end
				break;
			end
			if (((554 - (134 + 185)) < (1820 - (549 + 584))) and (v128 == (685 - (314 + 371)))) then
				if (((15616 - 11067) > (2121 - (478 + 490))) and v90.FelDevastation:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61) and (v90.CollectiveAnguish:IsAvailable() or v90.StoketheFlames:IsAvailable())) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((2476 + 2198) < (5844 - (786 + 386)))) then
						return "fel_devastation big_aoe 2";
					end
				end
				if (((11880 - 8212) < (5940 - (1055 + 324))) and v90.TheHunt:IsCastable() and (v79 < v105) and v59 and ((v39 and v63) or not v63)) then
					if (v25(v90.TheHunt, not v15:IsInRange(1390 - (1093 + 247))) or ((405 + 50) == (380 + 3225))) then
						return "the_hunt big_aoe 4";
					end
				end
				if ((v90.ElysianDecree:IsCastable() and (v79 < v105) and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v102 > v65)) or ((10572 - 7909) == (11239 - 7927))) then
					if (((12170 - 7893) <= (11245 - 6770)) and (v64 == "player")) then
						if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or ((310 + 560) == (4580 - 3391))) then
							return "elysian_decree big_aoe 6 (Player)";
						end
					elseif (((5352 - 3799) <= (2363 + 770)) and (v64 == "cursor")) then
						if (v25(v92.ElysianDecreeCursor, not v15:IsInRange(76 - 46)) or ((2925 - (364 + 324)) >= (9624 - 6113))) then
							return "elysian_decree big_aoe 6 (Cursor)";
						end
					end
				end
				if ((v90.FelDevastation:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61)) or ((3177 - 1853) > (1001 + 2019))) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((12519 - 9527) == (3012 - 1131))) then
						return "fel_devastation big_aoe 8";
					end
				end
				v128 = 2 - 1;
			end
		end
	end
	local function v116()
		if (((4374 - (1249 + 19)) > (1378 + 148)) and v90.ImmolationAura:IsCastable() and v44) then
			if (((11766 - 8743) < (4956 - (686 + 400))) and v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35))) then
				return "immolation_aura fiery_demise 2";
			end
		end
		if (((113 + 30) > (303 - (73 + 156))) and v90.SigilOfFlame:IsCastable() and v47 and not v14:IsMoving() and (v98 or not v90.ConcentratedSigils:IsAvailable()) and v15:DebuffRefreshable(v90.SigilOfFlameDebuff)) then
			if (((1 + 17) < (2923 - (721 + 90))) and (v90.ConcentratedSigils:IsAvailable() or (v87 == "player"))) then
				if (((13 + 1084) <= (5285 - 3657)) and v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35))) then
					return "sigil_of_flame fiery_demise 4 (Player)";
				end
			elseif (((5100 - (224 + 246)) == (7500 - 2870)) and (v87 == "cursor")) then
				if (((6517 - 2977) > (487 + 2196)) and v25(v92.SigilOfFlameCursor, not v15:IsInRange(1 + 29))) then
					return "sigil_of_flame fiery_demise 4 (Cursor)";
				end
			end
		end
		if (((3522 + 1272) >= (6511 - 3236)) and v90.Felblade:IsCastable() and v42 and (v90.FelDevastation:CooldownRemains() <= (v90.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (166 - 116))) then
			if (((1997 - (203 + 310)) == (3477 - (1238 + 755))) and v25(v90.Felblade, not v97)) then
				return "felblade fiery_demise 6";
			end
		end
		if (((101 + 1331) < (5089 - (709 + 825))) and v90.FelDevastation:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
			if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((1962 - 897) > (5211 - 1633))) then
				return "fel_devastation fiery_demise 8";
			end
		end
		if ((v90.SoulCarver:IsCastable() and v58) or ((5659 - (196 + 668)) < (5555 - 4148))) then
			if (((3838 - 1985) < (5646 - (171 + 662))) and v25(v90.SoulCarver, not v15:IsInMeleeRange(v35))) then
				return "soul_carver fiery_demise 10";
			end
		end
		if ((v90.SpiritBomb:IsReady() and (v102 == (94 - (4 + 89))) and (v94 >= (17 - 12)) and v49) or ((1028 + 1793) < (10677 - 8246))) then
			if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((1128 + 1746) < (3667 - (35 + 1451)))) then
				return "spirit_bomb fiery_demise 12";
			end
		end
		if ((v90.SpiritBomb:IsReady() and (v102 > (1454 - (28 + 1425))) and (v102 <= (1998 - (941 + 1052))) and (v94 >= (4 + 0)) and v49) or ((4203 - (822 + 692)) <= (488 - 145))) then
			if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((881 + 988) == (2306 - (45 + 252)))) then
				return "spirit_bomb fiery_demise 14";
			end
		end
		if ((v90.SpiritBomb:IsReady() and (v102 >= (6 + 0)) and (v94 >= (2 + 1)) and v49) or ((8629 - 5083) < (2755 - (114 + 319)))) then
			if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((2988 - 906) == (6115 - 1342))) then
				return "spirit_bomb fiery_demise 16";
			end
		end
		if (((2069 + 1175) > (1571 - 516)) and v90.TheHunt:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) then
			if (v25(v90.TheHunt, not v15:IsInRange(62 - 32)) or ((5276 - (556 + 1407)) <= (2984 - (741 + 465)))) then
				return "the_hunt fiery_demise 18";
			end
		end
		if ((v90.ElysianDecree:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or ((1886 - (170 + 295)) >= (1109 + 995))) then
			if (((1665 + 147) <= (7998 - 4749)) and (v64 == "player")) then
				if (((1346 + 277) <= (1256 + 701)) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
					return "elysian_decree fiery_demise 20 (Player)";
				end
			elseif (((2499 + 1913) == (5642 - (957 + 273))) and (v64 == "cursor")) then
				if (((469 + 1281) >= (338 + 504)) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(114 - 84))) then
					return "elysian_decree fiery_demise 20 (Cursor)";
				end
			end
		end
		if (((11521 - 7149) > (5650 - 3800)) and v90.SoulCleave:IsReady() and (v14:FuryDeficit() <= (148 - 118)) and not v103 and v48) then
			if (((2012 - (389 + 1391)) < (516 + 305)) and v25(v90.SoulCleave, not v97)) then
				return "soul_cleave fiery_demise 22";
			end
		end
	end
	local function v117()
		local v130 = 0 + 0;
		while true do
			if (((1179 - 661) < (1853 - (783 + 168))) and (v130 == (0 - 0))) then
				if (((2945 + 49) > (1169 - (309 + 2))) and v90.FieryBrand:IsCastable() and v67 and ((v15:DebuffDown(v90.FieryBrandDebuff) and ((v90.SigilOfFlame:CooldownRemains() < (v90.SigilOfFlame:ExecuteTime() + v14:GCDRemains())) or (v90.SoulCarver:CooldownRemains() < (v90.SoulCarver:ExecuteTime() + v14:GCDRemains())) or (v90.FelDevastation:CooldownRemains() < (v90.FelDevastation:ExecuteTime() + v14:GCDRemains())))) or (v90.DownInFlames:IsAvailable() and (v90.FieryBrand:FullRechargeTime() < (v90.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) then
					if (v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand)) or ((11531 - 7776) <= (2127 - (1090 + 122)))) then
						return "fiery_brand maintenance 2";
					end
				end
				if (((1280 + 2666) > (12570 - 8827)) and v90.SigilOfFlame:IsCastable() and not v14:IsMoving()) then
					if (v90.ConcentratedSigils:IsAvailable() or (v87 == "player") or ((914 + 421) >= (4424 - (628 + 490)))) then
						if (((869 + 3975) > (5578 - 3325)) and v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif (((2065 - 1613) == (1226 - (431 + 343))) and (v87 == "cursor")) then
						if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(60 - 30)) or ((13182 - 8625) < (1649 + 438))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v130 = 1 + 0;
			end
			if (((5569 - (556 + 1139)) == (3889 - (6 + 9))) and (v130 == (1 + 1))) then
				if ((v90.BulkExtraction:IsCastable() and v40 and v14:PrevGCD(1 + 0, v90.SpiritBomb)) or ((2107 - (28 + 141)) > (1912 + 3023))) then
					if (v25(v90.BulkExtraction, not v97) or ((5252 - 997) < (2425 + 998))) then
						return "bulk_extraction maintenance 10";
					end
				end
				if (((2771 - (486 + 831)) <= (6482 - 3991)) and v90.Felblade:IsCastable() and v42 and (v14:FuryDeficit() >= (140 - 100))) then
					if (v25(v90.Felblade, not v97) or ((786 + 3371) <= (8862 - 6059))) then
						return "felblade maintenance 12";
					end
				end
				v130 = 1266 - (668 + 595);
			end
			if (((4367 + 486) >= (602 + 2380)) and (v130 == (10 - 6))) then
				if (((4424 - (23 + 267)) > (5301 - (1129 + 815))) and v90.SpiritBomb:IsReady() and (v14:FuryDeficit() < (417 - (371 + 16))) and (((v102 >= (1752 - (1326 + 424))) and (v94 >= (9 - 4))) or ((v102 >= (21 - 15)) and (v94 >= (122 - (88 + 30))))) and not v103 and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((4188 - (720 + 51)) < (5636 - 3102))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if ((v90.SoulCleave:IsReady() and (v14:FuryDeficit() < (1806 - (421 + 1355))) and (v94 <= (4 - 1)) and not v103 and v48) or ((1338 + 1384) <= (1247 - (286 + 797)))) then
					if (v25(v90.SoulCleave, not v97) or ((8802 - 6394) < (3492 - 1383))) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if ((v130 == (442 - (397 + 42))) or ((11 + 22) == (2255 - (24 + 776)))) then
				if ((v90.Fracture:IsCastable() and v43 and (v90.FelDevastation:CooldownRemains() <= (v90.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (77 - 27))) or ((1228 - (222 + 563)) >= (8846 - 4831))) then
					if (((2435 + 947) > (356 - (23 + 167))) and v25(v90.Fracture, not v97)) then
						return "fracture maintenance 14";
					end
				end
				if ((v90.Shear:IsCastable() and v46 and (v90.FelDevastation:CooldownRemains() <= (v90.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1848 - (690 + 1108)))) or ((102 + 178) == (2524 + 535))) then
					if (((2729 - (40 + 808)) > (213 + 1080)) and v25(v90.Shear, not v97)) then
						return "shear maintenance 16";
					end
				end
				v130 = 15 - 11;
			end
			if (((2253 + 104) == (1247 + 1110)) and (v130 == (1 + 0))) then
				if (((694 - (47 + 524)) == (80 + 43)) and v90.SpiritBomb:IsReady() and (v94 >= (13 - 8)) and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((1578 - 522) >= (7735 - 4343))) then
						return "spirit_bomb maintenance 6";
					end
				end
				if ((v90.ImmolationAura:IsCastable() and v44) or ((2807 - (1165 + 561)) < (32 + 1043))) then
					if (v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35)) or ((3248 - 2199) >= (1692 + 2740))) then
						return "immolation_aura maintenance 8";
					end
				end
				v130 = 481 - (341 + 138);
			end
		end
	end
	local function v118()
		if ((v90.TheHunt:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) or ((1288 + 3480) <= (1745 - 899))) then
			if (v25(v90.TheHunt, not v15:IsInRange(356 - (89 + 237))) or ((10802 - 7444) <= (2989 - 1569))) then
				return "the_hunt single_target 2";
			end
		end
		if ((v90.SoulCarver:IsCastable() and v58) or ((4620 - (581 + 300)) <= (4225 - (855 + 365)))) then
			if (v25(v90.SoulCarver, not v97) or ((3940 - 2281) >= (697 + 1437))) then
				return "soul_carver single_target 4";
			end
		end
		if ((v90.FelDevastation:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90.CollectiveAnguish:IsAvailable() or (v90.StoketheFlames:IsAvailable() and v90.BurningBlood:IsAvailable()))) or ((4495 - (1030 + 205)) < (2211 + 144))) then
			if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((623 + 46) == (4509 - (156 + 130)))) then
				return "fel_devastation single_target 6";
			end
		end
		if ((v90.ElysianDecree:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or ((3844 - 2152) < (990 - 402))) then
			if ((v64 == "player") or ((9824 - 5027) < (963 + 2688))) then
				if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or ((2436 + 1741) > (4919 - (10 + 59)))) then
					return "elysian_decree single_target 8 (Player)";
				end
			elseif ((v64 == "cursor") or ((114 + 286) > (5471 - 4360))) then
				if (((4214 - (671 + 492)) > (801 + 204)) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(1245 - (369 + 846)))) then
					return "elysian_decree single_target 8 (Cursor)";
				end
			end
		end
		if (((978 + 2715) <= (3740 + 642)) and v90.FelDevastation:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
			if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((5227 - (1036 + 909)) > (3260 + 840))) then
				return "fel_devastation single_target 10";
			end
		end
		if ((v90.SoulCleave:IsReady() and v90.FocusedCleave:IsAvailable() and not v103 and v48) or ((6010 - 2430) < (3047 - (11 + 192)))) then
			if (((45 + 44) < (4665 - (135 + 40))) and v25(v90.SoulCleave, not v97)) then
				return "soul_cleave single_target 12";
			end
		end
		if ((v90.Fracture:IsCastable() and v43) or ((12072 - 7089) < (1090 + 718))) then
			if (((8435 - 4606) > (5649 - 1880)) and v25(v90.Fracture, not v97)) then
				return "fracture single_target 14";
			end
		end
		if (((1661 - (50 + 126)) <= (8086 - 5182)) and v90.Shear:IsCastable() and v46) then
			if (((945 + 3324) == (5682 - (1233 + 180))) and v25(v90.Shear, not v97)) then
				return "shear single_target 16";
			end
		end
		if (((1356 - (522 + 447)) <= (4203 - (107 + 1314))) and v90.SoulCleave:IsReady() and not v103 and v48) then
			if (v25(v90.SoulCleave, not v97) or ((882 + 1017) <= (2794 - 1877))) then
				return "soul_cleave single_target 18";
			end
		end
		local v131 = v114();
		if (v131 or ((1832 + 2480) <= (1739 - 863))) then
			return v131;
		end
	end
	local function v119()
		if (((8831 - 6599) <= (4506 - (716 + 1194))) and v90.TheHunt:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) then
			if (((36 + 2059) < (395 + 3291)) and v25(v90.TheHunt, not v15:IsInRange(533 - (74 + 429)))) then
				return "the_hunt small_aoe 2";
			end
		end
		if ((v90.FelDevastation:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90.CollectiveAnguish:IsAvailable() or (v90.StoketheFlames:IsAvailable() and v90.BurningBlood:IsAvailable()))) or ((3076 - 1481) >= (2218 + 2256))) then
			if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or ((10572 - 5953) < (2039 + 843))) then
				return "fel_devastation small_aoe 4";
			end
		end
		if ((v90.ElysianDecree:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or ((906 - 612) >= (11944 - 7113))) then
			if (((2462 - (279 + 154)) <= (3862 - (454 + 324))) and (v64 == "player")) then
				if (v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35)) or ((1603 + 434) == (2437 - (12 + 5)))) then
					return "elysian_decree small_aoe 6 (Player)";
				end
			elseif (((2404 + 2054) > (9947 - 6043)) and (v64 == "cursor")) then
				if (((162 + 274) >= (1216 - (277 + 816))) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(128 - 98))) then
					return "elysian_decree small_aoe 6 (Cursor)";
				end
			end
		end
		if (((1683 - (1058 + 125)) < (341 + 1475)) and v90.FelDevastation:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
			if (((4549 - (815 + 160)) == (15334 - 11760)) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
				return "fel_devastation small_aoe 8";
			end
		end
		if (((524 - 303) < (94 + 296)) and v90.SoulCarver:IsCastable() and v58) then
			if (v25(v90.SoulCarver, not v97) or ((6468 - 4255) <= (3319 - (41 + 1857)))) then
				return "soul_carver small_aoe 10";
			end
		end
		if (((4951 - (1222 + 671)) < (12561 - 7701)) and v90.SpiritBomb:IsReady() and (v94 >= (6 - 1)) and v49) then
			if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or ((2478 - (229 + 953)) >= (6220 - (1111 + 663)))) then
				return "spirit_bomb small_aoe 12";
			end
		end
		if ((v90.SoulCleave:IsReady() and v90.FocusedCleave:IsAvailable() and (v94 <= (1581 - (874 + 705))) and v48) or ((195 + 1198) > (3063 + 1426))) then
			if (v25(v90.SoulCleave, not v97) or ((9195 - 4771) < (1 + 26))) then
				return "soul_cleave small_aoe 14";
			end
		end
		if ((v90.Fracture:IsCastable() and v43) or ((2676 - (642 + 37)) > (870 + 2945))) then
			if (((555 + 2910) > (4802 - 2889)) and v25(v90.Fracture, not v97)) then
				return "fracture small_aoe 16";
			end
		end
		if (((1187 - (233 + 221)) < (4206 - 2387)) and v90.Shear:IsCastable() and v46) then
			if (v25(v90.Shear, not v97) or ((3869 + 526) == (6296 - (718 + 823)))) then
				return "shear small_aoe 18";
			end
		end
		if ((v90.SoulCleave:IsReady() and (v94 <= (2 + 0)) and v48) or ((4598 - (266 + 539)) < (6706 - 4337))) then
			if (v25(v90.SoulCleave, not v97) or ((5309 - (636 + 589)) == (629 - 364))) then
				return "soul_cleave small_aoe 20";
			end
		end
		local v132 = v114();
		if (((8988 - 4630) == (3454 + 904)) and v132) then
			return v132;
		end
	end
	local function v120()
		v40 = EpicSettings.Settings['useBulkExtraction'];
		v41 = EpicSettings.Settings['useConsumeMagic'];
		v42 = EpicSettings.Settings['useFelblade'];
		v43 = EpicSettings.Settings['useFracture'];
		v44 = EpicSettings.Settings['useImmolationAura'];
		v45 = EpicSettings.Settings['useInfernalStrike'];
		v46 = EpicSettings.Settings['useShear'];
		v47 = EpicSettings.Settings['useSigilOfFlame'];
		v48 = EpicSettings.Settings['useSoulCleave'];
		v49 = EpicSettings.Settings['useSpiritBomb'];
		v50 = EpicSettings.Settings['useThrowGlaive'];
		v51 = EpicSettings.Settings['useChaosNova'];
		v52 = EpicSettings.Settings['useDisrupt'];
		v53 = EpicSettings.Settings['useSigilOfSilence'];
		v54 = EpicSettings.Settings['useSigilOfChains'];
		v55 = EpicSettings.Settings['useSigilOfMisery'];
		v56 = EpicSettings.Settings['useElysianDecree'];
		v57 = EpicSettings.Settings['useFelDevastation'];
		v58 = EpicSettings.Settings['useSoulCarver'];
		v59 = EpicSettings.Settings['useTheHunt'];
		v60 = EpicSettings.Settings['elysianDecreeWithCD'];
		v61 = EpicSettings.Settings['felDevastationWithCD'];
		v62 = EpicSettings.Settings['soulCarverWithCD'];
		v63 = EpicSettings.Settings['theHuntWithCD'];
		v66 = EpicSettings.Settings['useDemonSpikes'];
		v67 = EpicSettings.Settings['useFieryBrand'];
		v68 = EpicSettings.Settings['useMetamorphosis'];
		v69 = EpicSettings.Settings['demonSpikesHP'] or (0 + 0);
		v70 = EpicSettings.Settings['fieryBrandHP'] or (1015 - (657 + 358));
		v71 = EpicSettings.Settings['metamorphosisHP'] or (0 - 0);
		v87 = EpicSettings.Settings['sigilSetting'] or "player";
		v64 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v65 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
		v88 = EpicSettings.Settings['fieryBrandOffensively'];
		v89 = EpicSettings.Settings['metamorphosisOffensively'];
	end
	local function v121()
		local v162 = 1187 - (1151 + 36);
		while true do
			if ((v162 == (0 + 0)) or ((825 + 2313) < (2965 - 1972))) then
				v79 = EpicSettings.Settings['fightRemainsCheck'] or (1832 - (1552 + 280));
				v72 = EpicSettings.Settings['dispelBuffs'];
				v76 = EpicSettings.Settings['InterruptWithStun'];
				v162 = 835 - (64 + 770);
			end
			if (((2261 + 1069) > (5273 - 2950)) and (v162 == (1 + 1))) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v82 = EpicSettings.Settings['useHealingPotion'];
				v162 = 1246 - (157 + 1086);
			end
			if ((v162 == (5 - 2)) or ((15880 - 12254) == (6118 - 2129))) then
				v85 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (819 - (599 + 220));
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v162 = 7 - 3;
			end
			if ((v162 == (1935 - (1813 + 118))) or ((670 + 246) == (3888 - (841 + 376)))) then
				v75 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((380 - 108) == (64 + 208)) and (v162 == (2 - 1))) then
				v77 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v78 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v162 = 861 - (464 + 395);
			end
		end
	end
	local function v122()
		v120();
		v121();
		v37 = EpicSettings.Toggles['ooc'];
		v38 = EpicSettings.Toggles['aoe'];
		v39 = EpicSettings.Toggles['cds'];
		if (((10904 - 6655) <= (2324 + 2515)) and v14:IsDeadOrGhost()) then
			return;
		end
		if (((3614 - (467 + 370)) < (6612 - 3412)) and v90.ImprovedDisrupt:IsAvailable()) then
			v35 = 8 + 2;
		end
		v101 = v14:GetEnemiesInMeleeRange(v35);
		if (((325 - 230) < (306 + 1651)) and v38) then
			v102 = #v101;
		else
			v102 = 2 - 1;
		end
		v107();
		v108();
		v99 = v14:ActiveMitigationNeeded();
		v100 = v14:IsTankingAoE(528 - (150 + 370)) or v14:IsTanking(v15);
		if (((2108 - (74 + 1208)) < (4222 - 2505)) and (v27.TargetIsValid() or v14:AffectingCombat())) then
			local v169 = 0 - 0;
			while true do
				if (((1015 + 411) >= (1495 - (14 + 376))) and ((0 - 0) == v169)) then
					v104 = v10.BossFightRemains(nil, true);
					v105 = v104;
					v169 = 1 + 0;
				end
				if (((2420 + 334) <= (3223 + 156)) and (v169 == (2 - 1))) then
					if ((v105 == (8359 + 2752)) or ((4005 - (23 + 55)) == (3348 - 1935))) then
						v105 = v10.FightRemains(v101, false);
					end
					break;
				end
			end
		end
		if (v75 or ((771 + 383) <= (708 + 80))) then
			local v170 = 0 - 0;
			while true do
				if (((0 + 0) == v170) or ((2544 - (652 + 249)) > (9042 - 5663))) then
					v36 = v27.HandleIncorporeal(v90.Imprison, v92.ImprisonMouseover, 1888 - (708 + 1160));
					if (v36 or ((7608 - 4805) > (8293 - 3744))) then
						return v36;
					end
					break;
				end
			end
		end
		if ((v27.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((247 - (10 + 17)) >= (679 + 2343))) then
			local v171 = 1732 - (1400 + 332);
			local v172;
			local v173;
			while true do
				if (((5412 - 2590) == (4730 - (242 + 1666))) and (v171 == (2 + 2))) then
					if ((v102 >= (3 + 3)) or ((905 + 156) == (2797 - (850 + 90)))) then
						local v190 = 0 - 0;
						local v191;
						while true do
							if (((4150 - (360 + 1030)) > (1208 + 156)) and (v190 == (0 - 0))) then
								v191 = v115();
								if (v191 or ((6743 - 1841) <= (5256 - (909 + 752)))) then
									return v191;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v171 == (1226 - (109 + 1114))) or ((7051 - 3199) == (115 + 178))) then
					v173 = v117();
					if (v173 or ((1801 - (6 + 236)) == (2891 + 1697))) then
						return v173;
					end
					if ((v102 <= (1 + 0)) or ((10574 - 6090) == (1375 - 587))) then
						local v192 = 1133 - (1076 + 57);
						local v193;
						while true do
							if (((752 + 3816) >= (4596 - (579 + 110))) and (v192 == (0 + 0))) then
								v193 = v118();
								if (((1102 + 144) < (1842 + 1628)) and v193) then
									return v193;
								end
								break;
							end
						end
					end
					if (((4475 - (174 + 233)) >= (2714 - 1742)) and (v102 > (1 - 0)) and (v102 <= (3 + 2))) then
						local v194 = 1174 - (663 + 511);
						local v195;
						while true do
							if (((440 + 53) < (846 + 3047)) and ((0 - 0) == v194)) then
								v195 = v119();
								if (v195 or ((892 + 581) >= (7844 - 4512))) then
									return v195;
								end
								break;
							end
						end
					end
					v171 = 9 - 5;
				end
				if ((v171 == (0 + 0)) or ((7884 - 3833) <= (825 + 332))) then
					v103 = (v90.FelDevastation:CooldownRemains() < (v90.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (5 + 45));
					if (((1326 - (478 + 244)) < (3398 - (440 + 77))) and v90.ThrowGlaive:IsCastable() and v50 and v12.ValueIsInArray(v106, v15:NPCID())) then
						if (v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive)) or ((410 + 490) == (12360 - 8983))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if (((6015 - (655 + 901)) > (110 + 481)) and v90.ThrowGlaive:IsReady() and v50 and v12.ValueIsInArray(v106, v16:NPCID())) then
						if (((2602 + 796) >= (1618 + 777)) and v25(v92.ThrowGlaiveMouseover, not v15:IsSpellInRange(v90.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					if ((not v14:AffectingCombat() and v37) or ((8794 - 6611) >= (4269 - (695 + 750)))) then
						v173 = v112();
						if (((6610 - 4674) == (2987 - 1051)) and v173) then
							return v173;
						end
					end
					v171 = 3 - 2;
				end
				if ((v171 == (352 - (285 + 66))) or ((11263 - 6431) < (5623 - (682 + 628)))) then
					if (((659 + 3429) > (4173 - (176 + 123))) and v90.ConsumeMagic:IsAvailable() and v41 and v90.ConsumeMagic:IsReady() and v72 and not v14:IsCasting() and not v14:IsChanneling() and v27.UnitHasMagicBuff(v15)) then
						if (((1813 + 2519) == (3143 + 1189)) and v25(v90.ConsumeMagic, not v15:IsSpellInRange(v90.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((4268 - (239 + 30)) >= (789 + 2111)) and v100) then
						v173 = v113();
						if (v173 or ((2427 + 98) > (7192 - 3128))) then
							return v173;
						end
					end
					if (((13636 - 9265) == (4686 - (306 + 9))) and v90.InfernalStrike:IsCastable() and (v45 or (v90.InfernalStrike:ChargesFractional() > (3.9 - 2))) and (v90.InfernalStrike:TimeSinceLastCast() > (1 + 1))) then
						if (v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35)) or ((164 + 102) > (2400 + 2586))) then
							return "infernal_strike main 2";
						end
					end
					if (((5693 - 3702) >= (2300 - (1140 + 235))) and (v79 < v105) and v90.Metamorphosis:IsCastable() and v68 and v89 and v14:BuffDown(v90.MetamorphosisBuff) and v15:DebuffDown(v90.FieryBrandDebuff)) then
						if (((290 + 165) < (1883 + 170)) and v25(v92.MetamorphosisPlayer, not v97)) then
							return "metamorphosis main 4";
						end
					end
					v171 = 1 + 1;
				end
				if (((54 - (33 + 19)) == v171) or ((299 + 527) == (14539 - 9688))) then
					v172 = v27.HandleDPSPotion();
					if (((81 + 102) == (358 - 175)) and v172) then
						return v172;
					end
					if (((1087 + 72) <= (2477 - (586 + 103))) and (v79 < v105)) then
						if ((v80 and ((v39 and v81) or not v81)) or ((320 + 3187) > (13293 - 8975))) then
							local v197 = 1488 - (1309 + 179);
							while true do
								if ((v197 == (0 - 0)) or ((1339 + 1736) <= (7962 - 4997))) then
									v173 = v111();
									if (((1032 + 333) <= (4272 - 2261)) and v173) then
										return v173;
									end
									break;
								end
							end
						end
					end
					if ((v90.FieryDemise:IsAvailable() and (v90.FieryBrandDebuff:AuraActiveCount() > (1 - 0))) or ((3385 - (295 + 314)) > (8780 - 5205))) then
						local v196 = v116();
						if (v196 or ((4516 - (1300 + 662)) == (15085 - 10281))) then
							return v196;
						end
					end
					v171 = 1758 - (1178 + 577);
				end
			end
		end
	end
	local function v123()
		v20.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v90.FieryBrandDebuff:RegisterAuraTracking();
	end
	v20.SetAPL(302 + 279, v122, v123);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

