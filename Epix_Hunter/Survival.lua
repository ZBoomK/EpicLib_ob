local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1041 - 365) >= (3824 - 2182))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Hunter_Survival.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicLib;
	local v9 = EpicCache;
	local v10 = v8.Unit;
	local v11 = v10.Player;
	local v12 = v10.Target;
	local v13 = v10.Focus;
	local v14 = v10.MouseOver;
	local v15 = v10.Pet;
	local v16 = v8.Spell;
	local v17 = v8.MultiSpell;
	local v18 = v8.Item;
	local v19 = v8.Bind;
	local v20 = v8.Macro;
	local v21 = v8.AoEON;
	local v22 = v8.CDsON;
	local v23 = v8.Cast;
	local v24 = v8.Press;
	local v25 = v8.Commons.Everyone.num;
	local v26 = v8.Commons.Everyone.bool;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
	local v31;
	local v32;
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
	local function v52()
		v30 = EpicSettings.Settings['UseRacials'];
		v32 = EpicSettings.Settings['UseHealingPotion'];
		v33 = EpicSettings.Settings['HealingPotionName'] or (1772 - (1733 + 39));
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (1034 - (125 + 909));
		v37 = EpicSettings.Settings['InterruptWithStun'] or (1948 - (1096 + 852));
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v40 = EpicSettings.Settings['UsePet'];
		v41 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
		v42 = EpicSettings.Settings['UseSteelTrap'];
		v43 = EpicSettings.Settings['UseRevive'];
		v44 = EpicSettings.Settings['UseMendPet'];
		v45 = EpicSettings.Settings['MendPetHP'] or (512 - (409 + 103));
		v46 = EpicSettings.Settings['UseExhilaration'];
		v47 = EpicSettings.Settings['ExhilarationHP'] or (236 - (46 + 190));
		v48 = EpicSettings.Settings['UseTranq'];
		v49 = EpicSettings.Settings['UseHarpoon'];
		v50 = EpicSettings.Settings['UseHarpoonMO'];
		v51 = EpicSettings.Settings['UseAspectoftheEagle'];
	end
	local v53 = v8.Commons.Everyone;
	local v54 = v16.Hunter.Survival;
	local v55 = v18.Hunter.Survival;
	local v56 = {v55.AlgetharPuzzleBox:ID(),v55.ManicGrieftorch:ID()};
	local v57 = v20.Hunter.Survival;
	local v58 = v11:GetEquipment();
	local v59 = (v58[1330 - (1114 + 203)] and v18(v58[739 - (228 + 498)])) or v18(0 + 0);
	local v60 = (v58[8 + 6] and v18(v58[677 - (174 + 489)])) or v18(0 - 0);
	v8:RegisterForEvent(function()
		local v100 = 1905 - (830 + 1075);
		while true do
			if (((4660 - (303 + 221)) > (3666 - (231 + 1038))) and (v100 == (0 + 0))) then
				v58 = v11:GetEquipment();
				v59 = (v58[1175 - (171 + 991)] and v18(v58[53 - 40])) or v18(0 - 0);
				v100 = 2 - 1;
			end
			if ((v100 == (1 + 0)) or ((15192 - 10858) == (12246 - 8001))) then
				v60 = (v58[22 - 8] and v18(v58[43 - 29])) or v18(1248 - (111 + 1137));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v61 = {v54.SummonPet,v54.SummonPet2,v54.SummonPet3,v54.SummonPet4,v54.SummonPet5};
	local v62, v63;
	local v64 = 30764 - 19653;
	local v65 = 5792 + 5319;
	local v66 = (v54.MongooseBite:IsAvailable() and v54.MongooseBite:Cost()) or v54.RaptorStrike:Cost();
	local v67 = (v54.Lunge:IsAvailable() and (779 - (326 + 445))) or (21 - 16);
	v8:RegisterForEvent(function()
		local v101 = 0 - 0;
		while true do
			if ((v101 == (0 - 0)) or ((4987 - (530 + 181)) <= (3912 - (614 + 267)))) then
				v66 = (v54.MongooseBite:IsAvailable() and v54.MongooseBite:Cost()) or v54.RaptorStrike:Cost();
				v67 = (v54.Lunge:IsAvailable() and (40 - (19 + 13))) or (7 - 2);
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v8:RegisterForEvent(function()
		local v102 = 0 - 0;
		while true do
			if ((v102 == (0 - 0)) or ((1242 + 3540) <= (2108 - 909))) then
				v64 = 23042 - 11931;
				v65 = 12923 - (1293 + 519);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v68 = {v54.WildfireBomb,v54.ShrapnelBomb,v54.PheromoneBomb,v54.VolatileBomb};
	local v69 = {v54.WildfireBombDebuff,v54.ShrapnelBombDebuff,v54.PheromoneBombDebuff,v54.VolatileBombDebuff};
	local function v70(v103, v104)
		local v105 = 0 + 0;
		local v106;
		while true do
			if ((v105 == (0 + 0)) or ((3040 + 1824) < (2998 - (709 + 387)))) then
				v106 = v104 or (1858 - (673 + 1185));
				return (v11:Focus() + v11:FocusCastRegen(v103) + v106) < v11:FocusMax();
			end
		end
	end
	local function v71(v107)
		return (v107:DebuffRemains(v54.SerpentStingDebuff));
	end
	local function v72(v108)
		return (v108:DebuffRemains(v54.BloodseekerDebuff));
	end
	local function v73(v109)
		return (v109:DebuffStack(v54.LatentPoisonDebuff));
	end
	local function v74(v110)
		return (v110:DebuffDown(v54.ShreddedArmorDebuff));
	end
	local function v75(v111)
		return (v54.KillCommand:FullRechargeTime() < v11:GCD()) and v70(v54.KillCommand:ExecuteTime(), 60 - 39) and (v54.FlankingStrike:CooldownDown() or not v54.FlankingStrike:IsAvailable());
	end
	local function v76(v112)
		return (v112:DebuffDown(v54.ShreddedArmorDebuff));
	end
	local function v77(v113)
		return v113:DebuffStack(v54.LatentPoisonDebuff) > (25 - 17);
	end
	local function v78(v114)
		return v114:DebuffRefreshable(v54.SerpentStingDebuff) and (v114:TimeToDie() > (19 - 7)) and (not v54.VipersVenom:IsAvailable() or v54.HydrasBite:IsAvailable());
	end
	local function v79(v115)
		return v115:DebuffDown(v54.SerpentStingDebuff) and (v115:TimeToDie() > (6 + 1));
	end
	local function v80(v116)
		return (v116:DebuffRefreshable(v54.SerpentStingDebuff));
	end
	local function v81()
		local v117 = 0 + 0;
		while true do
			if (((6532 - 1693) >= (909 + 2791)) and (v117 == (3 - 1))) then
				if (v12:IsInMeleeRange(v67) or (v11:BuffUp(v54.AspectoftheEagle) and v12:IsInRange(78 - 38)) or ((2955 - (446 + 1434)) > (3201 - (1040 + 243)))) then
					if (((1181 - 785) <= (5651 - (559 + 1288))) and v54.MongooseBite:IsReady()) then
						if (v24(v54.MongooseBite) or ((6100 - (609 + 1322)) == (2641 - (13 + 441)))) then
							return "mongoose_bite precombat 6";
						end
					elseif (((5253 - 3847) == (3682 - 2276)) and v54.RaptorStrike:IsReady()) then
						if (((7625 - 6094) < (160 + 4111)) and v24(v54.RaptorStrike)) then
							return "raptor_strike precombat 8";
						end
					end
				end
				break;
			end
			if (((2306 - 1671) == (226 + 409)) and ((1 + 0) == v117)) then
				if (((10009 - 6636) <= (1946 + 1610)) and v54.SteelTrap:IsCastable() and v12:DebuffDown(v54.SteelTrapDebuff)) then
					if (v24(v54.SteelTrap, not v12:IsInRange(73 - 33)) or ((2176 + 1115) < (1825 + 1455))) then
						return "steel_trap precombat 2";
					end
				end
				if (((3152 + 1234) >= (734 + 139)) and v54.Harpoon:IsCastable() and v49 and (v11:BuffDown(v54.AspectoftheEagle) or not v12:IsInRange(30 + 0))) then
					if (((1354 - (153 + 280)) <= (3181 - 2079)) and v24(v54.Harpoon, not v12:IsSpellInRange(v54.Harpoon))) then
						return "harpoon precombat 4";
					end
				end
				v117 = 2 + 0;
			end
			if (((1859 + 2847) >= (504 + 459)) and (v117 == (0 + 0))) then
				if ((v13:Exists() and v54.Misdirection:IsReady()) or ((696 + 264) <= (1333 - 457))) then
					if (v24(v57.MisdirectionFocus) or ((1277 + 789) == (1599 - (89 + 578)))) then
						return "misdirection precombat 0";
					end
				end
				if (((3447 + 1378) < (10067 - 5224)) and v55.AlgetharPuzzleBox:IsEquippedAndReady()) then
					if (v24(v57.AlgetharPuzzleBox, nil, true) or ((4926 - (572 + 477)) >= (612 + 3925))) then
						return "algethar_puzzle_box precombat 1";
					end
				end
				v117 = 1 + 0;
			end
		end
	end
	local function v82()
		local v118 = 0 + 0;
		local v119;
		local v120;
		while true do
			if ((v118 == (86 - (84 + 2))) or ((7111 - 2796) < (1244 + 482))) then
				if ((v55.AlgetharPuzzleBox:IsEquippedAndReady() and (v11:GCDRemains() > (v11:GCD() - (842.6 - (497 + 345))))) or ((95 + 3584) < (106 + 519))) then
					if (v24(v57.AlgetharPuzzleBox, nil, true) or ((5958 - (605 + 728)) < (451 + 181))) then
						return "algethar_puzzle_box cds 17";
					end
				end
				if ((v55.ManicGrieftorch:IsEquippedAndReady() and (v11:GCDRemains() > (v11:GCD() - (0.6 - 0))) and v11:BuffDown(v54.SpearheadBuff)) or ((4 + 79) > (6581 - 4801))) then
					if (((493 + 53) <= (2983 - 1906)) and v24(v57.ManicGrieftorch, nil, true)) then
						return "manic_grieftorch cds 18";
					end
				end
				v118 = 1 + 0;
			end
			if ((v118 == (490 - (457 + 32))) or ((423 + 573) > (5703 - (832 + 570)))) then
				v119 = v11:GetUseableItems(v56, 13 + 0);
				if (((1062 + 3008) > (2430 - 1743)) and v119) then
					if (v24(v57.Trinket1, nil, nil, true) or ((316 + 340) >= (4126 - (588 + 208)))) then
						return "trinket1 trinket 2";
					end
				end
				v118 = 5 - 3;
			end
			if ((v118 == (1802 - (884 + 916))) or ((5216 - 2724) <= (195 + 140))) then
				v120 = v11:GetUseableItems(v56, 667 - (232 + 421));
				if (((6211 - (1569 + 320)) >= (629 + 1933)) and v120) then
					if (v24(v57.Trinket2, nil, nil, true) or ((691 + 2946) >= (12704 - 8934))) then
						return "trinket2 trinket 4";
					end
				end
				break;
			end
		end
	end
	local function v83()
		if ((v54.BloodFury:IsCastable() and (v11:BuffUp(v54.CoordinatedAssaultBuff) or v11:BuffUp(v54.SpearheadBuff) or (not v54.Spearhead:IsAvailable() and not v54.CoordinatedAssault:IsAvailable()))) or ((2984 - (316 + 289)) > (11983 - 7405))) then
			if (v24(v54.BloodFury) or ((23 + 460) > (2196 - (666 + 787)))) then
				return "blood_fury cds 2";
			end
		end
		if (((2879 - (360 + 65)) > (541 + 37)) and v54.Harpoon:IsCastable() and v49 and v54.TermsofEngagement:IsAvailable() and (v11:Focus() < v11:FocusMax())) then
			if (((1184 - (79 + 175)) < (7029 - 2571)) and v24(v54.Harpoon, not v12:IsSpellInRange(v54.Harpoon))) then
				return "harpoon cds 2";
			end
		end
		if (((517 + 145) <= (2979 - 2007)) and (v11:BuffUp(v54.CoordinatedAssaultBuff) or v11:BuffUp(v54.SpearheadBuff) or (not v54.Spearhead:IsAvailable() and not v54.CoordinatedAssault:IsAvailable()))) then
			local v126 = 0 - 0;
			while true do
				if (((5269 - (503 + 396)) == (4551 - (92 + 89))) and (v126 == (0 - 0))) then
					if (v54.AncestralCall:IsCastable() or ((2443 + 2319) <= (510 + 351))) then
						if (v24(v54.AncestralCall) or ((5529 - 4117) == (584 + 3680))) then
							return "ancestral_call cds 6";
						end
					end
					if (v54.Fireblood:IsCastable() or ((7223 - 4055) < (1879 + 274))) then
						if (v24(v54.Fireblood) or ((2377 + 2599) < (4056 - 2724))) then
							return "fireblood cds 8";
						end
					end
					break;
				end
			end
		end
		if (((578 + 4050) == (7057 - 2429)) and v54.LightsJudgment:IsCastable()) then
			if (v24(v54.LightsJudgment, not v12:IsSpellInRange(v54.LightsJudgment)) or ((1298 - (485 + 759)) == (913 - 518))) then
				return "lights_judgment cds 10";
			end
		end
		if (((1271 - (442 + 747)) == (1217 - (832 + 303))) and v54.BagofTricks:IsCastable() and (v54.KillCommand:FullRechargeTime() > v11:GCD())) then
			if (v24(v54.BagofTricks, not v12:IsSpellInRange(v54.BagofTricks)) or ((1527 - (88 + 858)) < (86 + 196))) then
				return "bag_of_tricks cds 12";
			end
		end
		if ((v54.Berserking:IsCastable() and (v11:BuffUp(v54.CoordinatedAssaultBuff) or v11:BuffUp(v54.SpearheadBuff) or (not v54.Spearhead:IsAvailable() and not v54.CoordinatedAssault:IsAvailable()) or (v65 < (11 + 2)))) or ((190 + 4419) < (3284 - (766 + 23)))) then
			if (((5687 - 4535) == (1574 - 422)) and v24(v54.Berserking)) then
				return "berserking cds 14";
			end
		end
		if (((4995 - 3099) <= (11614 - 8192)) and v31) then
			local v127 = v82();
			if (v127 or ((2063 - (1036 + 37)) > (1149 + 471))) then
				return v127;
			end
		end
		if ((v54.AspectoftheEagle:IsCastable() and v51 and not v12:IsInRange(v67)) or ((1707 - 830) > (3694 + 1001))) then
			if (((4171 - (641 + 839)) >= (2764 - (910 + 3))) and v24(v54.AspectoftheEagle)) then
				return "aspect_of_the_eagle cds 19";
			end
		end
	end
	local function v84()
		local v121 = 0 - 0;
		while true do
			if ((v121 == (1684 - (1466 + 218))) or ((1372 + 1613) >= (6004 - (556 + 592)))) then
				if (((1521 + 2755) >= (2003 - (329 + 479))) and v54.KillShot:IsReady() and v11:BuffUp(v54.CoordinatedAssaultEmpowerBuff) and v11:BuffUp(v54.CoordinatedAssaultBuff) and (v54.Bite:IsReady() or v54.Claw:IsReady() or v54.Smack:IsReady()) and v54.BirdsofPrey:IsAvailable()) then
					if (((4086 - (174 + 680)) <= (16115 - 11425)) and v24(v54.KillShot, not v12:IsSpellInRange(v54.KillShot))) then
						return "kill_shot cleave";
					end
				end
				if ((v54.WildfireBomb:FullRechargeTime() < v11:GCD()) or v54.CoordinatedAssault:CooldownUp() or (v11:BuffUp(v54.CoordinatedAssaultBuff) and v11:BuffDown(v54.CoordinatedAssaultEmpowerBuff)) or v54.Bombardier:IsAvailable() or ((1856 - 960) >= (2247 + 899))) then
					for v138, v139 in pairs(v68) do
						if (((3800 - (396 + 343)) >= (262 + 2696)) and v139:IsCastable()) then
							if (((4664 - (29 + 1448)) >= (2033 - (135 + 1254))) and v24(v139, not v12:IsSpellInRange(v139))) then
								return "wildfire_bomb cleave 2";
							end
						end
					end
				end
				if (((2425 - 1781) <= (3287 - 2583)) and v54.DeathChakram:IsCastable()) then
					if (((639 + 319) > (2474 - (389 + 1138))) and v24(v54.DeathChakram, not v12:IsSpellInRange(v54.DeathChakram))) then
						return "death_chakram cleave 4";
					end
				end
				if (((5066 - (102 + 472)) >= (2505 + 149)) and v54.Stampede:IsCastable() and v29) then
					if (((1909 + 1533) >= (1402 + 101)) and v24(v54.Stampede, not v12:IsSpellInRange(v54.Stampede))) then
						return "stampede cleave 6";
					end
				end
				v121 = 1546 - (320 + 1225);
			end
			if ((v121 == (6 - 2)) or ((1940 + 1230) <= (2928 - (157 + 1307)))) then
				if (v54.Carve:IsReady() or ((6656 - (821 + 1038)) == (10947 - 6559))) then
					if (((61 + 490) <= (1209 - 528)) and v24(v54.Carve, not v12:IsInMeleeRange(v67))) then
						return "carve cleave 36";
					end
				end
				if (((1220 + 2057) > (1008 - 601)) and v54.KillShot:IsReady() and (v11:BuffDown(v54.CoordinatedAssaultBuff))) then
					if (((5721 - (834 + 192)) >= (90 + 1325)) and v24(v54.KillShot, not v12:IsSpellInRange(v54.KillShot))) then
						return "kill_shot cleave 38";
					end
				end
				if ((v54.SteelTrap:IsCastable() and (v70(v54.SteelTrap:ExecuteTime()))) or ((825 + 2387) <= (21 + 923))) then
					if (v24(v54.SteelTrap, not v12:IsInRange(61 - 21)) or ((3400 - (300 + 4)) <= (481 + 1317))) then
						return "steel_trap cleave 40";
					end
				end
				if (((9258 - 5721) == (3899 - (112 + 250))) and v54.Spearhead:IsCastable() and v29) then
					if (((1530 + 2307) >= (3933 - 2363)) and v24(v54.Spearhead, not v12:IsSpellInRange(v54.Spearhead))) then
						return "spearhead cleave 41";
					end
				end
				v121 = 3 + 2;
			end
			if ((v121 == (4 + 2)) or ((2207 + 743) == (1891 + 1921))) then
				if (((3509 + 1214) >= (3732 - (1001 + 413))) and v54.RaptorStrike:IsReady()) then
					if (v53.CastTargetIf(v54.RaptorStrike, v63, "min", v71, nil, not v12:IsInMeleeRange(v67)) or ((4520 - 2493) > (3734 - (244 + 638)))) then
						return "raptor_strike cleave 46";
					end
				end
				if (v54.FlankingStrike:IsCastable() or ((1829 - (627 + 66)) > (12862 - 8545))) then
					if (((5350 - (512 + 90)) == (6654 - (1665 + 241))) and v24(v54.FlankingStrike, not v12:IsSpellInRange(v54.FlankingStrike))) then
						return "flanking_strike cleave 48";
					end
				end
				break;
			end
			if (((4453 - (373 + 344)) <= (2138 + 2602)) and ((1 + 1) == v121)) then
				for v131, v132 in pairs(v68) do
					if ((v132:IsCastable() and (v12:DebuffDown(v69[v131]))) or ((8941 - 5551) <= (5178 - 2118))) then
						if (v24(v132, not v12:IsSpellInRange(v132)) or ((2098 - (35 + 1064)) > (1960 + 733))) then
							return "wildfire_bomb cleave 18";
						end
					end
				end
				if (((990 - 527) < (3 + 598)) and v54.FuryoftheEagle:IsCastable()) then
					if (v24(v54.FuryoftheEagle, not v12:IsInMeleeRange(v67)) or ((3419 - (298 + 938)) < (1946 - (233 + 1026)))) then
						return "fury_of_the_eagle cleave 22";
					end
				end
				if (((6215 - (636 + 1030)) == (2326 + 2223)) and v54.Carve:IsReady() and (v12:DebuffUp(v54.ShrapnelBombDebuff))) then
					if (((4564 + 108) == (1388 + 3284)) and v24(v54.Carve, not v12:IsInMeleeRange(v67))) then
						return "carve cleave 24";
					end
				end
				if ((v54.FlankingStrike:IsCastable() and (v70(v54.FlankingStrike:ExecuteTime(), 3 + 27))) or ((3889 - (55 + 166)) < (77 + 318))) then
					if (v24(v54.FlankingStrike, not v12:IsInMeleeRange(v67)) or ((419 + 3747) == (1737 - 1282))) then
						return "flanking_strike cleave 26";
					end
				end
				v121 = 300 - (36 + 261);
			end
			if ((v121 == (1 - 0)) or ((5817 - (34 + 1334)) == (1024 + 1639))) then
				if ((v54.CoordinatedAssault:IsCastable() and v29 and (v54.FuryoftheEagle:CooldownDown() or not v54.FuryoftheEagle:IsAvailable())) or ((3324 + 953) < (4272 - (1035 + 248)))) then
					if (v24(v54.CoordinatedAssault, not v12:IsInMeleeRange(v67)) or ((891 - (20 + 1)) >= (2162 + 1987))) then
						return "coordinated_assault cleave 8";
					end
				end
				if (((2531 - (134 + 185)) < (4316 - (549 + 584))) and v54.ExplosiveShot:IsReady()) then
					if (((5331 - (314 + 371)) > (10271 - 7279)) and v24(v54.ExplosiveShot, not v12:IsSpellInRange(v54.ExplosiveShot))) then
						return "explosive_shot cleave 12";
					end
				end
				if (((2402 - (478 + 490)) < (1646 + 1460)) and v54.Carve:IsReady() and (v54.WildfireBomb:FullRechargeTime() > (v62 / (1174 - (786 + 386))))) then
					if (((2545 - 1759) < (4402 - (1055 + 324))) and v24(v54.Carve, not v12:IsInMeleeRange(v67))) then
						return "carve cleave 14";
					end
				end
				if ((v54.Butchery:IsReady() and ((v54.Butchery:FullRechargeTime() < v11:GCD()) or (v12:DebuffUp(v54.ShrapnelBombDebuff) and ((v12:DebuffStack(v54.InternalBleedingDebuff) < (1342 - (1093 + 247))) or (v12:DebuffRemains(v54.ShrapnelBombDebuff) < v11:GCD()))))) or ((2171 + 271) < (8 + 66))) then
					if (((18004 - 13469) == (15390 - 10855)) and v24(v54.Butchery, not v12:IsInMeleeRange(v67))) then
						return "butchery cleave 16";
					end
				end
				v121 = 5 - 3;
			end
			if ((v121 == (12 - 7)) or ((1071 + 1938) <= (8109 - 6004))) then
				if (((6307 - 4477) < (2767 + 902)) and v54.MongooseBite:IsReady() and (v11:BuffUp(v54.SpearheadBuff))) then
					if (v53.CastTargetIf(v54.MongooseBite, v63, "min", v71, nil, not v12:IsInMeleeRange(v67)) or ((3657 - 2227) >= (4300 - (364 + 324)))) then
						return "mongoose_bite cleave 42";
					end
				end
				if (((7354 - 4671) >= (5903 - 3443)) and v54.SerpentSting:IsReady()) then
					if (v53.CastTargetIf(v54.SerpentSting, v63, "min", v71, v78, not v12:IsSpellInRange(v54.SerpentSting)) or ((598 + 1206) >= (13703 - 10428))) then
						return "serpent_sting cleave 42";
					end
				end
				if ((v54.FlankingStrike:IsCastable() and (v70(v54.FlankingStrike:ExecuteTime()))) or ((2268 - 851) > (11021 - 7392))) then
					if (((6063 - (1249 + 19)) > (363 + 39)) and v24(v54.FlankingStrike, not v12:IsSpellInRange(v54.FlankingStrike))) then
						return "flanking_strike cleave 43.5";
					end
				end
				if (((18734 - 13921) > (4651 - (686 + 400))) and v54.MongooseBite:IsReady()) then
					if (((3070 + 842) == (4141 - (73 + 156))) and v53.CastTargetIf(v54.MongooseBite, v63, "min", v71, nil, not v12:IsInMeleeRange(v67))) then
						return "mongoose_bite cleave 44";
					end
				end
				v121 = 1 + 5;
			end
			if (((3632 - (721 + 90)) <= (55 + 4769)) and (v121 == (9 - 6))) then
				if (((2208 - (224 + 246)) <= (3555 - 1360)) and v54.Butchery:IsReady() and (not v54.ShrapnelBomb:IsCastable() or not v54.WildfireInfusion:IsAvailable())) then
					if (((75 - 34) <= (548 + 2470)) and v24(v54.Butchery, not v12:IsInMeleeRange(v67))) then
						return "butchery cleave 28";
					end
				end
				if (((52 + 2093) <= (3015 + 1089)) and v54.MongooseBite:IsReady()) then
					if (((5345 - 2656) < (16123 - 11278)) and v53.CastTargetIf(v54.MongooseBite, v63, "max", v73, v77, not v12:IsInMeleeRange(v67))) then
						return "mongoose_bite cleave 30";
					end
				end
				if (v54.RaptorStrike:IsReady() or ((2835 - (203 + 310)) > (4615 - (1238 + 755)))) then
					if (v53.CastTargetIf(v54.RaptorStrike, v63, "max", v73, v77, not v12:IsInMeleeRange(v67)) or ((317 + 4217) == (3616 - (709 + 825)))) then
						return "raptor_strike cleave 32";
					end
				end
				if ((v54.KillCommand:IsCastable() and v70(v54.KillCommand:ExecuteTime()) and (v54.KillCommand:FullRechargeTime() < v11:GCD())) or ((2894 - 1323) > (2719 - 852))) then
					if (v53.CastTargetIf(v54.KillCommand, v63, "min", v72, nil, not v12:IsSpellInRange(v54.KillCommand)) or ((3518 - (196 + 668)) >= (11829 - 8833))) then
						return "kill_command cleave 34";
					end
				end
				v121 = 7 - 3;
			end
		end
	end
	local function v85()
		local v122 = 833 - (171 + 662);
		while true do
			if (((4071 - (4 + 89)) > (7374 - 5270)) and (v122 == (2 + 3))) then
				if (((13154 - 10159) > (605 + 936)) and v54.FuryoftheEagle:IsCastable() and (v12:HealthPercentage() < (1551 - (35 + 1451))) and v54.RuthlessMarauder:IsAvailable()) then
					if (((4702 - (28 + 1425)) > (2946 - (941 + 1052))) and v24(v54.FuryoftheEagle, not v12:IsInMeleeRange(v67))) then
						return "fury_of_the_eagle st ";
					end
				end
				if ((v54.MongooseBite:IsReady() and (((v11:Focus() + v11:FocusCastRegen(v54.KillCommand:ExecuteTime()) + 21 + 0) > (v11:FocusMax() - (1524 - (822 + 692)))) or v11:HasTier(42 - 12, 2 + 2))) or ((3570 - (45 + 252)) > (4525 + 48))) then
					if (v53.CastTargetIf(v54.MongooseBite, v63, "max", v73, nil, not v12:IsInMeleeRange(v67)) or ((1085 + 2066) < (3124 - 1840))) then
						return "mongoose_bite st 40";
					end
				end
				if (v54.RaptorStrike:IsReady() or ((2283 - (114 + 319)) == (2194 - 665))) then
					if (((1051 - 230) < (1354 + 769)) and v53.CastTargetIf(v54.RaptorStrike, v63, "max", v73, nil, not v12:IsInMeleeRange(v67))) then
						return "raptor_strike st 46";
					end
				end
				if (((1343 - 441) < (4871 - 2546)) and v54.SteelTrap:IsCastable()) then
					if (((2821 - (556 + 1407)) <= (4168 - (741 + 465))) and v24(v54.SteelTrap, not v12:IsInRange(505 - (170 + 295)))) then
						return "steel_trap st 48";
					end
				end
				for v133, v134 in pairs(v68) do
					if ((v134:IsCastable() and (v12:DebuffDown(v69[v133]))) or ((2080 + 1866) < (1184 + 104))) then
						if (v24(v134, not v12:IsSpellInRange(v134)) or ((7981 - 4739) == (471 + 96))) then
							return "wildfire_bomb st 50";
						end
					end
				end
				v122 = 4 + 2;
			end
			if ((v122 == (2 + 1)) or ((2077 - (957 + 273)) >= (338 + 925))) then
				if ((v54.FlankingStrike:IsCastable() and (v70(v54.FlankingStrike:ExecuteTime(), 13 + 17))) or ((8584 - 6331) == (4877 - 3026))) then
					if (v24(v54.FlankingStrike, not v12:IsInMeleeRange(v67)) or ((6374 - 4287) > (11745 - 9373))) then
						return "flanking_strike st 22";
					end
				end
				if ((v54.Stampede:IsCastable() and v29) or ((6225 - (389 + 1391)) < (2604 + 1545))) then
					if (v24(v54.Stampede, not v12:IsSpellInRange(v54.Stampede)) or ((190 + 1628) == (193 - 108))) then
						return "stampede st 23";
					end
				end
				if (((1581 - (783 + 168)) < (7138 - 5011)) and v54.CoordinatedAssault:IsCastable() and v29 and ((not v54.CoordinatedKill:IsAvailable() and (v12:HealthPercentage() < (20 + 0)) and ((v11:BuffDown(v54.SpearheadBuff) and v54.Spearhead:CooldownDown()) or not v54.Spearhead:IsAvailable())) or (v54.CoordinatedKill:IsAvailable() and ((v11:BuffDown(v54.SpearheadBuff) and v54.Spearhead:CooldownDown()) or not v54.Spearhead:IsAvailable())))) then
					if (v24(v54.CoordinatedAssault, not v12:IsInMeleeRange(v67)) or ((2249 - (309 + 2)) == (7720 - 5206))) then
						return "coordinated_assault st 24";
					end
				end
				if (((5467 - (1090 + 122)) >= (18 + 37)) and v54.KillCommand:IsCastable()) then
					if (((10071 - 7072) > (792 + 364)) and v53.CastTargetIf(v54.KillCommand, v63, "min", v72, v75, not v12:IsSpellInRange(v54.KillCommand))) then
						return "kill_command st 28";
					end
				end
				if (((3468 - (628 + 490)) > (208 + 947)) and v54.SerpentSting:IsReady() and not v54.VipersVenom:IsAvailable()) then
					if (((9975 - 5946) <= (22178 - 17325)) and v53.CastTargetIf(v54.SerpentSting, v63, "min", v71, v80, not v12:IsSpellInRange(v54.SerpentSting))) then
						return "serpent_sting st 32";
					end
				end
				v122 = 778 - (431 + 343);
			end
			if ((v122 == (11 - 5)) or ((1492 - 976) > (2713 + 721))) then
				if (((518 + 3528) >= (4728 - (556 + 1139))) and v54.KillCommand:IsCastable() and (v70(v54.KillCommand:ExecuteTime(), 36 - (6 + 9)))) then
					if (v53.CastTargetIf(v54.KillCommand, v63, "min", v72, nil, not v12:IsSpellInRange(v54.KillCommand)) or ((498 + 2221) <= (742 + 705))) then
						return "kill_command st 52";
					end
				end
				if ((v54.CoordinatedAssault:IsCastable() and not v54.CoordinatedKill:IsAvailable() and (v12:TimeToDie() > (309 - (28 + 141)))) or ((1602 + 2532) < (4845 - 919))) then
					if (v24(v54.CoordinatedAssault, not v12:IsInMeleeRange(v67)) or ((117 + 47) >= (4102 - (486 + 831)))) then
						return "coordinated_assault st 54";
					end
				end
				break;
			end
			if ((v122 == (5 - 3)) or ((1848 - 1323) == (399 + 1710))) then
				if (((104 - 71) == (1296 - (668 + 595))) and v54.KillShot:IsReady() and (v11:BuffDown(v54.CoordinatedAssaultBuff))) then
					if (((2749 + 305) <= (810 + 3205)) and v24(v54.KillShot, not v12:IsSpellInRange(v54.KillShot))) then
						return "kill_shot st 14";
					end
				end
				if (((5102 - 3231) < (3672 - (23 + 267))) and v54.RaptorStrike:IsReady() and (v62 == (1945 - (1129 + 815))) and (v12:TimeToDie() < ((v11:Focus() / (v66 - v11:FocusCastRegen(v54.RaptorStrike:ExecuteTime()))) * v11:GCD()))) then
					if (((1680 - (371 + 16)) <= (3916 - (1326 + 424))) and v24(v54.RaptorStrike, not v12:IsInMeleeRange(v67))) then
						return "raptor_strike st 16";
					end
				end
				if ((v54.SerpentSting:IsReady() and not v54.VipersVenom:IsAvailable()) or ((4884 - 2305) < (449 - 326))) then
					if (v53.CastTargetIf(v54.SerpentSting, v63, "min", v71, v79, not v12:IsSpellInRange(v54.SerpentSting)) or ((964 - (88 + 30)) >= (3139 - (720 + 51)))) then
						return "serpent_sting st 18";
					end
				end
				if ((v54.FuryoftheEagle:IsCastable() and v11:BuffUp(v54.SeethingRageBuff) and (v11:BuffRemains(v54.SeethingRageBuff) < ((6 - 3) * v11:GCD()))) or ((5788 - (421 + 1355)) <= (5539 - 2181))) then
					if (((734 + 760) <= (4088 - (286 + 797))) and v24(v54.FuryoftheEagle, not v12:IsInMeleeRange(v67))) then
						return "fury_of_the_eagle st ";
					end
				end
				if ((v54.MongooseBite:IsReady() and ((v54.AlphaPredator:IsAvailable() and v11:BuffUp(v54.MongooseFuryBuff) and (v11:BuffRemains(v54.MongooseFuryBuff) < ((v11:Focus() / (v66 - v11:FocusCastRegen(v54.MongooseBite:ExecuteTime()))) * v11:GCD()))) or (v11:BuffUp(v54.SeethingRageBuff) and (v62 == (3 - 2))))) or ((5152 - 2041) == (2573 - (397 + 42)))) then
					if (((736 + 1619) == (3155 - (24 + 776))) and v24(v54.MongooseBite, not v12:IsInMeleeRange(v67))) then
						return "mongoose_bite st 20";
					end
				end
				v122 = 4 - 1;
			end
			if ((v122 == (786 - (222 + 563))) or ((1295 - 707) <= (312 + 120))) then
				if (((4987 - (23 + 167)) >= (5693 - (690 + 1108))) and ((v12:DebuffUp(v54.ShreddedArmorDebuff) and ((v54.WildfireBomb:FullRechargeTime() < ((1 + 1) * v11:GCD())) or (v54.Bombardier:IsAvailable() and v54.CoordinatedAssault:CooldownUp()) or (v54.Bombardier:IsAvailable() and v11:BuffUp(v54.CoordinatedAssaultBuff) and (v11:BuffRemains(v54.CoordinatedAssaultBuff) < ((2 + 0) * v11:GCD()))))) or (v65 < (855 - (40 + 808))))) then
					for v140, v141 in pairs(v68) do
						if (((589 + 2988) == (13678 - 10101)) and v141:IsCastable()) then
							if (((3627 + 167) > (1954 + 1739)) and v24(v141, not v12:IsSpellInRange(v141))) then
								return "wildfire_bomb st 7";
							end
						end
					end
				end
				if ((v54.KillCommand:IsCastable() and (v54.KillCommand:FullRechargeTime() < v11:GCD()) and v70(v54.KillCommand:ExecuteTime(), 12 + 9) and ((v11:BuffStack(v54.DeadlyDuoBuff) > (573 - (47 + 524))) or (v11:BuffUp(v54.SpearheadBuff) and v12:DebuffRemains(v54.PheromoneBombDebuff)))) or ((828 + 447) == (11207 - 7107))) then
					if (v53.CastTargetIf(v54.KillCommand, v63, "min", v72, nil, not v12:IsSpellInRange(v54.KillCommand)) or ((2378 - 787) >= (8164 - 4584))) then
						return "kill_command st 8";
					end
				end
				if (((2709 - (1165 + 561)) <= (54 + 1754)) and v54.KillCommand:IsCastable() and (v54.WildfireBomb:FullRechargeTime() < ((9 - 6) * v11:GCD())) and v11:HasTier(12 + 18, 483 - (341 + 138)) and v11:BuffDown(v54.SpearheadBuff)) then
					if (v53.CastTargetIf(v54.KillCommand, v63, "min", v72, v74, not v12:IsSpellInRange(v54.KillCommand)) or ((581 + 1569) <= (2470 - 1273))) then
						return "kill_command st 9";
					end
				end
				if (((4095 - (89 + 237)) >= (3773 - 2600)) and v54.MongooseBite:IsReady() and (v11:BuffUp(v54.SpearheadBuff))) then
					if (((3126 - 1641) == (2366 - (581 + 300))) and v24(v54.MongooseBite, not v12:IsInMeleeRange(v67))) then
						return "mongoose_bite st 10";
					end
				end
				if ((v54.MongooseBite:IsReady() and (((v62 == (1221 - (855 + 365))) and (v12:TimeToDie() < ((v11:Focus() / (v66 - v11:FocusCastRegen(v54.MongooseBite:ExecuteTime()))) * v11:GCD()))) or (v11:BuffUp(v54.MongooseFuryBuff) and (v11:BuffRemains(v54.MongooseFuryBuff) < v11:GCD())))) or ((7873 - 4558) <= (909 + 1873))) then
					if (v24(v54.MongooseBite, not v12:IsInMeleeRange(v67)) or ((2111 - (1030 + 205)) >= (2783 + 181))) then
						return "mongoose_bite st 12";
					end
				end
				v122 = 2 + 0;
			end
			if ((v122 == (290 - (156 + 130))) or ((5071 - 2839) > (4207 - 1710))) then
				if ((v54.WildfireBomb:FullRechargeTime() < ((3 - 1) * v11:GCD())) or ((556 + 1554) <= (194 + 138))) then
					for v142, v143 in pairs(v68) do
						if (((3755 - (10 + 59)) > (898 + 2274)) and v143:IsCastable()) then
							if (v24(v143, not v12:IsSpellInRange(v143)) or ((22033 - 17559) < (1983 - (671 + 492)))) then
								return "wildfire_bomb st 34";
							end
						end
					end
				end
				if (((3407 + 872) >= (4097 - (369 + 846))) and v54.MongooseBite:IsReady() and (v12:DebuffUp(v54.ShrapnelBombDebuff))) then
					if (v24(v54.MongooseBite, not v12:IsInMeleeRange(v67)) or ((538 + 1491) >= (3005 + 516))) then
						return "mongoose_bite st 30";
					end
				end
				if (v11:HasTier(1975 - (1036 + 909), 4 + 0) or ((3419 - 1382) >= (4845 - (11 + 192)))) then
					for v144, v145 in pairs(v68) do
						if (((870 + 850) < (4633 - (135 + 40))) and v145:IsCastable() and ((v12:DebuffDown(v69[v144]) and v12:DebuffUp(v54.ShreddedArmorDebuff) and v70(v145:ExecuteTime())) or (v62 > (2 - 1)))) then
							if (v24(v145, not v12:IsSpellInRange(v145)) or ((263 + 173) > (6655 - 3634))) then
								return "wildfire_bomb st ";
							end
						end
					end
				end
				if (((1068 - 355) <= (1023 - (50 + 126))) and v54.MongooseBite:IsReady() and (v11:BuffUp(v54.MongooseFuryBuff))) then
					if (((5997 - 3843) <= (893 + 3138)) and v53.CastTargetIf(v54.MongooseBite, v63, "max", v73, nil, not v12:IsInMeleeRange(v67))) then
						return "mongoose_bite st 36";
					end
				end
				if (((6028 - (1233 + 180)) == (5584 - (522 + 447))) and v54.ExplosiveShot:IsReady() and (v54.Ranger:IsAvailable())) then
					if (v24(v54.ExplosiveShot, not v12:IsSpellInRange(v54.ExplosiveShot)) or ((5211 - (107 + 1314)) == (233 + 267))) then
						return "explosive_shot st 37";
					end
				end
				v122 = 15 - 10;
			end
			if (((38 + 51) < (438 - 217)) and (v122 == (0 - 0))) then
				if (((3964 - (716 + 1194)) >= (25 + 1396)) and v54.KillCommand:IsCastable() and v54.Spearhead:IsAvailable() and (v54.Spearhead:CooldownRemains() < ((1 + 1) * v11:GCD()))) then
					if (((1195 - (74 + 429)) < (5898 - 2840)) and v53.CastTargetIf(v54.KillCommand, v63, "min", v72, v76, not v12:IsSpellInRange(v54.KillCommand))) then
						return "kill_command st 2";
					end
				end
				if ((v54.Spearhead:IsAvailable() and (v54.Spearhead:CooldownRemains() < ((1 + 1) * v11:GCD())) and v12:DebuffUp(v54.ShreddedArmorDebuff)) or ((7448 - 4194) == (1171 + 484))) then
					for v146, v147 in pairs(v68) do
						if (v147:IsCastable() or ((3995 - 2699) == (12140 - 7230))) then
							if (((3801 - (279 + 154)) == (4146 - (454 + 324))) and v24(v147, not v12:IsSpellInRange(v147))) then
								return "wildfire_bomb st 4";
							end
						end
					end
				end
				if (((2080 + 563) < (3832 - (12 + 5))) and v54.DeathChakram:IsCastable() and (v70(v54.DeathChakram:ExecuteTime()) or (v54.Spearhead:IsAvailable() and v54.Spearhead:CooldownUp()))) then
					if (((1032 + 881) > (1255 - 762)) and v24(v54.DeathChakram, not v12:IsSpellInRange(v54.DeathChakram))) then
						return "death_chakram st 2";
					end
				end
				if (((1758 + 2997) > (4521 - (277 + 816))) and v54.Spearhead:IsCastable() and v29 and ((v11:Focus() + v11:FocusCastRegen(v54.KillCommand:ExecuteTime()) + (89 - 68)) > (v11:FocusMax() - (1193 - (1058 + 125)))) and (v54.DeathChakram:CooldownDown() or not v54.DeathChakram:IsAvailable())) then
					if (((259 + 1122) <= (3344 - (815 + 160))) and v24(v54.Spearhead, not v12:IsSpellInRange(v54.Spearhead))) then
						return "spearhead st 4";
					end
				end
				if ((v54.KillShot:IsReady() and v11:BuffUp(v54.CoordinatedAssaultEmpowerBuff) and (v54.Bite:IsReady() or v54.Claw:IsReady() or v54.Smack:IsReady())) or ((20779 - 15936) == (9694 - 5610))) then
					if (((1114 + 3555) > (1061 - 698)) and v24(v54.KillShot, not v12:IsSpellInRange(v54.KillShot))) then
						return "kill_shot st 6";
					end
				end
				v122 = 1899 - (41 + 1857);
			end
		end
	end
	local function v86()
		local v123 = 1893 - (1222 + 671);
		local v124;
		local v125;
		while true do
			if ((v123 == (5 - 3)) or ((2697 - 820) >= (4320 - (229 + 953)))) then
				v67 = (v124 and ((1814 - (1111 + 663)) + v125)) or ((1584 - (874 + 705)) + v125);
				if (((664 + 4078) >= (2474 + 1152)) and v28) then
					if ((v124 and not v12:IsInMeleeRange(16 - 8)) or ((128 + 4412) == (1595 - (642 + 37)))) then
						v62 = v12:GetEnemiesInSplashRangeCount(2 + 6);
					else
						v62 = #v11:GetEnemiesInRange(2 + 6);
					end
				else
					v62 = 2 - 1;
				end
				if (v124 or ((1610 - (233 + 221)) > (10047 - 5702))) then
					v63 = v11:GetEnemiesInRange(36 + 4);
				else
					v63 = v11:GetEnemiesInRange(1549 - (718 + 823));
				end
				v123 = 2 + 1;
			end
			if (((3042 - (266 + 539)) < (12029 - 7780)) and (v123 == (1225 - (636 + 589)))) then
				v52();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v123 = 2 - 1;
			end
			if (((5 - 2) == v123) or ((2127 + 556) < (9 + 14))) then
				if (((1712 - (657 + 358)) <= (2186 - 1360)) and (v53.TargetIsValid() or v11:AffectingCombat())) then
					local v135 = 0 - 0;
					while true do
						if (((2292 - (1151 + 36)) <= (1136 + 40)) and (v135 == (0 + 0))) then
							v64 = v8.BossFightRemains(nil, true);
							v65 = v64;
							v135 = 2 - 1;
						end
						if (((5211 - (1552 + 280)) <= (4646 - (64 + 770))) and (v135 == (1 + 0))) then
							if ((v65 == (25222 - 14111)) or ((140 + 648) >= (2859 - (157 + 1086)))) then
								v65 = v8.FightRemains(v63, false);
							end
							break;
						end
					end
				end
				if (((3710 - 1856) <= (14799 - 11420)) and not (v11:IsMounted() or v11:IsInVehicle()) and v40) then
					local v136 = 0 - 0;
					while true do
						if (((6208 - 1659) == (5368 - (599 + 220))) and (v136 == (0 - 0))) then
							if (v54.RevivePet:IsCastable() or ((4953 - (1813 + 118)) >= (2211 + 813))) then
								if (((6037 - (841 + 376)) > (3079 - 881)) and v24(v54.RevivePet, nil, true)) then
									return "Revive Pet";
								end
							end
							if ((v54.SummonPet:IsCastable() and v43 and v15:IsDeadOrGhost()) or ((247 + 814) >= (13350 - 8459))) then
								if (((2223 - (464 + 395)) <= (11479 - 7006)) and v24(v61[v41])) then
									return "Summon Pet";
								end
							end
							v136 = 1 + 0;
						end
						if ((v136 == (838 - (467 + 370))) or ((7428 - 3833) <= (3 + 0))) then
							if ((v54.MendPet:IsCastable() and v44 and (v15:HealthPercentage() < v45)) or ((16015 - 11343) == (601 + 3251))) then
								if (((3626 - 2067) == (2079 - (150 + 370))) and v24(v54.MendPet)) then
									return "Mend Pet";
								end
							end
							break;
						end
					end
				end
				if (v53.TargetIsValid() or ((3034 - (74 + 1208)) <= (1938 - 1150))) then
					local v137 = 0 - 0;
					while true do
						if ((v137 == (2 + 0)) or ((4297 - (14 + 376)) == (306 - 129))) then
							if (((2246 + 1224) > (488 + 67)) and (v62 > (2 + 0))) then
								local v148 = 0 - 0;
								local v149;
								while true do
									if ((v148 == (0 + 0)) or ((1050 - (23 + 55)) == (1528 - 883))) then
										v149 = v84();
										if (((2124 + 1058) >= (1900 + 215)) and v149) then
											return v149;
										end
										break;
									end
								end
							end
							if (((6035 - 2142) < (1394 + 3035)) and v54.ArcaneTorrent:IsCastable() and v29) then
								if (v24(v54.ArcaneTorrent, not v12:IsInRange(909 - (652 + 249))) or ((7672 - 4805) < (3773 - (708 + 1160)))) then
									return "arcane_torrent main 888";
								end
							end
							if (v24(v54.PoolFocus) or ((4875 - 3079) >= (7385 - 3334))) then
								return "Pooling Focus";
							end
							break;
						end
						if (((1646 - (10 + 17)) <= (844 + 2912)) and (v137 == (1732 - (1400 + 332)))) then
							if (((1158 - 554) == (2512 - (242 + 1666))) and not v11:AffectingCombat() and not v27) then
								local v150 = 0 + 0;
								local v151;
								while true do
									if ((v150 == (0 + 0)) or ((3822 + 662) == (1840 - (850 + 90)))) then
										v151 = v81();
										if (v151 or ((7809 - 3350) <= (2503 - (360 + 1030)))) then
											return v151;
										end
										break;
									end
								end
							end
							if (((3215 + 417) > (9590 - 6192)) and v54.Exhilaration:IsReady() and (v11:HealthPercentage() <= v47)) then
								if (((5615 - 1533) <= (6578 - (909 + 752))) and v24(v54.Exhilaration)) then
									return "exhilaration";
								end
							end
							if (((6055 - (109 + 1114)) >= (2537 - 1151)) and (v11:HealthPercentage() <= v36) and v55.Healthstone:IsReady()) then
								if (((54 + 83) == (379 - (6 + 236))) and v24(v57.Healthstone, nil, nil, true)) then
									return "healthstone";
								end
							end
							if ((not v11:IsCasting() and not v11:IsChanneling()) or ((990 + 580) >= (3487 + 845))) then
								local v152 = 0 - 0;
								local v153;
								while true do
									if ((v152 == (4 - 1)) or ((5197 - (1076 + 57)) <= (300 + 1519))) then
										v153 = v53.InterruptWithStun(v54.Intimidation, 729 - (579 + 110), nil, v14, v57.IntimidationMouseover);
										if (v153 or ((394 + 4592) < (1392 + 182))) then
											return v153;
										end
										break;
									end
									if (((2349 + 2077) > (579 - (174 + 233))) and (v152 == (2 - 1))) then
										v153 = v53.InterruptWithStun(v54.Intimidation, 70 - 30);
										if (((261 + 325) > (1629 - (663 + 511))) and v153) then
											return v153;
										end
										v152 = 2 + 0;
									end
									if (((180 + 646) == (2546 - 1720)) and (v152 == (0 + 0))) then
										v153 = v53.Interrupt(v54.Muzzle, 11 - 6, true);
										if (v153 or ((9728 - 5709) > (2120 + 2321))) then
											return v153;
										end
										v152 = 1 - 0;
									end
									if (((1438 + 579) < (390 + 3871)) and (v152 == (724 - (478 + 244)))) then
										v153 = v53.Interrupt(v54.Muzzle, 522 - (440 + 77), true, v14, v57.MuzzleMouseover);
										if (((2145 + 2571) > (292 - 212)) and v153) then
											return v153;
										end
										v152 = 1559 - (655 + 901);
									end
								end
							end
							v137 = 1 + 0;
						end
						if ((v137 == (1 + 0)) or ((2369 + 1138) == (13181 - 9909))) then
							if ((v48 and v54.TranquilizingShot:IsReady() and not v11:IsCasting() and not v11:IsChanneling() and (v53.UnitHasEnrageBuff(v12) or v53.UnitHasMagicBuff(v12))) or ((2321 - (695 + 750)) >= (10500 - 7425))) then
								if (((6715 - 2363) > (10271 - 7717)) and v24(v54.TranquilizingShot, not v12:IsSpellInRange(v54.TranquilizingShot))) then
									return "dispel";
								end
							end
							if ((not v124 and not v12:IsInMeleeRange(359 - (285 + 66))) or ((10270 - 5864) < (5353 - (682 + 628)))) then
								if ((v54.AspectoftheEagle:IsCastable() and v51) or ((305 + 1584) >= (3682 - (176 + 123)))) then
									if (((792 + 1100) <= (1984 + 750)) and v24(v54.AspectoftheEagle)) then
										return "aspect_of_the_eagle oor";
									end
								end
								if (((2192 - (239 + 30)) < (603 + 1615)) and v54.Harpoon:IsCastable() and v49) then
									if (((2089 + 84) > (670 - 291)) and v24(v54.Harpoon, not v12:IsSpellInRange(v54.Harpoon))) then
										return "harpoon oor";
									end
								end
							end
							if (v29 or ((8083 - 5492) == (3724 - (306 + 9)))) then
								local v154 = 0 - 0;
								local v155;
								while true do
									if (((786 + 3728) > (2040 + 1284)) and (v154 == (0 + 0))) then
										v155 = v83();
										if (v155 or ((594 - 386) >= (6203 - (1140 + 235)))) then
											return v155;
										end
										break;
									end
								end
							end
							if ((v62 < (2 + 1)) or not v28 or ((1452 + 131) > (916 + 2651))) then
								local v156 = 52 - (33 + 19);
								local v157;
								while true do
									if ((v156 == (0 + 0)) or ((3935 - 2622) == (350 + 444))) then
										v157 = v85();
										if (((6224 - 3050) > (2722 + 180)) and v157) then
											return v157;
										end
										break;
									end
								end
							end
							v137 = 691 - (586 + 103);
						end
					end
				end
				break;
			end
			if (((376 + 3744) <= (13115 - 8855)) and (v123 == (1489 - (1309 + 179)))) then
				v29 = EpicSettings.Toggles['cds'];
				v124 = v11:BuffUp(v54.AspectoftheEagle);
				v125 = (v54.Lunge:IsAvailable() and (5 - 2)) or (0 + 0);
				v123 = 5 - 3;
			end
		end
	end
	local function v87()
		v8.Print("Survival Hunter rotation by Epic. Supported by Gojira");
	end
	v8.SetAPL(193 + 62, v86, v87);
end;
return v0["Epix_Hunter_Survival.lua"]();

