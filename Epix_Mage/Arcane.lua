local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((8205 - 6052) == (3687 - (709 + 825))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((738 - 231) >= (3455 - (196 + 668)))) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if (((9281 - 4800) == (5314 - (171 + 662))) and (v5 == (94 - (4 + 89)))) then
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
	local v15 = v10.Spell;
	local v16 = v10.Item;
	local v17 = EpicLib;
	local v18 = v17.Cast;
	local v19 = v17.Press;
	local v20 = v17.Macro;
	local v21 = v17.Bind;
	local v22 = v17.Commons.Everyone.num;
	local v23 = v17.Commons.Everyone.bool;
	local v24 = GetItemCount;
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
		if (v91.RemoveCurse:IsAvailable() or ((8159 - 5831) < (253 + 440))) then
			v95.DispellableDebuffs = v95.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v96();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v91.ArcaneBlast:RegisterInFlight();
	v91.ArcaneBarrage:RegisterInFlight();
	local v97, v98;
	local v99, v100;
	local v101 = 13 - 10;
	local v102 = false;
	local v103 = false;
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = v13:HasTier(12 + 17, 1490 - (35 + 1451));
	local v108 = (226453 - (28 + 1425)) - (((26993 - (941 + 1052)) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((191772 + 8228) * v22(not v107)));
	local v109 = 1517 - (822 + 692);
	local v110 = 15862 - 4751;
	local v111 = 5234 + 5877;
	local v112;
	v10:RegisterForEvent(function()
		local v130 = 297 - (45 + 252);
		while true do
			if (((4283 + 45) == (1490 + 2838)) and (v130 == (4 - 2))) then
				v111 = 11544 - (114 + 319);
				break;
			end
			if (((2279 - 691) >= (1706 - 374)) and (v130 == (1 + 0))) then
				v108 = (335218 - 110218) - (((52381 - 27381) * v22(not v91.ArcaneHarmony:IsAvailable())) + ((201963 - (556 + 1407)) * v22(not v107)));
				v110 = 12317 - (741 + 465);
				v130 = 467 - (170 + 295);
			end
			if ((v130 == (0 + 0)) or ((3834 + 340) > (10458 - 6210))) then
				v102 = false;
				v105 = true;
				v130 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v107 = not v13:HasTier(19 + 10, 3 + 1);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v113()
		local v131 = 1230 - (957 + 273);
		while true do
			if ((v131 == (1 + 0)) or ((1836 + 2750) <= (312 - 230))) then
				if (((10179 - 6316) == (11799 - 7936)) and v91.IceBlock:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) then
					if (v19(v91.IceBlock) or ((1396 - 1114) <= (1822 - (389 + 1391)))) then
						return "ice_block defensive 3";
					end
				end
				if (((2892 + 1717) >= (80 + 686)) and v91.IceColdTalent:IsAvailable() and v91.IceColdAbility:IsCastable() and v59 and (v13:HealthPercentage() <= v66)) then
					if (v19(v91.IceColdAbility) or ((2622 - 1470) == (3439 - (783 + 168)))) then
						return "ice_cold defensive 3";
					end
				end
				v131 = 6 - 4;
			end
			if (((3366 + 56) > (3661 - (309 + 2))) and (v131 == (12 - 8))) then
				if (((2089 - (1090 + 122)) > (122 + 254)) and v81 and (v13:HealthPercentage() <= v83)) then
					local v208 = 0 - 0;
					while true do
						if ((v208 == (0 + 0)) or ((4236 - (628 + 490)) <= (332 + 1519))) then
							if ((v85 == "Refreshing Healing Potion") or ((408 - 243) >= (15958 - 12466))) then
								if (((4723 - (431 + 343)) < (9806 - 4950)) and v92.RefreshingHealingPotion:IsReady()) then
									if (v19(v93.RefreshingHealingPotion) or ((12370 - 8094) < (2383 + 633))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((600 + 4090) > (5820 - (556 + 1139))) and (v85 == "Dreamwalker's Healing Potion")) then
								if (v92.DreamwalkersHealingPotion:IsReady() or ((65 - (6 + 9)) >= (165 + 731))) then
									if (v19(v93.RefreshingHealingPotion) or ((879 + 835) >= (3127 - (28 + 141)))) then
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
			if ((v131 == (0 + 0)) or ((1840 - 349) < (457 + 187))) then
				if (((2021 - (486 + 831)) < (2568 - 1581)) and v91.PrismaticBarrier:IsCastable() and v56 and v13:BuffDown(v91.PrismaticBarrier) and (v13:HealthPercentage() <= v63)) then
					if (((13089 - 9371) > (361 + 1545)) and v19(v91.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v91.MassBarrier:IsCastable() and v60 and v13:BuffDown(v91.PrismaticBarrier) and v95.AreUnitsBelowHealthPercentage(v68, 6 - 4)) or ((2221 - (668 + 595)) > (3271 + 364))) then
					if (((706 + 2795) <= (12250 - 7758)) and v19(v91.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v131 = 291 - (23 + 267);
			end
			if ((v131 == (1946 - (1129 + 815))) or ((3829 - (371 + 16)) < (4298 - (1326 + 424)))) then
				if (((5444 - 2569) >= (5349 - 3885)) and v91.MirrorImage:IsCastable() and v61 and (v13:HealthPercentage() <= v67)) then
					if (v19(v91.MirrorImage) or ((4915 - (88 + 30)) >= (5664 - (720 + 51)))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v91.GreaterInvisibility:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((1225 - 674) > (3844 - (421 + 1355)))) then
					if (((3487 - 1373) > (464 + 480)) and v19(v91.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v131 = 1086 - (286 + 797);
			end
			if ((v131 == (10 - 7)) or ((3746 - 1484) >= (3535 - (397 + 42)))) then
				if ((v91.AlterTime:IsReady() and v55 and (v13:HealthPercentage() <= v62)) or ((705 + 1550) >= (4337 - (24 + 776)))) then
					if (v19(v91.AlterTime) or ((5910 - 2073) < (2091 - (222 + 563)))) then
						return "alter_time defensive 6";
					end
				end
				if (((6499 - 3549) == (2124 + 826)) and v92.Healthstone:IsReady() and v82 and (v13:HealthPercentage() <= v84)) then
					if (v19(v93.Healthstone) or ((4913 - (23 + 167)) < (5096 - (690 + 1108)))) then
						return "healthstone defensive";
					end
				end
				v131 = 2 + 2;
			end
		end
	end
	local function v114()
		if (((938 + 198) >= (1002 - (40 + 808))) and v91.RemoveCurse:IsReady() and v30 and v95.DispellableFriendlyUnit(4 + 16)) then
			if (v19(v93.RemoveCurseFocus) or ((1036 - 765) > (4539 + 209))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v115()
		v25 = v95.HandleTopTrinket(v94, v28, 22 + 18, nil);
		if (((2600 + 2140) >= (3723 - (47 + 524))) and v25) then
			return v25;
		end
		v25 = v95.HandleBottomTrinket(v94, v28, 26 + 14, nil);
		if (v25 or ((7046 - 4468) >= (5069 - 1679))) then
			return v25;
		end
	end
	local function v116()
		local v132 = 0 - 0;
		while true do
			if (((1767 - (1165 + 561)) <= (50 + 1611)) and (v132 == (0 - 0))) then
				if (((230 + 371) < (4039 - (341 + 138))) and v91.MirrorImage:IsCastable() and v88 and v61) then
					if (((64 + 171) < (1417 - 730)) and v19(v91.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if (((4875 - (89 + 237)) > (3709 - 2556)) and v91.ArcaneBlast:IsReady() and v31 and not v91.SiphonStorm:IsAvailable()) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((9839 - 5165) < (5553 - (581 + 300)))) then
						return "arcane_blast precombat 4";
					end
				end
				v132 = 1221 - (855 + 365);
			end
			if (((8712 - 5044) < (1490 + 3071)) and (v132 == (1237 - (1030 + 205)))) then
				if ((v91.ArcaneBlast:IsReady() and v31) or ((428 + 27) == (3354 + 251))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((2949 - (156 + 130)) == (7525 - 4213))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if (((7207 - 2930) <= (9165 - 4690)) and (v132 == (1 + 0))) then
				if ((v91.Evocation:IsReady() and v39 and (v91.SiphonStorm:IsAvailable())) or ((508 + 362) == (1258 - (10 + 59)))) then
					if (((440 + 1113) <= (15429 - 12296)) and v19(v91.Evocation)) then
						return "evocation precombat 6";
					end
				end
				if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52)) or ((3400 - (671 + 492)) >= (2795 + 716))) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(1255 - (369 + 846))) or ((351 + 973) > (2578 + 442))) then
						return "arcane_orb precombat 8";
					end
				end
				v132 = 1947 - (1036 + 909);
			end
		end
	end
	local function v117()
		local v133 = 0 + 0;
		while true do
			if (((0 - 0) == v133) or ((3195 - (11 + 192)) == (951 + 930))) then
				if (((3281 - (135 + 40)) > (3697 - 2171)) and ((v98 >= v101) or (v99 >= v101)) and ((v91.ArcaneOrb:Charges() > (0 + 0)) or (v13:ArcaneCharges() >= (6 - 3))) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (2 - 0)))) then
					v103 = true;
				elseif (((3199 - (50 + 126)) < (10776 - 6906)) and v103 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < (2 + 5)) and v91.RadiantSpark:CooldownDown()) then
					v103 = false;
				end
				if (((1556 - (1233 + 180)) > (1043 - (522 + 447))) and (v13:ArcaneCharges() > (1424 - (107 + 1314))) and ((v98 < v101) or (v99 < v101)) and v91.RadiantSpark:CooldownUp() and (v91.TouchoftheMagi:CooldownRemains() <= (v112 * (4 + 3))) and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * (15 - 10))) or (v91.ArcaneSurge:CooldownRemains() > (17 + 23)))) then
					v104 = true;
				elseif (((35 - 17) < (8356 - 6244)) and v104 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < (1917 - (716 + 1194))) and v91.RadiantSpark:CooldownDown()) then
					v104 = false;
				end
				v133 = 1 + 0;
			end
			if (((118 + 979) <= (2131 - (74 + 429))) and (v133 == (1 - 0))) then
				if (((2295 + 2335) == (10598 - 5968)) and v14:DebuffUp(v91.TouchoftheMagiDebuff) and v105) then
					v105 = false;
				end
				v106 = v91.ArcaneBlast:CastTime() < v112;
				break;
			end
		end
	end
	local function v118()
		if (((2505 + 1035) > (8271 - 5588)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(2 - 1, v91.ArcaneBarrage))) then
			if (((5227 - (279 + 154)) >= (4053 - (454 + 324))) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (((1168 + 316) == (1501 - (12 + 5))) and v91.RadiantSpark:CooldownUp()) then
			v102 = v91.ArcaneSurge:CooldownRemains() < (6 + 4);
		end
		if (((3648 - 2216) < (1314 + 2241)) and v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91.RadiantSpark:IsAvailable()) then
			if (v19(v91.ShiftingPower, not v14:IsInRange(1133 - (277 + 816)), true) or ((4550 - 3485) > (4761 - (1058 + 125)))) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and v91.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) or ((900 + 3895) < (2382 - (815 + 160)))) then
			if (((7950 - 6097) < (11425 - 6612)) and v19(v91.ArcaneOrb, not v14:IsInRange(10 + 30))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v91.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (5 - 3)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v91.ArcaneOrb:CooldownRemains() >= v112)))) or ((4719 - (41 + 1857)) < (4324 - (1222 + 671)))) then
			if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((7428 - 4554) < (3134 - 953))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == (1182 - (229 + 953))) and (v13:ManaPercentage() > (1804 - (1111 + 663))) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or ((4268 - (874 + 705)) <= (49 + 294))) then
			if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((1276 + 593) == (4175 - 2166))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (1 + 4)) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (685 - (642 + 37))))) and v13:HasTier(8 + 23, 1 + 3)) or ((8903 - 5357) < (2776 - (233 + 221)))) then
			if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((4814 - 2732) == (4202 + 571))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if (((4785 - (718 + 823)) > (664 + 391)) and v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > (822 - (266 + 539))) and not v13:HasTier(84 - 54, 1229 - (636 + 589))) then
			if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((7863 - 4550) <= (3666 - 1888))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if ((v91.ArcaneMissiles:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= (2 + 0)) and (v91.RadiantSpark:CooldownRemains() < (2 + 3)) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (1021 - (657 + 358))))) and not v13:HasTier(79 - 49, 8 - 4)) or ((2608 - (1151 + 36)) >= (2032 + 72))) then
			if (((477 + 1335) <= (9702 - 6453)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if (((3455 - (1552 + 280)) <= (2791 - (64 + 770))) and v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < (11 + 4)) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (11 - 6)))) and (v91.ArcaneSurge:CooldownRemains() < (6 + 24))) then
			if (((5655 - (157 + 1086)) == (8830 - 4418)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if (((7664 - 5914) >= (1291 - 449)) and v91.ArcaneMissiles:IsReady() and v36 and v91.RadiantSpark:CooldownUp() and v13:BuffUp(v91.ClearcastingBuff) and v91.NetherPrecision:IsAvailable() and (v13:BuffDown(v91.NetherPrecisionBuff) or (v13:BuffRemains(v91.NetherPrecisionBuff) < v112)) and v13:HasTier(40 - 10, 823 - (599 + 220))) then
			if (((8705 - 4333) > (3781 - (1813 + 118))) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if (((170 + 62) < (2038 - (841 + 376))) and v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
			if (((725 - 207) < (210 + 692)) and v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true)) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if (((8172 - 5178) > (1717 - (464 + 395))) and v91.NetherTempest:IsReady() and v41 and (v91.NetherTempest:TimeSinceLastCast() >= (76 - 46)) and (v91.ArcaneEcho:IsAvailable())) then
			if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or ((1804 + 1951) <= (1752 - (467 + 370)))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if (((8153 - 4207) > (2748 + 995)) and v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) then
			if (v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge)) or ((4576 - 3241) >= (516 + 2790))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if (((11269 - 6425) > (2773 - (150 + 370))) and v91.ArcaneBarrage:IsReady() and v32 and (v13:PrevGCDP(1283 - (74 + 1208), v91.ArcaneSurge) or v13:PrevGCDP(2 - 1, v91.NetherTempest) or v13:PrevGCDP(4 - 3, v91.RadiantSpark))) then
			if (((322 + 130) == (842 - (14 + 376))) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31 and v14:DebuffUp(v91.RadiantSparkVulnerability) and (v14:DebuffStack(v91.RadiantSparkVulnerability) < (6 - 2))) or ((2949 + 1608) < (1834 + 253))) then
			if (((3695 + 179) == (11351 - 7477)) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if ((v91.PresenceofMind:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((1458 + 480) > (5013 - (23 + 55)))) then
			if (v19(v91.PresenceofMind) or ((10084 - 5829) < (2285 + 1138))) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if (((1306 + 148) <= (3862 - 1371)) and v91.ArcaneBlast:IsReady() and v31 and (v13:BuffUp(v91.PresenceofMindBuff))) then
			if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((1308 + 2849) <= (3704 - (652 + 249)))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if (((12987 - 8134) >= (4850 - (708 + 1160))) and v91.ArcaneMissiles:IsReady() and v36 and v13:BuffDown(v91.NetherPrecisionBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v14:DebuffDown(v91.RadiantSparkVulnerability) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == (10 - 6)) and v13:PrevGCDP(1 - 0, v91.ArcaneBlast)))) then
			if (((4161 - (10 + 17)) > (754 + 2603)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if ((v91.ArcaneBlast:IsReady() and v31) or ((5149 - (1400 + 332)) < (4860 - 2326))) then
			if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((4630 - (242 + 1666)) <= (71 + 93))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (3 + 0)) or ((3348 - (850 + 90)) < (3693 - 1584))) then
				if ((v91.ArcaneBlast:IsReady() and v31 and (v91.ArcaneBlast:CastTime() >= v13:GCD()) and (v91.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v91.RadiantSparkVulnerability)) and (not v91.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (1425 - (360 + 1030)))) and ((v91.NetherTempest:IsAvailable() and v13:PrevGCDP(6 + 0, v91.RadiantSpark)) or (not v91.NetherTempest:IsAvailable() and v13:PrevGCDP(13 - 8, v91.RadiantSpark))) and not (v13:IsCasting(v91.ArcaneSurge) and (v13:CastRemains() < (0.5 - 0)) and not v106)) or ((1694 - (909 + 752)) == (2678 - (109 + 1114)))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((810 - 367) >= (1563 + 2452))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if (((3624 - (6 + 236)) > (105 + 61)) and v91.ArcaneBarrage:IsReady() and v32 and (v14:DebuffStack(v91.RadiantSparkVulnerability) == (4 + 0))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((660 - 380) == (5342 - 2283))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((3014 - (1076 + 57)) > (213 + 1080)) and v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and v13:PrevGCDP(690 - (579 + 110), v91.ArcaneBarrage) and ((v91.ArcaneBarrage:InFlight() and ((v91.ArcaneBarrage:TravelTime() - v91.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 + 0))) or (v13:GCDRemains() <= (0.2 + 0)))) then
					if (((1251 + 1106) == (2764 - (174 + 233))) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v134 = 11 - 7;
			end
			if (((215 - 92) == (55 + 68)) and (v134 == (1175 - (663 + 511)))) then
				if ((v91.ArcaneBlast:IsReady() and v31 and v105 and v91.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > (14 + 1))) or ((230 + 826) >= (10457 - 7065))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((655 + 426) < (2530 - 1455))) then
						return "arcane_blast spark_phase 6";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= (4 - 2)) and (v91.RadiantSpark:CooldownRemains() < (3 + 2)) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (11 - 5)))) or ((748 + 301) >= (406 + 4026))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((5490 - (478 + 244)) <= (1363 - (440 + 77)))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v91.ArcaneMissiles:IsReady() and v36 and v91.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < (7 + 8)) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (18 - 13)))) and (v91.ArcaneSurge:CooldownRemains() < (1586 - (655 + 901)))) or ((623 + 2735) <= (1088 + 332))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((2525 + 1214) <= (12106 - 9101))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				v134 = 1447 - (695 + 750);
			end
			if ((v134 == (6 - 4)) or ((2559 - 900) >= (8582 - 6448))) then
				if ((v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or ((3611 - (285 + 66)) < (5489 - 3134))) then
					if (v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark)) or ((1979 - (682 + 628)) == (681 + 3542))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if ((v91.NetherTempest:IsReady() and v41 and not v106 and (v91.NetherTempest:TimeSinceLastCast() >= (314 - (176 + 123))) and ((not v106 and v13:PrevGCDP(2 + 2, v91.RadiantSpark) and (v91.ArcaneSurge:CooldownRemains() <= v91.NetherTempest:ExecuteTime())) or v13:PrevGCDP(4 + 1, v91.RadiantSpark))) or ((1961 - (239 + 30)) < (160 + 428))) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or ((4611 + 186) < (6461 - 2810))) then
						return "nether_tempest spark_phase 16";
					end
				end
				if ((v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111) and ((not v91.NetherTempest:IsAvailable() and ((v13:PrevGCDP(12 - 8, v91.RadiantSpark) and not v106) or v13:PrevGCDP(320 - (306 + 9), v91.RadiantSpark))) or v13:PrevGCDP(3 - 2, v91.NetherTempest))) or ((727 + 3450) > (2976 + 1874))) then
					if (v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge)) or ((193 + 207) > (3176 - 2065))) then
						return "arcane_surge spark_phase 18";
					end
				end
				v134 = 1378 - (1140 + 235);
			end
			if (((1942 + 1109) > (922 + 83)) and (v134 == (0 + 0))) then
				if (((3745 - (33 + 19)) <= (1583 + 2799)) and v91.NetherTempest:IsReady() and v41 and (v91.NetherTempest:TimeSinceLastCast() >= (134 - 89)) and v14:DebuffDown(v91.NetherTempestDebuff) and v105 and v13:BloodlustUp()) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or ((1446 + 1836) > (8040 - 3940))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((v105 and v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or ((4269 - (586 + 103)) < (259 + 2585))) then
					if (((273 - 184) < (5978 - (1309 + 179))) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91.RadiantSpark:CooldownRemains() < (9 - 4)) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * (3 + 3)))) and v13:HasTier(83 - 52, 4 + 0)) or ((10586 - 5603) < (3602 - 1794))) then
					if (((4438 - (295 + 314)) > (9256 - 5487)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				v134 = 1963 - (1300 + 662);
			end
			if (((4662 - 3177) <= (4659 - (1178 + 577))) and (v134 == (3 + 1))) then
				if (((12619 - 8350) == (5674 - (851 + 554))) and v91.ArcaneBlast:IsReady() and v31) then
					if (((343 + 44) <= (7715 - 4933)) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((4124 - 2225) <= (1219 - (115 + 187)))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((3303 + 1009) <= (830 + 46))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v135 = 0 - 0;
		while true do
			if (((3393 - (160 + 1001)) <= (2272 + 324)) and (v135 == (2 + 0))) then
				if (((4288 - 2193) < (4044 - (237 + 121))) and v91.ArcaneBarrage:IsReady() and v32 and (v91.ArcaneSurge:CooldownRemains() < (972 - (525 + 372))) and (v14:DebuffStack(v91.RadiantSparkVulnerability) == (7 - 3)) and not v91.OrbBarrage:IsAvailable()) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((5240 - 3645) >= (4616 - (96 + 46)))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == (779 - (643 + 134))) and (v91.ArcaneSurge:CooldownRemains() > (28 + 47))) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == (2 - 1)) and (v91.ArcaneSurge:CooldownRemains() < (278 - 203)) and not v91.OrbBarrage:IsAvailable()))) or ((4430 + 189) < (5655 - 2773))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((600 - 306) >= (5550 - (316 + 403)))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				if (((1349 + 680) <= (8478 - 5394)) and v91.ArcaneBarrage:IsReady() and v32 and ((v14:DebuffStack(v91.RadiantSparkVulnerability) == (1 + 0)) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == (4 - 2)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == (3 + 0)) and ((v98 > (2 + 3)) or (v99 > (17 - 12)))) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == (19 - 15))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v91.OrbBarrage:IsAvailable()) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((4231 - 2194) == (139 + 2281))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				v135 = 5 - 2;
			end
			if (((218 + 4240) > (11485 - 7581)) and (v135 == (18 - (12 + 5)))) then
				if (((1693 - 1257) >= (261 - 138)) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v91.ArcaneOrb:TimeSinceLastCast() >= (31 - 16)) and (v13:ArcaneCharges() < (7 - 4))) then
					if (((102 + 398) < (3789 - (1656 + 317))) and v19(v91.ArcaneOrb, not v14:IsInRange(36 + 4))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				if (((2864 + 710) == (9503 - 5929)) and v91.NetherTempest:IsReady() and v41 and (v91.NetherTempest:TimeSinceLastCast() >= (73 - 58)) and (v91.ArcaneEcho:IsAvailable())) then
					if (((575 - (5 + 349)) < (1852 - 1462)) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if ((v91.ArcaneSurge:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) or ((3484 - (266 + 1005)) <= (937 + 484))) then
					if (((10434 - 7376) < (6398 - 1538)) and v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				v135 = 1698 - (561 + 1135);
			end
			if ((v135 == (3 - 0)) or ((4260 - 2964) >= (5512 - (507 + 559)))) then
				if ((v91.PresenceofMind:IsCastable() and v42) or ((3495 - 2102) > (13882 - 9393))) then
					if (v19(v91.PresenceofMind) or ((4812 - (212 + 176)) < (932 - (250 + 655)))) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and ((((v14:DebuffStack(v91.RadiantSparkVulnerability) == (5 - 3)) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == (5 - 2))) and not v91.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v91.RadiantSparkVulnerability) and v91.OrbBarrage:IsAvailable()))) or ((3124 - 1127) > (5771 - (1869 + 87)))) then
					if (((12018 - 8553) > (3814 - (484 + 1417))) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if (((1570 - 837) < (3047 - 1228)) and v91.ArcaneBarrage:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == (777 - (48 + 725))) and v13:BuffUp(v91.ArcaneSurgeBuff)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == (4 - 1)) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91.OrbBarrage:IsAvailable()))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((11791 - 7396) == (2764 + 1991))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((1062 + 2731) < (691 + 1678))) then
				if ((v13:BuffUp(v91.PresenceofMindBuff) and v89 and (v13:PrevGCDP(854 - (152 + 701), v91.ArcaneBlast)) and (v13:CooldownRemains(v91.ArcaneSurge) > (1386 - (430 + 881)))) or ((1565 + 2519) == (1160 - (557 + 338)))) then
					if (((1289 + 3069) == (12280 - 7922)) and v19(v93.CancelPOM)) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if ((v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(3 - 2, v91.ArcaneBarrage))) or ((8336 - 5198) < (2139 - 1146))) then
					if (((4131 - (499 + 302)) > (3189 - (39 + 827))) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v91.RadiantSpark:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or ((10009 - 6383) == (8908 - 4919))) then
					if (v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true) or ((3638 - 2722) == (4100 - 1429))) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		while true do
			if (((44 + 228) == (429 - 157)) and (v136 == (105 - (103 + 1)))) then
				if (((4803 - (475 + 79)) <= (10460 - 5621)) and v91.ArcaneBlast:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (((8886 - 6109) < (414 + 2786)) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if (((84 + 11) < (3460 - (1395 + 108))) and v91.ArcaneBarrage:IsReady() and v32 and (v13:BuffUp(v91.ArcaneHarmonyBuff) or (v91.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (101 - 66)))) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) then
					if (((2030 - (7 + 1197)) < (749 + 968)) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				if (((498 + 928) >= (1424 - (27 + 292))) and v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > (38 - 8)) and (v91.TouchoftheMagi:CooldownRemains() > (125 - 95))) or (v13:ManaPercentage() > (138 - 68))) and v13:BuffDown(v91.ArcaneArtilleryBuff)) then
					if (((5244 - 2490) <= (3518 - (43 + 96))) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and (v13:BuffStack(v91.ClearcastingBuff) > (4 - 3)) and v91.ConjureManaGem:IsAvailable() and v92.ManaGem:CooldownUp()) or ((8877 - 4950) == (1173 + 240))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((326 + 828) <= (1557 - 769))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				v136 = 1 + 1;
			end
			if ((v136 == (3 - 1)) or ((518 + 1125) > (248 + 3131))) then
				if ((v91.ArcaneBlast:IsReady() and v31 and (v13:BuffUp(v91.NetherPrecisionBuff))) or ((4554 - (1414 + 337)) > (6489 - (1642 + 298)))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((573 - 353) >= (8693 - 5671))) then
						return "arcane_blast touch_phase 14";
					end
				end
				if (((8374 - 5552) == (929 + 1893)) and v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and ((v14:DebuffRemains(v91.TouchoftheMagiDebuff) > v91.ArcaneMissiles:CastTime()) or not v91.PresenceofMind:IsAvailable())) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((826 + 235) == (2829 - (357 + 615)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((1938 + 822) > (3346 - 1982)) and v91.ArcaneBlast:IsReady() and v31) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((4201 + 701) <= (7704 - 4109))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32) or ((3081 + 771) == (20 + 273))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((980 + 579) == (5889 - (384 + 917)))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if ((v136 == (697 - (128 + 569))) or ((6027 - (1407 + 136)) == (2675 - (687 + 1200)))) then
				if (((6278 - (556 + 1154)) >= (13745 - 9838)) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) > (104 - (9 + 86)))) then
					v102 = not v102;
				end
				if (((1667 - (275 + 146)) < (565 + 2905)) and v91.NetherTempest:IsReady() and v41 and (v14:DebuffRefreshable(v91.NetherTempestDebuff) or not v14:DebuffUp(v91.NetherTempestDebuff)) and (v13:ArcaneCharges() == (68 - (29 + 35))) and (v13:ManaPercentage() < (132 - 102)) and (v13:SpellHaste() < (0.667 - 0)) and v13:BuffDown(v91.ArcaneSurgeBuff)) then
					if (((17958 - 13890) >= (634 + 338)) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if (((1505 - (53 + 959)) < (4301 - (312 + 96))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v13:ArcaneCharges() < (3 - 1)) and (v13:ManaPercentage() < (315 - (147 + 138))) and (v13:SpellHaste() < (899.667 - (813 + 86))) and v13:BuffDown(v91.ArcaneSurgeBuff)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(37 + 3)) or ((2728 - 1255) >= (3824 - (18 + 474)))) then
						return "arcane_orb touch_phase 4";
					end
				end
				if ((v91.PresenceofMind:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or ((1367 + 2684) <= (3776 - 2619))) then
					if (((1690 - (860 + 226)) < (3184 - (121 + 182))) and v19(v91.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v122()
		local v137 = 1240 - (988 + 252);
		while true do
			if ((v137 == (1 + 0)) or ((282 + 618) == (5347 - (49 + 1921)))) then
				if (((5349 - (223 + 667)) > (643 - (51 + 1))) and v91.ArcaneBarrage:IsReady() and v32 and ((((v98 <= (6 - 2)) or (v99 <= (8 - 4))) and (v13:ArcaneCharges() == (1128 - (146 + 979)))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) then
					if (((960 + 2438) >= (3000 - (311 + 294))) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < (5 - 3))) or ((925 + 1258) >= (4267 - (496 + 947)))) then
					if (((3294 - (1233 + 125)) == (786 + 1150)) and v19(v91.ArcaneOrb, not v14:IsInRange(36 + 4))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v137 = 1 + 1;
			end
			if ((v137 == (1647 - (963 + 682))) or ((4033 + 799) < (5817 - (504 + 1000)))) then
				if (((2754 + 1334) > (3528 + 346)) and v91.ArcaneExplosion:IsReady() and v33) then
					if (((409 + 3923) == (6387 - 2055)) and v19(v91.ArcaneExplosion, not v14:IsInRange(26 + 4))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if (((2326 + 1673) >= (3082 - (156 + 26))) and (v137 == (0 + 0))) then
				if ((v14:DebuffRemains(v91.TouchoftheMagiDebuff) > (13 - 4)) or ((2689 - (149 + 15)) > (5024 - (890 + 70)))) then
					v102 = not v102;
				end
				if (((4488 - (39 + 78)) == (4853 - (14 + 468))) and v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((584 - 318) > (13936 - 8950))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v123()
		local v138 = 0 + 0;
		while true do
			if (((423 + 1568) >= (418 + 507)) and (v138 == (0 + 0))) then
				if (((870 - 415) < (2030 + 23)) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < (10 - 7)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (2 + 68)) or (v107 and (v91.TouchoftheMagi:CooldownRemains() > (81 - (12 + 39)))))) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(38 + 2)) or ((2556 - 1730) == (17277 - 12426))) then
						return "arcane_orb rotation 2";
					end
				end
				v102 = ((v91.ArcaneSurge:CooldownRemains() > (9 + 21)) and (v91.TouchoftheMagi:CooldownRemains() > (6 + 4))) or false;
				if (((463 - 280) == (122 + 61)) and v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v107 and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (57 - 45))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (1722 - (1596 + 114)))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (31 - 19))) and (v111 > (728 - (164 + 549)))) then
					if (((2597 - (1059 + 379)) <= (2219 - 431)) and v19(v91.ShiftingPower, not v14:IsInRange(21 + 19))) then
						return "shifting_power rotation 4";
					end
				end
				if ((v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and not v107 and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() > (8 + 37)) and (v111 > (407 - (145 + 247)))) or ((2878 + 629) > (1996 + 2322))) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(118 - 78)) or ((590 + 2485) <= (2554 + 411))) then
						return "shifting_power rotation 6";
					end
				end
				v138 = 1 - 0;
			end
			if (((2085 - (254 + 466)) <= (2571 - (544 + 16))) and ((5 - 3) == v138)) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) == v109)) or ((3404 - (294 + 334)) > (3828 - (236 + 17)))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((1102 + 1452) == (3740 + 1064))) then
						return "arcane_missiles rotation 14";
					end
				end
				if (((9705 - 7128) == (12200 - 9623)) and v91.NetherTempest:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v91.TemporalWarpBuff) or (v13:ManaPercentage() < (6 + 4)) or not v91.ShiftingPower:IsAvailable()) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v111 >= (10 + 2))) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or ((800 - (413 + 381)) >= (80 + 1809))) then
						return "nether_tempest rotation 16";
					end
				end
				if (((1075 - 569) <= (4914 - 3022)) and v91.ArcaneBarrage:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (2020 - (582 + 1388))) and not v91.Evocation:IsAvailable() and (v111 > (34 - 14))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((1438 + 570) > (2582 - (326 + 38)))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((1120 - 741) <= (5919 - 1772)) and v91.ArcaneBarrage:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (690 - (47 + 573))) and v102 and v13:BloodlustUp() and (v91.TouchoftheMagi:CooldownRemains() > (2 + 3)) and (v111 > (84 - 64))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((7325 - 2811) <= (2673 - (1269 + 395)))) then
						return "arcane_barrage rotation 20";
					end
				end
				v138 = 495 - (76 + 416);
			end
			if ((v138 == (444 - (319 + 124))) or ((7991 - 4495) == (2199 - (564 + 443)))) then
				if ((v91.PresenceofMind:IsCastable() and v42 and (v13:ArcaneCharges() < (7 - 4)) and (v14:HealthPercentage() < (493 - (337 + 121))) and v91.ArcaneBombardment:IsAvailable()) or ((609 - 401) == (9856 - 6897))) then
					if (((6188 - (1261 + 650)) >= (556 + 757)) and v19(v91.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((4122 - 1535) < (4991 - (772 + 1045))) and v91.ArcaneBlast:IsReady() and v31 and v91.TimeAnomaly:IsAvailable() and v13:BuffUp(v91.ArcaneSurgeBuff) and (v13:BuffRemains(v91.ArcaneSurgeBuff) <= (1 + 5))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((4264 - (102 + 42)) <= (4042 - (1524 + 320)))) then
						return "arcane_blast rotation 10";
					end
				end
				if ((v91.ArcaneBlast:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v14:HealthPercentage() < (1305 - (1049 + 221))) and v91.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (159 - (18 + 138)))) or ((3906 - 2310) == (1960 - (67 + 1035)))) then
					if (((3568 - (136 + 212)) == (13683 - 10463)) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > (28 + 2)) and (v91.TouchoftheMagi:CooldownRemains() > (1634 - (240 + 1364)))) or (v13:ManaPercentage() > (1152 - (1050 + 32)))) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or ((5005 - 3603) > (2142 + 1478))) then
					if (((3629 - (331 + 724)) == (208 + 2366)) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				v138 = 646 - (269 + 375);
			end
			if (((2523 - (267 + 458)) < (858 + 1899)) and (v138 == (7 - 3))) then
				if ((v91.ArcaneBlast:IsReady() and v31) or ((1195 - (667 + 151)) > (4101 - (1410 + 87)))) then
					if (((2465 - (1504 + 393)) < (2462 - 1551)) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return "arcane_blast rotation 32";
					end
				end
				if (((8522 - 5237) < (5024 - (461 + 335))) and v91.ArcaneBarrage:IsReady() and v32) then
					if (((501 + 3415) > (5089 - (1730 + 31))) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((4167 - (728 + 939)) < (13596 - 9757)) and (v138 == (5 - 2))) then
				if (((1161 - 654) == (1575 - (138 + 930))) and v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffUp(v91.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (((220 + 20) <= (2475 + 690)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if (((715 + 119) >= (3286 - 2481)) and v91.ArcaneBlast:IsReady() and v31 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v91.NetherPrecisionBuff)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or ((5578 - (459 + 1307)) < (4186 - (474 + 1396)))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (104 - 44)) and v102 and (v91.TouchoftheMagi:CooldownRemains() > (10 + 0)) and (v91.Evocation:CooldownRemains() > (1 + 39)) and (v111 > (57 - 37))) or ((337 + 2315) <= (5117 - 3584))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((15691 - 12093) < (2051 - (562 + 29)))) then
						return "arcane_barrage rotation 26";
					end
				end
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffDown(v91.NetherPrecisionBuff) and (not v107 or not v105)) or ((3510 + 606) < (2611 - (374 + 1045)))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or ((2673 + 704) <= (2803 - 1900))) then
						return "arcane_missiles rotation 30";
					end
				end
				v138 = 642 - (448 + 190);
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((1795 + 2181) >= (287 + 152)) and (v139 == (7 - 5))) then
				if (((11658 - 7906) == (5246 - (1307 + 187))) and v91.ArcaneOrb:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() == (0 - 0)) and (v91.TouchoftheMagi:CooldownRemains() > (41 - 23))) then
					if (((12405 - 8359) > (3378 - (232 + 451))) and v19(v91.ArcaneOrb, not v14:IsInRange(39 + 1))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (9 + 1)))) or ((4109 - (510 + 54)) == (6441 - 3244))) then
					if (((2430 - (13 + 23)) > (726 - 353)) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v139 = 3 - 0;
			end
			if (((7548 - 3393) <= (5320 - (830 + 258))) and (v139 == (3 - 2))) then
				if ((v91.ArcaneMissiles:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v91.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v91.ArcaneArtilleryBuff) + 4 + 1))) or ((3047 + 534) == (4914 - (860 + 581)))) then
					if (((18424 - 13429) > (2658 + 690)) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((v91.ArcaneBarrage:IsReady() and v32 and ((v98 <= (245 - (237 + 4))) or (v99 <= (9 - 5)) or v13:BuffUp(v91.ClearcastingBuff)) and (v13:ArcaneCharges() == (6 - 3))) or ((1429 - 675) > (3049 + 675))) then
					if (((125 + 92) >= (215 - 158)) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v139 = 1 + 1;
			end
			if ((v139 == (0 + 0)) or ((3496 - (85 + 1341)) >= (6888 - 2851))) then
				if (((7639 - 4934) == (3077 - (45 + 327))) and v91.ShiftingPower:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and (not v91.Evocation:IsAvailable() or (v91.Evocation:CooldownRemains() > (21 - 9))) and (not v91.ArcaneSurge:IsAvailable() or (v91.ArcaneSurge:CooldownRemains() > (514 - (444 + 58)))) and (not v91.TouchoftheMagi:IsAvailable() or (v91.TouchoftheMagi:CooldownRemains() > (6 + 6))) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((not v91.ChargedOrb:IsAvailable() and (v91.ArcaneOrb:CooldownRemains() > (3 + 9))) or (v91.ArcaneOrb:Charges() == (0 + 0)) or (v91.ArcaneOrb:CooldownRemains() > (34 - 22)))) then
					if (((1793 - (64 + 1668)) == (2034 - (1227 + 746))) and v19(v91.ShiftingPower, not v14:IsInRange(122 - 82), true)) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v91.NetherTempest:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((v98 > (10 - 4)) or (v99 > (500 - (415 + 79))) or not v91.OrbBarrage:IsAvailable())) or ((18 + 681) >= (1787 - (142 + 349)))) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or ((764 + 1019) >= (4971 - 1355))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (3 + 0)) or ((10655 - 6742) > (6391 - (1710 + 154)))) then
				if (((4694 - (200 + 118)) > (324 + 493)) and v91.ArcaneExplosion:IsReady() and v33) then
					if (((8498 - 3637) > (1221 - 397)) and v19(v91.ArcaneExplosion, not v14:IsInRange(27 + 3))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v140 = 0 + 0;
		local v141;
		while true do
			if ((v140 == (2 + 0)) or ((221 + 1162) >= (4616 - 2485))) then
				if ((v92.ManaGem:IsReady() and v40 and not v91.CascadingPower:IsAvailable() and v13:PrevGCDP(1251 - (363 + 887), v91.ArcaneSurge) and (not v106 or (v106 and v13:PrevGCDP(2 - 0, v91.ArcaneSurge)))) or ((8929 - 7053) >= (393 + 2148))) then
					if (((4169 - 2387) <= (2578 + 1194)) and v19(v93.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((not v107 and ((v91.ArcaneSurge:CooldownRemains() <= (v112 * ((1665 - (674 + 990)) + v22(v91.NetherTempest:IsAvailable() and v91.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v91.ArcaneSurgeBuff) > ((1 + 2) * v22(v13:HasTier(13 + 17, 2 - 0) and not v13:HasTier(1085 - (507 + 548), 841 - (289 + 548))))) or v13:BuffUp(v91.ArcaneOverloadBuff)) and (v91.Evocation:CooldownRemains() > (1863 - (821 + 997))) and ((v91.TouchoftheMagi:CooldownRemains() < (v112 * (259 - (195 + 60)))) or (v91.TouchoftheMagi:CooldownRemains() > (6 + 14))) and ((v98 < v101) or (v99 < v101))) or ((6201 - (251 + 1250)) < (2381 - 1568))) then
					local v209 = 0 + 0;
					local v210;
					while true do
						if (((4231 - (809 + 223)) < (5910 - 1860)) and ((0 - 0) == v209)) then
							v210 = v118();
							if (v210 or ((16370 - 11419) < (3263 + 1167))) then
								return v210;
							end
							break;
						end
					end
				end
				if (((51 + 45) == (713 - (14 + 603))) and not v107 and (v91.ArcaneSurge:CooldownRemains() > (159 - (118 + 11))) and (v91.RadiantSpark:CooldownUp() or v14:DebuffUp(v91.RadiantSparkDebuff) or v14:DebuffUp(v91.RadiantSparkVulnerability)) and ((v91.TouchoftheMagi:CooldownRemains() <= (v112 * (1 + 2))) or v14:DebuffUp(v91.TouchoftheMagiDebuff)) and ((v98 < v101) or (v99 < v101))) then
					local v211 = 0 + 0;
					local v212;
					while true do
						if (((0 - 0) == v211) or ((3688 - (551 + 398)) > (2533 + 1475))) then
							v212 = v118();
							if (v212 or ((9 + 14) == (922 + 212))) then
								return v212;
							end
							break;
						end
					end
				end
				v140 = 11 - 8;
			end
			if ((v140 == (0 - 0)) or ((873 + 1820) >= (16319 - 12208))) then
				if ((v91.TouchoftheMagi:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1 + 0, v91.ArcaneBarrage))) or ((4405 - (40 + 49)) <= (8172 - 6026))) then
					if (v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi)) or ((4036 - (99 + 391)) <= (2324 + 485))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((21557 - 16653) > (5363 - 3197)) and v13:IsChanneling(v91.Evocation) and (((v13:ManaPercentage() >= (93 + 2)) and not v91.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v111 * (10 - 6))) and not ((v111 > (1614 - (1032 + 572))) and (v91.ArcaneSurge:CooldownRemains() < (418 - (203 + 214))))))) then
					if (((1926 - (568 + 1249)) >= (71 + 19)) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((11955 - 6977) > (11220 - 8315)) and v91.ArcaneBarrage:IsReady() and v32 and (v111 < (1308 - (913 + 393)))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or ((8545 - 5519) <= (3221 - 941))) then
						return "arcane_barrage main 34";
					end
				end
				v140 = 411 - (269 + 141);
			end
			if ((v140 == (2 - 1)) or ((3634 - (362 + 1619)) <= (2733 - (950 + 675)))) then
				if (((1122 + 1787) > (3788 - (216 + 963))) and v91.Evocation:IsCastable() and v39 and not v105 and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (1297 - (485 + 802))) and (v91.TouchoftheMagi:CooldownRemains() < (579 - (432 + 127)))) or (v91.TouchoftheMagi:CooldownRemains() < (1088 - (1065 + 8)))) and (v13:ManaPercentage() < (v111 * (3 + 1)))) then
					if (((2358 - (635 + 966)) > (140 + 54)) and v19(v91.Evocation)) then
						return "evocation main 36";
					end
				end
				if ((v91.ConjureManaGem:IsCastable() and v37 and v14:DebuffDown(v91.TouchoftheMagiDebuff) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91.ArcaneSurge:CooldownRemains() < (72 - (5 + 37))) and (v91.ArcaneSurge:CooldownRemains() < v111) and not v92.ManaGem:Exists()) or ((76 - 45) >= (582 + 816))) then
					if (((5058 - 1862) <= (2280 + 2592)) and v19(v91.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((6910 - 3584) == (12609 - 9283)) and v92.ManaGem:IsReady() and v40 and v91.CascadingPower:IsAvailable() and (v13:BuffStack(v91.ClearcastingBuff) < (3 - 1)) and v13:BuffUp(v91.ArcaneSurgeBuff)) then
					if (((3426 - 1993) <= (2789 + 1089)) and v19(v93.ManaGem)) then
						return "mana_gem main 40";
					end
				end
				v140 = 531 - (318 + 211);
			end
			if ((v140 == (19 - 15)) or ((3170 - (963 + 624)) == (742 + 993))) then
				if ((v28 and v107 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 < v101) or (v99 < v101))) or ((3827 - (518 + 328)) == (5478 - 3128))) then
					local v213 = 0 - 0;
					local v214;
					while true do
						if ((v213 == (317 - (301 + 16))) or ((13089 - 8623) <= (1384 - 891))) then
							v214 = v121();
							if (v214 or ((6645 - 4098) <= (1800 + 187))) then
								return v214;
							end
							break;
						end
					end
				end
				if (((1682 + 1279) > (5849 - 3109)) and ((v98 >= v101) or (v99 >= v101))) then
					local v215 = 0 + 0;
					local v216;
					while true do
						if (((352 + 3344) >= (11483 - 7871)) and (v215 == (0 + 0))) then
							v216 = v124();
							if (v216 or ((3989 - (829 + 190)) == (6700 - 4822))) then
								return v216;
							end
							break;
						end
					end
				end
				v141 = v123();
				v140 = 6 - 1;
			end
			if ((v140 == (3 - 0)) or ((9173 - 5480) < (469 + 1508))) then
				if ((v28 and v91.RadiantSpark:IsAvailable() and v103) or ((304 + 626) > (6377 - 4276))) then
					local v217 = v120();
					if (((3919 + 234) > (3699 - (520 + 93))) and v217) then
						return v217;
					end
				end
				if ((v28 and v107 and v91.RadiantSpark:IsAvailable() and v104) or ((4930 - (259 + 17)) <= (234 + 3816))) then
					local v218 = v119();
					if (v218 or ((937 + 1665) < (5064 - 3568))) then
						return v218;
					end
				end
				if ((v28 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 >= v101) or (v99 >= v101))) or ((1611 - (396 + 195)) > (6638 - 4350))) then
					local v219 = v122();
					if (((2089 - (440 + 1321)) == (2157 - (1059 + 770))) and v219) then
						return v219;
					end
				end
				v140 = 18 - 14;
			end
			if (((2056 - (424 + 121)) < (695 + 3113)) and (v140 == (1352 - (641 + 706)))) then
				if (v141 or ((995 + 1515) > (5359 - (249 + 191)))) then
					return v141;
				end
				break;
			end
		end
	end
	local function v126()
		local v142 = 0 - 0;
		while true do
			if (((2128 + 2635) == (18357 - 13594)) and (v142 == (433 - (183 + 244)))) then
				v54 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v55 = EpicSettings.Settings['useAlterTime'];
				v56 = EpicSettings.Settings['usePrismaticBarrier'];
				v57 = EpicSettings.Settings['useGreaterInvisibility'];
				v142 = 1 + 6;
			end
			if (((4867 - (434 + 296)) > (5897 - 4049)) and ((522 - (169 + 343)) == v142)) then
				v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v88 = EpicSettings.Settings['mirrorImageBeforePull'];
				v90 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((2136 + 300) <= (5514 - 2380)) and (v142 == (0 - 0))) then
				v31 = EpicSettings.Settings['useArcaneBlast'];
				v32 = EpicSettings.Settings['useArcaneBarrage'];
				v33 = EpicSettings.Settings['useArcaneExplosion'];
				v34 = EpicSettings.Settings['useArcaneFamiliar'];
				v142 = 1 + 0;
			end
			if (((10558 - 6835) == (4846 - (651 + 472))) and ((2 + 0) == v142)) then
				v40 = EpicSettings.Settings['useManaGem'];
				v41 = EpicSettings.Settings['useNetherTempest'];
				v42 = EpicSettings.Settings['usePresenceOfMind'];
				v89 = EpicSettings.Settings['cancelPOM'];
				v142 = 2 + 1;
			end
			if ((v142 == (10 - 1)) or ((4529 - (397 + 86)) >= (5192 - (423 + 453)))) then
				v66 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v67 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v68 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v86 = EpicSettings.Settings['useSpellStealTarget'];
				v142 = 8 + 2;
			end
			if (((1 + 0) == v142) or ((3198 - (50 + 1140)) < (1668 + 261))) then
				v35 = EpicSettings.Settings['useArcaneIntellect'];
				v36 = EpicSettings.Settings['useArcaneMissiles'];
				v37 = EpicSettings.Settings['useConjureManaGem'];
				v39 = EpicSettings.Settings['useEvocation'];
				v142 = 2 + 0;
			end
			if (((149 + 2235) > (2549 - 774)) and (v142 == (3 + 1))) then
				v46 = EpicSettings.Settings['useShiftingPower'];
				v47 = EpicSettings.Settings['useArcaneOrb'];
				v48 = EpicSettings.Settings['useRadiantSpark'];
				v49 = EpicSettings.Settings['useTouchOfTheMagi'];
				v142 = 601 - (157 + 439);
			end
			if ((v142 == (13 - 5)) or ((15095 - 10552) <= (12944 - 8568))) then
				v62 = EpicSettings.Settings['alterTimeHP'] or (918 - (782 + 136));
				v63 = EpicSettings.Settings['prismaticBarrierHP'] or (855 - (112 + 743));
				v64 = EpicSettings.Settings['greaterInvisibilityHP'] or (1171 - (1026 + 145));
				v65 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v142 = 727 - (493 + 225);
			end
			if (((2675 - 1947) == (443 + 285)) and (v142 == (18 - 11))) then
				v58 = EpicSettings.Settings['useIceBlock'];
				v59 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v61 = EpicSettings.Settings['useMirrorImage'];
				v142 = 1 + 7;
			end
			if (((14 - 9) == v142) or ((314 + 762) > (7803 - 3132))) then
				v50 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v51 = EpicSettings.Settings['shiftingPowerWithCD'];
				v52 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v53 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v142 = 1601 - (210 + 1385);
			end
			if (((3540 - (1201 + 488)) >= (235 + 143)) and (v142 == (5 - 2))) then
				v43 = EpicSettings.Settings['useCounterspell'];
				v44 = EpicSettings.Settings['useBlastWave'];
				v38 = EpicSettings.Settings['useDragonsBreath'];
				v45 = EpicSettings.Settings['useArcaneSurge'];
				v142 = 6 - 2;
			end
		end
	end
	local function v127()
		local v143 = 585 - (352 + 233);
		while true do
			if ((v143 == (7 - 4)) or ((1060 + 888) >= (9882 - 6406))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (574 - (489 + 85));
				v83 = EpicSettings.Settings['healingPotionHP'] or (1501 - (277 + 1224));
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v71 = EpicSettings.Settings['handleAfflicted'];
				v143 = 1497 - (663 + 830);
			end
			if (((4211 + 583) >= (2039 - 1206)) and (v143 == (879 - (461 + 414)))) then
				v72 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((686 + 3404) == (1637 + 2453)) and (v143 == (1 + 1))) then
				v79 = EpicSettings.Settings['trinketsWithCD'];
				v80 = EpicSettings.Settings['racialsWithCD'];
				v82 = EpicSettings.Settings['useHealthstone'];
				v81 = EpicSettings.Settings['useHealingPotion'];
				v143 = 3 + 0;
			end
			if ((v143 == (250 - (172 + 78))) or ((6059 - 2301) == (920 + 1578))) then
				v76 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v73 = EpicSettings.Settings['InterruptWithStun'];
				v74 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v75 = EpicSettings.Settings['InterruptThreshold'];
				v143 = 1 + 0;
			end
			if ((v143 == (1 + 0)) or ((4477 - 1804) < (1982 - 407))) then
				v70 = EpicSettings.Settings['DispelDebuffs'];
				v69 = EpicSettings.Settings['DispelBuffs'];
				v78 = EpicSettings.Settings['useTrinkets'];
				v77 = EpicSettings.Settings['useRacials'];
				v143 = 1 + 1;
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
		if (v13:IsDeadOrGhost() or ((2058 + 1663) <= (518 + 937))) then
			return;
		end
		v97 = v14:GetEnemiesInSplashRange(19 - 14);
		v100 = v13:GetEnemiesInRange(93 - 53);
		if (((287 + 647) < (1297 + 973)) and v27) then
			local v153 = 447 - (133 + 314);
			while true do
				if ((v153 == (0 + 0)) or ((1825 - (199 + 14)) == (4492 - 3237))) then
					v98 = max(v14:GetEnemiesInSplashRangeCount(1554 - (647 + 902)), #v100);
					v99 = #v100;
					break;
				end
			end
		else
			local v154 = 0 - 0;
			while true do
				if ((v154 == (233 - (85 + 148))) or ((5641 - (426 + 863)) < (19684 - 15478))) then
					v98 = 1655 - (873 + 781);
					v99 = 1 - 0;
					break;
				end
			end
		end
		if (v95.TargetIsValid() or v13:AffectingCombat() or ((7723 - 4863) <= (75 + 106))) then
			local v155 = 0 - 0;
			while true do
				if (((4617 - 1395) >= (4534 - 3007)) and (v155 == (1948 - (414 + 1533)))) then
					v111 = v110;
					if (((1305 + 200) <= (2676 - (443 + 112))) and (v111 == (12590 - (888 + 591)))) then
						v111 = v10.FightRemains(v100, false);
					end
					break;
				end
				if (((1922 - 1178) == (43 + 701)) and (v155 == (0 - 0))) then
					if (v13:AffectingCombat() or v70 or ((773 + 1206) >= (1372 + 1464))) then
						local v220 = 0 + 0;
						local v221;
						while true do
							if (((3492 - 1659) <= (4941 - 2273)) and (v220 == (1679 - (136 + 1542)))) then
								if (((12087 - 8401) == (3659 + 27)) and v25) then
									return v25;
								end
								break;
							end
							if (((5512 - 2045) > (346 + 131)) and (v220 == (486 - (68 + 418)))) then
								v221 = v70 and v91.RemoveCurse:IsReady() and v30;
								v25 = v95.FocusUnit(v221, v93, 54 - 34, nil, 36 - 16);
								v220 = 1 + 0;
							end
						end
					end
					v110 = v10.BossFightRemains(nil, true);
					v155 = 1093 - (770 + 322);
				end
			end
		end
		v112 = v13:GCD();
		if (v71 or ((190 + 3098) >= (1025 + 2516))) then
			if (v90 or ((486 + 3071) == (6495 - 1955))) then
				local v207 = 0 - 0;
				while true do
					if ((v207 == (0 - 0)) or ((959 - 698) > (706 + 561))) then
						v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 44 - 14);
						if (((611 + 661) < (2366 + 1492)) and v25) then
							return v25;
						end
						break;
					end
				end
			end
		end
		if (((2872 + 792) == (13797 - 10133)) and not v13:AffectingCombat()) then
			local v156 = 0 - 0;
			while true do
				if (((656 + 1285) >= (2072 - 1622)) and (v156 == (0 - 0))) then
					if ((v91.ArcaneIntellect:IsCastable() and v35 and (v13:BuffDown(v91.ArcaneIntellect, true) or v95.GroupBuffMissing(v91.ArcaneIntellect))) or ((1911 + 2735) < (1603 - 1279))) then
						if (((4664 - (762 + 69)) == (12411 - 8578)) and v19(v91.ArcaneIntellect)) then
							return "arcane_intellect group_buff";
						end
					end
					if ((v91.ArcaneFamiliar:IsReady() and v34 and v13:BuffDown(v91.ArcaneFamiliarBuff)) or ((1069 + 171) > (2182 + 1188))) then
						if (v19(v91.ArcaneFamiliar) or ((6000 - 3519) == (1474 + 3208))) then
							return "arcane_familiar precombat 2";
						end
					end
					v156 = 1 + 0;
				end
				if (((18416 - 13689) >= (365 - (8 + 149))) and (v156 == (1321 - (1199 + 121)))) then
					if (((473 - 193) < (8694 - 4843)) and v91.ConjureManaGem:IsCastable() and v37) then
						if (v19(v91.ConjureManaGem) or ((1239 + 1768) > (11400 - 8206))) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
			end
		end
		if (v95.TargetIsValid() or ((4956 - 2820) >= (2607 + 339))) then
			local v157 = 1807 - (518 + 1289);
			while true do
				if (((3712 - 1547) <= (335 + 2186)) and (v157 == (3 - 0))) then
					if (((2108 + 753) > (1130 - (304 + 165))) and v91.Spellsteal:IsAvailable() and v86 and v91.Spellsteal:IsReady() and v30 and v69 and not v13:IsCasting() and not v13:IsChanneling() and v95.UnitHasMagicBuff(v14)) then
						if (((4272 + 253) > (4679 - (54 + 106))) and v19(v91.Spellsteal, not v14:IsSpellInRange(v91.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((5147 - (1618 + 351)) > (686 + 286)) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v95.TargetIsValid()) then
						local v222 = 1016 - (10 + 1006);
						local v223;
						while true do
							if (((1197 + 3569) == (668 + 4098)) and (v222 == (0 - 0))) then
								v223 = v95.HandleDPSPotion(not v91.ArcaneSurge:IsReady());
								if (v223 or ((3778 - (912 + 121)) > (1479 + 1649))) then
									return v223;
								end
								v222 = 1290 - (1140 + 149);
							end
							if ((v222 == (3 + 1)) or ((1524 - 380) >= (857 + 3749))) then
								if (((11423 - 8085) >= (518 - 241)) and v25) then
									return v25;
								end
								break;
							end
							if (((451 + 2159) > (8883 - 6323)) and (v222 == (187 - (165 + 21)))) then
								if ((v87 and v91.TimeWarp:IsReady() and v91.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v91.ArcaneSurge:CooldownUp() or (v111 <= (151 - (61 + 50))) or (v13:BuffUp(v91.ArcaneSurgeBuff) and (v111 <= (v91.ArcaneSurge:CooldownRemains() + 6 + 8))))) or ((5691 - 4497) > (6211 - 3128))) then
									if (((360 + 556) >= (2207 - (1295 + 165))) and v19(v91.TimeWarp, not v14:IsInRange(10 + 30))) then
										return "time_warp main 4";
									end
								end
								if ((v77 and ((v80 and v28) or not v80) and (v76 < v111)) or ((983 + 1461) > (4351 - (819 + 578)))) then
									if (((4294 - (331 + 1071)) < (4257 - (588 + 155))) and v91.LightsJudgment:IsCastable() and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and ((v98 >= (1284 - (546 + 736))) or (v99 >= (1939 - (1834 + 103))))) then
										if (((328 + 205) == (1589 - 1056)) and v19(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment))) then
											return "lights_judgment main 6";
										end
									end
									if (((2361 - (1536 + 230)) <= (3904 - (128 + 363))) and v91.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v91.ArcaneSurge) and not (v13:BuffUp(v91.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v91.ArcaneSurgeBuff) and v14:DebuffUp(v91.TouchoftheMagiDebuff)))) then
										if (((7657 - 4579) >= (670 + 1921)) and v19(v91.Berserking)) then
											return "berserking main 8";
										end
									end
									if (((5299 - 2100) < (11864 - 7834)) and v13:PrevGCDP(2 - 1, v91.ArcaneSurge)) then
										if (((534 + 243) < (3087 - (615 + 394))) and v91.BloodFury:IsCastable()) then
											if (((1532 + 164) <= (2175 + 107)) and v19(v91.BloodFury)) then
												return "blood_fury main 10";
											end
										end
										if (v91.Fireblood:IsCastable() or ((5368 - 3607) >= (11167 - 8705))) then
											if (((5202 - (59 + 592)) > (5153 - 2825)) and v19(v91.Fireblood)) then
												return "fireblood main 12";
											end
										end
										if (((7043 - 3218) >= (330 + 137)) and v91.AncestralCall:IsCastable()) then
											if (v19(v91.AncestralCall) or ((3061 - (70 + 101)) == (1376 - 819))) then
												return "ancestral_call main 14";
											end
										end
									end
								end
								v222 = 2 + 0;
							end
							if ((v222 == (7 - 4)) or ((5011 - (123 + 118)) == (703 + 2201))) then
								if (v25 or ((49 + 3854) == (5935 - (653 + 746)))) then
									return v25;
								end
								v25 = v125();
								v222 = 7 - 3;
							end
							if (((5896 - 1803) <= (12971 - 8126)) and (v222 == (1 + 1))) then
								if (((1004 + 565) <= (3186 + 461)) and (v76 < v111)) then
									if ((v78 and ((v28 and v79) or not v79)) or ((496 + 3550) >= (769 + 4158))) then
										local v227 = 0 - 0;
										while true do
											if (((4401 + 222) >= (5149 - 2362)) and ((1234 - (885 + 349)) == v227)) then
												v25 = v115();
												if (((1775 + 459) >= (3354 - 2124)) and v25) then
													return v25;
												end
												break;
											end
										end
									end
								end
								v25 = v117();
								v222 = 8 - 5;
							end
						end
					end
					break;
				end
				if ((v157 == (968 - (915 + 53))) or ((1144 - (768 + 33)) == (6838 - 5052))) then
					if (((4524 - 1954) > (2737 - (287 + 41))) and Focus) then
						if (v70 or ((3456 - (638 + 209)) >= (1681 + 1553))) then
							local v225 = 1686 - (96 + 1590);
							while true do
								if ((v225 == (1672 - (741 + 931))) or ((1490 + 1543) >= (11484 - 7453))) then
									v25 = v114();
									if (v25 or ((6545 - 5144) == (2003 + 2665))) then
										return v25;
									end
									break;
								end
							end
						end
					end
					if (((1193 + 1583) >= (422 + 899)) and not v13:AffectingCombat() and v26) then
						local v224 = 0 - 0;
						while true do
							if ((v224 == (0 + 0)) or ((238 + 249) > (9394 - 7091))) then
								v25 = v116();
								if (v25 or ((4041 + 462) == (3956 - (64 + 430)))) then
									return v25;
								end
								break;
							end
						end
					end
					v157 = 1 + 0;
				end
				if (((916 - (106 + 257)) <= (1094 + 449)) and (v157 == (723 - (496 + 225)))) then
					if (((4120 - 2105) == (9815 - 7800)) and v71) then
						if (v90 or ((5899 - (256 + 1402)) <= (4231 - (30 + 1869)))) then
							local v226 = 1369 - (213 + 1156);
							while true do
								if ((v226 == (188 - (96 + 92))) or ((403 + 1961) < (2056 - (142 + 757)))) then
									v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 25 + 5);
									if (v25 or ((477 + 690) > (1357 - (32 + 47)))) then
										return v25;
									end
									break;
								end
							end
						end
					end
					if (v72 or ((3122 - (1053 + 924)) <= (1060 + 22))) then
						v25 = v95.HandleIncorporeal(v91.Polymorph, v93.PolymorphMouseOver, 51 - 21, true);
						if (v25 or ((4753 - (685 + 963)) == (9925 - 5044))) then
							return v25;
						end
					end
					v157 = 3 - 0;
				end
				if ((v157 == (1710 - (541 + 1168))) or ((3484 - (645 + 952)) > (5716 - (669 + 169)))) then
					v25 = v113();
					if (v25 or ((14157 - 10070) > (8937 - 4821))) then
						return v25;
					end
					v157 = 1 + 1;
				end
			end
		end
	end
	local function v129()
		local v149 = 0 + 0;
		while true do
			if (((1871 - (181 + 584)) <= (2661 - (665 + 730))) and (v149 == (0 - 0))) then
				v96();
				v17.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v17.SetAPL(125 - 63, v128, v129);
end;
return v0["Epix_Mage_Arcane.lua"]();

