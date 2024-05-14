local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2847 - (927 + 834)) >= (7010 - 5605))) then
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
	local v90 = ((v83.SoulSigils:IsAvailable()) and (436 - (317 + 115))) or (5 - 2);
	local v91, v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97, v98, v99, v100, v101, v102, v103;
	local v104 = 9057 + 2054;
	local v105 = 9811 + 1300;
	local v106 = {(292171 - 122750),(25021 + 144404),(27748 + 141184),(471332 - 301906),(60600 + 108829),(139755 + 29673),(79105 + 90325)};
	v9:RegisterForEvent(function()
		v104 = 12544 - (797 + 636);
		v105 = 53947 - 42836;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v90 = ((v83.SoulSigils:IsAvailable()) and (1623 - (1427 + 192))) or (2 + 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v107 = {};
	local v108 = v107;
	v108.AuraSouls = 0 - 0;
	v108.IncomingSouls = 0 + 0;
	v9:RegisterForSelfCombatEvent(function(...)
		local v125 = 0 + 0;
		local v126;
		local v127;
		while true do
			if ((v125 == (326 - (192 + 134))) or ((3645 - (316 + 960)) == (238 + 188))) then
				v126 = select(10 + 2, ...);
				v127 = 0 + 0;
				v125 = 3 - 2;
			end
			if ((v125 == (552 - (83 + 468))) or ((4882 - (1202 + 604)) > (14858 - 11675))) then
				if (((2000 - 798) > (2929 - 1871)) and ((v126 == v83.Fracture:ID()) or (v126 == v83.Shear:ID()))) then
					v127 = 327 - (45 + 280);
				elseif (((3582 + 129) > (2932 + 423)) and (v126 == v83.SoulCarver:ID())) then
					v127 = 2 + 1;
					C_Timer.After(1 + 0, function()
						v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
					end);
					C_Timer.After(3 - 1, function()
						v108.IncomingSouls = v108.IncomingSouls + (1912 - (340 + 1571));
					end);
					C_Timer.After(2 + 1, function()
						v108.IncomingSouls = v108.IncomingSouls + (1773 - (1733 + 39));
					end);
				elseif ((v126 == v83.ElysianDecree:ID()) or ((2489 - 1583) >= (3263 - (125 + 909)))) then
					v127 = ((v83.SoulSigils:IsAvailable()) and (1952 - (1096 + 852))) or (2 + 1);
				elseif (((1839 - 551) > (1214 + 37)) and v83.SoulSigils:IsAvailable() and ((v126 == v83.SigilOfFlame:ID()) or (v126 == v83.SigilOfMisery:ID()) or (v126 == v83.SigilOfChains:ID()) or (v126 == v83.SigilOfSilence:ID()))) then
					v127 = 513 - (409 + 103);
				else
					v127 = 236 - (46 + 190);
				end
				if ((v127 > (95 - (51 + 44))) or ((1273 + 3240) < (4669 - (1114 + 203)))) then
					v108.IncomingSouls = v108.IncomingSouls + v127;
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v9:RegisterForSelfCombatEvent(function(...)
		local v128 = 726 - (228 + 498);
		local v129;
		while true do
			if ((v128 == (0 + 0)) or ((1141 + 924) >= (3859 - (174 + 489)))) then
				v129 = select(31 - 19, ...);
				if ((v129 == (427577 - (830 + 1075))) or ((4900 - (303 + 221)) <= (2750 - (231 + 1038)))) then
					v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v130 = select(1174 - (171 + 991), ...);
		if ((v130 == (840647 - 636666)) or ((9108 - 5716) >= (11830 - 7089))) then
			local v188 = 0 + 0;
			while true do
				if (((11655 - 8330) >= (6213 - 4059)) and (v188 == (0 - 0))) then
					v108.AuraSouls = 3 - 2;
					v108.IncomingSouls = v26(1248 - (111 + 1137), v108.IncomingSouls - (159 - (91 + 67)));
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v131, v132, v132, v132, v133 = select(35 - 23, ...);
		if ((v131 == (50895 + 153086)) or ((1818 - (423 + 100)) >= (23 + 3210))) then
			local v189 = 0 - 0;
			while true do
				if (((2282 + 2095) > (2413 - (326 + 445))) and (v189 == (0 - 0))) then
					v108.AuraSouls = v133;
					v108.IncomingSouls = v26(0 - 0, v108.IncomingSouls - v133);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v134 = 0 - 0;
		local v135;
		local v136;
		local v137;
		while true do
			if (((5434 - (530 + 181)) > (2237 - (614 + 267))) and (v134 == (32 - (19 + 13)))) then
				v135, v136, v136, v136, v137 = select(18 - 6, ...);
				if ((v135 == (475345 - 271364)) or ((11814 - 7678) <= (892 + 2541))) then
					v108.AuraSouls = v137;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v138, v139, v139, v139, v140 = select(20 - 8, ...);
		if (((8803 - 4558) <= (6443 - (1293 + 519))) and (v138 == (416184 - 212203))) then
			v108.AuraSouls = 0 - 0;
		end
	end, "SPELL_AURA_REMOVED");
	local function v111()
		if (((8176 - 3900) >= (16877 - 12963)) and ((v83.Felblade:TimeSinceLastCast() < v13:GCD()) or (v83.InfernalStrike:TimeSinceLastCast() < v13:GCD()))) then
			local v191 = 0 - 0;
			while true do
				if (((105 + 93) <= (891 + 3474)) and (v191 == (0 - 0))) then
					v91 = true;
					v92 = true;
					v191 = 1 + 0;
				end
				if (((1589 + 3193) > (2923 + 1753)) and (v191 == (1097 - (709 + 387)))) then
					return;
				end
			end
		end
		v91 = v14:IsInMeleeRange(1863 - (673 + 1185));
		v92 = v91 or (v96 > (0 - 0));
	end
	local function v112()
		local v141 = 0 - 0;
		while true do
			if (((8002 - 3138) > (1572 + 625)) and ((0 + 0) == v141)) then
				v28 = v21.HandleTopTrinket(v86, v31, 54 - 14, nil);
				if (v28 or ((909 + 2791) == (4998 - 2491))) then
					return v28;
				end
				v141 = 1 - 0;
			end
			if (((6354 - (446 + 1434)) >= (1557 - (1040 + 243))) and (v141 == (2 - 1))) then
				v28 = v21.HandleBottomTrinket(v86, v31, 1887 - (559 + 1288), nil);
				if (v28 or ((3825 - (609 + 1322)) <= (1860 - (13 + 441)))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v113()
		if (((5874 - 4302) >= (4010 - 2479)) and v40 and ((not v32 and v82) or not v82) and not v13:IsMoving() and v83.SigilOfFlame:IsCastable()) then
			if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((23343 - 18656) < (170 + 4372))) then
				if (((11952 - 8661) > (593 + 1074)) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(4 + 4))) then
					return "sigil_of_flame precombat 2";
				end
			elseif ((v78 == "cursor") or ((2590 - 1717) == (1114 + 920))) then
				if (v19(v85.SigilOfFlameCursor, not v14:IsInRange(55 - 25)) or ((1862 + 954) < (7 + 4))) then
					return "sigil_of_flame precombat 2";
				end
			end
		end
		if (((2658 + 1041) < (3952 + 754)) and v83.ImmolationAura:IsCastable() and v37) then
			if (((2589 + 57) >= (1309 - (153 + 280))) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(23 - 15))) then
				return "immolation_aura precombat 4";
			end
		end
		if (((552 + 62) <= (1258 + 1926)) and v83.InfernalStrike:IsCastable() and v38 and ((not v32 and v81) or not v81) and (v83.InfernalStrike:ChargesFractional() > (1.7 + 0))) then
			if (((2837 + 289) == (2266 + 860)) and v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(11 - 3))) then
				return "infernal_strike precombat 6";
			end
		end
		if ((v83.Fracture:IsCastable() and v36 and v91) or ((1352 + 835) >= (5621 - (89 + 578)))) then
			if (v19(v83.Fracture) or ((2770 + 1107) == (7431 - 3856))) then
				return "fracture precombat 8";
			end
		end
		if (((1756 - (572 + 477)) > (86 + 546)) and v83.Shear:IsCastable() and v39 and v91) then
			if (v19(v83.Shear) or ((328 + 218) >= (321 + 2363))) then
				return "shear precombat 10";
			end
		end
	end
	local function v114()
		local v142 = 86 - (84 + 2);
		while true do
			if (((2414 - 949) <= (3099 + 1202)) and ((844 - (497 + 345)) == v142)) then
				if (((44 + 1660) > (241 + 1184)) and v73 and (v13:HealthPercentage() <= v75)) then
					local v204 = 1333 - (605 + 728);
					while true do
						if ((v204 == (0 + 0)) or ((1526 - 839) == (195 + 4039))) then
							if ((v77 == "Refreshing Healing Potion") or ((12311 - 8981) < (1289 + 140))) then
								if (((3177 - 2030) >= (253 + 82)) and v84.RefreshingHealingPotion:IsReady()) then
									if (((3924 - (457 + 32)) > (890 + 1207)) and v19(v85.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v77 == "Dreamwalker's Healing Potion") or ((5172 - (832 + 570)) >= (3807 + 234))) then
								if (v84.DreamwalkersHealingPotion:IsReady() or ((989 + 2802) <= (5700 - 4089))) then
									if (v19(v85.RefreshingHealingPotion) or ((2206 + 2372) <= (2804 - (588 + 208)))) then
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
			if (((3032 - 1907) <= (3876 - (884 + 916))) and ((1 - 0) == v142)) then
				if ((v83.FieryBrand:IsCastable() and v60 and (v14:TimeToDie() > v70) and (v93 or (v13:HealthPercentage() <= v63))) or ((431 + 312) >= (5052 - (232 + 421)))) then
					if (((3044 - (1569 + 320)) < (411 + 1262)) and v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand))) then
						return "fiery_brand defensives";
					end
				end
				if ((v84.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v76)) or ((442 + 1882) <= (1947 - 1369))) then
					if (((4372 - (316 + 289)) == (9860 - 6093)) and v19(v85.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v142 = 1 + 1;
			end
			if (((5542 - (666 + 787)) == (4514 - (360 + 65))) and (v142 == (0 + 0))) then
				if (((4712 - (79 + 175)) >= (2638 - 964)) and v83.DemonSpikes:IsCastable() and v59 and v13:BuffDown(v83.DemonSpikesBuff) and v13:BuffDown(v83.MetamorphosisBuff) and (((v96 == (1 + 0)) and v13:BuffDown(v83.FieryBrandDebuff)) or (v96 > (2 - 1)))) then
					if (((1871 - 899) <= (2317 - (503 + 396))) and (v83.DemonSpikes:ChargesFractional() > (182.9 - (92 + 89)))) then
						if (v19(v83.DemonSpikes) or ((9579 - 4641) < (2443 + 2319))) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (v93 or (v13:HealthPercentage() <= v62) or ((1482 + 1022) > (16698 - 12434))) then
						if (((295 + 1858) == (4908 - 2755)) and v19(v83.DemonSpikes)) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if ((v83.Metamorphosis:IsCastable() and v61 and (v13:HealthPercentage() <= v64) and (v13:BuffDown(v83.MetamorphosisBuff) or (v14:TimeToDie() < (14 + 1)))) or ((243 + 264) >= (7891 - 5300))) then
					if (((560 + 3921) == (6833 - 2352)) and v19(v85.MetamorphosisPlayer)) then
						return "metamorphosis defensives";
					end
				end
				v142 = 1245 - (485 + 759);
			end
		end
	end
	local function v115()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (1189 - (442 + 747))) or ((3463 - (832 + 303)) < (1639 - (88 + 858)))) then
				if (((1320 + 3008) == (3582 + 746)) and v60 and v79 and (v14:TimeToDie() > v70) and v83.FieryBrand:IsCastable() and (((v83.FieryBrandDebuff:AuraActiveCount() == (0 + 0)) and ((v83.SigilOfFlame:CooldownRemains() <= (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.SoulCarver:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.FelDevastation:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())))) or (v83.DownInFlames:IsAvailable() and (v83.FieryBrand:FullRechargeTime() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains()))))) then
					if (((2377 - (766 + 23)) >= (6575 - 5243)) and v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand))) then
						return "fiery_brand maintenance 2";
					end
				end
				if ((v40 and v83.SigilOfFlame:IsCastable() and ((not v32 and v82) or not v82) and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) or ((10996 - 6822) > (14417 - 10169))) then
					if (v83.ConcentratedSigils:IsAvailable() or (v78 == "player") or ((5659 - (1036 + 37)) <= (59 + 23))) then
						if (((7522 - 3659) == (3039 + 824)) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(1488 - (641 + 839)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v78 == "cursor") or ((1195 - (910 + 3)) <= (106 - 64))) then
						if (((6293 - (1466 + 218)) >= (353 + 413)) and v19(v85.SigilOfFlameCursor, not v14:IsInRange(1178 - (556 + 592)))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				if ((v37 and v83.ImmolationAura:IsCastable()) or ((410 + 742) == (3296 - (329 + 479)))) then
					if (((4276 - (174 + 680)) > (11511 - 8161)) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(16 - 8))) then
						return "immolation_aura maintenance 6";
					end
				end
				v143 = 1 + 0;
			end
			if (((1616 - (396 + 343)) > (34 + 342)) and (v143 == (1478 - (29 + 1448)))) then
				if ((v33 and v83.BulkExtraction:IsCastable() and (((1394 - (135 + 1254)) - v87) <= v96) and (v87 <= (7 - 5))) or ((14558 - 11440) <= (1234 + 617))) then
					if (v19(v83.BulkExtraction, not v91) or ((1692 - (389 + 1138)) >= (4066 - (102 + 472)))) then
						return "bulk_extraction maintenance 8";
					end
				end
				if (((3727 + 222) < (2693 + 2163)) and v103 and not v102 and v42) then
					if (v19(v83.Pool) or ((3988 + 288) < (4561 - (320 + 1225)))) then
						return "Wait for Spirit Bomb";
					end
				end
				if (((8349 - 3659) > (2524 + 1601)) and v42 and v83.SpiritBomb:IsReady() and v102) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(1472 - (157 + 1307))) or ((1909 - (821 + 1038)) >= (2235 - 1339))) then
						return "spirit_bomb maintenance 10";
					end
				end
				v143 = 1 + 1;
			end
			if ((v143 == (4 - 1)) or ((638 + 1076) >= (7331 - 4373))) then
				if ((v42 and v83.SpiritBomb:IsReady() and (v13:FuryDeficit() <= (1056 - (834 + 192))) and (v96 > (1 + 0)) and (v87 >= (2 + 2))) or ((33 + 1458) < (997 - 353))) then
					if (((1008 - (300 + 4)) < (264 + 723)) and v19(v83.SpiritBomb, not v14:IsInMeleeRange(20 - 12))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if (((4080 - (112 + 250)) > (760 + 1146)) and v41 and v83.SoulCleave:IsReady() and not v103 and (v13:FuryDeficit() <= (100 - 60))) then
					if (v19(v83.SoulCleave, not v91) or ((549 + 409) > (1880 + 1755))) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if (((2619 + 882) <= (2228 + 2264)) and (v143 == (2 + 0))) then
				if ((v35 and v83.Felblade:IsReady() and (((not v83.SpiritBomb:IsAvailable() or (v96 == (1415 - (1001 + 413)))) and (v13:FuryDeficit() >= (89 - 49))) or ((v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (932 - (244 + 638)))))) or ((4135 - (627 + 66)) < (7591 - 5043))) then
					if (((3477 - (512 + 90)) >= (3370 - (1665 + 241))) and v19(v83.Felblade, not v91)) then
						return "felblade maintenance 12";
					end
				end
				if ((v36 and v83.Fracture:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (767 - (373 + 344)))) or ((2164 + 2633) >= (1295 + 3598))) then
					if (v19(v83.Fracture, not v91) or ((1453 - 902) > (3499 - 1431))) then
						return "fracture maintenance 14";
					end
				end
				if (((3213 - (35 + 1064)) > (687 + 257)) and v39 and v83.Shear:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (106 - 56))) then
					if (v19(v83.Shear, not v91) or ((10 + 2252) >= (4332 - (298 + 938)))) then
						return "shear maintenance 16";
					end
				end
				v143 = 1262 - (233 + 1026);
			end
		end
	end
	local function v116()
		local v144 = 1666 - (636 + 1030);
		while true do
			if ((v144 == (2 + 1)) or ((2203 + 52) >= (1051 + 2486))) then
				if ((v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1.85 + 0)) and (v13:Fury() >= (261 - (55 + 166))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((744 + 3093) < (132 + 1174))) then
					if (((11266 - 8316) == (3247 - (36 + 261))) and (v57 == "player")) then
						if (v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(13 - 5)) or ((6091 - (34 + 1334)) < (1268 + 2030))) then
							return "elysian_decree fiery_demise 14 (Player)";
						end
					elseif (((883 + 253) >= (1437 - (1035 + 248))) and (v57 == "cursor")) then
						if (v19(v85.ElysianDecreeCursor, not v14:IsInRange(51 - (20 + 1))) or ((142 + 129) > (5067 - (134 + 185)))) then
							return "elysian_decree fiery_demise 14 (Cursor)";
						end
					end
				end
				if (((5873 - (549 + 584)) >= (3837 - (314 + 371))) and v103 and not v102 and v42) then
					if (v19(v83.Pool) or ((8850 - 6272) >= (4358 - (478 + 490)))) then
						return "Wait for Spirit Bomb";
					end
				end
				v144 = 3 + 1;
			end
			if (((1213 - (786 + 386)) <= (5379 - 3718)) and (v144 == (1381 - (1055 + 324)))) then
				if (((1941 - (1093 + 247)) < (3164 + 396)) and v51 and v83.SoulCarver:IsCastable() and (v88 < (1 + 2)) and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (((932 - 697) < (2331 - 1644)) and v19(v83.SoulCarver, not v91)) then
						return "soul_carver fiery_demise 10";
					end
				end
				if (((12943 - 8394) > (2897 - 1744)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
					if (v19(v83.TheHunt, not v14:IsInRange(11 + 19)) or ((18006 - 13332) < (16103 - 11431))) then
						return "the_hunt fiery_demise 12";
					end
				end
				v144 = 3 + 0;
			end
			if (((9380 - 5712) < (5249 - (364 + 324))) and (v144 == (2 - 1))) then
				if ((v35 and v83.Felblade:IsReady() and (not v83.SpiritBomb:IsAvailable() or (v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains()))) and (v13:Fury() < (119 - 69))) or ((151 + 304) == (15084 - 11479))) then
					if (v19(v83.Felblade, not v91) or ((4264 - 1601) == (10058 - 6746))) then
						return "felblade fiery_demise 6";
					end
				end
				if (((5545 - (1249 + 19)) <= (4040 + 435)) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105) and v83.FelDevastation:IsReady()) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(31 - 23)) or ((1956 - (686 + 400)) == (933 + 256))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v144 = 231 - (73 + 156);
			end
			if (((8 + 1545) <= (3944 - (721 + 90))) and (v144 == (1 + 3))) then
				if ((v83.SpiritBomb:IsReady() and v42 and v102) or ((7263 - 5026) >= (3981 - (224 + 246)))) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(12 - 4)) or ((2437 - 1113) > (548 + 2472))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				break;
			end
			if ((v144 == (0 + 0)) or ((2198 + 794) == (3739 - 1858))) then
				if (((10336 - 7230) > (2039 - (203 + 310))) and v37 and v83.ImmolationAura:IsCastable()) then
					if (((5016 - (1238 + 755)) < (271 + 3599)) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(1542 - (709 + 825)))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if (((262 - 119) > (107 - 33)) and v40 and v83.SigilOfFlame:IsCastable() and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (864 - (196 + 668))))) then
					if (((70 - 52) < (4374 - 2262)) and (v83.ConcentratedSigils:IsAvailable() or (v78 == "player"))) then
						if (((1930 - (171 + 662)) <= (1721 - (4 + 89))) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(27 - 19))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif (((1686 + 2944) == (20336 - 15706)) and (v78 == "cursor")) then
						if (((1389 + 2151) > (4169 - (35 + 1451))) and v19(v85.SigilOfFlameCursor, not v14:IsInRange(1483 - (28 + 1425)))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				v144 = 1994 - (941 + 1052);
			end
		end
	end
	local function v117()
		if (((4597 + 197) >= (4789 - (822 + 692))) and v83.SigilOfChains:IsCastable() and v47 and (v83.CycleofBinding:IsAvailable())) then
			if (((2118 - 634) == (699 + 785)) and ((v78 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((1729 - (45 + 252)) < (3518 + 37)) and v19(v85.SigilOfChainsPlayer, not v14:IsInMeleeRange(3 + 5))) then
					return "sigil_of_chains player filler 2";
				end
			elseif ((v78 == "cursor") or ((2591 - 1526) > (4011 - (114 + 319)))) then
				if (v19(v85.SigilOfChainsCursor, not v14:IsInRange(43 - 13)) or ((6144 - 1349) < (897 + 510))) then
					return "sigil_of_chains cursor filler 2";
				end
			end
		end
		if (((2760 - 907) < (10084 - 5271)) and v83.SigilOfMisery:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v48) then
			if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((4784 - (556 + 1407)) < (3637 - (741 + 465)))) then
				if (v19(v85.SigilOfMiseryPlayer, not v14:IsInMeleeRange(473 - (170 + 295))) or ((1515 + 1359) < (2004 + 177))) then
					return "sigil_of_misery player filler 4";
				end
			elseif ((v78 == "cursor") or ((6620 - 3931) <= (285 + 58))) then
				if (v19(v85.SigilOfMiseryCursor, not v14:IsInRange(20 + 10)) or ((1059 + 810) == (3239 - (957 + 273)))) then
					return "sigil_of_misery cursor filler 4";
				end
			end
		end
		if ((v83.SigilOfSilence:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v46) or ((949 + 2597) < (930 + 1392))) then
			if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((7933 - 5851) == (12577 - 7804))) then
				if (((9908 - 6664) > (5224 - 4169)) and v19(v85.SigilOfSilencePlayer, not v14:IsInMeleeRange(1788 - (389 + 1391)))) then
					return "sigil_of_silence player filler 6";
				end
			elseif ((v78 == "cursor") or ((2079 + 1234) <= (186 + 1592))) then
				if (v19(v85.SigilOfSilenceCursor, not v14:IsInRange(68 - 38)) or ((2372 - (783 + 168)) >= (7061 - 4957))) then
					return "sigil_of_silence cursor filler 6";
				end
			end
		end
		if (((1783 + 29) <= (3560 - (309 + 2))) and v83.Felblade:IsReady() and v35) then
			if (((4984 - 3361) <= (3169 - (1090 + 122))) and v19(v83.Felblade, not v91)) then
				return "felblade filler 8";
			end
		end
		if (((1431 + 2981) == (14817 - 10405)) and v83.Shear:IsCastable() and v39) then
			if (((1198 + 552) >= (1960 - (628 + 490))) and v19(v83.Shear, not v91)) then
				return "shear filler 10";
			end
		end
		if (((784 + 3588) > (4580 - 2730)) and v83.ThrowGlaive:IsCastable() and v43) then
			if (((1060 - 828) < (1595 - (431 + 343))) and v19(v83.ThrowGlaive, not v14:IsInRange(60 - 30))) then
				return "throw_glaive filler 12";
			end
		end
	end
	local function v118()
		if (((1498 - 980) < (713 + 189)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
			if (((383 + 2611) > (2553 - (556 + 1139))) and v19(v83.TheHunt, not v14:IsInRange(65 - (6 + 9)))) then
				return "the_hunt single_target 2";
			end
		end
		if ((v83.SoulCarver:IsCastable() and v51 and ((v31 and v55) or not v55) and (v70 < v105)) or ((688 + 3067) <= (469 + 446))) then
			if (((4115 - (28 + 141)) > (1450 + 2293)) and v19(v83.SoulCarver, not v91)) then
				return "soul_carver single_target 4";
			end
		end
		if ((v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) or ((1647 - 312) >= (2342 + 964))) then
			if (((6161 - (486 + 831)) > (5862 - 3609)) and v19(v83.FelDevastation, not v14:IsInMeleeRange(70 - 50))) then
				return "fel_devastation single_target 6";
			end
		end
		if (((86 + 366) == (1429 - 977)) and v83.ElysianDecree:IsCastable() and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
			if ((v57 == "player") or ((5820 - (668 + 595)) < (1878 + 209))) then
				if (((782 + 3092) == (10564 - 6690)) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(320 - (23 + 267)))) then
					return "elysian_decree single_target 8 (Player)";
				end
			elseif ((v57 == "cursor") or ((3882 - (1129 + 815)) > (5322 - (371 + 16)))) then
				if (v19(v85.ElysianDecreeCursor, not v14:IsInRange(1780 - (1326 + 424))) or ((8058 - 3803) < (12508 - 9085))) then
					return "elysian_decree single_target 8 (Cursor)";
				end
			end
		end
		if (((1572 - (88 + 30)) <= (3262 - (720 + 51))) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
			if (v19(v83.FelDevastation, not v14:IsInMeleeRange(44 - 24)) or ((5933 - (421 + 1355)) <= (4624 - 1821))) then
				return "fel_devastation single_target 10";
			end
		end
		if (((2384 + 2469) >= (4065 - (286 + 797))) and v83.SoulCleave:IsReady() and not v97 and v41) then
			if (((15112 - 10978) > (5560 - 2203)) and v19(v83.SoulCleave, not v91)) then
				return "soul_cleave single_target 12";
			end
		end
		if ((v83.Fracture:IsCastable() and v36) or ((3856 - (397 + 42)) < (792 + 1742))) then
			if (v19(v83.Fracture, not v91) or ((3522 - (24 + 776)) <= (252 - 88))) then
				return "fracture single_target 14";
			end
		end
		v28 = v117();
		if (v28 or ((3193 - (222 + 563)) < (4646 - 2537))) then
			return v28;
		end
	end
	local function v119()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (191 - (23 + 167))) or ((1831 - (690 + 1108)) == (525 + 930))) then
				if ((v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1.85 + 0)) and (v13:Fury() >= (888 - (40 + 808))) and ((v88 <= (1 + 0)) or (v88 >= (15 - 11))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((424 + 19) >= (2125 + 1890))) then
					if (((1855 + 1527) > (737 - (47 + 524))) and (v57 == "player")) then
						if (v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(20 + 10)) or ((765 - 485) == (4573 - 1514))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif (((4289 - 2408) > (3019 - (1165 + 561))) and (v57 == "cursor")) then
						if (((71 + 2286) == (7299 - 4942)) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(12 + 18))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				if (((602 - (341 + 138)) == (34 + 89)) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(41 - 21)) or ((1382 - (89 + 237)) >= (10911 - 7519))) then
						return "fel_devastation small_aoe 8";
					end
				end
				v145 = 3 - 1;
			end
			if ((v145 == (881 - (581 + 300))) or ((2301 - (855 + 365)) < (2553 - 1478))) then
				if ((v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) or ((343 + 706) >= (5667 - (1030 + 205)))) then
					if (v19(v83.TheHunt, not v14:IsInRange(47 + 3)) or ((4436 + 332) <= (1132 - (156 + 130)))) then
						return "the_hunt small_aoe 2";
					end
				end
				if ((v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) or ((7629 - 4271) <= (2393 - 973))) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(40 - 20)) or ((986 + 2753) <= (1753 + 1252))) then
						return "fel_devastation small_aoe 4";
					end
				end
				v145 = 70 - (10 + 59);
			end
			if ((v145 == (2 + 2)) or ((8170 - 6511) >= (3297 - (671 + 492)))) then
				if (v28 or ((2596 + 664) < (3570 - (369 + 846)))) then
					return v28;
				end
				break;
			end
			if (((1 + 2) == v145) or ((571 + 98) == (6168 - (1036 + 909)))) then
				if ((v83.Fracture:IsCastable() and v36) or ((1346 + 346) < (987 - 399))) then
					if (v19(v83.Fracture, not v91) or ((5000 - (11 + 192)) < (1846 + 1805))) then
						return "fracture small_aoe 14";
					end
				end
				v28 = v117();
				v145 = 179 - (135 + 40);
			end
			if ((v145 == (4 - 2)) or ((2518 + 1659) > (10684 - 5834))) then
				if ((v83.SoulCarver:IsCastable() and (v88 < (4 - 1)) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) or ((576 - (50 + 126)) > (3093 - 1982))) then
					if (((676 + 2375) > (2418 - (1233 + 180))) and v19(v83.SoulCarver, not v91)) then
						return "soul_carver small_aoe 10";
					end
				end
				if (((4662 - (522 + 447)) <= (5803 - (107 + 1314))) and v83.SoulCleave:IsReady() and ((v87 <= (1 + 0)) or not v83.SpiritBomb:IsAvailable()) and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((10000 - 6718) > (1742 + 2358))) then
						return "soul_cleave small_aoe 12";
					end
				end
				v145 = 5 - 2;
			end
		end
	end
	local function v120()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1910 - (716 + 1194))) or ((62 + 3518) < (305 + 2539))) then
				if (((592 - (74 + 429)) < (8661 - 4171)) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or v83.StoketheFlames:IsAvailable()) and v50 and ((v31 and v54) or not v54) and (v70 < v105) and ((not v32 and v81) or not v81)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(10 + 10)) or ((11406 - 6423) < (1280 + 528))) then
						return "fel_devastation big_aoe 2";
					end
				end
				if (((11804 - 7975) > (9318 - 5549)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
					if (((1918 - (279 + 154)) <= (3682 - (454 + 324))) and v19(v83.TheHunt, not v14:IsInRange(40 + 10))) then
						return "the_hunt big_aoe 4";
					end
				end
				if (((4286 - (12 + 5)) == (2302 + 1967)) and v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (2.85 - 1)) and (v13:Fury() >= (15 + 25)) and ((v88 <= (1094 - (277 + 816))) or (v88 >= (17 - 13))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
					if (((1570 - (1058 + 125)) <= (522 + 2260)) and (v57 == "player")) then
						if (v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(1005 - (815 + 160))) or ((8147 - 6248) <= (2176 - 1259))) then
							return "elysian_decree big_aoe 6 (Player)";
						end
					elseif ((v57 == "cursor") or ((1029 + 3283) <= (2560 - 1684))) then
						if (((4130 - (41 + 1857)) <= (4489 - (1222 + 671))) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(77 - 47))) then
							return "elysian_decree big_aoe 6 (Cursor)";
						end
					end
				end
				if (((3010 - 915) < (4868 - (229 + 953))) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(1794 - (1111 + 663))) or ((3174 - (874 + 705)) >= (627 + 3847))) then
						return "fel_devastation big_aoe 8";
					end
				end
				v146 = 1 + 0;
			end
			if ((v146 == (3 - 1)) or ((130 + 4489) < (3561 - (642 + 37)))) then
				if ((v83.SoulCleave:IsReady() and not v97 and v41) or ((68 + 226) >= (773 + 4058))) then
					if (((5093 - 3064) <= (3538 - (233 + 221))) and v19(v83.SoulCleave, not v91)) then
						return "soul_cleave big_aoe 18";
					end
				end
				v28 = v117();
				if (v28 or ((4710 - 2673) == (2131 + 289))) then
					return v28;
				end
				break;
			end
			if (((5999 - (718 + 823)) > (2457 + 1447)) and (v146 == (806 - (266 + 539)))) then
				if (((1234 - 798) >= (1348 - (636 + 589))) and v83.SoulCarver:IsCastable() and (v88 < (6 - 3)) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (((1031 - 531) < (1440 + 376)) and v19(v83.SoulCarver, not v91)) then
						return "soul_carver big_aoe 10";
					end
				end
				if (((1299 + 2275) == (4589 - (657 + 358))) and v83.SpiritBomb:IsReady() and (v87 >= (10 - 6)) and v42) then
					if (((503 - 282) < (1577 - (1151 + 36))) and v19(v83.SpiritBomb, not v14:IsInMeleeRange(8 + 0))) then
						return "spirit_bomb big_aoe 12";
					end
				end
				if ((v83.SoulCleave:IsReady() and (not v83.SpiritBomb:IsAvailable() or not v97) and v41) or ((582 + 1631) <= (4243 - 2822))) then
					if (((4890 - (1552 + 280)) < (5694 - (64 + 770))) and v19(v83.SoulCleave, not v91)) then
						return "soul_cleave big_aoe 14";
					end
				end
				if ((v83.Fracture:IsCastable() and v36) or ((880 + 416) >= (10092 - 5646))) then
					if (v19(v83.Fracture, not v91) or ((248 + 1145) > (5732 - (157 + 1086)))) then
						return "fracture big_aoe 16";
					end
				end
				v146 = 3 - 1;
			end
		end
	end
	local function v121()
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
		v63 = EpicSettings.Settings['fieryBrandHP'] or (0 - 0);
		v64 = EpicSettings.Settings['metamorphosisHP'] or (0 - 0);
		v78 = EpicSettings.Settings['sigilSetting'] or "player";
		v57 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v58 = EpicSettings.Settings['elysianDecreeSlider'] or (819 - (599 + 220));
		v79 = EpicSettings.Settings['fieryBrandOffensively'];
		v80 = EpicSettings.Settings['metamorphosisOffensively'];
	end
	local function v122()
		v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v65 = EpicSettings.Settings['dispelBuffs'];
		v67 = EpicSettings.Settings['InterruptWithStun'];
		v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v69 = EpicSettings.Settings['InterruptThreshold'];
		v71 = EpicSettings.Settings['useTrinkets'];
		v72 = EpicSettings.Settings['trinketsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v73 = EpicSettings.Settings['useHealingPotion'];
		v76 = EpicSettings.Settings['healthstoneHP'] or (1931 - (1813 + 118));
		v75 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v77 = EpicSettings.Settings['HealingPotionName'] or "";
		v66 = EpicSettings.Settings['HandleIncorporeal'];
		v82 = EpicSettings.Settings['RMBAOE'];
		v81 = EpicSettings.Settings['RMBMovement'];
	end
	local function v123()
		local v187 = 1217 - (841 + 376);
		while true do
			if ((v187 == (0 - 0)) or ((1028 + 3396) < (73 - 46))) then
				v121();
				v122();
				v29 = EpicSettings.Toggles['ooc'];
				v187 = 860 - (464 + 395);
			end
			if (((12 - 7) == v187) or ((960 + 1037) > (4652 - (467 + 370)))) then
				v88 = v87 + v89;
				if (((7160 - 3695) > (1405 + 508)) and v66) then
					local v205 = 0 - 0;
					while true do
						if (((115 + 618) < (4231 - 2412)) and (v205 == (520 - (150 + 370)))) then
							v28 = v21.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 1302 - (74 + 1208));
							if (v28 or ((10810 - 6415) == (22550 - 17795))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v21.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((2699 + 1094) < (2759 - (14 + 376)))) then
					v98 = v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (0 - 0));
					v99 = v96 == (1 + 0);
					v100 = (v96 >= (2 + 0)) and (v96 <= (5 + 0));
					v101 = v96 >= (17 - 11);
					v97 = ((v83.FelDevastation:CooldownRemains() <= (v83.SoulCleave:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (61 + 19))) or (((v89 > (79 - (23 + 55))) or (v88 >= (11 - 6))) and not v99);
					if (v98 or ((2726 + 1358) == (238 + 27))) then
						v102 = (v99 and (v87 >= (7 - 2))) or (v100 and (v87 >= (2 + 2))) or (v101 and (v87 >= (904 - (652 + 249))));
					else
						v102 = (v100 and (v87 >= (13 - 8))) or (v101 and (v87 >= (1872 - (708 + 1160))));
					end
					if (((11829 - 7471) == (7945 - 3587)) and v98) then
						v103 = (v99 and (v88 >= (32 - (10 + 17)))) or (v100 and (v88 >= (1 + 3))) or (v101 and (v88 >= (1735 - (1400 + 332))));
					else
						v103 = (v100 and (v88 >= (9 - 4))) or (v101 and (v88 >= (1912 - (242 + 1666))));
					end
					if ((v83.ThrowGlaive:IsCastable() and v43 and v11.ValueIsInArray(v106, v14:NPCID())) or ((1343 + 1795) < (364 + 629))) then
						if (((2838 + 492) > (3263 - (850 + 90))) and v19(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
							return "fodder to the flames on those filthy demons";
						end
					end
					if ((v83.ThrowGlaive:IsReady() and v43 and v11.ValueIsInArray(v106, v15:NPCID())) or ((6350 - 2724) == (5379 - (360 + 1030)))) then
						if (v19(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((811 + 105) == (7538 - 4867))) then
							return "fodder to the flames react per mouseover";
						end
					end
					if (((373 - 101) == (1933 - (909 + 752))) and not v13:AffectingCombat() and v29) then
						local v207 = 1223 - (109 + 1114);
						while true do
							if (((7778 - 3529) <= (1884 + 2955)) and (v207 == (242 - (6 + 236)))) then
								v28 = v113();
								if (((1750 + 1027) < (2576 + 624)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if (((224 - 129) < (3418 - 1461)) and v83.ConsumeMagic:IsAvailable() and v34 and v83.ConsumeMagic:IsReady() and v65 and not v13:IsCasting() and not v13:IsChanneling() and v21.UnitHasMagicBuff(v14)) then
						if (((1959 - (1076 + 57)) < (283 + 1434)) and v19(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((2115 - (579 + 110)) >= (88 + 1017)) and v94) then
						local v208 = 0 + 0;
						while true do
							if (((1462 + 1292) <= (3786 - (174 + 233))) and (v208 == (0 - 0))) then
								v28 = v114();
								if (v28 or ((6892 - 2965) == (629 + 784))) then
									return v28;
								end
								break;
							end
						end
					end
					if ((v83.InfernalStrike:IsCastable() and v38 and (v83.InfernalStrike:ChargesFractional() > (1175.7 - (663 + 511))) and (v83.InfernalStrike:TimeSinceLastCast() > (2 + 0))) or ((251 + 903) <= (2429 - 1641))) then
						if (v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(5 + 3)) or ((3867 - 2224) > (8179 - 4800))) then
							return "infernal_strike main 2";
						end
					end
					if (((v70 < v105) and v83.Metamorphosis:IsCastable() and v61 and v80 and v13:BuffDown(v83.MetamorphosisBuff) and (v83.FelDevastation:CooldownRemains() > (6 + 6))) or ((5455 - 2652) > (3242 + 1307))) then
						if (v19(v85.MetamorphosisPlayer, not v91) or ((21 + 199) >= (3744 - (478 + 244)))) then
							return "metamorphosis main 4";
						end
					end
					local v206 = v21.HandleDPSPotion();
					if (((3339 - (440 + 77)) == (1284 + 1538)) and v206) then
						return v206;
					end
					if ((v70 < v105) or ((3883 - 2822) == (3413 - (655 + 901)))) then
						if (((512 + 2248) > (1045 + 319)) and v71 and ((v31 and v72) or not v72)) then
							v28 = v112();
							if (v28 or ((3310 + 1592) <= (14482 - 10887))) then
								return v28;
							end
						end
					end
					if ((v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (1445 - (695 + 750)))) or ((13153 - 9301) == (451 - 158))) then
						v28 = v116();
						if (v28 or ((6269 - 4710) == (4939 - (285 + 66)))) then
							return v28;
						end
					end
					v28 = v115();
					if (v28 or ((10452 - 5968) == (2098 - (682 + 628)))) then
						return v28;
					end
					if (((737 + 3831) >= (4206 - (176 + 123))) and v99) then
						v28 = v118();
						if (((522 + 724) < (2518 + 952)) and v28) then
							return v28;
						end
					end
					if (((4337 - (239 + 30)) >= (265 + 707)) and v100) then
						local v209 = 0 + 0;
						while true do
							if (((871 - 378) < (12145 - 8252)) and (v209 == (315 - (306 + 9)))) then
								v28 = v119();
								if (v28 or ((5140 - 3667) >= (580 + 2752))) then
									return v28;
								end
								break;
							end
						end
					end
					if (v101 or ((2486 + 1565) <= (557 + 600))) then
						local v210 = 0 - 0;
						while true do
							if (((1979 - (1140 + 235)) < (1834 + 1047)) and ((0 + 0) == v210)) then
								v28 = v120();
								if (v28 or ((231 + 669) == (3429 - (33 + 19)))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((1610 + 2849) > (1771 - 1180)) and ((2 + 2) == v187)) then
				if (((6663 - 3265) >= (2246 + 149)) and (v21.TargetIsValid() or v13:AffectingCombat())) then
					v104 = v9.BossFightRemains(nil, true);
					v105 = v104;
					if ((v105 == (11800 - (586 + 103))) or ((199 + 1984) >= (8693 - 5869))) then
						v105 = v9.FightRemains(v95, false);
					end
				end
				v87 = v107.AuraSouls;
				v89 = v107.IncomingSouls;
				v187 = 1493 - (1309 + 179);
			end
			if (((3494 - 1558) == (843 + 1093)) and ((5 - 3) == v187)) then
				if (IsMouseButtonDown("RightButton") or ((3650 + 1182) < (9163 - 4850))) then
					v32 = true;
				else
					v32 = false;
				end
				v95 = v13:GetEnemiesInMeleeRange(15 - 7);
				if (((4697 - (295 + 314)) > (9514 - 5640)) and v30) then
					v96 = #v95;
				else
					v96 = 1963 - (1300 + 662);
				end
				v187 = 9 - 6;
			end
			if (((6087 - (1178 + 577)) == (2250 + 2082)) and (v187 == (2 - 1))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				if (((5404 - (851 + 554)) >= (2565 + 335)) and v13:IsDeadOrGhost()) then
					return v28;
				end
				v187 = 5 - 3;
			end
			if (((6 - 3) == v187) or ((2827 - (115 + 187)) > (3113 + 951))) then
				v111();
				v93 = v13:ActiveMitigationNeeded();
				v94 = v13:IsTankingAoE(8 + 0) or v13:IsTanking(v14);
				v187 = 15 - 11;
			end
		end
	end
	local function v124()
		v18.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v83.FieryBrandDebuff:RegisterAuraTracking();
		v83.SigilOfFlameDebuff:RegisterAuraTracking();
	end
	v18.SetAPL(1742 - (160 + 1001), v123, v124);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

