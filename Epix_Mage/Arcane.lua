local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1200 - (700 + 168)) == (467 + 4174))) then
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
	local v15 = v10.Mouseover;
	local v16 = v9.Spell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Cast;
	local v20 = v18.Press;
	local v21 = v18.Macro;
	local v22 = v18.Bind;
	local v23 = v18.Commons.Everyone.num;
	local v24 = v18.Commons.Everyone.bool;
	local v25 = math.max;
	local v26;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v91;
	local v92 = v16.Mage.Arcane;
	local v93 = v17.Mage.Arcane;
	local v94 = v21.Mage.Arcane;
	local v95 = {};
	local v96 = v18.Commons.Everyone;
	local function v97()
		if (v92.RemoveCurse:IsAvailable() or ((6366 - 4699) >= (3588 - (36 + 261)))) then
			v96.DispellableDebuffs = v96.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v97();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v92.ArcaneBlast:RegisterInFlight();
	v92.ArcaneBarrage:RegisterInFlight();
	local v98, v99;
	local v100, v101;
	local v102 = 4 - 1;
	local v103 = false;
	local v104 = false;
	local v105 = false;
	local v106 = true;
	local v107 = false;
	local v108 = v12:HasTier(1397 - (34 + 1334), 2 + 2);
	local v109 = (174822 + 50178) - (((26283 - (1035 + 248)) * v23(not v92.ArcaneHarmony:IsAvailable())) + ((200021 - (20 + 1)) * v23(not v108)));
	local v110 = 2 + 1;
	local v111 = 11430 - (134 + 185);
	local v112 = 12244 - (549 + 584);
	local v113;
	v9:RegisterForEvent(function()
		local v131 = 685 - (314 + 371);
		while true do
			if ((v131 == (0 - 0)) or ((1841 - (478 + 490)) == (1078 + 956))) then
				v103 = false;
				v106 = true;
				v131 = 1173 - (786 + 386);
			end
			if ((v131 == (3 - 2)) or ((4195 - (1055 + 324)) < (1351 - (1093 + 247)))) then
				v109 = (199943 + 25057) - (((2630 + 22370) * v23(not v92.ArcaneHarmony:IsAvailable())) + ((794035 - 594035) * v23(not v108)));
				v111 = 37708 - 26597;
				v131 = 5 - 3;
			end
			if (((9295 - 5596) < (1675 + 3031)) and (v131 == (7 - 5))) then
				v112 = 38297 - 27186;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v108 = not v12:HasTier(22 + 7, 9 - 5);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v114()
		local v132 = 688 - (364 + 324);
		while true do
			if (((7253 - 4607) >= (2101 - 1225)) and (v132 == (0 + 0))) then
				if (((2569 - 1955) <= (5098 - 1914)) and v92.PrismaticBarrier:IsCastable() and v57 and v12:BuffDown(v92.PrismaticBarrier) and (v12:HealthPercentage() <= v64)) then
					if (((9493 - 6367) == (4394 - (1249 + 19))) and v20(v92.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v92.MassBarrier:IsCastable() and v61 and v12:BuffDown(v92.PrismaticBarrier) and v96.AreUnitsBelowHealthPercentage(v69, 2 + 0)) or ((8512 - 6325) >= (6040 - (686 + 400)))) then
					if (v20(v92.MassBarrier) or ((3042 + 835) == (3804 - (73 + 156)))) then
						return "mass_barrier defensive 2";
					end
				end
				v132 = 1 + 0;
			end
			if (((1518 - (721 + 90)) > (8 + 624)) and (v132 == (9 - 6))) then
				if ((v92.AlterTime:IsReady() and v56 and (v12:HealthPercentage() <= v63)) or ((1016 - (224 + 246)) >= (4347 - 1663))) then
					if (((2697 - 1232) <= (781 + 3520)) and v20(v92.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if (((41 + 1663) > (1047 + 378)) and v93.Healthstone:IsReady() and v83 and (v12:HealthPercentage() <= v85)) then
					if (v20(v94.Healthstone) or ((1365 - 678) == (14089 - 9855))) then
						return "healthstone defensive";
					end
				end
				v132 = 517 - (203 + 310);
			end
			if ((v132 == (1994 - (1238 + 755))) or ((233 + 3097) < (2963 - (709 + 825)))) then
				if (((2113 - 966) >= (487 - 152)) and v92.IceBlock:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) then
					if (((4299 - (196 + 668)) > (8279 - 6182)) and v20(v92.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v92.IceColdTalent:IsAvailable() and v92.IceColdAbility:IsCastable() and v60 and (v12:HealthPercentage() <= v67)) or ((7809 - 4039) >= (4874 - (171 + 662)))) then
					if (v20(v92.IceColdAbility) or ((3884 - (4 + 89)) <= (5646 - 4035))) then
						return "ice_cold defensive 3";
					end
				end
				v132 = 1 + 1;
			end
			if ((v132 == (17 - 13)) or ((1796 + 2782) <= (3494 - (35 + 1451)))) then
				if (((2578 - (28 + 1425)) <= (4069 - (941 + 1052))) and v82 and (v12:HealthPercentage() <= v84)) then
					local v204 = 0 + 0;
					while true do
						if (((1514 - (822 + 692)) == v204) or ((1059 - 316) >= (2073 + 2326))) then
							if (((1452 - (45 + 252)) < (1656 + 17)) and (v86 == "Refreshing Healing Potion")) then
								if (v93.RefreshingHealingPotion:IsReady() or ((800 + 1524) <= (1406 - 828))) then
									if (((4200 - (114 + 319)) == (5408 - 1641)) and v20(v94.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((5238 - 1149) == (2607 + 1482)) and (v86 == "Dreamwalker's Healing Potion")) then
								if (((6641 - 2183) >= (3507 - 1833)) and v93.DreamwalkersHealingPotion:IsReady()) then
									if (((2935 - (556 + 1407)) <= (2624 - (741 + 465))) and v20(v94.RefreshingHealingPotion)) then
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
			if ((v132 == (467 - (170 + 295))) or ((2602 + 2336) < (4375 + 387))) then
				if ((v92.MirrorImage:IsCastable() and v62 and (v12:HealthPercentage() <= v68)) or ((6164 - 3660) > (3535 + 729))) then
					if (((1381 + 772) == (1220 + 933)) and v20(v92.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v92.GreaterInvisibility:IsReady() and v58 and (v12:HealthPercentage() <= v65)) or ((1737 - (957 + 273)) >= (693 + 1898))) then
					if (((1794 + 2687) == (17074 - 12593)) and v20(v92.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v132 = 7 - 4;
			end
		end
	end
	local function v115()
		if ((v92.RemoveCurse:IsReady() and v96.DispellableFriendlyUnit(61 - 41)) or ((11527 - 9199) < (2473 - (389 + 1391)))) then
			if (((2716 + 1612) == (451 + 3877)) and v20(v94.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v116()
		local v133 = 0 - 0;
		while true do
			if (((2539 - (783 + 168)) >= (4470 - 3138)) and (v133 == (0 + 0))) then
				v26 = v96.HandleTopTrinket(v95, v29, 351 - (309 + 2), nil);
				if (v26 or ((12817 - 8643) > (5460 - (1090 + 122)))) then
					return v26;
				end
				v133 = 1 + 0;
			end
			if ((v133 == (3 - 2)) or ((3139 + 1447) <= (1200 - (628 + 490)))) then
				v26 = v96.HandleBottomTrinket(v95, v29, 8 + 32, nil);
				if (((9564 - 5701) == (17653 - 13790)) and v26) then
					return v26;
				end
				break;
			end
		end
	end
	local function v117()
		local v134 = 774 - (431 + 343);
		while true do
			if ((v134 == (1 - 0)) or ((815 - 533) <= (34 + 8))) then
				if (((590 + 4019) >= (2461 - (556 + 1139))) and v92.Evocation:IsReady() and v39 and (v92.SiphonStorm:IsAvailable())) then
					if (v20(v92.Evocation) or ((1167 - (6 + 9)) == (456 + 2032))) then
						return "evocation precombat 6";
					end
				end
				if (((1754 + 1668) > (3519 - (28 + 141))) and v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53)) then
					if (((340 + 537) > (463 - 87)) and v20(v92.ArcaneOrb, not v13:IsInRange(29 + 11))) then
						return "arcane_orb precombat 8";
					end
				end
				v134 = 1319 - (486 + 831);
			end
			if (((0 - 0) == v134) or ((10977 - 7859) <= (350 + 1501))) then
				if ((v92.MirrorImage:IsCastable() and v89 and v62) or ((521 - 356) >= (4755 - (668 + 595)))) then
					if (((3554 + 395) < (980 + 3876)) and v20(v92.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32 and not v92.SiphonStorm:IsAvailable()) or ((11661 - 7385) < (3306 - (23 + 267)))) then
					if (((6634 - (1129 + 815)) > (4512 - (371 + 16))) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
						return "arcane_blast precombat 4";
					end
				end
				v134 = 1751 - (1326 + 424);
			end
			if ((v134 == (3 - 1)) or ((182 - 132) >= (1014 - (88 + 30)))) then
				if ((v92.ArcaneBlast:IsReady() and v32) or ((2485 - (720 + 51)) >= (6579 - 3621))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((3267 - (421 + 1355)) < (1061 - 417))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v118()
		if (((346 + 358) < (2070 - (286 + 797))) and ((v99 >= v102) or (v100 >= v102)) and ((v92.ArcaneOrb:Charges() > (0 - 0)) or (v12:ArcaneCharges() >= (4 - 1))) and v92.RadiantSpark:CooldownUp() and (v92.TouchoftheMagi:CooldownRemains() <= (v113 * (441 - (397 + 42))))) then
			v104 = true;
		elseif (((1162 + 2556) > (2706 - (24 + 776))) and v104 and v13:DebuffDown(v92.RadiantSparkVulnerability) and (v13:DebuffRemains(v92.RadiantSparkDebuff) < (10 - 3)) and v92.RadiantSpark:CooldownDown()) then
			v104 = false;
		end
		if (((v12:ArcaneCharges() > (788 - (222 + 563))) and ((v99 < v102) or (v100 < v102)) and v92.RadiantSpark:CooldownUp() and (v92.TouchoftheMagi:CooldownRemains() <= (v113 * (14 - 7))) and ((v92.ArcaneSurge:CooldownRemains() <= (v113 * (4 + 1))) or (v92.ArcaneSurge:CooldownRemains() > (230 - (23 + 167))))) or ((2756 - (690 + 1108)) > (1312 + 2323))) then
			v105 = true;
		elseif (((2888 + 613) <= (5340 - (40 + 808))) and v105 and v13:DebuffDown(v92.RadiantSparkVulnerability) and (v13:DebuffRemains(v92.RadiantSparkDebuff) < (2 + 5)) and v92.RadiantSpark:CooldownDown()) then
			v105 = false;
		end
		if ((v13:DebuffUp(v92.TouchoftheMagiDebuff) and v106) or ((13162 - 9720) < (2436 + 112))) then
			v106 = false;
		end
		v107 = v92.ArcaneBlast:CastTime() < v113;
	end
	local function v119()
		if (((1521 + 1354) >= (803 + 661)) and v92.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v112) and (v12:PrevGCDP(572 - (47 + 524), v92.ArcaneBarrage))) then
			if (v20(v92.TouchoftheMagi, not v13:IsSpellInRange(v92.TouchoftheMagi)) or ((3114 + 1683) >= (13375 - 8482))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (v92.RadiantSpark:CooldownUp() or ((823 - 272) > (4716 - 2648))) then
			v103 = v92.ArcaneSurge:CooldownRemains() < (1736 - (1165 + 561));
		end
		if (((63 + 2051) > (2923 - 1979)) and v92.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v112) and v12:BuffDown(v92.ArcaneSurgeBuff) and not v92.RadiantSpark:IsAvailable()) then
			if (v20(v92.ShiftingPower, not v13:IsInRange(16 + 24), true) or ((2741 - (341 + 138)) >= (836 + 2260))) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if ((v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v112) and v92.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) or ((4653 - 2398) >= (3863 - (89 + 237)))) then
			if (v20(v92.ArcaneOrb, not v13:IsInRange(128 - 88)) or ((8077 - 4240) < (2187 - (581 + 300)))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if (((4170 - (855 + 365)) == (7006 - 4056)) and v92.ArcaneBlast:IsReady() and v32 and v92.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (1 + 1)) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v92.ArcaneOrb:CooldownRemains() >= v113)))) then
			if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((5958 - (1030 + 205)) < (3097 + 201))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if (((1057 + 79) >= (440 - (156 + 130))) and v12:IsChanneling(v92.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and (v12:ManaPercentage() > (50 - 20)) and v12:BuffUp(v92.NetherPrecisionBuff) and v12:BuffDown(v92.ArcaneArtilleryBuff)) then
			if (v20(v94.StopCasting, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((554 - 283) > (1252 + 3496))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if (((2765 + 1975) >= (3221 - (10 + 59))) and v92.ArcaneMissiles:IsReady() and v37 and v106 and v12:BloodlustUp() and v12:BuffUp(v92.ClearcastingBuff) and (v92.RadiantSpark:CooldownRemains() < (2 + 3)) and v12:BuffDown(v92.NetherPrecisionBuff) and (v12:BuffDown(v92.ArcaneArtilleryBuff) or (v12:BuffRemains(v92.ArcaneArtilleryBuff) <= (v113 * (29 - 23)))) and v12:HasTier(1194 - (671 + 492), 4 + 0)) then
			if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((3793 - (369 + 846)) >= (898 + 2492))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if (((35 + 6) <= (3606 - (1036 + 909))) and v92.ArcaneBlast:IsReady() and v32 and v106 and v92.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v109) and (v12:BuffRemains(v92.SiphonStormBuff) > (14 + 3)) and not v12:HasTier(50 - 20, 207 - (11 + 192))) then
			if (((304 + 297) < (3735 - (135 + 40))) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if (((569 - 334) < (415 + 272)) and v92.ArcaneMissiles:IsReady() and v37 and v106 and v12:BloodlustUp() and v12:BuffUp(v92.ClearcastingBuff) and (v12:BuffStack(v92.ClearcastingBuff) >= (4 - 2)) and (v92.RadiantSpark:CooldownRemains() < (7 - 2)) and v12:BuffDown(v92.NetherPrecisionBuff) and (v12:BuffDown(v92.ArcaneArtilleryBuff) or (v12:BuffRemains(v92.ArcaneArtilleryBuff) <= (v113 * (182 - (50 + 126))))) and not v12:HasTier(83 - 53, 1 + 3)) then
			if (((5962 - (1233 + 180)) > (2122 - (522 + 447))) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if ((v92.ArcaneMissiles:IsReady() and v37 and v92.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v92.ArcaneHarmonyBuff) < (1436 - (107 + 1314))) and ((v106 and v12:BloodlustUp()) or (v12:BuffUp(v92.ClearcastingBuff) and (v92.RadiantSpark:CooldownRemains() < (3 + 2)))) and (v92.ArcaneSurge:CooldownRemains() < (91 - 61))) or ((1986 + 2688) < (9277 - 4605))) then
			if (((14512 - 10844) < (6471 - (716 + 1194))) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if ((v92.ArcaneMissiles:IsReady() and v37 and v92.RadiantSpark:CooldownUp() and v12:BuffUp(v92.ClearcastingBuff) and v92.NetherPrecision:IsAvailable() and (v12:BuffDown(v92.NetherPrecisionBuff) or (v12:BuffRemains(v92.NetherPrecisionBuff) < v113)) and v12:HasTier(1 + 29, 1 + 3)) or ((958 - (74 + 429)) == (6954 - 3349))) then
			if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((1320 + 1343) == (7580 - 4268))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if (((3026 + 1251) <= (13795 - 9320)) and v92.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v112)) then
			if (v20(v92.RadiantSpark, not v13:IsSpellInRange(v92.RadiantSpark), true) or ((2151 - 1281) == (1622 - (279 + 154)))) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if (((2331 - (454 + 324)) <= (2465 + 668)) and v92.NetherTempest:IsReady() and v41 and (v92.NetherTempest:TimeSinceLastCast() >= (47 - (12 + 5))) and (v92.ArcaneEcho:IsAvailable())) then
			if (v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest)) or ((1207 + 1030) >= (8946 - 5435))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if ((v92.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v112)) or ((490 + 834) > (4113 - (277 + 816)))) then
			if (v20(v92.ArcaneSurge, not v13:IsSpellInRange(v92.ArcaneSurge)) or ((12784 - 9792) == (3064 - (1058 + 125)))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if (((583 + 2523) > (2501 - (815 + 160))) and v92.ArcaneBarrage:IsReady() and v33 and (v12:PrevGCDP(4 - 3, v92.ArcaneSurge) or v12:PrevGCDP(2 - 1, v92.NetherTempest) or v12:PrevGCDP(1 + 0, v92.RadiantSpark))) then
			if (((8836 - 5813) < (5768 - (41 + 1857))) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if (((2036 - (1222 + 671)) > (191 - 117)) and v92.ArcaneBlast:IsReady() and v32 and v13:DebuffUp(v92.RadiantSparkVulnerability) and (v13:DebuffStack(v92.RadiantSparkVulnerability) < (5 - 1))) then
			if (((1200 - (229 + 953)) < (3886 - (1111 + 663))) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if (((2676 - (874 + 705)) <= (228 + 1400)) and v92.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v92.TouchoftheMagiDebuff) <= v113)) then
			if (((3159 + 1471) == (9624 - 4994)) and v20(v92.PresenceofMind)) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if (((100 + 3440) > (3362 - (642 + 37))) and v92.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v92.PresenceofMindBuff))) then
			if (((1094 + 3700) >= (524 + 2751)) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if (((3725 - 2241) == (1938 - (233 + 221))) and v92.ArcaneMissiles:IsReady() and v37 and v12:BuffDown(v92.NetherPrecisionBuff) and v12:BuffUp(v92.ClearcastingBuff) and (v13:DebuffDown(v92.RadiantSparkVulnerability) or ((v13:DebuffStack(v92.RadiantSparkVulnerability) == (8 - 4)) and v12:PrevGCDP(1 + 0, v92.ArcaneBlast)))) then
			if (((2973 - (718 + 823)) < (2238 + 1317)) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if ((v92.ArcaneBlast:IsReady() and v32) or ((1870 - (266 + 539)) > (10129 - 6551))) then
			if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((6020 - (636 + 589)) < (3339 - 1932))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v120()
		local v135 = 0 - 0;
		while true do
			if (((1469 + 384) < (1749 + 3064)) and (v135 == (1015 - (657 + 358)))) then
				if ((v92.NetherTempest:IsReady() and v41 and (v92.NetherTempest:TimeSinceLastCast() >= (119 - 74)) and v13:DebuffDown(v92.NetherTempestDebuff) and v106 and v12:BloodlustUp()) or ((6426 - 3605) < (3618 - (1151 + 36)))) then
					if (v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest)) or ((2776 + 98) < (574 + 1607))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((v106 and v12:IsChanneling(v92.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v92.NetherPrecisionBuff) and v12:BuffDown(v92.ArcaneArtilleryBuff)) or ((4521 - (1552 + 280)) <= (1177 - (64 + 770)))) then
					if (v20(v94.StopCasting, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((1269 + 600) == (4560 - 2551))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((v92.ArcaneMissiles:IsCastable() and v37 and v106 and v12:BloodlustUp() and v12:BuffUp(v92.ClearcastingBuff) and (v92.RadiantSpark:CooldownRemains() < (1 + 4)) and v12:BuffDown(v92.NetherPrecisionBuff) and (v12:BuffDown(v92.ArcaneArtilleryBuff) or (v12:BuffRemains(v92.ArcaneArtilleryBuff) <= (v113 * (1249 - (157 + 1086))))) and v12:HasTier(61 - 30, 17 - 13)) or ((5438 - 1892) < (3168 - 846))) then
					if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((2901 - (599 + 220)) == (9504 - 4731))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				v135 = 1932 - (1813 + 118);
			end
			if (((2372 + 872) > (2272 - (841 + 376))) and (v135 == (3 - 0))) then
				if ((v92.ArcaneBlast:IsReady() and v32 and (v92.ArcaneBlast:CastTime() >= v12:GCD()) and (v92.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v92.RadiantSparkVulnerability)) and (not v92.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (9 + 26))) and ((v92.NetherTempest:IsAvailable() and v12:PrevGCDP(16 - 10, v92.RadiantSpark)) or (not v92.NetherTempest:IsAvailable() and v12:PrevGCDP(864 - (464 + 395), v92.RadiantSpark))) and not (v12:IsCasting(v92.ArcaneSurge) and (v12:CastRemains() < (0.5 - 0)) and not v107)) or ((1592 + 1721) <= (2615 - (467 + 370)))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((2936 - 1515) >= (1545 + 559))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((6211 - 4399) <= (507 + 2742)) and v92.ArcaneBarrage:IsReady() and v33 and (v13:DebuffStack(v92.RadiantSparkVulnerability) == (8 - 4))) then
					if (((2143 - (150 + 370)) <= (3239 - (74 + 1208))) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((10851 - 6439) == (20924 - 16512)) and v92.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v112) and v12:PrevGCDP(1 + 0, v92.ArcaneBarrage) and ((v92.ArcaneBarrage:InFlight() and ((v92.ArcaneBarrage:TravelTime() - v92.ArcaneBarrage:TimeSinceLastCast()) <= (390.2 - (14 + 376)))) or (v12:GCDRemains() <= (0.2 - 0)))) then
					if (((1133 + 617) >= (740 + 102)) and v20(v92.TouchoftheMagi, not v13:IsSpellInRange(v92.TouchoftheMagi))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v135 = 4 + 0;
			end
			if (((12810 - 8438) > (1392 + 458)) and (v135 == (80 - (23 + 55)))) then
				if (((549 - 317) < (548 + 273)) and v92.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v112)) then
					if (((466 + 52) < (1398 - 496)) and v20(v92.RadiantSpark, not v13:IsSpellInRange(v92.RadiantSpark))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((942 + 2052) > (1759 - (652 + 249))) and v92.NetherTempest:IsReady() and v41 and not v107 and (v92.NetherTempest:TimeSinceLastCast() >= (40 - 25)) and ((not v107 and v12:PrevGCDP(1872 - (708 + 1160), v92.RadiantSpark) and (v92.ArcaneSurge:CooldownRemains() <= v92.NetherTempest:ExecuteTime())) or v12:PrevGCDP(13 - 8, v92.RadiantSpark))) then
					if (v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest)) or ((6846 - 3091) <= (942 - (10 + 17)))) then
						return "nether_tempest spark_phase 16";
					end
				end
				if (((887 + 3059) > (5475 - (1400 + 332))) and v92.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v112) and ((not v92.NetherTempest:IsAvailable() and ((v12:PrevGCDP(7 - 3, v92.RadiantSpark) and not v107) or v12:PrevGCDP(1913 - (242 + 1666), v92.RadiantSpark))) or v12:PrevGCDP(1 + 0, v92.NetherTempest))) then
					if (v20(v92.ArcaneSurge, not v13:IsSpellInRange(v92.ArcaneSurge)) or ((490 + 845) >= (2818 + 488))) then
						return "arcane_surge spark_phase 18";
					end
				end
				v135 = 943 - (850 + 90);
			end
			if (((8483 - 3639) > (3643 - (360 + 1030))) and (v135 == (1 + 0))) then
				if (((1275 - 823) == (621 - 169)) and v92.ArcaneBlast:IsReady() and v32 and v106 and v92.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v109) and (v12:BuffRemains(v92.SiphonStormBuff) > (1676 - (909 + 752)))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((5780 - (109 + 1114)) < (3820 - 1733))) then
						return "arcane_blast spark_phase 6";
					end
				end
				if (((1509 + 2365) == (4116 - (6 + 236))) and v92.ArcaneMissiles:IsCastable() and v37 and v106 and v12:BloodlustUp() and v12:BuffUp(v92.ClearcastingBuff) and (v12:BuffStack(v92.ClearcastingBuff) >= (2 + 0)) and (v92.RadiantSpark:CooldownRemains() < (5 + 0)) and v12:BuffDown(v92.NetherPrecisionBuff) and (v12:BuffRemains(v92.ArcaneArtilleryBuff) <= (v113 * (13 - 7)))) then
					if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((3384 - 1446) > (6068 - (1076 + 57)))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v92.ArcaneMissiles:IsReady() and v37 and v92.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v92.ArcaneHarmonyBuff) < (3 + 12)) and ((v106 and v12:BloodlustUp()) or (v12:BuffUp(v92.ClearcastingBuff) and (v92.RadiantSpark:CooldownRemains() < (694 - (579 + 110))))) and (v92.ArcaneSurge:CooldownRemains() < (3 + 27))) or ((3762 + 493) < (1817 + 1606))) then
					if (((1861 - (174 + 233)) <= (6958 - 4467)) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				v135 = 3 - 1;
			end
			if ((v135 == (2 + 2)) or ((5331 - (663 + 511)) <= (2501 + 302))) then
				if (((1054 + 3799) >= (9193 - 6211)) and v92.ArcaneBlast:IsReady() and v32) then
					if (((2504 + 1630) > (7903 - 4546)) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33) or ((8271 - 4854) < (1210 + 1324))) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((5297 - 2575) <= (117 + 47))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (723 - (478 + 244))) or ((2925 - (440 + 77)) < (959 + 1150))) then
				if ((v92.NetherTempest:IsReady() and v41 and (v92.NetherTempest:TimeSinceLastCast() >= (54 - 39)) and (v92.ArcaneEcho:IsAvailable())) or ((1589 - (655 + 901)) == (270 + 1185))) then
					if (v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest)) or ((340 + 103) >= (2712 + 1303))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if (((13624 - 10242) > (1611 - (695 + 750))) and v92.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v112)) then
					if (v20(v92.ArcaneSurge, not v13:IsSpellInRange(v92.ArcaneSurge)) or ((956 - 676) == (4720 - 1661))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				if (((7564 - 5683) > (1644 - (285 + 66))) and v92.ArcaneBarrage:IsReady() and v33 and (v92.ArcaneSurge:CooldownRemains() < (174 - 99)) and (v13:DebuffStack(v92.RadiantSparkVulnerability) == (1314 - (682 + 628))) and not v92.OrbBarrage:IsAvailable()) then
					if (((380 + 1977) == (2656 - (176 + 123))) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if (((52 + 71) == (90 + 33)) and v92.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v92.RadiantSparkVulnerability) == (271 - (239 + 30))) and (v92.ArcaneSurge:CooldownRemains() > (21 + 54))) or ((v13:DebuffStack(v92.RadiantSparkVulnerability) == (1 + 0)) and (v92.ArcaneSurge:CooldownRemains() < (132 - 57)) and not v92.OrbBarrage:IsAvailable()))) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((3294 - 2238) >= (3707 - (306 + 9)))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				v136 = 6 - 4;
			end
			if ((v136 == (1 + 1)) or ((664 + 417) < (518 + 557))) then
				if ((v92.ArcaneBarrage:IsReady() and v33 and ((v13:DebuffStack(v92.RadiantSparkVulnerability) == (2 - 1)) or (v13:DebuffStack(v92.RadiantSparkVulnerability) == (1377 - (1140 + 235))) or ((v13:DebuffStack(v92.RadiantSparkVulnerability) == (2 + 1)) and ((v99 > (5 + 0)) or (v100 > (2 + 3)))) or (v13:DebuffStack(v92.RadiantSparkVulnerability) == (56 - (33 + 19)))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v92.OrbBarrage:IsAvailable()) or ((379 + 670) >= (13283 - 8851))) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((2101 + 2667) <= (1658 - 812))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				if ((v92.PresenceofMind:IsCastable() and v42) or ((3149 + 209) <= (2109 - (586 + 103)))) then
					if (v20(v92.PresenceofMind) or ((341 + 3398) <= (9251 - 6246))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32 and ((((v13:DebuffStack(v92.RadiantSparkVulnerability) == (1490 - (1309 + 179))) or (v13:DebuffStack(v92.RadiantSparkVulnerability) == (5 - 2))) and not v92.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v92.RadiantSparkVulnerability) and v92.OrbBarrage:IsAvailable()))) or ((723 + 936) >= (5730 - 3596))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((2463 + 797) < (5003 - 2648))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v92.RadiantSparkVulnerability) == (7 - 3)) and v12:BuffUp(v92.ArcaneSurgeBuff)) or ((v13:DebuffStack(v92.RadiantSparkVulnerability) == (612 - (295 + 314))) and v12:BuffDown(v92.ArcaneSurgeBuff) and not v92.OrbBarrage:IsAvailable()))) or ((1642 - 973) == (6185 - (1300 + 662)))) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((5312 - 3620) < (2343 - (1178 + 577)))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v136 == (0 + 0)) or ((14181 - 9384) < (5056 - (851 + 554)))) then
				if ((v12:BuffUp(v92.PresenceofMindBuff) and v90 and (v12:PrevGCDP(1 + 0, v92.ArcaneBlast)) and (v92.ArcaneSurge:CooldownRemains() > (208 - 133))) or ((9071 - 4894) > (5152 - (115 + 187)))) then
					if (v20(v94.CancelPOM) or ((307 + 93) > (1052 + 59))) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if (((12023 - 8972) > (2166 - (160 + 1001))) and v92.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v112) and (v12:PrevGCDP(1 + 0, v92.ArcaneBarrage))) then
					if (((2549 + 1144) <= (8969 - 4587)) and v20(v92.TouchoftheMagi, not v13:IsSpellInRange(v92.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v92.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v112)) or ((3640 - (237 + 121)) > (4997 - (525 + 372)))) then
					if (v20(v92.RadiantSpark, not v13:IsSpellInRange(v92.RadiantSpark), true) or ((6787 - 3207) < (9344 - 6500))) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				if (((231 - (96 + 46)) < (5267 - (643 + 134))) and v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v112) and (v92.ArcaneOrb:TimeSinceLastCast() >= (6 + 9)) and (v12:ArcaneCharges() < (6 - 3))) then
					if (v20(v92.ArcaneOrb, not v13:IsInRange(148 - 108)) or ((4779 + 204) < (3547 - 1739))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				v136 = 1 - 0;
			end
		end
	end
	local function v122()
		local v137 = 719 - (316 + 403);
		while true do
			if (((2546 + 1283) > (10362 - 6593)) and (v137 == (1 + 0))) then
				if (((3739 - 2254) <= (2058 + 846)) and v92.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v92.TouchoftheMagiDebuff) <= v113)) then
					if (((1376 + 2893) == (14791 - 10522)) and v20(v92.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if (((1848 - 1461) <= (5779 - 2997)) and v92.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v92.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((109 + 1790) <= (1804 - 887))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33 and (v12:BuffUp(v92.ArcaneHarmonyBuff) or (v92.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (2 + 33)))) and (v13:DebuffRemains(v92.TouchoftheMagiDebuff) <= v113)) or ((12686 - 8374) <= (893 - (12 + 5)))) then
					if (((8669 - 6437) <= (5538 - 2942)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v137 = 3 - 1;
			end
			if (((5195 - 3100) < (749 + 2937)) and (v137 == (1973 - (1656 + 317)))) then
				if ((v13:DebuffRemains(v92.TouchoftheMagiDebuff) > (9 + 0)) or ((1279 + 316) >= (11896 - 7422))) then
					v103 = not v103;
				end
				if ((v92.NetherTempest:IsReady() and v41 and (v13:DebuffRefreshable(v92.NetherTempestDebuff) or not v13:DebuffUp(v92.NetherTempestDebuff)) and (v12:ArcaneCharges() == (19 - 15)) and (v12:ManaPercentage() < (384 - (5 + 349))) and (v12:SpellHaste() < (0.667 - 0)) and v12:BuffDown(v92.ArcaneSurgeBuff)) or ((5890 - (266 + 1005)) < (1900 + 982))) then
					if (v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest)) or ((1003 - 709) >= (6360 - 1529))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((3725 - (561 + 1135)) <= (4018 - 934)) and v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v12:ArcaneCharges() < (6 - 4)) and (v12:ManaPercentage() < (1096 - (507 + 559))) and (v12:SpellHaste() < (0.667 - 0)) and v12:BuffDown(v92.ArcaneSurgeBuff)) then
					if (v20(v92.ArcaneOrb, not v13:IsInRange(123 - 83)) or ((2425 - (212 + 176)) == (3325 - (250 + 655)))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v137 = 2 - 1;
			end
			if (((7789 - 3331) > (6107 - 2203)) and (v137 == (1958 - (1869 + 87)))) then
				if (((1512 - 1076) >= (2024 - (484 + 1417))) and v12:IsChanneling(v92.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v92.NetherPrecisionBuff) and (((v12:ManaPercentage() > (50 - 20)) and (v92.TouchoftheMagi:CooldownRemains() > (803 - (48 + 725)))) or (v12:ManaPercentage() > (114 - 44))) and v12:BuffDown(v92.ArcaneArtilleryBuff)) then
					if (((1341 - 841) < (1056 + 760)) and v20(v94.StopCasting, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((9551 - 5977) == (1001 + 2573)) and v92.ArcaneMissiles:IsCastable() and v37 and (v12:BuffStack(v92.ClearcastingBuff) > (1 + 0)) and v92.ConjureManaGem:IsAvailable() and v93.ManaGem:CooldownUp()) then
					if (((1074 - (152 + 701)) < (1701 - (430 + 881))) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v92.NetherPrecisionBuff))) or ((848 + 1365) <= (2316 - (557 + 338)))) then
					if (((904 + 2154) < (13695 - 8835)) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v137 = 10 - 7;
			end
			if ((v137 == (7 - 4)) or ((2792 - 1496) >= (5247 - (499 + 302)))) then
				if ((v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ClearcastingBuff) and ((v13:DebuffRemains(v92.TouchoftheMagiDebuff) > v92.ArcaneMissiles:CastTime()) or not v92.PresenceofMind:IsAvailable())) or ((2259 - (39 + 827)) > (12391 - 7902))) then
					if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((9879 - 5455) < (107 - 80))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32) or ((3065 - 1068) > (327 + 3488))) then
					if (((10141 - 6676) > (307 + 1606)) and v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if (((1159 - 426) < (1923 - (103 + 1))) and v92.ArcaneBarrage:IsReady() and v33) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((4949 - (475 + 79)) == (10279 - 5524))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1 + 0)) or ((3339 + 454) < (3872 - (1395 + 108)))) then
				if ((v92.ArcaneBarrage:IsReady() and v33 and ((((v99 <= (11 - 7)) or (v100 <= (1208 - (7 + 1197)))) and (v12:ArcaneCharges() == (2 + 1))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) or ((1426 + 2658) == (584 - (27 + 292)))) then
					if (((12770 - 8412) == (5557 - 1199)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v112) and (v12:ArcaneCharges() < (8 - 6))) or ((6188 - 3050) < (1890 - 897))) then
					if (((3469 - (43 + 96)) > (9475 - 7152)) and v20(v92.ArcaneOrb, not v13:IsInRange(90 - 50))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v138 = 2 + 0;
			end
			if ((v138 == (0 + 0)) or ((7166 - 3540) == (1529 + 2460))) then
				if ((v13:DebuffRemains(v92.TouchoftheMagiDebuff) > (16 - 7)) or ((289 + 627) == (196 + 2475))) then
					v103 = not v103;
				end
				if (((2023 - (1414 + 337)) == (2212 - (1642 + 298))) and v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ArcaneArtilleryBuff) and v12:BuffUp(v92.ClearcastingBuff)) then
					if (((11076 - 6827) <= (13920 - 9081)) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v138 = 2 - 1;
			end
			if (((914 + 1863) < (2490 + 710)) and (v138 == (974 - (357 + 615)))) then
				if (((67 + 28) < (4801 - 2844)) and v92.ArcaneExplosion:IsCastable() and v34) then
					if (((708 + 118) < (3679 - 1962)) and v20(v92.ArcaneExplosion, not v13:IsInRange(8 + 2))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((897 + 529) >= (2406 - (384 + 917))) and ((702 - (128 + 569)) == v139)) then
				if (((4297 - (1407 + 136)) <= (5266 - (687 + 1200))) and v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ClearcastingBuff) and v12:BuffDown(v92.NetherPrecisionBuff) and (not v108 or not v106)) then
					if (v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((5637 - (556 + 1154)) == (4970 - 3557))) then
						return "arcane_missiles rotation 30";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32) or ((1249 - (9 + 86)) <= (1209 - (275 + 146)))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((268 + 1375) > (3443 - (29 + 35)))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33) or ((12422 - 9619) > (13587 - 9038))) then
					if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((971 - 751) >= (1969 + 1053))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((3834 - (53 + 959)) == (3230 - (312 + 96))) and ((1 - 0) == v139)) then
				if ((v92.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v112) and not v108 and v12:BuffDown(v92.ArcaneSurgeBuff) and (v92.ArcaneSurge:CooldownRemains() > (330 - (147 + 138))) and (v112 > (914 - (813 + 86)))) or ((959 + 102) == (3440 - 1583))) then
					if (((3252 - (18 + 474)) > (461 + 903)) and v20(v92.ShiftingPower, not v13:IsInRange(130 - 90))) then
						return "shifting_power rotation 6";
					end
				end
				if ((v92.PresenceofMind:IsCastable() and v42 and (v12:ArcaneCharges() < (1089 - (860 + 226))) and (v13:HealthPercentage() < (338 - (121 + 182))) and v92.ArcaneBombardment:IsAvailable()) or ((604 + 4298) <= (4835 - (988 + 252)))) then
					if (v20(v92.PresenceofMind) or ((436 + 3416) == (92 + 201))) then
						return "presence_of_mind rotation 8";
					end
				end
				if ((v92.ArcaneBlast:IsReady() and v32 and v92.TimeAnomaly:IsAvailable() and v12:BuffUp(v92.ArcaneSurgeBuff) and (v12:BuffRemains(v92.ArcaneSurgeBuff) <= (1976 - (49 + 1921)))) or ((2449 - (223 + 667)) == (4640 - (51 + 1)))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((7717 - 3233) == (1687 - 899))) then
						return "arcane_blast rotation 10";
					end
				end
				v139 = 1127 - (146 + 979);
			end
			if (((1290 + 3278) >= (4512 - (311 + 294))) and (v139 == (11 - 7))) then
				if (((528 + 718) < (4913 - (496 + 947))) and v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ClearcastingBuff) and v12:BuffUp(v92.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
					if (((5426 - (1233 + 125)) >= (395 + 577)) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if (((443 + 50) < (740 + 3153)) and v92.ArcaneBlast:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v92.NetherPrecisionBuff)) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((3118 - (963 + 682)) >= (2781 + 551))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (1564 - (504 + 1000))) and v103 and (v92.TouchoftheMagi:CooldownRemains() > (7 + 3)) and (v92.Evocation:CooldownRemains() > (37 + 3)) and (v112 > (2 + 18))) or ((5973 - 1922) <= (989 + 168))) then
					if (((352 + 252) < (3063 - (156 + 26))) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage rotation 26";
					end
				end
				v139 = 3 + 2;
			end
			if ((v139 == (3 - 0)) or ((1064 - (149 + 15)) == (4337 - (890 + 70)))) then
				if (((4576 - (39 + 78)) > (1073 - (14 + 468))) and v92.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v92.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v92.TemporalWarpBuff) or (v12:ManaPercentage() < (21 - 11)) or not v92.ShiftingPower:IsAvailable()) and v12:BuffDown(v92.ArcaneSurgeBuff) and (v112 >= (33 - 21))) then
					if (((1754 + 1644) >= (1439 + 956)) and v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest))) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (11 + 39)) and not v92.Evocation:IsAvailable() and (v112 > (10 + 10))) or ((572 + 1611) >= (5405 - 2581))) then
					if (((1914 + 22) == (6803 - 4867)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage rotation 18";
					end
				end
				if ((v92.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (2 + 68)) and v103 and v12:BloodlustUp() and (v92.TouchoftheMagi:CooldownRemains() > (56 - (12 + 39))) and (v112 > (19 + 1))) or ((14956 - 10124) < (15360 - 11047))) then
					if (((1212 + 2876) > (2040 + 1834)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
						return "arcane_barrage rotation 20";
					end
				end
				v139 = 9 - 5;
			end
			if (((2886 + 1446) == (20935 - 16603)) and ((1712 - (1596 + 114)) == v139)) then
				if (((10440 - 6441) >= (3613 - (164 + 549))) and v92.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v92.PresenceofMindBuff) and (v13:HealthPercentage() < (1473 - (1059 + 379))) and v92.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (3 - 0))) then
					if (v20(v92.ArcaneBlast, not v13:IsSpellInRange(v92.ArcaneBlast)) or ((1309 + 1216) > (686 + 3378))) then
						return "arcane_blast rotation 12";
					end
				end
				if (((4763 - (145 + 247)) == (3587 + 784)) and v12:IsChanneling(v92.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v92.NetherPrecisionBuff) and (((v12:ManaPercentage() > (88 - 58)) and (v92.TouchoftheMagi:CooldownRemains() > (6 + 24))) or (v12:ManaPercentage() > (61 + 9))) and v12:BuffDown(v92.ArcaneArtilleryBuff)) then
					if (v20(v94.StopCasting, not v13:IsSpellInRange(v92.ArcaneMissiles)) or ((431 - 165) > (5706 - (254 + 466)))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if (((2551 - (544 + 16)) >= (2939 - 2014)) and v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ClearcastingBuff) and (v12:BuffStack(v92.ClearcastingBuff) == v110)) then
					if (((1083 - (294 + 334)) < (2306 - (236 + 17))) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
						return "arcane_missiles rotation 14";
					end
				end
				v139 = 2 + 1;
			end
			if ((v139 == (0 + 0)) or ((3110 - 2284) == (22967 - 18116))) then
				if (((95 + 88) == (151 + 32)) and v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v112) and (v12:ArcaneCharges() < (797 - (413 + 381))) and (v12:BloodlustDown() or (v12:ManaPercentage() > (3 + 67)) or (v108 and (v92.TouchoftheMagi:CooldownRemains() > (63 - 33))))) then
					if (((3010 - 1851) <= (3758 - (582 + 1388))) and v20(v92.ArcaneOrb, not v13:IsInRange(68 - 28))) then
						return "arcane_orb rotation 2";
					end
				end
				v103 = ((v92.ArcaneSurge:CooldownRemains() > (22 + 8)) and (v92.TouchoftheMagi:CooldownRemains() > (374 - (326 + 38)))) or false;
				if ((v92.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v112) and v108 and (not v92.Evocation:IsAvailable() or (v92.Evocation:CooldownRemains() > (35 - 23))) and (not v92.ArcaneSurge:IsAvailable() or (v92.ArcaneSurge:CooldownRemains() > (16 - 4))) and (not v92.TouchoftheMagi:IsAvailable() or (v92.TouchoftheMagi:CooldownRemains() > (632 - (47 + 573)))) and (v112 > (6 + 9))) or ((14894 - 11387) > (7007 - 2689))) then
					if (v20(v92.ShiftingPower, not v13:IsInRange(1704 - (1269 + 395))) or ((3567 - (76 + 416)) <= (3408 - (319 + 124)))) then
						return "shifting_power rotation 4";
					end
				end
				v139 = 2 - 1;
			end
		end
	end
	local function v125()
		if (((2372 - (564 + 443)) <= (5567 - 3556)) and v92.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v112) and (not v92.Evocation:IsAvailable() or (v92.Evocation:CooldownRemains() > (470 - (337 + 121)))) and (not v92.ArcaneSurge:IsAvailable() or (v92.ArcaneSurge:CooldownRemains() > (34 - 22))) and (not v92.TouchoftheMagi:IsAvailable() or (v92.TouchoftheMagi:CooldownRemains() > (39 - 27))) and v12:BuffDown(v92.ArcaneSurgeBuff) and ((not v92.ChargedOrb:IsAvailable() and (v92.ArcaneOrb:CooldownRemains() > (1923 - (1261 + 650)))) or (v92.ArcaneOrb:Charges() == (0 + 0)) or (v92.ArcaneOrb:CooldownRemains() > (18 - 6)))) then
			if (v20(v92.ShiftingPower, not v13:IsInRange(1857 - (772 + 1045)), true) or ((392 + 2384) > (3719 - (102 + 42)))) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v92.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v92.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v92.ArcaneSurgeBuff) and ((v99 > (1850 - (1524 + 320))) or (v100 > (1276 - (1049 + 221))) or not v92.OrbBarrage:IsAvailable())) or ((2710 - (18 + 138)) == (11758 - 6954))) then
			if (((3679 - (67 + 1035)) == (2925 - (136 + 212))) and v20(v92.NetherTempest, not v13:IsSpellInRange(v92.NetherTempest))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if ((v92.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v92.ArcaneArtilleryBuff) and v12:BuffUp(v92.ClearcastingBuff) and (v92.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v92.ArcaneArtilleryBuff) + (21 - 16)))) or ((5 + 1) >= (1742 + 147))) then
			if (((2110 - (240 + 1364)) <= (2974 - (1050 + 32))) and v20(v92.ArcaneMissiles, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if ((v92.ArcaneBarrage:IsReady() and v33 and ((v99 <= (14 - 10)) or (v100 <= (3 + 1)) or v12:BuffUp(v92.ClearcastingBuff)) and (v12:ArcaneCharges() == (1058 - (331 + 724)))) or ((163 + 1845) > (2862 - (269 + 375)))) then
			if (((1104 - (267 + 458)) <= (1290 + 2857)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if ((v92.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v112) and (v12:ArcaneCharges() == (0 - 0)) and (v92.TouchoftheMagi:CooldownRemains() > (836 - (667 + 151)))) or ((6011 - (1410 + 87)) <= (2906 - (1504 + 393)))) then
			if (v20(v92.ArcaneOrb, not v13:IsInRange(108 - 68)) or ((9069 - 5573) == (1988 - (461 + 335)))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if ((v92.ArcaneBarrage:IsReady() and v33 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (2 + 8)))) or ((1969 - (1730 + 31)) == (4626 - (728 + 939)))) then
			if (((15147 - 10870) >= (2662 - 1349)) and v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if (((5927 - 3340) < (4242 - (138 + 930))) and v92.ArcaneExplosion:IsCastable() and v34) then
			if (v20(v92.ArcaneExplosion, not v13:IsInRange(10 + 0)) or ((3222 + 898) <= (1884 + 314))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v126()
		if ((v92.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v112) and (v12:PrevGCDP(4 - 3, v92.ArcaneBarrage))) or ((3362 - (459 + 1307)) == (2728 - (474 + 1396)))) then
			if (((5622 - 2402) == (3018 + 202)) and v20(v92.TouchoftheMagi, not v13:IsSpellInRange(v92.TouchoftheMagi))) then
				return "touch_of_the_magi main 30";
			end
		end
		if ((v12:IsChanneling(v92.Evocation) and (((v12:ManaPercentage() >= (1 + 94)) and not v92.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v112 * (11 - 7))) and not ((v112 > (2 + 8)) and (v92.ArcaneSurge:CooldownRemains() < (3 - 2)))))) or ((6114 - 4712) > (4211 - (562 + 29)))) then
			if (((2195 + 379) == (3993 - (374 + 1045))) and v20(v94.StopCasting, not v13:IsSpellInRange(v92.ArcaneMissiles))) then
				return "cancel_action evocation main 32";
			end
		end
		if (((1424 + 374) < (8560 - 5803)) and v92.ArcaneBarrage:IsReady() and v33 and (v112 < (640 - (448 + 190)))) then
			if (v20(v92.ArcaneBarrage, not v13:IsSpellInRange(v92.ArcaneBarrage)) or ((122 + 255) > (1176 + 1428))) then
				return "arcane_barrage main 34";
			end
		end
		if (((371 + 197) < (3502 - 2591)) and v92.Evocation:IsCastable() and v39 and not v106 and v12:BuffDown(v92.ArcaneSurgeBuff) and v13:DebuffDown(v92.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (31 - 21)) and (v92.TouchoftheMagi:CooldownRemains() < (1514 - (1307 + 187)))) or (v92.TouchoftheMagi:CooldownRemains() < (59 - 44))) and (v12:ManaPercentage() < (v112 * (8 - 4)))) then
			if (((10072 - 6787) < (4911 - (232 + 451))) and v20(v92.Evocation)) then
				return "evocation main 36";
			end
		end
		if (((3740 + 176) > (2940 + 388)) and v92.ConjureManaGem:IsCastable() and v38 and v13:DebuffDown(v92.TouchoftheMagiDebuff) and v12:BuffDown(v92.ArcaneSurgeBuff) and (v92.ArcaneSurge:CooldownRemains() < (594 - (510 + 54))) and (v92.ArcaneSurge:CooldownRemains() < v112) and not v93.ManaGem:Exists()) then
			if (((5036 - 2536) < (3875 - (13 + 23))) and v20(v92.ConjureManaGem)) then
				return "conjure_mana_gem main 38";
			end
		end
		if (((988 - 481) == (728 - 221)) and v93.ManaGem:IsReady() and v40 and v92.CascadingPower:IsAvailable() and (v12:BuffStack(v92.ClearcastingBuff) < (3 - 1)) and v12:BuffUp(v92.ArcaneSurgeBuff)) then
			if (((1328 - (830 + 258)) <= (11164 - 7999)) and v20(v94.ManaGem)) then
				return "mana_gem main 40";
			end
		end
		if (((522 + 312) >= (685 + 120)) and v93.ManaGem:IsReady() and v40 and not v92.CascadingPower:IsAvailable() and v12:PrevGCDP(1442 - (860 + 581), v92.ArcaneSurge) and (not v107 or (v107 and v12:PrevGCDP(7 - 5, v92.ArcaneSurge)))) then
			if (v20(v94.ManaGem) or ((3026 + 786) < (2557 - (237 + 4)))) then
				return "mana_gem main 42";
			end
		end
		if ((not v108 and ((v92.ArcaneSurge:CooldownRemains() <= (v113 * ((2 - 1) + v23(v92.NetherTempest:IsAvailable() and v92.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v92.ArcaneSurgeBuff) > ((6 - 3) * v23(v12:HasTier(56 - 26, 2 + 0) and not v12:HasTier(18 + 12, 15 - 11)))) or v12:BuffUp(v92.ArcaneOverloadBuff)) and (v92.Evocation:CooldownRemains() > (20 + 25)) and ((v92.TouchoftheMagi:CooldownRemains() < (v113 * (3 + 1))) or (v92.TouchoftheMagi:CooldownRemains() > (1446 - (85 + 1341)))) and ((v99 < v102) or (v100 < v102))) or ((4524 - 1872) <= (4329 - 2796))) then
			local v145 = 372 - (45 + 327);
			while true do
				if ((v145 == (0 - 0)) or ((4100 - (444 + 58)) < (635 + 825))) then
					v26 = v119();
					if (v26 or ((709 + 3407) < (583 + 609))) then
						return v26;
					end
					break;
				end
			end
		end
		if ((not v108 and (v92.ArcaneSurge:CooldownRemains() > (86 - 56)) and (v92.RadiantSpark:CooldownUp() or v13:DebuffUp(v92.RadiantSparkDebuff) or v13:DebuffUp(v92.RadiantSparkVulnerability)) and ((v92.TouchoftheMagi:CooldownRemains() <= (v113 * (1735 - (64 + 1668)))) or v13:DebuffUp(v92.TouchoftheMagiDebuff)) and ((v99 < v102) or (v100 < v102))) or ((5350 - (1227 + 746)) <= (2775 - 1872))) then
			local v146 = 0 - 0;
			while true do
				if (((4470 - (415 + 79)) >= (12 + 427)) and (v146 == (491 - (142 + 349)))) then
					v26 = v119();
					if (((1608 + 2144) == (5158 - 1406)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if (((2011 + 2035) > (1899 + 796)) and v29 and v92.RadiantSpark:IsAvailable() and v104) then
			local v147 = 0 - 0;
			while true do
				if ((v147 == (1864 - (1710 + 154))) or ((3863 - (200 + 118)) == (1267 + 1930))) then
					v26 = v121();
					if (((4185 - 1791) > (553 - 180)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if (((3692 + 463) <= (4187 + 45)) and v29 and v108 and v92.RadiantSpark:IsAvailable() and v105) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (0 + 0)) or ((7758 - 4177) == (4723 - (363 + 887)))) then
					v26 = v120();
					if (((8722 - 3727) > (15935 - 12587)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if ((v29 and v13:DebuffUp(v92.TouchoftheMagiDebuff) and ((v99 >= v102) or (v100 >= v102))) or ((117 + 637) > (8713 - 4989))) then
			v26 = v123();
			if (((149 + 68) >= (1721 - (674 + 990))) and v26) then
				return v26;
			end
		end
		if ((v29 and v108 and v13:DebuffUp(v92.TouchoftheMagiDebuff) and ((v99 < v102) or (v100 < v102))) or ((594 + 1476) >= (1653 + 2384))) then
			local v149 = 0 - 0;
			while true do
				if (((3760 - (507 + 548)) == (3542 - (289 + 548))) and (v149 == (1818 - (821 + 997)))) then
					v26 = v122();
					if (((316 - (195 + 60)) == (17 + 44)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if ((v99 >= v102) or (v100 >= v102) or ((2200 - (251 + 1250)) >= (3796 - 2500))) then
			v26 = v125();
			if (v26 or ((1226 + 557) >= (4648 - (809 + 223)))) then
				return v26;
			end
		end
		if ((v99 < v102) or (v100 < v102) or ((5709 - 1796) > (13595 - 9068))) then
			v26 = v124();
			if (((14469 - 10093) > (602 + 215)) and v26) then
				return v26;
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if (((5478 - (14 + 603)) > (953 - (118 + 11))) and (v140 == (1 + 5))) then
				v55 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v56 = EpicSettings.Settings['useAlterTime'];
				v57 = EpicSettings.Settings['usePrismaticBarrier'];
				v58 = EpicSettings.Settings['useGreaterInvisibility'];
				v140 = 6 + 1;
			end
			if ((v140 == (29 - 19)) or ((2332 - (551 + 398)) >= (1347 + 784))) then
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['mirrorImageBeforePull'];
				v91 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v140 == (4 + 5)) or ((1525 + 351) >= (9450 - 6909))) then
				v67 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
				v68 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v69 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v140 = 3 + 7;
			end
			if (((1871 - (40 + 49)) <= (14364 - 10592)) and (v140 == (498 - (99 + 391)))) then
				v63 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v64 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
				v65 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v66 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v140 = 23 - 14;
			end
			if ((v140 == (1611 - (1032 + 572))) or ((5117 - (203 + 214)) < (2630 - (568 + 1249)))) then
				v59 = EpicSettings.Settings['useIceBlock'];
				v60 = EpicSettings.Settings['useIceCold'];
				v61 = EpicSettings.Settings['useMassBarrier'];
				v62 = EpicSettings.Settings['useMirrorImage'];
				v140 = 7 + 1;
			end
			if (((7682 - 4483) < (15643 - 11593)) and (v140 == (1309 - (913 + 393)))) then
				v43 = EpicSettings.Settings['useCounterspell'];
				v44 = EpicSettings.Settings['useBlastWave'];
				v45 = EpicSettings.Settings['useDragonsBreath'];
				v46 = EpicSettings.Settings['useArcaneSurge'];
				v140 = 11 - 7;
			end
			if ((v140 == (5 - 1)) or ((5361 - (269 + 141)) < (9853 - 5423))) then
				v47 = EpicSettings.Settings['useShiftingPower'];
				v48 = EpicSettings.Settings['useArcaneOrb'];
				v49 = EpicSettings.Settings['useRadiantSpark'];
				v50 = EpicSettings.Settings['useTouchOfTheMagi'];
				v140 = 1986 - (362 + 1619);
			end
			if (((1721 - (950 + 675)) == (38 + 58)) and (v140 == (1184 - (216 + 963)))) then
				v51 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v54 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v140 = 1293 - (485 + 802);
			end
			if ((v140 == (560 - (432 + 127))) or ((3812 - (1065 + 8)) > (2227 + 1781))) then
				v36 = EpicSettings.Settings['useArcaneIntellect'];
				v37 = EpicSettings.Settings['useArcaneMissiles'];
				v38 = EpicSettings.Settings['useConjureManaGem'];
				v39 = EpicSettings.Settings['useEvocation'];
				v140 = 1603 - (635 + 966);
			end
			if (((0 + 0) == v140) or ((65 - (5 + 37)) == (2819 - 1685))) then
				v32 = EpicSettings.Settings['useArcaneBlast'];
				v33 = EpicSettings.Settings['useArcaneBarrage'];
				v34 = EpicSettings.Settings['useArcaneExplosion'];
				v35 = EpicSettings.Settings['useArcaneFamiliar'];
				v140 = 1 + 0;
			end
			if ((v140 == (2 - 0)) or ((1261 + 1432) >= (8542 - 4431))) then
				v40 = EpicSettings.Settings['useManaGem'];
				v41 = EpicSettings.Settings['useNetherTempest'];
				v42 = EpicSettings.Settings['usePresenceOfMind'];
				v90 = EpicSettings.Settings['cancelPOM'];
				v140 = 11 - 8;
			end
		end
	end
	local function v128()
		local v141 = 0 - 0;
		while true do
			if (((11 - 6) == v141) or ((3104 + 1212) <= (2675 - (318 + 211)))) then
				v72 = EpicSettings.Settings['handleAfflicted'];
				v73 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v141 == (0 - 0)) or ((5133 - (963 + 624)) <= (1201 + 1608))) then
				v77 = EpicSettings.Settings['fightRemainsCheck'] or (846 - (518 + 328));
				v74 = EpicSettings.Settings['InterruptWithStun'];
				v75 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v141 = 2 - 1;
			end
			if (((7838 - 2934) > (2483 - (301 + 16))) and (v141 == (5 - 3))) then
				v79 = EpicSettings.Settings['useTrinkets'];
				v78 = EpicSettings.Settings['useRacials'];
				v80 = EpicSettings.Settings['trinketsWithCD'];
				v141 = 8 - 5;
			end
			if (((284 - 175) >= (82 + 8)) and ((1 + 0) == v141)) then
				v76 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['DispelDebuffs'];
				v70 = EpicSettings.Settings['DispelBuffs'];
				v141 = 3 - 1;
			end
			if (((2995 + 1983) > (277 + 2628)) and (v141 == (9 - 6))) then
				v81 = EpicSettings.Settings['racialsWithCD'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v82 = EpicSettings.Settings['useHealingPotion'];
				v141 = 2 + 2;
			end
			if ((v141 == (1023 - (829 + 190))) or ((10796 - 7770) <= (2884 - 604))) then
				v85 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v141 = 2 + 3;
			end
		end
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (5 - 3)) or ((1560 + 93) <= (1721 - (520 + 93)))) then
				v98 = v13:GetEnemiesInSplashRange(281 - (259 + 17));
				v101 = v12:GetEnemiesInRange(3 + 37);
				if (((1047 + 1862) > (8832 - 6223)) and v28) then
					v99 = v25(v13:GetEnemiesInSplashRangeCount(596 - (396 + 195)), #v101);
					v100 = #v101;
				else
					v99 = 2 - 1;
					v100 = 1762 - (440 + 1321);
				end
				if (((2586 - (1059 + 770)) > (897 - 703)) and (v96.TargetIsValid() or v12:AffectingCombat())) then
					local v205 = 545 - (424 + 121);
					while true do
						if ((v205 == (1 + 0)) or ((1378 - (641 + 706)) >= (554 + 844))) then
							v112 = v111;
							if (((3636 - (249 + 191)) <= (21223 - 16351)) and (v112 == (4963 + 6148))) then
								v112 = v9.FightRemains(v101, false);
							end
							break;
						end
						if (((12818 - 9492) == (3753 - (183 + 244))) and (v205 == (0 + 0))) then
							if (((2163 - (434 + 296)) <= (12375 - 8497)) and (v12:AffectingCombat() or v71)) then
								local v208 = 512 - (169 + 343);
								local v209;
								while true do
									if ((v208 == (0 + 0)) or ((2784 - 1201) == (5092 - 3357))) then
										v209 = v71 and v92.RemoveCurse:IsReady() and v31;
										v26 = v96.FocusUnit(v209, v94, 17 + 3, nil, 56 - 36);
										v208 = 1124 - (651 + 472);
									end
									if ((v208 == (1 + 0)) or ((1287 + 1694) == (2868 - 518))) then
										if (v26 or ((4949 - (397 + 86)) <= (1369 - (423 + 453)))) then
											return v26;
										end
										break;
									end
								end
							end
							v111 = v9.BossFightRemains(nil, true);
							v205 = 1 + 0;
						end
					end
				end
				v142 = 1 + 2;
			end
			if ((v142 == (3 + 0)) or ((2033 + 514) <= (1775 + 212))) then
				v113 = v12:GCD();
				if (((4151 - (50 + 1140)) > (2369 + 371)) and v72) then
					if (((2183 + 1513) >= (225 + 3387)) and v91) then
						v26 = v96.HandleAfflicted(v92.RemoveCurse, v94.RemoveCurseMouseover, 43 - 13);
						if (v26 or ((2150 + 820) == (2474 - (157 + 439)))) then
							return v26;
						end
					end
				end
				if (not v12:AffectingCombat() or v27 or ((6420 - 2727) < (6568 - 4591))) then
					local v206 = 0 - 0;
					while true do
						if ((v206 == (918 - (782 + 136))) or ((1785 - (112 + 743)) > (3272 - (1026 + 145)))) then
							if (((713 + 3440) > (3804 - (493 + 225))) and v92.ArcaneIntellect:IsCastable() and v36 and (v12:BuffDown(v92.ArcaneIntellect, true) or v96.GroupBuffMissing(v92.ArcaneIntellect))) then
								if (v20(v92.ArcaneIntellect) or ((17106 - 12452) <= (2464 + 1586))) then
									return "arcane_intellect group_buff";
								end
							end
							if ((v92.ArcaneFamiliar:IsReady() and v35 and v12:BuffDown(v92.ArcaneFamiliarBuff)) or ((6976 - 4374) < (29 + 1467))) then
								if (v20(v92.ArcaneFamiliar) or ((2915 - 1895) > (667 + 1621))) then
									return "arcane_familiar precombat 2";
								end
							end
							v206 = 1 - 0;
						end
						if (((1923 - (210 + 1385)) == (2017 - (1201 + 488))) and ((1 + 0) == v206)) then
							if (((2687 - 1176) < (6829 - 3021)) and v92.ConjureManaGem:IsCastable() and v38) then
								if (v20(v92.ConjureManaGem) or ((3095 - (352 + 233)) > (11887 - 6968))) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
					end
				end
				if (((2592 + 2171) == (13542 - 8779)) and v96.TargetIsValid()) then
					local v207 = 574 - (489 + 85);
					while true do
						if (((5638 - (277 + 1224)) > (3341 - (663 + 830))) and ((0 + 0) == v207)) then
							if (((5965 - 3529) <= (4009 - (461 + 414))) and v71 and v31 and v92.RemoveCurse:IsAvailable()) then
								if (((625 + 3098) == (1490 + 2233)) and v14) then
									local v212 = 0 + 0;
									while true do
										if ((v212 == (0 + 0)) or ((4296 - (172 + 78)) >= (6958 - 2642))) then
											v26 = v115();
											if (v26 or ((740 + 1268) < (2782 - 853))) then
												return v26;
											end
											break;
										end
									end
								end
								if (((651 + 1733) > (593 + 1182)) and v15 and v15:Exists() and v15:IsAPlayer() and v96.UnitHasCurseDebuff(v15)) then
									if (v92.RemoveCurse:IsReady() or ((7610 - 3067) <= (5508 - 1132))) then
										if (((183 + 545) == (403 + 325)) and v20(v94.RemoveCurseMouseover)) then
											return "remove_curse dispel";
										end
									end
								end
							end
							if ((not v12:AffectingCombat() and v27) or ((383 + 693) > (18593 - 13922))) then
								v26 = v117();
								if (((4312 - 2461) >= (116 + 262)) and v26) then
									return v26;
								end
							end
							v207 = 1 + 0;
						end
						if ((v207 == (449 - (133 + 314))) or ((339 + 1609) >= (3689 - (199 + 14)))) then
							if (((17161 - 12367) >= (2382 - (647 + 902))) and v72) then
								if (((12298 - 8208) == (4323 - (85 + 148))) and v91) then
									v26 = v96.HandleAfflicted(v92.RemoveCurse, v94.RemoveCurseMouseover, 1319 - (426 + 863));
									if (v26 or ((17587 - 13829) == (4152 - (873 + 781)))) then
										return v26;
									end
								end
							end
							if (v73 or ((3578 - 905) < (4253 - 2678))) then
								v26 = v96.HandleIncorporeal(v92.Polymorph, v94.PolymorphMouseOver, 13 + 17, true);
								if (v26 or ((13746 - 10025) <= (2084 - 629))) then
									return v26;
								end
							end
							v207 = 8 - 5;
						end
						if (((2881 - (414 + 1533)) < (1969 + 301)) and (v207 == (556 - (443 + 112)))) then
							v26 = v114();
							if (v26 or ((3091 - (888 + 591)) == (3242 - 1987))) then
								return v26;
							end
							v207 = 1 + 1;
						end
						if ((v207 == (11 - 8)) or ((1699 + 2653) < (2035 + 2171))) then
							if ((v92.Spellsteal:IsAvailable() and v87 and v92.Spellsteal:IsReady() and v31 and v70 and not v12:IsCasting() and not v12:IsChanneling() and v96.UnitHasMagicBuff(v13)) or ((306 + 2554) <= (344 - 163))) then
								if (((5968 - 2746) >= (3205 - (136 + 1542))) and v20(v92.Spellsteal, not v13:IsSpellInRange(v92.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							if (((4935 - 3430) <= (2106 + 15)) and not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v96.TargetIsValid()) then
								local v210 = 0 - 0;
								local v211;
								while true do
									if (((539 + 205) == (1230 - (68 + 418))) and (v210 == (2 - 1))) then
										if ((v88 and v92.TimeWarp:IsReady() and v92.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v92.ArcaneSurge:CooldownUp() or (v112 <= (72 - 32)) or (v12:BuffUp(v92.ArcaneSurgeBuff) and (v112 <= (v92.ArcaneSurge:CooldownRemains() + 13 + 1))))) or ((3071 - (770 + 322)) >= (164 + 2672))) then
											if (((531 + 1302) <= (365 + 2303)) and v20(v92.TimeWarp, not v13:IsInRange(57 - 17))) then
												return "time_warp main 4";
											end
										end
										if (((7146 - 3460) == (10038 - 6352)) and v78 and ((v81 and v29) or not v81) and (v77 < v112)) then
											local v213 = 0 - 0;
											while true do
												if (((1932 + 1535) > (713 - 236)) and (v213 == (0 + 0))) then
													if ((v92.LightsJudgment:IsCastable() and v12:BuffDown(v92.ArcaneSurgeBuff) and v13:DebuffDown(v92.TouchoftheMagiDebuff) and ((v99 >= (2 + 0)) or (v100 >= (2 + 0)))) or ((12381 - 9093) >= (4918 - 1377))) then
														if (v20(v92.LightsJudgment, not v13:IsSpellInRange(v92.LightsJudgment)) or ((1203 + 2354) == (20913 - 16373))) then
															return "lights_judgment main 6";
														end
													end
													if ((v92.Berserking:IsCastable() and ((v12:PrevGCDP(3 - 2, v92.ArcaneSurge) and not (v12:BuffUp(v92.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v92.ArcaneSurgeBuff) and v13:DebuffUp(v92.TouchoftheMagiDebuff)))) or ((108 + 153) > (6269 - 5002))) then
														if (((2103 - (762 + 69)) < (12492 - 8634)) and v20(v92.Berserking)) then
															return "berserking main 8";
														end
													end
													v213 = 1 + 0;
												end
												if (((2373 + 1291) == (8862 - 5198)) and (v213 == (1 + 0))) then
													if (((31 + 1910) >= (1753 - 1303)) and v12:PrevGCDP(158 - (8 + 149), v92.ArcaneSurge)) then
														local v215 = 1320 - (1199 + 121);
														while true do
															if ((v215 == (0 - 0)) or ((10488 - 5842) < (134 + 190))) then
																if (((13681 - 9848) == (8893 - 5060)) and v92.BloodFury:IsCastable()) then
																	if (v20(v92.BloodFury) or ((1098 + 142) > (5177 - (518 + 1289)))) then
																		return "blood_fury main 10";
																	end
																end
																if (v92.Fireblood:IsCastable() or ((4254 - 1773) == (622 + 4060))) then
																	if (((6903 - 2176) >= (154 + 54)) and v20(v92.Fireblood)) then
																		return "fireblood main 12";
																	end
																end
																v215 = 470 - (304 + 165);
															end
															if (((265 + 15) < (4011 - (54 + 106))) and ((1970 - (1618 + 351)) == v215)) then
																if (v92.AncestralCall:IsCastable() or ((2121 + 886) > (4210 - (10 + 1006)))) then
																	if (v20(v92.AncestralCall) or ((537 + 1599) >= (413 + 2533))) then
																		return "ancestral_call main 14";
																	end
																end
																break;
															end
														end
													end
													break;
												end
											end
										end
										v210 = 6 - 4;
									end
									if (((3198 - (912 + 121)) <= (1192 + 1329)) and (v210 == (1289 - (1140 + 149)))) then
										v211 = v96.HandleDPSPotion(not v92.ArcaneSurge:IsReady());
										if (((1831 + 1030) > (880 - 219)) and v211) then
											return v211;
										end
										v210 = 1 + 0;
									end
									if (((15486 - 10961) > (8475 - 3956)) and (v210 == (1 + 1))) then
										if (((11028 - 7850) > (1158 - (165 + 21))) and (v77 < v112)) then
											if (((4877 - (61 + 50)) == (1964 + 2802)) and v79 and ((v29 and v80) or not v80)) then
												local v214 = 0 - 0;
												while true do
													if ((v214 == (0 - 0)) or ((1079 + 1666) > (4588 - (1295 + 165)))) then
														v26 = v116();
														if (v26 or ((262 + 882) >= (1852 + 2754))) then
															return v26;
														end
														break;
													end
												end
											end
										end
										v26 = v118();
										v210 = 1400 - (819 + 578);
									end
									if (((4740 - (331 + 1071)) >= (1020 - (588 + 155))) and (v210 == (1286 - (546 + 736)))) then
										if (((4547 - (1834 + 103)) > (1575 + 985)) and v26) then
											return v26;
										end
										break;
									end
									if ((v210 == (8 - 5)) or ((2960 - (1536 + 230)) > (3574 - (128 + 363)))) then
										if (((195 + 721) >= (1858 - 1111)) and v26) then
											return v26;
										end
										v26 = v126();
										v210 = 2 + 2;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v142 == (0 - 0)) or ((7194 - 4750) > (7174 - 4220))) then
				v127();
				v128();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v142 = 1 + 0;
			end
			if (((3901 - (615 + 394)) < (3173 + 341)) and (v142 == (1 + 0))) then
				v29 = EpicSettings.Toggles['cds'];
				v30 = EpicSettings.Toggles['minicds'];
				v31 = EpicSettings.Toggles['dispel'];
				if (((1624 - 1091) == (2417 - 1884)) and v12:IsDeadOrGhost()) then
					return v26;
				end
				v142 = 653 - (59 + 592);
			end
		end
	end
	local function v130()
		v97();
		v18.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(137 - 75, v129, v130);
end;
return v0["Epix_Mage_Arcane.lua"]();

