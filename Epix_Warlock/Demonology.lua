local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 900 - (765 + 135);
	local v6;
	while true do
		if (((9260 - 4984) >= (1741 + 2173)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((245 - (20 + 27)) <= (4652 - (50 + 237))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((7762 - 2980) > (2101 + 2575)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 4 - 3;
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
		local v104 = 1493 - (711 + 782);
		while true do
			if (((9324 - 4460) > (2666 - (270 + 199))) and (v104 == (1 + 2))) then
				v45 = EpicSettings.Settings['DemonboltOpener'];
				v46 = EpicSettings.Settings['Guillotine'];
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (1819 - (580 + 1239));
				v48 = EpicSettings.Settings['DemonicStrength'];
				v104 = 11 - 7;
			end
			if ((v104 == (4 + 0)) or ((133 + 3567) == (1093 + 1414))) then
				v49 = EpicSettings.Settings['GrimoireFelguard'];
				v50 = EpicSettings.Settings['Implosion'];
				v51 = EpicSettings.Settings['NetherPortal'];
				v52 = EpicSettings.Settings['PowerSiphon'];
				v104 = 13 - 8;
			end
			if (((2780 + 1694) >= (1441 - (645 + 522))) and (v104 == (1791 - (1010 + 780)))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v104 = 1838 - (1045 + 791);
			end
			if ((v104 == (12 - 7)) or ((2891 - 997) <= (1911 - (351 + 154)))) then
				v53 = EpicSettings.Settings['SummonDemonicTyrant'];
				break;
			end
			if (((3146 - (1281 + 293)) >= (1797 - (28 + 238))) and ((4 - 2) == v104)) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1559 - (1381 + 178));
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v104 = 2 + 1;
			end
			if ((v104 == (0 - 0)) or ((2429 + 2258) < (5012 - (381 + 89)))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v104 = 1 + 0;
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
	local v70 = 312 - 192;
	local v71 = 0 - 0;
	local v72 = 0 - 0;
	local v73 = 0 + 0;
	local v74 = 0 + 0;
	local v75;
	local v76, v77;
	v10:RegisterForEvent(function()
		v62 = 9660 + 1451;
		v63 = 37476 - 26365;
	end, "PLAYER_REGEN_ENABLED");
	local v78 = v10.Commons.Everyone;
	v10:RegisterForEvent(function()
		v59 = v13:GetEquipment();
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v55.HandofGuldan:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v55.HandofGuldan:RegisterInFlight();
	local function v79()
		return v10.GuardiansTable.ImpCount or (1994 - (109 + 1885));
	end
	local function v80(v105)
		local v106 = 1469 - (1269 + 200);
		local v107;
		while true do
			if (((6307 - 3016) > (2482 - (98 + 717))) and (v106 == (826 - (802 + 24)))) then
				v107 = 0 - 0;
				for v138, v139 in pairs(v10.GuardiansTable.Pets) do
					if ((v139.ImpCasts <= v105) or ((1101 - 228) == (301 + 1733))) then
						v107 = v107 + 1 + 0;
					end
				end
				v106 = 1 + 0;
			end
			if (((1 + 0) == v106) or ((7833 - 5017) < (36 - 25))) then
				return v107;
			end
		end
	end
	local function v81()
		return v10.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v82()
		return v81() > (0 + 0);
	end
	local function v83()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 + 0);
	end
	local function v84()
		return v83() > (0 + 0);
	end
	local function v85()
		return v10.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v86()
		return v85() > (1433 - (797 + 636));
	end
	local function v87()
		return v10.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v88()
		return v87() > (1619 - (1427 + 192));
	end
	local function v89()
		return v10.GuardiansTable.PitLordDuration or (0 + 0);
	end
	local function v90()
		return v89() > (0 - 0);
	end
	local function v91(v108)
		return v108:DebuffDown(v55.DoomBrandDebuff) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) <= (3 + 0)));
	end
	local function v92(v109)
		return v109:DebuffDown(v55.DoomBrandDebuff) or (v55.HandofGuldan:InFlight() and (v109:DebuffRemains(v55.DoomBrandDebuff) <= (2 + 1))) or (v77 < (330 - (192 + 134)));
	end
	local function v93(v110)
		return (v110:DebuffRefreshable(v55.Doom));
	end
	local function v94(v111)
		return v111:DebuffRemains(v55.DoomBrandDebuff) > (1286 - (316 + 960));
	end
	local function v95()
		local v112 = 0 + 0;
		while true do
			if (((2855 + 844) < (4350 + 356)) and ((7 - 5) == v112)) then
				if (((3197 - (83 + 468)) >= (2682 - (1202 + 604))) and v55.ShadowBolt:IsReady()) then
					if (((2866 - 2252) <= (5299 - 2115)) and v24(v57.ShadowBoltPetAttack, not v14:IsSpellInRange(v55.ShadowBolt), true)) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((8655 - 5529) == (3451 - (45 + 280))) and (v112 == (1 + 0))) then
				if (v55.PowerSiphon:IsReady() or ((1911 + 276) >= (1809 + 3145))) then
					if (v24(v55.PowerSiphon) or ((2146 + 1731) == (629 + 2946))) then
						return "power_siphon precombat 2";
					end
				end
				if (((1308 - 601) > (2543 - (340 + 1571))) and v55.Demonbolt:IsReady() and v45 and v13:BuffDown(v55.DemonicCoreBuff) and not v13:IsCasting(v55.Demonbolt) and (v55.Demonbolt:TimeSinceLastCast() >= (2 + 2))) then
					if (v24(v57.DemonboltPetAttack, not v14:IsSpellInRange(v55.Demonbolt), true) or ((2318 - (1733 + 39)) >= (7375 - 4691))) then
						return "demonbolt precombat 4";
					end
				end
				v112 = 1036 - (125 + 909);
			end
			if (((3413 - (1096 + 852)) <= (1930 + 2371)) and (v112 == (0 - 0))) then
				v71 = 12 + 0;
				v64 = (526 - (409 + 103)) + v26(v55.GrimoireFelguard:IsAvailable()) + v26(v55.SummonVilefiend:IsAvailable());
				v112 = 237 - (46 + 190);
			end
		end
	end
	local function v96()
		local v113 = 95 - (51 + 44);
		local v114;
		while true do
			if (((481 + 1223) > (2742 - (1114 + 203))) and ((726 - (228 + 498)) == v113)) then
				v70 = v55.SummonDemonicTyrant:CooldownRemains();
				if (v27(v69) or ((149 + 538) == (2340 + 1894))) then
					local v140 = 663 - (174 + 489);
					local v141;
					while true do
						if ((v140 == (0 - 0)) or ((5235 - (830 + 1075)) < (1953 - (303 + 221)))) then
							v141 = (1389 - (231 + 1038)) - (GetTime() - v25.LastPI);
							if (((956 + 191) >= (1497 - (171 + 991))) and (v141 > (0 - 0)) and (((((v63 + v73) % (322 - 202)) <= (212 - 127)) and (((v63 + v73) % (97 + 23)) >= (87 - 62))) or (v73 >= (605 - 395))) and v69 and not v55.GrandWarlocksDesign:IsAvailable()) then
								v70 = v141;
							end
							break;
						end
					end
				end
				if (((5537 - 2102) > (6482 - 4385)) and v88() and v86()) then
					v65 = v28(v87(), v85()) - (v13:GCD() * (1248.5 - (111 + 1137)));
				end
				if ((not v55.SummonVilefiend:IsAvailable() and v55.GrimoireFelguard:IsAvailable() and v86()) or ((3928 - (91 + 67)) >= (12027 - 7986))) then
					v65 = v28(v85(), v81()) - (v13:GCD() * (0.5 + 0));
				end
				v113 = 524 - (423 + 100);
			end
			if (((1 + 0) == v113) or ((10496 - 6705) <= (840 + 771))) then
				if ((not v55.SummonVilefiend:IsAvailable() and (not v55.GrimoireFelguard:IsAvailable() or not v13:HasTier(801 - (326 + 445), 8 - 6)) and v86()) or ((10198 - 5620) <= (4686 - 2678))) then
					v65 = v85() - (v13:GCD() * (711.5 - (530 + 181)));
				end
				if (((2006 - (614 + 267)) <= (2108 - (19 + 13))) and ((not v88() and v55.SummonVilefiend:IsAvailable()) or not v86())) then
					v65 = 0 - 0;
				end
				v66 = not v55.NetherPortal:IsAvailable() or (v55.NetherPortal:CooldownRemains() > (69 - 39)) or v13:BuffUp(v55.NetherPortalBuff);
				v114 = v26(v55.SacrificedSouls:IsAvailable());
				v113 = 5 - 3;
			end
			if (((1 + 1) == v113) or ((1306 - 563) >= (9122 - 4723))) then
				if (((2967 - (1293 + 519)) < (3413 - 1740)) and (v77 > ((2 - 1) + v114))) then
					v67 = not v84();
				end
				if (((v77 > ((3 - 1) + v114)) and (v77 < ((21 - 16) + v114))) or ((5474 - 3150) <= (307 + 271))) then
					v67 = v83() < (2 + 4);
				end
				if (((8752 - 4985) == (871 + 2896)) and (v77 > (2 + 2 + v114))) then
					v67 = v83() < (5 + 3);
				end
				v68 = (v55.SummonDemonicTyrant:CooldownRemains() < (1116 - (709 + 387))) and (v70 < (1878 - (673 + 1185))) and ((v13:BuffStack(v55.DemonicCoreBuff) <= (5 - 3)) or v13:BuffDown(v55.DemonicCoreBuff)) and (v55.SummonVilefiend:CooldownRemains() < (v74 * (16 - 11))) and (v55.CallDreadstalkers:CooldownRemains() < (v74 * (8 - 3)));
				break;
			end
		end
	end
	local function v97()
		ShouldReturn = v78.HandleTopTrinket(v58, v31, 29 + 11, nil);
		if (((3056 + 1033) == (5520 - 1431)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v78.HandleBottomTrinket(v58, v31, 10 + 30, nil);
		if (((8888 - 4430) >= (3285 - 1611)) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v98()
		local v115 = 1880 - (446 + 1434);
		while true do
			if (((2255 - (1040 + 243)) <= (4232 - 2814)) and (v115 == (1847 - (559 + 1288)))) then
				if ((v56.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v55.DemonicPowerBuff) or (not v55.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v55.NetherPortalBuff) or not v55.NetherPortal:IsAvailable())))) or ((6869 - (609 + 1322)) < (5216 - (13 + 441)))) then
					if (v24(v57.TimebreachingTalon) or ((9356 - 6852) > (11168 - 6904))) then
						return "timebreaching_talon items 2";
					end
				end
				if (((10722 - 8569) == (81 + 2072)) and (not v55.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v55.DemonicPowerBuff))) then
					local v142 = v97();
					if (v142 or ((1841 - 1334) >= (921 + 1670))) then
						return v142;
					end
				end
				break;
			end
		end
	end
	local function v99()
		if (((1964 + 2517) == (13297 - 8816)) and v55.Berserking:IsCastable()) then
			if (v24(v55.Berserking) or ((1274 + 1054) < (1273 - 580))) then
				return "berserking ogcd 4";
			end
		end
		if (((2862 + 1466) == (2408 + 1920)) and v55.BloodFury:IsCastable()) then
			if (((1141 + 447) >= (1119 + 213)) and v24(v55.BloodFury)) then
				return "blood_fury ogcd 6";
			end
		end
		if (v55.Fireblood:IsCastable() or ((4084 + 90) > (4681 - (153 + 280)))) then
			if (v24(v55.Fireblood) or ((13242 - 8656) <= (74 + 8))) then
				return "fireblood ogcd 8";
			end
		end
	end
	local function v100()
		local v116 = 0 + 0;
		while true do
			if (((2022 + 1841) == (3506 + 357)) and (v116 == (3 + 0))) then
				if ((v55.CallDreadstalkers:IsReady() and (v88() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (45 - 15))) and (v13:BuffUp(v55.NetherPortalBuff) or v82() or (v72 == (4 + 1))))) and (v55.SummonDemonicTyrant:CooldownRemains() < (678 - (89 + 578))) and v66) or ((202 + 80) <= (86 - 44))) then
					if (((5658 - (572 + 477)) >= (104 + 662)) and v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v55.GrimoireFelguard:IsReady() and (v88() or (not v55.SummonVilefiend:IsAvailable() and (not v55.NetherPortal:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55.NetherPortal:CooldownRemains() > (19 + 11))) and (v13:BuffUp(v55.NetherPortalBuff) or v86() or (v72 == (1 + 4))) and v66))) or ((1238 - (84 + 2)) == (4100 - 1612))) then
					if (((2466 + 956) > (4192 - (497 + 345))) and v23(v55.GrimoireFelguard, v49, nil, not v14:IsSpellInRange(v55.GrimoireFelguard))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				if (((23 + 854) > (64 + 312)) and v55.HandofGuldan:IsReady() and (v72 > (1335 - (605 + 728))) and (v88() or (not v55.SummonVilefiend:IsAvailable() and v86())) and ((v72 > (2 + 0)) or (v87() < ((v74 * (3 - 1)) + ((1 + 1) / v13:SpellHaste()))))) then
					if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((11527 - 8409) <= (1669 + 182))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				v116 = 10 - 6;
			end
			if ((v116 == (2 + 0)) or ((654 - (457 + 32)) >= (1482 + 2010))) then
				if (((5351 - (832 + 570)) < (4575 + 281)) and v55.ShadowBolt:IsReady() and not v88() and v13:BuffDown(v55.NetherPortalBuff) and not v86() and (v72 < ((2 + 3) - v13:BuffStack(v55.DemonicCoreBuff)))) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((15131 - 10855) < (1453 + 1563))) then
						return "shadow_bolt tyrant 14";
					end
				end
				if (((5486 - (588 + 208)) > (11117 - 6992)) and v55.NetherPortal:IsReady() and (v72 == (1805 - (884 + 916)))) then
					if (v23(v55.NetherPortal, v51) or ((104 - 54) >= (520 + 376))) then
						return "nether_portal tyrant 16";
					end
				end
				if ((v55.SummonVilefiend:IsReady() and ((v72 == (658 - (232 + 421))) or v13:BuffUp(v55.NetherPortalBuff)) and (v55.SummonDemonicTyrant:CooldownRemains() < (1902 - (1569 + 320))) and v66) or ((421 + 1293) >= (562 + 2396))) then
					if (v23(v55.SummonVilefiend) or ((5024 - 3533) < (1249 - (316 + 289)))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				v116 = 7 - 4;
			end
			if (((33 + 671) < (2440 - (666 + 787))) and (v116 == (426 - (360 + 65)))) then
				if (((3475 + 243) > (2160 - (79 + 175))) and v55.Implosion:IsReady() and (v79() > (2 - 0)) and not v86() and not v82() and not v88() and ((v77 > (3 + 0)) or ((v77 > (5 - 3)) and v55.GrandWarlocksDesign:IsAvailable()))) then
					if (v23(v55.Implosion, v50, nil, not v14:IsInRange(77 - 37)) or ((1857 - (503 + 396)) > (3816 - (92 + 89)))) then
						return "implosion tyrant 8";
					end
				end
				if (((6791 - 3290) <= (2304 + 2188)) and v55.ShadowBolt:IsReady() and v13:PrevGCDP(1 + 0, v55.GrimoireFelguard) and (v73 > (117 - 87)) and v13:BuffDown(v55.NetherPortalBuff) and v13:BuffDown(v55.DemonicCoreBuff)) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((471 + 2971) < (5809 - 3261))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if (((2509 + 366) >= (700 + 764)) and v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (12 - 8)) and (not v88() or (not v55.SummonVilefiend:IsAvailable() and v85())) and v13:BuffDown(v55.NetherPortalBuff)) then
					if (v23(v55.PowerSiphon, v52) or ((599 + 4198) >= (7461 - 2568))) then
						return "power_siphon tyrant 12";
					end
				end
				v116 = 1246 - (485 + 759);
			end
			if ((v116 == (8 - 4)) or ((1740 - (442 + 747)) > (3203 - (832 + 303)))) then
				if (((3060 - (88 + 858)) > (288 + 656)) and v55.Demonbolt:IsReady() and (v72 < (4 + 0)) and v13:BuffUp(v55.DemonicCoreBuff) and (v88() or (not v55.SummonVilefiend:IsAvailable() and v86()))) then
					if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or ((94 + 2168) >= (3885 - (766 + 23)))) then
						return "demonbolt tyrant 26";
					end
				end
				if ((v55.PowerSiphon:IsReady() and (((v13:BuffStack(v55.DemonicCoreBuff) < (14 - 11)) and (v65 > (v55.SummonDemonicTyrant:ExecuteTime() + (v74 * (3 - 0))))) or (v65 == (0 - 0)))) or ((7653 - 5398) >= (4610 - (1036 + 37)))) then
					if (v23(v55.PowerSiphon, v52) or ((2721 + 1116) < (2543 - 1237))) then
						return "power_siphon tyrant 28";
					end
				end
				if (((2321 + 629) == (4430 - (641 + 839))) and v55.ShadowBolt:IsCastable()) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or ((5636 - (910 + 3)) < (8407 - 5109))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if (((2820 - (1466 + 218)) >= (71 + 83)) and (v116 == (1148 - (556 + 592)))) then
				if ((v55.HandofGuldan:IsReady() and (v65 > (v74 + v55.SummonDemonicTyrant:CastTime())) and (v65 < (v74 * (2 + 2)))) or ((1079 - (329 + 479)) > (5602 - (174 + 680)))) then
					if (((16287 - 11547) >= (6532 - 3380)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v74) + v74))) or ((3317 - (396 + 343)) >= (300 + 3090))) then
					local v143 = 1477 - (29 + 1448);
					local v144;
					local v145;
					while true do
						if (((1430 - (135 + 1254)) <= (6257 - 4596)) and (v143 == (9 - 7))) then
							v145 = v78.HandleDPSPotion();
							if (((401 + 200) < (5087 - (389 + 1138))) and v145) then
								return v145;
							end
							break;
						end
						if (((809 - (102 + 472)) < (649 + 38)) and ((1 + 0) == v143)) then
							v144 = v99();
							if (((4242 + 307) > (2698 - (320 + 1225))) and v144) then
								return v144;
							end
							v143 = 2 - 0;
						end
						if (((0 + 0) == v143) or ((6138 - (157 + 1307)) < (6531 - (821 + 1038)))) then
							v144 = v98();
							if (((9151 - 5483) < (499 + 4062)) and v144) then
								return v144;
							end
							v143 = 1 - 0;
						end
					end
				end
				if ((v55.SummonDemonicTyrant:IsCastable() and (v65 > (0 + 0)) and (v65 < (v55.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v74) + v74))) or ((1127 - 672) == (4631 - (834 + 192)))) then
					if (v23(v55.SummonDemonicTyrant, v53) or ((170 + 2493) == (851 + 2461))) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v116 = 1 + 0;
			end
		end
	end
	local function v101()
		local v117 = 0 - 0;
		while true do
			if (((4581 - (300 + 4)) <= (1196 + 3279)) and ((0 - 0) == v117)) then
				if ((v63 < (382 - (112 + 250))) or ((347 + 523) == (2978 - 1789))) then
					local v146 = 0 + 0;
					while true do
						if (((804 + 749) <= (2344 + 789)) and (v146 == (1 + 0))) then
							if (v55.SummonVilefiend:IsReady() or ((1662 + 575) >= (4925 - (1001 + 413)))) then
								if (v23(v55.SummonVilefiend) or ((2952 - 1628) > (3902 - (244 + 638)))) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
						if ((v146 == (693 - (627 + 66))) or ((8914 - 5922) == (2483 - (512 + 90)))) then
							if (((5012 - (1665 + 241)) > (2243 - (373 + 344))) and v55.GrimoireFelguard:IsReady()) then
								if (((1364 + 1659) < (1024 + 2846)) and v23(v55.GrimoireFelguard, v49)) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((377 - 234) > (125 - 51)) and v55.CallDreadstalkers:IsReady()) then
								if (((1117 - (35 + 1064)) < (1537 + 575)) and v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v146 = 2 - 1;
						end
					end
				end
				if (((5 + 1092) <= (2864 - (298 + 938))) and v55.NetherPortal:IsReady() and (v63 < (1289 - (233 + 1026)))) then
					if (((6296 - (636 + 1030)) == (2368 + 2262)) and v23(v55.NetherPortal, v51)) then
						return "nether_portal fight_end 8";
					end
				end
				v117 = 1 + 0;
			end
			if (((1052 + 2488) > (182 + 2501)) and ((223 - (55 + 166)) == v117)) then
				if (((930 + 3864) >= (330 + 2945)) and v55.PowerSiphon:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < (11 - 8)) and (v63 < (317 - (36 + 261)))) then
					if (((2595 - 1111) == (2852 - (34 + 1334))) and v23(v55.PowerSiphon, v52)) then
						return "power_siphon fight_end 14";
					end
				end
				if (((551 + 881) < (2763 + 792)) and v55.Implosion:IsReady() and (v63 < ((1285 - (1035 + 248)) * v74))) then
					if (v23(v55.Implosion, v50, nil, not v14:IsInRange(61 - (20 + 1))) or ((555 + 510) > (3897 - (134 + 185)))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if ((v117 == (1134 - (549 + 584))) or ((5480 - (314 + 371)) < (4830 - 3423))) then
				if (((2821 - (478 + 490)) < (2550 + 2263)) and v55.SummonDemonicTyrant:IsCastable() and (v63 < (1192 - (786 + 386)))) then
					if (v23(v55.SummonDemonicTyrant, v53) or ((9137 - 6316) < (3810 - (1055 + 324)))) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v55.DemonicStrength:IsCastable() and (v63 < (1350 - (1093 + 247)))) or ((2554 + 320) < (230 + 1951))) then
					if (v23(v55.DemonicStrength, v48) or ((10675 - 7986) <= (1163 - 820))) then
						return "demonic_strength fight_end 12";
					end
				end
				v117 = 5 - 3;
			end
		end
	end
	local function v102()
		v54();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (v30 or ((4696 - 2827) == (715 + 1294))) then
			v76 = v14:GetEnemiesInSplashRange(30 - 22);
			v77 = v14:GetEnemiesInSplashRangeCount(27 - 19);
			v75 = v13:GetEnemiesInRange(31 + 9);
		else
			v76 = {};
			v77 = 2 - 1;
			v75 = {};
		end
		v25.UpdatePetTable();
		v25.UpdateSoulShards();
		if (v78.TargetIsValid() or v13:AffectingCombat() or ((4234 - (364 + 324)) < (6365 - 4043))) then
			local v122 = 0 - 0;
			while true do
				if ((v122 == (0 + 0)) or ((8711 - 6629) == (7643 - 2870))) then
					v62 = v10.BossFightRemains(nil, true);
					v63 = v62;
					v122 = 2 - 1;
				end
				if (((4512 - (1249 + 19)) > (953 + 102)) and (v122 == (3 - 2))) then
					if ((v63 == (12197 - (686 + 400))) or ((2600 + 713) <= (2007 - (73 + 156)))) then
						v63 = v10.FightRemains(v76, false);
					end
					v73 = v10.CombatTime();
					v122 = 1 + 1;
				end
				if ((v122 == (813 - (721 + 90))) or ((16 + 1405) >= (6831 - 4727))) then
					v72 = v13:SoulShardsP();
					v74 = v13:GCD() + (470.25 - (224 + 246));
					break;
				end
			end
		end
		if (((2935 - 1123) <= (5981 - 2732)) and v55.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v43 and not v17:IsActive()) then
			if (((295 + 1328) <= (47 + 1910)) and v55.FelDomination:IsCastable()) then
				if (((3241 + 1171) == (8771 - 4359)) and v24(v55.FelDomination, nil, nil, true)) then
					return "fel_domination ooc";
				end
			end
			if (((5823 - 4073) >= (1355 - (203 + 310))) and v24(v55.SummonPet, false, true)) then
				return "summon_pet ooc";
			end
		end
		if (((6365 - (1238 + 755)) > (130 + 1720)) and v78.TargetIsValid()) then
			local v123 = 1534 - (709 + 825);
			local v124;
			while true do
				if (((427 - 195) < (1195 - 374)) and (v123 == (864 - (196 + 668)))) then
					ImmovableCallDreadstalkers = v13:BuffDown(v55.DemonicCallingBuff);
					if (((2045 - 1527) < (1868 - 966)) and not v13:AffectingCombat() and v29 and not v13:IsCasting(v55.Demonbolt)) then
						local v147 = 833 - (171 + 662);
						local v148;
						while true do
							if (((3087 - (4 + 89)) > (3007 - 2149)) and (v147 == (0 + 0))) then
								v148 = v95();
								if (v148 or ((16492 - 12737) <= (359 + 556))) then
									return v148;
								end
								break;
							end
						end
					end
					if (((5432 - (35 + 1451)) > (5196 - (28 + 1425))) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v149 = 1993 - (941 + 1052);
						local v150;
						while true do
							if ((v149 == (0 + 0)) or ((2849 - (822 + 692)) >= (4719 - 1413))) then
								v150 = v78.Interrupt(v55.SpellLock, 19 + 21, true);
								if (((5141 - (45 + 252)) > (2230 + 23)) and v150) then
									return v150;
								end
								v150 = v78.Interrupt(v55.SpellLock, 14 + 26, true, v16, v57.SpellLockMouseover);
								v149 = 2 - 1;
							end
							if (((885 - (114 + 319)) == (648 - 196)) and (v149 == (3 - 0))) then
								if (v150 or ((2906 + 1651) < (3108 - 1021))) then
									return v150;
								end
								v150 = v78.InterruptWithStun(v55.AxeToss, 83 - 43, true, v16, v57.AxeTossMouseover);
								if (((5837 - (556 + 1407)) == (5080 - (741 + 465))) and v150) then
									return v150;
								end
								break;
							end
							if ((v149 == (467 - (170 + 295))) or ((1022 + 916) > (4533 + 402))) then
								v150 = v78.Interrupt(v55.AxeToss, 98 - 58, true, v16, v57.AxeTossMouseover);
								if (v150 or ((3528 + 727) < (2196 + 1227))) then
									return v150;
								end
								v150 = v78.InterruptWithStun(v55.AxeToss, 23 + 17, true);
								v149 = 1233 - (957 + 273);
							end
							if (((389 + 1065) <= (998 + 1493)) and (v149 == (3 - 2))) then
								if (v150 or ((10954 - 6797) <= (8561 - 5758))) then
									return v150;
								end
								v150 = v78.Interrupt(v55.AxeToss, 198 - 158, true);
								if (((6633 - (389 + 1391)) >= (1871 + 1111)) and v150) then
									return v150;
								end
								v149 = 1 + 1;
							end
						end
					end
					if (((9411 - 5277) > (4308 - (783 + 168))) and v55.UnendingResolve:IsReady() and (v13:HealthPercentage() < v47)) then
						if (v24(v55.UnendingResolve, nil, nil, true) or ((11468 - 8051) < (2493 + 41))) then
							return "unending_resolve defensive";
						end
					end
					v96();
					v123 = 312 - (309 + 2);
				end
				if ((v123 == (18 - 12)) or ((3934 - (1090 + 122)) <= (54 + 110))) then
					if ((v55.SummonVilefiend:IsReady() and (v63 < (v55.SummonDemonicTyrant:CooldownRemains() + (16 - 11)))) or ((1648 + 760) < (3227 - (628 + 490)))) then
						if (v23(v55.SummonVilefiend) or ((6 + 27) == (3602 - 2147))) then
							return "summon_vilefiend main 40";
						end
					end
					if (v55.Doom:IsReady() or ((2024 - 1581) >= (4789 - (431 + 343)))) then
						if (((6829 - 3447) > (480 - 314)) and v78.CastCycle(v55.Doom, v75, v93, not v14:IsSpellInRange(v55.Doom))) then
							return "doom main 42";
						end
					end
					if (v55.ShadowBolt:IsCastable() or ((222 + 58) == (392 + 2667))) then
						if (((3576 - (556 + 1139)) > (1308 - (6 + 9))) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
							return "shadow_bolt main 44";
						end
					end
					break;
				end
				if (((432 + 1925) == (1208 + 1149)) and (v123 == (170 - (28 + 141)))) then
					if (((48 + 75) == (151 - 28)) and (v84() or (v63 < (16 + 6)))) then
						local v151 = 1317 - (486 + 831);
						local v152;
						while true do
							if ((v151 == (0 - 0)) or ((3717 - 2661) >= (641 + 2751))) then
								v152 = v99();
								if ((v152 and v32 and v31) or ((3418 - 2337) < (2338 - (668 + 595)))) then
									return v152;
								end
								break;
							end
						end
					end
					v124 = v98();
					if (v124 or ((944 + 105) >= (894 + 3538))) then
						return v124;
					end
					if ((v63 < (81 - 51)) or ((5058 - (23 + 267)) <= (2790 - (1129 + 815)))) then
						local v153 = 387 - (371 + 16);
						local v154;
						while true do
							if ((v153 == (1750 - (1326 + 424))) or ((6359 - 3001) <= (5189 - 3769))) then
								v154 = v101();
								if (v154 or ((3857 - (88 + 30)) <= (3776 - (720 + 51)))) then
									return v154;
								end
								break;
							end
						end
					end
					if ((v55.HandofGuldan:IsReady() and (v73 < (0.5 - 0)) and (((v63 % (1871 - (421 + 1355))) > (65 - 25)) or ((v63 % (47 + 48)) < (1098 - (286 + 797)))) and (v55.ReignofTyranny:IsAvailable() or (v77 > (7 - 5)))) or ((2747 - 1088) >= (2573 - (397 + 42)))) then
						if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((1019 + 2241) < (3155 - (24 + 776)))) then
							return "hand_of_guldan main 2";
						end
					end
					v123 = 2 - 0;
				end
				if ((v123 == (790 - (222 + 563))) or ((1473 - 804) == (3041 + 1182))) then
					if ((v55.Demonbolt:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) > (191 - (23 + 167))) and (((v72 < (1802 - (690 + 1108))) and not v55.SoulStrike:IsAvailable()) or (v55.SoulStrike:CooldownRemains() > (v74 * (1 + 1))) or (v72 < (2 + 0))) and not v68) or ((2540 - (40 + 808)) < (97 + 491))) then
						if (v78.CastCycle(v55.Demonbolt, v76, v92, not v14:IsSpellInRange(v55.Demonbolt)) or ((18343 - 13546) < (3490 + 161))) then
							return "demonbolt main 30";
						end
					end
					if ((v55.Demonbolt:IsReady() and v13:HasTier(17 + 14, 2 + 0) and v13:BuffUp(v55.DemonicCoreBuff) and (v72 < (575 - (47 + 524))) and not v68) or ((2711 + 1466) > (13257 - 8407))) then
						if (v78.CastTargetIf(v55.Demonbolt, v76, "==", v92, v94, not v14:IsSpellInRange(v55.Demonbolt)) or ((598 - 198) > (2533 - 1422))) then
							return "demonbolt main 32";
						end
					end
					if (((4777 - (1165 + 561)) > (30 + 975)) and v55.Demonbolt:IsReady() and (v63 < (v13:BuffStack(v55.DemonicCoreBuff) * v74))) then
						if (((11437 - 7744) <= (1672 + 2710)) and v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt))) then
							return "demonbolt main 34";
						end
					end
					if ((v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (v55.PowerSiphon:CooldownRemains() < (483 - (341 + 138))) and (v72 < (2 + 2)) and not v68) or ((6772 - 3490) > (4426 - (89 + 237)))) then
						if (v78.CastCycle(v55.Demonbolt, v76, v92, not v14:IsSpellInRange(v55.Demonbolt)) or ((11516 - 7936) < (5987 - 3143))) then
							return "demonbolt main 36";
						end
					end
					if (((970 - (581 + 300)) < (5710 - (855 + 365))) and v55.PowerSiphon:IsReady() and (v13:BuffDown(v55.DemonicCoreBuff))) then
						if (v23(v55.PowerSiphon, v52) or ((11835 - 6852) < (591 + 1217))) then
							return "power_siphon main 38";
						end
					end
					v123 = 1241 - (1030 + 205);
				end
				if (((3595 + 234) > (3507 + 262)) and (v123 == (288 - (156 + 130)))) then
					if (((3374 - 1889) <= (4893 - 1989)) and (((v55.SummonDemonicTyrant:CooldownRemains() < (30 - 15)) and (v55.SummonVilefiend:CooldownRemains() < (v74 * (2 + 3))) and (v55.CallDreadstalkers:CooldownRemains() < (v74 * (3 + 2))) and ((v55.GrimoireFelguard:CooldownRemains() < (79 - (10 + 59))) or not v13:HasTier(9 + 21, 9 - 7)) and (not v69 or (v70 < (1178 - (671 + 492))) or (v63 < (32 + 8)) or v13:PowerInfusionUp())) or (v55.SummonVilefiend:IsAvailable() and (v55.SummonDemonicTyrant:CooldownRemains() < (1230 - (369 + 846))) and (v55.SummonVilefiend:CooldownRemains() < (v74 * (2 + 3))) and (v55.CallDreadstalkers:CooldownRemains() < (v74 * (5 + 0))) and ((v55.GrimoireFelguard:CooldownRemains() < (1955 - (1036 + 909))) or not v13:HasTier(24 + 6, 2 - 0)) and (not v69 or (v70 < (218 - (11 + 192))) or (v63 < (21 + 19)) or v13:PowerInfusionUp())))) then
						local v155 = 175 - (135 + 40);
						local v156;
						while true do
							if (((10343 - 6074) == (2574 + 1695)) and (v155 == (0 - 0))) then
								v156 = v100();
								if (((579 - 192) <= (2958 - (50 + 126))) and v156) then
									return v156;
								end
								break;
							end
						end
					end
					if (((v55.SummonDemonicTyrant:CooldownRemains() < (41 - 26)) and (v88() or (not v55.SummonVilefiend:IsAvailable() and (v82() or v55.GrimoireFelguard:CooldownUp() or not v13:HasTier(7 + 23, 1415 - (1233 + 180))))) and (not v69 or (v70 < (984 - (522 + 447))) or (v63 < (1461 - (107 + 1314))) or v13:PowerInfusionUp())) or ((882 + 1017) <= (2794 - 1877))) then
						local v157 = 0 + 0;
						local v158;
						while true do
							if (((0 - 0) == v157) or ((17060 - 12748) <= (2786 - (716 + 1194)))) then
								v158 = v100();
								if (((39 + 2193) <= (279 + 2317)) and v158) then
									return v158;
								end
								break;
							end
						end
					end
					if (((2598 - (74 + 429)) < (7110 - 3424)) and v55.SummonDemonicTyrant:IsCastable() and (v88() or v82() or (v55.GrimoireFelguard:CooldownRemains() > (45 + 45)))) then
						if (v23(v55.SummonDemonicTyrant, v53) or ((3651 - 2056) >= (3166 + 1308))) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if ((v55.SummonVilefiend:IsReady() and (v55.SummonDemonicTyrant:CooldownRemains() > (138 - 93))) or ((11420 - 6801) < (3315 - (279 + 154)))) then
						if (v23(v55.SummonVilefiend) or ((1072 - (454 + 324)) >= (3801 + 1030))) then
							return "summon_vilefiend main 6";
						end
					end
					if (((2046 - (12 + 5)) <= (1663 + 1421)) and v55.Demonbolt:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (((not v55.SoulStrike:IsAvailable() or (v55.SoulStrike:CooldownRemains() > (v74 * (4 - 2)))) and (v72 < (2 + 2))) or (v72 < ((1097 - (277 + 816)) - (v26(v77 > (8 - 6)))))) and not v13:PrevGCDP(1184 - (1058 + 125), v55.Demonbolt) and v13:HasTier(6 + 25, 977 - (815 + 160))) then
						if (v78.CastCycle(v55.Demonbolt, v76, v91, not v14:IsSpellInRange(v55.Demonbolt)) or ((8739 - 6702) == (5744 - 3324))) then
							return "demonbolt main 8";
						end
					end
					v123 = 1 + 2;
				end
				if (((13031 - 8573) > (5802 - (41 + 1857))) and (v123 == (1896 - (1222 + 671)))) then
					if (((1126 - 690) >= (175 - 52)) and v55.PowerSiphon:IsReady() and v13:BuffDown(v55.DemonicCoreBuff) and (v14:DebuffDown(v55.DoomBrandDebuff) or (not v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v74 + v55.Demonbolt:TravelTime()))) or (v55.HandofGuldan:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v74 + v55.Demonbolt:TravelTime() + (1185 - (229 + 953)))))) and v13:HasTier(1805 - (1111 + 663), 1581 - (874 + 705))) then
						if (((70 + 430) < (1240 + 576)) and v23(v55.PowerSiphon, v52)) then
							return "power_siphon main 10";
						end
					end
					if (((7428 - 3854) == (101 + 3473)) and v55.DemonicStrength:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v74) and (((v63 > (742 - (642 + 37))) and not (v63 > (v55.SummonDemonicTyrant:CooldownRemains() + 16 + 53))) or (v55.SummonDemonicTyrant:CooldownRemains() > (5 + 25)) or v69 or v13:BuffUp(v55.RiteofRuvaraadBuff) or not v55.SummonDemonicTyrant:IsAvailable() or not v55.GrimoireFelguard:IsAvailable() or not v13:HasTier(75 - 45, 456 - (233 + 221)))) then
						if (((510 - 289) < (344 + 46)) and v23(v55.DemonicStrength, v48)) then
							return "demonic_strength main 12";
						end
					end
					if (v55.BilescourgeBombers:IsReady() or ((3754 - (718 + 823)) <= (895 + 526))) then
						if (((3863 - (266 + 539)) < (13759 - 8899)) and v23(v55.BilescourgeBombers, nil, nil, not v14:IsInRange(1265 - (636 + 589)))) then
							return "bilescourge_bombers main 14";
						end
					end
					if ((v55.Guillotine:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v74) and (v55.DemonicStrength:CooldownDown() or not v55.DemonicStrength:IsAvailable())) or ((3076 - 1780) >= (9169 - 4723))) then
						if (v23(v55.Guillotine, nil, nil, not v14:IsInRange(32 + 8)) or ((507 + 886) > (5504 - (657 + 358)))) then
							return "guillotine main 16";
						end
					end
					if ((v55.CallDreadstalkers:IsReady() and ((v55.SummonDemonicTyrant:CooldownRemains() > (66 - 41)) or (v70 > (56 - 31)) or v13:BuffUp(v55.NetherPortalBuff))) or ((5611 - (1151 + 36)) < (27 + 0))) then
						if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or ((526 + 1471) > (11393 - 7578))) then
							return "call_dreadstalkers main 18";
						end
					end
					v123 = 1836 - (1552 + 280);
				end
				if (((4299 - (64 + 770)) > (1299 + 614)) and (v123 == (8 - 4))) then
					if (((131 + 602) < (3062 - (157 + 1086))) and v55.Implosion:IsReady() and (v80(3 - 1) > (0 - 0)) and v67 and not v13:PrevGCDP(1 - 0, v55.Implosion)) then
						if (v23(v55.Implosion, v50, nil, not v14:IsInRange(54 - 14)) or ((5214 - (599 + 220)) == (9468 - 4713))) then
							return "implosion main 20";
						end
					end
					if ((v55.SummonSoulkeeper:IsReady() and (v55.SummonSoulkeeper:Count() == (1941 - (1813 + 118))) and (v77 > (1 + 0))) or ((5010 - (841 + 376)) < (3318 - 949))) then
						if (v23(v55.SummonSoulkeeper) or ((949 + 3135) == (723 - 458))) then
							return "soul_strike main 22";
						end
					end
					if (((5217 - (464 + 395)) == (11184 - 6826)) and v55.DemonicStrength:IsCastable() and (((v63 > (31 + 32)) and not (v63 > (v55.SummonDemonicTyrant:CooldownRemains() + (906 - (467 + 370))))) or (v55.SummonDemonicTyrant:CooldownRemains() > (61 - 31)) or v13:BuffUp(v55.RiteofRuvaraadBuff) or v69 or not v55.SummonDemonicTyrant:IsAvailable() or not v55.GrimoireFelguard:IsAvailable() or not v13:HasTier(23 + 7, 6 - 4))) then
						if (v23(v55.DemonicStrength, v48) or ((490 + 2648) < (2309 - 1316))) then
							return "demonic_strength main 24";
						end
					end
					if (((3850 - (150 + 370)) > (3605 - (74 + 1208))) and v55.HandofGuldan:IsReady() and (((v72 > (4 - 2)) and (v55.CallDreadstalkers:CooldownRemains() > (v74 * (18 - 14))) and (v55.SummonDemonicTyrant:CooldownRemains() > (13 + 4))) or (v72 == (395 - (14 + 376))) or ((v72 == (6 - 2)) and v55.SoulStrike:IsAvailable() and (v55.SoulStrike:CooldownRemains() < (v74 * (2 + 0))))) and (v77 == (1 + 0)) and v55.GrandWarlocksDesign:IsAvailable()) then
						if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or ((3459 + 167) == (11688 - 7699))) then
							return "hand_of_guldan main 26";
						end
					end
					if ((v55.HandofGuldan:IsReady() and (v72 > (2 + 0)) and not ((v77 == (79 - (23 + 55))) and v55.GrandWarlocksDesign:IsAvailable())) or ((2170 - 1254) == (1783 + 888))) then
						if (((245 + 27) == (421 - 149)) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					v123 = 2 + 3;
				end
			end
		end
	end
	local function v103()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(1167 - (652 + 249), v102, v103);
end;
return v0["Epix_Warlock_Demonology.lua"]();

