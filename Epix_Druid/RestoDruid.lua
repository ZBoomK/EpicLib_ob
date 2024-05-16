local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 489 - (457 + 32);
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((3320 - (832 + 570)) == (1013 + 62))) then
			v6 = v0[v4];
			if (((104 + 292) <= (13461 - 9657)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (797 - (588 + 208))) or ((11236 - 7067) == (3987 - (884 + 916)))) then
			return v6(...);
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
	local v108 = 6443 + 4668;
	local v109 = 11764 - (232 + 421);
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = false;
	local v117 = v14:GetEquipment();
	local v118 = (v117[1902 - (1569 + 320)] and v21(v117[4 + 9])) or v21(0 + 0);
	local v119 = (v117[46 - 32] and v21(v117[619 - (316 + 289)])) or v21(0 - 0);
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if (((2859 - (666 + 787)) == (1831 - (360 + 65))) and (v147 == (0 + 0))) then
				v117 = v14:GetEquipment();
				v118 = (v117[267 - (79 + 175)] and v21(v117[19 - 6])) or v21(0 + 0);
				v147 = 2 - 1;
			end
			if (((2948 - 1417) < (5170 - (503 + 396))) and (v147 == (182 - (92 + 89)))) then
				v119 = (v117[26 - 12] and v21(v117[8 + 6])) or v21(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v148 = 0 - 0;
		while true do
			if (((87 + 548) == (1447 - 812)) and (v148 == (0 + 0))) then
				v108 = 5307 + 5804;
				v109 = 33840 - 22729;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v120()
		if (((421 + 2952) <= (5422 - 1866)) and v101.ImprovedNaturesCure:IsAvailable()) then
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
		return (v14:StealthUp(true, true) and (1245.6 - (485 + 759))) or (2 - 1);
	end
	v101.Rake:RegisterPMultiplier(v101.RakeDebuff, v121);
	local function v122()
		v110 = v14:BuffUp(v101.EclipseSolar) or v14:BuffUp(v101.EclipseLunar);
		v111 = v14:BuffUp(v101.EclipseSolar) and v14:BuffUp(v101.EclipseLunar);
		v112 = v14:BuffUp(v101.EclipseLunar) and v14:BuffDown(v101.EclipseSolar);
		v113 = v14:BuffUp(v101.EclipseSolar) and v14:BuffDown(v101.EclipseLunar);
		v114 = (not v110 and (((v101.Starfire:Count() == (1189 - (442 + 747))) and (v101.Wrath:Count() > (1135 - (832 + 303)))) or v14:IsCasting(v101.Wrath))) or v113;
		v115 = (not v110 and (((v101.Wrath:Count() == (946 - (88 + 858))) and (v101.Starfire:Count() > (0 + 0))) or v14:IsCasting(v101.Starfire))) or v112;
		v116 = not v110 and (v101.Wrath:Count() > (0 + 0)) and (v101.Starfire:Count() > (0 + 0));
	end
	local function v123(v149)
		return v149:DebuffRefreshable(v101.SunfireDebuff) and (v109 > (794 - (766 + 23)));
	end
	local function v124(v150)
		return (v150:DebuffRefreshable(v101.MoonfireDebuff) and (v109 > (59 - 47)) and ((((v107 <= (5 - 1)) or (v14:Energy() < (131 - 81))) and v14:BuffDown(v101.HeartOfTheWild)) or (((v107 <= (13 - 9)) or (v14:Energy() < (1123 - (1036 + 37)))) and v14:BuffUp(v101.HeartOfTheWild))) and v150:DebuffDown(v101.MoonfireDebuff)) or (v14:PrevGCD(1 + 0, v101.Sunfire) and ((v150:DebuffUp(v101.MoonfireDebuff) and (v150:DebuffRemains(v101.MoonfireDebuff) < (v150:DebuffDuration(v101.MoonfireDebuff) * (0.8 - 0)))) or v150:DebuffDown(v101.MoonfireDebuff)) and (v107 == (1 + 0)));
	end
	local function v125(v151)
		return v151:DebuffRefreshable(v101.MoonfireDebuff) and (v151:TimeToDie() > (1485 - (641 + 839)));
	end
	local function v126(v152)
		return ((v152:DebuffRefreshable(v101.Rip) or ((v14:Energy() > (1003 - (910 + 3))) and (v152:DebuffRemains(v101.Rip) <= (25 - 15)))) and (((v14:ComboPoints() == (1689 - (1466 + 218))) and (v152:TimeToDie() > (v152:DebuffRemains(v101.Rip) + 12 + 12))) or (((v152:DebuffRemains(v101.Rip) + (v14:ComboPoints() * (1152 - (556 + 592)))) < v152:TimeToDie()) and ((v152:DebuffRemains(v101.Rip) + 2 + 2 + (v14:ComboPoints() * (812 - (329 + 479)))) > v152:TimeToDie())))) or (v152:DebuffDown(v101.Rip) and (v14:ComboPoints() > ((856 - (174 + 680)) + (v107 * (6 - 4)))));
	end
	local function v127(v153)
		return (v153:DebuffDown(v101.RakeDebuff) or v153:DebuffRefreshable(v101.RakeDebuff)) and (v153:TimeToDie() > (20 - 10)) and (v14:ComboPoints() < (4 + 1));
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
		local v156 = 739 - (396 + 343);
		local v157;
		while true do
			if ((v156 == (1 + 0)) or ((4768 - (29 + 1448)) < (4669 - (135 + 1254)))) then
				v157 = v100.HandleBottomTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 150 - 110, nil);
				if (((20478 - 16092) >= (582 + 291)) and v157) then
					return v157;
				end
				break;
			end
			if (((2448 - (389 + 1138)) <= (1676 - (102 + 472))) and (v156 == (0 + 0))) then
				v157 = v100.HandleTopTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 23 + 17, nil);
				if (((4389 + 317) >= (2508 - (320 + 1225))) and v157) then
					return v157;
				end
				v156 = 1 - 0;
			end
		end
	end
	local function v133()
		if ((v101.Rake:IsReady() and (v14:StealthUp(false, true))) or ((588 + 372) <= (2340 - (157 + 1307)))) then
			if (v25(v101.Rake, not v16:IsInMeleeRange(1869 - (821 + 1038))) or ((5154 - 3088) == (102 + 830))) then
				return "rake cat 2";
			end
		end
		if (((8570 - 3745) < (1802 + 3041)) and v39 and not v14:StealthUp(false, true)) then
			local v173 = v132();
			if (v173 or ((9609 - 5732) >= (5563 - (834 + 192)))) then
				return v173;
			end
		end
		if (v101.AdaptiveSwarm:IsCastable() or ((275 + 4040) < (444 + 1282))) then
			if (v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm)) or ((79 + 3600) < (968 - 343))) then
				return "adaptive_swarm cat";
			end
		end
		if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((4929 - (300 + 4)) < (169 + 463))) then
			if (v14:BuffUp(v101.CatForm) or ((217 - 134) > (2142 - (112 + 250)))) then
				if (((218 + 328) <= (2697 - 1620)) and (v14:BuffUp(v101.HeartOfTheWild) or (v101.HeartOfTheWild:CooldownRemains() > (35 + 25)) or not v101.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (26 + 24)) and (((v14:ComboPoints() < (4 + 1)) and (v16:DebuffRemains(v101.Rip) > (3 + 2))) or (v107 > (1 + 0)))) then
					if (v25(v101.ConvokeTheSpirits, not v16:IsInRange(1444 - (1001 + 413))) or ((2220 - 1224) > (5183 - (244 + 638)))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((4763 - (627 + 66)) > (2046 - 1359)) and v101.Sunfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (607 - (512 + 90))) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (1936 - (1665 + 241))))) then
			if (v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover) or ((1373 - (373 + 344)) >= (1502 + 1828))) then
				return "sunfire cat 20";
			end
		end
		if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (2 + 3)) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (79 - 49)))) or ((4216 - 1724) <= (1434 - (35 + 1064)))) then
			if (((3145 + 1177) >= (5481 - 2919)) and v100.CastCycle(v101.Moonfire, v106, v124, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover)) then
				return "moonfire cat 22";
			end
		end
		if ((v101.Sunfire:IsReady() and v16:DebuffDown(v101.SunfireDebuff) and (v16:TimeToDie() > (1 + 4))) or ((4873 - (298 + 938)) >= (5029 - (233 + 1026)))) then
			if (v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire)) or ((4045 - (636 + 1030)) > (2341 + 2237))) then
				return "sunfire cat 24";
			end
		end
		if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and v16:DebuffDown(v101.MoonfireDebuff) and (v16:TimeToDie() > (5 + 0))) or ((144 + 339) > (51 + 692))) then
			if (((2675 - (55 + 166)) > (113 + 465)) and v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire))) then
				return "moonfire cat 24";
			end
		end
		if (((94 + 836) < (17025 - 12567)) and v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) then
			if (((959 - (36 + 261)) <= (1699 - 727)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
				return "starsurge cat 26";
			end
		end
		if (((5738 - (34 + 1334)) == (1680 + 2690)) and v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (24 + 6)) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild) and v16:DebuffUp(v101.SunfireDebuff) and (v16:DebuffUp(v101.MoonfireDebuff) or (v107 > (1287 - (1035 + 248))))) then
			if (v25(v101.HeartOfTheWild) or ((4783 - (20 + 1)) <= (449 + 412))) then
				return "heart_of_the_wild cat 26";
			end
		end
		if ((v101.CatForm:IsReady() and v14:BuffDown(v101.CatForm) and (v14:Energy() >= (349 - (134 + 185))) and v36) or ((2545 - (549 + 584)) == (4949 - (314 + 371)))) then
			if (v25(v101.CatForm) or ((10875 - 7707) < (3121 - (478 + 490)))) then
				return "cat_form cat 28";
			end
		end
		if ((v101.FerociousBite:IsReady() and (((v14:ComboPoints() > (2 + 1)) and (v16:TimeToDie() < (1182 - (786 + 386)))) or ((v14:ComboPoints() == (16 - 11)) and (v14:Energy() >= (1404 - (1055 + 324))) and (not v101.Rip:IsAvailable() or (v16:DebuffRemains(v101.Rip) > (1345 - (1093 + 247))))))) or ((4422 + 554) < (141 + 1191))) then
			if (((18373 - 13745) == (15706 - 11078)) and v25(v101.FerociousBite, not v16:IsInMeleeRange(14 - 9))) then
				return "ferocious_bite cat 32";
			end
		end
		if ((v101.Rip:IsAvailable() and v101.Rip:IsReady() and (v107 < (27 - 16)) and v126(v16)) or ((20 + 34) == (1521 - 1126))) then
			if (((282 - 200) == (62 + 20)) and v25(v101.Rip, not v16:IsInMeleeRange(12 - 7))) then
				return "rip cat 34";
			end
		end
		if ((v101.Thrash:IsReady() and (v107 >= (690 - (364 + 324))) and v16:DebuffRefreshable(v101.ThrashDebuff)) or ((1592 - 1011) < (676 - 394))) then
			if (v25(v101.Thrash, not v16:IsInMeleeRange(3 + 5)) or ((19285 - 14676) < (3995 - 1500))) then
				return "thrash cat";
			end
		end
		if (((3498 - 2346) == (2420 - (1249 + 19))) and v101.Rake:IsReady() and v127(v16)) then
			if (((1712 + 184) <= (13319 - 9897)) and v25(v101.Rake, not v16:IsInMeleeRange(1091 - (686 + 400)))) then
				return "rake cat 36";
			end
		end
		if ((v101.Rake:IsReady() and ((v14:ComboPoints() < (4 + 1)) or (v14:Energy() > (319 - (73 + 156)))) and (v16:PMultiplier(v101.Rake) <= v14:PMultiplier(v101.Rake)) and v128(v16)) or ((5 + 985) > (2431 - (721 + 90)))) then
			if (v25(v101.Rake, not v16:IsInMeleeRange(1 + 4)) or ((2847 - 1970) > (5165 - (224 + 246)))) then
				return "rake cat 40";
			end
		end
		if (((4359 - 1668) >= (3407 - 1556)) and v101.Swipe:IsReady() and (v107 >= (1 + 1))) then
			if (v25(v101.Swipe, not v16:IsInMeleeRange(1 + 7)) or ((2193 + 792) >= (9654 - 4798))) then
				return "swipe cat 38";
			end
		end
		if (((14229 - 9953) >= (1708 - (203 + 310))) and v101.Shred:IsReady() and ((v14:ComboPoints() < (1998 - (1238 + 755))) or (v14:Energy() > (7 + 83)))) then
			if (((4766 - (709 + 825)) <= (8642 - 3952)) and v25(v101.Shred, not v16:IsInMeleeRange(6 - 1))) then
				return "shred cat 42";
			end
		end
	end
	local function v134()
		if ((v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (894 - (196 + 668))) or (v101.ConvokeTheSpirits:CooldownRemains() > (355 - 265)) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild)) or ((1855 - 959) >= (3979 - (171 + 662)))) then
			if (((3154 - (4 + 89)) >= (10367 - 7409)) and v25(v101.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if (((1161 + 2026) >= (2828 - 2184)) and v101.MoonkinForm:IsReady() and (v14:BuffDown(v101.MoonkinForm)) and v36) then
			if (((253 + 391) <= (2190 - (35 + 1451))) and v25(v101.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if (((2411 - (28 + 1425)) > (2940 - (941 + 1052))) and v101.Starsurge:IsReady() and ((v107 < (6 + 0)) or (not v112 and (v107 < (1522 - (822 + 692))))) and v36) then
			if (((6412 - 1920) >= (1251 + 1403)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
				return "starsurge owl 8";
			end
		end
		if (((3739 - (45 + 252)) >= (1488 + 15)) and v101.Moonfire:IsReady() and ((v107 < (2 + 3)) or (not v112 and (v107 < (16 - 9))))) then
			if (v100.CastCycle(v101.Moonfire, v106, v125, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((3603 - (114 + 319)) <= (2101 - 637))) then
				return "moonfire owl 10";
			end
		end
		if (v101.Sunfire:IsReady() or ((6146 - 1349) == (2798 + 1590))) then
			if (((820 - 269) <= (1426 - 745)) and v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if (((5240 - (556 + 1407)) > (1613 - (741 + 465))) and v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) then
			if (((5160 - (170 + 295)) >= (746 + 669)) and v14:BuffUp(v101.MoonkinForm)) then
				if (v25(v101.ConvokeTheSpirits, not v16:IsInRange(28 + 2)) or ((7907 - 4695) <= (783 + 161))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if ((v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(6 + 2)) and ((v113 and (v107 == (1 + 0))) or v114 or (v116 and (v107 > (1231 - (957 + 273)))))) or ((829 + 2267) <= (720 + 1078))) then
			if (((13477 - 9940) == (9320 - 5783)) and v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true)) then
				return "wrath owl 14";
			end
		end
		if (((11719 - 7882) >= (7774 - 6204)) and v101.Starfire:IsReady()) then
			if (v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true) or ((4730 - (389 + 1391)) == (2392 + 1420))) then
				return "starfire owl 16";
			end
		end
	end
	local function v135()
		local v158 = 0 + 0;
		local v159;
		local v160;
		while true do
			if (((10752 - 6029) >= (3269 - (783 + 168))) and ((6 - 4) == v158)) then
				if (v101.Rip:IsAvailable() or ((1994 + 33) > (3163 - (309 + 2)))) then
					v160 = v160 + (2 - 1);
				end
				if (v101.Rake:IsAvailable() or ((2348 - (1090 + 122)) > (1400 + 2917))) then
					v160 = v160 + (3 - 2);
				end
				if (((3250 + 1498) == (5866 - (628 + 490))) and v101.Thrash:IsAvailable()) then
					v160 = v160 + 1 + 0;
				end
				if (((9249 - 5513) <= (21661 - 16921)) and (v160 >= (776 - (431 + 343))) and v16:IsInMeleeRange(16 - 8)) then
					local v214 = 0 - 0;
					local v215;
					while true do
						if (((0 + 0) == v214) or ((434 + 2956) <= (4755 - (556 + 1139)))) then
							v215 = v133();
							if (v215 or ((1014 - (6 + 9)) > (494 + 2199))) then
								return v215;
							end
							break;
						end
					end
				end
				v158 = 2 + 1;
			end
			if (((632 - (28 + 141)) < (233 + 368)) and (v158 == (6 - 1))) then
				if (true or ((1547 + 636) < (2004 - (486 + 831)))) then
					if (((11837 - 7288) == (16015 - 11466)) and v25(v101.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((883 + 3789) == (14772 - 10100)) and (v158 == (1264 - (668 + 595)))) then
				v159 = v100.InterruptWithStun(v101.MightyBash, 8 + 0);
				if (v159 or ((740 + 2928) < (1077 - 682))) then
					return v159;
				end
				v122();
				v160 = 290 - (23 + 267);
				v158 = 1946 - (1129 + 815);
			end
			if ((v158 == (391 - (371 + 16))) or ((5916 - (1326 + 424)) == (861 - 406))) then
				if ((v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) or ((16257 - 11808) == (2781 - (88 + 30)))) then
					if (v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge)) or ((5048 - (720 + 51)) < (6648 - 3659))) then
						return "starsurge main 28";
					end
				end
				if ((v101.Starfire:IsReady() and (v107 > (1778 - (421 + 1355)))) or ((1435 - 565) >= (2039 + 2110))) then
					if (((3295 - (286 + 797)) < (11635 - 8452)) and v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true)) then
						return "starfire owl 16";
					end
				end
				if (((7694 - 3048) > (3431 - (397 + 42))) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(3 + 5))) then
					if (((2234 - (24 + 776)) < (4784 - 1678)) and v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true)) then
						return "wrath main 30";
					end
				end
				if (((1571 - (222 + 563)) < (6660 - 3637)) and v101.Moonfire:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(6 + 2))) then
					if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((2632 - (23 + 167)) < (1872 - (690 + 1108)))) then
						return "moonfire main 32";
					end
				end
				v158 = 2 + 3;
			end
			if (((3741 + 794) == (5383 - (40 + 808))) and ((0 + 0) == v158)) then
				v159 = v100.InterruptWithStun(v101.IncapacitatingRoar, 30 - 22);
				if (v159 or ((2876 + 133) <= (1114 + 991))) then
					return v159;
				end
				if (((1004 + 826) < (4240 - (47 + 524))) and v14:BuffUp(v101.CatForm) and (v14:ComboPoints() > (0 + 0))) then
					v159 = v100.InterruptWithStun(v101.Maim, 21 - 13);
					if (v159 or ((2138 - 708) >= (8237 - 4625))) then
						return v159;
					end
				end
				if (((4409 - (1165 + 561)) >= (74 + 2386)) and (v14:BuffUp(v101.CatForm) or v14:BuffUp(v101.BearForm))) then
					local v216 = 0 - 0;
					while true do
						if ((v216 == (0 + 0)) or ((2283 - (341 + 138)) >= (885 + 2390))) then
							v159 = v100.InterruptWithStun(v101.SkullBash, 20 - 10);
							if (v159 or ((1743 - (89 + 237)) > (11674 - 8045))) then
								return v159;
							end
							break;
						end
					end
				end
				v158 = 1 - 0;
			end
			if (((5676 - (581 + 300)) > (1622 - (855 + 365))) and (v158 == (6 - 3))) then
				if (((1572 + 3241) > (4800 - (1030 + 205))) and v101.AdaptiveSwarm:IsCastable()) then
					if (((3673 + 239) == (3640 + 272)) and v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				if (((3107 - (156 + 130)) <= (10960 - 6136)) and v101.MoonkinForm:IsAvailable()) then
					local v217 = 0 - 0;
					local v218;
					while true do
						if (((3559 - 1821) <= (579 + 1616)) and ((0 + 0) == v217)) then
							v218 = v134();
							if (((110 - (10 + 59)) <= (854 + 2164)) and v218) then
								return v218;
							end
							break;
						end
					end
				end
				if (((10563 - 8418) <= (5267 - (671 + 492))) and v101.Sunfire:IsReady() and (v16:DebuffRefreshable(v101.SunfireDebuff))) then
					if (((2141 + 548) < (6060 - (369 + 846))) and v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire))) then
						return "sunfire main 24";
					end
				end
				if ((v101.Moonfire:IsReady() and (v16:DebuffRefreshable(v101.MoonfireDebuff))) or ((615 + 1707) > (2238 + 384))) then
					if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((6479 - (1036 + 909)) == (1656 + 426))) then
						return "moonfire main 26";
					end
				end
				v158 = 6 - 2;
			end
		end
	end
	local v136 = 203 - (11 + 192);
	local function v137()
		if ((v101.NaturesCure:IsReady() and (v100.UnitHasDispellableDebuffByPlayer(v17) or v100.DispellableFriendlyUnit(11 + 9) or v100.UnitHasCurseDebuff(v17) or v100.UnitHasPoisonDebuff(v17))) or ((1746 - (135 + 40)) > (4523 - 2656))) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (0 - 0)) or ((3978 - 1324) >= (3172 - (50 + 126)))) then
					if (((11076 - 7098) > (466 + 1638)) and (v136 == (1413 - (1233 + 180)))) then
						v136 = GetTime();
					end
					if (((3964 - (522 + 447)) > (2962 - (107 + 1314))) and v100.Wait(233 + 267, v136)) then
						local v236 = 0 - 0;
						while true do
							if (((1380 + 1869) > (1892 - 939)) and (v236 == (0 - 0))) then
								if (v25(v104.NaturesCureFocus) or ((5183 - (716 + 1194)) > (79 + 4494))) then
									return "natures_cure dispel 2";
								end
								v136 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v138()
		local v161 = 503 - (74 + 429);
		while true do
			if ((v161 == (0 - 0)) or ((1562 + 1589) < (2938 - 1654))) then
				if (((v14:HealthPercentage() <= v96) and v97 and v101.Barkskin:IsReady()) or ((1309 + 541) == (4713 - 3184))) then
					if (((2029 - 1208) < (2556 - (279 + 154))) and v25(v101.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((1680 - (454 + 324)) < (1830 + 495)) and (v14:HealthPercentage() <= v98) and v99 and v101.Renewal:IsReady()) then
					if (((875 - (12 + 5)) <= (1597 + 1365)) and v25(v101.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v161 = 2 - 1;
			end
			if ((v161 == (1 + 0)) or ((5039 - (277 + 816)) < (5503 - 4215))) then
				if ((v102.Healthstone:IsReady() and v46 and (v14:HealthPercentage() <= v47)) or ((4425 - (1058 + 125)) == (107 + 460))) then
					if (v25(v104.Healthstone, nil, nil, true) or ((1822 - (815 + 160)) >= (5418 - 4155))) then
						return "healthstone defensive 3";
					end
				end
				if ((v40 and (v14:HealthPercentage() <= v42)) or ((5348 - 3095) == (442 + 1409))) then
					if ((v41 == "Refreshing Healing Potion") or ((6100 - 4013) > (4270 - (41 + 1857)))) then
						if (v102.RefreshingHealingPotion:IsReady() or ((6338 - (1222 + 671)) < (10723 - 6574))) then
							if (v25(v104.RefreshingHealingPotion, nil, nil, true) or ((2612 - 794) == (1267 - (229 + 953)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v139()
		local v162 = 1774 - (1111 + 663);
		while true do
			if (((2209 - (874 + 705)) < (298 + 1829)) and (v162 == (2 + 0))) then
				if ((v14:BuffUp(v101.Innervate) and (v130() > (0 - 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) or ((55 + 1883) == (3193 - (642 + 37)))) then
					if (((971 + 3284) >= (9 + 46)) and v25(v104.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if (((7529 - 4530) > (1610 - (233 + 221))) and (v162 == (0 - 0))) then
				if (((2069 + 281) > (2696 - (718 + 823))) and v101.Swiftmend:IsReady() and not v131(v17) and v14:BuffDown(v101.SoulOfTheForestBuff)) then
					if (((2536 + 1493) <= (5658 - (266 + 539))) and v25(v104.RejuvenationFocus)) then
						return "rejuvenation ramp";
					end
				end
				if ((v101.Swiftmend:IsReady() and v131(v17)) or ((1460 - 944) > (4659 - (636 + 589)))) then
					if (((9604 - 5558) >= (6255 - 3222)) and v25(v104.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				v162 = 1 + 0;
			end
			if ((v162 == (1 + 0)) or ((3734 - (657 + 358)) <= (3830 - 2383))) then
				if ((v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady()) or ((9418 - 5284) < (5113 - (1151 + 36)))) then
					if (v25(v104.WildgrowthFocus, nil, true) or ((159 + 5) >= (733 + 2052))) then
						return "wildgrowth ramp";
					end
				end
				if ((v101.Innervate:IsReady() and v14:BuffDown(v101.Innervate)) or ((1567 - 1042) == (3941 - (1552 + 280)))) then
					if (((867 - (64 + 770)) == (23 + 10)) and v25(v104.InnervatePlayer, nil, nil, true)) then
						return "innervate ramp";
					end
				end
				v162 = 4 - 2;
			end
		end
	end
	local function v140()
		if (((543 + 2511) <= (5258 - (157 + 1086))) and v37) then
			local v175 = 0 - 0;
			while true do
				if (((8194 - 6323) < (5187 - 1805)) and ((5 - 1) == v175)) then
					if (((2112 - (599 + 220)) <= (4312 - 2146)) and (v55 == "Player")) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (1946 - (1813 + 118)))) or ((1886 + 693) < (1340 - (841 + 376)))) then
							if (v25(v104.EfflorescencePlayer) or ((1184 - 338) >= (551 + 1817))) then
								return "efflorescence healing player";
							end
						end
					elseif ((v55 == "Cursor") or ((10950 - 6938) <= (4217 - (464 + 395)))) then
						if (((3834 - 2340) <= (1444 + 1561)) and v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (852 - (467 + 370)))) then
							if (v25(v104.EfflorescenceCursor) or ((6428 - 3317) == (1567 + 567))) then
								return "efflorescence healing cursor";
							end
						end
					elseif (((8072 - 5717) == (368 + 1987)) and (v55 == "Confirmation")) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (34 - 19))) or ((1108 - (150 + 370)) <= (1714 - (74 + 1208)))) then
							if (((11798 - 7001) >= (18472 - 14577)) and v25(v101.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if (((2546 + 1031) == (3967 - (14 + 376))) and v101.Wildgrowth:IsReady() and v93 and v100.AreUnitsBelowHealthPercentage(v94, v95, v101.Regrowth) and (not v101.Swiftmend:IsAvailable() or not v101.Swiftmend:IsReady())) then
						if (((6580 - 2786) > (2390 + 1303)) and v25(v104.WildgrowthFocus, nil, true)) then
							return "wildgrowth healing";
						end
					end
					if ((v101.Regrowth:IsCastable() and v76 and (v17:HealthPercentage() <= v77)) or ((1121 + 154) == (3911 + 189))) then
						if (v25(v104.RegrowthFocus, nil, true) or ((4661 - 3070) >= (2694 + 886))) then
							return "regrowth healing";
						end
					end
					if (((1061 - (23 + 55)) <= (4284 - 2476)) and v14:BuffUp(v101.Innervate) and (v130() > (0 + 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
						if (v25(v104.RejuvenationMouseover) or ((1931 + 219) <= (1855 - 658))) then
							return "rejuvenation_cycle healing";
						end
					end
					v175 = 2 + 3;
				end
				if (((4670 - (652 + 249)) >= (3139 - 1966)) and (v175 == (1873 - (708 + 1160)))) then
					if (((4030 - 2545) == (2707 - 1222)) and v101.Rejuvenation:IsCastable() and v80 and v17:BuffRefreshable(v101.Rejuvenation) and (v17:HealthPercentage() <= v81)) then
						if (v25(v104.RejuvenationFocus) or ((3342 - (10 + 17)) <= (625 + 2157))) then
							return "rejuvenation healing";
						end
					end
					if ((v101.Regrowth:IsCastable() and v78 and v17:BuffUp(v101.Rejuvenation) and (v17:HealthPercentage() <= v79)) or ((2608 - (1400 + 332)) >= (5684 - 2720))) then
						if (v25(v104.RegrowthFocus, nil, true) or ((4140 - (242 + 1666)) > (1069 + 1428))) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v175 == (0 + 0)) or ((1799 + 311) <= (1272 - (850 + 90)))) then
					if (((6455 - 2769) > (4562 - (360 + 1030))) and v39) then
						local v237 = 0 + 0;
						local v238;
						while true do
							if ((v237 == (0 - 0)) or ((6155 - 1681) < (2481 - (909 + 752)))) then
								v238 = v132();
								if (((5502 - (109 + 1114)) >= (5275 - 2393)) and v238) then
									return v238;
								end
								break;
							end
						end
					end
					if ((v54 and v32 and v14:AffectingCombat() and (v129() > (2 + 1)) and v101.NaturesVigil:IsReady()) or ((2271 - (6 + 236)) >= (2219 + 1302))) then
						if (v25(v101.NaturesVigil, nil, nil, true) or ((1640 + 397) >= (10947 - 6305))) then
							return "natures_vigil healing";
						end
					end
					if (((3004 - 1284) < (5591 - (1076 + 57))) and v101.Swiftmend:IsReady() and v82 and v14:BuffDown(v101.SoulOfTheForestBuff) and v131(v17) and (v17:HealthPercentage() <= v83)) then
						if (v25(v104.SwiftmendFocus) or ((72 + 364) > (3710 - (579 + 110)))) then
							return "swiftmend healing";
						end
					end
					if (((57 + 656) <= (749 + 98)) and v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady() and v100.AreUnitsBelowHealthPercentage(v91, v92, v101.Regrowth)) then
						if (((1144 + 1010) <= (4438 - (174 + 233))) and v25(v104.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					v175 = 2 - 1;
				end
				if (((8100 - 3485) == (2053 + 2562)) and (v175 == (1177 - (663 + 511)))) then
					if ((v68 == "Anyone") or ((3382 + 408) == (109 + 391))) then
						if (((274 - 185) < (134 + 87)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69)) then
							if (((4835 - 2781) >= (3439 - 2018)) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					elseif (((331 + 361) < (5951 - 2893)) and (v68 == "Tank Only")) then
						if ((v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and (v100.UnitGroupRole(v17) == "TANK")) or ((2320 + 934) == (152 + 1503))) then
							if (v25(v104.IronBarkFocus) or ((2018 - (478 + 244)) == (5427 - (440 + 77)))) then
								return "iron_bark healing";
							end
						end
					elseif (((1532 + 1836) == (12326 - 8958)) and (v68 == "Tank and Self")) then
						if (((4199 - (655 + 901)) < (708 + 3107)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and ((v100.UnitGroupRole(v17) == "TANK") or (v100.UnitGroupRole(v17) == "HEALER"))) then
							if (((1465 + 448) > (333 + 160)) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					end
					if (((19156 - 14401) > (4873 - (695 + 750))) and v101.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) then
						if (((4715 - 3334) <= (3655 - 1286)) and v25(v104.AdaptiveSwarmFocus)) then
							return "adaptive_swarm healing";
						end
					end
					if ((v14:AffectingCombat() and v70 and (v100.UnitGroupRole(v17) == "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, true, false) < (3 - 2)) and (v17:HealthPercentage() <= (v71 - (v27(v14:BuffUp(v101.CatForm)) * (366 - (285 + 66))))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) or ((11289 - 6446) == (5394 - (682 + 628)))) then
						if (((753 + 3916) > (662 - (176 + 123))) and v25(v104.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					if ((v14:AffectingCombat() and v72 and (v100.UnitGroupRole(v17) ~= "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, false, true) < (1 + 0)) and (v101.Undergrowth:IsAvailable() or v100.IsSoloMode()) and (v17:HealthPercentage() <= (v73 - (v27(v14:BuffUp(v101.CatForm)) * (11 + 4)))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) or ((2146 - (239 + 30)) >= (854 + 2284))) then
						if (((4558 + 184) >= (6417 - 2791)) and v25(v104.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v175 = 12 - 8;
				end
				if (((317 - (306 + 9)) == v175) or ((15842 - 11302) == (160 + 756))) then
					if ((v14:AffectingCombat() and v32 and v101.ConvokeTheSpirits:IsReady() and v100.AreUnitsBelowHealthPercentage(v63, v64, v101.Regrowth)) or ((710 + 446) > (2092 + 2253))) then
						if (((6396 - 4159) < (5624 - (1140 + 235))) and v25(v101.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					if ((v101.CenarionWard:IsReady() and v60 and (v17:HealthPercentage() <= v61)) or ((1708 + 975) < (22 + 1))) then
						if (((179 + 518) <= (878 - (33 + 19))) and v25(v104.CenarionWardFocus)) then
							return "cenarion_ward healing";
						end
					end
					if (((399 + 706) <= (3524 - 2348)) and v14:BuffUp(v101.NaturesSwiftness) and v101.Regrowth:IsCastable()) then
						if (((1489 + 1890) <= (7475 - 3663)) and v25(v104.RegrowthFocus)) then
							return "regrowth_swiftness healing";
						end
					end
					if ((v101.NaturesSwiftness:IsReady() and v74 and (v17:HealthPercentage() <= v75)) or ((739 + 49) >= (2305 - (586 + 103)))) then
						if (((169 + 1685) <= (10402 - 7023)) and v25(v101.NaturesSwiftness)) then
							return "natures_swiftness healing";
						end
					end
					v175 = 1491 - (1309 + 179);
				end
				if (((8211 - 3662) == (1980 + 2569)) and (v175 == (2 - 1))) then
					if ((v57 and v101.GroveGuardians:IsReady() and (v101.GroveGuardians:TimeSinceLastCast() > (4 + 1)) and v100.AreUnitsBelowHealthPercentage(v58, v59, v101.Regrowth)) or ((6420 - 3398) >= (6025 - 3001))) then
						if (((5429 - (295 + 314)) > (5398 - 3200)) and v25(v104.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Flourish:IsReady() and v14:BuffDown(v101.Flourish) and (v129() > (1966 - (1300 + 662))) and v100.AreUnitsBelowHealthPercentage(v66, v67, v101.Regrowth)) or ((3331 - 2270) >= (6646 - (1178 + 577)))) then
						if (((709 + 655) <= (13222 - 8749)) and v25(v101.Flourish, nil, nil, true)) then
							return "flourish healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v100.AreUnitsBelowHealthPercentage(v85, v86, v101.Regrowth)) or ((5000 - (851 + 554)) <= (3 + 0))) then
						if (v25(v101.Tranquility, nil, true) or ((12956 - 8284) == (8365 - 4513))) then
							return "tranquility healing";
						end
					end
					if (((1861 - (115 + 187)) == (1194 + 365)) and v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v14:BuffUp(v101.IncarnationBuff) and v100.AreUnitsBelowHealthPercentage(v88, v89, v101.Regrowth)) then
						if (v25(v101.Tranquility, nil, true) or ((1659 + 93) <= (3105 - 2317))) then
							return "tranquility_tree healing";
						end
					end
					v175 = 1163 - (160 + 1001);
				end
			end
		end
	end
	local function v141()
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((1 + 0) == v163) or ((7997 - 4090) == (535 - (237 + 121)))) then
				if (((4367 - (525 + 372)) > (1051 - 496)) and v164) then
					return v164;
				end
				if (v34 or ((3193 - 2221) == (787 - (96 + 46)))) then
					local v219 = v139();
					if (((3959 - (643 + 134)) >= (764 + 1351)) and v219) then
						return v219;
					end
				end
				v163 = 4 - 2;
			end
			if (((14453 - 10560) < (4248 + 181)) and (v163 == (3 - 1))) then
				v164 = v140();
				if (v164 or ((5860 - 2993) < (2624 - (316 + 403)))) then
					return v164;
				end
				v163 = 2 + 1;
			end
			if ((v163 == (8 - 5)) or ((650 + 1146) >= (10201 - 6150))) then
				if (((1148 + 471) <= (1211 + 2545)) and v100.TargetIsValid() and v35) then
					v164 = v135();
					if (((2092 - 1488) == (2884 - 2280)) and v164) then
						return v164;
					end
				end
				break;
			end
			if (((0 - 0) == v163) or ((257 + 4227) == (1771 - 871))) then
				if (((v45 or v44) and v33) or ((218 + 4241) <= (3274 - 2161))) then
					local v220 = 17 - (12 + 5);
					local v221;
					while true do
						if (((14106 - 10474) > (7249 - 3851)) and ((0 - 0) == v220)) then
							v221 = v137();
							if (((10122 - 6040) <= (998 + 3919)) and v221) then
								return v221;
							end
							break;
						end
					end
				end
				v164 = v138();
				v163 = 1974 - (1656 + 317);
			end
		end
	end
	local function v142()
		local v165 = 0 + 0;
		while true do
			if (((3873 + 959) >= (3685 - 2299)) and (v165 == (0 - 0))) then
				if (((491 - (5 + 349)) == (650 - 513)) and (v45 or v44) and v33) then
					local v222 = 1271 - (266 + 1005);
					local v223;
					while true do
						if (((0 + 0) == v222) or ((5356 - 3786) >= (5702 - 1370))) then
							v223 = v137();
							if (v223 or ((5760 - (561 + 1135)) <= (2369 - 550))) then
								return v223;
							end
							break;
						end
					end
				end
				if ((v30 and v37) or ((16389 - 11403) < (2640 - (507 + 559)))) then
					local v224 = 0 - 0;
					local v225;
					while true do
						if (((13688 - 9262) > (560 - (212 + 176))) and ((905 - (250 + 655)) == v224)) then
							v225 = v140();
							if (((1597 - 1011) > (795 - 340)) and v225) then
								return v225;
							end
							break;
						end
					end
				end
				v165 = 1 - 0;
			end
			if (((2782 - (1869 + 87)) == (2864 - 2038)) and (v165 == (1902 - (484 + 1417)))) then
				if ((v43 and v101.MarkOfTheWild:IsCastable() and (v14:BuffDown(v101.MarkOfTheWild, true) or v100.GroupBuffMissing(v101.MarkOfTheWild))) or ((8613 - 4594) > (7442 - 3001))) then
					if (((2790 - (48 + 725)) < (6960 - 2699)) and v25(v104.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (((12652 - 7936) > (47 + 33)) and v100.TargetIsValid()) then
					if ((v101.Rake:IsReady() and (v14:StealthUp(false, true))) or ((9371 - 5864) == (916 + 2356))) then
						if (v25(v101.Rake, not v16:IsInMeleeRange(3 + 7)) or ((1729 - (152 + 701)) >= (4386 - (430 + 881)))) then
							return "rake";
						end
					end
				end
				v165 = 1 + 1;
			end
			if (((5247 - (557 + 338)) > (755 + 1799)) and (v165 == (5 - 3))) then
				if ((v100.TargetIsValid() and v35) or ((15428 - 11022) < (10741 - 6698))) then
					local v226 = 0 - 0;
					local v227;
					while true do
						if ((v226 == (801 - (499 + 302))) or ((2755 - (39 + 827)) >= (9338 - 5955))) then
							v227 = v135();
							if (((4225 - 2333) <= (10858 - 8124)) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v143()
		local v166 = 0 - 0;
		while true do
			if (((165 + 1758) < (6491 - 4273)) and (v166 == (1 + 0))) then
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v46 = EpicSettings.Settings['UseHealthstone'];
				v47 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v48 = EpicSettings.Settings['HandleCharredTreant'];
				v49 = EpicSettings.Settings['HandleCharredBrambles'];
				v166 = 106 - (103 + 1);
			end
			if (((2727 - (475 + 79)) > (818 - 439)) and (v166 == (16 - 11))) then
				v68 = EpicSettings.Settings['IronBarkUsage'] or "";
				v69 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
				break;
			end
			if ((v166 == (0 + 0)) or ((4094 - (1395 + 108)) == (9919 - 6510))) then
				v38 = EpicSettings.Settings['UseRacials'];
				v39 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseHealingPotion'];
				v41 = EpicSettings.Settings['HealingPotionName'] or "";
				v42 = EpicSettings.Settings['HealingPotionHP'] or (1204 - (7 + 1197));
				v43 = EpicSettings.Settings['UseMarkOfTheWild'];
				v166 = 1 + 0;
			end
			if (((1576 + 2938) > (3643 - (27 + 292))) and (v166 == (5 - 3))) then
				v50 = EpicSettings.Settings['InterruptWithStun'];
				v51 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v52 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v53 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v54 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v55 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v166 = 12 - 9;
			end
			if ((v166 == (5 - 2)) or ((395 - 187) >= (4967 - (43 + 96)))) then
				v56 = EpicSettings.Settings['EfflorescenceHP'] or (0 - 0);
				v57 = EpicSettings.Settings['UseGroveGuardians'];
				v58 = EpicSettings.Settings['GroveGuardiansHP'] or (0 - 0);
				v59 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 + 0);
				v60 = EpicSettings.Settings['UseCenarionWard'];
				v61 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
				v166 = 7 - 3;
			end
			if ((v166 == (2 + 2)) or ((2966 - 1383) > (1123 + 2444))) then
				v62 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v63 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 + 0);
				v64 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (1751 - (1414 + 337));
				v65 = EpicSettings.Settings['UseFlourish'];
				v66 = EpicSettings.Settings['FlourishHP'] or (1940 - (1642 + 298));
				v67 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
				v166 = 14 - 9;
			end
		end
	end
	local function v144()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (1 + 2)) or ((1022 + 291) == (1766 - (357 + 615)))) then
				v79 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 + 0);
				v80 = EpicSettings.Settings['UseRejuvenation'];
				v81 = EpicSettings.Settings['RejuvenationHP'] or (0 - 0);
				v167 = 4 + 0;
			end
			if (((6801 - 3627) > (2322 + 580)) and (v167 == (1 + 0))) then
				v73 = EpicSettings.Settings['LifebloomHP'] or (0 + 0);
				v74 = EpicSettings.Settings['UseNaturesSwiftness'];
				v75 = EpicSettings.Settings['NaturesSwiftnessHP'] or (1301 - (384 + 917));
				v167 = 699 - (128 + 569);
			end
			if (((5663 - (1407 + 136)) <= (6147 - (687 + 1200))) and (v167 == (1710 - (556 + 1154)))) then
				v70 = EpicSettings.Settings['UseLifebloomTank'];
				v71 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
				v72 = EpicSettings.Settings['UseLifebloom'];
				v167 = 96 - (9 + 86);
			end
			if ((v167 == (429 - (275 + 146))) or ((144 + 739) > (4842 - (29 + 35)))) then
				v94 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
				v95 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v96 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v167 = 6 + 3;
			end
			if ((v167 == (1019 - (53 + 959))) or ((4028 - (312 + 96)) >= (8488 - 3597))) then
				v91 = EpicSettings.Settings['WildgrowthSotFHP'] or (285 - (147 + 138));
				v92 = EpicSettings.Settings['WildgrowthSotFGroup'] or (899 - (813 + 86));
				v93 = EpicSettings.Settings['UseWildgrowth'];
				v167 = 8 + 0;
			end
			if (((7888 - 3630) > (1429 - (18 + 474))) and (v167 == (2 + 3))) then
				v85 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
				v86 = EpicSettings.Settings['TranquilityGroup'] or (1086 - (860 + 226));
				v87 = EpicSettings.Settings['UseTranquilityTree'];
				v167 = 309 - (121 + 182);
			end
			if ((v167 == (1 + 1)) or ((6109 - (988 + 252)) < (103 + 803))) then
				v76 = EpicSettings.Settings['UseRegrowth'];
				v77 = EpicSettings.Settings['RegrowthHP'] or (0 + 0);
				v78 = EpicSettings.Settings['UseRegrowthRefresh'];
				v167 = 1973 - (49 + 1921);
			end
			if ((v167 == (899 - (223 + 667))) or ((1277 - (51 + 1)) > (7277 - 3049))) then
				v97 = EpicSettings.Settings['UseBarkskin'];
				v98 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
				v99 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((4453 - (146 + 979)) > (632 + 1606)) and (v167 == (611 - (311 + 294)))) then
				v88 = EpicSettings.Settings['TranquilityTreeHP'] or (0 - 0);
				v89 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
				v90 = EpicSettings.Settings['UseWildgrowthSotF'];
				v167 = 1450 - (496 + 947);
			end
			if (((5197 - (1233 + 125)) > (571 + 834)) and (v167 == (4 + 0))) then
				v82 = EpicSettings.Settings['UseSwiftmend'];
				v83 = EpicSettings.Settings['SwiftmendHP'] or (0 + 0);
				v84 = EpicSettings.Settings['UseTranquility'];
				v167 = 1650 - (963 + 682);
			end
		end
	end
	local function v145()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (1506 - (504 + 1000))) or ((871 + 422) <= (462 + 45))) then
				v36 = EpicSettings.Toggles['dpsform'];
				v37 = EpicSettings.Toggles['healing'];
				if (v14:IsDeadOrGhost() or ((274 + 2622) < (1187 - 382))) then
					return;
				end
				if (((1979 + 337) == (1347 + 969)) and (v14:AffectingCombat() or v44)) then
					local v228 = 182 - (156 + 26);
					local v229;
					while true do
						if ((v228 == (0 + 0)) or ((4020 - 1450) == (1697 - (149 + 15)))) then
							v229 = v44 and v101.NaturesCure:IsReady() and v33;
							if ((v100.IsTankBelowHealthPercentage(v69, 980 - (890 + 70), v101.Regrowth) and v101.IronBark:IsReady() and ((v68 == "Tank Only") or (v68 == "Tank and Self"))) or ((1000 - (39 + 78)) == (1942 - (14 + 468)))) then
								local v242 = 0 - 0;
								local v243;
								while true do
									if ((v242 == (0 - 0)) or ((2384 + 2235) <= (600 + 399))) then
										v243 = v100.FocusUnit(v229, nil, nil, "TANK", 9 + 31, v101.Regrowth);
										if (v243 or ((1541 + 1869) > (1079 + 3037))) then
											return v243;
										end
										break;
									end
								end
							elseif (((v14:HealthPercentage() < v69) and v101.IronBark:IsReady() and (v68 == "Tank and Self")) or ((1728 - 825) >= (3024 + 35))) then
								local v244 = 0 - 0;
								local v245;
								while true do
									if ((v244 == (0 + 0)) or ((4027 - (12 + 39)) < (2658 + 199))) then
										v245 = v100.FocusUnit(v229, nil, nil, "HEALER", 123 - 83, v101.Regrowth);
										if (((17558 - 12628) > (684 + 1623)) and v245) then
											return v245;
										end
										break;
									end
								end
							else
								local v246 = v100.FocusUnit(v229, nil, nil, nil, 22 + 18, v101.Regrowth);
								if (v246 or ((10259 - 6213) < (860 + 431))) then
									return v246;
								end
							end
							break;
						end
					end
				end
				v168 = 14 - 11;
			end
			if ((v168 == (1713 - (1596 + 114))) or ((11072 - 6831) == (4258 - (164 + 549)))) then
				if (v14:IsMounted() or ((5486 - (1059 + 379)) > (5254 - 1022))) then
					return;
				end
				if (v14:IsMoving() or ((907 + 843) >= (586 + 2887))) then
					v105 = GetTime();
				end
				if (((3558 - (145 + 247)) == (2598 + 568)) and (v14:BuffUp(v101.TravelForm) or v14:BuffUp(v101.BearForm) or v14:BuffUp(v101.CatForm))) then
					if (((815 + 948) < (11040 - 7316)) and ((GetTime() - v105) < (1 + 0))) then
						return;
					end
				end
				if (((50 + 7) <= (4420 - 1697)) and v31) then
					v106 = v16:GetEnemiesInSplashRange(728 - (254 + 466));
					v107 = #v106;
				else
					v106 = {};
					v107 = 561 - (544 + 16);
				end
				v168 = 12 - 8;
			end
			if ((v168 == (632 - (294 + 334))) or ((2323 - (236 + 17)) == (191 + 252))) then
				if (v100.TargetIsValid() or v14:AffectingCombat() or ((2106 + 599) == (5245 - 3852))) then
					local v230 = 0 - 0;
					while true do
						if ((v230 == (1 + 0)) or ((3790 + 811) < (855 - (413 + 381)))) then
							if ((v109 == (468 + 10643)) or ((2956 - 1566) >= (12322 - 7578))) then
								v109 = v10.FightRemains(v106, false);
							end
							break;
						end
						if ((v230 == (1970 - (582 + 1388))) or ((3412 - 1409) > (2745 + 1089))) then
							v108 = v10.BossFightRemains(nil, true);
							v109 = v108;
							v230 = 365 - (326 + 38);
						end
					end
				end
				if (v48 or ((461 - 305) > (5585 - 1672))) then
					local v231 = v100.HandleCharredTreant(v101.Rejuvenation, v104.RejuvenationMouseover, 660 - (47 + 573));
					if (((69 + 126) == (828 - 633)) and v231) then
						return v231;
					end
					local v231 = v100.HandleCharredTreant(v101.Regrowth, v104.RegrowthMouseover, 64 - 24, true);
					if (((4769 - (1269 + 395)) >= (2288 - (76 + 416))) and v231) then
						return v231;
					end
					local v231 = v100.HandleCharredTreant(v101.Swiftmend, v104.SwiftmendMouseover, 483 - (319 + 124));
					if (((10009 - 5630) >= (3138 - (564 + 443))) and v231) then
						return v231;
					end
					local v231 = v100.HandleCharredTreant(v101.Wildgrowth, v104.WildgrowthMouseover, 110 - 70, true);
					if (((4302 - (337 + 121)) >= (5985 - 3942)) and v231) then
						return v231;
					end
				end
				if (v49 or ((10766 - 7534) <= (4642 - (1261 + 650)))) then
					local v232 = 0 + 0;
					local v233;
					while true do
						if (((7816 - 2911) == (6722 - (772 + 1045))) and (v232 == (0 + 0))) then
							v233 = v100.HandleCharredBrambles(v101.Rejuvenation, v104.RejuvenationMouseover, 184 - (102 + 42));
							if (v233 or ((5980 - (1524 + 320)) >= (5681 - (1049 + 221)))) then
								return v233;
							end
							v232 = 157 - (18 + 138);
						end
						if ((v232 == (2 - 1)) or ((4060 - (67 + 1035)) == (4365 - (136 + 212)))) then
							v233 = v100.HandleCharredBrambles(v101.Regrowth, v104.RegrowthMouseover, 169 - 129, true);
							if (((984 + 244) >= (750 + 63)) and v233) then
								return v233;
							end
							v232 = 1606 - (240 + 1364);
						end
						if ((v232 == (1084 - (1050 + 32))) or ((12336 - 8881) > (2396 + 1654))) then
							v233 = v100.HandleCharredBrambles(v101.Swiftmend, v104.SwiftmendMouseover, 1095 - (331 + 724));
							if (((20 + 223) == (887 - (269 + 375))) and v233) then
								return v233;
							end
							v232 = 728 - (267 + 458);
						end
						if ((v232 == (1 + 2)) or ((520 - 249) > (2390 - (667 + 151)))) then
							v233 = v100.HandleCharredBrambles(v101.Wildgrowth, v104.WildgrowthMouseover, 1537 - (1410 + 87), true);
							if (((4636 - (1504 + 393)) < (8901 - 5608)) and v233) then
								return v233;
							end
							break;
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v30) or ((10226 - 6284) < (1930 - (461 + 335)))) then
					local v234 = v100.DeadFriendlyUnitsCount();
					if (v14:AffectingCombat() or ((345 + 2348) == (6734 - (1730 + 31)))) then
						if (((3813 - (728 + 939)) == (7600 - 5454)) and v101.Rebirth:IsReady()) then
							if (v25(v101.Rebirth, nil, true) or ((4551 - 2307) == (7386 - 4162))) then
								return "rebirth";
							end
						end
					elseif ((v234 > (1069 - (138 + 930))) or ((4482 + 422) <= (1498 + 418))) then
						if (((78 + 12) <= (4348 - 3283)) and v25(v101.Revitalize, nil, true)) then
							return "revitalize";
						end
					elseif (((6568 - (459 + 1307)) == (6672 - (474 + 1396))) and v25(v101.Revive, not v16:IsInRange(69 - 29), true)) then
						return "revive";
					end
				end
				v168 = 5 + 0;
			end
			if (((1 + 4) == v168) or ((6530 - 4250) <= (65 + 446))) then
				if ((v37 and (v14:AffectingCombat() or v30)) or ((5594 - 3918) <= (2019 - 1556))) then
					local v235 = v139();
					if (((4460 - (562 + 29)) == (3299 + 570)) and v235) then
						return v235;
					end
					local v235 = v140();
					if (((2577 - (374 + 1045)) <= (2069 + 544)) and v235) then
						return v235;
					end
				end
				if (not v14:IsChanneling() or ((7340 - 4976) <= (2637 - (448 + 190)))) then
					if (v14:AffectingCombat() or ((1590 + 3332) < (88 + 106))) then
						local v239 = 0 + 0;
						local v240;
						while true do
							if (((0 - 0) == v239) or ((6497 - 4406) < (1525 - (1307 + 187)))) then
								v240 = v141();
								if (v240 or ((9636 - 7206) >= (11407 - 6535))) then
									return v240;
								end
								break;
							end
						end
					elseif (v30 or ((14625 - 9855) < (2418 - (232 + 451)))) then
						local v241 = v142();
						if (v241 or ((4239 + 200) <= (2076 + 274))) then
							return v241;
						end
					end
				end
				break;
			end
			if ((v168 == (564 - (510 + 54))) or ((9023 - 4544) < (4502 - (13 + 23)))) then
				v143();
				v144();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v168 = 1 - 0;
			end
			if (((3659 - 1112) > (2225 - 1000)) and (v168 == (1089 - (830 + 258)))) then
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['ramp'];
				v35 = EpicSettings.Toggles['dps'];
				v168 = 6 - 4;
			end
		end
	end
	local function v146()
		v23.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v120();
	end
	v23.SetAPL(66 + 39, v145, v146);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

