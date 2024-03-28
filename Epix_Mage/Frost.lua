local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 874 - (69 + 805);
	local v6;
	while true do
		if (((12310 - 9090) == (3771 - (83 + 468))) and (v5 == (1806 - (1202 + 604)))) then
			v6 = v0[v4];
			if (((9961 - 7827) == (3551 - 1417)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (326 - (45 + 280))) or ((2080 + 74) >= (2905 + 420))) then
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
	local v98;
	local v99 = v19.Mage.Frost;
	local v100 = v21.Mage.Frost;
	local v101 = v26.Mage.Frost;
	local v102 = {};
	local v103, v104;
	local v105, v106;
	local v107 = 0 + 0;
	local v108 = 0 + 0;
	local v109 = 3 + 12;
	local v110 = 20574 - 9463;
	local v111 = 13022 - (340 + 1571);
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((511 + 784) >= (5005 - (1733 + 39)))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(232804 - 148083);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(229631 - (125 + 909));
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(230302 - (1096 + 852));
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(102544 + 126054);
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(326465 - 97865);
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v110 = 10777 + 334;
		v111 = 11623 - (409 + 103);
		v107 = 236 - (46 + 190);
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v133)
		if (((4472 - (51 + 44)) > (464 + 1178)) and (v133 == nil)) then
			v133 = v15;
		end
		return not v133:IsInBossList() or (v133:Level() < (1390 - (1114 + 203)));
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v134)
		return (v134:DebuffStack(v99.WintersChillDebuff));
	end
	local function v118(v135)
		return (v135:DebuffDown(v99.WintersChillDebuff));
	end
	local function v119()
		if (((5449 - (228 + 498)) > (294 + 1062)) and v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) then
			if (v24(v99.IceBarrier) or ((2285 + 1851) <= (4096 - (174 + 489)))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((11059 - 6814) <= (6536 - (830 + 1075))) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 526 - (303 + 221), v99.ArcaneIntellect)) then
			if (((5545 - (231 + 1038)) >= (3262 + 652)) and v24(v99.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if (((1360 - (171 + 991)) <= (17988 - 13623)) and v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
			if (((12840 - 8058) > (11668 - 6992)) and v24(v99.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((3893 + 971) > (7701 - 5504)) and v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
			if (v24(v99.IceBlock) or ((10673 - 6973) == (4040 - 1533))) then
				return "ice_block defensive 4";
			end
		end
		if (((13830 - 9356) >= (1522 - (111 + 1137))) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
			if (v24(v99.MirrorImage) or ((2052 - (91 + 67)) <= (4184 - 2778))) then
				return "mirror_image defensive 5";
			end
		end
		if (((393 + 1179) >= (2054 - (423 + 100))) and v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
			if (v24(v99.GreaterInvisibility) or ((33 + 4654) < (12575 - 8033))) then
				return "greater_invisibility defensive 6";
			end
		end
		if (((1716 + 1575) > (2438 - (326 + 445))) and v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
			if (v24(v99.AlterTime) or ((3809 - 2936) == (4531 - 2497))) then
				return "alter_time defensive 7";
			end
		end
		if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((6572 - 3756) < (722 - (530 + 181)))) then
			if (((4580 - (614 + 267)) < (4738 - (19 + 13))) and v24(v101.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((4305 - 1659) >= (2040 - 1164)) and v85 and (v14:HealthPercentage() <= v87)) then
			if (((1753 - 1139) <= (827 + 2357)) and (v89 == "Refreshing Healing Potion")) then
				if (((5497 - 2371) == (6482 - 3356)) and v100.RefreshingHealingPotion:IsReady()) then
					if (v24(v101.RefreshingHealingPotion) or ((3999 - (1293 + 519)) >= (10107 - 5153))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v89 == "Dreamwalker's Healing Potion") or ((10122 - 6245) == (6836 - 3261))) then
				if (((3048 - 2341) > (1488 - 856)) and v100.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v101.RefreshingHealingPotion) or ((290 + 256) >= (548 + 2136))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local v120 = 0 - 0;
	local function v121()
		if (((339 + 1126) <= (1429 + 2872)) and v99.RemoveCurse:IsReady() and (v113.UnitHasDispellableDebuffByPlayer(v16) or v113.DispellableFriendlyUnit(16 + 9))) then
			if (((2800 - (709 + 387)) > (3283 - (673 + 1185))) and (v120 == (0 - 0))) then
				v120 = GetTime();
			end
			if (v113.Wait(1605 - 1105, v120) or ((1129 - 442) == (3029 + 1205))) then
				if (v24(v101.RemoveCurseFocus) or ((2489 + 841) < (1928 - 499))) then
					return "remove_curse dispel";
				end
				v120 = 0 + 0;
			end
		end
	end
	local function v122()
		v31 = v113.HandleTopTrinket(v102, v34, 79 - 39, nil);
		if (((2251 - 1104) >= (2215 - (446 + 1434))) and v31) then
			return v31;
		end
		v31 = v113.HandleBottomTrinket(v102, v34, 1323 - (1040 + 243), nil);
		if (((10252 - 6817) > (3944 - (559 + 1288))) and v31) then
			return v31;
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((5701 - (609 + 1322)) >= (4495 - (13 + 441)))) then
			local v184 = 0 - 0;
			while true do
				if ((v184 == (0 - 0)) or ((18880 - 15089) <= (60 + 1551))) then
					if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((16626 - 12048) <= (714 + 1294))) then
						if (((493 + 632) <= (6160 - 4084)) and v24(v99.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if ((v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) or ((407 + 336) >= (8090 - 3691))) then
						if (((764 + 391) < (931 + 742)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v124()
		if ((v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 + 0, v99.IcyVeins)) or ((1952 + 372) <= (566 + 12))) then
			if (((4200 - (153 + 280)) == (10877 - 7110)) and v24(v99.TimeWarp, not v15:IsInRange(36 + 4))) then
				return "time_warp cd 2";
			end
		end
		local v136 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (((1615 + 2474) == (2140 + 1949)) and v136) then
			return v136;
		end
		if (((4046 + 412) >= (1213 + 461)) and v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) then
			if (((1479 - 507) <= (877 + 541)) and v24(v99.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v111) or ((5605 - (89 + 578)) < (3402 + 1360))) then
			if ((v91 and ((v34 and v92) or not v92)) or ((5205 - 2701) > (5313 - (572 + 477)))) then
				v31 = v122();
				if (((291 + 1862) == (1293 + 860)) and v31) then
					return v31;
				end
			end
		end
		if ((v90 and ((v93 and v34) or not v93) and (v83 < v111)) or ((61 + 446) >= (2677 - (84 + 2)))) then
			if (((7384 - 2903) == (3229 + 1252)) and v99.BloodFury:IsCastable()) then
				if (v24(v99.BloodFury) or ((3170 - (497 + 345)) < (18 + 675))) then
					return "blood_fury cd 10";
				end
			end
			if (((732 + 3596) == (5661 - (605 + 728))) and v99.Berserking:IsCastable()) then
				if (((1134 + 454) >= (2960 - 1628)) and v24(v99.Berserking)) then
					return "berserking cd 12";
				end
			end
			if (v99.LightsJudgment:IsCastable() or ((192 + 3982) > (15705 - 11457))) then
				if (v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment)) or ((4135 + 451) <= (226 - 144))) then
					return "lights_judgment cd 14";
				end
			end
			if (((2917 + 946) == (4352 - (457 + 32))) and v99.Fireblood:IsCastable()) then
				if (v24(v99.Fireblood) or ((120 + 162) <= (1444 - (832 + 570)))) then
					return "fireblood cd 16";
				end
			end
			if (((4343 + 266) >= (200 + 566)) and v99.AncestralCall:IsCastable()) then
				if (v24(v99.AncestralCall) or ((4076 - 2924) == (1199 + 1289))) then
					return "ancestral_call cd 18";
				end
			end
		end
	end
	local function v125()
		local v137 = 796 - (588 + 208);
		while true do
			if (((9222 - 5800) > (5150 - (884 + 916))) and (v137 == (1 - 0))) then
				if (((509 + 368) > (1029 - (232 + 421))) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1919 - (1569 + 320))) and (v104 >= (1 + 1))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(2 + 6)) or ((10506 - 7388) <= (2456 - (316 + 289)))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((431 - 266) >= (162 + 3330))) then
					if (((5402 - (666 + 787)) < (5281 - (360 + 65))) and v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v137 = 2 + 0;
			end
			if ((v137 == (256 - (79 + 175))) or ((6742 - 2466) < (2354 + 662))) then
				if (((14376 - 9686) > (7944 - 3819)) and v99.IceLance:IsCastable() and v47) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((949 - (503 + 396)) >= (1077 - (92 + 89)))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if ((v137 == (0 - 0)) or ((880 + 834) >= (1751 + 1207))) then
				if ((v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) or ((5838 - 4347) < (89 + 555))) then
					if (((1604 - 900) < (862 + 125)) and v24(v99.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if (((1776 + 1942) > (5804 - 3898)) and v99.IceNova:IsCastable() and v48) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((120 + 838) > (5543 - 1908))) then
						return "ice_nova movement";
					end
				end
				v137 = 1245 - (485 + 759);
			end
		end
	end
	local function v126()
		local v138 = 0 - 0;
		while true do
			if (((4690 - (442 + 747)) <= (5627 - (832 + 303))) and ((948 - (88 + 858)) == v138)) then
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) or ((1050 + 2392) < (2109 + 439))) then
					if (((119 + 2756) >= (2253 - (766 + 23))) and v24(v99.ShiftingPower, not v15:IsInRange(197 - 157), true)) then
						return "shifting_power aoe 16";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (6 - 1)) and (v99.Blizzard:CooldownRemains() > v112)) or ((12638 - 7841) >= (16606 - 11713))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((1624 - (1036 + 37)) > (1467 + 601))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((4116 - 2002) > (743 + 201)) and v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (1480 - (641 + 839))) and (v14:PrevGCDP(914 - (910 + 3), v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (2.8 - 1)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((3946 - (1466 + 218)) >= (1423 + 1673))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (1148 - (556 + 592))) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((802 + 1453) >= (4345 - (329 + 479)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((4691 - (174 + 680)) < (4487 - 3181))) then
						return "flurry aoe 21";
					end
				end
				v138 = 5 - 2;
			end
			if (((2107 + 843) == (3689 - (396 + 343))) and ((0 + 0) == v138)) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1478 - (29 + 1448), v99.CometStorm) or (v14:PrevGCDP(1390 - (135 + 1254), v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((17792 - 13069) < (15398 - 12100))) then
					if (((758 + 378) >= (1681 - (389 + 1138))) and v24(v99.ConeofCold, not v15:IsInRange(582 - (102 + 472)))) then
						return "cone_of_cold aoe 2";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) or ((151 + 120) > (4428 + 320))) then
					if (((6285 - (320 + 1225)) >= (5610 - 2458)) and v24(v101.FrozenOrbCast, not v15:IsInRange(25 + 15))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1465 - (157 + 1307), v99.GlacialSpike) or not v115())) or ((4437 - (821 + 1038)) >= (8458 - 5068))) then
					if (((5 + 36) <= (2950 - 1289)) and v24(v101.BlizzardCursor, not v15:IsInRange(15 + 25), v14:BuffDown(v99.IceFloes))) then
						return "blizzard aoe 6";
					end
				end
				if (((1489 - 888) < (4586 - (834 + 192))) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (7 + 18))) or (v99.ConeofCold:CooldownRemains() > (1 + 19)))) then
					if (((364 - 129) < (991 - (300 + 4))) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				v138 = 1 + 0;
			end
			if (((11908 - 7359) > (1515 - (112 + 250))) and (v138 == (2 + 2))) then
				if ((v99.Frostbolt:IsCastable() and v41) or ((11709 - 7035) < (2677 + 1995))) then
					if (((1897 + 1771) < (3412 + 1149)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
						return "frostbolt aoe 32";
					end
				end
				if ((v14:IsMoving() and v95) or ((226 + 229) == (2679 + 926))) then
					local v203 = 1414 - (1001 + 413);
					while true do
						if ((v203 == (0 - 0)) or ((3545 - (244 + 638)) == (4005 - (627 + 66)))) then
							v31 = v125();
							if (((12743 - 8466) <= (5077 - (512 + 90))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v138 == (1907 - (1665 + 241))) or ((1587 - (373 + 344)) == (537 + 652))) then
				if (((411 + 1142) <= (8263 - 5130)) and v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 - 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(1100 - (35 + 1064), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) then
					if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((1628 + 609) >= (7511 - 4000))) then
						return "freeze aoe 10";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and (v14:PrevGCDP(1237 - (298 + 938), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1260 - (233 + 1026)))))) or ((2990 - (636 + 1030)) > (1545 + 1475))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((2923 + 69) == (559 + 1322))) then
						return "ice_nova aoe 11";
					end
				end
				if (((210 + 2896) > (1747 - (55 + 166))) and v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and ((v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (v107 == (0 - 0))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (298 - (36 + 261)))))) then
					if (((5286 - 2263) < (5238 - (34 + 1334))) and v24(v99.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((55 + 88) > (58 + 16)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
					if (((1301 - (1035 + 248)) < (2133 - (20 + 1))) and v24(v99.ConeofCold, not v15:IsInRange(5 + 3))) then
						return "cone_of_cold aoe 14";
					end
				end
				v138 = 321 - (134 + 185);
			end
			if (((2230 - (549 + 584)) <= (2313 - (314 + 371))) and (v138 == (10 - 7))) then
				if (((5598 - (478 + 490)) == (2453 + 2177)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
					if (((4712 - (786 + 386)) > (8689 - 6006)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if (((6173 - (1055 + 324)) >= (4615 - (1093 + 247))) and v99.IceNova:IsCastable() and v48 and (v103 >= (4 + 0)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) then
					if (((157 + 1327) == (5891 - 4407)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if (((4859 - 3427) < (10115 - 6560)) and v99.DragonsBreath:IsCastable() and v39 and (v104 >= (17 - 10))) then
					if (v24(v99.DragonsBreath, not v15:IsInRange(4 + 6)) or ((4102 - 3037) > (12332 - 8754))) then
						return "dragons_breath aoe 26";
					end
				end
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (23 + 7)) and (v104 >= (17 - 10))) or ((5483 - (364 + 324)) < (3857 - 2450))) then
					if (((4446 - 2593) < (1596 + 3217)) and v24(v99.ArcaneExplosion, not v15:IsInRange(33 - 25))) then
						return "arcane_explosion aoe 28";
					end
				end
				v138 = 5 - 1;
			end
		end
	end
	local function v127()
		local v139 = 0 - 0;
		while true do
			if (((1269 - (1249 + 19)) == v139) or ((2547 + 274) < (9462 - 7031))) then
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (1091 - (686 + 400))) and (v99.Flurry:CooldownUp() or (v107 > (0 + 0)))) or ((3103 - (73 + 156)) < (11 + 2170))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((3500 - (721 + 90)) <= (4 + 339))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (6 - 4)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((2339 - (224 + 246)) == (3254 - 1245))) then
					if (v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb)) or ((6528 - 2982) < (422 + 1900))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (1 + 9)) and (v99.FrozenOrb:CooldownRemains() > (8 + 2)) and (v107 == (0 - 0)) and (v104 >= (9 - 6))) or ((2595 - (203 + 310)) == (6766 - (1238 + 755)))) then
					if (((227 + 3017) > (2589 - (709 + 825))) and v24(v99.ConeofCold)) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (3 - 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (3 - 0)))) or ((4177 - (196 + 668)) <= (7019 - 5241))) then
					if (v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes)) or ((2943 - 1522) >= (2937 - (171 + 662)))) then
						return "blizzard cleave 16";
					end
				end
				v139 = 95 - (4 + 89);
			end
			if (((6350 - 4538) <= (1184 + 2065)) and (v139 == (0 - 0))) then
				if (((637 + 986) <= (3443 - (35 + 1451))) and v99.CometStorm:IsCastable() and (v14:PrevGCDP(1454 - (28 + 1425), v99.Flurry) or v14:PrevGCDP(1994 - (941 + 1052), v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) then
					if (((4231 + 181) == (5926 - (822 + 692))) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if (((2498 - 748) >= (397 + 445)) and v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(298 - (45 + 252), v99.Frostbolt) and (v108 >= (3 + 0))) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or ((v108 >= (7 - 4)) and (v108 < (438 - (114 + 319))) and (v99.Flurry:ChargesFractional() == (2 - 0))))) then
					if (((5601 - 1229) > (1180 + 670)) and v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry))) then
						return "flurry cleave 4";
					end
					if (((344 - 112) < (1720 - 899)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
						return "flurry cleave 4";
					end
				end
				if (((2481 - (556 + 1407)) < (2108 - (741 + 465))) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (465 - (170 + 295))) and (v108 == (3 + 1)) and v14:BuffUp(v99.FingersofFrostBuff)) then
					local v204 = 0 + 0;
					while true do
						if (((7371 - 4377) > (712 + 146)) and (v204 == (0 + 0))) then
							if (v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance)) or ((2127 + 1628) <= (2145 - (957 + 273)))) then
								return "ice_lance cleave 6";
							end
							if (((1056 + 2890) > (1499 + 2244)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				if ((v99.RayofFrost:IsCastable() and (v107 == (3 - 2)) and v49) or ((3518 - 2183) >= (10097 - 6791))) then
					if (((23985 - 19141) > (4033 - (389 + 1391))) and v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (((284 + 168) == (48 + 404)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
				end
				v139 = 2 - 1;
			end
			if (((954 - (783 + 168)) == v139) or ((15294 - 10737) < (2053 + 34))) then
				if (((4185 - (309 + 2)) == (11896 - 8022)) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((3150 - (1090 + 122)) > (1600 + 3335))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((14290 - 10035) < (2343 + 1080))) then
					v31 = v125();
					if (((2572 - (628 + 490)) <= (447 + 2044)) and v31) then
						return v31;
					end
				end
				break;
			end
			if ((v139 == (4 - 2)) or ((18997 - 14840) <= (3577 - (431 + 343)))) then
				if (((9801 - 4948) >= (8626 - 5644)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (8 + 2)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (2 + 8))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (1705 - (556 + 1139))))) or (v99.IcyVeins:CooldownRemains() < (35 - (6 + 9))))) then
					if (((757 + 3377) > (1720 + 1637)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (174 - (28 + 141)))) or ((1324 + 2093) < (3127 - 593))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((1928 + 794) <= (1481 - (486 + 831)))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(2 - 1, v99.GlacialSpike)) or (v107 > (0 - 0)))) or ((456 + 1952) < (6668 - 4559))) then
					local v205 = 1263 - (668 + 595);
					while true do
						if ((v205 == (0 + 0)) or ((7 + 26) == (3967 - 2512))) then
							if (v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance)) or ((733 - (23 + 267)) >= (5959 - (1129 + 815)))) then
								return "ice_lance cleave 22";
							end
							if (((3769 - (371 + 16)) > (1916 - (1326 + 424))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (7 - 3))) or ((1023 - 743) == (3177 - (88 + 30)))) then
					if (((2652 - (720 + 51)) > (2876 - 1583)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v139 = 1779 - (421 + 1355);
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if (((1158 + 1199) == (3440 - (286 + 797))) and (v140 == (7 - 5))) then
				if (((202 - 79) == (562 - (397 + 42))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 + 0)) and (((v99.FrozenOrb:CooldownRemains() > (810 - (24 + 776))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (15 - 5))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (795 - (222 + 563))))) or (v99.IcyVeins:CooldownRemains() < (44 - 24)))) then
					if (v24(v99.ShiftingPower, not v15:IsInRange(29 + 11)) or ((1246 - (23 + 167)) >= (5190 - (690 + 1108)))) then
						return "shifting_power single 18";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (2 + 3))) or ((892 + 189) < (1923 - (40 + 808)))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((173 + 876) >= (16947 - 12515))) then
						return "glacial_spike single 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) or ((2523 + 2245) <= (464 + 382))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3929 - (47 + 524)) <= (922 + 498))) then
						return "ice_lance single 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (10 - 6))) or ((5590 - 1851) <= (6853 - 3848))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3385 - (1165 + 561)) >= (64 + 2070))) then
						return "ice_nova single 24";
					end
				end
				v140 = 9 - 6;
			end
			if ((v140 == (0 + 0)) or ((3739 - (341 + 138)) < (636 + 1719))) then
				if ((v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1 - 0, v99.Flurry) or v14:PrevGCDP(327 - (89 + 237), v99.ConeofCold))) or ((2151 - 1482) == (8890 - 4667))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((2573 - (581 + 300)) < (1808 - (855 + 365)))) then
						return "comet_storm single 2";
					end
				end
				if ((v99.Flurry:IsCastable() and (v107 == (0 - 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1 + 0, v99.Frostbolt) and (v108 >= (1238 - (1030 + 205)))) or (v14:PrevGCDP(1 + 0, v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (290 - (156 + 130))) and v14:BuffDown(v99.FingersofFrostBuff)))) or ((10899 - 6102) < (6153 - 2502))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((8554 - 4377) > (1278 + 3572))) then
						return "flurry single 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 + 0)) and (v108 == (73 - (10 + 59))) and v14:BuffUp(v99.FingersofFrostBuff)) or ((114 + 286) > (5471 - 4360))) then
					if (((4214 - (671 + 492)) > (801 + 204)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 6";
					end
				end
				if (((4908 - (369 + 846)) <= (1161 + 3221)) and v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1 + 0))) then
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((5227 - (1036 + 909)) > (3260 + 840))) then
						return "ray_of_frost single 8";
					end
				end
				v140 = 1 - 0;
			end
			if ((v140 == (206 - (11 + 192))) or ((1810 + 1770) < (3019 - (135 + 40)))) then
				if (((215 - 126) < (2707 + 1783)) and v90 and ((v93 and v34) or not v93)) then
					if (v99.BagofTricks:IsCastable() or ((10977 - 5994) < (2710 - 902))) then
						if (((4005 - (50 + 126)) > (10494 - 6725)) and v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((329 + 1156) <= (4317 - (1233 + 180))) and v99.Frostbolt:IsCastable() and v41) then
					if (((5238 - (522 + 447)) == (5690 - (107 + 1314))) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
						return "frostbolt single 26";
					end
				end
				if (((180 + 207) <= (8476 - 5694)) and v14:IsMoving() and v95) then
					local v206 = 0 + 0;
					while true do
						if ((v206 == (0 - 0)) or ((7513 - 5614) <= (2827 - (716 + 1194)))) then
							v31 = v125();
							if (v31 or ((74 + 4238) <= (94 + 782))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((2735 - (74 + 429)) <= (5007 - 2411)) and (v140 == (1 + 0))) then
				if (((4795 - 2700) < (2608 + 1078)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (15 - 10)) and ((v99.Flurry:Charges() >= (2 - 1)) or ((v107 > (433 - (279 + 154))) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((2373 - (454 + 324)) >= (3520 + 954))) then
						return "glacial_spike single 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (17 - (12 + 5))) and (v14:BuffStackP(v99.FingersofFrostBuff) < (2 + 0)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((11769 - 7150) < (1065 + 1817))) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(1133 - (277 + 816))) or ((1256 - 962) >= (6014 - (1058 + 125)))) then
						return "frozen_orb single 12";
					end
				end
				if (((381 + 1648) <= (4059 - (815 + 160))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (42 - 32)) and (v99.FrozenOrb:CooldownRemains() > (23 - 13)) and (v107 == (0 + 0)) and (v103 >= (8 - 5))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(1906 - (41 + 1857))) or ((3930 - (1222 + 671)) == (6254 - 3834))) then
						return "cone_of_cold single 14";
					end
				end
				if (((6407 - 1949) > (5086 - (229 + 953))) and v99.Blizzard:IsCastable() and v38 and (v103 >= (1776 - (1111 + 663))) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (1582 - (874 + 705))))) then
					if (((62 + 374) >= (84 + 39)) and v24(v101.BlizzardCursor, not v15:IsInRange(83 - 43), v14:BuffDown(v99.IceFloes))) then
						return "blizzard single 16";
					end
				end
				v140 = 1 + 1;
			end
		end
	end
	local function v129()
		v36 = EpicSettings.Settings['useArcaneExplosion'];
		v37 = EpicSettings.Settings['useArcaneIntellect'];
		v38 = EpicSettings.Settings['useBlizzard'];
		v39 = EpicSettings.Settings['useDragonsBreath'];
		v40 = EpicSettings.Settings['useFireBlast'];
		v41 = EpicSettings.Settings['useFrostbolt'];
		v42 = EpicSettings.Settings['useFrostNova'];
		v43 = EpicSettings.Settings['useFlurry'];
		v44 = EpicSettings.Settings['useFreezePet'];
		v45 = EpicSettings.Settings['useGlacialSpike'];
		v46 = EpicSettings.Settings['useIceFloes'];
		v47 = EpicSettings.Settings['useIceLance'];
		v48 = EpicSettings.Settings['useIceNova'];
		v49 = EpicSettings.Settings['useRayOfFrost'];
		v50 = EpicSettings.Settings['useCounterspell'];
		v51 = EpicSettings.Settings['useBlastWave'];
		v52 = EpicSettings.Settings['useIcyVeins'];
		v53 = EpicSettings.Settings['useFrozenOrb'];
		v54 = EpicSettings.Settings['useCometStorm'];
		v55 = EpicSettings.Settings['useConeOfCold'];
		v56 = EpicSettings.Settings['useShiftingPower'];
		v57 = EpicSettings.Settings['icyVeinsWithCD'];
		v58 = EpicSettings.Settings['frozenOrbWithCD'];
		v59 = EpicSettings.Settings['cometStormWithCD'];
		v60 = EpicSettings.Settings['coneOfColdWithCD'];
		v61 = EpicSettings.Settings['shiftingPowerWithCD'];
		v62 = EpicSettings.Settings['useAlterTime'];
		v63 = EpicSettings.Settings['useIceBarrier'];
		v64 = EpicSettings.Settings['useGreaterInvisibility'];
		v65 = EpicSettings.Settings['useIceBlock'];
		v66 = EpicSettings.Settings['useIceCold'];
		v67 = EpicSettings.Settings['useMassBarrier'];
		v68 = EpicSettings.Settings['useMirrorImage'];
		v69 = EpicSettings.Settings['alterTimeHP'] or (679 - (642 + 37));
		v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
		v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v72 = EpicSettings.Settings['iceBlockHP'] or (454 - (233 + 221));
		v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v94 = EpicSettings.Settings['useSpellStealTarget'];
		v95 = EpicSettings.Settings['useSpellsWhileMoving'];
		v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v97 = EpicSettings.Settings['mirrorImageBeforePull'];
		v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v130()
		local v179 = 1541 - (718 + 823);
		while true do
			if (((315 + 185) < (2621 - (266 + 539))) and (v179 == (2 - 1))) then
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v91 = EpicSettings.Settings['useTrinkets'];
				v179 = 1227 - (636 + 589);
			end
			if (((8483 - 4909) == (7371 - 3797)) and (v179 == (4 + 0))) then
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((81 + 140) < (1405 - (657 + 358))) and ((4 - 2) == v179)) then
				v90 = EpicSettings.Settings['useRacials'];
				v92 = EpicSettings.Settings['trinketsWithCD'];
				v93 = EpicSettings.Settings['racialsWithCD'];
				v86 = EpicSettings.Settings['useHealthstone'];
				v179 = 6 - 3;
			end
			if (((1187 - (1151 + 36)) == v179) or ((2138 + 75) <= (374 + 1047))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v84 = EpicSettings.Settings['useWeapon'];
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v179 = 1833 - (1552 + 280);
			end
			if (((3892 - (64 + 770)) < (3300 + 1560)) and (v179 == (6 - 3))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v87 = EpicSettings.Settings['healingPotionHP'] or (1243 - (157 + 1086));
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v179 = 7 - 3;
			end
		end
	end
	local function v131()
		local v180 = 0 - 0;
		while true do
			if (((2 - 0) == v180) or ((1768 - 472) >= (5265 - (599 + 220)))) then
				if (v14:IsDeadOrGhost() or ((2773 - 1380) > (6420 - (1813 + 118)))) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(4 + 1);
				v106 = v14:GetEnemiesInRange(1257 - (841 + 376));
				v180 = 3 - 0;
			end
			if (((1 + 0) == v180) or ((12075 - 7651) < (886 - (464 + 395)))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v180 = 5 - 3;
			end
			if ((v180 == (2 + 1)) or ((2834 - (467 + 370)) > (7883 - 4068))) then
				if (((2544 + 921) > (6557 - 4644)) and v33) then
					local v207 = 0 + 0;
					while true do
						if (((1705 - 972) < (2339 - (150 + 370))) and (v207 == (1282 - (74 + 1208)))) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(12 - 7), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(23 - 18), #v106);
							break;
						end
					end
				else
					local v208 = 0 + 0;
					while true do
						if (((390 - (14 + 376)) == v208) or ((7623 - 3228) == (3077 + 1678))) then
							v103 = 1 + 0;
							v104 = 1 + 0;
							break;
						end
					end
				end
				if (not v14:AffectingCombat() or ((11113 - 7320) < (1783 + 586))) then
					if ((v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) or ((4162 - (23 + 55)) == (628 - 363))) then
						if (((2909 + 1449) == (3914 + 444)) and v24(v99.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v113.TargetIsValid() or v14:AffectingCombat() or ((4864 - 1726) < (313 + 680))) then
					local v209 = 901 - (652 + 249);
					while true do
						if (((8911 - 5581) > (4191 - (708 + 1160))) and (v209 == (2 - 1))) then
							if ((v111 == (20257 - 9146)) or ((3653 - (10 + 17)) == (896 + 3093))) then
								v111 = v10.FightRemains(v106, false);
							end
							v107 = v15:DebuffStack(v99.WintersChillDebuff);
							v209 = 1734 - (1400 + 332);
						end
						if ((v209 == (3 - 1)) or ((2824 - (242 + 1666)) == (1143 + 1528))) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
						if (((100 + 172) == (232 + 40)) and (v209 == (940 - (850 + 90)))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v209 = 1 - 0;
						end
					end
				end
				v180 = 1394 - (360 + 1030);
			end
			if (((3761 + 488) <= (13657 - 8818)) and (v180 == (5 - 1))) then
				if (((4438 - (909 + 752)) < (4423 - (109 + 1114))) and v113.TargetIsValid()) then
					local v210 = 0 - 0;
					while true do
						if (((37 + 58) < (2199 - (6 + 236))) and ((2 + 0) == v210)) then
							if (((665 + 161) < (4048 - 2331)) and (v14:AffectingCombat() or v77)) then
								local v211 = 0 - 0;
								local v212;
								while true do
									if (((2559 - (1076 + 57)) >= (182 + 923)) and (v211 == (690 - (579 + 110)))) then
										if (((218 + 2536) <= (2988 + 391)) and v31) then
											return v31;
										end
										break;
									end
									if ((v211 == (0 + 0)) or ((4334 - (174 + 233)) == (3946 - 2533))) then
										v212 = v77 and v99.RemoveCurse:IsReady() and v35;
										v31 = v113.FocusUnit(v212, nil, 35 - 15, nil, 9 + 11, v99.ArcaneIntellect);
										v211 = 1175 - (663 + 511);
									end
								end
							end
							if (v78 or ((1030 + 124) <= (172 + 616))) then
								if (v98 or ((5065 - 3422) > (2047 + 1332))) then
									v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 70 - 40);
									if (v31 or ((6785 - 3982) > (2171 + 2378))) then
										return v31;
									end
								end
							end
							v210 = 5 - 2;
						end
						if ((v210 == (3 + 1)) or ((21 + 199) >= (3744 - (478 + 244)))) then
							if (((3339 - (440 + 77)) == (1284 + 1538)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
								local v213 = 0 - 0;
								while true do
									if ((v213 == (1558 - (655 + 901))) or ((197 + 864) == (1422 + 435))) then
										v31 = v128();
										if (((1864 + 896) > (5494 - 4130)) and v31) then
											return v31;
										end
										v213 = 1448 - (695 + 750);
									end
									if ((v213 == (9 - 6)) or ((7564 - 2662) <= (14458 - 10863))) then
										if (v24(v99.Pool) or ((4203 - (285 + 66)) == (682 - 389))) then
											return "pool for ST()";
										end
										if ((v14:IsMoving() and v95) or ((2869 - (682 + 628)) == (740 + 3848))) then
											local v215 = 299 - (176 + 123);
											while true do
												if ((v215 == (0 + 0)) or ((3253 + 1231) == (1057 - (239 + 30)))) then
													v31 = v125();
													if (((1242 + 3326) >= (3756 + 151)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
									if (((2204 - 958) < (10826 - 7356)) and (v213 == (315 - (306 + 9)))) then
										if (((14195 - 10127) >= (170 + 802)) and v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) then
											if (((303 + 190) < (1874 + 2019)) and v24(v101.UseWeapon, nil)) then
												return "Using Weapon Macro";
											end
										end
										if (v34 or ((4212 - 2739) >= (4707 - (1140 + 235)))) then
											local v216 = 0 + 0;
											while true do
												if ((v216 == (0 + 0)) or ((1040 + 3011) <= (1209 - (33 + 19)))) then
													v31 = v124();
													if (((219 + 385) < (8635 - 5754)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										v213 = 1 + 0;
									end
									if ((v213 == (1 - 0)) or ((844 + 56) == (4066 - (586 + 103)))) then
										if (((406 + 4053) > (1819 - 1228)) and v33 and (((v104 >= (1495 - (1309 + 179))) and not v14:HasTier(54 - 24, 1 + 1)) or ((v104 >= (7 - 4)) and v99.IceCaller:IsAvailable()))) then
											v31 = v126();
											if (((2567 + 831) >= (5088 - 2693)) and v31) then
												return v31;
											end
											if (v24(v99.Pool) or ((4349 - 2166) >= (3433 - (295 + 314)))) then
												return "pool for Aoe()";
											end
										end
										if (((4755 - 2819) == (3898 - (1300 + 662))) and v33 and (v104 == (6 - 4))) then
											v31 = v127();
											if (v31 or ((6587 - (1178 + 577)) < (2240 + 2073))) then
												return v31;
											end
											if (((12084 - 7996) > (5279 - (851 + 554))) and v24(v99.Pool)) then
												return "pool for Cleave()";
											end
										end
										v213 = 2 + 0;
									end
								end
							end
							break;
						end
						if (((12013 - 7681) == (9408 - 5076)) and (v210 == (302 - (115 + 187)))) then
							if (((3063 + 936) >= (2746 + 154)) and v77 and v35 and v99.RemoveCurse:IsAvailable()) then
								local v214 = 0 - 0;
								while true do
									if ((v214 == (1161 - (160 + 1001))) or ((2209 + 316) > (2805 + 1259))) then
										if (((8947 - 4576) == (4729 - (237 + 121))) and v16) then
											local v217 = 897 - (525 + 372);
											while true do
												if ((v217 == (0 - 0)) or ((873 - 607) > (5128 - (96 + 46)))) then
													v31 = v121();
													if (((2768 - (643 + 134)) >= (334 + 591)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										if (((1090 - 635) < (7622 - 5569)) and v17 and v17:Exists() and not v14:CanAttack(v17) and v113.UnitHasCurseDebuff(v17)) then
											if (v99.RemoveCurse:IsReady() or ((793 + 33) == (9520 - 4669))) then
												if (((373 - 190) == (902 - (316 + 403))) and v24(v101.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if (((771 + 388) <= (4915 - 3127)) and not v14:AffectingCombat() and v32) then
								v31 = v123();
								if (v31 or ((1268 + 2239) > (10874 - 6556))) then
									return v31;
								end
							end
							v210 = 1 + 0;
						end
						if ((v210 == (1 + 0)) or ((10654 - 7579) <= (14160 - 11195))) then
							v31 = v119();
							if (((2835 - 1470) <= (116 + 1895)) and v31) then
								return v31;
							end
							v210 = 3 - 1;
						end
						if (((1 + 2) == v210) or ((8167 - 5391) > (3592 - (12 + 5)))) then
							if (v79 or ((9919 - 7365) == (10249 - 5445))) then
								v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 63 - 33);
								if (((6390 - 3813) == (524 + 2053)) and v31) then
									return v31;
								end
							end
							if ((v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) or ((1979 - (1656 + 317)) >= (1684 + 205))) then
								if (((406 + 100) <= (5030 - 3138)) and v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v210 = 19 - 15;
						end
					end
				end
				break;
			end
			if ((v180 == (354 - (5 + 349))) or ((9537 - 7529) > (3489 - (266 + 1005)))) then
				v129();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v180 = 1 + 0;
			end
		end
	end
	local function v132()
		v114();
		v99.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(218 - 154, v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

