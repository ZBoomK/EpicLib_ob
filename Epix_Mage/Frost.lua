local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((545 + 91) == (7838 - 5936))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.MouseOver;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.PressCursor;
	local v25 = v21.Macro;
	local v26 = v21.Bind;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = math.max;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35;
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
	local v97 = v18.Mage.Frost;
	local v98 = v20.Mage.Frost;
	local v99 = v25.Mage.Frost;
	local v100 = {};
	local v101, v102;
	local v103, v104;
	local v105 = 0 - 0;
	local v106 = 0 - 0;
	local v107 = 13 + 2;
	local v108 = 38947 - 27836;
	local v109 = 32052 - 20941;
	local v110;
	local v111 = v21.Commons.Everyone;
	local function v112()
		if (v97.RemoveCurse:IsAvailable() or ((7799 - 2960) <= (10139 - 6859))) then
			v111.DispellableDebuffs = v111.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v97.FrozenOrb:RegisterInFlightEffect(85969 - (111 + 1137));
	v97.FrozenOrb:RegisterInFlight();
	v9:RegisterForEvent(function()
		v97.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v97.Frostbolt:RegisterInFlightEffect(228755 - (91 + 67));
	v97.Frostbolt:RegisterInFlight();
	v97.Flurry:RegisterInFlightEffect(679638 - 451284);
	v97.Flurry:RegisterInFlight();
	v97.IceLance:RegisterInFlightEffect(57037 + 171561);
	v97.IceLance:RegisterInFlight();
	v97.GlacialSpike:RegisterInFlightEffect(229123 - (423 + 100));
	v97.GlacialSpike:RegisterInFlight();
	v9:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 - 0)) or ((1915 + 1759) <= (2733 - (326 + 445)))) then
				v108 = 48488 - 37377;
				v109 = 24753 - 13642;
				v130 = 2 - 1;
			end
			if ((v130 == (712 - (530 + 181))) or ((2775 - (614 + 267)) < (1438 - (19 + 13)))) then
				v105 = 0 - 0;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113(v131)
		if (((3662 - 2090) >= (4373 - 2842)) and (v131 == nil)) then
			v131 = v14;
		end
		return not v131:IsInBossList() or (v131:Level() < (19 + 54));
	end
	local function v114()
		return v29(v13:BuffRemains(v97.FingersofFrostBuff), v14:DebuffRemains(v97.WintersChillDebuff), v14:DebuffRemains(v97.Frostbite), v14:DebuffRemains(v97.Freeze), v14:DebuffRemains(v97.FrostNova));
	end
	local function v115(v132)
		return (v132:DebuffStack(v97.WintersChillDebuff));
	end
	local function v116(v133)
		return (v133:DebuffDown(v97.WintersChillDebuff));
	end
	local function v117()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (3 - 1)) or ((6499 - (1293 + 519)) < (9266 - 4724))) then
				if (((8592 - 5301) > (3187 - 1520)) and v97.MirrorImage:IsCastable() and v67 and (v13:HealthPercentage() <= v73)) then
					if (v23(v97.MirrorImage) or ((3764 - 2891) == (4791 - 2757))) then
						return "mirror_image defensive 5";
					end
				end
				if ((v97.GreaterInvisibility:IsReady() and v63 and (v13:HealthPercentage() <= v70)) or ((1492 + 1324) < (3 + 8))) then
					if (((8594 - 4895) < (1088 + 3618)) and v23(v97.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v134 = 1 + 2;
			end
			if (((1654 + 992) >= (1972 - (709 + 387))) and (v134 == (1859 - (673 + 1185)))) then
				if (((1780 - 1166) <= (10224 - 7040)) and v97.IceColdTalent:IsAvailable() and v97.IceColdAbility:IsCastable() and v65 and (v13:HealthPercentage() <= v72)) then
					if (((5142 - 2016) == (2236 + 890)) and v23(v97.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v97.IceBlock:IsReady() and v64 and (v13:HealthPercentage() <= v71)) or ((1635 + 552) >= (6688 - 1734))) then
					if (v23(v97.IceBlock) or ((953 + 2924) == (7128 - 3553))) then
						return "ice_block defensive 4";
					end
				end
				v134 = 3 - 1;
			end
			if (((2587 - (446 + 1434)) > (1915 - (1040 + 243))) and ((8 - 5) == v134)) then
				if ((v97.AlterTime:IsReady() and v61 and (v13:HealthPercentage() <= v68)) or ((2393 - (559 + 1288)) >= (4615 - (609 + 1322)))) then
					if (((1919 - (13 + 441)) <= (16072 - 11771)) and v23(v97.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if (((4463 - 2759) > (7097 - 5672)) and v98.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v86)) then
					if (v23(v99.Healthstone) or ((26 + 661) == (15376 - 11142))) then
						return "healthstone defensive";
					end
				end
				v134 = 2 + 2;
			end
			if ((v134 == (0 + 0)) or ((9881 - 6551) < (782 + 647))) then
				if (((2109 - 962) >= (222 + 113)) and v97.IceBarrier:IsCastable() and v62 and v13:BuffDown(v97.IceBarrier) and (v13:HealthPercentage() <= v69)) then
					if (((1911 + 1524) > (1507 + 590)) and v23(v97.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v97.MassBarrier:IsCastable() and v66 and v13:BuffDown(v97.IceBarrier) and v111.AreUnitsBelowHealthPercentage(v74, 2 + 0)) or ((3689 + 81) >= (4474 - (153 + 280)))) then
					if (v23(v97.MassBarrier) or ((10946 - 7155) <= (1447 + 164))) then
						return "mass_barrier defensive 2";
					end
				end
				v134 = 1 + 0;
			end
			if ((v134 == (3 + 1)) or ((4155 + 423) <= (1456 + 552))) then
				if (((1713 - 588) <= (1284 + 792)) and v83 and (v13:HealthPercentage() <= v85)) then
					if ((v87 == "Refreshing Healing Potion") or ((1410 - (89 + 578)) >= (3143 + 1256))) then
						if (((2400 - 1245) < (2722 - (572 + 477))) and v98.RefreshingHealingPotion:IsReady()) then
							if (v23(v99.RefreshingHealingPotion) or ((314 + 2010) <= (347 + 231))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((450 + 3317) == (3853 - (84 + 2))) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((6738 - 2649) == (2946 + 1143)) and v98.DreamwalkersHealingPotion:IsReady()) then
							if (((5300 - (497 + 345)) >= (43 + 1631)) and v23(v99.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		if (((165 + 807) <= (2751 - (605 + 728))) and v97.RemoveCurse:IsReady() and v34 and v111.DispellableFriendlyUnit(15 + 5)) then
			if (v23(v99.RemoveCurseFocus) or ((10978 - 6040) < (219 + 4543))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v119()
		v30 = v111.HandleTopTrinket(v100, v33, 147 - 107, nil);
		if (v30 or ((2258 + 246) > (11813 - 7549))) then
			return v30;
		end
		v30 = v111.HandleBottomTrinket(v100, v33, 31 + 9, nil);
		if (((2642 - (457 + 32)) == (914 + 1239)) and v30) then
			return v30;
		end
	end
	local function v120()
		if (v111.TargetIsValid() or ((1909 - (832 + 570)) >= (2441 + 150))) then
			local v145 = 0 + 0;
			while true do
				if (((15857 - 11376) == (2159 + 2322)) and (v145 == (796 - (588 + 208)))) then
					if ((v97.MirrorImage:IsCastable() and v67 and v95) or ((6274 - 3946) < (2493 - (884 + 916)))) then
						if (((9060 - 4732) == (2510 + 1818)) and v23(v97.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if (((2241 - (232 + 421)) >= (3221 - (1569 + 320))) and v97.Frostbolt:IsCastable() and not v13:IsCasting(v97.Frostbolt)) then
						if (v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt)) or ((1025 + 3149) > (808 + 3440))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		local v135 = 0 - 0;
		local v136;
		while true do
			if ((v135 == (605 - (316 + 289))) or ((12004 - 7418) <= (4 + 78))) then
				if (((5316 - (666 + 787)) == (4288 - (360 + 65))) and v94 and v97.TimeWarp:IsCastable() and v13:BloodlustExhaustUp() and v97.TemporalWarp:IsAvailable() and v13:BloodlustDown() and v13:PrevGCDP(1 + 0, v97.IcyVeins)) then
					if (v23(v97.TimeWarp, not v14:IsInRange(294 - (79 + 175))) or ((444 - 162) <= (33 + 9))) then
						return "time_warp cd 2";
					end
				end
				v136 = v111.HandleDPSPotion(v13:BuffUp(v97.IcyVeinsBuff));
				v135 = 2 - 1;
			end
			if (((8875 - 4266) >= (1665 - (503 + 396))) and (v135 == (182 - (92 + 89)))) then
				if (v136 or ((2234 - 1082) == (1276 + 1212))) then
					return v136;
				end
				if (((2026 + 1396) > (13119 - 9769)) and v97.IcyVeins:IsCastable() and v33 and v51 and v56 and (v82 < v109)) then
					if (((120 + 757) > (857 - 481)) and v23(v97.IcyVeins)) then
						return "icy_veins cd 6";
					end
				end
				v135 = 2 + 0;
			end
			if ((v135 == (1 + 1)) or ((9496 - 6378) <= (232 + 1619))) then
				if ((v82 < v109) or ((251 - 86) >= (4736 - (485 + 759)))) then
					if (((9137 - 5188) < (6045 - (442 + 747))) and v89 and ((v33 and v90) or not v90)) then
						v30 = v119();
						if (v30 or ((5411 - (832 + 303)) < (3962 - (88 + 858)))) then
							return v30;
						end
					end
				end
				if (((1430 + 3260) > (3414 + 711)) and v88 and ((v91 and v33) or not v91) and (v82 < v109)) then
					local v202 = 0 + 0;
					while true do
						if (((791 - (766 + 23)) == v202) or ((246 - 196) >= (1224 - 328))) then
							if (v97.AncestralCall:IsCastable() or ((4515 - 2801) >= (10039 - 7081))) then
								if (v23(v97.AncestralCall) or ((2564 - (1036 + 37)) < (457 + 187))) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((1370 - 666) < (777 + 210)) and ((1481 - (641 + 839)) == v202)) then
							if (((4631 - (910 + 3)) > (4858 - 2952)) and v97.LightsJudgment:IsCastable()) then
								if (v23(v97.LightsJudgment, not v14:IsSpellInRange(v97.LightsJudgment)) or ((2642 - (1466 + 218)) > (1671 + 1964))) then
									return "lights_judgment cd 14";
								end
							end
							if (((4649 - (556 + 592)) <= (1598 + 2894)) and v97.Fireblood:IsCastable()) then
								if (v23(v97.Fireblood) or ((4250 - (329 + 479)) < (3402 - (174 + 680)))) then
									return "fireblood cd 16";
								end
							end
							v202 = 6 - 4;
						end
						if (((5958 - 3083) >= (1046 + 418)) and (v202 == (739 - (396 + 343)))) then
							if (v97.BloodFury:IsCastable() or ((425 + 4372) >= (6370 - (29 + 1448)))) then
								if (v23(v97.BloodFury) or ((1940 - (135 + 1254)) > (7790 - 5722))) then
									return "blood_fury cd 10";
								end
							end
							if (((9870 - 7756) > (630 + 314)) and v97.Berserking:IsCastable()) then
								if (v23(v97.Berserking) or ((3789 - (389 + 1138)) >= (3670 - (102 + 472)))) then
									return "berserking cd 12";
								end
							end
							v202 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (2 + 0)) or ((3800 - (320 + 1225)) >= (6295 - 2758))) then
				if ((v97.IceLance:IsCastable() and v46) or ((2348 + 1489) < (2770 - (157 + 1307)))) then
					if (((4809 - (821 + 1038)) == (7360 - 4410)) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if ((v137 == (0 + 0)) or ((8388 - 3665) < (1228 + 2070))) then
				if (((2815 - 1679) >= (1180 - (834 + 192))) and v97.IceFloes:IsCastable() and v45 and v13:BuffDown(v97.IceFloes)) then
					if (v23(v97.IceFloes) or ((18 + 253) > (1219 + 3529))) then
						return "ice_floes movement";
					end
				end
				if (((102 + 4638) >= (4882 - 1730)) and v97.IceNova:IsCastable() and v47) then
					if (v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova)) or ((2882 - (300 + 4)) >= (906 + 2484))) then
						return "ice_nova movement";
					end
				end
				v137 = 2 - 1;
			end
			if (((403 - (112 + 250)) <= (663 + 998)) and ((2 - 1) == v137)) then
				if (((345 + 256) < (1842 + 1718)) and v97.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (23 + 7)) and (v102 >= (1 + 1))) then
					if (((175 + 60) < (2101 - (1001 + 413))) and v23(v97.ArcaneExplosion, not v14:IsInRange(17 - 9))) then
						return "arcane_explosion movement";
					end
				end
				if (((5431 - (244 + 638)) > (1846 - (627 + 66))) and v97.FireBlast:IsCastable() and v39) then
					if (v23(v97.FireBlast, not v14:IsSpellInRange(v97.FireBlast)) or ((13926 - 9252) < (5274 - (512 + 90)))) then
						return "fire_blast movement";
					end
				end
				v137 = 1908 - (1665 + 241);
			end
		end
	end
	local function v123()
		local v138 = 717 - (373 + 344);
		while true do
			if (((1655 + 2013) < (1207 + 3354)) and (v138 == (7 - 4))) then
				if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (8 - 3)) and (v97.Blizzard:CooldownRemains() > v110)) or ((1554 - (35 + 1064)) == (2623 + 982))) then
					if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((5697 - 3034) == (14 + 3298))) then
						return "glacial_spike aoe 18";
					end
				end
				if (((5513 - (298 + 938)) <= (5734 - (233 + 1026))) and v97.Flurry:IsCastable() and v42 and not v113() and (v105 == (1666 - (636 + 1030))) and (v13:PrevGCDP(1 + 0, v97.GlacialSpike) or (v97.Flurry:ChargesFractional() > (1.8 + 0)))) then
					if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((259 + 611) == (81 + 1108))) then
						return "flurry aoe 20";
					end
				end
				if (((1774 - (55 + 166)) <= (608 + 2525)) and v97.Flurry:IsCastable() and v42 and (v105 == (0 + 0)) and (v13:BuffUp(v97.BrainFreezeBuff) or v13:BuffUp(v97.FingersofFrostBuff))) then
					if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((8543 - 6306) >= (3808 - (36 + 261)))) then
						return "flurry aoe 21";
					end
				end
				v138 = 6 - 2;
			end
			if ((v138 == (1373 - (34 + 1334))) or ((509 + 815) > (2347 + 673))) then
				if ((v97.ArcaneExplosion:IsCastable() and v35 and (v13:ManaPercentage() > (1313 - (1035 + 248))) and (v102 >= (28 - (20 + 1)))) or ((1559 + 1433) == (2200 - (134 + 185)))) then
					if (((4239 - (549 + 584)) > (2211 - (314 + 371))) and v23(v97.ArcaneExplosion, not v14:IsInRange(27 - 19))) then
						return "arcane_explosion aoe 28";
					end
				end
				if (((3991 - (478 + 490)) < (2051 + 1819)) and v97.Frostbolt:IsCastable() and v40) then
					if (((1315 - (786 + 386)) > (239 - 165)) and v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((1397 - (1055 + 324)) < (3452 - (1093 + 247))) and v13:IsMoving() and v93) then
					local v203 = 0 + 0;
					while true do
						if (((116 + 981) <= (6463 - 4835)) and (v203 == (0 - 0))) then
							v30 = v122();
							if (((13174 - 8544) == (11634 - 7004)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1260 + 2280) > (10335 - 7652)) and (v138 == (13 - 9))) then
				if (((3615 + 1179) >= (8375 - 5100)) and v97.IceLance:IsCastable() and v46 and (v13:BuffUp(v97.FingersofFrostBuff) or (v114() > v97.IceLance:TravelTime()) or v28(v105))) then
					if (((2172 - (364 + 324)) == (4068 - 2584)) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if (((3436 - 2004) < (1179 + 2376)) and v97.IceNova:IsCastable() and v47 and (v101 >= (16 - 12)) and ((not v97.Snowstorm:IsAvailable() and not v97.GlacialSpike:IsAvailable()) or not v113())) then
					if (v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova)) or ((1705 - 640) > (10866 - 7288))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v97.DragonsBreath:IsCastable() and v38 and (v102 >= (1275 - (1249 + 19)))) or ((4329 + 466) < (5476 - 4069))) then
					if (((2939 - (686 + 400)) < (3777 + 1036)) and v23(v97.DragonsBreath, not v14:IsInRange(239 - (73 + 156)))) then
						return "dragons_breath aoe 26";
					end
				end
				v138 = 1 + 4;
			end
			if ((v138 == (812 - (721 + 90))) or ((32 + 2789) < (7893 - 5462))) then
				if ((v97.CometStorm:IsCastable() and ((v58 and v33) or not v58) and v53 and (v82 < v109) and not v13:PrevGCDP(471 - (224 + 246), v97.GlacialSpike) and (not v97.ColdestSnap:IsAvailable() or (v97.ConeofCold:CooldownUp() and (v97.FrozenOrb:CooldownRemains() > (40 - 15))) or (v97.ConeofCold:CooldownRemains() > (36 - 16)))) or ((522 + 2352) < (52 + 2129))) then
					if (v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm)) or ((1976 + 713) <= (681 - 338))) then
						return "comet_storm aoe 8";
					end
				end
				if ((v17:IsActive() and v43 and v97.Freeze:IsReady() and v113() and (v114() == (0 - 0)) and ((not v97.GlacialSpike:IsAvailable() and not v97.Snowstorm:IsAvailable()) or v13:PrevGCDP(514 - (203 + 310), v97.GlacialSpike) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107)))) or ((3862 - (1238 + 755)) == (141 + 1868))) then
					if (v23(v99.FreezePet, not v14:IsSpellInRange(v97.Freeze)) or ((5080 - (709 + 825)) < (4278 - 1956))) then
						return "freeze aoe 10";
					end
				end
				if ((v97.IceNova:IsCastable() and v47 and v113() and not v13:PrevOffGCDP(1 - 0, v97.Freeze) and (v13:PrevGCDP(865 - (196 + 668), v97.GlacialSpike) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107) and (v110 < (3 - 2))))) or ((4312 - 2230) == (5606 - (171 + 662)))) then
					if (((3337 - (4 + 89)) > (3697 - 2642)) and v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				v138 = 1 + 1;
			end
			if ((v138 == (0 - 0)) or ((1300 + 2013) <= (3264 - (35 + 1451)))) then
				if ((v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v13:PrevGCDP(1454 - (28 + 1425), v97.CometStorm) or (v13:PrevGCDP(1994 - (941 + 1052), v97.FrozenOrb) and not v97.CometStorm:IsAvailable()))) or ((1363 + 58) >= (3618 - (822 + 692)))) then
					if (((2586 - 774) <= (1531 + 1718)) and v23(v97.ConeofCold, not v14:IsInRange(305 - (45 + 252)))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((1606 + 17) <= (674 + 1283)) and v97.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v109) and (not v13:PrevGCDP(2 - 1, v97.GlacialSpike) or not v113())) then
					if (((4845 - (114 + 319)) == (6334 - 1922)) and v23(v99.FrozenOrbCast, not v14:IsInRange(51 - 11))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((1116 + 634) >= (1253 - 411)) and v97.Blizzard:IsCastable() and v37 and (not v13:PrevGCDP(1 - 0, v97.GlacialSpike) or not v113())) then
					if (((6335 - (556 + 1407)) > (3056 - (741 + 465))) and v23(v99.BlizzardCursor, not v14:IsInRange(505 - (170 + 295)))) then
						return "blizzard aoe 6";
					end
				end
				v138 = 1 + 0;
			end
			if (((214 + 18) < (2021 - 1200)) and (v138 == (2 + 0))) then
				if (((333 + 185) < (511 + 391)) and v97.FrostNova:IsCastable() and v41 and v113() and not v13:PrevOffGCDP(1231 - (957 + 273), v97.Freeze) and ((v13:PrevGCDP(1 + 0, v97.GlacialSpike) and (v105 == (0 + 0))) or (v97.ConeofCold:CooldownUp() and (v13:BuffStack(v97.SnowstormBuff) == v107) and (v110 < (3 - 2))))) then
					if (((7889 - 4895) > (2620 - 1762)) and v23(v97.FrostNova)) then
						return "frost_nova aoe 12";
					end
				end
				if ((v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and (v13:BuffStackP(v97.SnowstormBuff) == v107)) or ((18593 - 14838) <= (2695 - (389 + 1391)))) then
					if (((2476 + 1470) > (390 + 3353)) and v23(v97.ConeofCold, not v14:IsInRange(18 - 10))) then
						return "cone_of_cold aoe 14";
					end
				end
				if ((v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109)) or ((2286 - (783 + 168)) >= (11095 - 7789))) then
					if (((4765 + 79) > (2564 - (309 + 2))) and v23(v97.ShiftingPower, not v14:IsInRange(122 - 82), true)) then
						return "shifting_power aoe 16";
					end
				end
				v138 = 1215 - (1090 + 122);
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((1517 - 1065) == (310 + 142)) and (v139 == (1118 - (628 + 490)))) then
				if ((v97.CometStorm:IsCastable() and (v13:PrevGCDP(1 + 0, v97.Flurry) or v13:PrevGCDP(2 - 1, v97.ConeofCold)) and ((v58 and v33) or not v58) and v53 and (v82 < v109)) or ((20825 - 16268) < (2861 - (431 + 343)))) then
					if (((7823 - 3949) == (11207 - 7333)) and v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v97.Flurry:IsCastable() and v42 and ((v13:PrevGCDP(1 + 0, v97.Frostbolt) and (v106 >= (1 + 2))) or v13:PrevGCDP(1696 - (556 + 1139), v97.GlacialSpike) or ((v106 >= (18 - (6 + 9))) and (v106 < (1 + 4)) and (v97.Flurry:ChargesFractional() == (2 + 0))))) or ((2107 - (28 + 141)) > (1912 + 3023))) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (0 + 0)) or ((5572 - (486 + 831)) < (8907 - 5484))) then
							if (((5118 - 3664) <= (471 + 2020)) and v111.CastTargetIf(v97.Flurry, v103, "min", v115, nil, not v14:IsSpellInRange(v97.Flurry))) then
								return "flurry cleave 4";
							end
							if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((13144 - 8987) <= (4066 - (668 + 595)))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if (((4367 + 486) >= (602 + 2380)) and v97.IceLance:IsReady() and v46 and v97.GlacialSpike:IsAvailable() and (v97.WintersChillDebuff:AuraActiveCount() == (0 - 0)) and (v106 == (294 - (23 + 267))) and v13:BuffUp(v97.FingersofFrostBuff)) then
					local v205 = 1944 - (1129 + 815);
					while true do
						if (((4521 - (371 + 16)) > (5107 - (1326 + 424))) and (v205 == (0 - 0))) then
							if (v111.CastTargetIf(v97.IceLance, v103, "max", v116, nil, not v14:IsSpellInRange(v97.IceLance)) or ((12486 - 9069) < (2652 - (88 + 30)))) then
								return "ice_lance cleave 6";
							end
							if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((3493 - (720 + 51)) <= (364 - 200))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				if ((v97.RayofFrost:IsCastable() and (v105 == (1777 - (421 + 1355))) and v48) or ((3972 - 1564) < (1036 + 1073))) then
					local v206 = 1083 - (286 + 797);
					while true do
						if ((v206 == (0 - 0)) or ((53 - 20) == (1894 - (397 + 42)))) then
							if (v111.CastTargetIf(v97.RayofFrost, v103, "max", v115, nil, not v14:IsSpellInRange(v97.RayofFrost)) or ((139 + 304) >= (4815 - (24 + 776)))) then
								return "ray_of_frost cleave 8";
							end
							if (((5209 - 1827) > (951 - (222 + 563))) and v23(v97.RayofFrost, not v14:IsSpellInRange(v97.RayofFrost))) then
								return "ray_of_frost cleave 8";
							end
							break;
						end
					end
				end
				v139 = 1 - 0;
			end
			if ((v139 == (2 + 0)) or ((470 - (23 + 167)) == (4857 - (690 + 1108)))) then
				if (((679 + 1202) > (1067 + 226)) and v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109) and (((v97.FrozenOrb:CooldownRemains() > (858 - (40 + 808))) and (not v97.CometStorm:IsAvailable() or (v97.CometStorm:CooldownRemains() > (2 + 8))) and (not v97.RayofFrost:IsAvailable() or (v97.RayofFrost:CooldownRemains() > (38 - 28)))) or (v97.IcyVeins:CooldownRemains() < (20 + 0)))) then
					if (((1247 + 1110) == (1293 + 1064)) and v23(v97.ShiftingPower, not v14:IsSpellInRange(v97.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if (((694 - (47 + 524)) == (80 + 43)) and v97.GlacialSpike:IsReady() and v44 and (v106 == (13 - 8))) then
					if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((1578 - 522) >= (7735 - 4343))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v97.IceLance:IsReady() and v46 and ((v13:BuffStackP(v97.FingersofFrostBuff) and not v13:PrevGCDP(1727 - (1165 + 561), v97.GlacialSpike)) or (v105 > (0 + 0)))) or ((3347 - 2266) < (411 + 664))) then
					if (v111.CastTargetIf(v97.IceLance, v103, "max", v115, nil, not v14:IsSpellInRange(v97.IceLance)) or ((1528 - (341 + 138)) >= (1197 + 3235))) then
						return "ice_lance cleave 22";
					end
					if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((9839 - 5071) <= (1172 - (89 + 237)))) then
						return "ice_lance cleave 22";
					end
				end
				if ((v97.IceNova:IsCastable() and v47 and (v102 >= (12 - 8))) or ((7069 - 3711) <= (2301 - (581 + 300)))) then
					if (v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova)) or ((4959 - (855 + 365)) <= (7137 - 4132))) then
						return "ice_nova cleave 24";
					end
				end
				v139 = 1 + 2;
			end
			if ((v139 == (1238 - (1030 + 205))) or ((1558 + 101) >= (1986 + 148))) then
				if ((v97.Frostbolt:IsCastable() and v40) or ((3546 - (156 + 130)) < (5351 - 2996))) then
					if (v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true) or ((1127 - 458) == (8649 - 4426))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v13:IsMoving() and v93) or ((446 + 1246) < (343 + 245))) then
					v30 = v122();
					if (v30 or ((4866 - (10 + 59)) < (1033 + 2618))) then
						return v30;
					end
				end
				break;
			end
			if ((v139 == (4 - 3)) or ((5340 - (671 + 492)) > (3861 + 989))) then
				if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (1220 - (369 + 846))) and (v97.Flurry:CooldownUp() or (v105 > (0 + 0)))) or ((342 + 58) > (3056 - (1036 + 909)))) then
					if (((2426 + 625) > (1687 - 682)) and v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if (((3896 - (11 + 192)) <= (2215 + 2167)) and v97.FrozenOrb:IsCastable() and ((v57 and v33) or not v57) and v52 and (v82 < v109) and (v13:BuffStackP(v97.FingersofFrostBuff) < (177 - (135 + 40))) and (not v97.RayofFrost:IsAvailable() or v97.RayofFrost:CooldownDown())) then
					if (v23(v99.FrozenOrbCast, not v14:IsSpellInRange(v97.FrozenOrb)) or ((7951 - 4669) > (2472 + 1628))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v97.CometStorm:CooldownRemains() > (22 - 12)) and (v97.FrozenOrb:CooldownRemains() > (14 - 4)) and (v105 == (176 - (50 + 126))) and (v102 >= (8 - 5))) or ((793 + 2787) < (4257 - (1233 + 180)))) then
					if (((1058 - (522 + 447)) < (5911 - (107 + 1314))) and v23(v97.ConeofCold)) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v97.Blizzard:IsCastable() and v37 and (v102 >= (1 + 1)) and v97.IceCaller:IsAvailable() and v97.FreezingRain:IsAvailable() and ((not v97.SplinteringCold:IsAvailable() and not v97.RayofFrost:IsAvailable()) or v13:BuffUp(v97.FreezingRainBuff) or (v102 >= (8 - 5)))) or ((2117 + 2866) < (3590 - 1782))) then
					if (((15149 - 11320) > (5679 - (716 + 1194))) and v23(v99.BlizzardCursor, not v14:IsSpellInRange(v97.Blizzard))) then
						return "blizzard cleave 16";
					end
				end
				v139 = 1 + 1;
			end
		end
	end
	local function v125()
		if (((160 + 1325) <= (3407 - (74 + 429))) and v97.CometStorm:IsCastable() and v53 and ((v58 and v33) or not v58) and (v82 < v109) and (v13:PrevGCDP(1 - 0, v97.Flurry) or v13:PrevGCDP(1 + 0, v97.ConeofCold))) then
			if (((9771 - 5502) == (3021 + 1248)) and v23(v97.CometStorm, not v14:IsSpellInRange(v97.CometStorm))) then
				return "comet_storm single 2";
			end
		end
		if (((1193 - 806) <= (6878 - 4096)) and v97.Flurry:IsCastable() and (v105 == (433 - (279 + 154))) and v14:DebuffDown(v97.WintersChillDebuff) and ((v13:PrevGCDP(779 - (454 + 324), v97.Frostbolt) and (v106 >= (3 + 0))) or (v13:PrevGCDP(18 - (12 + 5), v97.Frostbolt) and v13:BuffUp(v97.BrainFreezeBuff)) or v13:PrevGCDP(1 + 0, v97.GlacialSpike) or (v97.GlacialSpike:IsAvailable() and (v106 == (10 - 6)) and v13:BuffDown(v97.FingersofFrostBuff)))) then
			if (v23(v97.Flurry, not v14:IsSpellInRange(v97.Flurry)) or ((702 + 1197) <= (2010 - (277 + 816)))) then
				return "flurry single 4";
			end
		end
		if ((v97.IceLance:IsReady() and v46 and v97.GlacialSpike:IsAvailable() and not v97.GlacialSpike:InFlight() and (v105 == (0 - 0)) and (v106 == (1187 - (1058 + 125))) and v13:BuffUp(v97.FingersofFrostBuff)) or ((809 + 3503) <= (1851 - (815 + 160)))) then
			if (((9576 - 7344) <= (6162 - 3566)) and v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance))) then
				return "ice_lance single 6";
			end
		end
		if (((500 + 1595) < (10774 - 7088)) and v97.RayofFrost:IsCastable() and v48 and (v14:DebuffRemains(v97.WintersChillDebuff) > v97.RayofFrost:CastTime()) and (v105 == (1899 - (41 + 1857)))) then
			if (v23(v97.RayofFrost, not v14:IsSpellInRange(v97.RayofFrost)) or ((3488 - (1222 + 671)) >= (11563 - 7089))) then
				return "ray_of_frost single 8";
			end
		end
		if ((v97.GlacialSpike:IsReady() and v44 and (v106 == (6 - 1)) and ((v97.Flurry:Charges() >= (1183 - (229 + 953))) or ((v105 > (1774 - (1111 + 663))) and (v97.GlacialSpike:CastTime() < v14:DebuffRemains(v97.WintersChillDebuff))))) or ((6198 - (874 + 705)) < (404 + 2478))) then
			if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((201 + 93) >= (10041 - 5210))) then
				return "glacial_spike single 10";
			end
		end
		if (((58 + 1971) <= (3763 - (642 + 37))) and v97.FrozenOrb:IsCastable() and v52 and ((v57 and v33) or not v57) and (v82 < v109) and (v105 == (0 + 0)) and (v13:BuffStackP(v97.FingersofFrostBuff) < (1 + 1)) and (not v97.RayofFrost:IsAvailable() or v97.RayofFrost:CooldownDown())) then
			if (v23(v99.FrozenOrbCast, not v14:IsInRange(100 - 60)) or ((2491 - (233 + 221)) == (5596 - 3176))) then
				return "frozen_orb single 12";
			end
		end
		if (((3924 + 534) > (5445 - (718 + 823))) and v97.ConeofCold:IsCastable() and v54 and ((v59 and v33) or not v59) and (v82 < v109) and v97.ColdestSnap:IsAvailable() and (v97.CometStorm:CooldownRemains() > (7 + 3)) and (v97.FrozenOrb:CooldownRemains() > (815 - (266 + 539))) and (v105 == (0 - 0)) and (v101 >= (1228 - (636 + 589)))) then
			if (((1034 - 598) >= (253 - 130)) and v23(v97.ConeofCold, not v14:IsInRange(7 + 1))) then
				return "cone_of_cold single 14";
			end
		end
		if (((182 + 318) < (2831 - (657 + 358))) and v97.Blizzard:IsCastable() and v37 and (v101 >= (4 - 2)) and v97.IceCaller:IsAvailable() and v97.FreezingRain:IsAvailable() and ((not v97.SplinteringCold:IsAvailable() and not v97.RayofFrost:IsAvailable()) or v13:BuffUp(v97.FreezingRainBuff) or (v101 >= (6 - 3)))) then
			if (((4761 - (1151 + 36)) == (3452 + 122)) and v23(v99.BlizzardCursor, not v14:IsInRange(11 + 29))) then
				return "blizzard single 16";
			end
		end
		if (((659 - 438) < (2222 - (1552 + 280))) and v97.ShiftingPower:IsCastable() and v55 and ((v60 and v33) or not v60) and (v82 < v109) and (v105 == (834 - (64 + 770))) and (((v97.FrozenOrb:CooldownRemains() > (7 + 3)) and (not v97.CometStorm:IsAvailable() or (v97.CometStorm:CooldownRemains() > (22 - 12))) and (not v97.RayofFrost:IsAvailable() or (v97.RayofFrost:CooldownRemains() > (2 + 8)))) or (v97.IcyVeins:CooldownRemains() < (1263 - (157 + 1086))))) then
			if (v23(v97.ShiftingPower, not v14:IsInRange(80 - 40)) or ((9692 - 7479) <= (2179 - 758))) then
				return "shifting_power single 18";
			end
		end
		if (((4173 - 1115) < (5679 - (599 + 220))) and v97.GlacialSpike:IsReady() and v44 and (v106 == (9 - 4))) then
			if (v23(v97.GlacialSpike, not v14:IsSpellInRange(v97.GlacialSpike)) or ((3227 - (1813 + 118)) >= (3250 + 1196))) then
				return "glacial_spike single 20";
			end
		end
		if ((v97.IceLance:IsReady() and v46 and ((v13:BuffUp(v97.FingersofFrostBuff) and not v13:PrevGCDP(1218 - (841 + 376), v97.GlacialSpike) and not v97.GlacialSpike:InFlight()) or v28(v105))) or ((1951 - 558) > (1043 + 3446))) then
			if (v23(v97.IceLance, not v14:IsSpellInRange(v97.IceLance)) or ((12075 - 7651) < (886 - (464 + 395)))) then
				return "ice_lance single 22";
			end
		end
		if ((v97.IceNova:IsCastable() and v47 and (v102 >= (10 - 6))) or ((960 + 1037) > (4652 - (467 + 370)))) then
			if (((7160 - 3695) > (1405 + 508)) and v23(v97.IceNova, not v14:IsSpellInRange(v97.IceNova))) then
				return "ice_nova single 24";
			end
		end
		if (((2512 - 1779) < (284 + 1535)) and v88 and ((v91 and v33) or not v91)) then
			if (v97.BagofTricks:IsCastable() or ((10225 - 5830) == (5275 - (150 + 370)))) then
				if (v23(v97.BagofTricks, not v14:IsSpellInRange(v97.BagofTricks)) or ((5075 - (74 + 1208)) < (5826 - 3457))) then
					return "bag_of_tricks cd 40";
				end
			end
		end
		if ((v97.Frostbolt:IsCastable() and v40) or ((19368 - 15284) == (189 + 76))) then
			if (((4748 - (14 + 376)) == (7558 - 3200)) and v23(v97.Frostbolt, not v14:IsSpellInRange(v97.Frostbolt), true)) then
				return "frostbolt single 26";
			end
		end
		if ((v13:IsMoving() and v93) or ((2031 + 1107) < (873 + 120))) then
			local v146 = 0 + 0;
			while true do
				if (((9757 - 6427) > (1748 + 575)) and (v146 == (78 - (23 + 55)))) then
					v30 = v122();
					if (v30 or ((8593 - 4967) == (2662 + 1327))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (10 - 3)) or ((289 + 627) == (3572 - (652 + 249)))) then
				v72 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v70 = EpicSettings.Settings['greaterInvisibilityHP'] or (1868 - (708 + 1160));
				v71 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v73 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v74 = EpicSettings.Settings['massBarrierHP'] or (27 - (10 + 17));
				v140 = 2 + 6;
			end
			if (((2004 - (1400 + 332)) == (521 - 249)) and (v140 == (1912 - (242 + 1666)))) then
				v55 = EpicSettings.Settings['useShiftingPower'];
				v56 = EpicSettings.Settings['icyVeinsWithCD'];
				v57 = EpicSettings.Settings['frozenOrbWithCD'];
				v58 = EpicSettings.Settings['cometStormWithCD'];
				v59 = EpicSettings.Settings['coneOfColdWithCD'];
				v140 = 3 + 2;
			end
			if (((1558 + 2691) <= (4124 + 715)) and (v140 == (948 - (850 + 90)))) then
				v92 = EpicSettings.Settings['useSpellStealTarget'];
				v93 = EpicSettings.Settings['useSpellsWhileMoving'];
				v94 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v95 = EpicSettings.Settings['mirrorImageBeforePull'];
				v96 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((4863 - 2086) < (4590 - (360 + 1030))) and ((6 + 0) == v140)) then
				v65 = EpicSettings.Settings['useIceCold'];
				v66 = EpicSettings.Settings['useMassBarrier'];
				v67 = EpicSettings.Settings['useMirrorImage'];
				v68 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v69 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
				v140 = 1668 - (909 + 752);
			end
			if (((1318 - (109 + 1114)) < (3582 - 1625)) and (v140 == (0 + 0))) then
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneIntellect'];
				v37 = EpicSettings.Settings['useBlizzard'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v39 = EpicSettings.Settings['useFireBlast'];
				v140 = 243 - (6 + 236);
			end
			if (((521 + 305) < (1383 + 334)) and (v140 == (6 - 3))) then
				v50 = EpicSettings.Settings['useBlastWave'];
				v51 = EpicSettings.Settings['useIcyVeins'];
				v52 = EpicSettings.Settings['useFrozenOrb'];
				v53 = EpicSettings.Settings['useCometStorm'];
				v54 = EpicSettings.Settings['useConeOfCold'];
				v140 = 6 - 2;
			end
			if (((2559 - (1076 + 57)) >= (182 + 923)) and ((690 - (579 + 110)) == v140)) then
				v40 = EpicSettings.Settings['useFrostbolt'];
				v41 = EpicSettings.Settings['useFrostNova'];
				v42 = EpicSettings.Settings['useFlurry'];
				v43 = EpicSettings.Settings['useFreezePet'];
				v44 = EpicSettings.Settings['useGlacialSpike'];
				v140 = 1 + 1;
			end
			if (((2435 + 319) <= (1794 + 1585)) and (v140 == (409 - (174 + 233)))) then
				v45 = EpicSettings.Settings['useIceFloes'];
				v46 = EpicSettings.Settings['useIceLance'];
				v47 = EpicSettings.Settings['useIceNova'];
				v48 = EpicSettings.Settings['useRayOfFrost'];
				v49 = EpicSettings.Settings['useCounterspell'];
				v140 = 8 - 5;
			end
			if ((v140 == (8 - 3)) or ((1747 + 2180) == (2587 - (663 + 511)))) then
				v60 = EpicSettings.Settings['shiftingPowerWithCD'];
				v61 = EpicSettings.Settings['useAlterTime'];
				v62 = EpicSettings.Settings['useIceBarrier'];
				v63 = EpicSettings.Settings['useGreaterInvisibility'];
				v64 = EpicSettings.Settings['useIceBlock'];
				v140 = 6 + 0;
			end
		end
	end
	local function v127()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (12 - 8)) or ((699 + 455) <= (1855 - 1067))) then
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v141 = 9 - 4;
			end
			if ((v141 == (3 + 0)) or ((151 + 1492) > (4101 - (478 + 244)))) then
				v91 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v83 = EpicSettings.Settings['useHealingPotion'];
				v141 = 521 - (440 + 77);
			end
			if ((v141 == (1 + 0)) or ((10258 - 7455) > (6105 - (655 + 901)))) then
				v81 = EpicSettings.Settings['InterruptThreshold'];
				v76 = EpicSettings.Settings['DispelDebuffs'];
				v75 = EpicSettings.Settings['DispelBuffs'];
				v141 = 1 + 1;
			end
			if (((4 + 1) == v141) or ((149 + 71) >= (12174 - 9152))) then
				v77 = EpicSettings.Settings['handleAfflicted'];
				v78 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((4267 - (695 + 750)) == (9636 - 6814)) and (v141 == (0 - 0))) then
				v82 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v79 = EpicSettings.Settings['InterruptWithStun'];
				v80 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v141 = 352 - (285 + 66);
			end
			if ((v141 == (4 - 2)) or ((2371 - (682 + 628)) == (300 + 1557))) then
				v89 = EpicSettings.Settings['useTrinkets'];
				v88 = EpicSettings.Settings['useRacials'];
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v141 = 302 - (176 + 123);
			end
		end
	end
	local function v128()
		local v142 = 0 + 0;
		while true do
			if (((2003 + 757) > (1633 - (239 + 30))) and (v142 == (0 + 0))) then
				v126();
				v127();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v142 = 1 + 0;
			end
			if ((v142 == (1 - 0)) or ((15293 - 10391) <= (3910 - (306 + 9)))) then
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((13441 - 9589) == (51 + 242))) then
					return v30;
				end
				v103 = v14:GetEnemiesInSplashRange(4 + 1);
				v142 = 1 + 1;
			end
			if ((v142 == (8 - 5)) or ((2934 - (1140 + 235)) == (2920 + 1668))) then
				if (v111.TargetIsValid() or ((4112 + 372) == (203 + 585))) then
					local v207 = 52 - (33 + 19);
					while true do
						if (((1650 + 2918) >= (11710 - 7803)) and (v207 == (2 + 2))) then
							if (((2443 - 1197) < (3254 + 216)) and v13:AffectingCombat() and v111.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
								if (((4757 - (586 + 103)) >= (89 + 883)) and v33) then
									local v214 = 0 - 0;
									while true do
										if (((1981 - (1309 + 179)) < (7027 - 3134)) and (v214 == (0 + 0))) then
											v30 = v121();
											if (v30 or ((3955 - 2482) >= (2517 + 815))) then
												return v30;
											end
											break;
										end
									end
								end
								if ((v32 and (((v102 >= (14 - 7)) and not v13:HasTier(59 - 29, 611 - (295 + 314))) or ((v102 >= (6 - 3)) and v97.IceCaller:IsAvailable()))) or ((6013 - (1300 + 662)) <= (3633 - 2476))) then
									v30 = v123();
									if (((2359 - (1178 + 577)) < (1497 + 1384)) and v30) then
										return v30;
									end
									if (v23(v97.Pool) or ((2660 - 1760) == (4782 - (851 + 554)))) then
										return "pool for Aoe()";
									end
								end
								if (((3944 + 515) > (1638 - 1047)) and v32 and (v102 == (3 - 1))) then
									local v215 = 302 - (115 + 187);
									while true do
										if (((2603 + 795) >= (2268 + 127)) and ((3 - 2) == v215)) then
											if (v23(v97.Pool) or ((3344 - (160 + 1001)) >= (2471 + 353))) then
												return "pool for Cleave()";
											end
											break;
										end
										if (((1336 + 600) == (3962 - 2026)) and (v215 == (358 - (237 + 121)))) then
											v30 = v124();
											if (v30 or ((5729 - (525 + 372)) < (8176 - 3863))) then
												return v30;
											end
											v215 = 3 - 2;
										end
									end
								end
								v30 = v125();
								if (((4230 - (96 + 46)) > (4651 - (643 + 134))) and v30) then
									return v30;
								end
								if (((1564 + 2768) == (10386 - 6054)) and v23(v97.Pool)) then
									return "pool for ST()";
								end
								if (((14846 - 10847) >= (2782 + 118)) and v93) then
									v30 = v122();
									if (v30 or ((4955 - 2430) > (8306 - 4242))) then
										return v30;
									end
								end
							end
							break;
						end
						if (((5090 - (316 + 403)) == (2906 + 1465)) and (v207 == (2 - 1))) then
							v30 = v117();
							if (v30 or ((97 + 169) > (12556 - 7570))) then
								return v30;
							end
							v207 = 2 + 0;
						end
						if (((642 + 1349) >= (3205 - 2280)) and (v207 == (9 - 7))) then
							if (((945 - 490) < (118 + 1935)) and (v13:AffectingCombat() or v76)) then
								local v210 = 0 - 0;
								local v211;
								while true do
									if ((v210 == (1 + 0)) or ((2430 - 1604) == (4868 - (12 + 5)))) then
										if (((710 - 527) == (389 - 206)) and v30) then
											return v30;
										end
										break;
									end
									if (((2463 - 1304) <= (4433 - 2645)) and (v210 == (0 + 0))) then
										v211 = v76 and v97.RemoveCurse:IsReady() and v34;
										v30 = v111.FocusUnit(v211, v99, 1993 - (1656 + 317), nil, 18 + 2);
										v210 = 1 + 0;
									end
								end
							end
							if (v77 or ((9324 - 5817) > (21251 - 16933))) then
								if (v96 or ((3429 - (5 + 349)) <= (14083 - 11118))) then
									local v216 = 1271 - (266 + 1005);
									while true do
										if (((900 + 465) <= (6861 - 4850)) and (v216 == (0 - 0))) then
											v30 = v111.HandleAfflicted(v97.RemoveCurse, v99.RemoveCurseMouseover, 1726 - (561 + 1135));
											if (v30 or ((3616 - 840) > (11751 - 8176))) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v207 = 1069 - (507 + 559);
						end
						if ((v207 == (0 - 0)) or ((7898 - 5344) == (5192 - (212 + 176)))) then
							if (((3482 - (250 + 655)) == (7027 - 4450)) and v15) then
								if (v76 or ((10 - 4) >= (2954 - 1065))) then
									local v217 = 1956 - (1869 + 87);
									while true do
										if (((1754 - 1248) <= (3793 - (484 + 1417))) and (v217 == (0 - 0))) then
											v30 = v118();
											if (v30 or ((3364 - 1356) > (2991 - (48 + 725)))) then
												return v30;
											end
											break;
										end
									end
								end
							end
							if (((618 - 239) <= (11126 - 6979)) and not v13:AffectingCombat() and v31) then
								local v212 = 0 + 0;
								while true do
									if (((0 - 0) == v212) or ((1264 + 3250) <= (295 + 714))) then
										v30 = v120();
										if (v30 or ((4349 - (152 + 701)) == (2503 - (430 + 881)))) then
											return v30;
										end
										break;
									end
								end
							end
							v207 = 1 + 0;
						end
						if ((v207 == (898 - (557 + 338))) or ((62 + 146) == (8338 - 5379))) then
							if (((14977 - 10700) >= (3488 - 2175)) and v78) then
								local v213 = 0 - 0;
								while true do
									if (((3388 - (499 + 302)) < (4040 - (39 + 827))) and ((0 - 0) == v213)) then
										v30 = v111.HandleIncorporeal(v97.Polymorph, v99.PolymorphMouseOver, 67 - 37, true);
										if (v30 or ((16364 - 12244) <= (3374 - 1176))) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v97.Spellsteal:IsAvailable() and v92 and v97.Spellsteal:IsReady() and v34 and v75 and not v13:IsCasting() and not v13:IsChanneling() and v111.UnitHasMagicBuff(v14)) or ((137 + 1459) == (2511 - 1653))) then
								if (((516 + 2704) == (5095 - 1875)) and v23(v97.Spellsteal, not v14:IsSpellInRange(v97.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v207 = 108 - (103 + 1);
						end
					end
				end
				break;
			end
			if ((v142 == (556 - (475 + 79))) or ((3030 - 1628) > (11584 - 7964))) then
				v104 = v13:GetEnemiesInRange(6 + 34);
				if (((2266 + 308) == (4077 - (1395 + 108))) and v32) then
					local v208 = 0 - 0;
					while true do
						if (((3002 - (7 + 1197)) < (1203 + 1554)) and (v208 == (0 + 0))) then
							v101 = v29(v14:GetEnemiesInSplashRangeCount(324 - (27 + 292)), #v104);
							v102 = v29(v14:GetEnemiesInSplashRangeCount(14 - 9), #v104);
							break;
						end
					end
				else
					v101 = 1 - 0;
					v102 = 4 - 3;
				end
				if (not v13:AffectingCombat() or ((743 - 366) > (4958 - 2354))) then
					if (((707 - (43 + 96)) < (3716 - 2805)) and v97.ArcaneIntellect:IsCastable() and v36 and (v13:BuffDown(v97.ArcaneIntellect, true) or v111.GroupBuffMissing(v97.ArcaneIntellect))) then
						if (((7427 - 4142) < (3509 + 719)) and v23(v97.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (((1106 + 2810) > (6577 - 3249)) and (v111.TargetIsValid() or v13:AffectingCombat())) then
					local v209 = 0 + 0;
					while true do
						if (((4685 - 2185) < (1209 + 2630)) and (v209 == (0 + 0))) then
							v108 = v9.BossFightRemains(nil, true);
							v109 = v108;
							v209 = 1752 - (1414 + 337);
						end
						if (((2447 - (1642 + 298)) == (1321 - 814)) and (v209 == (2 - 1))) then
							if (((712 - 472) <= (1042 + 2123)) and (v109 == (8645 + 2466))) then
								v109 = v9.FightRemains(v104, false);
							end
							v105 = v14:DebuffStack(v97.WintersChillDebuff);
							v209 = 974 - (357 + 615);
						end
						if (((586 + 248) >= (1974 - 1169)) and (v209 == (2 + 0))) then
							v106 = v13:BuffStackP(v97.IciclesBuff);
							v110 = v13:GCD();
							break;
						end
					end
				end
				v142 = 6 - 3;
			end
		end
	end
	local function v129()
		v112();
		v97.WintersChillDebuff:RegisterAuraTracking();
		v21.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(52 + 12, v128, v129);
end;
return v0["Epix_Mage_Frost.lua"]();

