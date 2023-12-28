local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1173 - (257 + 916))) or ((1257 + 410) >= (1832 + 1459))) then
			v6 = v0[v4];
			if (not v6 or ((674 + 199) == (1881 + 153))) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (552 - (83 + 468))) or ((4622 - (1202 + 604)) < (51 - 40))) then
			return v6(...);
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
	local v84 = (v83[20 - 7] and v19(v83[35 - 22])) or v19(325 - (45 + 280));
	local v85 = (v83[14 + 0] and v19(v83[13 + 1])) or v19(0 + 0);
	local v86, v87;
	local v88, v89;
	local v90 = {{v79.FelEruption},{v79.ChaosNova}};
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = false;
	local v97 = ((v79.AFireInside:IsAvailable()) and (2 + 3)) or (1773 - (1733 + 39));
	local v98 = v14:GCD() + (0.25 - 0);
	local v99 = 1034 - (125 + 909);
	local v100 = false;
	local v101 = 13059 - (1096 + 852);
	local v102 = 4985 + 6126;
	local v103 = {(164327 + 5094),(169661 - (46 + 190)),(47646 + 121286),(170152 - (228 + 498)),(93603 + 75826),(441409 - 271981),(169954 - (303 + 221))};
	v10:RegisterForEvent(function()
		local v117 = 1269 - (231 + 1038);
		while true do
			if (((3083 + 616) < (5868 - (171 + 991))) and (v117 == (12 - 9))) then
				v102 = 29835 - 18724;
				break;
			end
			if (((6602 - 3956) >= (702 + 174)) and (v117 == (3 - 2))) then
				v93 = false;
				v94 = false;
				v117 = 5 - 3;
			end
			if (((989 - 375) <= (9842 - 6658)) and (v117 == (1248 - (111 + 1137)))) then
				v91 = false;
				v92 = false;
				v117 = 159 - (91 + 67);
			end
			if (((9303 - 6177) == (780 + 2346)) and (v117 == (525 - (423 + 100)))) then
				v95 = false;
				v101 = 78 + 11033;
				v117 = 7 - 4;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v118 = 0 + 0;
		while true do
			if (((771 - (326 + 445)) == v118) or ((9543 - 7356) >= (11036 - 6082))) then
				v83 = v14:GetEquipment();
				v84 = (v83[29 - 16] and v19(v83[724 - (530 + 181)])) or v19(881 - (614 + 267));
				v118 = 33 - (19 + 13);
			end
			if ((v118 == (1 - 0)) or ((9034 - 5157) == (10212 - 6637))) then
				v85 = (v83[4 + 10] and v19(v83[24 - 10])) or v19(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v97 = ((v79.AFireInside:IsAvailable()) and (1817 - (1293 + 519))) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v104(v119)
		return v119:DebuffRemains(v79.BurningWoundDebuff) or v119:DebuffRemains(v79.BurningWoundLegDebuff);
	end
	local function v105(v120)
		return v79.BurningWound:IsAvailable() and (v120:DebuffRemains(v79.BurningWoundDebuff) < (9 - 5)) and (v79.BurningWoundDebuff:AuraActiveCount() < v26(v88, 5 - 2));
	end
	local function v106()
		v28 = v23.HandleTopTrinket(v82, v31, 172 - 132, nil);
		if (((1665 - 958) > (335 + 297)) and v28) then
			return v28;
		end
		v28 = v23.HandleBottomTrinket(v82, v31, 9 + 31, nil);
		if (v28 or ((1268 - 722) >= (621 + 2063))) then
			return v28;
		end
	end
	local function v107()
		if (((487 + 978) <= (2688 + 1613)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
			if (((2800 - (709 + 387)) > (3283 - (673 + 1185))) and v21(v79.Blur)) then
				return "blur defensive";
			end
		end
		if ((v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((1992 - 1305) == (13595 - 9361))) then
			if (v21(v79.Netherwalk) or ((5478 - 2148) < (1023 + 406))) then
				return "netherwalk defensive";
			end
		end
		if (((858 + 289) >= (451 - 116)) and v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) then
			if (((844 + 2591) > (4180 - 2083)) and v21(v81.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v73 and (v14:HealthPercentage() <= v75)) or ((7400 - 3630) >= (5921 - (446 + 1434)))) then
			if ((v77 == "Refreshing Healing Potion") or ((5074 - (1040 + 243)) <= (4808 - 3197))) then
				if (v80.RefreshingHealingPotion:IsReady() or ((6425 - (559 + 1288)) <= (3939 - (609 + 1322)))) then
					if (((1579 - (13 + 441)) <= (7757 - 5681)) and v21(v81.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v77 == "Dreamwalker's Healing Potion") or ((1946 - 1203) >= (21908 - 17509))) then
				if (((44 + 1111) < (6075 - 4402)) and v80.DreamwalkersHealingPotion:IsReady()) then
					if (v21(v81.RefreshingHealingPotion) or ((826 + 1498) <= (254 + 324))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v108()
		local v121 = 0 - 0;
		while true do
			if (((2062 + 1705) == (6928 - 3161)) and (v121 == (0 + 0))) then
				if (((2275 + 1814) == (2938 + 1151)) and v79.ImmolationAura:IsCastable() and v45) then
					if (((3744 + 714) >= (1638 + 36)) and v21(v79.ImmolationAura, not v15:IsInRange(441 - (153 + 280)))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((2806 - 1834) <= (1274 + 144)) and v46 and not v14:IsMoving() and (v88 > (1 + 0)) and v79.SigilOfFlame:IsCastable()) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((2585 + 2353) < (4322 + 440))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(6 + 2)) or ((3812 - 1308) > (2636 + 1628))) then
							return "sigil_of_flame precombat 9";
						end
					elseif (((2820 - (89 + 578)) == (1539 + 614)) and (v78 == "cursor")) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(83 - 43)) or ((1556 - (572 + 477)) >= (350 + 2241))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v121 = 1 + 0;
			end
			if (((535 + 3946) == (4567 - (84 + 2))) and ((1 - 0) == v121)) then
				if ((not v15:IsInMeleeRange(4 + 1) and v79.Felblade:IsCastable() and v42) or ((3170 - (497 + 345)) < (18 + 675))) then
					if (((732 + 3596) == (5661 - (605 + 728))) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade precombat 9";
					end
				end
				if (((1134 + 454) >= (2960 - 1628)) and not v15:IsInMeleeRange(1 + 4) and v79.ThrowGlaive:IsCastable() and v47) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((15432 - 11258) > (3830 + 418))) then
						return "throw_glaive precombat 9";
					end
				end
				v121 = 5 - 3;
			end
			if (((2 + 0) == v121) or ((5075 - (457 + 32)) <= (35 + 47))) then
				if (((5265 - (832 + 570)) == (3640 + 223)) and not v15:IsInMeleeRange(2 + 3) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(3 - 2, v79.Felblade))) and v32 and v43) then
					if (v21(v79.FelRush, not v15:IsInRange(8 + 7)) or ((1078 - (588 + 208)) <= (113 - 71))) then
						return "fel_rush precombat 10";
					end
				end
				if (((6409 - (884 + 916)) >= (1603 - 837)) and v15:IsInMeleeRange(3 + 2) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(658 - (232 + 421))) or ((3041 - (1569 + 320)) == (611 + 1877))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v109()
		if (((651 + 2771) > (11288 - 7938)) and v14:BuffDown(v79.FelBarrage)) then
			if (((1482 - (316 + 289)) > (984 - 608)) and v79.DeathSweep:IsReady() and v37) then
				if (v21(v79.DeathSweep, not v15:IsInRange(1 + 7)) or ((4571 - (666 + 787)) <= (2276 - (360 + 65)))) then
					return "death_sweep meta_end 2";
				end
			end
			if ((v79.Annihilation:IsReady() and v33) or ((155 + 10) >= (3746 - (79 + 175)))) then
				if (((6226 - 2277) < (3790 + 1066)) and v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v110()
		local v122 = 0 - 0;
		local v123;
		while true do
			if ((v122 == (0 - 0)) or ((5175 - (503 + 396)) < (3197 - (92 + 89)))) then
				if (((9098 - 4408) > (2116 + 2009)) and ((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and not v79.Demonic:IsAvailable()) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(5 + 3)) or ((195 - 145) >= (123 + 773))) then
						return "metamorphosis cooldown 4";
					end
				end
				if ((((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and v79.Demonic:IsAvailable() and ((not v79.ChaoticTransformation:IsAvailable() and v79.EyeBeam:CooldownDown()) or ((v79.EyeBeam:CooldownRemains() > (45 - 25)) and (not v91 or v14:PrevGCDP(1 + 0, v79.DeathSweep) or v14:PrevGCDP(1 + 1, v79.DeathSweep))) or ((v102 < ((75 - 50) + (v24(v79.ShatteredDestiny:IsAvailable()) * (9 + 61)))) and v79.EyeBeam:CooldownDown() and v79.BladeDance:CooldownDown())) and v14:BuffDown(v79.InnerDemonBuff)) or ((2613 - 899) >= (4202 - (485 + 759)))) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(18 - 10)) or ((2680 - (442 + 747)) < (1779 - (832 + 303)))) then
						return "metamorphosis cooldown 6";
					end
				end
				v122 = 947 - (88 + 858);
			end
			if (((215 + 489) < (817 + 170)) and (v122 == (1 + 1))) then
				if (((4507 - (766 + 23)) > (9409 - 7503)) and v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v88 > v60)) then
					if ((v59 == "player") or ((1309 - 351) > (9577 - 5942))) then
						if (((11882 - 8381) <= (5565 - (1036 + 37))) and v21(v81.ElysianDecreePlayer, not v15:IsInRange(6 + 2))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif ((v59 == "cursor") or ((6702 - 3260) < (2005 + 543))) then
						if (((4355 - (641 + 839)) >= (2377 - (910 + 3))) and v21(v81.ElysianDecreeCursor, not v15:IsInRange(76 - 46))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if ((v70 < v102) or ((6481 - (1466 + 218)) >= (2249 + 2644))) then
					if ((v71 and ((v31 and v72) or not v72)) or ((1699 - (556 + 592)) > (736 + 1332))) then
						local v176 = 808 - (329 + 479);
						while true do
							if (((2968 - (174 + 680)) > (3243 - 2299)) and ((0 - 0) == v176)) then
								v28 = v106();
								if (v28 or ((1615 + 647) >= (3835 - (396 + 343)))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v122 == (1 + 0)) or ((3732 - (29 + 1448)) >= (4926 - (135 + 1254)))) then
				v123 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				if (v123 or ((14454 - 10617) < (6097 - 4791))) then
					return v123;
				end
				v122 = 2 + 0;
			end
		end
	end
	local function v111()
		local v124 = 1527 - (389 + 1138);
		while true do
			if (((3524 - (102 + 472)) == (2784 + 166)) and (v124 == (3 + 1))) then
				if ((v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v88 >= ((1547 - (320 + 1225)) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.ThrowGlaive:FullRechargeTime() < (v98 * (5 - 2))) or (v88 > (1 + 0))) and not v14:HasTier(1495 - (157 + 1307), 1861 - (821 + 1038))) or ((11783 - 7060) < (361 + 2937))) then
					if (((2017 - 881) >= (58 + 96)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "throw_glaive rotation 32";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v88 >= (4 - 2)) and (v14:Fury() < (1096 - (834 + 192))) and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((18 + 253) > (1219 + 3529))) then
					if (((102 + 4638) >= (4882 - 1730)) and v21(v79.ImmolationAura, not v15:IsInRange(312 - (300 + 4)))) then
						return "immolation_aura rotation 34";
					end
				end
				if ((v79.Annihilation:IsCastable() and v33 and not v92 and ((v79.EssenceBreak:CooldownRemains() > (0 + 0)) or not v79.EssenceBreak:IsAvailable()) and v14:BuffDown(v79.FelBarrage)) or v14:HasTier(78 - 48, 364 - (112 + 250)) or ((1028 + 1550) >= (8492 - 5102))) then
					if (((24 + 17) <= (860 + 801)) and v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation))) then
						return "annihilation rotation 36";
					end
				end
				if (((450 + 151) < (1766 + 1794)) and v79.Felblade:IsCastable() and v42 and (((v14:FuryDeficit() >= (30 + 10)) and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)))) then
					if (((1649 - (1001 + 413)) < (1531 - 844)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade rotation 38";
					end
				end
				if (((5431 - (244 + 638)) > (1846 - (627 + 66))) and v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and (v14:FuryDeficit() >= (89 - 59))) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((5276 - (512 + 90)) < (6578 - (1665 + 241)))) then
						if (((4385 - (373 + 344)) < (2058 + 2503)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(3 + 5))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif ((v78 == "cursor") or ((1200 - 745) == (6100 - 2495))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(1139 - (35 + 1064))) or ((1938 + 725) == (7085 - 3773))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				v124 = 1 + 4;
			end
			if (((5513 - (298 + 938)) <= (5734 - (233 + 1026))) and (v124 == (1672 - (636 + 1030)))) then
				if ((v79.Felblade:IsCastable() and v42 and (v14:FuryDeficit() >= (21 + 19))) or ((850 + 20) == (354 + 835))) then
					if (((105 + 1448) <= (3354 - (55 + 166))) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade rotation 50";
					end
				end
				if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and v79.DemonBlades:IsAvailable() and v79.EyeBeam:CooldownDown() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.FelRush:Recharge() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable())) or ((434 + 1803) >= (354 + 3157))) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((5056 - 3732) > (3317 - (36 + 261)))) then
						return "fel_rush rotation 52";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38 and v79.BurningWound:IsAvailable() and (v15:DebuffRemains(v79.BurningWoundDebuff) < (6 - 2))) or ((4360 - (34 + 1334)) == (724 + 1157))) then
					if (((2414 + 692) > (2809 - (1035 + 248))) and v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite))) then
						return "demons_bite rotation 54";
					end
				end
				if (((3044 - (20 + 1)) < (2017 + 1853)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and not v79.DemonBlades:IsAvailable() and (v88 > (320 - (134 + 185))) and v14:BuffDown(v79.UnboundChaosBuff)) then
					if (((1276 - (549 + 584)) > (759 - (314 + 371))) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 56";
					end
				end
				if (((61 - 43) < (3080 - (478 + 490))) and v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= (16 + 14)) and v15:IsInRange(1202 - (786 + 386))) then
					if (((3553 - 2456) <= (3007 - (1055 + 324))) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (((5970 - (1093 + 247)) == (4115 + 515)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1 + 7))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif (((14054 - 10514) > (9105 - 6422)) and (v78 == "cursor")) then
						if (((13640 - 8846) >= (8229 - 4954)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(11 + 19))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				v124 = 26 - 19;
			end
			if (((5114 - 3630) == (1119 + 365)) and (v124 == (12 - 7))) then
				if (((2120 - (364 + 324)) < (9745 - 6190)) and v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v89 >= ((1 + 1) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and not v14:HasTier(129 - 98, 2 - 0)) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((3234 - 2169) > (4846 - (1249 + 19)))) then
						return "throw_glaive rotation 40";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v14:BuffStack(v79.ImmolationAuraBuff) < v97) and v15:IsInRange(8 + 0) and (v14:BuffDown(v79.UnboundChaosBuff) or not v79.UnboundChaos:IsAvailable()) and ((v79.ImmolationAura:Recharge() < v79.EssenceBreak:CooldownRemains()) or (not v79.EssenceBreak:IsAvailable() and (v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge())))) or ((18664 - 13869) < (2493 - (686 + 400)))) then
					if (((1454 + 399) < (5042 - (73 + 156))) and v21(v79.ImmolationAura, not v15:IsInRange(1 + 7))) then
						return "immolation_aura rotation 42";
					end
				end
				if ((v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(812 - (721 + 90), v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v79.ThrowGlaive:FullRechargeTime() < v79.BladeDance:CooldownRemains()) and v14:HasTier(1 + 30, 6 - 4) and v14:BuffDown(v79.FelBarrage) and not v93) or ((3291 - (224 + 246)) < (3938 - 1507))) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((5291 - 2417) < (396 + 1785))) then
						return "throw_glaive rotation 44";
					end
				end
				if ((v79.ChaosStrike:IsReady() and v35 and not v92 and not v93 and v14:BuffDown(v79.FelBarrage)) or ((64 + 2625) <= (252 + 91))) then
					if (v21(v79.ChaosStrike, not v15:IsSpellInRange(v79.ChaosStrike)) or ((3715 - 1846) == (6685 - 4676))) then
						return "chaos_strike rotation 46";
					end
				end
				if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and (v14:FuryDeficit() >= (543 - (203 + 310)))) or ((5539 - (1238 + 755)) < (163 + 2159))) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((3616 - (709 + 825)) == (8794 - 4021))) then
						if (((4725 - 1481) > (1919 - (196 + 668))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(31 - 23))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif ((v78 == "cursor") or ((6862 - 3549) <= (2611 - (171 + 662)))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(123 - (4 + 89))) or ((4980 - 3559) >= (767 + 1337))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				v124 = 26 - 20;
			end
			if (((711 + 1101) <= (4735 - (35 + 1451))) and (v124 == (1460 - (28 + 1425)))) then
				if (((3616 - (941 + 1052)) <= (1877 + 80)) and v79.DemonsBite:IsCastable() and v38) then
					if (((5926 - (822 + 692)) == (6298 - 1886)) and v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite))) then
						return "demons_bite rotation 57";
					end
				end
				if (((825 + 925) >= (1139 - (45 + 252))) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) <= (20 + 0))) then
					if (((1505 + 2867) > (4502 - 2652)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 58";
					end
				end
				if (((665 - (114 + 319)) < (1178 - 357)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v15:IsInRange(9 - 1) and not v79.Momentum:IsAvailable()) then
					if (((331 + 187) < (1343 - 441)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				if (((6273 - 3279) > (2821 - (556 + 1407))) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and not v79.Initiative:IsAvailable() and not v15:IsInRange(1214 - (741 + 465))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(473 - (170 + 295)), nil, true) or ((1979 + 1776) <= (841 + 74))) then
						return "vengeful_retreat rotation 60";
					end
				end
				if (((9714 - 5768) > (3103 + 640)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and (v79.DemonBlades:IsAvailable() or not v15:IsInRange(7 + 5)) and v15:DebuffDown(v79.EssenceBreakDebuff) and v15:IsSpellInRange(v79.ThrowGlaive) and not v14:HasTier(1261 - (957 + 273), 1 + 1)) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((535 + 800) >= (12597 - 9291))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if (((12764 - 7920) > (6881 - 4628)) and (v124 == (0 - 0))) then
				if (((2232 - (389 + 1391)) == (284 + 168)) and v79.EssenceBreak:IsCastable() and v39 and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > (2 + 8)))) then
					if (v21(v79.EssenceBreak, not v15:IsInRange(18 - 10)) or ((5508 - (783 + 168)) < (7004 - 4917))) then
						return "essence_break rotation prio";
					end
				end
				if (((3811 + 63) == (4185 - (309 + 2))) and v79.BladeDance:IsCastable() and v34 and v15:DebuffUp(v79.EssenceBreakDebuff)) then
					if (v21(v79.BladeDance, not v15:IsInRange(24 - 16)) or ((3150 - (1090 + 122)) > (1600 + 3335))) then
						return "blade_dance rotation prio";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((14290 - 10035) < (2343 + 1080))) then
					if (((2572 - (628 + 490)) <= (447 + 2044)) and v21(v79.DeathSweep, not v15:IsInRange(19 - 11))) then
						return "death_sweep rotation prio";
					end
				end
				if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.Metamorphosis:CooldownRemains() <= (v14:GCD() * (13 - 10)))) or ((4931 - (431 + 343)) <= (5660 - 2857))) then
					if (((14039 - 9186) >= (2356 + 626)) and v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation))) then
						return "annihilation rotation 2";
					end
				end
				if (((529 + 3605) > (5052 - (556 + 1139))) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v79.EyeBeam:CooldownRemains() < (15.3 - (6 + 9))) and (v79.EssenceBreak:CooldownRemains() < (v98 * (1 + 1))) and (v10.CombatTime() > (3 + 2)) and (v14:Fury() >= (199 - (28 + 141))) and v79.Inertia:IsAvailable()) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(4 + 4), nil, true) or ((4217 - 800) < (1795 + 739))) then
						return "vengeful_retreat rotation 3";
					end
				end
				v124 = 1318 - (486 + 831);
			end
			if ((v124 == (7 - 4)) or ((9583 - 6861) <= (31 + 133))) then
				if ((v79.Annihilation:IsReady() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.EyeBeam:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v79.FelBarrage)) or ((7613 - 5205) < (3372 - (668 + 595)))) then
					if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((30 + 3) == (294 + 1161))) then
						return "annihilation rotation 20";
					end
				end
				if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (8 - 5))) and (v14:BuffRemains(v79.MomentumBuff) < (295 - (23 + 267))) and v14:BuffDown(v79.MetamorphosisBuff)) or ((2387 - (1129 + 815)) >= (4402 - (371 + 16)))) then
					if (((5132 - (1326 + 424)) > (313 - 147)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 22";
					end
				end
				if ((v79.EyeBeam:IsCastable() and v40 and not v14:PrevGCDP(3 - 2, v79.VengefulRetreat) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.Metamorphosis:CooldownRemains() > ((148 - (88 + 30)) - (v24(v79.CycleOfHatred:IsAvailable()) * (786 - (720 + 51))))) or ((v79.Metamorphosis:CooldownRemains() < (v98 * (4 - 2))) and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() < (v98 * (1777.5 - (421 + 1355))))))) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > v98) or not v79.RestlessHunter:IsAvailable()) and (v79.CycleOfHatred:IsAvailable() or not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (8 - 3)) or not v48 or (v10.CombatTime() < (5 + 5))) and v14:BuffDown(v79.InnerDemonBuff)) or (v102 < (1098 - (286 + 797))))) or ((1023 - 743) == (5066 - 2007))) then
					if (((2320 - (397 + 42)) > (404 + 889)) and v21(v79.EyeBeam, not v15:IsInRange(808 - (24 + 776)))) then
						return "eye_beam rotation 26";
					end
				end
				if (((3630 - 1273) == (3142 - (222 + 563))) and v79.BladeDance:IsCastable() and v34 and v91 and ((v79.EyeBeam:CooldownRemains() > (11 - 6)) or not v79.Demonic:IsAvailable() or v14:HasTier(23 + 8, 192 - (23 + 167)))) then
					if (((1921 - (690 + 1108)) == (45 + 78)) and v21(v79.BladeDance, not v15:IsInRange(7 + 1))) then
						return "blade_dance rotation 28";
					end
				end
				if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff) and (v88 >= (852 - (40 + 808)))) or ((174 + 882) >= (12970 - 9578))) then
					if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((1034 + 47) < (569 + 506))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(5 + 3)) or ((1620 - (47 + 524)) >= (2877 + 1555))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif ((v78 == "cursor") or ((13033 - 8265) <= (1264 - 418))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(91 - 51)) or ((5084 - (1165 + 561)) <= (43 + 1377))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				v124 = 12 - 8;
			end
			if ((v124 == (1 + 0)) or ((4218 - (341 + 138)) <= (812 + 2193))) then
				if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 - 0)) and ((v79.EssenceBreak:CooldownRemains() > (341 - (89 + 237))) or ((v79.EssenceBreak:CooldownRemains() < v98) and (not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > ((48 - 33) + ((21 - 11) * v24(v79.CycleOfHatred:IsAvailable()))))))) and ((v10.CombatTime() < (911 - (581 + 300))) or ((v14:GCDRemains() - (1221 - (855 + 365))) < (0 - 0))) and (not v79.Initiative:IsAvailable() or (v14:BuffRemains(v79.InitiativeBuff) < v98) or (v10.CombatTime() > (2 + 2)))) or ((2894 - (1030 + 205)) >= (2004 + 130))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(8 + 0), nil, true) or ((3546 - (156 + 130)) < (5351 - 2996))) then
						return "vengeful_retreat rotation 4";
					end
				end
				if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 - 0)) and ((v79.EssenceBreak:CooldownRemains() > (30 - 15)) or ((v79.EssenceBreak:CooldownRemains() < (v98 * (1 + 1))) and (((v14:BuffRemains(v79.InitiativeBuff) < v98) and not v96 and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > (18 + 12))) or not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > ((84 - (10 + 59)) + ((3 + 7) * v24(v79.CycleofHatred:IsAvailable()))))))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff))) or ((3294 - 2625) == (5386 - (671 + 492)))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(7 + 1), nil, true) or ((2907 - (369 + 846)) < (156 + 432))) then
						return "vengeful_retreat rotation 6";
					end
				end
				if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and v79.Initiative:IsAvailable() and not v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and (v14:BuffDown(v79.InitiativeBuff) or (v14:PrevGCDP(1946 - (1036 + 909), v79.DeathSweep) and v79.Metamorphosis:CooldownUp() and v79.ChaoticTransformation:IsAvailable())) and v79.Initiative:IsAvailable()) or ((3814 + 983) < (6129 - 2478))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(211 - (11 + 192)), nil, true) or ((2111 + 2066) > (5025 - (135 + 40)))) then
						return "vengeful_retreat rotation 8";
					end
				end
				if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v98 * (4 - 2))) and (v79.EyeBeam:CooldownRemains() <= v98) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) or ((242 + 158) > (2447 - 1336))) then
					if (((4573 - 1522) > (1181 - (50 + 126))) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "fel_rush rotation 10";
					end
				end
				if (((10283 - 6590) <= (970 + 3412)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or ((v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge()) and (v79.EyeBeam:CooldownRemains() > (1417 - (1233 + 180))))) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) then
					if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((4251 - (522 + 447)) > (5521 - (107 + 1314)))) then
						return "fel_rush rotation 11";
					end
				end
				v124 = 1 + 1;
			end
			if ((v124 == (5 - 3)) or ((1521 + 2059) < (5647 - 2803))) then
				if (((352 - 263) < (6400 - (716 + 1194))) and v79.EssenceBreak:IsCastable() and v39 and ((((v14:BuffRemains(v79.MetamorphosisBuff) > (v98 * (1 + 2))) or (v79.EyeBeam:CooldownRemains() > (2 + 8))) and (not v79.TacticalRetreat:IsAvailable() or v14:BuffUp(v79.TacticalRetreatBuff) or (v10.CombatTime() < (513 - (74 + 429)))) and (v79.BladeDance:CooldownRemains() <= ((5.1 - 2) * v98))) or (v102 < (3 + 3)))) then
					if (v21(v79.EssenceBreak, not v15:IsInRange(18 - 10)) or ((3526 + 1457) < (5573 - 3765))) then
						return "essence_break rotation 13";
					end
				end
				if (((9467 - 5638) > (4202 - (279 + 154))) and v79.DeathSweep:IsCastable() and v37 and v91 and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() > (v98 * (780 - (454 + 324))))) and v14:BuffDown(v79.FelBarrage)) then
					if (((1169 + 316) <= (2921 - (12 + 5))) and v21(v79.DeathSweep, not v15:IsInRange(5 + 3))) then
						return "death_sweep rotation 14";
					end
				end
				if (((10877 - 6608) == (1578 + 2691)) and v79.TheHunt:IsCastable() and v32 and v55 and (v70 < v102) and ((v31 and v58) or not v58) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v10.CombatTime() < (1103 - (277 + 816))) or (v79.Metamorphosis:CooldownRemains() > (42 - 32))) and ((v88 == (1184 - (1058 + 125))) or (v88 > (1 + 2)) or (v102 < (985 - (815 + 160)))) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FuriousGaze:IsAvailable() or v14:BuffUp(v79.FuriousGazeBuff) or v14:HasTier(132 - 101, 9 - 5))) or not v14:HasTier(8 + 22, 5 - 3)) and (v10.CombatTime() > (1908 - (41 + 1857)))) then
					if (((2280 - (1222 + 671)) <= (7190 - 4408)) and v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if ((v79.FelBarrage:IsCastable() and v41 and ((v88 > (1 - 0)) or ((v88 == (1183 - (229 + 953))) and (v14:FuryDeficit() < (1794 - (1111 + 663))) and v14:BuffDown(v79.MetamorphosisBuff)))) or ((3478 - (874 + 705)) <= (129 + 788))) then
					if (v21(v79.FelBarrage, not v15:IsInRange(6 + 2)) or ((8962 - 4650) <= (25 + 851))) then
						return "fel_barrage rotation 16";
					end
				end
				if (((2911 - (642 + 37)) <= (592 + 2004)) and v79.GlaiveTempest:IsReady() and v44 and (v15:DebuffDown(v79.EssenceBreakDebuff) or (v88 > (1 + 0))) and v14:BuffDown(v79.FelBarrage)) then
					if (((5260 - 3165) < (4140 - (233 + 221))) and v21(v79.GlaiveTempest, not v15:IsInRange(18 - 10))) then
						return "glaive_tempest rotation 18";
					end
				end
				v124 = 3 + 0;
			end
		end
	end
	local function v112()
		local v125 = 1541 - (718 + 823);
		while true do
			if ((v125 == (1 + 0)) or ((2400 - (266 + 539)) >= (12666 - 8192))) then
				v37 = EpicSettings.Settings['useDeathSweep'];
				v38 = EpicSettings.Settings['useDemonsBite'];
				v39 = EpicSettings.Settings['useEssenceBreak'];
				v40 = EpicSettings.Settings['useEyeBeam'];
				v125 = 1227 - (636 + 589);
			end
			if (((4 - 2) == v125) or ((9526 - 4907) < (2284 + 598))) then
				v41 = EpicSettings.Settings['useFelBarrage'];
				v42 = EpicSettings.Settings['useFelblade'];
				v43 = EpicSettings.Settings['useFelRush'];
				v44 = EpicSettings.Settings['useGlaiveTempest'];
				v125 = 2 + 1;
			end
			if ((v125 == (1019 - (657 + 358))) or ((778 - 484) >= (11006 - 6175))) then
				v53 = EpicSettings.Settings['useElysianDecree'];
				v54 = EpicSettings.Settings['useMetamorphosis'];
				v55 = EpicSettings.Settings['useTheHunt'];
				v56 = EpicSettings.Settings['elysianDecreeWithCD'];
				v125 = 1192 - (1151 + 36);
			end
			if (((1960 + 69) <= (811 + 2273)) and ((8 - 5) == v125)) then
				v45 = EpicSettings.Settings['useImmolationAura'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v47 = EpicSettings.Settings['useThrowGlaive'];
				v48 = EpicSettings.Settings['useVengefulRetreat'];
				v125 = 1836 - (1552 + 280);
			end
			if ((v125 == (834 - (64 + 770))) or ((1384 + 653) == (5493 - 3073))) then
				v33 = EpicSettings.Settings['useAnnihilation'];
				v34 = EpicSettings.Settings['useBladeDance'];
				v35 = EpicSettings.Settings['useChaosStrike'];
				v36 = EpicSettings.Settings['useConsumeMagic'];
				v125 = 1 + 0;
			end
			if (((5701 - (157 + 1086)) > (7813 - 3909)) and (v125 == (21 - 16))) then
				v57 = EpicSettings.Settings['metamorphosisWithCD'];
				v58 = EpicSettings.Settings['theHuntWithCD'];
				v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
		end
	end
	local function v113()
		v49 = EpicSettings.Settings['useChaosNova'];
		v50 = EpicSettings.Settings['useDisrupt'];
		v51 = EpicSettings.Settings['useFelEruption'];
		v52 = EpicSettings.Settings['useSigilOfMisery'];
		v61 = EpicSettings.Settings['useBlur'];
		v62 = EpicSettings.Settings['useNetherwalk'];
		v63 = EpicSettings.Settings['blurHP'] or (0 - 0);
		v64 = EpicSettings.Settings['netherwalkHP'] or (819 - (599 + 220));
		v78 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v114()
		local v132 = 0 - 0;
		while true do
			if (((2367 - (1813 + 118)) >= (90 + 33)) and (v132 == (1219 - (841 + 376)))) then
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v132 = 3 - 0;
			end
			if (((117 + 383) < (4956 - 3140)) and (v132 == (860 - (464 + 395)))) then
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v132 = 5 - 3;
			end
			if (((1717 + 1857) == (4411 - (467 + 370))) and (v132 == (0 - 0))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v132 = 3 - 2;
			end
			if (((35 + 186) < (907 - 517)) and (v132 == (524 - (150 + 370)))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v132 == (1285 - (74 + 1208))) or ((5443 - 3230) <= (6739 - 5318))) then
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (390 - (14 + 376));
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v132 = 6 - 2;
			end
		end
	end
	local function v115()
		local v133 = 0 + 0;
		while true do
			if (((2687 + 371) < (4636 + 224)) and (v133 == (0 - 0))) then
				v113();
				v112();
				v114();
				v133 = 1 + 0;
			end
			if ((v133 == (80 - (23 + 55))) or ((3071 - 1775) >= (2967 + 1479))) then
				v32 = EpicSettings.Toggles['movement'];
				if (v14:IsDeadOrGhost() or ((1251 + 142) > (6959 - 2470))) then
					return v28;
				end
				v86 = v14:GetEnemiesInMeleeRange(3 + 5);
				v133 = 904 - (652 + 249);
			end
			if ((v133 == (7 - 4)) or ((6292 - (708 + 1160)) < (73 - 46))) then
				v87 = v14:GetEnemiesInMeleeRange(36 - 16);
				if (v30 or ((2024 - (10 + 17)) > (857 + 2958))) then
					local v170 = 1732 - (1400 + 332);
					while true do
						if (((6646 - 3181) > (3821 - (242 + 1666))) and (v170 == (0 + 0))) then
							v88 = ((#v86 > (0 + 0)) and #v86) or (1 + 0);
							v89 = #v87;
							break;
						end
					end
				else
					local v171 = 940 - (850 + 90);
					while true do
						if (((1283 - 550) < (3209 - (360 + 1030))) and (v171 == (0 + 0))) then
							v88 = 2 - 1;
							v89 = 1 - 0;
							break;
						end
					end
				end
				v98 = v14:GCD() + (1661.05 - (909 + 752));
				v133 = 1227 - (109 + 1114);
			end
			if ((v133 == (1 - 0)) or ((1711 + 2684) == (4997 - (6 + 236)))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v133 = 2 + 0;
			end
			if ((v133 == (4 + 0)) or ((8945 - 5152) < (4137 - 1768))) then
				if (v23.TargetIsValid() or v14:AffectingCombat() or ((5217 - (1076 + 57)) == (44 + 221))) then
					local v172 = 689 - (579 + 110);
					while true do
						if (((345 + 4013) == (3854 + 504)) and (v172 == (0 + 0))) then
							v101 = v10.BossFightRemains(nil, true);
							v102 = v101;
							v172 = 408 - (174 + 233);
						end
						if ((v172 == (2 - 1)) or ((5507 - 2369) < (442 + 551))) then
							if (((4504 - (663 + 511)) > (2073 + 250)) and (v102 == (2413 + 8698))) then
								v102 = v10.FightRemains(v86, false);
							end
							break;
						end
					end
				end
				v28 = v107();
				if (v28 or ((11178 - 7552) == (2416 + 1573))) then
					return v28;
				end
				v133 = 11 - 6;
			end
			if (((12 - 7) == v133) or ((438 + 478) == (5198 - 2527))) then
				if (((194 + 78) == (25 + 247)) and v66) then
					local v173 = 722 - (478 + 244);
					while true do
						if (((4766 - (440 + 77)) <= (2201 + 2638)) and (v173 == (0 - 0))) then
							v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 1586 - (655 + 901), true);
							if (((515 + 2262) < (2450 + 750)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((65 + 30) < (7883 - 5926)) and v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v174 = 1445 - (695 + 750);
					local v175;
					while true do
						if (((2820 - 1994) < (2649 - 932)) and (v174 == (0 - 0))) then
							if (((1777 - (285 + 66)) >= (2575 - 1470)) and not v14:AffectingCombat()) then
								local v177 = 1310 - (682 + 628);
								while true do
									if (((444 + 2310) <= (3678 - (176 + 123))) and ((0 + 0) == v177)) then
										v28 = v108();
										if (v28 or ((2849 + 1078) == (1682 - (239 + 30)))) then
											return v28;
										end
										break;
									end
								end
							end
							if ((v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) or ((314 + 840) <= (758 + 30))) then
								if (v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic)) or ((2907 - 1264) > (10541 - 7162))) then
									return "greater_purge damage";
								end
							end
							if ((v79.Felblade:IsCastable() and v42 and v14:PrevGCDP(316 - (306 + 9), v79.VengefulRetreat)) or ((9781 - 6978) > (792 + 3757))) then
								if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((135 + 85) >= (1455 + 1567))) then
									return "felblade rotation 1";
								end
							end
							v174 = 2 - 1;
						end
						if (((4197 - (1140 + 235)) == (1796 + 1026)) and (v174 == (2 + 0))) then
							v92 = v91 and (v14:Fury() < ((20 + 55) - (v24(v79.DemonBlades:IsAvailable()) * (72 - (33 + 19))))) and (v79.BladeDance:CooldownRemains() < v98);
							v93 = v79.Demonic:IsAvailable() and not v79.BlindFury:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (1 + 1))) and (v14:FuryDeficit() > (89 - 59));
							v95 = (v79.Momentum:IsAvailable() and v14:BuffDown(v79.MomentumBuff)) or (v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff));
							v174 = 2 + 1;
						end
						if ((v174 == (9 - 4)) or ((995 + 66) == (2546 - (586 + 103)))) then
							if (((252 + 2508) > (4199 - 2835)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and ((v79.EyeBeam:CooldownRemains() < (v98 * (1490 - (1309 + 179)))) or v14:BuffUp(v79.MetamorphosisBuff)) and (v79.EssenceBreak:CooldownRemains() < (v98 * (5 - 2))) and v14:BuffDown(v79.UnboundChaosBuff) and v14:BuffDown(v79.InertiaBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
								if (v21(v79.ImmolationAura, not v15:IsInRange(4 + 4)) or ((13164 - 8262) <= (2716 + 879))) then
									return "immolation_aura main 5";
								end
							end
							if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:FullRechargeTime() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable()) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > (12 - 6))) and v79.BladeDance:CooldownDown() and ((v14:Fury() < (149 - 74)) or (v79.BladeDance:CooldownRemains() < (v98 * (611 - (295 + 314)))))) or ((9461 - 5609) == (2255 - (1300 + 662)))) then
								if (v21(v79.ImmolationAura, not v15:IsInRange(24 - 16)) or ((3314 - (1178 + 577)) == (2383 + 2205))) then
									return "immolation_aura main 6";
								end
							end
							if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and ((v14:BuffRemains(v79.UnboundChaosBuff) < (v98 * (5 - 3))) or (v15:TimeToDie() < (v98 * (1407 - (851 + 554)))))) or ((3966 + 518) == (2185 - 1397))) then
								if (((9920 - 5352) >= (4209 - (115 + 187))) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fel_rush main 8";
								end
							end
							v174 = 5 + 1;
						end
						if (((1180 + 66) < (13674 - 10204)) and (v174 == (1165 - (160 + 1001)))) then
							if (((3559 + 509) >= (671 + 301)) and v79.ImmolationAura:IsCastable() and v45 and v79.AFireInside:IsAvailable() and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v98 * (3 - 1))) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
								if (((851 - (237 + 121)) < (4790 - (525 + 372))) and v21(v79.ImmolationAura, not v15:IsInRange(14 - 6))) then
									return "immolation_aura main 3";
								end
							end
							if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and (((v79.ImmolationAura:Charges() == (6 - 4)) and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v14:PrevGCDP(143 - (96 + 46), v79.EyeBeam) and v14:BuffUp(v79.InertiaBuff) and (v14:BuffRemains(v79.InertiaBuff) < (780 - (643 + 134)))))) or ((532 + 941) >= (7989 - 4657))) then
								if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((15040 - 10989) <= (1110 + 47))) then
									return "fel_rush main 4";
								end
							end
							if (((1184 - 580) < (5889 - 3008)) and v79.TheHunt:IsCastable() and (v10.CombatTime() < (729 - (316 + 403))) and (not v79.Inertia:IsAvailable() or (v14:BuffUp(v79.MetamorphosisBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)))) then
								if (v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt)) or ((599 + 301) == (9284 - 5907))) then
									return "the_hunt main 6";
								end
							end
							v174 = 2 + 3;
						end
						if (((11229 - 6770) > (419 + 172)) and (v174 == (2 + 4))) then
							if (((11773 - 8375) >= (11438 - 9043)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and ((v79.EyeBeam:CooldownRemains() + (5 - 2)) > v14:BuffRemains(v79.UnboundChaosBuff)) and (v79.BladeDance:CooldownDown() or v79.EssenceBreak:CooldownUp())) then
								if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((125 + 2058) >= (5558 - 2734))) then
									return "fel_rush main 9";
								end
							end
							if (((95 + 1841) == (5695 - 3759)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EssenceBreak:CooldownRemains() > (27 - (12 + 5))))) then
								if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((18767 - 13935) < (9201 - 4888))) then
									return "fel_rush main 10";
								end
							end
							if (((8689 - 4601) > (9606 - 5732)) and (v70 < v102) and v31) then
								local v178 = 0 + 0;
								while true do
									if (((6305 - (1656 + 317)) == (3861 + 471)) and ((0 + 0) == v178)) then
										v28 = v110();
										if (((10633 - 6634) >= (14272 - 11372)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v174 = 361 - (5 + 349);
						end
						if ((v174 == (14 - 11)) or ((3796 - (266 + 1005)) > (2679 + 1385))) then
							v175 = v27(v79.EyeBeam:BaseDuration(), v14:GCD());
							v96 = v79.Demonic:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v102 > (v79.Metamorphosis:CooldownRemains() + (102 - 72) + (v24(v79.ShatteredDestiny:IsAvailable()) * (78 - 18)))) and (v79.Metamorphosis:CooldownRemains() < (1716 - (561 + 1135))) and (v79.Metamorphosis:CooldownRemains() > (v175 + (v98 * (v24(v79.InnerDemon:IsAvailable()) + (2 - 0)))));
							if (((14367 - 9996) == (5437 - (507 + 559))) and v79.ImmolationAura:IsCastable() and v45 and v79.Ragefire:IsAvailable() and (v88 >= (7 - 4)) and (v79.BladeDance:CooldownDown() or v15:DebuffDown(v79.EssenceBreakDebuff))) then
								if (v21(v79.ImmolationAura, not v15:IsInRange(24 - 16)) or ((654 - (212 + 176)) > (5891 - (250 + 655)))) then
									return "immolation_aura main 2";
								end
							end
							v174 = 10 - 6;
						end
						if (((3478 - 1487) >= (1447 - 522)) and (v174 == (1964 - (1869 + 87)))) then
							if (((1578 - 1123) < (3954 - (484 + 1417))) and (v79.DemonBlades:IsAvailable())) then
								if (v21(v79.Pool) or ((1770 - 944) == (8129 - 3278))) then
									return "pool demon_blades";
								end
							end
							break;
						end
						if (((956 - (48 + 725)) == (298 - 115)) and (v174 == (18 - 11))) then
							if (((674 + 485) <= (4778 - 2990)) and v14:BuffUp(v79.MetamorphosisBuff) and (v14:BuffRemains(v79.MetamorphosisBuff) < v98) and (v88 < (1 + 2))) then
								local v179 = 0 + 0;
								while true do
									if ((v179 == (853 - (152 + 701))) or ((4818 - (430 + 881)) > (1654 + 2664))) then
										v28 = v109();
										if (v28 or ((3970 - (557 + 338)) <= (877 + 2088))) then
											return v28;
										end
										break;
									end
								end
							end
							v28 = v111();
							if (((3846 - 2481) <= (7041 - 5030)) and v28) then
								return v28;
							end
							v174 = 21 - 13;
						end
						if ((v174 == (2 - 1)) or ((3577 - (499 + 302)) > (4441 - (39 + 827)))) then
							if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v15:NPCID())) or ((7050 - 4496) == (10728 - 5924))) then
								if (((10235 - 7658) == (3956 - 1379)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fodder to the flames react per target";
								end
							end
							if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v16:NPCID())) or ((1 + 5) >= (5528 - 3639))) then
								if (((81 + 425) <= (2993 - 1101)) and v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v91 = v79.FirstBlood:IsAvailable() or v79.TrailofRuin:IsAvailable() or (v79.ChaosTheory:IsAvailable() and v14:BuffDown(v79.ChaosTheoryBuff)) or (v88 > (105 - (103 + 1)));
							v174 = 556 - (475 + 79);
						end
					end
				end
				break;
			end
		end
	end
	local function v116()
		v79.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(1247 - 670, v115, v116);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

