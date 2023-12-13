local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2264 - (360 + 10)) < (901 + 505))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.MouseOver;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.PressCursor;
	local v25 = v21.Macro;
	local v26 = v21.Bind;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = math.max;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local v63;
	local v64;
	local v65;
	local v66;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97 = v18.Mage.Frost;
	local v98 = v20.Mage.Frost;
	local v99 = v25.Mage.Frost;
	local v100 = {};
	local v101, v102;
	local v103, v104;
	local v105 = 0 + 0;
	local v106 = 1046 - (82 + 964);
	local v107 = 15 + 0;
	local v108 = 11623 - (409 + 103);
	local v109 = 11347 - (46 + 190);
	local v110;
	local v111 = v21.Commons.Everyone;
	local function v112()
		if (((1667 - (51 + 44)) >= (432 + 1099)) and v97.RemoveCurse:IsAvailable()) then
			v111.DispellableDebuffs = v111.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v97.FrozenOrb:RegisterInFlightEffect(86038 - (1114 + 203));
	v97.FrozenOrb:RegisterInFlight();
	v9:RegisterForEvent(function()
		v97.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v97.Frostbolt:RegisterInFlightEffect(229323 - (228 + 498));
	v97.Frostbolt:RegisterInFlight();
	v97.Flurry:RegisterInFlightEffect(49474 + 178880);
	v97.Flurry:RegisterInFlight();
	v97.IceLance:RegisterInFlightEffect(126292 + 102306);
	v97.IceLance:RegisterInFlight();
	v97.GlacialSpike:RegisterInFlightEffect(229263 - (174 + 489));
	v97.GlacialSpike:RegisterInFlight();
	v9:RegisterForEvent(function()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (1906 - (830 + 1075))) or ((5211 - (303 + 221)) < (5811 - (231 + 1038)))) then
				v105 = 0 + 0;
				break;
			end
			if (((4453 - (171 + 991)) > (6870 - 5203)) and (v131 == (0 - 0))) then
				v108 = 27726 - 16615;
				v109 = 8893 + 2218;
				v131 = 3 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113(v132)
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 - 0)) or ((2698 - 1825) == (3282 - (111 + 1137)))) then
				if ((v132 == nil) or ((2974 - (91 + 67)) < (32 - 21))) then
					v132 = v14;
				end
				return not v132:IsInBossList() or (v132:Level() < (19 + 54));
			end
		end
	end
	local function v114()
		return v29(v13:BuffRemains(v97.FingersofFrostBuff), v14:DebuffRemains(v97.WintersChillDebuff), v14:DebuffRemains(v97.Frostbite), v14:DebuffRemains(v97.Freeze), v14:DebuffRemains(v97.FrostNova));
	end
	local function v115(v134)
		local v135 = 523 - (423 + 100);
		local v136;
		while true do
			if (((26 + 3673) < (13029 - 8323)) and (v135 == (1 + 0))) then
				for v210, v211 in pairs(v134) do
					v136 = v136 + v211:DebuffStack(v97.WintersChillDebuff);
				end
				return v136;
			end
			if (((3417 - (326 + 445)) >= (3822 - 2946)) and (v135 == (0 - 0))) then
				if (((1433 - 819) <= (3895 - (530 + 181))) and (v97.WintersChillDebuff:AuraActiveCount() == (881 - (614 + 267)))) then
					return 32 - (19 + 13);
				end
				v136 = 0 - 0;
				v135 = 2 - 1;
			end
		end
	end
	local function v116(v137)
		return (v137:DebuffStack(v97.WintersChillDebuff));
	end
	local function v117(v138)
		return (v138:DebuffDown(v97.WintersChillDebuff));
	end
	local function v118()
		local v139 = 0 - 0;
		while true do
			if (((812 + 2314) == (5497 - 2371)) and (v139 == (6 - 3))) then
				if ((v97.AlterTime:IsReady() and v61 and (v13:HealthPercentage() <= v68)) or ((3999 - (1293 + 519)) >= (10107 - 5153))) then
					if (v23(v97.AlterTime) or ((10122 - 6245) == (6836 - 3261))) then
						return "alter_time defensive 7";
					end
				end
				if (((3048 - 2341) > (1488 - 856)) and v98.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v86)) then
					if (v23(v99.Healthstone) or ((290 + 256) >= (548 + 2136))) then
						return "healthstone defensive";
					end
				end
				v139 = 9 - 5;
			end
			if (((339 + 1126) <= (1429 + 2872)) and (v139 == (3 + 1))) then
				if (((2800 - (709 + 387)) > (3283 - (673 + 1185))) and v83 and (v13:HealthPercentage() <= v85)) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (0 - 0)) or ((1129 - 442) == (3029 + 1205))) then
							if ((v87 == "Refreshing Healing Potion") or ((2489 + 841) < (1928 - 499))) then
								if (((282 + 865) >= (667 - 332)) and v98.RefreshingHealingPotion:IsReady()) then
									if (((6742 - 3307) > (3977 - (446 + 1434))) and v23(v99.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v87 == "Dreamwalker's Healing Potion") or ((5053 - (1040 + 243)) >= (12060 - 8019))) then
								if (v98.DreamwalkersHealingPotion:IsReady() or ((5638 - (559 + 1288)) <= (3542 - (609 + 1322)))) then
									if (v23(v99.RefreshingHealingPotion) or ((5032 - (13 + 441)) <= (7503 - 5495))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((2946 - 1821) <= (10339 - 8263)) and (v139 == (1 + 1))) then
				if ((v97.MirrorImage:IsCastable() and v67 and (v13:HealthPercentage() <= v73)) or ((2698 - 1955) >= (1563 + 2836))) then
					if (((507 + 648) < (4964 - 3291)) and v23(v97.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v97.GreaterInvisibility:IsReady() and v63 and (v13:HealthPercentage() <= v70)) or ((1272 + 1052) <= (1062 - 484))) then
					if (((2491 + 1276) == (2096 + 1671)) and v23(v97.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v139 = 3 + 0;
			end
			if (((3434 + 655) == (4001 + 88)) and (v139 == (433 - (153 + 280)))) then
				if (((12872 - 8414) >= (1503 + 171)) and v97.IceBarrier:IsCastable() and v62 and v13:BuffDown(v97.IceBarrier) and (v13:HealthPercentage() <= v69)) then
					if (((384 + 588) <= (743 + 675)) and v23(v97.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v97.MassBarrier:IsCastable() and v66 and v13:BuffDown(v97.IceBarrier) and v111.AreUnitsBelowHealthPercentage(v74, 2 + 0)) or ((3579 + 1359) < (7250 - 2488))) then
					if (v23(v97.MassBarrier) or ((1548 + 956) > (4931 - (89 + 578)))) then
						return "mass_barrier defensive 2";
					end
				end
				v139 = 1 + 0;
			end
			if (((4475 - 2322) == (3202 - (572 + 477))) and (v139 == (1 + 0))) then
				if ((v97.IceColdTalent:IsAvailable() and v97.IceColdAbility:IsCastable() and v65 and (v13:HealthPercentage() <= v72)) or ((305 + 202) >= (310 + 2281))) then
					if (((4567 - (84 + 2)) == (7384 - 2903)) and v23(v97.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v97.IceBlock:IsReady() and v64 and (v13:HealthPercentage() <= v71)) or ((1678 + 650) < (1535 - (497 + 345)))) then
					if (((111 + 4217) == (732 + 3596)) and v23(v97.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v139 = 1335 - (605 + 728);
			end
		end
	end
	local function v119()
		if (((1134 + 454) >= (2960 - 1628)) and v97.RemoveCurse:IsReady() and v34 and v111.DispellableFriendlyUnit(1 + 19)) then
			if (v23(v99.RemoveCurseFocus) or ((15432 - 11258) > (3830 + 418))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v120()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1 + 0)) or ((5075 - (457 + 32)) <= (35 + 47))) then
				v30 = v111.HandleBottomTrinket(v100, v33, 1442 - (832 + 570), nil);
				if (((3640 + 223) == (1008 + 2855)) and v30) then
					return v30;
				end
				break;
			end
			if ((v140 == (0 - 0)) or ((136 + 146) <= (838 - (588 + 208)))) then
				v30 = v111.HandleTopTrinket(v100, v33, 107 - 67, nil);
				if (((6409 - (884 + 916)) >= (1603 - 837)) and v30) then
					return v30;
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v121()
		if (v111.TargetIsValid() or ((1805 - (232 + 421)) == (4377 - (1569 + 320)))) then
			local v184 = 0 + 0;
			while true do
				if (((651 + 2771) > (11288 - 7938)) and (v184 == (605 - (316 + 289)))) then
					if (((2295 - 1418) > (18 + 358)) and v97.MirrorImage:IsCastable() and v67 and v95) then
						if (v23(v97.MirrorImage) or ((4571 - (666 + 787)) <= (2276 - (360 + 65)))) then
							return "mirror_image precombat 2";
						end
					end
					if ((v97.Frostbolt:IsCastable() and not v13:IsCasting(v97.Frostbolt)) or ((155 + 10) >= (3746 - (79 + 175)))) then
						if (((6226 - 2277) < (3790 + 1066)) and v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		if ((v94 and v97.TimeWarp:IsCastable() and v13:BloodlustExhaustUp() and v97.TemporalWarp:IsAvailable() and v13:BloodlustDown() and v13:PrevGCDP(2 - 1, v97.IcyVeins)) or ((8234 - 3958) < (3915 - (503 + 396)))) then
			if (((4871 - (92 + 89)) > (8001 - 3876)) and v23(v97.TimeWarp, not v14:IsInRange(21 + 19))) then
				return "time_warp cd 2";
			end
		end
		local v141 = v111.HandleDPSPotion(v13:BuffUp(v97.IcyVeinsBuff));
		if (v141 or ((30 + 20) >= (3508 - 2612))) then
			return v141;
		end
		if ((v97.IcyVeins:IsCastable() and v33 and v51 and v56 and (v82 < v109)) or ((235 + 1479) >= (6744 - 3786))) then
			if (v23(v97.IcyVeins) or ((1301 + 190) < (308 + 336))) then
				return "icy_veins cd 6";
			end
		end
		if (((2144 - 1440) < (124 + 863)) and (v82 < v109)) then
			if (((5669 - 1951) > (3150 - (485 + 759))) and v89 and ((v33 and v90) or not v90)) then
				local v212 = 0 - 0;
				while true do
					if ((v212 == (1189 - (442 + 747))) or ((2093 - (832 + 303)) > (4581 - (88 + 858)))) then
						v30 = v120();
						if (((1068 + 2433) <= (3718 + 774)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if ((v88 and ((v91 and v33) or not v91) and (v82 < v109)) or ((142 + 3300) < (3337 - (766 + 23)))) then
			local v185 = 0 - 0;
			while true do
				if (((3931 - 1056) >= (3856 - 2392)) and (v185 == (0 - 0))) then
					if (v97.BloodFury:IsCastable() or ((5870 - (1036 + 37)) >= (3470 + 1423))) then
						if (v23(v97.BloodFury) or ((1072 - 521) > (1627 + 441))) then
							return "blood_fury cd 10";
						end
					end
					if (((3594 - (641 + 839)) > (1857 - (910 + 3))) and v97.Berserking:IsCastable()) then
						if (v23(v97.Berserking) or ((5766 - 3504) >= (4780 - (1466 + 218)))) then
							return "berserking cd 12";
						end
					end
					v185 = 1 + 0;
				end
				if ((v185 == (1149 - (556 + 592))) or ((802 + 1453) >= (4345 - (329 + 479)))) then
					if (v97.LightsJudgment:IsCastable() or ((4691 - (174 + 680)) < (4487 - 3181))) then
						if (((6114 - 3164) == (2107 + 843)) and v23(v97.LightsJudgment, not v14:IsSpellInRange(v97.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (v97.Fireblood:IsCastable() or ((5462 - (396 + 343)) < (292 + 3006))) then
						if (((2613 - (29 + 1448)) >= (1543 - (135 + 1254))) and v23(v97.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v185 = 7 - 5;
				end
				if ((v185 == (9 - 7)) or ((181 + 90) > (6275 - (389 + 1138)))) then
					if (((5314 - (102 + 472)) >= (2975 + 177)) and v97.AncestralCall:IsCastable()) then
						if (v23(v97.AncestralCall) or ((1430 + 1148) >= (3161 + 229))) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		if (((1586 - (320 + 1225)) <= (2956 - 1295)) and v97.IceFloes:IsCastable() and v45 and v13:BuffDown(v97.IceFloes)) then
			if (((368 + 233) < (5024 - (157 + 1307))) and v23(v97.IceFloes)) then
				return "ice_floes movement";
			end
		end
		if (((2094 - (821 + 1038)) < (1713 - 1026)) and v97.IceNova:IsCastable() and v47) then
			if (((498 + 4051) > (2047 - 894)) and v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova))) then
				return "ice_nova movement";
			end
		end
		if ((v97.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (12 + 18)) and (v102 >= (4 - 2))) or ((5700 - (834 + 192)) < (298 + 4374))) then
			if (((942 + 2726) < (98 + 4463)) and v23(v97.ArcaneExplosion, not v14:IsInRange(12 - 4))) then
				return "arcane_explosion movement";
			end
		end
		if ((v97.FireBlast:IsCastable() and v39) or ((759 - (300 + 4)) == (963 + 2642))) then
			if (v23(v97.FireBlast, not v14:IsSpellInRange(v97.FireBlast)) or ((6971 - 4308) == (3674 - (112 + 250)))) then
				return "fire_blast movement";
			end
		end
		if (((1705 + 2572) <= (11211 - 6736)) and v97.IceLance:IsCastable() and v46) then
			if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((499 + 371) == (615 + 574))) then
				return "ice_lance movement";
			end
		end
	end
	local function v124()
		if (((1162 + 391) <= (1554 + 1579)) and v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v13:PrevGCDP(1 + 0, v97.CometStorm) or (v13:PrevGCDP(1415 - (1001 + 413), v97.FrozenOrb) and not v97.CometStorm:IsAvailable()))) then
			if (v23(v97.ConeofCold, not v14:IsInRange(17 - 9)) or ((3119 - (244 + 638)) >= (4204 - (627 + 66)))) then
				return "cone_of_cold aoe 2";
			end
		end
		if ((v97.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v109) and (not v13:PrevGCDP(2 - 1, v97.GlacialSpike) or not v113())) or ((1926 - (512 + 90)) > (4926 - (1665 + 241)))) then
			if (v23(v99.FrozenOrbCast, not v14:IsInRange(757 - (373 + 344))) or ((1350 + 1642) == (498 + 1383))) then
				return "frozen_orb aoe 4";
			end
		end
		if (((8192 - 5086) > (2581 - 1055)) and v97.Blizzard:IsCastable() and v37 and (not v13:PrevGCDP(1100 - (35 + 1064), v97.GlacialSpike) or not v113())) then
			if (((2200 + 823) < (8279 - 4409)) and v23(v99.BlizzardCursor, not v14:IsInRange(1 + 39))) then
				return "blizzard aoe 6";
			end
		end
		if (((1379 - (298 + 938)) > (1333 - (233 + 1026))) and v97.CometStorm:IsCastable() and ((v58 and v33) or not v58) and v53 and (v82 < v109) and not v13:PrevGCDP(1667 - (636 + 1030), v97.GlacialSpike) and (not v97.ColdestSnap:IsAvailable() or (v97.ConeofCold:CooldownUp() and (v97.FrozenOrb:CooldownRemains() > (13 + 12))) or (v97.ConeofCold:CooldownRemains() > (20 + 0)))) then
			if (((6 + 12) < (143 + 1969)) and v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm))) then
				return "comet_storm aoe 8";
			end
		end
		if (((1318 - (55 + 166)) <= (316 + 1312)) and v17:IsActive() and v43 and v97.Freeze:IsReady() and v113() and (v114() == (0 + 0)) and ((not v97.GlacialSpike:IsAvailable() and not v97.Snowstorm:IsAvailable()) or v13:PrevGCDP(3 - 2, v97.GlacialSpike) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107)))) then
			if (((4927 - (36 + 261)) == (8097 - 3467)) and v23(v99.FreezePet, not v14:IsSpellInRange(v97.Freeze))) then
				return "freeze aoe 10";
			end
		end
		if (((4908 - (34 + 1334)) > (1032 + 1651)) and v97.IceNova:IsCastable() and v47 and v113() and not v13:PrevOffGCDP(1 + 0, v97.Freeze) and (v13:PrevGCDP(1284 - (1035 + 248), v97.GlacialSpike) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107) and (v110 < (22 - (20 + 1)))))) then
			if (((2498 + 2296) >= (3594 - (134 + 185))) and v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova))) then
				return "ice_nova aoe 11";
			end
		end
		if (((2617 - (549 + 584)) == (2169 - (314 + 371))) and v97.FrostNova:IsCastable() and v41 and v113() and not v13:PrevOffGCDP(3 - 2, v97.Freeze) and ((v13:PrevGCDP(969 - (478 + 490), v97.GlacialSpike) and (v105 == (0 + 0))) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107) and (v110 < (1173 - (786 + 386)))))) then
			if (((4638 - 3206) < (4934 - (1055 + 324))) and v23(v97.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if ((v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and (v13:BuffStackP(v97.SnowstormBuff) == v107)) or ((2405 - (1093 + 247)) > (3180 + 398))) then
			if (v23(v97.ConeofCold, not v14:IsInRange(1 + 7)) or ((19037 - 14242) < (4775 - 3368))) then
				return "cone_of_cold aoe 14";
			end
		end
		if (((5272 - 3419) < (12094 - 7281)) and v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109)) then
			if (v23(v97.ShiftingPower, not v14:IsInRange(15 + 25), true) or ((10867 - 8046) < (8379 - 5948))) then
				return "shifting_power aoe 16";
			end
		end
		if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (4 + 1)) and (v97.Blizzard:CooldownRemains() > v110)) or ((7349 - 4475) < (2869 - (364 + 324)))) then
			if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((7371 - 4682) <= (822 - 479))) then
				return "glacial_spike aoe 18";
			end
		end
		if ((v97.Flurry:IsCastable() and v42 and not v113() and (v105 == (0 + 0)) and (v13:PrevGCDP(4 - 3, v97.GlacialSpike) or (v97.Flurry:ChargesFractional() > (1.8 - 0)))) or ((5676 - 3807) == (3277 - (1249 + 19)))) then
			if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((3201 + 345) < (9038 - 6716))) then
				return "flurry aoe 20";
			end
		end
		if ((v97.Flurry:IsCastable() and v42 and (v105 == (1086 - (686 + 400))) and (v13:BuffUp(v97.BrainFreezeBuff) or v13:BuffUp(v97.FingersofFrostBuff))) or ((1634 + 448) == (5002 - (73 + 156)))) then
			if (((16 + 3228) > (1866 - (721 + 90))) and v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry))) then
				return "flurry aoe 21";
			end
		end
		if ((v97.IceLance:IsCastable() and v46 and (v13:BuffUp(v97.FingersofFrostBuff) or (v114() > v97.IceLance:TravelTime()) or v28(v105))) or ((38 + 3275) <= (5772 - 3994))) then
			if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((1891 - (224 + 246)) >= (3407 - 1303))) then
				return "ice_lance aoe 22";
			end
		end
		if (((3336 - 1524) <= (590 + 2659)) and v97.IceNova:IsCastable() and v47 and (v101 >= (1 + 3)) and ((not v97.Snowstorm:IsAvailable() and not v97.GlacialSpike:IsAvailable()) or not v113())) then
			if (((1193 + 430) <= (3890 - 1933)) and v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova))) then
				return "ice_nova aoe 23";
			end
		end
		if (((14682 - 10270) == (4925 - (203 + 310))) and v97.DragonsBreath:IsCastable() and v38 and (v102 >= (2000 - (1238 + 755)))) then
			if (((123 + 1627) >= (2376 - (709 + 825))) and v23(v97.DragonsBreath, not v14:IsInRange(18 - 8))) then
				return "dragons_breath aoe 26";
			end
		end
		if (((6368 - 1996) > (2714 - (196 + 668))) and v97.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (118 - 88)) and (v102 >= (14 - 7))) then
			if (((1065 - (171 + 662)) < (914 - (4 + 89))) and v23(v97.ArcaneExplosion, not v14:IsInRange(27 - 19))) then
				return "arcane_explosion aoe 28";
			end
		end
		if (((189 + 329) < (3961 - 3059)) and v97.Frostbolt:IsCastable() and v40) then
			if (((1175 + 1819) > (2344 - (35 + 1451))) and v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true)) then
				return "frostbolt aoe 32";
			end
		end
		if ((v13:IsMoving() and v93) or ((5208 - (28 + 1425)) <= (2908 - (941 + 1052)))) then
			local v186 = 0 + 0;
			while true do
				if (((5460 - (822 + 692)) > (5342 - 1599)) and (v186 == (0 + 0))) then
					v30 = v123();
					if (v30 or ((1632 - (45 + 252)) >= (3272 + 34))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v125()
		if (((1668 + 3176) > (5483 - 3230)) and v97.CometStorm:IsCastable() and (v13:PrevGCDP(434 - (114 + 319), v97.Flurry) or v13:PrevGCDP(1 - 0, v97.ConeofCold)) and ((v58 and v33) or not v58) and v53 and (v82 < v109)) then
			if (((578 - 126) == (289 + 163)) and v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm))) then
				return "comet_storm cleave 2";
			end
		end
		if ((v97.Flurry:IsCastable() and v42 and ((v13:PrevGCDP(1 - 0, v97.Frostbolt) and (v106 >= (5 - 2))) or v13:PrevGCDP(1964 - (556 + 1407), v97.GlacialSpike) or ((v106 >= (1209 - (741 + 465))) and (v106 < (470 - (170 + 295))) and (v97.Flurry:ChargesFractional() == (2 + 0))))) or ((4186 + 371) < (5138 - 3051))) then
			local v187 = 0 + 0;
			while true do
				if (((2485 + 1389) == (2194 + 1680)) and (v187 == (1230 - (957 + 273)))) then
					if (v111.CastTargetIf(v97.Flurry, v103, "min", v116, nil, not v14:IsSpellInRange(v97.Flurry)) or ((519 + 1419) > (1976 + 2959))) then
						return "flurry cleave 4";
					end
					if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((16213 - 11958) < (9020 - 5597))) then
						return "flurry cleave 4";
					end
					break;
				end
			end
		end
		if (((4440 - 2986) <= (12334 - 9843)) and v97.IceLance:IsReady() and v46 and v97.GlacialSpike:IsAvailable() and (v97.WintersChillDebuff:AuraActiveCount() == (1780 - (389 + 1391))) and (v106 == (3 + 1)) and v13:BuffUp(v97.FingersofFrostBuff)) then
			local v188 = 0 + 0;
			while true do
				if ((v188 == (0 - 0)) or ((5108 - (783 + 168)) <= (9407 - 6604))) then
					if (((4774 + 79) >= (3293 - (309 + 2))) and v111.CastTargetIf(v97.IceLance, v103, "max", v117, nil, not v14:IsSpellInRange(v97.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (((12694 - 8560) > (4569 - (1090 + 122))) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
						return "ice_lance cleave 6";
					end
					break;
				end
			end
		end
		if ((v97.RayofFrost:IsCastable() and (v105 == (1 + 0)) and v48) or ((11475 - 8058) < (1735 + 799))) then
			local v189 = 1118 - (628 + 490);
			while true do
				if ((v189 == (0 + 0)) or ((6738 - 4016) <= (749 - 585))) then
					if (v111.CastTargetIf(v97.RayofFrost, v103, "max", v116, nil, not v14:IsSpellInRange(v97.RayofFrost)) or ((3182 - (431 + 343)) < (4258 - 2149))) then
						return "ray_of_frost cleave 8";
					end
					if (v23(v97.RayofFrost, not v14:IsSpellInRange(v97.RayofFrost)) or ((95 - 62) == (1150 + 305))) then
						return "ray_of_frost cleave 8";
					end
					break;
				end
			end
		end
		if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (1 + 4)) and (v97.Flurry:CooldownUp() or (v105 > (1695 - (556 + 1139))))) or ((458 - (6 + 9)) >= (736 + 3279))) then
			if (((1733 + 1649) > (335 - (28 + 141))) and v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike))) then
				return "glacial_spike cleave 10";
			end
		end
		if ((v97.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v109) and (v13:BuffStackP(v97.FingersofFrostBuff) < (1 + 1)) and (not v97.RayofFrost:IsAvailable() or v97.RayofFrost:CooldownDown())) or ((345 - 65) == (2167 + 892))) then
			if (((3198 - (486 + 831)) > (3364 - 2071)) and v23(v99.FrozenOrbCast, not v14:IsSpellInRange(v97.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if (((8297 - 5940) == (446 + 1911)) and v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v97.CometStorm:CooldownRemains() > (31 - 21)) and (v97.FrozenOrb:CooldownRemains() > (1273 - (668 + 595))) and (v105 == (0 + 0)) and (v102 >= (1 + 2))) then
			if (((335 - 212) == (413 - (23 + 267))) and v23(v97.ConeofCold)) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v97.Blizzard:IsCastable() and v37 and (v102 >= (1946 - (1129 + 815))) and v97.IceCaller:IsAvailable() and v97.FreezingRain:IsAvailable() and ((not v97.SplinteringCold:IsAvailable() and not v97.RayofFrost:IsAvailable()) or v13:BuffUp(v97.FreezingRainBuff) or (v102 >= (390 - (371 + 16))))) or ((2806 - (1326 + 424)) >= (6423 - 3031))) then
			if (v23(v99.BlizzardCursor, not v14:IsSpellInRange(v97.Blizzard)) or ((3950 - 2869) < (1193 - (88 + 30)))) then
				return "blizzard cleave 16";
			end
		end
		if ((v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109) and (((v97.FrozenOrb:CooldownRemains() > (781 - (720 + 51))) and (not v97.CometStorm:IsAvailable() or (v97.CometStorm:CooldownRemains() > (22 - 12))) and (not v97.RayofFrost:IsAvailable() or (v97.RayofFrost:CooldownRemains() > (1786 - (421 + 1355))))) or (v97.IcyVeins:CooldownRemains() < (32 - 12)))) or ((516 + 533) >= (5515 - (286 + 797)))) then
			if (v23(v97.ShiftingPower, not v14:IsSpellInRange(v97.ShiftingPower), true) or ((17429 - 12661) <= (1400 - 554))) then
				return "shifting_power cleave 18";
			end
		end
		if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (444 - (397 + 42)))) or ((1049 + 2309) <= (2220 - (24 + 776)))) then
			if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((5759 - 2020) <= (3790 - (222 + 563)))) then
				return "glacial_spike cleave 20";
			end
		end
		if ((v97.IceLance:IsReady() and v46 and ((v13:BuffStackP(v97.FingersofFrostBuff) and not v13:PrevGCDP(1 - 0, v97.GlacialSpike)) or (v105 > (0 + 0)))) or ((1849 - (23 + 167)) >= (3932 - (690 + 1108)))) then
			local v190 = 0 + 0;
			while true do
				if (((0 + 0) == v190) or ((4108 - (40 + 808)) < (388 + 1967))) then
					if (v111.CastTargetIf(v97.IceLance, v103, "max", v116, nil, not v14:IsSpellInRange(v97.IceLance)) or ((2558 - 1889) == (4037 + 186))) then
						return "ice_lance cleave 22";
					end
					if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((896 + 796) < (323 + 265))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if ((v97.IceNova:IsCastable() and v47 and (v102 >= (575 - (47 + 524)))) or ((3114 + 1683) < (9980 - 6329))) then
			if (v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova)) or ((6245 - 2068) > (11061 - 6211))) then
				return "ice_nova cleave 24";
			end
		end
		if ((v97.Frostbolt:IsCastable() and v40) or ((2126 - (1165 + 561)) > (34 + 1077))) then
			if (((9449 - 6398) > (384 + 621)) and v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true)) then
				return "frostbolt cleave 26";
			end
		end
		if (((4172 - (341 + 138)) <= (1183 + 3199)) and v13:IsMoving() and v93) then
			local v191 = 0 - 0;
			while true do
				if ((v191 == (326 - (89 + 237))) or ((10558 - 7276) > (8631 - 4531))) then
					v30 = v123();
					if (v30 or ((4461 - (581 + 300)) < (4064 - (855 + 365)))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v126()
		if (((211 - 122) < (1467 + 3023)) and v97.CometStorm:IsCastable() and v53 and ((v58 and v33) or not v58) and (v82 < v109) and (v13:PrevGCDP(1236 - (1030 + 205), v97.Flurry) or v13:PrevGCDP(1 + 0, v97.ConeofCold))) then
			if (v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm)) or ((4636 + 347) < (2094 - (156 + 130)))) then
				return "comet_storm single 2";
			end
		end
		if (((8699 - 4870) > (6351 - 2582)) and v97.Flurry:IsCastable() and (v105 == (0 - 0)) and v14:DebuffDown(v97.WintersChillDebuff) and ((v13:PrevGCDP(1 + 0, v97.Frostbolt) and (v106 >= (2 + 1))) or (v13:PrevGCDP(70 - (10 + 59), v97.Frostbolt) and v13:BuffUp(v97.BrainFreezeBuff)) or v13:PrevGCDP(1 + 0, v97.GlacialSpike) or (v97.GlacialSpike:IsAvailable() and (v106 == (19 - 15)) and v13:BuffDown(v97.FingersofFrostBuff)))) then
			if (((2648 - (671 + 492)) <= (2312 + 592)) and v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry))) then
				return "flurry single 4";
			end
		end
		if (((5484 - (369 + 846)) == (1131 + 3138)) and v97.IceLance:IsReady() and v46 and v97.GlacialSpike:IsAvailable() and not v97.GlacialSpike:InFlight() and (v105 == (0 + 0)) and (v106 == (1949 - (1036 + 909))) and v13:BuffUp(v97.FingersofFrostBuff)) then
			if (((308 + 79) <= (4670 - 1888)) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
				return "ice_lance single 6";
			end
		end
		if ((v97.RayofFrost:IsCastable() and v48 and (v14:DebuffRemains(v97.WintersChillDebuff) > v97.RayofFrost:CastTime()) and (v105 == (204 - (11 + 192)))) or ((960 + 939) <= (1092 - (135 + 40)))) then
			if (v23(v97.RayofFrost, not v14:IsSpellInRange(v97.RayofFrost)) or ((10447 - 6135) <= (529 + 347))) then
				return "ray_of_frost single 8";
			end
		end
		if (((4916 - 2684) <= (3891 - 1295)) and v97.GlacialSpike:IsReady() and v44 and (v106 == (181 - (50 + 126))) and ((v97.Flurry:Charges() >= (2 - 1)) or ((v105 > (0 + 0)) and (v97.GlacialSpike:CastTime() < v14:DebuffRemains(v97.WintersChillDebuff))))) then
			if (((3508 - (1233 + 180)) < (4655 - (522 + 447))) and v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike))) then
				return "glacial_spike single 10";
			end
		end
		if ((v97.FrozenOrb:IsCastable() and v52 and ((v57 and v33) or not v57) and (v82 < v109) and (v105 == (1421 - (107 + 1314))) and (v13:BuffStackP(v97.FingersofFrostBuff) < (1 + 1)) and (not v97.RayofFrost:IsAvailable() or v97.RayofFrost:CooldownDown())) or ((4860 - 3265) >= (1901 + 2573))) then
			if (v23(v99.FrozenOrbCast, not v14:IsInRange(79 - 39)) or ((18275 - 13656) < (4792 - (716 + 1194)))) then
				return "frozen_orb single 12";
			end
		end
		if ((v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v97.CometStorm:CooldownRemains() > (1 + 9)) and (v97.FrozenOrb:CooldownRemains() > (2 + 8)) and (v105 == (503 - (74 + 429))) and (v101 >= (5 - 2))) or ((146 + 148) >= (11058 - 6227))) then
			if (((1436 + 593) <= (9507 - 6423)) and v23(v97.ConeofCold, not v14:IsInRange(19 - 11))) then
				return "cone_of_cold single 14";
			end
		end
		if ((v97.Blizzard:IsCastable() and v37 and (v101 >= (435 - (279 + 154))) and v97.IceCaller:IsAvailable() and v97.FreezingRain:IsAvailable() and ((not v97.SplinteringCold:IsAvailable() and not v97.RayofFrost:IsAvailable()) or v13:BuffUp(v97.FreezingRainBuff) or (v101 >= (781 - (454 + 324))))) or ((1603 + 434) == (2437 - (12 + 5)))) then
			if (((2404 + 2054) > (9947 - 6043)) and v23(v99.BlizzardCursor, not v14:IsInRange(15 + 25))) then
				return "blizzard single 16";
			end
		end
		if (((1529 - (277 + 816)) >= (525 - 402)) and v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109) and (v105 == (1183 - (1058 + 125))) and (((v97.FrozenOrb:CooldownRemains() > (2 + 8)) and (not v97.CometStorm:IsAvailable() or (v97.CometStorm:CooldownRemains() > (985 - (815 + 160)))) and (not v97.RayofFrost:IsAvailable() or (v97.RayofFrost:CooldownRemains() > (42 - 32)))) or (v97.IcyVeins:CooldownRemains() < (47 - 27)))) then
			if (((120 + 380) < (5308 - 3492)) and v23(v97.ShiftingPower, not v14:IsInRange(1938 - (41 + 1857)))) then
				return "shifting_power single 18";
			end
		end
		if (((5467 - (1222 + 671)) == (9237 - 5663)) and v97.GlacialSpike:IsReady() and v44 and (v106 == (6 - 1))) then
			if (((1403 - (229 + 953)) < (2164 - (1111 + 663))) and v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike))) then
				return "glacial_spike single 20";
			end
		end
		if ((v97.IceLance:IsReady() and v46 and ((v13:BuffUp(v97.FingersofFrostBuff) and not v13:PrevGCDP(1580 - (874 + 705), v97.GlacialSpike) and not v97.GlacialSpike:InFlight()) or v28(v105))) or ((310 + 1903) <= (970 + 451))) then
			if (((6356 - 3298) < (137 + 4723)) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
				return "ice_lance single 22";
			end
		end
		if ((v97.IceNova:IsCastable() and v47 and (v102 >= (683 - (642 + 37)))) or ((296 + 1000) >= (712 + 3734))) then
			if (v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova)) or ((3497 - 2104) > (4943 - (233 + 221)))) then
				return "ice_nova single 24";
			end
		end
		if ((v88 and ((v91 and v33) or not v91)) or ((10229 - 5805) < (24 + 3))) then
			if (v97.BagofTricks:IsCastable() or ((3538 - (718 + 823)) > (2401 + 1414))) then
				if (((4270 - (266 + 539)) > (5415 - 3502)) and v23(v97.BagofTricks, not v14:IsSpellInRange(v97.BagofTricks))) then
					return "bag_of_tricks cd 40";
				end
			end
		end
		if (((1958 - (636 + 589)) < (4317 - 2498)) and v97.Frostbolt:IsCastable() and v40) then
			if (v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true) or ((9064 - 4669) == (3769 + 986))) then
				return "frostbolt single 26";
			end
		end
		if ((v13:IsMoving() and v93) or ((1378 + 2415) < (3384 - (657 + 358)))) then
			local v192 = 0 - 0;
			while true do
				if ((v192 == (0 - 0)) or ((5271 - (1151 + 36)) == (256 + 9))) then
					v30 = v123();
					if (((1146 + 3212) == (13014 - 8656)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v127()
		v35 = EpicSettings.Settings['useArcaneExplosion'];
		v36 = EpicSettings.Settings['useArcaneIntellect'];
		v37 = EpicSettings.Settings['useBlizzard'];
		v38 = EpicSettings.Settings['useDragonsBreath'];
		v39 = EpicSettings.Settings['useFireBlast'];
		v40 = EpicSettings.Settings['useFrostbolt'];
		v41 = EpicSettings.Settings['useFrostNova'];
		v42 = EpicSettings.Settings['useFlurry'];
		v43 = EpicSettings.Settings['useFreezePet'];
		v44 = EpicSettings.Settings['useGlacialSpike'];
		v45 = EpicSettings.Settings['useIceFloes'];
		v46 = EpicSettings.Settings['useIceLance'];
		v47 = EpicSettings.Settings['useIceNova'];
		v48 = EpicSettings.Settings['useRayOfFrost'];
		v49 = EpicSettings.Settings['useCounterspell'];
		v50 = EpicSettings.Settings['useBlastWave'];
		v51 = EpicSettings.Settings['useIcyVeins'];
		v52 = EpicSettings.Settings['useFrozenOrb'];
		v53 = EpicSettings.Settings['useCometStorm'];
		v54 = EpicSettings.Settings['useConeOfCold'];
		v55 = EpicSettings.Settings['useShiftingPower'];
		v56 = EpicSettings.Settings['icyVeinsWithCD'];
		v57 = EpicSettings.Settings['frozenOrbWithCD'];
		v58 = EpicSettings.Settings['cometStormWithCD'];
		v59 = EpicSettings.Settings['coneOfColdWithCD'];
		v60 = EpicSettings.Settings['shiftingPowerWithCD'];
		v61 = EpicSettings.Settings['useAlterTime'];
		v62 = EpicSettings.Settings['useIceBarrier'];
		v63 = EpicSettings.Settings['useGreaterInvisibility'];
		v64 = EpicSettings.Settings['useIceBlock'];
		v65 = EpicSettings.Settings['useIceCold'];
		v66 = EpicSettings.Settings['useMassBarrier'];
		v67 = EpicSettings.Settings['useMirrorImage'];
		v68 = EpicSettings.Settings['alterTimeHP'] or (1832 - (1552 + 280));
		v69 = EpicSettings.Settings['iceBarrierHP'] or (834 - (64 + 770));
		v72 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v70 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v71 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v73 = EpicSettings.Settings['mirrorImageHP'] or (1243 - (157 + 1086));
		v74 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v92 = EpicSettings.Settings['useSpellStealTarget'];
		v93 = EpicSettings.Settings['useSpellsWhileMoving'];
		v94 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v95 = EpicSettings.Settings['mirrorImageBeforePull'];
		v96 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v128()
		local v180 = 0 - 0;
		while true do
			if ((v180 == (3 - 0)) or ((4282 - 1144) < (1812 - (599 + 220)))) then
				v91 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v83 = EpicSettings.Settings['useHealingPotion'];
				v180 = 7 - 3;
			end
			if (((5261 - (1813 + 118)) > (1699 + 624)) and (v180 == (1217 - (841 + 376)))) then
				v82 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v79 = EpicSettings.Settings['InterruptWithStun'];
				v80 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v180 = 1 + 0;
			end
			if ((v180 == (10 - 6)) or ((4485 - (464 + 395)) == (10237 - 6248))) then
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (837 - (467 + 370));
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v180 = 9 - 4;
			end
			if ((v180 == (4 + 1)) or ((3139 - 2223) == (417 + 2254))) then
				v77 = EpicSettings.Settings['handleAfflicted'];
				v78 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((632 - 360) == (792 - (150 + 370))) and (v180 == (1284 - (74 + 1208)))) then
				v89 = EpicSettings.Settings['useTrinkets'];
				v88 = EpicSettings.Settings['useRacials'];
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v180 = 7 - 4;
			end
			if (((20151 - 15902) <= (3444 + 1395)) and (v180 == (391 - (14 + 376)))) then
				v81 = EpicSettings.Settings['InterruptThreshold'];
				v76 = EpicSettings.Settings['DispelDebuffs'];
				v75 = EpicSettings.Settings['DispelBuffs'];
				v180 = 3 - 1;
			end
		end
	end
	local function v129()
		local v181 = 0 + 0;
		while true do
			if (((2440 + 337) < (3052 + 148)) and (v181 == (2 - 1))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				v181 = 2 + 0;
			end
			if (((173 - (23 + 55)) < (4637 - 2680)) and (v181 == (0 + 0))) then
				v127();
				v128();
				v31 = EpicSettings.Toggles['ooc'];
				v181 = 1 + 0;
			end
			if (((1280 - 454) < (541 + 1176)) and (v181 == (903 - (652 + 249)))) then
				if (((3816 - 2390) >= (2973 - (708 + 1160))) and v13:IsDeadOrGhost()) then
					return v30;
				end
				v103 = v14:GetEnemiesInSplashRange(13 - 8);
				v104 = v13:GetEnemiesInRange(72 - 32);
				v181 = 30 - (10 + 17);
			end
			if (((619 + 2135) <= (5111 - (1400 + 332))) and (v181 == (5 - 2))) then
				if (v32 or ((5835 - (242 + 1666)) == (605 + 808))) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (0 + 0)) or ((2094 - (850 + 90)) <= (1379 - 591))) then
							v101 = v29(v14:GetEnemiesInSplashRangeCount(1395 - (360 + 1030)), #v104);
							v102 = v29(v14:GetEnemiesInSplashRangeCount(5 + 0), #v104);
							break;
						end
					end
				else
					local v215 = 0 - 0;
					while true do
						if ((v215 == (0 - 0)) or ((3304 - (909 + 752)) > (4602 - (109 + 1114)))) then
							v101 = 1 - 0;
							v102 = 1 + 0;
							break;
						end
					end
				end
				if (not v13:AffectingCombat() or ((3045 - (6 + 236)) > (2867 + 1682))) then
					if ((v97.ArcaneIntellect:IsCastable() and v36 and (v13:BuffDown(v97.ArcaneIntellect, true) or v111.GroupBuffMissing(v97.ArcaneIntellect))) or ((178 + 42) >= (7126 - 4104))) then
						if (((4928 - 2106) == (3955 - (1076 + 57))) and v23(v97.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v111.TargetIsValid() or v13:AffectingCombat() or ((175 + 886) == (2546 - (579 + 110)))) then
					v108 = v9.BossFightRemains(nil, true);
					v109 = v108;
					if (((218 + 2542) > (1206 + 158)) and (v109 == (5897 + 5214))) then
						v109 = v9.FightRemains(v104, false);
					end
					v105 = v14:DebuffStack(v97.WintersChillDebuff);
					v106 = v13:BuffStackP(v97.IciclesBuff);
					v110 = v13:GCD();
				end
				v181 = 411 - (174 + 233);
			end
			if (((11 - 7) == v181) or ((8603 - 3701) <= (1599 + 1996))) then
				if (v111.TargetIsValid() or ((5026 - (663 + 511)) == (262 + 31))) then
					local v216 = 0 + 0;
					while true do
						if ((v216 == (5 - 3)) or ((945 + 614) == (10801 - 6213))) then
							if (v13:AffectingCombat() or v76 or ((10854 - 6370) == (377 + 411))) then
								local v217 = 0 - 0;
								local v218;
								while true do
									if (((3256 + 1312) >= (358 + 3549)) and (v217 == (723 - (478 + 244)))) then
										if (((1763 - (440 + 77)) < (1578 + 1892)) and v30) then
											return v30;
										end
										break;
									end
									if (((14889 - 10821) >= (2528 - (655 + 901))) and (v217 == (0 + 0))) then
										v218 = v76 and v97.RemoveCurse:IsReady() and v34;
										v30 = v111.FocusUnit(v218, v99, 16 + 4, nil, 14 + 6);
										v217 = 3 - 2;
									end
								end
							end
							if (((1938 - (695 + 750)) < (13293 - 9400)) and v77) then
								if (v96 or ((2272 - 799) >= (13400 - 10068))) then
									local v222 = 351 - (285 + 66);
									while true do
										if ((v222 == (0 - 0)) or ((5361 - (682 + 628)) <= (187 + 970))) then
											v30 = v111.HandleAfflicted(v97.RemoveCurse, v99.RemoveCurseMouseover, 329 - (176 + 123));
											if (((253 + 351) < (2090 + 791)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v216 = 272 - (239 + 30);
						end
						if ((v216 == (1 + 0)) or ((866 + 34) == (5977 - 2600))) then
							v30 = v118();
							if (((13911 - 9452) > (906 - (306 + 9))) and v30) then
								return v30;
							end
							v216 = 6 - 4;
						end
						if (((591 + 2807) >= (1470 + 925)) and (v216 == (0 + 0))) then
							if (v15 or ((6242 - 4059) >= (4199 - (1140 + 235)))) then
								if (((1233 + 703) == (1776 + 160)) and v76) then
									v30 = v119();
									if (v30 or ((1241 + 3591) < (4365 - (33 + 19)))) then
										return v30;
									end
								end
							end
							if (((1477 + 2611) > (11611 - 7737)) and not v13:AffectingCombat() and v31) then
								local v219 = 0 + 0;
								while true do
									if (((8495 - 4163) == (4063 + 269)) and (v219 == (689 - (586 + 103)))) then
										v30 = v121();
										if (((365 + 3634) >= (8928 - 6028)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							v216 = 1489 - (1309 + 179);
						end
						if ((v216 == (6 - 2)) or ((1100 + 1425) > (10914 - 6850))) then
							if (((3302 + 1069) == (9286 - 4915)) and v13:AffectingCombat() and v111.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
								local v220 = 0 - 0;
								while true do
									if ((v220 == (610 - (295 + 314))) or ((653 - 387) > (6948 - (1300 + 662)))) then
										if (((6251 - 4260) >= (2680 - (1178 + 577))) and v32 and (v102 == (2 + 0))) then
											v30 = v125();
											if (((1344 - 889) < (3458 - (851 + 554))) and v30) then
												return v30;
											end
											if (v23(v97.Pool) or ((731 + 95) == (13453 - 8602))) then
												return "pool for Cleave()";
											end
										end
										v30 = v126();
										v220 = 3 - 1;
									end
									if (((485 - (115 + 187)) == (141 + 42)) and (v220 == (3 + 0))) then
										if (((4567 - 3408) <= (2949 - (160 + 1001))) and v93) then
											local v223 = 0 + 0;
											while true do
												if (((0 + 0) == v223) or ((7178 - 3671) > (4676 - (237 + 121)))) then
													v30 = v123();
													if (v30 or ((3972 - (525 + 372)) <= (5620 - 2655))) then
														return v30;
													end
													break;
												end
											end
										end
										break;
									end
									if (((4484 - 3119) <= (2153 - (96 + 46))) and (v220 == (779 - (643 + 134)))) then
										if (v30 or ((1003 + 1773) > (8571 - 4996))) then
											return v30;
										end
										if (v23(v97.Pool) or ((9482 - 6928) == (4608 + 196))) then
											return "pool for ST()";
										end
										v220 = 5 - 2;
									end
									if (((5267 - 2690) == (3296 - (316 + 403))) and (v220 == (0 + 0))) then
										if (v33 or ((16 - 10) >= (683 + 1206))) then
											local v224 = 0 - 0;
											while true do
												if (((359 + 147) <= (610 + 1282)) and (v224 == (0 - 0))) then
													v30 = v122();
													if (v30 or ((9589 - 7581) > (4607 - 2389))) then
														return v30;
													end
													break;
												end
											end
										end
										if (((22 + 357) <= (8163 - 4016)) and v32 and (((v102 >= (1 + 6)) and not v13:HasTier(88 - 58, 19 - (12 + 5))) or ((v102 >= (11 - 8)) and v97.IceCaller:IsAvailable()))) then
											local v225 = 0 - 0;
											while true do
												if ((v225 == (1 - 0)) or ((11193 - 6679) <= (205 + 804))) then
													if (v23(v97.Pool) or ((5469 - (1656 + 317)) == (1063 + 129))) then
														return "pool for Aoe()";
													end
													break;
												end
												if ((v225 == (0 + 0)) or ((552 - 344) == (14562 - 11603))) then
													v30 = v124();
													if (((4631 - (5 + 349)) >= (6236 - 4923)) and v30) then
														return v30;
													end
													v225 = 1272 - (266 + 1005);
												end
											end
										end
										v220 = 1 + 0;
									end
								end
							end
							break;
						end
						if (((8827 - 6240) < (4177 - 1003)) and (v216 == (1699 - (561 + 1135)))) then
							if (v78 or ((5369 - 1249) <= (7225 - 5027))) then
								local v221 = 1066 - (507 + 559);
								while true do
									if ((v221 == (0 - 0)) or ((4935 - 3339) == (1246 - (212 + 176)))) then
										v30 = v111.HandleIncorporeal(v97.Polymorph, v99.PolymorphMouseOver, 935 - (250 + 655), true);
										if (((8780 - 5560) == (5626 - 2406)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v97.Spellsteal:IsAvailable() and v92 and v97.Spellsteal:IsReady() and v34 and v75 and not v13:IsCasting() and not v13:IsChanneling() and v111.UnitHasMagicBuff(v14)) or ((2193 - 791) > (5576 - (1869 + 87)))) then
								if (((8927 - 6353) == (4475 - (484 + 1417))) and v23(v97.Spellsteal, not v14:IsSpellInRange(v97.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v216 = 8 - 4;
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		v112();
		v21.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(107 - 43, v129, v130);
end;
return v0["Epix_Mage_Frost.lua"]();

