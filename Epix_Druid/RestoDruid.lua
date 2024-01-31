local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 881 - (614 + 267);
	local v6;
	while true do
		if (((1949 - (19 + 13)) > (2096 - 808)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if (((1411 - 917) <= (871 + 2481)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((7590 - 3930) <= (3877 - (1293 + 519)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Druid_RestoDruid.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Pet;
	local v16 = v13.Target;
	local v17 = v13.Focus;
	local v18 = v13.MouseOver;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = v10.Commons;
	local v23 = EpicLib;
	local v24 = v23.Cast;
	local v25 = v23.Press;
	local v26 = v23.Macro;
	local v27 = v23.Commons.Everyone.num;
	local v28 = v23.Commons.Everyone.bool;
	local v29 = string.format;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
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
	local v99;
	local v100 = v23.Commons.Everyone;
	local v101 = v19.Druid.Restoration;
	local v102 = v21.Druid.Restoration;
	local v103 = {};
	local v104 = v26.Druid.Restoration;
	local v105 = 0 - 0;
	local v106, v107;
	local v108 = 21247 - 10136;
	local v109 = 47911 - 36800;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = false;
	local v117 = v14:GetEquipment();
	local v118 = (v117[30 - 17] and v21(v117[7 + 6])) or v21(0 + 0);
	local v119 = (v117[32 - 18] and v21(v117[4 + 10])) or v21(0 + 0);
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (1097 - (709 + 387))) or ((5968 - (673 + 1185)) > (12690 - 8314))) then
				v119 = (v117[44 - 30] and v21(v117[22 - 8])) or v21(0 + 0);
				break;
			end
			if ((v147 == (0 + 0)) or ((2200 - 570) > (1032 + 3166))) then
				v117 = v14:GetEquipment();
				v118 = (v117[25 - 12] and v21(v117[24 - 11])) or v21(1880 - (446 + 1434));
				v147 = 1284 - (1040 + 243);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v148 = 0 - 0;
		while true do
			if (((2901 - (559 + 1288)) == (2985 - (609 + 1322))) and (v148 == (454 - (13 + 441)))) then
				v108 = 41519 - 30408;
				v109 = 29103 - 17992;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v120()
		if (v101.ImprovedNaturesCure:IsAvailable() or ((3366 - 2690) >= (62 + 1580))) then
			v100.DispellableDebuffs = v12.MergeTable(v100.DispellableMagicDebuffs, v100.DispellableDiseaseDebuffs);
			v100.DispellableDebuffs = v12.MergeTable(v100.DispellableDebuffs, v100.DispellableCurseDebuffs);
		else
			v100.DispellableDebuffs = v100.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v120();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v121()
		return (v14:StealthUp(true, true) and (3.6 - 2)) or (1 + 0);
	end
	v101.Rake:RegisterPMultiplier(v101.RakeDebuff, v121);
	local function v122()
		v110 = v14:BuffUp(v101.EclipseSolar) or v14:BuffUp(v101.EclipseLunar);
		v111 = v14:BuffUp(v101.EclipseSolar) and v14:BuffUp(v101.EclipseLunar);
		v112 = v14:BuffUp(v101.EclipseLunar) and v14:BuffDown(v101.EclipseSolar);
		v113 = v14:BuffUp(v101.EclipseSolar) and v14:BuffDown(v101.EclipseLunar);
		v114 = (not v110 and (((v101.Starfire:Count() == (0 + 0)) and (v101.Wrath:Count() > (0 - 0))) or v14:IsCasting(v101.Wrath))) or v113;
		v115 = (not v110 and (((v101.Wrath:Count() == (0 + 0)) and (v101.Starfire:Count() > (0 - 0))) or v14:IsCasting(v101.Starfire))) or v112;
		v116 = not v110 and (v101.Wrath:Count() > (0 + 0)) and (v101.Starfire:Count() > (0 + 0));
	end
	local function v123(v149)
		return v149:DebuffRefreshable(v101.SunfireDebuff) and (v109 > (4 + 1));
	end
	local function v124(v150)
		return (v150:DebuffRefreshable(v101.MoonfireDebuff) and (v109 > (11 + 1)) and ((((v107 <= (4 + 0)) or (v14:Energy() < (483 - (153 + 280)))) and v14:BuffDown(v101.HeartOfTheWild)) or (((v107 <= (11 - 7)) or (v14:Energy() < (45 + 5))) and v14:BuffUp(v101.HeartOfTheWild))) and v150:DebuffDown(v101.MoonfireDebuff)) or (v14:PrevGCD(1 + 0, v101.Sunfire) and ((v150:DebuffUp(v101.MoonfireDebuff) and (v150:DebuffRemains(v101.MoonfireDebuff) < (v150:DebuffDuration(v101.MoonfireDebuff) * (0.8 + 0)))) or v150:DebuffDown(v101.MoonfireDebuff)) and (v107 == (1 + 0)));
	end
	local function v125(v151)
		return v151:DebuffRefreshable(v101.MoonfireDebuff) and (v151:TimeToDie() > (4 + 1));
	end
	local function v126(v152)
		return ((v152:DebuffRefreshable(v101.Rip) or ((v14:Energy() > (137 - 47)) and (v152:DebuffRemains(v101.Rip) <= (7 + 3)))) and (((v14:ComboPoints() == (672 - (89 + 578))) and (v152:TimeToDie() > (v152:DebuffRemains(v101.Rip) + 18 + 6))) or (((v152:DebuffRemains(v101.Rip) + (v14:ComboPoints() * (8 - 4))) < v152:TimeToDie()) and ((v152:DebuffRemains(v101.Rip) + (1053 - (572 + 477)) + (v14:ComboPoints() * (1 + 3))) > v152:TimeToDie())))) or (v152:DebuffDown(v101.Rip) and (v14:ComboPoints() > (2 + 0 + (v107 * (1 + 1)))));
	end
	local function v127(v153)
		return (v153:DebuffDown(v101.RakeDebuff) or v153:DebuffRefreshable(v101.RakeDebuff)) and (v153:TimeToDie() > (96 - (84 + 2))) and (v14:ComboPoints() < (8 - 3));
	end
	local function v128(v154)
		return (v154:DebuffUp(v101.AdaptiveSwarmDebuff));
	end
	local function v129()
		return v100.FriendlyUnitsWithBuffCount(v101.Rejuvenation) + v100.FriendlyUnitsWithBuffCount(v101.Regrowth) + v100.FriendlyUnitsWithBuffCount(v101.Wildgrowth);
	end
	local function v130()
		return v100.FriendlyUnitsWithoutBuffCount(v101.Rejuvenation);
	end
	local function v131(v155)
		return v155:BuffUp(v101.Rejuvenation) or v155:BuffUp(v101.Regrowth) or v155:BuffUp(v101.Wildgrowth);
	end
	local function v132()
		local v156 = 0 + 0;
		local v157;
		while true do
			if (((4978 - (497 + 345)) > (62 + 2335)) and (v156 == (1 + 0))) then
				v157 = v100.HandleBottomTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 1373 - (605 + 728), nil);
				if (v157 or ((3093 + 1241) == (9437 - 5192))) then
					return v157;
				end
				break;
			end
			if ((v156 == (0 + 0)) or ((15809 - 11533) <= (2733 + 298))) then
				v157 = v100.HandleTopTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 110 - 70, nil);
				if (v157 or ((3611 + 1171) <= (1688 - (457 + 32)))) then
					return v157;
				end
				v156 = 1 + 0;
			end
		end
	end
	local function v133()
		local v158 = 1402 - (832 + 570);
		while true do
			if ((v158 == (4 + 0)) or ((1269 + 3595) < (6730 - 4828))) then
				if (((2331 + 2508) >= (4496 - (588 + 208))) and v101.Swipe:IsReady() and (v107 >= (5 - 3))) then
					if (v25(v101.Swipe, not v16:IsInMeleeRange(1808 - (884 + 916))) or ((2250 - 1175) > (1113 + 805))) then
						return "swipe cat 38";
					end
				end
				if (((1049 - (232 + 421)) <= (5693 - (1569 + 320))) and v101.Shred:IsReady() and ((v14:ComboPoints() < (2 + 3)) or (v14:Energy() > (18 + 72)))) then
					if (v25(v101.Shred, not v16:IsInMeleeRange(16 - 11)) or ((4774 - (316 + 289)) == (5724 - 3537))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if (((65 + 1341) == (2859 - (666 + 787))) and (v158 == (428 - (360 + 65)))) then
				if (((1431 + 100) < (4525 - (79 + 175))) and v101.Rip:IsAvailable() and v101.Rip:IsReady() and (v107 < (17 - 6)) and v126(v16)) then
					if (((496 + 139) == (1946 - 1311)) and v25(v101.Rip, not v16:IsInMeleeRange(9 - 4))) then
						return "rip cat 34";
					end
				end
				if (((4272 - (503 + 396)) <= (3737 - (92 + 89))) and v101.Thrash:IsReady() and (v107 >= (3 - 1)) and v16:DebuffRefreshable(v101.ThrashDebuff)) then
					if (v25(v101.Thrash, not v16:IsInMeleeRange(5 + 3)) or ((1948 + 1343) < (12844 - 9564))) then
						return "thrash cat";
					end
				end
				if (((600 + 3786) >= (1990 - 1117)) and v101.Rake:IsReady() and v127(v16)) then
					if (((804 + 117) <= (527 + 575)) and v25(v101.Rake, not v16:IsInMeleeRange(15 - 10))) then
						return "rake cat 36";
					end
				end
				if (((588 + 4118) >= (1468 - 505)) and v101.Rake:IsReady() and ((v14:ComboPoints() < (1249 - (485 + 759))) or (v14:Energy() > (208 - 118))) and (v16:PMultiplier(v101.Rake) <= v14:PMultiplier(v101.Rake)) and v128(v16)) then
					if (v25(v101.Rake, not v16:IsInMeleeRange(1194 - (442 + 747))) or ((2095 - (832 + 303)) <= (1822 - (88 + 858)))) then
						return "rake cat 40";
					end
				end
				v158 = 2 + 2;
			end
			if ((v158 == (0 + 0)) or ((86 + 1980) == (1721 - (766 + 23)))) then
				if (((23819 - 18994) < (6622 - 1779)) and v101.Rake:IsReady() and (v14:StealthUp(false, true))) then
					if (v25(v101.Rake, not v16:IsInMeleeRange(26 - 16)) or ((13158 - 9281) >= (5610 - (1036 + 37)))) then
						return "rake cat 2";
					end
				end
				if ((v39 and not v14:StealthUp(false, true)) or ((3060 + 1255) < (3361 - 1635))) then
					local v219 = 0 + 0;
					local v220;
					while true do
						if ((v219 == (1480 - (641 + 839))) or ((4592 - (910 + 3)) < (1593 - 968))) then
							v220 = v132();
							if (v220 or ((6309 - (1466 + 218)) < (291 + 341))) then
								return v220;
							end
							break;
						end
					end
				end
				if (v101.AdaptiveSwarm:IsCastable() or ((1231 - (556 + 592)) > (633 + 1147))) then
					if (((1354 - (329 + 479)) <= (1931 - (174 + 680))) and v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm))) then
						return "adaptive_swarm cat";
					end
				end
				if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((3422 - 2426) > (8914 - 4613))) then
					if (((2906 + 1164) > (1426 - (396 + 343))) and v14:BuffUp(v101.CatForm)) then
						if (((v14:BuffUp(v101.HeartOfTheWild) or (v101.HeartOfTheWild:CooldownRemains() > (6 + 54)) or not v101.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (1527 - (29 + 1448))) and (((v14:ComboPoints() < (1394 - (135 + 1254))) and (v16:DebuffRemains(v101.Rip) > (18 - 13))) or (v107 > (4 - 3)))) or ((438 + 218) >= (4857 - (389 + 1138)))) then
							if (v25(v101.ConvokeTheSpirits, not v16:IsInRange(604 - (102 + 472))) or ((2352 + 140) <= (186 + 149))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				v158 = 1 + 0;
			end
			if (((5867 - (320 + 1225)) >= (4560 - 1998)) and (v158 == (2 + 0))) then
				if ((v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) or ((5101 - (157 + 1307)) >= (5629 - (821 + 1038)))) then
					if (v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge)) or ((5935 - 3556) > (501 + 4077))) then
						return "starsurge cat 26";
					end
				end
				if ((v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (53 - 23)) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild) and v16:DebuffUp(v101.SunfireDebuff) and (v16:DebuffUp(v101.MoonfireDebuff) or (v107 > (2 + 2)))) or ((1197 - 714) > (1769 - (834 + 192)))) then
					if (((157 + 2297) > (149 + 429)) and v25(v101.HeartOfTheWild)) then
						return "heart_of_the_wild cat 26";
					end
				end
				if (((20 + 910) < (6906 - 2448)) and v101.CatForm:IsReady() and v14:BuffDown(v101.CatForm) and (v14:Energy() >= (334 - (300 + 4))) and v36) then
					if (((177 + 485) <= (2544 - 1572)) and v25(v101.CatForm)) then
						return "cat_form cat 28";
					end
				end
				if (((4732 - (112 + 250)) == (1743 + 2627)) and v101.FerociousBite:IsReady() and (((v14:ComboPoints() > (7 - 4)) and (v16:TimeToDie() < (6 + 4))) or ((v14:ComboPoints() == (3 + 2)) and (v14:Energy() >= (19 + 6)) and (not v101.Rip:IsAvailable() or (v16:DebuffRemains(v101.Rip) > (3 + 2)))))) then
					if (v25(v101.FerociousBite, not v16:IsInMeleeRange(4 + 1)) or ((6176 - (1001 + 413)) <= (1919 - 1058))) then
						return "ferocious_bite cat 32";
					end
				end
				v158 = 885 - (244 + 638);
			end
			if ((v158 == (694 - (627 + 66))) or ((4207 - 2795) == (4866 - (512 + 90)))) then
				if ((v101.Sunfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (1911 - (1665 + 241))) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (747 - (373 + 344))))) or ((1429 + 1739) < (570 + 1583))) then
					if (v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover) or ((13125 - 8149) < (2253 - 921))) then
						return "sunfire cat 20";
					end
				end
				if (((5727 - (35 + 1064)) == (3368 + 1260)) and v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (10 - 5)) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (1 + 29)))) then
					if (v100.CastCycle(v101.Moonfire, v106, v124, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((1290 - (298 + 938)) == (1654 - (233 + 1026)))) then
						return "moonfire cat 22";
					end
				end
				if (((1748 - (636 + 1030)) == (42 + 40)) and v101.Sunfire:IsReady() and v16:DebuffDown(v101.SunfireDebuff) and (v16:TimeToDie() > (5 + 0))) then
					if (v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire)) or ((173 + 408) < (20 + 262))) then
						return "sunfire cat 24";
					end
				end
				if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and v16:DebuffDown(v101.MoonfireDebuff) and (v16:TimeToDie() > (226 - (55 + 166)))) or ((894 + 3715) < (251 + 2244))) then
					if (((4399 - 3247) == (1449 - (36 + 261))) and v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire))) then
						return "moonfire cat 24";
					end
				end
				v158 = 3 - 1;
			end
		end
	end
	local function v134()
		if (((3264 - (34 + 1334)) <= (1316 + 2106)) and v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (24 + 6)) or (v101.ConvokeTheSpirits:CooldownRemains() > (1373 - (1035 + 248))) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild)) then
			if (v25(v101.HeartOfTheWild) or ((1011 - (20 + 1)) > (844 + 776))) then
				return "heart_of_the_wild owl 2";
			end
		end
		if ((v101.MoonkinForm:IsReady() and (v14:BuffDown(v101.MoonkinForm)) and v36) or ((1196 - (134 + 185)) > (5828 - (549 + 584)))) then
			if (((3376 - (314 + 371)) >= (6354 - 4503)) and v25(v101.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if ((v101.Starsurge:IsReady() and ((v107 < (974 - (478 + 490))) or (not v112 and (v107 < (5 + 3)))) and v36) or ((4157 - (786 + 386)) >= (15728 - 10872))) then
			if (((5655 - (1055 + 324)) >= (2535 - (1093 + 247))) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
				return "starsurge owl 8";
			end
		end
		if (((2873 + 359) <= (494 + 4196)) and v101.Moonfire:IsReady() and ((v107 < (19 - 14)) or (not v112 and (v107 < (23 - 16))))) then
			if (v100.CastCycle(v101.Moonfire, v106, v125, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((2549 - 1653) >= (7905 - 4759))) then
				return "moonfire owl 10";
			end
		end
		if (((1089 + 1972) >= (11395 - 8437)) and v101.Sunfire:IsReady()) then
			if (((10984 - 7797) >= (486 + 158)) and v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if (((1646 - 1002) <= (1392 - (364 + 324))) and v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) then
			if (((2626 - 1668) > (2272 - 1325)) and v14:BuffUp(v101.MoonkinForm)) then
				if (((1489 + 3003) >= (11105 - 8451)) and v25(v101.ConvokeTheSpirits, not v16:IsInRange(48 - 18))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((10453 - 7011) >= (2771 - (1249 + 19))) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(8 + 0)) and ((v113 and (v107 == (3 - 2))) or v114 or (v116 and (v107 > (1087 - (686 + 400)))))) then
			if (v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true) or ((2488 + 682) <= (1693 - (73 + 156)))) then
				return "wrath owl 14";
			end
		end
		if (v101.Starfire:IsReady() or ((23 + 4774) == (5199 - (721 + 90)))) then
			if (((7 + 544) <= (2211 - 1530)) and v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true)) then
				return "starfire owl 16";
			end
		end
	end
	local function v135()
		local v159 = 470 - (224 + 246);
		local v160;
		local v161;
		while true do
			if (((5308 - 2031) > (749 - 342)) and (v159 == (0 + 0))) then
				v160 = v100.InterruptWithStun(v101.IncapacitatingRoar, 1 + 7);
				if (((3449 + 1246) >= (2813 - 1398)) and v160) then
					return v160;
				end
				if ((v14:BuffUp(v101.CatForm) and (v14:ComboPoints() > (0 - 0))) or ((3725 - (203 + 310)) <= (2937 - (1238 + 755)))) then
					v160 = v100.InterruptWithStun(v101.Maim, 1 + 7);
					if (v160 or ((4630 - (709 + 825)) <= (3312 - 1514))) then
						return v160;
					end
				end
				v160 = v100.InterruptWithStun(v101.MightyBash, 11 - 3);
				v159 = 865 - (196 + 668);
			end
			if (((13964 - 10427) == (7326 - 3789)) and ((834 - (171 + 662)) == v159)) then
				if (((3930 - (4 + 89)) >= (5502 - 3932)) and v160) then
					return v160;
				end
				v122();
				v161 = 0 + 0;
				if (v101.Rip:IsAvailable() or ((12957 - 10007) == (1495 + 2317))) then
					v161 = v161 + (1487 - (35 + 1451));
				end
				v159 = 1455 - (28 + 1425);
			end
			if (((6716 - (941 + 1052)) >= (2223 + 95)) and (v159 == (1518 - (822 + 692)))) then
				if ((v101.Starfire:IsReady() and (v107 > (2 - 0))) or ((955 + 1072) > (3149 - (45 + 252)))) then
					if (v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true) or ((1124 + 12) > (1486 + 2831))) then
						return "starfire owl 16";
					end
				end
				if (((11555 - 6807) == (5181 - (114 + 319))) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(11 - 3))) then
					if (((4787 - 1051) <= (3022 + 1718)) and v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true)) then
						return "wrath main 30";
					end
				end
				if ((v101.Moonfire:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(11 - 3))) or ((7102 - 3712) <= (5023 - (556 + 1407)))) then
					if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((2205 - (741 + 465)) > (3158 - (170 + 295)))) then
						return "moonfire main 32";
					end
				end
				if (((244 + 219) < (553 + 48)) and true) then
					if (v25(v101.Pool) or ((5374 - 3191) < (570 + 117))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((2918 + 1631) == (2576 + 1973)) and (v159 == (1233 - (957 + 273)))) then
				if (((1250 + 3422) == (1871 + 2801)) and v101.MoonkinForm:IsAvailable()) then
					local v221 = 0 - 0;
					local v222;
					while true do
						if ((v221 == (0 - 0)) or ((11203 - 7535) < (1955 - 1560))) then
							v222 = v134();
							if (v222 or ((5946 - (389 + 1391)) == (286 + 169))) then
								return v222;
							end
							break;
						end
					end
				end
				if ((v101.Sunfire:IsReady() and (v16:DebuffRefreshable(v101.SunfireDebuff))) or ((464 + 3985) == (6062 - 3399))) then
					if (v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire)) or ((5228 - (783 + 168)) < (10031 - 7042))) then
						return "sunfire main 24";
					end
				end
				if ((v101.Moonfire:IsReady() and (v16:DebuffRefreshable(v101.MoonfireDebuff))) or ((856 + 14) >= (4460 - (309 + 2)))) then
					if (((6792 - 4580) < (4395 - (1090 + 122))) and v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire))) then
						return "moonfire main 26";
					end
				end
				if (((1507 + 3139) > (10048 - 7056)) and v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) then
					if (((982 + 452) < (4224 - (628 + 490))) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
						return "starsurge main 28";
					end
				end
				v159 = 1 + 3;
			end
			if (((1945 - 1159) < (13815 - 10792)) and (v159 == (776 - (431 + 343)))) then
				if (v101.Rake:IsAvailable() or ((4931 - 2489) < (213 - 139))) then
					v161 = v161 + 1 + 0;
				end
				if (((581 + 3954) == (6230 - (556 + 1139))) and v101.Thrash:IsAvailable()) then
					v161 = v161 + (16 - (6 + 9));
				end
				if (((v161 >= (1 + 1)) and v16:IsInMeleeRange(5 + 3)) or ((3178 - (28 + 141)) <= (816 + 1289))) then
					local v223 = v133();
					if (((2258 - 428) < (2599 + 1070)) and v223) then
						return v223;
					end
				end
				if (v101.AdaptiveSwarm:IsCastable() or ((2747 - (486 + 831)) >= (9399 - 5787))) then
					if (((9445 - 6762) >= (465 + 1995)) and v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				v159 = 9 - 6;
			end
		end
	end
	local v136 = 1263 - (668 + 595);
	local function v137()
		if ((v17 and v100.DispellableFriendlyUnit(18 + 2) and v101.NaturesCure:IsReady()) or ((364 + 1440) >= (8931 - 5656))) then
			if ((v136 == (290 - (23 + 267))) or ((3361 - (1129 + 815)) > (4016 - (371 + 16)))) then
				v136 = GetTime();
			end
			if (((6545 - (1326 + 424)) > (760 - 358)) and v100.Wait(1827 - 1327, v136)) then
				local v217 = 118 - (88 + 30);
				while true do
					if (((5584 - (720 + 51)) > (7930 - 4365)) and (v217 == (1776 - (421 + 1355)))) then
						if (((6453 - 2541) == (1922 + 1990)) and v25(v104.NaturesCureFocus)) then
							return "natures_cure dispel 2";
						end
						v136 = 1083 - (286 + 797);
						break;
					end
				end
			end
		end
	end
	local function v138()
		if (((10312 - 7491) <= (7990 - 3166)) and (v14:HealthPercentage() <= v96) and v97 and v101.Barkskin:IsReady()) then
			if (((2177 - (397 + 42)) <= (686 + 1509)) and v25(v101.Barkskin, nil, nil, true)) then
				return "barkskin defensive 2";
			end
		end
		if (((841 - (24 + 776)) <= (4649 - 1631)) and (v14:HealthPercentage() <= v98) and v99 and v101.Renewal:IsReady()) then
			if (((2930 - (222 + 563)) <= (9042 - 4938)) and v25(v101.Renewal, nil, nil, true)) then
				return "renewal defensive 2";
			end
		end
		if (((1937 + 752) < (5035 - (23 + 167))) and v102.Healthstone:IsReady() and v46 and (v14:HealthPercentage() <= v47)) then
			if (v25(v104.Healthstone, nil, nil, true) or ((4120 - (690 + 1108)) > (946 + 1676))) then
				return "healthstone defensive 3";
			end
		end
		if ((v40 and (v14:HealthPercentage() <= v42)) or ((3740 + 794) == (2930 - (40 + 808)))) then
			if ((v41 == "Refreshing Healing Potion") or ((259 + 1312) > (7139 - 5272))) then
				if (v102.RefreshingHealingPotion:IsReady() or ((2537 + 117) >= (1585 + 1411))) then
					if (((2182 + 1796) > (2675 - (47 + 524))) and v25(v104.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v139()
		local v162 = 0 + 0;
		while true do
			if (((8186 - 5191) > (2303 - 762)) and (v162 == (4 - 2))) then
				if (((4975 - (1165 + 561)) > (29 + 924)) and v14:BuffUp(v101.Innervate) and (v130() > (0 - 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
					if (v25(v104.RejuvenationMouseover) or ((1249 + 2024) > (5052 - (341 + 138)))) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if ((v162 == (0 + 0)) or ((6502 - 3351) < (1610 - (89 + 237)))) then
				if ((v101.Swiftmend:IsReady() and not v131(v17) and v14:BuffDown(v101.SoulOfTheForestBuff)) or ((5951 - 4101) == (3218 - 1689))) then
					if (((1702 - (581 + 300)) < (3343 - (855 + 365))) and v25(v104.RejuvenationFocus)) then
						return "rejuvenation ramp";
					end
				end
				if (((2142 - 1240) < (760 + 1565)) and v101.Swiftmend:IsReady() and v131(v17)) then
					if (((2093 - (1030 + 205)) <= (2781 + 181)) and v25(v104.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				v162 = 1 + 0;
			end
			if ((v162 == (287 - (156 + 130))) or ((8966 - 5020) < (2170 - 882))) then
				if ((v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady()) or ((6639 - 3397) == (150 + 417))) then
					if (v25(v104.WildgrowthFocus, nil, true) or ((494 + 353) >= (1332 - (10 + 59)))) then
						return "wildgrowth ramp";
					end
				end
				if ((v101.Innervate:IsReady() and v14:BuffDown(v101.Innervate)) or ((638 + 1615) == (9115 - 7264))) then
					if (v25(v104.InnervatePlayer, nil, nil, true) or ((3250 - (671 + 492)) > (1889 + 483))) then
						return "innervate ramp";
					end
				end
				v162 = 1217 - (369 + 846);
			end
		end
	end
	local function v140()
		if (v37 or ((1177 + 3268) < (3541 + 608))) then
			local v209 = 1945 - (1036 + 909);
			while true do
				if (((4 + 0) == v209) or ((3052 - 1234) == (288 - (11 + 192)))) then
					if (((319 + 311) < (2302 - (135 + 40))) and (v55 == "Player")) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (36 - 21))) or ((1169 + 769) == (5538 - 3024))) then
							if (((6378 - 2123) >= (231 - (50 + 126))) and v25(v104.EfflorescencePlayer)) then
								return "efflorescence healing player";
							end
						end
					elseif (((8350 - 5351) > (256 + 900)) and (v55 == "Cursor")) then
						if (((3763 - (1233 + 180)) > (2124 - (522 + 447))) and v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (1436 - (107 + 1314)))) then
							if (((1870 + 2159) <= (14787 - 9934)) and v25(v104.EfflorescenceCursor)) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v55 == "Confirmation") or ((220 + 296) > (6818 - 3384))) then
						if (((16008 - 11962) >= (4943 - (716 + 1194))) and v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (1 + 14))) then
							if (v25(v101.Efflorescence) or ((292 + 2427) <= (1950 - (74 + 429)))) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v101.Wildgrowth:IsReady() and v93 and v100.AreUnitsBelowHealthPercentage(v94, v95) and (not v101.Swiftmend:IsAvailable() or not v101.Swiftmend:IsReady())) or ((7974 - 3840) < (1946 + 1980))) then
						if (v25(v104.WildgrowthFocus, nil, true) or ((375 - 211) >= (1971 + 814))) then
							return "wildgrowth healing";
						end
					end
					if ((v101.Regrowth:IsCastable() and v76 and (v17:HealthPercentage() <= v77)) or ((1618 - 1093) == (5214 - 3105))) then
						if (((466 - (279 + 154)) == (811 - (454 + 324))) and v25(v104.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					if (((2403 + 651) <= (4032 - (12 + 5))) and v14:BuffUp(v101.Innervate) and (v130() > (0 + 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
						if (((4767 - 2896) < (1250 + 2132)) and v25(v104.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					v209 = 1098 - (277 + 816);
				end
				if (((5524 - 4231) <= (3349 - (1058 + 125))) and (v209 == (1 + 4))) then
					if ((v101.Rejuvenation:IsCastable() and v80 and v17:BuffRefreshable(v101.Rejuvenation) and (v17:HealthPercentage() <= v81)) or ((3554 - (815 + 160)) < (527 - 404))) then
						if (v25(v104.RejuvenationFocus) or ((2008 - 1162) >= (565 + 1803))) then
							return "rejuvenation healing";
						end
					end
					if ((v101.Regrowth:IsCastable() and v78 and v17:BuffUp(v101.Rejuvenation) and (v17:HealthPercentage() <= v79)) or ((11727 - 7715) <= (5256 - (41 + 1857)))) then
						if (((3387 - (1222 + 671)) <= (7766 - 4761)) and v25(v104.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v209 == (0 - 0)) or ((4293 - (229 + 953)) == (3908 - (1111 + 663)))) then
					if (((3934 - (874 + 705)) == (330 + 2025)) and v39) then
						local v235 = v132();
						if (v235 or ((402 + 186) <= (897 - 465))) then
							return v235;
						end
					end
					if (((136 + 4661) >= (4574 - (642 + 37))) and v54 and v32 and v14:AffectingCombat() and (v129() > (1 + 2)) and v101.NaturesVigil:IsReady()) then
						if (((573 + 3004) == (8980 - 5403)) and v25(v101.NaturesVigil, nil, nil, true)) then
							return "natures_vigil healing";
						end
					end
					if (((4248 - (233 + 221)) > (8539 - 4846)) and v101.Swiftmend:IsReady() and v82 and v14:BuffDown(v101.SoulOfTheForestBuff) and v131(v17) and (v17:HealthPercentage() <= v83)) then
						if (v25(v104.SwiftmendFocus) or ((1123 + 152) == (5641 - (718 + 823)))) then
							return "swiftmend healing";
						end
					end
					if ((v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady() and v100.AreUnitsBelowHealthPercentage(v91, v92)) or ((1002 + 589) >= (4385 - (266 + 539)))) then
						if (((2782 - 1799) <= (3033 - (636 + 589))) and v25(v104.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					v209 = 2 - 1;
				end
				if ((v209 == (5 - 2)) or ((1704 + 446) <= (435 + 762))) then
					if (((4784 - (657 + 358)) >= (3105 - 1932)) and (v68 == "Anyone")) then
						if (((3383 - 1898) == (2672 - (1151 + 36))) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69)) then
							if (v25(v104.IronBarkFocus) or ((3202 + 113) <= (732 + 2050))) then
								return "iron_bark healing";
							end
						end
					elseif ((v68 == "Tank Only") or ((2616 - 1740) >= (4796 - (1552 + 280)))) then
						if ((v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and (v100.UnitGroupRole(v17) == "TANK")) or ((3066 - (64 + 770)) > (1696 + 801))) then
							if (v25(v104.IronBarkFocus) or ((4789 - 2679) <= (59 + 273))) then
								return "iron_bark healing";
							end
						end
					elseif (((4929 - (157 + 1086)) > (6348 - 3176)) and (v68 == "Tank and Self")) then
						if ((v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and ((v100.UnitGroupRole(v17) == "TANK") or (v100.UnitGroupRole(v17) == "HEALER"))) or ((19594 - 15120) < (1257 - 437))) then
							if (((5839 - 1560) >= (3701 - (599 + 220))) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					end
					if ((v101.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) or ((4040 - 2011) >= (5452 - (1813 + 118)))) then
						if (v25(v104.AdaptiveSwarmFocus) or ((1490 + 547) >= (5859 - (841 + 376)))) then
							return "adaptive_swarm healing";
						end
					end
					if (((2410 - 690) < (1036 + 3422)) and v14:AffectingCombat() and v70 and (v100.UnitGroupRole(v17) == "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, true, false) < (2 - 1)) and (v17:HealthPercentage() <= (v71 - (v27(v14:BuffUp(v101.CatForm)) * (874 - (464 + 395))))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) then
						if (v25(v104.LifebloomFocus) or ((1118 - 682) > (1451 + 1570))) then
							return "lifebloom healing";
						end
					end
					if (((1550 - (467 + 370)) <= (1750 - 903)) and v14:AffectingCombat() and v72 and (v100.UnitGroupRole(v17) ~= "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, false, true) < (1 + 0)) and (v101.Undergrowth:IsAvailable() or v100.IsSoloMode()) and (v17:HealthPercentage() <= (v73 - (v27(v14:BuffUp(v101.CatForm)) * (51 - 36)))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) then
						if (((337 + 1817) <= (9378 - 5347)) and v25(v104.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v209 = 524 - (150 + 370);
				end
				if (((5897 - (74 + 1208)) == (11351 - 6736)) and ((9 - 7) == v209)) then
					if ((v14:AffectingCombat() and v32 and v101.ConvokeTheSpirits:IsReady() and v100.AreUnitsBelowHealthPercentage(v63, v64)) or ((2697 + 1093) == (890 - (14 + 376)))) then
						if (((153 - 64) < (144 + 77)) and v25(v101.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					if (((1805 + 249) >= (1356 + 65)) and v101.CenarionWard:IsReady() and v60 and (v17:HealthPercentage() <= v61)) then
						if (((2027 - 1335) < (2301 + 757)) and v25(v104.CenarionWardFocus)) then
							return "cenarion_ward healing";
						end
					end
					if ((v14:BuffUp(v101.NaturesSwiftness) and v101.Regrowth:IsCastable()) or ((3332 - (23 + 55)) == (3922 - 2267))) then
						if (v25(v104.RegrowthFocus) or ((865 + 431) == (4410 + 500))) then
							return "regrowth_swiftness healing";
						end
					end
					if (((5221 - 1853) == (1060 + 2308)) and v101.NaturesSwiftness:IsReady() and v74 and (v17:HealthPercentage() <= v75)) then
						if (((3544 - (652 + 249)) < (10209 - 6394)) and v25(v101.NaturesSwiftness)) then
							return "natures_swiftness healing";
						end
					end
					v209 = 1871 - (708 + 1160);
				end
				if (((5192 - 3279) > (898 - 405)) and (v209 == (28 - (10 + 17)))) then
					if (((1068 + 3687) > (5160 - (1400 + 332))) and v57 and v101.GroveGuardians:IsReady() and (v101.GroveGuardians:TimeSinceLastCast() > (9 - 4)) and v100.AreUnitsBelowHealthPercentage(v58, v59)) then
						if (((3289 - (242 + 1666)) <= (1014 + 1355)) and v25(v104.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Flourish:IsReady() and v14:BuffDown(v101.Flourish) and (v129() > (2 + 2)) and v100.AreUnitsBelowHealthPercentage(v66, v67)) or ((4128 + 715) == (5024 - (850 + 90)))) then
						if (((8177 - 3508) > (1753 - (360 + 1030))) and v25(v101.Flourish, nil, nil, true)) then
							return "flourish healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v100.AreUnitsBelowHealthPercentage(v85, v86)) or ((1662 + 215) >= (8856 - 5718))) then
						if (((6523 - 1781) >= (5287 - (909 + 752))) and v25(v101.Tranquility, nil, true)) then
							return "tranquility healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v14:BuffUp(v101.IncarnationBuff) and v100.AreUnitsBelowHealthPercentage(v88, v89)) or ((5763 - (109 + 1114)) == (1676 - 760))) then
						if (v25(v101.Tranquility, nil, true) or ((450 + 706) > (4587 - (6 + 236)))) then
							return "tranquility_tree healing";
						end
					end
					v209 = 2 + 0;
				end
			end
		end
	end
	local function v141()
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((5275 - 3038) < (7421 - 3172)) and (v163 == (1133 - (1076 + 57)))) then
				if (((v45 or v44) and v33) or ((442 + 2241) < (712 - (579 + 110)))) then
					local v224 = v137();
					if (((56 + 641) <= (731 + 95)) and v224) then
						return v224;
					end
				end
				v164 = v138();
				v163 = 1 + 0;
			end
			if (((1512 - (174 + 233)) <= (3284 - 2108)) and ((4 - 1) == v163)) then
				if (((1503 + 1876) <= (4986 - (663 + 511))) and v100.TargetIsValid() and v35) then
					local v225 = 0 + 0;
					while true do
						if (((0 + 0) == v225) or ((2429 - 1641) >= (979 + 637))) then
							v164 = v135();
							if (((4364 - 2510) <= (8179 - 4800)) and v164) then
								return v164;
							end
							break;
						end
					end
				end
				break;
			end
			if (((2171 + 2378) == (8853 - 4304)) and (v163 == (1 + 0))) then
				if (v164 or ((277 + 2745) >= (3746 - (478 + 244)))) then
					return v164;
				end
				if (((5337 - (440 + 77)) > (1000 + 1198)) and v34) then
					local v226 = 0 - 0;
					local v227;
					while true do
						if (((1556 - (655 + 901)) == v226) or ((197 + 864) >= (3745 + 1146))) then
							v227 = v139();
							if (((922 + 442) <= (18019 - 13546)) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				v163 = 1447 - (695 + 750);
			end
			if (((6 - 4) == v163) or ((5547 - 1952) <= (11 - 8))) then
				v164 = v140();
				if (v164 or ((5023 - (285 + 66)) == (8978 - 5126))) then
					return v164;
				end
				v163 = 1313 - (682 + 628);
			end
		end
	end
	local function v142()
		local v165 = 0 + 0;
		while true do
			if (((1858 - (176 + 123)) == (653 + 906)) and (v165 == (0 + 0))) then
				if (((v45 or v44) and v33) or ((2021 - (239 + 30)) <= (215 + 573))) then
					local v228 = 0 + 0;
					local v229;
					while true do
						if (((0 - 0) == v228) or ((12189 - 8282) == (492 - (306 + 9)))) then
							v229 = v137();
							if (((12108 - 8638) > (97 + 458)) and v229) then
								return v229;
							end
							break;
						end
					end
				end
				if ((v30 and v37) or ((597 + 375) == (311 + 334))) then
					local v230 = 0 - 0;
					local v231;
					while true do
						if (((4557 - (1140 + 235)) >= (1346 + 769)) and ((0 + 0) == v230)) then
							v231 = v140();
							if (((1000 + 2893) < (4481 - (33 + 19))) and v231) then
								return v231;
							end
							break;
						end
					end
				end
				v165 = 1 + 0;
			end
			if ((v165 == (2 - 1)) or ((1263 + 1604) < (3735 - 1830))) then
				if ((v43 and v101.MarkOfTheWild:IsCastable() and (v14:BuffDown(v101.MarkOfTheWild, true) or v100.GroupBuffMissing(v101.MarkOfTheWild))) or ((1685 + 111) >= (4740 - (586 + 103)))) then
					if (((148 + 1471) <= (11563 - 7807)) and v25(v104.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (((2092 - (1309 + 179)) == (1089 - 485)) and v100.TargetIsValid()) then
					if ((v101.Rake:IsReady() and (v14:StealthUp(false, true))) or ((1952 + 2532) == (2417 - 1517))) then
						if (v25(v101.Rake, not v16:IsInMeleeRange(8 + 2)) or ((9473 - 5014) <= (2217 - 1104))) then
							return "rake";
						end
					end
				end
				v165 = 611 - (295 + 314);
			end
			if (((8920 - 5288) > (5360 - (1300 + 662))) and (v165 == (6 - 4))) then
				if (((5837 - (1178 + 577)) <= (2554 + 2363)) and v100.TargetIsValid() and v35) then
					local v232 = v135();
					if (((14284 - 9452) >= (2791 - (851 + 554))) and v232) then
						return v232;
					end
				end
				break;
			end
		end
	end
	local function v143()
		v38 = EpicSettings.Settings['UseRacials'];
		v39 = EpicSettings.Settings['UseTrinkets'];
		v40 = EpicSettings.Settings['UseHealingPotion'];
		v41 = EpicSettings.Settings['HealingPotionName'] or "";
		v42 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v43 = EpicSettings.Settings['UseMarkOfTheWild'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v46 = EpicSettings.Settings['UseHealthstone'];
		v47 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v48 = EpicSettings.Settings['HandleCharredTreant'];
		v49 = EpicSettings.Settings['HandleCharredBrambles'];
		v50 = EpicSettings.Settings['InterruptWithStun'];
		v51 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v52 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v53 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v54 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v55 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v56 = EpicSettings.Settings['EfflorescenceHP'] or (302 - (115 + 187));
		v57 = EpicSettings.Settings['UseGroveGuardians'];
		v58 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
		v59 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 + 0);
		v60 = EpicSettings.Settings['UseCenarionWard'];
		v61 = EpicSettings.Settings['CenarionWardHP'] or (0 - 0);
		v62 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v63 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (1161 - (160 + 1001));
		v64 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
		v65 = EpicSettings.Settings['UseFlourish'];
		v66 = EpicSettings.Settings['FlourishHP'] or (0 + 0);
		v67 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
		v68 = EpicSettings.Settings['IronBarkUsage'] or "";
		v69 = EpicSettings.Settings['IronBarkHP'] or (358 - (237 + 121));
	end
	local function v144()
		v70 = EpicSettings.Settings['UseLifebloomTank'];
		v71 = EpicSettings.Settings['LifebloomTankHP'] or (897 - (525 + 372));
		v72 = EpicSettings.Settings['UseLifebloom'];
		v73 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
		v74 = EpicSettings.Settings['UseNaturesSwiftness'];
		v75 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
		v76 = EpicSettings.Settings['UseRegrowth'];
		v77 = EpicSettings.Settings['RegrowthHP'] or (142 - (96 + 46));
		v78 = EpicSettings.Settings['UseRegrowthRefresh'];
		v79 = EpicSettings.Settings['RegrowthRefreshHP'] or (777 - (643 + 134));
		v80 = EpicSettings.Settings['UseRejuvenation'];
		v81 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
		v82 = EpicSettings.Settings['UseSwiftmend'];
		v83 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
		v84 = EpicSettings.Settings['UseTranquility'];
		v85 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v86 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
		v87 = EpicSettings.Settings['UseTranquilityTree'];
		v88 = EpicSettings.Settings['TranquilityTreeHP'] or (0 - 0);
		v89 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 - 0);
		v90 = EpicSettings.Settings['UseWildgrowthSotF'];
		v91 = EpicSettings.Settings['WildgrowthSotFHP'] or (719 - (316 + 403));
		v92 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 + 0);
		v93 = EpicSettings.Settings['UseWildgrowth'];
		v94 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
		v95 = EpicSettings.Settings['WildgrowthGroup'] or (0 + 0);
		v96 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v97 = EpicSettings.Settings['UseBarkskin'];
		v98 = EpicSettings.Settings['RenewalHP'] or (0 + 0);
		v99 = EpicSettings.Settings['UseRenewal'];
	end
	local function v145()
		v143();
		v144();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['ramp'];
		v35 = EpicSettings.Toggles['dps'];
		v36 = EpicSettings.Toggles['dpsform'];
		v37 = EpicSettings.Toggles['healing'];
		if (((45 + 92) == (474 - 337)) and v14:IsDeadOrGhost()) then
			return;
		end
		if (v14:AffectingCombat() or v44 or ((7498 - 5928) >= (8999 - 4667))) then
			local v210 = 0 + 0;
			local v211;
			while true do
				if ((v210 == (0 - 0)) or ((199 + 3865) <= (5351 - 3532))) then
					v211 = v44 and v101.NaturesCure:IsReady() and v33;
					if ((v100.IsTankBelowHealthPercentage(v69) and v101.IronBark:IsReady() and ((v68 == "Tank Only") or (v68 == "Tank and Self"))) or ((5003 - (12 + 5)) < (6113 - 4539))) then
						local v236 = 0 - 0;
						local v237;
						while true do
							if (((9408 - 4982) > (426 - 254)) and (v236 == (0 + 0))) then
								v237 = v100.FocusUnit(v211, nil, nil, "TANK", 1993 - (1656 + 317));
								if (((523 + 63) > (365 + 90)) and v237) then
									return v237;
								end
								break;
							end
						end
					elseif (((2196 - 1370) == (4065 - 3239)) and (v14:HealthPercentage() < v69) and v101.IronBark:IsReady() and (v68 == "Tank and Self")) then
						local v238 = 354 - (5 + 349);
						local v239;
						while true do
							if ((v238 == (0 - 0)) or ((5290 - (266 + 1005)) > (2927 + 1514))) then
								v239 = v100.FocusUnit(v211, nil, nil, "HEALER", 68 - 48);
								if (((2655 - 638) < (5957 - (561 + 1135))) and v239) then
									return v239;
								end
								break;
							end
						end
					else
						local v240 = 0 - 0;
						local v241;
						while true do
							if (((15501 - 10785) > (1146 - (507 + 559))) and (v240 == (0 - 0))) then
								v241 = v100.FocusUnit(v211, nil, nil, nil);
								if (v241 or ((10845 - 7338) == (3660 - (212 + 176)))) then
									return v241;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (v14:IsMounted() or ((1781 - (250 + 655)) >= (8385 - 5310))) then
			return;
		end
		if (((7603 - 3251) > (3995 - 1441)) and v14:IsMoving()) then
			v105 = GetTime();
		end
		if (v14:BuffUp(v101.TravelForm) or v14:BuffUp(v101.BearForm) or v14:BuffUp(v101.CatForm) or ((6362 - (1869 + 87)) < (14022 - 9979))) then
			if (((GetTime() - v105) < (1902 - (484 + 1417))) or ((4048 - 2159) >= (5668 - 2285))) then
				return;
			end
		end
		if (((2665 - (48 + 725)) <= (4465 - 1731)) and v31) then
			v106 = v16:GetEnemiesInSplashRange(21 - 13);
			v107 = #v106;
		else
			v106 = {};
			v107 = 1 + 0;
		end
		if (((5139 - 3216) < (621 + 1597)) and (v100.TargetIsValid() or v14:AffectingCombat())) then
			local v212 = 0 + 0;
			while true do
				if (((3026 - (152 + 701)) > (1690 - (430 + 881))) and (v212 == (1 + 0))) then
					if ((v109 == (12006 - (557 + 338))) or ((766 + 1825) == (9606 - 6197))) then
						v109 = v10.FightRemains(v106, false);
					end
					break;
				end
				if (((15807 - 11293) > (8830 - 5506)) and (v212 == (0 - 0))) then
					v108 = v10.BossFightRemains(nil, true);
					v109 = v108;
					v212 = 802 - (499 + 302);
				end
			end
		end
		if (v48 or ((1074 - (39 + 827)) >= (13327 - 8499))) then
			local v213 = v100.HandleCharredTreant(v101.Rejuvenation, v104.RejuvenationMouseover, 89 - 49);
			if (v213 or ((6287 - 4704) > (5476 - 1909))) then
				return v213;
			end
			local v213 = v100.HandleCharredTreant(v101.Regrowth, v104.RegrowthMouseover, 4 + 36, true);
			if (v213 or ((3842 - 2529) == (128 + 666))) then
				return v213;
			end
			local v213 = v100.HandleCharredTreant(v101.Swiftmend, v104.SwiftmendMouseover, 63 - 23);
			if (((3278 - (103 + 1)) > (3456 - (475 + 79))) and v213) then
				return v213;
			end
			local v213 = v100.HandleCharredTreant(v101.Wildgrowth, v104.WildgrowthMouseover, 86 - 46, true);
			if (((13184 - 9064) <= (551 + 3709)) and v213) then
				return v213;
			end
		end
		if (v49 or ((778 + 105) > (6281 - (1395 + 108)))) then
			local v214 = v100.HandleCharredBrambles(v101.Rejuvenation, v104.RejuvenationMouseover, 116 - 76);
			if (v214 or ((4824 - (7 + 1197)) >= (2133 + 2758))) then
				return v214;
			end
			local v214 = v100.HandleCharredBrambles(v101.Regrowth, v104.RegrowthMouseover, 14 + 26, true);
			if (((4577 - (27 + 292)) > (2745 - 1808)) and v214) then
				return v214;
			end
			local v214 = v100.HandleCharredBrambles(v101.Swiftmend, v104.SwiftmendMouseover, 51 - 11);
			if (v214 or ((20419 - 15550) < (1786 - 880))) then
				return v214;
			end
			local v214 = v100.HandleCharredBrambles(v101.Wildgrowth, v104.WildgrowthMouseover, 76 - 36, true);
			if (v214 or ((1364 - (43 + 96)) > (17246 - 13018))) then
				return v214;
			end
		end
		if (((7524 - 4196) > (1858 + 380)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v30) then
			local v215 = v100.DeadFriendlyUnitsCount();
			if (((1084 + 2755) > (2776 - 1371)) and v14:AffectingCombat()) then
				if (v101.Rebirth:IsReady() or ((496 + 797) <= (949 - 442))) then
					if (v25(v101.Rebirth, nil, true) or ((912 + 1984) < (60 + 745))) then
						return "rebirth";
					end
				end
			elseif (((4067 - (1414 + 337)) == (4256 - (1642 + 298))) and (v215 > (2 - 1))) then
				if (v25(v101.Revitalize, nil, true) or ((7393 - 4823) == (4548 - 3015))) then
					return "revitalize";
				end
			elseif (v25(v101.Revive, not v16:IsInRange(14 + 26), true) or ((688 + 195) == (2432 - (357 + 615)))) then
				return "revive";
			end
		end
		if ((v37 and (v14:AffectingCombat() or v30)) or ((3243 + 1376) <= (2450 - 1451))) then
			local v216 = v139();
			if (v216 or ((2922 + 488) > (8820 - 4704))) then
				return v216;
			end
			local v216 = v140();
			if (v216 or ((723 + 180) >= (208 + 2851))) then
				return v216;
			end
		end
		if (not v14:IsChanneling() or ((2500 + 1476) < (4158 - (384 + 917)))) then
			if (((5627 - (128 + 569)) > (3850 - (1407 + 136))) and v14:AffectingCombat()) then
				local v218 = v141();
				if (v218 or ((5933 - (687 + 1200)) < (3001 - (556 + 1154)))) then
					return v218;
				end
			elseif (v30 or ((14920 - 10679) == (3640 - (9 + 86)))) then
				local v233 = 421 - (275 + 146);
				local v234;
				while true do
					if ((v233 == (0 + 0)) or ((4112 - (29 + 35)) > (18755 - 14523))) then
						v234 = v142();
						if (v234 or ((5227 - 3477) >= (15331 - 11858))) then
							return v234;
						end
						break;
					end
				end
			end
		end
	end
	local function v146()
		local v204 = 0 + 0;
		while true do
			if (((4178 - (53 + 959)) == (3574 - (312 + 96))) and (v204 == (0 - 0))) then
				v23.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
				v204 = 286 - (147 + 138);
			end
			if (((2662 - (813 + 86)) < (3366 + 358)) and (v204 == (1 - 0))) then
				v120();
				break;
			end
		end
	end
	v23.SetAPL(597 - (18 + 474), v145, v146);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

