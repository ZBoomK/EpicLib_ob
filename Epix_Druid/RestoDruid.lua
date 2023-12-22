local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1994 + 160) >= (1929 + 1396))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((2884 - 1589) >= (7545 - 4312))) then
			v6 = v0[v4];
			if (((5088 - (530 + 181)) > (2523 - (614 + 267))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 33 - (19 + 13);
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
	local v99 = v23.Commons.Everyone;
	local v100 = v19.Druid.Restoration;
	local v101 = v21.Druid.Restoration;
	local v102 = {};
	local v103 = v26.Druid.Restoration;
	local v104 = 0 - 0;
	local v105, v106;
	local v107 = 25892 - 14781;
	local v108 = 31739 - 20628;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v14:GetEquipment();
	local v117 = (v116[4 + 9] and v21(v116[22 - 9])) or v21(0 - 0);
	local v118 = (v116[1826 - (1293 + 519)] and v21(v116[28 - 14])) or v21(0 - 0);
	v10:RegisterForEvent(function()
		local v145 = 0 - 0;
		while true do
			if (((20366 - 15643) > (3194 - 1838)) and (v145 == (0 + 0))) then
				v116 = v14:GetEquipment();
				v117 = (v116[3 + 10] and v21(v116[29 - 16])) or v21(0 + 0);
				v145 = 1 + 0;
			end
			if ((v145 == (1 + 0)) or ((5232 - (709 + 387)) <= (5291 - (673 + 1185)))) then
				v118 = (v116[40 - 26] and v21(v116[44 - 30])) or v21(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v146 = 0 + 0;
		while true do
			if (((3172 + 1073) <= (6252 - 1621)) and (v146 == (0 + 0))) then
				v107 = 22154 - 11043;
				v108 = 21810 - 10699;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (((6156 - (446 + 1434)) >= (5197 - (1040 + 243))) and v100.ImprovedNaturesCure:IsAvailable()) then
			v99.DispellableDebuffs = v12.MergeTable(v99.DispellableMagicDebuffs, v99.DispellableDiseaseDebuffs);
			v99.DispellableDebuffs = v12.MergeTable(v99.DispellableDebuffs, v99.DispellableCurseDebuffs);
		else
			v99.DispellableDebuffs = v99.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v119();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v120()
		return (v14:StealthUp(true, true) and (2.6 - 1)) or (1848 - (559 + 1288));
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		local v147 = 1931 - (609 + 1322);
		while true do
			if (((652 - (13 + 441)) <= (16311 - 11946)) and (v147 == (7 - 4))) then
				v115 = not v109 and (v100.Wrath:Count() > (0 - 0)) and (v100.Starfire:Count() > (0 + 0));
				break;
			end
			if (((17367 - 12585) > (1661 + 3015)) and (v147 == (1 + 1))) then
				v113 = (not v109 and (((v100.Starfire:Count() == (0 - 0)) and (v100.Wrath:Count() > (0 + 0))) or v14:IsCasting(v100.Wrath))) or v112;
				v114 = (not v109 and (((v100.Wrath:Count() == (0 - 0)) and (v100.Starfire:Count() > (0 + 0))) or v14:IsCasting(v100.Starfire))) or v111;
				v147 = 2 + 1;
			end
			if (((3495 + 1369) > (1845 + 352)) and (v147 == (1 + 0))) then
				v111 = v14:BuffUp(v100.EclipseLunar) and v14:BuffDown(v100.EclipseSolar);
				v112 = v14:BuffUp(v100.EclipseSolar) and v14:BuffDown(v100.EclipseLunar);
				v147 = 435 - (153 + 280);
			end
			if ((v147 == (0 - 0)) or ((3322 + 378) == (990 + 1517))) then
				v109 = v14:BuffUp(v100.EclipseSolar) or v14:BuffUp(v100.EclipseLunar);
				v110 = v14:BuffUp(v100.EclipseSolar) and v14:BuffUp(v100.EclipseLunar);
				v147 = 1 + 0;
			end
		end
	end
	local function v122(v148)
		return v148:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (5 + 0));
	end
	local function v123(v149)
		return (v149:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (9 + 3)) and ((((v106 <= (5 - 1)) or (v14:Energy() < (31 + 19))) and v14:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (671 - (89 + 578))) or (v14:Energy() < (36 + 14))) and v14:BuffUp(v100.HeartOfTheWild))) and v149:DebuffDown(v100.MoonfireDebuff)) or (v14:PrevGCD(1 - 0, v100.Sunfire) and ((v149:DebuffUp(v100.MoonfireDebuff) and (v149:DebuffRemains(v100.MoonfireDebuff) < (v149:DebuffDuration(v100.MoonfireDebuff) * (1049.8 - (572 + 477))))) or v149:DebuffDown(v100.MoonfireDebuff)) and (v106 == (1 + 0)));
	end
	local function v124(v150)
		return v150:DebuffRefreshable(v100.MoonfireDebuff) and (v150:TimeToDie() > (4 + 1));
	end
	local function v125(v151)
		return ((v151:DebuffRefreshable(v100.Rip) or ((v14:Energy() > (11 + 79)) and (v151:DebuffRemains(v100.Rip) <= (96 - (84 + 2))))) and (((v14:ComboPoints() == (8 - 3)) and (v151:TimeToDie() > (v151:DebuffRemains(v100.Rip) + 18 + 6))) or (((v151:DebuffRemains(v100.Rip) + (v14:ComboPoints() * (846 - (497 + 345)))) < v151:TimeToDie()) and ((v151:DebuffRemains(v100.Rip) + 1 + 3 + (v14:ComboPoints() * (1 + 3))) > v151:TimeToDie())))) or (v151:DebuffDown(v100.Rip) and (v14:ComboPoints() > ((1335 - (605 + 728)) + (v106 * (2 + 0)))));
	end
	local function v126(v152)
		return (v152:DebuffDown(v100.RakeDebuff) or v152:DebuffRefreshable(v100.RakeDebuff)) and (v152:TimeToDie() > (22 - 12)) and (v14:ComboPoints() < (1 + 4));
	end
	local function v127(v153)
		return (v153:DebuffUp(v100.AdaptiveSwarmDebuff));
	end
	local function v128()
		return v99.FriendlyUnitsWithBuffCount(v100.Rejuvenation) + v99.FriendlyUnitsWithBuffCount(v100.Regrowth) + v99.FriendlyUnitsWithBuffCount(v100.Wildgrowth);
	end
	local function v129()
		return v99.FriendlyUnitsWithoutBuffCount(v100.Rejuvenation);
	end
	local function v130(v154)
		return v154:BuffUp(v100.Rejuvenation) or v154:BuffUp(v100.Regrowth) or v154:BuffUp(v100.Wildgrowth);
	end
	local function v131()
		local v155 = 0 - 0;
		while true do
			if (((4034 + 440) >= (759 - 485)) and (v155 == (0 + 0))) then
				ShouldReturn = v99.HandleTopTrinket(v102, v32 and (v14:BuffUp(v100.HeartOfTheWild) or v14:BuffUp(v100.IncarnationBuff)), 529 - (457 + 32), nil);
				if (ShouldReturn or ((804 + 1090) <= (2808 - (832 + 570)))) then
					return ShouldReturn;
				end
				v155 = 1 + 0;
			end
			if (((410 + 1162) >= (5417 - 3886)) and ((1 + 0) == v155)) then
				ShouldReturn = v99.HandleBottomTrinket(v102, v32 and (v14:BuffUp(v100.HeartOfTheWild) or v14:BuffUp(v100.IncarnationBuff)), 836 - (588 + 208), nil);
				if (ShouldReturn or ((12632 - 7945) < (6342 - (884 + 916)))) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v132()
		local v156 = 0 - 0;
		while true do
			if (((1909 + 1382) > (2320 - (232 + 421))) and ((1890 - (1569 + 320)) == v156)) then
				if ((v52 and v32 and v100.ConvokeTheSpirits:IsCastable()) or ((215 + 658) == (387 + 1647))) then
					if (v14:BuffUp(v100.CatForm) or ((9489 - 6673) < (616 - (316 + 289)))) then
						if (((9682 - 5983) < (218 + 4488)) and (v14:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (1513 - (666 + 787))) or not v100.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (475 - (360 + 65))) and (((v14:ComboPoints() < (5 + 0)) and (v16:DebuffRemains(v100.Rip) > (259 - (79 + 175)))) or (v106 > (1 - 0)))) then
							if (((2065 + 581) >= (2684 - 1808)) and v25(v100.ConvokeTheSpirits, not v16:IsInRange(57 - 27))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if (((1513 - (503 + 396)) <= (3365 - (92 + 89))) and v100.Sunfire:IsReady() and v14:BuffDown(v100.CatForm) and (v16:TimeToDie() > (9 - 4)) and (not v100.Rip:IsAvailable() or v16:DebuffUp(v100.Rip) or (v14:Energy() < (16 + 14)))) then
					if (((1851 + 1275) == (12241 - 9115)) and v99.CastCycle(v100.Sunfire, v105, v122, not v16:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
						return "sunfire cat 20";
					end
				end
				if ((v100.Moonfire:IsReady() and v14:BuffDown(v100.CatForm) and (v16:TimeToDie() > (1 + 4)) and (not v100.Rip:IsAvailable() or v16:DebuffUp(v100.Rip) or (v14:Energy() < (68 - 38)))) or ((1909 + 278) >= (2367 + 2587))) then
					if (v99.CastCycle(v100.Moonfire, v105, v123, not v16:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((11808 - 7931) == (447 + 3128))) then
						return "moonfire cat 22";
					end
				end
				v156 = 2 - 0;
			end
			if (((1951 - (485 + 759)) > (1462 - 830)) and (v156 == (1191 - (442 + 747)))) then
				if ((v100.Sunfire:IsReady() and v16:DebuffDown(v100.SunfireDebuff) and (v16:TimeToDie() > (1140 - (832 + 303)))) or ((1492 - (88 + 858)) >= (819 + 1865))) then
					if (((1213 + 252) <= (178 + 4123)) and v25(v100.Sunfire, not v16:IsSpellInRange(v100.Sunfire))) then
						return "sunfire cat 24";
					end
				end
				if (((2493 - (766 + 23)) > (7034 - 5609)) and v100.Moonfire:IsReady() and v14:BuffDown(v100.CatForm) and v16:DebuffDown(v100.MoonfireDebuff) and (v16:TimeToDie() > (6 - 1))) then
					if (v25(v100.Moonfire, not v16:IsSpellInRange(v100.Moonfire)) or ((1809 - 1122) == (14370 - 10136))) then
						return "moonfire cat 24";
					end
				end
				if ((v100.Starsurge:IsReady() and (v14:BuffDown(v100.CatForm))) or ((4403 - (1036 + 37)) < (1014 + 415))) then
					if (((2233 - 1086) >= (264 + 71)) and v25(v100.Starsurge, not v16:IsSpellInRange(v100.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				v156 = 1483 - (641 + 839);
			end
			if (((4348 - (910 + 3)) > (5345 - 3248)) and (v156 == (1687 - (1466 + 218)))) then
				if ((v100.HeartOfTheWild:IsCastable() and v32 and ((v100.ConvokeTheSpirits:CooldownRemains() < (14 + 16)) or not v100.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v100.HeartOfTheWild) and v16:DebuffUp(v100.SunfireDebuff) and (v16:DebuffUp(v100.MoonfireDebuff) or (v106 > (1152 - (556 + 592))))) or ((1341 + 2429) >= (4849 - (329 + 479)))) then
					if (v25(v100.HeartOfTheWild) or ((4645 - (174 + 680)) <= (5535 - 3924))) then
						return "heart_of_the_wild cat 26";
					end
				end
				if ((v100.CatForm:IsReady() and v14:BuffDown(v100.CatForm) and (v14:Energy() >= (62 - 32)) and v36) or ((3269 + 1309) <= (2747 - (396 + 343)))) then
					if (((100 + 1025) <= (3553 - (29 + 1448))) and v25(v100.CatForm)) then
						return "cat_form cat 28";
					end
				end
				if ((v100.FerociousBite:IsReady() and (((v14:ComboPoints() > (1392 - (135 + 1254))) and (v16:TimeToDie() < (37 - 27))) or ((v14:ComboPoints() == (23 - 18)) and (v14:Energy() >= (17 + 8)) and (not v100.Rip:IsAvailable() or (v16:DebuffRemains(v100.Rip) > (1532 - (389 + 1138))))))) or ((1317 - (102 + 472)) >= (4152 + 247))) then
					if (((641 + 514) < (1560 + 113)) and v25(v100.FerociousBite, not v16:IsInMeleeRange(1550 - (320 + 1225)))) then
						return "ferocious_bite cat 32";
					end
				end
				v156 = 6 - 2;
			end
			if ((v156 == (4 + 1)) or ((3788 - (157 + 1307)) <= (2437 - (821 + 1038)))) then
				if (((9398 - 5631) == (412 + 3355)) and v100.Rake:IsReady() and ((v14:ComboPoints() < (8 - 3)) or (v14:Energy() > (34 + 56))) and (v16:PMultiplier(v100.Rake) <= v14:PMultiplier(v100.Rake)) and v127(v16)) then
					if (((10134 - 6045) == (5115 - (834 + 192))) and v25(v100.Rake, not v16:IsInMeleeRange(1 + 4))) then
						return "rake cat 40";
					end
				end
				if (((1145 + 3313) >= (36 + 1638)) and v100.Swipe:IsReady() and (v106 >= (2 - 0))) then
					if (((1276 - (300 + 4)) <= (379 + 1039)) and v25(v100.Swipe, not v16:IsInMeleeRange(20 - 12))) then
						return "swipe cat 38";
					end
				end
				if ((v100.Shred:IsReady() and ((v14:ComboPoints() < (367 - (112 + 250))) or (v14:Energy() > (36 + 54)))) or ((12370 - 7432) < (2729 + 2033))) then
					if (v25(v100.Shred, not v16:IsInMeleeRange(3 + 2)) or ((1873 + 631) > (2115 + 2149))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if (((1600 + 553) == (3567 - (1001 + 413))) and (v156 == (8 - 4))) then
				if ((v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (893 - (244 + 638))) and v125(v16)) or ((1200 - (627 + 66)) >= (7720 - 5129))) then
					if (((5083 - (512 + 90)) == (6387 - (1665 + 241))) and v25(v100.Rip, not v16:IsInMeleeRange(722 - (373 + 344)))) then
						return "rip cat 34";
					end
				end
				if ((v100.Thrash:IsReady() and (v106 >= (1 + 1)) and v16:DebuffRefreshable(v100.ThrashDebuff)) or ((616 + 1712) < (1827 - 1134))) then
					if (((7323 - 2995) == (5427 - (35 + 1064))) and v25(v100.Thrash, not v16:IsInMeleeRange(6 + 2))) then
						return "thrash cat";
					end
				end
				if (((3397 - 1809) >= (6 + 1326)) and v100.Rake:IsReady() and v126(v16)) then
					if (v25(v100.Rake, not v16:IsInMeleeRange(1241 - (298 + 938))) or ((5433 - (233 + 1026)) > (5914 - (636 + 1030)))) then
						return "rake cat 36";
					end
				end
				v156 = 3 + 2;
			end
			if ((v156 == (0 + 0)) or ((1363 + 3223) <= (6 + 76))) then
				if (((4084 - (55 + 166)) == (749 + 3114)) and v100.Rake:IsReady() and (v14:StealthUp(false, true))) then
					if (v25(v100.Rake, not v16:IsInMeleeRange(2 + 8)) or ((1076 - 794) <= (339 - (36 + 261)))) then
						return "rake cat 2";
					end
				end
				if (((8059 - 3450) >= (2134 - (34 + 1334))) and UseTrinkets and not v14:StealthUp(false, true)) then
					local v224 = 0 + 0;
					local v225;
					while true do
						if ((v224 == (0 + 0)) or ((2435 - (1035 + 248)) == (2509 - (20 + 1)))) then
							v225 = v131();
							if (((1783 + 1639) > (3669 - (134 + 185))) and v225) then
								return v225;
							end
							break;
						end
					end
				end
				if (((2010 - (549 + 584)) > (1061 - (314 + 371))) and v100.AdaptiveSwarm:IsCastable()) then
					if (v25(v100.AdaptiveSwarm, not v16:IsSpellInRange(v100.AdaptiveSwarm)) or ((10703 - 7585) <= (2819 - (478 + 490)))) then
						return "adaptive_swarm cat";
					end
				end
				v156 = 1 + 0;
			end
		end
	end
	local function v133()
		local v157 = 1172 - (786 + 386);
		while true do
			if ((v157 == (9 - 6)) or ((1544 - (1055 + 324)) >= (4832 - (1093 + 247)))) then
				if (((3510 + 439) < (511 + 4345)) and v100.Wrath:IsReady() and (v14:BuffDown(v100.CatForm) or not v16:IsInMeleeRange(31 - 23)) and ((v112 and (v106 == (3 - 2))) or v113 or (v115 and (v106 > (2 - 1))))) then
					if (v25(v100.Wrath, not v16:IsSpellInRange(v100.Wrath), true) or ((10745 - 6469) < (1073 + 1943))) then
						return "wrath owl 14";
					end
				end
				if (((18067 - 13377) > (14217 - 10092)) and v100.Starfire:IsReady()) then
					if (v25(v100.Starfire, not v16:IsSpellInRange(v100.Starfire), true) or ((38 + 12) >= (2291 - 1395))) then
						return "starfire owl 16";
					end
				end
				break;
			end
			if ((v157 == (689 - (364 + 324))) or ((4698 - 2984) >= (7097 - 4139))) then
				if ((v100.Starsurge:IsReady() and ((v106 < (2 + 4)) or (not v111 and (v106 < (33 - 25)))) and v36) or ((2387 - 896) < (1955 - 1311))) then
					if (((1972 - (1249 + 19)) < (891 + 96)) and v25(v100.Starsurge, not v16:IsSpellInRange(v100.Starsurge))) then
						return "starsurge owl 8";
					end
				end
				if (((14472 - 10754) > (2992 - (686 + 400))) and v100.Moonfire:IsReady() and ((v106 < (4 + 1)) or (not v111 and (v106 < (236 - (73 + 156)))))) then
					if (v99.CastCycle(v100.Moonfire, v105, v124, not v16:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((5 + 953) > (4446 - (721 + 90)))) then
						return "moonfire owl 10";
					end
				end
				v157 = 1 + 1;
			end
			if (((11367 - 7866) <= (4962 - (224 + 246))) and (v157 == (2 - 0))) then
				if (v100.Sunfire:IsReady() or ((6337 - 2895) < (463 + 2085))) then
					if (((69 + 2806) >= (1076 + 388)) and v99.CastCycle(v100.Sunfire, v105, v122, not v16:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
						return "sunfire owl 12";
					end
				end
				if ((v52 and v32 and v100.ConvokeTheSpirits:IsCastable()) or ((9536 - 4739) >= (16282 - 11389))) then
					if (v14:BuffUp(v100.MoonkinForm) or ((1064 - (203 + 310)) > (4061 - (1238 + 755)))) then
						if (((148 + 1966) > (2478 - (709 + 825))) and v25(v100.ConvokeTheSpirits, not v16:IsInRange(55 - 25))) then
							return "convoke_the_spirits moonkin 18";
						end
					end
				end
				v157 = 3 - 0;
			end
			if ((v157 == (864 - (196 + 668))) or ((8930 - 6668) >= (6413 - 3317))) then
				if ((v100.HeartOfTheWild:IsCastable() and v32 and ((v100.ConvokeTheSpirits:CooldownRemains() < (863 - (171 + 662))) or (v100.ConvokeTheSpirits:CooldownRemains() > (183 - (4 + 89))) or not v100.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v100.HeartOfTheWild)) or ((7903 - 5648) >= (1288 + 2249))) then
					if (v25(v100.HeartOfTheWild) or ((16852 - 13015) < (513 + 793))) then
						return "heart_of_the_wild owl 2";
					end
				end
				if (((4436 - (35 + 1451)) == (4403 - (28 + 1425))) and v100.MoonkinForm:IsReady() and (v14:BuffDown(v100.MoonkinForm)) and v36) then
					if (v25(v100.MoonkinForm) or ((6716 - (941 + 1052)) < (3163 + 135))) then
						return "moonkin_form owl 4";
					end
				end
				v157 = 1515 - (822 + 692);
			end
		end
	end
	local function v134()
		ShouldReturn = v99.InterruptWithStun(v100.IncapacitatingRoar, 11 - 3);
		if (((536 + 600) >= (451 - (45 + 252))) and ShouldReturn) then
			return ShouldReturn;
		end
		if ((v14:BuffUp(v100.CatForm) and (v14:ComboPoints() > (0 + 0))) or ((94 + 177) > (11555 - 6807))) then
			ShouldReturn = v99.InterruptWithStun(v100.Maim, 441 - (114 + 319));
			if (((6805 - 2065) >= (4038 - 886)) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		ShouldReturn = v99.InterruptWithStun(v100.MightyBash, 6 + 2);
		if (ShouldReturn or ((3840 - 1262) >= (7102 - 3712))) then
			return ShouldReturn;
		end
		v121();
		local v158 = 1963 - (556 + 1407);
		if (((1247 - (741 + 465)) <= (2126 - (170 + 295))) and v100.Rip:IsAvailable()) then
			v158 = v158 + 1 + 0;
		end
		if (((553 + 48) < (8764 - 5204)) and v100.Rake:IsAvailable()) then
			v158 = v158 + 1 + 0;
		end
		if (((151 + 84) < (390 + 297)) and v100.Thrash:IsAvailable()) then
			v158 = v158 + (1231 - (957 + 273));
		end
		if (((1217 + 3332) > (462 + 691)) and (v158 >= (7 - 5)) and v16:IsInMeleeRange(21 - 13)) then
			local v193 = 0 - 0;
			local v194;
			while true do
				if ((v193 == (0 - 0)) or ((6454 - (389 + 1391)) < (2932 + 1740))) then
					v194 = v132();
					if (((382 + 3286) < (10383 - 5822)) and v194) then
						return v194;
					end
					break;
				end
			end
		end
		if (v100.AdaptiveSwarm:IsCastable() or ((1406 - (783 + 168)) == (12098 - 8493))) then
			if (v25(v100.AdaptiveSwarm, not v16:IsSpellInRange(v100.AdaptiveSwarm)) or ((2620 + 43) == (3623 - (309 + 2)))) then
				return "adaptive_swarm main";
			end
		end
		if (((13133 - 8856) <= (5687 - (1090 + 122))) and v100.MoonkinForm:IsAvailable()) then
			local v195 = 0 + 0;
			local v196;
			while true do
				if ((v195 == (0 - 0)) or ((596 + 274) == (2307 - (628 + 490)))) then
					v196 = v133();
					if (((279 + 1274) <= (7756 - 4623)) and v196) then
						return v196;
					end
					break;
				end
			end
		end
		if ((v100.Sunfire:IsReady() and (v16:DebuffRefreshable(v100.SunfireDebuff))) or ((10223 - 7986) >= (4285 - (431 + 343)))) then
			if (v25(v100.Sunfire, not v16:IsSpellInRange(v100.Sunfire)) or ((2673 - 1349) > (8736 - 5716))) then
				return "sunfire main 24";
			end
		end
		if ((v100.Moonfire:IsReady() and (v16:DebuffRefreshable(v100.MoonfireDebuff))) or ((2364 + 628) == (241 + 1640))) then
			if (((4801 - (556 + 1139)) > (1541 - (6 + 9))) and v25(v100.Moonfire, not v16:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if (((554 + 2469) < (1983 + 1887)) and v100.Starsurge:IsReady() and (v14:BuffDown(v100.CatForm))) then
			if (((312 - (28 + 141)) > (29 + 45)) and v25(v100.Starsurge, not v16:IsSpellInRange(v100.Starsurge))) then
				return "starsurge main 28";
			end
		end
		if (((21 - 3) < (1496 + 616)) and v100.Starfire:IsReady() and (v106 > (1319 - (486 + 831)))) then
			if (((2854 - 1757) <= (5731 - 4103)) and v25(v100.Starfire, not v16:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
		if (((875 + 3755) == (14639 - 10009)) and v100.Wrath:IsReady() and (v14:BuffDown(v100.CatForm) or not v16:IsInMeleeRange(1271 - (668 + 595)))) then
			if (((3186 + 354) > (541 + 2142)) and v25(v100.Wrath, not v16:IsSpellInRange(v100.Wrath), true)) then
				return "wrath main 30";
			end
		end
		if (((13073 - 8279) >= (3565 - (23 + 267))) and v100.Moonfire:IsReady() and (v14:BuffDown(v100.CatForm) or not v16:IsInMeleeRange(1952 - (1129 + 815)))) then
			if (((1871 - (371 + 16)) == (3234 - (1326 + 424))) and v25(v100.Moonfire, not v16:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (((2711 - 1279) < (12990 - 9435)) and true) then
			if (v25(v100.Pool) or ((1183 - (88 + 30)) > (4349 - (720 + 51)))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v135()
		if ((v17 and v99.DispellableFriendlyUnit() and v100.NaturesCure:IsReady()) or ((10666 - 5871) < (3183 - (421 + 1355)))) then
			if (((3056 - 1203) < (2365 + 2448)) and v25(v103.NaturesCureFocus)) then
				return "natures_cure dispel 2";
			end
		end
	end
	local function v136()
		local v159 = 1083 - (286 + 797);
		while true do
			if ((v159 == (3 - 2)) or ((4672 - 1851) < (2870 - (397 + 42)))) then
				if ((v101.Healthstone:IsReady() and v45 and (v14:HealthPercentage() <= v46)) or ((898 + 1976) < (2981 - (24 + 776)))) then
					if (v25(v103.Healthstone, nil, nil, true) or ((4142 - 1453) <= (1128 - (222 + 563)))) then
						return "healthstone defensive 3";
					end
				end
				if ((v39 and (v14:HealthPercentage() <= v41)) or ((4117 - 2248) == (1447 + 562))) then
					if ((v40 == "Refreshing Healing Potion") or ((3736 - (23 + 167)) < (4120 - (690 + 1108)))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((752 + 1330) == (3937 + 836))) then
							if (((4092 - (40 + 808)) > (174 + 881)) and v25(v103.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v159 == (0 - 0)) or ((3167 + 146) <= (941 + 837))) then
				if (((v14:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) or ((780 + 641) >= (2675 - (47 + 524)))) then
					if (((1176 + 636) <= (8881 - 5632)) and v25(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((2426 - 803) <= (4462 - 2505)) and (v14:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) then
					if (((6138 - (1165 + 561)) == (132 + 4280)) and v25(v100.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v159 = 3 - 2;
			end
		end
	end
	local function v137()
		local v160 = 0 + 0;
		while true do
			if (((2229 - (341 + 138)) >= (228 + 614)) and (v160 == (1 - 0))) then
				if (((4698 - (89 + 237)) > (5951 - 4101)) and v100.Swiftmend:IsReady() and v130(v17)) then
					if (((487 - 255) < (1702 - (581 + 300))) and v25(v103.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				if (((1738 - (855 + 365)) < (2142 - 1240)) and v14:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) then
					if (((978 + 2016) > (2093 - (1030 + 205))) and v25(v103.WildgrowthFocus, nil, true)) then
						return "wildgrowth ramp";
					end
				end
				v160 = 2 + 0;
			end
			if (((0 + 0) == v160) or ((4041 - (156 + 130)) <= (2079 - 1164))) then
				if (((6650 - 2704) > (7665 - 3922)) and (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(11 + 29))) then
					return;
				end
				if ((v100.Swiftmend:IsReady() and not v130(v17) and v14:BuffDown(v100.SoulOfTheForestBuff)) or ((779 + 556) >= (3375 - (10 + 59)))) then
					if (((1370 + 3474) > (11095 - 8842)) and v25(v103.RejuvenationFocus)) then
						return "rejuvenation ramp";
					end
				end
				v160 = 1164 - (671 + 492);
			end
			if (((360 + 92) == (1667 - (369 + 846))) and ((1 + 1) == v160)) then
				if ((v100.Innervate:IsReady() and v14:BuffDown(v100.Innervate)) or ((3889 + 668) < (4032 - (1036 + 909)))) then
					if (((3081 + 793) == (6503 - 2629)) and v25(v103.InnervatePlayer, nil, nil, true)) then
						return "innervate ramp";
					end
				end
				if ((v14:BuffUp(v100.Innervate) and (v129() > (203 - (11 + 192))) and v18 and v18:Exists() and v18:BuffRefreshable(v100.Rejuvenation)) or ((980 + 958) > (5110 - (135 + 40)))) then
					if (v25(v103.RejuvenationMouseover) or ((10309 - 6054) < (2064 + 1359))) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
		end
	end
	local function v138()
		local v161 = 0 - 0;
		while true do
			if (((2179 - 725) <= (2667 - (50 + 126))) and (v161 == (0 - 0))) then
				if (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(9 + 31) or ((5570 - (1233 + 180)) <= (3772 - (522 + 447)))) then
					return;
				end
				if (((6274 - (107 + 1314)) >= (1384 + 1598)) and v37) then
					if (((12596 - 8462) > (1426 + 1931)) and UseTrinkets) then
						local v236 = v131();
						if (v236 or ((6785 - 3368) < (10026 - 7492))) then
							return v236;
						end
					end
					if ((v53 and v32 and v14:AffectingCombat() and (v128() > (1913 - (716 + 1194))) and v100.NaturesVigil:IsReady()) or ((47 + 2675) <= (18 + 146))) then
						if (v25(v100.NaturesVigil, nil, nil, true) or ((2911 - (74 + 429)) < (4067 - 1958))) then
							return "natures_vigil healing";
						end
					end
					if ((v100.Swiftmend:IsReady() and v81 and v14:BuffDown(v100.SoulOfTheForestBuff) and v130(v17) and (v17:HealthPercentage() <= v82)) or ((17 + 16) == (3330 - 1875))) then
						if (v25(v103.SwiftmendFocus) or ((314 + 129) >= (12377 - 8362))) then
							return "swiftmend healing";
						end
					end
					if (((8361 - 4979) > (599 - (279 + 154))) and v14:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91)) then
						if (v25(v103.WildgrowthFocus, nil, true) or ((1058 - (454 + 324)) == (2407 + 652))) then
							return "wildgrowth_sotf healing";
						end
					end
					if (((1898 - (12 + 5)) > (698 + 595)) and v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (12 - 7)) and v99.AreUnitsBelowHealthPercentage(v57, v58)) then
						if (((871 + 1486) == (3450 - (277 + 816))) and v25(v103.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if (((525 - 402) == (1306 - (1058 + 125))) and v14:AffectingCombat() and v32 and v100.Flourish:IsReady() and v14:BuffDown(v100.Flourish) and (v128() > (1 + 3)) and v99.AreUnitsBelowHealthPercentage(v65, v66)) then
						if (v25(v100.Flourish, nil, nil, true) or ((2031 - (815 + 160)) >= (14553 - 11161))) then
							return "flourish healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85)) or ((2565 - 1484) < (257 + 818))) then
						if (v25(v100.Tranquility, nil, true) or ((3066 - 2017) >= (6330 - (41 + 1857)))) then
							return "tranquility healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v100.Tranquility:IsReady() and v14:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88)) or ((6661 - (1222 + 671)) <= (2186 - 1340))) then
						if (v25(v100.Tranquility, nil, true) or ((4826 - 1468) <= (2602 - (229 + 953)))) then
							return "tranquility_tree healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63)) or ((5513 - (1111 + 663)) <= (4584 - (874 + 705)))) then
						if (v25(v100.ConvokeTheSpirits) or ((233 + 1426) >= (1456 + 678))) then
							return "convoke_the_spirits healing";
						end
					end
					if ((v100.CenarionWard:IsReady() and v59 and (v17:HealthPercentage() <= v60)) or ((6776 - 3516) < (67 + 2288))) then
						if (v25(v103.CenarionWardFocus) or ((1348 - (642 + 37)) == (963 + 3260))) then
							return "cenarion_ward healing";
						end
					end
					if ((v14:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) or ((271 + 1421) < (1475 - 887))) then
						if (v25(v103.RegrowthFocus) or ((5251 - (233 + 221)) < (8442 - 4791))) then
							return "regrowth_swiftness healing";
						end
					end
					if ((v100.NaturesSwiftness:IsReady() and v73 and (v17:HealthPercentage() <= v74)) or ((3677 + 500) > (6391 - (718 + 823)))) then
						if (v25(v100.NaturesSwiftness) or ((252 + 148) > (1916 - (266 + 539)))) then
							return "natures_swiftness healing";
						end
					end
					if (((8637 - 5586) > (2230 - (636 + 589))) and (v67 == "Anyone")) then
						if (((8765 - 5072) <= (9037 - 4655)) and v100.IronBark:IsReady() and (v17:HealthPercentage() <= v68)) then
							if (v25(v103.IronBarkFocus) or ((2601 + 681) > (1490 + 2610))) then
								return "iron_bark healing";
							end
						end
					elseif ((v67 == "Tank Only") or ((4595 - (657 + 358)) < (7529 - 4685))) then
						if (((202 - 113) < (5677 - (1151 + 36))) and v100.IronBark:IsReady() and (v17:HealthPercentage() <= v68) and (v22.UnitGroupRole(v17) == "TANK")) then
							if (v25(v103.IronBarkFocus) or ((4813 + 170) < (476 + 1332))) then
								return "iron_bark healing";
							end
						end
					elseif (((11434 - 7605) > (5601 - (1552 + 280))) and (v67 == "Tank and Self")) then
						if (((2319 - (64 + 770)) <= (1972 + 932)) and v100.IronBark:IsReady() and (v17:HealthPercentage() <= v68) and ((v22.UnitGroupRole(v17) == "TANK") or (v22.UnitGroupRole(v17) == "HEALER"))) then
							if (((9690 - 5421) == (758 + 3511)) and v25(v103.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					end
					if (((1630 - (157 + 1086)) <= (5567 - 2785)) and v100.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) then
						if (v25(v103.AdaptiveSwarmFocus) or ((8317 - 6418) <= (1406 - 489))) then
							return "adaptive_swarm healing";
						end
					end
					if ((v14:AffectingCombat() and v69 and (v99.UnitGroupRole(v17) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (1 - 0)) and (v17:HealthPercentage() <= (v70 - (v27(v14:BuffUp(v100.CatForm)) * (834 - (599 + 220))))) and v100.Lifebloom:IsCastable() and v17:BuffRefreshable(v100.Lifebloom)) or ((8586 - 4274) <= (2807 - (1813 + 118)))) then
						if (((1632 + 600) <= (3813 - (841 + 376))) and v25(v103.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					if (((2935 - 840) < (857 + 2829)) and v14:AffectingCombat() and v71 and (v99.UnitGroupRole(v17) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (2 - 1)) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v17:HealthPercentage() <= (v72 - (v27(v14:BuffUp(v100.CatForm)) * (874 - (464 + 395))))) and v100.Lifebloom:IsCastable() and v17:BuffRefreshable(v100.Lifebloom)) then
						if (v25(v103.LifebloomFocus) or ((4093 - 2498) >= (2149 + 2325))) then
							return "lifebloom healing";
						end
					end
					if ((v54 == "Player") or ((5456 - (467 + 370)) < (5955 - 3073))) then
						if ((v14:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (12 + 3))) or ((1007 - 713) >= (754 + 4077))) then
							if (((4720 - 2691) <= (3604 - (150 + 370))) and v25(v103.EfflorescencePlayer)) then
								return "efflorescence healing player";
							end
						end
					elseif ((v54 == "Cursor") or ((3319 - (74 + 1208)) == (5952 - 3532))) then
						if (((21142 - 16684) > (2778 + 1126)) and v14:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (405 - (14 + 376)))) then
							if (((756 - 320) >= (80 + 43)) and v25(v103.EfflorescenceCursor)) then
								return "efflorescence healing cursor";
							end
						end
					elseif (((440 + 60) < (1732 + 84)) and (v54 == "Confirmation")) then
						if (((10472 - 6898) == (2689 + 885)) and v14:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (93 - (23 + 55)))) then
							if (((523 - 302) < (261 + 129)) and v25(v100.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) or ((1988 + 225) <= (2203 - 782))) then
						if (((962 + 2096) < (5761 - (652 + 249))) and v25(v103.WildgrowthFocus, nil, true)) then
							return "wildgrowth healing";
						end
					end
					if ((v100.Regrowth:IsCastable() and v75 and (v17:HealthPercentage() <= v76)) or ((3468 - 2172) >= (6314 - (708 + 1160)))) then
						if (v25(v103.RegrowthFocus, nil, true) or ((3781 - 2388) > (8183 - 3694))) then
							return "regrowth healing";
						end
					end
					if ((v14:BuffUp(v100.Innervate) and (v129() > (27 - (10 + 17))) and v18 and v18:Exists() and v18:BuffRefreshable(v100.Rejuvenation)) or ((994 + 3430) < (1759 - (1400 + 332)))) then
						if (v25(v103.RejuvenationMouseover) or ((3829 - 1832) > (5723 - (242 + 1666)))) then
							return "rejuvenation_cycle healing";
						end
					end
					if (((1483 + 1982) > (702 + 1211)) and v100.Rejuvenation:IsCastable() and v79 and v17:BuffRefreshable(v100.Rejuvenation) and (v17:HealthPercentage() <= v80)) then
						if (((625 + 108) < (2759 - (850 + 90))) and v25(v103.RejuvenationFocus)) then
							return "rejuvenation healing";
						end
					end
					if ((v100.Regrowth:IsCastable() and v77 and v17:BuffUp(v100.Rejuvenation) and (v17:HealthPercentage() <= v78)) or ((7697 - 3302) == (6145 - (360 + 1030)))) then
						if (v25(v103.RegrowthFocus, nil, true) or ((3357 + 436) < (6686 - 4317))) then
							return "regrowth healing";
						end
					end
				end
				break;
			end
		end
	end
	local function v139()
		if (((v44 or v43) and v33) or ((5618 - 1534) == (1926 - (909 + 752)))) then
			local v197 = v135();
			if (((5581 - (109 + 1114)) == (7978 - 3620)) and v197) then
				return v197;
			end
		end
		local v162 = v136();
		if (v162 or ((1222 + 1916) < (1235 - (6 + 236)))) then
			return v162;
		end
		if (((2099 + 1231) > (1870 + 453)) and v34) then
			local v198 = v137();
			if (v198 or ((8551 - 4925) == (6967 - 2978))) then
				return v198;
			end
		end
		local v162 = v138();
		if (v162 or ((2049 - (1076 + 57)) == (440 + 2231))) then
			return v162;
		end
		if (((961 - (579 + 110)) == (22 + 250)) and v99.TargetIsValid() and v35) then
			local v199 = 0 + 0;
			while true do
				if (((2256 + 1993) <= (5246 - (174 + 233))) and (v199 == (0 - 0))) then
					v162 = v134();
					if (((4873 - 2096) < (1423 + 1777)) and v162) then
						return v162;
					end
					break;
				end
			end
		end
	end
	local function v140()
		local v163 = 1174 - (663 + 511);
		while true do
			if (((85 + 10) < (425 + 1532)) and (v163 == (0 - 0))) then
				if (((501 + 325) < (4042 - 2325)) and (v44 or v43) and v33) then
					local v226 = v135();
					if (((3451 - 2025) >= (528 + 577)) and v226) then
						return v226;
					end
				end
				if (((5359 - 2605) <= (2409 + 970)) and v30 and v37) then
					local v227 = 0 + 0;
					local v228;
					while true do
						if (((722 - (478 + 244)) == v227) or ((4444 - (440 + 77)) == (643 + 770))) then
							v228 = v138();
							if (v228 or ((4223 - 3069) <= (2344 - (655 + 901)))) then
								return v228;
							end
							break;
						end
					end
				end
				v163 = 1 + 0;
			end
			if ((v163 == (2 + 0)) or ((1110 + 533) > (13612 - 10233))) then
				if ((v99.TargetIsValid() and v35) or ((4248 - (695 + 750)) > (15533 - 10984))) then
					local v229 = 0 - 0;
					local v230;
					while true do
						if (((0 - 0) == v229) or ((571 - (285 + 66)) >= (7044 - 4022))) then
							v230 = v134();
							if (((4132 - (682 + 628)) == (455 + 2367)) and v230) then
								return v230;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v163 == (300 - (176 + 123))) or ((444 + 617) == (1348 + 509))) then
				if (((3029 - (239 + 30)) > (371 + 993)) and v42 and v100.MarkOfTheWild:IsCastable() and (v14:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) then
					if (v25(v103.MarkOfTheWildPlayer) or ((4712 + 190) <= (6362 - 2767))) then
						return "mark_of_the_wild";
					end
				end
				if (v99.TargetIsValid() or ((12017 - 8165) == (608 - (306 + 9)))) then
					if ((v100.Rake:IsReady() and (v14:StealthUp(false, true))) or ((5440 - 3881) == (798 + 3790))) then
						if (v25(v100.Rake, not v16:IsInMeleeRange(7 + 3)) or ((2159 + 2325) == (2253 - 1465))) then
							return "rake";
						end
					end
				end
				v163 = 1377 - (1140 + 235);
			end
		end
	end
	local function v141()
		v38 = EpicSettings.Settings['UseRacials'];
		v39 = EpicSettings.Settings['UseHealingPotion'];
		v40 = EpicSettings.Settings['HealingPotionName'] or "";
		v41 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v42 = EpicSettings.Settings['UseMarkOfTheWild'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v44 = EpicSettings.Settings['DispelBuffs'];
		v45 = EpicSettings.Settings['UseHealthstone'];
		v46 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v47 = EpicSettings.Settings['HandleCharredTreant'];
		v48 = EpicSettings.Settings['HandleCharredBrambles'];
		v49 = EpicSettings.Settings['InterruptWithStun'];
		v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v51 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v55 = EpicSettings.Settings['EfflorescenceHP'] or (52 - (33 + 19));
		v56 = EpicSettings.Settings['UseGroveGuardians'];
		v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
		v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
		v59 = EpicSettings.Settings['UseCenarionWard'];
		v60 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
		v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 - 0);
		v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
		v64 = EpicSettings.Settings['UseFlourish'];
		v65 = EpicSettings.Settings['FlourishHP'] or (689 - (586 + 103));
		v66 = EpicSettings.Settings['FlourishGroup'] or (0 + 0);
		v67 = EpicSettings.Settings['IronBarkUsage'] or "";
		v68 = EpicSettings.Settings['IronBarkHP'] or (0 - 0);
	end
	local function v142()
		local v180 = 1488 - (1309 + 179);
		while true do
			if (((8246 - 3678) >= (1701 + 2206)) and (v180 == (15 - 9))) then
				v93 = EpicSettings.Settings['WildgrowthHP'] or (0 + 0);
				v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v95 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v96 = EpicSettings.Settings['UseBarkskin'];
				v180 = 616 - (295 + 314);
			end
			if (((3060 - 1814) < (5432 - (1300 + 662))) and (v180 == (21 - 14))) then
				v97 = EpicSettings.Settings['RenewalHP'] or (1755 - (1178 + 577));
				v98 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((2113 + 1955) >= (2873 - 1901)) and (v180 == (1407 - (851 + 554)))) then
				v77 = EpicSettings.Settings['UseRegrowthRefresh'];
				v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 + 0);
				v79 = EpicSettings.Settings['UseRejuvenation'];
				v80 = EpicSettings.Settings['RejuvenationHP'] or (0 - 0);
				v180 = 6 - 3;
			end
			if (((795 - (115 + 187)) < (2982 + 911)) and (v180 == (1 + 0))) then
				v73 = EpicSettings.Settings['UseNaturesSwiftness'];
				v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
				v75 = EpicSettings.Settings['UseRegrowth'];
				v76 = EpicSettings.Settings['RegrowthHP'] or (1161 - (160 + 1001));
				v180 = 2 + 0;
			end
			if ((v180 == (4 + 1)) or ((3015 - 1542) >= (3690 - (237 + 121)))) then
				v89 = EpicSettings.Settings['UseWildgrowthSotF'];
				v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (897 - (525 + 372));
				v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
				v92 = EpicSettings.Settings['UseWildgrowth'];
				v180 = 19 - 13;
			end
			if (((142 - (96 + 46)) == v180) or ((4828 - (643 + 134)) <= (418 + 739))) then
				v69 = EpicSettings.Settings['UseLifebloomTank'];
				v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
				v71 = EpicSettings.Settings['UseLifebloom'];
				v72 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
				v180 = 1 + 0;
			end
			if (((1184 - 580) < (5889 - 3008)) and (v180 == (723 - (316 + 403)))) then
				v85 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
				v86 = EpicSettings.Settings['UseTranquilityTree'];
				v87 = EpicSettings.Settings['TranquilityTreeHP'] or (0 - 0);
				v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
				v180 = 12 - 7;
			end
			if ((v180 == (3 + 0)) or ((291 + 609) == (11700 - 8323))) then
				v81 = EpicSettings.Settings['UseSwiftmend'];
				v82 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
				v83 = EpicSettings.Settings['UseTranquility'];
				v84 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
				v180 = 1 + 3;
			end
		end
	end
	local function v143()
		v141();
		v142();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['ramp'];
		v35 = EpicSettings.Toggles['dps'];
		v36 = EpicSettings.Toggles['dpsform'];
		v37 = EpicSettings.Toggles['healing'];
		if (((8777 - 4318) > (29 + 562)) and v14:IsDeadOrGhost()) then
			return;
		end
		if (((9997 - 6599) >= (2412 - (12 + 5))) and (v14:AffectingCombat() or v43)) then
			local v200 = v43 and v100.NaturesCure:IsReady() and v33;
			if ((v99.IsTankBelowHealthPercentage(v68) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) or ((8478 - 6295) >= (6025 - 3201))) then
				local v221 = 0 - 0;
				local v222;
				while true do
					if (((4800 - 2864) == (393 + 1543)) and (v221 == (1973 - (1656 + 317)))) then
						v222 = v99.FocusUnit(v200, nil, nil, "TANK", 18 + 2);
						if (v222 or ((3873 + 959) < (11468 - 7155))) then
							return v222;
						end
						break;
					end
				end
			elseif (((20119 - 16031) > (4228 - (5 + 349))) and (v14:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) then
				local v231 = 0 - 0;
				local v232;
				while true do
					if (((5603 - (266 + 1005)) == (2855 + 1477)) and (v231 == (0 - 0))) then
						v232 = v99.FocusUnit(v200, nil, nil, "HEALER", 26 - 6);
						if (((5695 - (561 + 1135)) >= (3779 - 879)) and v232) then
							return v232;
						end
						break;
					end
				end
			else
				local v233 = v99.FocusUnit(v200, nil, nil, nil, 65 - 45);
				if (v233 or ((3591 - (507 + 559)) > (10197 - 6133))) then
					return v233;
				end
			end
		end
		if (((13518 - 9147) == (4759 - (212 + 176))) and v14:IsMounted()) then
			return;
		end
		if (v14:IsMoving() or ((1171 - (250 + 655)) > (13596 - 8610))) then
			v104 = GetTime();
		end
		if (((3478 - 1487) >= (1447 - 522)) and (v14:BuffUp(v100.TravelForm) or v14:BuffUp(v100.BearForm) or v14:BuffUp(v100.CatForm))) then
			if (((2411 - (1869 + 87)) < (7120 - 5067)) and ((GetTime() - v104) < (1902 - (484 + 1417)))) then
				return;
			end
		end
		if (v31 or ((1770 - 944) == (8129 - 3278))) then
			v105 = v16:GetEnemiesInSplashRange(781 - (48 + 725));
			v106 = #v105;
		else
			v105 = {};
			v106 = 1 - 0;
		end
		if (((490 - 307) == (107 + 76)) and (v99.TargetIsValid() or v14:AffectingCombat())) then
			local v201 = 0 - 0;
			while true do
				if (((325 + 834) <= (522 + 1266)) and (v201 == (854 - (152 + 701)))) then
					if ((v108 == (12422 - (430 + 881))) or ((1344 + 2163) > (5213 - (557 + 338)))) then
						v108 = v10.FightRemains(v105, false);
					end
					break;
				end
				if ((v201 == (0 + 0)) or ((8665 - 5590) <= (10382 - 7417))) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					v201 = 2 - 1;
				end
			end
		end
		if (((2941 - 1576) <= (2812 - (499 + 302))) and v47) then
			local v202 = 866 - (39 + 827);
			local v203;
			while true do
				if ((v202 == (7 - 4)) or ((6199 - 3423) > (14199 - 10624))) then
					v203 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 61 - 21, true);
					if (v203 or ((219 + 2335) == (14060 - 9256))) then
						return v203;
					end
					break;
				end
				if (((413 + 2164) == (4077 - 1500)) and (v202 == (104 - (103 + 1)))) then
					v203 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 594 - (475 + 79));
					if (v203 or ((12 - 6) >= (6044 - 4155))) then
						return v203;
					end
					v202 = 1 + 0;
				end
				if (((446 + 60) <= (3395 - (1395 + 108))) and (v202 == (2 - 1))) then
					v203 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 1244 - (7 + 1197), true);
					if (v203 or ((876 + 1132) > (774 + 1444))) then
						return v203;
					end
					v202 = 321 - (27 + 292);
				end
				if (((1110 - 731) <= (5288 - 1141)) and (v202 == (8 - 6))) then
					v203 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 78 - 38);
					if (v203 or ((8596 - 4082) <= (1148 - (43 + 96)))) then
						return v203;
					end
					v202 = 12 - 9;
				end
			end
		end
		if (v48 or ((7903 - 4407) == (990 + 202))) then
			local v204 = 0 + 0;
			local v205;
			while true do
				if ((v204 == (0 - 0)) or ((80 + 128) == (5545 - 2586))) then
					v205 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 13 + 27);
					if (((314 + 3963) >= (3064 - (1414 + 337))) and v205) then
						return v205;
					end
					v204 = 1941 - (1642 + 298);
				end
				if (((6743 - 4156) < (9131 - 5957)) and (v204 == (8 - 5))) then
					v205 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 14 + 26, true);
					if (v205 or ((3206 + 914) <= (3170 - (357 + 615)))) then
						return v205;
					end
					break;
				end
				if ((v204 == (1 + 0)) or ((3915 - 2319) == (736 + 122))) then
					v205 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 85 - 45, true);
					if (((2576 + 644) == (219 + 3001)) and v205) then
						return v205;
					end
					v204 = 2 + 0;
				end
				if (((1303 - (384 + 917)) == v204) or ((2099 - (128 + 569)) > (5163 - (1407 + 136)))) then
					v205 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 1927 - (687 + 1200));
					if (((4284 - (556 + 1154)) == (9055 - 6481)) and v205) then
						return v205;
					end
					v204 = 98 - (9 + 86);
				end
			end
		end
		if (((2219 - (275 + 146)) < (449 + 2308)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v30) then
			local v206 = 64 - (29 + 35);
			local v207;
			while true do
				if ((v206 == (0 - 0)) or ((1125 - 748) > (11495 - 8891))) then
					v207 = v99.DeadFriendlyUnitsCount();
					if (((370 + 198) < (1923 - (53 + 959))) and v14:AffectingCombat()) then
						if (((3693 - (312 + 96)) < (7337 - 3109)) and v100.Rebirth:IsReady()) then
							if (((4201 - (147 + 138)) > (4227 - (813 + 86))) and v25(v100.Rebirth, nil, true)) then
								return "rebirth";
							end
						end
					elseif (((2260 + 240) < (7112 - 3273)) and (v207 > (493 - (18 + 474)))) then
						if (((172 + 335) == (1654 - 1147)) and v25(v100.Revitalize, nil, true)) then
							return "revitalize";
						end
					elseif (((1326 - (860 + 226)) <= (3468 - (121 + 182))) and v25(v100.Revive, not v16:IsInRange(5 + 35), true)) then
						return "revive";
					end
					break;
				end
			end
		end
		if (((2074 - (988 + 252)) >= (91 + 714)) and v37 and (v14:AffectingCombat() or v30)) then
			DebugMessage = v137();
			if (DebugMessage or ((1195 + 2617) < (4286 - (49 + 1921)))) then
				return DebugMessage;
			end
			DebugMessage = v138();
			if (DebugMessage or ((3542 - (223 + 667)) <= (1585 - (51 + 1)))) then
				return DebugMessage;
			end
		end
		if (not v14:IsChanneling() or ((6192 - 2594) < (3126 - 1666))) then
			if (v14:AffectingCombat() or ((5241 - (146 + 979)) < (337 + 855))) then
				local v223 = v139();
				if (v223 or ((3982 - (311 + 294)) <= (2518 - 1615))) then
					return v223;
				end
			elseif (((1685 + 2291) >= (1882 - (496 + 947))) and v30) then
				local v234 = 1358 - (1233 + 125);
				local v235;
				while true do
					if (((1523 + 2229) == (3367 + 385)) and (v234 == (0 + 0))) then
						v235 = v140();
						if (((5691 - (963 + 682)) > (2250 + 445)) and v235) then
							return v235;
						end
						break;
					end
				end
			end
		end
	end
	local function v144()
		v23.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v119();
	end
	v23.SetAPL(1609 - (504 + 1000), v143, v144);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

