local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5488 - (1429 + 348)) > (3397 - (19 + 23))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.MouseOver;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.PressCursor;
	local v25 = v21.Macro;
	local v26 = v21.Bind;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = math.max;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v98 = v18.Mage.Frost;
	local v99 = v20.Mage.Frost;
	local v100 = v25.Mage.Frost;
	local v101 = {};
	local v102, v103;
	local v104, v105;
	local v106 = 0 - 0;
	local v107 = 0 - 0;
	local v108 = 1443 - (1233 + 195);
	local v109 = 37052 - 25941;
	local v110 = 3975 + 7136;
	local v111;
	local v112 = v21.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((369 + 537) >= (1839 + 390))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(61604 + 23117);
	v98.FrozenOrb:RegisterInFlight();
	v9:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(106729 + 121868);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(229787 - (797 + 636));
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(1109925 - 881327);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(230219 - (1427 + 192));
	v98.GlacialSpike:RegisterInFlight();
	v9:RegisterForEvent(function()
		local v132 = 0 + 0;
		while true do
			if (((2990 - 1702) > (1125 + 126)) and (v132 == (0 + 0))) then
				v109 = 11437 - (192 + 134);
				v110 = 12387 - (316 + 960);
				v132 = 1 + 0;
			end
			if ((v132 == (1 + 0)) or ((4172 + 341) < (12814 - 9462))) then
				v106 = 551 - (83 + 468);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v133)
		local v134 = 1806 - (1202 + 604);
		while true do
			if ((v134 == (0 - 0)) or ((3436 - 1371) >= (8848 - 5652))) then
				if ((v133 == nil) or ((4701 - (45 + 280)) <= (1430 + 51))) then
					v133 = v14;
				end
				return not v133:IsInBossList() or (v133:Level() < (64 + 9));
			end
		end
	end
	local function v115()
		return v29(v13:BuffRemains(v98.FingersofFrostBuff), v14:DebuffRemains(v98.WintersChillDebuff), v14:DebuffRemains(v98.Frostbite), v14:DebuffRemains(v98.Freeze), v14:DebuffRemains(v98.FrostNova));
	end
	local function v116(v135)
		return (v135:DebuffStack(v98.WintersChillDebuff));
	end
	local function v117(v136)
		return (v136:DebuffDown(v98.WintersChillDebuff));
	end
	local function v118()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (2 + 1)) or ((597 + 2795) >= (8779 - 4038))) then
				if (((5236 - (340 + 1571)) >= (850 + 1304)) and v98.AlterTime:IsReady() and v61 and (v13:HealthPercentage() <= v68)) then
					if (v23(v98.AlterTime) or ((3067 - (1733 + 39)) >= (8883 - 5650))) then
						return "alter_time defensive 7";
					end
				end
				if (((5411 - (125 + 909)) > (3590 - (1096 + 852))) and v99.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) then
					if (((2119 + 2604) > (1935 - 579)) and v23(v100.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v137 = 4 + 0;
			end
			if ((v137 == (514 - (409 + 103))) or ((4372 - (46 + 190)) <= (3528 - (51 + 44)))) then
				if (((1198 + 3047) <= (5948 - (1114 + 203))) and v98.MirrorImage:IsCastable() and v67 and (v13:HealthPercentage() <= v73)) then
					if (((5002 - (228 + 498)) >= (848 + 3066)) and v23(v98.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if (((110 + 88) <= (5028 - (174 + 489))) and v98.GreaterInvisibility:IsReady() and v63 and (v13:HealthPercentage() <= v70)) then
					if (((12458 - 7676) > (6581 - (830 + 1075))) and v23(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v137 = 527 - (303 + 221);
			end
			if (((6133 - (231 + 1038)) > (1831 + 366)) and (v137 == (1166 - (171 + 991)))) then
				if ((v84 and (v13:HealthPercentage() <= v86)) or ((15248 - 11548) == (6731 - 4224))) then
					if (((11164 - 6690) >= (220 + 54)) and (v88 == "Refreshing Healing Potion")) then
						if (v99.RefreshingHealingPotion:IsReady() or ((6639 - 4745) <= (4055 - 2649))) then
							if (((2533 - 961) >= (4732 - 3201)) and v23(v100.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((5935 - (111 + 1137)) < (4700 - (91 + 67)))) then
						if (((9794 - 6503) > (416 + 1251)) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v100.RefreshingHealingPotion) or ((1396 - (423 + 100)) == (15 + 2019))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((2 - 1) == v137) or ((1468 + 1348) < (782 - (326 + 445)))) then
				if (((16142 - 12443) < (10483 - 5777)) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v65 and (v13:HealthPercentage() <= v72)) then
					if (((6175 - 3529) >= (1587 - (530 + 181))) and v23(v98.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if (((1495 - (614 + 267)) <= (3216 - (19 + 13))) and v98.IceBlock:IsReady() and v64 and (v13:HealthPercentage() <= v71)) then
					if (((5087 - 1961) == (7284 - 4158)) and v23(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v137 = 5 - 3;
			end
			if ((v137 == (0 + 0)) or ((3846 - 1659) >= (10273 - 5319))) then
				if ((v98.IceBarrier:IsCastable() and v62 and v13:BuffDown(v98.IceBarrier) and (v13:HealthPercentage() <= v69)) or ((5689 - (1293 + 519)) == (7294 - 3719))) then
					if (((1845 - 1138) > (1208 - 576)) and v23(v98.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98.MassBarrier:IsCastable() and v66 and v13:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v74, 8 - 6)) or ((1285 - 739) >= (1422 + 1262))) then
					if (((299 + 1166) <= (9993 - 5692)) and v23(v98.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local v119 = 0 + 0;
	local function v120()
		if (((1065 + 639) > (2521 - (709 + 387))) and v98.RemoveCurse:IsReady() and v112.DispellableFriendlyUnit(1878 - (673 + 1185))) then
			local v197 = 0 - 0;
			while true do
				if ((v197 == (0 - 0)) or ((1129 - 442) == (3029 + 1205))) then
					if ((v119 == (0 + 0)) or ((4496 - 1166) < (351 + 1078))) then
						v119 = GetTime();
					end
					if (((2286 - 1139) >= (657 - 322)) and v112.Wait(2380 - (446 + 1434), v119)) then
						local v210 = 1283 - (1040 + 243);
						while true do
							if (((10252 - 6817) > (3944 - (559 + 1288))) and (v210 == (1931 - (609 + 1322)))) then
								if (v23(v100.RemoveCurseFocus) or ((4224 - (13 + 441)) >= (15100 - 11059))) then
									return "remove_curse dispel";
								end
								v119 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		v30 = v112.HandleTopTrinket(v101, v33, 199 - 159, nil);
		if (v30 or ((142 + 3649) <= (5850 - 4239))) then
			return v30;
		end
		v30 = v112.HandleBottomTrinket(v101, v33, 15 + 25, nil);
		if (v30 or ((2007 + 2571) <= (5958 - 3950))) then
			return v30;
		end
	end
	local function v122()
		if (((616 + 509) <= (3817 - 1741)) and v112.TargetIsValid()) then
			local v198 = 0 + 0;
			while true do
				if ((v198 == (0 + 0)) or ((534 + 209) >= (3694 + 705))) then
					if (((1131 + 24) < (2106 - (153 + 280))) and v98.MirrorImage:IsCastable() and v67 and v96) then
						if (v23(v98.MirrorImage) or ((6710 - 4386) <= (519 + 59))) then
							return "mirror_image precombat 2";
						end
					end
					if (((1488 + 2279) == (1972 + 1795)) and v98.Frostbolt:IsCastable() and not v13:IsCasting(v98.Frostbolt)) then
						if (((3711 + 378) == (2963 + 1126)) and v23(v98.Frostbolt, not v14:IsSpellInRange(v98.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		if (((6788 - 2330) >= (1035 + 639)) and v95 and v98.TimeWarp:IsCastable() and v13:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v13:BloodlustDown() and v13:PrevGCDP(668 - (89 + 578), v98.IcyVeins)) then
			if (((695 + 277) <= (2947 - 1529)) and v23(v98.TimeWarp, not v14:IsInRange(1089 - (572 + 477)))) then
				return "time_warp cd 2";
			end
		end
		local v138 = v112.HandleDPSPotion(v13:BuffUp(v98.IcyVeinsBuff));
		if (v138 or ((666 + 4272) < (2858 + 1904))) then
			return v138;
		end
		if ((v98.IcyVeins:IsCastable() and v33 and v51 and v56 and (v82 < v110)) or ((299 + 2205) > (4350 - (84 + 2)))) then
			if (((3548 - 1395) == (1552 + 601)) and v23(v98.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v82 < v110) or ((1349 - (497 + 345)) >= (67 + 2524))) then
			if (((758 + 3723) == (5814 - (605 + 728))) and v90 and ((v33 and v91) or not v91)) then
				v30 = v121();
				if (v30 or ((1661 + 667) < (1540 - 847))) then
					return v30;
				end
			end
		end
		if (((199 + 4129) == (16001 - 11673)) and v89 and ((v92 and v33) or not v92) and (v82 < v110)) then
			if (((1432 + 156) >= (3690 - 2358)) and v98.BloodFury:IsCastable()) then
				if (v23(v98.BloodFury) or ((3152 + 1022) > (4737 - (457 + 32)))) then
					return "blood_fury cd 10";
				end
			end
			if (v98.Berserking:IsCastable() or ((1946 + 2640) <= (1484 - (832 + 570)))) then
				if (((3640 + 223) == (1008 + 2855)) and v23(v98.Berserking)) then
					return "berserking cd 12";
				end
			end
			if (v98.LightsJudgment:IsCastable() or ((997 - 715) <= (21 + 21))) then
				if (((5405 - (588 + 208)) >= (2064 - 1298)) and v23(v98.LightsJudgment, not v14:IsSpellInRange(v98.LightsJudgment))) then
					return "lights_judgment cd 14";
				end
			end
			if (v98.Fireblood:IsCastable() or ((2952 - (884 + 916)) == (5208 - 2720))) then
				if (((1985 + 1437) > (4003 - (232 + 421))) and v23(v98.Fireblood)) then
					return "fireblood cd 16";
				end
			end
			if (((2766 - (1569 + 320)) > (93 + 283)) and v98.AncestralCall:IsCastable()) then
				if (v23(v98.AncestralCall) or ((593 + 2525) <= (6237 - 4386))) then
					return "ancestral_call cd 18";
				end
			end
		end
	end
	local function v124()
		local v139 = 605 - (316 + 289);
		while true do
			if ((v139 == (5 - 3)) or ((8 + 157) >= (4945 - (666 + 787)))) then
				if (((4374 - (360 + 65)) < (4539 + 317)) and v98.IceLance:IsCastable() and v46) then
					if (v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance)) or ((4530 - (79 + 175)) < (4755 - 1739))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if (((3660 + 1030) > (12644 - 8519)) and ((1 - 0) == v139)) then
				if ((v98.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (929 - (503 + 396))) and (v103 >= (183 - (92 + 89)))) or ((96 - 46) >= (460 + 436))) then
					if (v23(v98.ArcaneExplosion, not v14:IsInRange(5 + 3)) or ((6712 - 4998) >= (405 + 2553))) then
						return "arcane_explosion movement";
					end
				end
				if ((v98.FireBlast:IsCastable() and v39) or ((3399 - 1908) < (562 + 82))) then
					if (((337 + 367) < (3006 - 2019)) and v23(v98.FireBlast, not v14:IsSpellInRange(v98.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v139 = 1 + 1;
			end
			if (((5669 - 1951) > (3150 - (485 + 759))) and ((0 - 0) == v139)) then
				if ((v98.IceFloes:IsCastable() and v45 and v13:BuffDown(v98.IceFloes)) or ((2147 - (442 + 747)) > (4770 - (832 + 303)))) then
					if (((4447 - (88 + 858)) <= (1370 + 3122)) and v23(v98.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if ((v98.IceNova:IsCastable() and v47) or ((2849 + 593) < (105 + 2443))) then
					if (((3664 - (766 + 23)) >= (7227 - 5763)) and v23(v98.IceNova, not v14:IsSpellInRange(v98.IceNova))) then
						return "ice_nova movement";
					end
				end
				v139 = 1 - 0;
			end
		end
	end
	local function v125()
		if ((v98.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v110) and v98.ColdestSnap:IsAvailable() and (v13:PrevGCDP(2 - 1, v98.CometStorm) or (v13:PrevGCDP(3 - 2, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) or ((5870 - (1036 + 37)) >= (3470 + 1423))) then
			if (v23(v98.ConeofCold, not v14:IsInRange(15 - 7)) or ((434 + 117) > (3548 - (641 + 839)))) then
				return "cone_of_cold aoe 2";
			end
		end
		if (((3027 - (910 + 3)) > (2406 - 1462)) and v98.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v110) and (not v13:PrevGCDP(1685 - (1466 + 218), v98.GlacialSpike) or not v114())) then
			if (v23(v100.FrozenOrbCast, not v14:IsInRange(19 + 21)) or ((3410 - (556 + 592)) >= (1101 + 1995))) then
				return "frozen_orb aoe 4";
			end
		end
		if ((v98.Blizzard:IsCastable() and v37 and (not v13:PrevGCDP(809 - (329 + 479), v98.GlacialSpike) or not v114())) or ((3109 - (174 + 680)) >= (12153 - 8616))) then
			if (v23(v100.BlizzardCursor, not v14:IsInRange(82 - 42)) or ((2740 + 1097) < (2045 - (396 + 343)))) then
				return "blizzard aoe 6";
			end
		end
		if (((262 + 2688) == (4427 - (29 + 1448))) and v98.CometStorm:IsCastable() and ((v58 and v33) or not v58) and v53 and (v82 < v110) and not v13:PrevGCDP(1390 - (135 + 1254), v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (94 - 69))) or (v98.ConeofCold:CooldownRemains() > (93 - 73)))) then
			if (v23(v98.CometStorm, not v14:IsSpellInRange(v98.CometStorm)) or ((3148 + 1575) < (4825 - (389 + 1138)))) then
				return "comet_storm aoe 8";
			end
		end
		if (((1710 - (102 + 472)) >= (146 + 8)) and v17:IsActive() and v43 and v98.Freeze:IsReady() and v114() and (v115() == (0 + 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v13:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v13:BuffStack(v98.SnowstormBuff) == v108)))) then
			if (v23(v100.FreezePet, not v14:IsSpellInRange(v98.Freeze)) or ((1816 - (320 + 1225)) > (8452 - 3704))) then
				return "freeze aoe 10";
			end
		end
		if (((2901 + 1839) >= (4616 - (157 + 1307))) and v98.IceNova:IsCastable() and v47 and v114() and not v13:PrevOffGCDP(1860 - (821 + 1038), v98.Freeze) and (v13:PrevGCDP(2 - 1, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v13:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) then
			if (v23(v98.IceNova, not v14:IsSpellInRange(v98.IceNova)) or ((4578 - 2000) >= (1262 + 2128))) then
				return "ice_nova aoe 11";
			end
		end
		if (((101 - 60) <= (2687 - (834 + 192))) and v98.FrostNova:IsCastable() and v41 and v114() and not v13:PrevOffGCDP(1 + 0, v98.Freeze) and ((v13:PrevGCDP(1 + 0, v98.GlacialSpike) and (v106 == (0 + 0))) or (v98.ConeofCold:CooldownUp() and (v13:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 - 0))))) then
			if (((905 - (300 + 4)) < (951 + 2609)) and v23(v98.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if (((615 - 380) < (1049 - (112 + 250))) and v98.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v110) and (v13:BuffStackP(v98.SnowstormBuff) == v108)) then
			if (((1814 + 2735) > (2888 - 1735)) and v23(v98.ConeofCold, not v14:IsInRange(5 + 3))) then
				return "cone_of_cold aoe 14";
			end
		end
		if ((v98.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v110)) or ((2418 + 2256) < (3495 + 1177))) then
			if (((1819 + 1849) < (3389 + 1172)) and v23(v98.ShiftingPower, not v14:IsInRange(1454 - (1001 + 413)), true)) then
				return "shifting_power aoe 16";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v44 and (v107 == (11 - 6)) and (v98.Blizzard:CooldownRemains() > v111)) or ((1337 - (244 + 638)) == (4298 - (627 + 66)))) then
			if (v23(v98.GlacialSpike, not v14:IsSpellInRange(v98.GlacialSpike)) or ((7934 - 5271) == (3914 - (512 + 90)))) then
				return "glacial_spike aoe 18";
			end
		end
		if (((6183 - (1665 + 241)) <= (5192 - (373 + 344))) and v98.Flurry:IsCastable() and v42 and not v114() and (v106 == (0 + 0)) and (v13:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (2.8 - 1)))) then
			if (v23(v98.Flurry, not v14:IsSpellInRange(v98.Flurry)) or ((1472 - 602) == (2288 - (35 + 1064)))) then
				return "flurry aoe 20";
			end
		end
		if (((1130 + 423) <= (6702 - 3569)) and v98.Flurry:IsCastable() and v42 and (v106 == (0 + 0)) and (v13:BuffUp(v98.BrainFreezeBuff) or v13:BuffUp(v98.FingersofFrostBuff))) then
			if (v23(v98.Flurry, not v14:IsSpellInRange(v98.Flurry)) or ((3473 - (298 + 938)) >= (4770 - (233 + 1026)))) then
				return "flurry aoe 21";
			end
		end
		if ((v98.IceLance:IsCastable() and v46 and (v13:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v28(v106))) or ((2990 - (636 + 1030)) > (1545 + 1475))) then
			if (v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance)) or ((2923 + 69) == (559 + 1322))) then
				return "ice_lance aoe 22";
			end
		end
		if (((210 + 2896) > (1747 - (55 + 166))) and v98.IceNova:IsCastable() and v47 and (v102 >= (1 + 3)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) then
			if (((304 + 2719) < (14779 - 10909)) and v23(v98.IceNova, not v14:IsSpellInRange(v98.IceNova))) then
				return "ice_nova aoe 23";
			end
		end
		if (((440 - (36 + 261)) > (129 - 55)) and v98.DragonsBreath:IsCastable() and v38 and (v103 >= (1375 - (34 + 1334)))) then
			if (((7 + 11) < (1641 + 471)) and v23(v98.DragonsBreath, not v14:IsInRange(1293 - (1035 + 248)))) then
				return "dragons_breath aoe 26";
			end
		end
		if (((1118 - (20 + 1)) <= (849 + 779)) and v98.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (349 - (134 + 185))) and (v103 >= (1140 - (549 + 584)))) then
			if (((5315 - (314 + 371)) == (15894 - 11264)) and v23(v98.ArcaneExplosion, not v14:IsInRange(976 - (478 + 490)))) then
				return "arcane_explosion aoe 28";
			end
		end
		if (((1876 + 1664) > (3855 - (786 + 386))) and v98.Frostbolt:IsCastable() and v40) then
			if (((15527 - 10733) >= (4654 - (1055 + 324))) and v23(v98.Frostbolt, not v14:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt aoe 32";
			end
		end
		if (((2824 - (1093 + 247)) == (1319 + 165)) and v13:IsMoving() and v94) then
			v30 = v124();
			if (((151 + 1281) < (14113 - 10558)) and v30) then
				return v30;
			end
		end
	end
	local function v126()
		local v140 = 0 - 0;
		while true do
			if (((0 - 0) == v140) or ((2676 - 1611) > (1273 + 2305))) then
				if ((v98.CometStorm:IsCastable() and (v13:PrevGCDP(3 - 2, v98.Flurry) or v13:PrevGCDP(3 - 2, v98.ConeofCold)) and ((v58 and v33) or not v58) and v53 and (v82 < v110)) or ((3616 + 1179) < (3598 - 2191))) then
					if (((2541 - (364 + 324)) < (13193 - 8380)) and v23(v98.CometStorm, not v14:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v98.Flurry:IsCastable() and v42 and ((v13:PrevGCDP(2 - 1, v98.Frostbolt) and (v107 >= (1 + 2))) or v13:PrevGCDP(4 - 3, v98.GlacialSpike) or ((v107 >= (4 - 1)) and (v107 < (15 - 10)) and (v98.Flurry:ChargesFractional() == (1270 - (1249 + 19)))))) or ((2547 + 274) < (9462 - 7031))) then
					local v203 = 1086 - (686 + 400);
					while true do
						if ((v203 == (0 + 0)) or ((3103 - (73 + 156)) < (11 + 2170))) then
							if (v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v14:IsSpellInRange(v98.Flurry)) or ((3500 - (721 + 90)) <= (4 + 339))) then
								return "flurry cleave 4";
							end
							if (v23(v98.Flurry, not v14:IsSpellInRange(v98.Flurry)) or ((6068 - 4199) == (2479 - (224 + 246)))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if ((v98.IceLance:IsReady() and v46 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (0 - 0)) and (v107 == (6 - 2)) and v13:BuffUp(v98.FingersofFrostBuff)) or ((644 + 2902) < (56 + 2266))) then
					local v204 = 0 + 0;
					while true do
						if ((v204 == (0 - 0)) or ((6928 - 4846) == (5286 - (203 + 310)))) then
							if (((5237 - (1238 + 755)) > (74 + 981)) and v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v14:IsSpellInRange(v98.IceLance))) then
								return "ice_lance cleave 6";
							end
							if (v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance)) or ((4847 - (709 + 825)) <= (3276 - 1498))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				if ((v98.RayofFrost:IsCastable() and (v106 == (1 - 0)) and v48) or ((2285 - (196 + 668)) >= (8306 - 6202))) then
					local v205 = 0 - 0;
					while true do
						if (((2645 - (171 + 662)) <= (3342 - (4 + 89))) and (v205 == (0 - 0))) then
							if (((591 + 1032) <= (8595 - 6638)) and v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v14:IsSpellInRange(v98.RayofFrost))) then
								return "ray_of_frost cleave 8";
							end
							if (((1731 + 2681) == (5898 - (35 + 1451))) and v23(v98.RayofFrost, not v14:IsSpellInRange(v98.RayofFrost))) then
								return "ray_of_frost cleave 8";
							end
							break;
						end
					end
				end
				v140 = 1454 - (28 + 1425);
			end
			if (((3743 - (941 + 1052)) >= (808 + 34)) and (v140 == (1517 - (822 + 692)))) then
				if (((6241 - 1869) > (872 + 978)) and v98.Frostbolt:IsCastable() and v40) then
					if (((529 - (45 + 252)) < (813 + 8)) and v23(v98.Frostbolt, not v14:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt cleave 26";
					end
				end
				if (((179 + 339) < (2194 - 1292)) and v13:IsMoving() and v94) then
					v30 = v124();
					if (((3427 - (114 + 319)) > (1231 - 373)) and v30) then
						return v30;
					end
				end
				break;
			end
			if ((v140 == (2 - 0)) or ((2394 + 1361) <= (1363 - 448))) then
				if (((8267 - 4321) > (5706 - (556 + 1407))) and v98.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v110) and (((v98.FrozenOrb:CooldownRemains() > (1216 - (741 + 465))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (475 - (170 + 295)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (6 + 4)))) or (v98.IcyVeins:CooldownRemains() < (19 + 1)))) then
					if (v23(v98.ShiftingPower, not v14:IsSpellInRange(v98.ShiftingPower), true) or ((3286 - 1951) >= (2741 + 565))) then
						return "shifting_power cleave 18";
					end
				end
				if (((3107 + 1737) > (1276 + 977)) and v98.GlacialSpike:IsReady() and v44 and (v107 == (1235 - (957 + 273)))) then
					if (((121 + 331) == (181 + 271)) and v23(v98.GlacialSpike, not v14:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v98.IceLance:IsReady() and v46 and ((v13:BuffStackP(v98.FingersofFrostBuff) and not v13:PrevGCDP(3 - 2, v98.GlacialSpike)) or (v106 > (0 - 0)))) or ((13918 - 9361) < (10334 - 8247))) then
					if (((5654 - (389 + 1391)) == (2431 + 1443)) and v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v14:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance)) or ((202 + 1736) > (11235 - 6300))) then
						return "ice_lance cleave 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v47 and (v103 >= (955 - (783 + 168)))) or ((14280 - 10025) < (3367 + 56))) then
					if (((1765 - (309 + 2)) <= (7649 - 5158)) and v23(v98.IceNova, not v14:IsSpellInRange(v98.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v140 = 1215 - (1090 + 122);
			end
			if ((v140 == (1 + 0)) or ((13961 - 9804) <= (1919 + 884))) then
				if (((5971 - (628 + 490)) >= (535 + 2447)) and v98.GlacialSpike:IsReady() and v44 and (v107 == (12 - 7)) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) then
					if (((4908 - (431 + 343)) > (6779 - 3422)) and v23(v98.GlacialSpike, not v14:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v110) and (v13:BuffStackP(v98.FingersofFrostBuff) < (5 - 3)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((2700 + 717) < (325 + 2209))) then
					if (v23(v100.FrozenOrbCast, not v14:IsSpellInRange(v98.FrozenOrb)) or ((4417 - (556 + 1139)) <= (179 - (6 + 9)))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (2 + 8)) and (v98.FrozenOrb:CooldownRemains() > (6 + 4)) and (v106 == (169 - (28 + 141))) and (v103 >= (2 + 1))) or ((2971 - 563) < (1494 + 615))) then
					if (v23(v98.ConeofCold) or ((1350 - (486 + 831)) == (3786 - 2331))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v37 and (v103 >= (6 - 4)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v13:BuffUp(v98.FreezingRainBuff) or (v103 >= (1 + 2)))) or ((1400 - 957) >= (5278 - (668 + 595)))) then
					if (((3044 + 338) > (34 + 132)) and v23(v100.BlizzardCursor, not v14:IsSpellInRange(v98.Blizzard))) then
						return "blizzard cleave 16";
					end
				end
				v140 = 5 - 3;
			end
		end
	end
	local function v127()
		local v141 = 290 - (23 + 267);
		while true do
			if ((v141 == (1944 - (1129 + 815))) or ((667 - (371 + 16)) == (4809 - (1326 + 424)))) then
				if (((3562 - 1681) > (4724 - 3431)) and v98.CometStorm:IsCastable() and v53 and ((v58 and v33) or not v58) and (v82 < v110) and (v13:PrevGCDP(119 - (88 + 30), v98.Flurry) or v13:PrevGCDP(772 - (720 + 51), v98.ConeofCold))) then
					if (((5243 - 2886) == (4133 - (421 + 1355))) and v23(v98.CometStorm, not v14:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((202 - 79) == (61 + 62)) and v98.Flurry:IsCastable() and (v106 == (1083 - (286 + 797))) and v14:DebuffDown(v98.WintersChillDebuff) and ((v13:PrevGCDP(3 - 2, v98.Frostbolt) and (v107 >= (4 - 1))) or (v13:PrevGCDP(440 - (397 + 42), v98.Frostbolt) and v13:BuffUp(v98.BrainFreezeBuff)) or v13:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (804 - (24 + 776))) and v13:BuffDown(v98.FingersofFrostBuff)))) then
					if (v23(v98.Flurry, not v14:IsSpellInRange(v98.Flurry)) or ((1626 - 570) >= (4177 - (222 + 563)))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v46 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 - 0)) and (v107 == (3 + 1)) and v13:BuffUp(v98.FingersofFrostBuff)) or ((1271 - (23 + 167)) < (2873 - (690 + 1108)))) then
					if (v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance)) or ((379 + 670) >= (3656 + 776))) then
						return "ice_lance single 6";
					end
				end
				v141 = 849 - (40 + 808);
			end
			if ((v141 == (1 + 3)) or ((18232 - 13464) <= (809 + 37))) then
				if ((v89 and ((v92 and v33) or not v92)) or ((1777 + 1581) <= (779 + 641))) then
					if (v98.BagofTricks:IsCastable() or ((4310 - (47 + 524)) <= (1951 + 1054))) then
						if (v23(v98.BagofTricks, not v14:IsSpellInRange(v98.BagofTricks)) or ((4534 - 2875) >= (3190 - 1056))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((v98.Frostbolt:IsCastable() and v40) or ((7434 - 4174) < (4081 - (1165 + 561)))) then
					if (v23(v98.Frostbolt, not v14:IsSpellInRange(v98.Frostbolt), true) or ((20 + 649) == (13079 - 8856))) then
						return "frostbolt single 26";
					end
				end
				if ((v13:IsMoving() and v94) or ((646 + 1046) < (1067 - (341 + 138)))) then
					local v206 = 0 + 0;
					while true do
						if ((v206 == (0 - 0)) or ((5123 - (89 + 237)) < (11745 - 8094))) then
							v30 = v124();
							if (v30 or ((8793 - 4616) > (5731 - (581 + 300)))) then
								return v30;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v141 == (1222 - (855 + 365))) or ((950 - 550) > (363 + 748))) then
				if (((4286 - (1030 + 205)) > (944 + 61)) and v98.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (10 + 0)) and (v98.FrozenOrb:CooldownRemains() > (296 - (156 + 130))) and (v106 == (0 - 0)) and (v102 >= (4 - 1))) then
					if (((7563 - 3870) <= (1155 + 3227)) and v23(v98.ConeofCold, not v14:IsInRange(5 + 3))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v37 and (v102 >= (71 - (10 + 59))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v13:BuffUp(v98.FreezingRainBuff) or (v102 >= (1 + 2)))) or ((16163 - 12881) > (5263 - (671 + 492)))) then
					if (v23(v100.BlizzardCursor, not v14:IsInRange(32 + 8)) or ((4795 - (369 + 846)) < (753 + 2091))) then
						return "blizzard single 16";
					end
				end
				if (((76 + 13) < (6435 - (1036 + 909))) and v98.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (16 - 6)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (213 - (11 + 192)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (6 + 4)))) or (v98.IcyVeins:CooldownRemains() < (195 - (135 + 40))))) then
					if (v23(v98.ShiftingPower, not v14:IsInRange(96 - 56)) or ((3004 + 1979) < (3982 - 2174))) then
						return "shifting_power single 18";
					end
				end
				v141 = 4 - 1;
			end
			if (((4005 - (50 + 126)) > (10494 - 6725)) and (v141 == (1 + 0))) then
				if (((2898 - (1233 + 180)) <= (3873 - (522 + 447))) and v98.RayofFrost:IsCastable() and v48 and (v14:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (1422 - (107 + 1314)))) then
					if (((1981 + 2288) == (13007 - 8738)) and v23(v98.RayofFrost, not v14:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				if (((165 + 222) <= (5524 - 2742)) and v98.GlacialSpike:IsReady() and v44 and (v107 == (19 - 14)) and ((v98.Flurry:Charges() >= (1911 - (716 + 1194))) or ((v106 > (0 + 0)) and (v98.GlacialSpike:CastTime() < v14:DebuffRemains(v98.WintersChillDebuff))))) then
					if (v23(v98.GlacialSpike, not v14:IsSpellInRange(v98.GlacialSpike)) or ((204 + 1695) <= (1420 - (74 + 429)))) then
						return "glacial_spike single 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and v52 and ((v57 and v33) or not v57) and (v82 < v110) and (v106 == (0 - 0)) and (v13:BuffStackP(v98.FingersofFrostBuff) < (1 + 1)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((9870 - 5558) <= (620 + 256))) then
					if (((6880 - 4648) <= (6418 - 3822)) and v23(v100.FrozenOrbCast, not v14:IsInRange(473 - (279 + 154)))) then
						return "frozen_orb single 12";
					end
				end
				v141 = 780 - (454 + 324);
			end
			if (((1649 + 446) < (3703 - (12 + 5))) and (v141 == (2 + 1))) then
				if ((v98.GlacialSpike:IsReady() and v44 and (v107 == (12 - 7))) or ((590 + 1005) >= (5567 - (277 + 816)))) then
					if (v23(v98.GlacialSpike, not v14:IsSpellInRange(v98.GlacialSpike)) or ((19737 - 15118) < (4065 - (1058 + 125)))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v46 and ((v13:BuffUp(v98.FingersofFrostBuff) and not v13:PrevGCDP(1 + 0, v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v28(v106))) or ((1269 - (815 + 160)) >= (20728 - 15897))) then
					if (((4816 - 2787) <= (736 + 2348)) and v23(v98.IceLance, not v14:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v47 and (v103 >= (11 - 7))) or ((3935 - (41 + 1857)) == (4313 - (1222 + 671)))) then
					if (((11521 - 7063) > (5611 - 1707)) and v23(v98.IceNova, not v14:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v141 = 1186 - (229 + 953);
			end
		end
	end
	local function v128()
		v35 = EpicSettings.Settings['useArcaneExplosion'];
		v36 = EpicSettings.Settings['useArcaneIntellect'];
		v37 = EpicSettings.Settings['useBlizzard'];
		v38 = EpicSettings.Settings['useDragonsBreath'];
		v39 = EpicSettings.Settings['useFireBlast'];
		v40 = EpicSettings.Settings['useFrostbolt'];
		v41 = EpicSettings.Settings['useFrostNova'];
		v42 = EpicSettings.Settings['useFlurry'];
		v43 = EpicSettings.Settings['useFreezePet'];
		v44 = EpicSettings.Settings['useGlacialSpike'];
		v45 = EpicSettings.Settings['useIceFloes'];
		v46 = EpicSettings.Settings['useIceLance'];
		v47 = EpicSettings.Settings['useIceNova'];
		v48 = EpicSettings.Settings['useRayOfFrost'];
		v49 = EpicSettings.Settings['useCounterspell'];
		v50 = EpicSettings.Settings['useBlastWave'];
		v51 = EpicSettings.Settings['useIcyVeins'];
		v52 = EpicSettings.Settings['useFrozenOrb'];
		v53 = EpicSettings.Settings['useCometStorm'];
		v54 = EpicSettings.Settings['useConeOfCold'];
		v55 = EpicSettings.Settings['useShiftingPower'];
		v56 = EpicSettings.Settings['icyVeinsWithCD'];
		v57 = EpicSettings.Settings['frozenOrbWithCD'];
		v58 = EpicSettings.Settings['cometStormWithCD'];
		v59 = EpicSettings.Settings['coneOfColdWithCD'];
		v60 = EpicSettings.Settings['shiftingPowerWithCD'];
		v61 = EpicSettings.Settings['useAlterTime'];
		v62 = EpicSettings.Settings['useIceBarrier'];
		v63 = EpicSettings.Settings['useGreaterInvisibility'];
		v64 = EpicSettings.Settings['useIceBlock'];
		v65 = EpicSettings.Settings['useIceCold'];
		v66 = EpicSettings.Settings['useMassBarrier'];
		v67 = EpicSettings.Settings['useMirrorImage'];
		v68 = EpicSettings.Settings['alterTimeHP'] or (1774 - (1111 + 663));
		v69 = EpicSettings.Settings['iceBarrierHP'] or (1579 - (874 + 705));
		v72 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v70 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v71 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v73 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v74 = EpicSettings.Settings['massBarrierHP'] or (679 - (642 + 37));
		v93 = EpicSettings.Settings['useSpellStealTarget'];
		v94 = EpicSettings.Settings['useSpellsWhileMoving'];
		v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v96 = EpicSettings.Settings['mirrorImageBeforePull'];
		v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v129()
		v82 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v83 = EpicSettings.Settings['useWeapon'];
		v79 = EpicSettings.Settings['InterruptWithStun'];
		v80 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v81 = EpicSettings.Settings['InterruptThreshold'];
		v76 = EpicSettings.Settings['DispelDebuffs'];
		v75 = EpicSettings.Settings['DispelBuffs'];
		v90 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v91 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v85 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v88 = EpicSettings.Settings['HealingPotionName'] or "";
		v77 = EpicSettings.Settings['handleAfflicted'];
		v78 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v130()
		local v194 = 454 - (233 + 221);
		while true do
			if (((1008 - 572) >= (109 + 14)) and (v194 == (1542 - (718 + 823)))) then
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (((315 + 185) < (2621 - (266 + 539))) and v13:IsDeadOrGhost()) then
					return v30;
				end
				v104 = v14:GetEnemiesInSplashRange(13 - 8);
				v194 = 1227 - (636 + 589);
			end
			if (((8483 - 4909) == (7371 - 3797)) and (v194 == (0 + 0))) then
				v128();
				v129();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v194 = 1 + 0;
			end
			if (((1236 - (657 + 358)) < (1032 - 642)) and (v194 == (4 - 2))) then
				v105 = v13:GetEnemiesInRange(1227 - (1151 + 36));
				if (v32 or ((2138 + 75) <= (374 + 1047))) then
					local v207 = 0 - 0;
					while true do
						if (((4890 - (1552 + 280)) < (5694 - (64 + 770))) and (v207 == (0 + 0))) then
							v102 = v29(v14:GetEnemiesInSplashRangeCount(11 - 6), #v105);
							v103 = v29(v14:GetEnemiesInSplashRangeCount(1 + 4), #v105);
							break;
						end
					end
				else
					v102 = 1244 - (157 + 1086);
					v103 = 1 - 0;
				end
				if (not v13:AffectingCombat() or ((5676 - 4380) >= (6819 - 2373))) then
					if ((v98.ArcaneIntellect:IsCastable() and v36 and (v13:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) or ((1900 - 507) > (5308 - (599 + 220)))) then
						if (v23(v98.ArcaneIntellect) or ((8809 - 4385) < (1958 - (1813 + 118)))) then
							return "arcane_intellect";
						end
					end
				end
				if (v112.TargetIsValid() or v13:AffectingCombat() or ((1460 + 537) > (5032 - (841 + 376)))) then
					local v208 = 0 - 0;
					while true do
						if (((805 + 2660) > (5221 - 3308)) and ((859 - (464 + 395)) == v208)) then
							v109 = v9.BossFightRemains(nil, true);
							v110 = v109;
							v208 = 2 - 1;
						end
						if (((353 + 380) < (2656 - (467 + 370))) and (v208 == (1 - 0))) then
							if ((v110 == (8157 + 2954)) or ((15066 - 10671) == (742 + 4013))) then
								v110 = v9.FightRemains(v105, false);
							end
							v106 = v14:DebuffStack(v98.WintersChillDebuff);
							v208 = 4 - 2;
						end
						if ((v208 == (522 - (150 + 370))) or ((5075 - (74 + 1208)) < (5826 - 3457))) then
							v107 = v13:BuffStackP(v98.IciclesBuff);
							v111 = v13:GCD();
							break;
						end
					end
				end
				v194 = 14 - 11;
			end
			if ((v194 == (3 + 0)) or ((4474 - (14 + 376)) == (459 - 194))) then
				if (((2820 + 1538) == (3829 + 529)) and v112.TargetIsValid()) then
					local v209 = 0 + 0;
					while true do
						if ((v209 == (5 - 3)) or ((2361 + 777) < (1071 - (23 + 55)))) then
							if (((7891 - 4561) > (1551 + 772)) and (v13:AffectingCombat() or v76)) then
								local v211 = 0 + 0;
								local v212;
								while true do
									if (((0 - 0) == v211) or ((1141 + 2485) == (4890 - (652 + 249)))) then
										v212 = v76 and v98.RemoveCurse:IsReady() and v34;
										v30 = v112.FocusUnit(v212, v100, 53 - 33, nil, 1888 - (708 + 1160));
										v211 = 2 - 1;
									end
									if ((v211 == (1 - 0)) or ((943 - (10 + 17)) == (600 + 2071))) then
										if (((2004 - (1400 + 332)) == (521 - 249)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (((6157 - (242 + 1666)) <= (2071 + 2768)) and v77) then
								if (((1018 + 1759) < (2728 + 472)) and v97) then
									local v215 = 940 - (850 + 90);
									while true do
										if (((165 - 70) < (3347 - (360 + 1030))) and ((0 + 0) == v215)) then
											v30 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 84 - 54);
											if (((1135 - 309) < (3378 - (909 + 752))) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v209 = 1226 - (109 + 1114);
						end
						if (((2610 - 1184) >= (431 + 674)) and (v209 == (246 - (6 + 236)))) then
							if (((1736 + 1018) <= (2720 + 659)) and v13:AffectingCombat() and v112.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
								if ((v33 and v83 and (v99.Dreambinder:IsEquippedAndReady() or v99.Iridal:IsEquippedAndReady())) or ((9260 - 5333) == (2467 - 1054))) then
									if (v23(v100.UseWeapon, nil) or ((2287 - (1076 + 57)) <= (130 + 658))) then
										return "Using Weapon Macro";
									end
								end
								if (v33 or ((2332 - (579 + 110)) > (267 + 3112))) then
									v30 = v123();
									if (v30 or ((2479 + 324) > (2415 + 2134))) then
										return v30;
									end
								end
								if ((v32 and (((v103 >= (414 - (174 + 233))) and not v13:HasTier(83 - 53, 3 - 1)) or ((v103 >= (2 + 1)) and v98.IceCaller:IsAvailable()))) or ((1394 - (663 + 511)) >= (2696 + 326))) then
									local v216 = 0 + 0;
									while true do
										if (((8699 - 5877) == (1709 + 1113)) and (v216 == (2 - 1))) then
											if (v23(v98.Pool) or ((2568 - 1507) == (887 + 970))) then
												return "pool for Aoe()";
											end
											break;
										end
										if (((5371 - 2611) > (973 + 391)) and (v216 == (0 + 0))) then
											v30 = v125();
											if (v30 or ((5624 - (478 + 244)) <= (4112 - (440 + 77)))) then
												return v30;
											end
											v216 = 1 + 0;
										end
									end
								end
								if ((v32 and (v103 == (7 - 5))) or ((5408 - (655 + 901)) == (55 + 238))) then
									v30 = v126();
									if (v30 or ((1194 + 365) == (3098 + 1490))) then
										return v30;
									end
									if (v23(v98.Pool) or ((18064 - 13580) == (2233 - (695 + 750)))) then
										return "pool for Cleave()";
									end
								end
								v30 = v127();
								if (((15598 - 11030) >= (6029 - 2122)) and v30) then
									return v30;
								end
								if (((5011 - 3765) < (3821 - (285 + 66))) and v23(v98.Pool)) then
									return "pool for ST()";
								end
								if (((9482 - 5414) >= (2282 - (682 + 628))) and v13:IsMoving() and v94) then
									v30 = v124();
									if (((80 + 413) < (4192 - (176 + 123))) and v30) then
										return v30;
									end
								end
							end
							break;
						end
						if ((v209 == (2 + 1)) or ((1069 + 404) >= (3601 - (239 + 30)))) then
							if (v78 or ((1102 + 2949) <= (1113 + 44))) then
								local v213 = 0 - 0;
								while true do
									if (((1884 - 1280) < (3196 - (306 + 9))) and (v213 == (0 - 0))) then
										v30 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 6 + 24, true);
										if (v30 or ((553 + 347) == (1626 + 1751))) then
											return v30;
										end
										break;
									end
								end
							end
							if (((12750 - 8291) > (1966 - (1140 + 235))) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v34 and v75 and not v13:IsCasting() and not v13:IsChanneling() and v112.UnitHasMagicBuff(v14)) then
								if (((2163 + 1235) >= (2197 + 198)) and v23(v98.Spellsteal, not v14:IsSpellInRange(v98.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v209 = 2 + 2;
						end
						if ((v209 == (53 - (33 + 19))) or ((789 + 1394) >= (8464 - 5640))) then
							v30 = v118();
							if (((853 + 1083) == (3796 - 1860)) and v30) then
								return v30;
							end
							v209 = 2 + 0;
						end
						if (((689 - (586 + 103)) == v209) or ((440 + 4392) < (13278 - 8965))) then
							if (((5576 - (1309 + 179)) > (6993 - 3119)) and v76 and v34 and v98.RemoveCurse:IsAvailable()) then
								local v214 = 0 + 0;
								while true do
									if (((11633 - 7301) == (3273 + 1059)) and (v214 == (0 - 0))) then
										if (((7968 - 3969) >= (3509 - (295 + 314))) and v15) then
											v30 = v120();
											if (v30 or ((6201 - 3676) > (6026 - (1300 + 662)))) then
												return v30;
											end
										end
										if (((13725 - 9354) == (6126 - (1178 + 577))) and v16 and v16:Exists() and v16:IsAPlayer() and v112.UnitHasCurseDebuff(v16)) then
											if (v98.RemoveCurse:IsReady() or ((139 + 127) > (14739 - 9753))) then
												if (((3396 - (851 + 554)) >= (818 + 107)) and v23(v100.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if (((1261 - 806) < (4458 - 2405)) and not v13:AffectingCombat() and v31) then
								v30 = v122();
								if (v30 or ((1128 - (115 + 187)) == (3716 + 1135))) then
									return v30;
								end
							end
							v209 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		v113();
		v98.WintersChillDebuff:RegisterAuraTracking();
		v21.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(251 - 187, v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

