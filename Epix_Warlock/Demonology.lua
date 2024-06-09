local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 1555 - (991 + 564);
	local v7;
	while true do
		if (((2973 + 1573) >= (3834 - (1381 + 178))) and (v6 == (1 + 0))) then
			return v7(v0, ...);
		end
		if (((661 + 158) >= (10 + 12)) and (v6 == (0 - 0))) then
			v7 = v1[v5];
			if (((1639 + 1523) == (3632 - (381 + 89))) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
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
		local v135 = 0 + 0;
		while true do
			if ((v135 == (8 - 3)) or ((3525 - (1074 + 82)) > (9705 - 5276))) then
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (1784 - (214 + 1570));
				v58 = EpicSettings.Settings['UseBurningRush'] or (1455 - (990 + 465));
				v59 = EpicSettings.Settings['BurningRushHP'] or (0 + 0);
				v45 = EpicSettings.Settings['DrainLifeHP'] or (0 + 0);
				v135 = 6 + 0;
			end
			if (((16115 - 12020) >= (4909 - (1668 + 58))) and (v135 == (628 - (512 + 114)))) then
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v135 = 2 + 1;
			end
			if (((1 + 3) == v135) or ((3227 + 484) < (3399 - 2391))) then
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v135 = 1999 - (109 + 1885);
			end
			if ((v135 == (1475 - (1269 + 200))) or ((2010 - 961) <= (1721 - (98 + 717)))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (826 - (802 + 24));
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				break;
			end
			if (((5699 - 1186) > (403 + 2323)) and (v135 == (0 + 0))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v135 = 1 + 0;
			end
			if ((v135 == (8 - 5)) or ((4938 - 3457) >= (951 + 1707))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				v52 = EpicSettings.Settings['DemonicStrength'];
				v135 = 3 + 1;
			end
			if ((v135 == (1 + 0)) or ((4653 - (797 + 636)) == (6622 - 5258))) then
				v38 = EpicSettings.Settings['HealingPotionHP'] or (1619 - (1427 + 192));
				v39 = EpicSettings.Settings['UseHealthstone'] or (0 + 0);
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v135 = 1 + 1;
			end
		end
	end
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = v21.Warlock.Demonology;
	local v64 = {v62.MirrorofFracturedTomorrows:ID(),v62.NymuesUnravelingSpindle:ID(),v62.TimeThiefsGambit:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[11 + 2] and v20(v65[13 + 0])) or v20(0 - 0);
	local v67 = (v65[565 - (83 + 468)] and v20(v65[1820 - (1202 + 604)])) or v20(0 - 0);
	local v68 = v66:Level() or (0 - 0);
	local v69 = v67:Level() or (0 - 0);
	local v70 = v66:OnUseSpell();
	local v71 = v67:OnUseSpell();
	local v72 = (v70 and (v70.MaximumRange > (325 - (45 + 280))) and (v70.MaximumRange <= (97 + 3)) and v70.MaximumRange) or (88 + 12);
	local v73 = (v71 and (v71.MaximumRange > (0 + 0)) and (v71.MaximumRange <= (56 + 44)) and v71.MaximumRange) or (18 + 82);
	v72 = ((v66:ID() == v62.BelorrelostheSuncaller:ID()) and (18 - 8)) or v72;
	v73 = ((v67:ID() == v62.BelorrelostheSuncaller:ID()) and (1921 - (340 + 1571))) or v73;
	local v74 = v66:HasUseBuff();
	local v75 = v67:HasUseBuff();
	local v76 = (v66:ID() == v62.RubyWhelpShell:ID()) or (v66:ID() == v62.WhisperingIncarnateIcon:ID()) or (v66:ID() == v62.TimeThiefsGambit:ID());
	local v77 = (v67:ID() == v62.RubyWhelpShell:ID()) or (v67:ID() == v62.WhisperingIncarnateIcon:ID()) or (v67:ID() == v62.TimeThiefsGambit:ID());
	local v78 = v66:ID() == v62.NymuesUnravelingSpindle:ID();
	local v79 = v67:ID() == v62.NymuesUnravelingSpindle:ID();
	local v80 = v66:BuffDuration() + (v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()) * (8 + 12)) + (v27(v66:ID() == v62.NymuesUnravelingSpindle:ID()) * (1774 - (1733 + 39)));
	local v81 = v67:BuffDuration() + (v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID()) * (54 - 34)) + (v27(v67:ID() == v62.NymuesUnravelingSpindle:ID()) * (1036 - (125 + 909)));
	local v82 = (v74 and (((v66:Cooldown() % (2038 - (1096 + 852))) == (0 + 0)) or (((128 - 38) % v66:Cooldown()) == (0 + 0))) and (513 - (409 + 103))) or (236.5 - (46 + 190));
	local v83 = (v75 and (((v67:Cooldown() % (185 - (51 + 44))) == (0 + 0)) or (((1407 - (1114 + 203)) % v67:Cooldown()) == (726 - (228 + 498)))) and (1 + 0)) or (0.5 + 0);
	local v84 = (v71 and not v70 and (665 - (174 + 489))) or (2 - 1);
	local v85 = (v71 and not v70 and (1907 - (830 + 1075))) or (525 - (303 + 221));
	if ((v70 and v71) or ((2323 - (231 + 1038)) > (2827 + 565))) then
		v84 = (not v74 and not v75 and (v69 > v68) and (1164 - (171 + 991))) or (4 - 3);
		local v150 = ((v67:Cooldown() / v81) * v83 * ((2 - 1) - ((0.5 - 0) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 + 0);
		local v151 = ((v66:Cooldown() / v80) * v82 * ((3 - 2) - ((0.5 - 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * ((1 - 0) + ((v68 - v69) / (309 - 209)))) or (1248 - (111 + 1137));
		if ((not v74 and v75) or (v75 and (v150 > v151)) or ((834 - (91 + 67)) >= (4886 - 3244))) then
			v85 = 1 + 1;
		else
			v85 = 524 - (423 + 100);
		end
	end
	local v86 = 78 + 11033;
	local v87 = 30764 - 19653;
	local v88 = 8 + 6 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	local v89 = 771 - (326 + 445);
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = 0 - 0;
	local v94 = 0 - 0;
	local v95 = 0 - 0;
	local v96 = 831 - (530 + 181);
	local v97 = 893 - (614 + 267);
	local v98 = 32 - (19 + 13);
	local v99 = 0 - 0;
	local v100 = 0 - 0;
	local v101;
	local v102, v103;
	v11:RegisterForEvent(function()
		local v136 = 0 - 0;
		while true do
			if (((1075 + 3061) > (4215 - 1818)) and (v136 == (0 - 0))) then
				v86 = 12923 - (1293 + 519);
				v87 = 22669 - 11558;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v104 = v11.Commons.Everyone;
	local v105 = {{v61.AxeToss,"Cast Axe Toss (Interrupt)",function()
		return true;
	end}};
	v11:RegisterForEvent(function()
		v65 = v14:GetEquipment();
		v66 = (v65[7 + 6] and v20(v65[3 + 10])) or v20(0 - 0);
		v67 = (v65[4 + 10] and v20(v65[5 + 9])) or v20(0 + 0);
		v68 = v66:Level() or (1096 - (709 + 387));
		v69 = v67:Level() or (1858 - (673 + 1185));
		v70 = v66:OnUseSpell();
		v71 = v67:OnUseSpell();
		v72 = (v70 and (v70.MaximumRange > (0 - 0)) and (v70.MaximumRange <= (321 - 221)) and v70.MaximumRange) or (164 - 64);
		v73 = (v71 and (v71.MaximumRange > (0 + 0)) and (v71.MaximumRange <= (75 + 25)) and v71.MaximumRange) or (135 - 35);
		v72 = ((v66:ID() == v62.BelorrelostheSuncaller:ID()) and (3 + 7)) or v72;
		v73 = ((v67:ID() == v62.BelorrelostheSuncaller:ID()) and (19 - 9)) or v73;
		v74 = v66:HasUseBuff();
		v75 = v67:HasUseBuff();
		v76 = (v66:ID() == v62.RubyWhelpShell:ID()) or (v66:ID() == v62.WhisperingIncarnateIcon:ID()) or (v66:ID() == v62.TimeThiefsGambit:ID());
		v77 = (v67:ID() == v62.RubyWhelpShell:ID()) or (v67:ID() == v62.WhisperingIncarnateIcon:ID()) or (v67:ID() == v62.TimeThiefsGambit:ID());
		v78 = v66:ID() == v62.NymuesUnravelingSpindle:ID();
		v79 = v67:ID() == v62.NymuesUnravelingSpindle:ID();
		v80 = v66:BuffDuration() + (v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()) * (39 - 19)) + (v27(v66:ID() == v62.NymuesUnravelingSpindle:ID()) * (1882 - (446 + 1434)));
		v81 = v67:BuffDuration() + (v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID()) * (1303 - (1040 + 243))) + (v27(v67:ID() == v62.NymuesUnravelingSpindle:ID()) * (5 - 3));
		v82 = (v74 and (((v66:Cooldown() % (1937 - (559 + 1288))) == (1931 - (609 + 1322))) or (((544 - (13 + 441)) % v66:Cooldown()) == (0 - 0))) and (2 - 1)) or (0.5 - 0);
		v83 = (v75 and (((v67:Cooldown() % (4 + 86)) == (0 - 0)) or (((32 + 58) % v67:Cooldown()) == (0 + 0))) and (2 - 1)) or (0.5 + 0);
		v84 = (v71 and not v70 and (3 - 1)) or (1 + 0);
		v85 = (v71 and not v70 and (2 + 0)) or (1 + 0);
		if ((v70 and v71) or ((3640 + 694) == (4154 + 91))) then
			v84 = (not v74 and not v75 and (v69 > v68) and (435 - (153 + 280))) or (2 - 1);
			local v155 = ((v67:Cooldown() / v81) * v83 * ((1 + 0) - ((0.5 + 0) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 + 0);
			local v156 = ((v66:Cooldown() / v80) * v82 * ((1 + 0) - ((0.5 + 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * ((1 - 0) + ((v68 - v69) / (62 + 38)))) or (667 - (89 + 578));
			if ((not v74 and v75) or (v75 and (v155 > v156)) or ((3055 + 1221) <= (6301 - 3270))) then
				v85 = 1051 - (572 + 477);
			else
				v85 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		v61.HandofGuldan:RegisterInFlight();
		v88 = 9 + 5 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	end, "LEARNED_SPELL_IN_TAB");
	local function v106()
		return v11.GuardiansTable.ImpCount or (0 + 0);
	end
	local function v107(v137)
		local v138 = 86 - (84 + 2);
		for v152, v153 in pairs(v11.GuardiansTable.Pets) do
			if ((v153.ImpCasts <= v137) or ((7880 - 3098) <= (864 + 335))) then
				v138 = v138 + (843 - (497 + 345));
			end
		end
		return v138;
	end
	local function v108()
		return v11.GuardiansTable.FelGuardDuration or (0 + 0);
	end
	local function v109()
		return v108() > (0 + 0);
	end
	local function v110()
		return v11.GuardiansTable.DemonicTyrantDuration or (1333 - (605 + 728));
	end
	local function v111()
		return v110() > (0 + 0);
	end
	local function v112()
		return v11.GuardiansTable.DreadstalkerDuration or (0 - 0);
	end
	local function v113()
		return v112() > (0 + 0);
	end
	local function v114()
		return v11.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v115()
		return v114() > (0 + 0);
	end
	local function v116()
		return v11.GuardiansTable.PitLordDuration or (0 - 0);
	end
	local function v117()
		return v116() > (0 + 0);
	end
	local function v118(v139)
		return v139:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (492 - (457 + 32))));
	end
	local function v119(v140)
		return (v140:DebuffDown(v61.DoomBrandDebuff)) or (v103 < (2 + 2));
	end
	local function v120(v141)
		return (v141:DebuffRefreshable(v61.Doom));
	end
	local function v121(v142)
		return (v142:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v122(v143)
		return v143:DebuffRemains(v61.DoomBrandDebuff) > (1412 - (832 + 570));
	end
	local function v123()
		v97 = 12 + 0;
		v88 = 4 + 10 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
		v93 = 0 - 0;
		v94 = 0 + 0;
		if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v106(), 798 - (588 + 208))) <= (10 - 6)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (1803 - (884 + 916))))) or ((10182 - 5318) < (1103 + 799))) then
			if (((5492 - (232 + 421)) >= (5589 - (1569 + 320))) and v24(v61.PowerSiphon)) then
				return "power_siphon precombat 2";
			end
		end
		if ((v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) or ((264 + 811) > (365 + 1553))) then
			if (((1334 - 938) <= (4409 - (316 + 289))) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt precombat 3";
			end
		end
		if ((v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(2 - 1, v61.PowerSiphon)) or ((193 + 3976) == (3640 - (666 + 787)))) then
			if (((1831 - (360 + 65)) == (1314 + 92)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt precombat 4";
			end
		end
		if (((1785 - (79 + 175)) < (6734 - 2463)) and v61.ShadowBolt:IsReady()) then
			if (((496 + 139) == (1946 - 1311)) and v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
				return "shadow_bolt precombat 6";
			end
		end
	end
	local function v124()
		local v144 = 0 - 0;
		local v145;
		while true do
			if (((4272 - (503 + 396)) <= (3737 - (92 + 89))) and (v144 == (3 - 1))) then
				if ((not v115() and v61.SummonVilefiend:IsAvailable()) or not v113() or ((1688 + 1603) < (1942 + 1338))) then
					v89 = 0 - 0;
				end
				v90 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (5 + 25)) or v14:BuffUp(v61.NetherPortalBuff);
				v145 = v27(v61.SacrificedSouls:IsAvailable());
				v144 = 6 - 3;
			end
			if (((3827 + 559) >= (417 + 456)) and ((8 - 5) == v144)) then
				v91 = false;
				if (((115 + 806) <= (1679 - 577)) and (v103 > ((1245 - (485 + 759)) + v145))) then
					v91 = not v111();
				end
				if (((10889 - 6183) >= (2152 - (442 + 747))) and (v103 > ((1137 - (832 + 303)) + v145)) and (v103 < ((951 - (88 + 858)) + v145))) then
					v91 = v110() < (2 + 4);
				end
				v144 = 4 + 0;
			end
			if ((v144 == (1 + 0)) or ((1749 - (766 + 23)) <= (4324 - 3448))) then
				if ((v115() and v113()) or ((2824 - 758) == (2455 - 1523))) then
					v89 = v30(v114(), v112()) - (v14:GCD() * (0.5 - 0));
				end
				if (((5898 - (1036 + 37)) < (3434 + 1409)) and not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v113()) then
					v89 = v30(v112(), v108()) - (v14:GCD() * (0.5 - 0));
				end
				if ((not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(24 + 6, 1482 - (641 + 839))) and v113()) or ((4790 - (910 + 3)) >= (11566 - 7029))) then
					v89 = v112() - (v14:GCD() * (1684.5 - (1466 + 218)));
				end
				v144 = 1 + 1;
			end
			if ((v144 == (1152 - (556 + 592))) or ((1535 + 2780) < (2534 - (329 + 479)))) then
				if ((v103 > ((858 - (174 + 680)) + v145)) or ((12641 - 8962) < (1295 - 670))) then
					v91 = v110() < (6 + 2);
				end
				v92 = (v61.SummonDemonicTyrant:CooldownRemains() < (759 - (396 + 343))) and (v96 < (2 + 18)) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (1479 - (29 + 1448))) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (1394 - (135 + 1254)))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (18 - 13)));
				break;
			end
			if ((v144 == (0 - 0)) or ((3083 + 1542) < (2159 - (389 + 1138)))) then
				if ((((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (577 - (102 + 472))) and v61.NetherPortal:IsAvailable()) or (v87 < (19 + 1)) or (v111() and (v87 < (56 + 44))) or (v87 < (24 + 1)) or v111() or (not v61.SummonDemonicTyrant:IsAvailable() and v113())) and (v95 <= (1545 - (320 + 1225)))) or ((147 - 64) > (1090 + 690))) then
					v94 = (1584 - (157 + 1307)) + v99;
				end
				v95 = v94 - v99;
				if (((2405 - (821 + 1038)) <= (2686 - 1609)) and (((((v87 + v99) % (14 + 106)) <= (150 - 65)) and (((v87 + v99) % (45 + 75)) >= (61 - 36))) or (v99 >= (1236 - (834 + 192)))) and (v95 > (0 + 0)) and not v61.GrandWarlocksDesign:IsAvailable()) then
					v96 = v95;
				else
					v96 = v61.SummonDemonicTyrant:CooldownRemains();
				end
				v144 = 1 + 0;
			end
		end
	end
	local function v125()
		local v146 = v104.HandleTopTrinket(v64, v33, 1 + 39, nil);
		if (v146 or ((1542 - 546) > (4605 - (300 + 4)))) then
			return v146;
		end
		local v146 = v104.HandleBottomTrinket(v64, v33, 11 + 29, nil);
		if (((10654 - 6584) > (1049 - (112 + 250))) and v146) then
			return v146;
		end
	end
	local function v126()
		if ((v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) or ((262 + 394) >= (8342 - 5012))) then
			if (v25(v63.TimebreachingTalon) or ((1428 + 1064) <= (174 + 161))) then
				return "timebreaching_talon items 2";
			end
		end
		if (((3233 + 1089) >= (1271 + 1291)) and (not v61.SummonDemonicTyrant:IsAvailable() or v14:BuffUp(v61.DemonicPowerBuff))) then
			local v157 = v125();
			if (v157 or ((2702 + 935) >= (5184 - (1001 + 413)))) then
				return v157;
			end
		end
	end
	local function v127()
		local v147 = 0 - 0;
		while true do
			if (((883 - (244 + 638)) == v147) or ((3072 - (627 + 66)) > (13640 - 9062))) then
				if (v61.Fireblood:IsCastable() or ((1085 - (512 + 90)) > (2649 - (1665 + 241)))) then
					if (((3171 - (373 + 344)) > (261 + 317)) and v25(v61.Fireblood, v34)) then
						return "fireblood ogcd 8";
					end
				end
				if (((247 + 683) < (11758 - 7300)) and v61.AncestralCall:IsCastable()) then
					if (((1119 - 457) <= (2071 - (35 + 1064))) and v24(v61.AncestralCall, v34)) then
						return "ancestral_call racials 8";
					end
				end
				break;
			end
			if (((3180 + 1190) == (9349 - 4979)) and (v147 == (0 + 0))) then
				if (v61.Berserking:IsCastable() or ((5998 - (298 + 938)) <= (2120 - (233 + 1026)))) then
					if (v25(v61.Berserking, v34) or ((3078 - (636 + 1030)) == (2181 + 2083))) then
						return "berserking ogcd 4";
					end
				end
				if (v61.BloodFury:IsCastable() or ((3095 + 73) < (640 + 1513))) then
					if (v25(v61.BloodFury, v34) or ((337 + 4639) < (1553 - (55 + 166)))) then
						return "blood_fury ogcd 6";
					end
				end
				v147 = 1 + 0;
			end
		end
	end
	local function v128()
		local v148 = 0 + 0;
		while true do
			if (((17674 - 13046) == (4925 - (36 + 261))) and (v148 == (0 - 0))) then
				if (((v89 > (1368 - (34 + 1334))) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100)) and (v94 <= (0 + 0))) or ((42 + 12) == (1678 - (1035 + 248)))) then
					v94 = (141 - (20 + 1)) + v99;
				end
				if (((43 + 39) == (401 - (134 + 185))) and v61.HandofGuldan:IsReady() and (v98 > (1133 - (549 + 584))) and (v89 > (v100 + v61.SummonDemonicTyrant:CastTime())) and (v89 < (v100 * (689 - (314 + 371))))) then
					if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((1994 - 1413) < (1250 - (478 + 490)))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((v89 > (0 + 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) or ((5781 - (786 + 386)) < (8081 - 5586))) then
					local v173 = v126();
					if (((2531 - (1055 + 324)) == (2492 - (1093 + 247))) and v173) then
						return v173;
					end
					local v173 = v127();
					if (((1685 + 211) <= (360 + 3062)) and v173) then
						return v173;
					end
					local v174 = v104.HandleDPSPotion();
					if (v174 or ((3930 - 2940) > (5497 - 3877))) then
						return v174;
					end
				end
				if ((v61.SummonDemonicTyrant:IsCastable() and (v89 > (0 - 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) or ((2203 - 1326) > (1671 + 3024))) then
					if (((10366 - 7675) >= (6379 - 4528)) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v148 = 1 + 0;
			end
			if ((v148 == (4 - 2)) or ((3673 - (364 + 324)) >= (13311 - 8455))) then
				if (((10260 - 5984) >= (397 + 798)) and v61.NetherPortal:IsReady() and (v98 == (20 - 15))) then
					if (((5175 - 1943) <= (14244 - 9554)) and v24(v61.NetherPortal, v55)) then
						return "nether_portal tyrant 16";
					end
				end
				if ((v61.SummonVilefiend:IsReady() and ((v98 == (1273 - (1249 + 19))) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (12 + 1)) and v90) or ((3487 - 2591) >= (4232 - (686 + 400)))) then
					if (((2402 + 659) >= (3187 - (73 + 156))) and v24(v61.SummonVilefiend)) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if (((16 + 3171) >= (1455 - (721 + 90))) and v61.CallDreadstalkers:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (1 + 29))) and (v14:BuffUp(v61.NetherPortalBuff) or v109() or (v98 == (16 - 11))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (481 - (224 + 246))) and v90) then
					if (((1042 - 398) <= (1295 - 591)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if (((174 + 784) > (23 + 924)) and v61.GrimoireFelguard:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (23 + 7))) and (v14:BuffUp(v61.NetherPortalBuff) or v113() or (v98 == (9 - 4))) and v90))) then
					if (((14948 - 10456) >= (3167 - (203 + 310))) and v24(v61.GrimoireFelguard, v53)) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v148 = 1996 - (1238 + 755);
			end
			if (((241 + 3201) >= (3037 - (709 + 825))) and (v148 == (1 - 0))) then
				if ((v61.Implosion:IsReady() and (v106() > (2 - 0)) and not v113() and not v109() and not v115() and ((v103 > (867 - (196 + 668))) or ((v103 > (7 - 5)) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(1 - 0, v61.Implosion)) or ((4003 - (171 + 662)) <= (1557 - (4 + 89)))) then
					if (v24(v61.Implosion, v54, nil, not v15:IsInRange(140 - 100)) or ((1747 + 3050) == (19273 - 14885))) then
						return "implosion tyrant 8";
					end
				end
				if (((217 + 334) <= (2167 - (35 + 1451))) and v61.ShadowBolt:IsReady() and v14:PrevGCDP(1454 - (28 + 1425), v61.GrimoireFelguard) and (v99 > (2023 - (941 + 1052))) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) then
					if (((3143 + 134) > (1921 - (822 + 692))) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if (((6702 - 2007) >= (667 + 748)) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (301 - (45 + 252))) and (not v115() or (not v61.SummonVilefiend:IsAvailable() and v112())) and v14:BuffDown(v61.NetherPortalBuff)) then
					if (v24(v61.PowerSiphon, v56) or ((3179 + 33) <= (325 + 619))) then
						return "power_siphon tyrant 12";
					end
				end
				if ((v61.ShadowBolt:IsReady() and not v115() and v14:BuffDown(v61.NetherPortalBuff) and not v113() and (v98 < ((12 - 7) - v14:BuffStack(v61.DemonicCoreBuff)))) or ((3529 - (114 + 319)) <= (2581 - 783))) then
					if (((4531 - 994) == (2255 + 1282)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v148 = 2 - 0;
			end
			if (((8039 - 4202) >= (3533 - (556 + 1407))) and (v148 == (1209 - (741 + 465)))) then
				if ((v61.HandofGuldan:IsReady() and (((v98 > (467 - (170 + 295))) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113())) and ((v98 > (2 + 0)) or (v114() < ((v100 * (2 + 0)) + ((4 - 2) / v14:SpellHaste()))))) or (not v113() and (v98 == (5 + 0))))) or ((1892 + 1058) == (2159 + 1653))) then
					if (((5953 - (957 + 273)) >= (620 + 1698)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if ((v61.Demonbolt:IsReady() and (v98 < (2 + 2)) and (v14:BuffStack(v61.DemonicCoreBuff) > (3 - 2)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113()) or not v23())) or ((5341 - 3314) > (8711 - 5859))) then
					if ((v61.DoomBrandDebuff:AuraActiveCount() == v103) or not v14:HasTier(153 - 122, 1782 - (389 + 1391)) or ((713 + 423) > (450 + 3867))) then
						if (((10809 - 6061) == (5699 - (783 + 168))) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt tyrant 26";
						end
					elseif (((12538 - 8802) <= (4663 + 77)) and v104.CastCycle(v61.Demonbolt, v102, v121, not v15:IsSpellInRange(v61.Demonbolt))) then
						return "demonbolt tyrant 27";
					end
				end
				if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (314 - (309 + 2))) and (v89 > (v61.SummonDemonicTyrant:ExecuteTime() + (v100 * (9 - 6))))) or (v89 == (1212 - (1090 + 122))))) or ((1100 + 2290) <= (10276 - 7216))) then
					if (v24(v61.PowerSiphon) or ((684 + 315) > (3811 - (628 + 490)))) then
						return "power_siphon tyrant 28";
					end
				end
				if (((84 + 379) < (1487 - 886)) and v61.ShadowBolt:IsCastable()) then
					if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((9976 - 7793) < (1461 - (431 + 343)))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
		end
	end
	local function v129()
		if (((9186 - 4637) == (13159 - 8610)) and v61.SummonDemonicTyrant:IsCastable() and (v87 < (16 + 4))) then
			if (((598 + 4074) == (6367 - (556 + 1139))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
				return "summon_demonic_tyrant fight_end 10";
			end
		end
		if ((v87 < (35 - (6 + 9))) or ((672 + 2996) < (203 + 192))) then
			local v158 = 169 - (28 + 141);
			while true do
				if ((v158 == (1 + 0)) or ((5142 - 976) == (323 + 132))) then
					if (v61.SummonVilefiend:IsReady() or ((5766 - (486 + 831)) == (6929 - 4266))) then
						if (v24(v61.SummonVilefiend) or ((15057 - 10780) < (565 + 2424))) then
							return "summon_vilefiend fight_end 6";
						end
					end
					break;
				end
				if ((v158 == (0 - 0)) or ((2133 - (668 + 595)) >= (3734 + 415))) then
					if (((446 + 1766) < (8680 - 5497)) and v61.GrimoireFelguard:IsReady() and v53) then
						if (((4936 - (23 + 267)) > (4936 - (1129 + 815))) and v24(v61.GrimoireFelguard)) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (((1821 - (371 + 16)) < (4856 - (1326 + 424))) and v61.CallDreadstalkers:IsReady()) then
						if (((1488 - 702) < (11046 - 8023)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					v158 = 119 - (88 + 30);
				end
			end
		end
		if ((v61.NetherPortal:IsReady() and v55 and (v87 < (801 - (720 + 51)))) or ((5432 - 2990) < (1850 - (421 + 1355)))) then
			if (((7481 - 2946) == (2228 + 2307)) and v24(v61.NetherPortal)) then
				return "nether_portal fight_end 8";
			end
		end
		if ((v61.DemonicStrength:IsCastable() and (v87 < (1093 - (286 + 797)))) or ((10999 - 7990) <= (3486 - 1381))) then
			if (((2269 - (397 + 42)) < (1146 + 2523)) and v24(v61.DemonicStrength, v52)) then
				return "demonic_strength fight_end 12";
			end
		end
		if ((v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (803 - (24 + 776))) and (v87 < (30 - 10))) or ((2215 - (222 + 563)) >= (7957 - 4345))) then
			if (((1932 + 751) >= (2650 - (23 + 167))) and v24(v61.PowerSiphon, v56)) then
				return "power_siphon fight_end 14";
			end
		end
		if ((v61.Implosion:IsReady() and v54 and (v87 < ((1800 - (690 + 1108)) * v100))) or ((651 + 1153) >= (2702 + 573))) then
			if (v24(v61.Implosion, nil, nil, not v15:IsInRange(888 - (40 + 808))) or ((234 + 1183) > (13877 - 10248))) then
				return "implosion fight_end 16";
			end
		end
	end
	local v130 = 0 + 0;
	local v131 = false;
	function UpdateLastMoveTime()
		if (((2537 + 2258) > (221 + 181)) and v14:IsMoving()) then
			if (((5384 - (47 + 524)) > (2314 + 1251)) and not v131) then
				v130 = GetTime();
				v131 = true;
			end
		else
			v131 = false;
		end
	end
	local function v132()
		if (((10693 - 6781) == (5848 - 1936)) and v14:AffectingCombat()) then
			local v159 = 0 - 0;
			while true do
				if (((4547 - (1165 + 561)) <= (144 + 4680)) and (v159 == (0 - 0))) then
					if (((664 + 1074) <= (2674 - (341 + 138))) and (v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) then
						if (((12 + 29) <= (6227 - 3209)) and v25(v61.DarkPact)) then
							return "dark_pact defensive 2";
						end
					end
					if (((2471 - (89 + 237)) <= (13202 - 9098)) and (v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) then
						if (((5660 - 2971) < (5726 - (581 + 300))) and v25(v61.DrainLife)) then
							return "drain_life defensive 2";
						end
					end
					v159 = 1221 - (855 + 365);
				end
				if ((v159 == (2 - 1)) or ((759 + 1563) > (3857 - (1030 + 205)))) then
					if (((v14:HealthPercentage() <= v46) and v61.HealthFunnel:IsCastable()) or ((4257 + 277) == (1937 + 145))) then
						if (v25(v61.HealthFunnel) or ((1857 - (156 + 130)) > (4242 - 2375))) then
							return "health_funnel defensive 2";
						end
					end
					if (((v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) or ((4472 - 1818) >= (6135 - 3139))) then
						if (((1049 + 2929) > (1227 + 877)) and v25(v61.UnendingResolve)) then
							return "unending_resolve defensive 2";
						end
					end
					break;
				end
			end
		end
	end
	local function v133()
		local v149 = 69 - (10 + 59);
		while true do
			if (((848 + 2147) > (7589 - 6048)) and (v149 == (1164 - (671 + 492)))) then
				v33 = EpicSettings.Toggles['cds'];
				if (((2587 + 662) > (2168 - (369 + 846))) and v32) then
					v102 = v15:GetEnemiesInSplashRange(3 + 5);
					v103 = v15:GetEnemiesInSplashRangeCount(7 + 1);
					v101 = v14:GetEnemiesInRange(1985 - (1036 + 909));
				else
					local v175 = 0 + 0;
					while true do
						if ((v175 == (0 - 0)) or ((3476 - (11 + 192)) > (2311 + 2262))) then
							v102 = {};
							v103 = 176 - (135 + 40);
							v175 = 2 - 1;
						end
						if ((v175 == (1 + 0)) or ((6941 - 3790) < (1924 - 640))) then
							v101 = {};
							break;
						end
					end
				end
				UpdateLastMoveTime();
				v149 = 178 - (50 + 126);
			end
			if ((v149 == (0 - 0)) or ((410 + 1440) == (2942 - (1233 + 180)))) then
				v60();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v149 = 970 - (522 + 447);
			end
			if (((2242 - (107 + 1314)) < (986 + 1137)) and (v149 == (5 - 3))) then
				if (((384 + 518) < (4617 - 2292)) and (v104.TargetIsValid() or v14:AffectingCombat())) then
					local v176 = 0 - 0;
					while true do
						if (((2768 - (716 + 1194)) <= (51 + 2911)) and ((1 + 0) == v176)) then
							if ((v87 == (11614 - (74 + 429))) or ((7612 - 3666) < (639 + 649))) then
								v87 = v11.FightRemains(v102, false);
							end
							v26.UpdatePetTable();
							v176 = 4 - 2;
						end
						if ((v176 == (3 + 0)) or ((9994 - 6752) == (1401 - 834))) then
							v98 = v14:SoulShardsP();
							v100 = v14:GCD() + (433.25 - (279 + 154));
							break;
						end
						if ((v176 == (778 - (454 + 324))) or ((667 + 180) >= (1280 - (12 + 5)))) then
							v86 = v11.BossFightRemains();
							v87 = v86;
							v176 = 1 + 0;
						end
						if (((4 - 2) == v176) or ((833 + 1420) == (2944 - (277 + 816)))) then
							v26.UpdateSoulShards();
							v99 = v11.CombatTime();
							v176 = 12 - 9;
						end
					end
				end
				if ((v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) or ((3270 - (1058 + 125)) > (445 + 1927))) then
					if (v25(v61.SummonPet, false, true) or ((5420 - (815 + 160)) < (17801 - 13652))) then
						return "summon_pet ooc";
					end
				end
				if ((v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) or ((4315 - 2497) == (21 + 64))) then
					if (((1841 - 1211) < (4025 - (41 + 1857))) and v25(v63.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v149 = 1896 - (1222 + 671);
			end
			if ((v149 == (7 - 4)) or ((2785 - 847) == (3696 - (229 + 953)))) then
				if (((6029 - (1111 + 663)) >= (1634 - (874 + 705))) and v36 and (v14:HealthPercentage() <= v38)) then
					local v177 = 0 + 0;
					while true do
						if (((2047 + 952) > (2402 - 1246)) and ((0 + 0) == v177)) then
							if (((3029 - (642 + 37)) > (264 + 891)) and (v37 == "Refreshing Healing Potion")) then
								if (((645 + 3384) <= (12184 - 7331)) and v62.RefreshingHealingPotion:IsReady()) then
									if (v25(v63.RefreshingHealingPotion) or ((970 - (233 + 221)) > (7940 - 4506))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3562 + 484) >= (4574 - (718 + 823))) and (v37 == "Dreamwalker's Healing Potion")) then
								if (v62.DreamwalkersHealingPotion:IsReady() or ((1711 + 1008) <= (2252 - (266 + 539)))) then
									if (v25(v63.RefreshingHealingPotion) or ((11704 - 7570) < (5151 - (636 + 589)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (v104.TargetIsValid() or ((388 - 224) >= (5743 - 2958))) then
					if ((not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) or ((417 + 108) == (767 + 1342))) then
						local v179 = v123();
						if (((1048 - (657 + 358)) == (87 - 54)) and v179) then
							return v179;
						end
					end
					if (((6957 - 3903) <= (5202 - (1151 + 36))) and not v14:IsCasting() and not v14:IsChanneling()) then
						local v180 = v104.Interrupt(v61.SpellLock, 39 + 1, true);
						if (((492 + 1379) < (10099 - 6717)) and v180) then
							return v180;
						end
						v180 = v104.Interrupt(v61.SpellLock, 1872 - (1552 + 280), true, v17, v63.SpellLockMouseover);
						if (((2127 - (64 + 770)) <= (1471 + 695)) and v180) then
							return v180;
						end
						v180 = v104.Interrupt(v61.AxeToss, 90 - 50, true);
						if (v180 or ((458 + 2121) < (1366 - (157 + 1086)))) then
							return v180;
						end
						v180 = v104.Interrupt(v61.AxeToss, 80 - 40, true, v17, v63.AxeTossMouseover);
						if (v180 or ((3705 - 2859) >= (3632 - 1264))) then
							return v180;
						end
						v180 = v104.InterruptWithStun(v61.AxeToss, 54 - 14, true);
						if (v180 or ((4831 - (599 + 220)) <= (6686 - 3328))) then
							return v180;
						end
						v180 = v104.InterruptWithStun(v61.AxeToss, 1971 - (1813 + 118), true, v17, v63.AxeTossMouseover);
						if (((1093 + 401) <= (4222 - (841 + 376))) and v180) then
							return v180;
						end
					end
					if ((v14:AffectingCombat() and v58) or ((4358 - 1247) == (496 + 1638))) then
						if (((6428 - 4073) == (3214 - (464 + 395))) and v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v131 and ((GetTime() - v130) >= (2 - 1)) and (v14:HealthPercentage() >= v59)) then
							if (v25(v61.BurningRush) or ((283 + 305) <= (1269 - (467 + 370)))) then
								return "burning_rush defensive 2";
							end
						elseif (((9913 - 5116) >= (2860 + 1035)) and v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v131 or (v14:HealthPercentage() <= v59))) then
							if (((12261 - 8684) == (559 + 3018)) and v25(v63.CancelBurningRush)) then
								return "burning_rush defensive 4";
							end
						end
					end
					local v178 = v132();
					if (((8826 - 5032) > (4213 - (150 + 370))) and v178) then
						return v178;
					end
					if ((v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) or ((2557 - (74 + 1208)) == (10084 - 5984))) then
						if (v25(v61.UnendingResolve) or ((7545 - 5954) >= (2548 + 1032))) then
							return "unending_resolve defensive";
						end
					end
					v124();
					if (((1373 - (14 + 376)) <= (3135 - 1327)) and (v111() or (v87 < (15 + 7)))) then
						local v181 = 0 + 0;
						local v182;
						while true do
							if ((v181 == (0 + 0)) or ((6299 - 4149) <= (901 + 296))) then
								v182 = v127();
								if (((3847 - (23 + 55)) >= (2779 - 1606)) and v182 and v34 and v33) then
									return v182;
								end
								break;
							end
						end
					end
					local v178 = v126();
					if (((991 + 494) == (1334 + 151)) and v178) then
						return v178;
					end
					if ((v87 < (46 - 16)) or ((1043 + 2272) <= (3683 - (652 + 249)))) then
						local v183 = 0 - 0;
						local v184;
						while true do
							if ((v183 == (1868 - (708 + 1160))) or ((2377 - 1501) >= (5403 - 2439))) then
								v184 = v129();
								if (v184 or ((2259 - (10 + 17)) > (561 + 1936))) then
									return v184;
								end
								break;
							end
						end
					end
					if ((v61.HandofGuldan:IsReady() and (v99 < (1732.5 - (1400 + 332))) and (((v87 % (182 - 87)) > (1948 - (242 + 1666))) or ((v87 % (41 + 54)) < (6 + 9))) and (v61.ReignofTyranny:IsAvailable() or (v103 > (2 + 0)))) or ((3050 - (850 + 90)) <= (580 - 248))) then
						if (((5076 - (360 + 1030)) > (2808 + 364)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((v61.SummonDemonicTyrant:CooldownRemains() < (42 - 27)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (6 - 1))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (1666 - (909 + 752)))) and ((v61.GrimoireFelguard:CooldownRemains() < (1233 - (109 + 1114))) or not v14:HasTier(54 - 24, 1 + 1)) and ((v96 < (257 - (6 + 236))) or (v87 < (26 + 14)) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (13 + 2)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (11 - 6))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (8 - 3))) and ((v61.GrimoireFelguard:CooldownRemains() < (1143 - (1076 + 57))) or not v14:HasTier(5 + 25, 691 - (579 + 110))) and ((v96 < (2 + 13)) or (v87 < (36 + 4)) or v14:PowerInfusionUp())) or ((2375 + 2099) < (1227 - (174 + 233)))) then
						local v185 = v128();
						if (((11952 - 7673) >= (5058 - 2176)) and v185) then
							return v185;
						end
					end
					if (((v61.SummonDemonicTyrant:CooldownRemains() < (7 + 8)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and (v109() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(1204 - (663 + 511), 2 + 0)))) and ((v96 < (4 + 11)) or v109() or (v87 < (123 - 83)) or v14:PowerInfusionUp())) or ((1229 + 800) >= (8289 - 4768))) then
						local v186 = 0 - 0;
						local v187;
						while true do
							if ((v186 == (0 + 0)) or ((3964 - 1927) >= (3309 + 1333))) then
								v187 = v128();
								if (((158 + 1562) < (5180 - (478 + 244))) and v187) then
									return v187;
								end
								break;
							end
						end
					end
					if ((v61.SummonDemonicTyrant:IsCastable() and v57 and (v115() or v109() or (v61.GrimoireFelguard:CooldownRemains() > (607 - (440 + 77))))) or ((199 + 237) > (11056 - 8035))) then
						if (((2269 - (655 + 901)) <= (158 + 689)) and v24(v61.SummonDemonicTyrant)) then
							return "summon_demonic_tyrant main 4";
						end
					end
					if (((1650 + 504) <= (2722 + 1309)) and v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (181 - 136))) then
						if (((6060 - (695 + 750)) == (15758 - 11143)) and v24(v61.SummonVilefiend)) then
							return "summon_vilefiend main 6";
						end
					end
					if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v100 * (2 - 0)))) and (v98 < (15 - 11))) or (v98 < ((355 - (285 + 66)) - (v27(v103 > (4 - 2)))))) and not v14:PrevGCDP(1311 - (682 + 628), v61.Demonbolt) and v14:HasTier(5 + 26, 301 - (176 + 123))) or ((1586 + 2204) == (363 + 137))) then
						if (((358 - (239 + 30)) < (61 + 160)) and v104.CastCycle(v61.Demonbolt, v102, v118, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 8";
						end
					end
					if (((1975 + 79) >= (2514 - 1093)) and v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime() + (8 - 5))))) and v14:HasTier(346 - (306 + 9), 6 - 4)) then
						if (((121 + 571) < (1877 + 1181)) and v24(v61.PowerSiphon, v56)) then
							return "power_siphon main 10";
						end
					end
					if ((v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v100)) or ((1567 + 1687) == (4732 - 3077))) then
						if (v24(v61.DemonicStrength, v52) or ((2671 - (1140 + 235)) == (3125 + 1785))) then
							return "demonic_strength main 12";
						end
					end
					if (((3089 + 279) == (865 + 2503)) and v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) then
						if (((2695 - (33 + 19)) < (1378 + 2437)) and v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(119 - 79))) then
							return "bilescourge_bombers main 14";
						end
					end
					if (((843 + 1070) > (966 - 473)) and v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v100) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) then
						if (((4459 + 296) > (4117 - (586 + 103))) and v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(4 + 36))) then
							return "guillotine main 16";
						end
					end
					if (((4251 - 2870) <= (3857 - (1309 + 179))) and v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (45 - 20)) or (v96 > (11 + 14)) or v14:BuffUp(v61.NetherPortalBuff))) then
						if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((13006 - 8163) == (3085 + 999))) then
							return "call_dreadstalkers main 18";
						end
					end
					if (((9919 - 5250) > (722 - 359)) and v61.Implosion:IsReady() and (v107(611 - (295 + 314)) > (0 - 0)) and v91 and not v14:PrevGCDP(1963 - (1300 + 662), v61.Implosion)) then
						if (v24(v61.Implosion, v54, nil, not v15:IsInRange(125 - 85)) or ((3632 - (1178 + 577)) >= (1630 + 1508))) then
							return "implosion main 20";
						end
					end
					if (((14018 - 9276) >= (5031 - (851 + 554))) and v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (9 + 1)) and (v103 > (2 - 1))) then
						if (v24(v61.SummonSoulkeeper) or ((9860 - 5320) == (1218 - (115 + 187)))) then
							return "soul_strike main 22";
						end
					end
					if ((v61.HandofGuldan:IsReady() and (((v98 > (2 + 0)) and (v61.CallDreadstalkers:CooldownRemains() > (v100 * (4 + 0))) and (v61.SummonDemonicTyrant:CooldownRemains() > (66 - 49))) or (v98 == (1166 - (160 + 1001))) or ((v98 == (4 + 0)) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v100 * (2 + 0))))) and (v103 == (1 - 0)) and v61.GrandWarlocksDesign:IsAvailable()) or ((1514 - (237 + 121)) > (5242 - (525 + 372)))) then
						if (((4241 - 2004) < (13960 - 9711)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
							return "hand_of_guldan main 26";
						end
					end
					if ((v61.HandofGuldan:IsReady() and (v98 > (144 - (96 + 46))) and not ((v103 == (778 - (643 + 134))) and v61.GrandWarlocksDesign:IsAvailable())) or ((969 + 1714) < (54 - 31))) then
						if (((2587 - 1890) <= (793 + 33)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
							return "hand_of_guldan main 28";
						end
					end
					if (((2168 - 1063) <= (2403 - 1227)) and v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (720 - (316 + 403))) and (((v98 < (3 + 1)) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v100 * (5 - 3))) or (v98 < (1 + 1))) and not v92) then
						if (((8509 - 5130) <= (2702 + 1110)) and v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 30";
						end
					end
					if ((v61.Demonbolt:IsReady() and v14:HasTier(10 + 21, 6 - 4) and v14:BuffUp(v61.DemonicCoreBuff) and (v98 < (19 - 15)) and not v92) or ((1636 - 848) >= (93 + 1523))) then
						if (((3649 - 1795) <= (166 + 3213)) and v104.CastTargetIf(v61.Demonbolt, v102, "==", v119, v122, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 32";
						end
					end
					if (((13383 - 8834) == (4566 - (12 + 5))) and v61.Demonbolt:IsReady() and (v87 < (v14:BuffStack(v61.DemonicCoreBuff) * v100))) then
						if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((11737 - 8715) >= (6451 - 3427))) then
							return "demonbolt main 34";
						end
					end
					if (((10245 - 5425) > (5450 - 3252)) and v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (1 + 3)) and (v98 < (1977 - (1656 + 317))) and not v92) then
						if (v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt)) or ((946 + 115) >= (3920 + 971))) then
							return "demonbolt main 36";
						end
					end
					if (((3626 - 2262) <= (22014 - 17541)) and v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) then
						if (v24(v61.PowerSiphon, v56) or ((3949 - (5 + 349)) <= (14 - 11))) then
							return "power_siphon main 38";
						end
					end
					if ((v61.SummonVilefiend:IsReady() and (v87 < (v61.SummonDemonicTyrant:CooldownRemains() + (1276 - (266 + 1005))))) or ((3079 + 1593) == (13143 - 9291))) then
						if (((2051 - 492) == (3255 - (561 + 1135))) and v24(v61.SummonVilefiend)) then
							return "summon_vilefiend main 40";
						end
					end
					if (v61.Doom:IsReady() or ((2282 - 530) <= (2590 - 1802))) then
						if (v104.CastCycle(v61.Doom, v101, v120, not v15:IsSpellInRange(v61.Doom)) or ((4973 - (507 + 559)) == (443 - 266))) then
							return "doom main 42";
						end
					end
					if (((10731 - 7261) > (943 - (212 + 176))) and v61.ShadowBolt:IsCastable()) then
						if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((1877 - (250 + 655)) == (1758 - 1113))) then
							return "shadow_bolt main 44";
						end
					end
				end
				break;
			end
		end
	end
	local function v134()
		v61.DoomBrandDebuff:RegisterAuraTracking();
		v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v11.SetAPL(464 - 198, v133, v134);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

