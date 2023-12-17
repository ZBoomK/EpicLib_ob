local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((932 + 76) < (14187 - 10476)) and (v5 == (551 - (83 + 468)))) then
			v6 = v0[v4];
			if (not v6 or ((2855 - (1202 + 604)) <= (4229 - 3323))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((12495 - 7982) > (3051 - (45 + 280))) and (v5 == (1 + 0))) then
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
	local v107 = 0 + 0;
	local v108 = 9 + 6;
	local v109 = 1955 + 9156;
	local v110 = 20574 - 9463;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((3392 - (340 + 1571)) >= (1049 + 1609))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(86493 - (1733 + 39));
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(628161 - 399564);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(229388 - (125 + 909));
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(230546 - (1096 + 852));
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(102545 + 126055);
	v98.GlacialSpike:RegisterInFlight();
	v98.WintersChillDebuff:RegisterAuraTracking();
	v10:RegisterForEvent(function()
		v109 = 15867 - 4756;
		v110 = 10777 + 334;
		v106 = 512 - (409 + 103);
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v131)
		local v132 = 236 - (46 + 190);
		while true do
			if ((v132 == (95 - (51 + 44))) or ((909 + 2311) == (2681 - (1114 + 203)))) then
				if ((v131 == nil) or ((1780 - (228 + 498)) > (735 + 2657))) then
					v131 = v15;
				end
				return not v131:IsInBossList() or (v131:Level() < (41 + 32));
			end
		end
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
		local v135 = 663 - (174 + 489);
		while true do
			if ((v135 == (2 - 1)) or ((2581 - (830 + 1075)) >= (2166 - (303 + 221)))) then
				if (((5405 - (231 + 1038)) > (1998 + 399)) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (v24(v98.IceColdAbility) or ((5496 - (171 + 991)) == (17494 - 13249))) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((11481 - 7205) <= (7563 - 4532))) then
					if (v24(v98.IceBlock) or ((3828 + 954) <= (4202 - 3003))) then
						return "ice_block defensive 4";
					end
				end
				v135 = 5 - 3;
			end
			if ((v135 == (0 - 0)) or ((15035 - 10171) < (3150 - (111 + 1137)))) then
				if (((4997 - (91 + 67)) >= (11012 - 7312)) and v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v98.IceBarrier) or ((269 + 806) > (2441 - (423 + 100)))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((3 + 393) <= (10532 - 6728)) and v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2 + 0)) then
					if (v24(v98.MassBarrier) or ((4940 - (326 + 445)) == (9543 - 7356))) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 2 - 1;
			end
			if (((3281 - 1875) == (2117 - (530 + 181))) and (v135 == (885 - (614 + 267)))) then
				if (((1563 - (19 + 13)) < (6951 - 2680)) and v84 and (v14:HealthPercentage() <= v86)) then
					local v210 = 0 - 0;
					while true do
						if (((1813 - 1178) == (165 + 470)) and (v210 == (0 - 0))) then
							if (((6994 - 3621) <= (5368 - (1293 + 519))) and (v88 == "Refreshing Healing Potion")) then
								if (v99.RefreshingHealingPotion:IsReady() or ((6714 - 3423) < (8563 - 5283))) then
									if (((8387 - 4001) >= (3764 - 2891)) and v24(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((2169 - 1248) <= (584 + 518)) and (v88 == "Dreamwalker's Healing Potion")) then
								if (((961 + 3745) >= (2236 - 1273)) and v99.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or ((222 + 738) <= (292 + 584))) then
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
			if ((v135 == (2 + 0)) or ((3162 - (709 + 387)) == (2790 - (673 + 1185)))) then
				if (((13993 - 9168) < (15551 - 10708)) and v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (v24(v98.MirrorImage) or ((6378 - 2501) >= (3246 + 1291))) then
						return "mirror_image defensive 5";
					end
				end
				if ((v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((3225 + 1090) < (2329 - 603))) then
					if (v24(v98.GreaterInvisibility) or ((904 + 2775) < (1246 - 621))) then
						return "greater_invisibility defensive 6";
					end
				end
				v135 = 5 - 2;
			end
			if ((v135 == (1883 - (446 + 1434))) or ((5908 - (1040 + 243)) < (1886 - 1254))) then
				if ((v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((1930 - (559 + 1288)) > (3711 - (609 + 1322)))) then
					if (((1000 - (13 + 441)) <= (4024 - 2947)) and v24(v98.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) or ((2608 - 1612) > (21420 - 17119))) then
					if (((152 + 3918) > (2494 - 1807)) and v24(v100.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v135 = 2 + 2;
			end
		end
	end
	local function v119()
		if ((v98.RemoveCurse:IsReady() and v35 and v112.DispellableFriendlyUnit(9 + 11)) or ((1946 - 1290) >= (1823 + 1507))) then
			if (v24(v100.RemoveCurseFocus) or ((4582 - 2090) <= (222 + 113))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v120()
		local v136 = 0 + 0;
		while true do
			if (((3106 + 1216) >= (2152 + 410)) and (v136 == (1 + 0))) then
				v31 = v112.HandleBottomTrinket(v101, v34, 473 - (153 + 280), nil);
				if (v31 or ((10501 - 6864) >= (3385 + 385))) then
					return v31;
				end
				break;
			end
			if ((v136 == (0 + 0)) or ((1245 + 1134) > (4155 + 423))) then
				v31 = v112.HandleTopTrinket(v101, v34, 29 + 11, nil);
				if (v31 or ((735 - 252) > (460 + 283))) then
					return v31;
				end
				v136 = 668 - (89 + 578);
			end
		end
	end
	local function v121()
		if (((1754 + 700) > (1201 - 623)) and v112.TargetIsValid()) then
			local v188 = 1049 - (572 + 477);
			while true do
				if (((126 + 804) < (2676 + 1782)) and (v188 == (0 + 0))) then
					if (((748 - (84 + 2)) <= (1601 - 629)) and v98.MirrorImage:IsCastable() and v68 and v96) then
						if (((3149 + 1221) == (5212 - (497 + 345))) and v24(v98.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if ((v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) or ((122 + 4640) <= (146 + 715))) then
						if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt)) or ((2745 - (605 + 728)) == (3043 + 1221))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		if ((v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 - 0, v98.IcyVeins)) or ((146 + 3022) < (7960 - 5807))) then
			if (v24(v98.TimeWarp, not v15:IsInRange(37 + 3)) or ((13786 - 8810) < (1006 + 326))) then
				return "time_warp cd 2";
			end
		end
		local v137 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
		if (((5117 - (457 + 32)) == (1964 + 2664)) and v137) then
			return v137;
		end
		if ((v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) or ((1456 - (832 + 570)) == (373 + 22))) then
			if (((22 + 60) == (289 - 207)) and v24(v98.IcyVeins)) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v110) or ((280 + 301) < (1078 - (588 + 208)))) then
			if ((v90 and ((v34 and v91) or not v91)) or ((12422 - 7813) < (4295 - (884 + 916)))) then
				v31 = v120();
				if (((2411 - 1259) == (668 + 484)) and v31) then
					return v31;
				end
			end
		end
		if (((2549 - (232 + 421)) <= (5311 - (1569 + 320))) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
			local v189 = 0 + 0;
			while true do
				if ((v189 == (1 + 0)) or ((3336 - 2346) > (2225 - (316 + 289)))) then
					if (v98.LightsJudgment:IsCastable() or ((2295 - 1418) > (217 + 4478))) then
						if (((4144 - (666 + 787)) >= (2276 - (360 + 65))) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (v98.Fireblood:IsCastable() or ((2790 + 195) >= (5110 - (79 + 175)))) then
						if (((6742 - 2466) >= (933 + 262)) and v24(v98.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v189 = 5 - 3;
				end
				if (((6223 - 2991) <= (5589 - (503 + 396))) and ((183 - (92 + 89)) == v189)) then
					if (v98.AncestralCall:IsCastable() or ((1737 - 841) >= (1614 + 1532))) then
						if (((1812 + 1249) >= (11583 - 8625)) and v24(v98.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
				if (((436 + 2751) >= (1467 - 823)) and (v189 == (0 + 0))) then
					if (((308 + 336) <= (2144 - 1440)) and v98.BloodFury:IsCastable()) then
						if (((120 + 838) > (1443 - 496)) and v24(v98.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((5736 - (485 + 759)) >= (6140 - 3486)) and v98.Berserking:IsCastable()) then
						if (((4631 - (442 + 747)) >= (2638 - (832 + 303))) and v24(v98.Berserking)) then
							return "berserking cd 12";
						end
					end
					v189 = 947 - (88 + 858);
				end
			end
		end
	end
	local function v123()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1 + 0)) or ((131 + 3039) <= (2253 - (766 + 23)))) then
				if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (148 - 118)) and (v103 >= (2 - 0))) or ((12638 - 7841) == (14892 - 10504))) then
					if (((1624 - (1036 + 37)) <= (483 + 198)) and v24(v98.ArcaneExplosion, not v15:IsInRange(15 - 7))) then
						return "arcane_explosion movement";
					end
				end
				if (((2578 + 699) > (1887 - (641 + 839))) and v98.FireBlast:IsCastable() and v40) then
					if (((5608 - (910 + 3)) >= (3607 - 2192)) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v138 = 1686 - (1466 + 218);
			end
			if ((v138 == (0 + 0)) or ((4360 - (556 + 592)) <= (336 + 608))) then
				if ((v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or ((3904 - (329 + 479)) <= (2652 - (174 + 680)))) then
					if (((12153 - 8616) == (7331 - 3794)) and v24(v98.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if (((2740 + 1097) >= (2309 - (396 + 343))) and v98.IceNova:IsCastable() and v48) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((262 + 2688) == (5289 - (29 + 1448)))) then
						return "ice_nova movement";
					end
				end
				v138 = 1390 - (135 + 1254);
			end
			if (((17792 - 13069) >= (10823 - 8505)) and (v138 == (2 + 0))) then
				if ((v98.IceLance:IsCastable() and v47) or ((3554 - (389 + 1138)) > (3426 - (102 + 472)))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((1073 + 63) > (2394 + 1923))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((6293 - (320 + 1225)) == (8452 - 3704)) and (v139 == (2 + 1))) then
				if (((5200 - (157 + 1307)) <= (6599 - (821 + 1038))) and v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((8458 - 5068) <= (335 + 2725))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v102 >= (6 - 2)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) or ((372 + 627) > (6674 - 3981))) then
					if (((1489 - (834 + 192)) < (39 + 562)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v98.DragonsBreath:IsCastable() and v39 and (v103 >= (2 + 5))) or ((47 + 2136) < (1063 - 376))) then
					if (((4853 - (300 + 4)) == (1215 + 3334)) and v24(v98.DragonsBreath, not v15:IsInRange(26 - 16))) then
						return "dragons_breath aoe 26";
					end
				end
				if (((5034 - (112 + 250)) == (1863 + 2809)) and v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (75 - 45)) and (v103 >= (5 + 2))) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(5 + 3)) or ((2744 + 924) < (196 + 199))) then
						return "arcane_explosion aoe 28";
					end
				end
				v139 = 3 + 1;
			end
			if ((v139 == (1418 - (1001 + 413))) or ((9290 - 5124) == (1337 - (244 + 638)))) then
				if ((v98.Frostbolt:IsCastable() and v41) or ((5142 - (627 + 66)) == (7934 - 5271))) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((4879 - (512 + 90)) < (4895 - (1665 + 241)))) then
						return "frostbolt aoe 32";
					end
				end
				if ((v14:IsMoving() and v94) or ((1587 - (373 + 344)) >= (1872 + 2277))) then
					v31 = v123();
					if (((586 + 1626) < (8395 - 5212)) and v31) then
						return v31;
					end
				end
				break;
			end
			if (((7861 - 3215) > (4091 - (35 + 1064))) and (v139 == (0 + 0))) then
				if (((3067 - 1633) < (13 + 3093)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1237 - (298 + 938), v98.CometStorm) or (v14:PrevGCDP(1260 - (233 + 1026), v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
					if (((2452 - (636 + 1030)) < (1546 + 1477)) and v24(v98.ConeofCold, not v15:IsInRange(8 + 0))) then
						return "cone_of_cold aoe 2";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1 + 0, v98.GlacialSpike) or not v114())) or ((165 + 2277) < (295 - (55 + 166)))) then
					if (((879 + 3656) == (457 + 4078)) and v24(v100.FrozenOrbCast, not v15:IsInRange(152 - 112))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(298 - (36 + 261), v98.GlacialSpike) or not v114())) or ((5261 - 2252) <= (3473 - (34 + 1334)))) then
					if (((704 + 1126) < (2851 + 818)) and v24(v100.BlizzardCursor, not v15:IsInRange(1323 - (1035 + 248)))) then
						return "blizzard aoe 6";
					end
				end
				if ((v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(22 - (20 + 1), v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (14 + 11))) or (v98.ConeofCold:CooldownRemains() > (339 - (134 + 185))))) or ((2563 - (549 + 584)) >= (4297 - (314 + 371)))) then
					if (((9210 - 6527) >= (3428 - (478 + 490))) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (1174 - (786 + 386))) or ((5843 - 4039) >= (4654 - (1055 + 324)))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((2757 - (1093 + 247)) > (3225 + 404))) then
					if (((505 + 4290) > (1596 - 1194)) and v24(v98.ShiftingPower, not v15:IsInRange(135 - 95), true)) then
						return "shifting_power aoe 16";
					end
				end
				if (((13695 - 8882) > (8958 - 5393)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (2 + 3)) and (v98.Blizzard:CooldownRemains() > v111)) then
					if (((15070 - 11158) == (13483 - 9571)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((2128 + 693) <= (12336 - 7512)) and v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (688 - (364 + 324))) and (v14:PrevGCDP(2 - 1, v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (2.8 - 1)))) then
					if (((577 + 1161) <= (9184 - 6989)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 20";
					end
				end
				if (((65 - 24) <= (9165 - 6147)) and v98.Flurry:IsCastable() and v43 and (v106 == (1268 - (1249 + 19))) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if (((1937 + 208) <= (15974 - 11870)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 21";
					end
				end
				v139 = 1089 - (686 + 400);
			end
			if (((2110 + 579) < (5074 - (73 + 156))) and (v139 == (1 + 0))) then
				if ((v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (811 - (721 + 90))) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or ((7539 - 5217) > (3092 - (224 + 246)))) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or ((7344 - 2810) == (3833 - 1751))) then
						return "freeze aoe 10";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and (v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) or ((3123 - 1552) > (6212 - 4345))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((3167 - (203 + 310)) >= (4989 - (1238 + 755)))) then
						return "ice_nova aoe 11";
					end
				end
				if (((278 + 3700) > (3638 - (709 + 825))) and v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1 - 0, v98.Freeze) and ((v14:PrevGCDP(1 - 0, v98.GlacialSpike) and (v106 == (864 - (196 + 668)))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (3 - 2))))) then
					if (((6203 - 3208) > (2374 - (171 + 662))) and v24(v98.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if (((3342 - (4 + 89)) > (3339 - 2386)) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) then
					if (v24(v98.ConeofCold, not v15:IsInRange(3 + 5)) or ((14375 - 11102) > (1794 + 2779))) then
						return "cone_of_cold aoe 14";
					end
				end
				v139 = 1488 - (35 + 1451);
			end
		end
	end
	local function v125()
		if ((v98.CometStorm:IsCastable() and (v14:PrevGCDP(1454 - (28 + 1425), v98.Flurry) or v14:PrevGCDP(1994 - (941 + 1052), v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) or ((3022 + 129) < (2798 - (822 + 692)))) then
			if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((2641 - 791) == (721 + 808))) then
				return "comet_storm cleave 2";
			end
		end
		if (((1118 - (45 + 252)) < (2101 + 22)) and v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v98.Frostbolt) and (v107 >= (7 - 4))) or v14:PrevGCDP(434 - (114 + 319), v98.GlacialSpike) or ((v107 >= (3 - 0)) and (v107 < (6 - 1)) and (v98.Flurry:ChargesFractional() == (2 + 0))))) then
			local v190 = 0 - 0;
			while true do
				if (((1889 - 987) < (4288 - (556 + 1407))) and (v190 == (1206 - (741 + 465)))) then
					if (((1323 - (170 + 295)) <= (1561 + 1401)) and v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry cleave 4";
					end
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((3625 + 321) < (3170 - 1882))) then
						return "flurry cleave 4";
					end
					break;
				end
			end
		end
		if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (0 + 0)) and (v107 == (3 + 1)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((1836 + 1406) == (1797 - (957 + 273)))) then
			if (v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance)) or ((227 + 620) >= (506 + 757))) then
				return "ice_lance cleave 6";
			end
			if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((8584 - 6331) == (4877 - 3026))) then
				return "ice_lance cleave 6";
			end
		end
		if ((v98.RayofFrost:IsCastable() and (v106 == (2 - 1)) and v49) or ((10334 - 8247) > (4152 - (389 + 1391)))) then
			if (v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v15:IsSpellInRange(v98.RayofFrost)) or ((2789 + 1656) < (432 + 3717))) then
				return "ray_of_frost cleave 8";
			end
			if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((4138 - 2320) == (1036 - (783 + 168)))) then
				return "ray_of_frost cleave 8";
			end
		end
		if (((2114 - 1484) < (2093 + 34)) and v98.GlacialSpike:IsReady() and v45 and (v107 == (316 - (309 + 2))) and (v98.Flurry:CooldownUp() or (v106 > (0 - 0)))) then
			if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((3150 - (1090 + 122)) == (816 + 1698))) then
				return "glacial_spike cleave 10";
			end
		end
		if (((14290 - 10035) >= (38 + 17)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1120 - (628 + 490))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
			if (((538 + 2461) > (2861 - 1705)) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
				return "frozen_orb cleave 12";
			end
		end
		if (((10739 - 8389) > (1929 - (431 + 343))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (20 - 10)) and (v98.FrozenOrb:CooldownRemains() > (28 - 18)) and (v106 == (0 + 0)) and (v103 >= (1 + 2))) then
			if (((5724 - (556 + 1139)) <= (4868 - (6 + 9))) and v24(v98.ConeofCold)) then
				return "cone_of_cold cleave 14";
			end
		end
		if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (2 + 1)))) or ((685 - (28 + 141)) > (1331 + 2103))) then
			if (((4994 - 948) >= (2149 + 884)) and v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard))) then
				return "blizzard cleave 16";
			end
		end
		if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (1327 - (486 + 831))) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (26 - 16))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (35 - 25)))) or (v98.IcyVeins:CooldownRemains() < (4 + 16)))) or ((8597 - 5878) <= (2710 - (668 + 595)))) then
			if (v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true) or ((3720 + 414) < (792 + 3134))) then
				return "shifting_power cleave 18";
			end
		end
		if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (13 - 8))) or ((454 - (23 + 267)) >= (4729 - (1129 + 815)))) then
			if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((912 - (371 + 16)) == (3859 - (1326 + 424)))) then
				return "glacial_spike cleave 20";
			end
		end
		if (((61 - 28) == (120 - 87)) and v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(119 - (88 + 30), v98.GlacialSpike)) or (v106 > (771 - (720 + 51))))) then
			local v191 = 0 - 0;
			while true do
				if (((4830 - (421 + 1355)) <= (6623 - 2608)) and ((0 + 0) == v191)) then
					if (((2954 - (286 + 797)) < (12363 - 8981)) and v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					if (((2140 - 847) <= (2605 - (397 + 42))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance cleave 22";
					end
					break;
				end
			end
		end
		if ((v98.IceNova:IsCastable() and v48 and (v103 >= (2 + 2))) or ((3379 - (24 + 776)) < (189 - 66))) then
			if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((1631 - (222 + 563)) >= (5217 - 2849))) then
				return "ice_nova cleave 24";
			end
		end
		if ((v98.Frostbolt:IsCastable() and v41) or ((2889 + 1123) <= (3548 - (23 + 167)))) then
			if (((3292 - (690 + 1108)) <= (1085 + 1920)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
				return "frostbolt cleave 26";
			end
		end
		if ((v14:IsMoving() and v94) or ((2567 + 544) == (2982 - (40 + 808)))) then
			v31 = v123();
			if (((388 + 1967) == (9005 - 6650)) and v31) then
				return v31;
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (0 + 0)) or ((323 + 265) <= (1003 - (47 + 524)))) then
				if (((3114 + 1683) >= (10647 - 6752)) and v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1 - 0, v98.Flurry) or v14:PrevGCDP(2 - 1, v98.ConeofCold))) then
					if (((5303 - (1165 + 561)) == (107 + 3470)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((11750 - 7956) > (1410 + 2283)) and v98.Flurry:IsCastable() and (v106 == (479 - (341 + 138))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1 + 0, v98.Frostbolt) and (v107 >= (5 - 2))) or (v14:PrevGCDP(327 - (89 + 237), v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(3 - 2, v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (8 - 4)) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((2156 - (581 + 300)) == (5320 - (855 + 365)))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 - 0)) and (v107 == (2 + 2)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((2826 - (1030 + 205)) >= (3361 + 219))) then
					if (((915 + 68) <= (2094 - (156 + 130))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v140 = 2 - 1;
			end
			if ((v140 == (2 - 0)) or ((4403 - 2253) <= (316 + 881))) then
				if (((2198 + 1571) >= (1242 - (10 + 59))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (3 + 7)) and (v98.FrozenOrb:CooldownRemains() > (49 - 39)) and (v106 == (1163 - (671 + 492))) and (v102 >= (3 + 0))) then
					if (((2700 - (369 + 846)) == (394 + 1091)) and v24(v98.ConeofCold, not v15:IsInRange(7 + 1))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v102 >= (1947 - (1036 + 909))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (3 + 0)))) or ((5565 - 2250) <= (2985 - (11 + 192)))) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(21 + 19)) or ((1051 - (135 + 40)) >= (7181 - 4217))) then
						return "blizzard single 16";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 + 0)) and (((v98.FrozenOrb:CooldownRemains() > (22 - 12)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (14 - 4))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (186 - (50 + 126))))) or (v98.IcyVeins:CooldownRemains() < (55 - 35)))) or ((495 + 1737) > (3910 - (1233 + 180)))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(1009 - (522 + 447))) or ((3531 - (107 + 1314)) <= (155 + 177))) then
						return "shifting_power single 18";
					end
				end
				v140 = 8 - 5;
			end
			if (((1566 + 2120) > (6298 - 3126)) and (v140 == (11 - 8))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (1915 - (716 + 1194)))) or ((77 + 4397) < (88 + 732))) then
					if (((4782 - (74 + 429)) >= (5559 - 2677)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((4644 - 2615) >= (2492 + 1029))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((6279 - 4242) >= (11477 - 6835))) then
						return "ice_lance single 22";
					end
				end
				if (((2153 - (279 + 154)) < (5236 - (454 + 324))) and v98.IceNova:IsCastable() and v48 and (v103 >= (4 + 0))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((453 - (12 + 5)) > (1629 + 1392))) then
						return "ice_nova single 24";
					end
				end
				v140 = 10 - 6;
			end
			if (((264 + 449) <= (1940 - (277 + 816))) and (v140 == (17 - 13))) then
				if (((3337 - (1058 + 125)) <= (756 + 3275)) and v89 and ((v92 and v34) or not v92)) then
					if (((5590 - (815 + 160)) == (19801 - 15186)) and v98.BagofTricks:IsCastable()) then
						if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or ((8996 - 5206) == (120 + 380))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((260 - 171) < (2119 - (41 + 1857))) and v98.Frostbolt:IsCastable() and v41) then
					if (((3947 - (1222 + 671)) >= (3672 - 2251)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if (((994 - 302) < (4240 - (229 + 953))) and v14:IsMoving() and v94) then
					local v211 = 1774 - (1111 + 663);
					while true do
						if (((1579 - (874 + 705)) == v211) or ((456 + 2798) == (1130 + 525))) then
							v31 = v123();
							if (v31 or ((2693 - 1397) == (139 + 4771))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4047 - (642 + 37)) == (768 + 2600)) and (v140 == (1 + 0))) then
				if (((6635 - 3992) < (4269 - (233 + 221))) and v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (2 - 1))) then
					if (((1684 + 229) > (2034 - (718 + 823))) and v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				if (((2993 + 1762) > (4233 - (266 + 539))) and v98.GlacialSpike:IsReady() and v45 and (v107 == (13 - 8)) and ((v98.Flurry:Charges() >= (1226 - (636 + 589))) or ((v106 > (0 - 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) then
					if (((2848 - 1467) <= (1878 + 491)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 + 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (1017 - (657 + 358))) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((12823 - 7980) == (9304 - 5220))) then
					if (((5856 - (1151 + 36)) > (351 + 12)) and v24(v100.FrozenOrbCast, not v15:IsInRange(11 + 29))) then
						return "frozen_orb single 12";
					end
				end
				v140 = 5 - 3;
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
		v69 = EpicSettings.Settings['alterTimeHP'] or (1832 - (1552 + 280));
		v70 = EpicSettings.Settings['iceBarrierHP'] or (834 - (64 + 770));
		v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v74 = EpicSettings.Settings['mirrorImageHP'] or (1243 - (157 + 1086));
		v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v93 = EpicSettings.Settings['useSpellStealTarget'];
		v94 = EpicSettings.Settings['useSpellsWhileMoving'];
		v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v96 = EpicSettings.Settings['mirrorImageBeforePull'];
		v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v128()
		local v179 = 0 - 0;
		while true do
			if ((v179 == (5 - 1)) or ((2561 - 684) >= (3957 - (599 + 220)))) then
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((9442 - 4700) >= (5557 - (1813 + 118))) and ((0 + 0) == v179)) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (1217 - (841 + 376));
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v179 = 1 - 0;
			end
			if (((1 + 1) == v179) or ((12392 - 7852) == (1775 - (464 + 395)))) then
				v91 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['useHealingPotion'];
				v179 = 7 - 4;
			end
			if (((1 + 0) == v179) or ((1993 - (467 + 370)) > (8978 - 4633))) then
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v90 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v179 = 2 + 0;
			end
			if (((7668 - 5431) < (663 + 3586)) and ((6 - 3) == v179)) then
				v87 = EpicSettings.Settings['healthstoneHP'] or (520 - (150 + 370));
				v86 = EpicSettings.Settings['healingPotionHP'] or (1282 - (74 + 1208));
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v179 = 9 - 5;
			end
		end
	end
	local function v129()
		v127();
		v128();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (v14:IsDeadOrGhost() or ((12724 - 10041) < (17 + 6))) then
			return v31;
		end
		v104 = v15:GetEnemiesInSplashRange(395 - (14 + 376));
		v105 = v14:GetEnemiesInRange(69 - 29);
		if (((452 + 245) <= (726 + 100)) and v33) then
			local v192 = 0 + 0;
			while true do
				if (((3237 - 2132) <= (885 + 291)) and (v192 == (78 - (23 + 55)))) then
					v102 = v30(v15:GetEnemiesInSplashRangeCount(11 - 6), #v105);
					v103 = v30(v15:GetEnemiesInSplashRangeCount(4 + 1), #v105);
					break;
				end
			end
		else
			local v193 = 0 + 0;
			while true do
				if (((5238 - 1859) <= (1200 + 2612)) and ((901 - (652 + 249)) == v193)) then
					v102 = 2 - 1;
					v103 = 1869 - (708 + 1160);
					break;
				end
			end
		end
		if (not v14:AffectingCombat() or ((2138 - 1350) >= (2946 - 1330))) then
			if (((1881 - (10 + 17)) <= (759 + 2620)) and v98.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
				if (((6281 - (1400 + 332)) == (8724 - 4175)) and v24(v98.ArcaneIntellect)) then
					return "arcane_intellect";
				end
			end
		end
		if (v112.TargetIsValid() or v14:AffectingCombat() or ((4930 - (242 + 1666)) >= (1295 + 1729))) then
			local v194 = 0 + 0;
			while true do
				if (((4108 + 712) > (3138 - (850 + 90))) and (v194 == (1 - 0))) then
					if ((v110 == (12501 - (360 + 1030))) or ((939 + 122) >= (13804 - 8913))) then
						v110 = v10.FightRemains(v105, false);
					end
					v106 = v15:DebuffStack(v98.WintersChillDebuff);
					v194 = 2 - 0;
				end
				if (((3025 - (909 + 752)) <= (5696 - (109 + 1114))) and (v194 == (3 - 1))) then
					v107 = v14:BuffStackP(v98.IciclesBuff);
					v111 = v14:GCD();
					break;
				end
				if (((0 + 0) == v194) or ((3837 - (6 + 236)) <= (2 + 1))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v194 = 1 + 0;
				end
			end
		end
		if (v112.TargetIsValid() or ((11017 - 6345) == (6728 - 2876))) then
			if (((2692 - (1076 + 57)) == (257 + 1302)) and v16) then
				if (v77 or ((2441 - (579 + 110)) <= (63 + 725))) then
					local v212 = 0 + 0;
					while true do
						if ((v212 == (0 + 0)) or ((4314 - (174 + 233)) == (494 - 317))) then
							v31 = v119();
							if (((6090 - 2620) > (247 + 308)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if ((not v14:AffectingCombat() and v32) or ((2146 - (663 + 511)) == (576 + 69))) then
				local v208 = 0 + 0;
				while true do
					if (((9809 - 6627) >= (1281 + 834)) and ((0 - 0) == v208)) then
						v31 = v121();
						if (((9424 - 5531) < (2114 + 2315)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
			v31 = v118();
			if (v31 or ((5579 - 2712) < (1358 + 547))) then
				return v31;
			end
			if (v14:AffectingCombat() or v77 or ((165 + 1631) >= (4773 - (478 + 244)))) then
				local v209 = v77 and v98.RemoveCurse:IsReady() and v35;
				v31 = v112.FocusUnit(v209, v100, 537 - (440 + 77), nil, 10 + 10);
				if (((5925 - 4306) <= (5312 - (655 + 901))) and v31) then
					return v31;
				end
			end
			if (((113 + 491) == (463 + 141)) and v78) then
				if (v97 or ((3028 + 1456) == (3625 - 2725))) then
					v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 1475 - (695 + 750));
					if (v31 or ((15225 - 10766) <= (1716 - 603))) then
						return v31;
					end
				end
			end
			if (((14606 - 10974) > (3749 - (285 + 66))) and v79) then
				v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 69 - 39, true);
				if (((5392 - (682 + 628)) <= (793 + 4124)) and v31) then
					return v31;
				end
			end
			if (((5131 - (176 + 123)) >= (580 + 806)) and v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) then
				if (((100 + 37) == (406 - (239 + 30))) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((427 + 1143) >= (4164 + 168))) then
				if (v34 or ((7192 - 3128) <= (5674 - 3855))) then
					local v213 = 315 - (306 + 9);
					while true do
						if ((v213 == (0 - 0)) or ((868 + 4118) < (966 + 608))) then
							v31 = v122();
							if (((2131 + 2295) > (491 - 319)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				if (((1961 - (1140 + 235)) > (290 + 165)) and v33 and (((v103 >= (7 + 0)) and not v14:HasTier(8 + 22, 54 - (33 + 19))) or ((v103 >= (2 + 1)) and v98.IceCaller:IsAvailable()))) then
					v31 = v124();
					if (((2475 - 1649) == (364 + 462)) and v31) then
						return v31;
					end
					if (v24(v98.Pool) or ((7881 - 3862) > (4165 + 276))) then
						return "pool for Aoe()";
					end
				end
				if (((2706 - (586 + 103)) < (388 + 3873)) and v33 and (v103 == (5 - 3))) then
					v31 = v125();
					if (((6204 - (1309 + 179)) > (144 - 64)) and v31) then
						return v31;
					end
					if (v24(v98.Pool) or ((1527 + 1980) == (8787 - 5515))) then
						return "pool for Cleave()";
					end
				end
				v31 = v126();
				if (v31 or ((662 + 214) >= (6533 - 3458))) then
					return v31;
				end
				if (((8671 - 4319) > (3163 - (295 + 314))) and v24(v98.Pool)) then
					return "pool for ST()";
				end
				if (v94 or ((10821 - 6415) < (6005 - (1300 + 662)))) then
					local v214 = 0 - 0;
					while true do
						if ((v214 == (1755 - (1178 + 577))) or ((982 + 907) >= (10000 - 6617))) then
							v31 = v123();
							if (((3297 - (851 + 554)) <= (2418 + 316)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v130()
		local v184 = 0 - 0;
		while true do
			if (((4176 - 2253) < (2520 - (115 + 187))) and (v184 == (0 + 0))) then
				v113();
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(61 + 3, v129, v130);
end;
return v0["Epix_Mage_Frost.lua"]();

