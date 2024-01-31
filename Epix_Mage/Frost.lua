local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 285 - (74 + 211);
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((2230 - (28 + 238)) < (2994 - 1654))) then
			return v6(...);
		end
		if (((4058 - (1381 + 178)) == (2344 + 155)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((962 + 1293) < (75 - 53))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v106 = 470 - (381 + 89);
	local v107 = 0 + 0;
	local v108 = 11 + 4;
	local v109 = 19032 - 7921;
	local v110 = 12267 - (1074 + 82);
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((2379 - 1293) >= (3189 - (214 + 1570)))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(86176 - (990 + 465));
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(94238 + 134359);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(99362 + 128992);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(222300 + 6298);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(899662 - 671062);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v131 = 1726 - (1668 + 58);
		while true do
			if ((v131 == (627 - (512 + 114))) or ((6176 - 3807) == (880 - 454))) then
				v106 = 0 - 0;
				break;
			end
			if ((v131 == (0 + 0)) or ((576 + 2500) > (2768 + 415))) then
				v109 = 37476 - 26365;
				v110 = 13105 - (109 + 1885);
				v131 = 1470 - (1269 + 200);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		if (((2303 - 1101) > (1873 - (98 + 717))) and (v132 == nil)) then
			v132 = v15;
		end
		return not v132:IsInBossList() or (v132:Level() < (899 - (802 + 24)));
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
		if (((6399 - 2688) > (4237 - 882)) and v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
			if (v24(v98.IceBarrier) or ((134 + 772) >= (1713 + 516))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((212 + 1076) > (270 + 981)) and v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 5 - 3)) then
			if (v24(v98.MassBarrier) or ((15049 - 10536) < (1199 + 2153))) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((841 + 1224) >= (2637 + 559))) then
			if (v24(v98.IceColdAbility) or ((3182 + 1194) <= (692 + 789))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((4825 - (797 + 636)) >= (23019 - 18278))) then
			if (((4944 - (1427 + 192)) >= (747 + 1407)) and v24(v98.IceBlock)) then
				return "ice_block defensive 4";
			end
		end
		if ((v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((3006 - 1711) >= (2907 + 326))) then
			if (((1984 + 2393) > (1968 - (192 + 134))) and v24(v98.MirrorImage)) then
				return "mirror_image defensive 5";
			end
		end
		if (((5999 - (316 + 960)) > (755 + 601)) and v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
			if (v24(v98.GreaterInvisibility) or ((3192 + 944) <= (3174 + 259))) then
				return "greater_invisibility defensive 6";
			end
		end
		if (((16228 - 11983) <= (5182 - (83 + 468))) and v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
			if (((6082 - (1202 + 604)) >= (18271 - 14357)) and v24(v98.AlterTime)) then
				return "alter_time defensive 7";
			end
		end
		if (((329 - 131) <= (12085 - 7720)) and v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
			if (((5107 - (45 + 280)) > (4514 + 162)) and v24(v100.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((4250 + 614) > (803 + 1394)) and v84 and (v14:HealthPercentage() <= v86)) then
			if ((v88 == "Refreshing Healing Potion") or ((2048 + 1652) == (441 + 2066))) then
				if (((8284 - 3810) >= (2185 - (340 + 1571))) and v99.RefreshingHealingPotion:IsReady()) then
					if (v24(v100.RefreshingHealingPotion) or ((748 + 1146) <= (3178 - (1733 + 39)))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((4319 - 2747) >= (2565 - (125 + 909))) and (v88 == "Dreamwalker's Healing Potion")) then
				if (v99.DreamwalkersHealingPotion:IsReady() or ((6635 - (1096 + 852)) < (2038 + 2504))) then
					if (((4699 - 1408) > (1617 + 50)) and v24(v100.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v119()
		if ((v98.RemoveCurse:IsReady() and v112.DispellableFriendlyUnit(532 - (409 + 103))) or ((1109 - (46 + 190)) == (2129 - (51 + 44)))) then
			local v195 = 0 + 0;
			while true do
				if ((v195 == (1317 - (1114 + 203))) or ((3542 - (228 + 498)) < (3 + 8))) then
					v112.Wait(1 + 0);
					if (((4362 - (174 + 489)) < (12260 - 7554)) and v24(v100.RemoveCurseFocus)) then
						return "remove_curse dispel";
					end
					break;
				end
			end
		end
	end
	local function v120()
		v31 = v112.HandleTopTrinket(v101, v34, 1945 - (830 + 1075), nil);
		if (((3170 - (303 + 221)) >= (2145 - (231 + 1038))) and v31) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 34 + 6, nil);
		if (((1776 - (171 + 991)) <= (13121 - 9937)) and v31) then
			return v31;
		end
	end
	local function v121()
		if (((8393 - 5267) == (7800 - 4674)) and v112.TargetIsValid()) then
			local v196 = 0 + 0;
			while true do
				if ((v196 == (0 - 0)) or ((6308 - 4121) >= (7985 - 3031))) then
					if ((v98.MirrorImage:IsCastable() and v68 and v96) or ((11984 - 8107) == (4823 - (111 + 1137)))) then
						if (((865 - (91 + 67)) > (1880 - 1248)) and v24(v98.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if ((v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) or ((137 + 409) >= (3207 - (423 + 100)))) then
						if (((11 + 1454) <= (11908 - 7607)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		if (((889 + 815) > (2196 - (326 + 445))) and v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(4 - 3, v98.IcyVeins)) then
			if (v24(v98.TimeWarp, not v15:IsInRange(89 - 49)) or ((1603 - 916) == (4945 - (530 + 181)))) then
				return "time_warp cd 2";
			end
		end
		local v135 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
		if (v135 or ((4211 - (614 + 267)) < (1461 - (19 + 13)))) then
			return v135;
		end
		if (((1866 - 719) >= (780 - 445)) and v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
			if (((9812 - 6377) > (545 + 1552)) and v24(v98.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v110) or ((6630 - 2860) >= (8380 - 4339))) then
			if ((v90 and ((v34 and v91) or not v91)) or ((5603 - (1293 + 519)) <= (3286 - 1675))) then
				v31 = v120();
				if (v31 or ((11952 - 7374) <= (3839 - 1831))) then
					return v31;
				end
			end
		end
		if (((4851 - 3726) <= (4890 - 2814)) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
			local v197 = 0 + 0;
			while true do
				if ((v197 == (1 + 1)) or ((1725 - 982) >= (1017 + 3382))) then
					if (((384 + 771) < (1046 + 627)) and v98.AncestralCall:IsCastable()) then
						if (v24(v98.AncestralCall) or ((3420 - (709 + 387)) <= (2436 - (673 + 1185)))) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
				if (((10924 - 7157) == (12096 - 8329)) and (v197 == (0 - 0))) then
					if (((2925 + 1164) == (3056 + 1033)) and v98.BloodFury:IsCastable()) then
						if (((6018 - 1560) >= (412 + 1262)) and v24(v98.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((1937 - 965) <= (2783 - 1365)) and v98.Berserking:IsCastable()) then
						if (v24(v98.Berserking) or ((6818 - (446 + 1434)) < (6045 - (1040 + 243)))) then
							return "berserking cd 12";
						end
					end
					v197 = 2 - 1;
				end
				if ((v197 == (1848 - (559 + 1288))) or ((4435 - (609 + 1322)) > (4718 - (13 + 441)))) then
					if (((8045 - 5892) == (5639 - 3486)) and v98.LightsJudgment:IsCastable()) then
						if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((2525 - 2018) >= (97 + 2494))) then
							return "lights_judgment cd 14";
						end
					end
					if (((16274 - 11793) == (1592 + 2889)) and v98.Fireblood:IsCastable()) then
						if (v24(v98.Fireblood) or ((1021 + 1307) < (2056 - 1363))) then
							return "fireblood cd 16";
						end
					end
					v197 = 2 + 0;
				end
			end
		end
	end
	local function v123()
		if (((7959 - 3631) == (2862 + 1466)) and v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) then
			if (((884 + 704) >= (958 + 374)) and v24(v98.IceFloes)) then
				return "ice_floes movement";
			end
		end
		if ((v98.IceNova:IsCastable() and v48) or ((3505 + 669) > (4157 + 91))) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((5019 - (153 + 280)) <= (236 - 154))) then
				return "ice_nova movement";
			end
		end
		if (((3469 + 394) == (1526 + 2337)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (16 + 14)) and (v103 >= (2 + 0))) then
			if (v24(v98.ArcaneExplosion, not v15:IsInRange(6 + 2)) or ((428 - 146) <= (26 + 16))) then
				return "arcane_explosion movement";
			end
		end
		if (((5276 - (89 + 578)) >= (548 + 218)) and v98.FireBlast:IsCastable() and v40) then
			if (v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast)) or ((2394 - 1242) == (3537 - (572 + 477)))) then
				return "fire_blast movement";
			end
		end
		if (((462 + 2960) > (2011 + 1339)) and v98.IceLance:IsCastable() and v47) then
			if (((105 + 772) > (462 - (84 + 2))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
				return "ice_lance movement";
			end
		end
	end
	local function v124()
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1 - 0, v98.CometStorm) or (v14:PrevGCDP(1 + 0, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) or ((3960 - (497 + 345)) <= (48 + 1803))) then
			if (v24(v98.ConeofCold, not v15:IsInRange(2 + 6)) or ((1498 - (605 + 728)) >= (2492 + 1000))) then
				return "cone_of_cold aoe 2";
			end
		end
		if (((8779 - 4830) < (223 + 4633)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(3 - 2, v98.GlacialSpike) or not v114())) then
			if (v24(v100.FrozenOrbCast, not v15:IsInRange(37 + 3)) or ((11846 - 7570) < (2278 + 738))) then
				return "frozen_orb aoe 4";
			end
		end
		if (((5179 - (457 + 32)) > (1751 + 2374)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1403 - (832 + 570), v98.GlacialSpike) or not v114())) then
			if (v24(v100.BlizzardCursor, not v15:IsInRange(38 + 2)) or ((14 + 36) >= (3170 - 2274))) then
				return "blizzard aoe 6";
			end
		end
		if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (821 - (588 + 208)))) or (v98.ConeofCold:CooldownRemains() > (53 - 33)))) or ((3514 - (884 + 916)) >= (6192 - 3234))) then
			if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((865 + 626) < (1297 - (232 + 421)))) then
				return "comet_storm aoe 8";
			end
		end
		if (((2593 - (1569 + 320)) < (243 + 744)) and v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (0 + 0)) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(3 - 2, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) then
			if (((4323 - (316 + 289)) > (4989 - 3083)) and v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze))) then
				return "freeze aoe 10";
			end
		end
		if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and (v14:PrevGCDP(1454 - (666 + 787), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (426 - (360 + 65)))))) or ((896 + 62) > (3889 - (79 + 175)))) then
			if (((5520 - 2019) <= (3506 + 986)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova aoe 11";
			end
		end
		if ((v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(2 - 1, v98.Freeze) and ((v14:PrevGCDP(1 - 0, v98.GlacialSpike) and (v106 == (899 - (503 + 396)))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (182 - (92 + 89)))))) or ((6676 - 3234) < (1307 + 1241))) then
			if (((1702 + 1173) >= (5733 - 4269)) and v24(v98.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or ((656 + 4141) >= (11156 - 6263))) then
			if (v24(v98.ConeofCold, not v15:IsInRange(7 + 1)) or ((264 + 287) > (6298 - 4230))) then
				return "cone_of_cold aoe 14";
			end
		end
		if (((264 + 1850) > (1439 - 495)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) then
			if (v24(v98.ShiftingPower, not v15:IsInRange(1284 - (485 + 759)), true) or ((5233 - 2971) >= (4285 - (442 + 747)))) then
				return "shifting_power aoe 16";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (1140 - (832 + 303))) and (v98.Blizzard:CooldownRemains() > v111)) or ((3201 - (88 + 858)) >= (1079 + 2458))) then
			if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((3176 + 661) < (54 + 1252))) then
				return "glacial_spike aoe 18";
			end
		end
		if (((3739 - (766 + 23)) == (14563 - 11613)) and v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (0 - 0)) and (v14:PrevGCDP(2 - 1, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (3.8 - 2)))) then
			if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((5796 - (1036 + 37)) < (2339 + 959))) then
				return "flurry aoe 20";
			end
		end
		if (((2212 - 1076) >= (122 + 32)) and v98.Flurry:IsCastable() and v43 and (v106 == (1480 - (641 + 839))) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
			if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((1184 - (910 + 3)) > (12103 - 7355))) then
				return "flurry aoe 21";
			end
		end
		if (((6424 - (1466 + 218)) >= (1449 + 1703)) and v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) then
			if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((3726 - (556 + 592)) >= (1206 + 2184))) then
				return "ice_lance aoe 22";
			end
		end
		if (((849 - (329 + 479)) <= (2515 - (174 + 680))) and v98.IceNova:IsCastable() and v48 and (v102 >= (13 - 9)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) then
			if (((1245 - 644) < (2542 + 1018)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova aoe 23";
			end
		end
		if (((974 - (396 + 343)) < (61 + 626)) and v98.DragonsBreath:IsCastable() and v39 and (v103 >= (1484 - (29 + 1448)))) then
			if (((5938 - (135 + 1254)) > (4343 - 3190)) and v24(v98.DragonsBreath, not v15:IsInRange(46 - 36))) then
				return "dragons_breath aoe 26";
			end
		end
		if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (20 + 10)) and (v103 >= (1534 - (389 + 1138)))) or ((5248 - (102 + 472)) < (4409 + 263))) then
			if (((2035 + 1633) < (4253 + 308)) and v24(v98.ArcaneExplosion, not v15:IsInRange(1553 - (320 + 1225)))) then
				return "arcane_explosion aoe 28";
			end
		end
		if ((v98.Frostbolt:IsCastable() and v41) or ((809 - 354) == (2206 + 1399))) then
			if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((4127 - (157 + 1307)) == (5171 - (821 + 1038)))) then
				return "frostbolt aoe 32";
			end
		end
		if (((10670 - 6393) <= (490 + 3985)) and v14:IsMoving() and v94) then
			v31 = v123();
			if (v31 or ((1545 - 675) == (443 + 746))) then
				return v31;
			end
		end
	end
	local function v125()
		if (((3849 - 2296) <= (4159 - (834 + 192))) and v98.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) then
			if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((49 + 2188) >= (5438 - 1927))) then
				return "comet_storm cleave 2";
			end
		end
		if ((v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(305 - (300 + 4), v98.Frostbolt) and (v107 >= (1 + 2))) or v14:PrevGCDP(2 - 1, v98.GlacialSpike) or ((v107 >= (365 - (112 + 250))) and (v107 < (2 + 3)) and (v98.Flurry:ChargesFractional() == (4 - 2))))) or ((759 + 565) > (1562 + 1458))) then
			local v198 = 0 + 0;
			while true do
				if ((v198 == (0 + 0)) or ((2223 + 769) == (3295 - (1001 + 413)))) then
					if (((6926 - 3820) > (2408 - (244 + 638))) and v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry cleave 4";
					end
					if (((3716 - (627 + 66)) < (11531 - 7661)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry cleave 4";
					end
					break;
				end
			end
		end
		if (((745 - (512 + 90)) > (1980 - (1665 + 241))) and v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (717 - (373 + 344))) and (v107 == (2 + 2)) and v14:BuffUp(v98.FingersofFrostBuff)) then
			local v199 = 0 + 0;
			while true do
				if (((47 - 29) < (3573 - 1461)) and (v199 == (1099 - (35 + 1064)))) then
					if (((799 + 298) <= (3482 - 1854)) and v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (((19 + 4611) == (5866 - (298 + 938))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 6";
					end
					break;
				end
			end
		end
		if (((4799 - (233 + 1026)) > (4349 - (636 + 1030))) and v98.RayofFrost:IsCastable() and (v106 == (1 + 0)) and v49) then
			local v200 = 0 + 0;
			while true do
				if (((1425 + 3369) >= (222 + 3053)) and ((221 - (55 + 166)) == v200)) then
					if (((288 + 1196) == (150 + 1334)) and v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (((5468 - 4036) < (3852 - (36 + 261))) and v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					break;
				end
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (8 - 3)) and (v98.Flurry:CooldownUp() or (v106 > (1368 - (34 + 1334))))) or ((410 + 655) > (2781 + 797))) then
			if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((6078 - (1035 + 248)) < (1428 - (20 + 1)))) then
				return "glacial_spike cleave 10";
			end
		end
		if (((966 + 887) < (5132 - (134 + 185))) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1135 - (549 + 584))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
			if (v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb)) or ((3506 - (314 + 371)) < (8345 - 5914))) then
				return "frozen_orb cleave 12";
			end
		end
		if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (978 - (478 + 490))) and (v98.FrozenOrb:CooldownRemains() > (6 + 4)) and (v106 == (1172 - (786 + 386))) and (v103 >= (9 - 6))) or ((4253 - (1055 + 324)) < (3521 - (1093 + 247)))) then
			if (v24(v98.ConeofCold) or ((2390 + 299) <= (37 + 306))) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (7 - 5)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (9 - 6)))) or ((5317 - 3448) == (5048 - 3039))) then
			if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((1262 + 2284) < (8945 - 6623))) then
				return "blizzard cleave 16";
			end
		end
		if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (34 - 24)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (8 + 2))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (25 - 15)))) or (v98.IcyVeins:CooldownRemains() < (708 - (364 + 324))))) or ((5707 - 3625) == (11453 - 6680))) then
			if (((1076 + 2168) > (4414 - 3359)) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
				return "shifting_power cleave 18";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (8 - 3))) or ((10061 - 6748) <= (3046 - (1249 + 19)))) then
			if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((1283 + 138) >= (8189 - 6085))) then
				return "glacial_spike cleave 20";
			end
		end
		if (((2898 - (686 + 400)) <= (2550 + 699)) and v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(230 - (73 + 156), v98.GlacialSpike)) or (v106 > (0 + 0)))) then
			local v201 = 811 - (721 + 90);
			while true do
				if (((19 + 1604) <= (6353 - 4396)) and (v201 == (470 - (224 + 246)))) then
					if (((7147 - 2735) == (8123 - 3711)) and v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (((318 + 1432) >= (21 + 821)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if (((3212 + 1160) > (3678 - 1828)) and v98.IceNova:IsCastable() and v48 and (v103 >= (12 - 8))) then
			if (((745 - (203 + 310)) < (2814 - (1238 + 755))) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova cleave 24";
			end
		end
		if (((37 + 481) < (2436 - (709 + 825))) and v98.Frostbolt:IsCastable() and v41) then
			if (((5517 - 2523) > (1249 - 391)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt cleave 26";
			end
		end
		if ((v14:IsMoving() and v94) or ((4619 - (196 + 668)) <= (3612 - 2697))) then
			local v202 = 0 - 0;
			while true do
				if (((4779 - (171 + 662)) > (3836 - (4 + 89))) and ((0 - 0) == v202)) then
					v31 = v123();
					if (v31 or ((487 + 848) >= (14520 - 11214))) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v136 = 0 + 0;
		while true do
			if (((6330 - (35 + 1451)) > (3706 - (28 + 1425))) and (v136 == (1994 - (941 + 1052)))) then
				if (((434 + 18) == (1966 - (822 + 692))) and v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (1 - 0))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((2147 + 2410) < (2384 - (45 + 252)))) then
						return "ray_of_frost single 8";
					end
				end
				if (((3834 + 40) == (1334 + 2540)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (12 - 7)) and ((v98.Flurry:Charges() >= (434 - (114 + 319))) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((2482 - 544) > (3146 + 1789))) then
						return "glacial_spike single 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 - 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (3 - 1)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((6218 - (556 + 1407)) < (4629 - (741 + 465)))) then
					if (((1919 - (170 + 295)) <= (1313 + 1178)) and v24(v100.FrozenOrbCast, not v15:IsInRange(37 + 3))) then
						return "frozen_orb single 12";
					end
				end
				v136 = 4 - 2;
			end
			if ((v136 == (0 + 0)) or ((2666 + 1491) <= (1588 + 1215))) then
				if (((6083 - (957 + 273)) >= (798 + 2184)) and v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(3 - 2, v98.ConeofCold))) then
					if (((10893 - 6759) > (10253 - 6896)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if ((v98.Flurry:IsCastable() and (v106 == (0 - 0)) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1781 - (389 + 1391), v98.Frostbolt) and (v107 >= (2 + 1))) or (v14:PrevGCDP(1 + 0, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(2 - 1, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (955 - (783 + 168))) and v14:BuffDown(v98.FingersofFrostBuff)))) or ((11468 - 8051) < (2493 + 41))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((3033 - (309 + 2)) <= (503 - 339))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (1212 - (1090 + 122))) and (v107 == (2 + 2)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((8087 - 5679) < (1444 + 665))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((1151 - (628 + 490)) == (261 + 1194))) then
						return "ice_lance single 6";
					end
				end
				v136 = 2 - 1;
			end
			if ((v136 == (13 - 10)) or ((1217 - (431 + 343)) >= (8108 - 4093))) then
				if (((9783 - 6401) > (132 + 34)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (1 + 4))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((1975 - (556 + 1139)) == (3074 - (6 + 9)))) then
						return "glacial_spike single 20";
					end
				end
				if (((345 + 1536) > (663 + 630)) and v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(170 - (28 + 141), v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) then
					if (((913 + 1444) == (2908 - 551)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((88 + 35) == (1440 - (486 + 831))) and v98.IceNova:IsCastable() and v48 and (v103 >= (10 - 6))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((3717 - 2661) >= (641 + 2751))) then
						return "ice_nova single 24";
					end
				end
				v136 = 12 - 8;
			end
			if ((v136 == (1265 - (668 + 595))) or ((973 + 108) < (217 + 858))) then
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (27 - 17)) and (v98.FrozenOrb:CooldownRemains() > (300 - (23 + 267))) and (v106 == (1944 - (1129 + 815))) and (v102 >= (390 - (371 + 16)))) or ((2799 - (1326 + 424)) >= (8393 - 3961))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(29 - 21)) or ((4886 - (88 + 30)) <= (1617 - (720 + 51)))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (4 - 2)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (1779 - (421 + 1355))))) or ((5539 - 2181) <= (698 + 722))) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(1123 - (286 + 797))) or ((13668 - 9929) <= (4976 - 1971))) then
						return "blizzard single 16";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (439 - (397 + 42))) and (((v98.FrozenOrb:CooldownRemains() > (4 + 6)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (810 - (24 + 776)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (15 - 5)))) or (v98.IcyVeins:CooldownRemains() < (805 - (222 + 563))))) or ((3654 - 1995) >= (1537 + 597))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(230 - (23 + 167))) or ((5058 - (690 + 1108)) < (850 + 1505))) then
						return "shifting_power single 18";
					end
				end
				v136 = 3 + 0;
			end
			if ((v136 == (852 - (40 + 808))) or ((111 + 558) == (16148 - 11925))) then
				if ((v89 and ((v92 and v34) or not v92)) or ((1618 + 74) < (312 + 276))) then
					if (v98.BagofTricks:IsCastable() or ((2631 + 2166) < (4222 - (47 + 524)))) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((2711 + 1466) > (13257 - 8407))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((v98.Frostbolt:IsCastable() and v41) or ((598 - 198) > (2533 - 1422))) then
					if (((4777 - (1165 + 561)) > (30 + 975)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if (((11437 - 7744) <= (1672 + 2710)) and v14:IsMoving() and v94) then
					v31 = v123();
					if (v31 or ((3761 - (341 + 138)) > (1107 + 2993))) then
						return v31;
					end
				end
				break;
			end
		end
	end
	local function v127()
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
		v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v70 = EpicSettings.Settings['iceBarrierHP'] or (326 - (89 + 237));
		v73 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v72 = EpicSettings.Settings['iceBlockHP'] or (881 - (581 + 300));
		v74 = EpicSettings.Settings['mirrorImageHP'] or (1220 - (855 + 365));
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v93 = EpicSettings.Settings['useSpellStealTarget'];
		v94 = EpicSettings.Settings['useSpellsWhileMoving'];
		v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v96 = EpicSettings.Settings['mirrorImageBeforePull'];
		v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
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
		v87 = EpicSettings.Settings['healthstoneHP'] or (1235 - (1030 + 205));
		v86 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
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
		if (v14:IsDeadOrGhost() or ((3331 + 249) < (3130 - (156 + 130)))) then
			return v31;
		end
		v104 = v15:GetEnemiesInSplashRange(11 - 6);
		v105 = v14:GetEnemiesInRange(67 - 27);
		if (((181 - 92) < (1184 + 3306)) and v33) then
			v102 = v30(v15:GetEnemiesInSplashRangeCount(3 + 2), #v105);
			v103 = v30(v15:GetEnemiesInSplashRangeCount(74 - (10 + 59)), #v105);
		else
			v102 = 1 + 0;
			v103 = 4 - 3;
		end
		if (not v14:AffectingCombat() or ((6146 - (671 + 492)) < (1440 + 368))) then
			if (((5044 - (369 + 846)) > (998 + 2771)) and v98.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
				if (((1268 + 217) <= (4849 - (1036 + 909))) and v24(v98.ArcaneIntellect)) then
					return "arcane_intellect";
				end
			end
		end
		if (((3395 + 874) == (7166 - 2897)) and (v112.TargetIsValid() or v14:AffectingCombat())) then
			local v203 = 203 - (11 + 192);
			while true do
				if (((196 + 191) <= (2957 - (135 + 40))) and (v203 == (2 - 1))) then
					if ((v110 == (6698 + 4413)) or ((4183 - 2284) <= (1373 - 456))) then
						v110 = v10.FightRemains(v105, false);
					end
					v106 = v15:DebuffStack(v98.WintersChillDebuff);
					v203 = 178 - (50 + 126);
				end
				if ((v203 == (5 - 3)) or ((955 + 3357) <= (2289 - (1233 + 180)))) then
					v107 = v14:BuffStackP(v98.IciclesBuff);
					v111 = v14:GCD();
					break;
				end
				if (((3201 - (522 + 447)) <= (4017 - (107 + 1314))) and (v203 == (0 + 0))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v203 = 2 - 1;
				end
			end
		end
		if (((890 + 1205) < (7319 - 3633)) and v112.TargetIsValid()) then
			if ((v77 and v35 and v98.RemoveCurse:IsAvailable()) or ((6310 - 4715) >= (6384 - (716 + 1194)))) then
				if (v16 or ((79 + 4540) < (309 + 2573))) then
					v31 = v119();
					if (v31 or ((797 - (74 + 429)) >= (9319 - 4488))) then
						return v31;
					end
				end
				if (((1006 + 1023) <= (7059 - 3975)) and v17 and v17:Exists() and v17:IsAPlayer() and v112.UnitHasCurseDebuff(v17)) then
					if (v98.RemoveCurse:IsReady() or ((1442 + 595) == (7460 - 5040))) then
						if (((11022 - 6564) > (4337 - (279 + 154))) and v24(v100.RemoveCurseMouseover)) then
							return "remove_curse dispel";
						end
					end
				end
			end
			if (((1214 - (454 + 324)) >= (97 + 26)) and not v14:AffectingCombat() and v32) then
				local v204 = 17 - (12 + 5);
				while true do
					if (((270 + 230) < (4626 - 2810)) and (v204 == (0 + 0))) then
						v31 = v121();
						if (((4667 - (277 + 816)) == (15271 - 11697)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
			v31 = v118();
			if (((1404 - (1058 + 125)) < (74 + 316)) and v31) then
				return v31;
			end
			if (v14:AffectingCombat() or v77 or ((3188 - (815 + 160)) <= (6096 - 4675))) then
				local v205 = 0 - 0;
				local v206;
				while true do
					if (((730 + 2328) < (14206 - 9346)) and (v205 == (1898 - (41 + 1857)))) then
						v206 = v77 and v98.RemoveCurse:IsReady() and v35;
						v31 = v112.FocusUnit(v206, v100, 1913 - (1222 + 671), nil, 51 - 31);
						v205 = 1 - 0;
					end
					if ((v205 == (1183 - (229 + 953))) or ((3070 - (1111 + 663)) >= (6025 - (874 + 705)))) then
						if (v31 or ((195 + 1198) > (3063 + 1426))) then
							return v31;
						end
						break;
					end
				end
			end
			if (v78 or ((9195 - 4771) < (1 + 26))) then
				if (v97 or ((2676 - (642 + 37)) > (870 + 2945))) then
					local v209 = 0 + 0;
					while true do
						if (((8699 - 5234) > (2367 - (233 + 221))) and ((0 - 0) == v209)) then
							v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 27 + 3);
							if (((2274 - (718 + 823)) < (1145 + 674)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if (v79 or ((5200 - (266 + 539)) == (13462 - 8707))) then
				local v207 = 1225 - (636 + 589);
				while true do
					if ((v207 == (0 - 0)) or ((7822 - 4029) < (1878 + 491))) then
						v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 11 + 19, true);
						if (v31 or ((5099 - (657 + 358)) == (701 - 436))) then
							return v31;
						end
						break;
					end
				end
			end
			if (((9928 - 5570) == (5545 - (1151 + 36))) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
				if (v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal)) or ((3031 + 107) < (262 + 731))) then
					return "spellsteal damage";
				end
			end
			if (((9944 - 6614) > (4155 - (1552 + 280))) and v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
				local v208 = 834 - (64 + 770);
				while true do
					if ((v208 == (2 + 0)) or ((8231 - 4605) == (709 + 3280))) then
						if (v31 or ((2159 - (157 + 1086)) == (5346 - 2675))) then
							return v31;
						end
						if (((1191 - 919) == (416 - 144)) and v24(v98.Pool)) then
							return "pool for ST()";
						end
						v208 = 3 - 0;
					end
					if (((5068 - (599 + 220)) <= (9635 - 4796)) and (v208 == (1932 - (1813 + 118)))) then
						if (((2030 + 747) < (4417 - (841 + 376))) and v33 and (v103 == (2 - 0))) then
							local v210 = 0 + 0;
							while true do
								if (((259 - 164) < (2816 - (464 + 395))) and (v210 == (0 - 0))) then
									v31 = v125();
									if (((397 + 429) < (2554 - (467 + 370))) and v31) then
										return v31;
									end
									v210 = 1 - 0;
								end
								if (((1047 + 379) >= (3787 - 2682)) and (v210 == (1 + 0))) then
									if (((6406 - 3652) <= (3899 - (150 + 370))) and v24(v98.Pool)) then
										return "pool for Cleave()";
									end
									break;
								end
							end
						end
						v31 = v126();
						v208 = 1284 - (74 + 1208);
					end
					if ((v208 == (7 - 4)) or ((18624 - 14697) == (1006 + 407))) then
						if ((v14:IsMoving() and v94) or ((1544 - (14 + 376)) <= (1366 - 578))) then
							local v211 = 0 + 0;
							while true do
								if ((v211 == (0 + 0)) or ((1567 + 76) > (9900 - 6521))) then
									v31 = v123();
									if (v31 or ((2109 + 694) > (4627 - (23 + 55)))) then
										return v31;
									end
									break;
								end
							end
						end
						break;
					end
					if ((v208 == (0 - 0)) or ((147 + 73) >= (2714 + 308))) then
						if (((4375 - 1553) == (888 + 1934)) and v34) then
							local v212 = 901 - (652 + 249);
							while true do
								if ((v212 == (0 - 0)) or ((2929 - (708 + 1160)) == (5040 - 3183))) then
									v31 = v122();
									if (((5032 - 2272) > (1391 - (10 + 17))) and v31) then
										return v31;
									end
									break;
								end
							end
						end
						if ((v33 and (((v103 >= (2 + 5)) and not v14:HasTier(1762 - (1400 + 332), 3 - 1)) or ((v103 >= (1911 - (242 + 1666))) and v98.IceCaller:IsAvailable()))) or ((2098 + 2804) <= (1318 + 2277))) then
							local v213 = 0 + 0;
							while true do
								if ((v213 == (940 - (850 + 90))) or ((6746 - 2894) == (1683 - (360 + 1030)))) then
									v31 = v124();
									if (v31 or ((1380 + 179) == (12949 - 8361))) then
										return v31;
									end
									v213 = 1 - 0;
								end
								if ((v213 == (1662 - (909 + 752))) or ((5707 - (109 + 1114)) == (1442 - 654))) then
									if (((1779 + 2789) >= (4149 - (6 + 236))) and v24(v98.Pool)) then
										return "pool for Aoe()";
									end
									break;
								end
							end
						end
						v208 = 1 + 0;
					end
				end
			end
		end
	end
	local function v130()
		v113();
		v98.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(52 + 12, v129, v130);
end;
return v0["Epix_Mage_Frost.lua"]();

