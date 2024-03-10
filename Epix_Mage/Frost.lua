local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((1459 - (757 + 15)) == (2317 + 1917))) then
			v6 = v0[v4];
			if (not v6 or ((6124 - 2794) < (945 + 484))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((825 + 322) >= (282 + 53)) and (v5 == (1 + 0))) then
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
	local v107 = 433 - (153 + 280);
	local v108 = 0 - 0;
	local v109 = 14 + 1;
	local v110 = 4388 + 6723;
	local v111 = 5815 + 5296;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (((3118 + 317) > (1520 + 577)) and v99.RemoveCurse:IsAvailable()) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(129005 - 44284);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(141287 + 87310);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(229021 - (89 + 578));
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(163303 + 65295);
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(475254 - 246654);
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v133 = 1049 - (572 + 477);
		while true do
			if ((v133 == (0 + 0)) or ((2263 + 1507) >= (483 + 3558))) then
				v110 = 11197 - (84 + 2);
				v111 = 18311 - 7200;
				v133 = 1 + 0;
			end
			if ((v133 == (843 - (497 + 345))) or ((97 + 3694) <= (273 + 1338))) then
				v107 = 1333 - (605 + 728);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v134)
		local v135 = 0 + 0;
		while true do
			if ((v135 == (0 - 0)) or ((210 + 4368) <= (7424 - 5416))) then
				if (((1015 + 110) <= (5751 - 3675)) and (v134 == nil)) then
					v134 = v15;
				end
				return not v134:IsInBossList() or (v134:Level() < (56 + 17));
			end
		end
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v136)
		return (v136:DebuffStack(v99.WintersChillDebuff));
	end
	local function v118(v137)
		return (v137:DebuffDown(v99.WintersChillDebuff));
	end
	local function v119()
		local v138 = 489 - (457 + 32);
		while true do
			if ((v138 == (0 + 0)) or ((2145 - (832 + 570)) >= (4145 + 254))) then
				if (((302 + 853) < (5920 - 4247)) and v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v99.IceBarrier) or ((1120 + 1204) <= (1374 - (588 + 208)))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((10152 - 6385) == (5567 - (884 + 916))) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 3 - 1, v99.ArcaneIntellect)) then
					if (((2371 + 1718) == (4742 - (232 + 421))) and v24(v99.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v138 = 1890 - (1569 + 320);
			end
			if (((1094 + 3364) >= (319 + 1355)) and (v138 == (9 - 6))) then
				if (((1577 - (316 + 289)) <= (3711 - 2293)) and v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
					if (v24(v99.AlterTime) or ((229 + 4709) < (6215 - (666 + 787)))) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((2929 - (360 + 65)) > (3985 + 279))) then
					if (((2407 - (79 + 175)) == (3394 - 1241)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v138 = 4 + 0;
			end
			if ((v138 == (12 - 8)) or ((975 - 468) >= (3490 - (503 + 396)))) then
				if (((4662 - (92 + 89)) == (8692 - 4211)) and v85 and (v14:HealthPercentage() <= v87)) then
					local v209 = 0 + 0;
					while true do
						if ((v209 == (0 + 0)) or ((9116 - 6788) < (95 + 598))) then
							if (((9868 - 5540) == (3777 + 551)) and (v89 == "Refreshing Healing Potion")) then
								if (((759 + 829) >= (4056 - 2724)) and v100.RefreshingHealingPotion:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((521 + 3653) > (6478 - 2230))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or ((5830 - (485 + 759)) <= (189 - 107))) then
								if (((5052 - (442 + 747)) == (4998 - (832 + 303))) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((1228 - (88 + 858)) <= (13 + 29))) then
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
			if (((3815 + 794) >= (32 + 734)) and (v138 == (790 - (766 + 23)))) then
				if ((v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((5687 - 4535) == (3402 - 914))) then
					if (((9015 - 5593) > (11370 - 8020)) and v24(v99.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if (((1950 - (1036 + 37)) > (267 + 109)) and v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
					if (v24(v99.IceBlock) or ((6071 - 2953) <= (1457 + 394))) then
						return "ice_block defensive 4";
					end
				end
				v138 = 1482 - (641 + 839);
			end
			if ((v138 == (915 - (910 + 3))) or ((420 - 255) >= (5176 - (1466 + 218)))) then
				if (((1815 + 2134) < (6004 - (556 + 592))) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (v24(v99.MirrorImage) or ((1521 + 2755) < (3824 - (329 + 479)))) then
						return "mirror_image defensive 5";
					end
				end
				if (((5544 - (174 + 680)) > (14174 - 10049)) and v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
					if (v24(v99.GreaterInvisibility) or ((103 - 53) >= (640 + 256))) then
						return "greater_invisibility defensive 6";
					end
				end
				v138 = 742 - (396 + 343);
			end
		end
	end
	local v120 = 0 + 0;
	local function v121()
		if ((v99.RemoveCurse:IsReady() and v113.UnitHasDispellableDebuffByPlayer(v16)) or ((3191 - (29 + 1448)) >= (4347 - (135 + 1254)))) then
			local v203 = 0 - 0;
			while true do
				if ((v203 == (0 - 0)) or ((994 + 497) < (2171 - (389 + 1138)))) then
					if (((1278 - (102 + 472)) < (932 + 55)) and (v120 == (0 + 0))) then
						v120 = GetTime();
					end
					if (((3467 + 251) > (3451 - (320 + 1225))) and v113.Wait(890 - 390, v120)) then
						if (v24(v101.RemoveCurseFocus) or ((587 + 371) > (5099 - (157 + 1307)))) then
							return "remove_curse dispel";
						end
						v120 = 1859 - (821 + 1038);
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v139 = 0 - 0;
		while true do
			if (((383 + 3118) <= (7978 - 3486)) and (v139 == (1 + 0))) then
				v31 = v113.HandleBottomTrinket(v102, v34, 99 - 59, nil);
				if (v31 or ((4468 - (834 + 192)) < (162 + 2386))) then
					return v31;
				end
				break;
			end
			if (((738 + 2137) >= (32 + 1432)) and (v139 == (0 - 0))) then
				v31 = v113.HandleTopTrinket(v102, v34, 344 - (300 + 4), nil);
				if (v31 or ((1282 + 3515) >= (12808 - 7915))) then
					return v31;
				end
				v139 = 363 - (112 + 250);
			end
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((220 + 331) > (5180 - 3112))) then
			local v204 = 0 + 0;
			while true do
				if (((1094 + 1020) > (707 + 237)) and ((0 + 0) == v204)) then
					if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((1681 + 581) >= (4510 - (1001 + 413)))) then
						if (v24(v99.MirrorImage) or ((5028 - 2773) >= (4419 - (244 + 638)))) then
							return "mirror_image precombat 2";
						end
					end
					if ((v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) or ((4530 - (627 + 66)) < (3891 - 2585))) then
						if (((3552 - (512 + 90)) == (4856 - (1665 + 241))) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v124()
		local v140 = 717 - (373 + 344);
		local v141;
		while true do
			if ((v140 == (1 + 0)) or ((1250 + 3473) < (8699 - 5401))) then
				if (((1921 - 785) >= (1253 - (35 + 1064))) and v141) then
					return v141;
				end
				if ((v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) or ((198 + 73) > (10158 - 5410))) then
					if (((19 + 4721) >= (4388 - (298 + 938))) and v24(v99.IcyVeins)) then
						return "icy_veins cd 6";
					end
				end
				v140 = 1261 - (233 + 1026);
			end
			if (((1666 - (636 + 1030)) == v140) or ((1319 + 1259) >= (3312 + 78))) then
				if (((13 + 28) <= (113 + 1548)) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(222 - (55 + 166), v99.IcyVeins)) then
					if (((117 + 484) < (358 + 3202)) and v24(v99.TimeWarp, not v15:IsInRange(152 - 112))) then
						return "time_warp cd 2";
					end
				end
				v141 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
				v140 = 298 - (36 + 261);
			end
			if (((410 - 175) < (2055 - (34 + 1334))) and (v140 == (1 + 1))) then
				if (((3535 + 1014) > (2436 - (1035 + 248))) and (v83 < v111)) then
					if ((v91 and ((v34 and v92) or not v92)) or ((4695 - (20 + 1)) < (2435 + 2237))) then
						local v220 = 319 - (134 + 185);
						while true do
							if (((4801 - (549 + 584)) < (5246 - (314 + 371))) and (v220 == (0 - 0))) then
								v31 = v122();
								if (v31 or ((1423 - (478 + 490)) == (1910 + 1695))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((v90 and ((v93 and v34) or not v93) and (v83 < v111)) or ((3835 - (786 + 386)) == (10727 - 7415))) then
					local v210 = 1379 - (1055 + 324);
					while true do
						if (((5617 - (1093 + 247)) <= (3977 + 498)) and (v210 == (1 + 0))) then
							if (v99.LightsJudgment:IsCastable() or ((3454 - 2584) == (4034 - 2845))) then
								if (((4418 - 2865) <= (7872 - 4739)) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
									return "lights_judgment cd 14";
								end
							end
							if (v99.Fireblood:IsCastable() or ((796 + 1441) >= (13525 - 10014))) then
								if (v24(v99.Fireblood) or ((4563 - 3239) > (2278 + 742))) then
									return "fireblood cd 16";
								end
							end
							v210 = 4 - 2;
						end
						if ((v210 == (690 - (364 + 324))) or ((8201 - 5209) == (4513 - 2632))) then
							if (((1030 + 2076) > (6385 - 4859)) and v99.AncestralCall:IsCastable()) then
								if (((4841 - 1818) < (11753 - 7883)) and v24(v99.AncestralCall)) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((1411 - (1249 + 19)) > (67 + 7)) and (v210 == (0 - 0))) then
							if (((1104 - (686 + 400)) < (1658 + 454)) and v99.BloodFury:IsCastable()) then
								if (((1326 - (73 + 156)) <= (8 + 1620)) and v24(v99.BloodFury)) then
									return "blood_fury cd 10";
								end
							end
							if (((5441 - (721 + 90)) == (53 + 4577)) and v99.Berserking:IsCastable()) then
								if (((11493 - 7953) > (3153 - (224 + 246))) and v24(v99.Berserking)) then
									return "berserking cd 12";
								end
							end
							v210 = 1 - 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v142 = 0 - 0;
		while true do
			if (((870 + 3924) >= (78 + 3197)) and (v142 == (0 + 0))) then
				if (((2949 - 1465) == (4938 - 3454)) and v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) then
					if (((1945 - (203 + 310)) < (5548 - (1238 + 755))) and v24(v99.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if ((v99.IceNova:IsCastable() and v48) or ((75 + 990) > (5112 - (709 + 825)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((8835 - 4040) < (2049 - 642))) then
						return "ice_nova movement";
					end
				end
				v142 = 865 - (196 + 668);
			end
			if (((7316 - 5463) < (9969 - 5156)) and (v142 == (834 - (171 + 662)))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (123 - (4 + 89))) and (v104 >= (6 - 4))) or ((1028 + 1793) < (10677 - 8246))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(4 + 4)) or ((4360 - (35 + 1451)) < (3634 - (28 + 1425)))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((4682 - (941 + 1052)) <= (329 + 14))) then
					if (v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast)) or ((3383 - (822 + 692)) == (2867 - 858))) then
						return "fire_blast movement";
					end
				end
				v142 = 1 + 1;
			end
			if ((v142 == (299 - (45 + 252))) or ((3509 + 37) < (800 + 1522))) then
				if ((v99.IceLance:IsCastable() and v47) or ((5066 - 2984) == (5206 - (114 + 319)))) then
					if (((4657 - 1413) > (1351 - 296)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (2 - 0)) or ((6941 - 3628) <= (3741 - (556 + 1407)))) then
				if ((v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1207 - (741 + 465), v99.Freeze) and ((v14:PrevGCDP(466 - (170 + 295), v99.GlacialSpike) and (v107 == (0 + 0))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 + 0))))) or ((3498 - 2077) >= (1745 + 359))) then
					if (((1163 + 649) <= (1840 + 1409)) and v24(v99.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((2853 - (957 + 273)) <= (524 + 1433)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
					if (((1767 + 2645) == (16811 - 12399)) and v24(v99.ConeofCold, not v15:IsInRange(21 - 13))) then
						return "cone_of_cold aoe 14";
					end
				end
				if (((5345 - 3595) >= (4169 - 3327)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
					if (((6152 - (389 + 1391)) > (1161 + 689)) and v24(v99.ShiftingPower, not v15:IsInRange(5 + 35), true)) then
						return "shifting_power aoe 16";
					end
				end
				v143 = 6 - 3;
			end
			if (((1183 - (783 + 168)) < (2755 - 1934)) and (v143 == (0 + 0))) then
				if (((829 - (309 + 2)) < (2769 - 1867)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1213 - (1090 + 122), v99.CometStorm) or (v14:PrevGCDP(1 + 0, v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) then
					if (((10055 - 7061) > (588 + 270)) and v24(v99.ConeofCold, not v15:IsInRange(1126 - (628 + 490)))) then
						return "cone_of_cold aoe 2";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) or ((9297 - 5542) <= (4181 - 3266))) then
					if (((4720 - (431 + 343)) > (7559 - 3816)) and v24(v101.FrozenOrbCast, not v15:IsInRange(115 - 75))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) or ((171 + 1164) >= (5001 - (556 + 1139)))) then
					if (((4859 - (6 + 9)) > (413 + 1840)) and v24(v101.BlizzardCursor, not v15:IsInRange(21 + 19))) then
						return "blizzard aoe 6";
					end
				end
				v143 = 170 - (28 + 141);
			end
			if (((176 + 276) == (557 - 105)) and (v143 == (4 + 1))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1347 - (486 + 831))) and (v104 >= (18 - 11))) or ((16043 - 11486) < (395 + 1692))) then
					if (((12249 - 8375) == (5137 - (668 + 595))) and v24(v99.ArcaneExplosion, not v15:IsInRange(8 + 0))) then
						return "arcane_explosion aoe 28";
					end
				end
				if ((v99.Frostbolt:IsCastable() and v41) or ((391 + 1547) > (13458 - 8523))) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true) or ((4545 - (23 + 267)) < (5367 - (1129 + 815)))) then
						return "frostbolt aoe 32";
					end
				end
				if (((1841 - (371 + 16)) <= (4241 - (1326 + 424))) and v14:IsMoving() and v95) then
					local v211 = 0 - 0;
					while true do
						if ((v211 == (0 - 0)) or ((4275 - (88 + 30)) <= (3574 - (720 + 51)))) then
							v31 = v125();
							if (((10795 - 5942) >= (4758 - (421 + 1355))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((6819 - 2685) > (1650 + 1707)) and (v143 == (1087 - (286 + 797)))) then
				if ((v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) or ((12491 - 9074) < (4197 - 1663))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3161 - (397 + 42)) <= (52 + 112))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v103 >= (804 - (24 + 776))) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) or ((3709 - 1301) < (2894 - (222 + 563)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((72 - 39) == (1048 + 407))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (197 - (23 + 167)))) or ((2241 - (690 + 1108)) >= (1449 + 2566))) then
					if (((2790 + 592) > (1014 - (40 + 808))) and v24(v99.DragonsBreath, not v15:IsInRange(2 + 8))) then
						return "dragons_breath aoe 26";
					end
				end
				v143 = 19 - 14;
			end
			if ((v143 == (3 + 0)) or ((149 + 131) == (1678 + 1381))) then
				if (((2452 - (47 + 524)) > (840 + 453)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (13 - 8)) and (v99.Blizzard:CooldownRemains() > v112)) then
					if (((3523 - 1166) == (5375 - 3018)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((1849 - (1165 + 561)) == (4 + 119)) and v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (0 - 0)) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (480.8 - (341 + 138))))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((286 + 770) >= (6999 - 3607))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (326 - (89 + 237))) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((3477 - 2396) < (2263 - 1188))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((1930 - (581 + 300)) >= (5652 - (855 + 365)))) then
						return "flurry aoe 21";
					end
				end
				v143 = 9 - 5;
			end
			if ((v143 == (1 + 0)) or ((6003 - (1030 + 205)) <= (795 + 51))) then
				if ((v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (311 - (156 + 130)))) or (v99.ConeofCold:CooldownRemains() > (45 - 25)))) or ((5659 - 2301) <= (2908 - 1488))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((986 + 2753) <= (1753 + 1252))) then
						return "comet_storm aoe 8";
					end
				end
				if ((v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (69 - (10 + 59))) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) or ((8170 - 6511) >= (3297 - (671 + 492)))) then
					if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((2596 + 664) < (3570 - (369 + 846)))) then
						return "freeze aoe 10";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1946 - (1036 + 909)))))) or ((532 + 137) == (7089 - 2866))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((1895 - (11 + 192)) < (298 + 290))) then
						return "ice_nova aoe 11";
					end
				end
				v143 = 177 - (135 + 40);
			end
		end
	end
	local function v127()
		local v144 = 0 - 0;
		while true do
			if (((2 + 0) == v144) or ((10567 - 5770) < (5472 - 1821))) then
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (186 - (50 + 126))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (27 - 17))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (3 + 7)))) or (v99.IcyVeins:CooldownRemains() < (1433 - (1233 + 180))))) or ((5146 - (522 + 447)) > (6271 - (107 + 1314)))) then
					if (v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true) or ((186 + 214) > (3385 - 2274))) then
						return "shifting_power cleave 18";
					end
				end
				if (((1296 + 1755) > (1995 - 990)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (19 - 14))) then
					if (((5603 - (716 + 1194)) <= (75 + 4307)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike)) or (v107 > (503 - (74 + 429))))) or ((6330 - 3048) > (2033 + 2067))) then
					local v212 = 0 - 0;
					while true do
						if ((v212 == (0 + 0)) or ((11036 - 7456) < (7031 - 4187))) then
							if (((522 - (279 + 154)) < (5268 - (454 + 324))) and v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 22";
							end
							if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3921 + 1062) < (1825 - (12 + 5)))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if (((2065 + 1764) > (9603 - 5834)) and v99.IceNova:IsCastable() and v48 and (v104 >= (2 + 2))) then
					if (((2578 - (277 + 816)) <= (12409 - 9505)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v144 = 1186 - (1058 + 125);
			end
			if (((801 + 3468) == (5244 - (815 + 160))) and (v144 == (0 - 0))) then
				if (((918 - 531) <= (664 + 2118)) and v99.CometStorm:IsCastable() and (v14:PrevGCDP(2 - 1, v99.Flurry) or v14:PrevGCDP(1899 - (41 + 1857), v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((3792 - (1222 + 671)) <= (2370 - 1453))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 - 0, v99.Frostbolt) and (v108 >= (1185 - (229 + 953)))) or v14:PrevGCDP(1775 - (1111 + 663), v99.GlacialSpike) or ((v108 >= (1582 - (874 + 705))) and (v108 < (1 + 4)) and (v99.Flurry:ChargesFractional() == (2 + 0))))) or ((8962 - 4650) <= (25 + 851))) then
					if (((2911 - (642 + 37)) <= (592 + 2004)) and v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry))) then
						return "flurry cleave 4";
					end
					if (((336 + 1759) < (9254 - 5568)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry))) then
						return "flurry cleave 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (454 - (233 + 221))) and (v108 == (8 - 4)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((1404 + 191) >= (6015 - (718 + 823)))) then
					local v213 = 0 + 0;
					while true do
						if ((v213 == (805 - (266 + 539))) or ((13077 - 8458) < (4107 - (636 + 589)))) then
							if (v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance)) or ((697 - 403) >= (9963 - 5132))) then
								return "ice_lance cleave 6";
							end
							if (((1608 + 421) <= (1121 + 1963)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				if ((v99.RayofFrost:IsCastable() and (v107 == (1016 - (657 + 358))) and v49) or ((5393 - 3356) == (5513 - 3093))) then
					if (((5645 - (1151 + 36)) > (3771 + 133)) and v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (((115 + 321) >= (367 - 244)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
				end
				v144 = 1833 - (1552 + 280);
			end
			if (((1334 - (64 + 770)) < (1233 + 583)) and (v144 == (2 - 1))) then
				if (((635 + 2939) == (4817 - (157 + 1086))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (10 - 5)) and (v99.Flurry:CooldownUp() or (v107 > (0 - 0)))) then
					if (((338 - 117) < (532 - 142)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (821 - (599 + 220))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((4406 - 2193) <= (3352 - (1813 + 118)))) then
					if (((2236 + 822) < (6077 - (841 + 376))) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (14 - 4)) and (v99.FrozenOrb:CooldownRemains() > (3 + 7)) and (v107 == (0 - 0)) and (v104 >= (862 - (464 + 395)))) or ((3326 - 2030) >= (2136 + 2310))) then
					if (v24(v99.ConeofCold) or ((2230 - (467 + 370)) > (9276 - 4787))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (2 + 0)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (10 - 7)))) or ((691 + 3733) < (62 - 35))) then
					if (v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard)) or ((2517 - (150 + 370)) > (5097 - (74 + 1208)))) then
						return "blizzard cleave 16";
					end
				end
				v144 = 4 - 2;
			end
			if (((16433 - 12968) > (1362 + 551)) and (v144 == (393 - (14 + 376)))) then
				if (((1270 - 537) < (1178 + 641)) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true) or ((3861 + 534) == (4535 + 220))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((11113 - 7320) < (1783 + 586))) then
					local v214 = 78 - (23 + 55);
					while true do
						if ((v214 == (0 - 0)) or ((2726 + 1358) == (238 + 27))) then
							v31 = v125();
							if (((6756 - 2398) == (1371 + 2987)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v145 = 901 - (652 + 249);
		while true do
			if ((v145 == (10 - 6)) or ((5006 - (708 + 1160)) < (2695 - 1702))) then
				if (((6071 - 2741) > (2350 - (10 + 17))) and v90 and ((v93 and v34) or not v93)) then
					if (v99.BagofTricks:IsCastable() or ((815 + 2811) == (5721 - (1400 + 332)))) then
						if (v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks)) or ((1756 - 840) == (4579 - (242 + 1666)))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((117 + 155) == (100 + 172)) and v99.Frostbolt:IsCastable() and v41) then
					if (((3622 + 627) <= (5779 - (850 + 90))) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if (((4863 - 2086) < (4590 - (360 + 1030))) and v14:IsMoving() and v95) then
					local v215 = 0 + 0;
					while true do
						if (((267 - 172) < (2692 - 735)) and (v215 == (1661 - (909 + 752)))) then
							v31 = v125();
							if (((2049 - (109 + 1114)) < (3142 - 1425)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((556 + 870) >= (1347 - (6 + 236))) and (v145 == (2 + 0))) then
				if (((2217 + 537) <= (7968 - 4589)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (17 - 7)) and (v99.FrozenOrb:CooldownRemains() > (1143 - (1076 + 57))) and (v107 == (0 + 0)) and (v103 >= (692 - (579 + 110)))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(1 + 7)) or ((3472 + 455) == (750 + 663))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v103 >= (409 - (174 + 233))) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (8 - 5)))) or ((2024 - 870) <= (351 + 437))) then
					if (v24(v101.BlizzardCursor, not v15:IsInRange(1214 - (663 + 511))) or ((1466 + 177) > (734 + 2645))) then
						return "blizzard single 16";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 - 0)) and (((v99.FrozenOrb:CooldownRemains() > (7 + 3)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (23 - 13))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (24 - 14)))) or (v99.IcyVeins:CooldownRemains() < (10 + 10)))) or ((5455 - 2652) > (3242 + 1307))) then
					if (v24(v99.ShiftingPower, not v15:IsInRange(4 + 36)) or ((942 - (478 + 244)) >= (3539 - (440 + 77)))) then
						return "shifting_power single 18";
					end
				end
				v145 = 2 + 1;
			end
			if (((10328 - 7506) == (4378 - (655 + 901))) and ((0 + 0) == v145)) then
				if ((v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1 + 0, v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold))) or ((4274 - 3213) == (3302 - (695 + 750)))) then
					if (((9424 - 6664) > (2104 - 740)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if ((v99.Flurry:IsCastable() and (v107 == (0 - 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(352 - (285 + 66), v99.Frostbolt) and (v108 >= (6 - 3))) or (v14:PrevGCDP(1311 - (682 + 628), v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (303 - (176 + 123))) and v14:BuffDown(v99.FingersofFrostBuff)))) or ((2051 + 2851) <= (2608 + 987))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((4121 - (239 + 30)) == (80 + 213))) then
						return "flurry single 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 + 0)) and (v108 == (6 - 2)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((4863 - 3304) == (4903 - (306 + 9)))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((15647 - 11163) == (138 + 650))) then
						return "ice_lance single 6";
					end
				end
				v145 = 1 + 0;
			end
			if (((2199 + 2369) >= (11172 - 7265)) and (v145 == (1376 - (1140 + 235)))) then
				if (((793 + 453) < (3183 + 287)) and v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1 + 0))) then
					if (((4120 - (33 + 19)) >= (351 + 621)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				if (((1477 - 984) < (1715 + 2178)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (9 - 4)) and ((v99.Flurry:Charges() >= (1 + 0)) or ((v107 > (689 - (586 + 103))) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((135 + 1338) >= (10257 - 6925))) then
						return "glacial_spike single 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (1488 - (1309 + 179))) and (v14:BuffStackP(v99.FingersofFrostBuff) < (2 - 0)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((1764 + 2287) <= (3107 - 1950))) then
					if (((457 + 147) < (6121 - 3240)) and v24(v101.FrozenOrbCast, not v15:IsInRange(79 - 39))) then
						return "frozen_orb single 12";
					end
				end
				v145 = 611 - (295 + 314);
			end
			if ((v145 == (6 - 3)) or ((2862 - (1300 + 662)) == (10604 - 7227))) then
				if (((6214 - (1178 + 577)) > (307 + 284)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (14 - 9))) then
					if (((4803 - (851 + 554)) >= (2118 + 277)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(2 - 1, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) or ((4741 - 2558) >= (3126 - (115 + 187)))) then
					if (((1483 + 453) == (1833 + 103)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (15 - 11))) or ((5993 - (160 + 1001)) < (3774 + 539))) then
					if (((2821 + 1267) > (7930 - 4056)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v145 = 362 - (237 + 121);
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
		v69 = EpicSettings.Settings['alterTimeHP'] or (897 - (525 + 372));
		v70 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
		v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (142 - (96 + 46));
		v72 = EpicSettings.Settings['iceBlockHP'] or (777 - (643 + 134));
		v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v94 = EpicSettings.Settings['useSpellStealTarget'];
		v95 = EpicSettings.Settings['useSpellsWhileMoving'];
		v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v97 = EpicSettings.Settings['mirrorImageBeforePull'];
		v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
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
		v88 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v87 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v131()
		local v198 = 0 - 0;
		while true do
			if (((5051 - (316 + 403)) == (2880 + 1452)) and (v198 == (8 - 5))) then
				if (((1446 + 2553) >= (7303 - 4403)) and v113.TargetIsValid()) then
					local v216 = 0 + 0;
					while true do
						if ((v216 == (0 + 0)) or ((8749 - 6224) > (19409 - 15345))) then
							if (((9080 - 4709) == (251 + 4120)) and v77 and v35 and v99.RemoveCurse:IsAvailable()) then
								local v221 = 0 - 0;
								while true do
									if ((v221 == (0 + 0)) or ((782 - 516) > (5003 - (12 + 5)))) then
										if (((7733 - 5742) >= (1973 - 1048)) and v16) then
											local v228 = 0 - 0;
											while true do
												if (((1128 - 673) < (417 + 1636)) and (v228 == (1973 - (1656 + 317)))) then
													v31 = v121();
													if (v31 or ((737 + 89) == (3888 + 963))) then
														return v31;
													end
													break;
												end
											end
										end
										if (((486 - 303) == (900 - 717)) and v17 and v17:Exists() and v17:IsAPlayer() and v113.UnitHasCurseDebuff(v17)) then
											if (((1513 - (5 + 349)) <= (8492 - 6704)) and v99.RemoveCurse:IsReady()) then
												if (v24(v101.RemoveCurseMouseover) or ((4778 - (266 + 1005)) > (2846 + 1472))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((10492 - 7417) <= (3903 - 938))) then
								local v222 = 1696 - (561 + 1135);
								while true do
									if (((1778 - 413) <= (6610 - 4599)) and (v222 == (1066 - (507 + 559)))) then
										v31 = v123();
										if (v31 or ((6965 - 4189) > (11056 - 7481))) then
											return v31;
										end
										break;
									end
								end
							end
							v216 = 389 - (212 + 176);
						end
						if ((v216 == (906 - (250 + 655))) or ((6964 - 4410) == (8393 - 3589))) then
							v31 = v119();
							if (((4031 - 1454) == (4533 - (1869 + 87))) and v31) then
								return v31;
							end
							v216 = 6 - 4;
						end
						if (((1905 - (484 + 1417)) == v216) or ((12 - 6) >= (3165 - 1276))) then
							if (((1279 - (48 + 725)) <= (3090 - 1198)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
								local v223 = 0 - 0;
								while true do
									if ((v223 == (1 + 0)) or ((5366 - 3358) > (621 + 1597))) then
										if (((111 + 268) <= (5000 - (152 + 701))) and v33 and (((v104 >= (1318 - (430 + 881))) and not v14:HasTier(12 + 18, 897 - (557 + 338))) or ((v104 >= (1 + 2)) and v99.IceCaller:IsAvailable()))) then
											local v229 = 0 - 0;
											while true do
												if ((v229 == (3 - 2)) or ((11992 - 7478) <= (2174 - 1165))) then
													if (v24(v99.Pool) or ((4297 - (499 + 302)) == (2058 - (39 + 827)))) then
														return "pool for Aoe()";
													end
													break;
												end
												if ((v229 == (0 - 0)) or ((464 - 256) == (11752 - 8793))) then
													v31 = v126();
													if (((6566 - 2289) >= (113 + 1200)) and v31) then
														return v31;
													end
													v229 = 2 - 1;
												end
											end
										end
										if (((414 + 2173) < (5022 - 1848)) and v33 and (v104 == (106 - (103 + 1)))) then
											local v230 = 554 - (475 + 79);
											while true do
												if ((v230 == (0 - 0)) or ((13184 - 9064) <= (285 + 1913))) then
													v31 = v127();
													if (v31 or ((1405 + 191) == (2361 - (1395 + 108)))) then
														return v31;
													end
													v230 = 2 - 1;
												end
												if (((4424 - (7 + 1197)) == (1404 + 1816)) and (v230 == (1 + 0))) then
													if (v24(v99.Pool) or ((1721 - (27 + 292)) > (10607 - 6987))) then
														return "pool for Cleave()";
													end
													break;
												end
											end
										end
										v223 = 2 - 0;
									end
									if (((10794 - 8220) == (5075 - 2501)) and (v223 == (0 - 0))) then
										if (((1937 - (43 + 96)) < (11246 - 8489)) and v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) then
											if (v24(v101.UseWeapon, nil) or ((851 - 474) > (2161 + 443))) then
												return "Using Weapon Macro";
											end
										end
										if (((161 + 407) < (1800 - 889)) and v34) then
											v31 = v124();
											if (((1259 + 2026) < (7923 - 3695)) and v31) then
												return v31;
											end
										end
										v223 = 1 + 0;
									end
									if (((288 + 3628) > (5079 - (1414 + 337))) and (v223 == (1943 - (1642 + 298)))) then
										if (((6517 - 4017) < (11043 - 7204)) and v24(v99.Pool)) then
											return "pool for ST()";
										end
										if (((1504 - 997) == (167 + 340)) and v14:IsMoving() and v95) then
											local v231 = 0 + 0;
											while true do
												if (((1212 - (357 + 615)) <= (2222 + 943)) and (v231 == (0 - 0))) then
													v31 = v125();
													if (((715 + 119) >= (1725 - 920)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v223 == (2 + 0)) or ((260 + 3552) < (1456 + 860))) then
										v31 = v128();
										if (v31 or ((3953 - (384 + 917)) <= (2230 - (128 + 569)))) then
											return v31;
										end
										v223 = 1546 - (1407 + 136);
									end
								end
							end
							break;
						end
						if (((1890 - (687 + 1200)) == v216) or ((5308 - (556 + 1154)) < (5136 - 3676))) then
							if (v79 or ((4211 - (9 + 86)) < (1613 - (275 + 146)))) then
								local v224 = 0 + 0;
								while true do
									if ((v224 == (64 - (29 + 35))) or ((14966 - 11589) <= (2696 - 1793))) then
										v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 132 - 102);
										if (((2590 + 1386) >= (1451 - (53 + 959))) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((4160 - (312 + 96)) == (6511 - 2759)) and v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) then
								if (((4331 - (147 + 138)) > (3594 - (813 + 86))) and v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v216 = 4 + 0;
						end
						if ((v216 == (3 - 1)) or ((4037 - (18 + 474)) == (1079 + 2118))) then
							if (((7813 - 5419) > (1459 - (860 + 226))) and (v14:AffectingCombat() or v77)) then
								local v225 = 303 - (121 + 182);
								local v226;
								while true do
									if (((512 + 3643) <= (5472 - (988 + 252))) and ((1 + 0) == v225)) then
										if (v31 or ((1122 + 2459) == (5443 - (49 + 1921)))) then
											return v31;
										end
										break;
									end
									if (((5885 - (223 + 667)) > (3400 - (51 + 1))) and (v225 == (0 - 0))) then
										v226 = v77 and v99.RemoveCurse:IsReady() and v35;
										v31 = v113.FocusUnit(v226, nil, 42 - 22, nil, 1145 - (146 + 979), v99.ArcaneIntellect);
										v225 = 1 + 0;
									end
								end
							end
							if (v78 or ((1359 - (311 + 294)) > (10385 - 6661))) then
								if (((92 + 125) >= (1500 - (496 + 947))) and v98) then
									local v227 = 1358 - (1233 + 125);
									while true do
										if (((0 + 0) == v227) or ((1858 + 212) >= (768 + 3269))) then
											v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 1675 - (963 + 682));
											if (((2258 + 447) == (4209 - (504 + 1000))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v216 = 3 + 0;
						end
					end
				end
				break;
			end
			if (((56 + 5) == (6 + 55)) and ((2 - 0) == v198)) then
				v106 = v14:GetEnemiesInRange(35 + 5);
				if (v33 or ((407 + 292) >= (1478 - (156 + 26)))) then
					local v217 = 0 + 0;
					while true do
						if (((0 - 0) == v217) or ((1947 - (149 + 15)) >= (4576 - (890 + 70)))) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(122 - (39 + 78)), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(487 - (14 + 468)), #v106);
							break;
						end
					end
				else
					local v218 = 0 - 0;
					while true do
						if ((v218 == (0 - 0)) or ((2019 + 1894) > (2719 + 1808))) then
							v103 = 1 + 0;
							v104 = 1 + 0;
							break;
						end
					end
				end
				if (((1147 + 3229) > (1563 - 746)) and not v14:AffectingCombat()) then
					if (((4805 + 56) > (2895 - 2071)) and v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) then
						if (v24(v99.ArcaneIntellect) or ((35 + 1348) >= (2182 - (12 + 39)))) then
							return "arcane_intellect";
						end
					end
				end
				if (v113.TargetIsValid() or v14:AffectingCombat() or ((1746 + 130) >= (7865 - 5324))) then
					local v219 = 0 - 0;
					while true do
						if (((529 + 1253) <= (1986 + 1786)) and ((4 - 2) == v219)) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
						if ((v219 == (0 + 0)) or ((22714 - 18014) < (2523 - (1596 + 114)))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v219 = 2 - 1;
						end
						if (((3912 - (164 + 549)) < (5488 - (1059 + 379))) and (v219 == (1 - 0))) then
							if ((v111 == (5759 + 5352)) or ((835 + 4116) < (4822 - (145 + 247)))) then
								v111 = v10.FightRemains(v106, false);
							end
							v107 = v15:DebuffStack(v99.WintersChillDebuff);
							v219 = 2 + 0;
						end
					end
				end
				v198 = 2 + 1;
			end
			if (((284 - 188) == (19 + 77)) and (v198 == (1 + 0))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((4446 - 1707) > (4728 - (254 + 466)))) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(565 - (544 + 16));
				v198 = 5 - 3;
			end
			if ((v198 == (628 - (294 + 334))) or ((276 - (236 + 17)) == (489 + 645))) then
				v129();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v198 = 1 + 0;
			end
		end
	end
	local function v132()
		local v199 = 0 - 0;
		while true do
			if ((v199 == (4 - 3)) or ((1387 + 1306) >= (3386 + 725))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
			if ((v199 == (794 - (413 + 381))) or ((182 + 4134) <= (4563 - 2417))) then
				v114();
				v99.WintersChillDebuff:RegisterAuraTracking();
				v199 = 2 - 1;
			end
		end
	end
	v22.SetAPL(2034 - (582 + 1388), v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

