local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 + 0;
	local v7;
	while true do
		if ((v6 == (762 - (418 + 344))) or ((1199 - (192 + 134)) == (3310 - (316 + 960)))) then
			v7 = v1[v5];
			if (not v7 or ((1568 + 1248) < (9 + 2))) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
		if (((14141 - 10442) < (5257 - (83 + 468))) and (v6 == (1807 - (1202 + 604)))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Warlock_Demonology.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.Focus;
	local v17 = v13.MouseOver;
	local v18 = v13.Pet;
	local v19 = v11.Spell;
	local v20 = v11.Item;
	local v21 = v11.Macro;
	local v22 = v11.AoEON;
	local v23 = v11.CDsON;
	local v24 = v11.Cast;
	local v25 = v11.Press;
	local v26 = v11.Commons.Warlock;
	local v27 = v11.Commons.Everyone.num;
	local v28 = v11.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = math.min;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v47;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local function v60()
		local v115 = 0 - 0;
		while true do
			if (((4403 - 1757) >= (2425 - 1549)) and (v115 == (331 - (45 + 280)))) then
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
				v115 = 7 + 0;
			end
			if (((225 + 389) <= (1762 + 1422)) and (v115 == (1 + 4))) then
				v52 = EpicSettings.Settings['DemonicStrength'];
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v115 = 10 - 4;
			end
			if (((5037 - (340 + 1571)) == (1233 + 1893)) and (v115 == (1773 - (1733 + 39)))) then
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v38 = EpicSettings.Settings['HealingPotionHP'] or (1034 - (125 + 909));
				v39 = EpicSettings.Settings['UseHealthstone'] or (1948 - (1096 + 852));
				v115 = 1 + 1;
			end
			if ((v115 == (9 - 2)) or ((2122 + 65) >= (5466 - (409 + 103)))) then
				v58 = EpicSettings.Settings['UseBurningRush'] or (236 - (46 + 190));
				v59 = EpicSettings.Settings['BurningRushHP'] or (95 - (51 + 44));
				v45 = EpicSettings.Settings['DrainLifeHP'] or (0 + 0);
				v115 = 1325 - (1114 + 203);
			end
			if ((v115 == (730 - (228 + 498))) or ((840 + 3037) == (1976 + 1599))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (663 - (174 + 489));
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				v115 = 1910 - (830 + 1075);
			end
			if (((1231 - (303 + 221)) > (1901 - (231 + 1038))) and (v115 == (0 + 0))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v115 = 1163 - (171 + 991);
			end
			if (((32 - 24) == v115) or ((1466 - 920) >= (6697 - 4013))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (0 + 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				break;
			end
			if (((4226 - 2761) <= (6932 - 2631)) and (v115 == (9 - 6))) then
				v43 = EpicSettings.Settings['InterruptThreshold'] or (1248 - (111 + 1137));
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (158 - (91 + 67));
				v115 = 11 - 7;
			end
			if (((426 + 1278) > (1948 - (423 + 100))) and (v115 == (1 + 1))) then
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (771 - (326 + 445));
				v115 = 13 - 10;
			end
		end
	end
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = v21.Warlock.Demonology;
	local v64 = {};
	local v65 = 24753 - 13642;
	local v66 = 25935 - 14824;
	local v67 = (725 - (530 + 181)) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	local v68 = 881 - (614 + 267);
	local v69 = false;
	local v70 = false;
	local v71 = false;
	local v72 = 32 - (19 + 13);
	local v73 = 0 - 0;
	local v74 = 0 - 0;
	local v75 = 342 - 222;
	local v76 = 4 + 8;
	local v77 = 0 - 0;
	local v78 = 0 - 0;
	local v79 = 1812 - (1293 + 519);
	local v80;
	local v81, v82;
	v11:RegisterForEvent(function()
		v65 = 22669 - 11558;
		v66 = 29010 - 17899;
	end, "PLAYER_REGEN_ENABLED");
	local v83 = v11.Commons.Everyone;
	local v84 = {{v61.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v11:RegisterForEvent(function()
		v61.HandofGuldan:RegisterInFlight();
		v67 = 3 + 11 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	end, "LEARNED_SPELL_IN_TAB");
	v61.HandofGuldan:RegisterInFlight();
	local function v85()
		return v11.GuardiansTable.ImpCount or (0 - 0);
	end
	local function v86(v116)
		local v117 = 0 + 0;
		local v118;
		while true do
			if ((v117 == (1 + 0)) or ((430 + 257) == (5330 - (709 + 387)))) then
				return v118;
			end
			if (((1858 - (673 + 1185)) == v117) or ((9657 - 6327) < (4588 - 3159))) then
				v118 = 0 - 0;
				for v151, v152 in pairs(v11.GuardiansTable.Pets) do
					if (((821 + 326) >= (251 + 84)) and (v152.ImpCasts <= v116)) then
						v118 = v118 + (1 - 0);
					end
				end
				v117 = 1 + 0;
			end
		end
	end
	local function v87()
		return v11.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v88()
		return v87() > (0 - 0);
	end
	local function v89()
		return v11.GuardiansTable.DemonicTyrantDuration or (1880 - (446 + 1434));
	end
	local function v90()
		return v89() > (1283 - (1040 + 243));
	end
	local function v91()
		return v11.GuardiansTable.DreadstalkerDuration or (0 - 0);
	end
	local function v92()
		return v91() > (1847 - (559 + 1288));
	end
	local function v93()
		return v11.GuardiansTable.VilefiendDuration or (1931 - (609 + 1322));
	end
	local function v94()
		return v93() > (454 - (13 + 441));
	end
	local function v95()
		return v11.GuardiansTable.PitLordDuration or (0 - 0);
	end
	local function v96()
		return v95() > (0 - 0);
	end
	local function v97(v119)
		return v119:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (14 - 11)));
	end
	local function v98(v120)
		return (v120:DebuffDown(v61.DoomBrandDebuff)) or (v82 < (1 + 3));
	end
	local function v99(v121)
		return (v121:DebuffRefreshable(v61.Doom));
	end
	local function v100(v122)
		return (v122:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v101(v123)
		return v123:DebuffRemains(v61.DoomBrandDebuff) > (36 - 26);
	end
	local function v102()
		local v124 = 0 + 0;
		while true do
			if (((1506 + 1929) > (6222 - 4125)) and ((2 + 0) == v124)) then
				if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v85(), 3 - 1)) <= (3 + 1)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (2 + 1)))) or ((2709 + 1061) >= (3394 + 647))) then
					if (v24(v61.PowerSiphon) or ((3710 + 81) <= (2044 - (153 + 280)))) then
						return "power_siphon precombat 2";
					end
				end
				if ((v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) or ((13219 - 8641) <= (1803 + 205))) then
					if (((445 + 680) <= (1087 + 989)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt precombat 3";
					end
				end
				v124 = 3 + 0;
			end
			if ((v124 == (3 + 0)) or ((1131 - 388) >= (2719 + 1680))) then
				if (((1822 - (89 + 578)) < (1196 + 477)) and v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(1 - 0, v61.PowerSiphon)) then
					if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((3373 - (572 + 477)) <= (78 + 500))) then
						return "demonbolt precombat 4";
					end
				end
				if (((2261 + 1506) == (450 + 3317)) and v61.ShadowBolt:IsReady()) then
					if (((4175 - (84 + 2)) == (6738 - 2649)) and v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((3212 + 1246) >= (2516 - (497 + 345))) and (v124 == (0 + 0))) then
				v76 = 3 + 9;
				v67 = (1347 - (605 + 728)) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
				v124 = 1 + 0;
			end
			if (((2160 - 1188) <= (65 + 1353)) and (v124 == (3 - 2))) then
				v72 = 0 + 0;
				v73 = 0 - 0;
				v124 = 2 + 0;
			end
		end
	end
	local function v103()
		if ((((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (492 - (457 + 32))) and v61.NetherPortal:IsAvailable()) or (v66 < (9 + 11)) or (v90() and (v66 < (1502 - (832 + 570)))) or (v66 < (24 + 1)) or v90() or (not v61.SummonDemonicTyrant:IsAvailable() and v92())) and (v74 <= (0 + 0))) or ((17474 - 12536) < (2294 + 2468))) then
			v73 = (916 - (588 + 208)) + v78;
		end
		v74 = v73 - v78;
		if (((((((v66 + v78) % (323 - 203)) <= (1885 - (884 + 916))) and (((v66 + v78) % (251 - 131)) >= (15 + 10))) or (v78 >= (863 - (232 + 421)))) and (v74 > (1889 - (1569 + 320))) and not v61.GrandWarlocksDesign:IsAvailable()) or ((615 + 1889) > (811 + 3453))) then
			v75 = v74;
		else
			v75 = v61.SummonDemonicTyrant:CooldownRemains();
		end
		if (((7254 - 5101) == (2758 - (316 + 289))) and v94() and v92()) then
			v68 = v30(v93(), v91()) - (v14:GCD() * (0.5 - 0));
		end
		if ((not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v92()) or ((24 + 483) >= (4044 - (666 + 787)))) then
			v68 = v30(v91(), v87()) - (v14:GCD() * (425.5 - (360 + 65)));
		end
		if (((4188 + 293) == (4735 - (79 + 175))) and not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(47 - 17, 2 + 0)) and v92()) then
			v68 = v91() - (v14:GCD() * (0.5 - 0));
		end
		if ((not v94() and v61.SummonVilefiend:IsAvailable()) or not v92() or ((4483 - 2155) < (1592 - (503 + 396)))) then
			v68 = 181 - (92 + 89);
		end
		v69 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (58 - 28)) or v14:BuffUp(v61.NetherPortalBuff);
		local v125 = v27(v61.SacrificedSouls:IsAvailable());
		v70 = false;
		if (((2220 + 2108) == (2562 + 1766)) and (v82 > ((3 - 2) + v125))) then
			v70 = not v90();
		end
		if (((218 + 1370) >= (3036 - 1704)) and (v82 > (2 + 0 + v125)) and (v82 < (3 + 2 + v125))) then
			v70 = v89() < (17 - 11);
		end
		if ((v82 > (1 + 3 + v125)) or ((6364 - 2190) > (5492 - (485 + 759)))) then
			v70 = v89() < (18 - 10);
		end
		v71 = (v61.SummonDemonicTyrant:CooldownRemains() < (1209 - (442 + 747))) and (v75 < (1155 - (832 + 303))) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (948 - (88 + 858))) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (2 + 3))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (5 + 0)));
	end
	local function v104()
		local v126 = 0 + 0;
		local v127;
		while true do
			if ((v126 == (789 - (766 + 23))) or ((22639 - 18053) <= (111 - 29))) then
				v127 = v83.HandleTopTrinket(v64, v33, 105 - 65, nil);
				if (((13111 - 9248) == (4936 - (1036 + 37))) and v127) then
					return v127;
				end
				v126 = 1 + 0;
			end
			if ((v126 == (1 - 0)) or ((222 + 60) <= (1522 - (641 + 839)))) then
				v127 = v83.HandleBottomTrinket(v64, v33, 953 - (910 + 3), nil);
				if (((11749 - 7140) >= (2450 - (1466 + 218))) and v127) then
					return v127;
				end
				break;
			end
		end
	end
	local function v105()
		local v128 = 0 + 0;
		local v129;
		while true do
			if ((v128 == (1148 - (556 + 592))) or ((410 + 742) == (3296 - (329 + 479)))) then
				if (((4276 - (174 + 680)) > (11511 - 8161)) and v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) then
					if (((1817 - 940) > (269 + 107)) and v25(v63.TimebreachingTalon)) then
						return "timebreaching_talon items 2";
					end
				end
				v129 = v104();
				v128 = 740 - (396 + 343);
			end
			if ((v128 == (1 + 0)) or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
				if (v129 or ((621 - 456) >= (16304 - 12812))) then
					return v129;
				end
				break;
			end
		end
	end
	local function v106()
		if (((2632 + 1317) < (6383 - (389 + 1138))) and v61.Berserking:IsCastable()) then
			if (v25(v61.Berserking, v34) or ((4850 - (102 + 472)) < (2847 + 169))) then
				return "berserking ogcd 4";
			end
		end
		if (((2601 + 2089) > (3847 + 278)) and v61.BloodFury:IsCastable()) then
			if (v25(v61.BloodFury, v34) or ((1595 - (320 + 1225)) >= (1594 - 698))) then
				return "blood_fury ogcd 6";
			end
		end
		if (v61.Fireblood:IsCastable() or ((1049 + 665) >= (4422 - (157 + 1307)))) then
			if (v25(v61.Fireblood, v34) or ((3350 - (821 + 1038)) < (1606 - 962))) then
				return "fireblood ogcd 8";
			end
		end
		if (((77 + 627) < (1753 - 766)) and v61.AncestralCall:IsCastable()) then
			if (((1384 + 2334) > (4724 - 2818)) and v24(v61.AncestralCall, v34)) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v107()
		if (((v68 > (1026 - (834 + 192))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79)) and (v73 <= (0 + 0))) or ((246 + 712) > (79 + 3556))) then
			v73 = (185 - 65) + v78;
		end
		if (((3805 - (300 + 4)) <= (1200 + 3292)) and v61.HandofGuldan:IsReady() and (v77 > (0 - 0)) and (v68 > (v79 + v61.SummonDemonicTyrant:CastTime())) and (v68 < (v79 * (366 - (112 + 250))))) then
			if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((1373 + 2069) < (6382 - 3834))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((1648 + 1227) >= (758 + 706)) and (v68 > (0 + 0)) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) then
			local v134 = 0 + 0;
			local v135;
			local v136;
			while true do
				if ((v134 == (2 + 0)) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
					v136 = v83.HandleDPSPotion();
					if (v136 or ((1433 - (244 + 638)) > (2761 - (627 + 66)))) then
						return v136;
					end
					break;
				end
				if (((6298 - 4184) > (1546 - (512 + 90))) and (v134 == (1906 - (1665 + 241)))) then
					v135 = v105();
					if (v135 or ((2979 - (373 + 344)) >= (1397 + 1699))) then
						return v135;
					end
					v134 = 1 + 0;
				end
				if ((v134 == (2 - 1)) or ((3815 - 1560) >= (4636 - (35 + 1064)))) then
					v135 = v106();
					if (v135 or ((2792 + 1045) < (2794 - 1488))) then
						return v135;
					end
					v134 = 1 + 1;
				end
			end
		end
		if (((4186 - (298 + 938)) == (4209 - (233 + 1026))) and v61.SummonDemonicTyrant:IsCastable() and (v68 > (1666 - (636 + 1030))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) then
			if (v25(v61.SummonDemonicTyrant, nil, nil, v57) or ((2415 + 2308) < (3222 + 76))) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if (((338 + 798) >= (11 + 143)) and v61.Implosion:IsReady() and (v85() > (223 - (55 + 166))) and not v92() and not v88() and not v94() and ((v82 > (1 + 2)) or ((v82 > (1 + 1)) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(3 - 2, v61.Implosion)) then
			if (v24(v61.Implosion, v54, nil, not v15:IsInRange(337 - (36 + 261))) or ((473 - 202) > (6116 - (34 + 1334)))) then
				return "implosion tyrant 8";
			end
		end
		if (((1823 + 2917) >= (2450 + 702)) and v61.ShadowBolt:IsReady() and v14:PrevGCDP(1284 - (1035 + 248), v61.GrimoireFelguard) and (v78 > (51 - (20 + 1))) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) then
			if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((1344 + 1234) >= (3709 - (134 + 185)))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if (((1174 - (549 + 584)) <= (2346 - (314 + 371))) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (13 - 9)) and (not v94() or (not v61.SummonVilefiend:IsAvailable() and v91())) and v14:BuffDown(v61.NetherPortalBuff)) then
			if (((1569 - (478 + 490)) < (1886 + 1674)) and v24(v61.PowerSiphon, v56)) then
				return "power_siphon tyrant 12";
			end
		end
		if (((1407 - (786 + 386)) < (2225 - 1538)) and v61.ShadowBolt:IsReady() and not v94() and v14:BuffDown(v61.NetherPortalBuff) and not v92() and (v77 < ((1384 - (1055 + 324)) - v14:BuffStack(v61.DemonicCoreBuff)))) then
			if (((5889 - (1093 + 247)) > (1025 + 128)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if ((v61.NetherPortal:IsReady() and (v77 == (1 + 4))) or ((18556 - 13882) < (15855 - 11183))) then
			if (((10437 - 6769) < (11461 - 6900)) and v24(v61.NetherPortal, v55)) then
				return "nether_portal tyrant 16";
			end
		end
		if ((v61.SummonVilefiend:IsReady() and ((v77 == (2 + 3)) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (49 - 36)) and v69) or ((1568 - 1113) == (2719 + 886))) then
			if (v24(v61.SummonVilefiend) or ((6810 - 4147) == (4000 - (364 + 324)))) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if (((11724 - 7447) <= (10738 - 6263)) and v61.CallDreadstalkers:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (10 + 20))) and (v14:BuffUp(v61.NetherPortalBuff) or v88() or (v77 == (20 - 15))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (17 - 6)) and v69) then
			if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((2642 - 1772) == (2457 - (1249 + 19)))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if (((1402 + 151) <= (12195 - 9062)) and v61.GrimoireFelguard:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (1116 - (686 + 400)))) and (v14:BuffUp(v61.NetherPortalBuff) or v92() or (v77 == (4 + 1))) and v69))) then
			if (v24(v61.GrimoireFelguard, v53) or ((2466 - (73 + 156)) >= (17 + 3494))) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if ((v61.HandofGuldan:IsReady() and (((v77 > (813 - (721 + 90))) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92())) and ((v77 > (1 + 1)) or (v93() < ((v79 * (6 - 4)) + ((472 - (224 + 246)) / v14:SpellHaste()))))) or (not v92() and (v77 == (8 - 3))))) or ((2437 - 1113) > (548 + 2472))) then
			if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((72 + 2920) == (1382 + 499))) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if (((6174 - 3068) > (5078 - 3552)) and v61.Demonbolt:IsReady() and (v77 < (517 - (203 + 310))) and (v14:BuffStack(v61.DemonicCoreBuff) > (1994 - (1238 + 755))) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92()) or not v23())) then
			if (((212 + 2811) < (5404 - (709 + 825))) and ((v61.DoomBrandDebuff:AuraActiveCount() == v82) or not v14:HasTier(56 - 25, 2 - 0))) then
				if (((1007 - (196 + 668)) > (291 - 217)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
					return "demonbolt tyrant 26";
				end
			elseif (((36 - 18) < (2945 - (171 + 662))) and v83.CastCycle(v61.Demonbolt, v81, v100, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt tyrant 27";
			end
		end
		if (((1190 - (4 + 89)) <= (5705 - 4077)) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (2 + 1)) and (v68 > (v61.SummonDemonicTyrant:ExecuteTime() + (v79 * (13 - 10))))) or (v68 == (0 + 0)))) then
			if (((6116 - (35 + 1451)) == (6083 - (28 + 1425))) and v24(v61.PowerSiphon)) then
				return "power_siphon tyrant 28";
			end
		end
		if (((5533 - (941 + 1052)) > (2573 + 110)) and v61.ShadowBolt:IsCastable()) then
			if (((6308 - (822 + 692)) >= (4675 - 1400)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v108()
		local v130 = 0 + 0;
		while true do
			if (((1781 - (45 + 252)) == (1469 + 15)) and (v130 == (0 + 0))) then
				if (((3484 - 2052) < (3988 - (114 + 319))) and v61.SummonDemonicTyrant:IsCastable() and (v66 < (28 - 8))) then
					if (v25(v61.SummonDemonicTyrant, nil, nil, v57) or ((1364 - 299) > (2281 + 1297))) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v66 < (29 - 9)) or ((10046 - 5251) < (3370 - (556 + 1407)))) then
					if (((3059 - (741 + 465)) < (5278 - (170 + 295))) and v61.GrimoireFelguard:IsReady() and v53) then
						if (v24(v61.GrimoireFelguard) or ((1487 + 1334) < (2233 + 198))) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (v61.CallDreadstalkers:IsReady() or ((7075 - 4201) < (1808 + 373))) then
						if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((1725 + 964) <= (195 + 148))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					if (v61.SummonVilefiend:IsReady() or ((3099 - (957 + 273)) == (538 + 1471))) then
						if (v24(v61.SummonVilefiend) or ((1420 + 2126) < (8847 - 6525))) then
							return "summon_vilefiend fight_end 6";
						end
					end
				end
				v130 = 2 - 1;
			end
			if ((v130 == (2 - 1)) or ((10309 - 8227) == (6553 - (389 + 1391)))) then
				if (((2036 + 1208) > (110 + 945)) and v61.NetherPortal:IsReady() and v55 and (v66 < (68 - 38))) then
					if (v24(v61.NetherPortal) or ((4264 - (783 + 168)) <= (5967 - 4189))) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v61.DemonicStrength:IsCastable() and (v66 < (10 + 0))) or ((1732 - (309 + 2)) >= (6460 - 4356))) then
					if (((3024 - (1090 + 122)) <= (1054 + 2195)) and v24(v61.DemonicStrength, v52)) then
						return "demonic_strength fight_end 12";
					end
				end
				v130 = 6 - 4;
			end
			if (((1111 + 512) <= (3075 - (628 + 490))) and (v130 == (1 + 1))) then
				if (((10923 - 6511) == (20162 - 15750)) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (777 - (431 + 343))) and (v66 < (40 - 20))) then
					if (((5062 - 3312) >= (666 + 176)) and v24(v61.PowerSiphon, v56)) then
						return "power_siphon fight_end 14";
					end
				end
				if (((560 + 3812) > (3545 - (556 + 1139))) and v61.Implosion:IsReady() and v54 and (v66 < ((17 - (6 + 9)) * v79))) then
					if (((43 + 189) < (421 + 400)) and v24(v61.Implosion, nil, nil, not v15:IsInRange(209 - (28 + 141)))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
		end
	end
	local v109 = 0 + 0;
	local v110 = false;
	function UpdateLastMoveTime()
		if (((638 - 120) < (639 + 263)) and v14:IsMoving()) then
			if (((4311 - (486 + 831)) > (2232 - 1374)) and not v110) then
				v109 = GetTime();
				v110 = true;
			end
		else
			v110 = false;
		end
	end
	local function v111()
		if (v14:AffectingCombat() or ((13219 - 9464) <= (173 + 742))) then
			local v137 = 0 - 0;
			while true do
				if (((5209 - (668 + 595)) > (3369 + 374)) and (v137 == (0 + 0))) then
					if (((v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) or ((3640 - 2305) >= (3596 - (23 + 267)))) then
						if (((6788 - (1129 + 815)) > (2640 - (371 + 16))) and v25(v61.DarkPact)) then
							return "dark_pact defensive 2";
						end
					end
					if (((2202 - (1326 + 424)) == (855 - 403)) and (v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) then
						if (v25(v61.DrainLife) or ((16652 - 12095) < (2205 - (88 + 30)))) then
							return "drain_life defensive 2";
						end
					end
					v137 = 772 - (720 + 51);
				end
				if (((8617 - 4743) == (5650 - (421 + 1355))) and (v137 == (1 - 0))) then
					if (((v14:HealthPercentage() <= v46) and v61.HealthFunnel:IsCastable()) or ((952 + 986) > (6018 - (286 + 797)))) then
						if (v25(v61.HealthFunnel) or ((15554 - 11299) < (5668 - 2245))) then
							return "health_funnel defensive 2";
						end
					end
					if (((1893 - (397 + 42)) <= (779 + 1712)) and (v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) then
						if (v25(v61.UnendingResolve) or ((4957 - (24 + 776)) <= (4318 - 1515))) then
							return "unending_resolve defensive 2";
						end
					end
					break;
				end
			end
		end
	end
	local function v112()
		local v131 = 785 - (222 + 563);
		while true do
			if (((10692 - 5839) >= (2147 + 835)) and ((193 - (23 + 167)) == v131)) then
				if (((5932 - (690 + 1108)) > (1212 + 2145)) and v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (((v77 < (852 - (40 + 808))) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v79 * (1 + 1))) or (v77 < (7 - 5))) and not v71) then
					if (v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt)) or ((3266 + 151) < (1341 + 1193))) then
						return "demonbolt main 30";
					end
				end
				if ((v61.Demonbolt:IsReady() and v14:HasTier(17 + 14, 573 - (47 + 524)) and v14:BuffUp(v61.DemonicCoreBuff) and (v77 < (3 + 1)) and not v71) or ((7440 - 4718) <= (244 - 80))) then
					if (v83.CastTargetIf(v61.Demonbolt, v81, "==", v98, v101, not v15:IsSpellInRange(v61.Demonbolt)) or ((5491 - 3083) < (3835 - (1165 + 561)))) then
						return "demonbolt main 32";
					end
				end
				if ((v61.Demonbolt:IsReady() and (v66 < (v14:BuffStack(v61.DemonicCoreBuff) * v79))) or ((1 + 32) == (4506 - 3051))) then
					if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((170 + 273) >= (4494 - (341 + 138)))) then
						return "demonbolt main 34";
					end
				end
				if (((913 + 2469) > (342 - 176)) and v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (330 - (89 + 237))) and (v77 < (12 - 8)) and not v71) then
					if (v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt)) or ((589 - 309) == (3940 - (581 + 300)))) then
						return "demonbolt main 36";
					end
				end
				v131 = 1224 - (855 + 365);
			end
			if (((4467 - 2586) > (423 + 870)) and (v131 == (1235 - (1030 + 205)))) then
				if (((2213 + 144) == (2193 + 164)) and v61.SummonDemonicTyrant:IsCastable() and v57 and (v94() or v88() or (v61.GrimoireFelguard:CooldownRemains() > (376 - (156 + 130))))) then
					if (((279 - 156) == (207 - 84)) and v24(v61.SummonDemonicTyrant)) then
						return "summon_demonic_tyrant main 4";
					end
				end
				if ((v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (92 - 47))) or ((279 + 777) >= (1978 + 1414))) then
					if (v24(v61.SummonVilefiend) or ((1150 - (10 + 59)) < (305 + 770))) then
						return "summon_vilefiend main 6";
					end
				end
				if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v79 * (9 - 7)))) and (v77 < (1167 - (671 + 492)))) or (v77 < ((4 + 0) - (v27(v82 > (1217 - (369 + 846))))))) and not v14:PrevGCDP(1 + 0, v61.Demonbolt) and v14:HasTier(27 + 4, 1947 - (1036 + 909))) or ((835 + 214) >= (7440 - 3008))) then
					if (v83.CastCycle(v61.Demonbolt, v81, v97, not v15:IsSpellInRange(v61.Demonbolt)) or ((4971 - (11 + 192)) <= (428 + 418))) then
						return "demonbolt main 8";
					end
				end
				if ((v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime() + (178 - (135 + 40)))))) and v14:HasTier(75 - 44, 2 + 0)) or ((7397 - 4039) <= (2128 - 708))) then
					if (v24(v61.PowerSiphon, v56) or ((3915 - (50 + 126)) <= (8367 - 5362))) then
						return "power_siphon main 10";
					end
				end
				v131 = 1 + 0;
			end
			if (((1417 - (1233 + 180)) == v131) or ((2628 - (522 + 447)) >= (3555 - (107 + 1314)))) then
				if ((v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) or ((1513 + 1747) < (7175 - 4820))) then
					if (v24(v61.PowerSiphon, v56) or ((285 + 384) == (8385 - 4162))) then
						return "power_siphon main 38";
					end
				end
				if ((v61.SummonVilefiend:IsReady() and (v66 < (v61.SummonDemonicTyrant:CooldownRemains() + (19 - 14)))) or ((3602 - (716 + 1194)) < (11 + 577))) then
					if (v24(v61.SummonVilefiend) or ((514 + 4283) < (4154 - (74 + 429)))) then
						return "summon_vilefiend main 40";
					end
				end
				if (v61.Doom:IsReady() or ((8057 - 3880) > (2404 + 2446))) then
					if (v83.CastCycle(v61.Doom, v80, v99, not v15:IsSpellInRange(v61.Doom)) or ((915 - 515) > (787 + 324))) then
						return "doom main 42";
					end
				end
				if (((9405 - 6354) > (2484 - 1479)) and v61.ShadowBolt:IsCastable()) then
					if (((4126 - (279 + 154)) <= (5160 - (454 + 324))) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt main 44";
					end
				end
				break;
			end
			if ((v131 == (1 + 0)) or ((3299 - (12 + 5)) > (2211 + 1889))) then
				if ((v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v79)) or ((9121 - 5541) < (1051 + 1793))) then
					if (((1182 - (277 + 816)) < (19186 - 14696)) and v24(v61.DemonicStrength, v52)) then
						return "demonic_strength main 12";
					end
				end
				if ((v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) or ((6166 - (1058 + 125)) < (339 + 1469))) then
					if (((4804 - (815 + 160)) > (16171 - 12402)) and v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(94 - 54))) then
						return "bilescourge_bombers main 14";
					end
				end
				if (((355 + 1130) <= (8488 - 5584)) and v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v79) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) then
					if (((6167 - (41 + 1857)) == (6162 - (1222 + 671))) and v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(103 - 63))) then
						return "guillotine main 16";
					end
				end
				if (((556 - 169) <= (3964 - (229 + 953))) and v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (1799 - (1111 + 663))) or (v75 > (1604 - (874 + 705))) or v14:BuffUp(v61.NetherPortalBuff))) then
					if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((266 + 1633) <= (626 + 291))) then
						return "call_dreadstalkers main 18";
					end
				end
				v131 = 3 - 1;
			end
			if ((v131 == (1 + 1)) or ((4991 - (642 + 37)) <= (200 + 676))) then
				if (((358 + 1874) <= (6517 - 3921)) and v61.Implosion:IsReady() and (v86(456 - (233 + 221)) > (0 - 0)) and v70 and not v14:PrevGCDP(1 + 0, v61.Implosion)) then
					if (((3636 - (718 + 823)) < (2320 + 1366)) and v24(v61.Implosion, v54, nil, not v15:IsInRange(845 - (266 + 539)))) then
						return "implosion main 20";
					end
				end
				if ((v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (28 - 18)) and (v82 > (1226 - (636 + 589)))) or ((3786 - 2191) >= (9227 - 4753))) then
					if (v24(v61.SummonSoulkeeper) or ((3661 + 958) < (1048 + 1834))) then
						return "soul_strike main 22";
					end
				end
				if ((v61.HandofGuldan:IsReady() and (((v77 > (1017 - (657 + 358))) and (v61.CallDreadstalkers:CooldownRemains() > (v79 * (10 - 6))) and (v61.SummonDemonicTyrant:CooldownRemains() > (38 - 21))) or (v77 == (1192 - (1151 + 36))) or ((v77 == (4 + 0)) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v79 * (1 + 1))))) and (v82 == (2 - 1)) and v61.GrandWarlocksDesign:IsAvailable()) or ((2126 - (1552 + 280)) >= (5665 - (64 + 770)))) then
					if (((1378 + 651) <= (7000 - 3916)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
						return "hand_of_guldan main 26";
					end
				end
				if ((v61.HandofGuldan:IsReady() and (v77 > (1 + 1)) and not ((v82 == (1244 - (157 + 1086))) and v61.GrandWarlocksDesign:IsAvailable())) or ((4076 - 2039) == (10598 - 8178))) then
					if (((6838 - 2380) > (5328 - 1424)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
						return "hand_of_guldan main 28";
					end
				end
				v131 = 822 - (599 + 220);
			end
		end
	end
	local function v113()
		local v132 = 0 - 0;
		while true do
			if (((2367 - (1813 + 118)) >= (90 + 33)) and (v132 == (1219 - (841 + 376)))) then
				if (((700 - 200) < (422 + 1394)) and (v83.TargetIsValid() or v14:AffectingCombat())) then
					local v153 = 0 - 0;
					while true do
						if (((4433 - (464 + 395)) == (9172 - 5598)) and ((0 + 0) == v153)) then
							v65 = v11.BossFightRemains();
							v66 = v65;
							v153 = 838 - (467 + 370);
						end
						if (((456 - 235) < (287 + 103)) and (v153 == (3 - 2))) then
							if ((v66 == (1734 + 9377)) or ((5148 - 2935) <= (1941 - (150 + 370)))) then
								v66 = v11.FightRemains(v81, false);
							end
							v26.UpdatePetTable();
							v153 = 1284 - (74 + 1208);
						end
						if (((7521 - 4463) < (23049 - 18189)) and (v153 == (2 + 0))) then
							v26.UpdateSoulShards();
							v78 = v11.CombatTime();
							v153 = 393 - (14 + 376);
						end
						if ((v153 == (4 - 1)) or ((839 + 457) >= (3906 + 540))) then
							v77 = v14:SoulShardsP();
							v79 = v14:GCD() + 0.25 + 0;
							break;
						end
					end
				end
				if ((v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) or ((4081 - 2688) > (3378 + 1111))) then
					if (v25(v61.SummonPet, false, true) or ((4502 - (23 + 55)) < (63 - 36))) then
						return "summon_pet ooc";
					end
				end
				if ((v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) or ((1333 + 664) > (3426 + 389))) then
					if (((5372 - 1907) > (602 + 1311)) and v25(v63.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v132 = 904 - (652 + 249);
			end
			if (((1961 - 1228) < (3687 - (708 + 1160))) and ((2 - 1) == v132)) then
				v33 = EpicSettings.Toggles['cds'];
				if (v32 or ((8013 - 3618) == (4782 - (10 + 17)))) then
					local v154 = 0 + 0;
					while true do
						if ((v154 == (1733 - (1400 + 332))) or ((7275 - 3482) < (4277 - (242 + 1666)))) then
							v82 = v29(#v81, #v80);
							break;
						end
						if ((v154 == (0 + 0)) or ((1497 + 2587) == (226 + 39))) then
							v81 = v15:GetEnemiesInSplashRange(948 - (850 + 90));
							v80 = v14:GetEnemiesInRange(70 - 30);
							v154 = 1391 - (360 + 1030);
						end
					end
				else
					local v155 = 0 + 0;
					while true do
						if (((12300 - 7942) == (5995 - 1637)) and (v155 == (1662 - (909 + 752)))) then
							v82 = 1224 - (109 + 1114);
							break;
						end
						if ((v155 == (0 - 0)) or ((1222 + 1916) < (1235 - (6 + 236)))) then
							v81 = {};
							v80 = {};
							v155 = 1 + 0;
						end
					end
				end
				UpdateLastMoveTime();
				v132 = 2 + 0;
			end
			if (((7853 - 4523) > (4057 - 1734)) and ((1133 - (1076 + 57)) == v132)) then
				v60();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v132 = 1 + 0;
			end
			if ((v132 == (692 - (579 + 110))) or ((287 + 3339) == (3527 + 462))) then
				if ((v36 and (v14:HealthPercentage() <= v38)) or ((487 + 429) == (3078 - (174 + 233)))) then
					local v156 = 0 - 0;
					while true do
						if (((477 - 205) == (121 + 151)) and (v156 == (1174 - (663 + 511)))) then
							if (((3791 + 458) <= (1051 + 3788)) and (v37 == "Refreshing Healing Potion")) then
								if (((8561 - 5784) < (1938 + 1262)) and v62.RefreshingHealingPotion:IsReady()) then
									if (((223 - 128) < (4737 - 2780)) and v25(v63.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((395 + 431) < (3341 - 1624)) and (v37 == "Dreamwalker's Healing Potion")) then
								if (((1017 + 409) >= (102 + 1003)) and v62.DreamwalkersHealingPotion:IsReady()) then
									if (((3476 - (478 + 244)) <= (3896 - (440 + 77))) and v25(v63.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (v83.TargetIsValid() or ((1786 + 2141) == (5171 - 3758))) then
					local v157 = 1556 - (655 + 901);
					local v158;
					while true do
						if ((v157 == (1 + 3)) or ((884 + 270) <= (533 + 255))) then
							if (((v61.SummonDemonicTyrant:CooldownRemains() < (60 - 45)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (1450 - (695 + 750)))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (16 - 11))) and ((v61.GrimoireFelguard:CooldownRemains() < (15 - 5)) or not v14:HasTier(120 - 90, 353 - (285 + 66))) and ((v75 < (34 - 19)) or (v66 < (1350 - (682 + 628))) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (3 + 12)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (304 - (176 + 123)))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (3 + 2))) and ((v61.GrimoireFelguard:CooldownRemains() < (8 + 2)) or not v14:HasTier(299 - (239 + 30), 1 + 1)) and ((v75 < (15 + 0)) or (v66 < (70 - 30)) or v14:PowerInfusionUp())) or ((5125 - 3482) > (3694 - (306 + 9)))) then
								local v159 = v107();
								if (v159 or ((9781 - 6978) > (792 + 3757))) then
									return v159;
								end
							end
							if (((v61.SummonDemonicTyrant:CooldownRemains() < (10 + 5)) and (v94() or (not v61.SummonVilefiend:IsAvailable() and (v88() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(15 + 15, 5 - 3)))) and ((v75 < (1390 - (1140 + 235))) or v88() or (v66 < (26 + 14)) or v14:PowerInfusionUp())) or ((202 + 18) >= (776 + 2246))) then
								local v160 = 52 - (33 + 19);
								local v161;
								while true do
									if (((1019 + 1803) == (8458 - 5636)) and (v160 == (0 + 0))) then
										v161 = v107();
										if (v161 or ((2080 - 1019) == (1742 + 115))) then
											return v161;
										end
										break;
									end
								end
							end
							v158 = v112();
							v157 = 694 - (586 + 103);
						end
						if (((252 + 2508) > (4199 - 2835)) and (v157 == (1490 - (1309 + 179)))) then
							v103();
							if (v90() or (v66 < (39 - 17)) or ((2134 + 2768) <= (9654 - 6059))) then
								local v162 = 0 + 0;
								local v163;
								while true do
									if ((v162 == (0 - 0)) or ((7675 - 3823) == (902 - (295 + 314)))) then
										v163 = v106();
										if ((v163 and v34 and v33) or ((3828 - 2269) == (6550 - (1300 + 662)))) then
											return v163;
										end
										break;
									end
								end
							end
							v158 = v105();
							v157 = 9 - 6;
						end
						if ((v157 == (1758 - (1178 + 577))) or ((2329 + 2155) == (2329 - 1541))) then
							if (((5973 - (851 + 554)) >= (3455 + 452)) and v158) then
								return v158;
							end
							if (((3455 - 2209) < (7536 - 4066)) and (v66 < (332 - (115 + 187)))) then
								local v164 = v108();
								if (((3116 + 952) >= (921 + 51)) and v164) then
									return v164;
								end
							end
							if (((1942 - 1449) < (5054 - (160 + 1001))) and v61.HandofGuldan:IsReady() and (v78 < (0.5 + 0)) and (((v66 % (66 + 29)) > (81 - 41)) or ((v66 % (453 - (237 + 121))) < (912 - (525 + 372)))) and (v61.ReignofTyranny:IsAvailable() or (v82 > (3 - 1)))) then
								if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((4839 - 3366) >= (3474 - (96 + 46)))) then
									return "hand_of_guldan main 2";
								end
							end
							v157 = 781 - (643 + 134);
						end
						if (((0 + 0) == v157) or ((9713 - 5662) <= (4295 - 3138))) then
							if (((580 + 24) < (5653 - 2772)) and not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) then
								local v165 = 0 - 0;
								local v166;
								while true do
									if ((v165 == (719 - (316 + 403))) or ((599 + 301) == (9284 - 5907))) then
										v166 = v102();
										if (((1612 + 2847) > (1488 - 897)) and v166) then
											return v166;
										end
										break;
									end
								end
							end
							if (((2408 + 990) >= (772 + 1623)) and not v14:IsCasting() and not v14:IsChanneling()) then
								local v167 = 0 - 0;
								local v168;
								while true do
									if ((v167 == (4 - 3)) or ((4534 - 2351) >= (162 + 2662))) then
										if (((3811 - 1875) == (95 + 1841)) and v168) then
											return v168;
										end
										v168 = v83.Interrupt(v61.AxeToss, 117 - 77, true);
										if (v168 or ((4849 - (12 + 5)) < (16751 - 12438))) then
											return v168;
										end
										v167 = 3 - 1;
									end
									if (((8689 - 4601) > (9606 - 5732)) and ((0 + 0) == v167)) then
										v168 = v83.Interrupt(v61.SpellLock, 2013 - (1656 + 317), true);
										if (((3861 + 471) == (3472 + 860)) and v168) then
											return v168;
										end
										v168 = v83.Interrupt(v61.SpellLock, 106 - 66, true, v17, v63.SpellLockMouseover);
										v167 = 4 - 3;
									end
									if (((4353 - (5 + 349)) >= (13774 - 10874)) and (v167 == (1274 - (266 + 1005)))) then
										if (v168 or ((1664 + 861) > (13866 - 9802))) then
											return v168;
										end
										v168 = v83.InterruptWithStun(v61.AxeToss, 52 - 12, true, v17, v63.AxeTossMouseover);
										if (((6067 - (561 + 1135)) == (5695 - 1324)) and v168) then
											return v168;
										end
										break;
									end
									if ((v167 == (6 - 4)) or ((1332 - (507 + 559)) > (12511 - 7525))) then
										v168 = v83.Interrupt(v61.AxeToss, 123 - 83, true, v17, v63.AxeTossMouseover);
										if (((2379 - (212 + 176)) >= (1830 - (250 + 655))) and v168) then
											return v168;
										end
										v168 = v83.InterruptWithStun(v61.AxeToss, 109 - 69, true);
										v167 = 5 - 2;
									end
								end
							end
							if (((711 - 256) < (4009 - (1869 + 87))) and v14:AffectingCombat() and v58) then
								if ((v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v110 and ((GetTime() - v109) >= (3 - 2)) and (v14:HealthPercentage() >= v59)) or ((2727 - (484 + 1417)) == (10397 - 5546))) then
									if (((305 - 122) == (956 - (48 + 725))) and v25(v61.BurningRush)) then
										return "burning_rush defensive 2";
									end
								elseif (((1892 - 733) <= (4796 - 3008)) and v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v110 or (v14:HealthPercentage() <= v59))) then
									if (v25(v63.CancelBurningRush) or ((2039 + 1468) > (11539 - 7221))) then
										return "burning_rush defensive 4";
									end
								end
							end
							v157 = 1 + 0;
						end
						if ((v157 == (2 + 3)) or ((3928 - (152 + 701)) <= (4276 - (430 + 881)))) then
							if (((523 + 842) <= (2906 - (557 + 338))) and v158) then
								return v158;
							end
							break;
						end
						if ((v157 == (1 + 0)) or ((7822 - 5046) > (12518 - 8943))) then
							v158 = v111();
							if (v158 or ((6785 - 4231) == (10353 - 5549))) then
								return v158;
							end
							if (((3378 - (499 + 302)) == (3443 - (39 + 827))) and v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) then
								if (v25(v61.UnendingResolve) or ((16 - 10) >= (4218 - 2329))) then
									return "unending_resolve defensive";
								end
							end
							v157 = 7 - 5;
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		v61.DoomBrandDebuff:RegisterAuraTracking();
		v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v11.SetAPL(407 - 141, v113, v114);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

