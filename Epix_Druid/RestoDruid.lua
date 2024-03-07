local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (712 - (530 + 181))) or ((2237 - (614 + 267)) > (4755 - (19 + 13)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((9637 - 5501) <= (9806 - 6373))) then
			v6 = v0[v4];
			if (((1103 + 3142) <= (8144 - 3513)) and not v6) then
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
	local v105 = 1812 - (1293 + 519);
	local v106, v107;
	local v108 = 22669 - 11558;
	local v109 = 29010 - 17899;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = false;
	local v117 = v14:GetEquipment();
	local v118 = (v117[24 - 11] and v21(v117[56 - 43])) or v21(0 - 0);
	local v119 = (v117[8 + 6] and v21(v117[3 + 11])) or v21(0 - 0);
	v10:RegisterForEvent(function()
		v117 = v14:GetEquipment();
		v118 = (v117[4 + 9] and v21(v117[5 + 8])) or v21(0 + 0);
		v119 = (v117[1110 - (709 + 387)] and v21(v117[1872 - (673 + 1185)])) or v21(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v147 = 0 - 0;
		while true do
			if (((7035 - 2759) >= (2800 + 1114)) and (v147 == (0 + 0))) then
				v108 = 15001 - 3890;
				v109 = 2729 + 8382;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v120()
		if (((394 - 196) <= (8568 - 4203)) and v101.ImprovedNaturesCure:IsAvailable()) then
			local v197 = 1880 - (446 + 1434);
			while true do
				if (((6065 - (1040 + 243)) > (13956 - 9280)) and (v197 == (1847 - (559 + 1288)))) then
					v100.DispellableDebuffs = v12.MergeTable(v100.DispellableMagicDebuffs, v100.DispellableDiseaseDebuffs);
					v100.DispellableDebuffs = v12.MergeTable(v100.DispellableDebuffs, v100.DispellableCurseDebuffs);
					break;
				end
			end
		else
			v100.DispellableDebuffs = v100.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v120();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v121()
		return (v14:StealthUp(true, true) and (1932.6 - (609 + 1322))) or (455 - (13 + 441));
	end
	v101.Rake:RegisterPMultiplier(v101.RakeDebuff, v121);
	local function v122()
		local v148 = 0 - 0;
		while true do
			if (((12740 - 7876) > (10942 - 8745)) and (v148 == (0 + 0))) then
				v110 = v14:BuffUp(v101.EclipseSolar) or v14:BuffUp(v101.EclipseLunar);
				v111 = v14:BuffUp(v101.EclipseSolar) and v14:BuffUp(v101.EclipseLunar);
				v148 = 3 - 2;
			end
			if ((v148 == (2 + 1)) or ((1622 + 2078) == (7439 - 4932))) then
				v116 = not v110 and (v101.Wrath:Count() > (0 + 0)) and (v101.Starfire:Count() > (0 - 0));
				break;
			end
			if (((2958 + 1516) >= (153 + 121)) and (v148 == (2 + 0))) then
				v114 = (not v110 and (((v101.Starfire:Count() == (0 + 0)) and (v101.Wrath:Count() > (0 + 0))) or v14:IsCasting(v101.Wrath))) or v113;
				v115 = (not v110 and (((v101.Wrath:Count() == (433 - (153 + 280))) and (v101.Starfire:Count() > (0 - 0))) or v14:IsCasting(v101.Starfire))) or v112;
				v148 = 3 + 0;
			end
			if ((v148 == (1 + 0)) or ((992 + 902) <= (1276 + 130))) then
				v112 = v14:BuffUp(v101.EclipseLunar) and v14:BuffDown(v101.EclipseSolar);
				v113 = v14:BuffUp(v101.EclipseSolar) and v14:BuffDown(v101.EclipseLunar);
				v148 = 2 + 0;
			end
		end
	end
	local function v123(v149)
		return v149:DebuffRefreshable(v101.SunfireDebuff) and (v109 > (7 - 2));
	end
	local function v124(v150)
		return (v150:DebuffRefreshable(v101.MoonfireDebuff) and (v109 > (8 + 4)) and ((((v107 <= (671 - (89 + 578))) or (v14:Energy() < (36 + 14))) and v14:BuffDown(v101.HeartOfTheWild)) or (((v107 <= (8 - 4)) or (v14:Energy() < (1099 - (572 + 477)))) and v14:BuffUp(v101.HeartOfTheWild))) and v150:DebuffDown(v101.MoonfireDebuff)) or (v14:PrevGCD(1 + 0, v101.Sunfire) and ((v150:DebuffUp(v101.MoonfireDebuff) and (v150:DebuffRemains(v101.MoonfireDebuff) < (v150:DebuffDuration(v101.MoonfireDebuff) * (0.8 + 0)))) or v150:DebuffDown(v101.MoonfireDebuff)) and (v107 == (1 + 0)));
	end
	local function v125(v151)
		return v151:DebuffRefreshable(v101.MoonfireDebuff) and (v151:TimeToDie() > (91 - (84 + 2)));
	end
	local function v126(v152)
		return ((v152:DebuffRefreshable(v101.Rip) or ((v14:Energy() > (148 - 58)) and (v152:DebuffRemains(v101.Rip) <= (8 + 2)))) and (((v14:ComboPoints() == (847 - (497 + 345))) and (v152:TimeToDie() > (v152:DebuffRemains(v101.Rip) + 1 + 23))) or (((v152:DebuffRemains(v101.Rip) + (v14:ComboPoints() * (1 + 3))) < v152:TimeToDie()) and ((v152:DebuffRemains(v101.Rip) + (1337 - (605 + 728)) + (v14:ComboPoints() * (3 + 1))) > v152:TimeToDie())))) or (v152:DebuffDown(v101.Rip) and (v14:ComboPoints() > ((3 - 1) + (v107 * (1 + 1)))));
	end
	local function v127(v153)
		return (v153:DebuffDown(v101.RakeDebuff) or v153:DebuffRefreshable(v101.RakeDebuff)) and (v153:TimeToDie() > (36 - 26)) and (v14:ComboPoints() < (5 + 0));
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
		local v156 = v100.HandleTopTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 110 - 70, nil);
		if (((1187 + 385) >= (2020 - (457 + 32))) and v156) then
			return v156;
		end
		local v156 = v100.HandleBottomTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 17 + 23, nil);
		if (v156 or ((6089 - (832 + 570)) < (4279 + 263))) then
			return v156;
		end
	end
	local function v133()
		if (((859 + 2432) > (5898 - 4231)) and v101.Rake:IsReady() and (v14:StealthUp(false, true))) then
			if (v25(v101.Rake, not v16:IsInMeleeRange(5 + 5)) or ((1669 - (588 + 208)) == (5481 - 3447))) then
				return "rake cat 2";
			end
		end
		if ((v39 and not v14:StealthUp(false, true)) or ((4616 - (884 + 916)) < (22 - 11))) then
			local v200 = 0 + 0;
			local v201;
			while true do
				if (((4352 - (232 + 421)) < (6595 - (1569 + 320))) and (v200 == (0 + 0))) then
					v201 = v132();
					if (((503 + 2143) >= (2951 - 2075)) and v201) then
						return v201;
					end
					break;
				end
			end
		end
		if (((1219 - (316 + 289)) <= (8334 - 5150)) and v101.AdaptiveSwarm:IsCastable()) then
			if (((145 + 2981) == (4579 - (666 + 787))) and v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm))) then
				return "adaptive_swarm cat";
			end
		end
		if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((2612 - (360 + 65)) >= (4630 + 324))) then
			if (v14:BuffUp(v101.CatForm) or ((4131 - (79 + 175)) == (5637 - 2062))) then
				if (((552 + 155) > (1936 - 1304)) and (v14:BuffUp(v101.HeartOfTheWild) or (v101.HeartOfTheWild:CooldownRemains() > (115 - 55)) or not v101.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (949 - (503 + 396))) and (((v14:ComboPoints() < (186 - (92 + 89))) and (v16:DebuffRemains(v101.Rip) > (9 - 4))) or (v107 > (1 + 0)))) then
					if (v25(v101.ConvokeTheSpirits, not v16:IsInRange(18 + 12)) or ((2138 - 1592) >= (368 + 2316))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((3340 - 1875) <= (3753 + 548)) and v101.Sunfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (3 + 2)) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (91 - 61)))) then
			if (((213 + 1491) > (2173 - 748)) and v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover)) then
				return "sunfire cat 20";
			end
		end
		if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (1249 - (485 + 759))) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (69 - 39)))) or ((1876 - (442 + 747)) == (5369 - (832 + 303)))) then
			if (v100.CastCycle(v101.Moonfire, v106, v124, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((4276 - (88 + 858)) < (436 + 993))) then
				return "moonfire cat 22";
			end
		end
		if (((950 + 197) >= (14 + 321)) and v101.Sunfire:IsReady() and v16:DebuffDown(v101.SunfireDebuff) and (v16:TimeToDie() > (794 - (766 + 23)))) then
			if (((16957 - 13522) > (2867 - 770)) and v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire))) then
				return "sunfire cat 24";
			end
		end
		if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and v16:DebuffDown(v101.MoonfireDebuff) and (v16:TimeToDie() > (13 - 8))) or ((12795 - 9025) >= (5114 - (1036 + 37)))) then
			if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((2688 + 1103) <= (3137 - 1526))) then
				return "moonfire cat 24";
			end
		end
		if ((v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) or ((3602 + 976) <= (3488 - (641 + 839)))) then
			if (((2038 - (910 + 3)) <= (5292 - 3216)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
				return "starsurge cat 26";
			end
		end
		if ((v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (1714 - (1466 + 218))) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild) and v16:DebuffUp(v101.SunfireDebuff) and (v16:DebuffUp(v101.MoonfireDebuff) or (v107 > (2 + 2)))) or ((1891 - (556 + 592)) >= (1565 + 2834))) then
			if (((1963 - (329 + 479)) < (2527 - (174 + 680))) and v25(v101.HeartOfTheWild)) then
				return "heart_of_the_wild cat 26";
			end
		end
		if ((v101.CatForm:IsReady() and v14:BuffDown(v101.CatForm) and (v14:Energy() >= (103 - 73)) and v36) or ((4816 - 2492) <= (413 + 165))) then
			if (((4506 - (396 + 343)) == (334 + 3433)) and v25(v101.CatForm)) then
				return "cat_form cat 28";
			end
		end
		if (((5566 - (29 + 1448)) == (5478 - (135 + 1254))) and v101.FerociousBite:IsReady() and (((v14:ComboPoints() > (11 - 8)) and (v16:TimeToDie() < (46 - 36))) or ((v14:ComboPoints() == (4 + 1)) and (v14:Energy() >= (1552 - (389 + 1138))) and (not v101.Rip:IsAvailable() or (v16:DebuffRemains(v101.Rip) > (579 - (102 + 472))))))) then
			if (((4207 + 251) >= (929 + 745)) and v25(v101.FerociousBite, not v16:IsInMeleeRange(5 + 0))) then
				return "ferocious_bite cat 32";
			end
		end
		if (((2517 - (320 + 1225)) <= (2524 - 1106)) and v101.Rip:IsAvailable() and v101.Rip:IsReady() and (v107 < (7 + 4)) and v126(v16)) then
			if (v25(v101.Rip, not v16:IsInMeleeRange(1469 - (157 + 1307))) or ((6797 - (821 + 1038)) < (11880 - 7118))) then
				return "rip cat 34";
			end
		end
		if ((v101.Thrash:IsReady() and (v107 >= (1 + 1)) and v16:DebuffRefreshable(v101.ThrashDebuff)) or ((4447 - 1943) > (1587 + 2677))) then
			if (((5336 - 3183) == (3179 - (834 + 192))) and v25(v101.Thrash, not v16:IsInMeleeRange(1 + 7))) then
				return "thrash cat";
			end
		end
		if ((v101.Rake:IsReady() and v127(v16)) or ((131 + 376) >= (56 + 2535))) then
			if (((6941 - 2460) == (4785 - (300 + 4))) and v25(v101.Rake, not v16:IsInMeleeRange(2 + 3))) then
				return "rake cat 36";
			end
		end
		if ((v101.Rake:IsReady() and ((v14:ComboPoints() < (13 - 8)) or (v14:Energy() > (452 - (112 + 250)))) and (v16:PMultiplier(v101.Rake) <= v14:PMultiplier(v101.Rake)) and v128(v16)) or ((929 + 1399) < (1735 - 1042))) then
			if (((2480 + 1848) == (2239 + 2089)) and v25(v101.Rake, not v16:IsInMeleeRange(4 + 1))) then
				return "rake cat 40";
			end
		end
		if (((788 + 800) >= (990 + 342)) and v101.Swipe:IsReady() and (v107 >= (1416 - (1001 + 413)))) then
			if (v25(v101.Swipe, not v16:IsInMeleeRange(17 - 9)) or ((5056 - (244 + 638)) > (4941 - (627 + 66)))) then
				return "swipe cat 38";
			end
		end
		if ((v101.Shred:IsReady() and ((v14:ComboPoints() < (14 - 9)) or (v14:Energy() > (692 - (512 + 90))))) or ((6492 - (1665 + 241)) <= (799 - (373 + 344)))) then
			if (((1743 + 2120) == (1023 + 2840)) and v25(v101.Shred, not v16:IsInMeleeRange(13 - 8))) then
				return "shred cat 42";
			end
		end
	end
	local function v134()
		if ((v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (50 - 20)) or (v101.ConvokeTheSpirits:CooldownRemains() > (1189 - (35 + 1064))) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild)) or ((206 + 76) <= (89 - 47))) then
			if (((19 + 4590) >= (2002 - (298 + 938))) and v25(v101.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if ((v101.MoonkinForm:IsReady() and (v14:BuffDown(v101.MoonkinForm)) and v36) or ((2411 - (233 + 1026)) == (4154 - (636 + 1030)))) then
			if (((1750 + 1672) > (3273 + 77)) and v25(v101.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if (((261 + 616) > (26 + 350)) and v101.Starsurge:IsReady() and ((v107 < (227 - (55 + 166))) or (not v112 and (v107 < (2 + 6)))) and v36) then
			if (v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge)) or ((314 + 2804) <= (7069 - 5218))) then
				return "starsurge owl 8";
			end
		end
		if ((v101.Moonfire:IsReady() and ((v107 < (302 - (36 + 261))) or (not v112 and (v107 < (12 - 5))))) or ((1533 - (34 + 1334)) >= (1343 + 2149))) then
			if (((3069 + 880) < (6139 - (1035 + 248))) and v100.CastCycle(v101.Moonfire, v106, v125, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover)) then
				return "moonfire owl 10";
			end
		end
		if (v101.Sunfire:IsReady() or ((4297 - (20 + 1)) < (1572 + 1444))) then
			if (((5009 - (134 + 185)) > (5258 - (549 + 584))) and v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((735 - (314 + 371)) >= (3075 - 2179))) then
			if (v14:BuffUp(v101.MoonkinForm) or ((2682 - (478 + 490)) >= (1567 + 1391))) then
				if (v25(v101.ConvokeTheSpirits, not v16:IsInRange(1202 - (786 + 386))) or ((4829 - 3338) < (2023 - (1055 + 324)))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((2044 - (1093 + 247)) < (878 + 109)) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(1 + 7)) and ((v113 and (v107 == (3 - 2))) or v114 or (v116 and (v107 > (3 - 2))))) then
			if (((10579 - 6861) > (4789 - 2883)) and v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true)) then
				return "wrath owl 14";
			end
		end
		if (v101.Starfire:IsReady() or ((341 + 617) > (14003 - 10368))) then
			if (((12067 - 8566) <= (3388 + 1104)) and v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true)) then
				return "starfire owl 16";
			end
		end
	end
	local function v135()
		local v157 = 0 - 0;
		local v158;
		local v159;
		while true do
			if ((v157 == (692 - (364 + 324))) or ((9435 - 5993) < (6114 - 3566))) then
				if (((953 + 1922) >= (6125 - 4661)) and v101.Starfire:IsReady() and (v107 > (2 - 0))) then
					if (v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true) or ((14568 - 9771) >= (6161 - (1249 + 19)))) then
						return "starfire owl 16";
					end
				end
				if ((v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(8 + 0))) or ((2144 - 1593) > (3154 - (686 + 400)))) then
					if (((1659 + 455) > (1173 - (73 + 156))) and v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true)) then
						return "wrath main 30";
					end
				end
				if ((v101.Moonfire:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(1 + 7))) or ((3073 - (721 + 90)) >= (35 + 3061))) then
					if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((7321 - 5066) >= (4007 - (224 + 246)))) then
						return "moonfire main 32";
					end
				end
				if (true or ((6215 - 2378) < (2404 - 1098))) then
					if (((536 + 2414) == (71 + 2879)) and v25(v101.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v157 == (1 + 0)) or ((9389 - 4666) < (10974 - 7676))) then
				if (((1649 - (203 + 310)) >= (2147 - (1238 + 755))) and v158) then
					return v158;
				end
				v122();
				v159 = 0 + 0;
				if (v101.Rip:IsAvailable() or ((1805 - (709 + 825)) > (8749 - 4001))) then
					v159 = v159 + (1 - 0);
				end
				v157 = 866 - (196 + 668);
			end
			if (((18714 - 13974) >= (6528 - 3376)) and ((835 - (171 + 662)) == v157)) then
				if (v101.Rake:IsAvailable() or ((2671 - (4 + 89)) >= (11881 - 8491))) then
					v159 = v159 + 1 + 0;
				end
				if (((180 - 139) <= (652 + 1009)) and v101.Thrash:IsAvailable()) then
					v159 = v159 + (1487 - (35 + 1451));
				end
				if (((2054 - (28 + 1425)) < (5553 - (941 + 1052))) and (v159 >= (2 + 0)) and v16:IsInMeleeRange(1522 - (822 + 692))) then
					local v213 = 0 - 0;
					local v214;
					while true do
						if (((111 + 124) < (984 - (45 + 252))) and ((0 + 0) == v213)) then
							v214 = v133();
							if (((1566 + 2983) > (2806 - 1653)) and v214) then
								return v214;
							end
							break;
						end
					end
				end
				if (v101.AdaptiveSwarm:IsCastable() or ((5107 - (114 + 319)) < (6707 - 2035))) then
					if (((4699 - 1031) < (2908 + 1653)) and v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				v157 = 4 - 1;
			end
			if ((v157 == (0 - 0)) or ((2418 - (556 + 1407)) == (4811 - (741 + 465)))) then
				v158 = v100.InterruptWithStun(v101.IncapacitatingRoar, 473 - (170 + 295));
				if (v158 or ((1404 + 1259) == (3043 + 269))) then
					return v158;
				end
				if (((10530 - 6253) <= (3710 + 765)) and v14:BuffUp(v101.CatForm) and (v14:ComboPoints() > (0 + 0))) then
					v158 = v100.InterruptWithStun(v101.Maim, 5 + 3);
					if (v158 or ((2100 - (957 + 273)) == (319 + 870))) then
						return v158;
					end
				end
				v158 = v100.InterruptWithStun(v101.MightyBash, 4 + 4);
				v157 = 3 - 2;
			end
			if (((4092 - 2539) <= (9569 - 6436)) and (v157 == (14 - 11))) then
				if (v101.MoonkinForm:IsAvailable() or ((4017 - (389 + 1391)) >= (2203 + 1308))) then
					local v215 = 0 + 0;
					local v216;
					while true do
						if ((v215 == (0 - 0)) or ((2275 - (783 + 168)) > (10135 - 7115))) then
							v216 = v134();
							if (v216 or ((2944 + 48) == (2192 - (309 + 2)))) then
								return v216;
							end
							break;
						end
					end
				end
				if (((9538 - 6432) > (2738 - (1090 + 122))) and v101.Sunfire:IsReady() and (v16:DebuffRefreshable(v101.SunfireDebuff))) then
					if (((981 + 2042) < (12997 - 9127)) and v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire))) then
						return "sunfire main 24";
					end
				end
				if (((98 + 45) > (1192 - (628 + 490))) and v101.Moonfire:IsReady() and (v16:DebuffRefreshable(v101.MoonfireDebuff))) then
					if (((4 + 14) < (5228 - 3116)) and v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire))) then
						return "moonfire main 26";
					end
				end
				if (((5013 - 3916) <= (2402 - (431 + 343))) and v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) then
					if (((9350 - 4720) == (13394 - 8764)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
						return "starsurge main 28";
					end
				end
				v157 = 4 + 0;
			end
		end
	end
	local v136 = 0 + 0;
	local function v137()
		if (((5235 - (556 + 1139)) > (2698 - (6 + 9))) and v17 and v100.DispellableFriendlyUnit(4 + 16) and v101.NaturesCure:IsReady()) then
			if (((2456 + 2338) >= (3444 - (28 + 141))) and (v136 == (0 + 0))) then
				v136 = GetTime();
			end
			if (((1830 - 346) == (1052 + 432)) and v100.Wait(1817 - (486 + 831), v136)) then
				local v211 = 0 - 0;
				while true do
					if (((5041 - 3609) < (672 + 2883)) and (v211 == (0 - 0))) then
						if (v25(v104.NaturesCureFocus) or ((2328 - (668 + 595)) > (3220 + 358))) then
							return "natures_cure dispel 2";
						end
						v136 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v138()
		if (((v14:HealthPercentage() <= v96) and v97 and v101.Barkskin:IsReady()) or ((13076 - 8281) < (1697 - (23 + 267)))) then
			if (((3797 - (1129 + 815)) < (5200 - (371 + 16))) and v25(v101.Barkskin, nil, nil, true)) then
				return "barkskin defensive 2";
			end
		end
		if (((v14:HealthPercentage() <= v98) and v99 and v101.Renewal:IsReady()) or ((4571 - (1326 + 424)) < (4604 - 2173))) then
			if (v25(v101.Renewal, nil, nil, true) or ((10502 - 7628) < (2299 - (88 + 30)))) then
				return "renewal defensive 2";
			end
		end
		if ((v102.Healthstone:IsReady() and v46 and (v14:HealthPercentage() <= v47)) or ((3460 - (720 + 51)) <= (762 - 419))) then
			if (v25(v104.Healthstone, nil, nil, true) or ((3645 - (421 + 1355)) == (3313 - 1304))) then
				return "healthstone defensive 3";
			end
		end
		if ((v40 and (v14:HealthPercentage() <= v42)) or ((1742 + 1804) < (3405 - (286 + 797)))) then
			if ((v41 == "Refreshing Healing Potion") or ((7610 - 5528) == (7905 - 3132))) then
				if (((3683 - (397 + 42)) > (330 + 725)) and v102.RefreshingHealingPotion:IsReady()) then
					if (v25(v104.RefreshingHealingPotion, nil, nil, true) or ((4113 - (24 + 776)) <= (2738 - 960))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v139()
		local v160 = 785 - (222 + 563);
		while true do
			if ((v160 == (0 - 0)) or ((1024 + 397) >= (2294 - (23 + 167)))) then
				if (((3610 - (690 + 1108)) <= (1173 + 2076)) and v101.Swiftmend:IsReady() and not v131(v17) and v14:BuffDown(v101.SoulOfTheForestBuff)) then
					if (((1339 + 284) <= (2805 - (40 + 808))) and v25(v104.RejuvenationFocus)) then
						return "rejuvenation ramp";
					end
				end
				if (((727 + 3685) == (16871 - 12459)) and v101.Swiftmend:IsReady() and v131(v17)) then
					if (((1673 + 77) >= (446 + 396)) and v25(v104.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				v160 = 1 + 0;
			end
			if (((4943 - (47 + 524)) > (1201 + 649)) and (v160 == (2 - 1))) then
				if (((346 - 114) < (1872 - 1051)) and v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady()) then
					if (((2244 - (1165 + 561)) < (27 + 875)) and v25(v104.WildgrowthFocus, nil, true)) then
						return "wildgrowth ramp";
					end
				end
				if (((9272 - 6278) > (328 + 530)) and v101.Innervate:IsReady() and v14:BuffDown(v101.Innervate)) then
					if (v25(v104.InnervatePlayer, nil, nil, true) or ((4234 - (341 + 138)) <= (247 + 668))) then
						return "innervate ramp";
					end
				end
				v160 = 3 - 1;
			end
			if (((4272 - (89 + 237)) > (12041 - 8298)) and (v160 == (3 - 1))) then
				if ((v14:BuffUp(v101.Innervate) and (v130() > (881 - (581 + 300))) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) or ((2555 - (855 + 365)) >= (7852 - 4546))) then
					if (((1582 + 3262) > (3488 - (1030 + 205))) and v25(v104.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
		end
	end
	local function v140()
		if (((425 + 27) == (421 + 31)) and v37) then
			local v202 = 286 - (156 + 130);
			while true do
				if ((v202 == (6 - 3)) or ((7679 - 3122) < (4273 - 2186))) then
					if (((1021 + 2853) == (2260 + 1614)) and v101.CenarionWard:IsReady() and v60 and (v17:HealthPercentage() <= v61)) then
						if (v25(v104.CenarionWardFocus) or ((2007 - (10 + 59)) > (1396 + 3539))) then
							return "cenarion_ward healing";
						end
					end
					if ((v14:BuffUp(v101.NaturesSwiftness) and v101.Regrowth:IsCastable()) or ((20954 - 16699) < (4586 - (671 + 492)))) then
						if (((1158 + 296) <= (3706 - (369 + 846))) and v25(v104.RegrowthFocus)) then
							return "regrowth_swiftness healing";
						end
					end
					if ((v101.NaturesSwiftness:IsReady() and v74 and (v17:HealthPercentage() <= v75)) or ((1101 + 3056) <= (2393 + 410))) then
						if (((6798 - (1036 + 909)) >= (2371 + 611)) and v25(v101.NaturesSwiftness)) then
							return "natures_swiftness healing";
						end
					end
					v202 = 6 - 2;
				end
				if (((4337 - (11 + 192)) > (1697 + 1660)) and (v202 == (175 - (135 + 40)))) then
					if (v39 or ((8278 - 4861) < (1528 + 1006))) then
						local v234 = v132();
						if (v234 or ((5996 - 3274) <= (245 - 81))) then
							return v234;
						end
					end
					if ((v54 and v32 and v14:AffectingCombat() and (v129() > (179 - (50 + 126))) and v101.NaturesVigil:IsReady()) or ((6705 - 4297) < (467 + 1642))) then
						if (v25(v101.NaturesVigil, nil, nil, true) or ((1446 - (1233 + 180)) == (2424 - (522 + 447)))) then
							return "natures_vigil healing";
						end
					end
					if ((v101.Swiftmend:IsReady() and v82 and v14:BuffDown(v101.SoulOfTheForestBuff) and v131(v17) and (v17:HealthPercentage() <= v83)) or ((1864 - (107 + 1314)) >= (1864 + 2151))) then
						if (((10305 - 6923) > (71 + 95)) and v25(v104.SwiftmendFocus)) then
							return "swiftmend healing";
						end
					end
					v202 = 1 - 0;
				end
				if ((v202 == (3 - 2)) or ((2190 - (716 + 1194)) == (53 + 3006))) then
					if (((202 + 1679) > (1796 - (74 + 429))) and v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady() and v100.AreUnitsBelowHealthPercentage(v91, v92, v101.Regrowth)) then
						if (((4546 - 2189) == (1169 + 1188)) and v25(v104.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					if (((281 - 158) == (88 + 35)) and v57 and v101.GroveGuardians:IsReady() and (v101.GroveGuardians:TimeSinceLastCast() > (15 - 10)) and v100.AreUnitsBelowHealthPercentage(v58, v59, v101.Regrowth)) then
						if (v25(v104.GroveGuardiansFocus, nil, nil) or ((2610 - 1554) >= (3825 - (279 + 154)))) then
							return "grove_guardians healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Flourish:IsReady() and v14:BuffDown(v101.Flourish) and (v129() > (782 - (454 + 324))) and v100.AreUnitsBelowHealthPercentage(v66, v67, v101.Regrowth)) or ((851 + 230) < (1092 - (12 + 5)))) then
						if (v25(v101.Flourish, nil, nil, true) or ((566 + 483) >= (11292 - 6860))) then
							return "flourish healing";
						end
					end
					v202 = 1 + 1;
				end
				if ((v202 == (1098 - (277 + 816))) or ((20374 - 15606) <= (2029 - (1058 + 125)))) then
					if ((v14:AffectingCombat() and v72 and (v100.UnitGroupRole(v17) ~= "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, false, true) < (1 + 0)) and (v101.Undergrowth:IsAvailable() or v100.IsSoloMode()) and (v17:HealthPercentage() <= (v73 - (v27(v14:BuffUp(v101.CatForm)) * (990 - (815 + 160))))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) or ((14407 - 11049) <= (3370 - 1950))) then
						if (v25(v104.LifebloomFocus) or ((892 + 2847) <= (8784 - 5779))) then
							return "lifebloom healing";
						end
					end
					if ((v55 == "Player") or ((3557 - (41 + 1857)) >= (4027 - (1222 + 671)))) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (38 - 23))) or ((4686 - 1426) < (3537 - (229 + 953)))) then
							if (v25(v104.EfflorescencePlayer) or ((2443 - (1111 + 663)) == (5802 - (874 + 705)))) then
								return "efflorescence healing player";
							end
						end
					elseif ((v55 == "Cursor") or ((237 + 1455) < (402 + 186))) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (31 - 16))) or ((136 + 4661) < (4330 - (642 + 37)))) then
							if (v25(v104.EfflorescenceCursor) or ((953 + 3224) > (776 + 4074))) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v55 == "Confirmation") or ((1004 - 604) > (1565 - (233 + 221)))) then
						if (((7054 - 4003) > (885 + 120)) and v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (1556 - (718 + 823)))) then
							if (((2324 + 1369) <= (5187 - (266 + 539))) and v25(v101.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v101.Wildgrowth:IsReady() and v93 and v100.AreUnitsBelowHealthPercentage(v94, v95, v101.Regrowth) and (not v101.Swiftmend:IsAvailable() or not v101.Swiftmend:IsReady())) or ((9291 - 6009) > (5325 - (636 + 589)))) then
						if (v25(v104.WildgrowthFocus, nil, true) or ((8498 - 4918) < (5865 - 3021))) then
							return "wildgrowth healing";
						end
					end
					v202 = 5 + 1;
				end
				if (((33 + 56) < (5505 - (657 + 358))) and (v202 == (10 - 6))) then
					if ((v68 == "Anyone") or ((11352 - 6369) < (2995 - (1151 + 36)))) then
						if (((3698 + 131) > (991 + 2778)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69)) then
							if (((4434 - 2949) <= (4736 - (1552 + 280))) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					elseif (((5103 - (64 + 770)) == (2899 + 1370)) and (v68 == "Tank Only")) then
						if (((878 - 491) <= (494 + 2288)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and (v100.UnitGroupRole(v17) == "TANK")) then
							if (v25(v104.IronBarkFocus) or ((3142 - (157 + 1086)) <= (1834 - 917))) then
								return "iron_bark healing";
							end
						end
					elseif ((v68 == "Tank and Self") or ((18885 - 14573) <= (1343 - 467))) then
						if (((3045 - 813) <= (3415 - (599 + 220))) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and ((v100.UnitGroupRole(v17) == "TANK") or (v100.UnitGroupRole(v17) == "HEALER"))) then
							if (((4171 - 2076) < (5617 - (1813 + 118))) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					end
					if ((v101.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) or ((1166 + 429) >= (5691 - (841 + 376)))) then
						if (v25(v104.AdaptiveSwarmFocus) or ((6471 - 1852) < (670 + 2212))) then
							return "adaptive_swarm healing";
						end
					end
					if ((v14:AffectingCombat() and v70 and (v100.UnitGroupRole(v17) == "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, true, false) < (2 - 1)) and (v17:HealthPercentage() <= (v71 - (v27(v14:BuffUp(v101.CatForm)) * (874 - (464 + 395))))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) or ((754 - 460) >= (2321 + 2510))) then
						if (((2866 - (467 + 370)) <= (6373 - 3289)) and v25(v104.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v202 = 4 + 1;
				end
				if ((v202 == (20 - 14)) or ((318 + 1719) == (5630 - 3210))) then
					if (((4978 - (150 + 370)) > (5186 - (74 + 1208))) and v101.Regrowth:IsCastable() and v76 and (v17:HealthPercentage() <= v77)) then
						if (((1072 - 636) >= (583 - 460)) and v25(v104.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					if (((356 + 144) < (2206 - (14 + 376))) and v14:BuffUp(v101.Innervate) and (v130() > (0 - 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
						if (((2313 + 1261) == (3140 + 434)) and v25(v104.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					if (((211 + 10) < (1142 - 752)) and v101.Rejuvenation:IsCastable() and v80 and v17:BuffRefreshable(v101.Rejuvenation) and (v17:HealthPercentage() <= v81)) then
						if (v25(v104.RejuvenationFocus) or ((1665 + 548) <= (1499 - (23 + 55)))) then
							return "rejuvenation healing";
						end
					end
					v202 = 16 - 9;
				end
				if (((2041 + 1017) < (4365 + 495)) and (v202 == (2 - 0))) then
					if ((v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v100.AreUnitsBelowHealthPercentage(v85, v86, v101.Regrowth)) or ((408 + 888) >= (5347 - (652 + 249)))) then
						if (v25(v101.Tranquility, nil, true) or ((3727 - 2334) > (6357 - (708 + 1160)))) then
							return "tranquility healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v14:BuffUp(v101.IncarnationBuff) and v100.AreUnitsBelowHealthPercentage(v88, v89, v101.Regrowth)) or ((12008 - 7584) < (48 - 21))) then
						if (v25(v101.Tranquility, nil, true) or ((2024 - (10 + 17)) > (857 + 2958))) then
							return "tranquility_tree healing";
						end
					end
					if (((5197 - (1400 + 332)) > (3669 - 1756)) and v14:AffectingCombat() and v32 and v101.ConvokeTheSpirits:IsReady() and v100.AreUnitsBelowHealthPercentage(v63, v64, v101.Regrowth)) then
						if (((2641 - (242 + 1666)) < (779 + 1040)) and v25(v101.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					v202 = 2 + 1;
				end
				if (((6 + 1) == v202) or ((5335 - (850 + 90)) == (8327 - 3572))) then
					if ((v101.Regrowth:IsCastable() and v78 and v17:BuffUp(v101.Rejuvenation) and (v17:HealthPercentage() <= v79)) or ((5183 - (360 + 1030)) < (2097 + 272))) then
						if (v25(v104.RegrowthFocus, nil, true) or ((11527 - 7443) == (364 - 99))) then
							return "regrowth healing";
						end
					end
					break;
				end
			end
		end
	end
	local function v141()
		local v161 = 1661 - (909 + 752);
		local v162;
		while true do
			if (((5581 - (109 + 1114)) == (7978 - 3620)) and (v161 == (1 + 0))) then
				if (v162 or ((3380 - (6 + 236)) < (626 + 367))) then
					return v162;
				end
				if (((2681 + 649) > (5478 - 3155)) and v34) then
					local v217 = 0 - 0;
					local v218;
					while true do
						if ((v217 == (1133 - (1076 + 57))) or ((597 + 3029) == (4678 - (579 + 110)))) then
							v218 = v139();
							if (v218 or ((73 + 843) == (2362 + 309))) then
								return v218;
							end
							break;
						end
					end
				end
				v161 = 2 + 0;
			end
			if (((679 - (174 + 233)) == (759 - 487)) and (v161 == (3 - 1))) then
				v162 = v140();
				if (((1890 + 2359) <= (6013 - (663 + 511))) and v162) then
					return v162;
				end
				v161 = 3 + 0;
			end
			if (((603 + 2174) < (9865 - 6665)) and (v161 == (0 + 0))) then
				if (((223 - 128) < (4737 - 2780)) and (v45 or v44) and v33) then
					local v219 = v137();
					if (((395 + 431) < (3341 - 1624)) and v219) then
						return v219;
					end
				end
				v162 = v138();
				v161 = 1 + 0;
			end
			if (((131 + 1295) >= (1827 - (478 + 244))) and (v161 == (520 - (440 + 77)))) then
				if (((1253 + 1501) <= (12367 - 8988)) and v100.TargetIsValid() and v35) then
					local v220 = 1556 - (655 + 901);
					while true do
						if (((0 + 0) == v220) or ((3007 + 920) == (955 + 458))) then
							v162 = v135();
							if (v162 or ((4648 - 3494) <= (2233 - (695 + 750)))) then
								return v162;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v142()
		local v163 = 0 - 0;
		while true do
			if ((v163 == (1 - 0)) or ((6607 - 4964) > (3730 - (285 + 66)))) then
				if ((v43 and v101.MarkOfTheWild:IsCastable() and (v14:BuffDown(v101.MarkOfTheWild, true) or v100.GroupBuffMissing(v101.MarkOfTheWild))) or ((6533 - 3730) > (5859 - (682 + 628)))) then
					if (v25(v104.MarkOfTheWildPlayer) or ((36 + 184) >= (3321 - (176 + 123)))) then
						return "mark_of_the_wild";
					end
				end
				if (((1181 + 1641) == (2048 + 774)) and v100.TargetIsValid()) then
					if ((v101.Rake:IsReady() and (v14:StealthUp(false, true))) or ((1330 - (239 + 30)) == (505 + 1352))) then
						if (((2653 + 107) > (2414 - 1050)) and v25(v101.Rake, not v16:IsInMeleeRange(31 - 21))) then
							return "rake";
						end
					end
				end
				v163 = 317 - (306 + 9);
			end
			if (((0 - 0) == v163) or ((853 + 4049) <= (2206 + 1389))) then
				if (((v45 or v44) and v33) or ((1855 + 1997) == (837 - 544))) then
					local v221 = 1375 - (1140 + 235);
					local v222;
					while true do
						if ((v221 == (0 + 0)) or ((1430 + 129) == (1178 + 3410))) then
							v222 = v137();
							if (v222 or ((4536 - (33 + 19)) == (285 + 503))) then
								return v222;
							end
							break;
						end
					end
				end
				if (((13691 - 9123) >= (1722 + 2185)) and v30 and v37) then
					local v223 = 0 - 0;
					local v224;
					while true do
						if (((1169 + 77) < (4159 - (586 + 103))) and ((0 + 0) == v223)) then
							v224 = v140();
							if (((12523 - 8455) >= (2460 - (1309 + 179))) and v224) then
								return v224;
							end
							break;
						end
					end
				end
				v163 = 1 - 0;
			end
			if (((215 + 278) < (10454 - 6561)) and (v163 == (2 + 0))) then
				if ((v100.TargetIsValid() and v35) or ((3129 - 1656) >= (6639 - 3307))) then
					local v225 = v135();
					if (v225 or ((4660 - (295 + 314)) <= (2841 - 1684))) then
						return v225;
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
		v42 = EpicSettings.Settings['HealingPotionHP'] or (1962 - (1300 + 662));
		v43 = EpicSettings.Settings['UseMarkOfTheWild'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v46 = EpicSettings.Settings['UseHealthstone'];
		v47 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v48 = EpicSettings.Settings['HandleCharredTreant'];
		v49 = EpicSettings.Settings['HandleCharredBrambles'];
		v50 = EpicSettings.Settings['InterruptWithStun'];
		v51 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v52 = EpicSettings.Settings['InterruptThreshold'] or (1755 - (1178 + 577));
		v53 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v54 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v55 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v56 = EpicSettings.Settings['EfflorescenceHP'] or (0 + 0);
		v57 = EpicSettings.Settings['UseGroveGuardians'];
		v58 = EpicSettings.Settings['GroveGuardiansHP'] or (0 - 0);
		v59 = EpicSettings.Settings['GroveGuardiansGroup'] or (1405 - (851 + 554));
		v60 = EpicSettings.Settings['UseCenarionWard'];
		v61 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
		v62 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v63 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 - 0);
		v64 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
		v65 = EpicSettings.Settings['UseFlourish'];
		v66 = EpicSettings.Settings['FlourishHP'] or (302 - (115 + 187));
		v67 = EpicSettings.Settings['FlourishGroup'] or (0 + 0);
		v68 = EpicSettings.Settings['IronBarkUsage'] or "";
		v69 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
	end
	local function v144()
		v70 = EpicSettings.Settings['UseLifebloomTank'];
		v71 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
		v72 = EpicSettings.Settings['UseLifebloom'];
		v73 = EpicSettings.Settings['LifebloomHP'] or (1161 - (160 + 1001));
		v74 = EpicSettings.Settings['UseNaturesSwiftness'];
		v75 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 + 0);
		v76 = EpicSettings.Settings['UseRegrowth'];
		v77 = EpicSettings.Settings['RegrowthHP'] or (0 + 0);
		v78 = EpicSettings.Settings['UseRegrowthRefresh'];
		v79 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
		v80 = EpicSettings.Settings['UseRejuvenation'];
		v81 = EpicSettings.Settings['RejuvenationHP'] or (358 - (237 + 121));
		v82 = EpicSettings.Settings['UseSwiftmend'];
		v83 = EpicSettings.Settings['SwiftmendHP'] or (897 - (525 + 372));
		v84 = EpicSettings.Settings['UseTranquility'];
		v85 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v86 = EpicSettings.Settings['TranquilityGroup'] or (0 - 0);
		v87 = EpicSettings.Settings['UseTranquilityTree'];
		v88 = EpicSettings.Settings['TranquilityTreeHP'] or (142 - (96 + 46));
		v89 = EpicSettings.Settings['TranquilityTreeGroup'] or (777 - (643 + 134));
		v90 = EpicSettings.Settings['UseWildgrowthSotF'];
		v91 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 + 0);
		v92 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
		v93 = EpicSettings.Settings['UseWildgrowth'];
		v94 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
		v95 = EpicSettings.Settings['WildgrowthGroup'] or (0 + 0);
		v96 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v97 = EpicSettings.Settings['UseBarkskin'];
		v98 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
		v99 = EpicSettings.Settings['UseRenewal'];
	end
	local function v145()
		local v194 = 719 - (316 + 403);
		while true do
			if (((402 + 202) < (7920 - 5039)) and (v194 == (3 + 4))) then
				if (not v14:IsChanneling() or ((2266 - 1366) == (2394 + 983))) then
					if (((1438 + 3021) > (2047 - 1456)) and v14:AffectingCombat()) then
						local v235 = v141();
						if (((16228 - 12830) >= (4975 - 2580)) and v235) then
							return v235;
						end
					elseif (v30 or ((125 + 2058) >= (5558 - 2734))) then
						local v236 = 0 + 0;
						local v237;
						while true do
							if (((5695 - 3759) == (1953 - (12 + 5))) and (v236 == (0 - 0))) then
								v237 = v142();
								if (v237 or ((10309 - 5477) < (9168 - 4855))) then
									return v237;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((10137 - 6049) > (787 + 3087)) and (v194 == (1979 - (1656 + 317)))) then
				if (((3861 + 471) == (3472 + 860)) and v49) then
					local v226 = 0 - 0;
					local v227;
					while true do
						if (((19681 - 15682) >= (3254 - (5 + 349))) and (v226 == (4 - 3))) then
							v227 = v100.HandleCharredBrambles(v101.Regrowth, v104.RegrowthMouseover, 1311 - (266 + 1005), true);
							if (v227 or ((1664 + 861) > (13866 - 9802))) then
								return v227;
							end
							v226 = 2 - 0;
						end
						if (((6067 - (561 + 1135)) == (5695 - 1324)) and (v226 == (6 - 4))) then
							v227 = v100.HandleCharredBrambles(v101.Swiftmend, v104.SwiftmendMouseover, 1106 - (507 + 559));
							if (v227 or ((667 - 401) > (15420 - 10434))) then
								return v227;
							end
							v226 = 391 - (212 + 176);
						end
						if (((2896 - (250 + 655)) >= (2522 - 1597)) and (v226 == (0 - 0))) then
							v227 = v100.HandleCharredBrambles(v101.Rejuvenation, v104.RejuvenationMouseover, 62 - 22);
							if (((2411 - (1869 + 87)) < (7120 - 5067)) and v227) then
								return v227;
							end
							v226 = 1902 - (484 + 1417);
						end
						if ((v226 == (6 - 3)) or ((1383 - 557) == (5624 - (48 + 725)))) then
							v227 = v100.HandleCharredBrambles(v101.Wildgrowth, v104.WildgrowthMouseover, 65 - 25, true);
							if (((490 - 307) == (107 + 76)) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				if (((3097 - 1938) <= (501 + 1287)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v30) then
					local v228 = v100.DeadFriendlyUnitsCount();
					if (v14:AffectingCombat() or ((1023 + 2484) > (5171 - (152 + 701)))) then
						if (v101.Rebirth:IsReady() or ((4386 - (430 + 881)) <= (1136 + 1829))) then
							if (((2260 - (557 + 338)) <= (595 + 1416)) and v25(v101.Rebirth, nil, true)) then
								return "rebirth";
							end
						end
					elseif ((v228 > (2 - 1)) or ((9720 - 6944) > (9497 - 5922))) then
						if (v25(v101.Revitalize, nil, true) or ((5504 - 2950) == (5605 - (499 + 302)))) then
							return "revitalize";
						end
					elseif (((3443 - (39 + 827)) == (7113 - 4536)) and v25(v101.Revive, not v16:IsInRange(89 - 49), true)) then
						return "revive";
					end
				end
				if ((v37 and (v14:AffectingCombat() or v30)) or ((23 - 17) >= (2899 - 1010))) then
					local v229 = v139();
					if (((44 + 462) <= (5537 - 3645)) and v229) then
						return v229;
					end
					local v229 = v140();
					if (v229 or ((322 + 1686) > (3509 - 1291))) then
						return v229;
					end
				end
				v194 = 111 - (103 + 1);
			end
			if (((933 - (475 + 79)) <= (8964 - 4817)) and (v194 == (3 - 2))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v194 = 1 + 1;
			end
			if (((3 + 0) == v194) or ((6017 - (1395 + 108)) <= (2935 - 1926))) then
				v37 = EpicSettings.Toggles['healing'];
				if (v14:IsDeadOrGhost() or ((4700 - (7 + 1197)) == (520 + 672))) then
					return;
				end
				if (v14:AffectingCombat() or v44 or ((73 + 135) == (3278 - (27 + 292)))) then
					local v230 = 0 - 0;
					local v231;
					while true do
						if (((5453 - 1176) >= (5506 - 4193)) and (v230 == (0 - 0))) then
							v231 = v44 and v101.NaturesCure:IsReady() and v33;
							if (((4926 - 2339) < (3313 - (43 + 96))) and v100.IsTankBelowHealthPercentage(v69, 81 - 61, v101.Regrowth) and v101.IronBark:IsReady() and ((v68 == "Tank Only") or (v68 == "Tank and Self"))) then
								local v238 = 0 - 0;
								local v239;
								while true do
									if ((v238 == (0 + 0)) or ((1164 + 2956) <= (4344 - 2146))) then
										v239 = v100.FocusUnit(v231, nil, nil, "TANK", 8 + 12, v101.Regrowth);
										if (v239 or ((2990 - 1394) == (271 + 587))) then
											return v239;
										end
										break;
									end
								end
							elseif (((237 + 2983) == (4971 - (1414 + 337))) and (v14:HealthPercentage() < v69) and v101.IronBark:IsReady() and (v68 == "Tank and Self")) then
								local v240 = 1940 - (1642 + 298);
								local v241;
								while true do
									if ((v240 == (0 - 0)) or ((4033 - 2631) > (10742 - 7122))) then
										v241 = v100.FocusUnit(v231, nil, nil, "HEALER", 7 + 13, v101.Regrowth);
										if (((2003 + 571) == (3546 - (357 + 615))) and v241) then
											return v241;
										end
										break;
									end
								end
							else
								local v242 = 0 + 0;
								local v243;
								while true do
									if (((4411 - 2613) < (2363 + 394)) and (v242 == (0 - 0))) then
										v243 = v100.FocusUnit(v231, nil, nil, nil, 16 + 4, v101.Regrowth);
										if (v243 or ((26 + 351) > (1637 + 967))) then
											return v243;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v194 = 1305 - (384 + 917);
			end
			if (((1265 - (128 + 569)) < (2454 - (1407 + 136))) and (v194 == (1892 - (687 + 1200)))) then
				if (((4995 - (556 + 1154)) < (14874 - 10646)) and v31) then
					v106 = v16:GetEnemiesInSplashRange(103 - (9 + 86));
					v107 = #v106;
				else
					v106 = {};
					v107 = 422 - (275 + 146);
				end
				if (((637 + 3279) > (3392 - (29 + 35))) and (v100.TargetIsValid() or v14:AffectingCombat())) then
					local v232 = 0 - 0;
					while true do
						if (((7467 - 4967) < (16947 - 13108)) and (v232 == (0 + 0))) then
							v108 = v10.BossFightRemains(nil, true);
							v109 = v108;
							v232 = 1013 - (53 + 959);
						end
						if (((915 - (312 + 96)) == (879 - 372)) and ((286 - (147 + 138)) == v232)) then
							if (((1139 - (813 + 86)) <= (2861 + 304)) and (v109 == (20585 - 9474))) then
								v109 = v10.FightRemains(v106, false);
							end
							break;
						end
					end
				end
				if (((1326 - (18 + 474)) >= (272 + 533)) and v48) then
					local v233 = v100.HandleCharredTreant(v101.Rejuvenation, v104.RejuvenationMouseover, 130 - 90);
					if (v233 or ((4898 - (860 + 226)) < (2619 - (121 + 182)))) then
						return v233;
					end
					local v233 = v100.HandleCharredTreant(v101.Regrowth, v104.RegrowthMouseover, 5 + 35, true);
					if (v233 or ((3892 - (988 + 252)) <= (174 + 1359))) then
						return v233;
					end
					local v233 = v100.HandleCharredTreant(v101.Swiftmend, v104.SwiftmendMouseover, 13 + 27);
					if (v233 or ((5568 - (49 + 1921)) < (2350 - (223 + 667)))) then
						return v233;
					end
					local v233 = v100.HandleCharredTreant(v101.Wildgrowth, v104.WildgrowthMouseover, 92 - (51 + 1), true);
					if (v233 or ((7084 - 2968) < (2552 - 1360))) then
						return v233;
					end
				end
				v194 = 1131 - (146 + 979);
			end
			if (((1 + 1) == v194) or ((3982 - (311 + 294)) <= (2518 - 1615))) then
				v34 = EpicSettings.Toggles['ramp'];
				v35 = EpicSettings.Toggles['dps'];
				v36 = EpicSettings.Toggles['dpsform'];
				v194 = 2 + 1;
			end
			if (((5419 - (496 + 947)) >= (1797 - (1233 + 125))) and (v194 == (2 + 2))) then
				if (((3367 + 385) == (713 + 3039)) and v14:IsMounted()) then
					return;
				end
				if (((5691 - (963 + 682)) > (2250 + 445)) and v14:IsMoving()) then
					v105 = GetTime();
				end
				if (v14:BuffUp(v101.TravelForm) or v14:BuffUp(v101.BearForm) or v14:BuffUp(v101.CatForm) or ((5049 - (504 + 1000)) == (2153 + 1044))) then
					if (((2181 + 213) > (36 + 337)) and ((GetTime() - v105) < (1 - 0))) then
						return;
					end
				end
				v194 = 5 + 0;
			end
			if (((2417 + 1738) <= (4414 - (156 + 26))) and (v194 == (0 + 0))) then
				v143();
				v144();
				v30 = EpicSettings.Toggles['ooc'];
				v194 = 1 - 0;
			end
		end
	end
	local function v146()
		local v195 = 164 - (149 + 15);
		while true do
			if ((v195 == (961 - (890 + 70))) or ((3698 - (39 + 78)) == (3955 - (14 + 468)))) then
				v120();
				break;
			end
			if (((10984 - 5989) > (9357 - 6009)) and (v195 == (0 + 0))) then
				v23.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
				v195 = 1 + 0;
			end
		end
	end
	v23.SetAPL(23 + 82, v145, v146);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

