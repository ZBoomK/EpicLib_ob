local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1566 - (1429 + 137);
	local v6;
	while true do
		if (((2086 - (1253 + 196)) == (894 - (126 + 131))) and ((834 - (171 + 662)) == v5)) then
			return v6(...);
		end
		if ((v5 == (93 - (4 + 89))) or ((12894 - 9215) < (228 + 397))) then
			v6 = v0[v4];
			if (not v6 or ((20313 - 15688) < (248 + 384))) then
				return v1(v4, ...);
			end
			v5 = 1487 - (35 + 1451);
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
		if (v94.RemoveCurse:IsAvailable() or ((1536 - (28 + 1425)) > (3773 - (941 + 1052)))) then
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
	local v104 = 3 + 0;
	local v105 = false;
	local v106 = false;
	local v107 = false;
	local v108 = true;
	local v109 = false;
	local v110 = v13:HasTier(1543 - (822 + 692), 5 - 1);
	local v111 = (105980 + 119020) - (((25297 - (45 + 252)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((197887 + 2113) * v24(not v110)));
	local v112 = 2 + 1;
	local v113 = 27041 - 15930;
	local v114 = 11544 - (114 + 319);
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 - 0;
		while true do
			if (((699 - 153) <= (687 + 390)) and ((1 - 0) == v134)) then
				v111 = (471435 - 246435) - (((26963 - (556 + 1407)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((201206 - (741 + 465)) * v24(not v110)));
				v113 = 11576 - (170 + 295);
				v134 = 2 + 0;
			end
			if (((0 + 0) == v134) or ((2451 - 1455) > (3566 + 735))) then
				v105 = false;
				v108 = true;
				v134 = 1 + 0;
			end
			if (((2305 + 1765) > (1917 - (957 + 273))) and (v134 == (1 + 1))) then
				v114 = 4448 + 6663;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v110 = not v13:HasTier(110 - 81, 10 - 6);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v116()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (14 - 11)) or ((2436 - (389 + 1391)) >= (2090 + 1240))) then
				if ((v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((260 + 2232) <= (762 - 427))) then
					if (((5273 - (783 + 168)) >= (8598 - 6036)) and v21(v94.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) or ((3578 + 59) >= (4081 - (309 + 2)))) then
					if (v21(v96.Healthstone) or ((7305 - 4926) > (5790 - (1090 + 122)))) then
						return "healthstone defensive";
					end
				end
				v135 = 2 + 2;
			end
			if ((v135 == (13 - 9)) or ((331 + 152) > (1861 - (628 + 490)))) then
				if (((441 + 2013) > (1430 - 852)) and v84 and (v13:HealthPercentage() <= v86)) then
					local v205 = 0 - 0;
					while true do
						if (((1704 - (431 + 343)) < (9003 - 4545)) and ((0 - 0) == v205)) then
							if (((523 + 139) <= (125 + 847)) and (v88 == "Refreshing Healing Potion")) then
								if (((6065 - (556 + 1139)) == (4385 - (6 + 9))) and v95.RefreshingHealingPotion:IsReady()) then
									if (v21(v96.RefreshingHealingPotion) or ((872 + 3890) <= (442 + 419))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((1581 - (28 + 141)) == (1652 + 2612))) then
								if (v95.DreamwalkersHealingPotion:IsReady() or ((3909 - 741) < (1525 + 628))) then
									if (v21(v96.RefreshingHealingPotion) or ((6293 - (486 + 831)) < (3466 - 2134))) then
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
			if (((16293 - 11665) == (875 + 3753)) and (v135 == (0 - 0))) then
				if ((v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((1317 - (668 + 595)) == (356 + 39))) then
					if (((17 + 65) == (223 - 141)) and v21(v94.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 292 - (23 + 267), v94.ArcaneIntellect)) or ((2525 - (1129 + 815)) < (669 - (371 + 16)))) then
					if (v21(v94.MassBarrier) or ((6359 - (1326 + 424)) < (4725 - 2230))) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 3 - 2;
			end
			if (((1270 - (88 + 30)) == (1923 - (720 + 51))) and (v135 == (4 - 2))) then
				if (((3672 - (421 + 1355)) <= (5644 - 2222)) and v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) then
					if (v21(v94.MirrorImage) or ((487 + 503) > (2703 - (286 + 797)))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((3205 - 2328) > (7776 - 3081))) then
					if (((3130 - (397 + 42)) >= (579 + 1272)) and v21(v94.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v135 = 803 - (24 + 776);
			end
			if ((v135 == (1 - 0)) or ((3770 - (222 + 563)) >= (10699 - 5843))) then
				if (((3079 + 1197) >= (1385 - (23 + 167))) and v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
					if (((5030 - (690 + 1108)) <= (1693 + 2997)) and v21(v94.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) or ((740 + 156) >= (3994 - (40 + 808)))) then
					if (((504 + 2557) >= (11311 - 8353)) and v21(v94.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v135 = 2 + 0;
			end
		end
	end
	local v117 = 0 + 0;
	local function v118()
		if (((1748 + 1439) >= (1215 - (47 + 524))) and v94.RemoveCurse:IsReady() and v98.DispellableFriendlyUnit(13 + 7)) then
			local v149 = 0 - 0;
			while true do
				if (((962 - 318) <= (1605 - 901)) and (v149 == (1726 - (1165 + 561)))) then
					if (((29 + 929) > (2932 - 1985)) and (v117 == (0 + 0))) then
						v117 = GetTime();
					end
					if (((4971 - (341 + 138)) >= (717 + 1937)) and v98.Wait(1031 - 531, v117)) then
						local v214 = 326 - (89 + 237);
						while true do
							if (((11072 - 7630) >= (3164 - 1661)) and (v214 == (881 - (581 + 300)))) then
								if (v21(v96.RemoveCurseFocus) or ((4390 - (855 + 365)) <= (3477 - 2013))) then
									return "remove_curse dispel";
								end
								v117 = 0 + 0;
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
		local v136 = 1235 - (1030 + 205);
		while true do
			if ((v136 == (0 + 0)) or ((4463 + 334) == (4674 - (156 + 130)))) then
				v27 = v98.HandleTopTrinket(v97, v30, 90 - 50, nil);
				if (((928 - 377) <= (1394 - 713)) and v27) then
					return v27;
				end
				v136 = 1 + 0;
			end
			if (((1911 + 1366) > (476 - (10 + 59))) and (v136 == (1 + 0))) then
				v27 = v98.HandleBottomTrinket(v97, v30, 196 - 156, nil);
				if (((5858 - (671 + 492)) >= (1127 + 288)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v120()
		local v137 = 1215 - (369 + 846);
		while true do
			if ((v137 == (1 + 1)) or ((2742 + 470) <= (2889 - (1036 + 909)))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((2462 + 634) <= (3018 - 1220))) then
					if (((3740 - (11 + 192)) == (1788 + 1749)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if (((4012 - (135 + 40)) >= (3803 - 2233)) and (v137 == (0 + 0))) then
				if ((v94.MirrorImage:IsCastable() and v91 and v63) or ((6498 - 3548) == (5713 - 1901))) then
					if (((4899 - (50 + 126)) >= (6454 - 4136)) and v21(v94.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) or ((449 + 1578) > (4265 - (1233 + 180)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((2105 - (522 + 447)) > (5738 - (107 + 1314)))) then
						return "arcane_blast precombat 4";
					end
				end
				v137 = 1 + 0;
			end
			if (((14467 - 9719) == (2017 + 2731)) and ((1 - 0) == v137)) then
				if (((14781 - 11045) <= (6650 - (716 + 1194))) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
					if (v21(v94.Evocation) or ((58 + 3332) <= (328 + 2732))) then
						return "evocation precombat 6";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((1502 - (74 + 429)) > (5194 - 2501))) then
					if (((230 + 233) < (1375 - 774)) and v21(v94.ArcaneOrb, not v14:IsInRange(29 + 11))) then
						return "arcane_orb precombat 8";
					end
				end
				v137 = 5 - 3;
			end
		end
	end
	local function v121()
		if ((((v101 >= v104) or (v102 >= v104)) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (436 - (279 + 154)))) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (780 - (454 + 324))))) or ((1718 + 465) < (704 - (12 + 5)))) then
			v106 = true;
		elseif (((2453 + 2096) == (11590 - 7041)) and v106 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (3 + 4)) and v94.RadiantSpark:CooldownDown()) then
			v106 = false;
		end
		if (((5765 - (277 + 816)) == (19963 - 15291)) and (v13:ArcaneCharges() > (1186 - (1058 + 125))) and ((v101 < v104) or (v102 < v104)) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (2 + 5))) and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * (980 - (815 + 160)))) or (v94.ArcaneSurge:CooldownRemains() > (171 - 131)))) then
			v107 = true;
		elseif ((v107 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (16 - 9)) and v94.RadiantSpark:CooldownDown()) or ((876 + 2792) < (1154 - 759))) then
			v107 = false;
		end
		if ((v14:DebuffUp(v94.TouchoftheMagiDebuff) and v108) or ((6064 - (41 + 1857)) == (2348 - (1222 + 671)))) then
			v108 = false;
		end
		v109 = v94.ArcaneBlast:CastTime() < v115;
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (7 - 1)) or ((5631 - (229 + 953)) == (4437 - (1111 + 663)))) then
				if ((v94.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1583 - (874 + 705))) and v13:PrevGCDP(1 + 0, v94.ArcaneBlast)))) or ((2919 + 1358) < (6212 - 3223))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((25 + 845) >= (4828 - (642 + 37)))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if (((505 + 1707) < (510 + 2673)) and v94.ArcaneBlast:IsReady() and v33) then
					if (((11665 - 7019) > (3446 - (233 + 221))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if (((3315 - 1881) < (2734 + 372)) and (v138 == (1541 - (718 + 823)))) then
				if (((495 + 291) < (3828 - (266 + 539))) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((3667 - (636 + 589)) < (175 - 101))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((9353 - 4818) == (3594 + 941)) and v94.RadiantSpark:CooldownUp()) then
					v105 = v94.ArcaneSurge:CooldownRemains() < (4 + 6);
				end
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) or ((4024 - (657 + 358)) <= (5573 - 3468))) then
					if (((4169 - 2339) < (4856 - (1151 + 36))) and v21(v94.ShiftingPower, not v14:IsInRange(39 + 1), true)) then
						return "shifting_power cooldown_phase 4";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (2 - 1)) or ((3262 - (1552 + 280)) >= (4446 - (64 + 770)))) then
				if (((1822 + 861) >= (5584 - 3124)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and v94.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(8 + 32)) or ((3047 - (157 + 1086)) >= (6555 - 3280))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v94.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (8 - 6)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v94.ArcaneOrb:CooldownRemains() >= v115)))) or ((2173 - 756) > (4952 - 1323))) then
					if (((5614 - (599 + 220)) > (800 - 398)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((6744 - (1813 + 118)) > (2606 + 959)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (1217 - (841 + 376))) and (v13:ManaPercentage() > (42 - 12)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (((909 + 3003) == (10677 - 6765)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				v138 = 861 - (464 + 395);
			end
			if (((7239 - 4418) <= (2317 + 2507)) and (v138 == (840 - (467 + 370)))) then
				if (((3591 - 1853) <= (1612 + 583)) and v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (51 - 36)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1 + 4)))) and (v94.ArcaneSurge:CooldownRemains() < (69 - 39))) then
					if (((561 - (150 + 370)) <= (4300 - (74 + 1208))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if (((5275 - 3130) <= (19463 - 15359)) and v94.ArcaneMissiles:IsReady() and v38 and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < v115)) and v13:HasTier(22 + 8, 394 - (14 + 376))) then
					if (((4663 - 1974) < (3136 + 1709)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((2040 + 282) > (2501 + 121))) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), true) or ((13285 - 8751) == (1567 + 515))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v138 = 82 - (23 + 55);
			end
			if ((v138 == (4 - 2)) or ((1049 + 522) > (1677 + 190))) then
				if ((v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (7 - 2)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (2 + 4)))) and v13:HasTier(932 - (652 + 249), 10 - 6)) or ((4522 - (708 + 1160)) >= (8132 - 5136))) then
					if (((7252 - 3274) > (2131 - (10 + 17))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((673 + 2322) > (3273 - (1400 + 332))) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (32 - 15)) and not v13:HasTier(1938 - (242 + 1666), 2 + 2)) then
					if (((1191 + 2058) > (813 + 140)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (942 - (850 + 90))) and (v94.RadiantSpark:CooldownRemains() < (8 - 3)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (1396 - (360 + 1030))))) and not v13:HasTier(27 + 3, 11 - 7)) or ((4502 - 1229) > (6234 - (909 + 752)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4374 - (109 + 1114)) < (2350 - 1066))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				v138 = 2 + 1;
			end
			if ((v138 == (247 - (6 + 236))) or ((1166 + 684) == (1231 + 298))) then
				if (((1935 - 1114) < (3707 - 1584)) and v94.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v94.RadiantSparkVulnerability) and (v14:DebuffStack(v94.RadiantSparkVulnerability) < (1137 - (1076 + 57)))) then
					if (((149 + 753) < (3014 - (579 + 110))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if (((68 + 790) <= (2619 + 343)) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (v21(v94.PresenceofMind) or ((2095 + 1851) < (1695 - (174 + 233)))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.PresenceofMindBuff))) or ((9055 - 5813) == (994 - 427))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((377 + 470) >= (2437 - (663 + 511)))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				v138 = 6 + 0;
			end
			if ((v138 == (1 + 3)) or ((6945 - 4692) == (1121 + 730))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (70 - 40)) and (v94.ArcaneEcho:IsAvailable())) or ((5051 - 2964) > (1132 + 1240))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((8651 - 4206) < (2957 + 1192))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if ((v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) or ((167 + 1651) == (807 - (478 + 244)))) then
					if (((1147 - (440 + 77)) < (968 + 1159)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(3 - 2, v94.ArcaneSurge) or v13:PrevGCDP(1557 - (655 + 901), v94.NetherTempest) or v13:PrevGCDP(1 + 0, v94.RadiantSpark))) or ((1484 + 454) == (1698 + 816))) then
					if (((17141 - 12886) >= (1500 - (695 + 750))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				v138 = 16 - 11;
			end
		end
	end
	local function v123()
		if (((4627 - 1628) > (4649 - 3493)) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (396 - (285 + 66))) and v14:DebuffDown(v94.NetherTempestDebuff) and v108 and v13:BloodlustUp()) then
			if (((5478 - 3128) > (2465 - (682 + 628))) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
				return "nether_tempest spark_phase 2";
			end
		end
		if (((650 + 3379) <= (5152 - (176 + 123))) and v108 and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
			if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((375 + 141) > (3703 - (239 + 30)))) then
				return "arcane_missiles interrupt spark_phase 4";
			end
		end
		if (((1100 + 2946) >= (2916 + 117)) and v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (8 - 3)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (18 - 12)))) and v13:HasTier(346 - (306 + 9), 13 - 9)) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((473 + 2246) <= (888 + 559))) then
				return "arcane_missiles spark_phase 4";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (8 + 7))) or ((11821 - 7687) < (5301 - (1140 + 235)))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((105 + 59) >= (2554 + 231))) then
				return "arcane_blast spark_phase 6";
			end
		end
		if ((v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (1 + 1)) and (v94.RadiantSpark:CooldownRemains() < (57 - (33 + 19))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (3 + 3)))) or ((1573 - 1048) == (930 + 1179))) then
			if (((64 - 31) == (31 + 2)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
				return "arcane_missiles spark_phase 10";
			end
		end
		if (((3743 - (586 + 103)) <= (366 + 3649)) and v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (46 - 31)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1493 - (1309 + 179))))) and (v94.ArcaneSurge:CooldownRemains() < (54 - 24))) then
			if (((815 + 1056) < (9082 - 5700)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
				return "arcane_missiles spark_phase 12";
			end
		end
		if (((977 + 316) <= (4601 - 2435)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
			if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark)) or ((5138 - 2559) < (732 - (295 + 314)))) then
				return "radiant_spark spark_phase 14";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and not v109 and (v94.NetherTempest:TimeSinceLastCast() >= (36 - 21)) and ((not v109 and v13:PrevGCDP(1966 - (1300 + 662), v94.RadiantSpark) and (v94.ArcaneSurge:CooldownRemains() <= v94.NetherTempest:ExecuteTime())) or v13:PrevGCDP(15 - 10, v94.RadiantSpark))) or ((2601 - (1178 + 577)) >= (1230 + 1138))) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((11860 - 7848) <= (4763 - (851 + 554)))) then
				return "nether_tempest spark_phase 16";
			end
		end
		if (((1322 + 172) <= (8333 - 5328)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114) and ((not v94.NetherTempest:IsAvailable() and ((v13:PrevGCDP(8 - 4, v94.RadiantSpark) and not v109) or v13:PrevGCDP(307 - (115 + 187), v94.RadiantSpark))) or v13:PrevGCDP(1 + 0, v94.NetherTempest))) then
			if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge)) or ((2946 + 165) == (8409 - 6275))) then
				return "arcane_surge spark_phase 18";
			end
		end
		if (((3516 - (160 + 1001)) == (2061 + 294)) and v94.ArcaneBlast:IsReady() and v33 and (v94.ArcaneBlast:CastTime() >= v13:GCD()) and (v94.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v94.RadiantSparkVulnerability)) and (not v94.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (25 + 10))) and ((v94.NetherTempest:IsAvailable() and v13:PrevGCDP(11 - 5, v94.RadiantSpark)) or (not v94.NetherTempest:IsAvailable() and v13:PrevGCDP(363 - (237 + 121), v94.RadiantSpark))) and not (v13:IsCasting(v94.ArcaneSurge) and (v13:CastRemains() < (897.5 - (525 + 372))) and not v109)) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((1114 - 526) <= (1419 - 987))) then
				return "arcane_blast spark_phase 20";
			end
		end
		if (((4939 - (96 + 46)) >= (4672 - (643 + 134))) and v94.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 + 2))) then
			if (((8576 - 4999) == (13280 - 9703)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage spark_phase 22";
			end
		end
		if (((3639 + 155) > (7247 - 3554)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and v13:PrevGCDP(1 - 0, v94.ArcaneBarrage) and ((v94.ArcaneBarrage:InFlight() and ((v94.ArcaneBarrage:TravelTime() - v94.ArcaneBarrage:TimeSinceLastCast()) <= (719.2 - (316 + 403)))) or (v13:GCDRemains() <= (0.2 + 0)))) then
			if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((3505 - 2230) == (1482 + 2618))) then
				return "touch_of_the_magi spark_phase 24";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33) or ((4006 - 2415) >= (2537 + 1043))) then
			if (((317 + 666) <= (6264 - 4456)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast spark_phase 26";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34) or ((10268 - 8118) <= (2486 - 1289))) then
			if (((216 + 3553) >= (2308 - 1135)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage spark_phase 28";
			end
		end
	end
	local function v124()
		if (((73 + 1412) == (4368 - 2883)) and v13:BuffUp(v94.PresenceofMindBuff) and v92 and (v13:PrevGCDP(18 - (12 + 5), v94.ArcaneBlast)) and (v94.ArcaneSurge:CooldownRemains() > (291 - 216))) then
			if (v21(v96.CancelPOM) or ((7072 - 3757) <= (5913 - 3131))) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) or ((178 + 698) >= (4937 - (1656 + 317)))) then
			if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((1989 + 243) > (2001 + 496))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((5610 - 3500) <= (1633 - 1301))) then
			if (((4040 - (5 + 349)) > (15066 - 11894)) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), true)) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v94.ArcaneOrb:TimeSinceLastCast() >= (1286 - (266 + 1005))) and (v13:ArcaneCharges() < (2 + 1))) or ((15265 - 10791) < (1079 - 259))) then
			if (((5975 - (561 + 1135)) >= (3755 - 873)) and v21(v94.ArcaneOrb, not v14:IsInRange(131 - 91))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (1081 - (507 + 559))) and (v94.ArcaneEcho:IsAvailable())) or ((5091 - 3062) >= (10889 - 7368))) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((2425 - (212 + 176)) >= (5547 - (250 + 655)))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((4690 - 2970) < (7789 - 3331)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
			if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge)) or ((681 - 245) > (4977 - (1869 + 87)))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if (((2472 - 1759) <= (2748 - (484 + 1417))) and v94.ArcaneBarrage:IsReady() and v34 and (v94.ArcaneSurge:CooldownRemains() < (160 - 85)) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (6 - 2)) and not v94.OrbBarrage:IsAvailable()) then
			if (((2927 - (48 + 725)) <= (6584 - 2553)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if (((12381 - 7766) == (2683 + 1932)) and v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 2)) and (v94.ArcaneSurge:CooldownRemains() > (21 + 54))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (928 - (152 + 701))) and not v94.OrbBarrage:IsAvailable()))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((5101 - (430 + 881)) == (192 + 308))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if (((984 - (557 + 338)) < (66 + 155)) and v94.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 - 1)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (6 - 4)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (7 - 4)) and ((v101 > (10 - 5)) or (v102 > (806 - (499 + 302))))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (870 - (39 + 827)))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable()) then
			if (((5670 - 3616) >= (3173 - 1752)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if (((2748 - 2056) < (4694 - 1636)) and v94.PresenceofMind:IsCastable() and v43) then
			if (v21(v94.PresenceofMind) or ((279 + 2975) == (4843 - 3188))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 1)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 1))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable()))) or ((1400 - (103 + 1)) == (5464 - (475 + 79)))) then
			if (((7280 - 3912) == (10777 - 7409)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if (((342 + 2301) < (3358 + 457)) and v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1507 - (1395 + 108))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (8 - 5)) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) then
			if (((3117 - (7 + 1197)) > (215 + 278)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v125()
		if (((1660 + 3095) > (3747 - (27 + 292))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (25 - 16))) then
			v105 = not v105;
		end
		if (((1760 - 379) <= (9934 - 7565)) and v94.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v94.NetherTempestDebuff) or not v14:DebuffUp(v94.NetherTempestDebuff)) and (v13:ArcaneCharges() == (7 - 3)) and (v13:ManaPercentage() < (57 - 27)) and (v13:SpellHaste() < (139.667 - (43 + 96))) and v13:BuffDown(v94.ArcaneSurgeBuff)) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((19755 - 14912) == (9233 - 5149))) then
				return "nether_tempest touch_phase 2";
			end
		end
		if (((3875 + 794) > (103 + 260)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (3 - 1)) and (v13:ManaPercentage() < (12 + 18)) and (v13:SpellHaste() < (0.667 - 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(13 + 27)) or ((138 + 1739) >= (4889 - (1414 + 337)))) then
				return "arcane_orb touch_phase 4";
			end
		end
		if (((6682 - (1642 + 298)) >= (9452 - 5826)) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
			if (v21(v94.PresenceofMind) or ((13060 - 8520) == (2717 - 1801))) then
				return "presence_of_mind touch_phase 6";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((381 + 775) > (3381 + 964))) then
			if (((3209 - (357 + 615)) < (2983 + 1266)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast touch_phase 8";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v94.ArcaneHarmonyBuff) or (v94.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (85 - 50)))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((2299 + 384) < (49 - 26))) then
			if (((558 + 139) <= (57 + 769)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage touch_phase 10";
			end
		end
		if (((695 + 410) <= (2477 - (384 + 917))) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (697 - (128 + 569))) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (1573 - (1407 + 136))) and (v94.TouchoftheMagi:CooldownRemains() > (1917 - (687 + 1200)))) or (v13:ManaPercentage() > (1780 - (556 + 1154)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
			if (((11887 - 8508) <= (3907 - (9 + 86))) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
				return "arcane_missiles interrupt touch_phase 12";
			end
		end
		if ((v94.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v94.ClearcastingBuff) > (422 - (275 + 146))) and v94.ConjureManaGem:IsAvailable() and v95.ManaGem:CooldownUp()) or ((129 + 659) >= (1680 - (29 + 35)))) then
			if (((8216 - 6362) <= (10092 - 6713)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
				return "arcane_missiles touch_phase 12";
			end
		end
		if (((20081 - 15532) == (2963 + 1586)) and v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.NetherPrecisionBuff))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((4034 - (53 + 959)) >= (3432 - (312 + 96)))) then
				return "arcane_blast touch_phase 14";
			end
		end
		if (((8365 - 3545) > (2483 - (147 + 138))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > v94.ArcaneMissiles:CastTime()) or not v94.PresenceofMind:IsAvailable())) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((1960 - (813 + 86)) >= (4420 + 471))) then
				return "arcane_missiles touch_phase 18";
			end
		end
		if (((2527 - 1163) <= (4965 - (18 + 474))) and v94.ArcaneBlast:IsReady() and v33) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((1213 + 2382) <= (9 - 6))) then
				return "arcane_blast touch_phase 20";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34) or ((5758 - (860 + 226)) == (4155 - (121 + 182)))) then
			if (((192 + 1367) == (2799 - (988 + 252))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage touch_phase 22";
			end
		end
	end
	local function v126()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (1 + 1)) or ((3722 - (49 + 1921)) <= (1678 - (223 + 667)))) then
				if ((v94.ArcaneExplosion:IsCastable() and v35) or ((3959 - (51 + 1)) == (304 - 127))) then
					if (((7430 - 3960) > (1680 - (146 + 979))) and v21(v94.ArcaneExplosion, not v14:IsInRange(3 + 7))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if (((605 - (311 + 294)) == v139) or ((2710 - 1738) == (274 + 371))) then
				if (((4625 - (496 + 947)) >= (3473 - (1233 + 125))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (4 + 5))) then
					v105 = not v105;
				end
				if (((3493 + 400) < (842 + 3587)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4512 - (963 + 682)) < (1590 + 315))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v139 = 1505 - (504 + 1000);
			end
			if ((v139 == (1 + 0)) or ((1636 + 160) >= (383 + 3668))) then
				if (((2386 - 767) <= (3209 + 547)) and v94.ArcaneBarrage:IsReady() and v34 and ((((v101 <= (3 + 1)) or (v102 <= (186 - (156 + 26)))) and (v13:ArcaneCharges() == (2 + 1))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) then
					if (((944 - 340) == (768 - (149 + 15))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (962 - (890 + 70)))) or ((4601 - (39 + 78)) == (1382 - (14 + 468)))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(87 - 47)) or ((12462 - 8003) <= (575 + 538))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v139 = 2 + 0;
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if (((1641 + 1991) > (891 + 2507)) and (v140 == (5 - 2))) then
				if (((4035 + 47) <= (17278 - 12361)) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (1 + 9)) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v114 >= (63 - (12 + 39)))) then
					if (((4496 + 336) >= (4289 - 2903)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
						return "nether_tempest rotation 16";
					end
				end
				if (((487 - 350) == (41 + 96)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (27 + 23)) and not v94.Evocation:IsAvailable() and (v114 > (50 - 30))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1046 + 524) >= (20935 - 16603))) then
						return "arcane_barrage rotation 18";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (1780 - (1596 + 114))) and v105 and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (12 - 7)) and (v114 > (733 - (164 + 549)))) or ((5502 - (1059 + 379)) <= (2257 - 438))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((2585 + 2401) < (266 + 1308))) then
						return "arcane_barrage rotation 20";
					end
				end
				v140 = 396 - (145 + 247);
			end
			if (((3632 + 794) > (80 + 92)) and (v140 == (0 - 0))) then
				if (((113 + 473) > (392 + 63)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (4 - 1)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (790 - (254 + 466))) or (v110 and (v94.TouchoftheMagi:CooldownRemains() > (590 - (544 + 16)))))) then
					if (((2624 - 1798) == (1454 - (294 + 334))) and v21(v94.ArcaneOrb, not v14:IsInRange(293 - (236 + 17)))) then
						return "arcane_orb rotation 2";
					end
				end
				v105 = ((v94.ArcaneSurge:CooldownRemains() > (13 + 17)) and (v94.TouchoftheMagi:CooldownRemains() > (8 + 2))) or false;
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v110 and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (44 - 32))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (56 - 44))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (7 + 5))) and (v114 > (13 + 2))) or ((4813 - (413 + 381)) > (187 + 4254))) then
					if (((4289 - 2272) < (11068 - 6807)) and v21(v94.ShiftingPower, not v14:IsInRange(2010 - (582 + 1388)))) then
						return "shifting_power rotation 4";
					end
				end
				v140 = 1 - 0;
			end
			if (((3376 + 1340) > (444 - (326 + 38))) and (v140 == (2 - 1))) then
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and not v110 and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (64 - 19)) and (v114 > (635 - (47 + 573)))) or ((1237 + 2270) == (13896 - 10624))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(64 - 24)) or ((2540 - (1269 + 395)) >= (3567 - (76 + 416)))) then
						return "shifting_power rotation 6";
					end
				end
				if (((4795 - (319 + 124)) > (5838 - 3284)) and v94.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (1010 - (564 + 443))) and (v14:HealthPercentage() < (96 - 61)) and v94.ArcaneBombardment:IsAvailable()) then
					if (v21(v94.PresenceofMind) or ((4864 - (337 + 121)) < (11845 - 7802))) then
						return "presence_of_mind rotation 8";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (19 - 13))) or ((3800 - (1261 + 650)) >= (1432 + 1951))) then
					if (((3014 - 1122) <= (4551 - (772 + 1045))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 10";
					end
				end
				v140 = 1 + 1;
			end
			if (((2067 - (102 + 42)) < (4062 - (1524 + 320))) and (v140 == (1275 - (1049 + 221)))) then
				if (((2329 - (18 + 138)) > (927 - 548)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and (not v110 or not v108)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((3693 - (67 + 1035)) == (3757 - (136 + 212)))) then
						return "arcane_missiles rotation 30";
					end
				end
				if (((19181 - 14667) > (2663 + 661)) and v94.ArcaneBlast:IsReady() and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((192 + 16) >= (6432 - (240 + 1364)))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((2665 - (1050 + 32)) > (12736 - 9169))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((777 + 536) == (1849 - (331 + 724)))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((257 + 2917) > (3546 - (269 + 375))) and (v140 == (729 - (267 + 458)))) then
				if (((1282 + 2838) <= (8192 - 3932)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffUp(v94.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((1701 - (667 + 151)) > (6275 - (1410 + 87)))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) or ((5517 - (1504 + 393)) >= (13220 - 8329))) then
					if (((11046 - 6788) > (1733 - (461 + 335))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (8 + 52)) and v105 and (v94.TouchoftheMagi:CooldownRemains() > (1771 - (1730 + 31))) and (v94.Evocation:CooldownRemains() > (1707 - (728 + 939))) and (v114 > (70 - 50))) or ((9875 - 5006) < (2075 - 1169))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((2293 - (138 + 930)) > (3864 + 364))) then
						return "arcane_barrage rotation 26";
					end
				end
				v140 = 4 + 1;
			end
			if (((2853 + 475) > (9138 - 6900)) and (v140 == (1768 - (459 + 1307)))) then
				if (((5709 - (474 + 1396)) > (2453 - 1048)) and v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v14:HealthPercentage() < (33 + 2)) and v94.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (1 + 2))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((3703 - 2410) <= (65 + 442))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (130 - 100)) and (v94.TouchoftheMagi:CooldownRemains() > (621 - (562 + 29)))) or (v13:ManaPercentage() > (60 + 10))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((4315 - (374 + 1045)) < (638 + 167))) then
					if (((7191 - 4875) == (2954 - (448 + 190))) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) == v112)) or ((830 + 1740) == (692 + 841))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((576 + 307) == (5613 - 4153))) then
						return "arcane_missiles rotation 14";
					end
				end
				v140 = 8 - 5;
			end
		end
	end
	local function v128()
		if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (1506 - (1307 + 187)))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (47 - 35))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (27 - 15))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (36 - 24))) or (v94.ArcaneOrb:Charges() == (683 - (232 + 451))) or (v94.ArcaneOrb:CooldownRemains() > (12 + 0)))) or ((4081 + 538) <= (1563 - (510 + 54)))) then
			if (v21(v94.ShiftingPower, not v14:IsInRange(80 - 40), true) or ((3446 - (13 + 23)) > (8022 - 3906))) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (7 - 1)) or (v102 > (10 - 4)) or not v94.OrbBarrage:IsAvailable())) or ((1991 - (830 + 258)) >= (10790 - 7731))) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest)) or ((2488 + 1488) < (2431 + 426))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if (((6371 - (860 + 581)) > (8509 - 6202)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v94.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v94.ArcaneArtilleryBuff) + 4 + 1))) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles)) or ((4287 - (237 + 4)) < (3033 - 1742))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v101 <= (9 - 5)) or (v102 <= (7 - 3)) or v13:BuffUp(v94.ClearcastingBuff)) and (v13:ArcaneCharges() == (3 + 0))) or ((2436 + 1805) == (13383 - 9838))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1737 + 2311) > (2302 + 1930))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() == (1426 - (85 + 1341))) and (v94.TouchoftheMagi:CooldownRemains() > (30 - 12))) or ((4942 - 3192) >= (3845 - (45 + 327)))) then
			if (((5974 - 2808) == (3668 - (444 + 58))) and v21(v94.ArcaneOrb, not v14:IsInRange(18 + 22))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if (((304 + 1459) < (1821 + 1903)) and v94.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (28 - 18)))) then
			if (((1789 - (64 + 1668)) <= (4696 - (1227 + 746))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v94.ArcaneExplosion:IsCastable() and v35) or ((6362 - 4292) == (822 - 379))) then
			if (v21(v94.ArcaneExplosion, not v14:IsInRange(504 - (415 + 79))) or ((70 + 2635) == (1884 - (142 + 349)))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v129()
		local v141 = 0 + 0;
		while true do
			if (((0 - 0) == v141) or ((2287 + 2314) < (43 + 18))) then
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) or ((3254 - (1710 + 154)) >= (5062 - (200 + 118)))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi)) or ((794 + 1209) > (6702 - 2868))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (140 - 45)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v114 * (4 + 0))) and not ((v114 > (10 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (1 + 0)))))) or ((25 + 131) > (8477 - 4564))) then
					if (((1445 - (363 + 887)) == (340 - 145)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((14779 - 11674) >= (278 + 1518)) and v94.ArcaneBarrage:IsReady() and v34 and (v114 < (4 - 2))) then
					if (((2993 + 1386) >= (3795 - (674 + 990))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage main 34";
					end
				end
				v141 = 1 + 0;
			end
			if (((1574 + 2270) >= (3237 - 1194)) and (v141 == (1056 - (507 + 548)))) then
				if ((v94.Evocation:IsCastable() and v40 and not v108 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (847 - (289 + 548))) and (v94.TouchoftheMagi:CooldownRemains() < (1838 - (821 + 997)))) or (v94.TouchoftheMagi:CooldownRemains() < (270 - (195 + 60)))) and (v13:ManaPercentage() < (v114 * (2 + 2)))) or ((4733 - (251 + 1250)) <= (8000 - 5269))) then
					if (((3371 + 1534) == (5937 - (809 + 223))) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				if ((v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (43 - 13)) and (v94.ArcaneSurge:CooldownRemains() < v114) and not v95.ManaGem:Exists()) or ((12420 - 8284) >= (14584 - 10173))) then
					if (v21(v94.ConjureManaGem) or ((2179 + 779) == (2104 + 1913))) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((1845 - (14 + 603)) >= (942 - (118 + 11))) and v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (1 + 1)) and v13:BuffUp(v94.ArcaneSurgeBuff)) then
					if (v21(v96.ManaGem) or ((2878 + 577) > (11802 - 7752))) then
						return "mana_gem main 40";
					end
				end
				v141 = 951 - (551 + 398);
			end
			if (((154 + 89) == (87 + 156)) and (v141 == (3 + 0))) then
				if ((v30 and v94.RadiantSpark:IsAvailable() and v106) or ((1007 - 736) > (3621 - 2049))) then
					local v206 = 0 + 0;
					while true do
						if (((10873 - 8134) < (910 + 2383)) and (v206 == (89 - (40 + 49)))) then
							v27 = v124();
							if (v27 or ((15011 - 11069) < (1624 - (99 + 391)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v110 and v94.RadiantSpark:IsAvailable() and v107) or ((2228 + 465) == (21861 - 16888))) then
					local v207 = 0 - 0;
					while true do
						if (((2091 + 55) == (5646 - 3500)) and (v207 == (1604 - (1032 + 572)))) then
							v27 = v123();
							if (v27 or ((2661 - (203 + 214)) == (5041 - (568 + 1249)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 >= v104) or (v102 >= v104))) or ((3837 + 1067) <= (4601 - 2685))) then
					v27 = v126();
					if (((347 - 257) <= (2371 - (913 + 393))) and v27) then
						return v27;
					end
				end
				v141 = 11 - 7;
			end
			if (((6784 - 1982) == (5212 - (269 + 141))) and ((4 - 2) == v141)) then
				if ((v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and v13:PrevGCDP(1982 - (362 + 1619), v94.ArcaneSurge) and (not v109 or (v109 and v13:PrevGCDP(1627 - (950 + 675), v94.ArcaneSurge)))) or ((879 + 1401) <= (1690 - (216 + 963)))) then
					if (v21(v96.ManaGem) or ((2963 - (485 + 802)) <= (1022 - (432 + 127)))) then
						return "mana_gem main 42";
					end
				end
				if (((4942 - (1065 + 8)) == (2150 + 1719)) and not v110 and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * ((1602 - (635 + 966)) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((3 + 0) * v24(v13:HasTier(72 - (5 + 37), 4 - 2) and not v13:HasTier(13 + 17, 5 - 1)))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (22 + 23)) and ((v94.TouchoftheMagi:CooldownRemains() < (v115 * (8 - 4))) or (v94.TouchoftheMagi:CooldownRemains() > (75 - 55))) and ((v101 < v104) or (v102 < v104))) then
					v27 = v122();
					if (((2183 - 1025) <= (6247 - 3634)) and v27) then
						return v27;
					end
				end
				if ((not v110 and (v94.ArcaneSurge:CooldownRemains() > (22 + 8)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v115 * (532 - (318 + 211)))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and ((v101 < v104) or (v102 < v104))) or ((11632 - 9268) <= (3586 - (963 + 624)))) then
					local v208 = 0 + 0;
					while true do
						if ((v208 == (846 - (518 + 328))) or ((11473 - 6551) < (309 - 115))) then
							v27 = v122();
							if (v27 or ((2408 - (301 + 16)) < (90 - 59))) then
								return v27;
							end
							break;
						end
					end
				end
				v141 = 8 - 5;
			end
			if ((v141 == (10 - 6)) or ((2202 + 228) >= (2767 + 2105))) then
				if ((v30 and v110 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 < v104) or (v102 < v104))) or ((10183 - 5413) < (1044 + 691))) then
					v27 = v125();
					if (v27 or ((423 + 4016) <= (7471 - 5121))) then
						return v27;
					end
				end
				if ((v101 >= v104) or (v102 >= v104) or ((1446 + 3033) < (5485 - (829 + 190)))) then
					local v209 = 0 - 0;
					while true do
						if (((3222 - 675) > (1692 - 467)) and (v209 == (0 - 0))) then
							v27 = v128();
							if (((1107 + 3564) > (874 + 1800)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v101 < v104) or (v102 < v104) or ((11218 - 7522) < (3140 + 187))) then
					local v210 = 613 - (520 + 93);
					while true do
						if ((v210 == (276 - (259 + 17))) or ((262 + 4280) == (1069 + 1901))) then
							v27 = v127();
							if (((853 - 601) <= (2568 - (396 + 195))) and v27) then
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
		local v142 = 0 - 0;
		while true do
			if ((v142 == (1764 - (440 + 1321))) or ((3265 - (1059 + 770)) == (17456 - 13681))) then
				v50 = EpicSettings.Settings['useRadiantSpark'];
				v51 = EpicSettings.Settings['useTouchOfTheMagi'];
				v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v142 = 549 - (424 + 121);
			end
			if (((1 + 0) == v142) or ((2965 - (641 + 706)) < (369 + 561))) then
				v39 = EpicSettings.Settings['useConjureManaGem'];
				v40 = EpicSettings.Settings['useEvocation'];
				v41 = EpicSettings.Settings['useManaGem'];
				v42 = EpicSettings.Settings['useNetherTempest'];
				v43 = EpicSettings.Settings['usePresenceOfMind'];
				v92 = EpicSettings.Settings['cancelPOM'];
				v142 = 442 - (249 + 191);
			end
			if (((20574 - 15851) > (1855 + 2298)) and (v142 == (22 - 16))) then
				v68 = EpicSettings.Settings['iceColdHP'] or (427 - (183 + 244));
				v69 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v70 = EpicSettings.Settings['massBarrierHP'] or (730 - (434 + 296));
				v89 = EpicSettings.Settings['useSpellStealTarget'];
				v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v91 = EpicSettings.Settings['mirrorImageBeforePull'];
				v142 = 21 - 14;
			end
			if ((v142 == (512 - (169 + 343))) or ((3204 + 450) >= (8188 - 3534))) then
				v33 = EpicSettings.Settings['useArcaneBlast'];
				v34 = EpicSettings.Settings['useArcaneBarrage'];
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneFamiliar'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useArcaneMissiles'];
				v142 = 2 - 1;
			end
			if (((780 + 171) <= (4242 - 2746)) and (v142 == (1128 - (651 + 472)))) then
				v62 = EpicSettings.Settings['useMassBarrier'];
				v63 = EpicSettings.Settings['useMirrorImage'];
				v64 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
				v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v67 = EpicSettings.Settings['iceBlockHP'] or (483 - (397 + 86));
				v142 = 882 - (423 + 453);
			end
			if ((v142 == (1 + 6)) or ((229 + 1507) == (499 + 72))) then
				v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v142 == (2 + 0)) or ((801 + 95) > (5959 - (50 + 1140)))) then
				v44 = EpicSettings.Settings['useCounterspell'];
				v45 = EpicSettings.Settings['useBlastWave'];
				v46 = EpicSettings.Settings['useDragonsBreath'];
				v47 = EpicSettings.Settings['useArcaneSurge'];
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['useArcaneOrb'];
				v142 = 3 + 0;
			end
			if ((v142 == (3 + 1)) or ((65 + 980) <= (1464 - 444))) then
				v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v57 = EpicSettings.Settings['useAlterTime'];
				v58 = EpicSettings.Settings['usePrismaticBarrier'];
				v59 = EpicSettings.Settings['useGreaterInvisibility'];
				v60 = EpicSettings.Settings['useIceBlock'];
				v61 = EpicSettings.Settings['useIceCold'];
				v142 = 4 + 1;
			end
		end
	end
	local function v131()
		local v143 = 596 - (157 + 439);
		while true do
			if ((v143 == (4 - 1)) or ((3854 - 2694) <= (970 - 642))) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v143 = 922 - (782 + 136);
			end
			if (((4663 - (112 + 743)) > (4095 - (1026 + 145))) and (v143 == (1 + 0))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v143 = 720 - (493 + 225);
			end
			if (((14302 - 10411) < (2993 + 1926)) and ((10 - 6) == v143)) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v143 = 2 + 3;
			end
			if ((v143 == (7 - 2)) or ((3829 - (210 + 1385)) <= (3191 - (1201 + 488)))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v143 == (0 + 0)) or ((4467 - 1955) < (774 - 342))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (585 - (352 + 233));
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v143 = 2 - 1;
			end
			if (((2 + 0) == v143) or ((5254 - 3406) == (1439 - (489 + 85)))) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v143 = 1504 - (277 + 1224);
			end
		end
	end
	local function v132()
		local v144 = 1493 - (663 + 830);
		while true do
			if ((v144 == (2 + 0)) or ((11464 - 6782) <= (5416 - (461 + 414)))) then
				v100 = v14:GetEnemiesInSplashRange(1 + 4);
				v103 = v13:GetEnemiesInRange(17 + 23);
				if (v29 or ((289 + 2737) >= (3989 + 57))) then
					local v211 = 250 - (172 + 78);
					while true do
						if (((3237 - 1229) > (235 + 403)) and (v211 == (0 - 0))) then
							v101 = v26(v14:GetEnemiesInSplashRangeCount(2 + 3), #v103);
							v102 = #v103;
							break;
						end
					end
				else
					v101 = 1 + 0;
					v102 = 1 - 0;
				end
				if (((2234 - 459) <= (813 + 2420)) and (v98.TargetIsValid() or v13:AffectingCombat())) then
					if (v13:AffectingCombat() or v72 or ((2513 + 2030) == (711 + 1286))) then
						local v215 = 0 - 0;
						local v216;
						while true do
							if ((v215 == (2 - 1)) or ((952 + 2150) < (416 + 312))) then
								if (((792 - (133 + 314)) == (60 + 285)) and v27) then
									return v27;
								end
								break;
							end
							if ((v215 == (213 - (199 + 14))) or ((10120 - 7293) < (1927 - (647 + 902)))) then
								v216 = v72 and v94.RemoveCurse:IsReady() and v32;
								v27 = v98.FocusUnit(v216, nil, 60 - 40, nil, 253 - (85 + 148), v94.ArcaneIntellect);
								v215 = 1290 - (426 + 863);
							end
						end
					end
					v113 = v10.BossFightRemains(nil, true);
					v114 = v113;
					if ((v114 == (52000 - 40889)) or ((5130 - (873 + 781)) < (3477 - 880))) then
						v114 = v10.FightRemains(v103, false);
					end
				end
				v144 = 7 - 4;
			end
			if (((1276 + 1803) < (17710 - 12916)) and (v144 == (1 - 0))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (((14412 - 9558) > (6411 - (414 + 1533))) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v144 = 2 + 0;
			end
			if (((555 - (443 + 112)) == v144) or ((6391 - (888 + 591)) == (9710 - 5952))) then
				v130();
				v131();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v144 = 1 + 0;
			end
			if (((474 - 348) <= (1360 + 2122)) and (v144 == (2 + 1))) then
				v115 = v13:GCD();
				if (v73 or ((254 + 2120) == (8334 - 3960))) then
					if (((2917 - 1342) == (3253 - (136 + 1542))) and v93) then
						local v217 = 0 - 0;
						while true do
							if ((v217 == (0 + 0)) or ((3551 - 1317) == (1053 + 402))) then
								v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 516 - (68 + 418));
								if (v27 or ((2891 - 1824) > (3227 - 1448))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (((1866 + 295) >= (2026 - (770 + 322))) and (not v13:AffectingCombat() or v28)) then
					local v212 = 0 + 0;
					while true do
						if (((467 + 1145) == (221 + 1391)) and (v212 == (0 - 0))) then
							if (((8438 - 4086) >= (7715 - 4882)) and v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) then
								if (v21(v94.ArcaneIntellect) or ((11851 - 8629) < (1712 + 1361))) then
									return "arcane_intellect group_buff";
								end
							end
							if (((1114 - 370) <= (1412 + 1530)) and v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) then
								if (v21(v94.ArcaneFamiliar) or ((1124 + 709) <= (1036 + 286))) then
									return "arcane_familiar precombat 2";
								end
							end
							v212 = 3 - 2;
						end
						if ((v212 == (1 - 0)) or ((1172 + 2295) <= (4859 - 3804))) then
							if (((11705 - 8164) == (1457 + 2084)) and v94.ConjureManaGem:IsCastable() and v39) then
								if (v21(v94.ConjureManaGem) or ((17601 - 14044) >= (4834 - (762 + 69)))) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
					end
				end
				if (v98.TargetIsValid() or ((2127 - 1470) >= (1438 + 230))) then
					local v213 = 0 + 0;
					while true do
						if ((v213 == (2 - 1)) or ((324 + 703) > (62 + 3796))) then
							v27 = v116();
							if (v27 or ((14236 - 10582) < (607 - (8 + 149)))) then
								return v27;
							end
							v213 = 1322 - (1199 + 121);
						end
						if (((3199 - 1308) < (10052 - 5599)) and (v213 == (1 + 1))) then
							if (v73 or ((11208 - 8068) < (4939 - 2810))) then
								if (v93 or ((2261 + 294) < (3047 - (518 + 1289)))) then
									v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 51 - 21);
									if (v27 or ((628 + 4099) <= (6896 - 2174))) then
										return v27;
									end
								end
							end
							if (((546 + 194) < (5406 - (304 + 165))) and v74) then
								v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseOver, 29 + 1, true);
								if (((3818 - (54 + 106)) >= (2249 - (1618 + 351))) and v27) then
									return v27;
								end
							end
							v213 = 3 + 0;
						end
						if ((v213 == (1016 - (10 + 1006))) or ((223 + 662) >= (145 + 886))) then
							if (((11521 - 7967) >= (1558 - (912 + 121))) and v72 and v32 and v94.RemoveCurse:IsAvailable()) then
								local v218 = 0 + 0;
								while true do
									if (((3703 - (1140 + 149)) <= (1902 + 1070)) and (v218 == (0 - 0))) then
										if (((657 + 2872) <= (12108 - 8570)) and v15) then
											local v222 = 0 - 0;
											while true do
												if ((v222 == (0 + 0)) or ((9928 - 7067) < (644 - (165 + 21)))) then
													v27 = v118();
													if (((1828 - (61 + 50)) <= (1864 + 2661)) and v27) then
														return v27;
													end
													break;
												end
											end
										end
										if ((v16 and v16:Exists() and v16:IsAPlayer() and v98.UnitHasCurseDebuff(v16)) or ((15147 - 11969) <= (3070 - 1546))) then
											if (((1672 + 2582) > (1830 - (1295 + 165))) and v94.RemoveCurse:IsReady()) then
												if (v21(v96.RemoveCurseMouseover) or ((374 + 1261) == (715 + 1062))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v13:AffectingCombat() and v28) or ((4735 - (819 + 578)) >= (5395 - (331 + 1071)))) then
								local v219 = 743 - (588 + 155);
								while true do
									if (((2436 - (546 + 736)) <= (3412 - (1834 + 103))) and (v219 == (0 + 0))) then
										v27 = v120();
										if (v27 or ((7785 - 5175) < (2996 - (1536 + 230)))) then
											return v27;
										end
										break;
									end
								end
							end
							v213 = 492 - (128 + 363);
						end
						if (((1 + 2) == v213) or ((3602 - 2154) == (797 + 2286))) then
							if (((5199 - 2060) > (2696 - 1780)) and v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) then
								if (((7174 - 4220) == (2028 + 926)) and v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							if (((1126 - (615 + 394)) <= (2611 + 281)) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) then
								local v220 = 0 + 0;
								local v221;
								while true do
									if ((v220 == (2 - 1)) or ((2054 - 1601) > (5313 - (59 + 592)))) then
										if (((2922 - 1602) > (1095 - 500)) and v90 and v94.TimeWarp:IsReady() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v114 <= (29 + 11)) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v114 <= (v94.ArcaneSurge:CooldownRemains() + (185 - (70 + 101))))))) then
											if (v21(v94.TimeWarp, not v14:IsInRange(98 - 58)) or ((2269 + 930) < (1481 - 891))) then
												return "time_warp main 4";
											end
										end
										if ((v80 and ((v83 and v30) or not v83) and (v78 < v114)) or ((5034 - (123 + 118)) < (8 + 22))) then
											local v223 = 0 + 0;
											while true do
												if (((1399 - (653 + 746)) == v223) or ((3171 - 1475) <= (1525 - 466))) then
													if (((6273 - 3930) == (1034 + 1309)) and v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (2 + 0)) or (v102 >= (2 + 0)))) then
														if (v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment)) or ((128 + 915) > (561 + 3030))) then
															return "lights_judgment main 6";
														end
													end
													if ((v94.Berserking:IsCastable() and ((v13:PrevGCDP(2 - 1, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) or ((2751 + 139) >= (7535 - 3456))) then
														if (((5708 - (885 + 349)) <= (3789 + 981)) and v21(v94.Berserking)) then
															return "berserking main 8";
														end
													end
													v223 = 2 - 1;
												end
												if (((2 - 1) == v223) or ((5910 - (915 + 53)) == (4704 - (768 + 33)))) then
													if (v13:PrevGCDP(3 - 2, v94.ArcaneSurge) or ((436 - 188) > (5173 - (287 + 41)))) then
														local v224 = 847 - (638 + 209);
														while true do
															if (((816 + 753) == (3255 - (96 + 1590))) and ((1672 - (741 + 931)) == v224)) then
																if (v94.BloodFury:IsCastable() or ((2420 + 2507) <= (9176 - 5955))) then
																	if (v21(v94.BloodFury) or ((8315 - 6535) > (1196 + 1591))) then
																		return "blood_fury main 10";
																	end
																end
																if (v94.Fireblood:IsCastable() or ((1692 + 2245) <= (393 + 837))) then
																	if (v21(v94.Fireblood) or ((10006 - 7369) < (555 + 1151))) then
																		return "fireblood main 12";
																	end
																end
																v224 = 1 + 0;
															end
															if ((v224 == (4 - 3)) or ((2396 + 273) <= (2903 - (64 + 430)))) then
																if (v94.AncestralCall:IsCastable() or ((1391 + 10) > (5059 - (106 + 257)))) then
																	if (v21(v94.AncestralCall) or ((2326 + 954) < (2042 - (496 + 225)))) then
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
										if (((10074 - 5147) >= (11218 - 8915)) and (v78 < v114)) then
											if (((5120 - (256 + 1402)) >= (2931 - (30 + 1869))) and v81 and ((v30 and v82) or not v82)) then
												v27 = v119();
												if (v27 or ((2446 - (213 + 1156)) >= (2199 - (96 + 92)))) then
													return v27;
												end
											end
										end
										v27 = v121();
										v220 = 1 + 1;
									end
									if (((2442 - (142 + 757)) < (1968 + 447)) and (v220 == (1 + 1))) then
										if (v27 or ((4523 - (32 + 47)) < (3992 - (1053 + 924)))) then
											return v27;
										end
										v27 = v129();
										if (v27 or ((4114 + 86) == (4015 - 1683))) then
											return v27;
										end
										break;
									end
									if ((v220 == (1648 - (685 + 963))) or ((2598 - 1320) >= (2051 - 735))) then
										if (((2791 - (541 + 1168)) == (2679 - (645 + 952))) and v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) then
											if (((2166 - (669 + 169)) <= (16897 - 12019)) and v21(v96.UseWeapon, nil)) then
												return "Using Weapon Macro";
											end
										end
										v221 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
										if (((8874 - 4787) >= (458 + 897)) and v221) then
											return v221;
										end
										if ((v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes)) or ((131 + 459) > (5415 - (181 + 584)))) then
											if (v21(v94.IceFloes) or ((5169 - (665 + 730)) <= (10568 - 6901))) then
												return "ice_floes movement";
											end
										end
										v220 = 1 - 0;
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
	local function v133()
		local v145 = 1350 - (540 + 810);
		while true do
			if (((5077 - 3807) < (5900 - 3754)) and (v145 == (0 + 0))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(265 - (166 + 37), v132, v133);
end;
return v0["Epix_Mage_Arcane.lua"]();

