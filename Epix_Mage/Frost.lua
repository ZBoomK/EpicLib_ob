local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1948 - (1096 + 852))) or ((1665 + 2046) < (1439 - 431))) then
			v6 = v0[v4];
			if (not v6 or ((1018 + 31) <= (1418 - (409 + 103)))) then
				return v1(v4, ...);
			end
			v5 = 237 - (46 + 190);
		end
		if (((4608 - (51 + 44)) > (769 + 1957)) and (v5 == (1318 - (1114 + 203)))) then
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
	local v107 = 726 - (228 + 498);
	local v108 = 0 + 0;
	local v109 = 9 + 6;
	local v110 = 11774 - (174 + 489);
	local v111 = 28947 - 17836;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((3386 - (830 + 1075)) >= (3182 - (303 + 221)))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(85990 - (231 + 1038));
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(190493 + 38104);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(229516 - (171 + 991));
	v99.Flurry:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(942107 - 713507);
	v99.GlacialSpike:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(613831 - 385233);
	v99.IceLance:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v134 = 0 - 0;
		while true do
			if (((1 + 0) == v134) or ((11287 - 8067) == (3934 - 2570))) then
				v107 = 0 - 0;
				break;
			end
			if ((v134 == (0 - 0)) or ((2302 - (111 + 1137)) > (3550 - (91 + 67)))) then
				v110 = 33069 - 21958;
				v111 = 2773 + 8338;
				v134 = 524 - (423 + 100);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v135)
		if ((v135 == nil) or ((5 + 671) >= (4546 - 2904))) then
			v135 = v15;
		end
		return not v135:IsInBossList() or (v135:Level() < (39 + 34));
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v136)
		if (((4907 - (326 + 445)) > (10460 - 8063)) and (v99.WintersChillDebuff:AuraActiveCount() == (0 - 0))) then
			return 0 - 0;
		end
		local v137 = 711 - (530 + 181);
		for v198, v199 in pairs(v136) do
			v137 = v137 + v199:DebuffStack(v99.WintersChillDebuff);
		end
		return v137;
	end
	local function v118(v138)
		return (v138:DebuffStack(v99.WintersChillDebuff));
	end
	local function v119(v139)
		return (v139:DebuffDown(v99.WintersChillDebuff));
	end
	local function v120()
		local v140 = 881 - (614 + 267);
		while true do
			if ((v140 == (35 - (19 + 13))) or ((7053 - 2719) == (9891 - 5646))) then
				if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((12214 - 7938) <= (788 + 2243))) then
					if (v24(v99.AlterTime) or ((8409 - 3627) <= (2486 - 1287))) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((6676 - (1293 + 519)) < (3880 - 1978))) then
					if (((12633 - 7794) >= (7075 - 3375)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v140 = 17 - 13;
			end
			if ((v140 == (4 - 2)) or ((570 + 505) > (392 + 1526))) then
				if (((919 - 523) <= (880 + 2924)) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (v24(v99.MirrorImage) or ((1385 + 2784) == (1367 + 820))) then
						return "mirror_image defensive 5";
					end
				end
				if (((2502 - (709 + 387)) == (3264 - (673 + 1185))) and v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
					if (((4439 - 2908) < (13714 - 9443)) and v24(v99.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v140 = 4 - 1;
			end
			if (((455 + 180) == (475 + 160)) and (v140 == (0 - 0))) then
				if (((829 + 2544) <= (7090 - 3534)) and v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v99.IceBarrier) or ((6460 - 3169) < (5160 - (446 + 1434)))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((5669 - (1040 + 243)) >= (2605 - 1732)) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 1849 - (559 + 1288), v99.ArcaneIntellect)) then
					if (((2852 - (609 + 1322)) <= (1556 - (13 + 441))) and v24(v99.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v140 = 3 - 2;
			end
			if (((12326 - 7620) >= (4796 - 3833)) and ((1 + 3) == v140)) then
				if ((v85 and (v14:HealthPercentage() <= v87)) or ((3486 - 2526) <= (312 + 564))) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (0 - 0)) or ((1131 + 935) == (1713 - 781))) then
							if (((3190 + 1635) < (2694 + 2149)) and (v89 == "Refreshing Healing Potion")) then
								if (v100.RefreshingHealingPotion:IsReady() or ((2786 + 1091) >= (3810 + 727))) then
									if (v24(v101.RefreshingHealingPotion) or ((4222 + 93) < (2159 - (153 + 280)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or ((10623 - 6944) < (562 + 63))) then
								if (v100.DreamwalkersHealingPotion:IsReady() or ((1827 + 2798) < (331 + 301))) then
									if (v24(v101.RefreshingHealingPotion) or ((76 + 7) > (1290 + 490))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v214 = 1 - 0;
						end
						if (((338 + 208) <= (1744 - (89 + 578))) and (v214 == (1 + 0))) then
							if ((v89 == "Potion of Withering Dreams") or ((2070 - 1074) > (5350 - (572 + 477)))) then
								if (((549 + 3521) > (413 + 274)) and v100.PotionOfWitheringDreams:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((79 + 577) >= (3416 - (84 + 2)))) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v140 == (1 - 0)) or ((1796 + 696) <= (1177 - (497 + 345)))) then
				if (((111 + 4211) >= (434 + 2128)) and v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (v24(v99.IceColdAbility) or ((4970 - (605 + 728)) >= (2690 + 1080))) then
						return "ice_cold defensive 3";
					end
				end
				if ((v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((5288 - 2909) > (210 + 4368))) then
					if (v24(v99.IceBlock) or ((1785 - 1302) > (670 + 73))) then
						return "ice_block defensive 4";
					end
				end
				v140 = 5 - 3;
			end
		end
	end
	local v121 = 0 + 0;
	local function v122()
		if (((2943 - (457 + 32)) > (246 + 332)) and v99.RemoveCurse:IsReady() and (v113.UnitHasDispellableDebuffByPlayer(v16) or v113.DispellableFriendlyUnit(1422 - (832 + 570)) or v113.UnitHasCurseDebuff(v16))) then
			if (((877 + 53) < (1163 + 3295)) and (v121 == (0 - 0))) then
				v121 = GetTime();
			end
			if (((319 + 343) <= (1768 - (588 + 208))) and v113.Wait(1347 - 847, v121)) then
				local v212 = 1800 - (884 + 916);
				while true do
					if (((9148 - 4778) == (2534 + 1836)) and ((653 - (232 + 421)) == v212)) then
						if (v24(v101.RemoveCurseFocus) or ((6651 - (1569 + 320)) <= (212 + 649))) then
							return "remove_curse dispel";
						end
						v121 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v123()
		v31 = v113.HandleTopTrinket(v102, v34, 134 - 94, nil);
		if (v31 or ((2017 - (316 + 289)) == (11161 - 6897))) then
			return v31;
		end
		v31 = v113.HandleBottomTrinket(v102, v34, 2 + 38, nil);
		if (v31 or ((4621 - (666 + 787)) < (2578 - (360 + 65)))) then
			return v31;
		end
	end
	local function v124()
		if (v113.TargetIsValid() or ((4651 + 325) < (1586 - (79 + 175)))) then
			local v203 = 0 - 0;
			while true do
				if (((3612 + 1016) == (14185 - 9557)) and (v203 == (0 - 0))) then
					if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((953 - (503 + 396)) == (576 - (92 + 89)))) then
						if (((158 - 76) == (43 + 39)) and v24(v99.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if ((v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) or ((344 + 237) < (1104 - 822))) then
						if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt)) or ((631 + 3978) < (5688 - 3193))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		if (((1006 + 146) == (551 + 601)) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and (v14:PrevOffGCDP(2 - 1, v99.IcyVeins) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 <= (14 + 96))) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 >= (427 - 147))) or (v111 < (1284 - (485 + 759))))) then
			if (((4387 - 2491) <= (4611 - (442 + 747))) and v24(v99.TimeWarp, not v15:IsInRange(1175 - (832 + 303)))) then
				return "time_warp cd 2";
			end
		end
		local v141 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (v141 or ((1936 - (88 + 858)) > (494 + 1126))) then
			return v141;
		end
		if ((v99.IcyVeins:IsCastable() and ((v34 and v57) or not v57) and v52 and (v83 < v111)) or ((726 + 151) > (194 + 4501))) then
			if (((3480 - (766 + 23)) >= (9137 - 7286)) and v24(v99.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v111) or ((4081 - 1096) >= (12793 - 7937))) then
			if (((14512 - 10236) >= (2268 - (1036 + 37))) and v91 and ((v34 and v92) or not v92)) then
				local v213 = 0 + 0;
				while true do
					if (((6293 - 3061) <= (3690 + 1000)) and ((1480 - (641 + 839)) == v213)) then
						v31 = v123();
						if (v31 or ((1809 - (910 + 3)) >= (8020 - 4874))) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if (((4745 - (1466 + 218)) >= (1360 + 1598)) and v90 and ((v93 and v34) or not v93) and (v83 < v111)) then
			local v204 = 1148 - (556 + 592);
			while true do
				if (((1134 + 2053) >= (1452 - (329 + 479))) and ((854 - (174 + 680)) == v204)) then
					if (((2212 - 1568) <= (1459 - 755)) and v99.BloodFury:IsCastable()) then
						if (((684 + 274) > (1686 - (396 + 343))) and v24(v99.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((398 + 4094) >= (4131 - (29 + 1448))) and v99.Berserking:IsCastable()) then
						if (((4831 - (135 + 1254)) >= (5662 - 4159)) and v24(v99.Berserking)) then
							return "berserking cd 12";
						end
					end
					v204 = 4 - 3;
				end
				if ((v204 == (1 + 0)) or ((4697 - (389 + 1138)) <= (2038 - (102 + 472)))) then
					if (v99.LightsJudgment:IsCastable() or ((4527 + 270) == (2434 + 1954))) then
						if (((514 + 37) <= (2226 - (320 + 1225))) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (((5833 - 2556) > (250 + 157)) and v99.Fireblood:IsCastable()) then
						if (((6159 - (157 + 1307)) >= (3274 - (821 + 1038))) and v24(v99.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v204 = 4 - 2;
				end
				if ((v204 == (1 + 1)) or ((5704 - 2492) <= (352 + 592))) then
					if (v99.AncestralCall:IsCastable() or ((7673 - 4577) <= (2824 - (834 + 192)))) then
						if (((225 + 3312) == (908 + 2629)) and v24(v99.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v142 = 0 + 0;
		while true do
			if (((5943 - 2106) >= (1874 - (300 + 4))) and (v142 == (1 + 0))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (78 - 48)) and (v104 >= (364 - (112 + 250)))) or ((1176 + 1774) == (9549 - 5737))) then
					if (((2706 + 2017) >= (1199 + 1119)) and v24(v99.ArcaneExplosion, not v15:IsInRange(8 + 2))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((1006 + 1021) > (2119 + 733))) then
					if (v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast)) or ((2550 - (1001 + 413)) > (9626 - 5309))) then
						return "fire_blast movement";
					end
				end
				v142 = 884 - (244 + 638);
			end
			if (((5441 - (627 + 66)) == (14147 - 9399)) and (v142 == (602 - (512 + 90)))) then
				if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes) and not v14:PrevOffGCDP(1 + 0, v99.IceFloes)) then
					if (v24(v99.IceFloes) or ((897 + 2493) <= (8071 - 5011))) then
						return "ice_floes movement";
					end
				end
				if ((v99.IceNova:IsCastable() and v48) or ((1690 - 691) > (3792 - (35 + 1064)))) then
					if (((337 + 126) < (1285 - 684)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova movement";
					end
				end
				v142 = 1 + 0;
			end
			if ((v142 == (1238 - (298 + 938))) or ((3442 - (233 + 1026)) < (2353 - (636 + 1030)))) then
				if (((2326 + 2223) == (4444 + 105)) and v99.IceLance:IsCastable() and v47) then
					if (((1388 + 3284) == (316 + 4356)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v127()
		local v143 = 221 - (55 + 166);
		while true do
			if ((v143 == (1 + 4)) or ((369 + 3299) < (1508 - 1113))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (327 - (36 + 261))) and (v104 >= (12 - 5))) or ((5534 - (34 + 1334)) == (175 + 280))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(7 + 1)) or ((5732 - (1035 + 248)) == (2684 - (20 + 1)))) then
						return "arcane_explosion aoe 28";
					end
				end
				if ((v99.Frostbolt:IsCastable() and v41) or ((2229 + 2048) < (3308 - (134 + 185)))) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((2003 - (549 + 584)) >= (4834 - (314 + 371)))) then
						return "frostbolt aoe 32";
					end
				end
				if (((7593 - 5381) < (4151 - (478 + 490))) and v14:IsMoving() and v95) then
					v31 = v126();
					if (((2462 + 2184) > (4164 - (786 + 386))) and v31) then
						return v31;
					end
				end
				break;
			end
			if (((4644 - 3210) < (4485 - (1055 + 324))) and (v143 == (1340 - (1093 + 247)))) then
				if (((699 + 87) < (318 + 2705)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(3 - 2, v99.CometStorm) or (v14:PrevGCDP(3 - 2, v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(33 - 21)) or ((6136 - 3694) < (27 + 47))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((17470 - 12935) == (15631 - 11096)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(102 - 62)) or ((3697 - (364 + 324)) <= (5770 - 3665))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((4391 - 2561) < (1217 + 2452)) and v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(4 - 3, v99.GlacialSpike) or not v115())) then
					if (v24(v101.BlizzardCursor, not v15:IsInRange(64 - 24), v14:BuffDown(v99.IceFloes)) or ((4343 - 2913) >= (4880 - (1249 + 19)))) then
						return "blizzard aoe 6";
					end
				end
				v143 = 1 + 0;
			end
			if (((10443 - 7760) >= (3546 - (686 + 400))) and (v143 == (2 + 0))) then
				if ((v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(230 - (73 + 156), v99.Freeze) and ((v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (v107 == (811 - (721 + 90)))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 + 0))))) or ((5857 - 4053) >= (3745 - (224 + 246)))) then
					if (v24(v99.FrostNova) or ((2295 - 878) > (6681 - 3052))) then
						return "frost_nova aoe 12";
					end
				end
				if (((870 + 3925) > (10 + 392)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
					if (((3536 + 1277) > (7087 - 3522)) and v24(v99.ConeofCold, not v15:IsInRange(26 - 18))) then
						return "cone_of_cold aoe 14";
					end
				end
				if (((4425 - (203 + 310)) == (5905 - (1238 + 755))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
					if (((198 + 2623) <= (6358 - (709 + 825))) and v24(v99.ShiftingPower, not v15:IsInRange(73 - 33), true)) then
						return "shifting_power aoe 16";
					end
				end
				v143 = 3 - 0;
			end
			if (((2602 - (196 + 668)) <= (8666 - 6471)) and (v143 == (5 - 2))) then
				if (((874 - (171 + 662)) <= (3111 - (4 + 89))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (17 - 12)) and (v99.Blizzard:CooldownRemains() > v112)) then
					if (((782 + 1363) <= (18025 - 13921)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((1055 + 1634) < (6331 - (35 + 1451))) and v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (1453 - (28 + 1425))) and (v14:PrevGCDP(1994 - (941 + 1052), v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (1.8 + 0)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((3836 - (822 + 692)) > (3742 - 1120))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 + 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((4831 - (45 + 252)) == (2060 + 22))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((541 + 1030) > (4543 - 2676))) then
						return "flurry aoe 21";
					end
				end
				v143 = 437 - (114 + 319);
			end
			if ((v143 == (1 - 0)) or ((3400 - 746) >= (1910 + 1086))) then
				if (((5926 - 1948) > (4408 - 2304)) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1964 - (556 + 1407), v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (1231 - (741 + 465)))) or (v99.ConeofCold:CooldownRemains() > (485 - (170 + 295))))) then
					if (((1579 + 1416) > (1416 + 125)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				if (((7998 - 4749) > (791 + 162)) and v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 + 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) then
					if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((4503 - (957 + 273)) > (1224 + 3349))) then
						return "freeze aoe 10";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and (v14:PrevGCDP(3 - 2, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (2 - 1))))) or ((9624 - 6473) < (6357 - 5073))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3630 - (389 + 1391)) == (960 + 569))) then
						return "ice_nova aoe 11";
					end
				end
				v143 = 1 + 1;
			end
			if (((1868 - 1047) < (3074 - (783 + 168))) and (v143 == (13 - 9))) then
				if (((888 + 14) < (2636 - (309 + 2))) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
					if (((2634 - 1776) <= (4174 - (1090 + 122))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v103 >= (2 + 2)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) or ((13252 - 9306) < (882 + 406))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((4360 - (628 + 490)) == (102 + 465))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (16 - 9))) or ((3870 - 3023) >= (2037 - (431 + 343)))) then
					if (v24(v99.DragonsBreath, not v15:IsInRange(20 - 10)) or ((6517 - 4264) == (1463 + 388))) then
						return "dragons_breath aoe 26";
					end
				end
				v143 = 1 + 4;
			end
		end
	end
	local function v128()
		if ((v99.CometStorm:IsCastable() and (v14:PrevGCDP(1696 - (556 + 1139), v99.Flurry) or v14:PrevGCDP(16 - (6 + 9), v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) or ((383 + 1704) > (1216 + 1156))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((4614 - (28 + 141)) < (1608 + 2541))) then
				return "comet_storm cleave 2";
			end
		end
		if ((v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 - 0, v99.Frostbolt) and (v108 >= (3 + 0))) or v14:PrevGCDP(1318 - (486 + 831), v99.GlacialSpike) or ((v108 >= (7 - 4)) and (v108 < (17 - 12)) and (v99.Flurry:ChargesFractional() == (1 + 1))))) or ((5748 - 3930) == (1348 - (668 + 595)))) then
			if (((567 + 63) < (429 + 1698)) and v113.CastTargetIf(v99.Flurry, v105, "min", v118, nil, not v15:IsSpellInRange(v99.Flurry))) then
				return "flurry cleave 4";
			end
			if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((5285 - 3347) == (2804 - (23 + 267)))) then
				return "flurry cleave 4";
			end
		end
		if (((6199 - (1129 + 815)) >= (442 - (371 + 16))) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (1750 - (1326 + 424))) and (v108 == (7 - 3)) and v14:BuffUp(v99.FingersofFrostBuff)) then
			local v205 = 0 - 0;
			while true do
				if (((3117 - (88 + 30)) > (1927 - (720 + 51))) and (v205 == (0 - 0))) then
					if (((4126 - (421 + 1355)) > (1905 - 750)) and v113.CastTargetIf(v99.IceLance, v105, "max", v119, nil, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (((1980 + 2049) <= (5936 - (286 + 797))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 6";
					end
					break;
				end
			end
		end
		if ((v99.RayofFrost:IsCastable() and (v107 == (3 - 2)) and v49) or ((853 - 337) > (3873 - (397 + 42)))) then
			if (((1264 + 2782) >= (3833 - (24 + 776))) and v113.CastTargetIf(v99.RayofFrost, v105, "max", v118, nil, not v15:IsSpellInRange(v99.RayofFrost))) then
				return "ray_of_frost cleave 8";
			end
			if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((4188 - 1469) <= (2232 - (222 + 563)))) then
				return "ray_of_frost cleave 8";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (11 - 6)) and (v99.Flurry:CooldownUp() or (v107 > (0 + 0)))) or ((4324 - (23 + 167)) < (5724 - (690 + 1108)))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((60 + 104) >= (2298 + 487))) then
				return "glacial_spike cleave 10";
			end
		end
		if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (850 - (40 + 808))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((87 + 438) == (8064 - 5955))) then
			if (((32 + 1) == (18 + 15)) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if (((1675 + 1379) <= (4586 - (47 + 524))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (7 + 3)) and (v99.FrozenOrb:CooldownRemains() > (27 - 17)) and (v107 == (0 - 0)) and (v104 >= (6 - 3))) then
			if (((3597 - (1165 + 561)) < (101 + 3281)) and v24(v99.ConeofCold, not v15:IsInRange(37 - 25))) then
				return "cone_of_cold cleave 14";
			end
		end
		if (((494 + 799) <= (2645 - (341 + 138))) and v99.Blizzard:IsCastable() and v38 and (v104 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (5 - 2)))) then
			if (v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes)) or ((2905 - (89 + 237)) < (395 - 272))) then
				return "blizzard cleave 16";
			end
		end
		if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (21 - 11)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (891 - (581 + 300)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (1230 - (855 + 365))))) or (v99.IcyVeins:CooldownRemains() < (47 - 27)))) or ((277 + 569) >= (3603 - (1030 + 205)))) then
			if (v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true) or ((3767 + 245) <= (3124 + 234))) then
				return "shifting_power cleave 18";
			end
		end
		if (((1780 - (156 + 130)) <= (6827 - 3822)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (8 - 3))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((6371 - 3260) == (563 + 1571))) then
				return "glacial_spike cleave 20";
			end
		end
		if (((1374 + 981) == (2424 - (10 + 59))) and v99.IceLance:IsReady() and v47 and ((v14:BuffUpP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike)) or (v107 > (0 - 0)))) then
			local v206 = 1163 - (671 + 492);
			while true do
				if ((v206 == (0 + 0)) or ((1803 - (369 + 846)) <= (115 + 317))) then
					if (((4094 + 703) >= (5840 - (1036 + 909))) and v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (((2844 + 733) == (6004 - 2427)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if (((3997 - (11 + 192)) > (1867 + 1826)) and v99.IceNova:IsCastable() and v48 and (v104 >= (179 - (135 + 40)))) then
			if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3089 - 1814) == (2472 + 1628))) then
				return "ice_nova cleave 24";
			end
		end
		if ((v99.Frostbolt:IsCastable() and v41) or ((3504 - 1913) >= (5366 - 1786))) then
			if (((1159 - (50 + 126)) <= (5034 - 3226)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
				return "frostbolt cleave 26";
			end
		end
		if ((v14:IsMoving() and v95) or ((476 + 1674) <= (2610 - (1233 + 180)))) then
			v31 = v126();
			if (((4738 - (522 + 447)) >= (2594 - (107 + 1314))) and v31) then
				return v31;
			end
		end
	end
	local function v129()
		if (((690 + 795) == (4524 - 3039)) and v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1 + 0, v99.Flurry) or v14:PrevGCDP(1 - 0, v99.ConeofCold))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((13116 - 9801) <= (4692 - (716 + 1194)))) then
				return "comet_storm single 2";
			end
		end
		if ((v99.Flurry:IsCastable() and (v107 == (0 + 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1 + 0, v99.Frostbolt) and (v108 >= (506 - (74 + 429)))) or (v14:PrevGCDP(1 - 0, v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (8 - 4)) and v14:BuffDown(v99.FingersofFrostBuff)))) or ((620 + 256) >= (9137 - 6173))) then
			if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((5518 - 3286) > (2930 - (279 + 154)))) then
				return "flurry single 4";
			end
		end
		if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (778 - (454 + 324))) and (v108 == (4 + 0)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((2127 - (12 + 5)) <= (180 + 152))) then
			if (((9391 - 5705) > (1173 + 1999)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance single 6";
			end
		end
		if ((v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1094 - (277 + 816)))) or ((19117 - 14643) < (2003 - (1058 + 125)))) then
			if (((803 + 3476) >= (3857 - (815 + 160))) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
				return "ray_of_frost single 8";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (21 - 16)) and ((v99.Flurry:Charges() >= (2 - 1)) or ((v107 > (0 + 0)) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) or ((5931 - 3902) >= (5419 - (41 + 1857)))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((3930 - (1222 + 671)) >= (11997 - 7355))) then
				return "glacial_spike single 10";
			end
		end
		if (((2472 - 752) < (5640 - (229 + 953))) and v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (1774 - (1111 + 663))) and (v14:BuffStackP(v99.FingersofFrostBuff) < (1581 - (874 + 705))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(6 + 34)) or ((298 + 138) > (6279 - 3258))) then
				return "frozen_orb single 12";
			end
		end
		if (((21 + 692) <= (1526 - (642 + 37))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (3 + 7)) and (v99.FrozenOrb:CooldownRemains() > (2 + 8)) and (v107 == (0 - 0)) and (v103 >= (457 - (233 + 221)))) then
			if (((4980 - 2826) <= (3548 + 483)) and v24(v99.ConeofCold, not v15:IsInRange(1549 - (718 + 823)))) then
				return "cone_of_cold single 14";
			end
		end
		if (((2905 + 1710) == (5420 - (266 + 539))) and v99.Blizzard:IsCastable() and v38 and (v103 >= (5 - 3)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (1228 - (636 + 589))))) then
			if (v24(v101.BlizzardCursor, not v15:IsInRange(94 - 54), v14:BuffDown(v99.IceFloes)) or ((7817 - 4027) == (397 + 103))) then
				return "blizzard single 16";
			end
		end
		if (((33 + 56) < (1236 - (657 + 358))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 - 0)) and (((v99.FrozenOrb:CooldownRemains() > (22 - 12)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (1197 - (1151 + 36)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (10 + 0)))) or (v99.IcyVeins:CooldownRemains() < (6 + 14)))) then
			if (((6134 - 4080) >= (3253 - (1552 + 280))) and v24(v99.ShiftingPower, not v15:IsInRange(874 - (64 + 770)))) then
				return "shifting_power single 18";
			end
		end
		if (((470 + 222) < (6941 - 3883)) and v99.GlacialSpike:IsCastable() and v45 and (v108 == (1 + 4))) then
			if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((4497 - (157 + 1086)) == (3312 - 1657))) then
				return "glacial_spike single 20";
			end
		end
		if ((v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(4 - 3, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) or ((1987 - 691) == (6701 - 1791))) then
			if (((4187 - (599 + 220)) == (6706 - 3338)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance single 22";
			end
		end
		if (((4574 - (1813 + 118)) < (2789 + 1026)) and v33 and v99.IceNova:IsCastable() and v48 and (v104 >= (1221 - (841 + 376)))) then
			if (((2679 - 766) > (115 + 378)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova single 24";
			end
		end
		if (((12978 - 8223) > (4287 - (464 + 395))) and v90 and ((v93 and v34) or not v93)) then
			if (((3544 - 2163) <= (1138 + 1231)) and v99.BagofTricks:IsCastable()) then
				if (v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks)) or ((5680 - (467 + 370)) == (8439 - 4355))) then
					return "bag_of_tricks cd 40";
				end
			end
		end
		if (((3428 + 1241) > (1244 - 881)) and v99.Frostbolt:IsCastable() and v41) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((293 + 1584) >= (7300 - 4162))) then
				return "frostbolt single 26";
			end
		end
		if (((5262 - (150 + 370)) >= (4908 - (74 + 1208))) and v14:IsMoving() and v95) then
			local v207 = 0 - 0;
			while true do
				if ((v207 == (0 - 0)) or ((3231 + 1309) == (1306 - (14 + 376)))) then
					v31 = v126();
					if (v31 or ((2004 - 848) > (2812 + 1533))) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v130()
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
		v69 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
		v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
		v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v72 = EpicSettings.Settings['iceBlockHP'] or (78 - (23 + 55));
		v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v94 = EpicSettings.Settings['useSpellStealTarget'];
		v95 = EpicSettings.Settings['useSpellsWhileMoving'];
		v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v97 = EpicSettings.Settings['mirrorImageBeforePull'];
		v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v131()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
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
		v88 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v87 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v132()
		local v196 = 901 - (652 + 249);
		while true do
			if (((5986 - 3749) < (6117 - (708 + 1160))) and ((2 - 1) == v196)) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((4891 - 2208) < (50 - (10 + 17)))) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(2 + 3);
				v196 = 1734 - (1400 + 332);
			end
			if (((1336 - 639) <= (2734 - (242 + 1666))) and (v196 == (1 + 1))) then
				v106 = v14:GetEnemiesInRange(15 + 25);
				if (((942 + 163) <= (2116 - (850 + 90))) and v33) then
					local v215 = 0 - 0;
					while true do
						if (((4769 - (360 + 1030)) <= (3374 + 438)) and ((0 - 0) == v215)) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(10 - 2), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(1677 - (909 + 752)), #v106);
							break;
						end
					end
				else
					v103 = 1224 - (109 + 1114);
					v104 = 1 - 0;
				end
				if (not v14:AffectingCombat() or ((307 + 481) >= (1858 - (6 + 236)))) then
					if (((1169 + 685) <= (2720 + 659)) and v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) then
						if (((10727 - 6178) == (7945 - 3396)) and v24(v99.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v113.TargetIsValid() or v14:AffectingCombat() or ((4155 - (1076 + 57)) >= (498 + 2526))) then
					local v216 = 689 - (579 + 110);
					while true do
						if (((381 + 4439) > (1944 + 254)) and (v216 == (0 + 0))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v216 = 408 - (174 + 233);
						end
						if ((v216 == (2 - 1)) or ((1862 - 801) >= (2175 + 2716))) then
							if (((2538 - (663 + 511)) <= (3991 + 482)) and (v111 == (2413 + 8698))) then
								v111 = v10.FightRemains(v106, false);
							end
							if ((v33 and (v104 > (2 - 1))) or ((2177 + 1418) <= (6 - 3))) then
								v107 = v117(v105);
							else
								v107 = v15:DebuffStack(v99.WintersChillDebuff);
							end
							v216 = 4 - 2;
						end
						if ((v216 == (1 + 1)) or ((9093 - 4421) == (2746 + 1106))) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
					end
				end
				v196 = 1 + 2;
			end
			if (((2281 - (478 + 244)) == (2076 - (440 + 77))) and (v196 == (2 + 1))) then
				if (v113.TargetIsValid() or ((6412 - 4660) <= (2344 - (655 + 901)))) then
					if ((v77 and v35 and v99.RemoveCurse:IsAvailable()) or ((725 + 3182) == (136 + 41))) then
						if (((2344 + 1126) > (2235 - 1680)) and v16) then
							v31 = v122();
							if (v31 or ((2417 - (695 + 750)) == (2202 - 1557))) then
								return v31;
							end
						end
						if (((4910 - 1728) >= (8506 - 6391)) and v17 and v17:Exists() and not v14:CanAttack(v17) and v113.UnitHasCurseDebuff(v17)) then
							if (((4244 - (285 + 66)) < (10324 - 5895)) and v99.RemoveCurse:IsReady()) then
								if (v24(v101.RemoveCurseMouseover) or ((4177 - (682 + 628)) < (308 + 1597))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if ((not v14:AffectingCombat() and v32) or ((2095 - (176 + 123)) >= (1695 + 2356))) then
						v31 = v124();
						if (((1175 + 444) <= (4025 - (239 + 30))) and v31) then
							return v31;
						end
					end
					v31 = v120();
					if (((165 + 439) == (581 + 23)) and v31) then
						return v31;
					end
					if (v14:AffectingCombat() or v77 or ((7936 - 3452) == (2807 - 1907))) then
						local v217 = 315 - (306 + 9);
						local v218;
						while true do
							if ((v217 == (3 - 2)) or ((776 + 3683) <= (683 + 430))) then
								if (((1749 + 1883) > (9716 - 6318)) and v31) then
									return v31;
								end
								break;
							end
							if (((5457 - (1140 + 235)) <= (3130 + 1787)) and ((0 + 0) == v217)) then
								v218 = v77 and v99.RemoveCurse:IsReady() and v35;
								v31 = v113.FocusUnit(v218, nil, 6 + 14, nil, 72 - (33 + 19), v99.ArcaneIntellect);
								v217 = 1 + 0;
							end
						end
					end
					if (((14482 - 9650) >= (611 + 775)) and v78) then
						if (((268 - 131) == (129 + 8)) and v98) then
							v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 719 - (586 + 103));
							if (v31 or ((143 + 1427) >= (13336 - 9004))) then
								return v31;
							end
						end
					end
					if (v79 or ((5552 - (1309 + 179)) <= (3283 - 1464))) then
						v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 14 + 16);
						if (v31 or ((13390 - 8404) < (1189 + 385))) then
							return v31;
						end
					end
					if (((9403 - 4977) > (342 - 170)) and v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) then
						if (((1195 - (295 + 314)) > (1117 - 662)) and v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((2788 - (1300 + 662)) == (2593 - 1767)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
						if ((v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) or ((5774 - (1178 + 577)) > (2307 + 2134))) then
							if (((5962 - 3945) < (5666 - (851 + 554))) and v24(v101.UseWeapon, nil)) then
								return "Using Weapon Macro";
							end
						end
						if (((4171 + 545) > (221 - 141)) and v34) then
							v31 = v125();
							if (v31 or ((7616 - 4109) == (3574 - (115 + 187)))) then
								return v31;
							end
						end
						if ((v33 and (((v104 >= (6 + 1)) and not v14:HasTier(29 + 1, 7 - 5)) or ((v104 >= (1164 - (160 + 1001))) and v99.IceCaller:IsAvailable()))) or ((767 + 109) >= (2122 + 953))) then
							local v219 = 0 - 0;
							while true do
								if (((4710 - (237 + 121)) > (3451 - (525 + 372))) and ((1 - 0) == v219)) then
									if (v24(v99.Pool) or ((14476 - 10070) < (4185 - (96 + 46)))) then
										return "pool for Aoe()";
									end
									break;
								end
								if ((v219 == (777 - (643 + 134))) or ((682 + 1207) >= (8111 - 4728))) then
									v31 = v127();
									if (((7024 - 5132) <= (2622 + 112)) and v31) then
										return v31;
									end
									v219 = 1 - 0;
								end
							end
						end
						if (((3930 - 2007) < (2937 - (316 + 403))) and v33 and (v104 == (2 + 0))) then
							local v220 = 0 - 0;
							while true do
								if (((786 + 1387) > (954 - 575)) and (v220 == (0 + 0))) then
									v31 = v128();
									if (v31 or ((836 + 1755) == (11811 - 8402))) then
										return v31;
									end
									v220 = 4 - 3;
								end
								if (((9376 - 4862) > (191 + 3133)) and (v220 == (1 - 0))) then
									if (v24(v99.Pool) or ((11 + 197) >= (14204 - 9376))) then
										return "pool for Cleave()";
									end
									break;
								end
							end
						end
						v31 = v129();
						if (v31 or ((1600 - (12 + 5)) > (13854 - 10287))) then
							return v31;
						end
						if (v24(v99.Pool) or ((2800 - 1487) == (1687 - 893))) then
							return "pool for ST()";
						end
						if (((7870 - 4696) > (589 + 2313)) and v14:IsMoving() and v95) then
							v31 = v126();
							if (((6093 - (1656 + 317)) <= (3797 + 463)) and v31) then
								return v31;
							end
						end
					end
				end
				break;
			end
			if (((0 + 0) == v196) or ((2347 - 1464) > (23515 - 18737))) then
				v130();
				v131();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v196 = 355 - (5 + 349);
			end
		end
	end
	local function v133()
		local v197 = 0 - 0;
		while true do
			if ((v197 == (1271 - (266 + 1005))) or ((2386 + 1234) >= (16688 - 11797))) then
				v114();
				v99.WintersChillDebuff:RegisterAuraTracking();
				v197 = 1 - 0;
			end
			if (((5954 - (561 + 1135)) > (1220 - 283)) and (v197 == (3 - 2))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1130 - (507 + 559), v132, v133);
end;
return v0["Epix_Mage_Frost.lua"]();

