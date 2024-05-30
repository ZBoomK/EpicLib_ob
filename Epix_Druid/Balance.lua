local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (683 - (27 + 656))) or ((917 + 132) <= (331 + 575))) then
			v6 = v0[v4];
			if (((2498 + 2015) > (480 + 2246)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1912 - (340 + 1571))) or ((585 + 896) >= (4430 - (1733 + 39)))) then
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
	local v49;
	local function v50()
		local v110 = 0 - 0;
		while true do
			if ((v110 == (1037 - (125 + 909))) or ((5168 - (1096 + 852)) == (612 + 752))) then
				v45 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v46 = EpicSettings.Settings['NaturesVigilHP'] or (0 + 0);
				v47 = EpicSettings.Settings['WildMushroom'];
				v48 = EpicSettings.Settings['Starfall'];
				v110 = 516 - (409 + 103);
			end
			if ((v110 == (240 - (46 + 190))) or ((1149 - (51 + 44)) > (957 + 2435))) then
				v49 = EpicSettings.Settings['UseIncarnation'];
				break;
			end
			if ((v110 == (1318 - (1114 + 203))) or ((1402 - (228 + 498)) >= (356 + 1286))) then
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'];
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v110 = 665 - (174 + 489);
			end
			if (((10775 - 6639) > (4302 - (830 + 1075))) and (v110 == (524 - (303 + 221)))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'];
				v36 = EpicSettings.Settings['HealingPotionHP'] or (1269 - (231 + 1038));
				v110 = 1 + 0;
			end
			if ((v110 == (1164 - (171 + 991))) or ((17861 - 13527) == (11398 - 7153))) then
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v42 = EpicSettings.Settings['OutOfCombatHealing'];
				v43 = EpicSettings.Settings['MarkOfTheWild'];
				v44 = EpicSettings.Settings['MoonkinFormOOC'];
				v110 = 3 + 0;
			end
		end
	end
	local v51 = v10.Commons.Everyone;
	local v52 = v17.Druid.Balance;
	local v53 = v19.Druid.Balance;
	local v54 = {v53.MirrorofFracturedTomorrows:ID()};
	local v55 = v20.Druid.Balance;
	local v56 = v13:GetEquipment();
	local v57 = (v56[37 - 24] and v19(v56[20 - 7])) or v19(0 - 0);
	local v58 = (v56[1262 - (111 + 1137)] and v19(v56[172 - (91 + 67)])) or v19(0 - 0);
	local v59 = false;
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
	local v77 = v10.Druid;
	local v78 = 2773 + 8338;
	local v79 = 11634 - (423 + 100);
	local v80 = (v52.IncarnationTalent:IsAvailable() and v52.Incarnation) or v52.CelestialAlignment;
	local v81 = false;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	local v85 = false;
	local v86 = false;
	local v87 = false;
	v10:RegisterForEvent(function()
		v56 = v13:GetEquipment();
		v57 = (v56[1 + 12] and v19(v56[35 - 22])) or v19(0 + 0);
		v58 = (v56[785 - (326 + 445)] and v19(v56[60 - 46])) or v19(0 - 0);
		v59 = false;
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v111 = 0 - 0;
		while true do
			if ((v111 == (711 - (530 + 181))) or ((5157 - (614 + 267)) <= (3063 - (19 + 13)))) then
				v59 = false;
				v78 = 18084 - 6973;
				v111 = 2 - 1;
			end
			if (((2 - 1) == v111) or ((1242 + 3540) <= (2108 - 909))) then
				v79 = 23042 - 11931;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v80 = (v52.IncarnationTalent:IsAvailable() and v52.Incarnation) or v52.CelestialAlignment;
		v59 = false;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v88, v89;
	local function v90(v112)
		local v113 = 1812 - (1293 + 519);
		if ((v112 == v52.Wrath) or ((9923 - 5059) < (4965 - 3063))) then
			v113 = 14 - 6;
			if (((20866 - 16027) >= (8716 - 5016)) and v52.WildSurges:IsAvailable()) then
				v113 = v113 + 2 + 0;
			end
			if ((v52.SouloftheForest:IsAvailable() and v13:BuffUp(v52.EclipseSolar)) or ((220 + 855) > (4456 - 2538))) then
				v113 = v113 * (1.6 + 0);
			end
		elseif (((132 + 264) <= (2378 + 1426)) and (v112 == v52.Starfire)) then
			v113 = 1106 - (709 + 387);
			if (v52.WildSurges:IsAvailable() or ((6027 - (673 + 1185)) == (6342 - 4155))) then
				v113 = v113 + (6 - 4);
			end
			if (((2312 - 906) == (1006 + 400)) and v13:BuffUp(v52.WarriorofEluneBuff)) then
				v113 = v113 * (1.4 + 0);
			end
			if (((2066 - 535) < (1049 + 3222)) and v52.SouloftheForest:IsAvailable() and v13:BuffUp(v52.EclipseLunar)) then
				local v171 = (1 - 0) + ((0.2 - 0) * v89);
				if (((2515 - (446 + 1434)) == (1918 - (1040 + 243))) and (v171 > (2.6 - 1))) then
					v171 = 1848.6 - (559 + 1288);
				end
				v113 = v113 * v171;
			end
		end
		return v113;
	end
	local function v91(v114)
		local v115 = 1931 - (609 + 1322);
		local v116;
		while true do
			if (((3827 - (13 + 441)) <= (13287 - 9731)) and (v115 == (0 - 0))) then
				v116 = v114:DebuffRemains(v52.SunfireDebuff);
				return v114:DebuffRefreshable(v52.SunfireDebuff) and (v116 < (9 - 7)) and ((v114:TimeToDie() - v116) > (1 + 5));
			end
		end
	end
	local function v92(v117)
		return v117:DebuffRefreshable(v52.SunfireDebuff) and (v13:AstralPowerDeficit() > (v67 + v52.Sunfire:EnergizeAmount()));
	end
	local function v93(v118)
		local v119 = 0 - 0;
		local v120;
		while true do
			if (((0 + 0) == v119) or ((1443 + 1848) < (9733 - 6453))) then
				v120 = v118:DebuffRemains(v52.MoonfireDebuff);
				return v118:DebuffRefreshable(v52.MoonfireDebuff) and (v120 < (2 + 0)) and ((v118:TimeToDie() - v120) > (10 - 4));
			end
		end
	end
	local function v94(v121)
		return v121:DebuffRefreshable(v52.MoonfireDebuff) and (v13:AstralPowerDeficit() > (v67 + v52.Moonfire:EnergizeAmount()));
	end
	local function v95(v122)
		local v123 = 0 + 0;
		local v124;
		while true do
			if (((2440 + 1946) >= (628 + 245)) and (v123 == (0 + 0))) then
				v124 = v122:DebuffRemains(v52.StellarFlareDebuff);
				return v122:DebuffRefreshable(v52.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v67 + v52.StellarFlare:EnergizeAmount())) and (v124 < (2 + 0)) and ((v122:TimeToDie() - v124) > (441 - (153 + 280)));
			end
		end
	end
	local function v96(v125)
		return v125:DebuffRefreshable(v52.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v67 + v52.StellarFlare:EnergizeAmount()));
	end
	local function v97(v126)
		return v126:DebuffRefreshable(v52.SunfireDebuff) and ((v126:TimeToDie() - v16:DebuffRemains(v52.SunfireDebuff)) > ((17 - 11) - (v89 / (2 + 0)))) and (v13:AstralPowerDeficit() > (v67 + v52.Sunfire:EnergizeAmount()));
	end
	local function v98(v127)
		return v127:DebuffRefreshable(v52.MoonfireDebuff) and ((v127:TimeToDie() - v16:DebuffRemains(v52.MoonfireDebuff)) > (3 + 3)) and (v13:AstralPowerDeficit() > (v67 + v52.Moonfire:EnergizeAmount()));
	end
	local function v99(v128)
		return v128:DebuffRefreshable(v52.StellarFlareDebuff) and (((v128:TimeToDie() - v128:DebuffRemains(v52.StellarFlareDebuff)) - v128:GetEnemiesInSplashRangeCount(5 + 3)) > (8 + 0 + v89));
	end
	local function v100(v129)
		return v129:DebuffRemains(v52.MoonfireDebuff) > ((v129:DebuffRemains(v52.SunfireDebuff) * (16 + 6)) / (27 - 9));
	end
	local function v101()
		v81 = v13:BuffUp(v52.EclipseSolar) or v13:BuffUp(v52.EclipseLunar);
		v82 = v13:BuffUp(v52.EclipseSolar) and v13:BuffUp(v52.EclipseLunar);
		v83 = v13:BuffUp(v52.EclipseLunar) and v13:BuffDown(v52.EclipseSolar);
		v84 = v13:BuffUp(v52.EclipseSolar) and v13:BuffDown(v52.EclipseLunar);
		v85 = (not v81 and (((v52.Starfire:Count() == (0 + 0)) and (v52.Wrath:Count() > (667 - (89 + 578)))) or v13:IsCasting(v52.Wrath))) or v84;
		v86 = (not v81 and (((v52.Wrath:Count() == (0 + 0)) and (v52.Starfire:Count() > (0 - 0))) or v13:IsCasting(v52.Starfire))) or v83;
		v87 = not v81 and (v52.Wrath:Count() > (1049 - (572 + 477))) and (v52.Starfire:Count() > (0 + 0));
	end
	local function v102()
		v60 = (not v52.CelestialAlignment:IsAvailable() and not v52.IncarnationTalent:IsAvailable()) or not v23();
		v64 = 0 + 0;
		local v130 = ((v57:IsUsable() or (v57:ID() == v53.SpoilsofNeltharus:ID()) or (v57:ID() == v53.MirrorofFracturedTomorrows:ID())) and (1 + 0)) or (86 - (84 + 2));
		v64 = v64 + v130;
		local v131 = ((v58:IsUsable() or (v58:ID() == v53.SpoilsofNeltharus:ID()) or (v58:ID() == v53.MirrorofFracturedTomorrows:ID())) and (2 - 0)) or (0 + 0);
		v131 = ((v58:ID() == v53.SpoilsofNeltharus:ID()) and (843 - (497 + 345))) or (0 + 0);
		v64 = v64 + v131;
		v59 = true;
	end
	local function v103()
		if (((156 + 765) <= (2435 - (605 + 728))) and v52.MarkOfTheWild:IsCastable() and v51.GroupBuffMissing(v52.MarkOfTheWild)) then
			if (((3358 + 1348) >= (2140 - 1177)) and v24(v52.MarkOfTheWild, v43)) then
				return "mark_of_the_wild precombat";
			end
		end
		if (v52.MoonkinForm:IsCastable() or ((44 + 916) <= (3238 - 2362))) then
			if (v25(v52.MoonkinForm) or ((1863 + 203) == (2581 - 1649))) then
				return "moonkin_form";
			end
		end
		if (((3644 + 1181) < (5332 - (457 + 32))) and v52.Wrath:IsCastable() and not v13:IsCasting(v52.Wrath)) then
			if (v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((1645 + 2232) >= (5939 - (832 + 570)))) then
				return "wrath precombat 2";
			end
		end
		if ((v52.Wrath:IsCastable() and ((v13:IsCasting(v52.Wrath) and (v52.Wrath:Count() == (2 + 0))) or (v13:PrevGCD(1 + 0, v52.Wrath) and (v52.Wrath:Count() == (3 - 2))))) or ((2079 + 2236) < (2522 - (588 + 208)))) then
			if (v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((9915 - 6236) < (2425 - (884 + 916)))) then
				return "wrath precombat 4";
			end
		end
		if (v52.StellarFlare:IsCastable() or ((9682 - 5057) < (367 + 265))) then
			if (v24(v52.StellarFlare, nil, nil, not v16:IsSpellInRange(v52.StellarFlare)) or ((736 - (232 + 421)) > (3669 - (1569 + 320)))) then
				return "stellar_flare precombat 6";
			end
		end
		if (((134 + 412) <= (205 + 872)) and v52.Starfire:IsCastable() and not v52.StellarFlare:IsAvailable()) then
			if (v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire)) or ((3356 - 2360) > (4906 - (316 + 289)))) then
				return "starfire precombat 8";
			end
		end
	end
	local function v104()
		local v132 = 0 - 0;
		while true do
			if (((188 + 3882) > (2140 - (666 + 787))) and (v132 == (427 - (360 + 65)))) then
				if (v52.Moonfire:IsCastable() or ((614 + 42) >= (3584 - (79 + 175)))) then
					if (v24(v52.Moonfire, nil, nil, not v16:IsSpellInRange(v52.Moonfire)) or ((3929 - 1437) <= (262 + 73))) then
						return "moonfire fallthru 10";
					end
				end
				break;
			end
			if (((13247 - 8925) >= (4933 - 2371)) and (v132 == (899 - (503 + 396)))) then
				if ((v52.Starfall:IsReady() and v65) or ((3818 - (92 + 89)) >= (7313 - 3543))) then
					if (v24(v52.Starfall, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((1221 + 1158) > (2710 + 1868))) then
						return "starfall fallthru 2";
					end
				end
				if (v52.Starsurge:IsReady() or ((1891 - 1408) > (102 + 641))) then
					if (((5594 - 3140) > (505 + 73)) and v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge))) then
						return "starsurge fallthru 4";
					end
				end
				v132 = 1 + 0;
			end
			if (((2832 - 1902) < (557 + 3901)) and ((1 - 0) == v132)) then
				if (((1906 - (485 + 759)) <= (2248 - 1276)) and v52.WildMushroom:IsReady() and not v65) then
					if (((5559 - (442 + 747)) == (5505 - (832 + 303))) and v24(v52.WildMushroom, v47, nil, not v16:IsSpellInRange(v52.WildMushroom))) then
						return "wild_mushroom fallthru 6";
					end
				end
				if (v52.Sunfire:IsCastable() or ((5708 - (88 + 858)) <= (263 + 598))) then
					if (v51.CastCycle(v52.Sunfire, v88, v100, not v16:IsSpellInRange(v52.Sunfire)) or ((1169 + 243) == (176 + 4088))) then
						return "sunfire fallthru 8";
					end
				end
				v132 = 791 - (766 + 23);
			end
		end
	end
	local function v105()
		local v133 = 0 - 0;
		local v134;
		local v135;
		local v136;
		while true do
			if ((v133 == (11 - 2)) or ((8346 - 5178) < (7307 - 5154))) then
				if (v136 or ((6049 - (1036 + 37)) < (945 + 387))) then
					return v136;
				end
				if (((9012 - 4384) == (3641 + 987)) and v10.CastAnnotated(v52.Pool, false, "MOVING")) then
					return "Pool ST due to movement and no fallthru";
				end
				break;
			end
			if ((v133 == (1483 - (641 + 839))) or ((967 - (910 + 3)) == (1006 - 611))) then
				if (((1766 - (1466 + 218)) == (38 + 44)) and v52.WarriorofElune:IsCastable() and v63 and (v70 or (v13:BuffRemains(v52.EclipseSolar) < (1155 - (556 + 592))))) then
					if (v24(v52.WarriorofElune) or ((207 + 374) < (1090 - (329 + 479)))) then
						return "warrior_of_elune st 20";
					end
				end
				if ((v52.Starfire:IsCastable() and v70 and (v63 or v13:BuffUp(v52.EclipseSolar))) or ((5463 - (174 + 680)) < (8573 - 6078))) then
					if (((2387 - 1235) == (823 + 329)) and v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire))) then
						return "starfire st 24";
					end
				end
				if (((2635 - (396 + 343)) <= (303 + 3119)) and v52.Wrath:IsCastable() and v70) then
					if (v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((2467 - (29 + 1448)) > (3009 - (135 + 1254)))) then
						return "wrath st 26";
					end
				end
				v72 = (v75 > (14 - 10)) or (((v80:CooldownRemains() > (140 - 110)) or v60) and ((v13:BuffRemains(v52.EclipseLunar) > (3 + 1)) or (v13:BuffRemains(v52.EclipseSolar) > (1531 - (389 + 1138)))));
				v133 = 578 - (102 + 472);
			end
			if ((v133 == (0 + 0)) or ((487 + 390) > (4378 + 317))) then
				if (((4236 - (320 + 1225)) >= (3294 - 1443)) and v52.Sunfire:IsCastable()) then
					if (v51.CastCycle(v52.Sunfire, v88, v91, not v16:IsSpellInRange(v52.Sunfire)) or ((1827 + 1158) >= (6320 - (157 + 1307)))) then
						return "sunfire st 2";
					end
				end
				v68 = v30 and (v80:CooldownRemains() < (1864 - (821 + 1038))) and not v74 and (((v16:TimeToDie() > (37 - 22)) and (v73 < (53 + 427))) or (v79 < ((44 - 19) + ((4 + 6) * v26(v52.Incarnation:IsAvailable())))));
				if (((10598 - 6322) >= (2221 - (834 + 192))) and v52.Moonfire:IsCastable()) then
					if (((206 + 3026) <= (1204 + 3486)) and v51.CastCycle(v52.Moonfire, v88, v93, not v16:IsSpellInRange(v52.Moonfire))) then
						return "moonfire st 6";
					end
				end
				if (v52.StellarFlare:IsCastable() or ((20 + 876) >= (4873 - 1727))) then
					if (((3365 - (300 + 4)) >= (790 + 2168)) and v51.CastCycle(v52.StellarFlare, v88, v95, not v16:IsSpellInRange(v52.StellarFlare))) then
						return "stellar_flare st 10";
					end
				end
				v133 = 2 - 1;
			end
			if (((3549 - (112 + 250)) >= (257 + 387)) and (v133 == (2 - 1))) then
				if (((369 + 275) <= (365 + 339)) and v13:BuffUp(v52.StarlordBuff) and (v13:BuffRemains(v52.StarlordBuff) < (2 + 0)) and (((v73 >= (273 + 277)) and not v74 and v13:BuffUp(v52.StarweaversWarp)) or ((v73 >= (417 + 143)) and v13:BuffUp(v52.StarweaversWeft)))) then
					if (((2372 - (1001 + 413)) > (2111 - 1164)) and v10.CastAnnotated(v55.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 11";
					end
				end
				if (((5374 - (244 + 638)) >= (3347 - (627 + 66))) and v52.Starfall:IsReady() and (v73 >= (1638 - 1088)) and not v74 and v13:BuffUp(v52.StarweaversWarp)) then
					if (((4044 - (512 + 90)) >= (3409 - (1665 + 241))) and v24(v52.Starfall, v48, nil, not v16:IsSpellInRange(v52.Wrath))) then
						return "starfall st 12";
					end
				end
				if ((v52.Starsurge:IsReady() and (v73 >= (1277 - (373 + 344))) and v13:BuffUp(v52.StarweaversWeft)) or ((1430 + 1740) <= (388 + 1076))) then
					if (v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge)) or ((12653 - 7856) == (7425 - 3037))) then
						return "starsurge st 13";
					end
				end
				if (((1650 - (35 + 1064)) <= (496 + 185)) and v52.Starfire:IsReady() and v13:BuffUp(v52.DreamstateBuff) and v68 and v83) then
					if (((7011 - 3734) > (2 + 405)) and v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire))) then
						return "starfire st 14";
					end
				end
				v133 = 1238 - (298 + 938);
			end
			if (((5954 - (233 + 1026)) >= (3081 - (636 + 1030))) and (v133 == (5 + 3))) then
				if ((v13:BuffUp(v52.StarlordBuff) and (v13:BuffRemains(v52.StarlordBuff) < (2 + 0)) and v135) or ((955 + 2257) <= (64 + 880))) then
					if (v25(v55.CancelStarlord, false, "CANCEL") or ((3317 - (55 + 166)) <= (349 + 1449))) then
						return "cancel_buff starlord st 53";
					end
				end
				if (((356 + 3181) == (13508 - 9971)) and v52.Starsurge:IsReady() and v135) then
					if (((4134 - (36 + 261)) >= (2745 - 1175)) and v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge))) then
						return "starsurge st 54";
					end
				end
				if ((v52.Wrath:IsCastable() and not v13:IsMoving()) or ((4318 - (34 + 1334)) == (1466 + 2346))) then
					if (((3670 + 1053) >= (3601 - (1035 + 248))) and v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath))) then
						return "wrath st 60";
					end
				end
				v136 = v104();
				v133 = 30 - (20 + 1);
			end
			if ((v133 == (4 + 2)) or ((2346 - (134 + 185)) > (3985 - (549 + 584)))) then
				if ((v52.Starsurge:IsReady() and v134) or ((1821 - (314 + 371)) > (14820 - 10503))) then
					if (((5716 - (478 + 490)) == (2516 + 2232)) and v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge))) then
						return "starsurge st 40";
					end
				end
				if (((4908 - (786 + 386)) <= (15352 - 10612)) and v52.Sunfire:IsCastable()) then
					if (v51.CastCycle(v52.Sunfire, v88, v92, not v16:IsSpellInRange(v52.Sunfire)) or ((4769 - (1055 + 324)) <= (4400 - (1093 + 247)))) then
						return "sunfire st 42";
					end
				end
				if (v52.Moonfire:IsCastable() or ((888 + 111) > (284 + 2409))) then
					if (((1838 - 1375) < (2039 - 1438)) and v51.CastCycle(v52.Moonfire, v88, v94, not v16:IsSpellInRange(v52.Moonfire))) then
						return "moonfire st 44";
					end
				end
				if (v52.StellarFlare:IsCastable() or ((6211 - 4028) < (1726 - 1039))) then
					if (((1619 + 2930) == (17524 - 12975)) and v51.CastCycle(v52.StellarFlare, v88, v96, not v16:IsSpellInRange(v52.StellarFlare))) then
						return "stellar_flare st 46";
					end
				end
				v133 = 24 - 17;
			end
			if (((3523 + 1149) == (11947 - 7275)) and (v133 == (692 - (364 + 324)))) then
				if ((v52.Starsurge:IsReady() and v52.ConvokeTheSpirits:IsAvailable() and v52.ConvokeTheSpirits:IsCastable() and v72) or ((10055 - 6387) < (947 - 552))) then
					if (v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge)) or ((1381 + 2785) == (1903 - 1448))) then
						return "starsurge st 28";
					end
				end
				if ((v52.ConvokeTheSpirits:IsCastable() and v23() and v72) or ((7124 - 2675) == (8087 - 5424))) then
					if (v24(v52.ConvokeTheSpirits, nil, not v16:IsSpellInRange(v52.Wrath)) or ((5545 - (1249 + 19)) < (2698 + 291))) then
						return "convoke_the_spirits st 30";
					end
				end
				if ((v52.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.AstralCommunion:EnergizeAmount()))) or ((3386 - 2516) >= (5235 - (686 + 400)))) then
					if (((1736 + 476) < (3412 - (73 + 156))) and v24(v52.AstralCommunion)) then
						return "astral_communion st 32";
					end
				end
				if (((22 + 4624) > (3803 - (721 + 90))) and v52.ForceOfNature:IsCastable() and v23() and (v13:AstralPowerDeficit() > (v67 + v52.ForceOfNature:EnergizeAmount()))) then
					if (((17 + 1417) < (10084 - 6978)) and v24(v52.ForceOfNature, nil, not v16:IsSpellInRange(v52.Wrath))) then
						return "force_of_nature st 34";
					end
				end
				v133 = 475 - (224 + 246);
			end
			if (((1273 - 487) < (5565 - 2542)) and (v133 == (2 + 5))) then
				if ((v52.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.NewMoon:EnergizeAmount())) and (v74 or ((v52.NewMoon:ChargesFractional() > (1.5 + 1)) and (v73 <= (382 + 138)) and (v80:CooldownRemains() > (19 - 9))) or (v79 < (33 - 23)))) or ((2955 - (203 + 310)) < (2067 - (1238 + 755)))) then
					if (((317 + 4218) == (6069 - (709 + 825))) and v24(v52.NewMoon, nil, nil, not v16:IsSpellInRange(v52.NewMoon))) then
						return "new_moon st 48";
					end
				end
				if ((v52.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v52.EclipseLunar) > v52.HalfMoon:ExecuteTime()) or (v13:BuffRemains(v52.EclipseSolar) > v52.HalfMoon:ExecuteTime())) and (v74 or ((v52.HalfMoon:ChargesFractional() > (3.5 - 1)) and (v73 <= (757 - 237)) and (v80:CooldownRemains() > (874 - (196 + 668)))) or (v79 < (39 - 29)))) or ((6232 - 3223) <= (2938 - (171 + 662)))) then
					if (((1923 - (4 + 89)) < (12859 - 9190)) and v24(v52.HalfMoon, nil, nil, not v16:IsSpellInRange(v52.HalfMoon))) then
						return "half_moon st 50";
					end
				end
				if ((v52.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v52.EclipseLunar) > v52.FullMoon:ExecuteTime()) or (v13:BuffRemains(v52.EclipseSolar) > v52.FullMoon:ExecuteTime())) and (v74 or ((v52.HalfMoon:ChargesFractional() > (1.5 + 1)) and (v73 <= (2283 - 1763)) and (v80:CooldownRemains() > (4 + 6))) or (v79 < (1496 - (35 + 1451))))) or ((2883 - (28 + 1425)) >= (5605 - (941 + 1052)))) then
					if (((2573 + 110) >= (3974 - (822 + 692))) and v24(v52.FullMoon, nil, nil, not v16:IsSpellInRange(v52.FullMoon))) then
						return "full_moon st 52";
					end
				end
				v135 = v13:BuffUp(v52.StarweaversWeft) or (v13:AstralPowerDeficit() < (v67 + v90(v52.Wrath) + ((v90(v52.Starfire) + v67) * (v26(v13:BuffRemains(v52.EclipseSolar) < (v13:GCD() * (3 - 0))))))) or (v52.AstralCommunion:IsAvailable() and (v52.AstralCommunion:CooldownRemains() < (2 + 1))) or (v79 < (302 - (45 + 252)));
				v133 = 8 + 0;
			end
			if ((v133 == (1 + 1)) or ((4390 - 2586) >= (3708 - (114 + 319)))) then
				if ((v52.Wrath:IsReady() and v13:BuffUp(v52.DreamstateBuff) and v68 and v13:BuffUp(v52.EclipseSolar)) or ((2034 - 617) > (4649 - 1020))) then
					if (((3057 + 1738) > (598 - 196)) and v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath))) then
						return "wrath st 15";
					end
				end
				if (((10084 - 5271) > (5528 - (556 + 1407))) and v30) then
					if (((5118 - (741 + 465)) == (4377 - (170 + 295))) and v52.CelestialAlignment:IsCastable() and v68 and v49) then
						if (((1487 + 1334) <= (4431 + 393)) and v25(v52.CelestialAlignment)) then
							return "celestial_alignment st 16";
						end
					end
					if (((4278 - 2540) <= (1820 + 375)) and v52.Incarnation:IsCastable() and v68 and v49) then
						if (((27 + 14) <= (1710 + 1308)) and v25(v52.Incarnation)) then
							return "incarnation st 18";
						end
					end
				end
				v63 = ((v73 < (1750 - (957 + 273))) and (v80:CooldownRemains() > (2 + 3)) and (v89 < (2 + 1))) or v13:HasTier(118 - 87, 5 - 3);
				v70 = v87 or (v63 and v13:BuffUp(v52.EclipseSolar) and (v13:BuffRemains(v52.EclipseSolar) < v52.Starfire:CastTime())) or (not v63 and v13:BuffUp(v52.EclipseLunar) and (v13:BuffRemains(v52.EclipseLunar) < v52.Wrath:CastTime()));
				v133 = 9 - 6;
			end
			if (((10621 - 8476) <= (5884 - (389 + 1391))) and (v133 == (4 + 1))) then
				if (((280 + 2409) < (11030 - 6185)) and v52.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (953 - (783 + 168))) and ((v75 > (9 - 6)) or ((v80:CooldownRemains() > (30 + 0)) and (v73 <= (591 - (309 + 2)))) or ((v73 >= (1719 - 1159)) and (v13:AstralPowerP() > (1262 - (1090 + 122)))))) or (v79 < (4 + 6)))) then
					if (v24(v52.FuryOfElune, nil, not v16:IsSpellInRange(v52.FuryOfElune)) or ((7798 - 5476) > (1795 + 827))) then
						return "fury_of_elune st 36";
					end
				end
				if ((v52.Starfall:IsReady() and (v13:BuffUp(v52.StarweaversWarp))) or ((5652 - (628 + 490)) == (374 + 1708))) then
					if (v24(v52.Starfall, nil, not v16:IsSpellInRange(v52.Wrath)) or ((3889 - 2318) > (8532 - 6665))) then
						return "starfall st 38";
					end
				end
				v134 = (v52.Starlord:IsAvailable() and (v13:BuffStack(v52.StarlordBuff) < (777 - (431 + 343)))) or (((v13:BuffStack(v52.BOATArcaneBuff) + v13:BuffStack(v52.BOATNatureBuff)) > (3 - 1)) and (v13:BuffRemains(v52.StarlordBuff) > (11 - 7)));
				if ((v13:BuffUp(v52.StarlordBuff) and (v13:BuffRemains(v52.StarlordBuff) < (2 + 0)) and v134) or ((340 + 2314) >= (4691 - (556 + 1139)))) then
					if (((3993 - (6 + 9)) > (386 + 1718)) and v10.CastAnnotated(v55.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 39";
					end
				end
				v133 = 4 + 2;
			end
		end
	end
	local function v106()
		local v137 = 169 - (28 + 141);
		local v138;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		local v144;
		while true do
			if (((1161 + 1834) > (1901 - 360)) and (v137 == (2 + 0))) then
				v140 = v89 < (1320 - (486 + 831));
				if (((8454 - 5205) > (3354 - 2401)) and v52.Starfire:IsCastable() and v140 and (v87 or (v13:BuffRemains(v52.EclipseSolar) < v52.Starfire:CastTime()))) then
					if (v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire)) or ((619 + 2654) > (14459 - 9886))) then
						return "starfire aoe 17";
					end
				end
				if ((v52.Wrath:IsCastable() and not v140 and (v87 or (v13:BuffRemains(v52.EclipseLunar) < v52.Wrath:CastTime()))) or ((4414 - (668 + 595)) < (1156 + 128))) then
					if (v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((374 + 1476) == (4169 - 2640))) then
						return "wrath aoe 18";
					end
				end
				if (((1111 - (23 + 267)) < (4067 - (1129 + 815))) and v52.WildMushroom:IsCastable() and (v13:AstralPowerDeficit() > (v67 + (407 - (371 + 16)))) and (not v52.WaningTwilight:IsAvailable() or ((v16:DebuffRemains(v52.FungalGrowthDebuff) < (1752 - (1326 + 424))) and (v16:TimeToDie() > (13 - 6)) and not v13:PrevGCDP(3 - 2, v52.WildMushroom)))) then
					if (((1020 - (88 + 30)) < (3096 - (720 + 51))) and v24(v52.WildMushroom, v47, nil, not v16:IsSpellInRange(v52.WildMushroom))) then
						return "wild_mushroom aoe 20";
					end
				end
				if (((1908 - 1050) <= (4738 - (421 + 1355))) and v52.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (2 - 0)) and ((v75 > (2 + 1)) or ((v80:CooldownRemains() > (1113 - (286 + 797))) and (v73 <= (1023 - 743))) or ((v73 >= (927 - 367)) and (v13:AstralPowerP() > (489 - (397 + 42)))))) or (v79 < (4 + 6)))) then
					if (v24(v52.FuryOfElune, nil, not v16:IsSpellInRange(v52.FuryOfElune)) or ((4746 - (24 + 776)) < (1984 - 696))) then
						return "fury_of_elune aoe 22";
					end
				end
				v141 = (v16:TimeToDie() > (789 - (222 + 563))) and (v13:BuffUp(v52.StarweaversWarp) or (v52.Starlord:IsAvailable() and (v13:BuffStack(v52.StarlordBuff) < (6 - 3))));
				v137 = 3 + 0;
			end
			if ((v137 == (191 - (23 + 167))) or ((5040 - (690 + 1108)) == (205 + 362))) then
				v139 = (v69 and ((v52.OrbitalStrike:IsAvailable() and (v13:AstralPowerDeficit() < (v67 + ((7 + 1) * v89)))) or v13:BuffUp(v52.TouchTheCosmos))) or (v13:AstralPowerDeficit() < (v67 + (856 - (40 + 808)) + ((2 + 10) * v26((v13:BuffRemains(v52.EclipseLunar) < (15 - 11)) or (v13:BuffRemains(v52.EclipseSolar) < (4 + 0))))));
				if ((v13:BuffUp(v52.StarlordBuff) and (v13:BuffRemains(v52.StarlordBuff) < (2 + 0)) and v139) or ((465 + 382) >= (1834 - (47 + 524)))) then
					if (v10.CastAnnotated(v55.CancelStarlord, false, "CANCEL") or ((1463 + 790) == (5059 - 3208))) then
						return "cancel_buff starlord aoe 9.5";
					end
				end
				if ((v52.Starfall:IsReady() and v139) or ((3119 - 1032) > (5409 - 3037))) then
					if (v24(v52.Starfall, v48, nil, not v16:IsSpellInRange(v52.Wrath)) or ((6171 - (1165 + 561)) < (124 + 4025))) then
						return "starfall aoe 10";
					end
				end
				if ((v52.Starfire:IsReady() and v13:BuffUp(v52.DreamstateBuff) and v69 and v13:BuffUp(v52.EclipseLunar)) or ((5630 - 3812) == (33 + 52))) then
					if (((1109 - (341 + 138)) < (575 + 1552)) and v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire))) then
						return "starfire aoe 11";
					end
				end
				if (v30 or ((3999 - 2061) == (2840 - (89 + 237)))) then
					if (((13688 - 9433) >= (115 - 60)) and v52.CelestialAlignment:IsCastable() and v69) then
						if (((3880 - (581 + 300)) > (2376 - (855 + 365))) and v25(v52.CelestialAlignment)) then
							return "celestial_alignment aoe 10";
						end
					end
					if (((5581 - 3231) > (378 + 777)) and v52.Incarnation:IsCastable() and v69) then
						if (((5264 - (1030 + 205)) <= (4557 + 296)) and v25(v52.Incarnation)) then
							return "celestial_alignment aoe 12";
						end
					end
				end
				if (v52.WarriorofElune:IsCastable() or ((481 + 35) > (3720 - (156 + 130)))) then
					if (((9193 - 5147) >= (5111 - 2078)) and v25(v52.WarriorofElune)) then
						return "warrior_of_elune aoe 14";
					end
				end
				v137 = 3 - 1;
			end
			if ((v137 == (2 + 2)) or ((1586 + 1133) <= (1516 - (10 + 59)))) then
				if ((v52.ConvokeTheSpirits:IsCastable() and v23() and (v13:AstralPowerP() < (15 + 35)) and (v89 < ((14 - 11) + v26(v52.ElunesGuidance:IsAvailable()))) and ((v13:BuffRemains(v52.EclipseLunar) > (1167 - (671 + 492))) or (v13:BuffRemains(v52.EclipseSolar) > (4 + 0)))) or ((5349 - (369 + 846)) < (1040 + 2886))) then
					if (v24(v52.ConvokeTheSpirits, nil, not v16:IsInRange(35 + 5)) or ((2109 - (1036 + 909)) >= (2215 + 570))) then
						return "convoke_the_spirits aoe 36";
					end
				end
				if ((v52.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.NewMoon:EnergizeAmount()))) or ((881 - 356) == (2312 - (11 + 192)))) then
					if (((17 + 16) == (208 - (135 + 40))) and v24(v52.NewMoon, nil, nil, not v16:IsSpellInRange(v52.NewMoon))) then
						return "new_moon aoe 38";
					end
				end
				if (((7399 - 4345) <= (2421 + 1594)) and v52.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v52.EclipseLunar) > v52.FullMoon:ExecuteTime()) or (v13:BuffRemains(v52.EclipseSolar) > v52.FullMoon:ExecuteTime()))) then
					if (((4121 - 2250) < (5069 - 1687)) and v24(v52.HalfMoon, nil, nil, not v16:IsSpellInRange(v52.HalfMoon))) then
						return "half_moon aoe 40";
					end
				end
				if (((1469 - (50 + 126)) <= (6031 - 3865)) and v52.ForceOfNature:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.ForceOfNature:EnergizeAmount()))) then
					if (v24(v52.ForceOfNature, nil, not v16:IsSpellInRange(v52.Wrath)) or ((571 + 2008) < (1536 - (1233 + 180)))) then
						return "force_of_nature aoe 42";
					end
				end
				if ((v52.Starsurge:IsReady() and v13:BuffUp(v52.StarweaversWeft) and (v89 < (986 - (522 + 447)))) or ((2267 - (107 + 1314)) >= (1099 + 1269))) then
					if (v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge)) or ((12224 - 8212) <= (1427 + 1931))) then
						return "starsurge aoe 44";
					end
				end
				v142 = 0 - 0;
				v137 = 19 - 14;
			end
			if (((3404 - (716 + 1194)) <= (52 + 2953)) and (v137 == (0 + 0))) then
				v138 = v13:IsInParty() and not v13:IsInRaid();
				if ((v52.Moonfire:IsCastable() and v138) or ((3614 - (74 + 429)) == (4116 - 1982))) then
					if (((1168 + 1187) == (5390 - 3035)) and v51.CastCycle(v52.Moonfire, v88, v98, not v16:IsSpellInRange(v52.Moonfire))) then
						return "moonfire aoe 2";
					end
				end
				v69 = v23() and (v80:CooldownRemains() < (4 + 1)) and not v74 and (((v16:TimeToDie() > (30 - 20)) and (v73 < (1236 - 736))) or (v79 < ((458 - (279 + 154)) + ((788 - (454 + 324)) * v26(v52.Incarnation:IsAvailable())))));
				if (v52.Sunfire:IsCastable() or ((463 + 125) <= (449 - (12 + 5)))) then
					if (((2587 + 2210) >= (9924 - 6029)) and v51.CastCycle(v52.Sunfire, v88, v97, not v16:IsSpellInRange(v52.Sunfire))) then
						return "sunfire aoe 4";
					end
				end
				if (((1322 + 2255) == (4670 - (277 + 816))) and v52.Moonfire:IsCastable() and not v138) then
					if (((16212 - 12418) > (4876 - (1058 + 125))) and v51.CastCycle(v52.Moonfire, v88, v98, not v16:IsSpellInRange(v52.Moonfire))) then
						return "moonfire aoe 6";
					end
				end
				if ((v52.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.StellarFlare:EnergizeAmount())) and (v89 < (((3 + 8) - v52.UmbralIntensity:TalentRank()) - v52.AstralSmolder:TalentRank())) and v69) or ((2250 - (815 + 160)) == (17591 - 13491))) then
					if (v51.CastCycle(v52.StellarFlare, v88, v99, not v16:IsSpellInRange(v52.StellarFlare)) or ((3776 - 2185) >= (855 + 2725))) then
						return "stellar_flare aoe 9";
					end
				end
				v137 = 2 - 1;
			end
			if (((2881 - (41 + 1857)) <= (3701 - (1222 + 671))) and (v137 == (15 - 9))) then
				if (v144 or ((3090 - 940) <= (2379 - (229 + 953)))) then
					return v144;
				end
				if (((5543 - (1111 + 663)) >= (2752 - (874 + 705))) and v10.CastAnnotated(v52.Pool, false, "MOVING")) then
					return "Pool AoE due to movement and no fallthru";
				end
				break;
			end
			if (((208 + 1277) == (1014 + 471)) and (v137 == (10 - 5))) then
				v143 = 0 + 0;
				if (v13:BuffUp(v52.EclipseLunar) or ((3994 - (642 + 37)) <= (635 + 2147))) then
					local v164 = v13:BuffInfo(v52.EclipseLunar, nil, true);
					local v165 = v164.points[1 + 0];
					local v166 = (v165 - (37 - 22)) / (456 - (233 + 221));
				end
				if (v13:BuffUp(v52.EclipseSolar) or ((2025 - 1149) >= (2609 + 355))) then
					local v167 = 1541 - (718 + 823);
					local v168;
					local v169;
					local v170;
					while true do
						if (((1 + 0) == v167) or ((3037 - (266 + 539)) > (7069 - 4572))) then
							v170 = (v169 - (1240 - (636 + 589))) / (4 - 2);
							break;
						end
						if ((v167 == (0 - 0)) or ((1673 + 437) <= (121 + 211))) then
							v168 = v13:BuffInfo(v52.EclipseSolar, nil, true);
							v169 = v168.points[1016 - (657 + 358)];
							v167 = 2 - 1;
						end
					end
				end
				if (((8397 - 4711) > (4359 - (1151 + 36))) and v52.Starfire:IsCastable() and not v13:IsMoving() and (((v89 > ((3 + 0) - (v26(v13:BuffUp(v52.DreamstateBuff) or (v142 > v143))))) and v13:BuffUp(v52.EclipseLunar)) or v83)) then
					if (v24(v52.Starfire, nil, nil, not v16:IsSpellInRange(v52.Starfire)) or ((1177 + 3297) < (2448 - 1628))) then
						return "starfire aoe 46";
					end
				end
				if (((6111 - (1552 + 280)) >= (3716 - (64 + 770))) and v52.Wrath:IsCastable() and not v13:IsMoving()) then
					if (v24(v52.Wrath, nil, nil, not v16:IsSpellInRange(v52.Wrath)) or ((1378 + 651) >= (7992 - 4471))) then
						return "wrath aoe 48";
					end
				end
				v144 = v104();
				v137 = 2 + 4;
			end
			if ((v137 == (1246 - (157 + 1086))) or ((4076 - 2039) >= (20330 - 15688))) then
				if (((2638 - 918) < (6084 - 1626)) and v13:BuffUp(v52.StarlordBuff) and (v13:BuffRemains(v52.StarlordBuff) < (821 - (599 + 220))) and v141) then
					if (v10.CastAnnotated(v55.CancelStarlord, false, "CANCEL") or ((867 - 431) > (4952 - (1813 + 118)))) then
						return "cancel_buff starlord aoe 23";
					end
				end
				if (((522 + 191) <= (2064 - (841 + 376))) and v52.Starfall:IsReady() and v141) then
					if (((3018 - 864) <= (937 + 3094)) and v24(v52.Starfall, v48, nil, not v16:IsSpellInRange(v52.Wrath))) then
						return "starfall aoe 24";
					end
				end
				if (((12596 - 7981) == (5474 - (464 + 395))) and v52.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v52.EclipseLunar) > v52.FullMoon:ExecuteTime()) or (v13:BuffRemains(v52.EclipseSolar) > v52.FullMoon:ExecuteTime())) and (v74 or ((v52.HalfMoon:ChargesFractional() > (5.5 - 3)) and (v73 <= (250 + 270)) and (v80:CooldownRemains() > (847 - (467 + 370)))) or (v79 < (20 - 10)))) then
					if (v24(v52.FullMoon, nil, nil, not v16:IsSpellInRange(v52.FullMoon)) or ((2783 + 1007) == (1714 - 1214))) then
						return "full_moon aoe 26";
					end
				end
				if (((14 + 75) < (514 - 293)) and v52.Starsurge:IsReady() and v13:BuffUp(v52.StarweaversWeft) and (v89 < (523 - (150 + 370)))) then
					if (((3336 - (74 + 1208)) >= (3494 - 2073)) and v24(v52.Starsurge, nil, nil, not v16:IsSpellInRange(v52.Starsurge))) then
						return "starsurge aoe 30";
					end
				end
				if (((3281 - 2589) < (2176 + 882)) and v52.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.StellarFlare:EnergizeAmount())) and (v89 < (((401 - (14 + 376)) - v52.UmbralIntensity:TalentRank()) - v52.AstralSmolder:TalentRank()))) then
					if (v51.CastCycle(v52.StellarFlare, v88, v99, not v16:IsSpellInRange(v52.StellarFlare)) or ((5643 - 2389) == (1071 + 584))) then
						return "stellar_flare aoe 32";
					end
				end
				if ((v52.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v67 + v52.AstralCommunion:EnergizeAmount()))) or ((1139 + 157) == (4683 + 227))) then
					if (((9868 - 6500) == (2534 + 834)) and v24(v52.ForceOfNature)) then
						return "astral_communion aoe 34";
					end
				end
				v137 = 82 - (23 + 55);
			end
		end
	end
	local function v107()
		local v145 = v51.HandleTopTrinket(v54, v30, 94 - 54, nil);
		if (((1764 + 879) < (3426 + 389)) and v145) then
			return v145;
		end
		local v145 = v51.HandleBottomTrinket(v54, v30, 62 - 22, nil);
		if (((602 + 1311) > (1394 - (652 + 249))) and v145) then
			return v145;
		end
	end
	local function v108()
		C_Timer.After(0.15 - 0, function()
			local v146 = 1868 - (708 + 1160);
			while true do
				if (((12907 - 8152) > (6249 - 2821)) and (v146 == (28 - (10 + 17)))) then
					v28 = EpicSettings.Toggles['ooc'];
					v29 = EpicSettings.Toggles['aoe'];
					v146 = 1 + 1;
				end
				if (((3113 - (1400 + 332)) <= (4543 - 2174)) and (v146 == (1911 - (242 + 1666)))) then
					if (v13:IsDeadOrGhost() or ((2073 + 2770) == (1497 + 2587))) then
						if (((3980 + 689) > (1303 - (850 + 90))) and v25(v52.Nothing, nil, nil)) then
							return "Dead";
						end
					end
					v88 = v16:GetEnemiesInSplashRange(17 - 7);
					v146 = 1394 - (360 + 1030);
				end
				if (((0 + 0) == v146) or ((5297 - 3420) >= (4317 - 1179))) then
					v88 = v16:GetEnemiesInSplashRange(1671 - (909 + 752));
					v50();
					v146 = 1224 - (109 + 1114);
				end
				if (((8681 - 3939) >= (1412 + 2214)) and (v146 == (244 - (6 + 236)))) then
					v30 = EpicSettings.Toggles['cds'];
					v31 = EpicSettings.Toggles['toggle'];
					v146 = 2 + 1;
				end
				if ((v146 == (4 + 0)) or ((10707 - 6167) == (1599 - 683))) then
					if (v29 or ((2289 - (1076 + 57)) > (715 + 3630))) then
						v89 = v16:GetEnemiesInSplashRangeCount(699 - (579 + 110));
					else
						v89 = 1 + 0;
					end
					if (((1978 + 259) < (2256 + 1993)) and not v13:IsChanneling() and v31) then
						if (v13:AffectingCombat() or ((3090 - (174 + 233)) < (64 - 41))) then
							if (((1223 - 526) <= (368 + 458)) and (v13:HealthPercentage() <= v46) and v52.NaturesVigil:IsReady()) then
								if (((2279 - (663 + 511)) <= (1050 + 126)) and v25(v52.NaturesVigil, nil, nil, true)) then
									return "barkskin defensive 2";
								end
							end
							if (((734 + 2645) <= (11752 - 7940)) and (v13:HealthPercentage() <= v45) and v52.Barkskin:IsReady()) then
								if (v25(v52.Barkskin, nil, nil, true) or ((478 + 310) >= (3804 - 2188))) then
									return "barkskin defensive 2";
								end
							end
							if (((4487 - 2633) <= (1613 + 1766)) and (v13:HealthPercentage() <= v38) and v37 and v53.Healthstone:IsReady()) then
								if (((8853 - 4304) == (3242 + 1307)) and v25(v55.Healthstone, nil, nil, true)) then
									return "healthstone defensive 4";
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((277 + 2745) >= (3746 - (478 + 244)))) then
							local v173 = 517 - (440 + 77);
							local v174;
							while true do
								if (((2192 + 2628) > (8044 - 5846)) and (v173 == (1556 - (655 + 901)))) then
									v174 = v51.DeadFriendlyUnitsCount();
									if (v13:AffectingCombat() or ((197 + 864) >= (3745 + 1146))) then
										if (((922 + 442) <= (18019 - 13546)) and v52.Rebirth:IsCastable()) then
											if (v25(v52.Rebirth, nil, true) or ((5040 - (695 + 750)) <= (9 - 6))) then
												return "rebirth";
											end
										end
									elseif (v52.Revive:IsCastable() or ((7209 - 2537) == (15491 - 11639))) then
										if (((1910 - (285 + 66)) == (3633 - 2074)) and v25(v52.Revive, not v16:IsInRange(1350 - (682 + 628)), true)) then
											return "revive";
										end
									end
									break;
								end
							end
						end
						if ((v51.TargetIsValid() and not v59) or ((283 + 1469) <= (1087 - (176 + 123)))) then
							v102();
						end
						if (v51.TargetIsValid() or v13:AffectingCombat() or ((1635 + 2272) == (129 + 48))) then
							v76 = true;
							v78 = v10.BossFightRemains();
							v79 = v78;
							if (((3739 - (239 + 30)) > (151 + 404)) and (v79 == (10680 + 431))) then
								v79 = v10.FightRemains(v88, false);
							end
							v73 = 0 - 0;
							if (v52.PrimordialArcanicPulsar:IsAvailable() or ((3032 - 2060) == (960 - (306 + 9)))) then
								local v177 = v13:BuffInfo(v52.PAPBuff, false, true);
								if (((11103 - 7921) >= (368 + 1747)) and (v177 ~= nil)) then
									v73 = v177.points[1 + 0];
								end
							end
							v74 = v13:BuffUp(v52.CABuff) or v13:BuffUp(v52.IncarnationBuff);
							v75 = 0 + 0;
							if (((11132 - 7239) < (5804 - (1140 + 235))) and v74) then
								v75 = (v52.IncarnationTalent:IsAvailable() and v13:BuffRemains(v52.IncarnationBuff)) or v13:BuffRemains(v52.CABuff);
							end
						end
						if (not v13:AffectingCombat() or ((1825 + 1042) < (1747 + 158))) then
							if ((v52.MoonkinForm:IsCastable() and v44) or ((461 + 1335) >= (4103 - (33 + 19)))) then
								if (((585 + 1034) <= (11257 - 7501)) and v25(v52.MoonkinForm)) then
									return "moonkin_form ooc";
								end
							end
						end
						if (((267 + 337) == (1184 - 580)) and ((v51.TargetIsValid() and v28) or v13:AffectingCombat())) then
							local v175 = 0 + 0;
							local v176;
							while true do
								if (((690 - (586 + 103)) == v175) or ((409 + 4075) == (2770 - 1870))) then
									v65 = (v89 > ((1489 - (1309 + 179)) + v26(not v52.AetherialKindling:IsAvailable() and not v52.Starweaver:IsAvailable()))) and v52.Starfall:IsAvailable();
									v66 = v89 > (1 - 0);
									v67 = ((3 + 3) / v13:SpellHaste()) + v26(v52.NaturesBalance:IsAvailable()) + (v26(v52.OrbitBreaker:IsAvailable()) * v26(v16:DebuffUp(v52.MoonfireDebuff)) * v26(v77.OrbitBreakerStacks > ((72 - 45) - ((2 + 0) * v26(v13:BuffUp(v52.SolsticeBuff))))) * (84 - 44));
									v175 = 3 - 1;
								end
								if ((v175 == (612 - (295 + 314))) or ((10951 - 6492) <= (3075 - (1300 + 662)))) then
									if (((11404 - 7772) > (5153 - (1178 + 577))) and v65 and v29) then
										local v179 = 0 + 0;
										local v180;
										while true do
											if (((12067 - 7985) <= (6322 - (851 + 554))) and (v179 == (1 + 0))) then
												if (((13400 - 8568) >= (3009 - 1623)) and v10.CastAnnotated(v52.Pool, false, "WAIT/AoE")) then
													return "Wait for AoE";
												end
												break;
											end
											if (((439 - (115 + 187)) == (105 + 32)) and (v179 == (0 + 0))) then
												v180 = v106();
												if (v180 or ((6186 - 4616) >= (5493 - (160 + 1001)))) then
													return v180;
												end
												v179 = 1 + 0;
											end
										end
									end
									if (true or ((2805 + 1259) <= (3723 - 1904))) then
										local v181 = 358 - (237 + 121);
										local v182;
										while true do
											if ((v181 == (898 - (525 + 372))) or ((9452 - 4466) < (5171 - 3597))) then
												if (((4568 - (96 + 46)) > (949 - (643 + 134))) and v10.CastAnnotated(v52.Pool, false, "WAIT/ST")) then
													return "Wait for ST";
												end
												break;
											end
											if (((212 + 374) > (1090 - 635)) and (v181 == (0 - 0))) then
												v182 = v105();
												if (((793 + 33) == (1620 - 794)) and v182) then
													return v182;
												end
												v181 = 1 - 0;
											end
										end
									end
									break;
								end
								if ((v175 == (719 - (316 + 403))) or ((2672 + 1347) > (12209 - 7768))) then
									if (((729 + 1288) < (10730 - 6469)) and v34 and (v13:HealthPercentage() <= v36)) then
										local v183 = 0 + 0;
										while true do
											if (((1520 + 3196) > (277 - 197)) and (v183 == (0 - 0))) then
												if ((v35 == "Refreshing Healing Potion") or ((7285 - 3778) == (188 + 3084))) then
													if (v53.RefreshingHealingPotion:IsReady() or ((1724 - 848) >= (151 + 2924))) then
														if (((12803 - 8451) > (2571 - (12 + 5))) and v10.Press(v55.RefreshingHealingPotion)) then
															return "refreshing healing potion defensive 4";
														end
													end
												end
												if ((v35 == "Dreamwalker's Healing Potion") or ((17113 - 12707) < (8625 - 4582))) then
													if (v53.DreamwalkersHealingPotion:IsReady() or ((4015 - 2126) >= (8389 - 5006))) then
														if (((384 + 1508) <= (4707 - (1656 + 317))) and v10.Press(v55.RefreshingHealingPotion)) then
															return "dreamwalkers healing potion defensive";
														end
													end
												end
												break;
											end
										end
									end
									v101();
									if (((1714 + 209) < (1778 + 440)) and not v13:AffectingCombat()) then
										local v184 = v103();
										if (((5777 - 3604) > (1865 - 1486)) and v184) then
											return v184;
										end
									end
									v175 = 355 - (5 + 349);
								end
								if (((9 - 7) == v175) or ((3862 - (266 + 1005)) == (2247 + 1162))) then
									if (((15402 - 10888) > (4375 - 1051)) and v52.Berserking:IsCastable() and v23() and ((v75 >= (1716 - (561 + 1135))) or v60 or (v79 < (19 - 4)))) then
										if (v24(v52.Berserking, v32) or ((683 - 475) >= (5894 - (507 + 559)))) then
											return "berserking main 2";
										end
									end
									v176 = v107();
									if (v176 or ((3972 - 2389) > (11031 - 7464))) then
										return v176;
									end
									v175 = 391 - (212 + 176);
								end
							end
						end
					end
					break;
				end
			end
		end);
	end
	local function v109()
		v10.Print("Balance Druid Rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(1007 - (250 + 655), v108, v109);
end;
return v0["Epix_Druid_Balance.lua"]();

