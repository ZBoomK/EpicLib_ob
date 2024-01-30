local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1235 - (1184 + 51);
	local v6;
	while true do
		if ((v5 == (789 - (766 + 23))) or ((21603 - 17227) <= (2025 - 544))) then
			v6 = v0[v4];
			if (not v6 or ((8936 - 5544) >= (16091 - 11350))) then
				return v1(v4, ...);
			end
			v5 = 1074 - (1036 + 37);
		end
		if (((2358 + 967) >= (4194 - 2040)) and (v5 == (1 + 0))) then
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
		if (v93.RemoveCurse:IsAvailable() or ((2775 - (641 + 839)) >= (4146 - (910 + 3)))) then
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
	local v103 = 7 - 4;
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v13:HasTier(1713 - (1466 + 218), 2 + 2);
	local v110 = (226148 - (556 + 592)) - (((8890 + 16110) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((200808 - (329 + 479)) * v24(not v109)));
	local v111 = 857 - (174 + 680);
	local v112 = 38179 - 27068;
	local v113 = 23029 - 11918;
	local v114;
	v10:RegisterForEvent(function()
		v104 = false;
		v107 = true;
		v110 = (160644 + 64356) - (((25739 - (396 + 343)) * v24(not v93.ArcaneHarmony:IsAvailable())) + ((17696 + 182304) * v24(not v109)));
		v112 = 12588 - (29 + 1448);
		v113 = 12500 - (135 + 1254);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v109 = not v13:HasTier(109 - 80, 18 - 14);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		if (((2917 + 1460) > (3169 - (389 + 1138))) and v93.PrismaticBarrier:IsCastable() and v58 and v13:BuffDown(v93.PrismaticBarrier) and (v13:HealthPercentage() <= v65)) then
			if (((5297 - (102 + 472)) > (1280 + 76)) and v21(v93.PrismaticBarrier)) then
				return "ice_barrier defensive 1";
			end
		end
		if ((v93.MassBarrier:IsCastable() and v62 and v13:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v70, 2 + 0)) or ((3857 + 279) <= (4978 - (320 + 1225)))) then
			if (((7556 - 3311) <= (2834 + 1797)) and v21(v93.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if (((5740 - (157 + 1307)) >= (5773 - (821 + 1038))) and v93.IceBlock:IsCastable() and v60 and (v13:HealthPercentage() <= v67)) then
			if (((493 - 295) <= (478 + 3887)) and v21(v93.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if (((8493 - 3711) > (1740 + 2936)) and v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v61 and (v13:HealthPercentage() <= v68)) then
			if (((12055 - 7191) > (3223 - (834 + 192))) and v21(v93.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v93.MirrorImage:IsCastable() and v63 and (v13:HealthPercentage() <= v69)) or ((236 + 3464) == (644 + 1863))) then
			if (((97 + 4377) >= (423 - 149)) and v21(v93.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if ((v93.GreaterInvisibility:IsReady() and v59 and (v13:HealthPercentage() <= v66)) or ((2198 - (300 + 4)) <= (376 + 1030))) then
			if (((4114 - 2542) >= (1893 - (112 + 250))) and v21(v93.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if ((v93.AlterTime:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or ((1869 + 2818) < (11378 - 6836))) then
			if (((1886 + 1405) > (863 + 804)) and v21(v93.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v94.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v86)) or ((653 + 220) == (1009 + 1025))) then
			if (v21(v95.Healthstone) or ((2092 + 724) < (1425 - (1001 + 413)))) then
				return "healthstone defensive";
			end
		end
		if (((8248 - 4549) < (5588 - (244 + 638))) and v83 and (v13:HealthPercentage() <= v85)) then
			local v179 = 693 - (627 + 66);
			while true do
				if (((7884 - 5238) >= (1478 - (512 + 90))) and (v179 == (1906 - (1665 + 241)))) then
					if (((1331 - (373 + 344)) <= (1437 + 1747)) and (v87 == "Refreshing Healing Potion")) then
						if (((828 + 2298) == (8245 - 5119)) and v94.RefreshingHealingPotion:IsReady()) then
							if (v21(v95.RefreshingHealingPotion) or ((3700 - 1513) >= (6053 - (35 + 1064)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v87 == "Dreamwalker's Healing Potion") or ((2821 + 1056) == (7648 - 4073))) then
						if (((3 + 704) > (1868 - (298 + 938))) and v94.DreamwalkersHealingPotion:IsReady()) then
							if (v21(v95.RefreshingHealingPotion) or ((1805 - (233 + 1026)) >= (4350 - (636 + 1030)))) then
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
		if (((750 + 715) <= (4202 + 99)) and v93.RemoveCurse:IsReady() and v97.DispellableFriendlyUnit(6 + 14)) then
			if (((116 + 1588) > (1646 - (55 + 166))) and v21(v95.RemoveCurseFocus)) then
				return "remove_curse dispel";
			end
		end
	end
	local function v117()
		v27 = v97.HandleTopTrinket(v96, v30, 8 + 32, nil);
		if (v27 or ((70 + 617) == (16169 - 11935))) then
			return v27;
		end
		v27 = v97.HandleBottomTrinket(v96, v30, 337 - (36 + 261), nil);
		if (v27 or ((5823 - 2493) < (2797 - (34 + 1334)))) then
			return v27;
		end
	end
	local function v118()
		local v132 = 0 + 0;
		while true do
			if (((892 + 255) >= (1618 - (1035 + 248))) and (v132 == (22 - (20 + 1)))) then
				if (((1790 + 1645) > (2416 - (134 + 185))) and v93.Evocation:IsReady() and v40 and (v93.SiphonStorm:IsAvailable())) then
					if (v21(v93.Evocation) or ((4903 - (549 + 584)) >= (4726 - (314 + 371)))) then
						return "evocation precombat 6";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54)) or ((13014 - 9223) <= (2579 - (478 + 490)))) then
					if (v21(v93.ArcaneOrb, not v14:IsInRange(22 + 18)) or ((5750 - (786 + 386)) <= (6503 - 4495))) then
						return "arcane_orb precombat 8";
					end
				end
				v132 = 1381 - (1055 + 324);
			end
			if (((2465 - (1093 + 247)) <= (1845 + 231)) and (v132 == (1 + 1))) then
				if ((v93.ArcaneBlast:IsReady() and v33) or ((2949 - 2206) >= (14929 - 10530))) then
					if (((3286 - 2131) < (4203 - 2530)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if ((v132 == (0 + 0)) or ((8953 - 6629) <= (1992 - 1414))) then
				if (((2841 + 926) == (9633 - 5866)) and v93.MirrorImage:IsCastable() and v90 and v63) then
					if (((4777 - (364 + 324)) == (11209 - 7120)) and v21(v93.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				if (((10697 - 6239) >= (555 + 1119)) and v93.ArcaneBlast:IsReady() and v33 and not v93.SiphonStorm:IsAvailable()) then
					if (((4067 - 3095) <= (2270 - 852)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 4";
					end
				end
				v132 = 2 - 1;
			end
		end
	end
	local function v119()
		local v133 = 1268 - (1249 + 19);
		while true do
			if ((v133 == (1 + 0)) or ((19221 - 14283) < (5848 - (686 + 400)))) then
				if ((v14:DebuffUp(v93.TouchoftheMagiDebuff) and v107) or ((1965 + 539) > (4493 - (73 + 156)))) then
					v107 = false;
				end
				v108 = v93.ArcaneBlast:CastTime() < v114;
				break;
			end
			if (((11 + 2142) == (2964 - (721 + 90))) and (v133 == (0 + 0))) then
				if ((((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (0 - 0)) or (v13:ArcaneCharges() >= (473 - (224 + 246)))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 - 0)))) or ((933 - 426) >= (470 + 2121))) then
					v105 = true;
				elseif (((107 + 4374) == (3292 + 1189)) and v105 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (13 - 6)) and v93.RadiantSpark:CooldownDown()) then
					v105 = false;
				end
				if (((v13:ArcaneCharges() > (9 - 6)) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (520 - (203 + 310)))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (1998 - (1238 + 755)))) or (v93.ArcaneSurge:CooldownRemains() > (3 + 37)))) or ((3862 - (709 + 825)) < (1276 - 583))) then
					v106 = true;
				elseif (((6304 - 1976) == (5192 - (196 + 668))) and v106 and v14:DebuffDown(v93.RadiantSparkVulnerability) and (v14:DebuffRemains(v93.RadiantSparkDebuff) < (27 - 20)) and v93.RadiantSpark:CooldownDown()) then
					v106 = false;
				end
				v133 = 1 - 0;
			end
		end
	end
	local function v120()
		if (((2421 - (171 + 662)) >= (1425 - (4 + 89))) and v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(3 - 2, v93.ArcaneBarrage))) then
			if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((1520 + 2654) > (18658 - 14410))) then
				return "touch_of_the_magi cooldown_phase 2";
			end
		end
		if (v93.RadiantSpark:CooldownUp() or ((1799 + 2787) <= (1568 - (35 + 1451)))) then
			v104 = v93.ArcaneSurge:CooldownRemains() < (1463 - (28 + 1425));
		end
		if (((5856 - (941 + 1052)) == (3705 + 158)) and v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) then
			if (v21(v93.ShiftingPower, not v14:IsInRange(1554 - (822 + 692)), true) or ((402 - 120) <= (20 + 22))) then
				return "shifting_power cooldown_phase 4";
			end
		end
		if (((4906 - (45 + 252)) >= (758 + 8)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and v93.RadiantSpark:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) then
			if (v21(v93.ArcaneOrb, not v14:IsInRange(14 + 26)) or ((2803 - 1651) == (2921 - (114 + 319)))) then
				return "arcane_orb cooldown_phase 6";
			end
		end
		if (((4912 - 1490) > (4292 - 942)) and v93.ArcaneBlast:IsReady() and v33 and v93.RadiantSpark:CooldownUp() and ((v13:ArcaneCharges() < (2 + 0)) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) then
			if (((1305 - 428) > (787 - 411)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 8";
			end
		end
		if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (1963 - (556 + 1407))) and (v13:ManaPercentage() > (1236 - (741 + 465))) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((3583 - (170 + 295)) <= (976 + 875))) then
			if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((152 + 13) >= (8597 - 5105))) then
				return "arcane_missiles interrupt cooldown_phase 10";
			end
		end
		if (((3274 + 675) < (3115 + 1741)) and v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (3 + 2)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (1236 - (957 + 273))))) and v13:HasTier(9 + 22, 2 + 2)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((16293 - 12017) < (7947 - 4931))) then
				return "arcane_missiles cooldown_phase 10";
			end
		end
		if (((14325 - 9635) > (20425 - 16300)) and v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (1797 - (389 + 1391))) and not v13:HasTier(19 + 11, 1 + 3)) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((113 - 63) >= (1847 - (783 + 168)))) then
				return "arcane_blast cooldown_phase 12";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (6 - 4)) and (v93.RadiantSpark:CooldownRemains() < (5 + 0)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (317 - (309 + 2))))) and not v13:HasTier(92 - 62, 1216 - (1090 + 122))) or ((556 + 1158) >= (9934 - 6976))) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1021 + 470) < (1762 - (628 + 490)))) then
				return "arcane_missiles cooldown_phase 14";
			end
		end
		if (((127 + 577) < (2443 - 1456)) and v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (68 - 53)) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (779 - (431 + 343))))) and (v93.ArcaneSurge:CooldownRemains() < (60 - 30))) then
			if (((10755 - 7037) > (1506 + 400)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 16";
			end
		end
		if ((v93.ArcaneMissiles:IsReady() and v38 and v93.RadiantSpark:CooldownUp() and v13:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v13:BuffDown(v93.NetherPrecisionBuff) or (v13:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v13:HasTier(4 + 26, 1699 - (556 + 1139))) or ((973 - (6 + 9)) > (666 + 2969))) then
			if (((1794 + 1707) <= (4661 - (28 + 141))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 18";
			end
		end
		if ((v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) or ((1334 + 2108) < (3144 - 596))) then
			if (((2037 + 838) >= (2781 - (486 + 831))) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true)) then
				return "radiant_spark cooldown_phase 20";
			end
		end
		if ((v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (78 - 48)) and (v93.ArcaneEcho:IsAvailable())) or ((16888 - 12091) >= (925 + 3968))) then
			if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((1742 - 1191) > (3331 - (668 + 595)))) then
				return "nether_tempest cooldown_phase 22";
			end
		end
		if (((1903 + 211) > (191 + 753)) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) then
			if (v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge)) or ((6168 - 3906) >= (3386 - (23 + 267)))) then
				return "arcane_surge cooldown_phase 24";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:PrevGCDP(1945 - (1129 + 815), v93.ArcaneSurge) or v13:PrevGCDP(388 - (371 + 16), v93.NetherTempest) or v13:PrevGCDP(1751 - (1326 + 424), v93.RadiantSpark))) or ((4270 - 2015) >= (12925 - 9388))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((3955 - (88 + 30)) < (2077 - (720 + 51)))) then
				return "arcane_barrage cooldown_phase 26";
			end
		end
		if (((6562 - 3612) == (4726 - (421 + 1355))) and v93.ArcaneBlast:IsReady() and v33 and v14:DebuffUp(v93.RadiantSparkVulnerability) and (v14:DebuffStack(v93.RadiantSparkVulnerability) < (6 - 2))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2321 + 2402) < (4381 - (286 + 797)))) then
				return "arcane_blast cooldown_phase 28";
			end
		end
		if (((4152 - 3016) >= (254 - 100)) and v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
			if (v21(v93.PresenceofMind) or ((710 - (397 + 42)) > (1483 + 3265))) then
				return "presence_of_mind cooldown_phase 30";
			end
		end
		if (((5540 - (24 + 776)) >= (4855 - 1703)) and v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.PresenceofMindBuff))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3363 - (222 + 563)) >= (7469 - 4079))) then
				return "arcane_blast cooldown_phase 32";
			end
		end
		if (((30 + 11) <= (1851 - (23 + 167))) and v93.ArcaneMissiles:IsReady() and v38 and v13:BuffDown(v93.NetherPrecisionBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v14:DebuffDown(v93.RadiantSparkVulnerability) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1802 - (690 + 1108))) and v13:PrevGCDP(1 + 0, v93.ArcaneBlast)))) then
			if (((496 + 105) < (4408 - (40 + 808))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles cooldown_phase 34";
			end
		end
		if (((39 + 196) < (2626 - 1939)) and v93.ArcaneBlast:IsReady() and v33) then
			if (((4348 + 201) > (610 + 543)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast cooldown_phase 36";
			end
		end
	end
	local function v121()
		if ((v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (25 + 20)) and v14:DebuffDown(v93.NetherTempestDebuff) and v107 and v13:BloodlustUp()) or ((5245 - (47 + 524)) < (3032 + 1640))) then
			if (((10026 - 6358) < (6819 - 2258)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest spark_phase 2";
			end
		end
		if ((v107 and v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((2181 - (1165 + 561)) == (108 + 3497))) then
			if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((8247 - 5584) == (1264 + 2048))) then
				return "arcane_missiles interrupt spark_phase 4";
			end
		end
		if (((4756 - (341 + 138)) <= (1209 + 3266)) and v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (10 - 5)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffDown(v93.ArcaneArtilleryBuff) or (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (332 - (89 + 237))))) and v13:HasTier(99 - 68, 8 - 4)) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1751 - (581 + 300)) == (2409 - (855 + 365)))) then
				return "arcane_missiles spark_phase 4";
			end
		end
		if (((3688 - 2135) <= (1023 + 2110)) and v93.ArcaneBlast:IsReady() and v33 and v107 and v93.ArcaneSurge:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v110) and (v13:BuffRemains(v93.SiphonStormBuff) > (1250 - (1030 + 205)))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2101 + 136) >= (3267 + 244))) then
				return "arcane_blast spark_phase 6";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and v107 and v13:BloodlustUp() and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) >= (288 - (156 + 130))) and (v93.RadiantSpark:CooldownRemains() < (11 - 6)) and v13:BuffDown(v93.NetherPrecisionBuff) and (v13:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (9 - 3)))) or ((2711 - 1387) > (796 + 2224))) then
			if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1745 + 1247) == (1950 - (10 + 59)))) then
				return "arcane_missiles spark_phase 10";
			end
		end
		if (((879 + 2227) > (7515 - 5989)) and v93.ArcaneMissiles:IsReady() and v38 and v93.ArcaneHarmony:IsAvailable() and (v13:BuffStack(v93.ArcaneHarmonyBuff) < (1178 - (671 + 492))) and ((v107 and v13:BloodlustUp()) or (v13:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)))) and (v93.ArcaneSurge:CooldownRemains() < (1245 - (369 + 846)))) then
			if (((801 + 2222) < (3303 + 567)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles spark_phase 12";
			end
		end
		if (((2088 - (1036 + 909)) > (59 + 15)) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
			if (((30 - 12) < (2315 - (11 + 192))) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark))) then
				return "radiant_spark spark_phase 14";
			end
		end
		if (((555 + 542) <= (1803 - (135 + 40))) and v93.NetherTempest:IsReady() and v42 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (36 - 21)) and ((not v108 and v13:PrevGCDP(3 + 1, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v13:PrevGCDP(10 - 5, v93.RadiantSpark))) then
			if (((6940 - 2310) == (4806 - (50 + 126))) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest spark_phase 16";
			end
		end
		if (((9857 - 6317) > (594 + 2089)) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v13:PrevGCDP(1417 - (1233 + 180), v93.RadiantSpark) and not v108) or v13:PrevGCDP(974 - (522 + 447), v93.RadiantSpark))) or v13:PrevGCDP(1422 - (107 + 1314), v93.NetherTempest))) then
			if (((2225 + 2569) >= (9979 - 6704)) and v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge))) then
				return "arcane_surge spark_phase 18";
			end
		end
		if (((631 + 853) == (2946 - 1462)) and v93.ArcaneBlast:IsReady() and v33 and (v93.ArcaneBlast:CastTime() >= v13:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v14:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v14:HealthPercentage() >= (138 - 103))) and ((v93.NetherTempest:IsAvailable() and v13:PrevGCDP(1916 - (716 + 1194), v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v13:PrevGCDP(1 + 4, v93.RadiantSpark))) and not (v13:IsCasting(v93.ArcaneSurge) and (v13:CastRemains() < (0.5 + 0)) and not v108)) then
			if (((1935 - (74 + 429)) < (6857 - 3302)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast spark_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 2))) or ((2437 - 1372) > (2532 + 1046))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((14782 - 9987) < (3478 - 2071))) then
				return "arcane_barrage spark_phase 22";
			end
		end
		if (((2286 - (279 + 154)) < (5591 - (454 + 324))) and v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and v13:PrevGCDP(1 + 0, v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (17.2 - (12 + 5)))) or (v13:GCDRemains() <= (0.2 + 0)))) then
			if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((7187 - 4366) < (899 + 1532))) then
				return "touch_of_the_magi spark_phase 24";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33) or ((3967 - (277 + 816)) < (9319 - 7138))) then
			if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((3872 - (1058 + 125)) <= (65 + 278))) then
				return "arcane_blast spark_phase 26";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34) or ((2844 - (815 + 160)) == (8619 - 6610))) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((8417 - 4871) < (554 + 1768))) then
				return "arcane_barrage spark_phase 28";
			end
		end
	end
	local function v122()
		if ((v13:BuffUp(v93.PresenceofMindBuff) and v91 and (v13:PrevGCDP(2 - 1, v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (1973 - (41 + 1857)))) or ((3975 - (1222 + 671)) == (12335 - 7562))) then
			if (((4662 - 1418) > (2237 - (229 + 953))) and v21(v95.CancelPOM)) then
				return "cancel presence_of_mind aoe_spark_phase 1";
			end
		end
		if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1775 - (1111 + 663), v93.ArcaneBarrage))) or ((4892 - (874 + 705)) <= (249 + 1529))) then
			if (v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi)) or ((970 + 451) >= (4372 - 2268))) then
				return "touch_of_the_magi aoe_spark_phase 2";
			end
		end
		if (((51 + 1761) <= (3928 - (642 + 37))) and v93.RadiantSpark:IsReady() and v50 and ((v55 and v31) or not v55) and (v78 < v113)) then
			if (((371 + 1252) <= (314 + 1643)) and v21(v93.RadiantSpark, not v14:IsSpellInRange(v93.RadiantSpark), true)) then
				return "radiant_spark aoe_spark_phase 4";
			end
		end
		if (((11077 - 6665) == (4866 - (233 + 221))) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (34 - 19)) and (v13:ArcaneCharges() < (3 + 0))) then
			if (((3291 - (718 + 823)) >= (530 + 312)) and v21(v93.ArcaneOrb, not v14:IsInRange(845 - (266 + 539)))) then
				return "arcane_orb aoe_spark_phase 6";
			end
		end
		if (((12377 - 8005) > (3075 - (636 + 589))) and v93.NetherTempest:IsReady() and v42 and (v93.NetherTempest:TimeSinceLastCast() >= (35 - 20)) and (v93.ArcaneEcho:IsAvailable())) then
			if (((478 - 246) < (651 + 170)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest aoe_spark_phase 8";
			end
		end
		if (((189 + 329) < (1917 - (657 + 358))) and v93.ArcaneSurge:IsReady() and v47 and ((v52 and v30) or not v52) and (v78 < v113)) then
			if (((7927 - 4933) > (1954 - 1096)) and v21(v93.ArcaneSurge, not v14:IsSpellInRange(v93.ArcaneSurge))) then
				return "arcane_surge aoe_spark_phase 10";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (v93.ArcaneSurge:CooldownRemains() < (1262 - (1151 + 36))) and (v14:DebuffStack(v93.RadiantSparkVulnerability) == (4 + 0)) and not v93.OrbBarrage:IsAvailable()) or ((988 + 2767) <= (2732 - 1817))) then
			if (((5778 - (1552 + 280)) > (4577 - (64 + 770))) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 12";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 0)) and (v93.ArcaneSurge:CooldownRemains() > (170 - 95))) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 0)) and (v93.ArcaneSurge:CooldownRemains() < (1318 - (157 + 1086))) and not v93.OrbBarrage:IsAvailable()))) or ((2672 - 1337) >= (14479 - 11173))) then
			if (((7430 - 2586) > (3074 - 821)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 14";
			end
		end
		if (((1271 - (599 + 220)) == (899 - 447)) and v93.ArcaneBarrage:IsReady() and v34 and ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1932 - (1813 + 118))) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 0)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (1220 - (841 + 376))) and ((v100 > (6 - 1)) or (v101 > (2 + 3)))) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (10 - 6))) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) then
			if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((5416 - (464 + 395)) < (5355 - 3268))) then
				return "arcane_barrage aoe_spark_phase 16";
			end
		end
		if (((1861 + 2013) == (4711 - (467 + 370))) and v93.PresenceofMind:IsCastable() and v43) then
			if (v21(v93.PresenceofMind) or ((4004 - 2066) > (3623 + 1312))) then
				return "presence_of_mind aoe_spark_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v33 and ((((v14:DebuffStack(v93.RadiantSparkVulnerability) == (6 - 4)) or (v14:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 2))) and not v93.OrbBarrage:IsAvailable()) or (v14:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) or ((9899 - 5644) < (3943 - (150 + 370)))) then
			if (((2736 - (74 + 1208)) <= (6126 - 3635)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast aoe_spark_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and (((v14:DebuffStack(v93.RadiantSparkVulnerability) == (18 - 14)) and v13:BuffUp(v93.ArcaneSurgeBuff)) or ((v14:DebuffStack(v93.RadiantSparkVulnerability) == (3 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) or ((4547 - (14 + 376)) <= (4861 - 2058))) then
			if (((3141 + 1712) >= (2620 + 362)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_spark_phase 22";
			end
		end
	end
	local function v123()
		local v134 = 0 + 0;
		while true do
			if (((12113 - 7979) > (2526 + 831)) and (v134 == (79 - (23 + 55)))) then
				if ((v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or ((8097 - 4680) < (1691 + 843))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((2445 + 277) <= (253 - 89))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v14:HealthPercentage() < (12 + 23)))) and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) or ((3309 - (652 + 249)) < (5643 - 3534))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((1901 - (708 + 1160)) == (3949 - 2494))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (57 - (10 + 17))) and (v93.TouchoftheMagi:CooldownRemains() > (7 + 23))) or (v13:ManaPercentage() > (1802 - (1400 + 332)))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((849 - 406) >= (5923 - (242 + 1666)))) then
					if (((1448 + 1934) > (61 + 105)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if ((v93.ArcaneMissiles:IsCastable() and v38 and (v13:BuffStack(v93.ClearcastingBuff) > (1 + 0)) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) or ((1220 - (850 + 90)) == (5357 - 2298))) then
					if (((3271 - (360 + 1030)) > (1145 + 148)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				v134 = 5 - 3;
			end
			if (((3242 - 885) == (4018 - (909 + 752))) and (v134 == (1225 - (109 + 1114)))) then
				if (((225 - 102) == (48 + 75)) and v93.ArcaneBlast:IsReady() and v33 and (v13:BuffUp(v93.NetherPrecisionBuff))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((1298 - (6 + 236)) >= (2138 + 1254))) then
						return "arcane_blast touch_phase 14";
					end
				end
				if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) or ((871 + 210) < (2535 - 1460))) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1831 - 782) >= (5565 - (1076 + 57)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33) or ((785 + 3983) <= (1535 - (579 + 110)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((266 + 3092) <= (1256 + 164))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34) or ((1985 + 1754) <= (3412 - (174 + 233)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((4633 - 2974) >= (3744 - 1610))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
			if ((v134 == (0 + 0)) or ((4434 - (663 + 511)) < (2101 + 254))) then
				if ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (2 + 7)) or ((2062 - 1393) == (2558 + 1665))) then
					v104 = not v104;
				end
				if ((v93.NetherTempest:IsReady() and v42 and (v14:DebuffRefreshable(v93.NetherTempestDebuff) or not v14:DebuffUp(v93.NetherTempestDebuff)) and (v13:ArcaneCharges() == (9 - 5)) and (v13:ManaPercentage() < (72 - 42)) and (v13:SpellHaste() < (0.667 + 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) or ((3293 - 1601) < (420 + 168))) then
					if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((439 + 4358) < (4373 - (478 + 244)))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v13:ArcaneCharges() < (519 - (440 + 77))) and (v13:ManaPercentage() < (14 + 16)) and (v13:SpellHaste() < (0.667 - 0)) and v13:BuffDown(v93.ArcaneSurgeBuff)) or ((5733 - (655 + 901)) > (900 + 3950))) then
					if (v21(v93.ArcaneOrb, not v14:IsInRange(31 + 9)) or ((271 + 129) > (4475 - 3364))) then
						return "arcane_orb touch_phase 4";
					end
				end
				if (((4496 - (695 + 750)) > (3431 - 2426)) and v93.PresenceofMind:IsCastable() and v43 and (v14:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (((5698 - 2005) <= (17623 - 13241)) and v21(v93.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				v134 = 352 - (285 + 66);
			end
		end
	end
	local function v124()
		if ((v14:DebuffRemains(v93.TouchoftheMagiDebuff) > (20 - 11)) or ((4592 - (682 + 628)) > (661 + 3439))) then
			v104 = not v104;
		end
		if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff)) or ((3879 - (176 + 123)) < (1190 + 1654))) then
			if (((65 + 24) < (4759 - (239 + 30))) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles aoe_touch_phase 2";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v34 and ((((v100 <= (2 + 2)) or (v101 <= (4 + 0))) and (v13:ArcaneCharges() == (4 - 1))) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) or ((15546 - 10563) < (2123 - (306 + 9)))) then
			if (((13361 - 9532) > (656 + 3113)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_touch_phase 4";
			end
		end
		if (((912 + 573) <= (1398 + 1506)) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (5 - 3))) then
			if (((5644 - (1140 + 235)) == (2717 + 1552)) and v21(v93.ArcaneOrb, not v14:IsInRange(37 + 3))) then
				return "arcane_orb aoe_touch_phase 6";
			end
		end
		if (((100 + 287) <= (2834 - (33 + 19))) and v93.ArcaneExplosion:IsCastable() and v35) then
			if (v21(v93.ArcaneExplosion, not v14:IsInRange(4 + 6)) or ((5691 - 3792) <= (404 + 513))) then
				return "arcane_explosion aoe_touch_phase 8";
			end
		end
	end
	local function v125()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (0 + 0)) or ((5001 - (586 + 103)) <= (80 + 796))) then
				if (((6871 - 4639) <= (4084 - (1309 + 179))) and v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() < (5 - 2)) and (v13:BloodlustDown() or (v13:ManaPercentage() > (31 + 39)) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (80 - 50))))) then
					if (((1583 + 512) < (7831 - 4145)) and v21(v93.ArcaneOrb, not v14:IsInRange(79 - 39))) then
						return "arcane_orb rotation 2";
					end
				end
				v104 = ((v93.ArcaneSurge:CooldownRemains() > (639 - (295 + 314))) and (v93.TouchoftheMagi:CooldownRemains() > (24 - 14))) or false;
				if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (1974 - (1300 + 662)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (37 - 25))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (1767 - (1178 + 577)))) and (v113 > (8 + 7))) or ((4714 - 3119) >= (5879 - (851 + 554)))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(36 + 4)) or ((12809 - 8190) < (6258 - 3376))) then
						return "shifting_power rotation 4";
					end
				end
				v135 = 303 - (115 + 187);
			end
			if (((3 + 0) == v135) or ((279 + 15) >= (19037 - 14206))) then
				if (((3190 - (160 + 1001)) <= (2699 + 385)) and v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v93.TemporalWarpBuff) or (v13:ManaPercentage() < (7 + 3)) or not v93.ShiftingPower:IsAvailable()) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (23 - 11))) then
					if (v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest)) or ((2395 - (237 + 121)) == (3317 - (525 + 372)))) then
						return "nether_tempest rotation 16";
					end
				end
				if (((8451 - 3993) > (12826 - 8922)) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (192 - (96 + 46))) and not v93.Evocation:IsAvailable() and (v113 > (797 - (643 + 134)))) then
					if (((158 + 278) >= (294 - 171)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage rotation 18";
					end
				end
				if (((1856 - 1356) < (1742 + 74)) and v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (137 - 67)) and v104 and v13:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (10 - 5)) and (v113 > (739 - (316 + 403)))) then
					if (((2376 + 1198) == (9826 - 6252)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage rotation 20";
					end
				end
				v135 = 2 + 2;
			end
			if (((556 - 335) < (277 + 113)) and (v135 == (1 + 1))) then
				if ((v93.ArcaneBlast:IsReady() and v33 and v13:BuffUp(v93.PresenceofMindBuff) and (v14:HealthPercentage() < (121 - 86)) and v93.ArcaneBombardment:IsAvailable() and (v13:ArcaneCharges() < (14 - 11))) or ((4596 - 2383) <= (82 + 1339))) then
					if (((6019 - 2961) < (238 + 4622)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 12";
					end
				end
				if ((v13:IsChanneling(v93.ArcaneMissiles) and (v13:GCDRemains() == (0 - 0)) and v13:BuffUp(v93.NetherPrecisionBuff) and (((v13:ManaPercentage() > (47 - (12 + 5))) and (v93.TouchoftheMagi:CooldownRemains() > (116 - 86))) or (v13:ManaPercentage() > (149 - 79))) and v13:BuffDown(v93.ArcaneArtilleryBuff)) or ((2754 - 1458) >= (11025 - 6579))) then
					if (v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((283 + 1110) > (6462 - (1656 + 317)))) then
						return "arcane_missiles interrupt rotation 20";
					end
				end
				if ((v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and (v13:BuffStack(v93.ClearcastingBuff) == v111)) or ((3943 + 481) < (22 + 5))) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((5309 - 3312) > (18775 - 14960))) then
						return "arcane_missiles rotation 14";
					end
				end
				v135 = 357 - (5 + 349);
			end
			if (((16458 - 12993) > (3184 - (266 + 1005))) and (v135 == (4 + 1))) then
				if (((2500 - 1767) < (2394 - 575)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((6091 - (561 + 1135)) == (6196 - 1441))) then
						return "arcane_missiles rotation 30";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33) or ((12468 - 8675) < (3435 - (507 + 559)))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((10247 - 6163) == (819 - 554))) then
						return "arcane_blast rotation 32";
					end
				end
				if (((4746 - (212 + 176)) == (5263 - (250 + 655))) and v93.ArcaneBarrage:IsReady() and v34) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((8556 - 5418) < (1734 - 741))) then
						return "arcane_barrage rotation 34";
					end
				end
				break;
			end
			if (((5210 - 1880) > (4279 - (1869 + 87))) and (v135 == (3 - 2))) then
				if ((v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and not v109 and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (1946 - (484 + 1417))) and (v113 > (32 - 17))) or ((6076 - 2450) == (4762 - (48 + 725)))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(65 - 25)) or ((2457 - 1541) == (1553 + 1118))) then
						return "shifting_power rotation 6";
					end
				end
				if (((726 - 454) == (77 + 195)) and v93.PresenceofMind:IsCastable() and v43 and (v13:ArcaneCharges() < (1 + 2)) and (v14:HealthPercentage() < (888 - (152 + 701))) and v93.ArcaneBombardment:IsAvailable()) then
					if (((5560 - (430 + 881)) <= (1854 + 2985)) and v21(v93.PresenceofMind)) then
						return "presence_of_mind rotation 8";
					end
				end
				if (((3672 - (557 + 338)) < (946 + 2254)) and v93.ArcaneBlast:IsReady() and v33 and v93.TimeAnomaly:IsAvailable() and v13:BuffUp(v93.ArcaneSurgeBuff) and (v13:BuffRemains(v93.ArcaneSurgeBuff) <= (16 - 10))) then
					if (((332 - 237) < (5198 - 3241)) and v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast rotation 10";
					end
				end
				v135 = 4 - 2;
			end
			if (((1627 - (499 + 302)) < (2583 - (39 + 827))) and (v135 == (10 - 6))) then
				if (((3184 - 1758) >= (4388 - 3283)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ClearcastingBuff) and v13:BuffUp(v93.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) then
					if (((4228 - 1474) <= (290 + 3089)) and v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles rotation 22";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v33 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v93.NetherPrecisionBuff)) or ((11493 - 7566) == (227 + 1186))) then
					if (v21(v93.ArcaneBlast, not v14:IsSpellInRange(v93.ArcaneBlast)) or ((1825 - 671) <= (892 - (103 + 1)))) then
						return "arcane_blast rotation 24";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v34 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < (614 - (475 + 79))) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (21 - 11)) and (v93.Evocation:CooldownRemains() > (128 - 88)) and (v113 > (3 + 17))) or ((1446 + 197) > (4882 - (1395 + 108)))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((8156 - 5353) > (5753 - (7 + 1197)))) then
						return "arcane_barrage rotation 26";
					end
				end
				v135 = 3 + 2;
			end
		end
	end
	local function v126()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (320 - (27 + 292))) or ((644 - 424) >= (3853 - 831))) then
				if (((11834 - 9012) == (5564 - 2742)) and v93.ArcaneMissiles:IsCastable() and v38 and v13:BuffUp(v93.ArcaneArtilleryBuff) and v13:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v13:BuffRemains(v93.ArcaneArtilleryBuff) + (9 - 4)))) then
					if (v21(v93.ArcaneMissiles, not v14:IsSpellInRange(v93.ArcaneMissiles)) or ((1200 - (43 + 96)) == (7574 - 5717))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if (((6240 - 3480) > (1132 + 232)) and v93.ArcaneBarrage:IsReady() and v34 and ((v100 <= (2 + 2)) or (v101 <= (7 - 3)) or v13:BuffUp(v93.ClearcastingBuff)) and (v13:ArcaneCharges() == (2 + 1))) then
					if (v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage)) or ((9186 - 4284) <= (1132 + 2463))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v136 = 1 + 1;
			end
			if ((v136 == (1753 - (1414 + 337))) or ((5792 - (1642 + 298)) == (763 - 470))) then
				if ((v93.ArcaneOrb:IsReady() and v49 and ((v54 and v31) or not v54) and (v78 < v113) and (v13:ArcaneCharges() == (0 - 0)) and (v93.TouchoftheMagi:CooldownRemains() > (53 - 35))) or ((514 + 1045) == (3570 + 1018))) then
					if (v21(v93.ArcaneOrb, not v14:IsInRange(1012 - (357 + 615))) or ((3148 + 1336) == (1933 - 1145))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((3915 + 653) >= (8372 - 4465)) and v93.ArcaneBarrage:IsReady() and v34 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < (8 + 2)))) then
					if (((85 + 1161) < (2182 + 1288)) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_rotation 12";
					end
				end
				v136 = 1304 - (384 + 917);
			end
			if (((4765 - (128 + 569)) >= (2515 - (1407 + 136))) and (v136 == (1890 - (687 + 1200)))) then
				if (((2203 - (556 + 1154)) < (13695 - 9802)) and v93.ArcaneExplosion:IsCastable() and v35) then
					if (v21(v93.ArcaneExplosion, not v14:IsInRange(105 - (9 + 86))) or ((1894 - (275 + 146)) >= (542 + 2790))) then
						return "arcane_explosion aoe_rotation 14";
					end
				end
				break;
			end
			if ((v136 == (64 - (29 + 35))) or ((17953 - 13902) <= (3455 - 2298))) then
				if (((2666 - 2062) < (1877 + 1004)) and v93.ShiftingPower:IsReady() and v48 and ((v30 and v53) or not v53) and (v78 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (1024 - (53 + 959)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (420 - (312 + 96)))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (20 - 8))) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (297 - (147 + 138)))) or (v93.ArcaneOrb:Charges() == (899 - (813 + 86))) or (v93.ArcaneOrb:CooldownRemains() > (11 + 1)))) then
					if (v21(v93.ShiftingPower, not v14:IsInRange(74 - 34), true) or ((1392 - (18 + 474)) == (1140 + 2237))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if (((14553 - 10094) > (1677 - (860 + 226))) and v93.NetherTempest:IsReady() and v42 and v14:DebuffRefreshable(v93.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (309 - (121 + 182))) or (v101 > (1 + 5)) or not v93.OrbBarrage:IsAvailable())) then
					if (((4638 - (988 + 252)) >= (271 + 2124)) and v21(v93.NetherTempest, not v14:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v127()
		if ((v93.TouchoftheMagi:IsReady() and v51 and ((v56 and v31) or not v56) and (v78 < v113) and (v13:PrevGCDP(1971 - (49 + 1921), v93.ArcaneBarrage))) or ((3073 - (223 + 667)) >= (2876 - (51 + 1)))) then
			if (((3331 - 1395) == (4145 - 2209)) and v21(v93.TouchoftheMagi, not v14:IsSpellInRange(v93.TouchoftheMagi))) then
				return "touch_of_the_magi main 30";
			end
		end
		if ((v13:IsChanneling(v93.Evocation) and (((v13:ManaPercentage() >= (1220 - (146 + 979))) and not v93.SiphonStorm:IsAvailable()) or ((v13:ManaPercentage() > (v113 * (2 + 2))) and not ((v113 > (615 - (311 + 294))) and (v93.ArcaneSurge:CooldownRemains() < (2 - 1)))))) or ((2047 + 2785) < (5756 - (496 + 947)))) then
			if (((5446 - (1233 + 125)) > (1573 + 2301)) and v21(v95.StopCasting, not v14:IsSpellInRange(v93.ArcaneMissiles))) then
				return "cancel_action evocation main 32";
			end
		end
		if (((3887 + 445) == (824 + 3508)) and v93.ArcaneBarrage:IsReady() and v34 and (v113 < (1647 - (963 + 682)))) then
			if (((3338 + 661) >= (4404 - (504 + 1000))) and v21(v93.ArcaneBarrage, not v14:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage main 34";
			end
		end
		if ((v93.Evocation:IsCastable() and v40 and not v107 and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < (7 + 3)) and (v93.TouchoftheMagi:CooldownRemains() < (19 + 1))) or (v93.TouchoftheMagi:CooldownRemains() < (2 + 13))) and (v13:ManaPercentage() < (v113 * (5 - 1)))) or ((2158 + 367) > (2364 + 1700))) then
			if (((4553 - (156 + 26)) == (2519 + 1852)) and v21(v93.Evocation)) then
				return "evocation main 36";
			end
		end
		if ((v93.ConjureManaGem:IsCastable() and v39 and v14:DebuffDown(v93.TouchoftheMagiDebuff) and v13:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (46 - 16)) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) or ((430 - (149 + 15)) > (5946 - (890 + 70)))) then
			if (((2108 - (39 + 78)) >= (1407 - (14 + 468))) and v21(v93.ConjureManaGem)) then
				return "conjure_mana_gem main 38";
			end
		end
		if (((1000 - 545) < (5738 - 3685)) and v94.ManaGem:IsReady() and v41 and v93.CascadingPower:IsAvailable() and (v13:BuffStack(v93.ClearcastingBuff) < (2 + 0)) and v13:BuffUp(v93.ArcaneSurgeBuff)) then
			if (v21(v95.ManaGem) or ((497 + 329) == (1031 + 3820))) then
				return "mana_gem main 40";
			end
		end
		if (((83 + 100) == (48 + 135)) and v94.ManaGem:IsReady() and v41 and not v93.CascadingPower:IsAvailable() and v13:PrevGCDP(1 - 0, v93.ArcaneSurge) and (not v108 or (v108 and v13:PrevGCDP(2 + 0, v93.ArcaneSurge)))) then
			if (((4072 - 2913) <= (46 + 1742)) and v21(v95.ManaGem)) then
				return "mana_gem main 42";
			end
		end
		if ((not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * ((52 - (12 + 39)) + v24(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v13:BuffRemains(v93.ArcaneSurgeBuff) > ((3 + 0) * v24(v13:HasTier(92 - 62, 6 - 4) and not v13:HasTier(9 + 21, 3 + 1)))) or v13:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (114 - 69)) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (3 + 1))) or (v93.TouchoftheMagi:CooldownRemains() > (96 - 76))) and ((v100 < v103) or (v101 < v103))) or ((5217 - (1596 + 114)) > (11273 - 6955))) then
			local v180 = 713 - (164 + 549);
			while true do
				if ((v180 == (1438 - (1059 + 379))) or ((3818 - 743) <= (1537 + 1428))) then
					v27 = v120();
					if (((231 + 1134) <= (2403 - (145 + 247))) and v27) then
						return v27;
					end
					break;
				end
			end
		end
		if ((not v109 and (v93.ArcaneSurge:CooldownRemains() > (25 + 5)) and (v93.RadiantSpark:CooldownUp() or v14:DebuffUp(v93.RadiantSparkDebuff) or v14:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 1))) or v14:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) or ((8229 - 5453) > (686 + 2889))) then
			v27 = v120();
			if (v27 or ((2200 + 354) == (7800 - 2996))) then
				return v27;
			end
		end
		if (((3297 - (254 + 466)) == (3137 - (544 + 16))) and v30 and v93.RadiantSpark:IsAvailable() and v105) then
			v27 = v122();
			if (v27 or ((18 - 12) >= (2517 - (294 + 334)))) then
				return v27;
			end
		end
		if (((759 - (236 + 17)) <= (816 + 1076)) and v30 and v109 and v93.RadiantSpark:IsAvailable() and v106) then
			v27 = v121();
			if (v27 or ((1564 + 444) > (8353 - 6135))) then
				return v27;
			end
		end
		if (((1794 - 1415) <= (2136 + 2011)) and v30 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) then
			local v181 = 0 + 0;
			while true do
				if ((v181 == (794 - (413 + 381))) or ((190 + 4324) <= (2145 - 1136))) then
					v27 = v124();
					if (v27 or ((9081 - 5585) == (3162 - (582 + 1388)))) then
						return v27;
					end
					break;
				end
			end
		end
		if ((v30 and v109 and v14:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) or ((354 - 146) == (2119 + 840))) then
			local v182 = 364 - (326 + 38);
			while true do
				if (((12652 - 8375) >= (1873 - 560)) and (v182 == (620 - (47 + 573)))) then
					v27 = v123();
					if (((912 + 1675) < (13480 - 10306)) and v27) then
						return v27;
					end
					break;
				end
			end
		end
		if ((v100 >= v103) or (v101 >= v103) or ((6686 - 2566) <= (3862 - (1269 + 395)))) then
			local v183 = 492 - (76 + 416);
			while true do
				if ((v183 == (443 - (319 + 124))) or ((3647 - 2051) == (1865 - (564 + 443)))) then
					v27 = v126();
					if (((8914 - 5694) == (3678 - (337 + 121))) and v27) then
						return v27;
					end
					break;
				end
			end
		end
		if ((v100 < v103) or (v101 < v103) or ((4107 - 2705) > (12058 - 8438))) then
			v27 = v125();
			if (((4485 - (1261 + 650)) == (1089 + 1485)) and v27) then
				return v27;
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
		v65 = EpicSettings.Settings['prismaticBarrierHP'] or (1817 - (772 + 1045));
		v66 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v67 = EpicSettings.Settings['iceBlockHP'] or (144 - (102 + 42));
		v68 = EpicSettings.Settings['iceColdHP'] or (1844 - (1524 + 320));
		v69 = EpicSettings.Settings['mirrorImageHP'] or (1270 - (1049 + 221));
		v70 = EpicSettings.Settings['massBarrierHP'] or (156 - (18 + 138));
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v129()
		local v173 = 0 - 0;
		while true do
			if (((2900 - (67 + 1035)) < (3105 - (136 + 212))) and (v173 == (0 - 0))) then
				v78 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v75 = EpicSettings.Settings['InterruptWithStun'];
				v76 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v77 = EpicSettings.Settings['InterruptThreshold'];
				v173 = 1 + 0;
			end
			if ((v173 == (1607 - (240 + 1364))) or ((1459 - (1050 + 32)) > (9297 - 6693))) then
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (1055 - (331 + 724));
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v73 = EpicSettings.Settings['handleAfflicted'];
				v173 = 1 + 3;
			end
			if (((1212 - (269 + 375)) < (1636 - (267 + 458))) and (v173 == (1 + 1))) then
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v83 = EpicSettings.Settings['useHealingPotion'];
				v173 = 5 - 2;
			end
			if (((4103 - (667 + 151)) < (5725 - (1410 + 87))) and (v173 == (1901 - (1504 + 393)))) then
				v74 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((10585 - 6669) > (8634 - 5306)) and (v173 == (797 - (461 + 335)))) then
				v72 = EpicSettings.Settings['DispelDebuffs'];
				v71 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v79 = EpicSettings.Settings['useRacials'];
				v173 = 1 + 1;
			end
		end
	end
	local function v130()
		local v174 = 1761 - (1730 + 31);
		while true do
			if (((4167 - (728 + 939)) < (13596 - 9757)) and (v174 == (0 - 0))) then
				v128();
				v129();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v174 = 2 - 1;
			end
			if (((1575 - (138 + 930)) == (464 + 43)) and (v174 == (1 + 0))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['minicds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (((206 + 34) <= (12923 - 9758)) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v174 = 1768 - (459 + 1307);
			end
			if (((2704 - (474 + 1396)) >= (1405 - 600)) and ((2 + 0) == v174)) then
				v99 = v14:GetEnemiesInSplashRange(1 + 4);
				v102 = v13:GetEnemiesInRange(114 - 74);
				if (v29 or ((484 + 3328) < (7731 - 5415))) then
					v100 = v26(v14:GetEnemiesInSplashRangeCount(21 - 16), #v102);
					v101 = #v102;
				else
					local v202 = 591 - (562 + 29);
					while true do
						if ((v202 == (0 + 0)) or ((4071 - (374 + 1045)) <= (1214 + 319))) then
							v100 = 2 - 1;
							v101 = 639 - (448 + 190);
							break;
						end
					end
				end
				if (v97.TargetIsValid() or v13:AffectingCombat() or ((1162 + 2436) < (660 + 800))) then
					local v203 = 0 + 0;
					while true do
						if ((v203 == (3 - 2)) or ((12789 - 8673) < (2686 - (1307 + 187)))) then
							v113 = v112;
							if ((v113 == (44060 - 32949)) or ((7906 - 4529) <= (2768 - 1865))) then
								v113 = v10.FightRemains(v102, false);
							end
							break;
						end
						if (((4659 - (232 + 451)) >= (420 + 19)) and (v203 == (0 + 0))) then
							if (((4316 - (510 + 54)) == (7559 - 3807)) and (v13:AffectingCombat() or v72)) then
								local v211 = v72 and v93.RemoveCurse:IsReady() and v32;
								v27 = v97.FocusUnit(v211, v95, 56 - (13 + 23), nil, 38 - 18);
								if (((5813 - 1767) > (4896 - 2201)) and v27) then
									return v27;
								end
							end
							v112 = v10.BossFightRemains(nil, true);
							v203 = 1089 - (830 + 258);
						end
					end
				end
				v174 = 10 - 7;
			end
			if ((v174 == (2 + 1)) or ((3017 + 528) == (4638 - (860 + 581)))) then
				v114 = v13:GCD();
				if (((8830 - 6436) > (297 + 76)) and v73) then
					if (((4396 - (237 + 4)) <= (9945 - 5713)) and v92) then
						local v205 = 0 - 0;
						while true do
							if ((v205 == (0 - 0)) or ((2932 + 649) == (1995 + 1478))) then
								v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 113 - 83);
								if (((2144 + 2851) > (1822 + 1526)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				if (not v13:AffectingCombat() or v28 or ((2180 - (85 + 1341)) > (6353 - 2629))) then
					local v204 = 0 - 0;
					while true do
						if (((589 - (45 + 327)) >= (106 - 49)) and (v204 == (503 - (444 + 58)))) then
							if ((v93.ConjureManaGem:IsCastable() and v39) or ((900 + 1170) >= (695 + 3342))) then
								if (((1323 + 1382) == (7839 - 5134)) and v21(v93.ConjureManaGem)) then
									return "conjure_mana_gem precombat 4";
								end
							end
							break;
						end
						if (((1793 - (64 + 1668)) == (2034 - (1227 + 746))) and (v204 == (0 - 0))) then
							if ((v93.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) or ((1296 - 597) >= (1790 - (415 + 79)))) then
								if (v21(v93.ArcaneIntellect) or ((46 + 1737) >= (4107 - (142 + 349)))) then
									return "arcane_intellect group_buff";
								end
							end
							if ((v93.ArcaneFamiliar:IsReady() and v36 and v13:BuffDown(v93.ArcaneFamiliarBuff)) or ((1677 + 2236) > (6224 - 1697))) then
								if (((2175 + 2201) > (576 + 241)) and v21(v93.ArcaneFamiliar)) then
									return "arcane_familiar precombat 2";
								end
							end
							v204 = 2 - 1;
						end
					end
				end
				if (((6725 - (1710 + 154)) > (1142 - (200 + 118))) and v97.TargetIsValid()) then
					if ((v72 and v32 and v93.RemoveCurse:IsAvailable()) or ((548 + 835) >= (3725 - 1594))) then
						local v206 = 0 - 0;
						while true do
							if ((v206 == (0 + 0)) or ((1856 + 20) >= (1364 + 1177))) then
								if (((285 + 1497) <= (8171 - 4399)) and v15) then
									local v212 = 1250 - (363 + 887);
									while true do
										if ((v212 == (0 - 0)) or ((22371 - 17671) < (126 + 687))) then
											v27 = v116();
											if (((7484 - 4285) < (2768 + 1282)) and v27) then
												return v27;
											end
											break;
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v97.UnitHasCurseDebuff(v16)) or ((6615 - (674 + 990)) < (1271 + 3159))) then
									if (((40 + 56) == (151 - 55)) and v93.RemoveCurse:IsReady()) then
										if (v21(v95.RemoveCurseMouseover) or ((3794 - (507 + 548)) > (4845 - (289 + 548)))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if ((not v13:AffectingCombat() and v28) or ((1841 - (821 + 997)) == (1389 - (195 + 60)))) then
						local v207 = 0 + 0;
						while true do
							if ((v207 == (1501 - (251 + 1250))) or ((7889 - 5196) >= (2825 + 1286))) then
								v27 = v118();
								if (v27 or ((5348 - (809 + 223)) <= (3131 - 985))) then
									return v27;
								end
								break;
							end
						end
					end
					v27 = v115();
					if (v27 or ((10648 - 7102) <= (9287 - 6478))) then
						return v27;
					end
					if (((3612 + 1292) > (1135 + 1031)) and v73) then
						if (((726 - (14 + 603)) >= (219 - (118 + 11))) and v92) then
							v27 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 5 + 25);
							if (((4147 + 831) > (8465 - 5560)) and v27) then
								return v27;
							end
						end
					end
					if (v74 or ((3975 - (551 + 398)) <= (1441 + 839))) then
						local v208 = 0 + 0;
						while true do
							if ((v208 == (0 + 0)) or ((6147 - 4494) <= (2552 - 1444))) then
								v27 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseOver, 10 + 20, true);
								if (((11548 - 8639) > (721 + 1888)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
					if (((846 - (40 + 49)) > (738 - 544)) and v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v32 and v71 and not v13:IsCasting() and not v13:IsChanneling() and v97.UnitHasMagicBuff(v14)) then
						if (v21(v93.Spellsteal, not v14:IsSpellInRange(v93.Spellsteal)) or ((521 - (99 + 391)) >= (1157 + 241))) then
							return "spellsteal damage";
						end
					end
					if (((14049 - 10853) <= (12064 - 7192)) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v97.TargetIsValid()) then
						local v209 = 0 + 0;
						local v210;
						while true do
							if (((8751 - 5425) == (4930 - (1032 + 572))) and (v209 == (420 - (203 + 214)))) then
								v27 = v119();
								if (((3250 - (568 + 1249)) <= (3034 + 844)) and v27) then
									return v27;
								end
								v209 = 9 - 5;
							end
							if ((v209 == (0 - 0)) or ((2889 - (913 + 393)) == (4899 - 3164))) then
								v210 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
								if (v210 or ((4211 - 1230) == (2760 - (269 + 141)))) then
									return v210;
								end
								v209 = 2 - 1;
							end
							if ((v209 == (1982 - (362 + 1619))) or ((6091 - (950 + 675)) <= (191 + 302))) then
								if ((v13:IsMoving() and v93.IceFloes:IsReady()) or ((3726 - (216 + 963)) <= (3274 - (485 + 802)))) then
									if (((3520 - (432 + 127)) > (3813 - (1065 + 8))) and v21(v93.IceFloes)) then
										return "ice_floes movement";
									end
								end
								if (((2053 + 1643) >= (5213 - (635 + 966))) and v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (29 + 11)) or (v13:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + (56 - (5 + 37))))))) then
									if (v21(v93.TimeWarp, not v14:IsInRange(99 - 59)) or ((1236 + 1734) == (2972 - 1094))) then
										return "time_warp main 4";
									end
								end
								v209 = 1 + 1;
							end
							if ((v209 == (8 - 4)) or ((14001 - 10308) < (3727 - 1750))) then
								v27 = v127();
								if (v27 or ((2223 - 1293) > (1511 + 590))) then
									return v27;
								end
								break;
							end
							if (((4682 - (318 + 211)) > (15184 - 12098)) and (v209 == (1589 - (963 + 624)))) then
								if ((v79 and ((v82 and v30) or not v82) and (v78 < v113)) or ((1990 + 2664) <= (4896 - (518 + 328)))) then
									if ((v93.LightsJudgment:IsCastable() and v13:BuffDown(v93.ArcaneSurgeBuff) and v14:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (4 - 2)) or (v101 >= (2 - 0)))) or ((2919 - (301 + 16)) < (4384 - 2888))) then
										if (v21(v93.LightsJudgment, not v14:IsSpellInRange(v93.LightsJudgment)) or ((2864 - 1844) > (5970 - 3682))) then
											return "lights_judgment main 6";
										end
									end
									if (((298 + 30) == (187 + 141)) and v93.Berserking:IsCastable() and ((v13:PrevGCDP(1 - 0, v93.ArcaneSurge) and not (v13:BuffUp(v93.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v93.ArcaneSurgeBuff) and v14:DebuffUp(v93.TouchoftheMagiDebuff)))) then
										if (((910 + 601) < (363 + 3445)) and v21(v93.Berserking)) then
											return "berserking main 8";
										end
									end
									if (v13:PrevGCDP(3 - 2, v93.ArcaneSurge) or ((811 + 1699) > (5938 - (829 + 190)))) then
										local v213 = 0 - 0;
										while true do
											if (((6026 - 1263) == (6583 - 1820)) and (v213 == (0 - 0))) then
												if (((981 + 3156) > (604 + 1244)) and v93.BloodFury:IsCastable()) then
													if (((7393 - 4957) <= (2958 + 176)) and v21(v93.BloodFury)) then
														return "blood_fury main 10";
													end
												end
												if (((4336 - (520 + 93)) == (3999 - (259 + 17))) and v93.Fireblood:IsCastable()) then
													if (v21(v93.Fireblood) or ((234 + 3812) >= (1554 + 2762))) then
														return "fireblood main 12";
													end
												end
												v213 = 3 - 2;
											end
											if ((v213 == (592 - (396 + 195))) or ((5825 - 3817) < (3690 - (440 + 1321)))) then
												if (((4213 - (1059 + 770)) > (8207 - 6432)) and v93.AncestralCall:IsCastable()) then
													if (v21(v93.AncestralCall) or ((5088 - (424 + 121)) <= (798 + 3578))) then
														return "ancestral_call main 14";
													end
												end
												break;
											end
										end
									end
								end
								if (((2075 - (641 + 706)) == (289 + 439)) and (v78 < v113)) then
									if ((v80 and ((v30 and v81) or not v81)) or ((1516 - (249 + 191)) > (20348 - 15677))) then
										v27 = v117();
										if (((827 + 1024) >= (1456 - 1078)) and v27) then
											return v27;
										end
									end
								end
								v209 = 430 - (183 + 244);
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v175 = 0 + 0;
		while true do
			if ((v175 == (730 - (434 + 296))) or ((6216 - 4268) >= (3988 - (169 + 343)))) then
				v98();
				v19.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(55 + 7, v130, v131);
end;
return v0["Epix_Mage_Arcane.lua"]();

