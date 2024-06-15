local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 + 0;
	local v7;
	while true do
		if (((4886 - 2969) > (1675 - (370 + 17))) and (v6 == (1292 - (783 + 508)))) then
			return v7(v0, ...);
		end
		if (((2266 - (1733 + 39)) <= (9210 - 5858)) and (v6 == (1034 - (125 + 909)))) then
			v7 = v1[v5];
			if (not v7 or ((5608 - (1096 + 852)) <= (927 + 1138))) then
				return v2(v5, v0, ...);
			end
			v6 = 1 - 0;
		end
	end
end
v1["Epix_Druid_Balance.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.MouseOver;
	local v16 = v13.Pet;
	local v17 = v13.Target;
	local v18 = v11.Spell;
	local v19 = v11.MultiSpell;
	local v20 = v11.Item;
	local v21 = v11.Macro;
	local v22 = v11.Bind;
	local v23 = v11.AoEON;
	local v24 = v11.CDsON;
	local v25 = v11.Cast;
	local v26 = v11.Press;
	local v27 = v11.Commons.Everyone.num;
	local v28 = v11.Commons.Everyone.bool;
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
	local function v51()
		v33 = EpicSettings.Settings['UseRacials'];
		v35 = EpicSettings.Settings['UseHealingPotion'];
		v36 = EpicSettings.Settings['HealingPotionName'];
		v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v38 = EpicSettings.Settings['UseHealthstone'];
		v39 = EpicSettings.Settings['HealthstoneHP'] or (512 - (409 + 103));
		v40 = EpicSettings.Settings['InterruptWithStun'];
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v42 = EpicSettings.Settings['InterruptThreshold'] or (236 - (46 + 190));
		v43 = EpicSettings.Settings['OutOfCombatHealing'];
		v44 = EpicSettings.Settings['MarkOfTheWild'];
		v45 = EpicSettings.Settings['MoonkinFormOOC'];
		v46 = EpicSettings.Settings['BarkskinHP'] or (95 - (51 + 44));
		v47 = EpicSettings.Settings['NaturesVigilHP'] or (0 + 0);
		v48 = EpicSettings.Settings['WildMushroom'];
		v49 = EpicSettings.Settings['Starfall'];
		v50 = EpicSettings.Settings['UseIncarnation'];
	end
	local v52 = v11.Commons.Everyone;
	local v53 = v18.Druid.Balance;
	local v54 = v20.Druid.Balance;
	local v55 = {v54.MirrorofFracturedTomorrows:ID()};
	local v56 = v21.Druid.Balance;
	local v57 = v14:GetEquipment();
	local v58 = (v57[739 - (228 + 498)] and v20(v57[3 + 10])) or v20(0 + 0);
	local v59 = (v57[677 - (174 + 489)] and v20(v57[36 - 22])) or v20(1905 - (830 + 1075));
	local v60 = false;
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
	local v78 = v11.Druid;
	local v79 = 11635 - (303 + 221);
	local v80 = 12380 - (231 + 1038);
	local v81 = (v53.IncarnationTalent:IsAvailable() and v53.Incarnation) or v53.CelestialAlignment;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	local v85 = false;
	local v86 = false;
	local v87 = false;
	local v88 = false;
	v11:RegisterForEvent(function()
		v57 = v14:GetEquipment();
		v58 = (v57[11 + 2] and v20(v57[1175 - (171 + 991)])) or v20(0 - 0);
		v59 = (v57[37 - 23] and v20(v57[34 - 20])) or v20(0 + 0);
		v60 = false;
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		local v123 = 0 - 0;
		while true do
			if ((v123 == (0 - 0)) or ((6625 - 2515) > (13527 - 9151))) then
				v60 = false;
				v79 = 12359 - (111 + 1137);
				v123 = 159 - (91 + 67);
			end
			if ((v123 == (2 - 1)) or ((407 + 1223) > (4721 - (423 + 100)))) then
				v80 = 78 + 11033;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v11:RegisterForEvent(function()
		v81 = (v53.IncarnationTalent:IsAvailable() and v53.Incarnation) or v53.CelestialAlignment;
		v60 = false;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v89, v90;
	local function v91(v124)
		local v125 = 0 - 0;
		local v126;
		while true do
			if (((550 + 504) == (1825 - (326 + 445))) and ((4 - 3) == v125)) then
				return v126;
			end
			if ((v125 == (0 - 0)) or ((1577 - 901) >= (2353 - (530 + 181)))) then
				v126 = 881 - (614 + 267);
				if (((4168 - (19 + 13)) > (3901 - 1504)) and (v124 == v53.Wrath)) then
					v126 = 18 - 10;
					if (v53.WildSurges:IsAvailable() or ((12380 - 8046) == (1103 + 3142))) then
						v126 = v126 + (3 - 1);
					end
					if ((v53.SouloftheForest:IsAvailable() and v14:BuffUp(v53.EclipseSolar)) or ((8867 - 4591) <= (4843 - (1293 + 519)))) then
						v126 = v126 * (1.6 - 0);
					end
				elseif ((v124 == v53.Starfire) or ((12485 - 7703) <= (2292 - 1093))) then
					local v174 = 0 - 0;
					while true do
						if ((v174 == (2 - 1)) or ((2577 + 2287) < (389 + 1513))) then
							if (((11242 - 6403) >= (856 + 2844)) and v14:BuffUp(v53.WarriorofEluneBuff)) then
								v126 = v126 * (1.4 + 0);
							end
							if ((v53.SouloftheForest:IsAvailable() and v14:BuffUp(v53.EclipseLunar)) or ((672 + 403) > (3014 - (709 + 387)))) then
								local v180 = 1858 - (673 + 1185);
								local v181;
								while true do
									if (((1148 - 752) <= (12215 - 8411)) and (v180 == (1 - 0))) then
										v126 = v126 * v181;
										break;
									end
									if ((v180 == (0 + 0)) or ((3116 + 1053) == (2952 - 765))) then
										v181 = 1 + 0 + ((0.2 - 0) * v90);
										if (((2759 - 1353) == (3286 - (446 + 1434))) and (v181 > (1284.6 - (1040 + 243)))) then
											v181 = 2.6 - 1;
										end
										v180 = 1848 - (559 + 1288);
									end
								end
							end
							break;
						end
						if (((3462 - (609 + 1322)) < (4725 - (13 + 441))) and (v174 == (0 - 0))) then
							v126 = 26 - 16;
							if (((3162 - 2527) == (24 + 611)) and v53.WildSurges:IsAvailable()) then
								v126 = v126 + (7 - 5);
							end
							v174 = 1 + 0;
						end
					end
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v92(v127)
		local v128 = 0 - 0;
		local v129;
		while true do
			if (((1846 + 1527) <= (6539 - 2983)) and (v128 == (0 + 0))) then
				v129 = v127:DebuffRemains(v53.SunfireDebuff);
				return v127:DebuffRefreshable(v53.SunfireDebuff) and (v129 < (2 + 0)) and ((v127:TimeToDie() - v129) > (5 + 1));
			end
		end
	end
	local function v93(v130)
		return v130:DebuffRefreshable(v53.SunfireDebuff) and (v14:AstralPowerDeficit() > (v68 + v53.Sunfire:EnergizeAmount()));
	end
	local function v94(v131)
		local v132 = 0 + 0;
		local v133;
		while true do
			if ((v132 == (0 + 0)) or ((3724 - (153 + 280)) < (9471 - 6191))) then
				v133 = v131:DebuffRemains(v53.MoonfireDebuff);
				return v131:DebuffRefreshable(v53.MoonfireDebuff) and (v133 < (2 + 0)) and ((v131:TimeToDie() - v133) > (3 + 3));
			end
		end
	end
	local function v95(v134)
		return v134:DebuffRefreshable(v53.MoonfireDebuff) and (v14:AstralPowerDeficit() > (v68 + v53.Moonfire:EnergizeAmount()));
	end
	local function v96(v135)
		local v136 = v135:DebuffRemains(v53.StellarFlareDebuff);
		return v135:DebuffRefreshable(v53.StellarFlareDebuff) and (v14:AstralPowerDeficit() > (v68 + v53.StellarFlare:EnergizeAmount())) and (v136 < (2 + 0)) and ((v135:TimeToDie() - v136) > (8 + 0));
	end
	local function v97(v137)
		return v137:DebuffRefreshable(v53.StellarFlareDebuff) and (v14:AstralPowerDeficit() > (v68 + v53.StellarFlare:EnergizeAmount()));
	end
	local function v98(v138)
		return v138:DebuffRefreshable(v53.SunfireDebuff) and ((v138:TimeToDie() - v17:DebuffRemains(v53.SunfireDebuff)) > ((5 + 1) - (v90 / (2 - 0)))) and (v14:AstralPowerDeficit() > (v68 + v53.Sunfire:EnergizeAmount()));
	end
	local function v99(v139)
		return v139:DebuffRefreshable(v53.MoonfireDebuff) and ((v139:TimeToDie() - v17:DebuffRemains(v53.MoonfireDebuff)) > (4 + 2)) and (v14:AstralPowerDeficit() > (v68 + v53.Moonfire:EnergizeAmount()));
	end
	local function v100(v140)
		return v140:DebuffRefreshable(v53.StellarFlareDebuff) and (((v140:TimeToDie() - v140:DebuffRemains(v53.StellarFlareDebuff)) - v140:GetEnemiesInSplashRangeCount(675 - (89 + 578))) > (6 + 2 + v90));
	end
	local function v101(v141)
		return v141:DebuffRemains(v53.MoonfireDebuff) > ((v141:DebuffRemains(v53.SunfireDebuff) * (45 - 23)) / (1067 - (572 + 477)));
	end
	local function v102()
		v82 = v14:BuffUp(v53.EclipseSolar) or v14:BuffUp(v53.EclipseLunar);
		v83 = v14:BuffUp(v53.EclipseSolar) and v14:BuffUp(v53.EclipseLunar);
		v84 = v14:BuffUp(v53.EclipseLunar) and v14:BuffDown(v53.EclipseSolar);
		v85 = v14:BuffUp(v53.EclipseSolar) and v14:BuffDown(v53.EclipseLunar);
		v86 = (not v82 and (((v53.Starfire:Count() == (0 + 0)) and (v53.Wrath:Count() > (0 + 0))) or v14:IsCasting(v53.Wrath))) or v85;
		v87 = (not v82 and (((v53.Wrath:Count() == (0 + 0)) and (v53.Starfire:Count() > (86 - (84 + 2)))) or v14:IsCasting(v53.Starfire))) or v84;
		v88 = not v82 and (v53.Wrath:Count() > (0 - 0)) and (v53.Starfire:Count() > (0 + 0));
	end
	local function v103()
		local v142 = 842 - (497 + 345);
		local v143;
		local v144;
		while true do
			if (((113 + 4273) >= (148 + 725)) and (v142 == (1334 - (605 + 728)))) then
				v143 = ((v58:IsUsable() or (v58:ID() == v54.SpoilsofNeltharus:ID()) or (v58:ID() == v54.MirrorofFracturedTomorrows:ID())) and (1 + 0)) or (0 - 0);
				v65 = v65 + v143;
				v142 = 1 + 1;
			end
			if (((3405 - 2484) <= (994 + 108)) and (v142 == (7 - 4))) then
				v65 = v65 + v144;
				v60 = true;
				break;
			end
			if (((3554 + 1152) >= (1452 - (457 + 32))) and (v142 == (1 + 1))) then
				v144 = ((v59:IsUsable() or (v59:ID() == v54.SpoilsofNeltharus:ID()) or (v59:ID() == v54.MirrorofFracturedTomorrows:ID())) and (1404 - (832 + 570))) or (0 + 0);
				v144 = ((v59:ID() == v54.SpoilsofNeltharus:ID()) and (1 + 0)) or (0 - 0);
				v142 = 2 + 1;
			end
			if ((v142 == (796 - (588 + 208))) or ((2587 - 1627) <= (2676 - (884 + 916)))) then
				v61 = (not v53.CelestialAlignment:IsAvailable() and not v53.IncarnationTalent:IsAvailable()) or not v24();
				v65 = 0 - 0;
				v142 = 1 + 0;
			end
		end
	end
	local function v104()
		local v145 = 653 - (232 + 421);
		while true do
			if (((1889 - (1569 + 320)) == v145) or ((507 + 1559) == (178 + 754))) then
				if (((16259 - 11434) < (5448 - (316 + 289))) and v53.MarkOfTheWild:IsCastable() and v52.GroupBuffMissing(v53.MarkOfTheWild)) then
					if (v25(v53.MarkOfTheWild, v44) or ((10148 - 6271) >= (210 + 4327))) then
						return "mark_of_the_wild precombat";
					end
				end
				if (v53.MoonkinForm:IsCastable() or ((5768 - (666 + 787)) < (2151 - (360 + 65)))) then
					if (v26(v53.MoonkinForm) or ((3439 + 240) < (879 - (79 + 175)))) then
						return "moonkin_form";
					end
				end
				v145 = 1 - 0;
			end
			if ((v145 == (1 + 0)) or ((14176 - 9551) < (1216 - 584))) then
				if ((v53.Wrath:IsCastable() and not v14:IsCasting(v53.Wrath)) or ((982 - (503 + 396)) > (1961 - (92 + 89)))) then
					if (((1058 - 512) <= (553 + 524)) and v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
						return "wrath precombat 2";
					end
				end
				if ((v53.Wrath:IsCastable() and ((v14:IsCasting(v53.Wrath) and (v53.Wrath:Count() == (2 + 0))) or (v14:PrevGCD(3 - 2, v53.Wrath) and (v53.Wrath:Count() == (1 + 0))))) or ((2270 - 1274) > (3753 + 548))) then
					if (((1944 + 2126) > (2092 - 1405)) and v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
						return "wrath precombat 4";
					end
				end
				v145 = 1 + 1;
			end
			if ((v145 == (2 - 0)) or ((1900 - (485 + 759)) >= (7705 - 4375))) then
				if (v53.StellarFlare:IsCastable() or ((3681 - (442 + 747)) <= (1470 - (832 + 303)))) then
					if (((5268 - (88 + 858)) >= (781 + 1781)) and v25(v53.StellarFlare, nil, nil, not v17:IsSpellInRange(v53.StellarFlare))) then
						return "stellar_flare precombat 6";
					end
				end
				if ((v53.Starfire:IsCastable() and not v53.StellarFlare:IsAvailable()) or ((3010 + 627) >= (156 + 3614))) then
					if (v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire)) or ((3168 - (766 + 23)) > (22600 - 18022))) then
						return "starfire precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v105()
		if ((v53.Starfall:IsReady() and v66) or ((659 - 176) > (1957 - 1214))) then
			if (((8328 - 5874) > (1651 - (1036 + 37))) and v25(v53.Starfall, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
				return "starfall fallthru 2";
			end
		end
		if (((660 + 270) < (8681 - 4223)) and v53.Starsurge:IsReady()) then
			if (((521 + 141) <= (2452 - (641 + 839))) and v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge))) then
				return "starsurge fallthru 4";
			end
		end
		if (((5283 - (910 + 3)) == (11140 - 6770)) and v53.WildMushroom:IsReady() and not v66) then
			if (v25(v53.WildMushroom, v48, nil, not v17:IsSpellInRange(v53.WildMushroom)) or ((6446 - (1466 + 218)) <= (396 + 465))) then
				return "wild_mushroom fallthru 6";
			end
		end
		if (v53.Sunfire:IsCastable() or ((2560 - (556 + 592)) == (1517 + 2747))) then
			if (v52.CastCycle(v53.Sunfire, v89, v101, not v17:IsSpellInRange(v53.Sunfire)) or ((3976 - (329 + 479)) < (3007 - (174 + 680)))) then
				return "sunfire fallthru 8";
			end
		end
		if (v53.Moonfire:IsCastable() or ((17098 - 12122) < (2760 - 1428))) then
			if (((3305 + 1323) == (5367 - (396 + 343))) and v25(v53.Moonfire, nil, nil, not v17:IsSpellInRange(v53.Moonfire))) then
				return "moonfire fallthru 10";
			end
		end
	end
	local function v106()
		if (v53.Sunfire:IsCastable() or ((5 + 49) == (1872 - (29 + 1448)))) then
			if (((1471 - (135 + 1254)) == (308 - 226)) and v52.CastCycle(v53.Sunfire, v89, v92, not v17:IsSpellInRange(v53.Sunfire))) then
				return "sunfire st 2";
			end
		end
		v69 = v31 and (v81:CooldownRemains() < (23 - 18)) and not v75 and (((v17:TimeToDie() > (10 + 5)) and (v74 < (2007 - (389 + 1138)))) or (v80 < ((599 - (102 + 472)) + ((10 + 0) * v27(v53.Incarnation:IsAvailable())))));
		if (v53.Moonfire:IsCastable() or ((323 + 258) < (263 + 19))) then
			if (v52.CastCycle(v53.Moonfire, v89, v94, not v17:IsSpellInRange(v53.Moonfire)) or ((6154 - (320 + 1225)) < (4441 - 1946))) then
				return "moonfire st 6";
			end
		end
		if (((705 + 447) == (2616 - (157 + 1307))) and v53.StellarFlare:IsCastable()) then
			if (((3755 - (821 + 1038)) <= (8537 - 5115)) and v52.CastCycle(v53.StellarFlare, v89, v96, not v17:IsSpellInRange(v53.StellarFlare))) then
				return "stellar_flare st 10";
			end
		end
		if ((v14:BuffUp(v53.StarlordBuff) and (v14:BuffRemains(v53.StarlordBuff) < (1 + 1)) and (((v74 >= (976 - 426)) and not v75 and v14:BuffUp(v53.StarweaversWarp)) or ((v74 >= (209 + 351)) and v14:BuffUp(v53.StarweaversWeft)))) or ((2453 - 1463) > (2646 - (834 + 192)))) then
			if (v11.CastAnnotated(v56.CancelStarlord, false, "CANCEL") or ((56 + 821) > (1206 + 3489))) then
				return "cancel_buff starlord st 11";
			end
		end
		if (((58 + 2633) >= (2867 - 1016)) and v53.Starfall:IsReady() and (v74 >= (854 - (300 + 4))) and not v75 and v14:BuffUp(v53.StarweaversWarp)) then
			if (v25(v53.Starfall, v49, nil, not v17:IsSpellInRange(v53.Wrath)) or ((798 + 2187) >= (12711 - 7855))) then
				return "starfall st 12";
			end
		end
		if (((4638 - (112 + 250)) >= (477 + 718)) and v53.Starsurge:IsReady() and (v74 >= (1402 - 842)) and v14:BuffUp(v53.StarweaversWeft)) then
			if (((1852 + 1380) <= (2426 + 2264)) and v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge))) then
				return "starsurge st 13";
			end
		end
		if ((v53.Starfire:IsReady() and v14:BuffUp(v53.DreamstateBuff) and v69 and v84) or ((671 + 225) >= (1560 + 1586))) then
			if (((2274 + 787) >= (4372 - (1001 + 413))) and v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire))) then
				return "starfire st 14";
			end
		end
		if (((7106 - 3919) >= (1526 - (244 + 638))) and v53.Wrath:IsReady() and v14:BuffUp(v53.DreamstateBuff) and v69 and v14:BuffUp(v53.EclipseSolar)) then
			if (((1337 - (627 + 66)) <= (2097 - 1393)) and v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
				return "wrath st 15";
			end
		end
		if (((1560 - (512 + 90)) > (2853 - (1665 + 241))) and v31) then
			local v161 = 717 - (373 + 344);
			while true do
				if (((2026 + 2466) >= (703 + 1951)) and (v161 == (0 - 0))) then
					if (((5824 - 2382) >= (2602 - (35 + 1064))) and v53.CelestialAlignment:IsCastable() and v69 and v50) then
						if (v26(v53.CelestialAlignment) or ((2307 + 863) <= (3131 - 1667))) then
							return "celestial_alignment st 16";
						end
					end
					if ((v53.Incarnation:IsCastable() and v69 and v50) or ((20 + 4777) == (5624 - (298 + 938)))) then
						if (((1810 - (233 + 1026)) <= (2347 - (636 + 1030))) and v26(v53.Incarnation)) then
							return "incarnation st 18";
						end
					end
					break;
				end
			end
		end
		v64 = ((v74 < (266 + 254)) and (v81:CooldownRemains() > (5 + 0)) and (v90 < (1 + 2))) or v14:HasTier(3 + 28, 223 - (55 + 166));
		v71 = v88 or (v64 and v14:BuffUp(v53.EclipseSolar) and (v14:BuffRemains(v53.EclipseSolar) < v53.Starfire:CastTime())) or (not v64 and v14:BuffUp(v53.EclipseLunar) and (v14:BuffRemains(v53.EclipseLunar) < v53.Wrath:CastTime()));
		if (((636 + 2641) > (41 + 366)) and v53.WarriorofElune:IsCastable() and v64 and (v71 or (v14:BuffRemains(v53.EclipseSolar) < (26 - 19)))) then
			if (((4992 - (36 + 261)) >= (2474 - 1059)) and v25(v53.WarriorofElune)) then
				return "warrior_of_elune st 20";
			end
		end
		if ((v53.Starfire:IsCastable() and v71 and (v64 or v14:BuffUp(v53.EclipseSolar))) or ((4580 - (34 + 1334)) <= (363 + 581))) then
			if (v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire)) or ((2406 + 690) <= (3081 - (1035 + 248)))) then
				return "starfire st 24";
			end
		end
		if (((3558 - (20 + 1)) == (1843 + 1694)) and v53.Wrath:IsCastable() and v71) then
			if (((4156 - (134 + 185)) >= (2703 - (549 + 584))) and v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
				return "wrath st 26";
			end
		end
		v73 = (v76 > (689 - (314 + 371))) or (((v81:CooldownRemains() > (102 - 72)) or v61) and ((v14:BuffRemains(v53.EclipseLunar) > (972 - (478 + 490))) or (v14:BuffRemains(v53.EclipseSolar) > (3 + 1))));
		if ((v53.Starsurge:IsReady() and v53.ConvokeTheSpirits:IsAvailable() and v53.ConvokeTheSpirits:IsCastable() and v73) or ((4122 - (786 + 386)) == (12346 - 8534))) then
			if (((6102 - (1055 + 324)) >= (3658 - (1093 + 247))) and v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge))) then
				return "starsurge st 28";
			end
		end
		if ((v53.ConvokeTheSpirits:IsCastable() and v24() and v73) or ((1802 + 225) > (300 + 2552))) then
			if (v25(v53.ConvokeTheSpirits, nil, not v17:IsSpellInRange(v53.Wrath)) or ((4510 - 3374) > (14650 - 10333))) then
				return "convoke_the_spirits st 30";
			end
		end
		if (((13510 - 8762) == (11931 - 7183)) and v53.AstralCommunion:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.AstralCommunion:EnergizeAmount()))) then
			if (((1329 + 2407) <= (18260 - 13520)) and v25(v53.AstralCommunion)) then
				return "astral_communion st 32";
			end
		end
		if ((v53.ForceOfNature:IsCastable() and v24() and (v14:AstralPowerDeficit() > (v68 + v53.ForceOfNature:EnergizeAmount()))) or ((11684 - 8294) <= (2308 + 752))) then
			if (v25(v56.ForceOfNatureCusor, nil, not v17:IsSpellInRange(v53.Wrath)) or ((2554 - 1555) > (3381 - (364 + 324)))) then
				return "force_of_nature st 34";
			end
		end
		if (((1268 - 805) < (1442 - 841)) and v53.FuryOfElune:IsCastable() and (((v17:TimeToDie() > (1 + 1)) and ((v76 > (12 - 9)) or ((v81:CooldownRemains() > (48 - 18)) and (v74 <= (850 - 570))) or ((v74 >= (1828 - (1249 + 19))) and (v14:AstralPowerP() > (46 + 4))))) or (v80 < (38 - 28)))) then
			if (v25(v53.FuryOfElune, nil, not v17:IsSpellInRange(v53.FuryOfElune)) or ((3269 - (686 + 400)) < (540 + 147))) then
				return "fury_of_elune st 36";
			end
		end
		if (((4778 - (73 + 156)) == (22 + 4527)) and v53.Starfall:IsReady() and (v14:BuffUp(v53.StarweaversWarp))) then
			if (((5483 - (721 + 90)) == (53 + 4619)) and v25(v53.Starfall, nil, not v17:IsSpellInRange(v53.Wrath))) then
				return "starfall st 38";
			end
		end
		local v146 = (v53.Starlord:IsAvailable() and (v14:BuffStack(v53.StarlordBuff) < (9 - 6))) or (((v14:BuffStack(v53.BOATArcaneBuff) + v14:BuffStack(v53.BOATNatureBuff)) > (472 - (224 + 246))) and (v14:BuffRemains(v53.StarlordBuff) > (5 - 1)));
		if ((v14:BuffUp(v53.StarlordBuff) and (v14:BuffRemains(v53.StarlordBuff) < (3 - 1)) and v146) or ((666 + 3002) < (10 + 385))) then
			if (v11.CastAnnotated(v56.CancelStarlord, false, "CANCEL") or ((3060 + 1106) == (904 - 449))) then
				return "cancel_buff starlord st 39";
			end
		end
		if ((v53.Starsurge:IsReady() and v146) or ((14805 - 10356) == (3176 - (203 + 310)))) then
			if (v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge)) or ((6270 - (1238 + 755)) < (209 + 2780))) then
				return "starsurge st 40";
			end
		end
		if (v53.Sunfire:IsCastable() or ((2404 - (709 + 825)) >= (7645 - 3496))) then
			if (((3221 - 1009) < (4047 - (196 + 668))) and v52.CastCycle(v53.Sunfire, v89, v93, not v17:IsSpellInRange(v53.Sunfire))) then
				return "sunfire st 42";
			end
		end
		if (((18343 - 13697) > (6197 - 3205)) and v53.Moonfire:IsCastable()) then
			if (((2267 - (171 + 662)) < (3199 - (4 + 89))) and v52.CastCycle(v53.Moonfire, v89, v95, not v17:IsSpellInRange(v53.Moonfire))) then
				return "moonfire st 44";
			end
		end
		if (((2754 - 1968) < (1101 + 1922)) and v53.StellarFlare:IsCastable()) then
			if (v52.CastCycle(v53.StellarFlare, v89, v97, not v17:IsSpellInRange(v53.StellarFlare)) or ((10725 - 8283) < (30 + 44))) then
				return "stellar_flare st 46";
			end
		end
		if (((6021 - (35 + 1451)) == (5988 - (28 + 1425))) and v53.NewMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.NewMoon:EnergizeAmount())) and (v75 or ((v53.NewMoon:ChargesFractional() > (1995.5 - (941 + 1052))) and (v74 <= (499 + 21)) and (v81:CooldownRemains() > (1524 - (822 + 692)))) or (v80 < (14 - 4)))) then
			if (v25(v53.NewMoon, nil, nil, not v17:IsSpellInRange(v53.NewMoon)) or ((1418 + 1591) <= (2402 - (45 + 252)))) then
				return "new_moon st 48";
			end
		end
		if (((1811 + 19) < (1263 + 2406)) and v53.HalfMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.HalfMoon:EnergizeAmount())) and ((v14:BuffRemains(v53.EclipseLunar) > v53.HalfMoon:ExecuteTime()) or (v14:BuffRemains(v53.EclipseSolar) > v53.HalfMoon:ExecuteTime())) and (v75 or ((v53.HalfMoon:ChargesFractional() > (4.5 - 2)) and (v74 <= (953 - (114 + 319))) and (v81:CooldownRemains() > (14 - 4))) or (v80 < (12 - 2)))) then
			if (v25(v53.HalfMoon, nil, nil, not v17:IsSpellInRange(v53.HalfMoon)) or ((912 + 518) >= (5380 - 1768))) then
				return "half_moon st 50";
			end
		end
		if (((5621 - 2938) >= (4423 - (556 + 1407))) and v53.FullMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.FullMoon:EnergizeAmount())) and ((v14:BuffRemains(v53.EclipseLunar) > v53.FullMoon:ExecuteTime()) or (v14:BuffRemains(v53.EclipseSolar) > v53.FullMoon:ExecuteTime())) and (v75 or ((v53.HalfMoon:ChargesFractional() > (1208.5 - (741 + 465))) and (v74 <= (985 - (170 + 295))) and (v81:CooldownRemains() > (6 + 4))) or (v80 < (10 + 0)))) then
			if (v25(v53.FullMoon, nil, nil, not v17:IsSpellInRange(v53.FullMoon)) or ((4441 - 2637) >= (2715 + 560))) then
				return "full_moon st 52";
			end
		end
		local v147 = v14:BuffUp(v53.StarweaversWeft) or (v14:AstralPowerDeficit() < (v68 + v91(v53.Wrath) + ((v91(v53.Starfire) + v68) * (v27(v14:BuffRemains(v53.EclipseSolar) < (v14:GCD() * (2 + 1))))))) or (v53.AstralCommunion:IsAvailable() and (v53.AstralCommunion:CooldownRemains() < (2 + 1))) or (v80 < (1235 - (957 + 273)));
		if ((v14:BuffUp(v53.StarlordBuff) and (v14:BuffRemains(v53.StarlordBuff) < (1 + 1)) and v147) or ((568 + 849) > (13828 - 10199))) then
			if (((12635 - 7840) > (1227 - 825)) and v26(v56.CancelStarlord, false, "CANCEL")) then
				return "cancel_buff starlord st 53";
			end
		end
		if (((23832 - 19019) > (5345 - (389 + 1391))) and v53.Starsurge:IsReady() and v147) then
			if (((2455 + 1457) == (408 + 3504)) and v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge))) then
				return "starsurge st 54";
			end
		end
		if (((6422 - 3601) <= (5775 - (783 + 168))) and v53.Wrath:IsCastable() and not v14:IsMoving()) then
			if (((5832 - 4094) <= (2160 + 35)) and v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath))) then
				return "wrath st 60";
			end
		end
		local v148 = v105();
		if (((352 - (309 + 2)) <= (9267 - 6249)) and v148) then
			return v148;
		end
		if (((3357 - (1090 + 122)) <= (1331 + 2773)) and v11.CastAnnotated(v53.Pool, false, "MOVING")) then
			return "Pool ST due to movement and no fallthru";
		end
	end
	local function v107()
		local v149 = 0 - 0;
		local v150;
		local v151;
		local v152;
		local v153;
		local v154;
		local v155;
		local v156;
		while true do
			if (((1841 + 848) < (5963 - (628 + 490))) and (v149 == (2 + 5))) then
				if ((v53.Starsurge:IsReady() and v14:BuffUp(v53.StarweaversWeft) and (v90 < (41 - 24))) or ((10611 - 8289) > (3396 - (431 + 343)))) then
					if (v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge)) or ((9156 - 4622) == (6022 - 3940))) then
						return "starsurge aoe 44";
					end
				end
				v154 = 0 + 0;
				v155 = 0 + 0;
				if (v14:BuffUp(v53.EclipseLunar) or ((3266 - (556 + 1139)) > (1882 - (6 + 9)))) then
					local v166 = 0 + 0;
					local v167;
					local v168;
					local v169;
					while true do
						if ((v166 == (1 + 0)) or ((2823 - (28 + 141)) >= (1161 + 1835))) then
							v169 = (v168 - (18 - 3)) / (2 + 0);
							break;
						end
						if (((5295 - (486 + 831)) > (5475 - 3371)) and (v166 == (0 - 0))) then
							v167 = v14:BuffInfo(v53.EclipseLunar, nil, true);
							v168 = v167.points[1 + 0];
							v166 = 3 - 2;
						end
					end
				end
				v149 = 1271 - (668 + 595);
			end
			if (((2695 + 300) > (311 + 1230)) and (v149 == (10 - 6))) then
				if (((3539 - (23 + 267)) > (2897 - (1129 + 815))) and v53.FuryOfElune:IsCastable() and (((v17:TimeToDie() > (389 - (371 + 16))) and ((v76 > (1753 - (1326 + 424))) or ((v81:CooldownRemains() > (56 - 26)) and (v74 <= (1023 - 743))) or ((v74 >= (678 - (88 + 30))) and (v14:AstralPowerP() > (821 - (720 + 51)))))) or (v80 < (22 - 12)))) then
					if (v25(v53.FuryOfElune, nil, not v17:IsSpellInRange(v53.FuryOfElune)) or ((5049 - (421 + 1355)) > (7544 - 2971))) then
						return "fury_of_elune aoe 22";
					end
				end
				v153 = (v17:TimeToDie() > (2 + 2)) and (v14:BuffUp(v53.StarweaversWarp) or (v53.Starlord:IsAvailable() and (v14:BuffStack(v53.StarlordBuff) < (1086 - (286 + 797)))));
				if ((v14:BuffUp(v53.StarlordBuff) and (v14:BuffRemains(v53.StarlordBuff) < (7 - 5)) and v153) or ((5218 - 2067) < (1723 - (397 + 42)))) then
					if (v11.CastAnnotated(v56.CancelStarlord, false, "CANCEL") or ((578 + 1272) == (2329 - (24 + 776)))) then
						return "cancel_buff starlord aoe 23";
					end
				end
				if (((1264 - 443) < (2908 - (222 + 563))) and v53.Starfall:IsReady() and v153) then
					if (((1986 - 1084) < (1674 + 651)) and v25(v53.Starfall, v49, nil, not v17:IsSpellInRange(v53.Wrath))) then
						return "starfall aoe 24";
					end
				end
				v149 = 195 - (23 + 167);
			end
			if (((2656 - (690 + 1108)) <= (1069 + 1893)) and (v149 == (0 + 0))) then
				v150 = v14:IsInParty() and not v14:IsInRaid();
				if ((v53.Moonfire:IsCastable() and v150) or ((4794 - (40 + 808)) < (213 + 1075))) then
					if (v52.CastCycle(v53.Moonfire, v89, v99, not v17:IsSpellInRange(v53.Moonfire)) or ((12397 - 9155) == (542 + 25))) then
						return "moonfire aoe 2";
					end
				end
				v70 = v24() and (v81:CooldownRemains() < (3 + 2)) and not v75 and (((v17:TimeToDie() > (6 + 4)) and (v74 < (1071 - (47 + 524)))) or (v80 < (17 + 8 + ((27 - 17) * v27(v53.Incarnation:IsAvailable())))));
				if (v53.Sunfire:IsCastable() or ((1265 - 418) >= (2880 - 1617))) then
					if (v52.CastCycle(v53.Sunfire, v89, v98, not v17:IsSpellInRange(v53.Sunfire)) or ((3979 - (1165 + 561)) == (55 + 1796))) then
						return "sunfire aoe 4";
					end
				end
				v149 = 3 - 2;
			end
			if ((v149 == (1 + 0)) or ((2566 - (341 + 138)) > (641 + 1731))) then
				if ((v53.Moonfire:IsCastable() and not v150) or ((9173 - 4728) < (4475 - (89 + 237)))) then
					if (v52.CastCycle(v53.Moonfire, v89, v99, not v17:IsSpellInRange(v53.Moonfire)) or ((5848 - 4030) == (178 - 93))) then
						return "moonfire aoe 6";
					end
				end
				if (((1511 - (581 + 300)) < (3347 - (855 + 365))) and v53.StellarFlare:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.StellarFlare:EnergizeAmount())) and (v90 < (((26 - 15) - v53.UmbralIntensity:TalentRank()) - v53.AstralSmolder:TalentRank())) and v70) then
					if (v52.CastCycle(v53.StellarFlare, v89, v100, not v17:IsSpellInRange(v53.StellarFlare)) or ((633 + 1305) == (3749 - (1030 + 205)))) then
						return "stellar_flare aoe 9";
					end
				end
				v151 = (v70 and ((v53.OrbitalStrike:IsAvailable() and (v14:AstralPowerDeficit() < (v68 + ((8 + 0) * v90)))) or v14:BuffUp(v53.TouchTheCosmos))) or (v14:AstralPowerDeficit() < (v68 + 8 + 0 + ((298 - (156 + 130)) * v27((v14:BuffRemains(v53.EclipseLunar) < (8 - 4)) or (v14:BuffRemains(v53.EclipseSolar) < (6 - 2))))));
				if (((8714 - 4459) >= (15 + 40)) and v14:BuffUp(v53.StarlordBuff) and (v14:BuffRemains(v53.StarlordBuff) < (2 + 0)) and v151) then
					if (((3068 - (10 + 59)) > (327 + 829)) and v11.CastAnnotated(v56.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord aoe 9.5";
					end
				end
				v149 = 9 - 7;
			end
			if (((3513 - (671 + 492)) > (920 + 235)) and (v149 == (1221 - (369 + 846)))) then
				if (((1067 + 2962) <= (4142 + 711)) and v53.ConvokeTheSpirits:IsCastable() and v24() and (v14:AstralPowerP() < (1995 - (1036 + 909))) and (v90 < (3 + 0 + v27(v53.ElunesGuidance:IsAvailable()))) and ((v14:BuffRemains(v53.EclipseLunar) > (6 - 2)) or (v14:BuffRemains(v53.EclipseSolar) > (207 - (11 + 192))))) then
					if (v25(v53.ConvokeTheSpirits, nil, not v17:IsInRange(21 + 19)) or ((691 - (135 + 40)) > (8320 - 4886))) then
						return "convoke_the_spirits aoe 36";
					end
				end
				if (((2439 + 1607) >= (6681 - 3648)) and v53.NewMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.NewMoon:EnergizeAmount()))) then
					if (v25(v53.NewMoon, nil, nil, not v17:IsSpellInRange(v53.NewMoon)) or ((4075 - 1356) <= (1623 - (50 + 126)))) then
						return "new_moon aoe 38";
					end
				end
				if ((v53.HalfMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.HalfMoon:EnergizeAmount())) and ((v14:BuffRemains(v53.EclipseLunar) > v53.FullMoon:ExecuteTime()) or (v14:BuffRemains(v53.EclipseSolar) > v53.FullMoon:ExecuteTime()))) or ((11511 - 7377) < (869 + 3057))) then
					if (v25(v53.HalfMoon, nil, nil, not v17:IsSpellInRange(v53.HalfMoon)) or ((1577 - (1233 + 180)) >= (3754 - (522 + 447)))) then
						return "half_moon aoe 40";
					end
				end
				if ((v53.ForceOfNature:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.ForceOfNature:EnergizeAmount()))) or ((1946 - (107 + 1314)) == (979 + 1130))) then
					if (((100 - 67) == (15 + 18)) and v25(v56.ForceOfNatureCusor, nil, not v17:IsSpellInRange(v53.Wrath))) then
						return "force_of_nature aoe 42";
					end
				end
				v149 = 13 - 6;
			end
			if (((12083 - 9029) <= (5925 - (716 + 1194))) and (v149 == (1 + 4))) then
				if (((201 + 1670) < (3885 - (74 + 429))) and v53.FullMoon:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.FullMoon:EnergizeAmount())) and ((v14:BuffRemains(v53.EclipseLunar) > v53.FullMoon:ExecuteTime()) or (v14:BuffRemains(v53.EclipseSolar) > v53.FullMoon:ExecuteTime())) and (v75 or ((v53.HalfMoon:ChargesFractional() > (3.5 - 1)) and (v74 <= (258 + 262)) and (v81:CooldownRemains() > (22 - 12))) or (v80 < (8 + 2)))) then
					if (((3985 - 2692) <= (5355 - 3189)) and v25(v53.FullMoon, nil, nil, not v17:IsSpellInRange(v53.FullMoon))) then
						return "full_moon aoe 26";
					end
				end
				if ((v53.Starsurge:IsReady() and v14:BuffUp(v53.StarweaversWeft) and (v90 < (436 - (279 + 154)))) or ((3357 - (454 + 324)) < (97 + 26))) then
					if (v25(v53.Starsurge, nil, nil, not v17:IsSpellInRange(v53.Starsurge)) or ((863 - (12 + 5)) >= (1277 + 1091))) then
						return "starsurge aoe 30";
					end
				end
				if ((v53.StellarFlare:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.StellarFlare:EnergizeAmount())) and (v90 < (((27 - 16) - v53.UmbralIntensity:TalentRank()) - v53.AstralSmolder:TalentRank()))) or ((1483 + 2529) <= (4451 - (277 + 816)))) then
					if (((6383 - 4889) <= (4188 - (1058 + 125))) and v52.CastCycle(v53.StellarFlare, v89, v100, not v17:IsSpellInRange(v53.StellarFlare))) then
						return "stellar_flare aoe 32";
					end
				end
				if ((v53.AstralCommunion:IsCastable() and (v14:AstralPowerDeficit() > (v68 + v53.AstralCommunion:EnergizeAmount()))) or ((584 + 2527) == (3109 - (815 + 160)))) then
					if (((10104 - 7749) == (5590 - 3235)) and v25(v56.ForceOfNatureCusor)) then
						return "astral_communion aoe 34";
					end
				end
				v149 = 2 + 4;
			end
			if ((v149 == (8 - 5)) or ((2486 - (41 + 1857)) <= (2325 - (1222 + 671)))) then
				v152 = v90 < (7 - 4);
				if (((6895 - 2098) >= (5077 - (229 + 953))) and v53.Starfire:IsCastable() and v152 and (v88 or (v14:BuffRemains(v53.EclipseSolar) < v53.Starfire:CastTime()))) then
					if (((5351 - (1111 + 663)) == (5156 - (874 + 705))) and v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire))) then
						return "starfire aoe 17";
					end
				end
				if (((532 + 3262) > (2520 + 1173)) and v53.Wrath:IsCastable() and not v152 and (v88 or (v14:BuffRemains(v53.EclipseLunar) < v53.Wrath:CastTime()))) then
					if (v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath)) or ((2650 - 1375) == (116 + 3984))) then
						return "wrath aoe 18";
					end
				end
				if ((v53.WildMushroom:IsCastable() and (v14:AstralPowerDeficit() > (v68 + (699 - (642 + 37)))) and (not v53.WaningTwilight:IsAvailable() or ((v17:DebuffRemains(v53.FungalGrowthDebuff) < (1 + 1)) and (v17:TimeToDie() > (2 + 5)) and not v14:PrevGCDP(2 - 1, v53.WildMushroom)))) or ((2045 - (233 + 221)) >= (8278 - 4698))) then
					if (((866 + 117) <= (3349 - (718 + 823))) and v25(v53.WildMushroom, v48, nil, not v17:IsSpellInRange(v53.WildMushroom))) then
						return "wild_mushroom aoe 20";
					end
				end
				v149 = 3 + 1;
			end
			if ((v149 == (807 - (266 + 539))) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
				if (((8946 - 5177) >= (2418 - 1245)) and v53.Starfall:IsReady() and v151) then
					if (((1177 + 308) == (540 + 945)) and v25(v53.Starfall, v49, nil, not v17:IsSpellInRange(v53.Wrath))) then
						return "starfall aoe 10";
					end
				end
				if ((v53.Starfire:IsReady() and v14:BuffUp(v53.DreamstateBuff) and v70 and v14:BuffUp(v53.EclipseLunar)) or ((4330 - (657 + 358)) <= (7365 - 4583))) then
					if (v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire)) or ((1995 - 1119) >= (4151 - (1151 + 36)))) then
						return "starfire aoe 11";
					end
				end
				if (v31 or ((2156 + 76) > (657 + 1840))) then
					if ((v53.CelestialAlignment:IsCastable() and v70) or ((6301 - 4191) <= (2164 - (1552 + 280)))) then
						if (((4520 - (64 + 770)) > (2154 + 1018)) and v26(v53.CelestialAlignment)) then
							return "celestial_alignment aoe 10";
						end
					end
					if ((v53.Incarnation:IsCastable() and v70) or ((10156 - 5682) < (146 + 674))) then
						if (((5522 - (157 + 1086)) >= (5768 - 2886)) and v26(v53.Incarnation)) then
							return "celestial_alignment aoe 12";
						end
					end
				end
				if (v53.WarriorofElune:IsCastable() or ((8886 - 6857) >= (5400 - 1879))) then
					if (v26(v53.WarriorofElune) or ((2780 - 743) >= (5461 - (599 + 220)))) then
						return "warrior_of_elune aoe 14";
					end
				end
				v149 = 5 - 2;
			end
			if (((3651 - (1813 + 118)) < (3259 + 1199)) and (v149 == (1225 - (841 + 376)))) then
				if (v14:BuffUp(v53.EclipseSolar) or ((610 - 174) > (702 + 2319))) then
					local v170 = v14:BuffInfo(v53.EclipseSolar, nil, true);
					local v171 = v170.points[2 - 1];
					local v172 = (v171 - (874 - (464 + 395))) / (5 - 3);
				end
				if (((343 + 370) <= (1684 - (467 + 370))) and v53.Starfire:IsCastable() and not v14:IsMoving() and (((v90 > ((5 - 2) - (v27(v14:BuffUp(v53.DreamstateBuff) or (v154 > v155))))) and v14:BuffUp(v53.EclipseLunar)) or v84)) then
					if (((1582 + 572) <= (13818 - 9787)) and v25(v53.Starfire, nil, nil, not v17:IsSpellInRange(v53.Starfire))) then
						return "starfire aoe 46";
					end
				end
				if (((720 + 3895) == (10737 - 6122)) and v53.Wrath:IsCastable() and not v14:IsMoving()) then
					if (v25(v53.Wrath, nil, nil, not v17:IsSpellInRange(v53.Wrath)) or ((4310 - (150 + 370)) == (1782 - (74 + 1208)))) then
						return "wrath aoe 48";
					end
				end
				v156 = v105();
				v149 = 21 - 12;
			end
			if (((422 - 333) < (158 + 63)) and (v149 == (399 - (14 + 376)))) then
				if (((3561 - 1507) >= (920 + 501)) and v156) then
					return v156;
				end
				if (((608 + 84) < (2917 + 141)) and v11.CastAnnotated(v53.Pool, false, "MOVING")) then
					return "Pool AoE due to movement and no fallthru";
				end
				break;
			end
		end
	end
	local function v108()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((0 + 0) == v157) or ((3332 - (23 + 55)) == (3922 - 2267))) then
				v158 = v52.HandleTopTrinket(v55, v31, 27 + 13, nil);
				if (v158 or ((1164 + 132) == (7613 - 2703))) then
					return v158;
				end
				v157 = 1 + 0;
			end
			if (((4269 - (652 + 249)) == (9013 - 5645)) and ((1869 - (708 + 1160)) == v157)) then
				v158 = v52.HandleBottomTrinket(v55, v31, 108 - 68, nil);
				if (((4818 - 2175) < (3842 - (10 + 17))) and v158) then
					return v158;
				end
				break;
			end
		end
	end
	local function v109()
		C_Timer.After(0.15 + 0, function()
			local v159 = 1732 - (1400 + 332);
			while true do
				if (((3669 - 1756) > (2401 - (242 + 1666))) and (v159 == (2 + 2))) then
					if (((1743 + 3012) > (2922 + 506)) and v30) then
						v90 = v17:GetEnemiesInSplashRangeCount(950 - (850 + 90));
					else
						v90 = 1 - 0;
					end
					if (((2771 - (360 + 1030)) <= (2097 + 272)) and not v14:IsChanneling() and v32) then
						local v173 = 0 - 0;
						while true do
							if ((v173 == (1 - 0)) or ((6504 - (909 + 752)) == (5307 - (109 + 1114)))) then
								if (((8547 - 3878) > (142 + 221)) and v52.TargetIsValid() and not v60) then
									v103();
								end
								if (v52.TargetIsValid() or v14:AffectingCombat() or ((2119 - (6 + 236)) >= (1978 + 1160))) then
									v77 = true;
									v79 = v11.BossFightRemains();
									v80 = v79;
									if (((3817 + 925) >= (8551 - 4925)) and (v80 == (19407 - 8296))) then
										v80 = v11.FightRemains(v89, false);
									end
									v74 = 1133 - (1076 + 57);
									if (v53.PrimordialArcanicPulsar:IsAvailable() or ((747 + 3793) == (1605 - (579 + 110)))) then
										local v182 = 0 + 0;
										local v183;
										while true do
											if ((v182 == (0 + 0)) or ((614 + 542) > (4752 - (174 + 233)))) then
												v183 = v14:BuffInfo(v53.PAPBuff, false, true);
												if (((6248 - 4011) < (7457 - 3208)) and (v183 ~= nil)) then
													v74 = v183.points[1 + 0];
												end
												break;
											end
										end
									end
									v75 = v14:BuffUp(v53.CABuff) or v14:BuffUp(v53.IncarnationBuff);
									v76 = 1174 - (663 + 511);
									if (v75 or ((2394 + 289) < (5 + 18))) then
										v76 = (v53.IncarnationTalent:IsAvailable() and v14:BuffRemains(v53.IncarnationBuff)) or v14:BuffRemains(v53.CABuff);
									end
								end
								v173 = 5 - 3;
							end
							if (((423 + 274) <= (1944 - 1118)) and ((4 - 2) == v173)) then
								if (((528 + 577) <= (2288 - 1112)) and not v14:AffectingCombat()) then
									if (((2409 + 970) <= (349 + 3463)) and v53.MoonkinForm:IsCastable() and v45) then
										if (v26(v53.MoonkinForm) or ((1510 - (478 + 244)) >= (2133 - (440 + 77)))) then
											return "moonkin_form ooc";
										end
									end
								end
								if (((843 + 1011) <= (12367 - 8988)) and ((v52.TargetIsValid() and v29) or v14:AffectingCombat())) then
									local v176 = 1556 - (655 + 901);
									local v177;
									while true do
										if (((844 + 3705) == (3483 + 1066)) and (v176 == (3 + 0))) then
											if ((v66 and v30) or ((12174 - 9152) >= (4469 - (695 + 750)))) then
												local v184 = v107();
												if (((16458 - 11638) > (3391 - 1193)) and v184) then
													return v184;
												end
												if (v11.CastAnnotated(v53.Pool, false, "WAIT/AoE") or ((4267 - 3206) >= (5242 - (285 + 66)))) then
													return "Wait for AoE";
												end
											end
											if (((3179 - 1815) <= (5783 - (682 + 628))) and true) then
												local v185 = 0 + 0;
												local v186;
												while true do
													if ((v185 == (299 - (176 + 123))) or ((1504 + 2091) <= (3 + 0))) then
														v186 = v106();
														if (v186 or ((4941 - (239 + 30)) == (1048 + 2804))) then
															return v186;
														end
														v185 = 1 + 0;
													end
													if (((2758 - 1199) == (4863 - 3304)) and (v185 == (316 - (306 + 9)))) then
														if (v11.CastAnnotated(v53.Pool, false, "WAIT/ST") or ((6113 - 4361) <= (138 + 650))) then
															return "Wait for ST";
														end
														break;
													end
												end
											end
											break;
										end
										if (((0 + 0) == v176) or ((1881 + 2026) == (505 - 328))) then
											if (((4845 - (1140 + 235)) > (354 + 201)) and v35 and (v14:HealthPercentage() <= v37)) then
												if ((v36 == "Refreshing Healing Potion") or ((892 + 80) == (166 + 479))) then
													if (((3234 - (33 + 19)) >= (764 + 1351)) and v54.RefreshingHealingPotion:IsReady()) then
														if (((11668 - 7775) < (1952 + 2477)) and v11.Press(v56.RefreshingHealingPotion)) then
															return "refreshing healing potion defensive 4";
														end
													end
												end
												if ((v36 == "Dreamwalker's Healing Potion") or ((5622 - 2755) < (1787 + 118))) then
													if (v54.DreamwalkersHealingPotion:IsReady() or ((2485 - (586 + 103)) >= (369 + 3682))) then
														if (((4984 - 3365) <= (5244 - (1309 + 179))) and v11.Press(v56.RefreshingHealingPotion)) then
															return "dreamwalkers healing potion defensive";
														end
													end
												end
											end
											v102();
											if (((1089 - 485) == (263 + 341)) and not v14:AffectingCombat()) then
												local v187 = 0 - 0;
												local v188;
												while true do
													if ((v187 == (0 + 0)) or ((9526 - 5042) == (1793 - 893))) then
														v188 = v104();
														if (v188 or ((5068 - (295 + 314)) <= (2733 - 1620))) then
															return v188;
														end
														break;
													end
												end
											end
											v176 = 1963 - (1300 + 662);
										end
										if (((11404 - 7772) > (5153 - (1178 + 577))) and (v176 == (1 + 0))) then
											v66 = (v90 > ((2 - 1) + v27(not v53.AetherialKindling:IsAvailable() and not v53.Starweaver:IsAvailable()))) and v53.Starfall:IsAvailable();
											v67 = v90 > (1406 - (851 + 554));
											v68 = ((6 + 0) / v14:SpellHaste()) + v27(v53.NaturesBalance:IsAvailable()) + (v27(v53.OrbitBreaker:IsAvailable()) * v27(v17:DebuffUp(v53.MoonfireDebuff)) * v27(v78.OrbitBreakerStacks > ((74 - 47) - ((3 - 1) * v27(v14:BuffUp(v53.SolsticeBuff))))) * (342 - (115 + 187)));
											v176 = 2 + 0;
										end
										if (((3865 + 217) <= (19376 - 14459)) and (v176 == (1163 - (160 + 1001)))) then
											if (((4228 + 604) >= (957 + 429)) and v53.Berserking:IsCastable() and v24() and ((v76 >= (40 - 20)) or v61 or (v80 < (373 - (237 + 121))))) then
												if (((1034 - (525 + 372)) == (259 - 122)) and v25(v53.Berserking, v33)) then
													return "berserking main 2";
												end
											end
											v177 = v108();
											if (v177 or ((5158 - 3588) >= (4474 - (96 + 46)))) then
												return v177;
											end
											v176 = 780 - (643 + 134);
										end
									end
								end
								break;
							end
							if ((v173 == (0 + 0)) or ((9744 - 5680) <= (6753 - 4934))) then
								if (v14:AffectingCombat() or ((4782 + 204) < (3088 - 1514))) then
									local v178 = 0 - 0;
									while true do
										if (((5145 - (316 + 403)) > (115 + 57)) and (v178 == (2 - 1))) then
											if (((212 + 374) > (1145 - 690)) and (v14:HealthPercentage() <= v39) and v38 and v54.Healthstone:IsReady()) then
												if (((586 + 240) == (267 + 559)) and v26(v56.Healthstone, nil, nil, true)) then
													return "healthstone defensive 4";
												end
											end
											break;
										end
										if ((v178 == (0 - 0)) or ((19194 - 15175) > (9225 - 4784))) then
											if (((116 + 1901) < (8388 - 4127)) and (v14:HealthPercentage() <= v47) and v53.NaturesVigil:IsReady()) then
												if (((231 + 4485) > (235 - 155)) and v26(v53.NaturesVigil, nil, nil, true)) then
													return "barkskin defensive 2";
												end
											end
											if (((v14:HealthPercentage() <= v46) and v53.Barkskin:IsReady()) or ((3524 - (12 + 5)) == (12708 - 9436))) then
												if (v26(v53.Barkskin, nil, nil, true) or ((1868 - 992) >= (6536 - 3461))) then
													return "barkskin defensive 2";
												end
											end
											v178 = 2 - 1;
										end
									end
								end
								if (((884 + 3468) > (4527 - (1656 + 317))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
									local v179 = v52.DeadFriendlyUnitsCount();
									if (v14:AffectingCombat() or ((3927 + 479) < (3240 + 803))) then
										if (v53.Rebirth:IsCastable() or ((5022 - 3133) >= (16649 - 13266))) then
											if (((2246 - (5 + 349)) <= (12986 - 10252)) and v26(v53.Rebirth, nil, true)) then
												return "rebirth";
											end
										end
									elseif (((3194 - (266 + 1005)) < (1462 + 756)) and v53.Revive:IsCastable()) then
										if (((7414 - 5241) > (498 - 119)) and v26(v53.Revive, not v17:IsInRange(1736 - (561 + 1135)), true)) then
											return "revive";
										end
									end
								end
								v173 = 1 - 0;
							end
						end
					end
					break;
				end
				if (((0 - 0) == v159) or ((3657 - (507 + 559)) == (8554 - 5145))) then
					v89 = v17:GetEnemiesInSplashRange(30 - 20);
					v51();
					v159 = 389 - (212 + 176);
				end
				if (((5419 - (250 + 655)) > (9064 - 5740)) and ((2 - 0) == v159)) then
					v31 = EpicSettings.Toggles['cds'];
					v32 = EpicSettings.Toggles['toggle'];
					v159 = 4 - 1;
				end
				if (((1957 - (1869 + 87)) == v159) or ((721 - 513) >= (6729 - (484 + 1417)))) then
					v29 = EpicSettings.Toggles['ooc'];
					v30 = EpicSettings.Toggles['aoe'];
					v159 = 4 - 2;
				end
				if (((4 - 1) == v159) or ((2356 - (48 + 725)) > (5826 - 2259))) then
					if (v14:IsDeadOrGhost() or ((3522 - 2209) == (462 + 332))) then
						if (((8482 - 5308) > (813 + 2089)) and v26(v53.Nothing, nil, nil)) then
							return "Dead";
						end
					end
					v89 = v17:GetEnemiesInSplashRange(3 + 7);
					v159 = 857 - (152 + 701);
				end
			end
		end);
	end
	local function v110()
		v11.Print("Balance Druid Rotation by Epic. Supported by Gojira");
	end
	v11.SetAPL(1413 - (430 + 881), v109, v110);
end;
return v1["Epix_Druid_Balance.lua"](...);

