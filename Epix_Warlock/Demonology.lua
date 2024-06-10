local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 1061 - (346 + 715);
	local v7;
	while true do
		if ((v6 == (0 - 0)) or ((4715 - (1074 + 82)) <= (933 - 507))) then
			v7 = v1[v5];
			if (((2792 - (214 + 1570)) <= (5166 - (990 + 465))) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
		if ((v6 == (1 + 0)) or ((1021 + 28) <= (3565 - 2659))) then
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
		local v114 = 1726 - (1668 + 58);
		while true do
			if (((5139 - (512 + 114)) > (7106 - 4380)) and (v114 == (3 - 1))) then
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v114 = 3 + 0;
			end
			if ((v114 == (16 - 11)) or ((3475 - (109 + 1885)) >= (4127 - (1269 + 200)))) then
				v52 = EpicSettings.Settings['DemonicStrength'];
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v114 = 11 - 5;
			end
			if (((821 - (98 + 717)) == v114) or ((4046 - (802 + 24)) == (2351 - 987))) then
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 - 0);
				v114 = 2 + 5;
			end
			if ((v114 == (1 + 0)) or ((174 + 880) > (732 + 2660))) then
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v39 = EpicSettings.Settings['UseHealthstone'] or (0 + 0);
				v114 = 1 + 1;
			end
			if ((v114 == (3 + 0)) or ((492 + 184) >= (767 + 875))) then
				v43 = EpicSettings.Settings['InterruptThreshold'] or (1433 - (797 + 636));
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v114 = 1623 - (1427 + 192);
			end
			if (((1434 + 2702) > (5565 - 3168)) and (v114 == (0 + 0))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v114 = 1 + 0;
			end
			if ((v114 == (330 - (192 + 134))) or ((5610 - (316 + 960)) == (2363 + 1882))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				v114 = 18 - 13;
			end
			if (((559 - (83 + 468)) == v114) or ((6082 - (1202 + 604)) <= (14149 - 11118))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				break;
			end
			if ((v114 == (332 - (45 + 280))) or ((4616 + 166) <= (1048 + 151))) then
				v58 = EpicSettings.Settings['UseBurningRush'] or (0 + 0);
				v59 = EpicSettings.Settings['BurningRushHP'] or (0 + 0);
				v45 = EpicSettings.Settings['DrainLifeHP'] or (0 + 0);
				v114 = 14 - 6;
			end
		end
	end
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = v21.Warlock.Demonology;
	local v64 = {};
	local v65 = 13022 - (340 + 1571);
	local v66 = 4383 + 6728;
	local v67 = (1786 - (1733 + 39)) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	local v68 = 0 - 0;
	local v69 = false;
	local v70 = false;
	local v71 = false;
	local v72 = 1034 - (125 + 909);
	local v73 = 1948 - (1096 + 852);
	local v74 = 0 + 0;
	local v75 = 171 - 51;
	local v76 = 12 + 0;
	local v77 = 512 - (409 + 103);
	local v78 = 236 - (46 + 190);
	local v79 = 95 - (51 + 44);
	local v80;
	local v81, v82;
	v11:RegisterForEvent(function()
		v65 = 3134 + 7977;
		v66 = 12428 - (1114 + 203);
	end, "PLAYER_REGEN_ENABLED");
	local v83 = v11.Commons.Everyone;
	local v84 = {{v61.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v11:RegisterForEvent(function()
		v61.HandofGuldan:RegisterInFlight();
		v67 = (36 - 22) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	end, "LEARNED_SPELL_IN_TAB");
	v61.HandofGuldan:RegisterInFlight();
	local function v85()
		return v11.GuardiansTable.ImpCount or (1905 - (830 + 1075));
	end
	local function v86(v115)
		local v116 = 524 - (303 + 221);
		local v117;
		while true do
			if ((v116 == (1269 - (231 + 1038))) or ((4054 + 810) < (3064 - (171 + 991)))) then
				v117 = 0 - 0;
				for v148, v149 in pairs(v11.GuardiansTable.Pets) do
					if (((12993 - 8154) >= (9233 - 5533)) and (v149.ImpCasts <= v115)) then
						v117 = v117 + 1 + 0;
					end
				end
				v116 = 3 - 2;
			end
			if ((v116 == (2 - 1)) or ((1732 - 657) > (5928 - 4010))) then
				return v117;
			end
		end
	end
	local function v87()
		return v11.GuardiansTable.FelGuardDuration or (1248 - (111 + 1137));
	end
	local function v88()
		return v87() > (158 - (91 + 67));
	end
	local function v89()
		return v11.GuardiansTable.DemonicTyrantDuration or (0 - 0);
	end
	local function v90()
		return v89() > (0 + 0);
	end
	local function v91()
		return v11.GuardiansTable.DreadstalkerDuration or (523 - (423 + 100));
	end
	local function v92()
		return v91() > (0 + 0);
	end
	local function v93()
		return v11.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v94()
		return v93() > (0 + 0);
	end
	local function v95()
		return v11.GuardiansTable.PitLordDuration or (771 - (326 + 445));
	end
	local function v96()
		return v95() > (0 - 0);
	end
	local function v97(v118)
		return v118:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (6 - 3)));
	end
	local function v98(v119)
		return (v119:DebuffDown(v61.DoomBrandDebuff)) or (v82 < (9 - 5));
	end
	local function v99(v120)
		return (v120:DebuffRefreshable(v61.Doom));
	end
	local function v100(v121)
		return (v121:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v101(v122)
		return v122:DebuffRemains(v61.DoomBrandDebuff) > (721 - (530 + 181));
	end
	local function v102()
		v76 = 893 - (614 + 267);
		v67 = (46 - (19 + 13)) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
		v72 = 0 - 0;
		v73 = 0 - 0;
		if (((1131 - 735) <= (988 + 2816)) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v85(), 3 - 1)) <= (7 - 3)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (1815 - (1293 + 519))))) then
			if (v24(v61.PowerSiphon) or ((8505 - 4336) == (5709 - 3522))) then
				return "power_siphon precombat 2";
			end
		end
		if (((2688 - 1282) == (6062 - 4656)) and v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) then
			if (((3606 - 2075) < (2263 + 2008)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt precombat 3";
			end
		end
		if (((130 + 505) == (1475 - 840)) and v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(1 + 0, v61.PowerSiphon)) then
			if (((1121 + 2252) <= (2223 + 1333)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt precombat 4";
			end
		end
		if (v61.ShadowBolt:IsReady() or ((4387 - (709 + 387)) < (5138 - (673 + 1185)))) then
			if (((12719 - 8333) >= (2803 - 1930)) and v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt precombat 6";
			end
		end
	end
	local function v103()
		local v123 = 0 - 0;
		local v124;
		while true do
			if (((659 + 262) <= (824 + 278)) and ((0 - 0) == v123)) then
				if (((1156 + 3550) >= (1920 - 957)) and ((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (5 - 2)) and v61.NetherPortal:IsAvailable()) or (v66 < (1900 - (446 + 1434))) or (v90() and (v66 < (1383 - (1040 + 243)))) or (v66 < (74 - 49)) or v90() or (not v61.SummonDemonicTyrant:IsAvailable() and v92())) and (v74 <= (1847 - (559 + 1288)))) then
					v73 = (2051 - (609 + 1322)) + v78;
				end
				v74 = v73 - v78;
				if (((((((v66 + v78) % (574 - (13 + 441))) <= (317 - 232)) and (((v66 + v78) % (314 - 194)) >= (124 - 99))) or (v78 >= (8 + 202))) and (v74 > (0 - 0)) and not v61.GrandWarlocksDesign:IsAvailable()) or ((341 + 619) <= (384 + 492))) then
					v75 = v74;
				else
					v75 = v61.SummonDemonicTyrant:CooldownRemains();
				end
				if ((v94() and v92()) or ((6130 - 4064) == (510 + 422))) then
					v68 = v30(v93(), v91()) - (v14:GCD() * (0.5 - 0));
				end
				v123 = 1 + 0;
			end
			if (((2684 + 2141) < (3480 + 1363)) and (v123 == (3 + 0))) then
				if ((v82 > (4 + 0 + v124)) or ((4310 - (153 + 280)) >= (13100 - 8563))) then
					v70 = v89() < (8 + 0);
				end
				v71 = (v61.SummonDemonicTyrant:CooldownRemains() < (8 + 12)) and (v75 < (11 + 9)) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (2 + 0)) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (4 + 1))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (7 - 2)));
				break;
			end
			if ((v123 == (2 + 0)) or ((4982 - (89 + 578)) < (1233 + 493))) then
				v124 = v27(v61.SacrificedSouls:IsAvailable());
				v70 = false;
				if ((v82 > ((1 - 0) + v124)) or ((4728 - (572 + 477)) < (85 + 540))) then
					v70 = not v90();
				end
				if (((v82 > (2 + 0 + v124)) and (v82 < (1 + 4 + v124))) or ((4711 - (84 + 2)) < (1040 - 408))) then
					v70 = v89() < (5 + 1);
				end
				v123 = 845 - (497 + 345);
			end
			if ((v123 == (1 + 0)) or ((15 + 68) > (3113 - (605 + 728)))) then
				if (((390 + 156) <= (2393 - 1316)) and not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v92()) then
					v68 = v30(v91(), v87()) - (v14:GCD() * (0.5 + 0));
				end
				if ((not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(110 - 80, 2 + 0)) and v92()) or ((2759 - 1763) > (3248 + 1053))) then
					v68 = v91() - (v14:GCD() * (489.5 - (457 + 32)));
				end
				if (((1727 + 2343) > (2089 - (832 + 570))) and ((not v94() and v61.SummonVilefiend:IsAvailable()) or not v92())) then
					v68 = 0 + 0;
				end
				v69 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (8 + 22)) or v14:BuffUp(v61.NetherPortalBuff);
				v123 = 6 - 4;
			end
		end
	end
	local function v104()
		local v125 = 0 + 0;
		local v126;
		while true do
			if ((v125 == (797 - (588 + 208))) or ((1767 - 1111) >= (5130 - (884 + 916)))) then
				v126 = v83.HandleBottomTrinket(v64, v33, 83 - 43, nil);
				if (v126 or ((1445 + 1047) <= (988 - (232 + 421)))) then
					return v126;
				end
				break;
			end
			if (((6211 - (1569 + 320)) >= (629 + 1933)) and (v125 == (0 + 0))) then
				v126 = v83.HandleTopTrinket(v64, v33, 134 - 94, nil);
				if (v126 or ((4242 - (316 + 289)) >= (9868 - 6098))) then
					return v126;
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v105()
		local v127 = 1453 - (666 + 787);
		while true do
			if ((v127 == (425 - (360 + 65))) or ((2224 + 155) > (4832 - (79 + 175)))) then
				if ((v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) or ((761 - 278) > (580 + 163))) then
					if (((7522 - 5068) > (1113 - 535)) and v25(v63.TimebreachingTalon)) then
						return "timebreaching_talon items 2";
					end
				end
				if (((1829 - (503 + 396)) < (4639 - (92 + 89))) and (not v61.SummonDemonicTyrant:IsAvailable() or v14:BuffUp(v61.DemonicPowerBuff))) then
					local v150 = v104();
					if (((1283 - 621) <= (499 + 473)) and v150) then
						return v150;
					end
				end
				break;
			end
		end
	end
	local function v106()
		local v128 = 0 + 0;
		while true do
			if (((17113 - 12743) == (598 + 3772)) and (v128 == (0 - 0))) then
				if (v61.Berserking:IsCastable() or ((4155 + 607) <= (412 + 449))) then
					if (v25(v61.Berserking, v34) or ((4300 - 2888) == (533 + 3731))) then
						return "berserking ogcd 4";
					end
				end
				if (v61.BloodFury:IsCastable() or ((4831 - 1663) < (3397 - (485 + 759)))) then
					if (v25(v61.BloodFury, v34) or ((11513 - 6537) < (2521 - (442 + 747)))) then
						return "blood_fury ogcd 6";
					end
				end
				v128 = 1136 - (832 + 303);
			end
			if (((5574 - (88 + 858)) == (1411 + 3217)) and (v128 == (1 + 0))) then
				if (v61.Fireblood:IsCastable() or ((3 + 51) == (1184 - (766 + 23)))) then
					if (((404 - 322) == (111 - 29)) and v25(v61.Fireblood, v34)) then
						return "fireblood ogcd 8";
					end
				end
				if (v61.AncestralCall:IsCastable() or ((1530 - 949) < (956 - 674))) then
					if (v24(v61.AncestralCall, v34) or ((5682 - (1036 + 37)) < (1769 + 726))) then
						return "ancestral_call racials 8";
					end
				end
				break;
			end
		end
	end
	local function v107()
		if (((2243 - 1091) == (907 + 245)) and (v68 > (1480 - (641 + 839))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79)) and (v73 <= (913 - (910 + 3)))) then
			v73 = (305 - 185) + v78;
		end
		if (((3580 - (1466 + 218)) <= (1573 + 1849)) and v61.HandofGuldan:IsReady() and (v77 > (1148 - (556 + 592))) and (v68 > (v79 + v61.SummonDemonicTyrant:CastTime())) and (v68 < (v79 * (2 + 2)))) then
			if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((1798 - (329 + 479)) > (2474 - (174 + 680)))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((v68 > (0 - 0)) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) or ((1817 - 940) > (3353 + 1342))) then
			local v133 = v105();
			if (((3430 - (396 + 343)) >= (164 + 1687)) and v133) then
				return v133;
			end
			local v133 = v106();
			if (v133 or ((4462 - (29 + 1448)) >= (6245 - (135 + 1254)))) then
				return v133;
			end
			local v134 = v83.HandleDPSPotion();
			if (((16108 - 11832) >= (5579 - 4384)) and v134) then
				return v134;
			end
		end
		if (((2154 + 1078) <= (6217 - (389 + 1138))) and v61.SummonDemonicTyrant:IsCastable() and (v68 > (574 - (102 + 472))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) then
			if (v25(v61.SummonDemonicTyrant, nil, nil, v57) or ((846 + 50) >= (1745 + 1401))) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if (((2855 + 206) >= (4503 - (320 + 1225))) and v61.Implosion:IsReady() and (v85() > (2 - 0)) and not v92() and not v88() and not v94() and ((v82 > (2 + 1)) or ((v82 > (1466 - (157 + 1307))) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(1860 - (821 + 1038), v61.Implosion)) then
			if (((7951 - 4764) >= (71 + 573)) and v24(v61.Implosion, v54, nil, not v15:IsInRange(71 - 31))) then
				return "implosion tyrant 8";
			end
		end
		if (((240 + 404) <= (1744 - 1040)) and v61.ShadowBolt:IsReady() and v14:PrevGCDP(1027 - (834 + 192), v61.GrimoireFelguard) and (v78 > (2 + 28)) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) then
			if (((246 + 712) > (21 + 926)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if (((6958 - 2466) >= (2958 - (300 + 4))) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (2 + 2)) and (not v94() or (not v61.SummonVilefiend:IsAvailable() and v91())) and v14:BuffDown(v61.NetherPortalBuff)) then
			if (((9010 - 5568) >= (1865 - (112 + 250))) and v24(v61.PowerSiphon, v56)) then
				return "power_siphon tyrant 12";
			end
		end
		if ((v61.ShadowBolt:IsReady() and not v94() and v14:BuffDown(v61.NetherPortalBuff) and not v92() and (v77 < ((2 + 3) - v14:BuffStack(v61.DemonicCoreBuff)))) or ((7941 - 4771) <= (839 + 625))) then
			if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((2481 + 2316) == (3282 + 1106))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if (((274 + 277) <= (506 + 175)) and v61.NetherPortal:IsReady() and (v77 == (1419 - (1001 + 413)))) then
			if (((7307 - 4030) > (1289 - (244 + 638))) and v24(v61.NetherPortal, v55)) then
				return "nether_portal tyrant 16";
			end
		end
		if (((5388 - (627 + 66)) >= (4216 - 2801)) and v61.SummonVilefiend:IsReady() and ((v77 == (607 - (512 + 90))) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (1919 - (1665 + 241))) and v69) then
			if (v24(v61.SummonVilefiend) or ((3929 - (373 + 344)) <= (426 + 518))) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if ((v61.CallDreadstalkers:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (8 + 22))) and (v14:BuffUp(v61.NetherPortalBuff) or v88() or (v77 == (13 - 8))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (18 - 7)) and v69) or ((4195 - (35 + 1064)) <= (1309 + 489))) then
			if (((7567 - 4030) == (15 + 3522)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if (((5073 - (298 + 938)) >= (2829 - (233 + 1026))) and v61.GrimoireFelguard:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (1696 - (636 + 1030)))) and (v14:BuffUp(v61.NetherPortalBuff) or v92() or (v77 == (3 + 2))) and v69))) then
			if (v24(v61.GrimoireFelguard, v53) or ((2882 + 68) == (1133 + 2679))) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if (((320 + 4403) >= (2539 - (55 + 166))) and v61.HandofGuldan:IsReady() and (((v77 > (1 + 1)) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92())) and ((v77 > (1 + 1)) or (v93() < ((v79 * (7 - 5)) + ((299 - (36 + 261)) / v14:SpellHaste()))))) or (not v92() and (v77 == (8 - 3))))) then
			if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((3395 - (34 + 1334)) > (1097 + 1755))) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if ((v61.Demonbolt:IsReady() and (v77 < (4 + 0)) and (v14:BuffStack(v61.DemonicCoreBuff) > (1284 - (1035 + 248))) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92()) or not v23())) or ((1157 - (20 + 1)) > (2250 + 2067))) then
			if (((5067 - (134 + 185)) == (5881 - (549 + 584))) and ((v61.DoomBrandDebuff:AuraActiveCount() == v82) or not v14:HasTier(716 - (314 + 371), 6 - 4))) then
				if (((4704 - (478 + 490)) <= (2511 + 2229)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
					return "demonbolt tyrant 26";
				end
			elseif (v83.CastCycle(v61.Demonbolt, v81, v100, not v15:IsSpellInRange(v61.Demonbolt)) or ((4562 - (786 + 386)) <= (9911 - 6851))) then
				return "demonbolt tyrant 27";
			end
		end
		if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (1382 - (1055 + 324))) and (v68 > (v61.SummonDemonicTyrant:ExecuteTime() + (v79 * (1343 - (1093 + 247)))))) or (v68 == (0 + 0)))) or ((106 + 893) > (10691 - 7998))) then
			if (((1570 - 1107) < (1710 - 1109)) and v24(v61.PowerSiphon)) then
				return "power_siphon tyrant 28";
			end
		end
		if (v61.ShadowBolt:IsCastable() or ((5485 - 3302) < (245 + 442))) then
			if (((17524 - 12975) == (15679 - 11130)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v108()
		local v129 = 0 + 0;
		while true do
			if (((11947 - 7275) == (5360 - (364 + 324))) and (v129 == (0 - 0))) then
				if ((v61.SummonDemonicTyrant:IsCastable() and (v66 < (47 - 27))) or ((1216 + 2452) < (1652 - 1257))) then
					if (v25(v61.SummonDemonicTyrant, nil, nil, v57) or ((6671 - 2505) == (1381 - 926))) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v66 < (1288 - (1249 + 19))) or ((4016 + 433) == (10365 - 7702))) then
					if ((v61.GrimoireFelguard:IsReady() and v53) or ((5363 - (686 + 400)) < (2346 + 643))) then
						if (v24(v61.GrimoireFelguard) or ((1099 - (73 + 156)) >= (20 + 4129))) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (((3023 - (721 + 90)) < (36 + 3147)) and v61.CallDreadstalkers:IsReady()) then
						if (((15084 - 10438) > (3462 - (224 + 246))) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					if (((2322 - 888) < (5718 - 2612)) and v61.SummonVilefiend:IsReady()) then
						if (((143 + 643) < (72 + 2951)) and v24(v61.SummonVilefiend)) then
							return "summon_vilefiend fight_end 6";
						end
					end
				end
				v129 = 1 + 0;
			end
			if ((v129 == (3 - 1)) or ((8126 - 5684) < (587 - (203 + 310)))) then
				if (((6528 - (1238 + 755)) == (317 + 4218)) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (1537 - (709 + 825))) and (v66 < (36 - 16))) then
					if (v24(v61.PowerSiphon, v56) or ((4382 - 1373) <= (2969 - (196 + 668)))) then
						return "power_siphon fight_end 14";
					end
				end
				if (((7225 - 5395) < (7599 - 3930)) and v61.Implosion:IsReady() and v54 and (v66 < ((835 - (171 + 662)) * v79))) then
					if (v24(v61.Implosion, nil, nil, not v15:IsInRange(133 - (4 + 89))) or ((5012 - 3582) >= (1316 + 2296))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if (((11784 - 9101) >= (965 + 1495)) and (v129 == (1487 - (35 + 1451)))) then
				if ((v61.NetherPortal:IsReady() and v55 and (v66 < (1483 - (28 + 1425)))) or ((3797 - (941 + 1052)) >= (3141 + 134))) then
					if (v24(v61.NetherPortal) or ((2931 - (822 + 692)) > (5180 - 1551))) then
						return "nether_portal fight_end 8";
					end
				end
				if (((2259 + 2536) > (699 - (45 + 252))) and v61.DemonicStrength:IsCastable() and (v66 < (10 + 0))) then
					if (((1657 + 3156) > (8676 - 5111)) and v24(v61.DemonicStrength, v52)) then
						return "demonic_strength fight_end 12";
					end
				end
				v129 = 435 - (114 + 319);
			end
		end
	end
	local v109 = 0 - 0;
	local v110 = false;
	function UpdateLastMoveTime()
		if (((5012 - 1100) == (2494 + 1418)) and v14:IsMoving()) then
			if (((4202 - 1381) <= (10107 - 5283)) and not v110) then
				v109 = GetTime();
				v110 = true;
			end
		else
			v110 = false;
		end
	end
	local function v111()
		if (((3701 - (556 + 1407)) <= (3401 - (741 + 465))) and v14:AffectingCombat()) then
			if (((506 - (170 + 295)) <= (1591 + 1427)) and (v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) then
				if (((1971 + 174) <= (10104 - 6000)) and v25(v61.DarkPact)) then
					return "dark_pact defensive 2";
				end
			end
			if (((2230 + 459) < (3108 + 1737)) and (v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) then
				if (v25(v61.DrainLife) or ((1315 + 1007) > (3852 - (957 + 273)))) then
					return "drain_life defensive 2";
				end
			end
			if (((v14:HealthPercentage() <= v46) and v61.HealthFunnel:IsCastable()) or ((1213 + 3321) == (834 + 1248))) then
				if (v25(v61.HealthFunnel) or ((5986 - 4415) > (4919 - 3052))) then
					return "health_funnel defensive 2";
				end
			end
			if (((v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) or ((8106 - 5452) >= (14835 - 11839))) then
				if (((5758 - (389 + 1391)) > (1321 + 783)) and v25(v61.UnendingResolve)) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v112()
		local v130 = 0 + 0;
		while true do
			if (((6818 - 3823) > (2492 - (783 + 168))) and (v130 == (6 - 4))) then
				if (((3196 + 53) > (1264 - (309 + 2))) and (v83.TargetIsValid() or v14:AffectingCombat())) then
					v65 = v11.BossFightRemains();
					v66 = v65;
					if ((v66 == (34120 - 23009)) or ((4485 - (1090 + 122)) > (1483 + 3090))) then
						v66 = v11.FightRemains(v81, false);
					end
					v26.UpdatePetTable();
					v26.UpdateSoulShards();
					v78 = v11.CombatTime();
					v77 = v14:SoulShardsP();
					v79 = v14:GCD() + (0.25 - 0);
				end
				if ((v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) or ((2157 + 994) < (2402 - (628 + 490)))) then
					if (v25(v61.SummonPet, false, true) or ((332 + 1518) == (3785 - 2256))) then
						return "summon_pet ooc";
					end
				end
				if (((3751 - 2930) < (2897 - (431 + 343))) and v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) then
					if (((1821 - 919) < (6726 - 4401)) and v25(v63.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v130 = 3 + 0;
			end
			if (((110 + 748) <= (4657 - (556 + 1139))) and (v130 == (15 - (6 + 9)))) then
				v60();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v130 = 1 + 0;
			end
			if ((v130 == (2 + 1)) or ((4115 - (28 + 141)) < (499 + 789))) then
				if ((v36 and (v14:HealthPercentage() <= v38)) or ((4001 - 759) == (402 + 165))) then
					local v151 = 1317 - (486 + 831);
					while true do
						if ((v151 == (0 - 0)) or ((2981 - 2134) >= (239 + 1024))) then
							if ((v37 == "Refreshing Healing Potion") or ((7123 - 4870) == (3114 - (668 + 595)))) then
								if (v62.RefreshingHealingPotion:IsReady() or ((1878 + 209) > (479 + 1893))) then
									if (v25(v63.RefreshingHealingPotion) or ((12121 - 7676) < (4439 - (23 + 267)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v37 == "Dreamwalker's Healing Potion") or ((3762 - (1129 + 815)) == (472 - (371 + 16)))) then
								if (((2380 - (1326 + 424)) < (4028 - 1901)) and v62.DreamwalkersHealingPotion:IsReady()) then
									if (v25(v63.RefreshingHealingPotion) or ((7081 - 5143) == (2632 - (88 + 30)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((5026 - (720 + 51)) >= (122 - 67)) and v83.TargetIsValid()) then
					local v152 = 1776 - (421 + 1355);
					local v153;
					while true do
						if (((4947 - 1948) > (568 + 588)) and (v152 == (1089 - (286 + 797)))) then
							if (((8590 - 6240) > (1912 - 757)) and v61.HandofGuldan:IsReady() and (((v77 > (441 - (397 + 42))) and (v61.CallDreadstalkers:CooldownRemains() > (v79 * (2 + 2))) and (v61.SummonDemonicTyrant:CooldownRemains() > (817 - (24 + 776)))) or (v77 == (7 - 2)) or ((v77 == (789 - (222 + 563))) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v79 * (3 - 1))))) and (v82 == (1 + 0)) and v61.GrandWarlocksDesign:IsAvailable()) then
								if (((4219 - (23 + 167)) <= (6651 - (690 + 1108))) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
									return "hand_of_guldan main 26";
								end
							end
							if ((v61.HandofGuldan:IsReady() and (v77 > (1 + 1)) and not ((v82 == (1 + 0)) and v61.GrandWarlocksDesign:IsAvailable())) or ((1364 - (40 + 808)) > (566 + 2868))) then
								if (((15471 - 11425) >= (2899 + 134)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
									return "hand_of_guldan main 28";
								end
							end
							if ((v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (((v77 < (3 + 1)) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v79 * (573 - (47 + 524)))) or (v77 < (2 + 0))) and not v71) or ((7432 - 4713) <= (2162 - 715))) then
								if (v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt)) or ((9427 - 5293) < (5652 - (1165 + 561)))) then
									return "demonbolt main 30";
								end
							end
							if ((v61.Demonbolt:IsReady() and v14:HasTier(1 + 30, 6 - 4) and v14:BuffUp(v61.DemonicCoreBuff) and (v77 < (2 + 2)) and not v71) or ((643 - (341 + 138)) >= (752 + 2033))) then
								if (v83.CastTargetIf(v61.Demonbolt, v81, "==", v98, v101, not v15:IsSpellInRange(v61.Demonbolt)) or ((1083 - 558) == (2435 - (89 + 237)))) then
									return "demonbolt main 32";
								end
							end
							v152 = 22 - 15;
						end
						if (((69 - 36) == (914 - (581 + 300))) and ((1220 - (855 + 365)) == v152)) then
							if (((7253 - 4199) <= (1311 + 2704)) and not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) then
								local v155 = v102();
								if (((3106 - (1030 + 205)) < (3176 + 206)) and v155) then
									return v155;
								end
							end
							if (((1203 + 90) <= (2452 - (156 + 130))) and not v14:IsCasting() and not v14:IsChanneling()) then
								local v156 = v83.Interrupt(v61.SpellLock, 90 - 50, true);
								if (v156 or ((4346 - 1767) < (251 - 128))) then
									return v156;
								end
								v156 = v83.Interrupt(v61.SpellLock, 11 + 29, true, v17, v63.SpellLockMouseover);
								if (v156 or ((494 + 352) >= (2437 - (10 + 59)))) then
									return v156;
								end
								v156 = v83.Interrupt(v61.AxeToss, 12 + 28, true);
								if (v156 or ((19758 - 15746) <= (4521 - (671 + 492)))) then
									return v156;
								end
								v156 = v83.Interrupt(v61.AxeToss, 32 + 8, true, v17, v63.AxeTossMouseover);
								if (((2709 - (369 + 846)) <= (796 + 2209)) and v156) then
									return v156;
								end
								v156 = v83.InterruptWithStun(v61.AxeToss, 35 + 5, true);
								if (v156 or ((5056 - (1036 + 909)) == (1697 + 437))) then
									return v156;
								end
								v156 = v83.InterruptWithStun(v61.AxeToss, 67 - 27, true, v17, v63.AxeTossMouseover);
								if (((2558 - (11 + 192)) == (1191 + 1164)) and v156) then
									return v156;
								end
							end
							if ((v14:AffectingCombat() and v58) or ((763 - (135 + 40)) <= (1046 - 614))) then
								if (((2892 + 1905) >= (8580 - 4685)) and v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v110 and ((GetTime() - v109) >= (1 - 0)) and (v14:HealthPercentage() >= v59)) then
									if (((3753 - (50 + 126)) == (9960 - 6383)) and v25(v61.BurningRush)) then
										return "burning_rush defensive 2";
									end
								elseif (((840 + 2954) > (5106 - (1233 + 180))) and v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v110 or (v14:HealthPercentage() <= v59))) then
									if (v25(v63.CancelBurningRush) or ((2244 - (522 + 447)) == (5521 - (107 + 1314)))) then
										return "burning_rush defensive 4";
									end
								end
							end
							v153 = v111();
							v152 = 1 + 0;
						end
						if ((v152 == (11 - 7)) or ((676 + 915) >= (7109 - 3529))) then
							if (((3889 - 2906) <= (3718 - (716 + 1194))) and v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v79 * (1 + 1)))) and (v77 < (1 + 3))) or (v77 < ((507 - (74 + 429)) - (v27(v82 > (3 - 1)))))) and not v14:PrevGCDP(1 + 0, v61.Demonbolt) and v14:HasTier(70 - 39, 2 + 0)) then
								if (v83.CastCycle(v61.Demonbolt, v81, v97, not v15:IsSpellInRange(v61.Demonbolt)) or ((6628 - 4478) <= (2959 - 1762))) then
									return "demonbolt main 8";
								end
							end
							if (((4202 - (279 + 154)) >= (1951 - (454 + 324))) and v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime() + 3 + 0)))) and v14:HasTier(48 - (12 + 5), 2 + 0)) then
								if (((3783 - 2298) == (549 + 936)) and v24(v61.PowerSiphon, v56)) then
									return "power_siphon main 10";
								end
							end
							if ((v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v79)) or ((4408 - (277 + 816)) <= (11887 - 9105))) then
								if (v24(v61.DemonicStrength, v52) or ((2059 - (1058 + 125)) >= (556 + 2408))) then
									return "demonic_strength main 12";
								end
							end
							if ((v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) or ((3207 - (815 + 160)) > (10713 - 8216))) then
								if (v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(94 - 54)) or ((504 + 1606) <= (970 - 638))) then
									return "bilescourge_bombers main 14";
								end
							end
							v152 = 1903 - (41 + 1857);
						end
						if (((5579 - (1222 + 671)) > (8198 - 5026)) and ((1 - 0) == v152)) then
							if (v153 or ((5656 - (229 + 953)) < (2594 - (1111 + 663)))) then
								return v153;
							end
							if (((5858 - (874 + 705)) >= (404 + 2478)) and v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) then
								if (v25(v61.UnendingResolve) or ((1385 + 644) >= (7318 - 3797))) then
									return "unending_resolve defensive";
								end
							end
							v103();
							if (v90() or (v66 < (1 + 21)) or ((2716 - (642 + 37)) >= (1059 + 3583))) then
								local v157 = v106();
								if (((276 + 1444) < (11192 - 6734)) and v157 and v34 and v33) then
									return v157;
								end
							end
							v152 = 456 - (233 + 221);
						end
						if (((18 - 10) == v152) or ((384 + 52) > (4562 - (718 + 823)))) then
							if (((449 + 264) <= (1652 - (266 + 539))) and v61.Doom:IsReady()) then
								if (((6098 - 3944) <= (5256 - (636 + 589))) and v83.CastCycle(v61.Doom, v80, v99, not v15:IsSpellInRange(v61.Doom))) then
									return "doom main 42";
								end
							end
							if (((10954 - 6339) == (9518 - 4903)) and v61.ShadowBolt:IsCastable()) then
								if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((3004 + 786) == (182 + 318))) then
									return "shadow_bolt main 44";
								end
							end
							break;
						end
						if (((1104 - (657 + 358)) < (584 - 363)) and (v152 == (11 - 6))) then
							if (((3241 - (1151 + 36)) >= (1373 + 48)) and v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v79) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) then
								if (((182 + 510) < (9132 - 6074)) and v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(1872 - (1552 + 280)))) then
									return "guillotine main 16";
								end
							end
							if ((v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (859 - (64 + 770))) or (v75 > (17 + 8)) or v14:BuffUp(v61.NetherPortalBuff))) or ((7386 - 4132) == (294 + 1361))) then
								if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((2539 - (157 + 1086)) == (9827 - 4917))) then
									return "call_dreadstalkers main 18";
								end
							end
							if (((14750 - 11382) == (5166 - 1798)) and v61.Implosion:IsReady() and (v86(2 - 0) > (819 - (599 + 220))) and v70 and not v14:PrevGCDP(1 - 0, v61.Implosion)) then
								if (((4574 - (1813 + 118)) < (2789 + 1026)) and v24(v61.Implosion, v54, nil, not v15:IsInRange(1257 - (841 + 376)))) then
									return "implosion main 20";
								end
							end
							if (((2679 - 766) > (115 + 378)) and v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (27 - 17)) and (v82 > (860 - (464 + 395)))) then
								if (((12203 - 7448) > (1647 + 1781)) and v24(v61.SummonSoulkeeper)) then
									return "soul_strike main 22";
								end
							end
							v152 = 843 - (467 + 370);
						end
						if (((2853 - 1472) <= (1739 + 630)) and (v152 == (23 - 16))) then
							if ((v61.Demonbolt:IsReady() and (v66 < (v14:BuffStack(v61.DemonicCoreBuff) * v79))) or ((756 + 4087) == (9501 - 5417))) then
								if (((5189 - (150 + 370)) > (1645 - (74 + 1208))) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
									return "demonbolt main 34";
								end
							end
							if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (9 - 5)) and (v77 < (18 - 14)) and not v71) or ((1336 + 541) >= (3528 - (14 + 376)))) then
								if (((8224 - 3482) >= (2347 + 1279)) and v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt))) then
									return "demonbolt main 36";
								end
							end
							if ((v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) or ((3989 + 551) == (874 + 42))) then
								if (v24(v61.PowerSiphon, v56) or ((3387 - 2231) > (3269 + 1076))) then
									return "power_siphon main 38";
								end
							end
							if (((2315 - (23 + 55)) < (10069 - 5820)) and v61.SummonVilefiend:IsReady() and (v66 < (v61.SummonDemonicTyrant:CooldownRemains() + 4 + 1))) then
								if (v24(v61.SummonVilefiend) or ((2410 + 273) < (35 - 12))) then
									return "summon_vilefiend main 40";
								end
							end
							v152 = 3 + 5;
						end
						if (((1598 - (652 + 249)) <= (2210 - 1384)) and (v152 == (1871 - (708 + 1160)))) then
							if (((2999 - 1894) <= (2143 - 967)) and (((v61.SummonDemonicTyrant:CooldownRemains() < (42 - (10 + 17))) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (2 + 3))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (1737 - (1400 + 332)))) and ((v61.GrimoireFelguard:CooldownRemains() < (19 - 9)) or not v14:HasTier(1938 - (242 + 1666), 1 + 1)) and ((v75 < (6 + 9)) or (v66 < (35 + 5)) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (955 - (850 + 90))) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (8 - 3))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (1395 - (360 + 1030)))) and ((v61.GrimoireFelguard:CooldownRemains() < (9 + 1)) or not v14:HasTier(84 - 54, 2 - 0)) and ((v75 < (1676 - (909 + 752))) or (v66 < (1263 - (109 + 1114))) or v14:PowerInfusionUp())))) then
								local v158 = 0 - 0;
								local v159;
								while true do
									if (((1316 + 2063) <= (4054 - (6 + 236))) and (v158 == (0 + 0))) then
										v159 = v107();
										if (v159 or ((635 + 153) >= (3810 - 2194))) then
											return v159;
										end
										break;
									end
								end
							end
							if (((3237 - 1383) <= (4512 - (1076 + 57))) and (v61.SummonDemonicTyrant:CooldownRemains() < (3 + 12)) and (v94() or (not v61.SummonVilefiend:IsAvailable() and (v88() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(719 - (579 + 110), 1 + 1)))) and ((v75 < (14 + 1)) or v88() or (v66 < (22 + 18)) or v14:PowerInfusionUp())) then
								local v160 = v107();
								if (((4956 - (174 + 233)) == (12706 - 8157)) and v160) then
									return v160;
								end
							end
							if ((v61.SummonDemonicTyrant:IsCastable() and v57 and (v94() or v88() or (v61.GrimoireFelguard:CooldownRemains() > (157 - 67)))) or ((1344 + 1678) >= (4198 - (663 + 511)))) then
								if (((4301 + 519) > (478 + 1720)) and v24(v61.SummonDemonicTyrant)) then
									return "summon_demonic_tyrant main 4";
								end
							end
							if ((v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (138 - 93))) or ((643 + 418) >= (11514 - 6623))) then
								if (((3301 - 1937) <= (2135 + 2338)) and v24(v61.SummonVilefiend)) then
									return "summon_vilefiend main 6";
								end
							end
							v152 = 7 - 3;
						end
						if ((v152 == (2 + 0)) or ((329 + 3266) <= (725 - (478 + 244)))) then
							v153 = v105();
							if (v153 or ((5189 - (440 + 77)) == (1752 + 2100))) then
								return v153;
							end
							if (((5705 - 4146) == (3115 - (655 + 901))) and (v66 < (6 + 24))) then
								local v161 = v108();
								if (v161 or ((1342 + 410) <= (533 + 255))) then
									return v161;
								end
							end
							if ((v61.HandofGuldan:IsReady() and (v78 < (0.5 - 0)) and (((v66 % (1540 - (695 + 750))) > (136 - 96)) or ((v66 % (146 - 51)) < (60 - 45))) and (v61.ReignofTyranny:IsAvailable() or (v82 > (353 - (285 + 66))))) or ((9107 - 5200) == (1487 - (682 + 628)))) then
								if (((560 + 2910) > (854 - (176 + 123))) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
									return "hand_of_guldan main 2";
								end
							end
							v152 = 2 + 1;
						end
					end
				end
				break;
			end
			if ((v130 == (1 + 0)) or ((1241 - (239 + 30)) == (176 + 469))) then
				v33 = EpicSettings.Toggles['cds'];
				if (((3059 + 123) >= (3743 - 1628)) and v32) then
					v81 = v15:GetEnemiesInSplashRange(24 - 16);
					v82 = v15:GetEnemiesInSplashRangeCount(323 - (306 + 9));
					v80 = v14:GetEnemiesInRange(139 - 99);
				else
					local v154 = 0 + 0;
					while true do
						if (((2389 + 1504) < (2132 + 2297)) and (v154 == (0 - 0))) then
							v81 = {};
							v82 = 1376 - (1140 + 235);
							v154 = 1 + 0;
						end
						if ((v154 == (1 + 0)) or ((736 + 2131) < (1957 - (33 + 19)))) then
							v80 = {};
							break;
						end
					end
				end
				UpdateLastMoveTime();
				v130 = 1 + 1;
			end
		end
	end
	local function v113()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 + 0)) or ((3521 - 1725) >= (3799 + 252))) then
				v61.DoomBrandDebuff:RegisterAuraTracking();
				v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v11.SetAPL(955 - (586 + 103), v112, v113);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

