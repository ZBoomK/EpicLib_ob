local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 692 - (589 + 103);
	local v6;
	while true do
		if ((v5 == (1034 - (125 + 909))) or ((5273 - (1096 + 852)) > (1558 + 1913))) then
			v6 = v0[v4];
			if (((4616 - 1383) == (3136 + 97)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 513 - (409 + 103);
		end
		if (((1700 - (46 + 190)) <= (4472 - (51 + 44))) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.PressCursor;
	local v26 = v22.Macro;
	local v27 = v22.Bind;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = math.max;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v97;
	local v98 = v19.Mage.Frost;
	local v99 = v21.Mage.Frost;
	local v100 = v26.Mage.Frost;
	local v101 = {};
	local v102, v103;
	local v104;
	local v105;
	local v106 = 1317 - (1114 + 203);
	local v107 = 726 - (228 + 498);
	local v108 = 4 + 11;
	local v109 = 6139 + 4972;
	local v110 = 11774 - (174 + 489);
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (((7005 - 4316) < (6628 - (830 + 1075))) and v98.RemoveCurse:IsAvailable()) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(85245 - (303 + 221));
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(229866 - (231 + 1038));
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(190290 + 38064);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(229760 - (171 + 991));
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(942107 - 713507);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v109 = 29835 - 18724;
		v110 = 27726 - 16615;
		v106 = 0 + 0;
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		local v133 = 0 - 0;
		while true do
			if (((11931 - 7795) >= (3863 - 1466)) and (v133 == (0 - 0))) then
				if ((v132 == nil) or ((5582 - (111 + 1137)) == (4403 - (91 + 67)))) then
					v132 = v15;
				end
				return not v132:IsInBossList() or (v132:Level() < (217 - 144));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v134)
		local v135 = 0 + 0;
		local v136;
		while true do
			if ((v135 == (524 - (423 + 100))) or ((31 + 4245) <= (8392 - 5361))) then
				for v209, v210 in pairs(v134) do
					v136 = v136 + v210:DebuffStack(v98.WintersChillDebuff);
				end
				return v136;
			end
			if ((v135 == (0 + 0)) or ((5553 - (326 + 445)) <= (5232 - 4033))) then
				if ((v98.WintersChillDebuff:AuraActiveCount() == (0 - 0)) or ((11353 - 6489) < (2613 - (530 + 181)))) then
					return 881 - (614 + 267);
				end
				v136 = 32 - (19 + 13);
				v135 = 1 - 0;
			end
		end
	end
	local function v117(v137)
		return (v137:DebuffStack(v98.WintersChillDebuff));
	end
	local function v118(v138)
		return (v138:DebuffDown(v98.WintersChillDebuff));
	end
	local function v119()
		if (((11276 - 6437) >= (10569 - 6869)) and v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
			if (v24(v98.IceBarrier) or ((280 + 795) > (3372 - 1454))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((820 - 424) <= (5616 - (1293 + 519))) and v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 3 - 1)) then
			if (v24(v98.MassBarrier) or ((10884 - 6715) == (4182 - 1995))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((6062 - 4656) == (3311 - 1905)) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
			if (((811 + 720) < (872 + 3399)) and v24(v98.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((1475 - 840) == (147 + 488)) and v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
			if (((1121 + 2252) <= (2223 + 1333)) and v24(v98.IceBlock)) then
				return "ice_block defensive 4";
			end
		end
		if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((4387 - (709 + 387)) < (5138 - (673 + 1185)))) then
			if (((12719 - 8333) >= (2803 - 1930)) and v24(v98.MirrorImage)) then
				return "mirror_image defensive 5";
			end
		end
		if (((1514 - 593) <= (789 + 313)) and v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
			if (((3517 + 1189) >= (1299 - 336)) and v24(v98.GreaterInvisibility)) then
				return "greater_invisibility defensive 6";
			end
		end
		if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((236 + 724) <= (1746 - 870))) then
			if (v24(v98.AlterTime) or ((4055 - 1989) == (2812 - (446 + 1434)))) then
				return "alter_time defensive 7";
			end
		end
		if (((6108 - (1040 + 243)) < (14454 - 9611)) and v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
			if (v24(v100.Healthstone) or ((5724 - (559 + 1288)) >= (6468 - (609 + 1322)))) then
				return "healthstone defensive";
			end
		end
		if ((v84 and (v14:HealthPercentage() <= v86)) or ((4769 - (13 + 441)) < (6449 - 4723))) then
			local v148 = 0 - 0;
			while true do
				if ((v148 == (0 - 0)) or ((137 + 3542) < (2269 - 1644))) then
					if ((v88 == "Refreshing Healing Potion") or ((1643 + 2982) < (277 + 355))) then
						if (v99.RefreshingHealingPotion:IsReady() or ((246 - 163) > (975 + 805))) then
							if (((1003 - 457) <= (713 + 364)) and v24(v100.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((554 + 442) > (3091 + 1210))) then
						if (((3418 + 652) > (673 + 14)) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v100.RefreshingHealingPotion) or ((1089 - (153 + 280)) >= (9615 - 6285))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v120()
		if ((v98.RemoveCurse:IsReady() and v35 and v112.DispellableFriendlyUnit(18 + 2)) or ((984 + 1508) <= (176 + 159))) then
			if (((3923 + 399) >= (1857 + 705)) and v24(v100.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v121()
		v31 = v112.HandleTopTrinket(v101, v34, 60 - 20, nil);
		if (v31 or ((2248 + 1389) >= (4437 - (89 + 578)))) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 29 + 11, nil);
		if (v31 or ((4945 - 2566) > (5627 - (572 + 477)))) then
			return v31;
		end
	end
	local function v122()
		if (v112.TargetIsValid() or ((66 + 417) > (446 + 297))) then
			local v149 = 0 + 0;
			while true do
				if (((2540 - (84 + 2)) > (952 - 374)) and ((0 + 0) == v149)) then
					if (((1772 - (497 + 345)) < (115 + 4343)) and v98.MirrorImage:IsCastable() and v68 and v96) then
						if (((112 + 550) <= (2305 - (605 + 728))) and v24(v98.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if (((3118 + 1252) == (9715 - 5345)) and v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
						if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt)) or ((219 + 4543) <= (3183 - 2322))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		if ((v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 + 0, v98.IcyVeins)) or ((3911 - 2499) == (3220 + 1044))) then
			if (v24(v98.TimeWarp, not v15:IsInRange(529 - (457 + 32))) or ((1345 + 1823) < (3555 - (832 + 570)))) then
				return "time_warp cd 2";
			end
		end
		local v139 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
		if (v139 or ((4688 + 288) < (348 + 984))) then
			return v139;
		end
		if (((16377 - 11749) == (2230 + 2398)) and v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
			if (v24(v98.IcyVeins) or ((850 - (588 + 208)) == (1064 - 669))) then
				return "icy_veins cd 6";
			end
		end
		if (((1882 - (884 + 916)) == (171 - 89)) and (v83 < v110)) then
			if ((v90 and ((v34 and v91) or not v91)) or ((337 + 244) < (935 - (232 + 421)))) then
				local v211 = 1889 - (1569 + 320);
				while true do
					if (((0 + 0) == v211) or ((876 + 3733) < (8407 - 5912))) then
						v31 = v121();
						if (((1757 - (316 + 289)) == (3015 - 1863)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if (((88 + 1808) <= (4875 - (666 + 787))) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
			local v150 = 425 - (360 + 65);
			while true do
				if (((2 + 0) == v150) or ((1244 - (79 + 175)) > (2554 - 934))) then
					if (v98.AncestralCall:IsCastable() or ((685 + 192) > (14391 - 9696))) then
						if (((5182 - 2491) >= (2750 - (503 + 396))) and v24(v98.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
				if ((v150 == (182 - (92 + 89))) or ((5790 - 2805) >= (2491 + 2365))) then
					if (((2531 + 1745) >= (4679 - 3484)) and v98.LightsJudgment:IsCastable()) then
						if (((442 + 2790) <= (10693 - 6003)) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (v98.Fireblood:IsCastable() or ((782 + 114) >= (1503 + 1643))) then
						if (((9322 - 6261) >= (370 + 2588)) and v24(v98.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v150 = 2 - 0;
				end
				if (((4431 - (485 + 759)) >= (1489 - 845)) and (v150 == (1189 - (442 + 747)))) then
					if (((1779 - (832 + 303)) <= (1650 - (88 + 858))) and v98.BloodFury:IsCastable()) then
						if (((292 + 666) > (784 + 163)) and v24(v98.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((186 + 4306) >= (3443 - (766 + 23))) and v98.Berserking:IsCastable()) then
						if (((16992 - 13550) >= (2054 - 551)) and v24(v98.Berserking)) then
							return "berserking cd 12";
						end
					end
					v150 = 2 - 1;
				end
			end
		end
	end
	local function v124()
		if ((v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or ((10759 - 7589) <= (2537 - (1036 + 37)))) then
			if (v24(v98.IceFloes) or ((3401 + 1396) == (8544 - 4156))) then
				return "ice_floes movement";
			end
		end
		if (((434 + 117) <= (2161 - (641 + 839))) and v98.IceNova:IsCastable() and v48) then
			if (((4190 - (910 + 3)) > (1037 - 630)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova movement";
			end
		end
		if (((6379 - (1466 + 218)) >= (651 + 764)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1178 - (556 + 592))) and (v103 >= (1 + 1))) then
			if (v24(v98.ArcaneExplosion, not v15:IsInRange(838 - (329 + 479))) or ((4066 - (174 + 680)) <= (3243 - 2299))) then
				return "arcane_explosion movement";
			end
		end
		if ((v98.FireBlast:IsCastable() and UseFireblast) or ((6416 - 3320) <= (1284 + 514))) then
			if (((4276 - (396 + 343)) == (313 + 3224)) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
				return "fire_blast movement";
			end
		end
		if (((5314 - (29 + 1448)) >= (2959 - (135 + 1254))) and v98.IceLance:IsCastable() and v47) then
			if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((11113 - 8163) == (17798 - 13986))) then
				return "ice_lance movement";
			end
		end
	end
	local function v125()
		if (((3148 + 1575) >= (3845 - (389 + 1138))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(575 - (102 + 472), v98.CometStorm) or (v14:PrevGCDP(1 + 0, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
			if (v24(v98.ConeofCold) or ((1125 + 902) > (2660 + 192))) then
				return "cone_of_cold aoe 2";
			end
		end
		if ((v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1546 - (320 + 1225), v98.GlacialSpike) or not v114())) or ((2021 - 885) > (2642 + 1675))) then
			if (((6212 - (157 + 1307)) == (6607 - (821 + 1038))) and v24(v100.FrozenOrbCast, not v15:IsInRange(99 - 59))) then
				return "frozen_orb aoe 4";
			end
		end
		if (((409 + 3327) <= (8419 - 3679)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) then
			if (v24(v100.BlizzardCursor, not v15:IsInRange(99 - 59)) or ((4416 - (834 + 192)) <= (195 + 2865))) then
				return "blizzard aoe 6";
			end
		end
		if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (1 + 24))) or (v98.ConeofCold:CooldownRemains() > (30 - 10)))) or ((1303 - (300 + 4)) > (720 + 1973))) then
			if (((1211 - 748) < (963 - (112 + 250))) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
				return "comet_storm aoe 8";
			end
		end
		if ((v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 + 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(2 - 1, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or ((1251 + 932) < (356 + 331))) then
			if (((3403 + 1146) == (2256 + 2293)) and v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze))) then
				return "freeze aoe 10";
			end
		end
		if (((3471 + 1201) == (6086 - (1001 + 413))) and v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(2 - 1, v98.Freeze) and (v14:PrevGCDP(883 - (244 + 638), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (694 - (627 + 66)))))) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((10929 - 7261) < (997 - (512 + 90)))) then
				return "ice_nova aoe 11";
			end
		end
		if ((v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1907 - (1665 + 241), v98.Freeze) and ((v14:PrevGCDP(718 - (373 + 344), v98.GlacialSpike) and (v106 == (0 + 0))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) or ((10988 - 6822) == (769 - 314))) then
			if (v24(v98.FrostNova) or ((5548 - (35 + 1064)) == (1938 + 725))) then
				return "frost_nova aoe 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or ((9150 - 4873) < (12 + 2977))) then
			if (v24(v98.ConeofCold) or ((2106 - (298 + 938)) >= (5408 - (233 + 1026)))) then
				return "cone_of_cold aoe 14";
			end
		end
		if (((3878 - (636 + 1030)) < (1628 + 1555)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) then
			if (((4539 + 107) > (889 + 2103)) and v24(v98.ShiftingPower, not v15:IsInRange(3 + 37), true)) then
				return "shifting_power aoe 16";
			end
		end
		if (((1655 - (55 + 166)) < (602 + 2504)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (1 + 4)) and (v98.Blizzard:CooldownRemains() > v111)) then
			if (((3001 - 2215) < (3320 - (36 + 261))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike aoe 18";
			end
		end
		if ((v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (0 - 0)) and (v14:PrevGCDP(1369 - (34 + 1334), v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (1.8 + 0)))) or ((1898 + 544) < (1357 - (1035 + 248)))) then
			if (((4556 - (20 + 1)) == (2363 + 2172)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
				return "flurry aoe 20";
			end
		end
		if ((v98.Flurry:IsCastable() and v43 and (v106 == (319 - (134 + 185))) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) or ((4142 - (549 + 584)) <= (2790 - (314 + 371)))) then
			if (((6282 - 4452) < (4637 - (478 + 490))) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
				return "flurry aoe 21";
			end
		end
		if ((v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) or ((758 + 672) >= (4784 - (786 + 386)))) then
			if (((8689 - 6006) >= (3839 - (1055 + 324))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance aoe 22";
			end
		end
		if ((v98.IceNova:IsCastable() and v48 and (v102 >= (1344 - (1093 + 247))) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) or ((1604 + 200) >= (345 + 2930))) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((5625 - 4208) > (12315 - 8686))) then
				return "ice_nova aoe 23";
			end
		end
		if (((13644 - 8849) > (1010 - 608)) and v98.DragonsBreath:IsCastable() and v39 and (v103 >= (3 + 4))) then
			if (((18541 - 13728) > (12287 - 8722)) and v24(v98.DragonsBreath)) then
				return "dragons_breath aoe 26";
			end
		end
		if (((2950 + 962) == (10004 - 6092)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (718 - (364 + 324))) and (v103 >= (19 - 12))) then
			if (((6769 - 3948) <= (1599 + 3225)) and v24(v98.ArcaneExplosion, not v15:IsInRange(125 - 95))) then
				return "arcane_explosion aoe 28";
			end
		end
		if (((2783 - 1045) <= (6666 - 4471)) and v98.Frostbolt:IsCastable() and v41) then
			if (((1309 - (1249 + 19)) <= (2725 + 293)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt aoe 32";
			end
		end
		if (((8349 - 6204) <= (5190 - (686 + 400))) and v14:IsMoving() and v94) then
			local v151 = 0 + 0;
			local v152;
			while true do
				if (((2918 - (73 + 156)) < (23 + 4822)) and (v151 == (811 - (721 + 90)))) then
					v152 = v124();
					if (v152 or ((27 + 2295) > (8513 - 5891))) then
						return v152;
					end
					break;
				end
			end
		end
	end
	local function v126()
		if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(471 - (224 + 246), v98.Flurry) or v14:PrevGCDP(1 - 0, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((8347 - 3813) == (378 + 1704))) then
			if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((38 + 1533) > (1372 + 495))) then
				return "comet_storm cleave 2";
			end
		end
		if ((v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 - 0, v98.Frostbolt) and (v107 >= (9 - 6))) or v14:PrevGCDP(514 - (203 + 310), v98.GlacialSpike) or ((v107 >= (1996 - (1238 + 755))) and (v107 < (1 + 4)) and (v98.Flurry:ChargesFractional() == (1536 - (709 + 825)))))) or ((4890 - 2236) >= (4363 - 1367))) then
			if (((4842 - (196 + 668)) > (8306 - 6202)) and v112.CastTargetIf(v98.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v98.Flurry))) then
				return "flurry cleave 4";
			end
		end
		if (((6203 - 3208) > (2374 - (171 + 662))) and v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (93 - (4 + 89))) and (v107 == (13 - 9)) and v14:BuffUp(v98.FingersofFrostBuff)) then
			if (((1184 + 2065) > (4185 - 3232)) and v112.CastTargetIf(v98.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance cleave 6";
			end
		end
		if ((v98.RayofFrost:IsCastable() and (v106 == (1 + 0)) and v49) or ((4759 - (35 + 1451)) > (6026 - (28 + 1425)))) then
			if (v112.CastTargetIf(v98.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v98.RayofFrost)) or ((5144 - (941 + 1052)) < (1232 + 52))) then
				return "ray_of_frost cleave 8";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (1519 - (822 + 692))) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) or ((872 + 978) == (1826 - (45 + 252)))) then
			if (((813 + 8) < (731 + 1392)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 10";
			end
		end
		if (((2194 - 1292) < (2758 - (114 + 319))) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (2 - 0)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
			if (((1098 - 240) <= (1889 + 1073)) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (14 - 4)) and (v98.FrozenOrb:CooldownRemains() > (20 - 10)) and (v106 == (1963 - (556 + 1407))) and (v103 >= (1209 - (741 + 465)))) or ((4411 - (170 + 295)) < (679 + 609))) then
			if (v24(v98.ConeofCold, not v15:IsSpellInRange(v98.ConeofCold)) or ((2978 + 264) == (1395 - 828))) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (2 + 0)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (2 + 1)))) or ((480 + 367) >= (2493 - (957 + 273)))) then
			if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((603 + 1650) == (741 + 1110))) then
				return "blizzard cleave 16";
			end
		end
		if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (38 - 28)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (26 - 16))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (30 - 20)))) or (v98.IcyVeins:CooldownRemains() < (99 - 79)))) or ((3867 - (389 + 1391)) > (1489 + 883))) then
			if (v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true) or ((463 + 3982) < (9445 - 5296))) then
				return "shifting_power cleave 18";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (956 - (783 + 168)))) or ((6101 - 4283) == (84 + 1))) then
			if (((941 - (309 + 2)) < (6531 - 4404)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 20";
			end
		end
		if ((v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(1213 - (1090 + 122), v98.GlacialSpike)) or (v106 > (0 + 0)))) or ((6508 - 4570) == (1721 + 793))) then
			if (((5373 - (628 + 490)) >= (10 + 45)) and v112.CastTargetIf(v98.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance cleave 22";
			end
		end
		if (((7424 - 4425) > (5282 - 4126)) and v98.IceNova:IsCastable() and v48 and (v103 >= (778 - (431 + 343)))) then
			if (((4746 - 2396) > (3341 - 2186)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova cleave 24";
			end
		end
		if (((3183 + 846) <= (621 + 4232)) and v98.Frostbolt:IsCastable() and v41) then
			if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((2211 - (556 + 1139)) > (3449 - (6 + 9)))) then
				return "frostbolt cleave 26";
			end
		end
		if (((741 + 3305) >= (1554 + 1479)) and v14:IsMoving() and v94) then
			local v153 = v124();
			if (v153 or ((2888 - (28 + 141)) <= (561 + 886))) then
				return v153;
			end
		end
	end
	local function v127()
		local v140 = 0 - 0;
		while true do
			if (((0 + 0) == v140) or ((5451 - (486 + 831)) < (10216 - 6290))) then
				if ((v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(3 - 2, v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold))) or ((518 - 354) >= (4048 - (668 + 595)))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((473 + 52) == (426 + 1683))) then
						return "comet_storm single 2";
					end
				end
				if (((89 - 56) == (323 - (23 + 267))) and v98.Flurry:IsCastable() and (v106 == (1944 - (1129 + 815))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(388 - (371 + 16), v98.Frostbolt) and (v107 >= (1753 - (1326 + 424)))) or (v14:PrevGCDP(1 - 0, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(3 - 2, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (122 - (88 + 30))) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (((3825 - (720 + 51)) <= (8931 - 4916)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if (((3647 - (421 + 1355)) < (5578 - 2196)) and v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 + 0)) and (v107 == (1087 - (286 + 797))) and v14:BuffUp(v98.FingersofFrostBuff)) then
					if (((4726 - 3433) <= (3587 - 1421)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v140 = 440 - (397 + 42);
			end
			if ((v140 == (1 + 0)) or ((3379 - (24 + 776)) < (189 - 66))) then
				if ((v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (786 - (222 + 563)))) or ((1863 - 1017) >= (1705 + 663))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((4202 - (23 + 167)) <= (5156 - (690 + 1108)))) then
						return "ray_of_frost single 8";
					end
				end
				if (((540 + 954) <= (2479 + 526)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (853 - (40 + 808))) and ((v98.Flurry:Charges() >= (1 + 0)) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((2974 + 137) == (1129 + 1005))) then
						return "glacial_spike single 10";
					end
				end
				if (((1292 + 1063) == (2926 - (47 + 524))) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 + 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (5 - 3)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(59 - 19)) or ((1340 - 752) <= (2158 - (1165 + 561)))) then
						return "frozen_orb single 12";
					end
				end
				v140 = 1 + 1;
			end
			if (((14857 - 10060) >= (1487 + 2408)) and (v140 == (482 - (341 + 138)))) then
				if (((966 + 2611) == (7381 - 3804)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (331 - (89 + 237)))) then
					if (((12205 - 8411) > (7774 - 4081)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(882 - (581 + 300), v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((2495 - (855 + 365)) == (9738 - 5638))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((520 + 1071) >= (4815 - (1030 + 205)))) then
						return "ice_lance single 22";
					end
				end
				if (((923 + 60) <= (1682 + 126)) and v98.IceNova:IsCastable() and v48 and (v103 >= (290 - (156 + 130)))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((4885 - 2735) <= (2016 - 819))) then
						return "ice_nova single 24";
					end
				end
				v140 = 7 - 3;
			end
			if (((994 + 2775) >= (685 + 488)) and ((71 - (10 + 59)) == v140)) then
				if (((420 + 1065) == (7313 - 5828)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (1173 - (671 + 492))) and (v98.FrozenOrb:CooldownRemains() > (8 + 2)) and (v106 == (1215 - (369 + 846))) and (v102 >= (1 + 2))) then
					if (v24(v98.ConeofCold) or ((2830 + 485) <= (4727 - (1036 + 909)))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (2 + 0)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (4 - 1)))) or ((1079 - (11 + 192)) >= (1498 + 1466))) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(215 - (135 + 40))) or ((5407 - 3175) > (1506 + 991))) then
						return "blizzard single 16";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 - 0)) and (((v98.FrozenOrb:CooldownRemains() > (14 - 4)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (186 - (50 + 126)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (27 - 17)))) or (v98.IcyVeins:CooldownRemains() < (5 + 15)))) or ((3523 - (1233 + 180)) <= (1301 - (522 + 447)))) then
					if (((5107 - (107 + 1314)) > (1472 + 1700)) and v24(v98.ShiftingPower, not v15:IsInRange(121 - 81))) then
						return "shifting_power single 18";
					end
				end
				v140 = 2 + 1;
			end
			if ((v140 == (7 - 3)) or ((17701 - 13227) < (2730 - (716 + 1194)))) then
				if (((74 + 4205) >= (309 + 2573)) and v89 and ((v92 and v34) or not v92)) then
					if (v98.BagofTricks:IsCastable() or ((2532 - (74 + 429)) >= (6792 - 3271))) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((1010 + 1027) >= (10625 - 5983))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((1217 + 503) < (13743 - 9285)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((1077 - 641) > (3454 - (279 + 154)))) then
						return "frostbolt single 26";
					end
				end
				if (((1491 - (454 + 324)) <= (667 + 180)) and v14:IsMoving() and v94) then
					local v212 = v124();
					if (((2171 - (12 + 5)) <= (2174 + 1857)) and v212) then
						return v212;
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v141 = 0 - 0;
		while true do
			if (((1706 + 2909) == (5708 - (277 + 816))) and (v141 == (4 - 3))) then
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v141 = 1185 - (1058 + 125);
			end
			if ((v141 == (2 + 4)) or ((4765 - (815 + 160)) == (2145 - 1645))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
				v141 = 20 - 13;
			end
			if (((1987 - (41 + 1857)) < (2114 - (1222 + 671))) and (v141 == (0 - 0))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v141 = 1 - 0;
			end
			if (((3236 - (229 + 953)) >= (3195 - (1111 + 663))) and (v141 == (1587 - (874 + 705)))) then
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((97 + 595) < (2087 + 971)) and (v141 == (7 - 3))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v141 = 1 + 4;
			end
			if ((v141 == (686 - (642 + 37))) or ((742 + 2512) == (265 + 1390))) then
				v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (454 - (233 + 221));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (1541 - (718 + 823));
				v141 = 6 + 2;
			end
			if ((v141 == (810 - (266 + 539))) or ((3668 - 2372) == (6135 - (636 + 589)))) then
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v141 = 14 - 8;
			end
			if (((6946 - 3578) == (2670 + 698)) and (v141 == (1 + 1))) then
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v141 = 1018 - (657 + 358);
			end
			if (((6997 - 4354) < (8691 - 4876)) and (v141 == (1190 - (1151 + 36)))) then
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v141 = 4 + 0;
			end
		end
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if (((5712 - 3799) > (2325 - (1552 + 280))) and (v142 == (836 - (64 + 770)))) then
				v90 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v91 = EpicSettings.Settings['trinketsWithCD'];
				v142 = 3 + 0;
			end
			if (((10794 - 6039) > (609 + 2819)) and (v142 == (1248 - (157 + 1086)))) then
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2763 - 1382) <= (10375 - 8006)) and (v142 == (5 - 1))) then
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (819 - (599 + 220));
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v142 = 9 - 4;
			end
			if ((v142 == (1934 - (1813 + 118))) or ((3541 + 1302) == (5301 - (841 + 376)))) then
				v92 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['useHealingPotion'];
				v142 = 5 - 1;
			end
			if (((1085 + 3584) > (990 - 627)) and (v142 == (860 - (464 + 395)))) then
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v142 = 5 - 3;
			end
			if ((v142 == (0 + 0)) or ((2714 - (467 + 370)) >= (6484 - 3346))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v142 = 3 - 2;
			end
		end
	end
	local function v130()
		local v143 = 0 + 0;
		while true do
			if (((11032 - 6290) >= (4146 - (150 + 370))) and ((1282 - (74 + 1208)) == v143)) then
				v128();
				v129();
				v32 = EpicSettings.Toggles['ooc'];
				v143 = 2 - 1;
			end
			if (((9 - 7) == v143) or ((3231 + 1309) == (1306 - (14 + 376)))) then
				if (v14:IsDeadOrGhost() or ((2004 - 848) > (2812 + 1533))) then
					return;
				end
				v105 = v15:GetEnemiesInSplashRange(5 + 0);
				Enemies40yRange = v14:GetEnemiesInRange(39 + 1);
				v143 = 8 - 5;
			end
			if (((1683 + 554) < (4327 - (23 + 55))) and (v143 == (6 - 3))) then
				if (v33 or ((1791 + 892) < (21 + 2))) then
					local v213 = 0 - 0;
					while true do
						if (((220 + 477) <= (1727 - (652 + 249))) and (v213 == (0 - 0))) then
							v102 = v30(v15:GetEnemiesInSplashRangeCount(1873 - (708 + 1160)), #Enemies40yRange);
							v103 = v30(v15:GetEnemiesInSplashRangeCount(13 - 8), #Enemies40yRange);
							break;
						end
					end
				else
					v104 = 1 - 0;
					v102 = 28 - (10 + 17);
					v103 = 1 + 0;
				end
				if (((2837 - (1400 + 332)) <= (2255 - 1079)) and not v14:AffectingCombat()) then
					if (((5287 - (242 + 1666)) <= (1632 + 2180)) and v98.ArcaneIntellect:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
						if (v24(v98.ArcaneIntellect) or ((289 + 499) >= (1378 + 238))) then
							return "arcane_intellect";
						end
					end
				end
				if (((2794 - (850 + 90)) <= (5917 - 2538)) and (v112.TargetIsValid() or v14:AffectingCombat())) then
					local v214 = 1390 - (360 + 1030);
					while true do
						if (((4026 + 523) == (12839 - 8290)) and ((1 - 0) == v214)) then
							if ((v110 == (12772 - (909 + 752))) or ((4245 - (109 + 1114)) >= (5536 - 2512))) then
								v110 = v10.FightRemains(Enemies40yRange, false);
							end
							v106 = v15:DebuffStack(v98.WintersChillDebuff);
							v214 = 1 + 1;
						end
						if (((5062 - (6 + 236)) > (1385 + 813)) and (v214 == (0 + 0))) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v214 = 2 - 1;
						end
						if ((v214 == (3 - 1)) or ((2194 - (1076 + 57)) >= (805 + 4086))) then
							v107 = v14:BuffStackP(v98.IciclesBuff);
							v111 = v14:GCD();
							break;
						end
					end
				end
				v143 = 693 - (579 + 110);
			end
			if (((108 + 1256) <= (3955 + 518)) and ((1 + 0) == v143)) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v143 = 409 - (174 + 233);
			end
			if ((v143 == (11 - 7)) or ((6309 - 2714) <= (2 + 1))) then
				if (v112.TargetIsValid() or ((5846 - (663 + 511)) == (3437 + 415))) then
					local v215 = 0 + 0;
					while true do
						if (((4806 - 3247) == (945 + 614)) and (v215 == (0 - 0))) then
							if (v16 or ((4240 - 2488) <= (377 + 411))) then
								if (v77 or ((7604 - 3697) == (127 + 50))) then
									v31 = v120();
									if (((318 + 3152) > (1277 - (478 + 244))) and v31) then
										return v31;
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((1489 - (440 + 77)) == (294 + 351))) then
								local v216 = 0 - 0;
								while true do
									if (((4738 - (655 + 901)) >= (393 + 1722)) and (v216 == (0 + 0))) then
										v31 = v122();
										if (((2629 + 1264) < (17842 - 13413)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							v215 = 1446 - (695 + 750);
						end
						if ((v215 == (6 - 4)) or ((4424 - 1557) < (7661 - 5756))) then
							if (v14:AffectingCombat() or v77 or ((2147 - (285 + 66)) >= (9443 - 5392))) then
								local v217 = 1310 - (682 + 628);
								local v218;
								while true do
									if (((261 + 1358) <= (4055 - (176 + 123))) and (v217 == (0 + 0))) then
										v218 = v77 and v98.RemoveCurse:IsReady() and v35;
										v31 = v112.FocusUnit(v218, v100, 15 + 5, nil, 289 - (239 + 30));
										v217 = 1 + 0;
									end
									if (((581 + 23) == (1068 - 464)) and (v217 == (2 - 1))) then
										if (v31 or ((4799 - (306 + 9)) == (3140 - 2240))) then
											return v31;
										end
										break;
									end
								end
							end
							if (v78 or ((776 + 3683) <= (683 + 430))) then
								if (((1749 + 1883) > (9716 - 6318)) and v97) then
									local v220 = 1375 - (1140 + 235);
									while true do
										if (((2598 + 1484) <= (4509 + 408)) and (v220 == (0 + 0))) then
											v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 82 - (33 + 19));
											if (((1745 + 3087) >= (4154 - 2768)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v215 = 2 + 1;
						end
						if (((268 - 131) == (129 + 8)) and (v215 == (693 - (586 + 103)))) then
							if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((143 + 1427) >= (13336 - 9004))) then
								if (v34 or ((5552 - (1309 + 179)) <= (3283 - 1464))) then
									local v221 = 0 + 0;
									while true do
										if ((v221 == (0 - 0)) or ((3767 + 1219) < (3343 - 1769))) then
											v31 = v123();
											if (((8819 - 4393) > (781 - (295 + 314))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if (((1439 - 853) > (2417 - (1300 + 662))) and v33 and (((v103 >= (21 - 14)) and not v14:HasTier(1785 - (1178 + 577), 2 + 0)) or ((v103 >= (8 - 5)) and v98.IceCaller:IsAvailable()))) then
									local v222 = 1405 - (851 + 554);
									while true do
										if (((731 + 95) == (2290 - 1464)) and (v222 == (0 - 0))) then
											v31 = v125();
											if (v31 or ((4321 - (115 + 187)) > (3402 + 1039))) then
												return v31;
											end
											v222 = 1 + 0;
										end
										if (((7948 - 5931) < (5422 - (160 + 1001))) and (v222 == (1 + 0))) then
											if (((3254 + 1462) > (163 - 83)) and v24(v98.Pool)) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								if ((v33 and (v103 == (360 - (237 + 121)))) or ((4404 - (525 + 372)) == (6202 - 2930))) then
									v31 = v126();
									if (v31 or ((2878 - 2002) >= (3217 - (96 + 46)))) then
										return v31;
									end
									if (((5129 - (643 + 134)) > (922 + 1632)) and v24(v98.Pool)) then
										return "pool for Cleave()";
									end
								end
								v31 = v127();
								if (v31 or ((10564 - 6158) < (15010 - 10967))) then
									return v31;
								end
								if (v24(v98.Pool) or ((1812 + 77) >= (6638 - 3255))) then
									return "pool for ST()";
								end
								if (((3867 - 1975) <= (3453 - (316 + 403))) and v94) then
									local v223 = 0 + 0;
									while true do
										if (((5286 - 3363) < (802 + 1416)) and (v223 == (0 - 0))) then
											v31 = v124();
											if (((1540 + 633) > (123 + 256)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((v215 == (3 - 2)) or ((12374 - 9783) == (7081 - 3672))) then
							v31 = v119();
							if (((259 + 4255) > (6543 - 3219)) and v31) then
								return v31;
							end
							v215 = 1 + 1;
						end
						if (((8 - 5) == v215) or ((225 - (12 + 5)) >= (18751 - 13923))) then
							if (v79 or ((3376 - 1793) > (7581 - 4014))) then
								local v219 = 0 - 0;
								while true do
									if ((v219 == (0 + 0)) or ((3286 - (1656 + 317)) == (708 + 86))) then
										v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 25 + 5, true);
										if (((8439 - 5265) > (14282 - 11380)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((4474 - (5 + 349)) <= (20234 - 15974)) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
								if (v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal)) or ((2154 - (266 + 1005)) > (3149 + 1629))) then
									return "spellsteal damage";
								end
							end
							v215 = 13 - 9;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (1696 - (561 + 1135))) or ((4717 - 1097) >= (16077 - 11186))) then
				v113();
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1130 - (507 + 559), v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

