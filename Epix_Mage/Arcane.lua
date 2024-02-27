local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5332 - (262 + 1637)) <= (8105 - 3969)) and not v5) then
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
	local v92;
	local v93 = v16.Mage.Arcane;
	local v94 = v17.Mage.Arcane;
	local v95 = v21.Mage.Arcane;
	local v96 = {};
	local v97 = v18.Commons.Everyone;
	local function v98()
		if (((5709 - (157 + 1307)) <= (6490 - (821 + 1038))) and v93.RemoveCurse:IsAvailable()) then
			v97.DispellableDebuffs = v97.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v98();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v93.ArcaneBlast:RegisterInFlight();
	v93.ArcaneBarrage:RegisterInFlight();
	local v99, v100;
	local v101, v102;
	local v103 = 7 - 4;
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v12:HasTier(4 + 25, 6 - 2);
	local v110 = (83713 + 141287) - (((61964 - 36964) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((201026 - (834 + 192)) * v23(not v109)));
	local v111 = 1 + 2;
	local v112 = 2852 + 8259;
	local v113 = 239 + 10872;
	local v114;
	v9:RegisterForEvent(function()
		v104 = false;
		v107 = true;
		v110 = (348570 - 123570) - (((25304 - (300 + 4)) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((53414 + 146586) * v23(not v109)));
		v112 = 29085 - 17974;
		v113 = 11473 - (112 + 250);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v109 = not v12:HasTier(12 + 17, 9 - 5);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		local v133 = 0 + 0;
		while true do
			if (((2212 + 2064) >= (2928 + 986)) and (v133 == (2 + 1))) then
				if (((148 + 50) <= (5779 - (1001 + 413))) and v93.AlterTime:IsReady() and v56 and (v12:HealthPercentage() <= v63)) then
					if (((10663 - 5881) > (5558 - (244 + 638))) and v20(v93.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if (((5557 - (627 + 66)) > (6546 - 4349)) and v94.Healthstone:IsReady() and v84 and (v12:HealthPercentage() <= v86)) then
					if (v20(v95.Healthstone) or ((4302 - (512 + 90)) == (4413 - (1665 + 241)))) then
						return "healthstone defensive";
					end
				end
				v133 = 721 - (373 + 344);
			end
			if (((2018 + 2456) >= (73 + 201)) and (v133 == (10 - 6))) then
				if ((v83 and (v12:HealthPercentage() <= v85)) or ((3204 - 1310) <= (2505 - (35 + 1064)))) then
					if (((1144 + 428) >= (3275 - 1744)) and (v87 == "Refreshing Healing Potion")) then
						if (v94.RefreshingHealingPotion:IsReady() or ((19 + 4668) < (5778 - (298 + 938)))) then
							if (((4550 - (233 + 1026)) > (3333 - (636 + 1030))) and v20(v95.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v87 == "Dreamwalker's Healing Potion") or ((447 + 426) == (1987 + 47))) then
						if (v94.DreamwalkersHealingPotion:IsReady() or ((837 + 1979) < (1 + 10))) then
							if (((3920 - (55 + 166)) < (912 + 3794)) and v20(v95.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((267 + 2379) >= (3345 - 2469)) and (v133 == (297 - (36 + 261)))) then
				if (((1073 - 459) <= (4552 - (34 + 1334))) and v93.PrismaticBarrier:IsCastable() and v57 and v12:BuffDown(v93.PrismaticBarrier) and (v12:HealthPercentage() <= v64)) then
					if (((1202 + 1924) == (2429 + 697)) and v20(v93.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v93.MassBarrier:IsCastable() and v61 and v12:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v69, 1285 - (1035 + 248))) or ((2208 - (20 + 1)) >= (2581 + 2373))) then
					if (v20(v93.MassBarrier) or ((4196 - (134 + 185)) == (4708 - (549 + 584)))) then
						return "mass_barrier defensive 2";
					end
				end
				v133 = 686 - (314 + 371);
			end
			if (((2427 - 1720) > (1600 - (478 + 490))) and (v133 == (2 + 0))) then
				if ((v93.MirrorImage:IsCastable() and v62 and (v12:HealthPercentage() <= v68)) or ((1718 - (786 + 386)) >= (8693 - 6009))) then
					if (((2844 - (1055 + 324)) <= (5641 - (1093 + 247))) and v20(v93.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if (((1515 + 189) > (150 + 1275)) and v93.GreaterInvisibility:IsReady() and v58 and (v12:HealthPercentage() <= v65)) then
					if (v20(v93.GreaterInvisibility) or ((2727 - 2040) == (14369 - 10135))) then
						return "greater_invisibility defensive 5";
					end
				end
				v133 = 8 - 5;
			end
			if ((v133 == (2 - 1)) or ((1185 + 2145) < (5504 - 4075))) then
				if (((3953 - 2806) >= (253 + 82)) and v93.IceBlock:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) then
					if (((8784 - 5349) > (2785 - (364 + 324))) and v20(v93.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if ((v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v60 and (v12:HealthPercentage() <= v67)) or ((10334 - 6564) >= (9696 - 5655))) then
					if (v20(v93.IceColdAbility) or ((1257 + 2534) <= (6740 - 5129))) then
						return "ice_cold defensive 3";
					end
				end
				v133 = 2 - 0;
			end
		end
	end
	local v116 = 0 - 0;
	local function v117()
		if ((v93.RemoveCurse:IsReady() and v97.DispellableFriendlyUnit(1288 - (1249 + 19))) or ((4133 + 445) <= (7816 - 5808))) then
			if (((2211 - (686 + 400)) <= (1629 + 447)) and (v116 == (229 - (73 + 156)))) then
				v116 = GetTime();
			end
			if (v97.Wait(3 + 497, v116) or ((1554 - (721 + 90)) >= (50 + 4349))) then
				if (((3750 - 2595) < (2143 - (224 + 246))) and v20(v95.RemoveCurseFocus)) then
					return "remove_curse dispel";
				end
				v116 = 0 - 0;
			end
		end
	end
	local function v118()
		v26 = v97.HandleTopTrinket(v96, v29, 73 - 33, nil);
		if (v26 or ((422 + 1902) <= (14 + 564))) then
			return v26;
		end
		v26 = v97.HandleBottomTrinket(v96, v29, 30 + 10, nil);
		if (((7488 - 3721) == (12535 - 8768)) and v26) then
			return v26;
		end
	end
	local function v119()
		local v134 = 513 - (203 + 310);
		while true do
			if (((6082 - (1238 + 755)) == (286 + 3803)) and (v134 == (1536 - (709 + 825)))) then
				if (((8214 - 3756) >= (2438 - 764)) and v93.ArcaneBlast:IsReady() and v32) then
					if (((1836 - (196 + 668)) <= (5598 - 4180)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if ((v134 == (1 - 0)) or ((5771 - (171 + 662)) < (4855 - (4 + 89)))) then
				if ((v93.Evocation:IsReady() and v39 and (v93.SiphonStorm:IsAvailable())) or ((8776 - 6272) > (1553 + 2711))) then
					if (((9456 - 7303) == (845 + 1308)) and v20(v93.Evocation)) then
						return "evocation precombat 6";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53)) or ((1993 - (35 + 1451)) >= (4044 - (28 + 1425)))) then
					if (((6474 - (941 + 1052)) == (4297 + 184)) and v20(v93.ArcaneOrb, not v13:IsInRange(1554 - (822 + 692)))) then
						return "arcane_orb precombat 8";
					end
				end
				v134 = 2 - 0;
			end
			if (((0 + 0) == v134) or ((2625 - (45 + 252)) < (686 + 7))) then
				if (((1490 + 2838) == (10533 - 6205)) and v93.MirrorImage:IsCastable() and v90 and v62) then
					if (((2021 - (114 + 319)) >= (1911 - 579)) and v20(v93.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and not v93.SiphonStorm:IsAvailable()) or ((5347 - 1173) > (2709 + 1539))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((6832 - 2246) <= (171 - 89))) then
						return "arcane_blast precombat 4";
					end
				end
				v134 = 1964 - (556 + 1407);
			end
		end
	end
	local function v120()
		local v135 = 1206 - (741 + 465);
		while true do
			if (((4328 - (170 + 295)) == (2036 + 1827)) and (v135 == (0 + 0))) then
				if ((((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (0 - 0)) or (v12:ArcaneCharges() >= (3 + 0))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 0)))) or ((160 + 122) <= (1272 - (957 + 273)))) then
					v105 = true;
				elseif (((1233 + 3376) >= (307 + 459)) and v105 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (26 - 19)) and v93.RadiantSpark:CooldownDown()) then
					v105 = false;
				end
				if (((v12:ArcaneCharges() > (7 - 4)) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (20 - 13))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (24 - 19))) or (v93.ArcaneSurge:CooldownRemains() > (1820 - (389 + 1391))))) or ((723 + 429) == (259 + 2229))) then
					v106 = true;
				elseif (((7790 - 4368) > (4301 - (783 + 168))) and v106 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (23 - 16)) and v93.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				v135 = 1 + 0;
			end
			if (((1188 - (309 + 2)) > (1154 - 778)) and (v135 == (1213 - (1090 + 122)))) then
				if ((v13:DebuffUp(v93.TouchoftheMagiDebuff) and v107) or ((1011 + 2107) <= (6216 - 4365))) then
					v107 = false;
				end
				v108 = v93.ArcaneBlast:CastTime() < v114;
				break;
			end
		end
	end
	local function v121()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (1124 - (628 + 490))) or ((30 + 135) >= (8645 - 5153))) then
				if (((18046 - 14097) < (5630 - (431 + 343))) and v93.ArcaneMissiles:IsReady() and v37 and v12:BuffDown(v93.NetherPrecisionBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v13:DebuffDown(v93.RadiantSparkVulnerability) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (7 - 3)) and v12:PrevGCDP(2 - 1, v93.ArcaneBlast)))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((3379 + 897) < (386 + 2630))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if (((6385 - (556 + 1139)) > (4140 - (6 + 9))) and v93.ArcaneBlast:IsReady() and v32) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((10 + 40) >= (460 + 436))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v136 == (172 - (28 + 141))) or ((664 + 1050) >= (3650 - 692))) then
				if ((v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (11 + 4)) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1322 - (486 + 831))))) and (v93.ArcaneSurge:CooldownRemains() < (78 - 48))) or ((5249 - 3758) < (122 + 522))) then
					if (((2225 - 1521) < (2250 - (668 + 595))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if (((3346 + 372) > (385 + 1521)) and v93.ArcaneMissiles:IsReady() and v37 and v93.RadiantSpark:CooldownUp() and v12:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v12:BuffDown(v93.NetherPrecisionBuff) or (v12:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v12:HasTier(81 - 51, 294 - (23 + 267))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((2902 - (1129 + 815)) > (4022 - (371 + 16)))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if (((5251 - (1326 + 424)) <= (8507 - 4015)) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) then
					if (v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), true) or ((12577 - 9135) < (2666 - (88 + 30)))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v136 = 775 - (720 + 51);
			end
			if (((6395 - 3520) >= (3240 - (421 + 1355))) and (v136 == (2 - 0))) then
				if ((v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (3 + 2)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1089 - (286 + 797))))) and v12:HasTier(113 - 82, 6 - 2)) or ((5236 - (397 + 42)) >= (1529 + 3364))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((1351 - (24 + 776)) > (3185 - 1117))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((2899 - (222 + 563)) > (2079 - 1135)) and v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (13 + 4)) and not v12:HasTier(220 - (23 + 167), 1802 - (690 + 1108))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((817 + 1445) >= (2554 + 542))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (850 - (40 + 808))) and (v93.RadiantSpark:CooldownRemains() < (1 + 4)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (22 - 16)))) and not v12:HasTier(29 + 1, 3 + 1)) or ((1237 + 1018) >= (4108 - (47 + 524)))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((2491 + 1346) < (3569 - 2263))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				v136 = 4 - 1;
			end
			if (((6727 - 3777) == (4676 - (1165 + 561))) and (v136 == (0 + 0))) then
				if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(3 - 2, v93.ArcaneBarrage))) or ((1803 + 2920) < (3777 - (341 + 138)))) then
					if (((307 + 829) >= (317 - 163)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (v93.RadiantSpark:CooldownUp() or ((597 - (89 + 237)) > (15274 - 10526))) then
					v104 = v93.ArcaneSurge:CooldownRemains() < (21 - 11);
				end
				if (((5621 - (581 + 300)) >= (4372 - (855 + 365))) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) then
					if (v20(v93.ShiftingPower, not v13:IsInRange(95 - 55), true) or ((842 + 1736) >= (4625 - (1030 + 205)))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				v136 = 1 + 0;
			end
			if (((39 + 2) <= (1947 - (156 + 130))) and ((11 - 6) == v136)) then
				if (((1012 - 411) < (7291 - 3731)) and v93.ArcaneBlast:IsReady() and v32 and v13:DebuffUp(v93.RadiantSparkVulnerability) and (v13:DebuffStack(v93.RadiantSparkVulnerability) < (2 + 2))) then
					if (((138 + 97) < (756 - (10 + 59))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if (((1287 + 3262) > (5678 - 4525)) and v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (v20(v93.PresenceofMind) or ((5837 - (671 + 492)) < (3720 + 952))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if (((4883 - (369 + 846)) < (1208 + 3353)) and v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.PresenceofMindBuff))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((389 + 66) == (5550 - (1036 + 909)))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				v136 = 5 + 1;
			end
			if (((6 - 2) == v136) or ((2866 - (11 + 192)) == (1674 + 1638))) then
				if (((4452 - (135 + 40)) <= (10842 - 6367)) and v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (19 + 11)) and (v93.ArcaneEcho:IsAvailable())) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((1916 - 1046) == (1781 - 592))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((1729 - (50 + 126)) <= (8723 - 5590)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) then
					if (v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge)) or ((496 + 1741) >= (4924 - (1233 + 180)))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:PrevGCDP(970 - (522 + 447), v93.ArcaneSurge) or v12:PrevGCDP(1422 - (107 + 1314), v93.NetherTempest) or v12:PrevGCDP(1 + 0, v93.RadiantSpark))) or ((4033 - 2709) > (1283 + 1737))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((5941 - 2949) == (7442 - 5561))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				v136 = 1915 - (716 + 1194);
			end
			if (((54 + 3052) > (164 + 1362)) and (v136 == (504 - (74 + 429)))) then
				if (((5831 - 2808) < (1919 + 1951)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and v93.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) then
					if (((327 - 184) > (53 + 21)) and v20(v93.ArcaneOrb, not v13:IsInRange(123 - 83))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if (((44 - 26) < (2545 - (279 + 154))) and v93.ArcaneBlast:IsReady() and v32 and v93.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (780 - (454 + 324))) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) then
					if (((864 + 233) <= (1645 - (12 + 5))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((2497 + 2133) == (11797 - 7167)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and (v12:ManaPercentage() > (1123 - (277 + 816))) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (((15126 - 11586) > (3866 - (1058 + 125))) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				v136 = 1 + 1;
			end
		end
	end
	local function v122()
		if (((5769 - (815 + 160)) >= (14051 - 10776)) and v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (106 - 61)) and v13:DebuffDown(v93.NetherTempestDebuff) and v107 and v12:BloodlustUp()) then
			if (((355 + 1129) == (4337 - 2853)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest spark_phase 2";
			end
		end
		if (((3330 - (41 + 1857)) < (5448 - (1222 + 671))) and v107 and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((1530 - 465) > (4760 - (229 + 953)))) then
				return "arcane_missiles interrupt spark_phase 4";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1779 - (1111 + 663))) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1585 - (874 + 705))))) and v12:HasTier(5 + 26, 3 + 1)) or ((9967 - 5172) < (40 + 1367))) then
			if (((2532 - (642 + 37)) < (1098 + 3715)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles spark_phase 4";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (3 + 12))) or ((7082 - 4261) < (2885 - (233 + 221)))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((6645 - 3771) < (1920 + 261))) then
				return "arcane_blast spark_phase 6";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (1543 - (718 + 823))) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (811 - (266 + 539))))) or ((7612 - 4923) <= (1568 - (636 + 589)))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((4436 - 2567) == (4143 - 2134))) then
				return "arcane_missiles spark_phase 10";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (12 + 3)) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (2 + 3)))) and (v93.ArcaneSurge:CooldownRemains() < (1045 - (657 + 358)))) or ((9388 - 5842) < (5289 - 2967))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((3269 - (1151 + 36)) == (4610 + 163))) then
				return "arcane_missiles spark_phase 12";
			end
		end
		if (((853 + 2391) > (3150 - 2095)) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) then
			if (v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark)) or ((5145 - (1552 + 280)) <= (2612 - (64 + 770)))) then
				return "radiant_spark spark_phase 14";
			end
		end
		if ((v93.NetherTempest:IsReady() and v41 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (11 + 4)) and ((not v108 and v12:PrevGCDP(8 - 4, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v12:PrevGCDP(1 + 4, v93.RadiantSpark))) or ((2664 - (157 + 1086)) >= (4210 - 2106))) then
			if (((7935 - 6123) <= (4983 - 1734)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest spark_phase 16";
			end
		end
		if (((2214 - 591) <= (2776 - (599 + 220))) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v12:PrevGCDP(7 - 3, v93.RadiantSpark) and not v108) or v12:PrevGCDP(1936 - (1813 + 118), v93.RadiantSpark))) or v12:PrevGCDP(1 + 0, v93.NetherTempest))) then
			if (((5629 - (841 + 376)) == (6181 - 1769)) and v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge))) then
				return "arcane_surge spark_phase 18";
			end
		end
		if (((407 + 1343) >= (2298 - 1456)) and v93.ArcaneBlast:IsReady() and v32 and (v93.ArcaneBlast:CastTime() >= v12:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (894 - (464 + 395)))) and ((v93.NetherTempest:IsAvailable() and v12:PrevGCDP(15 - 9, v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v12:PrevGCDP(3 + 2, v93.RadiantSpark))) and not (v12:IsCasting(v93.ArcaneSurge) and (v12:CastRemains() < (837.5 - (467 + 370))) and not v108)) then
			if (((9034 - 4662) > (1358 + 492)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast spark_phase 20";
			end
		end
		if (((795 - 563) < (129 + 692)) and v93.ArcaneBarrage:IsReady() and v33 and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4))) then
			if (((1038 - (150 + 370)) < (2184 - (74 + 1208))) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage spark_phase 22";
			end
		end
		if (((7363 - 4369) > (4069 - 3211)) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and v12:PrevGCDP(1 + 0, v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (390.2 - (14 + 376)))) or (v12:GCDRemains() <= (0.2 - 0)))) then
			if (v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi)) or ((2430 + 1325) <= (804 + 111))) then
				return "touch_of_the_magi spark_phase 24";
			end
		end
		if (((3764 + 182) > (10967 - 7224)) and v93.ArcaneBlast:IsReady() and v32) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((1005 + 330) >= (3384 - (23 + 55)))) then
				return "arcane_blast spark_phase 26";
			end
		end
		if (((11479 - 6635) > (1504 + 749)) and v93.ArcaneBarrage:IsReady() and v33) then
			if (((406 + 46) == (700 - 248)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage spark_phase 28";
			end
		end
	end
	local function v123()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (903 - (652 + 249))) or ((12195 - 7638) < (3955 - (708 + 1160)))) then
				if (((10515 - 6641) == (7062 - 3188)) and v93.ArcaneBarrage:IsReady() and v33 and (v93.ArcaneSurge:CooldownRemains() < (102 - (10 + 17))) and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 3)) and not v93.OrbBarrage:IsAvailable()) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((3670 - (1400 + 332)) > (9465 - 4530))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1910 - (242 + 1666))) and (v93.ArcaneSurge:CooldownRemains() > (33 + 42))) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 0)) and (v93.ArcaneSurge:CooldownRemains() < (64 + 11)) and not v93.OrbBarrage:IsAvailable()))) or ((5195 - (850 + 90)) < (5994 - 2571))) then
					if (((2844 - (360 + 1030)) <= (2205 + 286)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 1)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 0)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1664 - (909 + 752))) and ((v100 > (1228 - (109 + 1114))) or (v101 > (9 - 4)))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 2))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) or ((4399 - (6 + 236)) <= (1766 + 1037))) then
					if (((3907 + 946) >= (7032 - 4050)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				v137 = 4 - 1;
			end
			if (((5267 - (1076 + 57)) > (553 + 2804)) and (v137 == (690 - (579 + 110)))) then
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (2 + 13)) and (v12:ArcaneCharges() < (3 + 0))) or ((1814 + 1603) < (2941 - (174 + 233)))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(111 - 71)) or ((4777 - 2055) <= (73 + 91))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				if ((v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (1189 - (663 + 511))) and (v93.ArcaneEcho:IsAvailable())) or ((2149 + 259) < (458 + 1651))) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((101 - 68) == (882 + 573))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if ((v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) or ((1042 - 599) >= (9719 - 5704))) then
					if (((1614 + 1768) > (322 - 156)) and v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				v137 = 2 + 0;
			end
			if ((v137 == (0 + 0)) or ((1002 - (478 + 244)) == (3576 - (440 + 77)))) then
				if (((856 + 1025) > (4732 - 3439)) and v12:BuffUp(v93.PresenceofMindBuff) and v91 and (v12:PrevGCDP(1557 - (655 + 901), v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (14 + 61))) then
					if (((1805 + 552) == (1592 + 765)) and v20(v95.CancelPOM)) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if (((495 - 372) == (1568 - (695 + 750))) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(3 - 2, v93.ArcaneBarrage))) then
					if (v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi)) or ((1629 - 573) >= (13641 - 10249))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) or ((1432 - (285 + 66)) < (2505 - 1430))) then
					if (v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), true) or ((2359 - (682 + 628)) >= (715 + 3717))) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				v137 = 300 - (176 + 123);
			end
			if ((v137 == (2 + 1)) or ((3459 + 1309) <= (1115 - (239 + 30)))) then
				if ((v93.PresenceofMind:IsCastable() and v42) or ((913 + 2445) <= (1365 + 55))) then
					if (v20(v93.PresenceofMind) or ((6617 - 2878) <= (9375 - 6370))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and ((((v13:DebuffStack(v93.RadiantSparkVulnerability) == (317 - (306 + 9))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (10 - 7))) and not v93.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) or ((289 + 1370) >= (1310 + 824))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((1570 + 1690) < (6734 - 4379))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1379 - (1140 + 235))) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 1)) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) or ((614 + 55) == (1084 + 3139))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((1744 - (33 + 19)) < (213 + 375))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (2 + 1)) or ((9407 - 4610) < (3424 + 227))) then
				if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) or ((4866 - (586 + 103)) > (442 + 4408))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((1231 - 831) > (2599 - (1309 + 179)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((5507 - 2456) > (438 + 567)) and v93.ArcaneBlast:IsReady() and v32) then
					if (((9917 - 6224) <= (3310 + 1072)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33) or ((6972 - 3690) > (8169 - 4069))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((4189 - (295 + 314)) < (6984 - 4140))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if (((2051 - (1300 + 662)) < (14099 - 9609)) and (v138 == (1757 - (1178 + 577)))) then
				if ((v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (88 - 58)) and (v93.TouchoftheMagi:CooldownRemains() > (1435 - (851 + 554)))) or (v12:ManaPercentage() > (62 + 8))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) or ((13819 - 8836) < (3926 - 2118))) then
					if (((4131 - (115 + 187)) > (2887 + 882)) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((1406 + 79) <= (11443 - 8539)) and v93.ArcaneMissiles:IsCastable() and v37 and (v12:BuffStack(v93.ClearcastingBuff) > (1162 - (160 + 1001))) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) then
					if (((3735 + 534) == (2946 + 1323)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if (((791 - 404) <= (3140 - (237 + 121))) and v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.NetherPrecisionBuff))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((2796 - (525 + 372)) <= (1738 - 821))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v138 = 9 - 6;
			end
			if ((v138 == (143 - (96 + 46))) or ((5089 - (643 + 134)) <= (317 + 559))) then
				if (((5351 - 3119) <= (9638 - 7042)) and v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (((2010 + 85) < (7233 - 3547)) and v20(v93.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) or ((3260 - 1665) >= (5193 - (316 + 403)))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((3071 + 1548) < (7923 - 5041))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (13 + 22)))) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((740 - 446) >= (3424 + 1407))) then
					if (((654 + 1375) <= (10685 - 7601)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v138 = 9 - 7;
			end
			if ((v138 == (0 - 0)) or ((117 + 1920) == (4764 - 2344))) then
				if (((218 + 4240) > (11485 - 7581)) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (26 - (12 + 5)))) then
					v104 = not v104;
				end
				if (((1693 - 1257) >= (261 - 138)) and v93.NetherTempest:IsReady() and v41 and (v13:DebuffRefreshable(v93.NetherTempestDebuff) or not v13:DebuffUp(v93.NetherTempestDebuff)) and (v12:ArcaneCharges() == (8 - 4)) and (v12:ManaPercentage() < (74 - 44)) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) then
					if (((2473 - (1656 + 317)) < (1619 + 197)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((2864 + 710) == (9503 - 5929)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v12:ArcaneCharges() < (9 - 7)) and (v12:ManaPercentage() < (384 - (5 + 349))) and (v12:SpellHaste() < (0.667 - 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) then
					if (((1492 - (266 + 1005)) < (257 + 133)) and v20(v93.ArcaneOrb, not v13:IsInRange(136 - 96))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v138 = 1 - 0;
			end
		end
	end
	local function v125()
		if ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (1705 - (561 + 1135))) or ((2883 - 670) <= (4670 - 3249))) then
			v104 = not v104;
		end
		if (((4124 - (507 + 559)) < (12195 - 7335)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff)) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((4008 - 2712) >= (4834 - (212 + 176)))) then
				return "arcane_missiles aoe_touch_phase 2";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and ((((v100 <= (909 - (250 + 655))) or (v101 <= (10 - 6))) and (v12:ArcaneCharges() == (5 - 2))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) or ((2178 - 785) > (6445 - (1869 + 87)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((15344 - 10920) < (1928 - (484 + 1417)))) then
				return "arcane_barrage aoe_touch_phase 4";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (4 - 2))) or ((3346 - 1349) > (4588 - (48 + 725)))) then
			if (((5660 - 2195) > (5131 - 3218)) and v20(v93.ArcaneOrb, not v13:IsInRange(24 + 16))) then
				return "arcane_orb aoe_touch_phase 6";
			end
		end
		if (((1958 - 1225) < (510 + 1309)) and v93.ArcaneExplosion:IsCastable() and v34) then
			if (v20(v93.ArcaneExplosion, not v13:IsInRange(3 + 7)) or ((5248 - (152 + 701)) == (6066 - (430 + 881)))) then
				return "arcane_explosion aoe_touch_phase 8";
			end
		end
	end
	local function v126()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (898 - (557 + 338))) or ((1122 + 2671) < (6675 - 4306))) then
				if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffUp(v93.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) or ((14301 - 10217) == (704 - 439))) then
					if (((9392 - 5034) == (5159 - (499 + 302))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v93.NetherPrecisionBuff)) or ((4004 - (39 + 827)) < (2740 - 1747))) then
					if (((7437 - 4107) > (9226 - 6903)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (92 - 32)) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (1 + 9)) and (v93.Evocation:CooldownRemains() > (117 - 77)) and (v113 > (4 + 16))) or ((5737 - 2111) == (4093 - (103 + 1)))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((1470 - (475 + 79)) == (5774 - 3103))) then
						return "arcane_barrage rotation 26";
					end
				end
				if (((870 - 598) == (36 + 236)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) then
					if (((3740 + 509) <= (6342 - (1395 + 108))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 30";
					end
				end
				v139 = 11 - 7;
			end
			if (((3981 - (7 + 1197)) < (1396 + 1804)) and (v139 == (0 + 0))) then
				if (((414 - (27 + 292)) < (5734 - 3777)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (3 - 0)) and (v12:BloodlustDown() or (v12:ManaPercentage() > (293 - 223)) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (59 - 29))))) then
					if (((1572 - 746) < (1856 - (43 + 96))) and v20(v93.ArcaneOrb, not v13:IsInRange(163 - 123))) then
						return "arcane_orb rotation 2";
					end
				end
				v104 = ((v93.ArcaneSurge:CooldownRemains() > (67 - 37)) and (v93.TouchoftheMagi:CooldownRemains() > (9 + 1))) or false;
				if (((403 + 1023) >= (2184 - 1079)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (5 + 7))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (21 - 9))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (4 + 8))) and (v113 > (2 + 13))) then
					if (((4505 - (1414 + 337)) <= (5319 - (1642 + 298))) and v20(v93.ShiftingPower, not v13:IsInRange(104 - 64))) then
						return "shifting_power rotation 4";
					end
				end
				if ((v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and not v109 and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (129 - 84)) and (v113 > (44 - 29))) or ((1293 + 2634) == (1100 + 313))) then
					if (v20(v93.ShiftingPower, not v13:IsInRange(1012 - (357 + 615))) or ((811 + 343) <= (1933 - 1145))) then
						return "shifting_power rotation 6";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (2 - 1)) or ((1315 + 328) > (230 + 3149))) then
				if ((v93.PresenceofMind:IsCastable() and v42 and (v12:ArcaneCharges() < (2 + 1)) and (v13:HealthPercentage() < (1336 - (384 + 917))) and v93.ArcaneBombardment:IsAvailable()) or ((3500 - (128 + 569)) > (6092 - (1407 + 136)))) then
					if (v20(v93.PresenceofMind) or ((2107 - (687 + 1200)) >= (4732 - (556 + 1154)))) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((9927 - 7105) == (2917 - (9 + 86))) and v93.ArcaneBlast:IsReady() and v32 and v93.TimeAnomaly:IsAvailable() and v12:BuffUp(v93.ArcaneSurgeBuff) and (v12:BuffRemains(v93.ArcaneSurgeBuff) <= (427 - (275 + 146)))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((173 + 888) == (1921 - (29 + 35)))) then
						return "arcane_blast rotation 10";
					end
				end
				if (((12232 - 9472) > (4073 - 2709)) and v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v13:HealthPercentage() < (154 - 119)) and v93.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (2 + 1))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((5914 - (53 + 959)) <= (4003 - (312 + 96)))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (315 - (147 + 138))) and (v93.TouchoftheMagi:CooldownRemains() > (929 - (813 + 86)))) or (v12:ManaPercentage() > (64 + 6))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) or ((7136 - 3284) == (785 - (18 + 474)))) then
					if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((526 + 1033) == (14974 - 10386))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				v139 = 1088 - (860 + 226);
			end
			if ((v139 == (305 - (121 + 182))) or ((552 + 3932) == (2028 - (988 + 252)))) then
				if (((516 + 4052) >= (1224 + 2683)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) == v111)) then
					if (((3216 - (49 + 1921)) < (4360 - (223 + 667))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 14";
					end
				end
				if (((4120 - (51 + 1)) >= (1672 - 700)) and v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v93.TemporalWarpBuff) or (v12:ManaPercentage() < (21 - 11)) or not v93.ShiftingPower:IsAvailable()) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (1137 - (146 + 979)))) then
					if (((140 + 353) < (4498 - (311 + 294))) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (139 - 89)) and not v93.Evocation:IsAvailable() and (v113 > (9 + 11))) or ((2916 - (496 + 947)) >= (4690 - (1233 + 125)))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((1644 + 2407) <= (1039 + 118))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((115 + 489) < (4526 - (963 + 682))) and v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (59 + 11)) and v104 and v12:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (1509 - (504 + 1000))) and (v113 > (14 + 6))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((820 + 80) == (319 + 3058))) then
						return "arcane_barrage rotation 20";
					end
				end
				v139 = 4 - 1;
			end
			if (((3810 + 649) > (344 + 247)) and (v139 == (186 - (156 + 26)))) then
				if (((1958 + 1440) >= (3746 - 1351)) and v93.ArcaneBlast:IsReady() and v32) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((2347 - (149 + 15)) >= (3784 - (890 + 70)))) then
						return "arcane_blast rotation 32";
					end
				end
				if (((2053 - (39 + 78)) == (2418 - (14 + 468))) and v93.ArcaneBarrage:IsReady() and v33) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((10625 - 5793) < (12054 - 7741))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
		end
	end
	local function v127()
		if (((2110 + 1978) > (2327 + 1547)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (3 + 9))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (6 + 6))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (4 + 8))) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (22 - 10))) or (v93.ArcaneOrb:Charges() == (0 + 0)) or (v93.ArcaneOrb:CooldownRemains() > (42 - 30)))) then
			if (((110 + 4222) == (4383 - (12 + 39))) and v20(v93.ShiftingPower, not v13:IsInRange(38 + 2), true)) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if (((12378 - 8379) >= (10328 - 7428)) and v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (2 + 4)) or (v101 > (4 + 2)) or not v93.OrbBarrage:IsAvailable())) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((6402 - 3877) > (2707 + 1357))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if (((21124 - 16753) == (6081 - (1596 + 114))) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v93.ArcaneArtilleryBuff) + (12 - 7)))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((979 - (164 + 549)) > (6424 - (1059 + 379)))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if (((2472 - 481) >= (480 + 445)) and v93.ArcaneBarrage:IsReady() and v33 and ((v100 <= (1 + 3)) or (v101 <= (396 - (145 + 247))) or v12:BuffUp(v93.ClearcastingBuff)) and (v12:ArcaneCharges() == (3 + 0))) then
			if (((211 + 244) < (6086 - 4033)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() == (0 + 0)) and (v93.TouchoftheMagi:CooldownRemains() > (16 + 2))) or ((1340 - 514) == (5571 - (254 + 466)))) then
			if (((743 - (544 + 16)) == (581 - 398)) and v20(v93.ArcaneOrb, not v13:IsInRange(668 - (294 + 334)))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if (((1412 - (236 + 17)) <= (771 + 1017)) and v93.ArcaneBarrage:IsReady() and v33 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (8 + 2)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((13207 - 9700) > (20443 - 16125))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v93.ArcaneExplosion:IsCastable() and v34) or ((1584 + 1491) <= (2443 + 522))) then
			if (((2159 - (413 + 381)) <= (85 + 1926)) and v20(v93.ArcaneExplosion, not v13:IsInRange(21 - 11))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1970 - (582 + 1388))) or ((4729 - 1953) > (2560 + 1015))) then
				if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(365 - (326 + 38), v93.ArcaneBarrage))) or ((7555 - 5001) == (6857 - 2053))) then
					if (((3197 - (47 + 573)) == (909 + 1668)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v12:IsChanneling(v93.Evocation) and (((v12:ManaPercentage() >= (403 - 308)) and not v93.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v113 * (5 - 1))) and not ((v113 > (1674 - (1269 + 395))) and (v93.ArcaneSurge:CooldownRemains() < (493 - (76 + 416))))))) or ((449 - (319 + 124)) >= (4317 - 2428))) then
					if (((1513 - (564 + 443)) <= (5237 - 3345)) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v113 < (460 - (337 + 121)))) or ((5883 - 3875) > (7388 - 5170))) then
					if (((2290 - (1261 + 650)) <= (1755 + 2392)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage main 34";
					end
				end
				v140 = 1 - 0;
			end
			if ((v140 == (1820 - (772 + 1045))) or ((637 + 3877) <= (1153 - (102 + 42)))) then
				if ((v29 and v93.RadiantSpark:IsAvailable() and v105) or ((5340 - (1524 + 320)) == (2462 - (1049 + 221)))) then
					local v209 = 156 - (18 + 138);
					while true do
						if (((0 - 0) == v209) or ((1310 - (67 + 1035)) == (3307 - (136 + 212)))) then
							v26 = v123();
							if (((18174 - 13897) >= (1052 + 261)) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				if (((2385 + 202) < (4778 - (240 + 1364))) and v29 and v109 and v93.RadiantSpark:IsAvailable() and v106) then
					local v210 = 1082 - (1050 + 32);
					while true do
						if (((0 - 0) == v210) or ((2438 + 1682) <= (3253 - (331 + 724)))) then
							v26 = v122();
							if (v26 or ((129 + 1467) == (1502 - (269 + 375)))) then
								return v26;
							end
							break;
						end
					end
				end
				if (((3945 - (267 + 458)) == (1002 + 2218)) and v29 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) then
					v26 = v125();
					if (v26 or ((2695 - 1293) > (4438 - (667 + 151)))) then
						return v26;
					end
				end
				v140 = 1501 - (1410 + 87);
			end
			if (((4471 - (1504 + 393)) == (6957 - 4383)) and (v140 == (2 - 1))) then
				if (((2594 - (461 + 335)) < (353 + 2404)) and v93.Evocation:IsCastable() and v39 and not v107 and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (1771 - (1730 + 31))) and (v93.TouchoftheMagi:CooldownRemains() < (1687 - (728 + 939)))) or (v93.TouchoftheMagi:CooldownRemains() < (53 - 38))) and (v12:ManaPercentage() < (v113 * (7 - 3)))) then
					if (v20(v93.Evocation) or ((863 - 486) > (3672 - (138 + 930)))) then
						return "evocation main 36";
					end
				end
				if (((520 + 48) < (713 + 198)) and v93.ConjureManaGem:IsCastable() and v38 and v13:DebuffDown(v93.TouchoftheMagiDebuff) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (26 + 4)) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) then
					if (((13413 - 10128) < (5994 - (459 + 1307))) and v20(v93.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((5786 - (474 + 1396)) > (5811 - 2483)) and v94.ManaGem:IsReady() and v40 and v93.CascadingPower:IsAvailable() and (v12:BuffStack(v93.ClearcastingBuff) < (2 + 0)) and v12:BuffUp(v93.ArcaneSurgeBuff)) then
					if (((9 + 2491) < (10996 - 7157)) and v20(v95.ManaGem)) then
						return "mana_gem main 40";
					end
				end
				v140 = 1 + 1;
			end
			if (((1692 - 1185) == (2211 - 1704)) and (v140 == (593 - (562 + 29)))) then
				if (((205 + 35) <= (4584 - (374 + 1045))) and v94.ManaGem:IsReady() and v40 and not v93.CascadingPower:IsAvailable() and v12:PrevGCDP(1 + 0, v93.ArcaneSurge) and (not v108 or (v108 and v12:PrevGCDP(5 - 3, v93.ArcaneSurge)))) then
					if (((1472 - (448 + 190)) >= (260 + 545)) and v20(v95.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (1 + 0 + v23(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v93.ArcaneSurgeBuff) > ((2 + 1) * v23(v12:HasTier(115 - 85, 5 - 3) and not v12:HasTier(1524 - (1307 + 187), 15 - 11)))) or v12:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (105 - 60)) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (11 - 7))) or (v93.TouchoftheMagi:CooldownRemains() > (703 - (232 + 451)))) and ((v100 < v103) or (v101 < v103))) or ((3640 + 172) < (2046 + 270))) then
					v26 = v121();
					if (v26 or ((3216 - (510 + 54)) <= (3088 - 1555))) then
						return v26;
					end
				end
				if ((not v109 and (v93.ArcaneSurge:CooldownRemains() > (66 - (13 + 23))) and (v93.RadiantSpark:CooldownUp() or v13:DebuffUp(v93.RadiantSparkDebuff) or v13:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (5 - 2))) or v13:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) or ((5169 - 1571) < (2652 - 1192))) then
					v26 = v121();
					if (v26 or ((5204 - (830 + 258)) < (4204 - 3012))) then
						return v26;
					end
				end
				v140 = 2 + 1;
			end
			if ((v140 == (4 + 0)) or ((4818 - (860 + 581)) <= (3330 - 2427))) then
				if (((3156 + 820) >= (680 - (237 + 4))) and v29 and v109 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) then
					v26 = v124();
					if (((8817 - 5065) == (9492 - 5740)) and v26) then
						return v26;
					end
				end
				if (((7670 - 3624) > (2206 + 489)) and ((v100 >= v103) or (v101 >= v103))) then
					local v211 = 0 + 0;
					while true do
						if ((v211 == (0 - 0)) or ((1522 + 2023) == (1739 + 1458))) then
							v26 = v127();
							if (((3820 - (85 + 1341)) > (635 - 262)) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				if (((11734 - 7579) <= (4604 - (45 + 327))) and ((v100 < v103) or (v101 < v103))) then
					local v212 = 0 - 0;
					while true do
						if ((v212 == (502 - (444 + 58))) or ((1557 + 2024) == (598 + 2875))) then
							v26 = v126();
							if (((2442 + 2553) > (9702 - 6354)) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v129()
		v32 = EpicSettings.Settings['useArcaneBlast'];
		v33 = EpicSettings.Settings['useArcaneBarrage'];
		v34 = EpicSettings.Settings['useArcaneExplosion'];
		v35 = EpicSettings.Settings['useArcaneFamiliar'];
		v36 = EpicSettings.Settings['useArcaneIntellect'];
		v37 = EpicSettings.Settings['useArcaneMissiles'];
		v38 = EpicSettings.Settings['useConjureManaGem'];
		v39 = EpicSettings.Settings['useEvocation'];
		v40 = EpicSettings.Settings['useManaGem'];
		v41 = EpicSettings.Settings['useNetherTempest'];
		v42 = EpicSettings.Settings['usePresenceOfMind'];
		v91 = EpicSettings.Settings['cancelPOM'];
		v43 = EpicSettings.Settings['useCounterspell'];
		v44 = EpicSettings.Settings['useBlastWave'];
		v45 = EpicSettings.Settings['useDragonsBreath'];
		v46 = EpicSettings.Settings['useArcaneSurge'];
		v47 = EpicSettings.Settings['useShiftingPower'];
		v48 = EpicSettings.Settings['useArcaneOrb'];
		v49 = EpicSettings.Settings['useRadiantSpark'];
		v50 = EpicSettings.Settings['useTouchOfTheMagi'];
		v51 = EpicSettings.Settings['arcaneSurgeWithCD'];
		v52 = EpicSettings.Settings['shiftingPowerWithCD'];
		v53 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
		v54 = EpicSettings.Settings['radiantSparkWithMiniCD'];
		v55 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
		v56 = EpicSettings.Settings['useAlterTime'];
		v57 = EpicSettings.Settings['usePrismaticBarrier'];
		v58 = EpicSettings.Settings['useGreaterInvisibility'];
		v59 = EpicSettings.Settings['useIceBlock'];
		v60 = EpicSettings.Settings['useIceCold'];
		v61 = EpicSettings.Settings['useMassBarrier'];
		v62 = EpicSettings.Settings['useMirrorImage'];
		v63 = EpicSettings.Settings['alterTimeHP'] or (1732 - (64 + 1668));
		v64 = EpicSettings.Settings['prismaticBarrierHP'] or (1973 - (1227 + 746));
		v65 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v66 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v67 = EpicSettings.Settings['iceColdHP'] or (494 - (415 + 79));
		v68 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
		v69 = EpicSettings.Settings['massBarrierHP'] or (491 - (142 + 349));
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v130()
		local v177 = 0 + 0;
		while true do
			if ((v177 == (0 - 0)) or ((375 + 379) > (2624 + 1100))) then
				v77 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v78 = EpicSettings.Settings['useWeapon'];
				v74 = EpicSettings.Settings['InterruptWithStun'];
				v177 = 1865 - (1710 + 154);
			end
			if (((535 - (200 + 118)) >= (23 + 34)) and ((8 - 3) == v177)) then
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v72 = EpicSettings.Settings['handleAfflicted'];
				v73 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v177 == (1 - 0)) or ((1840 + 230) >= (3994 + 43))) then
				v75 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v76 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['DispelDebuffs'];
				v177 = 2 + 0;
			end
			if (((432 + 2273) == (5860 - 3155)) and (v177 == (1253 - (363 + 887)))) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v177 = 6 - 2;
			end
			if (((290 - 229) == (10 + 51)) and (v177 == (9 - 5))) then
				v83 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (1664 - (674 + 990));
				v177 = 2 + 3;
			end
			if ((v177 == (1 + 1)) or ((1107 - 408) >= (2351 - (507 + 548)))) then
				v70 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v79 = EpicSettings.Settings['useRacials'];
				v177 = 840 - (289 + 548);
			end
		end
	end
	local function v131()
		v129();
		v130();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v30 = EpicSettings.Toggles['minicds'];
		v31 = EpicSettings.Toggles['dispel'];
		if (v12:IsDeadOrGhost() or ((3601 - (821 + 997)) >= (3871 - (195 + 60)))) then
			return v26;
		end
		v99 = v13:GetEnemiesInSplashRange(2 + 3);
		v102 = v12:GetEnemiesInRange(1541 - (251 + 1250));
		if (v28 or ((11463 - 7550) > (3111 + 1416))) then
			local v185 = 1032 - (809 + 223);
			while true do
				if (((6385 - 2009) > (2453 - 1636)) and ((0 - 0) == v185)) then
					v100 = v25(v13:GetEnemiesInSplashRangeCount(4 + 1), #v102);
					v101 = #v102;
					break;
				end
			end
		else
			local v186 = 0 + 0;
			while true do
				if (((5478 - (14 + 603)) > (953 - (118 + 11))) and (v186 == (0 + 0))) then
					v100 = 1 + 0;
					v101 = 2 - 1;
					break;
				end
			end
		end
		if (v97.TargetIsValid() or v12:AffectingCombat() or ((2332 - (551 + 398)) >= (1347 + 784))) then
			if (v12:AffectingCombat() or v71 or ((668 + 1208) >= (2066 + 475))) then
				local v202 = 0 - 0;
				local v203;
				while true do
					if (((4105 - 2323) <= (1223 + 2549)) and (v202 == (3 - 2))) then
						if (v26 or ((1298 + 3402) < (902 - (40 + 49)))) then
							return v26;
						end
						break;
					end
					if (((12182 - 8983) < (4540 - (99 + 391))) and (v202 == (0 + 0))) then
						v203 = v71 and v93.RemoveCurse:IsReady() and v31;
						v26 = v97.FocusUnit(v203, v95, 87 - 67, nil, 49 - 29);
						v202 = 1 + 0;
					end
				end
			end
			v112 = v9.BossFightRemains(nil, true);
			v113 = v112;
			if ((v113 == (29236 - 18125)) or ((6555 - (1032 + 572)) < (4847 - (203 + 214)))) then
				v113 = v9.FightRemains(v102, false);
			end
		end
		v114 = v12:GCD();
		if (((1913 - (568 + 1249)) == (76 + 20)) and v72) then
			if (v92 or ((6578 - 3839) > (15481 - 11473))) then
				v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 1336 - (913 + 393));
				if (v26 or ((64 - 41) == (1602 - 468))) then
					return v26;
				end
			end
		end
		if (not v12:AffectingCombat() or v27 or ((3103 - (269 + 141)) >= (9143 - 5032))) then
			local v187 = 1981 - (362 + 1619);
			while true do
				if ((v187 == (1625 - (950 + 675))) or ((1664 + 2652) <= (3325 - (216 + 963)))) then
					if ((v93.ArcaneIntellect:IsCastable() and v36 and (v12:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) or ((4833 - (485 + 802)) <= (3368 - (432 + 127)))) then
						if (((5977 - (1065 + 8)) > (1204 + 962)) and v20(v93.ArcaneIntellect)) then
							return "arcane_intellect group_buff";
						end
					end
					if (((1710 - (635 + 966)) >= (65 + 25)) and v93.ArcaneFamiliar:IsReady() and v35 and v12:BuffDown(v93.ArcaneFamiliarBuff)) then
						if (((5020 - (5 + 37)) > (7225 - 4320)) and v20(v93.ArcaneFamiliar)) then
							return "arcane_familiar precombat 2";
						end
					end
					v187 = 1 + 0;
				end
				if ((v187 == (1 - 0)) or ((1416 + 1610) <= (4737 - 2457))) then
					if ((v93.ConjureManaGem:IsCastable() and v38) or ((6266 - 4613) <= (2089 - 981))) then
						if (((6954 - 4045) > (1876 + 733)) and v20(v93.ConjureManaGem)) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
			end
		end
		if (((1286 - (318 + 211)) > (954 - 760)) and v97.TargetIsValid()) then
			if ((v71 and v31 and v93.RemoveCurse:IsAvailable()) or ((1618 - (963 + 624)) >= (598 + 800))) then
				local v204 = 846 - (518 + 328);
				while true do
					if (((7450 - 4254) <= (7786 - 2914)) and (v204 == (317 - (301 + 16)))) then
						if (((9748 - 6422) == (9340 - 6014)) and v14) then
							v26 = v117();
							if (((3739 - 2306) <= (3513 + 365)) and v26) then
								return v26;
							end
						end
						if ((v15 and v15:Exists() and v15:IsAPlayer() and v97.UnitHasCurseDebuff(v15)) or ((899 + 684) == (3703 - 1968))) then
							if (v93.RemoveCurse:IsReady() or ((1794 + 1187) == (224 + 2126))) then
								if (v20(v95.RemoveCurseMouseover) or ((14198 - 9732) <= (160 + 333))) then
									return "remove_curse dispel";
								end
							end
						end
						break;
					end
				end
			end
			if ((not v12:AffectingCombat() and v27) or ((3566 - (829 + 190)) <= (7089 - 5102))) then
				local v205 = 0 - 0;
				while true do
					if (((4093 - 1132) > (6806 - 4066)) and (v205 == (0 + 0))) then
						v26 = v119();
						if (((1208 + 2488) >= (10963 - 7351)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
			v26 = v115();
			if (v26 or ((2803 + 167) == (2491 - (520 + 93)))) then
				return v26;
			end
			if (v72 or ((3969 - (259 + 17)) < (114 + 1863))) then
				if (v92 or ((335 + 595) > (7112 - 5011))) then
					v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 621 - (396 + 195));
					if (((12049 - 7896) > (4847 - (440 + 1321))) and v26) then
						return v26;
					end
				end
			end
			if (v73 or ((6483 - (1059 + 770)) <= (18727 - 14677))) then
				local v206 = 545 - (424 + 121);
				while true do
					if (((0 + 0) == v206) or ((3949 - (641 + 706)) < (593 + 903))) then
						v26 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseOver, 470 - (249 + 191), true);
						if (v26 or ((4443 - 3423) > (1022 + 1266))) then
							return v26;
						end
						break;
					end
				end
			end
			if (((1264 - 936) == (755 - (183 + 244))) and v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v31 and v70 and not v12:IsCasting() and not v12:IsChanneling() and v97.UnitHasMagicBuff(v13)) then
				if (((75 + 1436) < (4538 - (434 + 296))) and v20(v93.Spellsteal, not v13:IsSpellInRange(v93.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if ((not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v97.TargetIsValid()) or ((8009 - 5499) > (5431 - (169 + 343)))) then
				local v207 = 0 + 0;
				local v208;
				while true do
					if (((8380 - 3617) == (13980 - 9217)) and (v207 == (2 + 0))) then
						if (((11732 - 7595) > (2971 - (651 + 472))) and v26) then
							return v26;
						end
						v26 = v128();
						if (((1841 + 595) <= (1353 + 1781)) and v26) then
							return v26;
						end
						break;
					end
					if (((4543 - 820) == (4206 - (397 + 86))) and (v207 == (876 - (423 + 453)))) then
						if ((v29 and v78 and (v94.Dreambinder:IsEquippedAndReady() or v94.Iridal:IsEquippedAndReady())) or ((412 + 3634) >= (569 + 3747))) then
							if (v20(v95.UseWeapon, nil) or ((1754 + 254) < (1540 + 389))) then
								return "Using Weapon Macro";
							end
						end
						v208 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
						if (((2130 + 254) > (2965 - (50 + 1140))) and v208) then
							return v208;
						end
						if ((v12:IsMoving() and v93.IceFloes:IsReady() and not v12:BuffUp(v93.IceFloes)) or ((3927 + 616) <= (2584 + 1792))) then
							if (((46 + 682) == (1044 - 316)) and v20(v93.IceFloes)) then
								return "ice_floes movement";
							end
						end
						v207 = 1 + 0;
					end
					if ((v207 == (597 - (157 + 439))) or ((1870 - 794) > (15520 - 10849))) then
						if (((5475 - 3624) >= (1296 - (782 + 136))) and v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (895 - (112 + 743))) or (v12:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + (1185 - (1026 + 145))))))) then
							if (v20(v93.TimeWarp, not v13:IsInRange(7 + 33)) or ((2666 - (493 + 225)) >= (12776 - 9300))) then
								return "time_warp main 4";
							end
						end
						if (((2917 + 1877) >= (2233 - 1400)) and v79 and ((v82 and v29) or not v82) and (v77 < v113)) then
							local v213 = 0 + 0;
							while true do
								if (((11688 - 7598) == (1191 + 2899)) and (v213 == (0 - 0))) then
									if ((v93.LightsJudgment:IsCastable() and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (1597 - (210 + 1385))) or (v101 >= (1691 - (1201 + 488))))) or ((2329 + 1429) == (4442 - 1944))) then
										if (v20(v93.LightsJudgment, not v13:IsSpellInRange(v93.LightsJudgment)) or ((4793 - 2120) < (2160 - (352 + 233)))) then
											return "lights_judgment main 6";
										end
									end
									if ((v93.Berserking:IsCastable() and ((v12:PrevGCDP(2 - 1, v93.ArcaneSurge) and not (v12:BuffUp(v93.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v93.ArcaneSurgeBuff) and v13:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((2025 + 1696) <= (4136 - 2681))) then
										if (((1508 - (489 + 85)) < (3771 - (277 + 1224))) and v20(v93.Berserking)) then
											return "berserking main 8";
										end
									end
									v213 = 1494 - (663 + 830);
								end
								if ((v213 == (1 + 0)) or ((3947 - 2335) == (2130 - (461 + 414)))) then
									if (v12:PrevGCDP(1 + 0, v93.ArcaneSurge) or ((1742 + 2610) < (401 + 3805))) then
										local v215 = 0 + 0;
										while true do
											if ((v215 == (251 - (172 + 78))) or ((4611 - 1751) <= (67 + 114))) then
												if (((4649 - 1427) >= (417 + 1110)) and v93.AncestralCall:IsCastable()) then
													if (((503 + 1002) <= (3553 - 1432)) and v20(v93.AncestralCall)) then
														return "ancestral_call main 14";
													end
												end
												break;
											end
											if (((935 - 191) == (188 + 556)) and (v215 == (0 + 0))) then
												if (v93.BloodFury:IsCastable() or ((705 + 1274) >= (11289 - 8453))) then
													if (((4270 - 2437) <= (819 + 1849)) and v20(v93.BloodFury)) then
														return "blood_fury main 10";
													end
												end
												if (((2105 + 1581) == (4133 - (133 + 314))) and v93.Fireblood:IsCastable()) then
													if (((603 + 2864) > (690 - (199 + 14))) and v20(v93.Fireblood)) then
														return "fireblood main 12";
													end
												end
												v215 = 3 - 2;
											end
										end
									end
									break;
								end
							end
						end
						if ((v77 < v113) or ((4837 - (647 + 902)) >= (10647 - 7106))) then
							if ((v80 and ((v29 and v81) or not v81)) or ((3790 - (85 + 148)) == (5829 - (426 + 863)))) then
								local v214 = 0 - 0;
								while true do
									if ((v214 == (1654 - (873 + 781))) or ((349 - 88) > (3421 - 2154))) then
										v26 = v118();
										if (((528 + 744) < (14252 - 10394)) and v26) then
											return v26;
										end
										break;
									end
								end
							end
						end
						v26 = v120();
						v207 = 2 - 0;
					end
				end
			end
		end
	end
	local function v132()
		v98();
		v18.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(183 - 121, v131, v132);
end;
return v0["Epix_Mage_Arcane.lua"]();

