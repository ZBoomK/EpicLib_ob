local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2688 + 724) > (439 + 380)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((10212 - 7050) <= (5180 - (404 + 1335))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 407 - (183 + 223);
		end
		if (((5726 - 1020) > (2935 + 1494)) and (v5 == (1 + 0))) then
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
		v33 = EpicSettings.Settings['UseTrinkets'];
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (337 - (10 + 327));
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UseHealthstone'] or (338 - (118 + 220));
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (449 - (108 + 341));
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v46 = EpicSettings.Settings['SummonPet'];
		v47 = EpicSettings.Settings['DarkPactHP'] or (1493 - (711 + 782));
		v48 = EpicSettings.Settings['DemonboltOpener'];
		v49 = EpicSettings.Settings["Use Guillotine"] or (0 - 0);
		v45 = EpicSettings.Settings['UnendingResolveHP'] or (469 - (270 + 199));
		v50 = EpicSettings.Settings['DemonicStrength'];
		v51 = EpicSettings.Settings['GrimoireFelguard'];
		v52 = EpicSettings.Settings['Implosion'];
		v53 = EpicSettings.Settings['NetherPortal'];
		v54 = EpicSettings.Settings['PowerSiphon'];
		v55 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
		v56 = EpicSettings.Settings['UseBurningRush'] or (1819 - (580 + 1239));
		v57 = EpicSettings.Settings['BurningRushHP'] or (0 - 0);
		v43 = EpicSettings.Settings['DrainLifeHP'] or (0 + 0);
		v44 = EpicSettings.Settings['HealthFunnelHP'] or (0 + 0);
		v45 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
	end
	local v59 = v18.Warlock.Demonology;
	local v60 = v19.Warlock.Demonology;
	local v61 = v20.Warlock.Demonology;
	local v62 = {v60.NymuesUnravelingSpindle:ID(),v60.TimeThiefsGambit:ID()};
	local v63 = v13:GetEquipment();
	local v64 = (v63[1180 - (645 + 522)] and v19(v63[1803 - (1010 + 780)])) or v19(0 + 0);
	local v65 = (v63[66 - 52] and v19(v63[41 - 27])) or v19(1836 - (1045 + 791));
	local v66 = 28124 - 17013;
	local v67 = 16965 - 5854;
	local v68 = (519 - (351 + 154)) + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
	local v69 = 1574 - (1281 + 293);
	local v70 = false;
	local v71 = false;
	local v72 = false;
	local v73 = 266 - (28 + 238);
	local v74 = 0 - 0;
	local v75 = 1559 - (1381 + 178);
	local v76 = 113 + 7;
	local v77 = 10 + 2;
	local v78 = 0 + 0;
	local v79 = 0 - 0;
	local v80 = 0 + 0;
	local v81;
	local v82, v83;
	v10:RegisterForEvent(function()
		v66 = 11581 - (381 + 89);
		v67 = 9854 + 1257;
	end, "PLAYER_REGEN_ENABLED");
	local v84 = v10.Commons.Everyone;
	local v85 = {{v59.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v124 = 1784 - (214 + 1570);
		while true do
			if (((4309 - (990 + 465)) < (1689 + 2406)) and ((1 + 0) == v124)) then
				v65 = (v63[14 + 0] and v19(v63[55 - 41])) or v19(1726 - (1668 + 58));
				break;
			end
			if ((v124 == (626 - (512 + 114))) or ((2758 - 1700) >= (2484 - 1282))) then
				v63 = v13:GetEquipment();
				v64 = (v63[45 - 32] and v19(v63[7 + 6])) or v19(0 + 0);
				v124 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v125 = 0 - 0;
		while true do
			if (((5705 - (109 + 1885)) > (4824 - (1269 + 200))) and (v125 == (0 - 0))) then
				v59.HandofGuldan:RegisterInFlight();
				v68 = (829 - (98 + 717)) + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v59.HandofGuldan:RegisterInFlight();
	local function v86()
		return v10.GuardiansTable.ImpCount or (826 - (802 + 24));
	end
	local function v87(v126)
		local v127 = 0 - 0;
		for v143, v144 in pairs(v10.GuardiansTable.Pets) do
			if ((v144.ImpCasts <= v126) or ((1144 - 238) >= (330 + 1899))) then
				v127 = v127 + 1 + 0;
			end
		end
		return v127;
	end
	local function v88()
		return v10.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v89()
		return v88() > (0 + 0);
	end
	local function v90()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 - 0);
	end
	local function v91()
		return v90() > (0 - 0);
	end
	local function v92()
		return v10.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v93()
		return v92() > (0 + 0);
	end
	local function v94()
		return v10.GuardiansTable.VilefiendDuration or (0 + 0);
	end
	local function v95()
		return v94() > (0 + 0);
	end
	local function v96()
		return v10.GuardiansTable.PitLordDuration or (0 + 0);
	end
	local function v97()
		return v96() > (1433 - (797 + 636));
	end
	local function v98(v128)
		return v128:DebuffDown(v59.DoomBrandDebuff) or (v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) <= (14 - 11)));
	end
	local function v99(v129)
		return (v129:DebuffDown(v59.DoomBrandDebuff)) or (v83 < (1623 - (1427 + 192)));
	end
	local function v100(v130)
		return (v130:DebuffRefreshable(v59.Doom));
	end
	local function v101(v131)
		return v131:DebuffRemains(v59.DoomBrandDebuff) > (4 + 6);
	end
	local function v102()
		local v132 = 0 - 0;
		while true do
			if (((1158 + 130) > (567 + 684)) and ((328 - (192 + 134)) == v132)) then
				if (v59.PowerSiphon:IsReady() or ((5789 - (316 + 960)) < (1866 + 1486))) then
					if (v23(v59.PowerSiphon, v54) or ((1594 + 471) >= (2955 + 241))) then
						return "power_siphon precombat 2";
					end
				end
				if ((v59.Demonbolt:IsReady() and v13:BuffDown(v59.DemonicCoreBuff)) or ((16729 - 12353) <= (2032 - (83 + 468)))) then
					if (v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt)) or ((5198 - (1202 + 604)) >= (22131 - 17390))) then
						return "demonbolt precombat 4";
					end
				end
				v132 = 4 - 1;
			end
			if (((9206 - 5881) >= (2479 - (45 + 280))) and (v132 == (3 + 0))) then
				if (v59.ShadowBolt:IsReady() or ((1132 + 163) >= (1181 + 2052))) then
					if (((2423 + 1954) > (289 + 1353)) and v23(v61.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((8745 - 4022) > (3267 - (340 + 1571))) and (v132 == (0 + 0))) then
				v77 = 1784 - (1733 + 39);
				v68 = (38 - 24) + v26(v59.GrimoireFelguard:IsAvailable()) + v26(v59.SummonVilefiend:IsAvailable());
				v132 = 1035 - (125 + 909);
			end
			if ((v132 == (1949 - (1096 + 852))) or ((1856 + 2280) <= (4901 - 1468))) then
				v73 = 0 + 0;
				v74 = 512 - (409 + 103);
				v132 = 238 - (46 + 190);
			end
		end
	end
	local function v103()
		local v133 = 95 - (51 + 44);
		local v134;
		while true do
			if (((1198 + 3047) <= (5948 - (1114 + 203))) and (v133 == (728 - (228 + 498)))) then
				if (((927 + 3349) >= (2163 + 1751)) and ((not v95() and v59.SummonVilefiend:IsAvailable()) or not v93())) then
					v69 = 663 - (174 + 489);
				end
				v70 = not v59.NetherPortal:IsAvailable() or (v59.NetherPortal:CooldownRemains() > (78 - 48)) or v13:BuffUp(v59.NetherPortalBuff);
				v134 = v26(v59.SacrificedSouls:IsAvailable());
				v133 = 1908 - (830 + 1075);
			end
			if (((722 - (303 + 221)) <= (5634 - (231 + 1038))) and ((1 + 0) == v133)) then
				if (((5944 - (171 + 991)) > (19270 - 14594)) and v95() and v93()) then
					v69 = v28(v94(), v92()) - (v13:GCD() * (0.5 - 0));
				end
				if (((12137 - 7273) > (1759 + 438)) and not v59.SummonVilefiend:IsAvailable() and v59.GrimoireFelguard:IsAvailable() and v93()) then
					v69 = v28(v92(), v88()) - (v13:GCD() * (0.5 - 0));
				end
				if ((not v59.SummonVilefiend:IsAvailable() and (not v59.GrimoireFelguard:IsAvailable() or not v13:HasTier(86 - 56, 2 - 0)) and v93()) or ((11437 - 7737) == (3755 - (111 + 1137)))) then
					v69 = v92() - (v13:GCD() * (158.5 - (91 + 67)));
				end
				v133 = 5 - 3;
			end
			if (((1117 + 3357) >= (797 - (423 + 100))) and (v133 == (0 + 0))) then
				if ((((v13:BuffUp(v59.NetherPortalBuff) and (v13:BuffRemains(v59.NetherPortalBuff) < (7 - 4)) and v59.NetherPortal:IsAvailable()) or (v67 < (11 + 9)) or (v91() and (v67 < (871 - (326 + 445)))) or (v67 < (109 - 84)) or v91() or (not v59.SummonDemonicTyrant:IsAvailable() and v93())) and (v75 <= (0 - 0))) or ((4420 - 2526) <= (2117 - (530 + 181)))) then
					v74 = (1001 - (614 + 267)) + v79;
				end
				v75 = v74 - v79;
				if (((1604 - (19 + 13)) >= (2491 - 960)) and (((((v67 + v79) % (279 - 159)) <= (242 - 157)) and (((v67 + v79) % (32 + 88)) >= (43 - 18))) or (v79 >= (435 - 225))) and (v75 > (1812 - (1293 + 519))) and not v59.GrandWarlocksDesign:IsAvailable()) then
					v76 = v75;
				else
					v76 = v59.SummonDemonicTyrant:CooldownRemains();
				end
				v133 = 1 - 0;
			end
			if ((v133 == (7 - 4)) or ((8962 - 4275) < (19585 - 15043))) then
				if (((7752 - 4461) > (883 + 784)) and (v83 > (1 + 0 + v134))) then
					v71 = not v91();
				end
				if (((v83 > ((4 - 2) + v134)) and (v83 < (2 + 3 + v134))) or ((291 + 582) == (1272 + 762))) then
					v71 = v90() < (1102 - (709 + 387));
				end
				if ((v83 > ((1862 - (673 + 1185)) + v134)) or ((8166 - 5350) < (35 - 24))) then
					v71 = v90() < (12 - 4);
				end
				v133 = 3 + 1;
			end
			if (((2764 + 935) < (6353 - 1647)) and (v133 == (1 + 3))) then
				v72 = (v59.SummonDemonicTyrant:CooldownRemains() < (39 - 19)) and (v76 < (39 - 19)) and ((v13:BuffStack(v59.DemonicCoreBuff) <= (1882 - (446 + 1434))) or v13:BuffDown(v59.DemonicCoreBuff)) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (1288 - (1040 + 243)))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (14 - 9)));
				break;
			end
		end
	end
	local function v104()
		local v135 = 1847 - (559 + 1288);
		local v136;
		while true do
			if (((4577 - (609 + 1322)) >= (1330 - (13 + 441))) and (v135 == (0 - 0))) then
				v136 = v84.HandleTopTrinket(v62, v31, 104 - 64, nil);
				if (((3057 - 2443) <= (119 + 3065)) and v136) then
					return v136;
				end
				v135 = 3 - 2;
			end
			if (((1111 + 2015) == (1370 + 1756)) and (v135 == (2 - 1))) then
				v136 = v84.HandleBottomTrinket(v62, v31, 22 + 18, nil);
				if (v136 or ((4022 - 1835) >= (3276 + 1678))) then
					return v136;
				end
				break;
			end
		end
	end
	local function v105()
		if ((v60.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v59.DemonicPowerBuff) or (not v59.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v59.NetherPortalBuff) or not v59.NetherPortal:IsAvailable())))) or ((2157 + 1720) == (2569 + 1006))) then
			if (((594 + 113) > (619 + 13)) and v24(v61.TimebreachingTalon)) then
				return "timebreaching_talon items 2";
			end
		end
		if (not v59.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v59.DemonicPowerBuff) or ((979 - (153 + 280)) >= (7750 - 5066))) then
			local v146 = v104();
			if (((1316 + 149) <= (1699 + 2602)) and v146) then
				return v146;
			end
		end
	end
	local function v106()
		local v137 = 0 + 0;
		while true do
			if (((1547 + 157) > (1033 + 392)) and (v137 == (1 - 0))) then
				if (v59.Fireblood:IsCastable() or ((425 + 262) == (4901 - (89 + 578)))) then
					if (v24(v59.Fireblood, v32) or ((2379 + 951) < (2970 - 1541))) then
						return "fireblood ogcd 8";
					end
				end
				if (((2196 - (572 + 477)) >= (46 + 289)) and v59.AncestralCall:IsCastable()) then
					if (((2062 + 1373) > (251 + 1846)) and v23(v59.AncestralCall, v32)) then
						return "ancestral_call racials 8";
					end
				end
				break;
			end
			if ((v137 == (86 - (84 + 2))) or ((6213 - 2443) >= (2912 + 1129))) then
				if (v59.Berserking:IsCastable() or ((4633 - (497 + 345)) <= (42 + 1569))) then
					if (v24(v59.Berserking, v32) or ((774 + 3804) <= (3341 - (605 + 728)))) then
						return "berserking ogcd 4";
					end
				end
				if (((803 + 322) <= (4615 - 2539)) and v59.BloodFury:IsCastable()) then
					if (v24(v59.BloodFury, v32) or ((35 + 708) >= (16264 - 11865))) then
						return "blood_fury ogcd 6";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v107()
		local v138 = 0 - 0;
		while true do
			if (((873 + 282) < (2162 - (457 + 32))) and (v138 == (1 + 0))) then
				if ((v59.Implosion:IsReady() and (v86() > (1404 - (832 + 570))) and not v93() and not v89() and not v95() and ((v83 > (3 + 0)) or ((v83 > (1 + 1)) and v59.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(3 - 2, v59.Implosion)) or ((1120 + 1204) <= (1374 - (588 + 208)))) then
					if (((10152 - 6385) == (5567 - (884 + 916))) and v23(v59.Implosion, v52, nil, not v14:IsInRange(83 - 43))) then
						return "implosion tyrant 8";
					end
				end
				if (((2371 + 1718) == (4742 - (232 + 421))) and v59.ShadowBolt:IsReady() and v13:PrevGCDP(1890 - (1569 + 320), v59.GrimoireFelguard) and (v79 > (8 + 22)) and v13:BuffDown(v59.NetherPortalBuff) and v13:BuffDown(v59.DemonicCoreBuff)) then
					if (((847 + 3611) >= (5640 - 3966)) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if (((1577 - (316 + 289)) <= (3711 - 2293)) and v59.PowerSiphon:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) < (1 + 3)) and (not v95() or (not v59.SummonVilefiend:IsAvailable() and v92())) and v13:BuffDown(v59.NetherPortalBuff)) then
					if (v23(v59.PowerSiphon, v54) or ((6391 - (666 + 787)) < (5187 - (360 + 65)))) then
						return "power_siphon tyrant 12";
					end
				end
				if ((v59.ShadowBolt:IsReady() and not v95() and v13:BuffDown(v59.NetherPortalBuff) and not v93() and (v78 < ((5 + 0) - v13:BuffStack(v59.DemonicCoreBuff)))) or ((2758 - (79 + 175)) > (6722 - 2458))) then
					if (((1681 + 472) == (6599 - 4446)) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v138 = 3 - 1;
			end
			if ((v138 == (901 - (503 + 396))) or ((688 - (92 + 89)) >= (5026 - 2435))) then
				if (((2299 + 2182) == (2653 + 1828)) and v59.NetherPortal:IsReady() and (v78 == (19 - 14))) then
					if (v23(v59.NetherPortal, v53) or ((319 + 2009) < (1579 - 886))) then
						return "nether_portal tyrant 16";
					end
				end
				if (((3777 + 551) == (2068 + 2260)) and v59.SummonVilefiend:IsReady() and ((v78 == (15 - 10)) or v13:BuffUp(v59.NetherPortalBuff)) and (v59.SummonDemonicTyrant:CooldownRemains() < (2 + 11)) and v70) then
					if (((2421 - 833) >= (2576 - (485 + 759))) and v23(v59.SummonVilefiend)) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v59.CallDreadstalkers:IsReady() and (v95() or (not v59.SummonVilefiend:IsAvailable() and (not v59.NetherPortal:IsAvailable() or v13:BuffUp(v59.NetherPortalBuff) or (v59.NetherPortal:CooldownRemains() > (69 - 39))) and (v13:BuffUp(v59.NetherPortalBuff) or v89() or (v78 == (1194 - (442 + 747)))))) and (v59.SummonDemonicTyrant:CooldownRemains() < (1146 - (832 + 303))) and v70) or ((5120 - (88 + 858)) > (1295 + 2953))) then
					if (v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers)) or ((3796 + 790) <= (4 + 78))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if (((4652 - (766 + 23)) == (19070 - 15207)) and v59.GrimoireFelguard:IsReady() and (v95() or (not v59.SummonVilefiend:IsAvailable() and (not v59.NetherPortal:IsAvailable() or v13:BuffUp(v59.NetherPortalBuff) or (v59.NetherPortal:CooldownRemains() > (41 - 11))) and (v13:BuffUp(v59.NetherPortalBuff) or v93() or (v78 == (13 - 8))) and v70))) then
					if (v23(v59.GrimoireFelguard, v51) or ((956 - 674) <= (1115 - (1036 + 37)))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v138 = 3 + 0;
			end
			if (((8975 - 4366) >= (603 + 163)) and (v138 == (1483 - (641 + 839)))) then
				if ((v59.HandofGuldan:IsReady() and (((v78 > (915 - (910 + 3))) and (v95() or (not v59.SummonVilefiend:IsAvailable() and v93())) and ((v78 > (4 - 2)) or (v94() < ((v80 * (1686 - (1466 + 218))) + ((1 + 1) / v13:SpellHaste()))))) or (not v93() and (v78 == (1153 - (556 + 592)))))) or ((410 + 742) == (3296 - (329 + 479)))) then
					if (((4276 - (174 + 680)) > (11511 - 8161)) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((1817 - 940) > (269 + 107)) and v59.Demonbolt:IsReady() and (v78 < (743 - (396 + 343))) and (v13:BuffStack(v59.DemonicCoreBuff) > (1 + 0)) and (v95() or (not v59.SummonVilefiend:IsAvailable() and v93()))) then
					if (v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt)) or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
						return "demonbolt tyrant 26";
					end
				end
				if ((v59.PowerSiphon:IsReady() and (((v13:BuffStack(v59.DemonicCoreBuff) < (11 - 8)) and (v69 > (v59.SummonDemonicTyrant:ExecuteTime() + (v80 * (13 - 10))))) or (v69 == (0 + 0)))) or ((1692 - (389 + 1138)) >= (4066 - (102 + 472)))) then
					if (((3727 + 222) < (2693 + 2163)) and v23(v59.PowerSiphon, v54)) then
						return "power_siphon tyrant 28";
					end
				end
				if (v59.ShadowBolt:IsCastable() or ((3988 + 288) < (4561 - (320 + 1225)))) then
					if (((8349 - 3659) > (2524 + 1601)) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if ((v138 == (1464 - (157 + 1307))) or ((1909 - (821 + 1038)) >= (2235 - 1339))) then
				if (((v69 > (0 + 0)) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80)) and (v74 <= (0 - 0))) or ((638 + 1076) >= (7331 - 4373))) then
					v74 = (1146 - (834 + 192)) + v79;
				end
				if ((v59.HandofGuldan:IsReady() and (v78 > (0 + 0)) and (v69 > (v80 + v59.SummonDemonicTyrant:CastTime())) and (v69 < (v80 * (2 + 2)))) or ((33 + 1458) < (997 - 353))) then
					if (((1008 - (300 + 4)) < (264 + 723)) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((9732 - 6014) > (2268 - (112 + 250))) and (v69 > (0 + 0)) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80))) then
					local v159 = 0 - 0;
					local v160;
					local v161;
					while true do
						if ((v159 == (1 + 0)) or ((496 + 462) > (2719 + 916))) then
							v160 = v106();
							if (((1736 + 1765) <= (3338 + 1154)) and v160) then
								return v160;
							end
							v159 = 1416 - (1001 + 413);
						end
						if ((v159 == (0 - 0)) or ((4324 - (244 + 638)) < (3241 - (627 + 66)))) then
							v160 = v105();
							if (((8566 - 5691) >= (2066 - (512 + 90))) and v160) then
								return v160;
							end
							v159 = 1907 - (1665 + 241);
						end
						if ((v159 == (719 - (373 + 344))) or ((2164 + 2633) >= (1295 + 3598))) then
							v161 = v84.HandleDPSPotion();
							if (v161 or ((1453 - 902) > (3499 - 1431))) then
								return v161;
							end
							break;
						end
					end
				end
				if (((3213 - (35 + 1064)) > (687 + 257)) and v59.SummonDemonicTyrant:IsCastable() and (v69 > (0 - 0)) and (v69 < (v59.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v59.DemonicCoreBuff)) * v59.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v59.DemonicCoreBuff)) * v80) + v80))) then
					if (v24(v59.SummonDemonicTyrant, nil, nil, v55) or ((10 + 2252) >= (4332 - (298 + 938)))) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v138 = 1260 - (233 + 1026);
			end
		end
	end
	local function v108()
		local v139 = 1666 - (636 + 1030);
		while true do
			if ((v139 == (0 + 0)) or ((2203 + 52) >= (1051 + 2486))) then
				if ((v59.SummonDemonicTyrant:IsCastable() and (v67 < (2 + 18))) or ((4058 - (55 + 166)) < (254 + 1052))) then
					if (((297 + 2653) == (11266 - 8316)) and v24(v59.SummonDemonicTyrant, nil, nil, v55)) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v67 < (317 - (36 + 261))) or ((8259 - 3536) < (4666 - (34 + 1334)))) then
					local v162 = 0 + 0;
					while true do
						if (((883 + 253) >= (1437 - (1035 + 248))) and (v162 == (22 - (20 + 1)))) then
							if (v59.SummonVilefiend:IsReady() or ((142 + 129) > (5067 - (134 + 185)))) then
								if (((5873 - (549 + 584)) >= (3837 - (314 + 371))) and v23(v59.SummonVilefiend)) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
						if ((v162 == (0 - 0)) or ((3546 - (478 + 490)) >= (1796 + 1594))) then
							if (((1213 - (786 + 386)) <= (5379 - 3718)) and v59.GrimoireFelguard:IsReady()) then
								if (((1980 - (1055 + 324)) < (4900 - (1093 + 247))) and v23(v59.GrimoireFelguard, v51)) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((209 + 26) < (73 + 614)) and v59.CallDreadstalkers:IsReady()) then
								if (((18060 - 13511) > (3912 - 2759)) and v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v162 = 2 - 1;
						end
					end
				end
				v139 = 2 - 1;
			end
			if ((v139 == (1 + 1)) or ((18006 - 13332) < (16103 - 11431))) then
				if (((2766 + 902) < (11664 - 7103)) and v59.PowerSiphon:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) < (691 - (364 + 324))) and (v67 < (54 - 34))) then
					if (v23(v59.PowerSiphon, v54) or ((1091 - 636) == (1195 + 2410))) then
						return "power_siphon fight_end 14";
					end
				end
				if ((v59.Implosion:IsReady() and (v67 < ((8 - 6) * v80))) or ((4264 - 1601) == (10058 - 6746))) then
					if (((5545 - (1249 + 19)) <= (4040 + 435)) and v23(v59.Implosion, v52, nil, not v14:IsInRange(155 - 115))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if ((v139 == (1087 - (686 + 400))) or ((683 + 187) == (1418 - (73 + 156)))) then
				if (((8 + 1545) <= (3944 - (721 + 90))) and v59.NetherPortal:IsReady() and (v67 < (1 + 29))) then
					if (v23(v59.NetherPortal, v53) or ((7263 - 5026) >= (3981 - (224 + 246)))) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v59.DemonicStrength:IsCastable() and (v67 < (16 - 6))) or ((2437 - 1113) > (548 + 2472))) then
					if (v23(v59.DemonicStrength, v50) or ((72 + 2920) == (1382 + 499))) then
						return "demonic_strength fight_end 12";
					end
				end
				v139 = 3 - 1;
			end
		end
	end
	local v109 = 0 - 0;
	local v110 = false;
	function UpdateLastMoveTime()
		if (((3619 - (203 + 310)) > (3519 - (1238 + 755))) and v13:IsMoving()) then
			if (((212 + 2811) < (5404 - (709 + 825))) and not v110) then
				v109 = GetTime();
				v110 = true;
			end
		else
			v110 = false;
		end
	end
	local function v111()
		if (((262 - 119) > (107 - 33)) and v13:AffectingCombat()) then
			if (((882 - (196 + 668)) < (8338 - 6226)) and (v13:HealthPercentage() <= v47) and v59.DarkPact:IsCastable() and not v13:BuffUp(v59.DarkPact)) then
				if (((2272 - 1175) <= (2461 - (171 + 662))) and v24(v59.DarkPact)) then
					return "dark_pact defensive 2";
				end
			end
			if (((4723 - (4 + 89)) == (16228 - 11598)) and (v13:HealthPercentage() <= v43) and v59.DrainLife:IsCastable()) then
				if (((1290 + 2250) > (11784 - 9101)) and v24(v59.DrainLife)) then
					return "drain_life defensive 2";
				end
			end
			if (((1880 + 2914) >= (4761 - (35 + 1451))) and (v13:HealthPercentage() <= v44) and v59.HealthFunnel:IsCastable()) then
				if (((2937 - (28 + 1425)) == (3477 - (941 + 1052))) and v24(v59.HealthFunnel)) then
					return "health_funnel defensive 2";
				end
			end
			if (((1374 + 58) < (5069 - (822 + 692))) and (v13:HealthPercentage() <= v45) and v59.UnendingResolve:IsCastable()) then
				if (v24(v59.UnendingResolve) or ((1519 - 454) > (1686 + 1892))) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v112()
		v58();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (v30 or ((5092 - (45 + 252)) < (1393 + 14))) then
			v82 = v14:GetEnemiesInSplashRange(3 + 5);
			v83 = v14:GetEnemiesInSplashRangeCount(19 - 11);
			v81 = v13:GetEnemiesInRange(473 - (114 + 319));
		else
			v82 = {};
			v83 = 1 - 0;
			v81 = {};
		end
		UpdateLastMoveTime();
		if (((2373 - 520) < (3069 + 1744)) and (v84.TargetIsValid() or v13:AffectingCombat())) then
			local v147 = 0 - 0;
			while true do
				if ((v147 == (3 - 1)) or ((4784 - (556 + 1407)) < (3637 - (741 + 465)))) then
					v25.UpdateSoulShards();
					v79 = v10.CombatTime();
					v147 = 468 - (170 + 295);
				end
				if ((v147 == (1 + 0)) or ((2640 + 234) < (5369 - 3188))) then
					if ((v67 == (9211 + 1900)) or ((1725 + 964) <= (195 + 148))) then
						v67 = v10.FightRemains(v82, false);
					end
					v25.UpdatePetTable();
					v147 = 1232 - (957 + 273);
				end
				if (((1 + 2) == v147) or ((749 + 1120) == (7655 - 5646))) then
					v78 = v13:SoulShardsP();
					v80 = v13:GCD() + (0.25 - 0);
					break;
				end
				if ((v147 == (0 - 0)) or ((17558 - 14012) < (4102 - (389 + 1391)))) then
					v66 = v10.BossFightRemains();
					v67 = v66;
					v147 = 1 + 0;
				end
			end
		end
		if ((v59.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v46 and not v17:IsActive()) or ((217 + 1865) == (10866 - 6093))) then
			if (((4195 - (783 + 168)) > (3540 - 2485)) and v24(v59.SummonPet, false, true)) then
				return "summon_pet ooc";
			end
		end
		if ((v60.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) or ((3259 + 54) <= (2089 - (309 + 2)))) then
			if (v24(v61.Healthstone) or ((4363 - 2942) >= (3316 - (1090 + 122)))) then
				return "healthstone defensive 3";
			end
		end
		if (((588 + 1224) <= (10911 - 7662)) and v34 and (v13:HealthPercentage() <= v36)) then
			local v148 = 0 + 0;
			while true do
				if (((2741 - (628 + 490)) <= (351 + 1606)) and (v148 == (0 - 0))) then
					if (((20162 - 15750) == (5186 - (431 + 343))) and (v35 == "Refreshing Healing Potion")) then
						if (((3534 - 1784) >= (2435 - 1593)) and v60.RefreshingHealingPotion:IsReady()) then
							if (((3454 + 918) > (237 + 1613)) and v24(v61.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1927 - (556 + 1139)) < (836 - (6 + 9))) and (v35 == "Dreamwalker's Healing Potion")) then
						if (((95 + 423) < (463 + 439)) and v60.DreamwalkersHealingPotion:IsReady()) then
							if (((3163 - (28 + 141)) > (333 + 525)) and v24(v61.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (v84.TargetIsValid() or ((4635 - 880) <= (649 + 266))) then
			if (((5263 - (486 + 831)) > (9739 - 5996)) and not v13:AffectingCombat() and v29 and not v13:IsCasting(v59.Demonbolt)) then
				local v150 = 0 - 0;
				local v151;
				while true do
					if (((0 + 0) == v150) or ((4221 - 2886) >= (4569 - (668 + 595)))) then
						v151 = v102();
						if (((4359 + 485) > (455 + 1798)) and v151) then
							return v151;
						end
						break;
					end
				end
			end
			if (((1232 - 780) == (742 - (23 + 267))) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v152 = v84.Interrupt(v59.SpellLock, 1984 - (1129 + 815), true);
				if (v152 or ((4944 - (371 + 16)) < (3837 - (1326 + 424)))) then
					return v152;
				end
				v152 = v84.Interrupt(v59.SpellLock, 75 - 35, true, v16, v61.SpellLockMouseover);
				if (((14156 - 10282) == (3992 - (88 + 30))) and v152) then
					return v152;
				end
				v152 = v84.Interrupt(v59.AxeToss, 811 - (720 + 51), true);
				if (v152 or ((4310 - 2372) > (6711 - (421 + 1355)))) then
					return v152;
				end
				v152 = v84.Interrupt(v59.AxeToss, 65 - 25, true, v16, v61.AxeTossMouseover);
				if (v152 or ((2091 + 2164) < (4506 - (286 + 797)))) then
					return v152;
				end
				v152 = v84.InterruptWithStun(v59.AxeToss, 146 - 106, true);
				if (((2408 - 954) <= (2930 - (397 + 42))) and v152) then
					return v152;
				end
				v152 = v84.InterruptWithStun(v59.AxeToss, 13 + 27, true, v16, v61.AxeTossMouseover);
				if (v152 or ((4957 - (24 + 776)) <= (4318 - 1515))) then
					return v152;
				end
			end
			if (((5638 - (222 + 563)) >= (6569 - 3587)) and v13:AffectingCombat() and v56) then
				if (((2977 + 1157) > (3547 - (23 + 167))) and v59.BurningRush:IsCastable() and not v13:BuffUp(v59.BurningRush) and v110 and ((GetTime() - v109) >= (1799 - (690 + 1108))) and (v13:HealthPercentage() >= v57)) then
					if (v24(v59.BurningRush) or ((1233 + 2184) < (2091 + 443))) then
						return "burning_rush defensive 2";
					end
				elseif ((v59.BurningRush:IsCastable() and v13:BuffUp(v59.BurningRush) and (not v110 or (v13:HealthPercentage() <= v57))) or ((3570 - (40 + 808)) <= (28 + 136))) then
					if (v24(v61.CancelBurningRush) or ((9208 - 6800) < (2016 + 93))) then
						return "burning_rush defensive 4";
					end
				end
			end
			local v149 = v111();
			if (v149 or ((18 + 15) == (798 + 657))) then
				return v149;
			end
			if ((v59.UnendingResolve:IsReady() and (v13:HealthPercentage() < v45)) or ((1014 - (47 + 524)) >= (2606 + 1409))) then
				if (((9244 - 5862) > (247 - 81)) and v24(v59.UnendingResolve, nil, nil, true)) then
					return "unending_resolve defensive";
				end
			end
			v103();
			if (v91() or (v67 < (49 - 27)) or ((2006 - (1165 + 561)) == (91 + 2968))) then
				local v153 = 0 - 0;
				local v154;
				while true do
					if (((718 + 1163) > (1772 - (341 + 138))) and (v153 == (0 + 0))) then
						v154 = v106();
						if (((4863 - 2506) == (2683 - (89 + 237))) and v154 and v32 and v31) then
							return v154;
						end
						break;
					end
				end
			end
			local v149 = v105();
			if (((395 - 272) == (258 - 135)) and v149) then
				return v149;
			end
			if ((v67 < (911 - (581 + 300))) or ((2276 - (855 + 365)) >= (8056 - 4664))) then
				local v155 = v108();
				if (v155 or ((353 + 728) < (2310 - (1030 + 205)))) then
					return v155;
				end
			end
			if ((v59.HandofGuldan:IsReady() and (v79 < (0.5 + 0)) and (((v67 % (89 + 6)) > (326 - (156 + 130))) or ((v67 % (215 - 120)) < (25 - 10))) and (v59.ReignofTyranny:IsAvailable() or (v83 > (3 - 1)))) or ((277 + 772) >= (2585 + 1847))) then
				if (v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan)) or ((4837 - (10 + 59)) <= (240 + 606))) then
					return "hand_of_guldan main 2";
				end
			end
			if (((v59.SummonDemonicTyrant:CooldownRemains() < (73 - 58)) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (1168 - (671 + 492)))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (4 + 1))) and ((v59.GrimoireFelguard:CooldownRemains() < (1225 - (369 + 846))) or not v13:HasTier(8 + 22, 2 + 0)) and ((v76 < (1960 - (1036 + 909))) or (v67 < (32 + 8)) or v13:PowerInfusionUp())) or (v59.SummonVilefiend:IsAvailable() and (v59.SummonDemonicTyrant:CooldownRemains() < (25 - 10)) and (v59.SummonVilefiend:CooldownRemains() < (v80 * (208 - (11 + 192)))) and (v59.CallDreadstalkers:CooldownRemains() < (v80 * (3 + 2))) and ((v59.GrimoireFelguard:CooldownRemains() < (185 - (135 + 40))) or not v13:HasTier(72 - 42, 2 + 0)) and ((v76 < (32 - 17)) or (v67 < (59 - 19)) or v13:PowerInfusionUp())) or ((3534 - (50 + 126)) <= (3954 - 2534))) then
				local v156 = 0 + 0;
				local v157;
				while true do
					if ((v156 == (1413 - (1233 + 180))) or ((4708 - (522 + 447)) <= (4426 - (107 + 1314)))) then
						v157 = v107();
						if (v157 or ((770 + 889) >= (6502 - 4368))) then
							return v157;
						end
						break;
					end
				end
			end
			if (((v59.SummonDemonicTyrant:CooldownRemains() < (7 + 8)) and (v95() or (not v59.SummonVilefiend:IsAvailable() and (v89() or v59.GrimoireFelguard:CooldownUp() or not v13:HasTier(59 - 29, 7 - 5)))) and ((v76 < (1925 - (716 + 1194))) or v89() or (v67 < (1 + 39)) or v13:PowerInfusionUp())) or ((350 + 2910) < (2858 - (74 + 429)))) then
				local v158 = v107();
				if (v158 or ((1289 - 620) == (2094 + 2129))) then
					return v158;
				end
			end
			if ((v59.SummonDemonicTyrant:IsCastable() and (v95() or v89() or (v59.GrimoireFelguard:CooldownRemains() > (206 - 116)))) or ((1198 + 494) < (1812 - 1224))) then
				if (v23(v59.SummonDemonicTyrant, v55, nil, nil) or ((11860 - 7063) < (4084 - (279 + 154)))) then
					return "summon_demonic_tyrant main 4";
				end
			end
			if ((v59.SummonVilefiend:IsReady() and (v59.SummonDemonicTyrant:CooldownRemains() > (823 - (454 + 324)))) or ((3287 + 890) > (4867 - (12 + 5)))) then
				if (v23(v59.SummonVilefiend) or ((216 + 184) > (2830 - 1719))) then
					return "summon_vilefiend main 6";
				end
			end
			if (((1128 + 1923) > (2098 - (277 + 816))) and v59.Demonbolt:IsReady() and v13:BuffUp(v59.DemonicCoreBuff) and (((not v59.SoulStrike:IsAvailable() or (v59.SoulStrike:CooldownRemains() > (v80 * (8 - 6)))) and (v78 < (1187 - (1058 + 125)))) or (v78 < ((1 + 3) - (v26(v83 > (977 - (815 + 160))))))) and not v13:PrevGCDP(4 - 3, v59.Demonbolt) and v13:HasTier(73 - 42, 1 + 1)) then
				if (((10795 - 7102) <= (6280 - (41 + 1857))) and v84.CastCycle(v59.Demonbolt, v82, v98, not v14:IsSpellInRange(v59.Demonbolt))) then
					return "demonbolt main 8";
				end
			end
			if ((v59.PowerSiphon:IsReady() and v13:BuffDown(v59.DemonicCoreBuff) and (v14:DebuffDown(v59.DoomBrandDebuff) or (not v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) < (v80 + v59.Demonbolt:TravelTime()))) or (v59.HandofGuldan:InFlight() and (v14:DebuffRemains(v59.DoomBrandDebuff) < (v80 + v59.Demonbolt:TravelTime() + (1896 - (1222 + 671)))))) and v13:HasTier(80 - 49, 2 - 0)) or ((4464 - (229 + 953)) > (5874 - (1111 + 663)))) then
				if (v23(v59.PowerSiphon, v54) or ((5159 - (874 + 705)) < (399 + 2445))) then
					return "power_siphon main 10";
				end
			end
			if (((61 + 28) < (9333 - 4843)) and v59.DemonicStrength:IsCastable() and (v13:BuffRemains(v59.NetherPortalBuff) < v80)) then
				if (v23(v59.DemonicStrength, v50) or ((141 + 4842) < (2487 - (642 + 37)))) then
					return "demonic_strength main 12";
				end
			end
			if (((874 + 2955) > (603 + 3166)) and v59.BilescourgeBombers:IsReady() and v59.BilescourgeBombers:IsCastable()) then
				if (((3728 - 2243) <= (3358 - (233 + 221))) and v23(v59.BilescourgeBombers, nil, nil, not v14:IsInRange(92 - 52))) then
					return "bilescourge_bombers main 14";
				end
			end
			if (((3758 + 511) == (5810 - (718 + 823))) and v59.Guillotine:IsCastable() and v49 and (v13:BuffRemains(v59.NetherPortalBuff) < v80) and (v59.DemonicStrength:CooldownDown() or not v59.DemonicStrength:IsAvailable())) then
				if (((244 + 143) <= (3587 - (266 + 539))) and v23(v61.GuillotineCursor, nil, nil, not v14:IsInRange(113 - 73))) then
					return "guillotine main 16";
				end
			end
			if ((v59.CallDreadstalkers:IsReady() and ((v59.SummonDemonicTyrant:CooldownRemains() > (1250 - (636 + 589))) or (v76 > (59 - 34)) or v13:BuffUp(v59.NetherPortalBuff))) or ((3916 - 2017) <= (727 + 190))) then
				if (v23(v59.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v59.CallDreadstalkers)) or ((1567 + 2745) <= (1891 - (657 + 358)))) then
					return "call_dreadstalkers main 18";
				end
			end
			if (((5909 - 3677) <= (5914 - 3318)) and v59.Implosion:IsReady() and (v87(1189 - (1151 + 36)) > (0 + 0)) and v71 and not v13:PrevGCDP(1 + 0, v59.Implosion)) then
				if (((6256 - 4161) < (5518 - (1552 + 280))) and v23(v59.Implosion, v52, nil, not v14:IsInRange(874 - (64 + 770)))) then
					return "implosion main 20";
				end
			end
			if ((v59.SummonSoulkeeper:IsReady() and (v59.SummonSoulkeeper:Count() == (7 + 3)) and (v83 > (2 - 1))) or ((284 + 1311) >= (5717 - (157 + 1086)))) then
				if (v23(v59.SummonSoulkeeper) or ((9244 - 4625) < (12622 - 9740))) then
					return "soul_strike main 22";
				end
			end
			if ((v59.HandofGuldan:IsReady() and (((v78 > (2 - 0)) and (v59.CallDreadstalkers:CooldownRemains() > (v80 * (5 - 1))) and (v59.SummonDemonicTyrant:CooldownRemains() > (836 - (599 + 220)))) or (v78 == (9 - 4)) or ((v78 == (1935 - (1813 + 118))) and v59.SoulStrike:IsAvailable() and (v59.SoulStrike:CooldownRemains() < (v80 * (2 + 0))))) and (v83 == (1218 - (841 + 376))) and v59.GrandWarlocksDesign:IsAvailable()) or ((411 - 117) >= (1123 + 3708))) then
				if (((5538 - 3509) <= (3943 - (464 + 395))) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
					return "hand_of_guldan main 26";
				end
			end
			if ((v59.HandofGuldan:IsReady() and (v78 > (5 - 3)) and not ((v83 == (1 + 0)) and v59.GrandWarlocksDesign:IsAvailable())) or ((2874 - (467 + 370)) == (5001 - 2581))) then
				if (((3273 + 1185) > (13382 - 9478)) and v23(v59.HandofGuldan, nil, nil, not v14:IsSpellInRange(v59.HandofGuldan))) then
					return "hand_of_guldan main 28";
				end
			end
			if (((69 + 367) >= (285 - 162)) and v59.Demonbolt:IsReady() and (v13:BuffStack(v59.DemonicCoreBuff) > (521 - (150 + 370))) and (((v78 < (1286 - (74 + 1208))) and not v59.SoulStrike:IsAvailable()) or (v59.SoulStrike:CooldownRemains() > (v80 * (4 - 2))) or (v78 < (9 - 7))) and not v72) then
				if (((356 + 144) < (2206 - (14 + 376))) and v84.CastCycle(v59.Demonbolt, v82, v99, not v14:IsSpellInRange(v59.Demonbolt))) then
					return "demonbolt main 30";
				end
			end
			if (((6198 - 2624) == (2313 + 1261)) and v59.Demonbolt:IsReady() and v13:HasTier(28 + 3, 2 + 0) and v13:BuffUp(v59.DemonicCoreBuff) and (v78 < (11 - 7)) and not v72) then
				if (((167 + 54) < (468 - (23 + 55))) and v84.CastTargetIf(v59.Demonbolt, v82, "==", v99, v101, not v14:IsSpellInRange(v59.Demonbolt))) then
					return "demonbolt main 32";
				end
			end
			if ((v59.Demonbolt:IsReady() and (v67 < (v13:BuffStack(v59.DemonicCoreBuff) * v80))) or ((5244 - 3031) <= (949 + 472))) then
				if (((2747 + 311) < (7535 - 2675)) and v23(v59.Demonbolt, nil, nil, not v14:IsSpellInRange(v59.Demonbolt))) then
					return "demonbolt main 34";
				end
			end
			if ((v59.Demonbolt:IsReady() and v13:BuffUp(v59.DemonicCoreBuff) and (v59.PowerSiphon:CooldownRemains() < (2 + 2)) and (v78 < (905 - (652 + 249))) and not v72) or ((3468 - 2172) >= (6314 - (708 + 1160)))) then
				if (v84.CastCycle(v59.Demonbolt, v82, v99, not v14:IsSpellInRange(v59.Demonbolt)) or ((3781 - 2388) > (8183 - 3694))) then
					return "demonbolt main 36";
				end
			end
			if ((v59.PowerSiphon:IsReady() and (v13:BuffDown(v59.DemonicCoreBuff))) or ((4451 - (10 + 17)) < (7 + 20))) then
				if (v23(v59.PowerSiphon, v54) or ((3729 - (1400 + 332)) > (7317 - 3502))) then
					return "power_siphon main 38";
				end
			end
			if (((5373 - (242 + 1666)) > (819 + 1094)) and v59.SummonVilefiend:IsReady() and (v67 < (v59.SummonDemonicTyrant:CooldownRemains() + 2 + 3))) then
				if (((625 + 108) < (2759 - (850 + 90))) and v23(v59.SummonVilefiend)) then
					return "summon_vilefiend main 40";
				end
			end
			if (v59.Doom:IsReady() or ((7697 - 3302) == (6145 - (360 + 1030)))) then
				if (v84.CastCycle(v59.Doom, v81, v100, not v14:IsSpellInRange(v59.Doom)) or ((3357 + 436) < (6686 - 4317))) then
					return "doom main 42";
				end
			end
			if (v59.ShadowBolt:IsCastable() or ((5618 - 1534) == (1926 - (909 + 752)))) then
				if (((5581 - (109 + 1114)) == (7978 - 3620)) and v23(v59.ShadowBolt, nil, nil, not v14:IsSpellInRange(v59.ShadowBolt))) then
					return "shadow_bolt main 44";
				end
			end
		end
	end
	local function v113()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(104 + 162, v112, v113);
end;
return v0["Epix_Warlock_Demonology.lua"]();

