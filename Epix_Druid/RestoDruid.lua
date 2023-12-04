local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2353 - 1154) == (3079 - (446 + 1434))) and (v5 == (1284 - (1040 + 243)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((2483 - (559 + 1288)) == (3833 - (609 + 1322)))) then
			v6 = v0[v4];
			if (not v6 or ((5293 - (13 + 441)) <= (12256 - 8976))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v98 = v22.Commons.Everyone;
	local v99 = v19.Druid.Restoration;
	local v100 = v21.Druid.Restoration;
	local v101 = {};
	local v102 = v25.Druid.Restoration;
	local v103 = 0 - 0;
	local v104, v105;
	local v106 = 414 + 10697;
	local v107 = 40352 - 29241;
	local v108 = false;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = v14:GetEquipment();
	local v116 = (v115[5 + 8] and v21(v115[6 + 7])) or v21(0 - 0);
	local v117 = (v115[8 + 6] and v21(v115[25 - 11])) or v21(0 + 0);
	v10:RegisterForEvent(function()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (1 + 0)) or ((3085 + 589) <= (1920 + 42))) then
				v117 = (v115[447 - (153 + 280)] and v21(v115[40 - 26])) or v21(0 + 0);
				break;
			end
			if ((v144 == (0 + 0)) or ((992 + 902) < (1276 + 130))) then
				v115 = v14:GetEquipment();
				v116 = (v115[10 + 3] and v21(v115[19 - 6])) or v21(0 + 0);
				v144 = 668 - (89 + 578);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v106 = 7938 + 3173;
		v107 = 23099 - 11988;
	end, "PLAYER_REGEN_ENABLED");
	local function v118()
		if (((2621 - (572 + 477)) >= (207 + 1324)) and v99.ImprovedNaturesCure:IsAvailable()) then
			v98.DispellableDebuffs = v12.MergeTable(v98.DispellableMagicDebuffs, v98.DispellableDiseaseDebuffs);
			v98.DispellableDebuffs = v12.MergeTable(v98.DispellableDebuffs, v98.DispellableCurseDebuffs);
		else
			v98.DispellableDebuffs = v98.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v118();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v119()
		return (v14:StealthUp(true, true) and (1.6 + 0)) or (1 + 0);
	end
	v99.Rake:RegisterPMultiplier(v99.RakeDebuff, v119);
	local function v120()
		local v145 = 86 - (84 + 2);
		while true do
			if ((v145 == (4 - 1)) or ((3377 + 1310) < (5384 - (497 + 345)))) then
				v114 = not v108 and (v99.Wrath:Count() > (0 + 0)) and (v99.Starfire:Count() > (0 + 0));
				break;
			end
			if (((4624 - (605 + 728)) > (1190 + 477)) and (v145 == (3 - 1))) then
				v112 = (not v108 and (((v99.Starfire:Count() == (0 + 0)) and (v99.Wrath:Count() > (0 - 0))) or v14:IsCasting(v99.Wrath))) or v111;
				v113 = (not v108 and (((v99.Wrath:Count() == (0 + 0)) and (v99.Starfire:Count() > (0 - 0))) or v14:IsCasting(v99.Starfire))) or v110;
				v145 = 3 + 0;
			end
			if ((v145 == (490 - (457 + 32))) or ((371 + 502) == (3436 - (832 + 570)))) then
				v110 = v14:BuffUp(v99.EclipseLunar) and v14:BuffDown(v99.EclipseSolar);
				v111 = v14:BuffUp(v99.EclipseSolar) and v14:BuffDown(v99.EclipseLunar);
				v145 = 2 + 0;
			end
			if ((v145 == (0 + 0)) or ((9965 - 7149) < (6 + 5))) then
				v108 = v14:BuffUp(v99.EclipseSolar) or v14:BuffUp(v99.EclipseLunar);
				v109 = v14:BuffUp(v99.EclipseSolar) and v14:BuffUp(v99.EclipseLunar);
				v145 = 797 - (588 + 208);
			end
		end
	end
	local function v121(v146)
		return v146:DebuffRefreshable(v99.SunfireDebuff) and (v107 > (13 - 8));
	end
	local function v122(v147)
		return (v147:DebuffRefreshable(v99.MoonfireDebuff) and (v107 > (1812 - (884 + 916))) and ((((v105 <= (8 - 4)) or (v14:Energy() < (29 + 21))) and v14:BuffDown(v99.HeartOfTheWild)) or (((v105 <= (657 - (232 + 421))) or (v14:Energy() < (1939 - (1569 + 320)))) and v14:BuffUp(v99.HeartOfTheWild))) and v147:DebuffDown(v99.MoonfireDebuff)) or (v14:PrevGCD(1 + 0, v99.Sunfire) and ((v147:DebuffUp(v99.MoonfireDebuff) and (v147:DebuffRemains(v99.MoonfireDebuff) < (v147:DebuffDuration(v99.MoonfireDebuff) * (0.8 + 0)))) or v147:DebuffDown(v99.MoonfireDebuff)) and (v105 == (3 - 2)));
	end
	local function v123(v148)
		return v148:DebuffRefreshable(v99.MoonfireDebuff) and (v148:TimeToDie() > (610 - (316 + 289)));
	end
	local function v124(v149)
		return ((v149:DebuffRefreshable(v99.Rip) or ((v14:Energy() > (235 - 145)) and (v149:DebuffRemains(v99.Rip) <= (1 + 9)))) and (((v14:ComboPoints() == (1458 - (666 + 787))) and (v149:TimeToDie() > (v149:DebuffRemains(v99.Rip) + (449 - (360 + 65))))) or (((v149:DebuffRemains(v99.Rip) + (v14:ComboPoints() * (4 + 0))) < v149:TimeToDie()) and ((v149:DebuffRemains(v99.Rip) + (258 - (79 + 175)) + (v14:ComboPoints() * (5 - 1))) > v149:TimeToDie())))) or (v149:DebuffDown(v99.Rip) and (v14:ComboPoints() > (2 + 0 + (v105 * (5 - 3)))));
	end
	local function v125(v150)
		return (v150:DebuffDown(v99.RakeDebuff) or v150:DebuffRefreshable(v99.RakeDebuff)) and (v150:TimeToDie() > (19 - 9)) and (v14:ComboPoints() < (904 - (503 + 396)));
	end
	local function v126(v151)
		return (v151:DebuffUp(v99.AdaptiveSwarmDebuff));
	end
	local function v127()
		return v98.FriendlyUnitsWithBuffCount(v99.Rejuvenation) + v98.FriendlyUnitsWithBuffCount(v99.Regrowth) + v98.FriendlyUnitsWithBuffCount(v99.Wildgrowth);
	end
	local function v128()
		return v98.FriendlyUnitsWithoutBuffCount(v99.Rejuvenation);
	end
	local function v129(v152)
		return v152:BuffUp(v99.Rejuvenation) or v152:BuffUp(v99.Regrowth) or v152:BuffUp(v99.Wildgrowth);
	end
	local function v130()
		ShouldReturn = v98.HandleTopTrinket(v101, v31 and (v14:BuffUp(v99.HeartOfTheWild) or v14:BuffUp(v99.IncarnationBuff)), 221 - (92 + 89), nil);
		if (((7175 - 3476) < (2414 + 2292)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v98.HandleBottomTrinket(v101, v31 and (v14:BuffUp(v99.HeartOfTheWild) or v14:BuffUp(v99.IncarnationBuff)), 24 + 16, nil);
		if (((10361 - 7715) >= (120 + 756)) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v131()
		local v153 = 0 - 0;
		while true do
			if (((536 + 78) <= (1521 + 1663)) and (v153 == (5 - 3))) then
				if (((391 + 2735) == (4766 - 1640)) and v99.Sunfire:IsReady() and v16:DebuffDown(v99.SunfireDebuff) and (v16:TimeToDie() > (1249 - (485 + 759)))) then
					if (v24(v99.Sunfire, not v16:IsSpellInRange(v99.Sunfire)) or ((5060 - 2873) >= (6143 - (442 + 747)))) then
						return "sunfire cat 24";
					end
				end
				if ((v99.Moonfire:IsReady() and v14:BuffDown(v99.CatForm) and v16:DebuffDown(v99.MoonfireDebuff) and (v16:TimeToDie() > (1140 - (832 + 303)))) or ((4823 - (88 + 858)) == (1090 + 2485))) then
					if (((586 + 121) > (27 + 605)) and v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire))) then
						return "moonfire cat 24";
					end
				end
				if ((v99.Starsurge:IsReady() and (v14:BuffDown(v99.CatForm))) or ((1335 - (766 + 23)) >= (13250 - 10566))) then
					if (((2003 - 538) <= (11331 - 7030)) and v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				v153 = 10 - 7;
			end
			if (((2777 - (1036 + 37)) > (1011 + 414)) and ((9 - 4) == v153)) then
				if ((v99.Rake:IsReady() and ((v14:ComboPoints() < (4 + 1)) or (v14:Energy() > (1570 - (641 + 839)))) and (v16:PMultiplier(v99.Rake) <= v14:PMultiplier(v99.Rake)) and v126(v16)) or ((1600 - (910 + 3)) == (10793 - 6559))) then
					if (v24(v99.Rake, not v16:IsInMeleeRange(1689 - (1466 + 218))) or ((1531 + 1799) < (2577 - (556 + 592)))) then
						return "rake cat 40";
					end
				end
				if (((408 + 739) >= (1143 - (329 + 479))) and v99.Swipe:IsReady() and (v105 >= (856 - (174 + 680)))) then
					if (((11803 - 8368) > (4346 - 2249)) and v24(v99.Swipe, not v16:IsInMeleeRange(6 + 2))) then
						return "swipe cat 38";
					end
				end
				if ((v99.Shred:IsReady() and ((v14:ComboPoints() < (744 - (396 + 343))) or (v14:Energy() > (8 + 82)))) or ((5247 - (29 + 1448)) >= (5430 - (135 + 1254)))) then
					if (v24(v99.Shred, not v16:IsInMeleeRange(18 - 13)) or ((17700 - 13909) <= (1074 + 537))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if ((v153 == (1528 - (389 + 1138))) or ((5152 - (102 + 472)) <= (1895 + 113))) then
				if (((624 + 501) <= (1936 + 140)) and v51 and v31 and v99.ConvokeTheSpirits:IsCastable()) then
					if (v14:BuffUp(v99.CatForm) or ((2288 - (320 + 1225)) >= (7830 - 3431))) then
						if (((707 + 448) < (3137 - (157 + 1307))) and (v14:BuffUp(v99.HeartOfTheWild) or (v99.HeartOfTheWild:CooldownRemains() > (1919 - (821 + 1038))) or not v99.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (124 - 74)) and (((v14:ComboPoints() < (1 + 4)) and (v16:DebuffRemains(v99.Rip) > (8 - 3))) or (v105 > (1 + 0)))) then
							if (v24(v99.ConvokeTheSpirits, not v16:IsInRange(74 - 44)) or ((3350 - (834 + 192)) <= (37 + 541))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if (((967 + 2800) == (81 + 3686)) and v99.Sunfire:IsReady() and v14:BuffDown(v99.CatForm) and (v16:TimeToDie() > (7 - 2)) and (not v99.Rip:IsAvailable() or v16:DebuffUp(v99.Rip) or (v14:Energy() < (334 - (300 + 4))))) then
					if (((1093 + 2996) == (10703 - 6614)) and v98.CastCycle(v99.Sunfire, v104, v121, not v16:IsSpellInRange(v99.Sunfire), nil, nil, v102.SunfireMouseover)) then
						return "sunfire cat 20";
					end
				end
				if (((4820 - (112 + 250)) >= (668 + 1006)) and v99.Moonfire:IsReady() and v14:BuffDown(v99.CatForm) and (v16:TimeToDie() > (12 - 7)) and (not v99.Rip:IsAvailable() or v16:DebuffUp(v99.Rip) or (v14:Energy() < (18 + 12)))) then
					if (((503 + 469) <= (1061 + 357)) and v98.CastCycle(v99.Moonfire, v104, v122, not v16:IsSpellInRange(v99.Moonfire), nil, nil, v102.MoonfireMouseover)) then
						return "moonfire cat 22";
					end
				end
				v153 = 1 + 1;
			end
			if ((v153 == (3 + 1)) or ((6352 - (1001 + 413)) < (10619 - 5857))) then
				if ((v99.Rip:IsAvailable() and v99.Rip:IsReady() and (v105 < (893 - (244 + 638))) and v124(v16)) or ((3197 - (627 + 66)) > (12704 - 8440))) then
					if (((2755 - (512 + 90)) == (4059 - (1665 + 241))) and v24(v99.Rip, not v16:IsInMeleeRange(722 - (373 + 344)))) then
						return "rip cat 34";
					end
				end
				if ((v99.Thrash:IsReady() and (v105 >= (1 + 1)) and v16:DebuffRefreshable(v99.ThrashDebuff)) or ((135 + 372) >= (6834 - 4243))) then
					if (((7582 - 3101) == (5580 - (35 + 1064))) and v24(v99.Thrash, not v16:IsInMeleeRange(6 + 2))) then
						return "thrash cat";
					end
				end
				if ((v99.Rake:IsReady() and v125(v16)) or ((4980 - 2652) < (3 + 690))) then
					if (((5564 - (298 + 938)) == (5587 - (233 + 1026))) and v24(v99.Rake, not v16:IsInMeleeRange(1671 - (636 + 1030)))) then
						return "rake cat 36";
					end
				end
				v153 = 3 + 2;
			end
			if (((1552 + 36) >= (396 + 936)) and (v153 == (0 + 0))) then
				if ((v99.Rake:IsReady() and (v14:StealthUp(false, true))) or ((4395 - (55 + 166)) > (824 + 3424))) then
					if (v24(v99.Rake, not v16:IsInMeleeRange(2 + 8)) or ((17514 - 12928) <= (379 - (36 + 261)))) then
						return "rake cat 2";
					end
				end
				if (((6755 - 2892) == (5231 - (34 + 1334))) and UseTrinkets and not v14:StealthUp(false, true)) then
					local v220 = 0 + 0;
					local v221;
					while true do
						if ((v220 == (0 + 0)) or ((1565 - (1035 + 248)) <= (63 - (20 + 1)))) then
							v221 = v130();
							if (((2402 + 2207) >= (1085 - (134 + 185))) and v221) then
								return v221;
							end
							break;
						end
					end
				end
				if (v99.AdaptiveSwarm:IsCastable() or ((2285 - (549 + 584)) == (3173 - (314 + 371)))) then
					if (((11747 - 8325) > (4318 - (478 + 490))) and v24(v99.AdaptiveSwarm, not v16:IsSpellInRange(v99.AdaptiveSwarm))) then
						return "adaptive_swarm cat";
					end
				end
				v153 = 1 + 0;
			end
			if (((2049 - (786 + 386)) > (1217 - 841)) and (v153 == (1382 - (1055 + 324)))) then
				if ((v99.HeartOfTheWild:IsCastable() and v31 and ((v99.ConvokeTheSpirits:CooldownRemains() < (1370 - (1093 + 247))) or not v99.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v99.HeartOfTheWild) and v16:DebuffUp(v99.SunfireDebuff) and (v16:DebuffUp(v99.MoonfireDebuff) or (v105 > (4 + 0)))) or ((328 + 2790) <= (7348 - 5497))) then
					if (v24(v99.HeartOfTheWild) or ((559 - 394) >= (9936 - 6444))) then
						return "heart_of_the_wild cat 26";
					end
				end
				if (((9923 - 5974) < (1728 + 3128)) and v99.CatForm:IsReady() and v14:BuffDown(v99.CatForm) and (v14:Energy() >= (115 - 85)) and v35) then
					if (v24(v99.CatForm) or ((14738 - 10462) < (2275 + 741))) then
						return "cat_form cat 28";
					end
				end
				if (((11994 - 7304) > (4813 - (364 + 324))) and v99.FerociousBite:IsReady() and (((v14:ComboPoints() > (7 - 4)) and (v16:TimeToDie() < (23 - 13))) or ((v14:ComboPoints() == (2 + 3)) and (v14:Energy() >= (104 - 79)) and (not v99.Rip:IsAvailable() or (v16:DebuffRemains(v99.Rip) > (8 - 3)))))) then
					if (v24(v99.FerociousBite, not v16:IsInMeleeRange(15 - 10)) or ((1318 - (1249 + 19)) >= (809 + 87))) then
						return "ferocious_bite cat 32";
					end
				end
				v153 = 15 - 11;
			end
		end
	end
	local function v132()
		local v154 = 1086 - (686 + 400);
		while true do
			if ((v154 == (0 + 0)) or ((1943 - (73 + 156)) >= (14 + 2944))) then
				if ((v99.HeartOfTheWild:IsCastable() and v31 and ((v99.ConvokeTheSpirits:CooldownRemains() < (841 - (721 + 90))) or (v99.ConvokeTheSpirits:CooldownRemains() > (2 + 88)) or not v99.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v99.HeartOfTheWild)) or ((4840 - 3349) < (1114 - (224 + 246)))) then
					if (((1139 - 435) < (1816 - 829)) and v24(v99.HeartOfTheWild)) then
						return "heart_of_the_wild owl 2";
					end
				end
				if (((675 + 3043) > (46 + 1860)) and v99.MoonkinForm:IsReady() and (v14:BuffDown(v99.MoonkinForm)) and v35) then
					if (v24(v99.MoonkinForm) or ((704 + 254) > (7226 - 3591))) then
						return "moonkin_form owl 4";
					end
				end
				v154 = 3 - 2;
			end
			if (((4014 - (203 + 310)) <= (6485 - (1238 + 755))) and (v154 == (1 + 0))) then
				if ((v99.Starsurge:IsReady() and ((v105 < (1540 - (709 + 825))) or (not v110 and (v105 < (14 - 6)))) and v35) or ((5013 - 1571) < (3412 - (196 + 668)))) then
					if (((11351 - 8476) >= (3032 - 1568)) and v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge))) then
						return "starsurge owl 8";
					end
				end
				if ((v99.Moonfire:IsReady() and ((v105 < (838 - (171 + 662))) or (not v110 and (v105 < (100 - (4 + 89)))))) or ((16813 - 12016) >= (1782 + 3111))) then
					if (v98.CastCycle(v99.Moonfire, v104, v123, not v16:IsSpellInRange(v99.Moonfire), nil, nil, v102.MoonfireMouseover) or ((2420 - 1869) > (811 + 1257))) then
						return "moonfire owl 10";
					end
				end
				v154 = 1488 - (35 + 1451);
			end
			if (((3567 - (28 + 1425)) > (2937 - (941 + 1052))) and (v154 == (3 + 0))) then
				if ((v99.Wrath:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(1522 - (822 + 692))) and ((v111 and (v105 == (1 - 0))) or v112 or (v114 and (v105 > (1 + 0))))) or ((2559 - (45 + 252)) >= (3064 + 32))) then
					if (v24(v99.Wrath, not v16:IsSpellInRange(v99.Wrath), true) or ((777 + 1478) >= (8607 - 5070))) then
						return "wrath owl 14";
					end
				end
				if (v99.Starfire:IsReady() or ((4270 - (114 + 319)) < (1874 - 568))) then
					if (((3780 - 830) == (1881 + 1069)) and v24(v99.Starfire, not v16:IsSpellInRange(v99.Starfire), true)) then
						return "starfire owl 16";
					end
				end
				break;
			end
			if ((v154 == (2 - 0)) or ((9895 - 5172) < (5261 - (556 + 1407)))) then
				if (((2342 - (741 + 465)) >= (619 - (170 + 295))) and v99.Sunfire:IsReady()) then
					if (v98.CastCycle(v99.Sunfire, v104, v121, not v16:IsSpellInRange(v99.Sunfire), nil, nil, v102.SunfireMouseover) or ((143 + 128) > (4362 + 386))) then
						return "sunfire owl 12";
					end
				end
				if (((11670 - 6930) >= (2613 + 539)) and v51 and v31 and v99.ConvokeTheSpirits:IsCastable()) then
					if (v14:BuffUp(v99.MoonkinForm) or ((1654 + 924) >= (1920 + 1470))) then
						if (((1271 - (957 + 273)) <= (445 + 1216)) and v24(v99.ConvokeTheSpirits, not v16:IsInRange(13 + 17))) then
							return "convoke_the_spirits moonkin 18";
						end
					end
				end
				v154 = 11 - 8;
			end
		end
	end
	local function v133()
		ShouldReturn = v98.InterruptWithStun(v99.IncapacitatingRoar, 21 - 13);
		if (((1835 - 1234) < (17627 - 14067)) and ShouldReturn) then
			return ShouldReturn;
		end
		if (((2015 - (389 + 1391)) < (432 + 255)) and v14:BuffUp(v99.CatForm) and (v14:ComboPoints() > (0 + 0))) then
			local v176 = 0 - 0;
			while true do
				if (((5500 - (783 + 168)) > (3869 - 2716)) and (v176 == (0 + 0))) then
					ShouldReturn = v98.InterruptWithStun(v99.Maim, 319 - (309 + 2));
					if (ShouldReturn or ((14353 - 9679) < (5884 - (1090 + 122)))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		ShouldReturn = v98.InterruptWithStun(v99.MightyBash, 3 + 5);
		if (((12318 - 8650) < (3122 + 1439)) and ShouldReturn) then
			return ShouldReturn;
		end
		v120();
		local v155 = 1118 - (628 + 490);
		if (v99.Rip:IsAvailable() or ((82 + 373) == (8925 - 5320))) then
			v155 = v155 + (4 - 3);
		end
		if (v99.Rake:IsAvailable() or ((3437 - (431 + 343)) == (6688 - 3376))) then
			v155 = v155 + (2 - 1);
		end
		if (((3379 + 898) <= (573 + 3902)) and v99.Thrash:IsAvailable()) then
			v155 = v155 + (1696 - (556 + 1139));
		end
		if (((v155 >= (17 - (6 + 9))) and v16:IsInMeleeRange(2 + 6)) or ((446 + 424) == (1358 - (28 + 141)))) then
			local v177 = 0 + 0;
			local v178;
			while true do
				if (((1916 - 363) <= (2219 + 914)) and (v177 == (1317 - (486 + 831)))) then
					v178 = v131();
					if (v178 or ((5821 - 3584) >= (12360 - 8849))) then
						return v178;
					end
					break;
				end
			end
		end
		if (v99.AdaptiveSwarm:IsCastable() or ((251 + 1073) > (9549 - 6529))) then
			if (v24(v99.AdaptiveSwarm, not v16:IsSpellInRange(v99.AdaptiveSwarm)) or ((4255 - (668 + 595)) == (1693 + 188))) then
				return "adaptive_swarm main";
			end
		end
		if (((627 + 2479) > (4161 - 2635)) and v99.MoonkinForm:IsAvailable()) then
			local v179 = v132();
			if (((3313 - (23 + 267)) < (5814 - (1129 + 815))) and v179) then
				return v179;
			end
		end
		if (((530 - (371 + 16)) > (1824 - (1326 + 424))) and v99.Sunfire:IsReady() and (v16:DebuffRefreshable(v99.SunfireDebuff))) then
			if (((33 - 15) < (7717 - 5605)) and v24(v99.Sunfire, not v16:IsSpellInRange(v99.Sunfire))) then
				return "sunfire main 24";
			end
		end
		if (((1215 - (88 + 30)) <= (2399 - (720 + 51))) and v99.Moonfire:IsReady() and (v16:DebuffRefreshable(v99.MoonfireDebuff))) then
			if (((10299 - 5669) == (6406 - (421 + 1355))) and v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if (((5840 - 2300) > (1318 + 1365)) and v99.Starsurge:IsReady() and (v14:BuffDown(v99.CatForm))) then
			if (((5877 - (286 + 797)) >= (11972 - 8697)) and v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge))) then
				return "starsurge main 28";
			end
		end
		if (((2457 - 973) == (1923 - (397 + 42))) and v99.Starfire:IsReady() and (v105 > (1 + 1))) then
			if (((2232 - (24 + 776)) < (5476 - 1921)) and v24(v99.Starfire, not v16:IsSpellInRange(v99.Starfire), true)) then
				return "starfire owl 16";
			end
		end
		if ((v99.Wrath:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(793 - (222 + 563)))) or ((2346 - 1281) > (2577 + 1001))) then
			if (v24(v99.Wrath, not v16:IsSpellInRange(v99.Wrath), true) or ((4985 - (23 + 167)) < (3205 - (690 + 1108)))) then
				return "wrath main 30";
			end
		end
		if (((669 + 1184) < (3970 + 843)) and v99.Moonfire:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(856 - (40 + 808)))) then
			if (v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire)) or ((465 + 2356) < (9296 - 6865))) then
				return "moonfire main 32";
			end
		end
		if (true or ((2747 + 127) < (1154 + 1027))) then
			if (v24(v99.Pool) or ((1475 + 1214) <= (914 - (47 + 524)))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v134()
		if ((v17 and v98.DispellableFriendlyUnit() and v99.NaturesCure:IsReady()) or ((1213 + 656) == (5491 - 3482))) then
			if (v24(v102.NaturesCureFocus) or ((5301 - 1755) < (5295 - 2973))) then
				return "natures_cure dispel 2";
			end
		end
	end
	local function v135()
		local v156 = 1726 - (1165 + 561);
		while true do
			if ((v156 == (1 + 0)) or ((6448 - 4366) == (1822 + 2951))) then
				if (((3723 - (341 + 138)) > (285 + 770)) and v100.Healthstone:IsReady() and v44 and (v14:HealthPercentage() <= v45)) then
					if (v24(v102.Healthstone, nil, nil, true) or ((6836 - 3523) <= (2104 - (89 + 237)))) then
						return "healthstone defensive 3";
					end
				end
				if ((v38 and (v14:HealthPercentage() <= v40)) or ((4571 - 3150) >= (4429 - 2325))) then
					if (((2693 - (581 + 300)) <= (4469 - (855 + 365))) and (v39 == "Refreshing Healing Potion")) then
						if (((3854 - 2231) <= (639 + 1318)) and v100.RefreshingHealingPotion:IsReady()) then
							if (((5647 - (1030 + 205)) == (4142 + 270)) and v24(v102.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((1628 + 122) >= (1128 - (156 + 130))) and (v156 == (0 - 0))) then
				if (((7367 - 2995) > (3789 - 1939)) and (v14:HealthPercentage() <= v94) and v95 and v99.Barkskin:IsReady()) then
					if (((62 + 170) < (479 + 342)) and v24(v99.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((587 - (10 + 59)) < (256 + 646)) and (v14:HealthPercentage() <= v96) and v97 and v99.Renewal:IsReady()) then
					if (((14744 - 11750) > (2021 - (671 + 492))) and v24(v99.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v156 = 1 + 0;
			end
		end
	end
	local function v136()
		local v157 = 1215 - (369 + 846);
		while true do
			if ((v157 == (1 + 0)) or ((3205 + 550) <= (2860 - (1036 + 909)))) then
				if (((3138 + 808) > (6284 - 2541)) and v99.Swiftmend:IsReady() and v129(v17)) then
					if (v24(v102.SwiftmendFocus) or ((1538 - (11 + 192)) >= (1671 + 1635))) then
						return "swiftmend ramp";
					end
				end
				if (((5019 - (135 + 40)) > (5458 - 3205)) and v14:BuffUp(v99.SoulOfTheForestBuff) and v99.Wildgrowth:IsReady()) then
					if (((273 + 179) == (995 - 543)) and v24(v102.WildgrowthFocus, nil, true)) then
						return "wildgrowth ramp";
					end
				end
				v157 = 2 - 0;
			end
			if ((v157 == (176 - (50 + 126))) or ((12689 - 8132) < (462 + 1625))) then
				if (((5287 - (1233 + 180)) == (4843 - (522 + 447))) and (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(1461 - (107 + 1314)))) then
					return;
				end
				if ((v99.Swiftmend:IsReady() and not v129(v17) and v14:BuffDown(v99.SoulOfTheForestBuff)) or ((900 + 1038) > (15037 - 10102))) then
					if (v24(v102.RejuvenationFocus) or ((1808 + 2447) < (6797 - 3374))) then
						return "rejuvenation ramp";
					end
				end
				v157 = 3 - 2;
			end
			if (((3364 - (716 + 1194)) <= (43 + 2448)) and (v157 == (1 + 1))) then
				if ((v99.Innervate:IsReady() and v14:BuffDown(v99.Innervate)) or ((4660 - (74 + 429)) <= (5406 - 2603))) then
					if (((2406 + 2447) >= (6825 - 3843)) and v24(v102.InnervatePlayer, nil, nil, true)) then
						return "innervate ramp";
					end
				end
				if (((2925 + 1209) > (10349 - 6992)) and v14:BuffUp(v99.Innervate) and (v128() > (0 - 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v99.Rejuvenation)) then
					if (v24(v102.RejuvenationMouseover) or ((3850 - (279 + 154)) < (3312 - (454 + 324)))) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
		end
	end
	local function v137()
		if (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(32 + 8) or ((2739 - (12 + 5)) <= (89 + 75))) then
			return;
		end
		if (v36 or ((6135 - 3727) < (780 + 1329))) then
			if (UseTrinkets or ((1126 - (277 + 816)) == (6217 - 4762))) then
				local v215 = 1183 - (1058 + 125);
				local v216;
				while true do
					if ((v215 == (0 + 0)) or ((1418 - (815 + 160)) >= (17226 - 13211))) then
						v216 = v130();
						if (((8028 - 4646) > (40 + 126)) and v216) then
							return v216;
						end
						break;
					end
				end
			end
			if ((v52 and v31 and v14:AffectingCombat() and (v127() > (8 - 5)) and v99.NaturesVigil:IsReady()) or ((2178 - (41 + 1857)) == (4952 - (1222 + 671)))) then
				if (((4861 - 2980) > (1857 - 564)) and v24(v99.NaturesVigil, nil, nil, true)) then
					return "natures_vigil healing";
				end
			end
			if (((3539 - (229 + 953)) == (4131 - (1111 + 663))) and v99.Swiftmend:IsReady() and v80 and v14:BuffDown(v99.SoulOfTheForestBuff) and v129(v17) and (v17:HealthPercentage() <= v81)) then
				if (((1702 - (874 + 705)) == (18 + 105)) and v24(v102.SwiftmendFocus)) then
					return "swiftmend healing";
				end
			end
			if ((v14:BuffUp(v99.SoulOfTheForestBuff) and v99.Wildgrowth:IsReady() and v98.AreUnitsBelowHealthPercentage(v89, v90)) or ((721 + 335) >= (7050 - 3658))) then
				if (v24(v102.WildgrowthFocus, nil, true) or ((31 + 1050) < (1754 - (642 + 37)))) then
					return "wildgrowth_sotf healing";
				end
			end
			if ((v55 and v99.GroveGuardians:IsReady() and (v99.GroveGuardians:TimeSinceLastCast() > (2 + 3)) and v98.AreUnitsBelowHealthPercentage(v56, v57)) or ((168 + 881) >= (11127 - 6695))) then
				if (v24(v102.GroveGuardiansFocus, nil, nil) or ((5222 - (233 + 221)) <= (1956 - 1110))) then
					return "grove_guardians healing";
				end
			end
			if ((v14:AffectingCombat() and v31 and v99.Flourish:IsReady() and v14:BuffDown(v99.Flourish) and (v127() > (4 + 0)) and v98.AreUnitsBelowHealthPercentage(v64, v65)) or ((4899 - (718 + 823)) <= (894 + 526))) then
				if (v24(v99.Flourish, nil, nil, true) or ((4544 - (266 + 539)) <= (8507 - 5502))) then
					return "flourish healing";
				end
			end
			if ((v14:AffectingCombat() and v31 and v99.Tranquility:IsReady() and v98.AreUnitsBelowHealthPercentage(v83, v84)) or ((2884 - (636 + 589)) >= (5065 - 2931))) then
				if (v24(v99.Tranquility, nil, true) or ((6723 - 3463) < (1867 + 488))) then
					return "tranquility healing";
				end
			end
			if ((v14:AffectingCombat() and v31 and v99.Tranquility:IsReady() and v14:BuffUp(v99.IncarnationBuff) and v98.AreUnitsBelowHealthPercentage(v86, v87)) or ((244 + 425) == (5238 - (657 + 358)))) then
				if (v24(v99.Tranquility, nil, true) or ((4479 - 2787) < (1339 - 751))) then
					return "tranquility_tree healing";
				end
			end
			if ((v14:AffectingCombat() and v31 and v99.ConvokeTheSpirits:IsReady() and v98.AreUnitsBelowHealthPercentage(v61, v62)) or ((5984 - (1151 + 36)) < (3526 + 125))) then
				if (v24(v99.ConvokeTheSpirits) or ((1099 + 3078) > (14484 - 9634))) then
					return "convoke_the_spirits healing";
				end
			end
			if ((v99.CenarionWard:IsReady() and v58 and (v17:HealthPercentage() <= v59)) or ((2232 - (1552 + 280)) > (1945 - (64 + 770)))) then
				if (((2072 + 979) > (2281 - 1276)) and v24(v102.CenarionWardFocus)) then
					return "cenarion_ward healing";
				end
			end
			if (((656 + 3037) <= (5625 - (157 + 1086))) and v14:BuffUp(v99.NaturesSwiftness) and v99.Regrowth:IsCastable()) then
				if (v24(v102.RegrowthFocus) or ((6568 - 3286) > (17956 - 13856))) then
					return "regrowth_swiftness healing";
				end
			end
			if ((v99.NaturesSwiftness:IsReady() and v72 and (v17:HealthPercentage() <= v73)) or ((5491 - 1911) < (3881 - 1037))) then
				if (((908 - (599 + 220)) < (8941 - 4451)) and v24(v99.NaturesSwiftness)) then
					return "natures_swiftness healing";
				end
			end
			if ((v66 == "Anyone") or ((6914 - (1813 + 118)) < (1322 + 486))) then
				if (((5046 - (841 + 376)) > (5280 - 1511)) and v99.IronBark:IsReady() and (v17:HealthPercentage() <= v67)) then
					if (((345 + 1140) <= (7926 - 5022)) and v24(v102.IronBarkFocus)) then
						return "iron_bark healing";
					end
				end
			elseif (((5128 - (464 + 395)) == (10955 - 6686)) and (v66 == "Tank Only")) then
				if (((186 + 201) <= (3619 - (467 + 370))) and v99.IronBark:IsReady() and (v17:HealthPercentage() <= v67) and (Commons.UnitGroupRole(v17) == "TANK")) then
					if (v24(v102.IronBarkFocus) or ((3923 - 2024) <= (674 + 243))) then
						return "iron_bark healing";
					end
				end
			elseif ((v66 == "Tank and Self") or ((14781 - 10469) <= (137 + 739))) then
				if (((5192 - 2960) <= (3116 - (150 + 370))) and v99.IronBark:IsReady() and (v17:HealthPercentage() <= v67) and ((Commons.UnitGroupRole(v17) == "TANK") or (Commons.UnitGroupRole(v17) == "HEALER"))) then
					if (((3377 - (74 + 1208)) < (9065 - 5379)) and v24(v102.IronBarkFocus)) then
						return "iron_bark healing";
					end
				end
			end
			if ((v99.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) or ((7564 - 5969) >= (3184 + 1290))) then
				if (v24(v102.AdaptiveSwarmFocus) or ((5009 - (14 + 376)) < (4998 - 2116))) then
					return "adaptive_swarm healing";
				end
			end
			if ((v14:AffectingCombat() and v68 and (v98.UnitGroupRole(v17) == "TANK") and (v98.FriendlyUnitsWithBuffCount(v99.Lifebloom, true, false) < (1 + 0)) and (v17:HealthPercentage() <= (v69 - (v26(v14:BuffUp(v99.CatForm)) * (14 + 1)))) and v99.Lifebloom:IsCastable() and v17:BuffRefreshable(v99.Lifebloom)) or ((281 + 13) >= (14155 - 9324))) then
				if (((1527 + 502) <= (3162 - (23 + 55))) and v24(v102.LifebloomFocus)) then
					return "lifebloom healing";
				end
			end
			if ((v14:AffectingCombat() and v70 and (v98.UnitGroupRole(v17) ~= "TANK") and (v98.FriendlyUnitsWithBuffCount(v99.Lifebloom, false, true) < (2 - 1)) and (v99.Undergrowth:IsAvailable() or v98.IsSoloMode()) and (v17:HealthPercentage() <= (v71 - (v26(v14:BuffUp(v99.CatForm)) * (11 + 4)))) and v99.Lifebloom:IsCastable() and v17:BuffRefreshable(v99.Lifebloom)) or ((1830 + 207) == (3752 - 1332))) then
				if (((1403 + 3055) > (4805 - (652 + 249))) and v24(v102.LifebloomFocus)) then
					return "lifebloom healing";
				end
			end
			if (((1166 - 730) >= (1991 - (708 + 1160))) and (v53 == "Player")) then
				if (((1357 - 857) < (3310 - 1494)) and v14:AffectingCombat() and (v99.Efflorescence:TimeSinceLastCast() > (42 - (10 + 17)))) then
					if (((803 + 2771) == (5306 - (1400 + 332))) and v24(v102.EfflorescencePlayer)) then
						return "efflorescence healing player";
					end
				end
			elseif (((423 - 202) < (2298 - (242 + 1666))) and (v53 == "Cursor")) then
				if ((v14:AffectingCombat() and (v99.Efflorescence:TimeSinceLastCast() > (7 + 8))) or ((812 + 1401) <= (1212 + 209))) then
					if (((3998 - (850 + 90)) < (8512 - 3652)) and v24(v102.EfflorescenceCursor)) then
						return "efflorescence healing cursor";
					end
				end
			elseif ((v53 == "Confirmation") or ((2686 - (360 + 1030)) >= (3935 + 511))) then
				if ((v14:AffectingCombat() and (v99.Efflorescence:TimeSinceLastCast() > (42 - 27))) or ((1915 - 522) > (6150 - (909 + 752)))) then
					if (v24(v99.Efflorescence) or ((5647 - (109 + 1114)) < (48 - 21))) then
						return "efflorescence healing confirmation";
					end
				end
			end
			if ((v99.Wildgrowth:IsReady() and v91 and v98.AreUnitsBelowHealthPercentage(v92, v93) and (not v99.Swiftmend:IsAvailable() or not v99.Swiftmend:IsReady())) or ((778 + 1219) > (4057 - (6 + 236)))) then
				if (((2184 + 1281) > (1540 + 373)) and v24(v102.WildgrowthFocus, nil, true)) then
					return "wildgrowth healing";
				end
			end
			if (((1728 - 995) < (3176 - 1357)) and v99.Regrowth:IsCastable() and v74 and (v17:HealthPercentage() <= v75)) then
				if (v24(v102.RegrowthFocus, nil, true) or ((5528 - (1076 + 57)) == (782 + 3973))) then
					return "regrowth healing";
				end
			end
			if ((v14:BuffUp(v99.Innervate) and (v128() > (689 - (579 + 110))) and v18 and v18:Exists() and v18:BuffRefreshable(v99.Rejuvenation)) or ((300 + 3493) < (2095 + 274))) then
				if (v24(v102.RejuvenationMouseover) or ((2168 + 1916) == (672 - (174 + 233)))) then
					return "rejuvenation_cycle healing";
				end
			end
			if (((12173 - 7815) == (7648 - 3290)) and v99.Rejuvenation:IsCastable() and v78 and v17:BuffRefreshable(v99.Rejuvenation) and (v17:HealthPercentage() <= v79)) then
				if (v24(v102.RejuvenationFocus) or ((1396 + 1742) < (2167 - (663 + 511)))) then
					return "rejuvenation healing";
				end
			end
			if (((2971 + 359) > (505 + 1818)) and v99.Regrowth:IsCastable() and v76 and v17:BuffUp(v99.Rejuvenation) and (v17:HealthPercentage() <= v77)) then
				if (v24(v102.RegrowthFocus, nil, true) or ((11178 - 7552) == (2416 + 1573))) then
					return "regrowth healing";
				end
			end
		end
	end
	local function v138()
		local v158 = 0 - 0;
		local v159;
		while true do
			if ((v158 == (7 - 4)) or ((438 + 478) == (5198 - 2527))) then
				if (((194 + 78) == (25 + 247)) and v98.TargetIsValid() and v34) then
					v159 = v133();
					if (((4971 - (478 + 244)) <= (5356 - (440 + 77))) and v159) then
						return v159;
					end
				end
				break;
			end
			if (((1263 + 1514) < (11712 - 8512)) and (v158 == (1558 - (655 + 901)))) then
				v159 = v137();
				if (((18 + 77) < (1499 + 458)) and v159) then
					return v159;
				end
				v158 = 3 + 0;
			end
			if (((3327 - 2501) < (3162 - (695 + 750))) and (v158 == (0 - 0))) then
				if (((2200 - 774) >= (4444 - 3339)) and (v43 or v42) and v32) then
					local v222 = v134();
					if (((3105 - (285 + 66)) <= (7876 - 4497)) and v222) then
						return v222;
					end
				end
				v159 = v135();
				v158 = 1311 - (682 + 628);
			end
			if ((v158 == (1 + 0)) or ((4226 - (176 + 123)) == (592 + 821))) then
				if (v159 or ((838 + 316) <= (1057 - (239 + 30)))) then
					return v159;
				end
				if (v33 or ((447 + 1196) > (3248 + 131))) then
					v159 = v136();
					if (v159 or ((4960 - 2157) > (14192 - 9643))) then
						return v159;
					end
				end
				v158 = 317 - (306 + 9);
			end
		end
	end
	local function v139()
		local v160 = 0 - 0;
		while true do
			if ((v160 == (1 + 0)) or ((135 + 85) >= (1455 + 1567))) then
				if (((8069 - 5247) == (4197 - (1140 + 235))) and v41 and v99.MarkOfTheWild:IsCastable() and (v14:BuffDown(v99.MarkOfTheWild, true) or v98.GroupBuffMissing(v99.MarkOfTheWild))) then
					if (v24(v102.MarkOfTheWildPlayer) or ((676 + 385) == (1703 + 154))) then
						return "mark_of_the_wild";
					end
				end
				if (((709 + 2051) > (1416 - (33 + 19))) and v98.TargetIsValid()) then
					if ((v99.Rake:IsReady() and (v14:StealthUp(false, true))) or ((1770 + 3132) <= (10775 - 7180))) then
						if (v24(v99.Rake, not v16:IsInMeleeRange(5 + 5)) or ((7553 - 3701) == (275 + 18))) then
							return "rake";
						end
					end
				end
				v160 = 691 - (586 + 103);
			end
			if ((v160 == (1 + 1)) or ((4799 - 3240) == (6076 - (1309 + 179)))) then
				if ((v98.TargetIsValid() and v34) or ((8094 - 3610) == (343 + 445))) then
					ShouldReturn = v133();
					if (((12267 - 7699) >= (2952 + 955)) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				break;
			end
			if (((2647 - 1401) < (6914 - 3444)) and (v160 == (609 - (295 + 314)))) then
				if (((9991 - 5923) >= (2934 - (1300 + 662))) and (v43 or v42) and v32) then
					local v223 = v134();
					if (((1547 - 1054) < (5648 - (1178 + 577))) and v223) then
						return v223;
					end
				end
				if ((v29 and v36) or ((765 + 708) >= (9849 - 6517))) then
					local v224 = 1405 - (851 + 554);
					local v225;
					while true do
						if (((0 + 0) == v224) or ((11234 - 7183) <= (2512 - 1355))) then
							v225 = v137();
							if (((906 - (115 + 187)) < (2207 + 674)) and v225) then
								return v225;
							end
							break;
						end
					end
				end
				v160 = 1 + 0;
			end
		end
	end
	local function v140()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (1161 - (160 + 1001))) or ((788 + 112) == (2331 + 1046))) then
				v37 = EpicSettings.Settings['UseRacials'];
				v38 = EpicSettings.Settings['UseHealingPotion'];
				v39 = EpicSettings.Settings['HealingPotionName'] or "";
				v40 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v41 = EpicSettings.Settings['UseMarkOfTheWild'];
				v161 = 359 - (237 + 121);
			end
			if (((5356 - (525 + 372)) > (1120 - 529)) and (v161 == (16 - 11))) then
				v62 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (142 - (96 + 46));
				v63 = EpicSettings.Settings['UseFlourish'];
				v64 = EpicSettings.Settings['FlourishHP'] or (777 - (643 + 134));
				v65 = EpicSettings.Settings['FlourishGroup'] or (0 + 0);
				v66 = EpicSettings.Settings['IronBarkUsage'] or "";
				v161 = 14 - 8;
			end
			if (((12615 - 9217) >= (2297 + 98)) and (v161 == (5 - 2))) then
				v52 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v53 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v54 = EpicSettings.Settings['EfflorescenceHP'] or (0 - 0);
				v55 = EpicSettings.Settings['UseGroveGuardians'];
				v56 = EpicSettings.Settings['GroveGuardiansHP'] or (719 - (316 + 403));
				v161 = 3 + 1;
			end
			if (((2 - 1) == v161) or ((789 + 1394) >= (7111 - 4287))) then
				v42 = EpicSettings.Settings['DispelDebuffs'];
				v43 = EpicSettings.Settings['DispelBuffs'];
				v44 = EpicSettings.Settings['UseHealthstone'];
				v45 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v46 = EpicSettings.Settings['HandleCharredTreant'];
				v161 = 1 + 1;
			end
			if (((6708 - 4772) == (9246 - 7310)) and (v161 == (7 - 3))) then
				v57 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 + 0);
				v58 = EpicSettings.Settings['UseCenarionWard'];
				v59 = EpicSettings.Settings['CenarionWardHP'] or (0 - 0);
				v60 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v61 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 + 0);
				v161 = 14 - 9;
			end
			if ((v161 == (23 - (12 + 5))) or ((18767 - 13935) < (9201 - 4888))) then
				v67 = EpicSettings.Settings['IronBarkHP'] or (0 - 0);
				break;
			end
			if (((10137 - 6049) > (787 + 3087)) and (v161 == (1975 - (1656 + 317)))) then
				v47 = EpicSettings.Settings['HandleCharredBrambles'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v51 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v161 = 3 + 0;
			end
		end
	end
	local function v141()
		local v162 = 0 - 0;
		while true do
			if (((21320 - 16988) == (4686 - (5 + 349))) and (v162 == (28 - 22))) then
				v86 = EpicSettings.Settings['TranquilityTreeHP'] or (1271 - (266 + 1005));
				v87 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
				v88 = EpicSettings.Settings['UseWildgrowthSotF'];
				v162 = 23 - 16;
			end
			if (((5264 - 1265) >= (4596 - (561 + 1135))) and (v162 == (9 - 2))) then
				v89 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
				v90 = EpicSettings.Settings['WildgrowthSotFGroup'] or (1066 - (507 + 559));
				v91 = EpicSettings.Settings['UseWildgrowth'];
				v162 = 20 - 12;
			end
			if ((v162 == (15 - 10)) or ((2913 - (212 + 176)) > (4969 - (250 + 655)))) then
				v83 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
				v84 = EpicSettings.Settings['TranquilityGroup'] or (0 - 0);
				v85 = EpicSettings.Settings['UseTranquilityTree'];
				v162 = 9 - 3;
			end
			if (((6327 - (1869 + 87)) == (15160 - 10789)) and (v162 == (1910 - (484 + 1417)))) then
				v95 = EpicSettings.Settings['UseBarkskin'];
				v96 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
				v97 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((4 - 1) == v162) or ((1039 - (48 + 725)) > (8145 - 3159))) then
				v77 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
				v78 = EpicSettings.Settings['UseRejuvenation'];
				v79 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
				v162 = 10 - 6;
			end
			if (((558 + 1433) >= (270 + 655)) and (v162 == (857 - (152 + 701)))) then
				v80 = EpicSettings.Settings['UseSwiftmend'];
				v81 = EpicSettings.Settings['SwiftmendHP'] or (1311 - (430 + 881));
				v82 = EpicSettings.Settings['UseTranquility'];
				v162 = 2 + 3;
			end
			if (((1350 - (557 + 338)) < (607 + 1446)) and (v162 == (22 - 14))) then
				v92 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
				v93 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v94 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v162 = 810 - (499 + 302);
			end
			if ((v162 == (866 - (39 + 827))) or ((2279 - 1453) == (10833 - 5982))) then
				v68 = EpicSettings.Settings['UseLifebloomTank'];
				v69 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
				v70 = EpicSettings.Settings['UseLifebloom'];
				v162 = 1 - 0;
			end
			if (((16 + 167) == (535 - 352)) and (v162 == (1 + 0))) then
				v71 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
				v72 = EpicSettings.Settings['UseNaturesSwiftness'];
				v73 = EpicSettings.Settings['NaturesSwiftnessHP'] or (104 - (103 + 1));
				v162 = 556 - (475 + 79);
			end
			if (((2505 - 1346) <= (5721 - 3933)) and (v162 == (1 + 1))) then
				v74 = EpicSettings.Settings['UseRegrowth'];
				v75 = EpicSettings.Settings['RegrowthHP'] or (0 + 0);
				v76 = EpicSettings.Settings['UseRegrowthRefresh'];
				v162 = 1506 - (1395 + 108);
			end
		end
	end
	local function v142()
		v140();
		v141();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['ramp'];
		v34 = EpicSettings.Toggles['dps'];
		v35 = EpicSettings.Toggles['dpsform'];
		v36 = EpicSettings.Toggles['healing'];
		if (v14:IsDeadOrGhost() or ((10204 - 6697) > (5522 - (7 + 1197)))) then
			return;
		end
		if (v14:AffectingCombat() or v42 or ((1341 + 1734) <= (1035 + 1930))) then
			local v180 = v42 and v99.NaturesCure:IsReady() and v32;
			if (((1684 - (27 + 292)) <= (5892 - 3881)) and v98.IsTankBelowHealthPercentage(v67) and v99.IronBark:IsReady() and ((v66 == "Tank Only") or (v66 == "Tank and Self"))) then
				local v217 = 0 - 0;
				while true do
					if ((v217 == (0 - 0)) or ((5473 - 2697) > (6808 - 3233))) then
						ShouldReturn = v98.FocusUnit(v180, nil, nil, "TANK", 159 - (43 + 96));
						if (ShouldReturn or ((10417 - 7863) == (10860 - 6056))) then
							return ShouldReturn;
						end
						break;
					end
				end
			elseif (((2139 + 438) == (728 + 1849)) and (v14:HealthPercentage() < v67) and v99.IronBark:IsReady() and (v66 == "Tank and Self")) then
				local v226 = 0 - 0;
				while true do
					if ((v226 == (0 + 0)) or ((10 - 4) >= (595 + 1294))) then
						ShouldReturn = v98.FocusUnit(v180, nil, nil, "HEALER", 2 + 18);
						if (((2257 - (1414 + 337)) <= (3832 - (1642 + 298))) and ShouldReturn) then
							return ShouldReturn;
						end
						break;
					end
				end
			else
				local v227 = 0 - 0;
				while true do
					if ((v227 == (0 - 0)) or ((5958 - 3950) > (730 + 1488))) then
						ShouldReturn = v98.FocusUnit(v180, nil, nil, nil, 16 + 4);
						if (((1351 - (357 + 615)) <= (2911 + 1236)) and ShouldReturn) then
							return ShouldReturn;
						end
						break;
					end
				end
			end
		end
		if (v14:IsMounted() or ((11075 - 6561) <= (865 + 144))) then
			return;
		end
		if (v14:IsMoving() or ((7491 - 3995) == (954 + 238))) then
			v103 = GetTime();
		end
		if (v14:BuffUp(v99.TravelForm) or v14:BuffUp(v99.BearForm) or v14:BuffUp(v99.CatForm) or ((15 + 193) == (1860 + 1099))) then
			if (((5578 - (384 + 917)) >= (2010 - (128 + 569))) and ((GetTime() - v103) < (1544 - (1407 + 136)))) then
				return;
			end
		end
		if (((4474 - (687 + 1200)) < (4884 - (556 + 1154))) and v30) then
			v104 = v16:GetEnemiesInSplashRange(28 - 20);
			v105 = #v104;
		else
			local v181 = 95 - (9 + 86);
			while true do
				if ((v181 == (421 - (275 + 146))) or ((671 + 3449) <= (2262 - (29 + 35)))) then
					v104 = {};
					v105 = 4 - 3;
					break;
				end
			end
		end
		if (v98.TargetIsValid() or v14:AffectingCombat() or ((4767 - 3171) == (3787 - 2929))) then
			local v182 = 0 + 0;
			while true do
				if (((4232 - (53 + 959)) == (3628 - (312 + 96))) and (v182 == (1 - 0))) then
					if ((v107 == (11396 - (147 + 138))) or ((2301 - (813 + 86)) > (3272 + 348))) then
						v107 = v10.FightRemains(v104, false);
					end
					break;
				end
				if (((4768 - 2194) == (3066 - (18 + 474))) and (v182 == (0 + 0))) then
					v106 = v10.BossFightRemains(nil, true);
					v107 = v106;
					v182 = 3 - 2;
				end
			end
		end
		if (((2884 - (860 + 226)) < (3060 - (121 + 182))) and v46) then
			ShouldReturn = v98.HandleCharredTreant(v99.Rejuvenation, v102.RejuvenationMouseover, 5 + 35);
			if (ShouldReturn or ((1617 - (988 + 252)) > (295 + 2309))) then
				return ShouldReturn;
			end
			ShouldReturn = v98.HandleCharredTreant(v99.Regrowth, v102.RegrowthMouseover, 13 + 27, true);
			if (((2538 - (49 + 1921)) < (1801 - (223 + 667))) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v98.HandleCharredTreant(v99.Swiftmend, v102.SwiftmendMouseover, 92 - (51 + 1));
			if (((5654 - 2369) < (9053 - 4825)) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v98.HandleCharredTreant(v99.Wildgrowth, v102.WildgrowthMouseover, 1165 - (146 + 979), true);
			if (((1106 + 2810) > (3933 - (311 + 294))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if (((6971 - 4471) < (1627 + 2212)) and v47) then
			local v183 = 1443 - (496 + 947);
			while true do
				if (((1865 - (1233 + 125)) == (206 + 301)) and (v183 == (2 + 0))) then
					ShouldReturn = v98.HandleCharredBrambles(v99.Swiftmend, v102.SwiftmendMouseover, 8 + 32);
					if (((1885 - (963 + 682)) <= (2642 + 523)) and ShouldReturn) then
						return ShouldReturn;
					end
					v183 = 1507 - (504 + 1000);
				end
				if (((562 + 272) >= (734 + 71)) and (v183 == (1 + 2))) then
					ShouldReturn = v98.HandleCharredBrambles(v99.Wildgrowth, v102.WildgrowthMouseover, 58 - 18, true);
					if (ShouldReturn or ((3257 + 555) < (1347 + 969))) then
						return ShouldReturn;
					end
					break;
				end
				if ((v183 == (182 - (156 + 26))) or ((1528 + 1124) <= (2397 - 864))) then
					ShouldReturn = v98.HandleCharredBrambles(v99.Rejuvenation, v102.RejuvenationMouseover, 204 - (149 + 15));
					if (ShouldReturn or ((4558 - (890 + 70)) < (1577 - (39 + 78)))) then
						return ShouldReturn;
					end
					v183 = 483 - (14 + 468);
				end
				if ((v183 == (2 - 1)) or ((11504 - 7388) < (616 + 576))) then
					ShouldReturn = v98.HandleCharredBrambles(v99.Regrowth, v102.RegrowthMouseover, 25 + 15, true);
					if (ShouldReturn or ((718 + 2659) <= (408 + 495))) then
						return ShouldReturn;
					end
					v183 = 1 + 1;
				end
			end
		end
		if (((7610 - 3634) >= (434 + 5)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v29) then
			local v184 = v98.DeadFriendlyUnitsCount();
			if (((13184 - 9432) == (95 + 3657)) and v14:AffectingCombat()) then
				if (((4097 - (12 + 39)) > (2508 + 187)) and v99.Rebirth:IsReady()) then
					if (v24(v99.Rebirth, nil, true) or ((10972 - 7427) == (11386 - 8189))) then
						return "rebirth";
					end
				end
			elseif (((710 + 1684) > (197 + 176)) and (v184 > (2 - 1))) then
				if (((2768 + 1387) <= (20452 - 16220)) and v24(v99.Revitalize, nil, true)) then
					return "revitalize";
				end
			elseif (v24(v99.Revive, not v16:IsInRange(1750 - (1596 + 114)), true) or ((9349 - 5768) == (4186 - (164 + 549)))) then
				return "revive";
			end
		end
		if (((6433 - (1059 + 379)) > (4156 - 808)) and v36 and (v14:AffectingCombat() or v29)) then
			local v185 = 0 + 0;
			while true do
				if ((v185 == (1 + 0)) or ((1146 - (145 + 247)) > (3056 + 668))) then
					DebugMessage = v137();
					if (((101 + 116) >= (168 - 111)) and DebugMessage) then
						return DebugMessage;
					end
					break;
				end
				if ((v185 == (0 + 0)) or ((1784 + 286) >= (6554 - 2517))) then
					DebugMessage = v136();
					if (((3425 - (254 + 466)) == (3265 - (544 + 16))) and DebugMessage) then
						return DebugMessage;
					end
					v185 = 2 - 1;
				end
			end
		end
		if (((689 - (294 + 334)) == (314 - (236 + 17))) and not v14:IsChanneling()) then
			if (v14:AffectingCombat() or ((302 + 397) >= (1009 + 287))) then
				local v218 = 0 - 0;
				local v219;
				while true do
					if ((v218 == (0 - 0)) or ((919 + 864) >= (2979 + 637))) then
						v219 = v138();
						if (v219 or ((4707 - (413 + 381)) > (191 + 4336))) then
							return v219;
						end
						break;
					end
				end
			elseif (((9306 - 4930) > (2122 - 1305)) and v29) then
				local v228 = 1970 - (582 + 1388);
				local v229;
				while true do
					if (((8282 - 3421) > (590 + 234)) and ((364 - (326 + 38)) == v228)) then
						v229 = v139();
						if (v229 or ((4090 - 2707) >= (3041 - 910))) then
							return v229;
						end
						break;
					end
				end
			end
		end
	end
	local function v143()
		local v171 = 620 - (47 + 573);
		while true do
			if ((v171 == (1 + 0)) or ((7967 - 6091) >= (4124 - 1583))) then
				v118();
				break;
			end
			if (((3446 - (1269 + 395)) <= (4264 - (76 + 416))) and (v171 == (443 - (319 + 124)))) then
				v22.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By BoomK");
				v171 = 2 - 1;
			end
		end
	end
	v22.SetAPL(1112 - (564 + 443), v142, v143);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

