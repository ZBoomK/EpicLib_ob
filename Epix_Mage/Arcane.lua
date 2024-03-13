local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((2298 - (289 + 714)) >= (3972 - (396 + 343)))) then
			v6 = v0[v4];
			if (((388 + 3989) > (3119 - (29 + 1448))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1390 - (135 + 1254);
		end
		if (((17792 - 13069) > (6331 - 4975)) and (v5 == (1 + 0))) then
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
		if (v94.RemoveCurse:IsAvailable() or ((5663 - (389 + 1138)) <= (4007 - (102 + 472)))) then
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
	local v110 = v13:HasTier(17 + 12, 4 + 0);
	local v111 = (226545 - (320 + 1225)) - (((44504 - 19504) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((122373 + 77627) * v24(not v110)));
	local v112 = 1467 - (157 + 1307);
	local v113 = 12970 - (821 + 1038);
	local v114 = 27721 - 16610;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if (((7539 - 3294) <= (1723 + 2908)) and ((2 - 1) == v134)) then
				v111 = (226026 - (834 + 192)) - (((1590 + 23410) * v24(not v94.ArcaneHarmony:IsAvailable())) + ((51335 + 148665) * v24(not v110)));
				v113 = 239 + 10872;
				v134 = 2 - 0;
			end
			if (((4580 - (300 + 4)) >= (1046 + 2868)) and (v134 == (0 - 0))) then
				v105 = false;
				v108 = true;
				v134 = 363 - (112 + 250);
			end
			if (((79 + 119) <= (10935 - 6570)) and (v134 == (2 + 0))) then
				v114 = 5747 + 5364;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v110 = not v13:HasTier(22 + 7, 2 + 2);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v116()
		local v135 = 0 + 0;
		while true do
			if (((6196 - (1001 + 413)) > (10427 - 5751)) and (v135 == (886 - (244 + 638)))) then
				if (((5557 - (627 + 66)) > (6546 - 4349)) and v84 and (v13:HealthPercentage() <= v86)) then
					local v208 = 602 - (512 + 90);
					while true do
						if ((v208 == (1906 - (1665 + 241))) or ((4417 - (373 + 344)) == (1131 + 1376))) then
							if (((1184 + 3290) >= (722 - 448)) and (v88 == "Refreshing Healing Potion")) then
								if (v95.RefreshingHealingPotion:IsReady() or ((3204 - 1310) <= (2505 - (35 + 1064)))) then
									if (((1144 + 428) >= (3275 - 1744)) and v21(v96.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((19 + 4668) < (5778 - (298 + 938)))) then
								if (((4550 - (233 + 1026)) > (3333 - (636 + 1030))) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (v21(v96.RefreshingHealingPotion) or ((447 + 426) == (1987 + 47))) then
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
			if ((v135 == (1 + 0)) or ((191 + 2625) < (232 - (55 + 166)))) then
				if (((717 + 2982) < (474 + 4232)) and v94.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
					if (((10105 - 7459) >= (1173 - (36 + 261))) and v21(v94.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((1073 - 459) <= (4552 - (34 + 1334))) and v94.IceColdTalent:IsAvailable() and v94.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
					if (((1202 + 1924) == (2429 + 697)) and v21(v94.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				v135 = 1285 - (1035 + 248);
			end
			if ((v135 == (23 - (20 + 1))) or ((1140 + 1047) >= (5273 - (134 + 185)))) then
				if ((v94.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((5010 - (549 + 584)) == (4260 - (314 + 371)))) then
					if (((2427 - 1720) > (1600 - (478 + 490))) and v21(v94.MirrorImage)) then
						return "mirror_image defensive 4";
					end
				end
				if ((v94.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((290 + 256) >= (3856 - (786 + 386)))) then
					if (((4744 - 3279) <= (5680 - (1055 + 324))) and v21(v94.GreaterInvisibility)) then
						return "greater_invisibility defensive 5";
					end
				end
				v135 = 1343 - (1093 + 247);
			end
			if (((1515 + 189) > (150 + 1275)) and (v135 == (11 - 8))) then
				if ((v94.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((2331 - 1644) == (12047 - 7813))) then
					if (v21(v94.AlterTime) or ((8367 - 5037) < (509 + 920))) then
						return "alter_time defensive 6";
					end
				end
				if (((4418 - 3271) >= (1154 - 819)) and v95.Healthstone:IsReady() and v85 and (v13:HealthPercentage() <= v87)) then
					if (((2591 + 844) > (5362 - 3265)) and v21(v96.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v135 = 692 - (364 + 324);
			end
			if ((v135 == (0 - 0)) or ((9046 - 5276) >= (1340 + 2701))) then
				if ((v94.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v94.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) or ((15862 - 12071) <= (2579 - 968))) then
					if (v21(v94.PrismaticBarrier) or ((13903 - 9325) <= (3276 - (1249 + 19)))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((1016 + 109) <= (8080 - 6004)) and v94.MassBarrier:IsCastable() and v62 and v13:BuffDown(v94.PrismaticBarrier) and v98.AreUnitsBelowHealthPercentage(v70, 1088 - (686 + 400), v94.ArcaneIntellect)) then
					if (v21(v94.MassBarrier) or ((583 + 160) >= (4628 - (73 + 156)))) then
						return "mass_barrier defensive 2";
					end
				end
				v135 = 1 + 0;
			end
		end
	end
	local v117 = 811 - (721 + 90);
	local function v118()
		if (((13 + 1142) < (5431 - 3758)) and v94.RemoveCurse:IsReady() and v98.UnitHasDispellableDebuffByPlayer(v15)) then
			local v188 = 470 - (224 + 246);
			while true do
				if (((0 - 0) == v188) or ((4278 - 1954) <= (105 + 473))) then
					if (((90 + 3677) == (2767 + 1000)) and (v117 == (0 - 0))) then
						v117 = GetTime();
					end
					if (((13607 - 9518) == (4602 - (203 + 310))) and v98.Wait(2493 - (1238 + 755), v117)) then
						local v212 = 0 + 0;
						while true do
							if (((5992 - (709 + 825)) >= (3084 - 1410)) and (v212 == (0 - 0))) then
								if (((1836 - (196 + 668)) <= (5598 - 4180)) and v21(v96.RemoveCurseFocus)) then
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
		v27 = v98.HandleTopTrinket(v97, v30, 873 - (171 + 662), nil);
		if (v27 or ((5031 - (4 + 89)) < (16690 - 11928))) then
			return v27;
		end
		v27 = v98.HandleBottomTrinket(v97, v30, 15 + 25, nil);
		if (v27 or ((10998 - 8494) > (1673 + 2591))) then
			return v27;
		end
	end
	local function v120()
		if (((3639 - (35 + 1451)) == (3606 - (28 + 1425))) and v94.MirrorImage:IsCastable() and v91 and v63) then
			if (v21(v94.MirrorImage) or ((2500 - (941 + 1052)) >= (2485 + 106))) then
				return "mirror_image precombat 2";
			end
		end
		if (((5995 - (822 + 692)) == (6397 - 1916)) and v94.ArcaneBlast:IsReady() and v33 and not v94.SiphonStorm:IsAvailable()) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast)) or ((1097 + 1231) < (990 - (45 + 252)))) then
				return "arcane_blast precombat 4";
			end
		end
		if (((4283 + 45) == (1490 + 2838)) and v94.Evocation:IsReady() and v40 and (v94.SiphonStorm:IsAvailable())) then
			if (((3864 - 2276) >= (1765 - (114 + 319))) and v21(v94.Evocation)) then
				return "evocation precombat 6";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((5992 - 1818) > (5442 - 1194))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(26 + 14)) or ((6832 - 2246) <= (171 - 89))) then
				return "arcane_orb precombat 8";
			end
		end
		if (((5826 - (556 + 1407)) == (5069 - (741 + 465))) and v94.ArcaneBlast:IsReady() and v33) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((747 - (170 + 295)) <= (23 + 19))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v121()
		local v136 = 0 + 0;
		while true do
			if (((11347 - 6738) >= (635 + 131)) and (v136 == (1 + 0))) then
				if ((v14:DebuffUp(v94.TouchoftheMagiDebuff) and v108) or ((653 + 499) == (3718 - (957 + 273)))) then
					v108 = false;
				end
				v109 = v94.ArcaneBlast:CastTime() < v115;
				break;
			end
			if (((916 + 2506) > (1342 + 2008)) and ((0 - 0) == v136)) then
				if (((2310 - 1433) > (1148 - 772)) and ((v101 >= v104) or (v102 >= v104)) and ((v94.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (1783 - (389 + 1391)))) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (2 + 0)))) then
					v106 = true;
				elseif ((v106 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (1 + 6)) and v94.RadiantSpark:CooldownDown()) or ((7098 - 3980) <= (2802 - (783 + 168)))) then
					v106 = false;
				end
				if (((v13:ArcaneCharges() > (9 - 6)) and ((v101 < v104) or (v102 < v104)) and v94.RadiantSpark:CooldownUp() and (v94.TouchoftheMagi:CooldownRemains() <= (v115 * (7 + 0))) and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * (316 - (309 + 2)))) or (v94.ArcaneSurge:CooldownRemains() > (122 - 82)))) or ((1377 - (1090 + 122)) >= (1133 + 2359))) then
					v107 = true;
				elseif (((13262 - 9313) < (3324 + 1532)) and v107 and v14:DebuffDown(v94.RadiantSparkVulnerability) and (v14:DebuffRemains(v94.RadiantSparkDebuff) < (1125 - (628 + 490))) and v94.RadiantSpark:CooldownDown()) then
					v107 = false;
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v122()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (4 - 3)) or ((5050 - (431 + 343)) < (6090 - 3074))) then
				if (((13567 - 8877) > (3259 + 866)) and v94.ArcaneBlast:IsReady() and v33 and v94.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (1 + 1)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v94.ArcaneOrb:CooldownRemains() >= v115)))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((1745 - (556 + 1139)) >= (911 - (6 + 9)))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and (v13:ManaPercentage() > (16 + 14)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((1883 - (28 + 141)) >= (1146 + 1812))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((1840 - 349) < (457 + 187))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				if (((2021 - (486 + 831)) < (2568 - 1581)) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (17 - 12)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (2 + 4)))) and v13:HasTier(97 - 66, 1267 - (668 + 595))) then
					if (((3346 + 372) > (385 + 1521)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (46 - 29)) and not v13:HasTier(320 - (23 + 267), 1948 - (1129 + 815))) or ((1345 - (371 + 16)) > (5385 - (1326 + 424)))) then
					if (((6630 - 3129) <= (16414 - 11922)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				v137 = 120 - (88 + 30);
			end
			if ((v137 == (775 - (720 + 51))) or ((7656 - 4214) < (4324 - (421 + 1355)))) then
				if (((4743 - 1868) >= (720 + 744)) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (v21(v94.PresenceofMind) or ((5880 - (286 + 797)) >= (17886 - 12993))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.PresenceofMindBuff))) or ((912 - 361) > (2507 - (397 + 42)))) then
					if (((661 + 1453) > (1744 - (24 + 776))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v94.NetherPrecisionBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v14:DebuffDown(v94.RadiantSparkVulnerability) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 1)) and v13:PrevGCDP(786 - (222 + 563), v94.ArcaneBlast)))) or ((4983 - 2721) >= (2230 + 866))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((2445 - (23 + 167)) >= (5335 - (690 + 1108)))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33) or ((1385 + 2452) < (1078 + 228))) then
					if (((3798 - (40 + 808)) == (486 + 2464)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v137 == (11 - 8)) or ((4515 + 208) < (1745 + 1553))) then
				if (((623 + 513) >= (725 - (47 + 524))) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (20 + 10)) and (v94.ArcaneEcho:IsAvailable())) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((740 - 469) > (7099 - 2351))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((10810 - 6070) >= (4878 - (1165 + 561))) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
					if (v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes)) or ((77 + 2501) >= (10499 - 7109))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if (((16 + 25) <= (2140 - (341 + 138))) and v94.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1 + 0, v94.ArcaneSurge) or v13:PrevGCDP(1 - 0, v94.NetherTempest) or v13:PrevGCDP(327 - (89 + 237), v94.RadiantSpark))) then
					if (((1933 - 1332) < (7494 - 3934)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				if (((1116 - (581 + 300)) < (1907 - (855 + 365))) and v94.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v94.RadiantSparkVulnerability) and (v14:DebuffStack(v94.RadiantSparkVulnerability) < (9 - 5))) then
					if (((1486 + 3063) > (2388 - (1030 + 205))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				v137 = 4 + 0;
			end
			if ((v137 == (2 + 0)) or ((4960 - (156 + 130)) < (10615 - 5943))) then
				if (((6181 - 2513) < (9341 - 4780)) and v94.ArcaneMissiles:IsReady() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (1 + 1)) and (v94.RadiantSpark:CooldownRemains() < (3 + 2)) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (75 - (10 + 59))))) and not v13:HasTier(9 + 21, 19 - 15)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((1618 - (671 + 492)) == (2870 + 735))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (1230 - (369 + 846))) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (2 + 3)))) and (v94.ArcaneSurge:CooldownRemains() < (26 + 4))) or ((4608 - (1036 + 909)) == (2634 + 678))) then
					if (((7180 - 2903) <= (4678 - (11 + 192))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.RadiantSpark:CooldownUp() and v13:BuffUp(v94.ClearcastingBuff) and v94.NetherPrecision:IsAvailable() and (v13:BuffDown(v94.NetherPrecisionBuff) or (v13:BuffRemains(v94.NetherPrecisionBuff) < v115)) and v13:HasTier(16 + 14, 179 - (135 + 40))) or ((2107 - 1237) == (717 + 472))) then
					if (((3420 - 1867) <= (4696 - 1563)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((2413 - (50 + 126)) >= (9776 - 6265))) then
					if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((294 + 1030) > (4433 - (1233 + 180)))) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v137 = 972 - (522 + 447);
			end
			if ((v137 == (1421 - (107 + 1314))) or ((1389 + 1603) == (5731 - 3850))) then
				if (((1320 + 1786) > (3030 - 1504)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(3 - 2, v94.ArcaneBarrage))) then
					if (((4933 - (716 + 1194)) < (67 + 3803)) and v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((16 + 127) > (577 - (74 + 429))) and v94.RadiantSpark:CooldownUp()) then
					v105 = v94.ArcaneSurge:CooldownRemains() < (19 - 9);
				end
				if (((9 + 9) < (4834 - 2722)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.RadiantSpark:IsAvailable()) then
					if (((777 + 320) <= (5018 - 3390)) and v21(v94.ShiftingPower, not v14:IsInRange(98 - 58), true)) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if (((5063 - (279 + 154)) == (5408 - (454 + 324))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and v94.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
					if (((2786 + 754) > (2700 - (12 + 5))) and v21(v94.ArcaneOrb, not v14:IsInRange(22 + 18))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				v137 = 2 - 1;
			end
		end
	end
	local function v123()
		local v138 = 0 + 0;
		while true do
			if (((5887 - (277 + 816)) >= (13994 - 10719)) and (v138 == (1186 - (1058 + 125)))) then
				if (((279 + 1205) == (2459 - (815 + 160))) and v94.ArcaneBlast:IsReady() and v33 and (v94.ArcaneBlast:CastTime() >= v13:GCD()) and (v94.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v94.RadiantSparkVulnerability)) and (not v94.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (150 - 115))) and ((v94.NetherTempest:IsAvailable() and v13:PrevGCDP(14 - 8, v94.RadiantSpark)) or (not v94.NetherTempest:IsAvailable() and v13:PrevGCDP(2 + 3, v94.RadiantSpark))) and not (v13:IsCasting(v94.ArcaneSurge) and (v13:CastRemains() < (0.5 - 0)) and not v109)) then
					if (((3330 - (41 + 1857)) < (5448 - (1222 + 671))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (10 - 6))) or ((1530 - 465) > (4760 - (229 + 953)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((6569 - (1111 + 663)) < (2986 - (874 + 705)))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((260 + 1593) < (3284 + 1529)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and v13:PrevGCDP(1 - 0, v94.ArcaneBarrage) and ((v94.ArcaneBarrage:InFlight() and ((v94.ArcaneBarrage:TravelTime() - v94.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 + 0))) or (v13:GCDRemains() <= (679.2 - (642 + 37))))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((644 + 2177) < (389 + 2042))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v138 = 9 - 5;
			end
			if ((v138 == (454 - (233 + 221))) or ((6645 - 3771) < (1920 + 261))) then
				if ((v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (1586 - (718 + 823))) and v14:DebuffDown(v94.NetherTempestDebuff) and v108 and v13:BloodlustUp()) or ((1693 + 996) <= (1148 - (266 + 539)))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((5291 - 3422) == (3234 - (636 + 589)))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if ((v108 and v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((7313 - 3767) < (1841 + 481))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((757 + 1325) == (5788 - (657 + 358)))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((8589 - 5345) > (2403 - 1348)) and v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1192 - (1151 + 36))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffDown(v94.ArcaneArtilleryBuff) or (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (6 + 0)))) and v13:HasTier(9 + 22, 11 - 7)) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((5145 - (1552 + 280)) <= (2612 - (64 + 770)))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (4 - 2)) or ((253 + 1168) >= (3347 - (157 + 1086)))) then
				if (((3626 - 1814) <= (14229 - 10980)) and v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) then
					if (((2488 - 865) <= (2670 - 713)) and v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if (((5231 - (599 + 220)) == (8785 - 4373)) and v94.NetherTempest:IsReady() and v42 and not v109 and (v94.NetherTempest:TimeSinceLastCast() >= (1946 - (1813 + 118))) and ((not v109 and v13:PrevGCDP(3 + 1, v94.RadiantSpark) and (v94.ArcaneSurge:CooldownRemains() <= v94.NetherTempest:ExecuteTime())) or v13:PrevGCDP(1222 - (841 + 376), v94.RadiantSpark))) then
					if (((2452 - 702) >= (196 + 646)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
						return "nether_tempest spark_phase 16";
					end
				end
				if (((11933 - 7561) > (2709 - (464 + 395))) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114) and ((not v94.NetherTempest:IsAvailable() and ((v13:PrevGCDP(10 - 6, v94.RadiantSpark) and not v109) or v13:PrevGCDP(3 + 2, v94.RadiantSpark))) or v13:PrevGCDP(838 - (467 + 370), v94.NetherTempest))) then
					if (((478 - 246) < (603 + 218)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
						return "arcane_surge spark_phase 18";
					end
				end
				v138 = 10 - 7;
			end
			if (((81 + 437) < (2098 - 1196)) and (v138 == (524 - (150 + 370)))) then
				if (((4276 - (74 + 1208)) > (2110 - 1252)) and v94.ArcaneBlast:IsReady() and v33) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((17808 - 14053) <= (652 + 263))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if (((4336 - (14 + 376)) > (6491 - 2748)) and v94.ArcaneBarrage:IsReady() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((864 + 471) >= (2905 + 401))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if (((4620 + 224) > (6601 - 4348)) and (v138 == (1 + 0))) then
				if (((530 - (23 + 55)) == (1070 - 618)) and v94.ArcaneBlast:IsReady() and v33 and v108 and v94.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v111) and (v13:BuffRemains(v94.SiphonStormBuff) > (11 + 4))) then
					if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((4093 + 464) < (3235 - 1148))) then
						return "arcane_blast spark_phase 6";
					end
				end
				if (((1219 + 2655) == (4775 - (652 + 249))) and v94.ArcaneMissiles:IsCastable() and v38 and v108 and v13:BloodlustUp() and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) >= (5 - 3)) and (v94.RadiantSpark:CooldownRemains() < (1873 - (708 + 1160))) and v13:BuffDown(v94.NetherPrecisionBuff) and (v13:BuffRemains(v94.ArcaneArtilleryBuff) <= (v115 * (16 - 10)))) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3533 - 1595) > (4962 - (10 + 17)))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v94.ArcaneMissiles:IsReady() and v38 and v94.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v94.ArcaneHarmonyBuff) < (4 + 11)) and ((v108 and v13:BloodlustUp()) or (v13:BuffUp(v94.ClearcastingBuff) and (v94.RadiantSpark:CooldownRemains() < (1737 - (1400 + 332))))) and (v94.ArcaneSurge:CooldownRemains() < (57 - 27))) or ((6163 - (242 + 1666)) < (1465 + 1958))) then
					if (((533 + 921) <= (2123 + 368)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				v138 = 942 - (850 + 90);
			end
		end
	end
	local function v124()
		if ((v13:BuffUp(v94.PresenceofMindBuff) and v92 and (v13:PrevGCDP(1 - 0, v94.ArcaneBlast)) and (v94.ArcaneSurge:CooldownRemains() > (1465 - (360 + 1030)))) or ((3679 + 478) <= (7911 - 5108))) then
			if (((6676 - 1823) >= (4643 - (909 + 752))) and v21(v96.CancelPOM)) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if (((5357 - (109 + 1114)) > (6145 - 2788)) and v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) then
			if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((3659 - (6 + 236)) < (1597 + 937))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if ((v94.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v114)) or ((2191 + 531) <= (386 - 222))) then
			if (v21(v94.RadiantSpark, not v14:IsSpellInRange(v94.RadiantSpark), v13:BuffDown(v94.IceFloes)) or ((4205 - 1797) < (3242 - (1076 + 57)))) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v94.ArcaneOrb:TimeSinceLastCast() >= (3 + 12)) and (v13:ArcaneCharges() < (692 - (579 + 110)))) or ((3 + 30) == (1287 + 168))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(22 + 18)) or ((850 - (174 + 233)) >= (11215 - 7200))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if (((5935 - 2553) > (74 + 92)) and v94.NetherTempest:IsReady() and v42 and (v94.NetherTempest:TimeSinceLastCast() >= (1189 - (663 + 511))) and (v94.ArcaneEcho:IsAvailable())) then
			if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((250 + 30) == (665 + 2394))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((5798 - 3917) > (783 + 510)) and v94.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v114)) then
			if (((5549 - 3192) == (5705 - 3348)) and v21(v94.ArcaneSurge, not v14:IsSpellInRange(v94.ArcaneSurge), v13:BuffDown(v94.IceFloes))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if (((59 + 64) == (239 - 116)) and v94.ArcaneBarrage:IsReady() and v34 and (v94.ArcaneSurge:CooldownRemains() < (54 + 21)) and (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 3)) and not v94.OrbBarrage:IsAvailable()) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1778 - (478 + 244)) >= (3909 - (440 + 77)))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1 + 1)) and (v94.ArcaneSurge:CooldownRemains() > (274 - 199))) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1557 - (655 + 901))) and (v94.ArcaneSurge:CooldownRemains() < (14 + 61)) and not v94.OrbBarrage:IsAvailable()))) or ((828 + 253) < (726 + 349))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4225 - 3176) >= (5877 - (695 + 750)))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (3 - 2)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (2 - 0)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (11 - 8)) and ((v101 > (356 - (285 + 66))) or (v102 > (11 - 6)))) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (1314 - (682 + 628)))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v94.OrbBarrage:IsAvailable()) or ((769 + 3999) <= (1145 - (176 + 123)))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1405 + 1953) <= (1031 + 389))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if ((v94.PresenceofMind:IsCastable() and v43) or ((4008 - (239 + 30)) <= (817 + 2188))) then
			if (v21(v94.PresenceofMind) or ((1595 + 64) >= (3776 - 1642))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v94.RadiantSparkVulnerability) == (5 - 3)) or (v14:DebuffStack(v94.RadiantSparkVulnerability) == (318 - (306 + 9)))) and not v94.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v94.RadiantSparkVulnerability) and v94.OrbBarrage:IsAvailable()))) or ((11376 - 8116) < (410 + 1945))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((411 + 258) == (2033 + 2190))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v94.RadiantSparkVulnerability) == (11 - 7)) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((v14:DebuffStack(v94.RadiantSparkVulnerability) == (1378 - (1140 + 235))) and v13:BuffDown(v94.ArcaneSurgeBuff) and not v94.OrbBarrage:IsAvailable()))) or ((1077 + 615) < (540 + 48))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1232 + 3565) < (3703 - (33 + 19)))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v125()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (5 - 3)) or ((1841 + 2336) > (9511 - 4661))) then
				if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (719 - (586 + 103))) and (v94.TouchoftheMagi:CooldownRemains() > (3 + 27))) or (v13:ManaPercentage() > (215 - 145))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((1888 - (1309 + 179)) > (2005 - 894))) then
					if (((1328 + 1723) > (2698 - 1693)) and v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((2790 + 903) <= (9310 - 4928)) and v94.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v94.ClearcastingBuff) > (1 - 0)) and v94.ConjureManaGem:IsAvailable() and v95.ManaGem:CooldownUp()) then
					if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((3891 - (295 + 314)) > (10070 - 5970))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v94.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v94.NetherPrecisionBuff))) or ((5542 - (1300 + 662)) < (8930 - 6086))) then
					if (((1844 - (1178 + 577)) < (2332 + 2158)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v139 = 8 - 5;
			end
			if ((v139 == (1406 - (851 + 554))) or ((4407 + 576) < (5014 - 3206))) then
				if (((8315 - 4486) > (4071 - (115 + 187))) and v94.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) then
					if (((1138 + 347) <= (2750 + 154)) and v21(v94.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if (((16822 - 12553) == (5430 - (160 + 1001))) and v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (((339 + 48) <= (1920 + 862)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v94.ArcaneHarmonyBuff) or (v94.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (71 - 36)))) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) <= v115)) or ((2257 - (237 + 121)) <= (1814 - (525 + 372)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((8174 - 3862) <= (2878 - 2002))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v139 = 144 - (96 + 46);
			end
			if (((3009 - (643 + 134)) <= (938 + 1658)) and ((0 - 0) == v139)) then
				if (((7778 - 5683) < (3535 + 151)) and (v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (17 - 8))) then
					v105 = not v105;
				end
				if ((v94.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v94.NetherTempestDebuff) or not v14:DebuffUp(v94.NetherTempestDebuff)) and (v13:ArcaneCharges() == (7 - 3)) and (v13:ManaPercentage() < (749 - (316 + 403))) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) or ((4385 - 2790) >= (1617 + 2857))) then
					if (v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes)) or ((11632 - 7013) < (2043 + 839))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (1 + 1)) and (v13:ManaPercentage() < (103 - 73)) and (v13:SpellHaste() < (0.667 - 0)) and v13:BuffDown(v94.ArcaneSurgeBuff)) or ((610 - 316) >= (277 + 4554))) then
					if (((3993 - 1964) <= (151 + 2933)) and v21(v94.ArcaneOrb, not v14:IsInRange(117 - 77))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v139 = 18 - (12 + 5);
			end
			if ((v139 == (11 - 8)) or ((4346 - 2309) == (5144 - 2724))) then
				if (((11055 - 6597) > (793 + 3111)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > v94.ArcaneMissiles:CastTime()) or not v94.PresenceofMind:IsAvailable())) then
					if (((2409 - (1656 + 317)) >= (110 + 13)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((401 + 99) < (4828 - 3012)) and v94.ArcaneBlast:IsReady() and v33) then
					if (((17589 - 14015) == (3928 - (5 + 349))) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if (((1049 - 828) < (1661 - (266 + 1005))) and v94.ArcaneBarrage:IsReady() and v34) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1459 + 754) <= (4848 - 3427))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v140 = 0 - 0;
		while true do
			if (((4754 - (561 + 1135)) < (6333 - 1473)) and ((6 - 4) == v140)) then
				if ((v94.ArcaneExplosion:IsCastable() and v35) or ((2362 - (507 + 559)) >= (11156 - 6710))) then
					if (v21(v94.ArcaneExplosion, not v14:IsInRange(30 - 20)) or ((1781 - (212 + 176)) > (5394 - (250 + 655)))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
			if ((v140 == (0 - 0)) or ((7729 - 3305) < (41 - 14))) then
				if ((v14:DebuffRemains(v94.TouchoftheMagiDebuff) > (1965 - (1869 + 87))) or ((6926 - 4929) > (5716 - (484 + 1417)))) then
					v105 = not v105;
				end
				if (((7426 - 3961) > (3205 - 1292)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff)) then
					if (((1506 - (48 + 725)) < (2970 - 1151)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v140 = 2 - 1;
			end
			if (((1 + 0) == v140) or ((11745 - 7350) == (1331 + 3424))) then
				if ((v94.ArcaneBarrage:IsReady() and v34 and ((((v101 <= (2 + 2)) or (v102 <= (857 - (152 + 701)))) and (v13:ArcaneCharges() == (1314 - (430 + 881)))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or ((1453 + 2340) < (3264 - (557 + 338)))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((1208 + 2876) == (746 - 481))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if (((15260 - 10902) == (11578 - 7220)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (4 - 2))) then
					if (v21(v94.ArcaneOrb, not v14:IsInRange(841 - (499 + 302))) or ((4004 - (39 + 827)) < (2740 - 1747))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v140 = 4 - 2;
			end
		end
	end
	local function v127()
		if (((13226 - 9896) > (3565 - 1242)) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() < (1 + 2)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (204 - 134)) or (v110 and (v94.TouchoftheMagi:CooldownRemains() > (5 + 25))))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(63 - 23)) or ((3730 - (103 + 1)) == (4543 - (475 + 79)))) then
				return "arcane_orb rotation 2";
			end
		end
		v105 = ((v94.ArcaneSurge:CooldownRemains() > (64 - 34)) and (v94.TouchoftheMagi:CooldownRemains() > (32 - 22))) or false;
		if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and v110 and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (2 + 10))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (11 + 1))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (1515 - (1395 + 108)))) and (v114 > (43 - 28))) or ((2120 - (7 + 1197)) == (1165 + 1506))) then
			if (((95 + 177) == (591 - (27 + 292))) and v21(v94.ShiftingPower, not v14:IsInRange(117 - 77))) then
				return "shifting_power rotation 4";
			end
		end
		if (((5417 - 1168) <= (20293 - 15454)) and v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and not v110 and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() > (88 - 43)) and (v114 > (28 - 13))) then
			if (((2916 - (43 + 96)) < (13053 - 9853)) and v21(v94.ShiftingPower, not v14:IsInRange(90 - 50))) then
				return "shifting_power rotation 6";
			end
		end
		if (((79 + 16) < (553 + 1404)) and v94.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (5 - 2)) and (v14:HealthPercentage() < (14 + 21)) and v94.ArcaneBombardment:IsAvailable()) then
			if (((1547 - 721) < (541 + 1176)) and v21(v94.PresenceofMind)) then
				return "presence_of_mind rotation 8";
			end
		end
		if (((105 + 1321) >= (2856 - (1414 + 337))) and v94.ArcaneBlast:IsReady() and v33 and v94.TimeAnomaly:IsAvailable() and v13:BuffUp(v94.ArcaneSurgeBuff) and (v13:BuffRemains(v94.ArcaneSurgeBuff) <= (1946 - (1642 + 298)))) then
			if (((7179 - 4425) <= (9720 - 6341)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast rotation 10";
			end
		end
		if ((v94.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v94.PresenceofMindBuff) and (v14:HealthPercentage() < (103 - 68)) and v94.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (1 + 2))) or ((3056 + 871) == (2385 - (357 + 615)))) then
			if (v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes)) or ((811 + 343) <= (1933 - 1145))) then
				return "arcane_blast rotation 12";
			end
		end
		if ((v13:IsChanneling(v94.ArcaneMissiles) and (v13:GCDRemains() == (0 + 0)) and v13:BuffUp(v94.NetherPrecisionBuff) and (((v13:ManaPercentage() > (64 - 34)) and (v94.TouchoftheMagi:CooldownRemains() > (24 + 6))) or (v13:ManaPercentage() > (5 + 65))) and v13:BuffDown(v94.ArcaneArtilleryBuff)) or ((1033 + 610) > (4680 - (384 + 917)))) then
			if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((3500 - (128 + 569)) > (6092 - (1407 + 136)))) then
				return "arcane_missiles interrupt rotation 20";
			end
		end
		if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and (v13:BuffStack(v94.ClearcastingBuff) == v112)) or ((2107 - (687 + 1200)) >= (4732 - (556 + 1154)))) then
			if (((9927 - 7105) == (2917 - (9 + 86))) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles rotation 14";
			end
		end
		if ((v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v94.TemporalWarpBuff) or (v13:ManaPercentage() < (431 - (275 + 146))) or not v94.ShiftingPower:IsAvailable()) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v114 >= (2 + 10))) or ((1125 - (29 + 35)) == (8230 - 6373))) then
			if (((8243 - 5483) > (6021 - 4657)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
				return "nether_tempest rotation 16";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (33 + 17)) and not v94.Evocation:IsAvailable() and (v114 > (1032 - (53 + 959)))) or ((5310 - (312 + 96)) <= (6239 - 2644))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((4137 - (147 + 138)) == (1192 - (813 + 86)))) then
				return "arcane_barrage rotation 18";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (64 + 6)) and v105 and v13:BloodlustUp() and (v94.TouchoftheMagi:CooldownRemains() > (8 - 3)) and (v114 > (512 - (18 + 474)))) or ((526 + 1033) == (14974 - 10386))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((5570 - (860 + 226)) == (1091 - (121 + 182)))) then
				return "arcane_barrage rotation 20";
			end
		end
		if (((563 + 4005) >= (5147 - (988 + 252))) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffUp(v94.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
			if (((141 + 1105) < (1087 + 2383)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles rotation 22";
			end
		end
		if (((6038 - (49 + 1921)) >= (1862 - (223 + 667))) and v94.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v94.NetherPrecisionBuff)) then
			if (((545 - (51 + 1)) < (6700 - 2807)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast rotation 24";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (128 - 68)) and v105 and (v94.TouchoftheMagi:CooldownRemains() > (1135 - (146 + 979))) and (v94.Evocation:CooldownRemains() > (12 + 28)) and (v114 > (625 - (311 + 294)))) or ((4107 - 2634) >= (1412 + 1920))) then
			if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((5494 - (496 + 947)) <= (2515 - (1233 + 125)))) then
				return "arcane_barrage rotation 26";
			end
		end
		if (((246 + 358) < (2585 + 296)) and v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ClearcastingBuff) and v13:BuffDown(v94.NetherPrecisionBuff) and (not v110 or not v108)) then
			if (v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff))) or ((171 + 729) == (5022 - (963 + 682)))) then
				return "arcane_missiles rotation 30";
			end
		end
		if (((3722 + 737) > (2095 - (504 + 1000))) and v94.ArcaneBlast:IsReady() and v33) then
			if (((2289 + 1109) >= (2182 + 213)) and v21(v94.ArcaneBlast, not v14:IsSpellInRange(v94.ArcaneBlast), v13:BuffDown(v94.IceFloes))) then
				return "arcane_blast rotation 32";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34) or ((206 + 1977) >= (4163 - 1339))) then
			if (((1655 + 281) == (1126 + 810)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
				return "arcane_barrage rotation 34";
			end
		end
	end
	local function v128()
		if ((v94.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v114) and (not v94.Evocation:IsAvailable() or (v94.Evocation:CooldownRemains() > (194 - (156 + 26)))) and (not v94.ArcaneSurge:IsAvailable() or (v94.ArcaneSurge:CooldownRemains() > (7 + 5))) and (not v94.TouchoftheMagi:IsAvailable() or (v94.TouchoftheMagi:CooldownRemains() > (18 - 6))) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((not v94.ChargedOrb:IsAvailable() and (v94.ArcaneOrb:CooldownRemains() > (176 - (149 + 15)))) or (v94.ArcaneOrb:Charges() == (960 - (890 + 70))) or (v94.ArcaneOrb:CooldownRemains() > (129 - (39 + 78))))) or ((5314 - (14 + 468)) < (9484 - 5171))) then
			if (((11426 - 7338) > (1999 + 1875)) and v21(v94.ShiftingPower, not v14:IsInRange(25 + 15), true)) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if (((921 + 3411) == (1957 + 2375)) and v94.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v94.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v94.ArcaneSurgeBuff) and ((v101 > (2 + 4)) or (v102 > (11 - 5)) or not v94.OrbBarrage:IsAvailable())) then
			if (((3953 + 46) >= (10190 - 7290)) and v21(v94.NetherTempest, not v14:IsSpellInRange(v94.NetherTempest), v13:BuffDown(v94.IceFloes))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if ((v94.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v94.ArcaneArtilleryBuff) and v13:BuffUp(v94.ClearcastingBuff) and (v94.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v94.ArcaneArtilleryBuff) + 1 + 4))) or ((2576 - (12 + 39)) > (3781 + 283))) then
			if (((13529 - 9158) == (15567 - 11196)) and v21(v94.ArcaneMissiles, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes) and not (v94.Slipstream:IsAvailable() and v13:BuffUp(v94.ClearcastingBuff)))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if ((v94.ArcaneBarrage:IsReady() and v34 and ((v101 <= (2 + 2)) or (v102 <= (3 + 1)) or v13:BuffUp(v94.ClearcastingBuff)) and (v13:ArcaneCharges() == (7 - 4))) or ((178 + 88) > (24096 - 19110))) then
			if (((3701 - (1596 + 114)) >= (2414 - 1489)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false)) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if (((1168 - (164 + 549)) < (3491 - (1059 + 379))) and v94.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v114) and (v13:ArcaneCharges() == (0 - 0)) and (v94.TouchoftheMagi:CooldownRemains() > (10 + 8))) then
			if (v21(v94.ArcaneOrb, not v14:IsInRange(7 + 33)) or ((1218 - (145 + 247)) == (3981 + 870))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if (((85 + 98) == (542 - 359)) and v94.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (2 + 8)))) then
			if (((999 + 160) <= (2902 - 1114)) and v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v94.ArcaneExplosion:IsCastable() and v35) or ((4227 - (254 + 466)) > (4878 - (544 + 16)))) then
			if (v21(v94.ArcaneExplosion, not v14:IsInRange(31 - 21)) or ((3703 - (294 + 334)) <= (3218 - (236 + 17)))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v129()
		local v141 = 0 + 0;
		while true do
			if (((1063 + 302) <= (7573 - 5562)) and ((0 - 0) == v141)) then
				if ((v94.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v114) and (v13:PrevGCDP(1 + 0, v94.ArcaneBarrage))) or ((2287 + 489) > (4369 - (413 + 381)))) then
					if (v21(v94.TouchoftheMagi, not v14:IsSpellInRange(v94.TouchoftheMagi), v13:BuffDown(v94.IceFloes)) or ((108 + 2446) == (10217 - 5413))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((6693 - 4116) == (4547 - (582 + 1388))) and v13:IsChanneling(v94.Evocation) and (((v13:ManaPercentage() >= (161 - 66)) and not v94.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v114 * (3 + 1))) and not ((v114 > (374 - (326 + 38))) and (v94.ArcaneSurge:CooldownRemains() < (2 - 1)))))) then
					if (v21(v96.StopCasting, not v14:IsSpellInRange(v94.ArcaneMissiles), v13:BuffDown(v94.IceFloes)) or ((8 - 2) >= (2509 - (47 + 573)))) then
						return "cancel_action evocation main 32";
					end
				end
				if (((179 + 327) <= (8035 - 6143)) and v94.ArcaneBarrage:IsReady() and v34 and (v114 < (2 - 0))) then
					if (v21(v94.ArcaneBarrage, not v14:IsSpellInRange(v94.ArcaneBarrage), false) or ((3672 - (1269 + 395)) > (2710 - (76 + 416)))) then
						return "arcane_barrage main 34";
					end
				end
				v141 = 444 - (319 + 124);
			end
			if (((866 - 487) <= (5154 - (564 + 443))) and ((5 - 3) == v141)) then
				if ((v95.ManaGem:IsReady() and v41 and not v94.CascadingPower:IsAvailable() and v13:PrevGCDP(459 - (337 + 121), v94.ArcaneSurge) and (not v109 or (v109 and v13:PrevGCDP(5 - 3, v94.ArcaneSurge)))) or ((15036 - 10522) <= (2920 - (1261 + 650)))) then
					if (v21(v96.ManaGem) or ((1480 + 2016) == (1899 - 707))) then
						return "mana_gem main 42";
					end
				end
				if ((not v110 and ((v94.ArcaneSurge:CooldownRemains() <= (v115 * ((1818 - (772 + 1045)) + v24(v94.NetherTempest:IsAvailable() and v94.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v94.ArcaneSurgeBuff) > ((1 + 2) * v24(v13:HasTier(174 - (102 + 42), 1846 - (1524 + 320)) and not v13:HasTier(1300 - (1049 + 221), 160 - (18 + 138))))) or v13:BuffUp(v94.ArcaneOverloadBuff)) and (v94.Evocation:CooldownRemains() > (110 - 65)) and ((v94.TouchoftheMagi:CooldownRemains() < (v115 * (1106 - (67 + 1035)))) or (v94.TouchoftheMagi:CooldownRemains() > (368 - (136 + 212)))) and ((v101 < v104) or (v102 < v104))) or ((883 - 675) == (2371 + 588))) then
					v27 = v122();
					if (((3943 + 334) >= (2917 - (240 + 1364))) and v27) then
						return v27;
					end
				end
				if (((3669 - (1050 + 32)) < (11332 - 8158)) and not v110 and (v94.ArcaneSurge:CooldownRemains() > (18 + 12)) and (v94.RadiantSpark:CooldownUp() or v14:DebuffUp(v94.RadiantSparkDebuff) or v14:DebuffUp(v94.RadiantSparkVulnerability)) and ((v94.TouchoftheMagi:CooldownRemains() <= (v115 * (1058 - (331 + 724)))) or v14:DebuffUp(v94.TouchoftheMagiDebuff)) and ((v101 < v104) or (v102 < v104))) then
					local v209 = 0 + 0;
					while true do
						if ((v209 == (644 - (269 + 375))) or ((4845 - (267 + 458)) <= (684 + 1514))) then
							v27 = v122();
							if (v27 or ((3068 - 1472) == (1676 - (667 + 151)))) then
								return v27;
							end
							break;
						end
					end
				end
				v141 = 1500 - (1410 + 87);
			end
			if (((5117 - (1504 + 393)) == (8703 - 5483)) and (v141 == (7 - 4))) then
				if ((v30 and v94.RadiantSpark:IsAvailable() and v106) or ((2198 - (461 + 335)) > (463 + 3157))) then
					v27 = v124();
					if (((4335 - (1730 + 31)) == (4241 - (728 + 939))) and v27) then
						return v27;
					end
				end
				if (((6367 - 4569) < (5592 - 2835)) and v30 and v110 and v94.RadiantSpark:IsAvailable() and v107) then
					v27 = v123();
					if (v27 or ((863 - 486) > (3672 - (138 + 930)))) then
						return v27;
					end
				end
				if (((520 + 48) < (713 + 198)) and v30 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 >= v104) or (v102 >= v104))) then
					v27 = v126();
					if (((2816 + 469) < (17263 - 13035)) and v27) then
						return v27;
					end
				end
				v141 = 1770 - (459 + 1307);
			end
			if (((5786 - (474 + 1396)) > (5811 - 2483)) and ((1 + 0) == v141)) then
				if (((9 + 2491) < (10996 - 7157)) and v94.Evocation:IsCastable() and v40 and not v108 and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (2 + 8)) and (v94.TouchoftheMagi:CooldownRemains() < (66 - 46))) or (v94.TouchoftheMagi:CooldownRemains() < (65 - 50))) and (v13:ManaPercentage() < (v114 * (595 - (562 + 29))))) then
					if (((433 + 74) == (1926 - (374 + 1045))) and v21(v94.Evocation)) then
						return "evocation main 36";
					end
				end
				if (((190 + 50) <= (9828 - 6663)) and v94.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v94.TouchoftheMagiDebuff) and v13:BuffDown(v94.ArcaneSurgeBuff) and (v94.ArcaneSurge:CooldownRemains() < (668 - (448 + 190))) and (v94.ArcaneSurge:CooldownRemains() < v114) and not v95.ManaGem:Exists()) then
					if (((270 + 564) >= (364 + 441)) and v21(v94.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v95.ManaGem:IsReady() and v41 and v94.CascadingPower:IsAvailable() and (v13:BuffStack(v94.ClearcastingBuff) < (2 + 0)) and v13:BuffUp(v94.ArcaneSurgeBuff)) or ((14656 - 10844) < (7196 - 4880))) then
					if (v21(v96.ManaGem) or ((4146 - (1307 + 187)) <= (6079 - 4546))) then
						return "mana_gem main 40";
					end
				end
				v141 = 4 - 2;
			end
			if ((v141 == (11 - 7)) or ((4281 - (232 + 451)) < (1395 + 65))) then
				if ((v30 and v110 and v14:DebuffUp(v94.TouchoftheMagiDebuff) and ((v101 < v104) or (v102 < v104))) or ((3637 + 479) < (1756 - (510 + 54)))) then
					v27 = v125();
					if (v27 or ((6803 - 3426) <= (939 - (13 + 23)))) then
						return v27;
					end
				end
				if (((7749 - 3773) >= (630 - 191)) and ((v101 >= v104) or (v102 >= v104))) then
					v27 = v128();
					if (((6816 - 3064) == (4840 - (830 + 258))) and v27) then
						return v27;
					end
				end
				if (((14272 - 10226) > (1687 + 1008)) and ((v101 < v104) or (v102 < v104))) then
					v27 = v127();
					if (v27 or ((3017 + 528) == (4638 - (860 + 581)))) then
						return v27;
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
		v64 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
		v65 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
		v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (241 - (237 + 4));
		v67 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v68 = EpicSettings.Settings['iceColdHP'] or (0 - 0);
		v69 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
		v70 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v89 = EpicSettings.Settings['useSpellStealTarget'];
		v90 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v91 = EpicSettings.Settings['mirrorImageBeforePull'];
		v93 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v131()
		local v178 = 0 + 0;
		while true do
			if (((9038 - 6644) > (161 + 212)) and ((2 + 1) == v178)) then
				v82 = EpicSettings.Settings['trinketsWithCD'];
				v83 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v178 = 1430 - (85 + 1341);
			end
			if (((7089 - 2934) <= (11951 - 7719)) and (v178 == (377 - (45 + 327)))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v178 == (3 - 1)) or ((4083 - (444 + 58)) == (1510 + 1963))) then
				v71 = EpicSettings.Settings['DispelBuffs'];
				v81 = EpicSettings.Settings['useTrinkets'];
				v80 = EpicSettings.Settings['useRacials'];
				v178 = 1 + 2;
			end
			if (((2442 + 2553) > (9702 - 6354)) and (v178 == (1732 - (64 + 1668)))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (1973 - (1227 + 746));
				v79 = EpicSettings.Settings['useWeapon'];
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v178 = 2 - 1;
			end
			if ((v178 == (1 - 0)) or ((1248 - (415 + 79)) > (96 + 3628))) then
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v178 = 493 - (142 + 349);
			end
			if (((93 + 124) >= (78 - 21)) and ((2 + 2) == v178)) then
				v84 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v178 = 1869 - (1710 + 154);
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
		if (v13:IsDeadOrGhost() or ((2388 - (200 + 118)) >= (1600 + 2437))) then
			return v27;
		end
		v100 = v14:GetEnemiesInSplashRange(8 - 3);
		v103 = v13:GetEnemiesInRange(59 - 19);
		if (((2404 + 301) == (2676 + 29)) and v29) then
			v101 = v26(v14:GetEnemiesInSplashRangeCount(3 + 2), #v103);
			v102 = #v103;
		else
			local v189 = 0 + 0;
			while true do
				if (((132 - 71) == (1311 - (363 + 887))) and (v189 == (0 - 0))) then
					v101 = 4 - 3;
					v102 = 1 + 0;
					break;
				end
			end
		end
		if (v98.TargetIsValid() or v13:AffectingCombat() or ((1635 - 936) >= (886 + 410))) then
			local v190 = 1664 - (674 + 990);
			while true do
				if ((v190 == (1 + 0)) or ((730 + 1053) >= (5731 - 2115))) then
					v114 = v113;
					if ((v114 == (12166 - (507 + 548))) or ((4750 - (289 + 548)) > (6345 - (821 + 997)))) then
						v114 = v10.FightRemains(v103, false);
					end
					break;
				end
				if (((4631 - (195 + 60)) > (220 + 597)) and (v190 == (1501 - (251 + 1250)))) then
					if (((14240 - 9379) > (567 + 257)) and (v13:AffectingCombat() or v72)) then
						local v213 = 1032 - (809 + 223);
						local v214;
						while true do
							if ((v213 == (0 - 0)) or ((4153 - 2770) >= (7046 - 4915))) then
								v214 = v72 and v94.RemoveCurse:IsReady() and v32;
								v27 = v98.FocusUnit(v214, nil, 15 + 5, nil, 11 + 9, v94.ArcaneIntellect);
								v213 = 618 - (14 + 603);
							end
							if ((v213 == (130 - (118 + 11))) or ((304 + 1572) >= (2117 + 424))) then
								if (((5193 - 3411) <= (4721 - (551 + 398))) and v27) then
									return v27;
								end
								break;
							end
						end
					end
					v113 = v10.BossFightRemains(nil, true);
					v190 = 1 + 0;
				end
			end
		end
		v115 = v13:GCD();
		if (v73 or ((1673 + 3027) < (661 + 152))) then
			if (((11897 - 8698) < (9331 - 5281)) and v93) then
				v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 10 + 20);
				if (v27 or ((19654 - 14703) < (1224 + 3206))) then
					return v27;
				end
			end
		end
		if (((185 - (40 + 49)) == (365 - 269)) and (not v13:AffectingCombat() or v28)) then
			if ((v94.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v94.ArcaneIntellect, true) or v98.GroupBuffMissing(v94.ArcaneIntellect))) or ((3229 - (99 + 391)) > (3316 + 692))) then
				if (v21(v94.ArcaneIntellect) or ((101 - 78) == (2807 - 1673))) then
					return "arcane_intellect group_buff";
				end
			end
			if ((v94.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v94.ArcaneFamiliarBuff)) or ((2624 + 69) >= (10817 - 6706))) then
				if (v21(v94.ArcaneFamiliar) or ((5920 - (1032 + 572)) <= (2563 - (203 + 214)))) then
					return "arcane_familiar precombat 2";
				end
			end
			if ((v94.ConjureManaGem:IsCastable() and v39) or ((5363 - (568 + 1249)) <= (2198 + 611))) then
				if (((11778 - 6874) > (8366 - 6200)) and v21(v94.ConjureManaGem)) then
					return "conjure_mana_gem precombat 4";
				end
			end
		end
		if (((1415 - (913 + 393)) >= (254 - 164)) and v98.TargetIsValid()) then
			if (((7033 - 2055) > (3315 - (269 + 141))) and v72 and v32 and v94.RemoveCurse:IsAvailable()) then
				if (v15 or ((6730 - 3704) <= (4261 - (362 + 1619)))) then
					local v210 = 1625 - (950 + 675);
					while true do
						if ((v210 == (0 + 0)) or ((2832 - (216 + 963)) <= (2395 - (485 + 802)))) then
							v27 = v118();
							if (((3468 - (432 + 127)) > (3682 - (1065 + 8))) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (((421 + 336) > (1795 - (635 + 966))) and v16 and v16:Exists() and v16:IsAPlayer() and v98.UnitHasCurseDebuff(v16)) then
					if (v94.RemoveCurse:IsReady() or ((23 + 8) >= (1440 - (5 + 37)))) then
						if (((7948 - 4752) <= (2028 + 2844)) and v21(v96.RemoveCurseMouseover)) then
							return "remove_curse dispel";
						end
					end
				end
			end
			if (((5264 - 1938) == (1557 + 1769)) and not v13:AffectingCombat() and v28) then
				local v205 = 0 - 0;
				while true do
					if (((5432 - 3999) <= (7313 - 3435)) and (v205 == (0 - 0))) then
						v27 = v120();
						if (v27 or ((1139 + 444) == (2264 - (318 + 211)))) then
							return v27;
						end
						break;
					end
				end
			end
			v27 = v116();
			if (v27 or ((14667 - 11686) == (3937 - (963 + 624)))) then
				return v27;
			end
			if (v73 or ((1909 + 2557) <= (1339 - (518 + 328)))) then
				if (v93 or ((5937 - 3390) <= (3175 - 1188))) then
					local v211 = 317 - (301 + 16);
					while true do
						if (((8678 - 5717) > (7695 - 4955)) and ((0 - 0) == v211)) then
							v27 = v98.HandleAfflicted(v94.RemoveCurse, v96.RemoveCurseMouseover, 28 + 2);
							if (((2099 + 1597) >= (7711 - 4099)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
			end
			if (v74 or ((1787 + 1183) == (179 + 1699))) then
				v27 = v98.HandleIncorporeal(v94.Polymorph, v96.PolymorphMouseover, 95 - 65);
				if (v27 or ((1192 + 2501) < (2996 - (829 + 190)))) then
					return v27;
				end
			end
			if ((v94.Spellsteal:IsAvailable() and v89 and v94.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v98.UnitHasMagicBuff(v14)) or ((3318 - 2388) > (2658 - 557))) then
				if (((5740 - 1587) > (7665 - 4579)) and v21(v94.Spellsteal, not v14:IsSpellInRange(v94.Spellsteal))) then
					return "spellsteal damage";
				end
			end
			if ((not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v98.TargetIsValid()) or ((1103 + 3551) <= (1323 + 2727))) then
				local v206 = 0 - 0;
				local v207;
				while true do
					if ((v206 == (2 + 0)) or ((3215 - (520 + 93)) < (1772 - (259 + 17)))) then
						if (v27 or ((59 + 961) > (824 + 1464))) then
							return v27;
						end
						v27 = v129();
						if (((1110 - 782) == (919 - (396 + 195))) and v27) then
							return v27;
						end
						break;
					end
					if (((4383 - 2872) < (5569 - (440 + 1321))) and (v206 == (1829 - (1059 + 770)))) then
						if ((v30 and v79 and (v95.Dreambinder:IsEquippedAndReady() or v95.Iridal:IsEquippedAndReady())) or ((11606 - 9096) > (5464 - (424 + 121)))) then
							if (((869 + 3894) == (6110 - (641 + 706))) and v21(v96.UseWeapon, nil)) then
								return "Using Weapon Macro";
							end
						end
						v207 = v98.HandleDPSPotion(not v94.ArcaneSurge:IsReady());
						if (((1639 + 2498) > (2288 - (249 + 191))) and v207) then
							return v207;
						end
						if (((10611 - 8175) <= (1400 + 1734)) and v13:IsMoving() and v94.IceFloes:IsReady() and not v13:BuffUp(v94.IceFloes)) then
							if (((14348 - 10625) == (4150 - (183 + 244))) and v21(v94.IceFloes)) then
								return "ice_floes movement";
							end
						end
						v206 = 1 + 0;
					end
					if ((v206 == (731 - (434 + 296))) or ((12911 - 8865) >= (4828 - (169 + 343)))) then
						if ((v90 and v94.TimeWarp:IsReady() and v94.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v94.ArcaneSurge:CooldownUp() or (v114 <= (36 + 4)) or (v13:BuffUp(v94.ArcaneSurgeBuff) and (v114 <= (v94.ArcaneSurge:CooldownRemains() + (24 - 10)))))) or ((5893 - 3885) < (1581 + 348))) then
							if (((6761 - 4377) > (2898 - (651 + 472))) and v21(v94.TimeWarp, not v14:IsInRange(31 + 9))) then
								return "time_warp main 4";
							end
						end
						if ((v80 and ((v83 and v30) or not v83) and (v78 < v114)) or ((1961 + 2582) <= (5340 - 964))) then
							if (((1211 - (397 + 86)) == (1604 - (423 + 453))) and v94.LightsJudgment:IsCastable() and v13:BuffDown(v94.ArcaneSurgeBuff) and v14:DebuffDown(v94.TouchoftheMagiDebuff) and ((v101 >= (1 + 1)) or (v102 >= (1 + 1)))) then
								if (v21(v94.LightsJudgment, not v14:IsSpellInRange(v94.LightsJudgment)) or ((940 + 136) > (3728 + 943))) then
									return "lights_judgment main 6";
								end
							end
							if (((1654 + 197) >= (1568 - (50 + 1140))) and v94.Berserking:IsCastable() and ((v13:PrevGCDP(1 + 0, v94.ArcaneSurge) and not (v13:BuffUp(v94.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v94.ArcaneSurgeBuff) and v14:DebuffUp(v94.TouchoftheMagiDebuff)))) then
								if (v21(v94.Berserking) or ((1151 + 797) >= (217 + 3259))) then
									return "berserking main 8";
								end
							end
							if (((6883 - 2089) >= (603 + 230)) and v13:PrevGCDP(597 - (157 + 439), v94.ArcaneSurge)) then
								if (((7112 - 3022) == (13590 - 9500)) and v94.BloodFury:IsCastable()) then
									if (v21(v94.BloodFury) or ((11116 - 7358) == (3416 - (782 + 136)))) then
										return "blood_fury main 10";
									end
								end
								if (v94.Fireblood:IsCastable() or ((3528 - (112 + 743)) < (2746 - (1026 + 145)))) then
									if (v21(v94.Fireblood) or ((639 + 3082) <= (2173 - (493 + 225)))) then
										return "fireblood main 12";
									end
								end
								if (((3433 - 2499) < (1381 + 889)) and v94.AncestralCall:IsCastable()) then
									if (v21(v94.AncestralCall) or ((4321 - 2709) == (24 + 1231))) then
										return "ancestral_call main 14";
									end
								end
							end
						end
						if ((v78 < v114) or ((12437 - 8085) < (1225 + 2981))) then
							if ((v81 and ((v30 and v82) or not v82)) or ((4778 - 1918) <= (1776 - (210 + 1385)))) then
								local v215 = 1689 - (1201 + 488);
								while true do
									if (((1997 + 1225) >= (2715 - 1188)) and (v215 == (0 - 0))) then
										v27 = v119();
										if (((2090 - (352 + 233)) <= (5125 - 3004)) and v27) then
											return v27;
										end
										break;
									end
								end
							end
						end
						v27 = v121();
						v206 = 2 + 0;
					end
				end
			end
		end
	end
	local function v133()
		local v184 = 0 - 0;
		while true do
			if (((1318 - (489 + 85)) == (2245 - (277 + 1224))) and (v184 == (1493 - (663 + 830)))) then
				v99();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(55 + 7, v132, v133);
end;
return v0["Epix_Mage_Arcane.lua"]();

