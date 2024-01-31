local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2115 + 2710) < (14371 - 9528)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((7130 - 3253) >= (3000 + 1537))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 + 0)) or ((3624 + 691) < (1689 + 37))) then
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
	local v106 = 433 - (153 + 280);
	local v107 = 0 - 0;
	local v108 = 14 + 1;
	local v109 = 4388 + 6723;
	local v110 = 5815 + 5296;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((3339 + 340) < (453 + 172))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(129005 - 44284);
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(141287 + 87310);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(229021 - (89 + 578));
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(163303 + 65295);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(475254 - 246654);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v109 = 12160 - (572 + 477);
		v110 = 1499 + 9612;
		v106 = 0 + 0;
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		local v133 = 0 + 0;
		while true do
			if ((v133 == (86 - (84 + 2))) or ((7622 - 2997) < (456 + 176))) then
				if ((v132 == nil) or ((925 - (497 + 345)) > (46 + 1734))) then
					v132 = v15;
				end
				return not v132:IsInBossList() or (v132:Level() < (13 + 60));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v134)
		return (v134:DebuffStack(v98.WintersChillDebuff));
	end
	local function v117(v135)
		return (v135:DebuffDown(v98.WintersChillDebuff));
	end
	local function v118()
		local v136 = 1333 - (605 + 728);
		while true do
			if (((390 + 156) <= (2393 - 1316)) and (v136 == (1 + 2))) then
				if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((3682 - 2686) > (3878 + 423))) then
					if (((11276 - 7206) > (519 + 168)) and v24(v98.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) or ((1145 - (457 + 32)) >= (1413 + 1917))) then
					if (v24(v100.Healthstone) or ((3894 - (832 + 570)) <= (316 + 19))) then
						return "healthstone defensive";
					end
				end
				v136 = 2 + 2;
			end
			if (((15294 - 10972) >= (1235 + 1327)) and (v136 == (798 - (588 + 208)))) then
				if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((9802 - 6165) >= (5570 - (884 + 916)))) then
					if (v24(v98.MirrorImage) or ((4980 - 2601) > (2655 + 1923))) then
						return "mirror_image defensive 5";
					end
				end
				if ((v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((1136 - (232 + 421)) > (2632 - (1569 + 320)))) then
					if (((603 + 1851) > (110 + 468)) and v24(v98.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v136 = 9 - 6;
			end
			if (((1535 - (316 + 289)) < (11669 - 7211)) and (v136 == (1 + 3))) then
				if (((2115 - (666 + 787)) <= (1397 - (360 + 65))) and v84 and (v14:HealthPercentage() <= v86)) then
					local v206 = 0 + 0;
					while true do
						if (((4624 - (79 + 175)) == (6890 - 2520)) and (v206 == (0 + 0))) then
							if ((v88 == "Refreshing Healing Potion") or ((14596 - 9834) <= (1657 - 796))) then
								if (v99.RefreshingHealingPotion:IsReady() or ((2311 - (503 + 396)) == (4445 - (92 + 89)))) then
									if (v24(v100.RefreshingHealingPotion) or ((6145 - 2977) < (1105 + 1048))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((2946 + 2030) < (5216 - 3884))) then
								if (((633 + 3995) == (10552 - 5924)) and v99.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or ((48 + 6) == (189 + 206))) then
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
			if (((249 - 167) == (11 + 71)) and ((1 - 0) == v136)) then
				if ((v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((1825 - (485 + 759)) < (652 - 370))) then
					if (v24(v98.IceColdAbility) or ((5798 - (442 + 747)) < (3630 - (832 + 303)))) then
						return "ice_cold defensive 3";
					end
				end
				if (((2098 - (88 + 858)) == (352 + 800)) and v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
					if (((1570 + 326) <= (141 + 3281)) and v24(v98.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v136 = 791 - (766 + 23);
			end
			if ((v136 == (0 - 0)) or ((1353 - 363) > (4268 - 2648))) then
				if ((v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((2976 - 2099) > (5768 - (1036 + 37)))) then
					if (((1908 + 783) >= (3604 - 1753)) and v24(v98.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2 + 0)) or ((4465 - (641 + 839)) >= (5769 - (910 + 3)))) then
					if (((10900 - 6624) >= (2879 - (1466 + 218))) and v24(v98.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local v119 = 1148 - (556 + 592);
	local function v120()
		if (((1150 + 2082) <= (5498 - (329 + 479))) and v98.RemoveCurse:IsReady() and v112.DispellableFriendlyUnit(874 - (174 + 680))) then
			local v185 = 0 - 0;
			while true do
				if ((v185 == (0 - 0)) or ((640 + 256) >= (3885 - (396 + 343)))) then
					if (((271 + 2790) >= (4435 - (29 + 1448))) and (v119 == (1389 - (135 + 1254)))) then
						v119 = GetTime();
					end
					if (((12005 - 8818) >= (3006 - 2362)) and v112.Wait(334 + 166, v119)) then
						local v213 = 1527 - (389 + 1138);
						while true do
							if (((1218 - (102 + 472)) <= (665 + 39)) and (v213 == (0 + 0))) then
								if (((894 + 64) > (2492 - (320 + 1225))) and v24(v100.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v119 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		v31 = v112.HandleTopTrinket(v101, v34, 25 + 15, nil);
		if (((5956 - (157 + 1307)) >= (4513 - (821 + 1038))) and v31) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 99 - 59, nil);
		if (((377 + 3065) >= (2669 - 1166)) and v31) then
			return v31;
		end
	end
	local function v122()
		if (v112.TargetIsValid() or ((1180 + 1990) <= (3628 - 2164))) then
			if ((v98.MirrorImage:IsCastable() and v68 and v96) or ((5823 - (834 + 192)) == (279 + 4109))) then
				if (((142 + 409) <= (15 + 666)) and v24(v98.MirrorImage)) then
					return "mirror_image precombat 2";
				end
			end
			if (((5075 - 1798) > (711 - (300 + 4))) and v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
				if (((1254 + 3441) >= (3704 - 2289)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v123()
		local v137 = 362 - (112 + 250);
		local v138;
		while true do
			if ((v137 == (1 + 1)) or ((8046 - 4834) <= (541 + 403))) then
				if ((v83 < v110) or ((1602 + 1494) <= (1345 + 453))) then
					if (((1754 + 1783) == (2628 + 909)) and v90 and ((v34 and v91) or not v91)) then
						local v214 = 1414 - (1001 + 413);
						while true do
							if (((8556 - 4719) >= (2452 - (244 + 638))) and ((693 - (627 + 66)) == v214)) then
								v31 = v121();
								if (v31 or ((8789 - 5839) == (4414 - (512 + 90)))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((6629 - (1665 + 241)) >= (3035 - (373 + 344))) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
					local v207 = 0 + 0;
					while true do
						if (((0 + 0) == v207) or ((5346 - 3319) > (4825 - 1973))) then
							if (v98.BloodFury:IsCastable() or ((2235 - (35 + 1064)) > (3142 + 1175))) then
								if (((10158 - 5410) == (19 + 4729)) and v24(v98.BloodFury)) then
									return "blood_fury cd 10";
								end
							end
							if (((4972 - (298 + 938)) <= (5999 - (233 + 1026))) and v98.Berserking:IsCastable()) then
								if (v24(v98.Berserking) or ((5056 - (636 + 1030)) <= (1565 + 1495))) then
									return "berserking cd 12";
								end
							end
							v207 = 1 + 0;
						end
						if (((1 + 1) == v207) or ((68 + 931) > (2914 - (55 + 166)))) then
							if (((90 + 373) < (61 + 540)) and v98.AncestralCall:IsCastable()) then
								if (v24(v98.AncestralCall) or ((8336 - 6153) < (984 - (36 + 261)))) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((7955 - 3406) == (5917 - (34 + 1334))) and (v207 == (1 + 0))) then
							if (((3631 + 1041) == (5955 - (1035 + 248))) and v98.LightsJudgment:IsCastable()) then
								if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((3689 - (20 + 1)) < (206 + 189))) then
									return "lights_judgment cd 14";
								end
							end
							if (v98.Fireblood:IsCastable() or ((4485 - (134 + 185)) == (1588 - (549 + 584)))) then
								if (v24(v98.Fireblood) or ((5134 - (314 + 371)) == (9141 - 6478))) then
									return "fireblood cd 16";
								end
							end
							v207 = 970 - (478 + 490);
						end
					end
				end
				break;
			end
			if (((1 + 0) == v137) or ((5449 - (786 + 386)) < (9681 - 6692))) then
				if (v138 or ((2249 - (1055 + 324)) >= (5489 - (1093 + 247)))) then
					return v138;
				end
				if (((1966 + 246) < (335 + 2848)) and v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
					if (((18445 - 13799) > (10153 - 7161)) and v24(v98.IcyVeins)) then
						return "icy_veins cd 6";
					end
				end
				v137 = 5 - 3;
			end
			if (((3603 - 2169) < (1105 + 2001)) and ((0 - 0) == v137)) then
				if (((2709 - 1923) < (2280 + 743)) and v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(2 - 1, v98.IcyVeins)) then
					if (v24(v98.TimeWarp, not v15:IsInRange(728 - (364 + 324))) or ((6694 - 4252) < (177 - 103))) then
						return "time_warp cd 2";
					end
				end
				v138 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v137 = 1 + 0;
			end
		end
	end
	local function v124()
		if (((18975 - 14440) == (7262 - 2727)) and v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) then
			if (v24(v98.IceFloes) or ((9138 - 6129) <= (3373 - (1249 + 19)))) then
				return "ice_floes movement";
			end
		end
		if (((1652 + 178) < (14281 - 10612)) and v98.IceNova:IsCastable() and v48) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((2516 - (686 + 400)) >= (2834 + 778))) then
				return "ice_nova movement";
			end
		end
		if (((2912 - (73 + 156)) >= (12 + 2448)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (841 - (721 + 90))) and (v103 >= (1 + 1))) then
			if (v24(v98.ArcaneExplosion, not v15:IsInRange(25 - 17)) or ((2274 - (224 + 246)) >= (5305 - 2030))) then
				return "arcane_explosion movement";
			end
		end
		if ((v98.FireBlast:IsCastable() and v40) or ((2608 - 1191) > (659 + 2970))) then
			if (((115 + 4680) > (296 + 106)) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
				return "fire_blast movement";
			end
		end
		if (((9568 - 4755) > (11863 - 8298)) and v98.IceLance:IsCastable() and v47) then
			if (((4425 - (203 + 310)) == (5905 - (1238 + 755))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance movement";
			end
		end
	end
	local function v125()
		local v139 = 0 + 0;
		while true do
			if (((4355 - (709 + 825)) <= (8889 - 4065)) and (v139 == (5 - 1))) then
				if (((2602 - (196 + 668)) <= (8666 - 6471)) and v98.Frostbolt:IsCastable() and v41) then
					if (((84 - 43) <= (3851 - (171 + 662))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((2238 - (4 + 89)) <= (14384 - 10280)) and v14:IsMoving() and v94) then
					local v208 = 0 + 0;
					while true do
						if (((11810 - 9121) < (1900 + 2945)) and (v208 == (1486 - (35 + 1451)))) then
							v31 = v124();
							if (v31 or ((3775 - (28 + 1425)) > (4615 - (941 + 1052)))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v139 == (2 + 0)) or ((6048 - (822 + 692)) == (2971 - 889))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((740 + 831) > (2164 - (45 + 252)))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(40 + 0), true) or ((914 + 1740) >= (7291 - 4295))) then
						return "shifting_power aoe 16";
					end
				end
				if (((4411 - (114 + 319)) > (3020 - 916)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (6 - 1)) and (v98.Blizzard:CooldownRemains() > v111)) then
					if (((1910 + 1085) > (2295 - 754)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((6807 - 3558) > (2916 - (556 + 1407))) and v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (1206 - (741 + 465))) and (v14:PrevGCDP(466 - (170 + 295), v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (1.8 + 0)))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((3007 + 266) > (11258 - 6685))) then
						return "flurry aoe 20";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and (v106 == (0 + 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) or ((2021 + 1130) < (728 + 556))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((3080 - (957 + 273)) == (409 + 1120))) then
						return "flurry aoe 21";
					end
				end
				v139 = 2 + 1;
			end
			if (((3128 - 2307) < (5594 - 3471)) and (v139 == (9 - 6))) then
				if (((4466 - 3564) < (4105 - (389 + 1391))) and v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) then
					if (((539 + 319) <= (309 + 2653)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v102 >= (8 - 4)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) or ((4897 - (783 + 168)) < (4322 - 3034))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((3189 + 53) == (878 - (309 + 2)))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v98.DragonsBreath:IsCastable() and v39 and (v103 >= (21 - 14))) or ((2059 - (1090 + 122)) >= (410 + 853))) then
					if (v24(v98.DragonsBreath, not v15:IsInRange(33 - 23)) or ((1542 + 711) == (2969 - (628 + 490)))) then
						return "dragons_breath aoe 26";
					end
				end
				if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (6 + 24)) and (v103 >= (16 - 9))) or ((9537 - 7450) > (3146 - (431 + 343)))) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(16 - 8)) or ((12859 - 8414) < (3278 + 871))) then
						return "arcane_explosion aoe 28";
					end
				end
				v139 = 1 + 3;
			end
			if ((v139 == (1695 - (556 + 1139))) or ((1833 - (6 + 9)) == (16 + 69))) then
				if (((323 + 307) < (2296 - (28 + 141))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1 + 0, v98.CometStorm) or (v14:PrevGCDP(1 - 0, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(6 + 2)) or ((3255 - (486 + 831)) == (6541 - 4027))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((14980 - 10725) >= (11 + 44)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(3 - 2, v98.GlacialSpike) or not v114())) then
					if (((4262 - (668 + 595)) > (1041 + 115)) and v24(v100.FrozenOrbCast, not v15:IsInRange(9 + 31))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((6408 - 4058) > (1445 - (23 + 267))) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1945 - (1129 + 815), v98.GlacialSpike) or not v114())) then
					if (((4416 - (371 + 16)) <= (6603 - (1326 + 424))) and v24(v100.BlizzardCursor, not v15:IsInRange(75 - 35))) then
						return "blizzard aoe 6";
					end
				end
				if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(3 - 2, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (143 - (88 + 30)))) or (v98.ConeofCold:CooldownRemains() > (791 - (720 + 51))))) or ((1147 - 631) > (5210 - (421 + 1355)))) then
					if (((6674 - 2628) >= (1490 + 1543)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				v139 = 1084 - (286 + 797);
			end
			if ((v139 == (3 - 2)) or ((4503 - 1784) <= (1886 - (397 + 42)))) then
				if ((v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 + 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(801 - (24 + 776), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or ((6368 - 2234) < (4711 - (222 + 563)))) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or ((360 - 196) >= (2006 + 779))) then
						return "freeze aoe 10";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(191 - (23 + 167), v98.Freeze) and (v14:PrevGCDP(1799 - (690 + 1108), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) or ((434 + 91) == (2957 - (40 + 808)))) then
					if (((6 + 27) == (126 - 93)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				if (((2919 + 135) <= (2125 + 1890)) and v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and ((v14:PrevGCDP(572 - (47 + 524), v98.GlacialSpike) and (v106 == (0 + 0))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (2 - 1))))) then
					if (((2797 - 926) < (7712 - 4330)) and v24(v98.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((3019 - (1165 + 561)) <= (65 + 2101)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) then
					if (v24(v98.ConeofCold, not v15:IsInRange(24 - 16)) or ((985 + 1594) < (602 - (341 + 138)))) then
						return "cone_of_cold aoe 14";
					end
				end
				v139 = 1 + 1;
			end
		end
	end
	local function v126()
		if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(1 - 0, v98.Flurry) or v14:PrevGCDP(327 - (89 + 237), v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((2721 - 1875) >= (4985 - 2617))) then
			if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((4893 - (581 + 300)) <= (4578 - (855 + 365)))) then
				return "comet_storm cleave 2";
			end
		end
		if (((3548 - 2054) <= (982 + 2023)) and v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1236 - (1030 + 205), v98.Frostbolt) and (v107 >= (3 + 0))) or v14:PrevGCDP(1 + 0, v98.GlacialSpike) or ((v107 >= (289 - (156 + 130))) and (v107 < (11 - 6)) and (v98.Flurry:ChargesFractional() == (2 - 0))))) then
			local v186 = 0 - 0;
			while true do
				if ((v186 == (0 + 0)) or ((1815 + 1296) == (2203 - (10 + 59)))) then
					if (((667 + 1688) == (11597 - 9242)) and v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry cleave 4";
					end
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((1751 - (671 + 492)) <= (344 + 88))) then
						return "flurry cleave 4";
					end
					break;
				end
			end
		end
		if (((6012 - (369 + 846)) >= (1032 + 2863)) and v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (0 + 0)) and (v107 == (1949 - (1036 + 909))) and v14:BuffUp(v98.FingersofFrostBuff)) then
			local v187 = 0 + 0;
			while true do
				if (((6004 - 2427) == (3780 - (11 + 192))) and (v187 == (0 + 0))) then
					if (((3969 - (135 + 40)) > (8947 - 5254)) and v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((769 + 506) == (9032 - 4932))) then
						return "ice_lance cleave 6";
					end
					break;
				end
			end
		end
		if ((v98.RayofFrost:IsCastable() and (v106 == (1 - 0)) and v49) or ((1767 - (50 + 126)) >= (9968 - 6388))) then
			if (((218 + 765) <= (3221 - (1233 + 180))) and v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
				return "ray_of_frost cleave 8";
			end
			if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((3119 - (522 + 447)) <= (2618 - (107 + 1314)))) then
				return "ray_of_frost cleave 8";
			end
		end
		if (((1749 + 2020) >= (3573 - 2400)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (3 + 2)) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) then
			if (((5875 - 4390) == (3395 - (716 + 1194))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 10";
			end
		end
		if ((v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1 + 1)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((356 + 2959) <= (3285 - (74 + 429)))) then
			if (v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb)) or ((1689 - 813) >= (1470 + 1494))) then
				return "frozen_orb cleave 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (22 - 12)) and (v98.FrozenOrb:CooldownRemains() > (8 + 2)) and (v106 == (0 - 0)) and (v103 >= (7 - 4))) or ((2665 - (279 + 154)) > (3275 - (454 + 324)))) then
			if (v24(v98.ConeofCold) or ((1661 + 449) <= (349 - (12 + 5)))) then
				return "cone_of_cold cleave 14";
			end
		end
		if (((1988 + 1698) > (8082 - 4910)) and v98.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (1096 - (277 + 816))))) then
			if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((19117 - 14643) < (2003 - (1058 + 125)))) then
				return "blizzard cleave 16";
			end
		end
		if (((803 + 3476) >= (3857 - (815 + 160))) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (42 - 32)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (23 - 13))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (3 + 7)))) or (v98.IcyVeins:CooldownRemains() < (58 - 38)))) then
			if (v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true) or ((3927 - (41 + 1857)) >= (5414 - (1222 + 671)))) then
				return "shifting_power cleave 18";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (12 - 7))) or ((2927 - 890) >= (5824 - (229 + 953)))) then
			if (((3494 - (1111 + 663)) < (6037 - (874 + 705))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
				return "glacial_spike cleave 20";
			end
		end
		if ((v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike)) or (v106 > (0 + 0)))) or ((905 - 469) > (86 + 2935))) then
			local v188 = 679 - (642 + 37);
			while true do
				if (((163 + 550) <= (136 + 711)) and (v188 == (0 - 0))) then
					if (((2608 - (233 + 221)) <= (9321 - 5290)) and v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (((4063 + 552) == (6156 - (718 + 823))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if ((v98.IceNova:IsCastable() and v48 and (v103 >= (3 + 1))) or ((4595 - (266 + 539)) == (1415 - 915))) then
			if (((1314 - (636 + 589)) < (524 - 303)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova cleave 24";
			end
		end
		if (((4236 - 2182) >= (1127 + 294)) and v98.Frostbolt:IsCastable() and v41) then
			if (((252 + 440) < (4073 - (657 + 358))) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt cleave 26";
			end
		end
		if ((v14:IsMoving() and v94) or ((8615 - 5361) == (3770 - 2115))) then
			v31 = v124();
			if (v31 or ((2483 - (1151 + 36)) == (4742 + 168))) then
				return v31;
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if (((10058 - 6690) == (5200 - (1552 + 280))) and (v140 == (834 - (64 + 770)))) then
				if (((1795 + 848) < (8660 - 4845)) and v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(1244 - (157 + 1086), v98.ConeofCold))) then
					if (((3828 - 1915) > (2159 - 1666)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((7293 - 2538) > (4678 - 1250)) and v98.Flurry:IsCastable() and (v106 == (819 - (599 + 220))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1 - 0, v98.Frostbolt) and (v107 >= (1934 - (1813 + 118)))) or (v14:PrevGCDP(1 + 0, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1218 - (841 + 376), v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (5 - 1)) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (((321 + 1060) <= (6466 - 4097)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (859 - (464 + 395))) and (v107 == (10 - 6)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((2326 + 2517) == (4921 - (467 + 370)))) then
					if (((9648 - 4979) > (267 + 96)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				if ((v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (3 - 2))) or ((293 + 1584) >= (7300 - 4162))) then
					if (((5262 - (150 + 370)) >= (4908 - (74 + 1208))) and v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				v140 = 2 - 1;
			end
			if (((4 - 3) == v140) or ((3231 + 1309) == (1306 - (14 + 376)))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (8 - 3)) and ((v98.Flurry:Charges() >= (1 + 0)) or ((v106 > (0 + 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or ((1103 + 53) > (12731 - 8386))) then
					if (((1683 + 554) < (4327 - (23 + 55))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 - 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (2 + 0)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((2410 + 273) < (35 - 12))) then
					if (((220 + 477) <= (1727 - (652 + 249))) and v24(v100.FrozenOrbCast, not v15:IsInRange(107 - 67))) then
						return "frozen_orb single 12";
					end
				end
				if (((2973 - (708 + 1160)) <= (3192 - 2016)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (18 - 8)) and (v98.FrozenOrb:CooldownRemains() > (37 - (10 + 17))) and (v106 == (0 + 0)) and (v102 >= (1735 - (1400 + 332)))) then
					if (((6480 - 3101) <= (5720 - (242 + 1666))) and v24(v98.ConeofCold, not v15:IsInRange(4 + 4))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (1 + 1)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (3 + 0)))) or ((1728 - (850 + 90)) >= (2829 - 1213))) then
					if (((3244 - (360 + 1030)) <= (2991 + 388)) and v24(v100.BlizzardCursor, not v15:IsInRange(112 - 72))) then
						return "blizzard single 16";
					end
				end
				v140 = 2 - 0;
			end
			if (((6210 - (909 + 752)) == (5772 - (109 + 1114))) and (v140 == (5 - 2))) then
				if ((v89 and ((v92 and v34) or not v92)) or ((1177 + 1845) >= (3266 - (6 + 236)))) then
					if (((3037 + 1783) > (1770 + 428)) and v98.BagofTricks:IsCastable()) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((2501 - 1440) >= (8542 - 3651))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((2497 - (1076 + 57)) <= (736 + 3737)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((4284 - (579 + 110)) <= (1 + 2))) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v94) or ((4131 + 541) == (2045 + 1807))) then
					local v209 = 407 - (174 + 233);
					while true do
						if (((4354 - 2795) == (2735 - 1176)) and ((0 + 0) == v209)) then
							v31 = v124();
							if (v31 or ((2926 - (663 + 511)) <= (703 + 85))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1 + 1) == v140) or ((12044 - 8137) == (108 + 69))) then
				if (((8169 - 4699) > (1343 - 788)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (19 - 9)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (8 + 2))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (1 + 9)))) or (v98.IcyVeins:CooldownRemains() < (742 - (478 + 244))))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(557 - (440 + 77))) or ((442 + 530) == (2360 - 1715))) then
						return "shifting_power single 18";
					end
				end
				if (((4738 - (655 + 901)) >= (393 + 1722)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (4 + 1))) then
					if (((2629 + 1264) < (17842 - 13413)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1446 - (695 + 750), v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((9789 - 6922) < (2939 - 1034))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((7223 - 5427) >= (4402 - (285 + 66)))) then
						return "ice_lance single 22";
					end
				end
				if (((3773 - 2154) <= (5066 - (682 + 628))) and v98.IceNova:IsCastable() and v48 and (v103 >= (1 + 3))) then
					if (((903 - (176 + 123)) == (253 + 351)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v140 = 3 + 0;
			end
		end
	end
	local function v128()
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
		v69 = EpicSettings.Settings['alterTimeHP'] or (269 - (239 + 30));
		v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
		v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v74 = EpicSettings.Settings['mirrorImageHP'] or (315 - (306 + 9));
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v93 = EpicSettings.Settings['useSpellStealTarget'];
		v94 = EpicSettings.Settings['useSpellsWhileMoving'];
		v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v96 = EpicSettings.Settings['mirrorImageBeforePull'];
		v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v129()
		local v179 = 0 + 0;
		while true do
			if ((v179 == (2 + 0)) or ((2159 + 2325) == (2573 - 1673))) then
				v91 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['useHealingPotion'];
				v179 = 1378 - (1140 + 235);
			end
			if ((v179 == (0 + 0)) or ((4089 + 370) <= (286 + 827))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (52 - (33 + 19));
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v179 = 1 + 0;
			end
			if (((10885 - 7253) > (1497 + 1901)) and (v179 == (5 - 2))) then
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (689 - (586 + 103));
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v179 = 1 + 3;
			end
			if (((12566 - 8484) <= (6405 - (1309 + 179))) and ((1 - 0) == v179)) then
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v90 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v179 = 1 + 1;
			end
			if (((12976 - 8144) >= (1047 + 339)) and (v179 == (7 - 3))) then
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v130()
		local v180 = 0 - 0;
		while true do
			if (((746 - (295 + 314)) == (336 - 199)) and ((1963 - (1300 + 662)) == v180)) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v180 = 6 - 4;
			end
			if (((1758 - (1178 + 577)) == v180) or ((816 + 754) >= (12806 - 8474))) then
				if (v33 or ((5469 - (851 + 554)) <= (1609 + 210))) then
					local v210 = 0 - 0;
					while true do
						if ((v210 == (0 - 0)) or ((5288 - (115 + 187)) < (1206 + 368))) then
							v102 = v30(v15:GetEnemiesInSplashRangeCount(5 + 0), #v105);
							v103 = v30(v15:GetEnemiesInSplashRangeCount(19 - 14), #v105);
							break;
						end
					end
				else
					v102 = 1162 - (160 + 1001);
					v103 = 1 + 0;
				end
				if (((3054 + 1372) > (351 - 179)) and not v14:AffectingCombat()) then
					if (((944 - (237 + 121)) > (1352 - (525 + 372))) and v98.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
						if (((1565 - 739) == (2713 - 1887)) and v24(v98.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v112.TargetIsValid() or v14:AffectingCombat() or ((4161 - (96 + 46)) > (5218 - (643 + 134)))) then
					local v211 = 0 + 0;
					while true do
						if (((4836 - 2819) < (15819 - 11558)) and (v211 == (1 + 0))) then
							if (((9255 - 4539) > (163 - 83)) and (v110 == (11830 - (316 + 403)))) then
								v110 = v10.FightRemains(v105, false);
							end
							v106 = v15:DebuffStack(v98.WintersChillDebuff);
							v211 = 2 + 0;
						end
						if (((5 - 3) == v211) or ((1268 + 2239) == (8239 - 4967))) then
							v107 = v14:BuffStackP(v98.IciclesBuff);
							v111 = v14:GCD();
							break;
						end
						if ((v211 == (0 + 0)) or ((283 + 593) >= (10654 - 7579))) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v211 = 4 - 3;
						end
					end
				end
				v180 = 7 - 3;
			end
			if (((250 + 4102) > (5027 - 2473)) and (v180 == (0 + 0))) then
				v128();
				v129();
				v32 = EpicSettings.Toggles['ooc'];
				v180 = 2 - 1;
			end
			if ((v180 == (19 - (12 + 5))) or ((17113 - 12707) < (8625 - 4582))) then
				if (v14:IsDeadOrGhost() or ((4015 - 2126) >= (8389 - 5006))) then
					return v31;
				end
				v104 = v15:GetEnemiesInSplashRange(2 + 3);
				v105 = v14:GetEnemiesInRange(2013 - (1656 + 317));
				v180 = 3 + 0;
			end
			if (((1517 + 375) <= (7269 - 4535)) and (v180 == (19 - 15))) then
				if (((2277 - (5 + 349)) < (10535 - 8317)) and v112.TargetIsValid()) then
					local v212 = 1271 - (266 + 1005);
					while true do
						if (((1432 + 741) > (1293 - 914)) and (v212 == (4 - 0))) then
							if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((4287 - (561 + 1135)) == (4441 - 1032))) then
								local v215 = 0 - 0;
								while true do
									if (((5580 - (507 + 559)) > (8340 - 5016)) and (v215 == (3 - 2))) then
										if ((v33 and (v103 == (390 - (212 + 176)))) or ((1113 - (250 + 655)) >= (13165 - 8337))) then
											local v221 = 0 - 0;
											while true do
												if ((v221 == (0 - 0)) or ((3539 - (1869 + 87)) > (12371 - 8804))) then
													v31 = v126();
													if (v31 or ((3214 - (484 + 1417)) == (1701 - 907))) then
														return v31;
													end
													v221 = 1 - 0;
												end
												if (((3947 - (48 + 725)) > (4740 - 1838)) and (v221 == (2 - 1))) then
													if (((2395 + 1725) <= (11384 - 7124)) and v24(v98.Pool)) then
														return "pool for Cleave()";
													end
													break;
												end
											end
										end
										v31 = v127();
										v215 = 1 + 1;
									end
									if ((v215 == (1 + 1)) or ((1736 - (152 + 701)) > (6089 - (430 + 881)))) then
										if (v31 or ((1387 + 2233) >= (5786 - (557 + 338)))) then
											return v31;
										end
										if (((1259 + 2999) > (2640 - 1703)) and v24(v98.Pool)) then
											return "pool for ST()";
										end
										v215 = 10 - 7;
									end
									if ((v215 == (7 - 4)) or ((10493 - 5624) < (1707 - (499 + 302)))) then
										if ((v14:IsMoving() and v94) or ((2091 - (39 + 827)) > (11671 - 7443))) then
											local v222 = 0 - 0;
											while true do
												if (((13218 - 9890) > (3435 - 1197)) and (v222 == (0 + 0))) then
													v31 = v124();
													if (((11236 - 7397) > (225 + 1180)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v215 == (0 - 0)) or ((1397 - (103 + 1)) <= (1061 - (475 + 79)))) then
										if (v34 or ((6260 - 3364) < (2576 - 1771))) then
											local v223 = 0 + 0;
											while true do
												if (((2039 + 277) == (3819 - (1395 + 108))) and (v223 == (0 - 0))) then
													v31 = v123();
													if (v31 or ((3774 - (7 + 1197)) == (669 + 864))) then
														return v31;
													end
													break;
												end
											end
										end
										if ((v33 and (((v103 >= (3 + 4)) and not v14:HasTier(349 - (27 + 292), 5 - 3)) or ((v103 >= (3 - 0)) and v98.IceCaller:IsAvailable()))) or ((3703 - 2820) == (2879 - 1419))) then
											local v224 = 0 - 0;
											while true do
												if ((v224 == (140 - (43 + 96))) or ((18841 - 14222) <= (2258 - 1259))) then
													if (v24(v98.Pool) or ((2830 + 580) > (1163 + 2953))) then
														return "pool for Aoe()";
													end
													break;
												end
												if ((v224 == (0 - 0)) or ((347 + 556) >= (5732 - 2673))) then
													v31 = v125();
													if (v31 or ((1252 + 2724) < (210 + 2647))) then
														return v31;
													end
													v224 = 1752 - (1414 + 337);
												end
											end
										end
										v215 = 1941 - (1642 + 298);
									end
								end
							end
							break;
						end
						if (((12851 - 7921) > (6636 - 4329)) and (v212 == (5 - 3))) then
							if (v14:AffectingCombat() or v77 or ((1332 + 2714) < (1005 + 286))) then
								local v216 = 972 - (357 + 615);
								local v217;
								while true do
									if ((v216 == (1 + 0)) or ((10406 - 6165) == (3038 + 507))) then
										if (v31 or ((8674 - 4626) > (3385 + 847))) then
											return v31;
										end
										break;
									end
									if ((v216 == (0 + 0)) or ((1100 + 650) >= (4774 - (384 + 917)))) then
										v217 = v77 and v98.RemoveCurse:IsReady() and v35;
										v31 = v112.FocusUnit(v217, v100, 717 - (128 + 569), nil, 1563 - (1407 + 136));
										v216 = 1888 - (687 + 1200);
									end
								end
							end
							if (((4876 - (556 + 1154)) == (11138 - 7972)) and v78) then
								if (((1858 - (9 + 86)) < (4145 - (275 + 146))) and v97) then
									local v220 = 0 + 0;
									while true do
										if (((121 - (29 + 35)) <= (12068 - 9345)) and (v220 == (0 - 0))) then
											v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 132 - 102);
											if (v31 or ((1349 + 721) == (1455 - (53 + 959)))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v212 = 411 - (312 + 96);
						end
						if ((v212 == (1 - 0)) or ((2990 - (147 + 138)) == (2292 - (813 + 86)))) then
							v31 = v118();
							if (v31 or ((4158 + 443) < (112 - 51))) then
								return v31;
							end
							v212 = 494 - (18 + 474);
						end
						if ((v212 == (2 + 1)) or ((4536 - 3146) >= (5830 - (860 + 226)))) then
							if (v79 or ((2306 - (121 + 182)) > (472 + 3362))) then
								v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 1270 - (988 + 252), true);
								if (v31 or ((18 + 138) > (1226 + 2687))) then
									return v31;
								end
							end
							if (((2165 - (49 + 1921)) == (1085 - (223 + 667))) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
								if (((3157 - (51 + 1)) >= (3090 - 1294)) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v212 = 8 - 4;
						end
						if (((5504 - (146 + 979)) >= (602 + 1529)) and ((605 - (311 + 294)) == v212)) then
							if (((10719 - 6875) >= (866 + 1177)) and v77 and v35 and v98.RemoveCurse:IsAvailable()) then
								local v218 = 1443 - (496 + 947);
								while true do
									if (((1358 - (1233 + 125)) == v218) or ((1312 + 1920) <= (2451 + 280))) then
										if (((932 + 3973) == (6550 - (963 + 682))) and v16) then
											local v225 = 0 + 0;
											while true do
												if ((v225 == (1504 - (504 + 1000))) or ((2786 + 1350) >= (4017 + 394))) then
													v31 = v120();
													if (v31 or ((280 + 2678) == (5922 - 1905))) then
														return v31;
													end
													break;
												end
											end
										end
										if (((1050 + 178) >= (473 + 340)) and v17 and v17:Exists() and v17:IsAPlayer() and v112.UnitHasCurseDebuff(v17)) then
											if (v98.RemoveCurse:IsReady() or ((3637 - (156 + 26)) > (2334 + 1716))) then
												if (((379 - 136) == (407 - (149 + 15))) and v24(v100.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((1231 - (890 + 70)) > (1689 - (39 + 78)))) then
								local v219 = 482 - (14 + 468);
								while true do
									if (((6022 - 3283) < (9203 - 5910)) and ((0 + 0) == v219)) then
										v31 = v122();
										if (v31 or ((2368 + 1574) < (241 + 893))) then
											return v31;
										end
										break;
									end
								end
							end
							v212 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v181 = 0 + 0;
		while true do
			if ((v181 == (1 - 0)) or ((2662 + 31) == (17474 - 12501))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
			if (((55 + 2091) == (2197 - (12 + 39))) and (v181 == (0 + 0))) then
				v113();
				v98.WintersChillDebuff:RegisterAuraTracking();
				v181 = 2 - 1;
			end
		end
	end
	v22.SetAPL(227 - 163, v130, v131);
end;
return v0["Epix_Mage_Frost.lua"]();

