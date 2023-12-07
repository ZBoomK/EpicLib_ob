local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1982 - (1501 + 481);
	local v6;
	while true do
		if (((251 + 803) == (2829 - 1775)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2369 - 1693) >= (4736 - 3094))) then
			v6 = v0[v4];
			if (((6666 - 2530) > (7409 - 5012)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1249 - (111 + 1137);
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
	local v106 = 158 - (91 + 67);
	local v107 = 0 - 0;
	local v108 = 4 + 11;
	local v109 = 11634 - (423 + 100);
	local v110 = 78 + 11033;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((12000 - 7666) == (2213 + 2032))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(85492 - (326 + 445));
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(997591 - 768994);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(508731 - 280377);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(533599 - 305001);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(229311 - (530 + 181));
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v109 = 11992 - (614 + 267);
		v110 = 11143 - (19 + 13);
		v106 = 0 - 0;
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 - 0)) or ((1111 + 3165) <= (5330 - 2299))) then
				if ((v132 == nil) or ((9916 - 5134) <= (3011 - (1293 + 519)))) then
					v132 = v15;
				end
				return not v132:IsInBossList() or (v132:Level() < (148 - 75));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v134)
		local v135 = 0 - 0;
		local v136;
		while true do
			if ((v135 == (1 - 0)) or ((20973 - 16109) < (4480 - 2578))) then
				for v210, v211 in pairs(v134) do
					v136 = v136 + v211:DebuffStack(v98.WintersChillDebuff);
				end
				return v136;
			end
			if (((2563 + 2276) >= (755 + 2945)) and (v135 == (0 - 0))) then
				if ((v98.WintersChillDebuff:AuraActiveCount() == (0 + 0)) or ((358 + 717) > (1199 + 719))) then
					return 1096 - (709 + 387);
				end
				v136 = 1858 - (673 + 1185);
				v135 = 2 - 1;
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
		local v139 = 0 - 0;
		while true do
			if (((651 - 255) <= (2721 + 1083)) and (v139 == (3 + 1))) then
				if ((v84 and (v14:HealthPercentage() <= v86)) or ((5628 - 1459) == (538 + 1649))) then
					local v214 = 0 - 0;
					while true do
						if (((2759 - 1353) == (3286 - (446 + 1434))) and (v214 == (1283 - (1040 + 243)))) then
							if (((4569 - 3038) < (6118 - (559 + 1288))) and (v88 == "Refreshing Healing Potion")) then
								if (((2566 - (609 + 1322)) == (1089 - (13 + 441))) and v99.RefreshingHealingPotion:IsReady()) then
									if (((12604 - 9231) <= (9314 - 5758)) and v24(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((16390 - 13099) < (123 + 3157))) then
								if (((15929 - 11543) >= (311 + 562)) and v99.DreamwalkersHealingPotion:IsReady()) then
									if (((404 + 517) <= (3270 - 2168)) and v24(v100.RefreshingHealingPotion)) then
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
			if (((2576 + 2130) >= (1770 - 807)) and (v139 == (2 + 1))) then
				if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((534 + 426) <= (630 + 246))) then
					if (v24(v98.AlterTime) or ((1735 + 331) == (912 + 20))) then
						return "alter_time defensive 7";
					end
				end
				if (((5258 - (153 + 280)) < (13984 - 9141)) and v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
					if (v24(v100.Healthstone) or ((3481 + 396) >= (1792 + 2745))) then
						return "healthstone defensive";
					end
				end
				v139 = 3 + 1;
			end
			if ((v139 == (0 + 0)) or ((3127 + 1188) < (2627 - 901))) then
				if ((v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((2274 + 1405) < (1292 - (89 + 578)))) then
					if (v24(v98.IceBarrier) or ((3304 + 1321) < (1313 - 681))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 1051 - (572 + 477))) or ((12 + 71) > (1069 + 711))) then
					if (((66 + 480) <= (1163 - (84 + 2))) and v24(v98.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v139 = 1 - 0;
			end
			if ((v139 == (1 + 0)) or ((1838 - (497 + 345)) > (111 + 4190))) then
				if (((689 + 3381) > (2020 - (605 + 728))) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (v24(v98.IceColdAbility) or ((469 + 187) >= (7403 - 4073))) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((115 + 2377) <= (1238 - 903))) then
					if (((3897 + 425) >= (7098 - 4536)) and v24(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v139 = 2 + 0;
			end
			if ((v139 == (491 - (457 + 32))) or ((1544 + 2093) >= (5172 - (832 + 570)))) then
				if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((2242 + 137) > (1194 + 3384))) then
					if (v24(v98.MirrorImage) or ((1709 - 1226) > (358 + 385))) then
						return "mirror_image defensive 5";
					end
				end
				if (((3250 - (588 + 208)) > (1557 - 979)) and v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
					if (((2730 - (884 + 916)) < (9333 - 4875)) and v24(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v139 = 2 + 1;
			end
		end
	end
	local function v120()
		if (((1315 - (232 + 421)) <= (2861 - (1569 + 320))) and v98.RemoveCurse:IsReady() and v35 and v112.DispellableFriendlyUnit(5 + 15)) then
			if (((831 + 3539) == (14726 - 10356)) and v24(v100.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v121()
		local v140 = 605 - (316 + 289);
		while true do
			if (((2 - 1) == v140) or ((220 + 4542) <= (2314 - (666 + 787)))) then
				v31 = v112.HandleBottomTrinket(v101, v34, 465 - (360 + 65), nil);
				if (v31 or ((1320 + 92) == (4518 - (79 + 175)))) then
					return v31;
				end
				break;
			end
			if (((0 - 0) == v140) or ((2473 + 695) < (6599 - 4446))) then
				v31 = v112.HandleTopTrinket(v101, v34, 77 - 37, nil);
				if (v31 or ((5875 - (503 + 396)) < (1513 - (92 + 89)))) then
					return v31;
				end
				v140 = 1 - 0;
			end
		end
	end
	local function v122()
		if (((2374 + 2254) == (2740 + 1888)) and v112.TargetIsValid()) then
			local v167 = 0 - 0;
			while true do
				if ((v167 == (0 + 0)) or ((122 - 68) == (345 + 50))) then
					if (((40 + 42) == (249 - 167)) and v98.MirrorImage:IsCastable() and v68 and v96) then
						if (v24(v98.MirrorImage) or ((73 + 508) < (429 - 147))) then
							return "mirror_image precombat 2";
						end
					end
					if ((v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) or ((5853 - (485 + 759)) < (5773 - 3278))) then
						if (((2341 - (442 + 747)) == (2287 - (832 + 303))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v141 = 946 - (88 + 858);
		local v142;
		while true do
			if (((578 + 1318) <= (2833 + 589)) and (v141 == (1 + 0))) then
				if (v142 or ((1779 - (766 + 23)) > (7997 - 6377))) then
					return v142;
				end
				if ((v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) or ((1199 - 322) > (12369 - 7674))) then
					if (((9133 - 6442) >= (2924 - (1036 + 37))) and v24(v98.IcyVeins)) then
						return "icy_veins cd 6";
					end
				end
				v141 = 2 + 0;
			end
			if (((0 - 0) == v141) or ((2349 + 636) >= (6336 - (641 + 839)))) then
				if (((5189 - (910 + 3)) >= (3046 - 1851)) and v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1685 - (1466 + 218), v98.IcyVeins)) then
					if (((1486 + 1746) <= (5838 - (556 + 592))) and v24(v98.TimeWarp, not v15:IsInRange(15 + 25))) then
						return "time_warp cd 2";
					end
				end
				v142 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v141 = 809 - (329 + 479);
			end
			if ((v141 == (856 - (174 + 680))) or ((3078 - 2182) >= (6520 - 3374))) then
				if (((2186 + 875) >= (3697 - (396 + 343))) and (v83 < v110)) then
					if (((282 + 2905) >= (2121 - (29 + 1448))) and v90 and ((v34 and v91) or not v91)) then
						local v222 = 1389 - (135 + 1254);
						while true do
							if (((2425 - 1781) <= (3287 - 2583)) and (v222 == (0 + 0))) then
								v31 = v121();
								if (((2485 - (389 + 1138)) > (1521 - (102 + 472))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((4240 + 252) >= (1472 + 1182)) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
					local v215 = 0 + 0;
					while true do
						if (((4987 - (320 + 1225)) >= (2675 - 1172)) and (v215 == (2 + 0))) then
							if (v98.AncestralCall:IsCastable() or ((4634 - (157 + 1307)) <= (3323 - (821 + 1038)))) then
								if (v24(v98.AncestralCall) or ((11968 - 7171) == (480 + 3908))) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((978 - 427) <= (254 + 427)) and (v215 == (0 - 0))) then
							if (((4303 - (834 + 192)) > (26 + 381)) and v98.BloodFury:IsCastable()) then
								if (((1206 + 3489) >= (31 + 1384)) and v24(v98.BloodFury)) then
									return "blood_fury cd 10";
								end
							end
							if (v98.Berserking:IsCastable() or ((4975 - 1763) <= (1248 - (300 + 4)))) then
								if (v24(v98.Berserking) or ((827 + 2269) <= (4706 - 2908))) then
									return "berserking cd 12";
								end
							end
							v215 = 363 - (112 + 250);
						end
						if (((1411 + 2126) == (8860 - 5323)) and (v215 == (1 + 0))) then
							if (((1985 + 1852) >= (1175 + 395)) and v98.LightsJudgment:IsCastable()) then
								if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((1463 + 1487) == (2832 + 980))) then
									return "lights_judgment cd 14";
								end
							end
							if (((6137 - (1001 + 413)) >= (5168 - 2850)) and v98.Fireblood:IsCastable()) then
								if (v24(v98.Fireblood) or ((2909 - (244 + 638)) > (3545 - (627 + 66)))) then
									return "fireblood cd 16";
								end
							end
							v215 = 5 - 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v143 = 602 - (512 + 90);
		while true do
			if ((v143 == (1906 - (1665 + 241))) or ((1853 - (373 + 344)) > (1948 + 2369))) then
				if (((1257 + 3491) == (12523 - 7775)) and v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) then
					if (((6321 - 2585) <= (5839 - (35 + 1064))) and v24(v98.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if ((v98.IceNova:IsCastable() and v48) or ((2467 + 923) <= (6546 - 3486))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((4 + 995) > (3929 - (298 + 938)))) then
						return "ice_nova movement";
					end
				end
				v143 = 1260 - (233 + 1026);
			end
			if (((2129 - (636 + 1030)) < (308 + 293)) and (v143 == (1 + 0))) then
				if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (9 + 21)) and (v103 >= (1 + 1))) or ((2404 - (55 + 166)) < (134 + 553))) then
					if (((458 + 4091) == (17372 - 12823)) and v24(v98.ArcaneExplosion, not v15:IsInRange(305 - (36 + 261)))) then
						return "arcane_explosion movement";
					end
				end
				if (((8170 - 3498) == (6040 - (34 + 1334))) and v98.FireBlast:IsCastable() and UseFireblast) then
					if (v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast)) or ((1411 + 2257) < (307 + 88))) then
						return "fire_blast movement";
					end
				end
				v143 = 1285 - (1035 + 248);
			end
			if ((v143 == (23 - (20 + 1))) or ((2171 + 1995) == (774 - (134 + 185)))) then
				if ((v98.IceLance:IsCastable() and v47) or ((5582 - (549 + 584)) == (3348 - (314 + 371)))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((14682 - 10405) < (3957 - (478 + 490)))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (1174 - (786 + 386))) or ((2817 - 1947) >= (5528 - (1055 + 324)))) then
				if (((3552 - (1093 + 247)) < (2829 + 354)) and v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and ((v14:PrevGCDP(3 - 2, v98.GlacialSpike) and (v106 == (0 - 0))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (2 - 1))))) then
					if (((11674 - 7028) > (1065 + 1927)) and v24(v98.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((5524 - 4090) < (10705 - 7599)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) then
					if (((593 + 193) < (7730 - 4707)) and v24(v98.ConeofCold)) then
						return "cone_of_cold aoe 14";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((3130 - (364 + 324)) < (202 - 128))) then
					if (((10882 - 6347) == (1504 + 3031)) and v24(v98.ShiftingPower, not v15:IsInRange(167 - 127), true)) then
						return "shifting_power aoe 16";
					end
				end
				v144 = 4 - 1;
			end
			if (((2 - 1) == v144) or ((4277 - (1249 + 19)) <= (1901 + 204))) then
				if (((7123 - 5293) < (4755 - (686 + 400))) and v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (254 - (73 + 156)))) or (v98.ConeofCold:CooldownRemains() > (1 + 19)))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((2241 - (721 + 90)) >= (41 + 3571))) then
						return "comet_storm aoe 8";
					end
				end
				if (((8711 - 6028) >= (2930 - (224 + 246))) and v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 - 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or ((328 + 1476) >= (78 + 3197))) then
						return "freeze aoe 10";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and (v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (3 - 2))))) or ((1930 - (203 + 310)) > (5622 - (1238 + 755)))) then
					if (((335 + 4460) > (1936 - (709 + 825))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				v144 = 3 - 1;
			end
			if (((7010 - 2197) > (4429 - (196 + 668))) and (v144 == (19 - 14))) then
				if (((8103 - 4191) == (4745 - (171 + 662))) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (123 - (4 + 89))) and (v103 >= (24 - 17))) then
					if (((1028 + 1793) <= (21188 - 16364)) and v24(v98.ArcaneExplosion, not v15:IsInRange(4 + 4))) then
						return "arcane_explosion aoe 28";
					end
				end
				if (((3224 - (35 + 1451)) <= (3648 - (28 + 1425))) and v98.Frostbolt:IsCastable() and v41) then
					if (((2034 - (941 + 1052)) <= (2894 + 124)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((3659 - (822 + 692)) <= (5858 - 1754)) and v14:IsMoving() and v94) then
					local v216 = v124();
					if (((1267 + 1422) < (5142 - (45 + 252))) and v216) then
						return v216;
					end
				end
				break;
			end
			if (((3 + 0) == v144) or ((800 + 1522) > (6380 - 3758))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (438 - (114 + 319))) and (v98.Blizzard:CooldownRemains() > v111)) or ((6509 - 1975) == (2667 - 585))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((1002 + 569) > (2780 - 913))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (0 - 0)) and (v14:PrevGCDP(1964 - (556 + 1407), v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (1207.8 - (741 + 465))))) or ((3119 - (170 + 295)) >= (1579 + 1417))) then
					if (((3654 + 324) > (5180 - 3076)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 20";
					end
				end
				if (((2483 + 512) > (989 + 552)) and v98.Flurry:IsCastable() and v43 and (v106 == (0 + 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if (((4479 - (957 + 273)) > (255 + 698)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 21";
					end
				end
				v144 = 2 + 2;
			end
			if ((v144 == (0 - 0)) or ((8625 - 5352) > (13968 - 9395))) then
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(4 - 3, v98.CometStorm) or (v14:PrevGCDP(1781 - (389 + 1391), v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) or ((1977 + 1174) < (134 + 1150))) then
					if (v24(v98.ConeofCold) or ((4211 - 2361) == (2480 - (783 + 168)))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((2755 - 1934) < (2089 + 34)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(312 - (309 + 2), v98.GlacialSpike) or not v114())) then
					if (((2769 - 1867) < (3537 - (1090 + 122))) and v24(v100.FrozenOrbCast, not v15:IsInRange(13 + 27))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((2881 - 2023) <= (2028 + 934)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1119 - (628 + 490), v98.GlacialSpike) or not v114())) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(8 + 32)) or ((9769 - 5823) < (5886 - 4598))) then
						return "blizzard aoe 6";
					end
				end
				v144 = 775 - (431 + 343);
			end
			if ((v144 == (7 - 3)) or ((9378 - 6136) == (448 + 119))) then
				if ((v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) or ((109 + 738) >= (2958 - (556 + 1139)))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((2268 - (6 + 9)) == (339 + 1512))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v102 >= (3 + 1)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) or ((2256 - (28 + 141)) > (919 + 1453))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((5486 - 1041) < (2939 + 1210))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v98.DragonsBreath:IsCastable() and v39 and (v103 >= (1324 - (486 + 831)))) or ((4730 - 2912) == (299 - 214))) then
					if (((120 + 510) < (6725 - 4598)) and v24(v98.DragonsBreath, not v15:IsInRange(1273 - (668 + 595)))) then
						return "dragons_breath aoe 26";
					end
				end
				v144 = 5 + 0;
			end
		end
	end
	local function v126()
		if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(2 - 1, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((2228 - (23 + 267)) == (4458 - (1129 + 815)))) then
			if (((4642 - (371 + 16)) >= (1805 - (1326 + 424))) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
				return "comet_storm cleave 2";
			end
		end
		if (((5679 - 2680) > (4224 - 3068)) and v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(119 - (88 + 30), v98.Frostbolt) and (v107 >= (774 - (720 + 51)))) or v14:PrevGCDP(2 - 1, v98.GlacialSpike) or ((v107 >= (1779 - (421 + 1355))) and (v107 < (8 - 3)) and (v98.Flurry:ChargesFractional() == (1 + 1))))) then
			if (((3433 - (286 + 797)) > (4222 - 3067)) and v112.CastTargetIf(v98.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v98.Flurry))) then
				return "flurry cleave 4";
			end
			if (((6672 - 2643) <= (5292 - (397 + 42))) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
				return "flurry cleave 4";
			end
		end
		if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (0 + 0)) and (v107 == (804 - (24 + 776))) and v14:BuffUp(v98.FingersofFrostBuff)) or ((794 - 278) > (4219 - (222 + 563)))) then
			if (((8914 - 4868) >= (2184 + 849)) and v112.CastTargetIf(v98.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance cleave 6";
			end
			if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((2909 - (23 + 167)) <= (3245 - (690 + 1108)))) then
				return "ice_lance cleave 6";
			end
		end
		if ((v98.RayofFrost:IsCastable() and (v106 == (1 + 0)) and v49) or ((3410 + 724) < (4774 - (40 + 808)))) then
			if (v112.CastTargetIf(v98.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v98.RayofFrost)) or ((28 + 136) >= (10649 - 7864))) then
				return "ray_of_frost cleave 8";
			end
			if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((502 + 23) == (1116 + 993))) then
				return "ray_of_frost cleave 8";
			end
		end
		if (((19 + 14) == (604 - (47 + 524))) and v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1)) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) then
			if (((4566 - 1512) <= (9156 - 5141)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 10";
			end
		end
		if (((3597 - (1165 + 561)) < (101 + 3281)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (6 - 4)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
			if (((494 + 799) <= (2645 - (341 + 138))) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (3 + 7)) and (v98.FrozenOrb:CooldownRemains() > (20 - 10)) and (v106 == (326 - (89 + 237))) and (v103 >= (9 - 6))) or ((5429 - 2850) < (1004 - (581 + 300)))) then
			if (v24(v98.ConeofCold, not v15:IsSpellInRange(v98.ConeofCold)) or ((2066 - (855 + 365)) >= (5624 - 3256))) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (1238 - (1030 + 205))))) or ((3767 + 245) <= (3124 + 234))) then
			if (((1780 - (156 + 130)) <= (6827 - 3822)) and v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard))) then
				return "blizzard cleave 16";
			end
		end
		if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (16 - 6)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (20 - 10))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (3 + 7)))) or (v98.IcyVeins:CooldownRemains() < (12 + 8)))) or ((3180 - (10 + 59)) == (604 + 1530))) then
			if (((11597 - 9242) == (3518 - (671 + 492))) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
				return "shifting_power cleave 18";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1))) or ((1803 - (369 + 846)) <= (115 + 317))) then
			if (((4094 + 703) >= (5840 - (1036 + 909))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 20";
			end
		end
		if (((2844 + 733) == (6004 - 2427)) and v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(204 - (11 + 192), v98.GlacialSpike)) or (v106 > (0 + 0)))) then
			local v168 = 175 - (135 + 40);
			while true do
				if (((9192 - 5398) > (2226 + 1467)) and (v168 == (0 - 0))) then
					if (v112.CastTargetIf(v98.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance)) or ((1911 - 636) == (4276 - (50 + 126)))) then
						return "ice_lance cleave 22";
					end
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((4430 - 2839) >= (793 + 2787))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if (((2396 - (1233 + 180)) <= (2777 - (522 + 447))) and v98.IceNova:IsCastable() and v48 and (v103 >= (1425 - (107 + 1314)))) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((998 + 1152) <= (3647 - 2450))) then
				return "ice_nova cleave 24";
			end
		end
		if (((1601 + 2168) >= (2329 - 1156)) and v98.Frostbolt:IsCastable() and v41) then
			if (((5875 - 4390) == (3395 - (716 + 1194))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt cleave 26";
			end
		end
		if ((v14:IsMoving() and v94) or ((57 + 3258) <= (298 + 2484))) then
			local v169 = v124();
			if (v169 or ((1379 - (74 + 429)) >= (5717 - 2753))) then
				return v169;
			end
		end
	end
	local function v127()
		local v145 = 0 + 0;
		while true do
			if (((4 - 2) == v145) or ((1580 + 652) > (7698 - 5201))) then
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (24 - 14)) and (v98.FrozenOrb:CooldownRemains() > (443 - (279 + 154))) and (v106 == (778 - (454 + 324))) and (v102 >= (3 + 0))) or ((2127 - (12 + 5)) <= (180 + 152))) then
					if (((9391 - 5705) > (1173 + 1999)) and v24(v98.ConeofCold)) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (1095 - (277 + 816))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (12 - 9)))) or ((5657 - (1058 + 125)) < (154 + 666))) then
					if (((5254 - (815 + 160)) >= (12365 - 9483)) and v24(v100.BlizzardCursor, not v15:IsInRange(94 - 54))) then
						return "blizzard single 16";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (29 - 19)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (1908 - (41 + 1857)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (1903 - (1222 + 671))))) or (v98.IcyVeins:CooldownRemains() < (51 - 31)))) or ((2915 - 886) >= (4703 - (229 + 953)))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(1814 - (1111 + 663))) or ((3616 - (874 + 705)) >= (650 + 3992))) then
						return "shifting_power single 18";
					end
				end
				v145 = 3 + 0;
			end
			if (((3575 - 1855) < (126 + 4332)) and (v145 == (679 - (642 + 37)))) then
				if ((v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold))) or ((1094 - 658) > (3475 - (233 + 221)))) then
					if (((1648 - 935) <= (746 + 101)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((3695 - (718 + 823)) <= (2537 + 1494)) and v98.Flurry:IsCastable() and (v106 == (805 - (266 + 539))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(2 - 1, v98.Frostbolt) and (v107 >= (1228 - (636 + 589)))) or (v14:PrevGCDP(2 - 1, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (4 + 0)) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (((1677 + 2938) == (5630 - (657 + 358))) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 - 0)) and (v107 == (8 - 4)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((4977 - (1151 + 36)) == (483 + 17))) then
					if (((24 + 65) < (659 - 438)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v145 = 1833 - (1552 + 280);
			end
			if (((2888 - (64 + 770)) >= (965 + 456)) and (v145 == (2 - 1))) then
				if (((123 + 569) < (4301 - (157 + 1086))) and v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (1 - 0))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((14251 - 10997) == (2538 - 883))) then
						return "ray_of_frost single 8";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (6 - 1)) and ((v98.Flurry:Charges() >= (820 - (599 + 220))) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or ((3227 - (1813 + 118)) == (3590 + 1320))) then
					if (((4585 - (841 + 376)) == (4719 - 1351)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if (((614 + 2029) < (10413 - 6598)) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (859 - (464 + 395))) and (v14:BuffStackP(v98.FingersofFrostBuff) < (5 - 3)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (((919 + 994) > (1330 - (467 + 370))) and v24(v100.FrozenOrbCast, not v15:IsInRange(82 - 42))) then
						return "frozen_orb single 12";
					end
				end
				v145 = 2 + 0;
			end
			if (((16300 - 11545) > (535 + 2893)) and ((8 - 4) == v145)) then
				if (((1901 - (150 + 370)) <= (3651 - (74 + 1208))) and v89 and ((v92 and v34) or not v92)) then
					if (v98.BagofTricks:IsCastable() or ((11911 - 7068) == (19368 - 15284))) then
						if (((3323 + 1346) > (753 - (14 + 376))) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((v98.Frostbolt:IsCastable() and v41) or ((3255 - 1378) >= (2031 + 1107))) then
					if (((4166 + 576) >= (3459 + 167)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((13302 - 8762) == (690 + 226))) then
					local v217 = v124();
					if (v217 or ((1234 - (23 + 55)) > (10297 - 5952))) then
						return v217;
					end
				end
				break;
			end
			if (((1493 + 744) < (3816 + 433)) and ((4 - 1) == v145)) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (2 + 3))) or ((3584 - (652 + 249)) < (61 - 38))) then
					if (((2565 - (708 + 1160)) <= (2242 - 1416)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if (((2014 - 909) <= (1203 - (10 + 17))) and v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) then
					if (((5111 - (1400 + 332)) <= (7311 - 3499)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v103 >= (1912 - (242 + 1666)))) or ((338 + 450) >= (593 + 1023))) then
					if (((1581 + 273) <= (4319 - (850 + 90))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v145 = 6 - 2;
			end
		end
	end
	local function v128()
		local v146 = 1390 - (360 + 1030);
		while true do
			if (((4026 + 523) == (12839 - 8290)) and (v146 == (7 - 1))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (1661 - (909 + 752));
				v72 = EpicSettings.Settings['iceBlockHP'] or (1223 - (109 + 1114));
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v146 = 249 - (6 + 236);
			end
			if ((v146 == (4 + 1)) or ((2433 + 589) >= (7131 - 4107))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (1133 - (1076 + 57));
				v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v146 = 695 - (579 + 110);
			end
			if (((381 + 4439) > (1944 + 254)) and (v146 == (4 + 3))) then
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v146 == (410 - (174 + 233))) or ((2963 - 1902) >= (8584 - 3693))) then
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v146 = 2 + 2;
			end
			if (((2538 - (663 + 511)) <= (3991 + 482)) and (v146 == (1 + 3))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v146 = 15 - 10;
			end
			if ((v146 == (2 + 0)) or ((8463 - 4868) <= (7 - 4))) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v146 = 2 + 1;
			end
			if ((v146 == (0 - 0)) or ((3330 + 1342) == (353 + 3499))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v146 = 723 - (478 + 244);
			end
			if (((2076 - (440 + 77)) == (709 + 850)) and (v146 == (3 - 2))) then
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v146 = 1558 - (655 + 901);
			end
		end
	end
	local function v129()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v80 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v82 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['DispelDebuffs'];
		v76 = EpicSettings.Settings['DispelBuffs'];
		v90 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v91 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v85 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v86 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v88 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v130()
		v128();
		v129();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (v14:IsDeadOrGhost() or ((7058 - 5306) <= (2233 - (695 + 750)))) then
			return;
		end
		v105 = v15:GetEnemiesInSplashRange(16 - 11);
		Enemies40yRange = v14:GetEnemiesInRange(61 - 21);
		if (v33 or ((15712 - 11805) == (528 - (285 + 66)))) then
			v102 = v30(v15:GetEnemiesInSplashRangeCount(11 - 6), #Enemies40yRange);
			v103 = v30(v15:GetEnemiesInSplashRangeCount(1315 - (682 + 628)), #Enemies40yRange);
		else
			local v170 = 0 + 0;
			while true do
				if (((3769 - (176 + 123)) > (233 + 322)) and ((0 + 0) == v170)) then
					v104 = 270 - (239 + 30);
					v102 = 1 + 0;
					v170 = 1 + 0;
				end
				if ((v170 == (1 - 0)) or ((3032 - 2060) == (960 - (306 + 9)))) then
					v103 = 3 - 2;
					break;
				end
			end
		end
		if (((554 + 2628) >= (1298 + 817)) and not v14:AffectingCombat()) then
			if (((1874 + 2019) < (12664 - 8235)) and v98.ArcaneIntellect:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
				if (v24(v98.ArcaneIntellect) or ((4242 - (1140 + 235)) < (1213 + 692))) then
					return "arcane_intellect";
				end
			end
		end
		if (v112.TargetIsValid() or v14:AffectingCombat() or ((1647 + 149) >= (1040 + 3011))) then
			local v171 = 52 - (33 + 19);
			while true do
				if (((585 + 1034) <= (11257 - 7501)) and (v171 == (1 + 0))) then
					if (((1184 - 580) == (567 + 37)) and (v110 == (11800 - (586 + 103)))) then
						v110 = v10.FightRemains(Enemies40yRange, false);
					end
					v106 = v15:DebuffStack(v98.WintersChillDebuff);
					v171 = 1 + 1;
				end
				if ((v171 == (5 - 3)) or ((5972 - (1309 + 179)) == (1624 - 724))) then
					v107 = v14:BuffStackP(v98.IciclesBuff);
					v111 = v14:GCD();
					break;
				end
				if ((v171 == (0 + 0)) or ((11974 - 7515) <= (841 + 272))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v171 = 1 - 0;
				end
			end
		end
		if (((7237 - 3605) > (4007 - (295 + 314))) and v112.TargetIsValid()) then
			if (((10025 - 5943) <= (6879 - (1300 + 662))) and v16) then
				if (((15173 - 10341) >= (3141 - (1178 + 577))) and v77) then
					local v218 = 0 + 0;
					while true do
						if (((404 - 267) == (1542 - (851 + 554))) and (v218 == (0 + 0))) then
							v31 = v120();
							if (v31 or ((4354 - 2784) >= (9408 - 5076))) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if ((not v14:AffectingCombat() and v32) or ((4366 - (115 + 187)) <= (1394 + 425))) then
				v31 = v122();
				if (v31 or ((4721 + 265) < (6202 - 4628))) then
					return v31;
				end
			end
			v31 = v119();
			if (((5587 - (160 + 1001)) > (151 + 21)) and v31) then
				return v31;
			end
			if (((405 + 181) > (931 - 476)) and (v14:AffectingCombat() or v77)) then
				local v212 = 358 - (237 + 121);
				local v213;
				while true do
					if (((1723 - (525 + 372)) == (1565 - 739)) and (v212 == (3 - 2))) then
						if (v31 or ((4161 - (96 + 46)) > (5218 - (643 + 134)))) then
							return v31;
						end
						break;
					end
					if (((729 + 1288) < (10216 - 5955)) and (v212 == (0 - 0))) then
						v213 = v77 and v98.RemoveCurse:IsReady() and v35;
						v31 = v112.FocusUnit(v213, v100, 20 + 0, nil, 39 - 19);
						v212 = 1 - 0;
					end
				end
			end
			if (((5435 - (316 + 403)) > (54 + 26)) and v78) then
				if (v97 or ((9642 - 6135) == (1183 + 2089))) then
					v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 75 - 45);
					if (v31 or ((621 + 255) >= (992 + 2083))) then
						return v31;
					end
				end
			end
			if (((15079 - 10727) > (12197 - 9643)) and v79) then
				v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 62 - 32, true);
				if (v31 or ((253 + 4153) < (7958 - 3915))) then
					return v31;
				end
			end
			if ((v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) or ((93 + 1796) >= (9953 - 6570))) then
				if (((1909 - (12 + 5)) <= (10618 - 7884)) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if (((4102 - 2179) < (4714 - 2496)) and v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
				if (((5388 - 3215) > (77 + 302)) and v34) then
					v31 = v123();
					if (v31 or ((4564 - (1656 + 317)) == (3038 + 371))) then
						return v31;
					end
				end
				if (((3618 + 896) > (8838 - 5514)) and v33 and (((v103 >= (34 - 27)) and not v14:HasTier(384 - (5 + 349), 9 - 7)) or ((v103 >= (1274 - (266 + 1005))) and v98.IceCaller:IsAvailable()))) then
					local v219 = 0 + 0;
					while true do
						if ((v219 == (0 - 0)) or ((273 - 65) >= (6524 - (561 + 1135)))) then
							v31 = v125();
							if (v31 or ((2062 - 479) > (11724 - 8157))) then
								return v31;
							end
							v219 = 1067 - (507 + 559);
						end
						if (((2 - 1) == v219) or ((4060 - 2747) == (1182 - (212 + 176)))) then
							if (((4079 - (250 + 655)) > (7913 - 5011)) and v24(v98.Pool)) then
								return "pool for Aoe()";
							end
							break;
						end
					end
				end
				if (((7199 - 3079) <= (6665 - 2405)) and v33 and (v103 == (1958 - (1869 + 87)))) then
					local v220 = 0 - 0;
					while true do
						if ((v220 == (1901 - (484 + 1417))) or ((1892 - 1009) > (8007 - 3229))) then
							v31 = v126();
							if (v31 or ((4393 - (48 + 725)) >= (7989 - 3098))) then
								return v31;
							end
							v220 = 2 - 1;
						end
						if (((2475 + 1783) > (2503 - 1566)) and (v220 == (1 + 0))) then
							if (v24(v98.Pool) or ((1419 + 3450) < (1759 - (152 + 701)))) then
								return "pool for Cleave()";
							end
							break;
						end
					end
				end
				v31 = v127();
				if (v31 or ((2536 - (430 + 881)) > (1620 + 2608))) then
					return v31;
				end
				if (((4223 - (557 + 338)) > (662 + 1576)) and v24(v98.Pool)) then
					return "pool for ST()";
				end
				if (((10818 - 6979) > (4919 - 3514)) and v94) then
					local v221 = 0 - 0;
					while true do
						if (((0 - 0) == v221) or ((2094 - (499 + 302)) <= (1373 - (39 + 827)))) then
							v31 = v124();
							if (v31 or ((7994 - 5098) < (1797 - 992))) then
								return v31;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v131()
		v113();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(254 - 190, v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

