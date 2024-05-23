local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4476 - (221 + 925)) > (1701 - (1019 + 26))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DemonHunter_Vengeance.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.MouseOver;
	local v16 = v9.Spell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Press;
	local v20 = v18.Macro;
	local v21 = v18.Commons.Everyone;
	local v22 = v9.Utils.MergeTableByKey;
	local v23 = v21.num;
	local v24 = v21.bool;
	local v25 = GetTime;
	local v26 = math.max;
	local v27 = math.min;
	local v28;
	local v29 = false;
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
	local v81;
	local v82;
	local v83 = v16.DemonHunter.Vengeance;
	local v84 = v17.DemonHunter.Vengeance;
	local v85 = v20.DemonHunter.Vengeance;
	local v86 = {};
	local v87, v88, v89;
	local v90 = ((v83.SoulSigils:IsAvailable()) and (4 + 0)) or (2 + 1);
	local v91, v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97, v98, v99, v100, v101, v102, v103;
	local v104 = 23688 - 12577;
	local v105 = 11536 - (360 + 65);
	local v106 = {(169675 - (79 + 175)),(132210 + 37215),(325338 - 156406),(169607 - (92 + 89)),(86891 + 82538),(663504 - 494076),(386322 - 216892)};
	v9:RegisterForEvent(function()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (0 + 0)) or ((7589 - 5097) <= (42 + 293))) then
				v104 = 16944 - 5833;
				v105 = 12355 - (485 + 759);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v90 = ((v83.SoulSigils:IsAvailable()) and (8 - 4)) or (1192 - (442 + 747));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v107 = {};
	local v108 = v107;
	v108.AuraSouls = 1135 - (832 + 303);
	v108.IncomingSouls = 946 - (88 + 858);
	v9:RegisterForSelfCombatEvent(function(...)
		local v126 = 0 + 0;
		local v127;
		local v128;
		while true do
			if (((3577 + 745) >= (106 + 2456)) and (v126 == (790 - (766 + 23)))) then
				if ((v127 == v83.Fracture:ID()) or (v127 == v83.Shear:ID()) or ((17954 - 14317) >= (5156 - 1386))) then
					v128 = 4 - 2;
				elseif ((v127 == v83.SoulCarver:ID()) or ((8074 - 5695) > (5651 - (1036 + 37)))) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (0 - 0)) or ((380 + 103) > (2223 - (641 + 839)))) then
							v128 = 916 - (910 + 3);
							C_Timer.After(2 - 1, function()
								v108.IncomingSouls = v108.IncomingSouls + (1685 - (1466 + 218));
							end);
							v214 = 1 + 0;
						end
						if (((3602 - (556 + 592)) > (206 + 372)) and ((809 - (329 + 479)) == v214)) then
							C_Timer.After(856 - (174 + 680), function()
								v108.IncomingSouls = v108.IncomingSouls + (3 - 2);
							end);
							C_Timer.After(5 - 2, function()
								v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
							end);
							break;
						end
					end
				elseif (((1669 - (396 + 343)) < (395 + 4063)) and (v127 == v83.ElysianDecree:ID())) then
					v128 = ((v83.SoulSigils:IsAvailable()) and (1481 - (29 + 1448))) or (1392 - (135 + 1254));
				elseif (((2493 - 1831) <= (4538 - 3566)) and v83.SoulSigils:IsAvailable() and ((v127 == v83.SigilOfFlame:ID()) or (v127 == v83.SigilOfMisery:ID()) or (v127 == v83.SigilOfChains:ID()) or (v127 == v83.SigilOfSilence:ID()))) then
					v128 = 1 + 0;
				else
					v128 = 1527 - (389 + 1138);
				end
				if (((4944 - (102 + 472)) == (4124 + 246)) and (v128 > (0 + 0))) then
					v108.IncomingSouls = v108.IncomingSouls + v128;
				end
				break;
			end
			if ((v126 == (0 + 0)) or ((6307 - (320 + 1225)) <= (1532 - 671))) then
				v127 = select(8 + 4, ...);
				v128 = 1464 - (157 + 1307);
				v126 = 1860 - (821 + 1038);
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v9:RegisterForSelfCombatEvent(function(...)
		local v129 = select(29 - 17, ...);
		if ((v129 == (46553 + 379119)) or ((2507 - 1095) == (1587 + 2677))) then
			v108.IncomingSouls = v108.IncomingSouls + (2 - 1);
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v130 = 1026 - (834 + 192);
		local v131;
		while true do
			if ((v130 == (0 + 0)) or ((814 + 2354) < (47 + 2106))) then
				v131 = select(17 - 5, ...);
				if ((v131 == (204285 - (300 + 4))) or ((1329 + 3647) < (3486 - 2154))) then
					v108.AuraSouls = 363 - (112 + 250);
					v108.IncomingSouls = v26(0 + 0, v108.IncomingSouls - (2 - 1));
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v132, v133, v133, v133, v134 = select(7 + 5, ...);
		if (((2394 + 2234) == (3462 + 1166)) and (v132 == (101141 + 102840))) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (1414 - (1001 + 413))) or ((120 - 66) == (1277 - (244 + 638)))) then
					v108.AuraSouls = v134;
					v108.IncomingSouls = v26(693 - (627 + 66), v108.IncomingSouls - v134);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v135 = 0 - 0;
		local v136;
		local v137;
		local v138;
		while true do
			if (((684 - (512 + 90)) == (1988 - (1665 + 241))) and (v135 == (717 - (373 + 344)))) then
				v136, v137, v137, v137, v138 = select(6 + 6, ...);
				if ((v136 == (53972 + 150009)) or ((1532 - 951) < (476 - 194))) then
					v108.AuraSouls = v138;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v139 = 1099 - (35 + 1064);
		local v140;
		local v141;
		local v142;
		while true do
			if ((v139 == (0 + 0)) or ((9860 - 5251) < (10 + 2485))) then
				v140, v141, v141, v141, v142 = select(1248 - (298 + 938), ...);
				if (((2411 - (233 + 1026)) == (2818 - (636 + 1030))) and (v140 == (104289 + 99692))) then
					v108.AuraSouls = 0 + 0;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	local function v111()
		local v143 = 0 + 0;
		while true do
			if (((129 + 1767) <= (3643 - (55 + 166))) and ((1 + 0) == v143)) then
				v92 = v91 or (v96 > (0 + 0));
				break;
			end
			if ((v143 == (0 - 0)) or ((1287 - (36 + 261)) > (2833 - 1213))) then
				if ((v83.Felblade:TimeSinceLastCast() < v13:GCD()) or (v83.InfernalStrike:TimeSinceLastCast() < v13:GCD()) or ((2245 - (34 + 1334)) > (1805 + 2890))) then
					local v209 = 0 + 0;
					while true do
						if (((3974 - (1035 + 248)) >= (1872 - (20 + 1))) and (v209 == (1 + 0))) then
							return;
						end
						if ((v209 == (319 - (134 + 185))) or ((4118 - (549 + 584)) >= (5541 - (314 + 371)))) then
							v91 = true;
							v92 = true;
							v209 = 3 - 2;
						end
					end
				end
				v91 = v14:IsInMeleeRange(973 - (478 + 490));
				v143 = 1 + 0;
			end
		end
	end
	local function v112()
		v28 = v21.HandleTopTrinket(v86, v31, 1212 - (786 + 386), nil);
		if (((13849 - 9573) >= (2574 - (1055 + 324))) and v28) then
			return v28;
		end
		v28 = v21.HandleBottomTrinket(v86, v31, 1380 - (1093 + 247), nil);
		if (((2873 + 359) <= (494 + 4196)) and v28) then
			return v28;
		end
	end
	local function v113()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (6 - 4)) or ((2549 - 1653) >= (7905 - 4759))) then
				if (((1089 + 1972) >= (11395 - 8437)) and v83.Shear:IsCastable() and v39 and v91) then
					if (((10984 - 7797) >= (486 + 158)) and v19(v83.Shear)) then
						return "shear precombat 10";
					end
				end
				break;
			end
			if (((1646 - 1002) <= (1392 - (364 + 324))) and ((0 - 0) == v144)) then
				if (((2298 - 1340) > (314 + 633)) and v40 and ((not v32 and v82) or not v82) and not v13:IsMoving() and v83.SigilOfFlame:IsCastable()) then
					if (((18795 - 14303) >= (4249 - 1595)) and ((v78 == "player") or v83.ConcentratedSigils:IsAvailable())) then
						if (((10453 - 7011) >= (2771 - (1249 + 19))) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(8 + 0))) then
							return "sigil_of_flame precombat 2";
						end
					elseif ((v78 == "cursor") or ((12339 - 9169) <= (2550 - (686 + 400)))) then
						if (v19(v85.SigilOfFlameCursor, not v14:IsInRange(24 + 6)) or ((5026 - (73 + 156)) == (21 + 4367))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if (((1362 - (721 + 90)) <= (8 + 673)) and v83.ImmolationAura:IsCastable() and v37) then
					if (((10639 - 7362) > (877 - (224 + 246))) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(12 - 4))) then
						return "immolation_aura precombat 4";
					end
				end
				v144 = 1 - 0;
			end
			if (((852 + 3843) >= (34 + 1381)) and (v144 == (1 + 0))) then
				if ((v83.InfernalStrike:IsCastable() and v38 and ((not v32 and v81) or not v81) and (v83.InfernalStrike:ChargesFractional() > (1.7 - 0))) or ((10688 - 7476) <= (1457 - (203 + 310)))) then
					if (v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(2001 - (1238 + 755))) or ((217 + 2879) <= (3332 - (709 + 825)))) then
						return "infernal_strike precombat 6";
					end
				end
				if (((6517 - 2980) == (5152 - 1615)) and v83.Fracture:IsCastable() and v36 and v91) then
					if (((4701 - (196 + 668)) >= (6198 - 4628)) and v19(v83.Fracture)) then
						return "fracture precombat 8";
					end
				end
				v144 = 3 - 1;
			end
		end
	end
	local function v114()
		if ((v83.DemonSpikes:IsCastable() and v59 and v13:BuffDown(v83.DemonSpikesBuff) and v13:BuffDown(v83.MetamorphosisBuff) and (((v96 == (834 - (171 + 662))) and v13:BuffDown(v83.FieryBrandDebuff)) or (v96 > (94 - (4 + 89))))) or ((10339 - 7389) == (1389 + 2423))) then
			if (((20744 - 16021) >= (910 + 1408)) and (v83.DemonSpikes:ChargesFractional() > (1487.9 - (35 + 1451)))) then
				if (v19(v83.DemonSpikes) or ((3480 - (28 + 1425)) > (4845 - (941 + 1052)))) then
					return "demon_spikes defensives (Capped)";
				end
			elseif (v93 or (v13:HealthPercentage() <= v62) or ((1090 + 46) > (5831 - (822 + 692)))) then
				if (((6778 - 2030) == (2237 + 2511)) and v19(v83.DemonSpikes)) then
					return "demon_spikes defensives (Danger)";
				end
			end
		end
		if (((4033 - (45 + 252)) <= (4690 + 50)) and v83.Metamorphosis:IsCastable() and v61 and (v13:HealthPercentage() <= v64) and (v13:BuffDown(v83.MetamorphosisBuff) or (v14:TimeToDie() < (6 + 9)))) then
			if (v19(v85.MetamorphosisPlayer) or ((8250 - 4860) <= (3493 - (114 + 319)))) then
				return "metamorphosis defensives";
			end
		end
		if ((v83.FieryBrand:IsCastable() and v60 and (v14:TimeToDie() > v70) and (v93 or (v13:HealthPercentage() <= v63))) or ((1433 - 434) > (3450 - 757))) then
			if (((296 + 167) < (895 - 294)) and v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand))) then
				return "fiery_brand defensives";
			end
		end
		if ((v84.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v76)) or ((4573 - 2390) < (2650 - (556 + 1407)))) then
			if (((5755 - (741 + 465)) == (5014 - (170 + 295))) and v19(v85.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((2462 + 2210) == (4292 + 380)) and v73 and (v13:HealthPercentage() <= v75)) then
			if ((v77 == "Refreshing Healing Potion") or ((9030 - 5362) < (328 + 67))) then
				if (v84.RefreshingHealingPotion:IsReady() or ((2672 + 1494) == (258 + 197))) then
					if (v19(v85.RefreshingHealingPotion) or ((5679 - (957 + 273)) == (713 + 1950))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v77 == "Dreamwalker's Healing Potion") or ((1713 + 2564) < (11389 - 8400))) then
				if (v84.DreamwalkersHealingPotion:IsReady() or ((2292 - 1422) >= (12672 - 8523))) then
					if (((10953 - 8741) < (4963 - (389 + 1391))) and v19(v85.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
			if (((2915 + 1731) > (312 + 2680)) and (v77 == "Potion of Withering Dreams")) then
				if (((3264 - 1830) < (4057 - (783 + 168))) and v84.PotionOfWitheringDreams:IsReady()) then
					if (((2637 - 1851) < (2974 + 49)) and v19(v85.RefreshingHealingPotion)) then
						return "potion of withering dreams defensive";
					end
				end
			end
		end
	end
	local function v115()
		local v145 = 311 - (309 + 2);
		while true do
			if (((0 - 0) == v145) or ((3654 - (1090 + 122)) < (24 + 50))) then
				if (((15230 - 10695) == (3104 + 1431)) and v60 and v79 and (v14:TimeToDie() > v70) and v83.FieryBrand:IsCastable() and (((v83.FieryBrandDebuff:AuraActiveCount() == (1118 - (628 + 490))) and ((v83.SigilOfFlame:CooldownRemains() <= (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.SoulCarver:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.FelDevastation:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())))) or (v83.DownInFlames:IsAvailable() and (v83.FieryBrand:FullRechargeTime() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains()))))) then
					if (v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand)) or ((540 + 2469) <= (5211 - 3106))) then
						return "fiery_brand maintenance 2";
					end
				end
				if (((8363 - 6533) < (4443 - (431 + 343))) and v40 and v83.SigilOfFlame:IsCastable() and ((not v32 and v82) or not v82) and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) then
					if (v83.ConcentratedSigils:IsAvailable() or (v78 == "player") or ((4136 - 2706) >= (2854 + 758))) then
						if (((344 + 2339) >= (4155 - (556 + 1139))) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(23 - (6 + 9)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v78 == "cursor") or ((331 + 1473) >= (1678 + 1597))) then
						if (v19(v85.SigilOfFlameCursor, not v14:IsInRange(199 - (28 + 141))) or ((549 + 868) > (4478 - 849))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				if (((3397 + 1398) > (1719 - (486 + 831))) and v37 and v83.ImmolationAura:IsCastable()) then
					if (((12524 - 7711) > (12551 - 8986)) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(2 + 6))) then
						return "immolation_aura maintenance 6";
					end
				end
				v145 = 3 - 2;
			end
			if (((5175 - (668 + 595)) == (3521 + 391)) and ((1 + 1) == v145)) then
				if (((7693 - 4872) <= (5114 - (23 + 267))) and v35 and v83.Felblade:IsReady() and (((not v83.SpiritBomb:IsAvailable() or (v96 == (1945 - (1129 + 815)))) and (v13:FuryDeficit() >= (427 - (371 + 16)))) or ((v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (1800 - (1326 + 424)))))) then
					if (((3291 - 1553) <= (8021 - 5826)) and v19(v83.Felblade, not v91)) then
						return "felblade maintenance 12";
					end
				end
				if (((159 - (88 + 30)) <= (3789 - (720 + 51))) and v36 and v83.Fracture:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (111 - 61))) then
					if (((3921 - (421 + 1355)) <= (6770 - 2666)) and v19(v83.Fracture, not v91)) then
						return "fracture maintenance 14";
					end
				end
				if (((1321 + 1368) < (5928 - (286 + 797))) and v39 and v83.Shear:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (182 - 132))) then
					if (v19(v83.Shear, not v91) or ((3845 - 1523) > (3061 - (397 + 42)))) then
						return "shear maintenance 16";
					end
				end
				v145 = 1 + 2;
			end
			if ((v145 == (803 - (24 + 776))) or ((6984 - 2450) == (2867 - (222 + 563)))) then
				if ((v42 and v83.SpiritBomb:IsReady() and (v13:FuryDeficit() <= (66 - 36)) and (v96 > (1 + 0)) and (v87 >= (194 - (23 + 167)))) or ((3369 - (690 + 1108)) > (674 + 1193))) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(7 + 1)) or ((3502 - (40 + 808)) >= (494 + 2502))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if (((15211 - 11233) > (2011 + 93)) and v41 and v83.SoulCleave:IsReady() and not v103 and (v13:FuryDeficit() <= (22 + 18))) then
					if (((1643 + 1352) > (2112 - (47 + 524))) and v19(v83.SoulCleave, not v91)) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if (((2109 + 1140) > (2604 - 1651)) and (v145 == (1 - 0))) then
				if ((v33 and v83.BulkExtraction:IsCastable() and (((11 - 6) - v87) <= v96) and (v87 <= (1728 - (1165 + 561)))) or ((98 + 3175) > (14163 - 9590))) then
					if (v19(v83.BulkExtraction, not v91) or ((1203 + 1948) < (1763 - (341 + 138)))) then
						return "bulk_extraction maintenance 8";
					end
				end
				if ((v103 and not v102 and v42) or ((500 + 1350) == (3154 - 1625))) then
					if (((1147 - (89 + 237)) < (6829 - 4706)) and v19(v83.Pool)) then
						return "Wait for Spirit Bomb";
					end
				end
				if (((1898 - 996) < (3206 - (581 + 300))) and v42 and v83.SpiritBomb:IsReady() and v102) then
					if (((2078 - (855 + 365)) <= (7035 - 4073)) and v19(v83.SpiritBomb, not v14:IsInMeleeRange(3 + 5))) then
						return "spirit_bomb maintenance 10";
					end
				end
				v145 = 1237 - (1030 + 205);
			end
		end
	end
	local function v116()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (4 + 0)) or ((4232 - (156 + 130)) < (2926 - 1638))) then
				if ((v83.SpiritBomb:IsReady() and v42 and v102) or ((5463 - 2221) == (1160 - 593))) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(3 + 5)) or ((494 + 353) >= (1332 - (10 + 59)))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				break;
			end
			if ((v146 == (1 + 1)) or ((11095 - 8842) == (3014 - (671 + 492)))) then
				if ((v51 and v83.SoulCarver:IsCastable() and (v88 < (3 + 0)) and ((v31 and v55) or not v55) and (v70 < v105)) or ((3302 - (369 + 846)) > (628 + 1744))) then
					if (v19(v83.SoulCarver, not v91) or ((3794 + 651) < (6094 - (1036 + 909)))) then
						return "soul_carver fiery_demise 10";
					end
				end
				if ((v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) or ((1446 + 372) == (142 - 57))) then
					if (((833 - (11 + 192)) < (1075 + 1052)) and v19(v83.TheHunt, not v14:IsInRange(205 - (135 + 40)))) then
						return "the_hunt fiery_demise 12";
					end
				end
				v146 = 6 - 3;
			end
			if ((v146 == (2 + 1)) or ((4269 - 2331) == (3768 - 1254))) then
				if (((4431 - (50 + 126)) >= (153 - 98)) and v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1.85 + 0)) and (v13:Fury() >= (1453 - (1233 + 180))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
					if (((3968 - (522 + 447)) > (2577 - (107 + 1314))) and (v57 == "player")) then
						if (((1091 + 1259) > (3519 - 2364)) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(4 + 4))) then
							return "elysian_decree fiery_demise 14 (Player)";
						end
					elseif (((8000 - 3971) <= (19201 - 14348)) and (v57 == "cursor")) then
						if (v19(v85.ElysianDecreeCursor, not v14:IsInRange(1940 - (716 + 1194))) or ((9 + 507) > (368 + 3066))) then
							return "elysian_decree fiery_demise 14 (Cursor)";
						end
					end
				end
				if (((4549 - (74 + 429)) >= (5850 - 2817)) and v103 and not v102 and v42) then
					if (v19(v83.Pool) or ((1348 + 1371) <= (3311 - 1864))) then
						return "Wait for Spirit Bomb";
					end
				end
				v146 = 3 + 1;
			end
			if ((v146 == (0 - 0)) or ((10221 - 6087) < (4359 - (279 + 154)))) then
				if ((v37 and v83.ImmolationAura:IsCastable()) or ((942 - (454 + 324)) >= (2192 + 593))) then
					if (v19(v83.ImmolationAura, not v14:IsInMeleeRange(25 - (12 + 5))) or ((284 + 241) == (5373 - 3264))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if (((13 + 20) == (1126 - (277 + 816))) and v40 and v83.SigilOfFlame:IsCastable() and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) then
					if (((4237 - (1058 + 125)) <= (753 + 3262)) and (v83.ConcentratedSigils:IsAvailable() or (v78 == "player"))) then
						if (((2846 - (815 + 160)) < (14510 - 11128)) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(18 - 10))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif (((309 + 984) <= (6331 - 4165)) and (v78 == "cursor")) then
						if (v19(v85.SigilOfFlameCursor, not v14:IsInRange(1928 - (41 + 1857))) or ((4472 - (1222 + 671)) < (317 - 194))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				v146 = 1 - 0;
			end
			if ((v146 == (1183 - (229 + 953))) or ((2620 - (1111 + 663)) >= (3947 - (874 + 705)))) then
				if ((v35 and v83.Felblade:IsReady() and (not v83.SpiritBomb:IsAvailable() or (v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains()))) and (v13:Fury() < (7 + 43))) or ((2738 + 1274) <= (6979 - 3621))) then
					if (((43 + 1451) <= (3684 - (642 + 37))) and v19(v83.Felblade, not v91)) then
						return "felblade fiery_demise 6";
					end
				end
				if ((v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105) and v83.FelDevastation:IsReady()) or ((710 + 2401) == (342 + 1792))) then
					if (((5912 - 3557) == (2809 - (233 + 221))) and v19(v83.FelDevastation, not v14:IsInMeleeRange(18 - 10))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v146 = 2 + 0;
			end
		end
	end
	local function v117()
		local v147 = 1541 - (718 + 823);
		while true do
			if ((v147 == (2 + 0)) or ((1393 - (266 + 539)) <= (1222 - 790))) then
				if (((6022 - (636 + 589)) >= (9245 - 5350)) and v83.Shear:IsCastable() and v39) then
					if (((7377 - 3800) == (2835 + 742)) and v19(v83.Shear, not v91)) then
						return "shear filler 10";
					end
				end
				if (((1379 + 2415) > (4708 - (657 + 358))) and v83.ThrowGlaive:IsCastable() and v43) then
					if (v19(v83.ThrowGlaive, not v14:IsInRange(79 - 49)) or ((2904 - 1629) == (5287 - (1151 + 36)))) then
						return "throw_glaive filler 12";
					end
				end
				break;
			end
			if ((v147 == (0 + 0)) or ((419 + 1172) >= (10691 - 7111))) then
				if (((2815 - (1552 + 280)) <= (2642 - (64 + 770))) and v83.SigilOfChains:IsCastable() and v47 and (v83.CycleofBinding:IsAvailable())) then
					if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((1460 + 690) <= (2716 - 1519))) then
						if (((670 + 3099) >= (2416 - (157 + 1086))) and v19(v85.SigilOfChainsPlayer, not v14:IsInMeleeRange(15 - 7))) then
							return "sigil_of_chains player filler 2";
						end
					elseif (((6503 - 5018) == (2277 - 792)) and (v78 == "cursor")) then
						if (v19(v85.SigilOfChainsCursor, not v14:IsInRange(40 - 10)) or ((4134 - (599 + 220)) <= (5539 - 2757))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if ((v83.SigilOfMisery:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v48) or ((2807 - (1813 + 118)) >= (2167 + 797))) then
					if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((3449 - (841 + 376)) > (3498 - 1001))) then
						if (v19(v85.SigilOfMiseryPlayer, not v14:IsInMeleeRange(2 + 6)) or ((5759 - 3649) <= (1191 - (464 + 395)))) then
							return "sigil_of_misery player filler 4";
						end
					elseif (((9459 - 5773) > (1524 + 1648)) and (v78 == "cursor")) then
						if (v19(v85.SigilOfMiseryCursor, not v14:IsInRange(867 - (467 + 370))) or ((9245 - 4771) < (602 + 218))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v147 = 3 - 2;
			end
			if (((668 + 3611) >= (6704 - 3822)) and (v147 == (521 - (150 + 370)))) then
				if ((v83.SigilOfSilence:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v46) or ((3311 - (74 + 1208)) >= (8660 - 5139))) then
					if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((9660 - 7623) >= (3304 + 1338))) then
						if (((2110 - (14 + 376)) < (7731 - 3273)) and v19(v85.SigilOfSilencePlayer, not v14:IsInMeleeRange(6 + 2))) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((v78 == "cursor") or ((384 + 52) > (2882 + 139))) then
						if (((2089 - 1376) <= (638 + 209)) and v19(v85.SigilOfSilenceCursor, not v14:IsInRange(108 - (23 + 55)))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if (((5104 - 2950) <= (2690 + 1341)) and v83.Felblade:IsReady() and v35) then
					if (((4145 + 470) == (7155 - 2540)) and v19(v83.Felblade, not v91)) then
						return "felblade filler 8";
					end
				end
				v147 = 1 + 1;
			end
		end
	end
	local function v118()
		local v148 = 901 - (652 + 249);
		while true do
			if ((v148 == (5 - 3)) or ((5658 - (708 + 1160)) == (1357 - 857))) then
				if (((161 - 72) < (248 - (10 + 17))) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (((462 + 1592) >= (3153 - (1400 + 332))) and v19(v83.FelDevastation, not v14:IsInMeleeRange(38 - 18))) then
						return "fel_devastation single_target 10";
					end
				end
				if (((2600 - (242 + 1666)) < (1309 + 1749)) and v83.SoulCleave:IsReady() and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((1193 + 2061) == (1411 + 244))) then
						return "soul_cleave single_target 12";
					end
				end
				v148 = 943 - (850 + 90);
			end
			if ((v148 == (1 - 0)) or ((2686 - (360 + 1030)) == (4346 + 564))) then
				if (((9506 - 6138) == (4633 - 1265)) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (((4304 - (909 + 752)) < (5038 - (109 + 1114))) and v19(v83.FelDevastation, not v14:IsInMeleeRange(36 - 16))) then
						return "fel_devastation single_target 6";
					end
				end
				if (((745 + 1168) > (735 - (6 + 236))) and v83.ElysianDecree:IsCastable() and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
					if (((2996 + 1759) > (2760 + 668)) and (v57 == "player")) then
						if (((3256 - 1875) <= (4137 - 1768)) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(1163 - (1076 + 57)))) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif ((v57 == "cursor") or ((797 + 4046) == (4773 - (579 + 110)))) then
						if (((369 + 4300) > (321 + 42)) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(16 + 14))) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				v148 = 409 - (174 + 233);
			end
			if ((v148 == (11 - 7)) or ((3294 - 1417) >= (1396 + 1742))) then
				if (((5916 - (663 + 511)) >= (3235 + 391)) and v28) then
					return v28;
				end
				break;
			end
			if ((v148 == (1 + 2)) or ((13996 - 9456) == (555 + 361))) then
				if ((v83.Fracture:IsCastable() and v36) or ((2721 - 1565) > (10518 - 6173))) then
					if (((1068 + 1169) < (8269 - 4020)) and v19(v83.Fracture, not v91)) then
						return "fracture single_target 14";
					end
				end
				v28 = v117();
				v148 = 3 + 1;
			end
			if ((v148 == (0 + 0)) or ((3405 - (478 + 244)) < (540 - (440 + 77)))) then
				if (((317 + 380) <= (3022 - 2196)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
					if (((2661 - (655 + 901)) <= (219 + 957)) and v19(v83.TheHunt, not v14:IsInRange(39 + 11))) then
						return "the_hunt single_target 2";
					end
				end
				if (((2282 + 1097) <= (15357 - 11545)) and v83.SoulCarver:IsCastable() and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (v19(v83.SoulCarver, not v91) or ((2233 - (695 + 750)) >= (5517 - 3901))) then
						return "soul_carver single_target 4";
					end
				end
				v148 = 1 - 0;
			end
		end
	end
	local function v119()
		local v149 = 0 - 0;
		while true do
			if (((2205 - (285 + 66)) <= (7876 - 4497)) and ((1312 - (682 + 628)) == v149)) then
				if (((734 + 3815) == (4848 - (176 + 123))) and v83.SoulCarver:IsCastable() and (v88 < (2 + 1)) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (v19(v83.SoulCarver, not v91) or ((2193 + 829) >= (3293 - (239 + 30)))) then
						return "soul_carver small_aoe 10";
					end
				end
				if (((1311 + 3509) > (2113 + 85)) and v83.SoulCleave:IsReady() and ((v87 <= (1 - 0)) or not v83.SpiritBomb:IsAvailable()) and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((3310 - 2249) >= (5206 - (306 + 9)))) then
						return "soul_cleave small_aoe 12";
					end
				end
				v149 = 10 - 7;
			end
			if (((238 + 1126) <= (2745 + 1728)) and ((1 + 0) == v149)) then
				if ((v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (2.85 - 1)) and (v13:Fury() >= (1415 - (1140 + 235))) and ((v88 <= (1 + 0)) or (v88 >= (4 + 0))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((923 + 2672) <= (55 - (33 + 19)))) then
					if ((v57 == "player") or ((1687 + 2985) == (11545 - 7693))) then
						if (((687 + 872) == (3056 - 1497)) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(29 + 1))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif ((v57 == "cursor") or ((2441 - (586 + 103)) <= (72 + 716))) then
						if (v19(v85.ElysianDecreeCursor, not v14:IsInRange(92 - 62)) or ((5395 - (1309 + 179)) == (318 - 141))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				if (((1511 + 1959) > (1490 - 935)) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(16 + 4)) or ((2064 - 1092) == (1285 - 640))) then
						return "fel_devastation small_aoe 8";
					end
				end
				v149 = 611 - (295 + 314);
			end
			if (((7815 - 4633) >= (4077 - (1300 + 662))) and (v149 == (9 - 6))) then
				if (((5648 - (1178 + 577)) < (2301 + 2128)) and v83.Fracture:IsCastable() and v36) then
					if (v19(v83.Fracture, not v91) or ((8475 - 5608) < (3310 - (851 + 554)))) then
						return "fracture small_aoe 14";
					end
				end
				v28 = v117();
				v149 = 4 + 0;
			end
			if ((v149 == (10 - 6)) or ((3900 - 2104) >= (4353 - (115 + 187)))) then
				if (((1240 + 379) <= (3556 + 200)) and v28) then
					return v28;
				end
				break;
			end
			if (((2379 - 1775) == (1765 - (160 + 1001))) and (v149 == (0 + 0))) then
				if ((v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) or ((3094 + 1390) == (1842 - 942))) then
					if (v19(v83.TheHunt, not v14:IsInRange(408 - (237 + 121))) or ((5356 - (525 + 372)) <= (2109 - 996))) then
						return "the_hunt small_aoe 2";
					end
				end
				if (((11933 - 8301) > (3540 - (96 + 46))) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (((4859 - (643 + 134)) <= (1776 + 3141)) and v19(v83.FelDevastation, not v14:IsInMeleeRange(47 - 27))) then
						return "fel_devastation small_aoe 4";
					end
				end
				v149 = 3 - 2;
			end
		end
	end
	local function v120()
		local v150 = 0 + 0;
		while true do
			if (((9482 - 4650) >= (2833 - 1447)) and (v150 == (719 - (316 + 403)))) then
				if (((92 + 45) == (376 - 239)) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or v83.StoketheFlames:IsAvailable()) and v50 and ((v31 and v54) or not v54) and (v70 < v105) and ((not v32 and v81) or not v81)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(8 + 12)) or ((3953 - 2383) >= (3070 + 1262))) then
						return "fel_devastation big_aoe 2";
					end
				end
				if ((v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) or ((1310 + 2754) <= (6302 - 4483))) then
					if (v19(v83.TheHunt, not v14:IsInRange(238 - 188)) or ((10357 - 5371) < (91 + 1483))) then
						return "the_hunt big_aoe 4";
					end
				end
				if (((8712 - 4286) > (9 + 163)) and v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (2.85 - 1)) and (v13:Fury() >= (57 - (12 + 5))) and ((v88 <= (3 - 2)) or (v88 >= (8 - 4))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
					if (((1245 - 659) > (1128 - 673)) and (v57 == "player")) then
						if (((168 + 658) == (2799 - (1656 + 317))) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(27 + 3))) then
							return "elysian_decree big_aoe 6 (Player)";
						end
					elseif ((v57 == "cursor") or ((3221 + 798) > (11808 - 7367))) then
						if (((9926 - 7909) < (4615 - (5 + 349))) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(142 - 112))) then
							return "elysian_decree big_aoe 6 (Cursor)";
						end
					end
				end
				if (((5987 - (266 + 1005)) > (53 + 27)) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(68 - 48)) or ((4616 - 1109) == (4968 - (561 + 1135)))) then
						return "fel_devastation big_aoe 8";
					end
				end
				v150 = 1 - 0;
			end
			if ((v150 == (6 - 4)) or ((1942 - (507 + 559)) >= (7716 - 4641))) then
				if (((13459 - 9107) > (2942 - (212 + 176))) and v83.SoulCleave:IsReady() and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((5311 - (250 + 655)) < (11024 - 6981))) then
						return "soul_cleave big_aoe 18";
					end
				end
				v28 = v117();
				if (v28 or ((3300 - 1411) >= (5292 - 1909))) then
					return v28;
				end
				break;
			end
			if (((3848 - (1869 + 87)) <= (9482 - 6748)) and (v150 == (1902 - (484 + 1417)))) then
				if (((4121 - 2198) < (3716 - 1498)) and v83.SoulCarver:IsCastable() and (v88 < (776 - (48 + 725))) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (((3549 - 1376) > (1016 - 637)) and v19(v83.SoulCarver, not v91)) then
						return "soul_carver big_aoe 10";
					end
				end
				if ((v83.SpiritBomb:IsReady() and (v87 >= (3 + 1)) and v42) or ((6924 - 4333) == (955 + 2454))) then
					if (((1316 + 3198) > (4177 - (152 + 701))) and v19(v83.SpiritBomb, not v14:IsInMeleeRange(1319 - (430 + 881)))) then
						return "spirit_bomb big_aoe 12";
					end
				end
				if ((v83.SoulCleave:IsReady() and (not v83.SpiritBomb:IsAvailable() or not v97) and v41) or ((80 + 128) >= (5723 - (557 + 338)))) then
					if (v19(v83.SoulCleave, not v91) or ((468 + 1115) > (10051 - 6484))) then
						return "soul_cleave big_aoe 14";
					end
				end
				if ((v83.Fracture:IsCastable() and v36) or ((4597 - 3284) == (2109 - 1315))) then
					if (((6840 - 3666) > (3703 - (499 + 302))) and v19(v83.Fracture, not v91)) then
						return "fracture big_aoe 16";
					end
				end
				v150 = 868 - (39 + 827);
			end
		end
	end
	local function v121()
		local v151 = 0 - 0;
		while true do
			if (((9201 - 5081) <= (16920 - 12660)) and (v151 == (5 - 1))) then
				v49 = EpicSettings.Settings['useElysianDecree'];
				v50 = EpicSettings.Settings['useFelDevastation'];
				v51 = EpicSettings.Settings['useSoulCarver'];
				v52 = EpicSettings.Settings['useTheHunt'];
				v151 = 1 + 4;
			end
			if ((v151 == (8 - 5)) or ((142 + 741) > (7560 - 2782))) then
				v45 = EpicSettings.Settings['useDisrupt'];
				v46 = EpicSettings.Settings['useSigilOfSilence'];
				v47 = EpicSettings.Settings['useSigilOfChains'];
				v48 = EpicSettings.Settings['useSigilOfMisery'];
				v151 = 108 - (103 + 1);
			end
			if ((v151 == (562 - (475 + 79))) or ((7825 - 4205) >= (15651 - 10760))) then
				v58 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				v79 = EpicSettings.Settings['fieryBrandOffensively'];
				v80 = EpicSettings.Settings['metamorphosisOffensively'];
				break;
			end
			if (((3748 + 510) > (2440 - (1395 + 108))) and ((14 - 9) == v151)) then
				v53 = EpicSettings.Settings['elysianDecreeWithCD'];
				v54 = EpicSettings.Settings['felDevastationWithCD'];
				v55 = EpicSettings.Settings['soulCarverWithCD'];
				v56 = EpicSettings.Settings['theHuntWithCD'];
				v151 = 1210 - (7 + 1197);
			end
			if ((v151 == (0 + 0)) or ((1699 + 3170) < (1225 - (27 + 292)))) then
				v33 = EpicSettings.Settings['useBulkExtraction'];
				v34 = EpicSettings.Settings['useConsumeMagic'];
				v35 = EpicSettings.Settings['useFelblade'];
				v36 = EpicSettings.Settings['useFracture'];
				v151 = 2 - 1;
			end
			if ((v151 == (2 - 0)) or ((5137 - 3912) > (8337 - 4109))) then
				v41 = EpicSettings.Settings['useSoulCleave'];
				v42 = EpicSettings.Settings['useSpiritBomb'];
				v43 = EpicSettings.Settings['useThrowGlaive'];
				v44 = EpicSettings.Settings['useChaosNova'];
				v151 = 5 - 2;
			end
			if (((3467 - (43 + 96)) > (9128 - 6890)) and ((13 - 7) == v151)) then
				v59 = EpicSettings.Settings['useDemonSpikes'];
				v60 = EpicSettings.Settings['useFieryBrand'];
				v61 = EpicSettings.Settings['useMetamorphosis'];
				v62 = EpicSettings.Settings['demonSpikesHP'] or (0 + 0);
				v151 = 2 + 5;
			end
			if (((7587 - 3748) > (539 + 866)) and (v151 == (12 - 5))) then
				v63 = EpicSettings.Settings['fieryBrandHP'] or (0 + 0);
				v64 = EpicSettings.Settings['metamorphosisHP'] or (0 + 0);
				v78 = EpicSettings.Settings['sigilSetting'] or "player";
				v57 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v151 = 1759 - (1414 + 337);
			end
			if ((v151 == (1941 - (1642 + 298))) or ((3370 - 2077) <= (1458 - 951))) then
				v37 = EpicSettings.Settings['useImmolationAura'];
				v38 = EpicSettings.Settings['useInfernalStrike'];
				v39 = EpicSettings.Settings['useShear'];
				v40 = EpicSettings.Settings['useSigilOfFlame'];
				v151 = 5 - 3;
			end
		end
	end
	local function v122()
		local v152 = 0 + 0;
		while true do
			if ((v152 == (0 + 0)) or ((3868 - (357 + 615)) < (566 + 239))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v152 = 1 + 0;
			end
			if (((4963 - 2647) == (1853 + 463)) and (v152 == (1 + 0))) then
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v152 = 2 + 0;
			end
			if ((v152 == (1304 - (384 + 917))) or ((3267 - (128 + 569)) == (3076 - (1407 + 136)))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				v82 = EpicSettings.Settings['RMBAOE'];
				v81 = EpicSettings.Settings['RMBMovement'];
				break;
			end
			if ((v152 == (1889 - (687 + 1200))) or ((2593 - (556 + 1154)) == (5136 - 3676))) then
				v73 = EpicSettings.Settings['useHealingPotion'];
				v76 = EpicSettings.Settings['healthstoneHP'] or (95 - (9 + 86));
				v75 = EpicSettings.Settings['healingPotionHP'] or (421 - (275 + 146));
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v152 = 1 + 2;
			end
		end
	end
	local function v123()
		local v153 = 64 - (29 + 35);
		while true do
			if ((v153 == (0 - 0)) or ((13796 - 9177) <= (4409 - 3410))) then
				v121();
				v122();
				v29 = EpicSettings.Toggles['ooc'];
				v153 = 1 + 0;
			end
			if (((1015 - (53 + 959)) == v153) or ((3818 - (312 + 96)) > (7143 - 3027))) then
				v111();
				v93 = v13:ActiveMitigationNeeded();
				v94 = v13:IsTankingAoE(293 - (147 + 138)) or v13:IsTanking(v14);
				v153 = 903 - (813 + 86);
			end
			if ((v153 == (5 + 0)) or ((1672 - 769) >= (3551 - (18 + 474)))) then
				v88 = v87 + v89;
				if (v66 or ((1342 + 2634) < (9324 - 6467))) then
					local v210 = 1086 - (860 + 226);
					while true do
						if (((5233 - (121 + 182)) > (284 + 2023)) and (v210 == (1240 - (988 + 252)))) then
							v28 = v21.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 3 + 17);
							if (v28 or ((1268 + 2778) < (3261 - (49 + 1921)))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v21.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((5131 - (223 + 667)) == (3597 - (51 + 1)))) then
					local v211 = 0 - 0;
					local v212;
					while true do
						if (((8 - 4) == v211) or ((5173 - (146 + 979)) > (1195 + 3037))) then
							if ((v83.InfernalStrike:IsCastable() and v38 and (v83.InfernalStrike:ChargesFractional() > (606.7 - (311 + 294))) and (v83.InfernalStrike:TimeSinceLastCast() > (5 - 3))) or ((742 + 1008) >= (4916 - (496 + 947)))) then
								if (((4524 - (1233 + 125)) == (1285 + 1881)) and v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(8 + 0))) then
									return "infernal_strike main 2";
								end
							end
							if (((335 + 1428) < (5369 - (963 + 682))) and (v70 < v105) and v83.Metamorphosis:IsCastable() and v61 and v80 and v13:BuffDown(v83.MetamorphosisBuff) and (v83.FelDevastation:CooldownRemains() > (11 + 1))) then
								if (((1561 - (504 + 1000)) <= (1834 + 889)) and v19(v85.MetamorphosisPlayer, not v91)) then
									return "metamorphosis main 4";
								end
							end
							v212 = v21.HandleDPSPotion();
							v211 = 5 + 0;
						end
						if ((v211 == (1 + 2)) or ((3052 - 982) == (379 + 64))) then
							if ((not v13:AffectingCombat() and v29) or ((1574 + 1131) == (1575 - (156 + 26)))) then
								v28 = v113();
								if (v28 or ((2651 + 1950) < (95 - 34))) then
									return v28;
								end
							end
							if ((v83.ConsumeMagic:IsAvailable() and v34 and v83.ConsumeMagic:IsReady() and v65 and not v13:IsCasting() and not v13:IsChanneling() and v21.UnitHasMagicBuff(v14)) or ((1554 - (149 + 15)) >= (5704 - (890 + 70)))) then
								if (v19(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic)) or ((2120 - (39 + 78)) > (4316 - (14 + 468)))) then
									return "greater_purge damage";
								end
							end
							if (v94 or ((342 - 186) > (10936 - 7023))) then
								v28 = v114();
								if (((101 + 94) == (118 + 77)) and v28) then
									return v28;
								end
							end
							v211 = 1 + 3;
						end
						if (((1403 + 1702) >= (471 + 1325)) and (v211 == (9 - 4))) then
							if (((4328 + 51) >= (7488 - 5357)) and v212) then
								return v212;
							end
							if (((98 + 3746) >= (2094 - (12 + 39))) and (v70 < v105)) then
								if ((v71 and ((v31 and v72) or not v72)) or ((3007 + 225) <= (8453 - 5722))) then
									v28 = v112();
									if (((17469 - 12564) == (1455 + 3450)) and v28) then
										return v28;
									end
								end
							end
							if ((v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (0 + 0))) or ((10487 - 6351) >= (2938 + 1473))) then
								local v215 = 0 - 0;
								while true do
									if ((v215 == (1710 - (1596 + 114))) or ((7722 - 4764) == (4730 - (164 + 549)))) then
										v28 = v116();
										if (((2666 - (1059 + 379)) >= (1008 - 195)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v211 = 4 + 2;
						end
						if ((v211 == (2 + 4)) or ((3847 - (145 + 247)) > (3324 + 726))) then
							v28 = v115();
							if (((113 + 130) == (719 - 476)) and v28) then
								return v28;
							end
							if (v99 or ((52 + 219) > (1355 + 217))) then
								v28 = v118();
								if (((4446 - 1707) < (4013 - (254 + 466))) and v28) then
									return v28;
								end
							end
							v211 = 567 - (544 + 16);
						end
						if ((v211 == (21 - 14)) or ((4570 - (294 + 334)) < (1387 - (236 + 17)))) then
							if (v100 or ((1161 + 1532) == (3872 + 1101))) then
								local v216 = 0 - 0;
								while true do
									if (((10160 - 8014) == (1105 + 1041)) and (v216 == (0 + 0))) then
										v28 = v119();
										if (v28 or ((3038 - (413 + 381)) == (136 + 3088))) then
											return v28;
										end
										break;
									end
								end
							end
							if (v101 or ((10429 - 5525) <= (4976 - 3060))) then
								v28 = v120();
								if (((2060 - (582 + 1388)) <= (1814 - 749)) and v28) then
									return v28;
								end
							end
							break;
						end
						if (((3438 + 1364) == (5166 - (326 + 38))) and (v211 == (0 - 0))) then
							v98 = v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (0 - 0));
							v99 = v96 == (621 - (47 + 573));
							v100 = (v96 >= (1 + 1)) and (v96 <= (21 - 16));
							v211 = 1 - 0;
						end
						if ((v211 == (1666 - (1269 + 395))) or ((2772 - (76 + 416)) <= (954 - (319 + 124)))) then
							if (v98 or ((3830 - 2154) <= (1470 - (564 + 443)))) then
								v103 = (v99 and (v88 >= (13 - 8))) or (v100 and (v88 >= (462 - (337 + 121)))) or (v101 and (v88 >= (8 - 5)));
							else
								v103 = (v100 and (v88 >= (16 - 11))) or (v101 and (v88 >= (1915 - (1261 + 650))));
							end
							if (((1637 + 2232) == (6165 - 2296)) and v83.ThrowGlaive:IsCastable() and v43 and v11.ValueIsInArray(v106, v14:NPCID())) then
								if (((2975 - (772 + 1045)) <= (369 + 2244)) and v19(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
									return "fodder to the flames on those filthy demons";
								end
							end
							if ((v83.ThrowGlaive:IsReady() and v43 and v11.ValueIsInArray(v106, v15:NPCID())) or ((2508 - (102 + 42)) <= (3843 - (1524 + 320)))) then
								if (v19(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((6192 - (1049 + 221)) < (350 - (18 + 138)))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v211 = 7 - 4;
						end
						if ((v211 == (1103 - (67 + 1035))) or ((2439 - (136 + 212)) < (131 - 100))) then
							v101 = v96 >= (5 + 1);
							v97 = ((v83.FelDevastation:CooldownRemains() <= (v83.SoulCleave:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (74 + 6))) or (((v89 > (1605 - (240 + 1364))) or (v88 >= (1087 - (1050 + 32)))) and not v99);
							if (v98 or ((8676 - 6246) >= (2882 + 1990))) then
								v102 = (v99 and (v87 >= (1060 - (331 + 724)))) or (v100 and (v87 >= (1 + 3))) or (v101 and (v87 >= (647 - (269 + 375))));
							else
								v102 = (v100 and (v87 >= (730 - (267 + 458)))) or (v101 and (v87 >= (2 + 2)));
							end
							v211 = 3 - 1;
						end
					end
				end
				break;
			end
			if ((v153 == (819 - (667 + 151))) or ((6267 - (1410 + 87)) < (3632 - (1504 + 393)))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				if (v13:IsDeadOrGhost() or ((11998 - 7559) <= (6096 - 3746))) then
					return v28;
				end
				v153 = 798 - (461 + 335);
			end
			if ((v153 == (1 + 1)) or ((6240 - (1730 + 31)) < (6133 - (728 + 939)))) then
				if (((9020 - 6473) > (2484 - 1259)) and IsMouseButtonDown("RightButton")) then
					v32 = true;
				else
					v32 = false;
				end
				v95 = v13:GetEnemiesInMeleeRange(18 - 10);
				if (((5739 - (138 + 930)) > (2444 + 230)) and v30) then
					v96 = #v95;
				else
					v96 = 1 + 0;
				end
				v153 = 3 + 0;
			end
			if ((v153 == (16 - 12)) or ((5462 - (459 + 1307)) < (5197 - (474 + 1396)))) then
				if (v21.TargetIsValid() or v13:AffectingCombat() or ((7930 - 3388) == (2784 + 186))) then
					local v213 = 0 + 0;
					while true do
						if (((721 - 469) <= (251 + 1726)) and (v213 == (0 - 0))) then
							v104 = v9.BossFightRemains(nil, true);
							v105 = v104;
							v213 = 4 - 3;
						end
						if ((v213 == (592 - (562 + 29))) or ((1225 + 211) == (5194 - (374 + 1045)))) then
							if ((v105 == (8794 + 2317)) or ((5024 - 3406) < (1568 - (448 + 190)))) then
								v105 = v9.FightRemains(v95, false);
							end
							break;
						end
					end
				end
				v87 = v107.AuraSouls;
				v89 = v107.IncomingSouls;
				v153 = 2 + 3;
			end
		end
	end
	local function v124()
		local v154 = 0 + 0;
		while true do
			if (((3078 + 1645) > (15967 - 11814)) and (v154 == (2 - 1))) then
				v83.SigilOfFlameDebuff:RegisterAuraTracking();
				break;
			end
			if ((v154 == (1494 - (1307 + 187))) or ((14490 - 10836) >= (10896 - 6242))) then
				v18.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
				v83.FieryBrandDebuff:RegisterAuraTracking();
				v154 = 2 - 1;
			end
		end
	end
	v18.SetAPL(1264 - (232 + 451), v123, v124);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

