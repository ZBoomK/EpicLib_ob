local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1 + 0) == v5) or ((130 + 507) == (6045 - 3443))) then
			return v6(...);
		end
		if (((71 + 233) <= (208 + 417)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((1730 - (709 + 387)) == (4274 - (673 + 1185)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
	end
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.PressCursor;
	local v26 = v22.Macro;
	local v27 = v22.Bind;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = math.max;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98 = v19.Mage.Frost;
	local v99 = v21.Mage.Frost;
	local v100 = v26.Mage.Frost;
	local v101 = {};
	local v102, v103;
	local v104;
	local v105;
	local v106 = 0 - 0;
	local v107 = 0 - 0;
	local v108 = 11 + 4;
	local v109 = 8303 + 2808;
	local v110 = 15001 - 3890;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (((271 + 832) < (3549 - 1769)) and v98.RemoveCurse:IsAvailable()) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(166309 - 81588);
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(230477 - (446 + 1434));
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(229637 - (1040 + 243));
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(682277 - 453679);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(230447 - (559 + 1288));
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v132 = 1931 - (609 + 1322);
		while true do
			if (((3138 - (13 + 441)) > (2040 - 1494)) and (v132 == (2 - 1))) then
				v106 = 0 - 0;
				break;
			end
			if (((55 + 1410) <= (15620 - 11319)) and (v132 == (0 + 0))) then
				v109 = 4869 + 6242;
				v110 = 32972 - 21861;
				v132 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v133)
		local v134 = 0 - 0;
		while true do
			if (((1127 + 577) > (793 + 632)) and (v134 == (0 + 0))) then
				if ((v133 == nil) or ((577 + 110) == (4143 + 91))) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < (506 - (153 + 280)));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v135)
		if ((v98.WintersChillDebuff:AuraActiveCount() == (0 - 0)) or ((2990 + 340) < (565 + 864))) then
			return 0 + 0;
		end
		local v136 = 0 + 0;
		for v163, v164 in pairs(v135) do
			v136 = v136 + v164:DebuffStack(v98.WintersChillDebuff);
		end
		return v136;
	end
	local function v117(v137)
		return (v137:DebuffStack(v98.WintersChillDebuff));
	end
	local function v118(v138)
		return (v138:DebuffDown(v98.WintersChillDebuff));
	end
	local function v119()
		local v139 = 0 + 0;
		while true do
			if (((1745 - 598) >= (208 + 127)) and (v139 == (670 - (89 + 578)))) then
				if (((2454 + 981) > (4359 - 2262)) and v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
					if (v24(v98.AlterTime) or ((4819 - (572 + 477)) >= (545 + 3496))) then
						return "alter_time defensive 7";
					end
				end
				if ((v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) or ((2276 + 1515) <= (193 + 1418))) then
					if (v24(v100.Healthstone) or ((4664 - (84 + 2)) <= (3309 - 1301))) then
						return "healthstone defensive";
					end
				end
				v139 = 3 + 1;
			end
			if (((1967 - (497 + 345)) <= (54 + 2022)) and (v139 == (1 + 3))) then
				if ((v84 and (v14:HealthPercentage() <= v86)) or ((2076 - (605 + 728)) >= (3139 + 1260))) then
					if (((2567 - 1412) < (77 + 1596)) and (v88 == "Refreshing Healing Potion")) then
						if (v99.RefreshingHealingPotion:IsReady() or ((8592 - 6268) <= (522 + 56))) then
							if (((10436 - 6669) == (2845 + 922)) and v24(v100.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((4578 - (457 + 32)) == (1735 + 2354)) and (v88 == "Dreamwalker's Healing Potion")) then
						if (((5860 - (832 + 570)) >= (1578 + 96)) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (((254 + 718) <= (5017 - 3599)) and v24(v100.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v139 == (1 + 0)) or ((5734 - (588 + 208)) < (12834 - 8072))) then
				if ((v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((4304 - (884 + 916)) > (8926 - 4662))) then
					if (((1249 + 904) == (2806 - (232 + 421))) and v24(v98.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((2396 - (1569 + 320)) >= (636 + 1955))) then
					if (((852 + 3629) == (15100 - 10619)) and v24(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v139 = 607 - (316 + 289);
			end
			if ((v139 == (0 - 0)) or ((108 + 2220) < (2146 - (666 + 787)))) then
				if (((4753 - (360 + 65)) == (4045 + 283)) and v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (((1842 - (79 + 175)) >= (2099 - 767)) and v24(v98.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2 + 0)) or ((12794 - 8620) > (8180 - 3932))) then
					if (v24(v98.MassBarrier) or ((5485 - (503 + 396)) <= (263 - (92 + 89)))) then
						return "mass_barrier defensive 2";
					end
				end
				v139 = 1 - 0;
			end
			if (((1982 + 1881) == (2287 + 1576)) and (v139 == (7 - 5))) then
				if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((39 + 243) <= (95 - 53))) then
					if (((4022 + 587) >= (366 + 400)) and v24(v98.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((3508 - 2356) == (311 + 2177))) then
					if (((5217 - 1795) > (4594 - (485 + 759))) and v24(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v139 = 6 - 3;
			end
		end
	end
	local function v120()
		if (((2066 - (442 + 747)) > (1511 - (832 + 303))) and v98.RemoveCurse:IsReady() and v35 and v112.DispellableFriendlyUnit(966 - (88 + 858))) then
			if (v24(v100.RemoveCurseFocus) or ((951 + 2167) <= (1532 + 319))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v121()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (789 - (766 + 23))) or ((814 - 649) >= (4775 - 1283))) then
				v31 = v112.HandleTopTrinket(v101, v34, 105 - 65, nil);
				if (((13402 - 9453) < (5929 - (1036 + 37))) and v31) then
					return v31;
				end
				v140 = 1 + 0;
			end
			if (((1 - 0) == v140) or ((3364 + 912) < (4496 - (641 + 839)))) then
				v31 = v112.HandleBottomTrinket(v101, v34, 953 - (910 + 3), nil);
				if (((11956 - 7266) > (5809 - (1466 + 218))) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v122()
		if (v112.TargetIsValid() or ((23 + 27) >= (2044 - (556 + 592)))) then
			if ((v98.MirrorImage:IsCastable() and v68 and v96) or ((610 + 1104) >= (3766 - (329 + 479)))) then
				if (v24(v98.MirrorImage) or ((2345 - (174 + 680)) < (2212 - 1568))) then
					return "mirror_image precombat 2";
				end
			end
			if (((1459 - 755) < (705 + 282)) and v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
				if (((4457 - (396 + 343)) > (169 + 1737)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v123()
		local v141 = 1477 - (29 + 1448);
		local v142;
		while true do
			if (((1391 - (135 + 1254)) == v141) or ((3608 - 2650) > (16972 - 13337))) then
				if (((2334 + 1167) <= (6019 - (389 + 1138))) and (v83 < v110)) then
					if ((v90 and ((v34 and v91) or not v91)) or ((4016 - (102 + 472)) < (2405 + 143))) then
						local v224 = 0 + 0;
						while true do
							if (((2681 + 194) >= (3009 - (320 + 1225))) and (v224 == (0 - 0))) then
								v31 = v121();
								if (v31 or ((2936 + 1861) >= (6357 - (157 + 1307)))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((v89 and ((v92 and v34) or not v92) and (v83 < v110)) or ((2410 - (821 + 1038)) > (5159 - 3091))) then
					if (((232 + 1882) > (1676 - 732)) and v98.BloodFury:IsCastable()) then
						if (v24(v98.BloodFury) or ((842 + 1420) >= (7673 - 4577))) then
							return "blood_fury cd 10";
						end
					end
					if (v98.Berserking:IsCastable() or ((3281 - (834 + 192)) >= (225 + 3312))) then
						if (v24(v98.Berserking) or ((985 + 2852) < (29 + 1277))) then
							return "berserking cd 12";
						end
					end
					if (((4570 - 1620) == (3254 - (300 + 4))) and v98.LightsJudgment:IsCastable()) then
						if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((1262 + 3461) < (8633 - 5335))) then
							return "lights_judgment cd 14";
						end
					end
					if (((1498 - (112 + 250)) >= (62 + 92)) and v98.Fireblood:IsCastable()) then
						if (v24(v98.Fireblood) or ((678 - 407) > (2721 + 2027))) then
							return "fireblood cd 16";
						end
					end
					if (((2452 + 2288) >= (2358 + 794)) and v98.AncestralCall:IsCastable()) then
						if (v24(v98.AncestralCall) or ((1279 + 1299) >= (2519 + 871))) then
							return "ancestral_call cd 18";
						end
					end
				end
				break;
			end
			if (((1455 - (1001 + 413)) <= (3703 - 2042)) and (v141 == (882 - (244 + 638)))) then
				if (((1294 - (627 + 66)) < (10607 - 7047)) and v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(603 - (512 + 90), v98.IcyVeins)) then
					if (((2141 - (1665 + 241)) < (1404 - (373 + 344))) and v24(v98.TimeWarp, not v15:IsInRange(19 + 21))) then
						return "time_warp cd 2";
					end
				end
				v142 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v141 = 1 + 0;
			end
			if (((11998 - 7449) > (1950 - 797)) and (v141 == (1100 - (35 + 1064)))) then
				if (v142 or ((3401 + 1273) < (9995 - 5323))) then
					return v142;
				end
				if (((15 + 3653) < (5797 - (298 + 938))) and v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
					if (v24(v98.IcyVeins) or ((1714 - (233 + 1026)) == (5271 - (636 + 1030)))) then
						return "icy_veins cd 6";
					end
				end
				v141 = 2 + 0;
			end
		end
	end
	local function v124()
		local v143 = 0 + 0;
		while true do
			if (((0 + 0) == v143) or ((180 + 2483) == (3533 - (55 + 166)))) then
				if (((829 + 3448) <= (451 + 4024)) and v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) then
					if (v24(v98.IceFloes) or ((3322 - 2452) == (1486 - (36 + 261)))) then
						return "ice_floes movement";
					end
				end
				if (((2715 - 1162) <= (4501 - (34 + 1334))) and v98.IceNova:IsCastable() and v48) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((860 + 1377) >= (2728 + 783))) then
						return "ice_nova movement";
					end
				end
				v143 = 1284 - (1035 + 248);
			end
			if (((23 - (20 + 1)) == v143) or ((690 + 634) > (3339 - (134 + 185)))) then
				if ((v98.IceLance:IsCastable() and v47) or ((4125 - (549 + 584)) == (2566 - (314 + 371)))) then
					if (((10662 - 7556) > (2494 - (478 + 490))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if (((1602 + 1421) < (5042 - (786 + 386))) and (v143 == (3 - 2))) then
				if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (27 + 3)) and (v103 >= (1 + 1))) then
					if (((71 - 53) < (7167 - 5055)) and v24(v98.ArcaneExplosion, not v15:IsInRange(22 - 14))) then
						return "arcane_explosion movement";
					end
				end
				if (((2756 - 1659) <= (580 + 1048)) and v98.FireBlast:IsCastable() and UseFireblast) then
					if (((17836 - 13206) == (15958 - 11328)) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v143 = 2 + 0;
			end
		end
	end
	local function v125()
		local v144 = 0 - 0;
		while true do
			if (((4228 - (364 + 324)) > (7354 - 4671)) and (v144 == (9 - 5))) then
				if (((1589 + 3205) >= (13703 - 10428)) and v98.Frostbolt:IsCastable() and v41) then
					if (((2376 - 892) == (4506 - 3022)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((2700 - (1249 + 19)) < (3209 + 346)) and v14:IsMoving() and v94) then
					local v210 = 0 - 0;
					local v211;
					while true do
						if ((v210 == (1086 - (686 + 400))) or ((836 + 229) > (3807 - (73 + 156)))) then
							v211 = v124();
							if (v211 or ((23 + 4772) < (2218 - (721 + 90)))) then
								return v211;
							end
							break;
						end
					end
				end
				break;
			end
			if (((21 + 1832) < (15627 - 10814)) and (v144 == (472 - (224 + 246)))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((4569 - 1748) < (4475 - 2044))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(8 + 32), true) or ((69 + 2805) < (1602 + 579))) then
						return "shifting_power aoe 16";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (9 - 4)) and (v98.Blizzard:CooldownRemains() > v111)) or ((8948 - 6259) <= (856 - (203 + 310)))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((3862 - (1238 + 755)) == (141 + 1868))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (1534 - (709 + 825))) and (v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (1.8 - 0)))) or ((4410 - (196 + 668)) < (9167 - 6845))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((4312 - 2230) == (5606 - (171 + 662)))) then
						return "flurry aoe 20";
					end
				end
				if (((3337 - (4 + 89)) > (3697 - 2642)) and v98.Flurry:IsCastable() and v43 and (v106 == (0 + 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((14551 - 11238) <= (698 + 1080))) then
						return "flurry aoe 21";
					end
				end
				v144 = 1489 - (35 + 1451);
			end
			if ((v144 == (1456 - (28 + 1425))) or ((3414 - (941 + 1052)) >= (2018 + 86))) then
				if (((3326 - (822 + 692)) <= (4637 - 1388)) and v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) then
					if (((765 + 858) <= (2254 - (45 + 252))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if (((4366 + 46) == (1519 + 2893)) and v98.IceNova:IsCastable() and v48 and (v102 >= (9 - 5)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) then
					if (((2183 - (114 + 319)) >= (1208 - 366)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if (((5601 - 1229) > (1180 + 670)) and v98.DragonsBreath:IsCastable() and v39 and (v103 >= (9 - 2))) then
					if (((485 - 253) < (2784 - (556 + 1407))) and v24(v98.DragonsBreath, not v15:IsInRange(1216 - (741 + 465)))) then
						return "dragons_breath aoe 26";
					end
				end
				if (((983 - (170 + 295)) < (476 + 426)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (28 + 2)) and (v103 >= (17 - 10))) then
					if (((2482 + 512) > (551 + 307)) and v24(v98.ArcaneExplosion, not v15:IsInRange(5 + 3))) then
						return "arcane_explosion aoe 28";
					end
				end
				v144 = 1234 - (957 + 273);
			end
			if ((v144 == (0 + 0)) or ((1504 + 2251) <= (3486 - 2571))) then
				if (((10398 - 6452) > (11432 - 7689)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(4 - 3, v98.CometStorm) or (v14:PrevGCDP(1781 - (389 + 1391), v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(6 + 2)) or ((139 + 1196) >= (7526 - 4220))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((5795 - (783 + 168)) > (7561 - 5308)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) then
					if (((763 - (309 + 2)) == (1387 - 935)) and v24(v100.FrozenOrbCast, not v15:IsInRange(1252 - (1090 + 122)))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) or ((15304 - 10747) < (1429 + 658))) then
					if (((4992 - (628 + 490)) == (695 + 3179)) and v24(v100.BlizzardCursor, not v15:IsInRange(99 - 59))) then
						return "blizzard aoe 6";
					end
				end
				if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(4 - 3, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (799 - (431 + 343)))) or (v98.ConeofCold:CooldownRemains() > (40 - 20)))) or ((5606 - 3668) > (3899 + 1036))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((545 + 3710) < (5118 - (556 + 1139)))) then
						return "comet_storm aoe 8";
					end
				end
				v144 = 16 - (6 + 9);
			end
			if (((267 + 1187) <= (1277 + 1214)) and (v144 == (170 - (28 + 141)))) then
				if ((v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 + 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or ((2945 + 1212) <= (4120 - (486 + 831)))) then
					if (((12628 - 7775) >= (10498 - 7516)) and v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze))) then
						return "freeze aoe 10";
					end
				end
				if (((782 + 3352) > (10614 - 7257)) and v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1264 - (668 + 595), v98.Freeze) and (v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((9318 - 5901) < (2824 - (23 + 267)))) then
						return "ice_nova aoe 11";
					end
				end
				if ((v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1945 - (1129 + 815), v98.Freeze) and ((v14:PrevGCDP(388 - (371 + 16), v98.GlacialSpike) and (v106 == (1750 - (1326 + 424)))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 - 0))))) or ((9946 - 7224) <= (282 - (88 + 30)))) then
					if (v24(v98.FrostNova) or ((3179 - (720 + 51)) < (4691 - 2582))) then
						return "frost_nova aoe 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or ((1809 - (421 + 1355)) == (2400 - 945))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(4 + 4)) or ((1526 - (286 + 797)) >= (14677 - 10662))) then
						return "cone_of_cold aoe 14";
					end
				end
				v144 = 2 - 0;
			end
		end
	end
	local function v126()
		local v145 = 439 - (397 + 42);
		while true do
			if (((1057 + 2325) > (966 - (24 + 776))) and (v145 == (0 - 0))) then
				if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(786 - (222 + 563), v98.Flurry) or v14:PrevGCDP(1 - 0, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((202 + 78) == (3249 - (23 + 167)))) then
					if (((3679 - (690 + 1108)) > (467 + 826)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if (((1945 + 412) == (3205 - (40 + 808))) and v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v98.Frostbolt) and (v107 >= (11 - 8))) or v14:PrevGCDP(1 + 0, v98.GlacialSpike) or ((v107 >= (2 + 1)) and (v107 < (3 + 2)) and (v98.Flurry:ChargesFractional() == (573 - (47 + 524)))))) then
					local v212 = 0 + 0;
					while true do
						if (((336 - 213) == (183 - 60)) and (v212 == (0 - 0))) then
							if (v112.CastTargetIf(v98.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v98.Flurry)) or ((2782 - (1165 + 561)) >= (101 + 3291))) then
								return "flurry cleave 4";
							end
							if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((3347 - 2266) < (411 + 664))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (479 - (341 + 138))) and (v107 == (2 + 2)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((2164 - 1115) >= (4758 - (89 + 237)))) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (0 - 0)) or ((5649 - (581 + 300)) <= (2066 - (855 + 365)))) then
							if (v112.CastTargetIf(v98.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v98.IceLance)) or ((7975 - 4617) <= (464 + 956))) then
								return "ice_lance cleave 6";
							end
							if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((4974 - (1030 + 205)) <= (2822 + 183))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				v145 = 1 + 0;
			end
			if ((v145 == (290 - (156 + 130))) or ((3769 - 2110) >= (3596 - 1462))) then
				if ((v98.Frostbolt:IsCastable() and v41) or ((6676 - 3416) < (621 + 1734))) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((391 + 278) == (4292 - (10 + 59)))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((479 + 1213) < (2895 - 2307))) then
					local v214 = 1163 - (671 + 492);
					local v215;
					while true do
						if ((v214 == (0 + 0)) or ((6012 - (369 + 846)) < (967 + 2684))) then
							v215 = v124();
							if (v215 or ((3565 + 612) > (6795 - (1036 + 909)))) then
								return v215;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v145 == (1 + 0)) or ((671 - 271) > (1314 - (11 + 192)))) then
				if (((1542 + 1509) > (1180 - (135 + 40))) and v98.RayofFrost:IsCastable() and (v106 == (2 - 1)) and v49) then
					local v216 = 0 + 0;
					while true do
						if (((8135 - 4442) <= (6568 - 2186)) and (v216 == (176 - (50 + 126)))) then
							if (v112.CastTargetIf(v98.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v98.RayofFrost)) or ((9138 - 5856) > (908 + 3192))) then
								return "ray_of_frost cleave 8";
							end
							if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((4993 - (1233 + 180)) < (3813 - (522 + 447)))) then
								return "ray_of_frost cleave 8";
							end
							break;
						end
					end
				end
				if (((1510 - (107 + 1314)) < (2084 + 2406)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (15 - 10)) and (v98.Flurry:CooldownUp() or (v106 > (0 + 0)))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((9895 - 4912) < (7153 - 5345))) then
						return "glacial_spike cleave 10";
					end
				end
				if (((5739 - (716 + 1194)) > (65 + 3704)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1 + 1)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (((1988 - (74 + 429)) <= (5601 - 2697)) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				v145 = 1 + 1;
			end
			if (((9771 - 5502) == (3021 + 1248)) and (v145 == (5 - 3))) then
				if (((956 - 569) <= (3215 - (279 + 154))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (788 - (454 + 324))) and (v98.FrozenOrb:CooldownRemains() > (8 + 2)) and (v106 == (17 - (12 + 5))) and (v103 >= (2 + 1))) then
					if (v24(v98.ConeofCold) or ((4838 - 2939) <= (339 + 578))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (1095 - (277 + 816))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (12 - 9)))) or ((5495 - (1058 + 125)) <= (165 + 711))) then
					if (((3207 - (815 + 160)) <= (11138 - 8542)) and v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard))) then
						return "blizzard cleave 16";
					end
				end
				if (((4973 - 2878) < (880 + 2806)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (29 - 19)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (1908 - (41 + 1857)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (1903 - (1222 + 671))))) or (v98.IcyVeins:CooldownRemains() < (51 - 31)))) then
					if (v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true) or ((2292 - 697) >= (5656 - (229 + 953)))) then
						return "shifting_power cleave 18";
					end
				end
				v145 = 1777 - (1111 + 663);
			end
			if ((v145 == (1582 - (874 + 705))) or ((647 + 3972) < (1967 + 915))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (10 - 5))) or ((9 + 285) >= (5510 - (642 + 37)))) then
					if (((463 + 1566) <= (494 + 2590)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(2 - 1, v98.GlacialSpike)) or (v106 > (454 - (233 + 221))))) or ((4710 - 2673) == (2131 + 289))) then
					local v217 = 1541 - (718 + 823);
					while true do
						if (((2806 + 1652) > (4709 - (266 + 539))) and (v217 == (0 - 0))) then
							if (((1661 - (636 + 589)) >= (291 - 168)) and v112.CastTargetIf(v98.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
								return "ice_lance cleave 22";
							end
							if (((1031 - 531) < (1440 + 376)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if (((1299 + 2275) == (4589 - (657 + 358))) and v98.IceNova:IsCastable() and v48 and (v103 >= (10 - 6))) then
					if (((503 - 282) < (1577 - (1151 + 36))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v145 = 4 + 0;
			end
		end
	end
	local function v127()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (0 - 0)) or ((4045 - (1552 + 280)) <= (2255 - (64 + 770)))) then
				if (((2077 + 981) < (11032 - 6172)) and v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(1244 - (157 + 1086), v98.ConeofCold))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((2593 - 1297) >= (19472 - 15026))) then
						return "comet_storm single 2";
					end
				end
				if ((v98.Flurry:IsCastable() and (v106 == (0 - 0)) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1 - 0, v98.Frostbolt) and (v107 >= (822 - (599 + 220)))) or (v14:PrevGCDP(1 - 0, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1932 - (1813 + 118), v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (3 + 1)) and v14:BuffDown(v98.FingersofFrostBuff)))) or ((2610 - (841 + 376)) > (6289 - 1800))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((1028 + 3396) < (73 - 46))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (859 - (464 + 395))) and (v107 == (10 - 6)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((960 + 1037) > (4652 - (467 + 370)))) then
					if (((7160 - 3695) > (1405 + 508)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v146 = 3 - 2;
			end
			if (((115 + 618) < (4231 - 2412)) and (v146 == (524 - (150 + 370)))) then
				if ((v89 and ((v92 and v34) or not v92)) or ((5677 - (74 + 1208)) == (11695 - 6940))) then
					if (v98.BagofTricks:IsCastable() or ((17988 - 14195) < (1686 + 683))) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((4474 - (14 + 376)) == (459 - 194))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((2820 + 1538) == (3829 + 529)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((2993 + 145) < (2909 - 1916))) then
						return "frostbolt single 26";
					end
				end
				if (((2506 + 824) > (2401 - (23 + 55))) and v14:IsMoving() and v94) then
					local v218 = 0 - 0;
					local v219;
					while true do
						if ((v218 == (0 + 0)) or ((3257 + 369) == (6184 - 2195))) then
							v219 = v124();
							if (v219 or ((289 + 627) == (3572 - (652 + 249)))) then
								return v219;
							end
							break;
						end
					end
				end
				break;
			end
			if (((727 - 455) == (2140 - (708 + 1160))) and (v146 == (5 - 3))) then
				if (((7746 - 3497) <= (4866 - (10 + 17))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (3 + 7)) and (v98.FrozenOrb:CooldownRemains() > (1742 - (1400 + 332))) and (v106 == (0 - 0)) and (v102 >= (1911 - (242 + 1666)))) then
					if (((1189 + 1588) < (1173 + 2027)) and v24(v98.ConeofCold, not v15:IsInRange(7 + 1))) then
						return "cone_of_cold single 14";
					end
				end
				if (((1035 - (850 + 90)) < (3427 - 1470)) and v98.Blizzard:IsCastable() and v38 and (v102 >= (1392 - (360 + 1030))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (3 + 0)))) then
					if (((2330 - 1504) < (2362 - 645)) and v24(v100.BlizzardCursor, not v15:IsInRange(1701 - (909 + 752)))) then
						return "blizzard single 16";
					end
				end
				if (((2649 - (109 + 1114)) >= (2023 - 918)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (252 - (6 + 236))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (7 + 3))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (9 + 1)))) or (v98.IcyVeins:CooldownRemains() < (47 - 27)))) then
					if (((4809 - 2055) <= (4512 - (1076 + 57))) and v24(v98.ShiftingPower, not v15:IsInRange(7 + 33))) then
						return "shifting_power single 18";
					end
				end
				v146 = 692 - (579 + 110);
			end
			if ((v146 == (1 + 0)) or ((3472 + 455) == (750 + 663))) then
				if ((v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (408 - (174 + 233)))) or ((3223 - 2069) <= (1382 - 594))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((731 + 912) > (4553 - (663 + 511)))) then
						return "ray_of_frost single 8";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (5 + 0)) and ((v98.Flurry:Charges() >= (1 + 0)) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or ((1698 + 1105) > (10709 - 6160))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((532 - 312) >= (1443 + 1579))) then
						return "glacial_spike single 10";
					end
				end
				if (((5492 - 2670) == (2012 + 810)) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 + 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (724 - (478 + 244))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(557 - (440 + 77))) or ((483 + 578) == (6796 - 4939))) then
						return "frozen_orb single 12";
					end
				end
				v146 = 1558 - (655 + 901);
			end
			if (((512 + 2248) > (1045 + 319)) and (v146 == (3 + 0))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (20 - 15))) or ((6347 - (695 + 750)) <= (12275 - 8680))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((5944 - 2092) == (1178 - 885))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(352 - (285 + 66), v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((3633 - 2074) == (5898 - (682 + 628)))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((723 + 3761) == (1087 - (176 + 123)))) then
						return "ice_lance single 22";
					end
				end
				if (((1911 + 2657) >= (2835 + 1072)) and v98.IceNova:IsCastable() and v48 and (v103 >= (273 - (239 + 30)))) then
					if (((339 + 907) < (3336 + 134)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v146 = 6 - 2;
			end
		end
	end
	local function v128()
		local v147 = 0 - 0;
		while true do
			if (((4383 - (306 + 9)) >= (3391 - 2419)) and (v147 == (2 + 6))) then
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((303 + 190) < (1874 + 2019)) and (v147 == (19 - 12))) then
				v73 = EpicSettings.Settings['iceColdHP'] or (1375 - (1140 + 235));
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (52 - (33 + 19));
				v147 = 3 + 5;
			end
			if ((v147 == (2 - 1)) or ((649 + 824) >= (6533 - 3201))) then
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v147 = 2 + 0;
			end
			if (((691 - (586 + 103)) == v147) or ((369 + 3682) <= (3561 - 2404))) then
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v147 = 1491 - (1309 + 179);
			end
			if (((1089 - 485) < (1254 + 1627)) and ((0 - 0) == v147)) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v147 = 1 + 0;
			end
			if ((v147 == (12 - 6)) or ((1793 - 893) == (3986 - (295 + 314)))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (1962 - (1300 + 662));
				v147 = 21 - 14;
			end
			if (((6214 - (1178 + 577)) > (307 + 284)) and (v147 == (14 - 9))) then
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v147 = 1411 - (851 + 554);
			end
			if (((3005 + 393) >= (6642 - 4247)) and (v147 == (6 - 3))) then
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v147 = 306 - (115 + 187);
			end
			if ((v147 == (4 + 0)) or ((2067 + 116) >= (11128 - 8304))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v147 = 1166 - (160 + 1001);
			end
		end
	end
	local function v129()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v80 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v82 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['DispelDebuffs'];
		v76 = EpicSettings.Settings['DispelBuffs'];
		v90 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v91 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v85 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v88 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v130()
		local v161 = 358 - (237 + 121);
		while true do
			if (((2833 - (525 + 372)) == (3669 - 1733)) and ((6 - 4) == v161)) then
				if (v14:IsDeadOrGhost() or ((4974 - (96 + 46)) < (5090 - (643 + 134)))) then
					return;
				end
				v105 = v15:GetEnemiesInSplashRange(2 + 3);
				Enemies40yRange = v14:GetEnemiesInRange(95 - 55);
				v161 = 11 - 8;
			end
			if (((3921 + 167) > (7602 - 3728)) and (v161 == (5 - 2))) then
				if (((5051 - (316 + 403)) == (2880 + 1452)) and v33) then
					local v220 = 0 - 0;
					while true do
						if (((1446 + 2553) >= (7303 - 4403)) and (v220 == (0 + 0))) then
							v102 = v30(v15:GetEnemiesInSplashRangeCount(2 + 3), #Enemies40yRange);
							v103 = v30(v15:GetEnemiesInSplashRangeCount(17 - 12), #Enemies40yRange);
							break;
						end
					end
				else
					local v221 = 0 - 0;
					while true do
						if ((v221 == (0 - 0)) or ((145 + 2380) > (7999 - 3935))) then
							v104 = 1 + 0;
							v102 = 2 - 1;
							v221 = 18 - (12 + 5);
						end
						if (((16977 - 12606) == (9325 - 4954)) and ((1 - 0) == v221)) then
							v103 = 2 - 1;
							break;
						end
					end
				end
				if (not v14:AffectingCombat() or ((54 + 212) > (6959 - (1656 + 317)))) then
					if (((1775 + 216) >= (742 + 183)) and v98.ArcaneIntellect:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
						if (((1209 - 754) < (10103 - 8050)) and v24(v98.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v112.TargetIsValid() or v14:AffectingCombat() or ((1180 - (5 + 349)) == (23041 - 18190))) then
					local v222 = 1271 - (266 + 1005);
					while true do
						if (((121 + 62) == (624 - 441)) and (v222 == (0 - 0))) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v222 = 1697 - (561 + 1135);
						end
						if (((1509 - 350) <= (5877 - 4089)) and (v222 == (1067 - (507 + 559)))) then
							if ((v110 == (27880 - 16769)) or ((10845 - 7338) > (4706 - (212 + 176)))) then
								v110 = v10.FightRemains(Enemies40yRange, false);
							end
							v106 = v15:DebuffStack(v98.WintersChillDebuff);
							v222 = 907 - (250 + 655);
						end
						if (((5 - 3) == v222) or ((5373 - 2298) <= (4638 - 1673))) then
							v107 = v14:BuffStackP(v98.IciclesBuff);
							v111 = v14:GCD();
							break;
						end
					end
				end
				v161 = 1960 - (1869 + 87);
			end
			if (((4734 - 3369) <= (3912 - (484 + 1417))) and ((0 - 0) == v161)) then
				v128();
				v129();
				v32 = EpicSettings.Toggles['ooc'];
				v161 = 1 - 0;
			end
			if ((v161 == (777 - (48 + 725))) or ((4534 - 1758) > (9591 - 6016))) then
				if (v112.TargetIsValid() or ((1485 + 1069) == (12838 - 8034))) then
					local v223 = 0 + 0;
					while true do
						if (((752 + 1825) == (3430 - (152 + 701))) and ((1314 - (430 + 881)) == v223)) then
							if (v79 or ((3 + 3) >= (2784 - (557 + 338)))) then
								local v225 = 0 + 0;
								while true do
									if (((1425 - 919) <= (6625 - 4733)) and (v225 == (0 - 0))) then
										v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 64 - 34, true);
										if (v31 or ((2809 - (499 + 302)) > (3084 - (39 + 827)))) then
											return v31;
										end
										break;
									end
								end
							end
							if (((1045 - 666) <= (9261 - 5114)) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
								if (v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal)) or ((17928 - 13414) <= (1548 - 539))) then
									return "spellsteal damage";
								end
							end
							v223 = 1 + 3;
						end
						if ((v223 == (0 - 0)) or ((560 + 2936) == (1885 - 693))) then
							if (v16 or ((312 - (103 + 1)) == (3513 - (475 + 79)))) then
								if (((9245 - 4968) >= (4201 - 2888)) and v77) then
									local v229 = 0 + 0;
									while true do
										if (((2277 + 310) < (4677 - (1395 + 108))) and (v229 == (0 - 0))) then
											v31 = v120();
											if (v31 or ((5324 - (7 + 1197)) <= (959 + 1239))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((557 + 1039) == (1177 - (27 + 292)))) then
								v31 = v122();
								if (((9435 - 6215) == (4106 - 886)) and v31) then
									return v31;
								end
							end
							v223 = 4 - 3;
						end
						if (((7 - 3) == v223) or ((2669 - 1267) > (3759 - (43 + 96)))) then
							if (((10499 - 7925) == (5819 - 3245)) and v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
								local v226 = 0 + 0;
								while true do
									if (((508 + 1290) < (5448 - 2691)) and (v226 == (0 + 0))) then
										if (v34 or ((705 - 328) > (820 + 1784))) then
											local v230 = 0 + 0;
											while true do
												if (((2319 - (1414 + 337)) < (2851 - (1642 + 298))) and (v230 == (0 - 0))) then
													v31 = v123();
													if (((9450 - 6165) < (12546 - 8318)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										if (((1289 + 2627) > (2590 + 738)) and v33 and (((v103 >= (979 - (357 + 615))) and not v14:HasTier(22 + 8, 4 - 2)) or ((v103 >= (3 + 0)) and v98.IceCaller:IsAvailable()))) then
											local v231 = 0 - 0;
											while true do
												if (((2000 + 500) < (261 + 3578)) and ((0 + 0) == v231)) then
													v31 = v125();
													if (((1808 - (384 + 917)) == (1204 - (128 + 569))) and v31) then
														return v31;
													end
													v231 = 1544 - (1407 + 136);
												end
												if (((2127 - (687 + 1200)) <= (4875 - (556 + 1154))) and (v231 == (3 - 2))) then
													if (((929 - (9 + 86)) >= (1226 - (275 + 146))) and v24(v98.Pool)) then
														return "pool for Aoe()";
													end
													break;
												end
											end
										end
										v226 = 1 + 0;
									end
									if ((v226 == (66 - (29 + 35))) or ((16894 - 13082) < (6917 - 4601))) then
										if (v31 or ((11707 - 9055) <= (999 + 534))) then
											return v31;
										end
										if (v24(v98.Pool) or ((4610 - (53 + 959)) < (1868 - (312 + 96)))) then
											return "pool for ST()";
										end
										v226 = 4 - 1;
									end
									if ((v226 == (286 - (147 + 138))) or ((5015 - (813 + 86)) < (1078 + 114))) then
										if ((v33 and (v103 == (3 - 1))) or ((3869 - (18 + 474)) <= (305 + 598))) then
											v31 = v126();
											if (((12977 - 9001) >= (1525 - (860 + 226))) and v31) then
												return v31;
											end
											if (((4055 - (121 + 182)) == (462 + 3290)) and v24(v98.Pool)) then
												return "pool for Cleave()";
											end
										end
										v31 = v127();
										v226 = 1242 - (988 + 252);
									end
									if (((458 + 3588) > (845 + 1850)) and (v226 == (1973 - (49 + 1921)))) then
										if (v94 or ((4435 - (223 + 667)) == (3249 - (51 + 1)))) then
											local v232 = 0 - 0;
											while true do
												if (((5126 - 2732) > (1498 - (146 + 979))) and (v232 == (0 + 0))) then
													v31 = v124();
													if (((4760 - (311 + 294)) <= (11801 - 7569)) and v31) then
														return v31;
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
						if ((v223 == (1 + 0)) or ((5024 - (496 + 947)) == (4831 - (1233 + 125)))) then
							v31 = v119();
							if (((2027 + 2968) > (3004 + 344)) and v31) then
								return v31;
							end
							v223 = 1 + 1;
						end
						if ((v223 == (1647 - (963 + 682))) or ((630 + 124) > (5228 - (504 + 1000)))) then
							if (((147 + 70) >= (52 + 5)) and (v14:AffectingCombat() or v77)) then
								local v227 = 0 + 0;
								local v228;
								while true do
									if ((v227 == (1 - 0)) or ((1769 + 301) >= (2348 + 1689))) then
										if (((2887 - (156 + 26)) == (1559 + 1146)) and v31) then
											return v31;
										end
										break;
									end
									if (((95 - 34) == (225 - (149 + 15))) and (v227 == (960 - (890 + 70)))) then
										v228 = v77 and v98.RemoveCurse:IsReady() and v35;
										v31 = v112.FocusUnit(v228, v100, 137 - (39 + 78), nil, 502 - (14 + 468));
										v227 = 2 - 1;
									end
								end
							end
							if (v78 or ((1953 - 1254) >= (669 + 627))) then
								if (v97 or ((1071 + 712) >= (769 + 2847))) then
									v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 14 + 16);
									if (v31 or ((1026 + 2887) > (8665 - 4138))) then
										return v31;
									end
								end
							end
							v223 = 3 + 0;
						end
					end
				end
				break;
			end
			if (((15377 - 11001) > (21 + 796)) and (v161 == (52 - (12 + 39)))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v161 = 2 + 0;
			end
		end
	end
	local function v131()
		local v162 = 0 - 0;
		while true do
			if (((17312 - 12451) > (245 + 579)) and ((0 + 0) == v162)) then
				v113();
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(161 - 97, v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

