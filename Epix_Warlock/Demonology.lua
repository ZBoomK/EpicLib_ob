local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((1191 - (74 + 211)) >= (6022 - 3793))) then
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
		v36 = EpicSettings.Settings['HealingPotionName'] or (266 - (28 + 238));
		v37 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v38 = EpicSettings.Settings['UseHealthstone'] or (1559 - (1381 + 178));
		v39 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v42 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v47 = EpicSettings.Settings['SummonPet'];
		v48 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
		v49 = EpicSettings.Settings['DemonboltOpener'];
		v50 = EpicSettings.Settings["Use Guillotine"] or (470 - (381 + 89));
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
		v51 = EpicSettings.Settings['DemonicStrength'];
		v52 = EpicSettings.Settings['GrimoireFelguard'];
		v53 = EpicSettings.Settings['Implosion'];
		v54 = EpicSettings.Settings['NetherPortal'];
		v55 = EpicSettings.Settings['PowerSiphon'];
		v56 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
		v57 = EpicSettings.Settings['UseBurningRush'] or (0 - 0);
		v58 = EpicSettings.Settings['BurningRushHP'] or (1156 - (1074 + 82));
		v44 = EpicSettings.Settings['DrainLifeHP'] or (0 - 0);
		v45 = EpicSettings.Settings['HealthFunnelHP'] or (1784 - (214 + 1570));
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (1455 - (990 + 465));
	end
	local v60 = v18.Warlock.Demonology;
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = {v61.MirrorofFracturedTomorrows:ID(),v61.NymuesUnravelingSpindle:ID(),v61.TimeThiefsGambit:ID()};
	local v64 = v13:GetEquipment();
	local v65 = (v64[50 - 37] and v19(v64[1739 - (1668 + 58)])) or v19(626 - (512 + 114));
	local v66 = (v64[36 - 22] and v19(v64[28 - 14])) or v19(0 - 0);
	local v67 = v65:Level() or (0 + 0);
	local v68 = v66:Level() or (0 + 0);
	local v69 = v65:OnUseSpell();
	local v70 = v66:OnUseSpell();
	local v71 = (v69 and (v69.MaximumRange > (0 + 0)) and (v69.MaximumRange <= (337 - 237)) and v69.MaximumRange) or (2094 - (109 + 1885));
	local v72 = (v70 and (v70.MaximumRange > (1469 - (1269 + 200))) and (v70.MaximumRange <= (191 - 91)) and v70.MaximumRange) or (915 - (98 + 717));
	v71 = ((v65:ID() == v61.BelorrelostheSuncaller:ID()) and (836 - (802 + 24))) or v71;
	v72 = ((v66:ID() == v61.BelorrelostheSuncaller:ID()) and (17 - 7)) or v72;
	local v73 = v65:HasUseBuff();
	local v74 = v66:HasUseBuff();
	local v75 = (v65:ID() == v61.RubyWhelpShell:ID()) or (v65:ID() == v61.WhisperingIncarnateIcon:ID()) or (v65:ID() == v61.TimeThiefsGambit:ID());
	local v76 = (v66:ID() == v61.RubyWhelpShell:ID()) or (v66:ID() == v61.WhisperingIncarnateIcon:ID()) or (v66:ID() == v61.TimeThiefsGambit:ID());
	local v77 = v65:ID() == v61.NymuesUnravelingSpindle:ID();
	local v78 = v66:ID() == v61.NymuesUnravelingSpindle:ID();
	local v79 = v65:BuffDuration() + (v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()) * (25 - 5)) + (v26(v65:ID() == v61.NymuesUnravelingSpindle:ID()) * (1 + 1));
	local v80 = v66:BuffDuration() + (v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID()) * (16 + 4)) + (v26(v66:ID() == v61.NymuesUnravelingSpindle:ID()) * (1 + 1));
	local v81 = (v73 and (((v65:Cooldown() % (20 + 70)) == (0 - 0)) or (((300 - 210) % v65:Cooldown()) == (0 + 0))) and (1 + 0)) or (0.5 + 0);
	local v82 = (v74 and (((v66:Cooldown() % (66 + 24)) == (0 + 0)) or (((1523 - (797 + 636)) % v66:Cooldown()) == (0 - 0))) and (1620 - (1427 + 192))) or (0.5 + 0);
	local v83 = (v70 and not v69 and (4 - 2)) or (1 + 0);
	local v84 = (v70 and not v69 and (1 + 1)) or (327 - (192 + 134));
	if (((2564 - (316 + 960)) > (697 + 554)) and v69 and v70) then
		v83 = (not v73 and not v74 and (v68 > v67) and (2 + 0)) or (1 + 0);
		local v160 = ((v66:Cooldown() / v80) * v82 * ((3 - 2) - ((551.5 - (83 + 468)) * v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID())))) or (1806 - (1202 + 604));
		local v161 = ((v65:Cooldown() / v79) * v81 * ((4 - 3) - ((0.5 - 0) * v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()))) * ((2 - 1) + ((v67 - v68) / (425 - (45 + 280))))) or (0 + 0);
		if ((not v73 and v74) or (v74 and (v160 > v161)) or ((3943 + 570) < (1224 + 2128))) then
			v84 = 2 + 0;
		else
			v84 = 1 + 0;
		end
	end
	local v85 = 20574 - 9463;
	local v86 = 13022 - (340 + 1571);
	local v87 = 6 + 8 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
	local v88 = 1772 - (1733 + 39);
	local v89 = false;
	local v90 = false;
	local v91 = false;
	local v92 = 0 - 0;
	local v93 = 1034 - (125 + 909);
	local v94 = 1948 - (1096 + 852);
	local v95 = 54 + 66;
	local v96 = 16 - 4;
	local v97 = 0 + 0;
	local v98 = 512 - (409 + 103);
	local v99 = 236 - (46 + 190);
	local v100;
	local v101, v102;
	v10:RegisterForEvent(function()
		local v144 = 95 - (51 + 44);
		while true do
			if ((v144 == (0 + 0)) or ((3382 - (1114 + 203)) >= (3922 - (228 + 498)))) then
				v85 = 2408 + 8703;
				v86 = 6139 + 4972;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v103 = v10.Commons.Everyone;
	local v104 = {{v60.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v64 = v13:GetEquipment();
		v65 = (v64[1282 - (231 + 1038)] and v19(v64[11 + 2])) or v19(1162 - (171 + 991));
		v66 = (v64[57 - 43] and v19(v64[37 - 23])) or v19(0 - 0);
		v67 = v65:Level() or (0 + 0);
		v68 = v66:Level() or (0 - 0);
		v69 = v65:OnUseSpell();
		v70 = v66:OnUseSpell();
		v71 = (v69 and (v69.MaximumRange > (0 - 0)) and (v69.MaximumRange <= (161 - 61)) and v69.MaximumRange) or (309 - 209);
		v72 = (v70 and (v70.MaximumRange > (1248 - (111 + 1137))) and (v70.MaximumRange <= (258 - (91 + 67))) and v70.MaximumRange) or (297 - 197);
		v71 = ((v65:ID() == v61.BelorrelostheSuncaller:ID()) and (3 + 7)) or v71;
		v72 = ((v66:ID() == v61.BelorrelostheSuncaller:ID()) and (533 - (423 + 100))) or v72;
		v73 = v65:HasUseBuff();
		v74 = v66:HasUseBuff();
		v75 = (v65:ID() == v61.RubyWhelpShell:ID()) or (v65:ID() == v61.WhisperingIncarnateIcon:ID()) or (v65:ID() == v61.TimeThiefsGambit:ID());
		v76 = (v66:ID() == v61.RubyWhelpShell:ID()) or (v66:ID() == v61.WhisperingIncarnateIcon:ID()) or (v66:ID() == v61.TimeThiefsGambit:ID());
		v77 = v65:ID() == v61.NymuesUnravelingSpindle:ID();
		v78 = v66:ID() == v61.NymuesUnravelingSpindle:ID();
		v79 = v65:BuffDuration() + (v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()) * (1 + 19)) + (v26(v65:ID() == v61.NymuesUnravelingSpindle:ID()) * (5 - 3));
		v80 = v66:BuffDuration() + (v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID()) * (11 + 9)) + (v26(v66:ID() == v61.NymuesUnravelingSpindle:ID()) * (773 - (326 + 445)));
		v81 = (v73 and (((v65:Cooldown() % (392 - 302)) == (0 - 0)) or (((210 - 120) % v65:Cooldown()) == (711 - (530 + 181)))) and (882 - (614 + 267))) or (32.5 - (19 + 13));
		v82 = (v74 and (((v66:Cooldown() % (146 - 56)) == (0 - 0)) or (((257 - 167) % v66:Cooldown()) == (0 + 0))) and (1 - 0)) or (0.5 - 0);
		v83 = (v70 and not v69 and (1814 - (1293 + 519))) or (1 - 0);
		v84 = (v70 and not v69 and (4 - 2)) or (1 - 0);
		if ((v69 and v70) or ((18869 - 14493) <= (3488 - 2007))) then
			local v164 = 0 + 0;
			local v165;
			local v166;
			while true do
				if ((v164 == (0 + 0)) or ((7880 - 4488) >= (1096 + 3645))) then
					v83 = (not v73 and not v74 and (v68 > v67) and (1 + 1)) or (1 + 0);
					v165 = ((v66:Cooldown() / v80) * v82 * ((1097 - (709 + 387)) - ((1858.5 - (673 + 1185)) * v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID())))) or (0 - 0);
					v164 = 3 - 2;
				end
				if (((5470 - 2145) >= (1541 + 613)) and (v164 == (1 + 0))) then
					v166 = ((v65:Cooldown() / v79) * v81 * ((1 - 0) - ((0.5 + 0) * v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()))) * ((1 - 0) + ((v67 - v68) / (196 - 96)))) or (1880 - (446 + 1434));
					if ((not v73 and v74) or (v74 and (v165 > v166)) or ((2578 - (1040 + 243)) >= (9649 - 6416))) then
						v84 = 1849 - (559 + 1288);
					else
						v84 = 1932 - (609 + 1322);
					end
					break;
				end
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v145 = 454 - (13 + 441);
		while true do
			if (((16356 - 11979) > (4300 - 2658)) and ((0 - 0) == v145)) then
				v60.HandofGuldan:RegisterInFlight();
				v87 = 1 + 13 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v60.HandofGuldan:RegisterInFlight();
	local function v105()
		return v10.GuardiansTable.ImpCount or (0 - 0);
	end
	local function v106(v146)
		local v147 = 0 + 0;
		for v162, v163 in pairs(v10.GuardiansTable.Pets) do
			if (((2070 + 2653) > (4023 - 2667)) and (v163.ImpCasts <= v146)) then
				v147 = v147 + 1 + 0;
			end
		end
		return v147;
	end
	local function v107()
		return v10.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v108()
		return v107() > (0 + 0);
	end
	local function v109()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 + 0);
	end
	local function v110()
		return v109() > (0 + 0);
	end
	local function v111()
		return v10.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v112()
		return v111() > (0 + 0);
	end
	local function v113()
		return v10.GuardiansTable.VilefiendDuration or (433 - (153 + 280));
	end
	local function v114()
		return v113() > (0 - 0);
	end
	local function v115()
		return v10.GuardiansTable.PitLordDuration or (0 + 0);
	end
	local function v116()
		return v115() > (0 + 0);
	end
	local function v117(v148)
		return v148:DebuffDown(v60.DoomBrandDebuff) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) <= (2 + 1)));
	end
	local function v118(v149)
		return (v149:DebuffDown(v60.DoomBrandDebuff)) or (v102 < (4 + 0));
	end
	local function v119(v150)
		return (v150:DebuffRefreshable(v60.Doom));
	end
	local function v120(v151)
		return (v151:DebuffDown(v60.DoomBrandDebuff));
	end
	local function v121(v152)
		return v152:DebuffRemains(v60.DoomBrandDebuff) > (8 + 2);
	end
	local function v122()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (0 + 0)) or ((4803 - (89 + 578)) <= (2453 + 980))) then
				v96 = 24 - 12;
				v87 = (1063 - (572 + 477)) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				v153 = 1 + 0;
			end
			if (((2548 + 1697) <= (553 + 4078)) and (v153 == (89 - (84 + 2)))) then
				if (((7046 - 2770) >= (2820 + 1094)) and v60.Demonbolt:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and not v13:PrevGCDP(843 - (497 + 345), v60.PowerSiphon)) then
					if (((6 + 192) <= (738 + 3627)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt precombat 4";
					end
				end
				if (((6115 - (605 + 728)) > (3337 + 1339)) and v60.ShadowBolt:IsReady()) then
					if (((10813 - 5949) > (101 + 2096)) and v23(v62.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if ((v153 == (3 - 2)) or ((3336 + 364) == (6945 - 4438))) then
				v92 = 0 + 0;
				v93 = 489 - (457 + 32);
				v153 = 1 + 1;
			end
			if (((5876 - (832 + 570)) >= (259 + 15)) and (v153 == (1 + 1))) then
				if ((v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) + v28(v105(), 6 - 4)) <= (2 + 2)) or (v13:BuffRemains(v60.DemonicCoreBuff) < (799 - (588 + 208))))) or ((5104 - 3210) <= (3206 - (884 + 916)))) then
					if (((3290 - 1718) >= (888 + 643)) and v23(v60.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if ((v60.Demonbolt:IsReady() and not v14:IsInBossList() and v13:BuffUp(v60.DemonicCoreBuff)) or ((5340 - (232 + 421)) < (6431 - (1569 + 320)))) then
					if (((808 + 2483) > (317 + 1350)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt precombat 3";
					end
				end
				v153 = 9 - 6;
			end
		end
	end
	local function v123()
		local v154 = 605 - (316 + 289);
		local v155;
		while true do
			if (((10 - 6) == v154) or ((41 + 832) == (3487 - (666 + 787)))) then
				if ((v102 > ((429 - (360 + 65)) + v155)) or ((2632 + 184) < (265 - (79 + 175)))) then
					v90 = v109() < (12 - 4);
				end
				v91 = (v60.SummonDemonicTyrant:CooldownRemains() < (16 + 4)) and (v95 < (61 - 41)) and ((v13:BuffStack(v60.DemonicCoreBuff) <= (3 - 1)) or v13:BuffDown(v60.DemonicCoreBuff)) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (904 - (503 + 396)))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (186 - (92 + 89))));
				break;
			end
			if (((7175 - 3476) < (2414 + 2292)) and (v154 == (1 + 0))) then
				if (((10361 - 7715) >= (120 + 756)) and v114() and v112()) then
					v88 = v29(v113(), v111()) - (v13:GCD() * (0.5 - 0));
				end
				if (((536 + 78) <= (1521 + 1663)) and not v60.SummonVilefiend:IsAvailable() and v60.GrimoireFelguard:IsAvailable() and v112()) then
					v88 = v29(v111(), v107()) - (v13:GCD() * (0.5 - 0));
				end
				if (((391 + 2735) == (4766 - 1640)) and not v60.SummonVilefiend:IsAvailable() and (not v60.GrimoireFelguard:IsAvailable() or not v13:HasTier(1274 - (485 + 759), 4 - 2)) and v112()) then
					v88 = v111() - (v13:GCD() * (1189.5 - (442 + 747)));
				end
				v154 = 1137 - (832 + 303);
			end
			if ((v154 == (949 - (88 + 858))) or ((667 + 1520) >= (4100 + 854))) then
				v90 = false;
				if ((v102 > (1 + 0 + v155)) or ((4666 - (766 + 23)) == (17648 - 14073))) then
					v90 = not v110();
				end
				if (((966 - 259) > (1664 - 1032)) and (v102 > ((6 - 4) + v155)) and (v102 < ((1078 - (1036 + 37)) + v155))) then
					v90 = v109() < (5 + 1);
				end
				v154 = 7 - 3;
			end
			if ((v154 == (0 + 0)) or ((2026 - (641 + 839)) >= (3597 - (910 + 3)))) then
				if (((3734 - 2269) <= (5985 - (1466 + 218))) and ((v13:BuffUp(v60.NetherPortalBuff) and (v13:BuffRemains(v60.NetherPortalBuff) < (2 + 1)) and v60.NetherPortal:IsAvailable()) or (v86 < (1168 - (556 + 592))) or (v110() and (v86 < (36 + 64))) or (v86 < (833 - (329 + 479))) or v110() or (not v60.SummonDemonicTyrant:IsAvailable() and v112())) and (v94 <= (854 - (174 + 680)))) then
					v93 = (412 - 292) + v98;
				end
				v94 = v93 - v98;
				if (((3531 - 1827) > (1018 + 407)) and (((((v86 + v98) % (859 - (396 + 343))) <= (8 + 77)) and (((v86 + v98) % (1597 - (29 + 1448))) >= (1414 - (135 + 1254)))) or (v98 >= (791 - 581))) and (v94 > (0 - 0)) and not v60.GrandWarlocksDesign:IsAvailable()) then
					v95 = v94;
				else
					v95 = v60.SummonDemonicTyrant:CooldownRemains();
				end
				v154 = 1 + 0;
			end
			if ((v154 == (1529 - (389 + 1138))) or ((1261 - (102 + 472)) == (3996 + 238))) then
				if ((not v114() and v60.SummonVilefiend:IsAvailable()) or not v112() or ((1847 + 1483) < (1333 + 96))) then
					v88 = 1545 - (320 + 1225);
				end
				v89 = not v60.NetherPortal:IsAvailable() or (v60.NetherPortal:CooldownRemains() > (53 - 23)) or v13:BuffUp(v60.NetherPortalBuff);
				v155 = v26(v60.SacrificedSouls:IsAvailable());
				v154 = 2 + 1;
			end
		end
	end
	local function v124()
		local v156 = v103.HandleTopTrinket(v63, v32, 1504 - (157 + 1307), nil);
		if (((3006 - (821 + 1038)) >= (835 - 500)) and v156) then
			return v156;
		end
		local v156 = v103.HandleBottomTrinket(v63, v32, 5 + 35, nil);
		if (((6101 - 2666) > (781 + 1316)) and v156) then
			return v156;
		end
	end
	local function v125()
		if ((v61.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v60.DemonicPowerBuff) or (not v60.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v60.NetherPortalBuff) or not v60.NetherPortal:IsAvailable())))) or ((9344 - 5574) >= (5067 - (834 + 192)))) then
			if (v24(v62.TimebreachingTalon) or ((242 + 3549) <= (414 + 1197))) then
				return "timebreaching_talon items 2";
			end
		end
		if (not v60.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v60.DemonicPowerBuff) or ((99 + 4479) <= (3110 - 1102))) then
			local v167 = 304 - (300 + 4);
			local v168;
			while true do
				if (((301 + 824) <= (5434 - 3358)) and (v167 == (362 - (112 + 250)))) then
					v168 = v124();
					if (v168 or ((297 + 446) >= (11020 - 6621))) then
						return v168;
					end
					break;
				end
			end
		end
	end
	local function v126()
		if (((662 + 493) < (866 + 807)) and v60.Berserking:IsCastable()) then
			if (v24(v60.Berserking, v33) or ((1739 + 585) <= (287 + 291))) then
				return "berserking ogcd 4";
			end
		end
		if (((2799 + 968) == (5181 - (1001 + 413))) and v60.BloodFury:IsCastable()) then
			if (((9118 - 5029) == (4971 - (244 + 638))) and v24(v60.BloodFury, v33)) then
				return "blood_fury ogcd 6";
			end
		end
		if (((5151 - (627 + 66)) >= (4987 - 3313)) and v60.Fireblood:IsCastable()) then
			if (((1574 - (512 + 90)) <= (3324 - (1665 + 241))) and v24(v60.Fireblood, v33)) then
				return "fireblood ogcd 8";
			end
		end
		if (v60.AncestralCall:IsCastable() or ((5655 - (373 + 344)) < (2148 + 2614))) then
			if (v23(v60.AncestralCall, v33) or ((663 + 1841) > (11247 - 6983))) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v127()
		if (((3642 - 1489) == (3252 - (35 + 1064))) and (v88 > (0 + 0)) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99)) and (v93 <= (0 - 0))) then
			v93 = 1 + 119 + v98;
		end
		if ((v60.HandofGuldan:IsReady() and (v97 > (1236 - (298 + 938))) and (v88 > (v99 + v60.SummonDemonicTyrant:CastTime())) and (v88 < (v99 * (1263 - (233 + 1026))))) or ((2173 - (636 + 1030)) >= (1325 + 1266))) then
			if (((4377 + 104) == (1332 + 3149)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
				return "hand_of_guldan tyrant 2";
			end
		end
		if (((v88 > (0 + 0)) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99))) or ((2549 - (55 + 166)) < (135 + 558))) then
			local v169 = 0 + 0;
			local v170;
			local v171;
			while true do
				if (((16528 - 12200) == (4625 - (36 + 261))) and ((1 - 0) == v169)) then
					v170 = v126();
					if (((2956 - (34 + 1334)) >= (513 + 819)) and v170) then
						return v170;
					end
					v169 = 2 + 0;
				end
				if ((v169 == (1285 - (1035 + 248))) or ((4195 - (20 + 1)) > (2214 + 2034))) then
					v171 = v103.HandleDPSPotion();
					if (v171 or ((4905 - (134 + 185)) <= (1215 - (549 + 584)))) then
						return v171;
					end
					break;
				end
				if (((4548 - (314 + 371)) == (13261 - 9398)) and (v169 == (968 - (478 + 490)))) then
					v170 = v125();
					if (v170 or ((150 + 132) <= (1214 - (786 + 386)))) then
						return v170;
					end
					v169 = 3 - 2;
				end
			end
		end
		if (((5988 - (1055 + 324)) >= (2106 - (1093 + 247))) and v60.SummonDemonicTyrant:IsCastable() and (v88 > (0 + 0)) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99))) then
			if (v24(v60.SummonDemonicTyrant, nil, nil, v56) or ((122 + 1030) == (9877 - 7389))) then
				return "summon_demonic_tyrant tyrant 6";
			end
		end
		if (((11613 - 8191) > (9532 - 6182)) and v60.Implosion:IsReady() and (v105() > (4 - 2)) and not v112() and not v108() and not v114() and ((v102 > (2 + 1)) or ((v102 > (7 - 5)) and v60.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(3 - 2, v60.Implosion)) then
			if (((662 + 215) > (961 - 585)) and v23(v60.Implosion, v53, nil, not v14:IsInRange(728 - (364 + 324)))) then
				return "implosion tyrant 8";
			end
		end
		if ((v60.ShadowBolt:IsReady() and v13:PrevGCDP(2 - 1, v60.GrimoireFelguard) and (v98 > (71 - 41)) and v13:BuffDown(v60.NetherPortalBuff) and v13:BuffDown(v60.DemonicCoreBuff)) or ((1034 + 2084) <= (7745 - 5894))) then
			if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((264 - 99) >= (10605 - 7113))) then
				return "shadow_bolt tyrant 10";
			end
		end
		if (((5217 - (1249 + 19)) < (4384 + 472)) and v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (15 - 11)) and (not v114() or (not v60.SummonVilefiend:IsAvailable() and v111())) and v13:BuffDown(v60.NetherPortalBuff)) then
			if (v23(v60.PowerSiphon, v55) or ((5362 - (686 + 400)) < (2367 + 649))) then
				return "power_siphon tyrant 12";
			end
		end
		if (((4919 - (73 + 156)) > (20 + 4105)) and v60.ShadowBolt:IsReady() and not v114() and v13:BuffDown(v60.NetherPortalBuff) and not v112() and (v97 < ((816 - (721 + 90)) - v13:BuffStack(v60.DemonicCoreBuff)))) then
			if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((1 + 49) >= (2909 - 2013))) then
				return "shadow_bolt tyrant 14";
			end
		end
		if ((v60.NetherPortal:IsReady() and (v97 == (475 - (224 + 246)))) or ((2776 - 1062) >= (5445 - 2487))) then
			if (v23(v60.NetherPortal, v54) or ((271 + 1220) < (16 + 628))) then
				return "nether_portal tyrant 16";
			end
		end
		if (((518 + 186) < (1961 - 974)) and v60.SummonVilefiend:IsReady() and ((v97 == (16 - 11)) or v13:BuffUp(v60.NetherPortalBuff)) and (v60.SummonDemonicTyrant:CooldownRemains() < (526 - (203 + 310))) and v89) then
			if (((5711 - (1238 + 755)) > (134 + 1772)) and v23(v60.SummonVilefiend)) then
				return "summon_vilefiend tyrant 18";
			end
		end
		if ((v60.CallDreadstalkers:IsReady() and (v114() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (1564 - (709 + 825)))) and (v13:BuffUp(v60.NetherPortalBuff) or v108() or (v97 == (8 - 3))))) and (v60.SummonDemonicTyrant:CooldownRemains() < (15 - 4)) and v89) or ((1822 - (196 + 668)) > (14352 - 10717))) then
			if (((7251 - 3750) <= (5325 - (171 + 662))) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
				return "call_dreadstalkers tyrant 20";
			end
		end
		if ((v60.GrimoireFelguard:IsReady() and (v114() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (123 - (4 + 89)))) and (v13:BuffUp(v60.NetherPortalBuff) or v112() or (v97 == (17 - 12))) and v89))) or ((1254 + 2188) < (11191 - 8643))) then
			if (((1128 + 1747) >= (2950 - (35 + 1451))) and v23(v60.GrimoireFelguard, v52)) then
				return "grimoire_felguard tyrant 22";
			end
		end
		if ((v60.HandofGuldan:IsReady() and (((v97 > (1455 - (28 + 1425))) and (v114() or (not v60.SummonVilefiend:IsAvailable() and v112())) and ((v97 > (1995 - (941 + 1052))) or (v113() < ((v99 * (2 + 0)) + ((1516 - (822 + 692)) / v13:SpellHaste()))))) or (not v112() and (v97 == (6 - 1))))) or ((2260 + 2537) >= (5190 - (45 + 252)))) then
			if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((546 + 5) > (712 + 1356))) then
				return "hand_of_guldan tyrant 24";
			end
		end
		if (((5144 - 3030) > (1377 - (114 + 319))) and v60.Demonbolt:IsReady() and (v97 < (5 - 1)) and (v13:BuffStack(v60.DemonicCoreBuff) > (1 - 0)) and (v114() or (not v60.SummonVilefiend:IsAvailable() and v112()) or not v22())) then
			if ((v60.DoomBrandDebuff:AuraActiveCount() == v102) or not v13:HasTier(20 + 11, 2 - 0) or ((4739 - 2477) >= (5059 - (556 + 1407)))) then
				if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((3461 - (741 + 465)) >= (4002 - (170 + 295)))) then
					return "demonbolt tyrant 26";
				end
			elseif (v103.CastCycle(v60.Demonbolt, v101, v120, not v14:IsSpellInRange(v60.Demonbolt)) or ((2022 + 1815) < (1200 + 106))) then
				return "demonbolt tyrant 27";
			end
		end
		if (((7263 - 4313) == (2446 + 504)) and v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) < (2 + 1)) and (v88 > (v60.SummonDemonicTyrant:ExecuteTime() + (v99 * (2 + 1))))) or (v88 == (1230 - (957 + 273))))) then
			if (v23(v60.PowerSiphon) or ((1264 + 3459) < (1321 + 1977))) then
				return "power_siphon tyrant 28";
			end
		end
		if (((4328 - 3192) >= (405 - 251)) and v60.ShadowBolt:IsCastable()) then
			if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((827 - 556) > (23510 - 18762))) then
				return "shadow_bolt tyrant 30";
			end
		end
	end
	local function v128()
		local v157 = 1780 - (389 + 1391);
		while true do
			if (((2974 + 1766) >= (329 + 2823)) and (v157 == (4 - 2))) then
				if ((v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (954 - (783 + 168))) and (v86 < (67 - 47))) or ((2536 + 42) >= (3701 - (309 + 2)))) then
					if (((125 - 84) <= (2873 - (1090 + 122))) and v23(v60.PowerSiphon, v55)) then
						return "power_siphon fight_end 14";
					end
				end
				if (((195 + 406) < (11956 - 8396)) and v60.Implosion:IsReady() and v53 and (v86 < ((2 + 0) * v99))) then
					if (((1353 - (628 + 490)) < (124 + 563)) and v23(v60.Implosion, nil, nil, not v14:IsInRange(99 - 59))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
			if (((20788 - 16239) > (1927 - (431 + 343))) and (v157 == (1 - 0))) then
				if ((v60.NetherPortal:IsReady() and v54 and (v86 < (86 - 56))) or ((3693 + 981) < (598 + 4074))) then
					if (((5363 - (556 + 1139)) < (4576 - (6 + 9))) and v23(v60.NetherPortal)) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v60.DemonicStrength:IsCastable() and (v86 < (2 + 8))) or ((234 + 221) == (3774 - (28 + 141)))) then
					if (v23(v60.DemonicStrength, v51) or ((1032 + 1631) == (4087 - 775))) then
						return "demonic_strength fight_end 12";
					end
				end
				v157 = 2 + 0;
			end
			if (((5594 - (486 + 831)) <= (11644 - 7169)) and (v157 == (0 - 0))) then
				if ((v60.SummonDemonicTyrant:IsCastable() and (v86 < (4 + 16))) or ((2750 - 1880) == (2452 - (668 + 595)))) then
					if (((1398 + 155) <= (632 + 2501)) and v24(v60.SummonDemonicTyrant, nil, nil, v56)) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v86 < (54 - 34)) or ((2527 - (23 + 267)) >= (5455 - (1129 + 815)))) then
					local v177 = 387 - (371 + 16);
					while true do
						if ((v177 == (1751 - (1326 + 424))) or ((2507 - 1183) > (11035 - 8015))) then
							if (v60.SummonVilefiend:IsReady() or ((3110 - (88 + 30)) == (2652 - (720 + 51)))) then
								if (((6909 - 3803) > (3302 - (421 + 1355))) and v23(v60.SummonVilefiend)) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
						if (((4987 - 1964) < (1902 + 1968)) and (v177 == (1083 - (286 + 797)))) then
							if (((522 - 379) > (122 - 48)) and v60.GrimoireFelguard:IsReady() and v52) then
								if (((457 - (397 + 42)) < (660 + 1452)) and v23(v60.GrimoireFelguard)) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((1897 - (24 + 776)) <= (2507 - 879)) and v60.CallDreadstalkers:IsReady()) then
								if (((5415 - (222 + 563)) == (10201 - 5571)) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v177 = 1 + 0;
						end
					end
				end
				v157 = 191 - (23 + 167);
			end
		end
	end
	local v129 = 1798 - (690 + 1108);
	local v130 = false;
	function UpdateLastMoveTime()
		if (((1278 + 2262) > (2214 + 469)) and v13:IsMoving()) then
			if (((5642 - (40 + 808)) >= (540 + 2735)) and not v130) then
				local v176 = 0 - 0;
				while true do
					if (((1419 + 65) == (786 + 698)) and (v176 == (0 + 0))) then
						v129 = GetTime();
						v130 = true;
						break;
					end
				end
			end
		else
			v130 = false;
		end
	end
	local function v131()
		if (((2003 - (47 + 524)) < (2308 + 1247)) and v13:AffectingCombat()) then
			local v172 = 0 - 0;
			while true do
				if ((v172 == (0 - 0)) or ((2428 - 1363) > (5304 - (1165 + 561)))) then
					if (((v13:HealthPercentage() <= v48) and v60.DarkPact:IsCastable() and not v13:BuffUp(v60.DarkPact)) or ((143 + 4652) < (4357 - 2950))) then
						if (((708 + 1145) < (5292 - (341 + 138))) and v24(v60.DarkPact)) then
							return "dark_pact defensive 2";
						end
					end
					if (((v13:HealthPercentage() <= v44) and v60.DrainLife:IsCastable()) or ((762 + 2059) < (5016 - 2585))) then
						if (v24(v60.DrainLife) or ((3200 - (89 + 237)) < (7016 - 4835))) then
							return "drain_life defensive 2";
						end
					end
					v172 = 1 - 0;
				end
				if ((v172 == (882 - (581 + 300))) or ((3909 - (855 + 365)) <= (814 - 471))) then
					if (((v13:HealthPercentage() <= v45) and v60.HealthFunnel:IsCastable()) or ((611 + 1258) == (3244 - (1030 + 205)))) then
						if (v24(v60.HealthFunnel) or ((3329 + 217) < (2161 + 161))) then
							return "health_funnel defensive 2";
						end
					end
					if (((v13:HealthPercentage() <= v46) and v60.UnendingResolve:IsCastable()) or ((2368 - (156 + 130)) == (10844 - 6071))) then
						if (((5466 - 2222) > (2160 - 1105)) and v24(v60.UnendingResolve)) then
							return "unending_resolve defensive 2";
						end
					end
					break;
				end
			end
		end
	end
	local function v132()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (0 + 0)) or ((3382 - (10 + 59)) <= (503 + 1275))) then
				v59();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v158 = 4 - 3;
			end
			if ((v158 == (1165 - (671 + 492))) or ((1132 + 289) >= (3319 - (369 + 846)))) then
				if (((480 + 1332) <= (2773 + 476)) and v61.Healthstone:IsReady() and v38 and (v13:HealthPercentage() <= v39)) then
					if (((3568 - (1036 + 909)) <= (1556 + 401)) and v24(v62.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((7406 - 2994) == (4615 - (11 + 192))) and v35 and (v13:HealthPercentage() <= v37)) then
					if (((885 + 865) >= (1017 - (135 + 40))) and (v36 == "Refreshing Healing Potion")) then
						if (((10592 - 6220) > (1116 + 734)) and v61.RefreshingHealingPotion:IsReady()) then
							if (((510 - 278) < (1230 - 409)) and v24(v62.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((694 - (50 + 126)) < (2511 - 1609)) and (v36 == "Dreamwalker's Healing Potion")) then
						if (((663 + 2331) > (2271 - (1233 + 180))) and v61.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v62.RefreshingHealingPotion) or ((4724 - (522 + 447)) <= (2336 - (107 + 1314)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((1832 + 2114) > (11405 - 7662)) and v103.TargetIsValid()) then
					local v178 = 0 + 0;
					local v179;
					while true do
						if ((v178 == (3 - 1)) or ((5282 - 3947) >= (5216 - (716 + 1194)))) then
							if (((83 + 4761) > (242 + 2011)) and (((v60.SummonDemonicTyrant:CooldownRemains() < (518 - (74 + 429))) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (9 - 4))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (3 + 2))) and ((v60.GrimoireFelguard:CooldownRemains() < (22 - 12)) or not v13:HasTier(22 + 8, 5 - 3)) and ((v95 < (37 - 22)) or (v86 < (473 - (279 + 154))) or v13:PowerInfusionUp())) or (v60.SummonVilefiend:IsAvailable() and (v60.SummonDemonicTyrant:CooldownRemains() < (793 - (454 + 324))) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (4 + 1))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (22 - (12 + 5)))) and ((v60.GrimoireFelguard:CooldownRemains() < (6 + 4)) or not v13:HasTier(76 - 46, 1 + 1)) and ((v95 < (1108 - (277 + 816))) or (v86 < (170 - 130)) or v13:PowerInfusionUp())))) then
								local v182 = v127();
								if (((1635 - (1058 + 125)) == (85 + 367)) and v182) then
									return v182;
								end
							end
							if (((v60.SummonDemonicTyrant:CooldownRemains() < (990 - (815 + 160))) and (v114() or (not v60.SummonVilefiend:IsAvailable() and (v108() or v60.GrimoireFelguard:CooldownUp() or not v13:HasTier(128 - 98, 4 - 2)))) and ((v95 < (4 + 11)) or v108() or (v86 < (116 - 76)) or v13:PowerInfusionUp())) or ((6455 - (41 + 1857)) < (3980 - (1222 + 671)))) then
								local v183 = 0 - 0;
								local v184;
								while true do
									if (((5568 - 1694) == (5056 - (229 + 953))) and (v183 == (1774 - (1111 + 663)))) then
										v184 = v127();
										if (v184 or ((3517 - (874 + 705)) > (691 + 4244))) then
											return v184;
										end
										break;
									end
								end
							end
							if ((v60.SummonDemonicTyrant:IsCastable() and v56 and (v114() or v108() or (v60.GrimoireFelguard:CooldownRemains() > (62 + 28)))) or ((8844 - 4589) < (97 + 3326))) then
								if (((2133 - (642 + 37)) <= (568 + 1923)) and v23(v60.SummonDemonicTyrant)) then
									return "summon_demonic_tyrant main 4";
								end
							end
							if ((v60.SummonVilefiend:IsReady() and (v60.SummonDemonicTyrant:CooldownRemains() > (8 + 37))) or ((10437 - 6280) <= (3257 - (233 + 221)))) then
								if (((11222 - 6369) >= (2625 + 357)) and v23(v60.SummonVilefiend)) then
									return "summon_vilefiend main 6";
								end
							end
							if (((5675 - (718 + 823)) > (2113 + 1244)) and v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (((not v60.SoulStrike:IsAvailable() or (v60.SoulStrike:CooldownRemains() > (v99 * (807 - (266 + 539))))) and (v97 < (11 - 7))) or (v97 < ((1229 - (636 + 589)) - (v26(v102 > (4 - 2)))))) and not v13:PrevGCDP(1 - 0, v60.Demonbolt) and v13:HasTier(25 + 6, 1 + 1)) then
								if (v103.CastCycle(v60.Demonbolt, v101, v117, not v14:IsSpellInRange(v60.Demonbolt)) or ((4432 - (657 + 358)) < (6709 - 4175))) then
									return "demonbolt main 8";
								end
							end
							if ((v60.PowerSiphon:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and (v14:DebuffDown(v60.DoomBrandDebuff) or (not v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v99 + v60.Demonbolt:TravelTime()))) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v99 + v60.Demonbolt:TravelTime() + (6 - 3))))) and v13:HasTier(1218 - (1151 + 36), 2 + 0)) or ((716 + 2006) <= (489 - 325))) then
								if (v23(v60.PowerSiphon, v55) or ((4240 - (1552 + 280)) < (2943 - (64 + 770)))) then
									return "power_siphon main 10";
								end
							end
							v178 = 3 + 0;
						end
						if ((v178 == (8 - 4)) or ((6 + 27) == (2698 - (157 + 1086)))) then
							if ((v60.HandofGuldan:IsReady() and (((v97 > (3 - 1)) and (v60.CallDreadstalkers:CooldownRemains() > (v99 * (17 - 13))) and (v60.SummonDemonicTyrant:CooldownRemains() > (25 - 8))) or (v97 == (6 - 1)) or ((v97 == (823 - (599 + 220))) and v60.SoulStrike:IsAvailable() and (v60.SoulStrike:CooldownRemains() < (v99 * (3 - 1))))) and (v102 == (1932 - (1813 + 118))) and v60.GrandWarlocksDesign:IsAvailable()) or ((324 + 119) >= (5232 - (841 + 376)))) then
								if (((4738 - 1356) > (39 + 127)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
									return "hand_of_guldan main 26";
								end
							end
							if ((v60.HandofGuldan:IsReady() and (v97 > (5 - 3)) and not ((v102 == (860 - (464 + 395))) and v60.GrandWarlocksDesign:IsAvailable())) or ((718 - 438) == (1470 + 1589))) then
								if (((2718 - (467 + 370)) > (2671 - 1378)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
									return "hand_of_guldan main 28";
								end
							end
							if (((1731 + 626) == (8079 - 5722)) and v60.Demonbolt:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) > (1 + 0)) and (((v97 < (8 - 4)) and not v60.SoulStrike:IsAvailable()) or (v60.SoulStrike:CooldownRemains() > (v99 * (522 - (150 + 370)))) or (v97 < (1284 - (74 + 1208)))) and not v91) then
								if (((302 - 179) == (583 - 460)) and v103.CastCycle(v60.Demonbolt, v101, v118, not v14:IsSpellInRange(v60.Demonbolt))) then
									return "demonbolt main 30";
								end
							end
							if ((v60.Demonbolt:IsReady() and v13:HasTier(23 + 8, 392 - (14 + 376)) and v13:BuffUp(v60.DemonicCoreBuff) and (v97 < (6 - 2)) and not v91) or ((684 + 372) >= (2980 + 412))) then
								if (v103.CastTargetIf(v60.Demonbolt, v101, "==", v118, v121, not v14:IsSpellInRange(v60.Demonbolt)) or ((1031 + 50) < (3149 - 2074))) then
									return "demonbolt main 32";
								end
							end
							if ((v60.Demonbolt:IsReady() and (v86 < (v13:BuffStack(v60.DemonicCoreBuff) * v99))) or ((790 + 259) >= (4510 - (23 + 55)))) then
								if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((11299 - 6531) <= (565 + 281))) then
									return "demonbolt main 34";
								end
							end
							if ((v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (v60.PowerSiphon:CooldownRemains() < (4 + 0)) and (v97 < (5 - 1)) and not v91) or ((1057 + 2301) <= (2321 - (652 + 249)))) then
								if (v103.CastCycle(v60.Demonbolt, v101, v118, not v14:IsSpellInRange(v60.Demonbolt)) or ((10006 - 6267) <= (4873 - (708 + 1160)))) then
									return "demonbolt main 36";
								end
							end
							v178 = 13 - 8;
						end
						if ((v178 == (9 - 4)) or ((1686 - (10 + 17)) >= (480 + 1654))) then
							if ((v60.PowerSiphon:IsReady() and (v13:BuffDown(v60.DemonicCoreBuff))) or ((4992 - (1400 + 332)) < (4517 - 2162))) then
								if (v23(v60.PowerSiphon, v55) or ((2577 - (242 + 1666)) == (1808 + 2415))) then
									return "power_siphon main 38";
								end
							end
							if ((v60.SummonVilefiend:IsReady() and (v86 < (v60.SummonDemonicTyrant:CooldownRemains() + 2 + 3))) or ((1442 + 250) < (1528 - (850 + 90)))) then
								if (v23(v60.SummonVilefiend) or ((8401 - 3604) < (5041 - (360 + 1030)))) then
									return "summon_vilefiend main 40";
								end
							end
							if (v60.Doom:IsReady() or ((3697 + 480) > (13689 - 8839))) then
								if (v103.CastCycle(v60.Doom, v100, v119, not v14:IsSpellInRange(v60.Doom)) or ((550 - 150) > (2772 - (909 + 752)))) then
									return "doom main 42";
								end
							end
							if (((4274 - (109 + 1114)) > (1839 - 834)) and v60.ShadowBolt:IsCastable()) then
								if (((1438 + 2255) <= (4624 - (6 + 236))) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
									return "shadow_bolt main 44";
								end
							end
							break;
						end
						if ((v178 == (1 + 0)) or ((2642 + 640) > (9669 - 5569))) then
							v123();
							if (v110() or (v86 < (38 - 16)) or ((4713 - (1076 + 57)) < (468 + 2376))) then
								local v185 = 689 - (579 + 110);
								local v186;
								while true do
									if (((8 + 81) < (3970 + 520)) and (v185 == (0 + 0))) then
										v186 = v126();
										if ((v186 and v33 and v32) or ((5390 - (174 + 233)) < (5050 - 3242))) then
											return v186;
										end
										break;
									end
								end
							end
							v179 = v125();
							if (((6719 - 2890) > (1676 + 2093)) and v179) then
								return v179;
							end
							if (((2659 - (663 + 511)) <= (2591 + 313)) and (v86 < (7 + 23))) then
								local v187 = 0 - 0;
								local v188;
								while true do
									if (((2586 + 1683) == (10050 - 5781)) and (v187 == (0 - 0))) then
										v188 = v128();
										if (((185 + 202) <= (5414 - 2632)) and v188) then
											return v188;
										end
										break;
									end
								end
							end
							if ((v60.HandofGuldan:IsReady() and (v98 < (0.5 + 0)) and (((v86 % (9 + 86)) > (762 - (478 + 244))) or ((v86 % (612 - (440 + 77))) < (7 + 8))) and (v60.ReignofTyranny:IsAvailable() or (v102 > (7 - 5)))) or ((3455 - (655 + 901)) <= (171 + 746))) then
								if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((3302 + 1010) <= (592 + 284))) then
									return "hand_of_guldan main 2";
								end
							end
							v178 = 7 - 5;
						end
						if (((3677 - (695 + 750)) <= (8864 - 6268)) and (v178 == (0 - 0))) then
							if (((8425 - 6330) < (4037 - (285 + 66))) and not v13:AffectingCombat() and v30 and not v13:IsCasting(v60.ShadowBolt)) then
								local v189 = v122();
								if (v189 or ((3718 - 2123) >= (5784 - (682 + 628)))) then
									return v189;
								end
							end
							if ((not v13:IsCasting() and not v13:IsChanneling()) or ((745 + 3874) < (3181 - (176 + 123)))) then
								local v190 = 0 + 0;
								local v191;
								while true do
									if ((v190 == (2 + 0)) or ((563 - (239 + 30)) >= (1314 + 3517))) then
										v191 = v103.Interrupt(v60.AxeToss, 39 + 1, true, v16, v62.AxeTossMouseover);
										if (((3590 - 1561) <= (9621 - 6537)) and v191) then
											return v191;
										end
										v191 = v103.InterruptWithStun(v60.AxeToss, 355 - (306 + 9), true);
										v190 = 10 - 7;
									end
									if ((v190 == (1 + 2)) or ((1250 + 787) == (1165 + 1255))) then
										if (((12748 - 8290) > (5279 - (1140 + 235))) and v191) then
											return v191;
										end
										v191 = v103.InterruptWithStun(v60.AxeToss, 26 + 14, true, v16, v62.AxeTossMouseover);
										if (((400 + 36) >= (32 + 91)) and v191) then
											return v191;
										end
										break;
									end
									if (((552 - (33 + 19)) < (656 + 1160)) and (v190 == (0 - 0))) then
										v191 = v103.Interrupt(v60.SpellLock, 18 + 22, true);
										if (((7008 - 3434) == (3352 + 222)) and v191) then
											return v191;
										end
										v191 = v103.Interrupt(v60.SpellLock, 729 - (586 + 103), true, v16, v62.SpellLockMouseover);
										v190 = 1 + 0;
									end
									if (((680 - 459) < (1878 - (1309 + 179))) and (v190 == (1 - 0))) then
										if (v191 or ((964 + 1249) <= (3816 - 2395))) then
											return v191;
										end
										v191 = v103.Interrupt(v60.AxeToss, 31 + 9, true);
										if (((6496 - 3438) < (9684 - 4824)) and v191) then
											return v191;
										end
										v190 = 611 - (295 + 314);
									end
								end
							end
							if ((v13:AffectingCombat() and v57) or ((3183 - 1887) >= (6408 - (1300 + 662)))) then
								if ((v60.BurningRush:IsCastable() and not v13:BuffUp(v60.BurningRush) and v130 and ((GetTime() - v129) >= (3 - 2)) and (v13:HealthPercentage() >= v58)) or ((3148 - (1178 + 577)) > (2332 + 2157))) then
									if (v24(v60.BurningRush) or ((13078 - 8654) < (1432 - (851 + 554)))) then
										return "burning_rush defensive 2";
									end
								elseif ((v60.BurningRush:IsCastable() and v13:BuffUp(v60.BurningRush) and (not v130 or (v13:HealthPercentage() <= v58))) or ((1766 + 231) > (10580 - 6765))) then
									if (((7525 - 4060) > (2215 - (115 + 187))) and v24(v62.CancelBurningRush)) then
										return "burning_rush defensive 4";
									end
								end
							end
							v179 = v131();
							if (((562 + 171) < (1723 + 96)) and v179) then
								return v179;
							end
							if ((v60.UnendingResolve:IsReady() and (v13:HealthPercentage() < v46)) or ((17319 - 12924) == (5916 - (160 + 1001)))) then
								if (v24(v60.UnendingResolve) or ((3319 + 474) < (1635 + 734))) then
									return "unending_resolve defensive";
								end
							end
							v178 = 1 - 0;
						end
						if ((v178 == (361 - (237 + 121))) or ((4981 - (525 + 372)) == (502 - 237))) then
							if (((14318 - 9960) == (4500 - (96 + 46))) and v60.DemonicStrength:IsCastable() and (v13:BuffRemains(v60.NetherPortalBuff) < v99)) then
								if (v23(v60.DemonicStrength, v51) or ((3915 - (643 + 134)) < (359 + 634))) then
									return "demonic_strength main 12";
								end
							end
							if (((7984 - 4654) > (8624 - 6301)) and v60.BilescourgeBombers:IsReady() and v60.BilescourgeBombers:IsCastable()) then
								if (v23(v60.BilescourgeBombers, nil, nil, not v14:IsInRange(39 + 1)) or ((7116 - 3490) == (8153 - 4164))) then
									return "bilescourge_bombers main 14";
								end
							end
							if ((v60.Guillotine:IsCastable() and v50 and (v13:BuffRemains(v60.NetherPortalBuff) < v99) and (v60.DemonicStrength:CooldownDown() or not v60.DemonicStrength:IsAvailable())) or ((1635 - (316 + 403)) == (1776 + 895))) then
								if (((747 - 475) == (99 + 173)) and v23(v62.GuillotineCursor, nil, nil, not v14:IsInRange(100 - 60))) then
									return "guillotine main 16";
								end
							end
							if (((3012 + 1237) <= (1560 + 3279)) and v60.CallDreadstalkers:IsReady() and ((v60.SummonDemonicTyrant:CooldownRemains() > (86 - 61)) or (v95 > (119 - 94)) or v13:BuffUp(v60.NetherPortalBuff))) then
								if (((5768 - 2991) < (184 + 3016)) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
									return "call_dreadstalkers main 18";
								end
							end
							if (((187 - 92) < (96 + 1861)) and v60.Implosion:IsReady() and (v106(5 - 3) > (17 - (12 + 5))) and v90 and not v13:PrevGCDP(3 - 2, v60.Implosion)) then
								if (((1761 - 935) < (3649 - 1932)) and v23(v60.Implosion, v53, nil, not v14:IsInRange(99 - 59))) then
									return "implosion main 20";
								end
							end
							if (((290 + 1136) >= (3078 - (1656 + 317))) and v60.SummonSoulkeeper:IsReady() and (v60.SummonSoulkeeper:Count() == (9 + 1)) and (v102 > (1 + 0))) then
								if (((7322 - 4568) <= (16629 - 13250)) and v23(v60.SummonSoulkeeper)) then
									return "soul_strike main 22";
								end
							end
							v178 = 358 - (5 + 349);
						end
					end
				end
				break;
			end
			if ((v158 == (4 - 3)) or ((5198 - (266 + 1005)) == (932 + 481))) then
				if (v31 or ((3937 - 2783) <= (1036 - 248))) then
					v101 = v14:GetEnemiesInSplashRange(1704 - (561 + 1135));
					v102 = v14:GetEnemiesInSplashRangeCount(10 - 2);
					v100 = v13:GetEnemiesInRange(131 - 91);
				else
					local v180 = 1066 - (507 + 559);
					while true do
						if ((v180 == (2 - 1)) or ((5081 - 3438) > (3767 - (212 + 176)))) then
							v100 = {};
							break;
						end
						if ((v180 == (905 - (250 + 655))) or ((7643 - 4840) > (7948 - 3399))) then
							v101 = {};
							v102 = 1 - 0;
							v180 = 1957 - (1869 + 87);
						end
					end
				end
				UpdateLastMoveTime();
				if (v103.TargetIsValid() or v13:AffectingCombat() or ((763 - 543) >= (4923 - (484 + 1417)))) then
					local v181 = 0 - 0;
					while true do
						if (((4728 - 1906) == (3595 - (48 + 725))) and (v181 == (2 - 0))) then
							v25.UpdateSoulShards();
							v98 = v10.CombatTime();
							v181 = 7 - 4;
						end
						if ((v181 == (1 + 0)) or ((2835 - 1774) == (520 + 1337))) then
							if (((805 + 1955) > (2217 - (152 + 701))) and (v86 == (12422 - (430 + 881)))) then
								v86 = v10.FightRemains(v101, false);
							end
							v25.UpdatePetTable();
							v181 = 1 + 1;
						end
						if (((898 - (557 + 338)) == v181) or ((1449 + 3453) <= (10130 - 6535))) then
							v97 = v13:SoulShardsP();
							v99 = v13:GCD() + (0.25 - 0);
							break;
						end
						if ((v181 == (0 - 0)) or ((8301 - 4449) == (1094 - (499 + 302)))) then
							v85 = v10.BossFightRemains();
							v86 = v85;
							v181 = 867 - (39 + 827);
						end
					end
				end
				if ((v60.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v47 and not v17:IsActive()) or ((4303 - 2744) == (10246 - 5658))) then
					if (v24(v60.SummonPet, false, true) or ((17809 - 13325) == (1209 - 421))) then
						return "summon_pet ooc";
					end
				end
				v158 = 1 + 1;
			end
		end
	end
	local function v133()
		local v159 = 0 - 0;
		while true do
			if (((731 + 3837) >= (6181 - 2274)) and (v159 == (104 - (103 + 1)))) then
				v60.DoomBrandDebuff:RegisterAuraTracking();
				v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v10.SetAPL(820 - (475 + 79), v132, v133);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

