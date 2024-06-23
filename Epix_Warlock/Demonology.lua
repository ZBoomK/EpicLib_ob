local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 841 - (232 + 609);
	local v7;
	while true do
		if ((v6 == (1 + 0)) or ((2306 - (797 + 636)) == (9875 - 7841))) then
			return v7(v0, ...);
		end
		if ((v6 == (1619 - (1427 + 192))) or ((976 + 1840) < (25 - 14))) then
			v7 = v1[v5];
			if (((3325 + 374) < (2133 + 2573)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 327 - (192 + 134);
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
		local v115 = 1276 - (316 + 960);
		while true do
			if (((1473 + 1173) >= (677 + 199)) and (v115 == (7 + 0))) then
				v58 = EpicSettings.Settings['UseBurningRush'] or (0 - 0);
				v59 = EpicSettings.Settings['BurningRushHP'] or (551 - (83 + 468));
				v45 = EpicSettings.Settings['DrainLifeHP'] or (1806 - (1202 + 604));
				v115 = 37 - 29;
			end
			if (((1021 - 407) <= (8815 - 5631)) and (v115 == (330 - (45 + 280)))) then
				v52 = EpicSettings.Settings['DemonicStrength'];
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v115 = 6 + 0;
			end
			if (((2732 + 394) == (1142 + 1984)) and (v115 == (3 + 1))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				v115 = 1916 - (340 + 1571);
			end
			if ((v115 == (0 + 0)) or ((3959 - (1733 + 39)) >= (13613 - 8659))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v115 = 1035 - (125 + 909);
			end
			if ((v115 == (1950 - (1096 + 852))) or ((1740 + 2137) == (5105 - 1530))) then
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (512 - (409 + 103));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (236 - (46 + 190));
				v115 = 98 - (51 + 44);
			end
			if (((200 + 507) > (1949 - (1114 + 203))) and (v115 == (732 - (228 + 498)))) then
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
				v115 = 4 + 3;
			end
			if ((v115 == (671 - (174 + 489))) or ((1422 - 876) >= (4589 - (830 + 1075)))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (524 - (303 + 221));
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (1269 - (231 + 1038));
				break;
			end
			if (((1221 + 244) <= (5463 - (171 + 991))) and (v115 == (12 - 9))) then
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v115 = 4 + 0;
			end
			if (((5972 - 4268) > (4110 - 2685)) and (v115 == (1 - 0))) then
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v38 = EpicSettings.Settings['HealingPotionHP'] or (1248 - (111 + 1137));
				v39 = EpicSettings.Settings['UseHealthstone'] or (158 - (91 + 67));
				v115 = 5 - 3;
			end
		end
	end
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = v21.Warlock.Demonology;
	local v64 = {};
	local v65 = 2773 + 8338;
	local v66 = 11634 - (423 + 100);
	local v67 = 1 + 13 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	local v68 = 0 - 0;
	local v69 = false;
	local v70 = false;
	local v71 = false;
	local v72 = 0 + 0;
	local v73 = 771 - (326 + 445);
	local v74 = 0 - 0;
	local v75 = 267 - 147;
	local v76 = 27 - 15;
	local v77 = 711 - (530 + 181);
	local v78 = 881 - (614 + 267);
	local v79 = 32 - (19 + 13);
	local v80;
	local v81, v82;
	v11:RegisterForEvent(function()
		local v116 = 0 - 0;
		while true do
			if ((v116 == (0 - 0)) or ((1962 - 1275) == (1100 + 3134))) then
				v65 = 19540 - 8429;
				v66 = 23042 - 11931;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v83 = v11.Commons.Everyone;
	local v84 = {{v61.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v11:RegisterForEvent(function()
		local v117 = 0 - 0;
		while true do
			if (((0 - 0) == v117) or ((1764 + 1566) < (292 + 1137))) then
				v61.HandofGuldan:RegisterInFlight();
				v67 = (32 - 18) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v61.HandofGuldan:RegisterInFlight();
	local function v85()
		return v11.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v86(v118)
		local v119 = 0 + 0;
		for v139, v140 in pairs(v11.GuardiansTable.Pets) do
			if (((717 + 430) >= (1431 - (709 + 387))) and (v140.ImpCasts <= v118)) then
				v119 = v119 + (1859 - (673 + 1185));
			end
		end
		return v119;
	end
	local function v87()
		return v11.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v88()
		return v87() > (0 - 0);
	end
	local function v89()
		return v11.GuardiansTable.DemonicTyrantDuration or (0 - 0);
	end
	local function v90()
		return v89() > (0 + 0);
	end
	local function v91()
		return v11.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v92()
		return v91() > (0 - 0);
	end
	local function v93()
		return v11.GuardiansTable.VilefiendDuration or (0 + 0);
	end
	local function v94()
		return v93() > (0 - 0);
	end
	local function v95()
		return v11.GuardiansTable.PitLordDuration or (0 - 0);
	end
	local function v96()
		return v95() > (1880 - (446 + 1434));
	end
	local function v97(v120)
		return v120:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (1286 - (1040 + 243))));
	end
	local function v98(v121)
		return (v121:DebuffDown(v61.DoomBrandDebuff)) or (v82 < (11 - 7));
	end
	local function v99(v122)
		return (v122:DebuffRefreshable(v61.Doom));
	end
	local function v100(v123)
		return (v123:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v101(v124)
		return v124:DebuffRemains(v61.DoomBrandDebuff) > (1857 - (559 + 1288));
	end
	local function v102()
		local v125 = 1931 - (609 + 1322);
		while true do
			if (((3889 - (13 + 441)) > (7836 - 5739)) and ((0 - 0) == v125)) then
				v76 = 59 - 47;
				v67 = 1 + 13 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
				v125 = 3 - 2;
			end
			if ((v125 == (2 + 1)) or ((1652 + 2118) >= (11991 - 7950))) then
				if ((v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(1 + 0, v61.PowerSiphon)) or ((6972 - 3181) <= (1066 + 545))) then
					if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((2547 + 2031) <= (1443 + 565))) then
						return "demonbolt precombat 4";
					end
				end
				if (((945 + 180) <= (2032 + 44)) and v61.ShadowBolt:IsReady()) then
					if (v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((1176 - (153 + 280)) >= (12702 - 8303))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((1037 + 118) < (661 + 1012)) and (v125 == (1 + 0))) then
				v72 = 0 + 0;
				v73 = 0 + 0;
				v125 = 2 - 0;
			end
			if ((v125 == (2 + 0)) or ((2991 - (89 + 578)) <= (413 + 165))) then
				if (((7831 - 4064) == (4816 - (572 + 477))) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v85(), 1 + 1)) <= (3 + 1)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (1 + 2)))) then
					if (((4175 - (84 + 2)) == (6738 - 2649)) and v24(v61.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if (((3212 + 1246) >= (2516 - (497 + 345))) and v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) then
					if (((25 + 947) <= (240 + 1178)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt precombat 3";
					end
				end
				v125 = 1336 - (605 + 728);
			end
		end
	end
	local function v103()
		local v126 = 0 + 0;
		local v127;
		while true do
			if (((0 - 0) == v126) or ((227 + 4711) < (17606 - 12844))) then
				if ((((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (3 + 0)) and v61.NetherPortal:IsAvailable()) or (v66 < (55 - 35)) or (v90() and (v66 < (76 + 24))) or (v66 < (514 - (457 + 32))) or v90() or (not v61.SummonDemonicTyrant:IsAvailable() and v92())) and (v74 <= (0 + 0))) or ((3906 - (832 + 570)) > (4018 + 246))) then
					v73 = 32 + 88 + v78;
				end
				v74 = v73 - v78;
				if (((7618 - 5465) == (1038 + 1115)) and (((((v66 + v78) % (916 - (588 + 208))) <= (229 - 144)) and (((v66 + v78) % (1920 - (884 + 916))) >= (52 - 27))) or (v78 >= (122 + 88))) and (v74 > (653 - (232 + 421))) and not v61.GrandWarlocksDesign:IsAvailable()) then
					v75 = v74;
				else
					v75 = v61.SummonDemonicTyrant:CooldownRemains();
				end
				v126 = 1890 - (1569 + 320);
			end
			if ((v126 == (1 + 2)) or ((97 + 410) >= (8731 - 6140))) then
				v70 = false;
				if (((5086 - (316 + 289)) == (11729 - 7248)) and (v82 > (1 + 0 + v127))) then
					v70 = not v90();
				end
				if (((v82 > ((1455 - (666 + 787)) + v127)) and (v82 < ((430 - (360 + 65)) + v127))) or ((2176 + 152) < (947 - (79 + 175)))) then
					v70 = v89() < (9 - 3);
				end
				v126 = 4 + 0;
			end
			if (((13266 - 8938) == (8334 - 4006)) and (v126 == (901 - (503 + 396)))) then
				if (((1769 - (92 + 89)) >= (2583 - 1251)) and ((not v94() and v61.SummonVilefiend:IsAvailable()) or not v92())) then
					v68 = 0 + 0;
				end
				v69 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (18 + 12)) or v14:BuffUp(v61.NetherPortalBuff);
				v127 = v27(v61.SacrificedSouls:IsAvailable());
				v126 = 11 - 8;
			end
			if ((v126 == (1 + 3)) or ((9516 - 5342) > (3707 + 541))) then
				if ((v82 > (2 + 2 + v127)) or ((13967 - 9381) <= (11 + 71))) then
					v70 = v89() < (12 - 4);
				end
				v71 = (v61.SummonDemonicTyrant:CooldownRemains() < (1264 - (485 + 759))) and (v75 < (46 - 26)) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (1191 - (442 + 747))) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (1140 - (832 + 303)))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (951 - (88 + 858))));
				break;
			end
			if (((1178 + 2685) == (3198 + 665)) and (v126 == (1 + 0))) then
				if ((v94() and v92()) or ((1071 - (766 + 23)) <= (207 - 165))) then
					v68 = v30(v93(), v91()) - (v14:GCD() * (0.5 - 0));
				end
				if (((12143 - 7534) >= (2599 - 1833)) and not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v92()) then
					v68 = v30(v91(), v87()) - (v14:GCD() * (1073.5 - (1036 + 37)));
				end
				if ((not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(22 + 8, 3 - 1)) and v92()) or ((907 + 245) == (3968 - (641 + 839)))) then
					v68 = v91() - (v14:GCD() * (913.5 - (910 + 3)));
				end
				v126 = 4 - 2;
			end
		end
	end
	local function v104()
		local v128 = 1684 - (1466 + 218);
		local v129;
		while true do
			if (((1573 + 1849) > (4498 - (556 + 592))) and (v128 == (0 + 0))) then
				v129 = v83.HandleTopTrinket(v64, v33, 848 - (329 + 479), nil);
				if (((1731 - (174 + 680)) > (1291 - 915)) and v129) then
					return v129;
				end
				v128 = 1 - 0;
			end
			if ((v128 == (1 + 0)) or ((3857 - (396 + 343)) <= (164 + 1687))) then
				v129 = v83.HandleBottomTrinket(v64, v33, 1517 - (29 + 1448), nil);
				if (v129 or ((1554 - (135 + 1254)) >= (13154 - 9662))) then
					return v129;
				end
				break;
			end
		end
	end
	local function v105()
		local v130 = 0 - 0;
		local v131;
		while true do
			if (((2632 + 1317) < (6383 - (389 + 1138))) and ((575 - (102 + 472)) == v130)) then
				if (v131 or ((4036 + 240) < (1673 + 1343))) then
					return v131;
				end
				break;
			end
			if (((4374 + 316) > (5670 - (320 + 1225))) and (v130 == (0 - 0))) then
				if ((v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) or ((31 + 19) >= (2360 - (157 + 1307)))) then
					if (v25(v63.TimebreachingTalon) or ((3573 - (821 + 1038)) >= (7380 - 4422))) then
						return "timebreaching_talon items 2";
					end
				end
				v131 = v104();
				v130 = 1 + 0;
			end
		end
	end
	local function v106()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (0 + 0)) or ((3695 - 2204) < (1670 - (834 + 192)))) then
				if (((45 + 659) < (254 + 733)) and v61.Berserking:IsCastable()) then
					if (((80 + 3638) > (2952 - 1046)) and v25(v61.Berserking, v34)) then
						return "berserking ogcd 4";
					end
				end
				if (v61.BloodFury:IsCastable() or ((1262 - (300 + 4)) > (971 + 2664))) then
					if (((9164 - 5663) <= (4854 - (112 + 250))) and v25(v61.BloodFury, v34)) then
						return "blood_fury ogcd 6";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (2 - 1)) or ((1972 + 1470) < (1318 + 1230))) then
				if (((2151 + 724) >= (726 + 738)) and v61.Fireblood:IsCastable()) then
					if (v25(v61.Fireblood, v34) or ((3564 + 1233) >= (6307 - (1001 + 413)))) then
						return "fireblood ogcd 8";
					end
				end
				if (v61.AncestralCall:IsCastable() or ((1228 - 677) > (2950 - (244 + 638)))) then
					if (((2807 - (627 + 66)) > (2812 - 1868)) and v24(v61.AncestralCall, v34)) then
						return "ancestral_call racials 8";
					end
				end
				break;
			end
		end
	end
	local function v107()
		if (((v68 > (602 - (512 + 90))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79)) and (v73 <= (1906 - (1665 + 241)))) or ((2979 - (373 + 344)) >= (1397 + 1699))) then
			v73 = 32 + 88 + v78;
		end
		if ((v61.HandofGuldan:IsReady() and (v77 > (0 - 0)) and (v68 > (v79 + v61.SummonDemonicTyrant:CastTime())) and (v68 < (v79 * (6 - 2)))) or ((3354 - (35 + 1064)) >= (2574 + 963))) then
			if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((8209 - 4372) < (6 + 1300))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((4186 - (298 + 938)) == (4209 - (233 + 1026))) and (v68 > (1666 - (636 + 1030))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) then
			local v142 = 0 + 0;
			local v143;
			local v144;
			while true do
				if ((v142 == (1 + 0)) or ((1404 + 3319) < (223 + 3075))) then
					v143 = v106();
					if (((1357 - (55 + 166)) >= (30 + 124)) and v143) then
						return v143;
					end
					v142 = 1 + 1;
				end
				if (((0 - 0) == v142) or ((568 - (36 + 261)) > (8303 - 3555))) then
					v143 = v105();
					if (((6108 - (34 + 1334)) >= (1212 + 1940)) and v143) then
						return v143;
					end
					v142 = 1 + 0;
				end
				if ((v142 == (1285 - (1035 + 248))) or ((2599 - (20 + 1)) >= (1767 + 1623))) then
					v144 = v83.HandleDPSPotion();
					if (((360 - (134 + 185)) <= (2794 - (549 + 584))) and v144) then
						return v144;
					end
					break;
				end
			end
		end
		if (((1286 - (314 + 371)) < (12221 - 8661)) and v61.SummonDemonicTyrant:IsCastable() and (v68 > (968 - (478 + 490))) and (v68 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v79) + v79))) then
			if (((125 + 110) < (1859 - (786 + 386))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if (((14733 - 10184) > (2532 - (1055 + 324))) and v61.Implosion:IsReady() and (v85() > (1342 - (1093 + 247))) and not v92() and not v88() and not v94() and ((v82 > (3 + 0)) or ((v82 > (1 + 1)) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(3 - 2, v61.Implosion)) then
			if (v24(v61.Implosion, v54, nil, not v15:IsInRange(135 - 95)) or ((13299 - 8625) < (11740 - 7068))) then
				return "implosion tyrant 8";
			end
		end
		if (((1305 + 2363) < (17570 - 13009)) and v61.ShadowBolt:IsReady() and v14:PrevGCDP(3 - 2, v61.GrimoireFelguard) and (v78 > (23 + 7)) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) then
			if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((1163 - 708) == (4293 - (364 + 324)))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if ((v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (10 - 6)) and (not v94() or (not v61.SummonVilefiend:IsAvailable() and v91())) and v14:BuffDown(v61.NetherPortalBuff)) or ((6389 - 3726) == (1098 + 2214))) then
			if (((17896 - 13619) <= (7166 - 2691)) and v24(v61.PowerSiphon, v56)) then
				return "power_siphon tyrant 12";
			end
		end
		if ((v61.ShadowBolt:IsReady() and not v94() and v14:BuffDown(v61.NetherPortalBuff) and not v92() and (v77 < ((15 - 10) - v14:BuffStack(v61.DemonicCoreBuff)))) or ((2138 - (1249 + 19)) == (1074 + 115))) then
			if (((6045 - 4492) <= (4219 - (686 + 400))) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if ((v61.NetherPortal:IsReady() and (v77 == (4 + 1))) or ((2466 - (73 + 156)) >= (17 + 3494))) then
			if (v24(v61.NetherPortal, v55) or ((2135 - (721 + 90)) > (34 + 2986))) then
				return "nether_portal tyrant 16";
			end
		end
		if ((v61.SummonVilefiend:IsReady() and ((v77 == (16 - 11)) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (483 - (224 + 246))) and v69) or ((4846 - 1854) == (3463 - 1582))) then
			if (((564 + 2542) > (37 + 1489)) and v24(v61.SummonVilefiend)) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if (((2221 + 802) < (7694 - 3824)) and v61.CallDreadstalkers:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (99 - 69))) and (v14:BuffUp(v61.NetherPortalBuff) or v88() or (v77 == (518 - (203 + 310)))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (2004 - (1238 + 755))) and v69) then
			if (((10 + 133) > (1608 - (709 + 825))) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if (((32 - 14) < (3076 - 964)) and v61.GrimoireFelguard:IsReady() and (v94() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (894 - (196 + 668)))) and (v14:BuffUp(v61.NetherPortalBuff) or v92() or (v77 == (19 - 14))) and v69))) then
			if (((2272 - 1175) <= (2461 - (171 + 662))) and v24(v61.GrimoireFelguard, v53)) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if (((4723 - (4 + 89)) == (16228 - 11598)) and v61.HandofGuldan:IsReady() and (((v77 > (1 + 1)) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92())) and ((v77 > (8 - 6)) or (v93() < ((v79 * (1 + 1)) + ((1488 - (35 + 1451)) / v14:SpellHaste()))))) or (not v92() and (v77 == (1458 - (28 + 1425)))))) then
			if (((5533 - (941 + 1052)) > (2573 + 110)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if (((6308 - (822 + 692)) >= (4675 - 1400)) and v61.Demonbolt:IsReady() and (v77 < (2 + 2)) and (v14:BuffStack(v61.DemonicCoreBuff) > (298 - (45 + 252))) and (v94() or (not v61.SummonVilefiend:IsAvailable() and v92()) or not v23())) then
			if (((1469 + 15) == (511 + 973)) and ((v61.DoomBrandDebuff:AuraActiveCount() == v82) or not v14:HasTier(75 - 44, 435 - (114 + 319)))) then
				if (((2055 - 623) < (4555 - 1000)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
					return "demonbolt tyrant 26";
				end
			elseif (v83.CastCycle(v61.Demonbolt, v81, v100, not v15:IsSpellInRange(v61.Demonbolt)) or ((679 + 386) > (5330 - 1752))) then
				return "demonbolt tyrant 27";
			end
		end
		if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (5 - 2)) and (v68 > (v61.SummonDemonicTyrant:ExecuteTime() + (v79 * (1966 - (556 + 1407)))))) or (v68 == (1206 - (741 + 465))))) or ((5260 - (170 + 295)) < (742 + 665))) then
			if (((1703 + 150) < (11849 - 7036)) and v24(v61.PowerSiphon)) then
				return "power_siphon tyrant 28";
			end
		end
		if (v61.ShadowBolt:IsCastable() or ((2339 + 482) < (1560 + 871))) then
			if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((1628 + 1246) < (3411 - (957 + 273)))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v108()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (1 + 1)) or ((10246 - 7557) <= (903 - 560))) then
				if ((v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (9 - 6)) and (v66 < (99 - 79))) or ((3649 - (389 + 1391)) == (1261 + 748))) then
					if (v24(v61.PowerSiphon, v56) or ((370 + 3176) < (5285 - 2963))) then
						return "power_siphon fight_end 14";
					end
				end
				if ((v61.Implosion:IsReady() and v54 and (v66 < ((953 - (783 + 168)) * v79))) or ((6987 - 4905) == (4695 + 78))) then
					if (((3555 - (309 + 2)) > (3239 - 2184)) and v24(v61.Implosion, nil, nil, not v15:IsInRange(1252 - (1090 + 122)))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if ((v133 == (0 + 0)) or ((11126 - 7813) <= (1217 + 561))) then
				if ((v61.SummonDemonicTyrant:IsCastable() and (v66 < (1138 - (628 + 490)))) or ((255 + 1166) >= (5208 - 3104))) then
					if (((8280 - 6468) <= (4023 - (431 + 343))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if (((3277 - 1654) <= (5661 - 3704)) and (v66 < (16 + 4))) then
					local v169 = 0 + 0;
					while true do
						if (((6107 - (556 + 1139)) == (4427 - (6 + 9))) and (v169 == (0 + 0))) then
							if (((897 + 853) >= (1011 - (28 + 141))) and v61.GrimoireFelguard:IsReady() and v53) then
								if (((1694 + 2678) > (2283 - 433)) and v24(v61.GrimoireFelguard)) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((165 + 67) < (2138 - (486 + 831))) and v61.CallDreadstalkers:IsReady()) then
								if (((1347 - 829) < (3175 - 2273)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v169 = 1 + 0;
						end
						if (((9466 - 6472) > (2121 - (668 + 595))) and (v169 == (1 + 0))) then
							if (v61.SummonVilefiend:IsReady() or ((758 + 2997) <= (2495 - 1580))) then
								if (((4236 - (23 + 267)) > (5687 - (1129 + 815))) and v24(v61.SummonVilefiend)) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
					end
				end
				v133 = 388 - (371 + 16);
			end
			if ((v133 == (1751 - (1326 + 424))) or ((2528 - 1193) >= (12080 - 8774))) then
				if (((4962 - (88 + 30)) > (3024 - (720 + 51))) and v61.NetherPortal:IsReady() and v55 and (v66 < (66 - 36))) then
					if (((2228 - (421 + 1355)) == (744 - 292)) and v24(v61.NetherPortal)) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v61.DemonicStrength:IsCastable() and (v66 < (5 + 5))) or ((5640 - (286 + 797)) < (7629 - 5542))) then
					if (((6416 - 2542) == (4313 - (397 + 42))) and v24(v61.DemonicStrength, v52)) then
						return "demonic_strength fight_end 12";
					end
				end
				v133 = 1 + 1;
			end
		end
	end
	local v109 = 800 - (24 + 776);
	local v110 = false;
	function UpdateLastMoveTime()
		if (v14:IsMoving() or ((2985 - 1047) > (5720 - (222 + 563)))) then
			if (not v110 or ((9375 - 5120) < (2465 + 958))) then
				local v158 = 190 - (23 + 167);
				while true do
					if (((3252 - (690 + 1108)) <= (899 + 1592)) and (v158 == (0 + 0))) then
						v109 = GetTime();
						v110 = true;
						break;
					end
				end
			end
		else
			v110 = false;
		end
	end
	local function v111()
		if (v14:AffectingCombat() or ((5005 - (40 + 808)) <= (462 + 2341))) then
			if (((18557 - 13704) >= (2851 + 131)) and (v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) then
				if (((2187 + 1947) > (1841 + 1516)) and v25(v61.DarkPact)) then
					return "dark_pact defensive 2";
				end
			end
			if (((v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) or ((3988 - (47 + 524)) < (1645 + 889))) then
				if (v25(v61.DrainLife) or ((7440 - 4718) <= (244 - 80))) then
					return "drain_life defensive 2";
				end
			end
			if (((v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) or ((5491 - 3083) < (3835 - (1165 + 561)))) then
				if (v25(v61.UnendingResolve) or ((1 + 32) == (4506 - 3051))) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v112()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (482 - (341 + 138))) or ((120 + 323) >= (8285 - 4270))) then
				if (((3708 - (89 + 237)) > (533 - 367)) and v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (21 - 11)) and (v82 > (882 - (581 + 300)))) then
					if (v24(v61.SummonSoulkeeper) or ((1500 - (855 + 365)) == (7265 - 4206))) then
						return "soul_strike main 22";
					end
				end
				if (((615 + 1266) > (2528 - (1030 + 205))) and v61.HandofGuldan:IsReady() and (((v77 > (2 + 0)) and (v61.CallDreadstalkers:CooldownRemains() > (v79 * (4 + 0))) and (v61.SummonDemonicTyrant:CooldownRemains() > (303 - (156 + 130)))) or (v77 == (11 - 6)) or ((v77 == (6 - 2)) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v79 * (3 - 1))))) and (v82 == (1 + 0)) and v61.GrandWarlocksDesign:IsAvailable()) then
					if (((1375 + 982) == (2426 - (10 + 59))) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
						return "hand_of_guldan main 26";
					end
				end
				if (((35 + 88) == (605 - 482)) and v61.HandofGuldan:IsReady() and (v77 > (1165 - (671 + 492))) and not ((v82 == (1 + 0)) and v61.GrandWarlocksDesign:IsAvailable())) then
					if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((2271 - (369 + 846)) >= (899 + 2493))) then
						return "hand_of_guldan main 28";
					end
				end
				v134 = 4 + 0;
			end
			if ((v134 == (1945 - (1036 + 909))) or ((860 + 221) < (1804 - 729))) then
				if ((v61.SummonDemonicTyrant:IsCastable() and v57 and (v94() or v88() or (v61.GrimoireFelguard:CooldownRemains() > (293 - (11 + 192))))) or ((531 + 518) >= (4607 - (135 + 40)))) then
					if (v24(v61.SummonDemonicTyrant) or ((11552 - 6784) <= (510 + 336))) then
						return "summon_demonic_tyrant main 4";
					end
				end
				if ((v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (98 - 53))) or ((5033 - 1675) <= (1596 - (50 + 126)))) then
					if (v24(v61.SummonVilefiend) or ((10411 - 6672) <= (666 + 2339))) then
						return "summon_vilefiend main 6";
					end
				end
				if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v79 * (1415 - (1233 + 180))))) and (v77 < (973 - (522 + 447)))) or (v77 < ((1425 - (107 + 1314)) - (v27(v82 > (1 + 1)))))) and not v14:PrevGCDP(2 - 1, v61.Demonbolt) and v14:HasTier(14 + 17, 3 - 1)) or ((6563 - 4904) >= (4044 - (716 + 1194)))) then
					if (v83.CastCycle(v61.Demonbolt, v81, v97, not v15:IsSpellInRange(v61.Demonbolt)) or ((56 + 3204) < (253 + 2102))) then
						return "demonbolt main 8";
					end
				end
				v134 = 504 - (74 + 429);
			end
			if ((v134 == (11 - 5)) or ((332 + 337) == (9666 - 5443))) then
				if (v61.Doom:IsReady() or ((1198 + 494) < (1812 - 1224))) then
					if (v83.CastCycle(v61.Doom, v80, v99, not v15:IsSpellInRange(v61.Doom)) or ((11860 - 7063) < (4084 - (279 + 154)))) then
						return "doom main 42";
					end
				end
				if (v61.ShadowBolt:IsCastable() or ((4955 - (454 + 324)) > (3816 + 1034))) then
					if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((417 - (12 + 5)) > (600 + 511))) then
						return "shadow_bolt main 44";
					end
				end
				break;
			end
			if (((7773 - 4722) > (372 + 633)) and (v134 == (1097 - (277 + 816)))) then
				if (((15780 - 12087) <= (5565 - (1058 + 125))) and v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (((v77 < (979 - (815 + 160))) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v79 * (8 - 6))) or (v77 < (4 - 2))) and not v71) then
					if (v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt)) or ((783 + 2499) > (11984 - 7884))) then
						return "demonbolt main 30";
					end
				end
				if ((v61.Demonbolt:IsReady() and v14:HasTier(1929 - (41 + 1857), 1895 - (1222 + 671)) and v14:BuffUp(v61.DemonicCoreBuff) and (v77 < (10 - 6)) and not v71) or ((5145 - 1565) < (4026 - (229 + 953)))) then
					if (((1863 - (1111 + 663)) < (6069 - (874 + 705))) and v83.CastTargetIf(v61.Demonbolt, v81, "==", v98, v101, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt main 32";
					end
				end
				if ((v61.Demonbolt:IsReady() and (v66 < (v14:BuffStack(v61.DemonicCoreBuff) * v79))) or ((698 + 4285) < (1234 + 574))) then
					if (((7958 - 4129) > (107 + 3662)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt main 34";
					end
				end
				v134 = 684 - (642 + 37);
			end
			if (((339 + 1146) <= (465 + 2439)) and (v134 == (2 - 1))) then
				if (((4723 - (233 + 221)) == (9871 - 5602)) and v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v79 + v61.Demonbolt:TravelTime() + 3 + 0)))) and v14:HasTier(1572 - (718 + 823), 2 + 0)) then
					if (((1192 - (266 + 539)) <= (7876 - 5094)) and v24(v61.PowerSiphon, v56)) then
						return "power_siphon main 10";
					end
				end
				if ((v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v79)) or ((3124 - (636 + 589)) <= (2176 - 1259))) then
					if (v24(v61.DemonicStrength, v52) or ((8893 - 4581) <= (695 + 181))) then
						return "demonic_strength main 12";
					end
				end
				if (((811 + 1421) <= (3611 - (657 + 358))) and v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) then
					if (((5547 - 3452) < (8397 - 4711)) and v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(1227 - (1151 + 36)))) then
						return "bilescourge_bombers main 14";
					end
				end
				v134 = 2 + 0;
			end
			if ((v134 == (1 + 1)) or ((4763 - 3168) >= (6306 - (1552 + 280)))) then
				if ((v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v79) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) or ((5453 - (64 + 770)) < (1957 + 925))) then
					if (v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(90 - 50)) or ((53 + 241) >= (6074 - (157 + 1086)))) then
						return "guillotine main 16";
					end
				end
				if (((4060 - 2031) <= (13507 - 10423)) and v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (37 - 12)) or (v75 > (33 - 8)) or v14:BuffUp(v61.NetherPortalBuff))) then
					if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((2856 - (599 + 220)) == (4819 - 2399))) then
						return "call_dreadstalkers main 18";
					end
				end
				if (((6389 - (1813 + 118)) > (2854 + 1050)) and v61.Implosion:IsReady() and (v86(1219 - (841 + 376)) > (0 - 0)) and v70 and not v14:PrevGCDP(1 + 0, v61.Implosion)) then
					if (((1190 - 754) >= (982 - (464 + 395))) and v24(v61.Implosion, v54, nil, not v15:IsInRange(102 - 62))) then
						return "implosion main 20";
					end
				end
				v134 = 2 + 1;
			end
			if (((1337 - (467 + 370)) < (3752 - 1936)) and (v134 == (4 + 1))) then
				if (((12251 - 8677) == (558 + 3016)) and v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (8 - 4)) and (v77 < (524 - (150 + 370))) and not v71) then
					if (((1503 - (74 + 1208)) < (959 - 569)) and v83.CastCycle(v61.Demonbolt, v81, v98, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt main 36";
					end
				end
				if ((v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) or ((10495 - 8282) <= (1012 + 409))) then
					if (((3448 - (14 + 376)) < (8429 - 3569)) and v24(v61.PowerSiphon, v56)) then
						return "power_siphon main 38";
					end
				end
				if ((v61.SummonVilefiend:IsReady() and (v66 < (v61.SummonDemonicTyrant:CooldownRemains() + 4 + 1))) or ((1139 + 157) >= (4241 + 205))) then
					if (v24(v61.SummonVilefiend) or ((4081 - 2688) > (3378 + 1111))) then
						return "summon_vilefiend main 40";
					end
				end
				v134 = 84 - (23 + 55);
			end
		end
	end
	local function v113()
		v60();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		if (v32 or ((10484 - 6060) < (19 + 8))) then
			v81 = v15:GetEnemiesInSplashRange(8 + 0);
			v80 = v14:GetEnemiesInRange(62 - 22);
			v82 = v29(#v81, #v80);
		else
			v81 = {};
			v80 = {};
			v82 = 1 + 0;
		end
		UpdateLastMoveTime();
		if (v83.TargetIsValid() or v14:AffectingCombat() or ((2898 - (652 + 249)) > (10209 - 6394))) then
			local v145 = 1868 - (708 + 1160);
			while true do
				if (((9405 - 5940) > (3487 - 1574)) and (v145 == (28 - (10 + 17)))) then
					if (((165 + 568) < (3551 - (1400 + 332))) and (v66 == (21311 - 10200))) then
						v66 = v11.FightRemains(v81, false);
					end
					v26.UpdatePetTable();
					v145 = 1910 - (242 + 1666);
				end
				if ((v145 == (2 + 1)) or ((1611 + 2784) == (4053 + 702))) then
					v77 = v14:SoulShardsP();
					v79 = v14:GCD() + (940.25 - (850 + 90));
					break;
				end
				if ((v145 == (3 - 1)) or ((5183 - (360 + 1030)) < (2097 + 272))) then
					v26.UpdateSoulShards();
					v78 = v11.CombatTime();
					v145 = 7 - 4;
				end
				if ((v145 == (0 - 0)) or ((5745 - (909 + 752)) == (1488 - (109 + 1114)))) then
					v65 = v11.BossFightRemains();
					v66 = v65;
					v145 = 1 - 0;
				end
			end
		end
		if (((1697 + 2661) == (4600 - (6 + 236))) and v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) then
			if (v25(v61.SummonPet, false, true) or ((1978 + 1160) < (800 + 193))) then
				return "summon_pet ooc";
			end
		end
		if (((7853 - 4523) > (4057 - 1734)) and v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) then
			if (v25(v63.Healthstone) or ((4759 - (1076 + 57)) == (656 + 3333))) then
				return "healthstone defensive 3";
			end
		end
		if ((v36 and (v14:HealthPercentage() <= v38)) or ((1605 - (579 + 110)) == (211 + 2460))) then
			local v146 = 0 + 0;
			while true do
				if (((145 + 127) == (679 - (174 + 233))) and (v146 == (0 - 0))) then
					if (((7457 - 3208) <= (2152 + 2687)) and (v37 == "Refreshing Healing Potion")) then
						if (((3951 - (663 + 511)) < (2855 + 345)) and v62.RefreshingHealingPotion:IsReady()) then
							if (((21 + 74) < (6033 - 4076)) and v25(v63.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((501 + 325) < (4042 - 2325)) and (v37 == "Dreamwalker's Healing Potion")) then
						if (((3451 - 2025) >= (528 + 577)) and v62.DreamwalkersHealingPotion:IsReady()) then
							if (((5359 - 2605) <= (2409 + 970)) and v25(v63.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (v83.TargetIsValid() or ((359 + 3568) == (2135 - (478 + 244)))) then
			if ((not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) or ((1671 - (440 + 77)) <= (359 + 429))) then
				local v159 = 0 - 0;
				local v160;
				while true do
					if ((v159 == (1556 - (655 + 901))) or ((305 + 1338) > (2587 + 792))) then
						v160 = v102();
						if (v160 or ((1893 + 910) > (18326 - 13777))) then
							return v160;
						end
						break;
					end
				end
			end
			if ((not v14:IsCasting() and not v14:IsChanneling()) or ((1665 - (695 + 750)) >= (10319 - 7297))) then
				local v161 = 0 - 0;
				local v162;
				while true do
					if (((11349 - 8527) == (3173 - (285 + 66))) and ((0 - 0) == v161)) then
						v162 = v83.Interrupt(v61.SpellLock, 1350 - (682 + 628), true);
						if (v162 or ((172 + 889) == (2156 - (176 + 123)))) then
							return v162;
						end
						v162 = v83.Interrupt(v61.SpellLock, 17 + 23, true, v17, v63.SpellLockMouseover);
						v161 = 1 + 0;
					end
					if (((3029 - (239 + 30)) > (371 + 993)) and (v161 == (3 + 0))) then
						if (v162 or ((8675 - 3773) <= (11215 - 7620))) then
							return v162;
						end
						v162 = v83.InterruptWithStun(v61.AxeToss, 355 - (306 + 9), true, v17, v63.AxeTossMouseover);
						if (v162 or ((13441 - 9589) == (51 + 242))) then
							return v162;
						end
						break;
					end
					if (((1 + 0) == v161) or ((751 + 808) == (13119 - 8531))) then
						if (v162 or ((5859 - (1140 + 235)) == (502 + 286))) then
							return v162;
						end
						v162 = v83.Interrupt(v61.AxeToss, 37 + 3, true);
						if (((1173 + 3395) >= (3959 - (33 + 19))) and v162) then
							return v162;
						end
						v161 = 1 + 1;
					end
					if (((3734 - 2488) < (1529 + 1941)) and ((3 - 1) == v161)) then
						v162 = v83.Interrupt(v61.AxeToss, 38 + 2, true, v17, v63.AxeTossMouseover);
						if (((4757 - (586 + 103)) >= (89 + 883)) and v162) then
							return v162;
						end
						v162 = v83.InterruptWithStun(v61.AxeToss, 123 - 83, true);
						v161 = 1491 - (1309 + 179);
					end
				end
			end
			if (((889 - 396) < (1695 + 2198)) and v14:AffectingCombat() and v58) then
				if ((v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v110 and ((GetTime() - v109) >= (2 - 1)) and (v14:HealthPercentage() >= v59)) or ((1113 + 360) >= (7079 - 3747))) then
					if (v25(v61.BurningRush) or ((8072 - 4021) <= (1766 - (295 + 314)))) then
						return "burning_rush defensive 2";
					end
				elseif (((1483 - 879) < (4843 - (1300 + 662))) and v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v110 or (v14:HealthPercentage() <= v59))) then
					if (v25(v63.CancelBurningRush) or ((2826 - 1926) == (5132 - (1178 + 577)))) then
						return "burning_rush defensive 4";
					end
				end
			end
			local v147 = v111();
			if (((2316 + 2143) > (1747 - 1156)) and v147) then
				return v147;
			end
			if (((4803 - (851 + 554)) >= (2118 + 277)) and v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) then
				if (v25(v61.UnendingResolve) or ((6054 - 3871) >= (6132 - 3308))) then
					return "unending_resolve defensive";
				end
			end
			v103();
			if (((2238 - (115 + 187)) == (1483 + 453)) and (v90() or (v66 < (21 + 1)))) then
				local v163 = 0 - 0;
				local v164;
				while true do
					if ((v163 == (1161 - (160 + 1001))) or ((4228 + 604) < (2976 + 1337))) then
						v164 = v106();
						if (((8368 - 4280) > (4232 - (237 + 121))) and v164 and v34 and v33) then
							return v164;
						end
						break;
					end
				end
			end
			local v147 = v105();
			if (((5229 - (525 + 372)) == (8212 - 3880)) and v147) then
				return v147;
			end
			if (((13139 - 9140) >= (3042 - (96 + 46))) and (v66 < (807 - (643 + 134)))) then
				local v165 = v108();
				if (v165 or ((912 + 1613) > (9744 - 5680))) then
					return v165;
				end
			end
			if (((16228 - 11857) == (4192 + 179)) and v61.HandofGuldan:IsReady() and (v78 < (0.5 - 0)) and (((v66 % (194 - 99)) > (759 - (316 + 403))) or ((v66 % (64 + 31)) < (41 - 26))) and (v61.ReignofTyranny:IsAvailable() or (v82 > (1 + 1)))) then
				if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((669 - 403) > (3534 + 1452))) then
					return "hand_of_guldan main 2";
				end
			end
			if (((642 + 1349) >= (3205 - 2280)) and (((v61.SummonDemonicTyrant:CooldownRemains() < (71 - 56)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (10 - 5))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (1 + 4))) and ((v61.GrimoireFelguard:CooldownRemains() < (19 - 9)) or not v14:HasTier(2 + 28, 5 - 3)) and ((v75 < (32 - (12 + 5))) or (v66 < (155 - 115)) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (31 - 16)) and (v61.SummonVilefiend:CooldownRemains() < (v79 * (10 - 5))) and (v61.CallDreadstalkers:CooldownRemains() < (v79 * (12 - 7))) and ((v61.GrimoireFelguard:CooldownRemains() < (3 + 7)) or not v14:HasTier(2003 - (1656 + 317), 2 + 0)) and ((v75 < (13 + 2)) or (v66 < (106 - 66)) or v14:PowerInfusionUp())))) then
				local v166 = v107();
				if (((2239 - 1784) < (2407 - (5 + 349))) and v166) then
					return v166;
				end
			end
			if (((v61.SummonDemonicTyrant:CooldownRemains() < (71 - 56)) and (v94() or (not v61.SummonVilefiend:IsAvailable() and (v88() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(1301 - (266 + 1005), 2 + 0)))) and ((v75 < (51 - 36)) or v88() or (v66 < (52 - 12)) or v14:PowerInfusionUp())) or ((2522 - (561 + 1135)) == (6321 - 1470))) then
				local v167 = 0 - 0;
				local v168;
				while true do
					if (((1249 - (507 + 559)) == (459 - 276)) and (v167 == (0 - 0))) then
						v168 = v107();
						if (((1547 - (212 + 176)) <= (2693 - (250 + 655))) and v168) then
							return v168;
						end
						break;
					end
				end
			end
			local v147 = v112();
			if (v147 or ((9563 - 6056) > (7544 - 3226))) then
				return v147;
			end
		end
	end
	local function v114()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1956 - (1869 + 87))) or ((10665 - 7590) <= (4866 - (484 + 1417)))) then
				v61.DoomBrandDebuff:RegisterAuraTracking();
				v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v11.SetAPL(570 - 304, v113, v114);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

