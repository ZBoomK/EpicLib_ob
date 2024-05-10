local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2788 + 1457) <= (4287 + 344)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((18660 - 14384) >= (8719 - 4805)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((909 - (530 + 181)) <= (5246 - (614 + 267))) and (v5 == (33 - (19 + 13)))) then
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
		if (((7782 - 3000) > (10896 - 6220)) and v94.RemoveCurse:IsAvailable()) then
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
	local v104;
	if (((13894 - 9030) > (571 + 1626)) and not v94.ArcingCleave:IsAvailable()) then
		v104 = 15 - 6;
	elseif ((v94.ArcingCleave:IsAvailable() and (not v94.OrbBarrage:IsAvailable() or not v94.ArcaneBombardment:IsAvailable())) or ((7673 - 3973) == (4319 - (1293 + 519)))) then
		v104 = 10 - 5;
	else
		v104 = 7 - 4;
	end
	local v105 = false;
	local v106 = true;
	local v107 = false;
	local v108 = 21247 - 10136;
	local v109 = 47911 - 36800;
	local v110;
	v10:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if (((2370 + 2104) >= (56 + 218)) and ((2 - 1) == v126)) then
				v109 = 2568 + 8543;
				break;
			end
			if ((v126 == (0 + 0)) or ((1184 + 710) <= (2502 - (709 + 387)))) then
				v106 = true;
				v108 = 12969 - (673 + 1185);
				v126 = 2 - 1;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		if (((5047 - 3475) >= (2518 - 987)) and not v94.ArcingCleave:IsAvailable()) then
			v104 = 7 + 2;
		elseif ((v94.ArcingCleave:IsAvailable() and (not v94.OrbBarrage:IsAvailable() or not v94.ArcaneBombardment:IsAvailable())) or ((3503 + 1184) < (6131 - 1589))) then
			v104 = 2 + 3;
		else
			v104 = 5 - 2;
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v111()
		local v127 = 0 - 0;
		while true do
			if (((5171 - (446 + 1434)) > (2950 - (1040 + 243))) and (v127 == (8 - 5))) then
				if ((v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((2720 - (559 + 1288)) == (3965 - (609 + 1322)))) then
					if (v21(v94.AlterTime) or ((3270 - (13 + 441)) < (41 - 30))) then
						return "alter_time defensive 6";
					end
				end
				if (((9688 - 5989) < (23437 - 18731)) and v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) then
					if (((99 + 2547) >= (3181 - 2305)) and v21(v96.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v127 = 2 + 2;
			end
			if (((270 + 344) <= (9448 - 6264)) and (v127 == (2 + 0))) then
				if (((5748 - 2622) == (2067 + 1059)) and v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) then
					if (v21(v94.MirrorImage) or ((1217 + 970) >= (3560 + 1394))) then
						return "mirror_image defensive 4";
					end
				end
				if ((v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((3256 + 621) == (3498 + 77))) then
					if (((1140 - (153 + 280)) > (1824 - 1192)) and v21(v94.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v127 = 3 + 0;
			end
			if ((v127 == (0 + 0)) or ((286 + 260) >= (2436 + 248))) then
				if (((1062 + 403) <= (6548 - 2247)) and v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) then
					if (((1054 + 650) > (2092 - (89 + 578))) and v21(v94.PrismaticBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 2 + 0, v94.ArcaneIntellect)) or ((1428 - 741) == (5283 - (572 + 477)))) then
					if (v21(v94.MassBarrier) or ((450 + 2880) < (858 + 571))) then
						return "mass_barrier defensive 2";
					end
				end
				v127 = 1 + 0;
			end
			if (((1233 - (84 + 2)) >= (552 - 217)) and ((3 + 1) == v127)) then
				if (((4277 - (497 + 345)) > (54 + 2043)) and v84 and (v13:HealthPercentage() <= v86)) then
					local v201 = 0 + 0;
					while true do
						if ((v201 == (1333 - (605 + 728))) or ((2690 + 1080) >= (8984 - 4943))) then
							if ((v88 == "Refreshing Healing Potion") or ((174 + 3617) <= (5956 - 4345))) then
								if (v95.RefreshingHealingPotion:IsReady() or ((4128 + 450) <= (5563 - 3555))) then
									if (((850 + 275) <= (2565 - (457 + 32))) and v21(v96.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((316 + 427) >= (5801 - (832 + 570)))) then
								if (((1089 + 66) < (437 + 1236)) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (v21(v96.RefreshingHealingPotion) or ((8223 - 5899) <= (279 + 299))) then
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
			if (((4563 - (588 + 208)) == (10152 - 6385)) and (v127 == (1801 - (884 + 916)))) then
				if (((8560 - 4471) == (2371 + 1718)) and v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
					if (((5111 - (232 + 421)) >= (3563 - (1569 + 320))) and v21(v94.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((239 + 733) <= (270 + 1148)) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (v21(v94.IceColdAbility) or ((16639 - 11701) < (5367 - (316 + 289)))) then
						return "ice_cold defensive 3";
					end
				end
				v127 = 5 - 3;
			end
		end
	end
	local v112 = 0 + 0;
	local function v113()
		if ((v94.RemoveCurse:IsReady() and (v98.UnitHasDispellableDebuffByPlayer(v15) or v98.DispellableFriendlyUnit(1473 - (666 + 787)) or v98.UnitHasCurseDebuff(v15))) or ((2929 - (360 + 65)) > (3985 + 279))) then
			local v143 = 254 - (79 + 175);
			while true do
				if (((3394 - 1241) == (1681 + 472)) and ((0 - 0) == v143)) then
					if ((v112 == (0 - 0)) or ((1406 - (503 + 396)) >= (2772 - (92 + 89)))) then
						v112 = GetTime();
					end
					if (((8692 - 4211) == (2299 + 2182)) and v98.Wait(296 + 204, v112)) then
						local v205 = 0 - 0;
						while true do
							if ((v205 == (0 + 0)) or ((5307 - 2979) < (605 + 88))) then
								if (((2068 + 2260) == (13181 - 8853)) and v21(v96.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v112 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v114()
		local v128 = 0 - 0;
		while true do
			if (((2832 - (485 + 759)) >= (3081 - 1749)) and (v128 == (1190 - (442 + 747)))) then
				v27 = v98.HandleBottomTrinket(v97, v30, 1175 - (832 + 303), nil);
				if (v27 or ((5120 - (88 + 858)) > (1295 + 2953))) then
					return v27;
				end
				break;
			end
			if ((v128 == (0 + 0)) or ((189 + 4397) <= (871 - (766 + 23)))) then
				v27 = v98.HandleTopTrinket(v97, v30, 197 - 157, nil);
				if (((5282 - 1419) == (10177 - 6314)) and v27) then
					return v27;
				end
				v128 = 3 - 2;
			end
		end
	end
	local function v115()
		if ((v94.MirrorImage:IsCastable() and v91 and v63) or ((1355 - (1036 + 37)) <= (30 + 12))) then
			if (((8975 - 4366) >= (603 + 163)) and v21(v94.MirrorImage)) then
				return "mirror_image precombat 2";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) or ((2632 - (641 + 839)) == (3401 - (910 + 3)))) then
			if (((8723 - 5301) > (5034 - (1466 + 218))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
				return "arcane_blast precombat 4";
			end
		end
		if (((404 + 473) > (1524 - (556 + 592))) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
			if (v21(v94.Evocation) or ((1109 + 2009) <= (2659 - (329 + 479)))) then
				return "evocation precombat 6";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((1019 - (174 + 680)) >= (11998 - 8506))) then
			if (((8184 - 4235) < (3468 + 1388)) and v21(v94.ArcaneOrb, not v14:IsInRange(779 - (396 + 343)))) then
				return "arcane_orb precombat 8";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33) or ((379 + 3897) < (4493 - (29 + 1448)))) then
			if (((6079 - (135 + 1254)) > (15539 - 11414)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v116()
		if (((v101 >= v104) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (2 + 1))) and (v94.RadiantSpark:CooldownUp() or not v94.RadiantSpark:IsAvailable()) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (1529 - (389 + 1138)))) or not v94.TouchoftheMagi:IsAvailable())) or ((624 - (102 + 472)) >= (846 + 50))) then
			v105 = true;
		end
		if ((v105 and ((v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (4 + 3)) and v94.RadiantSpark:CooldownDown()) or (not v94.RadiantSpark:IsAvailable() and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) or ((1599 + 115) >= (4503 - (320 + 1225)))) then
			v105 = false;
		end
		if ((v14:DebuffUp(v94.TouchoftheMagiDebuff) and v106) or ((2653 - 1162) < (395 + 249))) then
			v106 = false;
		end
		v107 = v94.ArcaneBlast:CastTime() < v110;
	end
	local function v117()
		if (((2168 - (157 + 1307)) < (2846 - (821 + 1038))) and v94.TouchoftheMagi:IsReady() and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage)) and v51 and ((v56 and v31) or not v56) and (v78 < v109)) then
			if (((407 + 3311) > (3384 - 1478)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
				return "touch_of_the_magi aoe_cooldown_phase 2";
			end
		end
		if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v109)) or ((357 + 601) > (9009 - 5374))) then
			if (((4527 - (834 + 192)) <= (286 + 4206)) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes))) then
				return "radiant_spark aoe_cooldown_phase 4";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (1 + 2)) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) or ((74 + 3368) < (3947 - 1399))) then
			if (((3179 - (300 + 4)) >= (391 + 1073)) and v21(v94.ArcaneOrb, not v14:IsInRange(104 - 64))) then
				return "arcane_orb aoe_cooldown_phase 6";
			end
		end
		if ((v94.NetherTempest:IsReady() and v94.ArcaneEcho:IsAvailable() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and v42) or ((5159 - (112 + 250)) >= (1951 + 2942))) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((1380 - 829) > (1185 + 883))) then
				return "nether_tempest aoe_cooldown_phase 8";
			end
		end
		if (((1094 + 1020) > (707 + 237)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v109)) then
			if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes)) or ((1122 + 1140) >= (2300 + 796))) then
				return "arcane_surge aoe_cooldown_phase 10";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and (v94.ArcaneSurge:CooldownRemains() < (1489 - (1001 + 413))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (8 - 4)) and not v94.OrbBarrage:IsAvailable() and v34) or ((3137 - (244 + 638)) >= (4230 - (627 + 66)))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((11432 - 7595) < (1908 - (512 + 90)))) then
				return "arcane_barrage aoe_cooldown_phase 12";
			end
		end
		if (((4856 - (1665 + 241)) == (3667 - (373 + 344))) and v94.ArcaneBarrage:IsReady() and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 1)) and (v94.ArcaneSurge:CooldownRemains() > (20 + 55))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 - 1)) and (v94.ArcaneSurge:CooldownRemains() < (126 - 51)) and not v94.OrbBarrage:IsAvailable())) and v34) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((5822 - (35 + 1064)) < (2400 + 898))) then
				return "arcane_barrage aoe_cooldown_phase 14";
			end
		end
		if (((2430 - 1294) >= (1 + 153)) and v94.ArcaneBarrage:IsReady() and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1237 - (298 + 938))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1261 - (233 + 1026))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1669 - (636 + 1030))) and (v101 > (3 + 2))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (4 + 0))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable() and v34) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((81 + 190) > (321 + 4427))) then
				return "arcane_barrage aoe_cooldown_phase 16";
			end
		end
		if (((4961 - (55 + 166)) >= (611 + 2541)) and v94.PresenceofMind:IsCastable() and v43) then
			if (v21(v94.PresenceofMind) or ((260 + 2318) >= (12946 - 9556))) then
				return "presence_of_mind aoe_cooldown_phase 18";
			end
		end
		if (((338 - (36 + 261)) <= (2904 - 1243)) and v94.ArcaneBlast:IsReady() and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1370 - (34 + 1334))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 + 1))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable())) and v33) then
			if (((467 + 134) < (4843 - (1035 + 248))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast aoe_cooldown_phase 20";
			end
		end
		if (((256 - (20 + 1)) < (358 + 329)) and v94.ArcaneBarrage:IsReady() and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (323 - (134 + 185))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1136 - (549 + 584))) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) then
			if (((5234 - (314 + 371)) > (3958 - 2805)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_cooldown_phase 22";
			end
		end
	end
	local function v118()
		local v129 = 968 - (478 + 490);
		while true do
			if (((0 + 0) == v129) or ((5846 - (786 + 386)) < (15132 - 10460))) then
				if (((5047 - (1055 + 324)) < (5901 - (1093 + 247))) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v109) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (11 + 1))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (2 + 10))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (47 - 35))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (40 - 28))) or (v94.ArcaneOrb:Charges() == (0 - 0)) or (v94.ArcaneOrb:CooldownRemains() > (30 - 18))) and v14:DebuffDown(v94.TouchoftheMagiDebuff)) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(7 + 11)) or ((1752 - 1297) == (12425 - 8820))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v94.NetherTempest:IsReady() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (5 + 1)) or not v94.OrbBarrage:IsAvailable()) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v42) or ((6810 - 4147) == (4000 - (364 + 324)))) then
					if (((11724 - 7447) <= (10738 - 6263)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v129 = 1 + 0;
			end
			if ((v129 == (4 - 3)) or ((1393 - 523) == (3610 - 2421))) then
				if (((2821 - (1249 + 19)) <= (2828 + 305)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and ((v94.TouchoftheMagi:CooldownRemains() + (19 - 14)) > v13:BuffRemains(v94.ArcaneArtilleryBuff))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3323 - (686 + 400)) >= (2755 + 756))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (((v101 <= (233 - (73 + 156))) and (v13:ArcaneCharges() == (1 + 2))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (820 - (721 + 90))))) or ((15 + 1309) > (9805 - 6785))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((3462 - (224 + 246)) == (3047 - 1166))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v129 = 3 - 1;
			end
			if (((564 + 2542) > (37 + 1489)) and (v129 == (2 + 0))) then
				if (((6010 - 2987) < (12878 - 9008)) and v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (515 - (203 + 310))) and (v94.TouchoftheMagi:CooldownRemains() > (2011 - (1238 + 755))) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) then
					if (((10 + 133) > (1608 - (709 + 825))) and v21(v94.ArcaneOrb, not v14:IsInRange(73 - 33))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((25 - 7) < (2976 - (196 + 668))) and v94.ArcaneExplosion:IsReady() and v14:IsInRange(39 - 29)) then
					if (((2272 - 1175) <= (2461 - (171 + 662))) and v21(v94.ArcaneExplosion, not v14:IsInRange(103 - (4 + 89)))) then
						return "arcane_explosion aoe_rotation 12";
					end
				end
				break;
			end
		end
	end
	local function v119()
		if (((16228 - 11598) == (1686 + 2944)) and v94.TouchoftheMagi:IsReady() and (v13:PrevGCDP(4 - 3, v94.ArcaneBarrage)) and v51 and ((v56 and v31) or not v56) and (v78 < v109)) then
			if (((1389 + 2151) > (4169 - (35 + 1451))) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (((6247 - (28 + 1425)) >= (5268 - (941 + 1052))) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v109) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) then
			if (((1423 + 61) == (2998 - (822 + 692))) and v21(v94.ShiftingPower, not v14:IsInRange(25 - 7))) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if (((675 + 757) < (3852 - (45 + 252))) and v94.ArcaneOrb:IsReady() and (v94.RadiantSpark:CooldownUp() or ((v101 >= (2 + 0)) and v14:DebuffDown(v94.RadiantSparkVulnerability))) and (v13:ArcaneCharges() < v13:ArcaneChargesMax()) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(14 + 26)) or ((2591 - 1526) > (4011 - (114 + 319)))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if ((v94.ArcaneMissiles:IsReady() and v106 and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (6 - 1)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v110 * (7 - 1)))) and v38) or ((3057 + 1738) < (2095 - 688))) then
			if (((3882 - 2029) < (6776 - (556 + 1407))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles cooldown_phase 8";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v106 and v94.ArcaneSurge:CooldownUp() and (v13:ManaPercentage() > (1216 - (741 + 465))) and (v13:BuffRemains(v94.SiphonStormBuff) > (482 - (170 + 295))) and not v13:HasTier(16 + 14, 4 + 0) and v33) or ((6945 - 4124) < (2016 + 415))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1844 + 1030) < (1236 + 945))) then
				return "arcane_blast cooldown_phase 10";
			end
		end
		if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (1230 - (957 + 273))) and (v13:ManaPercentage() > (9 + 21)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((1077 + 1612) <= (1306 - 963))) then
			if (v21(v96.StopCasting) or ((4925 - 3056) == (6136 - 4127))) then
				return "arcane_missiles interrupt cooldown_phase 12";
			end
		end
		if ((v94.ArcaneMissiles:IsReady() and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < (v110 * (14 - 11)))) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v110 * (1786 - (389 + 1391))))) and v38) or ((2225 + 1321) < (242 + 2080))) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((4739 - 2657) == (5724 - (783 + 168)))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if (((10887 - 7643) > (1038 + 17)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v109)) then
			if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((3624 - (309 + 2)) <= (5460 - 3682))) then
				return "radiant_spark cooldown_phase 16";
			end
		end
		if ((v94.NetherTempest:IsReady() and (v94.NetherTempest:TimeSinceLastCast() >= (1242 - (1090 + 122))) and (v94.ArcaneEcho:IsAvailable()) and v42) or ((461 + 960) >= (7066 - 4962))) then
			if (((1241 + 571) <= (4367 - (628 + 490))) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
				return "nether_tempest cooldown_phase 18";
			end
		end
		if (((292 + 1331) <= (4844 - 2887)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v109)) then
			if (((20162 - 15750) == (5186 - (431 + 343))) and v21(v94.ArcaneSurge)) then
				return "arcane_surge cooldown_phase 20";
			end
		end
		if (((3534 - 1784) >= (2435 - 1593)) and v94.ArcaneBarrage:IsReady() and (v13:PrevGCDP(1 + 0, v94.ArcaneSurge) or v13:PrevGCDP(1 + 0, v94.NetherTempest) or v13:PrevGCDP(1696 - (556 + 1139), v94.RadiantSpark) or ((v101 >= ((19 - (6 + 9)) - ((1 + 1) * v24(v94.OrbBarrage:IsAvailable())))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (3 + 1)) and v94.ArcingCleave:IsAvailable())) and v34) then
			if (((4541 - (28 + 141)) > (717 + 1133)) and v21(v94.ArcaneBarrage, v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage cooldown_phase 22";
			end
		end
		if (((285 - 53) < (582 + 239)) and v94.ArcaneBlast:IsReady() and v14:DebuffUp(v94.RadiantSparkVulnerability) and ((v14:DebuffStack(v94.RadiantSparkVulnerability) < (1321 - (486 + 831))) or (v107 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (10 - 6)))) and v33) then
			if (((1823 - 1305) < (171 + 731)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast cooldown_phase 24";
			end
		end
		if (((9466 - 6472) > (2121 - (668 + 595))) and v94.PresenceofMind:IsCastable() and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v110) and v43) then
			if (v20(v94.PresenceofMind) or ((3379 + 376) <= (185 + 730))) then
				return "presence_of_mind cooldown_phase 26";
			end
		end
		if (((10761 - 6815) > (4033 - (23 + 267))) and v94.ArcaneBlast:IsReady() and (v13:BuffUp(v94.PresenceofMindBuff)) and v33) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((3279 - (1129 + 815)) >= (3693 - (371 + 16)))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if (((6594 - (1326 + 424)) > (4266 - 2013)) and v94.ArcaneMissiles:IsReady() and ((v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff)) or ((v13:BuffStack(v94.ClearcastingBuff) > (7 - 5)) and v14:DebuffUp(v94.TouchoftheMagiDebuff))) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (122 - (88 + 30))) and v13:PrevGCDP(772 - (720 + 51), v94.ArcaneBlast))) and v38) then
			if (((1005 - 553) == (2228 - (421 + 1355))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles cooldown_phase 30";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33) or ((7517 - 2960) < (1026 + 1061))) then
			if (((4957 - (286 + 797)) == (14161 - 10287)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
	end
	local function v120()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (440 - (397 + 42))) or ((606 + 1332) > (5735 - (24 + 776)))) then
				if ((v94.NetherTempest:IsReady() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (15 - 5)) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v106 and (v109 >= (797 - (222 + 563))) and v42) or ((9375 - 5120) < (2465 + 958))) then
					if (((1644 - (23 + 167)) <= (4289 - (690 + 1108))) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest rotation 8";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (26 + 44)) and (((v94.ArcaneSurge:CooldownRemains() > (25 + 5)) and (v94.TouchoftheMagi:CooldownRemains() > (858 - (40 + 808))) and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (1 + 4)) and (v109 > (114 - 84))) or (not v94.Evocation:IsAvailable() and (v109 > (20 + 0)))) and v34) or ((2200 + 1957) <= (1538 + 1265))) then
					if (((5424 - (47 + 524)) >= (1936 + 1046)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage rotation 10";
					end
				end
				v130 = 5 - 3;
			end
			if (((6181 - 2047) > (7655 - 4298)) and (v130 == (1728 - (1165 + 561)))) then
				if ((v94.PresenceofMind:IsCastable() and (v13:ArcaneCharges() < (1 + 2)) and (v14:HealthPercentage() < (108 - 73)) and v94.ArcaneBombardment:IsAvailable() and v43) or ((1304 + 2113) < (3013 - (341 + 138)))) then
					if (v21(v94.PresenceofMind) or ((735 + 1987) <= (337 - 173))) then
						return "presence_of_mind rotation 12";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and (((v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) or (v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (332 - (89 + 237))))) and v33) or ((7746 - 5338) < (4439 - 2330))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((914 - (581 + 300)) == (2675 - (855 + 365)))) then
						return "arcane_blast rotation 14";
					end
				end
				v130 = 6 - 3;
			end
			if ((v130 == (1 + 2)) or ((1678 - (1030 + 205)) >= (3770 + 245))) then
				if (((3147 + 235) > (452 - (156 + 130))) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (v13:ManaPercentage() > (50 - 20)) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (v21(v96.StopCasting) or ((573 - 293) == (807 + 2252))) then
						return "arcane_missiles interrupt rotation 16";
					end
				end
				if (((1097 + 784) > (1362 - (10 + 59))) and v94.ArcaneMissiles:IsCastable() and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and not v106 and v38) then
					if (((667 + 1690) == (11607 - 9250)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles rotation 18";
					end
				end
				v130 = 1167 - (671 + 492);
			end
			if (((98 + 25) == (1338 - (369 + 846))) and (v130 == (2 + 2))) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((902 + 154) >= (5337 - (1036 + 909)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((860 + 221) < (1804 - 729))) then
						return "arcane_blast rotation 20";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34) or ((1252 - (11 + 192)) >= (2240 + 2192))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((4943 - (135 + 40)) <= (2049 - 1203))) then
						return "arcane_barrage rotation 22";
					end
				end
				break;
			end
			if ((v130 == (0 + 0)) or ((7397 - 4039) <= (2128 - 708))) then
				if ((v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (179 - (50 + 126))) and (v13:BloodlustDown() or (v13:ManaPercentage() > (194 - 124))) and v49 and ((v54 and v31) or not v54)) or ((828 + 2911) <= (4418 - (1233 + 180)))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(1009 - (522 + 447))) or ((3080 - (107 + 1314)) >= (991 + 1143))) then
						return "arcane_orb rotation 2";
					end
				end
				if ((v94.ShiftingPower:IsReady() and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (137 - 92)) and (v109 > (7 + 8)) and v48 and ((v30 and v53) or not v53) and (v78 < v109)) or ((6473 - 3213) < (9317 - 6962))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(1928 - (716 + 1194))) or ((12 + 657) == (453 + 3770))) then
						return "shifting_power rotation 4";
					end
				end
				v130 = 504 - (74 + 429);
			end
		end
	end
	local function v121()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 + 0)) or ((3872 - 2180) < (416 + 172))) then
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v109) and (v13:PrevGCDP(2 - 1, v94.ArcaneBarrage))) or ((11860 - 7063) < (4084 - (279 + 154)))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((4955 - (454 + 324)) > (3816 + 1034))) then
						return "touch_of_the_magi main 30";
					end
				end
				if ((v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (112 - (12 + 5))) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v109 * (3 + 1))) and not ((v109 > (25 - 15)) and (v94.ArcaneSurge:CooldownRemains() < (1 + 0)))))) or ((1493 - (277 + 816)) > (4747 - 3636))) then
					if (((4234 - (1058 + 125)) > (189 + 816)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((4668 - (815 + 160)) <= (18801 - 14419)) and v94.ArcaneBarrage:IsReady() and v34 and (v109 < (4 - 2))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((783 + 2499) > (11984 - 7884))) then
						return "arcane_barrage main 34";
					end
				end
				v131 = 1899 - (41 + 1857);
			end
			if ((v131 == (1896 - (1222 + 671))) or ((9252 - 5672) < (4087 - 1243))) then
				if (((1271 - (229 + 953)) < (6264 - (1111 + 663))) and (v94.ArcaneSurge:CooldownRemains() > (1609 - (874 + 705))) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (1 + 2))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and (v101 < v104)) then
					v27 = v119();
					if (v27 or ((3400 + 1583) < (3758 - 1950))) then
						return v27;
					end
				end
				if (((108 + 3721) > (4448 - (642 + 37))) and v105 and ((v94.ArcaneSurge:CooldownRemains() < (v110 * (1 + 3))) or (v94.ArcaneSurge:CooldownRemains() > (7 + 33)))) then
					v27 = v117();
					if (((3728 - 2243) <= (3358 - (233 + 221))) and v27) then
						return v27;
					end
				end
				if (((9871 - 5602) == (3758 + 511)) and (v101 >= v104)) then
					local v202 = 1541 - (718 + 823);
					while true do
						if (((244 + 143) <= (3587 - (266 + 539))) and (v202 == (0 - 0))) then
							v27 = v118();
							if (v27 or ((3124 - (636 + 589)) <= (2176 - 1259))) then
								return v27;
							end
							break;
						end
					end
				end
				v131 = 8 - 4;
			end
			if ((v131 == (2 + 0)) or ((1567 + 2745) <= (1891 - (657 + 358)))) then
				if (((5909 - 3677) <= (5914 - 3318)) and v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and (v13:PrevGCDP(1188 - (1151 + 36), v94.ArcaneSurge))) then
					if (((2024 + 71) < (970 + 2716)) and v21(v96.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((((v94.ArcaneSurge:CooldownRemains() <= (v110 * ((2 - 1) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((1835 - (1552 + 280)) * v24(v13:HasTier(864 - (64 + 770), 2 + 0) and not v13:HasTier(68 - 38, 1 + 3)))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (1288 - (157 + 1086))) and ((v94.TouchoftheMagi:CooldownRemains() < (v110 * (7 - 3))) or (v94.TouchoftheMagi:CooldownRemains() > (87 - 67))) and (v101 < v104)) or ((2446 - 851) >= (6106 - 1632))) then
					v27 = v119();
					if (v27 or ((5438 - (599 + 220)) < (5738 - 2856))) then
						return v27;
					end
				end
				if (((v94.ArcaneSurge:CooldownRemains() > (1961 - (1813 + 118))) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (3 + 0))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and (v101 < v104)) or ((1511 - (841 + 376)) >= (6769 - 1938))) then
					v27 = v119();
					if (((472 + 1557) <= (8417 - 5333)) and v27) then
						return v27;
					end
				end
				v131 = 862 - (464 + 395);
			end
			if ((v131 == (10 - 6)) or ((979 + 1058) == (3257 - (467 + 370)))) then
				v27 = v120();
				if (((9212 - 4754) > (2866 + 1038)) and v27) then
					return v27;
				end
				break;
			end
			if (((1494 - 1058) >= (20 + 103)) and (v131 == (2 - 1))) then
				if (((1020 - (150 + 370)) < (3098 - (74 + 1208))) and v94.Evocation:IsCastable() and v40 and not v106 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (24 - 14)) and (v94.TouchoftheMagi:CooldownRemains() < (94 - 74))) or (v94.TouchoftheMagi:CooldownRemains() < (11 + 4))) and (((v13:BloodlustRemains() < (421 - (14 + 376))) and v13:BloodlustUp()) or not v106)) then
					if (((6198 - 2624) == (2313 + 1261)) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				if (((195 + 26) < (372 + 18)) and v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (87 - 57)) and (v94.ArcaneSurge:CooldownRemains() < v109) and not v95.ManaGem:Exists()) then
					if (v21(v94.ConjureManaGem) or ((1665 + 548) <= (1499 - (23 + 55)))) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((7247 - 4189) < (3244 + 1616)) and v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (2 + 0)) and v13:BuffUp(v94.ArcaneSurgeBuff)) then
					if (v21(v96.ManaGem) or ((2009 - 713) >= (1399 + 3047))) then
						return "mana_gem main 40";
					end
				end
				v131 = 903 - (652 + 249);
			end
		end
	end
	local function v122()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (1869 - (708 + 1160))) or ((3781 - 2388) > (8183 - 3694))) then
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useArcaneMissiles'];
				v39 = EpicSettings.Settings['useConjureManaGem'];
				v40 = EpicSettings.Settings['useEvocation'];
				v132 = 29 - (10 + 17);
			end
			if ((v132 == (1 + 2)) or ((6156 - (1400 + 332)) < (51 - 24))) then
				v44 = EpicSettings.Settings['useCounterspell'];
				v45 = EpicSettings.Settings['useBlastWave'];
				v46 = EpicSettings.Settings['useDragonsBreath'];
				v47 = EpicSettings.Settings['useArcaneSurge'];
				v132 = 1912 - (242 + 1666);
			end
			if ((v132 == (0 + 0)) or ((732 + 1265) > (3252 + 563))) then
				v33 = EpicSettings.Settings['useArcaneBlast'];
				v34 = EpicSettings.Settings['useArcaneBarrage'];
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneFamiliar'];
				v132 = 941 - (850 + 90);
			end
			if (((6068 - 2603) > (3303 - (360 + 1030))) and ((8 + 0) == v132)) then
				v64 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
				v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (1661 - (909 + 752));
				v67 = EpicSettings.Settings['iceBlockHP'] or (1223 - (109 + 1114));
				v132 = 16 - 7;
			end
			if (((286 + 447) < (2061 - (6 + 236))) and (v132 == (4 + 1))) then
				v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v132 = 5 + 1;
			end
			if (((13 - 7) == v132) or ((7676 - 3281) == (5888 - (1076 + 57)))) then
				v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v57 = EpicSettings.Settings['useAlterTime'];
				v58 = EpicSettings.Settings['usePrismaticBarrier'];
				v59 = EpicSettings.Settings['useGreaterInvisibility'];
				v132 = 2 + 5;
			end
			if (((698 - (579 + 110)) == v132) or ((300 + 3493) < (2095 + 274))) then
				v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v69 = EpicSettings.Settings['mirrorImageHP'] or (407 - (174 + 233));
				v70 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v89 = EpicSettings.Settings['useSpellStealTarget'];
				v132 = 17 - 7;
			end
			if ((v132 == (1 + 1)) or ((5258 - (663 + 511)) == (237 + 28))) then
				v41 = EpicSettings.Settings['useManaGem'];
				v42 = EpicSettings.Settings['useNetherTempest'];
				v43 = EpicSettings.Settings['usePresenceOfMind'];
				v92 = EpicSettings.Settings['cancelPOM'];
				v132 = 1 + 2;
			end
			if (((13435 - 9077) == (2640 + 1718)) and (v132 == (23 - 13))) then
				v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v91 = EpicSettings.Settings['mirrorImageBeforePull'];
				v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v132 == (9 - 5)) or ((1498 + 1640) < (1932 - 939))) then
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['useArcaneOrb'];
				v50 = EpicSettings.Settings['useRadiantSpark'];
				v51 = EpicSettings.Settings['useTouchOfTheMagi'];
				v132 = 4 + 1;
			end
			if (((305 + 3025) > (3045 - (478 + 244))) and ((524 - (440 + 77)) == v132)) then
				v60 = EpicSettings.Settings['useIceBlock'];
				v61 = EpicSettings.Settings['useIceCold'];
				v62 = EpicSettings.Settings['useMassBarrier'];
				v63 = EpicSettings.Settings['useMirrorImage'];
				v132 = 4 + 4;
			end
		end
	end
	local function v123()
		local v133 = 0 - 0;
		while true do
			if (((1559 - (655 + 901)) == v133) or ((673 + 2953) == (3054 + 935))) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v133 = 3 + 1;
			end
			if ((v133 == (20 - 15)) or ((2361 - (695 + 750)) == (9120 - 6449))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((419 - 147) == (1093 - 821)) and (v133 == (353 - (285 + 66)))) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v133 = 6 - 3;
			end
			if (((5559 - (682 + 628)) <= (780 + 4059)) and (v133 == (299 - (176 + 123)))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v133 = 1 + 0;
			end
			if (((3046 - (239 + 30)) < (870 + 2330)) and (v133 == (1 + 0))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v133 = 3 - 1;
			end
			if (((296 - 201) < (2272 - (306 + 9))) and ((13 - 9) == v133)) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v133 = 3 + 2;
			end
		end
	end
	local function v124()
		v122();
		v123();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['minicds'];
		v32 = EpicSettings.Toggles['dispel'];
		if (((2361 - 1535) < (3092 - (1140 + 235))) and v13:IsDeadOrGhost()) then
			return v27;
		end
		v100 = v14:GetEnemiesInSplashRange(4 + 1);
		v103 = v13:GetEnemiesInRange(37 + 3);
		if (((366 + 1060) >= (1157 - (33 + 19))) and v29) then
			local v144 = 0 + 0;
			while true do
				if (((8254 - 5500) <= (1489 + 1890)) and (v144 == (0 - 0))) then
					v101 = v26(v14:GetEnemiesInSplashRangeCount(5 + 0), #v103);
					v102 = #v103;
					break;
				end
			end
		else
			v101 = 690 - (586 + 103);
			v102 = 1 + 0;
		end
		if (v98.TargetIsValid() or v13:AffectingCombat() or ((12089 - 8162) == (2901 - (1309 + 179)))) then
			local v145 = 0 - 0;
			while true do
				if ((v145 == (1 + 0)) or ((3099 - 1945) <= (596 + 192))) then
					v109 = v108;
					if ((v109 == (23607 - 12496)) or ((3273 - 1630) > (3988 - (295 + 314)))) then
						v109 = v10.FightRemains(v103, false);
					end
					break;
				end
				if ((v145 == (0 - 0)) or ((4765 - (1300 + 662)) > (14284 - 9735))) then
					if (v13:AffectingCombat() or v72 or ((1975 - (1178 + 577)) >= (1570 + 1452))) then
						local v206 = 0 - 0;
						local v207;
						while true do
							if (((4227 - (851 + 554)) == (2496 + 326)) and (v206 == (0 - 0))) then
								v207 = v72 and v94.RemoveCurse:IsReady() and v32;
								v27 = v98.FocusUnit(v207, nil, 43 - 23, nil, 322 - (115 + 187), v94.ArcaneIntellect);
								v206 = 1 + 0;
							end
							if ((v206 == (1 + 0)) or ((4181 - 3120) == (3018 - (160 + 1001)))) then
								if (((2415 + 345) > (942 + 422)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
					v108 = v10.BossFightRemains(nil, true);
					v145 = 1 - 0;
				end
			end
		end
		v110 = v13:GCD();
		if (v73 or ((5260 - (237 + 121)) <= (4492 - (525 + 372)))) then
			if (v93 or ((7302 - 3450) == (962 - 669))) then
				local v197 = 142 - (96 + 46);
				while true do
					if ((v197 == (777 - (643 + 134))) or ((563 + 996) == (11000 - 6412))) then
						v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 111 - 81);
						if (v27 or ((4301 + 183) == (1546 - 758))) then
							return v27;
						end
						break;
					end
				end
			end
		end
		if (((9337 - 4769) >= (4626 - (316 + 403))) and (not v13:AffectingCombat() or v28)) then
			local v146 = 0 + 0;
			while true do
				if (((3425 - 2179) < (1255 + 2215)) and (v146 == (0 - 0))) then
					if (((2883 + 1185) >= (314 + 658)) and v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) then
						if (((1708 - 1215) < (18592 - 14699)) and v21(v94.ArcaneIntellect)) then
							return "arcane_intellect group_buff";
						end
					end
					if ((v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) or ((3059 - 1586) >= (191 + 3141))) then
						if (v21(v94.ArcaneFamiliar) or ((7974 - 3923) <= (57 + 1100))) then
							return "arcane_familiar precombat 2";
						end
					end
					v146 = 2 - 1;
				end
				if (((621 - (12 + 5)) < (11189 - 8308)) and (v146 == (1 - 0))) then
					if ((v94.ConjureManaGem:IsCastable() and v39) or ((1913 - 1013) == (8374 - 4997))) then
						if (((905 + 3554) > (2564 - (1656 + 317))) and v21(v94.ConjureManaGem)) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
			end
		end
		if (((3028 + 370) >= (1920 + 475)) and v98.TargetIsValid()) then
			if ((v72 and v32 and v94.RemoveCurse:IsAvailable()) or ((5804 - 3621) >= (13898 - 11074))) then
				local v198 = 354 - (5 + 349);
				while true do
					if (((9195 - 7259) == (3207 - (266 + 1005))) and (v198 == (0 + 0))) then
						if (v15 or ((16487 - 11655) < (5677 - 1364))) then
							local v209 = 1696 - (561 + 1135);
							while true do
								if (((5326 - 1238) > (12734 - 8860)) and (v209 == (1066 - (507 + 559)))) then
									v27 = v113();
									if (((10870 - 6538) == (13397 - 9065)) and v27) then
										return v27;
									end
									break;
								end
							end
						end
						if (((4387 - (212 + 176)) >= (3805 - (250 + 655))) and v16 and v16:Exists() and not v13:CanAttack(v16) and v98.UnitHasCurseDebuff(v16)) then
							if (v94.RemoveCurse:IsReady() or ((6885 - 4360) > (7100 - 3036))) then
								if (((6838 - 2467) == (6327 - (1869 + 87))) and v21(v96.RemoveCurseMouseover)) then
									return "remove_curse dispel";
								end
							end
						end
						break;
					end
				end
			end
			if ((not v13:AffectingCombat() and v28) or ((922 - 656) > (6887 - (484 + 1417)))) then
				v27 = v115();
				if (((4267 - 2276) >= (1549 - 624)) and v27) then
					return v27;
				end
			end
			v27 = v111();
			if (((1228 - (48 + 725)) < (3353 - 1300)) and v27) then
				return v27;
			end
			if (v73 or ((2215 - 1389) == (2820 + 2031))) then
				if (((488 - 305) == (52 + 131)) and v93) then
					local v203 = 0 + 0;
					while true do
						if (((2012 - (152 + 701)) <= (3099 - (430 + 881))) and (v203 == (0 + 0))) then
							v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 925 - (557 + 338));
							if (v27 or ((1037 + 2470) > (12168 - 7850))) then
								return v27;
							end
							break;
						end
					end
				end
			end
			if (v74 or ((10767 - 7692) <= (7877 - 4912))) then
				local v199 = 0 - 0;
				while true do
					if (((2166 - (499 + 302)) <= (2877 - (39 + 827))) and (v199 == (0 - 0))) then
						v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 67 - 37);
						if (v27 or ((11025 - 8249) > (5488 - 1913))) then
							return v27;
						end
						break;
					end
				end
			end
			if ((v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) or ((219 + 2335) == (14060 - 9256))) then
				if (((413 + 2164) == (4077 - 1500)) and v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if ((not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) or ((110 - (103 + 1)) >= (2443 - (475 + 79)))) then
				if (((1093 - 587) <= (6054 - 4162)) and v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) then
					if (v21(v96.UseWeapon, nil) or ((260 + 1748) > (1953 + 265))) then
						return "Using Weapon Macro";
					end
				end
				local v200 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
				if (((1882 - (1395 + 108)) <= (12067 - 7920)) and v200) then
					return v200;
				end
				if ((v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes) and not v13:PrevOffGCDP(1205 - (7 + 1197), v94.IceFloes)) or ((1969 + 2545) <= (353 + 656))) then
					if (v21(v94.IceFloes) or ((3815 - (27 + 292)) == (3492 - 2300))) then
						return "ice_floes movement";
					end
				end
				if ((v90 and v94.TimeWarp:IsReady() and v13:BloodlustDown() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v109 <= (51 - 11)) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v109 <= (v94.ArcaneSurge:CooldownRemains() + (58 - 44)))))) or ((409 - 201) == (5634 - 2675))) then
					if (((4416 - (43 + 96)) >= (5355 - 4042)) and v21(v94.TimeWarp, not v14:IsInRange(90 - 50))) then
						return "time_warp main 4";
					end
				end
				if (((2147 + 440) < (897 + 2277)) and v80 and ((v83 and v30) or not v83) and (v78 < v109)) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (0 + 0)) or ((7721 - 3601) <= (692 + 1506))) then
							if ((v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (1 + 1)) or (v102 >= (1753 - (1414 + 337))))) or ((3536 - (1642 + 298)) == (2236 - 1378))) then
								if (((9263 - 6043) == (9555 - 6335)) and v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment))) then
									return "lights_judgment main 6";
								end
							end
							if ((v94.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) or ((1091 + 311) > (4592 - (357 + 615)))) then
								if (((1807 + 767) == (6315 - 3741)) and v21(v94.Berserking)) then
									return "berserking main 8";
								end
							end
							v204 = 1 + 0;
						end
						if (((3852 - 2054) < (2206 + 551)) and (v204 == (1 + 0))) then
							if (v13:PrevGCDP(1 + 0, v94.ArcaneSurge) or ((1678 - (384 + 917)) > (3301 - (128 + 569)))) then
								local v210 = 1543 - (1407 + 136);
								while true do
									if (((2455 - (687 + 1200)) < (2621 - (556 + 1154))) and (v210 == (3 - 2))) then
										if (((3380 - (9 + 86)) < (4649 - (275 + 146))) and v94.AncestralCall:IsCastable()) then
											if (((637 + 3279) > (3392 - (29 + 35))) and v21(v94.AncestralCall)) then
												return "ancestral_call main 14";
											end
										end
										break;
									end
									if (((11079 - 8579) < (11466 - 7627)) and (v210 == (0 - 0))) then
										if (((331 + 176) == (1519 - (53 + 959))) and v94.BloodFury:IsCastable()) then
											if (((648 - (312 + 96)) <= (5493 - 2328)) and v21(v94.BloodFury)) then
												return "blood_fury main 10";
											end
										end
										if (((1119 - (147 + 138)) >= (1704 - (813 + 86))) and v94.Fireblood:IsCastable()) then
											if (v21(v94.Fireblood) or ((3445 + 367) < (4290 - 1974))) then
												return "fireblood main 12";
											end
										end
										v210 = 493 - (18 + 474);
									end
								end
							end
							break;
						end
					end
				end
				if ((v78 < v109) or ((895 + 1757) <= (5003 - 3470))) then
					if ((v81 and ((v30 and v82) or not v82)) or ((4684 - (860 + 226)) < (1763 - (121 + 182)))) then
						local v208 = 0 + 0;
						while true do
							if ((v208 == (1240 - (988 + 252))) or ((465 + 3651) < (374 + 818))) then
								v27 = v114();
								if (v27 or ((5347 - (49 + 1921)) <= (1793 - (223 + 667)))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				v27 = v116();
				if (((4028 - (51 + 1)) >= (755 - 316)) and v27) then
					return v27;
				end
				v27 = v121();
				if (((8033 - 4281) == (4877 - (146 + 979))) and v27) then
					return v27;
				end
			end
		end
	end
	local function v125()
		local v139 = 0 + 0;
		while true do
			if (((4651 - (311 + 294)) > (7515 - 4820)) and (v139 == (0 + 0))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(1505 - (496 + 947), v124, v125);
end;
return v0["Epix_Mage_Arcane.lua"]();

