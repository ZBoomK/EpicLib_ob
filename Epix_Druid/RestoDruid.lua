local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((4445 - (942 + 283)) == (454 + 910))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2150 - (709 + 387)) > (5250 - (673 + 1185)))) then
			v6 = v0[v4];
			if (not v6 or ((1960 - 1284) >= (5272 - 3630))) then
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
	local v105 = 0 + 0;
	local v106, v107;
	local v108 = 8303 + 2808;
	local v109 = 15001 - 3890;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = false;
	local v117 = v14:GetEquipment();
	local v118 = (v117[4 + 9] and v21(v117[25 - 12])) or v21(0 - 0);
	local v119 = (v117[1894 - (446 + 1434)] and v21(v117[1297 - (1040 + 243)])) or v21(0 - 0);
	v10:RegisterForEvent(function()
		local v146 = 1847 - (559 + 1288);
		while true do
			if (((6067 - (609 + 1322)) > (2851 - (13 + 441))) and (v146 == (0 - 0))) then
				v117 = v14:GetEquipment();
				v118 = (v117[33 - 20] and v21(v117[64 - 51])) or v21(0 + 0);
				v146 = 3 - 2;
			end
			if ((v146 == (1 + 0)) or ((1900 + 2434) == (12597 - 8352))) then
				v119 = (v117[8 + 6] and v21(v117[25 - 11])) or v21(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (0 + 0)) or ((3591 + 685) <= (2966 + 65))) then
				v108 = 11544 - (153 + 280);
				v109 = 32083 - 20972;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v120()
		if (v101.ImprovedNaturesCure:IsAvailable() or ((4294 + 488) <= (474 + 725))) then
			local v206 = 0 + 0;
			while true do
				if ((v206 == (0 + 0)) or ((3525 + 1339) < (2895 - 993))) then
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
		return (v14:StealthUp(true, true) and (1.6 + 0)) or (668 - (89 + 578));
	end
	v101.Rake:RegisterPMultiplier(v101.RakeDebuff, v121);
	local function v122()
		local v148 = 0 + 0;
		while true do
			if (((10059 - 5220) >= (4749 - (572 + 477))) and (v148 == (1 + 0))) then
				v112 = v14:BuffUp(v101.EclipseLunar) and v14:BuffDown(v101.EclipseSolar);
				v113 = v14:BuffUp(v101.EclipseSolar) and v14:BuffDown(v101.EclipseLunar);
				v148 = 2 + 0;
			end
			if ((v148 == (1 + 1)) or ((1161 - (84 + 2)) > (3160 - 1242))) then
				v114 = (not v110 and (((v101.Starfire:Count() == (0 + 0)) and (v101.Wrath:Count() > (842 - (497 + 345)))) or v14:IsCasting(v101.Wrath))) or v113;
				v115 = (not v110 and (((v101.Wrath:Count() == (0 + 0)) and (v101.Starfire:Count() > (0 + 0))) or v14:IsCasting(v101.Starfire))) or v112;
				v148 = 1336 - (605 + 728);
			end
			if (((283 + 113) <= (8456 - 4652)) and (v148 == (0 + 0))) then
				v110 = v14:BuffUp(v101.EclipseSolar) or v14:BuffUp(v101.EclipseLunar);
				v111 = v14:BuffUp(v101.EclipseSolar) and v14:BuffUp(v101.EclipseLunar);
				v148 = 3 - 2;
			end
			if ((v148 == (3 + 0)) or ((11550 - 7381) == (1652 + 535))) then
				v116 = not v110 and (v101.Wrath:Count() > (489 - (457 + 32))) and (v101.Starfire:Count() > (0 + 0));
				break;
			end
		end
	end
	local function v123(v149)
		return v149:DebuffRefreshable(v101.SunfireDebuff) and (v109 > (1407 - (832 + 570)));
	end
	local function v124(v150)
		return (v150:DebuffRefreshable(v101.MoonfireDebuff) and (v109 > (12 + 0)) and ((((v107 <= (2 + 2)) or (v14:Energy() < (176 - 126))) and v14:BuffDown(v101.HeartOfTheWild)) or (((v107 <= (2 + 2)) or (v14:Energy() < (846 - (588 + 208)))) and v14:BuffUp(v101.HeartOfTheWild))) and v150:DebuffDown(v101.MoonfireDebuff)) or (v14:PrevGCD(2 - 1, v101.Sunfire) and ((v150:DebuffUp(v101.MoonfireDebuff) and (v150:DebuffRemains(v101.MoonfireDebuff) < (v150:DebuffDuration(v101.MoonfireDebuff) * (1800.8 - (884 + 916))))) or v150:DebuffDown(v101.MoonfireDebuff)) and (v107 == (1 - 0)));
	end
	local function v125(v151)
		return v151:DebuffRefreshable(v101.MoonfireDebuff) and (v151:TimeToDie() > (3 + 2));
	end
	local function v126(v152)
		return ((v152:DebuffRefreshable(v101.Rip) or ((v14:Energy() > (743 - (232 + 421))) and (v152:DebuffRemains(v101.Rip) <= (1899 - (1569 + 320))))) and (((v14:ComboPoints() == (2 + 3)) and (v152:TimeToDie() > (v152:DebuffRemains(v101.Rip) + 5 + 19))) or (((v152:DebuffRemains(v101.Rip) + (v14:ComboPoints() * (13 - 9))) < v152:TimeToDie()) and ((v152:DebuffRemains(v101.Rip) + (609 - (316 + 289)) + (v14:ComboPoints() * (10 - 6))) > v152:TimeToDie())))) or (v152:DebuffDown(v101.Rip) and (v14:ComboPoints() > (1 + 1 + (v107 * (1455 - (666 + 787))))));
	end
	local function v127(v153)
		return (v153:DebuffDown(v101.RakeDebuff) or v153:DebuffRefreshable(v101.RakeDebuff)) and (v153:TimeToDie() > (435 - (360 + 65))) and (v14:ComboPoints() < (5 + 0));
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
		local v156 = v100.HandleTopTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 294 - (79 + 175), nil);
		if (((2216 - 810) == (1098 + 308)) and v156) then
			return v156;
		end
		local v156 = v100.HandleBottomTrinket(v103, v32 and (v14:BuffUp(v101.HeartOfTheWild) or v14:BuffUp(v101.IncarnationBuff)), 122 - 82, nil);
		if (((2948 - 1417) < (5170 - (503 + 396))) and v156) then
			return v156;
		end
	end
	local function v133()
		local v157 = 181 - (92 + 89);
		while true do
			if (((1231 - 596) == (326 + 309)) and ((2 + 1) == v157)) then
				if (((13209 - 9836) <= (487 + 3069)) and v101.Rip:IsAvailable() and v101.Rip:IsReady() and (v107 < (24 - 13)) and v126(v16)) then
					if (v25(v101.Rip, not v16:IsInMeleeRange(5 + 0)) or ((1572 + 1719) < (9989 - 6709))) then
						return "rip cat 34";
					end
				end
				if (((548 + 3838) >= (1331 - 458)) and v101.Thrash:IsReady() and (v107 >= (1246 - (485 + 759))) and v16:DebuffRefreshable(v101.ThrashDebuff)) then
					if (((2131 - 1210) <= (2291 - (442 + 747))) and v25(v101.Thrash, not v16:IsInMeleeRange(1143 - (832 + 303)))) then
						return "thrash cat";
					end
				end
				if (((5652 - (88 + 858)) >= (294 + 669)) and v101.Rake:IsReady() and v127(v16)) then
					if (v25(v101.Rake, not v16:IsInMeleeRange(5 + 0)) or ((40 + 920) <= (1665 - (766 + 23)))) then
						return "rake cat 36";
					end
				end
				if ((v101.Rake:IsReady() and ((v14:ComboPoints() < (24 - 19)) or (v14:Energy() > (123 - 33))) and (v16:PMultiplier(v101.Rake) <= v14:PMultiplier(v101.Rake)) and v128(v16)) or ((5443 - 3377) == (3163 - 2231))) then
					if (((5898 - (1036 + 37)) < (3434 + 1409)) and v25(v101.Rake, not v16:IsInMeleeRange(9 - 4))) then
						return "rake cat 40";
					end
				end
				v157 = 4 + 0;
			end
			if ((v157 == (1481 - (641 + 839))) or ((4790 - (910 + 3)) >= (11566 - 7029))) then
				if ((v101.Sunfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (1689 - (1466 + 218))) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (14 + 16)))) or ((5463 - (556 + 592)) < (614 + 1112))) then
					if (v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover) or ((4487 - (329 + 479)) < (1479 - (174 + 680)))) then
						return "sunfire cat 20";
					end
				end
				if ((v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and (v16:TimeToDie() > (17 - 12)) and (not v101.Rip:IsAvailable() or v16:DebuffUp(v101.Rip) or (v14:Energy() < (62 - 32)))) or ((3303 + 1322) < (1371 - (396 + 343)))) then
					if (v100.CastCycle(v101.Moonfire, v106, v124, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((8 + 75) > (3257 - (29 + 1448)))) then
						return "moonfire cat 22";
					end
				end
				if (((1935 - (135 + 1254)) <= (4057 - 2980)) and v101.Sunfire:IsReady() and v16:DebuffDown(v101.SunfireDebuff) and (v16:TimeToDie() > (23 - 18))) then
					if (v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire)) or ((664 + 332) > (5828 - (389 + 1138)))) then
						return "sunfire cat 24";
					end
				end
				if (((4644 - (102 + 472)) > (649 + 38)) and v101.Moonfire:IsReady() and v14:BuffDown(v101.CatForm) and v16:DebuffDown(v101.MoonfireDebuff) and (v16:TimeToDie() > (3 + 2))) then
					if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((612 + 44) >= (4875 - (320 + 1225)))) then
						return "moonfire cat 24";
					end
				end
				v157 = 2 - 0;
			end
			if (((3 + 1) == v157) or ((3956 - (157 + 1307)) <= (2194 - (821 + 1038)))) then
				if (((10783 - 6461) >= (281 + 2281)) and v101.Swipe:IsReady() and (v107 >= (3 - 1))) then
					if (v25(v101.Swipe, not v16:IsInMeleeRange(3 + 5)) or ((9014 - 5377) >= (4796 - (834 + 192)))) then
						return "swipe cat 38";
					end
				end
				if ((v101.Shred:IsReady() and ((v14:ComboPoints() < (1 + 4)) or (v14:Energy() > (24 + 66)))) or ((52 + 2327) > (7092 - 2514))) then
					if (v25(v101.Shred, not v16:IsInMeleeRange(309 - (300 + 4))) or ((129 + 354) > (1944 - 1201))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if (((2816 - (112 + 250)) > (231 + 347)) and (v157 == (4 - 2))) then
				if (((533 + 397) < (2306 + 2152)) and v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) then
					if (((496 + 166) <= (482 + 490)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				if (((3247 + 1123) == (5784 - (1001 + 413))) and v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (66 - 36)) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild) and v16:DebuffUp(v101.SunfireDebuff) and (v16:DebuffUp(v101.MoonfireDebuff) or (v107 > (886 - (244 + 638))))) then
					if (v25(v101.HeartOfTheWild) or ((5455 - (627 + 66)) <= (2565 - 1704))) then
						return "heart_of_the_wild cat 26";
					end
				end
				if ((v101.CatForm:IsReady() and v14:BuffDown(v101.CatForm) and (v14:Energy() >= (632 - (512 + 90))) and v36) or ((3318 - (1665 + 241)) == (4981 - (373 + 344)))) then
					if (v25(v101.CatForm) or ((1429 + 1739) < (570 + 1583))) then
						return "cat_form cat 28";
					end
				end
				if ((v101.FerociousBite:IsReady() and (((v14:ComboPoints() > (7 - 4)) and (v16:TimeToDie() < (16 - 6))) or ((v14:ComboPoints() == (1104 - (35 + 1064))) and (v14:Energy() >= (19 + 6)) and (not v101.Rip:IsAvailable() or (v16:DebuffRemains(v101.Rip) > (10 - 5)))))) or ((20 + 4956) < (2568 - (298 + 938)))) then
					if (((5887 - (233 + 1026)) == (6294 - (636 + 1030))) and v25(v101.FerociousBite, not v16:IsInMeleeRange(3 + 2))) then
						return "ferocious_bite cat 32";
					end
				end
				v157 = 3 + 0;
			end
			if ((v157 == (0 + 0)) or ((4 + 50) == (616 - (55 + 166)))) then
				if (((16 + 66) == (9 + 73)) and v101.Rake:IsReady() and (v14:StealthUp(false, true))) then
					if (v25(v101.Rake, not v16:IsInMeleeRange(38 - 28)) or ((878 - (36 + 261)) < (492 - 210))) then
						return "rake cat 2";
					end
				end
				if ((v39 and not v14:StealthUp(false, true)) or ((5977 - (34 + 1334)) < (960 + 1535))) then
					local v225 = v132();
					if (((896 + 256) == (2435 - (1035 + 248))) and v225) then
						return v225;
					end
				end
				if (((1917 - (20 + 1)) <= (1783 + 1639)) and v101.AdaptiveSwarm:IsCastable()) then
					if (v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm)) or ((1309 - (134 + 185)) > (2753 - (549 + 584)))) then
						return "adaptive_swarm cat";
					end
				end
				if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((1562 - (314 + 371)) > (16117 - 11422))) then
					if (((3659 - (478 + 490)) >= (981 + 870)) and v14:BuffUp(v101.CatForm)) then
						if (((v14:BuffUp(v101.HeartOfTheWild) or (v101.HeartOfTheWild:CooldownRemains() > (1232 - (786 + 386))) or not v101.HeartOfTheWild:IsAvailable()) and (v14:Energy() < (161 - 111)) and (((v14:ComboPoints() < (1384 - (1055 + 324))) and (v16:DebuffRemains(v101.Rip) > (1345 - (1093 + 247)))) or (v107 > (1 + 0)))) or ((314 + 2671) >= (19279 - 14423))) then
							if (((14511 - 10235) >= (3400 - 2205)) and v25(v101.ConvokeTheSpirits, not v16:IsInRange(75 - 45))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				v157 = 1 + 0;
			end
		end
	end
	local function v134()
		local v158 = 0 - 0;
		while true do
			if (((11139 - 7907) <= (3537 + 1153)) and ((0 - 0) == v158)) then
				if ((v101.HeartOfTheWild:IsCastable() and v32 and ((v101.ConvokeTheSpirits:CooldownRemains() < (718 - (364 + 324))) or (v101.ConvokeTheSpirits:CooldownRemains() > (246 - 156)) or not v101.ConvokeTheSpirits:IsAvailable()) and v14:BuffDown(v101.HeartOfTheWild)) or ((2149 - 1253) >= (1043 + 2103))) then
					if (((12808 - 9747) >= (4737 - 1779)) and v25(v101.HeartOfTheWild)) then
						return "heart_of_the_wild owl 2";
					end
				end
				if (((9679 - 6492) >= (1912 - (1249 + 19))) and v101.MoonkinForm:IsReady() and (v14:BuffDown(v101.MoonkinForm)) and v36) then
					if (((582 + 62) <= (2740 - 2036)) and v25(v101.MoonkinForm)) then
						return "moonkin_form owl 4";
					end
				end
				v158 = 1087 - (686 + 400);
			end
			if (((752 + 206) > (1176 - (73 + 156))) and ((1 + 1) == v158)) then
				if (((5303 - (721 + 90)) >= (30 + 2624)) and v101.Sunfire:IsReady()) then
					if (((11175 - 7733) >= (1973 - (224 + 246))) and v100.CastCycle(v101.Sunfire, v106, v123, not v16:IsSpellInRange(v101.Sunfire), nil, nil, v104.SunfireMouseover)) then
						return "sunfire owl 12";
					end
				end
				if ((v53 and v32 and v101.ConvokeTheSpirits:IsCastable()) or ((5135 - 1965) <= (2694 - 1230))) then
					if (v14:BuffUp(v101.MoonkinForm) or ((871 + 3926) == (105 + 4283))) then
						if (((405 + 146) <= (1353 - 672)) and v25(v101.ConvokeTheSpirits, not v16:IsInRange(99 - 69))) then
							return "convoke_the_spirits moonkin 18";
						end
					end
				end
				v158 = 516 - (203 + 310);
			end
			if (((5270 - (1238 + 755)) > (29 + 378)) and (v158 == (1537 - (709 + 825)))) then
				if (((8651 - 3956) >= (2060 - 645)) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(872 - (196 + 668))) and ((v113 and (v107 == (3 - 2))) or v114 or (v116 and (v107 > (1 - 0))))) then
					if (v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true) or ((4045 - (171 + 662)) <= (1037 - (4 + 89)))) then
						return "wrath owl 14";
					end
				end
				if (v101.Starfire:IsReady() or ((10851 - 7755) <= (655 + 1143))) then
					if (((15535 - 11998) == (1388 + 2149)) and v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true)) then
						return "starfire owl 16";
					end
				end
				break;
			end
			if (((5323 - (35 + 1451)) >= (3023 - (28 + 1425))) and (v158 == (1994 - (941 + 1052)))) then
				if ((v101.Starsurge:IsReady() and ((v107 < (6 + 0)) or (not v112 and (v107 < (1522 - (822 + 692))))) and v36) or ((4211 - 1261) == (1796 + 2016))) then
					if (((5020 - (45 + 252)) >= (2294 + 24)) and v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge))) then
						return "starsurge owl 8";
					end
				end
				if ((v101.Moonfire:IsReady() and ((v107 < (2 + 3)) or (not v112 and (v107 < (16 - 9))))) or ((2460 - (114 + 319)) > (4094 - 1242))) then
					if (v100.CastCycle(v101.Moonfire, v106, v125, not v16:IsSpellInRange(v101.Moonfire), nil, nil, v104.MoonfireMouseover) or ((1455 - 319) > (2753 + 1564))) then
						return "moonfire owl 10";
					end
				end
				v158 = 2 - 0;
			end
		end
	end
	local function v135()
		local v159 = v100.InterruptWithStun(v101.IncapacitatingRoar, 16 - 8);
		if (((6711 - (556 + 1407)) == (5954 - (741 + 465))) and v159) then
			return v159;
		end
		if (((4201 - (170 + 295)) <= (2498 + 2242)) and v14:BuffUp(v101.CatForm) and (v14:ComboPoints() > (0 + 0))) then
			v159 = v100.InterruptWithStun(v101.Maim, 19 - 11);
			if (v159 or ((2811 + 579) <= (1963 + 1097))) then
				return v159;
			end
		end
		v159 = v100.InterruptWithStun(v101.MightyBash, 5 + 3);
		if (v159 or ((2229 - (957 + 273)) > (721 + 1972))) then
			return v159;
		end
		v122();
		local v160 = 0 + 0;
		if (((1764 - 1301) < (1583 - 982)) and v101.Rip:IsAvailable()) then
			v160 = v160 + (2 - 1);
		end
		if (v101.Rake:IsAvailable() or ((10809 - 8626) < (2467 - (389 + 1391)))) then
			v160 = v160 + 1 + 0;
		end
		if (((474 + 4075) == (10356 - 5807)) and v101.Thrash:IsAvailable()) then
			v160 = v160 + (952 - (783 + 168));
		end
		if (((15680 - 11008) == (4596 + 76)) and (v160 >= (313 - (309 + 2))) and v16:IsInMeleeRange(24 - 16)) then
			local v209 = v133();
			if (v209 or ((4880 - (1090 + 122)) < (129 + 266))) then
				return v209;
			end
		end
		if (v101.AdaptiveSwarm:IsCastable() or ((13991 - 9825) == (312 + 143))) then
			if (v25(v101.AdaptiveSwarm, not v16:IsSpellInRange(v101.AdaptiveSwarm)) or ((5567 - (628 + 490)) == (478 + 2185))) then
				return "adaptive_swarm main";
			end
		end
		if (v101.MoonkinForm:IsAvailable() or ((10588 - 6311) < (13659 - 10670))) then
			local v210 = 774 - (431 + 343);
			local v211;
			while true do
				if ((v210 == (0 - 0)) or ((2516 - 1646) >= (3278 + 871))) then
					v211 = v134();
					if (((283 + 1929) < (4878 - (556 + 1139))) and v211) then
						return v211;
					end
					break;
				end
			end
		end
		if (((4661 - (6 + 9)) > (548 + 2444)) and v101.Sunfire:IsReady() and (v16:DebuffRefreshable(v101.SunfireDebuff))) then
			if (((735 + 699) < (3275 - (28 + 141))) and v25(v101.Sunfire, not v16:IsSpellInRange(v101.Sunfire))) then
				return "sunfire main 24";
			end
		end
		if (((305 + 481) < (3730 - 707)) and v101.Moonfire:IsReady() and (v16:DebuffRefreshable(v101.MoonfireDebuff))) then
			if (v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire)) or ((1730 + 712) < (1391 - (486 + 831)))) then
				return "moonfire main 26";
			end
		end
		if (((11801 - 7266) == (15966 - 11431)) and v101.Starsurge:IsReady() and (v14:BuffDown(v101.CatForm))) then
			if (v25(v101.Starsurge, not v16:IsSpellInRange(v101.Starsurge)) or ((569 + 2440) <= (6655 - 4550))) then
				return "starsurge main 28";
			end
		end
		if (((3093 - (668 + 595)) < (3302 + 367)) and v101.Starfire:IsReady() and (v107 > (1 + 1))) then
			if (v25(v101.Starfire, not v16:IsSpellInRange(v101.Starfire), true) or ((3899 - 2469) >= (3902 - (23 + 267)))) then
				return "starfire owl 16";
			end
		end
		if (((4627 - (1129 + 815)) >= (2847 - (371 + 16))) and v101.Wrath:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(1758 - (1326 + 424)))) then
			if (v25(v101.Wrath, not v16:IsSpellInRange(v101.Wrath), true) or ((3416 - 1612) >= (11967 - 8692))) then
				return "wrath main 30";
			end
		end
		if ((v101.Moonfire:IsReady() and (v14:BuffDown(v101.CatForm) or not v16:IsInMeleeRange(126 - (88 + 30)))) or ((2188 - (720 + 51)) > (8072 - 4443))) then
			if (((6571 - (421 + 1355)) > (662 - 260)) and v25(v101.Moonfire, not v16:IsSpellInRange(v101.Moonfire))) then
				return "moonfire main 32";
			end
		end
		if (((2365 + 2448) > (4648 - (286 + 797))) and true) then
			if (((14300 - 10388) == (6479 - 2567)) and v25(v101.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v136()
		if (((3260 - (397 + 42)) <= (1507 + 3317)) and v17 and v100.DispellableFriendlyUnit() and v101.NaturesCure:IsReady()) then
			if (((2538 - (24 + 776)) <= (3381 - 1186)) and v25(v104.NaturesCureFocus)) then
				return "natures_cure dispel 2";
			end
		end
	end
	local function v137()
		local v161 = 785 - (222 + 563);
		while true do
			if (((90 - 49) <= (2173 + 845)) and (v161 == (191 - (23 + 167)))) then
				if (((3943 - (690 + 1108)) <= (1481 + 2623)) and v102.Healthstone:IsReady() and v46 and (v14:HealthPercentage() <= v47)) then
					if (((2219 + 470) < (5693 - (40 + 808))) and v25(v104.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v40 and (v14:HealthPercentage() <= v42)) or ((383 + 1939) > (10026 - 7404))) then
					if ((v41 == "Refreshing Healing Potion") or ((4334 + 200) == (1102 + 980))) then
						if (v102.RefreshingHealingPotion:IsReady() or ((862 + 709) > (2438 - (47 + 524)))) then
							if (v25(v104.RefreshingHealingPotion, nil, nil, true) or ((1723 + 931) >= (8189 - 5193))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((5948 - 1970) > (4797 - 2693)) and (v161 == (1726 - (1165 + 561)))) then
				if (((89 + 2906) > (4772 - 3231)) and (v14:HealthPercentage() <= v96) and v97 and v101.Barkskin:IsReady()) then
					if (((1240 + 2009) > (1432 - (341 + 138))) and v25(v101.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((v14:HealthPercentage() <= v98) and v99 and v101.Renewal:IsReady()) or ((884 + 2389) > (9437 - 4864))) then
					if (v25(v101.Renewal, nil, nil, true) or ((3477 - (89 + 237)) < (4130 - 2846))) then
						return "renewal defensive 2";
					end
				end
				v161 = 1 - 0;
			end
		end
	end
	local function v138()
		local v162 = 881 - (581 + 300);
		while true do
			if ((v162 == (1222 - (855 + 365))) or ((4394 - 2544) == (500 + 1029))) then
				if (((2056 - (1030 + 205)) < (1994 + 129)) and v14:BuffUp(v101.Innervate) and (v130() > (0 + 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
					if (((1188 - (156 + 130)) < (5282 - 2957)) and v25(v104.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if (((1445 - 587) <= (6065 - 3103)) and (v162 == (1 + 0))) then
				if ((v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady()) or ((2302 + 1644) < (1357 - (10 + 59)))) then
					if (v25(v104.WildgrowthFocus, nil, true) or ((917 + 2325) == (2792 - 2225))) then
						return "wildgrowth ramp";
					end
				end
				if ((v101.Innervate:IsReady() and v14:BuffDown(v101.Innervate)) or ((2010 - (671 + 492)) >= (1006 + 257))) then
					if (v25(v104.InnervatePlayer, nil, nil, true) or ((3468 - (369 + 846)) == (491 + 1360))) then
						return "innervate ramp";
					end
				end
				v162 = 2 + 0;
			end
			if ((v162 == (1945 - (1036 + 909))) or ((1660 + 427) > (3981 - 1609))) then
				if ((v101.Swiftmend:IsReady() and not v131(v17) and v14:BuffDown(v101.SoulOfTheForestBuff)) or ((4648 - (11 + 192)) < (2097 + 2052))) then
					if (v25(v104.RejuvenationFocus) or ((1993 - (135 + 40)) == (205 - 120))) then
						return "rejuvenation ramp";
					end
				end
				if (((380 + 250) < (4685 - 2558)) and v101.Swiftmend:IsReady() and v131(v17)) then
					if (v25(v104.SwiftmendFocus) or ((2905 - 967) == (2690 - (50 + 126)))) then
						return "swiftmend ramp";
					end
				end
				v162 = 2 - 1;
			end
		end
	end
	local function v139()
		if (((942 + 3313) >= (1468 - (1233 + 180))) and v37) then
			local v212 = 969 - (522 + 447);
			while true do
				if (((4420 - (107 + 1314)) > (537 + 619)) and (v212 == (0 - 0))) then
					if (((999 + 1351) > (2293 - 1138)) and v39) then
						local v240 = v132();
						if (((15941 - 11912) <= (6763 - (716 + 1194))) and v240) then
							return v240;
						end
					end
					if ((v54 and v32 and v14:AffectingCombat() and (v129() > (1 + 2)) and v101.NaturesVigil:IsReady()) or ((56 + 460) > (3937 - (74 + 429)))) then
						if (((7804 - 3758) >= (1504 + 1529)) and v25(v101.NaturesVigil, nil, nil, true)) then
							return "natures_vigil healing";
						end
					end
					if ((v101.Swiftmend:IsReady() and v82 and v14:BuffDown(v101.SoulOfTheForestBuff) and v131(v17) and (v17:HealthPercentage() <= v83)) or ((6223 - 3504) <= (1024 + 423))) then
						if (v25(v104.SwiftmendFocus) or ((12744 - 8610) < (9707 - 5781))) then
							return "swiftmend healing";
						end
					end
					v212 = 434 - (279 + 154);
				end
				if ((v212 == (781 - (454 + 324))) or ((130 + 34) >= (2802 - (12 + 5)))) then
					if ((v101.CenarionWard:IsReady() and v60 and (v17:HealthPercentage() <= v61)) or ((284 + 241) == (5373 - 3264))) then
						if (((13 + 20) == (1126 - (277 + 816))) and v25(v104.CenarionWardFocus)) then
							return "cenarion_ward healing";
						end
					end
					if (((13049 - 9995) <= (5198 - (1058 + 125))) and v14:BuffUp(v101.NaturesSwiftness) and v101.Regrowth:IsCastable()) then
						if (((351 + 1520) < (4357 - (815 + 160))) and v25(v104.RegrowthFocus)) then
							return "regrowth_swiftness healing";
						end
					end
					if (((5547 - 4254) <= (5141 - 2975)) and v101.NaturesSwiftness:IsReady() and v74 and (v17:HealthPercentage() <= v75)) then
						if (v25(v101.NaturesSwiftness) or ((616 + 1963) < (359 - 236))) then
							return "natures_swiftness healing";
						end
					end
					v212 = 1902 - (41 + 1857);
				end
				if ((v212 == (1900 - (1222 + 671))) or ((2186 - 1340) >= (3403 - 1035))) then
					if ((v101.Regrowth:IsCastable() and v78 and v17:BuffUp(v101.Rejuvenation) and (v17:HealthPercentage() <= v79)) or ((5194 - (229 + 953)) <= (5132 - (1111 + 663)))) then
						if (((3073 - (874 + 705)) <= (421 + 2584)) and v25(v104.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v212 == (5 + 1)) or ((6466 - 3355) == (61 + 2073))) then
					if (((3034 - (642 + 37)) == (537 + 1818)) and v101.Regrowth:IsCastable() and v76 and (v17:HealthPercentage() <= v77)) then
						if (v25(v104.RegrowthFocus, nil, true) or ((95 + 493) <= (1084 - 652))) then
							return "regrowth healing";
						end
					end
					if (((5251 - (233 + 221)) >= (9006 - 5111)) and v14:BuffUp(v101.Innervate) and (v130() > (0 + 0)) and v18 and v18:Exists() and v18:BuffRefreshable(v101.Rejuvenation)) then
						if (((5118 - (718 + 823)) == (2251 + 1326)) and v25(v104.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					if (((4599 - (266 + 539)) > (10455 - 6762)) and v101.Rejuvenation:IsCastable() and v80 and v17:BuffRefreshable(v101.Rejuvenation) and (v17:HealthPercentage() <= v81)) then
						if (v25(v104.RejuvenationFocus) or ((2500 - (636 + 589)) == (9732 - 5632))) then
							return "rejuvenation healing";
						end
					end
					v212 = 14 - 7;
				end
				if ((v212 == (4 + 1)) or ((579 + 1012) >= (4595 - (657 + 358)))) then
					if (((2602 - 1619) <= (4119 - 2311)) and v14:AffectingCombat() and v72 and (v100.UnitGroupRole(v17) ~= "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, false, true) < (1188 - (1151 + 36))) and (v101.Undergrowth:IsAvailable() or v100.IsSoloMode()) and (v17:HealthPercentage() <= (v73 - (v27(v14:BuffUp(v101.CatForm)) * (15 + 0)))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) then
						if (v25(v104.LifebloomFocus) or ((566 + 1584) <= (3574 - 2377))) then
							return "lifebloom healing";
						end
					end
					if (((5601 - (1552 + 280)) >= (2007 - (64 + 770))) and (v55 == "Player")) then
						if (((1009 + 476) == (3371 - 1886)) and v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (3 + 12))) then
							if (v25(v104.EfflorescencePlayer) or ((4558 - (157 + 1086)) <= (5567 - 2785))) then
								return "efflorescence healing player";
							end
						end
					elseif ((v55 == "Cursor") or ((3836 - 2960) >= (4546 - 1582))) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (19 - 4))) or ((3051 - (599 + 220)) > (4972 - 2475))) then
							if (v25(v104.EfflorescenceCursor) or ((4041 - (1813 + 118)) <= (243 + 89))) then
								return "efflorescence healing cursor";
							end
						end
					elseif (((4903 - (841 + 376)) > (4444 - 1272)) and (v55 == "Confirmation")) then
						if ((v14:AffectingCombat() and (v101.Efflorescence:TimeSinceLastCast() > (4 + 11))) or ((12211 - 7737) < (1679 - (464 + 395)))) then
							if (((10981 - 6702) >= (1385 + 1497)) and v25(v101.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v101.Wildgrowth:IsReady() and v93 and v100.AreUnitsBelowHealthPercentage(v94, v95) and (not v101.Swiftmend:IsAvailable() or not v101.Swiftmend:IsReady())) or ((2866 - (467 + 370)) >= (7276 - 3755))) then
						if (v25(v104.WildgrowthFocus, nil, true) or ((1496 + 541) >= (15912 - 11270))) then
							return "wildgrowth healing";
						end
					end
					v212 = 1 + 5;
				end
				if (((4001 - 2281) < (4978 - (150 + 370))) and (v212 == (1283 - (74 + 1208)))) then
					if ((v14:BuffUp(v101.SoulOfTheForestBuff) and v101.Wildgrowth:IsReady() and v100.AreUnitsBelowHealthPercentage(v91, v92)) or ((1072 - 636) > (14327 - 11306))) then
						if (((508 + 205) <= (1237 - (14 + 376))) and v25(v104.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					if (((3735 - 1581) <= (2609 + 1422)) and v57 and v101.GroveGuardians:IsReady() and (v101.GroveGuardians:TimeSinceLastCast() > (5 + 0)) and v100.AreUnitsBelowHealthPercentage(v58, v59)) then
						if (((4402 + 213) == (13522 - 8907)) and v25(v104.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if ((v14:AffectingCombat() and v32 and v101.Flourish:IsReady() and v14:BuffDown(v101.Flourish) and (v129() > (4 + 0)) and v100.AreUnitsBelowHealthPercentage(v66, v67)) or ((3868 - (23 + 55)) == (1184 - 684))) then
						if (((60 + 29) < (199 + 22)) and v25(v101.Flourish, nil, nil, true)) then
							return "flourish healing";
						end
					end
					v212 = 2 - 0;
				end
				if (((647 + 1407) >= (2322 - (652 + 249))) and (v212 == (10 - 6))) then
					if (((2560 - (708 + 1160)) < (8300 - 5242)) and (v68 == "Anyone")) then
						if ((v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69)) or ((5932 - 2678) == (1682 - (10 + 17)))) then
							if (v25(v104.IronBarkFocus) or ((292 + 1004) == (6642 - (1400 + 332)))) then
								return "iron_bark healing";
							end
						end
					elseif (((6459 - 3091) == (5276 - (242 + 1666))) and (v68 == "Tank Only")) then
						if (((1131 + 1512) < (1399 + 2416)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and (v100.UnitGroupRole(v17) == "TANK")) then
							if (((1631 + 282) > (1433 - (850 + 90))) and v25(v104.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					elseif (((8327 - 3572) > (4818 - (360 + 1030))) and (v68 == "Tank and Self")) then
						if (((1223 + 158) <= (6686 - 4317)) and v101.IronBark:IsReady() and (v17:HealthPercentage() <= v69) and ((v100.UnitGroupRole(v17) == "TANK") or (v100.UnitGroupRole(v17) == "HEALER"))) then
							if (v25(v104.IronBarkFocus) or ((6662 - 1819) == (5745 - (909 + 752)))) then
								return "iron_bark healing";
							end
						end
					end
					if (((5892 - (109 + 1114)) > (664 - 301)) and v101.AdaptiveSwarm:IsCastable() and v14:AffectingCombat()) then
						if (v25(v104.AdaptiveSwarmFocus) or ((731 + 1146) >= (3380 - (6 + 236)))) then
							return "adaptive_swarm healing";
						end
					end
					if (((2988 + 1754) >= (2919 + 707)) and v14:AffectingCombat() and v70 and (v100.UnitGroupRole(v17) == "TANK") and (v100.FriendlyUnitsWithBuffCount(v101.Lifebloom, true, false) < (2 - 1)) and (v17:HealthPercentage() <= (v71 - (v27(v14:BuffUp(v101.CatForm)) * (26 - 11)))) and v101.Lifebloom:IsCastable() and v17:BuffRefreshable(v101.Lifebloom)) then
						if (v25(v104.LifebloomFocus) or ((5673 - (1076 + 57)) == (151 + 765))) then
							return "lifebloom healing";
						end
					end
					v212 = 694 - (579 + 110);
				end
				if ((v212 == (1 + 1)) or ((1023 + 133) > (2307 + 2038))) then
					if (((2644 - (174 + 233)) < (11868 - 7619)) and v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v100.AreUnitsBelowHealthPercentage(v85, v86)) then
						if (v25(v101.Tranquility, nil, true) or ((4708 - 2025) < (11 + 12))) then
							return "tranquility healing";
						end
					end
					if (((1871 - (663 + 511)) <= (737 + 89)) and v14:AffectingCombat() and v32 and v101.Tranquility:IsReady() and v14:BuffUp(v101.IncarnationBuff) and v100.AreUnitsBelowHealthPercentage(v88, v89)) then
						if (((240 + 865) <= (3625 - 2449)) and v25(v101.Tranquility, nil, true)) then
							return "tranquility_tree healing";
						end
					end
					if (((2047 + 1332) <= (8974 - 5162)) and v14:AffectingCombat() and v32 and v101.ConvokeTheSpirits:IsReady() and v100.AreUnitsBelowHealthPercentage(v63, v64)) then
						if (v25(v101.ConvokeTheSpirits) or ((1907 - 1119) >= (772 + 844))) then
							return "convoke_the_spirits healing";
						end
					end
					v212 = 5 - 2;
				end
			end
		end
	end
	local function v140()
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((170 + 1684) <= (4101 - (478 + 244))) and (v163 == (517 - (440 + 77)))) then
				if (((2069 + 2480) == (16649 - 12100)) and (v45 or v44) and v33) then
					local v226 = 1556 - (655 + 901);
					local v227;
					while true do
						if ((v226 == (0 + 0)) or ((2314 + 708) >= (2042 + 982))) then
							v227 = v136();
							if (((19418 - 14598) > (3643 - (695 + 750))) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				v164 = v137();
				v163 = 3 - 2;
			end
			if ((v163 == (1 - 0)) or ((4267 - 3206) >= (5242 - (285 + 66)))) then
				if (((3179 - 1815) <= (5783 - (682 + 628))) and v164) then
					return v164;
				end
				if (v34 or ((580 + 3015) <= (302 - (176 + 123)))) then
					local v228 = v138();
					if (v228 or ((1955 + 2717) == (2795 + 1057))) then
						return v228;
					end
				end
				v163 = 271 - (239 + 30);
			end
			if (((424 + 1135) == (1499 + 60)) and ((4 - 1) == v163)) then
				if ((v100.TargetIsValid() and v35) or ((5465 - 3713) <= (1103 - (306 + 9)))) then
					local v229 = 0 - 0;
					while true do
						if ((v229 == (0 + 0)) or ((2398 + 1509) == (86 + 91))) then
							v164 = v135();
							if (((9922 - 6452) > (1930 - (1140 + 235))) and v164) then
								return v164;
							end
							break;
						end
					end
				end
				break;
			end
			if (((2 + 0) == v163) or ((892 + 80) == (166 + 479))) then
				v164 = v139();
				if (((3234 - (33 + 19)) >= (764 + 1351)) and v164) then
					return v164;
				end
				v163 = 8 - 5;
			end
		end
	end
	local function v141()
		local v165 = 0 + 0;
		while true do
			if (((7633 - 3740) < (4153 + 276)) and (v165 == (691 - (586 + 103)))) then
				if ((v100.TargetIsValid() and v35) or ((262 + 2605) < (5864 - 3959))) then
					local v230 = 1488 - (1309 + 179);
					local v231;
					while true do
						if (((0 - 0) == v230) or ((782 + 1014) >= (10879 - 6828))) then
							v231 = v135();
							if (((1223 + 396) <= (7980 - 4224)) and v231) then
								return v231;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1203 - 599) == (1213 - (295 + 314))) and (v165 == (0 - 0))) then
				if (((v45 or v44) and v33) or ((6446 - (1300 + 662)) == (2826 - 1926))) then
					local v232 = 1755 - (1178 + 577);
					local v233;
					while true do
						if ((v232 == (0 + 0)) or ((13181 - 8722) <= (2518 - (851 + 554)))) then
							v233 = v136();
							if (((3212 + 420) > (9423 - 6025)) and v233) then
								return v233;
							end
							break;
						end
					end
				end
				if (((8865 - 4783) <= (5219 - (115 + 187))) and v30 and v37) then
					local v234 = v139();
					if (((3701 + 1131) >= (1313 + 73)) and v234) then
						return v234;
					end
				end
				v165 = 3 - 2;
			end
			if (((1298 - (160 + 1001)) == (120 + 17)) and (v165 == (1 + 0))) then
				if ((v43 and v101.MarkOfTheWild:IsCastable() and (v14:BuffDown(v101.MarkOfTheWild, true) or v100.GroupBuffMissing(v101.MarkOfTheWild))) or ((3213 - 1643) >= (4690 - (237 + 121)))) then
					if (v25(v104.MarkOfTheWildPlayer) or ((4961 - (525 + 372)) <= (3448 - 1629))) then
						return "mark_of_the_wild";
					end
				end
				if (v100.TargetIsValid() or ((16382 - 11396) < (1716 - (96 + 46)))) then
					if (((5203 - (643 + 134)) > (63 + 109)) and v101.Rake:IsReady() and (v14:StealthUp(false, true))) then
						if (((1404 - 818) > (1689 - 1234)) and v25(v101.Rake, not v16:IsInMeleeRange(10 + 0))) then
							return "rake";
						end
					end
				end
				v165 = 3 - 1;
			end
		end
	end
	local function v142()
		v38 = EpicSettings.Settings['UseRacials'];
		v39 = EpicSettings.Settings['UseTrinkets'];
		v40 = EpicSettings.Settings['UseHealingPotion'];
		v41 = EpicSettings.Settings['HealingPotionName'] or "";
		v42 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v43 = EpicSettings.Settings['UseMarkOfTheWild'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v46 = EpicSettings.Settings['UseHealthstone'];
		v47 = EpicSettings.Settings['HealthstoneHP'] or (719 - (316 + 403));
		v48 = EpicSettings.Settings['HandleCharredTreant'];
		v49 = EpicSettings.Settings['HandleCharredBrambles'];
		v50 = EpicSettings.Settings['InterruptWithStun'];
		v51 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v52 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v53 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v54 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v55 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v56 = EpicSettings.Settings['EfflorescenceHP'] or (0 - 0);
		v57 = EpicSettings.Settings['UseGroveGuardians'];
		v58 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
		v59 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
		v60 = EpicSettings.Settings['UseCenarionWard'];
		v61 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
		v62 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v63 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 + 0);
		v64 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
		v65 = EpicSettings.Settings['UseFlourish'];
		v66 = EpicSettings.Settings['FlourishHP'] or (0 - 0);
		v67 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
		v68 = EpicSettings.Settings['IronBarkUsage'] or "";
		v69 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
	end
	local function v143()
		v70 = EpicSettings.Settings['UseLifebloomTank'];
		v71 = EpicSettings.Settings['LifebloomTankHP'] or (0 - 0);
		v72 = EpicSettings.Settings['UseLifebloom'];
		v73 = EpicSettings.Settings['LifebloomHP'] or (0 + 0);
		v74 = EpicSettings.Settings['UseNaturesSwiftness'];
		v75 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 - 0);
		v76 = EpicSettings.Settings['UseRegrowth'];
		v77 = EpicSettings.Settings['RegrowthHP'] or (17 - (12 + 5));
		v78 = EpicSettings.Settings['UseRegrowthRefresh'];
		v79 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 - 0);
		v80 = EpicSettings.Settings['UseRejuvenation'];
		v81 = EpicSettings.Settings['RejuvenationHP'] or (0 - 0);
		v82 = EpicSettings.Settings['UseSwiftmend'];
		v83 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
		v84 = EpicSettings.Settings['UseTranquility'];
		v85 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
		v86 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
		v87 = EpicSettings.Settings['UseTranquilityTree'];
		v88 = EpicSettings.Settings['TranquilityTreeHP'] or (1973 - (1656 + 317));
		v89 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
		v90 = EpicSettings.Settings['UseWildgrowthSotF'];
		v91 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 + 0);
		v92 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
		v93 = EpicSettings.Settings['UseWildgrowth'];
		v94 = EpicSettings.Settings['WildgrowthHP'] or (0 - 0);
		v95 = EpicSettings.Settings['WildgrowthGroup'] or (354 - (5 + 349));
		v96 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v97 = EpicSettings.Settings['UseBarkskin'];
		v98 = EpicSettings.Settings['RenewalHP'] or (1271 - (266 + 1005));
		v99 = EpicSettings.Settings['UseRenewal'];
	end
	local function v144()
		v142();
		v143();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['ramp'];
		v35 = EpicSettings.Toggles['dps'];
		v36 = EpicSettings.Toggles['dpsform'];
		v37 = EpicSettings.Toggles['healing'];
		if (((545 + 281) == (2818 - 1992)) and v14:IsDeadOrGhost()) then
			return;
		end
		if (v14:AffectingCombat() or v44 or ((5290 - 1271) > (6137 - (561 + 1135)))) then
			local v213 = v44 and v101.NaturesCure:IsReady() and v33;
			if (((2628 - 611) < (14006 - 9745)) and v100.IsTankBelowHealthPercentage(v69) and v101.IronBark:IsReady() and ((v68 == "Tank Only") or (v68 == "Tank and Self"))) then
				local v220 = 1066 - (507 + 559);
				local v221;
				while true do
					if (((11833 - 7117) > (247 - 167)) and (v220 == (388 - (212 + 176)))) then
						v221 = v100.FocusUnit(v213, nil, nil, "TANK", 925 - (250 + 655));
						if (v221 or ((9563 - 6056) == (5716 - 2444))) then
							return v221;
						end
						break;
					end
				end
			elseif (((v14:HealthPercentage() < v69) and v101.IronBark:IsReady() and (v68 == "Tank and Self")) or ((1370 - 494) >= (5031 - (1869 + 87)))) then
				local v235 = 0 - 0;
				local v236;
				while true do
					if (((6253 - (484 + 1417)) > (5473 - 2919)) and (v235 == (0 - 0))) then
						v236 = v100.FocusUnit(v213, nil, nil, "HEALER", 793 - (48 + 725));
						if (v236 or ((7197 - 2791) < (10846 - 6803))) then
							return v236;
						end
						break;
					end
				end
			else
				local v237 = v100.FocusUnit(v213, nil, nil, nil);
				if (v237 or ((1098 + 791) >= (9040 - 5657))) then
					return v237;
				end
			end
		end
		if (((530 + 1362) <= (797 + 1937)) and v14:IsMounted()) then
			return;
		end
		if (((2776 - (152 + 701)) < (3529 - (430 + 881))) and v14:IsMoving()) then
			v105 = GetTime();
		end
		if (((833 + 1340) > (1274 - (557 + 338))) and (v14:BuffUp(v101.TravelForm) or v14:BuffUp(v101.BearForm) or v14:BuffUp(v101.CatForm))) then
			if (((GetTime() - v105) < (1 + 0)) or ((7301 - 4710) == (11937 - 8528))) then
				return;
			end
		end
		if (((11992 - 7478) > (7163 - 3839)) and v31) then
			v106 = v16:GetEnemiesInSplashRange(809 - (499 + 302));
			v107 = #v106;
		else
			v106 = {};
			v107 = 867 - (39 + 827);
		end
		if (v100.TargetIsValid() or v14:AffectingCombat() or ((573 - 365) >= (10782 - 5954))) then
			local v214 = 0 - 0;
			while true do
				if ((v214 == (0 - 0)) or ((136 + 1447) > (10440 - 6873))) then
					v108 = v10.BossFightRemains(nil, true);
					v109 = v108;
					v214 = 1 + 0;
				end
				if ((v214 == (1 - 0)) or ((1417 - (103 + 1)) == (1348 - (475 + 79)))) then
					if (((6861 - 3687) > (9286 - 6384)) and (v109 == (1436 + 9675))) then
						v109 = v10.FightRemains(v106, false);
					end
					break;
				end
			end
		end
		if (((3626 + 494) <= (5763 - (1395 + 108))) and v48) then
			local v215 = 0 - 0;
			local v216;
			while true do
				if ((v215 == (1205 - (7 + 1197))) or ((385 + 498) > (1668 + 3110))) then
					v216 = v100.HandleCharredTreant(v101.Regrowth, v104.RegrowthMouseover, 359 - (27 + 292), true);
					if (v216 or ((10607 - 6987) >= (6237 - 1346))) then
						return v216;
					end
					v215 = 8 - 6;
				end
				if (((8396 - 4138) > (1784 - 847)) and (v215 == (139 - (43 + 96)))) then
					v216 = v100.HandleCharredTreant(v101.Rejuvenation, v104.RejuvenationMouseover, 163 - 123);
					if (v216 or ((11007 - 6138) < (752 + 154))) then
						return v216;
					end
					v215 = 1 + 0;
				end
				if ((v215 == (5 - 2)) or ((470 + 755) > (7923 - 3695))) then
					v216 = v100.HandleCharredTreant(v101.Wildgrowth, v104.WildgrowthMouseover, 13 + 27, true);
					if (((245 + 3083) > (3989 - (1414 + 337))) and v216) then
						return v216;
					end
					break;
				end
				if (((5779 - (1642 + 298)) > (3662 - 2257)) and (v215 == (5 - 3))) then
					v216 = v100.HandleCharredTreant(v101.Swiftmend, v104.SwiftmendMouseover, 118 - 78);
					if (v216 or ((426 + 867) <= (395 + 112))) then
						return v216;
					end
					v215 = 975 - (357 + 615);
				end
			end
		end
		if (v49 or ((2033 + 863) < (1974 - 1169))) then
			local v217 = v100.HandleCharredBrambles(v101.Rejuvenation, v104.RejuvenationMouseover, 35 + 5);
			if (((4963 - 2647) == (1853 + 463)) and v217) then
				return v217;
			end
			local v217 = v100.HandleCharredBrambles(v101.Regrowth, v104.RegrowthMouseover, 3 + 37, true);
			if (v217 or ((1616 + 954) == (2834 - (384 + 917)))) then
				return v217;
			end
			local v217 = v100.HandleCharredBrambles(v101.Swiftmend, v104.SwiftmendMouseover, 737 - (128 + 569));
			if (v217 or ((2426 - (1407 + 136)) == (3347 - (687 + 1200)))) then
				return v217;
			end
			local v217 = v100.HandleCharredBrambles(v101.Wildgrowth, v104.WildgrowthMouseover, 1750 - (556 + 1154), true);
			if (v217 or ((16249 - 11630) <= (1094 - (9 + 86)))) then
				return v217;
			end
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v30) or ((3831 - (275 + 146)) > (670 + 3446))) then
			local v218 = v100.DeadFriendlyUnitsCount();
			if (v14:AffectingCombat() or ((967 - (29 + 35)) >= (13557 - 10498))) then
				if (v101.Rebirth:IsReady() or ((11875 - 7899) < (12612 - 9755))) then
					if (((3212 + 1718) > (3319 - (53 + 959))) and v25(v101.Rebirth, nil, true)) then
						return "rebirth";
					end
				end
			elseif ((v218 > (409 - (312 + 96))) or ((7022 - 2976) < (1576 - (147 + 138)))) then
				if (v25(v101.Revitalize, nil, true) or ((5140 - (813 + 86)) == (3204 + 341))) then
					return "revitalize";
				end
			elseif (v25(v101.Revive, not v16:IsInRange(74 - 34), true) or ((4540 - (18 + 474)) > (1428 + 2804))) then
				return "revive";
			end
		end
		if ((v37 and (v14:AffectingCombat() or v30)) or ((5711 - 3961) >= (4559 - (860 + 226)))) then
			local v219 = v138();
			if (((3469 - (121 + 182)) == (390 + 2776)) and v219) then
				return v219;
			end
			local v219 = v139();
			if (((3003 - (988 + 252)) < (421 + 3303)) and v219) then
				return v219;
			end
		end
		if (((18 + 39) <= (4693 - (49 + 1921))) and not v14:IsChanneling()) then
			if (v14:AffectingCombat() or ((2960 - (223 + 667)) == (495 - (51 + 1)))) then
				local v222 = 0 - 0;
				local v223;
				while true do
					if ((v222 == (0 - 0)) or ((3830 - (146 + 979)) == (394 + 999))) then
						v223 = v140();
						if (v223 or ((5206 - (311 + 294)) < (170 - 109))) then
							return v223;
						end
						break;
					end
				end
			elseif (v30 or ((589 + 801) >= (6187 - (496 + 947)))) then
				local v238 = 1358 - (1233 + 125);
				local v239;
				while true do
					if ((v238 == (0 + 0)) or ((1798 + 205) > (729 + 3105))) then
						v239 = v141();
						if (v239 or ((1801 - (963 + 682)) > (3266 + 647))) then
							return v239;
						end
						break;
					end
				end
			end
		end
	end
	local function v145()
		local v204 = 1504 - (504 + 1000);
		while true do
			if (((132 + 63) == (178 + 17)) and (v204 == (0 + 0))) then
				v23.Print("Restoration Druid Rotation by Epic.");
				EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
				v204 = 1 - 0;
			end
			if (((2653 + 452) >= (1045 + 751)) and (v204 == (183 - (156 + 26)))) then
				v120();
				break;
			end
		end
	end
	v23.SetAPL(61 + 44, v144, v145);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

