local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3499 + 212) > (2009 + 1346)) and not v5) then
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
		if (v93.RemoveCurse:IsAvailable() or ((1584 - (356 + 322)) >= (6788 - 4559))) then
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
	local v103 = 1 + 2;
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v12:HasTier(43 - 14, 1248 - (485 + 759));
	local v110 = (520623 - 295623) - (((26189 - (442 + 747)) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((201135 - (832 + 303)) * v23(not v109)));
	local v111 = 949 - (88 + 858);
	local v112 = 3387 + 7724;
	local v113 = 9196 + 1915;
	local v114;
	v9:RegisterForEvent(function()
		local v133 = 0 + 0;
		while true do
			if (((2077 - (766 + 23)) > (6175 - 4924)) and (v133 == (2 - 0))) then
				v113 = 29274 - 18163;
				break;
			end
			if ((v133 == (3 - 2)) or ((5586 - (1036 + 37)) < (2377 + 975))) then
				v110 = (438162 - 213162) - (((19666 + 5334) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((201480 - (641 + 839)) * v23(not v109)));
				v112 = 12024 - (910 + 3);
				v133 = 4 - 2;
			end
			if ((v133 == (1684 - (1466 + 218))) or ((950 + 1115) >= (4344 - (556 + 592)))) then
				v104 = false;
				v107 = true;
				v133 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v109 = not v12:HasTier(837 - (329 + 479), 858 - (174 + 680));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (5 - 2)) or ((3125 + 1251) <= (2220 - (396 + 343)))) then
				if ((v93.AlterTime:IsReady() and v56 and (v12:HealthPercentage() <= v63)) or ((301 + 3091) >= (6218 - (29 + 1448)))) then
					if (((4714 - (135 + 1254)) >= (8114 - 5960)) and v20(v93.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((v94.Healthstone:IsReady() and v84 and (v12:HealthPercentage() <= v86)) or ((6046 - 4751) >= (2155 + 1078))) then
					if (((5904 - (389 + 1138)) > (2216 - (102 + 472))) and v20(v95.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v134 = 4 + 0;
			end
			if (((2620 + 2103) > (1265 + 91)) and (v134 == (1547 - (320 + 1225)))) then
				if ((v93.MirrorImage:IsCastable() and v62 and (v12:HealthPercentage() <= v68)) or ((7362 - 3226) <= (2101 + 1332))) then
					if (((5709 - (157 + 1307)) <= (6490 - (821 + 1038))) and v20(v93.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if (((10668 - 6392) >= (429 + 3485)) and v93.GreaterInvisibility:IsReady() and v58 and (v12:HealthPercentage() <= v65)) then
					if (((351 - 153) <= (1625 + 2740)) and v20(v93.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v134 = 7 - 4;
			end
			if (((5808 - (834 + 192)) > (298 + 4378)) and (v134 == (2 + 2))) then
				if (((105 + 4759) > (3402 - 1205)) and v83 and (v12:HealthPercentage() <= v85)) then
					local v199 = 304 - (300 + 4);
					while true do
						if ((v199 == (0 + 0)) or ((9685 - 5985) == (2869 - (112 + 250)))) then
							if (((1784 + 2690) >= (685 - 411)) and (v87 == "Refreshing Healing Potion")) then
								if (v94.RefreshingHealingPotion:IsReady() or ((1086 + 808) <= (728 + 678))) then
									if (((1176 + 396) >= (760 + 771)) and v20(v95.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v87 == "Dreamwalker's Healing Potion") or ((3482 + 1205) < (5956 - (1001 + 413)))) then
								if (((7338 - 4047) > (2549 - (244 + 638))) and v94.DreamwalkersHealingPotion:IsReady()) then
									if (v20(v95.RefreshingHealingPotion) or ((1566 - (627 + 66)) == (6060 - 4026))) then
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
			if (((603 - (512 + 90)) == v134) or ((4722 - (1665 + 241)) < (728 - (373 + 344)))) then
				if (((1669 + 2030) < (1246 + 3460)) and v93.IceBlock:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) then
					if (((6979 - 4333) >= (1481 - 605)) and v20(v93.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((1713 - (35 + 1064)) <= (2317 + 867)) and v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v60 and (v12:HealthPercentage() <= v67)) then
					if (((6688 - 3562) == (13 + 3113)) and v20(v93.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v134 = 1238 - (298 + 938);
			end
			if ((v134 == (1259 - (233 + 1026))) or ((3853 - (636 + 1030)) >= (2533 + 2421))) then
				if ((v93.PrismaticBarrier:IsCastable() and v57 and v12:BuffDown(v93.PrismaticBarrier) and (v12:HealthPercentage() <= v64)) or ((3787 + 90) == (1062 + 2513))) then
					if (((48 + 659) > (853 - (55 + 166))) and v20(v93.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v93.MassBarrier:IsCastable() and v61 and v12:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v69, 1 + 1, v93.ArcaneIntellect)) or ((55 + 491) >= (10250 - 7566))) then
					if (((1762 - (36 + 261)) <= (7521 - 3220)) and v20(v93.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v134 = 1369 - (34 + 1334);
			end
		end
	end
	local v116 = 0 + 0;
	local function v117()
		if (((1324 + 380) > (2708 - (1035 + 248))) and v93.RemoveCurse:IsReady() and (v97.UnitHasDispellableDebuffByPlayer(v14) or v97.DispellableFriendlyUnit(46 - (20 + 1)))) then
			local v193 = 0 + 0;
			while true do
				if ((v193 == (319 - (134 + 185))) or ((1820 - (549 + 584)) == (4919 - (314 + 371)))) then
					if ((v116 == (0 - 0)) or ((4298 - (478 + 490)) < (757 + 672))) then
						v116 = GetTime();
					end
					if (((2319 - (786 + 386)) >= (1084 - 749)) and v97.Wait(1879 - (1055 + 324), v116)) then
						local v209 = 1340 - (1093 + 247);
						while true do
							if (((3053 + 382) > (221 + 1876)) and (v209 == (0 - 0))) then
								if (v20(v95.RemoveCurseFocus) or ((12794 - 9024) >= (11498 - 7457))) then
									return "remove_curse dispel";
								end
								v116 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v118()
		local v135 = 0 + 0;
		while true do
			if (((3 - 2) == v135) or ((13066 - 9275) <= (1215 + 396))) then
				v26 = v97.HandleBottomTrinket(v96, v29, 102 - 62, nil);
				if (v26 or ((5266 - (364 + 324)) <= (5504 - 3496))) then
					return v26;
				end
				break;
			end
			if (((2699 - 1574) <= (689 + 1387)) and ((0 - 0) == v135)) then
				v26 = v97.HandleTopTrinket(v96, v29, 64 - 24, nil);
				if (v26 or ((2256 - 1513) >= (5667 - (1249 + 19)))) then
					return v26;
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v119()
		if (((4495 - 3340) < (2759 - (686 + 400))) and v93.MirrorImage:IsCastable() and v90 and v62) then
			if (v20(v93.MirrorImage) or ((1824 + 500) <= (807 - (73 + 156)))) then
				return "mirror_image precombat 2";
			end
		end
		if (((18 + 3749) == (4578 - (721 + 90))) and v93.ArcaneBlast:IsReady() and v32 and not v93.SiphonStorm:IsAvailable()) then
			if (((46 + 4043) == (13276 - 9187)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast precombat 4";
			end
		end
		if (((4928 - (224 + 246)) >= (2711 - 1037)) and v93.Evocation:IsReady() and v39 and (v93.SiphonStorm:IsAvailable())) then
			if (((1789 - 817) <= (258 + 1160)) and v20(v93.Evocation)) then
				return "evocation precombat 6";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53)) or ((118 + 4820) < (3498 + 1264))) then
			if (v20(v93.ArcaneOrb, not v13:IsInRange(79 - 39)) or ((8332 - 5828) > (4777 - (203 + 310)))) then
				return "arcane_orb precombat 8";
			end
		end
		if (((4146 - (1238 + 755)) == (151 + 2002)) and v93.ArcaneBlast:IsReady() and v32) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((2041 - (709 + 825)) >= (4774 - 2183))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v120()
		local v136 = 0 - 0;
		while true do
			if (((5345 - (196 + 668)) == (17692 - 13211)) and (v136 == (1 - 0))) then
				if ((v13:DebuffUp(v93.TouchoftheMagiDebuff) and v107) or ((3161 - (171 + 662)) < (786 - (4 + 89)))) then
					v107 = false;
				end
				v108 = v93.ArcaneBlast:CastTime() < v114;
				break;
			end
			if (((15169 - 10841) == (1576 + 2752)) and (v136 == (0 - 0))) then
				if (((623 + 965) >= (2818 - (35 + 1451))) and ((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (1453 - (28 + 1425))) or (v12:ArcaneCharges() >= (1996 - (941 + 1052)))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 0)))) then
					v105 = true;
				elseif ((v105 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (1521 - (822 + 692))) and v93.RadiantSpark:CooldownDown()) or ((5958 - 1784) > (2001 + 2247))) then
					v105 = false;
				end
				if (((v12:ArcaneCharges() > (300 - (45 + 252))) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (7 + 0))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (2 + 3))) or (v93.ArcaneSurge:CooldownRemains() > (97 - 57)))) or ((5019 - (114 + 319)) <= (117 - 35))) then
					v106 = true;
				elseif (((4949 - 1086) == (2463 + 1400)) and v106 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (9 - 2)) and v93.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				v136 = 1 - 0;
			end
		end
	end
	local function v121()
		if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(1964 - (556 + 1407), v93.ArcaneBarrage))) or ((1488 - (741 + 465)) <= (507 - (170 + 295)))) then
			if (((2429 + 2180) >= (704 + 62)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (v93.RadiantSpark:CooldownUp() or ((2836 - 1684) == (2063 + 425))) then
			v104 = v93.ArcaneSurge:CooldownRemains() < (7 + 3);
		end
		if (((1938 + 1484) > (4580 - (957 + 273))) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) then
			if (((235 + 642) > (151 + 225)) and v20(v93.ShiftingPower, not v13:IsInRange(152 - 112), true)) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and v93.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) or ((8216 - 5098) <= (5653 - 3802))) then
			if (v20(v93.ArcaneOrb, not v13:IsInRange(198 - 158)) or ((1945 - (389 + 1391)) >= (2191 + 1301))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if (((412 + 3537) < (11055 - 6199)) and v93.ArcaneBlast:IsReady() and v32 and v93.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (953 - (783 + 168))) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((14350 - 10074) < (2967 + 49))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if (((5001 - (309 + 2)) > (12667 - 8542)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (1212 - (1090 + 122))) and (v12:ManaPercentage() > (10 + 20)) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes)) or ((167 - 117) >= (614 + 282))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (1123 - (628 + 490))) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (2 + 4)))) and v12:HasTier(76 - 45, 18 - 14)) or ((2488 - (431 + 343)) >= (5973 - 3015))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((4313 - 2822) < (509 + 135))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if (((91 + 613) < (2682 - (556 + 1139))) and v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (32 - (6 + 9))) and not v12:HasTier(6 + 24, 3 + 1)) then
			if (((3887 - (28 + 141)) > (739 + 1167)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (2 - 0)) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1323 - (486 + 831))))) and not v12:HasTier(78 - 48, 13 - 9)) or ((182 + 776) > (11493 - 7858))) then
			if (((4764 - (668 + 595)) <= (4043 + 449)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (4 + 11)) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (13 - 8)))) and (v93.ArcaneSurge:CooldownRemains() < (320 - (23 + 267)))) or ((5386 - (1129 + 815)) < (2935 - (371 + 16)))) then
			if (((4625 - (1326 + 424)) >= (2772 - 1308)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v93.RadiantSpark:CooldownUp() and v12:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v12:BuffDown(v93.NetherPrecisionBuff) or (v12:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v12:HasTier(109 - 79, 122 - (88 + 30))) or ((5568 - (720 + 51)) >= (10884 - 5991))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((2327 - (421 + 1355)) > (3411 - 1343))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if (((1039 + 1075) > (2027 - (286 + 797))) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) then
			if (v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), v12:BuffDown(v93.IceFloes)) or ((8268 - 6006) >= (5127 - 2031))) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if ((v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (469 - (397 + 42))) and (v93.ArcaneEcho:IsAvailable())) or ((705 + 1550) >= (4337 - (24 + 776)))) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes)) or ((5910 - 2073) < (2091 - (222 + 563)))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if (((6499 - 3549) == (2124 + 826)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) then
			if (v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge), v12:BuffDown(v93.IceFloes)) or ((4913 - (23 + 167)) < (5096 - (690 + 1108)))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if (((410 + 726) >= (128 + 26)) and v93.ArcaneBarrage:IsReady() and v33 and (v12:PrevGCDP(849 - (40 + 808), v93.ArcaneSurge) or v12:PrevGCDP(1 + 0, v93.NetherTempest) or v12:PrevGCDP(3 - 2, v93.RadiantSpark))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((260 + 11) > (2512 + 2236))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if (((2600 + 2140) >= (3723 - (47 + 524))) and v93.ArcaneBlast:IsReady() and v32 and v13:DebuffUp(v93.RadiantSparkVulnerability) and (v13:DebuffStack(v93.RadiantSparkVulnerability) < (3 + 1))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((7046 - 4468) >= (5069 - 1679))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if (((93 - 52) <= (3387 - (1165 + 561))) and v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
			if (((18 + 583) < (11025 - 7465)) and v20(v93.PresenceofMind)) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if (((90 + 145) < (1166 - (341 + 138))) and v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.PresenceofMindBuff))) then
			if (((1228 + 3321) > (2379 - 1226)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v37 and v12:BuffDown(v93.NetherPrecisionBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v13:DebuffDown(v93.RadiantSparkVulnerability) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (330 - (89 + 237))) and v12:PrevGCDP(3 - 2, v93.ArcaneBlast)))) or ((9839 - 5165) < (5553 - (581 + 300)))) then
			if (((4888 - (855 + 365)) < (10833 - 6272)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32) or ((149 + 306) == (4840 - (1030 + 205)))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((2501 + 162) == (3082 + 230))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v122()
		if (((4563 - (156 + 130)) <= (10168 - 5693)) and v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (75 - 30)) and v13:DebuffDown(v93.NetherTempestDebuff) and v107 and v12:BloodlustUp()) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes)) or ((1781 - 911) == (314 + 875))) then
				return "nether_tempest spark_phase 2";
			end
		end
		if (((906 + 647) <= (3202 - (10 + 59))) and v107 and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes)) or ((11016 - 8779) >= (4674 - (671 + 492)))) then
				return "arcane_missiles interrupt spark_phase 4";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1221 - (369 + 846))))) and v12:HasTier(9 + 22, 4 + 0)) or ((3269 - (1036 + 909)) > (2402 + 618))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((5022 - 2030) == (2084 - (11 + 192)))) then
				return "arcane_missiles spark_phase 4";
			end
		end
		if (((1570 + 1536) > (1701 - (135 + 40))) and v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (36 - 21))) then
			if (((1823 + 1200) < (8525 - 4655)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast spark_phase 6";
			end
		end
		if (((214 - 71) > (250 - (50 + 126))) and v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (5 - 3)) and (v93.RadiantSpark:CooldownRemains() < (2 + 3)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1419 - (1233 + 180))))) then
			if (((987 - (522 + 447)) < (3533 - (107 + 1314))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles spark_phase 10";
			end
		end
		if (((510 + 587) <= (4960 - 3332)) and v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (7 + 8)) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (9 - 4)))) and (v93.ArcaneSurge:CooldownRemains() < (118 - 88))) then
			if (((6540 - (716 + 1194)) == (80 + 4550)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles spark_phase 12";
			end
		end
		if (((380 + 3160) > (3186 - (74 + 429))) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) then
			if (((9247 - 4453) >= (1624 + 1651)) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), v12:BuffDown(v93.IceFloes))) then
				return "radiant_spark spark_phase 14";
			end
		end
		if (((3396 - 1912) == (1050 + 434)) and v93.NetherTempest:IsReady() and v41 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (45 - 30)) and ((not v108 and v12:PrevGCDP(9 - 5, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v12:PrevGCDP(438 - (279 + 154), v93.RadiantSpark))) then
			if (((2210 - (454 + 324)) < (2797 + 758)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes))) then
				return "nether_tempest spark_phase 16";
			end
		end
		if ((v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v12:PrevGCDP(21 - (12 + 5), v93.RadiantSpark) and not v108) or v12:PrevGCDP(3 + 2, v93.RadiantSpark))) or v12:PrevGCDP(2 - 1, v93.NetherTempest))) or ((394 + 671) > (4671 - (277 + 816)))) then
			if (v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge), v12:BuffDown(v93.IceFloes)) or ((20489 - 15694) < (2590 - (1058 + 125)))) then
				return "arcane_surge spark_phase 18";
			end
		end
		if (((348 + 1505) < (5788 - (815 + 160))) and v93.ArcaneBlast:IsReady() and v32 and (v93.ArcaneBlast:CastTime() >= v12:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (150 - 115))) and ((v93.NetherTempest:IsAvailable() and v12:PrevGCDP(14 - 8, v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v12:PrevGCDP(2 + 3, v93.RadiantSpark))) and not (v12:IsCasting(v93.ArcaneSurge) and (v12:CastRemains() < (0.5 - 0)) and not v108)) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((4719 - (41 + 1857)) < (4324 - (1222 + 671)))) then
				return "arcane_blast spark_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (10 - 6))) or ((4130 - 1256) < (3363 - (229 + 953)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((4463 - (1111 + 663)) <= (1922 - (874 + 705)))) then
				return "arcane_barrage spark_phase 22";
			end
		end
		if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and v12:PrevGCDP(1 + 0, v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 + 0))) or (v12:GCDRemains() <= (0.2 - 0)))) or ((53 + 1816) == (2688 - (642 + 37)))) then
			if (v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes)) or ((809 + 2737) < (372 + 1950))) then
				return "touch_of_the_magi spark_phase 24";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32) or ((5227 - 3145) == (5227 - (233 + 221)))) then
			if (((7501 - 4257) > (929 + 126)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast spark_phase 26";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33) or ((4854 - (718 + 823)) <= (1119 + 659))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((2226 - (266 + 539)) >= (5956 - 3852))) then
				return "arcane_barrage spark_phase 28";
			end
		end
	end
	local function v123()
		local v137 = 1225 - (636 + 589);
		while true do
			if (((4301 - 2489) <= (6700 - 3451)) and (v137 == (2 + 0))) then
				if (((590 + 1033) <= (2972 - (657 + 358))) and v93.ArcaneBarrage:IsReady() and v33 and (v93.ArcaneSurge:CooldownRemains() < (198 - 123)) and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4)) and not v93.OrbBarrage:IsAvailable()) then
					if (((5599 - (1151 + 36)) == (4261 + 151)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if (((461 + 1289) >= (2514 - 1672)) and v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1834 - (1552 + 280))) and (v93.ArcaneSurge:CooldownRemains() > (909 - (64 + 770)))) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 0)) and (v93.ArcaneSurge:CooldownRemains() < (170 - 95)) and not v93.OrbBarrage:IsAvailable()))) then
					if (((777 + 3595) > (3093 - (157 + 1086))) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				if (((463 - 231) < (3595 - 2774)) and v93.ArcaneBarrage:IsReady() and v33 and ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 - 0)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 0)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (822 - (599 + 220))) and ((v100 > (9 - 4)) or (v101 > (1936 - (1813 + 118))))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (3 + 1))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) then
					if (((1735 - (841 + 376)) < (1263 - 361)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				v137 = 1 + 2;
			end
			if (((8172 - 5178) > (1717 - (464 + 395))) and (v137 == (2 - 1))) then
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (8 + 7)) and (v12:ArcaneCharges() < (840 - (467 + 370)))) or ((7759 - 4004) <= (672 + 243))) then
					if (((13526 - 9580) > (584 + 3159)) and v20(v93.ArcaneOrb, not v13:IsInRange(93 - 53))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				if ((v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (535 - (150 + 370))) and (v93.ArcaneEcho:IsAvailable())) or ((2617 - (74 + 1208)) >= (8131 - 4825))) then
					if (((22973 - 18129) > (1604 + 649)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if (((842 - (14 + 376)) == (783 - 331)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) then
					if (v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge), v12:BuffDown(v93.IceFloes)) or ((2949 + 1608) < (1834 + 253))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				v137 = 2 + 0;
			end
			if (((11351 - 7477) == (2915 + 959)) and (v137 == (78 - (23 + 55)))) then
				if ((v12:BuffUp(v93.PresenceofMindBuff) and v91 and (v12:PrevGCDP(2 - 1, v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (51 + 24))) or ((1741 + 197) > (7651 - 2716))) then
					if (v20(v95.CancelPOM) or ((1339 + 2916) < (4324 - (652 + 249)))) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if (((3891 - 2437) <= (4359 - (708 + 1160))) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(2 - 1, v93.ArcaneBarrage))) then
					if (v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes)) or ((7578 - 3421) <= (2830 - (10 + 17)))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if (((1090 + 3763) >= (4714 - (1400 + 332))) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) then
					if (((7928 - 3794) > (5265 - (242 + 1666))) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), v12:BuffDown(v93.IceFloes))) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (2 + 1)) or ((2913 + 504) < (3474 - (850 + 90)))) then
				if ((v93.PresenceofMind:IsCastable() and v42) or ((4767 - 2045) <= (1554 - (360 + 1030)))) then
					if (v20(v93.PresenceofMind) or ((2132 + 276) < (5952 - 3843))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and ((((v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 - 0)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (1664 - (909 + 752)))) and not v93.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) or ((1256 - (109 + 1114)) == (2663 - 1208))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((173 + 270) >= (4257 - (6 + 236)))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if (((2131 + 1251) > (134 + 32)) and v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4)) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (4 - 1)) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((1413 - (1076 + 57)) == (504 + 2555))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if (((2570 - (579 + 110)) > (103 + 1190)) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (8 + 1))) then
			v104 = not v104;
		end
		if (((1251 + 1106) == (2764 - (174 + 233))) and v93.NetherTempest:IsReady() and v41 and (v13:DebuffRefreshable(v93.NetherTempestDebuff) or not v13:DebuffUp(v93.NetherTempestDebuff)) and (v12:ArcaneCharges() == (11 - 7)) and (v12:ManaPercentage() < (52 - 22)) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) then
			if (((1297 - (663 + 511)) == (110 + 13)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes))) then
				return "nether_tempest touch_phase 2";
			end
		end
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v12:ArcaneCharges() < (1 + 1)) and (v12:ManaPercentage() < (92 - 62)) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) or ((2485 - 1429) >= (8210 - 4818))) then
			if (v20(v93.ArcaneOrb, not v13:IsInRange(20 + 20)) or ((2103 - 1022) < (767 + 308))) then
				return "arcane_orb touch_phase 4";
			end
		end
		if ((v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((96 + 953) >= (5154 - (478 + 244)))) then
			if (v20(v93.PresenceofMind) or ((5285 - (440 + 77)) <= (385 + 461))) then
				return "presence_of_mind touch_phase 6";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) or ((12290 - 8932) <= (2976 - (655 + 901)))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((694 + 3045) <= (2301 + 704))) then
				return "arcane_blast touch_phase 8";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (24 + 11)))) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((6683 - 5024) >= (3579 - (695 + 750)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((11132 - 7872) < (3633 - 1278))) then
				return "arcane_barrage touch_phase 10";
			end
		end
		if ((v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (381 - (285 + 66))) and (v93.TouchoftheMagi:CooldownRemains() > (69 - 39))) or (v12:ManaPercentage() > (1380 - (682 + 628)))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) or ((108 + 561) == (4522 - (176 + 123)))) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes)) or ((708 + 984) < (427 + 161))) then
				return "arcane_missiles interrupt touch_phase 12";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and (v12:BuffStack(v93.ClearcastingBuff) > (270 - (239 + 30))) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) or ((1305 + 3492) < (3510 + 141))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((7393 - 3216) > (15131 - 10281))) then
				return "arcane_missiles touch_phase 12";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.NetherPrecisionBuff))) or ((715 - (306 + 9)) > (3876 - 2765))) then
			if (((531 + 2520) > (617 + 388)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast touch_phase 14";
			end
		end
		if (((1778 + 1915) <= (12530 - 8148)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((4657 - (1140 + 235)) > (2610 + 1490))) then
				return "arcane_missiles touch_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32) or ((3283 + 297) < (730 + 2114))) then
			if (((141 - (33 + 19)) < (1622 + 2868)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast touch_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33) or ((14935 - 9952) < (797 + 1011))) then
			if (((7508 - 3679) > (3535 + 234)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
				return "arcane_barrage touch_phase 22";
			end
		end
	end
	local function v125()
		local v138 = 689 - (586 + 103);
		while true do
			if (((136 + 1349) <= (8940 - 6036)) and (v138 == (1489 - (1309 + 179)))) then
				if (((7706 - 3437) == (1859 + 2410)) and v93.ArcaneBarrage:IsReady() and v33 and ((((v100 <= (10 - 6)) or (v101 <= (4 + 0))) and (v12:ArcaneCharges() == (5 - 2))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) then
					if (((770 - 383) <= (3391 - (295 + 314))) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (4 - 2))) or ((3861 - (1300 + 662)) <= (2879 - 1962))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(1795 - (1178 + 577))) or ((2240 + 2072) <= (2589 - 1713))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v138 = 1407 - (851 + 554);
			end
			if (((1974 + 258) <= (7199 - 4603)) and (v138 == (3 - 1))) then
				if (((2397 - (115 + 187)) < (2823 + 863)) and v93.ArcaneExplosion:IsCastable() and v34) then
					if (v20(v93.ArcaneExplosion, not v13:IsInRange(10 + 0)) or ((6285 - 4690) >= (5635 - (160 + 1001)))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((v138 == (0 + 0)) or ((3188 + 1431) < (5899 - 3017))) then
				if ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (367 - (237 + 121))) or ((1191 - (525 + 372)) >= (9158 - 4327))) then
					v104 = not v104;
				end
				if (((6666 - 4637) <= (3226 - (96 + 46))) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff)) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((2814 - (643 + 134)) == (874 + 1546))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v126()
		if (((16551 - 12093) > (3745 + 159)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (5 - 2)) and (v12:BloodlustDown() or (v12:ManaPercentage() > (143 - 73)) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (749 - (316 + 403)))))) then
			if (((290 + 146) >= (338 - 215)) and v20(v93.ArcaneOrb, not v13:IsInRange(15 + 25))) then
				return "arcane_orb rotation 2";
			end
		end
		v104 = ((v93.ArcaneSurge:CooldownRemains() > (75 - 45)) and (v93.TouchoftheMagi:CooldownRemains() > (8 + 2))) or false;
		if (((162 + 338) < (6292 - 4476)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (57 - 45))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (24 - 12))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (1 + 11))) and (v113 > (29 - 14))) then
			if (((175 + 3399) == (10514 - 6940)) and v20(v93.ShiftingPower, not v13:IsInRange(57 - (12 + 5)))) then
				return "shifting_power rotation 4";
			end
		end
		if (((858 - 637) < (832 - 442)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and not v109 and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (95 - 50)) and (v113 > (37 - 22))) then
			if (v20(v93.ShiftingPower, not v13:IsInRange(9 + 31)) or ((4186 - (1656 + 317)) <= (1267 + 154))) then
				return "shifting_power rotation 6";
			end
		end
		if (((2451 + 607) < (12922 - 8062)) and v93.PresenceofMind:IsCastable() and v42 and (v12:ArcaneCharges() < (14 - 11)) and (v13:HealthPercentage() < (389 - (5 + 349))) and v93.ArcaneBombardment:IsAvailable()) then
			if (v20(v93.PresenceofMind) or ((6155 - 4859) >= (5717 - (266 + 1005)))) then
				return "presence_of_mind rotation 8";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v93.TimeAnomaly:IsAvailable() and v12:BuffUp(v93.ArcaneSurgeBuff) and (v12:BuffRemains(v93.ArcaneSurgeBuff) <= (4 + 2))) or ((4752 - 3359) > (5909 - 1420))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((6120 - (561 + 1135)) < (35 - 8))) then
				return "arcane_blast rotation 10";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v13:HealthPercentage() < (115 - 80)) and v93.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (1069 - (507 + 559)))) or ((5010 - 3013) > (11798 - 7983))) then
			if (((3853 - (212 + 176)) > (2818 - (250 + 655))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast rotation 12";
			end
		end
		if (((1998 - 1265) < (3177 - 1358)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 - 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (1986 - (1869 + 87))) and (v93.TouchoftheMagi:CooldownRemains() > (104 - 74))) or (v12:ManaPercentage() > (1971 - (484 + 1417)))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes)) or ((9420 - 5025) == (7968 - 3213))) then
				return "arcane_missiles interrupt rotation 20";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) == v111)) or ((4566 - (48 + 725)) < (3869 - 1500))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((10956 - 6872) == (155 + 110))) then
				return "arcane_missiles rotation 14";
			end
		end
		if (((11646 - 7288) == (1220 + 3138)) and v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v93.TemporalWarpBuff) or (v12:ManaPercentage() < (3 + 7)) or not v93.ShiftingPower:IsAvailable()) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (865 - (152 + 701)))) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes)) or ((4449 - (430 + 881)) < (381 + 612))) then
				return "nether_tempest rotation 16";
			end
		end
		if (((4225 - (557 + 338)) > (687 + 1636)) and v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (140 - 90)) and not v93.Evocation:IsAvailable() and (v113 > (70 - 50))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((9633 - 6007) == (8596 - 4607))) then
				return "arcane_barrage rotation 18";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (871 - (499 + 302))) and v104 and v12:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (871 - (39 + 827))) and (v113 > (55 - 35))) or ((2045 - 1129) == (10608 - 7937))) then
			if (((417 - 145) == (24 + 248)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
				return "arcane_barrage rotation 20";
			end
		end
		if (((12436 - 8187) <= (775 + 4064)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffUp(v93.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
			if (((4393 - 1616) < (3304 - (103 + 1))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
				return "arcane_missiles rotation 22";
			end
		end
		if (((649 - (475 + 79)) < (4230 - 2273)) and v93.ArcaneBlast:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v93.NetherPrecisionBuff)) then
			if (((2643 - 1817) < (222 + 1495)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast rotation 24";
			end
		end
		if (((1255 + 171) >= (2608 - (1395 + 108))) and v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (174 - 114)) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (1214 - (7 + 1197))) and (v93.Evocation:CooldownRemains() > (18 + 22)) and (v113 > (7 + 13))) then
			if (((3073 - (27 + 292)) <= (9901 - 6522)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
				return "arcane_barrage rotation 26";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) or ((5007 - 1080) == (5925 - 4512))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((2275 - 1121) <= (1500 - 712))) then
				return "arcane_missiles rotation 30";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32) or ((1782 - (43 + 96)) > (13783 - 10404))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((6337 - 3534) > (3775 + 774))) then
				return "arcane_blast rotation 32";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33) or ((63 + 157) >= (5972 - 2950))) then
			if (((1082 + 1740) == (5288 - 2466)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
				return "arcane_barrage rotation 34";
			end
		end
	end
	local function v127()
		if ((v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (4 + 8))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (1 + 11))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (1763 - (1414 + 337)))) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (1952 - (1642 + 298)))) or (v93.ArcaneOrb:Charges() == (0 - 0)) or (v93.ArcaneOrb:CooldownRemains() > (34 - 22)))) or ((3148 - 2087) == (612 + 1245))) then
			if (((2148 + 612) > (2336 - (357 + 615))) and v20(v93.ShiftingPower, not v13:IsInRange(29 + 11), true)) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (14 - 8)) or (v101 > (6 + 0)) or not v93.OrbBarrage:IsAvailable())) or ((10505 - 5603) <= (2876 + 719))) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes)) or ((262 + 3590) == (185 + 108))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v93.ArcaneArtilleryBuff) + (1306 - (384 + 917))))) or ((2256 - (128 + 569)) == (6131 - (1407 + 136)))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes) and not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((6371 - (687 + 1200)) == (2498 - (556 + 1154)))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if (((16070 - 11502) >= (4002 - (9 + 86))) and v93.ArcaneBarrage:IsReady() and v33 and ((v100 <= (425 - (275 + 146))) or (v101 <= (1 + 3)) or v12:BuffUp(v93.ClearcastingBuff)) and (v12:ArcaneCharges() == (67 - (29 + 35)))) then
			if (((5522 - 4276) < (10364 - 6894)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false)) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if (((17958 - 13890) >= (634 + 338)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() == (1012 - (53 + 959))) and (v93.TouchoftheMagi:CooldownRemains() > (426 - (312 + 96)))) then
			if (((855 - 362) < (4178 - (147 + 138))) and v20(v93.ArcaneOrb, not v13:IsInRange(939 - (813 + 86)))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (10 + 0)))) or ((2728 - 1255) >= (3824 - (18 + 474)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((1367 + 2684) <= (3776 - 2619))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if (((1690 - (860 + 226)) < (3184 - (121 + 182))) and v93.ArcaneExplosion:IsCastable() and v34) then
			if (v20(v93.ArcaneExplosion, not v13:IsInRange(2 + 8)) or ((2140 - (988 + 252)) == (382 + 2995))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v128()
		local v139 = 0 + 0;
		while true do
			if (((6429 - (49 + 1921)) > (1481 - (223 + 667))) and (v139 == (53 - (51 + 1)))) then
				if (((5848 - 2450) >= (5128 - 2733)) and v93.Evocation:IsCastable() and v39 and not v107 and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (1135 - (146 + 979))) and (v93.TouchoftheMagi:CooldownRemains() < (6 + 14))) or (v93.TouchoftheMagi:CooldownRemains() < (620 - (311 + 294)))) and (v12:ManaPercentage() < (v113 * (11 - 7)))) then
					if (v20(v93.Evocation) or ((925 + 1258) >= (4267 - (496 + 947)))) then
						return "evocation main 36";
					end
				end
				if (((3294 - (1233 + 125)) == (786 + 1150)) and v93.ConjureManaGem:IsCastable() and v38 and v13:DebuffDown(v93.TouchoftheMagiDebuff) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (27 + 3)) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) then
					if (v20(v93.ConjureManaGem) or ((919 + 3913) < (5958 - (963 + 682)))) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((3412 + 676) > (5378 - (504 + 1000))) and v94.ManaGem:IsReady() and v40 and v93.CascadingPower:IsAvailable() and (v12:BuffStack(v93.ClearcastingBuff) < (2 + 0)) and v12:BuffUp(v93.ArcaneSurgeBuff)) then
					if (((3946 + 386) == (409 + 3923)) and v20(v95.ManaGem)) then
						return "mana_gem main 40";
					end
				end
				v139 = 2 - 0;
			end
			if (((3417 + 582) >= (1687 + 1213)) and (v139 == (184 - (156 + 26)))) then
				if ((v94.ManaGem:IsReady() and v40 and not v93.CascadingPower:IsAvailable() and v12:PrevGCDP(1 + 0, v93.ArcaneSurge) and (not v108 or (v108 and v12:PrevGCDP(2 - 0, v93.ArcaneSurge)))) or ((2689 - (149 + 15)) > (5024 - (890 + 70)))) then
					if (((4488 - (39 + 78)) == (4853 - (14 + 468))) and v20(v95.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * ((2 - 1) + v23(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v93.ArcaneSurgeBuff) > ((8 - 5) * v23(v12:HasTier(16 + 14, 2 + 0) and not v12:HasTier(7 + 23, 2 + 2)))) or v12:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (12 + 33)) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (7 - 3))) or (v93.TouchoftheMagi:CooldownRemains() > (20 + 0))) and ((v100 < v103) or (v101 < v103))) or ((934 - 668) > (126 + 4860))) then
					local v200 = 51 - (12 + 39);
					while true do
						if (((1853 + 138) >= (2863 - 1938)) and (v200 == (0 - 0))) then
							v26 = v121();
							if (((135 + 320) < (1081 + 972)) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				if ((not v109 and (v93.ArcaneSurge:CooldownRemains() > (76 - 46)) and (v93.RadiantSpark:CooldownUp() or v13:DebuffUp(v93.RadiantSparkDebuff) or v13:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 1))) or v13:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) or ((3991 - 3165) == (6561 - (1596 + 114)))) then
					local v201 = 0 - 0;
					while true do
						if (((896 - (164 + 549)) == (1621 - (1059 + 379))) and (v201 == (0 - 0))) then
							v26 = v121();
							if (((601 + 558) <= (302 + 1486)) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				v139 = 395 - (145 + 247);
			end
			if ((v139 == (0 + 0)) or ((1621 + 1886) > (12801 - 8483))) then
				if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(1 + 0, v93.ArcaneBarrage))) or ((2649 + 426) <= (4813 - 1848))) then
					if (((2085 - (254 + 466)) <= (2571 - (544 + 16))) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v12:IsChanneling(v93.Evocation) and (((v12:ManaPercentage() >= (301 - 206)) and not v93.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v113 * (632 - (294 + 334)))) and not ((v113 > (263 - (236 + 17))) and (v93.ArcaneSurge:CooldownRemains() < (1 + 0)))))) or ((2161 + 615) > (13463 - 9888))) then
					if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles), v12:BuffDown(v93.IceFloes)) or ((12091 - 9537) == (2474 + 2330))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((2123 + 454) == (3371 - (413 + 381))) and v93.ArcaneBarrage:IsReady() and v33 and (v113 < (1 + 1))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((12 - 6) >= (4906 - 3017))) then
						return "arcane_barrage main 34";
					end
				end
				v139 = 1971 - (582 + 1388);
			end
			if (((861 - 355) <= (1355 + 537)) and (v139 == (367 - (326 + 38)))) then
				if ((v29 and v93.RadiantSpark:IsAvailable() and v105) or ((5939 - 3931) > (3165 - 947))) then
					local v202 = 620 - (47 + 573);
					while true do
						if (((134 + 245) <= (17612 - 13465)) and (v202 == (0 - 0))) then
							v26 = v123();
							if (v26 or ((6178 - (1269 + 395)) <= (1501 - (76 + 416)))) then
								return v26;
							end
							break;
						end
					end
				end
				if ((v29 and v109 and v93.RadiantSpark:IsAvailable() and v106) or ((3939 - (319 + 124)) == (2724 - 1532))) then
					v26 = v122();
					if (v26 or ((1215 - (564 + 443)) == (8191 - 5232))) then
						return v26;
					end
				end
				if (((4735 - (337 + 121)) >= (3846 - 2533)) and v29 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) then
					local v203 = 0 - 0;
					while true do
						if (((4498 - (1261 + 650)) < (1343 + 1831)) and ((0 - 0) == v203)) then
							v26 = v125();
							if (v26 or ((5937 - (772 + 1045)) <= (311 + 1887))) then
								return v26;
							end
							break;
						end
					end
				end
				v139 = 148 - (102 + 42);
			end
			if ((v139 == (1848 - (1524 + 320))) or ((2866 - (1049 + 221)) == (1014 - (18 + 138)))) then
				if (((7881 - 4661) == (4322 - (67 + 1035))) and v29 and v109 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) then
					v26 = v124();
					if (v26 or ((1750 - (136 + 212)) > (15382 - 11762))) then
						return v26;
					end
				end
				if (((2063 + 511) == (2373 + 201)) and ((v100 >= v103) or (v101 >= v103))) then
					local v204 = 1604 - (240 + 1364);
					while true do
						if (((2880 - (1050 + 32)) < (9843 - 7086)) and (v204 == (0 + 0))) then
							v26 = v127();
							if (v26 or ((1432 - (331 + 724)) > (211 + 2393))) then
								return v26;
							end
							break;
						end
					end
				end
				if (((1212 - (269 + 375)) < (1636 - (267 + 458))) and ((v100 < v103) or (v101 < v103))) then
					local v205 = 0 + 0;
					while true do
						if (((6317 - 3032) < (5046 - (667 + 151))) and ((1497 - (1410 + 87)) == v205)) then
							v26 = v126();
							if (((5813 - (1504 + 393)) > (8995 - 5667)) and v26) then
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
		v63 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v64 = EpicSettings.Settings['prismaticBarrierHP'] or (796 - (461 + 335));
		v65 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v66 = EpicSettings.Settings['iceBlockHP'] or (1761 - (1730 + 31));
		v67 = EpicSettings.Settings['iceColdHP'] or (1667 - (728 + 939));
		v68 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v69 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v130()
		v77 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v78 = EpicSettings.Settings['useWeapon'];
		v74 = EpicSettings.Settings['InterruptWithStun'];
		v75 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v76 = EpicSettings.Settings['InterruptThreshold'];
		v71 = EpicSettings.Settings['DispelDebuffs'];
		v70 = EpicSettings.Settings['DispelBuffs'];
		v80 = EpicSettings.Settings['useTrinkets'];
		v79 = EpicSettings.Settings['useRacials'];
		v81 = EpicSettings.Settings['trinketsWithCD'];
		v82 = EpicSettings.Settings['racialsWithCD'];
		v84 = EpicSettings.Settings['useHealthstone'];
		v83 = EpicSettings.Settings['useHealingPotion'];
		v86 = EpicSettings.Settings['healthstoneHP'] or (1068 - (138 + 930));
		v85 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v87 = EpicSettings.Settings['HealingPotionName'] or "";
		v72 = EpicSettings.Settings['handleAfflicted'];
		v73 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v131()
		local v190 = 0 + 0;
		while true do
			if (((2143 + 357) < (15675 - 11836)) and ((1766 - (459 + 1307)) == v190)) then
				v129();
				v130();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v190 = 1871 - (474 + 1396);
			end
			if (((884 - 377) == (476 + 31)) and (v190 == (1 + 0))) then
				v29 = EpicSettings.Toggles['cds'];
				v30 = EpicSettings.Toggles['minicds'];
				v31 = EpicSettings.Toggles['dispel'];
				if (((687 - 447) <= (402 + 2763)) and v12:IsDeadOrGhost()) then
					return v26;
				end
				v190 = 6 - 4;
			end
			if (((3637 - 2803) >= (1396 - (562 + 29))) and (v190 == (3 + 0))) then
				v114 = v12:GCD();
				if (v72 or ((5231 - (374 + 1045)) < (1834 + 482))) then
					if (v92 or ((8234 - 5582) <= (2171 - (448 + 190)))) then
						v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 10 + 20);
						if (v26 or ((1625 + 1973) < (952 + 508))) then
							return v26;
						end
					end
				end
				if (not v12:AffectingCombat() or v27 or ((15825 - 11709) < (3703 - 2511))) then
					local v206 = 1494 - (1307 + 187);
					while true do
						if (((3 - 2) == v206) or ((7906 - 4529) <= (2768 - 1865))) then
							if (((4659 - (232 + 451)) >= (420 + 19)) and v93.ConjureManaGem:IsCastable() and v38) then
								if (((3315 + 437) == (4316 - (510 + 54))) and v20(v93.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
						if (((8151 - 4105) > (2731 - (13 + 23))) and (v206 == (0 - 0))) then
							if ((v93.ArcaneIntellect:IsCastable() and v36 and (v12:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) or ((5093 - 1548) == (5808 - 2611))) then
								if (((3482 - (830 + 258)) > (1315 - 942)) and v20(v93.ArcaneIntellect)) then
									return "arcane_intellect group_buff";
								end
							end
							if (((2600 + 1555) <= (3601 + 631)) and v93.ArcaneFamiliar:IsReady() and v35 and v12:BuffDown(v93.ArcaneFamiliarBuff)) then
								if (v20(v93.ArcaneFamiliar) or ((5022 - (860 + 581)) == (12810 - 9337))) then
									return "arcane_familiar precombat 2";
								end
							end
							v206 = 1 + 0;
						end
					end
				end
				if (((5236 - (237 + 4)) > (7868 - 4520)) and v97.TargetIsValid()) then
					if ((v71 and v31 and v93.RemoveCurse:IsAvailable()) or ((1907 - 1153) > (7060 - 3336))) then
						if (((178 + 39) >= (33 + 24)) and v14) then
							local v214 = 0 - 0;
							while true do
								if ((v214 == (0 + 0)) or ((1126 + 944) >= (5463 - (85 + 1341)))) then
									v26 = v117();
									if (((4615 - 1910) == (7639 - 4934)) and v26) then
										return v26;
									end
									break;
								end
							end
						end
						if (((433 - (45 + 327)) == (114 - 53)) and v15 and v15:Exists() and not v12:CanAttack(v15) and v97.UnitHasCurseDebuff(v15)) then
							if (v93.RemoveCurse:IsReady() or ((1201 - (444 + 58)) >= (564 + 732))) then
								if (v20(v95.RemoveCurseMouseover) or ((307 + 1476) >= (1768 + 1848))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if ((not v12:AffectingCombat() and v27) or ((11339 - 7426) > (6259 - (64 + 1668)))) then
						local v210 = 1973 - (1227 + 746);
						while true do
							if (((13450 - 9074) > (1515 - 698)) and ((494 - (415 + 79)) == v210)) then
								v26 = v119();
								if (((125 + 4736) > (1315 - (142 + 349))) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					v26 = v115();
					if (v26 or ((593 + 790) >= (2929 - 798))) then
						return v26;
					end
					if (v72 or ((933 + 943) >= (1791 + 750))) then
						if (((4852 - 3070) <= (5636 - (1710 + 154))) and v92) then
							v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 348 - (200 + 118));
							if (v26 or ((1863 + 2837) < (1421 - 608))) then
								return v26;
							end
						end
					end
					if (((4744 - 1545) < (3599 + 451)) and v73) then
						local v211 = 0 + 0;
						while true do
							if ((v211 == (0 + 0)) or ((791 + 4160) < (9597 - 5167))) then
								v26 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseover, 1280 - (363 + 887));
								if (((167 - 71) == (456 - 360)) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					if ((v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v31 and v70 and not v12:IsCasting() and not v12:IsChanneling() and v97.UnitHasMagicBuff(v13)) or ((423 + 2316) > (9378 - 5370))) then
						if (v20(v93.Spellsteal, not v13:IsSpellInRange(v93.Spellsteal)) or ((16 + 7) == (2798 - (674 + 990)))) then
							return "spellsteal damage";
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v97.TargetIsValid()) or ((773 + 1920) >= (1683 + 2428))) then
						if ((v29 and v78 and (v94.Dreambinder:IsEquippedAndReady() or v94.Iridal:IsEquippedAndReady())) or ((6840 - 2524) <= (3201 - (507 + 548)))) then
							if (v20(v95.UseWeapon, nil) or ((4383 - (289 + 548)) <= (4627 - (821 + 997)))) then
								return "Using Weapon Macro";
							end
						end
						local v212 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
						if (((5159 - (195 + 60)) > (583 + 1583)) and v212) then
							return v212;
						end
						if (((1610 - (251 + 1250)) >= (263 - 173)) and v12:IsMoving() and v93.IceFloes:IsReady() and not v12:BuffUp(v93.IceFloes)) then
							if (((3421 + 1557) > (3937 - (809 + 223))) and v20(v93.IceFloes)) then
								return "ice_floes movement";
							end
						end
						if ((v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (58 - 18)) or (v12:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + (41 - 27)))))) or ((10005 - 6979) <= (1680 + 600))) then
							if (v20(v93.TimeWarp, not v13:IsInRange(21 + 19)) or ((2270 - (14 + 603)) <= (1237 - (118 + 11)))) then
								return "time_warp main 4";
							end
						end
						if (((471 + 2438) > (2174 + 435)) and v79 and ((v82 and v29) or not v82) and (v77 < v113)) then
							if (((2206 - 1449) > (1143 - (551 + 398))) and v93.LightsJudgment:IsCastable() and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (2 + 0)) or (v101 >= (1 + 1)))) then
								if (v20(v93.LightsJudgment, not v13:IsSpellInRange(v93.LightsJudgment)) or ((26 + 5) >= (5199 - 3801))) then
									return "lights_judgment main 6";
								end
							end
							if (((7363 - 4167) <= (1580 + 3292)) and v93.Berserking:IsCastable() and ((v12:PrevGCDP(3 - 2, v93.ArcaneSurge) and not (v12:BuffUp(v93.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v93.ArcaneSurgeBuff) and v13:DebuffUp(v93.TouchoftheMagiDebuff)))) then
								if (((919 + 2407) == (3415 - (40 + 49))) and v20(v93.Berserking)) then
									return "berserking main 8";
								end
							end
							if (((5457 - 4024) <= (4368 - (99 + 391))) and v12:PrevGCDP(1 + 0, v93.ArcaneSurge)) then
								local v215 = 0 - 0;
								while true do
									if ((v215 == (2 - 1)) or ((1542 + 41) == (4565 - 2830))) then
										if (v93.AncestralCall:IsCastable() or ((4585 - (1032 + 572)) == (2767 - (203 + 214)))) then
											if (v20(v93.AncestralCall) or ((6283 - (568 + 1249)) <= (386 + 107))) then
												return "ancestral_call main 14";
											end
										end
										break;
									end
									if ((v215 == (0 - 0)) or ((9837 - 7290) <= (3293 - (913 + 393)))) then
										if (((8361 - 5400) > (3871 - 1131)) and v93.BloodFury:IsCastable()) then
											if (((4106 - (269 + 141)) >= (8033 - 4421)) and v20(v93.BloodFury)) then
												return "blood_fury main 10";
											end
										end
										if (v93.Fireblood:IsCastable() or ((4951 - (362 + 1619)) == (3503 - (950 + 675)))) then
											if (v20(v93.Fireblood) or ((1424 + 2269) < (3156 - (216 + 963)))) then
												return "fireblood main 12";
											end
										end
										v215 = 1288 - (485 + 802);
									end
								end
							end
						end
						if ((v77 < v113) or ((1489 - (432 + 127)) > (3174 - (1065 + 8)))) then
							if (((2307 + 1846) > (4687 - (635 + 966))) and v80 and ((v29 and v81) or not v81)) then
								v26 = v118();
								if (v26 or ((3347 + 1307) <= (4092 - (5 + 37)))) then
									return v26;
								end
							end
						end
						v26 = v120();
						if (v26 or ((6471 - 3869) < (623 + 873))) then
							return v26;
						end
						v26 = v128();
						if (v26 or ((1614 - 594) > (1071 + 1217))) then
							return v26;
						end
					end
				end
				break;
			end
			if (((681 - 353) == (1243 - 915)) and (v190 == (3 - 1))) then
				v99 = v13:GetEnemiesInSplashRange(11 - 6);
				v102 = v12:GetEnemiesInRange(29 + 11);
				if (((2040 - (318 + 211)) < (18737 - 14929)) and v28) then
					local v207 = 1587 - (963 + 624);
					while true do
						if ((v207 == (0 + 0)) or ((3356 - (518 + 328)) > (11466 - 6547))) then
							v100 = v25(v13:GetEnemiesInSplashRangeCount(7 - 2), #v102);
							v101 = #v102;
							break;
						end
					end
				else
					local v208 = 317 - (301 + 16);
					while true do
						if (((13959 - 9196) == (13376 - 8613)) and (v208 == (0 - 0))) then
							v100 = 1 + 0;
							v101 = 1 + 0;
							break;
						end
					end
				end
				if (((8832 - 4695) > (1112 + 736)) and (v97.TargetIsValid() or v12:AffectingCombat())) then
					if (((232 + 2204) <= (9963 - 6829)) and (v12:AffectingCombat() or v71)) then
						local v213 = v71 and v93.RemoveCurse:IsReady() and v31;
						v26 = v97.FocusUnit(v213, nil, 7 + 13, nil, 1039 - (829 + 190), v93.ArcaneIntellect);
						if (((13283 - 9560) == (4710 - 987)) and v26) then
							return v26;
						end
					end
					v112 = v9.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (15359 - 4248)) or ((10050 - 6004) >= (1023 + 3293))) then
						v113 = v9.FightRemains(v102, false);
					end
				end
				v190 = 1 + 2;
			end
		end
	end
	local function v132()
		v98();
		v18.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(187 - 125, v131, v132);
end;
return v0["Epix_Mage_Arcane.lua"]();

