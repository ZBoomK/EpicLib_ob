local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1796 - (503 + 1293);
	local v6;
	while true do
		if (((11534 - 7404) <= (3583 + 1371)) and (v5 == (1062 - (810 + 251)))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((699 + 1576) > (4099 + 447))) then
			v6 = v0[v4];
			if (((1352 - (43 + 490)) >= (755 - (711 + 22))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
		local v106 = 859 - (240 + 619);
		while true do
			if (((764 + 2398) == (5029 - 1867)) and (v106 == (1 + 2))) then
				v45 = EpicSettings.Settings['DemonboltOpener'];
				v46 = EpicSettings.Settings["Use Guillotine"] or (1744 - (1344 + 400));
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (405 - (255 + 150));
				v48 = EpicSettings.Settings['DemonicStrength'];
				v106 = 4 + 0;
			end
			if ((v106 == (3 + 1)) or ((10121 - 7752) > (14304 - 9875))) then
				v49 = EpicSettings.Settings['GrimoireFelguard'];
				v50 = EpicSettings.Settings['Implosion'];
				v51 = EpicSettings.Settings['NetherPortal'];
				v52 = EpicSettings.Settings['PowerSiphon'];
				v106 = 1744 - (404 + 1335);
			end
			if (((4501 - (183 + 223)) >= (3872 - 689)) and (v106 == (1 + 0))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (337 - (10 + 327));
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v106 = 340 - (118 + 220);
			end
			if ((v106 == (2 + 3)) or ((4160 - (108 + 341)) < (453 + 555))) then
				v53 = EpicSettings.Settings['SummonDemonicTyrant'];
				break;
			end
			if (((8 - 6) == v106) or ((2542 - (711 + 782)) <= (1736 - 830))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (469 - (270 + 199));
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (1819 - (580 + 1239));
				v106 = 8 - 5;
			end
			if (((4316 + 197) > (98 + 2628)) and (v106 == (0 + 0))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v106 = 1 + 0;
			end
		end
	end
	local v55 = v18.Warlock.Demonology;
	local v56 = v19.Warlock.Demonology;
	local v57 = v20.Warlock.Demonology;
	local v58 = {};
	local v59 = v13:GetEquipment();
	local v60 = (v59[1180 - (645 + 522)] and v19(v59[1803 - (1010 + 780)])) or v19(0 + 0);
	local v61 = (v59[66 - 52] and v19(v59[41 - 27])) or v19(1836 - (1045 + 791));
	local v62 = 28124 - 17013;
	local v63 = 16965 - 5854;
	local v64 = 505 - (351 + 154);
	local v65 = 1574 - (1281 + 293);
	local v66 = false;
	local v67 = false;
	local v68 = false;
	local v69 = 266 - (28 + 238);
	local v70 = 0 - 0;
	local v71 = 1559 - (1381 + 178);
	local v72 = 113 + 7;
	local v73 = 0 + 0;
	local v74 = 0 + 0;
	local v75 = 0 - 0;
	local v76 = 0 + 0;
	local v77;
	local v78, v79;
	v10:RegisterForEvent(function()
		v62 = 11581 - (381 + 89);
		v63 = 9854 + 1257;
	end, "PLAYER_REGEN_ENABLED");
	local v80 = v10.Commons.Everyone;
	v10:RegisterForEvent(function()
		v59 = v13:GetEquipment();
		v60 = (v59[9 + 4] and v19(v59[22 - 9])) or v19(1156 - (1074 + 82));
		v61 = (v59[30 - 16] and v19(v59[1798 - (214 + 1570)])) or v19(1455 - (990 + 465));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v55.HandofGuldan:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v55.HandofGuldan:RegisterInFlight();
	local function v81()
		return v10.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v82(v107)
		local v108 = 0 + 0;
		local v109;
		while true do
			if ((v108 == (0 + 0)) or ((5828 - 4347) >= (4384 - (1668 + 58)))) then
				v109 = 626 - (512 + 114);
				for v139, v140 in pairs(v10.GuardiansTable.Pets) do
					if ((v140.ImpCasts <= v107) or ((8395 - 5175) == (2819 - 1455))) then
						v109 = v109 + (3 - 2);
					end
				end
				v108 = 1 + 0;
			end
			if (((1 + 0) == v108) or ((917 + 137) > (11440 - 8048))) then
				return v109;
			end
		end
	end
	local function v83()
		return v10.GuardiansTable.FelGuardDuration or (1994 - (109 + 1885));
	end
	local function v84()
		return v83() > (1469 - (1269 + 200));
	end
	local function v85()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 - 0);
	end
	local function v86()
		return v85() > (815 - (98 + 717));
	end
	local function v87()
		return v10.GuardiansTable.DreadstalkerDuration or (826 - (802 + 24));
	end
	local function v88()
		return v87() > (0 - 0);
	end
	local function v89()
		return v10.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v90()
		return v89() > (0 + 0);
	end
	local function v91()
		return v10.GuardiansTable.PitLordDuration or (0 + 0);
	end
	local function v92()
		return v91() > (0 + 0);
	end
	local function v93(v110)
		return v110:DebuffDown(v55.DoomBrandDebuff) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) <= (1 + 2)));
	end
	local function v94(v111)
		return (v111:DebuffDown(v55.DoomBrandDebuff)) or (v79 < (11 - 7));
	end
	local function v95(v112)
		return (v112:DebuffRefreshable(v55.Doom));
	end
	local function v96(v113)
		return v113:DebuffRemains(v55.DoomBrandDebuff) > (33 - 23);
	end
	local function v97()
		local v114 = 0 + 0;
		while true do
			if (((1 + 1) == v114) or ((558 + 118) >= (1194 + 448))) then
				if (((1932 + 2204) > (3830 - (797 + 636))) and v55.PowerSiphon:IsReady()) then
					if (v24(v55.PowerSiphon) or ((21043 - 16709) == (5864 - (1427 + 192)))) then
						return "power_siphon precombat 2";
					end
				end
				if ((v55.Demonbolt:IsReady() and v13:BuffDown(v55.DemonicCoreBuff)) or ((1482 + 2794) <= (7037 - 4006))) then
					if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or ((4299 + 483) <= (544 + 655))) then
						return "demonbolt precombat 4";
					end
				end
				v114 = 329 - (192 + 134);
			end
			if (((1279 - (316 + 960)) == v114) or ((2707 + 2157) < (1468 + 434))) then
				if (((4473 + 366) >= (14145 - 10445)) and v55.ShadowBolt:IsReady()) then
					if (v23(v57.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((1626 - (83 + 468)) > (3724 - (1202 + 604)))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((1848 - 1452) <= (6330 - 2526)) and (v114 == (2 - 1))) then
				v69 = 325 - (45 + 280);
				v70 = 0 + 0;
				v114 = 2 + 0;
			end
			if ((v114 == (0 + 0)) or ((2307 + 1862) == (385 + 1802))) then
				v73 = 21 - 9;
				v64 = (1925 - (340 + 1571)) + v26(v55.GrimoireFelguard:IsAvailable()) + v26(v55.SummonVilefiend:IsAvailable());
				v114 = 1 + 0;
			end
		end
	end
	local function v98()
		local v115 = 1772 - (1733 + 39);
		local v116;
		while true do
			if (((3863 - 2457) == (2440 - (125 + 909))) and ((1948 - (1096 + 852)) == v115)) then
				if (((687 + 844) < (6099 - 1828)) and ((v13:BuffUp(v55.NetherPortalBuff) and (v13:BuffRemains(v55.NetherPortalBuff) < (3 + 0)) and v55.NetherPortal:IsAvailable()) or (v63 < (532 - (409 + 103))) or (v86() and (v63 < (336 - (46 + 190)))) or (v63 < (120 - (51 + 44))) or v86() or (not v55.SummonDemonicTyrant:IsAvailable() and v88())) and (v71 <= (0 + 0))) then
					v70 = (1437 - (1114 + 203)) + v75;
				end
				v71 = v70 - v75;
				if (((1361 - (228 + 498)) == (138 + 497)) and (((((v63 + v75) % (67 + 53)) <= (748 - (174 + 489))) and (((v63 + v75) % (312 - 192)) >= (1930 - (830 + 1075)))) or (v75 >= (734 - (303 + 221)))) and (v71 > (1269 - (231 + 1038))) and not v55.GrandWarlocksDesign:IsAvailable()) then
					v72 = v71;
				else
					v72 = v55.SummonDemonicTyrant:CooldownRemains();
				end
				v115 = 1 + 0;
			end
			if (((4535 - (171 + 991)) <= (14654 - 11098)) and (v115 == (2 - 1))) then
				if ((v90() and v88()) or ((8212 - 4921) < (2626 + 654))) then
					v65 = v28(v89(), v87()) - (v13:GCD() * (0.5 - 0));
				end
				if (((12652 - 8266) >= (1407 - 534)) and not v55.SummonVilefiend:IsAvailable() and v55.GrimoireFelguard:IsAvailable() and v88()) then
					v65 = v28(v87(), v83()) - (v13:GCD() * (0.5 - 0));
				end
				if (((2169 - (111 + 1137)) <= (1260 - (91 + 67))) and not v55.SummonVilefiend:IsAvailable() and (not v55.GrimoireFelguard:IsAvailable() or not v13:HasTier(89 - 59, 1 + 1)) and v88()) then
					v65 = v87() - (v13:GCD() * (523.5 - (423 + 100)));
				end
				v115 = 1 + 1;
			end
			if (((13029 - 8323) >= (502 + 461)) and (v115 == (774 - (326 + 445)))) then
				if ((v79 > ((4 - 3) + v116)) or ((2138 - 1178) <= (2044 - 1168))) then
					v67 = not v86();
				end
				if (((v79 > ((713 - (530 + 181)) + v116)) and (v79 < ((886 - (614 + 267)) + v116))) or ((2098 - (19 + 13)) == (1516 - 584))) then
					v67 = v85() < (13 - 7);
				end
				if (((13783 - 8958) < (1258 + 3585)) and (v79 > ((6 - 2) + v116))) then
					v67 = v85() < (16 - 8);
				end
				v115 = 1816 - (1293 + 519);
			end
			if (((3 - 1) == v115) or ((10122 - 6245) >= (8675 - 4138))) then
				if ((not v90() and v55.SummonVilefiend:IsAvailable()) or not v88() or ((18606 - 14291) < (4065 - 2339))) then
					v65 = 0 + 0;
				end
				v66 = not v55.NetherPortal:IsAvailable() or (v55.NetherPortal:CooldownRemains() > (7 + 23)) or v13:BuffUp(v55.NetherPortalBuff);
				v116 = v26(v55.SacrificedSouls:IsAvailable());
				v115 = 6 - 3;
			end
			if ((v115 == (1 + 3)) or ((1223 + 2456) < (391 + 234))) then
				v68 = (v55.SummonDemonicTyrant:CooldownRemains() < (1116 - (709 + 387))) and (v72 < (1878 - (673 + 1185))) and ((v13:BuffStack(v55.DemonicCoreBuff) <= (5 - 3)) or v13:BuffDown(v55.DemonicCoreBuff)) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (16 - 11))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (8 - 3)));
				break;
			end
		end
	end
	local function v99()
		local v117 = v80.HandleTopTrinket(v58, v31, 29 + 11, nil);
		if (v117 or ((3456 + 1169) < (852 - 220))) then
			return v117;
		end
		local v117 = v80.HandleBottomTrinket(v58, v31, 10 + 30, nil);
		if (v117 or ((165 - 82) > (3494 - 1714))) then
			return v117;
		end
	end
	local function v100()
		local v118 = 1880 - (446 + 1434);
		while true do
			if (((1829 - (1040 + 243)) <= (3214 - 2137)) and (v118 == (1847 - (559 + 1288)))) then
				if ((v56.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v55.DemonicPowerBuff) or (not v55.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v55.NetherPortalBuff) or not v55.NetherPortal:IsAvailable())))) or ((2927 - (609 + 1322)) > (4755 - (13 + 441)))) then
					if (((15208 - 11138) > (1799 - 1112)) and v24(v57.TimebreachingTalon)) then
						return "timebreaching_talon items 2";
					end
				end
				if (not v55.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v55.DemonicPowerBuff) or ((3267 - 2611) >= (124 + 3206))) then
					local v141 = 0 - 0;
					local v142;
					while true do
						if ((v141 == (0 + 0)) or ((1092 + 1400) <= (994 - 659))) then
							v142 = v99();
							if (((2366 + 1956) >= (4711 - 2149)) and v142) then
								return v142;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v101()
		if (v55.Berserking:IsCastable() or ((2405 + 1232) >= (2097 + 1673))) then
			if (v24(v55.Berserking) or ((1710 + 669) > (3844 + 734))) then
				return "berserking ogcd 4";
			end
		end
		if (v55.BloodFury:IsCastable() or ((473 + 10) > (1176 - (153 + 280)))) then
			if (((7085 - 4631) > (519 + 59)) and v24(v55.BloodFury)) then
				return "blood_fury ogcd 6";
			end
		end
		if (((368 + 562) < (2333 + 2125)) and v55.Fireblood:IsCastable()) then
			if (((601 + 61) <= (705 + 267)) and v24(v55.Fireblood)) then
				return "fireblood ogcd 8";
			end
		end
	end
	local function v102()
		if (((6654 - 2284) == (2701 + 1669)) and (v65 > (667 - (89 + 578))) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76)) and (v70 <= (0 + 0))) then
			v70 = (249 - 129) + v75;
		end
		if ((v55.HandofGuldan:IsReady() and (v74 > (1049 - (572 + 477))) and (v65 > (v76 + v55.SummonDemonicTyrant:CastTime())) and (v65 < (v76 * (1 + 3)))) or ((2858 + 1904) <= (103 + 758))) then
			if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((1498 - (84 + 2)) == (7026 - 2762))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76))) or ((4010 - (497 + 345)) < (56 + 2097))) then
			local v121 = 0 + 0;
			local v122;
			local v123;
			while true do
				if ((v121 == (1335 - (605 + 728))) or ((3551 + 1425) < (2960 - 1628))) then
					v123 = v80.HandleDPSPotion();
					if (((213 + 4415) == (17110 - 12482)) and v123) then
						return v123;
					end
					break;
				end
				if ((v121 == (1 + 0)) or ((149 - 95) == (299 + 96))) then
					v122 = v101();
					if (((571 - (457 + 32)) == (35 + 47)) and v122) then
						return v122;
					end
					v121 = 1404 - (832 + 570);
				end
				if ((v121 == (0 + 0)) or ((152 + 429) < (997 - 715))) then
					v122 = v100();
					if (v122 or ((2221 + 2388) < (3291 - (588 + 208)))) then
						return v122;
					end
					v121 = 2 - 1;
				end
			end
		end
		if (((2952 - (884 + 916)) == (2411 - 1259)) and v55.SummonDemonicTyrant:IsCastable() and (v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v76) + v76))) then
			if (((2549 - (232 + 421)) <= (5311 - (1569 + 320))) and v23(v55.SummonDemonicTyrant, v53)) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if ((v55.Implosion:IsReady() and (v81() > (1 + 1)) and not v88() and not v84() and not v90() and ((v79 > (1 + 2)) or ((v79 > (6 - 4)) and v55.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(606 - (316 + 289), v55.Implosion)) or ((2591 - 1601) > (75 + 1545))) then
			if (v23(v55.Implosion, v50, nil, not v14:IsInRange(1493 - (666 + 787))) or ((1302 - (360 + 65)) > (4388 + 307))) then
				return "implosion tyrant 8";
			end
		end
		if (((2945 - (79 + 175)) >= (2918 - 1067)) and v55.ShadowBolt:IsReady() and v13:PrevGCDP(1 + 0, v55.GrimoireFelguard) and (v75 > (91 - 61)) and v13:BuffDown(v55.NetherPortalBuff) and v13:BuffDown(v55.DemonicCoreBuff)) then
			if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((5748 - 2763) >= (5755 - (503 + 396)))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if (((4457 - (92 + 89)) >= (2317 - 1122)) and v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (3 + 1)) and (not v90() or (not v55.SummonVilefiend:IsAvailable() and v87())) and v13:BuffDown(v55.NetherPortalBuff)) then
			if (((1913 + 1319) <= (18366 - 13676)) and v23(v55.PowerSiphon, v52)) then
				return "power_siphon tyrant 12";
			end
		end
		if ((v55.ShadowBolt:IsReady() and not v90() and v13:BuffDown(v55.NetherPortalBuff) and not v88() and (v74 < ((1 + 4) - v13:BuffStack(v55.DemonicCoreBuff)))) or ((2042 - 1146) >= (2745 + 401))) then
			if (((1463 + 1598) >= (9008 - 6050)) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if (((398 + 2789) >= (981 - 337)) and v55.NetherPortal:IsReady() and (v74 == (1249 - (485 + 759)))) then
			if (((1489 - 845) <= (1893 - (442 + 747))) and v23(v55.NetherPortal, v51)) then
				return "nether_portal tyrant 16";
			end
		end
		if (((2093 - (832 + 303)) > (1893 - (88 + 858))) and v55.SummonVilefiend:IsReady() and ((v74 == (2 + 3)) or v13:BuffUp(v55.NetherPortalBuff)) and (v55.SummonDemonicTyrant:CooldownRemains() < (11 + 2)) and v66) then
			if (((186 + 4306) >= (3443 - (766 + 23))) and v23(v55.SummonVilefiend)) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if (((16992 - 13550) >= (2054 - 551)) and v55.CallDreadstalkers:IsReady() and (v90() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (79 - 49))) and (v13:BuffUp(v55.NetherPortalBuff) or v84() or (v74 == (16 - 11))))) and (v55.SummonDemonicTyrant:CooldownRemains() < (1084 - (1036 + 37))) and v66) then
			if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((2248 + 922) <= (2850 - 1386))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if ((v55.GrimoireFelguard:IsReady() and (v90() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (24 + 6))) and (v13:BuffUp(v55.NetherPortalBuff) or v88() or (v74 == (1485 - (641 + 839)))) and v66))) or ((5710 - (910 + 3)) == (11186 - 6798))) then
			if (((2235 - (1466 + 218)) <= (313 + 368)) and v23(v55.GrimoireFelguard, v49, nil, not v14:IsSpellInRange(v55.GrimoireFelguard))) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if (((4425 - (556 + 592)) > (145 + 262)) and v55.HandofGuldan:IsReady() and (v74 > (810 - (329 + 479))) and (v90() or (not v55.SummonVilefiend:IsAvailable() and v88())) and ((v74 > (856 - (174 + 680))) or (v89() < ((v76 * (6 - 4)) + ((3 - 1) / v13:SpellHaste()))))) then
			if (((3353 + 1342) >= (2154 - (396 + 343))) and v24(v55.HandofGuldan)) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if ((v55.Demonbolt:IsReady() and (v74 < (1 + 3)) and (v13:BuffStack(v55.DemonicCoreBuff) > (1478 - (29 + 1448))) and (v90() or (not v55.SummonVilefiend:IsAvailable() and v88()))) or ((4601 - (135 + 1254)) <= (3556 - 2612))) then
			if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or ((14455 - 11359) <= (1199 + 599))) then
				return "demonbolt tyrant 26";
			end
		end
		if (((5064 - (389 + 1138)) == (4111 - (102 + 472))) and v55.PowerSiphon:IsReady() and (((v13:BuffStack(v55.DemonicCoreBuff) < (3 + 0)) and (v65 > (v55.SummonDemonicTyrant:ExecuteTime() + (v76 * (2 + 1))))) or (v65 == (0 + 0)))) then
			if (((5382 - (320 + 1225)) >= (2794 - 1224)) and v23(v55.PowerSiphon, v52)) then
				return "power_siphon tyrant 28";
			end
		end
		if (v55.ShadowBolt:IsCastable() or ((1805 + 1145) == (5276 - (157 + 1307)))) then
			if (((6582 - (821 + 1038)) >= (5783 - 3465)) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v103()
		if ((v63 < (3 + 17)) or ((3600 - 1573) > (1062 + 1790))) then
			if (v55.GrimoireFelguard:IsReady() or ((2815 - 1679) > (5343 - (834 + 192)))) then
				if (((302 + 4446) == (1219 + 3529)) and v23(v55.GrimoireFelguard, v49)) then
					return "grimoire_felguard fight_end 2";
				end
			end
			if (((81 + 3655) <= (7343 - 2603)) and v55.CallDreadstalkers:IsReady()) then
				if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((3694 - (300 + 4)) <= (818 + 2242))) then
					return "call_dreadstalkers fight_end 4";
				end
			end
			if (v55.SummonVilefiend:IsReady() or ((2614 - 1615) > (3055 - (112 + 250)))) then
				if (((185 + 278) < (1505 - 904)) and v23(v55.SummonVilefiend)) then
					return "summon_vilefiend fight_end 6";
				end
			end
		end
		if ((v55.NetherPortal:IsReady() and (v63 < (18 + 12))) or ((1129 + 1054) < (514 + 173))) then
			if (((2256 + 2293) == (3380 + 1169)) and v23(v55.NetherPortal, v51)) then
				return "nether_portal fight_end 8";
			end
		end
		if (((6086 - (1001 + 413)) == (10418 - 5746)) and v55.SummonDemonicTyrant:IsCastable() and (v63 < (902 - (244 + 638)))) then
			if (v23(v55.SummonDemonicTyrant, v53) or ((4361 - (627 + 66)) < (1176 - 781))) then
				return "summon_demonic_tyrant fight_end 10";
			end
		end
		if ((v55.DemonicStrength:IsCastable() and (v63 < (612 - (512 + 90)))) or ((6072 - (1665 + 241)) == (1172 - (373 + 344)))) then
			if (v23(v55.DemonicStrength, v48) or ((2007 + 2442) == (705 + 1958))) then
				return "demonic_strength fight_end 12";
			end
		end
		if ((v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (7 - 4)) and (v63 < (33 - 13))) or ((5376 - (35 + 1064)) < (2175 + 814))) then
			if (v23(v55.PowerSiphon, v52) or ((1861 - 991) >= (17 + 4132))) then
				return "power_siphon fight_end 14";
			end
		end
		if (((3448 - (298 + 938)) < (4442 - (233 + 1026))) and v55.Implosion:IsReady() and (v63 < ((1668 - (636 + 1030)) * v76))) then
			if (((2376 + 2270) > (2923 + 69)) and v23(v55.Implosion, v50, nil, not v14:IsInRange(12 + 28))) then
				return "implosion fight_end 16";
			end
		end
	end
	local function v104()
		local v119 = 0 + 0;
		while true do
			if (((1655 - (55 + 166)) < (602 + 2504)) and ((1 + 1) == v119)) then
				if (((3001 - 2215) < (3320 - (36 + 261))) and v30) then
					local v143 = 0 - 0;
					while true do
						if ((v143 == (1369 - (34 + 1334))) or ((939 + 1503) < (58 + 16))) then
							v77 = v13:GetEnemiesInRange(1323 - (1035 + 248));
							break;
						end
						if (((4556 - (20 + 1)) == (2363 + 2172)) and (v143 == (319 - (134 + 185)))) then
							v78 = v14:GetEnemiesInSplashRange(1141 - (549 + 584));
							v79 = v14:GetEnemiesInSplashRangeCount(693 - (314 + 371));
							v143 = 3 - 2;
						end
					end
				else
					v78 = {};
					v79 = 969 - (478 + 490);
					v77 = {};
				end
				if (v80.TargetIsValid() or v13:AffectingCombat() or ((1594 + 1415) <= (3277 - (786 + 386)))) then
					local v144 = 0 - 0;
					while true do
						if (((3209 - (1055 + 324)) < (5009 - (1093 + 247))) and ((1 + 0) == v144)) then
							if ((v63 == (1169 + 9942)) or ((5677 - 4247) >= (12258 - 8646))) then
								v63 = v10.FightRemains(v78, false);
							end
							v25.UpdatePetTable();
							v144 = 5 - 3;
						end
						if (((6741 - 4058) >= (876 + 1584)) and (v144 == (7 - 5))) then
							v25.UpdateSoulShards();
							v75 = v10.CombatTime();
							v144 = 10 - 7;
						end
						if ((v144 == (3 + 0)) or ((4613 - 2809) >= (3963 - (364 + 324)))) then
							v74 = v13:SoulShardsP();
							v76 = v13:GCD() + (0.25 - 0);
							break;
						end
						if (((0 - 0) == v144) or ((470 + 947) > (15184 - 11555))) then
							v62 = v10.BossFightRemains();
							v63 = v62;
							v144 = 1 - 0;
						end
					end
				end
				v119 = 8 - 5;
			end
			if (((6063 - (1249 + 19)) > (363 + 39)) and ((15 - 11) == v119)) then
				if (((5899 - (686 + 400)) > (2798 + 767)) and v34 and (v13:HealthPercentage() <= v36)) then
					local v145 = 229 - (73 + 156);
					while true do
						if (((19 + 3893) == (4723 - (721 + 90))) and ((0 + 0) == v145)) then
							if (((9159 - 6338) <= (5294 - (224 + 246))) and (v35 == "Refreshing Healing Potion")) then
								if (((2815 - 1077) <= (4041 - 1846)) and v56.RefreshingHealingPotion:IsReady()) then
									if (((8 + 33) <= (72 + 2946)) and v24(v57.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((1576 + 569) <= (8158 - 4054)) and (v35 == "Dreamwalker's Healing Potion")) then
								if (((8948 - 6259) < (5358 - (203 + 310))) and v56.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v57.RefreshingHealingPotion) or ((4315 - (1238 + 755)) > (184 + 2438))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (v80.TargetIsValid() or ((6068 - (709 + 825)) == (3836 - 1754))) then
					if ((not v13:AffectingCombat() and v29 and not v13:IsCasting(v55.Demonbolt)) or ((2288 - 717) > (2731 - (196 + 668)))) then
						local v147 = v97();
						if (v147 or ((10478 - 7824) >= (6205 - 3209))) then
							return v147;
						end
					end
					if (((4811 - (171 + 662)) > (2197 - (4 + 89))) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v148 = v80.Interrupt(v55.SpellLock, 140 - 100, true);
						if (((1091 + 1904) > (6768 - 5227)) and v148) then
							return v148;
						end
						v148 = v80.Interrupt(v55.SpellLock, 16 + 24, true, v16, v57.SpellLockMouseover);
						if (((4735 - (35 + 1451)) > (2406 - (28 + 1425))) and v148) then
							return v148;
						end
						v148 = v80.Interrupt(v55.AxeToss, 2033 - (941 + 1052), true);
						if (v148 or ((3139 + 134) > (6087 - (822 + 692)))) then
							return v148;
						end
						v148 = v80.Interrupt(v55.AxeToss, 57 - 17, true, v16, v57.AxeTossMouseover);
						if (v148 or ((1485 + 1666) < (1581 - (45 + 252)))) then
							return v148;
						end
						v148 = v80.InterruptWithStun(v55.AxeToss, 40 + 0, true);
						if (v148 or ((637 + 1213) == (3720 - 2191))) then
							return v148;
						end
						v148 = v80.InterruptWithStun(v55.AxeToss, 473 - (114 + 319), true, v16, v57.AxeTossMouseover);
						if (((1178 - 357) < (2719 - 596)) and v148) then
							return v148;
						end
					end
					if (((576 + 326) < (3463 - 1138)) and v55.UnendingResolve:IsReady() and (v13:HealthPercentage() < v47)) then
						if (((1797 - 939) <= (4925 - (556 + 1407))) and v24(v55.UnendingResolve, nil, nil, true)) then
							return "unending_resolve defensive";
						end
					end
					v98();
					if (v86() or (v63 < (1228 - (741 + 465))) or ((4411 - (170 + 295)) < (679 + 609))) then
						local v149 = v101();
						if ((v149 and v32 and v31) or ((2978 + 264) == (1395 - 828))) then
							return v149;
						end
					end
					local v146 = v100();
					if (v146 or ((703 + 144) >= (810 + 453))) then
						return v146;
					end
					if ((v63 < (17 + 13)) or ((3483 - (957 + 273)) == (496 + 1355))) then
						local v150 = 0 + 0;
						local v151;
						while true do
							if ((v150 == (0 - 0)) or ((5499 - 3412) > (7244 - 4872))) then
								v151 = v103();
								if (v151 or ((22010 - 17565) < (5929 - (389 + 1391)))) then
									return v151;
								end
								break;
							end
						end
					end
					if ((v55.HandofGuldan:IsReady() and (v75 < (0.5 + 0)) and (((v63 % (10 + 85)) > (91 - 51)) or ((v63 % (1046 - (783 + 168))) < (50 - 35))) and (v55.ReignofTyranny:IsAvailable() or (v79 > (2 + 0)))) or ((2129 - (309 + 2)) == (261 - 176))) then
						if (((1842 - (1090 + 122)) < (690 + 1437)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((v55.SummonDemonicTyrant:CooldownRemains() < (50 - 35)) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (4 + 1))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (1123 - (628 + 490)))) and ((v55.GrimoireFelguard:CooldownRemains() < (2 + 8)) or not v13:HasTier(74 - 44, 9 - 7)) and ((v72 < (789 - (431 + 343))) or (v63 < (80 - 40)) or v13:PowerInfusionUp())) or (v55.SummonVilefiend:IsAvailable() and (v55.SummonDemonicTyrant:CooldownRemains() < (43 - 28)) and (v55.SummonVilefiend:CooldownRemains() < (v76 * (4 + 1))) and (v55.CallDreadstalkers:CooldownRemains() < (v76 * (1 + 4))) and ((v55.GrimoireFelguard:CooldownRemains() < (1705 - (556 + 1139))) or not v13:HasTier(45 - (6 + 9), 1 + 1)) and ((v72 < (8 + 7)) or (v63 < (209 - (28 + 141))) or v13:PowerInfusionUp())) or ((751 + 1187) == (3102 - 588))) then
						local v152 = v102();
						if (((3014 + 1241) >= (1372 - (486 + 831))) and v152) then
							return v152;
						end
					end
					if (((7803 - 4804) > (4069 - 2913)) and (v55.SummonDemonicTyrant:CooldownRemains() < (3 + 12)) and (v90() or (not v55.SummonVilefiend:IsAvailable() and (v84() or v55.GrimoireFelguard:CooldownUp() or not v13:HasTier(94 - 64, 1265 - (668 + 595))))) and ((v72 < (14 + 1)) or v84() or (v63 < (9 + 31)) or v13:PowerInfusionUp())) then
						local v153 = v102();
						if (((6408 - 4058) > (1445 - (23 + 267))) and v153) then
							return v153;
						end
					end
					if (((5973 - (1129 + 815)) <= (5240 - (371 + 16))) and v55.SummonDemonicTyrant:IsCastable() and (v90() or v84() or (v55.GrimoireFelguard:CooldownRemains() > (1840 - (1326 + 424))))) then
						if (v23(v55.SummonDemonicTyrant, v53) or ((976 - 460) > (12548 - 9114))) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if (((4164 - (88 + 30)) >= (3804 - (720 + 51))) and v55.SummonVilefiend:IsReady() and (v55.SummonDemonicTyrant:CooldownRemains() > (100 - 55))) then
						if (v23(v55.SummonVilefiend) or ((4495 - (421 + 1355)) <= (2386 - 939))) then
							return "summon_vilefiend main 6";
						end
					end
					if ((v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (((not v55.SoulStrike:IsAvailable() or (v55.SoulStrike:CooldownRemains() > (v76 * (1 + 1)))) and (v74 < (1087 - (286 + 797)))) or (v74 < ((14 - 10) - (v26(v79 > (2 - 0)))))) and not v13:PrevGCDP(440 - (397 + 42), v55.Demonbolt) and v13:HasTier(10 + 21, 802 - (24 + 776))) or ((6368 - 2234) < (4711 - (222 + 563)))) then
						if (v80.CastCycle(v55.Demonbolt, v78, v93, not v14:IsSpellInRange(v55.Demonbolt)) or ((360 - 196) >= (2006 + 779))) then
							return "demonbolt main 8";
						end
					end
					if ((v55.PowerSiphon:IsReady() and v13:BuffDown(v55.DemonicCoreBuff) and (v14:DebuffDown(v55.DoomBrandDebuff) or (not v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v76 + v55.Demonbolt:TravelTime()))) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v76 + v55.Demonbolt:TravelTime() + (193 - (23 + 167)))))) and v13:HasTier(1829 - (690 + 1108), 1 + 1)) or ((434 + 91) == (2957 - (40 + 808)))) then
						if (((6 + 27) == (126 - 93)) and v23(v55.PowerSiphon, v52)) then
							return "power_siphon main 10";
						end
					end
					if (((2919 + 135) <= (2125 + 1890)) and v55.DemonicStrength:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v76)) then
						if (((1027 + 844) < (3953 - (47 + 524))) and v23(v55.DemonicStrength, v48)) then
							return "demonic_strength main 12";
						end
					end
					if (((840 + 453) <= (5920 - 3754)) and v55.BilescourgeBombers:IsReady() and v55.BilescourgeBombers:IsCastable()) then
						if (v23(v55.BilescourgeBombers, nil, nil, not v14:IsInRange(59 - 19)) or ((5881 - 3302) < (1849 - (1165 + 561)))) then
							return "bilescourge_bombers main 14";
						end
					end
					if ((v55.Guillotine:IsCastable() and v46 and (v13:BuffRemains(v55.NetherPortalBuff) < v76) and (v55.DemonicStrength:CooldownDown() or not v55.DemonicStrength:IsAvailable())) or ((26 + 820) >= (7333 - 4965))) then
						if (v23(v57.Guillotine, nil, nil, not v14:IsInRange(16 + 24)) or ((4491 - (341 + 138)) <= (907 + 2451))) then
							return "guillotine main 16";
						end
					end
					if (((3082 - 1588) <= (3331 - (89 + 237))) and v55.CallDreadstalkers:IsReady() and ((v55.SummonDemonicTyrant:CooldownRemains() > (80 - 55)) or (v72 > (52 - 27)) or v13:BuffUp(v55.NetherPortalBuff))) then
						if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((3992 - (581 + 300)) == (3354 - (855 + 365)))) then
							return "call_dreadstalkers main 18";
						end
					end
					if (((5593 - 3238) == (769 + 1586)) and v55.Implosion:IsReady() and (v82(1237 - (1030 + 205)) > (0 + 0)) and v67 and not v13:PrevGCDP(1 + 0, v55.Implosion)) then
						if (v23(v55.Implosion, v50, nil, not v14:IsInRange(326 - (156 + 130))) or ((1335 - 747) <= (727 - 295))) then
							return "implosion main 20";
						end
					end
					if (((9824 - 5027) >= (1027 + 2868)) and v55.SummonSoulkeeper:IsReady() and (v55.SummonSoulkeeper:Count() == (6 + 4)) and (v79 > (70 - (10 + 59)))) then
						if (((1012 + 2565) == (17615 - 14038)) and v23(v55.SummonSoulkeeper)) then
							return "soul_strike main 22";
						end
					end
					if (((4957 - (671 + 492)) > (2940 + 753)) and v55.HandofGuldan:IsReady() and (((v74 > (1217 - (369 + 846))) and (v55.CallDreadstalkers:CooldownRemains() > (v76 * (2 + 2))) and (v55.SummonDemonicTyrant:CooldownRemains() > (15 + 2))) or (v74 == (1950 - (1036 + 909))) or ((v74 == (4 + 0)) and v55.SoulStrike:IsAvailable() and (v55.SoulStrike:CooldownRemains() < (v76 * (2 - 0))))) and (v79 == (204 - (11 + 192))) and v55.GrandWarlocksDesign:IsAvailable()) then
						if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((645 + 630) == (4275 - (135 + 40)))) then
							return "hand_of_guldan main 26";
						end
					end
					if ((v55.HandofGuldan:IsReady() and (v74 > (4 - 2)) and not ((v79 == (1 + 0)) and v55.GrandWarlocksDesign:IsAvailable())) or ((3504 - 1913) >= (5366 - 1786))) then
						if (((1159 - (50 + 126)) <= (5034 - 3226)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					if ((v55.Demonbolt:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) > (1 + 0)) and (((v74 < (1417 - (1233 + 180))) and not v55.SoulStrike:IsAvailable()) or (v55.SoulStrike:CooldownRemains() > (v76 * (971 - (522 + 447)))) or (v74 < (1423 - (107 + 1314)))) and not v68) or ((998 + 1152) <= (3647 - 2450))) then
						if (((1601 + 2168) >= (2329 - 1156)) and v80.CastCycle(v55.Demonbolt, v78, v94, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 30";
						end
					end
					if (((5875 - 4390) == (3395 - (716 + 1194))) and v55.Demonbolt:IsReady() and v13:HasTier(1 + 30, 1 + 1) and v13:BuffUp(v55.DemonicCoreBuff) and (v74 < (507 - (74 + 429))) and not v68) then
						if (v80.CastTargetIf(v55.Demonbolt, v78, "==", v94, v96, not v14:IsSpellInRange(v55.Demonbolt)) or ((6394 - 3079) <= (1379 + 1403))) then
							return "demonbolt main 32";
						end
					end
					if ((v55.Demonbolt:IsReady() and (v63 < (v13:BuffStack(v55.DemonicCoreBuff) * v76))) or ((2004 - 1128) >= (2097 + 867))) then
						if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or ((6880 - 4648) > (6173 - 3676))) then
							return "demonbolt main 34";
						end
					end
					if ((v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (v55.PowerSiphon:CooldownRemains() < (437 - (279 + 154))) and (v74 < (782 - (454 + 324))) and not v68) or ((1661 + 449) <= (349 - (12 + 5)))) then
						if (((1988 + 1698) > (8082 - 4910)) and v80.CastCycle(v55.Demonbolt, v78, v94, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 36";
						end
					end
					if ((v55.PowerSiphon:IsReady() and (v13:BuffDown(v55.DemonicCoreBuff))) or ((1654 + 2820) < (1913 - (277 + 816)))) then
						if (((18284 - 14005) >= (4065 - (1058 + 125))) and v23(v55.PowerSiphon, v52)) then
							return "power_siphon main 38";
						end
					end
					if ((v55.SummonVilefiend:IsReady() and (v63 < (v55.SummonDemonicTyrant:CooldownRemains() + 1 + 4))) or ((3004 - (815 + 160)) >= (15107 - 11586))) then
						if (v23(v55.SummonVilefiend) or ((4835 - 2798) >= (1108 + 3534))) then
							return "summon_vilefiend main 40";
						end
					end
					if (((5027 - 3307) < (6356 - (41 + 1857))) and v55.Doom:IsReady()) then
						if (v80.CastCycle(v55.Doom, v77, v95, not v14:IsSpellInRange(v55.Doom)) or ((2329 - (1222 + 671)) > (7807 - 4786))) then
							return "doom main 42";
						end
					end
					if (((1024 - 311) <= (2029 - (229 + 953))) and v55.ShadowBolt:IsCastable()) then
						if (((3928 - (1111 + 663)) <= (5610 - (874 + 705))) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
							return "shadow_bolt main 44";
						end
					end
				end
				break;
			end
			if (((646 + 3969) == (3149 + 1466)) and (v119 == (0 - 0))) then
				v54();
				v29 = EpicSettings.Toggles['ooc'];
				v119 = 1 + 0;
			end
			if ((v119 == (680 - (642 + 37))) or ((865 + 2925) == (80 + 420))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v119 = 4 - 2;
			end
			if (((543 - (233 + 221)) < (510 - 289)) and (v119 == (3 + 0))) then
				if (((3595 - (718 + 823)) >= (895 + 526)) and v55.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v43 and not v17:IsActive()) then
					if (((1497 - (266 + 539)) < (8657 - 5599)) and v24(v55.SummonPet, false, true)) then
						return "summon_pet ooc";
					end
				end
				if ((v56.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) or ((4479 - (636 + 589)) == (3928 - 2273))) then
					if (v24(v57.Healthstone) or ((2672 - 1376) == (3891 + 1019))) then
						return "healthstone defensive 3";
					end
				end
				v119 = 2 + 2;
			end
		end
	end
	local function v105()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(1281 - (657 + 358), v104, v105);
end;
return v0["Epix_Warlock_Demonology.lua"]();

