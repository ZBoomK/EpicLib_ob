local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1742 - (307 + 821)) < (6602 - 3418)) and (v5 == (1813 - (1293 + 519)))) then
			return v6(...);
		end
		if (((6377 - 3251) == (8161 - 5035)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((9430 - 7243) >= (11670 - 6716))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.PressCursor;
	local v26 = v22.Macro;
	local v27 = v22.Bind;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = math.max;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99 = v19.Mage.Frost;
	local v100 = v21.Mage.Frost;
	local v101 = v26.Mage.Frost;
	local v102 = {};
	local v103, v104;
	local v105, v106;
	local v107 = 0 + 0;
	local v108 = 0 - 0;
	local v109 = 4 + 11;
	local v110 = 3692 + 7419;
	local v111 = 6944 + 4167;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((4973 - (709 + 387)) == (5433 - (673 + 1185)))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(245702 - 160981);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(734068 - 505471);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(375719 - 147365);
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(163507 + 65091);
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(170810 + 57790);
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v133 = 0 - 0;
		while true do
			if (((174 + 533) > (1259 - 627)) and (v133 == (0 - 0))) then
				v110 = 12991 - (446 + 1434);
				v111 = 12394 - (1040 + 243);
				v133 = 2 - 1;
			end
			if ((v133 == (1848 - (559 + 1288))) or ((2477 - (609 + 1322)) >= (3138 - (13 + 441)))) then
				v107 = 0 - 0;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v134)
		if (((3837 - 2372) <= (21420 - 17119)) and (v134 == nil)) then
			v134 = v15;
		end
		return not v134:IsInBossList() or (v134:Level() < (3 + 70));
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v135)
		return (v135:DebuffStack(v99.WintersChillDebuff));
	end
	local function v118(v136)
		return (v136:DebuffDown(v99.WintersChillDebuff));
	end
	local function v119()
		local v137 = 0 - 0;
		while true do
			if (((606 + 1098) > (625 + 800)) and (v137 == (11 - 7))) then
				if ((v85 and (v14:HealthPercentage() <= v87)) or ((376 + 311) == (7787 - 3553))) then
					if ((v89 == "Refreshing Healing Potion") or ((2202 + 1128) < (795 + 634))) then
						if (((825 + 322) >= (282 + 53)) and v100.RefreshingHealingPotion:IsReady()) then
							if (((3361 + 74) > (2530 - (153 + 280))) and v24(v101.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v89 == "Dreamwalker's Healing Potion") or ((10886 - 7116) >= (3629 + 412))) then
						if (v100.DreamwalkersHealingPotion:IsReady() or ((1497 + 2294) <= (844 + 767))) then
							if (v24(v101.RefreshingHealingPotion) or ((4155 + 423) <= (1456 + 552))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1713 - 588) <= (1284 + 792)) and (v137 == (670 - (89 + 578)))) then
				if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((531 + 212) >= (9144 - 4745))) then
					if (((2204 - (572 + 477)) < (226 + 1447)) and v24(v99.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((1395 + 929) <= (69 + 509))) then
					if (((3853 - (84 + 2)) == (6207 - 2440)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v137 = 3 + 1;
			end
			if (((4931 - (497 + 345)) == (105 + 3984)) and ((1 + 1) == v137)) then
				if (((5791 - (605 + 728)) >= (1195 + 479)) and v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (((2160 - 1188) <= (65 + 1353)) and v24(v99.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((18256 - 13318) < (4293 + 469))) then
					if (v24(v99.GreaterInvisibility) or ((6937 - 4433) > (3220 + 1044))) then
						return "greater_invisibility defensive 6";
					end
				end
				v137 = 492 - (457 + 32);
			end
			if (((914 + 1239) == (3555 - (832 + 570))) and (v137 == (1 + 0))) then
				if ((v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((133 + 374) >= (9168 - 6577))) then
					if (((2159 + 2322) == (5277 - (588 + 208))) and v24(v99.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((6274 - 3946) < (2493 - (884 + 916)))) then
					if (((9060 - 4732) == (2510 + 1818)) and v24(v99.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v137 = 655 - (232 + 421);
			end
			if (((3477 - (1569 + 320)) >= (327 + 1005)) and ((0 + 0) == v137)) then
				if ((v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((14065 - 9891) > (4853 - (316 + 289)))) then
					if (v24(v99.IceBarrier) or ((12004 - 7418) <= (4 + 78))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((5316 - (666 + 787)) == (4288 - (360 + 65))) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 2 + 0, v99.ArcaneIntellect)) then
					if (v24(v99.MassBarrier) or ((536 - (79 + 175)) <= (65 - 23))) then
						return "mass_barrier defensive 2";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local v120 = 0 - 0;
	local function v121()
		if (((8875 - 4266) >= (1665 - (503 + 396))) and v99.RemoveCurse:IsReady() and v113.DispellableFriendlyUnit(201 - (92 + 89))) then
			local v151 = 0 - 0;
			while true do
				if ((v151 == (0 + 0)) or ((682 + 470) == (9743 - 7255))) then
					if (((468 + 2954) > (7638 - 4288)) and (v120 == (0 + 0))) then
						v120 = GetTime();
					end
					if (((419 + 458) > (1144 - 768)) and v113.Wait(63 + 437, v120)) then
						local v212 = 0 - 0;
						while true do
							if ((v212 == (1244 - (485 + 759))) or ((7214 - 4096) <= (3040 - (442 + 747)))) then
								if (v24(v101.RemoveCurseFocus) or ((1300 - (832 + 303)) >= (4438 - (88 + 858)))) then
									return "remove_curse dispel";
								end
								v120 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v138 = 0 + 0;
		while true do
			if (((163 + 3786) < (5645 - (766 + 23))) and (v138 == (4 - 3))) then
				v31 = v113.HandleBottomTrinket(v102, v34, 54 - 14, nil);
				if (v31 or ((11265 - 6989) < (10236 - 7220))) then
					return v31;
				end
				break;
			end
			if (((5763 - (1036 + 37)) > (2925 + 1200)) and (v138 == (0 - 0))) then
				v31 = v113.HandleTopTrinket(v102, v34, 32 + 8, nil);
				if (v31 or ((1530 - (641 + 839)) >= (1809 - (910 + 3)))) then
					return v31;
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((3398 - (1466 + 218)) >= (1360 + 1598))) then
			if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((2639 - (556 + 592)) < (230 + 414))) then
				if (((1512 - (329 + 479)) < (1841 - (174 + 680))) and v24(v99.MirrorImage)) then
					return "mirror_image precombat 2";
				end
			end
			if (((12775 - 9057) > (3950 - 2044)) and v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) then
				if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt)) or ((684 + 274) > (4374 - (396 + 343)))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v124()
		if (((310 + 3191) <= (5969 - (29 + 1448))) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1390 - (135 + 1254), v99.IcyVeins)) then
			if (v24(v99.TimeWarp, not v15:IsInRange(150 - 110)) or ((16071 - 12629) < (1699 + 849))) then
				return "time_warp cd 2";
			end
		end
		local v139 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (((4402 - (389 + 1138)) >= (2038 - (102 + 472))) and v139) then
			return v139;
		end
		if ((v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) or ((4527 + 270) >= (2714 + 2179))) then
			if (v24(v99.IcyVeins) or ((514 + 37) > (3613 - (320 + 1225)))) then
				return "icy_veins cd 6";
			end
		end
		if (((3762 - 1648) > (578 + 366)) and (v83 < v111)) then
			if ((v91 and ((v34 and v92) or not v92)) or ((3726 - (157 + 1307)) >= (4955 - (821 + 1038)))) then
				v31 = v122();
				if (v31 or ((5626 - 3371) >= (387 + 3150))) then
					return v31;
				end
			end
		end
		if ((v90 and ((v93 and v34) or not v93) and (v83 < v111)) or ((6815 - 2978) < (486 + 820))) then
			if (((7311 - 4361) == (3976 - (834 + 192))) and v99.BloodFury:IsCastable()) then
				if (v24(v99.BloodFury) or ((301 + 4422) < (847 + 2451))) then
					return "blood_fury cd 10";
				end
			end
			if (((25 + 1111) >= (238 - 84)) and v99.Berserking:IsCastable()) then
				if (v24(v99.Berserking) or ((575 - (300 + 4)) > (1269 + 3479))) then
					return "berserking cd 12";
				end
			end
			if (((12408 - 7668) >= (3514 - (112 + 250))) and v99.LightsJudgment:IsCastable()) then
				if (v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment)) or ((1028 + 1550) >= (8492 - 5102))) then
					return "lights_judgment cd 14";
				end
			end
			if (((24 + 17) <= (860 + 801)) and v99.Fireblood:IsCastable()) then
				if (((450 + 151) < (1766 + 1794)) and v24(v99.Fireblood)) then
					return "fireblood cd 16";
				end
			end
			if (((175 + 60) < (2101 - (1001 + 413))) and v99.AncestralCall:IsCastable()) then
				if (((10143 - 5594) > (2035 - (244 + 638))) and v24(v99.AncestralCall)) then
					return "ancestral_call cd 18";
				end
			end
		end
	end
	local function v125()
		local v140 = 693 - (627 + 66);
		while true do
			if ((v140 == (2 - 1)) or ((5276 - (512 + 90)) < (6578 - (1665 + 241)))) then
				if (((4385 - (373 + 344)) < (2058 + 2503)) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (8 + 22)) and (v104 >= (5 - 3))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(13 - 5)) or ((1554 - (35 + 1064)) == (2623 + 982))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((5697 - 3034) == (14 + 3298))) then
					if (((5513 - (298 + 938)) <= (5734 - (233 + 1026))) and v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v140 = 1668 - (636 + 1030);
			end
			if (((2 + 0) == v140) or ((850 + 20) == (354 + 835))) then
				if (((105 + 1448) <= (3354 - (55 + 166))) and v99.IceLance:IsCastable() and v47) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((434 + 1803) >= (354 + 3157))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if ((v140 == (0 - 0)) or ((1621 - (36 + 261)) > (5281 - 2261))) then
				if ((v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) or ((4360 - (34 + 1334)) == (724 + 1157))) then
					if (((2414 + 692) > (2809 - (1035 + 248))) and v24(v99.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if (((3044 - (20 + 1)) < (2017 + 1853)) and v99.IceNova:IsCastable() and v48) then
					if (((462 - (134 + 185)) > (1207 - (549 + 584))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova movement";
					end
				end
				v140 = 686 - (314 + 371);
			end
		end
	end
	local function v126()
		local v141 = 0 - 0;
		while true do
			if (((986 - (478 + 490)) < (1119 + 993)) and (v141 == (1177 - (786 + 386)))) then
				if (((3553 - 2456) <= (3007 - (1055 + 324))) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1370 - (1093 + 247))) and (v104 >= (7 + 0))) then
					if (((487 + 4143) == (18381 - 13751)) and v24(v99.ArcaneExplosion, not v15:IsInRange(26 - 18))) then
						return "arcane_explosion aoe 28";
					end
				end
				if (((10073 - 6533) > (6741 - 4058)) and v99.Frostbolt:IsCastable() and v41) then
					if (((1706 + 3088) >= (12616 - 9341)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((5114 - 3630) == (1119 + 365)) and v14:IsMoving() and v95) then
					local v208 = 0 - 0;
					while true do
						if (((2120 - (364 + 324)) < (9745 - 6190)) and (v208 == (0 - 0))) then
							v31 = v125();
							if (v31 or ((353 + 712) > (14971 - 11393))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v141 == (2 - 0)) or ((14562 - 9767) < (2675 - (1249 + 19)))) then
				if (((1673 + 180) < (18734 - 13921)) and v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1087 - (686 + 400), v99.Freeze) and ((v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (v107 == (229 - (73 + 156)))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 + 0))))) then
					if (v24(v99.FrostNova) or ((3632 - (721 + 90)) < (28 + 2403))) then
						return "frost_nova aoe 12";
					end
				end
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) or ((9331 - 6457) < (2651 - (224 + 246)))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(12 - 4)) or ((4950 - 2261) <= (63 + 280))) then
						return "cone_of_cold aoe 14";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) or ((45 + 1824) == (1476 + 533))) then
					if (v24(v99.ShiftingPower, not v15:IsInRange(79 - 39), true) or ((11800 - 8254) < (2835 - (203 + 310)))) then
						return "shifting_power aoe 16";
					end
				end
				v141 = 1996 - (1238 + 755);
			end
			if ((v141 == (1 + 0)) or ((3616 - (709 + 825)) == (8794 - 4021))) then
				if (((4725 - 1481) > (1919 - (196 + 668))) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(3 - 2, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (51 - 26))) or (v99.ConeofCold:CooldownRemains() > (853 - (171 + 662))))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((3406 - (4 + 89)) <= (6231 - 4453))) then
						return "comet_storm aoe 8";
					end
				end
				if ((v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 + 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(4 - 3, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) or ((558 + 863) >= (3590 - (35 + 1451)))) then
					if (((3265 - (28 + 1425)) <= (5242 - (941 + 1052))) and v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze))) then
						return "freeze aoe 10";
					end
				end
				if (((1557 + 66) <= (3471 - (822 + 692))) and v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1 - 0, v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (298 - (45 + 252)))))) then
					if (((4366 + 46) == (1519 + 2893)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova aoe 11";
					end
				end
				v141 = 4 - 2;
			end
			if (((2183 - (114 + 319)) >= (1208 - 366)) and (v141 == (4 - 0))) then
				if (((2788 + 1584) > (2756 - 906)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
					if (((485 - 253) < (2784 - (556 + 1407))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if (((1724 - (741 + 465)) < (1367 - (170 + 295))) and v99.IceNova:IsCastable() and v48 and (v103 >= (3 + 1)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) then
					if (((2751 + 243) > (2112 - 1254)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (6 + 1))) or ((2409 + 1346) <= (519 + 396))) then
					if (((5176 - (957 + 273)) > (1002 + 2741)) and v24(v99.DragonsBreath, not v15:IsInRange(5 + 5))) then
						return "dragons_breath aoe 26";
					end
				end
				v141 = 19 - 14;
			end
			if ((v141 == (7 - 4)) or ((4077 - 2742) >= (16370 - 13064))) then
				if (((6624 - (389 + 1391)) > (1414 + 839)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (1 + 4)) and (v99.Blizzard:CooldownRemains() > v112)) then
					if (((1028 - 576) == (1403 - (783 + 168))) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (0 - 0)) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (312.8 - (309 + 2))))) or ((13993 - 9436) < (3299 - (1090 + 122)))) then
					if (((1256 + 2618) == (13010 - 9136)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 + 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((3056 - (628 + 490)) > (885 + 4050))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry)) or ((10535 - 6280) < (15643 - 12220))) then
						return "flurry aoe 21";
					end
				end
				v141 = 778 - (431 + 343);
			end
			if (((2936 - 1482) <= (7206 - 4715)) and (v141 == (0 + 0))) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1 + 0, v99.CometStorm) or (v14:PrevGCDP(1696 - (556 + 1139), v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((4172 - (6 + 9)) <= (514 + 2289))) then
					if (((2487 + 2366) >= (3151 - (28 + 141))) and v24(v99.ConeofCold, not v15:IsInRange(4 + 4))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((5102 - 968) > (2378 + 979)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1318 - (486 + 831), v99.GlacialSpike) or not v115())) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(104 - 64)) or ((12029 - 8612) < (479 + 2055))) then
						return "frozen_orb aoe 4";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(3 - 2, v99.GlacialSpike) or not v115())) or ((3985 - (668 + 595)) <= (148 + 16))) then
					if (v24(v101.BlizzardCursor, not v15:IsInRange(9 + 31)) or ((6566 - 4158) < (2399 - (23 + 267)))) then
						return "blizzard aoe 6";
					end
				end
				v141 = 1945 - (1129 + 815);
			end
		end
	end
	local function v127()
		local v142 = 387 - (371 + 16);
		while true do
			if ((v142 == (1750 - (1326 + 424))) or ((61 - 28) == (5316 - 3861))) then
				if ((v99.CometStorm:IsCastable() and (v14:PrevGCDP(119 - (88 + 30), v99.Flurry) or v14:PrevGCDP(772 - (720 + 51), v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) or ((985 - 542) >= (5791 - (421 + 1355)))) then
					if (((5578 - 2196) > (82 + 84)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1084 - (286 + 797), v99.Frostbolt) and (v108 >= (10 - 7))) or v14:PrevGCDP(1 - 0, v99.GlacialSpike) or ((v108 >= (442 - (397 + 42))) and (v108 < (2 + 3)) and (v99.Flurry:ChargesFractional() == (802 - (24 + 776)))))) or ((431 - 151) == (3844 - (222 + 563)))) then
					local v209 = 0 - 0;
					while true do
						if (((1355 + 526) > (1483 - (23 + 167))) and (v209 == (1798 - (690 + 1108)))) then
							if (((851 + 1506) == (1945 + 412)) and v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry))) then
								return "flurry cleave 4";
							end
							if (((971 - (40 + 808)) == (21 + 102)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (0 - 0)) and (v108 == (4 + 0)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((559 + 497) >= (1861 + 1531))) then
					if (v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance)) or ((1652 - (47 + 524)) < (698 + 377))) then
						return "ice_lance cleave 6";
					end
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((2867 - 1818) >= (6626 - 2194))) then
						return "ice_lance cleave 6";
					end
				end
				if ((v99.RayofFrost:IsCastable() and (v107 == (2 - 1)) and v49) or ((6494 - (1165 + 561)) <= (26 + 820))) then
					if (v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost)) or ((10400 - 7042) <= (542 + 878))) then
						return "ray_of_frost cleave 8";
					end
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((4218 - (341 + 138)) <= (812 + 2193))) then
						return "ray_of_frost cleave 8";
					end
				end
				v142 = 1 - 0;
			end
			if ((v142 == (329 - (89 + 237))) or ((5336 - 3677) >= (4492 - 2358))) then
				if ((v99.Frostbolt:IsCastable() and v41) or ((4141 - (581 + 300)) < (3575 - (855 + 365)))) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true) or ((1588 - 919) == (1379 + 2844))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((2927 - (1030 + 205)) < (553 + 35))) then
					local v210 = 0 + 0;
					while true do
						if ((v210 == (286 - (156 + 130))) or ((10899 - 6102) < (6153 - 2502))) then
							v31 = v125();
							if (v31 or ((8554 - 4377) > (1278 + 3572))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v142 == (2 + 0)) or ((469 - (10 + 59)) > (315 + 796))) then
				if (((15025 - 11974) > (2168 - (671 + 492))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (8 + 2)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (1225 - (369 + 846)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (3 + 7)))) or (v99.IcyVeins:CooldownRemains() < (18 + 2)))) then
					if (((5638 - (1036 + 909)) <= (3485 + 897)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (8 - 3))) or ((3485 - (11 + 192)) > (2072 + 2028))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((3755 - (135 + 40)) < (6890 - 4046))) then
						return "glacial_spike cleave 20";
					end
				end
				if (((54 + 35) < (9891 - 5401)) and v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 - 0, v99.GlacialSpike)) or (v107 > (176 - (50 + 126))))) then
					if (v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance)) or ((13875 - 8892) < (401 + 1407))) then
						return "ice_lance cleave 22";
					end
					if (((5242 - (1233 + 180)) > (4738 - (522 + 447))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 22";
					end
				end
				if (((2906 - (107 + 1314)) <= (1348 + 1556)) and v99.IceNova:IsCastable() and v48 and (v104 >= (11 - 7))) then
					if (((1814 + 2455) == (8477 - 4208)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v142 = 11 - 8;
			end
			if (((2297 - (716 + 1194)) <= (48 + 2734)) and (v142 == (1 + 0))) then
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (508 - (74 + 429))) and (v99.Flurry:CooldownUp() or (v107 > (0 - 0)))) or ((942 + 957) <= (2098 - 1181))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((3051 + 1261) <= (2700 - 1824))) then
						return "glacial_spike cleave 10";
					end
				end
				if (((5518 - 3286) <= (3029 - (279 + 154))) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (780 - (454 + 324))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
					if (((1649 + 446) < (3703 - (12 + 5))) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (6 + 4)) and (v99.FrozenOrb:CooldownRemains() > (25 - 15)) and (v107 == (0 + 0)) and (v104 >= (1096 - (277 + 816)))) or ((6815 - 5220) >= (5657 - (1058 + 125)))) then
					if (v24(v99.ConeofCold) or ((867 + 3752) < (3857 - (815 + 160)))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (8 - 6)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (7 - 4)))) or ((71 + 223) >= (14121 - 9290))) then
					if (((3927 - (41 + 1857)) <= (4977 - (1222 + 671))) and v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard))) then
						return "blizzard cleave 16";
					end
				end
				v142 = 5 - 3;
			end
		end
	end
	local function v128()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (1182 - (229 + 953))) or ((3811 - (1111 + 663)) == (3999 - (874 + 705)))) then
				if (((625 + 3833) > (2664 + 1240)) and v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1 - 0, v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold))) then
					if (((1115 - (642 + 37)) >= (29 + 94)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((80 + 420) < (4559 - 2743)) and v99.Flurry:IsCastable() and (v107 == (454 - (233 + 221))) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(2 - 1, v99.Frostbolt) and (v108 >= (3 + 0))) or (v14:PrevGCDP(1542 - (718 + 823), v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (809 - (266 + 539))) and v14:BuffDown(v99.FingersofFrostBuff)))) then
					if (((10118 - 6544) == (4799 - (636 + 589))) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry))) then
						return "flurry single 4";
					end
				end
				if (((524 - 303) < (804 - 414)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 + 0)) and (v108 == (2 + 2)) and v14:BuffUp(v99.FingersofFrostBuff)) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3228 - (657 + 358)) <= (3762 - 2341))) then
						return "ice_lance single 6";
					end
				end
				if (((6966 - 3908) < (6047 - (1151 + 36))) and v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1 + 0))) then
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((341 + 955) >= (13277 - 8831))) then
						return "ray_of_frost single 8";
					end
				end
				v143 = 1833 - (1552 + 280);
			end
			if ((v143 == (837 - (64 + 770))) or ((946 + 447) > (10190 - 5701))) then
				if ((v90 and ((v93 and v34) or not v93)) or ((786 + 3638) < (1270 - (157 + 1086)))) then
					if (v99.BagofTricks:IsCastable() or ((3996 - 1999) > (16708 - 12893))) then
						if (((5314 - 1849) > (2610 - 697)) and v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((1552 - (599 + 220)) < (3621 - 1802)) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), true) or ((6326 - (1813 + 118)) == (3476 + 1279))) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((5010 - (841 + 376)) < (3318 - 949))) then
					v31 = v125();
					if (v31 or ((949 + 3135) == (723 - 458))) then
						return v31;
					end
				end
				break;
			end
			if (((5217 - (464 + 395)) == (11184 - 6826)) and (v143 == (1 + 1))) then
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (837 - (467 + 370))) and (((v99.FrozenOrb:CooldownRemains() > (20 - 10)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (8 + 2))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (34 - 24)))) or (v99.IcyVeins:CooldownRemains() < (4 + 16)))) or ((7300 - 4162) < (1513 - (150 + 370)))) then
					if (((4612 - (74 + 1208)) > (5713 - 3390)) and v24(v99.ShiftingPower, not v15:IsInRange(189 - 149))) then
						return "shifting_power single 18";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (4 + 1))) or ((4016 - (14 + 376)) == (6918 - 2929))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike)) or ((593 + 323) == (2347 + 324))) then
						return "glacial_spike single 20";
					end
				end
				if (((260 + 12) == (796 - 524)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
					if (((4327 - (23 + 55)) <= (11467 - 6628)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((1854 + 923) < (2874 + 326)) and v99.IceNova:IsCastable() and v48 and (v104 >= (5 - 1))) then
					if (((30 + 65) < (2858 - (652 + 249))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova single 24";
					end
				end
				v143 = 7 - 4;
			end
			if (((2694 - (708 + 1160)) < (4660 - 2943)) and (v143 == (1 - 0))) then
				if (((1453 - (10 + 17)) >= (249 + 856)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (1737 - (1400 + 332))) and ((v99.Flurry:Charges() >= (1 - 0)) or ((v107 > (1908 - (242 + 1666))) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) then
					if (((1179 + 1575) <= (1239 + 2140)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike))) then
						return "glacial_spike single 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (0 + 0)) and (v14:BuffStackP(v99.FingersofFrostBuff) < (942 - (850 + 90))) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((6877 - 2950) == (2803 - (360 + 1030)))) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(36 + 4)) or ((3257 - 2103) <= (1083 - 295))) then
						return "frozen_orb single 12";
					end
				end
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (1671 - (909 + 752))) and (v99.FrozenOrb:CooldownRemains() > (1233 - (109 + 1114))) and (v107 == (0 - 0)) and (v103 >= (2 + 1))) or ((1885 - (6 + 236)) > (2129 + 1250))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(7 + 1)) or ((6610 - 3807) > (7945 - 3396))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v103 >= (1135 - (1076 + 57))) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (1 + 2)))) or ((909 - (579 + 110)) >= (239 + 2783))) then
					if (((2496 + 326) == (1498 + 1324)) and v24(v101.BlizzardCursor, not v15:IsInRange(447 - (174 + 233)))) then
						return "blizzard single 16";
					end
				end
				v143 = 5 - 3;
			end
		end
	end
	local function v129()
		local v144 = 0 - 0;
		while true do
			if (((3 + 3) == v144) or ((2235 - (663 + 511)) == (1657 + 200))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v144 = 16 - 9;
			end
			if (((1318 + 1442) > (2654 - 1290)) and ((2 + 0) == v144)) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v144 = 1 + 2;
			end
			if ((v144 == (726 - (478 + 244))) or ((5419 - (440 + 77)) <= (1635 + 1960))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v144 = 18 - 13;
			end
			if (((1557 - (655 + 901)) == v144) or ((715 + 3137) == (225 + 68))) then
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v144 = 2 + 0;
			end
			if ((v144 == (20 - 15)) or ((3004 - (695 + 750)) == (15666 - 11078))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (351 - (285 + 66));
				v144 = 13 - 7;
			end
			if ((v144 == (1317 - (682 + 628))) or ((723 + 3761) == (1087 - (176 + 123)))) then
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((1911 + 2657) >= (2835 + 1072)) and (v144 == (269 - (239 + 30)))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v144 = 1 + 0;
			end
			if (((1198 + 48) < (6141 - 2671)) and (v144 == (8 - 5))) then
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v144 = 319 - (306 + 9);
			end
		end
	end
	local function v130()
		local v145 = 0 - 0;
		while true do
			if (((708 + 3360) >= (597 + 375)) and (v145 == (1 + 0))) then
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v91 = EpicSettings.Settings['useTrinkets'];
				v145 = 5 - 3;
			end
			if (((1868 - (1140 + 235)) < (2478 + 1415)) and (v145 == (0 + 0))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v84 = EpicSettings.Settings['useWeapon'];
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v145 = 53 - (33 + 19);
			end
			if ((v145 == (1 + 1)) or ((4414 - 2941) >= (1468 + 1864))) then
				v90 = EpicSettings.Settings['useRacials'];
				v92 = EpicSettings.Settings['trinketsWithCD'];
				v93 = EpicSettings.Settings['racialsWithCD'];
				v86 = EpicSettings.Settings['useHealthstone'];
				v145 = 5 - 2;
			end
			if ((v145 == (4 + 0)) or ((4740 - (586 + 103)) <= (106 + 1051))) then
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1859 - 1255) < (4369 - (1309 + 179))) and (v145 == (5 - 2))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v87 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v145 = 4 + 0;
			end
		end
	end
	local function v131()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1 - 0)) or ((1509 - (295 + 314)) == (8294 - 4917))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (((6421 - (1300 + 662)) > (1855 - 1264)) and v14:IsDeadOrGhost()) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(1760 - (1178 + 577));
				v146 = 2 + 0;
			end
			if (((10045 - 6647) >= (3800 - (851 + 554))) and (v146 == (2 + 0))) then
				v106 = v14:GetEnemiesInRange(110 - 70);
				if (v33 or ((4741 - 2558) >= (3126 - (115 + 187)))) then
					v103 = v30(v15:GetEnemiesInSplashRangeCount(4 + 1), #v106);
					v104 = v30(v15:GetEnemiesInSplashRangeCount(5 + 0), #v106);
				else
					v103 = 3 - 2;
					v104 = 1162 - (160 + 1001);
				end
				if (((1694 + 242) == (1336 + 600)) and not v14:AffectingCombat()) then
					if ((v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) or ((9891 - 5059) < (4671 - (237 + 121)))) then
						if (((4985 - (525 + 372)) > (7344 - 3470)) and v24(v99.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (((14233 - 9901) == (4474 - (96 + 46))) and (v113.TargetIsValid() or v14:AffectingCombat())) then
					local v211 = 777 - (643 + 134);
					while true do
						if (((1444 + 2555) >= (6953 - 4053)) and (v211 == (3 - 2))) then
							if ((v111 == (10656 + 455)) or ((4955 - 2430) > (8306 - 4242))) then
								v111 = v10.FightRemains(v106, false);
							end
							v107 = v15:DebuffStack(v99.WintersChillDebuff);
							v211 = 721 - (316 + 403);
						end
						if (((2906 + 1465) == (12017 - 7646)) and (v211 == (0 + 0))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v211 = 2 - 1;
						end
						if ((v211 == (2 + 0)) or ((86 + 180) > (17276 - 12290))) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
					end
				end
				v146 = 14 - 11;
			end
			if (((4136 - 2145) >= (53 + 872)) and (v146 == (5 - 2))) then
				if (((23 + 432) < (6040 - 3987)) and v113.TargetIsValid()) then
					if ((v77 and v35 and v99.RemoveCurse:IsAvailable()) or ((843 - (12 + 5)) == (18841 - 13990))) then
						local v213 = 0 - 0;
						while true do
							if (((388 - 205) == (453 - 270)) and (v213 == (0 + 0))) then
								if (((3132 - (1656 + 317)) <= (1594 + 194)) and v16) then
									local v219 = 0 + 0;
									while true do
										if ((v219 == (0 - 0)) or ((17259 - 13752) > (4672 - (5 + 349)))) then
											v31 = v121();
											if (v31 or ((14605 - 11530) <= (4236 - (266 + 1005)))) then
												return v31;
											end
											break;
										end
									end
								end
								if (((900 + 465) <= (6861 - 4850)) and v17 and v17:Exists() and v17:IsAPlayer() and v113.UnitHasCurseDebuff(v17)) then
									if (v99.RemoveCurse:IsReady() or ((3654 - 878) > (5271 - (561 + 1135)))) then
										if (v24(v101.RemoveCurseMouseover) or ((3328 - 774) == (15791 - 10987))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if (((3643 - (507 + 559)) == (6466 - 3889)) and not v14:AffectingCombat() and v32) then
						local v214 = 0 - 0;
						while true do
							if ((v214 == (388 - (212 + 176))) or ((911 - (250 + 655)) >= (5151 - 3262))) then
								v31 = v123();
								if (((883 - 377) <= (2959 - 1067)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v31 = v119();
					if (v31 or ((3964 - (1869 + 87)) > (7692 - 5474))) then
						return v31;
					end
					if (((2280 - (484 + 1417)) <= (8888 - 4741)) and (v14:AffectingCombat() or v77)) then
						local v215 = v77 and v99.RemoveCurse:IsReady() and v35;
						v31 = v113.FocusUnit(v215, nil, 33 - 13, nil, 793 - (48 + 725), v99.ArcaneIntellect);
						if (v31 or ((7373 - 2859) <= (2706 - 1697))) then
							return v31;
						end
					end
					if (v78 or ((2032 + 1464) == (3185 - 1993))) then
						if (v98 or ((59 + 149) == (863 + 2096))) then
							local v218 = 853 - (152 + 701);
							while true do
								if (((5588 - (430 + 881)) >= (503 + 810)) and (v218 == (895 - (557 + 338)))) then
									v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 9 + 21);
									if (((7290 - 4703) < (11114 - 7940)) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if (v79 or ((10945 - 6825) <= (4736 - 2538))) then
						local v216 = 801 - (499 + 302);
						while true do
							if ((v216 == (866 - (39 + 827))) or ((4405 - 2809) == (1915 - 1057))) then
								v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseOver, 119 - 89, true);
								if (((4943 - 1723) == (276 + 2944)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if ((v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) or ((4103 - 2701) > (580 + 3040))) then
						if (((4072 - 1498) == (2678 - (103 + 1))) and v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((2352 - (475 + 79)) < (5959 - 3202)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
						local v217 = 0 - 0;
						while true do
							if ((v217 == (0 + 0)) or ((332 + 45) > (4107 - (1395 + 108)))) then
								if (((1652 - 1084) < (2115 - (7 + 1197))) and v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) then
									if (((1433 + 1852) < (1476 + 2752)) and v24(v101.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								if (((4235 - (27 + 292)) > (9752 - 6424)) and v34) then
									v31 = v124();
									if (((3188 - 688) < (16099 - 12260)) and v31) then
										return v31;
									end
								end
								v217 = 1 - 0;
							end
							if (((965 - 458) == (646 - (43 + 96))) and ((12 - 9) == v217)) then
								if (((542 - 302) <= (2627 + 538)) and v24(v99.Pool)) then
									return "pool for ST()";
								end
								if (((236 + 598) >= (1591 - 786)) and v14:IsMoving() and v95) then
									local v220 = 0 + 0;
									while true do
										if ((v220 == (0 - 0)) or ((1201 + 2611) < (170 + 2146))) then
											v31 = v125();
											if (v31 or ((4403 - (1414 + 337)) <= (3473 - (1642 + 298)))) then
												return v31;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v217 == (2 - 1)) or ((10350 - 6752) < (4332 - 2872))) then
								if ((v33 and (((v104 >= (3 + 4)) and not v14:HasTier(24 + 6, 974 - (357 + 615))) or ((v104 >= (3 + 0)) and v99.IceCaller:IsAvailable()))) or ((10099 - 5983) < (1022 + 170))) then
									local v221 = 0 - 0;
									while true do
										if (((0 + 0) == v221) or ((230 + 3147) <= (568 + 335))) then
											v31 = v126();
											if (((5277 - (384 + 917)) >= (1136 - (128 + 569))) and v31) then
												return v31;
											end
											v221 = 1544 - (1407 + 136);
										end
										if (((5639 - (687 + 1200)) == (5462 - (556 + 1154))) and ((3 - 2) == v221)) then
											if (((4141 - (9 + 86)) > (3116 - (275 + 146))) and v24(v99.Pool)) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								if ((v33 and (v104 == (1 + 1))) or ((3609 - (29 + 35)) == (14168 - 10971))) then
									local v222 = 0 - 0;
									while true do
										if (((10568 - 8174) > (243 + 130)) and (v222 == (1012 - (53 + 959)))) then
											v31 = v127();
											if (((4563 - (312 + 96)) <= (7344 - 3112)) and v31) then
												return v31;
											end
											v222 = 286 - (147 + 138);
										end
										if ((v222 == (900 - (813 + 86))) or ((3237 + 344) == (6433 - 2960))) then
											if (((5487 - (18 + 474)) > (1130 + 2218)) and v24(v99.Pool)) then
												return "pool for Cleave()";
											end
											break;
										end
									end
								end
								v217 = 6 - 4;
							end
							if (((1088 - (860 + 226)) == v217) or ((1057 - (121 + 182)) > (459 + 3265))) then
								v31 = v128();
								if (((1457 - (988 + 252)) >= (7 + 50)) and v31) then
									return v31;
								end
								v217 = 1 + 2;
							end
						end
					end
				end
				break;
			end
			if ((v146 == (1970 - (49 + 1921))) or ((2960 - (223 + 667)) >= (4089 - (51 + 1)))) then
				v129();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v146 = 1 - 0;
			end
		end
	end
	local function v132()
		local v147 = 0 - 0;
		while true do
			if (((3830 - (146 + 979)) == (764 + 1941)) and (v147 == (605 - (311 + 294)))) then
				v114();
				v99.WintersChillDebuff:RegisterAuraTracking();
				v147 = 2 - 1;
			end
			if (((26 + 35) == (1504 - (496 + 947))) and (v147 == (1359 - (1233 + 125)))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(26 + 38, v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

