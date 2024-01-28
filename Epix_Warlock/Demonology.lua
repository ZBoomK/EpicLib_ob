local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((18 + 4) <= (1208 + 1047)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((3507 - 2421) >= (3144 - (404 + 1335)))) then
				return v1(v4, ...);
			end
			v5 = 407 - (183 + 223);
		end
		if ((v5 == (1 - 0)) or ((1570 + 799) == (154 + 272))) then
			return v6(...);
		end
	end
end
v0["Epix_Warlock_Demonology.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = v10.Macro;
	local v21 = v10.AoEON;
	local v22 = v10.CDsON;
	local v23 = v10.Cast;
	local v24 = v10.Press;
	local v25 = v10.Commons.Warlock;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
	local v28 = math.max;
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
	local v45;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local function v58()
		local v113 = 337 - (10 + 327);
		while true do
			if ((v113 == (3 + 0)) or ((3414 - (118 + 220)) > (1061 + 2122))) then
				v48 = EpicSettings.Settings['DemonboltOpener'];
				v49 = EpicSettings.Settings["Use Guillotine"] or (449 - (108 + 341));
				v45 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				v50 = EpicSettings.Settings['DemonicStrength'];
				v113 = 16 - 12;
			end
			if (((2695 - (711 + 782)) > (2028 - 970)) and (v113 == (471 - (270 + 199)))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (1819 - (580 + 1239));
				v46 = EpicSettings.Settings['SummonPet'];
				v47 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v113 = 3 + 0;
			end
			if (((134 + 3577) > (1462 + 1893)) and (v113 == (0 - 0))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v113 = 1168 - (645 + 522);
			end
			if ((v113 == (1796 - (1010 + 780))) or ((906 + 0) >= (10618 - 8389))) then
				v44 = EpicSettings.Settings['HealthFunnelHP'] or (0 - 0);
				v45 = EpicSettings.Settings['UnendingResolveHP'] or (1836 - (1045 + 791));
				break;
			end
			if (((3259 - 1971) > (1909 - 658)) and (v113 == (506 - (351 + 154)))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (1574 - (1281 + 293));
				v37 = EpicSettings.Settings['UseHealthstone'] or (266 - (28 + 238));
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (1559 - (1381 + 178));
				v113 = 2 + 0;
			end
			if ((v113 == (5 + 0)) or ((1926 + 2587) < (11555 - 8203))) then
				v55 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
				v56 = EpicSettings.Settings['UseBurningRush'] or (470 - (381 + 89));
				v57 = EpicSettings.Settings['BurningRushHP'] or (0 + 0);
				v43 = EpicSettings.Settings['DrainLifeHP'] or (0 + 0);
				v113 = 9 - 3;
			end
			if ((v113 == (1160 - (1074 + 82))) or ((4525 - 2460) >= (4980 - (214 + 1570)))) then
				v51 = EpicSettings.Settings['GrimoireFelguard'];
				v52 = EpicSettings.Settings['Implosion'];
				v53 = EpicSettings.Settings['NetherPortal'];
				v54 = EpicSettings.Settings['PowerSiphon'];
				v113 = 1460 - (990 + 465);
			end
		end
	end
	local v59 = v18.Warlock.Demonology;
	local v60 = v19.Warlock.Demonology;
	local v61 = v20.Warlock.Demonology;
	local v62 = {v60.NymuesUnravelingSpindle:ID(),v60.TimeThiefsGambit:ID()};
	local v63 = v13:GetEquipment();
	local v64 = (v63[13 + 0] and v19(v63[50 - 37])) or v19(1726 - (1668 + 58));
	local v65 = (v63[640 - (512 + 114)] and v19(v63[36 - 22])) or v19(0 - 0);
	local v66 = 38662 - 27551;
	local v67 = 5169 + 5942;
	local v68 = 3 + 11 + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
	local v69 = 0 + 0;
	local v70 = false;
	local v71 = false;
	local v72 = false;
	local v73 = 0 - 0;
	local v74 = 1994 - (109 + 1885);
	local v75 = 1469 - (1269 + 200);
	local v76 = 230 - 110;
	local v77 = 827 - (98 + 717);
	local v78 = 826 - (802 + 24);
	local v79 = 0 - 0;
	local v80 = 0 - 0;
	local v81;
	local v82, v83;
	v10:RegisterForEvent(function()
		v66 = 1641 + 9470;
		v67 = 8537 + 2574;
	end, "PLAYER_REGEN_ENABLED");
	local v84 = v10.Commons.Everyone;
	local v85 = {{v59.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v114 = 0 + 0;
		while true do
			if ((v114 == (0 + 0)) or ((3610 + 766) <= (1077 + 404))) then
				v63 = v13:GetEquipment();
				v64 = (v63[7 + 6] and v19(v63[1446 - (797 + 636)])) or v19(0 - 0);
				v114 = 1620 - (1427 + 192);
			end
			if ((v114 == (1 + 0)) or ((7875 - 4483) >= (4262 + 479))) then
				v65 = (v63[7 + 7] and v19(v63[340 - (192 + 134)])) or v19(1276 - (316 + 960));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v115 = 0 + 0;
		while true do
			if (((2566 + 759) >= (1991 + 163)) and ((0 - 0) == v115)) then
				v59.HandofGuldan:RegisterInFlight();
				v68 = (565 - (83 + 468)) + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v59.HandofGuldan:RegisterInFlight();
	local function v86()
		return v10.GuardiansTable.ImpCount or (1806 - (1202 + 604));
	end
	local function v87(v116)
		local v117 = 0 - 0;
		for v130, v131 in pairs(v10.GuardiansTable.Pets) do
			if ((v131.ImpCasts <= v116) or ((2154 - 859) >= (8951 - 5718))) then
				v117 = v117 + (326 - (45 + 280));
			end
		end
		return v117;
	end
	local function v88()
		return v10.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v89()
		return v88() > (0 + 0);
	end
	local function v90()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 + 0);
	end
	local function v91()
		return v90() > (0 + 0);
	end
	local function v92()
		return v10.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v93()
		return v92() > (0 - 0);
	end
	local function v94()
		return v10.GuardiansTable.VilefiendDuration or (1911 - (340 + 1571));
	end
	local function v95()
		return v94() > (0 + 0);
	end
	local function v96()
		return v10.GuardiansTable.PitLordDuration or (1772 - (1733 + 39));
	end
	local function v97()
		return v96() > (0 - 0);
	end
	local function v98(v118)
		return v118:DebuffDown(v59.DoomBrandDebuff) or (v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) <= (1037 - (125 + 909))));
	end
	local function v99(v119)
		return (v119:DebuffDown(v59.DoomBrandDebuff)) or (v83 < (1952 - (1096 + 852)));
	end
	local function v100(v120)
		return (v120:DebuffRefreshable(v59.Doom));
	end
	local function v101(v121)
		return v121:DebuffRemains(v59.DoomBrandDebuff) > (5 + 5);
	end
	local function v102()
		local v122 = 0 - 0;
		while true do
			if (((4246 + 131) > (2154 - (409 + 103))) and ((238 - (46 + 190)) == v122)) then
				if (((4818 - (51 + 44)) > (383 + 973)) and v59.PowerSiphon:IsReady()) then
					if (v23(v59.PowerSiphon, v54) or ((5453 - (1114 + 203)) <= (4159 - (228 + 498)))) then
						return "power_siphon precombat 2";
					end
				end
				if (((920 + 3325) <= (2559 + 2072)) and v59.Demonbolt:IsReady() and v13:BuffDown(v59.DemonicCoreBuff)) then
					if (((4939 - (174 + 489)) >= (10197 - 6283)) and v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt))) then
						return "demonbolt precombat 4";
					end
				end
				v122 = 1908 - (830 + 1075);
			end
			if (((722 - (303 + 221)) <= (5634 - (231 + 1038))) and (v122 == (3 + 0))) then
				if (((5944 - (171 + 991)) > (19270 - 14594)) and v59.ShadowBolt:IsReady()) then
					if (((13060 - 8196) > (5482 - 3285)) and v23(v61.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if ((v122 == (0 + 0)) or ((12969 - 9269) == (7231 - 4724))) then
				v77 = 18 - 6;
				v68 = (43 - 29) + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
				v122 = 1249 - (111 + 1137);
			end
			if (((4632 - (91 + 67)) >= (815 - 541)) and (v122 == (1 + 0))) then
				v73 = 523 - (423 + 100);
				v74 = 0 + 0;
				v122 = 5 - 3;
			end
		end
	end
	local function v103()
		if ((((v13:BuffUp(v59.NetherPortalBuff) and (v13:BuffRemains(v59.NetherPortalBuff) < (2 + 1)) and v59.NetherPortal:IsAvailable()) or (v67 < (791 - (326 + 445))) or (v91() and (v67 < (436 - 336))) or (v67 < (55 - 30)) or v91() or (not v59.SummonDemonicTyrant:IsAvailable() and v93())) and (v75 <= (0 - 0))) or ((2605 - (530 + 181)) <= (2287 - (614 + 267)))) then
			v74 = (152 - (19 + 13)) + v79;
		end
		v75 = v74 - v79;
		if (((2558 - 986) >= (3567 - 2036)) and (((((v67 + v79) % (342 - 222)) <= (23 + 62)) and (((v67 + v79) % (211 - 91)) >= (51 - 26))) or (v79 >= (2022 - (1293 + 519)))) and (v75 > (0 - 0)) and not v59.GrandWarlocksDesign:IsAvailable()) then
			v76 = v75;
		else
			v76 = v59.SummonDemonicTyrant:CooldownRemains();
		end
		if ((v95() and v93()) or ((12237 - 7550) < (8685 - 4143))) then
			v69 = v28(v94(), v92()) - (v13:GCD() * (0.5 - 0));
		end
		if (((7752 - 4461) > (883 + 784)) and not v59.SummonVilefiend:IsAvailable() and v59.GrimoireFelguard:IsAvailable() and v93()) then
			v69 = v28(v92(), v88()) - (v13:GCD() * (0.5 + 0));
		end
		if ((not v59.SummonVilefiend:IsAvailable() and (not v59.GrimoireFelguard:IsAvailable() or not v13:HasTier(69 - 39, 1 + 1)) and v93()) or ((291 + 582) == (1272 + 762))) then
			v69 = v92() - (v13:GCD() * (1096.5 - (709 + 387)));
		end
		if ((not v95() and v59.SummonVilefiend:IsAvailable()) or not v93() or ((4674 - (673 + 1185)) < (31 - 20))) then
			v69 = 0 - 0;
		end
		v70 = not v59.NetherPortal:IsAvailable() or (v59.NetherPortal:CooldownRemains() > (49 - 19)) or v13:BuffUp(v59.NetherPortalBuff);
		local v123 = v26(v59.SacrificedSouls:IsAvailable());
		if (((2646 + 1053) < (3517 + 1189)) and (v83 > ((1 - 0) + v123))) then
			v71 = not v91();
		end
		if (((650 + 1996) >= (1746 - 870)) and (v83 > ((3 - 1) + v123)) and (v83 < ((1885 - (446 + 1434)) + v123))) then
			v71 = v90() < (1289 - (1040 + 243));
		end
		if (((1832 - 1218) <= (5031 - (559 + 1288))) and (v83 > ((1935 - (609 + 1322)) + v123))) then
			v71 = v90() < (462 - (13 + 441));
		end
		v72 = (v59.SummonDemonicTyrant:CooldownRemains() < (74 - 54)) and (v76 < (52 - 32)) and ((v13:BuffStack(v59.DemonicCoreBuff) <= (9 - 7)) or v13:BuffDown(v59.DemonicCoreBuff)) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (1 + 4))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (18 - 13)));
	end
	local function v104()
		local v124 = 0 + 0;
		local v125;
		while true do
			if (((1370 + 1756) == (9276 - 6150)) and (v124 == (0 + 0))) then
				v125 = v84.HandleTopTrinket(v62, v31, 73 - 33, nil);
				if (v125 or ((1446 + 741) >= (2756 + 2198))) then
					return v125;
				end
				v124 = 1 + 0;
			end
			if ((v124 == (1 + 0)) or ((3794 + 83) == (4008 - (153 + 280)))) then
				v125 = v84.HandleBottomTrinket(v62, v31, 115 - 75, nil);
				if (((635 + 72) > (250 + 382)) and v125) then
					return v125;
				end
				break;
			end
		end
	end
	local function v105()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (0 + 0)) or ((396 + 150) >= (4086 - 1402))) then
				if (((906 + 559) <= (4968 - (89 + 578))) and v60.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v59.DemonicPowerBuff) or (not v59.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v59.NetherPortalBuff) or not v59.NetherPortal:IsAvailable())))) then
					if (((1218 + 486) > (2962 - 1537)) and v24(v61.TimebreachingTalon)) then
						return "timebreaching_talon items 2";
					end
				end
				if (not v59.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v59.DemonicPowerBuff) or ((1736 - (572 + 477)) == (572 + 3662))) then
					local v150 = v104();
					if (v150 or ((1999 + 1331) < (171 + 1258))) then
						return v150;
					end
				end
				break;
			end
		end
	end
	local function v106()
		if (((1233 - (84 + 2)) >= (552 - 217)) and v59.Berserking:IsCastable()) then
			if (((2475 + 960) > (2939 - (497 + 345))) and v24(v59.Berserking, v32)) then
				return "berserking ogcd 4";
			end
		end
		if (v59.BloodFury:IsCastable() or ((97 + 3673) >= (684 + 3357))) then
			if (v24(v59.BloodFury, v32) or ((5124 - (605 + 728)) <= (1150 + 461))) then
				return "blood_fury ogcd 6";
			end
		end
		if (v59.Fireblood:IsCastable() or ((10178 - 5600) <= (93 + 1915))) then
			if (((4159 - 3034) <= (1872 + 204)) and v24(v59.Fireblood, v32)) then
				return "fireblood ogcd 8";
			end
		end
		if (v59.AncestralCall:IsCastable() or ((2058 - 1315) >= (3322 + 1077))) then
			if (((1644 - (457 + 32)) < (710 + 963)) and v23(v59.AncestralCall, v32)) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v107()
		if (((v69 > (1402 - (832 + 570))) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80)) and (v74 <= (0 + 0))) or ((607 + 1717) <= (2045 - 1467))) then
			v74 = 58 + 62 + v79;
		end
		if (((4563 - (588 + 208)) == (10152 - 6385)) and v59.HandofGuldan:IsReady() and (v78 > (1800 - (884 + 916))) and (v69 > (v80 + v59.SummonDemonicTyrant:CastTime())) and (v69 < (v80 * (8 - 4)))) then
			if (((2371 + 1718) == (4742 - (232 + 421))) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((6347 - (1569 + 320)) >= (411 + 1263)) and (v69 > (0 + 0)) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80))) then
			local v133 = v105();
			if (((3275 - 2303) <= (2023 - (316 + 289))) and v133) then
				return v133;
			end
			local v133 = v106();
			if (v133 or ((12926 - 7988) < (220 + 4542))) then
				return v133;
			end
			local v134 = v84.HandleDPSPotion();
			if (v134 or ((3957 - (666 + 787)) > (4689 - (360 + 65)))) then
				return v134;
			end
		end
		if (((2013 + 140) == (2407 - (79 + 175))) and v59.SummonDemonicTyrant:IsCastable() and (v69 > (0 - 0)) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80))) then
			if (v24(v59.SummonDemonicTyrant, nil, nil, v55) or ((396 + 111) >= (7941 - 5350))) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if (((8629 - 4148) == (5380 - (503 + 396))) and v59.Implosion:IsReady() and (v86() > (183 - (92 + 89))) and not v93() and not v89() and not v95() and ((v83 > (5 - 2)) or ((v83 > (2 + 0)) and v59.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(1 + 0, v59.Implosion)) then
			if (v23(v59.Implosion, v52, nil, not v14:IsInRange(156 - 116)) or ((319 + 2009) < (1579 - 886))) then
				return "implosion tyrant 8";
			end
		end
		if (((3777 + 551) == (2068 + 2260)) and v59.ShadowBolt:IsReady() and v13:PrevGCDP(2 - 1, v59.GrimoireFelguard) and (v79 > (4 + 26)) and v13:BuffDown(v59.NetherPortalBuff) and v13:BuffDown(v59.DemonicCoreBuff)) then
			if (((2421 - 833) >= (2576 - (485 + 759))) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if ((v59.PowerSiphon:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) < (8 - 4)) and (not v95() or (not v59.SummonVilefiend:IsAvailable() and v92())) and v13:BuffDown(v59.NetherPortalBuff)) or ((5363 - (442 + 747)) > (5383 - (832 + 303)))) then
			if (v23(v59.PowerSiphon, v54) or ((5532 - (88 + 858)) <= (25 + 57))) then
				return "power_siphon tyrant 12";
			end
		end
		if (((3198 + 665) == (160 + 3703)) and v59.ShadowBolt:IsReady() and not v95() and v13:BuffDown(v59.NetherPortalBuff) and not v93() and (v78 < ((794 - (766 + 23)) - v13:BuffStack(v59.DemonicCoreBuff)))) then
			if (v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt)) or ((1392 - 1110) <= (56 - 14))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if (((12143 - 7534) >= (2599 - 1833)) and v59.NetherPortal:IsReady() and (v78 == (1078 - (1036 + 37)))) then
			if (v23(v59.NetherPortal, v53) or ((817 + 335) == (4844 - 2356))) then
				return "nether_portal tyrant 16";
			end
		end
		if (((2692 + 730) > (4830 - (641 + 839))) and v59.SummonVilefiend:IsReady() and ((v78 == (918 - (910 + 3))) or v13:BuffUp(v59.NetherPortalBuff)) and (v59.SummonDemonicTyrant:CooldownRemains() < (32 - 19)) and v70) then
			if (((2561 - (1466 + 218)) > (173 + 203)) and v23(v59.SummonVilefiend)) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if ((v59.CallDreadstalkers:IsReady() and (v95() or (not v59.SummonVilefiend:IsAvailable() and (not v59.NetherPortal:IsAvailable() or v13:BuffUp(v59.NetherPortalBuff) or (v59.NetherPortal:CooldownRemains() > (1178 - (556 + 592)))) and (v13:BuffUp(v59.NetherPortalBuff) or v89() or (v78 == (2 + 3))))) and (v59.SummonDemonicTyrant:CooldownRemains() < (819 - (329 + 479))) and v70) or ((3972 - (174 + 680)) <= (6360 - 4509))) then
			if (v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers)) or ((341 - 176) >= (2494 + 998))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if (((4688 - (396 + 343)) < (430 + 4426)) and v59.GrimoireFelguard:IsReady() and (v95() or (not v59.SummonVilefiend:IsAvailable() and (not v59.NetherPortal:IsAvailable() or v13:BuffUp(v59.NetherPortalBuff) or (v59.NetherPortal:CooldownRemains() > (1507 - (29 + 1448)))) and (v13:BuffUp(v59.NetherPortalBuff) or v93() or (v78 == (1394 - (135 + 1254)))) and v70))) then
			if (v23(v59.GrimoireFelguard, v51) or ((16108 - 11832) < (14082 - 11066))) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if (((3126 + 1564) > (5652 - (389 + 1138))) and v59.HandofGuldan:IsReady() and (((v78 > (576 - (102 + 472))) and (v95() or (not v59.SummonVilefiend:IsAvailable() and v93())) and ((v78 > (2 + 0)) or (v94() < ((v80 * (2 + 0)) + ((2 + 0) / v13:SpellHaste()))))) or (not v93() and (v78 == (1550 - (320 + 1225)))))) then
			if (v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan)) or ((89 - 39) >= (549 + 347))) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if ((v59.Demonbolt:IsReady() and (v78 < (1468 - (157 + 1307))) and (v13:BuffStack(v59.DemonicCoreBuff) > (1860 - (821 + 1038))) and (v95() or (not v59.SummonVilefiend:IsAvailable() and v93()))) or ((4276 - 2562) >= (324 + 2634))) then
			if (v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt)) or ((2648 - 1157) < (240 + 404))) then
				return "demonbolt tyrant 26";
			end
		end
		if (((1744 - 1040) < (2013 - (834 + 192))) and v59.PowerSiphon:IsReady() and (((v13:BuffStack(v59.DemonicCoreBuff) < (1 + 2)) and (v69 > (v59.SummonDemonicTyrant:ExecuteTime() + (v80 * (1 + 2))))) or (v69 == (0 + 0)))) then
			if (((5759 - 2041) > (2210 - (300 + 4))) and v23(v59.PowerSiphon, v54)) then
				return "power_siphon tyrant 28";
			end
		end
		if (v59.ShadowBolt:IsCastable() or ((256 + 702) > (9515 - 5880))) then
			if (((3863 - (112 + 250)) <= (1791 + 2701)) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v108()
		if ((v59.SummonDemonicTyrant:IsCastable() and (v67 < (50 - 30))) or ((1972 + 1470) < (1318 + 1230))) then
			if (((2151 + 724) >= (726 + 738)) and v24(v59.SummonDemonicTyrant, nil, nil, v55)) then
				return "summon_demonic_tyrant fight_end 10";
			end
		end
		if ((v67 < (15 + 5)) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
			if (v59.GrimoireFelguard:IsReady() or ((1433 - (244 + 638)) > (2761 - (627 + 66)))) then
				if (((6298 - 4184) > (1546 - (512 + 90))) and v23(v59.GrimoireFelguard, v51)) then
					return "grimoire_felguard fight_end 2";
				end
			end
			if (v59.CallDreadstalkers:IsReady() or ((4168 - (1665 + 241)) >= (3813 - (373 + 344)))) then
				if (v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers)) or ((1018 + 1237) >= (936 + 2601))) then
					return "call_dreadstalkers fight_end 4";
				end
			end
			if (v59.SummonVilefiend:IsReady() or ((10120 - 6283) < (2209 - 903))) then
				if (((4049 - (35 + 1064)) == (2147 + 803)) and v23(v59.SummonVilefiend)) then
					return "summon_vilefiend fight_end 6";
				end
			end
		end
		if ((v59.NetherPortal:IsReady() and (v67 < (64 - 34))) or ((19 + 4704) < (4534 - (298 + 938)))) then
			if (((2395 - (233 + 1026)) >= (1820 - (636 + 1030))) and v23(v59.NetherPortal, v53)) then
				return "nether_portal fight_end 8";
			end
		end
		if ((v59.DemonicStrength:IsCastable() and (v67 < (6 + 4))) or ((265 + 6) > (1411 + 3337))) then
			if (((321 + 4419) >= (3373 - (55 + 166))) and v23(v59.DemonicStrength, v50)) then
				return "demonic_strength fight_end 12";
			end
		end
		if ((v59.PowerSiphon:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) < (1 + 2)) and (v67 < (3 + 17))) or ((9845 - 7267) >= (3687 - (36 + 261)))) then
			if (((71 - 30) <= (3029 - (34 + 1334))) and v23(v59.PowerSiphon, v54)) then
				return "power_siphon fight_end 14";
			end
		end
		if (((232 + 369) < (2767 + 793)) and v59.Implosion:IsReady() and (v67 < ((1285 - (1035 + 248)) * v80))) then
			if (((256 - (20 + 1)) < (358 + 329)) and v23(v59.Implosion, v52, nil, not v14:IsInRange(359 - (134 + 185)))) then
				return "implosion fight_end 16";
			end
		end
	end
	local v109 = 1133 - (549 + 584);
	local v110 = false;
	function UpdateLastMoveTime()
		if (((5234 - (314 + 371)) > (3958 - 2805)) and v13:IsMoving()) then
			if (not v110 or ((5642 - (478 + 490)) < (2475 + 2197))) then
				v109 = GetTime();
				v110 = true;
			end
		else
			v110 = false;
		end
	end
	local function v111()
		v58();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (((4840 - (786 + 386)) < (14772 - 10211)) and v30) then
			v82 = v14:GetEnemiesInSplashRange(1387 - (1055 + 324));
			v83 = v14:GetEnemiesInSplashRangeCount(1348 - (1093 + 247));
			v81 = v13:GetEnemiesInRange(36 + 4);
		else
			local v135 = 0 + 0;
			while true do
				if ((v135 == (3 - 2)) or ((1543 - 1088) == (10258 - 6653))) then
					v81 = {};
					break;
				end
				if ((v135 == (0 - 0)) or ((948 + 1715) == (12759 - 9447))) then
					v82 = {};
					v83 = 3 - 2;
					v135 = 1 + 0;
				end
			end
		end
		UpdateLastMoveTime();
		if (((10937 - 6660) <= (5163 - (364 + 324))) and (v84.TargetIsValid() or v13:AffectingCombat())) then
			local v136 = 0 - 0;
			while true do
				if ((v136 == (4 - 2)) or ((289 + 581) == (4975 - 3786))) then
					v25.UpdateSoulShards();
					v79 = v10.CombatTime();
					v136 = 4 - 1;
				end
				if (((4716 - 3163) <= (4401 - (1249 + 19))) and (v136 == (3 + 0))) then
					v78 = v13:SoulShardsP();
					v80 = v13:GCD() + (0.25 - 0);
					break;
				end
				if ((v136 == (1086 - (686 + 400))) or ((1756 + 481) >= (3740 - (73 + 156)))) then
					v66 = v10.BossFightRemains();
					v67 = v66;
					v136 = 1 + 0;
				end
				if ((v136 == (812 - (721 + 90))) or ((15 + 1309) > (9805 - 6785))) then
					if ((v67 == (11581 - (224 + 246))) or ((4846 - 1854) == (3463 - 1582))) then
						v67 = v10.FightRemains(v82, false);
					end
					v25.UpdatePetTable();
					v136 = 1 + 1;
				end
			end
		end
		if (((74 + 3032) > (1121 + 405)) and v59.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v46 and not v17:IsActive()) then
			if (((6010 - 2987) < (12878 - 9008)) and v24(v59.SummonPet, false, true)) then
				return "summon_pet ooc";
			end
		end
		if (((656 - (203 + 310)) > (2067 - (1238 + 755))) and v60.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) then
			if (((2 + 16) < (3646 - (709 + 825))) and v24(v61.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((2021 - 924) <= (2371 - 743)) and v34 and (v13:HealthPercentage() <= v36)) then
			local v137 = 864 - (196 + 668);
			while true do
				if (((18280 - 13650) == (9590 - 4960)) and (v137 == (833 - (171 + 662)))) then
					if (((3633 - (4 + 89)) > (9403 - 6720)) and (v35 == "Refreshing Healing Potion")) then
						if (((1746 + 3048) >= (14384 - 11109)) and v60.RefreshingHealingPotion:IsReady()) then
							if (((582 + 902) == (2970 - (35 + 1451))) and v24(v61.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2885 - (28 + 1425)) < (5548 - (941 + 1052))) and (v35 == "Dreamwalker's Healing Potion")) then
						if (v60.DreamwalkersHealingPotion:IsReady() or ((1022 + 43) > (5092 - (822 + 692)))) then
							if (v24(v61.RefreshingHealingPotion) or ((6845 - 2050) < (663 + 744))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((2150 - (45 + 252)) < (4763 + 50)) and v84.TargetIsValid()) then
			local v138 = 0 + 0;
			local v139;
			while true do
				if ((v138 == (7 - 4)) or ((3254 - (114 + 319)) < (3490 - 1059))) then
					if ((v59.BilescourgeBombers:IsReady() and v59.BilescourgeBombers:IsCastable()) or ((3681 - 807) < (1391 + 790))) then
						if (v23(v59.BilescourgeBombers, nil, nil, not v14:IsInRange(59 - 19)) or ((5633 - 2944) <= (2306 - (556 + 1407)))) then
							return "bilescourge_bombers main 14";
						end
					end
					if ((v59.Guillotine:IsCastable() and v49 and (v13:BuffRemains(v59.NetherPortalBuff) < v80) and (v59.DemonicStrength:CooldownDown() or not v59.DemonicStrength:IsAvailable())) or ((3075 - (741 + 465)) == (2474 - (170 + 295)))) then
						if (v23(v61.GuillotineCursor, nil, nil, not v14:IsInRange(22 + 18)) or ((3258 + 288) < (5716 - 3394))) then
							return "guillotine main 16";
						end
					end
					if ((v59.CallDreadstalkers:IsReady() and ((v59.SummonDemonicTyrant:CooldownRemains() > (21 + 4)) or (v76 > (17 + 8)) or v13:BuffUp(v59.NetherPortalBuff))) or ((1179 + 903) == (6003 - (957 + 273)))) then
						if (((868 + 2376) > (423 + 632)) and v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers))) then
							return "call_dreadstalkers main 18";
						end
					end
					if ((v59.Implosion:IsReady() and (v87(7 - 5) > (0 - 0)) and v71 and not v13:PrevGCDP(2 - 1, v59.Implosion)) or ((16404 - 13091) <= (3558 - (389 + 1391)))) then
						if (v23(v59.Implosion, v52, nil, not v14:IsInRange(26 + 14)) or ((148 + 1273) >= (4789 - 2685))) then
							return "implosion main 20";
						end
					end
					if (((2763 - (783 + 168)) <= (10904 - 7655)) and v59.SummonSoulkeeper:IsReady() and (v59.SummonSoulkeeper:Count() == (10 + 0)) and (v83 > (312 - (309 + 2)))) then
						if (((4984 - 3361) <= (3169 - (1090 + 122))) and v23(v59.SummonSoulkeeper)) then
							return "soul_strike main 22";
						end
					end
					if (((1431 + 2981) == (14817 - 10405)) and v59.HandofGuldan:IsReady() and (((v78 > (2 + 0)) and (v59.CallDreadstalkers:CooldownRemains() > (v80 * (1122 - (628 + 490)))) and (v59.SummonDemonicTyrant:CooldownRemains() > (4 + 13))) or (v78 == (12 - 7)) or ((v78 == (18 - 14)) and v59.SoulStrike:IsAvailable() and (v59.SoulStrike:CooldownRemains() < (v80 * (776 - (431 + 343)))))) and (v83 == (1 - 0)) and v59.GrandWarlocksDesign:IsAvailable()) then
						if (((5062 - 3312) >= (666 + 176)) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
							return "hand_of_guldan main 26";
						end
					end
					v138 = 1 + 3;
				end
				if (((6067 - (556 + 1139)) > (1865 - (6 + 9))) and (v138 == (1 + 0))) then
					if (((119 + 113) < (990 - (28 + 141))) and (v91() or (v67 < (9 + 13)))) then
						local v151 = 0 - 0;
						local v152;
						while true do
							if (((367 + 151) < (2219 - (486 + 831))) and (v151 == (0 - 0))) then
								v152 = v106();
								if (((10540 - 7546) > (163 + 695)) and v152 and v32 and v31) then
									return v152;
								end
								break;
							end
						end
					end
					v139 = v105();
					if (v139 or ((11873 - 8118) <= (2178 - (668 + 595)))) then
						return v139;
					end
					if (((3551 + 395) > (755 + 2988)) and (v67 < (81 - 51))) then
						local v153 = 290 - (23 + 267);
						local v154;
						while true do
							if ((v153 == (1944 - (1129 + 815))) or ((1722 - (371 + 16)) >= (5056 - (1326 + 424)))) then
								v154 = v108();
								if (((9174 - 4330) > (8232 - 5979)) and v154) then
									return v154;
								end
								break;
							end
						end
					end
					if (((570 - (88 + 30)) == (1223 - (720 + 51))) and v59.HandofGuldan:IsReady() and (v79 < (0.5 - 0)) and (((v67 % (1871 - (421 + 1355))) > (65 - 25)) or ((v67 % (47 + 48)) < (1098 - (286 + 797)))) and (v59.ReignofTyranny:IsAvailable() or (v83 > (7 - 5)))) then
						if (v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan)) or ((7548 - 2991) < (2526 - (397 + 42)))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((1210 + 2664) == (4674 - (24 + 776))) and (((v59.SummonDemonicTyrant:CooldownRemains() < (23 - 8)) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (790 - (222 + 563)))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (11 - 6))) and ((v59.GrimoireFelguard:CooldownRemains() < (8 + 2)) or not v13:HasTier(220 - (23 + 167), 1800 - (690 + 1108))) and ((v76 < (6 + 9)) or (v67 < (33 + 7)) or v13:PowerInfusionUp())) or (v59.SummonVilefiend:IsAvailable() and (v59.SummonDemonicTyrant:CooldownRemains() < (863 - (40 + 808))) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (1 + 4))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (19 - 14))) and ((v59.GrimoireFelguard:CooldownRemains() < (10 + 0)) or not v13:HasTier(16 + 14, 2 + 0)) and ((v76 < (586 - (47 + 524))) or (v67 < (26 + 14)) or v13:PowerInfusionUp())))) then
						local v155 = 0 - 0;
						local v156;
						while true do
							if ((v155 == (0 - 0)) or ((4419 - 2481) > (6661 - (1165 + 561)))) then
								v156 = v107();
								if (v156 or ((127 + 4128) < (10601 - 7178))) then
									return v156;
								end
								break;
							end
						end
					end
					v138 = 1 + 1;
				end
				if (((1933 - (341 + 138)) <= (673 + 1818)) and (v138 == (3 - 1))) then
					if (((v59.SummonDemonicTyrant:CooldownRemains() < (341 - (89 + 237))) and (v95() or (not v59.SummonVilefiend:IsAvailable() and (v89() or v59.GrimoireFelguard:CooldownUp() or not v13:HasTier(96 - 66, 3 - 1)))) and ((v76 < (896 - (581 + 300))) or v89() or (v67 < (1260 - (855 + 365))) or v13:PowerInfusionUp())) or ((9873 - 5716) <= (916 + 1887))) then
						local v157 = v107();
						if (((6088 - (1030 + 205)) >= (2800 + 182)) and v157) then
							return v157;
						end
					end
					if (((3846 + 288) > (3643 - (156 + 130))) and v59.SummonDemonicTyrant:IsCastable() and (v95() or v89() or (v59.GrimoireFelguard:CooldownRemains() > (204 - 114)))) then
						if (v23(v59.SummonDemonicTyrant, v55, nil, nil) or ((5758 - 2341) < (5189 - 2655))) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if ((v59.SummonVilefiend:IsReady() and (v59.SummonDemonicTyrant:CooldownRemains() > (12 + 33))) or ((1588 + 1134) <= (233 - (10 + 59)))) then
						if (v23(v59.SummonVilefiend) or ((682 + 1726) < (10386 - 8277))) then
							return "summon_vilefiend main 6";
						end
					end
					if ((v59.Demonbolt:IsReady() and v13:BuffUp(v59.DemonicCoreBuff) and (((not v59.SoulStrike:IsAvailable() or (v59.SoulStrike:CooldownRemains() > (v80 * (1165 - (671 + 492))))) and (v78 < (4 + 0))) or (v78 < ((1219 - (369 + 846)) - (v26(v83 > (1 + 1)))))) and not v13:PrevGCDP(1 + 0, v59.Demonbolt) and v13:HasTier(1976 - (1036 + 909), 2 + 0)) or ((55 - 22) == (1658 - (11 + 192)))) then
						if (v84.CastCycle(v59.Demonbolt, v82, v98, not v14:IsSpellInRange(v59.Demonbolt)) or ((224 + 219) >= (4190 - (135 + 40)))) then
							return "demonbolt main 8";
						end
					end
					if (((8193 - 4811) > (101 + 65)) and v59.PowerSiphon:IsReady() and v13:BuffDown(v59.DemonicCoreBuff) and (v14:DebuffDown(v59.DoomBrandDebuff) or (not v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) < (v80 + v59.Demonbolt:TravelTime()))) or (v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) < (v80 + v59.Demonbolt:TravelTime() + (6 - 3))))) and v13:HasTier(46 - 15, 178 - (50 + 126))) then
						if (v23(v59.PowerSiphon, v54) or ((779 - 499) == (678 + 2381))) then
							return "power_siphon main 10";
						end
					end
					if (((3294 - (1233 + 180)) > (2262 - (522 + 447))) and v59.DemonicStrength:IsCastable() and (v13:BuffRemains(v59.NetherPortalBuff) < v80)) then
						if (((3778 - (107 + 1314)) == (1094 + 1263)) and v23(v59.DemonicStrength, v50)) then
							return "demonic_strength main 12";
						end
					end
					v138 = 8 - 5;
				end
				if (((53 + 70) == (244 - 121)) and (v138 == (19 - 14))) then
					if ((v59.SummonVilefiend:IsReady() and (v67 < (v59.SummonDemonicTyrant:CooldownRemains() + (1915 - (716 + 1194))))) or ((19 + 1037) >= (364 + 3028))) then
						if (v23(v59.SummonVilefiend) or ((1584 - (74 + 429)) < (2073 - 998))) then
							return "summon_vilefiend main 40";
						end
					end
					if (v59.Doom:IsReady() or ((520 + 529) >= (10144 - 5712))) then
						if (v84.CastCycle(v59.Doom, v81, v100, not v14:IsSpellInRange(v59.Doom)) or ((3374 + 1394) <= (2607 - 1761))) then
							return "doom main 42";
						end
					end
					if (v59.ShadowBolt:IsCastable() or ((8302 - 4944) <= (1853 - (279 + 154)))) then
						if (v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt)) or ((4517 - (454 + 324)) <= (2365 + 640))) then
							return "shadow_bolt main 44";
						end
					end
					break;
				end
				if ((v138 == (17 - (12 + 5))) or ((895 + 764) >= (5437 - 3303))) then
					if ((not v13:AffectingCombat() and v29 and not v13:IsCasting(v59.Demonbolt)) or ((1205 + 2055) < (3448 - (277 + 816)))) then
						local v158 = 0 - 0;
						local v159;
						while true do
							if (((1183 - (1058 + 125)) == v158) or ((126 + 543) == (5198 - (815 + 160)))) then
								v159 = v102();
								if (v159 or ((7259 - 5567) < (1395 - 807))) then
									return v159;
								end
								break;
							end
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1145 + 3652) < (10672 - 7021))) then
						local v160 = 1898 - (41 + 1857);
						local v161;
						while true do
							if ((v160 == (1893 - (1222 + 671))) or ((10795 - 6618) > (6971 - 2121))) then
								v161 = v84.Interrupt(v59.SpellLock, 1222 - (229 + 953), true);
								if (v161 or ((2174 - (1111 + 663)) > (2690 - (874 + 705)))) then
									return v161;
								end
								v161 = v84.Interrupt(v59.SpellLock, 6 + 34, true, v16, v61.SpellLockMouseover);
								if (((2082 + 969) > (2089 - 1084)) and v161) then
									return v161;
								end
								v160 = 1 + 0;
							end
							if (((4372 - (642 + 37)) <= (1000 + 3382)) and (v160 == (1 + 1))) then
								v161 = v84.InterruptWithStun(v59.AxeToss, 100 - 60, true);
								if (v161 or ((3736 - (233 + 221)) > (9480 - 5380))) then
									return v161;
								end
								v161 = v84.InterruptWithStun(v59.AxeToss, 36 + 4, true, v16, v61.AxeTossMouseover);
								if (v161 or ((5121 - (718 + 823)) < (1790 + 1054))) then
									return v161;
								end
								break;
							end
							if (((894 - (266 + 539)) < (12712 - 8222)) and (v160 == (1226 - (636 + 589)))) then
								v161 = v84.Interrupt(v59.AxeToss, 94 - 54, true);
								if (v161 or ((10277 - 5294) < (1433 + 375))) then
									return v161;
								end
								v161 = v84.Interrupt(v59.AxeToss, 15 + 25, true, v16, v61.AxeTossMouseover);
								if (((4844 - (657 + 358)) > (9979 - 6210)) and v161) then
									return v161;
								end
								v160 = 4 - 2;
							end
						end
					end
					if (((2672 - (1151 + 36)) <= (2805 + 99)) and v13:AffectingCombat() and v56) then
						if (((1123 + 3146) == (12748 - 8479)) and v59.BurningRush:IsCastable() and not v13:BuffUp(v59.BurningRush) and v110 and ((GetTime() - v109) >= (1833 - (1552 + 280))) and (v13:HealthPercentage() >= v57)) then
							if (((1221 - (64 + 770)) <= (1889 + 893)) and v24(v59.BurningRush)) then
								return "burning_rush defensive 2";
							end
						elseif ((v59.BurningRush:IsCastable() and v13:BuffUp(v59.BurningRush) and (not v110 or (v13:HealthPercentage() <= v57))) or ((4310 - 2411) <= (163 + 754))) then
							if (v24(v61.CancelBurningRush) or ((5555 - (157 + 1086)) <= (1753 - 877))) then
								return "burning_rush defensive 4";
							end
						end
					end
					if (((9775 - 7543) <= (3981 - 1385)) and v13:AffectingCombat()) then
						if (((2858 - 763) < (4505 - (599 + 220))) and (v13:HealthPercentage() <= v47) and v59.DarkPact:IsCastable() and not v13:BuffUp(v59.DarkPact)) then
							if (v24(v59.DarkPact) or ((3175 - 1580) >= (6405 - (1813 + 118)))) then
								return "dark_pact defensive 2";
							end
						end
						if (((v13:HealthPercentage() <= v43) and v59.DrainLife:IsCastable()) or ((3377 + 1242) < (4099 - (841 + 376)))) then
							if (v24(v59.DrainLife) or ((411 - 117) >= (1123 + 3708))) then
								return "drain_life defensive 2";
							end
						end
						if (((5538 - 3509) <= (3943 - (464 + 395))) and (v13:HealthPercentage() <= v44) and v59.HealthFunnel:IsCastable()) then
							if (v24(v59.HealthFunnel) or ((5227 - 3190) == (1163 + 1257))) then
								return "health_funnel defensive 2";
							end
						end
						if (((5295 - (467 + 370)) > (8067 - 4163)) and (v13:HealthPercentage() <= v45) and v59.UnendingResolve:IsCastable()) then
							if (((321 + 115) >= (421 - 298)) and v24(v59.UnendingResolve)) then
								return "unending_resolve defensive 2";
							end
						end
					end
					if (((79 + 421) < (4224 - 2408)) and v59.UnendingResolve:IsReady() and (v13:HealthPercentage() < v45)) then
						if (((4094 - (150 + 370)) == (4856 - (74 + 1208))) and v24(v59.UnendingResolve, nil, nil, true)) then
							return "unending_resolve defensive";
						end
					end
					v103();
					v138 = 2 - 1;
				end
				if (((1048 - 827) < (278 + 112)) and (v138 == (394 - (14 + 376)))) then
					if ((v59.HandofGuldan:IsReady() and (v78 > (3 - 1)) and not ((v83 == (1 + 0)) and v59.GrandWarlocksDesign:IsAvailable())) or ((1945 + 268) <= (1356 + 65))) then
						if (((8960 - 5902) < (3657 + 1203)) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					if ((v59.Demonbolt:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) > (79 - (23 + 55))) and (((v78 < (9 - 5)) and not v59.SoulStrike:IsAvailable()) or (v59.SoulStrike:CooldownRemains() > (v80 * (2 + 0))) or (v78 < (2 + 0))) and not v72) or ((2009 - 713) >= (1399 + 3047))) then
						if (v84.CastCycle(v59.Demonbolt, v82, v99, not v14:IsSpellInRange(v59.Demonbolt)) or ((2294 - (652 + 249)) > (12013 - 7524))) then
							return "demonbolt main 30";
						end
					end
					if ((v59.Demonbolt:IsReady() and v13:HasTier(1899 - (708 + 1160), 5 - 3) and v13:BuffUp(v59.DemonicCoreBuff) and (v78 < (6 - 2)) and not v72) or ((4451 - (10 + 17)) < (7 + 20))) then
						if (v84.CastTargetIf(v59.Demonbolt, v82, "==", v99, v101, not v14:IsSpellInRange(v59.Demonbolt)) or ((3729 - (1400 + 332)) > (7317 - 3502))) then
							return "demonbolt main 32";
						end
					end
					if (((5373 - (242 + 1666)) > (819 + 1094)) and v59.Demonbolt:IsReady() and (v67 < (v13:BuffStack(v59.DemonicCoreBuff) * v80))) then
						if (((269 + 464) < (1551 + 268)) and v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt))) then
							return "demonbolt main 34";
						end
					end
					if ((v59.Demonbolt:IsReady() and v13:BuffUp(v59.DemonicCoreBuff) and (v59.PowerSiphon:CooldownRemains() < (944 - (850 + 90))) and (v78 < (6 - 2)) and not v72) or ((5785 - (360 + 1030)) == (4209 + 546))) then
						if (v84.CastCycle(v59.Demonbolt, v82, v99, not v14:IsSpellInRange(v59.Demonbolt)) or ((10705 - 6912) < (3258 - 889))) then
							return "demonbolt main 36";
						end
					end
					if ((v59.PowerSiphon:IsReady() and (v13:BuffDown(v59.DemonicCoreBuff))) or ((5745 - (909 + 752)) == (1488 - (109 + 1114)))) then
						if (((7978 - 3620) == (1697 + 2661)) and v23(v59.PowerSiphon, v54, nil, nil)) then
							return "power_siphon main 38";
						end
					end
					v138 = 247 - (6 + 236);
				end
			end
		end
	end
	local function v112()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(168 + 98, v111, v112);
end;
return v0["Epix_Warlock_Demonology.lua"]();

