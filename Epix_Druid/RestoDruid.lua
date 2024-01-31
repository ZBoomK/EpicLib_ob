local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1119 + 1535) < (1197 + 837))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Druid_RestoDruid.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = v9.Commons;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.Macro;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = string.format;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99 = v22.Commons.Everyone;
	local v100 = v18.Druid.Restoration;
	local v101 = v20.Druid.Restoration;
	local v102 = {};
	local v103 = v25.Druid.Restoration;
	local v104 = 677 - (189 + 488);
	local v105, v106;
	local v107 = 16918 - 5807;
	local v108 = 6868 + 4243;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[680 - (89 + 578)] and v20(v116[10 + 3])) or v20(0 - 0);
	local v118 = (v116[1063 - (572 + 477)] and v20(v116[2 + 12])) or v20(0 + 0);
	v9:RegisterForEvent(function()
		v116 = v13:GetEquipment();
		v117 = (v116[2 + 11] and v20(v116[99 - (84 + 2)])) or v20(0 - 0);
		v118 = (v116[11 + 3] and v20(v116[856 - (497 + 345)])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v145 = 0 + 0;
		while true do
			if (((2254 - (605 + 728)) < (787 + 315)) and (v145 == (0 - 0))) then
				v107 = 510 + 10601;
				v108 = 41079 - 29968;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (((4243 + 463) >= (2667 - 1704)) and v100.ImprovedNaturesCure:IsAvailable()) then
			v99.DispellableDebuffs = v11.MergeTable(v99.DispellableMagicDebuffs, v99.DispellableDiseaseDebuffs);
			v99.DispellableDebuffs = v11.MergeTable(v99.DispellableDebuffs, v99.DispellableCurseDebuffs);
		else
			v99.DispellableDebuffs = v99.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v119();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v120()
		return (v13:StealthUp(true, true) and (1.6 + 0)) or (490 - (457 + 32));
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (1402 - (832 + 570))) or ((905 + 55) <= (229 + 647))) then
				v109 = v13:BuffUp(v100.EclipseSolar) or v13:BuffUp(v100.EclipseLunar);
				v110 = v13:BuffUp(v100.EclipseSolar) and v13:BuffUp(v100.EclipseLunar);
				v146 = 3 - 2;
			end
			if ((v146 == (2 + 1)) or ((2862 - (588 + 208)) == (2511 - 1579))) then
				v115 = not v109 and (v100.Wrath:Count() > (1800 - (884 + 916))) and (v100.Starfire:Count() > (0 - 0));
				break;
			end
			if (((2798 + 2027) < (5496 - (232 + 421))) and (v146 == (1891 - (1569 + 320)))) then
				v113 = (not v109 and (((v100.Starfire:Count() == (0 + 0)) and (v100.Wrath:Count() > (0 + 0))) or v13:IsCasting(v100.Wrath))) or v112;
				v114 = (not v109 and (((v100.Wrath:Count() == (0 - 0)) and (v100.Starfire:Count() > (605 - (316 + 289)))) or v13:IsCasting(v100.Starfire))) or v111;
				v146 = 7 - 4;
			end
			if ((v146 == (1 + 0)) or ((5330 - (666 + 787)) >= (4962 - (360 + 65)))) then
				v111 = v13:BuffUp(v100.EclipseLunar) and v13:BuffDown(v100.EclipseSolar);
				v112 = v13:BuffUp(v100.EclipseSolar) and v13:BuffDown(v100.EclipseLunar);
				v146 = 2 + 0;
			end
		end
	end
	local function v122(v147)
		return v147:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (259 - (79 + 175)));
	end
	local function v123(v148)
		return (v148:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (18 - 6)) and ((((v106 <= (4 + 0)) or (v13:Energy() < (153 - 103))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (7 - 3)) or (v13:Energy() < (949 - (503 + 396)))) and v13:BuffUp(v100.HeartOfTheWild))) and v148:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(182 - (92 + 89), v100.Sunfire) and ((v148:DebuffUp(v100.MoonfireDebuff) and (v148:DebuffRemains(v100.MoonfireDebuff) < (v148:DebuffDuration(v100.MoonfireDebuff) * (0.8 - 0)))) or v148:DebuffDown(v100.MoonfireDebuff)) and (v106 == (1 + 0)));
	end
	local function v124(v149)
		return v149:DebuffRefreshable(v100.MoonfireDebuff) and (v149:TimeToDie() > (3 + 2));
	end
	local function v125(v150)
		return ((v150:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (352 - 262)) and (v150:DebuffRemains(v100.Rip) <= (2 + 8)))) and (((v13:ComboPoints() == (11 - 6)) and (v150:TimeToDie() > (v150:DebuffRemains(v100.Rip) + 21 + 3))) or (((v150:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (2 + 2))) < v150:TimeToDie()) and ((v150:DebuffRemains(v100.Rip) + (12 - 8) + (v13:ComboPoints() * (1 + 3))) > v150:TimeToDie())))) or (v150:DebuffDown(v100.Rip) and (v13:ComboPoints() > ((2 - 0) + (v106 * (1246 - (485 + 759))))));
	end
	local function v126(v151)
		return (v151:DebuffDown(v100.RakeDebuff) or v151:DebuffRefreshable(v100.RakeDebuff)) and (v151:TimeToDie() > (23 - 13)) and (v13:ComboPoints() < (1194 - (442 + 747)));
	end
	local function v127(v152)
		return (v152:DebuffUp(v100.AdaptiveSwarmDebuff));
	end
	local function v128()
		return v99.FriendlyUnitsWithBuffCount(v100.Rejuvenation) + v99.FriendlyUnitsWithBuffCount(v100.Regrowth) + v99.FriendlyUnitsWithBuffCount(v100.Wildgrowth);
	end
	local function v129()
		return v99.FriendlyUnitsWithoutBuffCount(v100.Rejuvenation);
	end
	local function v130(v153)
		return v153:BuffUp(v100.Rejuvenation) or v153:BuffUp(v100.Regrowth) or v153:BuffUp(v100.Wildgrowth);
	end
	local function v131()
		local v154 = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 1175 - (832 + 303), nil);
		if (v154 or ((5261 - (88 + 858)) < (527 + 1199))) then
			return v154;
		end
		local v154 = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 34 + 6, nil);
		if (v154 or ((152 + 3527) < (1414 - (766 + 23)))) then
			return v154;
		end
	end
	local function v132()
		if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((22832 - 18207) < (863 - 231))) then
			if (v24(v100.Rake, not v15:IsInMeleeRange(26 - 16)) or ((281 - 198) > (2853 - (1036 + 37)))) then
				return "rake cat 2";
			end
		end
		if (((388 + 158) <= (2097 - 1020)) and v38 and not v13:StealthUp(false, true)) then
			local v180 = 0 + 0;
			local v181;
			while true do
				if ((v180 == (1480 - (641 + 839))) or ((1909 - (910 + 3)) > (10964 - 6663))) then
					v181 = v131();
					if (((5754 - (1466 + 218)) > (316 + 371)) and v181) then
						return v181;
					end
					break;
				end
			end
		end
		if (v100.AdaptiveSwarm:IsCastable() or ((1804 - (556 + 592)) >= (1185 + 2145))) then
			if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((3300 - (329 + 479)) <= (1189 - (174 + 680)))) then
				return "adaptive_swarm cat";
			end
		end
		if (((14850 - 10528) >= (5309 - 2747)) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
			if (v13:BuffUp(v100.CatForm) or ((2597 + 1040) >= (4509 - (396 + 343)))) then
				if (((v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (6 + 54)) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (1527 - (29 + 1448))) and (((v13:ComboPoints() < (1394 - (135 + 1254))) and (v15:DebuffRemains(v100.Rip) > (18 - 13))) or (v106 > (4 - 3)))) or ((1586 + 793) > (6105 - (389 + 1138)))) then
					if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(604 - (102 + 472))) or ((456 + 27) > (413 + 330))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((2289 + 165) > (2123 - (320 + 1225))) and v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (8 - 3)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (19 + 11)))) then
			if (((2394 - (157 + 1307)) < (6317 - (821 + 1038))) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
				return "sunfire cat 20";
			end
		end
		if (((1651 - 989) <= (107 + 865)) and v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (8 - 3)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (12 + 18)))) then
			if (((10831 - 6461) == (5396 - (834 + 192))) and v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
				return "moonfire cat 22";
			end
		end
		if ((v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (1 + 4))) or ((1223 + 3539) <= (19 + 842))) then
			if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((2186 - 774) == (4568 - (300 + 4)))) then
				return "sunfire cat 24";
			end
		end
		if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (2 + 3))) or ((8293 - 5125) < (2515 - (112 + 250)))) then
			if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((1984 + 2992) < (3336 - 2004))) then
				return "moonfire cat 24";
			end
		end
		if (((2652 + 1976) == (2394 + 2234)) and v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((41 + 13) == (196 + 199))) then
				return "starsurge cat 26";
			end
		end
		if (((61 + 21) == (1496 - (1001 + 413))) and v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (66 - 36)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (886 - (244 + 638))))) then
			if (v24(v100.HeartOfTheWild) or ((1274 - (627 + 66)) < (840 - 558))) then
				return "heart_of_the_wild cat 26";
			end
		end
		if ((v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (632 - (512 + 90))) and v35) or ((6515 - (1665 + 241)) < (3212 - (373 + 344)))) then
			if (((520 + 632) == (305 + 847)) and v24(v100.CatForm)) then
				return "cat_form cat 28";
			end
		end
		if (((5001 - 3105) <= (5790 - 2368)) and v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (1102 - (35 + 1064))) and (v15:TimeToDie() < (8 + 2))) or ((v13:ComboPoints() == (10 - 5)) and (v13:Energy() >= (1 + 24)) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (1241 - (298 + 938))))))) then
			if (v24(v100.FerociousBite, not v15:IsInMeleeRange(1264 - (233 + 1026))) or ((2656 - (636 + 1030)) > (829 + 791))) then
				return "ferocious_bite cat 32";
			end
		end
		if ((v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (11 + 0)) and v125(v15)) or ((261 + 616) > (318 + 4377))) then
			if (((2912 - (55 + 166)) >= (359 + 1492)) and v24(v100.Rip, not v15:IsInMeleeRange(1 + 4))) then
				return "rip cat 34";
			end
		end
		if ((v100.Thrash:IsReady() and (v106 >= (7 - 5)) and v15:DebuffRefreshable(v100.ThrashDebuff)) or ((3282 - (36 + 261)) >= (8491 - 3635))) then
			if (((5644 - (34 + 1334)) >= (460 + 735)) and v24(v100.Thrash, not v15:IsInMeleeRange(7 + 1))) then
				return "thrash cat";
			end
		end
		if (((4515 - (1035 + 248)) <= (4711 - (20 + 1))) and v100.Rake:IsReady() and v126(v15)) then
			if (v24(v100.Rake, not v15:IsInMeleeRange(3 + 2)) or ((1215 - (134 + 185)) >= (4279 - (549 + 584)))) then
				return "rake cat 36";
			end
		end
		if (((3746 - (314 + 371)) >= (10154 - 7196)) and v100.Rake:IsReady() and ((v13:ComboPoints() < (973 - (478 + 490))) or (v13:Energy() > (48 + 42))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) then
			if (((4359 - (786 + 386)) >= (2085 - 1441)) and v24(v100.Rake, not v15:IsInMeleeRange(1384 - (1055 + 324)))) then
				return "rake cat 40";
			end
		end
		if (((1984 - (1093 + 247)) <= (626 + 78)) and v100.Swipe:IsReady() and (v106 >= (1 + 1))) then
			if (((3803 - 2845) > (3213 - 2266)) and v24(v100.Swipe, not v15:IsInMeleeRange(22 - 14))) then
				return "swipe cat 38";
			end
		end
		if (((11287 - 6795) >= (945 + 1709)) and v100.Shred:IsReady() and ((v13:ComboPoints() < (19 - 14)) or (v13:Energy() > (310 - 220)))) then
			if (((2596 + 846) >= (3843 - 2340)) and v24(v100.Shred, not v15:IsInMeleeRange(693 - (364 + 324)))) then
				return "shred cat 42";
			end
		end
	end
	local function v133()
		if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (82 - 52)) or (v100.ConvokeTheSpirits:CooldownRemains() > (215 - 125)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) or ((1051 + 2119) <= (6125 - 4661))) then
			if (v24(v100.HeartOfTheWild) or ((7681 - 2884) == (13326 - 8938))) then
				return "heart_of_the_wild owl 2";
			end
		end
		if (((1819 - (1249 + 19)) <= (615 + 66)) and v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) then
			if (((12755 - 9478) > (1493 - (686 + 400))) and v24(v100.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if (((3684 + 1011) >= (1644 - (73 + 156))) and v100.Starsurge:IsReady() and ((v106 < (1 + 5)) or (not v111 and (v106 < (819 - (721 + 90))))) and v35) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((37 + 3175) <= (3064 - 2120))) then
				return "starsurge owl 8";
			end
		end
		if ((v100.Moonfire:IsReady() and ((v106 < (475 - (224 + 246))) or (not v111 and (v106 < (11 - 4))))) or ((5700 - 2604) <= (327 + 1471))) then
			if (((85 + 3452) == (2598 + 939)) and v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
				return "moonfire owl 10";
			end
		end
		if (((7627 - 3790) >= (5224 - 3654)) and v100.Sunfire:IsReady()) then
			if (v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover) or ((3463 - (203 + 310)) == (5805 - (1238 + 755)))) then
				return "sunfire owl 12";
			end
		end
		if (((330 + 4393) >= (3852 - (709 + 825))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
			if (v13:BuffUp(v100.MoonkinForm) or ((3735 - 1708) > (4153 - 1301))) then
				if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(894 - (196 + 668))) or ((4485 - 3349) > (8942 - 4625))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((5581 - (171 + 662)) == (4841 - (4 + 89))) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(27 - 19)) and ((v112 and (v106 == (1 + 0))) or v113 or (v115 and (v106 > (4 - 3))))) then
			if (((1466 + 2270) <= (6226 - (35 + 1451))) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
				return "wrath owl 14";
			end
		end
		if (v100.Starfire:IsReady() or ((4843 - (28 + 1425)) <= (5053 - (941 + 1052)))) then
			if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((958 + 41) > (4207 - (822 + 692)))) then
				return "starfire owl 16";
			end
		end
	end
	local function v134()
		local v155 = v99.InterruptWithStun(v100.IncapacitatingRoar, 11 - 3);
		if (((219 + 244) < (898 - (45 + 252))) and v155) then
			return v155;
		end
		if ((v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 + 0))) or ((752 + 1431) < (1671 - 984))) then
			v155 = v99.InterruptWithStun(v100.Maim, 441 - (114 + 319));
			if (((6530 - 1981) == (5828 - 1279)) and v155) then
				return v155;
			end
		end
		v155 = v99.InterruptWithStun(v100.MightyBash, 6 + 2);
		if (((6959 - 2287) == (9788 - 5116)) and v155) then
			return v155;
		end
		v121();
		local v156 = 1963 - (556 + 1407);
		if (v100.Rip:IsAvailable() or ((4874 - (741 + 465)) < (860 - (170 + 295)))) then
			v156 = v156 + 1 + 0;
		end
		if (v100.Rake:IsAvailable() or ((3827 + 339) == (1120 - 665))) then
			v156 = v156 + 1 + 0;
		end
		if (v100.Thrash:IsAvailable() or ((2854 + 1595) == (1508 + 1155))) then
			v156 = v156 + (1231 - (957 + 273));
		end
		if (((v156 >= (1 + 1)) and v15:IsInMeleeRange(4 + 4)) or ((16297 - 12020) < (7876 - 4887))) then
			local v182 = 0 - 0;
			local v183;
			while true do
				if ((v182 == (0 - 0)) or ((2650 - (389 + 1391)) >= (2604 + 1545))) then
					v183 = v132();
					if (((231 + 1981) < (7246 - 4063)) and v183) then
						return v183;
					end
					break;
				end
			end
		end
		if (((5597 - (783 + 168)) > (10041 - 7049)) and v100.AdaptiveSwarm:IsCastable()) then
			if (((1411 + 23) < (3417 - (309 + 2))) and v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm))) then
				return "adaptive_swarm main";
			end
		end
		if (((2413 - 1627) < (4235 - (1090 + 122))) and v100.MoonkinForm:IsAvailable()) then
			local v184 = 0 + 0;
			local v185;
			while true do
				if ((v184 == (0 - 0)) or ((1672 + 770) < (1192 - (628 + 490)))) then
					v185 = v133();
					if (((814 + 3721) == (11228 - 6693)) and v185) then
						return v185;
					end
					break;
				end
			end
		end
		if ((v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) or ((13751 - 10742) <= (2879 - (431 + 343)))) then
			if (((3695 - 1865) < (10613 - 6944)) and v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire))) then
				return "sunfire main 24";
			end
		end
		if ((v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) or ((1130 + 300) >= (462 + 3150))) then
			if (((4378 - (556 + 1139)) >= (2475 - (6 + 9))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((331 + 1473) >= (1678 + 1597))) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((1586 - (28 + 141)) > (1406 + 2223))) then
				return "starsurge main 28";
			end
		end
		if (((5918 - 1123) > (285 + 117)) and v100.Starfire:IsReady() and (v106 > (1319 - (486 + 831)))) then
			if (((12524 - 7711) > (12551 - 8986)) and v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
		if (((740 + 3172) == (12369 - 8457)) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(1271 - (668 + 595)))) then
			if (((2539 + 282) <= (973 + 3851)) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
				return "wrath main 30";
			end
		end
		if (((4739 - 3001) <= (2485 - (23 + 267))) and v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(1952 - (1129 + 815)))) then
			if (((428 - (371 + 16)) <= (4768 - (1326 + 424))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (((4062 - 1917) <= (14997 - 10893)) and true) then
			if (((2807 - (88 + 30)) < (5616 - (720 + 51))) and v24(v100.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v135()
		if ((v16 and v99.DispellableFriendlyUnit() and v100.NaturesCure:IsReady()) or ((5165 - 2843) > (4398 - (421 + 1355)))) then
			local v186 = 0 - 0;
			while true do
				if ((v186 == (0 + 0)) or ((5617 - (286 + 797)) == (7610 - 5528))) then
					v99.Wait(1 - 0);
					if (v24(v103.NaturesCureFocus) or ((2010 - (397 + 42)) > (584 + 1283))) then
						return "natures_cure dispel 2";
					end
					break;
				end
			end
		end
	end
	local function v136()
		local v157 = 800 - (24 + 776);
		while true do
			if ((v157 == (1 - 0)) or ((3439 - (222 + 563)) >= (6600 - 3604))) then
				if (((2865 + 1113) > (2294 - (23 + 167))) and v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) then
					if (((4793 - (690 + 1108)) > (556 + 985)) and v24(v103.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (((2680 + 569) > (1801 - (40 + 808))) and v39 and (v13:HealthPercentage() <= v41)) then
					if ((v40 == "Refreshing Healing Potion") or ((539 + 2734) > (17486 - 12913))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((3012 + 139) < (680 + 604))) then
							if (v24(v103.RefreshingHealingPotion, nil, nil, true) or ((1015 + 835) == (2100 - (47 + 524)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((533 + 288) < (5803 - 3680)) and (v157 == (0 - 0))) then
				if (((2056 - 1154) < (4051 - (1165 + 561))) and (v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) then
					if (((26 + 832) <= (9173 - 6211)) and v24(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) or ((1506 + 2440) < (1767 - (341 + 138)))) then
					if (v24(v100.Renewal, nil, nil, true) or ((876 + 2366) == (1169 - 602))) then
						return "renewal defensive 2";
					end
				end
				v157 = 327 - (89 + 237);
			end
		end
	end
	local function v137()
		if ((v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) or ((2724 - 1877) >= (2658 - 1395))) then
			if (v24(v103.RejuvenationFocus) or ((3134 - (581 + 300)) == (3071 - (855 + 365)))) then
				return "rejuvenation ramp";
			end
		end
		if ((v100.Swiftmend:IsReady() and v130(v16)) or ((4957 - 2870) > (775 + 1597))) then
			if (v24(v103.SwiftmendFocus) or ((5680 - (1030 + 205)) < (3896 + 253))) then
				return "swiftmend ramp";
			end
		end
		if ((v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) or ((1692 + 126) == (371 - (156 + 130)))) then
			if (((1431 - 801) < (3584 - 1457)) and v24(v103.WildgrowthFocus, nil, true)) then
				return "wildgrowth ramp";
			end
		end
		if ((v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) or ((3969 - 2031) == (663 + 1851))) then
			if (((2482 + 1773) >= (124 - (10 + 59))) and v24(v103.InnervatePlayer, nil, nil, true)) then
				return "innervate ramp";
			end
		end
		if (((849 + 2150) > (5693 - 4537)) and v13:BuffUp(v100.Innervate) and (v129() > (1163 - (671 + 492))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) then
			if (((1871 + 479) > (2370 - (369 + 846))) and v24(v103.RejuvenationMouseover)) then
				return "rejuvenation_cycle ramp";
			end
		end
	end
	local function v138()
		if (((1067 + 2962) <= (4142 + 711)) and v36) then
			local v187 = 1945 - (1036 + 909);
			while true do
				if ((v187 == (2 + 0)) or ((865 - 349) > (3637 - (11 + 192)))) then
					if (((2045 + 2001) >= (3208 - (135 + 40))) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85)) then
						if (v24(v100.Tranquility, nil, true) or ((6587 - 3868) <= (873 + 574))) then
							return "tranquility healing";
						end
					end
					if ((v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88)) or ((9107 - 4973) < (5885 - 1959))) then
						if (v24(v100.Tranquility, nil, true) or ((340 - (50 + 126)) >= (7754 - 4969))) then
							return "tranquility_tree healing";
						end
					end
					if ((v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63)) or ((117 + 408) == (3522 - (1233 + 180)))) then
						if (((1002 - (522 + 447)) == (1454 - (107 + 1314))) and v24(v100.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					v187 = 2 + 1;
				end
				if (((9305 - 6251) <= (1706 + 2309)) and (v187 == (9 - 4))) then
					if (((7402 - 5531) < (5292 - (716 + 1194))) and v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (1 + 0)) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (2 + 13)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
						if (((1796 - (74 + 429)) <= (4178 - 2012)) and v24(v103.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					if ((v54 == "Player") or ((1279 + 1300) < (281 - 158))) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (11 + 4))) or ((2607 - 1761) >= (5854 - 3486))) then
							if (v24(v103.EfflorescencePlayer) or ((4445 - (279 + 154)) <= (4136 - (454 + 324)))) then
								return "efflorescence healing player";
							end
						end
					elseif (((1176 + 318) <= (3022 - (12 + 5))) and (v54 == "Cursor")) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (9 + 6))) or ((7926 - 4815) == (789 + 1345))) then
							if (((3448 - (277 + 816)) == (10063 - 7708)) and v24(v103.EfflorescenceCursor)) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v54 == "Confirmation") or ((1771 - (1058 + 125)) <= (81 + 351))) then
						if (((5772 - (815 + 160)) >= (16712 - 12817)) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (35 - 20))) then
							if (((854 + 2723) == (10456 - 6879)) and v24(v100.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if (((5692 - (41 + 1857)) > (5586 - (1222 + 671))) and v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) then
						if (v24(v103.WildgrowthFocus, nil, true) or ((3295 - 2020) == (5893 - 1793))) then
							return "wildgrowth healing";
						end
					end
					v187 = 1188 - (229 + 953);
				end
				if ((v187 == (1775 - (1111 + 663))) or ((3170 - (874 + 705)) >= (502 + 3078))) then
					if (((671 + 312) <= (3758 - 1950)) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91)) then
						if (v24(v103.WildgrowthFocus, nil, true) or ((61 + 2089) <= (1876 - (642 + 37)))) then
							return "wildgrowth_sotf healing";
						end
					end
					if (((860 + 2909) >= (188 + 985)) and v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (12 - 7)) and v99.AreUnitsBelowHealthPercentage(v57, v58)) then
						if (((1939 - (233 + 221)) == (3433 - 1948)) and v24(v103.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if ((v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (4 + 0)) and v99.AreUnitsBelowHealthPercentage(v65, v66)) or ((4856 - (718 + 823)) <= (1751 + 1031))) then
						if (v24(v100.Flourish, nil, nil, true) or ((1681 - (266 + 539)) >= (8391 - 5427))) then
							return "flourish healing";
						end
					end
					v187 = 1227 - (636 + 589);
				end
				if ((v187 == (9 - 5)) or ((4603 - 2371) > (1979 + 518))) then
					if ((v67 == "Anyone") or ((767 + 1343) <= (1347 - (657 + 358)))) then
						if (((9759 - 6073) > (7226 - 4054)) and v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) then
							if (v24(v103.IronBarkFocus) or ((5661 - (1151 + 36)) < (792 + 28))) then
								return "iron_bark healing";
							end
						end
					elseif (((1125 + 3154) >= (8606 - 5724)) and (v67 == "Tank Only")) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v99.UnitGroupRole(v16) == "TANK")) or ((3861 - (1552 + 280)) >= (4355 - (64 + 770)))) then
							if (v24(v103.IronBarkFocus) or ((1384 + 653) >= (10537 - 5895))) then
								return "iron_bark healing";
							end
						end
					elseif (((306 + 1414) < (5701 - (157 + 1086))) and (v67 == "Tank and Self")) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v99.UnitGroupRole(v16) == "TANK") or (v99.UnitGroupRole(v16) == "HEALER"))) or ((872 - 436) > (13231 - 10210))) then
							if (((1092 - 379) <= (1155 - 308)) and v24(v103.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					end
					if (((2973 - (599 + 220)) <= (8027 - 3996)) and v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) then
						if (((6546 - (1813 + 118)) == (3374 + 1241)) and v24(v103.AdaptiveSwarmFocus)) then
							return "adaptive_swarm healing";
						end
					end
					if ((v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (1218 - (841 + 376))) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (20 - 5)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((881 + 2909) == (1364 - 864))) then
						if (((948 - (464 + 395)) < (567 - 346)) and v24(v103.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v187 = 3 + 2;
				end
				if (((2891 - (467 + 370)) >= (2936 - 1515)) and (v187 == (5 + 1))) then
					if (((2372 - 1680) < (478 + 2580)) and v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) then
						if (v24(v103.RegrowthFocus, nil, true) or ((7570 - 4316) == (2175 - (150 + 370)))) then
							return "regrowth healing";
						end
					end
					if ((v13:BuffUp(v100.Innervate) and (v129() > (1282 - (74 + 1208))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((3187 - 1891) == (23286 - 18376))) then
						if (((2397 + 971) == (3758 - (14 + 376))) and v24(v103.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					if (((4583 - 1940) < (2469 + 1346)) and v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) then
						if (((1681 + 232) > (471 + 22)) and v24(v103.RejuvenationFocus)) then
							return "rejuvenation healing";
						end
					end
					v187 = 20 - 13;
				end
				if (((3578 + 1177) > (3506 - (23 + 55))) and (v187 == (6 - 3))) then
					if (((922 + 459) <= (2128 + 241)) and v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) then
						if (v24(v103.CenarionWardFocus) or ((7508 - 2665) == (1285 + 2799))) then
							return "cenarion_ward healing";
						end
					end
					if (((5570 - (652 + 249)) > (971 - 608)) and v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) then
						if (v24(v103.RegrowthFocus) or ((3745 - (708 + 1160)) >= (8517 - 5379))) then
							return "regrowth_swiftness healing";
						end
					end
					if (((8645 - 3903) >= (3653 - (10 + 17))) and v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) then
						if (v24(v100.NaturesSwiftness) or ((1020 + 3520) == (2648 - (1400 + 332)))) then
							return "natures_swiftness healing";
						end
					end
					v187 = 7 - 3;
				end
				if ((v187 == (1915 - (242 + 1666))) or ((495 + 661) > (1593 + 2752))) then
					if (((1907 + 330) < (5189 - (850 + 90))) and v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) then
						if (v24(v103.RegrowthFocus, nil, true) or ((4698 - 2015) < (1413 - (360 + 1030)))) then
							return "regrowth healing";
						end
					end
					break;
				end
				if (((617 + 80) <= (2330 - 1504)) and (v187 == (0 - 0))) then
					if (((2766 - (909 + 752)) <= (2399 - (109 + 1114))) and v38) then
						local v232 = 0 - 0;
						local v233;
						while true do
							if (((1316 + 2063) <= (4054 - (6 + 236))) and (v232 == (0 + 0))) then
								v233 = v131();
								if (v233 or ((635 + 153) >= (3810 - 2194))) then
									return v233;
								end
								break;
							end
						end
					end
					if (((3237 - 1383) <= (4512 - (1076 + 57))) and v53 and v31 and v13:AffectingCombat() and (v128() > (1 + 2)) and v100.NaturesVigil:IsReady()) then
						if (((5238 - (579 + 110)) == (360 + 4189)) and v24(v100.NaturesVigil, nil, nil, true)) then
							return "natures_vigil healing";
						end
					end
					if ((v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) or ((2672 + 350) >= (1605 + 1419))) then
						if (((5227 - (174 + 233)) > (6139 - 3941)) and v24(v103.SwiftmendFocus)) then
							return "swiftmend healing";
						end
					end
					v187 = 1 - 0;
				end
			end
		end
	end
	local function v139()
		local v158 = 0 + 0;
		local v159;
		while true do
			if ((v158 == (1177 - (663 + 511))) or ((947 + 114) >= (1062 + 3829))) then
				if (((4204 - 2840) <= (2709 + 1764)) and v99.TargetIsValid() and v34) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (0 - 0)) or ((1716 + 1879) <= (5 - 2))) then
							v159 = v134();
							if (v159 or ((3330 + 1342) == (353 + 3499))) then
								return v159;
							end
							break;
						end
					end
				end
				break;
			end
			if (((2281 - (478 + 244)) == (2076 - (440 + 77))) and (v158 == (1 + 0))) then
				if (v159 or ((6412 - 4660) <= (2344 - (655 + 901)))) then
					return v159;
				end
				if (v33 or ((725 + 3182) == (136 + 41))) then
					local v214 = 0 + 0;
					local v215;
					while true do
						if (((13979 - 10509) > (2000 - (695 + 750))) and (v214 == (0 - 0))) then
							v215 = v137();
							if (v215 or ((1499 - 527) == (2594 - 1949))) then
								return v215;
							end
							break;
						end
					end
				end
				v158 = 353 - (285 + 66);
			end
			if (((7416 - 4234) >= (3425 - (682 + 628))) and (v158 == (0 + 0))) then
				if (((4192 - (176 + 123)) < (1853 + 2576)) and (v44 or v43) and v32) then
					local v216 = 0 + 0;
					local v217;
					while true do
						if ((v216 == (269 - (239 + 30))) or ((780 + 2087) < (1831 + 74))) then
							v217 = v135();
							if (v217 or ((3178 - 1382) >= (12638 - 8587))) then
								return v217;
							end
							break;
						end
					end
				end
				v159 = v136();
				v158 = 316 - (306 + 9);
			end
			if (((5649 - 4030) <= (654 + 3102)) and (v158 == (2 + 0))) then
				v159 = v138();
				if (((291 + 313) == (1726 - 1122)) and v159) then
					return v159;
				end
				v158 = 1378 - (1140 + 235);
			end
		end
	end
	local function v140()
		local v160 = 0 + 0;
		while true do
			if ((v160 == (1 + 0)) or ((1151 + 3333) == (952 - (33 + 19)))) then
				if ((v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) or ((1610 + 2849) <= (3335 - 2222))) then
					if (((1600 + 2032) > (6663 - 3265)) and v24(v103.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (((3828 + 254) <= (5606 - (586 + 103))) and v99.TargetIsValid()) then
					if (((440 + 4392) >= (4266 - 2880)) and v100.Rake:IsReady() and (v13:StealthUp(false, true))) then
						if (((1625 - (1309 + 179)) == (246 - 109)) and v24(v100.Rake, not v15:IsInMeleeRange(5 + 5))) then
							return "rake";
						end
					end
				end
				v160 = 5 - 3;
			end
			if ((v160 == (2 + 0)) or ((3335 - 1765) >= (8631 - 4299))) then
				if ((v99.TargetIsValid() and v34) or ((4673 - (295 + 314)) <= (4467 - 2648))) then
					local v218 = v134();
					if (v218 or ((6948 - (1300 + 662)) < (4942 - 3368))) then
						return v218;
					end
				end
				break;
			end
			if (((6181 - (1178 + 577)) > (90 + 82)) and (v160 == (0 - 0))) then
				if (((1991 - (851 + 554)) > (403 + 52)) and (v44 or v43) and v32) then
					local v219 = 0 - 0;
					local v220;
					while true do
						if (((1793 - 967) == (1128 - (115 + 187))) and (v219 == (0 + 0))) then
							v220 = v135();
							if (v220 or ((3805 + 214) > (17500 - 13059))) then
								return v220;
							end
							break;
						end
					end
				end
				if (((3178 - (160 + 1001)) < (3728 + 533)) and v29 and v36) then
					local v221 = 0 + 0;
					local v222;
					while true do
						if (((9653 - 4937) > (438 - (237 + 121))) and (v221 == (897 - (525 + 372)))) then
							v222 = v138();
							if (v222 or ((6648 - 3141) == (10750 - 7478))) then
								return v222;
							end
							break;
						end
					end
				end
				v160 = 143 - (96 + 46);
			end
		end
	end
	local function v141()
		local v161 = 777 - (643 + 134);
		while true do
			if ((v161 == (0 + 0)) or ((2100 - 1224) >= (11416 - 8341))) then
				v37 = EpicSettings.Settings['UseRacials'];
				v38 = EpicSettings.Settings['UseTrinkets'];
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v41 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v42 = EpicSettings.Settings['UseMarkOfTheWild'];
				v161 = 1 - 0;
			end
			if (((8895 - 4543) > (3273 - (316 + 403))) and (v161 == (2 + 1))) then
				v55 = EpicSettings.Settings['EfflorescenceHP'] or (0 - 0);
				v56 = EpicSettings.Settings['UseGroveGuardians'];
				v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
				v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
				v59 = EpicSettings.Settings['UseCenarionWard'];
				v60 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
				v161 = 2 + 2;
			end
			if ((v161 == (13 - 9)) or ((21042 - 16636) < (8398 - 4355))) then
				v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 + 0);
				v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
				v64 = EpicSettings.Settings['UseFlourish'];
				v65 = EpicSettings.Settings['FlourishHP'] or (0 + 0);
				v66 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
				v161 = 22 - (12 + 5);
			end
			if ((v161 == (3 - 2)) or ((4029 - 2140) >= (7191 - 3808))) then
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v45 = EpicSettings.Settings['UseHealthstone'];
				v46 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v47 = EpicSettings.Settings['HandleCharredTreant'];
				v48 = EpicSettings.Settings['HandleCharredBrambles'];
				v161 = 1 + 1;
			end
			if (((3865 - (1656 + 317)) <= (2437 + 297)) and (v161 == (5 + 0))) then
				v67 = EpicSettings.Settings['IronBarkUsage'] or "";
				v68 = EpicSettings.Settings['IronBarkHP'] or (0 - 0);
				break;
			end
			if (((9464 - 7541) < (2572 - (5 + 349))) and (v161 == (9 - 7))) then
				v49 = EpicSettings.Settings['InterruptWithStun'];
				v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v51 = EpicSettings.Settings['InterruptThreshold'] or (1271 - (266 + 1005));
				v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v161 = 2 + 1;
			end
		end
	end
	local function v142()
		v69 = EpicSettings.Settings['UseLifebloomTank'];
		v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
		v71 = EpicSettings.Settings['UseLifebloom'];
		v72 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
		v73 = EpicSettings.Settings['UseNaturesSwiftness'];
		v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (1696 - (561 + 1135));
		v75 = EpicSettings.Settings['UseRegrowth'];
		v76 = EpicSettings.Settings['RegrowthHP'] or (0 - 0);
		v77 = EpicSettings.Settings['UseRegrowthRefresh'];
		v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
		v79 = EpicSettings.Settings['UseRejuvenation'];
		v80 = EpicSettings.Settings['RejuvenationHP'] or (1066 - (507 + 559));
		v81 = EpicSettings.Settings['UseSwiftmend'];
		v82 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
		v83 = EpicSettings.Settings['UseTranquility'];
		v84 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v85 = EpicSettings.Settings['TranquilityGroup'] or (388 - (212 + 176));
		v86 = EpicSettings.Settings['UseTranquilityTree'];
		v87 = EpicSettings.Settings['TranquilityTreeHP'] or (905 - (250 + 655));
		v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 - 0);
		v89 = EpicSettings.Settings['UseWildgrowthSotF'];
		v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
		v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
		v92 = EpicSettings.Settings['UseWildgrowth'];
		v93 = EpicSettings.Settings['WildgrowthHP'] or (1956 - (1869 + 87));
		v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
		v95 = EpicSettings.Settings['BarkskinHP'] or (1901 - (484 + 1417));
		v96 = EpicSettings.Settings['UseBarkskin'];
		v97 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
		v98 = EpicSettings.Settings['UseRenewal'];
	end
	local function v143()
		local v175 = 0 - 0;
		while true do
			if (((2946 - (48 + 725)) > (618 - 239)) and (v175 == (18 - 11))) then
				if (not v13:IsChanneling() or ((1506 + 1085) == (9110 - 5701))) then
					if (((1264 + 3250) > (969 + 2355)) and v13:AffectingCombat()) then
						local v234 = 853 - (152 + 701);
						local v235;
						while true do
							if ((v234 == (1311 - (430 + 881))) or ((80 + 128) >= (5723 - (557 + 338)))) then
								v235 = v139();
								if (v235 or ((468 + 1115) > (10051 - 6484))) then
									return v235;
								end
								break;
							end
						end
					elseif (v29 or ((4597 - 3284) == (2109 - 1315))) then
						local v238 = 0 - 0;
						local v239;
						while true do
							if (((3975 - (499 + 302)) > (3768 - (39 + 827))) and (v238 == (0 - 0))) then
								v239 = v140();
								if (((9201 - 5081) <= (16920 - 12660)) and v239) then
									return v239;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v175 == (0 - 0)) or ((76 + 807) > (13984 - 9206))) then
				v141();
				v142();
				v29 = EpicSettings.Toggles['ooc'];
				v175 = 1 + 0;
			end
			if ((v175 == (5 - 1)) or ((3724 - (103 + 1)) >= (5445 - (475 + 79)))) then
				if (((9204 - 4946) > (2998 - 2061)) and v13:IsMounted()) then
					return;
				end
				if (v13:IsMoving() or ((630 + 4239) < (798 + 108))) then
					v104 = GetTime();
				end
				if (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm) or ((2728 - (1395 + 108)) > (12303 - 8075))) then
					if (((4532 - (7 + 1197)) > (976 + 1262)) and ((GetTime() - v104) < (1 + 0))) then
						return;
					end
				end
				v175 = 324 - (27 + 292);
			end
			if (((11249 - 7410) > (1791 - 386)) and ((12 - 9) == v175)) then
				v36 = EpicSettings.Toggles['healing'];
				if (v13:IsDeadOrGhost() or ((2549 - 1256) <= (965 - 458))) then
					return;
				end
				if (v13:AffectingCombat() or v43 or ((3035 - (43 + 96)) < (3283 - 2478))) then
					local v223 = v43 and v100.NaturesCure:IsReady() and v32;
					if (((5235 - 2919) == (1922 + 394)) and v99.IsTankBelowHealthPercentage(v68) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) then
						local v236 = 0 + 0;
						local v237;
						while true do
							if ((v236 == (0 - 0)) or ((985 + 1585) == (2872 - 1339))) then
								v237 = v99.FocusUnit(v223, nil, nil, "TANK", 7 + 13);
								if (v237 or ((65 + 818) == (3211 - (1414 + 337)))) then
									return v237;
								end
								break;
							end
						end
					elseif (((v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) or ((6559 - (1642 + 298)) <= (2603 - 1604))) then
						local v240 = 0 - 0;
						local v241;
						while true do
							if ((v240 == (0 - 0)) or ((1123 + 2287) > (3203 + 913))) then
								v241 = v99.FocusUnit(v223, nil, nil, "HEALER", 992 - (357 + 615));
								if (v241 or ((634 + 269) >= (7505 - 4446))) then
									return v241;
								end
								break;
							end
						end
					else
						local v242 = 0 + 0;
						local v243;
						while true do
							if (((0 - 0) == v242) or ((3180 + 796) < (195 + 2662))) then
								v243 = v99.FocusUnit(v223, nil, nil, nil);
								if (((3099 + 1831) > (3608 - (384 + 917))) and v243) then
									return v243;
								end
								break;
							end
						end
					end
				end
				v175 = 701 - (128 + 569);
			end
			if ((v175 == (1545 - (1407 + 136))) or ((5933 - (687 + 1200)) < (3001 - (556 + 1154)))) then
				v33 = EpicSettings.Toggles['ramp'];
				v34 = EpicSettings.Toggles['dps'];
				v35 = EpicSettings.Toggles['dpsform'];
				v175 = 10 - 7;
			end
			if ((v175 == (101 - (9 + 86))) or ((4662 - (275 + 146)) == (577 + 2968))) then
				if (v48 or ((4112 - (29 + 35)) > (18755 - 14523))) then
					local v224 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 119 - 79);
					if (v224 or ((7725 - 5975) >= (2263 + 1210))) then
						return v224;
					end
					local v224 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 1052 - (53 + 959), true);
					if (((3574 - (312 + 96)) == (5494 - 2328)) and v224) then
						return v224;
					end
					local v224 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 325 - (147 + 138));
					if (((2662 - (813 + 86)) < (3366 + 358)) and v224) then
						return v224;
					end
					local v224 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 74 - 34, true);
					if (((549 - (18 + 474)) <= (919 + 1804)) and v224) then
						return v224;
					end
				end
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) or ((6756 - 4686) == (1529 - (860 + 226)))) then
					local v225 = 303 - (121 + 182);
					local v226;
					while true do
						if ((v225 == (0 + 0)) or ((3945 - (988 + 252)) == (158 + 1235))) then
							v226 = v99.DeadFriendlyUnitsCount();
							if (v13:AffectingCombat() or ((1442 + 3159) < (2031 - (49 + 1921)))) then
								if (v100.Rebirth:IsReady() or ((2280 - (223 + 667)) >= (4796 - (51 + 1)))) then
									if (v24(v100.Rebirth, nil, true) or ((3447 - 1444) > (8209 - 4375))) then
										return "rebirth";
									end
								end
							elseif ((v226 > (1126 - (146 + 979))) or ((45 + 111) > (4518 - (311 + 294)))) then
								if (((543 - 348) == (83 + 112)) and v24(v100.Revitalize, nil, true)) then
									return "revitalize";
								end
							elseif (((4548 - (496 + 947)) >= (3154 - (1233 + 125))) and v24(v100.Revive, not v15:IsInRange(17 + 23), true)) then
								return "revive";
							end
							break;
						end
					end
				end
				if (((3929 + 450) >= (405 + 1726)) and v36 and (v13:AffectingCombat() or v29)) then
					local v227 = v137();
					if (((5489 - (963 + 682)) >= (1705 + 338)) and v227) then
						return v227;
					end
					local v227 = v138();
					if (v227 or ((4736 - (504 + 1000)) <= (1840 + 891))) then
						return v227;
					end
				end
				v175 = 7 + 0;
			end
			if (((463 + 4442) == (7233 - 2328)) and ((1 + 0) == v175)) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v175 = 2 + 0;
			end
			if ((v175 == (187 - (156 + 26))) or ((2383 + 1753) >= (6901 - 2490))) then
				if (v30 or ((3122 - (149 + 15)) == (4977 - (890 + 70)))) then
					local v228 = 117 - (39 + 78);
					while true do
						if (((1710 - (14 + 468)) >= (1787 - 974)) and (v228 == (0 - 0))) then
							v105 = v15:GetEnemiesInSplashRange(5 + 3);
							v106 = #v105;
							break;
						end
					end
				else
					local v229 = 0 + 0;
					while true do
						if ((v229 == (0 + 0)) or ((1561 + 1894) > (1062 + 2988))) then
							v105 = {};
							v106 = 1 - 0;
							break;
						end
					end
				end
				if (((241 + 2) == (853 - 610)) and (v99.TargetIsValid() or v13:AffectingCombat())) then
					local v230 = 0 + 0;
					while true do
						if (((52 - (12 + 39)) == v230) or ((253 + 18) > (4865 - 3293))) then
							if (((9754 - 7015) < (977 + 2316)) and (v108 == (5849 + 5262))) then
								v108 = v9.FightRemains(v105, false);
							end
							break;
						end
						if ((v230 == (0 - 0)) or ((2626 + 1316) < (5480 - 4346))) then
							v107 = v9.BossFightRemains(nil, true);
							v108 = v107;
							v230 = 1711 - (1596 + 114);
						end
					end
				end
				if (v47 or ((7030 - 4337) == (5686 - (164 + 549)))) then
					local v231 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 1478 - (1059 + 379));
					if (((2664 - 518) == (1113 + 1033)) and v231) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 7 + 33, true);
					if (v231 or ((2636 - (145 + 247)) == (2646 + 578))) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 19 + 21);
					if (v231 or ((14539 - 9635) <= (368 + 1548))) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 35 + 5, true);
					if (((146 - 56) <= (1785 - (254 + 466))) and v231) then
						return v231;
					end
				end
				v175 = 566 - (544 + 16);
			end
		end
	end
	local function v144()
		local v176 = 0 - 0;
		while true do
			if (((5430 - (294 + 334)) == (5055 - (236 + 17))) and (v176 == (1 + 0))) then
				v119();
				break;
			end
			if (((0 + 0) == v176) or ((8586 - 6306) <= (2419 - 1908))) then
				v22.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
				v176 = 1 + 0;
			end
		end
	end
	v22.SetAPL(87 + 18, v143, v144);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

