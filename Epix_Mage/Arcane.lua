local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2966 - 1355) < (688 + 3103)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((9101 - 4523) <= (6682 - 4674))) then
			v6 = v0[v4];
			if (((1638 - (203 + 310)) <= (4069 - (1238 + 755))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		if (v94.RemoveCurse:IsAvailable() or ((2277 - (709 + 825)) >= (8105 - 3706))) then
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
	local v104 = 3 - 0;
	local v105 = false;
	local v106 = false;
	local v107 = false;
	local v108 = true;
	local v109 = false;
	local v110 = v13:HasTier(893 - (196 + 668), 15 - 11);
	local v111 = (466070 - 241070) - (((25833 - (171 + 662)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((200093 - (4 + 89)) * v24(not v110)));
	local v112 = 10 - 7;
	local v113 = 4046 + 7065;
	local v114 = 48802 - 37691;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if (((2641 - (35 + 1451)) < (3126 - (28 + 1425))) and (v134 == (1994 - (941 + 1052)))) then
				v111 = (215744 + 9256) - (((26514 - (822 + 692)) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((285533 - 85533) * v24(not v110)));
				v113 = 5234 + 5877;
				v134 = 299 - (45 + 252);
			end
			if ((v134 == (0 + 0)) or ((800 + 1524) <= (1406 - 828))) then
				v105 = false;
				v108 = true;
				v134 = 434 - (114 + 319);
			end
			if (((5408 - 1641) == (4826 - 1059)) and (v134 == (2 + 0))) then
				v114 = 16553 - 5442;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v110 = not v13:HasTier(60 - 31, 1967 - (556 + 1407));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v116()
		local v135 = 1206 - (741 + 465);
		while true do
			if (((4554 - (170 + 295)) == (2155 + 1934)) and (v135 == (3 + 0))) then
				if (((10975 - 6517) >= (1388 + 286)) and v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) then
					if (((624 + 348) <= (803 + 615)) and v21(v94.AlterTime)) then
						return "alter_time defensive 6";
					end
				end
				if ((v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) or ((6168 - (957 + 273)) < (1274 + 3488))) then
					if (v21(v96.Healthstone) or ((1003 + 1501) > (16247 - 11983))) then
						return "healthstone defensive";
					end
				end
				v135 = 10 - 6;
			end
			if (((6576 - 4423) == (10660 - 8507)) and (v135 == (1782 - (389 + 1391)))) then
				if ((v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((319 + 188) >= (270 + 2321))) then
					if (((10201 - 5720) == (5432 - (783 + 168))) and v21(v94.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((7813 - 5485) < (682 + 11))) then
					if (((4639 - (309 + 2)) == (13290 - 8962)) and v21(v94.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v135 = 1215 - (1090 + 122);
			end
			if (((515 + 1073) >= (4473 - 3141)) and (v135 == (0 + 0))) then
				if ((v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((5292 - (628 + 490)) > (762 + 3486))) then
					if (v21(v94.PrismaticBarrier) or ((11354 - 6768) <= (374 - 292))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((4637 - (431 + 343)) == (7801 - 3938)) and v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 5 - 3, v94.ArcaneIntellect)) then
					if (v21(v94.MassBarrier) or ((223 + 59) <= (6 + 36))) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 1696 - (556 + 1139);
			end
			if (((4624 - (6 + 9)) >= (141 + 625)) and ((3 + 1) == v135)) then
				if ((v84 and (v13:HealthPercentage() <= v86)) or ((1321 - (28 + 141)) == (964 + 1524))) then
					local v207 = 0 - 0;
					while true do
						if (((2424 + 998) > (4667 - (486 + 831))) and (v207 == (0 - 0))) then
							if (((3087 - 2210) > (72 + 304)) and (v88 == "Refreshing Healing Potion")) then
								if (v95.RefreshingHealingPotion:IsReady() or ((9858 - 6740) <= (3114 - (668 + 595)))) then
									if (v21(v96.RefreshingHealingPotion) or ((149 + 16) >= (705 + 2787))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((10769 - 6820) < (5146 - (23 + 267))) and (v88 == "Dreamwalker's Healing Potion")) then
								if (v95.DreamwalkersHealingPotion:IsReady() or ((6220 - (1129 + 815)) < (3403 - (371 + 16)))) then
									if (((6440 - (1326 + 424)) > (7812 - 3687)) and v21(v96.RefreshingHealingPotion)) then
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
			if ((v135 == (3 - 2)) or ((168 - (88 + 30)) >= (1667 - (720 + 51)))) then
				if ((v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) or ((3812 - 2098) >= (4734 - (421 + 1355)))) then
					if (v21(v94.IceBlock) or ((2459 - 968) < (317 + 327))) then
						return "ice_block defensive 3";
					end
				end
				if (((1787 - (286 + 797)) < (3608 - 2621)) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (((6158 - 2440) > (2345 - (397 + 42))) and v21(v94.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v135 = 1 + 1;
			end
		end
	end
	local v117 = 800 - (24 + 776);
	local function v118()
		if ((v94.RemoveCurse:IsReady() and v98.UnitHasDispellableDebuffByPlayer(v15)) or ((1475 - 517) > (4420 - (222 + 563)))) then
			local v187 = 0 - 0;
			while true do
				if (((2521 + 980) <= (4682 - (23 + 167))) and (v187 == (1798 - (690 + 1108)))) then
					if ((v117 == (0 + 0)) or ((2840 + 602) < (3396 - (40 + 808)))) then
						v117 = GetTime();
					end
					if (((474 + 2401) >= (5598 - 4134)) and v98.Wait(478 + 22, v117)) then
						local v216 = 0 + 0;
						while true do
							if ((v216 == (0 + 0)) or ((5368 - (47 + 524)) >= (3176 + 1717))) then
								if (v21(v96.RemoveCurseFocus) or ((1506 - 955) > (3092 - 1024))) then
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
		local v136 = 1726 - (1165 + 561);
		while true do
			if (((63 + 2051) > (2923 - 1979)) and (v136 == (0 + 0))) then
				v27 = v98.HandleTopTrinket(v97, v30, 519 - (341 + 138), nil);
				if (v27 or ((611 + 1651) >= (6389 - 3293))) then
					return v27;
				end
				v136 = 327 - (89 + 237);
			end
			if ((v136 == (3 - 2)) or ((4747 - 2492) >= (4418 - (581 + 300)))) then
				v27 = v98.HandleBottomTrinket(v97, v30, 1260 - (855 + 365), nil);
				if (v27 or ((9113 - 5276) < (427 + 879))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v120()
		local v137 = 1235 - (1030 + 205);
		while true do
			if (((2770 + 180) == (2745 + 205)) and (v137 == (288 - (156 + 130)))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((10731 - 6008) < (5558 - 2260))) then
					if (((2326 - 1190) >= (41 + 113)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if (((0 + 0) == v137) or ((340 - (10 + 59)) > (1343 + 3405))) then
				if (((23343 - 18603) >= (4315 - (671 + 492))) and v94.MirrorImage:IsCastable() and v91 and v63) then
					if (v21(v94.MirrorImage) or ((2053 + 525) >= (4605 - (369 + 846)))) then
						return "mirror_image precombat 2";
					end
				end
				if (((11 + 30) <= (1418 + 243)) and v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) then
					if (((2546 - (1036 + 909)) < (2831 + 729)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast precombat 4";
					end
				end
				v137 = 1 - 0;
			end
			if (((438 - (11 + 192)) < (348 + 339)) and (v137 == (176 - (135 + 40)))) then
				if (((11021 - 6472) > (695 + 458)) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
					if (v21(v94.Evocation) or ((10296 - 5622) < (7003 - 2331))) then
						return "evocation precombat 6";
					end
				end
				if (((3844 - (50 + 126)) < (12700 - 8139)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(9 + 31)) or ((1868 - (1233 + 180)) == (4574 - (522 + 447)))) then
						return "arcane_orb precombat 8";
					end
				end
				v137 = 1423 - (107 + 1314);
			end
		end
	end
	local function v121()
		local v138 = 0 + 0;
		while true do
			if (((2 - 1) == v138) or ((1132 + 1531) == (6576 - 3264))) then
				if (((16922 - 12645) <= (6385 - (716 + 1194))) and v14:DebuffUp(v94.TouchoftheMagiDebuff) and v108) then
					v108 = false;
				end
				v109 = v94.ArcaneBlast:CastTime() < v115;
				break;
			end
			if ((v138 == (0 + 0)) or ((94 + 776) == (1692 - (74 + 429)))) then
				if (((2995 - 1442) <= (1553 + 1580)) and ((v101 >= v104) or (v102 >= v104)) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (3 + 0))) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (5 - 3)))) then
					v106 = true;
				elseif ((v106 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (16 - 9)) and v94.RadiantSpark:CooldownDown()) or ((2670 - (279 + 154)) >= (4289 - (454 + 324)))) then
					v106 = false;
				end
				if (((v13:ArcaneCharges() > (3 + 0)) and ((v101 < v104) or (v102 < v104)) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (24 - (12 + 5)))) and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * (3 + 2))) or (v94.ArcaneSurge:CooldownRemains() > (101 - 61)))) or ((490 + 834) > (4113 - (277 + 816)))) then
					v107 = true;
				elseif ((v107 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (29 - 22)) and v94.RadiantSpark:CooldownDown()) or ((4175 - (1058 + 125)) == (353 + 1528))) then
					v107 = false;
				end
				v138 = 976 - (815 + 160);
			end
		end
	end
	local function v122()
		local v139 = 0 - 0;
		while true do
			if (((7373 - 4267) > (365 + 1161)) and (v139 == (0 - 0))) then
				if (((4921 - (41 + 1857)) < (5763 - (1222 + 671))) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) then
					if (((204 - 61) > (1256 - (229 + 953))) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((1792 - (1111 + 663)) < (3691 - (874 + 705))) and v94.RadiantSpark:CooldownUp()) then
					v105 = v94.ArcaneSurge:CooldownRemains() < (2 + 8);
				end
				if (((749 + 348) <= (3383 - 1755)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) then
					if (((131 + 4499) == (5309 - (642 + 37))) and v21(v94.ShiftingPower, not v14:IsInRange(10 + 30), true)) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if (((567 + 2973) > (6736 - 4053)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and v94.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (((5248 - (233 + 221)) >= (7573 - 4298)) and v21(v94.ArcaneOrb, not v14:IsInRange(36 + 4))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				v139 = 1542 - (718 + 823);
			end
			if (((934 + 550) == (2289 - (266 + 539))) and (v139 == (11 - 7))) then
				if (((2657 - (636 + 589)) < (8438 - 4883)) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (v21(v94.PresenceofMind) or ((2196 - 1131) > (2836 + 742))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.PresenceofMindBuff))) or ((1743 + 3052) < (2422 - (657 + 358)))) then
					if (((4906 - 3053) < (10965 - 6152)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1191 - (1151 + 36))) and v13:PrevGCDP(1 + 0, v94.ArcaneBlast)))) or ((742 + 2079) < (7259 - 4828))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((4706 - (1552 + 280)) < (3015 - (64 + 770)))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((1826 + 863) <= (778 - 435))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((332 + 1537) == (3252 - (157 + 1086)))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v139 == (1 - 0)) or ((15530 - 11984) < (3561 - 1239))) then
				if ((v94.ArcaneBlast:IsReady() and v33 and v94.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (2 - 0)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v94.ArcaneOrb:CooldownRemains() >= v115)))) or ((2901 - (599 + 220)) == (9504 - 4731))) then
					if (((5175 - (1813 + 118)) > (772 + 283)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (1217 - (841 + 376))) and (v13:ManaPercentage() > (42 - 12)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((770 + 2543) <= (4853 - 3075))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((2280 - (464 + 395)) >= (5399 - 3295))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				if (((871 + 941) <= (4086 - (467 + 370))) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (9 - 4)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (5 + 1)))) and v13:HasTier(106 - 75, 1 + 3)) then
					if (((3775 - 2152) <= (2477 - (150 + 370))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((5694 - (74 + 1208)) == (10851 - 6439)) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (80 - 63)) and not v13:HasTier(22 + 8, 394 - (14 + 376))) then
					if (((3035 - 1285) >= (545 + 297)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				v139 = 2 + 0;
			end
			if (((4170 + 202) > (5420 - 3570)) and (v139 == (2 + 0))) then
				if (((310 - (23 + 55)) < (1945 - 1124)) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (2 + 0)) and (v94.RadiantSpark:CooldownRemains() < (5 + 0)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (9 - 3)))) and not v13:HasTier(10 + 20, 905 - (652 + 249))) then
					if (((1386 - 868) < (2770 - (708 + 1160))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if (((8126 - 5132) > (1564 - 706)) and v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (42 - (10 + 17))) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (2 + 3)))) and (v94.ArcaneSurge:CooldownRemains() < (1762 - (1400 + 332)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((7202 - 3447) <= (2823 - (242 + 1666)))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if (((1689 + 2257) > (1372 + 2371)) and v94.ArcaneMissiles:IsReady() and v38 and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < v115)) and v13:HasTier(26 + 4, 944 - (850 + 90))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((2337 - 1002) >= (4696 - (360 + 1030)))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if (((4287 + 557) > (6358 - 4105)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (((621 - 169) == (2113 - (909 + 752))) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v139 = 1226 - (109 + 1114);
			end
			if ((v139 == (5 - 2)) or ((1774 + 2783) < (2329 - (6 + 236)))) then
				if (((2441 + 1433) == (3119 + 755)) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (70 - 40)) and (v94.ArcaneEcho:IsAvailable())) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((3384 - 1446) > (6068 - (1076 + 57)))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if ((v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) or ((700 + 3555) < (4112 - (579 + 110)))) then
					if (((115 + 1339) <= (2203 + 288)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1 + 0, v94.ArcaneSurge) or v13:PrevGCDP(408 - (174 + 233), v94.NetherTempest) or v13:PrevGCDP(2 - 1, v94.RadiantSpark))) or ((7295 - 3138) <= (1247 + 1556))) then
					if (((6027 - (663 + 511)) >= (2661 + 321)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				if (((898 + 3236) > (10349 - 6992)) and v94.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v94.RadiantSparkVulnerability) and (v14:DebuffStack(v94.RadiantSparkVulnerability) < (3 + 1))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((8044 - 4627) < (6133 - 3599))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				v139 = 2 + 2;
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (0 + 0)) or ((249 + 2473) <= (886 - (478 + 244)))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (562 - (440 + 77))) and v14:DebuffDown(v94.NetherTempestDebuff) and v108 and v13:BloodlustUp()) or ((1095 + 1313) < (7718 - 5609))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((1589 - (655 + 901)) == (270 + 1185))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((v108 and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((300 + 143) >= (16174 - 12159))) then
					if (((4827 - (695 + 750)) > (566 - 400)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (7 - 2)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (24 - 18)))) and v13:HasTier(382 - (285 + 66), 8 - 4)) or ((1590 - (682 + 628)) == (494 + 2565))) then
					if (((2180 - (176 + 123)) > (541 + 752)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if (((1710 + 647) == (2626 - (239 + 30))) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (5 + 10))) then
					if (((119 + 4) == (217 - 94)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v140 = 2 - 1;
			end
			if ((v140 == (317 - (306 + 9))) or ((3684 - 2628) >= (590 + 2802))) then
				if ((v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114) and ((not v94.NetherTempest:IsAvailable() and ((v13:PrevGCDP(3 + 1, v94.RadiantSpark) and not v109) or v13:PrevGCDP(3 + 2, v94.RadiantSpark))) or v13:PrevGCDP(2 - 1, v94.NetherTempest))) or ((2456 - (1140 + 235)) < (685 + 390))) then
					if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes)) or ((962 + 87) >= (1138 + 3294))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v94.ArcaneBlast:CastTime() >= v13:GCD()) and (v94.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v94.RadiantSparkVulnerability)) and (not v94.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (87 - (33 + 19)))) and ((v94.NetherTempest:IsAvailable() and v13:PrevGCDP(3 + 3, v94.RadiantSpark)) or (not v94.NetherTempest:IsAvailable() and v13:PrevGCDP(14 - 9, v94.RadiantSpark))) and not (v13:IsCasting(v94.ArcaneSurge) and (v13:CastRemains() < (0.5 + 0)) and not v109)) or ((9350 - 4582) <= (794 + 52))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((4047 - (586 + 103)) <= (130 + 1290))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (12 - 8))) or ((5227 - (1309 + 179)) <= (5424 - 2419))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((723 + 936) >= (5730 - 3596))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and v13:PrevGCDP(1 + 0, v94.ArcaneBarrage) and ((v94.ArcaneBarrage:InFlight() and ((v94.ArcaneBarrage:TravelTime() - v94.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 - 0))) or (v13:GCDRemains() <= (0.2 - 0)))) or ((3869 - (295 + 314)) < (5784 - 3429))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((2631 - (1300 + 662)) == (13260 - 9037))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v140 = 1758 - (1178 + 577);
			end
			if ((v140 == (1 + 0)) or ((5001 - 3309) < (1993 - (851 + 554)))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (2 + 0)) and (v94.RadiantSpark:CooldownRemains() < (13 - 8)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (12 - 6)))) or ((5099 - (115 + 187)) < (2797 + 854))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3955 + 222) > (19112 - 14262))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (1176 - (160 + 1001))) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (5 + 0)))) and (v94.ArcaneSurge:CooldownRemains() < (21 + 9))) or ((818 - 418) > (1469 - (237 + 121)))) then
					if (((3948 - (525 + 372)) > (1904 - 899)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if (((12133 - 8440) <= (4524 - (96 + 46))) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((4059 - (643 + 134)) > (1481 + 2619))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if ((v94.NetherTempest:IsReady() and v42 and not v109 and (v94.NetherTempest:TimeSinceLastCast() >= (35 - 20)) and ((not v109 and v13:PrevGCDP(14 - 10, v94.RadiantSpark) and (v94.ArcaneSurge:CooldownRemains() <= v94.NetherTempest:ExecuteTime())) or v13:PrevGCDP(5 + 0, v94.RadiantSpark))) or ((7025 - 3445) < (5813 - 2969))) then
					if (((808 - (316 + 403)) < (2985 + 1505)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v140 = 5 - 3;
			end
			if ((v140 == (2 + 1)) or ((12548 - 7565) < (1282 + 526))) then
				if (((1235 + 2594) > (13059 - 9290)) and v94.ArcaneBlast:IsReady() and v33) then
					if (((7092 - 5607) <= (6032 - 3128)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if (((245 + 4024) == (8403 - 4134)) and v94.ArcaneBarrage:IsReady() and v34) then
					if (((19 + 368) <= (8184 - 5402)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if ((v13:BuffUp(v94.PresenceofMindBuff) and v92 and (v13:PrevGCDP(18 - (12 + 5), v94.ArcaneBlast)) and (v94.ArcaneSurge:CooldownRemains() > (291 - 216))) or ((4051 - 2152) <= (1948 - 1031))) then
			if (v21(v96.CancelPOM) or ((10692 - 6380) <= (178 + 698))) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if (((4205 - (1656 + 317)) <= (2314 + 282)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) then
			if (((5570 - 3475) < (18140 - 14454)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((1949 - (5 + 349)) >= (21250 - 16776))) then
			if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((5890 - (266 + 1005)) < (1900 + 982))) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v94.ArcaneOrb:TimeSinceLastCast() >= (51 - 36)) and (v13:ArcaneCharges() < (3 - 0))) or ((1990 - (561 + 1135)) >= (6295 - 1464))) then
			if (((6669 - 4640) <= (4150 - (507 + 559))) and v21(v94.ArcaneOrb, not v14:IsInRange(100 - 60))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (46 - 31)) and (v94.ArcaneEcho:IsAvailable())) or ((2425 - (212 + 176)) == (3325 - (250 + 655)))) then
			if (((12156 - 7698) > (6821 - 2917)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((681 - 245) >= (2079 - (1869 + 87))) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
			if (((1734 - 1234) < (3717 - (484 + 1417))) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if (((7660 - 4086) == (5989 - 2415)) and v94.ArcaneBarrage:IsReady() and v34 and (v94.ArcaneSurge:CooldownRemains() < (848 - (48 + 725))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 1)) and not v94.OrbBarrage:IsAvailable()) then
			if (((592 - 371) < (227 + 163)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 2)) and (v94.ArcaneSurge:CooldownRemains() > (21 + 54))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (928 - (152 + 701))) and not v94.OrbBarrage:IsAvailable()))) or ((3524 - (430 + 881)) <= (545 + 876))) then
			if (((3953 - (557 + 338)) < (1437 + 3423)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 - 1)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (6 - 4)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (7 - 4)) and ((v101 > (10 - 5)) or (v102 > (806 - (499 + 302))))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (870 - (39 + 827)))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable()) or ((3577 - 2281) >= (9929 - 5483))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((5532 - 4139) > (6891 - 2402))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if ((v94.PresenceofMind:IsCastable() and v43) or ((379 + 4045) < (79 - 52))) then
			if (v21(v94.PresenceofMind) or ((320 + 1677) > (6036 - 2221))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if (((3569 - (103 + 1)) > (2467 - (475 + 79))) and v94.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 - 2)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (9 - 6))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable()))) then
			if (((95 + 638) < (1601 + 218)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1507 - (1395 + 108))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (8 - 5)) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) or ((5599 - (7 + 1197)) == (2074 + 2681))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1324 + 2469) < (2688 - (27 + 292)))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v125()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (1 - 0)) or ((17127 - 13043) == (522 - 257))) then
				if (((8299 - 3941) == (4497 - (43 + 96))) and v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((12800 - 9662) < (2244 - 1251))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if (((2764 + 566) > (656 + 1667)) and v94.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v94.ArcaneHarmonyBuff) or (v94.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (69 - 34)))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1390 + 2236) == (7475 - 3486))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (3 + 27)) and (v94.TouchoftheMagi:CooldownRemains() > (1781 - (1414 + 337)))) or (v13:ManaPercentage() > (2010 - (1642 + 298)))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((2387 - 1471) == (7683 - 5012))) then
					if (((806 - 534) == (90 + 182)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((3306 + 943) <= (5811 - (357 + 615))) and v94.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v94.ClearcastingBuff) > (1 + 0)) and v94.ConjureManaGem:IsAvailable() and v95.ManaGem:CooldownUp()) then
					if (((6813 - 4036) < (2742 + 458)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				v141 = 4 - 2;
			end
			if (((76 + 19) < (133 + 1824)) and (v141 == (2 + 0))) then
				if (((2127 - (384 + 917)) < (2414 - (128 + 569))) and v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.NetherPrecisionBuff))) then
					if (((2969 - (1407 + 136)) >= (2992 - (687 + 1200))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast touch_phase 14";
					end
				end
				if (((4464 - (556 + 1154)) <= (11887 - 8508)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > v94.ArcaneMissiles:CastTime()) or not v94.PresenceofMind:IsAvailable())) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((4022 - (9 + 86)) == (1834 - (275 + 146)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((188 + 966) <= (852 - (29 + 35)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((7281 - 5638) > (10092 - 6713))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((12373 - 9570) > (2963 + 1586))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1232 - (53 + 959)) >= (3430 - (312 + 96)))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if (((4897 - 2075) == (3107 - (147 + 138))) and (v141 == (899 - (813 + 86)))) then
				if ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (9 + 0)) or ((1965 - 904) == (2349 - (18 + 474)))) then
					v105 = not v105;
				end
				if (((932 + 1828) > (4451 - 3087)) and v94.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v94.NetherTempestDebuff) or not v14:DebuffUp(v94.NetherTempestDebuff)) and (v13:ArcaneCharges() == (1090 - (860 + 226))) and (v13:ManaPercentage() < (333 - (121 + 182))) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((6142 - (988 + 252)) <= (407 + 3188))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (1 + 1)) and (v13:ManaPercentage() < (2000 - (49 + 1921))) and (v13:SpellHaste() < (890.667 - (223 + 667))) and v13:BuffDown(v94.ArcaneSurgeBuff)) or ((3904 - (51 + 1)) == (504 - 211))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(85 - 45)) or ((2684 - (146 + 979)) == (1295 + 3293))) then
						return "arcane_orb touch_phase 4";
					end
				end
				if ((v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((5089 - (311 + 294)) == (2197 - 1409))) then
					if (((1935 + 2633) >= (5350 - (496 + 947))) and v21(v94.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				v141 = 1359 - (1233 + 125);
			end
		end
	end
	local function v126()
		if (((506 + 740) < (3114 + 356)) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (2 + 7))) then
			v105 = not v105;
		end
		if (((5713 - (963 + 682)) >= (812 + 160)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff)) then
			if (((1997 - (504 + 1000)) < (2622 + 1271)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles aoe_touch_phase 2";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((((v101 <= (4 + 0)) or (v102 <= (1 + 3))) and (v13:ArcaneCharges() == (4 - 1))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or ((1259 + 214) >= (1938 + 1394))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4233 - (156 + 26)) <= (667 + 490))) then
				return "arcane_barrage aoe_touch_phase 4";
			end
		end
		if (((944 - 340) < (3045 - (149 + 15))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (962 - (890 + 70)))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(157 - (39 + 78))) or ((1382 - (14 + 468)) == (7425 - 4048))) then
				return "arcane_orb aoe_touch_phase 6";
			end
		end
		if (((12462 - 8003) > (305 + 286)) and v94.ArcaneExplosion:IsCastable() and v35) then
			if (((2041 + 1357) >= (509 + 1886)) and v21(v94.ArcaneExplosion, not v14:IsInRange(5 + 5))) then
				return "arcane_explosion aoe_touch_phase 8";
			end
		end
	end
	local function v127()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1 - 0)) or ((2158 + 25) >= (9923 - 7099))) then
				if (((49 + 1887) == (1987 - (12 + 39))) and v94.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (3 + 0)) and (v14:HealthPercentage() < (108 - 73)) and v94.ArcaneBombardment:IsAvailable()) then
					if (v21(v94.PresenceofMind) or ((17209 - 12377) < (1279 + 3034))) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((2152 + 1936) > (9823 - 5949)) and v94.ArcaneBlast:IsReady() and v33 and v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (4 + 2))) then
					if (((20935 - 16603) == (6042 - (1596 + 114))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast rotation 10";
					end
				end
				if (((10440 - 6441) >= (3613 - (164 + 549))) and v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v14:HealthPercentage() < (1473 - (1059 + 379))) and v94.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (3 - 0))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1309 + 1216) > (686 + 3378))) then
						return "arcane_blast rotation 12";
					end
				end
				if (((4763 - (145 + 247)) == (3587 + 784)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (88 - 58)) and (v94.TouchoftheMagi:CooldownRemains() > (6 + 24))) or (v13:ManaPercentage() > (61 + 9))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((431 - 165) > (5706 - (254 + 466)))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				v142 = 562 - (544 + 16);
			end
			if (((6327 - 4336) >= (1553 - (294 + 334))) and (v142 == (253 - (236 + 17)))) then
				if (((197 + 258) < (1599 + 454)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (10 - 7)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (331 - 261)) or (v110 and (v94.TouchoftheMagi:CooldownRemains() > (16 + 14))))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(33 + 7)) or ((1620 - (413 + 381)) == (205 + 4646))) then
						return "arcane_orb rotation 2";
					end
				end
				v105 = ((v94.ArcaneSurge:CooldownRemains() > (63 - 33)) and (v94.TouchoftheMagi:CooldownRemains() > (25 - 15))) or false;
				if (((2153 - (582 + 1388)) == (311 - 128)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v110 and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (9 + 3))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (376 - (326 + 38)))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (35 - 23))) and (v114 > (21 - 6))) then
					if (((1779 - (47 + 573)) <= (631 + 1157)) and v21(v94.ShiftingPower, not v14:IsInRange(169 - 129))) then
						return "shifting_power rotation 4";
					end
				end
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and not v110 and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (73 - 28)) and (v114 > (1679 - (1269 + 395)))) or ((3999 - (76 + 416)) > (4761 - (319 + 124)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(91 - 51)) or ((4082 - (564 + 443)) <= (8208 - 5243))) then
						return "shifting_power rotation 6";
					end
				end
				v142 = 459 - (337 + 121);
			end
			if (((3999 - 2634) <= (6698 - 4687)) and (v142 == (1915 - (1261 + 650)))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((1175 + 1601) > (5697 - 2122))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((4371 - (772 + 1045)) == (678 + 4126))) then
						return "arcane_blast rotation 32";
					end
				end
				if (((2721 - (102 + 42)) == (4421 - (1524 + 320))) and v94.ArcaneBarrage:IsReady() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1276 - (1049 + 221)) >= (2045 - (18 + 138)))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((1238 - 732) <= (2994 - (67 + 1035))) and ((351 - (136 + 212)) == v142)) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffUp(v94.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((8532 - 6524) > (1777 + 441))) then
					if (((350 + 29) <= (5751 - (240 + 1364))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) or ((5596 - (1050 + 32)) <= (3602 - 2593))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((2068 + 1428) == (2247 - (331 + 724)))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (5 + 55)) and v105 and (v94.TouchoftheMagi:CooldownRemains() > (654 - (269 + 375))) and (v94.Evocation:CooldownRemains() > (765 - (267 + 458))) and (v114 > (7 + 13))) or ((399 - 191) == (3777 - (667 + 151)))) then
					if (((5774 - (1410 + 87)) >= (3210 - (1504 + 393))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage rotation 26";
					end
				end
				if (((6992 - 4405) < (8234 - 5060)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and (not v110 or not v108)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((4916 - (461 + 335)) <= (281 + 1917))) then
						return "arcane_missiles rotation 30";
					end
				end
				v142 = 1765 - (1730 + 31);
			end
			if ((v142 == (1669 - (728 + 939))) or ((5652 - 4056) == (1740 - 882))) then
				if (((7377 - 4157) == (4288 - (138 + 930))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) == v112)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1282 + 120) > (2831 + 789))) then
						return "arcane_missiles rotation 14";
					end
				end
				if (((2207 + 367) == (10510 - 7936)) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (1776 - (459 + 1307))) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v114 >= (1882 - (474 + 1396)))) then
					if (((3139 - 1341) < (2584 + 173)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest rotation 16";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (1 + 49)) and not v94.Evocation:IsAvailable() and (v114 > (57 - 37))) or ((48 + 329) > (8692 - 6088))) then
					if (((2477 - 1909) < (1502 - (562 + 29))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((2801 + 484) < (5647 - (374 + 1045))) and v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (56 + 14)) and v105 and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (15 - 10)) and (v114 > (658 - (448 + 190)))) then
					if (((1265 + 2651) > (1503 + 1825)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage rotation 20";
					end
				end
				v142 = 2 + 1;
			end
		end
	end
	local function v128()
		local v143 = 0 - 0;
		while true do
			if (((7768 - 5268) < (5333 - (1307 + 187))) and ((11 - 8) == v143)) then
				if (((1186 - 679) == (1554 - 1047)) and v94.ArcaneExplosion:IsCastable() and v35) then
					if (((923 - (232 + 451)) <= (3023 + 142)) and v21(v94.ArcaneExplosion, not v14:IsInRange(9 + 1))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if (((1398 - (510 + 54)) >= (1621 - 816)) and (v143 == (37 - (13 + 23)))) then
				if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v94.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v94.ArcaneArtilleryBuff) + (9 - 4)))) or ((5476 - 1664) < (4207 - 1891))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) or not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3740 - (830 + 258)) <= (5407 - 3874))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and ((v101 <= (3 + 1)) or (v102 <= (4 + 0)) or v13:BuffUp(v94.ClearcastingBuff)) and (v13:ArcaneCharges() == (1444 - (860 + 581)))) or ((13271 - 9673) < (1159 + 301))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4357 - (237 + 4)) < (2801 - 1609))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v143 = 4 - 2;
			end
			if ((v143 == (3 - 1)) or ((2765 + 612) <= (519 + 384))) then
				if (((15010 - 11034) >= (189 + 250)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() == (0 + 0)) and (v94.TouchoftheMagi:CooldownRemains() > (1444 - (85 + 1341)))) then
					if (((6401 - 2649) == (10596 - 6844)) and v21(v94.ArcaneOrb, not v14:IsInRange(412 - (45 + 327)))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((7634 - 3588) > (3197 - (444 + 58))) and v94.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (5 + 5)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((610 + 2935) == (1563 + 1634))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v143 = 8 - 5;
			end
			if (((4126 - (64 + 1668)) > (2346 - (1227 + 746))) and (v143 == (0 - 0))) then
				if (((7711 - 3556) <= (4726 - (415 + 79))) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (1 + 11))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (503 - (142 + 349)))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (6 + 6))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (15 - 3))) or (v94.ArcaneOrb:Charges() == (0 + 0)) or (v94.ArcaneOrb:CooldownRemains() > (9 + 3)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(108 - 68), true) or ((5445 - (1710 + 154)) == (3791 - (200 + 118)))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if (((1980 + 3015) > (5853 - 2505)) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (8 - 2)) or (v102 > (6 + 0)) or not v94.OrbBarrage:IsAvailable())) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((746 + 8) > (1999 + 1725))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v143 = 1 + 0;
			end
		end
	end
	local function v129()
		local v144 = 0 - 0;
		while true do
			if (((1467 - (363 + 887)) >= (98 - 41)) and (v144 == (4 - 3))) then
				if ((v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (5 + 25)) and (v94.ArcaneSurge:CooldownRemains() < v114) and not v95.ManaGem:Exists()) or ((4843 - 2773) >= (2759 + 1278))) then
					if (((4369 - (674 + 990)) == (776 + 1929)) and v21(v94.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((25 + 36) == (96 - 35)) and v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (1057 - (507 + 548))) and v13:BuffUp(v94.ArcaneSurgeBuff)) then
					if (v21(v96.ManaGem) or ((1536 - (289 + 548)) >= (3114 - (821 + 997)))) then
						return "mana_gem main 40";
					end
				end
				if ((v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and v13:PrevGCDP(256 - (195 + 60), v94.ArcaneSurge) and (not v109 or (v109 and v13:PrevGCDP(1 + 1, v94.ArcaneSurge)))) or ((3284 - (251 + 1250)) >= (10593 - 6977))) then
					if (v21(v96.ManaGem) or ((2689 + 1224) > (5559 - (809 + 223)))) then
						return "mana_gem main 42";
					end
				end
				if (((6385 - 2009) > (2453 - 1636)) and not v110 and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * ((3 - 2) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((3 + 0) * v24(v13:HasTier(16 + 14, 619 - (14 + 603)) and not v13:HasTier(159 - (118 + 11), 1 + 3)))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (38 + 7)) and ((v94.TouchoftheMagi:CooldownRemains() < (v115 * (11 - 7))) or (v94.TouchoftheMagi:CooldownRemains() > (969 - (551 + 398)))) and ((v101 < v104) or (v102 < v104))) then
					v27 = v122();
					if (((3073 + 1788) > (294 + 530)) and v27) then
						return v27;
					end
				end
				v144 = 2 + 0;
			end
			if ((v144 == (7 - 5)) or ((3186 - 1803) >= (691 + 1440))) then
				if ((not v110 and (v94.ArcaneSurge:CooldownRemains() > (119 - 89)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1 + 2))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and ((v101 < v104) or (v102 < v104))) or ((1965 - (40 + 49)) >= (9676 - 7135))) then
					local v208 = 490 - (99 + 391);
					while true do
						if (((1474 + 308) <= (16581 - 12809)) and (v208 == (0 - 0))) then
							v27 = v122();
							if (v27 or ((4579 + 121) < (2139 - 1326))) then
								return v27;
							end
							break;
						end
					end
				end
				if (((4803 - (1032 + 572)) < (4467 - (203 + 214))) and v30 and v94.RadiantSpark:IsAvailable() and v106) then
					local v209 = 1817 - (568 + 1249);
					while true do
						if ((v209 == (0 + 0)) or ((11891 - 6940) < (17111 - 12681))) then
							v27 = v124();
							if (((1402 - (913 + 393)) == (271 - 175)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v110 and v94.RadiantSpark:IsAvailable() and v107) or ((3869 - 1130) > (4418 - (269 + 141)))) then
					local v210 = 0 - 0;
					while true do
						if ((v210 == (1981 - (362 + 1619))) or ((1648 - (950 + 675)) == (438 + 696))) then
							v27 = v123();
							if (v27 or ((3872 - (216 + 963)) >= (5398 - (485 + 802)))) then
								return v27;
							end
							break;
						end
					end
				end
				if ((v30 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 >= v104) or (v102 >= v104))) or ((4875 - (432 + 127)) <= (3219 - (1065 + 8)))) then
					v27 = v126();
					if (v27 or ((1970 + 1576) <= (4410 - (635 + 966)))) then
						return v27;
					end
				end
				v144 = 3 + 0;
			end
			if (((4946 - (5 + 37)) > (5386 - 3220)) and (v144 == (0 + 0))) then
				if (((171 - 62) >= (43 + 47)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 - 0, v94.ArcaneBarrage))) then
					if (((18872 - 13894) > (5478 - 2573)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (227 - 132)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v114 * (3 + 1))) and not ((v114 > (539 - (318 + 211))) and (v94.ArcaneSurge:CooldownRemains() < (4 - 3)))))) or ((4613 - (963 + 624)) <= (975 + 1305))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((2499 - (518 + 328)) <= (2582 - 1474))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((4649 - 1740) > (2926 - (301 + 16))) and v94.ArcaneBarrage:IsReady() and v34 and (v114 < (5 - 3))) then
					if (((2126 - 1369) > (506 - 312)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage main 34";
					end
				end
				if ((v94.Evocation:IsCastable() and v40 and not v108 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (10 + 0)) and (v94.TouchoftheMagi:CooldownRemains() < (12 + 8))) or (v94.TouchoftheMagi:CooldownRemains() < (31 - 16))) and (v13:ManaPercentage() < (v114 * (3 + 1)))) or ((3 + 28) >= (4444 - 3046))) then
					if (((1032 + 2164) <= (5891 - (829 + 190))) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				v144 = 3 - 2;
			end
			if (((4208 - 882) == (4597 - 1271)) and (v144 == (7 - 4))) then
				if (((340 + 1093) <= (1267 + 2611)) and v30 and v110 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 < v104) or (v102 < v104))) then
					v27 = v125();
					if (v27 or ((4804 - 3221) == (1638 + 97))) then
						return v27;
					end
				end
				if ((v101 >= v104) or (v102 >= v104) or ((3594 - (520 + 93)) == (2626 - (259 + 17)))) then
					v27 = v128();
					if (v27 or ((258 + 4208) <= (178 + 315))) then
						return v27;
					end
				end
				if ((v101 < v104) or (v102 < v104) or ((8622 - 6075) <= (2578 - (396 + 195)))) then
					local v211 = 0 - 0;
					while true do
						if (((4722 - (440 + 1321)) > (4569 - (1059 + 770))) and ((0 - 0) == v211)) then
							v27 = v127();
							if (((4241 - (424 + 121)) >= (659 + 2953)) and v27) then
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
		v92 = EpicSettings.Settings['cancelPOM'];
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
		v64 = EpicSettings.Settings['alterTimeHP'] or (1347 - (641 + 706));
		v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
		v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (440 - (249 + 191));
		v67 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v70 = EpicSettings.Settings['massBarrierHP'] or (427 - (183 + 244));
		v89 = EpicSettings.Settings['useSpellStealTarget'];
		v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v91 = EpicSettings.Settings['mirrorImageBeforePull'];
		v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v131()
		local v181 = 0 + 0;
		while true do
			if ((v181 == (733 - (434 + 296))) or ((9477 - 6507) == (2390 - (169 + 343)))) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v181 = 4 + 0;
			end
			if ((v181 == (6 - 2)) or ((10839 - 7146) < (1620 + 357))) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (1123 - (651 + 472));
				v181 = 4 + 1;
			end
			if (((1 + 0) == v181) or ((1135 - 205) > (2584 - (397 + 86)))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v181 = 878 - (423 + 453);
			end
			if (((423 + 3730) > (407 + 2679)) and ((2 + 0) == v181)) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v181 = 3 + 0;
			end
			if ((v181 == (0 + 0)) or ((5844 - (50 + 1140)) <= (3501 + 549))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v181 = 1 + 0;
			end
			if ((v181 == (7 - 2)) or ((1883 + 719) < (2092 - (157 + 439)))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v132()
		local v182 = 0 - 0;
		while true do
			if ((v182 == (0 - 0)) or ((3017 - 1997) > (3206 - (782 + 136)))) then
				v130();
				v131();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v182 = 856 - (112 + 743);
			end
			if (((1499 - (1026 + 145)) == (57 + 271)) and (v182 == (719 - (493 + 225)))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (((5553 - 4042) < (2317 + 1491)) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v182 = 5 - 3;
			end
			if (((1 + 1) == v182) or ((7173 - 4663) > (1433 + 3486))) then
				v100 = v14:GetEnemiesInSplashRange(7 - 2);
				v103 = v13:GetEnemiesInRange(1635 - (210 + 1385));
				if (((6452 - (1201 + 488)) == (2952 + 1811)) and v29) then
					local v212 = 0 - 0;
					while true do
						if (((7418 - 3281) > (2433 - (352 + 233))) and ((0 - 0) == v212)) then
							v101 = v26(v14:GetEnemiesInSplashRangeCount(3 + 2), #v103);
							v102 = #v103;
							break;
						end
					end
				else
					v101 = 2 - 1;
					v102 = 575 - (489 + 85);
				end
				if (((3937 - (277 + 1224)) <= (4627 - (663 + 830))) and (v98.TargetIsValid() or v13:AffectingCombat())) then
					local v213 = 0 + 0;
					while true do
						if (((9116 - 5393) == (4598 - (461 + 414))) and ((0 + 0) == v213)) then
							if (v13:AffectingCombat() or v72 or ((1619 + 2427) >= (412 + 3904))) then
								local v218 = 0 + 0;
								local v219;
								while true do
									if (((250 - (172 + 78)) == v218) or ((3237 - 1229) < (710 + 1219))) then
										v219 = v72 and v94.RemoveCurse:IsReady() and v32;
										v27 = v98.FocusUnit(v219, nil, 28 - 8, nil, 6 + 14, v94.ArcaneIntellect);
										v218 = 1 + 0;
									end
									if (((3993 - 1609) > (2234 - 459)) and (v218 == (1 + 0))) then
										if (v27 or ((2513 + 2030) <= (1558 + 2818))) then
											return v27;
										end
										break;
									end
								end
							end
							v113 = v10.BossFightRemains(nil, true);
							v213 = 3 - 2;
						end
						if (((1696 - 968) == (224 + 504)) and (v213 == (1 + 0))) then
							v114 = v113;
							if ((v114 == (11558 - (133 + 314))) or ((188 + 888) > (4884 - (199 + 14)))) then
								v114 = v10.FightRemains(v103, false);
							end
							break;
						end
					end
				end
				v182 = 10 - 7;
			end
			if (((3400 - (647 + 902)) >= (1136 - 758)) and (v182 == (236 - (85 + 148)))) then
				v115 = v13:GCD();
				if (v73 or ((3237 - (426 + 863)) >= (16268 - 12792))) then
					if (((6448 - (873 + 781)) >= (1114 - 281)) and v93) then
						local v217 = 0 - 0;
						while true do
							if (((1695 + 2395) == (15109 - 11019)) and (v217 == (0 - 0))) then
								v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 89 - 59);
								if (v27 or ((5705 - (414 + 1533)) == (2166 + 332))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (not v13:AffectingCombat() or v28 or ((3228 - (443 + 112)) < (3054 - (888 + 591)))) then
					local v214 = 0 - 0;
					while true do
						if (((0 + 0) == v214) or ((14014 - 10293) <= (568 + 887))) then
							if (((452 + 482) < (243 + 2027)) and v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) then
								if (v21(v94.ArcaneIntellect) or ((3071 - 1459) == (2324 - 1069))) then
									return "arcane_intellect group_buff";
								end
							end
							if ((v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) or ((6030 - (136 + 1542)) < (13792 - 9586))) then
								if (v21(v94.ArcaneFamiliar) or ((2839 + 21) <= (287 - 106))) then
									return "arcane_familiar precombat 2";
								end
							end
							v214 = 1 + 0;
						end
						if (((3708 - (68 + 418)) >= (4138 - 2611)) and (v214 == (1 - 0))) then
							if (((1300 + 205) <= (3213 - (770 + 322))) and v94.ConjureManaGem:IsCastable() and v39) then
								if (((43 + 701) == (216 + 528)) and v21(v94.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
					end
				end
				if (v98.TargetIsValid() or ((271 + 1708) >= (4057 - 1221))) then
					local v215 = 0 - 0;
					while true do
						if (((4991 - 3158) <= (9813 - 7145)) and (v215 == (2 + 0))) then
							if (((5522 - 1836) == (1769 + 1917)) and v73) then
								if (((2126 + 1341) > (374 + 103)) and v93) then
									v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 112 - 82);
									if (v27 or ((4566 - 1278) >= (1197 + 2344))) then
										return v27;
									end
								end
							end
							if (v74 or ((16385 - 12828) == (15007 - 10467))) then
								local v220 = 0 + 0;
								while true do
									if ((v220 == (0 - 0)) or ((1092 - (762 + 69)) > (4102 - 2835))) then
										v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 26 + 4);
										if (((824 + 448) < (9331 - 5473)) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v215 = 1 + 2;
						end
						if (((59 + 3605) == (14275 - 10611)) and ((160 - (8 + 149)) == v215)) then
							if (((3261 - (1199 + 121)) >= (761 - 311)) and v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) then
								if (v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal)) or ((10488 - 5842) < (134 + 190))) then
									return "spellsteal damage";
								end
							end
							if (((13681 - 9848) == (8893 - 5060)) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) then
								local v221 = 0 + 0;
								local v222;
								while true do
									if ((v221 == (1809 - (518 + 1289))) or ((2126 - 886) > (448 + 2922))) then
										if ((v78 < v114) or ((3623 - 1142) == (3449 + 1233))) then
											if (((5196 - (304 + 165)) >= (197 + 11)) and v81 and ((v30 and v82) or not v82)) then
												local v227 = 160 - (54 + 106);
												while true do
													if (((2249 - (1618 + 351)) < (2716 + 1135)) and (v227 == (1016 - (10 + 1006)))) then
														v27 = v119();
														if (v27 or ((755 + 2252) > (448 + 2746))) then
															return v27;
														end
														break;
													end
												end
											end
										end
										v27 = v121();
										if (v27 or ((6924 - 4788) >= (3979 - (912 + 121)))) then
											return v27;
										end
										v221 = 2 + 1;
									end
									if (((3454 - (1140 + 149)) <= (1614 + 907)) and (v221 == (3 - 0))) then
										v27 = v129();
										if (((532 + 2329) > (2262 - 1601)) and v27) then
											return v27;
										end
										break;
									end
									if (((8486 - 3961) > (780 + 3739)) and (v221 == (3 - 2))) then
										if (((3364 - (165 + 21)) > (1083 - (61 + 50))) and v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes)) then
											if (((1964 + 2802) == (22716 - 17950)) and v21(v94.IceFloes)) then
												return "ice_floes movement";
											end
										end
										if ((v90 and v94.TimeWarp:IsReady() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v114 <= (80 - 40)) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v114 <= (v94.ArcaneSurge:CooldownRemains() + 6 + 8))))) or ((4205 - (1295 + 165)) > (714 + 2414))) then
											if (v21(v94.TimeWarp, not v14:IsInRange(17 + 23)) or ((2541 - (819 + 578)) >= (6008 - (331 + 1071)))) then
												return "time_warp main 4";
											end
										end
										if (((4081 - (588 + 155)) >= (1559 - (546 + 736))) and v80 and ((v83 and v30) or not v83) and (v78 < v114)) then
											local v225 = 1937 - (1834 + 103);
											while true do
												if (((1606 + 1004) > (7636 - 5076)) and (v225 == (1767 - (1536 + 230)))) then
													if (v13:PrevGCDP(492 - (128 + 363), v94.ArcaneSurge) or ((254 + 940) > (7669 - 4586))) then
														local v228 = 0 + 0;
														while true do
															if (((1516 - 600) >= (2199 - 1452)) and (v228 == (0 - 0))) then
																if (v94.BloodFury:IsCastable() or ((1678 + 766) > (3963 - (615 + 394)))) then
																	if (((2611 + 281) < (3349 + 165)) and v21(v94.BloodFury)) then
																		return "blood_fury main 10";
																	end
																end
																if (((1624 - 1091) == (2417 - 1884)) and v94.Fireblood:IsCastable()) then
																	if (((1246 - (59 + 592)) <= (7556 - 4143)) and v21(v94.Fireblood)) then
																		return "fireblood main 12";
																	end
																end
																v228 = 1 - 0;
															end
															if (((2170 + 908) >= (2762 - (70 + 101))) and (v228 == (2 - 1))) then
																if (((2269 + 930) < (10121 - 6091)) and v94.AncestralCall:IsCastable()) then
																	if (((1018 - (123 + 118)) < (503 + 1575)) and v21(v94.AncestralCall)) then
																		return "ancestral_call main 14";
																	end
																end
																break;
															end
														end
													end
													break;
												end
												if (((22 + 1674) <= (3681 - (653 + 746))) and (v225 == (0 - 0))) then
													if ((v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (2 - 0)) or (v102 >= (5 - 3)))) or ((777 + 984) >= (1576 + 886))) then
														if (((3975 + 576) > (286 + 2042)) and v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment))) then
															return "lights_judgment main 6";
														end
													end
													if (((597 + 3228) >= (1144 - 677)) and v94.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) then
														if (v21(v94.Berserking) or ((5339 - 2449) == (1791 - (885 + 349)))) then
															return "berserking main 8";
														end
													end
													v225 = 1 + 0;
												end
											end
										end
										v221 = 4 - 2;
									end
									if ((v221 == (0 - 0)) or ((5738 - (915 + 53)) == (3705 - (768 + 33)))) then
										if ((v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) or ((14944 - 11041) == (7985 - 3449))) then
											if (((4421 - (287 + 41)) <= (5692 - (638 + 209))) and v21(v96.UseWeapon, nil)) then
												return "Using Weapon Macro";
											end
										end
										v222 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
										if (((816 + 753) <= (5333 - (96 + 1590))) and v222) then
											return v222;
										end
										v221 = 1673 - (741 + 931);
									end
								end
							end
							break;
						end
						if ((v215 == (1 + 0)) or ((11527 - 7481) >= (23018 - 18091))) then
							v27 = v116();
							if (((1984 + 2639) >= (1198 + 1589)) and v27) then
								return v27;
							end
							v215 = 1 + 1;
						end
						if (((8477 - 6243) >= (400 + 830)) and (v215 == (0 + 0))) then
							if ((v72 and v32 and v94.RemoveCurse:IsAvailable()) or ((1398 - 1055) == (1603 + 183))) then
								local v223 = 494 - (64 + 430);
								while true do
									if (((2550 + 20) > (2772 - (106 + 257))) and (v223 == (0 + 0))) then
										if (v15 or ((3330 - (496 + 225)) >= (6612 - 3378))) then
											local v226 = 0 - 0;
											while true do
												if ((v226 == (1658 - (256 + 1402))) or ((4932 - (30 + 1869)) >= (5400 - (213 + 1156)))) then
													v27 = v118();
													if (v27 or ((1589 - (96 + 92)) == (796 + 3872))) then
														return v27;
													end
													break;
												end
											end
										end
										if (((3675 - (142 + 757)) >= (1077 + 244)) and v16 and v16:Exists() and v16:IsAPlayer() and v98.UnitHasCurseDebuff(v16)) then
											if (v94.RemoveCurse:IsReady() or ((200 + 287) > (2382 - (32 + 47)))) then
												if (v21(v96.RemoveCurseMouseover) or ((6480 - (1053 + 924)) == (3392 + 70))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if (((952 - 399) <= (3191 - (685 + 963))) and not v13:AffectingCombat() and v28) then
								local v224 = 0 - 0;
								while true do
									if (((3142 - 1127) == (3724 - (541 + 1168))) and (v224 == (1597 - (645 + 952)))) then
										v27 = v120();
										if (v27 or ((5079 - (669 + 169)) <= (8077 - 5745))) then
											return v27;
										end
										break;
									end
								end
							end
							v215 = 1 - 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v133()
		local v183 = 0 + 0;
		while true do
			if ((v183 == (0 + 0)) or ((3129 - (181 + 584)) < (2552 - (665 + 730)))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(178 - 116, v132, v133);
end;
return v0["Epix_Mage_Arcane.lua"]();

