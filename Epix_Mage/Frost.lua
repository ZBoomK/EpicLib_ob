local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 776 - (765 + 11);
	local v6;
	while true do
		if (((366 + 1098) <= (4900 - (423 + 100))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((7445 - 4756) < (2462 + 2261)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 772 - (326 + 445);
		end
		if (((18049 - 13913) >= (5340 - 2943)) and (v5 == (2 - 1))) then
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
	local v107 = 711 - (530 + 181);
	local v108 = 881 - (614 + 267);
	local v109 = 47 - (19 + 13);
	local v110 = 18084 - 6973;
	local v111 = 25892 - 14781;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((12380 - 8046) == (1103 + 3142))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(148996 - 64275);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(474074 - 245477);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(230166 - (1293 + 519));
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(466411 - 237813);
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(596863 - 368263);
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v133 = 0 - 0;
		while true do
			if (((4 - 3) == v133) or ((10072 - 5796) <= (1606 + 1425))) then
				v107 = 0 + 0;
				break;
			end
			if ((v133 == (0 - 0)) or ((1106 + 3676) <= (399 + 800))) then
				v110 = 6944 + 4167;
				v111 = 12207 - (709 + 387);
				v133 = 1859 - (673 + 1185);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v134)
		if ((v134 == nil) or ((14106 - 9242) < (6107 - 4205))) then
			v134 = v15;
		end
		return not v134:IsInBossList() or (v134:Level() < (119 - 46));
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
		local v137 = 0 + 0;
		while true do
			if (((3616 + 1223) >= (4995 - 1295)) and (v137 == (1 + 2))) then
				if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((2143 - 1068) > (3764 - 1846))) then
					if (((2276 - (446 + 1434)) <= (5087 - (1040 + 243))) and v24(v99.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((12442 - 8273) == (4034 - (559 + 1288)))) then
					if (((3337 - (609 + 1322)) == (1860 - (13 + 441))) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v137 = 14 - 10;
			end
			if (((4010 - 2479) < (21271 - 17000)) and (v137 == (1 + 1))) then
				if (((2306 - 1671) == (226 + 409)) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (((1478 + 1895) <= (10552 - 6996)) and v24(v99.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((1801 + 1490) < (6032 - 2752))) then
					if (((2900 + 1486) >= (486 + 387)) and v24(v99.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v137 = 3 + 0;
			end
			if (((774 + 147) <= (1079 + 23)) and (v137 == (433 - (153 + 280)))) then
				if (((13588 - 8882) >= (865 + 98)) and v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v99.IceBarrier) or ((380 + 580) <= (459 + 417))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 2 + 0, v99.ArcaneIntellect)) or ((1498 + 568) == (1418 - 486))) then
					if (((2983 + 1842) < (5510 - (89 + 578))) and v24(v99.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v137 = 1 + 0;
			end
			if (((8 - 4) == v137) or ((4926 - (572 + 477)) >= (612 + 3925))) then
				if ((v85 and (v14:HealthPercentage() <= v87)) or ((2590 + 1725) < (207 + 1519))) then
					local v215 = 86 - (84 + 2);
					while true do
						if ((v215 == (0 - 0)) or ((2651 + 1028) < (1467 - (497 + 345)))) then
							if ((v89 == "Refreshing Healing Potion") or ((119 + 4506) < (107 + 525))) then
								if (v100.RefreshingHealingPotion:IsReady() or ((1416 - (605 + 728)) > (1270 + 510))) then
									if (((1213 - 667) <= (50 + 1027)) and v24(v101.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or ((3682 - 2686) > (3878 + 423))) then
								if (((11276 - 7206) > (519 + 168)) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((1145 - (457 + 32)) >= (1413 + 1917))) then
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
			if ((v137 == (1403 - (832 + 570))) or ((2348 + 144) <= (88 + 247))) then
				if (((15294 - 10972) >= (1235 + 1327)) and v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (v24(v99.IceColdAbility) or ((4433 - (588 + 208)) >= (10161 - 6391))) then
						return "ice_cold defensive 3";
					end
				end
				if ((v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((4179 - (884 + 916)) > (9584 - 5006))) then
					if (v24(v99.IceBlock) or ((281 + 202) > (1396 - (232 + 421)))) then
						return "ice_block defensive 4";
					end
				end
				v137 = 1891 - (1569 + 320);
			end
		end
	end
	local v120 = 0 + 0;
	local function v121()
		if (((467 + 1987) > (1947 - 1369)) and v99.RemoveCurse:IsReady() and v113.UnitHasDispellableDebuffByPlayer(v16)) then
			if (((1535 - (316 + 289)) < (11669 - 7211)) and (v120 == (0 + 0))) then
				v120 = GetTime();
			end
			if (((2115 - (666 + 787)) <= (1397 - (360 + 65))) and v113.Wait(468 + 32, v120)) then
				local v209 = 254 - (79 + 175);
				while true do
					if (((6890 - 2520) == (3411 + 959)) and ((0 - 0) == v209)) then
						if (v24(v101.RemoveCurseFocus) or ((9170 - 4408) <= (1760 - (503 + 396)))) then
							return "remove_curse dispel";
						end
						v120 = 181 - (92 + 89);
						break;
					end
				end
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (0 + 0)) or ((836 + 576) == (16698 - 12434))) then
				v31 = v113.HandleTopTrinket(v102, v34, 6 + 34, nil);
				if (v31 or ((7223 - 4055) < (1879 + 274))) then
					return v31;
				end
				v138 = 1 + 0;
			end
			if ((v138 == (2 - 1)) or ((622 + 4354) < (2030 - 698))) then
				v31 = v113.HandleBottomTrinket(v102, v34, 1284 - (485 + 759), nil);
				if (((10708 - 6080) == (5817 - (442 + 747))) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((1189 - (832 + 303)) == (1341 - (88 + 858)))) then
			if (((25 + 57) == (68 + 14)) and v99.MirrorImage:IsCastable() and v68 and v97) then
				if (v24(v99.MirrorImage) or ((24 + 557) < (1071 - (766 + 23)))) then
					return "mirror_image precombat 2";
				end
			end
			if ((v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) or ((22753 - 18144) < (3411 - 916))) then
				if (((3034 - 1882) == (3909 - 2757)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v124()
		if (((2969 - (1036 + 37)) <= (2427 + 995)) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 - 0, v99.IcyVeins)) then
			if (v24(v99.TimeWarp, not v15:IsInRange(32 + 8)) or ((2470 - (641 + 839)) > (2533 - (910 + 3)))) then
				return "time_warp cd 2";
			end
		end
		local v139 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (v139 or ((2235 - 1358) > (6379 - (1466 + 218)))) then
			return v139;
		end
		if (((1237 + 1454) >= (2999 - (556 + 592))) and v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) then
			if (v24(v99.IcyVeins) or ((1062 + 1923) >= (5664 - (329 + 479)))) then
				return "icy_veins cd 6";
			end
		end
		if (((5130 - (174 + 680)) >= (4106 - 2911)) and (v83 < v111)) then
			if (((6698 - 3466) <= (3349 + 1341)) and v91 and ((v34 and v92) or not v92)) then
				local v210 = 739 - (396 + 343);
				while true do
					if (((0 + 0) == v210) or ((2373 - (29 + 1448)) >= (4535 - (135 + 1254)))) then
						v31 = v122();
						if (((11531 - 8470) >= (13811 - 10853)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if (((2124 + 1063) >= (2171 - (389 + 1138))) and v90 and ((v93 and v34) or not v93) and (v83 < v111)) then
			local v152 = 574 - (102 + 472);
			while true do
				if (((608 + 36) <= (391 + 313)) and ((0 + 0) == v152)) then
					if (((2503 - (320 + 1225)) > (1685 - 738)) and v99.BloodFury:IsCastable()) then
						if (((2749 + 1743) >= (4118 - (157 + 1307))) and v24(v99.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((5301 - (821 + 1038)) >= (3749 - 2246)) and v99.Berserking:IsCastable()) then
						if (v24(v99.Berserking) or ((347 + 2823) <= (2600 - 1136))) then
							return "berserking cd 12";
						end
					end
					v152 = 1 + 0;
				end
				if ((v152 == (2 - 1)) or ((5823 - (834 + 192)) == (279 + 4109))) then
					if (((142 + 409) <= (15 + 666)) and v99.LightsJudgment:IsCastable()) then
						if (((5075 - 1798) > (711 - (300 + 4))) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (((1254 + 3441) >= (3704 - 2289)) and v99.Fireblood:IsCastable()) then
						if (v24(v99.Fireblood) or ((3574 - (112 + 250)) <= (377 + 567))) then
							return "fireblood cd 16";
						end
					end
					v152 = 4 - 2;
				end
				if ((v152 == (2 + 0)) or ((1602 + 1494) <= (1345 + 453))) then
					if (((1754 + 1783) == (2628 + 909)) and v99.AncestralCall:IsCastable()) then
						if (((5251 - (1001 + 413)) >= (3501 - 1931)) and v24(v99.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		local v140 = 882 - (244 + 638);
		while true do
			if ((v140 == (694 - (627 + 66))) or ((8789 - 5839) == (4414 - (512 + 90)))) then
				if (((6629 - (1665 + 241)) >= (3035 - (373 + 344))) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (14 + 16)) and (v104 >= (1 + 1))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(20 - 12)) or ((3430 - 1403) > (3951 - (35 + 1064)))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((827 + 309) > (9236 - 4919))) then
					if (((19 + 4729) == (5984 - (298 + 938))) and v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v140 = 1261 - (233 + 1026);
			end
			if (((5402 - (636 + 1030)) <= (2424 + 2316)) and (v140 == (0 + 0))) then
				if ((v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) or ((1008 + 2382) <= (207 + 2853))) then
					if (v24(v99.IceFloes) or ((1220 - (55 + 166)) > (522 + 2171))) then
						return "ice_floes movement";
					end
				end
				if (((47 + 416) < (2295 - 1694)) and v99.IceNova:IsCastable() and v48) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((2480 - (36 + 261)) < (1201 - 514))) then
						return "ice_nova movement";
					end
				end
				v140 = 1369 - (34 + 1334);
			end
			if (((1749 + 2800) == (3535 + 1014)) and (v140 == (1285 - (1035 + 248)))) then
				if (((4693 - (20 + 1)) == (2435 + 2237)) and v99.IceLance:IsCastable() and v47) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3987 - (134 + 185)) < (1528 - (549 + 584)))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v141 = 685 - (314 + 371);
		while true do
			if ((v141 == (17 - 12)) or ((5134 - (478 + 490)) == (242 + 213))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1202 - (786 + 386))) and (v104 >= (22 - 15))) or ((5828 - (1055 + 324)) == (4003 - (1093 + 247)))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(8 + 0)) or ((450 + 3827) < (11866 - 8877))) then
						return "arcane_explosion aoe 28";
					end
				end
				if ((v99.Frostbolt:IsCastable() and v41) or ((2952 - 2082) >= (11805 - 7656))) then
					if (((5558 - 3346) < (1133 + 2050)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
						return "frostbolt aoe 32";
					end
				end
				if (((17898 - 13252) > (10312 - 7320)) and v14:IsMoving() and v95) then
					v31 = v125();
					if (((1082 + 352) < (7943 - 4837)) and v31) then
						return v31;
					end
				end
				break;
			end
			if (((1474 - (364 + 324)) < (8286 - 5263)) and (v141 == (0 - 0))) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1 + 0, v99.CometStorm) or (v14:PrevGCDP(4 - 3, v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((3910 - 1468) < (224 - 150))) then
					if (((5803 - (1249 + 19)) == (4094 + 441)) and v24(v99.ConeofCold, not v15:IsInRange(31 - 23))) then
						return "cone_of_cold aoe 2";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1087 - (686 + 400), v99.GlacialSpike) or not v115())) or ((2361 + 648) <= (2334 - (73 + 156)))) then
					if (((9 + 1821) < (4480 - (721 + 90))) and v24(v101.FrozenOrbCast, not v15:IsInRange(1 + 39))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(3 - 2, v99.GlacialSpike) or not v115())) or ((1900 - (224 + 246)) >= (5851 - 2239))) then
					if (((4939 - 2256) >= (447 + 2013)) and v24(v101.BlizzardCursor, not v15:IsInRange(1 + 39), v14:BuffDown(v99.IceFloes))) then
						return "blizzard aoe 6";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (3 - 1)) or ((6003 - 4199) >= (3788 - (203 + 310)))) then
				if ((v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1994 - (1238 + 755), v99.Freeze) and ((v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (v107 == (1534 - (709 + 825)))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 - 0))))) or ((2064 - 647) > (4493 - (196 + 668)))) then
					if (((18932 - 14137) > (832 - 430)) and v24(v99.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((5646 - (171 + 662)) > (3658 - (4 + 89))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
					if (((13711 - 9799) == (1425 + 2487)) and v24(v99.ConeofCold, not v15:IsInRange(35 - 27))) then
						return "cone_of_cold aoe 14";
					end
				end
				if (((1107 + 1714) <= (6310 - (35 + 1451))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
					if (((3191 - (28 + 1425)) <= (4188 - (941 + 1052))) and v24(v99.ShiftingPower, not v15:IsInRange(39 + 1), true)) then
						return "shifting_power aoe 16";
					end
				end
				v141 = 1517 - (822 + 692);
			end
			if (((58 - 17) <= (1422 + 1596)) and (v141 == (300 - (45 + 252)))) then
				if (((2123 + 22) <= (1413 + 2691)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (12 - 7)) and (v99.Blizzard:CooldownRemains() > v112)) then
					if (((3122 - (114 + 319)) < (6955 - 2110)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (0 - 0)) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (1.8 - 0)))) or ((4864 - 2542) > (4585 - (556 + 1407)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((5740 - (741 + 465)) == (2547 - (170 + 295)))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 + 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((1444 + 127) > (4596 - 2729))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((2201 + 453) >= (1922 + 1074))) then
						return "flurry aoe 21";
					end
				end
				v141 = 3 + 1;
			end
			if (((5208 - (957 + 273)) > (563 + 1541)) and (v141 == (1 + 0))) then
				if (((11412 - 8417) > (4060 - 2519)) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(2 - 1, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (123 - 98))) or (v99.ConeofCold:CooldownRemains() > (1800 - (389 + 1391))))) then
					if (((2039 + 1210) > (100 + 853)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				if ((v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 - 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(952 - (783 + 168), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) or ((10984 - 7711) > (4499 + 74))) then
					if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((3462 - (309 + 2)) < (3942 - 2658))) then
						return "freeze aoe 10";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1213 - (1090 + 122), v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (3 - 2))))) or ((1267 + 583) == (2647 - (628 + 490)))) then
					if (((148 + 673) < (5256 - 3133)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				v141 = 9 - 7;
			end
			if (((1676 - (431 + 343)) < (4695 - 2370)) and (v141 == (11 - 7))) then
				if (((678 + 180) <= (379 + 2583)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((5641 - (556 + 1139)) < (1303 - (6 + 9)))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v103 >= (1 + 3)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) or ((1661 + 1581) == (736 - (28 + 141)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((329 + 518) >= (1558 - 295))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (5 + 2))) or ((3570 - (486 + 831)) == (4816 - 2965))) then
					if (v24(v99.DragonsBreath, not v15:IsInRange(35 - 25)) or ((395 + 1692) > (7500 - 5128))) then
						return "dragons_breath aoe 26";
					end
				end
				v141 = 1268 - (668 + 595);
			end
		end
	end
	local function v127()
		if ((v99.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) or ((12121 - 7676) < (4439 - (23 + 267)))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((3762 - (1129 + 815)) == (472 - (371 + 16)))) then
				return "comet_storm cleave 2";
			end
		end
		if (((2380 - (1326 + 424)) < (4028 - 1901)) and v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(3 - 2, v99.Frostbolt) and (v108 >= (121 - (88 + 30)))) or v14:PrevGCDP(772 - (720 + 51), v99.GlacialSpike) or ((v108 >= (6 - 3)) and (v108 < (1781 - (421 + 1355))) and (v99.Flurry:ChargesFractional() == (2 - 0))))) then
			if (v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry)) or ((952 + 986) == (3597 - (286 + 797)))) then
				return "flurry cleave 4";
			end
			if (((15554 - 11299) >= (90 - 35)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
				return "flurry cleave 4";
			end
		end
		if (((3438 - (397 + 42)) > (362 + 794)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (800 - (24 + 776))) and (v108 == (5 - 1)) and v14:BuffUp(v99.FingersofFrostBuff)) then
			local v153 = 785 - (222 + 563);
			while true do
				if (((5177 - 2827) > (832 + 323)) and (v153 == (190 - (23 + 167)))) then
					if (((5827 - (690 + 1108)) <= (1751 + 3102)) and v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((426 + 90) > (4282 - (40 + 808)))) then
						return "ice_lance cleave 6";
					end
					break;
				end
			end
		end
		if (((667 + 3379) >= (11598 - 8565)) and v99.RayofFrost:IsCastable() and (v107 == (1 + 0)) and v49) then
			if (v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost)) or ((1439 + 1280) <= (794 + 653))) then
				return "ray_of_frost cleave 8";
			end
			if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((4705 - (47 + 524)) < (2548 + 1378))) then
				return "ray_of_frost cleave 8";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (13 - 8)) and (v99.Flurry:CooldownUp() or (v107 > (0 - 0)))) or ((373 - 209) >= (4511 - (1165 + 561)))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((16 + 509) == (6531 - 4422))) then
				return "glacial_spike cleave 10";
			end
		end
		if (((13 + 20) == (512 - (341 + 138))) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (1 + 1)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
			if (((6302 - 3248) <= (4341 - (89 + 237))) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if (((6018 - 4147) < (7119 - 3737)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (891 - (581 + 300))) and (v99.FrozenOrb:CooldownRemains() > (1230 - (855 + 365))) and (v107 == (0 - 0)) and (v104 >= (1 + 2))) then
			if (((2528 - (1030 + 205)) <= (2034 + 132)) and v24(v99.ConeofCold)) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (2 + 0)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (289 - (156 + 130))))) or ((5859 - 3280) < (207 - 84))) then
			if (v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes)) or ((1732 - 886) >= (624 + 1744))) then
				return "blizzard cleave 16";
			end
		end
		if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (6 + 4)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (79 - (10 + 59)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (3 + 7)))) or (v99.IcyVeins:CooldownRemains() < (98 - 78)))) or ((5175 - (671 + 492)) <= (2674 + 684))) then
			if (((2709 - (369 + 846)) <= (796 + 2209)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
				return "shifting_power cleave 18";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (5 + 0))) or ((5056 - (1036 + 909)) == (1697 + 437))) then
			if (((3953 - 1598) == (2558 - (11 + 192))) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
				return "glacial_spike cleave 20";
			end
		end
		if ((v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike)) or (v107 > (175 - (135 + 40))))) or ((1424 - 836) <= (261 + 171))) then
			local v154 = 0 - 0;
			while true do
				if (((7190 - 2393) >= (4071 - (50 + 126))) and (v154 == (0 - 0))) then
					if (((792 + 2785) == (4990 - (1233 + 180))) and v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (((4763 - (522 + 447)) > (5114 - (107 + 1314))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and (v104 >= (2 + 2))) or ((3885 - 2610) == (1742 + 2358))) then
			if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3159 - 1568) >= (14164 - 10584))) then
				return "ice_nova cleave 24";
			end
		end
		if (((2893 - (716 + 1194)) <= (31 + 1777)) and v99.Frostbolt:IsCastable() and v41) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((231 + 1919) <= (1700 - (74 + 429)))) then
				return "frostbolt cleave 26";
			end
		end
		if (((7270 - 3501) >= (582 + 591)) and v14:IsMoving() and v95) then
			local v155 = 0 - 0;
			while true do
				if (((1051 + 434) == (4577 - 3092)) and (v155 == (0 - 0))) then
					v31 = v125();
					if (v31 or ((3748 - (279 + 154)) <= (3560 - (454 + 324)))) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v128()
		local v142 = 0 + 0;
		while true do
			if (((18 - (12 + 5)) == v142) or ((473 + 403) >= (7552 - 4588))) then
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (2 + 3)) and ((v99.Flurry:Charges() >= (1094 - (277 + 816))) or ((v107 > (0 - 0)) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) or ((3415 - (1058 + 125)) > (469 + 2028))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((3085 - (815 + 160)) <= (1424 - 1092))) then
						return "glacial_spike single 10";
					end
				end
				if (((8749 - 5063) > (757 + 2415)) and v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (0 - 0)) and (v14:BuffStackP(v99.FingersofFrostBuff) < (1900 - (41 + 1857))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(1933 - (1222 + 671))) or ((11563 - 7089) < (1178 - 358))) then
						return "frozen_orb single 12";
					end
				end
				if (((5461 - (229 + 953)) >= (4656 - (1111 + 663))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (1589 - (874 + 705))) and (v99.FrozenOrb:CooldownRemains() > (2 + 8)) and (v107 == (0 + 0)) and (v103 >= (6 - 3))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(1 + 7)) or ((2708 - (642 + 37)) >= (803 + 2718))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (7 - 4)))) or ((2491 - (233 + 221)) >= (10733 - 6091))) then
					if (((1514 + 206) < (5999 - (718 + 823))) and v24(v101.BlizzardCursor, not v15:IsInRange(26 + 14), v14:BuffDown(v99.IceFloes))) then
						return "blizzard single 16";
					end
				end
				v142 = 807 - (266 + 539);
			end
			if ((v142 == (5 - 3)) or ((1661 - (636 + 589)) > (7171 - 4150))) then
				if (((1470 - 757) <= (672 + 175)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 + 0)) and (((v99.FrozenOrb:CooldownRemains() > (1025 - (657 + 358))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (26 - 16))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (22 - 12)))) or (v99.IcyVeins:CooldownRemains() < (1207 - (1151 + 36))))) then
					if (((2081 + 73) <= (1060 + 2971)) and v24(v99.ShiftingPower, not v15:IsInRange(119 - 79))) then
						return "shifting_power single 18";
					end
				end
				if (((6447 - (1552 + 280)) == (5449 - (64 + 770))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (4 + 1))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((8603 - 4813) == (89 + 411))) then
						return "glacial_spike single 20";
					end
				end
				if (((1332 - (157 + 1086)) < (442 - 221)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(4 - 3, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
					if (((3150 - 1096) >= (1939 - 518)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((1511 - (599 + 220)) < (6089 - 3031)) and v99.IceNova:IsCastable() and v48 and (v104 >= (1935 - (1813 + 118)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((2379 + 875) == (2872 - (841 + 376)))) then
						return "ice_nova single 24";
					end
				end
				v142 = 3 - 0;
			end
			if ((v142 == (1 + 2)) or ((3537 - 2241) == (5769 - (464 + 395)))) then
				if (((8643 - 5275) == (1618 + 1750)) and v90 and ((v93 and v34) or not v93)) then
					if (((3480 - (467 + 370)) < (7883 - 4068)) and v99.BagofTricks:IsCastable()) then
						if (((1405 + 508) > (1689 - 1196)) and v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((742 + 4013) > (7975 - 4547)) and v99.Frostbolt:IsCastable() and v41) then
					if (((1901 - (150 + 370)) <= (3651 - (74 + 1208))) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((11911 - 7068) == (19368 - 15284))) then
					local v216 = 0 + 0;
					while true do
						if (((5059 - (14 + 376)) > (629 - 266)) and ((0 + 0) == v216)) then
							v31 = v125();
							if (v31 or ((1649 + 228) >= (2993 + 145))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((13894 - 9152) >= (2728 + 898)) and ((78 - (23 + 55)) == v142)) then
				if ((v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(2 - 1, v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold))) or ((4077 + 463) == (1420 - 504))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((364 + 792) > (5246 - (652 + 249)))) then
						return "comet_storm single 2";
					end
				end
				if (((5986 - 3749) < (6117 - (708 + 1160))) and v99.Flurry:IsCastable() and (v107 == (0 - 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1 - 0, v99.Frostbolt) and (v108 >= (30 - (10 + 17)))) or (v14:PrevGCDP(1 + 0, v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1733 - (1400 + 332), v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (7 - 3)) and v14:BuffDown(v99.FingersofFrostBuff)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((4591 - (242 + 1666)) < (10 + 13))) then
						return "flurry single 4";
					end
				end
				if (((256 + 441) <= (704 + 122)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (940 - (850 + 90))) and (v108 == (6 - 2)) and v14:BuffUp(v99.FingersofFrostBuff)) then
					if (((2495 - (360 + 1030)) <= (1041 + 135)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 6";
					end
				end
				if (((9536 - 6157) <= (5244 - 1432)) and v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1662 - (909 + 752)))) then
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((2011 - (109 + 1114)) >= (2958 - 1342))) then
						return "ray_of_frost single 8";
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v129()
		local v143 = 242 - (6 + 236);
		while true do
			if (((1169 + 685) <= (2720 + 659)) and (v143 == (13 - 7))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v72 = EpicSettings.Settings['iceBlockHP'] or (1133 - (1076 + 57));
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (689 - (579 + 110));
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v143 = 1 + 6;
			end
			if (((4022 + 527) == (2415 + 2134)) and (v143 == (414 - (174 + 233)))) then
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v143 == (5 - 3)) or ((5303 - 2281) >= (1345 + 1679))) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v143 = 1177 - (663 + 511);
			end
			if (((4301 + 519) > (478 + 1720)) and (v143 == (2 - 1))) then
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v143 = 2 + 0;
			end
			if ((v143 == (11 - 6)) or ((2568 - 1507) >= (2334 + 2557))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v143 = 728 - (478 + 244);
			end
			if (((1881 - (440 + 77)) <= (2034 + 2439)) and ((0 - 0) == v143)) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v143 = 1557 - (655 + 901);
			end
			if ((v143 == (1 + 3)) or ((2753 + 842) <= (3 + 0))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v143 = 20 - 15;
			end
			if ((v143 == (1448 - (695 + 750))) or ((15953 - 11281) == (5944 - 2092))) then
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v143 = 15 - 11;
			end
		end
	end
	local function v130()
		local v144 = 351 - (285 + 66);
		while true do
			if (((3633 - 2074) == (2869 - (682 + 628))) and (v144 == (1 + 2))) then
				v92 = EpicSettings.Settings['trinketsWithCD'];
				v93 = EpicSettings.Settings['racialsWithCD'];
				v86 = EpicSettings.Settings['useHealthstone'];
				v144 = 303 - (176 + 123);
			end
			if ((v144 == (1 + 1)) or ((1271 + 481) <= (1057 - (239 + 30)))) then
				v76 = EpicSettings.Settings['DispelBuffs'];
				v91 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v144 = 1 + 2;
			end
			if ((v144 == (0 + 0)) or ((6915 - 3008) == (552 - 375))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (315 - (306 + 9));
				v84 = EpicSettings.Settings['useWeapon'];
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v144 = 3 - 2;
			end
			if (((604 + 2866) > (341 + 214)) and (v144 == (2 + 2))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v87 = EpicSettings.Settings['healingPotionHP'] or (1375 - (1140 + 235));
				v144 = 4 + 1;
			end
			if ((v144 == (5 + 0)) or ((250 + 722) == (697 - (33 + 19)))) then
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1149 + 2033) >= (6339 - 4224)) and (v144 == (1 + 0))) then
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v144 = 3 - 1;
			end
		end
	end
	local function v131()
		v129();
		v130();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((3651 + 242) < (5118 - (586 + 103))) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v105 = v15:GetEnemiesInSplashRange(1 + 4);
		v106 = v14:GetEnemiesInRange(123 - 83);
		if (v33 or ((4355 - (1309 + 179)) < (3439 - 1534))) then
			v103 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v106);
			v104 = v30(v15:GetEnemiesInSplashRangeCount(13 - 8), #v106);
		else
			local v156 = 0 + 0;
			while true do
				if ((v156 == (0 - 0)) or ((3578 - 1782) >= (4660 - (295 + 314)))) then
					v103 = 2 - 1;
					v104 = 1963 - (1300 + 662);
					break;
				end
			end
		end
		if (((5083 - 3464) <= (5511 - (1178 + 577))) and not v14:AffectingCombat()) then
			if (((314 + 290) == (1785 - 1181)) and v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) then
				if (v24(v99.ArcaneIntellect) or ((5889 - (851 + 554)) == (796 + 104))) then
					return "arcane_intellect";
				end
			end
		end
		if (v113.TargetIsValid() or v14:AffectingCombat() or ((12366 - 7907) <= (2417 - 1304))) then
			v110 = v10.BossFightRemains(nil, true);
			v111 = v110;
			if (((3934 - (115 + 187)) > (2603 + 795)) and (v111 == (10519 + 592))) then
				v111 = v10.FightRemains(v106, false);
			end
			v107 = v15:DebuffStack(v99.WintersChillDebuff);
			v108 = v14:BuffStackP(v99.IciclesBuff);
			v112 = v14:GCD();
		end
		if (((16085 - 12003) <= (6078 - (160 + 1001))) and v113.TargetIsValid()) then
			if (((4228 + 604) >= (957 + 429)) and v77 and v35 and v99.RemoveCurse:IsAvailable()) then
				local v211 = 0 - 0;
				while true do
					if (((495 - (237 + 121)) == (1034 - (525 + 372))) and (v211 == (0 - 0))) then
						if (v16 or ((5158 - 3588) >= (4474 - (96 + 46)))) then
							local v220 = 777 - (643 + 134);
							while true do
								if ((v220 == (0 + 0)) or ((9744 - 5680) <= (6753 - 4934))) then
									v31 = v121();
									if (v31 or ((4782 + 204) < (3088 - 1514))) then
										return v31;
									end
									break;
								end
							end
						end
						if (((9047 - 4621) > (891 - (316 + 403))) and v17 and v17:Exists() and v17:IsAPlayer() and v113.UnitHasCurseDebuff(v17)) then
							if (((390 + 196) > (1250 - 795)) and v99.RemoveCurse:IsReady()) then
								if (((299 + 527) == (2080 - 1254)) and v24(v101.RemoveCurseMouseover)) then
									return "remove_curse dispel";
								end
							end
						end
						break;
					end
				end
			end
			if ((not v14:AffectingCombat() and v32) or ((2849 + 1170) > (1432 + 3009))) then
				v31 = v123();
				if (((6988 - 4971) < (20349 - 16088)) and v31) then
					return v31;
				end
			end
			v31 = v119();
			if (((9797 - 5081) > (5 + 75)) and v31) then
				return v31;
			end
			if (v14:AffectingCombat() or v77 or ((6903 - 3396) == (160 + 3112))) then
				local v212 = 0 - 0;
				local v213;
				while true do
					if (((17 - (12 + 5)) == v212) or ((3402 - 2526) >= (6560 - 3485))) then
						v213 = v77 and v99.RemoveCurse:IsReady() and v35;
						v31 = v113.FocusUnit(v213, nil, 42 - 22, nil, 49 - 29, v99.ArcaneIntellect);
						v212 = 1 + 0;
					end
					if (((6325 - (1656 + 317)) > (2276 + 278)) and (v212 == (1 + 0))) then
						if (v31 or ((11715 - 7309) < (19897 - 15854))) then
							return v31;
						end
						break;
					end
				end
			end
			if (v78 or ((2243 - (5 + 349)) >= (16068 - 12685))) then
				if (((3163 - (266 + 1005)) <= (1802 + 932)) and v98) then
					local v217 = 0 - 0;
					while true do
						if (((2531 - 608) < (3914 - (561 + 1135))) and (v217 == (0 - 0))) then
							v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 98 - 68);
							if (((3239 - (507 + 559)) > (950 - 571)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if (v79 or ((8013 - 5422) == (3797 - (212 + 176)))) then
				local v214 = 905 - (250 + 655);
				while true do
					if (((12309 - 7795) > (5807 - 2483)) and (v214 == (0 - 0))) then
						v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 1986 - (1869 + 87));
						if (v31 or ((721 - 513) >= (6729 - (484 + 1417)))) then
							return v31;
						end
						break;
					end
				end
			end
			if ((v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) or ((3392 - 1809) > (5977 - 2410))) then
				if (v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal)) or ((2086 - (48 + 725)) == (1296 - 502))) then
					return "spellsteal damage";
				end
			end
			if (((8515 - 5341) > (1687 + 1215)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
				if (((11010 - 6890) <= (1193 + 3067)) and v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) then
					if (v24(v101.UseWeapon, nil) or ((258 + 625) > (5631 - (152 + 701)))) then
						return "Using Weapon Macro";
					end
				end
				if (v34 or ((4931 - (430 + 881)) >= (1874 + 3017))) then
					local v218 = 895 - (557 + 338);
					while true do
						if (((1259 + 2999) > (2640 - 1703)) and (v218 == (0 - 0))) then
							v31 = v124();
							if (v31 or ((12935 - 8066) < (1952 - 1046))) then
								return v31;
							end
							break;
						end
					end
				end
				if ((v33 and (((v104 >= (808 - (499 + 302))) and not v14:HasTier(896 - (39 + 827), 5 - 3)) or ((v104 >= (6 - 3)) and v99.IceCaller:IsAvailable()))) or ((4865 - 3640) > (6490 - 2262))) then
					local v219 = 0 + 0;
					while true do
						if (((9740 - 6412) > (359 + 1879)) and (v219 == (0 - 0))) then
							v31 = v126();
							if (((3943 - (103 + 1)) > (1959 - (475 + 79))) and v31) then
								return v31;
							end
							v219 = 2 - 1;
						end
						if ((v219 == (3 - 2)) or ((168 + 1125) <= (447 + 60))) then
							if (v24(v99.Pool) or ((4399 - (1395 + 108)) < (2342 - 1537))) then
								return "pool for Aoe()";
							end
							break;
						end
					end
				end
				if (((3520 - (7 + 1197)) == (1010 + 1306)) and v33 and (v104 == (1 + 1))) then
					v31 = v127();
					if (v31 or ((2889 - (27 + 292)) == (4491 - 2958))) then
						return v31;
					end
					if (v24(v99.Pool) or ((1125 - 242) == (6122 - 4662))) then
						return "pool for Cleave()";
					end
				end
				v31 = v128();
				if (v31 or ((9108 - 4489) <= (1901 - 902))) then
					return v31;
				end
				if (v24(v99.Pool) or ((3549 - (43 + 96)) > (16789 - 12673))) then
					return "pool for ST()";
				end
				if ((v14:IsMoving() and v95) or ((2041 - 1138) >= (2539 + 520))) then
					v31 = v125();
					if (v31 or ((1123 + 2853) < (5646 - 2789))) then
						return v31;
					end
				end
			end
		end
	end
	local function v132()
		v114();
		v99.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(25 + 39, v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

