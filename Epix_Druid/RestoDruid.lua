local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((19085 - 14131) == (4331 - (1233 + 195)))) then
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
	local v107 = 3975 + 7136;
	local v108 = 4523 + 6588;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[11 + 2] and v20(v116[10 + 3])) or v20(0 + 0);
	local v118 = (v116[1447 - (797 + 636)] and v20(v116[67 - 53])) or v20(1619 - (1427 + 192));
	v9:RegisterForEvent(function()
		local v146 = 0 + 0;
		while true do
			if (((7159 - 4075) > (36 + 4)) and (v146 == (0 + 0))) then
				v116 = v13:GetEquipment();
				v117 = (v116[339 - (192 + 134)] and v20(v116[1289 - (316 + 960)])) or v20(0 + 0);
				v146 = 1 + 0;
			end
			if (((3154 + 258) > (3130 - 2311)) and (v146 == (552 - (83 + 468)))) then
				v118 = (v116[1820 - (1202 + 604)] and v20(v116[65 - 51])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v107 = 30763 - 19652;
		v108 = 11436 - (45 + 280);
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (((3052 + 110) <= (3007 + 434)) and v100.ImprovedNaturesCure:IsAvailable()) then
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
		return (v13:StealthUp(true, true) and (1.6 + 0)) or (1 + 0);
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		local v147 = 0 + 0;
		while true do
			if (((8714 - 4008) > (6340 - (340 + 1571))) and (v147 == (1 + 1))) then
				v113 = (not v109 and (((v100.Starfire:Count() == (1772 - (1733 + 39))) and (v100.Wrath:Count() > (0 - 0))) or v13:IsCasting(v100.Wrath))) or v112;
				v114 = (not v109 and (((v100.Wrath:Count() == (1034 - (125 + 909))) and (v100.Starfire:Count() > (1948 - (1096 + 852)))) or v13:IsCasting(v100.Starfire))) or v111;
				v147 = 2 + 1;
			end
			if (((4075 - 1221) < (3972 + 123)) and (v147 == (512 - (409 + 103)))) then
				v109 = v13:BuffUp(v100.EclipseSolar) or v13:BuffUp(v100.EclipseLunar);
				v110 = v13:BuffUp(v100.EclipseSolar) and v13:BuffUp(v100.EclipseLunar);
				v147 = 237 - (46 + 190);
			end
			if ((v147 == (98 - (51 + 44))) or ((299 + 759) >= (2519 - (1114 + 203)))) then
				v115 = not v109 and (v100.Wrath:Count() > (726 - (228 + 498))) and (v100.Starfire:Count() > (0 + 0));
				break;
			end
			if (((2051 + 1660) > (4018 - (174 + 489))) and ((2 - 1) == v147)) then
				v111 = v13:BuffUp(v100.EclipseLunar) and v13:BuffDown(v100.EclipseSolar);
				v112 = v13:BuffUp(v100.EclipseSolar) and v13:BuffDown(v100.EclipseLunar);
				v147 = 1907 - (830 + 1075);
			end
		end
	end
	local function v122(v148)
		return v148:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (529 - (303 + 221)));
	end
	local function v123(v149)
		return (v149:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (1281 - (231 + 1038))) and ((((v106 <= (4 + 0)) or (v13:Energy() < (1212 - (171 + 991)))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (16 - 12)) or (v13:Energy() < (134 - 84))) and v13:BuffUp(v100.HeartOfTheWild))) and v149:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(2 - 1, v100.Sunfire) and ((v149:DebuffUp(v100.MoonfireDebuff) and (v149:DebuffRemains(v100.MoonfireDebuff) < (v149:DebuffDuration(v100.MoonfireDebuff) * (0.8 + 0)))) or v149:DebuffDown(v100.MoonfireDebuff)) and (v106 == (3 - 2)));
	end
	local function v124(v150)
		return v150:DebuffRefreshable(v100.MoonfireDebuff) and (v150:TimeToDie() > (14 - 9));
	end
	local function v125(v151)
		return ((v151:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (145 - 55)) and (v151:DebuffRemains(v100.Rip) <= (30 - 20)))) and (((v13:ComboPoints() == (1253 - (111 + 1137))) and (v151:TimeToDie() > (v151:DebuffRemains(v100.Rip) + (182 - (91 + 67))))) or (((v151:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (11 - 7))) < v151:TimeToDie()) and ((v151:DebuffRemains(v100.Rip) + 1 + 3 + (v13:ComboPoints() * (527 - (423 + 100)))) > v151:TimeToDie())))) or (v151:DebuffDown(v100.Rip) and (v13:ComboPoints() > (1 + 1 + (v106 * (5 - 3)))));
	end
	local function v126(v152)
		return (v152:DebuffDown(v100.RakeDebuff) or v152:DebuffRefreshable(v100.RakeDebuff)) and (v152:TimeToDie() > (6 + 4)) and (v13:ComboPoints() < (776 - (326 + 445)));
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
		local v155 = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 174 - 134, nil);
		if (v155 or ((2017 - 1111) >= (5202 - 2973))) then
			return v155;
		end
		local v155 = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 751 - (530 + 181), nil);
		if (((2169 - (614 + 267)) > (1283 - (19 + 13))) and v155) then
			return v155;
		end
	end
	local function v132()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (4 - 2)) or ((12891 - 8378) < (871 + 2481))) then
				if ((v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (8 - 3))) or ((4282 - 2217) >= (5008 - (1293 + 519)))) then
					if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((8928 - 4552) <= (3866 - 2385))) then
						return "sunfire cat 24";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (9 - 4))) or ((14626 - 11234) >= (11168 - 6427))) then
					if (((1762 + 1563) >= (440 + 1714)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
						return "moonfire cat 24";
					end
				end
				if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((3008 - 1713) >= (748 + 2485))) then
					if (((1455 + 2922) > (1027 + 615)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				v156 = 1099 - (709 + 387);
			end
			if (((6581 - (673 + 1185)) > (3932 - 2576)) and (v156 == (16 - 11))) then
				if ((v100.Rake:IsReady() and ((v13:ComboPoints() < (8 - 3)) or (v13:Energy() > (65 + 25))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) or ((3091 + 1045) <= (4634 - 1201))) then
					if (((1043 + 3202) <= (9233 - 4602)) and v24(v100.Rake, not v15:IsInMeleeRange(9 - 4))) then
						return "rake cat 40";
					end
				end
				if (((6156 - (446 + 1434)) >= (5197 - (1040 + 243))) and v100.Swipe:IsReady() and (v106 >= (5 - 3))) then
					if (((2045 - (559 + 1288)) <= (6296 - (609 + 1322))) and v24(v100.Swipe, not v15:IsInMeleeRange(462 - (13 + 441)))) then
						return "swipe cat 38";
					end
				end
				if (((17869 - 13087) > (12248 - 7572)) and v100.Shred:IsReady() and ((v13:ComboPoints() < (24 - 19)) or (v13:Energy() > (4 + 86)))) then
					if (((17664 - 12800) > (781 + 1416)) and v24(v100.Shred, not v15:IsInMeleeRange(3 + 2))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if ((v156 == (11 - 7)) or ((2025 + 1675) == (4610 - 2103))) then
				if (((2958 + 1516) >= (153 + 121)) and v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (8 + 3)) and v125(v15)) then
					if (v24(v100.Rip, not v15:IsInMeleeRange(5 + 0)) or ((1854 + 40) <= (1839 - (153 + 280)))) then
						return "rip cat 34";
					end
				end
				if (((4538 - 2966) >= (1375 + 156)) and v100.Thrash:IsReady() and (v106 >= (1 + 1)) and v15:DebuffRefreshable(v100.ThrashDebuff)) then
					if (v24(v100.Thrash, not v15:IsInMeleeRange(5 + 3)) or ((4254 + 433) < (3292 + 1250))) then
						return "thrash cat";
					end
				end
				if (((5010 - 1719) > (1031 + 636)) and v100.Rake:IsReady() and v126(v15)) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(672 - (89 + 578))) or ((624 + 249) == (4228 - 2194))) then
						return "rake cat 36";
					end
				end
				v156 = 1054 - (572 + 477);
			end
			if ((v156 == (0 + 0)) or ((1690 + 1126) < (2 + 9))) then
				if (((3785 - (84 + 2)) < (7755 - 3049)) and v100.Rake:IsReady() and (v13:StealthUp(false, true))) then
					if (((1907 + 739) >= (1718 - (497 + 345))) and v24(v100.Rake, not v15:IsInMeleeRange(1 + 9))) then
						return "rake cat 2";
					end
				end
				if (((104 + 510) <= (4517 - (605 + 728))) and v38 and not v13:StealthUp(false, true)) then
					local v212 = v131();
					if (((2231 + 895) == (6949 - 3823)) and v212) then
						return v212;
					end
				end
				if (v100.AdaptiveSwarm:IsCastable() or ((101 + 2086) >= (18316 - 13362))) then
					if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((3496 + 381) == (9904 - 6329))) then
						return "adaptive_swarm cat";
					end
				end
				v156 = 1 + 0;
			end
			if (((1196 - (457 + 32)) > (269 + 363)) and (v156 == (1405 - (832 + 570)))) then
				if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (29 + 1)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (2 + 2)))) or ((1932 - 1386) >= (1293 + 1391))) then
					if (((2261 - (588 + 208)) <= (11592 - 7291)) and v24(v100.HeartOfTheWild)) then
						return "heart_of_the_wild cat 26";
					end
				end
				if (((3504 - (884 + 916)) > (2983 - 1558)) and v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (18 + 12)) and v35) then
					if (v24(v100.CatForm) or ((1340 - (232 + 421)) == (6123 - (1569 + 320)))) then
						return "cat_form cat 28";
					end
				end
				if ((v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (1 + 2)) and (v15:TimeToDie() < (2 + 8))) or ((v13:ComboPoints() == (16 - 11)) and (v13:Energy() >= (630 - (316 + 289))) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (13 - 8)))))) or ((154 + 3176) < (2882 - (666 + 787)))) then
					if (((1572 - (360 + 65)) >= (314 + 21)) and v24(v100.FerociousBite, not v15:IsInMeleeRange(259 - (79 + 175)))) then
						return "ferocious_bite cat 32";
					end
				end
				v156 = 5 - 1;
			end
			if (((2681 + 754) > (6427 - 4330)) and (v156 == (1 - 0))) then
				if ((v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) or ((4669 - (503 + 396)) >= (4222 - (92 + 89)))) then
					if (v13:BuffUp(v100.CatForm) or ((7354 - 3563) <= (827 + 784))) then
						if (((v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (36 + 24)) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (195 - 145)) and (((v13:ComboPoints() < (1 + 4)) and (v15:DebuffRemains(v100.Rip) > (11 - 6))) or (v106 > (1 + 0)))) or ((2187 + 2391) <= (6115 - 4107))) then
							if (((141 + 984) <= (3165 - 1089)) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(1274 - (485 + 759)))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if ((v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (11 - 6)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (1219 - (442 + 747))))) or ((1878 - (832 + 303)) >= (5345 - (88 + 858)))) then
					if (((353 + 802) < (1385 + 288)) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
						return "sunfire cat 20";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (1 + 4)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (819 - (766 + 23))))) or ((11472 - 9148) <= (790 - 212))) then
					if (((9924 - 6157) == (12785 - 9018)) and v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
						return "moonfire cat 22";
					end
				end
				v156 = 1075 - (1036 + 37);
			end
		end
	end
	local function v133()
		if (((2900 + 1189) == (7962 - 3873)) and v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (24 + 6)) or (v100.ConvokeTheSpirits:CooldownRemains() > (1570 - (641 + 839))) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) then
			if (((5371 - (910 + 3)) >= (4267 - 2593)) and v24(v100.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if (((2656 - (1466 + 218)) <= (652 + 766)) and v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) then
			if (v24(v100.MoonkinForm) or ((6086 - (556 + 592)) < (1694 + 3068))) then
				return "moonkin_form owl 4";
			end
		end
		if ((v100.Starsurge:IsReady() and ((v106 < (814 - (329 + 479))) or (not v111 and (v106 < (862 - (174 + 680))))) and v35) or ((8603 - 6099) > (8838 - 4574))) then
			if (((1538 + 615) == (2892 - (396 + 343))) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
				return "starsurge owl 8";
			end
		end
		if ((v100.Moonfire:IsReady() and ((v106 < (1 + 4)) or (not v111 and (v106 < (1484 - (29 + 1448)))))) or ((1896 - (135 + 1254)) >= (9760 - 7169))) then
			if (((20922 - 16441) == (2987 + 1494)) and v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
				return "moonfire owl 10";
			end
		end
		if (v100.Sunfire:IsReady() or ((3855 - (389 + 1138)) < (1267 - (102 + 472)))) then
			if (((4085 + 243) == (2401 + 1927)) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if (((1481 + 107) >= (2877 - (320 + 1225))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
			if (v13:BuffUp(v100.MoonkinForm) or ((7430 - 3256) > (2600 + 1648))) then
				if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(1494 - (157 + 1307))) or ((6445 - (821 + 1038)) <= (204 - 122))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if (((423 + 3440) == (6861 - 2998)) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(3 + 5)) and ((v112 and (v106 == (2 - 1))) or v113 or (v115 and (v106 > (1027 - (834 + 192)))))) then
			if (v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true) or ((18 + 264) <= (11 + 31))) then
				return "wrath owl 14";
			end
		end
		if (((99 + 4510) >= (1186 - 420)) and v100.Starfire:IsReady()) then
			if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((1456 - (300 + 4)) == (665 + 1823))) then
				return "starfire owl 16";
			end
		end
	end
	local function v134()
		local v157 = v99.InterruptWithStun(v100.IncapacitatingRoar, 20 - 12);
		if (((3784 - (112 + 250)) > (1336 + 2014)) and v157) then
			return v157;
		end
		if (((2196 - 1319) > (216 + 160)) and v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 + 0))) then
			local v196 = 0 + 0;
			while true do
				if ((v196 == (0 + 0)) or ((2317 + 801) <= (3265 - (1001 + 413)))) then
					v157 = v99.InterruptWithStun(v100.Maim, 17 - 9);
					if (v157 or ((1047 - (244 + 638)) >= (4185 - (627 + 66)))) then
						return v157;
					end
					break;
				end
			end
		end
		v157 = v99.InterruptWithStun(v100.MightyBash, 23 - 15);
		if (((4551 - (512 + 90)) < (6762 - (1665 + 241))) and v157) then
			return v157;
		end
		v121();
		local v158 = 717 - (373 + 344);
		if (v100.Rip:IsAvailable() or ((1929 + 2347) < (799 + 2217))) then
			v158 = v158 + (2 - 1);
		end
		if (((7936 - 3246) > (5224 - (35 + 1064))) and v100.Rake:IsAvailable()) then
			v158 = v158 + 1 + 0;
		end
		if (v100.Thrash:IsAvailable() or ((106 - 56) >= (4 + 892))) then
			v158 = v158 + (1237 - (298 + 938));
		end
		if (((v158 >= (1261 - (233 + 1026))) and v15:IsInMeleeRange(1674 - (636 + 1030))) or ((877 + 837) >= (2890 + 68))) then
			local v197 = 0 + 0;
			local v198;
			while true do
				if ((v197 == (0 + 0)) or ((1712 - (55 + 166)) < (125 + 519))) then
					v198 = v132();
					if (((71 + 633) < (3769 - 2782)) and v198) then
						return v198;
					end
					break;
				end
			end
		end
		if (((4015 - (36 + 261)) > (3332 - 1426)) and v100.AdaptiveSwarm:IsCastable()) then
			if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((2326 - (34 + 1334)) > (1398 + 2237))) then
				return "adaptive_swarm main";
			end
		end
		if (((2721 + 780) <= (5775 - (1035 + 248))) and v100.MoonkinForm:IsAvailable()) then
			local v199 = v133();
			if (v199 or ((3463 - (20 + 1)) < (1328 + 1220))) then
				return v199;
			end
		end
		if (((3194 - (134 + 185)) >= (2597 - (549 + 584))) and v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) then
			if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((5482 - (314 + 371)) >= (16797 - 11904))) then
				return "sunfire main 24";
			end
		end
		if ((v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) or ((1519 - (478 + 490)) > (1096 + 972))) then
			if (((3286 - (786 + 386)) > (3057 - 2113)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 26";
			end
		end
		if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((3641 - (1055 + 324)) >= (4436 - (1093 + 247)))) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((2004 + 251) >= (372 + 3165))) then
				return "starsurge main 28";
			end
		end
		if ((v100.Starfire:IsReady() and (v106 > (7 - 5))) or ((13021 - 9184) < (3716 - 2410))) then
			if (((7413 - 4463) == (1050 + 1900)) and v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true)) then
				return "starfire owl 16";
			end
		end
		if ((v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(30 - 22))) or ((16278 - 11555) < (2487 + 811))) then
			if (((2905 - 1769) >= (842 - (364 + 324))) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
				return "wrath main 30";
			end
		end
		if ((v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(21 - 13))) or ((650 - 379) > (1574 + 3174))) then
			if (((19833 - 15093) >= (5047 - 1895)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (true or ((7829 - 5251) >= (4658 - (1249 + 19)))) then
			if (((38 + 3) <= (6465 - 4804)) and v24(v100.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local v135 = 1086 - (686 + 400);
	local function v136()
		if (((472 + 129) < (3789 - (73 + 156))) and v16 and v99.DispellableFriendlyUnit(1 + 19) and v100.NaturesCure:IsReady()) then
			local v200 = 811 - (721 + 90);
			while true do
				if (((3 + 232) < (2230 - 1543)) and (v200 == (470 - (224 + 246)))) then
					if (((7368 - 2819) > (2122 - 969)) and (v135 == (0 + 0))) then
						v135 = GetTime();
					end
					if (v99.Wait(12 + 488, v135) or ((3433 + 1241) < (9288 - 4616))) then
						if (((12206 - 8538) < (5074 - (203 + 310))) and v24(v103.NaturesCureFocus)) then
							return "natures_cure dispel 2";
						end
						v135 = 1993 - (1238 + 755);
					end
					break;
				end
			end
		end
	end
	local function v137()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (1534 - (709 + 825))) or ((838 - 383) == (5250 - 1645))) then
				if (((v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) or ((3527 - (196 + 668)) == (13076 - 9764))) then
					if (((8859 - 4582) <= (5308 - (171 + 662))) and v24(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) or ((963 - (4 + 89)) == (4167 - 2978))) then
					if (((566 + 987) <= (13760 - 10627)) and v24(v100.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v159 = 1 + 0;
			end
			if ((v159 == (1487 - (35 + 1451))) or ((3690 - (28 + 1425)) >= (5504 - (941 + 1052)))) then
				if ((v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) or ((1270 + 54) > (4534 - (822 + 692)))) then
					if (v24(v103.Healthstone, nil, nil, true) or ((4271 - 1279) == (886 + 995))) then
						return "healthstone defensive 3";
					end
				end
				if (((3403 - (45 + 252)) > (1510 + 16)) and v39 and (v13:HealthPercentage() <= v41)) then
					if (((1041 + 1982) < (9418 - 5548)) and (v40 == "Refreshing Healing Potion")) then
						if (((576 - (114 + 319)) > (106 - 32)) and v101.RefreshingHealingPotion:IsReady()) then
							if (((22 - 4) < (1347 + 765)) and v24(v103.RefreshingHealingPotion, nil, nil, true)) then
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
		if (((1633 - 536) <= (3410 - 1782)) and v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) then
			if (((6593 - (556 + 1407)) == (5836 - (741 + 465))) and v24(v103.RejuvenationFocus)) then
				return "rejuvenation ramp";
			end
		end
		if (((4005 - (170 + 295)) > (1414 + 1269)) and v100.Swiftmend:IsReady() and v130(v16)) then
			if (((4404 + 390) >= (8063 - 4788)) and v24(v103.SwiftmendFocus)) then
				return "swiftmend ramp";
			end
		end
		if (((1231 + 253) == (952 + 532)) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) then
			if (((811 + 621) < (4785 - (957 + 273))) and v24(v103.WildgrowthFocus, nil, true)) then
				return "wildgrowth ramp";
			end
		end
		if ((v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) or ((285 + 780) > (1433 + 2145))) then
			if (v24(v103.InnervatePlayer, nil, nil, true) or ((18271 - 13476) < (3707 - 2300))) then
				return "innervate ramp";
			end
		end
		if (((5659 - 3806) < (23832 - 19019)) and v13:BuffUp(v100.Innervate) and (v129() > (1780 - (389 + 1391))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) then
			if (v24(v103.RejuvenationMouseover) or ((1770 + 1051) < (254 + 2177))) then
				return "rejuvenation_cycle ramp";
			end
		end
	end
	local function v139()
		if (v36 or ((6542 - 3668) < (3132 - (783 + 168)))) then
			if (v38 or ((9024 - 6335) <= (338 + 5))) then
				local v211 = v131();
				if (v211 or ((2180 - (309 + 2)) == (6169 - 4160))) then
					return v211;
				end
			end
			if ((v53 and v31 and v13:AffectingCombat() and (v128() > (1215 - (1090 + 122))) and v100.NaturesVigil:IsReady()) or ((1150 + 2396) < (7798 - 5476))) then
				if (v24(v100.NaturesVigil, nil, nil, true) or ((1425 + 657) == (5891 - (628 + 490)))) then
					return "natures_vigil healing";
				end
			end
			if (((582 + 2662) > (2612 - 1557)) and v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) then
				if (v24(v103.SwiftmendFocus) or ((15140 - 11827) <= (2552 - (431 + 343)))) then
					return "swiftmend healing";
				end
			end
			if ((v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91, v100.Regrowth)) or ((2869 - 1448) >= (6086 - 3982))) then
				if (((1432 + 380) <= (416 + 2833)) and v24(v103.WildgrowthFocus, nil, true)) then
					return "wildgrowth_sotf healing";
				end
			end
			if (((3318 - (556 + 1139)) <= (1972 - (6 + 9))) and v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (1 + 4)) and v99.AreUnitsBelowHealthPercentage(v57, v58, v100.Regrowth)) then
				if (((2261 + 2151) == (4581 - (28 + 141))) and v24(v103.GroveGuardiansFocus, nil, nil)) then
					return "grove_guardians healing";
				end
			end
			if (((678 + 1072) >= (1038 - 196)) and v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (3 + 1)) and v99.AreUnitsBelowHealthPercentage(v65, v66, v100.Regrowth)) then
				if (((5689 - (486 + 831)) > (4814 - 2964)) and v24(v100.Flourish, nil, nil, true)) then
					return "flourish healing";
				end
			end
			if (((816 - 584) < (156 + 665)) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85, v100.Regrowth)) then
				if (((1637 - 1119) < (2165 - (668 + 595))) and v24(v100.Tranquility, nil, true)) then
					return "tranquility healing";
				end
			end
			if (((2695 + 299) > (173 + 685)) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88, v100.Regrowth)) then
				if (v24(v100.Tranquility, nil, true) or ((10240 - 6485) <= (1205 - (23 + 267)))) then
					return "tranquility_tree healing";
				end
			end
			if (((5890 - (1129 + 815)) > (4130 - (371 + 16))) and v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63, v100.Regrowth)) then
				if (v24(v100.ConvokeTheSpirits) or ((3085 - (1326 + 424)) >= (6260 - 2954))) then
					return "convoke_the_spirits healing";
				end
			end
			if (((17701 - 12857) > (2371 - (88 + 30))) and v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) then
				if (((1223 - (720 + 51)) == (1005 - 553)) and v24(v103.CenarionWardFocus)) then
					return "cenarion_ward healing";
				end
			end
			if ((v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) or ((6333 - (421 + 1355)) < (3442 - 1355))) then
				if (((1903 + 1971) == (4957 - (286 + 797))) and v24(v103.RegrowthFocus)) then
					return "regrowth_swiftness healing";
				end
			end
			if ((v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) or ((7084 - 5146) > (8173 - 3238))) then
				if (v24(v100.NaturesSwiftness) or ((4694 - (397 + 42)) < (1070 + 2353))) then
					return "natures_swiftness healing";
				end
			end
			if (((2254 - (24 + 776)) <= (3837 - 1346)) and (v67 == "Anyone")) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) or ((4942 - (222 + 563)) <= (6175 - 3372))) then
					if (((3495 + 1358) >= (3172 - (23 + 167))) and v24(v103.IronBarkFocus)) then
						return "iron_bark healing";
					end
				end
			elseif (((5932 - (690 + 1108)) > (1212 + 2145)) and (v67 == "Tank Only")) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v99.UnitGroupRole(v16) == "TANK")) or ((2819 + 598) < (3382 - (40 + 808)))) then
					if (v24(v103.IronBarkFocus) or ((449 + 2273) <= (626 - 462))) then
						return "iron_bark healing";
					end
				end
			elseif ((v67 == "Tank and Self") or ((2302 + 106) < (1116 + 993))) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v99.UnitGroupRole(v16) == "TANK") or (v99.UnitGroupRole(v16) == "HEALER"))) or ((19 + 14) == (2026 - (47 + 524)))) then
					if (v24(v103.IronBarkFocus) or ((288 + 155) >= (10975 - 6960))) then
						return "iron_bark healing";
					end
				end
			end
			if (((5056 - 1674) > (378 - 212)) and v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) then
				if (v24(v103.AdaptiveSwarmFocus) or ((2006 - (1165 + 561)) == (91 + 2968))) then
					return "adaptive_swarm healing";
				end
			end
			if (((5825 - 3944) > (494 + 799)) and v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (480 - (341 + 138))) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (5 + 10)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
				if (((4863 - 2506) == (2683 - (89 + 237))) and v24(v103.LifebloomFocus)) then
					return "lifebloom healing";
				end
			end
			if (((395 - 272) == (258 - 135)) and v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (882 - (581 + 300))) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (1235 - (855 + 365))))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
				if (v24(v103.LifebloomFocus) or ((2507 - 1451) >= (1108 + 2284))) then
					return "lifebloom healing";
				end
			end
			if ((v54 == "Player") or ((2316 - (1030 + 205)) < (1010 + 65))) then
				if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (14 + 1))) or ((1335 - (156 + 130)) >= (10070 - 5638))) then
					if (v24(v103.EfflorescencePlayer) or ((8035 - 3267) <= (1732 - 886))) then
						return "efflorescence healing player";
					end
				end
			elseif ((v54 == "Cursor") or ((885 + 2473) <= (829 + 591))) then
				if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (84 - (10 + 59)))) or ((1058 + 2681) <= (14798 - 11793))) then
					if (v24(v103.EfflorescenceCursor) or ((2822 - (671 + 492)) >= (1699 + 435))) then
						return "efflorescence healing cursor";
					end
				end
			elseif ((v54 == "Confirmation") or ((4475 - (369 + 846)) < (624 + 1731))) then
				if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (13 + 2))) or ((2614 - (1036 + 909)) == (3358 + 865))) then
					if (v24(v100.Efflorescence) or ((2840 - 1148) < (791 - (11 + 192)))) then
						return "efflorescence healing confirmation";
					end
				end
			end
			if ((v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94, v100.Regrowth) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) or ((2425 + 2372) < (3826 - (135 + 40)))) then
				if (v24(v103.WildgrowthFocus, nil, true) or ((10120 - 5943) > (2924 + 1926))) then
					return "wildgrowth healing";
				end
			end
			if ((v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) or ((881 - 481) > (1665 - 554))) then
				if (((3227 - (50 + 126)) > (2798 - 1793)) and v24(v103.RegrowthFocus, nil, true)) then
					return "regrowth healing";
				end
			end
			if (((818 + 2875) <= (5795 - (1233 + 180))) and v13:BuffUp(v100.Innervate) and (v129() > (969 - (522 + 447))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) then
				if (v24(v103.RejuvenationMouseover) or ((4703 - (107 + 1314)) > (1903 + 2197))) then
					return "rejuvenation_cycle healing";
				end
			end
			if ((v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) or ((10908 - 7328) < (1208 + 1636))) then
				if (((176 - 87) < (17765 - 13275)) and v24(v103.RejuvenationFocus)) then
					return "rejuvenation healing";
				end
			end
			if ((v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) or ((6893 - (716 + 1194)) < (31 + 1777))) then
				if (((411 + 3418) > (4272 - (74 + 429))) and v24(v103.RegrowthFocus, nil, true)) then
					return "regrowth healing";
				end
			end
		end
	end
	local function v140()
		if (((2864 - 1379) <= (1440 + 1464)) and (v44 or v43) and v32) then
			local v201 = v136();
			if (((9771 - 5502) == (3021 + 1248)) and v201) then
				return v201;
			end
		end
		local v160 = v137();
		if (((1193 - 806) <= (6878 - 4096)) and v160) then
			return v160;
		end
		if (v33 or ((2332 - (279 + 154)) <= (1695 - (454 + 324)))) then
			local v202 = v138();
			if (v202 or ((3393 + 919) <= (893 - (12 + 5)))) then
				return v202;
			end
		end
		local v160 = v139();
		if (((1204 + 1028) <= (6614 - 4018)) and v160) then
			return v160;
		end
		if (((775 + 1320) < (4779 - (277 + 816))) and v99.TargetIsValid() and v34) then
			v160 = v134();
			if (v160 or ((6815 - 5220) >= (5657 - (1058 + 125)))) then
				return v160;
			end
		end
	end
	local function v141()
		local v161 = 0 + 0;
		while true do
			if ((v161 == (976 - (815 + 160))) or ((19818 - 15199) < (6841 - 3959))) then
				if ((v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) or ((71 + 223) >= (14121 - 9290))) then
					if (((3927 - (41 + 1857)) <= (4977 - (1222 + 671))) and v24(v103.MarkOfTheWildPlayer)) then
						return "mark_of_the_wild";
					end
				end
				if (v99.TargetIsValid() or ((5264 - 3227) == (3478 - 1058))) then
					if (((5640 - (229 + 953)) > (5678 - (1111 + 663))) and v100.Rake:IsReady() and (v13:StealthUp(false, true))) then
						if (((2015 - (874 + 705)) >= (18 + 105)) and v24(v100.Rake, not v15:IsInMeleeRange(7 + 3))) then
							return "rake";
						end
					end
				end
				v161 = 3 - 1;
			end
			if (((15 + 485) < (2495 - (642 + 37))) and (v161 == (0 + 0))) then
				if (((572 + 3002) == (8973 - 5399)) and (v44 or v43) and v32) then
					local v213 = v136();
					if (((675 - (233 + 221)) < (901 - 511)) and v213) then
						return v213;
					end
				end
				if ((v29 and v36) or ((1948 + 265) <= (2962 - (718 + 823)))) then
					local v214 = 0 + 0;
					local v215;
					while true do
						if (((3863 - (266 + 539)) < (13759 - 8899)) and (v214 == (1225 - (636 + 589)))) then
							v215 = v139();
							if (v215 or ((3076 - 1780) >= (9169 - 4723))) then
								return v215;
							end
							break;
						end
					end
				end
				v161 = 1 + 0;
			end
			if ((v161 == (1 + 1)) or ((2408 - (657 + 358)) > (11885 - 7396))) then
				if ((v99.TargetIsValid() and v34) or ((10078 - 5654) < (1214 - (1151 + 36)))) then
					local v216 = 0 + 0;
					local v217;
					while true do
						if ((v216 == (0 + 0)) or ((5963 - 3966) > (5647 - (1552 + 280)))) then
							v217 = v134();
							if (((4299 - (64 + 770)) > (1299 + 614)) and v217) then
								return v217;
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
		v37 = EpicSettings.Settings['UseRacials'];
		v38 = EpicSettings.Settings['UseTrinkets'];
		v39 = EpicSettings.Settings['UseHealingPotion'];
		v40 = EpicSettings.Settings['HealingPotionName'] or "";
		v41 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v42 = EpicSettings.Settings['UseMarkOfTheWild'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v44 = EpicSettings.Settings['DispelBuffs'];
		v45 = EpicSettings.Settings['UseHealthstone'];
		v46 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v47 = EpicSettings.Settings['HandleCharredTreant'];
		v48 = EpicSettings.Settings['HandleCharredBrambles'];
		v49 = EpicSettings.Settings['InterruptWithStun'];
		v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v51 = EpicSettings.Settings['InterruptThreshold'] or (1243 - (157 + 1086));
		v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v55 = EpicSettings.Settings['EfflorescenceHP'] or (0 - 0);
		v56 = EpicSettings.Settings['UseGroveGuardians'];
		v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 - 0);
		v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
		v59 = EpicSettings.Settings['UseCenarionWard'];
		v60 = EpicSettings.Settings['CenarionWardHP'] or (0 - 0);
		v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (819 - (599 + 220));
		v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
		v64 = EpicSettings.Settings['UseFlourish'];
		v65 = EpicSettings.Settings['FlourishHP'] or (1931 - (1813 + 118));
		v66 = EpicSettings.Settings['FlourishGroup'] or (0 + 0);
		v67 = EpicSettings.Settings['IronBarkUsage'] or "";
		v68 = EpicSettings.Settings['IronBarkHP'] or (1217 - (841 + 376));
	end
	local function v143()
		v69 = EpicSettings.Settings['UseLifebloomTank'];
		v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
		v71 = EpicSettings.Settings['UseLifebloom'];
		v72 = EpicSettings.Settings['LifebloomHP'] or (0 + 0);
		v73 = EpicSettings.Settings['UseNaturesSwiftness'];
		v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
		v75 = EpicSettings.Settings['UseRegrowth'];
		v76 = EpicSettings.Settings['RegrowthHP'] or (859 - (464 + 395));
		v77 = EpicSettings.Settings['UseRegrowthRefresh'];
		v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
		v79 = EpicSettings.Settings['UseRejuvenation'];
		v80 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
		v81 = EpicSettings.Settings['UseSwiftmend'];
		v82 = EpicSettings.Settings['SwiftmendHP'] or (837 - (467 + 370));
		v83 = EpicSettings.Settings['UseTranquility'];
		v84 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v85 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
		v86 = EpicSettings.Settings['UseTranquilityTree'];
		v87 = EpicSettings.Settings['TranquilityTreeHP'] or (0 - 0);
		v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
		v89 = EpicSettings.Settings['UseWildgrowthSotF'];
		v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 - 0);
		v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (520 - (150 + 370));
		v92 = EpicSettings.Settings['UseWildgrowth'];
		v93 = EpicSettings.Settings['WildgrowthHP'] or (1282 - (74 + 1208));
		v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
		v95 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v96 = EpicSettings.Settings['UseBarkskin'];
		v97 = EpicSettings.Settings['RenewalHP'] or (0 + 0);
		v98 = EpicSettings.Settings['UseRenewal'];
	end
	local function v144()
		local v192 = 390 - (14 + 376);
		while true do
			if (((1270 - 537) < (1178 + 641)) and (v192 == (4 + 0))) then
				if (v99.TargetIsValid() or v13:AffectingCombat() or ((4192 + 203) == (13932 - 9177))) then
					local v218 = 0 + 0;
					while true do
						if (((78 - (23 + 55)) == v218) or ((8989 - 5196) < (1581 + 788))) then
							v107 = v9.BossFightRemains(nil, true);
							v108 = v107;
							v218 = 1 + 0;
						end
						if (((1 - 0) == v218) or ((1285 + 2799) == (1166 - (652 + 249)))) then
							if (((11662 - 7304) == (6226 - (708 + 1160))) and (v108 == (30160 - 19049))) then
								v108 = v9.FightRemains(v105, false);
							end
							break;
						end
					end
				end
				if (v47 or ((5721 - 2583) < (1020 - (10 + 17)))) then
					local v219 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 9 + 31);
					if (((5062 - (1400 + 332)) > (4455 - 2132)) and v219) then
						return v219;
					end
					local v219 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 1948 - (242 + 1666), true);
					if (v219 or ((1552 + 2074) == (1462 + 2527))) then
						return v219;
					end
					local v219 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 35 + 5);
					if (v219 or ((1856 - (850 + 90)) == (4677 - 2006))) then
						return v219;
					end
					local v219 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 1430 - (360 + 1030), true);
					if (((241 + 31) == (767 - 495)) and v219) then
						return v219;
					end
				end
				if (((5845 - 1596) <= (6500 - (909 + 752))) and v48) then
					local v220 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 1263 - (109 + 1114));
					if (((5083 - 2306) < (1246 + 1954)) and v220) then
						return v220;
					end
					local v220 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 282 - (6 + 236), true);
					if (((60 + 35) < (1576 + 381)) and v220) then
						return v220;
					end
					local v220 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 94 - 54);
					if (((1442 - 616) < (2850 - (1076 + 57))) and v220) then
						return v220;
					end
					local v220 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 7 + 33, true);
					if (((2115 - (579 + 110)) >= (88 + 1017)) and v220) then
						return v220;
					end
				end
				if (((2435 + 319) <= (1794 + 1585)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) then
					local v221 = 407 - (174 + 233);
					local v222;
					while true do
						if (((0 - 0) == v221) or ((6892 - 2965) == (629 + 784))) then
							v222 = v99.DeadFriendlyUnitsCount();
							if (v13:AffectingCombat() or ((2328 - (663 + 511)) <= (703 + 85))) then
								if (v100.Rebirth:IsReady() or ((357 + 1286) > (10417 - 7038))) then
									if (v24(v100.Rebirth, nil, true) or ((1698 + 1105) > (10709 - 6160))) then
										return "rebirth";
									end
								end
							elseif ((v222 > (2 - 1)) or ((105 + 115) >= (5881 - 2859))) then
								if (((2012 + 810) == (258 + 2564)) and v24(v100.Revitalize, nil, true)) then
									return "revitalize";
								end
							elseif (v24(v100.Revive, not v15:IsInRange(762 - (478 + 244)), true) or ((1578 - (440 + 77)) == (845 + 1012))) then
								return "revive";
							end
							break;
						end
					end
				end
				v192 = 18 - 13;
			end
			if (((4316 - (655 + 901)) > (253 + 1111)) and (v192 == (0 + 0))) then
				v142();
				v143();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v192 = 1 + 0;
			end
			if ((v192 == (11 - 8)) or ((6347 - (695 + 750)) <= (12275 - 8680))) then
				if (v13:IsMounted() or ((5944 - 2092) == (1178 - 885))) then
					return;
				end
				if (v13:IsMoving() or ((1910 - (285 + 66)) == (10694 - 6106))) then
					v104 = GetTime();
				end
				if (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm) or ((5794 - (682 + 628)) == (128 + 660))) then
					if (((4867 - (176 + 123)) >= (1635 + 2272)) and ((GetTime() - v104) < (1 + 0))) then
						return;
					end
				end
				if (((1515 - (239 + 30)) < (944 + 2526)) and v30) then
					local v223 = 0 + 0;
					while true do
						if (((7199 - 3131) >= (3032 - 2060)) and (v223 == (315 - (306 + 9)))) then
							v105 = v15:GetEnemiesInSplashRange(27 - 19);
							v106 = #v105;
							break;
						end
					end
				else
					local v224 = 0 + 0;
					while true do
						if (((303 + 190) < (1874 + 2019)) and ((0 - 0) == v224)) then
							v105 = {};
							v106 = 1376 - (1140 + 235);
							break;
						end
					end
				end
				v192 = 3 + 1;
			end
			if ((v192 == (5 + 0)) or ((379 + 1094) >= (3384 - (33 + 19)))) then
				if ((v36 and (v13:AffectingCombat() or v29)) or ((1463 + 2588) <= (3467 - 2310))) then
					local v225 = v138();
					if (((267 + 337) < (5649 - 2768)) and v225) then
						return v225;
					end
					local v225 = v139();
					if (v225 or ((844 + 56) == (4066 - (586 + 103)))) then
						return v225;
					end
				end
				if (((406 + 4053) > (1819 - 1228)) and not v13:IsChanneling()) then
					if (((4886 - (1309 + 179)) >= (4323 - 1928)) and v13:AffectingCombat()) then
						local v228 = v140();
						if (v228 or ((951 + 1232) >= (7584 - 4760))) then
							return v228;
						end
					elseif (((1463 + 473) == (4113 - 2177)) and v29) then
						local v229 = v141();
						if (v229 or ((9628 - 4796) < (4922 - (295 + 314)))) then
							return v229;
						end
					end
				end
				break;
			end
			if (((10040 - 5952) > (5836 - (1300 + 662))) and (v192 == (3 - 2))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['ramp'];
				v34 = EpicSettings.Toggles['dps'];
				v192 = 1757 - (1178 + 577);
			end
			if (((2250 + 2082) == (12806 - 8474)) and (v192 == (1407 - (851 + 554)))) then
				v35 = EpicSettings.Toggles['dpsform'];
				v36 = EpicSettings.Toggles['healing'];
				if (((3537 + 462) >= (8042 - 5142)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v13:AffectingCombat() or v43 or ((5483 - 2958) > (4366 - (115 + 187)))) then
					local v226 = 0 + 0;
					local v227;
					while true do
						if (((4138 + 233) == (17224 - 12853)) and (v226 == (1161 - (160 + 1001)))) then
							v227 = v43 and v100.NaturesCure:IsReady() and v32;
							if ((v99.IsTankBelowHealthPercentage(v68) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) or ((233 + 33) > (3441 + 1545))) then
								local v230 = v99.FocusUnit(v227, nil, nil, "TANK", 40 - 20, v100.Regrowth);
								if (((2349 - (237 + 121)) >= (1822 - (525 + 372))) and v230) then
									return v230;
								end
							elseif (((862 - 407) < (6745 - 4692)) and (v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) then
								local v231 = v99.FocusUnit(v227, nil, nil, "HEALER", 162 - (96 + 46), v100.Regrowth);
								if (v231 or ((1603 - (643 + 134)) == (1752 + 3099))) then
									return v231;
								end
							else
								local v232 = 0 - 0;
								local v233;
								while true do
									if (((679 - 496) == (176 + 7)) and (v232 == (0 - 0))) then
										v233 = v99.FocusUnit(v227, nil, nil, nil, 40 - 20, v100.Regrowth);
										if (((1878 - (316 + 403)) <= (1189 + 599)) and v233) then
											return v233;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v192 = 8 - 5;
			end
		end
	end
	local function v145()
		v22.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v119();
	end
	v22.SetAPL(38 + 67, v144, v145);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

