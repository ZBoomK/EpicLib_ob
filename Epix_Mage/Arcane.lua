local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((7887 - 5233) < (3351 - 1317))) then
			return v6(...);
		end
		if (((664 + 257) < (1944 - (497 + 345))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((796 + 3910) >= (2296 - (605 + 728))) and not v6) then
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
		if (v94.RemoveCurse:IsAvailable() or ((2134 - 1174) <= (41 + 835))) then
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
	if (not v94.ArcingCleave:IsAvailable() or ((7638 - 5572) == (841 + 91))) then
		v104 = 24 - 15;
	elseif (((3644 + 1181) < (5332 - (457 + 32))) and v94.ArcingCleave:IsAvailable() and (not v94.OrbBarrage:IsAvailable() or not v94.ArcaneBombardment:IsAvailable())) then
		v104 = 3 + 2;
	else
		v104 = 1405 - (832 + 570);
	end
	local v105 = false;
	local v106 = true;
	local v107 = false;
	local v108 = 10468 + 643;
	local v109 = 2898 + 8213;
	local v110;
	v10:RegisterForEvent(function()
		v106 = true;
		v108 = 39319 - 28208;
		v109 = 5353 + 5758;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		if (not v94.ArcingCleave:IsAvailable() or ((4673 - (588 + 208)) >= (12228 - 7691))) then
			v104 = 1809 - (884 + 916);
		elseif ((v94.ArcingCleave:IsAvailable() and (not v94.OrbBarrage:IsAvailable() or not v94.ArcaneBombardment:IsAvailable())) or ((9033 - 4718) < (1001 + 725))) then
			v104 = 658 - (232 + 421);
		else
			v104 = 1892 - (1569 + 320);
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v111()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (1 + 2)) or ((12397 - 8718) < (1230 - (316 + 289)))) then
				if ((v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((12106 - 7481) < (30 + 602))) then
					if (v21(v94.AlterTime) or ((1536 - (666 + 787)) > (2205 - (360 + 65)))) then
						return "alter_time defensive 6";
					end
				end
				if (((511 + 35) <= (1331 - (79 + 175))) and v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) then
					if (v21(v96.Healthstone) or ((1570 - 574) > (3357 + 944))) then
						return "healthstone defensive";
					end
				end
				v126 = 12 - 8;
			end
			if (((7838 - 3768) > (1586 - (503 + 396))) and (v126 == (183 - (92 + 89)))) then
				if ((v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((1271 - 615) >= (1708 + 1622))) then
					if (v21(v94.MirrorImage) or ((1475 + 1017) <= (1311 - 976))) then
						return "mirror_image defensive 4";
					end
				end
				if (((592 + 3730) >= (5841 - 3279)) and v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) then
					if (v21(v94.GreaterInvisibility) or ((3174 + 463) >= (1801 + 1969))) then
						return "greater_invisibility defensive 5";
					end
				end
				v126 = 8 - 5;
			end
			if ((v126 == (1 + 0)) or ((3627 - 1248) > (5822 - (485 + 759)))) then
				if ((v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) or ((1117 - 634) > (1932 - (442 + 747)))) then
					if (((3589 - (832 + 303)) > (1524 - (88 + 858))) and v21(v94.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((284 + 646) < (3690 + 768)) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (((28 + 634) <= (1761 - (766 + 23))) and v21(v94.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v126 = 9 - 7;
			end
			if (((5976 - 1606) == (11513 - 7143)) and (v126 == (0 - 0))) then
				if ((v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((5835 - (1036 + 37)) <= (611 + 250))) then
					if (v21(v94.PrismaticBarrier) or ((2749 - 1337) == (3355 + 909))) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 1482 - (641 + 839), v94.ArcaneIntellect)) or ((4081 - (910 + 3)) < (5488 - 3335))) then
					if (v21(v94.MassBarrier) or ((6660 - (1466 + 218)) < (613 + 719))) then
						return "mass_barrier defensive 2";
					end
				end
				v126 = 1149 - (556 + 592);
			end
			if (((1646 + 2982) == (5436 - (329 + 479))) and (v126 == (858 - (174 + 680)))) then
				if ((v84 and (v13:HealthPercentage() <= v86)) or ((185 - 131) == (818 - 423))) then
					local v197 = 0 + 0;
					while true do
						if (((821 - (396 + 343)) == (8 + 74)) and (v197 == (1477 - (29 + 1448)))) then
							if ((v88 == "Refreshing Healing Potion") or ((1970 - (135 + 1254)) < (1062 - 780))) then
								if (v95.RefreshingHealingPotion:IsReady() or ((21519 - 16910) < (1663 + 832))) then
									if (((2679 - (389 + 1138)) == (1726 - (102 + 472))) and v21(v96.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((1790 + 106) <= (1898 + 1524)) and (v88 == "Dreamwalker's Healing Potion")) then
								if (v95.DreamwalkersHealingPotion:IsReady() or ((924 + 66) > (3165 - (320 + 1225)))) then
									if (v21(v96.RefreshingHealingPotion) or ((1560 - 683) > (2873 + 1822))) then
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
	local v112 = 1464 - (157 + 1307);
	local function v113()
		if (((4550 - (821 + 1038)) >= (4618 - 2767)) and v94.RemoveCurse:IsReady() and (v98.UnitHasDispellableDebuffByPlayer(v15) or v98.DispellableFriendlyUnit(3 + 22) or v98.UnitHasCurseDebuff(v15))) then
			local v141 = 0 - 0;
			while true do
				if ((v141 == (0 + 0)) or ((7398 - 4413) >= (5882 - (834 + 192)))) then
					if (((272 + 4004) >= (307 + 888)) and (v112 == (0 + 0))) then
						v112 = GetTime();
					end
					if (((5006 - 1774) <= (4994 - (300 + 4))) and v98.Wait(134 + 366, v112)) then
						local v201 = 0 - 0;
						while true do
							if ((v201 == (362 - (112 + 250))) or ((358 + 538) >= (7881 - 4735))) then
								if (((1754 + 1307) >= (1530 + 1428)) and v21(v96.RemoveCurseFocus)) then
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
		local v127 = 0 + 0;
		while true do
			if (((2368 + 819) >= (2058 - (1001 + 413))) and (v127 == (0 - 0))) then
				v27 = v98.HandleTopTrinket(v97, v30, 922 - (244 + 638), nil);
				if (((1337 - (627 + 66)) <= (2097 - 1393)) and v27) then
					return v27;
				end
				v127 = 603 - (512 + 90);
			end
			if (((2864 - (1665 + 241)) > (1664 - (373 + 344))) and ((1 + 0) == v127)) then
				v27 = v98.HandleBottomTrinket(v97, v30, 11 + 29, nil);
				if (((11848 - 7356) >= (4491 - 1837)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v115()
		local v128 = 1099 - (35 + 1064);
		while true do
			if (((2505 + 937) >= (3215 - 1712)) and ((1 + 1) == v128)) then
				if ((v94.ArcaneBlast:IsReady() and v33) or ((4406 - (298 + 938)) <= (2723 - (233 + 1026)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((6463 - (636 + 1030)) == (2244 + 2144))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if (((539 + 12) <= (203 + 478)) and (v128 == (0 + 0))) then
				if (((3498 - (55 + 166)) > (79 + 328)) and v94.MirrorImage:IsCastable() and v91 and v63) then
					if (((473 + 4222) >= (5403 - 3988)) and v21(v94.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) or ((3509 - (36 + 261)) <= (1650 - 706))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((4464 - (34 + 1334)) <= (692 + 1106))) then
						return "arcane_blast precombat 4";
					end
				end
				v128 = 1 + 0;
			end
			if (((4820 - (1035 + 248)) == (3558 - (20 + 1))) and (v128 == (1 + 0))) then
				if (((4156 - (134 + 185)) >= (2703 - (549 + 584))) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
					if (v21(v94.Evocation) or ((3635 - (314 + 371)) == (13086 - 9274))) then
						return "evocation precombat 6";
					end
				end
				if (((5691 - (478 + 490)) >= (1228 + 1090)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(1212 - (786 + 386))) or ((6565 - 4538) > (4231 - (1055 + 324)))) then
						return "arcane_orb precombat 8";
					end
				end
				v128 = 1342 - (1093 + 247);
			end
		end
	end
	local function v116()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (0 + 0)) or ((4510 - 3374) > (14650 - 10333))) then
				if (((13510 - 8762) == (11931 - 7183)) and (v101 >= v104) and ((v94.ArcaneOrb:Charges() > (0 + 0)) or (v13:ArcaneCharges() >= (11 - 8))) and (v94.RadiantSpark:CooldownUp() or not v94.RadiantSpark:IsAvailable()) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (6 - 4))) or not v94.TouchoftheMagi:IsAvailable())) then
					v105 = true;
				end
				if (((2818 + 918) <= (12122 - 7382)) and v105 and ((v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (695 - (364 + 324))) and v94.RadiantSpark:CooldownDown()) or (not v94.RadiantSpark:IsAvailable() and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) then
					v105 = false;
				end
				v129 = 2 - 1;
			end
			if ((v129 == (2 - 1)) or ((1124 + 2266) <= (12804 - 9744))) then
				if ((v14:DebuffUp(v94.TouchoftheMagiDebuff) and v106) or ((1599 - 600) > (8178 - 5485))) then
					v106 = false;
				end
				v107 = v94.ArcaneBlast:CastTime() < v110;
				break;
			end
		end
	end
	local function v117()
		local v130 = 1268 - (1249 + 19);
		while true do
			if (((418 + 45) < (2339 - 1738)) and (v130 == (1086 - (686 + 400)))) then
				if ((v94.TouchoftheMagi:IsReady() and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage)) and v51 and ((v56 and v31) or not v56) and (v78 < v109)) or ((2412 - (73 + 156)) < (4 + 683))) then
					if (((5360 - (721 + 90)) == (52 + 4497)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi aoe_cooldown_phase 2";
					end
				end
				if (((15169 - 10497) == (5142 - (224 + 246))) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v109)) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((5941 - 2273) < (727 - 332))) then
						return "radiant_spark aoe_cooldown_phase 4";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (1 + 2)) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) or ((100 + 4066) == (335 + 120))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(79 - 39)) or ((14805 - 10356) == (3176 - (203 + 310)))) then
						return "arcane_orb aoe_cooldown_phase 6";
					end
				end
				if ((v94.NetherTempest:IsReady() and v94.ArcaneEcho:IsAvailable() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and v42) or ((6270 - (1238 + 755)) < (209 + 2780))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((2404 - (709 + 825)) >= (7645 - 3496))) then
						return "nether_tempest aoe_cooldown_phase 8";
					end
				end
				v130 = 1 - 0;
			end
			if (((3076 - (196 + 668)) < (12567 - 9384)) and (v130 == (1 - 0))) then
				if (((5479 - (171 + 662)) > (3085 - (4 + 89))) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v109)) then
					if (((5026 - 3592) < (1131 + 1975)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
						return "arcane_surge aoe_cooldown_phase 10";
					end
				end
				if (((3452 - 2666) < (1186 + 1837)) and v94.ArcaneBarrage:IsReady() and (v94.ArcaneSurge:CooldownRemains() < (1561 - (35 + 1451))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1457 - (28 + 1425))) and not v94.OrbBarrage:IsAvailable() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((4435 - (941 + 1052)) < (71 + 3))) then
						return "arcane_barrage aoe_cooldown_phase 12";
					end
				end
				if (((6049 - (822 + 692)) == (6474 - 1939)) and v94.ArcaneBarrage:IsReady() and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 1)) and (v94.ArcaneSurge:CooldownRemains() > (372 - (45 + 252)))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) and (v94.ArcaneSurge:CooldownRemains() < (26 + 49)) and not v94.OrbBarrage:IsAvailable())) and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((7322 - 4313) <= (2538 - (114 + 319)))) then
						return "arcane_barrage aoe_cooldown_phase 14";
					end
				end
				if (((2627 - 797) < (4700 - 1031)) and v94.ArcaneBarrage:IsReady() and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 0)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 - 0)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 2)) and (v101 > (1968 - (556 + 1407)))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1210 - (741 + 465)))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((1895 - (170 + 295)) >= (1904 + 1708))) then
						return "arcane_barrage aoe_cooldown_phase 16";
					end
				end
				v130 = 2 + 0;
			end
			if (((6605 - 3922) >= (2040 + 420)) and ((2 + 0) == v130)) then
				if ((v94.PresenceofMind:IsCastable() and v43) or ((1022 + 782) >= (4505 - (957 + 273)))) then
					if (v21(v94.PresenceofMind) or ((379 + 1038) > (1453 + 2176))) then
						return "presence_of_mind aoe_cooldown_phase 18";
					end
				end
				if (((18271 - 13476) > (1059 - 657)) and v94.ArcaneBlast:IsReady() and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 3)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (14 - 11))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable())) and v33) then
					if (((6593 - (389 + 1391)) > (2237 + 1328)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast aoe_cooldown_phase 20";
					end
				end
				if (((408 + 3504) == (8905 - 4993)) and v94.ArcaneBarrage:IsReady() and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (955 - (783 + 168))) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (9 - 6)) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) then
					if (((2775 + 46) <= (5135 - (309 + 2))) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
						return "arcane_barrage aoe_cooldown_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v131 = 0 - 0;
		while true do
			if (((2950 - (1090 + 122)) <= (712 + 1483)) and (v131 == (3 - 2))) then
				if (((29 + 12) <= (4136 - (628 + 490))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and ((v94.TouchoftheMagi:CooldownRemains() + 1 + 4) > v13:BuffRemains(v94.ArcaneArtilleryBuff))) then
					if (((5310 - 3165) <= (18755 - 14651)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if (((3463 - (431 + 343)) < (9785 - 4940)) and v94.ArcaneBarrage:IsReady() and v34 and (((v101 <= (11 - 7)) and (v13:ArcaneCharges() == (3 + 0))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (2 + 7)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((4017 - (556 + 1139)) > (2637 - (6 + 9)))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v131 = 1 + 1;
			end
			if (((2 + 0) == v131) or ((4703 - (28 + 141)) == (807 + 1275))) then
				if ((v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (2 - 0)) and (v94.TouchoftheMagi:CooldownRemains() > (13 + 5)) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) or ((2888 - (486 + 831)) > (4858 - 2991))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(140 - 100)) or ((502 + 2152) >= (9473 - 6477))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((5241 - (668 + 595)) > (1894 + 210)) and v94.ArcaneExplosion:IsReady() and v14:IsInRange(3 + 7)) then
					if (((8167 - 5172) > (1831 - (23 + 267))) and v21(v94.ArcaneExplosion, not v14:IsInRange(1954 - (1129 + 815)))) then
						return "arcane_explosion aoe_rotation 12";
					end
				end
				break;
			end
			if (((3636 - (371 + 16)) > (2703 - (1326 + 424))) and (v131 == (0 - 0))) then
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v109) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (43 - 31))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (130 - (88 + 30)))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (783 - (720 + 51)))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (26 - 14))) or (v94.ArcaneOrb:Charges() == (1776 - (421 + 1355))) or (v94.ArcaneOrb:CooldownRemains() > (19 - 7))) and v14:DebuffDown(v94.TouchoftheMagiDebuff)) or ((1608 + 1665) > (5656 - (286 + 797)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(65 - 47)) or ((5218 - 2067) < (1723 - (397 + 42)))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v94.NetherTempest:IsReady() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (2 + 4)) or not v94.OrbBarrage:IsAvailable()) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v42) or ((2650 - (24 + 776)) == (2355 - 826))) then
					if (((1606 - (222 + 563)) < (4677 - 2554)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v119()
		local v132 = 190 - (23 + 167);
		while true do
			if (((2700 - (690 + 1108)) < (839 + 1486)) and (v132 == (0 + 0))) then
				if (((1706 - (40 + 808)) <= (488 + 2474)) and v94.TouchoftheMagi:IsReady() and (v13:PrevGCDP(3 - 2, v94.ArcaneBarrage)) and v51 and ((v56 and v31) or not v56) and (v78 < v109)) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((3772 + 174) < (682 + 606))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v109) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) or ((1778 + 1464) == (1138 - (47 + 524)))) then
					if (v21(v94.ShiftingPower, not v14:IsInRange(12 + 6)) or ((2315 - 1468) >= (1888 - 625))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and (v94.RadiantSpark:CooldownUp() or ((v101 >= (4 - 2)) and v14:DebuffDown(v94.RadiantSparkVulnerability))) and (v13:ArcaneCharges() < v13:ArcaneChargesMax()) and v49 and ((v54 and v31) or not v54) and (v78 < v109)) or ((3979 - (1165 + 561)) == (55 + 1796))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(123 - 83)) or ((797 + 1290) > (2851 - (341 + 138)))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v106 and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (2 + 3)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v110 * (12 - 6)))) and v38) or ((4771 - (89 + 237)) < (13347 - 9198))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3827 - 2009) == (966 - (581 + 300)))) then
						return "arcane_missiles cooldown_phase 8";
					end
				end
				v132 = 1221 - (855 + 365);
			end
			if (((1496 - 866) < (695 + 1432)) and (v132 == (1237 - (1030 + 205)))) then
				if ((v94.NetherTempest:IsReady() and (v94.NetherTempest:TimeSinceLastCast() >= (29 + 1)) and (v94.ArcaneEcho:IsAvailable()) and v42) or ((1803 + 135) == (2800 - (156 + 130)))) then
					if (((9668 - 5413) >= (92 - 37)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest cooldown_phase 18";
					end
				end
				if (((6141 - 3142) > (305 + 851)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v109)) then
					if (((1371 + 979) > (1224 - (10 + 59))) and v21(v94.ArcaneSurge)) then
						return "arcane_surge cooldown_phase 20";
					end
				end
				if (((1140 + 2889) <= (23899 - 19046)) and v94.ArcaneBarrage:IsReady() and (v13:PrevGCDP(1164 - (671 + 492), v94.ArcaneSurge) or v13:PrevGCDP(1 + 0, v94.NetherTempest) or v13:PrevGCDP(1216 - (369 + 846), v94.RadiantSpark) or ((v101 >= ((2 + 2) - ((2 + 0) * v24(v94.OrbBarrage:IsAvailable())))) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1949 - (1036 + 909))) and v94.ArcingCleave:IsAvailable())) and v34) then
					if (v21(v94.ArcaneBarrage, v14:IsSpellInRange(v94.ArcaneBarrage)) or ((411 + 105) > (5764 - 2330))) then
						return "arcane_barrage cooldown_phase 22";
					end
				end
				if (((4249 - (11 + 192)) >= (1533 + 1500)) and v94.ArcaneBlast:IsReady() and v14:DebuffUp(v94.RadiantSparkVulnerability) and ((v14:DebuffStack(v94.RadiantSparkVulnerability) < (179 - (135 + 40))) or (v107 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (9 - 5)))) and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1639 + 1080) <= (3187 - 1740))) then
						return "arcane_blast cooldown_phase 24";
					end
				end
				v132 = 4 - 1;
			end
			if ((v132 == (177 - (50 + 126))) or ((11511 - 7377) < (869 + 3057))) then
				if ((v94.ArcaneBlast:IsReady() and v106 and v94.ArcaneSurge:CooldownUp() and (v13:ManaPercentage() > (1423 - (1233 + 180))) and (v13:BuffRemains(v94.SiphonStormBuff) > (986 - (522 + 447))) and not v13:HasTier(1451 - (107 + 1314), 2 + 2) and v33) or ((499 - 335) >= (1183 + 1602))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1042 - 517) == (8344 - 6235))) then
						return "arcane_blast cooldown_phase 10";
					end
				end
				if (((1943 - (716 + 1194)) == (1 + 32)) and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and (v13:ManaPercentage() > (533 - (74 + 429))) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) then
					if (((5890 - 2836) <= (1990 + 2025)) and v21(v96.StopCasting)) then
						return "arcane_missiles interrupt cooldown_phase 12";
					end
				end
				if (((4282 - 2411) < (2393 + 989)) and v94.ArcaneMissiles:IsReady() and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < (v110 * (8 - 5)))) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v110 * (14 - 8)))) and v38) then
					if (((1726 - (279 + 154)) <= (2944 - (454 + 324))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v109)) or ((2030 + 549) < (140 - (12 + 5)))) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((457 + 389) >= (6033 - 3665))) then
						return "radiant_spark cooldown_phase 16";
					end
				end
				v132 = 1 + 1;
			end
			if ((v132 == (1096 - (277 + 816))) or ((17143 - 13131) <= (4541 - (1058 + 125)))) then
				if (((281 + 1213) <= (3980 - (815 + 160))) and v94.PresenceofMind:IsCastable() and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v110) and v43) then
					if (v20(v94.PresenceofMind) or ((13348 - 10237) == (5065 - 2931))) then
						return "presence_of_mind cooldown_phase 26";
					end
				end
				if (((562 + 1793) == (6884 - 4529)) and v94.ArcaneBlast:IsReady() and (v13:BuffUp(v94.PresenceofMindBuff)) and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((2486 - (41 + 1857)) <= (2325 - (1222 + 671)))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if (((12398 - 7601) >= (5598 - 1703)) and v94.ArcaneMissiles:IsReady() and ((v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff)) or ((v13:BuffStack(v94.ClearcastingBuff) > (1184 - (229 + 953))) and v14:DebuffUp(v94.TouchoftheMagiDebuff))) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1778 - (1111 + 663))) and v13:PrevGCDP(1580 - (874 + 705), v94.ArcaneBlast))) and v38) then
					if (((501 + 3076) == (2441 + 1136)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 30";
					end
				end
				if (((7885 - 4091) > (104 + 3589)) and v94.ArcaneBlast:IsReady() and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1954 - (642 + 37)) == (935 + 3165))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				break;
			end
		end
	end
	local function v120()
		if ((v94.ArcaneOrb:IsReady() and (v13:ArcaneCharges() < (1 + 2)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (175 - 105))) and v49 and ((v54 and v31) or not v54)) or ((2045 - (233 + 221)) >= (8278 - 4698))) then
			if (((866 + 117) <= (3349 - (718 + 823))) and v21(v94.ArcaneOrb, not v14:IsInRange(26 + 14))) then
				return "arcane_orb rotation 2";
			end
		end
		if ((v94.ShiftingPower:IsReady() and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (850 - (266 + 539))) and (v109 > (42 - 27)) and v48 and ((v30 and v53) or not v53) and (v78 < v109)) or ((3375 - (636 + 589)) <= (2841 - 1644))) then
			if (((7773 - 4004) >= (930 + 243)) and v21(v94.ShiftingPower, not v14:IsInRange(7 + 11))) then
				return "shifting_power rotation 4";
			end
		end
		if (((2500 - (657 + 358)) == (3931 - 2446)) and v94.NetherTempest:IsReady() and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (22 - 12)) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v106 and (v109 >= (1199 - (1151 + 36))) and v42) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((3202 + 113) <= (732 + 2050))) then
				return "nether_tempest rotation 8";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (209 - 139)) and (((v94.ArcaneSurge:CooldownRemains() > (1862 - (1552 + 280))) and (v94.TouchoftheMagi:CooldownRemains() > (844 - (64 + 770))) and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (4 + 1)) and (v109 > (68 - 38))) or (not v94.Evocation:IsAvailable() and (v109 > (4 + 16)))) and v34) or ((2119 - (157 + 1086)) >= (5932 - 2968))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((9775 - 7543) > (3830 - 1333))) then
				return "arcane_barrage rotation 10";
			end
		end
		if ((v94.PresenceofMind:IsCastable() and (v13:ArcaneCharges() < (3 - 0)) and (v14:HealthPercentage() < (854 - (599 + 220))) and v94.ArcaneBombardment:IsAvailable() and v43) or ((4201 - 2091) <= (2263 - (1813 + 118)))) then
			if (((2695 + 991) > (4389 - (841 + 376))) and v21(v94.PresenceofMind)) then
				return "presence_of_mind rotation 12";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and (((v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) or (v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (7 - 1)))) and v33) or ((1040 + 3434) < (2238 - 1418))) then
			if (((5138 - (464 + 395)) >= (7396 - 4514)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast rotation 14";
			end
		end
		if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (v13:ManaPercentage() > (867 - (467 + 370))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((4192 - 2163) >= (2585 + 936))) then
			if (v21(v96.StopCasting) or ((6982 - 4945) >= (725 + 3917))) then
				return "arcane_missiles interrupt rotation 16";
			end
		end
		if (((4001 - 2281) < (4978 - (150 + 370))) and v94.ArcaneMissiles:IsCastable() and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and not v106 and v38) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1718 - (74 + 1208)) > (7430 - 4409))) then
				return "arcane_missiles rotation 18";
			end
		end
		if (((3381 - 2668) <= (603 + 244)) and v94.ArcaneBlast:IsReady() and v33) then
			if (((2544 - (14 + 376)) <= (6991 - 2960)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast rotation 20";
			end
		end
		if (((2987 + 1628) == (4055 + 560)) and v94.ArcaneBarrage:IsReady() and v34) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage)) or ((3615 + 175) == (1465 - 965))) then
				return "arcane_barrage rotation 22";
			end
		end
	end
	local function v121()
		local v133 = 0 + 0;
		while true do
			if (((167 - (23 + 55)) < (523 - 302)) and (v133 == (2 + 0))) then
				if (((1845 + 209) >= (2203 - 782)) and v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and (v13:PrevGCDP(1 + 0, v94.ArcaneSurge))) then
					if (((1593 - (652 + 249)) < (8183 - 5125)) and v21(v96.ManaGem)) then
						return "mana_gem main 42";
					end
				end
				if ((((v94.ArcaneSurge:CooldownRemains() <= (v110 * ((1869 - (708 + 1160)) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((8 - 5) * v24(v13:HasTier(54 - 24, 29 - (10 + 17)) and not v13:HasTier(7 + 23, 1736 - (1400 + 332))))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (86 - 41)) and ((v94.TouchoftheMagi:CooldownRemains() < (v110 * (1912 - (242 + 1666)))) or (v94.TouchoftheMagi:CooldownRemains() > (9 + 11))) and (v101 < v104)) or ((1193 + 2061) == (1411 + 244))) then
					v27 = v119();
					if (v27 or ((2236 - (850 + 90)) == (8599 - 3689))) then
						return v27;
					end
				end
				if (((4758 - (360 + 1030)) == (2981 + 387)) and (v94.ArcaneSurge:CooldownRemains() > (84 - 54)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (3 - 0))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and (v101 < v104)) then
					local v198 = 1661 - (909 + 752);
					while true do
						if (((3866 - (109 + 1114)) < (6984 - 3169)) and (v198 == (0 + 0))) then
							v27 = v119();
							if (((2155 - (6 + 236)) > (311 + 182)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				v133 = 3 + 0;
			end
			if (((11214 - 6459) > (5987 - 2559)) and (v133 == (1136 - (1076 + 57)))) then
				if (((228 + 1153) <= (3058 - (579 + 110))) and (v94.ArcaneSurge:CooldownRemains() > (3 + 27)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v110 * (3 + 0))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and (v101 < v104)) then
					v27 = v119();
					if (v27 or ((2571 + 2272) == (4491 - (174 + 233)))) then
						return v27;
					end
				end
				if (((13041 - 8372) > (636 - 273)) and v105 and ((v94.ArcaneSurge:CooldownRemains() < (v110 * (2 + 2))) or (v94.ArcaneSurge:CooldownRemains() > (1214 - (663 + 511))))) then
					v27 = v117();
					if (v27 or ((1675 + 202) >= (682 + 2456))) then
						return v27;
					end
				end
				if (((14619 - 9877) >= (2196 + 1430)) and (v101 >= v104)) then
					local v199 = 0 - 0;
					while true do
						if ((v199 == (0 - 0)) or ((2167 + 2373) == (1782 - 866))) then
							v27 = v118();
							if (v27 or ((824 + 332) > (398 + 3947))) then
								return v27;
							end
							break;
						end
					end
				end
				v133 = 726 - (478 + 244);
			end
			if (((2754 - (440 + 77)) < (1932 + 2317)) and (v133 == (0 - 0))) then
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v109) and (v13:PrevGCDP(1557 - (655 + 901), v94.ArcaneBarrage))) or ((498 + 2185) < (18 + 5))) then
					if (((471 + 226) <= (3327 - 2501)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((2550 - (695 + 750)) <= (4015 - 2839)) and v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (146 - 51)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v109 * (15 - 11))) and not ((v109 > (361 - (285 + 66))) and (v94.ArcaneSurge:CooldownRemains() < (2 - 1)))))) then
					if (((4689 - (682 + 628)) <= (615 + 3197)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v109 < (301 - (176 + 123)))) or ((330 + 458) >= (1173 + 443))) then
					if (((2123 - (239 + 30)) <= (919 + 2460)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage main 34";
					end
				end
				v133 = 1 + 0;
			end
			if (((8050 - 3501) == (14192 - 9643)) and (v133 == (319 - (306 + 9)))) then
				v27 = v120();
				if (v27 or ((10545 - 7523) >= (526 + 2498))) then
					return v27;
				end
				break;
			end
			if (((2958 + 1862) > (1058 + 1140)) and (v133 == (2 - 1))) then
				if ((v94.Evocation:IsCastable() and v40 and not v106 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (1385 - (1140 + 235))) and (v94.TouchoftheMagi:CooldownRemains() < (13 + 7))) or (v94.TouchoftheMagi:CooldownRemains() < (14 + 1))) and (((v13:BloodlustRemains() < (8 + 23)) and v13:BloodlustUp()) or not v106)) or ((1113 - (33 + 19)) >= (1766 + 3125))) then
					if (((4088 - 2724) <= (1971 + 2502)) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				if ((v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (58 - 28)) and (v94.ArcaneSurge:CooldownRemains() < v109) and not v95.ManaGem:Exists()) or ((3371 + 224) <= (692 - (586 + 103)))) then
					if (v21(v94.ConjureManaGem) or ((426 + 4246) == (11858 - 8006))) then
						return "conjure_mana_gem main 38";
					end
				end
				if (((3047 - (1309 + 179)) == (2813 - 1254)) and v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (1 + 1)) and v13:BuffUp(v94.ArcaneSurgeBuff)) then
					if (v21(v96.ManaGem) or ((4705 - 2953) <= (596 + 192))) then
						return "mana_gem main 40";
					end
				end
				v133 = 3 - 1;
			end
		end
	end
	local function v122()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (609 - (295 + 314))) or ((9596 - 5689) == (2139 - (1300 + 662)))) then
				v33 = EpicSettings.Settings['useArcaneBlast'];
				v34 = EpicSettings.Settings['useArcaneBarrage'];
				v35 = EpicSettings.Settings['useArcaneExplosion'];
				v36 = EpicSettings.Settings['useArcaneFamiliar'];
				v134 = 3 - 2;
			end
			if (((5225 - (1178 + 577)) > (289 + 266)) and (v134 == (5 - 3))) then
				v41 = EpicSettings.Settings['useManaGem'];
				v42 = EpicSettings.Settings['useNetherTempest'];
				v43 = EpicSettings.Settings['usePresenceOfMind'];
				v92 = EpicSettings.Settings['cancelPOM'];
				v134 = 1408 - (851 + 554);
			end
			if ((v134 == (9 + 1)) or ((2695 - 1723) == (1400 - 755))) then
				v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v91 = EpicSettings.Settings['mirrorImageBeforePull'];
				v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((3484 - (115 + 187)) >= (1620 + 495)) and (v134 == (4 + 0))) then
				v48 = EpicSettings.Settings['useShiftingPower'];
				v49 = EpicSettings.Settings['useArcaneOrb'];
				v50 = EpicSettings.Settings['useRadiantSpark'];
				v51 = EpicSettings.Settings['useTouchOfTheMagi'];
				v134 = 19 - 14;
			end
			if (((5054 - (160 + 1001)) < (3875 + 554)) and (v134 == (5 + 1))) then
				v56 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v57 = EpicSettings.Settings['useAlterTime'];
				v58 = EpicSettings.Settings['usePrismaticBarrier'];
				v59 = EpicSettings.Settings['useGreaterInvisibility'];
				v134 = 13 - 6;
			end
			if ((v134 == (361 - (237 + 121))) or ((3764 - (525 + 372)) < (3611 - 1706))) then
				v44 = EpicSettings.Settings['useCounterspell'];
				v45 = EpicSettings.Settings['useBlastWave'];
				v46 = EpicSettings.Settings['useDragonsBreath'];
				v47 = EpicSettings.Settings['useArcaneSurge'];
				v134 = 12 - 8;
			end
			if ((v134 == (150 - (96 + 46))) or ((2573 - (643 + 134)) >= (1463 + 2588))) then
				v64 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 - 0);
				v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v67 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v134 = 17 - 8;
			end
			if (((2338 - (316 + 403)) <= (2497 + 1259)) and (v134 == (24 - 15))) then
				v68 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v70 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
				v89 = EpicSettings.Settings['useSpellStealTarget'];
				v134 = 4 + 6;
			end
			if (((2092 - 1488) == (2884 - 2280)) and (v134 == (1 - 0))) then
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useArcaneMissiles'];
				v39 = EpicSettings.Settings['useConjureManaGem'];
				v40 = EpicSettings.Settings['useEvocation'];
				v134 = 1 + 1;
			end
			if ((v134 == (13 - 6)) or ((220 + 4264) == (2647 - 1747))) then
				v60 = EpicSettings.Settings['useIceBlock'];
				v61 = EpicSettings.Settings['useIceCold'];
				v62 = EpicSettings.Settings['useMassBarrier'];
				v63 = EpicSettings.Settings['useMirrorImage'];
				v134 = 25 - (12 + 5);
			end
			if ((v134 == (19 - 14)) or ((9513 - 5054) <= (2365 - 1252))) then
				v52 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v55 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v134 = 14 - 8;
			end
		end
	end
	local function v123()
		local v135 = 0 + 0;
		while true do
			if (((5605 - (1656 + 317)) > (3028 + 370)) and (v135 == (2 + 0))) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v135 = 7 - 4;
			end
			if (((20089 - 16007) <= (5271 - (5 + 349))) and (v135 == (0 - 0))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (1271 - (266 + 1005));
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v135 = 1 + 0;
			end
			if (((16487 - 11655) >= (1824 - 438)) and (v135 == (1700 - (561 + 1135)))) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v135 = 1071 - (507 + 559);
			end
			if (((343 - 206) == (423 - 286)) and (v135 == (389 - (212 + 176)))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v135 = 907 - (250 + 655);
			end
			if (((8 - 5) == v135) or ((2743 - 1173) >= (6777 - 2445))) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v135 = 1960 - (1869 + 87);
			end
			if ((v135 == (17 - 12)) or ((5965 - (484 + 1417)) <= (3898 - 2079))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v124()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (773 - (48 + 725))) or ((8145 - 3159) < (4222 - 2648))) then
				v122();
				v123();
				v28 = EpicSettings.Toggles['ooc'];
				v136 = 1 + 0;
			end
			if (((11828 - 7402) > (49 + 123)) and ((2 + 3) == v136)) then
				if (((1439 - (152 + 701)) > (1766 - (430 + 881))) and v98.TargetIsValid()) then
					if (((317 + 509) == (1721 - (557 + 338))) and v72 and v32 and v94.RemoveCurse:IsAvailable()) then
						local v202 = 0 + 0;
						while true do
							if ((v202 == (0 - 0)) or ((14073 - 10054) > (11798 - 7357))) then
								if (((4346 - 2329) < (5062 - (499 + 302))) and v15) then
									local v210 = 866 - (39 + 827);
									while true do
										if (((13018 - 8302) > (178 - 98)) and (v210 == (0 - 0))) then
											v27 = v113();
											if (v27 or ((5384 - 1877) == (281 + 2991))) then
												return v27;
											end
											break;
										end
									end
								end
								if ((v16 and v16:Exists() and not v13:CanAttack(v16) and v98.UnitHasCurseDebuff(v16)) or ((2563 - 1687) >= (492 + 2583))) then
									if (((6885 - 2533) > (2658 - (103 + 1))) and v94.RemoveCurse:IsReady()) then
										if (v21(v96.RemoveCurseMouseover) or ((4960 - (475 + 79)) < (8739 - 4696))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if ((not v13:AffectingCombat() and v28) or ((6044 - 4155) >= (438 + 2945))) then
						v27 = v115();
						if (((1666 + 226) <= (4237 - (1395 + 108))) and v27) then
							return v27;
						end
					end
					v27 = v111();
					if (((5595 - 3672) < (3422 - (7 + 1197))) and v27) then
						return v27;
					end
					if (((948 + 1225) > (133 + 246)) and v73) then
						if (v93 or ((2910 - (27 + 292)) == (9989 - 6580))) then
							local v205 = 0 - 0;
							while true do
								if (((18930 - 14416) > (6555 - 3231)) and (v205 == (0 - 0))) then
									v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 169 - (43 + 96));
									if (v27 or ((848 - 640) >= (10915 - 6087))) then
										return v27;
									end
									break;
								end
							end
						end
					end
					if (v74 or ((1314 + 269) > (1008 + 2559))) then
						v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 59 - 29);
						if (v27 or ((504 + 809) == (1487 - 693))) then
							return v27;
						end
					end
					if (((1000 + 2174) > (213 + 2689)) and v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) then
						if (((5871 - (1414 + 337)) <= (6200 - (1642 + 298))) and v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) or ((2301 - 1418) > (13745 - 8967))) then
						if ((v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) or ((10742 - 7122) >= (1610 + 3281))) then
							if (((3313 + 945) > (1909 - (357 + 615))) and v21(v96.UseWeapon, nil)) then
								return "Using Weapon Macro";
							end
						end
						local v203 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
						if (v203 or ((3418 + 1451) < (2222 - 1316))) then
							return v203;
						end
						if ((v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes) and not v13:PrevOffGCDP(1 + 0, v94.IceFloes)) or ((2625 - 1400) > (3382 + 846))) then
							if (((227 + 3101) > (1407 + 831)) and v21(v94.IceFloes)) then
								return "ice_floes movement";
							end
						end
						if (((5140 - (384 + 917)) > (2102 - (128 + 569))) and v90 and v94.TimeWarp:IsReady() and v13:BloodlustDown() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v109 <= (1583 - (1407 + 136))) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v109 <= (v94.ArcaneSurge:CooldownRemains() + (1901 - (687 + 1200))))))) then
							if (v21(v94.TimeWarp, not v14:IsInRange(1750 - (556 + 1154))) or ((4548 - 3255) <= (602 - (9 + 86)))) then
								return "time_warp main 4";
							end
						end
						if ((v80 and ((v83 and v30) or not v83) and (v78 < v109)) or ((3317 - (275 + 146)) < (131 + 674))) then
							if (((2380 - (29 + 35)) == (10264 - 7948)) and v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (5 - 3)) or (v102 >= (8 - 6)))) then
								if (v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment)) or ((1674 + 896) == (2545 - (53 + 959)))) then
									return "lights_judgment main 6";
								end
							end
							if ((v94.Berserking:IsCastable() and ((v13:PrevGCDP(409 - (312 + 96), v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) or ((1532 - 649) == (1745 - (147 + 138)))) then
								if (v21(v94.Berserking) or ((5518 - (813 + 86)) <= (903 + 96))) then
									return "berserking main 8";
								end
							end
							if (v13:PrevGCDP(1 - 0, v94.ArcaneSurge) or ((3902 - (18 + 474)) > (1389 + 2727))) then
								local v208 = 0 - 0;
								while true do
									if ((v208 == (1086 - (860 + 226))) or ((1206 - (121 + 182)) >= (377 + 2682))) then
										if (v94.BloodFury:IsCastable() or ((5216 - (988 + 252)) < (323 + 2534))) then
											if (((1545 + 3385) > (4277 - (49 + 1921))) and v21(v94.BloodFury)) then
												return "blood_fury main 10";
											end
										end
										if (v94.Fireblood:IsCastable() or ((4936 - (223 + 667)) < (1343 - (51 + 1)))) then
											if (v21(v94.Fireblood) or ((7299 - 3058) == (7591 - 4046))) then
												return "fireblood main 12";
											end
										end
										v208 = 1126 - (146 + 979);
									end
									if ((v208 == (1 + 0)) or ((4653 - (311 + 294)) > (11801 - 7569))) then
										if (v94.AncestralCall:IsCastable() or ((742 + 1008) >= (4916 - (496 + 947)))) then
											if (((4524 - (1233 + 125)) == (1285 + 1881)) and v21(v94.AncestralCall)) then
												return "ancestral_call main 14";
											end
										end
										break;
									end
								end
							end
						end
						if (((1582 + 181) < (708 + 3016)) and (v78 < v109)) then
							if (((1702 - (963 + 682)) <= (2273 + 450)) and v81 and ((v30 and v82) or not v82)) then
								local v209 = 1504 - (504 + 1000);
								while true do
									if ((v209 == (0 + 0)) or ((1886 + 184) == (42 + 401))) then
										v27 = v114();
										if (v27 or ((3988 - 1283) == (1191 + 202))) then
											return v27;
										end
										break;
									end
								end
							end
						end
						v27 = v116();
						if (v27 or ((2676 + 1925) < (243 - (156 + 26)))) then
							return v27;
						end
						v27 = v121();
						if (v27 or ((801 + 589) >= (7422 - 2678))) then
							return v27;
						end
					end
				end
				break;
			end
			if (((168 - (149 + 15)) == v136) or ((2963 - (890 + 70)) > (3951 - (39 + 78)))) then
				v110 = v13:GCD();
				if (v73 or ((638 - (14 + 468)) > (8604 - 4691))) then
					if (((545 - 350) == (101 + 94)) and v93) then
						local v204 = 0 + 0;
						while true do
							if (((660 + 2445) >= (812 + 984)) and (v204 == (0 + 0))) then
								v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 57 - 27);
								if (((4328 + 51) >= (7488 - 5357)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (((98 + 3746) >= (2094 - (12 + 39))) and (not v13:AffectingCombat() or v28)) then
					if ((v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) or ((3007 + 225) <= (8453 - 5722))) then
						if (((17469 - 12564) == (1455 + 3450)) and v21(v94.ArcaneIntellect)) then
							return "arcane_intellect group_buff";
						end
					end
					if ((v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) or ((2178 + 1958) >= (11185 - 6774))) then
						if (v21(v94.ArcaneFamiliar) or ((1971 + 987) == (19413 - 15396))) then
							return "arcane_familiar precombat 2";
						end
					end
					if (((2938 - (1596 + 114)) >= (2122 - 1309)) and v94.ConjureManaGem:IsCastable() and v39) then
						if (v21(v94.ConjureManaGem) or ((4168 - (164 + 549)) > (5488 - (1059 + 379)))) then
							return "conjure_mana_gem precombat 4";
						end
					end
				end
				v136 = 6 - 1;
			end
			if (((126 + 117) == (41 + 202)) and ((394 - (145 + 247)) == v136)) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((223 + 48) > (727 + 845))) then
					return v27;
				end
				v100 = v14:GetEnemiesInSplashRange(14 - 9);
				v136 = 1 + 2;
			end
			if (((2360 + 379) < (5346 - 2053)) and (v136 == (721 - (254 + 466)))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v136 = 562 - (544 + 16);
			end
			if (((9 - 6) == v136) or ((4570 - (294 + 334)) < (1387 - (236 + 17)))) then
				v103 = v13:GetEnemiesInRange(18 + 22);
				if (v29 or ((2097 + 596) == (18728 - 13755))) then
					v101 = v26(v14:GetEnemiesInSplashRangeCount(23 - 18), #v103);
					v102 = #v103;
				else
					v101 = 1 + 0;
					v102 = 1 + 0;
				end
				if (((2940 - (413 + 381)) == (91 + 2055)) and (v98.TargetIsValid() or v13:AffectingCombat())) then
					local v200 = 0 - 0;
					while true do
						if ((v200 == (0 - 0)) or ((4214 - (582 + 1388)) == (5492 - 2268))) then
							if (v13:AffectingCombat() or v72 or ((3511 + 1393) <= (2280 - (326 + 38)))) then
								local v206 = 0 - 0;
								local v207;
								while true do
									if (((128 - 38) <= (1685 - (47 + 573))) and (v206 == (1 + 0))) then
										if (((20394 - 15592) == (7793 - 2991)) and v27) then
											return v27;
										end
										break;
									end
									if ((v206 == (1664 - (1269 + 395))) or ((2772 - (76 + 416)) <= (954 - (319 + 124)))) then
										v207 = v72 and v94.RemoveCurse:IsReady() and v32;
										v27 = v98.FocusUnit(v207, nil, 45 - 25, nil, 1027 - (564 + 443), v94.ArcaneIntellect);
										v206 = 2 - 1;
									end
								end
							end
							v108 = v10.BossFightRemains(nil, true);
							v200 = 459 - (337 + 121);
						end
						if ((v200 == (2 - 1)) or ((5582 - 3906) <= (2374 - (1261 + 650)))) then
							v109 = v108;
							if (((1637 + 2232) == (6165 - 2296)) and (v109 == (12928 - (772 + 1045)))) then
								v109 = v10.FightRemains(v103, false);
							end
							break;
						end
					end
				end
				v136 = 1 + 3;
			end
		end
	end
	local function v125()
		local v137 = 144 - (102 + 42);
		while true do
			if (((3002 - (1524 + 320)) <= (3883 - (1049 + 221))) and (v137 == (156 - (18 + 138)))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(151 - 89, v124, v125);
end;
return v0["Epix_Mage_Arcane.lua"]();

