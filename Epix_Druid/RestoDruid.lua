local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((17138 - 12295) < (2325 + 2500))) then
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
	local v104 = 796 - (588 + 208);
	local v105, v106;
	local v107 = 29946 - 18835;
	local v108 = 12911 - (884 + 916);
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[27 - 14] and v20(v116[8 + 5])) or v20(653 - (232 + 421));
	local v118 = (v116[1903 - (1569 + 320)] and v20(v116[4 + 10])) or v20(0 + 0);
	v9:RegisterForEvent(function()
		v116 = v13:GetEquipment();
		v117 = (v116[43 - 30] and v20(v116[618 - (316 + 289)])) or v20(0 - 0);
		v118 = (v116[1 + 13] and v20(v116[1467 - (666 + 787)])) or v20(425 - (360 + 65));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (254 - (79 + 175))) or ((6113 - 2236) >= (3541 + 996))) then
				v107 = 34058 - 22947;
				v108 = 21397 - 10286;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (v100.ImprovedNaturesCure:IsAvailable() or ((5214 - (503 + 396)) < (1907 - (92 + 89)))) then
			local v167 = 0 - 0;
			while true do
				if ((v167 == (0 + 0)) or ((2178 + 1501) < (2447 - 1822))) then
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
		return (v13:StealthUp(true, true) and (1.6 + 0)) or (2 - 1);
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		v109 = v13:BuffUp(v100.EclipseSolar) or v13:BuffUp(v100.EclipseLunar);
		v110 = v13:BuffUp(v100.EclipseSolar) and v13:BuffUp(v100.EclipseLunar);
		v111 = v13:BuffUp(v100.EclipseLunar) and v13:BuffDown(v100.EclipseSolar);
		v112 = v13:BuffUp(v100.EclipseSolar) and v13:BuffDown(v100.EclipseLunar);
		v113 = (not v109 and (((v100.Starfire:Count() == (0 + 0)) and (v100.Wrath:Count() > (0 + 0))) or v13:IsCasting(v100.Wrath))) or v112;
		v114 = (not v109 and (((v100.Wrath:Count() == (0 - 0)) and (v100.Starfire:Count() > (0 + 0))) or v13:IsCasting(v100.Starfire))) or v111;
		v115 = not v109 and (v100.Wrath:Count() > (0 - 0)) and (v100.Starfire:Count() > (1244 - (485 + 759)));
	end
	local function v122(v147)
		return v147:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (11 - 6));
	end
	local function v123(v148)
		return (v148:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (1201 - (442 + 747))) and ((((v106 <= (1139 - (832 + 303))) or (v13:Energy() < (996 - (88 + 858)))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (2 + 2)) or (v13:Energy() < (42 + 8))) and v13:BuffUp(v100.HeartOfTheWild))) and v148:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(1 + 0, v100.Sunfire) and ((v148:DebuffUp(v100.MoonfireDebuff) and (v148:DebuffRemains(v100.MoonfireDebuff) < (v148:DebuffDuration(v100.MoonfireDebuff) * (789.8 - (766 + 23))))) or v148:DebuffDown(v100.MoonfireDebuff)) and (v106 == (4 - 3)));
	end
	local function v124(v149)
		return v149:DebuffRefreshable(v100.MoonfireDebuff) and (v149:TimeToDie() > (6 - 1));
	end
	local function v125(v150)
		return ((v150:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (237 - 147)) and (v150:DebuffRemains(v100.Rip) <= (33 - 23)))) and (((v13:ComboPoints() == (1078 - (1036 + 37))) and (v150:TimeToDie() > (v150:DebuffRemains(v100.Rip) + 18 + 6))) or (((v150:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (7 - 3))) < v150:TimeToDie()) and ((v150:DebuffRemains(v100.Rip) + 4 + 0 + (v13:ComboPoints() * (1484 - (641 + 839)))) > v150:TimeToDie())))) or (v150:DebuffDown(v100.Rip) and (v13:ComboPoints() > ((915 - (910 + 3)) + (v106 * (4 - 2)))));
	end
	local function v126(v151)
		return (v151:DebuffDown(v100.RakeDebuff) or v151:DebuffRefreshable(v100.RakeDebuff)) and (v151:TimeToDie() > (1694 - (1466 + 218))) and (v13:ComboPoints() < (3 + 2));
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
		local v154 = 1148 - (556 + 592);
		local v155;
		while true do
			if ((v154 == (1 + 0)) or ((5433 - (329 + 479)) < (1486 - (174 + 680)))) then
				v155 = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 137 - 97, nil);
				if (v155 or ((171 - 88) > (1271 + 509))) then
					return v155;
				end
				break;
			end
			if (((1285 - (396 + 343)) <= (96 + 981)) and (v154 == (1477 - (29 + 1448)))) then
				v155 = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 1429 - (135 + 1254), nil);
				if (v155 or ((3752 - 2756) > (20081 - 15780))) then
					return v155;
				end
				v154 = 1 + 0;
			end
		end
	end
	local function v132()
		if (((5597 - (389 + 1138)) > (1261 - (102 + 472))) and v100.Rake:IsReady() and (v13:StealthUp(false, true))) then
			if (v24(v100.Rake, not v15:IsInMeleeRange(10 + 0)) or ((364 + 292) >= (3105 + 225))) then
				return "rake cat 2";
			end
		end
		if ((v38 and not v13:StealthUp(false, true)) or ((4037 - (320 + 1225)) <= (596 - 261))) then
			local v170 = v131();
			if (((2645 + 1677) >= (4026 - (157 + 1307))) and v170) then
				return v170;
			end
		end
		if (v100.AdaptiveSwarm:IsCastable() or ((5496 - (821 + 1038)) >= (9406 - 5636))) then
			if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((261 + 2118) > (8131 - 3553))) then
				return "adaptive_swarm cat";
			end
		end
		if ((v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) or ((180 + 303) > (1841 - 1098))) then
			if (((3480 - (834 + 192)) > (37 + 541)) and v13:BuffUp(v100.CatForm)) then
				if (((239 + 691) < (96 + 4362)) and (v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (92 - 32)) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (354 - (300 + 4))) and (((v13:ComboPoints() < (2 + 3)) and (v15:DebuffRemains(v100.Rip) > (13 - 8))) or (v106 > (363 - (112 + 250))))) then
					if (((264 + 398) <= (2434 - 1462)) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(18 + 12))) then
						return "convoke_the_spirits cat 18";
					end
				end
			end
		end
		if (((2260 + 2110) == (3269 + 1101)) and v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (3 + 2)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (23 + 7)))) then
			if (v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover) or ((6176 - (1001 + 413)) <= (1919 - 1058))) then
				return "sunfire cat 20";
			end
		end
		if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (887 - (244 + 638))) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (723 - (627 + 66))))) or ((4207 - 2795) == (4866 - (512 + 90)))) then
			if (v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((5074 - (1665 + 241)) < (2870 - (373 + 344)))) then
				return "moonfire cat 22";
			end
		end
		if ((v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (3 + 2))) or ((1317 + 3659) < (3513 - 2181))) then
			if (((7831 - 3203) == (5727 - (35 + 1064))) and v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire))) then
				return "sunfire cat 24";
			end
		end
		if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (4 + 1))) or ((115 - 61) == (2 + 393))) then
			if (((1318 - (298 + 938)) == (1341 - (233 + 1026))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire cat 24";
			end
		end
		if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((2247 - (636 + 1030)) < (145 + 137))) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((4502 + 107) < (742 + 1753))) then
				return "starsurge cat 26";
			end
		end
		if (((78 + 1074) == (1373 - (55 + 166))) and v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (6 + 24)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (1 + 3)))) then
			if (((7240 - 5344) <= (3719 - (36 + 261))) and v24(v100.HeartOfTheWild)) then
				return "heart_of_the_wild cat 26";
			end
		end
		if ((v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (52 - 22)) and v35) or ((2358 - (34 + 1334)) > (623 + 997))) then
			if (v24(v100.CatForm) or ((682 + 195) > (5978 - (1035 + 248)))) then
				return "cat_form cat 28";
			end
		end
		if (((2712 - (20 + 1)) >= (965 + 886)) and v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (322 - (134 + 185))) and (v15:TimeToDie() < (1143 - (549 + 584)))) or ((v13:ComboPoints() == (690 - (314 + 371))) and (v13:Energy() >= (85 - 60)) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (973 - (478 + 490))))))) then
			if (v24(v100.FerociousBite, not v15:IsInMeleeRange(3 + 2)) or ((4157 - (786 + 386)) >= (15728 - 10872))) then
				return "ferocious_bite cat 32";
			end
		end
		if (((5655 - (1055 + 324)) >= (2535 - (1093 + 247))) and v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (10 + 1)) and v125(v15)) then
			if (((340 + 2892) <= (18620 - 13930)) and v24(v100.Rip, not v15:IsInMeleeRange(16 - 11))) then
				return "rip cat 34";
			end
		end
		if ((v100.Thrash:IsReady() and (v106 >= (5 - 3)) and v15:DebuffRefreshable(v100.ThrashDebuff)) or ((2251 - 1355) >= (1120 + 2026))) then
			if (((11792 - 8731) >= (10195 - 7237)) and v24(v100.Thrash, not v15:IsInMeleeRange(7 + 1))) then
				return "thrash cat";
			end
		end
		if (((8150 - 4963) >= (1332 - (364 + 324))) and v100.Rake:IsReady() and v126(v15)) then
			if (((1765 - 1121) <= (1689 - 985)) and v24(v100.Rake, not v15:IsInMeleeRange(2 + 3))) then
				return "rake cat 36";
			end
		end
		if (((4008 - 3050) > (1515 - 568)) and v100.Rake:IsReady() and ((v13:ComboPoints() < (15 - 10)) or (v13:Energy() > (1358 - (1249 + 19)))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) then
			if (((4055 + 437) >= (10330 - 7676)) and v24(v100.Rake, not v15:IsInMeleeRange(1091 - (686 + 400)))) then
				return "rake cat 40";
			end
		end
		if (((2701 + 741) >= (1732 - (73 + 156))) and v100.Swipe:IsReady() and (v106 >= (1 + 1))) then
			if (v24(v100.Swipe, not v15:IsInMeleeRange(819 - (721 + 90))) or ((36 + 3134) <= (4753 - 3289))) then
				return "swipe cat 38";
			end
		end
		if ((v100.Shred:IsReady() and ((v13:ComboPoints() < (475 - (224 + 246))) or (v13:Energy() > (145 - 55)))) or ((8832 - 4035) == (796 + 3592))) then
			if (((14 + 537) <= (501 + 180)) and v24(v100.Shred, not v15:IsInMeleeRange(9 - 4))) then
				return "shred cat 42";
			end
		end
	end
	local function v133()
		if (((10905 - 7628) > (920 - (203 + 310))) and v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (2023 - (1238 + 755))) or (v100.ConvokeTheSpirits:CooldownRemains() > (7 + 83)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) then
			if (((6229 - (709 + 825)) >= (2607 - 1192)) and v24(v100.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if ((v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) or ((4678 - 1466) <= (1808 - (196 + 668)))) then
			if (v24(v100.MoonkinForm) or ((12223 - 9127) <= (3724 - 1926))) then
				return "moonkin_form owl 4";
			end
		end
		if (((4370 - (171 + 662)) == (3630 - (4 + 89))) and v100.Starsurge:IsReady() and ((v106 < (20 - 14)) or (not v111 and (v106 < (3 + 5)))) and v35) then
			if (((16852 - 13015) >= (616 + 954)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
				return "starsurge owl 8";
			end
		end
		if ((v100.Moonfire:IsReady() and ((v106 < (1491 - (35 + 1451))) or (not v111 and (v106 < (1460 - (28 + 1425)))))) or ((4943 - (941 + 1052)) == (3656 + 156))) then
			if (((6237 - (822 + 692)) >= (3308 - 990)) and v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
				return "moonfire owl 10";
			end
		end
		if (v100.Sunfire:IsReady() or ((955 + 1072) > (3149 - (45 + 252)))) then
			if (v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover) or ((1124 + 12) > (1486 + 2831))) then
				return "sunfire owl 12";
			end
		end
		if (((11555 - 6807) == (5181 - (114 + 319))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
			if (((5363 - 1627) <= (6073 - 1333)) and v13:BuffUp(v100.MoonkinForm)) then
				if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(20 + 10)) or ((5050 - 1660) <= (6411 - 3351))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if ((v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(1971 - (556 + 1407))) and ((v112 and (v106 == (1207 - (741 + 465)))) or v113 or (v115 and (v106 > (466 - (170 + 295)))))) or ((527 + 472) > (2474 + 219))) then
			if (((1139 - 676) < (499 + 102)) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
				return "wrath owl 14";
			end
		end
		if (v100.Starfire:IsReady() or ((1400 + 783) < (390 + 297))) then
			if (((5779 - (957 + 273)) == (1217 + 3332)) and v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
	end
	local function v134()
		local v156 = v99.InterruptWithStun(v100.IncapacitatingRoar, 4 + 4);
		if (((17802 - 13130) == (12311 - 7639)) and v156) then
			return v156;
		end
		if ((v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 - 0))) or ((18162 - 14494) < (2175 - (389 + 1391)))) then
			local v171 = 0 + 0;
			while true do
				if ((v171 == (0 + 0)) or ((9484 - 5318) == (1406 - (783 + 168)))) then
					v156 = v99.InterruptWithStun(v100.Maim, 26 - 18);
					if (v156 or ((4377 + 72) == (2974 - (309 + 2)))) then
						return v156;
					end
					break;
				end
			end
		end
		v156 = v99.InterruptWithStun(v100.MightyBash, 24 - 16);
		if (v156 or ((5489 - (1090 + 122)) < (970 + 2019))) then
			return v156;
		end
		v121();
		local v157 = 0 - 0;
		if (v100.Rip:IsAvailable() or ((596 + 274) >= (5267 - (628 + 490)))) then
			v157 = v157 + 1 + 0;
		end
		if (((5476 - 3264) < (14546 - 11363)) and v100.Rake:IsAvailable()) then
			v157 = v157 + (775 - (431 + 343));
		end
		if (((9382 - 4736) > (8655 - 5663)) and v100.Thrash:IsAvailable()) then
			v157 = v157 + 1 + 0;
		end
		if (((184 + 1250) < (4801 - (556 + 1139))) and (v157 >= (17 - (6 + 9))) and v15:IsInMeleeRange(2 + 6)) then
			local v172 = 0 + 0;
			local v173;
			while true do
				if (((955 - (28 + 141)) < (1171 + 1852)) and (v172 == (0 - 0))) then
					v173 = v132();
					if (v173 or ((1730 + 712) < (1391 - (486 + 831)))) then
						return v173;
					end
					break;
				end
			end
		end
		if (((11801 - 7266) == (15966 - 11431)) and v100.AdaptiveSwarm:IsCastable()) then
			if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((569 + 2440) <= (6655 - 4550))) then
				return "adaptive_swarm main";
			end
		end
		if (((3093 - (668 + 595)) < (3302 + 367)) and v100.MoonkinForm:IsAvailable()) then
			local v174 = v133();
			if (v174 or ((289 + 1141) >= (9850 - 6238))) then
				return v174;
			end
		end
		if (((2973 - (23 + 267)) >= (4404 - (1129 + 815))) and v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) then
			if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((2191 - (371 + 16)) >= (5025 - (1326 + 424)))) then
				return "sunfire main 24";
			end
		end
		if ((v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) or ((2683 - 1266) > (13261 - 9632))) then
			if (((4913 - (88 + 30)) > (1173 - (720 + 51))) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if (((10706 - 5893) > (5341 - (421 + 1355))) and v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) then
			if (((6453 - 2541) == (1922 + 1990)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
				return "starsurge main 28";
			end
		end
		if (((3904 - (286 + 797)) <= (17634 - 12810)) and v100.Starfire:IsReady() and (v106 > (2 - 0))) then
			if (((2177 - (397 + 42)) <= (686 + 1509)) and v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
		if (((841 - (24 + 776)) <= (4649 - 1631)) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(793 - (222 + 563)))) then
			if (((4726 - 2581) <= (2955 + 1149)) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
				return "wrath main 30";
			end
		end
		if (((2879 - (23 + 167)) < (6643 - (690 + 1108))) and v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(3 + 5))) then
			if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((1916 + 406) > (3470 - (40 + 808)))) then
				return "moonfire main 32";
			end
		end
		if (true or ((747 + 3787) == (7961 - 5879))) then
			if (v24(v100.Pool) or ((1502 + 69) > (988 + 879))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		if ((v16 and (v99.UnitHasDispellableDebuffByPlayer(v16) or v99.DispellableFriendlyUnit(611 - (47 + 524))) and v100.NaturesCure:IsReady()) or ((1723 + 931) >= (8189 - 5193))) then
			local v175 = 0 - 0;
			while true do
				if (((9072 - 5094) > (3830 - (1165 + 561))) and (v175 == (0 + 0))) then
					if (((9276 - 6281) > (588 + 953)) and (v135 == (479 - (341 + 138)))) then
						v135 = GetTime();
					end
					if (((878 + 2371) > (1966 - 1013)) and v99.Wait(826 - (89 + 237), v135)) then
						if (v24(v103.NaturesCureFocus) or ((10529 - 7256) > (9627 - 5054))) then
							return "natures_cure dispel 2";
						end
						v135 = 881 - (581 + 300);
					end
					break;
				end
			end
		end
	end
	local function v137()
		local v158 = 1220 - (855 + 365);
		while true do
			if ((v158 == (0 - 0)) or ((1029 + 2122) < (2519 - (1030 + 205)))) then
				if (((v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) or ((1737 + 113) == (1423 + 106))) then
					if (((1107 - (156 + 130)) < (4823 - 2700)) and v24(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((1519 - 617) < (4761 - 2436)) and (v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) then
					if (((227 + 631) <= (1728 + 1234)) and v24(v100.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v158 = 70 - (10 + 59);
			end
			if ((v158 == (1 + 0)) or ((19433 - 15487) < (2451 - (671 + 492)))) then
				if ((v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) or ((2581 + 661) == (1782 - (369 + 846)))) then
					if (v24(v103.Healthstone, nil, nil, true) or ((225 + 622) >= (1078 + 185))) then
						return "healthstone defensive 3";
					end
				end
				if ((v39 and (v13:HealthPercentage() <= v41)) or ((4198 - (1036 + 909)) == (1472 + 379))) then
					if ((v40 == "Refreshing Healing Potion") or ((3503 - 1416) > (2575 - (11 + 192)))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((2247 + 2198) < (4324 - (135 + 40)))) then
							if (v24(v103.RefreshingHealingPotion, nil, nil, true) or ((4404 - 2586) == (52 + 33))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v138()
		local v159 = 0 - 0;
		while true do
			if (((944 - 314) < (2303 - (50 + 126))) and (v159 == (2 - 1))) then
				if ((v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) or ((429 + 1509) == (3927 - (1233 + 180)))) then
					if (((5224 - (522 + 447)) >= (1476 - (107 + 1314))) and v24(v103.WildgrowthFocus, nil, true)) then
						return "wildgrowth ramp";
					end
				end
				if (((1392 + 1607) > (3522 - 2366)) and v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) then
					if (((999 + 1351) > (2293 - 1138)) and v24(v103.InnervatePlayer, nil, nil, true)) then
						return "innervate ramp";
					end
				end
				v159 = 7 - 5;
			end
			if (((5939 - (716 + 1194)) <= (83 + 4770)) and (v159 == (1 + 1))) then
				if ((v13:BuffUp(v100.Innervate) and (v129() > (503 - (74 + 429))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((995 - 479) > (1702 + 1732))) then
					if (((9261 - 5215) >= (2146 + 887)) and v24(v103.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if ((v159 == (0 - 0)) or ((6722 - 4003) <= (1880 - (279 + 154)))) then
				if ((v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) or ((4912 - (454 + 324)) < (3089 + 837))) then
					if (v24(v103.RejuvenationFocus) or ((181 - (12 + 5)) >= (1502 + 1283))) then
						return "rejuvenation ramp";
					end
				end
				if ((v100.Swiftmend:IsReady() and v130(v16)) or ((1337 - 812) == (780 + 1329))) then
					if (((1126 - (277 + 816)) == (140 - 107)) and v24(v103.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				v159 = 1184 - (1058 + 125);
			end
		end
	end
	local function v139()
		if (((573 + 2481) <= (4990 - (815 + 160))) and v36) then
			if (((8027 - 6156) < (8028 - 4646)) and v38) then
				local v214 = v131();
				if (((309 + 984) <= (6331 - 4165)) and v214) then
					return v214;
				end
			end
			if ((v53 and v31 and v13:AffectingCombat() and (v128() > (1901 - (41 + 1857))) and v100.NaturesVigil:IsReady()) or ((4472 - (1222 + 671)) < (317 - 194))) then
				if (v24(v100.NaturesVigil, nil, nil, true) or ((1215 - 369) >= (3550 - (229 + 953)))) then
					return "natures_vigil healing";
				end
			end
			if ((v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) or ((5786 - (1111 + 663)) <= (4937 - (874 + 705)))) then
				if (((210 + 1284) <= (2051 + 954)) and v24(v103.SwiftmendFocus)) then
					return "swiftmend healing";
				end
			end
			if ((v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91, v100.Regrowth)) or ((6466 - 3355) == (61 + 2073))) then
				if (((3034 - (642 + 37)) == (537 + 1818)) and v24(v103.WildgrowthFocus, nil, true)) then
					return "wildgrowth_sotf healing";
				end
			end
			if ((v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (1 + 4)) and v99.AreUnitsBelowHealthPercentage(v57, v58, v100.Regrowth)) or ((1475 - 887) <= (886 - (233 + 221)))) then
				if (((11092 - 6295) >= (3429 + 466)) and v24(v103.GroveGuardiansFocus, nil, nil)) then
					return "grove_guardians healing";
				end
			end
			if (((5118 - (718 + 823)) == (2251 + 1326)) and v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (809 - (266 + 539))) and v99.AreUnitsBelowHealthPercentage(v65, v66, v100.Regrowth)) then
				if (((10741 - 6947) > (4918 - (636 + 589))) and v24(v100.Flourish, nil, nil, true)) then
					return "flourish healing";
				end
			end
			if ((v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85, v100.Regrowth)) or ((3026 - 1751) == (8456 - 4356))) then
				if (v24(v100.Tranquility, nil, true) or ((1261 + 330) >= (1301 + 2279))) then
					return "tranquility healing";
				end
			end
			if (((1998 - (657 + 358)) <= (4787 - 2979)) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88, v100.Regrowth)) then
				if (v24(v100.Tranquility, nil, true) or ((4898 - 2748) <= (2384 - (1151 + 36)))) then
					return "tranquility_tree healing";
				end
			end
			if (((3640 + 129) >= (309 + 864)) and v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63, v100.Regrowth)) then
				if (((4434 - 2949) == (3317 - (1552 + 280))) and v24(v100.ConvokeTheSpirits)) then
					return "convoke_the_spirits healing";
				end
			end
			if ((v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) or ((4149 - (64 + 770)) <= (1889 + 893))) then
				if (v24(v103.CenarionWardFocus) or ((1988 - 1112) >= (527 + 2437))) then
					return "cenarion_ward healing";
				end
			end
			if ((v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) or ((3475 - (157 + 1086)) > (4997 - 2500))) then
				if (v24(v103.RegrowthFocus) or ((9241 - 7131) <= (508 - 176))) then
					return "regrowth_swiftness healing";
				end
			end
			if (((5030 - 1344) > (3991 - (599 + 220))) and v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) then
				if (v24(v100.NaturesSwiftness) or ((8909 - 4435) < (2751 - (1813 + 118)))) then
					return "natures_swiftness healing";
				end
			end
			if (((3128 + 1151) >= (4099 - (841 + 376))) and (v67 == "Anyone")) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) or ((2842 - 813) >= (818 + 2703))) then
					if (v24(v103.IronBarkFocus) or ((5559 - 3522) >= (5501 - (464 + 395)))) then
						return "iron_bark healing";
					end
				end
			elseif (((4414 - 2694) < (2141 + 2317)) and (v67 == "Tank Only")) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v99.UnitGroupRole(v16) == "TANK")) or ((1273 - (467 + 370)) > (6242 - 3221))) then
					if (((524 + 189) <= (2903 - 2056)) and v24(v103.IronBarkFocus)) then
						return "iron_bark healing";
					end
				end
			elseif (((337 + 1817) <= (9378 - 5347)) and (v67 == "Tank and Self")) then
				if (((5135 - (150 + 370)) == (5897 - (74 + 1208))) and v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v99.UnitGroupRole(v16) == "TANK") or (v99.UnitGroupRole(v16) == "HEALER"))) then
					if (v24(v103.IronBarkFocus) or ((9321 - 5531) == (2371 - 1871))) then
						return "iron_bark healing";
					end
				end
			end
			if (((64 + 25) < (611 - (14 + 376))) and v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) then
				if (((3561 - 1507) >= (920 + 501)) and v24(v103.AdaptiveSwarmFocus)) then
					return "adaptive_swarm healing";
				end
			end
			if (((608 + 84) < (2917 + 141)) and v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (2 - 1)) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (12 + 3)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
				if (v24(v103.LifebloomFocus) or ((3332 - (23 + 55)) == (3922 - 2267))) then
					return "lifebloom healing";
				end
			end
			if ((v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (1 + 0)) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (14 + 1)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((2009 - 713) == (1545 + 3365))) then
				if (((4269 - (652 + 249)) == (9013 - 5645)) and v24(v103.LifebloomFocus)) then
					return "lifebloom healing";
				end
			end
			if (((4511 - (708 + 1160)) < (10355 - 6540)) and (v54 == "Player")) then
				if (((3487 - 1574) > (520 - (10 + 17))) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (4 + 11))) then
					if (((6487 - (1400 + 332)) > (6575 - 3147)) and v24(v103.EfflorescencePlayer)) then
						return "efflorescence healing player";
					end
				end
			elseif (((3289 - (242 + 1666)) <= (1014 + 1355)) and (v54 == "Cursor")) then
				if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (6 + 9))) or ((4128 + 715) == (5024 - (850 + 90)))) then
					if (((8177 - 3508) > (1753 - (360 + 1030))) and v24(v103.EfflorescenceCursor)) then
						return "efflorescence healing cursor";
					end
				end
			elseif ((v54 == "Confirmation") or ((1662 + 215) >= (8856 - 5718))) then
				if (((6523 - 1781) >= (5287 - (909 + 752))) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (1238 - (109 + 1114)))) then
					if (v24(v100.Efflorescence) or ((8312 - 3772) == (357 + 559))) then
						return "efflorescence healing confirmation";
					end
				end
			end
			if ((v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94, v100.Regrowth) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) or ((1398 - (6 + 236)) > (2738 + 1607))) then
				if (((1801 + 436) < (10020 - 5771)) and v24(v103.WildgrowthFocus, nil, true)) then
					return "wildgrowth healing";
				end
			end
			if ((v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) or ((4685 - 2002) < (1156 - (1076 + 57)))) then
				if (((115 + 582) <= (1515 - (579 + 110))) and v24(v103.RegrowthFocus, nil, true)) then
					return "regrowth healing";
				end
			end
			if (((88 + 1017) <= (1040 + 136)) and v13:BuffUp(v100.Innervate) and (v129() > (0 + 0)) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) then
				if (((3786 - (174 + 233)) <= (10647 - 6835)) and v24(v103.RejuvenationMouseover)) then
					return "rejuvenation_cycle healing";
				end
			end
			if ((v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) or ((1382 - 594) >= (719 + 897))) then
				if (((3028 - (663 + 511)) <= (3015 + 364)) and v24(v103.RejuvenationFocus)) then
					return "rejuvenation healing";
				end
			end
			if (((988 + 3561) == (14024 - 9475)) and v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) then
				if (v24(v103.RegrowthFocus, nil, true) or ((1830 + 1192) >= (7119 - 4095))) then
					return "regrowth healing";
				end
			end
		end
	end
	local function v140()
		local v160 = 0 - 0;
		local v161;
		while true do
			if (((2301 + 2519) > (4277 - 2079)) and (v160 == (1 + 0))) then
				if (v161 or ((97 + 964) >= (5613 - (478 + 244)))) then
					return v161;
				end
				if (((1881 - (440 + 77)) <= (2034 + 2439)) and v33) then
					local v216 = 0 - 0;
					local v217;
					while true do
						if (((1556 - (655 + 901)) == v216) or ((667 + 2928) <= (3 + 0))) then
							v217 = v138();
							if (v217 or ((3155 + 1517) == (15518 - 11666))) then
								return v217;
							end
							break;
						end
					end
				end
				v160 = 1447 - (695 + 750);
			end
			if (((5323 - 3764) == (2405 - 846)) and (v160 == (11 - 8))) then
				if ((v99.TargetIsValid() and v34) or ((2103 - (285 + 66)) <= (1836 - 1048))) then
					local v218 = 1310 - (682 + 628);
					while true do
						if ((v218 == (0 + 0)) or ((4206 - (176 + 123)) == (75 + 102))) then
							v161 = v134();
							if (((2518 + 952) > (824 - (239 + 30))) and v161) then
								return v161;
							end
							break;
						end
					end
				end
				break;
			end
			if (((0 + 0) == v160) or ((935 + 37) == (1141 - 496))) then
				if (((9927 - 6745) >= (2430 - (306 + 9))) and (v44 or v43) and v32) then
					local v219 = v136();
					if (((13584 - 9691) < (771 + 3658)) and v219) then
						return v219;
					end
				end
				v161 = v137();
				v160 = 1 + 0;
			end
			if ((v160 == (1 + 1)) or ((8198 - 5331) < (3280 - (1140 + 235)))) then
				v161 = v139();
				if (v161 or ((1143 + 653) >= (3715 + 336))) then
					return v161;
				end
				v160 = 1 + 2;
			end
		end
	end
	local function v141()
		local v162 = 52 - (33 + 19);
		while true do
			if (((585 + 1034) <= (11257 - 7501)) and (v162 == (1 + 1))) then
				if (((1184 - 580) == (567 + 37)) and v99.TargetIsValid() and v34) then
					local v220 = 689 - (586 + 103);
					local v221;
					while true do
						if (((0 + 0) == v220) or ((13804 - 9320) == (2388 - (1309 + 179)))) then
							v221 = v134();
							if (v221 or ((8049 - 3590) <= (485 + 628))) then
								return v221;
							end
							break;
						end
					end
				end
				break;
			end
			if (((9753 - 6121) > (2567 + 831)) and (v162 == (0 - 0))) then
				if (((8133 - 4051) <= (5526 - (295 + 314))) and (v44 or v43) and v32) then
					local v222 = 0 - 0;
					local v223;
					while true do
						if (((6794 - (1300 + 662)) >= (4352 - 2966)) and (v222 == (1755 - (1178 + 577)))) then
							v223 = v136();
							if (((72 + 65) == (404 - 267)) and v223) then
								return v223;
							end
							break;
						end
					end
				end
				if ((v29 and v36) or ((2975 - (851 + 554)) >= (3831 + 501))) then
					local v224 = v139();
					if (v224 or ((11270 - 7206) <= (3950 - 2131))) then
						return v224;
					end
				end
				v162 = 303 - (115 + 187);
			end
			if (((1 + 0) == v162) or ((4721 + 265) < (6202 - 4628))) then
				if (((5587 - (160 + 1001)) > (151 + 21)) and v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) then
					if (((405 + 181) > (931 - 476)) and v24(v103.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (((1184 - (237 + 121)) == (1723 - (525 + 372))) and v99.TargetIsValid()) then
					if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((7619 - 3600) > (14591 - 10150))) then
						if (((2159 - (96 + 46)) < (5038 - (643 + 134))) and v24(v100.Rake, not v15:IsInMeleeRange(4 + 6))) then
							return "rake";
						end
					end
				end
				v162 = 4 - 2;
			end
		end
	end
	local function v142()
		local v163 = 0 - 0;
		while true do
			if (((4523 + 193) > (157 - 77)) and (v163 == (5 - 2))) then
				v55 = EpicSettings.Settings['EfflorescenceHP'] or (719 - (316 + 403));
				v56 = EpicSettings.Settings['UseGroveGuardians'];
				v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
				v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
				v59 = EpicSettings.Settings['UseCenarionWard'];
				v60 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
				v163 = 9 - 5;
			end
			if ((v163 == (2 + 0)) or ((1131 + 2376) == (11337 - 8065))) then
				v49 = EpicSettings.Settings['InterruptWithStun'];
				v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v51 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v163 = 5 - 2;
			end
			if ((v163 == (1 + 4)) or ((1724 - 848) >= (151 + 2924))) then
				v67 = EpicSettings.Settings['IronBarkUsage'] or "";
				v68 = EpicSettings.Settings['IronBarkHP'] or (0 - 0);
				break;
			end
			if (((4369 - (12 + 5)) > (9919 - 7365)) and (v163 == (8 - 4))) then
				v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 - 0);
				v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
				v64 = EpicSettings.Settings['UseFlourish'];
				v65 = EpicSettings.Settings['FlourishHP'] or (0 + 0);
				v66 = EpicSettings.Settings['FlourishGroup'] or (1973 - (1656 + 317));
				v163 = 5 + 0;
			end
			if ((v163 == (0 + 0)) or ((11715 - 7309) < (19897 - 15854))) then
				v37 = EpicSettings.Settings['UseRacials'];
				v38 = EpicSettings.Settings['UseTrinkets'];
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v41 = EpicSettings.Settings['HealingPotionHP'] or (354 - (5 + 349));
				v42 = EpicSettings.Settings['UseMarkOfTheWild'];
				v163 = 4 - 3;
			end
			if ((v163 == (1272 - (266 + 1005))) or ((1245 + 644) >= (11542 - 8159))) then
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v45 = EpicSettings.Settings['UseHealthstone'];
				v46 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v47 = EpicSettings.Settings['HandleCharredTreant'];
				v48 = EpicSettings.Settings['HandleCharredBrambles'];
				v163 = 1698 - (561 + 1135);
			end
		end
	end
	local function v143()
		local v164 = 0 - 0;
		while true do
			if (((6219 - 4327) <= (3800 - (507 + 559))) and (v164 == (7 - 4))) then
				v81 = EpicSettings.Settings['UseSwiftmend'];
				v82 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
				v83 = EpicSettings.Settings['UseTranquility'];
				v84 = EpicSettings.Settings['TranquilityHP'] or (388 - (212 + 176));
				v164 = 909 - (250 + 655);
			end
			if (((5243 - 3320) < (3875 - 1657)) and ((5 - 1) == v164)) then
				v85 = EpicSettings.Settings['TranquilityGroup'] or (1956 - (1869 + 87));
				v86 = EpicSettings.Settings['UseTranquilityTree'];
				v87 = EpicSettings.Settings['TranquilityTreeHP'] or (0 - 0);
				v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (1901 - (484 + 1417));
				v164 = 10 - 5;
			end
			if (((3640 - 1467) > (1152 - (48 + 725))) and ((2 - 0) == v164)) then
				v77 = EpicSettings.Settings['UseRegrowthRefresh'];
				v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
				v79 = EpicSettings.Settings['UseRejuvenation'];
				v80 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
				v164 = 7 - 4;
			end
			if ((v164 == (2 + 5)) or ((756 + 1835) == (4262 - (152 + 701)))) then
				v97 = EpicSettings.Settings['RenewalHP'] or (1311 - (430 + 881));
				v98 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((1729 + 2785) > (4219 - (557 + 338))) and (v164 == (0 + 0))) then
				v69 = EpicSettings.Settings['UseLifebloomTank'];
				v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
				v71 = EpicSettings.Settings['UseLifebloom'];
				v72 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
				v164 = 2 - 1;
			end
			if ((v164 == (10 - 5)) or ((1009 - (499 + 302)) >= (5694 - (39 + 827)))) then
				v89 = EpicSettings.Settings['UseWildgrowthSotF'];
				v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
				v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
				v92 = EpicSettings.Settings['UseWildgrowth'];
				v164 = 23 - 17;
			end
			if (((8 - 2) == v164) or ((136 + 1447) > (10440 - 6873))) then
				v93 = EpicSettings.Settings['WildgrowthHP'] or (0 + 0);
				v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v95 = EpicSettings.Settings['BarkskinHP'] or (104 - (103 + 1));
				v96 = EpicSettings.Settings['UseBarkskin'];
				v164 = 561 - (475 + 79);
			end
			if (((2 - 1) == v164) or ((4201 - 2888) == (103 + 691))) then
				v73 = EpicSettings.Settings['UseNaturesSwiftness'];
				v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 + 0);
				v75 = EpicSettings.Settings['UseRegrowth'];
				v76 = EpicSettings.Settings['RegrowthHP'] or (1503 - (1395 + 108));
				v164 = 5 - 3;
			end
		end
	end
	local function v144()
		local v165 = 1204 - (7 + 1197);
		while true do
			if (((1384 + 1790) > (1013 + 1889)) and (v165 == (323 - (27 + 292)))) then
				if (((12073 - 7953) <= (5432 - 1172)) and (v99.TargetIsValid() or v13:AffectingCombat())) then
					local v225 = 0 - 0;
					while true do
						if ((v225 == (0 - 0)) or ((1681 - 798) > (4917 - (43 + 96)))) then
							v107 = v9.BossFightRemains(nil, true);
							v108 = v107;
							v225 = 4 - 3;
						end
						if (((1 - 0) == v225) or ((3004 + 616) >= (1382 + 3509))) then
							if (((8415 - 4157) > (360 + 577)) and (v108 == (20822 - 9711))) then
								v108 = v9.FightRemains(v105, false);
							end
							break;
						end
					end
				end
				if (v47 or ((1533 + 3336) < (67 + 839))) then
					local v226 = 1751 - (1414 + 337);
					local v227;
					while true do
						if (((1943 - (1642 + 298)) == v226) or ((3193 - 1968) > (12163 - 7935))) then
							v227 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 118 - 78, true);
							if (((1096 + 2232) > (1742 + 496)) and v227) then
								return v227;
							end
							break;
						end
						if (((4811 - (357 + 615)) > (987 + 418)) and ((2 - 1) == v226)) then
							v227 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 35 + 5, true);
							if (v227 or ((2770 - 1477) <= (406 + 101))) then
								return v227;
							end
							v226 = 1 + 1;
						end
						if (((0 + 0) == v226) or ((4197 - (384 + 917)) < (1502 - (128 + 569)))) then
							v227 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 1583 - (1407 + 136));
							if (((4203 - (687 + 1200)) == (4026 - (556 + 1154))) and v227) then
								return v227;
							end
							v226 = 3 - 2;
						end
						if (((97 - (9 + 86)) == v226) or ((2991 - (275 + 146)) == (250 + 1283))) then
							v227 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 104 - (29 + 35));
							if (v227 or ((3913 - 3030) == (4360 - 2900))) then
								return v227;
							end
							v226 = 13 - 10;
						end
					end
				end
				if (v48 or ((3009 + 1610) <= (2011 - (53 + 959)))) then
					local v228 = 408 - (312 + 96);
					local v229;
					while true do
						if ((v228 == (1 - 0)) or ((3695 - (147 + 138)) > (5015 - (813 + 86)))) then
							v229 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 37 + 3, true);
							if (v229 or ((1672 - 769) >= (3551 - (18 + 474)))) then
								return v229;
							end
							v228 = 1 + 1;
						end
						if ((v228 == (6 - 4)) or ((5062 - (860 + 226)) < (3160 - (121 + 182)))) then
							v229 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 5 + 35);
							if (((6170 - (988 + 252)) > (261 + 2046)) and v229) then
								return v229;
							end
							v228 = 1 + 2;
						end
						if ((v228 == (1973 - (49 + 1921))) or ((4936 - (223 + 667)) < (1343 - (51 + 1)))) then
							v229 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 68 - 28, true);
							if (v229 or ((9081 - 4840) == (4670 - (146 + 979)))) then
								return v229;
							end
							break;
						end
						if ((v228 == (0 + 0)) or ((4653 - (311 + 294)) > (11801 - 7569))) then
							v229 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 17 + 23);
							if (v229 or ((3193 - (496 + 947)) >= (4831 - (1233 + 125)))) then
								return v229;
							end
							v228 = 1 + 0;
						end
					end
				end
				if (((2841 + 325) == (602 + 2564)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) then
					local v230 = 1645 - (963 + 682);
					local v231;
					while true do
						if (((1472 + 291) < (5228 - (504 + 1000))) and (v230 == (0 + 0))) then
							v231 = v99.DeadFriendlyUnitsCount();
							if (((52 + 5) <= (257 + 2466)) and v13:AffectingCombat()) then
								if (v100.Rebirth:IsReady() or ((3052 - 982) == (379 + 64))) then
									if (v24(v100.Rebirth, nil, true) or ((1574 + 1131) == (1575 - (156 + 26)))) then
										return "rebirth";
									end
								end
							elseif ((v231 > (1 + 0)) or ((7198 - 2597) < (225 - (149 + 15)))) then
								if (v24(v100.Revitalize, nil, true) or ((2350 - (890 + 70)) >= (4861 - (39 + 78)))) then
									return "revitalize";
								end
							elseif (v24(v100.Revive, not v15:IsInRange(522 - (14 + 468)), true) or ((4404 - 2401) > (10716 - 6882))) then
								return "revive";
							end
							break;
						end
					end
				end
				v165 = 3 + 2;
			end
			if ((v165 == (0 + 0)) or ((34 + 122) > (1768 + 2145))) then
				v142();
				v143();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v165 = 1 + 0;
			end
			if (((373 - 178) == (193 + 2)) and (v165 == (10 - 7))) then
				if (((79 + 3026) >= (1847 - (12 + 39))) and v13:IsMounted()) then
					return;
				end
				if (((4074 + 305) >= (6596 - 4465)) and v13:IsMoving()) then
					v104 = GetTime();
				end
				if (((13690 - 9846) >= (606 + 1437)) and (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm))) then
					if (((GetTime() - v104) < (1 + 0)) or ((8195 - 4963) <= (1819 + 912))) then
						return;
					end
				end
				if (((23704 - 18799) == (6615 - (1596 + 114))) and v30) then
					v105 = v15:GetEnemiesInSplashRange(20 - 12);
					v106 = #v105;
				else
					local v232 = 713 - (164 + 549);
					while true do
						if ((v232 == (1438 - (1059 + 379))) or ((5135 - 999) >= (2287 + 2124))) then
							v105 = {};
							v106 = 1 + 0;
							break;
						end
					end
				end
				v165 = 396 - (145 + 247);
			end
			if ((v165 == (5 + 0)) or ((1367 + 1591) == (11909 - 7892))) then
				if (((236 + 992) >= (701 + 112)) and v36 and (v13:AffectingCombat() or v29)) then
					local v233 = 0 - 0;
					local v234;
					while true do
						if ((v233 == (721 - (254 + 466))) or ((4015 - (544 + 16)) > (12871 - 8821))) then
							v234 = v139();
							if (((871 - (294 + 334)) == (496 - (236 + 17))) and v234) then
								return v234;
							end
							break;
						end
						if ((v233 == (0 + 0)) or ((211 + 60) > (5920 - 4348))) then
							v234 = v138();
							if (((12967 - 10228) < (1696 + 1597)) and v234) then
								return v234;
							end
							v233 = 1 + 0;
						end
					end
				end
				if (not v13:IsChanneling() or ((4736 - (413 + 381)) < (48 + 1086))) then
					if (v13:AffectingCombat() or ((5727 - 3034) == (12917 - 7944))) then
						local v237 = 1970 - (582 + 1388);
						local v238;
						while true do
							if (((3655 - 1509) == (1537 + 609)) and (v237 == (364 - (326 + 38)))) then
								v238 = v140();
								if (v238 or ((6638 - 4394) == (4601 - 1377))) then
									return v238;
								end
								break;
							end
						end
					elseif (v29 or ((5524 - (47 + 573)) <= (676 + 1240))) then
						local v239 = 0 - 0;
						local v240;
						while true do
							if (((146 - 56) <= (2729 - (1269 + 395))) and (v239 == (492 - (76 + 416)))) then
								v240 = v141();
								if (((5245 - (319 + 124)) == (10976 - 6174)) and v240) then
									return v240;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v165 == (1008 - (564 + 443))) or ((6312 - 4032) <= (969 - (337 + 121)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['ramp'];
				v34 = EpicSettings.Toggles['dps'];
				v165 = 5 - 3;
			end
			if ((v165 == (6 - 4)) or ((3587 - (1261 + 650)) <= (196 + 267))) then
				v35 = EpicSettings.Toggles['dpsform'];
				v36 = EpicSettings.Toggles['healing'];
				if (((6165 - 2296) == (5686 - (772 + 1045))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (((164 + 994) <= (2757 - (102 + 42))) and (v13:AffectingCombat() or v43)) then
					local v235 = 1844 - (1524 + 320);
					local v236;
					while true do
						if ((v235 == (1270 - (1049 + 221))) or ((2520 - (18 + 138)) <= (4892 - 2893))) then
							v236 = v43 and v100.NaturesCure:IsReady() and v32;
							if ((v99.IsTankBelowHealthPercentage(v68, 1122 - (67 + 1035), v100.Regrowth) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) or ((5270 - (136 + 212)) < (824 - 630))) then
								local v241 = 0 + 0;
								local v242;
								while true do
									if ((v241 == (0 + 0)) or ((3695 - (240 + 1364)) < (1113 - (1050 + 32)))) then
										v242 = v99.FocusUnit(v236, nil, nil, "TANK", 142 - 102, v100.Regrowth);
										if (v242 or ((1438 + 992) >= (5927 - (331 + 724)))) then
											return v242;
										end
										break;
									end
								end
							elseif (((v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) or ((385 + 4385) < (2379 - (269 + 375)))) then
								local v243 = 725 - (267 + 458);
								local v244;
								while true do
									if ((v243 == (0 + 0)) or ((8536 - 4097) <= (3168 - (667 + 151)))) then
										v244 = v99.FocusUnit(v236, nil, nil, "HEALER", 1537 - (1410 + 87), v100.Regrowth);
										if (v244 or ((6376 - (1504 + 393)) < (12071 - 7605))) then
											return v244;
										end
										break;
									end
								end
							else
								local v245 = v99.FocusUnit(v236, nil, nil, nil, 103 - 63, v100.Regrowth);
								if (((3343 - (461 + 335)) > (157 + 1068)) and v245) then
									return v245;
								end
							end
							break;
						end
					end
				end
				v165 = 1764 - (1730 + 31);
			end
		end
	end
	local function v145()
		local v166 = 1667 - (728 + 939);
		while true do
			if (((16543 - 11872) > (5423 - 2749)) and (v166 == (2 - 1))) then
				v119();
				break;
			end
			if ((v166 == (1068 - (138 + 930))) or ((3378 + 318) < (2602 + 725))) then
				v22.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
				v166 = 1 + 0;
			end
		end
	end
	v22.SetAPL(428 - 323, v144, v145);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

