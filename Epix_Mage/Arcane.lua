local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1761 - (1322 + 439);
	local v6;
	while true do
		if (((15712 - 11199) >= (6907 - 4181)) and (v5 == (1528 - (389 + 1138)))) then
			return v6(...);
		end
		if ((v5 == (574 - (102 + 472))) or ((1398 + 83) >= (1474 + 1184))) then
			v6 = v0[v4];
			if (not v6 or ((3003 + 217) == (2909 - (320 + 1225)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Mage_Arcane.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = v10.Unit;
	local v12 = v10.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.Mouseover;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.Press;
	local v22 = v19.Macro;
	local v23 = v19.Bind;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26 = math.max;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v91;
	local v92;
	local v93 = v17.Mage.Arcane;
	local v94 = v18.Mage.Arcane;
	local v95 = v22.Mage.Arcane;
	local v96 = {};
	local v97 = v19.Commons.Everyone;
	local function v98()
		if (v93.RemoveCurse:IsAvailable() or ((645 + 409) > (4856 - (157 + 1307)))) then
			v97.DispellableDebuffs = v97.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v98();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v93.ArcaneBlast:RegisterInFlight();
	v93.ArcaneBarrage:RegisterInFlight();
	local v99, v100;
	local v101, v102;
	local v103 = 1862 - (821 + 1038);
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v13:HasTier(72 - 43, 1 + 3);
	local v110 = (399660 - 174660) - (((9302 + 15698) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((495714 - 295714) * v24(not v109)));
	local v111 = 1029 - (834 + 192);
	local v112 = 707 + 10404;
	local v113 = 2852 + 8259;
	local v114;
	v10:RegisterForEvent(function()
		v104 = false;
		v107 = true;
		v110 = (4831 + 220169) - (((38730 - 13730) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((200304 - (300 + 4)) * v24(not v109)));
		v112 = 2968 + 8143;
		v113 = 29085 - 17974;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v109 = not v13:HasTier(391 - (112 + 250), 2 + 2);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		if ((v93.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v93.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((1693 - 1017) >= (941 + 701))) then
			if (((2139 + 1997) > (1793 + 604)) and v21(v93.PrismaticBarrier)) then
				return "ice_barrier defensive 1";
			end
		end
		if ((v93.MassBarrier:IsCastable() and v62 and v13:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v70, 1 + 1)) or ((3220 + 1114) == (5659 - (1001 + 413)))) then
			if (v21(v93.MassBarrier) or ((9535 - 5259) <= (3913 - (244 + 638)))) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v93.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) or ((5475 - (627 + 66)) <= (3572 - 2373))) then
			if (v21(v93.IceBlock) or ((5466 - (512 + 90)) < (3808 - (1665 + 241)))) then
				return "ice_block defensive 3";
			end
		end
		if (((5556 - (373 + 344)) >= (1669 + 2031)) and v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
			if (v21(v93.IceColdAbility) or ((285 + 790) > (5059 - 3141))) then
				return "ice_cold defensive 3";
			end
		end
		if (((669 - 273) <= (4903 - (35 + 1064))) and v93.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) then
			if (v21(v93.MirrorImage) or ((3034 + 1135) == (4678 - 2491))) then
				return "mirror_image defensive 4";
			end
		end
		if (((6 + 1400) == (2642 - (298 + 938))) and v93.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) then
			if (((2790 - (233 + 1026)) < (5937 - (636 + 1030))) and v21(v93.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((325 + 310) == (621 + 14)) and v93.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) then
			if (((1002 + 2371) <= (241 + 3315)) and v21(v93.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v94.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v86)) or ((3512 - (55 + 166)) < (636 + 2644))) then
			if (((442 + 3944) >= (3333 - 2460)) and v21(v95.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((1218 - (36 + 261)) <= (1926 - 824)) and v83 and (v13:HealthPercentage() <= v85)) then
			local v178 = 1368 - (34 + 1334);
			while true do
				if (((1810 + 2896) >= (749 + 214)) and (v178 == (1283 - (1035 + 248)))) then
					if ((v87 == "Refreshing Healing Potion") or ((981 - (20 + 1)) <= (457 + 419))) then
						if (v94.RefreshingHealingPotion:IsReady() or ((2385 - (134 + 185)) == (2065 - (549 + 584)))) then
							if (((5510 - (314 + 371)) < (16625 - 11782)) and v21(v95.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v87 == "Dreamwalker's Healing Potion") or ((4845 - (478 + 490)) >= (2404 + 2133))) then
						if (v94.DreamwalkersHealingPotion:IsReady() or ((5487 - (786 + 386)) < (5590 - 3864))) then
							if (v21(v95.RefreshingHealingPotion) or ((5058 - (1055 + 324)) < (1965 - (1093 + 247)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local v116 = 0 + 0;
	local function v117()
		if ((v93.RemoveCurse:IsReady() and v97.DispellableFriendlyUnit(3 + 17)) or ((18362 - 13737) < (2144 - 1512))) then
			if ((v116 == (0 - 0)) or ((208 - 125) > (634 + 1146))) then
				v116 = GetTime();
			end
			if (((2103 - 1557) <= (3712 - 2635)) and v97.Wait(378 + 122, v116)) then
				if (v21(v95.RemoveCurseFocus) or ((2547 - 1551) > (4989 - (364 + 324)))) then
					return "remove_curse dispel";
				end
				v116 = 0 - 0;
			end
		end
	end
	local function v118()
		v27 = v97.HandleTopTrinket(v96, v30, 95 - 55, nil);
		if (((1349 + 2721) > (2874 - 2187)) and v27) then
			return v27;
		end
		v27 = v97.HandleBottomTrinket(v96, v30, 64 - 24, nil);
		if (v27 or ((1992 - 1336) >= (4598 - (1249 + 19)))) then
			return v27;
		end
	end
	local function v119()
		if ((v93.MirrorImage:IsCastable() and v90 and v63) or ((2250 + 242) <= (1303 - 968))) then
			if (((5408 - (686 + 400)) >= (2011 + 551)) and v21(v93.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33 and not v93.SiphonStorm:IsAvailable()) or ((3866 - (73 + 156)) >= (18 + 3752))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3190 - (721 + 90)) > (52 + 4526))) then
				return "arcane_blast precombat 4";
			end
		end
		if ((v93.Evocation:IsReady() and v40 and (v93.SiphonStorm:IsAvailable())) or ((1568 - 1085) > (1213 - (224 + 246)))) then
			if (((3974 - 1520) > (1063 - 485)) and v21(v93.Evocation)) then
				return "evocation precombat 6";
			end
		end
		if (((169 + 761) < (107 + 4351)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) then
			if (((487 + 175) <= (1931 - 959)) and v21(v93.ArcaneOrb, not v14:IsInRange(133 - 93))) then
				return "arcane_orb precombat 8";
			end
		end
		if (((4883 - (203 + 310)) == (6363 - (1238 + 755))) and v93.ArcaneBlast:IsReady() and v33) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((333 + 4429) <= (2395 - (709 + 825)))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v120()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (1 - 0)) or ((2276 - (196 + 668)) == (16835 - 12571))) then
				if ((v14:DebuffUp(v93.TouchoftheMagiDebuff) and v107) or ((6561 - 3393) < (2986 - (171 + 662)))) then
					v107 = false;
				end
				v108 = v93.ArcaneBlast:CastTime() < v114;
				break;
			end
			if ((v133 == (93 - (4 + 89))) or ((17440 - 12464) < (486 + 846))) then
				if (((20327 - 15699) == (1815 + 2813)) and ((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (1486 - (35 + 1451))) or (v13:ArcaneCharges() >= (1456 - (28 + 1425)))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (1995 - (941 + 1052))))) then
					v105 = true;
				elseif ((v105 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (7 + 0)) and v93.RadiantSpark:CooldownDown()) or ((1568 - (822 + 692)) == (563 - 168))) then
					v105 = false;
				end
				if (((39 + 43) == (379 - (45 + 252))) and (v13:ArcaneCharges() > (3 + 0)) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (3 + 4))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (12 - 7))) or (v93.ArcaneSurge:CooldownRemains() > (473 - (114 + 319))))) then
					v106 = true;
				elseif ((v106 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (9 - 2)) and v93.RadiantSpark:CooldownDown()) or ((744 - 163) < (180 + 102))) then
					v106 = false;
				end
				v133 = 1 - 0;
			end
		end
	end
	local function v121()
		if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1 - 0, v93.ArcaneBarrage))) or ((6572 - (556 + 1407)) < (3701 - (741 + 465)))) then
			if (((1617 - (170 + 295)) == (607 + 545)) and v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (((1742 + 154) <= (8424 - 5002)) and v93.RadiantSpark:CooldownUp()) then
			v104 = v93.ArcaneSurge:CooldownRemains() < (9 + 1);
		end
		if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) or ((635 + 355) > (918 + 702))) then
			if (v21(v93.ShiftingPower, not v14:IsInRange(1270 - (957 + 273)), true) or ((235 + 642) > (1880 + 2815))) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if (((10253 - 7562) >= (4877 - 3026)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and v93.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(122 - 82)) or ((14780 - 11795) >= (6636 - (389 + 1391)))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if (((2683 + 1593) >= (125 + 1070)) and v93.ArcaneBlast:IsReady() and v33 and v93.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (4 - 2)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) then
			if (((4183 - (783 + 168)) <= (15740 - 11050)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and (v13:ManaPercentage() > (341 - (309 + 2))) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((2751 - 1855) >= (4358 - (1090 + 122)))) then
			if (((993 + 2068) >= (9934 - 6976)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if (((2182 + 1005) >= (1762 - (628 + 490))) and v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1 + 4)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (14 - 8)))) and v13:HasTier(141 - 110, 778 - (431 + 343))) then
			if (((1300 - 656) <= (2036 - 1332)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if (((757 + 201) > (122 + 825)) and v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (1712 - (556 + 1139))) and not v13:HasTier(45 - (6 + 9), 1 + 3)) then
			if (((2302 + 2190) >= (2823 - (28 + 141))) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if (((1334 + 2108) >= (1854 - 351)) and v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (2 + 0)) and (v93.RadiantSpark:CooldownRemains() < (1322 - (486 + 831))) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (15 - 9)))) and not v13:HasTier(105 - 75, 1 + 3)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((10023 - 6853) <= (2727 - (668 + 595)))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (14 + 1)) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (2 + 3)))) and (v93.ArcaneSurge:CooldownRemains() < (81 - 51))) or ((5087 - (23 + 267)) == (6332 - (1129 + 815)))) then
			if (((938 - (371 + 16)) <= (2431 - (1326 + 424))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if (((6206 - 2929) > (1487 - 1080)) and v93.ArcaneMissiles:IsReady() and v38 and v93.RadiantSpark:CooldownUp() and v13:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v13:BuffDown(v93.NetherPrecisionBuff) or (v13:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v13:HasTier(148 - (88 + 30), 775 - (720 + 51))) then
			if (((10444 - 5749) >= (3191 - (421 + 1355))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if ((v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) or ((5298 - 2086) <= (464 + 480))) then
			if (v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true) or ((4179 - (286 + 797)) <= (6572 - 4774))) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if (((5858 - 2321) == (3976 - (397 + 42))) and v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (10 + 20)) and (v93.ArcaneEcho:IsAvailable())) then
			if (((4637 - (24 + 776)) >= (2418 - 848)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if ((v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) or ((3735 - (222 + 563)) == (8398 - 4586))) then
			if (((3401 + 1322) >= (2508 - (23 + 167))) and v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1799 - (690 + 1108), v93.ArcaneSurge) or v13:PrevGCDP(1 + 0, v93.NetherTempest) or v13:PrevGCDP(1 + 0, v93.RadiantSpark))) or ((2875 - (40 + 808)) > (470 + 2382))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((4344 - 3208) > (4127 + 190))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if (((2512 + 2236) == (2604 + 2144)) and v93.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v93.RadiantSparkVulnerability) and (v14:DebuffStack(v93.RadiantSparkVulnerability) < (575 - (47 + 524)))) then
			if (((2425 + 1311) <= (12956 - 8216)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if ((v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((5069 - 1679) <= (6978 - 3918))) then
			if (v21(v93.PresenceofMind) or ((2725 - (1165 + 561)) > (80 + 2613))) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if (((1433 - 970) < (230 + 371)) and v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.PresenceofMindBuff))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2662 - (341 + 138)) < (186 + 501))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if (((9387 - 4838) == (4875 - (89 + 237))) and v93.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v93.NetherPrecisionBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v14:DebuffDown(v93.RadiantSparkVulnerability) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (12 - 8)) and v13:PrevGCDP(1 - 0, v93.ArcaneBlast)))) then
			if (((5553 - (581 + 300)) == (5892 - (855 + 365))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33) or ((8712 - 5044) < (129 + 266))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((5401 - (1030 + 205)) == (428 + 27))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v122()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (287 - (156 + 130))) or ((10108 - 5659) == (4488 - 1825))) then
				if ((v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (30 - 15))) or ((1127 + 3150) < (1743 + 1246))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((939 - (10 + 59)) >= (1174 + 2975))) then
						return "arcane_blast spark_phase 6";
					end
				end
				if (((10893 - 8681) < (4346 - (671 + 492))) and v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (2 + 0)) and (v93.RadiantSpark:CooldownRemains() < (1220 - (369 + 846))) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (2 + 4)))) then
					if (((3965 + 681) > (4937 - (1036 + 909))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if (((1141 + 293) < (5214 - 2108)) and v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (218 - (11 + 192))) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (3 + 2)))) and (v93.ArcaneSurge:CooldownRemains() < (205 - (135 + 40)))) then
					if (((1904 - 1118) < (1823 + 1200)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				v134 = 4 - 2;
			end
			if ((v134 == (2 - 0)) or ((2618 - (50 + 126)) < (206 - 132))) then
				if (((1004 + 3531) == (5948 - (1233 + 180))) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
					if (v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark)) or ((3978 - (522 + 447)) <= (3526 - (107 + 1314)))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((850 + 980) < (11179 - 7510)) and v93.NetherTempest:IsReady() and v42 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (7 + 8)) and ((not v108 and v13:PrevGCDP(7 - 3, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v13:PrevGCDP(19 - 14, v93.RadiantSpark))) then
					if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((3340 - (716 + 1194)) >= (62 + 3550))) then
						return "nether_tempest spark_phase 16";
					end
				end
				if (((288 + 2395) >= (2963 - (74 + 429))) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v13:PrevGCDP(7 - 3, v93.RadiantSpark) and not v108) or v13:PrevGCDP(3 + 2, v93.RadiantSpark))) or v13:PrevGCDP(2 - 1, v93.NetherTempest))) then
					if (v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge)) or ((1277 + 527) >= (10096 - 6821))) then
						return "arcane_surge spark_phase 18";
					end
				end
				v134 = 7 - 4;
			end
			if ((v134 == (433 - (279 + 154))) or ((2195 - (454 + 324)) > (2856 + 773))) then
				if (((4812 - (12 + 5)) > (217 + 185)) and v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (114 - 69)) and v14:DebuffDown(v93.NetherTempestDebuff) and v107 and v13:BloodlustUp()) then
					if (((1779 + 3034) > (4658 - (277 + 816))) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((16716 - 12804) == (5095 - (1058 + 125))) and v107 and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (((3796 - (815 + 160)) <= (20697 - 15873)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((4125 - 2387) <= (524 + 1671)) and v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (14 - 9)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1904 - (41 + 1857))))) and v13:HasTier(1924 - (1222 + 671), 10 - 6)) then
					if (((58 - 17) <= (4200 - (229 + 953))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				v134 = 1775 - (1111 + 663);
			end
			if (((3724 - (874 + 705)) <= (575 + 3529)) and (v134 == (3 + 1))) then
				if (((5588 - 2899) < (137 + 4708)) and v93.ArcaneBlast:IsReady() and v33) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3001 - (642 + 37)) > (598 + 2024))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34) or ((726 + 3808) == (5227 - 3145))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((2025 - (233 + 221)) > (4316 - 2449))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if ((v134 == (3 + 0)) or ((4195 - (718 + 823)) >= (1886 + 1110))) then
				if (((4783 - (266 + 539)) > (5956 - 3852)) and v93.ArcaneBlast:IsReady() and v33 and (v93.ArcaneBlast:CastTime() >= v13:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (1260 - (636 + 589)))) and ((v93.NetherTempest:IsAvailable() and v13:PrevGCDP(14 - 8, v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v13:PrevGCDP(10 - 5, v93.RadiantSpark))) and not (v13:IsCasting(v93.ArcaneSurge) and (v13:CastRemains() < (0.5 + 0)) and not v108)) then
					if (((1089 + 1906) > (2556 - (657 + 358))) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((8602 - 5353) > (2171 - 1218)) and v93.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (1191 - (1151 + 36)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((3161 + 112) > (1203 + 3370))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and v13:PrevGCDP(2 - 1, v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (1832.2 - (1552 + 280)))) or (v13:GCDRemains() <= (834.2 - (64 + 770))))) or ((2140 + 1011) < (2914 - 1630))) then
					if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((329 + 1521) == (2772 - (157 + 1086)))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v134 = 7 - 3;
			end
		end
	end
	local function v123()
		if (((3595 - 2774) < (3255 - 1132)) and v13:BuffUp(v93.PresenceofMindBuff) and v91 and (v13:PrevGCDP(1 - 0, v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (894 - (599 + 220)))) then
			if (((1795 - 893) < (4256 - (1813 + 118))) and v21(v95.CancelPOM)) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if (((628 + 230) <= (4179 - (841 + 376))) and v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1 - 0, v93.ArcaneBarrage))) then
			if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((917 + 3029) < (3515 - 2227))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) or ((4101 - (464 + 395)) == (1455 - 888))) then
			if (v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true) or ((407 + 440) >= (2100 - (467 + 370)))) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (30 - 15)) and (v13:ArcaneCharges() < (3 + 0))) or ((7723 - 5470) == (289 + 1562))) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(93 - 53)) or ((2607 - (150 + 370)) > (3654 - (74 + 1208)))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if ((v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (36 - 21)) and (v93.ArcaneEcho:IsAvailable())) or ((21080 - 16635) < (2953 + 1196))) then
			if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((2208 - (14 + 376)) == (147 - 62))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((408 + 222) < (1869 + 258)) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) then
			if (v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge)) or ((1849 + 89) == (7366 - 4852))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if (((3202 + 1053) >= (133 - (23 + 55))) and v93.ArcaneBarrage:IsReady() and v34 and (v93.ArcaneSurge:CooldownRemains() < (177 - 102)) and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 + 1)) and not v93.OrbBarrage:IsAvailable()) then
			if (((2694 + 305) > (1792 - 636)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if (((740 + 1610) > (2056 - (652 + 249))) and v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (5 - 3)) and (v93.ArcaneSurge:CooldownRemains() > (1943 - (708 + 1160)))) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 1)) and (v93.ArcaneSurge:CooldownRemains() < (136 - 61)) and not v93.OrbBarrage:IsAvailable()))) then
			if (((4056 - (10 + 17)) <= (1090 + 3763)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1733 - (1400 + 332))) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 - 1)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1911 - (242 + 1666))) and ((v100 > (3 + 2)) or (v101 > (2 + 3)))) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (4 + 0))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) or ((1456 - (850 + 90)) > (6014 - 2580))) then
			if (((5436 - (360 + 1030)) >= (2685 + 348)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if ((v93.PresenceofMind:IsCastable() and v43) or ((7674 - 4955) <= (1990 - 543))) then
			if (v21(v93.PresenceofMind) or ((5795 - (909 + 752)) < (5149 - (109 + 1114)))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 - 1)) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 1))) and not v93.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) or ((406 - (6 + 236)) >= (1755 + 1030))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((423 + 102) == (4973 - 2864))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if (((57 - 24) == (1166 - (1076 + 57))) and v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 3)) and v13:BuffUp(v93.ArcaneSurgeBuff)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (692 - (579 + 110))) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) then
			if (((242 + 2812) <= (3550 + 465)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v124()
		if (((993 + 878) < (3789 - (174 + 233))) and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (25 - 16))) then
			v104 = not v104;
		end
		if (((2269 - 976) <= (964 + 1202)) and v93.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v93.NetherTempestDebuff) or not v14:DebuffUp(v93.NetherTempestDebuff)) and (v13:ArcaneCharges() == (1178 - (663 + 511))) and (v13:ManaPercentage() < (27 + 3)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) then
			if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((7950 - 5371) < (75 + 48))) then
				return "nether_tempest touch_phase 2";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (4 - 2)) and (v13:ManaPercentage() < (72 - 42)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) or ((1646 - 800) >= (1688 + 680))) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(4 + 36)) or ((4734 - (478 + 244)) <= (3875 - (440 + 77)))) then
				return "arcane_orb touch_phase 4";
			end
		end
		if (((680 + 814) <= (10998 - 7993)) and v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
			if (v21(v93.PresenceofMind) or ((4667 - (655 + 901)) == (396 + 1738))) then
				return "presence_of_mind touch_phase 6";
			end
		end
		if (((1803 + 552) == (1591 + 764)) and v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2368 - 1780) <= (1877 - (695 + 750)))) then
				return "arcane_blast touch_phase 8";
			end
		end
		if (((16380 - 11583) >= (6010 - 2115)) and v93.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (140 - 105)))) and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
			if (((3928 - (285 + 66)) == (8337 - 4760)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage touch_phase 10";
			end
		end
		if (((5104 - (682 + 628)) > (596 + 3097)) and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (299 - (176 + 123))) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (13 + 17)) and (v93.TouchoftheMagi:CooldownRemains() > (22 + 8))) or (v13:ManaPercentage() > (339 - (239 + 30)))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((347 + 928) == (3941 + 159))) then
				return "arcane_missiles interrupt touch_phase 12";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v93.ClearcastingBuff) > (1 - 0)) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) or ((4963 - 3372) >= (3895 - (306 + 9)))) then
			if (((3430 - 2447) <= (315 + 1493)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles touch_phase 12";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.NetherPrecisionBuff))) or ((1320 + 830) <= (577 + 620))) then
			if (((10777 - 7008) >= (2548 - (1140 + 235))) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast touch_phase 14";
			end
		end
		if (((946 + 539) == (1362 + 123)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((851 + 2464) <= (2834 - (33 + 19)))) then
				return "arcane_missiles touch_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33) or ((317 + 559) >= (8883 - 5919))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((984 + 1248) > (4896 - 2399))) then
				return "arcane_blast touch_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34) or ((1979 + 131) <= (1021 - (586 + 103)))) then
			if (((336 + 3350) > (9765 - 6593)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage touch_phase 22";
			end
		end
	end
	local function v125()
		if ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (1497 - (1309 + 179))) or ((8076 - 3602) < (357 + 463))) then
			v104 = not v104;
		end
		if (((11491 - 7212) >= (2177 + 705)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((4310 - 2281) >= (7015 - 3494))) then
				return "arcane_missiles aoe_touch_phase 2";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and ((((v100 <= (613 - (295 + 314))) or (v101 <= (9 - 5))) and (v13:ArcaneCharges() == (1965 - (1300 + 662)))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or ((6396 - 4359) >= (6397 - (1178 + 577)))) then
			if (((894 + 826) < (13178 - 8720)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_touch_phase 4";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (1407 - (851 + 554)))) or ((386 + 50) > (8378 - 5357))) then
			if (((1548 - 835) <= (1149 - (115 + 187))) and v21(v93.ArcaneOrb, not v14:IsInRange(31 + 9))) then
				return "arcane_orb aoe_touch_phase 6";
			end
		end
		if (((2040 + 114) <= (15884 - 11853)) and v93.ArcaneExplosion:IsCastable() and v35) then
			if (((5776 - (160 + 1001)) == (4038 + 577)) and v21(v93.ArcaneExplosion, not v14:IsInRange(7 + 3))) then
				return "arcane_explosion aoe_touch_phase 8";
			end
		end
	end
	local function v126()
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (5 - 2)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (428 - (237 + 121))) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (927 - (525 + 372)))))) or ((7185 - 3395) == (1642 - 1142))) then
			if (((231 - (96 + 46)) < (998 - (643 + 134))) and v21(v93.ArcaneOrb, not v14:IsInRange(15 + 25))) then
				return "arcane_orb rotation 2";
			end
		end
		v104 = ((v93.ArcaneSurge:CooldownRemains() > (71 - 41)) and (v93.TouchoftheMagi:CooldownRemains() > (37 - 27))) or false;
		if (((1970 + 84) >= (2788 - 1367)) and v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (24 - 12))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (731 - (316 + 403)))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (8 + 4))) and (v113 > (41 - 26))) then
			if (((251 + 441) < (7701 - 4643)) and v21(v93.ShiftingPower, not v14:IsInRange(29 + 11))) then
				return "shifting_power rotation 4";
			end
		end
		if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and not v109 and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (15 + 30)) and (v113 > (51 - 36))) or ((15540 - 12286) == (3438 - 1783))) then
			if (v21(v93.ShiftingPower, not v14:IsInRange(3 + 37)) or ((2551 - 1255) == (240 + 4670))) then
				return "shifting_power rotation 6";
			end
		end
		if (((9908 - 6540) == (3385 - (12 + 5))) and v93.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (11 - 8)) and (v14:HealthPercentage() < (74 - 39)) and v93.ArcaneBombardment:IsAvailable()) then
			if (((5618 - 2975) < (9460 - 5645)) and v21(v93.PresenceofMind)) then
				return "presence_of_mind rotation 8";
			end
		end
		if (((389 + 1524) > (2466 - (1656 + 317))) and v93.ArcaneBlast:IsReady() and v33 and v93.TimeAnomaly:IsAvailable() and v13:BuffUp(v93.ArcaneSurgeBuff) and (v13:BuffRemains(v93.ArcaneSurgeBuff) <= (6 + 0))) then
			if (((3811 + 944) > (9115 - 5687)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast rotation 10";
			end
		end
		if (((6796 - 5415) <= (2723 - (5 + 349))) and v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v14:HealthPercentage() < (166 - 131)) and v93.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (1274 - (266 + 1005)))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3192 + 1651) == (13934 - 9850))) then
				return "arcane_blast rotation 12";
			end
		end
		if (((6146 - 1477) > (2059 - (561 + 1135))) and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (98 - 68)) and (v93.TouchoftheMagi:CooldownRemains() > (1096 - (507 + 559)))) or (v13:ManaPercentage() > (175 - 105))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((5804 - 3927) >= (3526 - (212 + 176)))) then
				return "arcane_missiles interrupt rotation 20";
			end
		end
		if (((5647 - (250 + 655)) >= (9887 - 6261)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) == v111)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((7933 - 3393) == (1432 - 516))) then
				return "arcane_missiles rotation 14";
			end
		end
		if ((v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v93.TemporalWarpBuff) or (v13:ManaPercentage() < (1966 - (1869 + 87))) or not v93.ShiftingPower:IsAvailable()) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (41 - 29))) or ((3057 - (484 + 1417)) > (9313 - 4968))) then
			if (((3748 - 1511) < (5022 - (48 + 725))) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest rotation 16";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (81 - 31)) and not v93.Evocation:IsAvailable() and (v113 > (53 - 33))) or ((1560 + 1123) < (61 - 38))) then
			if (((196 + 501) <= (241 + 585)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage rotation 18";
			end
		end
		if (((1958 - (152 + 701)) <= (2487 - (430 + 881))) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (27 + 43)) and v104 and v13:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (900 - (557 + 338))) and (v113 > (6 + 14))) then
			if (((9521 - 6142) <= (13348 - 9536)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage rotation 20";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffUp(v93.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((2093 - 1305) >= (3482 - 1866))) then
			if (((2655 - (499 + 302)) <= (4245 - (39 + 827))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles rotation 22";
			end
		end
		if (((12557 - 8008) == (10159 - 5610)) and v93.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v93.NetherPrecisionBuff)) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((12002 - 8980) >= (4642 - 1618))) then
				return "arcane_blast rotation 24";
			end
		end
		if (((413 + 4407) > (6433 - 4235)) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (10 + 50)) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (15 - 5)) and (v93.Evocation:CooldownRemains() > (144 - (103 + 1))) and (v113 > (574 - (475 + 79)))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((2293 - 1232) >= (15651 - 10760))) then
				return "arcane_barrage rotation 26";
			end
		end
		if (((177 + 1187) <= (3937 + 536)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((5098 - (1395 + 108)) <= (8 - 5))) then
				return "arcane_missiles rotation 30";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33) or ((5876 - (7 + 1197)) == (1680 + 2172))) then
			if (((544 + 1015) == (1878 - (27 + 292))) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast rotation 32";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34) or ((5133 - 3381) <= (1004 - 216))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((16385 - 12478) == (348 - 171))) then
				return "arcane_barrage rotation 34";
			end
		end
	end
	local function v127()
		local v135 = 0 - 0;
		while true do
			if (((3609 - (43 + 96)) > (2263 - 1708)) and (v135 == (3 - 1))) then
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() == (0 + 0)) and (v93.TouchoftheMagi:CooldownRemains() > (6 + 12))) or ((1920 - 948) == (248 + 397))) then
					if (((5962 - 2780) >= (666 + 1449)) and v21(v93.ArcaneOrb, not v14:IsInRange(3 + 37))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((5644 - (1414 + 337)) < (6369 - (1642 + 298))) and v93.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (26 - 16)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((8247 - 5380) < (5653 - 3748))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v135 = 1 + 2;
			end
			if (((3 + 0) == v135) or ((2768 - (357 + 615)) >= (2844 + 1207))) then
				if (((3972 - 2353) <= (3219 + 537)) and v93.ArcaneExplosion:IsCastable() and v35) then
					if (((1294 - 690) == (484 + 120)) and v21(v93.ArcaneExplosion, not v14:IsInRange(1 + 9))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if ((v135 == (1 + 0)) or ((5785 - (384 + 917)) == (1597 - (128 + 569)))) then
				if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v93.ArcaneArtilleryBuff) + (1548 - (1407 + 136))))) or ((6346 - (687 + 1200)) <= (2823 - (556 + 1154)))) then
					if (((12777 - 9145) > (3493 - (9 + 86))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if (((4503 - (275 + 146)) <= (800 + 4117)) and v93.ArcaneBarrage:IsReady() and v34 and ((v100 <= (68 - (29 + 35))) or (v101 <= (17 - 13)) or v13:BuffUp(v93.ClearcastingBuff)) and (v13:ArcaneCharges() == (8 - 5))) then
					if (((21330 - 16498) >= (903 + 483)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v135 = 1014 - (53 + 959);
			end
			if (((545 - (312 + 96)) == (237 - 100)) and (v135 == (285 - (147 + 138)))) then
				if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (911 - (813 + 86)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (11 + 1))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (21 - 9))) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (504 - (18 + 474)))) or (v93.ArcaneOrb:Charges() == (0 + 0)) or (v93.ArcaneOrb:CooldownRemains() > (39 - 27)))) or ((2656 - (860 + 226)) >= (4635 - (121 + 182)))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(5 + 35), true) or ((5304 - (988 + 252)) <= (206 + 1613))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (2 + 4)) or (v101 > (1976 - (49 + 1921))) or not v93.OrbBarrage:IsAvailable())) or ((5876 - (223 + 667)) < (1626 - (51 + 1)))) then
					if (((7617 - 3191) > (367 - 195)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v135 = 1126 - (146 + 979);
			end
		end
	end
	local function v128()
		local v136 = 0 + 0;
		while true do
			if (((1191 - (311 + 294)) > (1268 - 813)) and (v136 == (0 + 0))) then
				if (((2269 - (496 + 947)) == (2184 - (1233 + 125))) and v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1 + 0, v93.ArcaneBarrage))) then
					if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((3606 + 413) > (844 + 3597))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((3662 - (963 + 682)) < (3556 + 705)) and v13:IsChanneling(v93.Evocation) and (((v13:ManaPercentage() >= (1599 - (504 + 1000))) and not v93.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v113 * (3 + 1))) and not ((v113 > (10 + 0)) and (v93.ArcaneSurge:CooldownRemains() < (1 + 0)))))) then
					if (((6953 - 2237) > (69 + 11)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (v113 < (2 + 0))) or ((3689 - (156 + 26)) == (1885 + 1387))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((1369 - 493) >= (3239 - (149 + 15)))) then
						return "arcane_barrage main 34";
					end
				end
				v136 = 961 - (890 + 70);
			end
			if (((4469 - (39 + 78)) > (3036 - (14 + 468))) and ((4 - 2) == v136)) then
				if ((v94.ManaGem:IsReady() and v41 and not v93.CascadingPower:IsAvailable() and v13:PrevGCDP(2 - 1, v93.ArcaneSurge) and (not v108 or (v108 and v13:PrevGCDP(2 + 0, v93.ArcaneSurge)))) or ((2646 + 1760) < (859 + 3184))) then
					if (v21(v95.ManaGem) or ((854 + 1035) >= (887 + 2496))) then
						return "mana_gem main 42";
					end
				end
				if (((3621 - 1729) <= (2703 + 31)) and not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * ((3 - 2) + v24(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v93.ArcaneSurgeBuff) > ((1 + 2) * v24(v13:HasTier(81 - (12 + 39), 2 + 0) and not v13:HasTier(92 - 62, 14 - 10)))) or v13:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (14 + 31)) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (3 + 1))) or (v93.TouchoftheMagi:CooldownRemains() > (50 - 30))) and ((v100 < v103) or (v101 < v103))) then
					v27 = v121();
					if (((1281 + 642) < (10719 - 8501)) and v27) then
						return v27;
					end
				end
				if (((3883 - (1596 + 114)) > (989 - 610)) and not v109 and (v93.ArcaneSurge:CooldownRemains() > (743 - (164 + 549))) and (v93.RadiantSpark:CooldownUp() or v14:DebuffUp(v93.RadiantSparkDebuff) or v14:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (1441 - (1059 + 379)))) or v14:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) then
					local v197 = 0 - 0;
					while true do
						if ((v197 == (0 + 0)) or ((437 + 2154) == (3801 - (145 + 247)))) then
							v27 = v121();
							if (((3704 + 810) > (1536 + 1788)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				v136 = 8 - 5;
			end
			if ((v136 == (1 + 3)) or ((180 + 28) >= (7839 - 3011))) then
				if ((v30 and v109 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) or ((2303 - (254 + 466)) > (4127 - (544 + 16)))) then
					local v198 = 0 - 0;
					while true do
						if ((v198 == (628 - (294 + 334))) or ((1566 - (236 + 17)) == (343 + 451))) then
							v27 = v124();
							if (((2471 + 703) > (10929 - 8027)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (((19506 - 15386) <= (2194 + 2066)) and ((v100 >= v103) or (v101 >= v103))) then
					v27 = v127();
					if (v27 or ((728 + 155) > (5572 - (413 + 381)))) then
						return v27;
					end
				end
				if ((v100 < v103) or (v101 < v103) or ((153 + 3467) >= (10402 - 5511))) then
					local v199 = 0 - 0;
					while true do
						if (((6228 - (582 + 1388)) > (1596 - 659)) and (v199 == (0 + 0))) then
							v27 = v126();
							if (v27 or ((5233 - (326 + 38)) < (2679 - 1773))) then
								return v27;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v136 == (1 - 0)) or ((1845 - (47 + 573)) > (1491 + 2737))) then
				if (((14134 - 10806) > (3631 - 1393)) and v93.Evocation:IsCastable() and v40 and not v107 and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (1674 - (1269 + 395))) and (v93.TouchoftheMagi:CooldownRemains() < (512 - (76 + 416)))) or (v93.TouchoftheMagi:CooldownRemains() < (458 - (319 + 124)))) and (v13:ManaPercentage() < (v113 * (9 - 5)))) then
					if (((4846 - (564 + 443)) > (3889 - 2484)) and v21(v93.Evocation)) then
						return "evocation main 36";
					end
				end
				if ((v93.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v93.TouchoftheMagiDebuff) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (488 - (337 + 121))) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) or ((3788 - 2495) <= (1688 - 1181))) then
					if (v21(v93.ConjureManaGem) or ((4807 - (1261 + 650)) < (341 + 464))) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((3690 - 1374) == (4133 - (772 + 1045))) and v94.ManaGem:IsReady() and v41 and v93.CascadingPower:IsAvailable() and (v13:BuffStack(v93.ClearcastingBuff) < (1 + 1)) and v13:BuffUp(v93.ArcaneSurgeBuff)) then
					if (v21(v95.ManaGem) or ((2714 - (102 + 42)) == (3377 - (1524 + 320)))) then
						return "mana_gem main 40";
					end
				end
				v136 = 1272 - (1049 + 221);
			end
			if ((v136 == (159 - (18 + 138))) or ((2161 - 1278) == (2562 - (67 + 1035)))) then
				if ((v30 and v93.RadiantSpark:IsAvailable() and v105) or ((4967 - (136 + 212)) <= (4245 - 3246))) then
					local v200 = 0 + 0;
					while true do
						if ((v200 == (0 + 0)) or ((5014 - (240 + 1364)) > (5198 - (1050 + 32)))) then
							v27 = v123();
							if (v27 or ((3224 - 2321) >= (1810 + 1249))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v109 and v93.RadiantSpark:IsAvailable() and v106) or ((5031 - (331 + 724)) < (231 + 2626))) then
					local v201 = 644 - (269 + 375);
					while true do
						if (((5655 - (267 + 458)) > (718 + 1589)) and (v201 == (0 - 0))) then
							v27 = v122();
							if (v27 or ((4864 - (667 + 151)) < (2788 - (1410 + 87)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) or ((6138 - (1504 + 393)) == (9582 - 6037))) then
					local v202 = 0 - 0;
					while true do
						if ((v202 == (796 - (461 + 335))) or ((518 + 3530) > (5993 - (1730 + 31)))) then
							v27 = v125();
							if (v27 or ((3417 - (728 + 939)) >= (12300 - 8827))) then
								return v27;
							end
							break;
						end
					end
				end
				v136 = 7 - 3;
			end
		end
	end
	local function v129()
		v33 = EpicSettings.Settings['useArcaneBlast'];
		v34 = EpicSettings.Settings['useArcaneBarrage'];
		v35 = EpicSettings.Settings['useArcaneExplosion'];
		v36 = EpicSettings.Settings['useArcaneFamiliar'];
		v37 = EpicSettings.Settings['useArcaneIntellect'];
		v38 = EpicSettings.Settings['useArcaneMissiles'];
		v39 = EpicSettings.Settings['useConjureManaGem'];
		v40 = EpicSettings.Settings['useEvocation'];
		v41 = EpicSettings.Settings['useManaGem'];
		v42 = EpicSettings.Settings['useNetherTempest'];
		v43 = EpicSettings.Settings['usePresenceOfMind'];
		v91 = EpicSettings.Settings['cancelPOM'];
		v44 = EpicSettings.Settings['useCounterspell'];
		v45 = EpicSettings.Settings['useBlastWave'];
		v46 = EpicSettings.Settings['useDragonsBreath'];
		v47 = EpicSettings.Settings['useArcaneSurge'];
		v48 = EpicSettings.Settings['useShiftingPower'];
		v49 = EpicSettings.Settings['useArcaneOrb'];
		v50 = EpicSettings.Settings['useRadiantSpark'];
		v51 = EpicSettings.Settings['useTouchOfTheMagi'];
		v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
		v53 = EpicSettings.Settings['shiftingPowerWithCD'];
		v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
		v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
		v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
		v57 = EpicSettings.Settings['useAlterTime'];
		v58 = EpicSettings.Settings['usePrismaticBarrier'];
		v59 = EpicSettings.Settings['useGreaterInvisibility'];
		v60 = EpicSettings.Settings['useIceBlock'];
		v61 = EpicSettings.Settings['useIceCold'];
		v62 = EpicSettings.Settings['useMassBarrier'];
		v63 = EpicSettings.Settings['useMirrorImage'];
		v64 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v65 = EpicSettings.Settings['prismaticBarrierHP'] or (1068 - (138 + 930));
		v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v67 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v70 = EpicSettings.Settings['massBarrierHP'] or (1766 - (459 + 1307));
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v130()
		local v173 = 1870 - (474 + 1396);
		while true do
			if (((5528 - 2362) == (2968 + 198)) and (v173 == (1 + 0))) then
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v71 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v79 = EpicSettings.Settings['useRacials'];
				v173 = 5 - 3;
			end
			if (((224 + 1539) < (12431 - 8707)) and (v173 == (17 - 13))) then
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((648 - (562 + 29)) <= (2322 + 401)) and ((1421 - (374 + 1045)) == v173)) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v83 = EpicSettings.Settings['useHealingPotion'];
				v173 = 3 + 0;
			end
			if (((0 - 0) == v173) or ((2708 - (448 + 190)) == (144 + 299))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v173 = 1 + 0;
			end
			if ((v173 == (11 - 8)) or ((8405 - 5700) == (2887 - (1307 + 187)))) then
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v173 = 11 - 7;
			end
		end
	end
	local function v131()
		local v174 = 683 - (232 + 451);
		while true do
			if (((5 + 0) == v174) or ((4065 + 536) < (625 - (510 + 54)))) then
				if (v97.TargetIsValid() or ((2800 - 1410) >= (4780 - (13 + 23)))) then
					local v203 = 0 - 0;
					while true do
						if ((v203 == (2 - 0)) or ((3638 - 1635) > (4922 - (830 + 258)))) then
							if (v73 or ((549 - 393) > (2449 + 1464))) then
								if (((166 + 29) == (1636 - (860 + 581))) and v92) then
									v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 110 - 80);
									if (((2465 + 640) >= (2037 - (237 + 4))) and v27) then
										return v27;
									end
								end
							end
							if (((10291 - 5912) >= (5391 - 3260)) and v74) then
								local v209 = 0 - 0;
								while true do
									if (((3147 + 697) >= (1174 + 869)) and (v209 == (0 - 0))) then
										v27 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseOver, 13 + 17, true);
										if (v27 or ((1759 + 1473) <= (4157 - (85 + 1341)))) then
											return v27;
										end
										break;
									end
								end
							end
							v203 = 4 - 1;
						end
						if (((13852 - 8947) == (5277 - (45 + 327))) and ((5 - 2) == v203)) then
							if ((v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v97.UnitHasMagicBuff(v14)) or ((4638 - (444 + 58)) >= (1917 + 2494))) then
								if (v21(v93.Spellsteal, not v14:IsSpellInRange(v93.Spellsteal)) or ((509 + 2449) == (1964 + 2053))) then
									return "spellsteal damage";
								end
							end
							if (((3558 - 2330) >= (2545 - (64 + 1668))) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v97.TargetIsValid()) then
								local v210 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
								if (v210 or ((5428 - (1227 + 746)) > (12448 - 8398))) then
									return v210;
								end
								if (((450 - 207) == (737 - (415 + 79))) and v13:IsMoving() and v93.IceFloes:IsReady()) then
									if (v21(v93.IceFloes) or ((7 + 264) > (2063 - (142 + 349)))) then
										return "ice_floes movement";
									end
								end
								if (((1174 + 1565) < (4526 - 1233)) and v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (20 + 20)) or (v13:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + 10 + 4))))) then
									if (v21(v93.TimeWarp, not v14:IsInRange(108 - 68)) or ((5806 - (1710 + 154)) < (1452 - (200 + 118)))) then
										return "time_warp main 4";
									end
								end
								if ((v79 and ((v82 and v30) or not v82) and (v78 < v113)) or ((1068 + 1625) == (8694 - 3721))) then
									local v213 = 0 - 0;
									while true do
										if (((1907 + 239) == (2123 + 23)) and (v213 == (1 + 0))) then
											if (v13:PrevGCDP(1 + 0, v93.ArcaneSurge) or ((4861 - 2617) == (4474 - (363 + 887)))) then
												if (v93.BloodFury:IsCastable() or ((8562 - 3658) <= (9119 - 7203))) then
													if (((14 + 76) <= (2491 - 1426)) and v21(v93.BloodFury)) then
														return "blood_fury main 10";
													end
												end
												if (((3282 + 1520) == (6466 - (674 + 990))) and v93.Fireblood:IsCastable()) then
													if (v21(v93.Fireblood) or ((654 + 1626) <= (210 + 301))) then
														return "fireblood main 12";
													end
												end
												if (v93.AncestralCall:IsCastable() or ((2655 - 979) <= (1518 - (507 + 548)))) then
													if (((4706 - (289 + 548)) == (5687 - (821 + 997))) and v21(v93.AncestralCall)) then
														return "ancestral_call main 14";
													end
												end
											end
											break;
										end
										if (((1413 - (195 + 60)) <= (703 + 1910)) and (v213 == (1501 - (251 + 1250)))) then
											if ((v93.LightsJudgment:IsCastable() and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (5 - 3)) or (v101 >= (2 + 0)))) or ((3396 - (809 + 223)) <= (2916 - 917))) then
												if (v21(v93.LightsJudgment, not v14:IsSpellInRange(v93.LightsJudgment)) or ((14781 - 9859) < (641 - 447))) then
													return "lights_judgment main 6";
												end
											end
											if ((v93.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v93.ArcaneSurge) and not (v13:BuffUp(v93.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v93.ArcaneSurgeBuff) and v14:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((1095 + 996) < (648 - (14 + 603)))) then
												if (v21(v93.Berserking) or ((2559 - (118 + 11)) >= (789 + 4083))) then
													return "berserking main 8";
												end
											end
											v213 = 1 + 0;
										end
									end
								end
								if ((v78 < v113) or ((13901 - 9131) < (2684 - (551 + 398)))) then
									if ((v80 and ((v30 and v81) or not v81)) or ((2806 + 1633) <= (837 + 1513))) then
										local v214 = 0 + 0;
										while true do
											if ((v214 == (0 - 0)) or ((10319 - 5840) < (1448 + 3018))) then
												v27 = v118();
												if (((10111 - 7564) > (339 + 886)) and v27) then
													return v27;
												end
												break;
											end
										end
									end
								end
								v27 = v120();
								if (((4760 - (40 + 49)) > (10182 - 7508)) and v27) then
									return v27;
								end
								v27 = v128();
								if (v27 or ((4186 - (99 + 391)) < (2752 + 575))) then
									return v27;
								end
							end
							break;
						end
						if ((v203 == (0 - 0)) or ((11247 - 6705) == (2894 + 76))) then
							if (((663 - 411) <= (3581 - (1032 + 572))) and v72 and v32 and v93.RemoveCurse:IsAvailable()) then
								local v211 = 417 - (203 + 214);
								while true do
									if ((v211 == (1817 - (568 + 1249))) or ((1124 + 312) == (9066 - 5291))) then
										if (v15 or ((6249 - 4631) < (2236 - (913 + 393)))) then
											v27 = v117();
											if (((13337 - 8614) > (5867 - 1714)) and v27) then
												return v27;
											end
										end
										if ((v16 and v16:Exists() and v16:IsAPlayer() and v97.UnitHasCurseDebuff(v16)) or ((4064 - (269 + 141)) >= (10350 - 5696))) then
											if (((2932 - (362 + 1619)) <= (3121 - (950 + 675))) and v93.RemoveCurse:IsReady()) then
												if (v21(v95.RemoveCurseMouseover) or ((670 + 1066) == (1750 - (216 + 963)))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v13:AffectingCombat() and v28) or ((2183 - (485 + 802)) > (5328 - (432 + 127)))) then
								local v212 = 1073 - (1065 + 8);
								while true do
									if ((v212 == (0 + 0)) or ((2646 - (635 + 966)) <= (734 + 286))) then
										v27 = v119();
										if (v27 or ((1202 - (5 + 37)) <= (815 - 487))) then
											return v27;
										end
										break;
									end
								end
							end
							v203 = 1 + 0;
						end
						if (((6027 - 2219) > (1369 + 1555)) and (v203 == (1 - 0))) then
							v27 = v115();
							if (((14751 - 10860) < (9276 - 4357)) and v27) then
								return v27;
							end
							v203 = 4 - 2;
						end
					end
				end
				break;
			end
			if (((1 + 0) == v174) or ((2763 - (318 + 211)) <= (7390 - 5888))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v174 = 1589 - (963 + 624);
			end
			if ((v174 == (2 + 2)) or ((3358 - (518 + 328)) < (1006 - 574))) then
				v114 = v13:GCD();
				if (v73 or ((2953 - 1105) == (1182 - (301 + 16)))) then
					if (v92 or ((13722 - 9040) <= (12753 - 8212))) then
						local v206 = 0 - 0;
						while true do
							if ((v206 == (0 + 0)) or ((1719 + 1307) >= (8637 - 4591))) then
								v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 19 + 11);
								if (((192 + 1816) > (2028 - 1390)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (((573 + 1202) <= (4252 - (829 + 190))) and (not v13:AffectingCombat() or v28)) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (1 - 0)) or ((6279 - 1736) == (4960 - 2963))) then
							if ((v93.ConjureManaGem:IsCastable() and v39) or ((736 + 2366) < (238 + 490))) then
								if (((1047 - 702) == (326 + 19)) and v21(v93.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
						if ((v204 == (613 - (520 + 93))) or ((3103 - (259 + 17)) < (22 + 356))) then
							if ((v93.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) or ((1251 + 2225) < (8792 - 6195))) then
								if (((3670 - (396 + 195)) < (13908 - 9114)) and v21(v93.ArcaneIntellect)) then
									return "arcane_intellect group_buff";
								end
							end
							if (((6615 - (440 + 1321)) > (6293 - (1059 + 770))) and v93.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v93.ArcaneFamiliarBuff)) then
								if (v21(v93.ArcaneFamiliar) or ((22713 - 17801) == (4303 - (424 + 121)))) then
									return "arcane_familiar precombat 2";
								end
							end
							v204 = 1 + 0;
						end
					end
				end
				v174 = 1352 - (641 + 706);
			end
			if (((50 + 76) <= (3922 - (249 + 191))) and (v174 == (13 - 10))) then
				v102 = v13:GetEnemiesInRange(18 + 22);
				if (v29 or ((9149 - 6775) == (4801 - (183 + 244)))) then
					local v205 = 0 + 0;
					while true do
						if (((2305 - (434 + 296)) == (5026 - 3451)) and (v205 == (512 - (169 + 343)))) then
							v100 = v26(v14:GetEnemiesInSplashRangeCount(5 + 0), #v102);
							v101 = #v102;
							break;
						end
					end
				else
					v100 = 1 - 0;
					v101 = 2 - 1;
				end
				if (v97.TargetIsValid() or v13:AffectingCombat() or ((1831 + 403) == (4126 - 2671))) then
					if (v13:AffectingCombat() or v72 or ((2190 - (651 + 472)) > (1345 + 434))) then
						local v207 = 0 + 0;
						local v208;
						while true do
							if (((2637 - 476) >= (1417 - (397 + 86))) and (v207 == (877 - (423 + 453)))) then
								if (((164 + 1448) == (213 + 1399)) and v27) then
									return v27;
								end
								break;
							end
							if (((3800 + 552) >= (2261 + 572)) and (v207 == (0 + 0))) then
								v208 = v72 and v93.RemoveCurse:IsReady() and v32;
								v27 = v97.FocusUnit(v208, v95, 1210 - (50 + 1140), nil, 18 + 2);
								v207 = 1 + 0;
							end
						end
					end
					v112 = v10.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (691 + 10420)) or ((4626 - 1404) < (2224 + 849))) then
						v113 = v10.FightRemains(v102, false);
					end
				end
				v174 = 600 - (157 + 439);
			end
			if (((1293 - 549) <= (9775 - 6833)) and ((5 - 3) == v174)) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((2751 - (782 + 136)) <= (2177 - (112 + 743)))) then
					return v27;
				end
				v99 = v14:GetEnemiesInSplashRange(1176 - (1026 + 145));
				v174 = 1 + 2;
			end
			if ((v174 == (718 - (493 + 225))) or ((12743 - 9276) <= (642 + 413))) then
				v129();
				v130();
				v28 = EpicSettings.Toggles['ooc'];
				v174 = 2 - 1;
			end
		end
	end
	local function v132()
		v98();
		v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(2 + 60, v131, v132);
end;
return v0["Epix_Mage_Arcane.lua"]();

