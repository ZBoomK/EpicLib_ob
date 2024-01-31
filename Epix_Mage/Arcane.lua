local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2335 + 640) > (1694 - (73 + 156))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2515 - (721 + 90)) < (18 + 1495))) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if (((1157 - (224 + 246)) == (1112 - 425)) and (v5 == (1 - 0))) then
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
	local v93 = v17.Mage.Arcane;
	local v94 = v18.Mage.Arcane;
	local v95 = v22.Mage.Arcane;
	local v96 = {};
	local v97 = v19.Commons.Everyone;
	local function v98()
		if (v93.RemoveCurse:IsAvailable() or ((119 + 537) >= (80 + 3250))) then
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
	local v103 = 3 + 0;
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v13:HasTier(57 - 28, 12 - 8);
	local v110 = (225513 - (203 + 310)) - (((26993 - (1238 + 755)) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((13973 + 186027) * v24(not v109)));
	local v111 = 1537 - (709 + 825);
	local v112 = 20474 - 9363;
	local v113 = 16185 - 5074;
	local v114;
	v10:RegisterForEvent(function()
		local v132 = 864 - (196 + 668);
		while true do
			if ((v132 == (7 - 5)) or ((5161 - 2669) <= (1168 - (171 + 662)))) then
				v113 = 11204 - (4 + 89);
				break;
			end
			if (((15148 - 10826) >= (933 + 1629)) and (v132 == (0 - 0))) then
				v104 = false;
				v107 = true;
				v132 = 1 + 0;
			end
			if ((v132 == (1487 - (35 + 1451))) or ((5090 - (28 + 1425)) >= (5763 - (941 + 1052)))) then
				v110 = (215744 + 9256) - (((26514 - (822 + 692)) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((285533 - 85533) * v24(not v109)));
				v112 = 5234 + 5877;
				v132 = 299 - (45 + 252);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v109 = not v13:HasTier(29 + 0, 2 + 2);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		if ((v93.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v93.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((5789 - 3410) > (5011 - (114 + 319)))) then
			if (v21(v93.PrismaticBarrier) or ((692 - 209) > (951 - 208))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((1565 + 889) > (860 - 282)) and v93.MassBarrier:IsCastable() and v62 and v13:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v70, 3 - 1)) then
			if (((2893 - (556 + 1407)) < (5664 - (741 + 465))) and v21(v93.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if (((1127 - (170 + 295)) <= (513 + 459)) and v93.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
			if (((4014 + 356) == (10759 - 6389)) and v21(v93.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if ((v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) or ((3948 + 814) <= (553 + 308))) then
			if (v21(v93.IceColdAbility) or ((800 + 612) == (5494 - (957 + 273)))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v93.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((848 + 2320) < (862 + 1291))) then
			if (v21(v93.MirrorImage) or ((18960 - 13984) < (3509 - 2177))) then
				return "mirror_image defensive 4";
			end
		end
		if (((14136 - 9508) == (22916 - 18288)) and v93.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) then
			if (v21(v93.GreaterInvisibility) or ((1834 - (389 + 1391)) == (248 + 147))) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((9 + 73) == (186 - 104)) and v93.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) then
			if (v21(v93.AlterTime) or ((1532 - (783 + 168)) < (946 - 664))) then
				return "alter_time defensive 6";
			end
		end
		if ((v94.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v86)) or ((4534 + 75) < (2806 - (309 + 2)))) then
			if (((3537 - 2385) == (2364 - (1090 + 122))) and v21(v95.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((615 + 1281) <= (11492 - 8070)) and v83 and (v13:HealthPercentage() <= v85)) then
			local v187 = 0 + 0;
			while true do
				if ((v187 == (1118 - (628 + 490))) or ((178 + 812) > (4010 - 2390))) then
					if ((v87 == "Refreshing Healing Potion") or ((4007 - 3130) > (5469 - (431 + 343)))) then
						if (((5434 - 2743) >= (5354 - 3503)) and v94.RefreshingHealingPotion:IsReady()) then
							if (v21(v95.RefreshingHealingPotion) or ((2359 + 626) >= (622 + 4234))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((5971 - (556 + 1139)) >= (1210 - (6 + 9))) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((592 + 2640) <= (2403 + 2287)) and v94.DreamwalkersHealingPotion:IsReady()) then
							if (v21(v95.RefreshingHealingPotion) or ((1065 - (28 + 141)) >= (1219 + 1927))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		if (((3778 - 717) >= (2096 + 862)) and v93.RemoveCurse:IsReady() and v97.DispellableFriendlyUnit(1337 - (486 + 831))) then
			v97.Wait(2 - 1);
			if (((11220 - 8033) >= (122 + 522)) and v21(v95.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v117()
		local v133 = 0 - 0;
		while true do
			if (((1907 - (668 + 595)) <= (634 + 70)) and (v133 == (0 + 0))) then
				v27 = v97.HandleTopTrinket(v96, v30, 109 - 69, nil);
				if (((1248 - (23 + 267)) > (2891 - (1129 + 815))) and v27) then
					return v27;
				end
				v133 = 388 - (371 + 16);
			end
			if (((6242 - (1326 + 424)) >= (5026 - 2372)) and (v133 == (3 - 2))) then
				v27 = v97.HandleBottomTrinket(v96, v30, 158 - (88 + 30), nil);
				if (((4213 - (720 + 51)) >= (3343 - 1840)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v118()
		local v134 = 1776 - (421 + 1355);
		while true do
			if ((v134 == (0 - 0)) or ((1558 + 1612) <= (2547 - (286 + 797)))) then
				if ((v93.MirrorImage:IsCastable() and v90 and v63) or ((17536 - 12739) == (7267 - 2879))) then
					if (((990 - (397 + 42)) <= (213 + 468)) and v21(v93.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if (((4077 - (24 + 776)) > (626 - 219)) and v93.ArcaneBlast:IsReady() and v33 and not v93.SiphonStorm:IsAvailable()) then
					if (((5480 - (222 + 563)) >= (3117 - 1702)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 4";
					end
				end
				v134 = 1 + 0;
			end
			if ((v134 == (192 - (23 + 167))) or ((5010 - (690 + 1108)) <= (341 + 603))) then
				if ((v93.ArcaneBlast:IsReady() and v33) or ((2554 + 542) <= (2646 - (40 + 808)))) then
					if (((583 + 2954) == (13525 - 9988)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if (((3668 + 169) >= (831 + 739)) and (v134 == (1 + 0))) then
				if ((v93.Evocation:IsReady() and v40 and (v93.SiphonStorm:IsAvailable())) or ((3521 - (47 + 524)) == (2474 + 1338))) then
					if (((12910 - 8187) >= (3465 - 1147)) and v21(v93.Evocation)) then
						return "evocation precombat 6";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((4622 - 2595) > (4578 - (1165 + 561)))) then
					if (v21(v93.ArcaneOrb, not v14:IsInRange(2 + 38)) or ((3518 - 2382) > (1648 + 2669))) then
						return "arcane_orb precombat 8";
					end
				end
				v134 = 481 - (341 + 138);
			end
		end
	end
	local function v119()
		local v135 = 0 + 0;
		while true do
			if (((9798 - 5050) == (5074 - (89 + 237))) and (v135 == (3 - 2))) then
				if (((7865 - 4129) <= (5621 - (581 + 300))) and v14:DebuffUp(v93.TouchoftheMagiDebuff) and v107) then
					v107 = false;
				end
				v108 = v93.ArcaneBlast:CastTime() < v114;
				break;
			end
			if ((v135 == (1220 - (855 + 365))) or ((8051 - 4661) <= (1000 + 2060))) then
				if ((((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (1235 - (1030 + 205))) or (v13:ArcaneCharges() >= (3 + 0))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 0)))) or ((1285 - (156 + 130)) > (6118 - 3425))) then
					v105 = true;
				elseif (((780 - 317) < (1230 - 629)) and v105 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (2 + 5)) and v93.RadiantSpark:CooldownDown()) then
					v105 = false;
				end
				if (((v13:ArcaneCharges() > (2 + 1)) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (76 - (10 + 59)))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (2 + 3))) or (v93.ArcaneSurge:CooldownRemains() > (196 - 156)))) or ((3346 - (671 + 492)) < (547 + 140))) then
					v106 = true;
				elseif (((5764 - (369 + 846)) == (1205 + 3344)) and v106 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (6 + 1)) and v93.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				v135 = 1946 - (1036 + 909);
			end
		end
	end
	local function v120()
		local v136 = 0 + 0;
		while true do
			if (((7843 - 3171) == (4875 - (11 + 192))) and ((0 + 0) == v136)) then
				if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(176 - (135 + 40), v93.ArcaneBarrage))) or ((8886 - 5218) < (239 + 156))) then
					if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((9177 - 5011) == (682 - 227))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (v93.RadiantSpark:CooldownUp() or ((4625 - (50 + 126)) == (7415 - 4752))) then
					v104 = v93.ArcaneSurge:CooldownRemains() < (3 + 7);
				end
				if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) or ((5690 - (1233 + 180)) < (3958 - (522 + 447)))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(1461 - (107 + 1314)), true) or ((404 + 466) >= (12642 - 8493))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if (((940 + 1272) < (6320 - 3137)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and v93.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (((18382 - 13736) > (4902 - (716 + 1194))) and v21(v93.ArcaneOrb, not v14:IsInRange(1 + 39))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				v136 = 1 + 0;
			end
			if (((1937 - (74 + 429)) < (5991 - 2885)) and (v136 == (1 + 0))) then
				if (((1798 - 1012) < (2139 + 884)) and v93.ArcaneBlast:IsReady() and v33 and v93.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (5 - 3)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((6037 - 3595) < (507 - (279 + 154)))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((5313 - (454 + 324)) == (3568 + 967)) and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (17 - (12 + 5))) and (v13:ManaPercentage() > (17 + 13)) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((7666 - 4657) <= (778 + 1327))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				if (((2923 - (277 + 816)) < (15677 - 12008)) and v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1188 - (1058 + 125))) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (2 + 4)))) and v13:HasTier(1006 - (815 + 160), 17 - 13)) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((3394 - 1964) >= (862 + 2750))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((7842 - 5159) >= (4358 - (41 + 1857))) and v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (1910 - (1222 + 671))) and not v13:HasTier(77 - 47, 5 - 1)) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2986 - (229 + 953)) >= (5049 - (1111 + 663)))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				v136 = 1581 - (874 + 705);
			end
			if ((v136 == (1 + 1)) or ((967 + 450) > (7542 - 3913))) then
				if (((135 + 4660) > (1081 - (642 + 37))) and v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (1 + 1)) and (v93.RadiantSpark:CooldownRemains() < (1 + 4)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (14 - 8)))) and not v13:HasTier(484 - (233 + 221), 8 - 4)) then
					if (((4237 + 576) > (5106 - (718 + 823))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if (((2462 + 1450) == (4717 - (266 + 539))) and v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (42 - 27)) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1230 - (636 + 589))))) and (v93.ArcaneSurge:CooldownRemains() < (71 - 41))) then
					if (((5818 - 2997) <= (3823 + 1001)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if (((632 + 1106) <= (3210 - (657 + 358))) and v93.ArcaneMissiles:IsReady() and v38 and v93.RadiantSpark:CooldownUp() and v13:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v13:BuffDown(v93.NetherPrecisionBuff) or (v13:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v13:HasTier(79 - 49, 8 - 4)) then
					if (((1228 - (1151 + 36)) <= (2915 + 103)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if (((564 + 1581) <= (12256 - 8152)) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
					if (((4521 - (1552 + 280)) < (5679 - (64 + 770))) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true)) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v136 = 3 + 0;
			end
			if ((v136 == (8 - 4)) or ((413 + 1909) > (3865 - (157 + 1086)))) then
				if ((v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((9074 - 4540) == (9118 - 7036))) then
					if (v21(v93.PresenceofMind) or ((2409 - 838) > (2548 - 681))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.PresenceofMindBuff))) or ((3473 - (599 + 220)) >= (5965 - 2969))) then
					if (((5909 - (1813 + 118)) > (1538 + 566)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				if (((4212 - (841 + 376)) > (2159 - 618)) and v93.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v93.NetherPrecisionBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v14:DebuffDown(v93.RadiantSparkVulnerability) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 3)) and v13:PrevGCDP(2 - 1, v93.ArcaneBlast)))) then
					if (((4108 - (464 + 395)) > (2445 - 1492)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33) or ((1572 + 1701) > (5410 - (467 + 370)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((6511 - 3360) < (943 + 341))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v136 == (10 - 7)) or ((289 + 1561) == (3556 - 2027))) then
				if (((1341 - (150 + 370)) < (3405 - (74 + 1208))) and v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (73 - 43)) and (v93.ArcaneEcho:IsAvailable())) then
					if (((4277 - 3375) < (1655 + 670)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((1248 - (14 + 376)) <= (5137 - 2175)) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) then
					if (v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge)) or ((2554 + 1392) < (1132 + 156))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1 + 0, v93.ArcaneSurge) or v13:PrevGCDP(2 - 1, v93.NetherTempest) or v13:PrevGCDP(1 + 0, v93.RadiantSpark))) or ((3320 - (23 + 55)) == (1343 - 776))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((566 + 281) >= (1135 + 128))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v93.RadiantSparkVulnerability) and (v14:DebuffStack(v93.RadiantSparkVulnerability) < (5 - 1))) or ((709 + 1544) == (2752 - (652 + 249)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((5584 - 3497) > (4240 - (708 + 1160)))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				v136 = 10 - 6;
			end
		end
	end
	local function v121()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (29 - (10 + 17))) or ((999 + 3446) < (5881 - (1400 + 332)))) then
				if ((v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v13:PrevGCDP(7 - 3, v93.RadiantSpark) and not v108) or v13:PrevGCDP(1913 - (242 + 1666), v93.RadiantSpark))) or v13:PrevGCDP(1 + 0, v93.NetherTempest))) or ((667 + 1151) == (73 + 12))) then
					if (((1570 - (850 + 90)) < (3725 - 1598)) and v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and (v93.ArcaneBlast:CastTime() >= v13:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (1425 - (360 + 1030)))) and ((v93.NetherTempest:IsAvailable() and v13:PrevGCDP(6 + 0, v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v13:PrevGCDP(13 - 8, v93.RadiantSpark))) and not (v13:IsCasting(v93.ArcaneSurge) and (v13:CastRemains() < (0.5 - 0)) and not v108)) or ((3599 - (909 + 752)) == (3737 - (109 + 1114)))) then
					if (((7790 - 3535) >= (22 + 33)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((3241 - (6 + 236)) > (729 + 427)) and v93.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (4 + 0))) then
					if (((5542 - 3192) > (2017 - 862)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((5162 - (1076 + 57)) <= (799 + 4054)) and v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and v13:PrevGCDP(690 - (579 + 110), v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 + 0))) or (v13:GCDRemains() <= (0.2 + 0)))) then
					if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((274 + 242) > (3841 - (174 + 233)))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v137 = 8 - 5;
			end
			if (((7101 - 3055) >= (1349 + 1684)) and ((1175 - (663 + 511)) == v137)) then
				if ((v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (2 + 0)) and (v93.RadiantSpark:CooldownRemains() < (2 + 3)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (18 - 12)))) or ((1647 + 1072) <= (3406 - 1959))) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((10007 - 5873) < (1874 + 2052))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (29 - 14)) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)))) and (v93.ArcaneSurge:CooldownRemains() < (3 + 27))) or ((886 - (478 + 244)) >= (3302 - (440 + 77)))) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((239 + 286) == (7718 - 5609))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if (((1589 - (655 + 901)) == (7 + 26)) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
					if (((2339 + 715) <= (2712 + 1303)) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((7537 - 5666) < (4827 - (695 + 750))) and v93.NetherTempest:IsReady() and v42 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (51 - 36)) and ((not v108 and v13:PrevGCDP(6 - 2, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v13:PrevGCDP(20 - 15, v93.RadiantSpark))) then
					if (((1644 - (285 + 66)) <= (5048 - 2882)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v137 = 1312 - (682 + 628);
			end
			if ((v137 == (0 + 0)) or ((2878 - (176 + 123)) < (52 + 71))) then
				if ((v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (33 + 12)) and v14:DebuffDown(v93.NetherTempestDebuff) and v107 and v13:BloodlustUp()) or ((1115 - (239 + 30)) >= (644 + 1724))) then
					if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((3857 + 155) <= (5943 - 2585))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((4661 - 3167) <= (3320 - (306 + 9))) and v107 and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((542 + 2569) == (1310 + 824))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((1134 + 1221) == (6734 - 4379)) and v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1380 - (1140 + 235))) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (4 + 2)))) and v13:HasTier(29 + 2, 2 + 2)) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((640 - (33 + 19)) <= (156 + 276))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if (((14377 - 9580) >= (1716 + 2179)) and v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (29 - 14))) then
					if (((3355 + 222) == (4266 - (586 + 103))) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v137 = 1 + 0;
			end
			if (((11680 - 7886) > (5181 - (1309 + 179))) and (v137 == (5 - 2))) then
				if ((v93.ArcaneBlast:IsReady() and v33) or ((555 + 720) == (11010 - 6910))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((1202 + 389) >= (7606 - 4026))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if (((1958 - 975) <= (2417 - (295 + 314))) and v93.ArcaneBarrage:IsReady() and v34) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((5280 - 3130) <= (3159 - (1300 + 662)))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if (((5524 - (1178 + 577)) >= (610 + 563)) and (v138 == (5 - 3))) then
				if (((2890 - (851 + 554)) == (1314 + 171)) and v93.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 1)) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 - 1)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (305 - (115 + 187))) and ((v100 > (4 + 1)) or (v101 > (5 + 0)))) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (15 - 11))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((4476 - (160 + 1001)) <= (2434 + 348))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				if ((v93.PresenceofMind:IsCastable() and v43) or ((605 + 271) >= (6067 - 3103))) then
					if (v21(v93.PresenceofMind) or ((2590 - (237 + 121)) > (3394 - (525 + 372)))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 - 1)) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (9 - 6))) and not v93.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) or ((2252 - (96 + 46)) <= (1109 - (643 + 134)))) then
					if (((1331 + 2355) > (7605 - 4433)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (14 - 10)) and v13:BuffUp(v93.ArcaneSurgeBuff)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) or ((8779 - 4305) < (1676 - 856))) then
					if (((4998 - (316 + 403)) >= (1916 + 966)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v138 == (2 - 1)) or ((734 + 1295) >= (8867 - 5346))) then
				if ((v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (11 + 4)) and (v93.ArcaneEcho:IsAvailable())) or ((657 + 1380) >= (16084 - 11442))) then
					if (((8214 - 6494) < (9260 - 4802)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if ((v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) or ((25 + 411) > (5947 - 2926))) then
					if (((35 + 678) <= (2491 - 1644)) and v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				if (((2171 - (12 + 5)) <= (15656 - 11625)) and v93.ArcaneBarrage:IsReady() and v34 and (v93.ArcaneSurge:CooldownRemains() < (159 - 84)) and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4)) and not v93.OrbBarrage:IsAvailable()) then
					if (((11444 - 6829) == (937 + 3678)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1975 - (1656 + 317))) and (v93.ArcaneSurge:CooldownRemains() > (67 + 8))) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 0)) and (v93.ArcaneSurge:CooldownRemains() < (199 - 124)) and not v93.OrbBarrage:IsAvailable()))) or ((18652 - 14862) == (854 - (5 + 349)))) then
					if (((422 - 333) < (1492 - (266 + 1005))) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				v138 = 2 + 0;
			end
			if (((7008 - 4954) >= (1870 - 449)) and (v138 == (1696 - (561 + 1135)))) then
				if (((901 - 209) < (10051 - 6993)) and v13:BuffUp(v93.PresenceofMindBuff) and v91 and (v13:PrevGCDP(1067 - (507 + 559), v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (188 - 113))) then
					if (v21(v95.CancelPOM) or ((10063 - 6809) == (2043 - (212 + 176)))) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(906 - (250 + 655), v93.ArcaneBarrage))) or ((3533 - 2237) == (8579 - 3669))) then
					if (((5268 - 1900) == (5324 - (1869 + 87))) and v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if (((9166 - 6523) < (5716 - (484 + 1417))) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
					if (((4100 - 2187) > (825 - 332)) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true)) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				if (((5528 - (48 + 725)) > (5599 - 2171)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (39 - 24)) and (v13:ArcaneCharges() < (2 + 1))) then
					if (((3690 - 2309) <= (663 + 1706)) and v21(v93.ArcaneOrb, not v14:IsInRange(12 + 28))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				v138 = 854 - (152 + 701);
			end
		end
	end
	local function v123()
		if ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (1320 - (430 + 881))) or ((1855 + 2988) == (4979 - (557 + 338)))) then
			v104 = not v104;
		end
		if (((1381 + 3288) > (1022 - 659)) and v93.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v93.NetherTempestDebuff) or not v14:DebuffUp(v93.NetherTempestDebuff)) and (v13:ArcaneCharges() == (13 - 9)) and (v13:ManaPercentage() < (79 - 49)) and (v13:SpellHaste() < (0.667 - 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) then
			if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((2678 - (499 + 302)) >= (4004 - (39 + 827)))) then
				return "nether_tempest touch_phase 2";
			end
		end
		if (((13090 - 8348) >= (8098 - 4472)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (7 - 5)) and (v13:ManaPercentage() < (46 - 16)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(117 - 77)) or ((727 + 3813) == (1449 - 533))) then
				return "arcane_orb touch_phase 4";
			end
		end
		if ((v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((1260 - (103 + 1)) > (4899 - (475 + 79)))) then
			if (((4835 - 2598) < (13596 - 9347)) and v21(v93.PresenceofMind)) then
				return "presence_of_mind touch_phase 6";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((347 + 2336) < (21 + 2))) then
			if (((2200 - (1395 + 108)) <= (2403 - 1577)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast touch_phase 8";
			end
		end
		if (((2309 - (7 + 1197)) <= (513 + 663)) and v93.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (13 + 22)))) and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
			if (((3698 - (27 + 292)) <= (11170 - 7358)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage touch_phase 10";
			end
		end
		if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (125 - 95)) and (v93.TouchoftheMagi:CooldownRemains() > (59 - 29))) or (v13:ManaPercentage() > (133 - 63))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((927 - (43 + 96)) >= (6591 - 4975))) then
			if (((4191 - 2337) <= (2804 + 575)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles interrupt touch_phase 12";
			end
		end
		if (((1285 + 3264) == (8990 - 4441)) and v93.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v93.ClearcastingBuff) > (1 + 0)) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((5662 - 2640) >= (953 + 2071))) then
				return "arcane_missiles touch_phase 12";
			end
		end
		if (((354 + 4466) > (3949 - (1414 + 337))) and v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.NetherPrecisionBuff))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3001 - (1642 + 298)) >= (12749 - 7858))) then
				return "arcane_blast touch_phase 14";
			end
		end
		if (((3923 - 2559) <= (13273 - 8800)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1184 + 2411) <= (3 + 0))) then
				return "arcane_missiles touch_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33) or ((5644 - (357 + 615)) == (2704 + 1148))) then
			if (((3824 - 2265) == (1336 + 223)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast touch_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34) or ((3754 - 2002) <= (631 + 157))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((266 + 3641) == (112 + 65))) then
				return "arcane_barrage touch_phase 22";
			end
		end
	end
	local function v124()
		if (((4771 - (384 + 917)) > (1252 - (128 + 569))) and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (1552 - (1407 + 136)))) then
			v104 = not v104;
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff)) or ((2859 - (687 + 1200)) == (2355 - (556 + 1154)))) then
			if (((11194 - 8012) >= (2210 - (9 + 86))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles aoe_touch_phase 2";
			end
		end
		if (((4314 - (275 + 146)) < (721 + 3708)) and v93.ArcaneBarrage:IsReady() and v34 and ((((v100 <= (68 - (29 + 35))) or (v101 <= (17 - 13))) and (v13:ArcaneCharges() == (8 - 5))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((12656 - 9789) < (1241 + 664))) then
				return "arcane_barrage aoe_touch_phase 4";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (1014 - (53 + 959)))) or ((2204 - (312 + 96)) >= (7030 - 2979))) then
			if (((1904 - (147 + 138)) <= (4655 - (813 + 86))) and v21(v93.ArcaneOrb, not v14:IsInRange(37 + 3))) then
				return "arcane_orb aoe_touch_phase 6";
			end
		end
		if (((1118 - 514) == (1096 - (18 + 474))) and v93.ArcaneExplosion:IsCastable() and v35) then
			if (v21(v93.ArcaneExplosion, not v14:IsInRange(4 + 6)) or ((14635 - 10151) == (1986 - (860 + 226)))) then
				return "arcane_explosion aoe_touch_phase 8";
			end
		end
	end
	local function v125()
		local v139 = 303 - (121 + 182);
		while true do
			if ((v139 == (1 + 4)) or ((5699 - (988 + 252)) <= (126 + 987))) then
				if (((1138 + 2494) > (5368 - (49 + 1921))) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) then
					if (((4972 - (223 + 667)) <= (4969 - (51 + 1))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 30";
					end
				end
				if (((8316 - 3484) >= (2967 - 1581)) and v93.ArcaneBlast:IsReady() and v33) then
					if (((1262 - (146 + 979)) == (39 + 98)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 32";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34) or ((2175 - (311 + 294)) >= (12080 - 7748))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((1722 + 2342) <= (3262 - (496 + 947)))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if ((v139 == (1359 - (1233 + 125))) or ((2024 + 2962) < (1413 + 161))) then
				if (((841 + 3585) > (1817 - (963 + 682))) and v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and not v109 and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (38 + 7)) and (v113 > (1519 - (504 + 1000)))) then
					if (((395 + 191) > (415 + 40)) and v21(v93.ShiftingPower, not v14:IsInRange(4 + 36))) then
						return "shifting_power rotation 6";
					end
				end
				if (((1217 - 391) == (706 + 120)) and v93.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (2 + 1)) and (v14:HealthPercentage() < (217 - (156 + 26))) and v93.ArcaneBombardment:IsAvailable()) then
					if (v21(v93.PresenceofMind) or ((2316 + 1703) > (6947 - 2506))) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((2181 - (149 + 15)) < (5221 - (890 + 70))) and v93.ArcaneBlast:IsReady() and v33 and v93.TimeAnomaly:IsAvailable() and v13:BuffUp(v93.ArcaneSurgeBuff) and (v13:BuffRemains(v93.ArcaneSurgeBuff) <= (123 - (39 + 78)))) then
					if (((5198 - (14 + 468)) > (175 - 95)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 10";
					end
				end
				v139 = 5 - 3;
			end
			if ((v139 == (2 + 0)) or ((2106 + 1401) == (696 + 2576))) then
				if ((v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v14:HealthPercentage() < (16 + 19)) and v93.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (1 + 2))) or ((1676 - 800) >= (3040 + 35))) then
					if (((15292 - 10940) > (65 + 2489)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (51 - (12 + 39))) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (28 + 2)) and (v93.TouchoftheMagi:CooldownRemains() > (92 - 62))) or (v13:ManaPercentage() > (249 - 179))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((1307 + 3099) < (2129 + 1914))) then
					if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((4789 - 2900) >= (2254 + 1129))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if (((9143 - 7251) <= (4444 - (1596 + 114))) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) == v111)) then
					if (((5020 - 3097) < (2931 - (164 + 549))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 14";
					end
				end
				v139 = 1441 - (1059 + 379);
			end
			if (((2697 - 524) > (197 + 182)) and ((0 + 0) == v139)) then
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (395 - (145 + 247))) and (v13:BloodlustDown() or (v13:ManaPercentage() > (58 + 12)) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (14 + 16))))) or ((7681 - 5090) == (655 + 2754))) then
					if (((3889 + 625) > (5397 - 2073)) and v21(v93.ArcaneOrb, not v14:IsInRange(760 - (254 + 466)))) then
						return "arcane_orb rotation 2";
					end
				end
				v104 = ((v93.ArcaneSurge:CooldownRemains() > (590 - (544 + 16))) and (v93.TouchoftheMagi:CooldownRemains() > (31 - 21))) or false;
				if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (640 - (294 + 334)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (265 - (236 + 17)))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (6 + 6))) and (v113 > (12 + 3))) or ((783 - 575) >= (22858 - 18030))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(21 + 19)) or ((1304 + 279) > (4361 - (413 + 381)))) then
						return "shifting_power rotation 4";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (8 - 4)) or ((3410 - 2097) == (2764 - (582 + 1388)))) then
				if (((5407 - 2233) > (2078 + 824)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffUp(v93.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (((4484 - (326 + 38)) <= (12602 - 8342)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v93.NetherPrecisionBuff)) or ((1260 - 377) > (5398 - (47 + 573)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((1277 + 2343) >= (20772 - 15881))) then
						return "arcane_blast rotation 24";
					end
				end
				if (((6910 - 2652) > (2601 - (1269 + 395))) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (552 - (76 + 416))) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (453 - (319 + 124))) and (v93.Evocation:CooldownRemains() > (91 - 51)) and (v113 > (1027 - (564 + 443)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((13479 - 8610) < (1364 - (337 + 121)))) then
						return "arcane_barrage rotation 26";
					end
				end
				v139 = 14 - 9;
			end
			if ((v139 == (9 - 6)) or ((3136 - (1261 + 650)) > (1789 + 2439))) then
				if (((5303 - 1975) > (4055 - (772 + 1045))) and v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v93.TemporalWarpBuff) or (v13:ManaPercentage() < (2 + 8)) or not v93.ShiftingPower:IsAvailable()) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (156 - (102 + 42)))) then
					if (((5683 - (1524 + 320)) > (2675 - (1049 + 221))) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (206 - (18 + 138))) and not v93.Evocation:IsAvailable() and (v113 > (48 - 28))) or ((2395 - (67 + 1035)) <= (855 - (136 + 212)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((12306 - 9410) < (645 + 160))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((2136 + 180) == (3920 - (240 + 1364))) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (1152 - (1050 + 32))) and v104 and v13:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (17 - 12)) and (v113 > (12 + 8))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((3625 - (331 + 724)) == (124 + 1409))) then
						return "arcane_barrage rotation 20";
					end
				end
				v139 = 648 - (269 + 375);
			end
		end
	end
	local function v126()
		if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (737 - (267 + 458)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (4 + 8))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (22 - 10))) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (830 - (667 + 151)))) or (v93.ArcaneOrb:Charges() == (1497 - (1410 + 87))) or (v93.ArcaneOrb:CooldownRemains() > (1909 - (1504 + 393))))) or ((2386 - 1503) == (3787 - 2327))) then
			if (v21(v93.ShiftingPower, not v14:IsInRange(836 - (461 + 335)), true) or ((591 + 4028) <= (2760 - (1730 + 31)))) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (1673 - (728 + 939))) or (v101 > (21 - 15)) or not v93.OrbBarrage:IsAvailable())) or ((6916 - 3506) > (9430 - 5314))) then
			if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((1971 - (138 + 930)) >= (2796 + 263))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v93.ArcaneArtilleryBuff) + 4 + 1))) or ((3408 + 568) < (11665 - 8808))) then
			if (((6696 - (459 + 1307)) > (4177 - (474 + 1396))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and ((v100 <= (6 - 2)) or (v101 <= (4 + 0)) or v13:BuffUp(v93.ClearcastingBuff)) and (v13:ArcaneCharges() == (1 + 2))) or ((11589 - 7543) < (164 + 1127))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((14157 - 9916) == (15460 - 11915))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() == (591 - (562 + 29))) and (v93.TouchoftheMagi:CooldownRemains() > (16 + 2))) or ((5467 - (374 + 1045)) > (3350 + 882))) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(124 - 84)) or ((2388 - (448 + 190)) >= (1122 + 2351))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if (((1430 + 1736) == (2063 + 1103)) and v93.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (38 - 28)))) then
			if (((5477 - 3714) < (5218 - (1307 + 187))) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if (((226 - 169) <= (6375 - 3652)) and v93.ArcaneExplosion:IsCastable() and v35) then
			if (v21(v93.ArcaneExplosion, not v14:IsInRange(30 - 20)) or ((2753 - (232 + 451)) == (424 + 19))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (568 - (510 + 54))) or ((5449 - 2744) == (1429 - (13 + 23)))) then
				if ((v30 and v109 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) or ((8968 - 4367) < (87 - 26))) then
					local v206 = 0 - 0;
					while true do
						if ((v206 == (1088 - (830 + 258))) or ((4903 - 3513) >= (2969 + 1775))) then
							v27 = v123();
							if (v27 or ((1705 + 298) > (5275 - (860 + 581)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v100 >= v103) or (v101 >= v103) or ((575 - 419) > (3106 + 807))) then
					local v207 = 241 - (237 + 4);
					while true do
						if (((457 - 262) == (493 - 298)) and (v207 == (0 - 0))) then
							v27 = v126();
							if (((2542 + 563) >= (1032 + 764)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (((16532 - 12153) >= (915 + 1216)) and ((v100 < v103) or (v101 < v103))) then
					local v208 = 0 + 0;
					while true do
						if (((5270 - (85 + 1341)) >= (3485 - 1442)) and (v208 == (0 - 0))) then
							v27 = v125();
							if (v27 or ((3604 - (45 + 327)) <= (5153 - 2422))) then
								return v27;
							end
							break;
						end
					end
				end
				break;
			end
			if (((5407 - (444 + 58)) == (2132 + 2773)) and (v140 == (1 + 2))) then
				if ((v30 and v93.RadiantSpark:IsAvailable() and v105) or ((2022 + 2114) >= (12782 - 8371))) then
					local v209 = 1732 - (64 + 1668);
					while true do
						if ((v209 == (1973 - (1227 + 746))) or ((9092 - 6134) == (7454 - 3437))) then
							v27 = v122();
							if (((1722 - (415 + 79)) >= (21 + 792)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v109 and v93.RadiantSpark:IsAvailable() and v106) or ((3946 - (142 + 349)) > (1735 + 2315))) then
					v27 = v121();
					if (((333 - 90) == (121 + 122)) and v27) then
						return v27;
					end
				end
				if ((v30 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) or ((191 + 80) > (4280 - 2708))) then
					v27 = v124();
					if (((4603 - (1710 + 154)) < (3611 - (200 + 118))) and v27) then
						return v27;
					end
				end
				v140 = 2 + 2;
			end
			if ((v140 == (0 - 0)) or ((5846 - 1904) < (1008 + 126))) then
				if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1 + 0, v93.ArcaneBarrage))) or ((1446 + 1247) == (795 + 4178))) then
					if (((4649 - 2503) == (3396 - (363 + 887))) and v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v13:IsChanneling(v93.Evocation) and (((v13:ManaPercentage() >= (165 - 70)) and not v93.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v113 * (18 - 14))) and not ((v113 > (2 + 8)) and (v93.ArcaneSurge:CooldownRemains() < (2 - 1)))))) or ((1534 + 710) == (4888 - (674 + 990)))) then
					if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1406 + 3498) <= (785 + 1131))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((142 - 52) <= (2120 - (507 + 548))) and v93.ArcaneBarrage:IsReady() and v34 and (v113 < (839 - (289 + 548)))) then
					if (((6620 - (821 + 997)) == (5057 - (195 + 60))) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage main 34";
					end
				end
				v140 = 1 + 0;
			end
			if ((v140 == (1502 - (251 + 1250))) or ((6679 - 4399) <= (352 + 159))) then
				if ((v93.Evocation:IsCastable() and v40 and not v107 and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (1042 - (809 + 223))) and (v93.TouchoftheMagi:CooldownRemains() < (29 - 9))) or (v93.TouchoftheMagi:CooldownRemains() < (44 - 29))) and (v13:ManaPercentage() < (v113 * (13 - 9)))) or ((1235 + 441) <= (243 + 220))) then
					if (((4486 - (14 + 603)) == (3998 - (118 + 11))) and v21(v93.Evocation)) then
						return "evocation main 36";
					end
				end
				if (((188 + 970) <= (2177 + 436)) and v93.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v93.TouchoftheMagiDebuff) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (87 - 57)) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) then
					if (v21(v93.ConjureManaGem) or ((3313 - (551 + 398)) <= (1264 + 735))) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v94.ManaGem:IsReady() and v41 and v93.CascadingPower:IsAvailable() and (v13:BuffStack(v93.ClearcastingBuff) < (1 + 1)) and v13:BuffUp(v93.ArcaneSurgeBuff)) or ((4001 + 921) < (721 - 527))) then
					if (v21(v95.ManaGem) or ((4817 - 2726) < (11 + 20))) then
						return "mana_gem main 40";
					end
				end
				v140 = 7 - 5;
			end
			if ((v140 == (1 + 1)) or ((2519 - (40 + 49)) >= (18553 - 13681))) then
				if ((v94.ManaGem:IsReady() and v41 and not v93.CascadingPower:IsAvailable() and v13:PrevGCDP(491 - (99 + 391), v93.ArcaneSurge) and (not v108 or (v108 and v13:PrevGCDP(2 + 0, v93.ArcaneSurge)))) or ((20968 - 16198) < (4296 - 2561))) then
					if (v21(v95.ManaGem) or ((4324 + 115) <= (6183 - 3833))) then
						return "mana_gem main 42";
					end
				end
				if ((not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * ((1605 - (1032 + 572)) + v24(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v93.ArcaneSurgeBuff) > ((420 - (203 + 214)) * v24(v13:HasTier(1847 - (568 + 1249), 2 + 0) and not v13:HasTier(72 - 42, 15 - 11)))) or v13:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (1351 - (913 + 393))) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (11 - 7))) or (v93.TouchoftheMagi:CooldownRemains() > (28 - 8))) and ((v100 < v103) or (v101 < v103))) or ((4889 - (269 + 141)) < (9933 - 5467))) then
					local v210 = 1981 - (362 + 1619);
					while true do
						if (((4172 - (950 + 675)) > (473 + 752)) and (v210 == (1179 - (216 + 963)))) then
							v27 = v120();
							if (((5958 - (485 + 802)) > (3233 - (432 + 127))) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((not v109 and (v93.ArcaneSurge:CooldownRemains() > (1103 - (1065 + 8))) and (v93.RadiantSpark:CooldownUp() or v14:DebuffUp(v93.RadiantSparkDebuff) or v14:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 1))) or v14:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) or ((5297 - (635 + 966)) < (2393 + 934))) then
					local v211 = 42 - (5 + 37);
					while true do
						if ((v211 == (0 - 0)) or ((1890 + 2652) == (4701 - 1731))) then
							v27 = v120();
							if (((118 + 134) <= (4108 - 2131)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				v140 = 11 - 8;
			end
		end
	end
	local function v128()
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
		v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
		v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v67 = EpicSettings.Settings['iceBlockHP'] or (529 - (318 + 211));
		v68 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v69 = EpicSettings.Settings['mirrorImageHP'] or (1587 - (963 + 624));
		v70 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v129()
		local v177 = 846 - (518 + 328);
		while true do
			if ((v177 == (6 - 3)) or ((2294 - 858) == (4092 - (301 + 16)))) then
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v177 = 10 - 6;
			end
			if ((v177 == (1 + 0)) or ((919 + 699) < (1985 - 1055))) then
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v71 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v79 = EpicSettings.Settings['useRacials'];
				v177 = 2 + 0;
			end
			if (((450 + 4273) > (13203 - 9050)) and (v177 == (0 + 0))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (1019 - (829 + 190));
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v177 = 3 - 2;
			end
			if (((2 - 0) == v177) or ((5051 - 1397) >= (11560 - 6906))) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v83 = EpicSettings.Settings['useHealingPotion'];
				v177 = 1 + 2;
			end
			if (((311 + 640) <= (4540 - 3044)) and (v177 == (4 + 0))) then
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v130()
		v128();
		v129();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['minicds'];
		v32 = EpicSettings.Toggles['dispel'];
		if (v13:IsDeadOrGhost() or ((2349 - (520 + 93)) == (847 - (259 + 17)))) then
			return v27;
		end
		v99 = v14:GetEnemiesInSplashRange(1 + 4);
		v102 = v13:GetEnemiesInRange(15 + 25);
		if (v29 or ((3033 - 2137) > (5360 - (396 + 195)))) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (1761 - (440 + 1321))) or ((2874 - (1059 + 770)) <= (4716 - 3696))) then
					v100 = v26(v14:GetEnemiesInSplashRangeCount(550 - (424 + 121)), #v102);
					v101 = #v102;
					break;
				end
			end
		else
			local v189 = 0 + 0;
			while true do
				if ((v189 == (1347 - (641 + 706))) or ((460 + 700) <= (768 - (249 + 191)))) then
					v100 = 4 - 3;
					v101 = 1 + 0;
					break;
				end
			end
		end
		if (((14676 - 10868) > (3351 - (183 + 244))) and (v97.TargetIsValid() or v13:AffectingCombat())) then
			local v190 = 0 + 0;
			while true do
				if (((4621 - (434 + 296)) < (15697 - 10778)) and (v190 == (512 - (169 + 343)))) then
					if (v13:AffectingCombat() or v72 or ((1959 + 275) <= (2642 - 1140))) then
						local v212 = v72 and v93.RemoveCurse:IsReady() and v32;
						v27 = v97.FocusUnit(v212, v95, 58 - 38, nil, 17 + 3);
						if (v27 or ((7123 - 4611) < (1555 - (651 + 472)))) then
							return v27;
						end
					end
					v112 = v10.BossFightRemains(nil, true);
					v190 = 1 + 0;
				end
				if ((v190 == (1 + 0)) or ((2254 - 406) == (1348 - (397 + 86)))) then
					v113 = v112;
					if ((v113 == (11987 - (423 + 453))) or ((476 + 4206) <= (599 + 3942))) then
						v113 = v10.FightRemains(v102, false);
					end
					break;
				end
			end
		end
		v114 = v13:GCD();
		if (v73 or ((2642 + 384) >= (3229 + 817))) then
			if (((1794 + 214) > (1828 - (50 + 1140))) and v92) then
				v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 26 + 4);
				if (((1048 + 727) <= (201 + 3032)) and v27) then
					return v27;
				end
			end
		end
		if (not v13:AffectingCombat() or v28 or ((6523 - 1980) == (1445 + 552))) then
			local v191 = 596 - (157 + 439);
			while true do
				if ((v191 == (1 - 0)) or ((10307 - 7205) < (2153 - 1425))) then
					if (((1263 - (782 + 136)) == (1200 - (112 + 743))) and v93.ConjureManaGem:IsCastable() and v39) then
						if (v21(v93.ConjureManaGem) or ((3998 - (1026 + 145)) < (65 + 313))) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
				if (((718 - (493 + 225)) == v191) or ((12776 - 9300) < (1580 + 1017))) then
					if (((8255 - 5176) < (92 + 4702)) and v93.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) then
						if (((13871 - 9017) > (1300 + 3164)) and v21(v93.ArcaneIntellect)) then
							return "arcane_intellect group_buff";
						end
					end
					if ((v93.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v93.ArcaneFamiliarBuff)) or ((8206 - 3294) == (5353 - (210 + 1385)))) then
						if (((1815 - (1201 + 488)) <= (2158 + 1324)) and v21(v93.ArcaneFamiliar)) then
							return "arcane_familiar precombat 2";
						end
					end
					v191 = 1 - 0;
				end
			end
		end
		if (v97.TargetIsValid() or ((4257 - 1883) == (4959 - (352 + 233)))) then
			local v192 = 0 - 0;
			while true do
				if (((857 + 718) == (4478 - 2903)) and ((575 - (489 + 85)) == v192)) then
					v27 = v115();
					if (v27 or ((3735 - (277 + 1224)) == (2948 - (663 + 830)))) then
						return v27;
					end
					v192 = 2 + 0;
				end
				if ((v192 == (6 - 3)) or ((1942 - (461 + 414)) > (299 + 1480))) then
					if (((865 + 1296) >= (89 + 845)) and v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v97.UnitHasMagicBuff(v14)) then
						if (((1590 + 22) == (1862 - (172 + 78))) and v21(v93.Spellsteal, not v14:IsSpellInRange(v93.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((7016 - 2664) >= (1043 + 1790)) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v97.TargetIsValid()) then
						local v213 = 0 - 0;
						local v214;
						while true do
							if ((v213 == (1 + 2)) or ((1077 + 2145) < (5148 - 2075))) then
								v27 = v119();
								if (((935 - 191) <= (740 + 2202)) and v27) then
									return v27;
								end
								v213 = 3 + 1;
							end
							if ((v213 == (1 + 0)) or ((7296 - 5463) <= (3079 - 1757))) then
								if ((v13:IsMoving() and v93.IceFloes:IsReady()) or ((1064 + 2403) <= (603 + 452))) then
									if (((3988 - (133 + 314)) == (616 + 2925)) and v21(v93.IceFloes)) then
										return "ice_floes movement";
									end
								end
								if ((v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (253 - (199 + 14))) or (v13:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + (50 - 36)))))) or ((5106 - (647 + 902)) >= (12036 - 8033))) then
									if (v21(v93.TimeWarp, not v14:IsInRange(273 - (85 + 148))) or ((1946 - (426 + 863)) >= (7806 - 6138))) then
										return "time_warp main 4";
									end
								end
								v213 = 1656 - (873 + 781);
							end
							if ((v213 == (4 - 0)) or ((2773 - 1746) > (1599 + 2259))) then
								v27 = v127();
								if (v27 or ((13498 - 9844) < (644 - 194))) then
									return v27;
								end
								break;
							end
							if (((5614 - 3723) < (6400 - (414 + 1533))) and (v213 == (0 + 0))) then
								v214 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
								if (v214 or ((3695 - (443 + 112)) < (3608 - (888 + 591)))) then
									return v214;
								end
								v213 = 2 - 1;
							end
							if ((v213 == (1 + 1)) or ((9623 - 7068) < (485 + 755))) then
								if ((v79 and ((v82 and v30) or not v82) and (v78 < v113)) or ((2287 + 2440) <= (505 + 4217))) then
									local v218 = 0 - 0;
									while true do
										if (((1370 - 630) < (6615 - (136 + 1542))) and ((3 - 2) == v218)) then
											if (((3631 + 27) >= (445 - 165)) and v13:PrevGCDP(1 + 0, v93.ArcaneSurge)) then
												local v221 = 486 - (68 + 418);
												while true do
													if ((v221 == (2 - 1)) or ((1605 - 720) >= (890 + 141))) then
														if (((4646 - (770 + 322)) >= (31 + 494)) and v93.AncestralCall:IsCastable()) then
															if (((699 + 1715) <= (406 + 2566)) and v21(v93.AncestralCall)) then
																return "ancestral_call main 14";
															end
														end
														break;
													end
													if (((5048 - 1519) <= (6859 - 3321)) and (v221 == (0 - 0))) then
														if (v93.BloodFury:IsCastable() or ((10523 - 7662) < (256 + 202))) then
															if (((2571 - 854) <= (2171 + 2354)) and v21(v93.BloodFury)) then
																return "blood_fury main 10";
															end
														end
														if (v93.Fireblood:IsCastable() or ((1949 + 1229) <= (1195 + 329))) then
															if (((16018 - 11764) > (513 - 143)) and v21(v93.Fireblood)) then
																return "fireblood main 12";
															end
														end
														v221 = 1 + 0;
													end
												end
											end
											break;
										end
										if ((v218 == (0 - 0)) or ((5404 - 3769) == (731 + 1046))) then
											if ((v93.LightsJudgment:IsCastable() and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (9 - 7)) or (v101 >= (833 - (762 + 69))))) or ((10808 - 7470) >= (3441 + 552))) then
												if (((748 + 406) <= (3567 - 2092)) and v21(v93.LightsJudgment, not v14:IsSpellInRange(v93.LightsJudgment))) then
													return "lights_judgment main 6";
												end
											end
											if ((v93.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v93.ArcaneSurge) and not (v13:BuffUp(v93.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v93.ArcaneSurgeBuff) and v14:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((42 + 2568) < (4792 - 3562))) then
												if (v21(v93.Berserking) or ((1605 - (8 + 149)) == (4403 - (1199 + 121)))) then
													return "berserking main 8";
												end
											end
											v218 = 1 - 0;
										end
									end
								end
								if (((7086 - 3947) > (378 + 538)) and (v78 < v113)) then
									if (((10543 - 7589) == (6854 - 3900)) and v80 and ((v30 and v81) or not v81)) then
										local v220 = 0 + 0;
										while true do
											if (((1924 - (518 + 1289)) <= (4959 - 2067)) and (v220 == (0 + 0))) then
												v27 = v117();
												if (v27 or ((660 - 207) > (3434 + 1228))) then
													return v27;
												end
												break;
											end
										end
									end
								end
								v213 = 472 - (304 + 165);
							end
						end
					end
					break;
				end
				if (((1247 + 73) > (755 - (54 + 106))) and (v192 == (1969 - (1618 + 351)))) then
					if ((v72 and v32 and v93.RemoveCurse:IsAvailable()) or ((2257 + 942) < (1606 - (10 + 1006)))) then
						local v215 = 0 + 0;
						while true do
							if ((v215 == (0 + 0)) or ((15538 - 10745) < (1063 - (912 + 121)))) then
								if (v15 or ((802 + 894) <= (2348 - (1140 + 149)))) then
									local v219 = 0 + 0;
									while true do
										if (((3122 - 779) == (436 + 1907)) and (v219 == (0 - 0))) then
											v27 = v116();
											if (v27 or ((1956 - 913) > (620 + 2971))) then
												return v27;
											end
											break;
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v97.UnitHasCurseDebuff(v16)) or ((10028 - 7138) >= (4265 - (165 + 21)))) then
									if (((4585 - (61 + 50)) <= (1965 + 2805)) and v93.RemoveCurse:IsReady()) then
										if (v21(v95.RemoveCurseMouseover) or ((23555 - 18613) == (7864 - 3961))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if ((not v13:AffectingCombat() and v28) or ((98 + 150) > (6305 - (1295 + 165)))) then
						local v216 = 0 + 0;
						while true do
							if (((631 + 938) == (2966 - (819 + 578))) and (v216 == (1402 - (331 + 1071)))) then
								v27 = v118();
								if (v27 or ((5670 - (588 + 155)) <= (4503 - (546 + 736)))) then
									return v27;
								end
								break;
							end
						end
					end
					v192 = 1938 - (1834 + 103);
				end
				if (((2 + 0) == v192) or ((5309 - 3529) > (4553 - (1536 + 230)))) then
					if (v73 or ((4428 - (128 + 363)) <= (262 + 968))) then
						if (v92 or ((6560 - 3923) < (441 + 1265))) then
							local v217 = 0 - 0;
							while true do
								if ((v217 == (0 - 0)) or ((6482 - 3813) <= (1654 + 755))) then
									v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 1039 - (615 + 394));
									if (v27 or ((1265 + 136) > (4476 + 220))) then
										return v27;
									end
									break;
								end
							end
						end
					end
					if (v74 or ((9998 - 6718) < (5991 - 4670))) then
						v27 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseOver, 681 - (59 + 592), true);
						if (((10908 - 5981) >= (4240 - 1937)) and v27) then
							return v27;
						end
					end
					v192 = 3 + 0;
				end
			end
		end
	end
	local function v131()
		local v183 = 171 - (70 + 101);
		while true do
			if (((8558 - 5096) >= (732 + 300)) and (v183 == (0 - 0))) then
				v98();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(303 - (123 + 118), v130, v131);
end;
return v0["Epix_Mage_Arcane.lua"]();

