local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if (((790 + 264) <= (8101 - 4630)) and (v6 == (712 - (530 + 181)))) then
			return v7(v0, ...);
		end
		if ((v6 == (881 - (614 + 267))) or ((1635 - (19 + 13)) <= (1099 - 423))) then
			v7 = v1[v5];
			if (((7999 - 4566) <= (11814 - 7678)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
	end
end
v1["Epix_Druid_RestoDruid.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Utils;
	local v14 = v11.Unit;
	local v15 = v14.Player;
	local v16 = v14.Pet;
	local v17 = v14.Target;
	local v18 = v14.Focus;
	local v19 = v14.MouseOver;
	local v20 = v11.Spell;
	local v21 = v11.MultiSpell;
	local v22 = v11.Item;
	local v23 = v11.Commons;
	local v24 = EpicLib;
	local v25 = v24.Cast;
	local v26 = v24.Press;
	local v27 = v24.Macro;
	local v28 = v24.Commons.Everyone.num;
	local v29 = v24.Commons.Everyone.bool;
	local v30 = string.format;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v100;
	local v101 = v24.Commons.Everyone;
	local v102 = v20.Druid.Restoration;
	local v103 = v22.Druid.Restoration;
	local v104 = {};
	local v105 = v27.Druid.Restoration;
	local v106 = 0 - 0;
	local v107, v108;
	local v109 = 23042 - 11931;
	local v110 = 12923 - (1293 + 519);
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = false;
	local v117 = false;
	local v118 = v15:GetEquipment();
	local v119 = (v118[26 - 13] and v22(v118[33 - 20])) or v22(0 - 0);
	local v120 = (v118[60 - 46] and v22(v118[32 - 18])) or v22(0 + 0);
	v11:RegisterForEvent(function()
		local v148 = 0 + 0;
		while true do
			if (((9862 - 5617) <= (1071 + 3560)) and (v148 == (1 + 0))) then
				v120 = (v118[9 + 5] and v22(v118[1110 - (709 + 387)])) or v22(1858 - (673 + 1185));
				break;
			end
			if (((12400 - 8124) >= (12568 - 8654)) and (v148 == (0 - 0))) then
				v118 = v15:GetEquipment();
				v119 = (v118[10 + 3] and v22(v118[10 + 3])) or v22(0 - 0);
				v148 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		v109 = 22154 - 11043;
		v110 = 21810 - 10699;
	end, "PLAYER_REGEN_ENABLED");
	local function v121()
		if (((2078 - (446 + 1434)) <= (5648 - (1040 + 243))) and v102.ImprovedNaturesCure:IsAvailable()) then
			local v192 = 0 - 0;
			while true do
				if (((6629 - (559 + 1288)) > (6607 - (609 + 1322))) and (v192 == (454 - (13 + 441)))) then
					v101.DispellableDebuffs = v13.MergeTable(v101.DispellableMagicDebuffs, v101.DispellableDiseaseDebuffs);
					v101.DispellableDebuffs = v13.MergeTable(v101.DispellableDebuffs, v101.DispellableCurseDebuffs);
					break;
				end
			end
		else
			v101.DispellableDebuffs = v101.DispellableMagicDebuffs;
		end
	end
	v11:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		return (v15:StealthUp(true, true) and (3.6 - 2)) or (2 - 1);
	end
	v102.Rake:RegisterPMultiplier(v102.RakeDebuff, v122);
	local function v123()
		local v149 = 0 - 0;
		while true do
			if (((182 + 4682) > (7978 - 5781)) and (v149 == (1 + 0))) then
				v113 = v15:BuffUp(v102.EclipseLunar) and v15:BuffDown(v102.EclipseSolar);
				v114 = v15:BuffUp(v102.EclipseSolar) and v15:BuffDown(v102.EclipseLunar);
				v149 = 1 + 1;
			end
			if ((v149 == (5 - 3)) or ((2025 + 1675) == (4610 - 2103))) then
				v115 = (not v111 and (((v102.Starfire:Count() == (0 + 0)) and (v102.Wrath:Count() > (0 + 0))) or v15:IsCasting(v102.Wrath))) or v114;
				v116 = (not v111 and (((v102.Wrath:Count() == (0 + 0)) and (v102.Starfire:Count() > (0 + 0))) or v15:IsCasting(v102.Starfire))) or v113;
				v149 = 3 + 0;
			end
			if (((4907 - (153 + 280)) >= (790 - 516)) and (v149 == (0 + 0))) then
				v111 = v15:BuffUp(v102.EclipseSolar) or v15:BuffUp(v102.EclipseLunar);
				v112 = v15:BuffUp(v102.EclipseSolar) and v15:BuffUp(v102.EclipseLunar);
				v149 = 1 + 0;
			end
			if ((v149 == (2 + 1)) or ((1719 + 175) <= (1019 + 387))) then
				v117 = not v111 and (v102.Wrath:Count() > (0 - 0)) and (v102.Starfire:Count() > (0 + 0));
				break;
			end
		end
	end
	local function v124(v150)
		return v150:DebuffRefreshable(v102.SunfireDebuff) and (v110 > (672 - (89 + 578)));
	end
	local function v125(v151)
		return (v151:DebuffRefreshable(v102.MoonfireDebuff) and (v110 > (9 + 3)) and ((((v108 <= (8 - 4)) or (v15:Energy() < (1099 - (572 + 477)))) and v15:BuffDown(v102.HeartOfTheWild)) or (((v108 <= (1 + 3)) or (v15:Energy() < (31 + 19))) and v15:BuffUp(v102.HeartOfTheWild))) and v151:DebuffDown(v102.MoonfireDebuff)) or (v15:PrevGCD(1 + 0, v102.Sunfire) and ((v151:DebuffUp(v102.MoonfireDebuff) and (v151:DebuffRemains(v102.MoonfireDebuff) < (v151:DebuffDuration(v102.MoonfireDebuff) * (86.8 - (84 + 2))))) or v151:DebuffDown(v102.MoonfireDebuff)) and (v108 == (1 - 0)));
	end
	local function v126(v152)
		return v152:DebuffRefreshable(v102.MoonfireDebuff) and (v152:TimeToDie() > (4 + 1));
	end
	local function v127(v153)
		return ((v153:DebuffRefreshable(v102.Rip) or ((v15:Energy() > (932 - (497 + 345))) and (v153:DebuffRemains(v102.Rip) <= (1 + 9)))) and (((v15:ComboPoints() == (1 + 4)) and (v153:TimeToDie() > (v153:DebuffRemains(v102.Rip) + (1357 - (605 + 728))))) or (((v153:DebuffRemains(v102.Rip) + (v15:ComboPoints() * (3 + 1))) < v153:TimeToDie()) and ((v153:DebuffRemains(v102.Rip) + (8 - 4) + (v15:ComboPoints() * (1 + 3))) > v153:TimeToDie())))) or (v153:DebuffDown(v102.Rip) and (v15:ComboPoints() > ((7 - 5) + (v108 * (2 + 0)))));
	end
	local function v128(v154)
		return (v154:DebuffDown(v102.RakeDebuff) or v154:DebuffRefreshable(v102.RakeDebuff)) and (v154:TimeToDie() > (27 - 17)) and (v15:ComboPoints() < (4 + 1));
	end
	local function v129(v155)
		return (v155:DebuffUp(v102.AdaptiveSwarmDebuff));
	end
	local function v130()
		return v101.FriendlyUnitsWithBuffCount(v102.Rejuvenation) + v101.FriendlyUnitsWithBuffCount(v102.Regrowth) + v101.FriendlyUnitsWithBuffCount(v102.Wildgrowth);
	end
	local function v131()
		return v101.FriendlyUnitsWithoutBuffCount(v102.Rejuvenation);
	end
	local function v132(v156)
		return v156:BuffUp(v102.Rejuvenation) or v156:BuffUp(v102.Regrowth) or v156:BuffUp(v102.Wildgrowth);
	end
	local function v133()
		local v157 = 489 - (457 + 32);
		local v158;
		while true do
			if (((667 + 905) >= (2933 - (832 + 570))) and (v157 == (0 + 0))) then
				v158 = v101.HandleTopTrinket(v104, v33 and (v15:BuffUp(v102.HeartOfTheWild) or v15:BuffUp(v102.IncarnationBuff)), 11 + 29, nil);
				if (v158 or ((16586 - 11899) < (2188 + 2354))) then
					return v158;
				end
				v157 = 797 - (588 + 208);
			end
			if (((8869 - 5578) > (3467 - (884 + 916))) and (v157 == (1 - 0))) then
				v158 = v101.HandleBottomTrinket(v104, v33 and (v15:BuffUp(v102.HeartOfTheWild) or v15:BuffUp(v102.IncarnationBuff)), 24 + 16, nil);
				if (v158 or ((1526 - (232 + 421)) == (3923 - (1569 + 320)))) then
					return v158;
				end
				break;
			end
		end
	end
	local function v134()
		if ((v102.Rake:IsReady() and (v15:StealthUp(false, true))) or ((691 + 2125) < (3 + 8))) then
			if (((12464 - 8765) < (5311 - (316 + 289))) and v26(v102.Rake, not v17:IsInMeleeRange(26 - 16))) then
				return "rake cat 2";
			end
		end
		if (((123 + 2523) >= (2329 - (666 + 787))) and v40 and not v15:StealthUp(false, true)) then
			local v195 = v133();
			if (((1039 - (360 + 65)) <= (2976 + 208)) and v195) then
				return v195;
			end
		end
		if (((3380 - (79 + 175)) == (4929 - 1803)) and v102.AdaptiveSwarm:IsCastable()) then
			if (v26(v102.AdaptiveSwarm, not v17:IsSpellInRange(v102.AdaptiveSwarm)) or ((1707 + 480) >= (15185 - 10231))) then
				return "adaptive_swarm cat";
			end
		end
		if ((v54 and v33 and v102.ConvokeTheSpirits:IsCastable()) or ((7466 - 3589) == (4474 - (503 + 396)))) then
			if (((888 - (92 + 89)) > (1225 - 593)) and v15:BuffUp(v102.CatForm)) then
				if (((v15:BuffUp(v102.HeartOfTheWild) or (v102.HeartOfTheWild:CooldownRemains() > (31 + 29)) or not v102.HeartOfTheWild:IsAvailable()) and (v15:Energy() < (30 + 20)) and (((v15:ComboPoints() < (19 - 14)) and (v17:DebuffRemains(v102.Rip) > (1 + 4))) or (v108 > (2 - 1)))) or ((477 + 69) >= (1282 + 1402))) then
					if (((4461 - 2996) <= (537 + 3764)) and v26(v102.ConvokeTheSpirits, not v17:IsInRange(45 - 15))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((2948 - (485 + 759)) > (3297 - 1872)) and v102.Sunfire:IsReady() and v15:BuffDown(v102.CatForm) and (v17:TimeToDie() > (1194 - (442 + 747))) and (not v102.Rip:IsAvailable() or v17:DebuffUp(v102.Rip) or (v15:Energy() < (1165 - (832 + 303))))) then
			if (v101.CastCycle(v102.Sunfire, v107, v124, not v17:IsSpellInRange(v102.Sunfire), nil, nil, v105.SunfireMouseover) or ((1633 - (88 + 858)) == (1291 + 2943))) then
				return "sunfire cat 20";
			end
		end
		if ((v102.Moonfire:IsReady() and v15:BuffDown(v102.CatForm) and (v17:TimeToDie() > (5 + 0)) and (not v102.Rip:IsAvailable() or v17:DebuffUp(v102.Rip) or (v15:Energy() < (2 + 28)))) or ((4119 - (766 + 23)) < (7054 - 5625))) then
			if (((1568 - 421) >= (882 - 547)) and v101.CastCycle(v102.Moonfire, v107, v125, not v17:IsSpellInRange(v102.Moonfire), nil, nil, v105.MoonfireMouseover)) then
				return "moonfire cat 22";
			end
		end
		if (((11658 - 8223) > (3170 - (1036 + 37))) and v102.Sunfire:IsReady() and v17:DebuffDown(v102.SunfireDebuff) and (v17:TimeToDie() > (4 + 1))) then
			if (v26(v102.Sunfire, not v17:IsSpellInRange(v102.Sunfire)) or ((7341 - 3571) >= (3179 + 862))) then
				return "sunfire cat 24";
			end
		end
		if ((v102.Moonfire:IsReady() and v15:BuffDown(v102.CatForm) and v17:DebuffDown(v102.MoonfireDebuff) and (v17:TimeToDie() > (1485 - (641 + 839)))) or ((4704 - (910 + 3)) <= (4106 - 2495))) then
			if (v26(v102.Moonfire, not v17:IsSpellInRange(v102.Moonfire)) or ((6262 - (1466 + 218)) <= (923 + 1085))) then
				return "moonfire cat 24";
			end
		end
		if (((2273 - (556 + 592)) <= (739 + 1337)) and v102.Starsurge:IsReady() and (v15:BuffDown(v102.CatForm))) then
			if (v26(v102.Starsurge, not v17:IsSpellInRange(v102.Starsurge)) or ((1551 - (329 + 479)) >= (5253 - (174 + 680)))) then
				return "starsurge cat 26";
			end
		end
		if (((3968 - 2813) < (3467 - 1794)) and v102.HeartOfTheWild:IsCastable() and v33 and ((v102.ConvokeTheSpirits:CooldownRemains() < (22 + 8)) or not v102.ConvokeTheSpirits:IsAvailable()) and v15:BuffDown(v102.HeartOfTheWild) and v17:DebuffUp(v102.SunfireDebuff) and (v17:DebuffUp(v102.MoonfireDebuff) or (v108 > (743 - (396 + 343))))) then
			if (v26(v102.HeartOfTheWild) or ((206 + 2118) <= (2055 - (29 + 1448)))) then
				return "heart_of_the_wild cat 26";
			end
		end
		if (((5156 - (135 + 1254)) == (14190 - 10423)) and v102.CatForm:IsReady() and v15:BuffDown(v102.CatForm) and (v15:Energy() >= (140 - 110)) and v37) then
			if (((2726 + 1363) == (5616 - (389 + 1138))) and v26(v102.CatForm)) then
				return "cat_form cat 28";
			end
		end
		if (((5032 - (102 + 472)) >= (1580 + 94)) and v102.FerociousBite:IsReady() and (((v15:ComboPoints() > (2 + 1)) and (v17:TimeToDie() < (10 + 0))) or ((v15:ComboPoints() == (1550 - (320 + 1225))) and (v15:Energy() >= (44 - 19)) and (not v102.Rip:IsAvailable() or (v17:DebuffRemains(v102.Rip) > (4 + 1)))))) then
			if (((2436 - (157 + 1307)) <= (3277 - (821 + 1038))) and v26(v102.FerociousBite, not v17:IsInMeleeRange(12 - 7))) then
				return "ferocious_bite cat 32";
			end
		end
		if ((v102.Rip:IsAvailable() and v102.Rip:IsReady() and (v108 < (2 + 9)) and v127(v17)) or ((8770 - 3832) < (1772 + 2990))) then
			if (v26(v102.Rip, not v17:IsInMeleeRange(12 - 7)) or ((3530 - (834 + 192)) > (272 + 3992))) then
				return "rip cat 34";
			end
		end
		if (((553 + 1600) == (47 + 2106)) and v102.Thrash:IsReady() and (v108 >= (2 - 0)) and v17:DebuffRefreshable(v102.ThrashDebuff)) then
			if (v26(v102.Thrash, not v17:IsInMeleeRange(312 - (300 + 4))) or ((136 + 371) >= (6782 - 4191))) then
				return "thrash cat";
			end
		end
		if (((4843 - (112 + 250)) == (1787 + 2694)) and v102.Rake:IsReady() and v128(v17)) then
			if (v26(v102.Rake, not v17:IsInMeleeRange(12 - 7)) or ((1334 + 994) < (359 + 334))) then
				return "rake cat 36";
			end
		end
		if (((3237 + 1091) == (2146 + 2182)) and v102.Rake:IsReady() and ((v15:ComboPoints() < (4 + 1)) or (v15:Energy() > (1504 - (1001 + 413)))) and (v17:PMultiplier(v102.Rake) <= v15:PMultiplier(v102.Rake)) and v129(v17)) then
			if (((3540 - 1952) >= (2214 - (244 + 638))) and v26(v102.Rake, not v17:IsInMeleeRange(698 - (627 + 66)))) then
				return "rake cat 40";
			end
		end
		if ((v102.Swipe:IsReady() and (v108 >= (5 - 3))) or ((4776 - (512 + 90)) > (6154 - (1665 + 241)))) then
			if (v26(v102.Swipe, not v17:IsInMeleeRange(725 - (373 + 344))) or ((2069 + 2517) <= (22 + 60))) then
				return "swipe cat 38";
			end
		end
		if (((10189 - 6326) == (6536 - 2673)) and v102.Shred:IsReady() and ((v15:ComboPoints() < (1104 - (35 + 1064))) or (v15:Energy() > (66 + 24)))) then
			if (v26(v102.Shred, not v17:IsInMeleeRange(10 - 5)) or ((2 + 280) <= (1278 - (298 + 938)))) then
				return "shred cat 42";
			end
		end
	end
	local function v135()
		if (((5868 - (233 + 1026)) >= (2432 - (636 + 1030))) and v102.HeartOfTheWild:IsCastable() and v33 and ((v102.ConvokeTheSpirits:CooldownRemains() < (16 + 14)) or (v102.ConvokeTheSpirits:CooldownRemains() > (88 + 2)) or not v102.ConvokeTheSpirits:IsAvailable()) and v15:BuffDown(v102.HeartOfTheWild)) then
			if (v26(v102.HeartOfTheWild) or ((343 + 809) == (169 + 2319))) then
				return "heart_of_the_wild owl 2";
			end
		end
		if (((3643 - (55 + 166)) > (650 + 2700)) and v102.MoonkinForm:IsReady() and (v15:BuffDown(v102.MoonkinForm)) and v37) then
			if (((89 + 788) > (1435 - 1059)) and v26(v102.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if ((v102.Starsurge:IsReady() and ((v108 < (303 - (36 + 261))) or (not v113 and (v108 < (13 - 5)))) and v37) or ((4486 - (34 + 1334)) <= (712 + 1139))) then
			if (v26(v102.Starsurge, not v17:IsSpellInRange(v102.Starsurge)) or ((129 + 36) >= (4775 - (1035 + 248)))) then
				return "starsurge owl 8";
			end
		end
		if (((3970 - (20 + 1)) < (2530 + 2326)) and v102.Moonfire:IsReady() and ((v108 < (324 - (134 + 185))) or (not v113 and (v108 < (1140 - (549 + 584)))))) then
			if (v101.CastCycle(v102.Moonfire, v107, v126, not v17:IsSpellInRange(v102.Moonfire), nil, nil, v105.MoonfireMouseover) or ((4961 - (314 + 371)) < (10353 - 7337))) then
				return "moonfire owl 10";
			end
		end
		if (((5658 - (478 + 490)) > (2186 + 1939)) and v102.Sunfire:IsReady()) then
			if (v101.CastCycle(v102.Sunfire, v107, v124, not v17:IsSpellInRange(v102.Sunfire), nil, nil, v105.SunfireMouseover) or ((1222 - (786 + 386)) >= (2901 - 2005))) then
				return "sunfire owl 12";
			end
		end
		if ((v54 and v33 and v102.ConvokeTheSpirits:IsCastable()) or ((3093 - (1055 + 324)) >= (4298 - (1093 + 247)))) then
			if (v15:BuffUp(v102.MoonkinForm) or ((1325 + 166) < (68 + 576))) then
				if (((2794 - 2090) < (3349 - 2362)) and v26(v102.ConvokeTheSpirits, not v17:IsInRange(85 - 55))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((9342 - 5624) > (679 + 1227)) and v102.Wrath:IsReady() and (v15:BuffDown(v102.CatForm) or not v17:IsInMeleeRange(30 - 22)) and ((v114 and (v108 == (3 - 2))) or v115 or (v117 and (v108 > (1 + 0))))) then
			if (v26(v102.Wrath, not v17:IsSpellInRange(v102.Wrath), true) or ((2449 - 1491) > (4323 - (364 + 324)))) then
				return "wrath owl 14";
			end
		end
		if (((9597 - 6096) <= (10778 - 6286)) and v102.Starfire:IsReady()) then
			if (v26(v102.Starfire, not v17:IsSpellInRange(v102.Starfire), true) or ((1141 + 2301) < (10661 - 8113))) then
				return "starfire owl 16";
			end
		end
	end
	local function v136()
		local v159 = 0 - 0;
		local v160;
		local v161;
		while true do
			if (((8731 - 5856) >= (2732 - (1249 + 19))) and (v159 == (6 + 0))) then
				if ((v102.Wrath:IsReady() and (v15:BuffDown(v102.CatForm) or not v17:IsInMeleeRange(31 - 23))) or ((5883 - (686 + 400)) >= (3840 + 1053))) then
					if (v26(v102.Wrath, not v17:IsSpellInRange(v102.Wrath), true) or ((780 - (73 + 156)) > (10 + 2058))) then
						return "wrath main 30";
					end
				end
				if (((2925 - (721 + 90)) > (11 + 933)) and v102.Moonfire:IsReady() and (v15:BuffDown(v102.CatForm) or not v17:IsInMeleeRange(25 - 17))) then
					if (v26(v102.Moonfire, not v17:IsSpellInRange(v102.Moonfire)) or ((2732 - (224 + 246)) >= (5015 - 1919))) then
						return "moonfire main 32";
					end
				end
				if (true or ((4151 - 1896) >= (642 + 2895))) then
					if (v26(v102.Pool) or ((92 + 3745) < (960 + 346))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((5865 - 2915) == (9817 - 6867)) and (v159 == (515 - (203 + 310)))) then
				v123();
				v161 = 1993 - (1238 + 755);
				if (v102.Rip:IsAvailable() or ((330 + 4393) < (4832 - (709 + 825)))) then
					v161 = v161 + (1 - 0);
				end
				v159 = 3 - 0;
			end
			if (((2000 - (196 + 668)) >= (607 - 453)) and (v159 == (7 - 3))) then
				if (v102.AdaptiveSwarm:IsCastable() or ((1104 - (171 + 662)) > (4841 - (4 + 89)))) then
					if (((16613 - 11873) >= (1148 + 2004)) and v26(v102.AdaptiveSwarm, not v17:IsSpellInRange(v102.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				if (v102.MoonkinForm:IsAvailable() or ((11323 - 8745) >= (1330 + 2060))) then
					local v226 = 1486 - (35 + 1451);
					local v227;
					while true do
						if (((1494 - (28 + 1425)) <= (3654 - (941 + 1052))) and (v226 == (0 + 0))) then
							v227 = v135();
							if (((2115 - (822 + 692)) < (5082 - 1522)) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				if (((111 + 124) < (984 - (45 + 252))) and v102.Sunfire:IsReady() and (v17:DebuffRefreshable(v102.SunfireDebuff))) then
					if (((4501 + 48) > (397 + 756)) and v26(v102.Sunfire, not v17:IsSpellInRange(v102.Sunfire))) then
						return "sunfire main 24";
					end
				end
				v159 = 12 - 7;
			end
			if ((v159 == (434 - (114 + 319))) or ((6710 - 2036) < (5986 - 1314))) then
				if (((2339 + 1329) < (6794 - 2233)) and (v15:BuffUp(v102.CatForm) or v15:BuffUp(v102.BearForm))) then
					local v228 = 0 - 0;
					while true do
						if ((v228 == (1963 - (556 + 1407))) or ((1661 - (741 + 465)) == (4070 - (170 + 295)))) then
							v160 = v101.InterruptWithStun(v102.SkullBash, 6 + 4);
							if (v160 or ((2447 + 216) == (8154 - 4842))) then
								return v160;
							end
							break;
						end
					end
				end
				v160 = v101.InterruptWithStun(v102.MightyBash, 7 + 1);
				if (((2743 + 1534) <= (2535 + 1940)) and v160) then
					return v160;
				end
				v159 = 1232 - (957 + 273);
			end
			if (((2 + 3) == v159) or ((349 + 521) == (4530 - 3341))) then
				if (((4092 - 2539) <= (9569 - 6436)) and v102.Moonfire:IsReady() and (v17:DebuffRefreshable(v102.MoonfireDebuff))) then
					if (v26(v102.Moonfire, not v17:IsSpellInRange(v102.Moonfire)) or ((11076 - 8839) >= (5291 - (389 + 1391)))) then
						return "moonfire main 26";
					end
				end
				if ((v102.Starsurge:IsReady() and (v15:BuffDown(v102.CatForm))) or ((831 + 493) > (315 + 2705))) then
					if (v26(v102.Starsurge, not v17:IsSpellInRange(v102.Starsurge)) or ((6811 - 3819) == (2832 - (783 + 168)))) then
						return "starsurge main 28";
					end
				end
				if (((10424 - 7318) > (1502 + 24)) and v102.Starfire:IsReady() and (v108 > (313 - (309 + 2)))) then
					if (((9283 - 6260) < (5082 - (1090 + 122))) and v26(v102.Starfire, not v17:IsSpellInRange(v102.Starfire), true)) then
						return "starfire owl 16";
					end
				end
				v159 = 2 + 4;
			end
			if (((480 - 337) > (51 + 23)) and (v159 == (1121 - (628 + 490)))) then
				if (((4 + 14) < (5228 - 3116)) and v102.Rake:IsAvailable()) then
					v161 = v161 + (4 - 3);
				end
				if (((1871 - (431 + 343)) <= (3287 - 1659)) and v102.Thrash:IsAvailable()) then
					v161 = v161 + (2 - 1);
				end
				if (((3658 + 972) == (593 + 4037)) and (v161 >= (1697 - (556 + 1139))) and v17:IsInMeleeRange(23 - (6 + 9))) then
					local v229 = 0 + 0;
					local v230;
					while true do
						if (((1814 + 1726) > (2852 - (28 + 141))) and (v229 == (0 + 0))) then
							v230 = v134();
							if (((5916 - 1122) >= (2320 + 955)) and v230) then
								return v230;
							end
							break;
						end
					end
				end
				v159 = 1321 - (486 + 831);
			end
			if (((3861 - 2377) == (5224 - 3740)) and (v159 == (0 + 0))) then
				v160 = v101.InterruptWithStun(v102.IncapacitatingRoar, 25 - 17);
				if (((2695 - (668 + 595)) < (3199 + 356)) and v160) then
					return v160;
				end
				if ((v15:BuffUp(v102.CatForm) and (v15:ComboPoints() > (0 + 0))) or ((2904 - 1839) > (3868 - (23 + 267)))) then
					v160 = v101.InterruptWithStun(v102.Maim, 1952 - (1129 + 815));
					if (v160 or ((5182 - (371 + 16)) < (3157 - (1326 + 424)))) then
						return v160;
					end
				end
				v159 = 1 - 0;
			end
		end
	end
	local v137 = 0 - 0;
	local function v138()
		if (((1971 - (88 + 30)) < (5584 - (720 + 51))) and v102.NaturesCure:IsReady() and (v101.UnitHasDispellableDebuffByPlayer(v18) or v101.DispellableFriendlyUnit(44 - 24) or v101.UnitHasCurseDebuff(v18) or v101.UnitHasPoisonDebuff(v18))) then
			local v196 = 1776 - (421 + 1355);
			while true do
				if ((v196 == (0 - 0)) or ((1386 + 1435) < (3514 - (286 + 797)))) then
					if ((v137 == (0 - 0)) or ((4760 - 1886) < (2620 - (397 + 42)))) then
						v137 = GetTime();
					end
					if (v101.Wait(157 + 343, v137) or ((3489 - (24 + 776)) <= (528 - 185))) then
						if (v26(v105.NaturesCureFocus) or ((2654 - (222 + 563)) == (4426 - 2417))) then
							return "natures_cure dispel 2";
						end
						v137 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v139()
		local v162 = 190 - (23 + 167);
		while true do
			if ((v162 == (1798 - (690 + 1108))) or ((1280 + 2266) < (1916 + 406))) then
				if (((v15:HealthPercentage() <= v97) and v98 and v102.Barkskin:IsReady()) or ((2930 - (40 + 808)) == (786 + 3987))) then
					if (((12404 - 9160) > (1009 + 46)) and v26(v102.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((v15:HealthPercentage() <= v99) and v100 and v102.Renewal:IsReady()) or ((1753 + 1560) <= (976 + 802))) then
					if (v26(v102.Renewal, nil, nil, true) or ((1992 - (47 + 524)) >= (1366 + 738))) then
						return "renewal defensive 2";
					end
				end
				v162 = 2 - 1;
			end
			if (((2708 - 896) <= (7409 - 4160)) and (v162 == (1727 - (1165 + 561)))) then
				if (((49 + 1574) <= (6061 - 4104)) and v103.Healthstone:IsReady() and v47 and (v15:HealthPercentage() <= v48)) then
					if (((1684 + 2728) == (4891 - (341 + 138))) and v26(v105.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (((473 + 1277) >= (1737 - 895)) and v41 and (v15:HealthPercentage() <= v43)) then
					if (((4698 - (89 + 237)) > (5951 - 4101)) and (v42 == "Refreshing Healing Potion")) then
						if (((487 - 255) < (1702 - (581 + 300))) and v103.RefreshingHealingPotion:IsReady()) then
							if (((1738 - (855 + 365)) < (2142 - 1240)) and v26(v105.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v140()
		if (((978 + 2016) > (2093 - (1030 + 205))) and v102.Swiftmend:IsReady() and not v132(v18) and v15:BuffDown(v102.SoulOfTheForestBuff)) then
			if (v26(v105.RejuvenationFocus) or ((3526 + 229) <= (852 + 63))) then
				return "rejuvenation ramp";
			end
		end
		if (((4232 - (156 + 130)) > (8504 - 4761)) and v102.Swiftmend:IsReady() and v132(v18)) then
			if (v26(v105.SwiftmendFocus) or ((2250 - 915) >= (6770 - 3464))) then
				return "swiftmend ramp";
			end
		end
		if (((1277 + 3567) > (1314 + 939)) and v15:BuffUp(v102.SoulOfTheForestBuff) and v102.Wildgrowth:IsReady()) then
			if (((521 - (10 + 59)) == (128 + 324)) and v26(v105.WildgrowthFocus, nil, true)) then
				return "wildgrowth ramp";
			end
		end
		if ((v102.Innervate:IsReady() and v15:BuffDown(v102.Innervate)) or ((22442 - 17885) < (3250 - (671 + 492)))) then
			if (((3084 + 790) == (5089 - (369 + 846))) and v26(v105.InnervatePlayer, nil, nil, true)) then
				return "innervate ramp";
			end
		end
		if ((v15:BuffUp(v102.Innervate) and (v131() > (0 + 0)) and v19 and v19:Exists() and v19:BuffRefreshable(v102.Rejuvenation)) or ((1654 + 284) > (6880 - (1036 + 909)))) then
			if (v26(v105.RejuvenationMouseover) or ((3384 + 871) < (5746 - 2323))) then
				return "rejuvenation_cycle ramp";
			end
		end
	end
	local function v141()
		if (((1657 - (11 + 192)) <= (1259 + 1232)) and v38) then
			local v197 = 175 - (135 + 40);
			while true do
				if ((v197 == (2 - 1)) or ((2506 + 1651) <= (6174 - 3371))) then
					if (((7274 - 2421) >= (3158 - (50 + 126))) and v15:BuffUp(v102.SoulOfTheForestBuff) and v102.Wildgrowth:IsReady() and v101.AreUnitsBelowHealthPercentage(v92, v93, v102.Regrowth)) then
						if (((11511 - 7377) > (744 + 2613)) and v26(v105.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					if ((v58 and v102.GroveGuardians:IsReady() and (v102.GroveGuardians:TimeSinceLastCast() > (1418 - (1233 + 180))) and v101.AreUnitsBelowHealthPercentage(v59, v60, v102.Regrowth)) or ((4386 - (522 + 447)) < (3955 - (107 + 1314)))) then
						if (v26(v105.GroveGuardiansFocus, nil, nil) or ((1264 + 1458) <= (499 - 335))) then
							return "grove_guardians healing";
						end
					end
					if ((v15:AffectingCombat() and v33 and v102.Flourish:IsReady() and v15:BuffDown(v102.Flourish) and (v130() > (2 + 2)) and v101.AreUnitsBelowHealthPercentage(v67, v68, v102.Regrowth)) or ((4781 - 2373) < (8344 - 6235))) then
						if (v26(v102.Flourish, nil, nil, true) or ((1943 - (716 + 1194)) == (25 + 1430))) then
							return "flourish healing";
						end
					end
					v197 = 1 + 1;
				end
				if ((v197 == (508 - (74 + 429))) or ((854 - 411) >= (1990 + 2025))) then
					if (((7741 - 4359) > (118 + 48)) and v15:AffectingCombat() and v73 and (v101.UnitGroupRole(v18) ~= "TANK") and (v101.FriendlyUnitsWithBuffCount(v102.Lifebloom, false, true) < (2 - 1)) and (v102.Undergrowth:IsAvailable() or v101.IsSoloMode()) and (v18:HealthPercentage() <= (v74 - (v28(v15:BuffUp(v102.CatForm)) * (37 - 22)))) and v102.Lifebloom:IsCastable() and v18:BuffRefreshable(v102.Lifebloom)) then
						if (v26(v105.LifebloomFocus) or ((713 - (279 + 154)) == (3837 - (454 + 324)))) then
							return "lifebloom healing";
						end
					end
					if (((1480 + 401) > (1310 - (12 + 5))) and (v56 == "Player")) then
						if (((1271 + 1086) == (6005 - 3648)) and v15:AffectingCombat() and (v102.Efflorescence:TimeSinceLastCast() > (6 + 9))) then
							if (((1216 - (277 + 816)) == (525 - 402)) and v26(v105.EfflorescencePlayer)) then
								return "efflorescence healing player";
							end
						end
					elseif ((v56 == "Cursor") or ((2239 - (1058 + 125)) >= (636 + 2756))) then
						if ((v15:AffectingCombat() and (v102.Efflorescence:TimeSinceLastCast() > (990 - (815 + 160)))) or ((4638 - 3557) < (2551 - 1476))) then
							if (v26(v105.EfflorescenceCursor) or ((251 + 798) >= (12955 - 8523))) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v56 == "Confirmation") or ((6666 - (41 + 1857)) <= (2739 - (1222 + 671)))) then
						if ((v15:AffectingCombat() and (v102.Efflorescence:TimeSinceLastCast() > (38 - 23))) or ((4826 - 1468) <= (2602 - (229 + 953)))) then
							if (v26(v102.Efflorescence) or ((5513 - (1111 + 663)) <= (4584 - (874 + 705)))) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v102.Wildgrowth:IsReady() and v94 and v101.AreUnitsBelowHealthPercentage(v95, v96, v102.Regrowth) and (not v102.Swiftmend:IsAvailable() or not v102.Swiftmend:IsReady())) or ((233 + 1426) >= (1456 + 678))) then
						if (v26(v105.WildgrowthFocus, nil, true) or ((6776 - 3516) < (67 + 2288))) then
							return "wildgrowth healing";
						end
					end
					v197 = 685 - (642 + 37);
				end
				if ((v197 == (0 + 0)) or ((108 + 561) == (10602 - 6379))) then
					if (v40 or ((2146 - (233 + 221)) < (1359 - 771))) then
						local v238 = v133();
						if (v238 or ((4223 + 574) < (5192 - (718 + 823)))) then
							return v238;
						end
					end
					if ((v55 and v33 and v15:AffectingCombat() and (v130() > (2 + 1)) and v102.NaturesVigil:IsReady()) or ((4982 - (266 + 539)) > (13731 - 8881))) then
						if (v26(v102.NaturesVigil, nil, nil, true) or ((1625 - (636 + 589)) > (2637 - 1526))) then
							return "natures_vigil healing";
						end
					end
					if (((6292 - 3241) > (797 + 208)) and v102.Swiftmend:IsReady() and v83 and v15:BuffDown(v102.SoulOfTheForestBuff) and v132(v18) and (v18:HealthPercentage() <= v84)) then
						if (((1342 + 2351) <= (5397 - (657 + 358))) and v26(v105.SwiftmendFocus)) then
							return "swiftmend healing";
						end
					end
					v197 = 2 - 1;
				end
				if ((v197 == (6 - 3)) or ((4469 - (1151 + 36)) > (3960 + 140))) then
					if ((v102.CenarionWard:IsReady() and v61 and (v18:HealthPercentage() <= v62)) or ((942 + 2638) < (8493 - 5649))) then
						if (((1921 - (1552 + 280)) < (5324 - (64 + 770))) and v26(v105.CenarionWardFocus)) then
							return "cenarion_ward healing";
						end
					end
					if ((v15:BuffUp(v102.NaturesSwiftness) and v102.Regrowth:IsCastable()) or ((3384 + 1599) < (4104 - 2296))) then
						if (((680 + 3149) > (5012 - (157 + 1086))) and v26(v105.RegrowthFocus)) then
							return "regrowth_swiftness healing";
						end
					end
					if (((2972 - 1487) <= (12718 - 9814)) and v102.NaturesSwiftness:IsReady() and v75 and (v18:HealthPercentage() <= v76)) then
						if (((6547 - 2278) == (5825 - 1556)) and v26(v102.NaturesSwiftness)) then
							return "natures_swiftness healing";
						end
					end
					v197 = 823 - (599 + 220);
				end
				if (((770 - 383) <= (4713 - (1813 + 118))) and (v197 == (3 + 1))) then
					if ((v69 == "Anyone") or ((3116 - (841 + 376)) <= (1284 - 367))) then
						if ((v102.IronBark:IsReady() and (v18:HealthPercentage() <= v70)) or ((1002 + 3310) <= (2391 - 1515))) then
							if (((3091 - (464 + 395)) <= (6662 - 4066)) and v26(v105.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					elseif (((1007 + 1088) < (4523 - (467 + 370))) and (v69 == "Tank Only")) then
						if ((v102.IronBark:IsReady() and (v18:HealthPercentage() <= v70) and (v101.UnitGroupRole(v18) == "TANK")) or ((3295 - 1700) >= (3285 + 1189))) then
							if (v26(v105.IronBarkFocus) or ((15833 - 11214) < (450 + 2432))) then
								return "iron_bark healing";
							end
						end
					elseif ((v69 == "Tank and Self") or ((683 - 389) >= (5351 - (150 + 370)))) then
						if (((3311 - (74 + 1208)) <= (7585 - 4501)) and v102.IronBark:IsReady() and (v18:HealthPercentage() <= v70) and ((v101.UnitGroupRole(v18) == "TANK") or (v101.UnitGroupRole(v18) == "HEALER"))) then
							if (v26(v105.IronBarkFocus) or ((9660 - 7623) == (1722 + 698))) then
								return "iron_bark healing";
							end
						end
					end
					if (((4848 - (14 + 376)) > (6770 - 2866)) and v102.AdaptiveSwarm:IsCastable() and v15:AffectingCombat()) then
						if (((283 + 153) >= (109 + 14)) and v26(v105.AdaptiveSwarmFocus)) then
							return "adaptive_swarm healing";
						end
					end
					if (((477 + 23) < (5321 - 3505)) and v15:AffectingCombat() and v71 and (v101.UnitGroupRole(v18) == "TANK") and (v101.FriendlyUnitsWithBuffCount(v102.Lifebloom, true, false) < (1 + 0)) and (v18:HealthPercentage() <= (v72 - (v28(v15:BuffUp(v102.CatForm)) * (93 - (23 + 55))))) and v102.Lifebloom:IsCastable() and v18:BuffRefreshable(v102.Lifebloom)) then
						if (((8469 - 4895) == (2385 + 1189)) and v26(v105.LifebloomFocus)) then
							return "lifebloom healing";
						end
					end
					v197 = 5 + 0;
				end
				if (((342 - 121) < (123 + 267)) and (v197 == (907 - (652 + 249)))) then
					if ((v102.Regrowth:IsCastable() and v77 and (v18:HealthPercentage() <= v78)) or ((5922 - 3709) <= (3289 - (708 + 1160)))) then
						if (((8300 - 5242) < (8860 - 4000)) and v26(v105.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					if ((v15:BuffUp(v102.Innervate) and (v131() > (27 - (10 + 17))) and v19 and v19:Exists() and v19:BuffRefreshable(v102.Rejuvenation)) or ((292 + 1004) >= (6178 - (1400 + 332)))) then
						if (v26(v105.RejuvenationMouseover) or ((2671 - 1278) > (6397 - (242 + 1666)))) then
							return "rejuvenation_cycle healing";
						end
					end
					if ((v102.Rejuvenation:IsCastable() and v81 and v18:BuffRefreshable(v102.Rejuvenation) and (v18:HealthPercentage() <= v82)) or ((1894 + 2530) < (10 + 17))) then
						if (v26(v105.RejuvenationFocus) or ((1702 + 295) > (4755 - (850 + 90)))) then
							return "rejuvenation healing";
						end
					end
					v197 = 12 - 5;
				end
				if (((4855 - (360 + 1030)) > (1693 + 220)) and (v197 == (19 - 12))) then
					if (((1007 - 274) < (3480 - (909 + 752))) and v102.Regrowth:IsCastable() and v79 and v18:BuffUp(v102.Rejuvenation) and (v18:HealthPercentage() <= v80)) then
						if (v26(v105.RegrowthFocus, nil, true) or ((5618 - (109 + 1114)) == (8705 - 3950))) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v197 == (1 + 1)) or ((4035 - (6 + 236)) < (1493 + 876))) then
					if ((v15:AffectingCombat() and v33 and v102.Tranquility:IsReady() and v101.AreUnitsBelowHealthPercentage(v86, v87, v102.Regrowth)) or ((3288 + 796) == (624 - 359))) then
						if (((7611 - 3253) == (5491 - (1076 + 57))) and v26(v102.Tranquility, nil, true)) then
							return "tranquility healing";
						end
					end
					if ((v15:AffectingCombat() and v33 and v102.Tranquility:IsReady() and v15:BuffUp(v102.IncarnationBuff) and v101.AreUnitsBelowHealthPercentage(v89, v90, v102.Regrowth)) or ((517 + 2621) < (1682 - (579 + 110)))) then
						if (((263 + 3067) > (2054 + 269)) and v26(v102.Tranquility, nil, true)) then
							return "tranquility_tree healing";
						end
					end
					if ((v15:AffectingCombat() and v33 and v102.ConvokeTheSpirits:IsReady() and v101.AreUnitsBelowHealthPercentage(v64, v65, v102.Regrowth)) or ((1925 + 1701) == (4396 - (174 + 233)))) then
						if (v26(v102.ConvokeTheSpirits) or ((2558 - 1642) == (4687 - 2016))) then
							return "convoke_the_spirits healing";
						end
					end
					v197 = 2 + 1;
				end
			end
		end
	end
	local function v142()
		local v163 = 1174 - (663 + 511);
		local v164;
		while true do
			if (((243 + 29) == (60 + 212)) and ((9 - 6) == v163)) then
				v164 = v141();
				if (((2574 + 1675) <= (11392 - 6553)) and v164) then
					return v164;
				end
				v163 = 9 - 5;
			end
			if (((1326 + 1451) < (6228 - 3028)) and (v163 == (0 + 0))) then
				v164 = v101.HandleAfflicted(v102.NaturesCure, v105.NaturesCureFocus, 3 + 27);
				if (((817 - (478 + 244)) < (2474 - (440 + 77))) and v164) then
					return v164;
				end
				v163 = 1 + 0;
			end
			if (((3022 - 2196) < (3273 - (655 + 901))) and ((1 + 3) == v163)) then
				if (((1092 + 334) >= (747 + 358)) and v101.TargetIsValid() and v36) then
					local v231 = 0 - 0;
					while true do
						if (((4199 - (695 + 750)) <= (11538 - 8159)) and (v231 == (0 - 0))) then
							v164 = v136();
							if (v164 or ((15793 - 11866) == (1764 - (285 + 66)))) then
								return v164;
							end
							break;
						end
					end
				end
				break;
			end
			if (((2 - 1) == v163) or ((2464 - (682 + 628)) <= (128 + 660))) then
				if (((v46 or v45) and v34) or ((1942 - (176 + 123)) > (1414 + 1965))) then
					local v232 = 0 + 0;
					local v233;
					while true do
						if ((v232 == (269 - (239 + 30))) or ((762 + 2041) > (4373 + 176))) then
							v233 = v138();
							if (v233 or ((389 - 169) >= (9428 - 6406))) then
								return v233;
							end
							break;
						end
					end
				end
				v164 = v139();
				v163 = 317 - (306 + 9);
			end
			if (((9847 - 7025) == (491 + 2331)) and ((2 + 0) == v163)) then
				if (v164 or ((511 + 550) == (5309 - 3452))) then
					return v164;
				end
				if (((4135 - (1140 + 235)) > (869 + 495)) and v35) then
					local v234 = 0 + 0;
					local v235;
					while true do
						if ((v234 == (0 + 0)) or ((4954 - (33 + 19)) <= (1299 + 2296))) then
							v235 = v140();
							if (v235 or ((11545 - 7693) == (130 + 163))) then
								return v235;
							end
							break;
						end
					end
				end
				v163 = 5 - 2;
			end
		end
	end
	local function v143()
		if (((v46 or v45) and v34) or ((1462 + 97) == (5277 - (586 + 103)))) then
			local v198 = v138();
			if (v198 or ((409 + 4075) == (2425 - 1637))) then
				return v198;
			end
		end
		if (((6056 - (1309 + 179)) >= (7052 - 3145)) and v31 and v38) then
			local v199 = 0 + 0;
			local v200;
			while true do
				if (((3346 - 2100) < (2622 + 848)) and (v199 == (0 - 0))) then
					v200 = v141();
					if (((8105 - 4037) >= (1581 - (295 + 314))) and v200) then
						return v200;
					end
					break;
				end
			end
		end
		if (((1210 - 717) < (5855 - (1300 + 662))) and v44 and v102.MarkOfTheWild:IsCastable() and (v15:BuffDown(v102.MarkOfTheWild, true) or v101.GroupBuffMissing(v102.MarkOfTheWild))) then
			if (v26(v105.MarkOfTheWildPlayer) or ((4625 - 3152) >= (5087 - (1178 + 577)))) then
				return "mark_of_the_wild";
			end
		end
		if (v101.TargetIsValid() or ((2104 + 1947) <= (3420 - 2263))) then
			if (((2009 - (851 + 554)) < (2548 + 333)) and v102.Rake:IsReady() and (v15:StealthUp(false, true))) then
				if (v26(v102.Rake, not v17:IsInMeleeRange(27 - 17)) or ((1954 - 1054) == (3679 - (115 + 187)))) then
					return "rake";
				end
			end
		end
		if (((3415 + 1044) > (560 + 31)) and v101.TargetIsValid() and v36) then
			local v201 = 0 - 0;
			local v202;
			while true do
				if (((4559 - (160 + 1001)) >= (2096 + 299)) and (v201 == (0 + 0))) then
					v202 = v136();
					if (v202 or ((4468 - 2285) >= (3182 - (237 + 121)))) then
						return v202;
					end
					break;
				end
			end
		end
	end
	local function v144()
		v39 = EpicSettings.Settings['UseRacials'];
		v40 = EpicSettings.Settings['UseTrinkets'];
		v41 = EpicSettings.Settings['UseHealingPotion'];
		v42 = EpicSettings.Settings['HealingPotionName'] or "";
		v43 = EpicSettings.Settings['HealingPotionHP'] or (897 - (525 + 372));
		v44 = EpicSettings.Settings['UseMarkOfTheWild'];
		v45 = EpicSettings.Settings['DispelDebuffs'];
		v46 = EpicSettings.Settings['DispelBuffs'];
		v47 = EpicSettings.Settings['UseHealthstone'];
		v48 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v49 = EpicSettings.Settings['HandleCharredTreant'];
		v50 = EpicSettings.Settings['HandleCharredBrambles'];
		v51 = EpicSettings.Settings['InterruptWithStun'];
		v52 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v53 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v54 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v55 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v56 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v57 = EpicSettings.Settings['EfflorescenceHP'] or (142 - (96 + 46));
		v58 = EpicSettings.Settings['UseGroveGuardians'];
		v59 = EpicSettings.Settings['GroveGuardiansHP'] or (777 - (643 + 134));
		v60 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 + 0);
		v61 = EpicSettings.Settings['UseCenarionWard'];
		v62 = EpicSettings.Settings['CenarionWardHP'] or (0 - 0);
		v63 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v64 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 - 0);
		v65 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
		v66 = EpicSettings.Settings['UseFlourish'];
		v67 = EpicSettings.Settings['FlourishHP'] or (0 - 0);
		v68 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
		v69 = EpicSettings.Settings['IronBarkUsage'] or "";
		v70 = EpicSettings.Settings['IronBarkHP'] or (719 - (316 + 403));
	end
	local function v145()
		local v182 = 0 + 0;
		while true do
			if (((5322 - 3386) == (700 + 1236)) and (v182 == (7 - 4))) then
				v83 = EpicSettings.Settings['UseSwiftmend'];
				v84 = EpicSettings.Settings['SwiftmendHP'] or (0 + 0);
				v85 = EpicSettings.Settings['UseTranquility'];
				v86 = EpicSettings.Settings['TranquilityHP'] or (0 + 0);
				v182 = 13 - 9;
			end
			if ((v182 == (23 - 18)) or ((10037 - 5205) < (247 + 4066))) then
				v91 = EpicSettings.Settings['UseWildgrowthSotF'];
				v92 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
				v93 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 + 0);
				v94 = EpicSettings.Settings['UseWildgrowth'];
				v182 = 17 - 11;
			end
			if (((4105 - (12 + 5)) > (15046 - 11172)) and (v182 == (14 - 7))) then
				v99 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
				v100 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((10742 - 6410) == (880 + 3452)) and (v182 == (1977 - (1656 + 317)))) then
				v87 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
				v88 = EpicSettings.Settings['UseTranquilityTree'];
				v89 = EpicSettings.Settings['TranquilityTreeHP'] or (0 + 0);
				v90 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 - 0);
				v182 = 24 - 19;
			end
			if (((4353 - (5 + 349)) >= (13774 - 10874)) and (v182 == (1271 - (266 + 1005)))) then
				v71 = EpicSettings.Settings['UseLifebloomTank'];
				v72 = EpicSettings.Settings['LifebloomTankHP'] or (0 + 0);
				v73 = EpicSettings.Settings['UseLifebloom'];
				v74 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
				v182 = 1 - 0;
			end
			if ((v182 == (1702 - (561 + 1135))) or ((3290 - 765) > (13358 - 9294))) then
				v95 = EpicSettings.Settings['WildgrowthHP'] or (1066 - (507 + 559));
				v96 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v97 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v98 = EpicSettings.Settings['UseBarkskin'];
				v182 = 395 - (212 + 176);
			end
			if (((5276 - (250 + 655)) == (11919 - 7548)) and (v182 == (1 - 0))) then
				v75 = EpicSettings.Settings['UseNaturesSwiftness'];
				v76 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
				v77 = EpicSettings.Settings['UseRegrowth'];
				v78 = EpicSettings.Settings['RegrowthHP'] or (1956 - (1869 + 87));
				v182 = 6 - 4;
			end
			if ((v182 == (1903 - (484 + 1417))) or ((570 - 304) > (8355 - 3369))) then
				v79 = EpicSettings.Settings['UseRegrowthRefresh'];
				v80 = EpicSettings.Settings['RegrowthRefreshHP'] or (773 - (48 + 725));
				v81 = EpicSettings.Settings['UseRejuvenation'];
				v82 = EpicSettings.Settings['RejuvenationHP'] or (0 - 0);
				v182 = 7 - 4;
			end
		end
	end
	local function v146()
		v144();
		v145();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['ramp'];
		v36 = EpicSettings.Toggles['dps'];
		v37 = EpicSettings.Toggles['dpsform'];
		v38 = EpicSettings.Toggles['healing'];
		if (((1158 + 833) >= (2472 - 1547)) and v15:IsDeadOrGhost()) then
			return;
		end
		if (((128 + 327) < (599 + 1454)) and (v15:AffectingCombat() or v45)) then
			local v203 = 853 - (152 + 701);
			local v204;
			while true do
				if ((v203 == (1311 - (430 + 881))) or ((317 + 509) == (5746 - (557 + 338)))) then
					v204 = v45 and v102.NaturesCure:IsReady() and v34;
					if (((55 + 128) == (515 - 332)) and v101.IsTankBelowHealthPercentage(v70, 70 - 50, v102.Regrowth) and v102.IronBark:IsReady() and ((v69 == "Tank Only") or (v69 == "Tank and Self"))) then
						local v239 = v101.FocusUnit(v204, nil, nil, "TANK", 106 - 66, v102.Regrowth);
						if (((2497 - 1338) <= (2589 - (499 + 302))) and v239) then
							return v239;
						end
					elseif (((v15:HealthPercentage() < v70) and v102.IronBark:IsReady() and (v69 == "Tank and Self")) or ((4373 - (39 + 827)) > (11919 - 7601))) then
						local v240 = v101.FocusUnit(v204, nil, nil, "HEALER", 89 - 49, v102.Regrowth);
						if (v240 or ((12213 - 9138) <= (4551 - 1586))) then
							return v240;
						end
					else
						local v241 = 0 + 0;
						local v242;
						while true do
							if (((3995 - 2630) <= (322 + 1689)) and (v241 == (0 - 0))) then
								v242 = v101.FocusUnit(v204, nil, nil, nil, 144 - (103 + 1), v102.Regrowth);
								if (v242 or ((3330 - (475 + 79)) > (7728 - 4153))) then
									return v242;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (v15:IsMounted() or ((8172 - 5618) == (621 + 4183))) then
			return;
		end
		if (((2268 + 309) == (4080 - (1395 + 108))) and v15:IsMoving()) then
			v106 = GetTime();
		end
		if (v15:BuffUp(v102.TravelForm) or v15:BuffUp(v102.BearForm) or v15:BuffUp(v102.CatForm) or ((17 - 11) >= (3093 - (7 + 1197)))) then
			if (((221 + 285) <= (661 + 1231)) and ((GetTime() - v106) < (320 - (27 + 292)))) then
				return;
			end
		end
		if (v32 or ((5883 - 3875) > (2827 - 609))) then
			v107 = v17:GetEnemiesInSplashRange(33 - 25);
			v108 = #v107;
		else
			local v205 = 0 - 0;
			while true do
				if (((721 - 342) <= (4286 - (43 + 96))) and ((0 - 0) == v205)) then
					v107 = {};
					v108 = 1 - 0;
					break;
				end
			end
		end
		if (v101.TargetIsValid() or v15:AffectingCombat() or ((3746 + 768) <= (285 + 724))) then
			v109 = v11.BossFightRemains(nil, true);
			v110 = v109;
			if ((v110 == (21960 - 10849)) or ((1340 + 2156) == (2233 - 1041))) then
				v110 = v11.FightRemains(v107, false);
			end
		end
		if (v49 or ((66 + 142) == (217 + 2742))) then
			local v206 = v101.HandleCharredTreant(v102.Rejuvenation, v105.RejuvenationMouseover, 1791 - (1414 + 337));
			if (((6217 - (1642 + 298)) >= (3422 - 2109)) and v206) then
				return v206;
			end
			local v206 = v101.HandleCharredTreant(v102.Regrowth, v105.RegrowthMouseover, 115 - 75, true);
			if (((7677 - 5090) < (1045 + 2129)) and v206) then
				return v206;
			end
			local v206 = v101.HandleCharredTreant(v102.Swiftmend, v105.SwiftmendMouseover, 32 + 8);
			if (v206 or ((5092 - (357 + 615)) <= (1543 + 655))) then
				return v206;
			end
			local v206 = v101.HandleCharredTreant(v102.Wildgrowth, v105.WildgrowthMouseover, 98 - 58, true);
			if (v206 or ((1368 + 228) == (1838 - 980))) then
				return v206;
			end
		end
		if (((2576 + 644) == (219 + 3001)) and v50) then
			local v207 = v101.HandleCharredBrambles(v102.Rejuvenation, v105.RejuvenationMouseover, 26 + 14);
			if (v207 or ((2703 - (384 + 917)) > (4317 - (128 + 569)))) then
				return v207;
			end
			local v207 = v101.HandleCharredBrambles(v102.Regrowth, v105.RegrowthMouseover, 1583 - (1407 + 136), true);
			if (((4461 - (687 + 1200)) == (4284 - (556 + 1154))) and v207) then
				return v207;
			end
			local v207 = v101.HandleCharredBrambles(v102.Swiftmend, v105.SwiftmendMouseover, 140 - 100);
			if (((1893 - (9 + 86)) < (3178 - (275 + 146))) and v207) then
				return v207;
			end
			local v207 = v101.HandleCharredBrambles(v102.Wildgrowth, v105.WildgrowthMouseover, 7 + 33, true);
			if (v207 or ((441 - (29 + 35)) > (11540 - 8936))) then
				return v207;
			end
		end
		if (((1696 - 1128) < (4021 - 3110)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17) and not v15:AffectingCombat() and v31) then
			local v208 = v101.DeadFriendlyUnitsCount();
			if (((2140 + 1145) < (5240 - (53 + 959))) and v15:AffectingCombat()) then
				if (((4324 - (312 + 96)) > (5775 - 2447)) and v102.Rebirth:IsReady()) then
					if (((2785 - (147 + 138)) < (4738 - (813 + 86))) and v26(v102.Rebirth, nil, true)) then
						return "rebirth";
					end
				end
			elseif (((459 + 48) == (939 - 432)) and (v208 > (493 - (18 + 474)))) then
				if (((81 + 159) <= (10330 - 7165)) and v26(v102.Revitalize, nil, true)) then
					return "revitalize";
				end
			elseif (((1920 - (860 + 226)) >= (1108 - (121 + 182))) and v26(v102.Revive, not v17:IsInRange(5 + 35), true)) then
				return "revive";
			end
		end
		if ((v38 and (v15:AffectingCombat() or v31)) or ((5052 - (988 + 252)) < (262 + 2054))) then
			local v209 = 0 + 0;
			local v210;
			while true do
				if ((v209 == (1971 - (49 + 1921))) or ((3542 - (223 + 667)) <= (1585 - (51 + 1)))) then
					v210 = v141();
					if (v210 or ((6192 - 2594) < (3126 - 1666))) then
						return v210;
					end
					break;
				end
				if ((v209 == (1125 - (146 + 979))) or ((1162 + 2954) < (1797 - (311 + 294)))) then
					v210 = v140();
					if (v210 or ((9417 - 6040) <= (383 + 520))) then
						return v210;
					end
					v209 = 1444 - (496 + 947);
				end
			end
		end
		if (((5334 - (1233 + 125)) >= (179 + 260)) and not v15:IsChanneling()) then
			if (((3367 + 385) == (713 + 3039)) and v15:AffectingCombat()) then
				local v224 = v142();
				if (((5691 - (963 + 682)) > (2250 + 445)) and v224) then
					return v224;
				end
			elseif (v31 or ((5049 - (504 + 1000)) == (2153 + 1044))) then
				local v236 = 0 + 0;
				local v237;
				while true do
					if (((226 + 2168) > (549 - 176)) and (v236 == (0 + 0))) then
						v237 = v143();
						if (((2417 + 1738) <= (4414 - (156 + 26))) and v237) then
							return v237;
						end
						break;
					end
				end
			end
		end
	end
	local function v147()
		v24.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v121();
	end
	v24.SetAPL(61 + 44, v146, v147);
end;
return v1["Epix_Druid_RestoDruid.lua"](...);

