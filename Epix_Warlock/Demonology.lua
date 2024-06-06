local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((4723 - (53 + 138)) > (2997 - (112 + 189))) and not v6) then
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
		v36 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v37 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v38 = EpicSettings.Settings['UseHealthstone'] or (0 + 0);
		v39 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1744 - (1344 + 400));
		v42 = EpicSettings.Settings['InterruptThreshold'] or (405 - (255 + 150));
		v47 = EpicSettings.Settings['SummonPet'];
		v48 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
		v49 = EpicSettings.Settings['DemonboltOpener'];
		v50 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
		v51 = EpicSettings.Settings['DemonicStrength'];
		v52 = EpicSettings.Settings['GrimoireFelguard'];
		v53 = EpicSettings.Settings['Implosion'];
		v54 = EpicSettings.Settings['NetherPortal'];
		v55 = EpicSettings.Settings['PowerSiphon'];
		v56 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 - 0);
		v57 = EpicSettings.Settings['UseBurningRush'] or (1739 - (404 + 1335));
		v58 = EpicSettings.Settings['BurningRushHP'] or (406 - (183 + 223));
		v44 = EpicSettings.Settings['DrainLifeHP'] or (0 - 0);
		v45 = EpicSettings.Settings['HealthFunnelHP'] or (0 + 0);
		v46 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
	end
	local v60 = v18.Warlock.Demonology;
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = {v61.MirrorofFracturedTomorrows:ID(),v61.NymuesUnravelingSpindle:ID(),v61.TimeThiefsGambit:ID()};
	local v64 = v13:GetEquipment();
	local v65 = (v64[5 + 8] and v19(v64[462 - (108 + 341)])) or v19(0 + 0);
	local v66 = (v64[59 - 45] and v19(v64[1507 - (711 + 782)])) or v19(0 - 0);
	local v67 = v65:Level() or (469 - (270 + 199));
	local v68 = v66:Level() or (0 + 0);
	local v69 = v65:OnUseSpell();
	local v70 = v66:OnUseSpell();
	local v71 = (v69 and (v69.MaximumRange > (1819 - (580 + 1239))) and (v69.MaximumRange <= (297 - 197)) and v69.MaximumRange) or (96 + 4);
	local v72 = (v70 and (v70.MaximumRange > (0 + 0)) and (v70.MaximumRange <= (44 + 56)) and v70.MaximumRange) or (261 - 161);
	v71 = ((v65:ID() == v61.BelorrelostheSuncaller:ID()) and (7 + 3)) or v71;
	v72 = ((v66:ID() == v61.BelorrelostheSuncaller:ID()) and (1177 - (645 + 522))) or v72;
	local v73 = v65:HasUseBuff();
	local v74 = v66:HasUseBuff();
	local v75 = (v65:ID() == v61.RubyWhelpShell:ID()) or (v65:ID() == v61.WhisperingIncarnateIcon:ID()) or (v65:ID() == v61.TimeThiefsGambit:ID());
	local v76 = (v66:ID() == v61.RubyWhelpShell:ID()) or (v66:ID() == v61.WhisperingIncarnateIcon:ID()) or (v66:ID() == v61.TimeThiefsGambit:ID());
	local v77 = v65:ID() == v61.NymuesUnravelingSpindle:ID();
	local v78 = v66:ID() == v61.NymuesUnravelingSpindle:ID();
	local v79 = v65:BuffDuration() + (v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()) * (1810 - (1010 + 780))) + (v26(v65:ID() == v61.NymuesUnravelingSpindle:ID()) * (2 + 0));
	local v80 = v66:BuffDuration() + (v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID()) * (95 - 75)) + (v26(v66:ID() == v61.NymuesUnravelingSpindle:ID()) * (5 - 3));
	local v81 = (v73 and (((v65:Cooldown() % (1926 - (1045 + 791))) == (0 - 0)) or (((137 - 47) % v65:Cooldown()) == (505 - (351 + 154)))) and (1575 - (1281 + 293))) or (266.5 - (28 + 238));
	local v82 = (v74 and (((v66:Cooldown() % (201 - 111)) == (1559 - (1381 + 178))) or (((85 + 5) % v66:Cooldown()) == (0 + 0))) and (1 + 0)) or (0.5 - 0);
	local v83 = (v70 and not v69 and (2 + 0)) or (471 - (381 + 89));
	local v84 = (v70 and not v69 and (2 + 0)) or (1 + 0);
	if (((1795 - 747) >= (1208 - (1074 + 82))) and v69 and v70) then
		local v160 = 0 - 0;
		local v161;
		local v162;
		while true do
			if (((4742 - (214 + 1570)) < (5958 - (990 + 465))) and (v160 == (1 + 0))) then
				v162 = ((v65:Cooldown() / v79) * v81 * ((1 + 0) - ((0.5 + 0) * v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()))) * ((3 - 2) + ((v67 - v68) / (1826 - (1668 + 58))))) or (626 - (512 + 114));
				if ((not v73 and v74) or (v74 and (v161 > v162)) or ((7130 - 4395) == (2705 - 1396))) then
					v84 = 6 - 4;
				else
					v84 = 1 + 0;
				end
				break;
			end
			if ((v160 == (0 + 0)) or ((3591 + 539) <= (9967 - 7012))) then
				v83 = (not v73 and not v74 and (v68 > v67) and (1996 - (109 + 1885))) or (1470 - (1269 + 200));
				v161 = ((v66:Cooldown() / v80) * v82 * ((1 - 0) - ((815.5 - (98 + 717)) * v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID())))) or (826 - (802 + 24));
				v160 = 1 - 0;
			end
		end
	end
	local v85 = 14032 - 2921;
	local v86 = 1641 + 9470;
	local v87 = 11 + 3 + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
	local v88 = 0 + 0;
	local v89 = false;
	local v90 = false;
	local v91 = false;
	local v92 = 0 + 0;
	local v93 = 0 - 0;
	local v94 = 0 - 0;
	local v95 = 43 + 77;
	local v96 = 5 + 7;
	local v97 = 0 + 0;
	local v98 = 0 + 0;
	local v99 = 0 + 0;
	local v100;
	local v101, v102;
	v10:RegisterForEvent(function()
		v85 = 12544 - (797 + 636);
		v86 = 53947 - 42836;
	end, "PLAYER_REGEN_ENABLED");
	local v103 = v10.Commons.Everyone;
	local v104 = {{v60.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v64 = v13:GetEquipment();
		v65 = (v64[6 + 7] and v19(v64[339 - (192 + 134)])) or v19(1276 - (316 + 960));
		v66 = (v64[8 + 6] and v19(v64[11 + 3])) or v19(0 + 0);
		v67 = v65:Level() or (0 - 0);
		v68 = v66:Level() or (551 - (83 + 468));
		v69 = v65:OnUseSpell();
		v70 = v66:OnUseSpell();
		v71 = (v69 and (v69.MaximumRange > (1806 - (1202 + 604))) and (v69.MaximumRange <= (466 - 366)) and v69.MaximumRange) or (166 - 66);
		v72 = (v70 and (v70.MaximumRange > (0 - 0)) and (v70.MaximumRange <= (425 - (45 + 280))) and v70.MaximumRange) or (97 + 3);
		v71 = ((v65:ID() == v61.BelorrelostheSuncaller:ID()) and (9 + 1)) or v71;
		v72 = ((v66:ID() == v61.BelorrelostheSuncaller:ID()) and (4 + 6)) or v72;
		v73 = v65:HasUseBuff();
		v74 = v66:HasUseBuff();
		v75 = (v65:ID() == v61.RubyWhelpShell:ID()) or (v65:ID() == v61.WhisperingIncarnateIcon:ID()) or (v65:ID() == v61.TimeThiefsGambit:ID());
		v76 = (v66:ID() == v61.RubyWhelpShell:ID()) or (v66:ID() == v61.WhisperingIncarnateIcon:ID()) or (v66:ID() == v61.TimeThiefsGambit:ID());
		v77 = v65:ID() == v61.NymuesUnravelingSpindle:ID();
		v78 = v66:ID() == v61.NymuesUnravelingSpindle:ID();
		v79 = v65:BuffDuration() + (v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()) * (12 + 8)) + (v26(v65:ID() == v61.NymuesUnravelingSpindle:ID()) * (1 + 1));
		v80 = v66:BuffDuration() + (v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID()) * (37 - 17)) + (v26(v66:ID() == v61.NymuesUnravelingSpindle:ID()) * (1913 - (340 + 1571)));
		v81 = (v73 and (((v65:Cooldown() % (36 + 54)) == (1772 - (1733 + 39))) or (((247 - 157) % v65:Cooldown()) == (1034 - (125 + 909)))) and (1949 - (1096 + 852))) or (0.5 + 0);
		v82 = (v74 and (((v66:Cooldown() % (128 - 38)) == (0 + 0)) or (((602 - (409 + 103)) % v66:Cooldown()) == (236 - (46 + 190)))) and (96 - (51 + 44))) or (0.5 + 0);
		v83 = (v70 and not v69 and (1319 - (1114 + 203))) or (727 - (228 + 498));
		v84 = (v70 and not v69 and (1 + 1)) or (1 + 0);
		if ((v69 and v70) or ((2627 - (174 + 489)) <= (3491 - 2151))) then
			v83 = (not v73 and not v74 and (v68 > v67) and (1907 - (830 + 1075))) or (525 - (303 + 221));
			local v163 = ((v66:Cooldown() / v80) * v82 * ((1270 - (231 + 1038)) - ((0.5 + 0) * v26(v66:ID() == v61.MirrorofFracturedTomorrows:ID())))) or (1162 - (171 + 991));
			local v164 = ((v65:Cooldown() / v79) * v81 * ((4 - 3) - ((0.5 - 0) * v26(v65:ID() == v61.MirrorofFracturedTomorrows:ID()))) * ((2 - 1) + ((v67 - v68) / (81 + 19)))) or (0 - 0);
			if (((7208 - 4709) == (4027 - 1528)) and ((not v73 and v74) or (v74 and (v163 > v164)))) then
				v84 = 6 - 4;
			else
				v84 = 1249 - (111 + 1137);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v60.HandofGuldan:RegisterInFlight();
		v87 = (172 - (91 + 67)) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
	end, "LEARNED_SPELL_IN_TAB");
	v60.HandofGuldan:RegisterInFlight();
	local function v105()
		return v10.GuardiansTable.ImpCount or (0 - 0);
	end
	local function v106(v144)
		local v145 = 0 + 0;
		local v146;
		while true do
			if ((v145 == (523 - (423 + 100))) or ((16 + 2239) < (60 - 38))) then
				v146 = 0 + 0;
				for v170, v171 in pairs(v10.GuardiansTable.Pets) do
					if ((v171.ImpCasts <= v144) or ((1857 - (326 + 445)) >= (6131 - 4726))) then
						v146 = v146 + (2 - 1);
					end
				end
				v145 = 2 - 1;
			end
			if ((v145 == (712 - (530 + 181))) or ((3250 - (614 + 267)) == (458 - (19 + 13)))) then
				return v146;
			end
		end
	end
	local function v107()
		return v10.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v108()
		return v107() > (0 - 0);
	end
	local function v109()
		return v10.GuardiansTable.DemonicTyrantDuration or (0 - 0);
	end
	local function v110()
		return v109() > (0 + 0);
	end
	local function v111()
		return v10.GuardiansTable.DreadstalkerDuration or (0 - 0);
	end
	local function v112()
		return v111() > (0 - 0);
	end
	local function v113()
		return v10.GuardiansTable.VilefiendDuration or (1812 - (1293 + 519));
	end
	local function v114()
		return v113() > (0 - 0);
	end
	local function v115()
		return v10.GuardiansTable.PitLordDuration or (0 - 0);
	end
	local function v116()
		return v115() > (0 - 0);
	end
	local function v117(v147)
		return v147:DebuffDown(v60.DoomBrandDebuff) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) <= (12 - 9)));
	end
	local function v118(v148)
		return (v148:DebuffDown(v60.DoomBrandDebuff)) or (v102 < (9 - 5));
	end
	local function v119(v149)
		return (v149:DebuffRefreshable(v60.Doom));
	end
	local function v120(v150)
		return (v150:DebuffDown(v60.DoomBrandDebuff));
	end
	local function v121(v151)
		return v151:DebuffRemains(v60.DoomBrandDebuff) > (6 + 4);
	end
	local function v122()
		local v152 = 0 + 0;
		while true do
			if ((v152 == (4 - 2)) or ((711 + 2365) > (1058 + 2125))) then
				if (((752 + 450) > (2154 - (709 + 387))) and v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) + v28(v105(), 1860 - (673 + 1185))) <= (11 - 7)) or (v13:BuffRemains(v60.DemonicCoreBuff) < (9 - 6)))) then
					if (((6105 - 2394) > (2400 + 955)) and v23(v60.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if ((v60.Demonbolt:IsReady() and not v14:IsInBossList() and v13:BuffUp(v60.DemonicCoreBuff)) or ((677 + 229) >= (3008 - 779))) then
					if (((317 + 971) > (2494 - 1243)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt precombat 3";
					end
				end
				v152 = 5 - 2;
			end
			if ((v152 == (1880 - (446 + 1434))) or ((5796 - (1040 + 243)) < (10004 - 6652))) then
				v96 = 1859 - (559 + 1288);
				v87 = (1945 - (609 + 1322)) + v26(v60.GrimoireFelguard:IsAvailable()) + v26(v60.SummonVilefiend:IsAvailable());
				v152 = 455 - (13 + 441);
			end
			if ((v152 == (10 - 7)) or ((5408 - 3343) >= (15917 - 12721))) then
				if ((v60.Demonbolt:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and not v13:PrevGCDP(1 + 0, v60.PowerSiphon)) or ((15892 - 11516) <= (527 + 954))) then
					if (v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt)) or ((1487 + 1905) >= (14069 - 9328))) then
						return "demonbolt precombat 4";
					end
				end
				if (((1820 + 1505) >= (3961 - 1807)) and v60.ShadowBolt:IsReady()) then
					if (v23(v62.ShadowBoltPetAttack, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((857 + 438) >= (1799 + 1434))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((3145 + 1232) > (1379 + 263)) and ((1 + 0) == v152)) then
				v92 = 433 - (153 + 280);
				v93 = 0 - 0;
				v152 = 2 + 0;
			end
		end
	end
	local function v123()
		if (((1865 + 2858) > (710 + 646)) and ((v13:BuffUp(v60.NetherPortalBuff) and (v13:BuffRemains(v60.NetherPortalBuff) < (3 + 0)) and v60.NetherPortal:IsAvailable()) or (v86 < (15 + 5)) or (v110() and (v86 < (152 - 52))) or (v86 < (16 + 9)) or v110() or (not v60.SummonDemonicTyrant:IsAvailable() and v112())) and (v94 <= (667 - (89 + 578)))) then
			v93 = 86 + 34 + v98;
		end
		v94 = v93 - v98;
		if (((((((v86 + v98) % (249 - 129)) <= (1134 - (572 + 477))) and (((v86 + v98) % (17 + 103)) >= (16 + 9))) or (v98 >= (26 + 184))) and (v94 > (86 - (84 + 2))) and not v60.GrandWarlocksDesign:IsAvailable()) or ((6816 - 2680) <= (2474 + 959))) then
			v95 = v94;
		else
			v95 = v60.SummonDemonicTyrant:CooldownRemains();
		end
		if (((5087 - (497 + 345)) <= (119 + 4512)) and v114() and v112()) then
			v88 = v29(v113(), v111()) - (v13:GCD() * (0.5 + 0));
		end
		if (((5609 - (605 + 728)) >= (2793 + 1121)) and not v60.SummonVilefiend:IsAvailable() and v60.GrimoireFelguard:IsAvailable() and v112()) then
			v88 = v29(v111(), v107()) - (v13:GCD() * (0.5 - 0));
		end
		if (((10 + 188) <= (16138 - 11773)) and not v60.SummonVilefiend:IsAvailable() and (not v60.GrimoireFelguard:IsAvailable() or not v13:HasTier(28 + 2, 5 - 3)) and v112()) then
			v88 = v111() - (v13:GCD() * (0.5 + 0));
		end
		if (((5271 - (457 + 32)) > (1984 + 2692)) and ((not v114() and v60.SummonVilefiend:IsAvailable()) or not v112())) then
			v88 = 1402 - (832 + 570);
		end
		v89 = not v60.NetherPortal:IsAvailable() or (v60.NetherPortal:CooldownRemains() > (29 + 1)) or v13:BuffUp(v60.NetherPortalBuff);
		local v153 = v26(v60.SacrificedSouls:IsAvailable());
		v90 = false;
		if (((1269 + 3595) > (7774 - 5577)) and (v102 > (1 + 0 + v153))) then
			v90 = not v110();
		end
		if (((v102 > ((798 - (588 + 208)) + v153)) and (v102 < ((13 - 8) + v153))) or ((5500 - (884 + 916)) == (5248 - 2741))) then
			v90 = v109() < (4 + 2);
		end
		if (((5127 - (232 + 421)) >= (2163 - (1569 + 320))) and (v102 > (1 + 3 + v153))) then
			v90 = v109() < (2 + 6);
		end
		v91 = (v60.SummonDemonicTyrant:CooldownRemains() < (67 - 47)) and (v95 < (625 - (316 + 289))) and ((v13:BuffStack(v60.DemonicCoreBuff) <= (5 - 3)) or v13:BuffDown(v60.DemonicCoreBuff)) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (1 + 4))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (1458 - (666 + 787))));
	end
	local function v124()
		local v154 = v103.HandleTopTrinket(v63, v32, 465 - (360 + 65), nil);
		if (v154 or ((1771 + 123) <= (1660 - (79 + 175)))) then
			return v154;
		end
		local v154 = v103.HandleBottomTrinket(v63, v32, 63 - 23, nil);
		if (((1227 + 345) >= (4692 - 3161)) and v154) then
			return v154;
		end
	end
	local function v125()
		if ((v61.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v60.DemonicPowerBuff) or (not v60.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v60.NetherPortalBuff) or not v60.NetherPortal:IsAvailable())))) or ((9025 - 4338) < (5441 - (503 + 396)))) then
			if (((3472 - (92 + 89)) > (3233 - 1566)) and v24(v62.TimebreachingTalon)) then
				return "timebreaching_talon items 2";
			end
		end
		if (not v60.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v60.DemonicPowerBuff) or ((448 + 425) == (1204 + 830))) then
			local v165 = 0 - 0;
			local v166;
			while true do
				if ((v165 == (0 + 0)) or ((6420 - 3604) < (10 + 1))) then
					v166 = v124();
					if (((1767 + 1932) < (14332 - 9626)) and v166) then
						return v166;
					end
					break;
				end
			end
		end
	end
	local function v126()
		if (((331 + 2315) >= (1335 - 459)) and v60.Berserking:IsCastable()) then
			if (((1858 - (485 + 759)) <= (7367 - 4183)) and v24(v60.Berserking, v33)) then
				return "berserking ogcd 4";
			end
		end
		if (((4315 - (442 + 747)) == (4261 - (832 + 303))) and v60.BloodFury:IsCastable()) then
			if (v24(v60.BloodFury, v33) or ((3133 - (88 + 858)) >= (1510 + 3444))) then
				return "blood_fury ogcd 6";
			end
		end
		if (v60.Fireblood:IsCastable() or ((3209 + 668) == (148 + 3427))) then
			if (((1496 - (766 + 23)) > (3120 - 2488)) and v24(v60.Fireblood, v33)) then
				return "fireblood ogcd 8";
			end
		end
		if (v60.AncestralCall:IsCastable() or ((745 - 199) >= (7071 - 4387))) then
			if (((4972 - 3507) <= (5374 - (1036 + 37))) and v23(v60.AncestralCall, v33)) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v127()
		local v155 = 0 + 0;
		while true do
			if (((3317 - 1613) > (1121 + 304)) and (v155 == (1482 - (641 + 839)))) then
				if ((v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (917 - (910 + 3))) and (not v114() or (not v60.SummonVilefiend:IsAvailable() and v111())) and v13:BuffDown(v60.NetherPortalBuff)) or ((1751 - 1064) == (5918 - (1466 + 218)))) then
					if (v23(v60.PowerSiphon, v55) or ((1531 + 1799) < (2577 - (556 + 592)))) then
						return "power_siphon tyrant 12";
					end
				end
				if (((408 + 739) >= (1143 - (329 + 479))) and v60.ShadowBolt:IsReady() and not v114() and v13:BuffDown(v60.NetherPortalBuff) and not v112() and (v97 < ((859 - (174 + 680)) - v13:BuffStack(v60.DemonicCoreBuff)))) then
					if (((11803 - 8368) > (4346 - 2249)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				if ((v60.NetherPortal:IsReady() and (v97 == (4 + 1))) or ((4509 - (396 + 343)) >= (358 + 3683))) then
					if (v23(v60.NetherPortal, v54) or ((5268 - (29 + 1448)) <= (3000 - (135 + 1254)))) then
						return "nether_portal tyrant 16";
					end
				end
				v155 = 11 - 8;
			end
			if (((23 - 18) == v155) or ((3051 + 1527) <= (3535 - (389 + 1138)))) then
				if (((1699 - (102 + 472)) <= (1960 + 116)) and v60.ShadowBolt:IsCastable()) then
					if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((413 + 330) >= (4102 + 297))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if (((2700 - (320 + 1225)) < (2978 - 1305)) and (v155 == (1 + 0))) then
				if ((v60.SummonDemonicTyrant:IsCastable() and (v88 > (1464 - (157 + 1307))) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99))) or ((4183 - (821 + 1038)) <= (1442 - 864))) then
					if (((412 + 3355) == (6691 - 2924)) and v24(v60.SummonDemonicTyrant, nil, nil, v56)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				if (((1522 + 2567) == (10134 - 6045)) and v60.Implosion:IsReady() and (v105() > (1028 - (834 + 192))) and not v112() and not v108() and not v114() and ((v102 > (1 + 2)) or ((v102 > (1 + 1)) and v60.GrandWarlocksDesign:IsAvailable())) and not v13:PrevGCDP(1 + 0, v60.Implosion)) then
					if (((6906 - 2448) >= (1978 - (300 + 4))) and v23(v60.Implosion, v53, nil, not v14:IsInRange(11 + 29))) then
						return "implosion tyrant 8";
					end
				end
				if (((2544 - 1572) <= (1780 - (112 + 250))) and v60.ShadowBolt:IsReady() and v13:PrevGCDP(1 + 0, v60.GrimoireFelguard) and (v98 > (75 - 45)) and v13:BuffDown(v60.NetherPortalBuff) and v13:BuffDown(v60.DemonicCoreBuff)) then
					if (v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt)) or ((2829 + 2109) < (2463 + 2299))) then
						return "shadow_bolt tyrant 10";
					end
				end
				v155 = 2 + 0;
			end
			if ((v155 == (2 + 2)) or ((1861 + 643) > (5678 - (1001 + 413)))) then
				if (((4800 - 2647) == (3035 - (244 + 638))) and v60.HandofGuldan:IsReady() and (((v97 > (695 - (627 + 66))) and (v114() or (not v60.SummonVilefiend:IsAvailable() and v112())) and ((v97 > (5 - 3)) or (v113() < ((v99 * (604 - (512 + 90))) + ((1908 - (1665 + 241)) / v13:SpellHaste()))))) or (not v112() and (v97 == (722 - (373 + 344)))))) then
					if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((229 + 278) >= (686 + 1905))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((11819 - 7338) == (7582 - 3101)) and v60.Demonbolt:IsReady() and (v97 < (1103 - (35 + 1064))) and (v13:BuffStack(v60.DemonicCoreBuff) > (1 + 0)) and (v114() or (not v60.SummonVilefiend:IsAvailable() and v112()) or not v22())) then
					if ((v60.DoomBrandDebuff:AuraActiveCount() == v102) or not v13:HasTier(66 - 35, 1 + 1) or ((3564 - (298 + 938)) < (1952 - (233 + 1026)))) then
						if (((5994 - (636 + 1030)) == (2213 + 2115)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
							return "demonbolt tyrant 26";
						end
					elseif (((1552 + 36) >= (396 + 936)) and v103.CastCycle(v60.Demonbolt, v101, v120, not v14:IsSpellInRange(v60.Demonbolt))) then
						return "demonbolt tyrant 27";
					end
				end
				if ((v60.PowerSiphon:IsReady() and v55 and (((v13:BuffStack(v60.DemonicCoreBuff) < (1 + 2)) and (v88 > (v60.SummonDemonicTyrant:ExecuteTime() + (v99 * (224 - (55 + 166)))))) or (v88 == (0 + 0)))) or ((420 + 3754) > (16223 - 11975))) then
					if (v23(v60.PowerSiphon) or ((4883 - (36 + 261)) <= (142 - 60))) then
						return "power_siphon tyrant 28";
					end
				end
				v155 = 1373 - (34 + 1334);
			end
			if (((1486 + 2377) == (3002 + 861)) and (v155 == (1283 - (1035 + 248)))) then
				if (((v88 > (21 - (20 + 1))) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99)) and (v93 <= (0 + 0))) or ((601 - (134 + 185)) <= (1175 - (549 + 584)))) then
					v93 = (805 - (314 + 371)) + v98;
				end
				if (((15822 - 11213) >= (1734 - (478 + 490))) and v60.HandofGuldan:IsReady() and (v97 > (0 + 0)) and (v88 > (v99 + v60.SummonDemonicTyrant:CastTime())) and (v88 < (v99 * (1176 - (786 + 386))))) then
					if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((3731 - 2579) == (3867 - (1055 + 324)))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((4762 - (1093 + 247)) > (2977 + 373)) and (v88 > (0 + 0)) and (v88 < (v60.SummonDemonicTyrant:ExecuteTime() + (v26(v13:BuffDown(v60.DemonicCoreBuff)) * v60.ShadowBolt:ExecuteTime()) + (v26(v13:BuffUp(v60.DemonicCoreBuff)) * v99) + v99))) then
					local v182 = 0 - 0;
					local v183;
					local v184;
					while true do
						if (((2976 - 2099) > (1069 - 693)) and (v182 == (4 - 2))) then
							v184 = v103.HandleDPSPotion();
							if (v184 or ((1110 + 2008) <= (7130 - 5279))) then
								return v184;
							end
							break;
						end
						if (((3 - 2) == v182) or ((125 + 40) >= (8930 - 5438))) then
							v183 = v126();
							if (((4637 - (364 + 324)) < (13311 - 8455)) and v183) then
								return v183;
							end
							v182 = 4 - 2;
						end
						if ((v182 == (0 + 0)) or ((17892 - 13616) < (4829 - 1813))) then
							v183 = v125();
							if (((14244 - 9554) > (5393 - (1249 + 19))) and v183) then
								return v183;
							end
							v182 = 1 + 0;
						end
					end
				end
				v155 = 3 - 2;
			end
			if ((v155 == (1089 - (686 + 400))) or ((40 + 10) >= (1125 - (73 + 156)))) then
				if ((v60.SummonVilefiend:IsReady() and ((v97 == (1 + 4)) or v13:BuffUp(v60.NetherPortalBuff)) and (v60.SummonDemonicTyrant:CooldownRemains() < (824 - (721 + 90))) and v89) or ((20 + 1694) >= (9604 - 6646))) then
					if (v23(v60.SummonVilefiend) or ((1961 - (224 + 246)) < (1042 - 398))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if (((1295 - 591) < (180 + 807)) and v60.CallDreadstalkers:IsReady() and (v114() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (1 + 29))) and (v13:BuffUp(v60.NetherPortalBuff) or v108() or (v97 == (4 + 1))))) and (v60.SummonDemonicTyrant:CooldownRemains() < (21 - 10)) and v89) then
					if (((12372 - 8654) > (2419 - (203 + 310))) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v60.GrimoireFelguard:IsReady() and (v114() or (not v60.SummonVilefiend:IsAvailable() and (not v60.NetherPortal:IsAvailable() or v13:BuffUp(v60.NetherPortalBuff) or (v60.NetherPortal:CooldownRemains() > (2023 - (1238 + 755)))) and (v13:BuffUp(v60.NetherPortalBuff) or v112() or (v97 == (1 + 4))) and v89))) or ((2492 - (709 + 825)) > (6698 - 3063))) then
					if (((5099 - 1598) <= (5356 - (196 + 668))) and v23(v60.GrimoireFelguard, v52)) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v155 = 15 - 11;
			end
		end
	end
	local function v128()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (833 - (171 + 662))) or ((3535 - (4 + 89)) < (8930 - 6382))) then
				if (((1047 + 1828) >= (6430 - 4966)) and v60.SummonDemonicTyrant:IsCastable() and (v86 < (8 + 12))) then
					if (v24(v60.SummonDemonicTyrant, nil, nil, v56) or ((6283 - (35 + 1451)) >= (6346 - (28 + 1425)))) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if ((v86 < (2013 - (941 + 1052))) or ((529 + 22) > (3582 - (822 + 692)))) then
					local v185 = 0 - 0;
					while true do
						if (((996 + 1118) > (1241 - (45 + 252))) and (v185 == (1 + 0))) then
							if (v60.SummonVilefiend:IsReady() or ((779 + 1483) >= (7534 - 4438))) then
								if (v23(v60.SummonVilefiend) or ((2688 - (114 + 319)) >= (5078 - 1541))) then
									return "summon_vilefiend fight_end 6";
								end
							end
							break;
						end
						if ((v185 == (0 - 0)) or ((2447 + 1390) < (1945 - 639))) then
							if (((6181 - 3231) == (4913 - (556 + 1407))) and v60.GrimoireFelguard:IsReady() and v52) then
								if (v23(v60.GrimoireFelguard) or ((5929 - (741 + 465)) < (3763 - (170 + 295)))) then
									return "grimoire_felguard fight_end 2";
								end
							end
							if (((599 + 537) >= (142 + 12)) and v60.CallDreadstalkers:IsReady()) then
								if (v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers)) or ((667 - 396) > (3936 + 812))) then
									return "call_dreadstalkers fight_end 4";
								end
							end
							v185 = 1 + 0;
						end
					end
				end
				v156 = 1 + 0;
			end
			if (((5970 - (957 + 273)) >= (844 + 2308)) and (v156 == (1 + 0))) then
				if ((v60.NetherPortal:IsReady() and v54 and (v86 < (114 - 84))) or ((6793 - 4215) >= (10354 - 6964))) then
					if (((203 - 162) <= (3441 - (389 + 1391))) and v23(v60.NetherPortal)) then
						return "nether_portal fight_end 8";
					end
				end
				if (((378 + 223) < (371 + 3189)) and v60.DemonicStrength:IsCastable() and (v86 < (22 - 12))) then
					if (((1186 - (783 + 168)) < (2305 - 1618)) and v23(v60.DemonicStrength, v51)) then
						return "demonic_strength fight_end 12";
					end
				end
				v156 = 2 + 0;
			end
			if (((4860 - (309 + 2)) > (3540 - 2387)) and (v156 == (1214 - (1090 + 122)))) then
				if ((v60.PowerSiphon:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) < (1 + 2)) and (v86 < (67 - 47))) or ((3199 + 1475) < (5790 - (628 + 490)))) then
					if (((658 + 3010) < (11292 - 6731)) and v23(v60.PowerSiphon, v55)) then
						return "power_siphon fight_end 14";
					end
				end
				if ((v60.Implosion:IsReady() and v53 and (v86 < ((9 - 7) * v99))) or ((1229 - (431 + 343)) == (7280 - 3675))) then
					if (v23(v60.Implosion, nil, nil, not v14:IsInRange(115 - 75)) or ((2104 + 559) == (424 + 2888))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
		end
	end
	local v129 = 1695 - (556 + 1139);
	local v130 = false;
	function UpdateLastMoveTime()
		if (((4292 - (6 + 9)) <= (820 + 3655)) and v13:IsMoving()) then
			if (not v130 or ((446 + 424) == (1358 - (28 + 141)))) then
				local v172 = 0 + 0;
				while true do
					if (((1916 - 363) <= (2219 + 914)) and (v172 == (1317 - (486 + 831)))) then
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
		if (v13:AffectingCombat() or ((5821 - 3584) >= (12360 - 8849))) then
			if (((v13:HealthPercentage() <= v48) and v60.DarkPact:IsCastable() and not v13:BuffUp(v60.DarkPact)) or ((251 + 1073) > (9549 - 6529))) then
				if (v24(v60.DarkPact) or ((4255 - (668 + 595)) == (1693 + 188))) then
					return "dark_pact defensive 2";
				end
			end
			if (((627 + 2479) > (4161 - 2635)) and (v13:HealthPercentage() <= v44) and v60.DrainLife:IsCastable()) then
				if (((3313 - (23 + 267)) < (5814 - (1129 + 815))) and v24(v60.DrainLife)) then
					return "drain_life defensive 2";
				end
			end
			if (((530 - (371 + 16)) > (1824 - (1326 + 424))) and (v13:HealthPercentage() <= v45) and v60.HealthFunnel:IsCastable()) then
				if (((33 - 15) < (7717 - 5605)) and v24(v60.HealthFunnel)) then
					return "health_funnel defensive 2";
				end
			end
			if (((1215 - (88 + 30)) <= (2399 - (720 + 51))) and (v13:HealthPercentage() <= v46) and v60.UnendingResolve:IsCastable()) then
				if (((10299 - 5669) == (6406 - (421 + 1355))) and v24(v60.UnendingResolve)) then
					return "unending_resolve defensive 2";
				end
			end
		end
	end
	local function v132()
		v59();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		if (((5840 - 2300) > (1318 + 1365)) and v31) then
			v101 = v14:GetEnemiesInSplashRange(1091 - (286 + 797));
			v102 = v14:GetEnemiesInSplashRangeCount(29 - 21);
			v100 = v13:GetEnemiesInRange(66 - 26);
		else
			v101 = {};
			v102 = 440 - (397 + 42);
			v100 = {};
		end
		UpdateLastMoveTime();
		if (((1498 + 3296) >= (4075 - (24 + 776))) and (v103.TargetIsValid() or v13:AffectingCombat())) then
			local v167 = 0 - 0;
			while true do
				if (((2269 - (222 + 563)) == (3269 - 1785)) and (v167 == (0 + 0))) then
					v85 = v10.BossFightRemains();
					v86 = v85;
					v167 = 191 - (23 + 167);
				end
				if (((3230 - (690 + 1108)) < (1283 + 2272)) and (v167 == (3 + 0))) then
					v97 = v13:SoulShardsP();
					v99 = v13:GCD() + (848.25 - (40 + 808));
					break;
				end
				if ((v167 == (1 + 1)) or ((4072 - 3007) > (3420 + 158))) then
					v25.UpdateSoulShards();
					v98 = v10.CombatTime();
					v167 = 2 + 1;
				end
				if ((v167 == (1 + 0)) or ((5366 - (47 + 524)) < (914 + 493))) then
					if (((5065 - 3212) < (7196 - 2383)) and (v86 == (25340 - 14229))) then
						v86 = v10.FightRemains(v101, false);
					end
					v25.UpdatePetTable();
					v167 = 1728 - (1165 + 561);
				end
			end
		end
		if ((v60.SummonPet:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v47 and not v17:IsActive()) or ((84 + 2737) < (7529 - 5098))) then
			if (v24(v60.SummonPet, false, true) or ((1097 + 1777) < (2660 - (341 + 138)))) then
				return "summon_pet ooc";
			end
		end
		if ((v61.Healthstone:IsReady() and v38 and (v13:HealthPercentage() <= v39)) or ((726 + 1963) <= (707 - 364))) then
			if (v24(v62.Healthstone) or ((2195 - (89 + 237)) == (6462 - 4453))) then
				return "healthstone defensive 3";
			end
		end
		if ((v35 and (v13:HealthPercentage() <= v37)) or ((7465 - 3919) < (3203 - (581 + 300)))) then
			local v168 = 1220 - (855 + 365);
			while true do
				if ((v168 == (0 - 0)) or ((680 + 1402) == (6008 - (1030 + 205)))) then
					if (((3046 + 198) > (982 + 73)) and (v36 == "Refreshing Healing Potion")) then
						if (v61.RefreshingHealingPotion:IsReady() or ((3599 - (156 + 130)) <= (4039 - 2261))) then
							if (v24(v62.RefreshingHealingPotion) or ((2394 - 973) >= (4308 - 2204))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((478 + 1334) <= (1895 + 1354)) and (v36 == "Dreamwalker's Healing Potion")) then
						if (((1692 - (10 + 59)) <= (554 + 1403)) and v61.DreamwalkersHealingPotion:IsReady()) then
							if (((21728 - 17316) == (5575 - (671 + 492))) and v24(v62.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((1394 + 356) >= (2057 - (369 + 846))) and v103.TargetIsValid()) then
			if (((1158 + 3214) > (1579 + 271)) and not v13:AffectingCombat() and v30 and not v13:IsCasting(v60.ShadowBolt)) then
				local v173 = 1945 - (1036 + 909);
				local v174;
				while true do
					if (((185 + 47) < (1378 - 557)) and (v173 == (203 - (11 + 192)))) then
						v174 = v122();
						if (((262 + 256) < (1077 - (135 + 40))) and v174) then
							return v174;
						end
						break;
					end
				end
			end
			if (((7254 - 4260) > (518 + 340)) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v175 = v103.Interrupt(v60.SpellLock, 88 - 48, true);
				if (v175 or ((5629 - 1874) <= (1091 - (50 + 126)))) then
					return v175;
				end
				v175 = v103.Interrupt(v60.SpellLock, 111 - 71, true, v16, v62.SpellLockMouseover);
				if (((874 + 3072) > (5156 - (1233 + 180))) and v175) then
					return v175;
				end
				v175 = v103.Interrupt(v60.AxeToss, 1009 - (522 + 447), true);
				if (v175 or ((2756 - (107 + 1314)) >= (1535 + 1771))) then
					return v175;
				end
				v175 = v103.Interrupt(v60.AxeToss, 121 - 81, true, v16, v62.AxeTossMouseover);
				if (((2058 + 2786) > (4473 - 2220)) and v175) then
					return v175;
				end
				v175 = v103.InterruptWithStun(v60.AxeToss, 158 - 118, true);
				if (((2362 - (716 + 1194)) == (8 + 444)) and v175) then
					return v175;
				end
				v175 = v103.InterruptWithStun(v60.AxeToss, 5 + 35, true, v16, v62.AxeTossMouseover);
				if (v175 or ((5060 - (74 + 429)) < (4025 - 1938))) then
					return v175;
				end
			end
			if (((1921 + 1953) == (8867 - 4993)) and v13:AffectingCombat() and v57) then
				if ((v60.BurningRush:IsCastable() and not v13:BuffUp(v60.BurningRush) and v130 and ((GetTime() - v129) >= (1 + 0)) and (v13:HealthPercentage() >= v58)) or ((5974 - 4036) > (12202 - 7267))) then
					if (v24(v60.BurningRush) or ((4688 - (279 + 154)) < (4201 - (454 + 324)))) then
						return "burning_rush defensive 2";
					end
				elseif (((1144 + 310) <= (2508 - (12 + 5))) and v60.BurningRush:IsCastable() and v13:BuffUp(v60.BurningRush) and (not v130 or (v13:HealthPercentage() <= v58))) then
					if (v24(v62.CancelBurningRush) or ((2242 + 1915) <= (7141 - 4338))) then
						return "burning_rush defensive 4";
					end
				end
			end
			local v169 = v131();
			if (((1794 + 3059) >= (4075 - (277 + 816))) and v169) then
				return v169;
			end
			if (((17664 - 13530) > (4540 - (1058 + 125))) and v60.UnendingResolve:IsReady() and (v13:HealthPercentage() < v46)) then
				if (v24(v60.UnendingResolve, nil, nil, true) or ((641 + 2776) < (3509 - (815 + 160)))) then
					return "unending_resolve defensive";
				end
			end
			v123();
			if (v110() or (v86 < (94 - 72)) or ((6461 - 3739) <= (40 + 124))) then
				local v176 = 0 - 0;
				local v177;
				while true do
					if ((v176 == (1898 - (41 + 1857))) or ((4301 - (1222 + 671)) < (5450 - 3341))) then
						v177 = v126();
						if ((v177 and v33 and v32) or ((46 - 13) == (2637 - (229 + 953)))) then
							return v177;
						end
						break;
					end
				end
			end
			local v169 = v125();
			if (v169 or ((2217 - (1111 + 663)) >= (5594 - (874 + 705)))) then
				return v169;
			end
			if (((474 + 2908) > (114 + 52)) and (v86 < (62 - 32))) then
				local v178 = v128();
				if (v178 or ((8 + 272) == (3738 - (642 + 37)))) then
					return v178;
				end
			end
			if (((429 + 1452) > (207 + 1086)) and v60.HandofGuldan:IsReady() and (v98 < (0.5 - 0)) and (((v86 % (549 - (233 + 221))) > (92 - 52)) or ((v86 % (84 + 11)) < (1556 - (718 + 823)))) and (v60.ReignofTyranny:IsAvailable() or (v102 > (2 + 0)))) then
				if (((3162 - (266 + 539)) == (6673 - 4316)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
					return "hand_of_guldan main 2";
				end
			end
			if (((1348 - (636 + 589)) == (291 - 168)) and (((v60.SummonDemonicTyrant:CooldownRemains() < (30 - 15)) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (4 + 1))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (2 + 3))) and ((v60.GrimoireFelguard:CooldownRemains() < (1025 - (657 + 358))) or not v13:HasTier(79 - 49, 4 - 2)) and ((v95 < (1202 - (1151 + 36))) or (v86 < (39 + 1)) or v13:PowerInfusionUp())) or (v60.SummonVilefiend:IsAvailable() and (v60.SummonDemonicTyrant:CooldownRemains() < (4 + 11)) and (v60.SummonVilefiend:CooldownRemains() < (v99 * (14 - 9))) and (v60.CallDreadstalkers:CooldownRemains() < (v99 * (1837 - (1552 + 280)))) and ((v60.GrimoireFelguard:CooldownRemains() < (844 - (64 + 770))) or not v13:HasTier(21 + 9, 4 - 2)) and ((v95 < (3 + 12)) or (v86 < (1283 - (157 + 1086))) or v13:PowerInfusionUp())))) then
				local v179 = v127();
				if (v179 or ((2113 - 1057) >= (14855 - 11463))) then
					return v179;
				end
			end
			if (((v60.SummonDemonicTyrant:CooldownRemains() < (22 - 7)) and (v114() or (not v60.SummonVilefiend:IsAvailable() and (v108() or v60.GrimoireFelguard:CooldownUp() or not v13:HasTier(40 - 10, 821 - (599 + 220))))) and ((v95 < (29 - 14)) or v108() or (v86 < (1971 - (1813 + 118))) or v13:PowerInfusionUp())) or ((791 + 290) < (2292 - (841 + 376)))) then
				local v180 = 0 - 0;
				local v181;
				while true do
					if ((v180 == (0 + 0)) or ((2863 - 1814) >= (5291 - (464 + 395)))) then
						v181 = v127();
						if (v181 or ((12236 - 7468) <= (407 + 439))) then
							return v181;
						end
						break;
					end
				end
			end
			if ((v60.SummonDemonicTyrant:IsCastable() and v56 and (v114() or v108() or (v60.GrimoireFelguard:CooldownRemains() > (927 - (467 + 370))))) or ((6939 - 3581) <= (1043 + 377))) then
				if (v23(v60.SummonDemonicTyrant) or ((12817 - 9078) <= (469 + 2536))) then
					return "summon_demonic_tyrant main 4";
				end
			end
			if ((v60.SummonVilefiend:IsReady() and (v60.SummonDemonicTyrant:CooldownRemains() > (104 - 59))) or ((2179 - (150 + 370)) >= (3416 - (74 + 1208)))) then
				if (v23(v60.SummonVilefiend) or ((8018 - 4758) < (11168 - 8813))) then
					return "summon_vilefiend main 6";
				end
			end
			if ((v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (((not v60.SoulStrike:IsAvailable() or (v60.SoulStrike:CooldownRemains() > (v99 * (2 + 0)))) and (v97 < (394 - (14 + 376)))) or (v97 < ((6 - 2) - (v26(v102 > (2 + 0)))))) and not v13:PrevGCDP(1 + 0, v60.Demonbolt) and v13:HasTier(30 + 1, 5 - 3)) or ((504 + 165) == (4301 - (23 + 55)))) then
				if (v103.CastCycle(v60.Demonbolt, v101, v117, not v14:IsSpellInRange(v60.Demonbolt)) or ((4009 - 2317) < (393 + 195))) then
					return "demonbolt main 8";
				end
			end
			if ((v60.PowerSiphon:IsReady() and v13:BuffDown(v60.DemonicCoreBuff) and (v14:DebuffDown(v60.DoomBrandDebuff) or (not v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v99 + v60.Demonbolt:TravelTime()))) or (v60.HandofGuldan:InFlight() and (v14:DebuffRemains(v60.DoomBrandDebuff) < (v99 + v60.Demonbolt:TravelTime() + 3 + 0)))) and v13:HasTier(47 - 16, 1 + 1)) or ((5698 - (652 + 249)) < (9770 - 6119))) then
				if (v23(v60.PowerSiphon, v55) or ((6045 - (708 + 1160)) > (13165 - 8315))) then
					return "power_siphon main 10";
				end
			end
			if ((v60.DemonicStrength:IsCastable() and (v13:BuffRemains(v60.NetherPortalBuff) < v99)) or ((729 - 329) > (1138 - (10 + 17)))) then
				if (((686 + 2365) > (2737 - (1400 + 332))) and v23(v60.DemonicStrength, v51)) then
					return "demonic_strength main 12";
				end
			end
			if (((7083 - 3390) <= (6290 - (242 + 1666))) and v60.BilescourgeBombers:IsReady() and v60.BilescourgeBombers:IsCastable()) then
				if (v23(v60.BilescourgeBombers, nil, nil, not v14:IsInRange(18 + 22)) or ((1203 + 2079) > (3495 + 605))) then
					return "bilescourge_bombers main 14";
				end
			end
			if ((v60.Guillotine:IsCastable() and v50 and (v13:BuffRemains(v60.NetherPortalBuff) < v99) and (v60.DemonicStrength:CooldownDown() or not v60.DemonicStrength:IsAvailable())) or ((4520 - (850 + 90)) < (4981 - 2137))) then
				if (((1479 - (360 + 1030)) < (3974 + 516)) and v23(v62.GuillotineCursor, nil, nil, not v14:IsInRange(112 - 72))) then
					return "guillotine main 16";
				end
			end
			if ((v60.CallDreadstalkers:IsReady() and ((v60.SummonDemonicTyrant:CooldownRemains() > (33 - 8)) or (v95 > (1686 - (909 + 752))) or v13:BuffUp(v60.NetherPortalBuff))) or ((6206 - (109 + 1114)) < (3310 - 1502))) then
				if (((1491 + 2338) > (4011 - (6 + 236))) and v23(v60.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v60.CallDreadstalkers))) then
					return "call_dreadstalkers main 18";
				end
			end
			if (((936 + 549) <= (2338 + 566)) and v60.Implosion:IsReady() and (v106(4 - 2) > (0 - 0)) and v90 and not v13:PrevGCDP(1134 - (1076 + 57), v60.Implosion)) then
				if (((703 + 3566) == (4958 - (579 + 110))) and v23(v60.Implosion, v53, nil, not v14:IsInRange(4 + 36))) then
					return "implosion main 20";
				end
			end
			if (((343 + 44) <= (1477 + 1305)) and v60.SummonSoulkeeper:IsReady() and (v60.SummonSoulkeeper:Count() == (417 - (174 + 233))) and (v102 > (2 - 1))) then
				if (v23(v60.SummonSoulkeeper) or ((3332 - 1433) <= (408 + 509))) then
					return "soul_strike main 22";
				end
			end
			if ((v60.HandofGuldan:IsReady() and (((v97 > (1176 - (663 + 511))) and (v60.CallDreadstalkers:CooldownRemains() > (v99 * (4 + 0))) and (v60.SummonDemonicTyrant:CooldownRemains() > (4 + 13))) or (v97 == (15 - 10)) or ((v97 == (3 + 1)) and v60.SoulStrike:IsAvailable() and (v60.SoulStrike:CooldownRemains() < (v99 * (4 - 2))))) and (v102 == (2 - 1)) and v60.GrandWarlocksDesign:IsAvailable()) or ((2058 + 2254) <= (1704 - 828))) then
				if (((1591 + 641) <= (238 + 2358)) and v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan))) then
					return "hand_of_guldan main 26";
				end
			end
			if (((2817 - (478 + 244)) < (4203 - (440 + 77))) and v60.HandofGuldan:IsReady() and (v97 > (1 + 1)) and not ((v102 == (3 - 2)) and v60.GrandWarlocksDesign:IsAvailable())) then
				if (v23(v60.HandofGuldan, nil, nil, not v14:IsSpellInRange(v60.HandofGuldan)) or ((3151 - (655 + 901)) >= (830 + 3644))) then
					return "hand_of_guldan main 28";
				end
			end
			if ((v60.Demonbolt:IsReady() and (v13:BuffStack(v60.DemonicCoreBuff) > (1 + 0)) and (((v97 < (3 + 1)) and not v60.SoulStrike:IsAvailable()) or (v60.SoulStrike:CooldownRemains() > (v99 * (7 - 5))) or (v97 < (1447 - (695 + 750)))) and not v91) or ((15772 - 11153) < (4447 - 1565))) then
				if (v103.CastCycle(v60.Demonbolt, v101, v118, not v14:IsSpellInRange(v60.Demonbolt)) or ((1182 - 888) >= (5182 - (285 + 66)))) then
					return "demonbolt main 30";
				end
			end
			if (((4729 - 2700) <= (4394 - (682 + 628))) and v60.Demonbolt:IsReady() and v13:HasTier(5 + 26, 301 - (176 + 123)) and v13:BuffUp(v60.DemonicCoreBuff) and (v97 < (2 + 2)) and not v91) then
				if (v103.CastTargetIf(v60.Demonbolt, v101, "==", v118, v121, not v14:IsSpellInRange(v60.Demonbolt)) or ((1478 + 559) == (2689 - (239 + 30)))) then
					return "demonbolt main 32";
				end
			end
			if (((1212 + 3246) > (3753 + 151)) and v60.Demonbolt:IsReady() and (v86 < (v13:BuffStack(v60.DemonicCoreBuff) * v99))) then
				if (((771 - 335) >= (383 - 260)) and v23(v60.Demonbolt, nil, nil, not v14:IsSpellInRange(v60.Demonbolt))) then
					return "demonbolt main 34";
				end
			end
			if (((815 - (306 + 9)) < (6337 - 4521)) and v60.Demonbolt:IsReady() and v13:BuffUp(v60.DemonicCoreBuff) and (v60.PowerSiphon:CooldownRemains() < (1 + 3)) and (v97 < (3 + 1)) and not v91) then
				if (((1721 + 1853) == (10220 - 6646)) and v103.CastCycle(v60.Demonbolt, v101, v118, not v14:IsSpellInRange(v60.Demonbolt))) then
					return "demonbolt main 36";
				end
			end
			if (((1596 - (1140 + 235)) < (249 + 141)) and v60.PowerSiphon:IsReady() and (v13:BuffDown(v60.DemonicCoreBuff))) then
				if (v23(v60.PowerSiphon, v55) or ((2030 + 183) <= (365 + 1056))) then
					return "power_siphon main 38";
				end
			end
			if (((3110 - (33 + 19)) < (1755 + 3105)) and v60.SummonVilefiend:IsReady() and (v86 < (v60.SummonDemonicTyrant:CooldownRemains() + (14 - 9)))) then
				if (v23(v60.SummonVilefiend) or ((571 + 725) >= (8718 - 4272))) then
					return "summon_vilefiend main 40";
				end
			end
			if (v60.Doom:IsReady() or ((1307 + 86) > (5178 - (586 + 103)))) then
				if (v103.CastCycle(v60.Doom, v100, v119, not v14:IsSpellInRange(v60.Doom)) or ((403 + 4021) < (82 - 55))) then
					return "doom main 42";
				end
			end
			if (v60.ShadowBolt:IsCastable() or ((3485 - (1309 + 179)) > (6887 - 3072))) then
				if (((1509 + 1956) > (5137 - 3224)) and v23(v60.ShadowBolt, nil, nil, not v14:IsSpellInRange(v60.ShadowBolt))) then
					return "shadow_bolt main 44";
				end
			end
		end
	end
	local function v133()
		v10.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(201 + 65, v132, v133);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

