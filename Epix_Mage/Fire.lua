local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((331 + 301) >= (642 + 65))) then
			v6 = v0[v4];
			if (not v6 or ((396 + 150) >= (4086 - 1402))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((2132 - (89 + 578)) <= (3073 + 1228)) and (v5 == (1 - 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Mage_Fire.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.Pet;
	local v18 = v12.Mouseover;
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
	local v31 = math.ceil;
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v89 = v19.Mage.Fire;
	local v90 = v21.Mage.Fire;
	local v91 = v26.Mage.Fire;
	local v92 = {};
	local v93 = v22.Commons.Everyone;
	local function v94()
		if (((2753 - (572 + 477)) > (193 + 1232)) and v89.RemoveCurse:IsAvailable()) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v35;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (3 + 1)) or (120 + 879);
	local v98 = 1085 - (84 + 2);
	local v99 = v97;
	local v100 = ((4 - 1) * v28(v89.FueltheFire:IsAvailable())) + ((720 + 279) * v28(not v89.FueltheFire:IsAvailable()));
	local v101 = 1841 - (497 + 345);
	local v102 = 2 + 38;
	local v103 = 169 + 830;
	local v104 = 1333.3 - (605 + 728);
	local v105 = 0 + 0;
	local v106 = 13 - 7;
	local v107 = false;
	local v108 = (v107 and (1 + 19)) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (2 - 1);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 + 0;
	local v115 = 489 - (457 + 32);
	local v116 = 4 + 4;
	local v117 = 1405 - (832 + 570);
	local v118;
	local v119;
	local v120;
	local v121 = 3 + 0;
	local v122 = 2898 + 8213;
	local v123 = 39319 - 28208;
	local v124;
	local v125, v126, v127;
	local v128;
	local v129;
	local v130;
	local v131;
	v10:RegisterForEvent(function()
		v107 = false;
		v108 = (v107 and (10 + 10)) or (796 - (588 + 208));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v155 = 0 - 0;
		while true do
			if (((1803 - (884 + 916)) == v155) or ((1437 - 750) == (2455 + 1779))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if ((v155 == (655 - (232 + 421))) or ((5219 - (1569 + 320)) < (351 + 1078))) then
				v89.PhoenixFlames:RegisterInFlightEffect(48930 + 208612);
				v89.PhoenixFlames:RegisterInFlight();
				v155 = 9 - 6;
			end
			if (((1752 - (316 + 289)) >= (876 - 541)) and (v155 == (0 + 0))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v155 = 1454 - (666 + 787);
			end
			if (((3860 - (360 + 65)) > (1960 + 137)) and (v155 == (255 - (79 + 175)))) then
				v89.Meteor:RegisterInFlightEffect(553690 - 202550);
				v89.Meteor:RegisterInFlight();
				v155 = 2 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(1076341 - 725201);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(495988 - 238446);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v10:RegisterForEvent(function()
		local v156 = 899 - (503 + 396);
		while true do
			if ((v156 == (181 - (92 + 89))) or ((7313 - 3543) >= (2073 + 1968))) then
				v122 = 6577 + 4534;
				v123 = 43512 - 32401;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 - 0)) or ((3308 + 483) <= (770 + 841))) then
				v96 = v89.SunKingsBlessing:IsAvailable();
				v97 = ((v89.FlamePatch:IsAvailable()) and (8 - 5)) or (125 + 874);
				v157 = 1 - 0;
			end
			if ((v157 == (1245 - (485 + 759))) or ((10592 - 6014) <= (3197 - (442 + 747)))) then
				v99 = v97;
				v110 = ((v89.Kindling:IsAvailable()) and (1135.4 - (832 + 303))) or (947 - (88 + 858));
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v15:HealthPercentage() > (28 + 62));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (75 + 15)) and v15:TimeToX(4 + 86)) or (789 - (766 + 23)))) or (0 - 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (41 - 11));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (79 - 49));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v158 = 0 - 0;
		local v159;
		while true do
			if (((2198 - (1036 + 37)) <= (1472 + 604)) and (v158 == (0 - 0))) then
				v159 = (v132() and (v28(v89.Pyroblast:InFlight()) + v28(v89.Fireball:InFlight()))) or (0 + 0);
				v159 = v159 + v28(v89.PhoenixFlames:InFlight() or v14:PrevGCDP(1481 - (641 + 839), v89.PhoenixFlames));
				v158 = 914 - (910 + 3);
			end
			if ((v158 == (2 - 1)) or ((2427 - (1466 + 218)) >= (2022 + 2377))) then
				return v14:BuffUp(v89.HotStreakBuff) or v14:BuffUp(v89.HyperthermiaBuff) or (v14:BuffUp(v89.HeatingUpBuff) and ((v135() and v14:IsCasting(v89.Scorch)) or (v132() and (v14:IsCasting(v89.Fireball) or v14:IsCasting(v89.Pyroblast) or (v159 > (1148 - (556 + 592)))))));
			end
		end
	end
	local function v138(v160)
		local v161 = 0 + 0;
		local v162;
		while true do
			if (((1963 - (329 + 479)) < (2527 - (174 + 680))) and ((0 - 0) == v161)) then
				v162 = 0 - 0;
				for v226, v227 in pairs(v160) do
					if (v227:DebuffUp(v89.IgniteDebuff) or ((1660 + 664) <= (1317 - (396 + 343)))) then
						v162 = v162 + 1 + 0;
					end
				end
				v161 = 1478 - (29 + 1448);
			end
			if (((5156 - (135 + 1254)) == (14190 - 10423)) and (v161 == (4 - 3))) then
				return v162;
			end
		end
	end
	local function v139()
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((5616 - (389 + 1138)) == (4663 - (102 + 472))) and (v163 == (1 + 0))) then
				return v164;
			end
			if (((2473 + 1985) >= (1561 + 113)) and (v163 == (1545 - (320 + 1225)))) then
				v164 = 0 - 0;
				if (((595 + 377) <= (2882 - (157 + 1307))) and (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight())) then
					v164 = v164 + (1860 - (821 + 1038));
				end
				v163 = 2 - 1;
			end
		end
	end
	local function v140()
		local v165 = 0 + 0;
		while true do
			if ((v165 == (0 - 0)) or ((1838 + 3100) < (11802 - 7040))) then
				v32 = v93.HandleTopTrinket(v92, v35, 1066 - (834 + 192), nil);
				if (v32 or ((160 + 2344) > (1095 + 3169))) then
					return v32;
				end
				v165 = 1 + 0;
			end
			if (((3335 - 1182) == (2457 - (300 + 4))) and (v165 == (1 + 0))) then
				v32 = v93.HandleBottomTrinket(v92, v35, 104 - 64, nil);
				if (v32 or ((869 - (112 + 250)) >= (1033 + 1558))) then
					return v32;
				end
				break;
			end
		end
	end
	local function v141()
		if (((11225 - 6744) == (2568 + 1913)) and v89.RemoveCurse:IsReady() and v93.DispellableFriendlyUnit(11 + 9)) then
			local v207 = 0 + 0;
			while true do
				if ((v207 == (0 + 0)) or ((1730 + 598) < (2107 - (1001 + 413)))) then
					v93.Wait(2 - 1);
					if (((5210 - (244 + 638)) == (5021 - (627 + 66))) and v24(v91.RemoveCurseFocus)) then
						return "remove_curse dispel";
					end
					break;
				end
			end
		end
	end
	local function v142()
		local v166 = 0 - 0;
		while true do
			if (((2190 - (512 + 90)) >= (3238 - (1665 + 241))) and (v166 == (719 - (373 + 344)))) then
				if ((v89.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) or ((1883 + 2291) > (1124 + 3124))) then
					if (v24(v89.MirrorImage) or ((12096 - 7510) <= (138 - 56))) then
						return "mirror_image defensive 4";
					end
				end
				if (((4962 - (35 + 1064)) == (2811 + 1052)) and v89.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
					if (v24(v89.GreaterInvisibility) or ((603 - 321) <= (1 + 41))) then
						return "greater_invisibility defensive 5";
					end
				end
				v166 = 1239 - (298 + 938);
			end
			if (((5868 - (233 + 1026)) >= (2432 - (636 + 1030))) and (v166 == (1 + 0))) then
				if ((v89.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) or ((1126 + 26) == (740 + 1748))) then
					if (((232 + 3190) > (3571 - (55 + 166))) and v24(v89.IceBlock)) then
						return "ice_block defensive 3";
					end
				end
				if (((170 + 707) > (38 + 338)) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) then
					if (v24(v89.IceColdAbility) or ((11907 - 8789) <= (2148 - (36 + 261)))) then
						return "ice_cold defensive 3";
					end
				end
				v166 = 3 - 1;
			end
			if ((v166 == (1372 - (34 + 1334))) or ((64 + 101) >= (2714 + 778))) then
				if (((5232 - (1035 + 248)) < (4877 - (20 + 1))) and v76 and (v14:HealthPercentage() <= v78)) then
					local v229 = 0 + 0;
					while true do
						if (((319 - (134 + 185)) == v229) or ((5409 - (549 + 584)) < (3701 - (314 + 371)))) then
							if (((16100 - 11410) > (5093 - (478 + 490))) and (v80 == "Refreshing Healing Potion")) then
								if (v90.RefreshingHealingPotion:IsReady() or ((27 + 23) >= (2068 - (786 + 386)))) then
									if (v24(v91.RefreshingHealingPotion) or ((5551 - 3837) >= (4337 - (1055 + 324)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v80 == "Dreamwalker's Healing Potion") or ((2831 - (1093 + 247)) < (573 + 71))) then
								if (((75 + 629) < (3918 - 2931)) and v90.DreamwalkersHealingPotion:IsReady()) then
									if (((12617 - 8899) > (5423 - 3517)) and v24(v91.RefreshingHealingPotion)) then
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
			if ((v166 == (7 - 4)) or ((341 + 617) > (14003 - 10368))) then
				if (((12067 - 8566) <= (3388 + 1104)) and v89.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) then
					if (v24(v89.AlterTime) or ((8802 - 5360) < (3236 - (364 + 324)))) then
						return "alter_time defensive 6";
					end
				end
				if (((7881 - 5006) >= (3512 - 2048)) and v90.Healthstone:IsReady() and v77 and (v14:HealthPercentage() <= v79)) then
					if (v24(v91.Healthstone) or ((1590 + 3207) >= (20473 - 15580))) then
						return "healthstone defensive";
					end
				end
				v166 = 5 - 1;
			end
			if ((v166 == (0 - 0)) or ((1819 - (1249 + 19)) > (1867 + 201))) then
				if (((8228 - 6114) > (2030 - (686 + 400))) and v89.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v89.BlazingBarrier) and (v14:HealthPercentage() <= v62)) then
					if (v24(v89.BlazingBarrier) or ((1775 + 487) >= (3325 - (73 + 156)))) then
						return "blazing_barrier defensive 1";
					end
				end
				if ((v89.MassBarrier:IsCastable() and v60 and v14:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v67, 1 + 1)) or ((3066 - (721 + 90)) >= (40 + 3497))) then
					if (v24(v89.MassBarrier) or ((12458 - 8621) < (1776 - (224 + 246)))) then
						return "mass_barrier defensive 2";
					end
				end
				v166 = 1 - 0;
			end
		end
	end
	local function v143()
		if (((5431 - 2481) == (536 + 2414)) and v89.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) then
			if (v24(v89.ArcaneIntellect) or ((113 + 4610) < (2423 + 875))) then
				return "arcane_intellect precombat 2";
			end
		end
		if (((2258 - 1122) >= (512 - 358)) and v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v59 and v85) then
			if (v24(v89.MirrorImage) or ((784 - (203 + 310)) > (6741 - (1238 + 755)))) then
				return "mirror_image precombat 2";
			end
		end
		if (((332 + 4408) >= (4686 - (709 + 825))) and v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast)) then
			if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true) or ((4750 - 2172) >= (4938 - 1548))) then
				return "pyroblast precombat 4";
			end
		end
		if (((905 - (196 + 668)) <= (6558 - 4897)) and v89.Fireball:IsReady() and v41) then
			if (((1244 - 643) < (4393 - (171 + 662))) and v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball), true)) then
				return "fireball precombat 6";
			end
		end
	end
	local function v144()
		if (((328 - (4 + 89)) < (2407 - 1720)) and v89.LivingBomb:IsReady() and v43 and (v126 > (1 + 0)) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 - 0)))) then
			if (((1784 + 2765) > (2639 - (35 + 1451))) and v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb))) then
				return "living_bomb active_talents 2";
			end
		end
		if ((v89.Meteor:IsReady() and v44 and (v75 < v123) and ((v109 <= (1453 - (28 + 1425))) or (v14:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((2038 - (941 + 1052)) < v109) or (v123 < v109))))) or ((4482 + 192) < (6186 - (822 + 692)))) then
			if (((5236 - 1568) < (2149 + 2412)) and v24(v91.MeteorCursor, not v15:IsInRange(337 - (45 + 252)))) then
				return "meteor active_talents 4";
			end
		end
		if ((v89.DragonsBreath:IsReady() and v39 and v89.AlexstraszasFury:IsAvailable() and v119 and v14:BuffDown(v89.HotStreakBuff) and (v14:BuffUp(v89.FeeltheBurnBuff) or (v10.CombatTime() > (15 + 0))) and not v135() and (v133() == (0 + 0)) and not v89.TemperedFlames:IsAvailable()) or ((1107 - 652) == (4038 - (114 + 319)))) then
			if (v24(v89.DragonsBreath, not v15:IsInRange(14 - 4)) or ((3411 - 748) == (2112 + 1200))) then
				return "dragons_breath active_talents 6";
			end
		end
		if (((6371 - 2094) <= (9376 - 4901)) and v89.DragonsBreath:IsReady() and v39 and v89.AlexstraszasFury:IsAvailable() and v119 and v14:BuffDown(v89.HotStreakBuff) and (v14:BuffUp(v89.FeeltheBurnBuff) or (v10.CombatTime() > (1978 - (556 + 1407)))) and not v135() and v89.TemperedFlames:IsAvailable()) then
			if (v24(v89.DragonsBreath, not v15:IsInRange(1216 - (741 + 465))) or ((1335 - (170 + 295)) == (627 + 562))) then
				return "dragons_breath active_talents 8";
			end
		end
	end
	local function v145()
		local v167 = v93.HandleDPSPotion(v14:BuffUp(v89.CombustionBuff));
		if (((1427 + 126) <= (7713 - 4580)) and v167) then
			return v167;
		end
		if ((v81 and ((v84 and v35) or not v84) and (v75 < v123)) or ((1855 + 382) >= (2252 + 1259))) then
			local v208 = 0 + 0;
			while true do
				if ((v208 == (1231 - (957 + 273))) or ((355 + 969) > (1209 + 1811))) then
					if (v89.Fireblood:IsCastable() or ((11400 - 8408) == (4956 - 3075))) then
						if (((9487 - 6381) > (7556 - 6030)) and v24(v89.Fireblood)) then
							return "fireblood combustion_cooldowns 8";
						end
					end
					if (((4803 - (389 + 1391)) < (2429 + 1441)) and v89.AncestralCall:IsCastable()) then
						if (((15 + 128) > (168 - 94)) and v24(v89.AncestralCall)) then
							return "ancestral_call combustion_cooldowns 10";
						end
					end
					break;
				end
				if (((969 - (783 + 168)) < (7088 - 4976)) and (v208 == (0 + 0))) then
					if (((1408 - (309 + 2)) <= (4999 - 3371)) and v89.BloodFury:IsCastable()) then
						if (((5842 - (1090 + 122)) == (1502 + 3128)) and v24(v89.BloodFury)) then
							return "blood_fury combustion_cooldowns 4";
						end
					end
					if (((11889 - 8349) > (1837 + 846)) and v89.Berserking:IsCastable() and v118) then
						if (((5912 - (628 + 490)) >= (588 + 2687)) and v24(v89.Berserking)) then
							return "berserking combustion_cooldowns 6";
						end
					end
					v208 = 2 - 1;
				end
			end
		end
		if (((6781 - 5297) == (2258 - (431 + 343))) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
			if (((2891 - 1459) < (10284 - 6729)) and v24(v89.TimeWarp, nil, nil, true)) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v75 < v123) or ((842 + 223) > (458 + 3120))) then
			if ((v82 and ((v35 and v83) or not v83)) or ((6490 - (556 + 1139)) < (1422 - (6 + 9)))) then
				local v228 = 0 + 0;
				while true do
					if (((950 + 903) < (4982 - (28 + 141))) and (v228 == (0 + 0))) then
						v32 = v140();
						if (v32 or ((3481 - 660) < (1722 + 709))) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v146()
		local v168 = 1317 - (486 + 831);
		while true do
			if ((v168 == (12 - 7)) or ((10117 - 7243) < (413 + 1768))) then
				if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < ((12 - 8) * v124)) and (v127 < v99)) or ((3952 - (668 + 595)) <= (309 + 34))) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((377 + 1492) == (5478 - 3469))) then
						return "scorch combustion_phase 36";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v45 and v14:HasTier(320 - (23 + 267), 1946 - (1129 + 815)) and (v89.PhoenixFlames:TravelTime() < v14:BuffRemains(v89.CombustionBuff)) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) < (389 - (371 + 16))) and ((v15:DebuffRemains(v89.CharringEmbersDebuff) < ((1754 - (1326 + 424)) * v124)) or (v14:BuffStack(v89.FlamesFuryBuff) > (1 - 0)) or v14:BuffUp(v89.FlamesFuryBuff))) or ((12957 - 9411) < (2440 - (88 + 30)))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((2853 - (720 + 51)) == (10617 - 5844))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if (((5020 - (421 + 1355)) > (1740 - 685)) and v89.Fireball:IsReady() and v41 and (v14:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v14:BuffUp(v89.FlameAccelerantBuff)) then
					if (v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball)) or ((1628 + 1685) <= (2861 - (286 + 797)))) then
						return "fireball combustion_phase 40";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(109 - 79, 2 - 0) and not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v14:BuffRemains(v89.CombustionBuff)) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) < (441 - (397 + 42)))) or ((444 + 977) >= (2904 - (24 + 776)))) then
					if (((2790 - 978) <= (4034 - (222 + 563))) and v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				v168 = 12 - 6;
			end
			if (((1169 + 454) <= (2147 - (23 + 167))) and (v168 == (1799 - (690 + 1108)))) then
				if (((1592 + 2820) == (3640 + 772)) and v89.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v89.CombustionBuff) and v14:HasTier(878 - (40 + 808), 1 + 1) and not v89.PhoenixFlames:InFlight() and (v15:DebuffRemains(v89.CharringEmbersDebuff) < ((15 - 11) * v124)) and v14:BuffDown(v89.HotStreakBuff)) then
					if (((1673 + 77) >= (446 + 396)) and v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v32 = v144();
				if (((2398 + 1974) > (2421 - (47 + 524))) and v32) then
					return v32;
				end
				if (((151 + 81) < (2244 - 1423)) and v89.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 - 0)) and ((v14:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v14:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) then
					if (((2244 - (1165 + 561)) < (27 + 875)) and v24(v89.Combustion, not v15:IsInRange(123 - 83), nil, true)) then
						return "combustion combustion_phase 10";
					end
				end
				v168 = 1 + 1;
			end
			if (((3473 - (341 + 138)) > (232 + 626)) and (v168 == (3 - 1))) then
				if ((v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and v119 and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((4081 - (89 + 237)) <= (2943 - 2028))) then
					if (((8307 - 4361) > (4624 - (581 + 300))) and v24(v91.FlamestrikeCursor, not v15:IsInRange(1260 - (855 + 365)))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and v119 and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((3170 - 1835) >= (1080 + 2226))) then
					if (((6079 - (1030 + 205)) > (2116 + 137)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if (((421 + 31) == (738 - (156 + 130))) and v89.Fireball:IsReady() and v41 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v125 < (4 - 2)) and not v135()) then
					if (v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball)) or ((7679 - 3122) < (4273 - 2186))) then
						return "fireball combustion_phase 16";
					end
				end
				if (((1021 + 2853) == (2260 + 1614)) and v89.Scorch:IsReady() and v47 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((2007 - (10 + 59)) > (1396 + 3539))) then
						return "scorch combustion_phase 18";
					end
				end
				v168 = 14 - 11;
			end
			if (((1163 - (671 + 492)) == v168) or ((3388 + 867) < (4638 - (369 + 846)))) then
				if (((385 + 1069) <= (2126 + 365)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v35) or not v84) and (v75 < v123) and v119) then
					if (v24(v89.LightsJudgment, not v15:IsSpellInRange(v89.LightsJudgment)) or ((6102 - (1036 + 909)) <= (2229 + 574))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((8147 - 3294) >= (3185 - (11 + 192))) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v35) or not v84) and (v75 < v123) and v119) then
					if (((2090 + 2044) > (3532 - (135 + 40))) and v24(v89.BagofTricks)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if ((v89.LivingBomb:IsReady() and v34 and v43 and (v126 > (2 - 1)) and v119) or ((2060 + 1357) < (5582 - 3048))) then
					if (v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb)) or ((4079 - 1357) <= (340 - (50 + 126)))) then
						return "living_bomb combustion_phase 6";
					end
				end
				if ((v14:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (55 - 35)) or ((533 + 1875) < (3522 - (1233 + 180)))) then
					local v230 = 969 - (522 + 447);
					while true do
						if ((v230 == (1421 - (107 + 1314))) or ((16 + 17) == (4433 - 2978))) then
							v32 = v145();
							if (v32 or ((189 + 254) >= (7973 - 3958))) then
								return v32;
							end
							break;
						end
					end
				end
				v168 = 3 - 2;
			end
			if (((5292 - (716 + 1194)) > (3 + 163)) and (v168 == (1 + 3))) then
				if ((v89.Pyroblast:IsReady() and v46 and v14:PrevGCDP(504 - (74 + 429), v89.Scorch) and v14:BuffUp(v89.HeatingUpBuff) and (v125 < v99) and v118) or ((540 - 260) == (1517 + 1542))) then
					if (((4305 - 2424) > (915 + 378)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast))) then
						return "pyroblast combustion_phase 28";
					end
				end
				if (((7266 - 4909) == (5827 - 3470)) and v89.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v123) and v118 and (v89.FireBlast:Charges() == (433 - (279 + 154))) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v125)) then
					if (((901 - (454 + 324)) == (97 + 26)) and v24(v89.ShiftingPower, not v15:IsInRange(57 - (12 + 5)))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v125 >= v100)) or ((570 + 486) >= (8642 - 5250))) then
					if (v24(v91.FlamestrikeCursor, not v15:IsInRange(15 + 25)) or ((2174 - (277 + 816)) < (4593 - 3518))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and v14:BuffUp(v89.FuryoftheSunKingBuff) and (v14:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) or ((2232 - (1058 + 125)) >= (831 + 3601))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast)) or ((5743 - (815 + 160)) <= (3629 - 2783))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v168 = 11 - 6;
			end
			if ((v168 == (1 + 2)) or ((9815 - 6457) <= (3318 - (41 + 1857)))) then
				if ((v89.FireBlast:IsReady() and v40 and not v137() and not v113 and (not v135() or v14:IsCasting(v89.Scorch) or (v15:DebuffRemains(v89.ImprovedScorchDebuff) > ((1897 - (1222 + 671)) * v124))) and (v14:BuffDown(v89.FuryoftheSunKingBuff) or v14:IsCasting(v89.Pyroblast)) and v118 and v14:BuffDown(v89.HyperthermiaBuff) and v14:BuffDown(v89.HotStreakBuff) and ((v139() + (v28(v14:BuffUp(v89.HeatingUpBuff)) * v28(v14:GCDRemains() > (0 - 0)))) < (2 - 0))) or ((4921 - (229 + 953)) <= (4779 - (1111 + 663)))) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((3238 - (874 + 705)) >= (299 + 1835))) then
						return "fire_blast combustion_phase 20";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v89.HotStreakBuff) and (v125 >= v99)) or (v14:BuffUp(v89.HyperthermiaBuff) and (v125 >= (v99 - v28(v89.Hyperthermia:IsAvailable())))))) or ((2225 + 1035) < (4895 - 2540))) then
					if (v24(v91.FlamestrikeCursor, not v15:IsInRange(2 + 38)) or ((1348 - (642 + 37)) == (963 + 3260))) then
						return "flamestrike combustion_phase 22";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and (v14:BuffUp(v89.HyperthermiaBuff))) or ((271 + 1421) < (1475 - 887))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast)) or ((5251 - (233 + 221)) < (8442 - 4791))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and v14:BuffUp(v89.HotStreakBuff) and v118) or ((3677 + 500) > (6391 - (718 + 823)))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast)) or ((252 + 148) > (1916 - (266 + 539)))) then
						return "pyroblast combustion_phase 26";
					end
				end
				v168 = 11 - 7;
			end
			if (((4276 - (636 + 589)) > (2385 - 1380)) and (v168 == (11 - 5))) then
				if (((2927 + 766) <= (1592 + 2790)) and v89.Scorch:IsReady() and v47 and (v14:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((4297 - (657 + 358)) > (10855 - 6755))) then
						return "scorch combustion_phase 44";
					end
				end
				if ((v89.Fireball:IsReady() and v41 and (v14:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) or ((8156 - 4576) < (4031 - (1151 + 36)))) then
					if (((86 + 3) < (1181 + 3309)) and v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball))) then
						return "fireball combustion_phase 46";
					end
				end
				if ((v89.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v89.CombustionBuff) < v124) and (v126 > (2 - 1))) or ((6815 - (1552 + 280)) < (2642 - (64 + 770)))) then
					if (((2600 + 1229) > (8555 - 4786)) and v24(v89.LivingBomb, not v15:IsSpellInRange(v89.LivingBomb))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
		end
	end
	local function v147()
		local v169 = 0 + 0;
		while true do
			if (((2728 - (157 + 1086)) <= (5812 - 2908)) and (v169 == (0 - 0))) then
				v114 = v89.Combustion:CooldownRemains() * v110;
				v115 = ((v89.Fireball:CastTime() * v28(v125 < v99)) + (v89.Flamestrike:CastTime() * v28(v125 >= v99))) - v104;
				v169 = 1 - 0;
			end
			if (((5825 - 1556) == (5088 - (599 + 220))) and (v169 == (3 - 1))) then
				if (((2318 - (1813 + 118)) <= (2034 + 748)) and v89.SunKingsBlessing:IsAvailable() and v132() and v14:BuffDown(v89.FuryoftheSunKingBuff)) then
					v109 = v30((v116 - v14:BuffStack(v89.SunKingsBlessingBuff)) * (1220 - (841 + 376)) * v124, v109);
				end
				v109 = v30(v14:BuffRemains(v89.CombustionBuff), v109);
				v169 = 3 - 0;
			end
			if ((v169 == (1 + 0)) or ((5183 - 3284) <= (1776 - (464 + 395)))) then
				v109 = v114;
				if ((v89.Firestarter:IsAvailable() and not v96) or ((11066 - 6754) <= (421 + 455))) then
					v109 = v30(v133(), v109);
				end
				v169 = 839 - (467 + 370);
			end
			if (((4612 - 2380) <= (1906 + 690)) and (v169 == (10 - 7))) then
				if (((327 + 1768) < (8575 - 4889)) and (((v114 + ((640 - (150 + 370)) * ((1283 - (74 + 1208)) - (((0.4 - 0) + ((0.2 - 0) * v28(v89.Firestarter:IsAvailable()))) * v28(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (15 + 5))))) then
					v109 = v114;
				end
				break;
			end
		end
	end
	local function v148()
		local v170 = 390 - (14 + 376);
		while true do
			if ((v170 == (0 - 0)) or ((1033 + 562) >= (3931 + 543))) then
				if ((v89.FireBlast:IsReady() and v40 and not v137() and not v113 and v14:BuffDown(v89.HotStreakBuff) and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) == (1 + 0)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (2 - 1)) or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 0) * v124)))) or ((4697 - (23 + 55)) < (6829 - 3947))) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((197 + 97) >= (4339 + 492))) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if (((3145 - 1116) <= (971 + 2113)) and v89.FireBlast:IsReady() and v40 and not v137() and not v113 and ((v28(v14:BuffUp(v89.HeatingUpBuff)) + v139()) == (902 - (652 + 249))) and v89.ShiftingPower:CooldownUp() and (not v14:HasTier(80 - 50, 1870 - (708 + 1160)) or (v15:DebuffRemains(v89.CharringEmbersDebuff) > ((5 - 3) * v124)))) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((3713 - 1676) == (2447 - (10 + 17)))) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v149()
		local v171 = 0 + 0;
		while true do
			if (((6190 - (1400 + 332)) > (7487 - 3583)) and (v171 == (1908 - (242 + 1666)))) then
				if (((187 + 249) >= (46 + 77)) and v34 and v89.Flamestrike:IsReady() and v42 and (v125 >= v97) and v137()) then
					if (((427 + 73) < (2756 - (850 + 90))) and v24(v91.FlamestrikeCursor, not v15:IsInRange(70 - 30))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((4964 - (360 + 1030)) == (3163 + 411)) and v89.Pyroblast:IsReady() and v46 and (v137())) then
					if (((623 - 402) < (536 - 146)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and not v14:IsCasting(v89.Flamestrike) and (v125 >= v100) and v14:BuffUp(v89.FuryoftheSunKingBuff)) or ((3874 - (909 + 752)) <= (2644 - (109 + 1114)))) then
					if (((5598 - 2540) < (1892 + 2968)) and v24(v91.FlamestrikeCursor, not v15:IsInRange(282 - (6 + 236)))) then
						return "flamestrike standard_rotation 12";
					end
				end
				if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((4 + 1) * v124))) and v14:BuffUp(v89.FuryoftheSunKingBuff) and not v14:IsCasting(v89.Scorch)) or ((1044 + 252) >= (10485 - 6039))) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((2432 - 1039) > (5622 - (1076 + 57)))) then
						return "scorch standard_rotation 13";
					end
				end
				v171 = 1 + 0;
			end
			if ((v171 == (692 - (579 + 110))) or ((350 + 4074) < (24 + 3))) then
				if ((v89.PhoenixFlames:IsCastable() and v45 and v89.AlexstraszasFury:IsAvailable() and v14:BuffDown(v89.HotStreakBuff) and (v139() == (0 + 0)) and ((not v112 and v14:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (409.5 - (174 + 233))) or ((v89.PhoenixFlames:ChargesFractional() > (2.5 - 1)) and (not v89.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((4 - 1) * v124)))))) or ((889 + 1108) > (4989 - (663 + 511)))) then
					if (((3092 + 373) > (416 + 1497)) and v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v144();
				if (((2259 - 1526) < (1102 + 717)) and v32) then
					return v32;
				end
				if ((v34 and v89.DragonsBreath:IsReady() and v39 and (v127 > (2 - 1)) and v89.AlexstraszasFury:IsAvailable()) or ((10639 - 6244) == (2269 + 2486))) then
					if (v24(v89.DragonsBreath, not v15:IsInRange(19 - 9)) or ((2704 + 1089) < (217 + 2152))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v171 = 726 - (478 + 244);
			end
			if ((v171 == (519 - (440 + 77))) or ((1857 + 2227) == (969 - 704))) then
				if (((5914 - (655 + 901)) == (809 + 3549)) and v89.PhoenixFlames:IsCastable() and v45 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 0) * v124)))) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((2119 + 1019) < (4000 - 3007))) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((4775 - (695 + 750)) > (7932 - 5609)) and v89.PhoenixFlames:IsCastable() and v45 and v14:HasTier(46 - 16, 7 - 5) and (v15:DebuffRemains(v89.CharringEmbersDebuff) < ((353 - (285 + 66)) * v124)) and v14:BuffDown(v89.HotStreakBuff)) then
					if (v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames)) or ((8452 - 4826) == (5299 - (682 + 628)))) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffStack(v89.ImprovedScorchDebuff) < v117)) or ((148 + 768) == (2970 - (176 + 123)))) then
					if (((114 + 158) == (198 + 74)) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
						return "scorch standard_rotation 22";
					end
				end
				if (((4518 - (239 + 30)) <= (1316 + 3523)) and v89.PhoenixFlames:IsCastable() and v45 and not v89.AlexstraszasFury:IsAvailable() and v14:BuffDown(v89.HotStreakBuff) and not v112 and v14:BuffUp(v89.FlamesFuryBuff)) then
					if (((2670 + 107) < (5663 - 2463)) and v24(v89.PhoenixFlames, not v15:IsSpellInRange(v89.PhoenixFlames))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v171 = 8 - 5;
			end
			if (((410 - (306 + 9)) < (6828 - 4871)) and (v171 == (1 + 3))) then
				if (((507 + 319) < (827 + 890)) and v89.Scorch:IsReady() and v47 and (v134())) then
					if (((4077 - 2651) >= (2480 - (1140 + 235))) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((1753 + 1001) <= (3099 + 280)) and v34 and v89.ArcaneExplosion:IsReady() and v37 and (v128 >= v101) and (v14:ManaPercentageP() >= v102)) then
					if (v24(v89.ArcaneExplosion, not v15:IsInRange(3 + 5)) or ((3979 - (33 + 19)) == (511 + 902))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((v34 and v89.Flamestrike:IsReady() and v42 and (v125 >= v98)) or ((3458 - 2304) <= (348 + 440))) then
					if (v24(v91.FlamestrikeCursor, not v15:IsInRange(78 - 38)) or ((1541 + 102) > (4068 - (586 + 103)))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v89.Pyroblast:IsReady() and v46 and v89.TemperedFlames:IsAvailable() and v14:BuffDown(v89.FlameAccelerantBuff)) or ((256 + 2547) > (14004 - 9455))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true) or ((1708 - (1309 + 179)) >= (5454 - 2432))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v171 = 3 + 2;
			end
			if (((7578 - 4756) == (2132 + 690)) and (v171 == (10 - 5))) then
				if ((v89.Fireball:IsReady() and v41 and not v137()) or ((2114 - 1053) == (2466 - (295 + 314)))) then
					if (((6779 - 4019) > (3326 - (1300 + 662))) and v24(v89.Fireball, not v15:IsSpellInRange(v89.Fireball), true)) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v171 == (3 - 2)) or ((6657 - (1178 + 577)) <= (1867 + 1728))) then
				if ((v89.Pyroblast:IsReady() and v46 and not v14:IsCasting(v89.Pyroblast) and (v14:BuffUp(v89.FuryoftheSunKingBuff))) or ((11387 - 7535) == (1698 - (851 + 554)))) then
					if (v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true) or ((1379 + 180) == (12724 - 8136))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v89.FireBlast:IsReady() and v40 and not v137() and not v132() and not v113 and v14:BuffDown(v89.FuryoftheSunKingBuff) and ((((v14:IsCasting(v89.Fireball) and ((v89.Fireball:ExecuteRemains() < (0.5 - 0)) or not v89.Hyperthermia:IsAvailable())) or (v14:IsCasting(v89.Pyroblast) and ((v89.Pyroblast:ExecuteRemains() < (302.5 - (115 + 187))) or not v89.Hyperthermia:IsAvailable()))) and v14:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v15:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (3 + 0))) and ((v14:BuffUp(v89.HeatingUpBuff) and not v14:IsCasting(v89.Scorch)) or (v14:BuffDown(v89.HotStreakBuff) and v14:BuffDown(v89.HeatingUpBuff) and v14:IsCasting(v89.Scorch) and (v139() == (0 + 0))))))) or ((17669 - 13185) == (1949 - (160 + 1001)))) then
					if (((3997 + 571) >= (2696 + 1211)) and v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast standard_rotation 16";
					end
				end
				if (((2550 - 1304) < (3828 - (237 + 121))) and v89.Pyroblast:IsReady() and v46 and (v14:IsCasting(v89.Scorch) or v14:PrevGCDP(898 - (525 + 372), v89.Scorch)) and v14:BuffUp(v89.HeatingUpBuff) and v134() and (v125 < v97)) then
					if (((7712 - 3644) >= (3193 - 2221)) and v24(v89.Pyroblast, not v15:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((635 - (96 + 46)) < (4670 - (643 + 134))) and v89.Scorch:IsReady() and v47 and v135() and (v15:DebuffRemains(v89.ImprovedScorchDebuff) < ((2 + 2) * v124))) then
					if (v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch)) or ((3531 - 2058) >= (12370 - 9038))) then
						return "scorch standard_rotation 19";
					end
				end
				v171 = 2 + 0;
			end
		end
	end
	local function v150()
		local v172 = 0 - 0;
		while true do
			if ((v172 == (0 - 0)) or ((4770 - (316 + 403)) <= (770 + 387))) then
				if (((1660 - 1056) < (1042 + 1839)) and not v95) then
					v147();
				end
				if ((v35 and v87 and v89.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (100 - 60)))) or ((638 + 262) == (1089 + 2288))) then
					if (((15450 - 10991) > (2822 - 2231)) and v24(v89.TimeWarp, not v15:IsInRange(83 - 43))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((195 + 3203) >= (4714 - 2319)) and (v75 < v123)) then
					if ((v82 and ((v35 and v83) or not v83)) or ((107 + 2076) >= (8308 - 5484))) then
						v32 = v140();
						if (((1953 - (12 + 5)) == (7519 - 5583)) and v32) then
							return v32;
						end
					end
				end
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v172 = 1 - 0;
			end
			if ((v172 == (1 - 0)) or ((11982 - 7150) < (876 + 3437))) then
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v28(v111))) / v89.FireBlast:Cooldown())) - (1974 - (1656 + 317))) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((11 + 1) / v89.FireBlast:Cooldown()) % (1 + 0)))) and (v109 < v123);
				if (((10869 - 6781) > (19066 - 15192)) and not v95 and ((v109 <= (354 - (5 + 349))) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) then
					v32 = v146();
					if (((20576 - 16244) == (5603 - (266 + 1005))) and v32) then
						return v32;
					end
				end
				if (((2636 + 1363) >= (9895 - 6995)) and not v113 and v89.SunKingsBlessing:IsAvailable()) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((3 - 0) * v124));
				end
				if ((v89.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v123) and v119 and ((v89.FireBlast:Charges() == (1696 - (561 + 1135))) or v113) and (not v135() or ((v15:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v14:BuffDown(v89.FuryoftheSunKingBuff))) and v14:BuffDown(v89.HotStreakBuff) and v111) or ((3290 - 765) > (13358 - 9294))) then
					if (((5437 - (507 + 559)) == (10968 - 6597)) and v24(v89.ShiftingPower, not v15:IsInRange(123 - 83), true)) then
						return "shifting_power main 12";
					end
				end
				v172 = 390 - (212 + 176);
			end
			if (((907 - (250 + 655)) == v172) or ((725 - 459) > (8712 - 3726))) then
				if (((3114 - 1123) >= (2881 - (1869 + 87))) and (v125 < v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + (24 - 17)) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v28(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if (((2356 - (484 + 1417)) < (4400 - 2347)) and (v125 >= v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v28(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if ((v89.FireBlast:IsReady() and v40 and not v137() and not v113 and (v109 > (0 - 0)) and (v125 >= v98) and not v132() and v14:BuffDown(v89.HotStreakBuff) and ((v14:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (773.5 - (48 + 725)))) or (v89.FireBlast:ChargesFractional() >= (2 - 0)))) or ((2215 - 1389) == (2820 + 2031))) then
					if (((488 - 305) == (52 + 131)) and v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true)) then
						return "fire_blast main 14";
					end
				end
				if (((338 + 821) <= (2641 - (152 + 701))) and v119 and v132() and (v109 > (1311 - (430 + 881)))) then
					v32 = v148();
					if (v32 or ((1344 + 2163) > (5213 - (557 + 338)))) then
						return v32;
					end
				end
				v172 = 1 + 2;
			end
			if ((v172 == (8 - 5)) or ((10767 - 7692) <= (7877 - 4912))) then
				if (((2941 - 1576) <= (2812 - (499 + 302))) and v89.FireBlast:IsReady() and v40 and not v137() and v14:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) then
					if (v24(v89.FireBlast, not v15:IsSpellInRange(v89.FireBlast), nil, true) or ((3642 - (39 + 827)) > (9868 - 6293))) then
						return "fire_blast main 16";
					end
				end
				if (((v109 > (0 - 0)) and v119) or ((10144 - 7590) == (7375 - 2571))) then
					v32 = v149();
					if (((221 + 2356) == (7542 - 4965)) and v32) then
						return v32;
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((1 + 5) >= (2988 - 1099))) then
					if (((610 - (103 + 1)) <= (2446 - (475 + 79))) and v24(v89.IceNova, not v15:IsSpellInRange(v89.IceNova))) then
						return "ice_nova main 18";
					end
				end
				if ((v89.Scorch:IsReady() and v47) or ((4340 - 2332) > (7097 - 4879))) then
					if (((49 + 330) <= (3650 + 497)) and v24(v89.Scorch, not v15:IsSpellInRange(v89.Scorch))) then
						return "scorch main 20";
					end
				end
				break;
			end
		end
	end
	local function v151()
		v37 = EpicSettings.Settings['useArcaneExplosion'];
		v38 = EpicSettings.Settings['useArcaneIntellect'];
		v39 = EpicSettings.Settings['useDragonsBreath'];
		v40 = EpicSettings.Settings['useFireBlast'];
		v41 = EpicSettings.Settings['useFireball'];
		v42 = EpicSettings.Settings['useFlamestrike'];
		v43 = EpicSettings.Settings['useLivingBomb'];
		v44 = EpicSettings.Settings['useMeteor'];
		v45 = EpicSettings.Settings['usePhoenixFlames'];
		v46 = EpicSettings.Settings['usePyroblast'];
		v47 = EpicSettings.Settings['useScorch'];
		v48 = EpicSettings.Settings['useCounterspell'];
		v49 = EpicSettings.Settings['useBlastWave'];
		v50 = EpicSettings.Settings['useCombustion'];
		v51 = EpicSettings.Settings['useShiftingPower'];
		v52 = EpicSettings.Settings['combustionWithCD'];
		v53 = EpicSettings.Settings['shiftingPowerWithCD'];
		v54 = EpicSettings.Settings['useAlterTime'];
		v55 = EpicSettings.Settings['useBlazingBarrier'];
		v56 = EpicSettings.Settings['useGreaterInvisibility'];
		v57 = EpicSettings.Settings['useIceBlock'];
		v58 = EpicSettings.Settings['useIceCold'];
		v60 = EpicSettings.Settings['useMassBarrier'];
		v59 = EpicSettings.Settings['useMirrorImage'];
		v61 = EpicSettings.Settings['alterTimeHP'] or (1503 - (1395 + 108));
		v62 = EpicSettings.Settings['blazingBarrierHP'] or (0 - 0);
		v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (1204 - (7 + 1197));
		v64 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
		v65 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
		v66 = EpicSettings.Settings['mirrorImageHP'] or (319 - (27 + 292));
		v67 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v152()
		local v201 = 0 - 0;
		while true do
			if ((v201 == (8 - 6)) or ((8901 - 4387) <= (1921 - 912))) then
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v76 = EpicSettings.Settings['useHealingPotion'];
				v201 = 142 - (43 + 96);
			end
			if ((v201 == (16 - 12)) or ((7903 - 4407) == (990 + 202))) then
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v201 == (1 + 2)) or ((410 - 202) == (1135 + 1824))) then
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v78 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v70 = EpicSettings.Settings['handleAfflicted'];
				v201 = 1 + 3;
			end
			if (((6028 - (1414 + 337)) >= (3253 - (1642 + 298))) and (v201 == (2 - 1))) then
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v68 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v81 = EpicSettings.Settings['useRacials'];
				v201 = 5 - 3;
			end
			if (((7677 - 5090) < (1045 + 2129)) and ((0 + 0) == v201)) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (972 - (357 + 615));
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v201 = 1 + 0;
			end
		end
	end
	local function v153()
		local v202 = 0 - 0;
		while true do
			if ((v202 == (2 + 0)) or ((8829 - 4709) <= (1758 + 440))) then
				if (v14:IsDeadOrGhost() or ((109 + 1487) == (540 + 318))) then
					return v32;
				end
				v130 = v15:GetEnemiesInSplashRange(1306 - (384 + 917));
				v129 = v14:GetEnemiesInRange(737 - (128 + 569));
				v202 = 1546 - (1407 + 136);
			end
			if (((5107 - (687 + 1200)) == (4930 - (556 + 1154))) and (v202 == (0 - 0))) then
				v151();
				v152();
				v33 = EpicSettings.Toggles['ooc'];
				v202 = 96 - (9 + 86);
			end
			if ((v202 == (422 - (275 + 146))) or ((229 + 1173) > (3684 - (29 + 35)))) then
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v202 = 8 - 6;
			end
			if (((7687 - 5113) == (11362 - 8788)) and (v202 == (2 + 1))) then
				if (((2810 - (53 + 959)) < (3165 - (312 + 96))) and v34) then
					local v231 = 0 - 0;
					while true do
						if ((v231 == (286 - (147 + 138))) or ((1276 - (813 + 86)) > (2354 + 250))) then
							v127 = v30(v15:GetEnemiesInSplashRangeCount(8 - 3), #v129);
							v128 = #v129;
							break;
						end
						if (((1060 - (18 + 474)) < (308 + 603)) and (v231 == (0 - 0))) then
							v125 = v30(v15:GetEnemiesInSplashRangeCount(1091 - (860 + 226)), #v129);
							v126 = v30(v15:GetEnemiesInSplashRangeCount(308 - (121 + 182)), #v129);
							v231 = 1 + 0;
						end
					end
				else
					local v232 = 1240 - (988 + 252);
					while true do
						if (((372 + 2913) < (1325 + 2903)) and (v232 == (1971 - (49 + 1921)))) then
							v127 = 891 - (223 + 667);
							v128 = 53 - (51 + 1);
							break;
						end
						if (((6739 - 2823) > (7126 - 3798)) and (v232 == (1125 - (146 + 979)))) then
							v125 = 1 + 0;
							v126 = 606 - (311 + 294);
							v232 = 2 - 1;
						end
					end
				end
				if (((1059 + 1441) < (5282 - (496 + 947))) and (v93.TargetIsValid() or v14:AffectingCombat())) then
					local v233 = 1358 - (1233 + 125);
					while true do
						if (((206 + 301) == (455 + 52)) and (v233 == (1 + 3))) then
							v118 = v14:BuffUp(v89.CombustionBuff);
							v119 = not v118;
							break;
						end
						if (((1885 - (963 + 682)) <= (2642 + 523)) and (v233 == (1504 - (504 + 1000)))) then
							if (((562 + 272) >= (734 + 71)) and (v14:AffectingCombat() or v69)) then
								local v236 = v69 and v89.RemoveCurse:IsReady() and v36;
								v32 = v93.FocusUnit(v236, v91, 2 + 18, nil, 29 - 9);
								if (v32 or ((3257 + 555) < (1347 + 969))) then
									return v32;
								end
							end
							v122 = v10.BossFightRemains(nil, true);
							v233 = 183 - (156 + 26);
						end
						if ((v233 == (1 + 0)) or ((4148 - 1496) <= (1697 - (149 + 15)))) then
							v123 = v122;
							if ((v123 == (12071 - (890 + 70))) or ((3715 - (39 + 78)) < (1942 - (14 + 468)))) then
								v123 = v10.FightRemains(v129, false);
							end
							v233 = 4 - 2;
						end
						if ((v233 == (8 - 5)) or ((2124 + 1992) < (716 + 476))) then
							if (v95 or ((718 + 2659) <= (408 + 495))) then
								v109 = 26199 + 73800;
							end
							v124 = v14:GCD();
							v233 = 7 - 3;
						end
						if (((3930 + 46) >= (1542 - 1103)) and (v233 == (1 + 1))) then
							v131 = v138(v129);
							v95 = not v35;
							v233 = 54 - (12 + 39);
						end
					end
				end
				if (((3491 + 261) == (11613 - 7861)) and not v14:AffectingCombat() and v33) then
					local v234 = 0 - 0;
					while true do
						if (((1200 + 2846) > (1419 + 1276)) and (v234 == (0 - 0))) then
							v32 = v143();
							if (v32 or ((2362 + 1183) == (15450 - 12253))) then
								return v32;
							end
							break;
						end
					end
				end
				v202 = 1714 - (1596 + 114);
			end
			if (((6250 - 3856) > (1086 - (164 + 549))) and (v202 == (1442 - (1059 + 379)))) then
				if (((5159 - 1004) <= (2194 + 2038)) and v14:AffectingCombat() and v93.TargetIsValid()) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (392 - (145 + 247))) or ((2939 + 642) == (1605 + 1868))) then
							if (((14808 - 9813) > (643 + 2705)) and v69 and v36 and v89.RemoveCurse:IsAvailable()) then
								local v237 = 0 + 0;
								while true do
									if ((v237 == (0 - 0)) or ((1474 - (254 + 466)) > (4284 - (544 + 16)))) then
										if (((689 - 472) >= (685 - (294 + 334))) and v16) then
											v32 = v141();
											if (v32 or ((2323 - (236 + 17)) >= (1741 + 2296))) then
												return v32;
											end
										end
										if (((2106 + 599) == (10187 - 7482)) and v18 and v18:Exists() and v18:IsAPlayer() and v93.UnitHasCurseDebuff(v18)) then
											if (((288 - 227) == (32 + 29)) and v89.RemoveCurse:IsReady()) then
												if (v24(v91.RemoveCurseMouseover) or ((576 + 123) >= (2090 - (413 + 381)))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							v32 = v142();
							v235 = 1 + 0;
						end
						if ((v235 == (8 - 4)) or ((4631 - 2848) >= (5586 - (582 + 1388)))) then
							v32 = v150();
							if (v32 or ((6666 - 2753) > (3241 + 1286))) then
								return v32;
							end
							break;
						end
						if (((4740 - (326 + 38)) > (2416 - 1599)) and (v235 == (2 - 0))) then
							if (((5481 - (47 + 573)) > (291 + 533)) and v71) then
								v32 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseOver, 127 - 97, true);
								if (v32 or ((2244 - 861) >= (3795 - (1269 + 395)))) then
									return v32;
								end
							end
							if ((v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v93.UnitHasMagicBuff(v15)) or ((2368 - (76 + 416)) >= (2984 - (319 + 124)))) then
								if (((4073 - 2291) <= (4779 - (564 + 443))) and v24(v89.Spellsteal, not v15:IsSpellInRange(v89.Spellsteal))) then
									return "spellsteal damage";
								end
							end
							v235 = 7 - 4;
						end
						if ((v235 == (459 - (337 + 121))) or ((13771 - 9071) < (2707 - 1894))) then
							if (((5110 - (1261 + 650)) < (1714 + 2336)) and v32) then
								return v32;
							end
							if (v70 or ((7890 - 2939) < (6247 - (772 + 1045)))) then
								if (((14 + 82) == (240 - (102 + 42))) and v88) then
									local v238 = 1844 - (1524 + 320);
									while true do
										if ((v238 == (1270 - (1049 + 221))) or ((2895 - (18 + 138)) > (9810 - 5802))) then
											v32 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 1132 - (67 + 1035));
											if (v32 or ((371 - (136 + 212)) == (4818 - 3684))) then
												return v32;
											end
											break;
										end
									end
								end
							end
							v235 = 2 + 0;
						end
						if (((3 + 0) == v235) or ((4297 - (240 + 1364)) >= (5193 - (1050 + 32)))) then
							if (((v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v89.HotStreakBuff)) or ((15410 - 11094) <= (1270 + 876))) then
								if (v24(v91.StopCasting, not v15:IsSpellInRange(v89.Pyroblast)) or ((4601 - (331 + 724)) <= (227 + 2582))) then
									return "Stop Casting";
								end
							end
							if (((5548 - (269 + 375)) > (2891 - (267 + 458))) and v14:IsMoving() and v89.IceFloes:IsReady()) then
								if (((34 + 75) >= (173 - 83)) and v24(v89.IceFloes)) then
									return "ice_floes movement";
								end
							end
							v235 = 822 - (667 + 151);
						end
					end
				end
				break;
			end
		end
	end
	local function v154()
		local v203 = 1497 - (1410 + 87);
		while true do
			if (((6875 - (1504 + 393)) > (7852 - 4947)) and (v203 == (0 - 0))) then
				v94();
				v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(859 - (461 + 335), v153, v154);
end;
return v0["Epix_Mage_Fire.lua"]();

