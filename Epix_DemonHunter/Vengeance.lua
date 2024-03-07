local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 683 - (27 + 656);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((318 + 552) >= (1703 + 1373))) then
			return v6(...);
		end
		if (((287 + 1342) > (2225 - 1023)) and (v5 == (1911 - (340 + 1571)))) then
			v6 = v0[v4];
			if (((398 + 610) < (5483 - (1733 + 39))) and not v6) then
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
	local v91 = ((v84.SoulSigils:IsAvailable()) and (1038 - (125 + 909))) or (1951 - (1096 + 852));
	local v92, v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98, v99, v100, v101, v102, v103, v104;
	local v105 = 4985 + 6126;
	local v106 = 15867 - 4756;
	local v107 = {(169933 - (409 + 103)),(169520 - (51 + 44)),(170249 - (1114 + 203)),(36707 + 132719),(170092 - (174 + 489)),(171333 - (830 + 1075)),(170699 - (231 + 1038))};
	v10:RegisterForEvent(function()
		v105 = 9259 + 1852;
		v106 = 12273 - (171 + 991);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v91 = ((v84.SoulSigils:IsAvailable()) and (16 - 12)) or (7 - 4);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v108 = {};
	local v109 = v108;
	v109.AuraSouls = 0 - 0;
	v109.IncomingSouls = 0 + 0;
	v10:RegisterForSelfCombatEvent(function(...)
		local v126 = 0 - 0;
		local v127;
		local v128;
		while true do
			if ((v126 == (0 - 0)) or ((1690 - 641) <= (2800 - 1894))) then
				v127 = select(1260 - (111 + 1137), ...);
				v128 = 158 - (91 + 67);
				v126 = 2 - 1;
			end
			if (((1127 + 3386) > (3249 - (423 + 100))) and (v126 == (1 + 0))) then
				if ((v127 == v84.Fracture:ID()) or (v127 == v84.Shear:ID()) or ((4100 - 2619) >= (1386 + 1272))) then
					v128 = 773 - (326 + 445);
				elseif ((v127 == v84.SoulCarver:ID()) or ((14051 - 10831) == (3038 - 1674))) then
					v128 = 6 - 3;
					C_Timer.After(712 - (530 + 181), function()
						v109.IncomingSouls = v109.IncomingSouls + (882 - (614 + 267));
					end);
					C_Timer.After(34 - (19 + 13), function()
						v109.IncomingSouls = v109.IncomingSouls + (1 - 0);
					end);
					C_Timer.After(6 - 3, function()
						v109.IncomingSouls = v109.IncomingSouls + (2 - 1);
					end);
				elseif ((v127 == v84.ElysianDecree:ID()) or ((274 + 780) > (5964 - 2572))) then
					v128 = ((v84.SoulSigils:IsAvailable()) and (7 - 3)) or (1815 - (1293 + 519));
				elseif ((v84.SoulSigils:IsAvailable() and ((v127 == v84.SigilOfFlame:ID()) or (v127 == v84.SigilOfMisery:ID()) or (v127 == v84.SigilOfChains:ID()) or (v127 == v84.SigilOfSilence:ID()))) or ((1378 - 702) >= (4286 - 2644))) then
					v128 = 1 - 0;
				else
					v128 = 0 - 0;
				end
				if (((9743 - 5607) > (1270 + 1127)) and (v128 > (0 + 0))) then
					v109.IncomingSouls = v109.IncomingSouls + v128;
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForSelfCombatEvent(function(...)
		local v129 = select(27 - 15, ...);
		if ((v129 == (98365 + 327307)) or ((1440 + 2894) == (2653 + 1592))) then
			v109.IncomingSouls = v109.IncomingSouls + (1097 - (709 + 387));
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v130 = 1858 - (673 + 1185);
		local v131;
		while true do
			if ((v130 == (0 - 0)) or ((13730 - 9454) <= (4986 - 1955))) then
				v131 = select(9 + 3, ...);
				if ((v131 == (152415 + 51566)) or ((6455 - 1673) <= (295 + 904))) then
					v109.AuraSouls = 1 - 0;
					v109.IncomingSouls = v27(0 - 0, v109.IncomingSouls - (1881 - (446 + 1434)));
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v132 = 1283 - (1040 + 243);
		local v133;
		local v134;
		local v135;
		while true do
			if ((v132 == (0 - 0)) or ((6711 - (559 + 1288)) < (3833 - (609 + 1322)))) then
				v133, v134, v134, v134, v135 = select(466 - (13 + 441), ...);
				if (((18082 - 13243) >= (9691 - 5991)) and (v133 == (1015915 - 811934))) then
					v109.AuraSouls = v135;
					v109.IncomingSouls = v27(0 + 0, v109.IncomingSouls - v135);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED_DOSE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v136 = 0 - 0;
		local v137;
		local v138;
		local v139;
		while true do
			if ((v136 == (0 + 0)) or ((472 + 603) > (5691 - 3773))) then
				v137, v138, v138, v138, v139 = select(7 + 5, ...);
				if (((727 - 331) <= (2515 + 1289)) and (v137 == (113451 + 90530))) then
					v109.AuraSouls = v139;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED_DOSE");
	v10:RegisterForSelfCombatEvent(function(...)
		local v140, v141, v141, v141, v142 = select(9 + 3, ...);
		if ((v140 == (171274 + 32707)) or ((4079 + 90) == (2620 - (153 + 280)))) then
			v109.AuraSouls = 0 - 0;
		end
	end, "SPELL_AURA_REMOVED");
	local function v112()
		local v143 = 0 + 0;
		while true do
			if (((556 + 850) == (736 + 670)) and (v143 == (0 + 0))) then
				if (((1110 + 421) < (6503 - 2232)) and ((v84.Felblade:TimeSinceLastCast() < v14:GCD()) or (v84.InfernalStrike:TimeSinceLastCast() < v14:GCD()))) then
					local v206 = 0 + 0;
					while true do
						if (((1302 - (89 + 578)) == (454 + 181)) and ((0 - 0) == v206)) then
							v92 = true;
							v93 = true;
							v206 = 1050 - (572 + 477);
						end
						if (((455 + 2918) <= (2135 + 1421)) and (v206 == (1 + 0))) then
							return;
						end
					end
				end
				v92 = v15:IsInMeleeRange(91 - (84 + 2));
				v143 = 1 - 0;
			end
			if ((v143 == (1 + 0)) or ((4133 - (497 + 345)) < (84 + 3196))) then
				v93 = v92 or (v97 > (0 + 0));
				break;
			end
		end
	end
	local function v113()
		local v144 = 1333 - (605 + 728);
		while true do
			if (((3130 + 1256) >= (1940 - 1067)) and (v144 == (0 + 0))) then
				v29 = v22.HandleTopTrinket(v87, v32, 147 - 107, nil);
				if (((831 + 90) <= (3052 - 1950)) and v29) then
					return v29;
				end
				v144 = 1 + 0;
			end
			if (((5195 - (457 + 32)) >= (409 + 554)) and ((1403 - (832 + 570)) == v144)) then
				v29 = v22.HandleBottomTrinket(v87, v32, 38 + 2, nil);
				if (v29 or ((251 + 709) <= (3099 - 2223))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v114()
		if ((v50 and ((not v33 and v83) or not v83) and ((v32 and v54) or not v54) and not v14:IsMoving() and v84.SigilOfFlame:IsCastable()) or ((996 + 1070) == (1728 - (588 + 208)))) then
			if (((13004 - 8179) < (6643 - (884 + 916))) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
				if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(16 - 8)) or ((2248 + 1629) >= (5190 - (232 + 421)))) then
					return "sigil_of_flame precombat 2";
				end
			elseif ((v79 == "cursor") or ((6204 - (1569 + 320)) < (424 + 1302))) then
				if (v20(v86.SigilOfFlameCursor, not v15:IsInRange(6 + 24)) or ((12397 - 8718) < (1230 - (316 + 289)))) then
					return "sigil_of_flame precombat 2";
				end
			end
		end
		if ((v84.ImmolationAura:IsCastable() and v38) or ((12106 - 7481) < (30 + 602))) then
			if (v20(v84.ImmolationAura, not v15:IsInMeleeRange(1461 - (666 + 787))) or ((508 - (360 + 65)) > (1664 + 116))) then
				return "immolation_aura precombat 4";
			end
		end
		if (((800 - (79 + 175)) <= (1697 - 620)) and v84.InfernalStrike:IsCastable() and v39 and ((not v33 and v82) or not v82) and (v84.InfernalStrike:ChargesFractional() > (1.7 + 0))) then
			if (v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(24 - 16)) or ((1917 - 921) > (5200 - (503 + 396)))) then
				return "infernal_strike precombat 6";
			end
		end
		if (((4251 - (92 + 89)) > (1332 - 645)) and v84.Fracture:IsCastable() and v37 and v92) then
			if (v20(v84.Fracture) or ((337 + 319) >= (1971 + 1359))) then
				return "fracture precombat 8";
			end
		end
		if ((v84.Shear:IsCastable() and v40 and v92) or ((9758 - 7266) <= (46 + 289))) then
			if (((9854 - 5532) >= (2236 + 326)) and v20(v84.Shear)) then
				return "shear precombat 10";
			end
		end
	end
	local function v115()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (2 - 1)) or ((454 + 3183) >= (5749 - 1979))) then
				if ((v84.FieryBrand:IsCastable() and v61 and (v94 or (v14:HealthPercentage() <= v64))) or ((3623 - (485 + 759)) > (10592 - 6014))) then
					if (v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand)) or ((1672 - (442 + 747)) > (1878 - (832 + 303)))) then
						return "fiery_brand defensives";
					end
				end
				if (((3400 - (88 + 858)) > (177 + 401)) and v85.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) then
					if (((770 + 160) < (184 + 4274)) and v20(v86.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v145 = 791 - (766 + 23);
			end
			if (((3268 - 2606) <= (1328 - 356)) and (v145 == (4 - 2))) then
				if (((14831 - 10461) == (5443 - (1036 + 37))) and v74 and (v14:HealthPercentage() <= v76)) then
					if ((v78 == "Refreshing Healing Potion") or ((3377 + 1385) <= (1676 - 815))) then
						if (v85.RefreshingHealingPotion:IsReady() or ((1111 + 301) == (5744 - (641 + 839)))) then
							if (v20(v86.RefreshingHealingPotion) or ((4081 - (910 + 3)) < (5488 - 3335))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v78 == "Dreamwalker's Healing Potion") or ((6660 - (1466 + 218)) < (613 + 719))) then
						if (((5776 - (556 + 592)) == (1646 + 2982)) and v85.DreamwalkersHealingPotion:IsReady()) then
							if (v20(v86.RefreshingHealingPotion) or ((862 - (329 + 479)) == (1249 - (174 + 680)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((281 - 199) == (169 - 87)) and (v145 == (0 + 0))) then
				if ((v84.DemonSpikes:IsCastable() and v60 and v14:BuffDown(v84.DemonSpikesBuff) and v14:BuffDown(v84.MetamorphosisBuff) and (((v97 == (740 - (396 + 343))) and v14:BuffDown(v84.FieryBrandDebuff)) or (v97 > (1 + 0)))) or ((2058 - (29 + 1448)) < (1671 - (135 + 1254)))) then
					if ((v84.DemonSpikes:ChargesFractional() > (3.9 - 2)) or ((21519 - 16910) < (1663 + 832))) then
						if (((2679 - (389 + 1138)) == (1726 - (102 + 472))) and v20(v84.DemonSpikes)) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (((1790 + 106) <= (1898 + 1524)) and (v94 or (v14:HealthPercentage() <= v63))) then
						if (v20(v84.DemonSpikes) or ((924 + 66) > (3165 - (320 + 1225)))) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if ((v84.Metamorphosis:IsCastable() and v62 and (v14:HealthPercentage() <= v65) and (v14:BuffDown(v84.MetamorphosisBuff) or (v15:TimeToDie() < (26 - 11)))) or ((537 + 340) > (6159 - (157 + 1307)))) then
					if (((4550 - (821 + 1038)) >= (4618 - 2767)) and v20(v86.MetamorphosisPlayer)) then
						return "metamorphosis defensives";
					end
				end
				v145 = 1 + 0;
			end
		end
	end
	local function v116()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1 + 0)) or ((7398 - 4413) >= (5882 - (834 + 192)))) then
				if (((272 + 4004) >= (307 + 888)) and v38 and v84.ImmolationAura:IsCastable()) then
					if (((70 + 3162) <= (7265 - 2575)) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(312 - (300 + 4)))) then
						return "immolation_aura maintenance 6";
					end
				end
				if ((v34 and v84.BulkExtraction:IsCastable() and (((2 + 3) - v88) <= v97) and (v88 <= (5 - 3))) or ((1258 - (112 + 250)) >= (1255 + 1891))) then
					if (((7668 - 4607) >= (1695 + 1263)) and v20(v84.BulkExtraction, not v92)) then
						return "bulk_extraction maintenance 8";
					end
				end
				v146 = 2 + 0;
			end
			if (((2384 + 803) >= (320 + 324)) and (v146 == (0 + 0))) then
				if (((2058 - (1001 + 413)) <= (1569 - 865)) and v61 and v80 and v84.FieryBrand:IsCastable() and (((v84.FieryBrandDebuff:AuraActiveCount() == (882 - (244 + 638))) and ((v84.SigilOfFlame:CooldownRemains() <= (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())) or (v84.SoulCarver:CooldownRemains() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())) or (v84.FelDevastation:CooldownRemains() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains())))) or (v84.DowninFlames:IsAvailable() and (v84.FieryBrand:FullRechargeTime() < (v84.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) then
					if (((1651 - (627 + 66)) > (2821 - 1874)) and v20(v84.FieryBrand, not v15:IsSpellInRange(v84.FieryBrand))) then
						return "fiery_brand maintenance 2";
					end
				end
				if (((5094 - (512 + 90)) >= (4560 - (1665 + 241))) and v41 and v84.SigilOfFlame:IsCastable() and ((not v33 and v83) or not v83) and (v84.AscendingFlame:IsAvailable() or (v84.SigilOfFlameDebuff:AuraActiveCount() == (717 - (373 + 344))))) then
					if (((1553 + 1889) >= (398 + 1105)) and (v84.ConcentratedSigils:IsAvailable() or (v79 == "player"))) then
						if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(20 - 12)) or ((5364 - 2194) <= (2563 - (35 + 1064)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v79 == "cursor") or ((3491 + 1306) == (9387 - 4999))) then
						if (((3 + 548) <= (1917 - (298 + 938))) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(1289 - (233 + 1026)))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v146 = 1667 - (636 + 1030);
			end
			if (((1676 + 1601) > (398 + 9)) and (v146 == (1 + 2))) then
				if (((318 + 4377) >= (1636 - (55 + 166))) and v37 and v84.Fracture:IsCastable() and (v84.FelDevastation:CooldownRemains() <= (v84.Fracture:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (10 + 40))) then
					if (v20(v84.Fracture, not v92) or ((323 + 2889) <= (3605 - 2661))) then
						return "fracture maintenance 14";
					end
				end
				if ((v40 and v84.Shear:IsCastable() and (v84.FelDevastation:CooldownRemains() <= (v84.Fracture:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (347 - (36 + 261)))) or ((5413 - 2317) <= (3166 - (34 + 1334)))) then
					if (((1360 + 2177) == (2749 + 788)) and v20(v84.Shear, not v92)) then
						return "shear maintenance 16";
					end
				end
				v146 = 1287 - (1035 + 248);
			end
			if (((3858 - (20 + 1)) >= (818 + 752)) and (v146 == (321 - (134 + 185)))) then
				if ((v43 and v84.SpiritBomb:IsReady() and v103) or ((4083 - (549 + 584)) == (4497 - (314 + 371)))) then
					if (((16213 - 11490) >= (3286 - (478 + 490))) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(5 + 3))) then
						return "spirit_bomb maintenance 10";
					end
				end
				if ((v36 and v84.Felblade:IsReady() and (((not v84.SpiritBomb:IsAvailable() or (v97 == (1173 - (786 + 386)))) and (v14:FuryDeficit() >= (129 - 89))) or ((v84.FelDevastation:CooldownRemains() <= (v84.Felblade:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1429 - (1055 + 324)))))) or ((3367 - (1093 + 247)) > (2535 + 317))) then
					if (v20(v84.Felblade, not v92) or ((120 + 1016) > (17139 - 12822))) then
						return "felblade maintenance 12";
					end
				end
				v146 = 9 - 6;
			end
			if (((13510 - 8762) == (11931 - 7183)) and (v146 == (2 + 2))) then
				if (((14392 - 10656) <= (16337 - 11597)) and v43 and v84.SpiritBomb:IsReady() and (v14:FuryDeficit() <= (23 + 7)) and (v97 > (2 - 1)) and (v88 >= (692 - (364 + 324)))) then
					if (v20(v84.SpiritBomb, not v15:IsInMeleeRange(21 - 13)) or ((8134 - 4744) <= (1015 + 2045))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if ((v42 and v84.SoulCleave:IsReady() and not v104 and (v14:FuryDeficit() <= (167 - 127))) or ((1599 - 600) > (8178 - 5485))) then
					if (((1731 - (1249 + 19)) < (543 + 58)) and v20(v84.SoulCleave, not v92)) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v147 = 0 - 0;
		while true do
			if ((v147 == (1089 - (686 + 400))) or ((1713 + 470) < (916 - (73 + 156)))) then
				if (((22 + 4527) == (5360 - (721 + 90))) and v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (1.85 + 0)) and (v14:Fury() >= (129 - 89)) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
					if (((5142 - (224 + 246)) == (7568 - 2896)) and (v58 == "player")) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(14 - 6)) or ((666 + 3002) < (10 + 385))) then
							return "elysian_decree fiery_demise 14 (Player)";
						end
					elseif ((v58 == "cursor") or ((3060 + 1106) == (904 - 449))) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(99 - 69)) or ((4962 - (203 + 310)) == (4656 - (1238 + 755)))) then
							return "elysian_decree fiery_demise 14 (Cursor)";
						end
					end
				end
				if ((v84.SpiritBomb:IsReady() and v43 and v103) or ((299 + 3978) < (4523 - (709 + 825)))) then
					if (v20(v84.SpiritBomb, not v15:IsInMeleeRange(14 - 6)) or ((1267 - 397) >= (5013 - (196 + 668)))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				break;
			end
			if (((8733 - 6521) < (6593 - 3410)) and (v147 == (834 - (171 + 662)))) then
				if (((4739 - (4 + 89)) > (10486 - 7494)) and v36 and v84.Felblade:IsReady() and (not v84.SpiritBomb:IsAvailable() or (v84.FelDevastation:CooldownRemains() <= (v84.Felblade:ExecuteTime() + v14:GCDRemains()))) and (v14:Fury() < (19 + 31))) then
					if (((6298 - 4864) < (1219 + 1887)) and v20(v84.Felblade, not v92)) then
						return "felblade fiery_demise 6";
					end
				end
				if (((2272 - (35 + 1451)) < (4476 - (28 + 1425))) and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106) and v84.FelDevastation:IsReady()) then
					if (v20(v84.FelDevastation, not v15:IsInMeleeRange(2001 - (941 + 1052))) or ((2342 + 100) < (1588 - (822 + 692)))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v147 = 2 - 0;
			end
			if (((2137 + 2398) == (4832 - (45 + 252))) and (v147 == (0 + 0))) then
				if ((v38 and v84.ImmolationAura:IsCastable()) or ((1036 + 1973) <= (5123 - 3018))) then
					if (((2263 - (114 + 319)) < (5267 - 1598)) and v20(v84.ImmolationAura, not v15:IsInMeleeRange(9 - 1))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if ((v84.SigilOfFlame:IsCastable() and (v84.AscendingFlame:IsAvailable() or (v84.SigilOfFlameDebuff:AuraActiveCount() == (0 + 0)))) or ((2130 - 700) >= (7567 - 3955))) then
					if (((4646 - (556 + 1407)) >= (3666 - (741 + 465))) and (v84.ConcentratedSigils:IsAvailable() or (v79 == "player"))) then
						if (v20(v86.SigilOfFlamePlayer, not v15:IsInMeleeRange(473 - (170 + 295))) or ((951 + 853) >= (3009 + 266))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif ((v79 == "cursor") or ((3488 - 2071) > (3009 + 620))) then
						if (((3076 + 1719) > (228 + 174)) and v20(v86.SigilOfFlameCursor, not v15:IsInRange(1260 - (957 + 273)))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				v147 = 1 + 0;
			end
			if (((1927 + 2886) > (13584 - 10019)) and (v147 == (5 - 3))) then
				if (((11948 - 8036) == (19370 - 15458)) and v52 and v84.SoulCarver:IsCastable() and (v89 < (1783 - (389 + 1391))) and ((v32 and v56) or not v56) and (v71 < v106)) then
					if (((1770 + 1051) <= (503 + 4321)) and v20(v84.SoulCarver, not v92)) then
						return "soul_carver fiery_demise 10";
					end
				end
				if (((3956 - 2218) <= (3146 - (783 + 168))) and v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) then
					if (((137 - 96) <= (2969 + 49)) and v20(v84.TheHunt, not v15:IsInRange(341 - (309 + 2)))) then
						return "the_hunt fiery_demise 12";
					end
				end
				v147 = 9 - 6;
			end
		end
	end
	local function v118()
		if (((3357 - (1090 + 122)) <= (1331 + 2773)) and v84.SigilOfChains:IsCastable() and v48 and (v84.CycleofBinding:IsAvailable())) then
			if (((9030 - 6341) < (3316 + 1529)) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
				if (v20(v86.SigilOfChainsPlayer, not v15:IsInMeleeRange(1126 - (628 + 490))) or ((417 + 1905) > (6491 - 3869))) then
					return "sigil_of_chains player filler 2";
				end
			elseif ((v79 == "cursor") or ((20720 - 16186) == (2856 - (431 + 343)))) then
				if (v20(v86.SigilOfChainsCursor, not v15:IsInRange(60 - 30)) or ((4544 - 2973) > (1475 + 392))) then
					return "sigil_of_chains cursor filler 2";
				end
			end
		end
		if ((v84.SigilOfMisery:IsCastable() and (v84.CycleofBinding:IsAvailable()) and v49) or ((340 + 2314) >= (4691 - (556 + 1139)))) then
			if (((3993 - (6 + 9)) > (386 + 1718)) and ((v79 == "player") or v84.ConcentratedSigils:IsAvailable())) then
				if (((1535 + 1460) > (1710 - (28 + 141))) and v20(v86.SigilOfMiseryPlayer, not v15:IsInMeleeRange(4 + 4))) then
					return "sigil_of_misery player filler 4";
				end
			elseif (((4009 - 760) > (675 + 278)) and (v79 == "cursor")) then
				if (v20(v86.SigilOfMiseryCursor, not v15:IsInRange(1347 - (486 + 831))) or ((8516 - 5243) > (16099 - 11526))) then
					return "sigil_of_misery cursor filler 4";
				end
			end
		end
		if ((v84.SigilOfSilence:IsCastable() and (v84.CycleofBinding:IsAvailable()) and v47) or ((596 + 2555) < (4059 - 2775))) then
			if ((v79 == "player") or v84.ConcentratedSigils:IsAvailable() or ((3113 - (668 + 595)) == (1376 + 153))) then
				if (((166 + 655) < (5789 - 3666)) and v20(v86.SigilOfSilencePlayer, not v15:IsInMeleeRange(298 - (23 + 267)))) then
					return "sigil_of_silence player filler 6";
				end
			elseif (((2846 - (1129 + 815)) < (2712 - (371 + 16))) and (v79 == "cursor")) then
				if (((2608 - (1326 + 424)) <= (5609 - 2647)) and v20(v86.SigilOfSilenceCursor, not v15:IsInRange(109 - 79))) then
					return "sigil_of_silence cursor filler 6";
				end
			end
		end
		if ((v84.Felblade:IsReady() and v36) or ((4064 - (88 + 30)) < (2059 - (720 + 51)))) then
			if (v20(v84.Felblade, not v92) or ((7211 - 3969) == (2343 - (421 + 1355)))) then
				return "felblade filler 8";
			end
		end
		if ((v84.Shear:IsCastable() and v40) or ((1396 - 549) >= (621 + 642))) then
			if (v20(v84.Shear, not v92) or ((3336 - (286 + 797)) == (6766 - 4915))) then
				return "shear filler 10";
			end
		end
		if ((v84.ThrowGlaive:IsCastable() and v44) or ((3456 - 1369) > (2811 - (397 + 42)))) then
			if (v20(v84.ThrowGlaive, not v15:IsInRange(10 + 20)) or ((5245 - (24 + 776)) < (6391 - 2242))) then
				return "throw_glaive filler 12";
			end
		end
	end
	local function v119()
		if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) or ((2603 - (222 + 563)) == (187 - 102))) then
			if (((454 + 176) < (2317 - (23 + 167))) and v20(v84.TheHunt, not v15:IsInRange(1848 - (690 + 1108)))) then
				return "the_hunt single_target 2";
			end
		end
		if ((v84.SoulCarver:IsCastable() and v52 and ((v32 and v56) or not v56) and (v71 < v106)) or ((700 + 1238) == (2074 + 440))) then
			if (((5103 - (40 + 808)) >= (10 + 45)) and v20(v84.SoulCarver, not v92)) then
				return "soul_carver single_target 4";
			end
		end
		if (((11467 - 8468) > (1105 + 51)) and v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable())) and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) then
			if (((1244 + 1106) > (634 + 521)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(591 - (47 + 524)))) then
				return "fel_devastation single_target 6";
			end
		end
		if (((2615 + 1414) <= (13265 - 8412)) and v84.ElysianDecree:IsCastable() and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
			if ((v58 == "player") or ((771 - 255) > (7831 - 4397))) then
				if (((5772 - (1165 + 561)) >= (91 + 2942)) and v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(92 - 62))) then
					return "elysian_decree single_target 8 (Player)";
				end
			elseif ((v58 == "cursor") or ((1038 + 1681) <= (1926 - (341 + 138)))) then
				if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(9 + 21)) or ((8530 - 4396) < (4252 - (89 + 237)))) then
					return "elysian_decree single_target 8 (Cursor)";
				end
			end
		end
		if ((v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((527 - 363) >= (5863 - 3078))) then
			if (v20(v84.FelDevastation, not v15:IsInMeleeRange(901 - (581 + 300))) or ((1745 - (855 + 365)) == (5009 - 2900))) then
				return "fel_devastation single_target 10";
			end
		end
		if (((11 + 22) == (1268 - (1030 + 205))) and v84.SoulCleave:IsReady() and not v98 and v42) then
			if (((2868 + 186) <= (3736 + 279)) and v20(v84.SoulCleave, not v92)) then
				return "soul_cleave single_target 12";
			end
		end
		if (((2157 - (156 + 130)) < (7684 - 4302)) and v84.Fracture:IsCastable() and v37) then
			if (((2179 - 886) <= (4435 - 2269)) and v20(v84.Fracture, not v92)) then
				return "fracture single_target 14";
			end
		end
		v29 = v118();
		if (v29 or ((680 + 1899) < (72 + 51))) then
			return v29;
		end
	end
	local function v120()
		local v148 = 69 - (10 + 59);
		while true do
			if (((1 + 1) == v148) or ((4166 - 3320) >= (3531 - (671 + 492)))) then
				if ((v84.SoulCarver:IsCastable() and (v89 < (3 + 0)) and v52 and ((v32 and v56) or not v56) and (v71 < v106)) or ((5227 - (369 + 846)) <= (889 + 2469))) then
					if (((1275 + 219) <= (4950 - (1036 + 909))) and v20(v84.SoulCarver, not v92)) then
						return "soul_carver small_aoe 10";
					end
				end
				if ((v84.SoulCleave:IsReady() and ((v88 <= (1 + 0)) or not v84.SpiritBomb:IsAvailable()) and not v98 and v42) or ((5222 - 2111) == (2337 - (11 + 192)))) then
					if (((1191 + 1164) == (2530 - (135 + 40))) and v20(v84.SoulCleave, not v92)) then
						return "soul_cleave small_aoe 12";
					end
				end
				v148 = 6 - 3;
			end
			if (((3 + 1) == v148) or ((1295 - 707) <= (646 - 214))) then
				if (((4973 - (50 + 126)) >= (10845 - 6950)) and v29) then
					return v29;
				end
				break;
			end
			if (((792 + 2785) == (4990 - (1233 + 180))) and (v148 == (969 - (522 + 447)))) then
				if (((5215 - (107 + 1314)) > (1714 + 1979)) and v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) then
					if (v20(v84.TheHunt, not v15:IsInRange(152 - 102)) or ((542 + 733) == (8141 - 4041))) then
						return "the_hunt small_aoe 2";
					end
				end
				if ((v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or (v84.StoketheFlames:IsAvailable() and v84.BurningBlood:IsAvailable())) and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((6294 - 4703) >= (5490 - (716 + 1194)))) then
					if (((17 + 966) <= (194 + 1614)) and v20(v84.FelDevastation, not v15:IsInMeleeRange(523 - (74 + 429)))) then
						return "fel_devastation small_aoe 4";
					end
				end
				v148 = 1 - 0;
			end
			if ((v148 == (1 + 0)) or ((4921 - 2771) <= (847 + 350))) then
				if (((11619 - 7850) >= (2900 - 1727)) and v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (434.85 - (279 + 154))) and (v14:Fury() >= (818 - (454 + 324))) and ((v89 <= (1 + 0)) or (v89 >= (21 - (12 + 5)))) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
					if (((801 + 684) == (3783 - 2298)) and (v58 == "player")) then
						if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(12 + 18)) or ((4408 - (277 + 816)) <= (11887 - 9105))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif ((v58 == "cursor") or ((2059 - (1058 + 125)) >= (556 + 2408))) then
						if (v20(v86.ElysianDecreeCursor, not v15:IsInRange(1005 - (815 + 160))) or ((9576 - 7344) > (5927 - 3430))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				if ((v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) or ((504 + 1606) <= (970 - 638))) then
					if (((5584 - (41 + 1857)) > (5065 - (1222 + 671))) and v20(v84.FelDevastation, not v15:IsInMeleeRange(51 - 31))) then
						return "fel_devastation small_aoe 8";
					end
				end
				v148 = 2 - 0;
			end
			if ((v148 == (1185 - (229 + 953))) or ((6248 - (1111 + 663)) < (2399 - (874 + 705)))) then
				if (((599 + 3680) >= (1967 + 915)) and v84.Fracture:IsCastable() and v37) then
					if (v20(v84.Fracture, not v92) or ((4217 - 2188) >= (100 + 3421))) then
						return "fracture small_aoe 14";
					end
				end
				v29 = v118();
				v148 = 683 - (642 + 37);
			end
		end
	end
	local function v121()
		if ((v84.FelDevastation:IsReady() and (v84.CollectiveAnguish:IsAvailable() or v84.StoketheFlames:IsAvailable()) and v51 and ((v32 and v55) or not v55) and (v71 < v106) and ((not v33 and v82) or not v82)) or ((465 + 1572) >= (743 + 3899))) then
			if (((4318 - 2598) < (4912 - (233 + 221))) and v20(v84.FelDevastation, not v15:IsInMeleeRange(46 - 26))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if ((v84.TheHunt:IsCastable() and v53 and ((not v33 and v82) or not v82) and ((v32 and v57) or not v57) and (v71 < v106)) or ((384 + 52) > (4562 - (718 + 823)))) then
			if (((449 + 264) <= (1652 - (266 + 539))) and v20(v84.TheHunt, not v15:IsInRange(141 - 91))) then
				return "the_hunt big_aoe 4";
			end
		end
		if (((3379 - (636 + 589)) <= (9568 - 5537)) and v84.ElysianDecree:IsCastable() and (v84.ElysianDecree:TimeSinceLastCast() >= (1.85 - 0)) and (v14:Fury() >= (32 + 8)) and ((v89 <= (1 + 0)) or (v89 >= (1019 - (657 + 358)))) and v50 and ((not v33 and v83) or not v83) and not v14:IsMoving() and ((v32 and v54) or not v54) and (v71 < v106) and (v97 > v59)) then
			if (((12219 - 7604) == (10514 - 5899)) and (v58 == "player")) then
				if (v20(v86.ElysianDecreePlayer, not v15:IsInMeleeRange(1217 - (1151 + 36))) or ((3660 + 130) == (132 + 368))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif (((265 - 176) < (2053 - (1552 + 280))) and (v58 == "cursor")) then
				if (((2888 - (64 + 770)) >= (965 + 456)) and v20(v86.ElysianDecreeCursor, not v15:IsInRange(68 - 38))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if (((123 + 569) < (4301 - (157 + 1086))) and v84.FelDevastation:IsReady() and v51 and ((not v33 and v82) or not v82) and ((v32 and v55) or not v55) and (v71 < v106)) then
			if (v20(v84.FelDevastation, not v15:IsInMeleeRange(40 - 20)) or ((14251 - 10997) == (2538 - 883))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if ((v84.SoulCarver:IsCastable() and (v89 < (3 - 0)) and v52 and ((v32 and v56) or not v56) and (v71 < v106)) or ((2115 - (599 + 220)) == (9777 - 4867))) then
			if (((5299 - (1813 + 118)) == (2462 + 906)) and v20(v84.SoulCarver, not v92)) then
				return "soul_carver big_aoe 10";
			end
		end
		if (((3860 - (841 + 376)) < (5345 - 1530)) and v84.SpiritBomb:IsReady() and (v88 >= (1 + 3)) and v43) then
			if (((5221 - 3308) > (1352 - (464 + 395))) and v20(v84.SpiritBomb, not v15:IsInMeleeRange(20 - 12))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if (((2284 + 2471) > (4265 - (467 + 370))) and v84.SoulCleave:IsReady() and (not v84.SpiritBomb:IsAvailable() or not v98) and v42) then
			if (((2853 - 1472) <= (1739 + 630)) and v20(v84.SoulCleave, not v92)) then
				return "soul_cleave big_aoe 14";
			end
		end
		if ((v84.Fracture:IsCastable() and v37) or ((16601 - 11758) == (638 + 3446))) then
			if (((10862 - 6193) > (883 - (150 + 370))) and v20(v84.Fracture, not v92)) then
				return "fracture big_aoe 16";
			end
		end
		if ((v84.SoulCleave:IsReady() and not v98 and v42) or ((3159 - (74 + 1208)) >= (7718 - 4580))) then
			if (((22489 - 17747) >= (2581 + 1045)) and v20(v84.SoulCleave, not v92)) then
				return "soul_cleave big_aoe 18";
			end
		end
		v29 = v118();
		if (v29 or ((4930 - (14 + 376)) == (1588 - 672))) then
			return v29;
		end
	end
	local function v122()
		v34 = EpicSettings.Settings['useBulkExtraction'];
		v35 = EpicSettings.Settings['useConsumeMagic'];
		v36 = EpicSettings.Settings['useFelblade'];
		v37 = EpicSettings.Settings['useFracture'];
		v38 = EpicSettings.Settings['useImmolationAura'];
		v39 = EpicSettings.Settings['useInfernalStrike'];
		v40 = EpicSettings.Settings['useShear'];
		v41 = EpicSettings.Settings['useSigilOfFlame'];
		v42 = EpicSettings.Settings['useSoulCleave'];
		v43 = EpicSettings.Settings['useSpiritBomb'];
		v44 = EpicSettings.Settings['useThrowGlaive'];
		v45 = EpicSettings.Settings['useChaosNova'];
		v46 = EpicSettings.Settings['useDisrupt'];
		v47 = EpicSettings.Settings['useSigilOfSilence'];
		v48 = EpicSettings.Settings['useSigilOfChains'];
		v49 = EpicSettings.Settings['useSigilOfMisery'];
		v50 = EpicSettings.Settings['useElysianDecree'];
		v51 = EpicSettings.Settings['useFelDevastation'];
		v52 = EpicSettings.Settings['useSoulCarver'];
		v53 = EpicSettings.Settings['useTheHunt'];
		v54 = EpicSettings.Settings['elysianDecreeWithCD'];
		v55 = EpicSettings.Settings['felDevastationWithCD'];
		v56 = EpicSettings.Settings['soulCarverWithCD'];
		v57 = EpicSettings.Settings['theHuntWithCD'];
		v60 = EpicSettings.Settings['useDemonSpikes'];
		v61 = EpicSettings.Settings['useFieryBrand'];
		v62 = EpicSettings.Settings['useMetamorphosis'];
		v63 = EpicSettings.Settings['demonSpikesHP'] or (0 + 0);
		v64 = EpicSettings.Settings['fieryBrandHP'] or (0 + 0);
		v65 = EpicSettings.Settings['metamorphosisHP'] or (0 + 0);
		v79 = EpicSettings.Settings['sigilSetting'] or "player";
		v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
		v80 = EpicSettings.Settings['fieryBrandOffensively'];
		v81 = EpicSettings.Settings['metamorphosisOffensively'];
	end
	local function v123()
		local v178 = 0 + 0;
		while true do
			if (((81 - (23 + 55)) == v178) or ((2739 - 1583) > (2900 + 1445))) then
				v67 = EpicSettings.Settings['HandleIncorporeal'];
				v83 = EpicSettings.Settings['RMBAOE'];
				v82 = EpicSettings.Settings['RMBMovement'];
				break;
			end
			if (((2009 + 228) < (6587 - 2338)) and (v178 == (1 + 0))) then
				v70 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['useTrinkets'];
				v73 = EpicSettings.Settings['trinketsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v178 = 903 - (652 + 249);
			end
			if ((v178 == (5 - 3)) or ((4551 - (708 + 1160)) < (62 - 39))) then
				v74 = EpicSettings.Settings['useHealingPotion'];
				v77 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v76 = EpicSettings.Settings['healingPotionHP'] or (27 - (10 + 17));
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v178 = 1 + 2;
			end
			if (((2429 - (1400 + 332)) <= (1584 - 758)) and (v178 == (1908 - (242 + 1666)))) then
				v71 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v66 = EpicSettings.Settings['dispelBuffs'];
				v68 = EpicSettings.Settings['InterruptWithStun'];
				v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v178 = 1 + 0;
			end
		end
	end
	local function v124()
		local v179 = 0 + 0;
		while true do
			if (((2045 - (850 + 90)) <= (2059 - 883)) and ((1390 - (360 + 1030)) == v179)) then
				v122();
				v123();
				v30 = EpicSettings.Toggles['ooc'];
				v179 = 1 + 0;
			end
			if (((9536 - 6157) <= (5244 - 1432)) and ((1666 - (909 + 752)) == v179)) then
				v89 = v88 + v90;
				if (v67 or ((2011 - (109 + 1114)) >= (2958 - 1342))) then
					local v207 = 0 + 0;
					while true do
						if (((2096 - (6 + 236)) <= (2129 + 1250)) and (v207 == (0 + 0))) then
							v29 = v22.HandleIncorporeal(v84.Imprison, v86.ImprisonMouseover, 47 - 27);
							if (((7945 - 3396) == (5682 - (1076 + 57))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v22.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((497 + 2525) >= (3713 - (579 + 110)))) then
					v99 = v84.FieryBrand:IsAvailable() and v84.FieryDemise:IsAvailable() and (v84.FieryBrandDebuff:AuraActiveCount() > (0 + 0));
					v100 = v97 == (1 + 0);
					v101 = (v97 >= (2 + 0)) and (v97 <= (412 - (174 + 233)));
					v102 = v97 >= (16 - 10);
					v98 = ((v84.FelDevastation:CooldownRemains() <= (v84.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (140 - 60))) or (((v90 > (1 + 0)) or (v89 >= (1179 - (663 + 511)))) and not v100);
					if (((4301 + 519) > (478 + 1720)) and v99) then
						v103 = (v100 and (v88 >= (15 - 10))) or (v101 and (v88 >= (3 + 1))) or (v102 and (v88 >= (6 - 3)));
					else
						v103 = (v101 and (v88 >= (12 - 7))) or (v102 and (v88 >= (2 + 2)));
					end
					if (v99 or ((2064 - 1003) >= (3486 + 1405))) then
						v104 = (v100 and (v89 >= (1 + 4))) or (v101 and (v89 >= (726 - (478 + 244)))) or (v102 and (v89 >= (520 - (440 + 77))));
					else
						v104 = (v101 and (v89 >= (3 + 2))) or (v102 and (v89 >= (14 - 10)));
					end
					if (((2920 - (655 + 901)) <= (830 + 3643)) and v84.ThrowGlaive:IsCastable() and v44 and v12.ValueIsInArray(v107, v15:NPCID())) then
						if (v20(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((2753 + 842) <= (3 + 0))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if ((v84.ThrowGlaive:IsReady() and v44 and v12.ValueIsInArray(v107, v16:NPCID())) or ((18821 - 14149) == (5297 - (695 + 750)))) then
						if (((5323 - 3764) == (2405 - 846)) and v20(v86.ThrowGlaiveMouseover, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					if ((not v14:AffectingCombat() and v30) or ((7046 - 5294) <= (1139 - (285 + 66)))) then
						local v210 = 0 - 0;
						while true do
							if (((1310 - (682 + 628)) == v210) or ((630 + 3277) == (476 - (176 + 123)))) then
								v29 = v114();
								if (((1452 + 2018) > (403 + 152)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if ((v84.ConsumeMagic:IsAvailable() and v35 and v84.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v22.UnitHasMagicBuff(v15)) or ((1241 - (239 + 30)) == (176 + 469))) then
						if (((3059 + 123) >= (3743 - 1628)) and v20(v84.ConsumeMagic, not v15:IsSpellInRange(v84.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((12145 - 8252) < (4744 - (306 + 9))) and v95) then
						v29 = v115();
						if (v29 or ((10004 - 7137) < (332 + 1573))) then
							return v29;
						end
					end
					if ((v84.InfernalStrike:IsCastable() and v39 and (v84.InfernalStrike:ChargesFractional() > (1.7 + 0)) and (v84.InfernalStrike:TimeSinceLastCast() > (1 + 1))) or ((5135 - 3339) >= (5426 - (1140 + 235)))) then
						if (((1031 + 588) <= (3445 + 311)) and v20(v86.InfernalStrikePlayer, not v15:IsInMeleeRange(3 + 5))) then
							return "infernal_strike main 2";
						end
					end
					if (((656 - (33 + 19)) == (219 + 385)) and (v71 < v106) and v84.Metamorphosis:IsCastable() and v62 and v81 and v14:BuffDown(v84.MetamorphosisBuff) and (v84.FelDevastation:CooldownRemains() > (35 - 23))) then
						if (v20(v86.MetamorphosisPlayer, not v92) or ((1976 + 2508) == (1764 - 864))) then
							return "metamorphosis main 4";
						end
					end
					local v208 = v22.HandleDPSPotion();
					if (v208 or ((4182 + 277) <= (1802 - (586 + 103)))) then
						return v208;
					end
					if (((331 + 3301) > (10461 - 7063)) and (v71 < v106)) then
						if (((5570 - (1309 + 179)) <= (8876 - 3959)) and v72 and ((v32 and v73) or not v73)) then
							v29 = v113();
							if (((2104 + 2728) >= (3722 - 2336)) and v29) then
								return v29;
							end
						end
					end
					if (((104 + 33) == (290 - 153)) and v84.FieryBrand:IsAvailable() and v84.FieryDemise:IsAvailable() and (v84.FieryBrandDebuff:AuraActiveCount() > (0 - 0))) then
						local v211 = 609 - (295 + 314);
						while true do
							if ((v211 == (0 - 0)) or ((3532 - (1300 + 662)) >= (13603 - 9271))) then
								v29 = v117();
								if (v29 or ((5819 - (1178 + 577)) <= (945 + 874))) then
									return v29;
								end
								break;
							end
						end
					end
					v29 = v116();
					if (v29 or ((14739 - 9753) < (2979 - (851 + 554)))) then
						return v29;
					end
					if (((3914 + 512) > (476 - 304)) and v100) then
						v29 = v119();
						if (((1272 - 686) > (757 - (115 + 187))) and v29) then
							return v29;
						end
					end
					if (((633 + 193) == (782 + 44)) and v101) then
						v29 = v120();
						if (v29 or ((15837 - 11818) > (5602 - (160 + 1001)))) then
							return v29;
						end
					end
					if (((1765 + 252) < (2941 + 1320)) and v102) then
						v29 = v121();
						if (((9653 - 4937) > (438 - (237 + 121))) and v29) then
							return v29;
						end
					end
				end
				break;
			end
			if ((v179 == (901 - (525 + 372))) or ((6648 - 3141) == (10750 - 7478))) then
				if (v22.TargetIsValid() or v14:AffectingCombat() or ((1018 - (96 + 46)) >= (3852 - (643 + 134)))) then
					local v209 = 0 + 0;
					while true do
						if (((10434 - 6082) > (9482 - 6928)) and (v209 == (1 + 0))) then
							if ((v106 == (21805 - 10694)) or ((9006 - 4600) < (4762 - (316 + 403)))) then
								v106 = v10.FightRemains(v96, false);
							end
							break;
						end
						if (((0 + 0) == v209) or ((5193 - 3304) >= (1223 + 2160))) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							v209 = 2 - 1;
						end
					end
				end
				v88 = v108.AuraSouls;
				v90 = v108.IncomingSouls;
				v179 = 4 + 1;
			end
			if (((610 + 1282) <= (9473 - 6739)) and (v179 == (14 - 11))) then
				v112();
				v94 = v14:ActiveMitigationNeeded();
				v95 = v14:IsTankingAoE(16 - 8) or v14:IsTanking(v15);
				v179 = 1 + 3;
			end
			if (((3785 - 1862) < (109 + 2109)) and (v179 == (5 - 3))) then
				if (((2190 - (12 + 5)) > (1471 - 1092)) and IsMouseButtonDown("RightButton")) then
					v33 = true;
				else
					v33 = false;
				end
				v96 = v14:GetEnemiesInMeleeRange(16 - 8);
				if (v31 or ((5507 - 2916) == (8453 - 5044))) then
					v97 = #v96;
				else
					v97 = 1 + 0;
				end
				v179 = 1976 - (1656 + 317);
			end
			if (((4023 + 491) > (2664 + 660)) and (v179 == (2 - 1))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				if (v14:IsDeadOrGhost() or ((1023 - 815) >= (5182 - (5 + 349)))) then
					return v29;
				end
				v179 = 9 - 7;
			end
		end
	end
	local function v125()
		local v180 = 1271 - (266 + 1005);
		while true do
			if ((v180 == (1 + 0)) or ((5401 - 3818) > (4695 - 1128))) then
				v84.SigilOfFlameDebuff:RegisterAuraTracking();
				break;
			end
			if ((v180 == (1696 - (561 + 1135))) or ((1710 - 397) == (2609 - 1815))) then
				v19.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
				v84.FieryBrandDebuff:RegisterAuraTracking();
				v180 = 1067 - (507 + 559);
			end
		end
	end
	v19.SetAPL(1457 - 876, v124, v125);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

