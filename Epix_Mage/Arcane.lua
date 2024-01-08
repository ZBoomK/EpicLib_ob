local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((6664 - 3975) < (5749 - (834 + 192))) and not v5) then
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
		if (((263 + 3873) >= (616 + 1781)) and v91.RemoveCurse:IsAvailable()) then
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
	local v101 = 1 + 2;
	local v102 = false;
	local v103 = false;
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = v12:HasTier(44 - 15, 308 - (300 + 4));
	local v108 = (60091 + 164909) - (((65443 - 40443) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((200362 - (112 + 250)) * v22(not v107)));
	local v109 = 2 + 1;
	local v110 = 27835 - 16724;
	local v111 = 6366 + 4745;
	local v112;
	v9:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (2 + 0)) or ((2149 + 2185) == (3154 + 1091))) then
				v111 = 12525 - (1001 + 413);
				break;
			end
			if ((v130 == (0 - 0)) or ((5158 - (244 + 638)) <= (3724 - (627 + 66)))) then
				v102 = false;
				v105 = true;
				v130 = 2 - 1;
			end
			if ((v130 == (603 - (512 + 90))) or ((6688 - (1665 + 241)) <= (1916 - (373 + 344)))) then
				v108 = (101480 + 123520) - (((6615 + 18385) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((527544 - 327544) * v22(not v107)));
				v110 = 18802 - 7691;
				v130 = 1101 - (35 + 1064);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v107 = not v12:HasTier(22 + 7, 8 - 4);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v113()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (1238 - (298 + 938))) or ((6123 - (233 + 1026)) < (3568 - (636 + 1030)))) then
				if (((2475 + 2364) >= (3615 + 85)) and v91.MirrorImage:IsCastable() and v61 and (v12:HealthPercentage() <= v67)) then
					if (v19(v91.MirrorImage) or ((320 + 755) > (130 + 1788))) then
						return "mirror_image defensive 4";
					end
				end
				if (((617 - (55 + 166)) <= (738 + 3066)) and v91.GreaterInvisibility:IsReady() and v57 and (v12:HealthPercentage() <= v64)) then
					if (v19(v91.GreaterInvisibility) or ((420 + 3749) == (8352 - 6165))) then
						return "greater_invisibility defensive 5";
					end
				end
				v131 = 300 - (36 + 261);
			end
			if (((2458 - 1052) == (2774 - (34 + 1334))) and (v131 == (2 + 2))) then
				if (((1190 + 341) < (5554 - (1035 + 248))) and v81 and (v12:HealthPercentage() <= v83)) then
					if (((656 - (20 + 1)) == (331 + 304)) and (v85 == "Refreshing Healing Potion")) then
						if (((3692 - (134 + 185)) <= (4689 - (549 + 584))) and v92.RefreshingHealingPotion:IsReady()) then
							if (v19(v93.RefreshingHealingPotion) or ((3976 - (314 + 371)) < (11260 - 7980))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((5354 - (478 + 490)) >= (463 + 410)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (((2093 - (786 + 386)) <= (3569 - 2467)) and v92.DreamwalkersHealingPotion:IsReady()) then
							if (((6085 - (1055 + 324)) >= (2303 - (1093 + 247))) and v19(v93.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v131 == (1 + 0)) or ((101 + 859) <= (3477 - 2601))) then
				if ((v91.IceBlock:IsCastable() and v58 and (v12:HealthPercentage() <= v65)) or ((7011 - 4945) == (2651 - 1719))) then
					if (((12124 - 7299) < (1723 + 3120)) and v19(v91.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v91.IceColdTalent:IsAvailable() and v91.IceColdAbility:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) or ((14935 - 11058) >= (15638 - 11101))) then
					if (v19(v91.IceColdAbility) or ((3254 + 1061) < (4413 - 2687))) then
						return "ice_cold defensive 3";
					end
				end
				v131 = 690 - (364 + 324);
			end
			if ((v131 == (0 - 0)) or ((8827 - 5148) < (208 + 417))) then
				if ((v91.PrismaticBarrier:IsCastable() and v56 and v12:BuffDown(v91.PrismaticBarrier) and (v12:HealthPercentage() <= v63)) or ((19352 - 14727) < (1011 - 379))) then
					if (v19(v91.PrismaticBarrier) or ((251 - 168) > (3048 - (1249 + 19)))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((493 + 53) <= (4191 - 3114)) and v91.MassBarrier:IsCastable() and v60 and v12:BuffDown(v91.PrismaticBarrier) and v95.AreUnitsBelowHealthPercentage(v68, 1088 - (686 + 400))) then
					if (v19(v91.MassBarrier) or ((782 + 214) > (4530 - (73 + 156)))) then
						return "mass_barrier defensive 2";
					end
				end
				v131 = 1 + 0;
			end
			if (((4881 - (721 + 90)) > (8 + 679)) and (v131 == (9 - 6))) then
				if ((v91.AlterTime:IsReady() and v55 and (v12:HealthPercentage() <= v62)) or ((1126 - (224 + 246)) >= (5394 - 2064))) then
					if (v19(v91.AlterTime) or ((4588 - 2096) <= (61 + 274))) then
						return "alter_time defensive 6";
					end
				end
				if (((103 + 4219) >= (1882 + 680)) and v92.Healthstone:IsReady() and v82 and (v12:HealthPercentage() <= v84)) then
					if (v19(v93.Healthstone) or ((7230 - 3593) >= (12545 - 8775))) then
						return "healthstone defensive";
					end
				end
				v131 = 517 - (203 + 310);
			end
		end
	end
	local function v114()
		if ((v91.RemoveCurse:IsReady() and v30 and v95.DispellableFriendlyUnit(2013 - (1238 + 755))) or ((167 + 2212) > (6112 - (709 + 825)))) then
			if (v19(v93.RemoveCurseFocus) or ((889 - 406) > (1081 - 338))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v115()
		v25 = v95.HandleTopTrinket(v94, v28, 904 - (196 + 668), nil);
		if (((9688 - 7234) > (1196 - 618)) and v25) then
			return v25;
		end
		v25 = v95.HandleBottomTrinket(v94, v28, 873 - (171 + 662), nil);
		if (((1023 - (4 + 89)) < (15625 - 11167)) and v25) then
			return v25;
		end
	end
	local function v116()
		local v132 = 0 + 0;
		while true do
			if (((2907 - 2245) <= (382 + 590)) and ((1486 - (35 + 1451)) == v132)) then
				if (((5823 - (28 + 1425)) == (6363 - (941 + 1052))) and v91.MirrorImage:IsCastable() and v88 and v61) then
					if (v19(v91.MirrorImage) or ((4567 + 195) <= (2375 - (822 + 692)))) then
						return "mirror_image precombat 2";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and not v91.SiphonStorm:IsAvailable()) or ((2015 - 603) == (2009 + 2255))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((3465 - (45 + 252)) < (2131 + 22))) then
						return "arcane_blast precombat 4";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (2 - 1)) or ((5409 - (114 + 319)) < (1911 - 579))) then
				if (((5929 - 1301) == (2951 + 1677)) and v91.Evocation:IsReady() and v38 and (v91.SiphonStorm:IsAvailable())) then
					if (v19(v91.Evocation) or ((79 - 25) == (827 - 432))) then
						return "evocation precombat 6";
					end
				end
				if (((2045 - (556 + 1407)) == (1288 - (741 + 465))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52)) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(505 - (170 + 295))) or ((307 + 274) < (260 + 22))) then
						return "arcane_orb precombat 8";
					end
				end
				v132 = 4 - 2;
			end
			if (((2 + 0) == v132) or ((2956 + 1653) < (1413 + 1082))) then
				if (((2382 - (957 + 273)) == (309 + 843)) and v91.ArcaneBlast:IsReady() and v31) then
					if (((759 + 1137) <= (13039 - 9617)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v117()
		if ((((v98 >= v101) or (v99 >= v101)) and ((v91.ArcaneOrb:Charges() > (0 - 0)) or (v12:ArcaneCharges() >= (9 - 6))) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (9 - 7)))) or ((2770 - (389 + 1391)) > (1017 + 603))) then
			v103 = true;
		elseif ((v103 and v13:DebuffDown(v91.RadiantSparkVulnerability) and (v13:DebuffRemains(v91.RadiantSparkDebuff) < (1 + 6)) and v91.RadiantSpark:CooldownDown()) or ((1996 - 1119) > (5646 - (783 + 168)))) then
			v103 = false;
		end
		if (((9031 - 6340) >= (1821 + 30)) and (v12:ArcaneCharges() > (314 - (309 + 2))) and ((v98 < v101) or (v99 < v101)) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (21 - 14))) and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * (1217 - (1090 + 122)))) or (v91.ArcaneSurge:CooldownRemains() > (13 + 27)))) then
			v104 = true;
		elseif ((v104 and v13:DebuffDown(v91.RadiantSparkVulnerability) and (v13:DebuffRemains(v91.RadiantSparkDebuff) < (23 - 16)) and v91.RadiantSpark:CooldownDown()) or ((2043 + 942) >= (5974 - (628 + 490)))) then
			v104 = false;
		end
		if (((767 + 3509) >= (2958 - 1763)) and v13:DebuffUp(v91.TouchoftheMagiDebuff) and v105) then
			v105 = false;
		end
		v106 = v91.ArcaneBlast:CastTime() < v112;
	end
	local function v118()
		if (((14770 - 11538) <= (5464 - (431 + 343))) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(1 - 0, v91.ArcaneBarrage))) then
			if (v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi)) or ((2591 - 1695) >= (2486 + 660))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (((392 + 2669) >= (4653 - (556 + 1139))) and v91.RadiantSpark:CooldownUp()) then
			v102 = v91.ArcaneSurge:CooldownRemains() < (25 - (6 + 9));
		end
		if (((584 + 2603) >= (330 + 314)) and v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v12:BuffDown(v91.ArcaneSurgeBuff) and not v91.RadiantSpark:IsAvailable()) then
			if (((813 - (28 + 141)) <= (273 + 431)) and v19(v91.ShiftingPower, not v13:IsInRange(49 - 9), true)) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if (((679 + 279) > (2264 - (486 + 831))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and v91.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) then
			if (((11689 - 7197) >= (9343 - 6689)) and v19(v91.ArcaneOrb, not v13:IsInRange(8 + 32))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if (((10883 - 7441) >= (2766 - (668 + 595))) and v91.ArcaneBlast:IsReady() and v31 and v91.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (2 + 0)) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v91.ArcaneOrb:CooldownRemains() >= v112)))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((640 + 2530) <= (3992 - 2528))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if ((v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (290 - (23 + 267))) and (v12:ManaPercentage() > (1974 - (1129 + 815))) and v12:BuffUp(v91.NetherPrecisionBuff) and v12:BuffDown(v91.ArcaneArtilleryBuff)) or ((5184 - (371 + 16)) == (6138 - (1326 + 424)))) then
			if (((1043 - 492) <= (2488 - 1807)) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if (((3395 - (88 + 30)) > (1178 - (720 + 51))) and v91.ArcaneMissiles:IsReady() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (11 - 6)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (1782 - (421 + 1355))))) and v12:HasTier(50 - 19, 2 + 2)) then
			if (((5778 - (286 + 797)) >= (5172 - 3757)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v108) and (v12:BuffRemains(v91.SiphonStormBuff) > (28 - 11)) and not v12:HasTier(469 - (397 + 42), 2 + 2)) or ((4012 - (24 + 776)) <= (1453 - 509))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((3881 - (222 + 563)) <= (3961 - 2163))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if (((2547 + 990) == (3727 - (23 + 167))) and v91.ArcaneMissiles:IsReady() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) >= (1800 - (690 + 1108))) and (v91.RadiantSpark:CooldownRemains() < (2 + 3)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (5 + 1)))) and not v12:HasTier(878 - (40 + 808), 1 + 3)) then
			if (((14672 - 10835) >= (1501 + 69)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v91.ArcaneHarmonyBuff) < (8 + 7)) and ((v105 and v12:BloodlustUp()) or (v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (3 + 2)))) and (v91.ArcaneSurge:CooldownRemains() < (601 - (47 + 524)))) or ((1915 + 1035) == (10420 - 6608))) then
			if (((7062 - 2339) >= (5286 - 2968)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v91.RadiantSpark:CooldownUp() and v12:BuffUp(v91.ClearcastingBuff) and v91.NetherPrecision:IsAvailable() and (v12:BuffDown(v91.NetherPrecisionBuff) or (v12:BuffRemains(v91.NetherPrecisionBuff) < v112)) and v12:HasTier(1756 - (1165 + 561), 1 + 3)) or ((6277 - 4250) > (1089 + 1763))) then
			if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((1615 - (341 + 138)) > (1166 + 3151))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if (((9798 - 5050) == (5074 - (89 + 237))) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
			if (((12018 - 8282) <= (9979 - 5239)) and v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark), true)) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if ((v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (911 - (581 + 300))) and (v91.ArcaneEcho:IsAvailable())) or ((4610 - (855 + 365)) <= (7268 - 4208))) then
			if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((327 + 672) > (3928 - (1030 + 205)))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if (((435 + 28) < (560 + 41)) and v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
			if (v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge)) or ((2469 - (156 + 130)) < (1560 - 873))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if (((7666 - 3117) == (9316 - 4767)) and v91.ArcaneBarrage:IsReady() and v32 and (v12:PrevGCDP(1 + 0, v91.ArcaneSurge) or v12:PrevGCDP(1 + 0, v91.NetherTempest) or v12:PrevGCDP(70 - (10 + 59), v91.RadiantSpark))) then
			if (((1322 + 3350) == (23008 - 18336)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v13:DebuffUp(v91.RadiantSparkVulnerability) and (v13:DebuffStack(v91.RadiantSparkVulnerability) < (1167 - (671 + 492)))) or ((2920 + 748) < (1610 - (369 + 846)))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((1103 + 3063) == (389 + 66))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if ((v91.PresenceofMind:IsCastable() and v41 and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((6394 - (1036 + 909)) == (2118 + 545))) then
			if (v19(v91.PresenceofMind) or ((7180 - 2903) < (3192 - (11 + 192)))) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and (v12:BuffUp(v91.PresenceofMindBuff))) or ((440 + 430) >= (4324 - (135 + 40)))) then
			if (((5359 - 3147) < (1919 + 1264)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if (((10234 - 5588) > (4484 - 1492)) and v91.ArcaneMissiles:IsReady() and v36 and v12:BuffDown(v91.NetherPrecisionBuff) and v12:BuffUp(v91.ClearcastingBuff) and (v13:DebuffDown(v91.RadiantSparkVulnerability) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (180 - (50 + 126))) and v12:PrevGCDP(2 - 1, v91.ArcaneBlast)))) then
			if (((318 + 1116) < (4519 - (1233 + 180))) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if (((1755 - (522 + 447)) < (4444 - (107 + 1314))) and v91.ArcaneBlast:IsReady() and v31) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((1134 + 1308) < (225 - 151))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v119()
		local v133 = 0 + 0;
		while true do
			if (((9005 - 4470) == (17943 - 13408)) and (v133 == (1913 - (716 + 1194)))) then
				if ((v91.ArcaneBlast:IsReady() and v31) or ((52 + 2957) <= (226 + 1879))) then
					if (((2333 - (74 + 429)) < (7077 - 3408)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((709 + 721) >= (8267 - 4655))) then
					if (((1899 + 784) >= (7584 - 5124)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if (((2 - 1) == v133) or ((2237 - (279 + 154)) >= (4053 - (454 + 324)))) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) >= (2 + 0)) and (v91.RadiantSpark:CooldownRemains() < (22 - (12 + 5))) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (4 + 2)))) or ((3610 - 2193) > (1342 + 2287))) then
					if (((5888 - (277 + 816)) > (1717 - 1315)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if (((5996 - (1058 + 125)) > (669 + 2896)) and v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v91.ArcaneHarmonyBuff) < (990 - (815 + 160))) and ((v105 and v12:BloodlustUp()) or (v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (21 - 16)))) and (v91.ArcaneSurge:CooldownRemains() < (71 - 41))) then
					if (((934 + 2978) == (11435 - 7523)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if (((4719 - (41 + 1857)) <= (6717 - (1222 + 671))) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
					if (((4491 - 2753) <= (3154 - 959)) and v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((1223 - (229 + 953)) <= (4792 - (1111 + 663))) and v91.NetherTempest:IsReady() and v40 and not v106 and (v91.NetherTempest:TimeSinceLastCast() >= (1594 - (874 + 705))) and ((not v106 and v12:PrevGCDP(1 + 3, v91.RadiantSpark) and (v91.ArcaneSurge:CooldownRemains() <= v91.NetherTempest:ExecuteTime())) or v12:PrevGCDP(4 + 1, v91.RadiantSpark))) then
					if (((4458 - 2313) <= (116 + 3988)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v133 = 681 - (642 + 37);
			end
			if (((614 + 2075) < (776 + 4069)) and ((4 - 2) == v133)) then
				if ((v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111) and ((not v91.NetherTempest:IsAvailable() and ((v12:PrevGCDP(458 - (233 + 221), v91.RadiantSpark) and not v106) or v12:PrevGCDP(11 - 6, v91.RadiantSpark))) or v12:PrevGCDP(1 + 0, v91.NetherTempest))) or ((3863 - (718 + 823)) > (1650 + 972))) then
					if (v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge)) or ((5339 - (266 + 539)) == (5894 - 3812))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and (v91.ArcaneBlast:CastTime() >= v12:GCD()) and (v91.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v91.RadiantSparkVulnerability)) and (not v91.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (1260 - (636 + 589)))) and ((v91.NetherTempest:IsAvailable() and v12:PrevGCDP(14 - 8, v91.RadiantSpark)) or (not v91.NetherTempest:IsAvailable() and v12:PrevGCDP(10 - 5, v91.RadiantSpark))) and not (v12:IsCasting(v91.ArcaneSurge) and (v12:CastRemains() < (0.5 + 0)) and not v106)) or ((571 + 1000) > (2882 - (657 + 358)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((7026 - 4372) >= (6825 - 3829))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((5165 - (1151 + 36)) > (2032 + 72)) and v91.ArcaneBarrage:IsReady() and v32 and (v13:DebuffStack(v91.RadiantSparkVulnerability) == (2 + 2))) then
					if (((8944 - 5949) > (3373 - (1552 + 280))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((4083 - (64 + 770)) > (648 + 305)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and v12:PrevGCDP(2 - 1, v91.ArcaneBarrage) and ((v91.ArcaneBarrage:InFlight() and ((v91.ArcaneBarrage:TravelTime() - v91.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 + 0))) or (v12:GCDRemains() <= (1243.2 - (157 + 1086))))) then
					if (v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi)) or ((6551 - 3278) > (20028 - 15455))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v133 = 3 - 0;
			end
			if ((v133 == (0 - 0)) or ((3970 - (599 + 220)) < (2556 - 1272))) then
				if ((v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (1976 - (1813 + 118))) and v13:DebuffDown(v91.NetherTempestDebuff) and v105 and v12:BloodlustUp()) or ((1353 + 497) == (2746 - (841 + 376)))) then
					if (((1150 - 329) < (494 + 1629)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((2461 - 1559) < (3184 - (464 + 395))) and v105 and v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v91.NetherPrecisionBuff) and v12:BuffDown(v91.ArcaneArtilleryBuff)) then
					if (((413 + 445) <= (3799 - (467 + 370))) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v105 and v12:BloodlustUp() and v12:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (9 - 4)) and v12:BuffDown(v91.NetherPrecisionBuff) and (v12:BuffDown(v91.ArcaneArtilleryBuff) or (v12:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (5 + 1)))) and v12:HasTier(106 - 75, 1 + 3)) or ((9180 - 5234) < (1808 - (150 + 370)))) then
					if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((4524 - (74 + 1208)) == (1394 - 827))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v108) and (v12:BuffRemains(v91.SiphonStormBuff) > (71 - 56))) or ((603 + 244) >= (1653 - (14 + 376)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((3907 - 1654) == (1198 + 653))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v120()
		if ((v12:BuffUp(v91.PresenceofMindBuff) and v89 and (v12:PrevGCDP(1 + 0, v91.ArcaneBlast)) and (v91.ArcaneSurge:CooldownRemains() > (219 - 144))) or ((1571 + 516) > (2450 - (23 + 55)))) then
			if (v19(v93.CancelPOM) or ((10534 - 6089) < (2769 + 1380))) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if ((v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(1 + 0, v91.ArcaneBarrage))) or ((2818 - 1000) == (27 + 58))) then
			if (((1531 - (652 + 249)) < (5692 - 3565)) and v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or ((3806 - (708 + 1160)) == (6823 - 4309))) then
			if (((7757 - 3502) >= (82 - (10 + 17))) and v19(v91.RadiantSpark, not v13:IsSpellInRange(v91.RadiantSpark), true)) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if (((674 + 2325) > (2888 - (1400 + 332))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v91.ArcaneOrb:TimeSinceLastCast() >= (28 - 13)) and (v12:ArcaneCharges() < (1911 - (242 + 1666)))) then
			if (((1006 + 1344) > (424 + 731)) and v19(v91.ArcaneOrb, not v13:IsInRange(35 + 5))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if (((4969 - (850 + 90)) <= (8499 - 3646)) and v91.NetherTempest:IsReady() and v40 and (v91.NetherTempest:TimeSinceLastCast() >= (1405 - (360 + 1030))) and (v91.ArcaneEcho:IsAvailable())) then
			if (v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest)) or ((457 + 59) > (9692 - 6258))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((5565 - 1519) >= (4694 - (909 + 752))) and v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
			if (v19(v91.ArcaneSurge, not v13:IsSpellInRange(v91.ArcaneSurge)) or ((3942 - (109 + 1114)) <= (2648 - 1201))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and (v91.ArcaneSurge:CooldownRemains() < (30 + 45)) and (v13:DebuffStack(v91.RadiantSparkVulnerability) == (246 - (6 + 236))) and not v91.OrbBarrage:IsAvailable()) or ((2605 + 1529) < (3161 + 765))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((386 - 222) >= (4864 - 2079))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and (((v13:DebuffStack(v91.RadiantSparkVulnerability) == (1135 - (1076 + 57))) and (v91.ArcaneSurge:CooldownRemains() > (13 + 62))) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (690 - (579 + 110))) and (v91.ArcaneSurge:CooldownRemains() < (6 + 69)) and not v91.OrbBarrage:IsAvailable()))) or ((465 + 60) == (1120 + 989))) then
			if (((440 - (174 + 233)) == (92 - 59)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if (((5359 - 2305) <= (1786 + 2229)) and v91.ArcaneBarrage:IsReady() and v32 and ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (1175 - (663 + 511))) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (2 + 0)) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (1 + 2)) and ((v98 > (15 - 10)) or (v99 > (4 + 1)))) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (9 - 5))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v91.OrbBarrage:IsAvailable()) then
			if (((4529 - 2658) < (1614 + 1768)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if (((2516 - 1223) <= (1544 + 622)) and v91.PresenceofMind:IsCastable() and v41) then
			if (v19(v91.PresenceofMind) or ((236 + 2343) < (845 - (478 + 244)))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and ((((v13:DebuffStack(v91.RadiantSparkVulnerability) == (519 - (440 + 77))) or (v13:DebuffStack(v91.RadiantSparkVulnerability) == (2 + 1))) and not v91.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v91.RadiantSparkVulnerability) and v91.OrbBarrage:IsAvailable()))) or ((3096 - 2250) >= (3924 - (655 + 901)))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((744 + 3268) <= (2571 + 787))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if (((1009 + 485) <= (12106 - 9101)) and v91.ArcaneBarrage:IsReady() and v32 and (((v13:DebuffStack(v91.RadiantSparkVulnerability) == (1449 - (695 + 750))) and v12:BuffUp(v91.ArcaneSurgeBuff)) or ((v13:DebuffStack(v91.RadiantSparkVulnerability) == (9 - 6)) and v12:BuffDown(v91.ArcaneSurgeBuff) and not v91.OrbBarrage:IsAvailable()))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((4800 - 1689) == (8582 - 6448))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v121()
		local v134 = 351 - (285 + 66);
		while true do
			if (((5489 - 3134) == (3665 - (682 + 628))) and (v134 == (0 + 0))) then
				if ((v13:DebuffRemains(v91.TouchoftheMagiDebuff) > (308 - (176 + 123))) or ((246 + 342) <= (314 + 118))) then
					v102 = not v102;
				end
				if (((5066 - (239 + 30)) >= (1059 + 2836)) and v91.NetherTempest:IsReady() and v40 and (v13:DebuffRefreshable(v91.NetherTempestDebuff) or not v13:DebuffUp(v91.NetherTempestDebuff)) and (v12:ArcaneCharges() == (4 + 0)) and (v12:ManaPercentage() < (53 - 23)) and (v12:SpellHaste() < (0.667 - 0)) and v12:BuffDown(v91.ArcaneSurgeBuff)) then
					if (((3892 - (306 + 9)) == (12482 - 8905)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((660 + 3134) > (2266 + 1427)) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v12:ArcaneCharges() < (1 + 1)) and (v12:ManaPercentage() < (85 - 55)) and (v12:SpellHaste() < (1375.667 - (1140 + 235))) and v12:BuffDown(v91.ArcaneSurgeBuff)) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(26 + 14)) or ((1170 + 105) == (1053 + 3047))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v134 = 53 - (33 + 19);
			end
			if (((1 + 0) == v134) or ((4768 - 3177) >= (1578 + 2002))) then
				if (((1927 - 944) <= (1696 + 112)) and v91.PresenceofMind:IsCastable() and v41 and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if (v19(v91.PresenceofMind) or ((2839 - (586 + 103)) <= (109 + 1088))) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if (((11603 - 7834) >= (2661 - (1309 + 179))) and v91.ArcaneBlast:IsReady() and v31 and v12:BuffUp(v91.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
					if (((2680 - 1195) == (647 + 838)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v12:BuffUp(v91.ArcaneHarmonyBuff) or (v91.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (93 - 58)))) and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((2504 + 811) <= (5910 - 3128))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((1745 - 869) >= (3573 - (295 + 314)))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v134 = 4 - 2;
			end
			if ((v134 == (1964 - (1300 + 662))) or ((7008 - 4776) > (4252 - (1178 + 577)))) then
				if ((v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v91.NetherPrecisionBuff) and (((v12:ManaPercentage() > (88 - 58)) and (v91.TouchoftheMagi:CooldownRemains() > (1435 - (851 + 554)))) or (v12:ManaPercentage() > (62 + 8))) and v12:BuffDown(v91.ArcaneArtilleryBuff)) or ((5851 - 3741) <= (720 - 388))) then
					if (((3988 - (115 + 187)) > (2430 + 742)) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and (v12:BuffStack(v91.ClearcastingBuff) > (1 + 0)) and v91.ConjureManaGem:IsAvailable() and v92.ManaGem:CooldownUp()) or ((17630 - 13156) < (1981 - (160 + 1001)))) then
					if (((3744 + 535) >= (1989 + 893)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and (v12:BuffUp(v91.NetherPrecisionBuff))) or ((4153 - 2124) >= (3879 - (237 + 121)))) then
					if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((2934 - (525 + 372)) >= (8800 - 4158))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v134 = 9 - 6;
			end
			if (((1862 - (96 + 46)) < (5235 - (643 + 134))) and (v134 == (2 + 1))) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and ((v13:DebuffRemains(v91.TouchoftheMagiDebuff) > v91.ArcaneMissiles:CastTime()) or not v91.PresenceofMind:IsAvailable())) or ((1045 - 609) > (11215 - 8194))) then
					if (((684 + 29) <= (1661 - 814)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((4402 - 2248) <= (4750 - (316 + 403))) and v91.ArcaneBlast:IsReady() and v31) then
					if (((3068 + 1547) == (12688 - 8073)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((1370 + 2420) == (1259 - 759))) then
					if (((64 + 25) < (72 + 149)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v135 = 0 - 0;
		while true do
			if (((9809 - 7755) >= (2951 - 1530)) and (v135 == (1 + 1))) then
				if (((1361 - 669) < (150 + 2908)) and v91.ArcaneExplosion:IsCastable() and v33) then
					if (v19(v91.ArcaneExplosion, not v13:IsInRange(29 - 19)) or ((3271 - (12 + 5)) == (6428 - 4773))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((2754 - 1458) == (12176 - 7266))) then
				if (((684 + 2684) == (5341 - (1656 + 317))) and (v13:DebuffRemains(v91.TouchoftheMagiDebuff) > (9 + 0))) then
					v102 = not v102;
				end
				if (((2118 + 525) < (10144 - 6329)) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ArcaneArtilleryBuff) and v12:BuffUp(v91.ClearcastingBuff)) then
					if (((9414 - 7501) > (847 - (5 + 349))) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v135 = 4 - 3;
			end
			if (((6026 - (266 + 1005)) > (2259 + 1169)) and (v135 == (3 - 2))) then
				if (((1817 - 436) <= (4065 - (561 + 1135))) and v91.ArcaneBarrage:IsReady() and v32 and ((((v98 <= (5 - 1)) or (v99 <= (12 - 8))) and (v12:ArcaneCharges() == (1069 - (507 + 559)))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((12152 - 7309) == (12630 - 8546))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if (((5057 - (212 + 176)) > (1268 - (250 + 655))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() < (5 - 3))) then
					if (v19(v91.ArcaneOrb, not v13:IsInRange(69 - 29)) or ((2936 - 1059) >= (5094 - (1869 + 87)))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v135 = 6 - 4;
			end
		end
	end
	local function v123()
		if (((6643 - (484 + 1417)) >= (7771 - 4145)) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() < (4 - 1)) and (v12:BloodlustDown() or (v12:ManaPercentage() > (843 - (48 + 725))) or (v107 and (v91.TouchoftheMagi:CooldownRemains() > (49 - 19))))) then
			if (v19(v91.ArcaneOrb, not v13:IsInRange(107 - 67)) or ((2639 + 1901) == (2447 - 1531))) then
				return "arcane_orb rotation 2";
			end
		end
		v102 = ((v91.ArcaneSurge:CooldownRemains() > (9 + 21)) and (v91.TouchoftheMagi:CooldownRemains() > (3 + 7))) or false;
		if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v107 and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (865 - (152 + 701)))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (1323 - (430 + 881)))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (5 + 7))) and (v111 > (910 - (557 + 338)))) or ((342 + 814) > (12244 - 7899))) then
			if (((7833 - 5596) < (11288 - 7039)) and v19(v91.ShiftingPower, not v13:IsInRange(86 - 46))) then
				return "shifting_power rotation 4";
			end
		end
		if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and not v107 and v12:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() > (846 - (499 + 302))) and (v111 > (881 - (39 + 827)))) or ((7405 - 4722) < (50 - 27))) then
			if (((2768 - 2071) <= (1267 - 441)) and v19(v91.ShiftingPower, not v13:IsInRange(4 + 36))) then
				return "shifting_power rotation 6";
			end
		end
		if (((3234 - 2129) <= (189 + 987)) and v91.PresenceofMind:IsCastable() and v41 and (v12:ArcaneCharges() < (4 - 1)) and (v13:HealthPercentage() < (139 - (103 + 1))) and v91.ArcaneBombardment:IsAvailable()) then
			if (((3933 - (475 + 79)) <= (8240 - 4428)) and v19(v91.PresenceofMind)) then
				return "presence_of_mind rotation 8";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v91.TimeAnomaly:IsAvailable() and v12:BuffUp(v91.ArcaneSurgeBuff) and (v12:BuffRemains(v91.ArcaneSurgeBuff) <= (19 - 13))) or ((102 + 686) >= (1423 + 193))) then
			if (((3357 - (1395 + 108)) <= (9832 - 6453)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast rotation 10";
			end
		end
		if (((5753 - (7 + 1197)) == (1984 + 2565)) and v91.ArcaneBlast:IsReady() and v31 and v12:BuffUp(v91.PresenceofMindBuff) and (v13:HealthPercentage() < (13 + 22)) and v91.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (322 - (27 + 292)))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((8855 - 5833) >= (3855 - 831))) then
				return "arcane_blast rotation 12";
			end
		end
		if (((20214 - 15394) > (4334 - 2136)) and v12:IsChanneling(v91.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v91.NetherPrecisionBuff) and (((v12:ManaPercentage() > (169 - (43 + 96))) and (v91.TouchoftheMagi:CooldownRemains() > (122 - 92))) or (v12:ManaPercentage() > (158 - 88))) and v12:BuffDown(v91.ArcaneArtilleryBuff)) then
			if (v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((881 + 180) >= (1382 + 3509))) then
				return "arcane_missiles interrupt rotation 20";
			end
		end
		if (((2695 - 1331) <= (1715 + 2758)) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and (v12:BuffStack(v91.ClearcastingBuff) == v109)) then
			if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((6737 - 3142) <= (1 + 2))) then
				return "arcane_missiles rotation 14";
			end
		end
		if ((v91.NetherTempest:IsReady() and v40 and v13:DebuffRefreshable(v91.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v91.TemporalWarpBuff) or (v12:ManaPercentage() < (1 + 9)) or not v91.ShiftingPower:IsAvailable()) and v12:BuffDown(v91.ArcaneSurgeBuff) and (v111 >= (1763 - (1414 + 337)))) or ((6612 - (1642 + 298)) == (10041 - 6189))) then
			if (((4484 - 2925) == (4626 - 3067)) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
				return "nether_tempest rotation 16";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (17 + 33)) and not v91.Evocation:IsAvailable() and (v111 > (16 + 4))) or ((2724 - (357 + 615)) <= (554 + 234))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((9586 - 5679) == (152 + 25))) then
				return "arcane_barrage rotation 18";
			end
		end
		if (((7436 - 3966) > (444 + 111)) and v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (5 + 65)) and v102 and v12:BloodlustUp() and (v91.TouchoftheMagi:CooldownRemains() > (4 + 1)) and (v111 > (1321 - (384 + 917)))) then
			if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((1669 - (128 + 569)) == (2188 - (1407 + 136)))) then
				return "arcane_barrage rotation 20";
			end
		end
		if (((5069 - (687 + 1200)) >= (3825 - (556 + 1154))) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and v12:BuffUp(v91.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
			if (((13695 - 9802) < (4524 - (9 + 86))) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles rotation 22";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v91.NetherPrecisionBuff)) or ((3288 - (275 + 146)) < (310 + 1595))) then
			if (v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast)) or ((1860 - (29 + 35)) >= (17953 - 13902))) then
				return "arcane_blast rotation 24";
			end
		end
		if (((4835 - 3216) <= (16580 - 12824)) and v91.ArcaneBarrage:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (40 + 20)) and v102 and (v91.TouchoftheMagi:CooldownRemains() > (1022 - (53 + 959))) and (v91.Evocation:CooldownRemains() > (448 - (312 + 96))) and (v111 > (34 - 14))) then
			if (((889 - (147 + 138)) == (1503 - (813 + 86))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage rotation 26";
			end
		end
		if ((v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ClearcastingBuff) and v12:BuffDown(v91.NetherPrecisionBuff) and (not v107 or not v105)) or ((4053 + 431) == (1667 - 767))) then
			if (v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles)) or ((4951 - (18 + 474)) <= (376 + 737))) then
				return "arcane_missiles rotation 30";
			end
		end
		if (((11854 - 8222) > (4484 - (860 + 226))) and v91.ArcaneBlast:IsReady() and v31) then
			if (((4385 - (121 + 182)) <= (606 + 4311)) and v19(v91.ArcaneBlast, not v13:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast rotation 32";
			end
		end
		if (((6072 - (988 + 252)) >= (157 + 1229)) and v91.ArcaneBarrage:IsReady() and v32) then
			if (((43 + 94) == (2107 - (49 + 1921))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage rotation 34";
			end
		end
	end
	local function v124()
		if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (902 - (223 + 667)))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (64 - (51 + 1)))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (20 - 8))) and v12:BuffDown(v91.ArcaneSurgeBuff) and ((not v91.ChargedOrb:IsAvailable() and (v91.ArcaneOrb:CooldownRemains() > (25 - 13))) or (v91.ArcaneOrb:Charges() == (1125 - (146 + 979))) or (v91.ArcaneOrb:CooldownRemains() > (4 + 8)))) or ((2175 - (311 + 294)) >= (12080 - 7748))) then
			if (v19(v91.ShiftingPower, not v13:IsInRange(17 + 23), true) or ((5507 - (496 + 947)) <= (3177 - (1233 + 125)))) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v91.NetherTempest:IsReady() and v40 and v13:DebuffRefreshable(v91.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v91.ArcaneSurgeBuff) and ((v98 > (3 + 3)) or (v99 > (6 + 0)) or not v91.OrbBarrage:IsAvailable())) or ((948 + 4038) < (3219 - (963 + 682)))) then
			if (((3694 + 732) > (1676 - (504 + 1000))) and v19(v91.NetherTempest, not v13:IsSpellInRange(v91.NetherTempest))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if (((395 + 191) > (415 + 40)) and v91.ArcaneMissiles:IsCastable() and v36 and v12:BuffUp(v91.ArcaneArtilleryBuff) and v12:BuffUp(v91.ClearcastingBuff) and (v91.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v91.ArcaneArtilleryBuff) + 1 + 4))) then
			if (((1217 - 391) == (706 + 120)) and v19(v91.ArcaneMissiles, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and ((v98 <= (3 + 1)) or (v99 <= (186 - (156 + 26))) or v12:BuffUp(v91.ClearcastingBuff)) and (v12:ArcaneCharges() == (2 + 1))) or ((6287 - 2268) > (4605 - (149 + 15)))) then
			if (((2977 - (890 + 70)) < (4378 - (39 + 78))) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if (((5198 - (14 + 468)) > (175 - 95)) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v12:ArcaneCharges() == (0 - 0)) and (v91.TouchoftheMagi:CooldownRemains() > (10 + 8))) then
			if (v19(v91.ArcaneOrb, not v13:IsInRange(25 + 15)) or ((746 + 2761) == (1478 + 1794))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if ((v91.ArcaneBarrage:IsReady() and v32 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (3 + 7)))) or ((1676 - 800) >= (3040 + 35))) then
			if (((15292 - 10940) > (65 + 2489)) and v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v91.ArcaneExplosion:IsCastable() and v33) or ((4457 - (12 + 39)) < (3762 + 281))) then
			if (v19(v91.ArcaneExplosion, not v13:IsInRange(30 - 20)) or ((6727 - 4838) >= (1003 + 2380))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v125()
		local v136 = 0 + 0;
		while true do
			if (((4797 - 2905) <= (1821 + 913)) and (v136 == (0 - 0))) then
				if (((3633 - (1596 + 114)) < (5790 - 3572)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v12:PrevGCDP(714 - (164 + 549), v91.ArcaneBarrage))) then
					if (((3611 - (1059 + 379)) > (469 - 90)) and v19(v91.TouchoftheMagi, not v13:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v12:IsChanneling(v91.Evocation) and (((v12:ManaPercentage() >= (50 + 45)) and not v91.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v111 * (1 + 3))) and not ((v111 > (402 - (145 + 247))) and (v91.ArcaneSurge:CooldownRemains() < (1 + 0)))))) or ((1198 + 1393) == (10106 - 6697))) then
					if (((867 + 3647) > (2864 + 460)) and v19(v93.StopCasting, not v13:IsSpellInRange(v91.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v111 < (2 - 0))) or ((928 - (254 + 466)) >= (5388 - (544 + 16)))) then
					if (v19(v91.ArcaneBarrage, not v13:IsSpellInRange(v91.ArcaneBarrage)) or ((5030 - 3447) > (4195 - (294 + 334)))) then
						return "arcane_barrage main 34";
					end
				end
				v136 = 254 - (236 + 17);
			end
			if ((v136 == (1 + 1)) or ((1023 + 290) == (2990 - 2196))) then
				if (((15027 - 11853) > (1495 + 1407)) and v92.ManaGem:IsReady() and v39 and not v91.CascadingPower:IsAvailable() and v12:PrevGCDP(1 + 0, v91.ArcaneSurge) and (not v106 or (v106 and v12:PrevGCDP(796 - (413 + 381), v91.ArcaneSurge)))) then
					if (((174 + 3946) <= (9060 - 4800)) and v19(v93.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((not v107 and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * ((2 - 1) + v22(v91.NetherTempest:IsAvailable() and v91.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v91.ArcaneSurgeBuff) > ((1973 - (582 + 1388)) * v22(v12:HasTier(51 - 21, 2 + 0) and not v12:HasTier(394 - (326 + 38), 11 - 7)))) or v12:BuffUp(v91.ArcaneOverloadBuff)) and (v91.Evocation:CooldownRemains() > (64 - 19)) and ((v91.TouchoftheMagi:CooldownRemains() < (v112 * (624 - (47 + 573)))) or (v91.TouchoftheMagi:CooldownRemains() > (8 + 12))) and ((v98 < v101) or (v99 < v101))) or ((3749 - 2866) > (7754 - 2976))) then
					local v200 = 1664 - (1269 + 395);
					while true do
						if (((492 - (76 + 416)) == v200) or ((4063 - (319 + 124)) >= (11180 - 6289))) then
							v25 = v118();
							if (((5265 - (564 + 443)) > (2593 - 1656)) and v25) then
								return v25;
							end
							break;
						end
					end
				end
				if ((not v107 and (v91.ArcaneSurge:CooldownRemains() > (488 - (337 + 121))) and (v91.RadiantSpark:CooldownUp() or v13:DebuffUp(v91.RadiantSparkDebuff) or v13:DebuffUp(v91.RadiantSparkVulnerability)) and ((v91.TouchoftheMagi:CooldownRemains() <= (v112 * (8 - 5))) or v13:DebuffUp(v91.TouchoftheMagiDebuff)) and ((v98 < v101) or (v99 < v101))) or ((16219 - 11350) < (2817 - (1261 + 650)))) then
					v25 = v118();
					if (v25 or ((519 + 706) > (6737 - 2509))) then
						return v25;
					end
				end
				v136 = 1820 - (772 + 1045);
			end
			if (((470 + 2858) > (2382 - (102 + 42))) and (v136 == (1848 - (1524 + 320)))) then
				if (((5109 - (1049 + 221)) > (1561 - (18 + 138))) and v28 and v107 and v13:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 < v101) or (v99 < v101))) then
					v25 = v121();
					if (v25 or ((3164 - 1871) <= (1609 - (67 + 1035)))) then
						return v25;
					end
				end
				if ((v98 >= v101) or (v99 >= v101) or ((3244 - (136 + 212)) < (3420 - 2615))) then
					v25 = v124();
					if (((1856 + 460) == (2136 + 180)) and v25) then
						return v25;
					end
				end
				if ((v98 < v101) or (v99 < v101) or ((4174 - (240 + 1364)) == (2615 - (1050 + 32)))) then
					local v201 = 0 - 0;
					while true do
						if ((v201 == (0 + 0)) or ((1938 - (331 + 724)) == (118 + 1342))) then
							v25 = v123();
							if (v25 or ((5263 - (269 + 375)) <= (1724 - (267 + 458)))) then
								return v25;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v136 == (1 + 2)) or ((6557 - 3147) > (4934 - (667 + 151)))) then
				if ((v28 and v91.RadiantSpark:IsAvailable() and v103) or ((2400 - (1410 + 87)) >= (4956 - (1504 + 393)))) then
					local v202 = 0 - 0;
					while true do
						if ((v202 == (0 - 0)) or ((4772 - (461 + 335)) < (366 + 2491))) then
							v25 = v120();
							if (((6691 - (1730 + 31)) > (3974 - (728 + 939))) and v25) then
								return v25;
							end
							break;
						end
					end
				end
				if ((v28 and v107 and v91.RadiantSpark:IsAvailable() and v104) or ((14329 - 10283) < (2618 - 1327))) then
					v25 = v119();
					if (v25 or ((9717 - 5476) == (4613 - (138 + 930)))) then
						return v25;
					end
				end
				if ((v28 and v13:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 >= v101) or (v99 >= v101))) or ((3700 + 348) > (3309 + 923))) then
					v25 = v122();
					if (v25 or ((1500 + 250) >= (14180 - 10707))) then
						return v25;
					end
				end
				v136 = 1770 - (459 + 1307);
			end
			if (((5036 - (474 + 1396)) == (5528 - 2362)) and (v136 == (1 + 0))) then
				if (((6 + 1757) < (10666 - 6942)) and v91.Evocation:IsCastable() and v38 and not v105 and v12:BuffDown(v91.ArcaneSurgeBuff) and v13:DebuffDown(v91.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (2 + 8)) and (v91.TouchoftheMagi:CooldownRemains() < (66 - 46))) or (v91.TouchoftheMagi:CooldownRemains() < (65 - 50))) and (v12:ManaPercentage() < (v111 * (595 - (562 + 29))))) then
					if (((49 + 8) <= (4142 - (374 + 1045))) and v19(v91.Evocation)) then
						return "evocation main 36";
					end
				end
				if ((v91.ConjureManaGem:IsCastable() and v37 and v13:DebuffDown(v91.TouchoftheMagiDebuff) and v12:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() < (24 + 6)) and (v91.ArcaneSurge:CooldownRemains() < v111) and not v92.ManaGem:Exists()) or ((6427 - 4357) == (1081 - (448 + 190)))) then
					if (v19(v91.ConjureManaGem) or ((874 + 1831) == (629 + 764))) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v92.ManaGem:IsReady() and v39 and v91.CascadingPower:IsAvailable() and (v12:BuffStack(v91.ClearcastingBuff) < (2 + 0)) and v12:BuffUp(v91.ArcaneSurgeBuff)) or ((17689 - 13088) < (189 - 128))) then
					if (v19(v93.ManaGem) or ((2884 - (1307 + 187)) >= (18812 - 14068))) then
						return "mana_gem main 40";
					end
				end
				v136 = 4 - 2;
			end
		end
	end
	local function v126()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (689 - (232 + 451))) or ((1913 + 90) > (3387 + 447))) then
				v54 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v55 = EpicSettings.Settings['useAlterTime'];
				v56 = EpicSettings.Settings['usePrismaticBarrier'];
				v57 = EpicSettings.Settings['useGreaterInvisibility'];
				v137 = 571 - (510 + 54);
			end
			if (((20 - 10) == v137) or ((192 - (13 + 23)) > (7627 - 3714))) then
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['mirrorImageBeforePull'];
				v90 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((279 - 84) == (353 - 158)) and (v137 == (1088 - (830 + 258)))) then
				v31 = EpicSettings.Settings['useArcaneBlast'];
				v32 = EpicSettings.Settings['useArcaneBarrage'];
				v33 = EpicSettings.Settings['useArcaneExplosion'];
				v34 = EpicSettings.Settings['useArcaneFamiliar'];
				v137 = 3 - 2;
			end
			if (((1943 + 1162) >= (1529 + 267)) and ((1443 - (860 + 581)) == v137)) then
				v39 = EpicSettings.Settings['useManaGem'];
				v40 = EpicSettings.Settings['useNetherTempest'];
				v41 = EpicSettings.Settings['usePresenceOfMind'];
				v89 = EpicSettings.Settings['cancelPOM'];
				v137 = 10 - 7;
			end
			if (((3476 + 903) >= (2372 - (237 + 4))) and (v137 == (20 - 11))) then
				v66 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v67 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v68 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v137 = 6 + 4;
			end
			if (((14512 - 10668) >= (877 + 1166)) and ((1 + 0) == v137)) then
				v35 = EpicSettings.Settings['useArcaneIntellect'];
				v36 = EpicSettings.Settings['useArcaneMissiles'];
				v37 = EpicSettings.Settings['useConjureManaGem'];
				v38 = EpicSettings.Settings['useEvocation'];
				v137 = 1428 - (85 + 1341);
			end
			if ((v137 == (6 - 2)) or ((9127 - 5895) <= (3103 - (45 + 327)))) then
				v46 = EpicSettings.Settings['useShiftingPower'];
				v47 = EpicSettings.Settings['useArcaneOrb'];
				v48 = EpicSettings.Settings['useRadiantSpark'];
				v49 = EpicSettings.Settings['useTouchOfTheMagi'];
				v137 = 9 - 4;
			end
			if (((5407 - (444 + 58)) == (2132 + 2773)) and (v137 == (2 + 6))) then
				v62 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v63 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
				v64 = EpicSettings.Settings['greaterInvisibilityHP'] or (1732 - (64 + 1668));
				v65 = EpicSettings.Settings['iceBlockHP'] or (1973 - (1227 + 746));
				v137 = 27 - 18;
			end
			if ((v137 == (12 - 5)) or ((4630 - (415 + 79)) >= (114 + 4297))) then
				v58 = EpicSettings.Settings['useIceBlock'];
				v59 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v61 = EpicSettings.Settings['useMirrorImage'];
				v137 = 499 - (142 + 349);
			end
			if (((3 + 2) == v137) or ((4066 - 1108) == (1997 + 2020))) then
				v50 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v51 = EpicSettings.Settings['shiftingPowerWithCD'];
				v52 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v53 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v137 = 5 + 1;
			end
			if (((3344 - 2116) >= (2677 - (1710 + 154))) and (v137 == (321 - (200 + 118)))) then
				v42 = EpicSettings.Settings['useCounterspell'];
				v43 = EpicSettings.Settings['useBlastWave'];
				v44 = EpicSettings.Settings['useDragonsBreath'];
				v45 = EpicSettings.Settings['useArcaneSurge'];
				v137 = 2 + 2;
			end
		end
	end
	local function v127()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (4 - 1)) or ((3070 + 385) > (4007 + 43))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v83 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v71 = EpicSettings.Settings['handleAfflicted'];
				v138 = 8 - 4;
			end
			if (((1493 - (363 + 887)) == (424 - 181)) and (v138 == (18 - 14))) then
				v72 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v138 == (1 + 1)) or ((633 - 362) > (1075 + 497))) then
				v79 = EpicSettings.Settings['trinketsWithCD'];
				v80 = EpicSettings.Settings['racialsWithCD'];
				v82 = EpicSettings.Settings['useHealthstone'];
				v81 = EpicSettings.Settings['useHealingPotion'];
				v138 = 1667 - (674 + 990);
			end
			if (((786 + 1953) < (1348 + 1945)) and (v138 == (0 - 0))) then
				v76 = EpicSettings.Settings['fightRemainsCheck'] or (1055 - (507 + 548));
				v73 = EpicSettings.Settings['InterruptWithStun'];
				v74 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v75 = EpicSettings.Settings['InterruptThreshold'];
				v138 = 838 - (289 + 548);
			end
			if ((v138 == (1819 - (821 + 997))) or ((4197 - (195 + 60)) < (305 + 829))) then
				v70 = EpicSettings.Settings['DispelDebuffs'];
				v69 = EpicSettings.Settings['DispelBuffs'];
				v78 = EpicSettings.Settings['useTrinkets'];
				v77 = EpicSettings.Settings['useRacials'];
				v138 = 1503 - (251 + 1250);
			end
		end
	end
	local function v128()
		v126();
		v127();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v29 = EpicSettings.Toggles['minicds'];
		v30 = EpicSettings.Toggles['dispel'];
		if (v12:IsDeadOrGhost() or ((7889 - 5196) == (3418 + 1555))) then
			return v25;
		end
		v97 = v13:GetEnemiesInSplashRange(1037 - (809 + 223));
		v100 = v12:GetEnemiesInRange(58 - 18);
		if (((6444 - 4298) == (7095 - 4949)) and v27) then
			local v147 = 0 + 0;
			while true do
				if ((v147 == (0 + 0)) or ((2861 - (14 + 603)) == (3353 - (118 + 11)))) then
					v98 = v24(v13:GetEnemiesInSplashRangeCount(1 + 4), #v100);
					v99 = #v100;
					break;
				end
			end
		else
			v98 = 1 + 0;
			v99 = 2 - 1;
		end
		if (v95.TargetIsValid() or v12:AffectingCombat() or ((5853 - (551 + 398)) <= (1211 + 705))) then
			if (((33 + 57) <= (866 + 199)) and (v12:AffectingCombat() or v70)) then
				local v199 = v70 and v91.RemoveCurse:IsReady() and v30;
				v25 = v95.FocusUnit(v199, v93, 74 - 54, nil, 46 - 26);
				if (((1557 + 3245) == (19063 - 14261)) and v25) then
					return v25;
				end
			end
			v110 = v9.BossFightRemains(nil, true);
			v111 = v110;
			if ((v111 == (3068 + 8043)) or ((2369 - (40 + 49)) <= (1945 - 1434))) then
				v111 = v9.FightRemains(v100, false);
			end
		end
		v112 = v12:GCD();
		if (v71 or ((2166 - (99 + 391)) <= (383 + 80))) then
			if (((17007 - 13138) == (9580 - 5711)) and v90) then
				v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 30 + 0);
				if (((3046 - 1888) <= (4217 - (1032 + 572))) and v25) then
					return v25;
				end
			end
		end
		if (not v12:AffectingCombat() or ((2781 - (203 + 214)) <= (3816 - (568 + 1249)))) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (2 - 1)) or ((19011 - 14089) < (1500 - (913 + 393)))) then
					if ((v91.ConjureManaGem:IsCastable() and v37) or ((5904 - 3813) < (43 - 12))) then
						if (v19(v91.ConjureManaGem) or ((2840 - (269 + 141)) >= (10835 - 5963))) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
				if ((v148 == (1981 - (362 + 1619))) or ((6395 - (950 + 675)) < (669 + 1066))) then
					if ((v91.ArcaneIntellect:IsCastable() and v35 and (v12:BuffDown(v91.ArcaneIntellect, true) or v95.GroupBuffMissing(v91.ArcaneIntellect))) or ((5618 - (216 + 963)) <= (3637 - (485 + 802)))) then
						if (v19(v91.ArcaneIntellect) or ((5038 - (432 + 127)) < (5539 - (1065 + 8)))) then
							return "arcane_intellect group_buff";
						end
					end
					if (((1415 + 1132) > (2826 - (635 + 966))) and v91.ArcaneFamiliar:IsReady() and v34 and v12:BuffDown(v91.ArcaneFamiliarBuff)) then
						if (((3359 + 1312) > (2716 - (5 + 37))) and v19(v91.ArcaneFamiliar)) then
							return "arcane_familiar precombat 2";
						end
					end
					v148 = 2 - 1;
				end
			end
		end
		if (v95.TargetIsValid() or ((1538 + 2158) < (5265 - 1938))) then
			local v149 = 0 + 0;
			while true do
				if ((v149 == (1 - 0)) or ((17219 - 12677) == (5601 - 2631))) then
					v25 = v113();
					if (((602 - 350) <= (1422 + 555)) and v25) then
						return v25;
					end
					v149 = 531 - (318 + 211);
				end
				if ((v149 == (9 - 7)) or ((3023 - (963 + 624)) == (1614 + 2161))) then
					if (v71 or ((2464 - (518 + 328)) < (2168 - 1238))) then
						if (((7548 - 2825) > (4470 - (301 + 16))) and v90) then
							local v207 = 0 - 0;
							while true do
								if ((v207 == (0 - 0)) or ((9534 - 5880) >= (4216 + 438))) then
									v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 18 + 12);
									if (((2030 - 1079) <= (901 + 595)) and v25) then
										return v25;
									end
									break;
								end
							end
						end
					end
					if (v72 or ((166 + 1570) == (1815 - 1244))) then
						local v203 = 0 + 0;
						while true do
							if ((v203 == (1019 - (829 + 190))) or ((3196 - 2300) > (6033 - 1264))) then
								v25 = v95.HandleIncorporeal(v91.Polymorph, v93.PolymorphMouseOver, 41 - 11, true);
								if (v25 or ((2595 - 1550) <= (242 + 778))) then
									return v25;
								end
								break;
							end
						end
					end
					v149 = 1 + 2;
				end
				if ((v149 == (8 - 5)) or ((1095 + 65) <= (941 - (520 + 93)))) then
					if (((4084 - (259 + 17)) > (169 + 2755)) and v91.Spellsteal:IsAvailable() and v86 and v91.Spellsteal:IsReady() and v30 and v69 and not v12:IsCasting() and not v12:IsChanneling() and v95.UnitHasMagicBuff(v13)) then
						if (((1401 + 2490) < (16653 - 11734)) and v19(v91.Spellsteal, not v13:IsSpellInRange(v91.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v95.TargetIsValid()) or ((2825 - (396 + 195)) <= (4357 - 2855))) then
						local v204 = 1761 - (440 + 1321);
						local v205;
						while true do
							if ((v204 == (1829 - (1059 + 770))) or ((11615 - 9103) < (977 - (424 + 121)))) then
								v205 = v95.HandleDPSPotion(not v91.ArcaneSurge:IsReady());
								if (v205 or ((337 + 1511) == (2212 - (641 + 706)))) then
									return v205;
								end
								v204 = 1 + 0;
							end
							if ((v204 == (444 - (249 + 191))) or ((20396 - 15714) <= (2029 + 2512))) then
								if (v25 or ((11662 - 8636) >= (4473 - (183 + 244)))) then
									return v25;
								end
								break;
							end
							if (((99 + 1909) > (1368 - (434 + 296))) and (v204 == (5 - 3))) then
								if (((2287 - (169 + 343)) <= (2835 + 398)) and (v76 < v111)) then
									if ((v78 and ((v28 and v79) or not v79)) or ((7993 - 3450) == (5861 - 3864))) then
										v25 = v115();
										if (v25 or ((2542 + 560) < (2064 - 1336))) then
											return v25;
										end
									end
								end
								v25 = v117();
								v204 = 1126 - (651 + 472);
							end
							if (((261 + 84) == (149 + 196)) and ((1 - 0) == v204)) then
								if ((v87 and v91.TimeWarp:IsReady() and v91.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v91.ArcaneSurge:CooldownUp() or (v111 <= (523 - (397 + 86))) or (v12:BuffUp(v91.ArcaneSurgeBuff) and (v111 <= (v91.ArcaneSurge:CooldownRemains() + (890 - (423 + 453))))))) or ((288 + 2539) < (50 + 328))) then
									if (v19(v91.TimeWarp, not v13:IsInRange(35 + 5)) or ((2775 + 701) < (2320 + 277))) then
										return "time_warp main 4";
									end
								end
								if (((4269 - (50 + 1140)) < (4144 + 650)) and v77 and ((v80 and v28) or not v80) and (v76 < v111)) then
									if (((2866 + 1988) > (278 + 4186)) and v91.LightsJudgment:IsCastable() and v12:BuffDown(v91.ArcaneSurgeBuff) and v13:DebuffDown(v91.TouchoftheMagiDebuff) and ((v98 >= (2 - 0)) or (v99 >= (2 + 0)))) then
										if (v19(v91.LightsJudgment, not v13:IsSpellInRange(v91.LightsJudgment)) or ((5508 - (157 + 439)) == (6534 - 2776))) then
											return "lights_judgment main 6";
										end
									end
									if (((418 - 292) <= (10299 - 6817)) and v91.Berserking:IsCastable() and ((v12:PrevGCDP(919 - (782 + 136), v91.ArcaneSurge) and not (v12:BuffUp(v91.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v91.ArcaneSurgeBuff) and v13:DebuffUp(v91.TouchoftheMagiDebuff)))) then
										if (v19(v91.Berserking) or ((3229 - (112 + 743)) == (5545 - (1026 + 145)))) then
											return "berserking main 8";
										end
									end
									if (((271 + 1304) == (2293 - (493 + 225))) and v12:PrevGCDP(3 - 2, v91.ArcaneSurge)) then
										if (v91.BloodFury:IsCastable() or ((1359 + 875) == (3900 - 2445))) then
											if (v19(v91.BloodFury) or ((21 + 1046) > (5083 - 3304))) then
												return "blood_fury main 10";
											end
										end
										if (((630 + 1531) >= (1560 - 626)) and v91.Fireblood:IsCastable()) then
											if (((3207 - (210 + 1385)) == (3301 - (1201 + 488))) and v19(v91.Fireblood)) then
												return "fireblood main 12";
											end
										end
										if (((2698 + 1654) >= (5038 - 2205)) and v91.AncestralCall:IsCastable()) then
											if (v19(v91.AncestralCall) or ((5777 - 2555) < (3658 - (352 + 233)))) then
												return "ancestral_call main 14";
											end
										end
									end
								end
								v204 = 4 - 2;
							end
							if (((405 + 339) <= (8364 - 5422)) and (v204 == (577 - (489 + 85)))) then
								if (v25 or ((3334 - (277 + 1224)) <= (2815 - (663 + 830)))) then
									return v25;
								end
								v25 = v125();
								v204 = 4 + 0;
							end
						end
					end
					break;
				end
				if ((v149 == (0 - 0)) or ((4342 - (461 + 414)) <= (177 + 878))) then
					if (((1417 + 2124) == (338 + 3203)) and v14) then
						if (v70 or ((3507 + 50) >= (4253 - (172 + 78)))) then
							v25 = v114();
							if (v25 or ((1059 - 402) >= (614 + 1054))) then
								return v25;
							end
						end
					end
					if ((not v12:AffectingCombat() and v26) or ((1481 - 454) > (1053 + 2805))) then
						local v206 = 0 + 0;
						while true do
							if ((v206 == (0 - 0)) or ((4598 - 944) < (114 + 336))) then
								v25 = v116();
								if (((1046 + 845) < (1585 + 2868)) and v25) then
									return v25;
								end
								break;
							end
						end
					end
					v149 = 3 - 2;
				end
			end
		end
	end
	local function v129()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (0 + 0)) or ((1793 + 1347) < (2576 - (133 + 314)))) then
				v96();
				v17.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v17.SetAPL(11 + 51, v128, v129);
end;
return v0["Epix_Mage_Arcane.lua"]();

