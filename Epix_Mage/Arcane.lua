local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1028 + 26) <= (9144 - 5673)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Arcane.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = v9.Unit;
	local v11 = v9.Utils;
	local v12 = v10.Player;
	local v13 = v10.Target;
	local v14 = v10.Focus;
	local v15 = v9.Spell;
	local v16 = v9.Item;
	local v17 = EpicLib;
	local v18 = v17.Cast;
	local v19 = v17.Press;
	local v20 = v17.Macro;
	local v21 = v17.Bind;
	local v22 = v17.Commons.Everyone.num;
	local v23 = v17.Commons.Everyone.bool;
	local v24 = math.max;
	local v25;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31;
	local v32;
	local v33;
	local v34;
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
	local v91 = v15.Mage.Arcane;
	local v92 = v16.Mage.Arcane;
	local v93 = v20.Mage.Arcane;
	local v94 = {};
	local v95 = v17.Commons.Everyone;
	local function v96()
		if (v91.RemoveCurse:IsAvailable() or ((5440 - 3837) <= (1749 - (1036 + 37)))) then
			v95.DispellableDebuffs = v95.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v96();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v91.ArcaneBlast:RegisterInFlight();
	v91.ArcaneBarrage:RegisterInFlight();
	local v97, v98;
	local v99, v100;
	local v101 = 3 + 0;
	local v102 = false;
	local v103 = false;
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = v12:HasTier(56 - 27, 4 + 0);
	local v108 = (226480 - (641 + 839)) - (((25913 - (910 + 3)) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((509859 - 309859) * v22(not v107)));
	local v109 = 1687 - (1466 + 218);
	local v110 = 5107 + 6004;
	local v111 = 12259 - (556 + 592);
	local v112;
	v9:RegisterForEvent(function()
		v102 = false;
		v105 = true;
		v108 = (80009 + 144991) - (((25808 - (329 + 479)) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((200854 - (174 + 680)) * v22(not v107)));
		v110 = 38179 - 27068;
		v111 = 23029 - 11918;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v107 = not v12:HasTier(21 + 8, 743 - (396 + 343));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v113()
		if (((304 + 3129) <= (5613 - (29 + 1448))) and v91.PrismaticBarrier:IsCastable() and v56 and v12:BuffDown(v91.PrismaticBarrier) and (v12:HealthPercentage() <= v63)) then
			if (((5634 - (135 + 1254)) <= (17445 - 12814)) and v19(v91.PrismaticBarrier)) then
				return "ice_barrier defensive 1";
			end
		end
		if (((19965 - 15689) >= (2609 + 1305)) and v91.MassBarrier:IsCastable() and v60 and v12:BuffDown(v91.PrismaticBarrier) and v95.AreUnitsBelowHealthPercentage(v68, 1529 - (389 + 1138))) then
			if (((772 - (102 + 472)) <= (4120 + 245)) and v19(v91.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if (((2652 + 2130) > (4361 + 315)) and v91.IceBlock:IsCastable() and v58 and (v12:HealthPercentage() <= v65)) then
			if (((6409 - (320 + 1225)) > (3910 - 1713)) and v19(v91.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if ((v91.IceColdTalent:IsAvailable() and v91.IceColdAbility:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) or ((2264 + 1436) == (3971 - (157 + 1307)))) then
			if (((6333 - (821 + 1038)) >= (683 - 409)) and v19(v91.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v91.MirrorImage:IsCastable() and v61 and (v12:HealthPercentage() <= v67)) or ((208 + 1686) <= (2496 - 1090))) then
			if (((585 + 987) >= (3794 - 2263)) and v19(v91.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if ((v91.GreaterInvisibility:IsReady() and v57 and (v12:HealthPercentage() <= v64)) or ((5713 - (834 + 192)) < (289 + 4253))) then
			if (((845 + 2446) > (36 + 1631)) and v19(v91.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if ((v91.AlterTime:IsReady() and v55 and (v12:HealthPercentage() <= v62)) or ((1352 - 479) == (2338 - (300 + 4)))) then
			if (v19(v91.AlterTime) or ((753 + 2063) < (28 - 17))) then
				return "alter_time defensive 6";
			end
		end
		if (((4061 - (112 + 250)) < (1877 + 2829)) and v92.Healthstone:IsReady() and v82 and (v12:HealthPercentage() <= v84)) then
			if (((6628 - 3982) >= (502 + 374)) and v19(v93.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((318 + 296) <= (2382 + 802)) and v81 and (v12:HealthPercentage() <= v83)) then
			if (((1550 + 1576) == (2323 + 803)) and (v85 == "Refreshing Healing Potion")) then
				if (v92.RefreshingHealingPotion:IsReady() or ((3601 - (1001 + 413)) >= (11046 - 6092))) then
					if (v19(v93.RefreshingHealingPotion) or ((4759 - (244 + 638)) == (4268 - (627 + 66)))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((2106 - 1399) > (1234 - (512 + 90))) and (v85 == "Dreamwalker's Healing Potion")) then
				if (v92.DreamwalkersHealingPotion:IsReady() or ((2452 - (1665 + 241)) >= (3401 - (373 + 344)))) then
					if (((661 + 804) <= (1139 + 3162)) and v19(v93.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v114()
		if (((4494 - 2790) > (2411 - 986)) and v91.RemoveCurse:IsReady() and v30 and v95.DispellableFriendlyUnit(1119 - (35 + 1064))) then
			if (v19(v93.RemoveCurseFocus) or ((500 + 187) == (9058 - 4824))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v115()
		v25 = v95.HandleTopTrinket(v94, v28, 1 + 39, nil);
		if (v25 or ((4566 - (298 + 938)) < (2688 - (233 + 1026)))) then
			return v25;
		end
		v25 = v95.HandleBottomTrinket(v94, v28, 1706 - (636 + 1030), nil);
		if (((587 + 560) >= (328 + 7)) and v25) then
			return v25;
		end
	end
	local function v116()
		local v130 = 0 + 0;
		while true do
			if (((233 + 3202) > (2318 - (55 + 166))) and (v130 == (1 + 1))) then
				if ((v91.ArcaneBlast:IsReady() and v31) or ((380 + 3390) >= (15432 - 11391))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((4088 - (36 + 261)) <= (2817 - 1206))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if ((v130 == (1369 - (34 + 1334))) or ((1760 + 2818) <= (1561 + 447))) then
				if (((2408 - (1035 + 248)) <= (2097 - (20 + 1))) and v91.Evocation:IsReady() and v38 and (v91.SiphonStorm:IsAvailable())) then
					if (v19(v91.Evocation) or ((388 + 355) >= (4718 - (134 + 185)))) then
						return "evocation precombat 6";
					end
				end
				if (((2288 - (549 + 584)) < (2358 - (314 + 371))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52)) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(137 - 97)) or ((3292 - (478 + 490)) <= (307 + 271))) then
						return "arcane_orb precombat 8";
					end
				end
				v130 = 1174 - (786 + 386);
			end
			if (((12201 - 8434) == (5146 - (1055 + 324))) and (v130 == (1340 - (1093 + 247)))) then
				if (((3634 + 455) == (430 + 3659)) and v91.MirrorImage:IsCastable() and v88 and v61) then
					if (((17699 - 13241) >= (5681 - 4007)) and v19(v91.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if (((2765 - 1793) <= (3563 - 2145)) and v91.ArcaneBlast:IsReady() and v31 and not v91.SiphonStorm:IsAvailable()) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((1757 + 3181) < (18345 - 13583))) then
						return "arcane_blast precombat 4";
					end
				end
				v130 = 3 - 2;
			end
		end
	end
	local function v117()
		if ((((v98 >= v101) or (v99 >= v101)) and ((v91.ArcaneOrb:Charges() > (0 + 0)) or (v12:ArcaneCharges() >= (7 - 4))) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (690 - (364 + 324))))) or ((6864 - 4360) > (10231 - 5967))) then
			v103 = true;
		elseif (((714 + 1439) == (9008 - 6855)) and v103 and v13:DebuffDown(v91.RadiantSparkVulnerability) and (v13:DebuffRemains(v91.RadiantSparkDebuff) < (10 - 3)) and v91.RadiantSpark:CooldownDown()) then
			v103 = false;
		end
		if (((v12:ArcaneCharges() > (8 - 5)) and ((v98 < v101) or (v99 < v101)) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (1275 - (1249 + 19)))) and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * (5 + 0))) or (v91.ArcaneSurge:CooldownRemains() > (155 - 115)))) or ((1593 - (686 + 400)) >= (2033 + 558))) then
			v104 = true;
		elseif (((4710 - (73 + 156)) == (22 + 4459)) and v104 and v13:DebuffDown(v91.RadiantSparkVulnerability) and (v13:DebuffRemains(v91.RadiantSparkDebuff) < (818 - (721 + 90))) and v91.RadiantSpark:CooldownDown()) then
			v104 = false;
		end
		if ((v13:DebuffUp(v91.TouchoftheMagiDebuff) and v105) or ((27 + 2301) < (2250 - 1557))) then
			v105 = false;
		end
		v106 = v91.ArcaneBlast:CastTime() < v112;
	end
	local function v118()
		if (((4798 - (224 + 246)) == (7010 - 2682)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(1 - 0, v91.ArcaneBarrage))) then
			if (((289 + 1299) >= (32 + 1300)) and v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (v91.RadiantSpark:CooldownUp() or ((3066 + 1108) > (8445 - 4197))) then
			v102 = v91.ArcaneSurge:CooldownRemains() < (33 - 23);
		end
		if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v12:BuffDown(v91.ArcaneSurgeBuff) and not v91.RadiantSpark:IsAvailable()) or ((5099 - (203 + 310)) <= (2075 - (1238 + 755)))) then
			if (((270 + 3593) == (5397 - (709 + 825))) and v19(v91.ShiftingPower, not v13:IsInRange(73 - 33), true)) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and v91.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) or ((410 - 128) <= (906 - (196 + 668)))) then
			if (((18197 - 13588) >= (1586 - 820)) and v19(v91.ArcaneOrb, not v13:IsInRange(873 - (171 + 662)))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v91.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (95 - (4 + 89))) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v91.ArcaneOrb:CooldownRemains() >= v112)))) or ((4037 - 2885) == (906 + 1582))) then
			if (((15030 - 11608) > (1314 + 2036)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if (((2363 - (35 + 1451)) > (1829 - (28 + 1425))) and v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (1993 - (941 + 1052))) and (v12:ManaPercentage() > (29 + 1)) and v12:BuffUp(v91.NetherPrecisionBuff) and v12:BuffDown(v91.ArcaneArtilleryBuff)) then
			if (v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((4632 - (822 + 692)) <= (2642 - 791))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (3 + 2)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (303 - (45 + 252))))) and v12:HasTier(31 + 0, 2 + 2)) or ((401 - 236) >= (3925 - (114 + 319)))) then
			if (((5669 - 1720) < (6222 - 1366)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v108) and (v12:BuffRemains(v91.SiphonStormBuff) > (11 + 6)) and not v12:HasTier(44 - 14, 8 - 4)) or ((6239 - (556 + 1407)) < (4222 - (741 + 465)))) then
			if (((5155 - (170 + 295)) > (2174 + 1951)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) >= (2 + 0)) and (v91.RadiantSpark:CooldownRemains() < (12 - 7)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (5 + 1)))) and not v12:HasTier(20 + 10, 3 + 1)) or ((1280 - (957 + 273)) >= (240 + 656))) then
			if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((687 + 1027) >= (11271 - 8313))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v91.ArcaneHarmonyBuff) < (39 - 24)) and ((v105 and v12:BloodlustUp()) or (v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (15 - 10)))) and (v91.ArcaneSurge:CooldownRemains() < (148 - 118))) or ((3271 - (389 + 1391)) < (405 + 239))) then
			if (((74 + 630) < (2246 - 1259)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if (((4669 - (783 + 168)) > (6396 - 4490)) and v91.ArcaneMissiles:IsReady() and v36 and v91.RadiantSpark:CooldownUp() and v12:BuffUp(v91.ClearcastingBuff) and v91.NetherPrecision:IsAvailable() and (v12:BuffDown(v91.NetherPrecisionBuff) or (v12:BuffRemains(v91.NetherPrecisionBuff) < v112)) and v12:HasTier(30 + 0, 315 - (309 + 2))) then
			if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((2941 - 1983) > (4847 - (1090 + 122)))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if (((1136 + 2365) <= (15086 - 10594)) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
			if (v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark), true) or ((2356 + 1086) < (3666 - (628 + 490)))) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if (((516 + 2359) >= (3624 - 2160)) and v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (137 - 107)) and (v91.ArcaneEcho:IsAvailable())) then
			if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((5571 - (431 + 343)) >= (9881 - 4988))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if ((v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) or ((1593 - 1042) > (1634 + 434))) then
			if (((271 + 1843) > (2639 - (556 + 1139))) and v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and (v12:PrevGCDP(16 - (6 + 9), v91.ArcaneSurge) or v12:PrevGCDP(1 + 0, v91.NetherTempest) or v12:PrevGCDP(1 + 0, v91.RadiantSpark))) or ((2431 - (28 + 141)) >= (1200 + 1896))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((2783 - 528) >= (2506 + 1031))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v13:DebuffUp(v91.RadiantSparkVulnerability) and (v13:DebuffStack(v91.RadiantSparkVulnerability) < (1321 - (486 + 831)))) or ((9984 - 6147) < (4597 - 3291))) then
			if (((558 + 2392) == (9327 - 6377)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if ((v91.PresenceofMind:IsCastable() and v41 and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((5986 - (668 + 595)) < (2968 + 330))) then
			if (((230 + 906) >= (419 - 265)) and v19(v91.PresenceofMind)) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and (v12:BuffUp(v91.PresenceofMindBuff))) or ((561 - (23 + 267)) > (6692 - (1129 + 815)))) then
			if (((5127 - (371 + 16)) >= (4902 - (1326 + 424))) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v12:BuffDown(v91.NetherPrecisionBuff) and v12:BuffUp(v91.ClearcastingBuff) and (v13:DebuffDown(v91.RadiantSparkVulnerability) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (7 - 3)) and v12:PrevGCDP(3 - 2, v91.ArcaneBlast)))) or ((2696 - (88 + 30)) >= (4161 - (720 + 51)))) then
			if (((91 - 50) <= (3437 - (421 + 1355))) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if (((991 - 390) < (1749 + 1811)) and v91.ArcaneBlast:IsReady() and v31) then
			if (((1318 - (286 + 797)) < (2511 - 1824)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v119()
		local v131 = 0 - 0;
		while true do
			if (((4988 - (397 + 42)) > (361 + 792)) and (v131 == (801 - (24 + 776)))) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) >= (2 - 0)) and (v91.RadiantSpark:CooldownRemains() < (790 - (222 + 563))) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (12 - 6)))) or ((3366 + 1308) < (4862 - (23 + 167)))) then
					if (((5466 - (690 + 1108)) < (1646 + 2915)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v91.ArcaneHarmonyBuff) < (13 + 2)) and ((v105 and v12:BloodlustUp()) or (v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (853 - (40 + 808))))) and (v91.ArcaneSurge:CooldownRemains() < (5 + 25))) or ((1739 - 1284) == (3446 + 159))) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((1409 + 1254) == (1817 + 1495))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if (((4848 - (47 + 524)) <= (2905 + 1570)) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
					if (v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark)) or ((2378 - 1508) == (1777 - 588))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((3541 - 1988) <= (4859 - (1165 + 561))) and v91.NetherTempest:IsReady() and v40 and not v106 and (v91.NetherTempest:TimeSinceLastCast() >= (1 + 14)) and ((not v106 and v12:PrevGCDP(12 - 8, v91.RadiantSpark) and (v91.ArcaneSurge:CooldownRemains() <= v91.NetherTempest:ExecuteTime())) or v12:PrevGCDP(2 + 3, v91.RadiantSpark))) then
					if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((2716 - (341 + 138)) >= (948 + 2563))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v131 = 3 - 1;
			end
			if ((v131 == (329 - (89 + 237))) or ((4259 - 2935) > (6358 - 3338))) then
				if ((v91.ArcaneBlast:IsReady() and v31) or ((3873 - (581 + 300)) == (3101 - (855 + 365)))) then
					if (((7377 - 4271) > (499 + 1027)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if (((4258 - (1030 + 205)) < (3634 + 236)) and v91.ArcaneBarrage:IsReady() and v32) then
					if (((134 + 9) > (360 - (156 + 130))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if (((40 - 22) < (3558 - 1446)) and (v131 == (0 - 0))) then
				if (((290 + 807) <= (950 + 678)) and v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (114 - (10 + 59))) and v13:DebuffDown(v91.NetherTempestDebuff) and v105 and v12:BloodlustUp()) then
					if (((1310 + 3320) == (22801 - 18171)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((4703 - (671 + 492)) > (2136 + 547)) and v105 and v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (1215 - (369 + 846))) and v12:BuffUp(v91.NetherPrecisionBuff) and v12:BuffDown(v91.ArcaneArtilleryBuff)) then
					if (((1270 + 3524) >= (2795 + 480)) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((3429 - (1036 + 909)) == (1180 + 304)) and v91.ArcaneMissiles:IsCastable() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (8 - 3)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (209 - (11 + 192))))) and v12:HasTier(16 + 15, 179 - (135 + 40))) then
					if (((3469 - 2037) < (2143 + 1412)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v108) and (v12:BuffRemains(v91.SiphonStormBuff) > (32 - 17))) or ((1596 - 531) > (3754 - (50 + 126)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((13351 - 8556) < (312 + 1095))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v131 = 1414 - (1233 + 180);
			end
			if (((2822 - (522 + 447)) < (6234 - (107 + 1314))) and (v131 == (1 + 1))) then
				if ((v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111) and ((not v91.NetherTempest:IsAvailable() and ((v12:PrevGCDP(11 - 7, v91.RadiantSpark) and not v106) or v12:PrevGCDP(3 + 2, v91.RadiantSpark))) or v12:PrevGCDP(1 - 0, v91.NetherTempest))) or ((11161 - 8340) < (4341 - (716 + 1194)))) then
					if (v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge)) or ((50 + 2824) < (234 + 1947))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and (v91.ArcaneBlast:CastTime() >= v12:GCD()) and (v91.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v91.RadiantSparkVulnerability)) and (not v91.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (538 - (74 + 429)))) and ((v91.NetherTempest:IsAvailable() and v12:PrevGCDP(11 - 5, v91.RadiantSpark)) or (not v91.NetherTempest:IsAvailable() and v12:PrevGCDP(3 + 2, v91.RadiantSpark))) and not (v12:IsCasting(v91.ArcaneSurge) and (v12:CastRemains() < (0.5 - 0)) and not v106)) or ((1903 + 786) <= (1056 - 713))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((4620 - 2751) == (2442 - (279 + 154)))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v13:DebuffStack(v91.RadiantSparkVulnerability) == (782 - (454 + 324)))) or ((2790 + 756) < (2339 - (12 + 5)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((1123 + 959) == (12161 - 7388))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((1199 + 2045) > (2148 - (277 + 816))) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and v12:PrevGCDP(4 - 3, v91.ArcaneBarrage) and ((v91.ArcaneBarrage:InFlight() and ((v91.ArcaneBarrage:TravelTime() - v91.ArcaneBarrage:TimeSinceLastCast()) <= (1183.2 - (1058 + 125)))) or (v12:GCDRemains() <= (0.2 + 0)))) then
					if (v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi)) or ((4288 - (815 + 160)) <= (7628 - 5850))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v131 = 7 - 4;
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if (((0 - 0) == v132) or ((3319 - (41 + 1857)) >= (3997 - (1222 + 671)))) then
				if (((4683 - 2871) <= (4669 - 1420)) and v12:BuffUp(v91.PresenceofMindBuff) and v89 and (v12:PrevGCDP(1183 - (229 + 953), v91.ArcaneBlast)) and (v12:CooldownRemains(v91.ArcaneSurge) > (1849 - (1111 + 663)))) then
					if (((3202 - (874 + 705)) <= (274 + 1683)) and v19(v93.CancelPOM)) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if (((3011 + 1401) == (9170 - 4758)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(1 + 0, v91.ArcaneBarrage))) then
					if (((2429 - (642 + 37)) >= (192 + 650)) and v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if (((700 + 3672) > (4644 - 2794)) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
					if (((686 - (233 + 221)) < (1898 - 1077)) and v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark), true)) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				if (((456 + 62) < (2443 - (718 + 823))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v91.ArcaneOrb:TimeSinceLastCast() >= (10 + 5)) and (v12:ArcaneCharges() < (808 - (266 + 539)))) then
					if (((8476 - 5482) > (2083 - (636 + 589))) and v19(v91.ArcaneOrb, not v13:IsInRange(94 - 54))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				v132 = 1 - 0;
			end
			if ((v132 == (1 + 0)) or ((1365 + 2390) <= (1930 - (657 + 358)))) then
				if (((10447 - 6501) > (8527 - 4784)) and v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (1202 - (1151 + 36))) and (v91.ArcaneEcho:IsAvailable())) then
					if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((1290 + 45) >= (870 + 2436))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if (((14466 - 9622) > (4085 - (1552 + 280))) and v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
					if (((1286 - (64 + 770)) == (307 + 145)) and v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v91.ArcaneSurge:CooldownRemains() < (170 - 95)) and (v13:DebuffStack(v91.RadiantSparkVulnerability) == (1 + 3)) and not v91.OrbBarrage:IsAvailable()) or ((5800 - (157 + 1086)) < (4176 - 2089))) then
					if (((16967 - 13093) == (5942 - 2068)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (((v13:DebuffStack(v91.RadiantSparkVulnerability) == (2 - 0)) and (v91.ArcaneSurge:CooldownRemains() > (894 - (599 + 220)))) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (1 - 0)) and (v91.ArcaneSurge:CooldownRemains() < (2006 - (1813 + 118))) and not v91.OrbBarrage:IsAvailable()))) or ((1417 + 521) > (6152 - (841 + 376)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((5961 - 1706) < (796 + 2627))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				v132 = 5 - 3;
			end
			if (((2313 - (464 + 395)) <= (6392 - 3901)) and ((1 + 1) == v132)) then
				if ((v91.ArcaneBarrage:IsReady() and v32 and ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (838 - (467 + 370))) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (3 - 1)) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (3 + 0)) and ((v98 > (17 - 12)) or (v99 > (1 + 4)))) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (8 - 4))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v91.OrbBarrage:IsAvailable()) or ((4677 - (150 + 370)) <= (4085 - (74 + 1208)))) then
					if (((11936 - 7083) >= (14142 - 11160)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				if (((2942 + 1192) > (3747 - (14 + 376))) and v91.PresenceofMind:IsCastable() and v41) then
					if (v19(v91.PresenceofMind) or ((5926 - 2509) < (1640 + 894))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and ((((v13:DebuffStack(v91.RadiantSparkVulnerability) == (2 + 0)) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (3 + 0))) and not v91.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v91.RadiantSparkVulnerability) and v91.OrbBarrage:IsAvailable()))) or ((7975 - 5253) <= (124 + 40))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((2486 - (23 + 55)) < (4997 - 2888))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (((v13:DebuffStack(v91.RadiantSparkVulnerability) == (3 + 1)) and v12:BuffUp(v91.ArcaneSurgeBuff)) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (3 + 0)) and v12:BuffDown(v91.ArcaneSurgeBuff) and not v91.OrbBarrage:IsAvailable()))) or ((50 - 17) == (458 + 997))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((1344 - (652 + 249)) >= (10744 - 6729))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v133 = 1868 - (708 + 1160);
		while true do
			if (((9180 - 5798) > (302 - 136)) and ((29 - (10 + 17)) == v133)) then
				if ((v91.ArcaneBlast:IsReady() and v31 and (v12:BuffUp(v91.NetherPrecisionBuff))) or ((63 + 217) == (4791 - (1400 + 332)))) then
					if (((3607 - 1726) > (3201 - (242 + 1666))) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 14";
					end
				end
				if (((1009 + 1348) == (864 + 1493)) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and ((v13:DebuffRemains(v91.TouchoftheMagiDebuff) > v91.ArcaneMissiles:CastTime()) or not v91.PresenceofMind:IsAvailable())) then
					if (((105 + 18) == (1063 - (850 + 90))) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31) or ((1848 - 792) >= (4782 - (360 + 1030)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((957 + 124) < (3033 - 1958))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((1442 - 393) >= (6093 - (909 + 752)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((5991 - (109 + 1114)) <= (1548 - 702))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if (((1 + 0) == v133) or ((3600 - (6 + 236)) <= (895 + 525))) then
				if ((v91.ArcaneBlast:IsReady() and v31 and v12:BuffUp(v91.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) or ((3010 + 729) <= (7086 - 4081))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((2897 - 1238) >= (3267 - (1076 + 57)))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v12:BuffUp(v91.ArcaneHarmonyBuff) or (v91.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (6 + 29)))) and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((3949 - (579 + 110)) < (186 + 2169))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((592 + 77) == (2242 + 1981))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				if ((v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (407 - (174 + 233))) and v12:BuffUp(v91.NetherPrecisionBuff) and (((v12:ManaPercentage() > (83 - 53)) and (v91.TouchoftheMagi:CooldownRemains() > (52 - 22))) or (v12:ManaPercentage() > (32 + 38))) and v12:BuffDown(v91.ArcaneArtilleryBuff)) or ((2866 - (663 + 511)) < (525 + 63))) then
					if (v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((1042 + 3755) < (11255 - 7604))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and (v12:BuffStack(v91.ClearcastingBuff) > (1 + 0)) and v91.ConjureManaGem:IsAvailable() and v92.ManaGem:CooldownUp()) or ((9833 - 5656) > (11740 - 6890))) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((191 + 209) > (2162 - 1051))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				v133 = 2 + 0;
			end
			if (((279 + 2772) > (1727 - (478 + 244))) and (v133 == (517 - (440 + 77)))) then
				if (((1680 + 2013) <= (16038 - 11656)) and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) > (1565 - (655 + 901)))) then
					v102 = not v102;
				end
				if ((v91.NetherTempest:IsReady() and v40 and (v13:DebuffRefreshable(v91.NetherTempestDebuff) or not v13:DebuffUp(v91.NetherTempestDebuff)) and (v12:ArcaneCharges() == (1 + 3)) and (v12:ManaPercentage() < (23 + 7)) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v91.ArcaneSurgeBuff)) or ((13221 - 9939) > (5545 - (695 + 750)))) then
					if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((12224 - 8644) < (4388 - 1544))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((357 - 268) < (4841 - (285 + 66))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v12:ArcaneCharges() < (4 - 2)) and (v12:ManaPercentage() < (1340 - (682 + 628))) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v91.ArcaneSurgeBuff)) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(339 - (176 + 123))) or ((2085 + 2898) < (1312 + 496))) then
						return "arcane_orb touch_phase 4";
					end
				end
				if (((4098 - (239 + 30)) > (1025 + 2744)) and v91.PresenceofMind:IsCastable() and v41 and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if (((1428 + 57) <= (5139 - 2235)) and v19(v91.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				v133 = 2 - 1;
			end
		end
	end
	local function v122()
		local v134 = 315 - (306 + 9);
		while true do
			if (((14896 - 10627) == (743 + 3526)) and (v134 == (2 + 0))) then
				if (((187 + 200) <= (7955 - 5173)) and v91.ArcaneExplosion:IsReady() and v33) then
					if (v19(v91.ArcaneExplosion, not v13:IsInRange(1383 - (1140 + 235))) or ((1209 + 690) <= (841 + 76))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((v134 == (0 + 0)) or ((4364 - (33 + 19)) <= (317 + 559))) then
				if (((6689 - 4457) <= (1144 + 1452)) and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) > (17 - 8))) then
					v102 = not v102;
				end
				if (((1965 + 130) < (4375 - (586 + 103))) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ArcaneArtilleryBuff) and v12:BuffUp(v91.ClearcastingBuff)) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((146 + 1449) >= (13773 - 9299))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v134 = 1489 - (1309 + 179);
			end
			if (((1 - 0) == v134) or ((2011 + 2608) < (7739 - 4857))) then
				if ((v91.ArcaneBarrage:IsReady() and v32 and ((((v98 <= (4 + 0)) or (v99 <= (7 - 3))) and (v12:ArcaneCharges() == (5 - 2))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) or ((903 - (295 + 314)) >= (11865 - 7034))) then
					if (((3991 - (1300 + 662)) <= (9684 - 6600)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() < (1757 - (1178 + 577)))) or ((1058 + 979) == (7154 - 4734))) then
					if (((5863 - (851 + 554)) > (3453 + 451)) and v19(v91.ArcaneOrb, not v13:IsInRange(110 - 70))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v134 = 3 - 1;
			end
		end
	end
	local function v123()
		local v135 = 302 - (115 + 187);
		while true do
			if (((334 + 102) >= (117 + 6)) and (v135 == (11 - 8))) then
				if (((1661 - (160 + 1001)) < (1589 + 227)) and v91.NetherTempest:IsReady() and v40 and v13:DebuffRefreshable(v91.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v91.TemporalWarpBuff) or (v12:ManaPercentage() < (7 + 3)) or not v91.ShiftingPower:IsAvailable()) and v12:BuffDown(v91.ArcaneSurgeBuff) and (v111 >= (23 - 11))) then
					if (((3932 - (237 + 121)) == (4471 - (525 + 372))) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest rotation 16";
					end
				end
				if (((418 - 197) < (1281 - 891)) and v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (192 - (96 + 46))) and not v91.Evocation:IsAvailable() and (v111 > (797 - (643 + 134)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((799 + 1414) <= (3407 - 1986))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((11353 - 8295) < (4661 + 199)) and v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (137 - 67)) and v102 and v12:BloodlustUp() and (v91.TouchoftheMagi:CooldownRemains() > (10 - 5)) and (v111 > (739 - (316 + 403)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((862 + 434) >= (12223 - 7777))) then
						return "arcane_barrage rotation 20";
					end
				end
				v135 = 2 + 2;
			end
			if ((v135 == (12 - 7)) or ((988 + 405) > (1447 + 3042))) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and v12:BuffDown(v91.NetherPrecisionBuff) and (not v107 or not v105)) or ((15328 - 10904) < (128 - 101))) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((4148 - 2151) > (219 + 3596))) then
						return "arcane_missiles rotation 30";
					end
				end
				if (((6821 - 3356) > (94 + 1819)) and v91.ArcaneBlast:IsReady() and v31) then
					if (((2156 - 1423) < (1836 - (12 + 5))) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((17070 - 12675) == (10145 - 5390))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((8062 - 4269) < (5874 - 3505))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if ((v135 == (1 + 3)) or ((6057 - (1656 + 317)) == (237 + 28))) then
				if (((3493 + 865) == (11587 - 7229)) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and v12:BuffUp(v91.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((15443 - 12305) < (1347 - (5 + 349)))) then
						return "arcane_missiles rotation 22";
					end
				end
				if (((15816 - 12486) > (3594 - (266 + 1005))) and v91.ArcaneBlast:IsReady() and v31 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v91.NetherPrecisionBuff)) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((2390 + 1236) == (13610 - 9621))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (78 - 18)) and v102 and (v91.TouchoftheMagi:CooldownRemains() > (1706 - (561 + 1135))) and (v91.Evocation:CooldownRemains() > (52 - 12)) and (v111 > (65 - 45))) or ((1982 - (507 + 559)) == (6702 - 4031))) then
					if (((841 - 569) == (660 - (212 + 176))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage rotation 26";
					end
				end
				v135 = 910 - (250 + 655);
			end
			if (((11586 - 7337) <= (8454 - 3615)) and (v135 == (1 - 0))) then
				if (((4733 - (1869 + 87)) < (11098 - 7898)) and v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and not v107 and v12:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() > (1946 - (484 + 1417))) and (v111 > (32 - 17))) then
					if (((158 - 63) < (2730 - (48 + 725))) and v19(v91.ShiftingPower, not v13:IsInRange(65 - 25))) then
						return "shifting_power rotation 6";
					end
				end
				if (((2215 - 1389) < (998 + 719)) and v91.PresenceofMind:IsCastable() and v41 and (v12:ArcaneCharges() < (7 - 4)) and (v13:HealthPercentage() < (10 + 25)) and v91.ArcaneBombardment:IsAvailable()) then
					if (((416 + 1010) >= (1958 - (152 + 701))) and v19(v91.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((4065 - (430 + 881)) <= (1295 + 2084)) and v91.ArcaneBlast:IsReady() and v31 and v91.TimeAnomaly:IsAvailable() and v12:BuffUp(v91.ArcaneSurgeBuff) and (v12:BuffRemains(v91.ArcaneSurgeBuff) <= (901 - (557 + 338)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((1161 + 2766) == (3981 - 2568))) then
						return "arcane_blast rotation 10";
					end
				end
				v135 = 6 - 4;
			end
			if ((v135 == (0 - 0)) or ((2486 - 1332) <= (1589 - (499 + 302)))) then
				if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() < (869 - (39 + 827))) and (v12:BloodlustDown() or (v12:ManaPercentage() > (193 - 123)) or (v107 and (v91.TouchoftheMagi:CooldownRemains() > (67 - 37))))) or ((6525 - 4882) > (5187 - 1808))) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(4 + 36)) or ((8203 - 5400) > (728 + 3821))) then
						return "arcane_orb rotation 2";
					end
				end
				v102 = ((v91.ArcaneSurge:CooldownRemains() > (47 - 17)) and (v91.TouchoftheMagi:CooldownRemains() > (114 - (103 + 1)))) or false;
				if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v107 and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (566 - (475 + 79)))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (25 - 13))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (38 - 26))) and (v111 > (2 + 13))) or ((194 + 26) >= (4525 - (1395 + 108)))) then
					if (((8211 - 5389) == (4026 - (7 + 1197))) and v19(v91.ShiftingPower, not v13:IsInRange(18 + 22))) then
						return "shifting_power rotation 4";
					end
				end
				v135 = 1 + 0;
			end
			if ((v135 == (321 - (27 + 292))) or ((3108 - 2047) == (2367 - 510))) then
				if (((11574 - 8814) > (2689 - 1325)) and v91.ArcaneBlast:IsReady() and v31 and v12:BuffUp(v91.PresenceofMindBuff) and (v13:HealthPercentage() < (66 - 31)) and v91.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (142 - (43 + 96)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((19995 - 15093) <= (8127 - 4532))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v91.NetherPrecisionBuff) and (((v12:ManaPercentage() > (9 + 21)) and (v91.TouchoftheMagi:CooldownRemains() > (59 - 29))) or (v12:ManaPercentage() > (27 + 43))) and v12:BuffDown(v91.ArcaneArtilleryBuff)) or ((7218 - 3366) == (93 + 200))) then
					if (v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((115 + 1444) == (6339 - (1414 + 337)))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) == v109)) or ((6424 - (1642 + 298)) == (2053 - 1265))) then
					if (((13141 - 8573) >= (11594 - 7687)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles rotation 14";
					end
				end
				v135 = 1 + 2;
			end
		end
	end
	local function v124()
		local v136 = 0 + 0;
		while true do
			if (((2218 - (357 + 615)) < (2436 + 1034)) and (v136 == (6 - 3))) then
				if (((3486 + 582) >= (2082 - 1110)) and v91.ArcaneExplosion:IsReady() and v33) then
					if (((395 + 98) < (265 + 3628)) and v19(v91.ArcaneExplosion, not v13:IsInRange(6 + 2))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if ((v136 == (1301 - (384 + 917))) or ((2170 - (128 + 569)) >= (4875 - (1407 + 136)))) then
				if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (1899 - (687 + 1200)))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (1722 - (556 + 1154)))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (42 - 30))) and v12:BuffDown(v91.ArcaneSurgeBuff) and ((not v91.ChargedOrb:IsAvailable() and (v91.ArcaneOrb:CooldownRemains() > (107 - (9 + 86)))) or (v91.ArcaneOrb:Charges() == (421 - (275 + 146))) or (v91.ArcaneOrb:CooldownRemains() > (2 + 10)))) or ((4115 - (29 + 35)) <= (5127 - 3970))) then
					if (((1803 - 1199) < (12718 - 9837)) and v19(v91.ShiftingPower, not v13:IsInRange(27 + 13), true)) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v91.NetherTempest:IsReady() and v40 and v13:DebuffRefreshable(v91.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v91.ArcaneSurgeBuff) and ((v98 > (1018 - (53 + 959))) or (v99 > (414 - (312 + 96))) or not v91.OrbBarrage:IsAvailable())) or ((1562 - 662) == (3662 - (147 + 138)))) then
					if (((5358 - (813 + 86)) > (535 + 56)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v136 = 1 - 0;
			end
			if (((3890 - (18 + 474)) >= (808 + 1587)) and (v136 == (6 - 4))) then
				if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() == (1086 - (860 + 226))) and (v91.TouchoftheMagi:CooldownRemains() > (321 - (121 + 182)))) or ((269 + 1914) >= (4064 - (988 + 252)))) then
					if (((219 + 1717) == (607 + 1329)) and v19(v91.ArcaneOrb, not v13:IsInRange(2010 - (49 + 1921)))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (900 - (223 + 667))))) or ((4884 - (51 + 1)) < (7423 - 3110))) then
					if (((8753 - 4665) > (4999 - (146 + 979))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v136 = 1 + 2;
			end
			if (((4937 - (311 + 294)) == (12080 - 7748)) and (v136 == (1 + 0))) then
				if (((5442 - (496 + 947)) >= (4258 - (1233 + 125))) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ArcaneArtilleryBuff) and v12:BuffUp(v91.ClearcastingBuff) and (v91.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v91.ArcaneArtilleryBuff) + 3 + 2))) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((2266 + 259) > (773 + 3291))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if (((6016 - (963 + 682)) == (3648 + 723)) and v91.ArcaneBarrage:IsReady() and v32 and ((v98 <= (1508 - (504 + 1000))) or (v99 <= (3 + 1)) or v12:BuffUp(v91.ClearcastingBuff)) and (v12:ArcaneCharges() == (3 + 0))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((26 + 240) > (7352 - 2366))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v136 = 2 + 0;
			end
		end
	end
	local function v125()
		if (((1158 + 833) >= (1107 - (156 + 26))) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(1 + 0, v91.ArcaneBarrage))) then
			if (((711 - 256) < (2217 - (149 + 15))) and v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi))) then
				return "touch_of_the_magi main 30";
			end
		end
		if ((v12:IsChanneling(v91.Evocation) and (((v12:ManaPercentage() >= (1055 - (890 + 70))) and not v91.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v111 * (121 - (39 + 78)))) and not ((v111 > (492 - (14 + 468))) and (v91.ArcaneSurge:CooldownRemains() < (2 - 1)))))) or ((2308 - 1482) == (2503 + 2348))) then
			if (((110 + 73) == (39 + 144)) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "cancel_action evocation main 32";
			end
		end
		if (((524 + 635) <= (469 + 1319)) and v91.ArcaneBarrage:IsReady() and v32 and (v111 < (3 - 1))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((3467 + 40) > (15173 - 10855))) then
				return "arcane_barrage main 34";
			end
		end
		if ((v91.Evocation:IsCastable() and v38 and not v105 and v12:BuffDown(v91.ArcaneSurgeBuff) and v13:DebuffDown(v91.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (1 + 9)) and (v91.TouchoftheMagi:CooldownRemains() < (71 - (12 + 39)))) or (v91.TouchoftheMagi:CooldownRemains() < (14 + 1))) and (v12:ManaPercentage() < (v111 * (12 - 8)))) or ((10951 - 7876) <= (879 + 2086))) then
			if (((719 + 646) <= (5099 - 3088)) and v19(v91.Evocation)) then
				return "evocation main 36";
			end
		end
		if ((v91.ConjureManaGem:IsCastable() and v37 and v13:DebuffDown(v91.TouchoftheMagiDebuff) and v12:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() < (20 + 10)) and (v91.ArcaneSurge:CooldownRemains() < v111) and not v92.ManaGem:Exists()) or ((13415 - 10639) > (5285 - (1596 + 114)))) then
			if (v19(v91.ConjureManaGem) or ((6668 - 4114) == (5517 - (164 + 549)))) then
				return "conjure_mana_gem main 38";
			end
		end
		if (((4015 - (1059 + 379)) == (3199 - 622)) and v92.ManaGem:IsReady() and v39 and v91.CascadingPower:IsAvailable() and (v12:BuffStack(v91.ClearcastingBuff) < (2 + 0)) and v12:BuffUp(v91.ArcaneSurgeBuff)) then
			if (v19(v93.ManaGem) or ((2 + 4) >= (2281 - (145 + 247)))) then
				return "mana_gem main 40";
			end
		end
		if (((416 + 90) <= (875 + 1017)) and v92.ManaGem:IsReady() and v39 and not v91.CascadingPower:IsAvailable() and v12:PrevGCDP(2 - 1, v91.ArcaneSurge) and (not v106 or (v106 and v12:PrevGCDP(1 + 1, v91.ArcaneSurge)))) then
			if (v19(v93.ManaGem) or ((1730 + 278) > (3601 - 1383))) then
				return "mana_gem main 42";
			end
		end
		if (((1099 - (254 + 466)) <= (4707 - (544 + 16))) and not v107 and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * ((2 - 1) + v22(v91.NetherTempest:IsAvailable() and v91.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v91.ArcaneSurgeBuff) > ((631 - (294 + 334)) * v22(v12:HasTier(283 - (236 + 17), 1 + 1) and not v12:HasTier(24 + 6, 14 - 10)))) or v12:BuffUp(v91.ArcaneOverloadBuff)) and (v91.Evocation:CooldownRemains() > (213 - 168)) and ((v91.TouchoftheMagi:CooldownRemains() < (v112 * (3 + 1))) or (v91.TouchoftheMagi:CooldownRemains() > (17 + 3))) and ((v98 < v101) or (v99 < v101))) then
			local v158 = 794 - (413 + 381);
			while true do
				if ((v158 == (0 + 0)) or ((9600 - 5086) <= (2620 - 1611))) then
					v25 = v118();
					if (v25 or ((5466 - (582 + 1388)) == (2030 - 838))) then
						return v25;
					end
					break;
				end
			end
		end
		if ((not v107 and (v91.ArcaneSurge:CooldownRemains() > (22 + 8)) and (v91.RadiantSpark:CooldownUp() or v13:DebuffUp(v91.RadiantSparkDebuff) or v13:DebuffUp(v91.RadiantSparkVulnerability)) and ((v91.TouchoftheMagi:CooldownRemains() <= (v112 * (367 - (326 + 38)))) or v13:DebuffUp(v91.TouchoftheMagiDebuff)) and ((v98 < v101) or (v99 < v101))) or ((615 - 407) == (4223 - 1264))) then
			local v159 = 620 - (47 + 573);
			while true do
				if (((1508 + 2769) >= (5576 - 4263)) and (v159 == (0 - 0))) then
					v25 = v118();
					if (((4251 - (1269 + 395)) < (3666 - (76 + 416))) and v25) then
						return v25;
					end
					break;
				end
			end
		end
		if ((v28 and v91.RadiantSpark:IsAvailable() and v103) or ((4563 - (319 + 124)) <= (5024 - 2826))) then
			local v160 = 1007 - (564 + 443);
			while true do
				if ((v160 == (0 - 0)) or ((2054 - (337 + 121)) == (2513 - 1655))) then
					v25 = v120();
					if (((10726 - 7506) == (5131 - (1261 + 650))) and v25) then
						return v25;
					end
					break;
				end
			end
		end
		if ((v28 and v107 and v91.RadiantSpark:IsAvailable() and v104) or ((594 + 808) > (5769 - 2149))) then
			v25 = v119();
			if (((4391 - (772 + 1045)) == (364 + 2210)) and v25) then
				return v25;
			end
		end
		if (((1942 - (102 + 42)) < (4601 - (1524 + 320))) and v28 and v13:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 >= v101) or (v99 >= v101))) then
			v25 = v122();
			if (v25 or ((1647 - (1049 + 221)) > (2760 - (18 + 138)))) then
				return v25;
			end
		end
		if (((1390 - 822) < (2013 - (67 + 1035))) and v28 and v107 and v13:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 < v101) or (v99 < v101))) then
			v25 = v121();
			if (((3633 - (136 + 212)) < (17966 - 13738)) and v25) then
				return v25;
			end
		end
		if (((3138 + 778) > (3068 + 260)) and ((v98 >= v101) or (v99 >= v101))) then
			v25 = v124();
			if (((4104 - (240 + 1364)) < (4921 - (1050 + 32))) and v25) then
				return v25;
			end
		end
		v25 = v123();
		if (((1810 - 1303) == (300 + 207)) and v25) then
			return v25;
		end
	end
	local function v126()
		local v137 = 1055 - (331 + 724);
		while true do
			if (((20 + 220) <= (3809 - (269 + 375))) and (v137 == (727 - (267 + 458)))) then
				v39 = EpicSettings.Settings['useManaGem'];
				v40 = EpicSettings.Settings['useNetherTempest'];
				v41 = EpicSettings.Settings['usePresenceOfMind'];
				v89 = EpicSettings.Settings['cancelPOM'];
				v137 = 1 + 2;
			end
			if (((1603 - 769) >= (1623 - (667 + 151))) and ((1505 - (1410 + 87)) == v137)) then
				v62 = EpicSettings.Settings['alterTimeHP'] or (1897 - (1504 + 393));
				v63 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
				v64 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v65 = EpicSettings.Settings['iceBlockHP'] or (796 - (461 + 335));
				v137 = 2 + 7;
			end
			if ((v137 == (1765 - (1730 + 31))) or ((5479 - (728 + 939)) < (8202 - 5886))) then
				v46 = EpicSettings.Settings['useShiftingPower'];
				v47 = EpicSettings.Settings['useArcaneOrb'];
				v48 = EpicSettings.Settings['useRadiantSpark'];
				v49 = EpicSettings.Settings['useTouchOfTheMagi'];
				v137 = 9 - 4;
			end
			if ((v137 == (0 - 0)) or ((3720 - (138 + 930)) <= (1401 + 132))) then
				v31 = EpicSettings.Settings['useArcaneBlast'];
				v32 = EpicSettings.Settings['useArcaneBarrage'];
				v33 = EpicSettings.Settings['useArcaneExplosion'];
				v34 = EpicSettings.Settings['useArcaneFamiliar'];
				v137 = 1 + 0;
			end
			if ((v137 == (1 + 0)) or ((14691 - 11093) < (3226 - (459 + 1307)))) then
				v35 = EpicSettings.Settings['useArcaneIntellect'];
				v36 = EpicSettings.Settings['useArcaneMissiles'];
				v37 = EpicSettings.Settings['useConjureManaGem'];
				v38 = EpicSettings.Settings['useEvocation'];
				v137 = 1872 - (474 + 1396);
			end
			if ((v137 == (17 - 7)) or ((3858 + 258) < (4 + 1188))) then
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['mirrorImageBeforePull'];
				v90 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((19 - 12) == v137) or ((428 + 2949) <= (3014 - 2111))) then
				v58 = EpicSettings.Settings['useIceBlock'];
				v59 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v61 = EpicSettings.Settings['useMirrorImage'];
				v137 = 34 - 26;
			end
			if (((4567 - (562 + 29)) >= (375 + 64)) and ((1425 - (374 + 1045)) == v137)) then
				v54 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v55 = EpicSettings.Settings['useAlterTime'];
				v56 = EpicSettings.Settings['usePrismaticBarrier'];
				v57 = EpicSettings.Settings['useGreaterInvisibility'];
				v137 = 6 + 1;
			end
			if (((11650 - 7898) == (4390 - (448 + 190))) and ((2 + 3) == v137)) then
				v50 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v51 = EpicSettings.Settings['shiftingPowerWithCD'];
				v52 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v53 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v137 = 3 + 3;
			end
			if (((2637 + 1409) > (10361 - 7666)) and (v137 == (8 - 5))) then
				v42 = EpicSettings.Settings['useCounterspell'];
				v43 = EpicSettings.Settings['useBlastWave'];
				v44 = EpicSettings.Settings['useDragonsBreath'];
				v45 = EpicSettings.Settings['useArcaneSurge'];
				v137 = 1498 - (1307 + 187);
			end
			if ((v137 == (35 - 26)) or ((8300 - 4755) == (9802 - 6605))) then
				v66 = EpicSettings.Settings['iceColdHP'] or (683 - (232 + 451));
				v67 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v68 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v137 = 574 - (510 + 54);
			end
		end
	end
	local function v127()
		v76 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v73 = EpicSettings.Settings['InterruptWithStun'];
		v74 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v75 = EpicSettings.Settings['InterruptThreshold'];
		v70 = EpicSettings.Settings['DispelDebuffs'];
		v69 = EpicSettings.Settings['DispelBuffs'];
		v78 = EpicSettings.Settings['useTrinkets'];
		v77 = EpicSettings.Settings['useRacials'];
		v79 = EpicSettings.Settings['trinketsWithCD'];
		v80 = EpicSettings.Settings['racialsWithCD'];
		v82 = EpicSettings.Settings['useHealthstone'];
		v81 = EpicSettings.Settings['useHealingPotion'];
		v84 = EpicSettings.Settings['healthstoneHP'] or (36 - (13 + 23));
		v83 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v71 = EpicSettings.Settings['handleAfflicted'];
		v72 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v128()
		v126();
		v127();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v29 = EpicSettings.Toggles['minicds'];
		v30 = EpicSettings.Toggles['dispel'];
		if (((3439 - 1045) > (676 - 303)) and v12:IsDeadOrGhost()) then
			return v25;
		end
		v97 = v13:GetEnemiesInSplashRange(1093 - (830 + 258));
		v100 = v12:GetEnemiesInRange(141 - 101);
		if (((2600 + 1555) <= (3601 + 631)) and v27) then
			v98 = v24(v13:GetEnemiesInSplashRangeCount(1446 - (860 + 581)), #v100);
			v99 = #v100;
		else
			local v161 = 0 - 0;
			while true do
				if (((0 + 0) == v161) or ((3822 - (237 + 4)) == (8161 - 4688))) then
					v98 = 2 - 1;
					v99 = 1 - 0;
					break;
				end
			end
		end
		if (((4089 + 906) > (1923 + 1425)) and (v95.TargetIsValid() or v12:AffectingCombat())) then
			local v162 = 0 - 0;
			while true do
				if ((v162 == (0 + 0)) or ((411 + 343) > (5150 - (85 + 1341)))) then
					if (((369 - 152) >= (160 - 103)) and (v12:AffectingCombat() or v70)) then
						local v201 = v70 and v91.RemoveCurse:IsReady() and v30;
						v25 = v95.FocusUnit(v201, v93, 392 - (45 + 327), nil, 37 - 17);
						if (v25 or ((2572 - (444 + 58)) >= (1755 + 2282))) then
							return v25;
						end
					end
					v110 = v9.BossFightRemains(nil, true);
					v162 = 1 + 0;
				end
				if (((1323 + 1382) == (7839 - 5134)) and (v162 == (1733 - (64 + 1668)))) then
					v111 = v110;
					if (((2034 - (1227 + 746)) == (187 - 126)) and (v111 == (20620 - 9509))) then
						v111 = v9.FightRemains(v100, false);
					end
					break;
				end
			end
		end
		v112 = v12:GCD();
		if (v71 or ((1193 - (415 + 79)) >= (34 + 1262))) then
			if (v90 or ((2274 - (142 + 349)) >= (1550 + 2066))) then
				local v200 = 0 - 0;
				while true do
					if ((v200 == (0 + 0)) or ((2757 + 1156) > (12328 - 7801))) then
						v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 1894 - (1710 + 154));
						if (((4694 - (200 + 118)) > (324 + 493)) and v25) then
							return v25;
						end
						break;
					end
				end
			end
		end
		if (((8498 - 3637) > (1221 - 397)) and not v12:AffectingCombat()) then
			if ((v91.ArcaneIntellect:IsCastable() and v35 and (v12:BuffDown(v91.ArcaneIntellect, true) or v95.GroupBuffMissing(v91.ArcaneIntellect))) or ((1229 + 154) >= (2108 + 23))) then
				if (v19(v91.ArcaneIntellect) or ((1007 + 869) >= (406 + 2135))) then
					return "arcane_intellect group_buff";
				end
			end
			if (((3860 - 2078) <= (5022 - (363 + 887))) and v91.ArcaneFamiliar:IsReady() and v34 and v12:BuffDown(v91.ArcaneFamiliarBuff)) then
				if (v19(v91.ArcaneFamiliar) or ((8207 - 3507) < (3869 - 3056))) then
					return "arcane_familiar precombat 2";
				end
			end
			if (((494 + 2705) < (9476 - 5426)) and v91.ConjureManaGem:IsCastable() and v37) then
				if (v19(v91.ConjureManaGem) or ((3384 + 1567) < (6094 - (674 + 990)))) then
					return "conjure_mana_gem precombat 4";
				end
			end
		end
		if (((28 + 68) == (40 + 56)) and v95.TargetIsValid()) then
			local v163 = 0 - 0;
			while true do
				if ((v163 == (1056 - (507 + 548))) or ((3576 - (289 + 548)) > (5826 - (821 + 997)))) then
					v25 = v113();
					if (v25 or ((278 - (195 + 60)) == (305 + 829))) then
						return v25;
					end
					v163 = 1503 - (251 + 1250);
				end
				if ((v163 == (8 - 5)) or ((1851 + 842) >= (5143 - (809 + 223)))) then
					if ((v91.Spellsteal:IsAvailable() and v86 and v91.Spellsteal:IsReady() and v30 and v69 and not v12:IsCasting() and not v12:IsChanneling() and v95.UnitHasMagicBuff(v13)) or ((6298 - 1982) <= (6444 - 4298))) then
						if (v19(v91.Spellsteal, not v13:IsSpellInRange(v91.Spellsteal)) or ((11724 - 8178) <= (2069 + 740))) then
							return "spellsteal damage";
						end
					end
					if (((2568 + 2336) > (2783 - (14 + 603))) and not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v95.TargetIsValid()) then
						local v202 = 129 - (118 + 11);
						local v203;
						while true do
							if (((18 + 91) >= (75 + 15)) and ((11 - 7) == v202)) then
								if (((5927 - (551 + 398)) > (1836 + 1069)) and v25) then
									return v25;
								end
								break;
							end
							if ((v202 == (0 + 0)) or ((2460 + 566) <= (8479 - 6199))) then
								v203 = v95.HandleDPSPotion(not v91.ArcaneSurge:IsReady());
								if (v203 or ((3808 - 2155) <= (360 + 748))) then
									return v203;
								end
								v202 = 3 - 2;
							end
							if (((804 + 2105) > (2698 - (40 + 49))) and (v202 == (3 - 2))) then
								if (((1247 - (99 + 391)) > (161 + 33)) and v87 and v91.TimeWarp:IsReady() and v91.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v91.ArcaneSurge:CooldownUp() or (v111 <= (175 - 135)) or (v12:BuffUp(v91.ArcaneSurgeBuff) and (v111 <= (v91.ArcaneSurge:CooldownRemains() + (34 - 20)))))) then
									if (v19(v91.TimeWarp, not v13:IsInRange(39 + 1)) or ((81 - 50) >= (3002 - (1032 + 572)))) then
										return "time_warp main 4";
									end
								end
								if (((3613 - (203 + 214)) <= (6689 - (568 + 1249))) and v77 and ((v80 and v28) or not v80) and (v76 < v111)) then
									local v206 = 0 + 0;
									while true do
										if (((7988 - 4662) == (12846 - 9520)) and (v206 == (1307 - (913 + 393)))) then
											if (((4046 - 2613) <= (5479 - 1601)) and v12:PrevGCDP(411 - (269 + 141), v91.ArcaneSurge)) then
												if (v91.BloodFury:IsCastable() or ((3520 - 1937) == (3716 - (362 + 1619)))) then
													if (v19(v91.BloodFury) or ((4606 - (950 + 675)) == (906 + 1444))) then
														return "blood_fury main 10";
													end
												end
												if (v91.Fireblood:IsCastable() or ((5645 - (216 + 963)) <= (1780 - (485 + 802)))) then
													if (v19(v91.Fireblood) or ((3106 - (432 + 127)) <= (3060 - (1065 + 8)))) then
														return "fireblood main 12";
													end
												end
												if (((1645 + 1316) > (4341 - (635 + 966))) and v91.AncestralCall:IsCastable()) then
													if (((2658 + 1038) >= (3654 - (5 + 37))) and v19(v91.AncestralCall)) then
														return "ancestral_call main 14";
													end
												end
											end
											break;
										end
										if (((0 - 0) == v206) or ((1236 + 1734) == (2972 - 1094))) then
											if ((v91.LightsJudgment:IsCastable() and v12:BuffDown(v91.ArcaneSurgeBuff) and v13:DebuffDown(v91.TouchoftheMagiDebuff) and ((v98 >= (1 + 1)) or (v99 >= (3 - 1)))) or ((14001 - 10308) < (3727 - 1750))) then
												if (v19(v91.LightsJudgment, not v13:IsSpellInRange(v91.LightsJudgment)) or ((2223 - 1293) > (1511 + 590))) then
													return "lights_judgment main 6";
												end
											end
											if (((4682 - (318 + 211)) > (15184 - 12098)) and v91.Berserking:IsCastable() and ((v12:PrevGCDP(1588 - (963 + 624), v91.ArcaneSurge) and not (v12:BuffUp(v91.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v91.ArcaneSurgeBuff) and v13:DebuffUp(v91.TouchoftheMagiDebuff)))) then
												if (v19(v91.Berserking) or ((1990 + 2664) <= (4896 - (518 + 328)))) then
													return "berserking main 8";
												end
											end
											v206 = 2 - 1;
										end
									end
								end
								v202 = 2 - 0;
							end
							if ((v202 == (320 - (301 + 16))) or ((7626 - 5024) < (4201 - 2705))) then
								if (v25 or ((2661 - 1641) > (2073 + 215))) then
									return v25;
								end
								v25 = v125();
								v202 = 3 + 1;
							end
							if (((699 - 371) == (198 + 130)) and (v202 == (1 + 1))) then
								if (((4803 - 3292) < (1230 + 2578)) and (v76 < v111)) then
									if ((v78 and ((v28 and v79) or not v79)) or ((3529 - (829 + 190)) > (17550 - 12631))) then
										v25 = v115();
										if (((6026 - 1263) == (6583 - 1820)) and v25) then
											return v25;
										end
									end
								end
								v25 = v117();
								v202 = 7 - 4;
							end
						end
					end
					break;
				end
				if (((981 + 3156) > (604 + 1244)) and (v163 == (0 - 0))) then
					if (((2299 + 137) <= (3747 - (520 + 93))) and v14) then
						if (((3999 - (259 + 17)) == (215 + 3508)) and v70) then
							v25 = v114();
							if (v25 or ((1456 + 2590) >= (14611 - 10295))) then
								return v25;
							end
						end
					end
					if ((not v12:AffectingCombat() and v26) or ((2599 - (396 + 195)) < (5596 - 3667))) then
						local v204 = 1761 - (440 + 1321);
						while true do
							if (((4213 - (1059 + 770)) > (8207 - 6432)) and (v204 == (545 - (424 + 121)))) then
								v25 = v116();
								if (v25 or ((829 + 3714) <= (5723 - (641 + 706)))) then
									return v25;
								end
								break;
							end
						end
					end
					v163 = 1 + 0;
				end
				if (((1168 - (249 + 191)) == (3171 - 2443)) and (v163 == (1 + 1))) then
					if (v71 or ((4146 - 3070) > (5098 - (183 + 244)))) then
						if (((91 + 1760) >= (1108 - (434 + 296))) and v90) then
							v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 95 - 65);
							if (v25 or ((2460 - (169 + 343)) >= (3048 + 428))) then
								return v25;
							end
						end
					end
					if (((8435 - 3641) >= (2444 - 1611)) and v72) then
						local v205 = 0 + 0;
						while true do
							if (((11599 - 7509) == (5213 - (651 + 472))) and (v205 == (0 + 0))) then
								v25 = v95.HandleIncorporeal(v91.Polymorph, v93.PolymorphMouseOver, 13 + 17, true);
								if (v25 or ((4585 - 827) == (2981 - (397 + 86)))) then
									return v25;
								end
								break;
							end
						end
					end
					v163 = 879 - (423 + 453);
				end
			end
		end
	end
	local function v129()
		v96();
		v17.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
	end
	v17.SetAPL(7 + 55, v128, v129);
end;
return v0["Epix_Mage_Arcane.lua"]();

