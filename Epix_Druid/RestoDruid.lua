local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((10245 - 6545) == (729 + 1778))) then
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
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = string.format;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v97 = v21.Commons.Everyone;
	local v98 = v18.Druid.Restoration;
	local v99 = v20.Druid.Restoration;
	local v100 = {};
	local v101 = v24.Druid.Restoration;
	local v102 = 772 - (757 + 15);
	local v103, v104;
	local v105 = 6081 + 5030;
	local v106 = 20435 - 9324;
	local v107 = false;
	local v108 = false;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = v13:GetEquipment();
	local v115 = (v114[9 + 4] and v20(v114[8 + 5])) or v20(0 + 0);
	local v116 = (v114[12 + 2] and v20(v114[14 + 0])) or v20(433 - (153 + 280));
	v9:RegisterForEvent(function()
		local v143 = 0 - 0;
		while true do
			if (((4017 + 457) >= (109 + 165)) and (v143 == (0 + 0))) then
				v114 = v13:GetEquipment();
				v115 = (v114[12 + 1] and v20(v114[10 + 3])) or v20(0 - 0);
				v143 = 1 + 0;
			end
			if ((v143 == (668 - (89 + 578))) or ((1354 + 540) <= (2922 - 1516))) then
				v116 = (v114[1063 - (572 + 477)] and v20(v114[2 + 12])) or v20(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v144 = 0 + 0;
		while true do
			if (((1658 - (84 + 2)) >= (2522 - 991)) and (v144 == (0 + 0))) then
				v105 = 11953 - (497 + 345);
				v106 = 285 + 10826;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v117()
		if (v98.ImprovedNaturesCure:IsAvailable() or ((793 + 3894) < (5875 - (605 + 728)))) then
			v97.DispellableDebuffs = v11.MergeTable(v97.DispellableMagicDebuffs, v97.DispellableDiseaseDebuffs);
			v97.DispellableDebuffs = v11.MergeTable(v97.DispellableDebuffs, v97.DispellableCurseDebuffs);
		else
			v97.DispellableDebuffs = v97.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v117();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v118()
		return (v13:StealthUp(true, true) and (1.6 + 0)) or (1 - 0);
	end
	v98.Rake:RegisterPMultiplier(v98.RakeDebuff, v118);
	local function v119()
		local v145 = 0 + 0;
		while true do
			if (((12167 - 8876) > (1503 + 164)) and (v145 == (7 - 4))) then
				v113 = not v107 and (v98.Wrath:Count() > (0 + 0)) and (v98.Starfire:Count() > (489 - (457 + 32)));
				break;
			end
			if ((v145 == (1 + 1)) or ((2275 - (832 + 570)) == (1917 + 117))) then
				v111 = (not v107 and (((v98.Starfire:Count() == (0 + 0)) and (v98.Wrath:Count() > (0 - 0))) or v13:IsCasting(v98.Wrath))) or v110;
				v112 = (not v107 and (((v98.Wrath:Count() == (0 + 0)) and (v98.Starfire:Count() > (796 - (588 + 208)))) or v13:IsCasting(v98.Starfire))) or v109;
				v145 = 8 - 5;
			end
			if ((v145 == (1801 - (884 + 916))) or ((5895 - 3079) < (7 + 4))) then
				v109 = v13:BuffUp(v98.EclipseLunar) and v13:BuffDown(v98.EclipseSolar);
				v110 = v13:BuffUp(v98.EclipseSolar) and v13:BuffDown(v98.EclipseLunar);
				v145 = 655 - (232 + 421);
			end
			if (((5588 - (1569 + 320)) < (1155 + 3551)) and (v145 == (0 + 0))) then
				v107 = v13:BuffUp(v98.EclipseSolar) or v13:BuffUp(v98.EclipseLunar);
				v108 = v13:BuffUp(v98.EclipseSolar) and v13:BuffUp(v98.EclipseLunar);
				v145 = 3 - 2;
			end
		end
	end
	local function v120(v146)
		return v146:DebuffRefreshable(v98.SunfireDebuff) and (v106 > (610 - (316 + 289)));
	end
	local function v121(v147)
		return (v147:DebuffRefreshable(v98.MoonfireDebuff) and (v106 > (31 - 19)) and ((((v104 <= (1 + 3)) or (v13:Energy() < (1503 - (666 + 787)))) and v13:BuffDown(v98.HeartOfTheWild)) or (((v104 <= (429 - (360 + 65))) or (v13:Energy() < (47 + 3))) and v13:BuffUp(v98.HeartOfTheWild))) and v147:DebuffDown(v98.MoonfireDebuff)) or (v13:PrevGCD(255 - (79 + 175), v98.Sunfire) and ((v147:DebuffUp(v98.MoonfireDebuff) and (v147:DebuffRemains(v98.MoonfireDebuff) < (v147:DebuffDuration(v98.MoonfireDebuff) * (0.8 - 0)))) or v147:DebuffDown(v98.MoonfireDebuff)) and (v104 == (1 + 0)));
	end
	local function v122(v148)
		return v148:DebuffRefreshable(v98.MoonfireDebuff) and (v148:TimeToDie() > (15 - 10));
	end
	local function v123(v149)
		return ((v149:DebuffRefreshable(v98.Rip) or ((v13:Energy() > (173 - 83)) and (v149:DebuffRemains(v98.Rip) <= (909 - (503 + 396))))) and (((v13:ComboPoints() == (186 - (92 + 89))) and (v149:TimeToDie() > (v149:DebuffRemains(v98.Rip) + (46 - 22)))) or (((v149:DebuffRemains(v98.Rip) + (v13:ComboPoints() * (3 + 1))) < v149:TimeToDie()) and ((v149:DebuffRemains(v98.Rip) + 3 + 1 + (v13:ComboPoints() * (15 - 11))) > v149:TimeToDie())))) or (v149:DebuffDown(v98.Rip) and (v13:ComboPoints() > (1 + 1 + (v104 * (4 - 2)))));
	end
	local function v124(v150)
		return (v150:DebuffDown(v98.RakeDebuff) or v150:DebuffRefreshable(v98.RakeDebuff)) and (v150:TimeToDie() > (9 + 1)) and (v13:ComboPoints() < (3 + 2));
	end
	local function v125(v151)
		return (v151:DebuffUp(v98.AdaptiveSwarmDebuff));
	end
	local function v126()
		return v97.FriendlyUnitsWithBuffCount(v98.Rejuvenation) + v97.FriendlyUnitsWithBuffCount(v98.Regrowth) + v97.FriendlyUnitsWithBuffCount(v98.Wildgrowth);
	end
	local function v127()
		return v97.FriendlyUnitsWithoutBuffCount(v98.Rejuvenation);
	end
	local function v128(v152)
		return v152:BuffUp(v98.Rejuvenation) or v152:BuffUp(v98.Regrowth) or v152:BuffUp(v98.Wildgrowth);
	end
	local function v129()
		ShouldReturn = v97.HandleTopTrinket(v100, v30 and (v13:BuffUp(v98.HeartOfTheWild) or v13:BuffUp(v98.IncarnationBuff)), 121 - 81, nil);
		if (((331 + 2315) >= (1335 - 459)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v97.HandleBottomTrinket(v100, v30 and (v13:BuffUp(v98.HeartOfTheWild) or v13:BuffUp(v98.IncarnationBuff)), 1284 - (485 + 759), nil);
		if (((1420 - 806) <= (4373 - (442 + 747))) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v130()
		if (((4261 - (832 + 303)) == (4072 - (88 + 858))) and v98.Rake:IsReady() and (v13:StealthUp(false, true))) then
			if (v23(v98.Rake, not v15:IsInMeleeRange(4 + 6)) or ((1810 + 377) >= (205 + 4749))) then
				return "rake cat 2";
			end
		end
		if ((UseTrinkets and not v13:StealthUp(false, true)) or ((4666 - (766 + 23)) == (17648 - 14073))) then
			local v165 = v129();
			if (((966 - 259) > (1664 - 1032)) and v165) then
				return v165;
			end
		end
		if (v98.AdaptiveSwarm:IsCastable() or ((1853 - 1307) >= (3757 - (1036 + 37)))) then
			if (((1039 + 426) <= (8375 - 4074)) and v23(v98.AdaptiveSwarm, not v15:IsSpellInRange(v98.AdaptiveSwarm))) then
				return "adaptive_swarm cat";
			end
		end
		if (((1341 + 363) > (2905 - (641 + 839))) and v50 and v30 and v98.ConvokeTheSpirits:IsCastable()) then
			if (v13:BuffUp(v98.CatForm) or ((1600 - (910 + 3)) == (10793 - 6559))) then
				if (((v13:BuffUp(v98.HeartOfTheWild) or (v98.HeartOfTheWild:CooldownRemains() > (1744 - (1466 + 218))) or not v98.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (23 + 27)) and (((v13:ComboPoints() < (1153 - (556 + 592))) and (v15:DebuffRemains(v98.Rip) > (2 + 3))) or (v104 > (809 - (329 + 479))))) or ((4184 - (174 + 680)) < (4909 - 3480))) then
					if (((2377 - 1230) >= (240 + 95)) and v23(v98.ConvokeTheSpirits, not v15:IsInRange(769 - (396 + 343)))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((304 + 3131) > (3574 - (29 + 1448))) and v98.Sunfire:IsReady() and v13:BuffDown(v98.CatForm) and (v15:TimeToDie() > (1394 - (135 + 1254))) and (not v98.Rip:IsAvailable() or v15:DebuffUp(v98.Rip) or (v13:Energy() < (113 - 83)))) then
			if (v97.CastCycle(v98.Sunfire, v103, v120, not v15:IsSpellInRange(v98.Sunfire), nil, nil, v101.SunfireMouseover) or ((17602 - 13832) >= (2694 + 1347))) then
				return "sunfire cat 20";
			end
		end
		if ((v98.Moonfire:IsReady() and v13:BuffDown(v98.CatForm) and (v15:TimeToDie() > (1532 - (389 + 1138))) and (not v98.Rip:IsAvailable() or v15:DebuffUp(v98.Rip) or (v13:Energy() < (604 - (102 + 472))))) or ((3578 + 213) <= (894 + 717))) then
			if (v97.CastCycle(v98.Moonfire, v103, v121, not v15:IsSpellInRange(v98.Moonfire), nil, nil, v101.MoonfireMouseover) or ((4269 + 309) <= (3553 - (320 + 1225)))) then
				return "moonfire cat 22";
			end
		end
		if (((2002 - 877) <= (1271 + 805)) and v98.Sunfire:IsReady() and v15:DebuffDown(v98.SunfireDebuff) and (v15:TimeToDie() > (1469 - (157 + 1307)))) then
			if (v23(v98.Sunfire, not v15:IsSpellInRange(v98.Sunfire)) or ((2602 - (821 + 1038)) >= (10975 - 6576))) then
				return "sunfire cat 24";
			end
		end
		if (((127 + 1028) < (2971 - 1298)) and v98.Moonfire:IsReady() and v13:BuffDown(v98.CatForm) and v15:DebuffDown(v98.MoonfireDebuff) and (v15:TimeToDie() > (2 + 3))) then
			if (v23(v98.Moonfire, not v15:IsSpellInRange(v98.Moonfire)) or ((5760 - 3436) <= (1604 - (834 + 192)))) then
				return "moonfire cat 24";
			end
		end
		if (((240 + 3527) == (967 + 2800)) and v98.Starsurge:IsReady() and (v13:BuffDown(v98.CatForm))) then
			if (((88 + 4001) == (6334 - 2245)) and v23(v98.Starsurge, not v15:IsSpellInRange(v98.Starsurge))) then
				return "starsurge cat 26";
			end
		end
		if (((4762 - (300 + 4)) >= (448 + 1226)) and v98.HeartOfTheWild:IsCastable() and v30 and ((v98.ConvokeTheSpirits:CooldownRemains() < (78 - 48)) or not v98.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v98.HeartOfTheWild) and v15:DebuffUp(v98.SunfireDebuff) and (v15:DebuffUp(v98.MoonfireDebuff) or (v104 > (366 - (112 + 250))))) then
			if (((388 + 584) <= (3552 - 2134)) and v23(v98.HeartOfTheWild)) then
				return "heart_of_the_wild cat 26";
			end
		end
		if ((v98.CatForm:IsReady() and v13:BuffDown(v98.CatForm) and (v13:Energy() >= (18 + 12)) and v34) or ((2554 + 2384) < (3562 + 1200))) then
			if (v23(v98.CatForm) or ((1242 + 1262) > (3168 + 1096))) then
				return "cat_form cat 28";
			end
		end
		if (((3567 - (1001 + 413)) == (4800 - 2647)) and v98.FerociousBite:IsReady() and (((v13:ComboPoints() > (885 - (244 + 638))) and (v15:TimeToDie() < (703 - (627 + 66)))) or ((v13:ComboPoints() == (14 - 9)) and (v13:Energy() >= (627 - (512 + 90))) and (not v98.Rip:IsAvailable() or (v15:DebuffRemains(v98.Rip) > (1911 - (1665 + 241))))))) then
			if (v23(v98.FerociousBite, not v15:IsInMeleeRange(722 - (373 + 344))) or ((229 + 278) >= (686 + 1905))) then
				return "ferocious_bite cat 32";
			end
		end
		if (((11819 - 7338) == (7582 - 3101)) and v98.Rip:IsAvailable() and v98.Rip:IsReady() and (v104 < (1110 - (35 + 1064))) and v123(v15)) then
			if (v23(v98.Rip, not v15:IsInMeleeRange(4 + 1)) or ((4980 - 2652) < (3 + 690))) then
				return "rip cat 34";
			end
		end
		if (((5564 - (298 + 938)) == (5587 - (233 + 1026))) and v98.Thrash:IsReady() and (v104 >= (1668 - (636 + 1030))) and v15:DebuffRefreshable(v98.ThrashDebuff)) then
			if (((812 + 776) >= (1302 + 30)) and v23(v98.Thrash, not v15:IsInMeleeRange(3 + 5))) then
				return "thrash cat";
			end
		end
		if ((v98.Rake:IsReady() and v124(v15)) or ((283 + 3891) > (4469 - (55 + 166)))) then
			if (v23(v98.Rake, not v15:IsInMeleeRange(1 + 4)) or ((462 + 4124) <= (312 - 230))) then
				return "rake cat 36";
			end
		end
		if (((4160 - (36 + 261)) == (6755 - 2892)) and v98.Rake:IsReady() and ((v13:ComboPoints() < (1373 - (34 + 1334))) or (v13:Energy() > (35 + 55))) and (v15:PMultiplier(v98.Rake) <= v13:PMultiplier(v98.Rake)) and v125(v15)) then
			if (v23(v98.Rake, not v15:IsInMeleeRange(4 + 1)) or ((1565 - (1035 + 248)) <= (63 - (20 + 1)))) then
				return "rake cat 40";
			end
		end
		if (((2402 + 2207) >= (1085 - (134 + 185))) and v98.Swipe:IsReady() and (v104 >= (1135 - (549 + 584)))) then
			if (v23(v98.Swipe, not v15:IsInMeleeRange(693 - (314 + 371))) or ((3954 - 2802) == (3456 - (478 + 490)))) then
				return "swipe cat 38";
			end
		end
		if (((1813 + 1609) > (4522 - (786 + 386))) and v98.Shred:IsReady() and ((v13:ComboPoints() < (16 - 11)) or (v13:Energy() > (1469 - (1055 + 324))))) then
			if (((2217 - (1093 + 247)) > (335 + 41)) and v23(v98.Shred, not v15:IsInMeleeRange(1 + 4))) then
				return "shred cat 42";
			end
		end
	end
	local function v131()
		if ((v98.HeartOfTheWild:IsCastable() and v30 and ((v98.ConvokeTheSpirits:CooldownRemains() < (119 - 89)) or (v98.ConvokeTheSpirits:CooldownRemains() > (305 - 215)) or not v98.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v98.HeartOfTheWild)) or ((8871 - 5753) <= (4651 - 2800))) then
			if (v23(v98.HeartOfTheWild) or ((59 + 106) >= (13452 - 9960))) then
				return "heart_of_the_wild owl 2";
			end
		end
		if (((13611 - 9662) < (3662 + 1194)) and v98.MoonkinForm:IsReady() and (v13:BuffDown(v98.MoonkinForm)) and v34) then
			if (v23(v98.MoonkinForm) or ((10935 - 6659) < (3704 - (364 + 324)))) then
				return "moonkin_form owl 4";
			end
		end
		if (((12856 - 8166) > (9898 - 5773)) and v98.Starsurge:IsReady() and ((v104 < (2 + 4)) or (not v109 and (v104 < (33 - 25)))) and v34) then
			if (v23(v98.Starsurge, not v15:IsSpellInRange(v98.Starsurge)) or ((80 - 30) >= (2721 - 1825))) then
				return "starsurge owl 8";
			end
		end
		if ((v98.Moonfire:IsReady() and ((v104 < (1273 - (1249 + 19))) or (not v109 and (v104 < (7 + 0))))) or ((6671 - 4957) >= (4044 - (686 + 400)))) then
			if (v97.CastCycle(v98.Moonfire, v103, v122, not v15:IsSpellInRange(v98.Moonfire), nil, nil, v101.MoonfireMouseover) or ((1170 + 321) < (873 - (73 + 156)))) then
				return "moonfire owl 10";
			end
		end
		if (((4 + 700) < (1798 - (721 + 90))) and v98.Sunfire:IsReady()) then
			if (((42 + 3676) > (6188 - 4282)) and v97.CastCycle(v98.Sunfire, v103, v120, not v15:IsSpellInRange(v98.Sunfire), nil, nil, v101.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if ((v50 and v30 and v98.ConvokeTheSpirits:IsCastable()) or ((1428 - (224 + 246)) > (5888 - 2253))) then
			if (((6446 - 2945) <= (815 + 3677)) and v13:BuffUp(v98.MoonkinForm)) then
				if (v23(v98.ConvokeTheSpirits, not v15:IsInRange(1 + 29)) or ((2529 + 913) < (5065 - 2517))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((9567 - 6692) >= (1977 - (203 + 310))) and v98.Wrath:IsReady() and (v13:BuffDown(v98.CatForm) or not v15:IsInMeleeRange(2001 - (1238 + 755))) and ((v110 and (v104 == (1 + 0))) or v111 or (v113 and (v104 > (1535 - (709 + 825)))))) then
			if (v23(v98.Wrath, not v15:IsSpellInRange(v98.Wrath), true) or ((8839 - 4042) >= (7126 - 2233))) then
				return "wrath owl 14";
			end
		end
		if (v98.Starfire:IsReady() or ((1415 - (196 + 668)) > (8164 - 6096))) then
			if (((4378 - 2264) > (1777 - (171 + 662))) and v23(v98.Starfire, not v15:IsSpellInRange(v98.Starfire), true)) then
				return "starfire owl 16";
			end
		end
	end
	local function v132()
		ShouldReturn = v97.InterruptWithStun(v98.IncapacitatingRoar, 101 - (4 + 89));
		if (ShouldReturn or ((7928 - 5666) >= (1128 + 1968))) then
			return ShouldReturn;
		end
		if ((v13:BuffUp(v98.CatForm) and (v13:ComboPoints() > (0 - 0))) or ((885 + 1370) >= (5023 - (35 + 1451)))) then
			ShouldReturn = v97.InterruptWithStun(v98.Maim, 1461 - (28 + 1425));
			if (ShouldReturn or ((5830 - (941 + 1052)) < (1253 + 53))) then
				return ShouldReturn;
			end
		end
		ShouldReturn = v97.InterruptWithStun(v98.MightyBash, 1522 - (822 + 692));
		if (((4211 - 1261) == (1390 + 1560)) and ShouldReturn) then
			return ShouldReturn;
		end
		v119();
		local v153 = 297 - (45 + 252);
		if (v98.Rip:IsAvailable() or ((4674 + 49) < (1136 + 2162))) then
			v153 = v153 + (2 - 1);
		end
		if (((1569 - (114 + 319)) >= (220 - 66)) and v98.Rake:IsAvailable()) then
			v153 = v153 + (1 - 0);
		end
		if (v98.Thrash:IsAvailable() or ((173 + 98) > (7073 - 2325))) then
			v153 = v153 + (1 - 0);
		end
		if (((6703 - (556 + 1407)) >= (4358 - (741 + 465))) and (v153 >= (467 - (170 + 295))) and v15:IsInMeleeRange(5 + 3)) then
			local v166 = 0 + 0;
			local v167;
			while true do
				if ((v166 == (0 - 0)) or ((2138 + 440) >= (2175 + 1215))) then
					v167 = v130();
					if (((24 + 17) <= (2891 - (957 + 273))) and v167) then
						return v167;
					end
					break;
				end
			end
		end
		if (((161 + 440) < (1426 + 2134)) and v98.AdaptiveSwarm:IsCastable()) then
			if (((895 - 660) < (1810 - 1123)) and v23(v98.AdaptiveSwarm, not v15:IsSpellInRange(v98.AdaptiveSwarm))) then
				return "adaptive_swarm main";
			end
		end
		if (((13894 - 9345) > (5709 - 4556)) and v98.MoonkinForm:IsAvailable()) then
			local v168 = v131();
			if (v168 or ((6454 - (389 + 1391)) < (2932 + 1740))) then
				return v168;
			end
		end
		if (((382 + 3286) < (10383 - 5822)) and v98.Sunfire:IsReady() and (v15:DebuffRefreshable(v98.SunfireDebuff))) then
			if (v23(v98.Sunfire, not v15:IsSpellInRange(v98.Sunfire)) or ((1406 - (783 + 168)) == (12098 - 8493))) then
				return "sunfire main 24";
			end
		end
		if ((v98.Moonfire:IsReady() and (v15:DebuffRefreshable(v98.MoonfireDebuff))) or ((2620 + 43) == (3623 - (309 + 2)))) then
			if (((13133 - 8856) <= (5687 - (1090 + 122))) and v23(v98.Moonfire, not v15:IsSpellInRange(v98.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if ((v98.Starsurge:IsReady() and (v13:BuffDown(v98.CatForm))) or ((283 + 587) == (3993 - 2804))) then
			if (((1063 + 490) <= (4251 - (628 + 490))) and v23(v98.Starsurge, not v15:IsSpellInRange(v98.Starsurge))) then
				return "starsurge main 28";
			end
		end
		if ((v98.Starfire:IsReady() and (v104 > (1 + 1))) or ((5538 - 3301) >= (16045 - 12534))) then
			if (v23(v98.Starfire, not v15:IsSpellInRange(v98.Starfire), true) or ((2098 - (431 + 343)) > (6099 - 3079))) then
				return "starfire owl 16";
			end
		end
		if ((v98.Wrath:IsReady() and (v13:BuffDown(v98.CatForm) or not v15:IsInMeleeRange(23 - 15))) or ((2364 + 628) == (241 + 1640))) then
			if (((4801 - (556 + 1139)) > (1541 - (6 + 9))) and v23(v98.Wrath, not v15:IsSpellInRange(v98.Wrath), true)) then
				return "wrath main 30";
			end
		end
		if (((554 + 2469) < (1983 + 1887)) and v98.Moonfire:IsReady() and (v13:BuffDown(v98.CatForm) or not v15:IsInMeleeRange(177 - (28 + 141)))) then
			if (((56 + 87) > (90 - 16)) and v23(v98.Moonfire, not v15:IsSpellInRange(v98.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (((13 + 5) < (3429 - (486 + 831))) and true) then
			if (((2854 - 1757) <= (5731 - 4103)) and v23(v98.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v133()
		if (((875 + 3755) == (14639 - 10009)) and v16 and v97.DispellableFriendlyUnit() and v98.NaturesCure:IsReady()) then
			if (((4803 - (668 + 595)) > (2415 + 268)) and v23(v101.NaturesCureFocus)) then
				return "natures_cure dispel 2";
			end
		end
	end
	local function v134()
		local v154 = 0 + 0;
		while true do
			if (((13073 - 8279) >= (3565 - (23 + 267))) and (v154 == (1944 - (1129 + 815)))) then
				if (((1871 - (371 + 16)) == (3234 - (1326 + 424))) and (v13:HealthPercentage() <= v93) and v94 and v98.Barkskin:IsReady()) then
					if (((2711 - 1279) < (12990 - 9435)) and v23(v98.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((v13:HealthPercentage() <= v95) and v96 and v98.Renewal:IsReady()) or ((1183 - (88 + 30)) > (4349 - (720 + 51)))) then
					if (v23(v98.Renewal, nil, nil, true) or ((10666 - 5871) < (3183 - (421 + 1355)))) then
						return "renewal defensive 2";
					end
				end
				v154 = 1 - 0;
			end
			if (((911 + 942) < (5896 - (286 + 797))) and (v154 == (3 - 2))) then
				if ((v99.Healthstone:IsReady() and v43 and (v13:HealthPercentage() <= v44)) or ((4672 - 1851) < (2870 - (397 + 42)))) then
					if (v23(v101.Healthstone, nil, nil, true) or ((898 + 1976) < (2981 - (24 + 776)))) then
						return "healthstone defensive 3";
					end
				end
				if ((v37 and (v13:HealthPercentage() <= v39)) or ((4142 - 1453) <= (1128 - (222 + 563)))) then
					if ((v38 == "Refreshing Healing Potion") or ((4117 - 2248) == (1447 + 562))) then
						if (v99.RefreshingHealingPotion:IsReady() or ((3736 - (23 + 167)) < (4120 - (690 + 1108)))) then
							if (v23(v101.RefreshingHealingPotion, nil, nil, true) or ((752 + 1330) == (3937 + 836))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		if (((4092 - (40 + 808)) > (174 + 881)) and (not v16 or not v16:Exists() or v16:IsDeadOrGhost() or not v16:IsInRange(152 - 112))) then
			return;
		end
		if ((v98.Swiftmend:IsReady() and not v128(v16) and v13:BuffDown(v98.SoulOfTheForestBuff)) or ((3167 + 146) <= (941 + 837))) then
			if (v23(v101.RejuvenationFocus) or ((780 + 641) >= (2675 - (47 + 524)))) then
				return "rejuvenation ramp";
			end
		end
		if (((1176 + 636) <= (8881 - 5632)) and v98.Swiftmend:IsReady() and v128(v16)) then
			if (((2426 - 803) <= (4462 - 2505)) and v23(v101.SwiftmendFocus)) then
				return "swiftmend ramp";
			end
		end
		if (((6138 - (1165 + 561)) == (132 + 4280)) and v13:BuffUp(v98.SoulOfTheForestBuff) and v98.Wildgrowth:IsReady()) then
			if (((5420 - 3670) >= (322 + 520)) and v23(v101.WildgrowthFocus, nil, true)) then
				return "wildgrowth ramp";
			end
		end
		if (((4851 - (341 + 138)) > (500 + 1350)) and v98.Innervate:IsReady() and v13:BuffDown(v98.Innervate)) then
			if (((478 - 246) < (1147 - (89 + 237))) and v23(v101.InnervatePlayer, nil, nil, true)) then
				return "innervate ramp";
			end
		end
		if (((1666 - 1148) < (1898 - 996)) and v13:BuffUp(v98.Innervate) and (v127() > (881 - (581 + 300))) and v17 and v17:Exists() and v17:BuffRefreshable(v98.Rejuvenation)) then
			if (((4214 - (855 + 365)) > (2037 - 1179)) and v23(v101.RejuvenationMouseover)) then
				return "rejuvenation_cycle ramp";
			end
		end
	end
	local function v136()
		local v155 = 0 + 0;
		while true do
			if (((1235 - (1030 + 205)) == v155) or ((3526 + 229) <= (852 + 63))) then
				if (((4232 - (156 + 130)) > (8504 - 4761)) and (not v16 or not v16:Exists() or v16:IsDeadOrGhost() or not v16:IsInRange(67 - 27))) then
					return;
				end
				if (v35 or ((2734 - 1399) >= (872 + 2434))) then
					local v211 = 0 + 0;
					while true do
						if (((4913 - (10 + 59)) > (638 + 1615)) and (v211 == (0 - 0))) then
							if (((1615 - (671 + 492)) == (360 + 92)) and UseTrinkets) then
								local v228 = v129();
								if (v228 or ((5772 - (369 + 846)) < (553 + 1534))) then
									return v228;
								end
							end
							if (((3307 + 567) == (5819 - (1036 + 909))) and v51 and v30 and v13:AffectingCombat() and (v126() > (3 + 0)) and v98.NaturesVigil:IsReady()) then
								if (v23(v98.NaturesVigil, nil, nil, true) or ((3253 - 1315) > (5138 - (11 + 192)))) then
									return "natures_vigil healing";
								end
							end
							if ((v98.Swiftmend:IsReady() and v79 and v13:BuffDown(v98.SoulOfTheForestBuff) and v128(v16) and (v16:HealthPercentage() <= v80)) or ((2151 + 2104) < (3598 - (135 + 40)))) then
								if (((3522 - 2068) <= (1502 + 989)) and v23(v101.SwiftmendFocus)) then
									return "swiftmend healing";
								end
							end
							v211 = 2 - 1;
						end
						if ((v211 == (2 - 0)) or ((4333 - (50 + 126)) <= (7804 - 5001))) then
							if (((1075 + 3778) >= (4395 - (1233 + 180))) and v13:AffectingCombat() and v30 and v98.Tranquility:IsReady() and v97.AreUnitsBelowHealthPercentage(v82, v83)) then
								if (((5103 - (522 + 447)) > (4778 - (107 + 1314))) and v23(v98.Tranquility, nil, true)) then
									return "tranquility healing";
								end
							end
							if ((v13:AffectingCombat() and v30 and v98.Tranquility:IsReady() and v13:BuffUp(v98.IncarnationBuff) and v97.AreUnitsBelowHealthPercentage(v85, v86)) or ((1586 + 1831) < (7721 - 5187))) then
								if (v23(v98.Tranquility, nil, true) or ((1157 + 1565) <= (325 - 161))) then
									return "tranquility_tree healing";
								end
							end
							if ((v13:AffectingCombat() and v30 and v98.ConvokeTheSpirits:IsReady() and v97.AreUnitsBelowHealthPercentage(v60, v61)) or ((9527 - 7119) < (4019 - (716 + 1194)))) then
								if (v23(v98.ConvokeTheSpirits) or ((1 + 32) == (156 + 1299))) then
									return "convoke_the_spirits healing";
								end
							end
							v211 = 506 - (74 + 429);
						end
						if ((v211 == (7 - 3)) or ((220 + 223) >= (9190 - 5175))) then
							if (((2393 + 989) > (511 - 345)) and (v65 == "Anyone")) then
								if ((v98.IronBark:IsReady() and (v16:HealthPercentage() <= v66)) or ((692 - 412) == (3492 - (279 + 154)))) then
									if (((2659 - (454 + 324)) > (1018 + 275)) and v23(v101.IronBarkFocus)) then
										return "iron_bark healing";
									end
								end
							elseif (((2374 - (12 + 5)) == (1271 + 1086)) and (v65 == "Tank Only")) then
								if (((312 - 189) == (46 + 77)) and v98.IronBark:IsReady() and (v16:HealthPercentage() <= v66) and (Commons.UnitGroupRole(v16) == "TANK")) then
									if (v23(v101.IronBarkFocus) or ((2149 - (277 + 816)) >= (14494 - 11102))) then
										return "iron_bark healing";
									end
								end
							elseif ((v65 == "Tank and Self") or ((2264 - (1058 + 125)) < (202 + 873))) then
								if ((v98.IronBark:IsReady() and (v16:HealthPercentage() <= v66) and ((Commons.UnitGroupRole(v16) == "TANK") or (Commons.UnitGroupRole(v16) == "HEALER"))) or ((2024 - (815 + 160)) >= (19016 - 14584))) then
									if (v23(v101.IronBarkFocus) or ((11318 - 6550) <= (202 + 644))) then
										return "iron_bark healing";
									end
								end
							end
							if ((v98.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) or ((9815 - 6457) <= (3318 - (41 + 1857)))) then
								if (v23(v101.AdaptiveSwarmFocus) or ((5632 - (1222 + 671)) <= (7766 - 4761))) then
									return "adaptive_swarm healing";
								end
							end
							if ((v13:AffectingCombat() and v67 and (v97.UnitGroupRole(v16) == "TANK") and (v97.FriendlyUnitsWithBuffCount(v98.Lifebloom, true, false) < (1 - 0)) and (v16:HealthPercentage() <= (v68 - (v25(v13:BuffUp(v98.CatForm)) * (1197 - (229 + 953))))) and v98.Lifebloom:IsCastable() and v16:BuffRefreshable(v98.Lifebloom)) or ((3433 - (1111 + 663)) >= (3713 - (874 + 705)))) then
								if (v23(v101.LifebloomFocus) or ((457 + 2803) < (1607 + 748))) then
									return "lifebloom healing";
								end
							end
							v211 = 10 - 5;
						end
						if (((1 + 2) == v211) or ((1348 - (642 + 37)) == (963 + 3260))) then
							if ((v98.CenarionWard:IsReady() and v57 and (v16:HealthPercentage() <= v58)) or ((271 + 1421) < (1475 - 887))) then
								if (v23(v101.CenarionWardFocus) or ((5251 - (233 + 221)) < (8442 - 4791))) then
									return "cenarion_ward healing";
								end
							end
							if ((v13:BuffUp(v98.NaturesSwiftness) and v98.Regrowth:IsCastable()) or ((3677 + 500) > (6391 - (718 + 823)))) then
								if (v23(v101.RegrowthFocus) or ((252 + 148) > (1916 - (266 + 539)))) then
									return "regrowth_swiftness healing";
								end
							end
							if (((8637 - 5586) > (2230 - (636 + 589))) and v98.NaturesSwiftness:IsReady() and v71 and (v16:HealthPercentage() <= v72)) then
								if (((8765 - 5072) <= (9037 - 4655)) and v23(v98.NaturesSwiftness)) then
									return "natures_swiftness healing";
								end
							end
							v211 = 4 + 0;
						end
						if ((v211 == (1 + 0)) or ((4297 - (657 + 358)) > (10855 - 6755))) then
							if ((v13:BuffUp(v98.SoulOfTheForestBuff) and v98.Wildgrowth:IsReady() and v97.AreUnitsBelowHealthPercentage(v88, v89)) or ((8156 - 4576) < (4031 - (1151 + 36)))) then
								if (((86 + 3) < (1181 + 3309)) and v23(v101.WildgrowthFocus, nil, true)) then
									return "wildgrowth_sotf healing";
								end
							end
							if ((v54 and v98.GroveGuardians:IsReady() and (v98.GroveGuardians:TimeSinceLastCast() > (14 - 9)) and v97.AreUnitsBelowHealthPercentage(v55, v56)) or ((6815 - (1552 + 280)) < (2642 - (64 + 770)))) then
								if (((2600 + 1229) > (8555 - 4786)) and v23(v101.GroveGuardiansFocus, nil, nil)) then
									return "grove_guardians healing";
								end
							end
							if (((264 + 1221) <= (4147 - (157 + 1086))) and v13:AffectingCombat() and v30 and v98.Flourish:IsReady() and v13:BuffDown(v98.Flourish) and (v126() > (7 - 3)) and v97.AreUnitsBelowHealthPercentage(v63, v64)) then
								if (((18697 - 14428) == (6547 - 2278)) and v23(v98.Flourish, nil, nil, true)) then
									return "flourish healing";
								end
							end
							v211 = 2 - 0;
						end
						if (((1206 - (599 + 220)) <= (5539 - 2757)) and (v211 == (1937 - (1813 + 118)))) then
							if ((v98.Regrowth:IsCastable() and v73 and (v16:HealthPercentage() <= v74)) or ((1389 + 510) <= (2134 - (841 + 376)))) then
								if (v23(v101.RegrowthFocus, nil, true) or ((6041 - 1729) <= (204 + 672))) then
									return "regrowth healing";
								end
							end
							if (((6092 - 3860) <= (3455 - (464 + 395))) and v13:BuffUp(v98.Innervate) and (v127() > (0 - 0)) and v17 and v17:Exists() and v17:BuffRefreshable(v98.Rejuvenation)) then
								if (((1007 + 1088) < (4523 - (467 + 370))) and v23(v101.RejuvenationMouseover)) then
									return "rejuvenation_cycle healing";
								end
							end
							if ((v98.Rejuvenation:IsCastable() and v77 and v16:BuffRefreshable(v98.Rejuvenation) and (v16:HealthPercentage() <= v78)) or ((3295 - 1700) >= (3285 + 1189))) then
								if (v23(v101.RejuvenationFocus) or ((15833 - 11214) < (450 + 2432))) then
									return "rejuvenation healing";
								end
							end
							v211 = 16 - 9;
						end
						if ((v211 == (527 - (150 + 370))) or ((1576 - (74 + 1208)) >= (11882 - 7051))) then
							if (((9622 - 7593) <= (2195 + 889)) and v98.Regrowth:IsCastable() and v75 and v16:BuffUp(v98.Rejuvenation) and (v16:HealthPercentage() <= v76)) then
								if (v23(v101.RegrowthFocus, nil, true) or ((2427 - (14 + 376)) == (4197 - 1777))) then
									return "regrowth healing";
								end
							end
							break;
						end
						if (((2885 + 1573) > (3430 + 474)) and (v211 == (5 + 0))) then
							if (((1277 - 841) >= (93 + 30)) and v13:AffectingCombat() and v69 and (v97.UnitGroupRole(v16) ~= "TANK") and (v97.FriendlyUnitsWithBuffCount(v98.Lifebloom, false, true) < (79 - (23 + 55))) and (v98.Undergrowth:IsAvailable() or v97.IsSoloMode()) and (v16:HealthPercentage() <= (v70 - (v25(v13:BuffUp(v98.CatForm)) * (35 - 20)))) and v98.Lifebloom:IsCastable() and v16:BuffRefreshable(v98.Lifebloom)) then
								if (((334 + 166) < (1631 + 185)) and v23(v101.LifebloomFocus)) then
									return "lifebloom healing";
								end
							end
							if (((5540 - 1966) == (1125 + 2449)) and (v52 == "Player")) then
								if (((1122 - (652 + 249)) < (1043 - 653)) and v13:AffectingCombat() and (v98.Efflorescence:TimeSinceLastCast() > (1883 - (708 + 1160)))) then
									if (v23(v101.EfflorescencePlayer) or ((6006 - 3793) <= (2590 - 1169))) then
										return "efflorescence healing player";
									end
								end
							elseif (((3085 - (10 + 17)) < (1092 + 3768)) and (v52 == "Cursor")) then
								if ((v13:AffectingCombat() and (v98.Efflorescence:TimeSinceLastCast() > (1747 - (1400 + 332)))) or ((2485 - 1189) >= (6354 - (242 + 1666)))) then
									if (v23(v101.EfflorescenceCursor) or ((597 + 796) > (1646 + 2843))) then
										return "efflorescence healing cursor";
									end
								end
							elseif ((v52 == "Confirmation") or ((3771 + 653) < (967 - (850 + 90)))) then
								if ((v13:AffectingCombat() and (v98.Efflorescence:TimeSinceLastCast() > (25 - 10))) or ((3387 - (360 + 1030)) > (3377 + 438))) then
									if (((9779 - 6314) > (2631 - 718)) and v23(v98.Efflorescence)) then
										return "efflorescence healing confirmation";
									end
								end
							end
							if (((2394 - (909 + 752)) < (3042 - (109 + 1114))) and v98.Wildgrowth:IsReady() and v90 and v97.AreUnitsBelowHealthPercentage(v91, v92) and (not v98.Swiftmend:IsAvailable() or not v98.Swiftmend:IsReady())) then
								if (v23(v101.WildgrowthFocus, nil, true) or ((8046 - 3651) == (1851 + 2904))) then
									return "wildgrowth healing";
								end
							end
							v211 = 248 - (6 + 236);
						end
					end
				end
				break;
			end
		end
	end
	local function v137()
		if (v45 or ((2390 + 1403) < (1907 + 462))) then
			local v169 = 0 - 0;
			while true do
				if ((v169 == (0 - 0)) or ((5217 - (1076 + 57)) == (44 + 221))) then
					ShouldReturn = v97.HandleAfflicted(v98.NaturesCure, v101.NaturesCureMouseover, 729 - (579 + 110));
					if (((345 + 4013) == (3854 + 504)) and ShouldReturn) then
						return ShouldReturn;
					end
					v169 = 1 + 0;
				end
				if ((v169 == (409 - (174 + 233))) or ((8765 - 5627) < (1742 - 749))) then
					ShouldReturn = v97.HandleAfflicted(v98.Regrowth, v101.RegrowthMouseover, 18 + 22, true);
					if (((4504 - (663 + 511)) > (2073 + 250)) and ShouldReturn) then
						return ShouldReturn;
					end
					v169 = 1 + 2;
				end
				if ((v169 == (12 - 8)) or ((2196 + 1430) == (9391 - 5402))) then
					ShouldReturn = v97.HandleAfflicted(v98.Wildgrowth, v101.WildgrowthMouseover, 96 - 56, true);
					if (ShouldReturn or ((438 + 478) == (5198 - 2527))) then
						return ShouldReturn;
					end
					break;
				end
				if (((194 + 78) == (25 + 247)) and (v169 == (725 - (478 + 244)))) then
					ShouldReturn = v97.HandleAfflicted(v98.Swiftmend, v101.SwiftmendMouseover, 557 - (440 + 77));
					if (((1932 + 2317) <= (17710 - 12871)) and ShouldReturn) then
						return ShouldReturn;
					end
					v169 = 1560 - (655 + 901);
				end
				if (((515 + 2262) < (2450 + 750)) and (v169 == (1 + 0))) then
					ShouldReturn = v97.HandleAfflicted(v98.Rejuvenation, v101.RejuvenationMouseover, 161 - 121);
					if (((1540 - (695 + 750)) < (6682 - 4725)) and ShouldReturn) then
						return ShouldReturn;
					end
					v169 = 2 - 0;
				end
			end
		end
		if (((3321 - 2495) < (2068 - (285 + 66))) and (v42 or v41) and v31) then
			local v170 = 0 - 0;
			local v171;
			while true do
				if (((2736 - (682 + 628)) >= (179 + 926)) and (v170 == (299 - (176 + 123)))) then
					v171 = v133();
					if (((1152 + 1602) <= (2452 + 927)) and v171) then
						return v171;
					end
					break;
				end
			end
		end
		local v156 = v134();
		if (v156 or ((4196 - (239 + 30)) == (385 + 1028))) then
			return v156;
		end
		if (v32 or ((1110 + 44) <= (1394 - 606))) then
			local v172 = 0 - 0;
			while true do
				if ((v172 == (315 - (306 + 9))) or ((5733 - 4090) > (588 + 2791))) then
					v156 = v135();
					if (v156 or ((1720 + 1083) > (2190 + 2359))) then
						return v156;
					end
					break;
				end
			end
		end
		v156 = v136();
		if (v156 or ((629 - 409) >= (4397 - (1140 + 235)))) then
			return v156;
		end
		if (((1796 + 1026) == (2588 + 234)) and v97.TargetIsValid() and v33) then
			local v173 = 0 + 0;
			while true do
				if ((v173 == (52 - (33 + 19))) or ((384 + 677) == (5565 - 3708))) then
					v156 = v132();
					if (((1216 + 1544) > (2674 - 1310)) and v156) then
						return v156;
					end
					break;
				end
			end
		end
	end
	local function v138()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (690 - (586 + 103))) or ((447 + 4455) <= (11067 - 7472))) then
				if (((v42 or v41) and v31) or ((5340 - (1309 + 179)) == (528 - 235))) then
					local v212 = 0 + 0;
					local v213;
					while true do
						if ((v212 == (0 - 0)) or ((1178 + 381) == (9747 - 5159))) then
							v213 = v133();
							if (v213 or ((8934 - 4450) == (1397 - (295 + 314)))) then
								return v213;
							end
							break;
						end
					end
				end
				if (((11219 - 6651) >= (5869 - (1300 + 662))) and v28 and v35) then
					local v214 = v136();
					if (((3912 - 2666) < (5225 - (1178 + 577))) and v214) then
						return v214;
					end
				end
				v157 = 2 + 0;
			end
			if (((12025 - 7957) >= (2377 - (851 + 554))) and (v157 == (0 + 0))) then
				if (((1367 - 874) < (8454 - 4561)) and v45) then
					local v215 = 302 - (115 + 187);
					while true do
						if ((v215 == (3 + 0)) or ((1395 + 78) >= (13130 - 9798))) then
							ShouldReturn = v97.HandleAfflicted(v98.Swiftmend, v101.SwiftmendMouseover, 1201 - (160 + 1001));
							if (ShouldReturn or ((3544 + 507) <= (799 + 358))) then
								return ShouldReturn;
							end
							v215 = 7 - 3;
						end
						if (((962 - (237 + 121)) < (3778 - (525 + 372))) and (v215 == (1 - 0))) then
							ShouldReturn = v97.HandleAfflicted(v98.Rejuvenation, v101.RejuvenationMouseover, 131 - 91);
							if (ShouldReturn or ((1042 - (96 + 46)) == (4154 - (643 + 134)))) then
								return ShouldReturn;
							end
							v215 = 1 + 1;
						end
						if (((10691 - 6232) > (2194 - 1603)) and (v215 == (0 + 0))) then
							ShouldReturn = v97.HandleAfflicted(v98.NaturesCure, v101.NaturesCureMouseover, 78 - 38);
							if (((6945 - 3547) >= (3114 - (316 + 403))) and ShouldReturn) then
								return ShouldReturn;
							end
							v215 = 1 + 0;
						end
						if (((5 - 3) == v215) or ((789 + 1394) >= (7111 - 4287))) then
							ShouldReturn = v97.HandleAfflicted(v98.Regrowth, v101.RegrowthMouseover, 29 + 11, true);
							if (((624 + 1312) == (6708 - 4772)) and ShouldReturn) then
								return ShouldReturn;
							end
							v215 = 14 - 11;
						end
						if ((v215 == (7 - 3)) or ((277 + 4555) < (8490 - 4177))) then
							ShouldReturn = v97.HandleAfflicted(v98.Wildgrowth, v101.WildgrowthMouseover, 2 + 38, true);
							if (((12027 - 7939) > (3891 - (12 + 5))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((16825 - 12493) == (9242 - 4910)) and v46) then
					ShouldReturn = v97.HandleIncorporeal(v98.Hibernate, v101.HibernateMouseover, 63 - 33, true);
					if (((9916 - 5917) >= (589 + 2311)) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				v157 = 1974 - (1656 + 317);
			end
			if ((v157 == (2 + 0)) or ((2024 + 501) > (10805 - 6741))) then
				if (((21512 - 17141) == (4725 - (5 + 349))) and v40 and v98.MarkOfTheWild:IsCastable() and (v13:BuffDown(v98.MarkOfTheWild, true) or v97.GroupBuffMissing(v98.MarkOfTheWild))) then
					if (v23(v101.MarkOfTheWildPlayer) or ((1263 - 997) > (6257 - (266 + 1005)))) then
						return "mark_of_the_wild";
					end
				end
				if (((1313 + 678) >= (3156 - 2231)) and v97.TargetIsValid()) then
					if (((599 - 144) < (3749 - (561 + 1135))) and v98.Rake:IsReady() and (v13:StealthUp(false, true))) then
						if (v23(v98.Rake, not v15:IsInMeleeRange(13 - 3)) or ((2715 - 1889) == (5917 - (507 + 559)))) then
							return "rake";
						end
					end
				end
				v157 = 7 - 4;
			end
			if (((565 - 382) == (571 - (212 + 176))) and (v157 == (908 - (250 + 655)))) then
				if (((3160 - 2001) <= (3124 - 1336)) and v97.TargetIsValid() and v33) then
					ShouldReturn = v132();
					if (ShouldReturn or ((5486 - 1979) > (6274 - (1869 + 87)))) then
						return ShouldReturn;
					end
				end
				break;
			end
		end
	end
	local function v139()
		local v158 = 0 - 0;
		while true do
			if (((1902 - (484 + 1417)) == v158) or ((6590 - 3515) <= (4968 - 2003))) then
				v41 = EpicSettings.Settings['DispelDebuffs'];
				v42 = EpicSettings.Settings['DispelBuffs'];
				v43 = EpicSettings.Settings['UseHealthstone'];
				v44 = EpicSettings.Settings['HealthstoneHP'] or (773 - (48 + 725));
				v45 = EpicSettings.Settings['HandleAfflicted'];
				v158 = 2 - 0;
			end
			if (((3661 - 2296) <= (1169 + 842)) and (v158 == (13 - 8))) then
				v61 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
				v62 = EpicSettings.Settings['UseFlourish'];
				v63 = EpicSettings.Settings['FlourishHP'] or (0 + 0);
				v64 = EpicSettings.Settings['FlourishGroup'] or (853 - (152 + 701));
				v65 = EpicSettings.Settings['IronBarkUsage'] or "";
				v158 = 1317 - (430 + 881);
			end
			if ((v158 == (0 + 0)) or ((3671 - (557 + 338)) > (1057 + 2518))) then
				v36 = EpicSettings.Settings['UseRacials'];
				v37 = EpicSettings.Settings['UseHealingPotion'];
				v38 = EpicSettings.Settings['HealingPotionName'] or "";
				v39 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v40 = EpicSettings.Settings['UseMarkOfTheWild'];
				v158 = 3 - 2;
			end
			if ((v158 == (4 - 2)) or ((5504 - 2950) == (5605 - (499 + 302)))) then
				v46 = EpicSettings.Settings['HandleIncorporeal'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'] or (866 - (39 + 827));
				v50 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v158 = 7 - 4;
			end
			if (((5755 - 3178) == (10235 - 7658)) and ((3 - 0) == v158)) then
				v51 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v52 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v53 = EpicSettings.Settings['EfflorescenceHP'] or (0 + 0);
				v54 = EpicSettings.Settings['UseGroveGuardians'];
				v55 = EpicSettings.Settings['GroveGuardiansHP'] or (0 - 0);
				v158 = 1 + 3;
			end
			if ((v158 == (5 - 1)) or ((110 - (103 + 1)) >= (2443 - (475 + 79)))) then
				v56 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
				v57 = EpicSettings.Settings['UseCenarionWard'];
				v58 = EpicSettings.Settings['CenarionWardHP'] or (0 - 0);
				v59 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v60 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 + 0);
				v158 = 5 + 0;
			end
			if (((2009 - (1395 + 108)) <= (5505 - 3613)) and (v158 == (1210 - (7 + 1197)))) then
				v66 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
				break;
			end
		end
	end
	local function v140()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (326 - (27 + 292))) or ((5883 - 3875) > (2827 - 609))) then
				v88 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
				v89 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
				v90 = EpicSettings.Settings['UseWildgrowth'];
				v159 = 14 - 6;
			end
			if (((518 - (43 + 96)) <= (16916 - 12769)) and (v159 == (11 - 6))) then
				v82 = EpicSettings.Settings['TranquilityHP'] or (0 + 0);
				v83 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
				v84 = EpicSettings.Settings['UseTranquilityTree'];
				v159 = 11 - 5;
			end
			if ((v159 == (2 + 2)) or ((8459 - 3945) <= (318 + 691))) then
				v79 = EpicSettings.Settings['UseSwiftmend'];
				v80 = EpicSettings.Settings['SwiftmendHP'] or (0 + 0);
				v81 = EpicSettings.Settings['UseTranquility'];
				v159 = 1756 - (1414 + 337);
			end
			if ((v159 == (1940 - (1642 + 298))) or ((9113 - 5617) == (3428 - 2236))) then
				v67 = EpicSettings.Settings['UseLifebloomTank'];
				v68 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
				v69 = EpicSettings.Settings['UseLifebloom'];
				v159 = 1 + 0;
			end
			if ((v159 == (2 + 0)) or ((1180 - (357 + 615)) == (2078 + 881))) then
				v73 = EpicSettings.Settings['UseRegrowth'];
				v74 = EpicSettings.Settings['RegrowthHP'] or (0 - 0);
				v75 = EpicSettings.Settings['UseRegrowthRefresh'];
				v159 = 3 + 0;
			end
			if (((9165 - 4888) >= (1051 + 262)) and (v159 == (1 + 5))) then
				v85 = EpicSettings.Settings['TranquilityTreeHP'] or (0 + 0);
				v86 = EpicSettings.Settings['TranquilityTreeGroup'] or (1301 - (384 + 917));
				v87 = EpicSettings.Settings['UseWildgrowthSotF'];
				v159 = 704 - (128 + 569);
			end
			if (((4130 - (1407 + 136)) < (5061 - (687 + 1200))) and (v159 == (1718 - (556 + 1154)))) then
				v91 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
				v92 = EpicSettings.Settings['WildgrowthGroup'] or (95 - (9 + 86));
				v93 = EpicSettings.Settings['BarkskinHP'] or (421 - (275 + 146));
				v159 = 2 + 7;
			end
			if ((v159 == (67 - (29 + 35))) or ((18259 - 14139) <= (6564 - 4366))) then
				v76 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
				v77 = EpicSettings.Settings['UseRejuvenation'];
				v78 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
				v159 = 1016 - (53 + 959);
			end
			if ((v159 == (417 - (312 + 96))) or ((2769 - 1173) == (1143 - (147 + 138)))) then
				v94 = EpicSettings.Settings['UseBarkskin'];
				v95 = EpicSettings.Settings['RenewalHP'] or (899 - (813 + 86));
				v96 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((2910 + 310) == (5965 - 2745)) and (v159 == (493 - (18 + 474)))) then
				v70 = EpicSettings.Settings['LifebloomHP'] or (0 + 0);
				v71 = EpicSettings.Settings['UseNaturesSwiftness'];
				v72 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
				v159 = 1088 - (860 + 226);
			end
		end
	end
	local function v141()
		local v160 = 303 - (121 + 182);
		while true do
			if ((v160 == (1 + 0)) or ((2642 - (988 + 252)) > (409 + 3211))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['ramp'];
				v33 = EpicSettings.Toggles['dps'];
				v160 = 1 + 1;
			end
			if (((4544 - (49 + 1921)) == (3464 - (223 + 667))) and (v160 == (52 - (51 + 1)))) then
				v139();
				v140();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v160 = 1 - 0;
			end
			if (((3850 - 2052) < (3882 - (146 + 979))) and (v160 == (2 + 2))) then
				if (v97.TargetIsValid() or v13:AffectingCombat() or ((982 - (311 + 294)) > (7261 - 4657))) then
					v105 = v9.BossFightRemains(nil, true);
					v106 = v105;
					if (((241 + 327) < (2354 - (496 + 947))) and (v106 == (12469 - (1233 + 125)))) then
						v106 = v9.FightRemains(v103, false);
					end
				end
				if (((1334 + 1951) < (3794 + 434)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v28) then
					local v216 = 0 + 0;
					local v217;
					while true do
						if (((5561 - (963 + 682)) > (2778 + 550)) and (v216 == (1504 - (504 + 1000)))) then
							v217 = v97.DeadFriendlyUnitsCount();
							if (((1684 + 816) < (3497 + 342)) and v13:AffectingCombat()) then
								if (((48 + 459) == (746 - 239)) and v98.Rebirth:IsReady()) then
									if (((206 + 34) <= (1841 + 1324)) and v23(v98.Rebirth, nil, true)) then
										return "rebirth";
									end
								end
							elseif (((1016 - (156 + 26)) >= (464 + 341)) and (v217 > (1 - 0))) then
								if (v23(v98.Revitalize, nil, true) or ((3976 - (149 + 15)) < (3276 - (890 + 70)))) then
									return "revitalize";
								end
							elseif (v23(v98.Revive, not v15:IsInRange(157 - (39 + 78)), true) or ((3134 - (14 + 468)) <= (3370 - 1837))) then
								return "revive";
							end
							break;
						end
					end
				end
				if (v35 or ((10056 - 6458) < (754 + 706))) then
					local v218 = 0 + 0;
					while true do
						if (((0 + 0) == v218) or ((1859 + 2257) < (313 + 879))) then
							DebugMessage = v135();
							if (DebugMessage or ((6463 - 3086) <= (893 + 10))) then
								return DebugMessage;
							end
							v218 = 3 - 2;
						end
						if (((101 + 3875) >= (490 - (12 + 39))) and ((1 + 0) == v218)) then
							DebugMessage = v136();
							if (((11613 - 7861) == (13362 - 9610)) and DebugMessage) then
								return DebugMessage;
							end
							break;
						end
					end
				end
				if (((1200 + 2846) > (1419 + 1276)) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((8989 - 5444) == (2130 + 1067))) then
						local v221 = 0 - 0;
						local v222;
						while true do
							if (((4104 - (1596 + 114)) > (973 - 600)) and (v221 == (713 - (164 + 549)))) then
								v222 = v137();
								if (((5593 - (1059 + 379)) <= (5254 - 1022)) and v222) then
									return v222;
								end
								break;
							end
						end
					elseif (v28 or ((1856 + 1725) == (586 + 2887))) then
						local v224 = 392 - (145 + 247);
						local v225;
						while true do
							if (((4099 + 896) > (1548 + 1800)) and ((0 - 0) == v224)) then
								v225 = v138();
								if (v225 or ((145 + 609) > (3208 + 516))) then
									return v225;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((352 - 135) >= (777 - (254 + 466))) and (v160 == (563 - (544 + 16)))) then
				if (v13:IsMounted() or ((6578 - 4508) >= (4665 - (294 + 334)))) then
					return;
				end
				if (((2958 - (236 + 17)) == (1167 + 1538)) and v13:IsMoving()) then
					v102 = GetTime();
				end
				if (((48 + 13) == (229 - 168)) and (v13:BuffUp(v98.TravelForm) or v13:BuffUp(v98.BearForm) or v13:BuffUp(v98.CatForm))) then
					if (((GetTime() - v102) < (4 - 3)) or ((360 + 339) >= (1068 + 228))) then
						return;
					end
				end
				if (v29 or ((2577 - (413 + 381)) >= (153 + 3463))) then
					v103 = v15:GetEnemiesInSplashRange(16 - 8);
					v104 = #v103;
				else
					local v219 = 0 - 0;
					while true do
						if ((v219 == (1970 - (582 + 1388))) or ((6666 - 2753) > (3241 + 1286))) then
							v103 = {};
							v104 = 365 - (326 + 38);
							break;
						end
					end
				end
				v160 = 11 - 7;
			end
			if (((6246 - 1870) > (1437 - (47 + 573))) and (v160 == (1 + 1))) then
				v34 = EpicSettings.Toggles['dpsform'];
				v35 = EpicSettings.Toggles['healing'];
				if (((20644 - 15783) > (1336 - 512)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v13:AffectingCombat() or v41 or ((3047 - (1269 + 395)) >= (2623 - (76 + 416)))) then
					local v220 = v41 and v98.NaturesCure:IsReady() and v31;
					if ((v97.IsTankBelowHealthPercentage(v66) and v98.IronBark:IsReady() and ((v65 == "Tank Only") or (v65 == "Tank and Self"))) or ((2319 - (319 + 124)) >= (5808 - 3267))) then
						local v223 = 1007 - (564 + 443);
						while true do
							if (((4932 - 3150) <= (4230 - (337 + 121))) and (v223 == (0 - 0))) then
								ShouldReturn = v97.FocusUnit(v220, nil, nil, "TANK", 66 - 46);
								if (ShouldReturn or ((6611 - (1261 + 650)) < (344 + 469))) then
									return ShouldReturn;
								end
								break;
							end
						end
					elseif (((5097 - 1898) < (5867 - (772 + 1045))) and (v13:HealthPercentage() < v66) and v98.IronBark:IsReady() and (v65 == "Tank and Self")) then
						local v226 = 0 + 0;
						while true do
							if ((v226 == (144 - (102 + 42))) or ((6795 - (1524 + 320)) < (5700 - (1049 + 221)))) then
								ShouldReturn = v97.FocusUnit(v220, nil, nil, "HEALER", 176 - (18 + 138));
								if (((234 - 138) == (1198 - (67 + 1035))) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					else
						local v227 = 348 - (136 + 212);
						while true do
							if ((v227 == (0 - 0)) or ((2195 + 544) > (3695 + 313))) then
								ShouldReturn = v97.FocusUnit(v220, nil, nil, nil, 1624 - (240 + 1364));
								if (ShouldReturn or ((1105 - (1050 + 32)) == (4048 - 2914))) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				v160 = 2 + 1;
			end
		end
	end
	local function v142()
		local v161 = 1055 - (331 + 724);
		while true do
			if ((v161 == (0 + 0)) or ((3337 - (269 + 375)) >= (4836 - (267 + 458)))) then
				v21.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.00 By BoomK");
				v161 = 1 + 0;
			end
			if ((v161 == (1 - 0)) or ((5134 - (667 + 151)) <= (3643 - (1410 + 87)))) then
				v117();
				break;
			end
		end
	end
	v21.SetAPL(2002 - (1504 + 393), v141, v142);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

