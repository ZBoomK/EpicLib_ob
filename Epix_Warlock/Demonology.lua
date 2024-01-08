local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3691 - 1322) == (356 + 2013)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((1821 + 2274) >= (3061 + 122)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 48 - (20 + 27);
		end
		if ((v5 == (288 - (50 + 237))) or ((2118 + 1593) < (1635 - 627))) then
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
	local v50;
	local v51;
	local v52;
	local v53;
	local function v54()
		local v106 = 0 + 0;
		while true do
			if ((v106 == (4 - 3)) or ((2542 - (711 + 782)) <= (1736 - 830))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (469 - (270 + 199));
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (1819 - (580 + 1239));
				v106 = 5 - 3;
			end
			if (((4316 + 197) > (98 + 2628)) and (v106 == (0 + 0))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v106 = 1 + 0;
			end
			if ((v106 == (1171 - (645 + 522))) or ((3271 - (1010 + 780)) >= (2657 + 1))) then
				v49 = EpicSettings.Settings['GrimoireFelguard'];
				v50 = EpicSettings.Settings['Implosion'];
				v51 = EpicSettings.Settings['NetherPortal'];
				v52 = EpicSettings.Settings['PowerSiphon'];
				v106 = 23 - 18;
			end
			if ((v106 == (14 - 9)) or ((5056 - (1045 + 791)) == (3452 - 2088))) then
				v53 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 - 0);
				break;
			end
			if ((v106 == (508 - (351 + 154))) or ((2628 - (1281 + 293)) > (3658 - (28 + 238)))) then
				v45 = EpicSettings.Settings['DemonboltOpener'];
				v46 = EpicSettings.Settings["Use Guillotine"] or (0 - 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (1559 - (1381 + 178));
				v48 = EpicSettings.Settings['DemonicStrength'];
				v106 = 4 + 0;
			end
			if ((v106 == (2 + 0)) or ((289 + 387) >= (5660 - 4018))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (470 - (381 + 89));
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v106 = 3 + 0;
			end
		end
	end
	local v55 = v18.Warlock.Demonology;
	local v56 = v19.Warlock.Demonology;
	local v57 = v20.Warlock.Demonology;
	local v58 = {};
	local v59 = v13:GetEquipment();
	local v60 = (v59[22 - 9] and v19(v59[1169 - (1074 + 82)])) or v19(0 - 0);
	local v61 = (v59[1798 - (214 + 1570)] and v19(v59[1469 - (990 + 465)])) or v19(0 + 0);
	local v62 = 4835 + 6276;
	local v63 = 10805 + 306;
	local v64 = 0 - 0;
	local v65 = 1726 - (1668 + 58);
	local v66 = false;
	local v67 = false;
	local v68 = false;
	local v69 = 626 - (512 + 114);
	local v70 = 0 - 0;
	local v71 = 0 - 0;
	local v72 = 417 - 297;
	local v73 = 0 + 0;
	local v74 = 0 + 0;
	local v75 = 0 + 0;
	local v76 = 0 - 0;
	local v77;
	local v78, v79;
	v10:RegisterForEvent(function()
		v62 = 13105 - (109 + 1885);
		v63 = 12580 - (1269 + 200);
	end, "PLAYER_REGEN_ENABLED");
	local v80 = v10.Commons.Everyone;
	v10:RegisterForEvent(function()
		local v107 = 0 - 0;
		while true do
			if (((4951 - (98 + 717)) > (3223 - (802 + 24))) and (v107 == (1 - 0))) then
				v61 = (v59[16 - 2] and v19(v59[3 + 11])) or v19(0 + 0);
				break;
			end
			if ((v107 == (0 + 0)) or ((935 + 3399) == (11809 - 7564))) then
				v59 = v13:GetEquipment();
				v60 = (v59[43 - 30] and v19(v59[5 + 8])) or v19(0 + 0);
				v107 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v55.HandofGuldan:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v55.HandofGuldan:RegisterInFlight();
	local function v81()
		return v10.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v82(v108)
		local v109 = 0 + 0;
		local v110;
		while true do
			if ((v109 == (1434 - (797 + 636))) or ((20761 - 16485) <= (4650 - (1427 + 192)))) then
				return v110;
			end
			if (((0 + 0) == v109) or ((11102 - 6320) <= (1078 + 121))) then
				v110 = 0 + 0;
				for v140, v141 in pairs(v10.GuardiansTable.Pets) do
					if ((v141.ImpCasts <= v108) or ((5190 - (192 + 134)) < (3178 - (316 + 960)))) then
						v110 = v110 + 1 + 0;
					end
				end
				v109 = 1 + 0;
			end
		end
	end
	local function v83()
		return v10.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v84()
		return v83() > (0 - 0);
	end
	local function v85()
		return v10.GuardiansTable.DemonicTyrantDuration or (551 - (83 + 468));
	end
	local function v86()
		return v85() > (1806 - (1202 + 604));
	end
	local function v87()
		return v10.GuardiansTable.DreadstalkerDuration or (0 - 0);
	end
	local function v88()
		return v87() > (0 - 0);
	end
	local function v89()
		return v10.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v90()
		return v89() > (325 - (45 + 280));
	end
	local function v91()
		return v10.GuardiansTable.PitLordDuration or (0 + 0);
	end
	local function v92()
		return v91() > (0 + 0);
	end
	local function v93(v111)
		return v111:DebuffDown(v55.DoomBrandDebuff) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) <= (2 + 1)));
	end
	local function v94(v112)
		return (v112:DebuffDown(v55.DoomBrandDebuff)) or (v79 < (3 + 1));
	end
	local function v95(v113)
		return (v113:DebuffRefreshable(v55.Doom));
	end
	local function v96(v114)
		return v114:DebuffRemains(v55.DoomBrandDebuff) > (2 + 8);
	end
	local function v97()
		local v115 = 0 - 0;
		while true do
			if (((6750 - (340 + 1571)) >= (1460 + 2240)) and ((1774 - (1733 + 39)) == v115)) then
				if (v55.PowerSiphon:IsReady() or ((2953 - 1878) > (2952 - (125 + 909)))) then
					if (((2344 - (1096 + 852)) <= (1707 + 2097)) and v24(v55.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if ((v55.Demonbolt:IsReady() and v13:BuffDown(v55.DemonicCoreBuff)) or ((5953 - 1784) == (2122 + 65))) then
					if (((1918 - (409 + 103)) == (1642 - (46 + 190))) and v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt))) then
						return "demonbolt precombat 4";
					end
				end
				v115 = 98 - (51 + 44);
			end
			if (((432 + 1099) < (5588 - (1114 + 203))) and (v115 == (729 - (228 + 498)))) then
				if (((138 + 497) == (351 + 284)) and v55.ShadowBolt:IsReady()) then
					if (((4036 - (174 + 489)) <= (9264 - 5708)) and v23(v57.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if ((v115 == (1905 - (830 + 1075))) or ((3815 - (303 + 221)) < (4549 - (231 + 1038)))) then
				v73 = 10 + 2;
				v64 = (1176 - (171 + 991)) + v26(v55.GrimoireFelguard:IsAvailable()) + v26(v55.SummonVilefiend:IsAvailable());
				v115 = 4 - 3;
			end
			if (((11777 - 7391) >= (2178 - 1305)) and (v115 == (1 + 0))) then
				v69 = 0 - 0;
				v70 = 0 - 0;
				v115 = 2 - 0;
			end
		end
	end
	local function v98()
		local v116 = 0 - 0;
		local v117;
		while true do
			if (((2169 - (111 + 1137)) <= (1260 - (91 + 67))) and (v116 == (11 - 7))) then
				v68 = (v55.SummonDemonicTyrant:CooldownRemains() < (5 + 15)) and (v72 < (543 - (423 + 100))) and ((v13:BuffStack(v55.DemonicCoreBuff) <= (1 + 1)) or v13:BuffDown(v55.DemonicCoreBuff)) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (13 - 8))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (3 + 2)));
				break;
			end
			if (((5477 - (326 + 445)) >= (4202 - 3239)) and (v116 == (4 - 2))) then
				if ((not v90() and v55.SummonVilefiend:IsAvailable()) or not v88() or ((2240 - 1280) <= (1587 - (530 + 181)))) then
					v65 = 881 - (614 + 267);
				end
				v66 = not v55.NetherPortal:IsAvailable() or (v55.NetherPortal:CooldownRemains() > (62 - (19 + 13))) or v13:BuffUp(v55.NetherPortalBuff);
				v117 = v26(v55.SacrificedSouls:IsAvailable());
				v116 = 4 - 1;
			end
			if ((v116 == (0 - 0)) or ((5901 - 3835) == (243 + 689))) then
				if (((8485 - 3660) < (10043 - 5200)) and ((v13:BuffUp(v55.NetherPortalBuff) and (v13:BuffRemains(v55.NetherPortalBuff) < (1815 - (1293 + 519))) and v55.NetherPortal:IsAvailable()) or (v63 < (40 - 20)) or (v86() and (v63 < (261 - 161))) or (v63 < (47 - 22)) or v86() or (not v55.SummonDemonicTyrant:IsAvailable() and v88())) and (v71 <= (0 - 0))) then
					v70 = (282 - 162) + v75;
				end
				v71 = v70 - v75;
				if (((((((v63 + v75) % (64 + 56)) <= (18 + 67)) and (((v63 + v75) % (278 - 158)) >= (6 + 19))) or (v75 >= (70 + 140))) and (v71 > (0 + 0)) and not v55.GrandWarlocksDesign:IsAvailable()) or ((4973 - (709 + 387)) >= (6395 - (673 + 1185)))) then
					v72 = v71;
				else
					v72 = v55.SummonDemonicTyrant:CooldownRemains();
				end
				v116 = 2 - 1;
			end
			if ((v116 == (3 - 2)) or ((7099 - 2784) < (1235 + 491))) then
				if ((v90() and v88()) or ((2749 + 930) < (843 - 218))) then
					v65 = v28(v89(), v87()) - (v13:GCD() * (0.5 + 0));
				end
				if ((not v55.SummonVilefiend:IsAvailable() and v55.GrimoireFelguard:IsAvailable() and v88()) or ((9221 - 4596) < (1240 - 608))) then
					v65 = v28(v87(), v83()) - (v13:GCD() * (1880.5 - (446 + 1434)));
				end
				if ((not v55.SummonVilefiend:IsAvailable() and (not v55.GrimoireFelguard:IsAvailable() or not v13:HasTier(1313 - (1040 + 243), 5 - 3)) and v88()) or ((1930 - (559 + 1288)) > (3711 - (609 + 1322)))) then
					v65 = v87() - (v13:GCD() * (454.5 - (13 + 441)));
				end
				v116 = 7 - 5;
			end
			if (((1430 - 884) <= (5363 - 4286)) and (v116 == (1 + 2))) then
				if ((v79 > ((3 - 2) + v117)) or ((354 + 642) > (1885 + 2416))) then
					v67 = not v86();
				end
				if (((12077 - 8007) > (376 + 311)) and (v79 > ((3 - 1) + v117)) and (v79 < (4 + 1 + v117))) then
					v67 = v85() < (4 + 2);
				end
				if ((v79 > (3 + 1 + v117)) or ((551 + 105) >= (3259 + 71))) then
					v67 = v85() < (441 - (153 + 280));
				end
				v116 = 11 - 7;
			end
		end
	end
	local function v99()
		local v118 = 0 + 0;
		local v119;
		while true do
			if ((v118 == (1 + 0)) or ((1305 + 1187) <= (305 + 30))) then
				v119 = v80.HandleBottomTrinket(v58, v31, 29 + 11, nil);
				if (((6580 - 2258) >= (1584 + 978)) and v119) then
					return v119;
				end
				break;
			end
			if ((v118 == (667 - (89 + 578))) or ((2599 + 1038) >= (7837 - 4067))) then
				v119 = v80.HandleTopTrinket(v58, v31, 1089 - (572 + 477), nil);
				if (v119 or ((321 + 2058) > (2748 + 1830))) then
					return v119;
				end
				v118 = 1 + 0;
			end
		end
	end
	local function v100()
		if ((v56.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v55.DemonicPowerBuff) or (not v55.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v55.NetherPortalBuff) or not v55.NetherPortal:IsAvailable())))) or ((569 - (84 + 2)) > (1224 - 481))) then
			if (((1768 + 686) > (1420 - (497 + 345))) and v24(v57.TimebreachingTalon)) then
				return "timebreaching_talon items 2";
			end
		end
		if (((24 + 906) < (754 + 3704)) and (not v55.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v55.DemonicPowerBuff))) then
			local v124 = v99();
			if (((1995 - (605 + 728)) <= (694 + 278)) and v124) then
				return v124;
			end
		end
	end
	local function v101()
		local v120 = 0 - 0;
		while true do
			if (((201 + 4169) == (16156 - 11786)) and (v120 == (0 + 0))) then
				if (v55.Berserking:IsCastable() or ((13193 - 8431) <= (651 + 210))) then
					if (v24(v55.Berserking) or ((1901 - (457 + 32)) == (1810 + 2454))) then
						return "berserking ogcd 4";
					end
				end
				if (v55.BloodFury:IsCastable() or ((4570 - (832 + 570)) < (2029 + 124))) then
					if (v24(v55.BloodFury) or ((1298 + 3678) < (4713 - 3381))) then
						return "blood_fury ogcd 6";
					end
				end
				v120 = 1 + 0;
			end
			if (((5424 - (588 + 208)) == (12473 - 7845)) and (v120 == (1801 - (884 + 916)))) then
				if (v55.Fireblood:IsCastable() or ((112 - 58) == (230 + 165))) then
					if (((735 - (232 + 421)) == (1971 - (1569 + 320))) and v24(v55.Fireblood)) then
						return "fireblood ogcd 8";
					end
				end
				break;
			end
		end
	end
	local function v102()
		local v121 = 0 + 0;
		while true do
			if ((v121 == (1 + 0)) or ((1957 - 1376) < (887 - (316 + 289)))) then
				if ((v55.Implosion:IsReady() and (v81() > (5 - 3)) and not v88() and not v84() and not v90() and ((v79 > (1 + 2)) or ((v79 > (1455 - (666 + 787))) and v55.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(426 - (360 + 65), v55.Implosion)) or ((4308 + 301) < (2749 - (79 + 175)))) then
					if (((1816 - 664) == (899 + 253)) and v23(v55.Implosion, v50, nil, not v14:IsInRange(122 - 82))) then
						return "implosion tyrant 8";
					end
				end
				if (((3651 - 1755) <= (4321 - (503 + 396))) and v55.ShadowBolt:IsReady() and v13:PrevGCDP(182 - (92 + 89), v55.GrimoireFelguard) and (v75 > (58 - 28)) and v13:BuffDown(v55.NetherPortalBuff) and v13:BuffDown(v55.DemonicCoreBuff)) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((508 + 482) > (959 + 661))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if ((v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (15 - 11)) and (not v90() or (not v55.SummonVilefiend:IsAvailable() and v87())) and v13:BuffDown(v55.NetherPortalBuff)) or ((120 + 757) > (10705 - 6010))) then
					if (((2348 + 343) >= (885 + 966)) and v23(v55.PowerSiphon, v52)) then
						return "power_siphon tyrant 12";
					end
				end
				if ((v55.ShadowBolt:IsReady() and not v90() and v13:BuffDown(v55.NetherPortalBuff) and not v88() and (v74 < ((15 - 10) - v13:BuffStack(v55.DemonicCoreBuff)))) or ((373 + 2612) >= (7405 - 2549))) then
					if (((5520 - (485 + 759)) >= (2765 - 1570)) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v121 = 1191 - (442 + 747);
			end
			if (((4367 - (832 + 303)) <= (5636 - (88 + 858))) and (v121 == (1 + 2))) then
				if ((v55.HandofGuldan:IsReady() and (v74 > (2 + 0)) and (v90() or (not v55.SummonVilefiend:IsAvailable() and v88())) and ((v74 > (1 + 1)) or (v89() < ((v76 * (791 - (766 + 23))) + ((9 - 7) / v13:SpellHaste()))))) or ((1224 - 328) >= (8288 - 5142))) then
					if (((10389 - 7328) >= (4031 - (1036 + 37))) and v24(v55.HandofGuldan)) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((2260 + 927) >= (1253 - 609)) and v55.Demonbolt:IsReady() and (v74 < (4 + 0)) and (v13:BuffStack(v55.DemonicCoreBuff) > (1481 - (641 + 839))) and (v90() or (not v55.SummonVilefiend:IsAvailable() and v88()))) then
					if (((1557 - (910 + 3)) <= (1794 - 1090)) and v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt))) then
						return "demonbolt tyrant 26";
					end
				end
				if (((2642 - (1466 + 218)) > (436 + 511)) and v55.PowerSiphon:IsReady() and (((v13:BuffStack(v55.DemonicCoreBuff) < (1151 - (556 + 592))) and (v65 > (v55.SummonDemonicTyrant:ExecuteTime() + (v76 * (2 + 1))))) or (v65 == (808 - (329 + 479))))) then
					if (((5346 - (174 + 680)) >= (9119 - 6465)) and v23(v55.PowerSiphon, v52)) then
						return "power_siphon tyrant 28";
					end
				end
				if (((7133 - 3691) >= (1074 + 429)) and v55.ShadowBolt:IsCastable()) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((3909 - (396 + 343)) <= (130 + 1334))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if ((v121 == (1479 - (29 + 1448))) or ((6186 - (135 + 1254)) == (16530 - 12142))) then
				if (((2572 - 2021) <= (454 + 227)) and v55.NetherPortal:IsReady() and (v74 == (1532 - (389 + 1138)))) then
					if (((3851 - (102 + 472)) > (385 + 22)) and v23(v55.NetherPortal, v51)) then
						return "nether_portal tyrant 16";
					end
				end
				if (((2604 + 2091) >= (1320 + 95)) and v55.SummonVilefiend:IsReady() and ((v74 == (1550 - (320 + 1225))) or v13:BuffUp(v55.NetherPortalBuff)) and (v55.SummonDemonicTyrant:CooldownRemains() < (22 - 9)) and v66) then
					if (v23(v55.SummonVilefiend) or ((1966 + 1246) <= (2408 - (157 + 1307)))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v55.CallDreadstalkers:IsReady() and (v90() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (1889 - (821 + 1038)))) and (v13:BuffUp(v55.NetherPortalBuff) or v84() or (v74 == (12 - 7))))) and (v55.SummonDemonicTyrant:CooldownRemains() < (2 + 9)) and v66) or ((5498 - 2402) <= (669 + 1129))) then
					if (((8766 - 5229) == (4563 - (834 + 192))) and v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if (((244 + 3593) >= (403 + 1167)) and v55.GrimoireFelguard:IsReady() and (v90() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (1 + 29))) and (v13:BuffUp(v55.NetherPortalBuff) or v88() or (v74 == (7 - 2))) and v66))) then
					if (v23(v55.GrimoireFelguard, v49) or ((3254 - (300 + 4)) == (1019 + 2793))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v121 = 7 - 4;
			end
			if (((5085 - (112 + 250)) >= (925 + 1393)) and (v121 == (0 - 0))) then
				if (((v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76)) and (v70 <= (0 + 0))) or ((1516 + 511) > (1415 + 1437))) then
					v70 = 90 + 30 + v75;
				end
				if ((v55.HandofGuldan:IsReady() and (v74 > (1414 - (1001 + 413))) and (v65 > (v76 + v55.SummonDemonicTyrant:CastTime())) and (v65 < (v76 * (8 - 4)))) or ((2018 - (244 + 638)) > (5010 - (627 + 66)))) then
					if (((14147 - 9399) == (5350 - (512 + 90))) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and (v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76))) then
					local v142 = v100();
					if (v142 or ((897 + 2493) <= (8071 - 5011))) then
						return v142;
					end
					local v142 = v101();
					if (v142 or ((1690 - 691) > (3792 - (35 + 1064)))) then
						return v142;
					end
					local v143 = v80.HandleDPSPotion();
					if (((337 + 126) < (1285 - 684)) and v143) then
						return v143;
					end
				end
				if ((v55.SummonDemonicTyrant:IsCastable() and (v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76))) or ((3419 - (298 + 938)) < (1946 - (233 + 1026)))) then
					if (((6215 - (636 + 1030)) == (2326 + 2223)) and v23(v55.SummonDemonicTyrant, v53)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v121 = 1 + 0;
			end
		end
	end
	local function v103()
		if (((1388 + 3284) == (316 + 4356)) and v55.SummonDemonicTyrant:IsCastable() and (v63 < (241 - (55 + 166)))) then
			if (v23(v55.SummonDemonicTyrant, v53) or ((711 + 2957) < (40 + 355))) then
				return "summon_demonic_tyrant fight_end 10";
			end
		end
		if ((v63 < (76 - 56)) or ((4463 - (36 + 261)) == (795 - 340))) then
			local v125 = 1368 - (34 + 1334);
			while true do
				if ((v125 == (1 + 0)) or ((3457 + 992) == (3946 - (1035 + 248)))) then
					if (v55.SummonVilefiend:IsReady() or ((4298 - (20 + 1)) < (1558 + 1431))) then
						if (v23(v55.SummonVilefiend) or ((1189 - (134 + 185)) >= (5282 - (549 + 584)))) then
							return "summon_vilefiend fight_end 6";
						end
					end
					break;
				end
				if (((2897 - (314 + 371)) < (10926 - 7743)) and (v125 == (968 - (478 + 490)))) then
					if (((2462 + 2184) > (4164 - (786 + 386))) and v55.GrimoireFelguard:IsReady()) then
						if (((4644 - 3210) < (4485 - (1055 + 324))) and v23(v55.GrimoireFelguard, v49)) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (((2126 - (1093 + 247)) < (2687 + 336)) and v55.CallDreadstalkers:IsReady()) then
						if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((257 + 2185) < (293 - 219))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					v125 = 3 - 2;
				end
			end
		end
		if (((12904 - 8369) == (11396 - 6861)) and v55.NetherPortal:IsReady() and (v63 < (11 + 19))) then
			if (v23(v55.NetherPortal, v51) or ((11591 - 8582) <= (7255 - 5150))) then
				return "nether_portal fight_end 8";
			end
		end
		if (((1380 + 450) < (9382 - 5713)) and v55.DemonicStrength:IsCastable() and (v63 < (698 - (364 + 324)))) then
			if (v23(v55.DemonicStrength, v48) or ((3920 - 2490) >= (8667 - 5055))) then
				return "demonic_strength fight_end 12";
			end
		end
		if (((890 + 1793) >= (10293 - 7833)) and v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (4 - 1)) and (v63 < (60 - 40))) then
			if (v23(v55.PowerSiphon, v52) or ((3072 - (1249 + 19)) >= (2957 + 318))) then
				return "power_siphon fight_end 14";
			end
		end
		if ((v55.Implosion:IsReady() and (v63 < ((7 - 5) * v76))) or ((2503 - (686 + 400)) > (2848 + 781))) then
			if (((5024 - (73 + 156)) > (2 + 400)) and v23(v55.Implosion, v50, nil, not v14:IsInRange(851 - (721 + 90)))) then
				return "implosion fight_end 16";
			end
		end
	end
	local function v104()
		local v122 = 0 + 0;
		while true do
			if (((15627 - 10814) > (4035 - (224 + 246))) and (v122 == (4 - 1))) then
				if (((7202 - 3290) == (710 + 3202)) and v55.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v43 and not v17:IsActive()) then
					if (((68 + 2753) <= (3544 + 1280)) and v24(v55.SummonPet, false, true)) then
						return "summon_pet ooc";
					end
				end
				if (((3455 - 1717) <= (7304 - 5109)) and v56.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) then
					if (((554 - (203 + 310)) <= (5011 - (1238 + 755))) and v24(v57.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v122 = 1 + 3;
			end
			if (((3679 - (709 + 825)) <= (7562 - 3458)) and (v122 == (1 - 0))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v122 = 866 - (196 + 668);
			end
			if (((10616 - 7927) < (10036 - 5191)) and (v122 == (833 - (171 + 662)))) then
				v54();
				v29 = EpicSettings.Toggles['ooc'];
				v122 = 94 - (4 + 89);
			end
			if (((6 - 4) == v122) or ((846 + 1476) > (11516 - 8894))) then
				if (v30 or ((1779 + 2755) == (3568 - (35 + 1451)))) then
					v78 = v14:GetEnemiesInSplashRange(1461 - (28 + 1425));
					v79 = v14:GetEnemiesInSplashRangeCount(2001 - (941 + 1052));
					v77 = v13:GetEnemiesInRange(39 + 1);
				else
					local v144 = 1514 - (822 + 692);
					while true do
						if ((v144 == (0 - 0)) or ((740 + 831) > (2164 - (45 + 252)))) then
							v78 = {};
							v79 = 1 + 0;
							v144 = 1 + 0;
						end
						if ((v144 == (2 - 1)) or ((3087 - (114 + 319)) >= (4300 - 1304))) then
							v77 = {};
							break;
						end
					end
				end
				if (((5096 - 1118) > (1342 + 762)) and (v80.TargetIsValid() or v13:AffectingCombat())) then
					v62 = v10.BossFightRemains();
					v63 = v62;
					if (((4462 - 1467) > (3228 - 1687)) and (v63 == (13074 - (556 + 1407)))) then
						v63 = v10.FightRemains(v78, false);
					end
					v25.UpdatePetTable();
					v25.UpdateSoulShards();
					v75 = v10.CombatTime();
					v74 = v13:SoulShardsP();
					v76 = v13:GCD() + (1206.25 - (741 + 465));
				end
				v122 = 468 - (170 + 295);
			end
			if (((1712 + 1537) > (876 + 77)) and (v122 == (9 - 5))) then
				if ((v34 and (v13:HealthPercentage() <= v36)) or ((2714 + 559) > (2933 + 1640))) then
					local v145 = 0 + 0;
					while true do
						if (((1230 - (957 + 273)) == v145) or ((843 + 2308) < (515 + 769))) then
							if ((v35 == "Refreshing Healing Potion") or ((7049 - 5199) == (4029 - 2500))) then
								if (((2507 - 1686) < (10512 - 8389)) and v56.RefreshingHealingPotion:IsReady()) then
									if (((2682 - (389 + 1391)) < (1459 + 866)) and v24(v57.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((90 + 768) <= (6742 - 3780)) and (v35 == "Dreamwalker's Healing Potion")) then
								if (v56.DreamwalkersHealingPotion:IsReady() or ((4897 - (783 + 168)) < (4322 - 3034))) then
									if (v24(v57.RefreshingHealingPotion) or ((3189 + 53) == (878 - (309 + 2)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (v80.TargetIsValid() or ((2600 - 1753) >= (2475 - (1090 + 122)))) then
					if ((not v13:AffectingCombat() and v29 and not v13:IsCasting(v55.Demonbolt)) or ((731 + 1522) == (6216 - 4365))) then
						local v147 = v97();
						if (v147 or ((1429 + 658) > (3490 - (628 + 490)))) then
							return v147;
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((798 + 3647) < (10272 - 6123))) then
						local v148 = 0 - 0;
						local v149;
						while true do
							if ((v148 == (774 - (431 + 343))) or ((3671 - 1853) == (245 - 160))) then
								v149 = v80.Interrupt(v55.SpellLock, 32 + 8, true);
								if (((81 + 549) < (3822 - (556 + 1139))) and v149) then
									return v149;
								end
								v149 = v80.Interrupt(v55.SpellLock, 55 - (6 + 9), true, v16, v57.SpellLockMouseover);
								v148 = 1 + 0;
							end
							if (((2 + 0) == v148) or ((2107 - (28 + 141)) == (974 + 1540))) then
								v149 = v80.Interrupt(v55.AxeToss, 49 - 9, true, v16, v57.AxeTossMouseover);
								if (((3014 + 1241) >= (1372 - (486 + 831))) and v149) then
									return v149;
								end
								v149 = v80.InterruptWithStun(v55.AxeToss, 104 - 64, true);
								v148 = 10 - 7;
							end
							if (((567 + 2432) > (3655 - 2499)) and (v148 == (1264 - (668 + 595)))) then
								if (((2115 + 235) > (233 + 922)) and v149) then
									return v149;
								end
								v149 = v80.Interrupt(v55.AxeToss, 109 - 69, true);
								if (((4319 - (23 + 267)) <= (6797 - (1129 + 815))) and v149) then
									return v149;
								end
								v148 = 389 - (371 + 16);
							end
							if (((1753 - (1326 + 424)) == v148) or ((976 - 460) > (12548 - 9114))) then
								if (((4164 - (88 + 30)) >= (3804 - (720 + 51))) and v149) then
									return v149;
								end
								v149 = v80.InterruptWithStun(v55.AxeToss, 88 - 48, true, v16, v57.AxeTossMouseover);
								if (v149 or ((4495 - (421 + 1355)) <= (2386 - 939))) then
									return v149;
								end
								break;
							end
						end
					end
					if ((v55.UnendingResolve:IsReady() and (v13:HealthPercentage() < v47)) or ((2031 + 2103) < (5009 - (286 + 797)))) then
						if (v24(v55.UnendingResolve, nil, nil, true) or ((599 - 435) >= (4612 - 1827))) then
							return "unending_resolve defensive";
						end
					end
					v98();
					if (v86() or (v63 < (461 - (397 + 42))) or ((164 + 361) == (2909 - (24 + 776)))) then
						local v150 = v101();
						if (((50 - 17) == (818 - (222 + 563))) and v150 and v32 and v31) then
							return v150;
						end
					end
					local v146 = v100();
					if (((6728 - 3674) <= (2891 + 1124)) and v146) then
						return v146;
					end
					if (((2061 - (23 + 167)) < (5180 - (690 + 1108))) and (v63 < (11 + 19))) then
						local v151 = v103();
						if (((1067 + 226) <= (3014 - (40 + 808))) and v151) then
							return v151;
						end
					end
					if ((v55.HandofGuldan:IsReady() and (v75 < (0.5 + 0)) and (((v63 % (363 - 268)) > (39 + 1)) or ((v63 % (51 + 44)) < (9 + 6))) and (v55.ReignofTyranny:IsAvailable() or (v79 > (573 - (47 + 524))))) or ((1674 + 905) < (336 - 213))) then
						if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((1264 - 418) >= (5400 - 3032))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((v55.SummonDemonicTyrant:CooldownRemains() < (1741 - (1165 + 561))) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (1 + 4))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (15 - 10))) and ((v55.GrimoireFelguard:CooldownRemains() < (4 + 6)) or not v13:HasTier(509 - (341 + 138), 1 + 1)) and ((v72 < (30 - 15)) or (v63 < (366 - (89 + 237))) or v13:PowerInfusionUp())) or (v55.SummonVilefiend:IsAvailable() and (v55.SummonDemonicTyrant:CooldownRemains() < (48 - 33)) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (10 - 5))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (886 - (581 + 300)))) and ((v55.GrimoireFelguard:CooldownRemains() < (1230 - (855 + 365))) or not v13:HasTier(71 - 41, 1 + 1)) and ((v72 < (1250 - (1030 + 205))) or (v63 < (38 + 2)) or v13:PowerInfusionUp())) or ((3733 + 279) <= (3644 - (156 + 130)))) then
						local v152 = v102();
						if (((3394 - 1900) <= (5064 - 2059)) and v152) then
							return v152;
						end
					end
					if (((v55.SummonDemonicTyrant:CooldownRemains() < (30 - 15)) and (v90() or (not v55.SummonVilefiend:IsAvailable() and (v84() or v55.GrimoireFelguard:CooldownUp() or not v13:HasTier(8 + 22, 2 + 0)))) and ((v72 < (84 - (10 + 59))) or v84() or (v63 < (12 + 28)) or v13:PowerInfusionUp())) or ((15320 - 12209) == (3297 - (671 + 492)))) then
						local v153 = v102();
						if (((1875 + 480) == (3570 - (369 + 846))) and v153) then
							return v153;
						end
					end
					if ((v55.SummonDemonicTyrant:IsCastable() and (v90() or v84() or (v55.GrimoireFelguard:CooldownRemains() > (24 + 66)))) or ((502 + 86) <= (2377 - (1036 + 909)))) then
						if (((3814 + 983) >= (6539 - 2644)) and v23(v55.SummonDemonicTyrant, v53)) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if (((3780 - (11 + 192)) == (1808 + 1769)) and v55.SummonVilefiend:IsReady() and (v55.SummonDemonicTyrant:CooldownRemains() > (220 - (135 + 40)))) then
						if (((9192 - 5398) > (2226 + 1467)) and v23(v55.SummonVilefiend)) then
							return "summon_vilefiend main 6";
						end
					end
					if ((v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (((not v55.SoulStrike:IsAvailable() or (v55.SoulStrike:CooldownRemains() > (v76 * (4 - 2)))) and (v74 < (5 - 1))) or (v74 < ((180 - (50 + 126)) - (v26(v79 > (5 - 3)))))) and not v13:PrevGCDP(1 + 0, v55.Demonbolt) and v13:HasTier(1444 - (1233 + 180), 971 - (522 + 447))) or ((2696 - (107 + 1314)) == (1903 + 2197))) then
						if (v80.CastCycle(v55.Demonbolt, v78, v93, not v14:IsSpellInRange(v55.Demonbolt)) or ((4847 - 3256) >= (1521 + 2059))) then
							return "demonbolt main 8";
						end
					end
					if (((1951 - 968) <= (7153 - 5345)) and v55.PowerSiphon:IsReady() and v13:BuffDown(v55.DemonicCoreBuff) and (v14:DebuffDown(v55.DoomBrandDebuff) or (not v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v76 + v55.Demonbolt:TravelTime()))) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v76 + v55.Demonbolt:TravelTime() + (1913 - (716 + 1194)))))) and v13:HasTier(1 + 30, 1 + 1)) then
						if (v23(v55.PowerSiphon, v52) or ((2653 - (74 + 429)) <= (2308 - 1111))) then
							return "power_siphon main 10";
						end
					end
					if (((1868 + 1901) >= (2684 - 1511)) and v55.DemonicStrength:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v76)) then
						if (((1051 + 434) == (4577 - 3092)) and v23(v55.DemonicStrength, v48)) then
							return "demonic_strength main 12";
						end
					end
					if ((v55.BilescourgeBombers:IsReady() and v55.BilescourgeBombers:IsCastable()) or ((8196 - 4881) <= (3215 - (279 + 154)))) then
						if (v23(v55.BilescourgeBombers, nil, nil, not v14:IsInRange(818 - (454 + 324))) or ((690 + 186) >= (2981 - (12 + 5)))) then
							return "bilescourge_bombers main 14";
						end
					end
					if ((v55.Guillotine:IsCastable() and v46 and (v13:BuffRemains(v55.NetherPortalBuff) < v76) and (v55.DemonicStrength:CooldownDown() or not v55.DemonicStrength:IsAvailable())) or ((1204 + 1028) > (6362 - 3865))) then
						if (v23(v57.Guillotine, nil, nil, not v14:IsInRange(15 + 25)) or ((3203 - (277 + 816)) <= (1418 - 1086))) then
							return "guillotine main 16";
						end
					end
					if (((4869 - (1058 + 125)) > (595 + 2577)) and v55.CallDreadstalkers:IsReady() and ((v55.SummonDemonicTyrant:CooldownRemains() > (1000 - (815 + 160))) or (v72 > (107 - 82)) or v13:BuffUp(v55.NetherPortalBuff))) then
						if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((10620 - 6146) < (196 + 624))) then
							return "call_dreadstalkers main 18";
						end
					end
					if (((12508 - 8229) >= (4780 - (41 + 1857))) and v55.Implosion:IsReady() and (v82(1895 - (1222 + 671)) > (0 - 0)) and v67 and not v13:PrevGCDP(1 - 0, v55.Implosion)) then
						if (v23(v55.Implosion, v50, nil, not v14:IsInRange(1222 - (229 + 953))) or ((3803 - (1111 + 663)) >= (5100 - (874 + 705)))) then
							return "implosion main 20";
						end
					end
					if ((v55.SummonSoulkeeper:IsReady() and (v55.SummonSoulkeeper:Count() == (2 + 8)) and (v79 > (1 + 0))) or ((4233 - 2196) >= (131 + 4511))) then
						if (((2399 - (642 + 37)) < (1017 + 3441)) and v23(v55.SummonSoulkeeper)) then
							return "soul_strike main 22";
						end
					end
					if ((v55.HandofGuldan:IsReady() and (((v74 > (1 + 1)) and (v55.CallDreadstalkers:CooldownRemains() > (v76 * (9 - 5))) and (v55.SummonDemonicTyrant:CooldownRemains() > (471 - (233 + 221)))) or (v74 == (11 - 6)) or ((v74 == (4 + 0)) and v55.SoulStrike:IsAvailable() and (v55.SoulStrike:CooldownRemains() < (v76 * (1543 - (718 + 823)))))) and (v79 == (1 + 0)) and v55.GrandWarlocksDesign:IsAvailable()) or ((1241 - (266 + 539)) > (8553 - 5532))) then
						if (((1938 - (636 + 589)) <= (2010 - 1163)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
							return "hand_of_guldan main 26";
						end
					end
					if (((4442 - 2288) <= (3195 + 836)) and v55.HandofGuldan:IsReady() and (v74 > (1 + 1)) and not ((v79 == (1016 - (657 + 358))) and v55.GrandWarlocksDesign:IsAvailable())) then
						if (((12219 - 7604) == (10514 - 5899)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					if ((v55.Demonbolt:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) > (1188 - (1151 + 36))) and (((v74 < (4 + 0)) and not v55.SoulStrike:IsAvailable()) or (v55.SoulStrike:CooldownRemains() > (v76 * (1 + 1))) or (v74 < (5 - 3))) and not v68) or ((5622 - (1552 + 280)) == (1334 - (64 + 770)))) then
						if (((61 + 28) < (501 - 280)) and v80.CastCycle(v55.Demonbolt, v78, v94, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 30";
						end
					end
					if (((365 + 1689) >= (2664 - (157 + 1086))) and v55.Demonbolt:IsReady() and v13:HasTier(61 - 30, 8 - 6) and v13:BuffUp(v55.DemonicCoreBuff) and (v74 < (5 - 1)) and not v68) then
						if (((943 - 251) < (3877 - (599 + 220))) and v80.CastTargetIf(v55.Demonbolt, v78, "==", v94, v96, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 32";
						end
					end
					if ((v55.Demonbolt:IsReady() and (v63 < (v13:BuffStack(v55.DemonicCoreBuff) * v76))) or ((6479 - 3225) == (3586 - (1813 + 118)))) then
						if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or ((948 + 348) == (6127 - (841 + 376)))) then
							return "demonbolt main 34";
						end
					end
					if (((4719 - 1351) == (783 + 2585)) and v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (v55.PowerSiphon:CooldownRemains() < (10 - 6)) and (v74 < (863 - (464 + 395))) and not v68) then
						if (((6782 - 4139) < (1833 + 1982)) and v80.CastCycle(v55.Demonbolt, v78, v94, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 36";
						end
					end
					if (((2750 - (467 + 370)) > (1018 - 525)) and v55.PowerSiphon:IsReady() and (v13:BuffDown(v55.DemonicCoreBuff))) then
						if (((3491 + 1264) > (11751 - 8323)) and v23(v55.PowerSiphon, v52)) then
							return "power_siphon main 38";
						end
					end
					if (((216 + 1165) <= (5511 - 3142)) and v55.SummonVilefiend:IsReady() and (v63 < (v55.SummonDemonicTyrant:CooldownRemains() + (525 - (150 + 370))))) then
						if (v23(v55.SummonVilefiend) or ((6125 - (74 + 1208)) == (10044 - 5960))) then
							return "summon_vilefiend main 40";
						end
					end
					if (((22143 - 17474) > (259 + 104)) and v55.Doom:IsReady()) then
						if (v80.CastCycle(v55.Doom, v77, v95, not v14:IsSpellInRange(v55.Doom)) or ((2267 - (14 + 376)) >= (5442 - 2304))) then
							return "doom main 42";
						end
					end
					if (((3069 + 1673) >= (3186 + 440)) and v55.ShadowBolt:IsCastable()) then
						if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((4330 + 210) == (2683 - 1767))) then
							return "shadow_bolt main 44";
						end
					end
				end
				break;
			end
		end
	end
	local function v105()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(201 + 65, v104, v105);
end;
return v0["Epix_Warlock_Demonology.lua"]();

