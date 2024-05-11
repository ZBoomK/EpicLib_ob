local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((447 + 1740) >= (11510 - 6556))) then
			v6 = v0[v4];
			if (not v6 or ((896 + 2981) == (1188 + 2387))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((1803 - (709 + 387)) > (2490 - (673 + 1185))) and (v5 == (2 - 1))) then
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
	local v88, v89, v90;
	local v91 = ((v84.SoulSigils:IsAvailable()) and (12 - 8)) or (4 - 1);
	local v92, v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98, v99, v100, v101, v102, v103, v104;
	local v105 = 7948 + 3163;
	local v106 = 8303 + 2808;
	local v107 = {(41611 + 127810),(332585 - 163160),(170215 - (1040 + 243)),(171273 - (559 + 1288)),(169883 - (13 + 441)),(443793 - 274365),(6309 + 163121)};
	v10:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if ((v126 == (0 + 0)) or ((240 + 306) >= (7964 - 5280))) then
				v105 = 6081 + 5030;
				v106 = 20435 - 9324;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v91 = ((v84.SoulSigils:IsAvailable()) and (3 + 1)) or (2 + 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v108 = {};
	local v109 = v108;
	v109.AuraSouls = 0 + 0;
	v109.IncomingSouls = 0 + 0;
	v10:RegisterForSelfCombatEvent(function(...)
		local v127 = 0 + 0;
		local v128;
		local v129;
		while true do
			if (((1898 - (153 + 280)) <= (12419 - 8118)) and ((1 + 0) == v127)) then
				if (((673 + 1031) > (746 + 679)) and ((v128 == v84.Fracture:ID()) or (v128 == v84.Shear:ID()))) then
					v129 = 2 + 0;
				elseif ((v128 == v84.SoulCarver:ID()) or ((498 + 189) == (6446 - 2212))) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (668 - (89 + 578))) or ((2379 + 951) < (2970 - 1541))) then
							C_Timer.After(1051 - (572 + 477), function()
								v109.IncomingSouls = v109.IncomingSouls + 1 + 0;
							end);
							C_Timer.After(2 + 1, function()
								v109.IncomingSouls = v109.IncomingSouls + 1 + 0;
							end);
							break;
						end
						if (((1233 - (84 + 2)) >= (552 - 217)) and (v214 == (0 + 0))) then
							v129 = 845 - (497 + 345);
							C_Timer.After(1 + 0, function()
								v109.IncomingSouls = v109.IncomingSouls + 1 + 0;
							end);
							v214 = 1334 - (605 + 728);
						end
					end
				elseif (((2451 + 984) > (4661 - 2564)) and (v128 == v84.ElysianDecree:ID())) then
					v129 = ((v84.SoulSigils:IsAvailable()) and (1 + 3)) or (10 - 7);
				elseif ((v84.SoulSigils:IsAvailable() and ((v128 == v84.SigilOfFlame:ID()) or (v128 == v84.SigilOfMisery:ID()) or (v128 == v84.SigilOfChains:ID()) or (v128 == v84.SigilOfSilence:ID()))) or ((3399 + 371) >= (11195 - 7154))) then
					v129 = 1 + 0;
				else
					v129 = 489 - (457 + 32);
				end
				if ((v129 > (0 + 0)) or ((5193 - (832 + 570)) <= (1518 + 93))) then
					v109.IncomingSouls = v109.IncomingSouls + v129;
				end
				break;
			end
			if ((v127 == (0 + 0)) or ((16200 - 11622) <= (968 + 1040))) then
				v128 = select(808 - (588 + 208), ...);
				v129 = 0 - 0;
				v127 = 1801 - (884 + 916);
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForSelfCombatEvent(function(...)
		local v130 = select(24 - 12, ...);
		if (((653 + 472) <= (2729 - (232 + 421))) and (v130 == (427561 - (1569 + 320)))) then
			v109.IncomingSouls = v109.IncomingSouls + 1 + 0;
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v131 = 0 + 0;
		local v132;
		while true do
			if ((v131 == (0 - 0)) or ((1348 - (316 + 289)) >= (11514 - 7115))) then
				v132 = select(1 + 11, ...);
				if (((2608 - (666 + 787)) < (2098 - (360 + 65))) and (v132 == (190634 + 13347))) then
					v109.AuraSouls = 255 - (79 + 175);
					v109.IncomingSouls = v27(0 - 0, v109.IncomingSouls - (1 + 0));
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v133 = 0 - 0;
		local v134;
		local v135;
		local v136;
		while true do
			if ((v133 == (0 - 0)) or ((3223 - (503 + 396)) <= (759 - (92 + 89)))) then
				v134, v135, v135, v135, v136 = select(22 - 10, ...);
				if (((1932 + 1835) == (2230 + 1537)) and (v134 == (798818 - 594837))) then
					v109.AuraSouls = v136;
					v109.IncomingSouls = v27(0 + 0, v109.IncomingSouls - v136);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED_DOSE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v137 = 0 - 0;
		local v138;
		local v139;
		local v140;
		while true do
			if (((3568 + 521) == (1954 + 2135)) and (v137 == (0 - 0))) then
				v138, v139, v139, v139, v140 = select(2 + 10, ...);
				if (((6798 - 2340) >= (2918 - (485 + 759))) and (v138 == (471988 - 268007))) then
					v109.AuraSouls = v140;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED_DOSE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v141 = 1189 - (442 + 747);
		local v142;
		local v143;
		local v144;
		while true do
			if (((2107 - (832 + 303)) <= (2364 - (88 + 858))) and (v141 == (0 + 0))) then
				v142, v143, v143, v143, v144 = select(10 + 2, ...);
				if ((v142 == (8402 + 195579)) or ((5727 - (766 + 23)) < (23508 - 18746))) then
					v109.AuraSouls = 0 - 0;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	local function v112()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (3 - 2)) or ((3577 - (1036 + 37)) > (3024 + 1240))) then
				v93 = v92 or (v97 > (0 - 0));
				break;
			end
			if (((1694 + 459) == (3633 - (641 + 839))) and (v145 == (913 - (910 + 3)))) then
				if ((v84.Felblade:TimeSinceLastCast() < v14:GCD()) or (v84.InfernalStrike:TimeSinceLastCast() < v14:GCD()) or ((1292 - 785) >= (4275 - (1466 + 218)))) then
					local v211 = 0 + 0;
					while true do
						if (((5629 - (556 + 592)) == (1594 + 2887)) and (v211 == (809 - (329 + 479)))) then
							return;
						end
						if (((854 - (174 + 680)) == v211) or ((7999 - 5671) < (1435 - 742))) then
							v92 = true;
							v93 = true;
							v211 = 1 + 0;
						end
					end
				end
				v92 = v15:IsInMeleeRange(744 - (396 + 343));
				v145 = 1 + 0;
			end
		end
	end
	local function v113()
		local v146 = 1477 - (29 + 1448);
		while true do
			if (((5717 - (135 + 1254)) == (16304 - 11976)) and ((4 - 3) == v146)) then
				v29 = v22.HandleBottomTrinket(v87, v32, 27 + 13, nil);
				if (((3115 - (389 + 1138)) >= (1906 - (102 + 472))) and v29) then
					return v29;
				end
				break;
			end
			if ((v146 == (0 + 0)) or ((2315 + 1859) > (3961 + 287))) then
				v29 = v22.HandleTopTrinket(v87, v32, 1585 - (320 + 1225), nil);
				if (v29 or ((8163 - 3577) <= (51 + 31))) then
					return v29;
				end
				v146 = 1465 - (157 + 1307);
			end
		end
	end
	local function v114()
		local v147 = 1859 - (821 + 1038);
		while true do
			if (((9638 - 5775) == (423 + 3440)) and (v147 == (0 - 0))) then
				if ((v41 and ((not v33 and v83) or not v83) and not v14:IsMoving() and v84.SigilOfFlame:IsCastable()) or ((105 + 177) <= (103 - 61))) then
					if (((5635 - (834 + 192)) >= (49 + 717)) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
						if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(3 + 5)) or ((25 + 1127) == (3854 - 1366))) then
							return "sigil_of_flame precombat 2";
						end
					elseif (((3726 - (300 + 4)) > (895 + 2455)) and (v79 == "cursor")) then
						if (((2295 - 1418) > (738 - (112 + 250))) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(12 + 18))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if ((v84.ImmolationAura:IsCastable() and v38) or ((7810 - 4692) <= (1061 + 790))) then
					if (v20(v84.ImmolationAura, not v15:IsInMeleeRange(5 + 3)) or ((124 + 41) >= (1732 + 1760))) then
						return "immolation_aura precombat 4";
					end
				end
				v147 = 1 + 0;
			end
			if (((5363 - (1001 + 413)) < (10828 - 5972)) and (v147 == (883 - (244 + 638)))) then
				if ((v84.InfernalStrike:IsCastable() and v39 and ((not v33 and v82) or not v82) and (v84.InfernalStrike:ChargesFractional() > (694.7 - (627 + 66)))) or ((12740 - 8464) < (3618 - (512 + 90)))) then
					if (((6596 - (1665 + 241)) > (4842 - (373 + 344))) and v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(4 + 4))) then
						return "infernal_strike precombat 6";
					end
				end
				if ((v84.Fracture:IsCastable() and v37 and v92) or ((14 + 36) >= (2363 - 1467))) then
					if (v20(v84.Fracture) or ((2900 - 1186) >= (4057 - (35 + 1064)))) then
						return "fracture precombat 8";
					end
				end
				v147 = 2 + 0;
			end
			if ((v147 == (4 - 2)) or ((6 + 1485) < (1880 - (298 + 938)))) then
				if (((1963 - (233 + 1026)) < (2653 - (636 + 1030))) and v84.Shear:IsCastable() and v40 and v92) then
					if (((1901 + 1817) > (1862 + 44)) and v20(v84.Shear)) then
						return "shear precombat 10";
					end
				end
				break;
			end
		end
	end
	local function v115()
		if ((v84.DemonSpikes:IsCastable() and v60 and v14:BuffDown(v84.DemonSpikesBuff) and v14:BuffDown(v84.MetamorphosisBuff) and (((v97 == (1 + 0)) and v14:BuffDown(v84.FieryBrandDebuff)) or (v97 > (1 + 0)))) or ((1179 - (55 + 166)) > (705 + 2930))) then
			if (((353 + 3148) <= (17155 - 12663)) and (v84.DemonSpikes:ChargesFractional() > (298.9 - (36 + 261)))) then
				if (v20(v84.DemonSpikes) or ((6019 - 2577) < (3916 - (34 + 1334)))) then
					return "demon_spikes defensives (Capped)";
				end
			elseif (((1106 + 1769) >= (1138 + 326)) and (v94 or (v14:HealthPercentage() <= v63))) then
				if (v20(v84.DemonSpikes) or ((6080 - (1035 + 248)) >= (4914 - (20 + 1)))) then
					return "demon_spikes defensives (Danger)";
				end
			end
		end
		if ((v84.Metamorphosis:IsCastable() and v62 and (v14:HealthPercentage() <= v65) and (v14:BuffDown(v84.MetamorphosisBuff) or (v15:TimeToDie() < (8 + 7)))) or ((870 - (134 + 185)) > (3201 - (549 + 584)))) then
			if (((2799 - (314 + 371)) > (3240 - 2296)) and v20(v86.MetamorphosisPlayer)) then
				return "metamorphosis defensives";
			end
		end
		if ((v84.FieryBrand:IsCastable() and v61 and (v15:TimeToDie() > v71) and (v94 or (v14:HealthPercentage() <= v64))) or ((3230 - (478 + 490)) >= (1641 + 1455))) then
			if (v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand)) or ((3427 - (786 + 386)) >= (11456 - 7919))) then
				return "fiery_brand defensives";
			end
		end
		if ((v85.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or ((5216 - (1055 + 324)) < (2646 - (1093 + 247)))) then
			if (((2622 + 328) == (311 + 2639)) and v20(v86.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v74 and (v14:HealthPercentage() <= v76)) or ((18751 - 14028) < (11192 - 7894))) then
			local v158 = 0 - 0;
			while true do
				if (((2854 - 1718) >= (55 + 99)) and (v158 == (0 - 0))) then
					if ((v78 == "Refreshing Healing Potion") or ((934 - 663) > (3581 + 1167))) then
						if (((12122 - 7382) >= (3840 - (364 + 324))) and v85.RefreshingHealingPotion:IsReady()) then
							if (v20(v86.RefreshingHealingPotion) or ((7067 - 4489) >= (8134 - 4744))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((14 + 27) <= (6950 - 5289)) and (v78 == "Dreamwalker's Healing Potion")) then
						if (((962 - 361) < (10812 - 7252)) and v85.DreamwalkersHealingPotion:IsReady()) then
							if (((1503 - (1249 + 19)) < (621 + 66)) and v20(v86.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v148 = 0 - 0;
		while true do
			if (((5635 - (686 + 400)) > (905 + 248)) and (v148 == (232 - (73 + 156)))) then
				if ((v37 and v84.Fracture:IsCastable() and (v84.FelDevastation:CooldownRemains() <= (v84.Fracture:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1 + 49))) or ((5485 - (721 + 90)) < (53 + 4619))) then
					if (((11909 - 8241) < (5031 - (224 + 246))) and v20(v84.Fracture, not v92)) then
						return "fracture maintenance 14";
					end
				end
				if ((v40 and v84.Shear:IsCastable() and (v84.FelDevastation:CooldownRemains() <= (v84.Fracture:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (81 - 31))) or ((837 - 382) == (654 + 2951))) then
					if (v20(v84.Shear, not v92) or ((64 + 2599) == (2433 + 879))) then
						return "shear maintenance 16";
					end
				end
				v148 = 7 - 3;
			end
			if (((14232 - 9955) <= (4988 - (203 + 310))) and (v148 == (1995 - (1238 + 755)))) then
				if ((v43 and v84.SpiritBomb:IsReady() and v103) or ((61 + 809) == (2723 - (709 + 825)))) then
					if (((2861 - 1308) <= (4563 - 1430)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(872 - (196 + 668)))) then
						return "spirit_bomb maintenance 10";
					end
				end
				if ((v36 and v84.Felblade:IsReady() and (((not v84.SpiritBomb:IsAvailable() or (v97 == (3 - 2))) and (v14:FuryDeficit() >= (82 - 42))) or ((v84.FelDevastation:CooldownRemains() <= (v84.Felblade:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (883 - (171 + 662)))))) or ((2330 - (4 + 89)) >= (12305 - 8794))) then
					if (v20(v84.Felblade, not v92) or ((483 + 841) > (13264 - 10244))) then
						return "felblade maintenance 12";
					end
				end
				v148 = 2 + 1;
			end
			if ((v148 == (1487 - (35 + 1451))) or ((4445 - (28 + 1425)) == (3874 - (941 + 1052)))) then
				if (((2979 + 127) > (3040 - (822 + 692))) and v38 and v84.ImmolationAura:IsCastable()) then
					if (((4314 - 1291) < (1823 + 2047)) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(305 - (45 + 252)))) then
						return "immolation_aura maintenance 6";
					end
				end
				if (((142 + 1) > (26 + 48)) and v34 and v84.BulkExtraction:IsCastable() and (((12 - 7) - v88) <= v97) and (v88 <= (435 - (114 + 319)))) then
					if (((25 - 7) < (2705 - 593)) and v20(v84.BulkExtraction, not v92)) then
						return "bulk_extraction maintenance 8";
					end
				end
				v148 = 2 + 0;
			end
			if (((1633 - 536) <= (3410 - 1782)) and (v148 == (1967 - (556 + 1407)))) then
				if (((5836 - (741 + 465)) == (5095 - (170 + 295))) and v43 and v84.SpiritBomb:IsReady() and (v14:FuryDeficit() <= (16 + 14)) and (v97 > (1 + 0)) and (v88 >= (9 - 5))) then
					if (((2935 + 605) > (1721 + 962)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(5 + 3))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if (((6024 - (957 + 273)) >= (876 + 2399)) and v42 and v84.SoulCleave:IsReady() and not v104 and (v14:FuryDeficit() <= (17 + 23))) then
					if (((5654 - 4170) == (3910 - 2426)) and v20(v84.SoulCleave, not v92)) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if (((4373 - 2941) < (17603 - 14048)) and (v148 == (1780 - (389 + 1391)))) then
				if ((v61 and v80 and (v15:TimeToDie() > v71) and v84.FieryBrand:IsCastable() and (((v84.FieryBrandDebuff:AuraActiveCount() == (0 + 0)) and ((v84.SigilOfFlame:CooldownRemains() <= (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())) or (v84.SoulCarver:CooldownRemains() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())) or (v84.FelDevastation:CooldownRemains() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())))) or (v84.DownInFlames:IsAvailable() and (v84.FieryBrand:FullRechargeTime() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) or ((111 + 954) > (8145 - 4567))) then
					if (v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand)) or ((5746 - (783 + 168)) < (4722 - 3315))) then
						return "fiery_brand maintenance 2";
					end
				end
				if (((1823 + 30) < (5124 - (309 + 2))) and v41 and v84.SigilOfFlame:IsCastable() and ((not v33 and v83) or not v83) and (v84.AscendingFlame:IsAvailable() or (v84.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) then
					if (v84.ConcentratedSigils:IsAvailable() or (v79 == "player") or ((4033 - (1090 + 122)) < (789 + 1642))) then
						if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(26 - 18)) or ((1967 + 907) < (3299 - (628 + 490)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v79 == "cursor") or ((483 + 2206) <= (849 - 506))) then
						if (v20(v86.SigilOfFlameCursor, not v15:IsInRange(137 - 107)) or ((2643 - (431 + 343)) == (4057 - 2048))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v148 = 2 - 1;
			end
		end
	end
	local function v117()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (1 + 0)) or ((5241 - (556 + 1139)) < (2337 - (6 + 9)))) then
				if ((v36 and v84.Felblade:IsReady() and (not v84.SpiritBomb:IsAvailable() or (v84.FelDevastation:CooldownRemains() <= (v84.Felblade:ExecuteTime() + v14:GCDRemains()))) and (v14:Fury() < (10 + 40))) or ((1067 + 1015) == (4942 - (28 + 141)))) then
					if (((1257 + 1987) > (1302 - 247)) and v20(v84.Felblade, not v92)) then
						return "felblade fiery_demise 6";
					end
				end
				if ((v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106) and v84.FelDevastation:IsReady()) or ((2347 + 966) <= (3095 - (486 + 831)))) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(20 - 12)) or ((5002 - 3581) >= (398 + 1706))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v149 = 6 - 4;
			end
			if (((3075 - (668 + 595)) <= (2924 + 325)) and (v149 == (1 + 1))) then
				if (((4425 - 2802) <= (2247 - (23 + 267))) and v52 and v84.SoulCarver:IsCastable() and (v89 < (1947 - (1129 + 815))) and ((v32 and v56) or not v56) and (v71 < v106)) then
					if (((4799 - (371 + 16)) == (6162 - (1326 + 424))) and v20(v84.SoulCarver, not v92)) then
						return "soul_carver fiery_demise 10";
					end
				end
				if (((3314 - 1564) >= (3076 - 2234)) and v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) then
					if (((4490 - (88 + 30)) > (2621 - (720 + 51))) and v20(v84.TheHunt, not v15:IsInRange(66 - 36))) then
						return "the_hunt fiery_demise 12";
					end
				end
				v149 = 1779 - (421 + 1355);
			end
			if (((381 - 149) < (404 + 417)) and (v149 == (1083 - (286 + 797)))) then
				if (((1893 - 1375) < (1493 - 591)) and v38 and v84.ImmolationAura:IsCastable()) then
					if (((3433 - (397 + 42)) > (268 + 590)) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(808 - (24 + 776)))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if ((v41 and v84.SigilOfFlame:IsCastable() and (v84.AscendingFlame:IsAvailable() or (v84.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) or ((4540 - (222 + 563)) <= (2016 - 1101))) then
					if (((2842 + 1104) > (3933 - (23 + 167))) and (v84.ConcentratedSigils:IsAvailable() or (v79 == "player"))) then
						if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(1806 - (690 + 1108))) or ((482 + 853) >= (2727 + 579))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif (((5692 - (40 + 808)) > (371 + 1882)) and (v79 == "cursor")) then
						if (((1728 - 1276) == (433 + 19)) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(16 + 14))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				v149 = 1 + 0;
			end
			if (((574 - (47 + 524)) == v149) or ((2958 + 1599) < (5704 - 3617))) then
				if (((5792 - 1918) == (8834 - 4960)) and v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (1727.85 - (1165 + 561))) and (v14:Fury() >= (2 + 38)) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
					if ((v58 == "player") or ((6002 - 4064) > (1883 + 3052))) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(487 - (341 + 138))) or ((1149 + 3106) < (7063 - 3640))) then
							return "elysian_decree fiery_demise 14 (Player)";
						end
					elseif (((1780 - (89 + 237)) <= (8013 - 5522)) and (v58 == "cursor")) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(63 - 33)) or ((5038 - (581 + 300)) <= (4023 - (855 + 365)))) then
							return "elysian_decree fiery_demise 14 (Cursor)";
						end
					end
				end
				if (((11526 - 6673) >= (974 + 2008)) and v84.SpiritBomb:IsReady() and v43 and v103) then
					if (((5369 - (1030 + 205)) > (3152 + 205)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(8 + 0))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v150 = 286 - (156 + 130);
		while true do
			if ((v150 == (2 - 1)) or ((5758 - 2341) < (5189 - 2655))) then
				if ((v84.SigilOfSilence:IsCastable() and (v84.CycleofBinding:IsAvailable()) and v47) or ((718 + 2004) <= (96 + 68))) then
					if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((2477 - (10 + 59)) < (597 + 1512))) then
						if (v20(v86.SigilOfSilencePlayer, not v15:IsInMeleeRange(39 - 31)) or ((1196 - (671 + 492)) == (1159 + 296))) then
							return "sigil_of_silence player filler 6";
						end
					elseif ((v79 == "cursor") or ((1658 - (369 + 846)) >= (1063 + 2952))) then
						if (((2887 + 495) > (2111 - (1036 + 909))) and v20(v86.SigilOfSilenceCursor, not v15:IsInRange(24 + 6))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v84.Felblade:IsReady() and v36) or ((470 - 190) == (3262 - (11 + 192)))) then
					if (((951 + 930) > (1468 - (135 + 40))) and v20(v84.Felblade, not v92)) then
						return "felblade filler 8";
					end
				end
				v150 = 4 - 2;
			end
			if (((1421 + 936) == (5192 - 2835)) and (v150 == (0 - 0))) then
				if (((299 - (50 + 126)) == (342 - 219)) and v84.SigilOfChains:IsCastable() and v48 and (v84.CycleofBinding:IsAvailable())) then
					if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((234 + 822) >= (4805 - (1233 + 180)))) then
						if (v20(v86.SigilOfChainsPlayer, not v15:IsInMeleeRange(977 - (522 + 447))) or ((2502 - (107 + 1314)) < (499 + 576))) then
							return "sigil_of_chains player filler 2";
						end
					elseif ((v79 == "cursor") or ((3196 - 2147) >= (1883 + 2549))) then
						if (v20(v86.SigilOfChainsCursor, not v15:IsInRange(59 - 29)) or ((18865 - 14097) <= (2756 - (716 + 1194)))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if ((v84.SigilOfMisery:IsCastable() and (v84.CycleofBinding:IsAvailable()) and v49) or ((58 + 3300) <= (153 + 1267))) then
					if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((4242 - (74 + 429)) <= (5796 - 2791))) then
						if (v20(v86.SigilOfMiseryPlayer, not v15:IsInMeleeRange(4 + 4)) or ((3797 - 2138) >= (1510 + 624))) then
							return "sigil_of_misery player filler 4";
						end
					elseif ((v79 == "cursor") or ((10050 - 6790) < (5822 - 3467))) then
						if (v20(v86.SigilOfMiseryCursor, not v15:IsInRange(463 - (279 + 154))) or ((1447 - (454 + 324)) == (3323 + 900))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v150 = 18 - (12 + 5);
			end
			if (((2 + 0) == v150) or ((4310 - 2618) < (218 + 370))) then
				if ((v84.Shear:IsCastable() and v40) or ((5890 - (277 + 816)) < (15600 - 11949))) then
					if (v20(v84.Shear, not v92) or ((5360 - (1058 + 125)) > (910 + 3940))) then
						return "shear filler 10";
					end
				end
				if ((v84.ThrowGlaive:IsCastable() and v44) or ((1375 - (815 + 160)) > (4766 - 3655))) then
					if (((7242 - 4191) > (240 + 765)) and v20(v84.ThrowGlaive, not v15:IsInRange(87 - 57))) then
						return "throw_glaive filler 12";
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v151 = 1898 - (41 + 1857);
		while true do
			if (((5586 - (1222 + 671)) <= (11325 - 6943)) and (v151 == (1 - 0))) then
				if ((v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable())) and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((4464 - (229 + 953)) > (5874 - (1111 + 663)))) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(1599 - (874 + 705))) or ((502 + 3078) < (1941 + 903))) then
						return "fel_devastation single_target 6";
					end
				end
				if (((184 - 95) < (127 + 4363)) and v84.ElysianDecree:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
					if ((v58 == "player") or ((5662 - (642 + 37)) < (413 + 1395))) then
						if (((613 + 3216) > (9462 - 5693)) and v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(484 - (233 + 221)))) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif (((3433 - 1948) <= (2557 + 347)) and (v58 == "cursor")) then
						if (((5810 - (718 + 823)) == (2687 + 1582)) and v20(v86.ElysianDecreeCursor, not v15:IsInRange(835 - (266 + 539)))) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				v151 = 5 - 3;
			end
			if (((1612 - (636 + 589)) <= (6603 - 3821)) and (v151 == (0 - 0))) then
				if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) or ((1505 + 394) <= (334 + 583))) then
					if (v20(v84.TheHunt, not v15:IsInRange(1065 - (657 + 358))) or ((11416 - 7104) <= (1995 - 1119))) then
						return "the_hunt single_target 2";
					end
				end
				if (((3419 - (1151 + 36)) <= (2507 + 89)) and v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56) and (v71 < v106)) then
					if (((551 + 1544) < (11007 - 7321)) and v20(v84.SoulCarver, not v92)) then
						return "soul_carver single_target 4";
					end
				end
				v151 = 1833 - (1552 + 280);
			end
			if ((v151 == (838 - (64 + 770))) or ((1083 + 512) >= (10156 - 5682))) then
				if (v29 or ((821 + 3798) < (4125 - (157 + 1086)))) then
					return v29;
				end
				break;
			end
			if ((v151 == (5 - 2)) or ((1287 - 993) >= (7410 - 2579))) then
				if (((2768 - 739) <= (3903 - (599 + 220))) and v84.Fracture:IsCastable() and v37) then
					if (v20(v84.Fracture, not v92) or ((4056 - 2019) == (4351 - (1813 + 118)))) then
						return "fracture single_target 14";
					end
				end
				v29 = v118();
				v151 = 3 + 1;
			end
			if (((5675 - (841 + 376)) > (5470 - 1566)) and (v151 == (1 + 1))) then
				if (((1190 - 754) >= (982 - (464 + 395))) and v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) then
					if (((1283 - 783) < (873 + 943)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(857 - (467 + 370)))) then
						return "fel_devastation single_target 10";
					end
				end
				if (((7385 - 3811) == (2624 + 950)) and v84.SoulCleave:IsReady() and not v98 and v42) then
					if (((757 - 536) < (61 + 329)) and v20(v84.SoulCleave, not v92)) then
						return "soul_cleave single_target 12";
					end
				end
				v151 = 6 - 3;
			end
		end
	end
	local function v120()
		local v152 = 520 - (150 + 370);
		while true do
			if ((v152 == (1285 - (74 + 1208))) or ((5443 - 3230) <= (6739 - 5318))) then
				if (((2176 + 882) < (5250 - (14 + 376))) and v84.Fracture:IsCastable() and v37) then
					if (v20(v84.Fracture, not v92) or ((2247 - 951) >= (2877 + 1569))) then
						return "fracture small_aoe 14";
					end
				end
				v29 = v118();
				v152 = 4 + 0;
			end
			if ((v152 == (1 + 0)) or ((4081 - 2688) > (3378 + 1111))) then
				if ((v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (79.85 - (23 + 55))) and (v14:Fury() >= (94 - 54)) and ((v89 <= (1 + 0)) or (v89 >= (4 + 0))) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) or ((6858 - 2434) < (9 + 18))) then
					if ((v58 == "player") or ((2898 - (652 + 249)) > (10209 - 6394))) then
						if (((5333 - (708 + 1160)) > (5192 - 3279)) and v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(54 - 24))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif (((760 - (10 + 17)) < (409 + 1410)) and (v58 == "cursor")) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(1762 - (1400 + 332))) or ((8429 - 4034) == (6663 - (242 + 1666)))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				if ((v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((1624 + 2169) < (869 + 1500))) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(18 + 2)) or ((5024 - (850 + 90)) == (463 - 198))) then
						return "fel_devastation small_aoe 8";
					end
				end
				v152 = 1392 - (360 + 1030);
			end
			if (((3857 + 501) == (12300 - 7942)) and (v152 == (0 - 0))) then
				if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) or ((4799 - (909 + 752)) < (2216 - (109 + 1114)))) then
					if (((6096 - 2766) > (905 + 1418)) and v20(v84.TheHunt, not v15:IsInRange(292 - (6 + 236)))) then
						return "the_hunt small_aoe 2";
					end
				end
				if ((v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable())) and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((2285 + 1341) == (3211 + 778))) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(47 - 27)) or ((1599 - 683) == (3804 - (1076 + 57)))) then
						return "fel_devastation small_aoe 4";
					end
				end
				v152 = 1 + 0;
			end
			if (((961 - (579 + 110)) == (22 + 250)) and ((2 + 0) == v152)) then
				if (((2256 + 1993) <= (5246 - (174 + 233))) and v84.SoulCarver:IsCastable() and (v89 < (8 - 5)) and v52 and ((v32 and v56) or not v56) and (v71 < v106)) then
					if (((4873 - 2096) < (1423 + 1777)) and v20(v84.SoulCarver, not v92)) then
						return "soul_carver small_aoe 10";
					end
				end
				if (((1269 - (663 + 511)) < (1746 + 211)) and v84.SoulCleave:IsReady() and ((v88 <= (1 + 0)) or not v84.SpiritBomb:IsAvailable()) and not v98 and v42) then
					if (((2546 - 1720) < (1040 + 677)) and v20(v84.SoulCleave, not v92)) then
						return "soul_cleave small_aoe 12";
					end
				end
				v152 = 6 - 3;
			end
			if (((3451 - 2025) >= (528 + 577)) and (v152 == (7 - 3))) then
				if (((1963 + 791) <= (309 + 3070)) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v121()
		if ((v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or v84.StoketheFlames:IsAvailable()) and v51 and ((v32 and v55) or not v55) and (v71 < v106) and ((not v33 and v82) or not v82)) or ((4649 - (478 + 244)) == (1930 - (440 + 77)))) then
			if (v20(v84.FelDevastation, not v15:IsInMeleeRange(10 + 10)) or ((4223 - 3069) <= (2344 - (655 + 901)))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) or ((305 + 1338) > (2587 + 792))) then
			if (v20(v84.TheHunt, not v15:IsInRange(34 + 16)) or ((11292 - 8489) > (5994 - (695 + 750)))) then
				return "the_hunt big_aoe 4";
			end
		end
		if ((v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (3.85 - 2)) and (v14:Fury() >= (61 - 21)) and ((v89 <= (3 - 2)) or (v89 >= (355 - (285 + 66)))) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) or ((512 - 292) >= (4332 - (682 + 628)))) then
			if (((455 + 2367) == (3121 - (176 + 123))) and (v58 == "player")) then
				if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(13 + 17)) or ((770 + 291) == (2126 - (239 + 30)))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif (((751 + 2009) > (1311 + 53)) and (v58 == "cursor")) then
				if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(53 - 23)) or ((15293 - 10391) <= (3910 - (306 + 9)))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if ((v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((13441 - 9589) == (51 + 242))) then
			if (v20(v84.FelDevastation, not v15:IsInMeleeRange(13 + 7)) or ((751 + 808) == (13119 - 8531))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if ((v84.SoulCarver:IsCastable() and (v89 < (1378 - (1140 + 235))) and v52 and ((v32 and v56) or not v56) and (v71 < v106)) or ((2854 + 1630) == (723 + 65))) then
			if (((1173 + 3395) >= (3959 - (33 + 19))) and v20(v84.SoulCarver, not v92)) then
				return "soul_carver big_aoe 10";
			end
		end
		if (((450 + 796) < (10400 - 6930)) and v84.SpiritBomb:IsReady() and (v88 >= (2 + 2)) and v43) then
			if (((7977 - 3909) >= (912 + 60)) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(697 - (586 + 103)))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if (((45 + 448) < (11985 - 8092)) and v84.SoulCleave:IsReady() and (not v84.SpiritBomb:IsAvailable() or not v98) and v42) then
			if (v20(v84.SoulCleave, not v92) or ((2961 - (1309 + 179)) >= (6014 - 2682))) then
				return "soul_cleave big_aoe 14";
			end
		end
		if ((v84.Fracture:IsCastable() and v37) or ((1764 + 2287) <= (3107 - 1950))) then
			if (((457 + 147) < (6121 - 3240)) and v20(v84.Fracture, not v92)) then
				return "fracture big_aoe 16";
			end
		end
		if ((v84.SoulCleave:IsReady() and not v98 and v42) or ((1793 - 893) == (3986 - (295 + 314)))) then
			if (((10951 - 6492) > (2553 - (1300 + 662))) and v20(v84.SoulCleave, not v92)) then
				return "soul_cleave big_aoe 18";
			end
		end
		v29 = v118();
		if (((10670 - 7272) >= (4150 - (1178 + 577))) and v29) then
			return v29;
		end
	end
	local function v122()
		local v153 = 0 + 0;
		while true do
			if (((8 - 5) == v153) or ((3588 - (851 + 554)) >= (2498 + 326))) then
				v46 = EpicSettings.Settings['useDisrupt'];
				v47 = EpicSettings.Settings['useSigilOfSilence'];
				v48 = EpicSettings.Settings['useSigilOfChains'];
				v49 = EpicSettings.Settings['useSigilOfMisery'];
				v153 = 10 - 6;
			end
			if (((4204 - 2268) == (2238 - (115 + 187))) and ((4 + 1) == v153)) then
				v54 = EpicSettings.Settings['elysianDecreeWithCD'];
				v55 = EpicSettings.Settings['felDevastationWithCD'];
				v56 = EpicSettings.Settings['soulCarverWithCD'];
				v57 = EpicSettings.Settings['theHuntWithCD'];
				v153 = 6 + 0;
			end
			if ((v153 == (7 - 5)) or ((5993 - (160 + 1001)) < (3774 + 539))) then
				v42 = EpicSettings.Settings['useSoulCleave'];
				v43 = EpicSettings.Settings['useSpiritBomb'];
				v44 = EpicSettings.Settings['useThrowGlaive'];
				v45 = EpicSettings.Settings['useChaosNova'];
				v153 = 3 + 0;
			end
			if (((8368 - 4280) > (4232 - (237 + 121))) and (v153 == (897 - (525 + 372)))) then
				v34 = EpicSettings.Settings['useBulkExtraction'];
				v35 = EpicSettings.Settings['useConsumeMagic'];
				v36 = EpicSettings.Settings['useFelblade'];
				v37 = EpicSettings.Settings['useFracture'];
				v153 = 1 - 0;
			end
			if (((14233 - 9901) == (4474 - (96 + 46))) and (v153 == (778 - (643 + 134)))) then
				v38 = EpicSettings.Settings['useImmolationAura'];
				v39 = EpicSettings.Settings['useInfernalStrike'];
				v40 = EpicSettings.Settings['useShear'];
				v41 = EpicSettings.Settings['useSigilOfFlame'];
				v153 = 1 + 1;
			end
			if (((9588 - 5589) >= (10766 - 7866)) and (v153 == (7 + 0))) then
				v64 = EpicSettings.Settings['fieryBrandHP'] or (0 - 0);
				v65 = EpicSettings.Settings['metamorphosisHP'] or (0 - 0);
				v79 = EpicSettings.Settings['sigilSetting'] or "player";
				v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v153 = 727 - (316 + 403);
			end
			if ((v153 == (3 + 1)) or ((6942 - 4417) > (1469 + 2595))) then
				v50 = EpicSettings.Settings['useElysianDecree'];
				v51 = EpicSettings.Settings['useFelDevastation'];
				v52 = EpicSettings.Settings['useSoulCarver'];
				v53 = EpicSettings.Settings['useTheHunt'];
				v153 = 12 - 7;
			end
			if (((3098 + 1273) == (1409 + 2962)) and (v153 == (20 - 14))) then
				v60 = EpicSettings.Settings['useDemonSpikes'];
				v61 = EpicSettings.Settings['useFieryBrand'];
				v62 = EpicSettings.Settings['useMetamorphosis'];
				v63 = EpicSettings.Settings['demonSpikesHP'] or (0 - 0);
				v153 = 14 - 7;
			end
			if ((v153 == (1 + 7)) or ((523 - 257) > (244 + 4742))) then
				v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				v80 = EpicSettings.Settings['fieryBrandOffensively'];
				v81 = EpicSettings.Settings['metamorphosisOffensively'];
				break;
			end
		end
	end
	local function v123()
		local v154 = 17 - (12 + 5);
		while true do
			if (((7733 - 5742) >= (1973 - 1048)) and (v154 == (6 - 3))) then
				v67 = EpicSettings.Settings['HandleIncorporeal'];
				v83 = EpicSettings.Settings['RMBAOE'];
				v82 = EpicSettings.Settings['RMBMovement'];
				break;
			end
			if (((1128 - 673) < (417 + 1636)) and (v154 == (1975 - (1656 + 317)))) then
				v74 = EpicSettings.Settings['useHealingPotion'];
				v77 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v76 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v154 = 7 - 4;
			end
			if ((v154 == (0 - 0)) or ((1180 - (5 + 349)) == (23041 - 18190))) then
				v71 = EpicSettings.Settings['fightRemainsCheck'] or (1271 - (266 + 1005));
				v66 = EpicSettings.Settings['dispelBuffs'];
				v68 = EpicSettings.Settings['InterruptWithStun'];
				v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v154 = 1 + 0;
			end
			if (((624 - 441) == (240 - 57)) and (v154 == (1697 - (561 + 1135)))) then
				v70 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['useTrinkets'];
				v73 = EpicSettings.Settings['trinketsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v154 = 2 - 0;
			end
		end
	end
	local function v124()
		local v155 = 0 - 0;
		while true do
			if (((2225 - (507 + 559)) <= (4486 - 2698)) and (v155 == (6 - 4))) then
				if (v31 or ((3895 - (212 + 176)) > (5223 - (250 + 655)))) then
					v97 = #v96;
				else
					v97 = 2 - 1;
				end
				v112();
				v94 = v14:ActiveMitigationNeeded();
				v95 = v14:IsTankingAoE(13 - 5) or v14:IsTanking(v15);
				v155 = 4 - 1;
			end
			if ((v155 == (1957 - (1869 + 87))) or ((10665 - 7590) <= (4866 - (484 + 1417)))) then
				v32 = EpicSettings.Toggles['cds'];
				if (((2925 - 1560) <= (3370 - 1359)) and v14:IsDeadOrGhost()) then
					return v29;
				end
				if (IsMouseButtonDown("RightButton") or ((3549 - (48 + 725)) > (5840 - 2265))) then
					v33 = true;
				else
					v33 = false;
				end
				v96 = v14:GetEnemiesInMeleeRange(21 - 13);
				v155 = 2 + 0;
			end
			if (((7 - 4) == v155) or ((715 + 1839) == (1401 + 3403))) then
				if (((3430 - (152 + 701)) == (3888 - (430 + 881))) and (v22.TargetIsValid() or v14:AffectingCombat())) then
					v105 = v10.BossFightRemains(nil, true);
					v106 = v105;
					if ((v106 == (4256 + 6855)) or ((901 - (557 + 338)) >= (559 + 1330))) then
						v106 = v10.FightRemains(v96, false);
					end
				end
				v88 = v108.AuraSouls;
				v90 = v108.IncomingSouls;
				v89 = v88 + v90;
				v155 = 10 - 6;
			end
			if (((1771 - 1265) <= (5026 - 3134)) and ((8 - 4) == v155)) then
				if (v67 or ((2809 - (499 + 302)) > (3084 - (39 + 827)))) then
					v29 = v22.HandleIncorporeal(v84.Imprison, v86.ImprisonMouseover, 55 - 35);
					if (((845 - 466) <= (16471 - 12324)) and v29) then
						return v29;
					end
				end
				if ((v22.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((6930 - 2416) <= (87 + 922))) then
					local v212 = 0 - 0;
					local v213;
					while true do
						if ((v212 == (1 + 3)) or ((5531 - 2035) == (1296 - (103 + 1)))) then
							if ((v71 < v106) or ((762 - (475 + 79)) == (6396 - 3437))) then
								if (((13686 - 9409) >= (170 + 1143)) and v72 and ((v32 and v73) or not v73)) then
									v29 = v113();
									if (((2277 + 310) < (4677 - (1395 + 108))) and v29) then
										return v29;
									end
								end
							end
							if ((v84.FieryBrand:IsAvailable() and v84.FieryDemise:IsAvailable() and (v84.FieryBrandDebuff:AuraActiveCount() > (0 - 0))) or ((5324 - (7 + 1197)) <= (959 + 1239))) then
								local v215 = 0 + 0;
								while true do
									if (((319 - (27 + 292)) == v215) or ((4676 - 3080) == (1093 - 235))) then
										v29 = v117();
										if (((13504 - 10284) == (6350 - 3130)) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							v29 = v116();
							if (v29 or ((2669 - 1267) > (3759 - (43 + 96)))) then
								return v29;
							end
							v212 = 20 - 15;
						end
						if (((5819 - 3245) == (2136 + 438)) and (v212 == (0 + 0))) then
							v99 = v84.FieryBrand:IsAvailable() and v84.FieryDemise:IsAvailable() and (v84.FieryBrandDebuff:AuraActiveCount() > (0 - 0));
							v100 = v97 == (1 + 0);
							v101 = (v97 >= (3 - 1)) and (v97 <= (2 + 3));
							v102 = v97 >= (1 + 5);
							v212 = 1752 - (1414 + 337);
						end
						if (((3738 - (1642 + 298)) < (7187 - 4430)) and (v212 == (2 - 1))) then
							v98 = ((v84.FelDevastation:CooldownRemains() <= (v84.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (237 - 157))) or (((v90 > (1 + 0)) or (v89 >= (4 + 1))) and not v100);
							if (v99 or ((1349 - (357 + 615)) > (1828 + 776))) then
								v103 = (v100 and (v88 >= (11 - 6))) or (v101 and (v88 >= (4 + 0))) or (v102 and (v88 >= (6 - 3)));
							else
								v103 = (v101 and (v88 >= (4 + 1))) or (v102 and (v88 >= (1 + 3)));
							end
							if (((358 + 210) < (2212 - (384 + 917))) and v99) then
								v104 = (v100 and (v89 >= (702 - (128 + 569)))) or (v101 and (v89 >= (1547 - (1407 + 136)))) or (v102 and (v89 >= (1890 - (687 + 1200))));
							else
								v104 = (v101 and (v89 >= (1715 - (556 + 1154)))) or (v102 and (v89 >= (14 - 10)));
							end
							if (((3380 - (9 + 86)) < (4649 - (275 + 146))) and v84.ThrowGlaive:IsCastable() and v44 and v12.ValueIsInArray(v107, v15:NPCID())) then
								if (((637 + 3279) > (3392 - (29 + 35))) and v20(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive))) then
									return "fodder to the flames on those filthy demons";
								end
							end
							v212 = 8 - 6;
						end
						if (((7467 - 4967) < (16947 - 13108)) and (v212 == (2 + 1))) then
							if (((1519 - (53 + 959)) == (915 - (312 + 96))) and v84.InfernalStrike:IsCastable() and v39 and (v84.InfernalStrike:ChargesFractional() > (1.7 - 0)) and (v84.InfernalStrike:TimeSinceLastCast() > (287 - (147 + 138)))) then
								if (((1139 - (813 + 86)) <= (2861 + 304)) and v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(14 - 6))) then
									return "infernal_strike main 2";
								end
							end
							if (((1326 - (18 + 474)) >= (272 + 533)) and (v71 < v106) and v84.Metamorphosis:IsCastable() and v62 and v81 and v14:BuffDown(v84.MetamorphosisBuff) and (v84.FelDevastation:CooldownRemains() > (39 - 27))) then
								if (v20(v86.MetamorphosisPlayer, not v92) or ((4898 - (860 + 226)) < (2619 - (121 + 182)))) then
									return "metamorphosis main 4";
								end
							end
							v213 = v22.HandleDPSPotion();
							if (v213 or ((327 + 2325) <= (2773 - (988 + 252)))) then
								return v213;
							end
							v212 = 1 + 3;
						end
						if ((v212 == (1 + 1)) or ((5568 - (49 + 1921)) < (2350 - (223 + 667)))) then
							if ((v84.ThrowGlaive:IsReady() and v44 and v12.ValueIsInArray(v107, v16:NPCID())) or ((4168 - (51 + 1)) < (2051 - 859))) then
								if (v20(v86.ThrowGlaiveMouseover, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((7230 - 3853) <= (2028 - (146 + 979)))) then
									return "fodder to the flames react per mouseover";
								end
							end
							if (((1123 + 2853) >= (1044 - (311 + 294))) and not v14:AffectingCombat() and v30) then
								v29 = v114();
								if (((10463 - 6711) == (1590 + 2162)) and v29) then
									return v29;
								end
							end
							if (((5489 - (496 + 947)) > (4053 - (1233 + 125))) and v84.ConsumeMagic:IsAvailable() and v35 and v84.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v22.UnitHasMagicBuff(v15)) then
								if (v20(v84.ConsumeMagic, not v15:IsSpellInRange(v84.ConsumeMagic)) or ((1439 + 2106) == (2869 + 328))) then
									return "greater_purge damage";
								end
							end
							if (((455 + 1939) > (2018 - (963 + 682))) and v95) then
								local v216 = 0 + 0;
								while true do
									if (((5659 - (504 + 1000)) <= (2850 + 1382)) and (v216 == (0 + 0))) then
										v29 = v115();
										if (v29 or ((338 + 3243) == (5121 - 1648))) then
											return v29;
										end
										break;
									end
								end
							end
							v212 = 3 + 0;
						end
						if (((2905 + 2090) > (3530 - (156 + 26))) and (v212 == (3 + 2))) then
							if (v100 or ((1179 - 425) > (3888 - (149 + 15)))) then
								local v217 = 960 - (890 + 70);
								while true do
									if (((334 - (39 + 78)) >= (539 - (14 + 468))) and (v217 == (0 - 0))) then
										v29 = v119();
										if (v29 or ((5785 - 3715) >= (2083 + 1954))) then
											return v29;
										end
										break;
									end
								end
							end
							if (((1625 + 1080) == (575 + 2130)) and v101) then
								local v218 = 0 + 0;
								while true do
									if (((16 + 45) == (116 - 55)) and ((0 + 0) == v218)) then
										v29 = v120();
										if (v29 or ((2455 - 1756) >= (33 + 1263))) then
											return v29;
										end
										break;
									end
								end
							end
							if (v102 or ((1834 - (12 + 39)) >= (3365 + 251))) then
								local v219 = 0 - 0;
								while true do
									if (((0 - 0) == v219) or ((1161 + 2752) > (2383 + 2144))) then
										v29 = v121();
										if (((11096 - 6720) > (545 + 272)) and v29) then
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
				break;
			end
			if (((23492 - 18631) > (2534 - (1596 + 114))) and (v155 == (0 - 0))) then
				v122();
				v123();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v155 = 714 - (164 + 549);
			end
		end
	end
	local function v125()
		v19.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v84.FieryBrandDebuff:RegisterAuraTracking();
		v84.SigilOfFlameDebuff:RegisterAuraTracking();
	end
	v19.SetAPL(2019 - (1059 + 379), v124, v125);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

