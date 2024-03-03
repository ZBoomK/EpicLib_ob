local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((13262 - 10042) == (101 + 1263))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2651 - (978 + 619)) > (4746 - (243 + 1111)))) then
			v6 = v0[v4];
			if (not v6 or ((618 + 58) >= (1800 - (91 + 67)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v98;
	local v99 = v19.Mage.Frost;
	local v100 = v21.Mage.Frost;
	local v101 = v26.Mage.Frost;
	local v102 = {};
	local v103, v104;
	local v105, v106;
	local v107 = 0 + 0;
	local v108 = 523 - (423 + 100);
	local v109 = 1 + 14;
	local v110 = 30764 - 19653;
	local v111 = 5792 + 5319;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (((4907 - (326 + 445)) > (10460 - 8063)) and v99.RemoveCurse:IsAvailable()) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(188743 - 104022);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(533597 - 305000);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(229065 - (530 + 181));
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(229479 - (614 + 267));
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(228632 - (19 + 13));
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v110 = 18084 - 6973;
		v111 = 25892 - 14781;
		v107 = 0 - 0;
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v133)
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 - 0)) or ((8987 - 4653) == (6057 - (1293 + 519)))) then
				if ((v133 == nil) or ((8724 - 4448) <= (7913 - 4882))) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < (139 - 66));
			end
		end
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v135)
		return (v135:DebuffStack(v99.WintersChillDebuff));
	end
	local function v118(v136)
		return (v136:DebuffDown(v99.WintersChillDebuff));
	end
	local function v119()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (6 - 3)) or ((2533 + 2249) <= (245 + 954))) then
				if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((11301 - 6437) < (440 + 1462))) then
					if (((1608 + 3231) >= (2313 + 1387)) and v24(v99.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((2171 - (709 + 387)) > (3776 - (673 + 1185)))) then
					if (((1148 - 752) <= (12215 - 8411)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v137 = 6 - 2;
			end
			if ((v137 == (3 + 1)) or ((3116 + 1053) == (2952 - 765))) then
				if (((346 + 1060) == (2803 - 1397)) and v85 and (v14:HealthPercentage() <= v87)) then
					if (((3005 - 1474) < (6151 - (446 + 1434))) and (v89 == "Refreshing Healing Potion")) then
						if (((1918 - (1040 + 243)) == (1895 - 1260)) and v100.RefreshingHealingPotion:IsReady()) then
							if (((5220 - (559 + 1288)) <= (5487 - (609 + 1322))) and v24(v101.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v89 == "Dreamwalker's Healing Potion") or ((3745 - (13 + 441)) < (12256 - 8976))) then
						if (((11488 - 7102) >= (4347 - 3474)) and v100.DreamwalkersHealingPotion:IsReady()) then
							if (((35 + 886) <= (4002 - 2900)) and v24(v101.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1672 + 3034) >= (422 + 541)) and (v137 == (2 - 1))) then
				if ((v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((526 + 434) <= (1610 - 734))) then
					if (v24(v99.IceColdAbility) or ((1366 + 700) == (519 + 413))) then
						return "ice_cold defensive 3";
					end
				end
				if (((3467 + 1358) < (4067 + 776)) and v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
					if (v24(v99.IceBlock) or ((3794 + 83) >= (4970 - (153 + 280)))) then
						return "ice_block defensive 4";
					end
				end
				v137 = 5 - 3;
			end
			if ((v137 == (0 + 0)) or ((1704 + 2611) < (904 + 822))) then
				if ((v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((3339 + 340) < (453 + 172))) then
					if (v24(v99.IceBarrier) or ((7042 - 2417) < (391 + 241))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 669 - (89 + 578), v99.ArcaneIntellect)) or ((60 + 23) > (3700 - 1920))) then
					if (((1595 - (572 + 477)) <= (146 + 931)) and v24(v99.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (1 + 1)) or ((1082 - (84 + 2)) > (7088 - 2787))) then
				if (((2933 + 1137) > (1529 - (497 + 345))) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (v24(v99.MirrorImage) or ((17 + 639) >= (563 + 2767))) then
						return "mirror_image defensive 5";
					end
				end
				if ((v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((3825 - (605 + 728)) <= (240 + 95))) then
					if (((9608 - 5286) >= (118 + 2444)) and v24(v99.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v137 = 10 - 7;
			end
		end
	end
	local v120 = 0 + 0;
	local function v121()
		if ((v99.RemoveCurse:IsReady() and v113.DispellableFriendlyUnit(55 - 35)) or ((2747 + 890) >= (4259 - (457 + 32)))) then
			if ((v120 == (0 + 0)) or ((3781 - (832 + 570)) > (4313 + 265))) then
				v120 = GetTime();
			end
			if (v113.Wait(131 + 369, v120) or ((1709 - 1226) > (358 + 385))) then
				if (((3250 - (588 + 208)) > (1557 - 979)) and v24(v101.RemoveCurseFocus)) then
					return "remove_curse dispel";
				end
				v120 = 1800 - (884 + 916);
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if (((540 + 390) < (5111 - (232 + 421))) and (v138 == (1889 - (1569 + 320)))) then
				v31 = v113.HandleTopTrinket(v102, v34, 10 + 30, nil);
				if (((126 + 536) <= (3275 - 2303)) and v31) then
					return v31;
				end
				v138 = 606 - (316 + 289);
			end
			if (((11439 - 7069) == (202 + 4168)) and ((1454 - (666 + 787)) == v138)) then
				v31 = v113.HandleBottomTrinket(v102, v34, 465 - (360 + 65), nil);
				if (v31 or ((4451 + 311) <= (1115 - (79 + 175)))) then
					return v31;
				end
				break;
			end
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((2226 - 814) == (3328 + 936))) then
			if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((9710 - 6542) < (4146 - 1993))) then
				if (v24(v99.MirrorImage) or ((5875 - (503 + 396)) < (1513 - (92 + 89)))) then
					return "mirror_image precombat 2";
				end
			end
			if (((8977 - 4349) == (2374 + 2254)) and v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) then
				if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt)) or ((32 + 22) == (1546 - 1151))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v124()
		if (((12 + 70) == (186 - 104)) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 + 0, v99.IcyVeins)) then
			if (v24(v99.TimeWarp, not v15:IsInRange(20 + 20)) or ((1769 - 1188) < (36 + 246))) then
				return "time_warp cd 2";
			end
		end
		local v139 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (v139 or ((7028 - 2419) < (3739 - (485 + 759)))) then
			return v139;
		end
		if (((2665 - 1513) == (2341 - (442 + 747))) and v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) then
			if (((3031 - (832 + 303)) <= (4368 - (88 + 858))) and v24(v99.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v111) or ((302 + 688) > (1341 + 279))) then
			if ((v91 and ((v34 and v92) or not v92)) or ((37 + 840) > (5484 - (766 + 23)))) then
				local v205 = 0 - 0;
				while true do
					if (((3680 - 989) >= (4876 - 3025)) and (v205 == (0 - 0))) then
						v31 = v122();
						if (v31 or ((4058 - (1036 + 37)) >= (3443 + 1413))) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if (((8326 - 4050) >= (941 + 254)) and v90 and ((v93 and v34) or not v93) and (v83 < v111)) then
			local v161 = 1480 - (641 + 839);
			while true do
				if (((4145 - (910 + 3)) <= (11956 - 7266)) and (v161 == (1686 - (1466 + 218)))) then
					if (v99.AncestralCall:IsCastable() or ((412 + 484) >= (4294 - (556 + 592)))) then
						if (((1089 + 1972) >= (3766 - (329 + 479))) and v24(v99.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
				if (((4041 - (174 + 680)) >= (2212 - 1568)) and ((1 - 0) == v161)) then
					if (((460 + 184) <= (1443 - (396 + 343))) and v99.LightsJudgment:IsCastable()) then
						if (((85 + 873) > (2424 - (29 + 1448))) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (((5881 - (135 + 1254)) >= (9998 - 7344)) and v99.Fireblood:IsCastable()) then
						if (((16071 - 12629) >= (1002 + 501)) and v24(v99.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v161 = 1529 - (389 + 1138);
				end
				if (((574 - (102 + 472)) == v161) or ((2992 + 178) <= (812 + 652))) then
					if (v99.BloodFury:IsCastable() or ((4473 + 324) == (5933 - (320 + 1225)))) then
						if (((980 - 429) <= (417 + 264)) and v24(v99.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((4741 - (157 + 1307)) > (2266 - (821 + 1038))) and v99.Berserking:IsCastable()) then
						if (((11713 - 7018) >= (155 + 1260)) and v24(v99.Berserking)) then
							return "berserking cd 12";
						end
					end
					v161 = 1 - 0;
				end
			end
		end
	end
	local function v125()
		if ((v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) or ((1196 + 2016) <= (2339 - 1395))) then
			if (v24(v99.IceFloes) or ((4122 - (834 + 192)) <= (115 + 1683))) then
				return "ice_floes movement";
			end
		end
		if (((908 + 2629) == (76 + 3461)) and v99.IceNova:IsCastable() and v48) then
			if (((5943 - 2106) >= (1874 - (300 + 4))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova movement";
			end
		end
		if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (9 + 21)) and (v104 >= (5 - 3))) or ((3312 - (112 + 250)) == (1520 + 2292))) then
			if (((11831 - 7108) >= (1328 + 990)) and v24(v99.ArcaneExplosion, not v15:IsInRange(5 + 3))) then
				return "arcane_explosion movement";
			end
		end
		if ((v99.FireBlast:IsCastable() and v40) or ((1516 + 511) > (1415 + 1437))) then
			if (v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast)) or ((844 + 292) > (5731 - (1001 + 413)))) then
				return "fire_blast movement";
			end
		end
		if (((10587 - 5839) == (5630 - (244 + 638))) and v99.IceLance:IsCastable() and v47) then
			if (((4429 - (627 + 66)) <= (14123 - 9383)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance movement";
			end
		end
	end
	local function v126()
		if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(603 - (512 + 90), v99.CometStorm) or (v14:PrevGCDP(1907 - (1665 + 241), v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((4107 - (373 + 344)) <= (1381 + 1679))) then
			if (v24(v99.ConeofCold, not v15:IsInRange(3 + 5)) or ((2634 - 1635) > (4556 - 1863))) then
				return "cone_of_cold aoe 2";
			end
		end
		if (((1562 - (35 + 1064)) < (438 + 163)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(2 - 1, v99.GlacialSpike) or not v115())) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(1 + 39)) or ((3419 - (298 + 938)) < (1946 - (233 + 1026)))) then
				return "frozen_orb aoe 4";
			end
		end
		if (((6215 - (636 + 1030)) == (2326 + 2223)) and v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) then
			if (((1388 + 3284) == (316 + 4356)) and v24(v101.BlizzardCursor, not v15:IsInRange(261 - (55 + 166)))) then
				return "blizzard aoe 6";
			end
		end
		if ((v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (3 + 22))) or (v99.ConeofCold:CooldownRemains() > (76 - 56)))) or ((3965 - (36 + 261)) < (690 - 295))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((5534 - (34 + 1334)) == (175 + 280))) then
				return "comet_storm aoe 8";
			end
		end
		if ((v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 + 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(1284 - (1035 + 248), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) or ((4470 - (20 + 1)) == (1388 + 1275))) then
			if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((4596 - (134 + 185)) < (4122 - (549 + 584)))) then
				return "freeze aoe 10";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(686 - (314 + 371), v99.Freeze) and (v14:PrevGCDP(3 - 2, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (969 - (478 + 490)))))) or ((461 + 409) >= (5321 - (786 + 386)))) then
			if (((7164 - 4952) < (4562 - (1055 + 324))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova aoe 11";
			end
		end
		if (((5986 - (1093 + 247)) > (2659 + 333)) and v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and ((v14:PrevGCDP(3 - 2, v99.GlacialSpike) and (v107 == (0 - 0))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (2 - 1))))) then
			if (((3603 - 2169) < (1105 + 2001)) and v24(v99.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if (((3027 - 2241) < (10419 - 7396)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
			if (v24(v99.ConeofCold, not v15:IsInRange(7 + 1)) or ((6244 - 3802) < (762 - (364 + 324)))) then
				return "cone_of_cold aoe 14";
			end
		end
		if (((12431 - 7896) == (10882 - 6347)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
			if (v24(v99.ShiftingPower, not v15:IsInRange(14 + 26), true) or ((12590 - 9581) <= (3371 - 1266))) then
				return "shifting_power aoe 16";
			end
		end
		if (((5557 - 3727) < (4937 - (1249 + 19))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (5 + 0)) and (v99.Blizzard:CooldownRemains() > v112)) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((5566 - 4136) >= (4698 - (686 + 400)))) then
				return "glacial_spike aoe 18";
			end
		end
		if (((2106 + 577) >= (2689 - (73 + 156))) and v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (0 + 0)) and (v14:PrevGCDP(812 - (721 + 90), v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (1.8 + 0)))) then
			if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((5857 - 4053) >= (3745 - (224 + 246)))) then
				return "flurry aoe 20";
			end
		end
		if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 - 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((2608 - 1191) > (659 + 2970))) then
			if (((115 + 4680) > (296 + 106)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry))) then
				return "flurry aoe 21";
			end
		end
		if (((9568 - 4755) > (11863 - 8298)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
			if (((4425 - (203 + 310)) == (5905 - (1238 + 755))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance aoe 22";
			end
		end
		if (((198 + 2623) <= (6358 - (709 + 825))) and v99.IceNova:IsCastable() and v48 and (v103 >= (7 - 3)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) then
			if (((2531 - 793) <= (3059 - (196 + 668))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova aoe 23";
			end
		end
		if (((161 - 120) <= (6251 - 3233)) and v99.DragonsBreath:IsCastable() and v39 and (v104 >= (840 - (171 + 662)))) then
			if (((2238 - (4 + 89)) <= (14384 - 10280)) and v24(v99.DragonsBreath, not v15:IsInRange(4 + 6))) then
				return "dragons_breath aoe 26";
			end
		end
		if (((11810 - 9121) < (1900 + 2945)) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1516 - (35 + 1451))) and (v104 >= (1460 - (28 + 1425)))) then
			if (v24(v99.ArcaneExplosion, not v15:IsInRange(2001 - (941 + 1052))) or ((2227 + 95) > (4136 - (822 + 692)))) then
				return "arcane_explosion aoe 28";
			end
		end
		if ((v99.Frostbolt:IsCastable() and v41) or ((6472 - 1938) == (981 + 1101))) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true) or ((1868 - (45 + 252)) > (1848 + 19))) then
				return "frostbolt aoe 32";
			end
		end
		if ((v14:IsMoving() and v95) or ((914 + 1740) >= (7291 - 4295))) then
			local v162 = 433 - (114 + 319);
			while true do
				if (((5711 - 1733) > (2695 - 591)) and ((0 + 0) == v162)) then
					v31 = v125();
					if (((4462 - 1467) > (3228 - 1687)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v140 = 1963 - (556 + 1407);
		while true do
			if (((4455 - (741 + 465)) > (1418 - (170 + 295))) and (v140 == (1 + 0))) then
				if ((v99.RayofFrost:IsCastable() and (v107 == (1 + 0)) and v49) or ((8058 - 4785) > (3791 + 782))) then
					if (v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost)) or ((2021 + 1130) < (728 + 556))) then
						return "ray_of_frost cleave 8";
					end
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((3080 - (957 + 273)) == (409 + 1120))) then
						return "ray_of_frost cleave 8";
					end
				end
				if (((329 + 492) < (8089 - 5966)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (13 - 8)) and (v99.Flurry:CooldownUp() or (v107 > (0 - 0)))) then
					if (((4466 - 3564) < (4105 - (389 + 1391))) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if (((539 + 319) <= (309 + 2653)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (4 - 2)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
					if (v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb)) or ((4897 - (783 + 168)) < (4322 - 3034))) then
						return "frozen_orb cleave 12";
					end
				end
				v140 = 2 + 0;
			end
			if ((v140 == (311 - (309 + 2))) or ((9955 - 6713) == (1779 - (1090 + 122)))) then
				if ((v99.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v99.Flurry) or v14:PrevGCDP(3 - 2, v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) or ((580 + 267) >= (2381 - (628 + 490)))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((404 + 1849) == (4582 - 2731))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(4 - 3, v99.Frostbolt) and (v108 >= (777 - (431 + 343)))) or v14:PrevGCDP(1 - 0, v99.GlacialSpike) or ((v108 >= (8 - 5)) and (v108 < (4 + 1)) and (v99.Flurry:ChargesFractional() == (1 + 1))))) or ((3782 - (556 + 1139)) > (2387 - (6 + 9)))) then
					if (v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry)) or ((814 + 3631) < (2126 + 2023))) then
						return "flurry cleave 4";
					end
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((1987 - (28 + 141)) == (33 + 52))) then
						return "flurry cleave 4";
					end
				end
				if (((777 - 147) < (1507 + 620)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (1317 - (486 + 831))) and (v108 == (10 - 6)) and v14:BuffUp(v99.FingersofFrostBuff)) then
					local v206 = 0 - 0;
					while true do
						if ((v206 == (0 + 0)) or ((6127 - 4189) == (3777 - (668 + 595)))) then
							if (((3829 + 426) >= (12 + 43)) and v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							if (((8178 - 5179) > (1446 - (23 + 267))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				v140 = 1945 - (1129 + 815);
			end
			if (((2737 - (371 + 16)) > (2905 - (1326 + 424))) and (v140 == (5 - 2))) then
				if (((14722 - 10693) <= (4971 - (88 + 30))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (776 - (720 + 51)))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((1147 - 631) > (5210 - (421 + 1355)))) then
						return "glacial_spike cleave 20";
					end
				end
				if (((6674 - 2628) >= (1490 + 1543)) and v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1084 - (286 + 797), v99.GlacialSpike)) or (v107 > (0 - 0)))) then
					if (v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance)) or ((4503 - 1784) <= (1886 - (397 + 42)))) then
						return "ice_lance cleave 22";
					end
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((1292 + 2842) < (4726 - (24 + 776)))) then
						return "ice_lance cleave 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (5 - 1))) or ((949 - (222 + 563)) >= (6136 - 3351))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((378 + 147) == (2299 - (23 + 167)))) then
						return "ice_nova cleave 24";
					end
				end
				v140 = 1802 - (690 + 1108);
			end
			if (((12 + 21) == (28 + 5)) and (v140 == (850 - (40 + 808)))) then
				if (((503 + 2551) <= (15353 - 11338)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (10 + 0)) and (v99.FrozenOrb:CooldownRemains() > (6 + 4)) and (v107 == (0 + 0)) and (v104 >= (574 - (47 + 524)))) then
					if (((1215 + 656) < (9244 - 5862)) and v24(v99.ConeofCold)) then
						return "cone_of_cold cleave 14";
					end
				end
				if (((1933 - 640) <= (4939 - 2773)) and v99.Blizzard:IsCastable() and v38 and (v104 >= (1728 - (1165 + 561))) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (1 + 2)))) then
					if (v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard)) or ((7987 - 5408) < (47 + 76))) then
						return "blizzard cleave 16";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (489 - (341 + 138))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (3 + 7))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (20 - 10)))) or (v99.IcyVeins:CooldownRemains() < (346 - (89 + 237))))) or ((2721 - 1875) >= (4985 - 2617))) then
					if (v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true) or ((4893 - (581 + 300)) <= (4578 - (855 + 365)))) then
						return "shifting_power cleave 18";
					end
				end
				v140 = 6 - 3;
			end
			if (((488 + 1006) <= (4240 - (1030 + 205))) and (v140 == (4 + 0))) then
				if ((v99.Frostbolt:IsCastable() and v41) or ((2895 + 216) == (2420 - (156 + 130)))) then
					if (((5351 - 2996) == (3969 - 1614)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true)) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((1204 - 616) <= (114 + 318))) then
					v31 = v125();
					if (((2798 + 1999) >= (3964 - (10 + 59))) and v31) then
						return v31;
					end
				end
				break;
			end
		end
	end
	local function v128()
		if (((1012 + 2565) == (17615 - 14038)) and v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1164 - (671 + 492), v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold))) then
			if (((5009 - (369 + 846)) > (978 + 2715)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
				return "comet_storm single 2";
			end
		end
		if ((v99.Flurry:IsCastable() and (v107 == (0 + 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1946 - (1036 + 909), v99.Frostbolt) and (v108 >= (3 + 0))) or (v14:PrevGCDP(1 - 0, v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(204 - (11 + 192), v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (3 + 1)) and v14:BuffDown(v99.FingersofFrostBuff)))) or ((1450 - (135 + 40)) == (9933 - 5833))) then
			if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((959 + 632) >= (7886 - 4306))) then
				return "flurry single 4";
			end
		end
		if (((1473 - 490) <= (1984 - (50 + 126))) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 - 0)) and (v108 == (1 + 3)) and v14:BuffUp(v99.FingersofFrostBuff)) then
			if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3563 - (1233 + 180)) <= (2166 - (522 + 447)))) then
				return "ice_lance single 6";
			end
		end
		if (((5190 - (107 + 1314)) >= (545 + 628)) and v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (2 - 1))) then
			if (((631 + 854) == (2948 - 1463)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
				return "ray_of_frost single 8";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (19 - 14)) and ((v99.Flurry:Charges() >= (1911 - (716 + 1194))) or ((v107 > (0 + 0)) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) or ((356 + 2959) <= (3285 - (74 + 429)))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((1689 - 813) >= (1470 + 1494))) then
				return "glacial_spike single 10";
			end
		end
		if ((v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (0 - 0)) and (v14:BuffStackP(v99.FingersofFrostBuff) < (2 + 0)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((6880 - 4648) > (6173 - 3676))) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(473 - (279 + 154))) or ((2888 - (454 + 324)) <= (262 + 70))) then
				return "frozen_orb single 12";
			end
		end
		if (((3703 - (12 + 5)) > (1711 + 1461)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (25 - 15)) and (v99.FrozenOrb:CooldownRemains() > (4 + 6)) and (v107 == (1093 - (277 + 816))) and (v103 >= (12 - 9))) then
			if (v24(v99.ConeofCold, not v15:IsInRange(1191 - (1058 + 125))) or ((839 + 3635) < (1795 - (815 + 160)))) then
				return "cone_of_cold single 14";
			end
		end
		if (((18359 - 14080) >= (6841 - 3959)) and v99.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (8 - 5)))) then
			if (v24(v101.BlizzardCursor, not v15:IsInRange(1938 - (41 + 1857))) or ((3922 - (1222 + 671)) >= (9100 - 5579))) then
				return "blizzard single 16";
			end
		end
		if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 - 0)) and (((v99.FrozenOrb:CooldownRemains() > (1192 - (229 + 953))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (1784 - (1111 + 663)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (1589 - (874 + 705))))) or (v99.IcyVeins:CooldownRemains() < (3 + 17)))) or ((1390 + 647) >= (9648 - 5006))) then
			if (((49 + 1671) < (5137 - (642 + 37))) and v24(v99.ShiftingPower, not v15:IsInRange(10 + 30))) then
				return "shifting_power single 18";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (1 + 4))) or ((1094 - 658) > (3475 - (233 + 221)))) then
			if (((1648 - 935) <= (746 + 101)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
				return "glacial_spike single 20";
			end
		end
		if (((3695 - (718 + 823)) <= (2537 + 1494)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(806 - (266 + 539), v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
			if (((13065 - 8450) == (5840 - (636 + 589))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance single 22";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and (v104 >= (9 - 5))) or ((7817 - 4027) == (397 + 103))) then
			if (((33 + 56) < (1236 - (657 + 358))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova single 24";
			end
		end
		if (((5438 - 3384) >= (3237 - 1816)) and v90 and ((v93 and v34) or not v93)) then
			if (((1879 - (1151 + 36)) < (2954 + 104)) and v99.BagofTricks:IsCastable()) then
				if (v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks)) or ((856 + 2398) == (4942 - 3287))) then
					return "bag_of_tricks cd 40";
				end
			end
		end
		if ((v99.Frostbolt:IsCastable() and v41) or ((3128 - (1552 + 280)) == (5744 - (64 + 770)))) then
			if (((2287 + 1081) == (7645 - 4277)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true)) then
				return "frostbolt single 26";
			end
		end
		if (((470 + 2173) < (5058 - (157 + 1086))) and v14:IsMoving() and v95) then
			v31 = v125();
			if (((3828 - 1915) > (2159 - 1666)) and v31) then
				return v31;
			end
		end
	end
	local function v129()
		local v141 = 0 - 0;
		while true do
			if (((6489 - 1734) > (4247 - (599 + 220))) and (v141 == (13 - 6))) then
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v141 = 1939 - (1813 + 118);
			end
			if (((1010 + 371) <= (3586 - (841 + 376))) and (v141 == (1 - 0))) then
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v141 = 1 + 1;
			end
			if ((v141 == (10 - 6)) or ((5702 - (464 + 395)) == (10480 - 6396))) then
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v141 = 3 + 2;
			end
			if (((5506 - (467 + 370)) > (749 - 386)) and (v141 == (0 + 0))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v141 = 3 - 2;
			end
			if ((v141 == (2 + 7)) or ((4366 - 2489) >= (3658 - (150 + 370)))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (1282 - (74 + 1208));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v141 = 400 - (14 + 376);
			end
			if (((8224 - 3482) >= (2347 + 1279)) and (v141 == (5 + 0))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v141 = 6 + 0;
			end
			if ((v141 == (8 - 5)) or ((3416 + 1124) == (994 - (23 + 55)))) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v141 = 9 - 5;
			end
			if (((6 + 2) == v141) or ((1039 + 117) > (6736 - 2391))) then
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (901 - (652 + 249));
				v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v141 = 1877 - (708 + 1160);
			end
			if (((6072 - 3835) < (7746 - 3497)) and (v141 == (37 - (10 + 17)))) then
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v141 = 3 + 8;
			end
			if (((1738 - (1400 + 332)) == v141) or ((5146 - 2463) < (1931 - (242 + 1666)))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v141 = 3 + 4;
			end
			if (((256 + 441) <= (704 + 122)) and (v141 == (942 - (850 + 90)))) then
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v141 = 4 - 1;
			end
			if (((2495 - (360 + 1030)) <= (1041 + 135)) and (v141 == (30 - 19))) then
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v130()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v84 = EpicSettings.Settings['useWeapon'];
		v80 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v82 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['DispelDebuffs'];
		v76 = EpicSettings.Settings['DispelBuffs'];
		v91 = EpicSettings.Settings['useTrinkets'];
		v90 = EpicSettings.Settings['useRacials'];
		v92 = EpicSettings.Settings['trinketsWithCD'];
		v93 = EpicSettings.Settings['racialsWithCD'];
		v86 = EpicSettings.Settings['useHealthstone'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v88 = EpicSettings.Settings['healthstoneHP'] or (1661 - (909 + 752));
		v87 = EpicSettings.Settings['healingPotionHP'] or (1223 - (109 + 1114));
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v131()
		local v156 = 0 - 0;
		while true do
			if (((1316 + 2063) <= (4054 - (6 + 236))) and ((2 + 1) == v156)) then
				if (v113.TargetIsValid() or ((635 + 153) >= (3810 - 2194))) then
					local v207 = 0 - 0;
					while true do
						if (((2987 - (1076 + 57)) <= (556 + 2823)) and (v207 == (689 - (579 + 110)))) then
							if (((360 + 4189) == (4022 + 527)) and v77 and v35 and v99.RemoveCurse:IsAvailable()) then
								local v210 = 0 + 0;
								while true do
									if ((v210 == (407 - (174 + 233))) or ((8441 - 5419) >= (5307 - 2283))) then
										if (((2144 + 2676) > (3372 - (663 + 511))) and v16) then
											local v217 = 0 + 0;
											while true do
												if ((v217 == (0 + 0)) or ((3270 - 2209) >= (2962 + 1929))) then
													v31 = v121();
													if (((3211 - 1847) <= (10828 - 6355)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										if ((v17 and v17:Exists() and v17:IsAPlayer() and v113.UnitHasCurseDebuff(v17)) or ((1716 + 1879) <= (5 - 2))) then
											if (v99.RemoveCurse:IsReady() or ((3330 + 1342) == (353 + 3499))) then
												if (((2281 - (478 + 244)) == (2076 - (440 + 77))) and v24(v101.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((797 + 955) <= (2883 - 2095))) then
								local v211 = 1556 - (655 + 901);
								while true do
									if ((v211 == (0 + 0)) or ((2992 + 915) == (120 + 57))) then
										v31 = v123();
										if (((13979 - 10509) > (2000 - (695 + 750))) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							v207 = 3 - 2;
						end
						if ((v207 == (1 - 0)) or ((3909 - 2937) == (996 - (285 + 66)))) then
							v31 = v119();
							if (((7416 - 4234) >= (3425 - (682 + 628))) and v31) then
								return v31;
							end
							v207 = 1 + 1;
						end
						if (((4192 - (176 + 123)) < (1853 + 2576)) and ((3 + 1) == v207)) then
							if ((v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((3136 - (239 + 30)) < (518 + 1387))) then
								if ((v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) or ((1727 + 69) >= (7169 - 3118))) then
									if (((5050 - 3431) <= (4071 - (306 + 9))) and v24(v101.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								if (((2107 - 1503) == (106 + 498)) and v34) then
									v31 = v124();
									if (v31 or ((2752 + 1732) == (434 + 466))) then
										return v31;
									end
								end
								if ((v33 and (((v104 >= (19 - 12)) and not v14:HasTier(1405 - (1140 + 235), 2 + 0)) or ((v104 >= (3 + 0)) and v99.IceCaller:IsAvailable()))) or ((1145 + 3314) <= (1165 - (33 + 19)))) then
									local v214 = 0 + 0;
									while true do
										if (((10885 - 7253) > (1497 + 1901)) and (v214 == (1 - 0))) then
											if (((3828 + 254) <= (5606 - (586 + 103))) and v24(v99.Pool)) then
												return "pool for Aoe()";
											end
											break;
										end
										if (((440 + 4392) >= (4266 - 2880)) and (v214 == (1488 - (1309 + 179)))) then
											v31 = v126();
											if (((246 - 109) == (60 + 77)) and v31) then
												return v31;
											end
											v214 = 2 - 1;
										end
									end
								end
								if ((v33 and (v104 == (2 + 0))) or ((3335 - 1765) >= (8631 - 4299))) then
									v31 = v127();
									if (v31 or ((4673 - (295 + 314)) <= (4467 - 2648))) then
										return v31;
									end
									if (v24(v99.Pool) or ((6948 - (1300 + 662)) < (4942 - 3368))) then
										return "pool for Cleave()";
									end
								end
								v31 = v128();
								if (((6181 - (1178 + 577)) > (90 + 82)) and v31) then
									return v31;
								end
								if (((1732 - 1146) > (1860 - (851 + 554))) and v24(v99.Pool)) then
									return "pool for ST()";
								end
								if (((731 + 95) == (2290 - 1464)) and v14:IsMoving() and v95) then
									local v215 = 0 - 0;
									while true do
										if ((v215 == (302 - (115 + 187))) or ((3078 + 941) > (4205 + 236))) then
											v31 = v125();
											if (((7948 - 5931) < (5422 - (160 + 1001))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((4126 + 590) > (56 + 24)) and (v207 == (5 - 2))) then
							if (v79 or ((3865 - (237 + 121)) == (4169 - (525 + 372)))) then
								v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 56 - 26);
								if (v31 or ((2878 - 2002) >= (3217 - (96 + 46)))) then
									return v31;
								end
							end
							if (((5129 - (643 + 134)) > (922 + 1632)) and v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) then
								if (v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal)) or ((10564 - 6158) < (15010 - 10967))) then
									return "spellsteal damage";
								end
							end
							v207 = 4 + 0;
						end
						if ((v207 == (3 - 1)) or ((3860 - 1971) >= (4102 - (316 + 403)))) then
							if (((1258 + 634) <= (7516 - 4782)) and (v14:AffectingCombat() or v77)) then
								local v212 = 0 + 0;
								local v213;
								while true do
									if (((4842 - 2919) < (1572 + 646)) and (v212 == (1 + 0))) then
										if (((7529 - 5356) > (1810 - 1431)) and v31) then
											return v31;
										end
										break;
									end
									if ((v212 == (0 - 0)) or ((149 + 2442) == (6710 - 3301))) then
										v213 = v77 and v99.RemoveCurse:IsReady() and v35;
										v31 = v113.FocusUnit(v213, nil, 1 + 19, nil, 58 - 38, v99.ArcaneIntellect);
										v212 = 18 - (12 + 5);
									end
								end
							end
							if (((17532 - 13018) > (7092 - 3768)) and v78) then
								if (v98 or ((442 - 234) >= (11972 - 7144))) then
									local v216 = 0 + 0;
									while true do
										if ((v216 == (1973 - (1656 + 317))) or ((1411 + 172) > (2859 + 708))) then
											v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 79 - 49);
											if (v31 or ((6461 - 5148) == (1148 - (5 + 349)))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v207 = 14 - 11;
						end
					end
				end
				break;
			end
			if (((4445 - (266 + 1005)) > (1913 + 989)) and ((3 - 2) == v156)) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (((5424 - 1304) <= (5956 - (561 + 1135))) and v14:IsDeadOrGhost()) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(6 - 1);
				v156 = 6 - 4;
			end
			if (((1066 - (507 + 559)) == v156) or ((2215 - 1332) > (14776 - 9998))) then
				v129();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v156 = 389 - (212 + 176);
			end
			if (((907 - (250 + 655)) == v156) or ((9871 - 6251) >= (8546 - 3655))) then
				v106 = v14:GetEnemiesInRange(62 - 22);
				if (((6214 - (1869 + 87)) > (3249 - 2312)) and v33) then
					local v208 = 1901 - (484 + 1417);
					while true do
						if ((v208 == (0 - 0)) or ((8159 - 3290) < (1679 - (48 + 725)))) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(8 - 3), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(13 - 8), #v106);
							break;
						end
					end
				else
					local v209 = 0 + 0;
					while true do
						if ((v209 == (0 - 0)) or ((343 + 882) > (1233 + 2995))) then
							v103 = 854 - (152 + 701);
							v104 = 1312 - (430 + 881);
							break;
						end
					end
				end
				if (((1275 + 2053) > (3133 - (557 + 338))) and not v14:AffectingCombat()) then
					if (((1135 + 2704) > (3959 - 2554)) and v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) then
						if (v24(v99.ArcaneIntellect) or ((4527 - 3234) <= (1346 - 839))) then
							return "arcane_intellect";
						end
					end
				end
				if (v113.TargetIsValid() or v14:AffectingCombat() or ((6240 - 3344) < (1606 - (499 + 302)))) then
					v110 = v10.BossFightRemains(nil, true);
					v111 = v110;
					if (((3182 - (39 + 827)) == (6392 - 4076)) and (v111 == (24814 - 13703))) then
						v111 = v10.FightRemains(v106, false);
					end
					v107 = v15:DebuffStack(v99.WintersChillDebuff);
					v108 = v14:BuffStackP(v99.IciclesBuff);
					v112 = v14:GCD();
				end
				v156 = 11 - 8;
			end
		end
	end
	local function v132()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (0 + 0)) or ((7522 - 4952) == (246 + 1287))) then
				v114();
				v99.WintersChillDebuff:RegisterAuraTracking();
				v157 = 1 - 0;
			end
			if ((v157 == (105 - (103 + 1))) or ((1437 - (475 + 79)) == (3156 - 1696))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(204 - 140, v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

