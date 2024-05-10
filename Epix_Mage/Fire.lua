local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3428 - (215 + 1059)) >= (4487 - (171 + 991)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Fire.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.Pet;
	local v17 = v11.Mouseover;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.PressCursor;
	local v25 = v21.Macro;
	local v26 = v21.Bind;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = math.ceil;
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
	local v89 = v18.Mage.Fire;
	local v90 = v20.Mage.Fire;
	local v91 = v25.Mage.Fire;
	local v92 = {};
	local v93 = v21.Commons.Everyone;
	local function v94()
		if (v89.RemoveCurse:IsAvailable() or ((5336 - 4041) >= (8680 - 5447))) then
			v93.DispellableDebuffs = v93.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v94();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v95 = not v34;
	local v96 = v89.SunKingsBlessing:IsAvailable();
	local v97 = ((v89.FlamePatch:IsAvailable()) and (9 - 5)) or (800 + 199);
	local v98 = 3501 - 2502;
	local v99 = v97;
	local v100 = ((8 - 5) * v27(v89.FueltheFire:IsAvailable())) + ((1609 - 610) * v27(not v89.FueltheFire:IsAvailable()));
	local v101 = 3087 - 2088;
	local v102 = 1288 - (111 + 1137);
	local v103 = 1157 - (91 + 67);
	local v104 = 0.3 - 0;
	local v105 = 0 + 0;
	local v106 = 529 - (423 + 100);
	local v107 = false;
	local v108 = (v107 and (1 + 19)) or (0 - 0);
	local v109;
	local v110 = ((v89.Kindling:IsAvailable()) and (0.4 + 0)) or (772 - (326 + 445));
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = 0 - 0;
	local v115 = 0 - 0;
	local v116 = 18 - 10;
	local v117 = 714 - (530 + 181);
	local v118;
	local v119;
	local v120 = v13:BuffRemains(v89.CombustionBuff);
	local v121 = 884 - (614 + 267);
	local v122 = 11143 - (19 + 13);
	local v123 = 18084 - 6973;
	local v124;
	local v125, v126, v127, v128;
	local v129, v130;
	local v131;
	v9:RegisterForEvent(function()
		local v156 = 0 - 0;
		while true do
			if (((12503 - 8126) > (427 + 1215)) and (v156 == (0 - 0))) then
				v107 = false;
				v108 = (v107 and (41 - 21)) or (1812 - (1293 + 519));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v157 = 0 - 0;
		while true do
			if (((12331 - 7608) > (2592 - 1236)) and (v157 == (8 - 6))) then
				v89.PhoenixFlames:RegisterInFlightEffect(606701 - 349159);
				v89.PhoenixFlames:RegisterInFlight();
				v157 = 2 + 1;
			end
			if ((v157 == (1 + 0)) or ((9609 - 5473) <= (794 + 2639))) then
				v89.Meteor:RegisterInFlightEffect(116652 + 234488);
				v89.Meteor:RegisterInFlight();
				v157 = 2 + 0;
			end
			if (((5341 - (709 + 387)) <= (6489 - (673 + 1185))) and (v157 == (8 - 5))) then
				v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
				v89.Fireball:RegisterInFlight(v89.CombustionBuff);
				break;
			end
			if (((13730 - 9454) >= (6439 - 2525)) and (v157 == (0 + 0))) then
				v89.Pyroblast:RegisterInFlight();
				v89.Fireball:RegisterInFlight();
				v157 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v89.Pyroblast:RegisterInFlight();
	v89.Fireball:RegisterInFlight();
	v89.Meteor:RegisterInFlightEffect(474095 - 122955);
	v89.Meteor:RegisterInFlight();
	v89.PhoenixFlames:RegisterInFlightEffect(63253 + 194289);
	v89.PhoenixFlames:RegisterInFlight();
	v89.Pyroblast:RegisterInFlight(v89.CombustionBuff);
	v89.Fireball:RegisterInFlight(v89.CombustionBuff);
	v9:RegisterForEvent(function()
		local v158 = 0 - 0;
		while true do
			if (((388 - 190) <= (6245 - (446 + 1434))) and (v158 == (1283 - (1040 + 243)))) then
				v122 = 33162 - 22051;
				v123 = 12958 - (559 + 1288);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v96 = v89.SunKingsBlessing:IsAvailable();
		v97 = ((v89.FlamePatch:IsAvailable()) and (1934 - (609 + 1322))) or (1453 - (13 + 441));
		v99 = v97;
		v110 = ((v89.Kindling:IsAvailable()) and (0.4 - 0)) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v132()
		return v89.Firestarter:IsAvailable() and (v14:HealthPercentage() > (448 - 358));
	end
	local function v133()
		return (v89.Firestarter:IsAvailable() and (((v14:HealthPercentage() > (4 + 86)) and v14:TimeToX(326 - 236)) or (0 + 0))) or (0 + 0);
	end
	local function v134()
		return v89.SearingTouch:IsAvailable() and (v14:HealthPercentage() < (89 - 59));
	end
	local function v135()
		return v89.ImprovedScorch:IsAvailable() and (v14:HealthPercentage() < (17 + 13));
	end
	local function v136()
		return (v121 * v89.ShiftingPower:BaseDuration()) / v89.ShiftingPower:BaseTickTime();
	end
	local function v137()
		local v159 = (v132() and (v27(v89.Pyroblast:InFlight()) + v27(v89.Fireball:InFlight()))) or (0 - 0);
		v159 = v159 + v27(v89.PhoenixFlames:InFlight() or v13:PrevGCDP(1 + 0, v89.PhoenixFlames));
		return v13:BuffUp(v89.HotStreakBuff) or v13:BuffUp(v89.HyperthermiaBuff) or (v13:BuffUp(v89.HeatingUpBuff) and ((v135() and v13:IsCasting(v89.Scorch)) or (v132() and (v13:IsCasting(v89.Fireball) or (v159 > (0 + 0))))));
	end
	local function v138(v160)
		local v161 = 0 + 0;
		for v206, v207 in pairs(v160) do
			if (((4016 + 766) > (4575 + 101)) and v207:DebuffUp(v89.IgniteDebuff)) then
				v161 = v161 + (434 - (153 + 280));
			end
		end
		return v161;
	end
	local function v139()
		local v162 = 0 - 0;
		local v163;
		while true do
			if (((4367 + 497) > (868 + 1329)) and (v162 == (0 + 0))) then
				v163 = 0 + 0;
				if (v89.Fireball:InFlight() or v89.PhoenixFlames:InFlight() or ((2682 + 1018) == (3816 - 1309))) then
					v163 = v163 + 1 + 0;
				end
				v162 = 668 - (89 + 578);
			end
			if (((3197 + 1277) >= (569 - 295)) and (v162 == (1050 - (572 + 477)))) then
				return v163;
			end
		end
	end
	local function v140()
		local v164 = 0 + 0;
		while true do
			if ((v164 == (0 + 0)) or ((227 + 1667) <= (1492 - (84 + 2)))) then
				v31 = v93.HandleTopTrinket(v92, v34, 65 - 25, nil);
				if (((1133 + 439) >= (2373 - (497 + 345))) and v31) then
					return v31;
				end
				v164 = 1 + 0;
			end
			if (((1 + 0) == v164) or ((6020 - (605 + 728)) < (3241 + 1301))) then
				v31 = v93.HandleBottomTrinket(v92, v34, 88 - 48, nil);
				if (((151 + 3140) > (6163 - 4496)) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local v141 = 0 + 0;
	local function v142()
		if ((v89.RemoveCurse:IsReady() and (v93.UnitHasDispellableDebuffByPlayer(v15) or v93.DispellableFriendlyUnit(55 - 35) or v93.UnitHasCurseDebuff(v15))) or ((660 + 213) == (2523 - (457 + 32)))) then
			if ((v141 == (0 + 0)) or ((4218 - (832 + 570)) < (11 + 0))) then
				v141 = GetTime();
			end
			if (((965 + 2734) < (16653 - 11947)) and v93.Wait(241 + 259, v141)) then
				local v227 = 796 - (588 + 208);
				while true do
					if (((7131 - 4485) >= (2676 - (884 + 916))) and (v227 == (0 - 0))) then
						if (((357 + 257) <= (3837 - (232 + 421))) and v23(v91.RemoveCurseFocus)) then
							return "remove_curse dispel";
						end
						v141 = 1889 - (1569 + 320);
						break;
					end
				end
			end
		end
	end
	local function v143()
		if (((767 + 2359) == (594 + 2532)) and v89.BlazingBarrier:IsCastable() and v54 and v13:BuffDown(v89.BlazingBarrier) and (v13:HealthPercentage() <= v61)) then
			if (v23(v89.BlazingBarrier) or ((7369 - 5182) >= (5559 - (316 + 289)))) then
				return "blazing_barrier defensive 1";
			end
		end
		if ((v89.MassBarrier:IsCastable() and v59 and v13:BuffDown(v89.BlazingBarrier) and v93.AreUnitsBelowHealthPercentage(v66, 5 - 3, v89.ArcaneIntellect)) or ((180 + 3697) == (5028 - (666 + 787)))) then
			if (((1132 - (360 + 65)) > (591 + 41)) and v23(v89.MassBarrier)) then
				return "mass_barrier defensive 2";
			end
		end
		if ((v89.IceBlock:IsCastable() and v56 and (v13:HealthPercentage() <= v63)) or ((800 - (79 + 175)) >= (4231 - 1547))) then
			if (((1144 + 321) <= (13183 - 8882)) and v23(v89.IceBlock)) then
				return "ice_block defensive 3";
			end
		end
		if (((3281 - 1577) > (2324 - (503 + 396))) and v89.IceColdTalent:IsAvailable() and v89.IceColdAbility:IsCastable() and v57 and (v13:HealthPercentage() <= v64)) then
			if (v23(v89.IceColdAbility) or ((868 - (92 + 89)) == (8213 - 3979))) then
				return "ice_cold defensive 3";
			end
		end
		if ((v89.MirrorImage:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or ((1708 + 1622) < (846 + 583))) then
			if (((4491 - 3344) >= (46 + 289)) and v23(v89.MirrorImage)) then
				return "mirror_image defensive 4";
			end
		end
		if (((7832 - 4397) > (1830 + 267)) and v89.GreaterInvisibility:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
			if (v23(v89.GreaterInvisibility) or ((1801 + 1969) >= (12307 - 8266))) then
				return "greater_invisibility defensive 5";
			end
		end
		if ((v89.AlterTime:IsReady() and v53 and (v13:HealthPercentage() <= v60)) or ((474 + 3317) <= (2456 - 845))) then
			if (v23(v89.AlterTime) or ((5822 - (485 + 759)) <= (4646 - 2638))) then
				return "alter_time defensive 6";
			end
		end
		if (((2314 - (442 + 747)) <= (3211 - (832 + 303))) and v90.Healthstone:IsReady() and v77 and (v13:HealthPercentage() <= v79)) then
			if (v23(v91.Healthstone) or ((1689 - (88 + 858)) >= (1341 + 3058))) then
				return "healthstone defensive";
			end
		end
		if (((956 + 199) < (69 + 1604)) and v76 and (v13:HealthPercentage() <= v78)) then
			local v210 = 789 - (766 + 23);
			while true do
				if (((0 - 0) == v210) or ((3178 - 854) <= (1522 - 944))) then
					if (((12785 - 9018) == (4840 - (1036 + 37))) and (v80 == "Refreshing Healing Potion")) then
						if (((2900 + 1189) == (7962 - 3873)) and v90.RefreshingHealingPotion:IsReady()) then
							if (((3507 + 951) >= (3154 - (641 + 839))) and v23(v91.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((1885 - (910 + 3)) <= (3614 - 2196)) and (v80 == "Dreamwalker's Healing Potion")) then
						if (v90.DreamwalkersHealingPotion:IsReady() or ((6622 - (1466 + 218)) < (2189 + 2573))) then
							if (v23(v91.RefreshingHealingPotion) or ((3652 - (556 + 592)) > (1517 + 2747))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v144()
		local v165 = 808 - (329 + 479);
		while true do
			if (((3007 - (174 + 680)) == (7397 - 5244)) and (v165 == (0 - 0))) then
				if ((v89.ArcaneIntellect:IsCastable() and v37 and (v13:BuffDown(v89.ArcaneIntellect, true) or v93.GroupBuffMissing(v89.ArcaneIntellect))) or ((362 + 145) >= (3330 - (396 + 343)))) then
					if (((397 + 4084) == (5958 - (29 + 1448))) and v23(v89.ArcaneIntellect)) then
						return "arcane_intellect precombat 2";
					end
				end
				if ((v89.MirrorImage:IsCastable() and v93.TargetIsValid() and v58 and v85) or ((3717 - (135 + 1254)) < (2610 - 1917))) then
					if (((20207 - 15879) == (2885 + 1443)) and v23(v89.MirrorImage)) then
						return "mirror_image precombat 2";
					end
				end
				v165 = 1528 - (389 + 1138);
			end
			if (((2162 - (102 + 472)) >= (1257 + 75)) and (v165 == (1 + 0))) then
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast)) or ((3892 + 282) > (5793 - (320 + 1225)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true) or ((8163 - 3577) <= (51 + 31))) then
						return "pyroblast precombat 4";
					end
				end
				if (((5327 - (157 + 1307)) == (5722 - (821 + 1038))) and v89.Fireball:IsReady() and v40) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), true) or ((703 - 421) <= (5 + 37))) then
						return "fireball precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v166 = 0 - 0;
		while true do
			if (((1715 + 2894) >= (1898 - 1132)) and (v166 == (1027 - (834 + 192)))) then
				if ((v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (1 + 14))) and not v135() and (v133() == (0 + 0)) and not v89.TemperedFlames:IsAvailable()) or ((25 + 1127) == (3854 - 1366))) then
					if (((3726 - (300 + 4)) > (895 + 2455)) and v23(v89.DragonsBreath, not v14:IsInRange(26 - 16))) then
						return "dragons_breath active_talents 6";
					end
				end
				if (((1239 - (112 + 250)) > (150 + 226)) and v89.DragonsBreath:IsReady() and v38 and v89.AlexstraszasFury:IsAvailable() and v119 and v13:BuffDown(v89.HotStreakBuff) and (v13:BuffUp(v89.FeeltheBurnBuff) or (v9.CombatTime() > (37 - 22))) and not v135() and v89.TemperedFlames:IsAvailable()) then
					if (v23(v89.DragonsBreath, not v14:IsInRange(6 + 4)) or ((1613 + 1505) <= (1385 + 466))) then
						return "dragons_breath active_talents 8";
					end
				end
				break;
			end
			if (((0 + 0) == v166) or ((123 + 42) >= (4906 - (1001 + 413)))) then
				if (((8805 - 4856) < (5738 - (244 + 638))) and v89.LivingBomb:IsReady() and v42 and (v127 > (694 - (627 + 66))) and v119 and ((v109 > v89.LivingBomb:CooldownRemains()) or (v109 <= (0 - 0)))) then
					if (v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes)) or ((4878 - (512 + 90)) < (4922 - (1665 + 241)))) then
						return "living_bomb active_talents 2";
					end
				end
				if (((5407 - (373 + 344)) > (1861 + 2264)) and v89.Meteor:IsReady() and v43 and (v74 < v123) and ((v109 <= (0 + 0)) or (v13:BuffRemains(v89.CombustionBuff) > v89.Meteor:TravelTime()) or (not v89.SunKingsBlessing:IsAvailable() and (((118 - 73) < v109) or (v123 < v109))))) then
					if (v23(v91.MeteorCursor, not v14:IsInRange(67 - 27)) or ((1149 - (35 + 1064)) >= (652 + 244))) then
						return "meteor active_talents 4";
					end
				end
				v166 = 2 - 1;
			end
		end
	end
	local function v146()
		local v167 = 0 + 0;
		local v168;
		while true do
			if ((v167 == (1238 - (298 + 938))) or ((2973 - (233 + 1026)) >= (4624 - (636 + 1030)))) then
				if ((v74 < v123) or ((763 + 728) < (630 + 14))) then
					if (((210 + 494) < (67 + 920)) and v82 and ((v34 and v83) or not v83)) then
						v31 = v140();
						if (((3939 - (55 + 166)) > (370 + 1536)) and v31) then
							return v31;
						end
					end
				end
				break;
			end
			if ((v167 == (1 + 0)) or ((3658 - 2700) > (3932 - (36 + 261)))) then
				if (((6122 - 2621) <= (5860 - (34 + 1334))) and v81 and ((v84 and v34) or not v84) and (v74 < v123)) then
					local v230 = 0 + 0;
					while true do
						if ((v230 == (1 + 0)) or ((4725 - (1035 + 248)) < (2569 - (20 + 1)))) then
							if (((1498 + 1377) >= (1783 - (134 + 185))) and v89.Fireblood:IsCastable()) then
								if (v23(v89.Fireblood) or ((5930 - (549 + 584)) >= (5578 - (314 + 371)))) then
									return "fireblood combustion_cooldowns 8";
								end
							end
							if (v89.AncestralCall:IsCastable() or ((1891 - 1340) > (3036 - (478 + 490)))) then
								if (((1120 + 994) > (2116 - (786 + 386))) and v23(v89.AncestralCall)) then
									return "ancestral_call combustion_cooldowns 10";
								end
							end
							break;
						end
						if ((v230 == (0 - 0)) or ((3641 - (1055 + 324)) >= (4436 - (1093 + 247)))) then
							if (v89.BloodFury:IsCastable() or ((2004 + 251) >= (372 + 3165))) then
								if (v23(v89.BloodFury) or ((15233 - 11396) < (4431 - 3125))) then
									return "blood_fury combustion_cooldowns 4";
								end
							end
							if (((8394 - 5444) == (7413 - 4463)) and v89.Berserking:IsCastable() and v118) then
								if (v23(v89.Berserking) or ((1681 + 3042) < (12705 - 9407))) then
									return "berserking combustion_cooldowns 6";
								end
							end
							v230 = 3 - 2;
						end
					end
				end
				if (((857 + 279) >= (393 - 239)) and v87 and v89.TimeWarp:IsReady() and v89.TemporalWarp:IsAvailable() and v13:BloodlustExhaustUp()) then
					if (v23(v89.TimeWarp, nil, nil, true) or ((959 - (364 + 324)) > (13015 - 8267))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				v167 = 4 - 2;
			end
			if (((1571 + 3169) >= (13188 - 10036)) and (v167 == (0 - 0))) then
				v168 = v93.HandleDPSPotion(v13:BuffUp(v89.CombustionBuff));
				if (v168 or ((7829 - 5251) >= (4658 - (1249 + 19)))) then
					return v168;
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v147()
		local v169 = 0 - 0;
		while true do
			if (((1127 - (686 + 400)) <= (1304 + 357)) and ((237 - (73 + 156)) == v169)) then
				if (((3 + 598) < (4371 - (721 + 90))) and v89.PhoenixFlames:IsCastable() and v44 and ((not v89.AlexstraszasFury:IsAvailable() and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff))) or v89.AlexstraszasFury:IsAvailable()) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (1 + 1))) then
					if (((763 - 528) < (1157 - (224 + 246))) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames combustion_phase 42";
					end
				end
				if (((7368 - 2819) > (2122 - 969)) and v89.Scorch:IsReady() and v46 and (v13:BuffRemains(v89.CombustionBuff) > v89.Scorch:CastTime()) and (v89.Scorch:CastTime() >= v124)) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((848 + 3826) < (112 + 4560))) then
						return "scorch combustion_phase 44";
					end
				end
				if (((2695 + 973) < (9067 - 4506)) and v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime())) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((1514 - 1059) == (4118 - (203 + 310)))) then
						return "fireball combustion_phase 46";
					end
				end
				v169 = 2002 - (1238 + 755);
			end
			if ((v169 == (1 + 2)) or ((4197 - (709 + 825)) == (6102 - 2790))) then
				if (((6230 - 1953) <= (5339 - (196 + 668))) and v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v89.Combustion:CooldownRemains() < v89.Flamestrike:CastTime()) and (v126 >= v100)) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(157 - 117), v13:BuffDown(v89.IceFloes)) or ((1802 - 932) == (2022 - (171 + 662)))) then
						return "flamestrike combustion_phase 12";
					end
				end
				if (((1646 - (4 + 89)) <= (10980 - 7847)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v119 and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((815 + 1422) >= (15421 - 11910))) then
						return "pyroblast combustion_phase 14";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and v119 and (v89.Combustion:CooldownRemains() < v89.Fireball:CastTime()) and (v126 < (1 + 1)) and not v135()) or ((2810 - (35 + 1451)) > (4473 - (28 + 1425)))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((4985 - (941 + 1052)) == (1804 + 77))) then
						return "fireball combustion_phase 16";
					end
				end
				v169 = 1518 - (822 + 692);
			end
			if (((4433 - 1327) > (719 + 807)) and (v169 == (297 - (45 + 252)))) then
				if (((2992 + 31) < (1332 + 2538)) and v89.LightsJudgment:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (((347 - 204) > (507 - (114 + 319))) and v23(v89.LightsJudgment, not v14:IsSpellInRange(v89.LightsJudgment))) then
						return "lights_judgment combustion_phase 2";
					end
				end
				if (((25 - 7) < (2705 - 593)) and v89.BagofTricks:IsCastable() and v81 and ((v84 and v34) or not v84) and (v74 < v123) and v119) then
					if (((700 + 397) <= (2425 - 797)) and v23(v89.BagofTricks)) then
						return "bag_of_tricks combustion_phase 4";
					end
				end
				if (((9701 - 5071) == (6593 - (556 + 1407))) and v89.LivingBomb:IsReady() and v33 and v42 and (v127 > (1207 - (741 + 465))) and v119) then
					if (((4005 - (170 + 295)) > (1414 + 1269)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
						return "living_bomb combustion_phase 6";
					end
				end
				v169 = 1 + 0;
			end
			if (((11803 - 7009) >= (2715 + 560)) and (v169 == (6 + 3))) then
				if (((841 + 643) == (2714 - (957 + 273))) and v89.LivingBomb:IsReady() and v42 and (v13:BuffRemains(v89.CombustionBuff) < v124) and (v127 > (1 + 0))) then
					if (((574 + 858) < (13546 - 9991)) and v23(v89.LivingBomb, not v14:IsSpellInRange(v89.LivingBomb), v13:BuffDown(v89.IceFloes))) then
						return "living_bomb combustion_phase 48";
					end
				end
				break;
			end
			if ((v169 == (18 - 11)) or ((3253 - 2188) > (17717 - 14139))) then
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((1784 - (389 + 1391)) * v124)) and (v128 < v99)) or ((3009 + 1786) < (147 + 1260))) then
					if (((4218 - 2365) < (5764 - (783 + 168))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch combustion_phase 36";
					end
				end
				if ((v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(100 - 70, 2 + 0) and (v89.PhoenixFlames:TravelTime() < v13:BuffRemains(v89.CombustionBuff)) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) < (313 - (309 + 2))) and ((v14:DebuffRemains(v89.CharringEmbersDebuff) < ((12 - 8) * v124)) or (v13:BuffStack(v89.FlamesFuryBuff) > (1213 - (1090 + 122))) or v13:BuffUp(v89.FlamesFuryBuff))) or ((915 + 1906) < (8164 - 5733))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((1967 + 907) < (3299 - (628 + 490)))) then
						return "phoenix_flames combustion_phase 38";
					end
				end
				if ((v89.Fireball:IsReady() and v40 and (v13:BuffRemains(v89.CombustionBuff) > v89.Fireball:CastTime()) and v13:BuffUp(v89.FlameAccelerantBuff)) or ((483 + 2206) <= (849 - 506))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((8541 - 6672) == (2783 - (431 + 343)))) then
						return "fireball combustion_phase 40";
					end
				end
				v169 = 16 - 8;
			end
			if ((v169 == (14 - 9)) or ((2802 + 744) < (297 + 2025))) then
				if ((v89.Pyroblast:IsReady() and v45 and (v13:BuffUp(v89.HyperthermiaBuff))) or ((3777 - (556 + 1139)) == (4788 - (6 + 9)))) then
					if (((594 + 2650) > (541 + 514)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast combustion_phase 24";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and v13:BuffUp(v89.HotStreakBuff) and v118) or ((3482 - (28 + 141)) <= (689 + 1089))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((1753 - 332) >= (1491 + 613))) then
						return "pyroblast combustion_phase 26";
					end
				end
				if (((3129 - (486 + 831)) <= (8454 - 5205)) and v89.Pyroblast:IsReady() and v45 and v13:PrevGCDP(3 - 2, v89.Scorch) and v13:BuffUp(v89.HeatingUpBuff) and (v126 < v99) and v118) then
					if (((307 + 1316) <= (6187 - 4230)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast combustion_phase 28";
					end
				end
				v169 = 1269 - (668 + 595);
			end
			if (((3971 + 441) == (890 + 3522)) and (v169 == (2 - 1))) then
				if (((2040 - (23 + 267)) >= (2786 - (1129 + 815))) and ((v13:BuffRemains(v89.CombustionBuff) > v106) or (v123 < (407 - (371 + 16))))) then
					v31 = v146();
					if (((6122 - (1326 + 424)) > (3503 - 1653)) and v31) then
						return v31;
					end
				end
				if (((847 - 615) < (939 - (88 + 30))) and v89.PhoenixFlames:IsCastable() and v44 and v13:BuffDown(v89.CombustionBuff) and v13:HasTier(801 - (720 + 51), 4 - 2) and not v89.PhoenixFlames:InFlight() and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((1780 - (421 + 1355)) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((854 - 336) < (444 + 458)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames combustion_phase 8";
					end
				end
				v31 = v145();
				v169 = 1085 - (286 + 797);
			end
			if (((10944 - 7950) > (1420 - 562)) and ((445 - (397 + 42)) == v169)) then
				if ((v89.ShiftingPower:IsReady() and v50 and ((v52 and v34) or not v52) and (v74 < v123) and v118 and (v89.FireBlast:Charges() == (0 + 0)) and ((v89.PhoenixFlames:Charges() < v89.PhoenixFlames:MaxCharges()) or v89.AlexstraszasFury:IsAvailable()) and (v103 <= v126)) or ((4555 - (24 + 776)) <= (1409 - 494))) then
					if (((4731 - (222 + 563)) > (8246 - 4503)) and v23(v89.ShiftingPower, not v14:IsInRange(29 + 11))) then
						return "shifting_power combustion_phase 30";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Flamestrike:CastTime()) and (v126 >= v100)) or ((1525 - (23 + 167)) >= (5104 - (690 + 1108)))) then
					if (((1748 + 3096) > (1859 + 394)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(888 - (40 + 808)), v13:BuffDown(v89.IceFloes))) then
						return "flamestrike combustion_phase 32";
					end
				end
				if (((75 + 377) == (1728 - 1276)) and v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and v13:BuffUp(v89.FuryoftheSunKingBuff) and (v13:BuffRemains(v89.FuryoftheSunKingBuff) > v89.Pyroblast:CastTime())) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((4356 + 201) < (1105 + 982))) then
						return "pyroblast combustion_phase 34";
					end
				end
				v169 = 4 + 3;
			end
			if (((4445 - (47 + 524)) == (2515 + 1359)) and (v169 == (10 - 6))) then
				if ((v89.Scorch:IsReady() and v46 and v119 and (v89.Combustion:CooldownRemains() < v89.Scorch:CastTime())) or ((2897 - 959) > (11254 - 6319))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((5981 - (1165 + 561)) < (102 + 3321))) then
						return "scorch combustion_phase 18";
					end
				end
				if (((4503 - 3049) <= (951 + 1540)) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((483 - (341 + 138)) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (0 + 0)))) < (3 - 1))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((4483 - (89 + 237)) <= (9017 - 6214))) then
						return "fire_blast combustion_phase 20";
					end
				end
				if (((10217 - 5364) >= (3863 - (581 + 300))) and v33 and v89.Flamestrike:IsReady() and v41 and ((v13:BuffUp(v89.HotStreakBuff) and (v126 >= v99)) or (v13:BuffUp(v89.HyperthermiaBuff) and (v126 >= (v99 - v27(v89.Hyperthermia:IsAvailable())))))) then
					if (((5354 - (855 + 365)) > (7973 - 4616)) and v23(v91.FlamestrikeCursor, not v14:IsInRange(14 + 26), v13:BuffDown(v89.IceFloes))) then
						return "flamestrike combustion_phase 22";
					end
				end
				v169 = 1240 - (1030 + 205);
			end
			if ((v169 == (2 + 0)) or ((3179 + 238) < (2820 - (156 + 130)))) then
				if (v31 or ((6184 - 3462) <= (275 - 111))) then
					return v31;
				end
				if ((v89.Combustion:IsReady() and v49 and ((v51 and v34) or not v51) and (v74 < v123) and (v139() == (0 - 0)) and v119 and (v109 <= (0 + 0)) and ((v13:IsCasting(v89.Scorch) and (v89.Scorch:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Fireball) and (v89.Fireball:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Pyroblast) and (v89.Pyroblast:ExecuteRemains() < v104)) or (v13:IsCasting(v89.Flamestrike) and (v89.Flamestrike:ExecuteRemains() < v104)) or (v89.Meteor:InFlight() and (v89.Meteor:InFlightRemains() < v104)))) or ((1405 + 1003) < (2178 - (10 + 59)))) then
					if (v23(v89.Combustion, not v14:IsInRange(12 + 28), nil, true) or ((162 - 129) == (2618 - (671 + 492)))) then
						return "combustion combustion_phase 10";
					end
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (not v135() or v13:IsCasting(v89.Scorch) or (v14:DebuffRemains(v89.ImprovedScorchDebuff) > ((4 + 0) * v124))) and (v13:BuffDown(v89.FuryoftheSunKingBuff) or v13:IsCasting(v89.Pyroblast)) and v118 and v13:BuffDown(v89.HyperthermiaBuff) and v13:BuffDown(v89.HotStreakBuff) and ((v139() + (v27(v13:BuffUp(v89.HeatingUpBuff)) * v27(v13:GCDRemains() > (1215 - (369 + 846))))) < (1 + 1))) or ((379 + 64) >= (5960 - (1036 + 909)))) then
					if (((2689 + 693) > (278 - 112)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast combustion_phase 12";
					end
				end
				v169 = 206 - (11 + 192);
			end
		end
	end
	local function v148()
		v114 = v89.Combustion:CooldownRemains() * v110;
		v115 = ((v89.Fireball:CastTime() * v27(v126 < v99)) + (v89.Flamestrike:CastTime() * v27(v126 >= v99))) - v104;
		v109 = v114;
		if ((v89.Firestarter:IsAvailable() and not v96) or ((142 + 138) == (3234 - (135 + 40)))) then
			v109 = v29(v133(), v109);
		end
		if (((4557 - 2676) > (780 + 513)) and v89.SunKingsBlessing:IsAvailable() and v132() and v13:BuffDown(v89.FuryoftheSunKingBuff)) then
			v109 = v29((v116 - v13:BuffStack(v89.SunKingsBlessingBuff)) * (6 - 3) * v124, v109);
		end
		v109 = v29(v13:BuffRemains(v89.CombustionBuff), v109);
		if (((3532 - 1175) == (2533 - (50 + 126))) and (((v114 + ((334 - 214) * ((1 + 0) - (((1413.4 - (1233 + 180)) + ((969.2 - (522 + 447)) * v27(v89.Firestarter:IsAvailable()))) * v27(v89.Kindling:IsAvailable()))))) <= v109) or (v109 > (v123 - (1441 - (107 + 1314)))))) then
			v109 = v114;
		end
	end
	local function v149()
		local v170 = 0 + 0;
		while true do
			if (((374 - 251) == (53 + 70)) and ((0 - 0) == v170)) then
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and v13:BuffDown(v89.HotStreakBuff) and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (3 - 2)) and (v89.ShiftingPower:CooldownUp() or (v89.FireBlast:Charges() > (1911 - (716 + 1194))) or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((1 + 1) * v124)))) or ((114 + 942) >= (3895 - (74 + 429)))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((2085 - 1004) < (533 + 542))) then
						return "fire_blast firestarter_fire_blasts 2";
					end
				end
				if ((v89.FireBlast:IsReady() and v39 and not v137() and not v113 and ((v27(v13:BuffUp(v89.HeatingUpBuff)) + v139()) == (2 - 1)) and v89.ShiftingPower:CooldownUp() and (not v13:HasTier(22 + 8, 5 - 3) or (v14:DebuffRemains(v89.CharringEmbersDebuff) > ((4 - 2) * v124)))) or ((1482 - (279 + 154)) >= (5210 - (454 + 324)))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((3752 + 1016) <= (863 - (12 + 5)))) then
						return "fire_blast firestarter_fire_blasts 4";
					end
				end
				break;
			end
		end
	end
	local function v150()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (12 - 7)) or ((1241 + 2117) <= (2513 - (277 + 816)))) then
				if ((v89.Fireball:IsReady() and v40 and not v137()) or ((15976 - 12237) <= (4188 - (1058 + 125)))) then
					if (v23(v89.Fireball, not v14:IsSpellInRange(v89.Fireball), v13:BuffDown(v89.IceFloes)) or ((312 + 1347) >= (3109 - (815 + 160)))) then
						return "fireball standard_rotation 36";
					end
				end
				break;
			end
			if (((4 - 3) == v171) or ((7738 - 4478) < (562 + 1793))) then
				if ((v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < (v89.Pyroblast:CastTime() + ((14 - 9) * v124))) and v13:BuffUp(v89.FuryoftheSunKingBuff) and not v13:IsCasting(v89.Scorch)) or ((2567 - (41 + 1857)) == (6116 - (1222 + 671)))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((4372 - 2680) < (844 - 256))) then
						return "scorch standard_rotation 13";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and not v13:IsCasting(v89.Pyroblast) and (v13:BuffUp(v89.FuryoftheSunKingBuff))) or ((5979 - (229 + 953)) < (5425 - (1111 + 663)))) then
					if (v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff)) or ((5756 - (874 + 705)) > (679 + 4171))) then
						return "pyroblast standard_rotation 14";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and (v13:IsCasting(v89.Scorch) or v13:PrevGCDP(1 + 0, v89.Scorch)) and v13:BuffUp(v89.HeatingUpBuff) and v134() and (v126 < v97)) or ((831 - 431) > (32 + 1079))) then
					if (((3730 - (642 + 37)) > (230 + 775)) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 18";
					end
				end
				if (((591 + 3102) <= (11002 - 6620)) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffRemains(v89.ImprovedScorchDebuff) < ((458 - (233 + 221)) * v124))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((7588 - 4306) > (3609 + 491))) then
						return "scorch standard_rotation 19";
					end
				end
				v171 = 1543 - (718 + 823);
			end
			if ((v171 == (0 + 0)) or ((4385 - (266 + 539)) < (8051 - 5207))) then
				if (((1314 - (636 + 589)) < (10658 - 6168)) and v33 and v89.Flamestrike:IsReady() and v41 and (v126 >= v97) and v137()) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(82 - 42), v13:BuffDown(v89.IceFloes)) or ((3949 + 1034) < (657 + 1151))) then
						return "flamestrike standard_rotation 2";
					end
				end
				if (((4844 - (657 + 358)) > (9979 - 6210)) and v89.Pyroblast:IsReady() and v45 and (v137())) then
					if (((3383 - 1898) <= (4091 - (1151 + 36))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), true)) then
						return "pyroblast standard_rotation 4";
					end
				end
				if (((4123 + 146) == (1123 + 3146)) and v89.FireBlast:IsReady() and v39 and not v137() and not v132() and not v113 and v13:BuffDown(v89.FuryoftheSunKingBuff) and (((v13:IsCasting(v89.Fireball) or v13:IsCasting(v89.Pyroblast)) and v13:BuffUp(v89.HeatingUpBuff)) or (v134() and (not v135() or (v14:DebuffStack(v89.ImprovedScorchDebuff) == v117) or (v89.FireBlast:FullRechargeTime() < (8 - 5))) and ((v13:BuffUp(v89.HeatingUpBuff) and not v13:IsCasting(v89.Scorch)) or (v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HeatingUpBuff) and v13:IsCasting(v89.Scorch) and (v139() == (1832 - (1552 + 280)))))))) then
					if (((1221 - (64 + 770)) <= (1889 + 893)) and v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true)) then
						return "fire_blast standard_rotation 6";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and not v13:IsCasting(v89.Flamestrike) and (v126 >= v100) and v13:BuffUp(v89.FuryoftheSunKingBuff)) or ((4310 - 2411) <= (163 + 754))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(1283 - (157 + 1086)), v13:BuffDown(v89.IceFloes)) or ((8630 - 4318) <= (3836 - 2960))) then
						return "flamestrike standard_rotation 12";
					end
				end
				v171 = 1 - 0;
			end
			if (((3045 - 813) <= (3415 - (599 + 220))) and ((5 - 2) == v171)) then
				if (((4026 - (1813 + 118)) < (2695 + 991)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and (v139() == (1217 - (841 + 376))) and ((not v112 and v13:BuffUp(v89.FlamesFuryBuff)) or (v89.PhoenixFlames:ChargesFractional() > (2.5 - 0)) or ((v89.PhoenixFlames:ChargesFractional() > (1.5 + 0)) and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((8 - 5) * v124)))))) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((2454 - (464 + 395)) >= (11481 - 7007))) then
						return "phoenix_flames standard_rotation 26";
					end
				end
				v31 = v145();
				if (v31 or ((2219 + 2400) < (3719 - (467 + 370)))) then
					return v31;
				end
				if ((v33 and v89.DragonsBreath:IsReady() and v38 and (v128 > (1 - 0)) and v89.AlexstraszasFury:IsAvailable()) or ((216 + 78) >= (16560 - 11729))) then
					if (((317 + 1712) <= (7174 - 4090)) and v23(v89.DragonsBreath, not v14:IsInRange(530 - (150 + 370)))) then
						return "dragons_breath standard_rotation 28";
					end
				end
				v171 = 1286 - (74 + 1208);
			end
			if (((4 - 2) == v171) or ((9660 - 7623) == (1722 + 698))) then
				if (((4848 - (14 + 376)) > (6770 - 2866)) and v89.PhoenixFlames:IsCastable() and v44 and v89.AlexstraszasFury:IsAvailable() and (not v89.FeeltheBurn:IsAvailable() or (v13:BuffRemains(v89.FeeltheBurnBuff) < ((2 + 0) * v124)))) then
					if (((384 + 52) >= (118 + 5)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 20";
					end
				end
				if (((1465 - 965) < (1367 + 449)) and v89.PhoenixFlames:IsCastable() and v44 and v13:HasTier(108 - (23 + 55), 4 - 2) and (v14:DebuffRemains(v89.CharringEmbersDebuff) < ((2 + 0) * v124)) and v13:BuffDown(v89.HotStreakBuff)) then
					if (((3210 + 364) == (5540 - 1966)) and v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false)) then
						return "phoenix_flames standard_rotation 21";
					end
				end
				if (((70 + 151) < (1291 - (652 + 249))) and v89.Scorch:IsReady() and v46 and v135() and (v14:DebuffStack(v89.ImprovedScorchDebuff) < v117)) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((5922 - 3709) <= (3289 - (708 + 1160)))) then
						return "scorch standard_rotation 22";
					end
				end
				if (((8300 - 5242) < (8860 - 4000)) and v89.PhoenixFlames:IsCastable() and v44 and not v89.AlexstraszasFury:IsAvailable() and v13:BuffDown(v89.HotStreakBuff) and not v112 and v13:BuffUp(v89.FlamesFuryBuff)) then
					if (v23(v89.PhoenixFlames, not v14:IsSpellInRange(v89.PhoenixFlames), false) or ((1323 - (10 + 17)) >= (999 + 3447))) then
						return "phoenix_flames standard_rotation 24";
					end
				end
				v171 = 1735 - (1400 + 332);
			end
			if (((7 - 3) == v171) or ((3301 - (242 + 1666)) > (1921 + 2568))) then
				if ((v89.Scorch:IsReady() and v46 and (v134())) or ((1622 + 2802) < (24 + 3))) then
					if (v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false) or ((2937 - (850 + 90)) > (6681 - 2866))) then
						return "scorch standard_rotation 30";
					end
				end
				if (((4855 - (360 + 1030)) > (1693 + 220)) and v33 and v89.ArcaneExplosion:IsReady() and v36 and (v130 >= v101) and (v13:ManaPercentageP() >= v102)) then
					if (((2068 - 1335) < (2501 - 682)) and v23(v89.ArcaneExplosion, not v14:IsInRange(1669 - (909 + 752)))) then
						return "arcane_explosion standard_rotation 32";
					end
				end
				if ((v33 and v89.Flamestrike:IsReady() and v41 and (v126 >= v98)) or ((5618 - (109 + 1114)) == (8705 - 3950))) then
					if (v23(v91.FlamestrikeCursor, not v14:IsInRange(16 + 24)) or ((4035 - (6 + 236)) < (1493 + 876))) then
						return "flamestrike standard_rotation 34";
					end
				end
				if ((v89.Pyroblast:IsReady() and v45 and v89.TemperedFlames:IsAvailable() and v13:BuffDown(v89.FlameAccelerantBuff)) or ((3288 + 796) == (624 - 359))) then
					if (((7611 - 3253) == (5491 - (1076 + 57))) and v23(v89.Pyroblast, not v14:IsSpellInRange(v89.Pyroblast), v13:BuffDown(v89.IceFloes) and v13:BuffDown(v89.HotStreakBuff) and v13:BuffDown(v89.HyperthermiaBuff))) then
						return "pyroblast standard_rotation 35";
					end
				end
				v171 = 1 + 4;
			end
		end
	end
	local function v151()
		local v172 = 689 - (579 + 110);
		while true do
			if ((v172 == (0 + 0)) or ((2775 + 363) < (528 + 465))) then
				if (((3737 - (174 + 233)) > (6488 - 4165)) and not v95) then
					v148();
				end
				if ((v34 and v87 and v89.TimeWarp:IsReady() and v13:BloodlustExhaustUp() and v89.TemporalWarp:IsAvailable() and (v132() or (v123 < (70 - 30)))) or ((1613 + 2013) == (5163 - (663 + 511)))) then
					if (v23(v89.TimeWarp, not v14:IsInRange(36 + 4)) or ((199 + 717) == (8234 - 5563))) then
						return "time_warp combustion_cooldowns 12";
					end
				end
				if (((165 + 107) == (640 - 368)) and (v74 < v123)) then
					if (((10285 - 6036) <= (2310 + 2529)) and v82 and ((v34 and v83) or not v83)) then
						v31 = v140();
						if (((5404 - 2627) < (2281 + 919)) and v31) then
							return v31;
						end
					end
				end
				v111 = v109 > v89.ShiftingPower:CooldownRemains();
				v172 = 1 + 0;
			end
			if (((817 - (478 + 244)) < (2474 - (440 + 77))) and (v172 == (1 + 1))) then
				if (((3022 - 2196) < (3273 - (655 + 901))) and (v126 < v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or (((v109 + 2 + 5) < ((v89.PhoenixFlames:FullRechargeTime() + v89.PhoenixFlames:Cooldown()) - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if (((1092 + 334) >= (747 + 358)) and (v126 >= v99)) then
					v112 = (v89.SunKingsBlessing:IsAvailable() or ((v109 < (v89.PhoenixFlames:FullRechargeTime() - (v136() * v27(v111)))) and (v109 < v123))) and not v89.AlexstraszasFury:IsAvailable();
				end
				if (((11094 - 8340) <= (4824 - (695 + 750))) and v89.FireBlast:IsReady() and v39 and not v137() and not v113 and (v109 > (0 - 0)) and (v126 >= v98) and not v132() and v13:BuffDown(v89.HotStreakBuff) and ((v13:BuffUp(v89.HeatingUpBuff) and (v89.Flamestrike:ExecuteRemains() < (0.5 - 0))) or (v89.FireBlast:ChargesFractional() >= (7 - 5)))) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((4278 - (285 + 66)) == (3293 - 1880))) then
						return "fire_blast main 14";
					end
				end
				if ((v119 and v132() and (v109 > (1310 - (682 + 628)))) or ((187 + 967) <= (1087 - (176 + 123)))) then
					local v231 = 0 + 0;
					while true do
						if ((v231 == (0 + 0)) or ((1912 - (239 + 30)) > (919 + 2460))) then
							v31 = v149();
							if (v31 or ((2695 + 108) > (8050 - 3501))) then
								return v31;
							end
							break;
						end
					end
				end
				v172 = 8 - 5;
			end
			if (((318 - (306 + 9)) == v172) or ((767 - 547) >= (526 + 2496))) then
				if (((1732 + 1090) == (1359 + 1463)) and v89.FireBlast:IsReady() and v39 and not v137() and v13:IsCasting(v89.ShiftingPower) and (v89.FireBlast:FullRechargeTime() < v121)) then
					if (v23(v89.FireBlast, not v14:IsSpellInRange(v89.FireBlast), false, true) or ((3033 - 1972) == (3232 - (1140 + 235)))) then
						return "fire_blast main 16";
					end
				end
				if (((1757 + 1003) > (1251 + 113)) and (v109 > (0 + 0)) and v119) then
					v31 = v150();
					if (v31 or ((4954 - (33 + 19)) <= (1299 + 2296))) then
						return v31;
					end
				end
				if ((v89.IceNova:IsCastable() and not v134()) or ((11545 - 7693) == (130 + 163))) then
					if (v23(v89.IceNova, not v14:IsSpellInRange(v89.IceNova)) or ((3056 - 1497) == (4303 + 285))) then
						return "ice_nova main 18";
					end
				end
				if ((v89.Scorch:IsReady() and v46) or ((5173 - (586 + 103)) == (72 + 716))) then
					if (((14063 - 9495) >= (5395 - (1309 + 179))) and v23(v89.Scorch, not v14:IsSpellInRange(v89.Scorch), false)) then
						return "scorch main 20";
					end
				end
				break;
			end
			if (((2249 - 1003) < (1511 + 1959)) and ((2 - 1) == v172)) then
				v113 = v119 and (((v89.FireBlast:ChargesFractional() + ((v109 + (v136() * v27(v111))) / v89.FireBlast:Cooldown())) - (1 + 0)) < ((v89.FireBlast:MaxCharges() + (v105 / v89.FireBlast:Cooldown())) - (((25 - 13) / v89.FireBlast:Cooldown()) % (1 - 0)))) and (v109 < v123);
				if (((4677 - (295 + 314)) >= (2387 - 1415)) and not v95 and ((v109 <= (1962 - (1300 + 662))) or v118 or ((v109 < v115) and (v89.Combustion:CooldownRemains() < v115)))) then
					local v232 = 0 - 0;
					while true do
						if (((2248 - (1178 + 577)) < (2022 + 1871)) and ((0 - 0) == v232)) then
							v31 = v147();
							if (v31 or ((2878 - (851 + 554)) >= (2947 + 385))) then
								return v31;
							end
							break;
						end
					end
				end
				if ((not v113 and v89.SunKingsBlessing:IsAvailable()) or ((11234 - 7183) <= (2512 - 1355))) then
					v113 = v134() and (v89.FireBlast:FullRechargeTime() > ((305 - (115 + 187)) * v124));
				end
				if (((463 + 141) < (2728 + 153)) and v89.ShiftingPower:IsReady() and ((v34 and v52) or not v52) and v50 and (v74 < v123) and v119 and ((v89.FireBlast:Charges() == (0 - 0)) or v113) and (not v135() or ((v14:DebuffRemains(v89.ImprovedScorchDebuff) > (v89.ShiftingPower:CastTime() + v89.Scorch:CastTime())) and v13:BuffDown(v89.FuryoftheSunKingBuff))) and v13:BuffDown(v89.HotStreakBuff) and v111) then
					if (v23(v89.ShiftingPower, not v14:IsInRange(1179 - (160 + 1001)), true) or ((788 + 112) == (2331 + 1046))) then
						return "shifting_power main 12";
					end
				end
				v172 = 3 - 1;
			end
		end
	end
	local function v152()
		v36 = EpicSettings.Settings['useArcaneExplosion'];
		v37 = EpicSettings.Settings['useArcaneIntellect'];
		v38 = EpicSettings.Settings['useDragonsBreath'];
		v39 = EpicSettings.Settings['useFireBlast'];
		v40 = EpicSettings.Settings['useFireball'];
		v41 = EpicSettings.Settings['useFlamestrike'];
		v42 = EpicSettings.Settings['useLivingBomb'];
		v43 = EpicSettings.Settings['useMeteor'];
		v44 = EpicSettings.Settings['usePhoenixFlames'];
		v45 = EpicSettings.Settings['usePyroblast'];
		v46 = EpicSettings.Settings['useScorch'];
		v47 = EpicSettings.Settings['useCounterspell'];
		v48 = EpicSettings.Settings['useBlastWave'];
		v49 = EpicSettings.Settings['useCombustion'];
		v50 = EpicSettings.Settings['useShiftingPower'];
		v51 = EpicSettings.Settings['combustionWithCD'];
		v52 = EpicSettings.Settings['shiftingPowerWithCD'];
		v53 = EpicSettings.Settings['useAlterTime'];
		v54 = EpicSettings.Settings['useBlazingBarrier'];
		v55 = EpicSettings.Settings['useGreaterInvisibility'];
		v56 = EpicSettings.Settings['useIceBlock'];
		v57 = EpicSettings.Settings['useIceCold'];
		v59 = EpicSettings.Settings['useMassBarrier'];
		v58 = EpicSettings.Settings['useMirrorImage'];
		v60 = EpicSettings.Settings['alterTimeHP'] or (358 - (237 + 121));
		v61 = EpicSettings.Settings['blazingBarrierHP'] or (897 - (525 + 372));
		v62 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
		v63 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
		v64 = EpicSettings.Settings['iceColdHP'] or (142 - (96 + 46));
		v65 = EpicSettings.Settings['mirrorImageHP'] or (777 - (643 + 134));
		v66 = EpicSettings.Settings['massBarrierHP'] or (0 + 0);
		v85 = EpicSettings.Settings['mirrorImageBeforePull'];
		v86 = EpicSettings.Settings['useSpellStealTarget'];
		v87 = EpicSettings.Settings['useTimeWarpWithTalent'];
		v88 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
	end
	local function v153()
		local v201 = 0 - 0;
		while true do
			if (((16554 - 12095) > (567 + 24)) and (v201 == (5 - 2))) then
				v76 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v78 = EpicSettings.Settings['healingPotionHP'] or (719 - (316 + 403));
				v80 = EpicSettings.Settings['HealingPotionName'] or "";
				v201 = 3 + 1;
			end
			if (((9342 - 5944) >= (866 + 1529)) and (v201 == (4 - 2))) then
				v81 = EpicSettings.Settings['useRacials'];
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v84 = EpicSettings.Settings['racialsWithCD'];
				v77 = EpicSettings.Settings['useHealthstone'];
				v201 = 3 + 0;
			end
			if ((v201 == (0 + 0)) or ((7564 - 5381) >= (13486 - 10662))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v75 = EpicSettings.Settings['useWeapon'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v201 = 1 + 0;
			end
			if (((3811 - 1875) == (95 + 1841)) and (v201 == (11 - 7))) then
				v69 = EpicSettings.Settings['handleAfflicted'];
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v201 == (18 - (12 + 5))) or ((18767 - 13935) < (9201 - 4888))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v68 = EpicSettings.Settings['DispelDebuffs'];
				v67 = EpicSettings.Settings['DispelBuffs'];
				v82 = EpicSettings.Settings['useTrinkets'];
				v201 = 3 - 1;
			end
		end
	end
	local function v154()
		v152();
		v153();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((10137 - 6049) > (787 + 3087)) and v13:IsDeadOrGhost()) then
			return v31;
		end
		v125 = v14:GetEnemiesInSplashRange(1978 - (1656 + 317));
		v129 = v13:GetEnemiesInRange(36 + 4);
		if (((3472 + 860) == (11518 - 7186)) and v33) then
			v126 = v29(v14:GetEnemiesInSplashRangeCount(24 - 19), #v129);
			v127 = v29(v14:GetEnemiesInSplashRangeCount(359 - (5 + 349)), #v129);
			v128 = v29(v14:GetEnemiesInSplashRangeCount(23 - 18), #v129);
			v130 = #v129;
		else
			v126 = 1272 - (266 + 1005);
			v127 = 1 + 0;
			v128 = 3 - 2;
			v130 = 1 - 0;
		end
		if (((5695 - (561 + 1135)) >= (3779 - 879)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
			if (v13:AffectingCombat() or v68 or ((8299 - 5774) > (5130 - (507 + 559)))) then
				local v228 = 0 - 0;
				local v229;
				while true do
					if (((13518 - 9147) == (4759 - (212 + 176))) and (v228 == (906 - (250 + 655)))) then
						if (v31 or ((725 - 459) > (8712 - 3726))) then
							return v31;
						end
						break;
					end
					if (((3114 - 1123) >= (2881 - (1869 + 87))) and (v228 == (0 - 0))) then
						v229 = v68 and v89.RemoveCurse:IsReady() and v35;
						v31 = v93.FocusUnit(v229, nil, 1921 - (484 + 1417), nil, 42 - 22, v89.ArcaneIntellect);
						v228 = 1 - 0;
					end
				end
			end
			v122 = v9.BossFightRemains(nil, true);
			v123 = v122;
			if (((1228 - (48 + 725)) < (3353 - 1300)) and (v123 == (29809 - 18698))) then
				v123 = v9.FightRemains(v129, false);
			end
			UnitsWithIgniteCount = v138(v129);
			v95 = not v34;
			if (v95 or ((481 + 345) == (12963 - 8112))) then
				v109 = 27986 + 72013;
			end
			v124 = v13:GCD();
			v118 = v13:BuffUp(v89.CombustionBuff);
			v119 = not v118;
			v120 = v13:BuffRemains(v89.CombustionBuff);
		end
		if (((54 + 129) == (1036 - (152 + 701))) and not v13:AffectingCombat() and v32) then
			local v211 = 1311 - (430 + 881);
			while true do
				if (((444 + 715) <= (2683 - (557 + 338))) and (v211 == (0 + 0))) then
					v31 = v144();
					if (v31 or ((9882 - 6375) > (15120 - 10802))) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v13:AffectingCombat() and v93.TargetIsValid()) or ((8169 - 5094) <= (6389 - 3424))) then
			local v212 = 801 - (499 + 302);
			while true do
				if (((2231 - (39 + 827)) <= (5551 - 3540)) and ((0 - 0) == v212)) then
					if ((v34 and v75 and (v90.Dreambinder:IsEquippedAndReady() or v90.Iridal:IsEquippedAndReady())) or ((11025 - 8249) > (5488 - 1913))) then
						if (v23(v91.UseWeapon, nil) or ((219 + 2335) == (14060 - 9256))) then
							return "Using Weapon Macro";
						end
					end
					if (((413 + 2164) == (4077 - 1500)) and v68 and v35 and v89.RemoveCurse:IsAvailable()) then
						if (v15 or ((110 - (103 + 1)) >= (2443 - (475 + 79)))) then
							v31 = v142();
							if (((1093 - 587) <= (6054 - 4162)) and v31) then
								return v31;
							end
						end
						if ((v17 and v17:Exists() and not v13:CanAttack(v17) and v93.UnitHasCurseDebuff(v17)) or ((260 + 1748) > (1953 + 265))) then
							if (((1882 - (1395 + 108)) <= (12067 - 7920)) and v89.RemoveCurse:IsReady()) then
								if (v23(v91.RemoveCurseMouseover) or ((5718 - (7 + 1197)) <= (440 + 569))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					v31 = v143();
					v212 = 1 + 0;
				end
				if ((v212 == (322 - (27 + 292))) or ((10244 - 6748) == (1519 - 327))) then
					v31 = v151();
					if (v31 or ((872 - 664) == (5834 - 2875))) then
						return v31;
					end
					break;
				end
				if (((8145 - 3868) >= (1452 - (43 + 96))) and (v212 == (8 - 6))) then
					if (((5848 - 3261) < (2634 + 540)) and v89.Spellsteal:IsAvailable() and v86 and v89.Spellsteal:IsReady() and v35 and v67 and not v13:IsCasting() and not v13:IsChanneling() and v93.UnitHasMagicBuff(v14)) then
						if (v23(v89.Spellsteal, not v14:IsSpellInRange(v89.Spellsteal)) or ((1164 + 2956) <= (4344 - 2146))) then
							return "spellsteal damage";
						end
					end
					if (((v13:IsCasting(v89.Pyroblast) or v13:IsChanneling(v89.Pyroblast) or v13:IsCasting(v89.Flamestrike) or v13:IsChanneling(v89.Flamestrike)) and v13:BuffUp(v89.HotStreakBuff)) or ((612 + 984) == (1607 - 749))) then
						if (((1014 + 2206) == (237 + 2983)) and v23(v91.StopCasting, not v14:IsSpellInRange(v89.Pyroblast), false, true)) then
							return "Stop Casting";
						end
					end
					if ((v13:IsMoving() and v89.IceFloes:IsReady() and not v13:BuffUp(v89.IceFloes) and not v13:PrevOffGCDP(1752 - (1414 + 337), v89.IceFloes)) or ((3342 - (1642 + 298)) > (9436 - 5816))) then
						if (((7404 - 4830) == (7638 - 5064)) and v23(v89.IceFloes)) then
							return "ice_floes movement";
						end
					end
					v212 = 1 + 2;
				end
				if (((1399 + 399) < (3729 - (357 + 615))) and (v212 == (1 + 0))) then
					if (v31 or ((924 - 547) > (2232 + 372))) then
						return v31;
					end
					if (((1216 - 648) < (729 + 182)) and v69) then
						if (((224 + 3061) < (2658 + 1570)) and v88) then
							local v233 = 1301 - (384 + 917);
							while true do
								if (((4613 - (128 + 569)) > (4871 - (1407 + 136))) and (v233 == (1887 - (687 + 1200)))) then
									v31 = v93.HandleAfflicted(v89.RemoveCurse, v91.RemoveCurseMouseover, 1740 - (556 + 1154));
									if (((8795 - 6295) < (3934 - (9 + 86))) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if (((928 - (275 + 146)) == (83 + 424)) and v70) then
						v31 = v93.HandleIncorporeal(v89.Polymorph, v91.PolymorphMouseover, 94 - (29 + 35));
						if (((1063 - 823) <= (9453 - 6288)) and v31) then
							return v31;
						end
					end
					v212 = 8 - 6;
				end
			end
		end
	end
	local function v155()
		v94();
		v21.Print("Fire Mage rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(42 + 21, v154, v155);
end;
return v0["Epix_Mage_Fire.lua"]();

