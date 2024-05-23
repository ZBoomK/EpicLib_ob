local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4991 - (614 + 267)) > (4408 - (19 + 13)))) then
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
		if (v93.RemoveCurse:IsAvailable() or ((2653 - 1023) > (9782 - 5584))) then
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
	local v103;
	if (((3010 - 1956) == (274 + 780)) and not v93.ArcingCleave:IsAvailable()) then
		v103 = 15 - 6;
	elseif ((v93.ArcingCleave:IsAvailable() and (not v93.OrbBarrage:IsAvailable() or not v93.ArcaneBombardment:IsAvailable())) or ((1401 - 725) >= (3454 - (1293 + 519)))) then
		v103 = 10 - 5;
	else
		v103 = 7 - 4;
	end
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = 21247 - 10136;
	local v108 = 47911 - 36800;
	local v109;
	v9:RegisterForEvent(function()
		local v125 = 0 - 0;
		while true do
			if (((2191 + 1945) > (490 + 1907)) and (v125 == (0 - 0))) then
				v105 = true;
				v107 = 2568 + 8543;
				v125 = 1 + 0;
			end
			if ((v125 == (1 + 0)) or ((5430 - (709 + 387)) == (6103 - (673 + 1185)))) then
				v108 = 32223 - 21112;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		if (not v93.ArcingCleave:IsAvailable() or ((13730 - 9454) <= (4986 - 1955))) then
			v103 = 7 + 2;
		elseif ((v93.ArcingCleave:IsAvailable() and (not v93.OrbBarrage:IsAvailable() or not v93.ArcaneBombardment:IsAvailable())) or ((3574 + 1208) <= (1618 - 419))) then
			v103 = 2 + 3;
		else
			v103 = 5 - 2;
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v110()
		if ((v93.PrismaticBarrier:IsCastable() and v57 and v12:BuffDown(v93.PrismaticBarrier) and (v12:HealthPercentage() <= v64)) or ((9548 - 4684) < (3782 - (446 + 1434)))) then
			if (((6122 - (1040 + 243)) >= (11043 - 7343)) and v20(v93.PrismaticBarrier)) then
				return "ice_barrier defensive 1";
			end
		end
		if ((v93.MassBarrier:IsCastable() and v61 and v12:BuffDown(v93.PrismaticBarrier) and v97.AreUnitsBelowHealthPercentage(v69, 1849 - (559 + 1288), v93.ArcaneIntellect)) or ((3006 - (609 + 1322)) > (2372 - (13 + 441)))) then
			if (((1479 - 1083) <= (9963 - 6159)) and v20(v93.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v93.IceBlock:IsCastable() and v59 and (v12:HealthPercentage() <= v66)) or ((20763 - 16594) == (82 + 2105))) then
			if (((5106 - 3700) == (500 + 906)) and v20(v93.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if (((671 + 860) < (12674 - 8403)) and v93.IceColdTalent:IsAvailable() and v93.IceColdAbility:IsCastable() and v60 and (v12:HealthPercentage() <= v67)) then
			if (((348 + 287) == (1167 - 532)) and v20(v93.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((2230 + 1143) <= (1978 + 1578)) and v93.MirrorImage:IsCastable() and v62 and (v12:HealthPercentage() <= v68)) then
			if (v20(v93.MirrorImage) or ((2365 + 926) < (2755 + 525))) then
				return "mirror_image defensive 4";
			end
		end
		if (((4292 + 94) >= (1306 - (153 + 280))) and v93.GreaterInvisibility:IsReady() and v58 and (v12:HealthPercentage() <= v65)) then
			if (((2659 - 1738) <= (990 + 112)) and v20(v93.GreaterInvisibility)) then
				return "greater_invisibility defensive 5";
			end
		end
		if (((1859 + 2847) >= (504 + 459)) and v93.AlterTime:IsReady() and v56 and (v12:HealthPercentage() <= v63)) then
			if (v20(v93.AlterTime) or ((872 + 88) <= (635 + 241))) then
				return "alter_time defensive 6";
			end
		end
		if ((v94.Healthstone:IsReady() and v84 and (v12:HealthPercentage() <= v86)) or ((3145 - 1079) == (577 + 355))) then
			if (((5492 - (89 + 578)) < (3460 + 1383)) and v20(v95.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v83 and (v12:HealthPercentage() <= v85)) or ((8060 - 4183) >= (5586 - (572 + 477)))) then
			if ((v87 == "Refreshing Healing Potion") or ((582 + 3733) < (1036 + 690))) then
				if (v94.RefreshingHealingPotion:IsReady() or ((440 + 3239) < (711 - (84 + 2)))) then
					if (v20(v95.RefreshingHealingPotion) or ((7622 - 2997) < (456 + 176))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v87 == "Dreamwalker's Healing Potion") or ((925 - (497 + 345)) > (46 + 1734))) then
				if (((93 + 453) <= (2410 - (605 + 728))) and v94.DreamwalkersHealingPotion:IsReady()) then
					if (v20(v95.RefreshingHealingPotion) or ((711 + 285) > (9562 - 5261))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
			if (((187 + 3883) > (2539 - 1852)) and (v87 == "Potion of Withering Dreams")) then
				if (v94.PotionOfWitheringDreams:IsReady() or ((592 + 64) >= (9226 - 5896))) then
					if (v20(v95.RefreshingHealingPotion) or ((1882 + 610) <= (824 - (457 + 32)))) then
						return "potion of withering dreams defensive";
					end
				end
			end
		end
	end
	local v111 = 0 + 0;
	local function v112()
		if (((5724 - (832 + 570)) >= (2414 + 148)) and v93.RemoveCurse:IsReady() and (v97.UnitHasDispellableDebuffByPlayer(v14) or v97.DispellableFriendlyUnit(6 + 14) or v97.UnitHasCurseDebuff(v14))) then
			local v154 = 0 - 0;
			while true do
				if ((v154 == (0 + 0)) or ((4433 - (588 + 208)) >= (10161 - 6391))) then
					if ((v111 == (1800 - (884 + 916))) or ((4980 - 2601) > (2655 + 1923))) then
						v111 = GetTime();
					end
					if (v97.Wait(1153 - (232 + 421), v111) or ((2372 - (1569 + 320)) > (183 + 560))) then
						local v198 = 0 + 0;
						while true do
							if (((8269 - 5815) > (1183 - (316 + 289))) and (v198 == (0 - 0))) then
								if (((43 + 887) < (5911 - (666 + 787))) and v20(v95.RemoveCurseFocus)) then
									return "remove_curse dispel";
								end
								v111 = 425 - (360 + 65);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v113()
		v26 = v97.HandleTopTrinket(v96, v29, 38 + 2, nil);
		if (((916 - (79 + 175)) <= (1532 - 560)) and v26) then
			return v26;
		end
		v26 = v97.HandleBottomTrinket(v96, v29, 32 + 8, nil);
		if (((13395 - 9025) == (8416 - 4046)) and v26) then
			return v26;
		end
	end
	local function v114()
		if ((v93.MirrorImage:IsCastable() and v90 and v62) or ((5661 - (503 + 396)) <= (1042 - (92 + 89)))) then
			if (v20(v93.MirrorImage) or ((2738 - 1326) == (2187 + 2077))) then
				return "mirror_image precombat 2";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32 and not v93.SiphonStorm:IsAvailable()) or ((1875 + 1293) < (8431 - 6278))) then
			if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast)) or ((681 + 4295) < (3036 - 1704))) then
				return "arcane_blast precombat 4";
			end
		end
		if (((4038 + 590) == (2211 + 2417)) and v93.Evocation:IsReady() and v39 and (v93.SiphonStorm:IsAvailable())) then
			if (v20(v93.Evocation) or ((164 - 110) == (50 + 345))) then
				return "evocation precombat 6";
			end
		end
		if (((124 - 42) == (1326 - (485 + 759))) and v93.ArcaneOrb:IsReady() and v48 and ((v53 and v30) or not v53)) then
			if (v20(v93.ArcaneOrb, not v13:IsInRange(92 - 52)) or ((1770 - (442 + 747)) < (1417 - (832 + 303)))) then
				return "arcane_orb precombat 8";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and v32) or ((5555 - (88 + 858)) < (761 + 1734))) then
			if (((954 + 198) == (48 + 1104)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast precombat 8";
			end
		end
	end
	local function v115()
		local v126 = 789 - (766 + 23);
		while true do
			if (((9360 - 7464) <= (4679 - 1257)) and (v126 == (2 - 1))) then
				if ((v13:DebuffUp(v93.TouchoftheMagiDebuff) and v105) or ((3360 - 2370) > (2693 - (1036 + 37)))) then
					v105 = false;
				end
				v106 = v93.ArcaneBlast:CastTime() < v109;
				break;
			end
			if ((v126 == (0 + 0)) or ((1707 - 830) > (3694 + 1001))) then
				if (((4171 - (641 + 839)) >= (2764 - (910 + 3))) and (v100 >= v103) and ((v93.ArcaneOrb:Charges() > (0 - 0)) or (v12:ArcaneCharges() >= (1687 - (1466 + 218)))) and (v93.RadiantSpark:CooldownUp() or not v93.RadiantSpark:IsAvailable()) and ((v93.TouchoftheMagi:CooldownRemains() <= (v109 * (1 + 1))) or not v93.TouchoftheMagi:IsAvailable())) then
					v104 = true;
				end
				if ((v104 and ((v13:DebuffDown(v93.RadiantSparkVulnerability) and (v13:DebuffRemains(v93.RadiantSparkDebuff) < (1155 - (556 + 592))) and v93.RadiantSpark:CooldownDown()) or (not v93.RadiantSpark:IsAvailable() and v13:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((1062 + 1923) >= (5664 - (329 + 479)))) then
					v104 = false;
				end
				v126 = 855 - (174 + 680);
			end
		end
	end
	local function v116()
		if (((14693 - 10417) >= (2476 - 1281)) and v93.TouchoftheMagi:IsReady() and (v12:PrevGCDP(1 + 0, v93.ArcaneBarrage)) and v50 and ((v55 and v30) or not v55) and (v77 < v108)) then
			if (((3971 - (396 + 343)) <= (415 + 4275)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes))) then
				return "touch_of_the_magi aoe_cooldown_phase 2";
			end
		end
		if ((v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v108)) or ((2373 - (29 + 1448)) >= (4535 - (135 + 1254)))) then
			if (((11531 - 8470) >= (13811 - 10853)) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), v12:BuffDown(v93.IceFloes))) then
				return "radiant_spark aoe_cooldown_phase 4";
			end
		end
		if (((2124 + 1063) >= (2171 - (389 + 1138))) and v93.ArcaneOrb:IsReady() and (v12:ArcaneCharges() < (577 - (102 + 472))) and v48 and ((v53 and v30) or not v53) and (v77 < v108)) then
			if (((608 + 36) <= (391 + 313)) and v20(v93.ArcaneOrb, not v13:IsInRange(38 + 2))) then
				return "arcane_orb aoe_cooldown_phase 6";
			end
		end
		if (((2503 - (320 + 1225)) > (1685 - 738)) and v93.NetherTempest:IsReady() and v93.ArcaneEcho:IsAvailable() and v13:DebuffRefreshable(v93.NetherTempestDebuff) and v41) then
			if (((2749 + 1743) >= (4118 - (157 + 1307))) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes))) then
				return "nether_tempest aoe_cooldown_phase 8";
			end
		end
		if (((5301 - (821 + 1038)) >= (3749 - 2246)) and v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v108)) then
			if (v20(v93.ArcaneSurge, not v13:IsSpellInRange(v93.ArcaneSurge), v12:BuffDown(v93.IceFloes)) or ((347 + 2823) <= (2600 - 1136))) then
				return "arcane_surge aoe_cooldown_phase 10";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and (v93.ArcaneSurge:CooldownRemains() < (28 + 47)) and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (9 - 5)) and not v93.OrbBarrage:IsAvailable() and v33) or ((5823 - (834 + 192)) == (279 + 4109))) then
			if (((142 + 409) <= (15 + 666)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_cooldown_phase 12";
			end
		end
		if (((5075 - 1798) > (711 - (300 + 4))) and v93.ArcaneBarrage:IsReady() and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 1)) and (v93.ArcaneSurge:CooldownRemains() > (196 - 121))) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (363 - (112 + 250))) and (v93.ArcaneSurge:CooldownRemains() < (30 + 45)) and not v93.OrbBarrage:IsAvailable())) and v33) then
			if (((11762 - 7067) >= (811 + 604)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
				return "arcane_barrage aoe_cooldown_phase 14";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 0)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 0)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (2 + 1)) and (v100 > (4 + 1))) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (1418 - (1001 + 413)))) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v93.OrbBarrage:IsAvailable() and v33) or ((7162 - 3950) <= (1826 - (244 + 638)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((3789 - (627 + 66)) <= (5357 - 3559))) then
				return "arcane_barrage aoe_cooldown_phase 16";
			end
		end
		if (((4139 - (512 + 90)) == (5443 - (1665 + 241))) and v93.PresenceofMind:IsCastable() and v42) then
			if (((4554 - (373 + 344)) >= (709 + 861)) and v20(v93.PresenceofMind)) then
				return "presence_of_mind aoe_cooldown_phase 18";
			end
		end
		if ((v93.ArcaneBlast:IsReady() and ((((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 1)) or (v13:DebuffStack(v93.RadiantSparkVulnerability) == (7 - 4))) and not v93.OrbBarrage:IsAvailable()) or (v13:DebuffUp(v93.RadiantSparkVulnerability) and v93.OrbBarrage:IsAvailable())) and v32) or ((4992 - 2042) == (4911 - (35 + 1064)))) then
			if (((3437 + 1286) >= (4959 - 2641)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
				return "arcane_blast aoe_cooldown_phase 20";
			end
		end
		if ((v93.ArcaneBarrage:IsReady() and (((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1 + 3)) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (1239 - (298 + 938))) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.OrbBarrage:IsAvailable()))) or ((3286 - (233 + 1026)) > (4518 - (636 + 1030)))) then
			if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((581 + 555) > (4217 + 100))) then
				return "arcane_barrage aoe_cooldown_phase 22";
			end
		end
	end
	local function v117()
		local v127 = 0 + 0;
		while true do
			if (((321 + 4427) == (4969 - (55 + 166))) and ((0 + 0) == v127)) then
				if (((376 + 3360) <= (18102 - 13362)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v108) and (not v93.Evocation:IsAvailable() or (v93.Evocation:CooldownRemains() > (309 - (36 + 261)))) and (not v93.ArcaneSurge:IsAvailable() or (v93.ArcaneSurge:CooldownRemains() > (20 - 8))) and (not v93.TouchoftheMagi:IsAvailable() or (v93.TouchoftheMagi:CooldownRemains() > (1380 - (34 + 1334)))) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((not v93.ChargedOrb:IsAvailable() and (v93.ArcaneOrb:CooldownRemains() > (5 + 7))) or (v93.ArcaneOrb:Charges() == (0 + 0)) or (v93.ArcaneOrb:CooldownRemains() > (1295 - (1035 + 248)))) and v13:DebuffDown(v93.TouchoftheMagiDebuff)) then
					if (v20(v93.ShiftingPower, not v13:IsInRange(39 - (20 + 1))) or ((1767 + 1623) <= (3379 - (134 + 185)))) then
						return "shifting_power aoe_rotation 2";
					end
				end
				if ((v93.NetherTempest:IsReady() and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffDown(v93.ArcaneSurgeBuff) and ((v100 > (1139 - (549 + 584))) or not v93.OrbBarrage:IsAvailable()) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and v41) or ((1684 - (314 + 371)) > (9244 - 6551))) then
					if (((1431 - (478 + 490)) < (319 + 282)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest))) then
						return "nether_tempest aoe_rotation 4";
					end
				end
				v127 = 1173 - (786 + 386);
			end
			if ((v127 == (3 - 2)) or ((3562 - (1055 + 324)) < (2027 - (1093 + 247)))) then
				if (((4043 + 506) == (479 + 4070)) and v93.ArcaneMissiles:IsCastable() and v37 and v12:BuffUp(v93.ArcaneArtilleryBuff) and ((v93.TouchoftheMagi:CooldownRemains() + (19 - 14)) > v12:BuffRemains(v93.ArcaneArtilleryBuff))) then
					if (((15855 - 11183) == (13294 - 8622)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
						return "arcane_missiles aoe_rotation 6";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (((v100 <= (9 - 5)) and (v12:ArcaneCharges() == (2 + 1))) or (v12:ArcaneCharges() == v12:ArcaneChargesMax()) or (v12:ManaPercentage() < (34 - 25)))) or ((12642 - 8974) < (298 + 97))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((10654 - 6488) == (1143 - (364 + 324)))) then
						return "arcane_barrage aoe_rotation 8";
					end
				end
				v127 = 5 - 3;
			end
			if (((4 - 2) == v127) or ((1475 + 2974) == (11142 - 8479))) then
				if ((v93.ArcaneOrb:IsReady() and (v12:ArcaneCharges() < (2 - 0)) and (v93.TouchoftheMagi:CooldownRemains() > (54 - 36)) and v48 and ((v53 and v30) or not v53) and (v77 < v108)) or ((5545 - (1249 + 19)) < (2698 + 291))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(155 - 115)) or ((1956 - (686 + 400)) >= (3256 + 893))) then
						return "arcane_orb aoe_rotation 10";
					end
				end
				if (((2441 - (73 + 156)) < (16 + 3167)) and v93.ArcaneExplosion:IsReady() and v13:IsInRange(821 - (721 + 90))) then
					if (((53 + 4593) > (9714 - 6722)) and v20(v93.ArcaneExplosion, not v13:IsInRange(480 - (224 + 246)))) then
						return "arcane_explosion aoe_rotation 12";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v128 = 0 - 0;
		while true do
			if (((2639 - 1205) < (564 + 2542)) and (v128 == (1 + 2))) then
				if (((578 + 208) < (6010 - 2987)) and v93.PresenceofMind:IsCastable() and (v13:DebuffRemains(v93.TouchoftheMagiDebuff) <= v109) and v42) then
					if (v19(v93.PresenceofMind) or ((8126 - 5684) < (587 - (203 + 310)))) then
						return "presence_of_mind cooldown_phase 26";
					end
				end
				if (((6528 - (1238 + 755)) == (317 + 4218)) and v93.ArcaneBlast:IsReady() and (v12:BuffUp(v93.PresenceofMindBuff)) and v32) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((4543 - (709 + 825)) <= (3878 - 1773))) then
						return "arcane_blast cooldown_phase 28";
					end
				end
				if (((2665 - 835) < (4533 - (196 + 668))) and v93.ArcaneMissiles:IsReady() and ((v12:BuffDown(v93.NetherPrecisionBuff) and v12:BuffUp(v93.ClearcastingBuff)) or ((v12:BuffStack(v93.ClearcastingBuff) > (7 - 5)) and v13:DebuffUp(v93.TouchoftheMagiDebuff))) and (v13:DebuffDown(v93.RadiantSparkVulnerability) or ((v13:DebuffStack(v93.RadiantSparkVulnerability) == (7 - 3)) and v12:PrevGCDP(834 - (171 + 662), v93.ArcaneBlast))) and v37) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((1523 - (4 + 89)) >= (12659 - 9047))) then
						return "arcane_missiles cooldown_phase 30";
					end
				end
				if (((977 + 1706) >= (10804 - 8344)) and v93.ArcaneBlast:IsReady() and v32) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((708 + 1096) >= (4761 - (35 + 1451)))) then
						return "arcane_blast cooldown_phase 32";
					end
				end
				break;
			end
			if (((1454 - (28 + 1425)) == v128) or ((3410 - (941 + 1052)) > (3480 + 149))) then
				if (((6309 - (822 + 692)) > (573 - 171)) and v93.ArcaneBlast:IsReady() and v105 and v93.ArcaneSurge:CooldownUp() and (v12:ManaPercentage() > (5 + 5)) and (v12:BuffRemains(v93.SiphonStormBuff) > (314 - (45 + 252))) and not v12:HasTier(30 + 0, 2 + 2) and v32) then
					if (((11713 - 6900) > (3998 - (114 + 319))) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
						return "arcane_blast cooldown_phase 10";
					end
				end
				if (((5616 - 1704) == (5012 - 1100)) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (0 + 0)) and (v12:ManaPercentage() > (44 - 14)) and v12:BuffUp(v93.NetherPrecisionBuff) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (((5910 - 3089) <= (6787 - (556 + 1407))) and v20(v95.StopCasting)) then
						return "arcane_missiles interrupt cooldown_phase 12";
					end
				end
				if (((2944 - (741 + 465)) <= (2660 - (170 + 295))) and v93.ArcaneMissiles:IsReady() and v93.RadiantSpark:CooldownUp() and v12:BuffUp(v93.ClearcastingBuff) and v93.NetherPrecision:IsAvailable() and (v12:BuffDown(v93.NetherPrecisionBuff) or (v12:BuffRemains(v93.NetherPrecisionBuff) < (v109 * (2 + 1)))) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v109 * (6 + 0)))) and v37) then
					if (((100 - 59) <= (2502 + 516)) and v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff)))) then
						return "arcane_missiles cooldown_phase 14";
					end
				end
				if (((1376 + 769) <= (2324 + 1780)) and v93.RadiantSpark:IsReady() and v49 and ((v54 and v30) or not v54) and (v77 < v108)) then
					if (((3919 - (957 + 273)) < (1296 + 3549)) and v20(v93.RadiantSpark, not v13:IsSpellInRange(v93.RadiantSpark), v12:BuffDown(v93.IceFloes))) then
						return "radiant_spark cooldown_phase 16";
					end
				end
				v128 = 1 + 1;
			end
			if (((7 - 5) == v128) or ((6118 - 3796) > (8008 - 5386))) then
				if ((v93.NetherTempest:IsReady() and (v93.NetherTempest:TimeSinceLastCast() >= (148 - 118)) and (v93.ArcaneEcho:IsAvailable()) and v41) or ((6314 - (389 + 1391)) == (1307 + 775))) then
					if (v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes)) or ((164 + 1407) > (4250 - 2383))) then
						return "nether_tempest cooldown_phase 18";
					end
				end
				if ((v93.ArcaneSurge:IsReady() and v46 and ((v51 and v29) or not v51) and (v77 < v108)) or ((3605 - (783 + 168)) >= (10054 - 7058))) then
					if (((3913 + 65) > (2415 - (309 + 2))) and v20(v93.ArcaneSurge)) then
						return "arcane_surge cooldown_phase 20";
					end
				end
				if (((9197 - 6202) > (2753 - (1090 + 122))) and v93.ArcaneBarrage:IsReady() and (v12:PrevGCDP(1 + 0, v93.ArcaneSurge) or v12:PrevGCDP(3 - 2, v93.NetherTempest) or v12:PrevGCDP(1 + 0, v93.RadiantSpark) or ((v100 >= ((1122 - (628 + 490)) - ((1 + 1) * v23(v93.OrbBarrage:IsAvailable())))) and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (9 - 5)) and v93.ArcingCleave:IsAvailable())) and v33) then
					if (((14847 - 11598) > (1727 - (431 + 343))) and v20(v93.ArcaneBarrage, v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage cooldown_phase 22";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and v13:DebuffUp(v93.RadiantSparkVulnerability) and ((v13:DebuffStack(v93.RadiantSparkVulnerability) < (7 - 3)) or (v106 and (v13:DebuffStack(v93.RadiantSparkVulnerability) == (11 - 7)))) and v32) or ((2586 + 687) > (585 + 3988))) then
					if (v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes)) or ((4846 - (556 + 1139)) < (1299 - (6 + 9)))) then
						return "arcane_blast cooldown_phase 24";
					end
				end
				v128 = 1 + 2;
			end
			if ((v128 == (0 + 0)) or ((2019 - (28 + 141)) == (593 + 936))) then
				if (((1013 - 192) < (1504 + 619)) and v93.TouchoftheMagi:IsReady() and (v12:PrevGCDP(1318 - (486 + 831), v93.ArcaneBarrage)) and v50 and ((v55 and v30) or not v55) and (v77 < v108)) then
					if (((2347 - 1445) < (8185 - 5860)) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes))) then
						return "touch_of_the_magi cooldown_phase 2";
					end
				end
				if (((163 + 695) <= (9365 - 6403)) and v93.ShiftingPower:IsReady() and v47 and ((v29 and v52) or not v52) and (v77 < v108) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v93.RadiantSpark:IsAvailable()) then
					if (v20(v93.ShiftingPower, not v13:IsInRange(1281 - (668 + 595))) or ((3551 + 395) < (260 + 1028))) then
						return "shifting_power cooldown_phase 4";
					end
				end
				if ((v93.ArcaneOrb:IsReady() and (v93.RadiantSpark:CooldownUp() or ((v100 >= (5 - 3)) and v13:DebuffDown(v93.RadiantSparkVulnerability))) and (v12:ArcaneCharges() < v12:ArcaneChargesMax()) and v48 and ((v53 and v30) or not v53) and (v77 < v108)) or ((3532 - (23 + 267)) == (2511 - (1129 + 815)))) then
					if (v20(v93.ArcaneOrb, not v13:IsInRange(427 - (371 + 16))) or ((2597 - (1326 + 424)) >= (2391 - 1128))) then
						return "arcane_orb cooldown_phase 6";
					end
				end
				if ((v93.ArcaneMissiles:IsReady() and v105 and v12:BuffUp(v93.ClearcastingBuff) and (v93.RadiantSpark:CooldownRemains() < (18 - 13)) and v12:BuffDown(v93.NetherPrecisionBuff) and (v12:BuffDown(v93.ArcaneArtilleryBuff) or (v12:BuffRemains(v93.ArcaneArtilleryBuff) <= (v109 * (124 - (88 + 30))))) and v37) or ((3024 - (720 + 51)) == (4117 - 2266))) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((3863 - (421 + 1355)) > (3912 - 1540))) then
						return "arcane_missiles cooldown_phase 8";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v119()
		local v129 = 1083 - (286 + 797);
		while true do
			if ((v129 == (3 - 2)) or ((7362 - 2917) < (4588 - (397 + 42)))) then
				if ((v93.NetherTempest:IsReady() and v13:DebuffRefreshable(v93.NetherTempestDebuff) and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:BuffUp(v93.TemporalWarpBuff) or (v12:ManaPercentage() < (4 + 6)) or not v93.ShiftingPower:IsAvailable()) and v12:BuffDown(v93.ArcaneSurgeBuff) and not v105 and (v108 >= (812 - (24 + 776))) and v41) or ((2800 - 982) == (870 - (222 + 563)))) then
					if (((1388 - 758) < (1532 + 595)) and v20(v93.NetherTempest, not v13:IsSpellInRange(v93.NetherTempest), v12:BuffDown(v93.IceFloes))) then
						return "nether_tempest rotation 8";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and (v12:ArcaneCharges() == v12:ArcaneChargesMax()) and (v12:ManaPercentage() < (260 - (23 + 167))) and (((v93.ArcaneSurge:CooldownRemains() > (1828 - (690 + 1108))) and (v93.TouchoftheMagi:CooldownRemains() > (4 + 6)) and v12:BloodlustUp() and (v93.TouchoftheMagi:CooldownRemains() > (5 + 0)) and (v108 > (878 - (40 + 808)))) or (not v93.Evocation:IsAvailable() and (v108 > (4 + 16)))) and v33) or ((7410 - 5472) == (2403 + 111))) then
					if (((2251 + 2004) >= (31 + 24)) and v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage))) then
						return "arcane_barrage rotation 10";
					end
				end
				v129 = 573 - (47 + 524);
			end
			if (((1947 + 1052) > (3159 - 2003)) and ((0 - 0) == v129)) then
				if (((5359 - 3009) > (2881 - (1165 + 561))) and v93.ArcaneOrb:IsReady() and (v12:ArcaneCharges() < (1 + 2)) and (v12:BloodlustDown() or (v12:ManaPercentage() > (216 - 146))) and v48 and ((v53 and v30) or not v53)) then
					if (((1538 + 2491) <= (5332 - (341 + 138))) and v20(v93.ArcaneOrb, not v13:IsInRange(11 + 29))) then
						return "arcane_orb rotation 2";
					end
				end
				if ((v93.ShiftingPower:IsReady() and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() > (92 - 47)) and (v108 > (341 - (89 + 237))) and v47 and ((v29 and v52) or not v52) and (v77 < v108)) or ((1659 - 1143) > (7229 - 3795))) then
					if (((4927 - (581 + 300)) >= (4253 - (855 + 365))) and v20(v93.ShiftingPower, not v13:IsInRange(42 - 24))) then
						return "shifting_power rotation 4";
					end
				end
				v129 = 1 + 0;
			end
			if ((v129 == (1237 - (1030 + 205))) or ((2553 + 166) <= (1347 + 100))) then
				if ((v93.PresenceofMind:IsCastable() and (v12:ArcaneCharges() < (289 - (156 + 130))) and (v13:HealthPercentage() < (79 - 44)) and v93.ArcaneBombardment:IsAvailable() and v42) or ((6966 - 2832) < (8040 - 4114))) then
					if (v20(v93.PresenceofMind) or ((44 + 120) >= (1625 + 1160))) then
						return "presence_of_mind rotation 12";
					end
				end
				if ((v93.ArcaneBlast:IsReady() and (((v12:ArcaneCharges() == v12:ArcaneChargesMax()) and v12:BuffUp(v93.NetherPrecisionBuff)) or (v93.TimeAnomaly:IsAvailable() and v12:BuffUp(v93.ArcaneSurgeBuff) and (v12:BuffRemains(v93.ArcaneSurgeBuff) <= (75 - (10 + 59))))) and v32) or ((149 + 376) == (10386 - 8277))) then
					if (((1196 - (671 + 492)) == (27 + 6)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
						return "arcane_blast rotation 14";
					end
				end
				v129 = 1218 - (369 + 846);
			end
			if (((809 + 2245) <= (3427 + 588)) and (v129 == (1949 - (1036 + 909)))) then
				if (((1488 + 383) < (5677 - 2295)) and v93.ArcaneBlast:IsReady() and v32) then
					if (((1496 - (11 + 192)) <= (1095 + 1071)) and v20(v93.ArcaneBlast, not v13:IsSpellInRange(v93.ArcaneBlast), v12:BuffDown(v93.IceFloes))) then
						return "arcane_blast rotation 20";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33) or ((2754 - (135 + 40)) < (297 - 174))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage)) or ((510 + 336) >= (5216 - 2848))) then
						return "arcane_barrage rotation 22";
					end
				end
				break;
			end
			if ((v129 == (4 - 1)) or ((4188 - (50 + 126)) <= (9350 - 5992))) then
				if (((331 + 1163) <= (4418 - (1233 + 180))) and v12:IsChanneling(v93.ArcaneMissiles) and (v12:GCDRemains() == (969 - (522 + 447))) and v12:BuffUp(v93.NetherPrecisionBuff) and (v12:ManaPercentage() > (1451 - (107 + 1314))) and v12:BuffDown(v93.ArcaneArtilleryBuff)) then
					if (v20(v95.StopCasting) or ((1444 + 1667) == (6502 - 4368))) then
						return "arcane_missiles interrupt rotation 16";
					end
				end
				if (((1001 + 1354) == (4676 - 2321)) and v93.ArcaneMissiles:IsCastable() and v12:BuffUp(v93.ClearcastingBuff) and v12:BuffDown(v93.NetherPrecisionBuff) and not v105 and v37) then
					if (v20(v93.ArcaneMissiles, not v13:IsSpellInRange(v93.ArcaneMissiles), not (v93.Slipstream:IsAvailable() and v12:BuffUp(v93.ClearcastingBuff))) or ((2326 - 1738) <= (2342 - (716 + 1194)))) then
						return "arcane_missiles rotation 18";
					end
				end
				v129 = 1 + 3;
			end
		end
	end
	local function v120()
		local v130 = 0 + 0;
		while true do
			if (((5300 - (74 + 429)) >= (7513 - 3618)) and (v130 == (1 + 0))) then
				if (((8187 - 4610) == (2531 + 1046)) and v93.ConjureManaGem:IsCastable() and v38 and v13:DebuffDown(v93.TouchoftheMagiDebuff) and v12:BuffDown(v93.ArcaneSurgeBuff) and (v93.ArcaneSurge:CooldownRemains() < (92 - 62)) and (v93.ArcaneSurge:CooldownRemains() < v108) and not v94.ManaGem:Exists()) then
					if (((9380 - 5586) > (4126 - (279 + 154))) and v20(v93.ConjureManaGem)) then
						return "conjure_mana_gem main 38";
					end
				end
				if ((v94.ManaGem:IsReady() and v40 and v93.CascadingPower:IsAvailable() and (v12:BuffStack(v93.ClearcastingBuff) < (780 - (454 + 324))) and v12:BuffUp(v93.ArcaneSurgeBuff)) or ((1004 + 271) == (4117 - (12 + 5)))) then
					if (v20(v95.ManaGem) or ((858 + 733) >= (9121 - 5541))) then
						return "mana_gem main 40";
					end
				end
				if (((364 + 619) <= (2901 - (277 + 816))) and v94.ManaGem:IsReady() and v40 and not v93.CascadingPower:IsAvailable() and (v12:PrevGCDP(4 - 3, v93.ArcaneSurge))) then
					if (v20(v95.ManaGem) or ((3333 - (1058 + 125)) <= (225 + 972))) then
						return "mana_gem main 42";
					end
				end
				if (((4744 - (815 + 160)) >= (5032 - 3859)) and ((v93.ArcaneSurge:CooldownRemains() <= (v109 * ((2 - 1) + v23(v93.NetherTempest:IsAvailable() and v93.ArcaneEcho:IsAvailable())))) or (v12:BuffRemains(v93.ArcaneSurgeBuff) > ((1 + 2) * v23(v12:HasTier(87 - 57, 1900 - (41 + 1857)) and not v12:HasTier(1923 - (1222 + 671), 10 - 6)))) or v12:BuffUp(v93.ArcaneOverloadBuff)) and (v93.Evocation:CooldownRemains() > (64 - 19)) and ((v93.TouchoftheMagi:CooldownRemains() < (v109 * (1186 - (229 + 953)))) or (v93.TouchoftheMagi:CooldownRemains() > (1794 - (1111 + 663)))) and (v100 < v103)) then
					v26 = v118();
					if (((3064 - (874 + 705)) == (208 + 1277)) and v26) then
						return v26;
					end
				end
				v130 = 2 + 0;
			end
			if ((v130 == (3 - 1)) or ((94 + 3221) <= (3461 - (642 + 37)))) then
				if (((v93.ArcaneSurge:CooldownRemains() > (7 + 23)) and (v93.RadiantSpark:CooldownUp() or v13:DebuffUp(v93.RadiantSparkDebuff) or v13:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v109 * (1 + 2))) or v13:DebuffUp(v93.TouchoftheMagiDebuff)) and (v100 < v103)) or ((2199 - 1323) >= (3418 - (233 + 221)))) then
					v26 = v118();
					if (v26 or ((5160 - 2928) > (2198 + 299))) then
						return v26;
					end
				end
				if (((v93.ArcaneSurge:CooldownRemains() > (1571 - (718 + 823))) and (v93.RadiantSpark:CooldownUp() or v13:DebuffUp(v93.RadiantSparkDebuff) or v13:DebuffUp(v93.RadiantSparkVulnerability)) and ((v93.TouchoftheMagi:CooldownRemains() <= (v109 * (2 + 1))) or v13:DebuffUp(v93.TouchoftheMagiDebuff)) and (v100 < v103)) or ((2915 - (266 + 539)) <= (939 - 607))) then
					v26 = v118();
					if (((4911 - (636 + 589)) > (7529 - 4357)) and v26) then
						return v26;
					end
				end
				if ((v104 and ((v93.ArcaneSurge:CooldownRemains() < (v109 * (8 - 4))) or (v93.ArcaneSurge:CooldownRemains() > (32 + 8)))) or ((1626 + 2848) < (1835 - (657 + 358)))) then
					local v196 = 0 - 0;
					while true do
						if (((9748 - 5469) >= (4069 - (1151 + 36))) and (v196 == (0 + 0))) then
							v26 = v116();
							if (v26 or ((534 + 1495) >= (10515 - 6994))) then
								return v26;
							end
							break;
						end
					end
				end
				if ((v100 >= v103) or ((3869 - (1552 + 280)) >= (5476 - (64 + 770)))) then
					local v197 = 0 + 0;
					while true do
						if (((3904 - 2184) < (792 + 3666)) and (v197 == (1243 - (157 + 1086)))) then
							v26 = v117();
							if (v26 or ((872 - 436) > (13231 - 10210))) then
								return v26;
							end
							break;
						end
					end
				end
				v130 = 3 - 0;
			end
			if (((972 - 259) <= (1666 - (599 + 220))) and (v130 == (5 - 2))) then
				v26 = v119();
				if (((4085 - (1813 + 118)) <= (2947 + 1084)) and v26) then
					return v26;
				end
				break;
			end
			if (((5832 - (841 + 376)) == (6466 - 1851)) and (v130 == (0 + 0))) then
				if ((v93.TouchoftheMagi:IsReady() and v50 and ((v55 and v30) or not v55) and (v77 < v108) and (v12:PrevGCDP(2 - 1, v93.ArcaneBarrage))) or ((4649 - (464 + 395)) == (1283 - 783))) then
					if (((43 + 46) < (1058 - (467 + 370))) and v20(v93.TouchoftheMagi, not v13:IsSpellInRange(v93.TouchoftheMagi), v12:BuffDown(v93.IceFloes))) then
						return "touch_of_the_magi main 30";
					end
				end
				if (((4244 - 2190) >= (1044 + 377)) and v12:IsChanneling(v93.Evocation) and (((v12:ManaPercentage() >= (325 - 230)) and not v93.SiphonStorm:IsAvailable()) or ((v12:ManaPercentage() > (v108 * (1 + 3))) and not ((v108 > (23 - 13)) and (v93.ArcaneSurge:CooldownRemains() < (521 - (150 + 370))))))) then
					if (((1974 - (74 + 1208)) < (7521 - 4463)) and v20(v95.StopCasting, not v13:IsSpellInRange(v93.ArcaneMissiles))) then
						return "cancel_action evocation main 32";
					end
				end
				if ((v93.ArcaneBarrage:IsReady() and v33 and (v108 < (9 - 7))) or ((2316 + 938) == (2045 - (14 + 376)))) then
					if (v20(v93.ArcaneBarrage, not v13:IsSpellInRange(v93.ArcaneBarrage), false) or ((2247 - 951) == (3178 + 1732))) then
						return "arcane_barrage main 34";
					end
				end
				if (((2959 + 409) == (3213 + 155)) and v93.Evocation:IsCastable() and v39 and not v105 and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and (((v12:ManaPercentage() < (29 - 19)) and (v93.TouchoftheMagi:CooldownRemains() < (16 + 4))) or (v93.TouchoftheMagi:CooldownRemains() < (93 - (23 + 55)))) and (((v12:BloodlustRemains() < (73 - 42)) and v12:BloodlustUp()) or not v105)) then
					if (((1764 + 879) < (3426 + 389)) and v20(v93.Evocation)) then
						return "evocation main 36";
					end
				end
				v130 = 1 - 0;
			end
		end
	end
	local function v121()
		local v131 = 0 + 0;
		while true do
			if (((2814 - (652 + 249)) > (1319 - 826)) and (v131 == (1870 - (708 + 1160)))) then
				v43 = EpicSettings.Settings['useCounterspell'];
				v44 = EpicSettings.Settings['useBlastWave'];
				v45 = EpicSettings.Settings['useDragonsBreath'];
				v46 = EpicSettings.Settings['useArcaneSurge'];
				v47 = EpicSettings.Settings['useShiftingPower'];
				v48 = EpicSettings.Settings['useArcaneOrb'];
				v131 = 8 - 5;
			end
			if (((8669 - 3914) > (3455 - (10 + 17))) and (v131 == (2 + 4))) then
				v67 = EpicSettings.Settings['iceColdHP'] or (1732 - (1400 + 332));
				v68 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v69 = EpicSettings.Settings['massBarrierHP'] or (1908 - (242 + 1666));
				v88 = EpicSettings.Settings['useSpellStealTarget'];
				v89 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v90 = EpicSettings.Settings['mirrorImageBeforePull'];
				v131 = 3 + 4;
			end
			if (((507 + 874) <= (2019 + 350)) and (v131 == (944 - (850 + 90)))) then
				v55 = EpicSettings.Settings['touchOfTheMagiWithMiniCD'];
				v56 = EpicSettings.Settings['useAlterTime'];
				v57 = EpicSettings.Settings['usePrismaticBarrier'];
				v58 = EpicSettings.Settings['useGreaterInvisibility'];
				v59 = EpicSettings.Settings['useIceBlock'];
				v60 = EpicSettings.Settings['useIceCold'];
				v131 = 8 - 3;
			end
			if ((v131 == (1393 - (360 + 1030))) or ((4286 + 557) == (11527 - 7443))) then
				v49 = EpicSettings.Settings['useRadiantSpark'];
				v50 = EpicSettings.Settings['useTouchOfTheMagi'];
				v51 = EpicSettings.Settings['arcaneSurgeWithCD'];
				v52 = EpicSettings.Settings['shiftingPowerWithCD'];
				v53 = EpicSettings.Settings['arcaneOrbWithMiniCD'];
				v54 = EpicSettings.Settings['radiantSparkWithMiniCD'];
				v131 = 5 - 1;
			end
			if (((6330 - (909 + 752)) > (1586 - (109 + 1114))) and ((1 - 0) == v131)) then
				v38 = EpicSettings.Settings['useConjureManaGem'];
				v39 = EpicSettings.Settings['useEvocation'];
				v40 = EpicSettings.Settings['useManaGem'];
				v41 = EpicSettings.Settings['useNetherTempest'];
				v42 = EpicSettings.Settings['usePresenceOfMind'];
				v91 = EpicSettings.Settings['cancelPOM'];
				v131 = 1 + 1;
			end
			if ((v131 == (242 - (6 + 236))) or ((1183 + 694) >= (2526 + 612))) then
				v32 = EpicSettings.Settings['useArcaneBlast'];
				v33 = EpicSettings.Settings['useArcaneBarrage'];
				v34 = EpicSettings.Settings['useArcaneExplosion'];
				v35 = EpicSettings.Settings['useArcaneFamiliar'];
				v36 = EpicSettings.Settings['useArcaneIntellect'];
				v37 = EpicSettings.Settings['useArcaneMissiles'];
				v131 = 2 - 1;
			end
			if (((8282 - 3540) >= (4759 - (1076 + 57))) and (v131 == (1 + 4))) then
				v61 = EpicSettings.Settings['useMassBarrier'];
				v62 = EpicSettings.Settings['useMirrorImage'];
				v63 = EpicSettings.Settings['alterTimeHP'] or (689 - (579 + 110));
				v64 = EpicSettings.Settings['prismaticBarrierHP'] or (0 + 0);
				v65 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v66 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v131 = 413 - (174 + 233);
			end
			if ((v131 == (19 - 12)) or ((7968 - 3428) == (408 + 508))) then
				v92 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v122()
		v77 = EpicSettings.Settings['fightRemainsCheck'] or (1174 - (663 + 511));
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
		v86 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v85 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v87 = EpicSettings.Settings['HealingPotionName'] or "";
		v72 = EpicSettings.Settings['handleAfflicted'];
		v73 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v123()
		v121();
		v122();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v30 = EpicSettings.Toggles['minicds'];
		v31 = EpicSettings.Toggles['dispel'];
		if (v12:IsDeadOrGhost() or ((3563 - 2407) > (2632 + 1713))) then
			return v26;
		end
		v99 = v13:GetEnemiesInSplashRange(11 - 6);
		v102 = v12:GetEnemiesInRange(96 - 56);
		if (((1068 + 1169) < (8269 - 4020)) and v28) then
			local v155 = 0 + 0;
			while true do
				if (((0 + 0) == v155) or ((3405 - (478 + 244)) < (540 - (440 + 77)))) then
					v100 = v25(v13:GetEnemiesInSplashRangeCount(3 + 2), #v102);
					v101 = #v102;
					break;
				end
			end
		else
			v100 = 3 - 2;
			v101 = 1557 - (655 + 901);
		end
		if (((130 + 567) <= (633 + 193)) and (v97.TargetIsValid() or v12:AffectingCombat())) then
			local v156 = 0 + 0;
			while true do
				if (((4451 - 3346) <= (2621 - (695 + 750))) and (v156 == (3 - 2))) then
					v108 = v107;
					if (((5214 - 1835) <= (15330 - 11518)) and (v108 == (11462 - (285 + 66)))) then
						v108 = v9.FightRemains(v102, false);
					end
					break;
				end
				if ((v156 == (0 - 0)) or ((2098 - (682 + 628)) >= (261 + 1355))) then
					if (((2153 - (176 + 123)) <= (1414 + 1965)) and (v12:AffectingCombat() or v71)) then
						local v199 = v71 and v93.RemoveCurse:IsReady() and v31;
						v26 = v97.FocusUnit(v199, nil, 15 + 5, nil, 289 - (239 + 30), v93.ArcaneIntellect);
						if (((1237 + 3312) == (4373 + 176)) and v26) then
							return v26;
						end
					end
					v107 = v9.BossFightRemains(nil, true);
					v156 = 1 - 0;
				end
			end
		end
		v109 = v12:GCD();
		if (v72 or ((9428 - 6406) >= (3339 - (306 + 9)))) then
			if (((16819 - 11999) > (383 + 1815)) and v92) then
				local v195 = 0 + 0;
				while true do
					if ((v195 == (0 + 0)) or ((3033 - 1972) >= (6266 - (1140 + 235)))) then
						v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 20 + 10);
						if (((1251 + 113) <= (1148 + 3325)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
		if (not v12:AffectingCombat() or v27 or ((3647 - (33 + 19)) <= (2 + 1))) then
			local v157 = 0 - 0;
			while true do
				if ((v157 == (0 + 0)) or ((9161 - 4489) == (3612 + 240))) then
					if (((2248 - (586 + 103)) == (142 + 1417)) and v93.ArcaneIntellect:IsCastable() and v36 and (v12:BuffDown(v93.ArcaneIntellect, true) or v97.GroupBuffMissing(v93.ArcaneIntellect))) then
						if (v20(v93.ArcaneIntellect) or ((5393 - 3641) <= (2276 - (1309 + 179)))) then
							return "arcane_intellect group_buff";
						end
					end
					if ((v93.ArcaneFamiliar:IsReady() and v35 and v12:BuffDown(v93.ArcaneFamiliarBuff)) or ((7052 - 3145) == (78 + 99))) then
						if (((9318 - 5848) > (420 + 135)) and v20(v93.ArcaneFamiliar)) then
							return "arcane_familiar precombat 2";
						end
					end
					v157 = 1 - 0;
				end
				if ((v157 == (1 - 0)) or ((1581 - (295 + 314)) == (1584 - 939))) then
					if (((5144 - (1300 + 662)) >= (6641 - 4526)) and v93.ConjureManaGem:IsCastable() and v38) then
						if (((5648 - (1178 + 577)) < (2301 + 2128)) and v20(v93.ConjureManaGem)) then
							return "conjure_mana_gem precombat 4";
						end
					end
					break;
				end
			end
		end
		if (v97.TargetIsValid() or ((8475 - 5608) < (3310 - (851 + 554)))) then
			local v158 = 0 + 0;
			while true do
				if ((v158 == (0 - 0)) or ((3900 - 2104) >= (4353 - (115 + 187)))) then
					if (((1240 + 379) <= (3556 + 200)) and v71 and v31 and v93.RemoveCurse:IsAvailable()) then
						if (((2379 - 1775) == (1765 - (160 + 1001))) and v14) then
							v26 = v112();
							if (v26 or ((3923 + 561) == (621 + 279))) then
								return v26;
							end
						end
						if ((v15 and v15:Exists() and not v12:CanAttack(v15) and v97.UnitHasCurseDebuff(v15)) or ((9127 - 4668) <= (1471 - (237 + 121)))) then
							if (((4529 - (525 + 372)) > (6441 - 3043)) and v93.RemoveCurse:IsReady()) then
								if (((13411 - 9329) <= (5059 - (96 + 46))) and v20(v95.RemoveCurseMouseover)) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if (((5609 - (643 + 134)) >= (501 + 885)) and not v12:AffectingCombat() and v27) then
						v26 = v114();
						if (((328 - 191) == (508 - 371)) and v26) then
							return v26;
						end
					end
					v158 = 1 + 0;
				end
				if (((5 - 2) == v158) or ((3209 - 1639) >= (5051 - (316 + 403)))) then
					if ((v93.Spellsteal:IsAvailable() and v88 and v93.Spellsteal:IsReady() and v31 and v70 and not v12:IsCasting() and not v12:IsChanneling() and v97.UnitHasMagicBuff(v13)) or ((2702 + 1362) <= (5001 - 3182))) then
						if (v20(v93.Spellsteal, not v13:IsSpellInRange(v93.Spellsteal)) or ((1802 + 3184) < (3963 - 2389))) then
							return "spellsteal damage";
						end
					end
					if (((3137 + 1289) > (56 + 116)) and not v12:IsCasting() and not v12:IsChanneling() and v12:AffectingCombat() and v97.TargetIsValid()) then
						local v200 = 0 - 0;
						local v201;
						while true do
							if (((2798 - 2212) > (945 - 490)) and (v200 == (1 + 2))) then
								v26 = v120();
								if (((1625 - 799) == (41 + 785)) and v26) then
									return v26;
								end
								break;
							end
							if ((v200 == (5 - 3)) or ((4036 - (12 + 5)) > (17248 - 12807))) then
								if (((4303 - 2286) < (9057 - 4796)) and (v77 < v108)) then
									if (((11694 - 6978) > (17 + 63)) and v80 and ((v29 and v81) or not v81)) then
										local v204 = 1973 - (1656 + 317);
										while true do
											if (((0 + 0) == v204) or ((2811 + 696) == (8699 - 5427))) then
												v26 = v113();
												if (v26 or ((4311 - 3435) >= (3429 - (5 + 349)))) then
													return v26;
												end
												break;
											end
										end
									end
								end
								v26 = v115();
								if (((20671 - 16319) > (3825 - (266 + 1005))) and v26) then
									return v26;
								end
								v200 = 2 + 1;
							end
							if ((v200 == (0 - 0)) or ((5800 - 1394) < (5739 - (561 + 1135)))) then
								if ((v29 and v78 and (v94.Dreambinder:IsEquippedAndReady() or v94.Iridal:IsEquippedAndReady())) or ((2460 - 571) >= (11120 - 7737))) then
									if (((2958 - (507 + 559)) <= (6860 - 4126)) and v20(v95.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								v201 = v97.HandleDPSPotion(not v93.ArcaneSurge:IsReady());
								if (((5947 - 4024) < (2606 - (212 + 176))) and v201) then
									return v201;
								end
								v200 = 906 - (250 + 655);
							end
							if (((5925 - 3752) > (661 - 282)) and (v200 == (1 - 0))) then
								if ((v12:IsMoving() and v93.IceFloes:IsReady() and not v12:BuffUp(v93.IceFloes) and not v12:PrevOffGCDP(1957 - (1869 + 87), v93.IceFloes)) or ((8986 - 6395) == (5310 - (484 + 1417)))) then
									if (((9674 - 5160) > (5570 - 2246)) and v20(v93.IceFloes)) then
										return "ice_floes movement";
									end
								end
								if ((v89 and v93.TimeWarp:IsReady() and v12:BloodlustDown() and v93.TemporalWarp:IsAvailable() and v12:BloodlustExhaustUp() and (v93.ArcaneSurge:CooldownUp() or (v108 <= (813 - (48 + 725))) or (v12:BuffUp(v93.ArcaneSurgeBuff) and (v108 <= (v93.ArcaneSurge:CooldownRemains() + (22 - 8)))))) or ((557 - 349) >= (2806 + 2022))) then
									if (v20(v93.TimeWarp, not v13:IsInRange(106 - 66)) or ((444 + 1139) > (1040 + 2527))) then
										return "time_warp main 4";
									end
								end
								if ((v79 and ((v82 and v29) or not v82) and (v77 < v108)) or ((2166 - (152 + 701)) == (2105 - (430 + 881)))) then
									local v203 = 0 + 0;
									while true do
										if (((4069 - (557 + 338)) > (858 + 2044)) and (v203 == (0 - 0))) then
											if (((14427 - 10307) <= (11317 - 7057)) and v93.LightsJudgment:IsCastable() and v12:BuffDown(v93.ArcaneSurgeBuff) and v13:DebuffDown(v93.TouchoftheMagiDebuff) and ((v100 >= (4 - 2)) or (v101 >= (803 - (499 + 302))))) then
												if (v20(v93.LightsJudgment, not v13:IsSpellInRange(v93.LightsJudgment)) or ((1749 - (39 + 827)) > (13189 - 8411))) then
													return "lights_judgment main 6";
												end
											end
											if ((v93.Berserking:IsCastable() and ((v12:PrevGCDP(2 - 1, v93.ArcaneSurge) and not (v12:BuffUp(v93.TemporalWarpBuff) and v12:BloodlustUp())) or (v12:BuffUp(v93.ArcaneSurgeBuff) and v13:DebuffUp(v93.TouchoftheMagiDebuff)))) or ((14378 - 10758) >= (7508 - 2617))) then
												if (((365 + 3893) > (2742 - 1805)) and v20(v93.Berserking)) then
													return "berserking main 8";
												end
											end
											v203 = 1 + 0;
										end
										if ((v203 == (1 - 0)) or ((4973 - (103 + 1)) < (1460 - (475 + 79)))) then
											if (v12:PrevGCDP(2 - 1, v93.ArcaneSurge) or ((3920 - 2695) > (547 + 3681))) then
												local v205 = 0 + 0;
												while true do
													if (((4831 - (1395 + 108)) > (6512 - 4274)) and (v205 == (1205 - (7 + 1197)))) then
														if (((1674 + 2165) > (491 + 914)) and v93.AncestralCall:IsCastable()) then
															if (v20(v93.AncestralCall) or ((1612 - (27 + 292)) <= (1485 - 978))) then
																return "ancestral_call main 14";
															end
														end
														break;
													end
													if ((v205 == (0 - 0)) or ((12145 - 9249) < (1587 - 782))) then
														if (((4410 - 2094) == (2455 - (43 + 96))) and v93.BloodFury:IsCastable()) then
															if (v20(v93.BloodFury) or ((10483 - 7913) == (3465 - 1932))) then
																return "blood_fury main 10";
															end
														end
														if (v93.Fireblood:IsCastable() or ((733 + 150) == (413 + 1047))) then
															if (v20(v93.Fireblood) or ((9129 - 4510) <= (383 + 616))) then
																return "fireblood main 12";
															end
														end
														v205 = 1 - 0;
													end
												end
											end
											break;
										end
									end
								end
								v200 = 1 + 1;
							end
						end
					end
					break;
				end
				if ((v158 == (1 + 1)) or ((5161 - (1414 + 337)) > (6056 - (1642 + 298)))) then
					if (v72 or ((2353 - 1450) >= (8800 - 5741))) then
						if (v92 or ((11798 - 7822) < (941 + 1916))) then
							local v202 = 0 + 0;
							while true do
								if (((5902 - (357 + 615)) > (1620 + 687)) and (v202 == (0 - 0))) then
									v26 = v97.HandleAfflicted(v93.RemoveCurse, v95.RemoveCurseMouseover, 26 + 4);
									if (v26 or ((8670 - 4624) < (1033 + 258))) then
										return v26;
									end
									break;
								end
							end
						end
					end
					if (v73 or ((289 + 3952) == (2229 + 1316))) then
						v26 = v97.HandleIncorporeal(v93.Polymorph, v95.PolymorphMouseover, 1331 - (384 + 917));
						if (v26 or ((4745 - (128 + 569)) > (5775 - (1407 + 136)))) then
							return v26;
						end
					end
					v158 = 1890 - (687 + 1200);
				end
				if ((v158 == (1711 - (556 + 1154))) or ((6156 - 4406) >= (3568 - (9 + 86)))) then
					v26 = v110();
					if (((3587 - (275 + 146)) == (515 + 2651)) and v26) then
						return v26;
					end
					v158 = 66 - (29 + 35);
				end
			end
		end
	end
	local function v124()
		local v151 = 0 - 0;
		while true do
			if (((5265 - 3502) < (16439 - 12715)) and (v151 == (0 + 0))) then
				v98();
				v18.Print("Arcane Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v18.SetAPL(1074 - (53 + 959), v123, v124);
end;
return v0["Epix_Mage_Arcane.lua"]();

