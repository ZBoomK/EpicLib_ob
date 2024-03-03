local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 554 - (419 + 135);
	local v6;
	while true do
		if (((219 + 906) <= (1133 + 943)) and (v5 == (1069 - (566 + 502)))) then
			return v6(...);
		end
		if ((v5 == (297 - (45 + 252))) or ((736 + 7) >= (1514 + 2885))) then
			v6 = v0[v4];
			if (((2810 - 1655) < (2106 - (114 + 319))) and not v6) then
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
	local v93;
	local v94 = v17.Mage.Arcane;
	local v95 = v18.Mage.Arcane;
	local v96 = v22.Mage.Arcane;
	local v97 = {};
	local v98 = v19.Commons.Everyone;
	local function v99()
		if (v94.RemoveCurse:IsAvailable() or ((2977 - 653) <= (369 + 209))) then
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
	local v104 = 4 - 1;
	local v105 = false;
	local v106 = false;
	local v107 = false;
	local v108 = true;
	local v109 = false;
	local v110 = v13:HasTier(60 - 31, 1967 - (556 + 1407));
	local v111 = (226206 - (741 + 465)) - (((25465 - (170 + 295)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((105379 + 94621) * v24(not v110)));
	local v112 = 3 + 0;
	local v113 = 27355 - 16244;
	local v114 = 9211 + 1900;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if (((2134 + 1633) == (4997 - (957 + 273))) and (v134 == (0 + 0))) then
				v105 = false;
				v108 = true;
				v134 = 1 + 0;
			end
			if (((15580 - 11491) == (10775 - 6686)) and (v134 == (5 - 3))) then
				v114 = 55018 - 43907;
				break;
			end
			if (((6238 - (389 + 1391)) >= (1051 + 623)) and (v134 == (1 + 0))) then
				v111 = (512238 - 287238) - (((25951 - (783 + 168)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((671239 - 471239) * v24(not v110)));
				v113 = 10930 + 181;
				v134 = 313 - (309 + 2);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v110 = not v13:HasTier(88 - 59, 1216 - (1090 + 122));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v116()
		local v135 = 0 + 0;
		while true do
			if (((3264 - 2292) <= (971 + 447)) and (v135 == (1121 - (628 + 490)))) then
				if ((v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((886 + 4052) < (11789 - 7027))) then
					if (v21(v94.AlterTime) or ((11443 - 8939) > (5038 - (431 + 343)))) then
						return "alter_time defensive 6";
					end
				end
				if (((4348 - 2195) == (6228 - 4075)) and v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) then
					if (v21(v96.Healthstone) or ((401 + 106) >= (332 + 2259))) then
						return "healthstone defensive";
					end
				end
				v135 = 1699 - (556 + 1139);
			end
			if (((4496 - (6 + 9)) == (821 + 3660)) and (v135 == (2 + 0))) then
				if ((v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((2497 - (28 + 141)) < (269 + 424))) then
					if (((5341 - 1013) == (3066 + 1262)) and v21(v94.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if (((2905 - (486 + 831)) >= (3466 - 2134)) and v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) then
					if (v21(v94.GreaterInvisibility) or ((14694 - 10520) > (803 + 3445))) then
						return "greater_invisibility defensive 5";
					end
				end
				v135 = 9 - 6;
			end
			if ((v135 == (1264 - (668 + 595))) or ((4127 + 459) <= (17 + 65))) then
				if (((10534 - 6671) == (4153 - (23 + 267))) and v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
					if (v21(v94.IceBlock) or ((2226 - (1129 + 815)) <= (429 - (371 + 16)))) then
						return "ice_block defensive 3";
					end
				end
				if (((6359 - (1326 + 424)) >= (1450 - 684)) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (v21(v94.IceColdAbility) or ((4209 - 3057) == (2606 - (88 + 30)))) then
						return "ice_cold defensive 3";
					end
				end
				v135 = 773 - (720 + 51);
			end
			if (((7612 - 4190) > (5126 - (421 + 1355))) and (v135 == (0 - 0))) then
				if (((431 + 446) > (1459 - (286 + 797))) and v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) then
					if (v21(v94.PrismaticBarrier) or ((11398 - 8280) <= (3065 - 1214))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 441 - (397 + 42), v94.ArcaneIntellect)) or ((52 + 113) >= (4292 - (24 + 776)))) then
					if (((6083 - 2134) < (5641 - (222 + 563))) and v21(v94.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 1 - 0;
			end
			if ((v135 == (3 + 1)) or ((4466 - (23 + 167)) < (4814 - (690 + 1108)))) then
				if (((1693 + 2997) > (3403 + 722)) and v84 and (v13:HealthPercentage() <= v86)) then
					local v208 = 848 - (40 + 808);
					while true do
						if ((v208 == (0 + 0)) or ((191 - 141) >= (857 + 39))) then
							if ((v88 == "Refreshing Healing Potion") or ((907 + 807) >= (1623 + 1335))) then
								if (v95.RefreshingHealingPotion:IsReady() or ((2062 - (47 + 524)) < (418 + 226))) then
									if (((1924 - 1220) < (1475 - 488)) and v21(v96.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((8479 - 4761) > (3632 - (1165 + 561))) and (v88 == "Dreamwalker's Healing Potion")) then
								if (v95.DreamwalkersHealingPotion:IsReady() or ((29 + 929) > (11258 - 7623))) then
									if (((1336 + 2165) <= (4971 - (341 + 138))) and v21(v96.RefreshingHealingPotion)) then
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
		end
	end
	local v117 = 0 + 0;
	local function v118()
		if ((v94.RemoveCurse:IsReady() and v98.DispellableFriendlyUnit(41 - 21)) or ((3768 - (89 + 237)) < (8196 - 5648))) then
			local v152 = 0 - 0;
			while true do
				if (((3756 - (581 + 300)) >= (2684 - (855 + 365))) and (v152 == (0 - 0))) then
					if ((v117 == (0 + 0)) or ((6032 - (1030 + 205)) >= (4594 + 299))) then
						v117 = GetTime();
					end
					if (v98.Wait(466 + 34, v117) or ((837 - (156 + 130)) > (4698 - 2630))) then
						local v218 = 0 - 0;
						while true do
							if (((4329 - 2215) > (249 + 695)) and (v218 == (0 + 0))) then
								if (v21(v96.RemoveCurseFocus) or ((2331 - (10 + 59)) >= (876 + 2220))) then
									return "remove_curse dispel";
								end
								v117 = 0 - 0;
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
		local v136 = 1163 - (671 + 492);
		while true do
			if ((v136 == (0 + 0)) or ((3470 - (369 + 846)) >= (937 + 2600))) then
				v27 = v98.HandleTopTrinket(v97, v30, 35 + 5, nil);
				if (v27 or ((5782 - (1036 + 909)) < (1039 + 267))) then
					return v27;
				end
				v136 = 1 - 0;
			end
			if (((3153 - (11 + 192)) == (1491 + 1459)) and ((176 - (135 + 40)) == v136)) then
				v27 = v98.HandleBottomTrinket(v97, v30, 96 - 56, nil);
				if (v27 or ((2847 + 1876) < (7265 - 3967))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v120()
		if (((1702 - 566) >= (330 - (50 + 126))) and v94.MirrorImage:IsCastable() and v91 and v63) then
			if (v21(v94.MirrorImage) or ((754 - 483) > (1051 + 3697))) then
				return "mirror_image precombat 2";
			end
		end
		if (((6153 - (1233 + 180)) >= (4121 - (522 + 447))) and v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((3999 - (107 + 1314)) >= (1574 + 1816))) then
				return "arcane_blast precombat 4";
			end
		end
		if (((124 - 83) <= (706 + 955)) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
			if (((1193 - 592) < (14085 - 10525)) and v21(v94.Evocation)) then
				return "evocation precombat 6";
			end
		end
		if (((2145 - (716 + 1194)) < (12 + 675)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) then
			if (((488 + 4061) > (1656 - (74 + 429))) and v21(v94.ArcaneOrb, not v14:IsInRange(77 - 37))) then
				return "arcane_orb precombat 8";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33) or ((2317 + 2357) < (10694 - 6022))) then
			if (((2596 + 1072) < (14061 - 9500)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v121()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (434 - (279 + 154))) or ((1233 - (454 + 324)) == (2837 + 768))) then
				if ((v14:DebuffUp(v94.TouchoftheMagiDebuff) and v108) or ((2680 - (12 + 5)) == (1786 + 1526))) then
					v108 = false;
				end
				v109 = v94.ArcaneBlast:CastTime() < v115;
				break;
			end
			if (((10897 - 6620) <= (1654 + 2821)) and (v137 == (1093 - (277 + 816)))) then
				if ((((v101 >= v104) or (v102 >= v104)) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (1186 - (1058 + 125)))) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1 + 1)))) or ((1845 - (815 + 160)) == (5101 - 3912))) then
					v106 = true;
				elseif (((3686 - 2133) <= (748 + 2385)) and v106 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (20 - 13)) and v94.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				if (((v13:ArcaneCharges() > (1901 - (41 + 1857))) and ((v101 < v104) or (v102 < v104)) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1900 - (1222 + 671)))) and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * (12 - 7))) or (v94.ArcaneSurge:CooldownRemains() > (57 - 17)))) or ((3419 - (229 + 953)) >= (5285 - (1111 + 663)))) then
					v107 = true;
				elseif ((v107 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (1586 - (874 + 705))) and v94.RadiantSpark:CooldownDown()) or ((186 + 1138) > (2061 + 959))) then
					v107 = false;
				end
				v137 = 1 - 0;
			end
		end
	end
	local function v122()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (680 - (642 + 37))) or ((683 + 2309) == (301 + 1580))) then
				if (((7798 - 4692) > (1980 - (233 + 221))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and v94.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (((6990 - 3967) < (3407 + 463)) and v21(v94.ArcaneOrb, not v14:IsInRange(1581 - (718 + 823)))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if (((90 + 53) > (879 - (266 + 539))) and v94.ArcaneBlast:IsReady() and v33 and v94.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (5 - 3)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v94.ArcaneOrb:CooldownRemains() >= v115)))) then
					if (((1243 - (636 + 589)) < (5013 - 2901)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((2262 - 1165) <= (1291 + 337)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and (v13:ManaPercentage() > (1045 - (657 + 358))) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (((12259 - 7629) == (10548 - 5918)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				v138 = 1189 - (1151 + 36);
			end
			if (((3419 + 121) > (706 + 1977)) and (v138 == (0 - 0))) then
				if (((6626 - (1552 + 280)) >= (4109 - (64 + 770))) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) then
					if (((3368 - 1884) == (264 + 1220)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((2675 - (157 + 1086)) < (7115 - 3560)) and v94.RadiantSpark:CooldownUp()) then
					v105 = v94.ArcaneSurge:CooldownRemains() < (43 - 33);
				end
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) or ((1633 - 568) > (4883 - 1305))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(859 - (599 + 220)), true) or ((9548 - 4753) < (3338 - (1813 + 118)))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				v138 = 1 + 0;
			end
			if (((3070 - (841 + 376)) < (6743 - 1930)) and ((2 + 3) == v138)) then
				if ((v94.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v94.RadiantSparkVulnerability) and (v14:DebuffStack(v94.RadiantSparkVulnerability) < (10 - 6))) or ((3680 - (464 + 395)) < (6238 - 3807))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((1381 + 1493) < (3018 - (467 + 370)))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if ((v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((5556 - 2867) <= (252 + 91))) then
					if (v21(v94.PresenceofMind) or ((6406 - 4537) == (314 + 1695))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.PresenceofMindBuff))) or ((8249 - 4703) < (2842 - (150 + 370)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((3364 - (74 + 1208)) == (11739 - 6966))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				v138 = 28 - 22;
			end
			if (((2309 + 935) > (1445 - (14 + 376))) and (v138 == (6 - 2))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (20 + 10)) and (v94.ArcaneEcho:IsAvailable())) or ((2911 + 402) <= (1696 + 82))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((4163 - 2742) >= (1583 + 521))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((1890 - (23 + 55)) <= (7699 - 4450)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
					if (((1084 + 539) <= (1758 + 199)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if (((6840 - 2428) == (1388 + 3024)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(902 - (652 + 249), v94.ArcaneSurge) or v13:PrevGCDP(2 - 1, v94.NetherTempest) or v13:PrevGCDP(1869 - (708 + 1160), v94.RadiantSpark))) then
					if (((4750 - 3000) >= (1534 - 692)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				v138 = 32 - (10 + 17);
			end
			if (((982 + 3390) > (3582 - (1400 + 332))) and (v138 == (5 - 2))) then
				if (((2140 - (242 + 1666)) < (352 + 469)) and v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (6 + 9)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (5 + 0)))) and (v94.ArcaneSurge:CooldownRemains() < (970 - (850 + 90)))) then
					if (((906 - 388) < (2292 - (360 + 1030))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if (((2650 + 344) > (2421 - 1563)) and v94.ArcaneMissiles:IsReady() and v38 and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < v115)) and v13:HasTier(41 - 11, 1665 - (909 + 752))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4978 - (109 + 1114)) <= (1675 - 760))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if (((1537 + 2409) > (3985 - (6 + 236))) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), true) or ((842 + 493) >= (2662 + 644))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v138 = 8 - 4;
			end
			if (((8460 - 3616) > (3386 - (1076 + 57))) and (v138 == (1 + 1))) then
				if (((1141 - (579 + 110)) == (36 + 416)) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (5 + 0)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (4 + 2)))) and v13:HasTier(438 - (174 + 233), 11 - 7)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((7997 - 3440) < (929 + 1158))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((5048 - (663 + 511)) == (3457 + 417)) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (4 + 13)) and not v13:HasTier(92 - 62, 3 + 1)) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((4562 - 2624) > (11946 - 7011))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (1 + 1)) and (v94.RadiantSpark:CooldownRemains() < (9 - 4)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (5 + 1)))) and not v13:HasTier(3 + 27, 726 - (478 + 244))) or ((4772 - (440 + 77)) < (1557 + 1866))) then
					if (((5321 - 3867) <= (4047 - (655 + 901))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				v138 = 1 + 2;
			end
			if (((5 + 1) == v138) or ((2807 + 1350) <= (11292 - 8489))) then
				if (((6298 - (695 + 750)) >= (10182 - 7200)) and v94.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (6 - 2)) and v13:PrevGCDP(3 - 2, v94.ArcaneBlast)))) then
					if (((4485 - (285 + 66)) > (7824 - 4467)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((4727 - (682 + 628)) < (409 + 2125))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((3021 - (176 + 123)) <= (69 + 95))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (269 - (239 + 30))) or ((655 + 1753) < (2028 + 81))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (79 - 34)) and v14:DebuffDown(v94.NetherTempestDebuff) and v108 and v13:BloodlustUp()) or ((102 - 69) == (1770 - (306 + 9)))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((1545 - 1102) >= (699 + 3316))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((2076 + 1306) > (80 + 86)) and v108 and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((1655 - (1140 + 235)) == (1947 + 1112))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((1725 + 156) > (332 + 961)) and v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (57 - (33 + 19))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (3 + 3)))) and v13:HasTier(92 - 61, 2 + 2)) then
					if (((4622 - 2265) == (2211 + 146)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if (((812 - (586 + 103)) == (12 + 111)) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (46 - 31))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((2544 - (1309 + 179)) >= (6122 - 2730))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (2 - 1)) or ((817 + 264) < (2284 - 1209))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (3 - 1)) and (v94.RadiantSpark:CooldownRemains() < (614 - (295 + 314))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (14 - 8)))) or ((3011 - (1300 + 662)) >= (13917 - 9485))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((6523 - (1178 + 577)) <= (440 + 406))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (44 - 29)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1410 - (851 + 554))))) and (v94.ArcaneSurge:CooldownRemains() < (27 + 3))) or ((9312 - 5954) <= (3084 - 1664))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4041 - (115 + 187)) <= (2302 + 703))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((1571 + 88) >= (8409 - 6275))) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark)) or ((4421 - (160 + 1001)) < (2061 + 294))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if ((v94.NetherTempest:IsReady() and v42 and not v109 and (v94.NetherTempest:TimeSinceLastCast() >= (11 + 4)) and ((not v109 and v13:PrevGCDP(7 - 3, v94.RadiantSpark) and (v94.ArcaneSurge:CooldownRemains() <= v94.NetherTempest:ExecuteTime())) or v13:PrevGCDP(363 - (237 + 121), v94.RadiantSpark))) or ((1566 - (525 + 372)) == (8005 - 3782))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((5558 - 3866) < (730 - (96 + 46)))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v139 = 779 - (643 + 134);
			end
			if ((v139 == (2 + 1)) or ((11502 - 6705) < (13554 - 9903))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((4006 + 171) > (9518 - 4668))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((817 - 417) > (1830 - (316 + 403)))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if (((2028 + 1023) > (2763 - 1758)) and v94.ArcaneBarrage:IsReady() and v34) then
					if (((1335 + 2358) <= (11035 - 6653)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if ((v139 == (2 + 0)) or ((1058 + 2224) > (14206 - 10106))) then
				if ((v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114) and ((not v94.NetherTempest:IsAvailable() and ((v13:PrevGCDP(19 - 15, v94.RadiantSpark) and not v109) or v13:PrevGCDP(10 - 5, v94.RadiantSpark))) or v13:PrevGCDP(1 + 0, v94.NetherTempest))) or ((7047 - 3467) < (139 + 2705))) then
					if (((261 - 172) < (4507 - (12 + 5))) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v94.ArcaneBlast:CastTime() >= v13:GCD()) and (v94.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v94.RadiantSparkVulnerability)) and (not v94.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (135 - 100))) and ((v94.NetherTempest:IsAvailable() and v13:PrevGCDP(12 - 6, v94.RadiantSpark)) or (not v94.NetherTempest:IsAvailable() and v13:PrevGCDP(10 - 5, v94.RadiantSpark))) and not (v13:IsCasting(v94.ArcaneSurge) and (v13:CastRemains() < (0.5 - 0)) and not v109)) or ((1012 + 3971) < (3781 - (1656 + 317)))) then
					if (((3413 + 416) > (3021 + 748)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((3948 - 2463) <= (14292 - 11388)) and v94.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (358 - (5 + 349)))) then
					if (((20277 - 16008) == (5540 - (266 + 1005))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((256 + 131) <= (9492 - 6710)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and v13:PrevGCDP(1 - 0, v94.ArcaneBarrage) and ((v94.ArcaneBarrage:InFlight() and ((v94.ArcaneBarrage:TravelTime() - v94.ArcaneBarrage:TimeSinceLastCast()) <= (1696.2 - (561 + 1135)))) or (v13:GCDRemains() <= (0.2 - 0)))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((6242 - 4343) <= (1983 - (507 + 559)))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v139 = 7 - 4;
			end
		end
	end
	local function v124()
		if ((v13:BuffUp(v94.PresenceofMindBuff) and v92 and (v13:PrevGCDP(3 - 2, v94.ArcaneBlast)) and (v94.ArcaneSurge:CooldownRemains() > (463 - (212 + 176)))) or ((5217 - (250 + 655)) <= (2388 - 1512))) then
			if (((3899 - 1667) <= (4061 - 1465)) and v21(v96.CancelPOM)) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if (((4051 - (1869 + 87)) < (12784 - 9098)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1902 - (484 + 1417), v94.ArcaneBarrage))) then
			if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((3418 - 1823) >= (7497 - 3023))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((5392 - (48 + 725)) < (4707 - 1825))) then
			if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), true) or ((788 - 494) >= (2808 + 2023))) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if (((5422 - 3393) <= (864 + 2220)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v94.ArcaneOrb:TimeSinceLastCast() >= (5 + 10)) and (v13:ArcaneCharges() < (856 - (152 + 701)))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(1351 - (430 + 881))) or ((781 + 1256) == (3315 - (557 + 338)))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if (((1318 + 3140) > (11001 - 7097)) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (52 - 37)) and (v94.ArcaneEcho:IsAvailable())) then
			if (((1158 - 722) >= (264 - 141)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((1301 - (499 + 302)) < (2682 - (39 + 827))) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
			if (((9866 - 6292) == (7981 - 4407)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if (((877 - 656) < (598 - 208)) and v94.ArcaneBarrage:IsReady() and v34 and (v94.ArcaneSurge:CooldownRemains() < (7 + 68)) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (11 - 7)) and not v94.OrbBarrage:IsAvailable()) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((355 + 1858) <= (2248 - 827))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if (((3162 - (103 + 1)) < (5414 - (475 + 79))) and v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 2)) and (v94.ArcaneSurge:CooldownRemains() > (240 - 165))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (67 + 8)) and not v94.OrbBarrage:IsAvailable()))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((2799 - (1395 + 108)) >= (12937 - 8491))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1205 - (7 + 1197))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 1)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 + 1)) and ((v101 > (324 - (27 + 292))) or (v102 > (14 - 9)))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 0))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable()) or ((5841 - 4448) > (8852 - 4363))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((8425 - 4001) < (166 - (43 + 96)))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if ((v94.PresenceofMind:IsCastable() and v43) or ((8145 - 6148) > (8625 - 4810))) then
			if (((2876 + 589) > (541 + 1372)) and v21(v94.PresenceofMind)) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if (((1448 - 715) < (698 + 1121)) and v94.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (3 - 1)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 2))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable()))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((323 + 4072) == (6506 - (1414 + 337)))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1944 - (1642 + 298))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (7 - 4)) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) or ((10911 - 7118) < (7029 - 4660))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1345 + 2739) == (207 + 58))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v125()
		local v140 = 972 - (357 + 615);
		while true do
			if (((3060 + 1298) == (10693 - 6335)) and (v140 == (1 + 0))) then
				if ((v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((6724 - 3586) < (795 + 198))) then
					if (((227 + 3103) > (1461 + 862)) and v21(v94.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((4927 - (384 + 917)) == (4686 - (128 + 569)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((2459 - (1407 + 136)) == (4558 - (687 + 1200)))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if (((1982 - (556 + 1154)) == (956 - 684)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v94.ArcaneHarmonyBuff) or (v94.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (130 - (9 + 86))))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (((4670 - (275 + 146)) <= (787 + 4052)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v140 = 66 - (29 + 35);
			end
			if (((12307 - 9530) < (9558 - 6358)) and (v140 == (8 - 6))) then
				if (((62 + 33) < (2969 - (53 + 959))) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (408 - (312 + 96))) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (52 - 22)) and (v94.TouchoftheMagi:CooldownRemains() > (315 - (147 + 138)))) or (v13:ManaPercentage() > (969 - (813 + 86)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (((747 + 79) < (3181 - 1464)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((1918 - (18 + 474)) >= (373 + 732)) and v94.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v94.ClearcastingBuff) > (3 - 2)) and v94.ConjureManaGem:IsAvailable() and v95.ManaGem:CooldownUp()) then
					if (((3840 - (860 + 226)) <= (3682 - (121 + 182))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.NetherPrecisionBuff))) or ((484 + 3443) == (2653 - (988 + 252)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((131 + 1023) <= (247 + 541))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v140 = 1973 - (49 + 1921);
			end
			if (((893 - (223 + 667)) == v140) or ((1695 - (51 + 1)) > (5815 - 2436))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > v94.ArcaneMissiles:CastTime()) or not v94.PresenceofMind:IsAvailable())) or ((6002 - 3199) > (5674 - (146 + 979)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((63 + 157) >= (3627 - (311 + 294)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((7869 - 5047) == (1196 + 1626)) and v94.ArcaneBlast:IsReady() and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((2504 - (496 + 947)) == (3215 - (1233 + 125)))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if (((1120 + 1640) > (1224 + 140)) and v94.ArcaneBarrage:IsReady() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((932 + 3970) <= (5240 - (963 + 682)))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if ((v140 == (0 + 0)) or ((5356 - (504 + 1000)) == (198 + 95))) then
				if ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (9 + 0)) or ((148 + 1411) == (6765 - 2177))) then
					v105 = not v105;
				end
				if ((v94.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v94.NetherTempestDebuff) or not v14:DebuffUp(v94.NetherTempestDebuff)) and (v13:ArcaneCharges() == (4 + 0)) and (v13:ManaPercentage() < (18 + 12)) and (v13:SpellHaste() < (182.667 - (156 + 26))) and v13:BuffDown(v94.ArcaneSurgeBuff)) or ((2584 + 1900) == (1232 - 444))) then
					if (((4732 - (149 + 15)) >= (4867 - (890 + 70))) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((1363 - (39 + 78)) < (3952 - (14 + 468))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (4 - 2)) and (v13:ManaPercentage() < (83 - 53)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) then
					if (((2443 + 1625) >= (207 + 765)) and v21(v94.ArcaneOrb, not v14:IsInRange(19 + 21))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v126()
		local v141 = 0 - 0;
		while true do
			if (((488 + 5) < (13679 - 9786)) and (v141 == (1 + 0))) then
				if ((v94.ArcaneBarrage:IsReady() and v34 and ((((v101 <= (55 - (12 + 39))) or (v102 <= (4 + 0))) and (v13:ArcaneCharges() == (9 - 6))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or ((5245 - 3772) >= (988 + 2344))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((2133 + 1918) <= (2933 - 1776))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if (((403 + 201) < (13923 - 11042)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (1712 - (1596 + 114)))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(104 - 64)) or ((1613 - (164 + 549)) == (4815 - (1059 + 379)))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v141 = 2 - 0;
			end
			if (((2311 + 2148) > (100 + 491)) and (v141 == (392 - (145 + 247)))) then
				if (((2789 + 609) >= (1107 + 1288)) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (26 - 17))) then
					v105 = not v105;
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff)) or ((419 + 1764) >= (2433 + 391))) then
					if (((3142 - 1206) == (2656 - (254 + 466))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v141 = 561 - (544 + 16);
			end
			if ((v141 == (5 - 3)) or ((5460 - (294 + 334)) < (4566 - (236 + 17)))) then
				if (((1763 + 2325) > (3016 + 858)) and v94.ArcaneExplosion:IsCastable() and v35) then
					if (((16314 - 11982) == (20509 - 16177)) and v21(v94.ArcaneExplosion, not v14:IsInRange(6 + 4))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
		end
	end
	local function v127()
		local v142 = 0 + 0;
		while true do
			if (((4793 - (413 + 381)) >= (123 + 2777)) and (v142 == (5 - 2))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffUp(v94.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((6558 - 4033) > (6034 - (582 + 1388)))) then
					if (((7447 - 3076) == (3129 + 1242)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) or ((630 - (326 + 38)) > (14749 - 9763))) then
					if (((2842 - 851) >= (1545 - (47 + 573))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 24";
					end
				end
				if (((161 + 294) < (8719 - 6666)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (97 - 37)) and v105 and (v94.TouchoftheMagi:CooldownRemains() > (1674 - (1269 + 395))) and (v94.Evocation:CooldownRemains() > (532 - (76 + 416))) and (v114 > (463 - (319 + 124)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1887 - 1061) == (5858 - (564 + 443)))) then
						return "arcane_barrage rotation 26";
					end
				end
				if (((506 - 323) == (641 - (337 + 121))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and (not v110 or not v108)) then
					if (((3395 - 2236) <= (5955 - 4167)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles rotation 30";
					end
				end
				v142 = 1915 - (1261 + 650);
			end
			if ((v142 == (2 + 2)) or ((5589 - 2082) > (6135 - (772 + 1045)))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((434 + 2641) <= (3109 - (102 + 42)))) then
					if (((3209 - (1524 + 320)) <= (3281 - (1049 + 221))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((2932 - (18 + 138)) > (8750 - 5175))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((3656 - (67 + 1035)) == (5152 - (136 + 212)))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((10950 - 8373) == (2065 + 512)) and (v142 == (0 + 0))) then
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (1607 - (240 + 1364))) and (v13:BloodlustDown() or (v13:ManaPercentage() > (1152 - (1050 + 32))) or (v110 and (v94.TouchoftheMagi:CooldownRemains() > (107 - 77))))) or ((4 + 2) >= (2944 - (331 + 724)))) then
					if (((41 + 465) <= (2536 - (269 + 375))) and v21(v94.ArcaneOrb, not v14:IsInRange(765 - (267 + 458)))) then
						return "arcane_orb rotation 2";
					end
				end
				v105 = ((v94.ArcaneSurge:CooldownRemains() > (10 + 20)) and (v94.TouchoftheMagi:CooldownRemains() > (19 - 9))) or false;
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v110 and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (830 - (667 + 151)))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (1509 - (1410 + 87)))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (1909 - (1504 + 393)))) and (v114 > (40 - 25))) or ((5209 - 3201) > (3014 - (461 + 335)))) then
					if (((49 + 330) <= (5908 - (1730 + 31))) and v21(v94.ShiftingPower, not v14:IsInRange(1707 - (728 + 939)))) then
						return "shifting_power rotation 4";
					end
				end
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and not v110 and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (159 - 114)) and (v114 > (30 - 15))) or ((10342 - 5828) <= (2077 - (138 + 930)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(37 + 3)) or ((2734 + 762) == (1022 + 170))) then
						return "shifting_power rotation 6";
					end
				end
				v142 = 4 - 3;
			end
			if ((v142 == (1768 - (459 + 1307))) or ((2078 - (474 + 1396)) == (5166 - 2207))) then
				if (((4009 + 268) >= (5 + 1308)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) == v112)) then
					if (((7410 - 4823) < (403 + 2771)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles rotation 14";
					end
				end
				if ((v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (33 - 23)) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v114 >= (52 - 40))) or ((4711 - (562 + 29)) <= (1874 + 324))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((3015 - (374 + 1045)) == (680 + 178))) then
						return "nether_tempest rotation 16";
					end
				end
				if (((9998 - 6778) == (3858 - (448 + 190))) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (17 + 33)) and not v94.Evocation:IsAvailable() and (v114 > (10 + 10))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((914 + 488) > (13918 - 10298))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((7998 - 5424) == (4068 - (1307 + 187))) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (277 - 207)) and v105 and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (11 - 6)) and (v114 > (61 - 41))) then
					if (((2481 - (232 + 451)) < (2633 + 124)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage rotation 20";
					end
				end
				v142 = 3 + 0;
			end
			if ((v142 == (565 - (510 + 54))) or ((759 - 382) > (2640 - (13 + 23)))) then
				if (((1106 - 538) < (1308 - 397)) and v94.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (4 - 1)) and (v14:HealthPercentage() < (1123 - (830 + 258))) and v94.ArcaneBombardment:IsAvailable()) then
					if (((11587 - 8302) < (2646 + 1582)) and v21(v94.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((3332 + 584) > (4769 - (860 + 581))) and v94.ArcaneBlast:IsReady() and v33 and v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (22 - 16))) then
					if (((1985 + 515) < (4080 - (237 + 4))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 10";
					end
				end
				if (((1191 - 684) == (1282 - 775)) and v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v14:HealthPercentage() < (66 - 31)) and v94.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (3 + 0))) then
					if (((138 + 102) <= (11949 - 8784)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 12";
					end
				end
				if (((358 + 476) >= (438 + 367)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (1426 - (85 + 1341))) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (51 - 21)) and (v94.TouchoftheMagi:CooldownRemains() > (84 - 54))) or (v13:ManaPercentage() > (442 - (45 + 327)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((7192 - 3380) < (2818 - (444 + 58)))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				v142 = 1 + 1;
			end
		end
	end
	local function v128()
		local v143 = 0 + 0;
		while true do
			if (((1 + 0) == v143) or ((7685 - 5033) <= (3265 - (64 + 1668)))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v94.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v94.ArcaneArtilleryBuff) + (1978 - (1227 + 746))))) or ((11059 - 7461) < (2709 - 1249))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4610 - (415 + 79)) < (31 + 1161))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and ((v101 <= (495 - (142 + 349))) or (v102 <= (2 + 2)) or v13:BuffUp(v94.ClearcastingBuff)) and (v13:ArcaneCharges() == (3 - 0))) or ((1679 + 1698) <= (637 + 266))) then
					if (((10827 - 6851) >= (2303 - (1710 + 154))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v143 = 320 - (200 + 118);
			end
			if (((1487 + 2265) == (6559 - 2807)) and ((4 - 1) == v143)) then
				if (((3595 + 451) > (2666 + 29)) and v94.ArcaneExplosion:IsCastable() and v35) then
					if (v21(v94.ArcaneExplosion, not v14:IsInRange(6 + 4)) or ((567 + 2978) == (6926 - 3729))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if (((3644 - (363 + 887)) > (651 - 278)) and (v143 == (0 - 0))) then
				if (((642 + 3513) <= (9902 - 5670)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (9 + 3))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (1676 - (674 + 990)))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (4 + 8))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (5 + 7))) or (v94.ArcaneOrb:Charges() == (0 - 0)) or (v94.ArcaneOrb:CooldownRemains() > (1067 - (507 + 548))))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(877 - (289 + 548)), true) or ((5399 - (821 + 997)) == (3728 - (195 + 60)))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if (((1344 + 3651) > (4849 - (251 + 1250))) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (17 - 11)) or (v102 > (5 + 1)) or not v94.OrbBarrage:IsAvailable())) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((1786 - (809 + 223)) > (5433 - 1709))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v143 = 2 - 1;
			end
			if (((717 - 500) >= (42 + 15)) and (v143 == (2 + 0))) then
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() == (617 - (14 + 603))) and (v94.TouchoftheMagi:CooldownRemains() > (147 - (118 + 11)))) or ((335 + 1735) >= (3363 + 674))) then
					if (((7882 - 5177) == (3654 - (551 + 398))) and v21(v94.ArcaneOrb, not v14:IsInRange(26 + 14))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((22 + 39) == (50 + 11)) and v94.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (37 - 27)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1610 - 911) >= (421 + 875))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v143 = 11 - 8;
			end
		end
	end
	local function v129()
		local v144 = 0 + 0;
		while true do
			if (((90 - (40 + 49)) == v144) or ((6789 - 5006) >= (4106 - (99 + 391)))) then
				if ((v94.Evocation:IsCastable() and v40 and not v108 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (9 + 1)) and (v94.TouchoftheMagi:CooldownRemains() < (87 - 67))) or (v94.TouchoftheMagi:CooldownRemains() < (37 - 22))) and (v13:ManaPercentage() < (v114 * (4 + 0)))) or ((10296 - 6383) > (6131 - (1032 + 572)))) then
					if (((4793 - (203 + 214)) > (2634 - (568 + 1249))) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				if (((3803 + 1058) > (1978 - 1154)) and v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (115 - 85)) and (v94.ArcaneSurge:CooldownRemains() < v114) and not v95.ManaGem:Exists()) then
					if (v21(v94.ConjureManaGem) or ((2689 - (913 + 393)) >= (6017 - 3886))) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (2 - 0)) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((2286 - (269 + 141)) >= (5651 - 3110))) then
					if (((3763 - (362 + 1619)) <= (5397 - (950 + 675))) and v21(v96.ManaGem)) then
						return "mana_gem main 40";
					end
				end
				v144 = 1 + 1;
			end
			if ((v144 == (1179 - (216 + 963))) or ((5987 - (485 + 802)) < (1372 - (432 + 127)))) then
				if (((4272 - (1065 + 8)) < (2250 + 1800)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1602 - (635 + 966), v94.ArcaneBarrage))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((3560 + 1391) < (4472 - (5 + 37)))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((238 - 142) == (40 + 56)) and v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (150 - 55)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v114 * (2 + 2))) and not ((v114 > (20 - 10)) and (v94.ArcaneSurge:CooldownRemains() < (3 - 2)))))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((5165 - 2426) > (9582 - 5574))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v114 < (2 + 0))) or ((552 - (318 + 211)) == (5579 - 4445))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((4280 - (963 + 624)) >= (1758 + 2353))) then
						return "arcane_barrage main 34";
					end
				end
				v144 = 847 - (518 + 328);
			end
			if ((v144 == (8 - 4)) or ((6897 - 2581) <= (2463 - (301 + 16)))) then
				if ((v30 and v110 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 < v104) or (v102 < v104))) or ((10392 - 6846) <= (7888 - 5079))) then
					v27 = v125();
					if (((12796 - 7892) > (1962 + 204)) and v27) then
						return v27;
					end
				end
				if (((62 + 47) >= (192 - 102)) and ((v101 >= v104) or (v102 >= v104))) then
					local v209 = 0 + 0;
					while true do
						if (((474 + 4504) > (9235 - 6330)) and ((0 + 0) == v209)) then
							v27 = v128();
							if (v27 or ((4045 - (829 + 190)) <= (8134 - 5854))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v101 < v104) or (v102 < v104) or ((2091 - 438) <= (1531 - 423))) then
					local v210 = 0 - 0;
					while true do
						if (((690 + 2219) > (853 + 1756)) and (v210 == (0 - 0))) then
							v27 = v127();
							if (((715 + 42) > (807 - (520 + 93))) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				break;
			end
			if (((278 - (259 + 17)) == v144) or ((2 + 29) >= (504 + 894))) then
				if (((10820 - 7624) <= (5463 - (396 + 195))) and v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and v13:PrevGCDP(2 - 1, v94.ArcaneSurge) and (not v109 or (v109 and v13:PrevGCDP(1763 - (440 + 1321), v94.ArcaneSurge)))) then
					if (((5155 - (1059 + 770)) == (15379 - 12053)) and v21(v96.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if (((1978 - (424 + 121)) <= (707 + 3171)) and not v110 and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * ((1348 - (641 + 706)) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((2 + 1) * v24(v13:HasTier(470 - (249 + 191), 8 - 6) and not v13:HasTier(14 + 16, 15 - 11)))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (472 - (183 + 244))) and ((v94.TouchoftheMagi:CooldownRemains() < (v115 * (1 + 3))) or (v94.TouchoftheMagi:CooldownRemains() > (750 - (434 + 296)))) and ((v101 < v104) or (v102 < v104))) then
					local v211 = 0 - 0;
					while true do
						if ((v211 == (512 - (169 + 343))) or ((1388 + 195) == (3052 - 1317))) then
							v27 = v122();
							if (v27 or ((8749 - 5768) == (1926 + 424))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((not v110 and (v94.ArcaneSurge:CooldownRemains() > (85 - 55)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1126 - (651 + 472)))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and ((v101 < v104) or (v102 < v104))) or ((3376 + 1090) <= (213 + 280))) then
					v27 = v122();
					if (v27 or ((3108 - 561) <= (2470 - (397 + 86)))) then
						return v27;
					end
				end
				v144 = 879 - (423 + 453);
			end
			if (((301 + 2660) > (362 + 2378)) and (v144 == (3 + 0))) then
				if (((2950 + 746) >= (3227 + 385)) and v30 and v94.RadiantSpark:IsAvailable() and v106) then
					local v212 = 1190 - (50 + 1140);
					while true do
						if (((0 + 0) == v212) or ((1754 + 1216) == (117 + 1761))) then
							v27 = v124();
							if (v27 or ((5302 - 1609) < (1431 + 546))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v110 and v94.RadiantSpark:IsAvailable() and v107) or ((1526 - (157 + 439)) > (3653 - 1552))) then
					v27 = v123();
					if (((13799 - 9646) > (9128 - 6042)) and v27) then
						return v27;
					end
				end
				if ((v30 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 >= v104) or (v102 >= v104))) or ((5572 - (782 + 136)) <= (4905 - (112 + 743)))) then
					v27 = v126();
					if (v27 or ((3773 - (1026 + 145)) < (257 + 1239))) then
						return v27;
					end
				end
				v144 = 722 - (493 + 225);
			end
		end
	end
	local function v130()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (5 + 2)) or ((2734 - 1714) > (44 + 2244))) then
				v67 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v70 = EpicSettings.Settings['massBarrierHP'] or (1595 - (210 + 1385));
				v89 = EpicSettings.Settings['useSpellStealTarget'];
				v145 = 1697 - (1201 + 488);
			end
			if (((204 + 124) == (583 - 255)) and (v145 == (6 - 2))) then
				v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v145 = 590 - (352 + 233);
			end
			if (((3651 - 2140) < (2072 + 1736)) and ((17 - 11) == v145)) then
				v62 = EpicSettings.Settings['useMassBarrier'];
				v63 = EpicSettings.Settings['useMirrorImage'];
				v64 = EpicSettings.Settings['alterTimeHP'] or (574 - (489 + 85));
				v65 = EpicSettings.Settings['prismaticBarrierHP'] or (1501 - (277 + 1224));
				v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (1493 - (663 + 830));
				v145 = 7 + 0;
			end
			if ((v145 == (4 - 2)) or ((3385 - (461 + 414)) > (825 + 4094))) then
				v43 = EpicSettings.Settings['usePresenceOfMind'];
				v92 = EpicSettings.Settings['cancelPOM'];
				v44 = EpicSettings.Settings['useCounterspell'];
				v45 = EpicSettings.Settings['useBlastWave'];
				v46 = EpicSettings.Settings['useDragonsBreath'];
				v145 = 2 + 1;
			end
			if (((454 + 4309) == (4696 + 67)) and (v145 == (250 - (172 + 78)))) then
				v33 = EpicSettings.Settings['useArcaneBlast'];
				v34 = EpicSettings.Settings['useArcaneBarrage'];
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneFamiliar'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v145 = 1 - 0;
			end
			if (((1523 + 2614) > (2666 - 818)) and (v145 == (3 + 5))) then
				v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v91 = EpicSettings.Settings['mirrorImageBeforePull'];
				v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((814 + 1622) <= (5250 - 2116)) and (v145 == (3 - 0))) then
				v47 = EpicSettings.Settings['useArcaneSurge'];
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['useArcaneOrb'];
				v50 = EpicSettings.Settings['useRadiantSpark'];
				v51 = EpicSettings.Settings['useTouchOfTheMagi'];
				v145 = 2 + 2;
			end
			if (((2059 + 1664) == (1326 + 2397)) and (v145 == (19 - 14))) then
				v57 = EpicSettings.Settings['useAlterTime'];
				v58 = EpicSettings.Settings['usePrismaticBarrier'];
				v59 = EpicSettings.Settings['useGreaterInvisibility'];
				v60 = EpicSettings.Settings['useIceBlock'];
				v61 = EpicSettings.Settings['useIceCold'];
				v145 = 13 - 7;
			end
			if (((1 + 0) == v145) or ((2311 + 1735) >= (4763 - (133 + 314)))) then
				v38 = EpicSettings.Settings['useArcaneMissiles'];
				v39 = EpicSettings.Settings['useConjureManaGem'];
				v40 = EpicSettings.Settings['useEvocation'];
				v41 = EpicSettings.Settings['useManaGem'];
				v42 = EpicSettings.Settings['useNetherTempest'];
				v145 = 1 + 1;
			end
		end
	end
	local function v131()
		local v146 = 213 - (199 + 14);
		while true do
			if (((10 - 7) == v146) or ((3557 - (647 + 902)) < (5800 - 3871))) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (233 - (85 + 148));
				v86 = EpicSettings.Settings['healingPotionHP'] or (1289 - (426 + 863));
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v146 = 18 - 14;
			end
			if (((4038 - (873 + 781)) > (2376 - 601)) and (v146 == (0 - 0))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v146 = 3 - 2;
			end
			if (((5 - 1) == v146) or ((13489 - 8946) <= (6323 - (414 + 1533)))) then
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((632 + 96) == (1283 - (443 + 112))) and (v146 == (1480 - (888 + 591)))) then
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v146 = 5 - 3;
			end
			if ((v146 == (1 + 1)) or ((4052 - 2976) > (1824 + 2847))) then
				v80 = EpicSettings.Settings['useRacials'];
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v146 = 2 + 1;
			end
		end
	end
	local function v132()
		local v147 = 0 + 0;
		while true do
			if (((3527 - 1676) >= (699 - 321)) and (v147 == (1683 - (136 + 1542)))) then
				if (v98.TargetIsValid() or ((6387 - 4439) >= (3450 + 26))) then
					local v213 = 0 - 0;
					while true do
						if (((3470 + 1324) >= (1319 - (68 + 418))) and ((2 - 1) == v213)) then
							v27 = v116();
							if (((7420 - 3330) == (3531 + 559)) and v27) then
								return v27;
							end
							v213 = 1094 - (770 + 322);
						end
						if ((v213 == (0 + 0)) or ((1087 + 2671) == (341 + 2157))) then
							if ((v72 and v32 and v94.RemoveCurse:IsAvailable()) or ((3823 - 1150) < (3053 - 1478))) then
								local v220 = 0 - 0;
								while true do
									if ((v220 == (0 - 0)) or ((2073 + 1648) <= (2180 - 725))) then
										if (((449 + 485) < (1392 + 878)) and v15) then
											v27 = v118();
											if (v27 or ((1264 + 348) == (4725 - 3470))) then
												return v27;
											end
										end
										if ((v16 and v16:Exists() and v16:IsAPlayer() and v98.UnitHasCurseDebuff(v16)) or ((6044 - 1692) < (1422 + 2784))) then
											if (v94.RemoveCurse:IsReady() or ((13174 - 10314) <= (598 - 417))) then
												if (((1326 + 1896) >= (7556 - 6029)) and v21(v96.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if (((2336 - (762 + 69)) <= (6867 - 4746)) and not v13:AffectingCombat() and v28) then
								local v221 = 0 + 0;
								while true do
									if (((482 + 262) == (1799 - 1055)) and ((0 + 0) == v221)) then
										v27 = v120();
										if (v27 or ((32 + 1947) >= (11049 - 8213))) then
											return v27;
										end
										break;
									end
								end
							end
							v213 = 158 - (8 + 149);
						end
						if (((3153 - (1199 + 121)) <= (4514 - 1846)) and (v213 == (4 - 2))) then
							if (((1518 + 2168) == (13156 - 9470)) and v73) then
								if (((8044 - 4577) > (422 + 55)) and v93) then
									local v227 = 1807 - (518 + 1289);
									while true do
										if ((v227 == (0 - 0)) or ((437 + 2851) >= (5171 - 1630))) then
											v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 23 + 7);
											if (v27 or ((4026 - (304 + 165)) == (4286 + 254))) then
												return v27;
											end
											break;
										end
									end
								end
							end
							if (v74 or ((421 - (54 + 106)) > (3236 - (1618 + 351)))) then
								local v222 = 0 + 0;
								while true do
									if (((2288 - (10 + 1006)) < (969 + 2889)) and (v222 == (0 + 0))) then
										v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 97 - 67);
										if (((4697 - (912 + 121)) == (1732 + 1932)) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v213 = 1292 - (1140 + 149);
						end
						if (((1243 + 698) >= (599 - 149)) and (v213 == (1 + 2))) then
							if ((v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) or ((15900 - 11254) < (607 - 283))) then
								if (((662 + 3171) == (13300 - 9467)) and v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							if ((not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) or ((1426 - (165 + 21)) > (3481 - (61 + 50)))) then
								local v223 = 0 + 0;
								local v224;
								while true do
									if ((v223 == (4 - 3)) or ((4999 - 2518) == (1840 + 2842))) then
										if (((6187 - (1295 + 165)) >= (48 + 160)) and v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes)) then
											if (((113 + 167) < (5248 - (819 + 578))) and v21(v94.IceFloes)) then
												return "ice_floes movement";
											end
										end
										if ((v90 and v94.TimeWarp:IsReady() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v114 <= (1442 - (331 + 1071))) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v114 <= (v94.ArcaneSurge:CooldownRemains() + (757 - (588 + 155))))))) or ((4289 - (546 + 736)) > (5131 - (1834 + 103)))) then
											if (v21(v94.TimeWarp, not v14:IsInRange(25 + 15)) or ((6371 - 4235) >= (4712 - (1536 + 230)))) then
												return "time_warp main 4";
											end
										end
										if (((2656 - (128 + 363)) <= (536 + 1985)) and v80 and ((v83 and v30) or not v83) and (v78 < v114)) then
											local v228 = 0 - 0;
											while true do
												if (((739 + 2122) > (1094 - 433)) and (v228 == (0 - 0))) then
													if (((10990 - 6465) > (3102 + 1417)) and v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (1011 - (615 + 394))) or (v102 >= (2 + 0)))) then
														if (((3029 + 149) > (2962 - 1990)) and v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment))) then
															return "lights_judgment main 6";
														end
													end
													if (((21617 - 16851) == (5417 - (59 + 592))) and v94.Berserking:IsCastable() and ((v13:PrevGCDP(2 - 1, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) then
														if (v21(v94.Berserking) or ((5054 - 2309) > (2205 + 923))) then
															return "berserking main 8";
														end
													end
													v228 = 172 - (70 + 101);
												end
												if ((v228 == (2 - 1)) or ((812 + 332) >= (11568 - 6962))) then
													if (((3579 - (123 + 118)) >= (68 + 209)) and v13:PrevGCDP(1 + 0, v94.ArcaneSurge)) then
														local v229 = 1399 - (653 + 746);
														while true do
															if (((4881 - 2271) > (3688 - 1128)) and (v229 == (0 - 0))) then
																if (v94.BloodFury:IsCastable() or ((527 + 667) > (1973 + 1110))) then
																	if (((801 + 115) >= (92 + 655)) and v21(v94.BloodFury)) then
																		return "blood_fury main 10";
																	end
																end
																if (v94.Fireblood:IsCastable() or ((382 + 2062) > (7241 - 4287))) then
																	if (((2753 + 139) < (6492 - 2978)) and v21(v94.Fireblood)) then
																		return "fireblood main 12";
																	end
																end
																v229 = 1235 - (885 + 349);
															end
															if (((424 + 109) == (1453 - 920)) and (v229 == (2 - 1))) then
																if (((1563 - (915 + 53)) <= (4214 - (768 + 33))) and v94.AncestralCall:IsCastable()) then
																	if (((11785 - 8707) >= (4560 - 1969)) and v21(v94.AncestralCall)) then
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
										v223 = 330 - (287 + 41);
									end
									if (((4046 - (638 + 209)) < (2094 + 1936)) and (v223 == (1688 - (96 + 1590)))) then
										if (((2449 - (741 + 931)) < (1021 + 1057)) and (v78 < v114)) then
											if (((4832 - 3136) <= (10661 - 8379)) and v81 and ((v30 and v82) or not v82)) then
												v27 = v119();
												if (v27 or ((756 + 1005) >= (1058 + 1404))) then
													return v27;
												end
											end
										end
										v27 = v121();
										if (((1451 + 3100) > (8834 - 6506)) and v27) then
											return v27;
										end
										v223 = 1 + 2;
									end
									if (((1868 + 1957) >= (1904 - 1437)) and (v223 == (3 + 0))) then
										v27 = v129();
										if (v27 or ((3384 - (64 + 430)) == (553 + 4))) then
											return v27;
										end
										break;
									end
									if ((v223 == (363 - (106 + 257))) or ((3382 + 1388) == (3625 - (496 + 225)))) then
										if ((v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) or ((7981 - 4078) == (22096 - 17560))) then
											if (((5751 - (256 + 1402)) <= (6744 - (30 + 1869))) and v21(v96.UseWeapon, nil)) then
												return "Using Weapon Macro";
											end
										end
										v224 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
										if (((2938 - (213 + 1156)) <= (3835 - (96 + 92))) and v224) then
											return v224;
										end
										v223 = 1 + 0;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v147 == (902 - (142 + 757))) or ((3296 + 750) >= (2014 + 2913))) then
				v103 = v13:GetEnemiesInRange(119 - (32 + 47));
				if (((6600 - (1053 + 924)) >= (2730 + 57)) and v29) then
					local v214 = 0 - 0;
					while true do
						if (((3882 - (685 + 963)) >= (2501 - 1271)) and (v214 == (0 - 0))) then
							v101 = v26(v14:GetEnemiesInSplashRangeCount(1714 - (541 + 1168)), #v103);
							v102 = #v103;
							break;
						end
					end
				else
					local v215 = 1597 - (645 + 952);
					while true do
						if ((v215 == (838 - (669 + 169))) or ((1188 - 845) == (3878 - 2092))) then
							v101 = 1 + 0;
							v102 = 1 + 0;
							break;
						end
					end
				end
				if (((3335 - (181 + 584)) > (3804 - (665 + 730))) and (v98.TargetIsValid() or v13:AffectingCombat())) then
					local v216 = 0 - 0;
					while true do
						if ((v216 == (1 - 0)) or ((3959 - (540 + 810)) >= (12929 - 9695))) then
							v114 = v113;
							if ((v114 == (30548 - 19437)) or ((2414 + 619) >= (4234 - (166 + 37)))) then
								v114 = v10.FightRemains(v103, false);
							end
							break;
						end
						if ((v216 == (1881 - (22 + 1859))) or ((3173 - (843 + 929)) == (4930 - (30 + 232)))) then
							if (((7928 - 5152) >= (2098 - (55 + 722))) and (v13:AffectingCombat() or v72)) then
								local v225 = 0 - 0;
								local v226;
								while true do
									if ((v225 == (1676 - (78 + 1597))) or ((108 + 379) > (2096 + 207))) then
										if (v27 or ((3770 + 733) == (4011 - (305 + 244)))) then
											return v27;
										end
										break;
									end
									if (((514 + 39) <= (1648 - (95 + 10))) and (v225 == (0 + 0))) then
										v226 = v72 and v94.RemoveCurse:IsReady() and v32;
										v27 = v98.FocusUnit(v226, nil, 63 - 43, nil, 27 - 7, v94.ArcaneIntellect);
										v225 = 763 - (592 + 170);
									end
								end
							end
							v113 = v10.BossFightRemains(nil, true);
							v216 = 3 - 2;
						end
					end
				end
				v147 = 9 - 5;
			end
			if (((940 + 1075) == (785 + 1230)) and (v147 == (4 - 2))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((688 + 3553) <= (4321 - 1989))) then
					return v27;
				end
				v100 = v14:GetEnemiesInSplashRange(512 - (353 + 154));
				v147 = 3 - 0;
			end
			if ((v147 == (1 - 0)) or ((1632 + 732) < (907 + 250))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v147 = 2 + 0;
			end
			if (((0 - 0) == v147) or ((2208 - 1041) > (2979 - 1701))) then
				v130();
				v131();
				v28 = EpicSettings.Toggles['ooc'];
				v147 = 87 - (7 + 79);
			end
			if ((v147 == (2 + 2)) or ((1326 - (24 + 157)) <= (2158 - 1076))) then
				v115 = v13:GCD();
				if (v73 or ((6623 - 3518) == (1387 + 3494))) then
					if (v93 or ((5082 - 3195) > (5258 - (262 + 118)))) then
						local v219 = 1083 - (1038 + 45);
						while true do
							if ((v219 == (0 - 0)) or ((4317 - (19 + 211)) > (4229 - (88 + 25)))) then
								v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 76 - 46);
								if (((549 + 557) <= (1182 + 84)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (((4191 - (1007 + 29)) < (1253 + 3397)) and (not v13:AffectingCombat() or v28)) then
					local v217 = 0 - 0;
					while true do
						if (((17849 - 14075) >= (410 + 1429)) and ((812 - (340 + 471)) == v217)) then
							if (((7080 - 4269) == (3400 - (276 + 313))) and v94.ConjureManaGem:IsCastable() and v39) then
								if (((5238 - 3092) > (1035 + 87)) and v21(v94.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
						if ((v217 == (0 + 0)) or ((6 + 50) == (5588 - (495 + 1477)))) then
							if ((v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) or ((7248 - 4827) < (408 + 214))) then
								if (((1412 - (342 + 61)) <= (495 + 635)) and v21(v94.ArcaneIntellect)) then
									return "arcane_intellect group_buff";
								end
							end
							if (((2923 - (4 + 161)) < (1825 + 1155)) and v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) then
								if (v21(v94.ArcaneFamiliar) or ((269 - 183) >= (9530 - 5904))) then
									return "arcane_familiar precombat 2";
								end
							end
							v217 = 498 - (322 + 175);
						end
					end
				end
				v147 = 568 - (173 + 390);
			end
		end
	end
	local function v133()
		local v148 = 0 + 0;
		while true do
			if (((2709 - (203 + 111)) == (149 + 2246)) and (v148 == (0 + 0))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(180 - 118, v132, v133);
end;
return v0["Epix_Mage_Arcane.lua"]();

