local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5180 - (1269 + 200)) > (6430 - 3075)) and (v5 == (815 - (98 + 717)))) then
			v6 = v0[v4];
			if (not v6 or ((1732 - (802 + 24)) >= (3843 - 1614))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((191 + 1097) > (962 + 289)) and (v5 == (1 + 0))) then
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
	local v104, v105;
	local v106 = 0 + 0;
	local v107 = 0 - 0;
	local v108 = 49 - 34;
	local v109 = 3975 + 7136;
	local v110 = 4523 + 6588;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((3723 + 790) < (2438 + 914))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(39555 + 45166);
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(230030 - (797 + 636));
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(1108741 - 880387);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(230217 - (1427 + 192));
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(79208 + 149392);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v131 = 0 - 0;
		while true do
			if (((1 + 0) == v131) or ((936 + 1129) >= (3522 - (192 + 134)))) then
				v106 = 1276 - (316 + 960);
				break;
			end
			if ((v131 == (0 + 0)) or ((3378 + 998) <= (1369 + 112))) then
				v109 = 42477 - 31366;
				v110 = 11662 - (83 + 468);
				v131 = 1807 - (1202 + 604);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		if ((v132 == nil) or ((15834 - 12442) >= (7890 - 3149))) then
			v132 = v15;
		end
		return not v132:IsInBossList() or (v132:Level() < (202 - 129));
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v133)
		return (v133:DebuffStack(v98.WintersChillDebuff));
	end
	local function v117(v134)
		return (v134:DebuffDown(v98.WintersChillDebuff));
	end
	local function v118()
		if (((3650 - (45 + 280)) >= (2080 + 74)) and v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
			if (v24(v98.IceBarrier) or ((1132 + 163) >= (1181 + 2052))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((2423 + 1954) > (289 + 1353)) and v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 3 - 1)) then
			if (((6634 - (340 + 1571)) > (535 + 821)) and v24(v98.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((5908 - (1733 + 39)) <= (9433 - 6000))) then
			if (((5279 - (125 + 909)) <= (6579 - (1096 + 852))) and v24(v98.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((1919 + 2357) >= (5589 - 1675)) and v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
			if (((193 + 5) <= (4877 - (409 + 103))) and v24(v98.IceBlock)) then
				return "ice_block defensive 4";
			end
		end
		if (((5018 - (46 + 190)) > (4771 - (51 + 44))) and v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
			if (((1372 + 3492) > (3514 - (1114 + 203))) and v24(v98.MirrorImage)) then
				return "mirror_image defensive 5";
			end
		end
		if ((v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((4426 - (228 + 498)) == (544 + 1963))) then
			if (((2472 + 2002) >= (937 - (174 + 489))) and v24(v98.GreaterInvisibility)) then
				return "greater_invisibility defensive 6";
			end
		end
		if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((4934 - 3040) <= (3311 - (830 + 1075)))) then
			if (((2096 - (303 + 221)) >= (2800 - (231 + 1038))) and v24(v98.AlterTime)) then
				return "alter_time defensive 7";
			end
		end
		if ((v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) or ((3906 + 781) < (5704 - (171 + 991)))) then
			if (((13562 - 10271) > (4476 - 2809)) and v24(v100.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v84 and (v14:HealthPercentage() <= v86)) or ((2178 - 1305) == (1628 + 406))) then
			if ((v88 == "Refreshing Healing Potion") or ((9871 - 7055) < (31 - 20))) then
				if (((5962 - 2263) < (14547 - 9841)) and v99.RefreshingHealingPotion:IsReady()) then
					if (((3894 - (111 + 1137)) >= (1034 - (91 + 67))) and v24(v100.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((1827 - 1213) <= (795 + 2389)) and (v88 == "Dreamwalker's Healing Potion")) then
				if (((3649 - (423 + 100)) == (22 + 3104)) and v99.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v100.RefreshingHealingPotion) or ((6055 - 3868) >= (2583 + 2371))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v119()
		if ((v98.RemoveCurse:IsReady() and v112.DispellableFriendlyUnit(791 - (326 + 445))) or ((16918 - 13041) == (7964 - 4389))) then
			if (((1650 - 943) > (1343 - (530 + 181))) and v24(v100.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v120()
		v31 = v112.HandleTopTrinket(v101, v34, 921 - (614 + 267), nil);
		if (v31 or ((578 - (19 + 13)) >= (4368 - 1684))) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 93 - 53, nil);
		if (((4184 - 2719) <= (1118 + 3183)) and v31) then
			return v31;
		end
	end
	local function v121()
		if (((2996 - 1292) > (2955 - 1530)) and v112.TargetIsValid()) then
			local v160 = 1812 - (1293 + 519);
			while true do
				if ((v160 == (0 - 0)) or ((1793 - 1106) == (8096 - 3862))) then
					if ((v98.MirrorImage:IsCastable() and v68 and v96) or ((14359 - 11029) < (3366 - 1937))) then
						if (((608 + 539) >= (69 + 266)) and v24(v98.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if (((7980 - 4545) > (485 + 1612)) and v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
						if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt)) or ((1253 + 2517) >= (2526 + 1515))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		if ((v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1097 - (709 + 387), v98.IcyVeins)) or ((5649 - (673 + 1185)) <= (4671 - 3060))) then
			if (v24(v98.TimeWarp, not v15:IsInRange(128 - 88)) or ((7532 - 2954) <= (1437 + 571))) then
				return "time_warp cd 2";
			end
		end
		local v135 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
		if (((841 + 284) <= (2802 - 726)) and v135) then
			return v135;
		end
		if ((v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) or ((183 + 560) >= (8770 - 4371))) then
			if (((2266 - 1111) < (3553 - (446 + 1434))) and v24(v98.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v110) or ((3607 - (1040 + 243)) <= (1725 - 1147))) then
			if (((5614 - (559 + 1288)) == (5698 - (609 + 1322))) and v90 and ((v34 and v91) or not v91)) then
				v31 = v120();
				if (((4543 - (13 + 441)) == (15279 - 11190)) and v31) then
					return v31;
				end
			end
		end
		if (((11676 - 7218) >= (8337 - 6663)) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
			if (((37 + 935) <= (5149 - 3731)) and v98.BloodFury:IsCastable()) then
				if (v24(v98.BloodFury) or ((1754 + 3184) < (2087 + 2675))) then
					return "blood_fury cd 10";
				end
			end
			if (v98.Berserking:IsCastable() or ((7430 - 4926) > (2334 + 1930))) then
				if (((3959 - 1806) == (1424 + 729)) and v24(v98.Berserking)) then
					return "berserking cd 12";
				end
			end
			if (v98.LightsJudgment:IsCastable() or ((282 + 225) >= (1862 + 729))) then
				if (((3763 + 718) == (4385 + 96)) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
					return "lights_judgment cd 14";
				end
			end
			if (v98.Fireblood:IsCastable() or ((2761 - (153 + 280)) < (2001 - 1308))) then
				if (((3886 + 442) == (1709 + 2619)) and v24(v98.Fireblood)) then
					return "fireblood cd 16";
				end
			end
			if (((832 + 756) >= (1209 + 123)) and v98.AncestralCall:IsCastable()) then
				if (v24(v98.AncestralCall) or ((3025 + 1149) > (6468 - 2220))) then
					return "ancestral_call cd 18";
				end
			end
		end
	end
	local function v123()
		if ((v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or ((2835 + 1751) <= (749 - (89 + 578)))) then
			if (((2760 + 1103) == (8030 - 4167)) and v24(v98.IceFloes)) then
				return "ice_floes movement";
			end
		end
		if ((v98.IceNova:IsCastable() and v48) or ((1331 - (572 + 477)) <= (6 + 36))) then
			if (((2766 + 1843) >= (92 + 674)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova movement";
			end
		end
		if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (116 - (84 + 2))) and (v103 >= (2 - 0))) or ((830 + 322) == (3330 - (497 + 345)))) then
			if (((88 + 3334) > (567 + 2783)) and v24(v98.ArcaneExplosion, not v15:IsInRange(1341 - (605 + 728)))) then
				return "arcane_explosion movement";
			end
		end
		if (((626 + 251) > (835 - 459)) and v98.FireBlast:IsCastable() and v40) then
			if (v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast)) or ((143 + 2975) <= (6843 - 4992))) then
				return "fire_blast movement";
			end
		end
		if ((v98.IceLance:IsCastable() and v47) or ((149 + 16) >= (9674 - 6182))) then
			if (((2982 + 967) < (5345 - (457 + 32))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance movement";
			end
		end
	end
	local function v124()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (1404 - (832 + 570))) or ((4029 + 247) < (787 + 2229))) then
				if (((16597 - 11907) > (1988 + 2137)) and v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(797 - (588 + 208), v98.Freeze) and ((v14:PrevGCDP(2 - 1, v98.GlacialSpike) and (v106 == (1800 - (884 + 916)))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 - 0))))) then
					if (v24(v98.FrostNova) or ((29 + 21) >= (1549 - (232 + 421)))) then
						return "frost_nova aoe 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or ((3603 - (1569 + 320)) >= (726 + 2232))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(2 + 6)) or ((5024 - 3533) < (1249 - (316 + 289)))) then
						return "cone_of_cold aoe 14";
					end
				end
				if (((1842 - 1138) < (46 + 941)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) then
					if (((5171 - (666 + 787)) > (2331 - (360 + 65))) and v24(v98.ShiftingPower, not v15:IsInRange(38 + 2), true)) then
						return "shifting_power aoe 16";
					end
				end
				v136 = 257 - (79 + 175);
			end
			if ((v136 == (7 - 2)) or ((748 + 210) > (11142 - 7507))) then
				if (((6742 - 3241) <= (5391 - (503 + 396))) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (211 - (92 + 89))) and (v103 >= (13 - 6))) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(5 + 3)) or ((2038 + 1404) < (9978 - 7430))) then
						return "arcane_explosion aoe 28";
					end
				end
				if (((394 + 2481) >= (3337 - 1873)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((4186 + 611) >= (2338 + 2555))) then
						return "frostbolt aoe 32";
					end
				end
				if ((v14:IsMoving() and v94) or ((1678 - 1127) > (259 + 1809))) then
					local v200 = 0 - 0;
					while true do
						if (((3358 - (485 + 759)) > (2184 - 1240)) and (v200 == (1189 - (442 + 747)))) then
							v31 = v123();
							if (v31 or ((3397 - (832 + 303)) >= (4042 - (88 + 858)))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v136 == (2 + 2)) or ((1867 + 388) >= (146 + 3391))) then
				if ((v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) or ((4626 - (766 + 23)) < (6447 - 5141))) then
					if (((4034 - 1084) == (7772 - 4822)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v102 >= (13 - 9)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) or ((5796 - (1036 + 37)) < (2339 + 959))) then
					if (((2212 - 1076) >= (122 + 32)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v98.DragonsBreath:IsCastable() and v39 and (v103 >= (1487 - (641 + 839)))) or ((1184 - (910 + 3)) > (12103 - 7355))) then
					if (((6424 - (1466 + 218)) >= (1449 + 1703)) and v24(v98.DragonsBreath, not v15:IsInRange(1158 - (556 + 592)))) then
						return "dragons_breath aoe 26";
					end
				end
				v136 = 2 + 3;
			end
			if ((v136 == (809 - (329 + 479))) or ((3432 - (174 + 680)) >= (11648 - 8258))) then
				if (((84 - 43) <= (1186 + 475)) and v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(740 - (396 + 343), v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (3 + 22))) or (v98.ConeofCold:CooldownRemains() > (1497 - (29 + 1448))))) then
					if (((1990 - (135 + 1254)) < (13411 - 9851)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				if (((1097 - 862) < (458 + 229)) and v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (1527 - (389 + 1138))) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(575 - (102 + 472), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) then
					if (((4293 + 256) > (640 + 513)) and v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze))) then
						return "freeze aoe 10";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and (v14:PrevGCDP(1546 - (320 + 1225), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 - 0))))) or ((2860 + 1814) < (6136 - (157 + 1307)))) then
					if (((5527 - (821 + 1038)) < (11379 - 6818)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				v136 = 1 + 1;
			end
			if ((v136 == (4 - 1)) or ((170 + 285) == (8935 - 5330))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (1031 - (834 + 192))) and (v98.Blizzard:CooldownRemains() > v111)) or ((170 + 2493) == (851 + 2461))) then
					if (((92 + 4185) <= (6932 - 2457)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (304 - (300 + 4))) and (v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (2.8 - 1)))) or ((1232 - (112 + 250)) == (474 + 715))) then
					if (((3890 - 2337) <= (1795 + 1338)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 20";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and (v106 == (0 + 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) or ((1674 + 563) >= (1741 + 1770))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((984 + 340) > (4434 - (1001 + 413)))) then
						return "flurry aoe 21";
					end
				end
				v136 = 8 - 4;
			end
			if ((v136 == (882 - (244 + 638))) or ((3685 - (627 + 66)) == (5604 - 3723))) then
				if (((3708 - (512 + 90)) > (3432 - (1665 + 241))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(718 - (373 + 344), v98.CometStorm) or (v14:PrevGCDP(1 + 0, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
					if (((800 + 2223) < (10207 - 6337)) and v24(v98.ConeofCold, not v15:IsInRange(13 - 5))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((1242 - (35 + 1064)) > (54 + 20)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(2 - 1, v98.GlacialSpike) or not v114())) then
					if (((1 + 17) < (3348 - (298 + 938))) and v24(v100.FrozenOrbCast, not v15:IsInRange(1299 - (233 + 1026)))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((2763 - (636 + 1030)) <= (833 + 795)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) then
					if (((1376 + 3254) == (313 + 4317)) and v24(v100.BlizzardCursor, not v15:IsInRange(261 - (55 + 166)))) then
						return "blizzard aoe 6";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v125()
		local v137 = 0 + 0;
		while true do
			if (((13519 - 9979) > (2980 - (36 + 261))) and ((1 - 0) == v137)) then
				if (((6162 - (34 + 1334)) >= (1259 + 2016)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1)) and (v98.Flurry:CooldownUp() or (v106 > (1283 - (1035 + 248))))) then
					if (((1505 - (20 + 1)) == (774 + 710)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if (((1751 - (134 + 185)) < (4688 - (549 + 584))) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (687 - (314 + 371))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb)) or ((3655 - 2590) > (4546 - (478 + 490)))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (6 + 4)) and (v98.FrozenOrb:CooldownRemains() > (1182 - (786 + 386))) and (v106 == (0 - 0)) and (v103 >= (1382 - (1055 + 324)))) or ((6135 - (1093 + 247)) < (1251 + 156))) then
					if (((195 + 1658) < (19108 - 14295)) and v24(v98.ConeofCold)) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (6 - 4)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (8 - 5)))) or ((7088 - 4267) < (865 + 1566))) then
					if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((11071 - 8197) < (7517 - 5336))) then
						return "blizzard cleave 16";
					end
				end
				v137 = 2 + 0;
			end
			if ((v137 == (0 - 0)) or ((3377 - (364 + 324)) <= (939 - 596))) then
				if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(2 - 1, v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((7820 - 5951) == (3216 - 1207))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((10769 - 7223) < (3590 - (1249 + 19)))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v98.Frostbolt) and (v107 >= (11 - 8))) or v14:PrevGCDP(1087 - (686 + 400), v98.GlacialSpike) or ((v107 >= (3 + 0)) and (v107 < (234 - (73 + 156))) and (v98.Flurry:ChargesFractional() == (1 + 1))))) or ((2893 - (721 + 90)) == (54 + 4719))) then
					local v201 = 0 - 0;
					while true do
						if (((3714 - (224 + 246)) > (1709 - 654)) and (v201 == (0 - 0))) then
							if (v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v15:IsSpellInRange(v98.Flurry)) or ((601 + 2712) <= (43 + 1735))) then
								return "flurry cleave 4";
							end
							if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((1044 + 377) >= (4182 - 2078))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if (((6029 - 4217) <= (3762 - (203 + 310))) and v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (1993 - (1238 + 755))) and (v107 == (1 + 3)) and v14:BuffUp(v98.FingersofFrostBuff)) then
					if (((3157 - (709 + 825)) <= (3606 - 1649)) and v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (((6426 - 2014) == (5276 - (196 + 668))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
				end
				if (((6909 - 5159) >= (1743 - 901)) and v98.RayofFrost:IsCastable() and (v106 == (834 - (171 + 662))) and v49) then
					if (((4465 - (4 + 89)) > (6484 - 4634)) and v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (((85 + 147) < (3605 - 2784)) and v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
				end
				v137 = 1 + 0;
			end
			if (((2004 - (35 + 1451)) < (2355 - (28 + 1425))) and ((1996 - (941 + 1052)) == v137)) then
				if (((2871 + 123) > (2372 - (822 + 692))) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((5360 - 1605) <= (431 + 484))) then
						return "frostbolt cleave 26";
					end
				end
				if (((4243 - (45 + 252)) > (3704 + 39)) and v14:IsMoving() and v94) then
					local v202 = 0 + 0;
					while true do
						if ((v202 == (0 - 0)) or ((1768 - (114 + 319)) >= (4745 - 1439))) then
							v31 = v123();
							if (((6206 - 1362) > (1437 + 816)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((672 - 220) == (946 - 494)) and (v137 == (1965 - (556 + 1407)))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (1216 - (741 + 465))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (475 - (170 + 295)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (6 + 4)))) or (v98.IcyVeins:CooldownRemains() < (19 + 1)))) or ((11219 - 6662) < (1731 + 356))) then
					if (((2485 + 1389) == (2194 + 1680)) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (1235 - (957 + 273)))) or ((519 + 1419) > (1976 + 2959))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((16213 - 11958) < (9020 - 5597))) then
						return "glacial_spike cleave 20";
					end
				end
				if (((4440 - 2986) <= (12334 - 9843)) and v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(1781 - (389 + 1391), v98.GlacialSpike)) or (v106 > (0 + 0)))) then
					if (v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v15:IsSpellInRange(v98.IceLance)) or ((433 + 3724) <= (6381 - 3578))) then
						return "ice_lance cleave 22";
					end
					if (((5804 - (783 + 168)) >= (10008 - 7026)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
				end
				if (((4067 + 67) > (3668 - (309 + 2))) and v98.IceNova:IsCastable() and v48 and (v103 >= (12 - 8))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((4629 - (1090 + 122)) < (822 + 1712))) then
						return "ice_nova cleave 24";
					end
				end
				v137 = 9 - 6;
			end
		end
	end
	local function v126()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1120 - (628 + 490))) or ((489 + 2233) <= (405 - 241))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 - 0)) and (((v98.FrozenOrb:CooldownRemains() > (784 - (431 + 343))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (20 - 10))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (28 - 18)))) or (v98.IcyVeins:CooldownRemains() < (16 + 4)))) or ((308 + 2100) < (3804 - (556 + 1139)))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(55 - (6 + 9))) or ((7 + 26) == (746 + 709))) then
						return "shifting_power single 18";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (174 - (28 + 141)))) or ((172 + 271) >= (4955 - 940))) then
					if (((2396 + 986) > (1483 - (486 + 831))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(2 - 1, v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((985 - 705) == (579 + 2480))) then
					if (((5947 - 4066) > (2556 - (668 + 595))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((2121 + 236) == (476 + 1881)) and v98.IceNova:IsCastable() and v48 and (v103 >= (10 - 6))) then
					if (((413 - (23 + 267)) == (2067 - (1129 + 815))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v138 = 390 - (371 + 16);
			end
			if ((v138 == (1750 - (1326 + 424))) or ((1999 - 943) >= (12395 - 9003))) then
				if ((v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(119 - (88 + 30), v98.Flurry) or v14:PrevGCDP(772 - (720 + 51), v98.ConeofCold))) or ((2404 - 1323) < (2851 - (421 + 1355)))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((1730 - 681) >= (2178 + 2254))) then
						return "comet_storm single 2";
					end
				end
				if ((v98.Flurry:IsCastable() and (v106 == (1083 - (286 + 797))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(3 - 2, v98.Frostbolt) and (v107 >= (4 - 1))) or (v14:PrevGCDP(440 - (397 + 42), v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (804 - (24 + 776))) and v14:BuffDown(v98.FingersofFrostBuff)))) or ((7345 - 2577) <= (1631 - (222 + 563)))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((7398 - 4040) <= (1023 + 397))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (190 - (23 + 167))) and (v107 == (1802 - (690 + 1108))) and v14:BuffUp(v98.FingersofFrostBuff)) or ((1350 + 2389) <= (2479 + 526))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((2507 - (40 + 808)) >= (352 + 1782))) then
						return "ice_lance single 6";
					end
				end
				if ((v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (3 - 2))) or ((3116 + 144) < (1246 + 1109))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((367 + 302) == (4794 - (47 + 524)))) then
						return "ray_of_frost single 8";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (8 - 5)) or ((2529 - 837) < (1340 - 752))) then
				if ((v89 and ((v92 and v34) or not v92)) or ((6523 - (1165 + 561)) < (109 + 3542))) then
					if (v98.BagofTricks:IsCastable() or ((12936 - 8759) > (1851 + 2999))) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((879 - (341 + 138)) > (300 + 811))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((6296 - 3245) > (1331 - (89 + 237))) and v98.Frostbolt:IsCastable() and v41) then
					if (((11880 - 8187) <= (9225 - 4843)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((4163 - (581 + 300)) > (5320 - (855 + 365)))) then
					local v203 = 0 - 0;
					while true do
						if ((v203 == (0 + 0)) or ((4815 - (1030 + 205)) < (2670 + 174))) then
							v31 = v123();
							if (((83 + 6) < (4776 - (156 + 130))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v138 == (2 - 1)) or ((8398 - 3415) < (3702 - 1894))) then
				if (((1009 + 2820) > (2198 + 1571)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (74 - (10 + 59))) and ((v98.Flurry:Charges() >= (1 + 0)) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) then
					if (((2648 - (671 + 492)) <= (2312 + 592)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if (((5484 - (369 + 846)) == (1131 + 3138)) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 + 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1947 - (1036 + 909))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (((308 + 79) <= (4670 - 1888)) and v24(v100.FrozenOrbCast, not v15:IsInRange(243 - (11 + 192)))) then
						return "frozen_orb single 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (6 + 4)) and (v98.FrozenOrb:CooldownRemains() > (185 - (135 + 40))) and (v106 == (0 - 0)) and (v102 >= (2 + 1))) or ((4183 - 2284) <= (1373 - 456))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(184 - (50 + 126))) or ((12006 - 7694) <= (194 + 682))) then
						return "cone_of_cold single 14";
					end
				end
				if (((3645 - (1233 + 180)) <= (3565 - (522 + 447))) and v98.Blizzard:IsCastable() and v38 and (v102 >= (1423 - (107 + 1314))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (2 + 1)))) then
					if (((6383 - 4288) < (1566 + 2120)) and v24(v100.BlizzardCursor, not v15:IsInRange(79 - 39))) then
						return "blizzard single 16";
					end
				end
				v138 = 7 - 5;
			end
		end
	end
	local function v127()
		local v139 = 1910 - (716 + 1194);
		while true do
			if ((v139 == (1 + 6)) or ((171 + 1424) >= (4977 - (74 + 429)))) then
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v139 == (1 - 0)) or ((2290 + 2329) < (6596 - 3714))) then
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v139 = 2 + 0;
			end
			if ((v139 == (12 - 8)) or ((726 - 432) >= (5264 - (279 + 154)))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v139 = 783 - (454 + 324);
			end
			if (((1597 + 432) <= (3101 - (12 + 5))) and ((0 + 0) == v139)) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v139 = 2 - 1;
			end
			if ((v139 == (3 + 3)) or ((3130 - (277 + 816)) == (10340 - 7920))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (1183 - (1058 + 125));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (975 - (815 + 160));
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v139 = 16 - 9;
			end
			if (((1064 + 3394) > (11411 - 7507)) and (v139 == (1903 - (41 + 1857)))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (1893 - (1222 + 671));
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v139 = 1188 - (229 + 953);
			end
			if (((2210 - (1111 + 663)) >= (1702 - (874 + 705))) and (v139 == (1 + 2))) then
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v139 = 3 + 1;
			end
			if (((1039 - 539) < (52 + 1764)) and ((681 - (642 + 37)) == v139)) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v139 = 1 + 2;
			end
		end
	end
	local function v128()
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
		v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v86 = EpicSettings.Settings['healingPotionHP'] or (454 - (233 + 221));
		v88 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v129()
		v127();
		v128();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((8264 - 4690) == (3146 + 428)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v104 = v15:GetEnemiesInSplashRange(1546 - (718 + 823));
		v105 = v14:GetEnemiesInRange(26 + 14);
		if (((1026 - (266 + 539)) < (1104 - 714)) and v33) then
			v102 = v30(v15:GetEnemiesInSplashRangeCount(1230 - (636 + 589)), #v105);
			v103 = v30(v15:GetEnemiesInSplashRangeCount(11 - 6), #v105);
		else
			v102 = 1 - 0;
			v103 = 1 + 0;
		end
		if (not v14:AffectingCombat() or ((804 + 1409) <= (2436 - (657 + 358)))) then
			if (((8096 - 5038) < (11072 - 6212)) and v98.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
				if (v24(v98.ArcaneIntellect) or ((2483 - (1151 + 36)) >= (4294 + 152))) then
					return "arcane_intellect";
				end
			end
		end
		if (v112.TargetIsValid() or v14:AffectingCombat() or ((367 + 1026) > (13405 - 8916))) then
			v109 = v10.BossFightRemains(nil, true);
			v110 = v109;
			if ((v110 == (12943 - (1552 + 280))) or ((5258 - (64 + 770)) < (19 + 8))) then
				v110 = v10.FightRemains(v105, false);
			end
			v106 = v15:DebuffStack(v98.WintersChillDebuff);
			v107 = v14:BuffStackP(v98.IciclesBuff);
			v111 = v14:GCD();
		end
		if (v112.TargetIsValid() or ((4532 - 2535) > (678 + 3137))) then
			local v161 = 1243 - (157 + 1086);
			while true do
				if (((6935 - 3470) > (8378 - 6465)) and (v161 == (0 - 0))) then
					if (((999 - 266) < (2638 - (599 + 220))) and v77 and v35 and v98.RemoveCurse:IsAvailable()) then
						if (v16 or ((8751 - 4356) == (6686 - (1813 + 118)))) then
							local v209 = 0 + 0;
							while true do
								if ((v209 == (1217 - (841 + 376))) or ((5314 - 1521) < (551 + 1818))) then
									v31 = v119();
									if (v31 or ((11147 - 7063) == (1124 - (464 + 395)))) then
										return v31;
									end
									break;
								end
							end
						end
						if (((11184 - 6826) == (2093 + 2265)) and v17 and v17:Exists() and v17:IsAPlayer() and v112.UnitHasCurseDebuff(v17)) then
							if (v98.RemoveCurse:IsReady() or ((3975 - (467 + 370)) < (2051 - 1058))) then
								if (((2445 + 885) > (7963 - 5640)) and v24(v100.RemoveCurseMouseover)) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if ((not v14:AffectingCombat() and v32) or ((566 + 3060) == (9280 - 5291))) then
						local v204 = 520 - (150 + 370);
						while true do
							if ((v204 == (1282 - (74 + 1208))) or ((2252 - 1336) == (12667 - 9996))) then
								v31 = v121();
								if (((194 + 78) == (662 - (14 + 376))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v161 = 1 - 0;
				end
				if (((2750 + 1499) <= (4251 + 588)) and (v161 == (3 + 0))) then
					if (((8136 - 5359) < (2408 + 792)) and v79) then
						local v205 = 78 - (23 + 55);
						while true do
							if (((225 - 130) < (1306 + 651)) and (v205 == (0 + 0))) then
								v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 46 - 16, true);
								if (((260 + 566) < (2618 - (652 + 249))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if (((3816 - 2390) >= (2973 - (708 + 1160))) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
						if (((7475 - 4721) <= (6160 - 2781)) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					v161 = 31 - (10 + 17);
				end
				if ((v161 == (1 + 3)) or ((5659 - (1400 + 332)) == (2710 - 1297))) then
					if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((3062 - (242 + 1666)) <= (338 + 450))) then
						local v206 = 0 + 0;
						while true do
							if ((v206 == (3 + 0)) or ((2583 - (850 + 90)) > (5917 - 2538))) then
								if ((v14:IsMoving() and v94) or ((4193 - (360 + 1030)) > (4026 + 523))) then
									v31 = v123();
									if (v31 or ((620 - 400) >= (4157 - 1135))) then
										return v31;
									end
								end
								break;
							end
							if (((4483 - (909 + 752)) == (4045 - (109 + 1114))) and ((0 - 0) == v206)) then
								if (v34 or ((414 + 647) == (2099 - (6 + 236)))) then
									local v211 = 0 + 0;
									while true do
										if (((2222 + 538) > (3216 - 1852)) and (v211 == (0 - 0))) then
											v31 = v122();
											if (v31 or ((6035 - (1076 + 57)) <= (592 + 3003))) then
												return v31;
											end
											break;
										end
									end
								end
								if ((v33 and (((v103 >= (696 - (579 + 110))) and not v14:HasTier(3 + 27, 2 + 0)) or ((v103 >= (2 + 1)) and v98.IceCaller:IsAvailable()))) or ((4259 - (174 + 233)) == (818 - 525))) then
									v31 = v124();
									if (v31 or ((2735 - 1176) == (2041 + 2547))) then
										return v31;
									end
									if (v24(v98.Pool) or ((5658 - (663 + 511)) == (703 + 85))) then
										return "pool for Aoe()";
									end
								end
								v206 = 1 + 0;
							end
							if (((14083 - 9515) >= (2366 + 1541)) and (v206 == (2 - 1))) then
								if (((3016 - 1770) < (1656 + 1814)) and v33 and (v103 == (3 - 1))) then
									v31 = v125();
									if (((2900 + 1168) >= (89 + 883)) and v31) then
										return v31;
									end
									if (((1215 - (478 + 244)) < (4410 - (440 + 77))) and v24(v98.Pool)) then
										return "pool for Cleave()";
									end
								end
								v31 = v126();
								v206 = 1 + 1;
							end
							if ((v206 == (7 - 5)) or ((3029 - (655 + 901)) >= (618 + 2714))) then
								if (v31 or ((3102 + 949) <= (782 + 375))) then
									return v31;
								end
								if (((2433 - 1829) < (4326 - (695 + 750))) and v24(v98.Pool)) then
									return "pool for ST()";
								end
								v206 = 9 - 6;
							end
						end
					end
					break;
				end
				if ((v161 == (2 - 0)) or ((3619 - 2719) == (3728 - (285 + 66)))) then
					if (((10393 - 5934) > (1901 - (682 + 628))) and (v14:AffectingCombat() or v77)) then
						local v207 = 0 + 0;
						local v208;
						while true do
							if (((3697 - (176 + 123)) >= (1002 + 1393)) and (v207 == (1 + 0))) then
								if (v31 or ((2452 - (239 + 30)) >= (768 + 2056))) then
									return v31;
								end
								break;
							end
							if (((1861 + 75) == (3426 - 1490)) and (v207 == (0 - 0))) then
								v208 = v77 and v98.RemoveCurse:IsReady() and v35;
								v31 = v112.FocusUnit(v208, v100, 335 - (306 + 9), nil, 69 - 49);
								v207 = 1 + 0;
							end
						end
					end
					if (v78 or ((2965 + 1867) < (2077 + 2236))) then
						if (((11690 - 7602) > (5249 - (1140 + 235))) and v97) then
							local v210 = 0 + 0;
							while true do
								if (((3973 + 359) == (1112 + 3220)) and (v210 == (52 - (33 + 19)))) then
									v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 11 + 19);
									if (((11985 - 7986) >= (1278 + 1622)) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					v161 = 5 - 2;
				end
				if (((1 + 0) == v161) or ((3214 - (586 + 103)) > (371 + 3693))) then
					v31 = v118();
					if (((13456 - 9085) == (5859 - (1309 + 179))) and v31) then
						return v31;
					end
					v161 = 2 - 0;
				end
			end
		end
	end
	local function v130()
		v113();
		v98.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(28 + 36, v129, v130);
end;
return v0["Epix_Mage_Frost.lua"]();

