local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 197 - (153 + 44);
	local v7;
	while true do
		if ((v6 == (1 + 0)) or ((3946 + 430) <= (2265 - 784))) then
			return v7(v0, ...);
		end
		if ((v6 == (0 + 0)) or ((1447 + 1945) >= (16344 - 11603))) then
			v7 = v1[v5];
			if (((1723 + 1602) >= (2624 - (381 + 89))) and not v7) then
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
			if ((v135 == (9 - 3)) or ((2451 - (1074 + 82)) >= (7084 - 3851))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (1784 - (214 + 1570));
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (1455 - (990 + 465));
				break;
			end
			if (((1805 + 2572) > (715 + 927)) and (v135 == (0 + 0))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v135 = 1727 - (1668 + 58);
			end
			if (((5349 - (512 + 114)) > (3535 - 2179)) and (v135 == (8 - 4))) then
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v135 = 17 - 12;
			end
			if ((v135 == (3 + 2)) or ((775 + 3361) <= (2985 + 448))) then
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 - 0);
				v58 = EpicSettings.Settings['UseBurningRush'] or (1994 - (109 + 1885));
				v59 = EpicSettings.Settings['BurningRushHP'] or (1469 - (1269 + 200));
				v45 = EpicSettings.Settings['DrainLifeHP'] or (0 - 0);
				v135 = 821 - (98 + 717);
			end
			if (((5071 - (802 + 24)) <= (7985 - 3354)) and (v135 == (3 - 0))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (0 + 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 + 0);
				v52 = EpicSettings.Settings['DemonicStrength'];
				v135 = 1 + 3;
			end
			if (((923 + 3353) >= (10888 - 6974)) and ((6 - 4) == v135)) then
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v135 = 3 + 0;
			end
			if (((93 + 105) <= (5798 - (797 + 636))) and (v135 == (4 - 3))) then
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
	if (((6051 - (231 + 1038)) > (3897 + 779)) and v70 and v71) then
		v84 = (not v74 and not v75 and (v69 > v68) and (1164 - (171 + 991))) or (4 - 3);
		local v155 = ((v67:Cooldown() / v81) * v83 * ((2 - 1) - ((0.5 - 0) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 + 0);
		local v156 = ((v66:Cooldown() / v80) * v82 * ((3 - 2) - ((0.5 - 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * ((1 - 0) + ((v68 - v69) / (309 - 209)))) or (1248 - (111 + 1137));
		if (((5022 - (91 + 67)) > (6538 - 4341)) and ((not v74 and v75) or (v75 and (v155 > v156)))) then
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
			if ((v136 == (0 + 0)) or ((6507 - 2807) == (5198 - 2691))) then
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
		local v137 = 0 + 0;
		while true do
			if (((913 + 3561) >= (636 - 362)) and (v137 == (2 + 4))) then
				v81 = v67:BuffDuration() + (v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID()) * (7 + 13)) + (v27(v67:ID() == v62.NymuesUnravelingSpindle:ID()) * (2 + 0));
				v82 = (v74 and (((v66:Cooldown() % (1186 - (709 + 387))) == (1858 - (673 + 1185))) or (((261 - 171) % v66:Cooldown()) == (0 - 0))) and (1 - 0)) or (0.5 + 0);
				v83 = (v75 and (((v67:Cooldown() % (68 + 22)) == (0 - 0)) or (((23 + 67) % v67:Cooldown()) == (0 - 0))) and (1 - 0)) or (1880.5 - (446 + 1434));
				v137 = 1290 - (1040 + 243);
			end
			if ((v137 == (11 - 7)) or ((3741 - (559 + 1288)) <= (3337 - (609 + 1322)))) then
				v75 = v67:HasUseBuff();
				v76 = (v66:ID() == v62.RubyWhelpShell:ID()) or (v66:ID() == v62.WhisperingIncarnateIcon:ID()) or (v66:ID() == v62.TimeThiefsGambit:ID());
				v77 = (v67:ID() == v62.RubyWhelpShell:ID()) or (v67:ID() == v62.WhisperingIncarnateIcon:ID()) or (v67:ID() == v62.TimeThiefsGambit:ID());
				v137 = 459 - (13 + 441);
			end
			if (((5874 - 4302) >= (4010 - 2479)) and (v137 == (34 - 27))) then
				v84 = (v71 and not v70 and (1 + 1)) or (3 - 2);
				v85 = (v71 and not v70 and (1 + 1)) or (1 + 0);
				if ((v70 and v71) or ((13908 - 9221) < (2486 + 2056))) then
					local v186 = 0 - 0;
					local v187;
					local v188;
					while true do
						if (((2176 + 1115) > (928 + 739)) and (v186 == (1 + 0))) then
							v188 = ((v66:Cooldown() / v80) * v82 * ((1 + 0) - ((0.5 + 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * ((434 - (153 + 280)) + ((v68 - v69) / (288 - 188)))) or (0 + 0);
							if ((not v74 and v75) or (v75 and (v187 > v188)) or ((345 + 528) == (1065 + 969))) then
								v85 = 2 + 0;
							else
								v85 = 1 + 0;
							end
							break;
						end
						if ((v186 == (0 - 0)) or ((1741 + 1075) < (678 - (89 + 578)))) then
							v84 = (not v74 and not v75 and (v69 > v68) and (2 + 0)) or (1 - 0);
							v187 = ((v67:Cooldown() / v81) * v83 * ((1050 - (572 + 477)) - ((0.5 + 0) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 + 0);
							v186 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((3785 - (84 + 2)) < (7755 - 3049)) and (v137 == (0 + 0))) then
				v65 = v14:GetEquipment();
				v66 = (v65[855 - (497 + 345)] and v20(v65[1 + 12])) or v20(0 + 0);
				v67 = (v65[1347 - (605 + 728)] and v20(v65[10 + 4])) or v20(0 - 0);
				v137 = 1 + 0;
			end
			if (((9782 - 7136) >= (790 + 86)) and (v137 == (13 - 8))) then
				v78 = v66:ID() == v62.NymuesUnravelingSpindle:ID();
				v79 = v67:ID() == v62.NymuesUnravelingSpindle:ID();
				v80 = v66:BuffDuration() + (v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()) * (16 + 4)) + (v27(v66:ID() == v62.NymuesUnravelingSpindle:ID()) * (491 - (457 + 32)));
				v137 = 3 + 3;
			end
			if (((2016 - (832 + 570)) <= (3000 + 184)) and (v137 == (1 + 2))) then
				v72 = ((v66:ID() == v62.BelorrelostheSuncaller:ID()) and (35 - 25)) or v72;
				v73 = ((v67:ID() == v62.BelorrelostheSuncaller:ID()) and (5 + 5)) or v73;
				v74 = v66:HasUseBuff();
				v137 = 800 - (588 + 208);
			end
			if (((8425 - 5299) == (4926 - (884 + 916))) and (v137 == (1 - 0))) then
				v68 = v66:Level() or (0 + 0);
				v69 = v67:Level() or (653 - (232 + 421));
				v70 = v66:OnUseSpell();
				v137 = 1891 - (1569 + 320);
			end
			if ((v137 == (1 + 1)) or ((416 + 1771) >= (16693 - 11739))) then
				v71 = v67:OnUseSpell();
				v72 = (v70 and (v70.MaximumRange > (605 - (316 + 289))) and (v70.MaximumRange <= (261 - 161)) and v70.MaximumRange) or (5 + 95);
				v73 = (v71 and (v71.MaximumRange > (1453 - (666 + 787))) and (v71.MaximumRange <= (525 - (360 + 65))) and v71.MaximumRange) or (94 + 6);
				v137 = 257 - (79 + 175);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (0 + 0)) or ((11884 - 8007) == (6884 - 3309))) then
				v61.HandofGuldan:RegisterInFlight();
				v88 = (913 - (503 + 396)) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	local function v106()
		return v11.GuardiansTable.ImpCount or (181 - (92 + 89));
	end
	local function v107(v139)
		local v140 = 0 - 0;
		local v141;
		while true do
			if (((363 + 344) > (375 + 257)) and ((0 - 0) == v140)) then
				v141 = 0 + 0;
				for v171, v172 in pairs(v11.GuardiansTable.Pets) do
					if ((v172.ImpCasts <= v139) or ((1244 - 698) >= (2342 + 342))) then
						v141 = v141 + 1 + 0;
					end
				end
				v140 = 2 - 1;
			end
			if (((183 + 1282) <= (6558 - 2257)) and (v140 == (1245 - (485 + 759)))) then
				return v141;
			end
		end
	end
	local function v108()
		return v11.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v109()
		return v108() > (1189 - (442 + 747));
	end
	local function v110()
		return v11.GuardiansTable.DemonicTyrantDuration or (1135 - (832 + 303));
	end
	local function v111()
		return v110() > (946 - (88 + 858));
	end
	local function v112()
		return v11.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v113()
		return v112() > (0 + 0);
	end
	local function v114()
		return v11.GuardiansTable.VilefiendDuration or (0 + 0);
	end
	local function v115()
		return v114() > (789 - (766 + 23));
	end
	local function v116()
		return v11.GuardiansTable.PitLordDuration or (0 - 0);
	end
	local function v117()
		return v116() > (0 - 0);
	end
	local function v118(v142)
		return v142:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (7 - 4)));
	end
	local function v119(v143)
		return (v143:DebuffDown(v61.DoomBrandDebuff)) or (v103 < (13 - 9));
	end
	local function v120(v144)
		return (v144:DebuffRefreshable(v61.Doom));
	end
	local function v121(v145)
		return (v145:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v122(v146)
		return v146:DebuffRemains(v61.DoomBrandDebuff) > (1083 - (1036 + 37));
	end
	local function v123()
		v97 = 9 + 3;
		v88 = (26 - 12) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
		v93 = 0 + 0;
		v94 = 1480 - (641 + 839);
		if (((2617 - (910 + 3)) > (3632 - 2207)) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v106(), 1686 - (1466 + 218))) <= (2 + 2)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (1151 - (556 + 592))))) then
			if (v24(v61.PowerSiphon) or ((245 + 442) == (5042 - (329 + 479)))) then
				return "power_siphon precombat 2";
			end
		end
		if ((v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) or ((4184 - (174 + 680)) < (4909 - 3480))) then
			if (((2377 - 1230) >= (240 + 95)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
				return "demonbolt precombat 3";
			end
		end
		if (((4174 - (396 + 343)) > (186 + 1911)) and v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(1478 - (29 + 1448), v61.PowerSiphon)) then
			if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((5159 - (135 + 1254)) >= (15223 - 11182))) then
				return "demonbolt precombat 4";
			end
		end
		if (v61.ShadowBolt:IsReady() or ((17700 - 13909) <= (1074 + 537))) then
			if (v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((6105 - (389 + 1138)) <= (2582 - (102 + 472)))) then
				return "shadow_bolt precombat 6";
			end
		end
	end
	local function v124()
		if (((1062 + 63) <= (1152 + 924)) and ((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (3 + 0)) and v61.NetherPortal:IsAvailable()) or (v87 < (1565 - (320 + 1225))) or (v111() and (v87 < (178 - 78))) or (v87 < (16 + 9)) or v111() or (not v61.SummonDemonicTyrant:IsAvailable() and v113())) and (v95 <= (1464 - (157 + 1307)))) then
			v94 = (1979 - (821 + 1038)) + v99;
		end
		v95 = v94 - v99;
		if (((((((v87 + v99) % (299 - 179)) <= (10 + 75)) and (((v87 + v99) % (213 - 93)) >= (10 + 15))) or (v99 >= (520 - 310))) and (v95 > (1026 - (834 + 192))) and not v61.GrandWarlocksDesign:IsAvailable()) or ((48 + 695) >= (1130 + 3269))) then
			v96 = v95;
		else
			v96 = v61.SummonDemonicTyrant:CooldownRemains();
		end
		if (((25 + 1130) < (2591 - 918)) and v115() and v113()) then
			v89 = v30(v114(), v112()) - (v14:GCD() * (304.5 - (300 + 4)));
		end
		if ((not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v113()) or ((621 + 1703) <= (1513 - 935))) then
			v89 = v30(v112(), v108()) - (v14:GCD() * (362.5 - (112 + 250)));
		end
		if (((1502 + 2265) == (9437 - 5670)) and not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(18 + 12, 2 + 0)) and v113()) then
			v89 = v112() - (v14:GCD() * (0.5 + 0));
		end
		if (((2028 + 2061) == (3038 + 1051)) and ((not v115() and v61.SummonVilefiend:IsAvailable()) or not v113())) then
			v89 = 1414 - (1001 + 413);
		end
		v90 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (66 - 36)) or v14:BuffUp(v61.NetherPortalBuff);
		local v147 = v27(v61.SacrificedSouls:IsAvailable());
		v91 = false;
		if (((5340 - (244 + 638)) >= (2367 - (627 + 66))) and (v103 > ((2 - 1) + v147))) then
			v91 = not v111();
		end
		if (((1574 - (512 + 90)) <= (3324 - (1665 + 241))) and (v103 > ((719 - (373 + 344)) + v147)) and (v103 < (3 + 2 + v147))) then
			v91 = v110() < (2 + 4);
		end
		if ((v103 > ((10 - 6) + v147)) or ((8356 - 3418) < (5861 - (35 + 1064)))) then
			v91 = v110() < (6 + 2);
		end
		v92 = (v61.SummonDemonicTyrant:CooldownRemains() < (42 - 22)) and (v96 < (1 + 19)) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (1238 - (298 + 938))) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (1264 - (233 + 1026)))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (1671 - (636 + 1030))));
	end
	local function v125()
		local v148 = v104.HandleTopTrinket(v64, v33, 21 + 19, nil);
		if (v148 or ((2446 + 58) > (1267 + 2997))) then
			return v148;
		end
		local v148 = v104.HandleBottomTrinket(v64, v33, 3 + 37, nil);
		if (((2374 - (55 + 166)) == (418 + 1735)) and v148) then
			return v148;
		end
	end
	local function v126()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (0 - 0)) or ((804 - (36 + 261)) >= (4531 - 1940))) then
				if (((5849 - (34 + 1334)) == (1723 + 2758)) and v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) then
					if (v25(v63.TimebreachingTalon) or ((1809 + 519) < (1976 - (1035 + 248)))) then
						return "timebreaching_talon items 2";
					end
				end
				if (((4349 - (20 + 1)) == (2255 + 2073)) and (not v61.SummonDemonicTyrant:IsAvailable() or v14:BuffUp(v61.DemonicPowerBuff))) then
					local v189 = 319 - (134 + 185);
					local v190;
					while true do
						if (((2721 - (549 + 584)) >= (2017 - (314 + 371))) and (v189 == (0 - 0))) then
							v190 = v125();
							if (v190 or ((5142 - (478 + 490)) > (2251 + 1997))) then
								return v190;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		if (v61.Berserking:IsCastable() or ((5758 - (786 + 386)) <= (265 - 183))) then
			if (((5242 - (1055 + 324)) == (5203 - (1093 + 247))) and v25(v61.Berserking, v34)) then
				return "berserking ogcd 4";
			end
		end
		if (v61.BloodFury:IsCastable() or ((251 + 31) <= (5 + 37))) then
			if (((18298 - 13689) >= (2599 - 1833)) and v25(v61.BloodFury, v34)) then
				return "blood_fury ogcd 6";
			end
		end
		if (v61.Fireblood:IsCastable() or ((3277 - 2125) == (6251 - 3763))) then
			if (((1218 + 2204) > (12905 - 9555)) and v25(v61.Fireblood, v34)) then
				return "fireblood ogcd 8";
			end
		end
		if (((3022 - 2145) > (284 + 92)) and v61.AncestralCall:IsCastable()) then
			if (v24(v61.AncestralCall, v34) or ((7973 - 4855) <= (2539 - (364 + 324)))) then
				return "ancestral_call racials 8";
			end
		end
	end
	local function v128()
		local v150 = 0 - 0;
		while true do
			if ((v150 == (2 - 1)) or ((55 + 110) >= (14611 - 11119))) then
				if (((6323 - 2374) < (14748 - 9892)) and v61.Implosion:IsReady() and (v106() > (1270 - (1249 + 19))) and not v113() and not v109() and not v115() and ((v103 > (3 + 0)) or ((v103 > (7 - 5)) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(1087 - (686 + 400), v61.Implosion)) then
					if (v24(v61.Implosion, v54, nil, not v15:IsInRange(32 + 8)) or ((4505 - (73 + 156)) < (15 + 3001))) then
						return "implosion tyrant 8";
					end
				end
				if (((5501 - (721 + 90)) > (47 + 4078)) and v61.ShadowBolt:IsReady() and v14:PrevGCDP(3 - 2, v61.GrimoireFelguard) and (v99 > (500 - (224 + 246))) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) then
					if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((81 - 31) >= (1649 - 753))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if ((v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (1 + 3)) and (not v115() or (not v61.SummonVilefiend:IsAvailable() and v112())) and v14:BuffDown(v61.NetherPortalBuff)) or ((41 + 1673) >= (2173 + 785))) then
					if (v24(v61.PowerSiphon, v56) or ((2964 - 1473) < (2142 - 1498))) then
						return "power_siphon tyrant 12";
					end
				end
				if (((1217 - (203 + 310)) < (2980 - (1238 + 755))) and v61.ShadowBolt:IsReady() and not v115() and v14:BuffDown(v61.NetherPortalBuff) and not v113() and (v98 < ((1 + 4) - v14:BuffStack(v61.DemonicCoreBuff)))) then
					if (((5252 - (709 + 825)) > (3511 - 1605)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v150 = 2 - 0;
			end
			if ((v150 == (866 - (196 + 668))) or ((3782 - 2824) > (7529 - 3894))) then
				if (((4334 - (171 + 662)) <= (4585 - (4 + 89))) and v61.NetherPortal:IsReady() and (v98 == (17 - 12))) then
					if (v24(v61.NetherPortal, v55) or ((1254 + 2188) < (11191 - 8643))) then
						return "nether_portal tyrant 16";
					end
				end
				if (((1128 + 1747) >= (2950 - (35 + 1451))) and v61.SummonVilefiend:IsReady() and ((v98 == (1458 - (28 + 1425))) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (2006 - (941 + 1052))) and v90) then
					if (v24(v61.SummonVilefiend) or ((4600 + 197) >= (6407 - (822 + 692)))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v61.CallDreadstalkers:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (42 - 12))) and (v14:BuffUp(v61.NetherPortalBuff) or v109() or (v98 == (3 + 2))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (308 - (45 + 252))) and v90) or ((546 + 5) > (712 + 1356))) then
					if (((5144 - 3030) > (1377 - (114 + 319))) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v61.GrimoireFelguard:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (43 - 13))) and (v14:BuffUp(v61.NetherPortalBuff) or v113() or (v98 == (6 - 1))) and v90))) or ((1442 + 820) >= (4612 - 1516))) then
					if (v24(v61.GrimoireFelguard, v53) or ((4724 - 2469) >= (5500 - (556 + 1407)))) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v150 = 1209 - (741 + 465);
			end
			if ((v150 == (468 - (170 + 295))) or ((2022 + 1815) < (1200 + 106))) then
				if (((7263 - 4313) == (2446 + 504)) and v61.HandofGuldan:IsReady() and (((v98 > (2 + 0)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113())) and ((v98 > (2 + 0)) or (v114() < ((v100 * (1232 - (957 + 273))) + ((1 + 1) / v14:SpellHaste()))))) or (not v113() and (v98 == (3 + 2))))) then
					if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((17996 - 13273) < (8690 - 5392))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if (((3469 - 2333) >= (762 - 608)) and v61.Demonbolt:IsReady() and (v98 < (1784 - (389 + 1391))) and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113()) or not v23())) then
					if ((v61.DoomBrandDebuff:AuraActiveCount() == v103) or not v14:HasTier(4 + 27, 4 - 2) or ((1222 - (783 + 168)) > (15935 - 11187))) then
						if (((4663 + 77) >= (3463 - (309 + 2))) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt tyrant 26";
						end
					elseif (v104.CastCycle(v61.Demonbolt, v102, v121, not v15:IsSpellInRange(v61.Demonbolt)) or ((7916 - 5338) >= (4602 - (1090 + 122)))) then
						return "demonbolt tyrant 27";
					end
				end
				if (((14 + 27) <= (5578 - 3917)) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (3 + 0)) and (v89 > (v61.SummonDemonicTyrant:ExecuteTime() + (v100 * (1121 - (628 + 490)))))) or (v89 == (0 + 0)))) then
					if (((1487 - 886) < (16269 - 12709)) and v24(v61.PowerSiphon)) then
						return "power_siphon tyrant 28";
					end
				end
				if (((1009 - (431 + 343)) < (1386 - 699)) and v61.ShadowBolt:IsCastable()) then
					if (((13159 - 8610) > (911 + 242)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if ((v150 == (0 + 0)) or ((6369 - (556 + 1139)) < (4687 - (6 + 9)))) then
				if (((672 + 2996) < (2337 + 2224)) and (v89 > (169 - (28 + 141))) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100)) and (v94 <= (0 + 0))) then
					v94 = (148 - 28) + v99;
				end
				if ((v61.HandofGuldan:IsReady() and (v98 > (0 + 0)) and (v89 > (v100 + v61.SummonDemonicTyrant:CastTime())) and (v89 < (v100 * (1321 - (486 + 831))))) or ((1183 - 728) == (12691 - 9086))) then
					if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((504 + 2159) == (10472 - 7160))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((5540 - (668 + 595)) <= (4027 + 448)) and (v89 > (0 + 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) then
					local v191 = v126();
					if (v191 or ((2372 - 1502) == (1479 - (23 + 267)))) then
						return v191;
					end
					local v191 = v127();
					if (((3497 - (1129 + 815)) <= (3520 - (371 + 16))) and v191) then
						return v191;
					end
					local v192 = v104.HandleDPSPotion();
					if (v192 or ((3987 - (1326 + 424)) >= (6649 - 3138))) then
						return v192;
					end
				end
				if ((v61.SummonDemonicTyrant:IsCastable() and (v89 > (0 - 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) or ((1442 - (88 + 30)) > (3791 - (720 + 51)))) then
					if (v25(v61.SummonDemonicTyrant, nil, nil, v57) or ((6655 - 3663) == (3657 - (421 + 1355)))) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v150 = 1 - 0;
			end
		end
	end
	local function v129()
		local v151 = 0 + 0;
		while true do
			if (((4189 - (286 + 797)) > (5578 - 4052)) and (v151 == (0 - 0))) then
				if (((3462 - (397 + 42)) < (1209 + 2661)) and v61.SummonDemonicTyrant:IsCastable() and (v87 < (820 - (24 + 776)))) then
					if (((220 - 77) > (859 - (222 + 563))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
						return "summon_demonic_tyrant fight_end 10";
					end
				end
				if (((39 - 21) < (1521 + 591)) and (v87 < (210 - (23 + 167)))) then
					if (((2895 - (690 + 1108)) <= (588 + 1040)) and v61.GrimoireFelguard:IsReady() and v53) then
						if (((3820 + 810) == (5478 - (40 + 808))) and v24(v61.GrimoireFelguard)) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (((583 + 2957) > (10259 - 7576)) and v61.CallDreadstalkers:IsReady()) then
						if (((4582 + 212) >= (1733 + 1542)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					if (((814 + 670) == (2055 - (47 + 524))) and v61.SummonVilefiend:IsReady()) then
						if (((930 + 502) < (9717 - 6162)) and v24(v61.SummonVilefiend)) then
							return "summon_vilefiend fight_end 6";
						end
					end
				end
				v151 = 1 - 0;
			end
			if ((v151 == (2 - 1)) or ((2791 - (1165 + 561)) > (107 + 3471))) then
				if ((v61.NetherPortal:IsReady() and v55 and (v87 < (92 - 62))) or ((1830 + 2965) < (1886 - (341 + 138)))) then
					if (((501 + 1352) < (9932 - 5119)) and v24(v61.NetherPortal)) then
						return "nether_portal fight_end 8";
					end
				end
				if ((v61.DemonicStrength:IsCastable() and (v87 < (336 - (89 + 237)))) or ((9075 - 6254) < (5117 - 2686))) then
					if (v24(v61.DemonicStrength, v52) or ((3755 - (581 + 300)) < (3401 - (855 + 365)))) then
						return "demonic_strength fight_end 12";
					end
				end
				v151 = 4 - 2;
			end
			if ((v151 == (1 + 1)) or ((3924 - (1030 + 205)) <= (323 + 20))) then
				if ((v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (3 + 0)) and (v87 < (306 - (156 + 130)))) or ((4246 - 2377) == (3385 - 1376))) then
					if (v24(v61.PowerSiphon, v56) or ((7262 - 3716) < (612 + 1710))) then
						return "power_siphon fight_end 14";
					end
				end
				if ((v61.Implosion:IsReady() and v54 and (v87 < ((2 + 0) * v100))) or ((2151 - (10 + 59)) == (1350 + 3423))) then
					if (((15975 - 12731) > (2218 - (671 + 492))) and v24(v61.Implosion, nil, nil, not v15:IsInRange(32 + 8))) then
						return "implosion fight_end 16";
					end
				end
				break;
			end
		end
	end
	local v130 = 1215 - (369 + 846);
	local v131 = false;
	function UpdateLastMoveTime()
		if (v14:IsMoving() or ((878 + 2435) <= (1518 + 260))) then
			if (not v131 or ((3366 - (1036 + 909)) >= (1673 + 431))) then
				local v173 = 0 - 0;
				while true do
					if (((2015 - (11 + 192)) <= (1642 + 1607)) and (v173 == (175 - (135 + 40)))) then
						v130 = GetTime();
						v131 = true;
						break;
					end
				end
			end
		else
			v131 = false;
		end
	end
	local function v132()
		if (((3932 - 2309) <= (1180 + 777)) and v14:AffectingCombat()) then
			local v158 = 0 - 0;
			while true do
				if (((6613 - 2201) == (4588 - (50 + 126))) and ((2 - 1) == v158)) then
					if (((388 + 1362) >= (2255 - (1233 + 180))) and (v14:HealthPercentage() <= v46) and v61.HealthFunnel:IsCastable()) then
						if (((5341 - (522 + 447)) > (3271 - (107 + 1314))) and v25(v61.HealthFunnel)) then
							return "health_funnel defensive 2";
						end
					end
					if (((108 + 124) < (2501 - 1680)) and (v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) then
						if (((221 + 297) < (1790 - 888)) and v25(v61.UnendingResolve)) then
							return "unending_resolve defensive 2";
						end
					end
					break;
				end
				if (((11846 - 8852) > (2768 - (716 + 1194))) and ((0 + 0) == v158)) then
					if (((v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) or ((403 + 3352) <= (1418 - (74 + 429)))) then
						if (((7612 - 3666) > (1856 + 1887)) and v25(v61.DarkPact)) then
							return "dark_pact defensive 2";
						end
					end
					if (((v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) or ((3055 - 1720) >= (2339 + 967))) then
						if (((14933 - 10089) > (5570 - 3317)) and v25(v61.DrainLife)) then
							return "drain_life defensive 2";
						end
					end
					v158 = 434 - (279 + 154);
				end
			end
		end
	end
	local function v133()
		v60();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		if (((1230 - (454 + 324)) == (356 + 96)) and v32) then
			local v159 = 17 - (12 + 5);
			while true do
				if ((v159 == (0 + 0)) or ((11611 - 7054) < (772 + 1315))) then
					v102 = v15:GetEnemiesInSplashRange(1101 - (277 + 816));
					v103 = v15:GetEnemiesInSplashRangeCount(34 - 26);
					v159 = 1184 - (1058 + 125);
				end
				if (((727 + 3147) == (4849 - (815 + 160))) and (v159 == (4 - 3))) then
					v101 = v14:GetEnemiesInRange(94 - 54);
					break;
				end
			end
		else
			v102 = {};
			v103 = 1 + 0;
			v101 = {};
		end
		UpdateLastMoveTime();
		if (v104.TargetIsValid() or v14:AffectingCombat() or ((5665 - 3727) > (6833 - (41 + 1857)))) then
			v86 = v11.BossFightRemains();
			v87 = v86;
			if ((v87 == (13004 - (1222 + 671))) or ((10997 - 6742) < (4919 - 1496))) then
				v87 = v11.FightRemains(v102, false);
			end
			v26.UpdatePetTable();
			v26.UpdateSoulShards();
			v99 = v11.CombatTime();
			v98 = v14:SoulShardsP();
			v100 = v14:GCD() + (1182.25 - (229 + 953));
		end
		if (((3228 - (1111 + 663)) <= (4070 - (874 + 705))) and v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) then
			if (v25(v61.SummonPet, false, true) or ((582 + 3575) <= (1913 + 890))) then
				return "summon_pet ooc";
			end
		end
		if (((10087 - 5234) >= (84 + 2898)) and v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) then
			if (((4813 - (642 + 37)) > (766 + 2591)) and v25(v63.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v36 and (v14:HealthPercentage() <= v38)) or ((547 + 2870) < (6361 - 3827))) then
			if ((v37 == "Refreshing Healing Potion") or ((3176 - (233 + 221)) <= (378 - 214))) then
				if (v62.RefreshingHealingPotion:IsReady() or ((2120 + 288) < (3650 - (718 + 823)))) then
					if (v25(v63.RefreshingHealingPotion) or ((21 + 12) == (2260 - (266 + 539)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v37 == "Dreamwalker's Healing Potion") or ((1253 - 810) >= (5240 - (636 + 589)))) then
				if (((8027 - 4645) > (341 - 175)) and v62.DreamwalkersHealingPotion:IsReady()) then
					if (v25(v63.RefreshingHealingPotion) or ((222 + 58) == (1112 + 1947))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (((2896 - (657 + 358)) > (3423 - 2130)) and v104.TargetIsValid()) then
			if (((5369 - 3012) == (3544 - (1151 + 36))) and not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) then
				local v174 = 0 + 0;
				local v175;
				while true do
					if (((33 + 90) == (367 - 244)) and (v174 == (1832 - (1552 + 280)))) then
						v175 = v123();
						if (v175 or ((1890 - (64 + 770)) >= (2303 + 1089))) then
							return v175;
						end
						break;
					end
				end
			end
			if ((not v14:IsCasting() and not v14:IsChanneling()) or ((2453 - 1372) < (191 + 884))) then
				local v176 = 1243 - (157 + 1086);
				local v177;
				while true do
					if ((v176 == (5 - 2)) or ((4594 - 3545) >= (6798 - 2366))) then
						if (v177 or ((6507 - 1739) <= (1665 - (599 + 220)))) then
							return v177;
						end
						v177 = v104.InterruptWithStun(v61.AxeToss, 79 - 39, true, v17, v63.AxeTossMouseover);
						if (v177 or ((5289 - (1813 + 118)) <= (1038 + 382))) then
							return v177;
						end
						break;
					end
					if ((v176 == (1219 - (841 + 376))) or ((5238 - 1499) <= (699 + 2306))) then
						v177 = v104.Interrupt(v61.AxeToss, 109 - 69, true, v17, v63.AxeTossMouseover);
						if (v177 or ((2518 - (464 + 395)) >= (5476 - 3342))) then
							return v177;
						end
						v177 = v104.InterruptWithStun(v61.AxeToss, 20 + 20, true);
						v176 = 840 - (467 + 370);
					end
					if ((v176 == (0 - 0)) or ((2394 + 866) < (8072 - 5717))) then
						v177 = v104.Interrupt(v61.SpellLock, 7 + 33, true);
						if (v177 or ((1556 - 887) == (4743 - (150 + 370)))) then
							return v177;
						end
						v177 = v104.Interrupt(v61.SpellLock, 1322 - (74 + 1208), true, v17, v63.SpellLockMouseover);
						v176 = 2 - 1;
					end
					if ((v176 == (4 - 3)) or ((1204 + 488) < (978 - (14 + 376)))) then
						if (v177 or ((8320 - 3523) < (2363 + 1288))) then
							return v177;
						end
						v177 = v104.Interrupt(v61.AxeToss, 36 + 4, true);
						if (v177 or ((3984 + 193) > (14211 - 9361))) then
							return v177;
						end
						v176 = 2 + 0;
					end
				end
			end
			if ((v14:AffectingCombat() and v58) or ((478 - (23 + 55)) > (2632 - 1521))) then
				if (((2036 + 1015) > (903 + 102)) and v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v131 and ((GetTime() - v130) >= (1 - 0)) and (v14:HealthPercentage() >= v59)) then
					if (((1162 + 2531) <= (5283 - (652 + 249))) and v25(v61.BurningRush)) then
						return "burning_rush defensive 2";
					end
				elseif ((v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v131 or (v14:HealthPercentage() <= v59))) or ((8782 - 5500) > (5968 - (708 + 1160)))) then
					if (v25(v63.CancelBurningRush) or ((9717 - 6137) < (5184 - 2340))) then
						return "burning_rush defensive 4";
					end
				end
			end
			local v160 = v132();
			if (((116 - (10 + 17)) < (1009 + 3481)) and v160) then
				return v160;
			end
			if ((v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) or ((6715 - (1400 + 332)) < (3467 - 1659))) then
				if (((5737 - (242 + 1666)) > (1613 + 2156)) and v25(v61.UnendingResolve)) then
					return "unending_resolve defensive";
				end
			end
			v124();
			if (((545 + 940) <= (2475 + 429)) and (v111() or (v87 < (962 - (850 + 90))))) then
				local v178 = 0 - 0;
				local v179;
				while true do
					if (((5659 - (360 + 1030)) == (3778 + 491)) and ((0 - 0) == v178)) then
						v179 = v127();
						if (((532 - 145) <= (4443 - (909 + 752))) and v179 and v34 and v33) then
							return v179;
						end
						break;
					end
				end
			end
			local v160 = v126();
			if (v160 or ((3122 - (109 + 1114)) <= (1678 - 761))) then
				return v160;
			end
			if ((v87 < (12 + 18)) or ((4554 - (6 + 236)) <= (552 + 324))) then
				local v180 = 0 + 0;
				local v181;
				while true do
					if (((5263 - 3031) <= (4534 - 1938)) and (v180 == (1133 - (1076 + 57)))) then
						v181 = v129();
						if (((345 + 1750) < (4375 - (579 + 110))) and v181) then
							return v181;
						end
						break;
					end
				end
			end
			if ((v61.HandofGuldan:IsReady() and (v99 < (0.5 + 0)) and (((v87 % (84 + 11)) > (22 + 18)) or ((v87 % (502 - (174 + 233))) < (41 - 26))) and (v61.ReignofTyranny:IsAvailable() or (v103 > (3 - 1)))) or ((710 + 885) >= (5648 - (663 + 511)))) then
				if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((4121 + 498) < (626 + 2256))) then
					return "hand_of_guldan main 2";
				end
			end
			if (((v61.SummonDemonicTyrant:CooldownRemains() < (46 - 31)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (4 + 1))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (11 - 6))) and ((v61.GrimoireFelguard:CooldownRemains() < (24 - 14)) or not v14:HasTier(15 + 15, 3 - 1)) and ((v96 < (11 + 4)) or (v87 < (4 + 36)) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (737 - (478 + 244))) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (522 - (440 + 77)))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (3 + 2))) and ((v61.GrimoireFelguard:CooldownRemains() < (36 - 26)) or not v14:HasTier(1586 - (655 + 901), 1 + 1)) and ((v96 < (12 + 3)) or (v87 < (28 + 12)) or v14:PowerInfusionUp())) or ((1184 - 890) >= (6276 - (695 + 750)))) then
				local v182 = 0 - 0;
				local v183;
				while true do
					if (((3130 - 1101) <= (12402 - 9318)) and (v182 == (351 - (285 + 66)))) then
						v183 = v128();
						if (v183 or ((4747 - 2710) == (3730 - (682 + 628)))) then
							return v183;
						end
						break;
					end
				end
			end
			if (((719 + 3739) > (4203 - (176 + 123))) and (v61.SummonDemonicTyrant:CooldownRemains() < (7 + 8)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and (v109() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(22 + 8, 271 - (239 + 30))))) and ((v96 < (5 + 10)) or v109() or (v87 < (39 + 1)) or v14:PowerInfusionUp())) then
				local v184 = 0 - 0;
				local v185;
				while true do
					if (((1359 - 923) >= (438 - (306 + 9))) and (v184 == (0 - 0))) then
						v185 = v128();
						if (((87 + 413) < (1115 + 701)) and v185) then
							return v185;
						end
						break;
					end
				end
			end
			if (((1721 + 1853) == (10220 - 6646)) and v61.SummonDemonicTyrant:IsCastable() and v57 and (v115() or v109() or (v61.GrimoireFelguard:CooldownRemains() > (1465 - (1140 + 235))))) then
				if (((141 + 80) < (358 + 32)) and v24(v61.SummonDemonicTyrant)) then
					return "summon_demonic_tyrant main 4";
				end
			end
			if ((v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (12 + 33))) or ((2265 - (33 + 19)) <= (514 + 907))) then
				if (((9165 - 6107) < (2141 + 2719)) and v24(v61.SummonVilefiend)) then
					return "summon_vilefiend main 6";
				end
			end
			if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v100 * (3 - 1)))) and (v98 < (4 + 0))) or (v98 < ((693 - (586 + 103)) - (v27(v103 > (1 + 1)))))) and not v14:PrevGCDP(2 - 1, v61.Demonbolt) and v14:HasTier(1519 - (1309 + 179), 2 - 0)) or ((565 + 731) >= (11939 - 7493))) then
				if (v104.CastCycle(v61.Demonbolt, v102, v118, not v15:IsSpellInRange(v61.Demonbolt)) or ((1053 + 340) > (9537 - 5048))) then
					return "demonbolt main 8";
				end
			end
			if ((v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime() + (5 - 2))))) and v14:HasTier(640 - (295 + 314), 4 - 2)) or ((6386 - (1300 + 662)) < (84 - 57))) then
				if (v24(v61.PowerSiphon, v56) or ((3752 - (1178 + 577)) > (1982 + 1833))) then
					return "power_siphon main 10";
				end
			end
			if (((10243 - 6778) > (3318 - (851 + 554))) and v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v100)) then
				if (((649 + 84) < (5044 - 3225)) and v24(v61.DemonicStrength, v52)) then
					return "demonic_strength main 12";
				end
			end
			if ((v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) or ((9545 - 5150) == (5057 - (115 + 187)))) then
				if (v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(31 + 9)) or ((3591 + 202) < (9335 - 6966))) then
					return "bilescourge_bombers main 14";
				end
			end
			if ((v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v100) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) or ((5245 - (160 + 1001)) == (232 + 33))) then
				if (((3007 + 1351) == (8921 - 4563)) and v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(398 - (237 + 121)))) then
					return "guillotine main 16";
				end
			end
			if ((v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (922 - (525 + 372))) or (v96 > (47 - 22)) or v14:BuffUp(v61.NetherPortalBuff))) or ((10310 - 7172) < (1135 - (96 + 46)))) then
				if (((4107 - (643 + 134)) > (839 + 1484)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
					return "call_dreadstalkers main 18";
				end
			end
			if ((v61.Implosion:IsReady() and (v107(4 - 2) > (0 - 0)) and v91 and not v14:PrevGCDP(1 + 0, v61.Implosion)) or ((7116 - 3490) == (8153 - 4164))) then
				if (v24(v61.Implosion, v54, nil, not v15:IsInRange(759 - (316 + 403))) or ((609 + 307) == (7343 - 4672))) then
					return "implosion main 20";
				end
			end
			if (((99 + 173) == (684 - 412)) and v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (8 + 2)) and (v103 > (1 + 0))) then
				if (((14722 - 10473) <= (23110 - 18271)) and v24(v61.SummonSoulkeeper)) then
					return "soul_strike main 22";
				end
			end
			if (((5768 - 2991) < (184 + 3016)) and v61.HandofGuldan:IsReady() and (((v98 > (3 - 1)) and (v61.CallDreadstalkers:CooldownRemains() > (v100 * (1 + 3))) and (v61.SummonDemonicTyrant:CooldownRemains() > (49 - 32))) or (v98 == (22 - (12 + 5))) or ((v98 == (15 - 11)) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v100 * (3 - 1))))) and (v103 == (1 - 0)) and v61.GrandWarlocksDesign:IsAvailable()) then
				if (((235 - 140) < (398 + 1559)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
					return "hand_of_guldan main 26";
				end
			end
			if (((2799 - (1656 + 317)) < (1531 + 186)) and v61.HandofGuldan:IsReady() and (v98 > (2 + 0)) and not ((v103 == (2 - 1)) and v61.GrandWarlocksDesign:IsAvailable())) then
				if (((7018 - 5592) >= (1459 - (5 + 349))) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
					return "hand_of_guldan main 28";
				end
			end
			if (((13081 - 10327) <= (4650 - (266 + 1005))) and v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (((v98 < (13 - 9)) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v100 * (2 - 0))) or (v98 < (1698 - (561 + 1135)))) and not v92) then
				if (v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt)) or ((5117 - 1190) == (4644 - 3231))) then
					return "demonbolt main 30";
				end
			end
			if ((v61.Demonbolt:IsReady() and v14:HasTier(1097 - (507 + 559), 4 - 2) and v14:BuffUp(v61.DemonicCoreBuff) and (v98 < (12 - 8)) and not v92) or ((1542 - (212 + 176)) <= (1693 - (250 + 655)))) then
				if (v104.CastTargetIf(v61.Demonbolt, v102, "==", v119, v122, not v15:IsSpellInRange(v61.Demonbolt)) or ((4480 - 2837) > (5903 - 2524))) then
					return "demonbolt main 32";
				end
			end
			if ((v61.Demonbolt:IsReady() and (v87 < (v14:BuffStack(v61.DemonicCoreBuff) * v100))) or ((4385 - 1582) > (6505 - (1869 + 87)))) then
				if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((763 - 543) >= (4923 - (484 + 1417)))) then
					return "demonbolt main 34";
				end
			end
			if (((6048 - 3226) == (4728 - 1906)) and v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (777 - (48 + 725))) and (v98 < (5 - 1)) and not v92) then
				if (v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt)) or ((2846 - 1785) == (1080 + 777))) then
					return "demonbolt main 36";
				end
			end
			if (((7375 - 4615) > (382 + 982)) and v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) then
				if (v24(v61.PowerSiphon, v56) or ((1429 + 3473) <= (4448 - (152 + 701)))) then
					return "power_siphon main 38";
				end
			end
			if ((v61.SummonVilefiend:IsReady() and (v87 < (v61.SummonDemonicTyrant:CooldownRemains() + (1316 - (430 + 881))))) or ((1476 + 2376) == (1188 - (557 + 338)))) then
				if (v24(v61.SummonVilefiend) or ((461 + 1098) == (12928 - 8340))) then
					return "summon_vilefiend main 40";
				end
			end
			if (v61.Doom:IsReady() or ((15701 - 11217) == (2093 - 1305))) then
				if (((9844 - 5276) >= (4708 - (499 + 302))) and v104.CastCycle(v61.Doom, v101, v120, not v15:IsSpellInRange(v61.Doom))) then
					return "doom main 42";
				end
			end
			if (((2112 - (39 + 827)) < (9579 - 6109)) and v61.ShadowBolt:IsCastable()) then
				if (((9084 - 5016) >= (3860 - 2888)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
					return "shadow_bolt main 44";
				end
			end
		end
	end
	local function v134()
		v61.DoomBrandDebuff:RegisterAuraTracking();
		v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
	end
	v11.SetAPL(407 - 141, v133, v134);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

