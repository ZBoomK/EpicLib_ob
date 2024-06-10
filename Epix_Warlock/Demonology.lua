local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((4452 - 1376) > (5141 - 1958))) then
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
		local v113 = 0 + 0;
		while true do
			if (((2293 - 1091) > (3145 - 2087)) and (v113 == (0 + 0))) then
				v34 = EpicSettings.Settings['UseTrinkets'];
				v33 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v113 = 1 + 0;
			end
			if (((9689 - 5978) > (2085 + 1270)) and ((1170 - (645 + 522)) == v113)) then
				v49 = EpicSettings.Settings['DemonboltOpener'];
				v50 = EpicSettings.Settings["Use Guillotine"] or (1790 - (1010 + 780));
				v46 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				v51 = EpicSettings.Settings['DemonicStrength'];
				v113 = 19 - 15;
			end
			if ((v113 == (14 - 9)) or ((2742 - (1045 + 791)) >= (5641 - 3412))) then
				v56 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 - 0);
				v57 = EpicSettings.Settings['UseBurningRush'] or (505 - (351 + 154));
				v58 = EpicSettings.Settings['BurningRushHP'] or (1574 - (1281 + 293));
				v44 = EpicSettings.Settings['DrainLifeHP'] or (266 - (28 + 238));
				v113 = 12 - 6;
			end
			if (((2847 - (1381 + 178)) > (1174 + 77)) and (v113 == (4 + 0))) then
				v52 = EpicSettings.Settings['GrimoireFelguard'];
				v53 = EpicSettings.Settings['Implosion'];
				v54 = EpicSettings.Settings['NetherPortal'];
				v55 = EpicSettings.Settings['PowerSiphon'];
				v113 = 3 + 2;
			end
			if ((v113 == (20 - 14)) or ((2339 + 2174) < (3822 - (381 + 89)))) then
				v45 = EpicSettings.Settings['HealthFunnelHP'] or (0 + 0);
				v46 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				break;
			end
			if ((v113 == (2 - 0)) or ((3221 - (1074 + 82)) >= (7003 - 3807))) then
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1784 - (214 + 1570));
				v42 = EpicSettings.Settings['InterruptThreshold'] or (1455 - (990 + 465));
				v47 = EpicSettings.Settings['SummonPet'];
				v48 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v113 = 2 + 1;
			end
			if ((v113 == (1 + 0)) or ((17221 - 12845) <= (3207 - (1668 + 58)))) then
				v37 = EpicSettings.Settings['HealingPotionHP'] or (626 - (512 + 114));
				v38 = EpicSettings.Settings['UseHealthstone'] or (0 - 0);
				v39 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v40 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v113 = 1 + 1;
			end
		end
	end
	local v60 = v18.Warlock.Demonology;
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = {};
	local v64 = 2080 + 9031;
	local v65 = 9660 + 1451;
	local v66 = (47 - 33) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
	local v67 = 1994 - (109 + 1885);
	local v68 = false;
	local v69 = false;
	local v70 = false;
	local v71 = 1469 - (1269 + 200);
	local v72 = 0 - 0;
	local v73 = 815 - (98 + 717);
	local v74 = 946 - (802 + 24);
	local v75 = 20 - 8;
	local v76 = 0 - 0;
	local v77 = 0 + 0;
	local v78 = 0 + 0;
	local v79;
	local v80, v81;
	v10:RegisterForEvent(function()
		local v114 = 0 + 0;
		while true do
			if ((v114 == (0 + 0)) or ((9436 - 6044) >= (15810 - 11069))) then
				v64 = 3975 + 7136;
				v65 = 4523 + 6588;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v82 = v10.Commons.Everyone;
	local v83 = {{v60.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v115 = 0 - 0;
		while true do
			if (((4944 - (1427 + 192)) >= (747 + 1407)) and (v115 == (0 - 0))) then
				v60.HandofGuldan:RegisterInFlight();
				v66 = 13 + 1 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v60.HandofGuldan:RegisterInFlight();
	local function v84()
		return v10.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v85(v116)
		local v117 = 326 - (192 + 134);
		local v118;
		while true do
			if ((v117 == (1276 - (316 + 960))) or ((721 + 574) >= (2495 + 738))) then
				v118 = 0 + 0;
				for v146, v147 in pairs(v10.GuardiansTable.Pets) do
					if (((16733 - 12356) > (2193 - (83 + 468))) and (v147.ImpCasts <= v116)) then
						v118 = v118 + (1807 - (1202 + 604));
					end
				end
				v117 = 4 - 3;
			end
			if (((7859 - 3136) > (3754 - 2398)) and ((326 - (45 + 280)) == v117)) then
				return v118;
			end
		end
	end
	local function v86()
		return v10.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v87()
		return v86() > (0 + 0);
	end
	local function v88()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 + 0);
	end
	local function v89()
		return v88() > (0 + 0);
	end
	local function v90()
		return v10.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v91()
		return v90() > (0 - 0);
	end
	local function v92()
		return v10.GuardiansTable.VilefiendDuration or (1911 - (340 + 1571));
	end
	local function v93()
		return v92() > (0 + 0);
	end
	local function v94()
		return v10.GuardiansTable.PitLordDuration or (1772 - (1733 + 39));
	end
	local function v95()
		return v94() > (0 - 0);
	end
	local function v96(v119)
		return v119:DebuffDown(v60.DoomBrandDebuff) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) <= (1037 - (125 + 909))));
	end
	local function v97(v120)
		return (v120:DebuffDown(v60.DoomBrandDebuff)) or (v81 < (1952 - (1096 + 852)));
	end
	local function v98(v121)
		return (v121:DebuffRefreshable(v60.Doom));
	end
	local function v99(v122)
		return (v122:DebuffDown(v60.DoomBrandDebuff));
	end
	local function v100(v123)
		return v123:DebuffRemains(v60.DoomBrandDebuff) > (5 + 5);
	end
	local function v101()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (2 + 0)) or ((4648 - (409 + 103)) <= (3669 - (46 + 190)))) then
				if (((4340 - (51 + 44)) <= (1307 + 3324)) and v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) + v28(v84(), 1319 - (1114 + 203))) <= (730 - (228 + 498))) or (v13:BuffRemains(v60.DemonicCoreBuff) < (1 + 2)))) then
					if (((2363 + 1913) >= (4577 - (174 + 489))) and v23(v60.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if (((515 - 317) <= (6270 - (830 + 1075))) and v60.Demonbolt:IsReady() and not v14:IsInBossList() and v13:BuffUp(v60.DemonicCoreBuff)) then
					if (((5306 - (303 + 221)) > (5945 - (231 + 1038))) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt precombat 3";
					end
				end
				v124 = 3 + 0;
			end
			if (((6026 - (171 + 991)) > (9054 - 6857)) and (v124 == (0 - 0))) then
				v75 = 29 - 17;
				v66 = 12 + 2 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				v124 = 3 - 2;
			end
			if (((8 - 5) == v124) or ((5964 - 2264) == (7749 - 5242))) then
				if (((5722 - (111 + 1137)) >= (432 - (91 + 67))) and v60.Demonbolt:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and not v13:PrevGCDP(2 - 1, v60.PowerSiphon)) then
					if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((473 + 1421) <= (1929 - (423 + 100)))) then
						return "demonbolt precombat 4";
					end
				end
				if (((12 + 1560) >= (4238 - 2707)) and v60.ShadowBolt:IsReady()) then
					if (v23(v62.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((2443 + 2244) < (5313 - (326 + 445)))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((14361 - 11070) > (3713 - 2046)) and (v124 == (2 - 1))) then
				v71 = 711 - (530 + 181);
				v72 = 881 - (614 + 267);
				v124 = 34 - (19 + 13);
			end
		end
	end
	local function v102()
		local v125 = 0 - 0;
		local v126;
		while true do
			if ((v125 == (4 - 2)) or ((2493 - 1620) == (529 + 1505))) then
				if ((not v93() and v60.SummonVilefiend:IsAvailable()) or not v91() or ((4951 - 2135) < (22 - 11))) then
					v67 = 1812 - (1293 + 519);
				end
				v68 = not v60.NetherPortal:IsAvailable() or (v60.NetherPortal:CooldownRemains() > (61 - 31)) or v13:BuffUp(v60.NetherPortalBuff);
				v126 = v26(v60.SacrificedSouls:IsAvailable());
				v125 = 7 - 4;
			end
			if (((7073 - 3374) < (20292 - 15586)) and (v125 == (0 - 0))) then
				if (((1402 + 1244) >= (179 + 697)) and ((v13:BuffUp(v60.NetherPortalBuff) and (v13:BuffRemains(v60.NetherPortalBuff) < (6 - 3)) and v60.NetherPortal:IsAvailable()) or (v65 < (5 + 15)) or (v89() and (v65 < (34 + 66))) or (v65 < (16 + 9)) or v89() or (not v60.SummonDemonicTyrant:IsAvailable() and v91())) and (v73 <= (1096 - (709 + 387)))) then
					v72 = (1978 - (673 + 1185)) + v77;
				end
				v73 = v72 - v77;
				if (((1780 - 1166) <= (10224 - 7040)) and (((((v65 + v77) % (197 - 77)) <= (61 + 24)) and (((v65 + v77) % (90 + 30)) >= (33 - 8))) or (v77 >= (52 + 158))) and (v73 > (0 - 0)) and not v60.GrandWarlocksDesign:IsAvailable()) then
					v74 = v73;
				else
					v74 = v60.SummonDemonicTyrant:CooldownRemains();
				end
				v125 = 1 - 0;
			end
			if (((5006 - (446 + 1434)) == (4409 - (1040 + 243))) and (v125 == (2 - 1))) then
				if ((v93() and v91()) or ((4034 - (559 + 1288)) >= (6885 - (609 + 1322)))) then
					v67 = v29(v92(), v90()) - (v13:GCD() * (454.5 - (13 + 441)));
				end
				if ((not v60.SummonVilefiend:IsAvailable() and v60.GrimoireFelguard:IsAvailable() and v91()) or ((14487 - 10610) == (9364 - 5789))) then
					v67 = v29(v90(), v86()) - (v13:GCD() * (0.5 - 0));
				end
				if (((27 + 680) > (2295 - 1663)) and not v60.SummonVilefiend:IsAvailable() and (not v60.GrimoireFelguard:IsAvailable() or not v13:HasTier(11 + 19, 1 + 1)) and v91()) then
					v67 = v90() - (v13:GCD() * (0.5 - 0));
				end
				v125 = 2 + 0;
			end
			if ((v125 == (7 - 3)) or ((361 + 185) >= (1493 + 1191))) then
				if (((1053 + 412) <= (3612 + 689)) and (v81 > (4 + 0 + v126))) then
					v69 = v88() < (441 - (153 + 280));
				end
				v70 = (v60.SummonDemonicTyrant:CooldownRemains() < (57 - 37)) and (v74 < (18 + 2)) and ((v13:BuffStack(v60.DemonicCoreBuff) <= (1 + 1)) or v13:BuffDown(v60.DemonicCoreBuff)) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (3 + 2))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (5 + 0)));
				break;
			end
			if (((1235 + 469) > (2169 - 744)) and (v125 == (2 + 1))) then
				v69 = false;
				if ((v81 > ((668 - (89 + 578)) + v126)) or ((491 + 196) == (8802 - 4568))) then
					v69 = not v89();
				end
				if (((v81 > ((1051 - (572 + 477)) + v126)) and (v81 < (1 + 4 + v126))) or ((1999 + 1331) < (171 + 1258))) then
					v69 = v88() < (92 - (84 + 2));
				end
				v125 = 6 - 2;
			end
		end
	end
	local function v103()
		local v127 = v82.HandleTopTrinket(v63, v32, 29 + 11, nil);
		if (((1989 - (497 + 345)) >= (9 + 326)) and v127) then
			return v127;
		end
		local v127 = v82.HandleBottomTrinket(v63, v32, 7 + 33, nil);
		if (((4768 - (605 + 728)) > (1497 + 600)) and v127) then
			return v127;
		end
	end
	local function v104()
		if ((v61.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v60.DemonicPowerBuff) or (not v60.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v60.NetherPortalBuff) or not v60.NetherPortal:IsAvailable())))) or ((8381 - 4611) >= (186 + 3855))) then
			if (v24(v62.TimebreachingTalon) or ((14016 - 10225) <= (1453 + 158))) then
				return "timebreaching_talon items 2";
			end
		end
		if (not v60.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v60.DemonicPowerBuff) or ((12683 - 8105) <= (1517 + 491))) then
			local v131 = 489 - (457 + 32);
			local v132;
			while true do
				if (((478 + 647) <= (3478 - (832 + 570))) and (v131 == (0 + 0))) then
					v132 = v103();
					if (v132 or ((194 + 549) >= (15567 - 11168))) then
						return v132;
					end
					break;
				end
			end
		end
	end
	local function v105()
		if (((557 + 598) < (2469 - (588 + 208))) and v60.Berserking:IsCastable()) then
			if (v24(v60.Berserking, v33) or ((6263 - 3939) <= (2378 - (884 + 916)))) then
				return "berserking ogcd 4";
			end
		end
		if (((7886 - 4119) == (2185 + 1582)) and v60.BloodFury:IsCastable()) then
			if (((4742 - (232 + 421)) == (5978 - (1569 + 320))) and v24(v60.BloodFury, v33)) then
				return "blood_fury ogcd 6";
			end
		end
		if (((1094 + 3364) >= (319 + 1355)) and v60.Fireblood:IsCastable()) then
			if (((3275 - 2303) <= (2023 - (316 + 289))) and v24(v60.Fireblood, v33)) then
				return "fireblood ogcd 8";
			end
		end
		if (v60.AncestralCall:IsCastable() or ((12926 - 7988) < (220 + 4542))) then
			if (v23(v60.AncestralCall, v33) or ((3957 - (666 + 787)) > (4689 - (360 + 65)))) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v106()
		local v128 = 0 + 0;
		while true do
			if (((2407 - (79 + 175)) == (3394 - 1241)) and (v128 == (0 + 0))) then
				if (((v67 > (0 - 0)) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78)) and (v72 <= (0 - 0))) or ((1406 - (503 + 396)) >= (2772 - (92 + 89)))) then
					v72 = (232 - 112) + v77;
				end
				if (((2299 + 2182) == (2653 + 1828)) and v60.HandofGuldan:IsReady() and (v76 > (0 - 0)) and (v67 > (v78 + v60.SummonDemonicTyrant:CastTime())) and (v67 < (v78 * (1 + 3)))) then
					if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((5307 - 2979) < (605 + 88))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((2068 + 2260) == (13181 - 8853)) and (v67 > (0 + 0)) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78))) then
					local v148 = 0 - 0;
					local v149;
					local v150;
					while true do
						if (((2832 - (485 + 759)) >= (3081 - 1749)) and (v148 == (1191 - (442 + 747)))) then
							v150 = v82.HandleDPSPotion();
							if (v150 or ((5309 - (832 + 303)) > (5194 - (88 + 858)))) then
								return v150;
							end
							break;
						end
						if ((v148 == (1 + 0)) or ((3796 + 790) <= (4 + 78))) then
							v149 = v105();
							if (((4652 - (766 + 23)) == (19070 - 15207)) and v149) then
								return v149;
							end
							v148 = 2 - 0;
						end
						if ((v148 == (0 - 0)) or ((956 - 674) <= (1115 - (1036 + 37)))) then
							v149 = v104();
							if (((3268 + 1341) >= (1491 - 725)) and v149) then
								return v149;
							end
							v148 = 1 + 0;
						end
					end
				end
				if ((v60.SummonDemonicTyrant:IsCastable() and (v67 > (1480 - (641 + 839))) and (v67 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v78) + v78))) or ((2065 - (910 + 3)) == (6342 - 3854))) then
					if (((5106 - (1466 + 218)) > (1540 + 1810)) and v24(v60.SummonDemonicTyrant, nil, nil, v56)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v128 = 1149 - (556 + 592);
			end
			if (((312 + 565) > (1184 - (329 + 479))) and (v128 == (857 - (174 + 680)))) then
				if ((v60.HandofGuldan:IsReady() and (((v76 > (6 - 4)) and (v93() or (not v60.SummonVilefiend:IsAvailable() and v91())) and ((v76 > (3 - 1)) or (v92() < ((v78 * (2 + 0)) + ((741 - (396 + 343)) / v13:SpellHaste()))))) or (not v91() and (v76 == (1 + 4))))) or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
					if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((621 - 456) >= (16304 - 12812))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((2632 + 1317) < (6383 - (389 + 1138))) and v60.Demonbolt:IsReady() and (v76 < (578 - (102 + 472))) and (v13:BuffStack(v60.DemonicCoreBuff) > (1 + 0)) and (v93() or (not v60.SummonVilefiend:IsAvailable() and v91()) or not v22())) then
					if ((v60.DoomBrandDebuff:AuraActiveCount() == v81) or not v13:HasTier(18 + 13, 2 + 0) or ((5821 - (320 + 1225)) < (5368 - 2352))) then
						if (((2870 + 1820) > (5589 - (157 + 1307))) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt tyrant 26";
						end
					elseif (v82.CastCycle(v60.Demonbolt, v80, v99, not v14:IsSpellInRange(v60.Demonbolt)) or ((1909 - (821 + 1038)) >= (2235 - 1339))) then
						return "demonbolt tyrant 27";
					end
				end
				if ((v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) < (1 + 2)) and (v67 > (v60.SummonDemonicTyrant:ExecuteTime() + (v78 * (4 - 1))))) or (v67 == (0 + 0)))) or ((4248 - 2534) >= (3984 - (834 + 192)))) then
					if (v23(v60.PowerSiphon) or ((95 + 1396) < (166 + 478))) then
						return "power_siphon tyrant 28";
					end
				end
				if (((16 + 688) < (1528 - 541)) and v60.ShadowBolt:IsCastable()) then
					if (((4022 - (300 + 4)) > (510 + 1396)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if ((v128 == (5 - 3)) or ((1320 - (112 + 250)) > (1450 + 2185))) then
				if (((8770 - 5269) <= (2574 + 1918)) and v60.NetherPortal:IsReady() and (v76 == (3 + 2))) then
					if (v23(v60.NetherPortal, v54) or ((2575 + 867) < (1264 + 1284))) then
						return "nether_portal tyrant 16";
					end
				end
				if (((2136 + 739) >= (2878 - (1001 + 413))) and v60.SummonVilefiend:IsReady() and ((v76 == (11 - 6)) or v13:BuffUp(v60.NetherPortalBuff)) and (v60.SummonDemonicTyrant:CooldownRemains() < (895 - (244 + 638))) and v68) then
					if (v23(v60.SummonVilefiend) or ((5490 - (627 + 66)) >= (14579 - 9686))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v60.CallDreadstalkers:IsReady() and (v93() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (632 - (512 + 90)))) and (v13:BuffUp(v60.NetherPortalBuff) or v87() or (v76 == (1911 - (1665 + 241)))))) and (v60.SummonDemonicTyrant:CooldownRemains() < (728 - (373 + 344))) and v68) or ((249 + 302) > (548 + 1520))) then
					if (((5575 - 3461) > (1597 - 653)) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v60.GrimoireFelguard:IsReady() and (v93() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (1129 - (35 + 1064)))) and (v13:BuffUp(v60.NetherPortalBuff) or v91() or (v76 == (4 + 1))) and v68))) or ((4839 - 2577) >= (13 + 3083))) then
					if (v23(v60.GrimoireFelguard, v52) or ((3491 - (298 + 938)) >= (4796 - (233 + 1026)))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v128 = 1669 - (636 + 1030);
			end
			if ((v128 == (1 + 0)) or ((3748 + 89) < (388 + 918))) then
				if (((200 + 2750) == (3171 - (55 + 166))) and v60.Implosion:IsReady() and (v84() > (1 + 1)) and not v91() and not v87() and not v93() and ((v81 > (1 + 2)) or ((v81 > (7 - 5)) and v60.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(298 - (36 + 261), v60.Implosion)) then
					if (v23(v60.Implosion, v53, nil, not v14:IsInRange(69 - 29)) or ((6091 - (34 + 1334)) < (1268 + 2030))) then
						return "implosion tyrant 8";
					end
				end
				if (((883 + 253) >= (1437 - (1035 + 248))) and v60.ShadowBolt:IsReady() and v13:PrevGCDP(22 - (20 + 1), v60.GrimoireFelguard) and (v77 > (16 + 14)) and v13:BuffDown(v60.NetherPortalBuff) and v13:BuffDown(v60.DemonicCoreBuff)) then
					if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((590 - (134 + 185)) > (5881 - (549 + 584)))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if (((5425 - (314 + 371)) >= (10820 - 7668)) and v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (972 - (478 + 490))) and (not v93() or (not v60.SummonVilefiend:IsAvailable() and v90())) and v13:BuffDown(v60.NetherPortalBuff)) then
					if (v23(v60.PowerSiphon, v55) or ((1366 + 1212) >= (4562 - (786 + 386)))) then
						return "power_siphon tyrant 12";
					end
				end
				if (((132 - 91) <= (3040 - (1055 + 324))) and v60.ShadowBolt:IsReady() and not v93() and v13:BuffDown(v60.NetherPortalBuff) and not v91() and (v76 < ((1345 - (1093 + 247)) - v13:BuffStack(v60.DemonicCoreBuff)))) then
					if (((535 + 66) < (375 + 3185)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v128 = 7 - 5;
			end
		end
	end
	local function v107()
		local v129 = 0 - 0;
		while true do
			if (((668 - 433) < (1726 - 1039)) and ((1 + 1) == v129)) then
				if (((17524 - 12975) > (3973 - 2820)) and v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (3 + 0)) and (v65 < (51 - 31))) then
					if (v23(v60.PowerSiphon, v55) or ((5362 - (364 + 324)) < (12807 - 8135))) then
						return "power_siphon fight_end 14";
					end
				end
				if (((8801 - 5133) < (1512 + 3049)) and v60.Implosion:IsReady() and v53 and (v65 < ((8 - 6) * v78))) then
					if (v23(v60.Implosion, nil, nil, not v14:IsInRange(64 - 24)) or ((1381 - 926) == (4873 - (1249 + 19)))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if ((v129 == (1 + 0)) or ((10365 - 7702) == (4398 - (686 + 400)))) then
				if (((3356 + 921) <= (4704 - (73 + 156))) and v60.NetherPortal:IsReady() and v54 and (v65 < (1 + 29))) then
					if (v23(v60.NetherPortal) or ((1681 - (721 + 90)) == (14 + 1175))) then
						return "nether_portal fight_end 8";
					end
				end
				if (((5042 - 3489) <= (3603 - (224 + 246))) and v60.DemonicStrength:IsCastable() and (v65 < (16 - 6))) then
					if (v23(v60.DemonicStrength, v51) or ((4118 - 1881) >= (637 + 2874))) then
						return "demonic_strength fight_end 12";
					end
				end
				v129 = 1 + 1;
			end
			if ((v129 == (0 + 0)) or ((2631 - 1307) > (10050 - 7030))) then
				if ((v60.SummonDemonicTyrant:IsCastable() and (v65 < (533 - (203 + 310)))) or ((4985 - (1238 + 755)) == (132 + 1749))) then
					if (((4640 - (709 + 825)) > (2811 - 1285)) and v24(v60.SummonDemonicTyrant, nil, nil, v56)) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if (((4402 - 1379) < (4734 - (196 + 668))) and (v65 < (78 - 58))) then
					if (((295 - 152) > (907 - (171 + 662))) and v60.GrimoireFelguard:IsReady() and v52) then
						if (((111 - (4 + 89)) < (7402 - 5290)) and v23(v60.GrimoireFelguard)) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (((400 + 697) <= (7150 - 5522)) and v60.CallDreadstalkers:IsReady()) then
						if (((1816 + 2814) == (6116 - (35 + 1451))) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					if (((4993 - (28 + 1425)) > (4676 - (941 + 1052))) and v60.SummonVilefiend:IsReady()) then
						if (((4597 + 197) >= (4789 - (822 + 692))) and v23(v60.SummonVilefiend)) then
							return "summon_vilefiend fight_end 6";
						end
					end
				end
				v129 = 1 - 0;
			end
		end
	end
	local v108 = 0 + 0;
	local v109 = false;
	function UpdateLastMoveTime()
		if (((1781 - (45 + 252)) == (1469 + 15)) and v13:IsMoving()) then
			if (((493 + 939) < (8652 - 5097)) and not v109) then
				v108 = GetTime();
				v109 = true;
			end
		else
			v109 = false;
		end
	end
	local function v110()
		if (v13:AffectingCombat() or ((1498 - (114 + 319)) > (5136 - 1558))) then
			if (((v13:HealthPercentage() <= v48) and v60.DarkPact:IsCastable() and not v13:BuffUp(v60.DarkPact)) or ((6144 - 1349) < (897 + 510))) then
				if (((2760 - 907) < (10084 - 5271)) and v24(v60.DarkPact)) then
					return "dark_pact defensive 2";
				end
			end
			if (((v13:HealthPercentage() <= v44) and v60.DrainLife:IsCastable()) or ((4784 - (556 + 1407)) < (3637 - (741 + 465)))) then
				if (v24(v60.DrainLife) or ((3339 - (170 + 295)) < (1150 + 1031))) then
					return "drain_life defensive 2";
				end
			end
			if (((v13:HealthPercentage() <= v45) and v60.HealthFunnel:IsCastable()) or ((2470 + 219) <= (844 - 501))) then
				if (v24(v60.HealthFunnel) or ((1550 + 319) == (1289 + 720))) then
					return "health_funnel defensive 2";
				end
			end
			if (((v13:HealthPercentage() <= v46) and v60.UnendingResolve:IsCastable()) or ((2008 + 1538) < (3552 - (957 + 273)))) then
				if (v24(v60.UnendingResolve) or ((557 + 1525) == (1911 + 2862))) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v111()
		local v130 = 0 - 0;
		while true do
			if (((8548 - 5304) > (3222 - 2167)) and ((0 - 0) == v130)) then
				v59();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v130 = 1781 - (389 + 1391);
			end
			if (((1 + 0) == v130) or ((345 + 2968) <= (4047 - 2269))) then
				if (v31 or ((2372 - (783 + 168)) >= (7061 - 4957))) then
					local v151 = 0 + 0;
					while true do
						if (((2123 - (309 + 2)) <= (9977 - 6728)) and (v151 == (1212 - (1090 + 122)))) then
							v80 = v14:GetEnemiesInSplashRange(3 + 5);
							v79 = v13:GetEnemiesInRange(134 - 94);
							v151 = 1 + 0;
						end
						if (((2741 - (628 + 490)) <= (351 + 1606)) and (v151 == (2 - 1))) then
							v81 = v28(#v80, #v79);
							break;
						end
					end
				else
					v80 = {};
					v79 = {};
					v81 = 4 - 3;
				end
				UpdateLastMoveTime();
				if (((5186 - (431 + 343)) == (8910 - 4498)) and (v82.TargetIsValid() or v13:AffectingCombat())) then
					v64 = v10.BossFightRemains();
					v65 = v64;
					if (((5062 - 3312) >= (666 + 176)) and (v65 == (1422 + 9689))) then
						v65 = v10.FightRemains(v80, false);
					end
					v25.UpdatePetTable();
					v25.UpdateSoulShards();
					v77 = v10.CombatTime();
					v76 = v13:SoulShardsP();
					v78 = v13:GCD() + (1695.25 - (556 + 1139));
				end
				if (((4387 - (6 + 9)) > (339 + 1511)) and v60.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v47 and not v17:IsActive()) then
					if (((119 + 113) < (990 - (28 + 141))) and v24(v60.SummonPet, false, true)) then
						return "summon_pet ooc";
					end
				end
				v130 = 1 + 1;
			end
			if (((638 - 120) < (639 + 263)) and ((1319 - (486 + 831)) == v130)) then
				if (((7791 - 4797) > (3020 - 2162)) and v61.Healthstone:IsReady() and v38 and (v13:HealthPercentage() <= v39)) then
					if (v24(v62.Healthstone) or ((710 + 3045) <= (2893 - 1978))) then
						return "healthstone defensive 3";
					end
				end
				if (((5209 - (668 + 595)) > (3369 + 374)) and v35 and (v13:HealthPercentage() <= v37)) then
					local v152 = 0 + 0;
					while true do
						if ((v152 == (0 - 0)) or ((1625 - (23 + 267)) >= (5250 - (1129 + 815)))) then
							if (((5231 - (371 + 16)) > (4003 - (1326 + 424))) and (v36 == "Refreshing Healing Potion")) then
								if (((855 - 403) == (1651 - 1199)) and v61.RefreshingHealingPotion:IsReady()) then
									if (v24(v62.RefreshingHealingPotion) or ((4675 - (88 + 30)) < (2858 - (720 + 51)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((8617 - 4743) == (5650 - (421 + 1355))) and (v36 == "Dreamwalker's Healing Potion")) then
								if (v61.DreamwalkersHealingPotion:IsReady() or ((3197 - 1259) > (2425 + 2510))) then
									if (v24(v62.RefreshingHealingPotion) or ((5338 - (286 + 797)) < (12513 - 9090))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((2408 - 954) <= (2930 - (397 + 42))) and v82.TargetIsValid()) then
					if ((not v13:AffectingCombat() and v30 and not v13:IsCasting(v60.ShadowBolt)) or ((1299 + 2858) <= (3603 - (24 + 776)))) then
						local v154 = v101();
						if (((7476 - 2623) >= (3767 - (222 + 563))) and v154) then
							return v154;
						end
					end
					if (((9108 - 4974) > (2417 + 940)) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v155 = 190 - (23 + 167);
						local v156;
						while true do
							if ((v155 == (1801 - (690 + 1108))) or ((1233 + 2184) < (2091 + 443))) then
								if (v156 or ((3570 - (40 + 808)) <= (28 + 136))) then
									return v156;
								end
								v156 = v82.InterruptWithStun(v60.AxeToss, 152 - 112, true, v16, v62.AxeTossMouseover);
								if (v156 or ((2302 + 106) < (1116 + 993))) then
									return v156;
								end
								break;
							end
							if ((v155 == (2 + 0)) or ((604 - (47 + 524)) == (945 + 510))) then
								v156 = v82.Interrupt(v60.AxeToss, 109 - 69, true, v16, v62.AxeTossMouseover);
								if (v156 or ((662 - 219) >= (9156 - 5141))) then
									return v156;
								end
								v156 = v82.InterruptWithStun(v60.AxeToss, 1766 - (1165 + 561), true);
								v155 = 1 + 2;
							end
							if (((10474 - 7092) > (64 + 102)) and ((480 - (341 + 138)) == v155)) then
								if (v156 or ((76 + 204) == (6312 - 3253))) then
									return v156;
								end
								v156 = v82.Interrupt(v60.AxeToss, 366 - (89 + 237), true);
								if (((6051 - 4170) > (2722 - 1429)) and v156) then
									return v156;
								end
								v155 = 883 - (581 + 300);
							end
							if (((3577 - (855 + 365)) == (5598 - 3241)) and (v155 == (0 + 0))) then
								v156 = v82.Interrupt(v60.SpellLock, 1275 - (1030 + 205), true);
								if (((116 + 7) == (115 + 8)) and v156) then
									return v156;
								end
								v156 = v82.Interrupt(v60.SpellLock, 326 - (156 + 130), true, v16, v62.SpellLockMouseover);
								v155 = 2 - 1;
							end
						end
					end
					if ((v13:AffectingCombat() and v57) or ((1779 - 723) >= (6946 - 3554))) then
						if ((v60.BurningRush:IsCastable() and not v13:BuffUp(v60.BurningRush) and v109 and ((GetTime() - v108) >= (1 + 0)) and (v13:HealthPercentage() >= v58)) or ((631 + 450) < (1144 - (10 + 59)))) then
							if (v24(v60.BurningRush) or ((297 + 752) >= (21826 - 17394))) then
								return "burning_rush defensive 2";
							end
						elseif ((v60.BurningRush:IsCastable() and v13:BuffUp(v60.BurningRush) and (not v109 or (v13:HealthPercentage() <= v58))) or ((5931 - (671 + 492)) <= (674 + 172))) then
							if (v24(v62.CancelBurningRush) or ((4573 - (369 + 846)) <= (376 + 1044))) then
								return "burning_rush defensive 4";
							end
						end
					end
					local v153 = v110();
					if (v153 or ((3191 + 548) <= (4950 - (1036 + 909)))) then
						return v153;
					end
					if ((v60.UnendingResolve:IsReady() and (v13:HealthPercentage() < v46)) or ((1320 + 339) >= (3582 - 1448))) then
						if (v24(v60.UnendingResolve) or ((3463 - (11 + 192)) < (1191 + 1164))) then
							return "unending_resolve defensive";
						end
					end
					v102();
					if (v89() or (v65 < (197 - (135 + 40))) or ((1620 - 951) == (2546 + 1677))) then
						local v157 = 0 - 0;
						local v158;
						while true do
							if ((v157 == (0 - 0)) or ((1868 - (50 + 126)) < (1637 - 1049))) then
								v158 = v105();
								if ((v158 and v33 and v32) or ((1062 + 3735) < (5064 - (1233 + 180)))) then
									return v158;
								end
								break;
							end
						end
					end
					local v153 = v104();
					if (v153 or ((5146 - (522 + 447)) > (6271 - (107 + 1314)))) then
						return v153;
					end
					if ((v65 < (14 + 16)) or ((1218 - 818) > (472 + 639))) then
						local v159 = v107();
						if (((6058 - 3007) > (3976 - 2971)) and v159) then
							return v159;
						end
					end
					if (((5603 - (716 + 1194)) <= (75 + 4307)) and v60.HandofGuldan:IsReady() and (v77 < (0.5 + 0)) and (((v65 % (598 - (74 + 429))) > (77 - 37)) or ((v65 % (48 + 47)) < (34 - 19))) and (v60.ReignofTyranny:IsAvailable() or (v81 > (2 + 0)))) then
						if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((10117 - 6835) > (10137 - 6037))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((v60.SummonDemonicTyrant:CooldownRemains() < (448 - (279 + 154))) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (783 - (454 + 324)))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (4 + 1))) and ((v60.GrimoireFelguard:CooldownRemains() < (27 - (12 + 5))) or not v13:HasTier(17 + 13, 4 - 2)) and ((v74 < (6 + 9)) or (v65 < (1133 - (277 + 816))) or v13:PowerInfusionUp())) or (v60.SummonVilefiend:IsAvailable() and (v60.SummonDemonicTyrant:CooldownRemains() < (63 - 48)) and (v60.SummonVilefiend:CooldownRemains() < (v78 * (1188 - (1058 + 125)))) and (v60.CallDreadstalkers:CooldownRemains() < (v78 * (1 + 4))) and ((v60.GrimoireFelguard:CooldownRemains() < (985 - (815 + 160))) or not v13:HasTier(128 - 98, 4 - 2)) and ((v74 < (4 + 11)) or (v65 < (116 - 76)) or v13:PowerInfusionUp())) or ((5478 - (41 + 1857)) < (4737 - (1222 + 671)))) then
						local v160 = v106();
						if (((229 - 140) < (6454 - 1964)) and v160) then
							return v160;
						end
					end
					if (((v60.SummonDemonicTyrant:CooldownRemains() < (1197 - (229 + 953))) and (v93() or (not v60.SummonVilefiend:IsAvailable() and (v87() or v60.GrimoireFelguard:CooldownUp() or not v13:HasTier(1804 - (1111 + 663), 1581 - (874 + 705))))) and ((v74 < (3 + 12)) or v87() or (v65 < (28 + 12)) or v13:PowerInfusionUp())) or ((10357 - 5374) < (51 + 1757))) then
						local v161 = 679 - (642 + 37);
						local v162;
						while true do
							if (((874 + 2955) > (603 + 3166)) and (v161 == (0 - 0))) then
								v162 = v106();
								if (((1939 - (233 + 221)) <= (6714 - 3810)) and v162) then
									return v162;
								end
								break;
							end
						end
					end
					if (((3758 + 511) == (5810 - (718 + 823))) and v60.SummonDemonicTyrant:IsCastable() and v56 and (v93() or v87() or (v60.GrimoireFelguard:CooldownRemains() > (57 + 33)))) then
						if (((1192 - (266 + 539)) <= (7876 - 5094)) and v23(v60.SummonDemonicTyrant)) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if ((v60.SummonVilefiend:IsReady() and (v60.SummonDemonicTyrant:CooldownRemains() > (1270 - (636 + 589)))) or ((4507 - 2608) <= (1891 - 974))) then
						if (v23(v60.SummonVilefiend) or ((3418 + 894) <= (319 + 557))) then
							return "summon_vilefiend main 6";
						end
					end
					if (((3247 - (657 + 358)) <= (6873 - 4277)) and v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (((not v60.SoulStrike:IsAvailable() or (v60.SoulStrike:CooldownRemains() > (v78 * (4 - 2)))) and (v76 < (1191 - (1151 + 36)))) or (v76 < ((4 + 0) - (v26(v81 > (1 + 1)))))) and not v13:PrevGCDP(2 - 1, v60.Demonbolt) and v13:HasTier(1863 - (1552 + 280), 836 - (64 + 770))) then
						if (((1423 + 672) < (8367 - 4681)) and v82.CastCycle(v60.Demonbolt, v80, v96, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt main 8";
						end
					end
					if ((v60.PowerSiphon:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and (v14:DebuffDown(v60.DoomBrandDebuff) or (not v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v78 + v60.Demonbolt:TravelTime()))) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v78 + v60.Demonbolt:TravelTime() + 1 + 2)))) and v13:HasTier(1274 - (157 + 1086), 3 - 1)) or ((6985 - 5390) >= (6862 - 2388))) then
						if (v23(v60.PowerSiphon, v55) or ((6303 - 1684) < (3701 - (599 + 220)))) then
							return "power_siphon main 10";
						end
					end
					if ((v60.DemonicStrength:IsCastable() and (v13:BuffRemains(v60.NetherPortalBuff) < v78)) or ((585 - 291) >= (6762 - (1813 + 118)))) then
						if (((1484 + 545) <= (4301 - (841 + 376))) and v23(v60.DemonicStrength, v51)) then
							return "demonic_strength main 12";
						end
					end
					if ((v60.BilescourgeBombers:IsReady() and v60.BilescourgeBombers:IsCastable()) or ((2854 - 817) == (563 + 1857))) then
						if (((12168 - 7710) > (4763 - (464 + 395))) and v23(v60.BilescourgeBombers, nil, nil, not v14:IsInRange(102 - 62))) then
							return "bilescourge_bombers main 14";
						end
					end
					if (((210 + 226) >= (960 - (467 + 370))) and v60.Guillotine:IsCastable() and v50 and (v13:BuffRemains(v60.NetherPortalBuff) < v78) and (v60.DemonicStrength:CooldownDown() or not v60.DemonicStrength:IsAvailable())) then
						if (((1033 - 533) < (1334 + 482)) and v23(v62.GuillotineCursor, nil, nil, not v14:IsInRange(137 - 97))) then
							return "guillotine main 16";
						end
					end
					if (((558 + 3016) == (8314 - 4740)) and v60.CallDreadstalkers:IsReady() and ((v60.SummonDemonicTyrant:CooldownRemains() > (545 - (150 + 370))) or (v74 > (1307 - (74 + 1208))) or v13:BuffUp(v60.NetherPortalBuff))) then
						if (((543 - 322) < (1849 - 1459)) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
							return "call_dreadstalkers main 18";
						end
					end
					if ((v60.Implosion:IsReady() and (v85(2 + 0) > (390 - (14 + 376))) and v69 and not v13:PrevGCDP(1 - 0, v60.Implosion)) or ((1432 + 781) <= (1249 + 172))) then
						if (((2917 + 141) < (14240 - 9380)) and v23(v60.Implosion, v53, nil, not v14:IsInRange(31 + 9))) then
							return "implosion main 20";
						end
					end
					if ((v60.SummonSoulkeeper:IsReady() and (v60.SummonSoulkeeper:Count() == (88 - (23 + 55))) and (v81 > (2 - 1))) or ((865 + 431) >= (3993 + 453))) then
						if (v23(v60.SummonSoulkeeper) or ((2159 - 766) > (1413 + 3076))) then
							return "soul_strike main 22";
						end
					end
					if ((v60.HandofGuldan:IsReady() and (((v76 > (903 - (652 + 249))) and (v60.CallDreadstalkers:CooldownRemains() > (v78 * (10 - 6))) and (v60.SummonDemonicTyrant:CooldownRemains() > (1885 - (708 + 1160)))) or (v76 == (13 - 8)) or ((v76 == (6 - 2)) and v60.SoulStrike:IsAvailable() and (v60.SoulStrike:CooldownRemains() < (v78 * (29 - (10 + 17)))))) and (v81 == (1 + 0)) and v60.GrandWarlocksDesign:IsAvailable()) or ((6156 - (1400 + 332)) < (51 - 24))) then
						if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((3905 - (242 + 1666)) > (1633 + 2182))) then
							return "hand_of_guldan main 26";
						end
					end
					if (((1270 + 2195) > (1631 + 282)) and v60.HandofGuldan:IsReady() and (v76 > (942 - (850 + 90))) and not ((v81 == (1 - 0)) and v60.GrandWarlocksDesign:IsAvailable())) then
						if (((2123 - (360 + 1030)) < (1610 + 209)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					if ((v60.Demonbolt:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) > (2 - 1)) and (((v76 < (5 - 1)) and not v60.SoulStrike:IsAvailable()) or (v60.SoulStrike:CooldownRemains() > (v78 * (1663 - (909 + 752)))) or (v76 < (1225 - (109 + 1114)))) and not v70) or ((8046 - 3651) == (1851 + 2904))) then
						if (v82.CastCycle(v60.Demonbolt, v80, v97, not v14:IsSpellInRange(v60.Demonbolt)) or ((4035 - (6 + 236)) < (1493 + 876))) then
							return "demonbolt main 30";
						end
					end
					if ((v60.Demonbolt:IsReady() and v13:HasTier(25 + 6, 4 - 2) and v13:BuffUp(v60.DemonicCoreBuff) and (v76 < (6 - 2)) and not v70) or ((5217 - (1076 + 57)) == (44 + 221))) then
						if (((5047 - (579 + 110)) == (345 + 4013)) and v82.CastTargetIf(v60.Demonbolt, v80, "==", v97, v100, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt main 32";
						end
					end
					if ((v60.Demonbolt:IsReady() and (v65 < (v13:BuffStack(v60.DemonicCoreBuff) * v78))) or ((2775 + 363) < (528 + 465))) then
						if (((3737 - (174 + 233)) > (6488 - 4165)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt main 34";
						end
					end
					if ((v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (v60.PowerSiphon:CooldownRemains() < (6 - 2)) and (v76 < (2 + 2)) and not v70) or ((4800 - (663 + 511)) == (3559 + 430))) then
						if (v82.CastCycle(v60.Demonbolt, v80, v97, not v14:IsSpellInRange(v60.Demonbolt)) or ((199 + 717) == (8234 - 5563))) then
							return "demonbolt main 36";
						end
					end
					if (((165 + 107) == (640 - 368)) and v60.PowerSiphon:IsReady() and (v13:BuffDown(v60.DemonicCoreBuff))) then
						if (((10285 - 6036) <= (2310 + 2529)) and v23(v60.PowerSiphon, v55)) then
							return "power_siphon main 38";
						end
					end
					if (((5404 - 2627) < (2281 + 919)) and v60.SummonVilefiend:IsReady() and (v65 < (v60.SummonDemonicTyrant:CooldownRemains() + 1 + 4))) then
						if (((817 - (478 + 244)) < (2474 - (440 + 77))) and v23(v60.SummonVilefiend)) then
							return "summon_vilefiend main 40";
						end
					end
					if (((376 + 450) < (6284 - 4567)) and v60.Doom:IsReady()) then
						if (((2982 - (655 + 901)) >= (205 + 900)) and v82.CastCycle(v60.Doom, v79, v98, not v14:IsSpellInRange(v60.Doom))) then
							return "doom main 42";
						end
					end
					if (((2109 + 645) <= (2282 + 1097)) and v60.ShadowBolt:IsCastable()) then
						if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((15820 - 11893) == (2858 - (695 + 750)))) then
							return "shadow_bolt main 44";
						end
					end
				end
				break;
			end
		end
	end
	local function v112()
		v60.DoomBrandDebuff:RegisterAuraTracking();
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(907 - 641, v111, v112);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

