local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((564 + 112) >= (2804 - (171 + 991)))) then
			return v6(...);
		end
		if (((17045 - 12909) > (6436 - 4039)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((3469 + 865) == (14880 - 10635))) then
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
	local v98 = v19.Mage.Frost;
	local v99 = v21.Mage.Frost;
	local v100 = v26.Mage.Frost;
	local v101 = {};
	local v102, v103;
	local v104;
	local v105;
	local v106 = 0 - 0;
	local v107 = 0 - 0;
	local v108 = 1263 - (111 + 1137);
	local v109 = 11269 - (91 + 67);
	local v110 = 33069 - 21958;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((1067 + 3209) <= (3554 - (423 + 100)))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(595 + 84126);
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(632952 - 404355);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(119023 + 109331);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(229369 - (326 + 445));
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(997604 - 769004);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (2 - 1)) or ((5493 - (530 + 181)) <= (2080 - (614 + 267)))) then
				v106 = 32 - (19 + 13);
				break;
			end
			if ((v132 == (0 - 0)) or ((11334 - 6470) < (5433 - 3531))) then
				v109 = 2886 + 8225;
				v110 = 19540 - 8429;
				v132 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v133)
		local v134 = 1812 - (1293 + 519);
		while true do
			if (((9872 - 5033) >= (9660 - 5960)) and (v134 == (0 - 0))) then
				if ((v133 == nil) or ((4635 - 3560) > (4518 - 2600))) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < (39 + 34));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v135)
		if (((81 + 315) <= (8838 - 5034)) and (v98.WintersChillDebuff:AuraActiveCount() == (0 + 0))) then
			return 0 + 0;
		end
		local v136 = 0 + 0;
		for v165, v166 in pairs(v135) do
			v136 = v136 + v166:DebuffStack(v98.WintersChillDebuff);
		end
		return v136;
	end
	local function v117(v137)
		return (v137:DebuffStack(v98.WintersChillDebuff));
	end
	local function v118(v138)
		return (v138:DebuffDown(v98.WintersChillDebuff));
	end
	local function v119()
		local v139 = 1096 - (709 + 387);
		while true do
			if ((v139 == (1862 - (673 + 1185))) or ((12090 - 7921) == (7022 - 4835))) then
				if (((2312 - 906) == (1006 + 400)) and v84 and (v14:HealthPercentage() <= v86)) then
					if (((1144 + 387) < (5766 - 1495)) and (v88 == "Refreshing Healing Potion")) then
						if (((156 + 479) == (1266 - 631)) and v99.RefreshingHealingPotion:IsReady()) then
							if (((6620 - 3247) <= (5436 - (446 + 1434))) and v24(v100.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((4574 - (1040 + 243)) < (9789 - 6509))) then
						if (((6233 - (559 + 1288)) >= (2804 - (609 + 1322))) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (((1375 - (13 + 441)) <= (4117 - 3015)) and v24(v100.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((12326 - 7620) >= (4796 - 3833)) and (v139 == (1 + 2))) then
				if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((3486 - 2526) <= (312 + 564))) then
					if (v24(v98.AlterTime) or ((906 + 1160) == (2765 - 1833))) then
						return "alter_time defensive 7";
					end
				end
				if (((2641 + 2184) < (8906 - 4063)) and v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
					if (v24(v100.Healthstone) or ((2564 + 1313) >= (2524 + 2013))) then
						return "healthstone defensive";
					end
				end
				v139 = 3 + 1;
			end
			if ((v139 == (0 + 0)) or ((4222 + 93) < (2159 - (153 + 280)))) then
				if ((v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((10623 - 6944) < (562 + 63))) then
					if (v24(v98.IceBarrier) or ((1827 + 2798) < (331 + 301))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2 + 0)) or ((61 + 22) > (2710 - 930))) then
					if (((338 + 208) <= (1744 - (89 + 578))) and v24(v98.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (1 - 0)) or ((2045 - (572 + 477)) > (581 + 3720))) then
				if (((2443 + 1627) > (83 + 604)) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (v24(v98.IceColdAbility) or ((742 - (84 + 2)) >= (5488 - 2158))) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((1796 + 696) <= (1177 - (497 + 345)))) then
					if (((111 + 4211) >= (434 + 2128)) and v24(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v139 = 1335 - (605 + 728);
			end
			if ((v139 == (2 + 0)) or ((8085 - 4448) >= (173 + 3597))) then
				if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((8795 - 6416) > (4128 + 450))) then
					if (v24(v98.MirrorImage) or ((1337 - 854) > (562 + 181))) then
						return "mirror_image defensive 5";
					end
				end
				if (((2943 - (457 + 32)) > (246 + 332)) and v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
					if (((2332 - (832 + 570)) < (4200 + 258)) and v24(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v139 = 1 + 2;
			end
		end
	end
	local function v120()
		if (((2342 - 1680) <= (469 + 503)) and v98.RemoveCurse:IsReady() and v35 and v112.DispellableFriendlyUnit(816 - (588 + 208))) then
			if (((11778 - 7408) == (6170 - (884 + 916))) and v24(v100.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v121()
		v31 = v112.HandleTopTrinket(v101, v34, 83 - 43, nil);
		if (v31 or ((2762 + 2000) <= (1514 - (232 + 421)))) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 1929 - (1569 + 320), nil);
		if (v31 or ((347 + 1065) == (811 + 3453))) then
			return v31;
		end
	end
	local function v122()
		if (v112.TargetIsValid() or ((10675 - 7507) < (2758 - (316 + 289)))) then
			if ((v98.MirrorImage:IsCastable() and v68 and v96) or ((13025 - 8049) < (62 + 1270))) then
				if (((6081 - (666 + 787)) == (5053 - (360 + 65))) and v24(v98.MirrorImage)) then
					return "mirror_image precombat 2";
				end
			end
			if ((v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) or ((51 + 3) == (649 - (79 + 175)))) then
				if (((128 - 46) == (64 + 18)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		local v141;
		while true do
			if (((3 - 1) == v140) or ((1480 - (503 + 396)) < (463 - (92 + 89)))) then
				if ((v83 < v110) or ((8940 - 4331) < (1280 + 1215))) then
					if (((682 + 470) == (4511 - 3359)) and v90 and ((v34 and v91) or not v91)) then
						v31 = v121();
						if (((260 + 1636) <= (7802 - 4380)) and v31) then
							return v31;
						end
					end
				end
				if ((v89 and ((v92 and v34) or not v92) and (v83 < v110)) or ((864 + 126) > (774 + 846))) then
					local v210 = 0 - 0;
					while true do
						if ((v210 == (1 + 0)) or ((1336 - 459) > (5939 - (485 + 759)))) then
							if (((6226 - 3535) >= (3040 - (442 + 747))) and v98.LightsJudgment:IsCastable()) then
								if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((4120 - (832 + 303)) >= (5802 - (88 + 858)))) then
									return "lights_judgment cd 14";
								end
							end
							if (((1304 + 2972) >= (989 + 206)) and v98.Fireblood:IsCastable()) then
								if (((134 + 3098) <= (5479 - (766 + 23))) and v24(v98.Fireblood)) then
									return "fireblood cd 16";
								end
							end
							v210 = 9 - 7;
						end
						if (((2 - 0) == v210) or ((2360 - 1464) >= (10677 - 7531))) then
							if (((4134 - (1036 + 37)) >= (2098 + 860)) and v98.AncestralCall:IsCastable()) then
								if (((6206 - 3019) >= (507 + 137)) and v24(v98.AncestralCall)) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((2124 - (641 + 839)) <= (1617 - (910 + 3))) and (v210 == (0 - 0))) then
							if (((2642 - (1466 + 218)) > (436 + 511)) and v98.BloodFury:IsCastable()) then
								if (((5640 - (556 + 592)) >= (944 + 1710)) and v24(v98.BloodFury)) then
									return "blood_fury cd 10";
								end
							end
							if (((4250 - (329 + 479)) >= (2357 - (174 + 680))) and v98.Berserking:IsCastable()) then
								if (v24(v98.Berserking) or ((10892 - 7722) <= (3034 - 1570))) then
									return "berserking cd 12";
								end
							end
							v210 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v140 == (739 - (396 + 343))) or ((425 + 4372) == (5865 - (29 + 1448)))) then
				if (((1940 - (135 + 1254)) <= (2565 - 1884)) and v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(4 - 3, v98.IcyVeins)) then
					if (((2184 + 1093) > (1934 - (389 + 1138))) and v24(v98.TimeWarp, not v15:IsInRange(614 - (102 + 472)))) then
						return "time_warp cd 2";
					end
				end
				v141 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v140 = 1 + 0;
			end
			if (((2604 + 2091) >= (1320 + 95)) and (v140 == (1546 - (320 + 1225)))) then
				if (v141 or ((5717 - 2505) <= (578 + 366))) then
					return v141;
				end
				if ((v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) or ((4560 - (157 + 1307)) <= (3657 - (821 + 1038)))) then
					if (((8824 - 5287) == (387 + 3150)) and v24(v98.IcyVeins)) then
						return "icy_veins cd 6";
					end
				end
				v140 = 3 - 1;
			end
		end
	end
	local function v124()
		local v142 = 0 + 0;
		while true do
			if (((9510 - 5673) >= (2596 - (834 + 192))) and (v142 == (0 + 0))) then
				if ((v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or ((758 + 2192) == (82 + 3730))) then
					if (((7316 - 2593) >= (2622 - (300 + 4))) and v24(v98.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if ((v98.IceNova:IsCastable() and v48) or ((542 + 1485) > (7465 - 4613))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((1498 - (112 + 250)) > (1721 + 2596))) then
						return "ice_nova movement";
					end
				end
				v142 = 2 - 1;
			end
			if (((2721 + 2027) == (2456 + 2292)) and (v142 == (1 + 0))) then
				if (((1853 + 1883) <= (3522 + 1218)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1444 - (1001 + 413))) and (v103 >= (4 - 2))) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(890 - (244 + 638))) or ((4083 - (627 + 66)) <= (9117 - 6057))) then
						return "arcane_explosion movement";
					end
				end
				if ((v98.FireBlast:IsCastable() and UseFireblast) or ((1601 - (512 + 90)) > (4599 - (1665 + 241)))) then
					if (((1180 - (373 + 344)) < (272 + 329)) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v142 = 1 + 1;
			end
			if ((v142 == (5 - 3)) or ((3693 - 1510) < (1786 - (35 + 1064)))) then
				if (((3310 + 1239) == (9732 - 5183)) and v98.IceLance:IsCastable() and v47) then
					if (((19 + 4653) == (5908 - (298 + 938))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v143 = 1259 - (233 + 1026);
		while true do
			if ((v143 == (1668 - (636 + 1030))) or ((1876 + 1792) < (386 + 9))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((1238 + 2928) == (31 + 424))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(261 - (55 + 166)), true) or ((863 + 3586) == (268 + 2395))) then
						return "shifting_power aoe 16";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (18 - 13)) and (v98.Blizzard:CooldownRemains() > v111)) or ((4574 - (36 + 261)) < (5226 - 2237))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((2238 - (34 + 1334)) >= (1595 + 2554))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((1719 + 493) < (4466 - (1035 + 248))) and v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (21 - (20 + 1))) and (v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (320.8 - (134 + 185))))) then
					if (((5779 - (549 + 584)) > (3677 - (314 + 371))) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 20";
					end
				end
				if (((4922 - 3488) < (4074 - (478 + 490))) and v98.Flurry:IsCastable() and v43 and (v106 == (0 + 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if (((1958 - (786 + 386)) < (9791 - 6768)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 21";
					end
				end
				v143 = 1382 - (1055 + 324);
			end
			if ((v143 == (1344 - (1093 + 247))) or ((2171 + 271) < (8 + 66))) then
				if (((18004 - 13469) == (15390 - 10855)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((8561 - 5552) <= (5289 - 3184))) then
						return "frostbolt aoe 32";
					end
				end
				if (((651 + 1179) < (14134 - 10465)) and v14:IsMoving() and v94) then
					local v211 = v124();
					if (v211 or ((4928 - 3498) >= (2724 + 888))) then
						return v211;
					end
				end
				break;
			end
			if (((6861 - 4178) >= (3148 - (364 + 324))) and (v143 == (7 - 4))) then
				if ((v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) or ((4328 - 2524) >= (1086 + 2189))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((5929 - 4512) > (5811 - 2182))) then
						return "ice_lance aoe 22";
					end
				end
				if (((14562 - 9767) > (1670 - (1249 + 19))) and v98.IceNova:IsCastable() and v48 and (v102 >= (4 + 0)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) then
					if (((18734 - 13921) > (4651 - (686 + 400))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if (((3070 + 842) == (4141 - (73 + 156))) and v98.DragonsBreath:IsCastable() and v39 and (v103 >= (1 + 6))) then
					if (((3632 - (721 + 90)) <= (55 + 4769)) and v24(v98.DragonsBreath, not v15:IsInRange(32 - 22))) then
						return "dragons_breath aoe 26";
					end
				end
				if (((2208 - (224 + 246)) <= (3555 - 1360)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (55 - 25)) and (v103 >= (2 + 5))) then
					if (((1 + 40) <= (2217 + 801)) and v24(v98.ArcaneExplosion, not v15:IsInRange(15 - 7))) then
						return "arcane_explosion aoe 28";
					end
				end
				v143 = 12 - 8;
			end
			if (((2658 - (203 + 310)) <= (6097 - (1238 + 755))) and (v143 == (1 + 0))) then
				if (((4223 - (709 + 825)) < (8927 - 4082)) and v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 - 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(865 - (196 + 668), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or ((9167 - 6845) > (5431 - 2809))) then
						return "freeze aoe 10";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(834 - (171 + 662), v98.Freeze) and (v14:PrevGCDP(94 - (4 + 89), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (3 - 2))))) or ((1651 + 2883) == (9144 - 7062))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((617 + 954) > (3353 - (35 + 1451)))) then
						return "ice_nova aoe 11";
					end
				end
				if ((v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1454 - (28 + 1425), v98.Freeze) and ((v14:PrevGCDP(1994 - (941 + 1052), v98.GlacialSpike) and (v106 == (0 + 0))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1515 - (822 + 692)))))) or ((3788 - 1134) >= (1412 + 1584))) then
					if (((4275 - (45 + 252)) > (2082 + 22)) and v24(v98.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((1031 + 1964) > (3750 - 2209)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) then
					if (((3682 - (114 + 319)) > (1367 - 414)) and v24(v98.ConeofCold)) then
						return "cone_of_cold aoe 14";
					end
				end
				v143 = 2 - 0;
			end
			if ((v143 == (0 + 0)) or ((4876 - 1603) > (9581 - 5008))) then
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1964 - (556 + 1407), v98.CometStorm) or (v14:PrevGCDP(1207 - (741 + 465), v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) or ((3616 - (170 + 295)) < (677 + 607))) then
					if (v24(v98.ConeofCold) or ((1700 + 150) == (3764 - 2235))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((681 + 140) < (1362 + 761)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) then
					if (((2132 - (957 + 273)) < (622 + 1703)) and v24(v100.FrozenOrbCast, not v15:IsInRange(17 + 23))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((3269 - 2411) <= (7805 - 4843)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(2 - 1, v98.GlacialSpike) or not v114())) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(198 - 158)) or ((5726 - (389 + 1391)) < (809 + 479))) then
						return "blizzard aoe 6";
					end
				end
				if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (56 - 31))) or (v98.ConeofCold:CooldownRemains() > (971 - (783 + 168))))) or ((10880 - 7638) == (558 + 9))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((1158 - (309 + 2)) >= (3878 - 2615))) then
						return "comet_storm aoe 8";
					end
				end
				v143 = 1213 - (1090 + 122);
			end
		end
	end
	local function v126()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (0 - 0)) or ((1542 + 711) == (2969 - (628 + 490)))) then
				if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(2 - 1, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((9537 - 7450) > (3146 - (431 + 343)))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((8977 - 4532) < (12002 - 7853))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v98.Frostbolt) and (v107 >= (1 + 2))) or v14:PrevGCDP(1696 - (556 + 1139), v98.GlacialSpike) or ((v107 >= (18 - (6 + 9))) and (v107 < (1 + 4)) and (v98.Flurry:ChargesFractional() == (2 + 0))))) or ((1987 - (28 + 141)) == (33 + 52))) then
					if (((777 - 147) < (1507 + 620)) and v112.CastTargetIf(v98.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry cleave 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (1317 - (486 + 831))) and (v107 == (10 - 6)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((6822 - 4884) == (476 + 2038))) then
					if (((13454 - 9199) >= (1318 - (668 + 595))) and v112.CastTargetIf(v98.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
				end
				if (((2699 + 300) > (234 + 922)) and v98.RayofFrost:IsCastable() and (v106 == (2 - 1)) and v49) then
					if (((2640 - (23 + 267)) > (3099 - (1129 + 815))) and v112.CastTargetIf(v98.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
				end
				v144 = 388 - (371 + 16);
			end
			if (((5779 - (1326 + 424)) <= (9190 - 4337)) and (v144 == (10 - 7))) then
				if ((v98.Frostbolt:IsCastable() and v41) or ((634 - (88 + 30)) > (4205 - (720 + 51)))) then
					if (((9000 - 4954) >= (4809 - (421 + 1355))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((4485 - 1766) <= (711 + 736))) then
					local v212 = v124();
					if (v212 or ((5217 - (286 + 797)) < (14351 - 10425))) then
						return v212;
					end
				end
				break;
			end
			if (((2 - 0) == v144) or ((603 - (397 + 42)) >= (870 + 1915))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (810 - (24 + 776))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (15 - 5))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (795 - (222 + 563))))) or (v98.IcyVeins:CooldownRemains() < (44 - 24)))) or ((378 + 147) == (2299 - (23 + 167)))) then
					if (((1831 - (690 + 1108)) == (12 + 21)) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if (((2520 + 534) <= (4863 - (40 + 808))) and v98.GlacialSpike:IsReady() and v45 and (v107 == (1 + 4))) then
					if (((7154 - 5283) < (3233 + 149)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 20";
					end
				end
				if (((685 + 608) <= (1188 + 978)) and v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(572 - (47 + 524), v98.GlacialSpike)) or (v106 > (0 + 0)))) then
					if (v112.CastTargetIf(v98.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance)) or ((7049 - 4470) < (183 - 60))) then
						return "ice_lance cleave 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v103 >= (8 - 4))) or ((2572 - (1165 + 561)) >= (71 + 2297))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((12425 - 8413) <= (1282 + 2076))) then
						return "ice_nova cleave 24";
					end
				end
				v144 = 482 - (341 + 138);
			end
			if (((404 + 1090) <= (6201 - 3196)) and (v144 == (327 - (89 + 237)))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (16 - 11)) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) or ((3992 - (581 + 300)) == (3354 - (855 + 365)))) then
					if (((5593 - 3238) == (769 + 1586)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1237 - (1030 + 205))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((553 + 35) <= (402 + 30))) then
					if (((5083 - (156 + 130)) >= (8850 - 4955)) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				if (((6028 - 2451) == (7325 - 3748)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (3 + 7)) and (v98.FrozenOrb:CooldownRemains() > (6 + 4)) and (v106 == (69 - (10 + 59))) and (v103 >= (1 + 2))) then
					if (((18684 - 14890) > (4856 - (671 + 492))) and v24(v98.ConeofCold, not v15:IsSpellInRange(v98.ConeofCold))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (2 + 0)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (1218 - (369 + 846))))) or ((338 + 937) == (3499 + 601))) then
					if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((3536 - (1036 + 909)) >= (2847 + 733))) then
						return "blizzard cleave 16";
					end
				end
				v144 = 2 - 0;
			end
		end
	end
	local function v127()
		local v145 = 203 - (11 + 192);
		while true do
			if (((497 + 486) <= (1983 - (135 + 40))) and (v145 == (2 - 1))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1)) and ((v98.Flurry:Charges() >= (2 - 1)) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or ((2326 - (50 + 126)) <= (3333 - 2136))) then
					if (((835 + 2934) >= (2586 - (1233 + 180))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if (((2454 - (522 + 447)) == (2906 - (107 + 1314))) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 + 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (5 - 3)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(17 + 23)) or ((6582 - 3267) <= (11007 - 8225))) then
						return "frozen_orb single 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (1920 - (716 + 1194))) and (v98.FrozenOrb:CooldownRemains() > (1 + 9)) and (v106 == (0 + 0)) and (v102 >= (506 - (74 + 429)))) or ((1689 - 813) >= (1470 + 1494))) then
					if (v24(v98.ConeofCold) or ((5108 - 2876) > (1767 + 730))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (5 - 3)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (7 - 4)))) or ((2543 - (279 + 154)) <= (1110 - (454 + 324)))) then
					if (((2900 + 786) > (3189 - (12 + 5))) and v24(v100.BlizzardCursor, not v15:IsInRange(22 + 18))) then
						return "blizzard single 16";
					end
				end
				v145 = 4 - 2;
			end
			if ((v145 == (0 + 0)) or ((5567 - (277 + 816)) < (3503 - 2683))) then
				if (((5462 - (1058 + 125)) >= (541 + 2341)) and v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(976 - (815 + 160), v98.Flurry) or v14:PrevGCDP(4 - 3, v98.ConeofCold))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((4816 - 2787) >= (840 + 2681))) then
						return "comet_storm single 2";
					end
				end
				if ((v98.Flurry:IsCastable() and (v106 == (0 - 0)) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1899 - (41 + 1857), v98.Frostbolt) and (v107 >= (1896 - (1222 + 671)))) or (v14:PrevGCDP(2 - 1, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1 - 0, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (1186 - (229 + 953))) and v14:BuffDown(v98.FingersofFrostBuff)))) or ((3811 - (1111 + 663)) >= (6221 - (874 + 705)))) then
					if (((241 + 1479) < (3042 + 1416)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 - 0)) and (v107 == (1 + 3)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((1115 - (642 + 37)) > (689 + 2332))) then
					if (((115 + 598) <= (2126 - 1279)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				if (((2608 - (233 + 221)) <= (9321 - 5290)) and v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (1 + 0))) then
					if (((6156 - (718 + 823)) == (2905 + 1710)) and v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				v145 = 806 - (266 + 539);
			end
			if ((v145 == (5 - 3)) or ((5015 - (636 + 589)) == (1186 - 686))) then
				if (((183 - 94) < (176 + 45)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (1025 - (657 + 358))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (26 - 16))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (22 - 12)))) or (v98.IcyVeins:CooldownRemains() < (1207 - (1151 + 36))))) then
					if (((1984 + 70) >= (374 + 1047)) and v24(v98.ShiftingPower, not v15:IsInRange(119 - 79))) then
						return "shifting_power single 18";
					end
				end
				if (((2524 - (1552 + 280)) < (3892 - (64 + 770))) and v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((7386 - 4132) == (294 + 1361))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1244 - (157 + 1086), v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((2593 - 1297) == (21504 - 16594))) then
					if (((5166 - 1798) == (4596 - 1228)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((3462 - (599 + 220)) < (7596 - 3781)) and v98.IceNova:IsCastable() and v48 and (v103 >= (1935 - (1813 + 118)))) then
					if (((1399 + 514) > (1710 - (841 + 376))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v145 = 3 - 0;
			end
			if (((1105 + 3650) > (9356 - 5928)) and (v145 == (862 - (464 + 395)))) then
				if (((3544 - 2163) <= (1138 + 1231)) and v89 and ((v92 and v34) or not v92)) then
					if (v98.BagofTricks:IsCastable() or ((5680 - (467 + 370)) == (8439 - 4355))) then
						if (((3428 + 1241) > (1244 - 881)) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((v98.Frostbolt:IsCastable() and v41) or ((293 + 1584) >= (7300 - 4162))) then
					if (((5262 - (150 + 370)) >= (4908 - (74 + 1208))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((11166 - 6626) == (4344 - 3428))) then
					local v213 = 0 + 0;
					local v214;
					while true do
						if ((v213 == (390 - (14 + 376))) or ((2004 - 848) > (2812 + 1533))) then
							v214 = v124();
							if (((1966 + 271) < (4053 + 196)) and v214) then
								return v214;
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
		local v146 = 0 - 0;
		while true do
			if ((v146 == (7 + 1)) or ((2761 - (23 + 55)) < (54 - 31))) then
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v146 = 3 + 6;
			end
			if (((1598 - (652 + 249)) <= (2210 - 1384)) and (v146 == (1875 - (708 + 1160)))) then
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v146 = 21 - 13;
			end
			if (((2014 - 909) <= (1203 - (10 + 17))) and (v146 == (1 + 3))) then
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v146 = 1737 - (1400 + 332);
			end
			if (((6480 - 3101) <= (5720 - (242 + 1666))) and ((1 + 1) == v146)) then
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v146 = 2 + 1;
			end
			if (((8 + 1) == v146) or ((1728 - (850 + 90)) >= (2829 - 1213))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (1390 - (360 + 1030));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v146 = 1671 - (909 + 752);
			end
			if (((3077 - (109 + 1114)) <= (6185 - 2806)) and (v146 == (4 + 6))) then
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v146 = 253 - (6 + 236);
			end
			if (((2867 + 1682) == (3662 + 887)) and (v146 == (6 - 3))) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v146 = 6 - 2;
			end
			if (((1133 - (1076 + 57)) == v146) or ((497 + 2525) >= (3713 - (579 + 110)))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v146 = 1 + 0;
			end
			if (((4262 + 558) > (1167 + 1031)) and ((408 - (174 + 233)) == v146)) then
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v146 = 5 - 3;
			end
			if ((v146 == (10 - 4)) or ((472 + 589) >= (6065 - (663 + 511)))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v146 = 7 + 0;
			end
			if (((297 + 1067) <= (13790 - 9317)) and ((7 + 4) == v146)) then
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v146 == (11 - 6)) or ((8702 - 5107) <= (2 + 1))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v146 = 11 - 5;
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
		v86 = EpicSettings.Settings['healingPotionHP'] or (722 - (478 + 244));
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
		if (v14:IsDeadOrGhost() or ((5189 - (440 + 77)) == (1752 + 2100))) then
			return;
		end
		v105 = v15:GetEnemiesInSplashRange(18 - 13);
		Enemies40yRange = v14:GetEnemiesInRange(1596 - (655 + 901));
		if (((290 + 1269) == (1194 + 365)) and v33) then
			v102 = v30(v15:GetEnemiesInSplashRangeCount(4 + 1), #Enemies40yRange);
			v103 = v30(v15:GetEnemiesInSplashRangeCount(20 - 15), #Enemies40yRange);
		else
			v104 = 1446 - (695 + 750);
			v102 = 3 - 2;
			v103 = 1 - 0;
		end
		if (not v14:AffectingCombat() or ((7046 - 5294) <= (1139 - (285 + 66)))) then
			if ((v98.ArcaneIntellect:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) or ((9107 - 5200) == (1487 - (682 + 628)))) then
				if (((560 + 2910) > (854 - (176 + 123))) and v24(v98.ArcaneIntellect)) then
					return "arcane_intellect";
				end
			end
		end
		if (v112.TargetIsValid() or v14:AffectingCombat() or ((407 + 565) == (468 + 177))) then
			local v170 = 269 - (239 + 30);
			while true do
				if (((866 + 2316) >= (2033 + 82)) and (v170 == (0 - 0))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v170 = 2 - 1;
				end
				if (((4208 - (306 + 9)) < (15455 - 11026)) and (v170 == (1 + 0))) then
					if ((v110 == (6818 + 4293)) or ((1381 + 1486) < (5447 - 3542))) then
						v110 = v10.FightRemains(Enemies40yRange, false);
					end
					v106 = v15:DebuffStack(v98.WintersChillDebuff);
					v170 = 1377 - (1140 + 235);
				end
				if ((v170 == (2 + 0)) or ((1647 + 149) >= (1040 + 3011))) then
					v107 = v14:BuffStackP(v98.IciclesBuff);
					v111 = v14:GCD();
					break;
				end
			end
		end
		if (((1671 - (33 + 19)) <= (1357 + 2399)) and v112.TargetIsValid()) then
			local v171 = 0 - 0;
			while true do
				if (((267 + 337) == (1184 - 580)) and (v171 == (4 + 0))) then
					if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((5173 - (586 + 103)) == (82 + 818))) then
						if (v34 or ((13727 - 9268) <= (2601 - (1309 + 179)))) then
							local v217 = 0 - 0;
							while true do
								if (((1581 + 2051) > (9125 - 5727)) and (v217 == (0 + 0))) then
									v31 = v123();
									if (((8672 - 4590) <= (9797 - 4880)) and v31) then
										return v31;
									end
									break;
								end
							end
						end
						if (((5441 - (295 + 314)) >= (3404 - 2018)) and v33 and (((v103 >= (1969 - (1300 + 662))) and not v14:HasTier(94 - 64, 1757 - (1178 + 577))) or ((v103 >= (2 + 1)) and v98.IceCaller:IsAvailable()))) then
							local v218 = 0 - 0;
							while true do
								if (((1542 - (851 + 554)) == (122 + 15)) and (v218 == (0 - 0))) then
									v31 = v125();
									if (v31 or ((3409 - 1839) >= (4634 - (115 + 187)))) then
										return v31;
									end
									v218 = 1 + 0;
								end
								if ((v218 == (1 + 0)) or ((16014 - 11950) <= (2980 - (160 + 1001)))) then
									if (v24(v98.Pool) or ((4362 + 624) < (1087 + 487))) then
										return "pool for Aoe()";
									end
									break;
								end
							end
						end
						if (((9060 - 4634) > (530 - (237 + 121))) and v33 and (v103 == (899 - (525 + 372)))) then
							v31 = v126();
							if (((1110 - 524) > (1494 - 1039)) and v31) then
								return v31;
							end
							if (((968 - (96 + 46)) == (1603 - (643 + 134))) and v24(v98.Pool)) then
								return "pool for Cleave()";
							end
						end
						v31 = v127();
						if (v31 or ((1451 + 2568) > (10648 - 6207))) then
							return v31;
						end
						if (((7488 - 5471) < (4087 + 174)) and v24(v98.Pool)) then
							return "pool for ST()";
						end
						if (((9255 - 4539) > (163 - 83)) and v94) then
							v31 = v124();
							if (v31 or ((4226 - (316 + 403)) == (2175 + 1097))) then
								return v31;
							end
						end
					end
					break;
				end
				if ((v171 == (5 - 3)) or ((317 + 559) >= (7743 - 4668))) then
					if (((3085 + 1267) > (824 + 1730)) and (v14:AffectingCombat() or v77)) then
						local v215 = v77 and v98.RemoveCurse:IsReady() and v35;
						v31 = v112.FocusUnit(v215, v100, 69 - 49, nil, 95 - 75);
						if (v31 or ((9153 - 4747) < (232 + 3811))) then
							return v31;
						end
					end
					if (v78 or ((3718 - 1829) >= (166 + 3217))) then
						if (((5566 - 3674) <= (2751 - (12 + 5))) and v97) then
							v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 116 - 86);
							if (((4102 - 2179) < (4714 - 2496)) and v31) then
								return v31;
							end
						end
					end
					v171 = 7 - 4;
				end
				if (((442 + 1731) > (2352 - (1656 + 317))) and (v171 == (0 + 0))) then
					if (v16 or ((2077 + 514) == (9064 - 5655))) then
						if (((22215 - 17701) > (3678 - (5 + 349))) and v77) then
							local v219 = 0 - 0;
							while true do
								if ((v219 == (1271 - (266 + 1005))) or ((138 + 70) >= (16473 - 11645))) then
									v31 = v120();
									if (v31 or ((2083 - 500) > (5263 - (561 + 1135)))) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if ((not v14:AffectingCombat() and v32) or ((1710 - 397) == (2609 - 1815))) then
						local v216 = 1066 - (507 + 559);
						while true do
							if (((7964 - 4790) > (8974 - 6072)) and (v216 == (388 - (212 + 176)))) then
								v31 = v122();
								if (((5025 - (250 + 655)) <= (11616 - 7356)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v171 = 1 - 0;
				end
				if ((v171 == (1 - 0)) or ((2839 - (1869 + 87)) > (16572 - 11794))) then
					v31 = v119();
					if (v31 or ((5521 - (484 + 1417)) >= (10483 - 5592))) then
						return v31;
					end
					v171 = 2 - 0;
				end
				if (((5031 - (48 + 725)) > (1530 - 593)) and (v171 == (7 - 4))) then
					if (v79 or ((2830 + 2039) < (2421 - 1515))) then
						v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 9 + 21, true);
						if (v31 or ((357 + 868) > (5081 - (152 + 701)))) then
							return v31;
						end
					end
					if (((4639 - (430 + 881)) > (858 + 1380)) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
						if (((4734 - (557 + 338)) > (416 + 989)) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					v171 = 10 - 6;
				end
			end
		end
	end
	local function v131()
		local v164 = 0 - 0;
		while true do
			if ((v164 == (0 - 0)) or ((2786 - 1493) <= (1308 - (499 + 302)))) then
				v113();
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(930 - (39 + 827), v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

