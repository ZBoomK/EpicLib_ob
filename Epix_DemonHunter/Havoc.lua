local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1061 - (346 + 715);
	local v6;
	while true do
		if (((5415 - 2253) == (4318 - (1074 + 82))) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if ((v5 == (1784 - (214 + 1570))) or ((3824 - (990 + 465)) > (1826 + 2603))) then
			v6 = v0[v4];
			if (((1782 + 2313) >= (3096 + 87)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
	local v21 = v20.Press;
	local v22 = v20.Macro;
	local v23 = v20.Commons.Everyone;
	local v24 = v23.num;
	local v25 = v23.bool;
	local v26 = math.min;
	local v27 = math.max;
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
	local v79 = v18.DemonHunter.Havoc;
	local v80 = v19.DemonHunter.Havoc;
	local v81 = v22.DemonHunter.Havoc;
	local v82 = {};
	local v83 = v14:GetEquipment();
	local v84 = (v83[1739 - (1668 + 58)] and v19(v83[639 - (512 + 114)])) or v19(0 - 0);
	local v85 = (v83[28 - 14] and v19(v83[48 - 34])) or v19(0 + 0);
	local v86, v87;
	local v88, v89;
	local v90 = {{v79.FelEruption},{v79.ChaosNova}};
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = false;
	local v97 = ((v79.AFireInside:IsAvailable()) and (1474 - (1269 + 200))) or (1 - 0);
	local v98 = v14:GCD() + (815.25 - (98 + 717));
	local v99 = 826 - (802 + 24);
	local v100 = false;
	local v101 = 19160 - 8049;
	local v102 = 14032 - 2921;
	local v103 = {(130170 + 39251),(36547 + 132878),(563347 - 394415),(68967 + 100459),(123198 + 46231),(170861 - (797 + 636)),(171049 - (1427 + 192))};
	v10:RegisterForEvent(function()
		local v117 = 0 + 0;
		while true do
			if ((v117 == (6 - 3)) or ((3336 + 375) < (457 + 551))) then
				v102 = 11437 - (192 + 134);
				break;
			end
			if ((v117 == (1276 - (316 + 960))) or ((584 + 465) <= (700 + 206))) then
				v91 = false;
				v92 = false;
				v117 = 1 + 0;
			end
			if (((17252 - 12739) > (3277 - (83 + 468))) and (v117 == (1808 - (1202 + 604)))) then
				v95 = false;
				v101 = 51868 - 40757;
				v117 = 4 - 1;
			end
			if ((v117 == (2 - 1)) or ((1806 - (45 + 280)) >= (2566 + 92))) then
				v93 = false;
				v94 = false;
				v117 = 2 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v118 = 0 + 0;
		while true do
			if ((v118 == (0 + 0)) or ((567 + 2653) == (2525 - 1161))) then
				v83 = v14:GetEquipment();
				v84 = (v83[1924 - (340 + 1571)] and v19(v83[6 + 7])) or v19(1772 - (1733 + 39));
				v118 = 2 - 1;
			end
			if ((v118 == (1035 - (125 + 909))) or ((3002 - (1096 + 852)) > (1522 + 1870))) then
				v85 = (v83[19 - 5] and v19(v83[14 + 0])) or v19(512 - (409 + 103));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v97 = ((v79.AFireInside:IsAvailable()) and (241 - (46 + 190))) or (96 - (51 + 44));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v104(v119)
		return v119:DebuffRemains(v79.BurningWoundDebuff) or v119:DebuffRemains(v79.BurningWoundLegDebuff);
	end
	local function v105(v120)
		return v79.BurningWound:IsAvailable() and (v120:DebuffRemains(v79.BurningWoundDebuff) < (2 + 2)) and (v79.BurningWoundDebuff:AuraActiveCount() < v26(v88, 1320 - (1114 + 203)));
	end
	local function v106()
		local v121 = 726 - (228 + 498);
		while true do
			if ((v121 == (0 + 0)) or ((374 + 302) >= (2305 - (174 + 489)))) then
				v28 = v23.HandleTopTrinket(v82, v31, 104 - 64, nil);
				if (((6041 - (830 + 1075)) > (2921 - (303 + 221))) and v28) then
					return v28;
				end
				v121 = 1270 - (231 + 1038);
			end
			if (((1 + 0) == v121) or ((5496 - (171 + 991)) == (17494 - 13249))) then
				v28 = v23.HandleBottomTrinket(v82, v31, 107 - 67, nil);
				if (v28 or ((10670 - 6394) <= (2426 + 605))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v107()
		local v122 = 0 - 0;
		while true do
			if ((v122 == (2 - 1)) or ((7707 - 2925) <= (3706 - 2507))) then
				if ((v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) or ((6112 - (111 + 1137)) < (2060 - (91 + 67)))) then
					if (((14402 - 9563) >= (924 + 2776)) and v21(v81.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v73 and (v14:HealthPercentage() <= v75)) or ((1598 - (423 + 100)) > (14 + 1904))) then
					local v175 = 0 - 0;
					while true do
						if (((207 + 189) <= (4575 - (326 + 445))) and (v175 == (0 - 0))) then
							if ((v77 == "Refreshing Healing Potion") or ((9287 - 5118) == (5104 - 2917))) then
								if (((2117 - (530 + 181)) == (2287 - (614 + 267))) and v80.RefreshingHealingPotion:IsReady()) then
									if (((1563 - (19 + 13)) < (6951 - 2680)) and v21(v81.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((1479 - 844) == (1813 - 1178)) and (v77 == "Dreamwalker's Healing Potion")) then
								if (((876 + 2497) <= (6253 - 2697)) and v80.DreamwalkersHealingPotion:IsReady()) then
									if (v21(v81.RefreshingHealingPotion) or ((6824 - 3533) < (5092 - (1293 + 519)))) then
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
			if (((8948 - 4562) >= (2278 - 1405)) and (v122 == (0 - 0))) then
				if (((3971 - 3050) <= (2595 - 1493)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
					if (((2493 + 2213) >= (197 + 766)) and v21(v79.Blur)) then
						return "blur defensive";
					end
				end
				if ((v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((2230 - 1270) <= (203 + 673))) then
					if (v21(v79.Netherwalk) or ((687 + 1379) == (583 + 349))) then
						return "netherwalk defensive";
					end
				end
				v122 = 1097 - (709 + 387);
			end
		end
	end
	local function v108()
		local v123 = 1858 - (673 + 1185);
		while true do
			if (((13993 - 9168) < (15551 - 10708)) and (v123 == (1 - 0))) then
				if ((not v15:IsInMeleeRange(4 + 1) and v79.Felblade:IsCastable()) or ((2897 + 980) >= (6125 - 1588))) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1060 + 3255) < (3441 - 1715))) then
						return "felblade precombat 9";
					end
				end
				if ((not v15:IsInMeleeRange(9 - 4) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownDown() and not v14:PrevGCDP(1881 - (446 + 1434), v79.Felblade))) and v32 and v43) or ((4962 - (1040 + 243)) < (1865 - 1240))) then
					if (v21(v79.FelRush, not v15:IsInRange(1862 - (559 + 1288))) or ((6556 - (609 + 1322)) < (1086 - (13 + 441)))) then
						return "fel_rush precombat 10";
					end
				end
				v123 = 7 - 5;
			end
			if (((5 - 3) == v123) or ((413 - 330) > (67 + 1713))) then
				if (((1982 - 1436) <= (383 + 694)) and v15:IsInMeleeRange(3 + 2) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(14 - 9)) or ((546 + 450) > (7910 - 3609))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if (((2691 + 1379) > (383 + 304)) and (v123 == (0 + 0))) then
				if ((v79.ImmolationAura:IsCastable() and v45) or ((551 + 105) >= (3259 + 71))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(441 - (153 + 280))) or ((7195 - 4703) <= (301 + 34))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((1707 + 2615) >= (1341 + 1221)) and v46 and not v14:IsMoving() and (v88 > (1 + 0)) and v79.SigilOfFlame:IsCastable()) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((2636 + 1001) >= (5740 - 1970))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(5 + 3)) or ((3046 - (89 + 578)) > (3271 + 1307))) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v78 == "cursor") or ((1003 - 520) > (1792 - (572 + 477)))) then
						if (((331 + 2123) > (347 + 231)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(5 + 35))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v123 = 87 - (84 + 2);
			end
		end
	end
	local function v109()
		if (((1532 - 602) < (3212 + 1246)) and v14:BuffDown(v79.FelBarrage)) then
			if (((1504 - (497 + 345)) <= (25 + 947)) and v79.DeathSweep:IsReady() and v37) then
				if (((739 + 3631) == (5703 - (605 + 728))) and v21(v79.DeathSweep, not v15:IsInRange(6 + 2))) then
					return "death_sweep meta_end 2";
				end
			end
			if ((v79.Annihilation:IsReady() and v33) or ((10586 - 5824) <= (40 + 821))) then
				if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((5220 - 3808) == (3844 + 420))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v110()
		local v124 = 0 - 0;
		local v125;
		while true do
			if ((v124 == (1 + 0)) or ((3657 - (457 + 32)) < (914 + 1239))) then
				v125 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				if (v125 or ((6378 - (832 + 570)) < (1255 + 77))) then
					return v125;
				end
				v124 = 1 + 1;
			end
			if (((16377 - 11749) == (2230 + 2398)) and (v124 == (796 - (588 + 208)))) then
				if ((((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and not v79.Demonic:IsAvailable()) or ((145 - 91) == (2195 - (884 + 916)))) then
					if (((171 - 89) == (48 + 34)) and v21(v81.MetamorphosisPlayer, not v15:IsInRange(661 - (232 + 421)))) then
						return "metamorphosis cooldown 4";
					end
				end
				if ((((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and v79.Demonic:IsAvailable() and ((not v79.ChaoticTransformation:IsAvailable() and v79.EyeBeam:CooldownDown()) or ((v79.EyeBeam:CooldownRemains() > (1909 - (1569 + 320))) and (not v91 or v14:PrevGCDP(1 + 0, v79.DeathSweep) or v14:PrevGCDP(1 + 1, v79.DeathSweep))) or ((v102 < ((84 - 59) + (v24(v79.ShatteredDestiny:IsAvailable()) * (675 - (316 + 289))))) and v79.EyeBeam:CooldownDown() and v79.BladeDance:CooldownDown())) and v14:BuffDown(v79.InnerDemonBuff)) or ((1520 - 939) < (14 + 268))) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(1461 - (666 + 787))) or ((5034 - (360 + 65)) < (2332 + 163))) then
						return "metamorphosis cooldown 6";
					end
				end
				v124 = 255 - (79 + 175);
			end
			if (((1816 - 664) == (899 + 253)) and (v124 == (5 - 3))) then
				if (((3651 - 1755) <= (4321 - (503 + 396))) and v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v88 > v60)) then
					if ((v59 == "player") or ((1171 - (92 + 89)) > (3142 - 1522))) then
						if (v21(v81.ElysianDecreePlayer, not v15:IsInRange(5 + 3)) or ((520 + 357) > (18386 - 13691))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif (((368 + 2323) >= (4220 - 2369)) and (v59 == "cursor")) then
						if (v21(v81.ElysianDecreeCursor, not v15:IsInRange(27 + 3)) or ((1426 + 1559) >= (14789 - 9933))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if (((534 + 3742) >= (1822 - 627)) and (v70 < v102)) then
					if (((4476 - (485 + 759)) <= (10852 - 6162)) and v71 and ((v31 and v72) or not v72)) then
						local v176 = 1189 - (442 + 747);
						while true do
							if ((v176 == (1135 - (832 + 303))) or ((1842 - (88 + 858)) >= (959 + 2187))) then
								v28 = v106();
								if (((2534 + 527) >= (122 + 2836)) and v28) then
									return v28;
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
	local function v111()
		local v126 = 789 - (766 + 23);
		while true do
			if (((15733 - 12546) >= (880 - 236)) and (v126 == (0 - 0))) then
				if (((2185 - 1541) <= (1777 - (1036 + 37))) and v79.EssenceBreak:IsCastable() and v39 and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > (8 + 2)))) then
					if (((1865 - 907) > (745 + 202)) and v21(v79.EssenceBreak, not v15:IsInRange(1488 - (641 + 839)))) then
						return "essence_break rotation prio";
					end
				end
				if (((5405 - (910 + 3)) >= (6765 - 4111)) and v79.BladeDance:IsCastable() and v34 and v15:DebuffUp(v79.EssenceBreakDebuff)) then
					if (((5126 - (1466 + 218)) >= (691 + 812)) and v21(v79.BladeDance, not v15:IsInRange(1156 - (556 + 592)))) then
						return "blade_dance rotation prio";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((1128 + 2042) <= (2272 - (329 + 479)))) then
					if (v21(v79.DeathSweep, not v15:IsInRange(862 - (174 + 680))) or ((16483 - 11686) == (9094 - 4706))) then
						return "death_sweep rotation prio";
					end
				end
				if (((394 + 157) <= (1420 - (396 + 343))) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.Metamorphosis:CooldownRemains() <= (v14:GCD() * (1 + 2)))) then
					if (((4754 - (29 + 1448)) > (1796 - (135 + 1254))) and v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation))) then
						return "annihilation rotation 2";
					end
				end
				if (((17687 - 12992) >= (6606 - 5191)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownDown() and (v79.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v79.EssenceBreak:CooldownRemains() < (v98 * (1529 - (389 + 1138)))) and (v10.CombatTime() > (579 - (102 + 472))) and (v14:Fury() >= (29 + 1)) and v79.Inertia:IsAvailable()) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(5 + 3), nil, true) or ((2995 + 217) <= (2489 - (320 + 1225)))) then
						return "vengeful_retreat rotation 3";
					end
				end
				v126 = 1 - 0;
			end
			if ((v126 == (2 + 1)) or ((4560 - (157 + 1307)) <= (3657 - (821 + 1038)))) then
				if (((8824 - 5287) == (387 + 3150)) and v79.Annihilation:IsReady() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.EyeBeam:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v79.FelBarrage)) then
					if (((6815 - 2978) >= (585 + 985)) and v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation))) then
						return "annihilation rotation 20";
					end
				end
				if ((v79.FelRush:IsReady() and v32 and v43 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (7 - 4))) and (v14:BuffRemains(v79.MomentumBuff) < (1031 - (834 + 192))) and v14:BuffDown(v79.MetamorphosisBuff)) or ((188 + 2762) == (979 + 2833))) then
					if (((102 + 4621) >= (3590 - 1272)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 22";
					end
				end
				if ((v79.EyeBeam:IsCastable() and v40 and not v14:PrevGCDP(305 - (300 + 4), v79.VengefulRetreat) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.Metamorphosis:CooldownRemains() > ((9 + 21) - (v24(v79.CycleOfHatred:IsAvailable()) * (39 - 24)))) or ((v79.Metamorphosis:CooldownRemains() < (v98 * (364 - (112 + 250)))) and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() < (v98 * (1.5 + 0)))))) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > v98) or not v79.RestlessHunter:IsAvailable()) and (v79.CycleOfHatred:IsAvailable() or not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (12 - 7)) or not v48 or (v10.CombatTime() < (6 + 4))) and v14:BuffDown(v79.InnerDemonBuff)) or (v102 < (8 + 7)))) or ((1516 + 511) > (1415 + 1437))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(6 + 2)) or ((2550 - (1001 + 413)) > (9626 - 5309))) then
						return "eye_beam rotation 26";
					end
				end
				if (((5630 - (244 + 638)) == (5441 - (627 + 66))) and v79.BladeDance:IsCastable() and v34 and v91 and ((v79.EyeBeam:CooldownRemains() > (14 - 9)) or not v79.Demonic:IsAvailable() or v14:HasTier(633 - (512 + 90), 1908 - (1665 + 241)))) then
					if (((4453 - (373 + 344)) <= (2138 + 2602)) and v21(v79.BladeDance, not v15:IsInRange(3 + 5))) then
						return "blade_dance rotation 28";
					end
				end
				if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff) and (v88 >= (10 - 6))) or ((5736 - 2346) <= (4159 - (35 + 1064)))) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((727 + 272) > (5761 - 3068))) then
						if (((2 + 461) < (1837 - (298 + 938))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1267 - (233 + 1026)))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif ((v78 == "cursor") or ((3849 - (636 + 1030)) < (352 + 335))) then
						if (((4444 + 105) == (1352 + 3197)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(3 + 37))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				v126 = 225 - (55 + 166);
			end
			if (((906 + 3766) == (470 + 4202)) and (v126 == (26 - 19))) then
				if ((v79.DemonsBite:IsCastable() and v38) or ((3965 - (36 + 261)) < (690 - 295))) then
					if (v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite)) or ((5534 - (34 + 1334)) == (175 + 280))) then
						return "demons_bite rotation 57";
					end
				end
				if ((v79.FelRush:IsReady() and v32 and v43 and not v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) <= (16 + 4))) or ((5732 - (1035 + 248)) == (2684 - (20 + 1)))) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((2229 + 2048) < (3308 - (134 + 185)))) then
						return "fel_rush rotation 58";
					end
				end
				if ((v79.FelRush:IsReady() and v32 and v43 and not v15:IsInRange(1141 - (549 + 584)) and not v79.Momentum:IsAvailable()) or ((1555 - (314 + 371)) >= (14243 - 10094))) then
					if (((3180 - (478 + 490)) < (1687 + 1496)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				if (((5818 - (786 + 386)) > (9690 - 6698)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownDown() and not v79.Initiative:IsAvailable() and not v15:IsInRange(1387 - (1055 + 324))) then
					if (((2774 - (1093 + 247)) < (2761 + 345)) and v21(v79.VengefulRetreat, not v15:IsInRange(1 + 7), nil, true)) then
						return "vengeful_retreat rotation 60";
					end
				end
				if (((3120 - 2334) < (10259 - 7236)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat) and not v14:IsMoving() and (v79.DemonBlades:IsAvailable() or not v15:IsInRange(30 - 18)) and v15:DebuffDown(v79.EssenceBreakDebuff) and v15:IsSpellInRange(v79.ThrowGlaive) and not v14:HasTier(12 + 19, 7 - 5)) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((8416 - 5974) < (56 + 18))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if (((11597 - 7062) == (5223 - (364 + 324))) and (v126 == (10 - 6))) then
				if ((v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v88 >= ((1 + 1) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.ThrowGlaive:FullRechargeTime() < (v98 * (12 - 9))) or (v88 > (1 - 0))) and not v14:HasTier(94 - 63, 1270 - (1249 + 19))) or ((2717 + 292) <= (8193 - 6088))) then
					if (((2916 - (686 + 400)) < (2879 + 790)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "throw_glaive rotation 32";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v88 >= (231 - (73 + 156))) and (v14:Fury() < (1 + 69)) and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((2241 - (721 + 90)) >= (41 + 3571))) then
					if (((8711 - 6028) >= (2930 - (224 + 246))) and v21(v79.ImmolationAura, not v15:IsInRange(12 - 4))) then
						return "immolation_aura rotation 34";
					end
				end
				if ((v79.Annihilation:IsCastable() and v33 and not v92 and ((v79.EssenceBreak:CooldownRemains() > (0 - 0)) or not v79.EssenceBreak:IsAvailable()) and v14:BuffDown(v79.FelBarrage)) or v14:HasTier(6 + 24, 1 + 1) or ((1325 + 479) >= (6511 - 3236))) then
					if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((4715 - 3298) > (4142 - (203 + 310)))) then
						return "annihilation rotation 36";
					end
				end
				if (((6788 - (1238 + 755)) > (29 + 373)) and v79.Felblade:IsCastable() and v42 and not v14:PrevGCDP(1535 - (709 + 825), v79.VengefulRetreat) and (((v14:FuryDeficit() >= (73 - 33)) and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)))) then
					if (((7010 - 2197) > (4429 - (196 + 668))) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade rotation 38";
					end
				end
				if (((15445 - 11533) == (8103 - 4191)) and v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and (v14:FuryDeficit() >= (863 - (171 + 662)))) then
					if (((2914 - (4 + 89)) <= (16907 - 12083)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (((633 + 1105) <= (9640 - 7445)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(4 + 4))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif (((1527 - (35 + 1451)) <= (4471 - (28 + 1425))) and (v78 == "cursor")) then
						if (((4138 - (941 + 1052)) <= (3936 + 168)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1554 - (822 + 692)))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				v126 = 6 - 1;
			end
			if (((1267 + 1422) < (5142 - (45 + 252))) and (v126 == (1 + 0))) then
				if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownDown() and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and ((v79.EssenceBreak:CooldownRemains() > (36 - 21)) or ((v79.EssenceBreak:CooldownRemains() < v98) and (not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > ((448 - (114 + 319)) + ((14 - 4) * v24(v79.CycleOfHatred:IsAvailable()))))))) and ((v10.CombatTime() < (38 - 8)) or ((v14:GCDRemains() - (1 + 0)) < (0 - 0))) and (not v79.Initiative:IsAvailable() or (v14:BuffRemains(v79.InitiativeBuff) < v98) or (v10.CombatTime() > (8 - 4)))) or ((4285 - (556 + 1407)) > (3828 - (741 + 465)))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(473 - (170 + 295)), nil, true) or ((2389 + 2145) == (1913 + 169))) then
						return "vengeful_retreat rotation 4";
					end
				end
				if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownDown() and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (2 - 1)) and ((v79.EssenceBreak:CooldownRemains() > (13 + 2)) or ((v79.EssenceBreak:CooldownRemains() < (v98 * (2 + 0))) and (((v14:BuffRemains(v79.InitiativeBuff) < v98) and not v96 and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > (17 + 13))) or not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > ((1245 - (957 + 273)) + ((3 + 7) * v24(v79.CycleofHatred:IsAvailable()))))))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff))) or ((629 + 942) > (7114 - 5247))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(21 - 13), nil, true) or ((8106 - 5452) >= (14835 - 11839))) then
						return "vengeful_retreat rotation 6";
					end
				end
				if (((5758 - (389 + 1391)) > (1321 + 783)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownDown() and v79.Initiative:IsAvailable() and not v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and (v14:BuffDown(v79.InitiativeBuff) or (v14:PrevGCDP(2 - 1, v79.DeathSweep) and v79.Metamorphosis:CooldownUp() and v79.ChaoticTransformation:IsAvailable())) and v79.Initiative:IsAvailable()) then
					if (((3946 - (783 + 168)) > (5171 - 3630)) and v21(v79.VengefulRetreat, not v15:IsInRange(8 + 0), nil, true)) then
						return "vengeful_retreat rotation 8";
					end
				end
				if (((3560 - (309 + 2)) > (2926 - 1973)) and v79.FelRush:IsCastable() and v32 and v43 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v98 * (1214 - (1090 + 122)))) and (v79.EyeBeam:CooldownRemains() <= v98) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((1062 + 2211) > (15358 - 10785))) then
						return "fel_rush rotation 10";
					end
				end
				if ((v79.FelRush:IsCastable() and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or ((v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge()) and (v79.EyeBeam:CooldownRemains() > (3 + 1)))) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) or ((4269 - (628 + 490)) < (231 + 1053))) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((4580 - 2730) == (6987 - 5458))) then
						return "fel_rush rotation 11";
					end
				end
				v126 = 776 - (431 + 343);
			end
			if (((1657 - 836) < (6141 - 4018)) and (v126 == (4 + 1))) then
				if (((116 + 786) < (4020 - (556 + 1139))) and v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(16 - (6 + 9), v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v89 >= ((1 + 1) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and not v14:HasTier(16 + 15, 171 - (28 + 141))) then
					if (((333 + 525) <= (3655 - 693)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "throw_glaive rotation 40";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v14:BuffStack(v79.ImmolationAuraBuff) < v97) and v15:IsInRange(6 + 2) and (v14:BuffDown(v79.UnboundChaosBuff) or not v79.UnboundChaos:IsAvailable()) and ((v79.ImmolationAura:Recharge() < v79.EssenceBreak:CooldownRemains()) or (not v79.EssenceBreak:IsAvailable() and (v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge())))) or ((5263 - (486 + 831)) < (3351 - 2063))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(27 - 19)) or ((613 + 2629) == (1792 - 1225))) then
						return "immolation_aura rotation 42";
					end
				end
				if ((v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(1264 - (668 + 595), v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v79.ThrowGlaive:FullRechargeTime() < v79.BladeDance:CooldownRemains()) and v14:HasTier(28 + 3, 1 + 1) and v14:BuffDown(v79.FelBarrage) and not v93) or ((2309 - 1462) >= (1553 - (23 + 267)))) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((4197 - (1129 + 815)) == (2238 - (371 + 16)))) then
						return "throw_glaive rotation 44";
					end
				end
				if ((v79.ChaosStrike:IsReady() and v35 and not v92 and not v93 and v14:BuffDown(v79.FelBarrage)) or ((3837 - (1326 + 424)) > (4492 - 2120))) then
					if (v21(v79.ChaosStrike, not v15:IsSpellInRange(v79.ChaosStrike)) or ((16243 - 11798) < (4267 - (88 + 30)))) then
						return "chaos_strike rotation 46";
					end
				end
				if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and (v14:FuryDeficit() >= (801 - (720 + 51)))) or ((4043 - 2225) == (1861 - (421 + 1355)))) then
					if (((1039 - 409) < (1045 + 1082)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1091 - (286 + 797))) or ((7084 - 5146) == (4163 - 1649))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif (((4694 - (397 + 42)) >= (18 + 37)) and (v78 == "cursor")) then
						if (((3799 - (24 + 776)) > (1780 - 624)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(815 - (222 + 563)))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				v126 = 12 - 6;
			end
			if (((1692 + 658) > (1345 - (23 + 167))) and (v126 == (1804 - (690 + 1108)))) then
				if (((1454 + 2575) <= (4003 + 850)) and v79.Felblade:IsCastable() and v42 and (v14:FuryDeficit() >= (888 - (40 + 808))) and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1973 - 1457) > (3283 + 151))) then
						return "felblade rotation 50";
					end
				end
				if (((2141 + 1905) >= (1664 + 1369)) and v79.FelRush:IsCastable() and v32 and v43 and not v79.Momentum:IsAvailable() and v79.DemonBlades:IsAvailable() and v79.EyeBeam:CooldownDown() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.FelRush:Recharge() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable())) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((3290 - (47 + 524)) <= (940 + 507))) then
						return "fel_rush rotation 52";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38 and v79.BurningWound:IsAvailable() and (v15:DebuffRemains(v79.BurningWoundDebuff) < (10 - 6))) or ((6181 - 2047) < (8953 - 5027))) then
					if (v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite)) or ((1890 - (1165 + 561)) >= (83 + 2702))) then
						return "demons_bite rotation 54";
					end
				end
				if ((v79.FelRush:IsCastable() and v32 and v43 and not v79.Momentum:IsAvailable() and not v79.DemonBlades:IsAvailable() and (v88 > (3 - 2)) and v14:BuffDown(v79.UnboundChaosBuff)) or ((201 + 324) == (2588 - (341 + 138)))) then
					if (((9 + 24) == (67 - 34)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 56";
					end
				end
				if (((3380 - (89 + 237)) <= (12916 - 8901)) and v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= (63 - 33)) and v15:IsInRange(911 - (581 + 300))) then
					if (((3091 - (855 + 365)) < (8032 - 4650)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (((423 + 870) <= (3401 - (1030 + 205))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(8 + 0))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif ((v78 == "cursor") or ((2400 + 179) < (409 - (156 + 130)))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(68 - 38)) or ((1425 - 579) >= (4849 - 2481))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				v126 = 2 + 5;
			end
			if ((v126 == (2 + 0)) or ((4081 - (10 + 59)) <= (950 + 2408))) then
				if (((7357 - 5863) <= (4168 - (671 + 492))) and v79.EssenceBreak:IsCastable() and v39 and ((((v14:BuffRemains(v79.MetamorphosisBuff) > (v98 * (3 + 0))) or (v79.EyeBeam:CooldownRemains() > (1225 - (369 + 846)))) and (not v79.TacticalRetreat:IsAvailable() or v14:BuffUp(v79.TacticalRetreatBuff) or (v10.CombatTime() < (3 + 7))) and (v79.BladeDance:CooldownRemains() <= ((3.1 + 0) * v98))) or (v102 < (1951 - (1036 + 909))))) then
					if (v21(v79.EssenceBreak, not v15:IsInRange(7 + 1)) or ((5222 - 2111) == (2337 - (11 + 192)))) then
						return "essence_break rotation 13";
					end
				end
				if (((1191 + 1164) == (2530 - (135 + 40))) and v79.DeathSweep:IsCastable() and v37 and v91 and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() > (v98 * (4 - 2)))) and v14:BuffDown(v79.FelBarrage)) then
					if (v21(v79.DeathSweep, not v15:IsInRange(5 + 3)) or ((1295 - 707) <= (646 - 214))) then
						return "death_sweep rotation 14";
					end
				end
				if (((4973 - (50 + 126)) >= (10845 - 6950)) and v79.TheHunt:IsCastable() and v32 and v55 and (v70 < v102) and ((v31 and v58) or not v58) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v10.CombatTime() < (3 + 7)) or (v79.Metamorphosis:CooldownRemains() > (1423 - (1233 + 180)))) and ((v88 == (970 - (522 + 447))) or (v88 > (1424 - (107 + 1314))) or (v102 < (5 + 5))) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FuriousGaze:IsAvailable() or v14:BuffUp(v79.FuriousGazeBuff) or v14:HasTier(94 - 63, 2 + 2))) or not v14:HasTier(59 - 29, 7 - 5)) and (v10.CombatTime() > (1920 - (716 + 1194)))) then
					if (((62 + 3515) == (384 + 3193)) and v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if (((4297 - (74 + 429)) > (7123 - 3430)) and v79.FelBarrage:IsCastable() and v41 and ((v88 > (1 + 0)) or ((v88 == (2 - 1)) and (v14:FuryDeficit() < (15 + 5)) and v14:BuffDown(v79.MetamorphosisBuff)))) then
					if (v21(v79.FelBarrage, not v15:IsInRange(24 - 16)) or ((3152 - 1877) == (4533 - (279 + 154)))) then
						return "fel_barrage rotation 16";
					end
				end
				if ((v79.GlaiveTempest:IsReady() and v44 and (v15:DebuffDown(v79.EssenceBreakDebuff) or (v88 > (779 - (454 + 324)))) and v14:BuffDown(v79.FelBarrage)) or ((1252 + 339) >= (3597 - (12 + 5)))) then
					if (((530 + 453) <= (4606 - 2798)) and v21(v79.GlaiveTempest, not v15:IsInRange(3 + 5))) then
						return "glaive_tempest rotation 18";
					end
				end
				v126 = 1096 - (277 + 816);
			end
		end
	end
	local function v112()
		v33 = EpicSettings.Settings['useAnnihilation'];
		v34 = EpicSettings.Settings['useBladeDance'];
		v35 = EpicSettings.Settings['useChaosStrike'];
		v36 = EpicSettings.Settings['useConsumeMagic'];
		v37 = EpicSettings.Settings['useDeathSweep'];
		v38 = EpicSettings.Settings['useDemonsBite'];
		v39 = EpicSettings.Settings['useEssenceBreak'];
		v40 = EpicSettings.Settings['useEyeBeam'];
		v41 = EpicSettings.Settings['useFelBarrage'];
		v42 = EpicSettings.Settings['useFelblade'];
		v43 = EpicSettings.Settings['useFelRush'];
		v44 = EpicSettings.Settings['useGlaiveTempest'];
		v45 = EpicSettings.Settings['useImmolationAura'];
		v46 = EpicSettings.Settings['useSigilOfFlame'];
		v47 = EpicSettings.Settings['useThrowGlaive'];
		v48 = EpicSettings.Settings['useVengefulRetreat'];
		v53 = EpicSettings.Settings['useElysianDecree'];
		v54 = EpicSettings.Settings['useMetamorphosis'];
		v55 = EpicSettings.Settings['useTheHunt'];
		v56 = EpicSettings.Settings['elysianDecreeWithCD'];
		v57 = EpicSettings.Settings['metamorphosisWithCD'];
		v58 = EpicSettings.Settings['theHuntWithCD'];
		v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
	end
	local function v113()
		v49 = EpicSettings.Settings['useChaosNova'];
		v50 = EpicSettings.Settings['useDisrupt'];
		v51 = EpicSettings.Settings['useFelEruption'];
		v52 = EpicSettings.Settings['useSigilOfMisery'];
		v61 = EpicSettings.Settings['useBlur'];
		v62 = EpicSettings.Settings['useNetherwalk'];
		v63 = EpicSettings.Settings['blurHP'] or (1183 - (1058 + 125));
		v64 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v78 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v114()
		v70 = EpicSettings.Settings['fightRemainsCheck'] or (975 - (815 + 160));
		v65 = EpicSettings.Settings['dispelBuffs'];
		v67 = EpicSettings.Settings['InterruptWithStun'];
		v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v69 = EpicSettings.Settings['InterruptThreshold'];
		v71 = EpicSettings.Settings['useTrinkets'];
		v72 = EpicSettings.Settings['trinketsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v73 = EpicSettings.Settings['useHealingPotion'];
		v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v75 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v77 = EpicSettings.Settings['HealingPotionName'] or "";
		v66 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v115()
		v113();
		v112();
		v114();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['movement'];
		if (v14:IsDeadOrGhost() or ((513 + 1637) <= (3498 - 2301))) then
			return v28;
		end
		v86 = v14:GetEnemiesInMeleeRange(1906 - (41 + 1857));
		v87 = v14:GetEnemiesInMeleeRange(1913 - (1222 + 671));
		if (((9741 - 5972) >= (1685 - 512)) and v30) then
			local v170 = 1182 - (229 + 953);
			while true do
				if (((3259 - (1111 + 663)) == (3064 - (874 + 705))) and (v170 == (0 + 0))) then
					v88 = ((#v86 > (0 + 0)) and #v86) or (1 - 0);
					v89 = #v87;
					break;
				end
			end
		else
			local v171 = 0 + 0;
			while true do
				if ((v171 == (679 - (642 + 37))) or ((756 + 2559) <= (446 + 2336))) then
					v88 = 2 - 1;
					v89 = 455 - (233 + 221);
					break;
				end
			end
		end
		v98 = v14:GCD() + (0.05 - 0);
		if (v23.TargetIsValid() or v14:AffectingCombat() or ((772 + 104) >= (4505 - (718 + 823)))) then
			v101 = v10.BossFightRemains(nil, true);
			v102 = v101;
			if ((v102 == (6992 + 4119)) or ((3037 - (266 + 539)) > (7069 - 4572))) then
				v102 = v10.FightRemains(v86, false);
			end
		end
		v28 = v107();
		if (v28 or ((3335 - (636 + 589)) <= (787 - 455))) then
			return v28;
		end
		if (((7602 - 3916) > (2514 + 658)) and v66) then
			local v172 = 0 + 0;
			while true do
				if ((v172 == (1015 - (657 + 358))) or ((11845 - 7371) < (1868 - 1048))) then
					v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 1217 - (1151 + 36), true);
					if (((4133 + 146) >= (758 + 2124)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((6059 - 4030) >= (5353 - (1552 + 280)))) then
			local v173 = 834 - (64 + 770);
			local v174;
			while true do
				if (((2 + 0) == v173) or ((4623 - 2586) >= (825 + 3817))) then
					v92 = v91 and (v14:Fury() < ((1318 - (157 + 1086)) - (v24(v79.DemonBlades:IsAvailable()) * (40 - 20)))) and (v79.BladeDance:CooldownRemains() < v98);
					v93 = v79.Demonic:IsAvailable() and not v79.BlindFury:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (8 - 6))) and (v14:FuryDeficit() > (46 - 16));
					v95 = (v79.Momentum:IsAvailable() and v14:BuffDown(v79.MomentumBuff)) or (v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff));
					v173 = 3 - 0;
				end
				if (((2539 - (599 + 220)) < (8877 - 4419)) and (v173 == (1939 - (1813 + 118)))) then
					if ((v79.DemonBlades:IsAvailable()) or ((319 + 117) > (4238 - (841 + 376)))) then
						if (((998 - 285) <= (197 + 650)) and v21(v79.Pool)) then
							return "pool demon_blades";
						end
					end
					break;
				end
				if (((5879 - 3725) <= (4890 - (464 + 395))) and ((10 - 6) == v173)) then
					if (((2217 + 2398) == (5452 - (467 + 370))) and v79.ImmolationAura:IsCastable() and v45 and v79.AFireInside:IsAvailable() and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v98 * (3 - 1))) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
						if (v21(v79.ImmolationAura, not v15:IsInRange(6 + 2)) or ((12992 - 9202) == (79 + 421))) then
							return "immolation_aura main 3";
						end
					end
					if (((206 - 117) < (741 - (150 + 370))) and v79.FelRush:IsCastable() and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and (((v79.ImmolationAura:Charges() == (1284 - (74 + 1208))) and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v14:PrevGCDP(2 - 1, v79.EyeBeam) and v14:BuffUp(v79.InertiaBuff) and (v14:BuffRemains(v79.InertiaBuff) < (14 - 11))))) then
						if (((1462 + 592) >= (1811 - (14 + 376))) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fel_rush main 4";
						end
					end
					if (((1199 - 507) < (1979 + 1079)) and v79.TheHunt:IsCastable() and (v10.CombatTime() < (9 + 1)) and (not v79.Inertia:IsAvailable() or (v14:BuffUp(v79.MetamorphosisBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)))) then
						if (v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt)) or ((3104 + 150) == (4849 - 3194))) then
							return "the_hunt main 6";
						end
					end
					v173 = 4 + 1;
				end
				if ((v173 == (78 - (23 + 55))) or ((3071 - 1775) == (3277 + 1633))) then
					if (((3025 + 343) == (5221 - 1853)) and not v14:AffectingCombat()) then
						v28 = v108();
						if (((832 + 1811) < (4716 - (652 + 249))) and v28) then
							return v28;
						end
					end
					if (((5119 - 3206) > (2361 - (708 + 1160))) and v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) then
						if (((12907 - 8152) > (6249 - 2821)) and v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((1408 - (10 + 17)) <= (533 + 1836)) and v79.FelRush:IsReady() and v32 and v43 and not v15:IsInRange(1740 - (1400 + 332))) then
						if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((9289 - 4446) == (5992 - (242 + 1666)))) then
							return "fel_rush rotation when OOR";
						end
					end
					v173 = 1 + 0;
				end
				if (((1712 + 2957) > (310 + 53)) and (v173 == (941 - (850 + 90)))) then
					if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v15:NPCID())) or ((3287 - 1410) >= (4528 - (360 + 1030)))) then
						if (((4197 + 545) >= (10234 - 6608)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v16:NPCID())) or ((6246 - 1706) == (2577 - (909 + 752)))) then
						if (v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((2379 - (109 + 1114)) > (7954 - 3609))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v91 = v79.FirstBlood:IsAvailable() or v79.TrailofRuin:IsAvailable() or (v79.ChaosTheory:IsAvailable() and v14:BuffDown(v79.ChaosTheoryBuff)) or (v88 > (1 + 0));
					v173 = 244 - (6 + 236);
				end
				if (((1410 + 827) < (3421 + 828)) and ((6 - 3) == v173)) then
					v174 = v27(v79.EyeBeam:BaseDuration(), v14:GCD());
					v96 = v79.Demonic:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v102 > (v79.Metamorphosis:CooldownRemains() + (52 - 22) + (v24(v79.ShatteredDestiny:IsAvailable()) * (1193 - (1076 + 57))))) and (v79.Metamorphosis:CooldownRemains() < (4 + 16)) and (v79.Metamorphosis:CooldownRemains() > (v174 + (v98 * (v24(v79.InnerDemon:IsAvailable()) + (691 - (579 + 110))))));
					if ((v79.ImmolationAura:IsCastable() and v45 and v79.Ragefire:IsAvailable() and (v88 >= (1 + 2)) and (v79.BladeDance:CooldownDown() or v15:DebuffDown(v79.EssenceBreakDebuff))) or ((2373 + 310) < (13 + 10))) then
						if (((1104 - (174 + 233)) <= (2307 - 1481)) and v21(v79.ImmolationAura, not v15:IsInRange(13 - 5))) then
							return "immolation_aura main 2";
						end
					end
					v173 = 2 + 2;
				end
				if (((2279 - (663 + 511)) <= (1050 + 126)) and (v173 == (2 + 5))) then
					if (((10417 - 7038) <= (2309 + 1503)) and v14:BuffUp(v79.MetamorphosisBuff) and (v14:BuffRemains(v79.MetamorphosisBuff) < v98) and (v88 < (6 - 3))) then
						v28 = v109();
						if (v28 or ((1907 - 1119) >= (772 + 844))) then
							return v28;
						end
					end
					v28 = v111();
					if (((3608 - 1754) <= (2409 + 970)) and v28) then
						return v28;
					end
					v173 = 1 + 7;
				end
				if (((5271 - (478 + 244)) == (5066 - (440 + 77))) and (v173 == (3 + 3))) then
					if ((v79.FelRush:IsCastable() and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and ((v79.EyeBeam:CooldownRemains() + (10 - 7)) > v14:BuffRemains(v79.UnboundChaosBuff)) and (v79.BladeDance:CooldownDown() or v79.EssenceBreak:CooldownUp())) or ((4578 - (655 + 901)) >= (561 + 2463))) then
						if (((3691 + 1129) > (1485 + 713)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fel_rush main 9";
						end
					end
					if ((v79.FelRush:IsCastable() and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EssenceBreak:CooldownRemains() > (40 - 30)))) or ((2506 - (695 + 750)) >= (16701 - 11810))) then
						if (((2104 - 740) <= (17989 - 13516)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fel_rush main 10";
						end
					end
					if (((v70 < v102) and v31) or ((3946 - (285 + 66)) <= (6 - 3))) then
						local v177 = 1310 - (682 + 628);
						while true do
							if (((0 + 0) == v177) or ((4971 - (176 + 123)) == (1612 + 2240))) then
								v28 = v110();
								if (((1131 + 428) == (1828 - (239 + 30))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					v173 = 2 + 5;
				end
				if (((5 + 0) == v173) or ((3100 - 1348) <= (2458 - 1670))) then
					if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and ((v79.EyeBeam:CooldownRemains() < (v98 * (317 - (306 + 9)))) or v14:BuffUp(v79.MetamorphosisBuff)) and (v79.EssenceBreak:CooldownRemains() < (v98 * (10 - 7))) and v14:BuffDown(v79.UnboundChaosBuff) and v14:BuffDown(v79.InertiaBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((680 + 3227) == (109 + 68))) then
						if (((1671 + 1799) > (1587 - 1032)) and v21(v79.ImmolationAura, not v15:IsInRange(1383 - (1140 + 235)))) then
							return "immolation_aura main 5";
						end
					end
					if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:FullRechargeTime() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable()) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > (4 + 2))) and v79.BladeDance:CooldownDown() and ((v14:Fury() < (69 + 6)) or (v79.BladeDance:CooldownRemains() < (v98 * (1 + 1))))) or ((1024 - (33 + 19)) == (233 + 412))) then
						if (((9537 - 6355) >= (932 + 1183)) and v21(v79.ImmolationAura, not v15:IsInRange(15 - 7))) then
							return "immolation_aura main 6";
						end
					end
					if (((3651 + 242) < (5118 - (586 + 103))) and v79.FelRush:IsCastable() and v32 and v43 and ((v14:BuffRemains(v79.UnboundChaosBuff) < (v98 * (1 + 1))) or (v15:TimeToDie() < (v98 * (5 - 3))))) then
						if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((4355 - (1309 + 179)) < (3439 - 1534))) then
							return "fel_rush main 8";
						end
					end
					v173 = 3 + 3;
				end
			end
		end
	end
	local function v116()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (0 + 0)) or ((3815 - 2019) >= (8072 - 4021))) then
				v79.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(1186 - (295 + 314), v115, v116);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

