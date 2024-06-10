local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((1249 - 430) >= (527 - (351 + 154))) and not v6) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Warlock_Demonology.lua"] = function(...)
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
	local v29 = math.min;
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
	local v46;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local function v59()
		v34 = EpicSettings.Settings['UseTrinkets'];
		v33 = EpicSettings.Settings['UseRacials'];
		v35 = EpicSettings.Settings['UseHealingPotion'];
		v36 = EpicSettings.Settings['HealingPotionName'] or (1574 - (1281 + 293));
		v37 = EpicSettings.Settings['HealingPotionHP'] or (266 - (28 + 238));
		v38 = EpicSettings.Settings['UseHealthstone'] or (0 - 0);
		v39 = EpicSettings.Settings['HealthstoneHP'] or (1559 - (1381 + 178));
		v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v42 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v47 = EpicSettings.Settings['SummonPet'];
		v48 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
		v49 = EpicSettings.Settings['DemonboltOpener'];
		v50 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (470 - (381 + 89));
		v51 = EpicSettings.Settings['DemonicStrength'];
		v52 = EpicSettings.Settings['GrimoireFelguard'];
		v53 = EpicSettings.Settings['Implosion'];
		v54 = EpicSettings.Settings['NetherPortal'];
		v55 = EpicSettings.Settings['PowerSiphon'];
		v56 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
		v57 = EpicSettings.Settings['UseBurningRush'] or (0 + 0);
		v58 = EpicSettings.Settings['BurningRushHP'] or (0 - 0);
		v44 = EpicSettings.Settings['DrainLifeHP'] or (1156 - (1074 + 82));
		v45 = EpicSettings.Settings['HealthFunnelHP'] or (0 - 0);
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (1784 - (214 + 1570));
	end
	local v60 = v18.Warlock.Demonology;
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = {};
	local v64 = 12566 - (990 + 465);
	local v65 = 4581 + 6530;
	local v66 = 7 + 7 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
	local v67 = 0 + 0;
	local v68 = false;
	local v69 = false;
	local v70 = false;
	local v71 = 0 - 0;
	local v72 = 1726 - (1668 + 58);
	local v73 = 626 - (512 + 114);
	local v74 = 312 - 192;
	local v75 = 24 - 12;
	local v76 = 0 - 0;
	local v77 = 0 + 0;
	local v78 = 0 + 0;
	local v79;
	local v80, v81;
	v10:RegisterForEvent(function()
		local v124 = 0 + 0;
		while true do
			if (((10665 - 7503) == (5156 - (109 + 1885))) and (v124 == (1469 - (1269 + 200)))) then
				v64 = 21296 - 10185;
				v65 = 11926 - (98 + 717);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v82 = v10.Commons.Everyone;
	local v83 = {{v60.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (0 + 0)) or ((512 + 1857) > (12321 - 7892))) then
				v60.HandofGuldan:RegisterInFlight();
				v66 = (46 - 32) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v60.HandofGuldan:RegisterInFlight();
	local function v84()
		return v10.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v85(v126)
		local v127 = 0 + 0;
		for v145, v146 in pairs(v10.GuardiansTable.Pets) do
			if (((3378 + 717) >= (2315 + 868)) and (v146.ImpCasts <= v126)) then
				v127 = v127 + 1 + 0;
			end
		end
		return v127;
	end
	local function v86()
		return v10.GuardiansTable.FelGuardDuration or (1433 - (797 + 636));
	end
	local function v87()
		return v86() > (0 - 0);
	end
	local function v88()
		return v10.GuardiansTable.DemonicTyrantDuration or (1619 - (1427 + 192));
	end
	local function v89()
		return v88() > (0 + 0);
	end
	local function v90()
		return v10.GuardiansTable.DreadstalkerDuration or (0 - 0);
	end
	local function v91()
		return v90() > (0 + 0);
	end
	local function v92()
		return v10.GuardiansTable.VilefiendDuration or (0 + 0);
	end
	local function v93()
		return v92() > (326 - (192 + 134));
	end
	local function v94()
		return v10.GuardiansTable.PitLordDuration or (1276 - (316 + 960));
	end
	local function v95()
		return v94() > (0 + 0);
	end
	local function v96(v128)
		return v128:DebuffDown(v60.DoomBrandDebuff) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) <= (3 + 0)));
	end
	local function v97(v129)
		return (v129:DebuffDown(v60.DoomBrandDebuff)) or (v81 < (4 + 0));
	end
	local function v98(v130)
		return (v130:DebuffRefreshable(v60.Doom));
	end
	local function v99(v131)
		return (v131:DebuffDown(v60.DoomBrandDebuff));
	end
	local function v100(v132)
		return v132:DebuffRemains(v60.DoomBrandDebuff) > (38 - 28);
	end
	local function v101()
		local v133 = 551 - (83 + 468);
		while true do
			if ((v133 == (1809 - (1202 + 604))) or ((17323 - 13612) < (1677 - 669))) then
				if ((v60.Demonbolt:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and not v13:PrevGCDP(2 - 1, v60.PowerSiphon)) or ((1374 - (45 + 280)) <= (875 + 31))) then
					if (((3943 + 570) > (996 + 1730)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt precombat 4";
					end
				end
				if (v60.ShadowBolt:IsReady() or ((820 + 661) >= (468 + 2190))) then
					if (v23(v62.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((5962 - 2742) == (3275 - (340 + 1571)))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if ((v133 == (1 + 1)) or ((2826 - (1733 + 39)) > (9320 - 5928))) then
				if ((v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) + v28(v84(), 1036 - (125 + 909))) <= (1952 - (1096 + 852))) or (v13:BuffRemains(v60.DemonicCoreBuff) < (2 + 1)))) or ((964 - 288) >= (1593 + 49))) then
					if (((4648 - (409 + 103)) > (2633 - (46 + 190))) and v23(v60.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if ((v60.Demonbolt:IsReady() and not v14:IsInBossList() and v13:BuffUp(v60.DemonicCoreBuff)) or ((4429 - (51 + 44)) == (1198 + 3047))) then
					if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((5593 - (1114 + 203)) <= (3757 - (228 + 498)))) then
						return "demonbolt precombat 3";
					end
				end
				v133 = 1 + 2;
			end
			if ((v133 == (0 + 0)) or ((5445 - (174 + 489)) <= (3123 - 1924))) then
				v75 = 1917 - (830 + 1075);
				v66 = (538 - (303 + 221)) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				v133 = 1270 - (231 + 1038);
			end
			if ((v133 == (1 + 0)) or ((6026 - (171 + 991)) < (7838 - 5936))) then
				v71 = 0 - 0;
				v72 = 0 - 0;
				v133 = 2 + 0;
			end
		end
	end
	local function v102()
		local v134 = 0 - 0;
		local v135;
		while true do
			if (((13959 - 9120) >= (5964 - 2264)) and (v134 == (6 - 4))) then
				v135 = v26(v60.SacrificedSouls:IsAvailable());
				v69 = false;
				if ((v81 > ((1249 - (111 + 1137)) + v135)) or ((1233 - (91 + 67)) > (5708 - 3790))) then
					v69 = not v89();
				end
				if (((99 + 297) <= (4327 - (423 + 100))) and (v81 > (1 + 1 + v135)) and (v81 < ((13 - 8) + v135))) then
					v69 = v88() < (4 + 2);
				end
				v134 = 774 - (326 + 445);
			end
			if (((4 - 3) == v134) or ((9287 - 5118) == (5104 - 2917))) then
				if (((2117 - (530 + 181)) == (2287 - (614 + 267))) and not v60.SummonVilefiend:IsAvailable() and v60.GrimoireFelguard:IsAvailable() and v91()) then
					v67 = v29(v90(), v86()) - (v13:GCD() * (32.5 - (19 + 13)));
				end
				if (((2491 - 960) < (9952 - 5681)) and not v60.SummonVilefiend:IsAvailable() and (not v60.GrimoireFelguard:IsAvailable() or not v13:HasTier(85 - 55, 1 + 1)) and v91()) then
					v67 = v90() - (v13:GCD() * (0.5 - 0));
				end
				if (((1316 - 681) == (2447 - (1293 + 519))) and ((not v93() and v60.SummonVilefiend:IsAvailable()) or not v91())) then
					v67 = 0 - 0;
				end
				v68 = not v60.NetherPortal:IsAvailable() or (v60.NetherPortal:CooldownRemains() > (78 - 48)) or v13:BuffUp(v60.NetherPortalBuff);
				v134 = 3 - 1;
			end
			if (((14544 - 11171) <= (8376 - 4820)) and (v134 == (0 + 0))) then
				if ((((v13:BuffUp(v60.NetherPortalBuff) and (v13:BuffRemains(v60.NetherPortalBuff) < (1 + 2)) and v60.NetherPortal:IsAvailable()) or (v65 < (46 - 26)) or (v89() and (v65 < (24 + 76))) or (v65 < (9 + 16)) or v89() or (not v60.SummonDemonicTyrant:IsAvailable() and v91())) and (v73 <= (0 + 0))) or ((4387 - (709 + 387)) < (5138 - (673 + 1185)))) then
					v72 = (348 - 228) + v77;
				end
				v73 = v72 - v77;
				if (((14084 - 9698) >= (1436 - 563)) and (((((v65 + v77) % (86 + 34)) <= (64 + 21)) and (((v65 + v77) % (162 - 42)) >= (7 + 18))) or (v77 >= (418 - 208))) and (v73 > (0 - 0)) and not v60.GrandWarlocksDesign:IsAvailable()) then
					v74 = v73;
				else
					v74 = v60.SummonDemonicTyrant:CooldownRemains();
				end
				if (((2801 - (446 + 1434)) <= (2385 - (1040 + 243))) and v93() and v91()) then
					v67 = v29(v92(), v90()) - (v13:GCD() * (0.5 - 0));
				end
				v134 = 1848 - (559 + 1288);
			end
			if (((6637 - (609 + 1322)) >= (1417 - (13 + 441))) and (v134 == (10 - 7))) then
				if ((v81 > ((10 - 6) + v135)) or ((4781 - 3821) <= (33 + 843))) then
					v69 = v88() < (29 - 21);
				end
				v70 = (v60.SummonDemonicTyrant:CooldownRemains() < (8 + 12)) and (v74 < (9 + 11)) and ((v13:BuffStack(v60.DemonicCoreBuff) <= (5 - 3)) or v13:BuffDown(v60.DemonicCoreBuff)) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (3 + 2))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (8 - 3)));
				break;
			end
		end
	end
	local function v103()
		local v136 = 0 + 0;
		local v137;
		while true do
			if ((v136 == (1 + 0)) or ((1485 + 581) == (783 + 149))) then
				v137 = v82.HandleBottomTrinket(v63, v32, 40 + 0, nil);
				if (((5258 - (153 + 280)) < (13984 - 9141)) and v137) then
					return v137;
				end
				break;
			end
			if (((0 + 0) == v136) or ((1531 + 2346) >= (2375 + 2162))) then
				v137 = v82.HandleTopTrinket(v63, v32, 37 + 3, nil);
				if (v137 or ((3127 + 1188) < (2627 - 901))) then
					return v137;
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v104()
		local v138 = 667 - (89 + 578);
		while true do
			if ((v138 == (0 + 0)) or ((7648 - 3969) < (1674 - (572 + 477)))) then
				if ((v61.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v60.DemonicPowerBuff) or (not v60.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v60.NetherPortalBuff) or not v60.NetherPortal:IsAvailable())))) or ((624 + 4001) < (380 + 252))) then
					if (v24(v62.TimebreachingTalon) or ((10 + 73) > (1866 - (84 + 2)))) then
						return "timebreaching_talon items 2";
					end
				end
				if (((899 - 353) <= (776 + 301)) and (not v60.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v60.DemonicPowerBuff))) then
					local v151 = 842 - (497 + 345);
					local v152;
					while true do
						if ((v151 == (0 + 0)) or ((169 + 827) > (5634 - (605 + 728)))) then
							v152 = v103();
							if (((2904 + 1166) > (1526 - 839)) and v152) then
								return v152;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v105()
		if (v60.Berserking:IsCastable() or ((31 + 625) >= (12311 - 8981))) then
			if (v24(v60.Berserking, v33) or ((2247 + 245) <= (927 - 592))) then
				return "berserking ogcd 4";
			end
		end
		if (((3264 + 1058) >= (3051 - (457 + 32))) and v60.BloodFury:IsCastable()) then
			if (v24(v60.BloodFury, v33) or ((1544 + 2093) >= (5172 - (832 + 570)))) then
				return "blood_fury ogcd 6";
			end
		end
		if (v60.Fireblood:IsCastable() or ((2242 + 137) > (1194 + 3384))) then
			if (v24(v60.Fireblood, v33) or ((1709 - 1226) > (358 + 385))) then
				return "fireblood ogcd 8";
			end
		end
		if (((3250 - (588 + 208)) > (1557 - 979)) and v60.AncestralCall:IsCastable()) then
			if (((2730 - (884 + 916)) < (9333 - 4875)) and v23(v60.AncestralCall, v33)) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v106()
		local v139 = 0 + 0;
		while true do
			if (((1315 - (232 + 421)) <= (2861 - (1569 + 320))) and (v139 == (1 + 0))) then
				if (((831 + 3539) == (14726 - 10356)) and v60.Implosion:IsReady() and (v84() > (607 - (316 + 289))) and not v91() and not v87() and not v93() and ((v81 > (7 - 4)) or ((v81 > (1 + 1)) and v60.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(1454 - (666 + 787), v60.Implosion)) then
					if (v23(v60.Implosion, v53, nil, not v14:IsInRange(465 - (360 + 65))) or ((4451 + 311) <= (1115 - (79 + 175)))) then
						return "implosion tyrant 8";
					end
				end
				if ((v60.ShadowBolt:IsReady() and v13:PrevGCDP(1 - 0, v60.GrimoireFelguard) and (v77 > (24 + 6)) and v13:BuffDown(v60.NetherPortalBuff) and v13:BuffDown(v60.DemonicCoreBuff)) or ((4327 - 2915) == (8211 - 3947))) then
					if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((4067 - (503 + 396)) < (2334 - (92 + 89)))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if ((v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (7 - 3)) and (not v93() or (not v60.SummonVilefiend:IsAvailable() and v90())) and v13:BuffDown(v60.NetherPortalBuff)) or ((2552 + 2424) < (789 + 543))) then
					if (((18123 - 13495) == (633 + 3995)) and v23(v60.PowerSiphon, v55)) then
						return "power_siphon tyrant 12";
					end
				end
				if ((v60.ShadowBolt:IsReady() and not v93() and v13:BuffDown(v60.NetherPortalBuff) and not v91() and (v76 < ((11 - 6) - v13:BuffStack(v60.DemonicCoreBuff)))) or ((48 + 6) == (189 + 206))) then
					if (((249 - 167) == (11 + 71)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v139 = 2 - 0;
			end
			if ((v139 == (1244 - (485 + 759))) or ((1344 - 763) < (1471 - (442 + 747)))) then
				if (((v67 > (1135 - (832 + 303))) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78)) and (v72 <= (946 - (88 + 858)))) or ((1405 + 3204) < (2065 + 430))) then
					v72 = 5 + 115 + v77;
				end
				if (((1941 - (766 + 23)) == (5687 - 4535)) and v60.HandofGuldan:IsReady() and (v76 > (0 - 0)) and (v67 > (v78 + v60.SummonDemonicTyrant:CastTime())) and (v67 < (v78 * (10 - 6)))) then
					if (((6434 - 4538) <= (4495 - (1036 + 37))) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((v67 > (0 + 0)) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78))) or ((1927 - 937) > (1275 + 345))) then
					local v153 = v104();
					if (v153 or ((2357 - (641 + 839)) > (5608 - (910 + 3)))) then
						return v153;
					end
					local v153 = v105();
					if (((6860 - 4169) >= (3535 - (1466 + 218))) and v153) then
						return v153;
					end
					local v154 = v82.HandleDPSPotion();
					if (v154 or ((1372 + 1613) >= (6004 - (556 + 592)))) then
						return v154;
					end
				end
				if (((1521 + 2755) >= (2003 - (329 + 479))) and v60.SummonDemonicTyrant:IsCastable() and (v67 > (854 - (174 + 680))) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78))) then
					if (((11105 - 7873) <= (9721 - 5031)) and v24(v60.SummonDemonicTyrant, nil, nil, v56)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (742 - (396 + 343))) or ((80 + 816) >= (4623 - (29 + 1448)))) then
				if (((4450 - (135 + 1254)) >= (11143 - 8185)) and v60.HandofGuldan:IsReady() and (((v76 > (9 - 7)) and (v93() or (not v60.SummonVilefiend:IsAvailable() and v91())) and ((v76 > (2 + 0)) or (v92() < ((v78 * (1529 - (389 + 1138))) + ((576 - (102 + 472)) / v13:SpellHaste()))))) or (not v91() and (v76 == (5 + 0))))) then
					if (((1768 + 1419) >= (601 + 43)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((2189 - (320 + 1225)) <= (1252 - 548)) and v60.Demonbolt:IsReady() and (v76 < (3 + 1)) and (v13:BuffStack(v60.DemonicCoreBuff) > (1465 - (157 + 1307))) and (v93() or (not v60.SummonVilefiend:IsAvailable() and v91()) or not v22())) then
					if (((2817 - (821 + 1038)) > (2362 - 1415)) and ((v60.DoomBrandDebuff:AuraActiveCount() == v81) or not v13:HasTier(4 + 27, 3 - 1))) then
						if (((1672 + 2820) >= (6577 - 3923)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt tyrant 26";
						end
					elseif (((4468 - (834 + 192)) >= (96 + 1407)) and v82.CastCycle(v60.Demonbolt, v80, v99, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt tyrant 27";
					end
				end
				if ((v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) < (1 + 2)) and (v67 > (v60.SummonDemonicTyrant:ExecuteTime() + (v78 * (1 + 2))))) or (v67 == (0 - 0)))) or ((3474 - (300 + 4)) <= (391 + 1073))) then
					if (v23(v60.PowerSiphon) or ((12557 - 7760) == (4750 - (112 + 250)))) then
						return "power_siphon tyrant 28";
					end
				end
				if (((220 + 331) <= (1705 - 1024)) and v60.ShadowBolt:IsCastable()) then
					if (((1878 + 1399) > (211 + 196)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if (((3512 + 1183) >= (702 + 713)) and (v139 == (2 + 0))) then
				if ((v60.NetherPortal:IsReady() and (v76 == (1419 - (1001 + 413)))) or ((7162 - 3950) <= (1826 - (244 + 638)))) then
					if (v23(v60.NetherPortal, v54) or ((3789 - (627 + 66)) <= (5357 - 3559))) then
						return "nether_portal tyrant 16";
					end
				end
				if (((4139 - (512 + 90)) == (5443 - (1665 + 241))) and v60.SummonVilefiend:IsReady() and ((v76 == (722 - (373 + 344))) or v13:BuffUp(v60.NetherPortalBuff)) and (v60.SummonDemonicTyrant:CooldownRemains() < (6 + 7)) and v68) then
					if (((1016 + 2821) >= (4141 - 2571)) and v23(v60.SummonVilefiend)) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v60.CallDreadstalkers:IsReady() and (v93() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (50 - 20))) and (v13:BuffUp(v60.NetherPortalBuff) or v87() or (v76 == (1104 - (35 + 1064)))))) and (v60.SummonDemonicTyrant:CooldownRemains() < (9 + 2)) and v68) or ((6311 - 3361) == (16 + 3796))) then
					if (((5959 - (298 + 938)) >= (3577 - (233 + 1026))) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v60.GrimoireFelguard:IsReady() and (v93() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (1696 - (636 + 1030)))) and (v13:BuffUp(v60.NetherPortalBuff) or v91() or (v76 == (3 + 2))) and v68))) or ((1980 + 47) > (848 + 2004))) then
					if (v23(v60.GrimoireFelguard, v52) or ((77 + 1059) > (4538 - (55 + 166)))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v139 = 1 + 2;
			end
		end
	end
	local function v107()
		local v140 = 0 + 0;
		while true do
			if (((18132 - 13384) == (5045 - (36 + 261))) and (v140 == (1 - 0))) then
				if (((5104 - (34 + 1334)) <= (1823 + 2917)) and v60.NetherPortal:IsReady() and v54 and (v65 < (24 + 6))) then
					if (v23(v60.NetherPortal) or ((4673 - (1035 + 248)) <= (3081 - (20 + 1)))) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v60.DemonicStrength:IsCastable() and (v65 < (6 + 4))) or ((1318 - (134 + 185)) > (3826 - (549 + 584)))) then
					if (((1148 - (314 + 371)) < (2063 - 1462)) and v23(v60.DemonicStrength, v51)) then
						return "demonic_strength fight_end 12";
					end
				end
				v140 = 970 - (478 + 490);
			end
			if ((v140 == (2 + 0)) or ((3355 - (786 + 386)) < (2225 - 1538))) then
				if (((5928 - (1055 + 324)) == (5889 - (1093 + 247))) and v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (3 + 0)) and (v65 < (3 + 17))) then
					if (((18548 - 13876) == (15855 - 11183)) and v23(v60.PowerSiphon, v55)) then
						return "power_siphon fight_end 14";
					end
				end
				if ((v60.Implosion:IsReady() and v53 and (v65 < ((5 - 3) * v78))) or ((9217 - 5549) < (141 + 254))) then
					if (v23(v60.Implosion, nil, nil, not v14:IsInRange(154 - 114)) or ((14359 - 10193) == (344 + 111))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if ((v140 == (0 - 0)) or ((5137 - (364 + 324)) == (7299 - 4636))) then
				if ((v60.SummonDemonicTyrant:IsCastable() and (v65 < (47 - 27))) or ((1418 + 2859) < (12506 - 9517))) then
					if (v24(v60.SummonDemonicTyrant, nil, nil, v56) or ((1393 - 523) >= (12600 - 8451))) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if (((3480 - (1249 + 19)) < (2874 + 309)) and (v65 < (77 - 57))) then
					local v155 = 1086 - (686 + 400);
					while true do
						if (((3646 + 1000) > (3221 - (73 + 156))) and (v155 == (1 + 0))) then
							if (((2245 - (721 + 90)) < (35 + 3071)) and v60.SummonVilefiend:IsReady()) then
								if (((2551 - 1765) < (3493 - (224 + 246))) and v23(v60.SummonVilefiend)) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
						if ((v155 == (0 - 0)) or ((4495 - 2053) < (14 + 60))) then
							if (((108 + 4427) == (3331 + 1204)) and v60.GrimoireFelguard:IsReady() and v52) then
								if (v23(v60.GrimoireFelguard) or ((5981 - 2972) <= (7005 - 4900))) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((2343 - (203 + 310)) < (5662 - (1238 + 755))) and v60.CallDreadstalkers:IsReady()) then
								if (v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers)) or ((100 + 1330) >= (5146 - (709 + 825)))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v155 = 1 - 0;
						end
					end
				end
				v140 = 1 - 0;
			end
		end
	end
	local v108 = 864 - (196 + 668);
	local v109 = false;
	function UpdateLastMoveTime()
		if (((10593 - 7910) >= (5095 - 2635)) and v13:IsMoving()) then
			if (not v109 or ((2637 - (171 + 662)) >= (3368 - (4 + 89)))) then
				v108 = GetTime();
				v109 = true;
			end
		else
			v109 = false;
		end
	end
	local function v110()
		if (v13:AffectingCombat() or ((4966 - 3549) > (1322 + 2307))) then
			if (((21060 - 16265) > (158 + 244)) and (v13:HealthPercentage() <= v48) and v60.DarkPact:IsCastable() and not v13:BuffUp(v60.DarkPact)) then
				if (((6299 - (35 + 1451)) > (5018 - (28 + 1425))) and v24(v60.DarkPact)) then
					return "dark_pact defensive 2";
				end
			end
			if (((5905 - (941 + 1052)) == (3752 + 160)) and (v13:HealthPercentage() <= v44) and v60.DrainLife:IsCastable()) then
				if (((4335 - (822 + 692)) <= (6886 - 2062)) and v24(v60.DrainLife)) then
					return "drain_life defensive 2";
				end
			end
			if (((819 + 919) <= (2492 - (45 + 252))) and (v13:HealthPercentage() <= v45) and v60.HealthFunnel:IsCastable()) then
				if (((41 + 0) <= (1039 + 1979)) and v24(v60.HealthFunnel)) then
					return "health_funnel defensive 2";
				end
			end
			if (((5220 - 3075) <= (4537 - (114 + 319))) and (v13:HealthPercentage() <= v46) and v60.UnendingResolve:IsCastable()) then
				if (((3860 - 1171) < (6208 - 1363)) and v24(v60.UnendingResolve)) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v111()
		if ((v60.SummonDemonicTyrant:IsCastable() and v56 and (v93() or v87() or (v60.GrimoireFelguard:CooldownRemains() > (58 + 32)))) or ((3458 - 1136) > (5493 - 2871))) then
			if (v23(v60.SummonDemonicTyrant) or ((6497 - (556 + 1407)) == (3288 - (741 + 465)))) then
				return "summon_demonic_tyrant main 4";
			end
		end
		if ((v60.SummonVilefiend:IsReady() and (v60.SummonDemonicTyrant:CooldownRemains() > (510 - (170 + 295)))) or ((828 + 743) > (1715 + 152))) then
			if (v23(v60.SummonVilefiend) or ((6534 - 3880) >= (2484 + 512))) then
				return "summon_vilefiend main 6";
			end
		end
		if (((2552 + 1426) > (1192 + 912)) and v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (((not v60.SoulStrike:IsAvailable() or (v60.SoulStrike:CooldownRemains() > (v78 * (1232 - (957 + 273))))) and (v76 < (2 + 2))) or (v76 < ((2 + 2) - (v26(v81 > (7 - 5)))))) and not v13:PrevGCDP(2 - 1, v60.Demonbolt) and v13:HasTier(94 - 63, 9 - 7)) then
			if (((4775 - (389 + 1391)) > (967 + 574)) and v82.CastCycle(v60.Demonbolt, v80, v96, not v14:IsSpellInRange(v60.Demonbolt))) then
				return "demonbolt main 8";
			end
		end
		if (((339 + 2910) > (2169 - 1216)) and v60.PowerSiphon:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and (v14:DebuffDown(v60.DoomBrandDebuff) or (not v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v78 + v60.Demonbolt:TravelTime()))) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v78 + v60.Demonbolt:TravelTime() + (954 - (783 + 168)))))) and v13:HasTier(103 - 72, 2 + 0)) then
			if (v23(v60.PowerSiphon, v55) or ((3584 - (309 + 2)) > (14043 - 9470))) then
				return "power_siphon main 10";
			end
		end
		if ((v60.DemonicStrength:IsCastable() and (v13:BuffRemains(v60.NetherPortalBuff) < v78)) or ((4363 - (1090 + 122)) < (417 + 867))) then
			if (v23(v60.DemonicStrength, v51) or ((6213 - 4363) == (1047 + 482))) then
				return "demonic_strength main 12";
			end
		end
		if (((1939 - (628 + 490)) < (381 + 1742)) and v60.BilescourgeBombers:IsReady() and v60.BilescourgeBombers:IsCastable()) then
			if (((2232 - 1330) < (10625 - 8300)) and v23(v60.BilescourgeBombers, nil, nil, not v14:IsInRange(814 - (431 + 343)))) then
				return "bilescourge_bombers main 14";
			end
		end
		if (((1732 - 874) <= (8568 - 5606)) and v60.Guillotine:IsCastable() and v50 and (v13:BuffRemains(v60.NetherPortalBuff) < v78) and (v60.DemonicStrength:CooldownDown() or not v60.DemonicStrength:IsAvailable())) then
			if (v23(v62.GuillotineCursor, nil, nil, not v14:IsInRange(32 + 8)) or ((505 + 3441) < (2983 - (556 + 1139)))) then
				return "guillotine main 16";
			end
		end
		if ((v60.CallDreadstalkers:IsReady() and ((v60.SummonDemonicTyrant:CooldownRemains() > (40 - (6 + 9))) or (v74 > (5 + 20)) or v13:BuffUp(v60.NetherPortalBuff))) or ((1661 + 1581) == (736 - (28 + 141)))) then
			if (v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers)) or ((329 + 518) >= (1558 - 295))) then
				return "call_dreadstalkers main 18";
			end
		end
		if ((v60.Implosion:IsReady() and (v85(2 + 0) > (1317 - (486 + 831))) and v69 and not v13:PrevGCDP(2 - 1, v60.Implosion)) or ((7931 - 5678) == (350 + 1501))) then
			if (v23(v60.Implosion, v53, nil, not v14:IsInRange(126 - 86)) or ((3350 - (668 + 595)) > (2135 + 237))) then
				return "implosion main 20";
			end
		end
		if ((v60.SummonSoulkeeper:IsReady() and (v60.SummonSoulkeeper:Count() == (3 + 7)) and (v81 > (2 - 1))) or ((4735 - (23 + 267)) < (6093 - (1129 + 815)))) then
			if (v23(v60.SummonSoulkeeper) or ((2205 - (371 + 16)) == (1835 - (1326 + 424)))) then
				return "soul_strike main 22";
			end
		end
		if (((1193 - 563) < (7772 - 5645)) and v60.HandofGuldan:IsReady() and (((v76 > (120 - (88 + 30))) and (v60.CallDreadstalkers:CooldownRemains() > (v78 * (775 - (720 + 51)))) and (v60.SummonDemonicTyrant:CooldownRemains() > (37 - 20))) or (v76 == (1781 - (421 + 1355))) or ((v76 == (6 - 2)) and v60.SoulStrike:IsAvailable() and (v60.SoulStrike:CooldownRemains() < (v78 * (1 + 1))))) and (v81 == (1084 - (286 + 797))) and v60.GrandWarlocksDesign:IsAvailable()) then
			if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((7084 - 5146) == (4163 - 1649))) then
				return "hand_of_guldan main 26";
			end
		end
		if (((4694 - (397 + 42)) >= (18 + 37)) and v60.HandofGuldan:IsReady() and (v76 > (802 - (24 + 776))) and not ((v81 == (1 - 0)) and v60.GrandWarlocksDesign:IsAvailable())) then
			if (((3784 - (222 + 563)) > (2546 - 1390)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
				return "hand_of_guldan main 28";
			end
		end
		if (((1692 + 658) > (1345 - (23 + 167))) and v60.Demonbolt:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) > (1799 - (690 + 1108))) and (((v76 < (2 + 2)) and not v60.SoulStrike:IsAvailable()) or (v60.SoulStrike:CooldownRemains() > (v78 * (2 + 0))) or (v76 < (850 - (40 + 808)))) and not v70) then
			if (((664 + 3365) <= (18557 - 13704)) and v82.CastCycle(v60.Demonbolt, v80, v97, not v14:IsSpellInRange(v60.Demonbolt))) then
				return "demonbolt main 30";
			end
		end
		if ((v60.Demonbolt:IsReady() and v13:HasTier(30 + 1, 2 + 0) and v13:BuffUp(v60.DemonicCoreBuff) and (v76 < (3 + 1)) and not v70) or ((1087 - (47 + 524)) > (2229 + 1205))) then
			if (((11059 - 7013) >= (4535 - 1502)) and v82.CastTargetIf(v60.Demonbolt, v80, "==", v97, v100, not v14:IsSpellInRange(v60.Demonbolt))) then
				return "demonbolt main 32";
			end
		end
		if ((v60.Demonbolt:IsReady() and (v65 < (v13:BuffStack(v60.DemonicCoreBuff) * v78))) or ((6200 - 3481) <= (3173 - (1165 + 561)))) then
			if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((123 + 4011) < (12159 - 8233))) then
				return "demonbolt main 34";
			end
		end
		if ((v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (v60.PowerSiphon:CooldownRemains() < (2 + 2)) and (v76 < (483 - (341 + 138))) and not v70) or ((45 + 119) >= (5747 - 2962))) then
			if (v82.CastCycle(v60.Demonbolt, v80, v97, not v14:IsSpellInRange(v60.Demonbolt)) or ((851 - (89 + 237)) == (6784 - 4675))) then
				return "demonbolt main 36";
			end
		end
		if (((69 - 36) == (914 - (581 + 300))) and v60.PowerSiphon:IsReady() and (v13:BuffDown(v60.DemonicCoreBuff))) then
			if (((4274 - (855 + 365)) <= (9536 - 5521)) and v23(v60.PowerSiphon, v55)) then
				return "power_siphon main 38";
			end
		end
		if (((611 + 1260) < (4617 - (1030 + 205))) and v60.SummonVilefiend:IsReady() and (v65 < (v60.SummonDemonicTyrant:CooldownRemains() + 5 + 0))) then
			if (((1203 + 90) <= (2452 - (156 + 130))) and v23(v60.SummonVilefiend)) then
				return "summon_vilefiend main 40";
			end
		end
		if (v60.Doom:IsReady() or ((5859 - 3280) < (207 - 84))) then
			if (v82.CastCycle(v60.Doom, v79, v98, not v14:IsSpellInRange(v60.Doom)) or ((1732 - 886) >= (624 + 1744))) then
				return "doom main 42";
			end
		end
		if (v60.ShadowBolt:IsCastable() or ((2340 + 1672) <= (3427 - (10 + 59)))) then
			if (((423 + 1071) <= (14798 - 11793)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
				return "shadow_bolt main 44";
			end
		end
	end
	local function v112()
		v59();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		if (v31 or ((4274 - (671 + 492)) == (1699 + 435))) then
			local v147 = 1215 - (369 + 846);
			while true do
				if (((624 + 1731) == (2010 + 345)) and (v147 == (1946 - (1036 + 909)))) then
					v81 = v28(#v80, #v79);
					break;
				end
				if (((0 + 0) == v147) or ((987 - 399) <= (635 - (11 + 192)))) then
					v80 = v14:GetEnemiesInSplashRange(5 + 3);
					v79 = v13:GetEnemiesInRange(215 - (135 + 40));
					v147 = 2 - 1;
				end
			end
		else
			local v148 = 0 + 0;
			while true do
				if (((10567 - 5770) >= (5839 - 1944)) and (v148 == (177 - (50 + 126)))) then
					v81 = 2 - 1;
					break;
				end
				if (((792 + 2785) == (4990 - (1233 + 180))) and (v148 == (969 - (522 + 447)))) then
					v80 = {};
					v79 = {};
					v148 = 1422 - (107 + 1314);
				end
			end
		end
		UpdateLastMoveTime();
		if (((1761 + 2033) > (11252 - 7559)) and (v82.TargetIsValid() or v13:AffectingCombat())) then
			v64 = v10.BossFightRemains();
			v65 = v64;
			if ((v65 == (4720 + 6391)) or ((2531 - 1256) == (16222 - 12122))) then
				v65 = v10.FightRemains(v80, false);
			end
			v25.UpdatePetTable();
			v25.UpdateSoulShards();
			v77 = v10.CombatTime();
			v76 = v13:SoulShardsP();
			v78 = v13:GCD() + (1910.25 - (716 + 1194));
		end
		if ((v60.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v47 and not v17:IsActive()) or ((28 + 1563) >= (384 + 3196))) then
			if (((1486 - (74 + 429)) <= (3487 - 1679)) and v24(v60.SummonPet, false, true)) then
				return "summon_pet ooc";
			end
		end
		if ((v61.Healthstone:IsReady() and v38 and (v13:HealthPercentage() <= v39)) or ((1066 + 1084) <= (2739 - 1542))) then
			if (((2667 + 1102) >= (3615 - 2442)) and v24(v62.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((3671 - 2186) == (1918 - (279 + 154))) and v35 and (v13:HealthPercentage() <= v37)) then
			if ((v36 == "Refreshing Healing Potion") or ((4093 - (454 + 324)) <= (2189 + 593))) then
				if (v61.RefreshingHealingPotion:IsReady() or ((893 - (12 + 5)) >= (1599 + 1365))) then
					if (v24(v62.RefreshingHealingPotion) or ((5686 - 3454) > (923 + 1574))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v36 == "Dreamwalker's Healing Potion") or ((3203 - (277 + 816)) <= (1418 - 1086))) then
				if (((4869 - (1058 + 125)) > (595 + 2577)) and v61.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v62.RefreshingHealingPotion) or ((5449 - (815 + 160)) < (3518 - 2698))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (((10157 - 5878) >= (688 + 2194)) and v82.TargetIsValid()) then
			local v149 = 0 - 0;
			local v150;
			while true do
				if ((v149 == (1898 - (41 + 1857))) or ((3922 - (1222 + 671)) >= (9100 - 5579))) then
					if ((not v13:AffectingCombat() and v30 and not v13:IsCasting(v60.ShadowBolt)) or ((2927 - 890) >= (5824 - (229 + 953)))) then
						local v156 = v101();
						if (((3494 - (1111 + 663)) < (6037 - (874 + 705))) and v156) then
							return v156;
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((62 + 374) > (2062 + 959))) then
						local v157 = 0 - 0;
						local v158;
						while true do
							if (((21 + 692) <= (1526 - (642 + 37))) and (v157 == (1 + 2))) then
								if (((345 + 1809) <= (10120 - 6089)) and v158) then
									return v158;
								end
								v158 = v82.InterruptWithStun(v60.AxeToss, 494 - (233 + 221), true, v16, v62.AxeTossMouseover);
								if (((10671 - 6056) == (4063 + 552)) and v158) then
									return v158;
								end
								break;
							end
							if ((v157 == (1541 - (718 + 823))) or ((2385 + 1405) == (1305 - (266 + 539)))) then
								v158 = v82.Interrupt(v60.SpellLock, 113 - 73, true);
								if (((1314 - (636 + 589)) < (524 - 303)) and v158) then
									return v158;
								end
								v158 = v82.Interrupt(v60.SpellLock, 82 - 42, true, v16, v62.SpellLockMouseover);
								v157 = 1 + 0;
							end
							if (((747 + 1307) >= (2436 - (657 + 358))) and (v157 == (4 - 2))) then
								v158 = v82.Interrupt(v60.AxeToss, 91 - 51, true, v16, v62.AxeTossMouseover);
								if (((1879 - (1151 + 36)) < (2954 + 104)) and v158) then
									return v158;
								end
								v158 = v82.InterruptWithStun(v60.AxeToss, 11 + 29, true);
								v157 = 8 - 5;
							end
							if ((v157 == (1833 - (1552 + 280))) or ((4088 - (64 + 770)) == (1124 + 531))) then
								if (v158 or ((2941 - 1645) == (872 + 4038))) then
									return v158;
								end
								v158 = v82.Interrupt(v60.AxeToss, 1283 - (157 + 1086), true);
								if (((6741 - 3373) == (14750 - 11382)) and v158) then
									return v158;
								end
								v157 = 2 - 0;
							end
						end
					end
					if (((3606 - 963) < (4634 - (599 + 220))) and v13:AffectingCombat() and v57) then
						if (((3808 - 1895) > (2424 - (1813 + 118))) and v60.BurningRush:IsCastable() and not v13:BuffUp(v60.BurningRush) and v109 and ((GetTime() - v108) >= (1 + 0)) and (v13:HealthPercentage() >= v58)) then
							if (((5972 - (841 + 376)) > (4803 - 1375)) and v24(v60.BurningRush)) then
								return "burning_rush defensive 2";
							end
						elseif (((321 + 1060) <= (6466 - 4097)) and v60.BurningRush:IsCastable() and v13:BuffUp(v60.BurningRush) and (not v109 or (v13:HealthPercentage() <= v58))) then
							if (v24(v62.CancelBurningRush) or ((5702 - (464 + 395)) == (10480 - 6396))) then
								return "burning_rush defensive 4";
							end
						end
					end
					v150 = v110();
					v149 = 1 + 0;
				end
				if (((5506 - (467 + 370)) > (749 - 386)) and ((3 + 0) == v149)) then
					if (((v60.SummonDemonicTyrant:CooldownRemains() < (51 - 36)) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (1 + 4))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (11 - 6))) and ((v60.GrimoireFelguard:CooldownRemains() < (530 - (150 + 370))) or not v13:HasTier(1312 - (74 + 1208), 4 - 2)) and ((v74 < (71 - 56)) or (v65 < (29 + 11)) or v13:PowerInfusionUp())) or (v60.SummonVilefiend:IsAvailable() and (v60.SummonDemonicTyrant:CooldownRemains() < (405 - (14 + 376))) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (8 - 3))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (4 + 1))) and ((v60.GrimoireFelguard:CooldownRemains() < (9 + 1)) or not v13:HasTier(29 + 1, 5 - 3)) and ((v74 < (12 + 3)) or (v65 < (118 - (23 + 55))) or v13:PowerInfusionUp())) or ((4447 - 2570) >= (2094 + 1044))) then
						local v159 = v106();
						if (((4259 + 483) >= (5621 - 1995)) and v159) then
							return v159;
						end
					end
					if (((v60.SummonDemonicTyrant:CooldownRemains() < (5 + 10)) and (v93() or (not v60.SummonVilefiend:IsAvailable() and (v87() or v60.GrimoireFelguard:CooldownUp() or not v13:HasTier(931 - (652 + 249), 5 - 3)))) and ((v74 < (1883 - (708 + 1160))) or v87() or (v65 < (108 - 68)) or v13:PowerInfusionUp())) or ((8277 - 3737) == (943 - (10 + 17)))) then
						local v160 = 0 + 0;
						local v161;
						while true do
							if (((1732 - (1400 + 332)) == v160) or ((2217 - 1061) > (6253 - (242 + 1666)))) then
								v161 = v106();
								if (((958 + 1279) < (1558 + 2691)) and v161) then
									return v161;
								end
								break;
							end
						end
					end
					v150 = v111();
					if (v150 or ((2287 + 396) < (963 - (850 + 90)))) then
						return v150;
					end
					break;
				end
				if (((1220 - 523) <= (2216 - (360 + 1030))) and (v149 == (1 + 0))) then
					if (((3118 - 2013) <= (1617 - 441)) and v150) then
						return v150;
					end
					if (((5040 - (909 + 752)) <= (5035 - (109 + 1114))) and v60.UnendingResolve:IsReady() and (v13:HealthPercentage() < v46)) then
						if (v24(v60.UnendingResolve) or ((1442 - 654) >= (630 + 986))) then
							return "unending_resolve defensive";
						end
					end
					v102();
					if (((2096 - (6 + 236)) <= (2129 + 1250)) and (v89() or (v65 < (18 + 4)))) then
						local v162 = 0 - 0;
						local v163;
						while true do
							if (((7945 - 3396) == (5682 - (1076 + 57))) and (v162 == (0 + 0))) then
								v163 = v105();
								if ((v163 and v33 and v32) or ((3711 - (579 + 110)) >= (239 + 2785))) then
									return v163;
								end
								break;
							end
						end
					end
					v149 = 2 + 0;
				end
				if (((2559 + 2261) > (2605 - (174 + 233))) and ((5 - 3) == v149)) then
					v150 = v104();
					if (v150 or ((1862 - 801) >= (2175 + 2716))) then
						return v150;
					end
					if (((2538 - (663 + 511)) <= (3991 + 482)) and (v65 < (7 + 23))) then
						local v164 = v107();
						if (v164 or ((11083 - 7488) <= (2 + 1))) then
							return v164;
						end
					end
					if ((v60.HandofGuldan:IsReady() and (v77 < (0.5 - 0)) and (((v65 % (229 - 134)) > (20 + 20)) or ((v65 % (184 - 89)) < (11 + 4))) and (v60.ReignofTyranny:IsAvailable() or (v81 > (1 + 1)))) or ((5394 - (478 + 244)) == (4369 - (440 + 77)))) then
						if (((709 + 850) == (5705 - 4146)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
							return "hand_of_guldan main 2";
						end
					end
					v149 = 1559 - (655 + 901);
				end
			end
		end
	end
	local function v113()
		local v144 = 0 + 0;
		while true do
			if (((0 + 0) == v144) or ((1184 + 568) <= (3174 - 2386))) then
				v60.DoomBrandDebuff:RegisterAuraTracking();
				v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v10.SetAPL(1711 - (695 + 750), v112, v113);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

