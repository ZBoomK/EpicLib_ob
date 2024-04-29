local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((12718 - 7936) <= (3197 - (1339 + 659)))) then
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
	local v90 = ((v83.SoulSigils:IsAvailable()) and (3 + 1)) or (714 - (530 + 181));
	local v91, v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97, v98, v99, v100, v101, v102, v103;
	local v104 = 11992 - (614 + 267);
	local v105 = 11143 - (19 + 13);
	local v106 = {(394808 - 225387),(44002 + 125423),(350338 - 181406),(345681 - 176255),(324002 - 154573),(399127 - 229699),(34567 + 134863)};
	v9:RegisterForEvent(function()
		local v125 = 0 - 0;
		while true do
			if ((v125 == (0 + 0)) or ((1616 + 3248) < (1189 + 713))) then
				v104 = 12207 - (709 + 387);
				v105 = 12969 - (673 + 1185);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v90 = ((v83.SoulSigils:IsAvailable()) and (11 - 7)) or (9 - 6);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v107 = {};
	local v108 = v107;
	v108.AuraSouls = 0 - 0;
	v108.IncomingSouls = 0 + 0;
	v9:RegisterForSelfCombatEvent(function(...)
		local v126 = 0 + 0;
		local v127;
		local v128;
		while true do
			if (((6532 - 1693) >= (909 + 2791)) and (v126 == (0 - 0))) then
				v127 = select(23 - 11, ...);
				v128 = 1880 - (446 + 1434);
				v126 = 1284 - (1040 + 243);
			end
			if ((v126 == (2 - 1)) or ((2922 - (559 + 1288)) > (3849 - (609 + 1322)))) then
				if (((850 - (13 + 441)) <= (14214 - 10410)) and ((v127 == v83.Fracture:ID()) or (v127 == v83.Shear:ID()))) then
					v128 = 5 - 3;
				elseif ((v127 == v83.SoulCarver:ID()) or ((20763 - 16594) == (82 + 2105))) then
					local v209 = 0 - 0;
					while true do
						if (((500 + 906) == (617 + 789)) and ((2 - 1) == v209)) then
							C_Timer.After(2 + 0, function()
								v108.IncomingSouls = v108.IncomingSouls + (1 - 0);
							end);
							C_Timer.After(2 + 1, function()
								v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
							end);
							break;
						end
						if (((1101 + 430) < (3587 + 684)) and (v209 == (0 + 0))) then
							v128 = 436 - (153 + 280);
							C_Timer.After(2 - 1, function()
								v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
							end);
							v209 = 1 + 0;
						end
					end
				elseif (((333 + 302) == (577 + 58)) and (v127 == v83.ElysianDecree:ID())) then
					v128 = ((v83.SoulSigils:IsAvailable()) and (3 + 1)) or (4 - 1);
				elseif (((2085 + 1288) <= (4223 - (89 + 578))) and v83.SoulSigils:IsAvailable() and ((v127 == v83.SigilOfFlame:ID()) or (v127 == v83.SigilOfMisery:ID()) or (v127 == v83.SigilOfChains:ID()) or (v127 == v83.SigilOfSilence:ID()))) then
					v128 = 1 + 0;
				else
					v128 = 0 - 0;
				end
				if ((v128 > (1049 - (572 + 477))) or ((444 + 2847) < (1969 + 1311))) then
					v108.IncomingSouls = v108.IncomingSouls + v128;
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v9:RegisterForSelfCombatEvent(function(...)
		local v129 = 0 + 0;
		local v130;
		while true do
			if (((4472 - (84 + 2)) >= (1438 - 565)) and (v129 == (0 + 0))) then
				v130 = select(854 - (497 + 345), ...);
				if (((24 + 897) <= (187 + 915)) and (v130 == (427005 - (605 + 728)))) then
					v108.IncomingSouls = v108.IncomingSouls + 1 + 0;
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v131 = 0 - 0;
		local v132;
		while true do
			if (((216 + 4490) >= (3560 - 2597)) and (v131 == (0 + 0))) then
				v132 = select(32 - 20, ...);
				if ((v132 == (154017 + 49964)) or ((1449 - (457 + 32)) <= (372 + 504))) then
					local v202 = 1402 - (832 + 570);
					while true do
						if (((0 + 0) == v202) or ((539 + 1527) == (3297 - 2365))) then
							v108.AuraSouls = 1 + 0;
							v108.IncomingSouls = v26(796 - (588 + 208), v108.IncomingSouls - (2 - 1));
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v133, v134, v134, v134, v135 = select(1812 - (884 + 916), ...);
		if (((10101 - 5276) < (2809 + 2034)) and (v133 == (204634 - (232 + 421)))) then
			local v181 = 1889 - (1569 + 320);
			while true do
				if (((0 + 0) == v181) or ((737 + 3140) >= (15288 - 10751))) then
					v108.AuraSouls = v135;
					v108.IncomingSouls = v26(605 - (316 + 289), v108.IncomingSouls - v135);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v136 = 0 - 0;
		local v137;
		local v138;
		local v139;
		while true do
			if ((v136 == (0 + 0)) or ((5768 - (666 + 787)) < (2151 - (360 + 65)))) then
				v137, v138, v138, v138, v139 = select(12 + 0, ...);
				if ((v137 == (204235 - (79 + 175))) or ((5800 - 2121) < (488 + 137))) then
					v108.AuraSouls = v139;
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED_DOSE");
	v9:RegisterForSelfCombatEvent(function(...)
		local v140, v141, v141, v141, v142 = select(36 - 24, ...);
		if ((v140 == (392838 - 188857)) or ((5524 - (503 + 396)) < (813 - (92 + 89)))) then
			v108.AuraSouls = 0 - 0;
		end
	end, "SPELL_AURA_REMOVED");
	local function v111()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (0 + 0)) or ((324 - 241) > (244 + 1536))) then
				if (((1244 - 698) <= (940 + 137)) and ((v83.Felblade:TimeSinceLastCast() < v13:GCD()) or (v83.InfernalStrike:TimeSinceLastCast() < v13:GCD()))) then
					v91 = true;
					v92 = true;
					return;
				end
				v91 = v14:IsInMeleeRange(3 + 2);
				v143 = 2 - 1;
			end
			if ((v143 == (1 + 0)) or ((1518 - 522) > (5545 - (485 + 759)))) then
				v92 = v91 or (v96 > (0 - 0));
				break;
			end
		end
	end
	local function v112()
		local v144 = 1189 - (442 + 747);
		while true do
			if (((5205 - (832 + 303)) > (1633 - (88 + 858))) and (v144 == (1 + 0))) then
				v28 = v21.HandleBottomTrinket(v86, v31, 34 + 6, nil);
				if (v28 or ((28 + 628) >= (4119 - (766 + 23)))) then
					return v28;
				end
				break;
			end
			if (((0 - 0) == v144) or ((3407 - 915) <= (882 - 547))) then
				v28 = v21.HandleTopTrinket(v86, v31, 135 - 95, nil);
				if (((5395 - (1036 + 37)) >= (1817 + 745)) and v28) then
					return v28;
				end
				v144 = 1 - 0;
			end
		end
	end
	local function v113()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (1481 - (641 + 839))) or ((4550 - (910 + 3)) >= (9610 - 5840))) then
				if ((v83.InfernalStrike:IsCastable() and v38 and ((not v32 and v81) or not v81) and (v83.InfernalStrike:ChargesFractional() > (1685.7 - (1466 + 218)))) or ((1094 + 1285) > (5726 - (556 + 592)))) then
					if (v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(3 + 5)) or ((1291 - (329 + 479)) > (1597 - (174 + 680)))) then
						return "infernal_strike precombat 6";
					end
				end
				if (((8432 - 5978) > (1197 - 619)) and v83.Fracture:IsCastable() and v36 and v91) then
					if (((664 + 266) < (5197 - (396 + 343))) and v19(v83.Fracture)) then
						return "fracture precombat 8";
					end
				end
				v145 = 1 + 1;
			end
			if (((2139 - (29 + 1448)) <= (2361 - (135 + 1254))) and ((0 - 0) == v145)) then
				if (((20404 - 16034) == (2913 + 1457)) and v40 and ((not v32 and v82) or not v82) and not v13:IsMoving() and v83.SigilOfFlame:IsCastable()) then
					if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((6289 - (389 + 1138)) <= (1435 - (102 + 472)))) then
						if (v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(8 + 0)) or ((783 + 629) == (3976 + 288))) then
							return "sigil_of_flame precombat 2";
						end
					elseif ((v78 == "cursor") or ((4713 - (320 + 1225)) < (3832 - 1679))) then
						if (v19(v85.SigilOfFlameCursor, not v14:IsInRange(19 + 11)) or ((6440 - (157 + 1307)) < (3191 - (821 + 1038)))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if (((11546 - 6918) == (507 + 4121)) and v83.ImmolationAura:IsCastable() and v37) then
					if (v19(v83.ImmolationAura, not v14:IsInMeleeRange(13 - 5)) or ((21 + 33) == (979 - 584))) then
						return "immolation_aura precombat 4";
					end
				end
				v145 = 1027 - (834 + 192);
			end
			if (((6 + 76) == (22 + 60)) and (v145 == (1 + 1))) then
				if ((v83.Shear:IsCastable() and v39 and v91) or ((899 - 318) < (586 - (300 + 4)))) then
					if (v19(v83.Shear) or ((1231 + 3378) < (6531 - 4036))) then
						return "shear precombat 10";
					end
				end
				break;
			end
		end
	end
	local function v114()
		if (((1514 - (112 + 250)) == (460 + 692)) and v83.DemonSpikes:IsCastable() and v59 and v13:BuffDown(v83.DemonSpikesBuff) and v13:BuffDown(v83.MetamorphosisBuff) and (((v96 == (2 - 1)) and v13:BuffDown(v83.FieryBrandDebuff)) or (v96 > (1 + 0)))) then
			if (((981 + 915) <= (2560 + 862)) and (v83.DemonSpikes:ChargesFractional() > (1.9 + 0))) then
				if (v19(v83.DemonSpikes) or ((736 + 254) > (3034 - (1001 + 413)))) then
					return "demon_spikes defensives (Capped)";
				end
			elseif (v93 or (v13:HealthPercentage() <= v62) or ((1955 - 1078) > (5577 - (244 + 638)))) then
				if (((3384 - (627 + 66)) >= (5515 - 3664)) and v19(v83.DemonSpikes)) then
					return "demon_spikes defensives (Danger)";
				end
			end
		end
		if ((v83.Metamorphosis:IsCastable() and v61 and (v13:HealthPercentage() <= v64) and (v13:BuffDown(v83.MetamorphosisBuff) or (v14:TimeToDie() < (617 - (512 + 90))))) or ((4891 - (1665 + 241)) >= (5573 - (373 + 344)))) then
			if (((1929 + 2347) >= (317 + 878)) and v19(v85.MetamorphosisPlayer)) then
				return "metamorphosis defensives";
			end
		end
		if (((8525 - 5293) <= (7936 - 3246)) and v83.FieryBrand:IsCastable() and v60 and (v93 or (v13:HealthPercentage() <= v63))) then
			if (v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand)) or ((1995 - (35 + 1064)) >= (2290 + 856))) then
				return "fiery_brand defensives";
			end
		end
		if (((6549 - 3488) >= (12 + 2946)) and v84.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v76)) then
			if (((4423 - (298 + 938)) >= (1903 - (233 + 1026))) and v19(v85.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((2310 - (636 + 1030)) <= (360 + 344)) and v73 and (v13:HealthPercentage() <= v75)) then
			local v183 = 0 + 0;
			while true do
				if (((285 + 673) > (64 + 883)) and (v183 == (221 - (55 + 166)))) then
					if (((871 + 3621) >= (267 + 2387)) and (v77 == "Refreshing Healing Potion")) then
						if (((13145 - 9703) >= (1800 - (36 + 261))) and v84.RefreshingHealingPotion:IsReady()) then
							if (v19(v85.RefreshingHealingPotion) or ((5543 - 2373) <= (2832 - (34 + 1334)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v77 == "Dreamwalker's Healing Potion") or ((1845 + 2952) == (3410 + 978))) then
						if (((1834 - (1035 + 248)) <= (702 - (20 + 1))) and v84.DreamwalkersHealingPotion:IsReady()) then
							if (((1708 + 1569) > (726 - (134 + 185))) and v19(v85.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v115()
		local v146 = 1133 - (549 + 584);
		while true do
			if (((5380 - (314 + 371)) >= (4857 - 3442)) and (v146 == (972 - (478 + 490)))) then
				if ((v42 and v83.SpiritBomb:IsReady() and (v13:FuryDeficit() <= (16 + 14)) and (v96 > (1173 - (786 + 386))) and (v87 >= (12 - 8))) or ((4591 - (1055 + 324)) <= (2284 - (1093 + 247)))) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(8 + 0)) or ((326 + 2770) <= (7138 - 5340))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if (((12003 - 8466) == (10064 - 6527)) and v41 and v83.SoulCleave:IsReady() and not v103 and (v13:FuryDeficit() <= (100 - 60))) then
					if (((1365 + 2472) >= (6048 - 4478)) and v19(v83.SoulCleave, not v91)) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if ((v146 == (10 - 7)) or ((2225 + 725) == (9748 - 5936))) then
				if (((5411 - (364 + 324)) >= (6354 - 4036)) and v36 and v83.Fracture:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (119 - 69))) then
					if (v19(v83.Fracture, not v91) or ((672 + 1355) > (11933 - 9081))) then
						return "fracture maintenance 14";
					end
				end
				if ((v39 and v83.Shear:IsCastable() and (v83.FelDevastation:CooldownRemains() <= (v83.Fracture:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (80 - 30))) or ((3450 - 2314) > (5585 - (1249 + 19)))) then
					if (((4286 + 462) == (18481 - 13733)) and v19(v83.Shear, not v91)) then
						return "shear maintenance 16";
					end
				end
				v146 = 1090 - (686 + 400);
			end
			if (((2932 + 804) <= (4969 - (73 + 156))) and (v146 == (1 + 0))) then
				if ((v37 and v83.ImmolationAura:IsCastable()) or ((4201 - (721 + 90)) <= (35 + 3025))) then
					if (v19(v83.ImmolationAura, not v14:IsInMeleeRange(25 - 17)) or ((1469 - (224 + 246)) > (4362 - 1669))) then
						return "immolation_aura maintenance 6";
					end
				end
				if (((852 - 389) < (110 + 491)) and v33 and v83.BulkExtraction:IsCastable() and (((1 + 4) - v87) <= v96) and (v87 <= (2 + 0))) then
					if (v19(v83.BulkExtraction, not v91) or ((4339 - 2156) < (2286 - 1599))) then
						return "bulk_extraction maintenance 8";
					end
				end
				v146 = 515 - (203 + 310);
			end
			if (((6542 - (1238 + 755)) == (318 + 4231)) and (v146 == (1536 - (709 + 825)))) then
				if (((8608 - 3936) == (6805 - 2133)) and v42 and v83.SpiritBomb:IsReady() and v102) then
					if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(872 - (196 + 668))) or ((14482 - 10814) < (818 - 423))) then
						return "spirit_bomb maintenance 10";
					end
				end
				if ((v35 and v83.Felblade:IsReady() and (((not v83.SpiritBomb:IsAvailable() or (v96 == (834 - (171 + 662)))) and (v13:FuryDeficit() >= (133 - (4 + 89)))) or ((v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (175 - 125))))) or ((1517 + 2649) == (1998 - 1543))) then
					if (v19(v83.Felblade, not v91) or ((1745 + 2704) == (4149 - (35 + 1451)))) then
						return "felblade maintenance 12";
					end
				end
				v146 = 1456 - (28 + 1425);
			end
			if (((1993 - (941 + 1052)) == v146) or ((4102 + 175) < (4503 - (822 + 692)))) then
				if ((v60 and v79 and v83.FieryBrand:IsCastable() and (((v83.FieryBrandDebuff:AuraActiveCount() == (0 - 0)) and ((v83.SigilOfFlame:CooldownRemains() <= (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.SoulCarver:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())) or (v83.FelDevastation:CooldownRemains() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains())))) or (v83.DownInFlames:IsAvailable() and (v83.FieryBrand:FullRechargeTime() < (v83.FieryBrand:ExecuteTime() + v13:GCDRemains()))))) or ((410 + 460) >= (4446 - (45 + 252)))) then
					if (((2189 + 23) < (1096 + 2087)) and v19(v83.FieryBrand, not v14:IsSpellInRange(v83.FieryBrand))) then
						return "fiery_brand maintenance 2";
					end
				end
				if (((11306 - 6660) > (3425 - (114 + 319))) and v40 and v83.SigilOfFlame:IsCastable() and ((not v32 and v82) or not v82) and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) then
					if (((1836 - 402) < (1981 + 1125)) and (v83.ConcentratedSigils:IsAvailable() or (v78 == "player"))) then
						if (((1170 - 384) < (6333 - 3310)) and v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(1971 - (556 + 1407)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v78 == "cursor") or ((3648 - (741 + 465)) < (539 - (170 + 295)))) then
						if (((2390 + 2145) == (4166 + 369)) and v19(v85.SigilOfFlameCursor, not v14:IsInRange(73 - 43))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v146 = 1 + 0;
			end
		end
	end
	local function v116()
		if ((v37 and v83.ImmolationAura:IsCastable()) or ((1930 + 1079) <= (1192 + 913))) then
			if (((3060 - (957 + 273)) < (982 + 2687)) and v19(v83.ImmolationAura, not v14:IsInMeleeRange(4 + 4))) then
				return "immolation_aura fiery_demise 2";
			end
		end
		if ((v83.SigilOfFlame:IsCastable() and (v83.AscendingFlame:IsAvailable() or (v83.SigilOfFlameDebuff:AuraActiveCount() == (0 - 0)))) or ((3768 - 2338) >= (11032 - 7420))) then
			if (((13285 - 10602) >= (4240 - (389 + 1391))) and (v83.ConcentratedSigils:IsAvailable() or (v78 == "player"))) then
				if (v19(v85.SigilOfFlamePlayer, not v14:IsInMeleeRange(6 + 2)) or ((188 + 1616) >= (7455 - 4180))) then
					return "sigil_of_flame fiery_demise 4 (Player)";
				end
			elseif ((v78 == "cursor") or ((2368 - (783 + 168)) > (12179 - 8550))) then
				if (((4717 + 78) > (713 - (309 + 2))) and v19(v85.SigilOfFlameCursor, not v14:IsInRange(92 - 62))) then
					return "sigil_of_flame fiery_demise 4 (Cursor)";
				end
			end
		end
		if (((6025 - (1090 + 122)) > (1156 + 2409)) and v35 and v83.Felblade:IsReady() and (not v83.SpiritBomb:IsAvailable() or (v83.FelDevastation:CooldownRemains() <= (v83.Felblade:ExecuteTime() + v13:GCDRemains()))) and (v13:Fury() < (167 - 117))) then
			if (((2678 + 1234) == (5030 - (628 + 490))) and v19(v83.Felblade, not v91)) then
				return "felblade fiery_demise 6";
			end
		end
		if (((506 + 2315) <= (11943 - 7119)) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105) and v83.FelDevastation:IsReady()) then
			if (((7942 - 6204) <= (2969 - (431 + 343))) and v19(v83.FelDevastation, not v14:IsInMeleeRange(16 - 8))) then
				return "fel_devastation fiery_demise 8";
			end
		end
		if (((118 - 77) <= (2385 + 633)) and v51 and v83.SoulCarver:IsCastable() and (v88 < (1 + 2)) and ((v31 and v55) or not v55) and (v70 < v105)) then
			if (((3840 - (556 + 1139)) <= (4119 - (6 + 9))) and v19(v83.SoulCarver, not v91)) then
				return "soul_carver fiery_demise 10";
			end
		end
		if (((493 + 2196) < (2482 + 2363)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
			if (v19(v83.TheHunt, not v14:IsInRange(199 - (28 + 141))) or ((900 + 1422) > (3236 - 614))) then
				return "the_hunt fiery_demise 12";
			end
		end
		if ((v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1.85 + 0)) and (v13:Fury() >= (1357 - (486 + 831))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((11798 - 7264) == (7329 - 5247))) then
			if ((v57 == "player") or ((297 + 1274) > (5903 - 4036))) then
				if (v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(1271 - (668 + 595))) or ((2389 + 265) >= (605 + 2391))) then
					return "elysian_decree fiery_demise 14 (Player)";
				end
			elseif (((10848 - 6870) > (2394 - (23 + 267))) and (v57 == "cursor")) then
				if (((4939 - (1129 + 815)) > (1928 - (371 + 16))) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(1780 - (1326 + 424)))) then
					return "elysian_decree fiery_demise 14 (Cursor)";
				end
			end
		end
		if (((6153 - 2904) > (3482 - 2529)) and v83.SpiritBomb:IsReady() and v42 and v102) then
			if (v19(v83.SpiritBomb, not v14:IsInMeleeRange(126 - (88 + 30))) or ((4044 - (720 + 51)) > (10172 - 5599))) then
				return "spirit_bomb fiery_demise 16";
			end
		end
	end
	local function v117()
		local v147 = 1776 - (421 + 1355);
		while true do
			if ((v147 == (1 - 0)) or ((1548 + 1603) < (2367 - (286 + 797)))) then
				if ((v83.SigilOfSilence:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v46) or ((6762 - 4912) == (2531 - 1002))) then
					if (((1260 - (397 + 42)) < (664 + 1459)) and ((v78 == "player") or v83.ConcentratedSigils:IsAvailable())) then
						if (((1702 - (24 + 776)) < (3581 - 1256)) and v19(v85.SigilOfSilencePlayer, not v14:IsInMeleeRange(793 - (222 + 563)))) then
							return "sigil_of_silence player filler 6";
						end
					elseif (((1890 - 1032) <= (2133 + 829)) and (v78 == "cursor")) then
						if (v19(v85.SigilOfSilenceCursor, not v14:IsInRange(220 - (23 + 167))) or ((5744 - (690 + 1108)) < (465 + 823))) then
							return "sigil_of_silence cursor filler 6";
						end
					end
				end
				if ((v83.Felblade:IsReady() and v35) or ((2675 + 567) == (1415 - (40 + 808)))) then
					if (v19(v83.Felblade, not v91) or ((140 + 707) >= (4829 - 3566))) then
						return "felblade filler 8";
					end
				end
				v147 = 2 + 0;
			end
			if ((v147 == (2 + 0)) or ((1236 + 1017) == (2422 - (47 + 524)))) then
				if ((v83.Shear:IsCastable() and v39) or ((1355 + 732) > (6483 - 4111))) then
					if (v19(v83.Shear, not v91) or ((6646 - 2201) < (9461 - 5312))) then
						return "shear filler 10";
					end
				end
				if ((v83.ThrowGlaive:IsCastable() and v43) or ((3544 - (1165 + 561)) == (3 + 82))) then
					if (((1951 - 1321) < (812 + 1315)) and v19(v83.ThrowGlaive, not v14:IsInRange(509 - (341 + 138)))) then
						return "throw_glaive filler 12";
					end
				end
				break;
			end
			if ((v147 == (0 + 0)) or ((3999 - 2061) == (2840 - (89 + 237)))) then
				if (((13688 - 9433) >= (115 - 60)) and v83.SigilOfChains:IsCastable() and v47 and (v83.CycleofBinding:IsAvailable())) then
					if (((3880 - (581 + 300)) > (2376 - (855 + 365))) and ((v78 == "player") or v83.ConcentratedSigils:IsAvailable())) then
						if (((5581 - 3231) > (378 + 777)) and v19(v85.SigilOfChainsPlayer, not v14:IsInMeleeRange(1243 - (1030 + 205)))) then
							return "sigil_of_chains player filler 2";
						end
					elseif (((3783 + 246) <= (4515 + 338)) and (v78 == "cursor")) then
						if (v19(v85.SigilOfChainsCursor, not v14:IsInRange(316 - (156 + 130))) or ((1172 - 656) > (5787 - 2353))) then
							return "sigil_of_chains cursor filler 2";
						end
					end
				end
				if (((8286 - 4240) >= (800 + 2233)) and v83.SigilOfMisery:IsCastable() and (v83.CycleofBinding:IsAvailable()) and v48) then
					if ((v78 == "player") or v83.ConcentratedSigils:IsAvailable() or ((1586 + 1133) <= (1516 - (10 + 59)))) then
						if (v19(v85.SigilOfMiseryPlayer, not v14:IsInMeleeRange(3 + 5)) or ((20359 - 16225) < (5089 - (671 + 492)))) then
							return "sigil_of_misery player filler 4";
						end
					elseif ((v78 == "cursor") or ((131 + 33) >= (4000 - (369 + 846)))) then
						if (v19(v85.SigilOfMiseryCursor, not v14:IsInRange(8 + 22)) or ((449 + 76) == (4054 - (1036 + 909)))) then
							return "sigil_of_misery cursor filler 4";
						end
					end
				end
				v147 = 1 + 0;
			end
		end
	end
	local function v118()
		local v148 = 0 - 0;
		while true do
			if (((236 - (11 + 192)) == (17 + 16)) and (v148 == (179 - (135 + 40)))) then
				if (((7399 - 4345) <= (2421 + 1594)) and v28) then
					return v28;
				end
				break;
			end
			if (((4121 - 2250) < (5069 - 1687)) and (v148 == (177 - (50 + 126)))) then
				if (((3600 - 2307) <= (480 + 1686)) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(1433 - (1233 + 180))) or ((3548 - (522 + 447)) < (1544 - (107 + 1314)))) then
						return "fel_devastation single_target 6";
					end
				end
				if ((v83.ElysianDecree:IsCastable() and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((393 + 453) >= (7215 - 4847))) then
					if ((v57 == "player") or ((1705 + 2307) <= (6668 - 3310))) then
						if (((5911 - 4417) <= (4915 - (716 + 1194))) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(1 + 29))) then
							return "elysian_decree single_target 8 (Player)";
						end
					elseif ((v57 == "cursor") or ((334 + 2777) == (2637 - (74 + 429)))) then
						if (((4543 - 2188) == (1168 + 1187)) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(68 - 38))) then
							return "elysian_decree single_target 8 (Cursor)";
						end
					end
				end
				v148 = 2 + 0;
			end
			if ((v148 == (8 - 5)) or ((1453 - 865) <= (865 - (279 + 154)))) then
				if (((5575 - (454 + 324)) >= (3065 + 830)) and v83.Fracture:IsCastable() and v36) then
					if (((3594 - (12 + 5)) == (1929 + 1648)) and v19(v83.Fracture, not v91)) then
						return "fracture single_target 14";
					end
				end
				v28 = v117();
				v148 = 10 - 6;
			end
			if (((1402 + 2392) > (4786 - (277 + 816))) and (v148 == (8 - 6))) then
				if ((v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) or ((2458 - (1058 + 125)) == (769 + 3331))) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(995 - (815 + 160))) or ((6826 - 5235) >= (8498 - 4918))) then
						return "fel_devastation single_target 10";
					end
				end
				if (((235 + 748) <= (5285 - 3477)) and v83.SoulCleave:IsReady() and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((4048 - (41 + 1857)) <= (3090 - (1222 + 671)))) then
						return "soul_cleave single_target 12";
					end
				end
				v148 = 7 - 4;
			end
			if (((5417 - 1648) >= (2355 - (229 + 953))) and (v148 == (1774 - (1111 + 663)))) then
				if (((3064 - (874 + 705)) == (208 + 1277)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
					if (v19(v83.TheHunt, not v14:IsInRange(35 + 15)) or ((6890 - 3575) <= (79 + 2703))) then
						return "the_hunt single_target 2";
					end
				end
				if ((v83.SoulCarver:IsCastable() and v51 and ((v31 and v55) or not v55) and (v70 < v105)) or ((1555 - (642 + 37)) >= (676 + 2288))) then
					if (v19(v83.SoulCarver, not v91) or ((358 + 1874) > (6269 - 3772))) then
						return "soul_carver single_target 4";
					end
				end
				v148 = 455 - (233 + 221);
			end
		end
	end
	local function v119()
		local v149 = 0 - 0;
		while true do
			if ((v149 == (1 + 0)) or ((3651 - (718 + 823)) <= (209 + 123))) then
				if (((4491 - (266 + 539)) > (8980 - 5808)) and v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1226.85 - (636 + 589))) and (v13:Fury() >= (94 - 54)) and ((v88 <= (1 - 0)) or (v88 >= (4 + 0))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) then
					if ((v57 == "player") or ((1626 + 2848) < (1835 - (657 + 358)))) then
						if (((11329 - 7050) >= (6565 - 3683)) and v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(1217 - (1151 + 36)))) then
							return "elysian_decree small_aoe 6 (Player)";
						end
					elseif ((v57 == "cursor") or ((1960 + 69) >= (926 + 2595))) then
						if (v19(v85.ElysianDecreeCursor, not v14:IsInRange(89 - 59)) or ((3869 - (1552 + 280)) >= (5476 - (64 + 770)))) then
							return "elysian_decree small_aoe 6 (Cursor)";
						end
					end
				end
				if (((1168 + 552) < (10119 - 5661)) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
					if (v19(v83.FelDevastation, not v14:IsInMeleeRange(4 + 16)) or ((1679 - (157 + 1086)) > (6046 - 3025))) then
						return "fel_devastation small_aoe 8";
					end
				end
				v149 = 8 - 6;
			end
			if (((1092 - 379) <= (1155 - 308)) and (v149 == (819 - (599 + 220)))) then
				if (((4289 - 2135) <= (5962 - (1813 + 118))) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
					if (((3374 + 1241) == (5832 - (841 + 376))) and v19(v83.TheHunt, not v14:IsInRange(70 - 20))) then
						return "the_hunt small_aoe 2";
					end
				end
				if ((v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or (v83.StoketheFlames:IsAvailable() and v83.BurningBlood:IsAvailable())) and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) or ((881 + 2909) == (1364 - 864))) then
					if (((948 - (464 + 395)) < (567 - 346)) and v19(v83.FelDevastation, not v14:IsInMeleeRange(10 + 10))) then
						return "fel_devastation small_aoe 4";
					end
				end
				v149 = 838 - (467 + 370);
			end
			if (((4244 - 2190) >= (1044 + 377)) and (v149 == (13 - 9))) then
				if (((108 + 584) < (7114 - 4056)) and v28) then
					return v28;
				end
				break;
			end
			if ((v149 == (523 - (150 + 370))) or ((4536 - (74 + 1208)) == (4070 - 2415))) then
				if ((v83.Fracture:IsCastable() and v36) or ((6146 - 4850) == (3494 + 1416))) then
					if (((3758 - (14 + 376)) == (5841 - 2473)) and v19(v83.Fracture, not v91)) then
						return "fracture small_aoe 14";
					end
				end
				v28 = v117();
				v149 = 3 + 1;
			end
			if (((2322 + 321) < (3639 + 176)) and (v149 == (5 - 3))) then
				if (((1440 + 473) > (571 - (23 + 55))) and v83.SoulCarver:IsCastable() and (v88 < (6 - 3)) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
					if (((3174 + 1581) > (3079 + 349)) and v19(v83.SoulCarver, not v91)) then
						return "soul_carver small_aoe 10";
					end
				end
				if (((2141 - 760) <= (746 + 1623)) and v83.SoulCleave:IsReady() and ((v87 <= (902 - (652 + 249))) or not v83.SpiritBomb:IsAvailable()) and not v97 and v41) then
					if (v19(v83.SoulCleave, not v91) or ((12960 - 8117) == (5952 - (708 + 1160)))) then
						return "soul_cleave small_aoe 12";
					end
				end
				v149 = 8 - 5;
			end
		end
	end
	local function v120()
		if (((8512 - 3843) > (390 - (10 + 17))) and v83.FelDevastation:IsReady() and (v83.CollectiveAnguish:IsAvailable() or v83.StoketheFlames:IsAvailable()) and v50 and ((v31 and v54) or not v54) and (v70 < v105) and ((not v32 and v81) or not v81)) then
			if (v19(v83.FelDevastation, not v14:IsInMeleeRange(5 + 15)) or ((3609 - (1400 + 332)) >= (6018 - 2880))) then
				return "fel_devastation big_aoe 2";
			end
		end
		if (((6650 - (242 + 1666)) >= (1552 + 2074)) and v83.TheHunt:IsCastable() and v52 and ((not v32 and v81) or not v81) and ((v31 and v56) or not v56) and (v70 < v105)) then
			if (v19(v83.TheHunt, not v14:IsInRange(19 + 31)) or ((3870 + 670) == (1856 - (850 + 90)))) then
				return "the_hunt big_aoe 4";
			end
		end
		if ((v83.ElysianDecree:IsCastable() and (v83.ElysianDecree:TimeSinceLastCast() >= (1.85 - 0)) and (v13:Fury() >= (1430 - (360 + 1030))) and ((v88 <= (1 + 0)) or (v88 >= (11 - 7))) and v49 and ((not v32 and v82) or not v82) and not v13:IsMoving() and ((v31 and v53) or not v53) and (v70 < v105) and (v96 > v58)) or ((1589 - 433) > (6006 - (909 + 752)))) then
			if (((3460 - (109 + 1114)) < (7778 - 3529)) and (v57 == "player")) then
				if (v19(v85.ElysianDecreePlayer, not v14:IsInMeleeRange(12 + 18)) or ((2925 - (6 + 236)) < (15 + 8))) then
					return "elysian_decree big_aoe 6 (Player)";
				end
			elseif (((562 + 135) <= (1947 - 1121)) and (v57 == "cursor")) then
				if (((1930 - 825) <= (2309 - (1076 + 57))) and v19(v85.ElysianDecreeCursor, not v14:IsInRange(5 + 25))) then
					return "elysian_decree big_aoe 6 (Cursor)";
				end
			end
		end
		if (((4068 - (579 + 110)) <= (301 + 3511)) and v83.FelDevastation:IsReady() and v50 and ((not v32 and v81) or not v81) and ((v31 and v54) or not v54) and (v70 < v105)) then
			if (v19(v83.FelDevastation, not v14:IsInMeleeRange(18 + 2)) or ((419 + 369) >= (2023 - (174 + 233)))) then
				return "fel_devastation big_aoe 8";
			end
		end
		if (((5178 - 3324) <= (5930 - 2551)) and v83.SoulCarver:IsCastable() and (v88 < (2 + 1)) and v51 and ((v31 and v55) or not v55) and (v70 < v105)) then
			if (((5723 - (663 + 511)) == (4059 + 490)) and v19(v83.SoulCarver, not v91)) then
				return "soul_carver big_aoe 10";
			end
		end
		if ((v83.SpiritBomb:IsReady() and (v87 >= (1 + 3)) and v42) or ((9316 - 6294) >= (1832 + 1192))) then
			if (((11347 - 6527) > (5320 - 3122)) and v19(v83.SpiritBomb, not v14:IsInMeleeRange(4 + 4))) then
				return "spirit_bomb big_aoe 12";
			end
		end
		if ((v83.SoulCleave:IsReady() and (not v83.SpiritBomb:IsAvailable() or not v97) and v41) or ((2064 - 1003) >= (3486 + 1405))) then
			if (((125 + 1239) <= (5195 - (478 + 244))) and v19(v83.SoulCleave, not v91)) then
				return "soul_cleave big_aoe 14";
			end
		end
		if ((v83.Fracture:IsCastable() and v36) or ((4112 - (440 + 77)) <= (2 + 1))) then
			if (v19(v83.Fracture, not v91) or ((17099 - 12427) == (5408 - (655 + 901)))) then
				return "fracture big_aoe 16";
			end
		end
		if (((290 + 1269) == (1194 + 365)) and v83.SoulCleave:IsReady() and not v97 and v41) then
			if (v19(v83.SoulCleave, not v91) or ((1184 + 568) <= (3174 - 2386))) then
				return "soul_cleave big_aoe 18";
			end
		end
		v28 = v117();
		if (v28 or ((5352 - (695 + 750)) == (604 - 427))) then
			return v28;
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
		v64 = EpicSettings.Settings['metamorphosisHP'] or (351 - (285 + 66));
		v78 = EpicSettings.Settings['sigilSetting'] or "player";
		v57 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v58 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
		v79 = EpicSettings.Settings['fieryBrandOffensively'];
		v80 = EpicSettings.Settings['metamorphosisOffensively'];
	end
	local function v122()
		local v179 = 1310 - (682 + 628);
		while true do
			if (((560 + 2910) > (854 - (176 + 123))) and (v179 == (0 + 0))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v179 = 270 - (239 + 30);
			end
			if ((v179 == (1 + 1)) or ((935 + 37) == (1141 - 496))) then
				v73 = EpicSettings.Settings['useHealingPotion'];
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (315 - (306 + 9));
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v179 = 10 - 7;
			end
			if (((554 + 2628) >= (1298 + 817)) and (v179 == (1 + 0))) then
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v179 = 5 - 3;
			end
			if (((5268 - (1140 + 235)) < (2819 + 1610)) and (v179 == (3 + 0))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				v82 = EpicSettings.Settings['RMBAOE'];
				v81 = EpicSettings.Settings['RMBMovement'];
				break;
			end
		end
	end
	local function v123()
		local v180 = 0 + 0;
		while true do
			if ((v180 == (53 - (33 + 19))) or ((1036 + 1831) < (5709 - 3804))) then
				v31 = EpicSettings.Toggles['cds'];
				if (v13:IsDeadOrGhost() or ((792 + 1004) >= (7944 - 3893))) then
					return v28;
				end
				if (((1519 + 100) <= (4445 - (586 + 103))) and IsMouseButtonDown("RightButton")) then
					v32 = true;
				else
					v32 = false;
				end
				v95 = v13:GetEnemiesInMeleeRange(1 + 7);
				v180 = 5 - 3;
			end
			if (((2092 - (1309 + 179)) == (1089 - 485)) and (v180 == (0 + 0))) then
				v121();
				v122();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v180 = 2 - 1;
			end
			if ((v180 == (3 + 0)) or ((9526 - 5042) == (1793 - 893))) then
				if (v21.TargetIsValid() or v13:AffectingCombat() or ((5068 - (295 + 314)) <= (2733 - 1620))) then
					local v206 = 1962 - (1300 + 662);
					while true do
						if (((11404 - 7772) > (5153 - (1178 + 577))) and (v206 == (1 + 0))) then
							if (((12067 - 7985) <= (6322 - (851 + 554))) and (v105 == (9826 + 1285))) then
								v105 = v9.FightRemains(v95, false);
							end
							break;
						end
						if (((13400 - 8568) >= (3009 - 1623)) and (v206 == (302 - (115 + 187)))) then
							v104 = v9.BossFightRemains(nil, true);
							v105 = v104;
							v206 = 1 + 0;
						end
					end
				end
				v87 = v107.AuraSouls;
				v89 = v107.IncomingSouls;
				v88 = v87 + v89;
				v180 = 4 + 0;
			end
			if (((539 - 402) == (1298 - (160 + 1001))) and (v180 == (2 + 0))) then
				if (v30 or ((1084 + 486) >= (8867 - 4535))) then
					v96 = #v95;
				else
					v96 = 359 - (237 + 121);
				end
				v111();
				v93 = v13:ActiveMitigationNeeded();
				v94 = v13:IsTankingAoE(905 - (525 + 372)) or v13:IsTanking(v14);
				v180 = 4 - 1;
			end
			if ((v180 == (12 - 8)) or ((4206 - (96 + 46)) <= (2596 - (643 + 134)))) then
				if (v66 or ((1800 + 3186) < (3774 - 2200))) then
					v28 = v21.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 74 - 54);
					if (((4245 + 181) > (337 - 165)) and v28) then
						return v28;
					end
				end
				if (((1197 - 611) > (1174 - (316 + 403))) and v21.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					local v207 = 0 + 0;
					local v208;
					while true do
						if (((2270 - 1444) == (299 + 527)) and (v207 == (7 - 4))) then
							if ((v83.InfernalStrike:IsCastable() and v38 and (v83.InfernalStrike:ChargesFractional() > (1.7 + 0)) and (v83.InfernalStrike:TimeSinceLastCast() > (1 + 1))) or ((13925 - 9906) > (21209 - 16768))) then
								if (((4189 - 2172) < (244 + 4017)) and v19(v85.InfernalStrikePlayer, not v14:IsInMeleeRange(15 - 7))) then
									return "infernal_strike main 2";
								end
							end
							if (((231 + 4485) > (235 - 155)) and (v70 < v105) and v83.Metamorphosis:IsCastable() and v61 and v80 and v13:BuffDown(v83.MetamorphosisBuff) and (v83.FelDevastation:CooldownRemains() > (29 - (12 + 5)))) then
								if (v19(v85.MetamorphosisPlayer, not v91) or ((13621 - 10114) == (6980 - 3708))) then
									return "metamorphosis main 4";
								end
							end
							v208 = v21.HandleDPSPotion();
							if (v208 or ((1861 - 985) >= (7625 - 4550))) then
								return v208;
							end
							v207 = 1 + 3;
						end
						if (((6325 - (1656 + 317)) > (2276 + 278)) and (v207 == (1 + 0))) then
							v97 = ((v83.FelDevastation:CooldownRemains() <= (v83.SoulCleave:ExecuteTime() + v13:GCDRemains())) and (v13:Fury() < (212 - 132))) or (((v89 > (4 - 3)) or (v88 >= (359 - (5 + 349)))) and not v99);
							if (v98 or ((20927 - 16521) < (5314 - (266 + 1005)))) then
								v102 = (v99 and (v87 >= (4 + 1))) or (v100 and (v87 >= (13 - 9))) or (v101 and (v87 >= (3 - 0)));
							else
								v102 = (v100 and (v87 >= (1701 - (561 + 1135)))) or (v101 and (v87 >= (5 - 1)));
							end
							if (v98 or ((6209 - 4320) >= (4449 - (507 + 559)))) then
								v103 = (v99 and (v88 >= (12 - 7))) or (v100 and (v88 >= (12 - 8))) or (v101 and (v88 >= (391 - (212 + 176))));
							else
								v103 = (v100 and (v88 >= (910 - (250 + 655)))) or (v101 and (v88 >= (10 - 6)));
							end
							if (((3305 - 1413) <= (4276 - 1542)) and v83.ThrowGlaive:IsCastable() and v43 and v11.ValueIsInArray(v106, v14:NPCID())) then
								if (((3879 - (1869 + 87)) < (7692 - 5474)) and v19(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
									return "fodder to the flames on those filthy demons";
								end
							end
							v207 = 1903 - (484 + 1417);
						end
						if (((4657 - 2484) > (634 - 255)) and (v207 == (775 - (48 + 725)))) then
							if ((v83.ThrowGlaive:IsReady() and v43 and v11.ValueIsInArray(v106, v15:NPCID())) or ((4232 - 1641) == (9145 - 5736))) then
								if (((2624 + 1890) > (8882 - 5558)) and v19(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive))) then
									return "fodder to the flames react per mouseover";
								end
							end
							if ((not v13:AffectingCombat() and v29) or ((59 + 149) >= (1408 + 3420))) then
								local v212 = 853 - (152 + 701);
								while true do
									if ((v212 == (1311 - (430 + 881))) or ((607 + 976) > (4462 - (557 + 338)))) then
										v28 = v113();
										if (v28 or ((389 + 924) == (2237 - 1443))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((11114 - 7940) > (7709 - 4807)) and v83.ConsumeMagic:IsAvailable() and v34 and v83.ConsumeMagic:IsReady() and v65 and not v13:IsCasting() and not v13:IsChanneling() and v21.UnitHasMagicBuff(v14)) then
								if (((8879 - 4759) <= (5061 - (499 + 302))) and v19(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic))) then
									return "greater_purge damage";
								end
							end
							if (v94 or ((1749 - (39 + 827)) > (13189 - 8411))) then
								local v213 = 0 - 0;
								while true do
									if (((0 - 0) == v213) or ((5557 - 1937) >= (419 + 4472))) then
										v28 = v114();
										if (((12462 - 8204) > (150 + 787)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v207 = 4 - 1;
						end
						if ((v207 == (109 - (103 + 1))) or ((5423 - (475 + 79)) < (1958 - 1052))) then
							if (v99 or ((3920 - 2695) > (547 + 3681))) then
								local v214 = 0 + 0;
								while true do
									if (((4831 - (1395 + 108)) > (6512 - 4274)) and (v214 == (1204 - (7 + 1197)))) then
										v28 = v118();
										if (((1674 + 2165) > (491 + 914)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (v100 or ((1612 - (27 + 292)) <= (1485 - 978))) then
								local v215 = 0 - 0;
								while true do
									if (((0 - 0) == v215) or ((5710 - 2814) < (1533 - 728))) then
										v28 = v119();
										if (((2455 - (43 + 96)) == (9447 - 7131)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (v101 or ((5810 - 3240) == (1273 + 260))) then
								v28 = v120();
								if (v28 or ((250 + 633) == (2885 - 1425))) then
									return v28;
								end
							end
							break;
						end
						if ((v207 == (0 + 0)) or ((8656 - 4037) <= (315 + 684))) then
							v98 = v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (0 + 0));
							v99 = v96 == (1752 - (1414 + 337));
							v100 = (v96 >= (1942 - (1642 + 298))) and (v96 <= (12 - 7));
							v101 = v96 >= (16 - 10);
							v207 = 2 - 1;
						end
						if ((v207 == (2 + 2)) or ((2654 + 756) > (5088 - (357 + 615)))) then
							if ((v70 < v105) or ((634 + 269) >= (7505 - 4446))) then
								if ((v71 and ((v31 and v72) or not v72)) or ((3407 + 569) < (6122 - 3265))) then
									v28 = v112();
									if (((3944 + 986) > (157 + 2150)) and v28) then
										return v28;
									end
								end
							end
							if ((v83.FieryBrand:IsAvailable() and v83.FieryDemise:IsAvailable() and (v83.FieryBrandDebuff:AuraActiveCount() > (0 + 0))) or ((5347 - (384 + 917)) < (1988 - (128 + 569)))) then
								v28 = v116();
								if (v28 or ((5784 - (1407 + 136)) == (5432 - (687 + 1200)))) then
									return v28;
								end
							end
							v28 = v115();
							if (v28 or ((5758 - (556 + 1154)) > (14888 - 10656))) then
								return v28;
							end
							v207 = 100 - (9 + 86);
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		v18.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
		v83.FieryBrandDebuff:RegisterAuraTracking();
		v83.SigilOfFlameDebuff:RegisterAuraTracking();
	end
	v18.SetAPL(1002 - (275 + 146), v123, v124);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

