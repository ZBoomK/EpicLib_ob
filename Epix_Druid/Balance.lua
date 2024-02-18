local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1231 - (353 + 878);
	local v6;
	while true do
		if (((3606 + 1219) < (6537 - 1694)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((7610 - 3733) >= (6417 - (446 + 1434)))) then
			v6 = v0[v4];
			if (not v6 or ((5598 - (1040 + 243)) < (5151 - 3425))) then
				return v1(v4, ...);
			end
			v5 = 1848 - (559 + 1288);
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
		v34 = EpicSettings.Settings['UseHealingPotion'] or (1931 - (609 + 1322));
		v35 = EpicSettings.Settings['HealingPotionName'];
		v36 = EpicSettings.Settings['HealingPotionHP'] or (454 - (13 + 441));
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v42 = EpicSettings.Settings['OutOfCombatHealing'];
		v43 = EpicSettings.Settings['MarkOfTheWild'];
		v44 = EpicSettings.Settings['MoonkinFormOOC'];
		v45 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v46 = EpicSettings.Settings['NaturesVigilHP'] or (0 + 0);
		v47 = EpicSettings.Settings['WildMushroom'] or (0 + 0);
		v48 = EpicSettings.Settings['Starfall'] or (0 - 0);
	end
	local v50 = v10.Commons.Everyone;
	local v51 = v17.Druid.Balance;
	local v52 = v19.Druid.Balance;
	local v53 = {v52.MirrorofFracturedTomorrows:ID()};
	local v54 = v20.Druid.Balance;
	local v55 = v13:GetEquipment();
	local v56 = (v55[23 - 10] and v19(v55[9 + 4])) or v19(0 + 0);
	local v57 = (v55[11 + 3] and v19(v55[12 + 2])) or v19(0 + 0);
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
	local v77 = 11544 - (153 + 280);
	local v78 = 32083 - 20972;
	local v79 = (v51.IncarnationTalent:IsAvailable() and v51.Incarnation) or v51.CelestialAlignment;
	local v80 = false;
	local v81 = false;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	local v85 = false;
	local v86 = false;
	v10:RegisterForEvent(function()
		local v115 = 0 + 0;
		while true do
			if ((v115 == (0 + 0)) or ((1926 + 1753) < (568 + 57))) then
				v55 = v13:GetEquipment();
				v56 = (v55[10 + 3] and v19(v55[19 - 6])) or v19(0 + 0);
				v115 = 668 - (89 + 578);
			end
			if ((v115 == (1 + 0)) or ((9614 - 4989) < (1681 - (572 + 477)))) then
				v57 = (v55[2 + 12] and v19(v55[9 + 5])) or v19(0 + 0);
				v58 = false;
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v116 = 86 - (84 + 2);
		while true do
			if ((v116 == (1 - 0)) or ((60 + 23) > (2622 - (497 + 345)))) then
				v78 = 285 + 10826;
				break;
			end
			if (((93 + 453) <= (2410 - (605 + 728))) and (v116 == (0 + 0))) then
				v58 = false;
				v77 = 24702 - 13591;
				v116 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v117 = 0 - 0;
		while true do
			if ((v117 == (0 + 0)) or ((2759 - 1763) > (3248 + 1053))) then
				v79 = (v51.IncarnationTalent:IsAvailable() and v51.Incarnation) or v51.CelestialAlignment;
				v58 = false;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v87, v88;
	local function v89(v118)
		local v119 = 489 - (457 + 32);
		local v120;
		while true do
			if (((1727 + 2343) > (2089 - (832 + 570))) and (v119 == (1 + 0))) then
				return v120;
			end
			if ((v119 == (0 + 0)) or ((2321 - 1665) >= (1605 + 1725))) then
				v120 = 796 - (588 + 208);
				if ((v118 == v51.Wrath) or ((6716 - 4224) <= (2135 - (884 + 916)))) then
					local v160 = 0 - 0;
					while true do
						if (((2506 + 1816) >= (3215 - (232 + 421))) and (v160 == (1889 - (1569 + 320)))) then
							v120 = 2 + 6;
							if (v51.WildSurges:IsAvailable() or ((691 + 2946) >= (12704 - 8934))) then
								v120 = v120 + (607 - (316 + 289));
							end
							v160 = 2 - 1;
						end
						if ((v160 == (1 + 0)) or ((3832 - (666 + 787)) > (5003 - (360 + 65)))) then
							if ((v51.SouloftheForest:IsAvailable() and v13:BuffUp(v51.EclipseSolar)) or ((452 + 31) > (997 - (79 + 175)))) then
								v120 = v120 * (1.6 - 0);
							end
							break;
						end
					end
				elseif (((1915 + 539) > (1771 - 1193)) and (v118 == v51.Starfire)) then
					local v168 = 0 - 0;
					while true do
						if (((1829 - (503 + 396)) < (4639 - (92 + 89))) and (v168 == (0 - 0))) then
							v120 = 6 + 4;
							if (((392 + 270) <= (3806 - 2834)) and v51.WildSurges:IsAvailable()) then
								v120 = v120 + 1 + 1;
							end
							v168 = 2 - 1;
						end
						if (((3813 + 557) == (2088 + 2282)) and (v168 == (2 - 1))) then
							if (v13:BuffUp(v51.WarriorofEluneBuff) or ((595 + 4167) <= (1312 - 451))) then
								v120 = v120 * (1245.4 - (485 + 759));
							end
							if ((v51.SouloftheForest:IsAvailable() and v13:BuffUp(v51.EclipseLunar)) or ((3267 - 1855) == (5453 - (442 + 747)))) then
								local v176 = 1135 - (832 + 303);
								local v177;
								while true do
									if ((v176 == (946 - (88 + 858))) or ((966 + 2202) < (1782 + 371))) then
										v177 = 1 + 0 + ((789.2 - (766 + 23)) * v88);
										if ((v177 > (4.6 - 3)) or ((6804 - 1828) < (3509 - 2177))) then
											v177 = 3.6 - 2;
										end
										v176 = 1074 - (1036 + 37);
									end
									if (((3282 + 1346) == (9012 - 4384)) and (v176 == (1 + 0))) then
										v120 = v120 * v177;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v119 = 1481 - (641 + 839);
			end
		end
	end
	local function v90(v121)
		local v122 = v121:DebuffRemains(v51.SunfireDebuff);
		return v121:DebuffRefreshable(v51.SunfireDebuff) and (v122 < (915 - (910 + 3))) and ((v121:TimeToDie() - v122) > (15 - 9));
	end
	local function v91(v123)
		return v123:DebuffRefreshable(v51.SunfireDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.Sunfire:EnergizeAmount()));
	end
	local function v92(v124)
		local v125 = 1684 - (1466 + 218);
		local v126;
		while true do
			if ((v125 == (0 + 0)) or ((1202 - (556 + 592)) == (141 + 254))) then
				v126 = v124:DebuffRemains(v51.MoonfireDebuff);
				return v124:DebuffRefreshable(v51.MoonfireDebuff) and (v126 < (810 - (329 + 479))) and ((v124:TimeToDie() - v126) > (860 - (174 + 680)));
			end
		end
	end
	local function v93(v127)
		return v127:DebuffRefreshable(v51.MoonfireDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.Moonfire:EnergizeAmount()));
	end
	local function v94(v128)
		local v129 = 0 - 0;
		local v130;
		while true do
			if (((169 - 87) == (59 + 23)) and (v129 == (739 - (396 + 343)))) then
				v130 = v128:DebuffRemains(v51.StellarFlareDebuff);
				return v128:DebuffRefreshable(v51.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v130 < (1 + 1)) and ((v128:TimeToDie() - v130) > (1485 - (29 + 1448)));
			end
		end
	end
	local function v95(v131)
		return v131:DebuffRefreshable(v51.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount()));
	end
	local function v96(v132)
		return v132:DebuffRefreshable(v51.SunfireDebuff) and ((v132:TimeToDie() - v16:DebuffRemains(v51.SunfireDebuff)) > ((1395 - (135 + 1254)) - (v88 / (7 - 5)))) and (v13:AstralPowerDeficit() > (v66 + v51.Sunfire:EnergizeAmount()));
	end
	local function v97(v133)
		return v133:DebuffRefreshable(v51.MoonfireDebuff) and ((v133:TimeToDie() - v16:DebuffRemains(v51.MoonfireDebuff)) > (27 - 21)) and (v13:AstralPowerDeficit() > (v66 + v51.Moonfire:EnergizeAmount()));
	end
	local function v98(v134)
		return v134:DebuffRefreshable(v51.StellarFlareDebuff) and (((v134:TimeToDie() - v134:DebuffRemains(v51.StellarFlareDebuff)) - v134:GetEnemiesInSplashRangeCount(6 + 2)) > ((1535 - (389 + 1138)) + v88));
	end
	local function v99(v135)
		return v135:DebuffRemains(v51.MoonfireDebuff) > ((v135:DebuffRemains(v51.SunfireDebuff) * (596 - (102 + 472))) / (17 + 1));
	end
	local function v100()
		v80 = v13:BuffUp(v51.EclipseSolar) or v13:BuffUp(v51.EclipseLunar);
		v81 = v13:BuffUp(v51.EclipseSolar) and v13:BuffUp(v51.EclipseLunar);
		v82 = v13:BuffUp(v51.EclipseLunar) and v13:BuffDown(v51.EclipseSolar);
		v83 = v13:BuffUp(v51.EclipseSolar) and v13:BuffDown(v51.EclipseLunar);
		v84 = (not v80 and (((v51.Starfire:Count() == (0 + 0)) and (v51.Wrath:Count() > (0 + 0))) or v13:IsCasting(v51.Wrath))) or v83;
		v85 = (not v80 and (((v51.Wrath:Count() == (1545 - (320 + 1225))) and (v51.Starfire:Count() > (0 - 0))) or v13:IsCasting(v51.Starfire))) or v82;
		v86 = not v80 and (v51.Wrath:Count() > (0 + 0)) and (v51.Starfire:Count() > (1464 - (157 + 1307)));
	end
	local function v101()
		local v136 = 1859 - (821 + 1038);
		local v137;
		local v138;
		while true do
			if ((v136 == (4 - 2)) or ((64 + 517) < (500 - 218))) then
				v138 = ((v57:IsUsable() or (v57:ID() == v52.SpoilsofNeltharus:ID()) or (v57:ID() == v52.MirrorofFracturedTomorrows:ID())) and (1 + 1)) or (0 - 0);
				v138 = ((v57:ID() == v52.SpoilsofNeltharus:ID()) and (1027 - (834 + 192))) or (0 + 0);
				v136 = 1 + 2;
			end
			if ((v136 == (1 + 2)) or ((7139 - 2530) < (2799 - (300 + 4)))) then
				v63 = v63 + v138;
				v58 = true;
				break;
			end
			if (((308 + 844) == (3015 - 1863)) and (v136 == (362 - (112 + 250)))) then
				v59 = (not v51.CelestialAlignment:IsAvailable() and not v51.IncarnationTalent:IsAvailable()) or not v23();
				v63 = 0 + 0;
				v136 = 2 - 1;
			end
			if (((1087 + 809) <= (1770 + 1652)) and (v136 == (1 + 0))) then
				v137 = ((v56:IsUsable() or (v56:ID() == v52.SpoilsofNeltharus:ID()) or (v56:ID() == v52.MirrorofFracturedTomorrows:ID())) and (1 + 0)) or (0 + 0);
				v63 = v63 + v137;
				v136 = 1416 - (1001 + 413);
			end
		end
	end
	local function v102()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (883 - (244 + 638))) or ((1683 - (627 + 66)) > (4827 - 3207))) then
				if ((v51.Wrath:IsCastable() and not v13:IsCasting(v51.Wrath)) or ((1479 - (512 + 90)) > (6601 - (1665 + 241)))) then
					if (((3408 - (373 + 344)) >= (835 + 1016)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath precombat 2";
					end
				end
				if ((v51.Wrath:IsCastable() and ((v13:IsCasting(v51.Wrath) and (v51.Wrath:Count() == (1 + 1))) or (v13:PrevGCD(2 - 1, v51.Wrath) and (v51.Wrath:Count() == (1 - 0))))) or ((4084 - (35 + 1064)) >= (3534 + 1322))) then
					if (((9148 - 4872) >= (5 + 1190)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath precombat 4";
					end
				end
				v139 = 1238 - (298 + 938);
			end
			if (((4491 - (233 + 1026)) <= (6356 - (636 + 1030))) and (v139 == (2 + 0))) then
				if (v51.StellarFlare:IsCastable() or ((876 + 20) >= (935 + 2211))) then
					if (((207 + 2854) >= (3179 - (55 + 166))) and v24(v51.StellarFlare, nil, nil, not v16:IsSpellInRange(v51.StellarFlare))) then
						return "stellar_flare precombat 6";
					end
				end
				if (((618 + 2569) >= (65 + 579)) and v51.Starfire:IsCastable() and not v51.StellarFlare:IsAvailable()) then
					if (((2459 - 1815) <= (1001 - (36 + 261))) and v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire))) then
						return "starfire precombat 8";
					end
				end
				break;
			end
			if (((1675 - 717) > (2315 - (34 + 1334))) and (v139 == (0 + 0))) then
				if (((3491 + 1001) >= (3937 - (1035 + 248))) and v51.MarkOfTheWild:IsCastable() and v50.GroupBuffMissing(v51.MarkOfTheWild)) then
					if (((3463 - (20 + 1)) >= (784 + 719)) and v24(v51.MarkOfTheWild, v43)) then
						return "mark_of_the_wild precombat";
					end
				end
				if (v51.MoonkinForm:IsCastable() or ((3489 - (134 + 185)) <= (2597 - (549 + 584)))) then
					if (v25(v51.MoonkinForm) or ((5482 - (314 + 371)) == (15063 - 10675))) then
						return "moonkin_form";
					end
				end
				v139 = 969 - (478 + 490);
			end
		end
	end
	local function v103()
		if (((292 + 259) <= (1853 - (786 + 386))) and v51.Starfall:IsReady() and v64) then
			if (((10614 - 7337) > (1786 - (1055 + 324))) and v24(v51.Starfall, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
				return "starfall fallthru 2";
			end
		end
		if (((6035 - (1093 + 247)) >= (1258 + 157)) and v51.Starsurge:IsReady()) then
			if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((338 + 2874) <= (3747 - 2803))) then
				return "starsurge fallthru 4";
			end
		end
		if ((v51.WildMushroom:IsReady() and not v64) or ((10506 - 7410) <= (5115 - 3317))) then
			if (((8888 - 5351) == (1259 + 2278)) and v24(v51.WildMushroom, v47, nil, not v16:IsSpellInRange(v51.WildMushroom))) then
				return "wild_mushroom fallthru 6";
			end
		end
		if (((14781 - 10944) >= (5411 - 3841)) and v51.Sunfire:IsCastable()) then
			if (v50.CastCycle(v51.Sunfire, v87, v99, not v16:IsSpellInRange(v51.Sunfire)) or ((2225 + 725) == (9748 - 5936))) then
				return "sunfire fallthru 8";
			end
		end
		if (((5411 - (364 + 324)) >= (6354 - 4036)) and v51.Moonfire:IsCastable()) then
			if (v24(v51.Moonfire, nil, nil, not v16:IsSpellInRange(v51.Moonfire)) or ((4864 - 2837) > (946 + 1906))) then
				return "moonfire fallthru 10";
			end
		end
	end
	local function v104()
		local v140 = 0 - 0;
		local v141;
		local v142;
		local v143;
		while true do
			if ((v140 == (8 - 3)) or ((3450 - 2314) > (5585 - (1249 + 19)))) then
				if (((4286 + 462) == (18481 - 13733)) and v51.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (1088 - (686 + 400))) and ((v74 > (3 + 0)) or ((v79:CooldownRemains() > (259 - (73 + 156))) and (v72 <= (2 + 278))) or ((v72 >= (1371 - (721 + 90))) and (v13:AstralPowerP() > (1 + 49))))) or (v78 < (32 - 22)))) then
					if (((4206 - (224 + 246)) <= (7678 - 2938)) and v24(v51.FuryOfElune, nil, not v16:IsSpellInRange(v51.FuryOfElune))) then
						return "fury_of_elune st 36";
					end
				end
				if ((v51.Starfall:IsReady() and (v13:BuffUp(v51.StarweaversWarp))) or ((6241 - 2851) <= (556 + 2504))) then
					if (v24(v51.Starfall, nil, not v16:IsSpellInRange(v51.Wrath)) or ((24 + 975) > (1978 + 715))) then
						return "starfall st 38";
					end
				end
				v141 = (v51.Starlord:IsAvailable() and (v13:BuffStack(v51.StarlordBuff) < (5 - 2))) or (((v13:BuffStack(v51.BOATArcaneBuff) + v13:BuffStack(v51.BOATNatureBuff)) > (6 - 4)) and (v13:BuffRemains(v51.StarlordBuff) > (517 - (203 + 310))));
				if (((2456 - (1238 + 755)) < (42 + 559)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (1536 - (709 + 825))) and v141) then
					if (v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL") or ((4022 - 1839) < (1000 - 313))) then
						return "cancel_buff starlord st 39";
					end
				end
				v140 = 870 - (196 + 668);
			end
			if (((17960 - 13411) == (9422 - 4873)) and (v140 == (841 - (171 + 662)))) then
				if (((4765 - (4 + 89)) == (16375 - 11703)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (1 + 1)) and v142) then
					if (v25(v54.CancelStarlord, false, "CANCEL") or ((16110 - 12442) < (155 + 240))) then
						return "cancel_buff starlord st 53";
					end
				end
				if ((v51.Starsurge:IsReady() and v142) or ((5652 - (35 + 1451)) == (1908 - (28 + 1425)))) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((6442 - (941 + 1052)) == (2554 + 109))) then
						return "starsurge st 54";
					end
				end
				if ((v51.Wrath:IsCastable() and not v13:IsMoving()) or ((5791 - (822 + 692)) < (4266 - 1277))) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((410 + 460) >= (4446 - (45 + 252)))) then
						return "wrath st 60";
					end
				end
				v143 = v103();
				v140 = 9 + 0;
			end
			if (((762 + 1450) < (7746 - 4563)) and (v140 == (436 - (114 + 319)))) then
				if (((6669 - 2023) > (3833 - 841)) and v51.WarriorofElune:IsCastable() and v62 and (v69 or (v13:BuffRemains(v51.EclipseSolar) < (5 + 2)))) then
					if (((2135 - 701) < (6507 - 3401)) and v24(v51.WarriorofElune)) then
						return "warrior_of_elune st 20";
					end
				end
				if (((2749 - (556 + 1407)) < (4229 - (741 + 465))) and v51.Starfire:IsCastable() and v69 and (v62 or v13:BuffUp(v51.EclipseSolar))) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((2907 - (170 + 295)) < (39 + 35))) then
						return "starfire st 24";
					end
				end
				if (((4166 + 369) == (11165 - 6630)) and v51.Wrath:IsCastable() and v69) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((2495 + 514) <= (1350 + 755))) then
						return "wrath st 26";
					end
				end
				v71 = (v74 > (3 + 1)) or (((v79:CooldownRemains() > (1260 - (957 + 273))) or v59) and ((v13:BuffRemains(v51.EclipseLunar) > (2 + 2)) or (v13:BuffRemains(v51.EclipseSolar) > (2 + 2))));
				v140 = 15 - 11;
			end
			if (((4822 - 2992) < (11206 - 7537)) and (v140 == (34 - 27))) then
				if ((v51.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.NewMoon:EnergizeAmount())) and (v73 or ((v51.NewMoon:ChargesFractional() > (1782.5 - (389 + 1391))) and (v72 <= (327 + 193)) and (v79:CooldownRemains() > (2 + 8))) or (v78 < (22 - 12)))) or ((2381 - (783 + 168)) >= (12122 - 8510))) then
					if (((2640 + 43) >= (2771 - (309 + 2))) and v24(v51.NewMoon, nil, nil, not v16:IsSpellInRange(v51.NewMoon))) then
						return "new_moon st 48";
					end
				end
				if ((v51.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.HalfMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.HalfMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (5.5 - 3)) and (v72 <= (1732 - (1090 + 122))) and (v79:CooldownRemains() > (4 + 6))) or (v78 < (33 - 23)))) or ((1235 + 569) >= (4393 - (628 + 490)))) then
					if (v24(v51.HalfMoon, nil, nil, not v16:IsSpellInRange(v51.HalfMoon)) or ((255 + 1162) > (8984 - 5355))) then
						return "half_moon st 50";
					end
				end
				if (((21913 - 17118) > (1176 - (431 + 343))) and v51.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (3.5 - 1)) and (v72 <= (1504 - 984)) and (v79:CooldownRemains() > (8 + 2))) or (v78 < (2 + 8)))) then
					if (((6508 - (556 + 1139)) > (3580 - (6 + 9))) and v24(v51.FullMoon, nil, nil, not v16:IsSpellInRange(v51.FullMoon))) then
						return "full_moon st 52";
					end
				end
				v142 = v13:BuffUp(v51.StarweaversWeft) or (v13:AstralPowerDeficit() < (v66 + v89(v51.Wrath) + ((v89(v51.Starfire) + v66) * (v26(v13:BuffRemains(v51.EclipseSolar) < (v13:GCD() * (1 + 2))))))) or (v51.AstralCommunion:IsAvailable() and (v51.AstralCommunion:CooldownRemains() < (2 + 1))) or (v78 < (174 - (28 + 141)));
				v140 = 4 + 4;
			end
			if (((4828 - 916) == (2771 + 1141)) and (v140 == (1323 - (486 + 831)))) then
				if (((7340 - 4519) <= (16983 - 12159)) and v51.Starsurge:IsReady() and v141) then
					if (((329 + 1409) <= (6940 - 4745)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge st 40";
					end
				end
				if (((1304 - (668 + 595)) <= (2716 + 302)) and v51.Sunfire:IsCastable()) then
					if (((433 + 1712) <= (11191 - 7087)) and v50.CastCycle(v51.Sunfire, v87, v91, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire st 42";
					end
				end
				if (((2979 - (23 + 267)) < (6789 - (1129 + 815))) and v51.Moonfire:IsCastable()) then
					if (v50.CastCycle(v51.Moonfire, v87, v93, not v16:IsSpellInRange(v51.Moonfire)) or ((2709 - (371 + 16)) > (4372 - (1326 + 424)))) then
						return "moonfire st 44";
					end
				end
				if (v51.StellarFlare:IsCastable() or ((8587 - 4053) == (7608 - 5526))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v95, not v16:IsSpellInRange(v51.StellarFlare)) or ((1689 - (88 + 30)) > (2638 - (720 + 51)))) then
						return "stellar_flare st 46";
					end
				end
				v140 = 15 - 8;
			end
			if ((v140 == (1785 - (421 + 1355))) or ((4377 - 1723) >= (1472 + 1524))) then
				if (((5061 - (286 + 797)) > (7691 - 5587)) and v143) then
					return v143;
				end
				if (((4960 - 1965) > (1980 - (397 + 42))) and v10.CastAnnotated(v51.Pool, false, "MOVING")) then
					return "Pool ST due to movement and no fallthru";
				end
				break;
			end
			if (((1015 + 2234) > (1753 - (24 + 776))) and (v140 == (5 - 1))) then
				if ((v51.Starsurge:IsReady() and v51.ConvokeTheSpirits:IsAvailable() and v51.ConvokeTheSpirits:IsCastable() and v71) or ((4058 - (222 + 563)) > (10075 - 5502))) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((2269 + 882) < (1474 - (23 + 167)))) then
						return "starsurge st 28";
					end
				end
				if ((v51.ConvokeTheSpirits:IsCastable() and v23() and v71) or ((3648 - (690 + 1108)) == (552 + 977))) then
					if (((678 + 143) < (2971 - (40 + 808))) and v24(v51.ConvokeTheSpirits, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "convoke_the_spirits st 30";
					end
				end
				if (((149 + 753) < (8890 - 6565)) and v51.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.AstralCommunion:EnergizeAmount()))) then
					if (((821 + 37) <= (1567 + 1395)) and v24(v51.AstralCommunion)) then
						return "astral_communion st 32";
					end
				end
				if ((v51.ForceOfNature:IsCastable() and v23() and (v13:AstralPowerDeficit() > (v66 + v51.ForceOfNature:EnergizeAmount()))) or ((2164 + 1782) < (1859 - (47 + 524)))) then
					if (v24(v51.ForceOfNature, nil, not v16:IsSpellInRange(v51.Wrath)) or ((2104 + 1138) == (1549 - 982))) then
						return "force_of_nature st 34";
					end
				end
				v140 = 7 - 2;
			end
			if ((v140 == (4 - 2)) or ((2573 - (1165 + 561)) >= (38 + 1225))) then
				if ((v51.Wrath:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v67 and v13:BuffUp(v51.EclipseSolar)) or ((6977 - 4724) == (707 + 1144))) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((2566 - (341 + 138)) > (641 + 1731))) then
						return "wrath st 15";
					end
				end
				if (v30 or ((9173 - 4728) < (4475 - (89 + 237)))) then
					if ((v51.CelestialAlignment:IsCastable() and v67) or ((5848 - 4030) == (178 - 93))) then
						if (((1511 - (581 + 300)) < (3347 - (855 + 365))) and v25(v51.CelestialAlignment)) then
							return "celestial_alignment st 16";
						end
					end
					if ((v51.Incarnation:IsCastable() and v67) or ((4603 - 2665) == (821 + 1693))) then
						if (((5490 - (1030 + 205)) >= (52 + 3)) and v25(v51.Incarnation)) then
							return "incarnation st 18";
						end
					end
				end
				v62 = ((v72 < (484 + 36)) and (v79:CooldownRemains() > (291 - (156 + 130))) and (v88 < (6 - 3))) or v13:HasTier(51 - 20, 3 - 1);
				v69 = v86 or (v62 and v13:BuffUp(v51.EclipseSolar) and (v13:BuffRemains(v51.EclipseSolar) < v51.Starfire:CastTime())) or (not v62 and v13:BuffUp(v51.EclipseLunar) and (v13:BuffRemains(v51.EclipseLunar) < v51.Wrath:CastTime()));
				v140 = 1 + 2;
			end
			if (((1749 + 1250) > (1225 - (10 + 59))) and (v140 == (0 + 0))) then
				if (((11573 - 9223) > (2318 - (671 + 492))) and v51.Sunfire:IsCastable()) then
					if (((3208 + 821) <= (6068 - (369 + 846))) and v50.CastCycle(v51.Sunfire, v87, v90, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire st 2";
					end
				end
				v67 = v30 and (v79:CooldownRemains() < (2 + 3)) and not v73 and (((v16:TimeToDie() > (13 + 2)) and (v72 < (2425 - (1036 + 909)))) or (v78 < (20 + 5 + ((16 - 6) * v26(v51.Incarnation:IsAvailable())))));
				if (v51.Moonfire:IsCastable() or ((719 - (11 + 192)) > (1736 + 1698))) then
					if (((4221 - (135 + 40)) >= (7348 - 4315)) and v50.CastCycle(v51.Moonfire, v87, v92, not v16:IsSpellInRange(v51.Moonfire))) then
						return "moonfire st 6";
					end
				end
				if (v51.StellarFlare:IsCastable() or ((1639 + 1080) <= (3187 - 1740))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v94, not v16:IsSpellInRange(v51.StellarFlare)) or ((6196 - 2062) < (4102 - (50 + 126)))) then
						return "stellar_flare st 10";
					end
				end
				v140 = 2 - 1;
			end
			if ((v140 == (1 + 0)) or ((1577 - (1233 + 180)) >= (3754 - (522 + 447)))) then
				if ((v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (1423 - (107 + 1314))) and (((v72 >= (256 + 294)) and not v73 and v13:BuffUp(v51.StarweaversWarp)) or ((v72 >= (1706 - 1146)) and v13:BuffUp(v51.StarweaversWeft)))) or ((223 + 302) == (4187 - 2078))) then
					if (((130 - 97) == (1943 - (716 + 1194))) and v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 11";
					end
				end
				if (((53 + 3001) <= (431 + 3584)) and v51.Starfall:IsReady() and (v72 >= (1053 - (74 + 429))) and not v73 and v13:BuffUp(v51.StarweaversWarp)) then
					if (((3609 - 1738) < (1677 + 1705)) and v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "starfall st 12";
					end
				end
				if (((2959 - 1666) <= (1533 + 633)) and v51.Starsurge:IsReady() and (v72 >= (1726 - 1166)) and v13:BuffUp(v51.StarweaversWeft)) then
					if (v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge)) or ((6376 - 3797) < (556 - (279 + 154)))) then
						return "starsurge st 13";
					end
				end
				if ((v51.Starfire:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v67 and v82) or ((1624 - (454 + 324)) >= (1864 + 504))) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((4029 - (12 + 5)) <= (1811 + 1547))) then
						return "starfire st 14";
					end
				end
				v140 = 4 - 2;
			end
		end
	end
	local function v105()
		local v144 = 0 + 0;
		local v145;
		local v146;
		local v147;
		local v148;
		local v149;
		local v150;
		local v151;
		while true do
			if (((2587 - (277 + 816)) <= (12840 - 9835)) and ((1183 - (1058 + 125)) == v144)) then
				v145 = v13:IsInParty() and not v13:IsInRaid();
				if ((v51.Moonfire:IsCastable() and v145) or ((584 + 2527) == (3109 - (815 + 160)))) then
					if (((10104 - 7749) == (5590 - 3235)) and v50.CastCycle(v51.Moonfire, v87, v97, not v16:IsSpellInRange(v51.Moonfire))) then
						return "moonfire aoe 2";
					end
				end
				v68 = v23() and (v79:CooldownRemains() < (2 + 3)) and not v73 and (((v16:TimeToDie() > (29 - 19)) and (v72 < (2398 - (41 + 1857)))) or (v78 < ((1918 - (1222 + 671)) + ((25 - 15) * v26(v51.Incarnation:IsAvailable())))));
				if (v51.Sunfire:IsCastable() or ((844 - 256) <= (1614 - (229 + 953)))) then
					if (((6571 - (1111 + 663)) >= (5474 - (874 + 705))) and v50.CastCycle(v51.Sunfire, v87, v96, not v16:IsSpellInRange(v51.Sunfire))) then
						return "sunfire aoe 4";
					end
				end
				if (((501 + 3076) == (2441 + 1136)) and v51.Moonfire:IsCastable() and not v145) then
					if (((7885 - 4091) > (104 + 3589)) and v50.CastCycle(v51.Moonfire, v87, v97, not v16:IsSpellInRange(v51.Moonfire))) then
						return "moonfire aoe 6";
					end
				end
				if ((v51.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v88 < (((690 - (642 + 37)) - v51.UmbralIntensity:TalentRank()) - v51.AstralSmolder:TalentRank())) and v68) or ((291 + 984) == (656 + 3444))) then
					if (v50.CastCycle(v51.StellarFlare, v87, v98, not v16:IsSpellInRange(v51.StellarFlare)) or ((3994 - 2403) >= (4034 - (233 + 221)))) then
						return "stellar_flare aoe 9";
					end
				end
				v144 = 2 - 1;
			end
			if (((866 + 117) <= (3349 - (718 + 823))) and (v144 == (2 + 1))) then
				if ((v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (807 - (266 + 539))) and v148) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
					if (((8946 - 5177) >= (2418 - 1245)) and v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord aoe 23";
					end
				end
				if (((1177 + 308) == (540 + 945)) and v51.Starfall:IsReady() and v148) then
					if (v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath)) or ((4330 - (657 + 358)) <= (7365 - 4583))) then
						return "starfall aoe 24";
					end
				end
				if ((v51.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime())) and (v73 or ((v51.HalfMoon:ChargesFractional() > (4.5 - 2)) and (v72 <= (1707 - (1151 + 36))) and (v79:CooldownRemains() > (10 + 0))) or (v78 < (3 + 7)))) or ((2616 - 1740) >= (4796 - (1552 + 280)))) then
					if (v24(v51.FullMoon, nil, nil, not v16:IsSpellInRange(v51.FullMoon)) or ((3066 - (64 + 770)) > (1696 + 801))) then
						return "full_moon aoe 26";
					end
				end
				if ((v51.Starsurge:IsReady() and v13:BuffUp(v51.StarweaversWeft) and (v88 < (6 - 3))) or ((375 + 1735) <= (1575 - (157 + 1086)))) then
					if (((7377 - 3691) > (13892 - 10720)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge aoe 30";
					end
				end
				if ((v51.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.StellarFlare:EnergizeAmount())) and (v88 < (((16 - 5) - v51.UmbralIntensity:TalentRank()) - v51.AstralSmolder:TalentRank()))) or ((6106 - 1632) < (1639 - (599 + 220)))) then
					if (((8520 - 4241) >= (4813 - (1813 + 118))) and v50.CastCycle(v51.StellarFlare, v87, v98, not v16:IsSpellInRange(v51.StellarFlare))) then
						return "stellar_flare aoe 32";
					end
				end
				if ((v51.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.AstralCommunion:EnergizeAmount()))) or ((1484 + 545) >= (4738 - (841 + 376)))) then
					if (v24(v51.ForceOfNature) or ((2854 - 817) >= (1079 + 3563))) then
						return "astral_communion aoe 34";
					end
				end
				v144 = 10 - 6;
			end
			if (((2579 - (464 + 395)) < (11440 - 6982)) and ((1 + 1) == v144)) then
				v147 = v88 < (840 - (467 + 370));
				if ((v51.Starfire:IsCastable() and v147 and (v86 or (v13:BuffRemains(v51.EclipseSolar) < v51.Starfire:CastTime()))) or ((900 - 464) > (2218 + 803))) then
					if (((2444 - 1731) <= (133 + 714)) and v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire))) then
						return "starfire aoe 17";
					end
				end
				if (((5010 - 2856) <= (4551 - (150 + 370))) and v51.Wrath:IsCastable() and not v147 and (v86 or (v13:BuffRemains(v51.EclipseLunar) < v51.Wrath:CastTime()))) then
					if (((5897 - (74 + 1208)) == (11351 - 6736)) and v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "wrath aoe 18";
					end
				end
				if ((v51.WildMushroom:IsCastable() and (v13:AstralPowerDeficit() > (v66 + (94 - 74))) and (not v51.WaningTwilight:IsAvailable() or ((v16:DebuffRemains(v51.FungalGrowthDebuff) < (2 + 0)) and (v16:TimeToDie() > (397 - (14 + 376))) and not v13:PrevGCDP(1 - 0, v51.WildMushroom)))) or ((2453 + 1337) == (440 + 60))) then
					if (((85 + 4) < (647 - 426)) and v24(v51.WildMushroom, v47, nil, not v16:IsSpellInRange(v51.WildMushroom))) then
						return "wild_mushroom aoe 20";
					end
				end
				if (((1546 + 508) >= (1499 - (23 + 55))) and v51.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (4 - 2)) and ((v74 > (3 + 0)) or ((v79:CooldownRemains() > (27 + 3)) and (v72 <= (434 - 154))) or ((v72 >= (177 + 383)) and (v13:AstralPowerP() > (951 - (652 + 249)))))) or (v78 < (26 - 16)))) then
					if (((2560 - (708 + 1160)) < (8300 - 5242)) and v24(v51.FuryOfElune, nil, not v16:IsSpellInRange(v51.FuryOfElune))) then
						return "fury_of_elune aoe 22";
					end
				end
				v148 = (v16:TimeToDie() > (6 - 2)) and (v13:BuffUp(v51.StarweaversWarp) or (v51.Starlord:IsAvailable() and (v13:BuffStack(v51.StarlordBuff) < (30 - (10 + 17)))));
				v144 = 1 + 2;
			end
			if ((v144 == (1738 - (1400 + 332))) or ((6241 - 2987) == (3563 - (242 + 1666)))) then
				if (v151 or ((555 + 741) == (1800 + 3110))) then
					return v151;
				end
				if (((2871 + 497) == (4308 - (850 + 90))) and v10.CastAnnotated(v51.Pool, false, "MOVING")) then
					return "Pool AoE due to movement and no fallthru";
				end
				break;
			end
			if (((4628 - 1985) < (5205 - (360 + 1030))) and (v144 == (5 + 0))) then
				v150 = 0 - 0;
				if (((2631 - 718) > (2154 - (909 + 752))) and v13:BuffUp(v51.EclipseLunar)) then
					local v161 = v13:BuffInfo(v51.EclipseLunar, nil, true);
					local v162 = v161.points[1224 - (109 + 1114)];
					local v163 = (v162 - (27 - 12)) / (1 + 1);
				end
				if (((4997 - (6 + 236)) > (2160 + 1268)) and v13:BuffUp(v51.EclipseSolar)) then
					local v164 = 0 + 0;
					local v165;
					local v166;
					local v167;
					while true do
						if (((3256 - 1875) <= (4137 - 1768)) and (v164 == (1134 - (1076 + 57)))) then
							v167 = (v166 - (3 + 12)) / (691 - (579 + 110));
							break;
						end
						if ((v164 == (0 + 0)) or ((4282 + 561) == (2168 + 1916))) then
							v165 = v13:BuffInfo(v51.EclipseSolar, nil, true);
							v166 = v165.points[408 - (174 + 233)];
							v164 = 2 - 1;
						end
					end
				end
				if (((8194 - 3525) > (162 + 201)) and v51.Starfire:IsCastable() and not v13:IsMoving() and (((v88 > ((1177 - (663 + 511)) - (v26(v13:BuffUp(v51.DreamstateBuff) or (v149 > v150))))) and v13:BuffUp(v51.EclipseLunar)) or v82)) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((1675 + 202) >= (682 + 2456))) then
						return "starfire aoe 46";
					end
				end
				if (((14619 - 9877) >= (2196 + 1430)) and v51.Wrath:IsCastable() and not v13:IsMoving()) then
					if (v24(v51.Wrath, nil, nil, not v16:IsSpellInRange(v51.Wrath)) or ((10688 - 6148) == (2217 - 1301))) then
						return "wrath aoe 48";
					end
				end
				v151 = v103();
				v144 = 3 + 3;
			end
			if ((v144 == (1 - 0)) or ((824 + 332) > (398 + 3947))) then
				v146 = (v68 and ((v51.OrbitalStrike:IsAvailable() and (v13:AstralPowerDeficit() < (v66 + ((730 - (478 + 244)) * v88)))) or v13:BuffUp(v51.TouchTheCosmos))) or (v13:AstralPowerDeficit() < (v66 + (525 - (440 + 77)) + ((6 + 6) * v26((v13:BuffRemains(v51.EclipseLunar) < (14 - 10)) or (v13:BuffRemains(v51.EclipseSolar) < (1560 - (655 + 901)))))));
				if (((415 + 1822) < (3253 + 996)) and v13:BuffUp(v51.StarlordBuff) and (v13:BuffRemains(v51.StarlordBuff) < (2 + 0)) and v146) then
					if (v10.CastAnnotated(v54.CancelStarlord, false, "CANCEL") or ((10808 - 8125) < (1468 - (695 + 750)))) then
						return "cancel_buff starlord aoe 9.5";
					end
				end
				if (((2380 - 1683) <= (1274 - 448)) and v51.Starfall:IsReady() and v146) then
					if (((4444 - 3339) <= (1527 - (285 + 66))) and v24(v51.Starfall, v48, nil, not v16:IsSpellInRange(v51.Wrath))) then
						return "starfall aoe 10";
					end
				end
				if (((7876 - 4497) <= (5122 - (682 + 628))) and v51.Starfire:IsReady() and v13:BuffUp(v51.DreamstateBuff) and v68 and v13:BuffUp(v51.EclipseLunar)) then
					if (v24(v51.Starfire, nil, nil, not v16:IsSpellInRange(v51.Starfire)) or ((128 + 660) >= (1915 - (176 + 123)))) then
						return "starfire aoe 11";
					end
				end
				if (((776 + 1078) <= (2452 + 927)) and v30) then
					if (((4818 - (239 + 30)) == (1237 + 3312)) and v51.CelestialAlignment:IsCastable() and v68) then
						if (v25(v51.CelestialAlignment) or ((2905 + 117) >= (5352 - 2328))) then
							return "celestial_alignment aoe 10";
						end
					end
					if (((15037 - 10217) > (2513 - (306 + 9))) and v51.Incarnation:IsCastable() and v68) then
						if (v25(v51.Incarnation) or ((3702 - 2641) >= (851 + 4040))) then
							return "celestial_alignment aoe 12";
						end
					end
				end
				if (((837 + 527) <= (2154 + 2319)) and v51.WarriorofElune:IsCastable()) then
					if (v25(v51.WarriorofElune) or ((10280 - 6685) <= (1378 - (1140 + 235)))) then
						return "warrior_of_elune aoe 14";
					end
				end
				v144 = 2 + 0;
			end
			if ((v144 == (4 + 0)) or ((1200 + 3472) == (3904 - (33 + 19)))) then
				if (((563 + 996) == (4672 - 3113)) and v51.ConvokeTheSpirits:IsCastable() and v23() and (v13:AstralPowerP() < (23 + 27)) and (v88 < ((5 - 2) + v26(v51.ElunesGuidance:IsAvailable()))) and ((v13:BuffRemains(v51.EclipseLunar) > (4 + 0)) or (v13:BuffRemains(v51.EclipseSolar) > (693 - (586 + 103))))) then
					if (v24(v51.ConvokeTheSpirits, nil, not v16:IsInRange(4 + 36)) or ((5393 - 3641) <= (2276 - (1309 + 179)))) then
						return "convoke_the_spirits aoe 36";
					end
				end
				if ((v51.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.NewMoon:EnergizeAmount()))) or ((7052 - 3145) == (78 + 99))) then
					if (((9318 - 5848) > (420 + 135)) and v24(v51.NewMoon, nil, nil, not v16:IsSpellInRange(v51.NewMoon))) then
						return "new_moon aoe 38";
					end
				end
				if ((v51.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v51.EclipseLunar) > v51.FullMoon:ExecuteTime()) or (v13:BuffRemains(v51.EclipseSolar) > v51.FullMoon:ExecuteTime()))) or ((2064 - 1092) == (1285 - 640))) then
					if (((3791 - (295 + 314)) >= (5194 - 3079)) and v24(v51.HalfMoon, nil, nil, not v16:IsSpellInRange(v51.HalfMoon))) then
						return "half_moon aoe 40";
					end
				end
				if (((5855 - (1300 + 662)) < (13907 - 9478)) and v51.ForceOfNature:IsCastable() and (v13:AstralPowerDeficit() > (v66 + v51.ForceOfNature:EnergizeAmount()))) then
					if (v24(v51.ForceOfNature, nil, not v16:IsSpellInRange(v51.Wrath)) or ((4622 - (1178 + 577)) < (990 + 915))) then
						return "force_of_nature aoe 42";
					end
				end
				if ((v51.Starsurge:IsReady() and v13:BuffUp(v51.StarweaversWeft) and (v88 < (50 - 33))) or ((3201 - (851 + 554)) >= (3583 + 468))) then
					if (((4489 - 2870) <= (8157 - 4401)) and v24(v51.Starsurge, nil, nil, not v16:IsSpellInRange(v51.Starsurge))) then
						return "starsurge aoe 44";
					end
				end
				v149 = 302 - (115 + 187);
				v144 = 4 + 1;
			end
		end
	end
	local function v106()
		local v152 = 0 + 0;
		local v153;
		while true do
			if (((2379 - 1775) == (1765 - (160 + 1001))) and ((0 + 0) == v152)) then
				v153 = v50.HandleTopTrinket(v53, v30, 28 + 12, nil);
				if (v153 or ((9178 - 4694) == (1258 - (237 + 121)))) then
					return v153;
				end
				v152 = 898 - (525 + 372);
			end
			if (((1 - 0) == v152) or ((14650 - 10191) <= (1255 - (96 + 46)))) then
				v153 = v50.HandleBottomTrinket(v53, v30, 817 - (643 + 134), nil);
				if (((1312 + 2320) > (8147 - 4749)) and v153) then
					return v153;
				end
				break;
			end
		end
	end
	local function v107()
		C_Timer.After(0.15 - 0, function()
			local v154 = 0 + 0;
			while true do
				if (((8010 - 3928) <= (10050 - 5133)) and (v154 == (719 - (316 + 403)))) then
					v87 = v16:GetEnemiesInSplashRange(7 + 3);
					v49();
					v154 = 2 - 1;
				end
				if (((1747 + 3085) >= (3490 - 2104)) and ((3 + 1) == v154)) then
					if (((45 + 92) == (474 - 337)) and v29) then
						v88 = v16:GetEnemiesInSplashRangeCount(47 - 37);
					else
						v88 = 1 - 0;
					end
					if ((not v13:IsChanneling() and v31) or ((90 + 1480) >= (8527 - 4195))) then
						if (v13:AffectingCombat() or ((199 + 3865) <= (5351 - 3532))) then
							local v170 = 17 - (12 + 5);
							while true do
								if ((v170 == (3 - 2)) or ((10637 - 5651) < (3345 - 1771))) then
									if (((10975 - 6549) > (35 + 137)) and (v13:HealthPercentage() <= v38) and v37 and v52.Healthstone:IsReady()) then
										if (((2559 - (1656 + 317)) > (406 + 49)) and v25(v54.Healthstone, nil, nil, true)) then
											return "healthstone defensive 4";
										end
									end
									break;
								end
								if (((662 + 164) == (2196 - 1370)) and (v170 == (0 - 0))) then
									if (((v13:HealthPercentage() <= v46) and v51.NaturesVigil:IsReady()) or ((4373 - (5 + 349)) > (21094 - 16653))) then
										if (((3288 - (266 + 1005)) < (2808 + 1453)) and v25(v51.NaturesVigil, nil, nil, true)) then
											return "barkskin defensive 2";
										end
									end
									if (((16091 - 11375) > (105 - 25)) and (v13:HealthPercentage() <= v45) and v51.Barkskin:IsReady()) then
										if (v25(v51.Barkskin, nil, nil, true) or ((5203 - (561 + 1135)) == (4263 - 991))) then
											return "barkskin defensive 2";
										end
									end
									v170 = 3 - 2;
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1942 - (507 + 559)) >= (7716 - 4641))) then
							local v171 = 0 - 0;
							local v172;
							while true do
								if (((4740 - (212 + 176)) > (3459 - (250 + 655))) and (v171 == (0 - 0))) then
									v172 = v50.DeadFriendlyUnitsCount();
									if (v13:AffectingCombat() or ((7698 - 3292) < (6325 - 2282))) then
										if (v51.Rebirth:IsCastable() or ((3845 - (1869 + 87)) >= (11733 - 8350))) then
											if (((3793 - (484 + 1417)) <= (5859 - 3125)) and v25(v51.Rebirth, nil, true)) then
												return "rebirth";
											end
										end
									elseif (((3222 - 1299) < (2991 - (48 + 725))) and v51.Revive:IsCastable()) then
										if (((3549 - 1376) > (1016 - 637)) and v25(v51.Revive, not v16:IsInRange(24 + 16), true)) then
											return "revive";
										end
									end
									break;
								end
							end
						end
						if ((v50.TargetIsValid() and not v58) or ((6924 - 4333) == (955 + 2454))) then
							v101();
						end
						if (((1316 + 3198) > (4177 - (152 + 701))) and (v50.TargetIsValid() or v13:AffectingCombat())) then
							local v173 = 1311 - (430 + 881);
							while true do
								if ((v173 == (1 + 0)) or ((1103 - (557 + 338)) >= (1428 + 3400))) then
									v78 = v77;
									if ((v78 == (31311 - 20200)) or ((5542 - 3959) > (9476 - 5909))) then
										v78 = v10.FightRemains(v87, false);
									end
									v173 = 4 - 2;
								end
								if ((v173 == (804 - (499 + 302))) or ((2179 - (39 + 827)) == (2191 - 1397))) then
									v73 = v13:BuffUp(v51.CABuff) or v13:BuffUp(v51.IncarnationBuff);
									v74 = 0 - 0;
									v173 = 15 - 11;
								end
								if (((4872 - 1698) > (249 + 2653)) and ((11 - 7) == v173)) then
									if (((660 + 3460) <= (6741 - 2481)) and v73) then
										v74 = (v51.IncarnationTalent:IsAvailable() and v13:BuffRemains(v51.IncarnationBuff)) or v13:BuffRemains(v51.CABuff);
									end
									break;
								end
								if ((v173 == (104 - (103 + 1))) or ((1437 - (475 + 79)) > (10328 - 5550))) then
									v75 = true;
									v77 = v10.BossFightRemains();
									v173 = 3 - 2;
								end
								if ((v173 == (1 + 1)) or ((3186 + 434) >= (6394 - (1395 + 108)))) then
									v72 = 0 - 0;
									if (((5462 - (7 + 1197)) > (409 + 528)) and v51.PrimordialArcanicPulsar:IsAvailable()) then
										local v178 = 0 + 0;
										local v179;
										while true do
											if ((v178 == (319 - (27 + 292))) or ((14267 - 9398) < (1155 - 249))) then
												v179 = v13:BuffInfo(v51.PAPBuff, false, true);
												if ((v179 ~= nil) or ((5137 - 3912) > (8337 - 4109))) then
													v72 = v179.points[1 - 0];
												end
												break;
											end
										end
									end
									v173 = 142 - (43 + 96);
								end
							end
						end
						if (((13575 - 10247) > (5059 - 2821)) and not v13:AffectingCombat()) then
							if (((3186 + 653) > (397 + 1008)) and v51.MoonkinForm:IsCastable() and v44) then
								if (v25(v51.MoonkinForm) or ((2555 - 1262) <= (195 + 312))) then
									return "moonkin_form ooc";
								end
							end
						end
						if ((v50.TargetIsValid() and v28) or v13:AffectingCombat() or ((5427 - 2531) < (254 + 551))) then
							local v174 = 0 + 0;
							local v175;
							while true do
								if (((4067 - (1414 + 337)) == (4256 - (1642 + 298))) and (v174 == (2 - 1))) then
									v65 = v88 > (2 - 1);
									v66 = ((17 - 11) / v13:SpellHaste()) + v26(v51.NaturesBalance:IsAvailable()) + (v26(v51.OrbitBreaker:IsAvailable()) * v26(v16:DebuffUp(v51.MoonfireDebuff)) * v26(v76.OrbitBreakerStacks > ((9 + 18) - ((2 + 0) * v26(v13:BuffUp(v51.SolsticeBuff))))) * (1012 - (357 + 615)));
									if ((v51.Berserking:IsCastable() and v23() and ((v74 >= (15 + 5)) or v59 or (v78 < (36 - 21)))) or ((2203 + 367) == (3285 - 1752))) then
										if (v24(v51.Berserking, v32) or ((707 + 176) == (100 + 1360))) then
											return "berserking main 2";
										end
									end
									v175 = v106();
									v174 = 2 + 0;
								end
								if ((v174 == (1303 - (384 + 917))) or ((5316 - (128 + 569)) <= (2542 - (1407 + 136)))) then
									if (v175 or ((5297 - (687 + 1200)) > (5826 - (556 + 1154)))) then
										return v175;
									end
									if ((v64 and v29) or ((3176 - 2273) >= (3154 - (9 + 86)))) then
										local v180 = v105();
										if (v180 or ((4397 - (275 + 146)) < (465 + 2392))) then
											return v180;
										end
										if (((4994 - (29 + 35)) > (10224 - 7917)) and v10.CastAnnotated(v51.Pool, false, "WAIT/AoE")) then
											return "Wait for AoE";
										end
									end
									if (true or ((12085 - 8039) < (5699 - 4408))) then
										local v181 = 0 + 0;
										local v182;
										while true do
											if ((v181 == (1013 - (53 + 959))) or ((4649 - (312 + 96)) == (6152 - 2607))) then
												if (v10.CastAnnotated(v51.Pool, false, "WAIT/ST") or ((4333 - (147 + 138)) > (5131 - (813 + 86)))) then
													return "Wait for ST";
												end
												break;
											end
											if ((v181 == (0 + 0)) or ((3242 - 1492) >= (3965 - (18 + 474)))) then
												v182 = v104();
												if (((1069 + 2097) == (10333 - 7167)) and v182) then
													return v182;
												end
												v181 = 1087 - (860 + 226);
											end
										end
									end
									break;
								end
								if (((2066 - (121 + 182)) < (459 + 3265)) and (v174 == (1240 - (988 + 252)))) then
									if (((7 + 50) <= (853 + 1870)) and v34 and (v13:HealthPercentage() <= v36)) then
										local v183 = 1970 - (49 + 1921);
										while true do
											if ((v183 == (890 - (223 + 667))) or ((2122 - (51 + 1)) == (762 - 319))) then
												if ((v35 == "Refreshing Healing Potion") or ((5792 - 3087) == (2518 - (146 + 979)))) then
													if (v52.RefreshingHealingPotion:IsReady() or ((1299 + 3302) < (666 - (311 + 294)))) then
														if (v10.Press(v54.RefreshingHealingPotion) or ((3876 - 2486) >= (2010 + 2734))) then
															return "refreshing healing potion defensive 4";
														end
													end
												end
												if ((v35 == "Dreamwalker's Healing Potion") or ((3446 - (496 + 947)) > (5192 - (1233 + 125)))) then
													if (v52.DreamwalkersHealingPotion:IsReady() or ((64 + 92) > (3511 + 402))) then
														if (((38 + 157) == (1840 - (963 + 682))) and v10.Press(v54.RefreshingHealingPotion)) then
															return "dreamwalkers healing potion defensive";
														end
													end
												end
												break;
											end
										end
									end
									v100();
									if (((2592 + 513) >= (3300 - (504 + 1000))) and not v13:AffectingCombat()) then
										local v184 = v102();
										if (((2949 + 1430) >= (1941 + 190)) and v184) then
											return v184;
										end
									end
									v64 = (v88 > (1 + 0 + v26(not v51.AetherialKindling:IsAvailable() and not v51.Starweaver:IsAvailable()))) and v51.Starfall:IsAvailable();
									v174 = 1 - 0;
								end
							end
						end
					end
					break;
				end
				if (((3285 + 559) >= (1189 + 854)) and (v154 == (185 - (156 + 26)))) then
					if (v13:IsDeadOrGhost() or ((1862 + 1370) <= (4272 - 1541))) then
						if (((5069 - (149 + 15)) == (5865 - (890 + 70))) and v25(v51.Nothing, nil, nil)) then
							return "Dead";
						end
					end
					v87 = v16:GetEnemiesInSplashRange(127 - (39 + 78));
					v154 = 486 - (14 + 468);
				end
				if ((v154 == (4 - 2)) or ((11560 - 7424) >= (2276 + 2135))) then
					v30 = EpicSettings.Toggles['cds'];
					v31 = EpicSettings.Toggles['toggle'];
					v154 = 2 + 1;
				end
				if ((v154 == (1 + 0)) or ((1336 + 1622) == (1053 + 2964))) then
					v28 = EpicSettings.Toggles['ooc'];
					v29 = EpicSettings.Toggles['aoe'];
					v154 = 3 - 1;
				end
			end
		end);
	end
	local function v108()
		v10.Print("Balance Druid Rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(101 + 1, v107, v108);
end;
return v0["Epix_Druid_Balance.lua"]();

