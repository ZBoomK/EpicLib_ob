local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 683 - (27 + 656);
	local v7;
	while true do
		if ((v6 == (0 + 0)) or ((496 + 860) == (1966 + 1586))) then
			v7 = v1[v5];
			if (((728 + 3408) >= (4438 - 2041)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1912 - (340 + 1571);
		end
		if ((v6 == (1 + 0)) or ((6106 - (1733 + 39)) == (11664 - 7419))) then
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
		local v135 = 1034 - (125 + 909);
		while true do
			if ((v135 == (1954 - (1096 + 852))) or ((1919 + 2357) <= (4328 - 1297))) then
				v55 = EpicSettings.Settings['NetherPortal'];
				v56 = EpicSettings.Settings['PowerSiphon'];
				v57 = EpicSettings.Settings['SummonDemonicTyrant'] or (0 + 0);
				v135 = 519 - (409 + 103);
			end
			if ((v135 == (241 - (46 + 190))) or ((4877 - (51 + 44)) <= (339 + 860))) then
				v52 = EpicSettings.Settings['DemonicStrength'];
				v53 = EpicSettings.Settings['GrimoireFelguard'];
				v54 = EpicSettings.Settings['Implosion'];
				v135 = 1323 - (1114 + 203);
			end
			if ((v135 == (727 - (228 + 498))) or ((1054 + 3810) < (1051 + 851))) then
				v37 = EpicSettings.Settings['HealingPotionName'] or (663 - (174 + 489));
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v39 = EpicSettings.Settings['UseHealthstone'] or (1905 - (830 + 1075));
				v135 = 526 - (303 + 221);
			end
			if (((6108 - (231 + 1038)) >= (3084 + 616)) and (v135 == (1169 - (171 + 991)))) then
				v58 = EpicSettings.Settings['UseBurningRush'] or (0 - 0);
				v59 = EpicSettings.Settings['BurningRushHP'] or (0 - 0);
				v45 = EpicSettings.Settings['DrainLifeHP'] or (0 - 0);
				v135 = 7 + 1;
			end
			if ((v135 == (13 - 9)) or ((3101 - 2026) > (3091 - 1173))) then
				v50 = EpicSettings.Settings['DemonboltOpener'];
				v51 = EpicSettings.Settings["Use Guillotine"] or (0 - 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (1248 - (111 + 1137));
				v135 = 163 - (91 + 67);
			end
			if (((1178 - 782) <= (950 + 2854)) and (v135 == (523 - (423 + 100)))) then
				v35 = EpicSettings.Settings['UseTrinkets'];
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v135 = 1 + 0;
			end
			if (((21 - 13) == v135) or ((2173 + 1996) == (2958 - (326 + 445)))) then
				v46 = EpicSettings.Settings['HealthFunnelHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UnendingResolveHP'] or (0 - 0);
				break;
			end
			if (((3281 - 1875) == (2117 - (530 + 181))) and (v135 == (884 - (614 + 267)))) then
				v43 = EpicSettings.Settings['InterruptThreshold'] or (32 - (19 + 13));
				v48 = EpicSettings.Settings['SummonPet'];
				v49 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v135 = 9 - 5;
			end
			if (((4373 - 2842) < (1110 + 3161)) and (v135 == (3 - 1))) then
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (1812 - (1293 + 519));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v135 = 7 - 4;
			end
		end
	end
	local v61 = v19.Warlock.Demonology;
	local v62 = v20.Warlock.Demonology;
	local v63 = v21.Warlock.Demonology;
	local v64 = {v62.MirrorofFracturedTomorrows:ID(),v62.NymuesUnravelingSpindle:ID(),v62.TimeThiefsGambit:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[7 + 6] and v20(v65[3 + 10])) or v20(0 - 0);
	local v67 = (v65[4 + 10] and v20(v65[5 + 9])) or v20(0 + 0);
	local v68 = v66:Level() or (1096 - (709 + 387));
	local v69 = v67:Level() or (1858 - (673 + 1185));
	local v70 = v66:OnUseSpell();
	local v71 = v67:OnUseSpell();
	local v72 = (v70 and (v70.MaximumRange > (0 - 0)) and (v70.MaximumRange <= (321 - 221)) and v70.MaximumRange) or (164 - 64);
	local v73 = (v71 and (v71.MaximumRange > (0 + 0)) and (v71.MaximumRange <= (75 + 25)) and v71.MaximumRange) or (135 - 35);
	v72 = ((v66:ID() == v62.BelorrelostheSuncaller:ID()) and (3 + 7)) or v72;
	v73 = ((v67:ID() == v62.BelorrelostheSuncaller:ID()) and (19 - 9)) or v73;
	local v74 = v66:HasUseBuff();
	local v75 = v67:HasUseBuff();
	local v76 = (v66:ID() == v62.RubyWhelpShell:ID()) or (v66:ID() == v62.WhisperingIncarnateIcon:ID()) or (v66:ID() == v62.TimeThiefsGambit:ID());
	local v77 = (v67:ID() == v62.RubyWhelpShell:ID()) or (v67:ID() == v62.WhisperingIncarnateIcon:ID()) or (v67:ID() == v62.TimeThiefsGambit:ID());
	local v78 = v66:ID() == v62.NymuesUnravelingSpindle:ID();
	local v79 = v67:ID() == v62.NymuesUnravelingSpindle:ID();
	local v80 = v66:BuffDuration() + (v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()) * (39 - 19)) + (v27(v66:ID() == v62.NymuesUnravelingSpindle:ID()) * (1882 - (446 + 1434)));
	local v81 = v67:BuffDuration() + (v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID()) * (1303 - (1040 + 243))) + (v27(v67:ID() == v62.NymuesUnravelingSpindle:ID()) * (5 - 3));
	local v82 = (v74 and (((v66:Cooldown() % (1937 - (559 + 1288))) == (1931 - (609 + 1322))) or (((544 - (13 + 441)) % v66:Cooldown()) == (0 - 0))) and (2 - 1)) or (0.5 - 0);
	local v83 = (v75 and (((v67:Cooldown() % (4 + 86)) == (0 - 0)) or (((32 + 58) % v67:Cooldown()) == (0 + 0))) and (2 - 1)) or (0.5 + 0);
	local v84 = (v71 and not v70 and (3 - 1)) or (1 + 0);
	local v85 = (v71 and not v70 and (2 + 0)) or (1 + 0);
	if (((534 + 101) == (622 + 13)) and v70 and v71) then
		local v156 = 433 - (153 + 280);
		local v157;
		local v158;
		while true do
			if (((9739 - 6366) <= (3193 + 363)) and (v156 == (1 + 0))) then
				v158 = ((v66:Cooldown() / v80) * v82 * ((1 + 0) - ((0.5 + 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * (1 + 0 + ((v68 - v69) / (152 - 52)))) or (0 + 0);
				if ((not v74 and v75) or (v75 and (v157 > v158)) or ((3958 - (89 + 578)) < (2344 + 936))) then
					v85 = 3 - 1;
				else
					v85 = 1050 - (572 + 477);
				end
				break;
			end
			if (((592 + 3794) >= (524 + 349)) and ((0 + 0) == v156)) then
				v84 = (not v74 and not v75 and (v69 > v68) and (88 - (84 + 2))) or (1 - 0);
				v157 = ((v67:Cooldown() / v81) * v83 * ((1 + 0) - ((842.5 - (497 + 345)) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 + 0);
				v156 = 1 + 0;
			end
		end
	end
	local v86 = 12444 - (605 + 728);
	local v87 = 7928 + 3183;
	local v88 = (30 - 16) + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	local v89 = 0 + 0;
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = 0 - 0;
	local v94 = 0 + 0;
	local v95 = 0 - 0;
	local v96 = 91 + 29;
	local v97 = 501 - (457 + 32);
	local v98 = 0 + 0;
	local v99 = 1402 - (832 + 570);
	local v100 = 0 + 0;
	local v101;
	local v102, v103;
	v11:RegisterForEvent(function()
		local v136 = 0 + 0;
		while true do
			if (((3259 - 2338) <= (531 + 571)) and (v136 == (796 - (588 + 208)))) then
				v86 = 29946 - 18835;
				v87 = 12911 - (884 + 916);
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
			if (((895 + 3811) >= (3244 - 2281)) and ((605 - (316 + 289)) == v137)) then
				v65 = v14:GetEquipment();
				v66 = (v65[33 - 20] and v20(v65[1 + 12])) or v20(1453 - (666 + 787));
				v67 = (v65[439 - (360 + 65)] and v20(v65[14 + 0])) or v20(254 - (79 + 175));
				v68 = v66:Level() or (0 - 0);
				v137 = 1 + 0;
			end
			if ((v137 == (5 - 3)) or ((1848 - 888) <= (1775 - (503 + 396)))) then
				v73 = (v71 and (v71.MaximumRange > (181 - (92 + 89))) and (v71.MaximumRange <= (193 - 93)) and v71.MaximumRange) or (52 + 48);
				v72 = ((v66:ID() == v62.BelorrelostheSuncaller:ID()) and (6 + 4)) or v72;
				v73 = ((v67:ID() == v62.BelorrelostheSuncaller:ID()) and (39 - 29)) or v73;
				v74 = v66:HasUseBuff();
				v137 = 1 + 2;
			end
			if ((v137 == (8 - 4)) or ((1803 + 263) == (446 + 486))) then
				v79 = v67:ID() == v62.NymuesUnravelingSpindle:ID();
				v80 = v66:BuffDuration() + (v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()) * (60 - 40)) + (v27(v66:ID() == v62.NymuesUnravelingSpindle:ID()) * (1 + 1));
				v81 = v67:BuffDuration() + (v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID()) * (30 - 10)) + (v27(v67:ID() == v62.NymuesUnravelingSpindle:ID()) * (1246 - (485 + 759)));
				v82 = (v74 and (((v66:Cooldown() % (208 - 118)) == (1189 - (442 + 747))) or (((1225 - (832 + 303)) % v66:Cooldown()) == (946 - (88 + 858)))) and (1 + 0)) or (0.5 + 0);
				v137 = 1 + 4;
			end
			if (((5614 - (766 + 23)) < (23908 - 19065)) and (v137 == (3 - 0))) then
				v75 = v67:HasUseBuff();
				v76 = (v66:ID() == v62.RubyWhelpShell:ID()) or (v66:ID() == v62.WhisperingIncarnateIcon:ID()) or (v66:ID() == v62.TimeThiefsGambit:ID());
				v77 = (v67:ID() == v62.RubyWhelpShell:ID()) or (v67:ID() == v62.WhisperingIncarnateIcon:ID()) or (v67:ID() == v62.TimeThiefsGambit:ID());
				v78 = v66:ID() == v62.NymuesUnravelingSpindle:ID();
				v137 = 10 - 6;
			end
			if ((v137 == (3 - 2)) or ((4950 - (1036 + 37)) >= (3217 + 1320))) then
				v69 = v67:Level() or (0 - 0);
				v70 = v66:OnUseSpell();
				v71 = v67:OnUseSpell();
				v72 = (v70 and (v70.MaximumRange > (0 + 0)) and (v70.MaximumRange <= (1580 - (641 + 839))) and v70.MaximumRange) or (1013 - (910 + 3));
				v137 = 4 - 2;
			end
			if ((v137 == (1689 - (1466 + 218))) or ((1984 + 2331) < (2874 - (556 + 592)))) then
				v83 = (v75 and (((v67:Cooldown() % (33 + 57)) == (808 - (329 + 479))) or (((944 - (174 + 680)) % v67:Cooldown()) == (0 - 0))) and (1 - 0)) or (0.5 + 0);
				v84 = (v71 and not v70 and (741 - (396 + 343))) or (1 + 0);
				v85 = (v71 and not v70 and (1479 - (29 + 1448))) or (1390 - (135 + 1254));
				if ((v70 and v71) or ((13859 - 10180) < (2918 - 2293))) then
					local v180 = 0 + 0;
					local v181;
					local v182;
					while true do
						if ((v180 == (1528 - (389 + 1138))) or ((5199 - (102 + 472)) < (597 + 35))) then
							v182 = ((v66:Cooldown() / v80) * v82 * ((1 + 0) - ((0.5 + 0) * v27(v66:ID() == v62.MirrorofFracturedTomorrows:ID()))) * ((1546 - (320 + 1225)) + ((v68 - v69) / (178 - 78)))) or (0 + 0);
							if ((not v74 and v75) or (v75 and (v181 > v182)) or ((1547 - (157 + 1307)) > (3639 - (821 + 1038)))) then
								v85 = 4 - 2;
							else
								v85 = 1 + 0;
							end
							break;
						end
						if (((969 - 423) <= (401 + 676)) and (v180 == (0 - 0))) then
							v84 = (not v74 and not v75 and (v69 > v68) and (1028 - (834 + 192))) or (1 + 0);
							v181 = ((v67:Cooldown() / v81) * v83 * ((1 + 0) - ((0.5 + 0) * v27(v67:ID() == v62.MirrorofFracturedTomorrows:ID())))) or (0 - 0);
							v180 = 305 - (300 + 4);
						end
					end
				end
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		v61.HandofGuldan:RegisterInFlight();
		v88 = 4 + 10 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
	end, "LEARNED_SPELL_IN_TAB");
	v61.HandofGuldan:RegisterInFlight();
	local function v106()
		return v11.GuardiansTable.ImpCount or (0 - 0);
	end
	local function v107(v138)
		local v139 = 362 - (112 + 250);
		local v140;
		while true do
			if ((v139 == (0 + 0)) or ((2495 - 1499) > (2464 + 1837))) then
				v140 = 0 + 0;
				for v178, v179 in pairs(v11.GuardiansTable.Pets) do
					if (((3044 + 1026) > (341 + 346)) and (v179.ImpCasts <= v138)) then
						v140 = v140 + 1 + 0;
					end
				end
				v139 = 1415 - (1001 + 413);
			end
			if ((v139 == (2 - 1)) or ((1538 - (244 + 638)) >= (4023 - (627 + 66)))) then
				return v140;
			end
		end
	end
	local function v108()
		return v11.GuardiansTable.FelGuardDuration or (0 - 0);
	end
	local function v109()
		return v108() > (602 - (512 + 90));
	end
	local function v110()
		return v11.GuardiansTable.DemonicTyrantDuration or (1906 - (1665 + 241));
	end
	local function v111()
		return v110() > (717 - (373 + 344));
	end
	local function v112()
		return v11.GuardiansTable.DreadstalkerDuration or (0 + 0);
	end
	local function v113()
		return v112() > (0 + 0);
	end
	local function v114()
		return v11.GuardiansTable.VilefiendDuration or (0 - 0);
	end
	local function v115()
		return v114() > (0 - 0);
	end
	local function v116()
		return v11.GuardiansTable.PitLordDuration or (1099 - (35 + 1064));
	end
	local function v117()
		return v116() > (0 + 0);
	end
	local function v118(v141)
		return v141:DebuffDown(v61.DoomBrandDebuff) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) <= (6 - 3)));
	end
	local function v119(v142)
		return (v142:DebuffDown(v61.DoomBrandDebuff)) or (v103 < (1 + 3));
	end
	local function v120(v143)
		return (v143:DebuffRefreshable(v61.Doom));
	end
	local function v121(v144)
		return (v144:DebuffDown(v61.DoomBrandDebuff));
	end
	local function v122(v145)
		return v145:DebuffRemains(v61.DoomBrandDebuff) > (1246 - (298 + 938));
	end
	local function v123()
		local v146 = 1259 - (233 + 1026);
		while true do
			if ((v146 == (1666 - (636 + 1030))) or ((1275 + 1217) <= (328 + 7))) then
				v97 = 4 + 8;
				v88 = 1 + 13 + v27(v61.GrimoireFelguard:IsAvailable()) + v27(v61.SummonVilefiend:IsAvailable());
				v146 = 222 - (55 + 166);
			end
			if (((838 + 3484) >= (258 + 2304)) and (v146 == (11 - 8))) then
				if ((v61.Demonbolt:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and not v14:PrevGCDP(298 - (36 + 261), v61.PowerSiphon)) or ((6360 - 2723) >= (5138 - (34 + 1334)))) then
					if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((915 + 1464) > (3558 + 1020))) then
						return "demonbolt precombat 4";
					end
				end
				if (v61.ShadowBolt:IsReady() or ((1766 - (1035 + 248)) > (764 - (20 + 1)))) then
					if (((1279 + 1175) > (897 - (134 + 185))) and v24(v63.ShadowBoltPetAttack, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt precombat 6";
					end
				end
				break;
			end
			if (((2063 - (549 + 584)) < (5143 - (314 + 371))) and ((6 - 4) == v146)) then
				if (((1630 - (478 + 490)) <= (515 + 457)) and v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) + v29(v106(), 1174 - (786 + 386))) <= (12 - 8)) or (v14:BuffRemains(v61.DemonicCoreBuff) < (1382 - (1055 + 324))))) then
					if (((5710 - (1093 + 247)) == (3884 + 486)) and v24(v61.PowerSiphon)) then
						return "power_siphon precombat 2";
					end
				end
				if ((v61.Demonbolt:IsReady() and not v15:IsInBossList() and v14:BuffUp(v61.DemonicCoreBuff)) or ((501 + 4261) <= (3418 - 2557))) then
					if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((4791 - 3379) == (12132 - 7868))) then
						return "demonbolt precombat 3";
					end
				end
				v146 = 7 - 4;
			end
			if ((v146 == (1 + 0)) or ((12204 - 9036) < (7420 - 5267))) then
				v93 = 0 + 0;
				v94 = 0 - 0;
				v146 = 690 - (364 + 324);
			end
		end
	end
	local function v124()
		local v147 = 0 - 0;
		local v148;
		while true do
			if ((v147 == (2 - 1)) or ((1650 + 3326) < (5573 - 4241))) then
				if (((7411 - 2783) == (14055 - 9427)) and not v61.SummonVilefiend:IsAvailable() and v61.GrimoireFelguard:IsAvailable() and v113()) then
					v89 = v30(v112(), v108()) - (v14:GCD() * (1268.5 - (1249 + 19)));
				end
				if ((not v61.SummonVilefiend:IsAvailable() and (not v61.GrimoireFelguard:IsAvailable() or not v14:HasTier(28 + 2, 7 - 5)) and v113()) or ((1140 - (686 + 400)) == (310 + 85))) then
					v89 = v112() - (v14:GCD() * (229.5 - (73 + 156)));
				end
				if (((1 + 81) == (893 - (721 + 90))) and ((not v115() and v61.SummonVilefiend:IsAvailable()) or not v113())) then
					v89 = 0 + 0;
				end
				v90 = not v61.NetherPortal:IsAvailable() or (v61.NetherPortal:CooldownRemains() > (97 - 67)) or v14:BuffUp(v61.NetherPortalBuff);
				v147 = 472 - (224 + 246);
			end
			if ((v147 == (0 - 0)) or ((1069 - 488) < (52 + 230))) then
				if ((((v14:BuffUp(v61.NetherPortalBuff) and (v14:BuffRemains(v61.NetherPortalBuff) < (1 + 2)) and v61.NetherPortal:IsAvailable()) or (v87 < (15 + 5)) or (v111() and (v87 < (198 - 98))) or (v87 < (83 - 58)) or v111() or (not v61.SummonDemonicTyrant:IsAvailable() and v113())) and (v95 <= (513 - (203 + 310)))) or ((6602 - (1238 + 755)) < (175 + 2320))) then
					v94 = (1654 - (709 + 825)) + v99;
				end
				v95 = v94 - v99;
				if (((2122 - 970) == (1677 - 525)) and (((((v87 + v99) % (984 - (196 + 668))) <= (335 - 250)) and (((v87 + v99) % (248 - 128)) >= (858 - (171 + 662)))) or (v99 >= (303 - (4 + 89)))) and (v95 > (0 - 0)) and not v61.GrandWarlocksDesign:IsAvailable()) then
					v96 = v95;
				else
					v96 = v61.SummonDemonicTyrant:CooldownRemains();
				end
				if (((691 + 1205) <= (15030 - 11608)) and v115() and v113()) then
					v89 = v30(v114(), v112()) - (v14:GCD() * (0.5 + 0));
				end
				v147 = 1487 - (35 + 1451);
			end
			if ((v147 == (1455 - (28 + 1425))) or ((2983 - (941 + 1052)) > (1554 + 66))) then
				v148 = v27(v61.SacrificedSouls:IsAvailable());
				v91 = false;
				if ((v103 > ((1515 - (822 + 692)) + v148)) or ((1251 - 374) > (2212 + 2483))) then
					v91 = not v111();
				end
				if (((2988 - (45 + 252)) >= (1832 + 19)) and (v103 > (1 + 1 + v148)) and (v103 < ((12 - 7) + v148))) then
					v91 = v110() < (439 - (114 + 319));
				end
				v147 = 3 - 0;
			end
			if ((v147 == (3 - 0)) or ((1903 + 1082) >= (7234 - 2378))) then
				if (((8958 - 4682) >= (3158 - (556 + 1407))) and (v103 > ((1210 - (741 + 465)) + v148))) then
					v91 = v110() < (473 - (170 + 295));
				end
				v92 = (v61.SummonDemonicTyrant:CooldownRemains() < (11 + 9)) and (v96 < (19 + 1)) and ((v14:BuffStack(v61.DemonicCoreBuff) <= (4 - 2)) or v14:BuffDown(v61.DemonicCoreBuff)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (5 + 0))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (4 + 1)));
				break;
			end
		end
	end
	local function v125()
		local v149 = v104.HandleTopTrinket(v64, v33, 23 + 17, nil);
		if (((4462 - (957 + 273)) <= (1255 + 3435)) and v149) then
			return v149;
		end
		local v149 = v104.HandleBottomTrinket(v64, v33, 17 + 23, nil);
		if (v149 or ((3414 - 2518) >= (8290 - 5144))) then
			return v149;
		end
	end
	local function v126()
		if (((9349 - 6288) >= (14647 - 11689)) and v62.TimebreachingTalon:IsEquippedAndReady() and (v14:BuffUp(v61.DemonicPowerBuff) or (not v61.SummonDemonicTyrant:IsAvailable() and (v14:BuffUp(v61.NetherPortalBuff) or not v61.NetherPortal:IsAvailable())))) then
			if (((4967 - (389 + 1391)) >= (405 + 239)) and v25(v63.TimebreachingTalon)) then
				return "timebreaching_talon items 2";
			end
		end
		if (((68 + 576) <= (1602 - 898)) and (not v61.SummonDemonicTyrant:IsAvailable() or v14:BuffUp(v61.DemonicPowerBuff))) then
			local v160 = 951 - (783 + 168);
			local v161;
			while true do
				if (((3215 - 2257) > (932 + 15)) and (v160 == (311 - (309 + 2)))) then
					v161 = v125();
					if (((13794 - 9302) >= (3866 - (1090 + 122))) and v161) then
						return v161;
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v150 = 0 + 0;
		while true do
			if (((11559 - 8117) >= (1029 + 474)) and ((1118 - (628 + 490)) == v150)) then
				if (v61.Berserking:IsCastable() or ((569 + 2601) <= (3624 - 2160))) then
					if (v25(v61.Berserking, v34) or ((21922 - 17125) == (5162 - (431 + 343)))) then
						return "berserking ogcd 4";
					end
				end
				if (((1112 - 561) <= (1969 - 1288)) and v61.BloodFury:IsCastable()) then
					if (((2589 + 688) > (53 + 354)) and v25(v61.BloodFury, v34)) then
						return "blood_fury ogcd 6";
					end
				end
				v150 = 1696 - (556 + 1139);
			end
			if (((4710 - (6 + 9)) >= (260 + 1155)) and (v150 == (1 + 0))) then
				if (v61.Fireblood:IsCastable() or ((3381 - (28 + 141)) <= (366 + 578))) then
					if (v25(v61.Fireblood, v34) or ((3821 - 725) <= (1274 + 524))) then
						return "fireblood ogcd 8";
					end
				end
				if (((4854 - (486 + 831)) == (9204 - 5667)) and v61.AncestralCall:IsCastable()) then
					if (((13508 - 9671) >= (297 + 1273)) and v24(v61.AncestralCall, v34)) then
						return "ancestral_call racials 8";
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v151 = 0 - 0;
		while true do
			if (((1264 - (668 + 595)) == v151) or ((2655 + 295) == (769 + 3043))) then
				if (((12880 - 8157) >= (2608 - (23 + 267))) and v61.Implosion:IsReady() and (v106() > (1946 - (1129 + 815))) and not v113() and not v109() and not v115() and ((v103 > (390 - (371 + 16))) or ((v103 > (1752 - (1326 + 424))) and v61.GrandWarlocksDesign:IsAvailable())) and not v14:PrevGCDP(1 - 0, v61.Implosion)) then
					if (v24(v61.Implosion, v54, nil, not v15:IsInRange(146 - 106)) or ((2145 - (88 + 30)) > (3623 - (720 + 51)))) then
						return "implosion tyrant 8";
					end
				end
				if ((v61.ShadowBolt:IsReady() and v14:PrevGCDP(2 - 1, v61.GrimoireFelguard) and (v99 > (1806 - (421 + 1355))) and v14:BuffDown(v61.NetherPortalBuff) and v14:BuffDown(v61.DemonicCoreBuff)) or ((1873 - 737) > (2121 + 2196))) then
					if (((5831 - (286 + 797)) == (17356 - 12608)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 10";
					end
				end
				if (((6187 - 2451) <= (5179 - (397 + 42))) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (2 + 2)) and (not v115() or (not v61.SummonVilefiend:IsAvailable() and v112())) and v14:BuffDown(v61.NetherPortalBuff)) then
					if (v24(v61.PowerSiphon, v56) or ((4190 - (24 + 776)) <= (4714 - 1654))) then
						return "power_siphon tyrant 12";
					end
				end
				if ((v61.ShadowBolt:IsReady() and not v115() and v14:BuffDown(v61.NetherPortalBuff) and not v113() and (v98 < ((790 - (222 + 563)) - v14:BuffStack(v61.DemonicCoreBuff)))) or ((2200 - 1201) > (1939 + 754))) then
					if (((653 - (23 + 167)) < (2399 - (690 + 1108))) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 14";
					end
				end
				v151 = 1 + 1;
			end
			if ((v151 == (3 + 0)) or ((3031 - (40 + 808)) < (114 + 573))) then
				if (((17395 - 12846) == (4348 + 201)) and v61.HandofGuldan:IsReady() and (((v98 > (2 + 0)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113())) and ((v98 > (2 + 0)) or (v114() < ((v100 * (573 - (47 + 524))) + ((2 + 0) / v14:SpellHaste()))))) or (not v113() and (v98 == (13 - 8))))) then
					if (((6985 - 2313) == (10654 - 5982)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
						return "hand_of_guldan tyrant 24";
					end
				end
				if ((v61.Demonbolt:IsReady() and (v98 < (1730 - (1165 + 561))) and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and v113()) or not v23())) or ((11360 - 7692) < (151 + 244))) then
					if ((v61.DoomBrandDebuff:AuraActiveCount() == v103) or not v14:HasTier(510 - (341 + 138), 1 + 1) or ((8597 - 4431) == (781 - (89 + 237)))) then
						if (v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt)) or ((14312 - 9863) == (5606 - 2943))) then
							return "demonbolt tyrant 26";
						end
					elseif (v104.CastCycle(v61.Demonbolt, v102, v121, not v15:IsSpellInRange(v61.Demonbolt)) or ((5158 - (581 + 300)) < (4209 - (855 + 365)))) then
						return "demonbolt tyrant 27";
					end
				end
				if ((v61.PowerSiphon:IsReady() and v56 and (((v14:BuffStack(v61.DemonicCoreBuff) < (6 - 3)) and (v89 > (v61.SummonDemonicTyrant:ExecuteTime() + (v100 * (1 + 2))))) or (v89 == (1235 - (1030 + 205))))) or ((817 + 53) >= (3860 + 289))) then
					if (((2498 - (156 + 130)) < (7232 - 4049)) and v24(v61.PowerSiphon)) then
						return "power_siphon tyrant 28";
					end
				end
				if (((7830 - 3184) > (6127 - 3135)) and v61.ShadowBolt:IsCastable()) then
					if (((378 + 1056) < (1812 + 1294)) and v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt))) then
						return "shadow_bolt tyrant 30";
					end
				end
				break;
			end
			if (((855 - (10 + 59)) < (855 + 2168)) and (v151 == (0 - 0))) then
				if (((v89 > (1163 - (671 + 492))) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100)) and (v94 <= (0 + 0))) or ((3657 - (369 + 846)) < (20 + 54))) then
					v94 = 103 + 17 + v99;
				end
				if (((6480 - (1036 + 909)) == (3606 + 929)) and v61.HandofGuldan:IsReady() and (v98 > (0 - 0)) and (v89 > (v100 + v61.SummonDemonicTyrant:CastTime())) and (v89 < (v100 * (207 - (11 + 192))))) then
					if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((1521 + 1488) <= (2280 - (135 + 40)))) then
						return "hand_of_guldan tyrant 2";
					end
				end
				if (((4433 - 2603) < (2212 + 1457)) and (v89 > (0 - 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) then
					local v183 = 0 - 0;
					local v184;
					local v185;
					while true do
						if (((177 - (50 + 126)) == v183) or ((3981 - 2551) >= (800 + 2812))) then
							v184 = v127();
							if (((4096 - (1233 + 180)) >= (3429 - (522 + 447))) and v184) then
								return v184;
							end
							v183 = 1423 - (107 + 1314);
						end
						if ((v183 == (0 + 0)) or ((5496 - 3692) >= (1391 + 1884))) then
							v184 = v126();
							if (v184 or ((2813 - 1396) > (14358 - 10729))) then
								return v184;
							end
							v183 = 1911 - (716 + 1194);
						end
						if (((82 + 4713) > (44 + 358)) and (v183 == (505 - (74 + 429)))) then
							v185 = v104.HandleDPSPotion();
							if (((9284 - 4471) > (1767 + 1798)) and v185) then
								return v185;
							end
							break;
						end
					end
				end
				if (((8954 - 5042) == (2768 + 1144)) and v61.SummonDemonicTyrant:IsCastable() and (v89 > (0 - 0)) and (v89 < (v61.SummonDemonicTyrant:ExecuteTime() + (v27(v14:BuffDown(v61.DemonicCoreBuff)) * v61.ShadowBolt:ExecuteTime()) + (v27(v14:BuffUp(v61.DemonicCoreBuff)) * v100) + v100))) then
					if (((6974 - 4153) <= (5257 - (279 + 154))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
						return "summon_demonic_tyrant tyrant 6";
					end
				end
				v151 = 779 - (454 + 324);
			end
			if (((1368 + 370) <= (2212 - (12 + 5))) and (v151 == (2 + 0))) then
				if (((104 - 63) <= (1116 + 1902)) and v61.NetherPortal:IsReady() and (v98 == (1098 - (277 + 816)))) then
					if (((9165 - 7020) <= (5287 - (1058 + 125))) and v24(v61.NetherPortal, v55)) then
						return "nether_portal tyrant 16";
					end
				end
				if (((505 + 2184) < (5820 - (815 + 160))) and v61.SummonVilefiend:IsReady() and ((v98 == (21 - 16)) or v14:BuffUp(v61.NetherPortalBuff)) and (v61.SummonDemonicTyrant:CooldownRemains() < (30 - 17)) and v90) then
					if (v24(v61.SummonVilefiend) or ((554 + 1768) > (7664 - 5042))) then
						return "summon_vilefiend tyrant 18";
					end
				end
				if ((v61.CallDreadstalkers:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (1928 - (41 + 1857)))) and (v14:BuffUp(v61.NetherPortalBuff) or v109() or (v98 == (1898 - (1222 + 671)))))) and (v61.SummonDemonicTyrant:CooldownRemains() < (28 - 17)) and v90) or ((6517 - 1983) == (3264 - (229 + 953)))) then
					if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((3345 - (1111 + 663)) > (3446 - (874 + 705)))) then
						return "call_dreadstalkers tyrant 20";
					end
				end
				if ((v61.GrimoireFelguard:IsReady() and (v115() or (not v61.SummonVilefiend:IsAvailable() and (not v61.NetherPortal:IsAvailable() or v14:BuffUp(v61.NetherPortalBuff) or (v61.NetherPortal:CooldownRemains() > (5 + 25))) and (v14:BuffUp(v61.NetherPortalBuff) or v113() or (v98 == (4 + 1))) and v90))) or ((5516 - 2862) >= (85 + 2911))) then
					if (((4657 - (642 + 37)) > (480 + 1624)) and v24(v61.GrimoireFelguard, v53)) then
						return "grimoire_felguard tyrant 22";
					end
				end
				v151 = 1 + 2;
			end
		end
	end
	local function v129()
		if (((7519 - 4524) > (1995 - (233 + 221))) and v61.SummonDemonicTyrant:IsCastable() and (v87 < (46 - 26))) then
			if (((2860 + 389) > (2494 - (718 + 823))) and v25(v61.SummonDemonicTyrant, nil, nil, v57)) then
				return "summon_demonic_tyrant fight_end 10";
			end
		end
		if ((v87 < (13 + 7)) or ((4078 - (266 + 539)) > (12946 - 8373))) then
			local v162 = 1225 - (636 + 589);
			while true do
				if ((v162 == (2 - 1)) or ((6498 - 3347) < (1018 + 266))) then
					if (v61.SummonVilefiend:IsReady() or ((673 + 1177) == (2544 - (657 + 358)))) then
						if (((2173 - 1352) < (4836 - 2713)) and v24(v61.SummonVilefiend)) then
							return "summon_vilefiend fight_end 6";
						end
					end
					break;
				end
				if (((2089 - (1151 + 36)) < (2246 + 79)) and (v162 == (0 + 0))) then
					if (((2562 - 1704) <= (4794 - (1552 + 280))) and v61.GrimoireFelguard:IsReady() and v53) then
						if (v24(v61.GrimoireFelguard) or ((4780 - (64 + 770)) < (875 + 413))) then
							return "grimoire_felguard fight_end 2";
						end
					end
					if (v61.CallDreadstalkers:IsReady() or ((7359 - 4117) == (101 + 466))) then
						if (v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers)) or ((2090 - (157 + 1086)) >= (2527 - 1264))) then
							return "call_dreadstalkers fight_end 4";
						end
					end
					v162 = 4 - 3;
				end
			end
		end
		if ((v61.NetherPortal:IsReady() and v55 and (v87 < (46 - 16))) or ((3074 - 821) == (2670 - (599 + 220)))) then
			if (v24(v61.NetherPortal) or ((4155 - 2068) > (4303 - (1813 + 118)))) then
				return "nether_portal fight_end 8";
			end
		end
		if ((v61.DemonicStrength:IsCastable() and (v87 < (8 + 2))) or ((5662 - (841 + 376)) < (5813 - 1664))) then
			if (v24(v61.DemonicStrength, v52) or ((423 + 1395) == (232 - 147))) then
				return "demonic_strength fight_end 12";
			end
		end
		if (((1489 - (464 + 395)) < (5458 - 3331)) and v61.PowerSiphon:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) < (2 + 1)) and (v87 < (857 - (467 + 370)))) then
			if (v24(v61.PowerSiphon, v56) or ((4004 - 2066) == (1846 + 668))) then
				return "power_siphon fight_end 14";
			end
		end
		if (((14586 - 10331) >= (9 + 46)) and v61.Implosion:IsReady() and v54 and (v87 < ((4 - 2) * v100))) then
			if (((3519 - (150 + 370)) > (2438 - (74 + 1208))) and v24(v61.Implosion, nil, nil, not v15:IsInRange(98 - 58))) then
				return "implosion fight_end 16";
			end
		end
	end
	local v130 = 0 - 0;
	local v131 = false;
	function UpdateLastMoveTime()
		if (((1673 + 677) > (1545 - (14 + 376))) and v14:IsMoving()) then
			if (((6987 - 2958) <= (3141 + 1712)) and not v131) then
				v130 = GetTime();
				v131 = true;
			end
		else
			v131 = false;
		end
	end
	local function v132()
		if (v14:AffectingCombat() or ((454 + 62) > (3276 + 158))) then
			local v163 = 0 - 0;
			while true do
				if (((3044 + 1002) >= (3111 - (23 + 55))) and (v163 == (2 - 1))) then
					if (((v14:HealthPercentage() <= v46) and v61.HealthFunnel:IsCastable()) or ((1815 + 904) <= (1300 + 147))) then
						if (v25(v61.HealthFunnel) or ((6409 - 2275) < (1235 + 2691))) then
							return "health_funnel defensive 2";
						end
					end
					if (((v14:HealthPercentage() <= v47) and v61.UnendingResolve:IsCastable()) or ((1065 - (652 + 249)) >= (7453 - 4668))) then
						if (v25(v61.UnendingResolve) or ((2393 - (708 + 1160)) == (5724 - 3615))) then
							return "unending_resolve defensive 2";
						end
					end
					break;
				end
				if (((60 - 27) == (60 - (10 + 17))) and (v163 == (0 + 0))) then
					if (((4786 - (1400 + 332)) <= (7701 - 3686)) and (v14:HealthPercentage() <= v49) and v61.DarkPact:IsCastable() and not v14:BuffUp(v61.DarkPact)) then
						if (((3779 - (242 + 1666)) < (1448 + 1934)) and v25(v61.DarkPact)) then
							return "dark_pact defensive 2";
						end
					end
					if (((474 + 819) <= (1846 + 320)) and (v14:HealthPercentage() <= v45) and v61.DrainLife:IsCastable()) then
						if (v25(v61.DrainLife) or ((3519 - (850 + 90)) < (214 - 91))) then
							return "drain_life defensive 2";
						end
					end
					v163 = 1391 - (360 + 1030);
				end
			end
		end
	end
	local function v133()
		v60();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		if (v32 or ((749 + 97) >= (6683 - 4315))) then
			v102 = v15:GetEnemiesInSplashRange(10 - 2);
			v103 = v15:GetEnemiesInSplashRangeCount(1669 - (909 + 752));
			v101 = v14:GetEnemiesInRange(1263 - (109 + 1114));
		else
			v102 = {};
			v103 = 1 - 0;
			v101 = {};
		end
		UpdateLastMoveTime();
		if (v104.TargetIsValid() or v14:AffectingCombat() or ((1562 + 2450) <= (3600 - (6 + 236)))) then
			local v164 = 0 + 0;
			while true do
				if (((1203 + 291) <= (7086 - 4081)) and (v164 == (3 - 1))) then
					v26.UpdateSoulShards();
					v99 = v11.CombatTime();
					v164 = 1136 - (1076 + 57);
				end
				if ((v164 == (1 + 0)) or ((3800 - (579 + 110)) == (169 + 1965))) then
					if (((2083 + 272) == (1250 + 1105)) and (v87 == (11518 - (174 + 233)))) then
						v87 = v11.FightRemains(v102, false);
					end
					v26.UpdatePetTable();
					v164 = 5 - 3;
				end
				if ((v164 == (4 - 1)) or ((262 + 326) <= (1606 - (663 + 511)))) then
					v98 = v14:SoulShardsP();
					v100 = v14:GCD() + 0.25 + 0;
					break;
				end
				if (((1042 + 3755) >= (12008 - 8113)) and (v164 == (0 + 0))) then
					v86 = v11.BossFightRemains();
					v87 = v86;
					v164 = 2 - 1;
				end
			end
		end
		if (((8658 - 5081) == (1707 + 1870)) and v61.SummonPet:IsCastable() and not (v14:IsMounted() or v14:IsInVehicle()) and v48 and not v18:IsActive()) then
			if (((7384 - 3590) > (2632 + 1061)) and v25(v61.SummonPet, false, true)) then
				return "summon_pet ooc";
			end
		end
		if ((v62.Healthstone:IsReady() and v39 and (v14:HealthPercentage() <= v40)) or ((117 + 1158) == (4822 - (478 + 244)))) then
			if (v25(v63.Healthstone) or ((2108 - (440 + 77)) >= (1628 + 1952))) then
				return "healthstone defensive 3";
			end
		end
		if (((3597 - 2614) <= (3364 - (655 + 901))) and v36 and (v14:HealthPercentage() <= v38)) then
			local v165 = 0 + 0;
			while true do
				if ((v165 == (0 + 0)) or ((1452 + 698) <= (4822 - 3625))) then
					if (((5214 - (695 + 750)) >= (4005 - 2832)) and (v37 == "Refreshing Healing Potion")) then
						if (((2291 - 806) == (5972 - 4487)) and v62.RefreshingHealingPotion:IsReady()) then
							if (v25(v63.RefreshingHealingPotion) or ((3666 - (285 + 66)) <= (6484 - 3702))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v37 == "Dreamwalker's Healing Potion") or ((2186 - (682 + 628)) >= (478 + 2486))) then
						if (v62.DreamwalkersHealingPotion:IsReady() or ((2531 - (176 + 123)) > (1045 + 1452))) then
							if (v25(v63.RefreshingHealingPotion) or ((1531 + 579) <= (601 - (239 + 30)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((1003 + 2683) > (3049 + 123)) and v104.TargetIsValid()) then
			local v166 = 0 - 0;
			local v167;
			while true do
				if ((v166 == (12 - 8)) or ((4789 - (306 + 9)) < (2861 - 2041))) then
					if (((745 + 3534) >= (1769 + 1113)) and v61.Guillotine:IsCastable() and v51 and (v14:BuffRemains(v61.NetherPortalBuff) < v100) and (v61.DemonicStrength:CooldownDown() or not v61.DemonicStrength:IsAvailable())) then
						if (v24(v63.GuillotineCursor, nil, nil, not v15:IsInRange(20 + 20)) or ((5801 - 3772) >= (4896 - (1140 + 235)))) then
							return "guillotine main 16";
						end
					end
					if ((v61.CallDreadstalkers:IsReady() and ((v61.SummonDemonicTyrant:CooldownRemains() > (16 + 9)) or (v96 > (23 + 2)) or v14:BuffUp(v61.NetherPortalBuff))) or ((523 + 1514) >= (4694 - (33 + 19)))) then
						if (((622 + 1098) < (13361 - 8903)) and v24(v61.CallDreadstalkers, nil, nil, not v15:IsSpellInRange(v61.CallDreadstalkers))) then
							return "call_dreadstalkers main 18";
						end
					end
					if ((v61.Implosion:IsReady() and (v107(1 + 1) > (0 - 0)) and v91 and not v14:PrevGCDP(1 + 0, v61.Implosion)) or ((1125 - (586 + 103)) > (276 + 2745))) then
						if (((2195 - 1482) <= (2335 - (1309 + 179))) and v24(v61.Implosion, v54, nil, not v15:IsInRange(72 - 32))) then
							return "implosion main 20";
						end
					end
					if (((938 + 1216) <= (10825 - 6794)) and v61.SummonSoulkeeper:IsReady() and (v61.SummonSoulkeeper:Count() == (8 + 2)) and (v103 > (1 - 0))) then
						if (((9196 - 4581) == (5224 - (295 + 314))) and v24(v61.SummonSoulkeeper)) then
							return "soul_strike main 22";
						end
					end
					if ((v61.HandofGuldan:IsReady() and (((v98 > (4 - 2)) and (v61.CallDreadstalkers:CooldownRemains() > (v100 * (1966 - (1300 + 662)))) and (v61.SummonDemonicTyrant:CooldownRemains() > (53 - 36))) or (v98 == (1760 - (1178 + 577))) or ((v98 == (3 + 1)) and v61.SoulStrike:IsAvailable() and (v61.SoulStrike:CooldownRemains() < (v100 * (5 - 3))))) and (v103 == (1406 - (851 + 554))) and v61.GrandWarlocksDesign:IsAvailable()) or ((3352 + 438) == (1386 - 886))) then
						if (((192 - 103) < (523 - (115 + 187))) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
							return "hand_of_guldan main 26";
						end
					end
					v166 = 4 + 1;
				end
				if (((1945 + 109) >= (5599 - 4178)) and ((1163 - (160 + 1001)) == v166)) then
					if (((606 + 86) < (2110 + 948)) and (v87 < (61 - 31))) then
						local v186 = v129();
						if (v186 or ((3612 - (237 + 121)) == (2552 - (525 + 372)))) then
							return v186;
						end
					end
					if ((v61.HandofGuldan:IsReady() and (v99 < (0.5 - 0)) and (((v87 % (312 - 217)) > (182 - (96 + 46))) or ((v87 % (872 - (643 + 134))) < (6 + 9))) and (v61.ReignofTyranny:IsAvailable() or (v103 > (4 - 2)))) or ((4811 - 3515) == (4709 + 201))) then
						if (((6609 - 3241) == (6884 - 3516)) and v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan))) then
							return "hand_of_guldan main 2";
						end
					end
					if (((3362 - (316 + 403)) < (2536 + 1279)) and (((v61.SummonDemonicTyrant:CooldownRemains() < (41 - 26)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (2 + 3))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (12 - 7))) and ((v61.GrimoireFelguard:CooldownRemains() < (8 + 2)) or not v14:HasTier(10 + 20, 6 - 4)) and ((v96 < (71 - 56)) or (v87 < (83 - 43)) or v14:PowerInfusionUp())) or (v61.SummonVilefiend:IsAvailable() and (v61.SummonDemonicTyrant:CooldownRemains() < (1 + 14)) and (v61.SummonVilefiend:CooldownRemains() < (v100 * (9 - 4))) and (v61.CallDreadstalkers:CooldownRemains() < (v100 * (1 + 4))) and ((v61.GrimoireFelguard:CooldownRemains() < (29 - 19)) or not v14:HasTier(47 - (12 + 5), 7 - 5)) and ((v96 < (31 - 16)) or (v87 < (85 - 45)) or v14:PowerInfusionUp())))) then
						local v187 = v128();
						if (((4743 - 2830) > (101 + 392)) and v187) then
							return v187;
						end
					end
					if (((6728 - (1656 + 317)) > (3055 + 373)) and (v61.SummonDemonicTyrant:CooldownRemains() < (13 + 2)) and (v115() or (not v61.SummonVilefiend:IsAvailable() and (v109() or v61.GrimoireFelguard:CooldownUp() or not v14:HasTier(79 - 49, 9 - 7)))) and ((v96 < (369 - (5 + 349))) or v109() or (v87 < (189 - 149)) or v14:PowerInfusionUp())) then
						local v188 = 1271 - (266 + 1005);
						local v189;
						while true do
							if (((911 + 470) <= (8083 - 5714)) and (v188 == (0 - 0))) then
								v189 = v128();
								if (v189 or ((6539 - (561 + 1135)) == (5321 - 1237))) then
									return v189;
								end
								break;
							end
						end
					end
					if (((15347 - 10678) > (1429 - (507 + 559))) and v61.SummonDemonicTyrant:IsCastable() and v57 and (v115() or v109() or (v61.GrimoireFelguard:CooldownRemains() > (225 - 135)))) then
						if (v24(v61.SummonDemonicTyrant) or ((5804 - 3927) >= (3526 - (212 + 176)))) then
							return "summon_demonic_tyrant main 4";
						end
					end
					v166 = 908 - (250 + 655);
				end
				if (((12930 - 8188) >= (6335 - 2709)) and (v166 == (0 - 0))) then
					if ((not v14:AffectingCombat() and v31 and not v14:IsCasting(v61.ShadowBolt)) or ((6496 - (1869 + 87)) == (3177 - 2261))) then
						local v190 = 1901 - (484 + 1417);
						local v191;
						while true do
							if ((v190 == (0 - 0)) or ((1936 - 780) > (5118 - (48 + 725)))) then
								v191 = v123();
								if (((3654 - 1417) < (11399 - 7150)) and v191) then
									return v191;
								end
								break;
							end
						end
					end
					if ((not v14:IsCasting() and not v14:IsChanneling()) or ((1560 + 1123) < (61 - 38))) then
						local v192 = v104.Interrupt(v61.SpellLock, 12 + 28, true);
						if (((204 + 493) <= (1679 - (152 + 701))) and v192) then
							return v192;
						end
						v192 = v104.Interrupt(v61.SpellLock, 1351 - (430 + 881), true, v17, v63.SpellLockMouseover);
						if (((424 + 681) <= (2071 - (557 + 338))) and v192) then
							return v192;
						end
						v192 = v104.Interrupt(v61.AxeToss, 12 + 28, true);
						if (((9521 - 6142) <= (13348 - 9536)) and v192) then
							return v192;
						end
						v192 = v104.Interrupt(v61.AxeToss, 106 - 66, true, v17, v63.AxeTossMouseover);
						if (v192 or ((1698 - 910) >= (2417 - (499 + 302)))) then
							return v192;
						end
						v192 = v104.InterruptWithStun(v61.AxeToss, 906 - (39 + 827), true);
						if (((5117 - 3263) <= (7546 - 4167)) and v192) then
							return v192;
						end
						v192 = v104.InterruptWithStun(v61.AxeToss, 158 - 118, true, v17, v63.AxeTossMouseover);
						if (((6983 - 2434) == (390 + 4159)) and v192) then
							return v192;
						end
					end
					if ((v14:AffectingCombat() and v58) or ((8844 - 5822) >= (484 + 2540))) then
						if (((7627 - 2807) > (2302 - (103 + 1))) and v61.BurningRush:IsCastable() and not v14:BuffUp(v61.BurningRush) and v131 and ((GetTime() - v130) >= (555 - (475 + 79))) and (v14:HealthPercentage() >= v59)) then
							if (v25(v61.BurningRush) or ((2293 - 1232) >= (15651 - 10760))) then
								return "burning_rush defensive 2";
							end
						elseif (((177 + 1187) <= (3937 + 536)) and v61.BurningRush:IsCastable() and v14:BuffUp(v61.BurningRush) and (not v131 or (v14:HealthPercentage() <= v59))) then
							if (v25(v63.CancelBurningRush) or ((5098 - (1395 + 108)) <= (8 - 5))) then
								return "burning_rush defensive 4";
							end
						end
					end
					v167 = v132();
					if (v167 or ((5876 - (7 + 1197)) == (1680 + 2172))) then
						return v167;
					end
					v166 = 1 + 0;
				end
				if (((1878 - (27 + 292)) == (4568 - 3009)) and ((7 - 1) == v166)) then
					if ((v61.PowerSiphon:IsReady() and (v14:BuffDown(v61.DemonicCoreBuff))) or ((7347 - 5595) <= (1553 - 765))) then
						if (v24(v61.PowerSiphon, v56) or ((7440 - 3533) == (316 - (43 + 96)))) then
							return "power_siphon main 38";
						end
					end
					if (((14154 - 10684) > (1254 - 699)) and v61.SummonVilefiend:IsReady() and (v87 < (v61.SummonDemonicTyrant:CooldownRemains() + 5 + 0))) then
						if (v24(v61.SummonVilefiend) or ((275 + 697) == (1274 - 629))) then
							return "summon_vilefiend main 40";
						end
					end
					if (((1220 + 1962) >= (3963 - 1848)) and v61.Doom:IsReady()) then
						if (((1226 + 2667) < (325 + 4104)) and v104.CastCycle(v61.Doom, v101, v120, not v15:IsSpellInRange(v61.Doom))) then
							return "doom main 42";
						end
					end
					if (v61.ShadowBolt:IsCastable() or ((4618 - (1414 + 337)) < (3845 - (1642 + 298)))) then
						if (v24(v61.ShadowBolt, nil, nil, not v15:IsSpellInRange(v61.ShadowBolt)) or ((4681 - 2885) >= (11654 - 7603))) then
							return "shadow_bolt main 44";
						end
					end
					break;
				end
				if (((4804 - 3185) <= (1237 + 2519)) and (v166 == (1 + 0))) then
					if (((1576 - (357 + 615)) == (424 + 180)) and v61.UnendingResolve:IsReady() and (v14:HealthPercentage() < v47)) then
						if (v25(v61.UnendingResolve, nil, nil, true) or ((11002 - 6518) == (772 + 128))) then
							return "unending_resolve defensive";
						end
					end
					v124();
					if (v111() or (v87 < (46 - 24)) or ((3567 + 892) <= (76 + 1037))) then
						local v193 = 0 + 0;
						local v194;
						while true do
							if (((4933 - (384 + 917)) > (4095 - (128 + 569))) and (v193 == (1543 - (1407 + 136)))) then
								v194 = v127();
								if (((5969 - (687 + 1200)) <= (6627 - (556 + 1154))) and v194 and v34 and v33) then
									return v194;
								end
								break;
							end
						end
					end
					v167 = v126();
					if (((16999 - 12167) >= (1481 - (9 + 86))) and v167) then
						return v167;
					end
					v166 = 423 - (275 + 146);
				end
				if (((23 + 114) == (201 - (29 + 35))) and (v166 == (13 - 10))) then
					if ((v61.SummonVilefiend:IsReady() and (v61.SummonDemonicTyrant:CooldownRemains() > (134 - 89))) or ((6930 - 5360) >= (2822 + 1510))) then
						if (v24(v61.SummonVilefiend) or ((5076 - (53 + 959)) <= (2227 - (312 + 96)))) then
							return "summon_vilefiend main 6";
						end
					end
					if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (((not v61.SoulStrike:IsAvailable() or (v61.SoulStrike:CooldownRemains() > (v100 * (3 - 1)))) and (v98 < (289 - (147 + 138)))) or (v98 < ((903 - (813 + 86)) - (v27(v103 > (2 + 0)))))) and not v14:PrevGCDP(1 - 0, v61.Demonbolt) and v14:HasTier(523 - (18 + 474), 1 + 1)) or ((16273 - 11287) < (2660 - (860 + 226)))) then
						if (((4729 - (121 + 182)) > (22 + 150)) and v104.CastCycle(v61.Demonbolt, v102, v118, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 8";
						end
					end
					if (((1826 - (988 + 252)) > (52 + 403)) and v61.PowerSiphon:IsReady() and v14:BuffDown(v61.DemonicCoreBuff) and (v15:DebuffDown(v61.DoomBrandDebuff) or (not v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime()))) or (v61.HandofGuldan:InFlight() and (v15:DebuffRemains(v61.DoomBrandDebuff) < (v100 + v61.Demonbolt:TravelTime() + 1 + 2)))) and v14:HasTier(2001 - (49 + 1921), 892 - (223 + 667))) then
						if (((878 - (51 + 1)) == (1421 - 595)) and v24(v61.PowerSiphon, v56)) then
							return "power_siphon main 10";
						end
					end
					if ((v61.DemonicStrength:IsCastable() and (v14:BuffRemains(v61.NetherPortalBuff) < v100)) or ((8605 - 4586) > (5566 - (146 + 979)))) then
						if (((570 + 1447) < (4866 - (311 + 294))) and v24(v61.DemonicStrength, v52)) then
							return "demonic_strength main 12";
						end
					end
					if (((13151 - 8435) > (34 + 46)) and v61.BilescourgeBombers:IsReady() and v61.BilescourgeBombers:IsCastable()) then
						if (v24(v61.BilescourgeBombers, nil, nil, not v15:IsInRange(1483 - (496 + 947))) or ((4865 - (1233 + 125)) == (1328 + 1944))) then
							return "bilescourge_bombers main 14";
						end
					end
					v166 = 4 + 0;
				end
				if ((v166 == (1 + 4)) or ((2521 - (963 + 682)) >= (2567 + 508))) then
					if (((5856 - (504 + 1000)) > (1720 + 834)) and v61.HandofGuldan:IsReady() and (v98 > (2 + 0)) and not ((v103 == (1 + 0)) and v61.GrandWarlocksDesign:IsAvailable())) then
						if (v24(v61.HandofGuldan, nil, nil, not v15:IsSpellInRange(v61.HandofGuldan)) or ((6496 - 2090) < (3455 + 588))) then
							return "hand_of_guldan main 28";
						end
					end
					if ((v61.Demonbolt:IsReady() and (v14:BuffStack(v61.DemonicCoreBuff) > (1 + 0)) and (((v98 < (186 - (156 + 26))) and not v61.SoulStrike:IsAvailable()) or (v61.SoulStrike:CooldownRemains() > (v100 * (2 + 0))) or (v98 < (2 - 0))) and not v92) or ((2053 - (149 + 15)) >= (4343 - (890 + 70)))) then
						if (((2009 - (39 + 78)) <= (3216 - (14 + 468))) and v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 30";
						end
					end
					if (((4228 - 2305) < (6199 - 3981)) and v61.Demonbolt:IsReady() and v14:HasTier(16 + 15, 2 + 0) and v14:BuffUp(v61.DemonicCoreBuff) and (v98 < (1 + 3)) and not v92) then
						if (((982 + 1191) > (100 + 279)) and v104.CastTargetIf(v61.Demonbolt, v102, "==", v119, v122, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 32";
						end
					end
					if ((v61.Demonbolt:IsReady() and (v87 < (v14:BuffStack(v61.DemonicCoreBuff) * v100))) or ((4959 - 2368) == (3370 + 39))) then
						if (((15861 - 11347) > (84 + 3240)) and v24(v61.Demonbolt, nil, nil, not v15:IsSpellInRange(v61.Demonbolt))) then
							return "demonbolt main 34";
						end
					end
					if ((v61.Demonbolt:IsReady() and v14:BuffUp(v61.DemonicCoreBuff) and (v61.PowerSiphon:CooldownRemains() < (55 - (12 + 39))) and (v98 < (4 + 0)) and not v92) or ((643 - 435) >= (17195 - 12367))) then
						if (v104.CastCycle(v61.Demonbolt, v102, v119, not v15:IsSpellInRange(v61.Demonbolt)) or ((470 + 1113) > (1878 + 1689))) then
							return "demonbolt main 36";
						end
					end
					v166 = 14 - 8;
				end
			end
		end
	end
	local function v134()
		local v155 = 0 + 0;
		while true do
			if ((v155 == (0 - 0)) or ((3023 - (1596 + 114)) == (2072 - 1278))) then
				v61.DoomBrandDebuff:RegisterAuraTracking();
				v11.Print("Demonology Warlock rotation by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v11.SetAPL(979 - (164 + 549), v133, v134);
end;
return v1["Epix_Warlock_Demonology.lua"](...);

