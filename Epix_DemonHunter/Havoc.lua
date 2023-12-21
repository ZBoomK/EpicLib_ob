local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1229 + 689) == (118 + 957))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Press;
	local v21 = v19.Macro;
	local v22 = v19.Commons.Everyone;
	local v23 = v22.num;
	local v24 = v22.bool;
	local v25 = math.min;
	local v26 = math.max;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v78 = v17.DemonHunter.Havoc;
	local v79 = v18.DemonHunter.Havoc;
	local v80 = v21.DemonHunter.Havoc;
	local v81 = {};
	local v82 = v13:GetEquipment();
	local v83 = (v82[1059 - (82 + 964)] and v18(v82[13 + 0])) or v18(512 - (409 + 103));
	local v84 = (v82[250 - (46 + 190)] and v18(v82[109 - (51 + 44)])) or v18(0 + 0);
	local v85, v86;
	local v87, v88;
	local v89 = {{v78.FelEruption},{v78.ChaosNova}};
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = ((v78.AFireInside:IsAvailable()) and (668 - (174 + 489))) or (2 - 1);
	local v97 = v13:GCD() + (1905.25 - (830 + 1075));
	local v98 = 524 - (303 + 221);
	local v99 = false;
	local v100 = 12380 - (231 + 1038);
	local v101 = 9259 + 1852;
	local v102 = {(698218 - 528797),(422792 - 253367),(592166 - 423234),(273108 - 103682),(170677 - (111 + 1137)),(504260 - 334832),(169953 - (423 + 100))};
	v9:RegisterForEvent(function()
		local v116 = 0 + 0;
		while true do
			if (((1095 - 699) <= (1983 + 1821)) and (v116 == (774 - (326 + 445)))) then
				v101 = 48488 - 37377;
				break;
			end
			if ((v116 == (2 - 1)) or ((9730 - 5561) == (2898 - (530 + 181)))) then
				v92 = false;
				v93 = false;
				v116 = 883 - (614 + 267);
			end
			if (((1438 - (19 + 13)) == (2287 - 881)) and (v116 == (0 - 0))) then
				v90 = false;
				v91 = false;
				v116 = 2 - 1;
			end
			if (((398 + 1133) < (7511 - 3240)) and (v116 == (3 - 1))) then
				v94 = false;
				v100 = 12923 - (1293 + 519);
				v116 = 5 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v117 = 0 - 0;
		while true do
			if (((1214 - 579) == (2738 - 2103)) and ((0 - 0) == v117)) then
				v82 = v13:GetEquipment();
				v83 = (v82[7 + 6] and v18(v82[3 + 10])) or v18(0 - 0);
				v117 = 1 + 0;
			end
			if (((1121 + 2252) <= (2223 + 1333)) and (v117 == (1097 - (709 + 387)))) then
				v84 = (v82[1872 - (673 + 1185)] and v18(v82[40 - 26])) or v18(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v96 = ((v78.AFireInside:IsAvailable()) and (8 - 3)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v103(v118)
		return v118:DebuffRemains(v78.BurningWoundDebuff) or v118:DebuffRemains(v78.BurningWoundLegDebuff);
	end
	local function v104(v119)
		return v78.BurningWound:IsAvailable() and (v119:DebuffRemains(v78.BurningWoundDebuff) < (3 + 1)) and (v78.BurningWoundDebuff:AuraActiveCount() < v25(v87, 3 - 0));
	end
	local function v105()
		local v120 = 0 + 0;
		while true do
			if ((v120 == (1 - 0)) or ((6460 - 3169) < (5160 - (446 + 1434)))) then
				v27 = v22.HandleBottomTrinket(v81, v30, 1323 - (1040 + 243), nil);
				if (((13090 - 8704) >= (2720 - (559 + 1288))) and v27) then
					return v27;
				end
				break;
			end
			if (((2852 - (609 + 1322)) <= (1556 - (13 + 441))) and (v120 == (0 - 0))) then
				v27 = v22.HandleTopTrinket(v81, v30, 104 - 64, nil);
				if (((23437 - 18731) >= (36 + 927)) and v27) then
					return v27;
				end
				v120 = 3 - 2;
			end
		end
	end
	local function v106()
		local v121 = 0 + 0;
		while true do
			if ((v121 == (1 + 0)) or ((2848 - 1888) <= (480 + 396))) then
				if ((v79.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v75)) or ((3799 - 1733) == (617 + 315))) then
					if (((2684 + 2141) < (3480 + 1363)) and v20(v80.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v72 and (v13:HealthPercentage() <= v74)) or ((3256 + 621) >= (4439 + 98))) then
					local v172 = 433 - (153 + 280);
					while true do
						if ((v172 == (0 - 0)) or ((3875 + 440) < (682 + 1044))) then
							if ((v76 == "Refreshing Healing Potion") or ((1926 + 1753) < (568 + 57))) then
								if (v79.RefreshingHealingPotion:IsReady() or ((3352 + 1273) < (961 - 329))) then
									if (v20(v80.RefreshingHealingPotion) or ((52 + 31) > (2447 - (89 + 578)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((391 + 155) <= (2238 - 1161)) and (v76 == "Dreamwalker's Healing Potion")) then
								if (v79.DreamwalkersHealingPotion:IsReady() or ((2045 - (572 + 477)) > (581 + 3720))) then
									if (((2443 + 1627) > (83 + 604)) and v20(v80.RefreshingHealingPotion)) then
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
			if ((v121 == (86 - (84 + 2))) or ((1080 - 424) >= (2399 + 931))) then
				if ((v78.Blur:IsCastable() and v60 and (v13:HealthPercentage() <= v62)) or ((3334 - (497 + 345)) <= (9 + 326))) then
					if (((731 + 3591) >= (3895 - (605 + 728))) and v20(v78.Blur)) then
						return "blur defensive";
					end
				end
				if ((v78.Netherwalk:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) or ((2595 + 1042) >= (8381 - 4611))) then
					if (v20(v78.Netherwalk) or ((110 + 2269) > (16925 - 12347))) then
						return "netherwalk defensive";
					end
				end
				v121 = 1 + 0;
			end
		end
	end
	local function v107()
		local v122 = 0 - 0;
		while true do
			if (((2 + 0) == v122) or ((972 - (457 + 32)) > (316 + 427))) then
				if (((3856 - (832 + 570)) > (545 + 33)) and not v14:IsInMeleeRange(2 + 3) and v78.FelRush:IsCastable() and (not v78.Felblade:IsAvailable() or (v78.Felblade:CooldownDown() and not v13:PrevGCDP(3 - 2, v78.Felblade))) and v31 and v42) then
					if (((448 + 482) < (5254 - (588 + 208))) and v20(v78.FelRush, not v14:IsInRange(40 - 25))) then
						return "fel_rush precombat 10";
					end
				end
				if (((2462 - (884 + 916)) <= (2034 - 1062)) and v14:IsInMeleeRange(3 + 2) and v37 and (v78.DemonsBite:IsCastable() or v78.DemonBlades:IsAvailable())) then
					if (((5023 - (232 + 421)) == (6259 - (1569 + 320))) and v20(v78.DemonsBite, not v14:IsInMeleeRange(2 + 3))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if ((v122 == (1 + 0)) or ((16046 - 11284) <= (1466 - (316 + 289)))) then
				if ((not v14:IsInMeleeRange(13 - 8) and v78.Felblade:IsCastable() and v41) or ((66 + 1346) == (5717 - (666 + 787)))) then
					if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((3593 - (360 + 65)) < (2013 + 140))) then
						return "felblade precombat 9";
					end
				end
				if ((not v14:IsInMeleeRange(259 - (79 + 175)) and v78.ThrowGlaive:IsCastable() and v46) or ((7846 - 2870) < (1040 + 292))) then
					if (((14185 - 9557) == (8912 - 4284)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive precombat 9";
					end
				end
				v122 = 901 - (503 + 396);
			end
			if ((v122 == (181 - (92 + 89))) or ((104 - 50) == (203 + 192))) then
				if (((49 + 33) == (320 - 238)) and v78.ImmolationAura:IsCastable() and v44) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(2 + 6)) or ((1324 - 743) < (247 + 35))) then
						return "immolation_aura precombat 8";
					end
				end
				if ((v45 and not v13:IsMoving() and (v87 > (1 + 0)) and v78.SigilOfFlame:IsCastable()) or ((14037 - 9428) < (312 + 2183))) then
					if (((1756 - 604) == (2396 - (485 + 759))) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (((4387 - 2491) <= (4611 - (442 + 747))) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1143 - (832 + 303)))) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v77 == "cursor") or ((1936 - (88 + 858)) > (494 + 1126))) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(34 + 6)) or ((37 + 840) > (5484 - (766 + 23)))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v122 = 4 - 3;
			end
		end
	end
	local function v108()
		if (((3680 - 989) >= (4876 - 3025)) and v13:BuffDown(v78.FelBarrage)) then
			local v139 = 0 - 0;
			while true do
				if ((v139 == (1073 - (1036 + 37))) or ((2117 + 868) >= (9456 - 4600))) then
					if (((3364 + 912) >= (2675 - (641 + 839))) and v78.DeathSweep:IsReady() and v36) then
						if (((4145 - (910 + 3)) <= (11956 - 7266)) and v20(v78.DeathSweep, not v14:IsInRange(1692 - (1466 + 218)))) then
							return "death_sweep meta_end 2";
						end
					end
					if ((v78.Annihilation:IsReady() and v32) or ((412 + 484) >= (4294 - (556 + 592)))) then
						if (((1089 + 1972) >= (3766 - (329 + 479))) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v109()
		local v123 = 854 - (174 + 680);
		local v124;
		while true do
			if (((10950 - 7763) >= (1334 - 690)) and (v123 == (0 + 0))) then
				if (((1383 - (396 + 343)) <= (63 + 641)) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and not v78.Demonic:IsAvailable()) then
					if (((2435 - (29 + 1448)) > (2336 - (135 + 1254))) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(30 - 22))) then
						return "metamorphosis cooldown 4";
					end
				end
				if (((20973 - 16481) >= (1769 + 885)) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and v78.Demonic:IsAvailable() and ((not v78.ChaoticTransformation:IsAvailable() and v78.EyeBeam:CooldownDown()) or ((v78.EyeBeam:CooldownRemains() > (1547 - (389 + 1138))) and (not v90 or v13:PrevGCDP(575 - (102 + 472), v78.DeathSweep) or v13:PrevGCDP(2 + 0, v78.DeathSweep))) or ((v101 < (14 + 11 + (v23(v78.ShatteredDestiny:IsAvailable()) * (66 + 4)))) and v78.EyeBeam:CooldownDown() and v78.BladeDance:CooldownDown())) and v13:BuffDown(v78.InnerDemonBuff)) then
					if (((4987 - (320 + 1225)) >= (2675 - 1172)) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(5 + 3))) then
						return "metamorphosis cooldown 6";
					end
				end
				v123 = 1465 - (157 + 1307);
			end
			if ((v123 == (1860 - (821 + 1038))) or ((7909 - 4739) <= (161 + 1303))) then
				v124 = v22.HandleDPSPotion(v13:BuffUp(v78.MetamorphosisBuff));
				if (v124 or ((8520 - 3723) == (1633 + 2755))) then
					return v124;
				end
				v123 = 4 - 2;
			end
			if (((1577 - (834 + 192)) <= (44 + 637)) and (v123 == (1 + 1))) then
				if (((71 + 3206) > (629 - 222)) and v52 and not v13:IsMoving() and ((v30 and v55) or not v55) and v78.ElysianDecree:IsCastable() and (v14:DebuffDown(v78.EssenceBreakDebuff)) and (v87 > v59)) then
					if (((4999 - (300 + 4)) >= (378 + 1037)) and (v58 == "player")) then
						if (v20(v80.ElysianDecreePlayer, not v14:IsInRange(20 - 12)) or ((3574 - (112 + 250)) <= (377 + 567))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif ((v58 == "cursor") or ((7756 - 4660) <= (1031 + 767))) then
						if (((1830 + 1707) == (2646 + 891)) and v20(v80.ElysianDecreeCursor, not v14:IsInRange(15 + 15))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if (((2851 + 986) >= (2984 - (1001 + 413))) and (v69 < v101)) then
					if ((v70 and ((v30 and v71) or not v71)) or ((6578 - 3628) == (4694 - (244 + 638)))) then
						local v179 = 693 - (627 + 66);
						while true do
							if (((14072 - 9349) >= (2920 - (512 + 90))) and (v179 == (1906 - (1665 + 241)))) then
								v27 = v105();
								if (v27 or ((2744 - (373 + 344)) > (1287 + 1565))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v110()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (15 - 9)) or ((1921 - 785) > (5416 - (35 + 1064)))) then
				if (((3455 + 1293) == (10158 - 5410)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (1 + 29))) then
					if (((4972 - (298 + 938)) <= (5999 - (233 + 1026))) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1674 - (636 + 1030))) or ((1734 + 1656) <= (2989 + 71))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif ((v77 == "cursor") or ((297 + 702) > (182 + 2511))) then
						if (((684 - (55 + 166)) < (117 + 484)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(5 + 35))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				if ((v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(3 - 2, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v88 >= ((299 - (36 + 261)) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and not v13:HasTier(53 - 22, 1370 - (34 + 1334))) or ((840 + 1343) < (534 + 153))) then
					if (((5832 - (1035 + 248)) == (4570 - (20 + 1))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive rotation 40";
					end
				end
				if (((2435 + 2237) == (4991 - (134 + 185))) and v78.ImmolationAura:IsCastable() and v44 and (v13:BuffStack(v78.ImmolationAuraBuff) < v96) and v14:IsInRange(1141 - (549 + 584)) and (v13:BuffDown(v78.UnboundChaosBuff) or not v78.UnboundChaos:IsAvailable()) and ((v78.ImmolationAura:Recharge() < v78.EssenceBreak:CooldownRemains()) or (not v78.EssenceBreak:IsAvailable() and (v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge())))) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(693 - (314 + 371))) or ((12591 - 8923) < (1363 - (478 + 490)))) then
						return "immolation_aura rotation 42";
					end
				end
				if ((v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v78.ThrowGlaive:FullRechargeTime() < v78.BladeDance:CooldownRemains()) and v13:HasTier(1203 - (786 + 386), 6 - 4) and v13:BuffDown(v78.FelBarrage) and not v92) or ((5545 - (1055 + 324)) == (1795 - (1093 + 247)))) then
					if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3954 + 495) == (281 + 2382))) then
						return "throw_glaive rotation 44";
					end
				end
				v125 = 27 - 20;
			end
			if ((v125 == (9 - 6)) or ((12170 - 7893) < (7510 - 4521))) then
				if ((v78.TheHunt:IsCastable() and v31 and v54 and (v69 < v101) and ((v30 and v57) or not v57) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v9.CombatTime() < (4 + 6)) or (v78.Metamorphosis:CooldownRemains() > (38 - 28))) and ((v87 == (3 - 2)) or (v87 > (3 + 0)) or (v101 < (25 - 15))) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and (not v78.FuriousGaze:IsAvailable() or v13:BuffUp(v78.FuriousGazeBuff) or v13:HasTier(719 - (364 + 324), 10 - 6))) or not v13:HasTier(71 - 41, 1 + 1)) and (v9.CombatTime() > (41 - 31))) or ((1393 - 523) >= (12600 - 8451))) then
					if (((3480 - (1249 + 19)) < (2874 + 309)) and v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if (((18084 - 13438) > (4078 - (686 + 400))) and v78.FelBarrage:IsCastable() and v40 and ((v87 > (1 + 0)) or ((v87 == (230 - (73 + 156))) and (v13:FuryDeficit() < (1 + 19)) and v13:BuffDown(v78.MetamorphosisBuff)))) then
					if (((2245 - (721 + 90)) < (35 + 3071)) and v20(v78.FelBarrage, not v14:IsInRange(25 - 17))) then
						return "fel_barrage rotation 16";
					end
				end
				if (((1256 - (224 + 246)) < (4896 - 1873)) and v78.GlaiveTempest:IsReady() and v43 and (v14:DebuffDown(v78.EssenceBreakDebuff) or (v87 > (1 - 0))) and v13:BuffDown(v78.FelBarrage)) then
					if (v20(v78.GlaiveTempest, not v14:IsInRange(2 + 6)) or ((59 + 2383) < (55 + 19))) then
						return "glaive_tempest rotation 18";
					end
				end
				if (((9016 - 4481) == (15091 - 10556)) and v78.Annihilation:IsReady() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v78.FelBarrage)) then
					if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((3522 - (203 + 310)) <= (4098 - (1238 + 755)))) then
						return "annihilation rotation 20";
					end
				end
				v125 = 1 + 3;
			end
			if (((3364 - (709 + 825)) < (6760 - 3091)) and (v125 == (5 - 1))) then
				if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (867 - (196 + 668)))) and (v13:BuffRemains(v78.MomentumBuff) < (19 - 14)) and v13:BuffDown(v78.MetamorphosisBuff)) or ((2962 - 1532) >= (4445 - (171 + 662)))) then
					if (((2776 - (4 + 89)) >= (8622 - 6162)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 22";
					end
				end
				if ((v78.EyeBeam:IsCastable() and v39 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.Metamorphosis:CooldownRemains() > ((131 - 101) - (v23(v78.CycleOfHatred:IsAvailable()) * (6 + 9)))) or ((v78.Metamorphosis:CooldownRemains() < (v97 * (1488 - (35 + 1451)))) and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() < (v97 * (1454.5 - (28 + 1425))))))) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > v97) or not v78.RestlessHunter:IsAvailable()) and (v78.CycleOfHatred:IsAvailable() or not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (1998 - (941 + 1052))) or not v47 or (v9.CombatTime() < (10 + 0))) and v13:BuffDown(v78.InnerDemonBuff)) or (v101 < (1529 - (822 + 692))))) or ((2575 - 771) >= (1543 + 1732))) then
					if (v20(v78.EyeBeam, not v14:IsInRange(305 - (45 + 252))) or ((1403 + 14) > (1249 + 2380))) then
						return "eye_beam rotation 26";
					end
				end
				if (((11669 - 6874) > (835 - (114 + 319))) and v78.BladeDance:IsCastable() and v33 and v90 and ((v78.EyeBeam:CooldownRemains() > (6 - 1)) or not v78.Demonic:IsAvailable() or v13:HasTier(39 - 8, 2 + 0))) then
					if (((7170 - 2357) > (7469 - 3904)) and v20(v78.BladeDance, not v14:IsInRange(1971 - (556 + 1407)))) then
						return "blade_dance rotation 28";
					end
				end
				if (((5118 - (741 + 465)) == (4377 - (170 + 295))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff) and (v87 >= (3 + 1))) then
					if (((2592 + 229) <= (11876 - 7052)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (((1441 + 297) <= (1408 + 787)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(5 + 3))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif (((1271 - (957 + 273)) <= (808 + 2210)) and (v77 == "cursor")) then
						if (((859 + 1286) <= (15638 - 11534)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(105 - 65))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				v125 = 15 - 10;
			end
			if (((13315 - 10626) < (6625 - (389 + 1391))) and (v125 == (6 + 3))) then
				if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) <= (3 + 17))) or ((5285 - 2963) > (3573 - (783 + 168)))) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((15216 - 10682) == (2048 + 34))) then
						return "fel_rush rotation 58";
					end
				end
				if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v14:IsInRange(319 - (309 + 2)) and not v78.Momentum:IsAvailable()) or ((4824 - 3253) > (3079 - (1090 + 122)))) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((861 + 1793) >= (10061 - 7065))) then
						return "fel_rush rotation 59";
					end
				end
				if (((2723 + 1255) > (3222 - (628 + 490))) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and not v78.Initiative:IsAvailable() and not v14:IsInRange(2 + 6)) then
					if (((7415 - 4420) > (7042 - 5501)) and v20(v78.VengefulRetreat, not v14:IsInRange(782 - (431 + 343)), nil, true)) then
						return "vengeful_retreat rotation 60";
					end
				end
				if (((6561 - 3312) > (2756 - 1803)) and v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and (v78.DemonBlades:IsAvailable() or not v14:IsInRange(2 + 10)) and v14:DebuffDown(v78.EssenceBreakDebuff) and v14:IsSpellInRange(v78.ThrowGlaive) and not v13:HasTier(1726 - (556 + 1139), 17 - (6 + 9))) then
					if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((600 + 2673) > (2343 + 2230))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if ((v125 == (174 - (28 + 141))) or ((1221 + 1930) < (1584 - 300))) then
				if ((v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v87 >= ((1319 - (486 + 831)) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.ThrowGlaive:FullRechargeTime() < (v97 * (7 - 4))) or (v87 > (3 - 2))) and not v13:HasTier(6 + 25, 6 - 4)) or ((3113 - (668 + 595)) == (1376 + 153))) then
					if (((166 + 655) < (5789 - 3666)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive rotation 32";
					end
				end
				if (((1192 - (23 + 267)) < (4269 - (1129 + 815))) and v78.ImmolationAura:IsCastable() and v44 and (v87 >= (389 - (371 + 16))) and (v13:Fury() < (1820 - (1326 + 424))) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
					if (((1624 - 766) <= (10823 - 7861)) and v20(v78.ImmolationAura, not v14:IsInRange(126 - (88 + 30)))) then
						return "immolation_aura rotation 34";
					end
				end
				if ((v78.Annihilation:IsCastable() and v32 and not v91 and ((v78.EssenceBreak:CooldownRemains() > (771 - (720 + 51))) or not v78.EssenceBreak:IsAvailable()) and v13:BuffDown(v78.FelBarrage)) or v13:HasTier(66 - 36, 1778 - (421 + 1355)) or ((6509 - 2563) < (633 + 655))) then
					if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((4325 - (286 + 797)) == (2072 - 1505))) then
						return "annihilation rotation 36";
					end
				end
				if ((v78.Felblade:IsCastable() and v41 and (((v13:FuryDeficit() >= (66 - 26)) and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)))) or ((1286 - (397 + 42)) >= (395 + 868))) then
					if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((3053 - (24 + 776)) == (2851 - 1000))) then
						return "felblade rotation 38";
					end
				end
				v125 = 791 - (222 + 563);
			end
			if ((v125 == (17 - 9)) or ((1503 + 584) > (2562 - (23 + 167)))) then
				if ((v78.DemonsBite:IsCastable() and v37 and v78.BurningWound:IsAvailable() and (v14:DebuffRemains(v78.BurningWoundDebuff) < (1802 - (690 + 1108)))) or ((1604 + 2841) < (3423 + 726))) then
					if (v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite)) or ((2666 - (40 + 808)) == (14 + 71))) then
						return "demons_bite rotation 54";
					end
				end
				if (((2409 - 1779) < (2033 + 94)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and not v78.DemonBlades:IsAvailable() and (v87 > (1 + 0)) and v13:BuffDown(v78.UnboundChaosBuff)) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((1063 + 875) == (3085 - (47 + 524)))) then
						return "fel_rush rotation 56";
					end
				end
				if (((2762 + 1493) >= (150 - 95)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (44 - 14)) and v14:IsInRange(68 - 38)) then
					if (((4725 - (1165 + 561)) > (35 + 1121)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (((7278 - 4928) > (441 + 714)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(487 - (341 + 138)))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif (((1088 + 2941) <= (10014 - 5161)) and (v77 == "cursor")) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(356 - (89 + 237))) or ((1659 - 1143) > (7229 - 3795))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				if (((4927 - (581 + 300)) >= (4253 - (855 + 365))) and v78.DemonsBite:IsCastable() and v37) then
					if (v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite)) or ((6457 - 3738) <= (473 + 974))) then
						return "demons_bite rotation 57";
					end
				end
				v125 = 1244 - (1030 + 205);
			end
			if ((v125 == (7 + 0)) or ((3846 + 288) < (4212 - (156 + 130)))) then
				if ((v78.ChaosStrike:IsReady() and v34 and not v91 and not v92 and v13:BuffDown(v78.FelBarrage)) or ((372 - 208) >= (4693 - 1908))) then
					if (v20(v78.ChaosStrike, not v14:IsSpellInRange(v78.ChaosStrike)) or ((1075 - 550) == (556 + 1553))) then
						return "chaos_strike rotation 46";
					end
				end
				if (((20 + 13) == (102 - (10 + 59))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and (v13:FuryDeficit() >= (9 + 21))) then
					if (((15040 - 11986) <= (5178 - (671 + 492))) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (((1490 + 381) < (4597 - (369 + 846))) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(3 + 5))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif (((1104 + 189) <= (4111 - (1036 + 909))) and (v77 == "cursor")) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(24 + 6)) or ((4329 - 1750) < (326 - (11 + 192)))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				if ((v78.Felblade:IsCastable() and v41 and (v13:FuryDeficit() >= (21 + 19))) or ((1021 - (135 + 40)) >= (5737 - 3369))) then
					if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((2419 + 1593) <= (7397 - 4039))) then
						return "felblade rotation 50";
					end
				end
				if (((2239 - 745) <= (3181 - (50 + 126))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and v78.DemonBlades:IsAvailable() and v78.EyeBeam:CooldownDown() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.FelRush:Recharge() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable())) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((8662 - 5551) == (473 + 1661))) then
						return "fel_rush rotation 52";
					end
				end
				v125 = 1421 - (1233 + 180);
			end
			if (((3324 - (522 + 447)) == (3776 - (107 + 1314))) and ((0 + 0) == v125)) then
				if ((v78.EssenceBreak:IsCastable() and v38 and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (30 - 20)))) or ((250 + 338) <= (857 - 425))) then
					if (((18979 - 14182) >= (5805 - (716 + 1194))) and v20(v78.EssenceBreak, not v14:IsInRange(1 + 7))) then
						return "essence_break rotation prio";
					end
				end
				if (((384 + 3193) == (4080 - (74 + 429))) and v78.BladeDance:IsCastable() and v33 and v14:DebuffUp(v78.EssenceBreakDebuff)) then
					if (((7318 - 3524) > (1831 + 1862)) and v20(v78.BladeDance, not v14:IsInRange(18 - 10))) then
						return "blade_dance rotation prio";
					end
				end
				if ((v78.DeathSweep:IsCastable() and v36 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((903 + 372) == (12640 - 8540))) then
					if (v20(v78.DeathSweep, not v14:IsInRange(19 - 11)) or ((2024 - (279 + 154)) >= (4358 - (454 + 324)))) then
						return "death_sweep rotation prio";
					end
				end
				if (((774 + 209) <= (1825 - (12 + 5))) and v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.Metamorphosis:CooldownRemains() <= (v13:GCD() * (2 + 1)))) then
					if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((5478 - 3328) <= (443 + 754))) then
						return "annihilation rotation 2";
					end
				end
				v125 = 1094 - (277 + 816);
			end
			if (((16105 - 12336) >= (2356 - (1058 + 125))) and (v125 == (1 + 1))) then
				if (((2460 - (815 + 160)) == (6371 - 4886)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) < (v97 * (4 - 2))) and (v78.EyeBeam:CooldownRemains() <= v97) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((791 + 2524) <= (8132 - 5350))) then
						return "fel_rush rotation 10";
					end
				end
				if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or ((v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge()) and (v78.EyeBeam:CooldownRemains() > (1902 - (41 + 1857))))) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) or ((2769 - (1222 + 671)) >= (7660 - 4696))) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3207 - 975) > (3679 - (229 + 953)))) then
						return "fel_rush rotation 11";
					end
				end
				if ((v78.EssenceBreak:IsCastable() and v38 and ((((v13:BuffRemains(v78.MetamorphosisBuff) > (v97 * (1777 - (1111 + 663)))) or (v78.EyeBeam:CooldownRemains() > (1589 - (874 + 705)))) and (not v78.TacticalRetreat:IsAvailable() or v13:BuffUp(v78.TacticalRetreatBuff) or (v9.CombatTime() < (2 + 8))) and (v78.BladeDance:CooldownRemains() <= ((3.1 + 0) * v97))) or (v101 < (12 - 6)))) or ((60 + 2050) <= (1011 - (642 + 37)))) then
					if (((841 + 2845) > (508 + 2664)) and v20(v78.EssenceBreak, not v14:IsInRange(19 - 11))) then
						return "essence_break rotation 13";
					end
				end
				if ((v78.DeathSweep:IsCastable() and v36 and v90 and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() > (v97 * (456 - (233 + 221))))) and v13:BuffDown(v78.FelBarrage)) or ((10345 - 5871) < (722 + 98))) then
					if (((5820 - (718 + 823)) >= (1814 + 1068)) and v20(v78.DeathSweep, not v14:IsInRange(813 - (266 + 539)))) then
						return "death_sweep rotation 14";
					end
				end
				v125 = 8 - 5;
			end
			if ((v125 == (1226 - (636 + 589))) or ((4815 - 2786) >= (7262 - 3741))) then
				if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and (v78.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1 + 1))) and (v9.CombatTime() > (1020 - (657 + 358))) and (v13:Fury() >= (79 - 49)) and v78.Inertia:IsAvailable()) or ((4640 - 2603) >= (5829 - (1151 + 36)))) then
					if (((1661 + 59) < (1173 + 3285)) and v20(v78.VengefulRetreat, not v14:IsInRange(23 - 15), nil, true)) then
						return "vengeful_retreat rotation 3";
					end
				end
				if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1833 - (1552 + 280))) and ((v78.EssenceBreak:CooldownRemains() > (849 - (64 + 770))) or ((v78.EssenceBreak:CooldownRemains() < v97) and (not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (11 + 4 + ((22 - 12) * v23(v78.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (6 + 24)) or ((v13:GCDRemains() - (1244 - (157 + 1086))) < (0 - 0))) and (not v78.Initiative:IsAvailable() or (v13:BuffRemains(v78.InitiativeBuff) < v97) or (v9.CombatTime() > (17 - 13)))) or ((668 - 232) > (4123 - 1102))) then
					if (((1532 - (599 + 220)) <= (1686 - 839)) and v20(v78.VengefulRetreat, not v14:IsInRange(1939 - (1813 + 118)), nil, true)) then
						return "vengeful_retreat rotation 4";
					end
				end
				if (((1575 + 579) <= (5248 - (841 + 376))) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 - 0)) and ((v78.EssenceBreak:CooldownRemains() > (4 + 11)) or ((v78.EssenceBreak:CooldownRemains() < (v97 * (5 - 3))) and (((v13:BuffRemains(v78.InitiativeBuff) < v97) and not v95 and (v78.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (889 - (464 + 395)))) or not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((38 - 23) + ((5 + 5) * v23(v78.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v78.UnboundChaosBuff) or v13:BuffUp(v78.InertiaBuff))) then
					if (((5452 - (467 + 370)) == (9536 - 4921)) and v20(v78.VengefulRetreat, not v14:IsInRange(6 + 2), nil, true)) then
						return "vengeful_retreat rotation 6";
					end
				end
				if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and not v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (3 - 2)) and (v13:BuffDown(v78.InitiativeBuff) or (v13:PrevGCDP(1 + 0, v78.DeathSweep) and v78.Metamorphosis:CooldownUp() and v78.ChaoticTransformation:IsAvailable())) and v78.Initiative:IsAvailable()) or ((8817 - 5027) == (1020 - (150 + 370)))) then
					if (((1371 - (74 + 1208)) < (543 - 322)) and v20(v78.VengefulRetreat, not v14:IsInRange(37 - 29), nil, true)) then
						return "vengeful_retreat rotation 8";
					end
				end
				v125 = 2 + 0;
			end
		end
	end
	local function v111()
		local v126 = 390 - (14 + 376);
		while true do
			if (((3561 - 1507) >= (920 + 501)) and (v126 == (7 + 0))) then
				v57 = EpicSettings.Settings['theHuntWithCD'];
				v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				break;
			end
			if (((2027 - 1335) < (2301 + 757)) and (v126 == (78 - (23 + 55)))) then
				v32 = EpicSettings.Settings['useAnnihilation'];
				v33 = EpicSettings.Settings['useBladeDance'];
				v34 = EpicSettings.Settings['useChaosStrike'];
				v126 = 2 - 1;
			end
			if ((v126 == (3 + 1)) or ((2923 + 331) == (2566 - 911))) then
				v44 = EpicSettings.Settings['useImmolationAura'];
				v45 = EpicSettings.Settings['useSigilOfFlame'];
				v46 = EpicSettings.Settings['useThrowGlaive'];
				v126 = 2 + 3;
			end
			if (((904 - (652 + 249)) == v126) or ((3468 - 2172) == (6778 - (708 + 1160)))) then
				v41 = EpicSettings.Settings['useFelblade'];
				v42 = EpicSettings.Settings['useFelRush'];
				v43 = EpicSettings.Settings['useGlaiveTempest'];
				v126 = 10 - 6;
			end
			if (((6140 - 2772) == (3395 - (10 + 17))) and (v126 == (1 + 1))) then
				v38 = EpicSettings.Settings['useEssenceBreak'];
				v39 = EpicSettings.Settings['useEyeBeam'];
				v40 = EpicSettings.Settings['useFelBarrage'];
				v126 = 1735 - (1400 + 332);
			end
			if (((5069 - 2426) < (5723 - (242 + 1666))) and (v126 == (3 + 3))) then
				v54 = EpicSettings.Settings['useTheHunt'];
				v55 = EpicSettings.Settings['elysianDecreeWithCD'];
				v56 = EpicSettings.Settings['metamorphosisWithCD'];
				v126 = 3 + 4;
			end
			if (((1631 + 282) > (1433 - (850 + 90))) and ((1 - 0) == v126)) then
				v35 = EpicSettings.Settings['useConsumeMagic'];
				v36 = EpicSettings.Settings['useDeathSweep'];
				v37 = EpicSettings.Settings['useDemonsBite'];
				v126 = 1392 - (360 + 1030);
			end
			if (((4209 + 546) > (9675 - 6247)) and (v126 == (6 - 1))) then
				v47 = EpicSettings.Settings['useVengefulRetreat'];
				v52 = EpicSettings.Settings['useElysianDecree'];
				v53 = EpicSettings.Settings['useMetamorphosis'];
				v126 = 1667 - (909 + 752);
			end
		end
	end
	local function v112()
		local v127 = 1223 - (109 + 1114);
		while true do
			if (((2528 - 1147) <= (923 + 1446)) and (v127 == (245 - (6 + 236)))) then
				v62 = EpicSettings.Settings['blurHP'] or (0 + 0);
				v63 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
				v127 = 8 - 4;
			end
			if ((v127 == (1 - 0)) or ((5976 - (1076 + 57)) == (672 + 3412))) then
				v50 = EpicSettings.Settings['useFelEruption'];
				v51 = EpicSettings.Settings['useSigilOfMisery'];
				v127 = 691 - (579 + 110);
			end
			if (((369 + 4300) > (321 + 42)) and (v127 == (0 + 0))) then
				v48 = EpicSettings.Settings['useChaosNova'];
				v49 = EpicSettings.Settings['useDisrupt'];
				v127 = 408 - (174 + 233);
			end
			if (((5 - 3) == v127) or ((3294 - 1417) >= (1396 + 1742))) then
				v60 = EpicSettings.Settings['useBlur'];
				v61 = EpicSettings.Settings['useNetherwalk'];
				v127 = 1177 - (663 + 511);
			end
			if (((4231 + 511) >= (788 + 2838)) and (v127 == (12 - 8))) then
				v77 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
		end
	end
	local function v113()
		v69 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v64 = EpicSettings.Settings['dispelBuffs'];
		v66 = EpicSettings.Settings['InterruptWithStun'];
		v67 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v68 = EpicSettings.Settings['InterruptThreshold'];
		v70 = EpicSettings.Settings['useTrinkets'];
		v71 = EpicSettings.Settings['trinketsWithCD'];
		v73 = EpicSettings.Settings['useHealthstone'];
		v72 = EpicSettings.Settings['useHealingPotion'];
		v75 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v74 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v76 = EpicSettings.Settings['HealingPotionName'] or "";
		v65 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v114()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (0 - 0)) or ((3236 + 1304) == (84 + 832))) then
				v112();
				v111();
				v113();
				v28 = EpicSettings.Toggles['ooc'];
				v137 = 723 - (478 + 244);
			end
			if ((v137 == (519 - (440 + 77))) or ((526 + 630) > (15902 - 11557))) then
				v85 = v13:GetEnemiesInMeleeRange(1564 - (655 + 901));
				v86 = v13:GetEnemiesInMeleeRange(4 + 16);
				if (((1713 + 524) < (2870 + 1379)) and v29) then
					local v173 = 0 - 0;
					while true do
						if ((v173 == (1445 - (695 + 750))) or ((9161 - 6478) < (34 - 11))) then
							v87 = ((#v85 > (0 - 0)) and #v85) or (352 - (285 + 66));
							v88 = #v86;
							break;
						end
					end
				else
					local v174 = 0 - 0;
					while true do
						if (((2007 - (682 + 628)) <= (134 + 692)) and ((299 - (176 + 123)) == v174)) then
							v87 = 1 + 0;
							v88 = 1 + 0;
							break;
						end
					end
				end
				v97 = v13:GCD() + (269.05 - (239 + 30));
				v137 = 1 + 2;
			end
			if (((1063 + 42) <= (2080 - 904)) and ((8 - 5) == v137)) then
				if (((3694 - (306 + 9)) <= (13302 - 9490)) and (v22.TargetIsValid() or v13:AffectingCombat())) then
					local v175 = 0 + 0;
					while true do
						if ((v175 == (0 + 0)) or ((380 + 408) >= (4620 - 3004))) then
							v100 = v9.BossFightRemains(nil, true);
							v101 = v100;
							v175 = 1376 - (1140 + 235);
						end
						if (((1180 + 674) <= (3099 + 280)) and (v175 == (1 + 0))) then
							if (((4601 - (33 + 19)) == (1643 + 2906)) and (v101 == (33302 - 22191))) then
								v101 = v9.FightRemains(v85, false);
							end
							break;
						end
					end
				end
				v27 = v106();
				if (v27 or ((1332 + 1690) >= (5930 - 2906))) then
					return v27;
				end
				if (((4520 + 300) > (2887 - (586 + 103))) and v65) then
					local v176 = 0 + 0;
					while true do
						if ((v176 == (0 - 0)) or ((2549 - (1309 + 179)) >= (8829 - 3938))) then
							v27 = v22.HandleIncorporeal(v78.Imprison, v80.ImprisonMouseover, 14 + 16, true);
							if (((3663 - 2299) <= (3379 + 1094)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				v137 = 7 - 3;
			end
			if ((v137 == (7 - 3)) or ((4204 - (295 + 314)) <= (6 - 3))) then
				if ((v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((6634 - (1300 + 662)) == (12095 - 8243))) then
					local v177 = 1755 - (1178 + 577);
					local v178;
					while true do
						if (((810 + 749) == (4608 - 3049)) and (v177 == (1409 - (851 + 554)))) then
							if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.ImmolationAura:FullRechargeTime() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable()) and v14:DebuffDown(v78.EssenceBreakDebuff) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > (6 + 0))) and v78.BladeDance:CooldownDown() and ((v13:Fury() < (208 - 133)) or (v78.BladeDance:CooldownRemains() < (v97 * (3 - 1))))) or ((2054 - (115 + 187)) <= (604 + 184))) then
								if (v20(v78.ImmolationAura, not v14:IsInRange(8 + 0)) or ((15396 - 11489) == (1338 - (160 + 1001)))) then
									return "immolation_aura main 6";
								end
							end
							if (((3036 + 434) > (383 + 172)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and ((v13:BuffRemains(v78.UnboundChaosBuff) < (v97 * (3 - 1))) or (v14:TimeToDie() < (v97 * (360 - (237 + 121)))))) then
								if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((1869 - (525 + 372)) == (1222 - 577))) then
									return "fel_rush main 8";
								end
							end
							if (((10454 - 7272) >= (2257 - (96 + 46))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and ((v78.EyeBeam:CooldownRemains() + (780 - (643 + 134))) > v13:BuffRemains(v78.UnboundChaosBuff)) and (v78.BladeDance:CooldownDown() or v78.EssenceBreak:CooldownUp())) then
								if (((1406 + 2487) < (10619 - 6190)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fel_rush main 9";
								end
							end
							if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EssenceBreak:CooldownRemains() > (37 - 27)))) or ((2750 + 117) < (3738 - 1833))) then
								if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3671 - 1875) >= (4770 - (316 + 403)))) then
									return "fel_rush main 10";
								end
							end
							v177 = 4 + 1;
						end
						if (((4451 - 2832) <= (1358 + 2398)) and (v177 == (0 - 0))) then
							if (((429 + 175) == (195 + 409)) and not v13:AffectingCombat()) then
								v27 = v107();
								if (v27 or ((15536 - 11052) == (4298 - 3398))) then
									return v27;
								end
							end
							if ((v78.ConsumeMagic:IsAvailable() and v35 and v78.ConsumeMagic:IsReady() and v64 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) or ((9262 - 4803) <= (64 + 1049))) then
								if (((7149 - 3517) > (166 + 3232)) and v20(v78.ConsumeMagic, not v14:IsSpellInRange(v78.ConsumeMagic))) then
									return "greater_purge damage";
								end
							end
							if (((12009 - 7927) <= (4934 - (12 + 5))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v14:IsInRange(30 - 22)) then
								if (((10309 - 5477) >= (2946 - 1560)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fel_rush rotation when OOR";
								end
							end
							if (((339 - 202) == (28 + 109)) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v14:NPCID())) then
								if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3543 - (1656 + 317)) >= (3861 + 471))) then
									return "fodder to the flames react per target";
								end
							end
							v177 = 1 + 0;
						end
						if ((v177 == (15 - 9)) or ((20001 - 15937) <= (2173 - (5 + 349)))) then
							if ((v78.DemonBlades:IsAvailable()) or ((23682 - 18696) < (2845 - (266 + 1005)))) then
								if (((2917 + 1509) > (586 - 414)) and v20(v78.Pool)) then
									return "pool demon_blades";
								end
							end
							break;
						end
						if (((771 - 185) > (2151 - (561 + 1135))) and (v177 == (2 - 0))) then
							v94 = (v78.Momentum:IsAvailable() and v13:BuffDown(v78.MomentumBuff)) or (v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff));
							v178 = v26(v78.EyeBeam:BaseDuration(), v13:GCD());
							v95 = v78.Demonic:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v101 > (v78.Metamorphosis:CooldownRemains() + (98 - 68) + (v23(v78.ShatteredDestiny:IsAvailable()) * (1126 - (507 + 559))))) and (v78.Metamorphosis:CooldownRemains() < (50 - 30)) and (v78.Metamorphosis:CooldownRemains() > (v178 + (v97 * (v23(v78.InnerDemon:IsAvailable()) + (6 - 4)))));
							if (((1214 - (212 + 176)) == (1731 - (250 + 655))) and v78.ImmolationAura:IsCastable() and v44 and v78.Ragefire:IsAvailable() and (v87 >= (8 - 5)) and (v78.BladeDance:CooldownDown() or v14:DebuffDown(v78.EssenceBreakDebuff))) then
								if (v20(v78.ImmolationAura, not v14:IsInRange(13 - 5)) or ((6287 - 2268) > (6397 - (1869 + 87)))) then
									return "immolation_aura main 2";
								end
							end
							v177 = 10 - 7;
						end
						if (((3918 - (484 + 1417)) < (9132 - 4871)) and ((1 - 0) == v177)) then
							if (((5489 - (48 + 725)) > (130 - 50)) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v15:NPCID())) then
								if (v20(v80.ThrowGlaiveMouseover, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((9408 - 5901) == (1902 + 1370))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v90 = v78.FirstBlood:IsAvailable() or v78.TrailofRuin:IsAvailable() or (v78.ChaosTheory:IsAvailable() and v13:BuffDown(v78.ChaosTheoryBuff)) or (v87 > (2 - 1));
							v91 = v90 and (v13:Fury() < ((21 + 54) - (v23(v78.DemonBlades:IsAvailable()) * (6 + 14)))) and (v78.BladeDance:CooldownRemains() < v97);
							v92 = v78.Demonic:IsAvailable() and not v78.BlindFury:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (855 - (152 + 701)))) and (v13:FuryDeficit() > (1341 - (430 + 881)));
							v177 = 1 + 1;
						end
						if ((v177 == (898 - (557 + 338))) or ((259 + 617) >= (8665 - 5590))) then
							if (((15239 - 10887) > (6785 - 4231)) and v78.ImmolationAura:IsCastable() and v44 and v78.AFireInside:IsAvailable() and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (v78.ImmolationAura:FullRechargeTime() < (v97 * (4 - 2))) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
								if (v20(v78.ImmolationAura, not v14:IsInRange(809 - (499 + 302))) or ((5272 - (39 + 827)) < (11160 - 7117))) then
									return "immolation_aura main 3";
								end
							end
							if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and (((v78.ImmolationAura:Charges() == (4 - 2)) and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v13:PrevGCDP(3 - 2, v78.EyeBeam) and v13:BuffUp(v78.InertiaBuff) and (v13:BuffRemains(v78.InertiaBuff) < (3 - 0))))) or ((162 + 1727) >= (9901 - 6518))) then
								if (((303 + 1589) <= (4325 - 1591)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fel_rush main 4";
								end
							end
							if (((2027 - (103 + 1)) < (2772 - (475 + 79))) and v78.TheHunt:IsCastable() and (v9.CombatTime() < (21 - 11)) and (not v78.Inertia:IsAvailable() or (v13:BuffUp(v78.MetamorphosisBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)))) then
								if (((6953 - 4780) > (49 + 330)) and v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt))) then
									return "the_hunt main 6";
								end
							end
							if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and ((v78.EyeBeam:CooldownRemains() < (v97 * (2 + 0))) or v13:BuffUp(v78.MetamorphosisBuff)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1506 - (1395 + 108)))) and v13:BuffDown(v78.UnboundChaosBuff) and v13:BuffDown(v78.InertiaBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((7539 - 4948) == (4613 - (7 + 1197)))) then
								if (((1969 + 2545) > (1160 + 2164)) and v20(v78.ImmolationAura, not v14:IsInRange(327 - (27 + 292)))) then
									return "immolation_aura main 5";
								end
							end
							v177 = 11 - 7;
						end
						if ((v177 == (6 - 1)) or ((872 - 664) >= (9520 - 4692))) then
							if (((v69 < v101) and v30) or ((3014 - 1431) > (3706 - (43 + 96)))) then
								v27 = v109();
								if (v27 or ((5355 - 4042) == (1794 - 1000))) then
									return v27;
								end
							end
							if (((2634 + 540) > (820 + 2082)) and v13:BuffUp(v78.MetamorphosisBuff) and (v13:BuffRemains(v78.MetamorphosisBuff) < v97) and (v87 < (5 - 2))) then
								v27 = v108();
								if (((1580 + 2540) <= (7983 - 3723)) and v27) then
									return v27;
								end
							end
							v27 = v110();
							if (v27 or ((278 + 605) > (351 + 4427))) then
								return v27;
							end
							v177 = 1757 - (1414 + 337);
						end
					end
				end
				break;
			end
			if ((v137 == (1941 - (1642 + 298))) or ((9436 - 5816) >= (14070 - 9179))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['movement'];
				if (((12635 - 8377) > (309 + 628)) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v137 = 2 + 0;
			end
		end
	end
	local function v115()
		local v138 = 972 - (357 + 615);
		while true do
			if (((0 + 0) == v138) or ((11946 - 7077) < (777 + 129))) then
				v78.BurningWoundDebuff:RegisterAuraTracking();
				v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(1236 - 659, v114, v115);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

