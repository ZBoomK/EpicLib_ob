local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2740 - 1276) <= (5658 - (771 + 510))) and not v5) then
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
		if (((6736 - 4047) < (2706 + 2017)) and v93.RemoveCurse:IsAvailable()) then
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
	local v103 = 2 + 1;
	local v104 = false;
	local v105 = false;
	local v106 = false;
	local v107 = true;
	local v108 = false;
	local v109 = v12:HasTier(22 + 7, 2 + 2);
	local v110 = (167148 + 57852) - (((26414 - (1001 + 413)) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((445996 - 245996) * v23(not v109)));
	local v111 = 885 - (244 + 638);
	local v112 = 11804 - (627 + 66);
	local v113 = 33106 - 21995;
	local v114;
	v9:RegisterForEvent(function()
		local v133 = 602 - (512 + 90);
		while true do
			if (((6042 - (1665 + 241)) >= (3114 - (373 + 344))) and (v133 == (1 + 1))) then
				v113 = 2940 + 8171;
				break;
			end
			if ((v133 == (0 - 0)) or ((7334 - 3000) == (5344 - (35 + 1064)))) then
				v104 = false;
				v107 = true;
				v133 = 1 + 0;
			end
			if ((v133 == (2 - 1)) or ((18 + 4258) <= (4267 - (298 + 938)))) then
				v110 = (226259 - (233 + 1026)) - (((26666 - (636 + 1030)) * v23(not v93.ArcaneHarmony:IsAvailable())) + ((102254 + 97746) * v23(not v109)));
				v112 = 10853 + 258;
				v133 = 1 + 1;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v109 = not v12:HasTier(2 + 27, 225 - (55 + 166));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v115()
		if ((v93.PrismaticBarrier:IsCastable() and v57 and v12:BuffDown(v93.PrismaticBarrier) and (v12:HealthPercentage() <= v64)) or ((927 + 3855) <= (121 + 1078))) then
			if (v20(v93.PrismaticBarrier) or ((18575 - 13711) < (2199 - (36 + 261)))) then
				return "ice_barrier defensive 1";
			end
		end
		if (((8462 - 3623) >= (5068 - (34 + 1334))) and v93.MassBarrier:IsCastable() and v61 and v12:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v69, 1 + 1, v93.ArcaneIntellect)) then
			if (v20(v93.MassBarrier) or ((836 + 239) > (3201 - (1035 + 248)))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((417 - (20 + 1)) <= (1982 + 1822)) and v93.IceBlock:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) then
			if (v20(v93.IceBlock) or ((4488 - (134 + 185)) == (3320 - (549 + 584)))) then
				return "ice_block defensive 3";
			end
		end
		if (((2091 - (314 + 371)) == (4826 - 3420)) and v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v60 and (v12:HealthPercentage() <= v67)) then
			if (((2499 - (478 + 490)) < (2263 + 2008)) and v20(v93.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((1807 - (786 + 386)) == (2056 - 1421)) and v93.MirrorImage:IsCastable() and v62 and (v12:HealthPercentage() <= v68)) then
			if (((4752 - (1055 + 324)) <= (4896 - (1093 + 247))) and v20(v93.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if ((v93.GreaterInvisibility:IsReady() and v58 and (v12:HealthPercentage() <= v65)) or ((2925 + 366) < (345 + 2935))) then
			if (((17413 - 13027) >= (2962 - 2089)) and v20(v93.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((2620 - 1699) <= (2769 - 1667)) and v93.AlterTime:IsReady() and v56 and (v12:HealthPercentage() <= v63)) then
			if (((1675 + 3031) >= (3709 - 2746)) and v20(v93.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v94.Healthstone:IsReady() and v84 and (v12:HealthPercentage() <= v86)) or ((3308 - 2348) <= (661 + 215))) then
			if (v20(v95.Healthstone) or ((5283 - 3217) == (1620 - (364 + 324)))) then
				return "healthstone defensive";
			end
		end
		if (((13226 - 8401) < (11621 - 6778)) and v83 and (v12:HealthPercentage() <= v85)) then
			local v180 = 0 + 0;
			while true do
				if ((v180 == (0 - 0)) or ((6208 - 2331) >= (13779 - 9242))) then
					if ((v87 == "Refreshing Healing Potion") or ((5583 - (1249 + 19)) < (1558 + 168))) then
						if (v94.RefreshingHealingPotion:IsReady() or ((14320 - 10641) < (1711 - (686 + 400)))) then
							if (v20(v95.RefreshingHealingPotion) or ((3629 + 996) < (861 - (73 + 156)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v87 == "Dreamwalker's Healing Potion") or ((1 + 82) > (2591 - (721 + 90)))) then
						if (((7 + 539) <= (3496 - 2419)) and v94.DreamwalkersHealingPotion:IsReady()) then
							if (v20(v95.RefreshingHealingPotion) or ((1466 - (224 + 246)) > (6967 - 2666))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local v116 = 0 - 0;
	local function v117()
		if (((739 + 3331) > (17 + 670)) and v93.RemoveCurse:IsReady() and v97.UnitHasDispellableDebuffByPlayer(v14)) then
			local v181 = 0 + 0;
			while true do
				if ((v181 == (0 - 0)) or ((2182 - 1526) >= (3843 - (203 + 310)))) then
					if ((v116 == (1993 - (1238 + 755))) or ((175 + 2317) <= (1869 - (709 + 825)))) then
						v116 = GetTime();
					end
					if (((7963 - 3641) >= (3731 - 1169)) and v97.Wait(1364 - (196 + 668), v116)) then
						local v207 = 0 - 0;
						while true do
							if ((v207 == (0 - 0)) or ((4470 - (171 + 662)) >= (3863 - (4 + 89)))) then
								if (v20(v95.RemoveCurseFocus) or ((8338 - 5959) > (1667 + 2911))) then
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
		v26 = v97.HandleTopTrinket(v96, v29, 16 + 24, nil);
		if (v26 or ((1969 - (35 + 1451)) > (2196 - (28 + 1425)))) then
			return v26;
		end
		v26 = v97.HandleBottomTrinket(v96, v29, 2033 - (941 + 1052), nil);
		if (((2354 + 100) > (2092 - (822 + 692))) and v26) then
			return v26;
		end
	end
	local function v119()
		local v134 = 0 - 0;
		while true do
			if (((439 + 491) < (4755 - (45 + 252))) and (v134 == (1 + 0))) then
				if (((228 + 434) <= (2365 - 1393)) and v93.Evocation:IsReady() and v39 and (v93.SiphonStorm:IsAvailable())) then
					if (((4803 - (114 + 319)) == (6274 - 1904)) and v20(v93.Evocation)) then
						return "evocation precombat 6";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53)) or ((6101 - 1339) <= (549 + 312))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(59 - 19)) or ((2958 - 1546) == (6227 - (556 + 1407)))) then
						return "arcane_orb precombat 8";
					end
				end
				v134 = 1208 - (741 + 465);
			end
			if (((467 - (170 + 295)) == v134) or ((1670 + 1498) < (1978 + 175))) then
				if ((v93.ArcaneBlast:IsReady() and v32) or ((12250 - 7274) < (1105 + 227))) then
					if (((2968 + 1660) == (2621 + 2007)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 8";
					end
				end
				break;
			end
			if ((v134 == (1230 - (957 + 273))) or ((15 + 39) == (159 + 236))) then
				if (((312 - 230) == (215 - 133)) and v93.MirrorImage:IsCastable() and v90 and v62) then
					if (v20(v93.MirrorImage) or ((1774 - 1193) < (1396 - 1114))) then
						return "mirror_image precombat 2";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and not v93.SiphonStorm:IsAvailable()) or ((6389 - (389 + 1391)) < (1566 + 929))) then
					if (((120 + 1032) == (2622 - 1470)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast precombat 4";
					end
				end
				v134 = 952 - (783 + 168);
			end
		end
	end
	local function v120()
		if (((6363 - 4467) <= (3366 + 56)) and ((v100 >= v103) or (v101 >= v103)) and ((v93.ArcaneOrb:Charges() > (311 - (309 + 2))) or (v12:ArcaneCharges() >= (9 - 6))) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (1214 - (1090 + 122))))) then
			v105 = true;
		elseif ((v105 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (3 + 4)) and v93.RadiantSpark:CooldownDown()) or ((3324 - 2334) > (1109 + 511))) then
			v105 = false;
		end
		if (((v12:ArcaneCharges() > (1121 - (628 + 490))) and ((v100 < v103) or (v101 < v103)) and v93.RadiantSpark:CooldownUp() and (v93.TouchoftheMagi:CooldownRemains() <= (v114 * (2 + 5))) and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * (12 - 7))) or (v93.ArcaneSurge:CooldownRemains() > (182 - 142)))) or ((1651 - (431 + 343)) > (9482 - 4787))) then
			v106 = true;
		elseif (((7784 - 5093) >= (1463 + 388)) and v106 and v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (1 + 6)) and v93.RadiantSpark:CooldownDown()) then
			v106 = false;
		end
		if ((v13:DebuffUp(v93.TouchoftheMagiDebuff) and v107) or ((4680 - (556 + 1139)) >= (4871 - (6 + 9)))) then
			v107 = false;
		end
		v108 = v93.ArcaneBlast:CastTime() < v114;
	end
	local function v121()
		local v135 = 0 + 0;
		while true do
			if (((2191 + 2085) >= (1364 - (28 + 141))) and ((2 + 1) == v135)) then
				if (((3989 - 757) <= (3322 + 1368)) and v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (1347 - (486 + 831))) and (v93.ArcaneEcho:IsAvailable())) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((2331 - 1435) >= (11075 - 7929))) then
						return "nether_tempest cooldown_phase 22";
					end
				end
				if (((579 + 2482) >= (9353 - 6395)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) then
					if (((4450 - (668 + 595)) >= (580 + 64)) and v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge cooldown_phase 24";
					end
				end
				if (((130 + 514) <= (1919 - 1215)) and v93.ArcaneBarrage:IsReady() and v33 and (v12:PrevGCDP(291 - (23 + 267), v93.ArcaneSurge) or v12:PrevGCDP(1945 - (1129 + 815), v93.NetherTempest) or v12:PrevGCDP(388 - (371 + 16), v93.RadiantSpark))) then
					if (((2708 - (1326 + 424)) > (1793 - 846)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage cooldown_phase 26";
					end
				end
				if (((16414 - 11922) >= (2772 - (88 + 30))) and v93.ArcaneBlast:IsReady() and v32 and v13:DebuffUp(v93.RadiantSparkVulnerability) and (v13:DebuffStack(v93.RadiantSparkVulnerability) < (775 - (720 + 51)))) then
					if (((7656 - 4214) >= (3279 - (421 + 1355))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				v135 = 6 - 2;
			end
			if ((v135 == (1 + 0)) or ((4253 - (286 + 797)) <= (5351 - 3887))) then
				if ((v93.ArcaneBlast:IsReady() and v32 and v93.RadiantSpark:CooldownUp() and ((v12:ArcaneCharges() < (2 - 0)) or ((v12:ArcaneCharges() < v12:ArcaneChargesMax()) and (v93.ArcaneOrb:CooldownRemains() >= v114)))) or ((5236 - (397 + 42)) == (1371 + 3017))) then
					if (((1351 - (24 + 776)) <= (1048 - 367)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 8";
					end
				end
				if (((4062 - (222 + 563)) > (896 - 489)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and (v12:ManaPercentage() > (220 - (23 + 167))) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (((6493 - (690 + 1108)) >= (511 + 904)) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt cooldown_phase 10";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (5 + 0)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (854 - (40 + 808))))) and v12:HasTier(6 + 25, 15 - 11)) or ((3070 + 142) <= (500 + 444))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((1698 + 1398) <= (2369 - (47 + 524)))) then
						return "arcane_missiles cooldown_phase 10";
					end
				end
				if (((2296 + 1241) == (9668 - 6131)) and v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (24 - 7)) and not v12:HasTier(68 - 38, 1730 - (1165 + 561))) then
					if (((114 + 3723) >= (4862 - 3292)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 12";
					end
				end
				v135 = 1 + 1;
			end
			if (((483 - (341 + 138)) == v135) or ((797 + 2153) == (7866 - 4054))) then
				if (((5049 - (89 + 237)) >= (7456 - 5138)) and v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (v20(v93.PresenceofMind) or ((4267 - 2240) > (3733 - (581 + 300)))) then
						return "presence_of_mind cooldown_phase 30";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.PresenceofMindBuff))) or ((2356 - (855 + 365)) > (10253 - 5936))) then
					if (((1551 + 3197) == (5983 - (1030 + 205))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				if (((3508 + 228) <= (4410 + 330)) and v93.ArcaneMissiles:IsReady() and v37 and v12:BuffDown(v93.NetherPrecisionBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v13:DebuffDown(v93.RadiantSparkVulnerability) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (290 - (156 + 130))) and v12:PrevGCDP(2 - 1, v93.ArcaneBlast)))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((5713 - 2323) <= (6267 - 3207))) then
						return "arcane_missiles cooldown_phase 34";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32) or ((264 + 735) > (1571 + 1122))) then
					if (((532 - (10 + 59)) < (170 + 431)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast cooldown_phase 36";
					end
				end
				break;
			end
			if ((v135 == (9 - 7)) or ((3346 - (671 + 492)) < (547 + 140))) then
				if (((5764 - (369 + 846)) == (1205 + 3344)) and v93.ArcaneMissiles:IsReady() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (2 + 0)) and (v93.RadiantSpark:CooldownRemains() < (1950 - (1036 + 909))) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (5 + 1)))) and not v12:HasTier(50 - 20, 207 - (11 + 192))) then
					if (((2362 + 2310) == (4847 - (135 + 40))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (36 - 21)) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (4 + 1)))) and (v93.ArcaneSurge:CooldownRemains() < (66 - 36))) or ((5498 - 1830) < (571 - (50 + 126)))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((11600 - 7434) == (101 + 354))) then
						return "arcane_missiles cooldown_phase 16";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v37 and v93.RadiantSpark:CooldownUp() and v12:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v12:BuffDown(v93.NetherPrecisionBuff) or (v12:BuffRemains(v93.NetherPrecisionBuff) < v114)) and v12:HasTier(1443 - (1233 + 180), 973 - (522 + 447))) or ((5870 - (107 + 1314)) == (1236 + 1427))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((13032 - 8755) < (1270 + 1719))) then
						return "arcane_missiles cooldown_phase 18";
					end
				end
				if ((v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) or ((1727 - 857) >= (16415 - 12266))) then
					if (((4122 - (716 + 1194)) < (55 + 3128)) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), true)) then
						return "radiant_spark cooldown_phase 20";
					end
				end
				v135 = 1 + 2;
			end
			if (((5149 - (74 + 429)) > (5771 - 2779)) and (v135 == (0 + 0))) then
				if (((3282 - 1848) < (2198 + 908)) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(2 - 1, v93.ArcaneBarrage))) then
					if (((1943 - 1157) < (3456 - (279 + 154))) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (v93.RadiantSpark:CooldownUp() or ((3220 - (454 + 324)) < (59 + 15))) then
					v104 = v93.ArcaneSurge:CooldownRemains() < (27 - (12 + 5));
				end
				if (((2446 + 2089) == (11555 - 7020)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) then
					if (v20(v93.ShiftingPower, not v13:IsInRange(15 + 25), true) or ((4102 - (277 + 816)) <= (8994 - 6889))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if (((3013 - (1058 + 125)) < (688 + 2981)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and v93.RadiantSpark:CooldownUp() and (v12:ArcaneCharges() < v12:ArcaneChargesMax())) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(1015 - (815 + 160))) or ((6135 - 4705) >= (8574 - 4962))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v122()
		local v136 = 0 - 0;
		while true do
			if (((4581 - (41 + 1857)) >= (4353 - (1222 + 671))) and ((0 - 0) == v136)) then
				if ((v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (64 - 19)) and v13:DebuffDown(v93.NetherTempestDebuff) and v107 and v12:BloodlustUp()) or ((2986 - (229 + 953)) >= (5049 - (1111 + 663)))) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((2996 - (874 + 705)) > (508 + 3121))) then
						return "nether_tempest spark_phase 2";
					end
				end
				if (((3272 + 1523) > (834 - 432)) and v107 and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (((5492 - (642 + 37)) > (813 + 2752)) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles interrupt spark_phase 4";
					end
				end
				if (((626 + 3286) == (9821 - 5909)) and v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (459 - (233 + 221))) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (13 - 7)))) and v12:HasTier(28 + 3, 1545 - (718 + 823))) then
					if (((1776 + 1045) <= (5629 - (266 + 539))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "arcane_missiles spark_phase 4";
					end
				end
				if (((4920 - 3182) <= (3420 - (636 + 589))) and v93.ArcaneBlast:IsReady() and v32 and v107 and v93.ArcaneSurge:CooldownUp() and v12:BloodlustUp() and (v12:Mana() >= v110) and (v12:BuffRemains(v93.SiphonStormBuff) > (35 - 20))) then
					if (((84 - 43) <= (2392 + 626)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast spark_phase 6";
					end
				end
				v136 = 1 + 0;
			end
			if (((3160 - (657 + 358)) <= (10866 - 6762)) and (v136 == (6 - 3))) then
				if (((3876 - (1151 + 36)) < (4679 + 166)) and v93.ArcaneBlast:IsReady() and v32) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((611 + 1711) > (7830 - 5208))) then
						return "arcane_blast spark_phase 26";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33) or ((6366 - (1552 + 280)) == (2916 - (64 + 770)))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((1067 + 504) > (4237 - 2370))) then
						return "arcane_barrage spark_phase 28";
					end
				end
				break;
			end
			if ((v136 == (1 + 1)) or ((3897 - (157 + 1086)) >= (5996 - 3000))) then
				if (((17422 - 13444) > (3227 - 1123)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113) and ((not v93.NetherTempest:IsAvailable() and ((v12:PrevGCDP(5 - 1, v93.RadiantSpark) and not v108) or v12:PrevGCDP(824 - (599 + 220), v93.RadiantSpark))) or v12:PrevGCDP(1 - 0, v93.NetherTempest))) then
					if (((4926 - (1813 + 118)) > (1127 + 414)) and v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge spark_phase 18";
					end
				end
				if (((4466 - (841 + 376)) > (1334 - 381)) and v93.ArcaneBlast:IsReady() and v32 and (v93.ArcaneBlast:CastTime() >= v12:GCD()) and (v93.ArcaneBlast:ExecuteTime() < v13:DebuffRemains(v93.RadiantSparkVulnerability)) and (not v93.ArcaneBombardment:IsAvailable() or (v13:HealthPercentage() >= (9 + 26))) and ((v93.NetherTempest:IsAvailable() and v12:PrevGCDP(16 - 10, v93.RadiantSpark)) or (not v93.NetherTempest:IsAvailable() and v12:PrevGCDP(864 - (464 + 395), v93.RadiantSpark))) and not (v12:IsCasting(v93.ArcaneSurge) and (v12:CastRemains() < (0.5 - 0)) and not v108)) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((1572 + 1701) > (5410 - (467 + 370)))) then
						return "arcane_blast spark_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4))) or ((2314 + 837) < (4401 - 3117))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((289 + 1561) == (3556 - 2027))) then
						return "arcane_barrage spark_phase 22";
					end
				end
				if (((1341 - (150 + 370)) < (3405 - (74 + 1208))) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and v12:PrevGCDP(2 - 1, v93.ArcaneBarrage) and ((v93.ArcaneBarrage:InFlight() and ((v93.ArcaneBarrage:TravelTime() - v93.ArcaneBarrage:TimeSinceLastCast()) <= (0.2 - 0))) or (v12:GCDRemains() <= (0.2 + 0)))) then
					if (((1292 - (14 + 376)) < (4032 - 1707)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi spark_phase 24";
					end
				end
				v136 = 2 + 1;
			end
			if (((754 + 104) <= (2825 + 137)) and (v136 == (2 - 1))) then
				if ((v93.ArcaneMissiles:IsCastable() and v37 and v107 and v12:BloodlustUp() and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) >= (2 + 0)) and (v93.RadiantSpark:CooldownRemains() < (83 - (23 + 55))) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v114 * (13 - 7)))) or ((2634 + 1312) < (1157 + 131))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((5026 - 1784) == (179 + 388))) then
						return "arcane_missiles spark_phase 10";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v37 and v93.ArcaneHarmony:IsAvailable() and (v12:BuffStack(v93.ArcaneHarmonyBuff) < (916 - (652 + 249))) and ((v107 and v12:BloodlustUp()) or (v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (13 - 8)))) and (v93.ArcaneSurge:CooldownRemains() < (1898 - (708 + 1160)))) or ((2299 - 1452) >= (2302 - 1039))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((2280 - (10 + 17)) == (416 + 1435))) then
						return "arcane_missiles spark_phase 12";
					end
				end
				if ((v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) or ((3819 - (1400 + 332)) > (4549 - 2177))) then
					if (v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark)) or ((6353 - (242 + 1666)) < (1776 + 2373))) then
						return "radiant_spark spark_phase 14";
					end
				end
				if ((v93.NetherTempest:IsReady() and v41 and not v108 and (v93.NetherTempest:TimeSinceLastCast() >= (6 + 9)) and ((not v108 and v12:PrevGCDP(4 + 0, v93.RadiantSpark) and (v93.ArcaneSurge:CooldownRemains() <= v93.NetherTempest:ExecuteTime())) or v12:PrevGCDP(945 - (850 + 90), v93.RadiantSpark))) or ((3183 - 1365) == (1475 - (360 + 1030)))) then
					if (((558 + 72) < (6003 - 3876)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest spark_phase 16";
					end
				end
				v136 = 2 - 0;
			end
		end
	end
	local function v123()
		local v137 = 1661 - (909 + 752);
		while true do
			if ((v137 == (1226 - (109 + 1114))) or ((3548 - 1610) == (979 + 1535))) then
				if (((4497 - (6 + 236)) >= (35 + 20)) and v93.PresenceofMind:IsCastable() and v42) then
					if (((2414 + 585) > (2726 - 1570)) and v20(v93.PresenceofMind)) then
						return "presence_of_mind aoe_spark_phase 18";
					end
				end
				if (((4104 - 1754) > (2288 - (1076 + 57))) and v93.ArcaneBlast:IsReady() and v32 and ((((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 1)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (692 - (579 + 110)))) and not v93.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable()))) then
					if (((319 + 3710) <= (4291 + 562)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast aoe_spark_phase 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (3 + 1)) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (410 - (174 + 233))) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) or ((1441 - 925) > (6026 - 2592))) then
					if (((1800 + 2246) >= (4207 - (663 + 511))) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 22";
					end
				end
				break;
			end
			if ((v137 == (2 + 0)) or ((591 + 2128) <= (4460 - 3013))) then
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v93.ArcaneSurge:CooldownRemains() < (46 + 29)) and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (9 - 5)) and not v93.OrbBarrage:IsAvailable()) or ((10007 - 5873) < (1874 + 2052))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((318 - 154) >= (1985 + 800))) then
						return "arcane_barrage aoe_spark_phase 12";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 1)) and (v93.ArcaneSurge:CooldownRemains() > (797 - (478 + 244)))) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (518 - (440 + 77))) and (v93.ArcaneSurge:CooldownRemains() < (35 + 40)) and not v93.OrbBarrage:IsAvailable()))) or ((1921 - 1396) == (3665 - (655 + 901)))) then
					if (((7 + 26) == (26 + 7)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 14";
					end
				end
				if (((2063 + 991) <= (16174 - 12159)) and v93.ArcaneBarrage:IsReady() and v33 and ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1446 - (695 + 750))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (6 - 4)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (3 - 0)) and ((v100 > (20 - 15)) or (v101 > (356 - (285 + 66))))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (8 - 4))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable()) then
					if (((3181 - (682 + 628)) < (546 + 2836)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_spark_phase 16";
					end
				end
				v137 = 302 - (176 + 123);
			end
			if (((541 + 752) <= (1572 + 594)) and (v137 == (269 - (239 + 30)))) then
				if ((v12:BuffUp(v93.PresenceofMindBuff) and v91 and (v12:PrevGCDP(1 + 0, v93.ArcaneBlast)) and (v93.ArcaneSurge:CooldownRemains() > (73 + 2))) or ((4564 - 1985) < (383 - 260))) then
					if (v20(v95.CancelPOM) or ((1161 - (306 + 9)) >= (8263 - 5895))) then
						return "cancel presence_of_mind aoe_spark_phase 1";
					end
				end
				if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(1 + 0, v93.ArcaneBarrage))) or ((2462 + 1550) <= (1617 + 1741))) then
					if (((4272 - 2778) <= (4380 - (1140 + 235))) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
						return "touch_of_the_magi aoe_spark_phase 2";
					end
				end
				if ((v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v113)) or ((1980 + 1131) == (1957 + 177))) then
					if (((605 + 1750) == (2407 - (33 + 19))) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), true)) then
						return "radiant_spark aoe_spark_phase 4";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (2 - 1)) or ((260 + 328) <= (846 - 414))) then
				if (((4499 + 298) >= (4584 - (586 + 103))) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v93.ArcaneOrb:TimeSinceLastCast() >= (2 + 13)) and (v12:ArcaneCharges() < (9 - 6))) then
					if (((5065 - (1309 + 179)) == (6456 - 2879)) and v20(v93.ArcaneOrb, not v13:IsInRange(18 + 22))) then
						return "arcane_orb aoe_spark_phase 6";
					end
				end
				if (((10189 - 6395) > (2790 + 903)) and v93.NetherTempest:IsReady() and v41 and (v93.NetherTempest:TimeSinceLastCast() >= (31 - 16)) and (v93.ArcaneEcho:IsAvailable())) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((2540 - 1265) == (4709 - (295 + 314)))) then
						return "nether_tempest aoe_spark_phase 8";
					end
				end
				if ((v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v113)) or ((3907 - 2316) >= (5542 - (1300 + 662)))) then
					if (((3086 - 2103) <= (3563 - (1178 + 577))) and v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge))) then
						return "arcane_surge aoe_spark_phase 10";
					end
				end
				v137 = 2 + 0;
			end
		end
	end
	local function v124()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1405 - (851 + 554))) or ((1902 + 248) <= (3319 - 2122))) then
				if (((8185 - 4416) >= (1475 - (115 + 187))) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (7 + 2))) then
					v104 = not v104;
				end
				if (((1406 + 79) == (5851 - 4366)) and v93.NetherTempest:IsReady() and v41 and (v13:DebuffRefreshable(v93.NetherTempestDebuff) or not v13:DebuffUp(v93.NetherTempestDebuff)) and (v12:ArcaneCharges() == (1165 - (160 + 1001))) and (v12:ManaPercentage() < (27 + 3)) and (v12:SpellHaste() < (0.667 + 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((6786 - 3471) <= (3140 - (237 + 121)))) then
						return "nether_tempest touch_phase 2";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v12:ArcaneCharges() < (899 - (525 + 372))) and (v12:ManaPercentage() < (56 - 26)) and (v12:SpellHaste() < (0.667 - 0)) and v12:BuffDown(v93.ArcaneSurgeBuff)) or ((1018 - (96 + 46)) >= (3741 - (643 + 134)))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(15 + 25)) or ((5351 - 3119) > (9270 - 6773))) then
						return "arcane_orb touch_phase 4";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (3 - 1)) or ((4313 - 2203) <= (1051 - (316 + 403)))) then
				if (((2451 + 1235) > (8720 - 5548)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (75 - 45)) and (v93.TouchoftheMagi:CooldownRemains() > (22 + 8))) or (v12:ManaPercentage() > (23 + 47))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((15502 - 11028) < (3916 - 3096))) then
						return "arcane_missiles interrupt touch_phase 12";
					end
				end
				if (((8888 - 4609) >= (165 + 2717)) and v93.ArcaneMissiles:IsCastable() and v37 and (v12:BuffStack(v93.ClearcastingBuff) > (1 - 0)) and v93.ConjureManaGem:IsAvailable() and v94.ManaGem:CooldownUp()) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((100 + 1929) >= (10359 - 6838))) then
						return "arcane_missiles touch_phase 12";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v32 and (v12:BuffUp(v93.NetherPrecisionBuff))) or ((2054 - (12 + 5)) >= (18029 - 13387))) then
					if (((3669 - 1949) < (9476 - 5018)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast touch_phase 14";
					end
				end
				v138 = 7 - 4;
			end
			if ((v138 == (1 + 0)) or ((2409 - (1656 + 317)) > (2692 + 329))) then
				if (((572 + 141) <= (2251 - 1404)) and v93.PresenceofMind:IsCastable() and v42 and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (((10600 - 8446) <= (4385 - (5 + 349))) and v20(v93.PresenceofMind)) then
						return "presence_of_mind touch_phase 6";
					end
				end
				if (((21920 - 17305) == (5886 - (266 + 1005))) and v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((2498 + 1292) == (1706 - 1206))) then
						return "arcane_blast touch_phase 8";
					end
				end
				if (((116 - 27) < (1917 - (561 + 1135))) and v93.ArcaneBarrage:IsReady() and v33 and (v12:BuffUp(v93.ArcaneHarmonyBuff) or (v93.ArcaneBombardment:IsAvailable() and (v13:HealthPercentage() < (45 - 10)))) and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v114)) then
					if (((6751 - 4697) >= (2487 - (507 + 559))) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 10";
					end
				end
				v138 = 4 - 2;
			end
			if (((2140 - 1448) < (3446 - (212 + 176))) and (v138 == (908 - (250 + 655)))) then
				if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > v93.ArcaneMissiles:CastTime()) or not v93.PresenceofMind:IsAvailable())) or ((8873 - 5619) == (2891 - 1236))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((2027 - 731) == (6866 - (1869 + 87)))) then
						return "arcane_missiles touch_phase 18";
					end
				end
				if (((11681 - 8313) == (5269 - (484 + 1417))) and v93.ArcaneBlast:IsReady() and v32) then
					if (((5664 - 3021) < (6393 - 2578)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
						return "arcane_blast touch_phase 20";
					end
				end
				if (((2686 - (48 + 725)) > (804 - 311)) and v93.ArcaneBarrage:IsReady() and v33) then
					if (((12757 - 8002) > (1993 + 1435)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage touch_phase 22";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v139 = 0 - 0;
		while true do
			if (((387 + 994) <= (691 + 1678)) and (v139 == (854 - (152 + 701)))) then
				if ((v93.ArcaneBarrage:IsReady() and v33 and ((((v100 <= (1315 - (430 + 881))) or (v101 <= (2 + 2))) and (v12:ArcaneCharges() == (898 - (557 + 338)))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()))) or ((1432 + 3411) == (11508 - 7424))) then
					if (((16349 - 11680) > (964 - 601)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage aoe_touch_phase 4";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (4 - 2))) or ((2678 - (499 + 302)) >= (4004 - (39 + 827)))) then
					if (((13090 - 8348) >= (8098 - 4472)) and v20(v93.ArcaneOrb, not v13:IsInRange(158 - 118))) then
						return "arcane_orb aoe_touch_phase 6";
					end
				end
				v139 = 2 - 0;
			end
			if (((0 + 0) == v139) or ((13288 - 8748) == (147 + 769))) then
				if ((v13:DebuffRemains(v93.TouchoftheMagiDebuff) > (13 - 4)) or ((1260 - (103 + 1)) > (4899 - (475 + 79)))) then
					v104 = not v104;
				end
				if (((4835 - 2598) < (13596 - 9347)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff)) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((347 + 2336) < (21 + 2))) then
						return "arcane_missiles aoe_touch_phase 2";
					end
				end
				v139 = 1504 - (1395 + 108);
			end
			if (((2027 - 1330) <= (2030 - (7 + 1197))) and (v139 == (1 + 1))) then
				if (((386 + 719) <= (1495 - (27 + 292))) and v93.ArcaneExplosion:IsCastable() and v34) then
					if (((9901 - 6522) <= (4860 - 1048)) and v20(v93.ArcaneExplosion, not v13:IsInRange(41 - 31))) then
						return "arcane_explosion aoe_touch_phase 8";
					end
				end
				break;
			end
		end
	end
	local function v126()
		if ((v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() < (5 - 2)) and (v12:BloodlustDown() or (v12:ManaPercentage() > (133 - 63)) or (v109 and (v93.TouchoftheMagi:CooldownRemains() > (169 - (43 + 96)))))) or ((3214 - 2426) >= (3653 - 2037))) then
			if (((1539 + 315) <= (955 + 2424)) and v20(v93.ArcaneOrb, not v13:IsInRange(79 - 39))) then
				return "arcane_orb rotation 2";
			end
		end
		v104 = ((v93.ArcaneSurge:CooldownRemains() > (12 + 18)) and (v93.TouchoftheMagi:CooldownRemains() > (18 - 8))) or false;
		if (((1433 + 3116) == (334 + 4215)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and v109 and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (1763 - (1414 + 337)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (1952 - (1642 + 298)))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (30 - 18))) and (v113 > (42 - 27))) then
			if (v20(v93.ShiftingPower, not v13:IsInRange(118 - 78)) or ((995 + 2027) >= (2353 + 671))) then
				return "shifting_power rotation 4";
			end
		end
		if (((5792 - (357 + 615)) > (1543 + 655)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and not v109 and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (110 - 65)) and (v113 > (13 + 2))) then
			if (v20(v93.ShiftingPower, not v13:IsInRange(85 - 45)) or ((849 + 212) >= (333 + 4558))) then
				return "shifting_power rotation 6";
			end
		end
		if (((858 + 506) <= (5774 - (384 + 917))) and v93.PresenceofMind:IsCastable() and v42 and (v12:ArcaneCharges() < (700 - (128 + 569))) and (v13:HealthPercentage() < (1578 - (1407 + 136))) and v93.ArcaneBombardment:IsAvailable()) then
			if (v20(v93.PresenceofMind) or ((5482 - (687 + 1200)) <= (1713 - (556 + 1154)))) then
				return "presence_of_mind rotation 8";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v93.TimeAnomaly:IsAvailable() and v12:BuffUp(v93.ArcaneSurgeBuff) and (v12:BuffRemains(v93.ArcaneSurgeBuff) <= (20 - 14))) or ((4767 - (9 + 86)) == (4273 - (275 + 146)))) then
			if (((254 + 1305) == (1623 - (29 + 35))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast rotation 10";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and v12:BuffUp(v93.PresenceofMindBuff) and (v13:HealthPercentage() < (155 - 120)) and v93.ArcaneBombardment:IsAvailable() and (v12:ArcaneCharges() < (8 - 5))) or ((7734 - 5982) <= (514 + 274))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((4919 - (53 + 959)) == (585 - (312 + 96)))) then
				return "arcane_blast rotation 12";
			end
		end
		if (((6022 - 2552) > (840 - (147 + 138))) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (899 - (813 + 86))) and v12:BuffUp(v93.NetherPrecisionBuff) and (((v12:ManaPercentage() > (28 + 2)) and (v93.TouchoftheMagi:CooldownRemains() > (55 - 25))) or (v12:ManaPercentage() > (562 - (18 + 474)))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((328 + 644) == (2105 - 1460))) then
				return "arcane_missiles interrupt rotation 20";
			end
		end
		if (((4268 - (860 + 226)) >= (2418 - (121 + 182))) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and (v12:BuffStack(v93.ClearcastingBuff) == v111)) then
			if (((480 + 3413) < (5669 - (988 + 252))) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles rotation 14";
			end
		end
		if ((v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v93.TemporalWarpBuff) or (v12:ManaPercentage() < (2 + 8)) or not v93.ShiftingPower:IsAvailable()) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v113 >= (4 + 8))) or ((4837 - (49 + 1921)) < (2795 - (223 + 667)))) then
			if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest)) or ((1848 - (51 + 1)) >= (6972 - 2921))) then
				return "nether_tempest rotation 16";
			end
		end
		if (((3466 - 1847) <= (4881 - (146 + 979))) and v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (15 + 35)) and not v93.Evocation:IsAvailable() and (v113 > (625 - (311 + 294)))) then
			if (((1684 - 1080) == (256 + 348)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage rotation 18";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (1513 - (496 + 947))) and v104 and v12:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (1363 - (1233 + 125))) and (v113 > (9 + 11))) or ((4023 + 461) == (171 + 729))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((6104 - (963 + 682)) <= (929 + 184))) then
				return "arcane_barrage rotation 20";
			end
		end
		if (((5136 - (504 + 1000)) > (2289 + 1109)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffUp(v93.ConcentrationBuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax())) then
			if (((3718 + 364) <= (464 + 4453)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles rotation 22";
			end
		end
		if (((7124 - 2292) >= (1185 + 201)) and v93.ArcaneBlast:IsReady() and v32 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v93.NetherPrecisionBuff)) then
			if (((80 + 57) == (319 - (156 + 26))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast rotation 24";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33 and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (35 + 25)) and v104 and (v93.TouchoftheMagi:CooldownRemains() > (15 - 5)) and (v93.Evocation:CooldownRemains() > (204 - (149 + 15))) and (v113 > (980 - (890 + 70)))) or ((1687 - (39 + 78)) >= (4814 - (14 + 468)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((8936 - 4872) <= (5084 - 3265))) then
				return "arcane_barrage rotation 26";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffDown(v93.NetherPrecisionBuff) and (not v109 or not v107)) or ((2573 + 2413) < (946 + 628))) then
			if (((941 + 3485) > (78 + 94)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
				return "arcane_missiles rotation 30";
			end
		end
		if (((154 + 432) > (870 - 415)) and v93.ArcaneBlast:IsReady() and v32) then
			if (((817 + 9) == (2902 - 2076)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast))) then
				return "arcane_blast rotation 32";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and v33) or ((102 + 3917) > (4492 - (12 + 39)))) then
			if (((1877 + 140) < (13189 - 8928)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage rotation 34";
			end
		end
	end
	local function v127()
		if (((16796 - 12080) > (24 + 56)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v113) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (7 + 5))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (29 - 17))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (8 + 4))) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (57 - 45))) or (v93.ArcaneOrb:Charges() == (1710 - (1596 + 114))) or (v93.ArcaneOrb:CooldownRemains() > (31 - 19)))) then
			if (v20(v93.ShiftingPower, not v13:IsInRange(753 - (164 + 549)), true) or ((4945 - (1059 + 379)) == (4062 - 790))) then
				return "shifting_power aoe_rotation 2";
			end
		end
		if ((v93.NetherTempest:IsReady() and v41 and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (4 + 2)) or (v101 > (2 + 4)) or not v93.OrbBarrage:IsAvailable())) or ((1268 - (145 + 247)) >= (2524 + 551))) then
			if (((2011 + 2341) > (7571 - 5017)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
				return "nether_tempest aoe_rotation 4";
			end
		end
		if ((v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and v12:BuffUp(v93.ClearcastingBuff) and (v93.TouchoftheMagi:CooldownRemains() > (v12:BuffRemains(v93.ArcaneArtilleryBuff) + 1 + 4))) or ((3796 + 610) < (6563 - 2520))) then
			if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((2609 - (254 + 466)) >= (3943 - (544 + 16)))) then
				return "arcane_missiles aoe_rotation 6";
			end
		end
		if (((6012 - 4120) <= (3362 - (294 + 334))) and v93.ArcaneBarrage:IsReady() and v33 and ((v100 <= (257 - (236 + 17))) or (v101 <= (2 + 2)) or v12:BuffUp(v93.ClearcastingBuff)) and (v12:ArcaneCharges() == (3 + 0))) then
			if (((7241 - 5318) < (10501 - 8283)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_rotation 8";
			end
		end
		if (((1119 + 1054) > (313 + 66)) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53) and (v77 < v113) and (v12:ArcaneCharges() == (794 - (413 + 381))) and (v93.TouchoftheMagi:CooldownRemains() > (1 + 17))) then
			if (v20(v93.ArcaneOrb, not v13:IsInRange(85 - 45)) or ((6730 - 4139) == (5379 - (582 + 1388)))) then
				return "arcane_orb aoe_rotation 10";
			end
		end
		if (((7690 - 3176) > (2380 + 944)) and v93.ArcaneBarrage:IsReady() and v33 and ((v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (374 - (326 + 38))))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((615 - 407) >= (6891 - 2063))) then
				return "arcane_barrage aoe_rotation 12";
			end
		end
		if ((v93.ArcaneExplosion:IsCastable() and v34) or ((2203 - (47 + 573)) > (1258 + 2309))) then
			if (v20(v93.ArcaneExplosion, not v13:IsInRange(42 - 32)) or ((2130 - 817) == (2458 - (1269 + 395)))) then
				return "arcane_explosion aoe_rotation 14";
			end
		end
	end
	local function v128()
		if (((3666 - (76 + 416)) > (3345 - (319 + 124))) and v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v113) and (v12:PrevGCDP(2 - 1, v93.ArcaneBarrage))) then
			if (((5127 - (564 + 443)) <= (11793 - 7533)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi))) then
				return "touch_of_the_magi main 30";
			end
		end
		if ((v12:IsChanneling(v93.Evocation) and (((v12:ManaPercentage() >= (553 - (337 + 121))) and not v93.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v113 * (11 - 7))) and not ((v113 > (33 - 23)) and (v93.ArcaneSurge:CooldownRemains() < (1912 - (1261 + 650))))))) or ((374 + 509) > (7614 - 2836))) then
			if (v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles)) or ((5437 - (772 + 1045)) >= (690 + 4201))) then
				return "cancel_action evocation main 32";
			end
		end
		if (((4402 - (102 + 42)) > (2781 - (1524 + 320))) and v93.ArcaneBarrage:IsReady() and v33 and (v113 < (1272 - (1049 + 221)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((5025 - (18 + 138)) < (2217 - 1311))) then
				return "arcane_barrage main 34";
			end
		end
		if ((v93.Evocation:IsCastable() and v39 and not v107 and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (1112 - (67 + 1035))) and (v93.TouchoftheMagi:CooldownRemains() < (368 - (136 + 212)))) or (v93.TouchoftheMagi:CooldownRemains() < (63 - 48))) and (v12:ManaPercentage() < (v113 * (4 + 0)))) or ((1130 + 95) > (5832 - (240 + 1364)))) then
			if (((4410 - (1050 + 32)) > (7990 - 5752)) and v20(v93.Evocation)) then
				return "evocation main 36";
			end
		end
		if (((2271 + 1568) > (2460 - (331 + 724))) and v93.ConjureManaGem:IsCastable() and v38 and v13:DebuffDown(v93.TouchoftheMagiDebuff) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (3 + 27)) and (v93.ArcaneSurge:CooldownRemains() < v113) and not v94.ManaGem:Exists()) then
			if (v20(v93.ConjureManaGem) or ((1937 - (269 + 375)) <= (1232 - (267 + 458)))) then
				return "conjure_mana_gem main 38";
			end
		end
		if ((v94.ManaGem:IsReady() and v40 and v93.CascadingPower:IsAvailable() and (v12:BuffStack(v93.ClearcastingBuff) < (1 + 1)) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((5568 - 2672) < (1623 - (667 + 151)))) then
			if (((3813 - (1410 + 87)) == (4213 - (1504 + 393))) and v20(v95.ManaGem)) then
				return "mana_gem main 40";
			end
		end
		if ((v94.ManaGem:IsReady() and v40 and not v93.CascadingPower:IsAvailable() and v12:PrevGCDP(2 - 1, v93.ArcaneSurge) and (not v108 or (v108 and v12:PrevGCDP(5 - 3, v93.ArcaneSurge)))) or ((3366 - (461 + 335)) == (196 + 1337))) then
			if (v20(v95.ManaGem) or ((2644 - (1730 + 31)) == (3127 - (728 + 939)))) then
				return "mana_gem main 42";
			end
		end
		if ((not v109 and ((v93.ArcaneSurge:CooldownRemains() <= (v114 * ((3 - 2) + v23(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v93.ArcaneSurgeBuff) > ((5 - 2) * v23(v12:HasTier(68 - 38, 1070 - (138 + 930)) and not v12:HasTier(28 + 2, 4 + 0)))) or v12:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (39 + 6)) and ((v93.TouchoftheMagi:CooldownRemains() < (v114 * (16 - 12))) or (v93.TouchoftheMagi:CooldownRemains() > (1786 - (459 + 1307)))) and ((v100 < v103) or (v101 < v103))) or ((6489 - (474 + 1396)) <= (1744 - 745))) then
			v26 = v121();
			if (v26 or ((3196 + 214) > (14 + 4102))) then
				return v26;
			end
		end
		if ((not v109 and (v93.ArcaneSurge:CooldownRemains() > (85 - 55)) and (v93.RadiantSpark:CooldownUp() or v13:DebuffUp(v93.RadiantSparkDebuff) or v13:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v114 * (1 + 2))) or v13:DebuffUp(v93.TouchoftheMagiDebuff)) and ((v100 < v103) or (v101 < v103))) or ((3014 - 2111) >= (13340 - 10281))) then
			local v182 = 591 - (562 + 29);
			while true do
				if ((v182 == (0 + 0)) or ((5395 - (374 + 1045)) < (2262 + 595))) then
					v26 = v121();
					if (((15308 - 10378) > (2945 - (448 + 190))) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if ((v29 and v93.RadiantSpark:IsAvailable() and v105) or ((1307 + 2739) < (583 + 708))) then
			local v183 = 0 + 0;
			while true do
				if ((v183 == (0 - 0)) or ((13177 - 8936) == (5039 - (1307 + 187)))) then
					v26 = v123();
					if (v26 or ((16052 - 12004) > (9908 - 5676))) then
						return v26;
					end
					break;
				end
			end
		end
		if ((v29 and v109 and v93.RadiantSpark:IsAvailable() and v106) or ((5365 - 3615) >= (4156 - (232 + 451)))) then
			local v184 = 0 + 0;
			while true do
				if (((2797 + 369) == (3730 - (510 + 54))) and (v184 == (0 - 0))) then
					v26 = v122();
					if (((1799 - (13 + 23)) < (7259 - 3535)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
		if (((81 - 24) <= (4946 - 2223)) and v29 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 >= v103) or (v101 >= v103))) then
			v26 = v125();
			if (v26 or ((3158 - (830 + 258)) == (1562 - 1119))) then
				return v26;
			end
		end
		if ((v29 and v109 and v13:DebuffUp(v93.TouchoftheMagiDebuff) and ((v100 < v103) or (v101 < v103))) or ((1693 + 1012) == (1186 + 207))) then
			local v185 = 1441 - (860 + 581);
			while true do
				if (((0 - 0) == v185) or ((3652 + 949) < (302 - (237 + 4)))) then
					v26 = v124();
					if (v26 or ((3266 - 1876) >= (12002 - 7258))) then
						return v26;
					end
					break;
				end
			end
		end
		if ((v100 >= v103) or (v101 >= v103) or ((3797 - 1794) > (3139 + 695))) then
			v26 = v127();
			if (v26 or ((90 + 66) > (14773 - 10860))) then
				return v26;
			end
		end
		if (((84 + 111) == (107 + 88)) and ((v100 < v103) or (v101 < v103))) then
			local v186 = 1426 - (85 + 1341);
			while true do
				if (((5298 - 2193) >= (5072 - 3276)) and ((372 - (45 + 327)) == v186)) then
					v26 = v126();
					if (((8262 - 3883) >= (2633 - (444 + 58))) and v26) then
						return v26;
					end
					break;
				end
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
		v63 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
		v64 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
		v65 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
		v66 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v67 = EpicSettings.Settings['iceColdHP'] or (1732 - (64 + 1668));
		v68 = EpicSettings.Settings['mirrorImageHP'] or (1973 - (1227 + 746));
		v69 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v88 = EpicSettings.Settings['useSpellStealTarget'];
		v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v90 = EpicSettings.Settings['mirrorImageBeforePull'];
		v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v130()
		local v176 = 0 - 0;
		while true do
			if (((4338 - (415 + 79)) >= (53 + 1990)) and (v176 == (495 - (142 + 349)))) then
				v72 = EpicSettings.Settings['handleAfflicted'];
				v73 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v176 == (2 + 1)) or ((4443 - 1211) <= (1358 + 1373))) then
				v83 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v176 = 1868 - (1710 + 154);
			end
			if (((5223 - (200 + 118)) == (1944 + 2961)) and (v176 == (0 - 0))) then
				v77 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v78 = EpicSettings.Settings['useWeapon'];
				v74 = EpicSettings.Settings['InterruptWithStun'];
				v75 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v176 = 1 + 0;
			end
			if ((v176 == (2 + 0)) or ((2220 + 1916) >= (705 + 3706))) then
				v79 = EpicSettings.Settings['useRacials'];
				v81 = EpicSettings.Settings['trinketsWithCD'];
				v82 = EpicSettings.Settings['racialsWithCD'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v176 = 6 - 3;
			end
			if (((1251 - (363 + 887)) == v176) or ((5165 - 2207) == (19120 - 15103))) then
				v76 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['DispelDebuffs'];
				v70 = EpicSettings.Settings['DispelBuffs'];
				v80 = EpicSettings.Settings['useTrinkets'];
				v176 = 1 + 1;
			end
		end
	end
	local function v131()
		local v177 = 0 - 0;
		while true do
			if (((840 + 388) >= (2477 - (674 + 990))) and (v177 == (1 + 0))) then
				v29 = EpicSettings.Toggles['cds'];
				v30 = EpicSettings.Toggles['minicds'];
				v31 = EpicSettings.Toggles['dispel'];
				if (v12:IsDeadOrGhost() or ((1414 + 2041) > (6419 - 2369))) then
					return v26;
				end
				v177 = 1057 - (507 + 548);
			end
			if (((1080 - (289 + 548)) == (2061 - (821 + 997))) and (v177 == (255 - (195 + 60)))) then
				v129();
				v130();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v177 = 1 + 0;
			end
			if ((v177 == (1504 - (251 + 1250))) or ((793 - 522) > (1081 + 491))) then
				v114 = v12:GCD();
				if (((3771 - (809 + 223)) < (4804 - 1511)) and v72) then
					if (v92 or ((11838 - 7896) < (3749 - 2615))) then
						v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 23 + 7);
						if (v26 or ((1411 + 1282) == (5590 - (14 + 603)))) then
							return v26;
						end
					end
				end
				if (((2275 - (118 + 11)) == (348 + 1798)) and (not v12:AffectingCombat() or v27)) then
					if ((v93.ArcaneIntellect:IsCastable() and v36 and (v12:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) or ((1870 + 374) == (9395 - 6171))) then
						if (v20(v93.ArcaneIntellect) or ((5853 - (551 + 398)) <= (1211 + 705))) then
							return "arcane_intellect group_buff";
						end
					end
					if (((33 + 57) <= (866 + 199)) and v93.ArcaneFamiliar:IsReady() and v35 and v12:BuffDown(v93.ArcaneFamiliarBuff)) then
						if (((17858 - 13056) == (11064 - 6262)) and v20(v93.ArcaneFamiliar)) then
							return "arcane_familiar precombat 2";
						end
					end
					if ((v93.ConjureManaGem:IsCastable() and v38) or ((739 + 1541) <= (2028 - 1517))) then
						if (v20(v93.ConjureManaGem) or ((463 + 1213) <= (552 - (40 + 49)))) then
							return "conjure_mana_gem precombat 4";
						end
					end
				end
				if (((14733 - 10864) == (4359 - (99 + 391))) and v97.TargetIsValid()) then
					if (((958 + 200) <= (11486 - 8873)) and v71 and v31 and v93.RemoveCurse:IsAvailable()) then
						if (v14 or ((5853 - 3489) <= (1948 + 51))) then
							v26 = v117();
							if (v26 or ((12951 - 8029) < (1798 - (1032 + 572)))) then
								return v26;
							end
						end
						if ((v15 and v15:Exists() and v15:IsAPlayer() and v97.UnitHasCurseDebuff(v15)) or ((2508 - (203 + 214)) < (1848 - (568 + 1249)))) then
							if (v93.RemoveCurse:IsReady() or ((1901 + 529) >= (11701 - 6829))) then
								if (v20(v95.RemoveCurseMouseover) or ((18424 - 13654) < (3041 - (913 + 393)))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if ((not v12:AffectingCombat() and v27) or ((12535 - 8096) <= (3320 - 970))) then
						local v208 = 410 - (269 + 141);
						while true do
							if ((v208 == (0 - 0)) or ((6460 - (362 + 1619)) < (6091 - (950 + 675)))) then
								v26 = v119();
								if (((982 + 1565) > (2404 - (216 + 963))) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					v26 = v115();
					if (((5958 - (485 + 802)) > (3233 - (432 + 127))) and v26) then
						return v26;
					end
					if (v72 or ((4769 - (1065 + 8)) < (1849 + 1478))) then
						if (v92 or ((6143 - (635 + 966)) == (2136 + 834))) then
							local v214 = 42 - (5 + 37);
							while true do
								if (((626 - 374) <= (823 + 1154)) and (v214 == (0 - 0))) then
									v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 15 + 15);
									if (v26 or ((2983 - 1547) == (14312 - 10537))) then
										return v26;
									end
									break;
								end
							end
						end
					end
					if (v73 or ((3051 - 1433) < (2223 - 1293))) then
						local v209 = 0 + 0;
						while true do
							if (((5252 - (318 + 211)) > (20434 - 16281)) and (v209 == (1587 - (963 + 624)))) then
								v26 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseover, 13 + 17);
								if (v26 or ((4500 - (518 + 328)) >= (10848 - 6194))) then
									return v26;
								end
								break;
							end
						end
					end
					if (((1519 - 568) <= (1813 - (301 + 16))) and v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v31 and v70 and not v12:IsCasting() and not v12:IsChanneling() and v97.UnitHasMagicBuff(v13)) then
						if (v20(v93.Spellsteal, not v13:IsSpellInRange(v93.Spellsteal)) or ((5087 - 3351) == (1603 - 1032))) then
							return "spellsteal damage";
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v97.TargetIsValid()) or ((2337 - 1441) > (4320 + 449))) then
						local v210 = 0 + 0;
						local v211;
						while true do
							if ((v210 == (3 - 1)) or ((629 + 416) <= (98 + 922))) then
								if ((v77 < v113) or ((3688 - 2528) <= (106 + 222))) then
									if (((4827 - (829 + 190)) > (10432 - 7508)) and v80 and ((v29 and v81) or not v81)) then
										local v216 = 0 - 0;
										while true do
											if (((5378 - 1487) < (12219 - 7300)) and (v216 == (0 + 0))) then
												v26 = v118();
												if (v26 or ((730 + 1504) <= (4558 - 3056))) then
													return v26;
												end
												break;
											end
										end
									end
								end
								v26 = v120();
								if (v26 or ((2371 + 141) < (1045 - (520 + 93)))) then
									return v26;
								end
								v210 = 279 - (259 + 17);
							end
							if ((v210 == (0 + 0)) or ((665 + 1183) == (2928 - 2063))) then
								if ((v29 and v78 and (v94.Dreambinder:IsEquippedAndReady() or v94.Iridal:IsEquippedAndReady())) or ((5273 - (396 + 195)) <= (13174 - 8633))) then
									if (v20(v95.UseWeapon, nil) or ((4787 - (440 + 1321)) >= (5875 - (1059 + 770)))) then
										return "Using Weapon Macro";
									end
								end
								v211 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
								if (((9285 - 7277) > (1183 - (424 + 121))) and v211) then
									return v211;
								end
								v210 = 1 + 0;
							end
							if (((3122 - (641 + 706)) <= (1281 + 1952)) and (v210 == (441 - (249 + 191)))) then
								if ((v12:IsMoving() and v93.IceFloes:IsReady() and not v12:BuffUp(v93.IceFloes)) or ((19790 - 15247) == (892 + 1105))) then
									if (v20(v93.IceFloes) or ((11955 - 8853) < (1155 - (183 + 244)))) then
										return "ice_floes movement";
									end
								end
								if (((17 + 328) == (1075 - (434 + 296))) and v89 and v93.TimeWarp:IsReady() and v93.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v113 <= (127 - 87)) or (v12:BuffUp(v93.ArcaneSurgeBuff) and (v113 <= (v93.ArcaneSurge:CooldownRemains() + (526 - (169 + 343))))))) then
									if (v20(v93.TimeWarp, not v13:IsInRange(36 + 4)) or ((4974 - 2147) < (1109 - 731))) then
										return "time_warp main 4";
									end
								end
								if ((v79 and ((v82 and v29) or not v82) and (v77 < v113)) or ((2848 + 628) < (7365 - 4768))) then
									local v215 = 1123 - (651 + 472);
									while true do
										if (((2327 + 752) < (2069 + 2725)) and (v215 == (1 - 0))) then
											if (((5337 - (397 + 86)) > (5340 - (423 + 453))) and v12:PrevGCDP(1 + 0, v93.ArcaneSurge)) then
												local v217 = 0 + 0;
												while true do
													if ((v217 == (0 + 0)) or ((3921 + 991) == (3357 + 401))) then
														if (((1316 - (50 + 1140)) <= (3010 + 472)) and v93.BloodFury:IsCastable()) then
															if (v20(v93.BloodFury) or ((1402 + 972) == (272 + 4102))) then
																return "blood_fury main 10";
															end
														end
														if (((2261 - 686) == (1140 + 435)) and v93.Fireblood:IsCastable()) then
															if (v20(v93.Fireblood) or ((2830 - (157 + 439)) == (2529 - 1074))) then
																return "fireblood main 12";
															end
														end
														v217 = 3 - 2;
													end
													if ((v217 == (2 - 1)) or ((1985 - (782 + 136)) > (2634 - (112 + 743)))) then
														if (((3332 - (1026 + 145)) >= (161 + 773)) and v93.AncestralCall:IsCastable()) then
															if (((2330 - (493 + 225)) == (5925 - 4313)) and v20(v93.AncestralCall)) then
																return "ancestral_call main 14";
															end
														end
														break;
													end
												end
											end
											break;
										end
										if (((2648 + 1704) >= (7595 - 4762)) and ((0 + 0) == v215)) then
											if ((v93.LightsJudgment:IsCastable() and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (5 - 3)) or (v101 >= (1 + 1)))) or ((5382 - 2160) < (4668 - (210 + 1385)))) then
												if (((2433 - (1201 + 488)) <= (1824 + 1118)) and v20(v93.LightsJudgment, not v13:IsSpellInRange(v93.LightsJudgment))) then
													return "lights_judgment main 6";
												end
											end
											if ((v93.Berserking:IsCastable() and ((v12:PrevGCDP(1 - 0, v93.ArcaneSurge) and not (v12:BuffUp(v93.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v93.ArcaneSurgeBuff) and v13:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((3287 - 1454) <= (1907 - (352 + 233)))) then
												if (v20(v93.Berserking) or ((8378 - 4911) <= (574 + 481))) then
													return "berserking main 8";
												end
											end
											v215 = 2 - 1;
										end
									end
								end
								v210 = 576 - (489 + 85);
							end
							if (((5042 - (277 + 1224)) == (5034 - (663 + 830))) and (v210 == (3 + 0))) then
								v26 = v128();
								if (v26 or ((8710 - 5153) >= (4878 - (461 + 414)))) then
									return v26;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v177 == (1 + 1)) or ((263 + 394) >= (159 + 1509))) then
				v99 = v13:GetEnemiesInSplashRange(5 + 0);
				v102 = v12:GetEnemiesInRange(290 - (172 + 78));
				if (v28 or ((1655 - 628) > (1420 + 2438))) then
					v100 = v25(v13:GetEnemiesInSplashRangeCount(7 - 2), #v102);
					v101 = #v102;
				else
					local v206 = 0 + 0;
					while true do
						if ((v206 == (0 + 0)) or ((6121 - 2467) < (566 - 116))) then
							v100 = 1 + 0;
							v101 = 1 + 0;
							break;
						end
					end
				end
				if (((674 + 1217) < (17725 - 13272)) and (v97.TargetIsValid() or v12:AffectingCombat())) then
					if (v12:AffectingCombat() or v71 or ((7315 - 4175) < (653 + 1476))) then
						local v212 = 0 + 0;
						local v213;
						while true do
							if ((v212 == (447 - (133 + 314))) or ((445 + 2110) < (1453 - (199 + 14)))) then
								v213 = v71 and v93.RemoveCurse:IsReady() and v31;
								v26 = v97.FocusUnit(v213, nil, 71 - 51, nil, 1569 - (647 + 902), v93.ArcaneIntellect);
								v212 = 2 - 1;
							end
							if ((v212 == (234 - (85 + 148))) or ((6016 - (426 + 863)) <= (22099 - 17377))) then
								if (((2394 - (873 + 781)) < (6610 - 1673)) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					v112 = v9.BossFightRemains(nil, true);
					v113 = v112;
					if (((9878 - 6220) >= (117 + 163)) and (v113 == (41047 - 29936))) then
						v113 = v9.FightRemains(v102, false);
					end
				end
				v177 = 3 - 0;
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

