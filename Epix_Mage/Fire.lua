local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((1318 - (757 + 15)) >= (1469 + 1215))) then
			v6 = v0[v4];
			if (((2694 - 1229) <= (2844 + 1457)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((1225 + 479) > (1197 + 228)) and (v5 == (1 + 0))) then
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
	local v89;
	local v90 = v19.Mage.Fire;
	local v91 = v21.Mage.Fire;
	local v92 = v26.Mage.Fire;
	local v93 = {};
	local v94 = v22.Commons.Everyone;
	local function v95()
		if (v90.RemoveCurse:IsAvailable() or ((1120 - (153 + 280)) == (12225 - 7991))) then
			v94.DispellableDebuffs = v94.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v95();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v96 = not v35;
	local v97 = v90.SunKingsBlessing:IsAvailable();
	local v98 = ((v90.FlamePatch:IsAvailable()) and (4 + 0)) or (395 + 604);
	local v99 = 523 + 476;
	local v100 = v98;
	local v101 = ((3 + 0) * v28(v90.FueltheFire:IsAvailable())) + ((724 + 275) * v28(not v90.FueltheFire:IsAvailable()));
	local v102 = 1520 - 521;
	local v103 = 25 + 15;
	local v104 = 1666 - (89 + 578);
	local v105 = 0.3 + 0;
	local v106 = 0 - 0;
	local v107 = 1055 - (572 + 477);
	local v108 = false;
	local v109 = (v108 and (3 + 17)) or (0 + 0);
	local v110;
	local v111 = ((v90.Kindling:IsAvailable()) and (0.4 + 0)) or (87 - (84 + 2));
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = 0 - 0;
	local v116 = 0 + 0;
	local v117 = 850 - (497 + 345);
	local v118 = 1 + 2;
	local v119;
	local v120;
	local v121;
	local v122 = 1 + 2;
	local v123 = 12444 - (605 + 728);
	local v124 = 7928 + 3183;
	local v125;
	local v126, v127, v128;
	local v129;
	local v130;
	local v131;
	local v132;
	v10:RegisterForEvent(function()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (0 + 0)) or ((12311 - 8981) < (1289 + 140))) then
				v108 = false;
				v109 = (v108 and (55 - 35)) or (0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v90.Pyroblast:RegisterInFlight();
		v90.Fireball:RegisterInFlight();
		v90.Meteor:RegisterInFlightEffect(351629 - (457 + 32));
		v90.Meteor:RegisterInFlight();
		v90.PhoenixFlames:RegisterInFlightEffect(109269 + 148273);
		v90.PhoenixFlames:RegisterInFlight();
		v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
		v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	end, "LEARNED_SPELL_IN_TAB");
	v90.Pyroblast:RegisterInFlight();
	v90.Fireball:RegisterInFlight();
	v90.Meteor:RegisterInFlightEffect(352542 - (832 + 570));
	v90.Meteor:RegisterInFlight();
	v90.PhoenixFlames:RegisterInFlightEffect(242628 + 14914);
	v90.PhoenixFlames:RegisterInFlight();
	v90.Pyroblast:RegisterInFlight(v90.CombustionBuff);
	v90.Fireball:RegisterInFlight(v90.CombustionBuff);
	v10:RegisterForEvent(function()
		local v158 = 0 + 0;
		while true do
			if (((4058 - 2911) >= (162 + 173)) and (v158 == (796 - (588 + 208)))) then
				v123 = 29946 - 18835;
				v124 = 12911 - (884 + 916);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v97 = v90.SunKingsBlessing:IsAvailable();
		v98 = ((v90.FlamePatch:IsAvailable()) and (6 - 3)) or (580 + 419);
		v100 = v98;
		v111 = ((v90.Kindling:IsAvailable()) and (653.4 - (232 + 421))) or (1890 - (1569 + 320));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v133()
		return v90.Firestarter:IsAvailable() and (v15:HealthPercentage() > (23 + 67));
	end
	local function v134()
		return (v90.Firestarter:IsAvailable() and (((v15:HealthPercentage() > (18 + 72)) and v15:TimeToX(303 - 213)) or (605 - (316 + 289)))) or (0 - 0);
	end
	local function v135()
		return v90.SearingTouch:IsAvailable() and (v15:HealthPercentage() < (2 + 28));
	end
	local function v136()
		return v90.ImprovedScorch:IsAvailable() and (v15:HealthPercentage() < (1483 - (666 + 787)));
	end
	local function v137()
		return (v122 * v90.ShiftingPower:BaseDuration()) / v90.ShiftingPower:BaseTickTime();
	end
	local function v138()
		local v159 = 425 - (360 + 65);
		local v160;
		while true do
			if (((3211 + 224) > (2351 - (79 + 175))) and (v159 == (1 - 0))) then
				return v14:BuffUp(v90.HotStreakBuff) or v14:BuffUp(v90.HyperthermiaBuff) or (v14:BuffUp(v90.HeatingUpBuff) and ((v136() and v14:IsCasting(v90.Scorch)) or (v133() and (v14:IsCasting(v90.Fireball) or v14:IsCasting(v90.Pyroblast) or (v160 > (0 + 0))))));
			end
			if ((v159 == (0 - 0)) or ((7260 - 3490) >= (4940 - (503 + 396)))) then
				v160 = (v133() and (v28(v90.Pyroblast:InFlight()) + v28(v90.Fireball:InFlight()))) or (181 - (92 + 89));
				v160 = v160 + v28(v90.PhoenixFlames:InFlight() or v14:PrevGCDP(1 - 0, v90.PhoenixFlames));
				v159 = 1 + 0;
			end
		end
	end
	local function v139(v161)
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (3 - 2)) or ((519 + 3272) <= (3673 - 2062))) then
				return v163;
			end
			if ((v162 == (0 + 0)) or ((2187 + 2391) <= (6115 - 4107))) then
				v163 = 0 + 0;
				for v228, v229 in pairs(v161) do
					if (((1715 - 590) <= (3320 - (485 + 759))) and v229:DebuffUp(v90.IgniteDebuff)) then
						v163 = v163 + (2 - 1);
					end
				end
				v162 = 1190 - (442 + 747);
			end
		end
	end
	local function v140()
		local v164 = 1135 - (832 + 303);
		local v165;
		while true do
			if ((v164 == (946 - (88 + 858))) or ((227 + 516) >= (3641 + 758))) then
				v165 = 0 + 0;
				if (((1944 - (766 + 23)) < (8259 - 6586)) and (v90.Fireball:InFlight() or v90.PhoenixFlames:InFlight())) then
					v165 = v165 + (1 - 0);
				end
				v164 = 2 - 1;
			end
			if ((v164 == (3 - 2)) or ((3397 - (1036 + 37)) <= (410 + 168))) then
				return v165;
			end
		end
	end
	local function v141()
		local v166 = 0 - 0;
		while true do
			if (((2964 + 803) == (5247 - (641 + 839))) and (v166 == (913 - (910 + 3)))) then
				v32 = v94.HandleTopTrinket(v93, v35, 101 - 61, nil);
				if (((5773 - (1466 + 218)) == (1880 + 2209)) and v32) then
					return v32;
				end
				v166 = 1149 - (556 + 592);
			end
			if (((1586 + 2872) >= (2482 - (329 + 479))) and (v166 == (855 - (174 + 680)))) then
				v32 = v94.HandleBottomTrinket(v93, v35, 137 - 97, nil);
				if (((2014 - 1042) <= (1013 + 405)) and v32) then
					return v32;
				end
				break;
			end
		end
	end
	local v142 = 739 - (396 + 343);
	local function v143()
		if ((v90.RemoveCurse:IsReady() and (v94.UnitHasDispellableDebuffByPlayer(v16) or v94.DispellableFriendlyUnit(3 + 22))) or ((6415 - (29 + 1448)) < (6151 - (135 + 1254)))) then
			if ((v142 == (0 - 0)) or ((11691 - 9187) > (2842 + 1422))) then
				v142 = GetTime();
			end
			if (((3680 - (389 + 1138)) == (2727 - (102 + 472))) and v94.Wait(472 + 28, v142)) then
				local v230 = 0 + 0;
				while true do
					if ((v230 == (0 + 0)) or ((2052 - (320 + 1225)) >= (4612 - 2021))) then
						if (((2742 + 1739) == (5945 - (157 + 1307))) and v24(v92.RemoveCurseFocus)) then
							return "remove_curse dispel";
						end
						v142 = 1859 - (821 + 1038);
						break;
					end
				end
			end
		end
	end
	local function v144()
		if ((v90.BlazingBarrier:IsCastable() and v55 and v14:BuffDown(v90.BlazingBarrier) and (v14:HealthPercentage() <= v62)) or ((5808 - 3480) < (76 + 617))) then
			if (((7687 - 3359) == (1611 + 2717)) and v24(v90.BlazingBarrier)) then
				return "blazing_barrier defensive 1";
			end
		end
		if (((3935 - 2347) >= (2358 - (834 + 192))) and v90.MassBarrier:IsCastable() and v60 and v14:BuffDown(v90.BlazingBarrier) and v94.AreUnitsBelowHealthPercentage(v67, 1 + 1, v90.ArcaneIntellect)) then
			if (v24(v90.MassBarrier) or ((1072 + 3102) > (92 + 4156))) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v90.IceBlock:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) or ((7104 - 2518) <= (386 - (300 + 4)))) then
			if (((1032 + 2831) == (10112 - 6249)) and v24(v90.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if ((v90.IceColdTalent:IsAvailable() and v90.IceColdAbility:IsCastable() and v58 and (v14:HealthPercentage() <= v65)) or ((644 - (112 + 250)) <= (17 + 25))) then
			if (((11546 - 6937) >= (439 + 327)) and v24(v90.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v59 and (v14:HealthPercentage() <= v66)) or ((596 + 556) == (1861 + 627))) then
			if (((1697 + 1725) > (2489 + 861)) and v24(v90.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if (((2291 - (1001 + 413)) > (838 - 462)) and v90.GreaterInvisibility:IsReady() and v56 and (v14:HealthPercentage() <= v63)) then
			if (v24(v90.GreaterInvisibility) or ((4000 - (244 + 638)) <= (2544 - (627 + 66)))) then
				return "greater_invisibility defensive 5";
			end
		end
		if ((v90.AlterTime:IsReady() and v54 and (v14:HealthPercentage() <= v61)) or ((491 - 326) >= (4094 - (512 + 90)))) then
			if (((5855 - (1665 + 241)) < (5573 - (373 + 344))) and v24(v90.AlterTime)) then
				return "alter_time defensive 6";
			end
		end
		if ((v91.Healthstone:IsReady() and v78 and (v14:HealthPercentage() <= v80)) or ((1929 + 2347) < (799 + 2217))) then
			if (((12370 - 7680) > (6980 - 2855)) and v24(v92.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v77 and (v14:HealthPercentage() <= v79)) or ((1149 - (35 + 1064)) >= (652 + 244))) then
			if ((v81 == "Refreshing Healing Potion") or ((3666 - 1952) >= (12 + 2946))) then
				if (v91.RefreshingHealingPotion:IsReady() or ((2727 - (298 + 938)) < (1903 - (233 + 1026)))) then
					if (((2370 - (636 + 1030)) < (505 + 482)) and v24(v92.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((3632 + 86) > (567 + 1339)) and (v81 == "Dreamwalker's Healing Potion")) then
				if (v91.DreamwalkersHealingPotion:IsReady() or ((65 + 893) > (3856 - (55 + 166)))) then
					if (((679 + 2822) <= (452 + 4040)) and v24(v92.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v145()
		if ((v90.ArcaneIntellect:IsCastable() and v38 and (v14:BuffDown(v90.ArcaneIntellect, true) or v94.GroupBuffMissing(v90.ArcaneIntellect))) or ((13145 - 9703) < (2845 - (36 + 261)))) then
			if (((5027 - 2152) >= (2832 - (34 + 1334))) and v24(v90.ArcaneIntellect)) then
				return "arcane_intellect precombat 2";
			end
		end
		if ((v90.MirrorImage:IsCastable() and v94.TargetIsValid() and v59 and v86) or ((1845 + 2952) >= (3802 + 1091))) then
			if (v24(v90.MirrorImage) or ((1834 - (1035 + 248)) > (2089 - (20 + 1)))) then
				return "mirror_image precombat 2";
			end
		end
		if (((1102 + 1012) > (1263 - (134 + 185))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast)) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((3395 - (549 + 584)) >= (3781 - (314 + 371)))) then
				return "pyroblast precombat 4";
			end
		end
		if ((v90.Fireball:IsReady() and v41) or ((7741 - 5486) >= (4505 - (478 + 490)))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), true) or ((2033 + 1804) < (2478 - (786 + 386)))) then
				return "fireball precombat 6";
			end
		end
	end
	local function v146()
		local v167 = 0 - 0;
		while true do
			if (((4329 - (1055 + 324)) == (4290 - (1093 + 247))) and ((1 + 0) == v167)) then
				if ((v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (2 + 13))) and not v136() and (v134() == (0 - 0)) and not v90.TemperedFlames:IsAvailable()) or ((16028 - 11305) < (9384 - 6086))) then
					if (((2854 - 1718) >= (55 + 99)) and v24(v90.DragonsBreath, not v15:IsInRange(38 - 28))) then
						return "dragons_breath active_talents 6";
					end
				end
				if ((v90.DragonsBreath:IsReady() and v39 and v90.AlexstraszasFury:IsAvailable() and v120 and v14:BuffDown(v90.HotStreakBuff) and (v14:BuffUp(v90.FeeltheBurnBuff) or (v10.CombatTime() > (51 - 36))) and not v136() and v90.TemperedFlames:IsAvailable()) or ((205 + 66) > (12142 - 7394))) then
					if (((5428 - (364 + 324)) >= (8640 - 5488)) and v24(v90.DragonsBreath, not v15:IsInRange(23 - 13))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if ((v167 == (0 + 0)) or ((10787 - 8209) >= (5429 - 2039))) then
				if (((124 - 83) <= (2929 - (1249 + 19))) and v90.LivingBomb:IsReady() and v43 and (v127 > (1 + 0)) and v120 and ((v110 > v90.LivingBomb:CooldownRemains()) or (v110 <= (0 - 0)))) then
					if (((1687 - (686 + 400)) < (2794 + 766)) and v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((464 - (73 + 156)) < (4 + 683)) and v90.Meteor:IsReady() and v44 and (v75 < v124) and ((v110 <= (811 - (721 + 90))) or (v14:BuffRemains(v90.CombustionBuff) > v90.Meteor:TravelTime()) or (not v90.SunKingsBlessing:IsAvailable() and (((1 + 44) < v110) or (v124 < v110))))) then
					if (((14769 - 10220) > (1623 - (224 + 246))) and v24(v92.MeteorCursor, not v15:IsInRange(64 - 24))) then
						return "meteor active_talents 4";
					end
				end
				v167 = 1 - 0;
			end
		end
	end
	local function v147()
		local v168 = 0 + 0;
		local v169;
		while true do
			if ((v168 == (0 + 0)) or ((3433 + 1241) < (9288 - 4616))) then
				v169 = v94.HandleDPSPotion(v14:BuffUp(v90.CombustionBuff));
				if (((12206 - 8538) < (5074 - (203 + 310))) and v169) then
					return v169;
				end
				v168 = 1994 - (1238 + 755);
			end
			if ((v168 == (1 + 0)) or ((1989 - (709 + 825)) == (6642 - 3037))) then
				if ((v82 and ((v85 and v35) or not v85) and (v75 < v124)) or ((3878 - 1215) == (4176 - (196 + 668)))) then
					local v232 = 0 - 0;
					while true do
						if (((8859 - 4582) <= (5308 - (171 + 662))) and (v232 == (93 - (4 + 89)))) then
							if (v90.BloodFury:IsCastable() or ((3049 - 2179) == (433 + 756))) then
								if (((6820 - 5267) <= (1229 + 1904)) and v24(v90.BloodFury)) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if ((v90.Berserking:IsCastable() and v119) or ((3723 - (35 + 1451)) >= (4964 - (28 + 1425)))) then
								if (v24(v90.Berserking) or ((3317 - (941 + 1052)) > (2896 + 124))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v232 = 1515 - (822 + 692);
						end
						if ((v232 == (1 - 0)) or ((1410 + 1582) == (2178 - (45 + 252)))) then
							if (((3074 + 32) > (526 + 1000)) and v90.Fireblood:IsCastable()) then
								if (((7357 - 4334) < (4303 - (114 + 319))) and v24(v90.Fireblood)) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (((204 - 61) > (94 - 20)) and v90.AncestralCall:IsCastable()) then
								if (((12 + 6) < (3145 - 1033)) and v24(v90.AncestralCall)) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
					end
				end
				if (((2298 - 1201) <= (3591 - (556 + 1407))) and v88 and v90.TimeWarp:IsReady() and v90.TemporalWarp:IsAvailable() and v14:BloodlustExhaustUp()) then
					if (((5836 - (741 + 465)) == (5095 - (170 + 295))) and v24(v90.TimeWarp, nil, nil, true)) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v168 = 2 + 0;
			end
			if (((3252 + 288) > (6605 - 3922)) and (v168 == (2 + 0))) then
				if (((3075 + 1719) >= (1855 + 1420)) and (v75 < v124)) then
					if (((2714 - (957 + 273)) == (397 + 1087)) and v83 and ((v35 and v84) or not v84)) then
						v32 = v141();
						if (((574 + 858) < (13546 - 9991)) and v32) then
							return v32;
						end
					end
				end
				break;
			end
		end
	end
	local function v148()
		if ((v90.LightsJudgment:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) or ((2806 - 1741) > (10928 - 7350))) then
			if (v24(v90.LightsJudgment, not v15:IsSpellInRange(v90.LightsJudgment)) or ((23743 - 18948) < (3187 - (389 + 1391)))) then
				return "lights_judgment combustion_phase 2";
			end
		end
		if (((1163 + 690) < (501 + 4312)) and v90.BagofTricks:IsCastable() and v82 and ((v85 and v35) or not v85) and (v75 < v124) and v120) then
			if (v24(v90.BagofTricks) or ((6422 - 3601) < (3382 - (783 + 168)))) then
				return "bag_of_tricks combustion_phase 4";
			end
		end
		if ((v90.LivingBomb:IsReady() and v34 and v43 and (v127 > (3 - 2)) and v120) or ((2827 + 47) < (2492 - (309 + 2)))) then
			if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((8257 - 5568) <= (1555 - (1090 + 122)))) then
				return "living_bomb combustion_phase 6";
			end
		end
		if ((v14:BuffRemains(v90.CombustionBuff) > v107) or (v124 < (7 + 13)) or ((6276 - 4407) == (1375 + 634))) then
			local v179 = 1118 - (628 + 490);
			while true do
				if (((0 + 0) == v179) or ((8779 - 5233) < (10611 - 8289))) then
					v32 = v147();
					if (v32 or ((2856 - (431 + 343)) == (9639 - 4866))) then
						return v32;
					end
					break;
				end
			end
		end
		if (((9384 - 6140) > (834 + 221)) and v90.PhoenixFlames:IsCastable() and v45 and v14:BuffDown(v90.CombustionBuff) and v14:HasTier(4 + 26, 1697 - (556 + 1139)) and not v90.PhoenixFlames:InFlight() and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((19 - (6 + 9)) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
			if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((607 + 2706) <= (911 + 867))) then
				return "phoenix_flames combustion_phase 8";
			end
		end
		v32 = v146();
		if (v32 or ((1590 - (28 + 141)) >= (815 + 1289))) then
			return v32;
		end
		if (((2236 - 424) <= (2302 + 947)) and v90.Combustion:IsReady() and v50 and ((v52 and v35) or not v52) and (v75 < v124) and (v140() == (1317 - (486 + 831))) and v120 and (v110 <= (0 - 0)) and ((v14:IsCasting(v90.Scorch) and (v90.Scorch:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Fireball) and (v90.Fireball:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Pyroblast) and (v90.Pyroblast:ExecuteRemains() < v105)) or (v14:IsCasting(v90.Flamestrike) and (v90.Flamestrike:ExecuteRemains() < v105)) or (v90.Meteor:InFlight() and (v90.Meteor:InFlightRemains() < v105)))) then
			if (((5713 - 4090) <= (370 + 1587)) and v24(v90.Combustion, not v15:IsInRange(126 - 86), nil, true)) then
				return "combustion combustion_phase 10";
			end
		end
		if (((5675 - (668 + 595)) == (3971 + 441)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v90.Combustion:CooldownRemains() < v90.Flamestrike:CastTime()) and (v126 >= v101)) then
			if (((353 + 1397) >= (2296 - 1454)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(330 - (23 + 267)), v14:BuffDown(v90.IceFloes))) then
				return "flamestrike combustion_phase 12";
			end
		end
		if (((6316 - (1129 + 815)) > (2237 - (371 + 16))) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v120 and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) then
			if (((1982 - (1326 + 424)) < (1554 - 733)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 14";
			end
		end
		if (((1892 - 1374) < (1020 - (88 + 30))) and v90.Fireball:IsReady() and v41 and v120 and (v90.Combustion:CooldownRemains() < v90.Fireball:CastTime()) and (v126 < (773 - (720 + 51))) and not v136()) then
			if (((6659 - 3665) > (2634 - (421 + 1355))) and v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes))) then
				return "fireball combustion_phase 16";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and v120 and (v90.Combustion:CooldownRemains() < v90.Scorch:CastTime())) or ((6194 - 2439) <= (450 + 465))) then
			if (((5029 - (286 + 797)) > (13682 - 9939)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
				return "scorch combustion_phase 18";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (not v136() or v14:IsCasting(v90.Scorch) or (v15:DebuffRemains(v90.ImprovedScorchDebuff) > ((6 - 2) * v125))) and (v14:BuffDown(v90.FuryoftheSunKingBuff) or v14:IsCasting(v90.Pyroblast)) and v119 and v14:BuffDown(v90.HyperthermiaBuff) and v14:BuffDown(v90.HotStreakBuff) and ((v140() + (v28(v14:BuffUp(v90.HeatingUpBuff)) * v28(v14:GCDRemains() > (439 - (397 + 42))))) < (1 + 1))) or ((2135 - (24 + 776)) >= (5092 - 1786))) then
			if (((5629 - (222 + 563)) > (4963 - 2710)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast combustion_phase 20";
			end
		end
		if (((326 + 126) == (642 - (23 + 167))) and v34 and v90.Flamestrike:IsReady() and v42 and ((v14:BuffUp(v90.HotStreakBuff) and (v126 >= v100)) or (v14:BuffUp(v90.HyperthermiaBuff) and (v126 >= (v100 - v28(v90.Hyperthermia:IsAvailable())))))) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(1838 - (690 + 1108)), v14:BuffDown(v90.IceFloes)) or ((1645 + 2912) < (1722 + 365))) then
				return "flamestrike combustion_phase 22";
			end
		end
		if (((4722 - (40 + 808)) == (638 + 3236)) and v90.Pyroblast:IsReady() and v46 and (v14:BuffUp(v90.HyperthermiaBuff))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((7410 - 5472) > (4717 + 218))) then
				return "pyroblast combustion_phase 24";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:BuffUp(v90.HotStreakBuff) and v119) or ((2251 + 2004) < (1878 + 1545))) then
			if (((2025 - (47 + 524)) <= (1617 + 874)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 26";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and v14:PrevGCDP(2 - 1, v90.Scorch) and v14:BuffUp(v90.HeatingUpBuff) and (v126 < v100) and v119) or ((6215 - 2058) <= (6392 - 3589))) then
			if (((6579 - (1165 + 561)) >= (89 + 2893)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
				return "pyroblast combustion_phase 28";
			end
		end
		if (((12803 - 8669) > (1281 + 2076)) and v90.ShiftingPower:IsReady() and v51 and ((v53 and v35) or not v53) and (v75 < v124) and v119 and (v90.FireBlast:Charges() == (479 - (341 + 138))) and ((v90.PhoenixFlames:Charges() < v90.PhoenixFlames:MaxCharges()) or v90.AlexstraszasFury:IsAvailable()) and (v104 <= v126)) then
			if (v24(v90.ShiftingPower, not v15:IsInRange(11 + 29)) or ((7051 - 3634) < (2860 - (89 + 237)))) then
				return "shifting_power combustion_phase 30";
			end
		end
		if ((v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Flamestrike:CastTime()) and (v126 >= v101)) or ((8756 - 6034) <= (344 - 180))) then
			if (v24(v92.FlamestrikeCursor, not v15:IsInRange(921 - (581 + 300)), v14:BuffDown(v90.IceFloes)) or ((3628 - (855 + 365)) < (5009 - 2900))) then
				return "flamestrike combustion_phase 32";
			end
		end
		if ((v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and v14:BuffUp(v90.FuryoftheSunKingBuff) and (v14:BuffRemains(v90.FuryoftheSunKingBuff) > v90.Pyroblast:CastTime())) or ((11 + 22) == (2690 - (1030 + 205)))) then
			if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((416 + 27) >= (3736 + 279))) then
				return "pyroblast combustion_phase 34";
			end
		end
		if (((3668 - (156 + 130)) > (377 - 211)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((6 - 2) * v125)) and (v128 < v100)) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((573 - 293) == (807 + 2252))) then
				return "scorch combustion_phase 36";
			end
		end
		if (((1097 + 784) > (1362 - (10 + 59))) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(9 + 21, 9 - 7) and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (1165 - (671 + 492))) and ((v15:DebuffRemains(v90.CharringEmbersDebuff) < ((4 + 0) * v125)) or (v14:BuffStack(v90.FlamesFuryBuff) > (1216 - (369 + 846))) or v14:BuffUp(v90.FlamesFuryBuff))) then
			if (((624 + 1733) == (2012 + 345)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
				return "phoenix_flames combustion_phase 38";
			end
		end
		if (((2068 - (1036 + 909)) == (98 + 25)) and v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime()) and v14:BuffUp(v90.FlameAccelerantBuff)) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((1772 - 716) >= (3595 - (11 + 192)))) then
				return "fireball combustion_phase 40";
			end
		end
		if ((v90.PhoenixFlames:IsCastable() and v45 and not v14:HasTier(16 + 14, 177 - (135 + 40)) and not v90.AlexstraszasFury:IsAvailable() and (v90.PhoenixFlames:TravelTime() < v14:BuffRemains(v90.CombustionBuff)) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) < (4 - 2))) or ((652 + 429) < (2368 - 1293))) then
			if (v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false) or ((1571 - 522) >= (4608 - (50 + 126)))) then
				return "phoenix_flames combustion_phase 42";
			end
		end
		if ((v90.Scorch:IsReady() and v47 and (v14:BuffRemains(v90.CombustionBuff) > v90.Scorch:CastTime()) and (v90.Scorch:CastTime() >= v125)) or ((13276 - 8508) <= (188 + 658))) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((4771 - (1233 + 180)) <= (2389 - (522 + 447)))) then
				return "scorch combustion_phase 44";
			end
		end
		if ((v90.Fireball:IsReady() and v41 and (v14:BuffRemains(v90.CombustionBuff) > v90.Fireball:CastTime())) or ((5160 - (107 + 1314)) <= (1395 + 1610))) then
			if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((5054 - 3395) >= (907 + 1227))) then
				return "fireball combustion_phase 46";
			end
		end
		if ((v90.LivingBomb:IsReady() and v43 and (v14:BuffRemains(v90.CombustionBuff) < v125) and (v127 > (1 - 0))) or ((12898 - 9638) < (4265 - (716 + 1194)))) then
			if (v24(v90.LivingBomb, not v15:IsSpellInRange(v90.LivingBomb), v14:BuffDown(v90.IceFloes)) or ((12 + 657) == (453 + 3770))) then
				return "living_bomb combustion_phase 48";
			end
		end
	end
	local function v149()
		local v170 = 503 - (74 + 429);
		while true do
			if ((v170 == (3 - 1)) or ((839 + 853) < (1345 - 757))) then
				if ((v90.SunKingsBlessing:IsAvailable() and v133() and v14:BuffDown(v90.FuryoftheSunKingBuff)) or ((3394 + 1403) < (11255 - 7604))) then
					v110 = v30((v117 - v14:BuffStack(v90.SunKingsBlessingBuff)) * (7 - 4) * v125, v110);
				end
				v110 = v30(v14:BuffRemains(v90.CombustionBuff), v110);
				v170 = 436 - (279 + 154);
			end
			if ((v170 == (779 - (454 + 324))) or ((3287 + 890) > (4867 - (12 + 5)))) then
				v110 = v115;
				if ((v90.Firestarter:IsAvailable() and not v97) or ((216 + 184) > (2830 - 1719))) then
					v110 = v30(v134(), v110);
				end
				v170 = 1 + 1;
			end
			if (((4144 - (277 + 816)) > (4294 - 3289)) and (v170 == (1183 - (1058 + 125)))) then
				v115 = v90.Combustion:CooldownRemains() * v111;
				v116 = ((v90.Fireball:CastTime() * v28(v126 < v100)) + (v90.Flamestrike:CastTime() * v28(v126 >= v100))) - v105;
				v170 = 1 + 0;
			end
			if (((4668 - (815 + 160)) <= (18801 - 14419)) and (v170 == (7 - 4))) then
				if (((v115 + ((29 + 91) * ((2 - 1) - (((1898.4 - (41 + 1857)) + ((1893.2 - (1222 + 671)) * v28(v90.Firestarter:IsAvailable()))) * v28(v90.Kindling:IsAvailable()))))) <= v110) or (v110 > (v124 - (51 - 31))) or ((4717 - 1435) > (5282 - (229 + 953)))) then
					v110 = v115;
				end
				break;
			end
		end
	end
	local function v150()
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and v14:BuffDown(v90.HotStreakBuff) and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1775 - (1111 + 663))) and (v90.ShiftingPower:CooldownUp() or (v90.FireBlast:Charges() > (1580 - (874 + 705))) or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) or ((2443 + 1137) < (5911 - 3067))) then
			if (((3 + 86) < (5169 - (642 + 37))) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 2";
			end
		end
		if ((v90.FireBlast:IsReady() and v40 and not v138() and not v114 and ((v28(v14:BuffUp(v90.HeatingUpBuff)) + v140()) == (1 + 0)) and v90.ShiftingPower:CooldownUp() and (not v14:HasTier(5 + 25, 4 - 2) or (v15:DebuffRemains(v90.CharringEmbersDebuff) > ((456 - (233 + 221)) * v125)))) or ((11522 - 6539) < (1592 + 216))) then
			if (((5370 - (718 + 823)) > (2372 + 1397)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast firestarter_fire_blasts 4";
			end
		end
	end
	local function v151()
		local v171 = 805 - (266 + 539);
		while true do
			if (((4204 - 2719) <= (4129 - (636 + 589))) and (v171 == (6 - 3))) then
				if (((8804 - 4535) == (3384 + 885)) and v90.PhoenixFlames:IsCastable() and v45 and v14:HasTier(11 + 19, 1017 - (657 + 358)) and (v15:DebuffRemains(v90.CharringEmbersDebuff) < ((4 - 2) * v125)) and v14:BuffDown(v90.HotStreakBuff)) then
					if (((881 - 494) <= (3969 - (1151 + 36))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffStack(v90.ImprovedScorchDebuff) < v118)) or ((1834 + 65) <= (242 + 675))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((12877 - 8565) <= (2708 - (1552 + 280)))) then
						return "scorch standard_rotation 22";
					end
				end
				if (((3066 - (64 + 770)) <= (1763 + 833)) and v90.PhoenixFlames:IsCastable() and v45 and not v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and not v113 and v14:BuffUp(v90.FlamesFuryBuff)) then
					if (((4755 - 2660) < (655 + 3031)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v171 = 1247 - (157 + 1086);
			end
			if ((v171 == (0 - 0)) or ((6985 - 5390) >= (6862 - 2388))) then
				if ((v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v98) and v138()) or ((6303 - 1684) < (3701 - (599 + 220)))) then
					if (v24(v92.FlamestrikeCursor, not v15:IsInRange(79 - 39), v14:BuffDown(v90.IceFloes)) or ((2225 - (1813 + 118)) >= (3532 + 1299))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((3246 - (841 + 376)) <= (4321 - 1237)) and v90.Pyroblast:IsReady() and v46 and (v138())) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), true) or ((474 + 1563) == (6605 - 4185))) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((5317 - (464 + 395)) > (10019 - 6115)) and v34 and v90.Flamestrike:IsReady() and v42 and not v14:IsCasting(v90.Flamestrike) and (v126 >= v101) and v14:BuffUp(v90.FuryoftheSunKingBuff)) then
					if (((210 + 226) >= (960 - (467 + 370))) and v24(v92.FlamestrikeCursor, not v15:IsInRange(82 - 42), v14:BuffDown(v90.IceFloes))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v171 = 1 + 0;
			end
			if (((1714 - 1214) < (284 + 1532)) and (v171 == (13 - 7))) then
				if (((4094 - (150 + 370)) == (4856 - (74 + 1208))) and v34 and v90.Flamestrike:IsReady() and v42 and (v126 >= v99)) then
					if (((543 - 322) < (1849 - 1459)) and v24(v92.FlamestrikeCursor, not v15:IsInRange(29 + 11))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v90.Pyroblast:IsReady() and v46 and v90.TemperedFlames:IsAvailable() and v14:BuffDown(v90.FlameAccelerantBuff)) or ((2603 - (14 + 376)) <= (2464 - 1043))) then
					if (((1979 + 1079) < (4270 + 590)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 35";
					end
				end
				if ((v90.Fireball:IsReady() and v41 and not v138()) or ((1237 + 59) >= (13027 - 8581))) then
					if (v24(v90.Fireball, not v15:IsSpellInRange(v90.Fireball), v14:BuffDown(v90.IceFloes)) or ((1048 + 345) > (4567 - (23 + 55)))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if ((v171 == (9 - 5)) or ((2953 + 1471) < (25 + 2))) then
				if ((v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and v14:BuffDown(v90.HotStreakBuff) and (v140() == (0 - 0)) and ((not v113 and v14:BuffUp(v90.FlamesFuryBuff)) or (v90.PhoenixFlames:ChargesFractional() > (1.5 + 1)) or ((v90.PhoenixFlames:ChargesFractional() > (902.5 - (652 + 249))) and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((7 - 4) * v125)))))) or ((3865 - (708 + 1160)) > (10355 - 6540))) then
					if (((6317 - 2852) > (1940 - (10 + 17))) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v32 = v146();
				if (((165 + 568) < (3551 - (1400 + 332))) and v32) then
					return v32;
				end
				v171 = 9 - 4;
			end
			if ((v171 == (1909 - (242 + 1666))) or ((1881 + 2514) == (1743 + 3012))) then
				if ((v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < (v90.Pyroblast:CastTime() + ((5 + 0) * v125))) and v14:BuffUp(v90.FuryoftheSunKingBuff) and not v14:IsCasting(v90.Scorch)) or ((4733 - (850 + 90)) < (4148 - 1779))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((5474 - (360 + 1030)) == (235 + 30))) then
						return "scorch standard_rotation 13";
					end
				end
				if (((12300 - 7942) == (5995 - 1637)) and v90.Pyroblast:IsReady() and v46 and not v14:IsCasting(v90.Pyroblast) and (v14:BuffUp(v90.FuryoftheSunKingBuff))) then
					if (v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff)) or ((4799 - (909 + 752)) < (2216 - (109 + 1114)))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if (((6096 - 2766) > (905 + 1418)) and v90.FireBlast:IsReady() and v40 and not v138() and not v133() and not v114 and v14:BuffDown(v90.FuryoftheSunKingBuff) and ((((v14:IsCasting(v90.Fireball) and ((v90.Fireball:ExecuteRemains() < (242.5 - (6 + 236))) or not v90.Hyperthermia:IsAvailable())) or (v14:IsCasting(v90.Pyroblast) and ((v90.Pyroblast:ExecuteRemains() < (0.5 + 0)) or not v90.Hyperthermia:IsAvailable()))) and v14:BuffUp(v90.HeatingUpBuff)) or (v135() and (not v136() or (v15:DebuffStack(v90.ImprovedScorchDebuff) == v118) or (v90.FireBlast:FullRechargeTime() < (3 + 0))) and ((v14:BuffUp(v90.HeatingUpBuff) and not v14:IsCasting(v90.Scorch)) or (v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HeatingUpBuff) and v14:IsCasting(v90.Scorch) and (v140() == (0 - 0))))))) then
					if (v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
						return "fire_blast standard_rotation 16";
					end
				end
				v171 = 1 + 1;
			end
			if ((v171 == (691 - (579 + 110))) or ((73 + 843) == (2362 + 309))) then
				if (((145 + 127) == (679 - (174 + 233))) and v90.Pyroblast:IsReady() and v46 and (v14:IsCasting(v90.Scorch) or v14:PrevGCDP(2 - 1, v90.Scorch)) and v14:BuffUp(v90.HeatingUpBuff) and v135() and (v126 < v98)) then
					if (((7457 - 3208) <= (2152 + 2687)) and v24(v90.Pyroblast, not v15:IsSpellInRange(v90.Pyroblast), v14:BuffDown(v90.IceFloes) and v14:BuffDown(v90.HotStreakBuff) and v14:BuffDown(v90.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((3951 - (663 + 511)) < (2855 + 345)) and v90.Scorch:IsReady() and v47 and v136() and (v15:DebuffRemains(v90.ImprovedScorchDebuff) < ((1 + 3) * v125))) then
					if (((292 - 197) < (1186 + 771)) and v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false)) then
						return "scorch standard_rotation 19";
					end
				end
				if (((1944 - 1118) < (4156 - 2439)) and v90.PhoenixFlames:IsCastable() and v45 and v90.AlexstraszasFury:IsAvailable() and (not v90.FeeltheBurn:IsAvailable() or (v14:BuffRemains(v90.FeeltheBurnBuff) < ((1 + 1) * v125)))) then
					if (((2775 - 1349) >= (788 + 317)) and v24(v90.PhoenixFlames, not v15:IsSpellInRange(v90.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				v171 = 1 + 2;
			end
			if (((3476 - (478 + 244)) <= (3896 - (440 + 77))) and (v171 == (3 + 2))) then
				if ((v34 and v90.DragonsBreath:IsReady() and v39 and (v128 > (3 - 2)) and v90.AlexstraszasFury:IsAvailable()) or ((5483 - (655 + 901)) == (263 + 1150))) then
					if (v24(v90.DragonsBreath, not v15:IsInRange(8 + 2)) or ((780 + 374) <= (3174 - 2386))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				if ((v90.Scorch:IsReady() and v47 and (v135())) or ((3088 - (695 + 750)) > (11538 - 8159))) then
					if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((4325 - 1522) > (18294 - 13745))) then
						return "scorch standard_rotation 30";
					end
				end
				if ((v34 and v90.ArcaneExplosion:IsReady() and v37 and (v129 >= v102) and (v14:ManaPercentageP() >= v103)) or ((571 - (285 + 66)) >= (7044 - 4022))) then
					if (((4132 - (682 + 628)) == (455 + 2367)) and v24(v90.ArcaneExplosion, not v15:IsInRange(307 - (176 + 123)))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				v171 = 3 + 3;
			end
		end
	end
	local function v152()
		if (not v96 or ((770 + 291) == (2126 - (239 + 30)))) then
			v149();
		end
		if (((751 + 2009) > (1311 + 53)) and v35 and v88 and v90.TimeWarp:IsReady() and v14:BloodlustExhaustUp() and v90.TemporalWarp:IsAvailable() and (v133() or (v124 < (70 - 30)))) then
			if (v24(v90.TimeWarp, not v15:IsInRange(124 - 84)) or ((5217 - (306 + 9)) <= (12545 - 8950))) then
				return "time_warp combustion_cooldowns 12";
			end
		end
		if ((v75 < v124) or ((670 + 3182) == (180 + 113))) then
			if ((v83 and ((v35 and v84) or not v84)) or ((751 + 808) == (13119 - 8531))) then
				local v231 = 1375 - (1140 + 235);
				while true do
					if ((v231 == (0 + 0)) or ((4112 + 372) == (203 + 585))) then
						v32 = v141();
						if (((4620 - (33 + 19)) >= (1411 + 2496)) and v32) then
							return v32;
						end
						break;
					end
				end
			end
		end
		v112 = v110 > v90.ShiftingPower:CooldownRemains();
		v114 = v120 and (((v90.FireBlast:ChargesFractional() + ((v110 + (v137() * v28(v112))) / v90.FireBlast:Cooldown())) - (2 - 1)) < ((v90.FireBlast:MaxCharges() + (v106 / v90.FireBlast:Cooldown())) - (((6 + 6) / v90.FireBlast:Cooldown()) % (1 - 0)))) and (v110 < v124);
		if (((1169 + 77) < (4159 - (586 + 103))) and not v96 and ((v110 <= (0 + 0)) or v119 or ((v110 < v116) and (v90.Combustion:CooldownRemains() < v116)))) then
			v32 = v148();
			if (((12523 - 8455) >= (2460 - (1309 + 179))) and v32) then
				return v32;
			end
		end
		if (((889 - 396) < (1695 + 2198)) and not v114 and v90.SunKingsBlessing:IsAvailable()) then
			v114 = v135() and (v90.FireBlast:FullRechargeTime() > ((7 - 4) * v125));
		end
		if ((v90.ShiftingPower:IsReady() and ((v35 and v53) or not v53) and v51 and (v75 < v124) and v120 and ((v90.FireBlast:Charges() == (0 + 0)) or v114) and (not v136() or ((v15:DebuffRemains(v90.ImprovedScorchDebuff) > (v90.ShiftingPower:CastTime() + v90.Scorch:CastTime())) and v14:BuffDown(v90.FuryoftheSunKingBuff))) and v14:BuffDown(v90.HotStreakBuff) and v112) or ((3129 - 1656) >= (6639 - 3307))) then
			if (v24(v90.ShiftingPower, not v15:IsInRange(649 - (295 + 314)), true) or ((9949 - 5898) <= (3119 - (1300 + 662)))) then
				return "shifting_power main 12";
			end
		end
		if (((1896 - 1292) < (4636 - (1178 + 577))) and (v126 < v100)) then
			v113 = (v90.SunKingsBlessing:IsAvailable() or (((v110 + 4 + 3) < ((v90.PhoenixFlames:FullRechargeTime() + v90.PhoenixFlames:Cooldown()) - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
		end
		if ((v126 >= v100) or ((2660 - 1760) == (4782 - (851 + 554)))) then
			v113 = (v90.SunKingsBlessing:IsAvailable() or ((v110 < (v90.PhoenixFlames:FullRechargeTime() - (v137() * v28(v112)))) and (v110 < v124))) and not v90.AlexstraszasFury:IsAvailable();
		end
		if (((3944 + 515) > (1638 - 1047)) and v90.FireBlast:IsReady() and v40 and not v138() and not v114 and (v110 > (0 - 0)) and (v126 >= v99) and not v133() and v14:BuffDown(v90.HotStreakBuff) and ((v14:BuffUp(v90.HeatingUpBuff) and (v90.Flamestrike:ExecuteRemains() < (302.5 - (115 + 187)))) or (v90.FireBlast:ChargesFractional() >= (2 + 0)))) then
			if (((3217 + 181) >= (9437 - 7042)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast main 14";
			end
		end
		if ((v120 and v133() and (v110 > (1161 - (160 + 1001)))) or ((1910 + 273) >= (1949 + 875))) then
			local v180 = 0 - 0;
			while true do
				if (((2294 - (237 + 121)) == (2833 - (525 + 372))) and (v180 == (0 - 0))) then
					v32 = v150();
					if (v32 or ((15875 - 11043) < (4455 - (96 + 46)))) then
						return v32;
					end
					break;
				end
			end
		end
		if (((4865 - (643 + 134)) > (1399 + 2475)) and v90.FireBlast:IsReady() and v40 and not v138() and v14:IsCasting(v90.ShiftingPower) and (v90.FireBlast:FullRechargeTime() < v122)) then
			if (((10386 - 6054) == (16083 - 11751)) and v24(v90.FireBlast, not v15:IsSpellInRange(v90.FireBlast), false, true)) then
				return "fire_blast main 16";
			end
		end
		if (((3836 + 163) >= (5691 - 2791)) and (v110 > (0 - 0)) and v120) then
			local v181 = 719 - (316 + 403);
			while true do
				if ((v181 == (0 + 0)) or ((6942 - 4417) > (1469 + 2595))) then
					v32 = v151();
					if (((11007 - 6636) == (3098 + 1273)) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if ((v90.IceNova:IsCastable() and not v135()) or ((86 + 180) > (17276 - 12290))) then
			if (((9508 - 7517) >= (1921 - 996)) and v24(v90.IceNova, not v15:IsSpellInRange(v90.IceNova))) then
				return "ice_nova main 18";
			end
		end
		if (((27 + 428) < (4041 - 1988)) and v90.Scorch:IsReady() and v47) then
			if (v24(v90.Scorch, not v15:IsSpellInRange(v90.Scorch), false) or ((41 + 785) == (14272 - 9421))) then
				return "scorch main 20";
			end
		end
	end
	local function v153()
		local v172 = 17 - (12 + 5);
		while true do
			if (((710 - 527) == (389 - 206)) and (v172 == (10 - 5))) then
				v67 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v86 = EpicSettings.Settings['mirrorImageBeforePull'];
				v87 = EpicSettings.Settings['useSpellStealTarget'];
				v88 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v89 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((236 + 923) <= (3761 - (1656 + 317))) and (v172 == (1 + 0))) then
				v43 = EpicSettings.Settings['useLivingBomb'];
				v44 = EpicSettings.Settings['useMeteor'];
				v45 = EpicSettings.Settings['usePhoenixFlames'];
				v46 = EpicSettings.Settings['usePyroblast'];
				v47 = EpicSettings.Settings['useScorch'];
				v48 = EpicSettings.Settings['useCounterspell'];
				v172 = 2 + 0;
			end
			if ((v172 == (0 - 0)) or ((17259 - 13752) > (4672 - (5 + 349)))) then
				v37 = EpicSettings.Settings['useArcaneExplosion'];
				v38 = EpicSettings.Settings['useArcaneIntellect'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFireball'];
				v42 = EpicSettings.Settings['useFlamestrike'];
				v172 = 4 - 3;
			end
			if ((v172 == (1275 - (266 + 1005))) or ((2027 + 1048) <= (10116 - 7151))) then
				v61 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v62 = EpicSettings.Settings['blazingBarrierHP'] or (1696 - (561 + 1135));
				v63 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v64 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v65 = EpicSettings.Settings['iceColdHP'] or (1066 - (507 + 559));
				v66 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v172 = 15 - 10;
			end
			if (((1753 - (212 + 176)) <= (2916 - (250 + 655))) and (v172 == (8 - 5))) then
				v55 = EpicSettings.Settings['useBlazingBarrier'];
				v56 = EpicSettings.Settings['useGreaterInvisibility'];
				v57 = EpicSettings.Settings['useIceBlock'];
				v58 = EpicSettings.Settings['useIceCold'];
				v60 = EpicSettings.Settings['useMassBarrier'];
				v59 = EpicSettings.Settings['useMirrorImage'];
				v172 = 6 - 2;
			end
			if ((v172 == (2 - 0)) or ((4732 - (1869 + 87)) > (12399 - 8824))) then
				v49 = EpicSettings.Settings['useBlastWave'];
				v50 = EpicSettings.Settings['useCombustion'];
				v51 = EpicSettings.Settings['useShiftingPower'];
				v52 = EpicSettings.Settings['combustionWithCD'];
				v53 = EpicSettings.Settings['shiftingPowerWithCD'];
				v54 = EpicSettings.Settings['useAlterTime'];
				v172 = 1904 - (484 + 1417);
			end
		end
	end
	local function v154()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (6 - 2)) or ((3327 - (48 + 725)) == (7847 - 3043))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v173 = 13 - 8;
			end
			if (((722 + 1855) == (752 + 1825)) and (v173 == (854 - (152 + 701)))) then
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v69 = EpicSettings.Settings['DispelDebuffs'];
				v173 = 1313 - (430 + 881);
			end
			if ((v173 == (2 + 1)) or ((901 - (557 + 338)) >= (559 + 1330))) then
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v85 = EpicSettings.Settings['racialsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v173 = 10 - 6;
			end
			if (((1771 - 1265) <= (5026 - 3134)) and (v173 == (4 - 2))) then
				v68 = EpicSettings.Settings['DispelBuffs'];
				v83 = EpicSettings.Settings['useTrinkets'];
				v82 = EpicSettings.Settings['useRacials'];
				v173 = 804 - (499 + 302);
			end
			if (((871 - (39 + 827)) == v173) or ((5542 - 3534) > (4953 - 2735))) then
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v70 = EpicSettings.Settings['handleAfflicted'];
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1505 - 1126) <= (6366 - 2219)) and (v173 == (0 + 0))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v76 = EpicSettings.Settings['useWeapon'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v173 = 1 + 0;
			end
		end
	end
	local function v155()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (108 - (103 + 1))) or ((5068 - (475 + 79)) <= (2180 - 1171))) then
				if ((v14:AffectingCombat() and v94.TargetIsValid()) or ((11187 - 7691) == (155 + 1037))) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (1505 - (1395 + 108))) or ((605 - 397) == (4163 - (7 + 1197)))) then
							if (((1865 + 2412) >= (459 + 854)) and v14:IsMoving() and v90.IceFloes:IsReady() and not v14:BuffUp(v90.IceFloes)) then
								if (((2906 - (27 + 292)) < (9300 - 6126)) and v24(v90.IceFloes)) then
									return "ice_floes movement";
								end
							end
							v32 = v152();
							if (v32 or ((5254 - 1134) <= (9217 - 7019))) then
								return v32;
							end
							break;
						end
						if ((v233 == (0 - 0)) or ((3039 - 1443) == (997 - (43 + 96)))) then
							if (((13134 - 9914) == (7280 - 4060)) and v35 and v76 and (v91.Dreambinder:IsEquippedAndReady() or v91.Iridal:IsEquippedAndReady())) then
								if (v24(v92.UseWeapon, nil) or ((1164 + 238) > (1023 + 2597))) then
									return "Using Weapon Macro";
								end
							end
							if (((5087 - 2513) == (987 + 1587)) and v69 and v36 and v90.RemoveCurse:IsAvailable()) then
								local v236 = 0 - 0;
								while true do
									if (((567 + 1231) < (203 + 2554)) and (v236 == (1751 - (1414 + 337)))) then
										if (v16 or ((2317 - (1642 + 298)) > (6788 - 4184))) then
											local v241 = 0 - 0;
											while true do
												if (((1685 - 1117) < (300 + 611)) and ((0 + 0) == v241)) then
													v32 = v143();
													if (((4257 - (357 + 615)) < (2968 + 1260)) and v32) then
														return v32;
													end
													break;
												end
											end
										end
										if (((9608 - 5692) > (2852 + 476)) and v18 and v18:Exists() and not v14:CanAttack(v18) and v94.UnitHasCurseDebuff(v18)) then
											if (((5357 - 2857) < (3071 + 768)) and v90.RemoveCurse:IsReady()) then
												if (((35 + 472) == (319 + 188)) and v24(v92.RemoveCurseMouseover)) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							v32 = v144();
							if (((1541 - (384 + 917)) <= (3862 - (128 + 569))) and v32) then
								return v32;
							end
							v233 = 1544 - (1407 + 136);
						end
						if (((2721 - (687 + 1200)) >= (2515 - (556 + 1154))) and (v233 == (3 - 2))) then
							if (v70 or ((3907 - (9 + 86)) < (2737 - (275 + 146)))) then
								if (v89 or ((432 + 2220) <= (1597 - (29 + 35)))) then
									local v240 = 0 - 0;
									while true do
										if (((0 - 0) == v240) or ((15883 - 12285) < (951 + 509))) then
											v32 = v94.HandleAfflicted(v90.RemoveCurse, v92.RemoveCurseMouseover, 1042 - (53 + 959));
											if (v32 or ((4524 - (312 + 96)) < (2068 - 876))) then
												return v32;
											end
											break;
										end
									end
								end
							end
							if (v71 or ((3662 - (147 + 138)) <= (1802 - (813 + 86)))) then
								local v237 = 0 + 0;
								while true do
									if (((7365 - 3389) >= (931 - (18 + 474))) and (v237 == (0 + 0))) then
										v32 = v94.HandleIncorporeal(v90.Polymorph, v92.PolymorphMouseover, 97 - 67);
										if (((4838 - (860 + 226)) == (4055 - (121 + 182))) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if (((499 + 3547) > (3935 - (988 + 252))) and v90.Spellsteal:IsAvailable() and v87 and v90.Spellsteal:IsReady() and v36 and v68 and not v14:IsCasting() and not v14:IsChanneling() and v94.UnitHasMagicBuff(v15)) then
								if (v24(v90.Spellsteal, not v15:IsSpellInRange(v90.Spellsteal)) or ((401 + 3144) == (1002 + 2195))) then
									return "spellsteal damage";
								end
							end
							if (((4364 - (49 + 1921)) > (1263 - (223 + 667))) and (v14:IsCasting(v90.Pyroblast) or v14:IsChanneling(v90.Pyroblast) or v14:IsCasting(v90.Flamestrike) or v14:IsChanneling(v90.Flamestrike)) and v14:BuffUp(v90.HotStreakBuff)) then
								if (((4207 - (51 + 1)) <= (7283 - 3051)) and v24(v92.StopCasting, not v15:IsSpellInRange(v90.Pyroblast), false, true)) then
									return "Stop Casting";
								end
							end
							v233 = 3 - 1;
						end
					end
				end
				break;
			end
			if ((v174 == (1127 - (146 + 979))) or ((1011 + 2570) == (4078 - (311 + 294)))) then
				if (((13929 - 8934) > (1419 + 1929)) and v14:IsDeadOrGhost()) then
					return v32;
				end
				v131 = v15:GetEnemiesInSplashRange(1448 - (496 + 947));
				v130 = v14:GetEnemiesInRange(1398 - (1233 + 125));
				v174 = 2 + 1;
			end
			if ((v174 == (1 + 0)) or ((144 + 610) > (5369 - (963 + 682)))) then
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v174 = 2 + 0;
			end
			if (((1721 - (504 + 1000)) >= (39 + 18)) and (v174 == (3 + 0))) then
				if (v34 or ((196 + 1874) >= (5952 - 1915))) then
					local v234 = 0 + 0;
					while true do
						if (((1574 + 1131) == (2887 - (156 + 26))) and ((1 + 0) == v234)) then
							v128 = v30(v15:GetEnemiesInSplashRangeCount(7 - 2), #v130);
							v129 = #v130;
							break;
						end
						if (((225 - (149 + 15)) == (1021 - (890 + 70))) and (v234 == (117 - (39 + 78)))) then
							v126 = v30(v15:GetEnemiesInSplashRangeCount(487 - (14 + 468)), #v130);
							v127 = v30(v15:GetEnemiesInSplashRangeCount(10 - 5), #v130);
							v234 = 2 - 1;
						end
					end
				else
					v126 = 1 + 0;
					v127 = 1 + 0;
					v128 = 1 + 0;
					v129 = 1 + 0;
				end
				if (v94.TargetIsValid() or v14:AffectingCombat() or ((184 + 515) >= (2480 - 1184))) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (3 - 2)) or ((46 + 1737) >= (3667 - (12 + 39)))) then
							v124 = v123;
							if ((v124 == (10337 + 774)) or ((12111 - 8198) > (16123 - 11596))) then
								v124 = v10.FightRemains(v130, false);
							end
							v235 = 1 + 1;
						end
						if (((2304 + 2072) > (2071 - 1254)) and (v235 == (3 + 1))) then
							v119 = v14:BuffUp(v90.CombustionBuff);
							v120 = not v119;
							break;
						end
						if (((23492 - 18631) > (2534 - (1596 + 114))) and ((0 - 0) == v235)) then
							if (v14:AffectingCombat() or v69 or ((2096 - (164 + 549)) >= (3569 - (1059 + 379)))) then
								local v238 = 0 - 0;
								local v239;
								while true do
									if ((v238 == (0 + 0)) or ((317 + 1559) >= (2933 - (145 + 247)))) then
										v239 = v69 and v90.RemoveCurse:IsReady() and v36;
										v32 = v94.FocusUnit(v239, nil, 17 + 3, nil, 10 + 10, v90.ArcaneIntellect);
										v238 = 2 - 1;
									end
									if (((342 + 1440) <= (3250 + 522)) and (v238 == (1 - 0))) then
										if (v32 or ((5420 - (254 + 466)) < (1373 - (544 + 16)))) then
											return v32;
										end
										break;
									end
								end
							end
							v123 = v10.BossFightRemains(nil, true);
							v235 = 2 - 1;
						end
						if (((3827 - (294 + 334)) < (4303 - (236 + 17))) and (v235 == (1 + 1))) then
							v132 = v139(v130);
							v96 = not v35;
							v235 = 3 + 0;
						end
						if ((v235 == (10 - 7)) or ((23440 - 18489) < (2281 + 2149))) then
							if (((80 + 16) == (890 - (413 + 381))) and v96) then
								v110 = 4209 + 95790;
							end
							v125 = v14:GCD();
							v235 = 8 - 4;
						end
					end
				end
				if ((not v14:AffectingCombat() and v33) or ((7114 - 4375) > (5978 - (582 + 1388)))) then
					v32 = v145();
					if (v32 or ((38 - 15) == (812 + 322))) then
						return v32;
					end
				end
				v174 = 368 - (326 + 38);
			end
			if (((0 - 0) == v174) or ((3843 - 1150) >= (4731 - (47 + 573)))) then
				v153();
				v154();
				v33 = EpicSettings.Toggles['ooc'];
				v174 = 1 + 0;
			end
		end
	end
	local function v156()
		local v175 = 0 - 0;
		while true do
			if ((v175 == (0 - 0)) or ((5980 - (1269 + 395)) <= (2638 - (76 + 416)))) then
				v95();
				v22.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(506 - (319 + 124), v155, v156);
end;
return v0["Epix_Mage_Fire.lua"]();

