local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4110 - (215 + 1059)) > (1656 - (171 + 991))) and not v5) then
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
	local v104 = 0 - 0;
	local v105, v106;
	local v107 = 29835 - 18724;
	local v108 = 27726 - 16615;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[11 + 2] and v20(v116[45 - 32])) or v20(0 - 0);
	local v118 = (v116[22 - 8] and v20(v116[43 - 29])) or v20(1248 - (111 + 1137));
	v9:RegisterForEvent(function()
		v116 = v13:GetEquipment();
		v117 = (v116[171 - (91 + 67)] and v20(v116[38 - 25])) or v20(0 + 0);
		v118 = (v116[537 - (423 + 100)] and v20(v116[1 + 13])) or v20(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v107 = 5792 + 5319;
		v108 = 11882 - (326 + 445);
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (v100.ImprovedNaturesCure:IsAvailable() or ((11896 - 9170) == (8618 - 4749))) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (711 - (530 + 181))) or ((5257 - (614 + 267)) <= (1513 - (19 + 13)))) then
					v99.DispellableDebuffs = v11.MergeTable(v99.DispellableMagicDebuffs, v99.DispellableDiseaseDebuffs);
					v99.DispellableDebuffs = v11.MergeTable(v99.DispellableDebuffs, v99.DispellableCurseDebuffs);
					break;
				end
			end
		else
			v99.DispellableDebuffs = v99.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v119();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v120()
		return (v13:StealthUp(true, true) and (1.6 - 0)) or (2 - 1);
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (0 + 0)) or ((5964 - 2572) >= (9831 - 5090))) then
				v109 = v13:BuffUp(v100.EclipseSolar) or v13:BuffUp(v100.EclipseLunar);
				v110 = v13:BuffUp(v100.EclipseSolar) and v13:BuffUp(v100.EclipseLunar);
				v145 = 1813 - (1293 + 519);
			end
			if (((6784 - 3459) >= (5623 - 3469)) and (v145 == (5 - 2))) then
				v115 = not v109 and (v100.Wrath:Count() > (0 - 0)) and (v100.Starfire:Count() > (0 - 0));
				break;
			end
			if ((v145 == (2 + 0)) or ((265 + 1030) >= (7511 - 4278))) then
				v113 = (not v109 and (((v100.Starfire:Count() == (0 + 0)) and (v100.Wrath:Count() > (0 + 0))) or v13:IsCasting(v100.Wrath))) or v112;
				v114 = (not v109 and (((v100.Wrath:Count() == (0 + 0)) and (v100.Starfire:Count() > (1096 - (709 + 387)))) or v13:IsCasting(v100.Starfire))) or v111;
				v145 = 1861 - (673 + 1185);
			end
			if (((12693 - 8316) > (5272 - 3630)) and (v145 == (1 - 0))) then
				v111 = v13:BuffUp(v100.EclipseLunar) and v13:BuffDown(v100.EclipseSolar);
				v112 = v13:BuffUp(v100.EclipseSolar) and v13:BuffDown(v100.EclipseLunar);
				v145 = 2 + 0;
			end
		end
	end
	local function v122(v146)
		return v146:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (4 + 1));
	end
	local function v123(v147)
		return (v147:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (15 - 3)) and ((((v106 <= (1 + 3)) or (v13:Energy() < (99 - 49))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (7 - 3)) or (v13:Energy() < (1930 - (446 + 1434)))) and v13:BuffUp(v100.HeartOfTheWild))) and v147:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(1284 - (1040 + 243), v100.Sunfire) and ((v147:DebuffUp(v100.MoonfireDebuff) and (v147:DebuffRemains(v100.MoonfireDebuff) < (v147:DebuffDuration(v100.MoonfireDebuff) * (0.8 - 0)))) or v147:DebuffDown(v100.MoonfireDebuff)) and (v106 == (1848 - (559 + 1288))));
	end
	local function v124(v148)
		return v148:DebuffRefreshable(v100.MoonfireDebuff) and (v148:TimeToDie() > (1936 - (609 + 1322)));
	end
	local function v125(v149)
		return ((v149:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (544 - (13 + 441))) and (v149:DebuffRemains(v100.Rip) <= (37 - 27)))) and (((v13:ComboPoints() == (13 - 8)) and (v149:TimeToDie() > (v149:DebuffRemains(v100.Rip) + (119 - 95)))) or (((v149:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (1 + 3))) < v149:TimeToDie()) and ((v149:DebuffRemains(v100.Rip) + (14 - 10) + (v13:ComboPoints() * (2 + 2))) > v149:TimeToDie())))) or (v149:DebuffDown(v100.Rip) and (v13:ComboPoints() > (1 + 1 + (v106 * (5 - 3)))));
	end
	local function v126(v150)
		return (v150:DebuffDown(v100.RakeDebuff) or v150:DebuffRefreshable(v100.RakeDebuff)) and (v150:TimeToDie() > (6 + 4)) and (v13:ComboPoints() < (8 - 3));
	end
	local function v127(v151)
		return (v151:DebuffUp(v100.AdaptiveSwarmDebuff));
	end
	local function v128()
		return v99.FriendlyUnitsWithBuffCount(v100.Rejuvenation) + v99.FriendlyUnitsWithBuffCount(v100.Regrowth) + v99.FriendlyUnitsWithBuffCount(v100.Wildgrowth);
	end
	local function v129()
		return v99.FriendlyUnitsWithoutBuffCount(v100.Rejuvenation);
	end
	local function v130(v152)
		return v152:BuffUp(v100.Rejuvenation) or v152:BuffUp(v100.Regrowth) or v152:BuffUp(v100.Wildgrowth);
	end
	local function v131()
		local v153 = 0 + 0;
		while true do
			if (((2627 + 2096) > (975 + 381)) and (v153 == (1 + 0))) then
				ShouldReturn = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 40 + 0, nil);
				if (ShouldReturn or ((4569 - (153 + 280)) <= (9913 - 6480))) then
					return ShouldReturn;
				end
				break;
			end
			if (((3812 + 433) <= (1829 + 2802)) and (v153 == (0 + 0))) then
				ShouldReturn = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 37 + 3, nil);
				if (((3099 + 1177) >= (5959 - 2045)) and ShouldReturn) then
					return ShouldReturn;
				end
				v153 = 1 + 0;
			end
		end
	end
	local function v132()
		local v154 = 667 - (89 + 578);
		while true do
			if (((142 + 56) <= (9074 - 4709)) and ((1051 - (572 + 477)) == v154)) then
				if (((645 + 4137) > (2807 + 1869)) and v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (1 + 4))) then
					if (((4950 - (84 + 2)) > (3620 - 1423)) and v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire))) then
						return "sunfire cat 24";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (4 + 1))) or ((4542 - (497 + 345)) == (65 + 2442))) then
					if (((757 + 3717) >= (1607 - (605 + 728))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
						return "moonfire cat 24";
					end
				end
				if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((1352 + 542) <= (3125 - 1719))) then
					if (((73 + 1499) >= (5660 - 4129)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				v154 = 3 + 0;
			end
			if ((v154 == (2 - 1)) or ((3539 + 1148) < (5031 - (457 + 32)))) then
				if (((1397 + 1894) > (3069 - (832 + 570))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
					if (v13:BuffUp(v100.CatForm) or ((823 + 50) == (531 + 1503))) then
						if (((v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (212 - 152)) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (25 + 25)) and (((v13:ComboPoints() < (801 - (588 + 208))) and (v15:DebuffRemains(v100.Rip) > (13 - 8))) or (v106 > (1801 - (884 + 916))))) or ((5895 - 3079) < (7 + 4))) then
							if (((4352 - (232 + 421)) < (6595 - (1569 + 320))) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(8 + 22))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if (((503 + 2143) >= (2951 - 2075)) and v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (610 - (316 + 289))) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (78 - 48)))) then
					if (((29 + 585) <= (4637 - (666 + 787))) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
						return "sunfire cat 20";
					end
				end
				if (((3551 - (360 + 65)) == (2922 + 204)) and v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (259 - (79 + 175))) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (47 - 17)))) then
					if (v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((1707 + 480) >= (15185 - 10231))) then
						return "moonfire cat 22";
					end
				end
				v154 = 3 - 1;
			end
			if (((903 - (503 + 396)) == v154) or ((4058 - (92 + 89)) == (6934 - 3359))) then
				if (((363 + 344) > (375 + 257)) and v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (42 - 31)) and v125(v15)) then
					if (v24(v100.Rip, not v15:IsInMeleeRange(1 + 4)) or ((1244 - 698) >= (2342 + 342))) then
						return "rip cat 34";
					end
				end
				if (((700 + 765) <= (13099 - 8798)) and v100.Thrash:IsReady() and (v106 >= (1 + 1)) and v15:DebuffRefreshable(v100.ThrashDebuff)) then
					if (((2598 - 894) > (2669 - (485 + 759))) and v24(v100.Thrash, not v15:IsInMeleeRange(18 - 10))) then
						return "thrash cat";
					end
				end
				if ((v100.Rake:IsReady() and v126(v15)) or ((1876 - (442 + 747)) == (5369 - (832 + 303)))) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(951 - (88 + 858))) or ((1015 + 2315) < (1183 + 246))) then
						return "rake cat 36";
					end
				end
				v154 = 1 + 4;
			end
			if (((1936 - (766 + 23)) >= (1653 - 1318)) and (v154 == (6 - 1))) then
				if (((9050 - 5615) > (7117 - 5020)) and v100.Rake:IsReady() and ((v13:ComboPoints() < (1078 - (1036 + 37))) or (v13:Energy() > (64 + 26))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(9 - 4)) or ((2966 + 804) >= (5521 - (641 + 839)))) then
						return "rake cat 40";
					end
				end
				if ((v100.Swipe:IsReady() and (v106 >= (915 - (910 + 3)))) or ((9664 - 5873) <= (3295 - (1466 + 218)))) then
					if (v24(v100.Swipe, not v15:IsInMeleeRange(4 + 4)) or ((5726 - (556 + 592)) <= (715 + 1293))) then
						return "swipe cat 38";
					end
				end
				if (((1933 - (329 + 479)) <= (2930 - (174 + 680))) and v100.Shred:IsReady() and ((v13:ComboPoints() < (17 - 12)) or (v13:Energy() > (186 - 96)))) then
					if (v24(v100.Shred, not v15:IsInMeleeRange(4 + 1)) or ((1482 - (396 + 343)) >= (390 + 4009))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if (((2632 - (29 + 1448)) < (3062 - (135 + 1254))) and (v154 == (0 - 0))) then
				if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((10850 - 8526) <= (386 + 192))) then
					if (((5294 - (389 + 1138)) == (4341 - (102 + 472))) and v24(v100.Rake, not v15:IsInMeleeRange(10 + 0))) then
						return "rake cat 2";
					end
				end
				if (((2268 + 1821) == (3813 + 276)) and v38 and not v13:StealthUp(false, true)) then
					local v218 = 1545 - (320 + 1225);
					local v219;
					while true do
						if (((7935 - 3477) >= (1025 + 649)) and ((1464 - (157 + 1307)) == v218)) then
							v219 = v131();
							if (((2831 - (821 + 1038)) <= (3537 - 2119)) and v219) then
								return v219;
							end
							break;
						end
					end
				end
				if (v100.AdaptiveSwarm:IsCastable() or ((541 + 4397) < (8458 - 3696))) then
					if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((932 + 1572) > (10568 - 6304))) then
						return "adaptive_swarm cat";
					end
				end
				v154 = 1027 - (834 + 192);
			end
			if (((137 + 2016) == (553 + 1600)) and (v154 == (1 + 2))) then
				if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (46 - 16)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (308 - (300 + 4))))) or ((136 + 371) >= (6782 - 4191))) then
					if (((4843 - (112 + 250)) == (1787 + 2694)) and v24(v100.HeartOfTheWild)) then
						return "heart_of_the_wild cat 26";
					end
				end
				if ((v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (75 - 45)) and v35) or ((1334 + 994) < (359 + 334))) then
					if (((3237 + 1091) == (2146 + 2182)) and v24(v100.CatForm)) then
						return "cat_form cat 28";
					end
				end
				if (((1180 + 408) >= (2746 - (1001 + 413))) and v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (6 - 3)) and (v15:TimeToDie() < (892 - (244 + 638)))) or ((v13:ComboPoints() == (698 - (627 + 66))) and (v13:Energy() >= (74 - 49)) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (607 - (512 + 90))))))) then
					if (v24(v100.FerociousBite, not v15:IsInMeleeRange(1911 - (1665 + 241))) or ((4891 - (373 + 344)) > (1916 + 2332))) then
						return "ferocious_bite cat 32";
					end
				end
				v154 = 2 + 2;
			end
		end
	end
	local function v133()
		if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (79 - 49)) or (v100.ConvokeTheSpirits:CooldownRemains() > (152 - 62)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) or ((5685 - (35 + 1064)) <= (60 + 22))) then
			if (((8264 - 4401) == (16 + 3847)) and v24(v100.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if ((v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) or ((1518 - (298 + 938)) <= (1301 - (233 + 1026)))) then
			if (((6275 - (636 + 1030)) >= (392 + 374)) and v24(v100.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if ((v100.Starsurge:IsReady() and ((v106 < (6 + 0)) or (not v111 and (v106 < (3 + 5)))) and v35) or ((78 + 1074) == (2709 - (55 + 166)))) then
			if (((664 + 2758) > (337 + 3013)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
				return "starsurge owl 8";
			end
		end
		if (((3349 - 2472) > (673 - (36 + 261))) and v100.Moonfire:IsReady() and ((v106 < (8 - 3)) or (not v111 and (v106 < (1375 - (34 + 1334)))))) then
			if (v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((1199 + 1919) <= (1439 + 412))) then
				return "moonfire owl 10";
			end
		end
		if (v100.Sunfire:IsReady() or ((1448 - (1035 + 248)) >= (3513 - (20 + 1)))) then
			if (((2058 + 1891) < (5175 - (134 + 185))) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if ((v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) or ((5409 - (549 + 584)) < (3701 - (314 + 371)))) then
			if (((16100 - 11410) > (5093 - (478 + 490))) and v13:BuffUp(v100.MoonkinForm)) then
				if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(16 + 14)) or ((1222 - (786 + 386)) >= (2901 - 2005))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if ((v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(1387 - (1055 + 324))) and ((v112 and (v106 == (1341 - (1093 + 247)))) or v113 or (v115 and (v106 > (1 + 0))))) or ((181 + 1533) >= (11743 - 8785))) then
			if (v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true) or ((5060 - 3569) < (1832 - 1188))) then
				return "wrath owl 14";
			end
		end
		if (((1768 - 1064) < (352 + 635)) and v100.Starfire:IsReady()) then
			if (((14323 - 10605) > (6569 - 4663)) and v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
	end
	local function v134()
		ShouldReturn = v99.InterruptWithStun(v100.IncapacitatingRoar, 7 + 1);
		if (ShouldReturn or ((2449 - 1491) > (4323 - (364 + 324)))) then
			return ShouldReturn;
		end
		if (((9597 - 6096) <= (10778 - 6286)) and v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 + 0))) then
			ShouldReturn = v99.InterruptWithStun(v100.Maim, 33 - 25);
			if (ShouldReturn or ((5511 - 2069) < (7738 - 5190))) then
				return ShouldReturn;
			end
		end
		ShouldReturn = v99.InterruptWithStun(v100.MightyBash, 1276 - (1249 + 19));
		if (((2596 + 279) >= (5698 - 4234)) and ShouldReturn) then
			return ShouldReturn;
		end
		v121();
		local v155 = 1086 - (686 + 400);
		if (v100.Rip:IsAvailable() or ((3764 + 1033) >= (5122 - (73 + 156)))) then
			v155 = v155 + 1 + 0;
		end
		if (v100.Rake:IsAvailable() or ((1362 - (721 + 90)) > (24 + 2044))) then
			v155 = v155 + (3 - 2);
		end
		if (((2584 - (224 + 246)) > (1528 - 584)) and v100.Thrash:IsAvailable()) then
			v155 = v155 + (1 - 0);
		end
		if (((v155 >= (1 + 1)) and v15:IsInMeleeRange(1 + 7)) or ((1662 + 600) >= (6155 - 3059))) then
			local v186 = v132();
			if (v186 or ((7504 - 5249) >= (4050 - (203 + 310)))) then
				return v186;
			end
		end
		if (v100.AdaptiveSwarm:IsCastable() or ((5830 - (1238 + 755)) < (92 + 1214))) then
			if (((4484 - (709 + 825)) == (5436 - 2486)) and v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm))) then
				return "adaptive_swarm main";
			end
		end
		if (v100.MoonkinForm:IsAvailable() or ((6879 - 2156) < (4162 - (196 + 668)))) then
			local v187 = v133();
			if (((4485 - 3349) >= (318 - 164)) and v187) then
				return v187;
			end
		end
		if ((v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) or ((1104 - (171 + 662)) > (4841 - (4 + 89)))) then
			if (((16613 - 11873) >= (1148 + 2004)) and v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire))) then
				return "sunfire main 24";
			end
		end
		if ((v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) or ((11323 - 8745) >= (1330 + 2060))) then
			if (((1527 - (35 + 1451)) <= (3114 - (28 + 1425))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if (((2594 - (941 + 1052)) < (3414 + 146)) and v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) then
			if (((1749 - (822 + 692)) < (980 - 293)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
				return "starsurge main 28";
			end
		end
		if (((2143 + 2406) > (1450 - (45 + 252))) and v100.Starfire:IsReady() and (v106 > (2 + 0))) then
			if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((1609 + 3065) < (11370 - 6698))) then
				return "starfire owl 16";
			end
		end
		if (((4101 - (114 + 319)) < (6548 - 1987)) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(9 - 1))) then
			if (v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true) or ((291 + 164) == (5370 - 1765))) then
				return "wrath main 30";
			end
		end
		if ((v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(16 - 8))) or ((4626 - (556 + 1407)) == (4518 - (741 + 465)))) then
			if (((4742 - (170 + 295)) <= (2358 + 2117)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (true or ((800 + 70) == (2927 - 1738))) then
			if (((1288 + 265) <= (2010 + 1123)) and v24(v100.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v135()
		if ((v16 and v99.DispellableFriendlyUnit() and v100.NaturesCure:IsReady()) or ((1267 + 970) >= (4741 - (957 + 273)))) then
			if (v24(v103.NaturesCureFocus) or ((355 + 969) > (1209 + 1811))) then
				return "natures_cure dispel 2";
			end
		end
	end
	local function v136()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (0 - 0)) or ((9138 - 6146) == (9314 - 7433))) then
				if (((4886 - (389 + 1391)) > (958 + 568)) and (v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) then
					if (((315 + 2708) < (8810 - 4940)) and v24(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((1094 - (783 + 168)) > (248 - 174)) and (v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) then
					if (((18 + 0) < (2423 - (309 + 2))) and v24(v100.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v156 = 2 - 1;
			end
			if (((2309 - (1090 + 122)) <= (528 + 1100)) and (v156 == (3 - 2))) then
				if (((3169 + 1461) == (5748 - (628 + 490))) and v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) then
					if (((635 + 2905) > (6642 - 3959)) and v24(v103.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (((21908 - 17114) >= (4049 - (431 + 343))) and v39 and (v13:HealthPercentage() <= v41)) then
					if (((2996 - 1512) == (4292 - 2808)) and (v40 == "Refreshing Healing Potion")) then
						if (((1132 + 300) < (455 + 3100)) and v101.RefreshingHealingPotion:IsReady()) then
							if (v24(v103.RefreshingHealingPotion, nil, nil, true) or ((2760 - (556 + 1139)) > (3593 - (6 + 9)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v137()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 + 0)) or ((4964 - (28 + 141)) < (545 + 862))) then
				if (((2286 - 433) < (3409 + 1404)) and (not v16 or not v16:Exists() or v16:IsDeadOrGhost() or not v16:IsInRange(1357 - (486 + 831)))) then
					return;
				end
				if ((v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) or ((7340 - 4519) < (8558 - 6127))) then
					if (v24(v103.RejuvenationFocus) or ((544 + 2330) < (6896 - 4715))) then
						return "rejuvenation ramp";
					end
				end
				v157 = 1264 - (668 + 595);
			end
			if ((v157 == (2 + 0)) or ((543 + 2146) <= (935 - 592))) then
				if ((v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) or ((2159 - (23 + 267)) == (3953 - (1129 + 815)))) then
					if (v24(v103.InnervatePlayer, nil, nil, true) or ((3933 - (371 + 16)) < (4072 - (1326 + 424)))) then
						return "innervate ramp";
					end
				end
				if ((v13:BuffUp(v100.Innervate) and (v129() > (0 - 0)) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((7608 - 5526) == (4891 - (88 + 30)))) then
					if (((4015 - (720 + 51)) > (2346 - 1291)) and v24(v103.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if ((v157 == (1777 - (421 + 1355))) or ((5465 - 2152) <= (874 + 904))) then
				if ((v100.Swiftmend:IsReady() and v130(v16)) or ((2504 - (286 + 797)) >= (7691 - 5587))) then
					if (((3000 - 1188) <= (3688 - (397 + 42))) and v24(v103.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				if (((507 + 1116) <= (2757 - (24 + 776))) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) then
					if (((6796 - 2384) == (5197 - (222 + 563))) and v24(v103.WildgrowthFocus, nil, true)) then
						return "wildgrowth ramp";
					end
				end
				v157 = 3 - 1;
			end
		end
	end
	local function v138()
		if (((1260 + 490) >= (1032 - (23 + 167))) and (not v16 or not v16:Exists() or v16:IsDeadOrGhost() or not v16:IsInRange(1838 - (690 + 1108)))) then
			return;
		end
		if (((1578 + 2794) > (1526 + 324)) and v36) then
			local v188 = 848 - (40 + 808);
			while true do
				if (((39 + 193) < (3139 - 2318)) and (v188 == (2 + 0))) then
					if (((275 + 243) < (495 + 407)) and v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63)) then
						if (((3565 - (47 + 524)) > (557 + 301)) and v24(v100.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					if ((v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) or ((10264 - 6509) <= (1368 - 453))) then
						if (((8999 - 5053) > (5469 - (1165 + 561))) and v24(v103.CenarionWardFocus)) then
							return "cenarion_ward healing";
						end
					end
					if ((v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) or ((40 + 1295) >= (10239 - 6933))) then
						if (((1849 + 2995) > (2732 - (341 + 138))) and v24(v103.RegrowthFocus)) then
							return "regrowth_swiftness healing";
						end
					end
					if (((123 + 329) == (932 - 480)) and v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) then
						if (v24(v100.NaturesSwiftness) or ((4883 - (89 + 237)) < (6713 - 4626))) then
							return "natures_swiftness healing";
						end
					end
					v188 = 6 - 3;
				end
				if (((4755 - (581 + 300)) == (5094 - (855 + 365))) and (v188 == (9 - 5))) then
					if ((v54 == "Player") or ((633 + 1305) > (6170 - (1030 + 205)))) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (15 + 0))) or ((3959 + 296) < (3709 - (156 + 130)))) then
							if (((3303 - 1849) <= (4197 - 1706)) and v24(v103.EfflorescencePlayer)) then
								return "efflorescence healing player";
							end
						end
					elseif ((v54 == "Cursor") or ((8513 - 4356) <= (739 + 2064))) then
						if (((2830 + 2023) >= (3051 - (10 + 59))) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (5 + 10))) then
							if (((20359 - 16225) > (4520 - (671 + 492))) and v24(v103.EfflorescenceCursor)) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v54 == "Confirmation") or ((2721 + 696) < (3749 - (369 + 846)))) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (4 + 11))) or ((2323 + 399) <= (2109 - (1036 + 909)))) then
							if (v24(v100.Efflorescence) or ((1915 + 493) < (3540 - 1431))) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) or ((236 - (11 + 192)) == (736 + 719))) then
						if (v24(v103.WildgrowthFocus, nil, true) or ((618 - (135 + 40)) >= (9727 - 5712))) then
							return "wildgrowth healing";
						end
					end
					if (((2039 + 1343) > (365 - 199)) and v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) then
						if (v24(v103.RegrowthFocus, nil, true) or ((419 - 139) == (3235 - (50 + 126)))) then
							return "regrowth healing";
						end
					end
					if (((5237 - 3356) > (287 + 1006)) and v13:BuffUp(v100.Innervate) and (v129() > (1413 - (1233 + 180))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) then
						if (((3326 - (522 + 447)) == (3778 - (107 + 1314))) and v24(v103.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					v188 = 3 + 2;
				end
				if (((374 - 251) == (53 + 70)) and (v188 == (5 - 2))) then
					if ((v67 == "Anyone") or ((4178 - 3122) >= (5302 - (716 + 1194)))) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) or ((19 + 1062) < (116 + 959))) then
							if (v24(v103.IronBarkFocus) or ((1552 - (74 + 429)) >= (8549 - 4117))) then
								return "iron_bark healing";
							end
						end
					elseif ((v67 == "Tank Only") or ((2364 + 2404) <= (1936 - 1090))) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v21.UnitGroupRole(v16) == "TANK")) or ((2376 + 982) <= (4377 - 2957))) then
							if (v24(v103.IronBarkFocus) or ((9244 - 5505) <= (3438 - (279 + 154)))) then
								return "iron_bark healing";
							end
						end
					elseif ((v67 == "Tank and Self") or ((2437 - (454 + 324)) >= (1679 + 455))) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v21.UnitGroupRole(v16) == "TANK") or (v21.UnitGroupRole(v16) == "HEALER"))) or ((3277 - (12 + 5)) < (1270 + 1085))) then
							if (v24(v103.IronBarkFocus) or ((1704 - 1035) == (1561 + 2662))) then
								return "iron_bark healing";
							end
						end
					end
					if ((v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) or ((2785 - (277 + 816)) < (2512 - 1924))) then
						if (v24(v103.AdaptiveSwarmFocus) or ((5980 - (1058 + 125)) < (685 + 2966))) then
							return "adaptive_swarm healing";
						end
					end
					if ((v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (976 - (815 + 160))) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (64 - 49)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((9915 - 5738) > (1157 + 3693))) then
						if (v24(v103.LifebloomFocus) or ((1169 - 769) > (3009 - (41 + 1857)))) then
							return "lifebloom healing";
						end
					end
					if (((4944 - (1222 + 671)) > (2597 - 1592)) and v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (1 - 0)) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (1197 - (229 + 953))))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
						if (((5467 - (1111 + 663)) <= (5961 - (874 + 705))) and v24(v103.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v188 = 1 + 3;
				end
				if ((v188 == (1 + 0)) or ((6821 - 3539) > (116 + 3984))) then
					if ((v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (684 - (642 + 37))) and v99.AreUnitsBelowHealthPercentage(v57, v58)) or ((817 + 2763) < (455 + 2389))) then
						if (((222 - 133) < (4944 - (233 + 221))) and v24(v103.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if ((v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (8 - 4)) and v99.AreUnitsBelowHealthPercentage(v65, v66)) or ((4386 + 597) < (3349 - (718 + 823)))) then
						if (((2410 + 1419) > (4574 - (266 + 539))) and v24(v100.Flourish, nil, nil, true)) then
							return "flourish healing";
						end
					end
					if (((4204 - 2719) <= (4129 - (636 + 589))) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85)) then
						if (((10133 - 5864) == (8804 - 4535)) and v24(v100.Tranquility, nil, true)) then
							return "tranquility healing";
						end
					end
					if (((307 + 80) <= (1011 + 1771)) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88)) then
						if (v24(v100.Tranquility, nil, true) or ((2914 - (657 + 358)) <= (2427 - 1510))) then
							return "tranquility_tree healing";
						end
					end
					v188 = 4 - 2;
				end
				if ((v188 == (1192 - (1151 + 36))) or ((4165 + 147) <= (231 + 645))) then
					if (((6665 - 4433) <= (4428 - (1552 + 280))) and v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) then
						if (((2929 - (64 + 770)) < (2503 + 1183)) and v24(v103.RejuvenationFocus)) then
							return "rejuvenation healing";
						end
					end
					if ((v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) or ((3620 - 2025) >= (795 + 3679))) then
						if (v24(v103.RegrowthFocus, nil, true) or ((5862 - (157 + 1086)) < (5768 - 2886))) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v188 == (0 - 0)) or ((450 - 156) >= (6593 - 1762))) then
					if (((2848 - (599 + 220)) <= (6141 - 3057)) and v38) then
						local v232 = v131();
						if (v232 or ((3968 - (1813 + 118)) == (1769 + 651))) then
							return v232;
						end
					end
					if (((5675 - (841 + 376)) > (5470 - 1566)) and v53 and v31 and v13:AffectingCombat() and (v128() > (1 + 2)) and v100.NaturesVigil:IsReady()) then
						if (((1190 - 754) >= (982 - (464 + 395))) and v24(v100.NaturesVigil, nil, nil, true)) then
							return "natures_vigil healing";
						end
					end
					if (((1283 - 783) < (873 + 943)) and v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) then
						if (((4411 - (467 + 370)) == (7385 - 3811)) and v24(v103.SwiftmendFocus)) then
							return "swiftmend healing";
						end
					end
					if (((163 + 58) < (1336 - 946)) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91)) then
						if (v24(v103.WildgrowthFocus, nil, true) or ((346 + 1867) <= (3305 - 1884))) then
							return "wildgrowth_sotf healing";
						end
					end
					v188 = 521 - (150 + 370);
				end
			end
		end
	end
	local function v139()
		local v158 = 1282 - (74 + 1208);
		local v159;
		while true do
			if (((7521 - 4463) < (23049 - 18189)) and (v158 == (0 + 0))) then
				if (((v44 or v43) and v32) or ((1686 - (14 + 376)) >= (7711 - 3265))) then
					local v220 = 0 + 0;
					local v221;
					while true do
						if ((v220 == (0 + 0)) or ((1329 + 64) > (13153 - 8664))) then
							v221 = v135();
							if (v221 or ((3329 + 1095) < (105 - (23 + 55)))) then
								return v221;
							end
							break;
						end
					end
				end
				v159 = v136();
				v158 = 2 - 1;
			end
			if ((v158 == (2 + 0)) or ((1794 + 203) > (5915 - 2100))) then
				v159 = v138();
				if (((1090 + 2375) > (2814 - (652 + 249))) and v159) then
					return v159;
				end
				v158 = 7 - 4;
			end
			if (((2601 - (708 + 1160)) < (4937 - 3118)) and (v158 == (5 - 2))) then
				if ((v99.TargetIsValid() and v34) or ((4422 - (10 + 17)) == (1068 + 3687))) then
					v159 = v134();
					if (v159 or ((5525 - (1400 + 332)) < (4543 - 2174))) then
						return v159;
					end
				end
				break;
			end
			if ((v158 == (1909 - (242 + 1666))) or ((1748 + 2336) == (98 + 167))) then
				if (((3715 + 643) == (5298 - (850 + 90))) and v159) then
					return v159;
				end
				if (v33 or ((5495 - 2357) < (2383 - (360 + 1030)))) then
					local v222 = 0 + 0;
					local v223;
					while true do
						if (((9399 - 6069) > (3195 - 872)) and (v222 == (1661 - (909 + 752)))) then
							v223 = v137();
							if (v223 or ((4849 - (109 + 1114)) == (7302 - 3313))) then
								return v223;
							end
							break;
						end
					end
				end
				v158 = 1 + 1;
			end
		end
	end
	local function v140()
		local v160 = 242 - (6 + 236);
		while true do
			if ((v160 == (0 + 0)) or ((738 + 178) == (6298 - 3627))) then
				if (((474 - 202) == (1405 - (1076 + 57))) and (v44 or v43) and v32) then
					local v224 = v135();
					if (((699 + 3550) <= (5528 - (579 + 110))) and v224) then
						return v224;
					end
				end
				if (((220 + 2557) < (2830 + 370)) and v29 and v36) then
					local v225 = v138();
					if (((51 + 44) < (2364 - (174 + 233))) and v225) then
						return v225;
					end
				end
				v160 = 2 - 1;
			end
			if (((1449 - 623) < (764 + 953)) and (v160 == (1175 - (663 + 511)))) then
				if (((1273 + 153) >= (240 + 865)) and v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) then
					if (((8490 - 5736) <= (2047 + 1332)) and v24(v103.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (v99.TargetIsValid() or ((9245 - 5318) == (3420 - 2007))) then
					if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((551 + 603) <= (1533 - 745))) then
						if (v24(v100.Rake, not v15:IsInMeleeRange(8 + 2)) or ((151 + 1492) > (4101 - (478 + 244)))) then
							return "rake";
						end
					end
				end
				v160 = 519 - (440 + 77);
			end
			if ((v160 == (1 + 1)) or ((10258 - 7455) > (6105 - (655 + 901)))) then
				if ((v99.TargetIsValid() and v34) or ((41 + 179) >= (2314 + 708))) then
					local v226 = v134();
					if (((1906 + 916) == (11368 - 8546)) and v226) then
						return v226;
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v161 = 1445 - (695 + 750);
		while true do
			if (((16 - 11) == v161) or ((1637 - 576) == (7468 - 5611))) then
				v57 = EpicSettings.Settings['GroveGuardiansHP'] or (351 - (285 + 66));
				v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
				v59 = EpicSettings.Settings['UseCenarionWard'];
				v60 = EpicSettings.Settings['CenarionWardHP'] or (1310 - (682 + 628));
				v161 = 1 + 5;
			end
			if (((3059 - (176 + 123)) > (571 + 793)) and (v161 == (5 + 1))) then
				v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (269 - (239 + 30));
				v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
				v64 = EpicSettings.Settings['UseFlourish'];
				v161 = 7 + 0;
			end
			if ((v161 == (12 - 5)) or ((15293 - 10391) <= (3910 - (306 + 9)))) then
				v65 = EpicSettings.Settings['FlourishHP'] or (0 - 0);
				v66 = EpicSettings.Settings['FlourishGroup'] or (0 + 0);
				v67 = EpicSettings.Settings['IronBarkUsage'] or "";
				v68 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
				break;
			end
			if (((0 + 0) == v161) or ((11014 - 7162) == (1668 - (1140 + 235)))) then
				v37 = EpicSettings.Settings['UseRacials'];
				v38 = EpicSettings.Settings['UseTrinkets'];
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v161 = 1 + 0;
			end
			if ((v161 == (3 + 0)) or ((401 + 1158) == (4640 - (33 + 19)))) then
				v49 = EpicSettings.Settings['InterruptWithStun'];
				v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v51 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v161 = 11 - 7;
			end
			if ((v161 == (1 + 0)) or ((8793 - 4309) == (739 + 49))) then
				v41 = EpicSettings.Settings['HealingPotionHP'] or (689 - (586 + 103));
				v42 = EpicSettings.Settings['UseMarkOfTheWild'];
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v161 = 1 + 1;
			end
			if (((14063 - 9495) >= (5395 - (1309 + 179))) and (v161 == (2 - 0))) then
				v45 = EpicSettings.Settings['UseHealthstone'];
				v46 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v47 = EpicSettings.Settings['HandleCharredTreant'];
				v48 = EpicSettings.Settings['HandleCharredBrambles'];
				v161 = 7 - 4;
			end
			if (((942 + 304) < (7372 - 3902)) and (v161 == (7 - 3))) then
				v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v55 = EpicSettings.Settings['EfflorescenceHP'] or (609 - (295 + 314));
				v56 = EpicSettings.Settings['UseGroveGuardians'];
				v161 = 12 - 7;
			end
		end
	end
	local function v142()
		v69 = EpicSettings.Settings['UseLifebloomTank'];
		v70 = EpicSettings.Settings['LifebloomTankHP'] or (1962 - (1300 + 662));
		v71 = EpicSettings.Settings['UseLifebloom'];
		v72 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
		v73 = EpicSettings.Settings['UseNaturesSwiftness'];
		v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (1755 - (1178 + 577));
		v75 = EpicSettings.Settings['UseRegrowth'];
		v76 = EpicSettings.Settings['RegrowthHP'] or (0 + 0);
		v77 = EpicSettings.Settings['UseRegrowthRefresh'];
		v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
		v79 = EpicSettings.Settings['UseRejuvenation'];
		v80 = EpicSettings.Settings['RejuvenationHP'] or (1405 - (851 + 554));
		v81 = EpicSettings.Settings['UseSwiftmend'];
		v82 = EpicSettings.Settings['SwiftmendHP'] or (0 + 0);
		v83 = EpicSettings.Settings['UseTranquility'];
		v84 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v85 = EpicSettings.Settings['TranquilityGroup'] or (0 - 0);
		v86 = EpicSettings.Settings['UseTranquilityTree'];
		v87 = EpicSettings.Settings['TranquilityTreeHP'] or (302 - (115 + 187));
		v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
		v89 = EpicSettings.Settings['UseWildgrowthSotF'];
		v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 + 0);
		v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
		v92 = EpicSettings.Settings['UseWildgrowth'];
		v93 = EpicSettings.Settings['WildgrowthHP'] or (1161 - (160 + 1001));
		v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 + 0);
		v95 = EpicSettings.Settings['BarkskinHP'] or (0 + 0);
		v96 = EpicSettings.Settings['UseBarkskin'];
		v97 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
		v98 = EpicSettings.Settings['UseRenewal'];
	end
	local function v143()
		v141();
		v142();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['ramp'];
		v34 = EpicSettings.Toggles['dps'];
		v35 = EpicSettings.Toggles['dpsform'];
		v36 = EpicSettings.Toggles['healing'];
		if (((4426 - (237 + 121)) >= (1869 - (525 + 372))) and v13:IsDeadOrGhost()) then
			return;
		end
		if (((933 - 440) < (12790 - 8897)) and (v13:AffectingCombat() or v43)) then
			local v189 = v43 and v100.NaturesCure:IsReady() and v32;
			if ((v99.IsTankBelowHealthPercentage(v68) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) or ((1615 - (96 + 46)) >= (4109 - (643 + 134)))) then
				local v215 = v99.FocusUnit(v189, nil, nil, "TANK", 8 + 12);
				if (v215 or ((9713 - 5662) <= (4295 - 3138))) then
					return v215;
				end
			elseif (((580 + 24) < (5653 - 2772)) and (v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) then
				local v227 = 0 - 0;
				local v228;
				while true do
					if ((v227 == (719 - (316 + 403))) or ((599 + 301) == (9284 - 5907))) then
						v228 = v99.FocusUnit(v189, nil, nil, "HEALER", 8 + 12);
						if (((11229 - 6770) > (419 + 172)) and v228) then
							return v228;
						end
						break;
					end
				end
			else
				local v229 = 0 + 0;
				local v230;
				while true do
					if (((11773 - 8375) >= (11438 - 9043)) and (v229 == (0 - 0))) then
						v230 = v99.FocusUnit(v189, nil, nil, nil, 2 + 18);
						if (v230 or ((4297 - 2114) >= (138 + 2686))) then
							return v230;
						end
						break;
					end
				end
			end
		end
		if (((5695 - 3759) == (1953 - (12 + 5))) and v13:IsMounted()) then
			return;
		end
		if (v13:IsMoving() or ((18767 - 13935) < (9201 - 4888))) then
			v104 = GetTime();
		end
		if (((8689 - 4601) > (9606 - 5732)) and (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm))) then
			if (((880 + 3452) == (6305 - (1656 + 317))) and ((GetTime() - v104) < (1 + 0))) then
				return;
			end
		end
		if (((3205 + 794) >= (7711 - 4811)) and v30) then
			v105 = v15:GetEnemiesInSplashRange(39 - 31);
			v106 = #v105;
		else
			local v190 = 354 - (5 + 349);
			while true do
				if ((v190 == (0 - 0)) or ((3796 - (266 + 1005)) > (2679 + 1385))) then
					v105 = {};
					v106 = 3 - 2;
					break;
				end
			end
		end
		if (((5754 - 1383) == (6067 - (561 + 1135))) and (v99.TargetIsValid() or v13:AffectingCombat())) then
			local v191 = 0 - 0;
			while true do
				if (((0 - 0) == v191) or ((1332 - (507 + 559)) > (12511 - 7525))) then
					v107 = v9.BossFightRemains(nil, true);
					v108 = v107;
					v191 = 3 - 2;
				end
				if (((2379 - (212 + 176)) >= (1830 - (250 + 655))) and (v191 == (2 - 1))) then
					if (((795 - 340) < (3211 - 1158)) and (v108 == (13067 - (1869 + 87)))) then
						v108 = v9.FightRemains(v105, false);
					end
					break;
				end
			end
		end
		if (v47 or ((2864 - 2038) == (6752 - (484 + 1417)))) then
			local v192 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 85 - 45);
			if (((305 - 122) == (956 - (48 + 725))) and v192) then
				return v192;
			end
			local v192 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 65 - 25, true);
			if (((3109 - 1950) <= (1040 + 748)) and v192) then
				return v192;
			end
			local v192 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 106 - 66);
			if (v192 or ((982 + 2525) > (1259 + 3059))) then
				return v192;
			end
			local v192 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 893 - (152 + 701), true);
			if (v192 or ((4386 - (430 + 881)) <= (1136 + 1829))) then
				return v192;
			end
		end
		if (((2260 - (557 + 338)) <= (595 + 1416)) and v48) then
			local v193 = 0 - 0;
			local v194;
			while true do
				if ((v193 == (3 - 2)) or ((7374 - 4598) > (7704 - 4129))) then
					v194 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 841 - (499 + 302), true);
					if (v194 or ((3420 - (39 + 827)) == (13261 - 8457))) then
						return v194;
					end
					v193 = 4 - 2;
				end
				if (((10235 - 7658) == (3956 - 1379)) and (v193 == (1 + 1))) then
					v194 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 117 - 77);
					if (v194 or ((1 + 5) >= (2988 - 1099))) then
						return v194;
					end
					v193 = 107 - (103 + 1);
				end
				if (((1060 - (475 + 79)) <= (4089 - 2197)) and (v193 == (9 - 6))) then
					v194 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 6 + 34, true);
					if (v194 or ((1768 + 240) > (3721 - (1395 + 108)))) then
						return v194;
					end
					break;
				end
				if (((1102 - 723) <= (5351 - (7 + 1197))) and (v193 == (0 + 0))) then
					v194 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 14 + 26);
					if (v194 or ((4833 - (27 + 292)) <= (2956 - 1947))) then
						return v194;
					end
					v193 = 1 - 0;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) or ((14661 - 11165) == (2350 - 1158))) then
			local v195 = v99.DeadFriendlyUnitsCount();
			if (v13:AffectingCombat() or ((395 - 187) == (3098 - (43 + 96)))) then
				if (((17446 - 13169) >= (2968 - 1655)) and v100.Rebirth:IsReady()) then
					if (((2147 + 440) < (897 + 2277)) and v24(v100.Rebirth, nil, true)) then
						return "rebirth";
					end
				end
			elseif ((v195 > (1 - 0)) or ((1580 + 2540) <= (4119 - 1921))) then
				if (v24(v100.Revitalize, nil, true) or ((503 + 1093) == (63 + 795))) then
					return "revitalize";
				end
			elseif (((4971 - (1414 + 337)) == (5160 - (1642 + 298))) and v24(v100.Revive, not v15:IsInRange(104 - 64), true)) then
				return "revive";
			end
		end
		if ((v36 and (v13:AffectingCombat() or v29)) or ((4033 - 2631) > (10742 - 7122))) then
			local v196 = 0 + 0;
			local v197;
			while true do
				if (((2003 + 571) == (3546 - (357 + 615))) and (v196 == (1 + 0))) then
					v197 = v138();
					if (((4411 - 2613) < (2363 + 394)) and v197) then
						return v197;
					end
					break;
				end
				if ((v196 == (0 - 0)) or ((302 + 75) > (177 + 2427))) then
					v197 = v137();
					if (((358 + 210) < (2212 - (384 + 917))) and v197) then
						return v197;
					end
					v196 = 698 - (128 + 569);
				end
			end
		end
		if (((4828 - (1407 + 136)) < (6115 - (687 + 1200))) and not v13:IsChanneling()) then
			if (((5626 - (556 + 1154)) > (11708 - 8380)) and v13:AffectingCombat()) then
				local v216 = v139();
				if (((2595 - (9 + 86)) < (4260 - (275 + 146))) and v216) then
					return v216;
				end
			elseif (((83 + 424) == (571 - (29 + 35))) and v29) then
				local v231 = v140();
				if (((1063 - 823) <= (9453 - 6288)) and v231) then
					return v231;
				end
			end
		end
	end
	local function v144()
		v22.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v119();
	end
	v22.SetAPL(463 - 358, v143, v144);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

