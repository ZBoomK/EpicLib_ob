local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2201 - 1331) >= (1688 + 1388))) then
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
	local v83 = (v82[45 - 32] and v18(v82[7 + 6])) or v18(0 + 0);
	local v84 = (v82[13 + 1] and v18(v82[47 - 33])) or v18(1994 - (109 + 1885));
	local v85, v86;
	local v87, v88;
	local v89 = {{v78.FelEruption},{v78.ChaosNova}};
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = ((v78.AFireInside:IsAvailable()) and (8 - 3)) or (1 - 0);
	local v97 = v13:GCD() + 0.25 + 0;
	local v98 = 0 + 0;
	local v99 = false;
	local v100 = 1826 + 9285;
	local v101 = 2397 + 8714;
	local v102 = {(564978 - 395557),(68967 + 100458),(122836 + 46096),(170859 - (797 + 636)),(171048 - (1427 + 192)),(393373 - 223945),(76783 + 92647)};
	v9:RegisterForEvent(function()
		local v116 = 326 - (192 + 134);
		while true do
			if (((2905 - (316 + 960)) > (669 + 533)) and (v116 == (3 + 0))) then
				v101 = 10270 + 841;
				break;
			end
			if (((3853 - 2845) < (4262 - (83 + 468))) and (v116 == (1807 - (1202 + 604)))) then
				v92 = false;
				v93 = false;
				v116 = 9 - 7;
			end
			if ((v116 == (0 - 0)) or ((2904 - 1855) <= (1231 - (45 + 280)))) then
				v90 = false;
				v91 = false;
				v116 = 1 + 0;
			end
			if (((3943 + 570) > (996 + 1730)) and (v116 == (2 + 0))) then
				v94 = false;
				v100 = 1955 + 9156;
				v116 = 5 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v82 = v13:GetEquipment();
		v83 = (v82[1924 - (340 + 1571)] and v18(v82[6 + 7])) or v18(1772 - (1733 + 39));
		v84 = (v82[38 - 24] and v18(v82[1048 - (125 + 909)])) or v18(1948 - (1096 + 852));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v96 = ((v78.AFireInside:IsAvailable()) and (3 + 2)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v103(v117)
		return v117:DebuffRemains(v78.BurningWoundDebuff) or v117:DebuffRemains(v78.BurningWoundLegDebuff);
	end
	local function v104(v118)
		return v78.BurningWound:IsAvailable() and (v118:DebuffRemains(v78.BurningWoundDebuff) < (4 + 0)) and (v78.BurningWoundDebuff:AuraActiveCount() < v25(v87, 515 - (409 + 103)));
	end
	local function v105()
		local v119 = 236 - (46 + 190);
		while true do
			if (((95 - (51 + 44)) == v119) or ((418 + 1063) >= (3975 - (1114 + 203)))) then
				v27 = v22.HandleTopTrinket(v81, v30, 766 - (228 + 498), nil);
				if (v27 or ((698 + 2522) == (754 + 610))) then
					return v27;
				end
				v119 = 664 - (174 + 489);
			end
			if ((v119 == (2 - 1)) or ((2959 - (830 + 1075)) > (3916 - (303 + 221)))) then
				v27 = v22.HandleBottomTrinket(v81, v30, 1309 - (231 + 1038), nil);
				if (v27 or ((564 + 112) >= (2804 - (171 + 991)))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v106()
		local v120 = 0 - 0;
		while true do
			if (((11105 - 6969) > (5981 - 3584)) and (v120 == (1 + 0))) then
				if ((v79.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v75)) or ((15192 - 10858) == (12246 - 8001))) then
					if (v20(v80.Healthstone) or ((6892 - 2616) <= (9369 - 6338))) then
						return "healthstone defensive";
					end
				end
				if ((v72 and (v13:HealthPercentage() <= v74)) or ((6030 - (111 + 1137)) <= (1357 - (91 + 67)))) then
					if ((v76 == "Refreshing Healing Potion") or ((14476 - 9612) < (475 + 1427))) then
						if (((5362 - (423 + 100)) >= (26 + 3674)) and v79.RefreshingHealingPotion:IsReady()) then
							if (v20(v80.RefreshingHealingPotion) or ((2976 - 1901) > (1000 + 918))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((1167 - (326 + 445)) <= (16600 - 12796)) and (v76 == "Dreamwalker's Healing Potion")) then
						if (v79.DreamwalkersHealingPotion:IsReady() or ((9287 - 5118) == (5104 - 2917))) then
							if (((2117 - (530 + 181)) == (2287 - (614 + 267))) and v20(v80.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1563 - (19 + 13)) < (6951 - 2680)) and (v120 == (0 - 0))) then
				if (((1813 - 1178) == (165 + 470)) and v78.Blur:IsCastable() and v60 and (v13:HealthPercentage() <= v62)) then
					if (((5931 - 2558) <= (7374 - 3818)) and v20(v78.Blur)) then
						return "blur defensive";
					end
				end
				if ((v78.Netherwalk:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) or ((5103 - (1293 + 519)) < (6692 - 3412))) then
					if (((11451 - 7065) >= (1669 - 796)) and v20(v78.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v120 = 4 - 3;
			end
		end
	end
	local function v107()
		local v121 = 0 - 0;
		while true do
			if (((488 + 433) <= (225 + 877)) and (v121 == (0 - 0))) then
				if (((1088 + 3618) >= (320 + 643)) and v78.ImmolationAura:IsCastable() and v44) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(5 + 3)) or ((2056 - (709 + 387)) <= (2734 - (673 + 1185)))) then
						return "immolation_aura precombat 8";
					end
				end
				if ((v45 and not v13:IsMoving() and (v87 > (2 - 1)) and v78.SigilOfFlame:IsCastable()) or ((6634 - 4568) == (1532 - 600))) then
					if (((3452 + 1373) < (3619 + 1224)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(10 - 2)) or ((953 + 2924) >= (9045 - 4508))) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v77 == "cursor") or ((8470 - 4155) < (3606 - (446 + 1434)))) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(1323 - (1040 + 243))) or ((10980 - 7301) < (2472 - (559 + 1288)))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v121 = 1932 - (609 + 1322);
			end
			if ((v121 == (455 - (13 + 441))) or ((17282 - 12657) < (1655 - 1023))) then
				if ((not v14:IsInMeleeRange(24 - 19) and v78.Felblade:IsCastable() and v41) or ((4 + 79) > (6464 - 4684))) then
					if (((194 + 352) <= (472 + 605)) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
						return "felblade precombat 9";
					end
				end
				if ((not v14:IsInMeleeRange(14 - 9) and v78.ThrowGlaive:IsCastable() and v46) or ((546 + 450) > (7910 - 3609))) then
					if (((2691 + 1379) > (383 + 304)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive precombat 9";
					end
				end
				v121 = 2 + 0;
			end
			if ((v121 == (2 + 0)) or ((642 + 14) >= (3763 - (153 + 280)))) then
				if ((not v14:IsInMeleeRange(14 - 9) and v78.FelRush:IsCastable() and (not v78.Felblade:IsAvailable() or (v78.Felblade:CooldownDown() and not v13:PrevGCDP(1 + 0, v78.Felblade))) and v31 and v42) or ((984 + 1508) <= (176 + 159))) then
					if (((3923 + 399) >= (1857 + 705)) and v20(v78.FelRush, not v14:IsInRange(22 - 7))) then
						return "fel_rush precombat 10";
					end
				end
				if ((v14:IsInMeleeRange(4 + 1) and v37 and (v78.DemonsBite:IsCastable() or v78.DemonBlades:IsAvailable())) or ((4304 - (89 + 578)) >= (2694 + 1076))) then
					if (v20(v78.DemonsBite, not v14:IsInMeleeRange(10 - 5)) or ((3428 - (572 + 477)) > (618 + 3960))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v108()
		if (v13:BuffDown(v78.FelBarrage) or ((290 + 193) > (89 + 654))) then
			if (((2540 - (84 + 2)) > (952 - 374)) and v78.DeathSweep:IsReady() and v36) then
				if (((670 + 260) < (5300 - (497 + 345))) and v20(v78.DeathSweep, not v14:IsInRange(1 + 7))) then
					return "death_sweep meta_end 2";
				end
			end
			if (((112 + 550) <= (2305 - (605 + 728))) and v78.Annihilation:IsReady() and v32) then
				if (((3118 + 1252) == (9715 - 5345)) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v109()
		local v122 = 0 + 0;
		local v123;
		while true do
			if (((7 - 5) == v122) or ((4293 + 469) <= (2385 - 1524))) then
				if ((v52 and not v13:IsMoving() and ((v30 and v55) or not v55) and v78.ElysianDecree:IsCastable() and (v14:DebuffDown(v78.EssenceBreakDebuff)) and (v87 > v59)) or ((1067 + 345) == (4753 - (457 + 32)))) then
					if ((v58 == "player") or ((1345 + 1823) < (3555 - (832 + 570)))) then
						if (v20(v80.ElysianDecreePlayer, not v14:IsInRange(8 + 0)) or ((1298 + 3678) < (4713 - 3381))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif (((2230 + 2398) == (5424 - (588 + 208))) and (v58 == "cursor")) then
						if (v20(v80.ElysianDecreeCursor, not v14:IsInRange(80 - 50)) or ((1854 - (884 + 916)) == (826 - 431))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if (((48 + 34) == (735 - (232 + 421))) and (v69 < v101)) then
					if ((v70 and ((v30 and v71) or not v71)) or ((2470 - (1569 + 320)) < (70 + 212))) then
						local v174 = 0 + 0;
						while true do
							if ((v174 == (0 - 0)) or ((5214 - (316 + 289)) < (6531 - 4036))) then
								v27 = v105();
								if (((54 + 1098) == (2605 - (666 + 787))) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((2321 - (360 + 65)) <= (3199 + 223)) and ((255 - (79 + 175)) == v122)) then
				v123 = v22.HandleDPSPotion(v13:BuffUp(v78.MetamorphosisBuff));
				if (v123 or ((1561 - 571) > (1265 + 355))) then
					return v123;
				end
				v122 = 5 - 3;
			end
			if ((v122 == (0 - 0)) or ((1776 - (503 + 396)) > (4876 - (92 + 89)))) then
				if (((5220 - 2529) >= (950 + 901)) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and not v78.Demonic:IsAvailable()) then
					if (v20(v80.MetamorphosisPlayer, not v14:IsInRange(5 + 3)) or ((11689 - 8704) >= (665 + 4191))) then
						return "metamorphosis cooldown 4";
					end
				end
				if (((9749 - 5473) >= (1043 + 152)) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and v78.Demonic:IsAvailable() and ((not v78.ChaoticTransformation:IsAvailable() and v78.EyeBeam:CooldownDown()) or ((v78.EyeBeam:CooldownRemains() > (10 + 10)) and (not v90 or v13:PrevGCDP(2 - 1, v78.DeathSweep) or v13:PrevGCDP(1 + 1, v78.DeathSweep))) or ((v101 < ((38 - 13) + (v23(v78.ShatteredDestiny:IsAvailable()) * (1314 - (485 + 759))))) and v78.EyeBeam:CooldownDown() and v78.BladeDance:CooldownDown())) and v13:BuffDown(v78.InnerDemonBuff)) then
					if (((7478 - 4246) <= (5879 - (442 + 747))) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(1143 - (832 + 303)))) then
						return "metamorphosis cooldown 6";
					end
				end
				v122 = 947 - (88 + 858);
			end
		end
	end
	local function v110()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (3 + 0)) or ((37 + 859) >= (3935 - (766 + 23)))) then
				if (((15111 - 12050) >= (4045 - 1087)) and v78.TheHunt:IsCastable() and v31 and v54 and (v69 < v101) and ((v30 and v57) or not v57) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v9.CombatTime() < (26 - 16)) or (v78.Metamorphosis:CooldownRemains() > (33 - 23))) and ((v87 == (1074 - (1036 + 37))) or (v87 > (3 + 0)) or (v101 < (19 - 9))) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and (not v78.FuriousGaze:IsAvailable() or v13:BuffUp(v78.FuriousGazeBuff) or v13:HasTier(25 + 6, 1484 - (641 + 839)))) or not v13:HasTier(943 - (910 + 3), 4 - 2)) and (v9.CombatTime() > (1694 - (1466 + 218)))) then
					if (((1465 + 1722) >= (1792 - (556 + 592))) and v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if (((230 + 414) <= (1512 - (329 + 479))) and v78.FelBarrage:IsCastable() and v40 and ((v87 > (855 - (174 + 680))) or ((v87 == (3 - 2)) and (v13:FuryDeficit() < (41 - 21)) and v13:BuffDown(v78.MetamorphosisBuff)))) then
					if (((684 + 274) > (1686 - (396 + 343))) and v20(v78.FelBarrage, not v14:IsInRange(1 + 7))) then
						return "fel_barrage rotation 16";
					end
				end
				if (((5969 - (29 + 1448)) >= (4043 - (135 + 1254))) and v78.GlaiveTempest:IsReady() and v43 and (v14:DebuffDown(v78.EssenceBreakDebuff) or (v87 > (3 - 2))) and v13:BuffDown(v78.FelBarrage)) then
					if (((16071 - 12629) >= (1002 + 501)) and v20(v78.GlaiveTempest, not v14:IsInRange(1535 - (389 + 1138)))) then
						return "glaive_tempest rotation 18";
					end
				end
				if ((v78.Annihilation:IsReady() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v78.FelBarrage)) or ((3744 - (102 + 472)) <= (1382 + 82))) then
					if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((2661 + 2136) == (4092 + 296))) then
						return "annihilation rotation 20";
					end
				end
				v124 = 1549 - (320 + 1225);
			end
			if (((980 - 429) <= (417 + 264)) and (v124 == (1468 - (157 + 1307)))) then
				if (((5136 - (821 + 1038)) > (1015 - 608)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (1 + 2))) and (v13:BuffRemains(v78.MomentumBuff) < (8 - 3)) and v13:BuffDown(v78.MetamorphosisBuff)) then
					if (((1747 + 2948) >= (3507 - 2092)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 22";
					end
				end
				if ((v78.EyeBeam:IsCastable() and v39 and not v13:PrevGCDP(1027 - (834 + 192), v78.VengefulRetreat) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.Metamorphosis:CooldownRemains() > ((2 + 28) - (v23(v78.CycleOfHatred:IsAvailable()) * (4 + 11)))) or ((v78.Metamorphosis:CooldownRemains() < (v97 * (1 + 1))) and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() < (v97 * (1.5 - 0)))))) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > v97) or not v78.RestlessHunter:IsAvailable()) and (v78.CycleOfHatred:IsAvailable() or not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (309 - (300 + 4))) or not v47 or (v9.CombatTime() < (3 + 7))) and v13:BuffDown(v78.InnerDemonBuff)) or (v101 < (39 - 24)))) or ((3574 - (112 + 250)) <= (377 + 567))) then
					if (v20(v78.EyeBeam, not v14:IsInRange(19 - 11)) or ((1774 + 1322) <= (930 + 868))) then
						return "eye_beam rotation 26";
					end
				end
				if (((2646 + 891) == (1754 + 1783)) and v78.BladeDance:IsCastable() and v33 and v90 and ((v78.EyeBeam:CooldownRemains() > (4 + 1)) or not v78.Demonic:IsAvailable() or v13:HasTier(1445 - (1001 + 413), 4 - 2))) then
					if (((4719 - (244 + 638)) >= (2263 - (627 + 66))) and v20(v78.BladeDance, not v14:IsInRange(23 - 15))) then
						return "blade_dance rotation 28";
					end
				end
				if ((v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff) and (v87 >= (606 - (512 + 90)))) or ((4856 - (1665 + 241)) == (4529 - (373 + 344)))) then
					if (((2131 + 2592) >= (614 + 1704)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(20 - 12)) or ((3430 - 1403) > (3951 - (35 + 1064)))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif ((v77 == "cursor") or ((827 + 309) > (9236 - 4919))) then
						if (((19 + 4729) == (5984 - (298 + 938))) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(1299 - (233 + 1026)))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				v124 = 1671 - (636 + 1030);
			end
			if (((1911 + 1825) <= (4630 + 110)) and (v124 == (2 + 3))) then
				if ((v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v87 >= ((223 - (55 + 166)) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.ThrowGlaive:FullRechargeTime() < (v97 * (1 + 2))) or (v87 > (1 + 0))) and not v13:HasTier(118 - 87, 299 - (36 + 261))) or ((5928 - 2538) <= (4428 - (34 + 1334)))) then
					if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((385 + 614) > (2093 + 600))) then
						return "throw_glaive rotation 32";
					end
				end
				if (((1746 - (1035 + 248)) < (622 - (20 + 1))) and v78.ImmolationAura:IsCastable() and v44 and (v87 >= (2 + 0)) and (v13:Fury() < (389 - (134 + 185))) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(1141 - (549 + 584))) or ((2868 - (314 + 371)) < (2358 - 1671))) then
						return "immolation_aura rotation 34";
					end
				end
				if (((5517 - (478 + 490)) == (2410 + 2139)) and ((v78.Annihilation:IsCastable() and v32 and not v91 and ((v78.EssenceBreak:CooldownRemains() > (1172 - (786 + 386))) or not v78.EssenceBreak:IsAvailable()) and v13:BuffDown(v78.FelBarrage)) or v13:HasTier(97 - 67, 1381 - (1055 + 324)))) then
					if (((6012 - (1093 + 247)) == (4152 + 520)) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
						return "annihilation rotation 36";
					end
				end
				if ((v78.Felblade:IsCastable() and v41 and (((v13:FuryDeficit() >= (5 + 35)) and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)))) or ((14562 - 10894) < (1340 - 945))) then
					if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((11854 - 7688) == (1143 - 688))) then
						return "felblade rotation 38";
					end
				end
				v124 = 3 + 3;
			end
			if ((v124 == (34 - 25)) or ((15334 - 10885) == (2008 + 655))) then
				if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) <= (51 - 31))) or ((4965 - (364 + 324)) < (8193 - 5204))) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2087 - 1217) >= (1376 + 2773))) then
						return "fel_rush rotation 58";
					end
				end
				if (((9255 - 7043) < (5097 - 1914)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v14:IsInRange(24 - 16) and not v78.Momentum:IsAvailable()) then
					if (((5914 - (1249 + 19)) > (2701 + 291)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				if (((5581 - 4147) < (4192 - (686 + 400))) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and not v78.Initiative:IsAvailable() and not v14:IsInRange(7 + 1)) then
					if (((1015 - (73 + 156)) < (15 + 3008)) and v20(v78.VengefulRetreat, not v14:IsInRange(819 - (721 + 90)), nil, true)) then
						return "vengeful_retreat rotation 60";
					end
				end
				if ((v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and (v78.DemonBlades:IsAvailable() or not v14:IsInRange(38 - 26)) and v14:DebuffDown(v78.EssenceBreakDebuff) and v14:IsSpellInRange(v78.ThrowGlaive) and not v13:HasTier(501 - (224 + 246), 2 - 0)) or ((4495 - 2053) < (14 + 60))) then
					if (((108 + 4427) == (3331 + 1204)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if ((v124 == (13 - 6)) or ((10013 - 7004) <= (2618 - (203 + 310)))) then
				if (((3823 - (1238 + 755)) < (257 + 3412)) and v78.ChaosStrike:IsReady() and v34 and not v91 and not v92 and v13:BuffDown(v78.FelBarrage)) then
					if (v20(v78.ChaosStrike, not v14:IsSpellInRange(v78.ChaosStrike)) or ((2964 - (709 + 825)) >= (6655 - 3043))) then
						return "chaos_strike rotation 46";
					end
				end
				if (((3907 - 1224) >= (3324 - (196 + 668))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and (v13:FuryDeficit() >= (118 - 88))) then
					if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((3736 - 1932) >= (4108 - (171 + 662)))) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(101 - (4 + 89))) or ((4966 - 3549) > (1322 + 2307))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif (((21060 - 16265) > (158 + 244)) and (v77 == "cursor")) then
						if (((6299 - (35 + 1451)) > (5018 - (28 + 1425))) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(2023 - (941 + 1052)))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				if (((3752 + 160) == (5426 - (822 + 692))) and v78.Felblade:IsCastable() and v41 and (v13:FuryDeficit() >= (57 - 17))) then
					if (((1329 + 1492) <= (5121 - (45 + 252))) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
						return "felblade rotation 50";
					end
				end
				if (((1720 + 18) <= (756 + 1439)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and v78.DemonBlades:IsAvailable() and v78.EyeBeam:CooldownDown() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.FelRush:Recharge() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable())) then
					if (((99 - 58) <= (3451 - (114 + 319))) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 52";
					end
				end
				v124 = 11 - 3;
			end
			if (((2748 - 603) <= (2617 + 1487)) and (v124 == (8 - 2))) then
				if (((5633 - 2944) < (6808 - (556 + 1407))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (1236 - (741 + 465)))) then
					if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((2787 - (170 + 295)) > (1382 + 1240))) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(8 + 0)) or ((11162 - 6628) == (1726 + 356))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif ((v77 == "cursor") or ((1008 + 563) > (1058 + 809))) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(1270 - (957 + 273))) or ((710 + 1944) >= (1200 + 1796))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				if (((15157 - 11179) > (5544 - 3440)) and v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(2 - 1, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v88 >= ((9 - 7) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and not v13:HasTier(1811 - (389 + 1391), 2 + 0)) then
					if (((312 + 2683) > (3508 - 1967)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "throw_glaive rotation 40";
					end
				end
				if (((4200 - (783 + 168)) > (3198 - 2245)) and v78.ImmolationAura:IsCastable() and v44 and (v13:BuffStack(v78.ImmolationAuraBuff) < v96) and v14:IsInRange(8 + 0) and (v13:BuffDown(v78.UnboundChaosBuff) or not v78.UnboundChaos:IsAvailable()) and ((v78.ImmolationAura:Recharge() < v78.EssenceBreak:CooldownRemains()) or (not v78.EssenceBreak:IsAvailable() and (v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge())))) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(319 - (309 + 2))) or ((10051 - 6778) > (5785 - (1090 + 122)))) then
						return "immolation_aura rotation 42";
					end
				end
				if ((v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v78.ThrowGlaive:FullRechargeTime() < v78.BladeDance:CooldownRemains()) and v13:HasTier(104 - 73, 2 + 0) and v13:BuffDown(v78.FelBarrage) and not v92) or ((4269 - (628 + 490)) < (231 + 1053))) then
					if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((4580 - 2730) == (6987 - 5458))) then
						return "throw_glaive rotation 44";
					end
				end
				v124 = 781 - (431 + 343);
			end
			if (((1657 - 836) < (6141 - 4018)) and (v124 == (0 + 0))) then
				if (((116 + 786) < (4020 - (556 + 1139))) and v78.EssenceBreak:IsCastable() and v38 and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (25 - (6 + 9))))) then
					if (((158 + 700) <= (1518 + 1444)) and v20(v78.EssenceBreak, not v14:IsInRange(177 - (28 + 141)))) then
						return "essence_break rotation prio";
					end
				end
				if ((v78.BladeDance:IsCastable() and v33 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((1529 + 2417) < (1589 - 301))) then
					if (v20(v78.BladeDance, not v14:IsInRange(6 + 2)) or ((4559 - (486 + 831)) == (1475 - 908))) then
						return "blade_dance rotation prio";
					end
				end
				if ((v78.DeathSweep:IsCastable() and v36 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((2981 - 2134) >= (239 + 1024))) then
					if (v20(v78.DeathSweep, not v14:IsInRange(25 - 17)) or ((3516 - (668 + 595)) == (1666 + 185))) then
						return "death_sweep rotation prio";
					end
				end
				if ((v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.Metamorphosis:CooldownRemains() <= (v13:GCD() * (1 + 2)))) or ((5691 - 3604) > (2662 - (23 + 267)))) then
					if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((6389 - (1129 + 815)) < (4536 - (371 + 16)))) then
						return "annihilation rotation 2";
					end
				end
				v124 = 1751 - (1326 + 424);
			end
			if ((v124 == (14 - 6)) or ((6643 - 4825) == (203 - (88 + 30)))) then
				if (((1401 - (720 + 51)) < (4731 - 2604)) and v78.DemonsBite:IsCastable() and v37 and v78.BurningWound:IsAvailable() and (v14:DebuffRemains(v78.BurningWoundDebuff) < (1780 - (421 + 1355)))) then
					if (v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite)) or ((3197 - 1259) == (1235 + 1279))) then
						return "demons_bite rotation 54";
					end
				end
				if (((5338 - (286 + 797)) >= (200 - 145)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and not v78.DemonBlades:IsAvailable() and (v87 > (1 - 0)) and v13:BuffDown(v78.UnboundChaosBuff)) then
					if (((3438 - (397 + 42)) > (362 + 794)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 56";
					end
				end
				if (((3150 - (24 + 776)) > (1779 - 624)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (815 - (222 + 563))) and v14:IsInRange(66 - 36)) then
					if (((2901 + 1128) <= (5043 - (23 + 167))) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
						if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1806 - (690 + 1108))) or ((187 + 329) > (2833 + 601))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif (((4894 - (40 + 808)) >= (500 + 2533)) and (v77 == "cursor")) then
						if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(114 - 84)) or ((2599 + 120) <= (766 + 681))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				if ((v78.DemonsBite:IsCastable() and v37) or ((2267 + 1867) < (4497 - (47 + 524)))) then
					if (v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite)) or ((107 + 57) >= (7612 - 4827))) then
						return "demons_bite rotation 57";
					end
				end
				v124 = 12 - 3;
			end
			if ((v124 == (2 - 1)) or ((2251 - (1165 + 561)) == (63 + 2046))) then
				if (((102 - 69) == (13 + 20)) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and (v78.EyeBeam:CooldownRemains() < (479.3 - (341 + 138))) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1 + 1))) and (v9.CombatTime() > (10 - 5)) and (v13:Fury() >= (356 - (89 + 237))) and v78.Inertia:IsAvailable()) then
					if (((9824 - 6770) <= (8452 - 4437)) and v20(v78.VengefulRetreat, not v14:IsInRange(889 - (581 + 300)), nil, true)) then
						return "vengeful_retreat rotation 3";
					end
				end
				if (((3091 - (855 + 365)) < (8032 - 4650)) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and ((v78.EssenceBreak:CooldownRemains() > (1250 - (1030 + 205))) or ((v78.EssenceBreak:CooldownRemains() < v97) and (not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (15 + 0 + ((10 + 0) * v23(v78.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (316 - (156 + 130))) or ((v13:GCDRemains() - (2 - 1)) < (0 - 0))) and (not v78.Initiative:IsAvailable() or (v13:BuffRemains(v78.InitiativeBuff) < v97) or (v9.CombatTime() > (7 - 3)))) then
					if (((341 + 952) <= (1264 + 902)) and v20(v78.VengefulRetreat, not v14:IsInRange(77 - (10 + 59)), nil, true)) then
						return "vengeful_retreat rotation 4";
					end
				end
				if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and ((v78.EssenceBreak:CooldownRemains() > (73 - 58)) or ((v78.EssenceBreak:CooldownRemains() < (v97 * (1165 - (671 + 492)))) and (((v13:BuffRemains(v78.InitiativeBuff) < v97) and not v95 and (v78.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (24 + 6))) or not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((1230 - (369 + 846)) + ((3 + 7) * v23(v78.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v78.UnboundChaosBuff) or v13:BuffUp(v78.InertiaBuff))) or ((2201 + 378) < (2068 - (1036 + 909)))) then
					if (v20(v78.VengefulRetreat, not v14:IsInRange(7 + 1), nil, true) or ((1420 - 574) >= (2571 - (11 + 192)))) then
						return "vengeful_retreat rotation 6";
					end
				end
				if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and not v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and (v13:BuffDown(v78.InitiativeBuff) or (v13:PrevGCDP(176 - (135 + 40), v78.DeathSweep) and v78.Metamorphosis:CooldownUp() and v78.ChaoticTransformation:IsAvailable())) and v78.Initiative:IsAvailable()) or ((9720 - 5708) <= (2025 + 1333))) then
					if (((3291 - 1797) <= (4504 - 1499)) and v20(v78.VengefulRetreat, not v14:IsInRange(184 - (50 + 126)), nil, true)) then
						return "vengeful_retreat rotation 8";
					end
				end
				v124 = 5 - 3;
			end
			if ((v124 == (1 + 1)) or ((4524 - (1233 + 180)) == (3103 - (522 + 447)))) then
				if (((3776 - (107 + 1314)) == (1093 + 1262)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) < (v97 * (5 - 3))) and (v78.EyeBeam:CooldownRemains() <= v97) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) then
					if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((250 + 338) <= (857 - 425))) then
						return "fel_rush rotation 10";
					end
				end
				if (((18979 - 14182) >= (5805 - (716 + 1194))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or ((v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge()) and (v78.EyeBeam:CooldownRemains() > (1 + 3)))) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) then
					if (((384 + 3193) == (4080 - (74 + 429))) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
						return "fel_rush rotation 11";
					end
				end
				if (((7318 - 3524) > (1831 + 1862)) and v78.EssenceBreak:IsCastable() and v38 and ((((v13:BuffRemains(v78.MetamorphosisBuff) > (v97 * (6 - 3))) or (v78.EyeBeam:CooldownRemains() > (8 + 2))) and (not v78.TacticalRetreat:IsAvailable() or v13:BuffUp(v78.TacticalRetreatBuff) or (v9.CombatTime() < (30 - 20))) and (v78.BladeDance:CooldownRemains() <= ((7.1 - 4) * v97))) or (v101 < (439 - (279 + 154))))) then
					if (v20(v78.EssenceBreak, not v14:IsInRange(786 - (454 + 324))) or ((1004 + 271) == (4117 - (12 + 5)))) then
						return "essence_break rotation 13";
					end
				end
				if ((v78.DeathSweep:IsCastable() and v36 and v90 and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() > (v97 * (2 + 0)))) and v13:BuffDown(v78.FelBarrage)) or ((4053 - 2462) >= (1323 + 2257))) then
					if (((2076 - (277 + 816)) <= (7725 - 5917)) and v20(v78.DeathSweep, not v14:IsInRange(1191 - (1058 + 125)))) then
						return "death_sweep rotation 14";
					end
				end
				v124 = 1 + 2;
			end
		end
	end
	local function v111()
		local v125 = 975 - (815 + 160);
		while true do
			if ((v125 == (0 - 0)) or ((5103 - 2953) <= (286 + 911))) then
				v32 = EpicSettings.Settings['useAnnihilation'];
				v33 = EpicSettings.Settings['useBladeDance'];
				v34 = EpicSettings.Settings['useChaosStrike'];
				v125 = 2 - 1;
			end
			if (((5667 - (41 + 1857)) >= (3066 - (1222 + 671))) and (v125 == (7 - 4))) then
				v41 = EpicSettings.Settings['useFelblade'];
				v42 = EpicSettings.Settings['useFelRush'];
				v43 = EpicSettings.Settings['useGlaiveTempest'];
				v125 = 5 - 1;
			end
			if (((2667 - (229 + 953)) == (3259 - (1111 + 663))) and (v125 == (1586 - (874 + 705)))) then
				v57 = EpicSettings.Settings['theHuntWithCD'];
				v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				break;
			end
			if ((v125 == (5 + 1)) or ((6890 - 3575) <= (79 + 2703))) then
				v54 = EpicSettings.Settings['useTheHunt'];
				v55 = EpicSettings.Settings['elysianDecreeWithCD'];
				v56 = EpicSettings.Settings['metamorphosisWithCD'];
				v125 = 686 - (642 + 37);
			end
			if ((v125 == (2 + 3)) or ((141 + 735) >= (7441 - 4477))) then
				v47 = EpicSettings.Settings['useVengefulRetreat'];
				v52 = EpicSettings.Settings['useElysianDecree'];
				v53 = EpicSettings.Settings['useMetamorphosis'];
				v125 = 460 - (233 + 221);
			end
			if ((v125 == (2 - 1)) or ((1965 + 267) > (4038 - (718 + 823)))) then
				v35 = EpicSettings.Settings['useConsumeMagic'];
				v36 = EpicSettings.Settings['useDeathSweep'];
				v37 = EpicSettings.Settings['useDemonsBite'];
				v125 = 2 + 0;
			end
			if ((v125 == (809 - (266 + 539))) or ((5973 - 3863) <= (1557 - (636 + 589)))) then
				v44 = EpicSettings.Settings['useImmolationAura'];
				v45 = EpicSettings.Settings['useSigilOfFlame'];
				v46 = EpicSettings.Settings['useThrowGlaive'];
				v125 = 11 - 6;
			end
			if (((7602 - 3916) > (2514 + 658)) and (v125 == (1 + 1))) then
				v38 = EpicSettings.Settings['useEssenceBreak'];
				v39 = EpicSettings.Settings['useEyeBeam'];
				v40 = EpicSettings.Settings['useFelBarrage'];
				v125 = 1018 - (657 + 358);
			end
		end
	end
	local function v112()
		v48 = EpicSettings.Settings['useChaosNova'];
		v49 = EpicSettings.Settings['useDisrupt'];
		v50 = EpicSettings.Settings['useFelEruption'];
		v51 = EpicSettings.Settings['useSigilOfMisery'];
		v60 = EpicSettings.Settings['useBlur'];
		v61 = EpicSettings.Settings['useNetherwalk'];
		v62 = EpicSettings.Settings['blurHP'] or (0 - 0);
		v63 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
		v77 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v113()
		local v132 = 1187 - (1151 + 36);
		while true do
			if ((v132 == (0 + 0)) or ((1177 + 3297) < (2448 - 1628))) then
				v69 = EpicSettings.Settings['fightRemainsCheck'] or (1832 - (1552 + 280));
				v64 = EpicSettings.Settings['dispelBuffs'];
				v66 = EpicSettings.Settings['InterruptWithStun'];
				v67 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v132 = 835 - (64 + 770);
			end
			if (((2906 + 1373) >= (6541 - 3659)) and (v132 == (1 + 0))) then
				v68 = EpicSettings.Settings['InterruptThreshold'];
				v70 = EpicSettings.Settings['useTrinkets'];
				v71 = EpicSettings.Settings['trinketsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v132 = 1245 - (157 + 1086);
			end
			if (((3 - 1) == v132) or ((8886 - 6857) >= (5400 - 1879))) then
				v72 = EpicSettings.Settings['useHealingPotion'];
				v75 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v74 = EpicSettings.Settings['healingPotionHP'] or (819 - (599 + 220));
				v76 = EpicSettings.Settings['HealingPotionName'] or "";
				v132 = 5 - 2;
			end
			if ((v132 == (1934 - (1813 + 118))) or ((1490 + 547) >= (5859 - (841 + 376)))) then
				v65 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v114()
		local v133 = 0 - 0;
		while true do
			if (((400 + 1320) < (12168 - 7710)) and (v133 == (861 - (464 + 395)))) then
				v85 = v13:GetEnemiesInMeleeRange(20 - 12);
				v86 = v13:GetEnemiesInMeleeRange(10 + 10);
				if (v29 or ((1273 - (467 + 370)) > (6242 - 3221))) then
					local v170 = 0 + 0;
					while true do
						if (((2444 - 1731) <= (133 + 714)) and (v170 == (0 - 0))) then
							v87 = ((#v85 > (520 - (150 + 370))) and #v85) or (1283 - (74 + 1208));
							v88 = #v86;
							break;
						end
					end
				else
					v87 = 2 - 1;
					v88 = 4 - 3;
				end
				v97 = v13:GCD() + 0.05 + 0;
				v133 = 393 - (14 + 376);
			end
			if (((3735 - 1581) <= (2609 + 1422)) and (v133 == (4 + 0))) then
				if (((4402 + 213) == (13522 - 8907)) and v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					if (not v13:AffectingCombat() or ((2852 + 938) == (578 - (23 + 55)))) then
						v27 = v107();
						if (((210 - 121) < (148 + 73)) and v27) then
							return v27;
						end
					end
					if (((1845 + 209) >= (2203 - 782)) and v78.ConsumeMagic:IsAvailable() and v35 and v78.ConsumeMagic:IsReady() and v64 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) then
						if (((218 + 474) < (3959 - (652 + 249))) and v20(v78.ConsumeMagic, not v14:IsSpellInRange(v78.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if ((v78.Felblade:IsCastable() and v41 and v13:PrevGCDP(2 - 1, v78.VengefulRetreat)) or ((5122 - (708 + 1160)) == (4492 - 2837))) then
						if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((2362 - 1066) == (4937 - (10 + 17)))) then
							return "felblade rotation 1";
						end
					end
					if (((757 + 2611) == (5100 - (1400 + 332))) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v14:NPCID())) then
						if (((5069 - 2426) < (5723 - (242 + 1666))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
							return "fodder to the flames react per target";
						end
					end
					if (((819 + 1094) > (181 + 312)) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v15:NPCID())) then
						if (((4053 + 702) > (4368 - (850 + 90))) and v20(v80.ThrowGlaiveMouseover, not v14:IsSpellInRange(v78.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v90 = v78.FirstBlood:IsAvailable() or v78.TrailofRuin:IsAvailable() or (v78.ChaosTheory:IsAvailable() and v13:BuffDown(v78.ChaosTheoryBuff)) or (v87 > (1 - 0));
					v91 = v90 and (v13:Fury() < ((1465 - (360 + 1030)) - (v23(v78.DemonBlades:IsAvailable()) * (18 + 2)))) and (v78.BladeDance:CooldownRemains() < v97);
					v92 = v78.Demonic:IsAvailable() and not v78.BlindFury:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (5 - 3))) and (v13:FuryDeficit() > (41 - 11));
					v94 = (v78.Momentum:IsAvailable() and v13:BuffDown(v78.MomentumBuff)) or (v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff));
					local v171 = v26(v78.EyeBeam:BaseDuration(), v13:GCD());
					v95 = v78.Demonic:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v101 > (v78.Metamorphosis:CooldownRemains() + (1691 - (909 + 752)) + (v23(v78.ShatteredDestiny:IsAvailable()) * (1283 - (109 + 1114))))) and (v78.Metamorphosis:CooldownRemains() < (36 - 16)) and (v78.Metamorphosis:CooldownRemains() > (v171 + (v97 * (v23(v78.InnerDemon:IsAvailable()) + 1 + 1))));
					if (((1623 - (6 + 236)) <= (1493 + 876)) and v78.ImmolationAura:IsCastable() and v44 and v78.Ragefire:IsAvailable() and (v87 >= (3 + 0)) and (v78.BladeDance:CooldownDown() or v14:DebuffDown(v78.EssenceBreakDebuff))) then
						if (v20(v78.ImmolationAura, not v14:IsInRange(18 - 10)) or ((8458 - 3615) == (5217 - (1076 + 57)))) then
							return "immolation_aura main 2";
						end
					end
					if (((768 + 3901) > (1052 - (579 + 110))) and v78.ImmolationAura:IsCastable() and v44 and v78.AFireInside:IsAvailable() and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (v78.ImmolationAura:FullRechargeTime() < (v97 * (1 + 1))) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
						if (v20(v78.ImmolationAura, not v14:IsInRange(8 + 0)) or ((997 + 880) >= (3545 - (174 + 233)))) then
							return "immolation_aura main 3";
						end
					end
					if (((13245 - 8503) >= (6364 - 2738)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and (((v78.ImmolationAura:Charges() == (1 + 1)) and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v13:PrevGCDP(1175 - (663 + 511), v78.EyeBeam) and v13:BuffUp(v78.InertiaBuff) and (v13:BuffRemains(v78.InertiaBuff) < (3 + 0))))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((986 + 3554) == (2823 - 1907))) then
							return "fel_rush main 4";
						end
					end
					if ((v78.TheHunt:IsCastable() and (v9.CombatTime() < (7 + 3)) and (not v78.Inertia:IsAvailable() or (v13:BuffUp(v78.MetamorphosisBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)))) or ((2721 - 1565) > (10518 - 6173))) then
						if (((1068 + 1169) < (8269 - 4020)) and v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt))) then
							return "the_hunt main 6";
						end
					end
					if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and ((v78.EyeBeam:CooldownRemains() < (v97 * (2 + 0))) or v13:BuffUp(v78.MetamorphosisBuff)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1 + 2))) and v13:BuffDown(v78.UnboundChaosBuff) and v13:BuffDown(v78.InertiaBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((3405 - (478 + 244)) < (540 - (440 + 77)))) then
						if (((317 + 380) <= (3022 - 2196)) and v20(v78.ImmolationAura, not v14:IsInRange(1564 - (655 + 901)))) then
							return "immolation_aura main 5";
						end
					end
					if (((205 + 900) <= (901 + 275)) and v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.ImmolationAura:FullRechargeTime() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable()) and v14:DebuffDown(v78.EssenceBreakDebuff) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > (5 + 1))) and v78.BladeDance:CooldownDown() and ((v13:Fury() < (302 - 227)) or (v78.BladeDance:CooldownRemains() < (v97 * (1447 - (695 + 750)))))) then
						if (((11538 - 8159) <= (5882 - 2070)) and v20(v78.ImmolationAura, not v14:IsInRange(32 - 24))) then
							return "immolation_aura main 6";
						end
					end
					if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and ((v13:BuffRemains(v78.UnboundChaosBuff) < (v97 * (353 - (285 + 66)))) or (v14:TimeToDie() < (v97 * (4 - 2))))) or ((2098 - (682 + 628)) >= (261 + 1355))) then
						if (((2153 - (176 + 123)) <= (1414 + 1965)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
							return "fel_rush main 8";
						end
					end
					if (((3300 + 1249) == (4818 - (239 + 30))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and ((v78.EyeBeam:CooldownRemains() + 1 + 2) > v13:BuffRemains(v78.UnboundChaosBuff)) and (v78.BladeDance:CooldownDown() or v78.EssenceBreak:CooldownUp())) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2905 + 117) >= (5352 - 2328))) then
							return "fel_rush main 9";
						end
					end
					if (((15037 - 10217) > (2513 - (306 + 9))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EssenceBreak:CooldownRemains() > (34 - 24)))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((185 + 876) >= (3001 + 1890))) then
							return "fel_rush main 10";
						end
					end
					if (((657 + 707) <= (12790 - 8317)) and (v69 < v101) and v30) then
						v27 = v109();
						if (v27 or ((4970 - (1140 + 235)) <= (2 + 1))) then
							return v27;
						end
					end
					if ((v13:BuffUp(v78.MetamorphosisBuff) and (v13:BuffRemains(v78.MetamorphosisBuff) < v97) and (v87 < (3 + 0))) or ((1200 + 3472) == (3904 - (33 + 19)))) then
						v27 = v108();
						if (((563 + 996) == (4672 - 3113)) and v27) then
							return v27;
						end
					end
					v27 = v110();
					if (v27 or ((772 + 980) <= (1545 - 757))) then
						return v27;
					end
					if ((v78.DemonBlades:IsAvailable()) or ((3664 + 243) == (866 - (586 + 103)))) then
						if (((316 + 3154) > (1708 - 1153)) and v20(v78.Pool)) then
							return "pool demon_blades";
						end
					end
				end
				break;
			end
			if ((v133 == (1491 - (1309 + 179))) or ((1754 - 782) == (281 + 364))) then
				if (((8545 - 5363) >= (1598 + 517)) and (v22.TargetIsValid() or v13:AffectingCombat())) then
					local v172 = 0 - 0;
					while true do
						if (((7756 - 3863) < (5038 - (295 + 314))) and ((0 - 0) == v172)) then
							v100 = v9.BossFightRemains(nil, true);
							v101 = v100;
							v172 = 1963 - (1300 + 662);
						end
						if ((v172 == (3 - 2)) or ((4622 - (1178 + 577)) < (990 + 915))) then
							if ((v101 == (32846 - 21735)) or ((3201 - (851 + 554)) >= (3583 + 468))) then
								v101 = v9.FightRemains(v85, false);
							end
							break;
						end
					end
				end
				v27 = v106();
				if (((4489 - 2870) <= (8157 - 4401)) and v27) then
					return v27;
				end
				if (((906 - (115 + 187)) == (463 + 141)) and v65) then
					local v173 = 0 + 0;
					while true do
						if (((0 - 0) == v173) or ((5645 - (160 + 1001)) == (788 + 112))) then
							v27 = v22.HandleIncorporeal(v78.Imprison, v80.ImprisonMouseover, 21 + 9, true);
							if (v27 or ((9127 - 4668) <= (1471 - (237 + 121)))) then
								return v27;
							end
							break;
						end
					end
				end
				v133 = 901 - (525 + 372);
			end
			if (((6885 - 3253) > (11164 - 7766)) and (v133 == (143 - (96 + 46)))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['movement'];
				if (((4859 - (643 + 134)) <= (1776 + 3141)) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v133 = 4 - 2;
			end
			if (((17939 - 13107) >= (1330 + 56)) and ((0 - 0) == v133)) then
				v112();
				v111();
				v113();
				v28 = EpicSettings.Toggles['ooc'];
				v133 = 1 - 0;
			end
		end
	end
	local function v115()
		local v134 = 719 - (316 + 403);
		while true do
			if (((92 + 45) == (376 - 239)) and (v134 == (0 + 0))) then
				v78.BurningWoundDebuff:RegisterAuraTracking();
				v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(1452 - 875, v114, v115);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

