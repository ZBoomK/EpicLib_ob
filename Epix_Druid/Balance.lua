local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2014 + 1665) < (1149 - 524))) then
			v6 = v0[v4];
			if (not v6 or ((3058 + 1567) < (352 + 280))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 + 0)) or ((82 + 1) > (2213 - (153 + 280)))) then
			return v6(...);
		end
	end
end
v0["Epix_Druid_Balance.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.MouseOver;
	local v15 = v12.Pet;
	local v16 = v12.Target;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = v10.Macro;
	local v21 = v10.Bind;
	local v22 = v10.AoEON;
	local v23 = v10.CDsON;
	local v24 = v10.Cast;
	local v25 = v10.Press;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
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
	local function v49()
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'] or (0 - 0);
		v35 = EpicSettings.Settings['HealingPotionName'];
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v42 = EpicSettings.Settings['OutOfCombatHealing'];
		v43 = EpicSettings.Settings['MarkOfTheWild'];
		v44 = EpicSettings.Settings['MoonkinFormOOC'];
		v45 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v46 = EpicSettings.Settings['NaturesVigilHP'] or (0 + 0);
		v47 = EpicSettings.Settings['WildMushroom'] or (667 - (89 + 578));
		v48 = EpicSettings.Settings['Starfall'] or (0 + 0);
	end
	local v50 = v10.Commons.Everyone;
	local v51 = v17.Druid.Balance;
	local v52 = v19.Druid.Balance;
	local v53 = {v52.MirrorofFracturedTomorrows:ID()};
	local v54 = v20.Druid.Balance;
	local v55 = v13:GetEquipment();
	local v56 = (v55[1062 - (572 + 477)] and v19(v55[2 + 11])) or v19(0 + 0);
	local v57 = (v55[2 + 12] and v19(v55[100 - (84 + 2)])) or v19(0 - 0);
	local v58 = false;
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
	local v76 = v10.Druid;
	local v77 = 8005 + 3106;
	local v78 = 11953 - (497 + 345);
	local v79 = (v51.IncarnationTalent:IsAvailable() and v51.Incarnation) or v51.CelestialAlignment;
	local v80 = false;
	local v81 = false;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	local v85 = false;
	local v86 = false;
	v10:RegisterForEvent(function()
		v55 = v13:GetEquipment();
		v56 = (v55[1 + 12] and v19(v55[3 + 10])) or v19(1333 - (605 + 728));
		v57 = (v55[10 + 4] and v19(v55[30 - 16])) or v19(0 + 0);
		v58 = false;
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v115 = 0 - 0;
		while true do
			if (((493 + 53) <= (2983 - 1906)) and (v115 == (1 + 0))) then
				v78 = 11600 - (457 + 32);
				break;
			end
			if ((v115 == (0 + 0)) or ((2398 - (832 + 570)) > (4052 + 249))) then
				v58 = false;
				v77 = 2898 + 8213;
				v115 = 3 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v116 = 0 + 0;
		while true do
			if (((4866 - (588 + 208)) > (1851 - 1164)) and (v116 == (1800 - (884 + 916)))) then
				v79 = (v51.IncarnationTalent:IsAvailable() and v51.Incarnation) or v51.CelestialAlignment;
				v58 = false;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v87, v88;
	local function v89(v117)
		local v118 = 0 - 0;
		local v119;
		while true do
			if (((1 + 0) == v118) or ((1309 - (232 + 421)) >= (5219 - (1569 + 320)))) then
				return v119;
			end
			if ((v118 == (0 + 0)) or ((474 + 2018) <= (1128 - 793))) then
				v119 = 605 - (316 + 289);
				if (((11313 - 6991) >= (119 + 2443)) and (v117 == v51.Wrath)) then
					local v162 = 1453 - (666 + 787);
					while true do
						if ((v162 == (426 - (360 + 65))) or ((3400 + 237) >= (4024 - (79 + 175)))) then
							if ((v51.SouloftheForest:IsAvailable() and v13:BuffUp(v51.EclipseSolar)) or ((3750 - 1371) > (3573 + 1005))) then
								v119 = v119 * (2.6 - 1);
							end
							break;
						end
						if ((v162 == (0 - 0)) or ((1382 - (503 + 396)) > (924 - (92 + 89)))) then
							v119 = 15 - 7;
							if (((1259 + 1195) > (343 + 235)) and v51.WildSurges:IsAvailable()) then
								v119 = v119 + (7 - 5);
							end
							v162 = 1 + 0;
						end
					end
				elseif (((2120 - 1190) < (3890 + 568)) and (v117 == v51.Starfire)) then
					v119 = 5 + 5;
					if (((2016 - 1354) <= (122 + 850)) and v51.WildSurges:IsAvailable()) then
						v119 = v119 + (2 - 0);
					end
					if (((5614 - (485 + 759)) == (10111 - 5741)) and v13:BuffUp(v51.WarriorofEluneBuff)) then
						v119 = v119 * (1190.4 - (442 + 747));
					end
					if ((v51.SouloftheForest:IsAvailable() and v13:BuffUp(v51.EclipseLunar)) or ((5897 - (832 + 303)) <= (1807 - (88 + 858)))) then
						local v174 = 0 + 0;
						local v175;
						while true do
							if ((v174 == (1 + 0)) or ((59 + 1353) == (5053 - (766 + 23)))) then
								v119 = v119 * v175;
								break;
							end
							if ((v174 == (0 - 0)) or ((4332 - 1164) < (5672 - 3519))) then
								v175 = (3 - 2) + ((1073.2 - (1036 + 37)) * v88);
								if ((v175 > (1.6 + 0)) or ((9690 - 4714) < (1048 + 284))) then
									v175 = 1481.6 - (641 + 839);
								end
								v174 = 914 - (910 + 3);
							end
						end
					end
				end
				v118 = 2 - 1;
			end
		end
	end
	local function v90(v120)
		local v121 = 1684 - (1466 + 218);
		local v122;
		while true do
			if (((2127 + 2501) == (5776 - (556 + 592))) and (v121 == (0 + 0))) then
				v122 = v120:DebuffRemains(v51.SunfireDebuff);
				return v120:DebuffRefreshable(v51.SunfireDebuff) and (v122 < (810 - (329 + 479))) and ((v120:TimeToDie() - v122) > (860 - (174 + 680)));
			end
		end
	end
	local function v91(v123)
		return v123:DebuffRefreshable(v51.SunfireDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.Sunfire:EnergizeAmount()));
	end
	local function v92(v124)
		local v125 = 0 - 0;
		local v126;
		while true do
			if ((v125 == (0 - 0)) or ((39 + 15) == (1134 - (396 + 343)))) then
				v126 = v124:DebuffRemains(v51.MoonfireDebuff);
				return v124:DebuffRefreshable(v51.MoonfireDebuff) and (v126 < (1 + 1)) and ((v124:TimeToDie() - v126) > (1483 - (29 + 1448)));
			end
		end
	end
	local function v93(v127)
		return v127:DebuffRefreshable(v51.MoonfireDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.Moonfire:EnergizeAmount()));
	end
	local function v94(v128)
		local v129 = 1389 - (135 + 1254);
		local v130;
		while true do
			if (((308 - 226) == (382 - 300)) and (v129 == (0 + 0))) then
				v130 = v128:DebuffRemains(v51.StellarFlareDebuff);
				return v128:DebuffRefreshable(v51.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v130 < (1529 - (389 + 1138))) and ((v128:TimeToDie() - v130) > (582 - (102 + 472)));
			end
		end
	end
	local function v95(v131)
		return v131:DebuffRefreshable(v51.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount()));
	end
	local function v96(v132)
		return v132:DebuffRefreshable(v51.SunfireDebuff) and ((v132:TimeToDie() - v16:DebuffRemains(v51.SunfireDebuff)) > ((6 + 0) - (v88 / (2 + 0)))) and (v13:AstralPowerDeficit() > (v66 + v51.Sunfire:EnergizeAmount()));
	end
	local function v97(v133)
		return v133:DebuffRefreshable(v51.MoonfireDebuff) and ((v133:TimeToDie() - v16:DebuffRemains(v51.MoonfireDebuff)) > (6 + 0)) and (v13:AstralPowerDeficit() > (v66 + v51.Moonfire:EnergizeAmount()));
	end
	local function v98(v134)
		return v134:DebuffRefreshable(v51.StellarFlareDebuff) and (((v134:TimeToDie() - v134:DebuffRemains(v51.StellarFlareDebuff)) - v134:GetEnemiesInSplashRangeCount(1553 - (320 + 1225))) > ((14 - 6) + v88));
	end
	local function v99(v135)
		return v135:DebuffRemains(v51.MoonfireDebuff) > ((v135:DebuffRemains(v51.SunfireDebuff) * (14 + 8)) / (1482 - (157 + 1307)));
	end
	local function v100()
		local v136 = 1859 - (821 + 1038);
		while true do
			if ((v136 == (2 - 1)) or ((64 + 517) < (500 - 218))) then
				v82 = v13:BuffUp(v51.EclipseLunar) and v13:BuffDown(v51.EclipseSolar);
				v83 = v13:BuffUp(v51.EclipseSolar) and v13:BuffDown(v51.EclipseLunar);
				v136 = 1 + 1;
			end
			if ((v136 == (0 - 0)) or ((5635 - (834 + 192)) < (159 + 2336))) then
				v80 = v13:BuffUp(v51.EclipseSolar) or v13:BuffUp(v51.EclipseLunar);
				v81 = v13:BuffUp(v51.EclipseSolar) and v13:BuffUp(v51.EclipseLunar);
				v136 = 1 + 0;
			end
			if (((25 + 1127) == (1783 - 631)) and (v136 == (307 - (300 + 4)))) then
				v86 = not v80 and (v51.Wrath:Count() > (0 + 0)) and (v51.Starfire:Count() > (0 - 0));
				break;
			end
			if (((2258 - (112 + 250)) <= (1365 + 2057)) and (v136 == (4 - 2))) then
				v84 = (not v80 and (((v51.Starfire:Count() == (0 + 0)) and (v51.Wrath:Count() > (0 + 0))) or v13:IsCasting(v51.Wrath))) or v83;
				v85 = (not v80 and (((v51.Wrath:Count() == (0 + 0)) and (v51.Starfire:Count() > (0 + 0))) or v13:IsCasting(v51.Starfire))) or v82;
				v136 = 3 + 0;
			end
		end
	end
	local function v101()
		local v137 = 1414 - (1001 + 413);
		local v138;
		local v139;
		while true do
			if ((v137 == (2 - 1)) or ((1872 - (244 + 638)) > (2313 - (627 + 66)))) then
				v138 = ((v56:IsUsable() or (v56:ID() == v52.SpoilsofNeltharus:ID()) or (v56:ID() == v52.MirrorofFracturedTomorrows:ID())) and (2 - 1)) or (602 - (512 + 90));
				v63 = v63 + v138;
				v137 = 1908 - (1665 + 241);
			end
			if ((v137 == (720 - (373 + 344))) or ((396 + 481) > (1243 + 3452))) then
				v63 = v63 + v139;
				v58 = true;
				break;
			end
			if (((7098 - 4407) >= (3132 - 1281)) and (v137 == (1101 - (35 + 1064)))) then
				v139 = ((v57:IsUsable() or (v57:ID() == v52.SpoilsofNeltharus:ID()) or (v57:ID() == v52.MirrorofFracturedTomorrows:ID())) and (2 + 0)) or (0 - 0);
				v139 = ((v57:ID() == v52.SpoilsofNeltharus:ID()) and (1 + 0)) or (1236 - (298 + 938));
				v137 = 1262 - (233 + 1026);
			end
			if ((v137 == (1666 - (636 + 1030))) or ((1527 + 1458) >= (4744 + 112))) then
				v59 = (not v51.CelestialAlignment:IsAvailable() and not v51.IncarnationTalent:IsAvailable()) or not v23();
				v63 = 0 + 0;
				v137 = 1 + 0;
			end
		end
	end
	local function v102()
		local v140 = 221 - (55 + 166);
		while true do
			if (((829 + 3447) >= (121 + 1074)) and ((0 - 0) == v140)) then
				if (((3529 - (36 + 261)) <= (8202 - 3512)) and v51.MarkOfTheWild:IsCastable() and v50.GroupBuffMissing(v51.MarkOfTheWild)) then
					if (v24(v51.MarkOfTheWild, v43) or ((2264 - (34 + 1334)) >= (1210 + 1936))) then
						return "mark_of_the_wild precombat";
					end
				end
				if (((2379 + 682) >= (4241 - (1035 + 248))) and v51.MoonkinForm:IsCastable()) then
					if (((3208 - (20 + 1)) >= (336 + 308)) and v25(v51.MoonkinForm)) then
						return "moonkin_form";
					end
				end
				v140 = 320 - (134 + 185);
			end
			if (((1777 - (549 + 584)) <= (1389 - (314 + 371))) and (v140 == (3 - 2))) then
				if (((1926 - (478 + 490)) > (502 + 445)) and v51.Wrath:IsCastable() and not v13:IsCasting(v51.Wrath)) then
					if (((5664 - (786 + 386)) >= (8596 - 5942)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath precombat 2";
					end
				end
				if (((4821 - (1055 + 324)) >= (2843 - (1093 + 247))) and v51.Wrath:IsCastable() and ((v13:IsCasting(v51.Wrath) and (v51.Wrath:Count() == (2 + 0))) or (v13:PrevGCD(1 + 0, v51.Wrath) and (v51.Wrath:Count() == (3 - 2))))) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((10758 - 7588) <= (4165 - 2701))) then
						return "wrath precombat 4";
					end
				end
				v140 = 4 - 2;
			end
			if ((v140 == (1 + 1)) or ((18480 - 13683) == (15124 - 10736))) then
				if (((416 + 135) <= (1741 - 1060)) and v51.StellarFlare:IsCastable()) then
					if (((3965 - (364 + 324)) > (1115 - 708)) and v24(v51.StellarFlare, nil, nil, not v16:IsSpellInRange(v51.StellarFlare))) then
						return "stellar_flare precombat 6";
					end
				end
				if (((11266 - 6571) >= (469 + 946)) and v51.Starfire:IsCastable() and not v51.StellarFlare:IsAvailable()) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((13439 - 10227) <= (1511 - 567))) then
						return "starfire precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v103()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (1269 - (1249 + 19))) or ((2795 + 301) <= (6998 - 5200))) then
				if (((4623 - (686 + 400)) == (2776 + 761)) and v51.WildMushroom:IsReady() and not v64) then
					if (((4066 - (73 + 156)) >= (8 + 1562)) and v24(v51.WildMushroom, v47, nil, not v16:IsSpellInRange(v51.WildMushroom))) then
						return "wild_mushroom fallthru 6";
					end
				end
				if (v51.Sunfire:IsCastable() or ((3761 - (721 + 90)) == (43 + 3769))) then
					if (((15334 - 10611) >= (2788 - (224 + 246))) and v50.CastCycle(v51.Sunfire, v87, v99, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire fallthru 8";
					end
				end
				v141 = 2 - 0;
			end
			if ((v141 == (0 - 0)) or ((368 + 1659) > (68 + 2784))) then
				if ((v51.Starfall:IsReady() and v64) or ((835 + 301) > (8582 - 4265))) then
					if (((15800 - 11052) == (5261 - (203 + 310))) and v24(v51.Starfall, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "starfall fallthru 2";
					end
				end
				if (((5729 - (1238 + 755)) <= (332 + 4408)) and v51.Starsurge:IsReady()) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((4924 - (709 + 825)) <= (5638 - 2578))) then
						return "starsurge fallthru 4";
					end
				end
				v141 = 1 - 0;
			end
			if ((v141 == (866 - (196 + 668))) or ((3944 - 2945) > (5578 - 2885))) then
				if (((1296 - (171 + 662)) < (694 - (4 + 89))) and v51.Moonfire:IsCastable()) then
					if (v24(v51.Moonfire, nil, nil, not v16:IsSpellInRange(v51.Moonfire)) or ((7651 - 5468) < (251 + 436))) then
						return "moonfire fallthru 10";
					end
				end
				break;
			end
		end
	end
	local function v104()
		local v142 = 0 - 0;
		local v143;
		local v144;
		local v145;
		while true do
			if (((1784 + 2765) == (6035 - (35 + 1451))) and (v142 == (1461 - (28 + 1425)))) then
				if (((6665 - (941 + 1052)) == (4480 + 192)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (1516 - (822 + 692))) and v144) then
					if (v25(v54.CancelStarlord, false, "CANCEL") or ((5236 - 1568) < (187 + 208))) then
						return "cancel_buff starlord st 53";
					end
				end
				if ((v51.Starsurge:IsReady() and v144) or ((4463 - (45 + 252)) == (451 + 4))) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((1532 + 2917) == (6480 - 3817))) then
						return "starsurge st 54";
					end
				end
				if ((v51.Wrath:IsCastable() and not v13:IsMoving()) or ((4710 - (114 + 319)) < (4290 - 1301))) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((1114 - 244) >= (2645 + 1504))) then
						return "wrath st 60";
					end
				end
				v145 = v103();
				v142 = 12 - 3;
			end
			if (((4634 - 2422) < (5146 - (556 + 1407))) and (v142 == (1212 - (741 + 465)))) then
				if (((5111 - (170 + 295)) > (1577 + 1415)) and v51.Starsurge:IsReady() and v143) then
					if (((1318 + 116) < (7646 - 4540)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge st 40";
					end
				end
				if (((652 + 134) < (1939 + 1084)) and v51.Sunfire:IsCastable()) then
					if (v50.CastCycle(v51.Sunfire, v87, v91, not v16:IsSpellInRange(v51.Sunfire)) or ((1383 + 1059) < (1304 - (957 + 273)))) then
						return "sunfire st 42";
					end
				end
				if (((1213 + 3322) == (1816 + 2719)) and v51.Moonfire:IsCastable()) then
					if (v50.CastCycle(v51.Moonfire, v87, v93, not v16:IsSpellInRange(v51.Moonfire)) or ((11465 - 8456) <= (5547 - 3442))) then
						return "moonfire st 44";
					end
				end
				if (((5589 - 3759) < (18167 - 14498)) and v51.StellarFlare:IsCastable()) then
					if (v50.CastCycle(v51.StellarFlare, v87, v95, not v16:IsSpellInRange(v51.StellarFlare)) or ((3210 - (389 + 1391)) >= (2267 + 1345))) then
						return "stellar_flare st 46";
					end
				end
				v142 = 1 + 6;
			end
			if (((6108 - 3425) >= (3411 - (783 + 168))) and (v142 == (30 - 21))) then
				if (v145 or ((1775 + 29) >= (3586 - (309 + 2)))) then
					return v145;
				end
				if (v10.CastAnnotated(v51.Pool, false, "MOVING") or ((4351 - 2934) > (4841 - (1090 + 122)))) then
					return "Pool ST due to movement and no fallthru";
				end
				break;
			end
			if (((1555 + 3240) > (1349 - 947)) and (v142 == (1 + 0))) then
				if (((5931 - (628 + 490)) > (640 + 2925)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (4 - 2)) and (((v72 >= (2513 - 1963)) and not v73 and v13:BuffUp(v51.StarweaversWarp)) or ((v72 >= (1334 - (431 + 343))) and v13:BuffUp(v51.StarweaversWeft)))) then
					if (((7900 - 3988) == (11316 - 7404)) and v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 11";
					end
				end
				if (((2229 + 592) <= (618 + 4206)) and v51.Starfall:IsReady() and (v72 >= (2245 - (556 + 1139))) and not v73 and v13:BuffUp(v51.StarweaversWarp)) then
					if (((1753 - (6 + 9)) <= (402 + 1793)) and v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "starfall st 12";
					end
				end
				if (((22 + 19) <= (3187 - (28 + 141))) and v51.Starsurge:IsReady() and (v72 >= (217 + 343)) and v13:BuffUp(v51.StarweaversWeft)) then
					if (((2647 - 502) <= (2907 + 1197)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge st 13";
					end
				end
				if (((4006 - (486 + 831)) < (12607 - 7762)) and v51.Starfire:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v67 and v82) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((8174 - 5852) > (496 + 2126))) then
						return "starfire st 14";
					end
				end
				v142 = 6 - 4;
			end
			if ((v142 == (1270 - (668 + 595))) or ((4080 + 454) == (420 + 1662))) then
				if ((v51.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.NewMoon:EnergizeAmount())) and (v73 or ((v51.NewMoon:ChargesFractional() > (5.5 - 3)) and (v72 <= (810 - (23 + 267))) and (v79:CooldownRemains() > (1954 - (1129 + 815)))) or (v78 < (397 - (371 + 16))))) or ((3321 - (1326 + 424)) > (3535 - 1668))) then
					if (v24(v51.NewMoon, nil, nil, not v16:IsSpellInRange(v51.NewMoon)) or ((9698 - 7044) >= (3114 - (88 + 30)))) then
						return "new_moon st 48";
					end
				end
				if (((4749 - (720 + 51)) > (4680 - 2576)) and v51.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.HalfMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.HalfMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (1778.5 - (421 + 1355))) and (v72 <= (857 - 337)) and (v79:CooldownRemains() > (5 + 5))) or (v78 < (1093 - (286 + 797))))) then
					if (((10948 - 7953) > (2552 - 1011)) and v24(v51.HalfMoon, nil, nil, not v16:IsSpellInRange(v51.HalfMoon))) then
						return "half_moon st 50";
					end
				end
				if (((3688 - (397 + 42)) > (298 + 655)) and v51.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (802.5 - (24 + 776))) and (v72 <= (801 - 281)) and (v79:CooldownRemains() > (795 - (222 + 563)))) or (v78 < (22 - 12)))) then
					if (v24(v51.FullMoon, nil, nil, not v16:IsSpellInRange(v51.FullMoon)) or ((2357 + 916) > (4763 - (23 + 167)))) then
						return "full_moon st 52";
					end
				end
				v144 = v13:BuffUp(v51.StarweaversWeft) or (v13:AstralPowerDeficit() < (v66 + v89(v51.Wrath) + ((v89(v51.Starfire) + v66) * (v26(v13:BuffRemains(v51.EclipseSolar) < (v13:GCD() * (1801 - (690 + 1108)))))))) or (v51.AstralCommunion:IsAvailable() and (v51.AstralCommunion:CooldownRemains() < (2 + 1))) or (v78 < (5 + 0));
				v142 = 856 - (40 + 808);
			end
			if ((v142 == (0 + 0)) or ((12049 - 8898) < (1228 + 56))) then
				if (v51.Sunfire:IsCastable() or ((979 + 871) == (839 + 690))) then
					if (((1392 - (47 + 524)) < (1378 + 745)) and v50.CastCycle(v51.Sunfire, v87, v90, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire st 2";
					end
				end
				v67 = v30 and (v79:CooldownRemains() < (13 - 8)) and not v73 and (((v16:TimeToDie() > (22 - 7)) and (v72 < (1094 - 614))) or (v78 < ((1751 - (1165 + 561)) + ((1 + 9) * v26(v51.Incarnation:IsAvailable())))));
				if (((2793 - 1891) < (888 + 1437)) and v51.Moonfire:IsCastable()) then
					if (((1337 - (341 + 138)) <= (800 + 2162)) and v50.CastCycle(v51.Moonfire, v87, v92, not v16:IsSpellInRange(v51.Moonfire))) then
						return "moonfire st 6";
					end
				end
				if (v51.StellarFlare:IsCastable() or ((8143 - 4197) < (1614 - (89 + 237)))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v94, not v16:IsSpellInRange(v51.StellarFlare)) or ((10429 - 7187) == (1193 - 626))) then
						return "stellar_flare st 10";
					end
				end
				v142 = 882 - (581 + 300);
			end
			if ((v142 == (1225 - (855 + 365))) or ((2011 - 1164) >= (413 + 850))) then
				if ((v51.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (1237 - (1030 + 205))) and ((v74 > (3 + 0)) or ((v79:CooldownRemains() > (28 + 2)) and (v72 <= (566 - (156 + 130)))) or ((v72 >= (1272 - 712)) and (v13:AstralPowerP() > (84 - 34))))) or (v78 < (20 - 10)))) or ((594 + 1659) == (1080 + 771))) then
					if (v24(v51.FuryOfElune, nil, not v16:IsSpellInRange(v51.FuryOfElune)) or ((2156 - (10 + 59)) > (671 + 1701))) then
						return "fury_of_elune st 36";
					end
				end
				if ((v51.Starfall:IsReady() and (v13:BuffUp(v51.StarweaversWarp))) or ((21890 - 17445) < (5312 - (671 + 492)))) then
					if (v24(v51.Starfall, nil, not v16:IsSpellInRange(v51.Wrath)) or ((1448 + 370) == (1300 - (369 + 846)))) then
						return "starfall st 38";
					end
				end
				v143 = (v51.Starlord:IsAvailable() and (v13:BuffStack(v51.StarlordBuff) < (1 + 2))) or (((v13:BuffStack(v51.BOATArcaneBuff) + v13:BuffStack(v51.BOATNatureBuff)) > (2 + 0)) and (v13:BuffRemains(v51.StarlordBuff) > (1949 - (1036 + 909))));
				if (((501 + 129) < (3570 - 1443)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (205 - (11 + 192))) and v143) then
					if (v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL") or ((980 + 958) == (2689 - (135 + 40)))) then
						return "cancel_buff starlord st 39";
					end
				end
				v142 = 14 - 8;
			end
			if (((2565 + 1690) >= (120 - 65)) and (v142 == (5 - 1))) then
				if (((3175 - (50 + 126)) > (3218 - 2062)) and v51.Starsurge:IsReady() and v51.ConvokeTheSpirits:IsAvailable() and v51.ConvokeTheSpirits:IsCastable() and v71) then
					if (((521 + 1829) > (2568 - (1233 + 180))) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge st 28";
					end
				end
				if (((4998 - (522 + 447)) <= (6274 - (107 + 1314))) and v51.ConvokeTheSpirits:IsCastable() and v23() and v71) then
					if (v24(v51.ConvokeTheSpirits, nil, not v16:IsSpellInRange(v51.Wrath)) or ((240 + 276) > (10463 - 7029))) then
						return "convoke_the_spirits st 30";
					end
				end
				if (((1719 + 2327) >= (6022 - 2989)) and v51.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.AstralCommunion:EnergizeAmount()))) then
					if (v24(v51.AstralCommunion) or ((10757 - 8038) <= (3357 - (716 + 1194)))) then
						return "astral_communion st 32";
					end
				end
				if ((v51.ForceOfNature:IsCastable() and v23() and (v13:AstralPowerDeficit() > (v66 + v51.ForceOfNature:EnergizeAmount()))) or ((71 + 4063) < (421 + 3505))) then
					if (v24(v51.ForceOfNature, nil, not v16:IsSpellInRange(v51.Wrath)) or ((667 - (74 + 429)) >= (5372 - 2587))) then
						return "force_of_nature st 34";
					end
				end
				v142 = 3 + 2;
			end
			if ((v142 == (4 - 2)) or ((372 + 153) == (6501 - 4392))) then
				if (((81 - 48) == (466 - (279 + 154))) and v51.Wrath:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v67 and v13:BuffUp(v51.EclipseSolar)) then
					if (((3832 - (454 + 324)) <= (3159 + 856)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath st 15";
					end
				end
				if (((1888 - (12 + 5)) < (1824 + 1558)) and v30) then
					local v163 = 0 - 0;
					while true do
						if (((478 + 815) <= (3259 - (277 + 816))) and (v163 == (0 - 0))) then
							if ((v51.CelestialAlignment:IsCastable() and v67) or ((3762 - (1058 + 125)) < (24 + 99))) then
								if (v25(v51.CelestialAlignment) or ((1821 - (815 + 160)) >= (10160 - 7792))) then
									return "celestial_alignment st 16";
								end
							end
							if ((v51.Incarnation:IsCastable() and v67) or ((9523 - 5511) <= (802 + 2556))) then
								if (((4367 - 2873) <= (4903 - (41 + 1857))) and v25(v51.Incarnation)) then
									return "incarnation st 18";
								end
							end
							break;
						end
					end
				end
				v62 = ((v72 < (2413 - (1222 + 671))) and (v79:CooldownRemains() > (12 - 7)) and (v88 < (3 - 0))) or v13:HasTier(1213 - (229 + 953), 1776 - (1111 + 663));
				v69 = v86 or (v62 and v13:BuffUp(v51.EclipseSolar) and (v13:BuffRemains(v51.EclipseSolar) < v51.Starfire:CastTime())) or (not v62 and v13:BuffUp(v51.EclipseLunar) and (v13:BuffRemains(v51.EclipseLunar) < v51.Wrath:CastTime()));
				v142 = 1582 - (874 + 705);
			end
			if ((v142 == (1 + 2)) or ((2123 + 988) == (4435 - 2301))) then
				if (((67 + 2288) == (3034 - (642 + 37))) and v51.WarriorofElune:IsCastable() and v62 and (v69 or (v13:BuffRemains(v51.EclipseSolar) < (2 + 5)))) then
					if (v24(v51.WarriorofElune) or ((95 + 493) <= (1084 - 652))) then
						return "warrior_of_elune st 20";
					end
				end
				if (((5251 - (233 + 221)) >= (9006 - 5111)) and v51.Starfire:IsCastable() and v69 and (v62 or v13:BuffUp(v51.EclipseSolar))) then
					if (((3149 + 428) == (5118 - (718 + 823))) and v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire))) then
						return "starfire st 24";
					end
				end
				if (((2388 + 1406) > (4498 - (266 + 539))) and v51.Wrath:IsCastable() and v69) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((3609 - 2334) == (5325 - (636 + 589)))) then
						return "wrath st 26";
					end
				end
				v71 = (v74 > (9 - 5)) or (((v79:CooldownRemains() > (61 - 31)) or v59) and ((v13:BuffRemains(v51.EclipseLunar) > (4 + 0)) or (v13:BuffRemains(v51.EclipseSolar) > (2 + 2))));
				v142 = 1019 - (657 + 358);
			end
		end
	end
	local function v105()
		local v146 = 0 - 0;
		local v147;
		local v148;
		local v149;
		local v150;
		local v151;
		local v152;
		local v153;
		while true do
			if ((v146 == (8 - 4)) or ((2778 - (1151 + 36)) >= (3458 + 122))) then
				if (((259 + 724) <= (5399 - 3591)) and v51.ConvokeTheSpirits:IsCastable() and v23() and (v13:AstralPowerP() < (1882 - (1552 + 280))) and (v88 < ((837 - (64 + 770)) + v26(v51.ElunesGuidance:IsAvailable()))) and ((v13:BuffRemains(v51.EclipseLunar) > (3 + 1)) or (v13:BuffRemains(v51.EclipseSolar) > (8 - 4)))) then
					if (v24(v51.ConvokeTheSpirits, nil, not v16:IsInRange(8 + 32)) or ((3393 - (157 + 1086)) <= (2395 - 1198))) then
						return "convoke_the_spirits aoe 36";
					end
				end
				if (((16507 - 12738) >= (1798 - 625)) and v51.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.NewMoon:EnergizeAmount()))) then
					if (((2026 - 541) == (2304 - (599 + 220))) and v24(v51.NewMoon, nil, nil, not v16:IsSpellInRange(v51.NewMoon))) then
						return "new_moon aoe 38";
					end
				end
				if ((v51.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime()))) or ((6601 - 3286) <= (4713 - (1813 + 118)))) then
					if (v24(v51.HalfMoon, nil, nil, not v16:IsSpellInRange(v51.HalfMoon)) or ((641 + 235) >= (4181 - (841 + 376)))) then
						return "half_moon aoe 40";
					end
				end
				if ((v51.ForceOfNature:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.ForceOfNature:EnergizeAmount()))) or ((3127 - 895) > (581 + 1916))) then
					if (v24(v51.ForceOfNature, nil, not v16:IsSpellInRange(v51.Wrath)) or ((5759 - 3649) <= (1191 - (464 + 395)))) then
						return "force_of_nature aoe 42";
					end
				end
				if (((9459 - 5773) > (1524 + 1648)) and v51.Starsurge:IsReady() and v13:BuffUp(v51.StarweaversWeft) and (v88 < (854 - (467 + 370)))) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((9245 - 4771) < (602 + 218))) then
						return "starsurge aoe 44";
					end
				end
				v151 = 0 - 0;
				v146 = 1 + 4;
			end
			if (((9954 - 5675) >= (3402 - (150 + 370))) and (v146 == (1283 - (74 + 1208)))) then
				v148 = (v68 and ((v51.OrbitalStrike:IsAvailable() and (v13:AstralPowerDeficit() < (v66 + ((19 - 11) * v88)))) or v13:BuffUp(v51.TouchtheCosmos))) or (v13:AstralPowerDeficit() < (v66 + (37 - 29) + ((9 + 3) * v26((v13:BuffRemains(v51.EclipseLunar) < (394 - (14 + 376))) or (v13:BuffRemains(v51.EclipseSolar) < (6 - 2))))));
				if ((v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (2 + 0)) and v148) or ((1783 + 246) >= (3359 + 162))) then
					if (v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL") or ((5968 - 3931) >= (3493 + 1149))) then
						return "cancel_buff starlord aoe 9.5";
					end
				end
				if (((1798 - (23 + 55)) < (10565 - 6107)) and v51.Starfall:IsReady() and v148) then
					if (v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath)) or ((291 + 145) > (2713 + 308))) then
						return "starfall aoe 10";
					end
				end
				if (((1104 - 391) <= (267 + 580)) and v51.Starfire:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v68 and v13:BuffUp(v51.EclipseLunar)) then
					if (((3055 - (652 + 249)) <= (10787 - 6756)) and v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire))) then
						return "starfire aoe 11";
					end
				end
				if (((6483 - (708 + 1160)) == (12527 - 7912)) and v30) then
					local v164 = 0 - 0;
					while true do
						if (((27 - (10 + 17)) == v164) or ((852 + 2938) == (2232 - (1400 + 332)))) then
							if (((170 - 81) < (2129 - (242 + 1666))) and v51.CelestialAlignment:IsCastable() and v68) then
								if (((879 + 1175) >= (521 + 900)) and v25(v51.CelestialAlignment)) then
									return "celestial_alignment aoe 10";
								end
							end
							if (((590 + 102) < (3998 - (850 + 90))) and v51.Incarnation:IsCastable() and v68) then
								if (v25(v51.Incarnation) or ((5699 - 2445) == (3045 - (360 + 1030)))) then
									return "celestial_alignment aoe 12";
								end
							end
							break;
						end
					end
				end
				if (v51.WarriorofElune:IsCastable() or ((1147 + 149) == (13858 - 8948))) then
					if (((4633 - 1265) == (5029 - (909 + 752))) and v25(v51.WarriorofElune)) then
						return "warrior_of_elune aoe 14";
					end
				end
				v146 = 1225 - (109 + 1114);
			end
			if (((4838 - 2195) < (1486 + 2329)) and (v146 == (244 - (6 + 236)))) then
				v149 = v88 < (2 + 1);
				if (((1540 + 373) > (1162 - 669)) and v51.Starfire:IsCastable() and v149 and (v86 or (v13:BuffRemains(v51.EclipseSolar) < v51.Starfire:CastTime()))) then
					if (((8305 - 3550) > (4561 - (1076 + 57))) and v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire))) then
						return "starfire aoe 17";
					end
				end
				if (((228 + 1153) <= (3058 - (579 + 110))) and v51.Wrath:IsCastable() and not v149 and (v86 or (v13:BuffRemains(v51.EclipseLunar) < v51.Wrath:CastTime()))) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((383 + 4460) == (3611 + 473))) then
						return "wrath aoe 18";
					end
				end
				if (((2478 + 2191) > (770 - (174 + 233))) and v51.WildMushroom:IsCastable() and (v13:AstralPowerDeficit() > (v66 + (55 - 35))) and (not v51.WaningTwilight:IsAvailable() or ((v16:DebuffRemains(v51.FungalGrowthDebuff) < (3 - 1)) and (v16:TimeToDie() > (4 + 3)) and not v13:PrevGCDP(1175 - (663 + 511), v51.WildMushroom)))) then
					if (v24(v51.WildMushroom, v47, nil, not v16:IsSpellInRange(v51.WildMushroom)) or ((1675 + 202) >= (682 + 2456))) then
						return "wild_mushroom aoe 20";
					end
				end
				if (((14619 - 9877) >= (2196 + 1430)) and v51.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (4 - 2)) and ((v74 > (7 - 4)) or ((v79:CooldownRemains() > (15 + 15)) and (v72 <= (544 - 264))) or ((v72 >= (400 + 160)) and (v13:AstralPowerP() > (5 + 45))))) or (v78 < (732 - (478 + 244))))) then
					if (v24(v51.FuryOfElune, nil, not v16:IsSpellInRange(v51.FuryOfElune)) or ((5057 - (440 + 77)) == (417 + 499))) then
						return "fury_of_elune aoe 22";
					end
				end
				v150 = (v16:TimeToDie() > (14 - 10)) and (v13:BuffUp(v51.StarweaversWarp) or (v51.Starlord:IsAvailable() and (v13:BuffStack(v51.StarlordBuff) < (1559 - (655 + 901)))));
				v146 = 1 + 2;
			end
			if ((v146 == (4 + 1)) or ((781 + 375) > (17504 - 13159))) then
				v152 = 1445 - (695 + 750);
				if (((7638 - 5401) < (6556 - 2307)) and v13:BuffUp(v51.EclipseLunar)) then
					local v165 = 0 - 0;
					local v166;
					local v167;
					local v168;
					while true do
						if ((v165 == (352 - (285 + 66))) or ((6254 - 3571) < (1333 - (682 + 628)))) then
							v168 = (v167 - (3 + 12)) / (301 - (176 + 123));
							break;
						end
						if (((292 + 405) <= (600 + 226)) and (v165 == (269 - (239 + 30)))) then
							v166 = v13:BuffInfo(v51.EclipseLunar, nil, true);
							v167 = v166.points[1 + 0];
							v165 = 1 + 0;
						end
					end
				end
				if (((1955 - 850) <= (3668 - 2492)) and v13:BuffUp(v51.EclipseSolar)) then
					local v169 = v13:BuffInfo(v51.EclipseSolar, nil, true);
					local v170 = v169.points[316 - (306 + 9)];
					local v171 = (v170 - (52 - 37)) / (1 + 1);
				end
				if (((2074 + 1305) <= (1835 + 1977)) and v51.Starfire:IsCastable() and not v13:IsMoving() and (((v88 > ((8 - 5) - (v26(v13:BuffUp(v51.DreamstateBuff) or (v151 > v152))))) and v13:BuffUp(v51.EclipseLunar)) or v82)) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((2163 - (1140 + 235)) >= (1029 + 587))) then
						return "starfire aoe 46";
					end
				end
				if (((1701 + 153) <= (868 + 2511)) and v51.Wrath:IsCastable() and not v13:IsMoving()) then
					if (((4601 - (33 + 19)) == (1643 + 2906)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath aoe 48";
					end
				end
				v153 = v103();
				v146 = 17 - 11;
			end
			if ((v146 == (3 + 3)) or ((5926 - 2904) >= (2836 + 188))) then
				if (((5509 - (586 + 103)) > (201 + 1997)) and v153) then
					return v153;
				end
				if (v10.CastAnnotated(v51.Pool, false, "MOVING") or ((3266 - 2205) >= (6379 - (1309 + 179)))) then
					return "Pool AoE due to movement and no fallthru";
				end
				break;
			end
			if (((2461 - 1097) <= (1947 + 2526)) and ((7 - 4) == v146)) then
				if ((v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (2 + 0)) and v150) or ((7638 - 4043) <= (5 - 2))) then
					if (v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL") or ((5281 - (295 + 314)) == (9461 - 5609))) then
						return "cancel_buff starlord aoe 23";
					end
				end
				if (((3521 - (1300 + 662)) == (4895 - 3336)) and v51.Starfall:IsReady() and v150) then
					if (v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath)) or ((3507 - (1178 + 577)) <= (410 + 378))) then
						return "starfall aoe 24";
					end
				end
				if ((v51.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (5.5 - 3)) and (v72 <= (1925 - (851 + 554))) and (v79:CooldownRemains() > (9 + 1))) or (v78 < (27 - 17)))) or ((8484 - 4577) == (479 - (115 + 187)))) then
					if (((2658 + 812) > (526 + 29)) and v24(v51.FullMoon, nil, nil, not v16:IsSpellInRange(v51.FullMoon))) then
						return "full_moon aoe 26";
					end
				end
				if ((v51.Starsurge:IsReady() and v13:BuffUp(v51.StarweaversWeft) and (v88 < (11 - 8))) or ((2133 - (160 + 1001)) == (565 + 80))) then
					if (((2196 + 986) >= (4329 - 2214)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge aoe 30";
					end
				end
				if (((4251 - (237 + 121)) < (5326 - (525 + 372))) and v51.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v88 < (((20 - 9) - v51.UmbralIntensity:TalentRank()) - v51.AstralSmolder:TalentRank()))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v98, not v16:IsSpellInRange(v51.StellarFlare)) or ((9419 - 6552) < (2047 - (96 + 46)))) then
						return "stellar_flare aoe 32";
					end
				end
				if ((v51.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.AstralCommunion:EnergizeAmount()))) or ((2573 - (643 + 134)) >= (1463 + 2588))) then
					if (((3881 - 2262) <= (13944 - 10188)) and v24(v51.ForceOfNature)) then
						return "astral_communion aoe 34";
					end
				end
				v146 = 4 + 0;
			end
			if (((1184 - 580) == (1234 - 630)) and (v146 == (719 - (316 + 403)))) then
				v147 = v13:IsInParty() and not v13:IsInRaid();
				if ((v51.Moonfire:IsCastable() and v147) or ((2981 + 1503) == (2474 - 1574))) then
					if (v50.CastCycle(v51.Moonfire, v87, v97, not v16:IsSpellInRange(v51.Moonfire)) or ((1612 + 2847) <= (2802 - 1689))) then
						return "moonfire aoe 2";
					end
				end
				v68 = v23() and (v79:CooldownRemains() < (4 + 1)) and not v73 and (((v16:TimeToDie() > (4 + 6)) and (v72 < (1732 - 1232))) or (v78 < ((119 - 94) + ((20 - 10) * v26(v51.Incarnation:IsAvailable())))));
				if (((208 + 3424) > (6688 - 3290)) and v51.Sunfire:IsCastable()) then
					if (((200 + 3882) <= (14466 - 9549)) and v50.CastCycle(v51.Sunfire, v87, v96, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire aoe 4";
					end
				end
				if (((4849 - (12 + 5)) >= (5383 - 3997)) and v51.Moonfire:IsCastable() and not v147) then
					if (((292 - 155) == (290 - 153)) and v50.CastCycle(v51.Moonfire, v87, v97, not v16:IsSpellInRange(v51.Moonfire))) then
						return "moonfire aoe 6";
					end
				end
				if ((v51.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v88 < (((27 - 16) - v51.UmbralIntensity:TalentRank()) - v51.AstralSmolder:TalentRank())) and v68) or ((319 + 1251) >= (6305 - (1656 + 317)))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v98, not v16:IsSpellInRange(v51.StellarFlare)) or ((3622 + 442) <= (1458 + 361))) then
						return "stellar_flare aoe 9";
					end
				end
				v146 = 2 - 1;
			end
		end
	end
	local function v106()
		local v154 = 0 - 0;
		local v155;
		while true do
			if ((v154 == (354 - (5 + 349))) or ((23682 - 18696) < (2845 - (266 + 1005)))) then
				v155 = v50.HandleTopTrinket(v53, v30, 27 + 13, nil);
				if (((15101 - 10675) > (226 - 54)) and v155) then
					return v155;
				end
				v154 = 1697 - (561 + 1135);
			end
			if (((762 - 176) > (1495 - 1040)) and (v154 == (1067 - (507 + 559)))) then
				v155 = v50.HandleBottomTrinket(v53, v30, 100 - 60, nil);
				if (((2554 - 1728) == (1214 - (212 + 176))) and v155) then
					return v155;
				end
				break;
			end
		end
	end
	local function v107()
		C_Timer.After(905.15 - (250 + 655), function()
			local v156 = 0 - 0;
			while true do
				if ((v156 == (1 - 0)) or ((6287 - 2268) > (6397 - (1869 + 87)))) then
					v28 = EpicSettings.Toggles['ooc'];
					v29 = EpicSettings.Toggles['aoe'];
					v156 = 6 - 4;
				end
				if (((3918 - (484 + 1417)) < (9132 - 4871)) and (v156 == (2 - 0))) then
					v30 = EpicSettings.Toggles['cds'];
					v31 = EpicSettings.Toggles['toggle'];
					v156 = 776 - (48 + 725);
				end
				if (((7703 - 2987) > (214 - 134)) and (v156 == (3 + 1))) then
					if (v29 or ((9371 - 5864) == (916 + 2356))) then
						v88 = v16:GetEnemiesInSplashRangeCount(3 + 7);
					else
						v88 = 854 - (152 + 701);
					end
					if ((not v13:IsChanneling() and v31) or ((2187 - (430 + 881)) >= (1178 + 1897))) then
						local v172 = 895 - (557 + 338);
						while true do
							if (((1287 + 3065) > (7196 - 4642)) and (v172 == (0 - 0))) then
								if (v13:AffectingCombat() or ((11705 - 7299) < (8712 - 4669))) then
									local v176 = 801 - (499 + 302);
									while true do
										if (((867 - (39 + 827)) == v176) or ((5214 - 3325) >= (7555 - 4172))) then
											if (((7514 - 5622) <= (4197 - 1463)) and (v13:HealthPercentage() <= v38) and v37 and v52.Healthstone:IsReady()) then
												if (((165 + 1758) < (6491 - 4273)) and v25(v54.Healthstone, nil, nil, true)) then
													return "healthstone defensive 4";
												end
											end
											break;
										end
										if (((348 + 1825) > (599 - 220)) and (v176 == (104 - (103 + 1)))) then
											if (((v13:HealthPercentage() <= v46) and v51.NaturesVigil:IsReady()) or ((3145 - (475 + 79)) == (7369 - 3960))) then
												if (((14444 - 9930) > (430 + 2894)) and v25(v51.NaturesVigil, nil, nil, true)) then
													return "barkskin defensive 2";
												end
											end
											if (((v13:HealthPercentage() <= v45) and v51.Barkskin:IsReady()) or ((184 + 24) >= (6331 - (1395 + 108)))) then
												if (v25(v51.Barkskin, nil, nil, true) or ((4606 - 3023) > (4771 - (7 + 1197)))) then
													return "barkskin defensive 2";
												end
											end
											v176 = 1 + 0;
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((459 + 854) == (1113 - (27 + 292)))) then
									local v177 = 0 - 0;
									local v178;
									while true do
										if (((4046 - 872) > (12170 - 9268)) and (v177 == (0 - 0))) then
											v178 = v50.DeadFriendlyUnitsCount();
											if (((7846 - 3726) <= (4399 - (43 + 96))) and v13:AffectingCombat()) then
												if (v51.Rebirth:IsCastable() or ((3601 - 2718) > (10802 - 6024))) then
													if (v25(v51.Rebirth, nil, true) or ((3004 + 616) >= (1382 + 3509))) then
														return "rebirth";
													end
												end
											elseif (((8415 - 4157) > (360 + 577)) and v51.Revive:IsCastable()) then
												if (v25(v51.Revive, not v16:IsInRange(74 - 34), true) or ((1533 + 3336) < (67 + 839))) then
													return "revive";
												end
											end
											break;
										end
									end
								end
								v172 = 1752 - (1414 + 337);
							end
							if ((v172 == (1941 - (1642 + 298))) or ((3193 - 1968) > (12163 - 7935))) then
								if (((9875 - 6547) > (737 + 1501)) and v50.TargetIsValid() and not v58) then
									v101();
								end
								if (((2987 + 852) > (2377 - (357 + 615))) and (v50.TargetIsValid() or v13:AffectingCombat())) then
									local v179 = 0 + 0;
									while true do
										if ((v179 == (9 - 5)) or ((1108 + 185) <= (1086 - 579))) then
											if (v73 or ((2317 + 579) < (55 + 750))) then
												v74 = (v51.IncarnationTalent:IsAvailable() and v13:BuffRemains(v51.IncarnationBuff)) or v13:BuffRemains(v51.CABuff);
											end
											break;
										end
										if (((1456 + 860) == (3617 - (384 + 917))) and (v179 == (698 - (128 + 569)))) then
											v78 = v77;
											if ((v78 == (12654 - (1407 + 136))) or ((4457 - (687 + 1200)) == (3243 - (556 + 1154)))) then
												v78 = v10.FightRemains(v87, false);
											end
											v179 = 6 - 4;
										end
										if ((v179 == (97 - (9 + 86))) or ((1304 - (275 + 146)) == (238 + 1222))) then
											v72 = 64 - (29 + 35);
											if (v51.PrimordialArcanicPulsar:IsAvailable() or ((20471 - 15852) <= (2983 - 1984))) then
												local v186 = 0 - 0;
												local v187;
												while true do
													if ((v186 == (0 + 0)) or ((4422 - (53 + 959)) > (4524 - (312 + 96)))) then
														v187 = v13:BuffInfo(v51.PAPBuff, false, true);
														if ((v187 ~= nil) or ((1566 - 663) >= (3344 - (147 + 138)))) then
															v72 = v187.points[900 - (813 + 86)];
														end
														break;
													end
												end
											end
											v179 = 3 + 0;
										end
										if ((v179 == (0 - 0)) or ((4468 - (18 + 474)) < (964 + 1893))) then
											v75 = true;
											v77 = v10.BossFightRemains();
											v179 = 3 - 2;
										end
										if (((6016 - (860 + 226)) > (2610 - (121 + 182))) and (v179 == (1 + 2))) then
											v73 = v13:BuffUp(v51.CABuff) or v13:BuffUp(v51.IncarnationBuff);
											v74 = 1240 - (988 + 252);
											v179 = 1 + 3;
										end
									end
								end
								v172 = 1 + 1;
							end
							if ((v172 == (1972 - (49 + 1921))) or ((4936 - (223 + 667)) < (1343 - (51 + 1)))) then
								if (not v13:AffectingCombat() or ((7299 - 3058) == (7591 - 4046))) then
									if ((v51.MoonkinForm:IsCastable() and v44) or ((5173 - (146 + 979)) > (1195 + 3037))) then
										if (v25(v51.MoonkinForm) or ((2355 - (311 + 294)) >= (9685 - 6212))) then
											return "moonkin_form ooc";
										end
									end
								end
								if (((1342 + 1824) == (4609 - (496 + 947))) and ((v50.TargetIsValid() and v28) or v13:AffectingCombat())) then
									if (((3121 - (1233 + 125)) < (1512 + 2212)) and v34 and (v13:HealthPercentage() <= v36)) then
										local v181 = 0 + 0;
										while true do
											if (((11 + 46) <= (4368 - (963 + 682))) and (v181 == (0 + 0))) then
												if ((v35 == "Refreshing Healing Potion") or ((3574 - (504 + 1000)) == (299 + 144))) then
													if (v52.RefreshingHealingPotion:IsReady() or ((2464 + 241) == (132 + 1261))) then
														if (v10.Press(v54.RefreshingHealingPotion) or ((6784 - 2183) < (53 + 8))) then
															return "refreshing healing potion defensive 4";
														end
													end
												end
												if ((v35 == "Dreamwalker's Healing Potion") or ((809 + 581) >= (4926 - (156 + 26)))) then
													if (v52.DreamwalkersHealingPotion:IsReady() or ((1154 + 849) > (5998 - 2164))) then
														if (v10.Press(v54.RefreshingHealingPotion) or ((320 - (149 + 15)) > (4873 - (890 + 70)))) then
															return "dreamwalkers healing potion defensive";
														end
													end
												end
												break;
											end
										end
									end
									v100();
									if (((312 - (39 + 78)) == (677 - (14 + 468))) and not v13:AffectingCombat()) then
										local v182 = v102();
										if (((6827 - 3722) >= (5019 - 3223)) and v182) then
											return v182;
										end
									end
									v64 = (v88 > (1 + 0 + v26(not v51.AetherialKindling:IsAvailable() and not v51.Starweaver:IsAvailable()))) and v51.Starfall:IsAvailable();
									v65 = v88 > (1 + 0);
									v66 = ((2 + 4) / v13:SpellHaste()) + v26(v51.NaturesBalance:IsAvailable()) + (v26(v51.OrbitBreaker:IsAvailable()) * v26(v16:DebuffUp(v51.MoonfireDebuff)) * v26(v76.OrbitBreakerStacks > ((13 + 14) - ((1 + 1) * v26(v13:BuffUp(v51.SolsticeBuff))))) * (76 - 36));
									if (((4328 + 51) >= (7488 - 5357)) and v51.Berserking:IsCastable() and v23() and ((v74 >= (1 + 19)) or v59 or (v78 < (66 - (12 + 39))))) then
										if (((3577 + 267) >= (6323 - 4280)) and v24(v51.Berserking, v32)) then
											return "berserking main 2";
										end
									end
									local v180 = v106();
									if (v180 or ((11510 - 8278) <= (810 + 1921))) then
										return v180;
									end
									if (((2582 + 2323) == (12437 - 7532)) and v64 and v29) then
										local v183 = v105();
										if (v183 or ((2755 + 1381) >= (21317 - 16906))) then
											return v183;
										end
										if (v10.CastAnnotated(v51.Pool, false, "WAIT/AoE") or ((4668 - (1596 + 114)) == (10487 - 6470))) then
											return "Wait for AoE";
										end
									end
									if (((1941 - (164 + 549)) >= (2251 - (1059 + 379))) and true) then
										local v184 = 0 - 0;
										local v185;
										while true do
											if ((v184 == (0 + 0)) or ((583 + 2872) > (4442 - (145 + 247)))) then
												v185 = v104();
												if (((200 + 43) == (113 + 130)) and v185) then
													return v185;
												end
												v184 = 2 - 1;
											end
											if ((v184 == (1 + 0)) or ((234 + 37) > (2551 - 979))) then
												if (((3459 - (254 + 466)) < (3853 - (544 + 16))) and v10.CastAnnotated(v51.Pool, false, "WAIT/ST")) then
													return "Wait for ST";
												end
												break;
											end
										end
									end
								end
								break;
							end
						end
					end
					break;
				end
				if ((v156 == (0 - 0)) or ((4570 - (294 + 334)) < (1387 - (236 + 17)))) then
					v87 = v16:GetEnemiesInSplashRange(5 + 5);
					v49();
					v156 = 1 + 0;
				end
				if ((v156 == (10 - 7)) or ((12749 - 10056) == (2561 + 2412))) then
					if (((1768 + 378) == (2940 - (413 + 381))) and v13:IsDeadOrGhost()) then
						if (v25(v51.Nothing, nil, nil) or ((95 + 2149) == (6856 - 3632))) then
							return "Dead";
						end
					end
					v87 = v16:GetEnemiesInSplashRange(25 - 15);
					v156 = 1974 - (582 + 1388);
				end
			end
		end);
	end
	local function v108()
		v10.Print("Balance Druid Rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(173 - 71, v107, v108);
end;
return v0["Epix_Druid_Balance.lua"]();

