local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5349 - (512 + 114)) > (3535 - 2179)) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1925 + 2211) <= (643 + 2790))) then
			v6 = v0[v4];
			if (((3691 + 554) <= (15620 - 10989)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1995 - (109 + 1885);
		end
	end
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.CastSuggested;
	local v24 = v20.Press;
	local v25 = v20.Macro;
	local v26 = v20.Commons.Everyone;
	local v27 = v26.num;
	local v28 = v26.bool;
	local v29 = math.min;
	local v30 = math.max;
	local v31 = 1474 - (1269 + 200);
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v84;
	local v85 = v18.DemonHunter.Havoc;
	local v86 = v19.DemonHunter.Havoc;
	local v87 = v25.DemonHunter.Havoc;
	local v88 = {};
	local v89 = v14:GetEquipment();
	local v90 = (v89[24 - 11] and v19(v89[828 - (98 + 717)])) or v19(826 - (802 + 24));
	local v91 = (v89[23 - 9] and v19(v89[16 - 2])) or v19(0 + 0);
	local v92, v93;
	local v94, v95;
	local v96 = {{v85.FelEruption},{v85.ChaosNova}};
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = false;
	local v102 = false;
	local v103 = ((v85.AFireInside:IsAvailable()) and (16 - 11)) or (1 + 0);
	local v104 = v14:GCD() + 0.25 + 0;
	local v105 = 0 + 0;
	local v106 = false;
	local v107 = 8080 + 3031;
	local v108 = 5188 + 5923;
	local v109 = {(822600 - 653179),(58705 + 110720),(151848 + 17084),(169752 - (192 + 134)),(94287 + 75142),(156604 + 12824),(169981 - (83 + 468))};
	v10:RegisterForEvent(function()
		local v123 = 1806 - (1202 + 604);
		while true do
			if (((19961 - 15685) >= (6513 - 2599)) and (v123 == (2 - 1))) then
				v99 = false;
				v100 = false;
				v123 = 327 - (45 + 280);
			end
			if (((192 + 6) <= (3814 + 551)) and (v123 == (0 + 0))) then
				v97 = false;
				v98 = false;
				v123 = 1 + 0;
			end
			if (((842 + 3940) > (8658 - 3982)) and (v123 == (1913 - (340 + 1571)))) then
				v101 = false;
				v107 = 4383 + 6728;
				v123 = 1775 - (1733 + 39);
			end
			if (((13365 - 8501) > (3231 - (125 + 909))) and (v123 == (1951 - (1096 + 852)))) then
				v108 = 4985 + 6126;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (1 + 0)) or ((4212 - (409 + 103)) == (2743 - (46 + 190)))) then
				v91 = (v89[109 - (51 + 44)] and v19(v89[4 + 10])) or v19(1317 - (1114 + 203));
				break;
			end
			if (((5200 - (228 + 498)) >= (60 + 214)) and (v124 == (0 + 0))) then
				v89 = v14:GetEquipment();
				v90 = (v89[676 - (174 + 489)] and v19(v89[33 - 20])) or v19(1905 - (830 + 1075));
				v124 = 525 - (303 + 221);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v103 = ((v85.AFireInside:IsAvailable()) and (1274 - (231 + 1038))) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v110(v125)
		return v125:DebuffRemains(v85.BurningWoundDebuff) or v125:DebuffRemains(v85.BurningWoundLegDebuff);
	end
	local function v111(v126)
		return v85.BurningWound:IsAvailable() and (v126:DebuffRemains(v85.BurningWoundDebuff) < (1166 - (171 + 991))) and (v85.BurningWoundDebuff:AuraActiveCount() < v29(v94, 12 - 9));
	end
	local function v112()
		v32 = v26.HandleTopTrinket(v88, v35, 107 - 67, nil);
		if (v32 or ((4726 - 2832) <= (1126 + 280))) then
			return v32;
		end
		v32 = v26.HandleBottomTrinket(v88, v35, 140 - 100, nil);
		if (((4534 - 2962) >= (2467 - 936)) and v32) then
			return v32;
		end
	end
	local function v113()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (1248 - (111 + 1137))) or ((4845 - (91 + 67)) < (13518 - 8976))) then
				if (((822 + 2469) > (2190 - (423 + 100))) and v85.Blur:IsCastable() and v65 and (v14:HealthPercentage() <= v67)) then
					if (v24(v85.Blur) or ((7 + 866) == (5631 - 3597))) then
						return "blur defensive";
					end
				end
				if ((v85.Netherwalk:IsCastable() and v66 and (v14:HealthPercentage() <= v68)) or ((1468 + 1348) < (782 - (326 + 445)))) then
					if (((16142 - 12443) < (10483 - 5777)) and v24(v85.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v127 = 2 - 1;
			end
			if (((3357 - (530 + 181)) >= (1757 - (614 + 267))) and (v127 == (33 - (19 + 13)))) then
				if (((999 - 385) <= (7419 - 4235)) and v86.Healthstone:IsReady() and v80 and (v14:HealthPercentage() <= v82)) then
					if (((8929 - 5803) == (812 + 2314)) and v24(v87.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v79 and (v14:HealthPercentage() <= v81)) or ((3846 - 1659) >= (10273 - 5319))) then
					local v182 = 1812 - (1293 + 519);
					while true do
						if (((0 - 0) == v182) or ((10122 - 6245) == (6836 - 3261))) then
							if (((3048 - 2341) > (1488 - 856)) and (v83 == "Refreshing Healing Potion")) then
								if (v86.RefreshingHealingPotion:IsReady() or ((290 + 256) >= (548 + 2136))) then
									if (((3403 - 1938) <= (994 + 3307)) and v24(v87.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((567 + 1137) > (891 + 534)) and (v83 == "Dreamwalker's Healing Potion")) then
								if (v86.DreamwalkersHealingPotion:IsReady() or ((1783 - (709 + 387)) == (6092 - (673 + 1185)))) then
									if (v24(v87.RefreshingHealingPotion) or ((9657 - 6327) < (4588 - 3159))) then
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
	local function v114()
		if (((1886 - 739) >= (240 + 95)) and v85.ImmolationAura:IsCastable() and v49) then
			if (((2567 + 868) > (2831 - 734)) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v50 and not v14:IsMoving() and (v94 > (1 + 0)) and v85.SigilOfFlame:IsCastable()) or ((7517 - 3747) >= (7932 - 3891))) then
			if ((v84 == "player") or v85.ConcentratedSigils:IsAvailable() or ((5671 - (446 + 1434)) <= (2894 - (1040 + 243)))) then
				if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or ((13663 - 9085) <= (3855 - (559 + 1288)))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((3056 - (609 + 1322)) <= (2530 - (13 + 441))) and (v84 == "cursor")) then
				if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(149 - 109)) or ((1946 - 1203) >= (21908 - 17509))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((44 + 1111) < (6075 - 4402)) and not v15:IsInMeleeRange(2 + 3) and v85.Felblade:IsCastable()) then
			if (v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade)) or ((1019 + 1305) <= (1715 - 1137))) then
				return "felblade precombat 9";
			end
		end
		if (((2062 + 1705) == (6928 - 3161)) and not v15:IsInMeleeRange(4 + 1) and v85.FelRush:IsCastable() and (not v85.Felblade:IsAvailable() or (v85.Felblade:CooldownDown() and not v14:PrevGCDP(1 + 0, v85.Felblade))) and v36 and v47) then
			if (((2938 + 1151) == (3434 + 655)) and v24(v85.FelRush, not v15:IsInRange(15 + 0))) then
				return "fel_rush precombat 10";
			end
		end
		if (((4891 - (153 + 280)) >= (4833 - 3159)) and v15:IsInMeleeRange(5 + 0) and v42 and (v85.DemonsBite:IsCastable() or v85.DemonBlades:IsAvailable())) then
			if (((384 + 588) <= (743 + 675)) and v24(v85.DemonsBite, not v15:IsInMeleeRange(5 + 0))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v115()
		if (v14:BuffDown(v85.FelBarrage) or ((3579 + 1359) < (7250 - 2488))) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (667 - (89 + 578))) or ((1789 + 715) > (8864 - 4600))) then
					if (((3202 - (572 + 477)) == (291 + 1862)) and v85.DeathSweep:IsReady() and v41) then
						if (v24(v85.DeathSweep, not v15:IsInRange(v31)) or ((305 + 202) >= (310 + 2281))) then
							return "death_sweep meta_end 2";
						end
					end
					if (((4567 - (84 + 2)) == (7384 - 2903)) and v85.Annihilation:IsReady() and v37) then
						if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or ((1678 + 650) < (1535 - (497 + 345)))) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v128 = 0 + 0;
		local v129;
		while true do
			if (((732 + 3596) == (5661 - (605 + 728))) and (v128 == (1 + 0))) then
				v129 = v26.HandleDPSPotion(v14:BuffUp(v85.MetamorphosisBuff));
				if (((3530 - 1942) >= (62 + 1270)) and v129) then
					return v129;
				end
				v128 = 7 - 5;
			end
			if ((v128 == (2 + 0)) or ((11564 - 7390) > (3208 + 1040))) then
				if ((v57 and not v14:IsMoving() and ((v35 and v60) or not v60) and v85.ElysianDecree:IsCastable() and (v15:DebuffDown(v85.EssenceBreakDebuff)) and (v94 > v64)) or ((5075 - (457 + 32)) <= (35 + 47))) then
					if (((5265 - (832 + 570)) == (3640 + 223)) and (v63 == "player")) then
						if (v24(v87.ElysianDecreePlayer, not v15:IsInRange(v31)) or ((74 + 208) <= (148 - 106))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif (((2221 + 2388) >= (1562 - (588 + 208))) and (v63 == "cursor")) then
						if (v24(v87.ElysianDecreeCursor, not v15:IsInRange(80 - 50)) or ((2952 - (884 + 916)) == (5208 - 2720))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if (((1985 + 1437) > (4003 - (232 + 421))) and (v76 < v108)) then
					if (((2766 - (1569 + 320)) > (93 + 283)) and v77 and ((v35 and v78) or not v78)) then
						local v183 = 0 + 0;
						while true do
							if ((v183 == (0 - 0)) or ((3723 - (316 + 289)) <= (4845 - 2994))) then
								v32 = v112();
								if (v32 or ((8 + 157) >= (4945 - (666 + 787)))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((4374 - (360 + 65)) < (4539 + 317)) and (v128 == (254 - (79 + 175)))) then
				if ((((v35 and v61) or not v61) and v85.Metamorphosis:IsCastable() and v58 and not v85.Demonic:IsAvailable()) or ((6742 - 2466) < (2354 + 662))) then
					if (((14376 - 9686) > (7944 - 3819)) and v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31))) then
						return "metamorphosis cooldown 4";
					end
				end
				if ((((v35 and v61) or not v61) and v85.Metamorphosis:IsCastable() and v58 and v85.Demonic:IsAvailable() and ((not v85.ChaoticTransformation:IsAvailable() and v85.EyeBeam:CooldownDown()) or ((v85.EyeBeam:CooldownRemains() > (919 - (503 + 396))) and (not v97 or v14:PrevGCDP(182 - (92 + 89), v85.DeathSweep) or v14:PrevGCDP(3 - 1, v85.DeathSweep))) or ((v108 < (13 + 12 + (v27(v85.ShatteredDestiny:IsAvailable()) * (42 + 28)))) and v85.EyeBeam:CooldownDown() and v85.BladeDance:CooldownDown())) and v14:BuffDown(v85.InnerDemonBuff)) or ((195 - 145) >= (123 + 773))) then
					if (v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31)) or ((3907 - 2193) >= (2581 + 377))) then
						return "metamorphosis cooldown 6";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v117()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (1 + 7)) or ((2273 - 782) < (1888 - (485 + 759)))) then
				if (((1628 - 924) < (2176 - (442 + 747))) and v85.DemonsBite:IsCastable() and v42) then
					if (((4853 - (832 + 303)) > (2852 - (88 + 858))) and v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite))) then
						return "demons_bite rotation 57";
					end
				end
				if ((v85.FelRush:IsReady() and v36 and v47 and not v85.Momentum:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) <= (7 + 13))) or ((793 + 165) > (150 + 3485))) then
					if (((4290 - (766 + 23)) <= (22175 - 17683)) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 58";
					end
				end
				if ((v85.FelRush:IsReady() and v36 and v47 and not v15:IsInRange(v31) and not v85.Momentum:IsAvailable()) or ((4706 - 1264) < (6713 - 4165))) then
					if (((9757 - 6882) >= (2537 - (1036 + 37))) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				if ((v85.VengefulRetreat:IsCastable() and v36 and v52 and v85.Felblade:CooldownDown() and not v85.Initiative:IsAvailable() and not v15:IsInRange(v31)) or ((3401 + 1396) >= (9528 - 4635))) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or ((434 + 117) > (3548 - (641 + 839)))) then
						return "vengeful_retreat rotation 60";
					end
				end
				v130 = 922 - (910 + 3);
			end
			if (((5389 - 3275) > (2628 - (1466 + 218))) and (v130 == (1 + 1))) then
				if ((v85.DeathSweep:IsCastable() and v41 and v97 and (not v85.EssenceBreak:IsAvailable() or (v85.EssenceBreak:CooldownRemains() > (v104 * (1150 - (556 + 592))))) and v14:BuffDown(v85.FelBarrage)) or ((805 + 1457) >= (3904 - (329 + 479)))) then
					if (v24(v85.DeathSweep, not v15:IsInRange(v31)) or ((3109 - (174 + 680)) >= (12153 - 8616))) then
						return "death_sweep rotation 14";
					end
				end
				if ((v85.TheHunt:IsCastable() and v36 and v59 and (v76 < v108) and ((v35 and v62) or not v62) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v10.CombatTime() < (20 - 10)) or (v85.Metamorphosis:CooldownRemains() > (8 + 2))) and ((v94 == (740 - (396 + 343))) or (v94 > (1 + 2)) or (v108 < (1487 - (29 + 1448)))) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and (not v85.FuriousGaze:IsAvailable() or v14:BuffUp(v85.FuriousGazeBuff) or v14:HasTier(1420 - (135 + 1254), 14 - 10))) or not v14:HasTier(140 - 110, 2 + 0)) and (v10.CombatTime() > (1537 - (389 + 1138)))) or ((4411 - (102 + 472)) < (1233 + 73))) then
					if (((1636 + 1314) == (2751 + 199)) and v24(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if ((v85.FelBarrage:IsCastable() and v45 and ((v94 > (1546 - (320 + 1225))) or ((v94 == (1 - 0)) and (v14:FuryDeficit() < (13 + 7)) and v14:BuffDown(v85.MetamorphosisBuff)))) or ((6187 - (157 + 1307)) < (5157 - (821 + 1038)))) then
					if (((2834 - 1698) >= (17 + 137)) and v24(v85.FelBarrage, not v15:IsInRange(v31))) then
						return "fel_barrage rotation 16";
					end
				end
				if ((v85.GlaiveTempest:IsReady() and v48 and (v15:DebuffDown(v85.EssenceBreakDebuff) or (v94 > (1 - 0))) and v14:BuffDown(v85.FelBarrage)) or ((101 + 170) > (11768 - 7020))) then
					if (((5766 - (834 + 192)) >= (201 + 2951)) and v24(v85.GlaiveTempest, not v15:IsInRange(v31))) then
						return "glaive_tempest rotation 18";
					end
				end
				v130 = 1 + 2;
			end
			if ((v130 == (1 + 6)) or ((3993 - 1415) >= (3694 - (300 + 4)))) then
				if (((11 + 30) <= (4348 - 2687)) and v85.FelRush:IsCastable() and v36 and v47 and not v85.Momentum:IsAvailable() and v85.DemonBlades:IsAvailable() and v85.EyeBeam:CooldownDown() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85.FelRush:Recharge() < v85.EssenceBreak:CooldownRemains()) or not v85.EssenceBreak:IsAvailable())) then
					if (((963 - (112 + 250)) < (1420 + 2140)) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 52";
					end
				end
				if (((588 - 353) < (394 + 293)) and v85.DemonsBite:IsCastable() and v42 and v85.BurningWound:IsAvailable() and (v15:DebuffRemains(v85.BurningWoundDebuff) < (3 + 1))) then
					if (((3403 + 1146) > (572 + 581)) and v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite))) then
						return "demons_bite rotation 54";
					end
				end
				if ((v85.FelRush:IsCastable() and v36 and v47 and not v85.Momentum:IsAvailable() and not v85.DemonBlades:IsAvailable() and (v94 > (1 + 0)) and v14:BuffDown(v85.UnboundChaosBuff)) or ((6088 - (1001 + 413)) < (10418 - 5746))) then
					if (((4550 - (244 + 638)) < (5254 - (627 + 66))) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 56";
					end
				end
				if ((v85.SigilOfFlame:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= (89 - 59)) and v15:IsInRange(632 - (512 + 90))) or ((2361 - (1665 + 241)) == (4322 - (373 + 344)))) then
					if ((v84 == "player") or v85.ConcentratedSigils:IsAvailable() or ((1202 + 1461) == (877 + 2435))) then
						if (((11281 - 7004) <= (7572 - 3097)) and v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif ((v84 == "cursor") or ((1969 - (35 + 1064)) == (866 + 323))) then
						if (((3322 - 1769) <= (13 + 3120)) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(1266 - (298 + 938)))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				v130 = 1267 - (233 + 1026);
			end
			if ((v130 == (1667 - (636 + 1030))) or ((1144 + 1093) >= (3430 + 81))) then
				if ((v85.VengefulRetreat:IsCastable() and v36 and v52 and v85.Felblade:CooldownDown() and v85.Initiative:IsAvailable() and not v85.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and (v14:BuffDown(v85.InitiativeBuff) or (v14:PrevGCDP(1 + 0, v85.DeathSweep) and v85.Metamorphosis:CooldownUp() and v85.ChaoticTransformation:IsAvailable())) and v85.Initiative:IsAvailable()) or ((1545 - (55 + 166)) > (586 + 2434))) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or ((301 + 2691) == (7183 - 5302))) then
						return "vengeful_retreat rotation 8";
					end
				end
				if (((3403 - (36 + 261)) > (2668 - 1142)) and v85.FelRush:IsCastable() and v36 and v47 and v85.Momentum:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) < (v104 * (1370 - (34 + 1334)))) and (v85.EyeBeam:CooldownRemains() <= v104) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85.BladeDance:CooldownDown()) then
					if (((1163 + 1860) < (3007 + 863)) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 10";
					end
				end
				if (((1426 - (1035 + 248)) > (95 - (20 + 1))) and v85.FelRush:IsCastable() and v36 and v47 and v85.Inertia:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or ((v85.EyeBeam:CooldownRemains() > v85.ImmolationAura:Recharge()) and (v85.EyeBeam:CooldownRemains() > (3 + 1)))) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85.BladeDance:CooldownDown()) then
					if (((337 - (134 + 185)) < (3245 - (549 + 584))) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "fel_rush rotation 11";
					end
				end
				if (((1782 - (314 + 371)) <= (5588 - 3960)) and v85.EssenceBreak:IsCastable() and v43 and ((((v14:BuffRemains(v85.MetamorphosisBuff) > (v104 * (971 - (478 + 490)))) or (v85.EyeBeam:CooldownRemains() > (6 + 4))) and (not v85.TacticalRetreat:IsAvailable() or v14:BuffUp(v85.TacticalRetreatBuff) or (v10.CombatTime() < (1182 - (786 + 386)))) and (v85.BladeDance:CooldownRemains() <= ((9.1 - 6) * v104))) or (v108 < (1385 - (1055 + 324))))) then
					if (((5970 - (1093 + 247)) == (4115 + 515)) and v24(v85.EssenceBreak, not v15:IsInRange(v31))) then
						return "essence_break rotation 13";
					end
				end
				v130 = 1 + 1;
			end
			if (((14054 - 10514) > (9105 - 6422)) and (v130 == (0 - 0))) then
				if (((12046 - 7252) >= (1165 + 2110)) and v85.Annihilation:IsCastable() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85.Metamorphosis:CooldownRemains() <= (v14:GCD() * (11 - 8)))) then
					if (((5114 - 3630) == (1119 + 365)) and v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation))) then
						return "annihilation rotation 2";
					end
				end
				if (((3661 - 2229) < (4243 - (364 + 324))) and v85.VengefulRetreat:IsCastable() and v36 and v52 and v85.Felblade:CooldownDown() and (v85.EyeBeam:CooldownRemains() < (0.3 - 0)) and (v85.EssenceBreak:CooldownRemains() < (v104 * (4 - 2))) and (v10.CombatTime() > (2 + 3)) and (v14:Fury() >= (125 - 95)) and v85.Inertia:IsAvailable()) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or ((1705 - 640) > (10866 - 7288))) then
						return "vengeful_retreat rotation 3";
					end
				end
				if ((v85.VengefulRetreat:IsCastable() and v36 and v52 and v85.Felblade:CooldownDown() and v85.Initiative:IsAvailable() and v85.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1269 - (1249 + 19))) and ((v85.EssenceBreak:CooldownRemains() > (14 + 1)) or ((v85.EssenceBreak:CooldownRemains() < v104) and (not v85.Demonic:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85.EyeBeam:CooldownRemains() > ((58 - 43) + ((1096 - (686 + 400)) * v27(v85.CycleOfHatred:IsAvailable()))))))) and ((v10.CombatTime() < (24 + 6)) or ((v14:GCDRemains() - (230 - (73 + 156))) < (0 + 0))) and (not v85.Initiative:IsAvailable() or (v14:BuffRemains(v85.InitiativeBuff) < v104) or (v10.CombatTime() > (815 - (721 + 90))))) or ((54 + 4741) < (4568 - 3161))) then
					if (((2323 - (224 + 246)) < (7796 - 2983)) and v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true)) then
						return "vengeful_retreat rotation 4";
					end
				end
				if ((v85.VengefulRetreat:IsCastable() and v36 and v52 and v85.Felblade:CooldownDown() and v85.Initiative:IsAvailable() and v85.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 - 0)) and ((v85.EssenceBreak:CooldownRemains() > (3 + 12)) or ((v85.EssenceBreak:CooldownRemains() < (v104 * (1 + 1))) and (((v14:BuffRemains(v85.InitiativeBuff) < v104) and not v102 and (v85.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > (23 + 7))) or not v85.Demonic:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85.EyeBeam:CooldownRemains() > ((29 - 14) + ((33 - 23) * v27(v85.CycleofHatred:IsAvailable()))))))) and (v14:BuffDown(v85.UnboundChaosBuff) or v14:BuffUp(v85.InertiaBuff))) or ((3334 - (203 + 310)) < (4424 - (1238 + 755)))) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or ((201 + 2673) < (3715 - (709 + 825)))) then
						return "vengeful_retreat rotation 6";
					end
				end
				v130 = 1 - 0;
			end
			if ((v130 == (12 - 3)) or ((3553 - (196 + 668)) <= (1354 - 1011))) then
				if ((v85.ThrowGlaive:IsCastable() and v51 and not v14:PrevGCDP(1 - 0, v85.VengefulRetreat) and not v14:IsMoving() and (v85.DemonBlades:IsAvailable() or not v15:IsInRange(845 - (171 + 662))) and v15:DebuffDown(v85.EssenceBreakDebuff) and v15:IsSpellInRange(v85.ThrowGlaive) and not v14:HasTier(124 - (4 + 89), 6 - 4)) or ((681 + 1188) == (8823 - 6814))) then
					if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((1391 + 2155) < (3808 - (35 + 1451)))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if (((1457 - (28 + 1425)) == v130) or ((4075 - (941 + 1052)) == (4577 + 196))) then
				if (((4758 - (822 + 692)) > (1505 - 450)) and v85.SigilOfFlame:IsCastable() and not v14:IsMoving() and v50 and v85.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff) and (v94 >= (2 + 2))) then
					if ((v84 == "player") or v85.ConcentratedSigils:IsAvailable() or ((3610 - (45 + 252)) <= (1760 + 18))) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or ((490 + 931) >= (5120 - 3016))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif (((2245 - (114 + 319)) <= (4664 - 1415)) and (v84 == "cursor")) then
						if (((2079 - 456) <= (1248 + 709)) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(59 - 19))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				if (((9244 - 4832) == (6375 - (556 + 1407))) and v85.ThrowGlaive:IsCastable() and v51 and not v14:PrevGCDP(1207 - (741 + 465), v85.VengefulRetreat) and not v14:IsMoving() and v85.Soulscar:IsAvailable() and (v94 >= ((467 - (170 + 295)) - v27(v85.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85.ThrowGlaive:FullRechargeTime() < (v104 * (2 + 1))) or (v94 > (1 + 0))) and not v14:HasTier(76 - 45, 2 + 0)) then
					if (((1123 + 627) >= (477 + 365)) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "throw_glaive rotation 32";
					end
				end
				if (((5602 - (957 + 273)) > (495 + 1355)) and v85.ImmolationAura:IsCastable() and v49 and (v94 >= (1 + 1)) and (v14:Fury() < (266 - 196)) and v15:DebuffDown(v85.EssenceBreakDebuff)) then
					if (((611 - 379) < (2507 - 1686)) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
						return "immolation_aura rotation 34";
					end
				end
				if (((2564 - 2046) < (2682 - (389 + 1391))) and ((v85.Annihilation:IsCastable() and v37 and not v98 and ((v85.EssenceBreak:CooldownRemains() > (0 + 0)) or not v85.EssenceBreak:IsAvailable()) and v14:BuffDown(v85.FelBarrage)) or v14:HasTier(4 + 26, 4 - 2))) then
					if (((3945 - (783 + 168)) > (2879 - 2021)) and v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation))) then
						return "annihilation rotation 36";
					end
				end
				v130 = 5 + 0;
			end
			if ((v130 == (317 - (309 + 2))) or ((11531 - 7776) <= (2127 - (1090 + 122)))) then
				if (((1280 + 2666) > (12570 - 8827)) and v85.ThrowGlaive:IsReady() and v51 and not v14:PrevGCDP(1 + 0, v85.VengefulRetreat) and not v14:IsMoving() and v85.Soulscar:IsAvailable() and (v85.ThrowGlaive:FullRechargeTime() < v85.BladeDance:CooldownRemains()) and v14:HasTier(1149 - (628 + 490), 1 + 1) and v14:BuffDown(v85.FelBarrage) and not v99) then
					if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((3305 - 1970) >= (15108 - 11802))) then
						return "throw_glaive rotation 44";
					end
				end
				if (((5618 - (431 + 343)) > (4550 - 2297)) and v85.ChaosStrike:IsReady() and v39 and not v98 and not v99 and v14:BuffDown(v85.FelBarrage)) then
					if (((1307 - 855) == (358 + 94)) and v24(v85.ChaosStrike, not v15:IsSpellInRange(v85.ChaosStrike))) then
						return "chaos_strike rotation 46";
					end
				end
				if ((v85.SigilOfFlame:IsCastable() and not v14:IsMoving() and v50 and (v14:FuryDeficit() >= (4 + 26))) or ((6252 - (556 + 1139)) < (2102 - (6 + 9)))) then
					if (((710 + 3164) == (1985 + 1889)) and ((v84 == "player") or v85.ConcentratedSigils:IsAvailable())) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or ((2107 - (28 + 141)) > (1912 + 3023))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif ((v84 == "cursor") or ((5252 - 997) < (2425 + 998))) then
						if (((2771 - (486 + 831)) <= (6482 - 3991)) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(105 - 75))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				if ((v85.Felblade:IsCastable() and v46 and (v14:FuryDeficit() >= (8 + 32)) and not v14:PrevGCDP(3 - 2, v85.VengefulRetreat)) or ((5420 - (668 + 595)) <= (2523 + 280))) then
					if (((979 + 3874) >= (8132 - 5150)) and v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade))) then
						return "felblade rotation 50";
					end
				end
				v130 = 297 - (23 + 267);
			end
			if (((6078 - (1129 + 815)) > (3744 - (371 + 16))) and (v130 == (1755 - (1326 + 424)))) then
				if ((v85.Felblade:IsCastable() and v46 and not v14:PrevGCDP(1 - 0, v85.VengefulRetreat) and (((v14:FuryDeficit() >= (146 - 106)) and v85.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v85.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)))) or ((3535 - (88 + 30)) < (3305 - (720 + 51)))) then
					if (v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade)) or ((6054 - 3332) <= (1940 - (421 + 1355)))) then
						return "felblade rotation 38";
					end
				end
				if ((v85.SigilOfFlame:IsCastable() and not v14:IsMoving() and v50 and v85.AnyMeansNecessary:IsAvailable() and (v14:FuryDeficit() >= (49 - 19))) or ((1183 + 1225) < (3192 - (286 + 797)))) then
					if ((v84 == "player") or v85.ConcentratedSigils:IsAvailable() or ((120 - 87) == (2409 - 954))) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or ((882 - (397 + 42)) >= (1254 + 2761))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif (((4182 - (24 + 776)) > (255 - 89)) and (v84 == "cursor")) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(825 - (222 + 563))) or ((616 - 336) == (2203 + 856))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				if (((2071 - (23 + 167)) > (3091 - (690 + 1108))) and v85.ThrowGlaive:IsReady() and v51 and not v14:PrevGCDP(1 + 0, v85.VengefulRetreat) and not v14:IsMoving() and v85.Soulscar:IsAvailable() and (v95 >= ((2 + 0) - v27(v85.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and not v14:HasTier(879 - (40 + 808), 1 + 1)) then
					if (((9013 - 6656) == (2253 + 104)) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return "throw_glaive rotation 40";
					end
				end
				if (((66 + 57) == (68 + 55)) and v85.ImmolationAura:IsCastable() and v49 and (v14:BuffStack(v85.ImmolationAuraBuff) < v103) and v15:IsInRange(579 - (47 + 524)) and (v14:BuffDown(v85.UnboundChaosBuff) or not v85.UnboundChaos:IsAvailable()) and ((v85.ImmolationAura:Recharge() < v85.EssenceBreak:CooldownRemains()) or (not v85.EssenceBreak:IsAvailable() and (v85.EyeBeam:CooldownRemains() > v85.ImmolationAura:Recharge())))) then
					if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or ((686 + 370) >= (9272 - 5880))) then
						return "immolation_aura rotation 42";
					end
				end
				v130 = 8 - 2;
			end
			if (((6 - 3) == v130) or ((2807 - (1165 + 561)) < (32 + 1043))) then
				if ((v85.Annihilation:IsReady() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85.EyeBeam:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v85.FelBarrage)) or ((3248 - 2199) >= (1692 + 2740))) then
					if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or ((5247 - (341 + 138)) <= (229 + 617))) then
						return "annihilation rotation 20";
					end
				end
				if ((v85.FelRush:IsReady() and v36 and v47 and v85.Momentum:IsAvailable() and (v85.EyeBeam:CooldownRemains() < (v104 * (5 - 2))) and (v14:BuffRemains(v85.MomentumBuff) < (331 - (89 + 237))) and v14:BuffDown(v85.MetamorphosisBuff)) or ((10802 - 7444) <= (2989 - 1569))) then
					if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((4620 - (581 + 300)) <= (4225 - (855 + 365)))) then
						return "fel_rush rotation 22";
					end
				end
				if ((v85.EyeBeam:IsCastable() and v44 and not v14:PrevGCDP(2 - 1, v85.VengefulRetreat) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85.Metamorphosis:CooldownRemains() > ((10 + 20) - (v27(v85.CycleOfHatred:IsAvailable()) * (1250 - (1030 + 205))))) or ((v85.Metamorphosis:CooldownRemains() < (v104 * (2 + 0))) and (not v85.EssenceBreak:IsAvailable() or (v85.EssenceBreak:CooldownRemains() < (v104 * (1.5 + 0)))))) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > v104) or not v85.RestlessHunter:IsAvailable()) and (v85.CycleOfHatred:IsAvailable() or not v85.Initiative:IsAvailable() or (v85.VengefulRetreat:CooldownRemains() > (291 - (156 + 130))) or not v52 or (v10.CombatTime() < (22 - 12))) and v14:BuffDown(v85.InnerDemonBuff)) or (v108 < (25 - 10)))) or ((3397 - 1738) >= (563 + 1571))) then
					if (v24(v85.EyeBeam, not v15:IsInRange(v31)) or ((1901 + 1359) < (2424 - (10 + 59)))) then
						return "eye_beam rotation 26";
					end
				end
				if ((v85.BladeDance:IsCastable() and v38 and v97 and ((v85.EyeBeam:CooldownRemains() > (2 + 3)) or not v85.Demonic:IsAvailable() or v14:HasTier(152 - 121, 1165 - (671 + 492)))) or ((533 + 136) == (5438 - (369 + 846)))) then
					if (v24(v85.BladeDance, not v15:IsInRange(v31)) or ((448 + 1244) < (502 + 86))) then
						return "blade_dance rotation 28";
					end
				end
				v130 = 1949 - (1036 + 909);
			end
		end
	end
	local function v118()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (11 - 4)) or ((5000 - (11 + 192)) < (1846 + 1805))) then
				v62 = EpicSettings.Settings['theHuntWithCD'];
				v63 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v64 = EpicSettings.Settings['elysianDecreeSlider'] or (175 - (135 + 40));
				break;
			end
			if ((v131 == (2 - 1)) or ((2518 + 1659) > (10684 - 5834))) then
				v40 = EpicSettings.Settings['useConsumeMagic'];
				v41 = EpicSettings.Settings['useDeathSweep'];
				v42 = EpicSettings.Settings['useDemonsBite'];
				v131 = 2 - 0;
			end
			if ((v131 == (176 - (50 + 126))) or ((1113 - 713) > (246 + 865))) then
				v37 = EpicSettings.Settings['useAnnihilation'];
				v38 = EpicSettings.Settings['useBladeDance'];
				v39 = EpicSettings.Settings['useChaosStrike'];
				v131 = 1414 - (1233 + 180);
			end
			if (((4020 - (522 + 447)) > (2426 - (107 + 1314))) and (v131 == (3 + 2))) then
				v52 = EpicSettings.Settings['useVengefulRetreat'];
				v57 = EpicSettings.Settings['useElysianDecree'];
				v58 = EpicSettings.Settings['useMetamorphosis'];
				v131 = 18 - 12;
			end
			if (((1569 + 2124) <= (8701 - 4319)) and (v131 == (11 - 8))) then
				v46 = EpicSettings.Settings['useFelblade'];
				v47 = EpicSettings.Settings['useFelRush'];
				v48 = EpicSettings.Settings['useGlaiveTempest'];
				v131 = 1914 - (716 + 1194);
			end
			if ((v131 == (1 + 1)) or ((352 + 2930) > (4603 - (74 + 429)))) then
				v43 = EpicSettings.Settings['useEssenceBreak'];
				v44 = EpicSettings.Settings['useEyeBeam'];
				v45 = EpicSettings.Settings['useFelBarrage'];
				v131 = 5 - 2;
			end
			if ((v131 == (2 + 2)) or ((8194 - 4614) < (2013 + 831))) then
				v49 = EpicSettings.Settings['useImmolationAura'];
				v50 = EpicSettings.Settings['useSigilOfFlame'];
				v51 = EpicSettings.Settings['useThrowGlaive'];
				v131 = 15 - 10;
			end
			if (((219 - 130) < (4923 - (279 + 154))) and (v131 == (784 - (454 + 324)))) then
				v59 = EpicSettings.Settings['useTheHunt'];
				v60 = EpicSettings.Settings['elysianDecreeWithCD'];
				v61 = EpicSettings.Settings['metamorphosisWithCD'];
				v131 = 6 + 1;
			end
		end
	end
	local function v119()
		local v132 = 17 - (12 + 5);
		while true do
			if ((v132 == (2 + 0)) or ((12696 - 7713) < (669 + 1139))) then
				v65 = EpicSettings.Settings['useBlur'];
				v66 = EpicSettings.Settings['useNetherwalk'];
				v132 = 1096 - (277 + 816);
			end
			if (((16361 - 12532) > (4952 - (1058 + 125))) and (v132 == (1 + 2))) then
				v67 = EpicSettings.Settings['blurHP'] or (975 - (815 + 160));
				v68 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
				v132 = 9 - 5;
			end
			if (((355 + 1130) <= (8488 - 5584)) and (v132 == (1899 - (41 + 1857)))) then
				v55 = EpicSettings.Settings['useFelEruption'];
				v56 = EpicSettings.Settings['useSigilOfMisery'];
				v132 = 1895 - (1222 + 671);
			end
			if (((11033 - 6764) == (6135 - 1866)) and (v132 == (1186 - (229 + 953)))) then
				v84 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
			if (((2161 - (1111 + 663)) <= (4361 - (874 + 705))) and (v132 == (0 + 0))) then
				v53 = EpicSettings.Settings['useChaosNova'];
				v54 = EpicSettings.Settings['useDisrupt'];
				v132 = 1 + 0;
			end
		end
	end
	local function v120()
		v76 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v69 = EpicSettings.Settings['dispelBuffs'];
		v73 = EpicSettings.Settings['InterruptWithStun'];
		v74 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v75 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['useTrinkets'];
		v78 = EpicSettings.Settings['trinketsWithCD'];
		v80 = EpicSettings.Settings['useHealthstone'];
		v79 = EpicSettings.Settings['useHealingPotion'];
		v82 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v81 = EpicSettings.Settings['healingPotionHP'] or (679 - (642 + 37));
		v83 = EpicSettings.Settings['HealingPotionName'] or "";
		v72 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v121()
		v119();
		v118();
		v120();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['movement'];
		if (v14:IsDeadOrGhost() or ((433 + 1466) <= (147 + 770))) then
			return;
		end
		if (v85.ImprovedDisrupt:IsAvailable() or ((10826 - 6514) <= (1330 - (233 + 221)))) then
			v31 = 23 - 13;
		end
		v92 = v14:GetEnemiesInMeleeRange(v31);
		v93 = v14:GetEnemiesInMeleeRange(18 + 2);
		if (((3773 - (718 + 823)) <= (1634 + 962)) and v34) then
			v94 = ((#v92 > (805 - (266 + 539))) and #v92) or (2 - 1);
			v95 = #v93;
		else
			local v149 = 1225 - (636 + 589);
			while true do
				if (((4973 - 2878) < (7602 - 3916)) and ((0 + 0) == v149)) then
					v94 = 1 + 0;
					v95 = 1016 - (657 + 358);
					break;
				end
			end
		end
		v104 = v14:GCD() + (0.05 - 0);
		if (v26.TargetIsValid() or v14:AffectingCombat() or ((3633 - 2038) >= (5661 - (1151 + 36)))) then
			local v150 = 0 + 0;
			while true do
				if ((v150 == (0 + 0)) or ((13794 - 9175) < (4714 - (1552 + 280)))) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					v150 = 835 - (64 + 770);
				end
				if ((v150 == (1 + 0)) or ((667 - 373) >= (858 + 3973))) then
					if (((3272 - (157 + 1086)) <= (6172 - 3088)) and (v108 == (48663 - 37552))) then
						v108 = v10.FightRemains(Enemies8y, false);
					end
					break;
				end
			end
		end
		v32 = v113();
		if (v32 or ((3124 - 1087) == (3303 - 883))) then
			return v32;
		end
		if (((5277 - (599 + 220)) > (7774 - 3870)) and v72) then
			local v151 = 1931 - (1813 + 118);
			while true do
				if (((319 + 117) >= (1340 - (841 + 376))) and (v151 == (0 - 0))) then
					v32 = v26.HandleIncorporeal(v85.Imprison, v87.ImprisonMouseover, 7 + 23, true);
					if (((1364 - 864) < (2675 - (464 + 395))) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if (((9172 - 5598) == (1717 + 1857)) and v26.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
			local v152 = 837 - (467 + 370);
			local v153;
			while true do
				if (((456 - 235) < (287 + 103)) and ((6 - 4) == v152)) then
					v98 = v97 and (v14:Fury() < ((12 + 63) - (v27(v85.DemonBlades:IsAvailable()) * (46 - 26)))) and (v85.BladeDance:CooldownRemains() < v104);
					v99 = v85.Demonic:IsAvailable() and not v85.BlindFury:IsAvailable() and (v85.EyeBeam:CooldownRemains() < (v104 * (522 - (150 + 370)))) and (v14:FuryDeficit() > (1312 - (74 + 1208)));
					v101 = (v85.Momentum:IsAvailable() and v14:BuffDown(v85.MomentumBuff)) or (v85.Inertia:IsAvailable() and v14:BuffDown(v85.InertiaBuff));
					v152 = 7 - 4;
				end
				if ((v152 == (0 - 0)) or ((1575 + 638) <= (1811 - (14 + 376)))) then
					if (((5303 - 2245) < (3145 + 1715)) and not v14:AffectingCombat()) then
						local v184 = 0 + 0;
						while true do
							if ((v184 == (0 + 0)) or ((3797 - 2501) >= (3345 + 1101))) then
								v32 = v114();
								if (v32 or ((1471 - (23 + 55)) > (10638 - 6149))) then
									return v32;
								end
								break;
							end
						end
					end
					if ((v85.ConsumeMagic:IsAvailable() and v40 and v85.ConsumeMagic:IsReady() and v69 and not v14:IsCasting() and not v14:IsChanneling() and v26.UnitHasMagicBuff(v15)) or ((2953 + 1471) < (25 + 2))) then
						if (v24(v85.ConsumeMagic, not v15:IsSpellInRange(v85.ConsumeMagic)) or ((3096 - 1099) > (1201 + 2614))) then
							return "greater_purge damage";
						end
					end
					if (((4366 - (652 + 249)) > (5119 - 3206)) and v85.FelRush:IsReady() and v36 and v47 and not v15:IsInRange(v31)) then
						if (((2601 - (708 + 1160)) < (4937 - 3118)) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
							return "fel_rush rotation when OOR";
						end
					end
					v152 = 1 - 0;
				end
				if ((v152 == (34 - (10 + 17))) or ((988 + 3407) == (6487 - (1400 + 332)))) then
					if ((v14:BuffUp(v85.MetamorphosisBuff) and (v14:BuffRemains(v85.MetamorphosisBuff) < v104) and (v94 < (5 - 2))) or ((5701 - (242 + 1666)) < (1014 + 1355))) then
						local v185 = 0 + 0;
						while true do
							if ((v185 == (0 + 0)) or ((5024 - (850 + 90)) == (463 - 198))) then
								v32 = v115();
								if (((5748 - (360 + 1030)) == (3857 + 501)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					v32 = v117();
					if (v32 or ((8856 - 5718) < (1365 - 372))) then
						return v32;
					end
					v152 = 1669 - (909 + 752);
				end
				if (((4553 - (109 + 1114)) > (4252 - 1929)) and (v152 == (2 + 2))) then
					if ((v85.ImmolationAura:IsCastable() and v49 and v85.AFireInside:IsAvailable() and v85.Inertia:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and (v85.ImmolationAura:FullRechargeTime() < (v104 * (244 - (6 + 236)))) and v15:DebuffDown(v85.EssenceBreakDebuff)) or ((2285 + 1341) == (3211 + 778))) then
						if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or ((2160 - 1244) == (4665 - 1994))) then
							return "immolation_aura main 3";
						end
					end
					if (((1405 - (1076 + 57)) == (45 + 227)) and v85.FelRush:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and (((v85.ImmolationAura:Charges() == (691 - (579 + 110))) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v14:PrevGCDP(1 + 0, v85.EyeBeam) and v14:BuffUp(v85.InertiaBuff) and (v14:BuffRemains(v85.InertiaBuff) < (3 + 0))))) then
						if (((2256 + 1993) <= (5246 - (174 + 233))) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
							return "fel_rush main 4";
						end
					end
					if (((7756 - 4979) < (5616 - 2416)) and v85.TheHunt:IsCastable() and (v10.CombatTime() < (5 + 5)) and (not v85.Inertia:IsAvailable() or (v14:BuffUp(v85.MetamorphosisBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)))) then
						if (((1269 - (663 + 511)) < (1746 + 211)) and v22(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt))) then
							return "the_hunt main 6";
						end
					end
					v152 = 2 + 3;
				end
				if (((2546 - 1720) < (1040 + 677)) and (v152 == (6 - 3))) then
					v153 = v30(v85.EyeBeam:BaseDuration(), v14:GCD());
					v102 = v85.Demonic:IsAvailable() and v85.EssenceBreak:IsAvailable() and Var3MinTrinket and (v108 > (v85.Metamorphosis:CooldownRemains() + (72 - 42) + (v27(v85.ShatteredDestiny:IsAvailable()) * (29 + 31)))) and (v85.Metamorphosis:CooldownRemains() < (38 - 18)) and (v85.Metamorphosis:CooldownRemains() > (v153 + (v104 * (v27(v85.InnerDemon:IsAvailable()) + 2 + 0))));
					if (((131 + 1295) >= (1827 - (478 + 244))) and v85.ImmolationAura:IsCastable() and v49 and v85.Ragefire:IsAvailable() and (v94 >= (520 - (440 + 77))) and (v85.BladeDance:CooldownDown() or v15:DebuffDown(v85.EssenceBreakDebuff))) then
						if (((1253 + 1501) <= (12367 - 8988)) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
							return "immolation_aura main 2";
						end
					end
					v152 = 1560 - (655 + 901);
				end
				if ((v152 == (1 + 0)) or ((3007 + 920) == (955 + 458))) then
					if ((v85.ThrowGlaive:IsReady() and v51 and v13.ValueIsInArray(v109, v15:NPCID())) or ((4648 - 3494) <= (2233 - (695 + 750)))) then
						if (v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((5610 - 3967) > (5214 - 1835))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v85.ThrowGlaive:IsReady() and v51 and v13.ValueIsInArray(v109, v16:NPCID())) or ((11272 - 8469) > (4900 - (285 + 66)))) then
						if (v24(v87.ThrowGlaiveMouseover, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((512 - 292) >= (4332 - (682 + 628)))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v97 = v85.FirstBlood:IsAvailable() or v85.TrailofRuin:IsAvailable() or (v85.ChaosTheory:IsAvailable() and v14:BuffDown(v85.ChaosTheoryBuff)) or (v94 > (1 + 0));
					v152 = 301 - (176 + 123);
				end
				if (((1181 + 1641) == (2048 + 774)) and (v152 == (275 - (239 + 30)))) then
					if ((v85.FelRush:IsCastable() and v36 and v47 and v85.Inertia:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and ((v85.EyeBeam:CooldownRemains() + 1 + 2) > v14:BuffRemains(v85.UnboundChaosBuff)) and (v85.BladeDance:CooldownDown() or v85.EssenceBreak:CooldownUp())) or ((1020 + 41) == (3286 - 1429))) then
						if (((8610 - 5850) > (1679 - (306 + 9))) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
							return "fel_rush main 9";
						end
					end
					if ((v85.FelRush:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and v85.Inertia:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or (v85.EssenceBreak:CooldownRemains() > (34 - 24)))) or ((853 + 4049) <= (2206 + 1389))) then
						if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((1855 + 1997) == (837 - 544))) then
							return "fel_rush main 10";
						end
					end
					if (((v76 < v108) and v35) or ((2934 - (1140 + 235)) == (2920 + 1668))) then
						local v186 = 0 + 0;
						while true do
							if ((v186 == (0 + 0)) or ((4536 - (33 + 19)) == (285 + 503))) then
								v32 = v116();
								if (((13691 - 9123) >= (1722 + 2185)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					v152 = 13 - 6;
				end
				if (((1169 + 77) < (4159 - (586 + 103))) and (v152 == (1 + 4))) then
					if (((12523 - 8455) >= (2460 - (1309 + 179))) and v85.ImmolationAura:IsCastable() and v49 and v85.Inertia:IsAvailable() and ((v85.EyeBeam:CooldownRemains() < (v104 * (2 - 0))) or v14:BuffUp(v85.MetamorphosisBuff)) and (v85.EssenceBreak:CooldownRemains() < (v104 * (2 + 1))) and v14:BuffDown(v85.UnboundChaosBuff) and v14:BuffDown(v85.InertiaBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)) then
						if (((1323 - 830) < (2941 + 952)) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
							return "immolation_aura main 5";
						end
					end
					if ((v85.ImmolationAura:IsCastable() and v49 and v85.Inertia:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85.ImmolationAura:FullRechargeTime() < v85.EssenceBreak:CooldownRemains()) or not v85.EssenceBreak:IsAvailable()) and v15:DebuffDown(v85.EssenceBreakDebuff) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > (12 - 6))) and v85.BladeDance:CooldownDown() and ((v14:Fury() < (149 - 74)) or (v85.BladeDance:CooldownRemains() < (v104 * (611 - (295 + 314)))))) or ((3617 - 2144) >= (5294 - (1300 + 662)))) then
						if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or ((12720 - 8669) <= (2912 - (1178 + 577)))) then
							return "immolation_aura main 6";
						end
					end
					if (((314 + 290) < (8516 - 5635)) and v85.FelRush:IsCastable() and v36 and v47 and ((v14:BuffRemains(v85.UnboundChaosBuff) < (v104 * (1407 - (851 + 554)))) or (v15:TimeToDie() < (v104 * (2 + 0))))) then
						if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or ((2496 - 1596) == (7333 - 3956))) then
							return "fel_rush main 8";
						end
					end
					v152 = 308 - (115 + 187);
				end
				if (((3415 + 1044) > (560 + 31)) and (v152 == (31 - 23))) then
					if (((4559 - (160 + 1001)) >= (2096 + 299)) and (v85.DemonBlades:IsAvailable())) then
						if (v24(v85.Pool) or ((1507 + 676) >= (5780 - 2956))) then
							return "pool demon_blades";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v146 = 358 - (237 + 121);
		while true do
			if (((2833 - (525 + 372)) == (3669 - 1733)) and (v146 == (0 - 0))) then
				v85.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(719 - (96 + 46), v121, v122);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

