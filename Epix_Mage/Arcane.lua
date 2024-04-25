local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1067 - (389 + 678);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((1011 - 528) > (2706 - (556 + 1407)))) then
			v6 = v0[v4];
			if (((3660 - (741 + 465)) > (1043 - (170 + 295))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((855 + 75) < (10975 - 6517)) and (v5 == (1 + 0))) then
			return v6(...);
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
	local v93;
	local v94 = v17.Mage.Arcane;
	local v95 = v18.Mage.Arcane;
	local v96 = v22.Mage.Arcane;
	local v97 = {};
	local v98 = v19.Commons.Everyone;
	local function v99()
		if (((425 + 237) <= (551 + 421)) and v94.RemoveCurse:IsAvailable()) then
			v98.DispellableDebuffs = v98.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v99();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v94.ArcaneBlast:RegisterInFlight();
	v94.ArcaneBarrage:RegisterInFlight();
	local v100, v101;
	local v102, v103;
	local v104 = 1233 - (957 + 273);
	local v105 = false;
	local v106 = false;
	local v107 = false;
	local v108 = true;
	local v109 = false;
	local v110 = v13:HasTier(8 + 21, 2 + 2);
	local v111 = (857349 - 632349) - (((65880 - 40880) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((610901 - 410901) * v24(not v110)));
	local v112 = 14 - 11;
	local v113 = 12891 - (389 + 1391);
	local v114 = 6972 + 4139;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if (((9948 - 5578) == (5321 - (783 + 168))) and (v134 == (6 - 4))) then
				v114 = 10930 + 181;
				break;
			end
			if ((v134 == (312 - (309 + 2))) or ((14623 - 9861) <= (2073 - (1090 + 122)))) then
				v111 = (72948 + 152052) - (((83962 - 58962) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((136874 + 63126) * v24(not v110)));
				v113 = 12229 - (628 + 490);
				v134 = 1 + 1;
			end
			if ((v134 == (0 - 0)) or ((6452 - 5040) == (5038 - (431 + 343)))) then
				v105 = false;
				v108 = true;
				v134 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v110 = not v13:HasTier(83 - 54, 4 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v116()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (1699 - (556 + 1139))) or ((3183 - (6 + 9)) < (395 + 1758))) then
				if ((v84 and (v13:HealthPercentage() <= v86)) or ((2550 + 2426) < (1501 - (28 + 141)))) then
					local v210 = 0 + 0;
					while true do
						if (((5712 - 1084) == (3278 + 1350)) and (v210 == (1317 - (486 + 831)))) then
							if ((v88 == "Refreshing Healing Potion") or ((140 - 86) == (1390 - 995))) then
								if (((16 + 66) == (259 - 177)) and v95.RefreshingHealingPotion:IsReady()) then
									if (v21(v96.RefreshingHealingPotion) or ((1844 - (668 + 595)) < (254 + 28))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((930 + 3679) < (6804 - 4309))) then
								if (((1442 - (23 + 267)) == (3096 - (1129 + 815))) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (((2283 - (371 + 16)) <= (5172 - (1326 + 424))) and v21(v96.RefreshingHealingPotion)) then
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
			if ((v135 == (0 - 0)) or ((3617 - 2627) > (1738 - (88 + 30)))) then
				if ((v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((1648 - (720 + 51)) > (10444 - 5749))) then
					if (((4467 - (421 + 1355)) >= (3053 - 1202)) and v21(v94.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 1 + 1, v94.ArcaneIntellect)) or ((4068 - (286 + 797)) >= (17751 - 12895))) then
					if (((7081 - 2805) >= (1634 - (397 + 42))) and v21(v94.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 1 + 0;
			end
			if (((4032 - (24 + 776)) <= (7225 - 2535)) and (v135 == (786 - (222 + 563)))) then
				if ((v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) or ((1973 - 1077) >= (2266 + 880))) then
					if (((3251 - (23 + 167)) >= (4756 - (690 + 1108))) and v21(v94.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((1150 + 2037) >= (532 + 112)) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (((1492 - (40 + 808)) <= (116 + 588)) and v21(v94.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v135 = 7 - 5;
			end
			if (((916 + 42) > (501 + 446)) and ((2 + 1) == v135)) then
				if (((5063 - (47 + 524)) >= (1723 + 931)) and v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) then
					if (((9408 - 5966) >= (2247 - 744)) and v21(v94.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) or ((7229 - 4059) <= (3190 - (1165 + 561)))) then
					if (v21(v96.Healthstone) or ((143 + 4654) == (13590 - 9202))) then
						return "healthstone defensive";
					end
				end
				v135 = 2 + 2;
			end
			if (((1030 - (341 + 138)) <= (184 + 497)) and (v135 == (3 - 1))) then
				if (((3603 - (89 + 237)) > (1309 - 902)) and v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) then
					if (((9884 - 5189) >= (2296 - (581 + 300))) and v21(v94.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((4432 - (855 + 365)) <= (2242 - 1298))) then
					if (v21(v94.GreaterInvisibility) or ((1011 + 2085) <= (3033 - (1030 + 205)))) then
						return "greater_invisibility defensive 5";
					end
				end
				v135 = 3 + 0;
			end
		end
	end
	local v117 = 0 + 0;
	local function v118()
		if (((3823 - (156 + 130)) == (8036 - 4499)) and v94.RemoveCurse:IsReady() and (v98.UnitHasDispellableDebuffByPlayer(v15) or v98.DispellableFriendlyUnit(42 - 17) or v98.UnitHasCurseDebuff(v15))) then
			local v156 = 0 - 0;
			while true do
				if (((1012 + 2825) >= (916 + 654)) and (v156 == (69 - (10 + 59)))) then
					if ((v117 == (0 + 0)) or ((14528 - 11578) == (4975 - (671 + 492)))) then
						v117 = GetTime();
					end
					if (((3760 + 963) >= (3533 - (369 + 846))) and v98.Wait(133 + 367, v117)) then
						local v218 = 0 + 0;
						while true do
							if ((v218 == (1945 - (1036 + 909))) or ((1612 + 415) > (4787 - 1935))) then
								if (v21(v96.RemoveCurseFocus) or ((1339 - (11 + 192)) > (2182 + 2135))) then
									return "remove_curse dispel";
								end
								v117 = 175 - (135 + 40);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v119()
		local v136 = 0 - 0;
		while true do
			if (((2862 + 1886) == (10459 - 5711)) and (v136 == (0 - 0))) then
				v27 = v98.HandleTopTrinket(v97, v30, 216 - (50 + 126), nil);
				if (((10402 - 6666) <= (1050 + 3690)) and v27) then
					return v27;
				end
				v136 = 1414 - (1233 + 180);
			end
			if ((v136 == (970 - (522 + 447))) or ((4811 - (107 + 1314)) <= (1420 + 1640))) then
				v27 = v98.HandleBottomTrinket(v97, v30, 121 - 81, nil);
				if (v27 or ((425 + 574) > (5347 - 2654))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v120()
		if (((1831 - 1368) < (2511 - (716 + 1194))) and v94.MirrorImage:IsCastable() and v91 and v63) then
			if (v21(v94.MirrorImage) or ((38 + 2145) < (74 + 613))) then
				return "mirror_image precombat 2";
			end
		end
		if (((5052 - (74 + 429)) == (8774 - 4225)) and v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) then
			if (((2316 + 2356) == (10694 - 6022)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast precombat 4";
			end
		end
		if ((v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) or ((2596 + 1072) < (1217 - 822))) then
			if (v21(v94.Evocation) or ((10300 - 6134) == (888 - (279 + 154)))) then
				return "evocation precombat 6";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((5227 - (454 + 324)) == (2096 + 567))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(57 - (12 + 5))) or ((2306 + 1971) < (7615 - 4626))) then
				return "arcane_orb precombat 8";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33) or ((322 + 548) >= (5242 - (277 + 816)))) then
			if (((9451 - 7239) < (4366 - (1058 + 125))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v121()
		local v137 = 0 + 0;
		while true do
			if (((5621 - (815 + 160)) > (12837 - 9845)) and ((2 - 1) == v137)) then
				if (((343 + 1091) < (9079 - 5973)) and v14:DebuffUp(v94.TouchoftheMagiDebuff) and v108) then
					v108 = false;
				end
				v109 = v94.ArcaneBlast:CastTime() < v115;
				break;
			end
			if (((2684 - (41 + 1857)) < (4916 - (1222 + 671))) and (v137 == (0 - 0))) then
				if ((((v101 >= v104) or (v102 >= v104)) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (1185 - (229 + 953)))) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1776 - (1111 + 663))))) or ((4021 - (874 + 705)) < (11 + 63))) then
					v106 = true;
				elseif (((3095 + 1440) == (9426 - 4891)) and v106 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (1 + 6)) and v94.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				if (((v13:ArcaneCharges() > (682 - (642 + 37))) and ((v101 < v104) or (v102 < v104)) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (2 + 5))) and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * (1 + 4))) or (v94.ArcaneSurge:CooldownRemains() > (100 - 60)))) or ((3463 - (233 + 221)) <= (4867 - 2762))) then
					v107 = true;
				elseif (((1611 + 219) < (5210 - (718 + 823))) and v107 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (5 + 2)) and v94.RadiantSpark:CooldownDown()) then
					v107 = false;
				end
				v137 = 806 - (266 + 539);
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1226 - (636 + 589))) or ((3394 - 1964) >= (7449 - 3837))) then
				if (((2127 + 556) >= (894 + 1566)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and v94.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(1055 - (657 + 358))) or ((4776 - 2972) >= (7461 - 4186))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v94.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (1189 - (1151 + 36))) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v94.ArcaneOrb:CooldownRemains() >= v115)))) or ((1369 + 48) > (955 + 2674))) then
					if (((14319 - 9524) > (2234 - (1552 + 280))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((5647 - (64 + 770)) > (2421 + 1144)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and (v13:ManaPercentage() > (6 + 24)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (((5155 - (157 + 1086)) == (7829 - 3917)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				v138 = 8 - 6;
			end
			if (((4327 - 1506) <= (6583 - 1759)) and (v138 == (819 - (599 + 220)))) then
				if (((3460 - 1722) <= (4126 - (1813 + 118))) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) then
					if (((1258 - (841 + 376)) <= (4228 - 1210)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((499 + 1646) <= (11201 - 7097)) and v94.RadiantSpark:CooldownUp()) then
					v105 = v94.ArcaneSurge:CooldownRemains() < (869 - (464 + 395));
				end
				if (((6900 - 4211) < (2327 + 2518)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(877 - (467 + 370)), true) or ((4798 - 2476) > (1925 + 697))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				v138 = 3 - 2;
			end
			if ((v138 == (1 + 1)) or ((10548 - 6014) == (2602 - (150 + 370)))) then
				if ((v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1287 - (74 + 1208))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (14 - 8)))) and v13:HasTier(146 - 115, 3 + 1)) or ((1961 - (14 + 376)) > (3237 - 1370))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1718 + 936) >= (2632 + 364))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((3794 + 184) > (6164 - 4060)) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (13 + 4)) and not v13:HasTier(108 - (23 + 55), 9 - 5)) then
					if (((1999 + 996) > (1384 + 157)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				if (((5036 - 1787) > (300 + 653)) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (903 - (652 + 249))) and (v94.RadiantSpark:CooldownRemains() < (13 - 8)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (1874 - (708 + 1160))))) and not v13:HasTier(81 - 51, 6 - 2)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3300 - (10 + 17)) > (1028 + 3545))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				v138 = 1735 - (1400 + 332);
			end
			if ((v138 == (7 - 3)) or ((5059 - (242 + 1666)) < (550 + 734))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (11 + 19)) and (v94.ArcaneEcho:IsAvailable())) or ((1577 + 273) == (2469 - (850 + 90)))) then
					if (((1437 - 616) < (3513 - (360 + 1030))) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((799 + 103) < (6562 - 4237)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
					if (((1180 - 322) <= (4623 - (909 + 752))) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1224 - (109 + 1114), v94.ArcaneSurge) or v13:PrevGCDP(1 - 0, v94.NetherTempest) or v13:PrevGCDP(1 + 0, v94.RadiantSpark))) or ((4188 - (6 + 236)) < (812 + 476))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((2610 + 632) == (1336 - 769))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				v138 = 8 - 3;
			end
			if ((v138 == (1139 - (1076 + 57))) or ((140 + 707) >= (1952 - (579 + 110)))) then
				if ((v94.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 3)) and v13:PrevGCDP(1 + 0, v94.ArcaneBlast)))) or ((1196 + 1057) == (2258 - (174 + 233)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((5829 - 3742) > (4162 - 1790))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((1977 + 2468) < (5323 - (663 + 511)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1622 + 196) == (19 + 66))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if (((1942 - 1312) < (1289 + 838)) and (v138 == (11 - 6))) then
				if ((v94.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v94.RadiantSparkVulnerability) and (v14:DebuffStack(v94.RadiantSparkVulnerability) < (9 - 5))) or ((925 + 1013) == (4892 - 2378))) then
					if (((3033 + 1222) >= (6 + 49)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if (((3721 - (478 + 244)) > (1673 - (440 + 77))) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (((1069 + 1281) > (4227 - 3072)) and v21(v94.PresenceofMind)) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if (((5585 - (655 + 901)) <= (900 + 3953)) and v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.PresenceofMindBuff))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((396 + 120) > (2319 + 1115))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				v138 = 24 - 18;
			end
			if (((5491 - (695 + 750)) >= (10356 - 7323)) and ((3 - 0) == v138)) then
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (60 - 45)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (356 - (285 + 66))))) and (v94.ArcaneSurge:CooldownRemains() < (69 - 39))) or ((4029 - (682 + 628)) <= (234 + 1213))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((4433 - (176 + 123)) < (1643 + 2283))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < v115)) and v13:HasTier(22 + 8, 273 - (239 + 30))) or ((45 + 119) >= (2677 + 108))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((928 - 403) == (6579 - 4470))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if (((348 - (306 + 9)) == (115 - 82)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (((532 + 2522) <= (2464 + 1551)) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v138 = 2 + 2;
			end
		end
	end
	local function v123()
		local v139 = 0 - 0;
		while true do
			if (((3246 - (1140 + 235)) < (2153 + 1229)) and (v139 == (1 + 0))) then
				if (((332 + 961) <= (2218 - (33 + 19))) and v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (1 + 1)) and (v94.RadiantSpark:CooldownRemains() < (14 - 9)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (3 + 3)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((5057 - 2478) < (116 + 7))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (704 - (586 + 103))) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1 + 4)))) and (v94.ArcaneSurge:CooldownRemains() < (92 - 62))) or ((2334 - (1309 + 179)) >= (4274 - 1906))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1747 + 2265) <= (9018 - 5660))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if (((1129 + 365) <= (6384 - 3379)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((6198 - 3087) == (2743 - (295 + 314)))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((5784 - 3429) == (4317 - (1300 + 662))) and v94.NetherTempest:IsReady() and v42 and not v109 and (v94.NetherTempest:TimeSinceLastCast() >= (46 - 31)) and ((not v109 and v13:PrevGCDP(1759 - (1178 + 577), v94.RadiantSpark) and (v94.ArcaneSurge:CooldownRemains() <= v94.NetherTempest:ExecuteTime())) or v13:PrevGCDP(3 + 2, v94.RadiantSpark))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((1738 - 1150) <= (1837 - (851 + 554)))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v139 = 2 + 0;
			end
			if (((13303 - 8506) >= (8459 - 4564)) and (v139 == (304 - (115 + 187)))) then
				if (((2740 + 837) == (3387 + 190)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114) and ((not v94.NetherTempest:IsAvailable() and ((v13:PrevGCDP(15 - 11, v94.RadiantSpark) and not v109) or v13:PrevGCDP(1166 - (160 + 1001), v94.RadiantSpark))) or v13:PrevGCDP(1 + 0, v94.NetherTempest))) then
					if (((2618 + 1176) > (7559 - 3866)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v94.ArcaneBlast:CastTime() >= v13:GCD()) and (v94.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v94.RadiantSparkVulnerability)) and (not v94.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (393 - (237 + 121)))) and ((v94.NetherTempest:IsAvailable() and v13:PrevGCDP(903 - (525 + 372), v94.RadiantSpark)) or (not v94.NetherTempest:IsAvailable() and v13:PrevGCDP(9 - 4, v94.RadiantSpark))) and not (v13:IsCasting(v94.ArcaneSurge) and (v13:CastRemains() < (0.5 - 0)) and not v109)) or ((1417 - (96 + 46)) == (4877 - (643 + 134)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((575 + 1016) >= (8584 - 5004))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((3649 - 2666) <= (1734 + 74)) and v94.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (7 - 3))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4394 - 2244) <= (1916 - (316 + 403)))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((2506 + 1263) >= (3224 - 2051)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and v13:PrevGCDP(1 + 0, v94.ArcaneBarrage) and ((v94.ArcaneBarrage:InFlight() and ((v94.ArcaneBarrage:TravelTime() - v94.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 - 0))) or (v13:GCDRemains() <= (0.2 + 0)))) then
					if (((479 + 1006) == (5145 - 3660)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v139 = 14 - 11;
			end
			if ((v139 == (5 - 2)) or ((190 + 3125) <= (5476 - 2694))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((43 + 833) >= (8720 - 5756))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((2249 - (12 + 5)) > (9698 - 7201))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((4501 - 2391) <= (705 - 373))) then
					if (((9140 - 5454) > (644 + 2528)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if ((v139 == (1973 - (1656 + 317))) or ((3987 + 487) < (658 + 162))) then
				if (((11377 - 7098) >= (14183 - 11301)) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (399 - (5 + 349))) and v14:DebuffDown(v94.NetherTempestDebuff) and v108 and v13:BloodlustUp()) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((9637 - 7608) >= (4792 - (266 + 1005)))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((v108 and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((6950 - 4913) >= (6111 - 1469))) then
					if (((3416 - (561 + 1135)) < (5809 - 1351)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (16 - 11)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (1072 - (507 + 559))))) and v13:HasTier(77 - 46, 12 - 8)) or ((824 - (212 + 176)) > (3926 - (250 + 655)))) then
					if (((1944 - 1231) <= (1479 - 632)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if (((3369 - 1215) <= (5987 - (1869 + 87))) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (52 - 37))) then
					if (((6516 - (484 + 1417)) == (9891 - 5276)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v139 = 1 - 0;
			end
		end
	end
	local function v124()
		local v140 = 773 - (48 + 725);
		while true do
			if ((v140 == (0 - 0)) or ((10168 - 6378) == (291 + 209))) then
				if (((237 - 148) < (62 + 159)) and v13:BuffUp(v94.PresenceofMindBuff) and v92 and (v13:PrevGCDP(1 + 0, v94.ArcaneBlast)) and (v94.ArcaneSurge:CooldownRemains() > (928 - (152 + 701)))) then
					if (((3365 - (430 + 881)) >= (545 + 876)) and v21(v96.CancelPOM)) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if (((1587 - (557 + 338)) < (904 + 2154)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((11394 - 8140) == (4396 - 2741))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((2792 - 1496) == (5711 - (499 + 302)))) then
					if (((4234 - (39 + 827)) == (9297 - 5929)) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes))) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				if (((5902 - 3259) < (15152 - 11337)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v94.ArcaneOrb:TimeSinceLastCast() >= (22 - 7)) and (v13:ArcaneCharges() < (1 + 2))) then
					if (((5599 - 3686) > (79 + 414)) and v21(v94.ArcaneOrb, not v14:IsInRange(63 - 23))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				v140 = 105 - (103 + 1);
			end
			if (((5309 - (475 + 79)) > (7410 - 3982)) and (v140 == (6 - 4))) then
				if (((179 + 1202) <= (2085 + 284)) and v94.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1504 - (1395 + 108))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 3)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1207 - (7 + 1197))) and ((v101 > (3 + 2)) or (v102 > (2 + 3)))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (323 - (27 + 292)))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable()) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((14191 - 9348) == (5207 - 1123))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				if (((19580 - 14911) > (715 - 352)) and v94.PresenceofMind:IsCastable() and v43) then
					if (v21(v94.PresenceofMind) or ((3574 - 1697) >= (3277 - (43 + 96)))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if (((19343 - 14601) >= (8197 - 4571)) and v94.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 + 0)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 2))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable()))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((8973 - 4433) == (352 + 564))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (7 - 3)) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 2)) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) or ((85 + 1071) > (6096 - (1414 + 337)))) then
					if (((4177 - (1642 + 298)) < (11076 - 6827)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v140 == (2 - 1)) or ((7961 - 5278) < (8 + 15))) then
				if (((543 + 154) <= (1798 - (357 + 615))) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (11 + 4)) and (v94.ArcaneEcho:IsAvailable())) then
					if (((2711 - 1606) <= (1008 + 168)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if (((7240 - 3861) <= (3049 + 763)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
					if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes)) or ((54 + 734) >= (1016 + 600))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				if (((3155 - (384 + 917)) <= (4076 - (128 + 569))) and v94.ArcaneBarrage:IsReady() and v34 and (v94.ArcaneSurge:CooldownRemains() < (1618 - (1407 + 136))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1891 - (687 + 1200))) and not v94.OrbBarrage:IsAvailable()) then
					if (((6259 - (556 + 1154)) == (16003 - 11454)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (97 - (9 + 86))) and (v94.ArcaneSurge:CooldownRemains() > (496 - (275 + 146)))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (139 - (29 + 35))) and not v94.OrbBarrage:IsAvailable()))) or ((13393 - 10371) >= (9032 - 6008))) then
					if (((21277 - 16457) > (1432 + 766)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				v140 = 1014 - (53 + 959);
			end
		end
	end
	local function v125()
		local v141 = 408 - (312 + 96);
		while true do
			if ((v141 == (3 - 1)) or ((1346 - (147 + 138)) >= (5790 - (813 + 86)))) then
				if (((1233 + 131) <= (8286 - 3813)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (492 - (18 + 474))) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (11 + 19)) and (v94.TouchoftheMagi:CooldownRemains() > (97 - 67))) or (v13:ManaPercentage() > (1156 - (860 + 226)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((3898 - (121 + 182)) <= (1 + 2))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v94.ClearcastingBuff) > (1241 - (988 + 252))) and v94.ConjureManaGem:IsAvailable() and v95.ManaGem:CooldownUp()) or ((528 + 4144) == (1207 + 2645))) then
					if (((3529 - (49 + 1921)) == (2449 - (223 + 667))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.NetherPrecisionBuff))) or ((1804 - (51 + 1)) <= (1356 - 568))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((8365 - 4458) == (1302 - (146 + 979)))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v141 = 1 + 2;
			end
			if (((4075 - (311 + 294)) > (1547 - 992)) and (v141 == (0 + 0))) then
				if ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (1452 - (496 + 947))) or ((2330 - (1233 + 125)) == (262 + 383))) then
					v105 = not v105;
				end
				if (((2855 + 327) >= (402 + 1713)) and v94.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v94.NetherTempestDebuff) or not v14:DebuffUp(v94.NetherTempestDebuff)) and (v13:ArcaneCharges() == (1649 - (963 + 682))) and (v13:ManaPercentage() < (26 + 4)) and (v13:SpellHaste() < (1504.667 - (504 + 1000))) and v13:BuffDown(v94.ArcaneSurgeBuff)) then
					if (((2622 + 1271) < (4034 + 395)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (1 + 1)) and (v13:ManaPercentage() < (44 - 14)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) or ((1668 + 1199) < (2087 - (156 + 26)))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(24 + 16)) or ((2809 - 1013) >= (4215 - (149 + 15)))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v141 = 961 - (890 + 70);
			end
			if (((1736 - (39 + 78)) <= (4238 - (14 + 468))) and (v141 == (6 - 3))) then
				if (((1688 - 1084) == (312 + 292)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > v94.ArcaneMissiles:CastTime()) or not v94.PresenceofMind:IsAvailable())) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((2693 + 1791) == (192 + 708))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((2014 + 2445) <= (292 + 821))) then
					if (((6951 - 3319) > (3359 + 39)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if (((14344 - 10262) <= (125 + 4792)) and v94.ArcaneBarrage:IsReady() and v34) then
					if (((4883 - (12 + 39)) >= (1290 + 96)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if (((423 - 286) == (487 - 350)) and (v141 == (1 + 0))) then
				if ((v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((827 + 743) >= (10984 - 6652))) then
					if (v21(v94.PresenceofMind) or ((2707 + 1357) <= (8790 - 6971))) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((6696 - (1596 + 114)) < (4109 - 2535))) then
					if (((5139 - (164 + 549)) > (1610 - (1059 + 379))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if (((727 - 141) > (236 + 219)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v94.ArcaneHarmonyBuff) or (v94.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (6 + 29)))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (((1218 - (145 + 247)) == (678 + 148)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v141 = 1 + 1;
			end
		end
	end
	local function v126()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (0 + 0)) or ((3462 + 557) > (7210 - 2769))) then
				if (((2737 - (254 + 466)) < (4821 - (544 + 16))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (28 - 19))) then
					v105 = not v105;
				end
				if (((5344 - (294 + 334)) > (333 - (236 + 17))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1512 + 1995) == (2547 + 725))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v142 = 3 - 2;
			end
			if ((v142 == (9 - 7)) or ((452 + 424) >= (2533 + 542))) then
				if (((5146 - (413 + 381)) > (108 + 2446)) and v94.ArcaneExplosion:IsCastable() and v35) then
					if (v21(v94.ArcaneExplosion, not v14:IsInRange(21 - 11)) or ((11444 - 7038) < (6013 - (582 + 1388)))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((v142 == (1 - 0)) or ((1353 + 536) >= (3747 - (326 + 38)))) then
				if (((5596 - 3704) <= (3902 - 1168)) and v94.ArcaneBarrage:IsReady() and v34 and ((((v101 <= (624 - (47 + 573))) or (v102 <= (2 + 2))) and (v13:ArcaneCharges() == (12 - 9))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) then
					if (((3120 - 1197) < (3882 - (1269 + 395))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if (((2665 - (76 + 416)) > (822 - (319 + 124))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (4 - 2))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(1047 - (564 + 443))) or ((7172 - 4581) == (3867 - (337 + 121)))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v142 = 5 - 3;
			end
		end
	end
	local function v127()
		local v143 = 0 - 0;
		while true do
			if (((6425 - (1261 + 650)) > (1407 + 1917)) and (v143 == (1 - 0))) then
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and not v110 and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (1862 - (772 + 1045))) and (v114 > (3 + 12))) or ((352 - (102 + 42)) >= (6672 - (1524 + 320)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(1310 - (1049 + 221))) or ((1739 - (18 + 138)) > (8730 - 5163))) then
						return "shifting_power rotation 6";
					end
				end
				if ((v94.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (1105 - (67 + 1035))) and (v14:HealthPercentage() < (383 - (136 + 212))) and v94.ArcaneBombardment:IsAvailable()) or ((5579 - 4266) == (637 + 157))) then
					if (((2926 + 248) > (4506 - (240 + 1364))) and v21(v94.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((5202 - (1050 + 32)) <= (15210 - 10950)) and v94.ArcaneBlast:IsReady() and v33 and v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (4 + 2))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1938 - (331 + 724)) > (386 + 4392))) then
						return "arcane_blast rotation 10";
					end
				end
				v143 = 646 - (269 + 375);
			end
			if ((v143 == (728 - (267 + 458))) or ((1126 + 2494) >= (9405 - 4514))) then
				if (((5076 - (667 + 151)) > (2434 - (1410 + 87))) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (1907 - (1504 + 393))) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v114 >= (32 - 20))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((12631 - 7762) < (1702 - (461 + 335)))) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (7 + 43)) and not v94.Evocation:IsAvailable() and (v114 > (1781 - (1730 + 31)))) or ((2892 - (728 + 939)) > (14974 - 10746))) then
					if (((6750 - 3422) > (5127 - 2889)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((4907 - (138 + 930)) > (1284 + 121)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (55 + 15)) and v105 and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (5 + 0)) and (v114 > (81 - 61))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((3059 - (459 + 1307)) <= (2377 - (474 + 1396)))) then
						return "arcane_barrage rotation 20";
					end
				end
				v143 = 6 - 2;
			end
			if ((v143 == (0 + 0)) or ((10 + 2886) < (2305 - 1500))) then
				if (((294 + 2022) == (7731 - 5415)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (12 - 9)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (661 - (562 + 29))) or (v110 and (v94.TouchoftheMagi:CooldownRemains() > (26 + 4))))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(1459 - (374 + 1045))) or ((2035 + 535) == (4760 - 3227))) then
						return "arcane_orb rotation 2";
					end
				end
				v105 = ((v94.ArcaneSurge:CooldownRemains() > (668 - (448 + 190))) and (v94.TouchoftheMagi:CooldownRemains() > (4 + 6))) or false;
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v110 and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (6 + 6))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (8 + 4))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (46 - 34))) and (v114 > (46 - 31))) or ((2377 - (1307 + 187)) == (5789 - 4329))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(93 - 53)) or ((14162 - 9543) <= (1682 - (232 + 451)))) then
						return "shifting_power rotation 4";
					end
				end
				v143 = 1 + 0;
			end
			if ((v143 == (2 + 0)) or ((3974 - (510 + 54)) > (8292 - 4176))) then
				if ((v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v14:HealthPercentage() < (71 - (13 + 23))) and v94.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (5 - 2))) or ((1296 - 393) >= (5557 - 2498))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((5064 - (830 + 258)) < (10078 - 7221))) then
						return "arcane_blast rotation 12";
					end
				end
				if (((3085 + 1845) > (1963 + 344)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (1441 - (860 + 581))) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (110 - 80)) and (v94.TouchoftheMagi:CooldownRemains() > (24 + 6))) or (v13:ManaPercentage() > (311 - (237 + 4)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((9508 - 5462) < (3266 - 1975))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) == v112)) or ((8040 - 3799) == (2902 + 643))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((2325 + 1723) > (15977 - 11745))) then
						return "arcane_missiles rotation 14";
					end
				end
				v143 = 2 + 1;
			end
			if ((v143 == (3 + 2)) or ((3176 - (85 + 1341)) >= (5925 - 2452))) then
				if (((8941 - 5775) == (3538 - (45 + 327))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and (not v110 or not v108)) then
					if (((3326 - 1563) < (4226 - (444 + 58))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles rotation 30";
					end
				end
				if (((25 + 32) <= (469 + 2254)) and v94.ArcaneBlast:IsReady() and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1012 + 1058) == (1283 - 840))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((4437 - (64 + 1668)) == (3366 - (1227 + 746)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((14142 - 9541) < (112 - 51))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((498 - (415 + 79)) == v143) or ((36 + 1354) >= (5235 - (142 + 349)))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffUp(v94.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((859 + 1144) > (5271 - 1437))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((78 + 78) > (2757 + 1156))) then
						return "arcane_missiles rotation 22";
					end
				end
				if (((530 - 335) == (2059 - (1710 + 154))) and v94.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) then
					if (((3423 - (200 + 118)) >= (712 + 1084)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast rotation 24";
					end
				end
				if (((7655 - 3276) >= (3160 - 1029)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (54 + 6)) and v105 and (v94.TouchoftheMagi:CooldownRemains() > (10 + 0)) and (v94.Evocation:CooldownRemains() > (22 + 18)) and (v114 > (4 + 16))) then
					if (((8327 - 4483) >= (3293 - (363 + 887))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage rotation 26";
					end
				end
				v143 = 8 - 3;
			end
		end
	end
	local function v128()
		if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (57 - 45))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (2 + 10))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (27 - 15))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (9 + 3))) or (v94.ArcaneOrb:Charges() == (1664 - (674 + 990))) or (v94.ArcaneOrb:CooldownRemains() > (4 + 8)))) or ((1323 + 1909) <= (4328 - 1597))) then
			if (((5960 - (507 + 548)) == (5742 - (289 + 548))) and v21(v94.ShiftingPower, not v14:IsInRange(1858 - (821 + 997)), true)) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (261 - (195 + 60))) or (v102 > (2 + 4)) or not v94.OrbBarrage:IsAvailable())) or ((5637 - (251 + 1250)) >= (12922 - 8511))) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((2033 + 925) == (5049 - (809 + 223)))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if (((1791 - 563) >= (2441 - 1628)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v94.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v94.ArcaneArtilleryBuff) + (16 - 11)))) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((2545 + 910) > (2121 + 1929))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if (((860 - (14 + 603)) == (372 - (118 + 11))) and v94.ArcaneBarrage:IsReady() and v34 and ((v101 <= (1 + 3)) or (v102 <= (4 + 0)) or v13:BuffUp(v94.ClearcastingBuff)) and (v13:ArcaneCharges() == (8 - 5))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1220 - (551 + 398)) > (994 + 578))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if (((975 + 1764) < (2677 + 616)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() == (0 - 0)) and (v94.TouchoftheMagi:CooldownRemains() > (41 - 23))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(13 + 27)) or ((15648 - 11706) < (314 + 820))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (99 - (40 + 49))))) or ((10255 - 7562) == (5463 - (99 + 391)))) then
			if (((1776 + 370) == (9433 - 7287)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v94.ArcaneExplosion:IsCastable() and v35) or ((5556 - 3312) == (3141 + 83))) then
			if (v21(v94.ArcaneExplosion, not v14:IsInRange(26 - 16)) or ((6508 - (1032 + 572)) <= (2333 - (203 + 214)))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v129()
		local v144 = 1817 - (568 + 1249);
		while true do
			if (((71 + 19) <= (2557 - 1492)) and (v144 == (3 - 2))) then
				if (((6108 - (913 + 393)) == (13560 - 8758)) and v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (42 - 12)) and (v94.ArcaneSurge:CooldownRemains() < v114) and not v95.ManaGem:Exists()) then
					if (v21(v94.ConjureManaGem) or ((2690 - (269 + 141)) <= (1136 - 625))) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (1983 - (362 + 1619))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((3301 - (950 + 675)) <= (179 + 284))) then
					if (((5048 - (216 + 963)) == (5156 - (485 + 802))) and v21(v96.ManaGem)) then
						return "mana_gem main 40";
					end
				end
				if (((1717 - (432 + 127)) <= (3686 - (1065 + 8))) and v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and v13:PrevGCDP(1 + 0, v94.ArcaneSurge) and (not v109 or (v109 and v13:PrevGCDP(1603 - (635 + 966), v94.ArcaneSurge)))) then
					if (v21(v96.ManaGem) or ((1700 + 664) <= (2041 - (5 + 37)))) then
						return "mana_gem main 42";
					end
				end
				if ((not v110 and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * ((2 - 1) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((2 + 1) * v24(v13:HasTier(47 - 17, 1 + 1) and not v13:HasTier(62 - 32, 15 - 11)))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (84 - 39)) and ((v94.TouchoftheMagi:CooldownRemains() < (v115 * (9 - 5))) or (v94.TouchoftheMagi:CooldownRemains() > (15 + 5))) and ((v101 < v104) or (v102 < v104))) or ((5451 - (318 + 211)) < (954 - 760))) then
					local v211 = 1587 - (963 + 624);
					while true do
						if ((v211 == (0 + 0)) or ((2937 - (518 + 328)) < (72 - 41))) then
							v27 = v122();
							if (v27 or ((3884 - 1454) >= (5189 - (301 + 16)))) then
								return v27;
							end
							break;
						end
					end
				end
				v144 = 5 - 3;
			end
			if ((v144 == (0 - 0)) or ((12446 - 7676) < (1572 + 163))) then
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) or ((9476 - 5037) <= (1414 + 936))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((427 + 4052) < (14198 - 9732))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((823 + 1724) > (2244 - (829 + 190))) and v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (338 - 243)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v114 * (4 - 0))) and not ((v114 > (13 - 3)) and (v94.ArcaneSurge:CooldownRemains() < (2 - 1)))))) then
					if (((1107 + 3564) > (874 + 1800)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v114 < (5 - 3))) or ((3488 + 208) < (3940 - (520 + 93)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4818 - (259 + 17)) == (172 + 2798))) then
						return "arcane_barrage main 34";
					end
				end
				if (((91 + 161) <= (6693 - 4716)) and v94.Evocation:IsCastable() and v40 and not v108 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (601 - (396 + 195))) and (v94.TouchoftheMagi:CooldownRemains() < (58 - 38))) or (v94.TouchoftheMagi:CooldownRemains() < (1776 - (440 + 1321)))) and (v13:ManaPercentage() < (v114 * (1833 - (1059 + 770))))) then
					if (v21(v94.Evocation) or ((6640 - 5204) == (4320 - (424 + 121)))) then
						return "evocation main 36";
					end
				end
				v144 = 1 + 0;
			end
			if ((v144 == (1349 - (641 + 706))) or ((641 + 977) < (1370 - (249 + 191)))) then
				if (((20574 - 15851) > (1855 + 2298)) and not v110 and (v94.ArcaneSurge:CooldownRemains() > (115 - 85)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v115 * (430 - (183 + 244)))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and ((v101 < v104) or (v102 < v104))) then
					local v212 = 0 + 0;
					while true do
						if ((v212 == (730 - (434 + 296))) or ((11660 - 8006) >= (5166 - (169 + 343)))) then
							v27 = v122();
							if (((834 + 117) <= (2631 - 1135)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v94.RadiantSpark:IsAvailable() and v106) or ((5095 - 3359) == (468 + 103))) then
					local v213 = 0 - 0;
					while true do
						if (((1123 - (651 + 472)) == v213) or ((678 + 218) > (2058 + 2711))) then
							v27 = v124();
							if (v27 or ((1275 - 230) <= (1503 - (397 + 86)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v110 and v94.RadiantSpark:IsAvailable() and v107) or ((2036 - (423 + 453)) <= (34 + 294))) then
					local v214 = 0 + 0;
					while true do
						if (((3325 + 483) > (2334 + 590)) and (v214 == (0 + 0))) then
							v27 = v123();
							if (((5081 - (50 + 1140)) < (4252 + 667)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 >= v104) or (v102 >= v104))) or ((1319 + 915) <= (94 + 1408))) then
					local v215 = 0 - 0;
					while true do
						if ((v215 == (0 + 0)) or ((3108 - (157 + 439)) < (750 - 318))) then
							v27 = v126();
							if (v27 or ((6140 - 4292) == (2558 - 1693))) then
								return v27;
							end
							break;
						end
					end
				end
				v144 = 921 - (782 + 136);
			end
			if (((858 - (112 + 743)) == v144) or ((5853 - (1026 + 145)) <= (780 + 3761))) then
				if ((v30 and v110 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 < v104) or (v102 < v104))) or ((3744 - (493 + 225)) >= (14871 - 10825))) then
					v27 = v125();
					if (((1222 + 786) > (1710 - 1072)) and v27) then
						return v27;
					end
				end
				if (((34 + 1741) <= (9239 - 6006)) and ((v101 >= v104) or (v102 >= v104))) then
					local v216 = 0 + 0;
					while true do
						if ((v216 == (0 - 0)) or ((6138 - (210 + 1385)) == (3686 - (1201 + 488)))) then
							v27 = v128();
							if (v27 or ((1923 + 1179) < (1294 - 566))) then
								return v27;
							end
							break;
						end
					end
				end
				if (((618 - 273) == (930 - (352 + 233))) and ((v101 < v104) or (v102 < v104))) then
					local v217 = 0 - 0;
					while true do
						if ((v217 == (0 + 0)) or ((8037 - 5210) < (952 - (489 + 85)))) then
							v27 = v127();
							if (v27 or ((4977 - (277 + 1224)) < (4090 - (663 + 830)))) then
								return v27;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v145 = 0 + 0;
		while true do
			if (((7539 - 4460) < (5669 - (461 + 414))) and (v145 == (2 + 4))) then
				v62 = EpicSettings.Settings['useMassBarrier'];
				v63 = EpicSettings.Settings['useMirrorImage'];
				v64 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
				v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v145 = 257 - (172 + 78);
			end
			if (((7826 - 2972) > (1643 + 2821)) and (v145 == (9 - 2))) then
				v67 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v70 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v89 = EpicSettings.Settings['useSpellStealTarget'];
				v145 = 3 + 5;
			end
			if ((v145 == (3 + 2)) or ((1749 + 3163) == (14959 - 11201))) then
				v57 = EpicSettings.Settings['useAlterTime'];
				v58 = EpicSettings.Settings['usePrismaticBarrier'];
				v59 = EpicSettings.Settings['useGreaterInvisibility'];
				v60 = EpicSettings.Settings['useIceBlock'];
				v61 = EpicSettings.Settings['useIceCold'];
				v145 = 13 - 7;
			end
			if (((39 + 87) <= (1989 + 1493)) and (v145 == (449 - (133 + 314)))) then
				v43 = EpicSettings.Settings['usePresenceOfMind'];
				v92 = EpicSettings.Settings['cancelPOM'];
				v44 = EpicSettings.Settings['useCounterspell'];
				v45 = EpicSettings.Settings['useBlastWave'];
				v46 = EpicSettings.Settings['useDragonsBreath'];
				v145 = 1 + 2;
			end
			if ((v145 == (216 - (199 + 14))) or ((8498 - 6124) == (5923 - (647 + 902)))) then
				v47 = EpicSettings.Settings['useArcaneSurge'];
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['useArcaneOrb'];
				v50 = EpicSettings.Settings['useRadiantSpark'];
				v51 = EpicSettings.Settings['useTouchOfTheMagi'];
				v145 = 11 - 7;
			end
			if (((1808 - (85 + 148)) == (2864 - (426 + 863))) and (v145 == (18 - 14))) then
				v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v145 = 1659 - (873 + 781);
			end
			if ((v145 == (10 - 2)) or ((6032 - 3798) == (603 + 852))) then
				v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v91 = EpicSettings.Settings['mirrorImageBeforePull'];
				v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v145 == (0 - 0)) or ((1529 - 462) > (5282 - 3503))) then
				v33 = EpicSettings.Settings['useArcaneBlast'];
				v34 = EpicSettings.Settings['useArcaneBarrage'];
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneFamiliar'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v145 = 1948 - (414 + 1533);
			end
			if (((1874 + 287) >= (1489 - (443 + 112))) and (v145 == (1480 - (888 + 591)))) then
				v38 = EpicSettings.Settings['useArcaneMissiles'];
				v39 = EpicSettings.Settings['useConjureManaGem'];
				v40 = EpicSettings.Settings['useEvocation'];
				v41 = EpicSettings.Settings['useManaGem'];
				v42 = EpicSettings.Settings['useNetherTempest'];
				v145 = 5 - 3;
			end
		end
	end
	local function v131()
		local v146 = 0 + 0;
		while true do
			if (((6071 - 4459) == (630 + 982)) and ((1 + 1) == v146)) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v146 = 1 + 2;
			end
			if (((8292 - 3940) >= (5247 - 2414)) and (v146 == (1678 - (136 + 1542)))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v146 = 1 + 0;
			end
			if ((v146 == (7 - 2)) or ((2332 + 890) < (3559 - (68 + 418)))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2016 - 1272) <= (5337 - 2395)) and (v146 == (3 + 0))) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v146 = 1096 - (770 + 322);
			end
			if ((v146 == (1 + 3)) or ((531 + 1302) <= (181 + 1141))) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v146 = 13 - 8;
			end
			if ((v146 == (3 - 2)) or ((1932 + 1535) <= (1580 - 525))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v146 = 1 + 1;
			end
		end
	end
	local function v132()
		v130();
		v131();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['minicds'];
		v32 = EpicSettings.Toggles['dispel'];
		if (((2171 + 1370) == (2775 + 766)) and v13:IsDeadOrGhost()) then
			return v27;
		end
		v100 = v14:GetEnemiesInSplashRange(18 - 13);
		v103 = v13:GetEnemiesInRange(55 - 15);
		if (v29 or ((1203 + 2354) >= (18439 - 14436))) then
			local v157 = 0 - 0;
			while true do
				if ((v157 == (0 + 0)) or ((3251 - 2594) >= (2499 - (762 + 69)))) then
					v101 = v26(v14:GetEnemiesInSplashRangeCount(16 - 11), #v103);
					v102 = #v103;
					break;
				end
			end
		else
			v101 = 1 + 0;
			v102 = 1 + 0;
		end
		if (v98.TargetIsValid() or v13:AffectingCombat() or ((2483 - 1456) > (1214 + 2644))) then
			local v158 = 0 + 0;
			while true do
				if ((v158 == (0 - 0)) or ((3811 - (8 + 149)) < (1770 - (1199 + 121)))) then
					if (((3199 - 1308) < (10052 - 5599)) and (v13:AffectingCombat() or v72)) then
						local v219 = v72 and v94.RemoveCurse:IsReady() and v32;
						v27 = v98.FocusUnit(v219, nil, 9 + 11, nil, 71 - 51, v94.ArcaneIntellect);
						if (v27 or ((7286 - 4146) < (1884 + 245))) then
							return v27;
						end
					end
					v113 = v10.BossFightRemains(nil, true);
					v158 = 1808 - (518 + 1289);
				end
				if ((v158 == (1 - 0)) or ((340 + 2215) < (1811 - 571))) then
					v114 = v113;
					if ((v114 == (8184 + 2927)) or ((5196 - (304 + 165)) <= (4458 + 264))) then
						v114 = v10.FightRemains(v103, false);
					end
					break;
				end
			end
		end
		v115 = v13:GCD();
		if (((900 - (54 + 106)) < (6906 - (1618 + 351))) and v73) then
			if (((2580 + 1078) >= (1296 - (10 + 1006))) and v93) then
				v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 8 + 22);
				if (v27 or ((124 + 761) >= (3342 - 2311))) then
					return v27;
				end
			end
		end
		if (((4587 - (912 + 121)) >= (249 + 276)) and (not v13:AffectingCombat() or v28)) then
			if (((3703 - (1140 + 149)) <= (1902 + 1070)) and v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) then
				if (((4703 - 1174) <= (658 + 2880)) and v21(v94.ArcaneIntellect)) then
					return "arcane_intellect group_buff";
				end
			end
			if ((v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) or ((9791 - 6930) < (858 - 400))) then
				if (((297 + 1420) <= (15702 - 11177)) and v21(v94.ArcaneFamiliar)) then
					return "arcane_familiar precombat 2";
				end
			end
			if ((v94.ConjureManaGem:IsCastable() and v39) or ((3364 - (165 + 21)) <= (1635 - (61 + 50)))) then
				if (((1753 + 2501) > (1763 - 1393)) and v21(v94.ConjureManaGem)) then
					return "conjure_mana_gem precombat 4";
				end
			end
		end
		if (v98.TargetIsValid() or ((3294 - 1659) == (699 + 1078))) then
			local v159 = 1460 - (1295 + 165);
			while true do
				if ((v159 == (1 + 2)) or ((1343 + 1995) >= (5390 - (819 + 578)))) then
					if (((2556 - (331 + 1071)) <= (2218 - (588 + 155))) and v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) then
						if (v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal)) or ((3892 - (546 + 736)) < (3167 - (1834 + 103)))) then
							return "spellsteal damage";
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) or ((891 + 557) == (9196 - 6113))) then
						if (((4905 - (1536 + 230)) > (1407 - (128 + 363))) and v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) then
							if (((628 + 2326) == (7348 - 4394)) and v21(v96.UseWeapon, nil)) then
								return "Using Weapon Macro";
							end
						end
						local v220 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
						if (((31 + 86) <= (4790 - 1898)) and v220) then
							return v220;
						end
						if ((v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes)) or ((1333 - 880) > (11323 - 6661))) then
							if (((906 + 414) > (1604 - (615 + 394))) and v21(v94.IceFloes)) then
								return "ice_floes movement";
							end
						end
						if ((v90 and v94.TimeWarp:IsReady() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v114 <= (37 + 3)) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v114 <= (v94.ArcaneSurge:CooldownRemains() + 14 + 0))))) or ((9751 - 6552) < (2676 - 2086))) then
							if (v21(v94.TimeWarp, not v14:IsInRange(691 - (59 + 592))) or ((10611 - 5818) < (55 - 25))) then
								return "time_warp main 4";
							end
						end
						if ((v80 and ((v83 and v30) or not v83) and (v78 < v114)) or ((1196 + 500) <= (1230 - (70 + 101)))) then
							local v221 = 0 - 0;
							while true do
								if (((1662 + 681) == (5884 - 3541)) and (v221 == (242 - (123 + 118)))) then
									if (v13:PrevGCDP(1 + 0, v94.ArcaneSurge) or ((13 + 1030) > (4990 - (653 + 746)))) then
										local v224 = 0 - 0;
										while true do
											if ((v224 == (1 - 0)) or ((7737 - 4847) >= (1800 + 2279))) then
												if (((2863 + 1611) <= (4167 + 603)) and v94.AncestralCall:IsCastable()) then
													if (v21(v94.AncestralCall) or ((606 + 4336) == (609 + 3294))) then
														return "ancestral_call main 14";
													end
												end
												break;
											end
											if ((v224 == (0 - 0)) or ((237 + 11) > (8950 - 4105))) then
												if (((2803 - (885 + 349)) == (1247 + 322)) and v94.BloodFury:IsCastable()) then
													if (v21(v94.BloodFury) or ((13436 - 8509) <= (9369 - 6148))) then
														return "blood_fury main 10";
													end
												end
												if (v94.Fireblood:IsCastable() or ((2748 - (915 + 53)) > (3588 - (768 + 33)))) then
													if (v21(v94.Fireblood) or ((15074 - 11137) <= (2165 - 935))) then
														return "fireblood main 12";
													end
												end
												v224 = 329 - (287 + 41);
											end
										end
									end
									break;
								end
								if ((v221 == (847 - (638 + 209))) or ((1371 + 1266) < (3392 - (96 + 1590)))) then
									if ((v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (1674 - (741 + 931))) or (v102 >= (1 + 1)))) or ((7603 - 4934) <= (11254 - 8845))) then
										if (v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment)) or ((602 + 799) > (2018 + 2678))) then
											return "lights_judgment main 6";
										end
									end
									if ((v94.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) or ((12446 - 9166) < (430 + 891))) then
										if (((2406 + 2521) >= (9394 - 7091)) and v21(v94.Berserking)) then
											return "berserking main 8";
										end
									end
									v221 = 1 + 0;
								end
							end
						end
						if (((3956 - (64 + 430)) >= (1024 + 8)) and (v78 < v114)) then
							if ((v81 and ((v30 and v82) or not v82)) or ((1440 - (106 + 257)) >= (1426 + 585))) then
								local v223 = 721 - (496 + 225);
								while true do
									if (((3155 - 1612) < (11764 - 9349)) and ((1658 - (256 + 1402)) == v223)) then
										v27 = v119();
										if (v27 or ((6343 - (30 + 1869)) < (3384 - (213 + 1156)))) then
											return v27;
										end
										break;
									end
								end
							end
						end
						v27 = v121();
						if (v27 or ((4388 - (96 + 92)) == (398 + 1934))) then
							return v27;
						end
						v27 = v129();
						if (v27 or ((2177 - (142 + 757)) >= (1073 + 243))) then
							return v27;
						end
					end
					break;
				end
				if (((443 + 639) == (1161 - (32 + 47))) and (v159 == (1977 - (1053 + 924)))) then
					if (((1301 + 27) <= (8401 - 3523)) and v72 and v32 and v94.RemoveCurse:IsAvailable()) then
						if (((5735 - (685 + 963)) >= (2755 - 1400)) and v15) then
							local v222 = 0 - 0;
							while true do
								if ((v222 == (1709 - (541 + 1168))) or ((2187 - (645 + 952)) > (5488 - (669 + 169)))) then
									v27 = v118();
									if (v27 or ((13073 - 9299) <= (7962 - 4295))) then
										return v27;
									end
									break;
								end
							end
						end
						if (((429 + 841) < (474 + 1672)) and v16 and v16:Exists() and not v13:CanAttack(v16) and v98.UnitHasCurseDebuff(v16)) then
							if (((5328 - (181 + 584)) >= (1451 - (665 + 730))) and v94.RemoveCurse:IsReady()) then
								if (v21(v96.RemoveCurseMouseover) or ((1285 - 839) == (1267 - 645))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if (((3419 - (540 + 810)) > (4034 - 3025)) and not v13:AffectingCombat() and v28) then
						v27 = v120();
						if (((32 - 20) < (3349 + 859)) and v27) then
							return v27;
						end
					end
					v159 = 204 - (166 + 37);
				end
				if ((v159 == (1883 - (22 + 1859))) or ((4762 - (843 + 929)) <= (3242 - (30 + 232)))) then
					if (v73 or ((7354 - 4779) >= (5052 - (55 + 722)))) then
						if (v93 or ((7783 - 4157) <= (2981 - (78 + 1597)))) then
							v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 7 + 23);
							if (((1245 + 123) < (3165 + 615)) and v27) then
								return v27;
							end
						end
					end
					if (v74 or ((3718 - (305 + 244)) == (2109 + 164))) then
						v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 135 - (95 + 10));
						if (((1757 + 724) <= (10390 - 7111)) and v27) then
							return v27;
						end
					end
					v159 = 3 - 0;
				end
				if ((v159 == (763 - (592 + 170))) or ((3707 - 2644) <= (2202 - 1325))) then
					v27 = v116();
					if (((1079 + 1235) == (901 + 1413)) and v27) then
						return v27;
					end
					v159 = 4 - 2;
				end
			end
		end
	end
	local function v133()
		local v152 = 0 + 0;
		while true do
			if (((1711 - 787) >= (984 - (353 + 154))) and ((0 - 0) == v152)) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(84 - 22, v132, v133);
end;
return v0["Epix_Mage_Arcane.lua"]();

