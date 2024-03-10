local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3738 + 431) > (3184 - 997)) and not v5) then
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
	local v104 = 0 + 0;
	local v105, v106;
	local v107 = 39319 - 28208;
	local v108 = 5353 + 5758;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[809 - (588 + 208)] and v20(v116[34 - 21])) or v20(1800 - (884 + 916));
	local v118 = (v116[28 - 14] and v20(v116[9 + 5])) or v20(653 - (232 + 421));
	v9:RegisterForEvent(function()
		local v146 = 1889 - (1569 + 320);
		while true do
			if (((345 + 1061) == (268 + 1138)) and (v146 == (0 - 0))) then
				v116 = v13:GetEquipment();
				v117 = (v116[618 - (316 + 289)] and v20(v116[33 - 20])) or v20(0 + 0);
				v146 = 1454 - (666 + 787);
			end
			if (((1956 - (360 + 65)) < (3992 + 279)) and (v146 == (255 - (79 + 175)))) then
				v118 = (v116[21 - 7] and v20(v116[11 + 3])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v107 = 21397 - 10286;
		v108 = 12010 - (503 + 396);
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (((816 - (92 + 89)) == (1231 - 596)) and v100.ImprovedNaturesCure:IsAvailable()) then
			local v168 = 0 + 0;
			while true do
				if (((1997 + 1376) <= (13925 - 10369)) and (v168 == (0 + 0))) then
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
		return (v13:StealthUp(true, true) and (2.6 - 1)) or (1 + 0);
	end
	v100.Rake:RegisterPMultiplier(v100.RakeDebuff, v120);
	local function v121()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (5 - 3)) or ((411 + 2880) < (5002 - 1722))) then
				v113 = (not v109 and (((v100.Starfire:Count() == (1244 - (485 + 759))) and (v100.Wrath:Count() > (0 - 0))) or v13:IsCasting(v100.Wrath))) or v112;
				v114 = (not v109 and (((v100.Wrath:Count() == (1189 - (442 + 747))) and (v100.Starfire:Count() > (1135 - (832 + 303)))) or v13:IsCasting(v100.Starfire))) or v111;
				v147 = 949 - (88 + 858);
			end
			if (((1337 + 3049) >= (723 + 150)) and (v147 == (0 + 0))) then
				v109 = v13:BuffUp(v100.EclipseSolar) or v13:BuffUp(v100.EclipseLunar);
				v110 = v13:BuffUp(v100.EclipseSolar) and v13:BuffUp(v100.EclipseLunar);
				v147 = 790 - (766 + 23);
			end
			if (((4546 - 3625) <= (1506 - 404)) and (v147 == (7 - 4))) then
				v115 = not v109 and (v100.Wrath:Count() > (0 - 0)) and (v100.Starfire:Count() > (1073 - (1036 + 37)));
				break;
			end
			if (((3337 + 1369) >= (1874 - 911)) and ((1 + 0) == v147)) then
				v111 = v13:BuffUp(v100.EclipseLunar) and v13:BuffDown(v100.EclipseSolar);
				v112 = v13:BuffUp(v100.EclipseSolar) and v13:BuffDown(v100.EclipseLunar);
				v147 = 1482 - (641 + 839);
			end
		end
	end
	local function v122(v148)
		return v148:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (918 - (910 + 3)));
	end
	local function v123(v149)
		return (v149:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (30 - 18)) and ((((v106 <= (1688 - (1466 + 218))) or (v13:Energy() < (23 + 27))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (1152 - (556 + 592))) or (v13:Energy() < (18 + 32))) and v13:BuffUp(v100.HeartOfTheWild))) and v149:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(809 - (329 + 479), v100.Sunfire) and ((v149:DebuffUp(v100.MoonfireDebuff) and (v149:DebuffRemains(v100.MoonfireDebuff) < (v149:DebuffDuration(v100.MoonfireDebuff) * (854.8 - (174 + 680))))) or v149:DebuffDown(v100.MoonfireDebuff)) and (v106 == (3 - 2)));
	end
	local function v124(v150)
		return v150:DebuffRefreshable(v100.MoonfireDebuff) and (v150:TimeToDie() > (10 - 5));
	end
	local function v125(v151)
		return ((v151:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (65 + 25)) and (v151:DebuffRemains(v100.Rip) <= (749 - (396 + 343))))) and (((v13:ComboPoints() == (1 + 4)) and (v151:TimeToDie() > (v151:DebuffRemains(v100.Rip) + (1501 - (29 + 1448))))) or (((v151:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (1393 - (135 + 1254)))) < v151:TimeToDie()) and ((v151:DebuffRemains(v100.Rip) + (14 - 10) + (v13:ComboPoints() * (18 - 14))) > v151:TimeToDie())))) or (v151:DebuffDown(v100.Rip) and (v13:ComboPoints() > (2 + 0 + (v106 * (1529 - (389 + 1138))))));
	end
	local function v126(v152)
		return (v152:DebuffDown(v100.RakeDebuff) or v152:DebuffRefreshable(v100.RakeDebuff)) and (v152:TimeToDie() > (584 - (102 + 472))) and (v13:ComboPoints() < (5 + 0));
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
		local v155 = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 23 + 17, nil);
		if (v155 or ((896 + 64) <= (2421 - (320 + 1225)))) then
			return v155;
		end
		local v155 = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 71 - 31, nil);
		if (v155 or ((1265 + 801) == (2396 - (157 + 1307)))) then
			return v155;
		end
	end
	local function v132()
		local v156 = 1859 - (821 + 1038);
		while true do
			if (((12038 - 7213) < (530 + 4313)) and (v156 == (3 - 1))) then
				if ((v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (2 + 3))) or ((9609 - 5732) >= (5563 - (834 + 192)))) then
					if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((275 + 4040) < (444 + 1282))) then
						return "sunfire cat 24";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (1 + 4))) or ((5698 - 2019) < (929 - (300 + 4)))) then
					if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((1236 + 3389) < (1654 - 1022))) then
						return "moonfire cat 24";
					end
				end
				if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((445 - (112 + 250)) > (710 + 1070))) then
					if (((1367 - 821) <= (617 + 460)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
						return "starsurge cat 26";
					end
				end
				v156 = 2 + 1;
			end
			if ((v156 == (4 + 1)) or ((494 + 502) > (3196 + 1105))) then
				if (((5484 - (1001 + 413)) > (1531 - 844)) and v100.Rake:IsReady() and ((v13:ComboPoints() < (887 - (244 + 638))) or (v13:Energy() > (783 - (627 + 66)))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(14 - 9)) or ((1258 - (512 + 90)) >= (5236 - (1665 + 241)))) then
						return "rake cat 40";
					end
				end
				if ((v100.Swipe:IsReady() and (v106 >= (719 - (373 + 344)))) or ((1124 + 1368) <= (89 + 246))) then
					if (((11400 - 7078) >= (4335 - 1773)) and v24(v100.Swipe, not v15:IsInMeleeRange(1107 - (35 + 1064)))) then
						return "swipe cat 38";
					end
				end
				if ((v100.Shred:IsReady() and ((v13:ComboPoints() < (4 + 1)) or (v13:Energy() > (192 - 102)))) or ((15 + 3622) >= (5006 - (298 + 938)))) then
					if (v24(v100.Shred, not v15:IsInMeleeRange(1264 - (233 + 1026))) or ((4045 - (636 + 1030)) > (2341 + 2237))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if ((v156 == (4 + 0)) or ((144 + 339) > (51 + 692))) then
				if (((2675 - (55 + 166)) > (113 + 465)) and v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (2 + 9)) and v125(v15)) then
					if (((3551 - 2621) < (4755 - (36 + 261))) and v24(v100.Rip, not v15:IsInMeleeRange(8 - 3))) then
						return "rip cat 34";
					end
				end
				if (((2030 - (34 + 1334)) <= (374 + 598)) and v100.Thrash:IsReady() and (v106 >= (2 + 0)) and v15:DebuffRefreshable(v100.ThrashDebuff)) then
					if (((5653 - (1035 + 248)) == (4391 - (20 + 1))) and v24(v100.Thrash, not v15:IsInMeleeRange(5 + 3))) then
						return "thrash cat";
					end
				end
				if ((v100.Rake:IsReady() and v126(v15)) or ((5081 - (134 + 185)) <= (1994 - (549 + 584)))) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(690 - (314 + 371))) or ((4847 - 3435) == (5232 - (478 + 490)))) then
						return "rake cat 36";
					end
				end
				v156 = 3 + 2;
			end
			if ((v156 == (1172 - (786 + 386))) or ((10261 - 7093) < (3532 - (1055 + 324)))) then
				if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((6316 - (1093 + 247)) < (1184 + 148))) then
					if (((487 + 4141) == (18373 - 13745)) and v24(v100.Rake, not v15:IsInMeleeRange(33 - 23))) then
						return "rake cat 2";
					end
				end
				if ((v38 and not v13:StealthUp(false, true)) or ((153 - 99) == (992 - 597))) then
					local v212 = 0 + 0;
					local v213;
					while true do
						if (((315 - 233) == (282 - 200)) and (v212 == (0 + 0))) then
							v213 = v131();
							if (v213 or ((1485 - 904) < (970 - (364 + 324)))) then
								return v213;
							end
							break;
						end
					end
				end
				if (v100.AdaptiveSwarm:IsCastable() or ((12634 - 8025) < (5986 - 3491))) then
					if (((382 + 770) == (4820 - 3668)) and v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm))) then
						return "adaptive_swarm cat";
					end
				end
				v156 = 1 - 0;
			end
			if (((5758 - 3862) <= (4690 - (1249 + 19))) and (v156 == (3 + 0))) then
				if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (116 - 86)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (1090 - (686 + 400))))) or ((777 + 213) > (1849 - (73 + 156)))) then
					if (v24(v100.HeartOfTheWild) or ((5 + 872) > (5506 - (721 + 90)))) then
						return "heart_of_the_wild cat 26";
					end
				end
				if (((31 + 2660) >= (6009 - 4158)) and v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (500 - (224 + 246))) and v35) then
					if (v24(v100.CatForm) or ((4835 - 1850) >= (8940 - 4084))) then
						return "cat_form cat 28";
					end
				end
				if (((776 + 3500) >= (29 + 1166)) and v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (3 + 0)) and (v15:TimeToDie() < (19 - 9))) or ((v13:ComboPoints() == (16 - 11)) and (v13:Energy() >= (538 - (203 + 310))) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (1998 - (1238 + 755))))))) then
					if (((226 + 3006) <= (6224 - (709 + 825))) and v24(v100.FerociousBite, not v15:IsInMeleeRange(8 - 3))) then
						return "ferocious_bite cat 32";
					end
				end
				v156 = 5 - 1;
			end
			if ((v156 == (865 - (196 + 668))) or ((3537 - 2641) >= (6516 - 3370))) then
				if (((3894 - (171 + 662)) >= (3051 - (4 + 89))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
					if (((11170 - 7983) >= (235 + 409)) and v13:BuffUp(v100.CatForm)) then
						if (((2828 - 2184) <= (277 + 427)) and (v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (1546 - (35 + 1451))) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (1503 - (28 + 1425))) and (((v13:ComboPoints() < (1998 - (941 + 1052))) and (v15:DebuffRemains(v100.Rip) > (5 + 0))) or (v106 > (1515 - (822 + 692))))) then
							if (((1367 - 409) > (447 + 500)) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(327 - (45 + 252)))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if (((4445 + 47) >= (914 + 1740)) and v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (12 - 7)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (463 - (114 + 319))))) then
					if (((4941 - 1499) >= (1925 - 422)) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
						return "sunfire cat 20";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (4 + 1)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (44 - 14)))) or ((6642 - 3472) <= (3427 - (556 + 1407)))) then
					if (v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((6003 - (741 + 465)) == (4853 - (170 + 295)))) then
						return "moonfire cat 22";
					end
				end
				v156 = 2 + 0;
			end
		end
	end
	local function v133()
		local v157 = 0 + 0;
		while true do
			if (((1356 - 805) <= (565 + 116)) and ((1 + 0) == v157)) then
				if (((1856 + 1421) > (1637 - (957 + 273))) and v100.Starsurge:IsReady() and ((v106 < (2 + 4)) or (not v111 and (v106 < (4 + 4)))) and v35) then
					if (((17889 - 13194) >= (3728 - 2313)) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
						return "starsurge owl 8";
					end
				end
				if ((v100.Moonfire:IsReady() and ((v106 < (15 - 10)) or (not v111 and (v106 < (34 - 27))))) or ((4992 - (389 + 1391)) <= (593 + 351))) then
					if (v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover) or ((323 + 2773) <= (4093 - 2295))) then
						return "moonfire owl 10";
					end
				end
				v157 = 953 - (783 + 168);
			end
			if (((11870 - 8333) == (3480 + 57)) and (v157 == (313 - (309 + 2)))) then
				if (((11782 - 7945) >= (2782 - (1090 + 122))) and v100.Sunfire:IsReady()) then
					if (v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover) or ((957 + 1993) == (12802 - 8990))) then
						return "sunfire owl 12";
					end
				end
				if (((3233 + 1490) >= (3436 - (628 + 490))) and v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) then
					if (v13:BuffUp(v100.MoonkinForm) or ((364 + 1663) > (7060 - 4208))) then
						if (v24(v100.ConvokeTheSpirits, not v15:IsInRange(137 - 107)) or ((1910 - (431 + 343)) > (8718 - 4401))) then
							return "convoke_the_spirits moonkin 18";
						end
					end
				end
				v157 = 8 - 5;
			end
			if (((3751 + 997) == (608 + 4140)) and (v157 == (1695 - (556 + 1139)))) then
				if (((3751 - (6 + 9)) <= (868 + 3872)) and v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (16 + 14)) or (v100.ConvokeTheSpirits:CooldownRemains() > (259 - (28 + 141))) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) then
					if (v24(v100.HeartOfTheWild) or ((1314 + 2076) <= (3777 - 717))) then
						return "heart_of_the_wild owl 2";
					end
				end
				if ((v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) or ((708 + 291) > (4010 - (486 + 831)))) then
					if (((1204 - 741) < (2115 - 1514)) and v24(v100.MoonkinForm)) then
						return "moonkin_form owl 4";
					end
				end
				v157 = 1 + 0;
			end
			if ((v157 == (9 - 6)) or ((3446 - (668 + 595)) < (619 + 68))) then
				if (((918 + 3631) == (12405 - 7856)) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(298 - (23 + 267))) and ((v112 and (v106 == (1945 - (1129 + 815)))) or v113 or (v115 and (v106 > (388 - (371 + 16)))))) then
					if (((6422 - (1326 + 424)) == (8848 - 4176)) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
						return "wrath owl 14";
					end
				end
				if (v100.Starfire:IsReady() or ((13403 - 9735) < (513 - (88 + 30)))) then
					if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((4937 - (720 + 51)) == (1012 - 557))) then
						return "starfire owl 16";
					end
				end
				break;
			end
		end
	end
	local function v134()
		local v158 = 1776 - (421 + 1355);
		local v159;
		local v160;
		while true do
			if ((v158 == (6 - 2)) or ((2186 + 2263) == (3746 - (286 + 797)))) then
				if ((v100.Starfire:IsReady() and (v106 > (7 - 5))) or ((7084 - 2807) < (3428 - (397 + 42)))) then
					if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((272 + 598) >= (4949 - (24 + 776)))) then
						return "starfire owl 16";
					end
				end
				if (((3407 - 1195) < (3968 - (222 + 563))) and v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(17 - 9))) then
					if (((3346 + 1300) > (3182 - (23 + 167))) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
						return "wrath main 30";
					end
				end
				if (((3232 - (690 + 1108)) < (1121 + 1985)) and v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(7 + 1))) then
					if (((1634 - (40 + 808)) < (498 + 2525)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
						return "moonfire main 32";
					end
				end
				if (true or ((9338 - 6896) < (71 + 3))) then
					if (((2400 + 2135) == (2487 + 2048)) and v24(v100.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v158 == (573 - (47 + 524))) or ((1953 + 1056) <= (5754 - 3649))) then
				if (((2736 - 906) < (8367 - 4698)) and v100.Rake:IsAvailable()) then
					v160 = v160 + (1727 - (1165 + 561));
				end
				if (v100.Thrash:IsAvailable() or ((43 + 1387) >= (11186 - 7574))) then
					v160 = v160 + 1 + 0;
				end
				if (((3162 - (341 + 138)) >= (665 + 1795)) and (v160 >= (3 - 1)) and v15:IsInMeleeRange(334 - (89 + 237))) then
					local v214 = 0 - 0;
					local v215;
					while true do
						if ((v214 == (0 - 0)) or ((2685 - (581 + 300)) >= (4495 - (855 + 365)))) then
							v215 = v132();
							if (v215 or ((3365 - 1948) > (1185 + 2444))) then
								return v215;
							end
							break;
						end
					end
				end
				if (((6030 - (1030 + 205)) > (378 + 24)) and v100.AdaptiveSwarm:IsCastable()) then
					if (((4478 + 335) > (3851 - (156 + 130))) and v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				v158 = 6 - 3;
			end
			if (((6592 - 2680) == (8011 - 4099)) and (v158 == (1 + 2))) then
				if (((1646 + 1175) <= (4893 - (10 + 59))) and v100.MoonkinForm:IsAvailable()) then
					local v216 = v133();
					if (((492 + 1246) <= (10809 - 8614)) and v216) then
						return v216;
					end
				end
				if (((1204 - (671 + 492)) <= (2403 + 615)) and v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) then
					if (((3360 - (369 + 846)) <= (1087 + 3017)) and v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire))) then
						return "sunfire main 24";
					end
				end
				if (((2295 + 394) < (6790 - (1036 + 909))) and v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) then
					if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((1847 + 475) > (4401 - 1779))) then
						return "moonfire main 26";
					end
				end
				if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((4737 - (11 + 192)) == (1053 + 1029))) then
					if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((1746 - (135 + 40)) > (4523 - 2656))) then
						return "starsurge main 28";
					end
				end
				v158 = 3 + 1;
			end
			if ((v158 == (0 - 0)) or ((3978 - 1324) >= (3172 - (50 + 126)))) then
				v159 = v99.InterruptWithStun(v100.IncapacitatingRoar, 22 - 14);
				if (((881 + 3097) > (3517 - (1233 + 180))) and v159) then
					return v159;
				end
				if (((3964 - (522 + 447)) > (2962 - (107 + 1314))) and v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 + 0))) then
					local v217 = 0 - 0;
					while true do
						if (((1380 + 1869) > (1892 - 939)) and (v217 == (0 - 0))) then
							v159 = v99.InterruptWithStun(v100.Maim, 1918 - (716 + 1194));
							if (v159 or ((56 + 3217) > (490 + 4083))) then
								return v159;
							end
							break;
						end
					end
				end
				v159 = v99.InterruptWithStun(v100.MightyBash, 511 - (74 + 429));
				v158 = 1 - 0;
			end
			if ((v158 == (1 + 0)) or ((7212 - 4061) < (909 + 375))) then
				if (v159 or ((5703 - 3853) == (3780 - 2251))) then
					return v159;
				end
				v121();
				v160 = 433 - (279 + 154);
				if (((1599 - (454 + 324)) < (1671 + 452)) and v100.Rip:IsAvailable()) then
					v160 = v160 + (18 - (12 + 5));
				end
				v158 = 2 + 0;
			end
		end
	end
	local v135 = 0 - 0;
	local function v136()
		if (((334 + 568) < (3418 - (277 + 816))) and v16 and v99.UnitHasDispellableDebuffByPlayer(v16) and v100.NaturesCure:IsReady()) then
			local v171 = 0 - 0;
			while true do
				if (((2041 - (1058 + 125)) <= (556 + 2406)) and (v171 == (975 - (815 + 160)))) then
					if ((v135 == (0 - 0)) or ((9367 - 5421) < (308 + 980))) then
						v135 = GetTime();
					end
					if (v99.Wait(1461 - 961, v135) or ((5140 - (41 + 1857)) == (2460 - (1222 + 671)))) then
						local v235 = 0 - 0;
						while true do
							if ((v235 == (0 - 0)) or ((2029 - (229 + 953)) >= (3037 - (1111 + 663)))) then
								if (v24(v103.NaturesCureFocus) or ((3832 - (874 + 705)) == (260 + 1591))) then
									return "natures_cure dispel 2";
								end
								v135 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v137()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (1 + 0)) or ((2766 - (642 + 37)) > (541 + 1831))) then
				if ((v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) or ((712 + 3733) < (10416 - 6267))) then
					if (v24(v103.Healthstone, nil, nil, true) or ((2272 - (233 + 221)) == (196 - 111))) then
						return "healthstone defensive 3";
					end
				end
				if (((555 + 75) < (3668 - (718 + 823))) and v39 and (v13:HealthPercentage() <= v41)) then
					if ((v40 == "Refreshing Healing Potion") or ((1220 + 718) == (3319 - (266 + 539)))) then
						if (((12046 - 7791) >= (1280 - (636 + 589))) and v101.RefreshingHealingPotion:IsReady()) then
							if (((7118 - 4119) > (2383 - 1227)) and v24(v103.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((1863 + 487) > (420 + 735)) and (v161 == (1015 - (657 + 358)))) then
				if (((10667 - 6638) <= (11056 - 6203)) and (v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) then
					if (v24(v100.Barkskin, nil, nil, true) or ((1703 - (1151 + 36)) > (3317 + 117))) then
						return "barkskin defensive 2";
					end
				end
				if (((1064 + 2982) >= (9057 - 6024)) and (v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) then
					if (v24(v100.Renewal, nil, nil, true) or ((4551 - (1552 + 280)) <= (2281 - (64 + 770)))) then
						return "renewal defensive 2";
					end
				end
				v161 = 1 + 0;
			end
		end
	end
	local function v138()
		if ((v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) or ((9384 - 5250) < (698 + 3228))) then
			if (v24(v103.RejuvenationFocus) or ((1407 - (157 + 1086)) >= (5574 - 2789))) then
				return "rejuvenation ramp";
			end
		end
		if ((v100.Swiftmend:IsReady() and v130(v16)) or ((2299 - 1774) == (3234 - 1125))) then
			if (((44 - 11) == (852 - (599 + 220))) and v24(v103.SwiftmendFocus)) then
				return "swiftmend ramp";
			end
		end
		if (((6081 - 3027) <= (5946 - (1813 + 118))) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) then
			if (((1368 + 503) < (4599 - (841 + 376))) and v24(v103.WildgrowthFocus, nil, true)) then
				return "wildgrowth ramp";
			end
		end
		if (((1810 - 517) <= (504 + 1662)) and v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) then
			if (v24(v103.InnervatePlayer, nil, nil, true) or ((7039 - 4460) < (982 - (464 + 395)))) then
				return "innervate ramp";
			end
		end
		if ((v13:BuffUp(v100.Innervate) and (v129() > (0 - 0)) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((407 + 439) >= (3205 - (467 + 370)))) then
			if (v24(v103.RejuvenationMouseover) or ((8290 - 4278) <= (2465 + 893))) then
				return "rejuvenation_cycle ramp";
			end
		end
	end
	local function v139()
		if (((5121 - 3627) <= (469 + 2536)) and v36) then
			local v172 = 0 - 0;
			while true do
				if (((523 - (150 + 370)) == v172) or ((4393 - (74 + 1208)) == (5248 - 3114))) then
					if (((11168 - 8813) == (1676 + 679)) and (v67 == "Anyone")) then
						if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) or ((978 - (14 + 376)) <= (748 - 316))) then
							if (((3104 + 1693) >= (3422 + 473)) and v24(v103.IronBarkFocus)) then
								return "iron_bark healing";
							end
						end
					elseif (((3412 + 165) == (10480 - 6903)) and (v67 == "Tank Only")) then
						if (((2855 + 939) > (3771 - (23 + 55))) and v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v99.UnitGroupRole(v16) == "TANK")) then
							if (v24(v103.IronBarkFocus) or ((3021 - 1746) == (2736 + 1364))) then
								return "iron_bark healing";
							end
						end
					elseif ((v67 == "Tank and Self") or ((1429 + 162) >= (5550 - 1970))) then
						if (((310 + 673) <= (2709 - (652 + 249))) and v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v99.UnitGroupRole(v16) == "TANK") or (v99.UnitGroupRole(v16) == "HEALER"))) then
							if (v24(v103.IronBarkFocus) or ((5753 - 3603) <= (3065 - (708 + 1160)))) then
								return "iron_bark healing";
							end
						end
					end
					if (((10230 - 6461) >= (2138 - 965)) and v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) then
						if (((1512 - (10 + 17)) == (334 + 1151)) and v24(v103.AdaptiveSwarmFocus)) then
							return "adaptive_swarm healing";
						end
					end
					if ((v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (1733 - (1400 + 332))) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (28 - 13)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((5223 - (242 + 1666)) <= (1191 + 1591))) then
						if (v24(v103.LifebloomFocus) or ((322 + 554) >= (2527 + 437))) then
							return "lifebloom healing";
						end
					end
					if ((v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (941 - (850 + 90))) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (25 - 10)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((3622 - (360 + 1030)) > (2210 + 287))) then
						if (v24(v103.LifebloomFocus) or ((5955 - 3845) <= (456 - 124))) then
							return "lifebloom healing";
						end
					end
					v172 = 1665 - (909 + 752);
				end
				if (((4909 - (109 + 1114)) > (5806 - 2634)) and ((1 + 1) == v172)) then
					if ((v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63, v100.Regrowth)) or ((4716 - (6 + 236)) < (517 + 303))) then
						if (((3445 + 834) >= (6796 - 3914)) and v24(v100.ConvokeTheSpirits)) then
							return "convoke_the_spirits healing";
						end
					end
					if ((v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) or ((3543 - 1514) >= (4654 - (1076 + 57)))) then
						if (v24(v103.CenarionWardFocus) or ((335 + 1702) >= (5331 - (579 + 110)))) then
							return "cenarion_ward healing";
						end
					end
					if (((136 + 1584) < (3942 + 516)) and v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) then
						if (v24(v103.RegrowthFocus) or ((232 + 204) > (3428 - (174 + 233)))) then
							return "regrowth_swiftness healing";
						end
					end
					if (((1991 - 1278) <= (1486 - 639)) and v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) then
						if (((958 + 1196) <= (5205 - (663 + 511))) and v24(v100.NaturesSwiftness)) then
							return "natures_swiftness healing";
						end
					end
					v172 = 3 + 0;
				end
				if (((1002 + 3613) == (14228 - 9613)) and (v172 == (1 + 0))) then
					if ((v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (11 - 6)) and v99.AreUnitsBelowHealthPercentage(v57, v58, v100.Regrowth)) or ((9174 - 5384) == (239 + 261))) then
						if (((172 - 83) < (158 + 63)) and v24(v103.GroveGuardiansFocus, nil, nil)) then
							return "grove_guardians healing";
						end
					end
					if (((188 + 1866) >= (2143 - (478 + 244))) and v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (521 - (440 + 77))) and v99.AreUnitsBelowHealthPercentage(v65, v66, v100.Regrowth)) then
						if (((315 + 377) < (11192 - 8134)) and v24(v100.Flourish, nil, nil, true)) then
							return "flourish healing";
						end
					end
					if ((v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85, v100.Regrowth)) or ((4810 - (655 + 901)) == (307 + 1348))) then
						if (v24(v100.Tranquility, nil, true) or ((993 + 303) == (3316 + 1594))) then
							return "tranquility healing";
						end
					end
					if (((13568 - 10200) == (4813 - (695 + 750))) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88, v100.Regrowth)) then
						if (((9024 - 6381) < (5887 - 2072)) and v24(v100.Tranquility, nil, true)) then
							return "tranquility_tree healing";
						end
					end
					v172 = 7 - 5;
				end
				if (((2264 - (285 + 66)) > (1149 - 656)) and (v172 == (1314 - (682 + 628)))) then
					if (((767 + 3988) > (3727 - (176 + 123))) and (v54 == "Player")) then
						if (((578 + 803) <= (1719 + 650)) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (284 - (239 + 30)))) then
							if (v24(v103.EfflorescencePlayer) or ((1317 + 3526) == (3926 + 158))) then
								return "efflorescence healing player";
							end
						end
					elseif (((8263 - 3594) > (1132 - 769)) and (v54 == "Cursor")) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (330 - (306 + 9)))) or ((6549 - 4672) >= (546 + 2592))) then
							if (((2910 + 1832) >= (1746 + 1880)) and v24(v103.EfflorescenceCursor)) then
								return "efflorescence healing cursor";
							end
						end
					elseif ((v54 == "Confirmation") or ((12982 - 8442) == (2291 - (1140 + 235)))) then
						if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (10 + 5))) or ((1061 + 95) > (1116 + 3229))) then
							if (((2289 - (33 + 19)) < (1535 + 2714)) and v24(v100.Efflorescence)) then
								return "efflorescence healing confirmation";
							end
						end
					end
					if ((v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94, v100.Regrowth) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) or ((8041 - 5358) < (11 + 12))) then
						if (((1366 - 669) <= (775 + 51)) and v24(v103.WildgrowthFocus, nil, true)) then
							return "wildgrowth healing";
						end
					end
					if (((1794 - (586 + 103)) <= (108 + 1068)) and v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) then
						if (((10402 - 7023) <= (5300 - (1309 + 179))) and v24(v103.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					if ((v13:BuffUp(v100.Innervate) and (v129() > (0 - 0)) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((343 + 445) >= (4339 - 2723))) then
						if (((1401 + 453) <= (7178 - 3799)) and v24(v103.RejuvenationMouseover)) then
							return "rejuvenation_cycle healing";
						end
					end
					v172 = 9 - 4;
				end
				if (((5158 - (295 + 314)) == (11172 - 6623)) and (v172 == (1967 - (1300 + 662)))) then
					if ((v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) or ((9489 - 6467) >= (4779 - (1178 + 577)))) then
						if (((2504 + 2316) > (6497 - 4299)) and v24(v103.RejuvenationFocus)) then
							return "rejuvenation healing";
						end
					end
					if ((v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) or ((2466 - (851 + 554)) >= (4326 + 565))) then
						if (((3782 - 2418) <= (9714 - 5241)) and v24(v103.RegrowthFocus, nil, true)) then
							return "regrowth healing";
						end
					end
					break;
				end
				if ((v172 == (302 - (115 + 187))) or ((2754 + 841) <= (3 + 0))) then
					if (v38 or ((18410 - 13738) == (5013 - (160 + 1001)))) then
						local v236 = v131();
						if (((1364 + 195) == (1076 + 483)) and v236) then
							return v236;
						end
					end
					if ((v53 and v31 and v13:AffectingCombat() and (v128() > (5 - 2)) and v100.NaturesVigil:IsReady()) or ((2110 - (237 + 121)) <= (1685 - (525 + 372)))) then
						if (v24(v100.NaturesVigil, nil, nil, true) or ((7407 - 3500) == (581 - 404))) then
							return "natures_vigil healing";
						end
					end
					if (((3612 - (96 + 46)) > (1332 - (643 + 134))) and v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) then
						if (v24(v103.SwiftmendFocus) or ((351 + 621) == (1546 - 901))) then
							return "swiftmend healing";
						end
					end
					if (((11813 - 8631) >= (2029 + 86)) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91, v100.Regrowth)) then
						if (((7639 - 3746) < (9053 - 4624)) and v24(v103.WildgrowthFocus, nil, true)) then
							return "wildgrowth_sotf healing";
						end
					end
					v172 = 720 - (316 + 403);
				end
			end
		end
	end
	local function v140()
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (5 - 3)) or ((1037 + 1830) < (4797 - 2892))) then
				v163 = v139();
				if (v163 or ((1273 + 523) >= (1306 + 2745))) then
					return v163;
				end
				v162 = 10 - 7;
			end
			if (((7732 - 6113) <= (7802 - 4046)) and (v162 == (0 + 0))) then
				if (((1188 - 584) == (30 + 574)) and (v44 or v43) and v32) then
					local v218 = 0 - 0;
					local v219;
					while true do
						if ((v218 == (17 - (12 + 5))) or ((17415 - 12931) == (1920 - 1020))) then
							v219 = v136();
							if (v219 or ((9478 - 5019) <= (2760 - 1647))) then
								return v219;
							end
							break;
						end
					end
				end
				v163 = v137();
				v162 = 1 + 0;
			end
			if (((5605 - (1656 + 317)) > (3028 + 370)) and (v162 == (1 + 0))) then
				if (((10853 - 6771) <= (24199 - 19282)) and v163) then
					return v163;
				end
				if (((5186 - (5 + 349)) >= (6583 - 5197)) and v33) then
					local v220 = 1271 - (266 + 1005);
					local v221;
					while true do
						if (((91 + 46) == (467 - 330)) and (v220 == (0 - 0))) then
							v221 = v138();
							if (v221 or ((3266 - (561 + 1135)) >= (5644 - 1312))) then
								return v221;
							end
							break;
						end
					end
				end
				v162 = 6 - 4;
			end
			if ((v162 == (1069 - (507 + 559))) or ((10197 - 6133) <= (5625 - 3806))) then
				if ((v99.TargetIsValid() and v34) or ((5374 - (212 + 176)) < (2479 - (250 + 655)))) then
					v163 = v134();
					if (((12069 - 7643) > (299 - 127)) and v163) then
						return v163;
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v164 = 0 - 0;
		while true do
			if (((2542 - (1869 + 87)) > (1578 - 1123)) and ((1902 - (484 + 1417)) == v164)) then
				if (((1770 - 944) == (1383 - 557)) and v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) then
					if (v24(v103.MarkOfTheWildPlayer) or ((4792 - (48 + 725)) > (7254 - 2813))) then
						return "mark_of_the_wild";
					end
				end
				if (((5411 - 3394) < (2477 + 1784)) and v99.TargetIsValid()) then
					if (((12603 - 7887) > (23 + 57)) and v100.Rake:IsReady() and (v13:StealthUp(false, true))) then
						if (v24(v100.Rake, not v15:IsInMeleeRange(3 + 7)) or ((4360 - (152 + 701)) == (4583 - (430 + 881)))) then
							return "rake";
						end
					end
				end
				v164 = 1 + 1;
			end
			if (((895 - (557 + 338)) == v164) or ((259 + 617) >= (8665 - 5590))) then
				if (((15239 - 10887) > (6785 - 4231)) and (v44 or v43) and v32) then
					local v222 = 0 - 0;
					local v223;
					while true do
						if ((v222 == (801 - (499 + 302))) or ((5272 - (39 + 827)) < (11160 - 7117))) then
							v223 = v136();
							if (v223 or ((4218 - 2329) >= (13436 - 10053))) then
								return v223;
							end
							break;
						end
					end
				end
				if (((2904 - 1012) <= (235 + 2499)) and v29 and v36) then
					local v224 = 0 - 0;
					local v225;
					while true do
						if (((308 + 1615) < (3509 - 1291)) and (v224 == (104 - (103 + 1)))) then
							v225 = v139();
							if (((2727 - (475 + 79)) > (818 - 439)) and v225) then
								return v225;
							end
							break;
						end
					end
				end
				v164 = 3 - 2;
			end
			if ((v164 == (1 + 1)) or ((2281 + 310) == (4912 - (1395 + 108)))) then
				if (((13135 - 8621) > (4528 - (7 + 1197))) and v99.TargetIsValid() and v34) then
					local v226 = v134();
					if (v226 or ((91 + 117) >= (1685 + 3143))) then
						return v226;
					end
				end
				break;
			end
		end
	end
	local function v142()
		local v165 = 319 - (27 + 292);
		while true do
			if ((v165 == (14 - 9)) or ((2018 - 435) > (14959 - 11392))) then
				v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (0 - 0);
				v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 - 0);
				v64 = EpicSettings.Settings['UseFlourish'];
				v65 = EpicSettings.Settings['FlourishHP'] or (139 - (43 + 96));
				v66 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
				v165 = 13 - 7;
			end
			if ((v165 == (0 + 0)) or ((371 + 942) == (1568 - 774))) then
				v37 = EpicSettings.Settings['UseRacials'];
				v38 = EpicSettings.Settings['UseTrinkets'];
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or "";
				v41 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v165 = 1 - 0;
			end
			if (((1000 + 2174) > (213 + 2689)) and (v165 == (1754 - (1414 + 337)))) then
				v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
				v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
				v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
				v55 = EpicSettings.Settings['EfflorescenceHP'] or (1940 - (1642 + 298));
				v56 = EpicSettings.Settings['UseGroveGuardians'];
				v165 = 10 - 6;
			end
			if (((11852 - 7732) <= (12641 - 8381)) and (v165 == (2 + 2))) then
				v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 + 0);
				v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (972 - (357 + 615));
				v59 = EpicSettings.Settings['UseCenarionWard'];
				v60 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
				v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
				v165 = 11 - 6;
			end
			if ((v165 == (6 + 0)) or ((1892 - 1009) > (3822 + 956))) then
				v67 = EpicSettings.Settings['IronBarkUsage'] or "";
				v68 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
				break;
			end
			if ((v165 == (2 + 0)) or ((4921 - (384 + 917)) >= (5588 - (128 + 569)))) then
				v47 = EpicSettings.Settings['HandleCharredTreant'];
				v48 = EpicSettings.Settings['HandleCharredBrambles'];
				v49 = EpicSettings.Settings['InterruptWithStun'];
				v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v51 = EpicSettings.Settings['InterruptThreshold'] or (1543 - (1407 + 136));
				v165 = 1890 - (687 + 1200);
			end
			if (((5968 - (556 + 1154)) > (3296 - 2359)) and (v165 == (96 - (9 + 86)))) then
				v42 = EpicSettings.Settings['UseMarkOfTheWild'];
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v45 = EpicSettings.Settings['UseHealthstone'];
				v46 = EpicSettings.Settings['HealthstoneHP'] or (421 - (275 + 146));
				v165 = 1 + 1;
			end
		end
	end
	local function v143()
		local v166 = 64 - (29 + 35);
		while true do
			if ((v166 == (13 - 10)) or ((14542 - 9673) < (3999 - 3093))) then
				v81 = EpicSettings.Settings['UseSwiftmend'];
				v82 = EpicSettings.Settings['SwiftmendHP'] or (0 + 0);
				v83 = EpicSettings.Settings['UseTranquility'];
				v84 = EpicSettings.Settings['TranquilityHP'] or (1012 - (53 + 959));
				v166 = 412 - (312 + 96);
			end
			if ((v166 == (0 - 0)) or ((1510 - (147 + 138)) > (5127 - (813 + 86)))) then
				v69 = EpicSettings.Settings['UseLifebloomTank'];
				v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 + 0);
				v71 = EpicSettings.Settings['UseLifebloom'];
				v72 = EpicSettings.Settings['LifebloomHP'] or (0 - 0);
				v166 = 493 - (18 + 474);
			end
			if (((1123 + 2205) > (7304 - 5066)) and (v166 == (1087 - (860 + 226)))) then
				v73 = EpicSettings.Settings['UseNaturesSwiftness'];
				v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (303 - (121 + 182));
				v75 = EpicSettings.Settings['UseRegrowth'];
				v76 = EpicSettings.Settings['RegrowthHP'] or (0 + 0);
				v166 = 1242 - (988 + 252);
			end
			if (((434 + 3405) > (441 + 964)) and (v166 == (1977 - (49 + 1921)))) then
				v97 = EpicSettings.Settings['RenewalHP'] or (890 - (223 + 667));
				v98 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if ((v166 == (58 - (51 + 1))) or ((2225 - 932) <= (1085 - 578))) then
				v93 = EpicSettings.Settings['WildgrowthHP'] or (1125 - (146 + 979));
				v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 + 0);
				v95 = EpicSettings.Settings['BarkskinHP'] or (605 - (311 + 294));
				v96 = EpicSettings.Settings['UseBarkskin'];
				v166 = 19 - 12;
			end
			if ((v166 == (1 + 1)) or ((4339 - (496 + 947)) < (2163 - (1233 + 125)))) then
				v77 = EpicSettings.Settings['UseRegrowthRefresh'];
				v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 + 0);
				v79 = EpicSettings.Settings['UseRejuvenation'];
				v80 = EpicSettings.Settings['RejuvenationHP'] or (0 + 0);
				v166 = 1 + 2;
			end
			if (((3961 - (963 + 682)) == (1933 + 383)) and (v166 == (1508 - (504 + 1000)))) then
				v85 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
				v86 = EpicSettings.Settings['UseTranquilityTree'];
				v87 = EpicSettings.Settings['TranquilityTreeHP'] or (0 + 0);
				v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (0 + 0);
				v166 = 7 - 2;
			end
			if ((v166 == (5 + 0)) or ((1495 + 1075) == (1715 - (156 + 26)))) then
				v89 = EpicSettings.Settings['UseWildgrowthSotF'];
				v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (0 + 0);
				v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 - 0);
				v92 = EpicSettings.Settings['UseWildgrowth'];
				v166 = 170 - (149 + 15);
			end
		end
	end
	local function v144()
		local v167 = 960 - (890 + 70);
		while true do
			if ((v167 == (117 - (39 + 78))) or ((1365 - (14 + 468)) == (3210 - 1750))) then
				v142();
				v143();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v167 = 2 - 1;
			end
			if ((v167 == (1 + 0)) or ((2774 + 1845) <= (213 + 786))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['ramp'];
				v34 = EpicSettings.Toggles['dps'];
				v167 = 1 + 1;
			end
			if ((v167 == (1 + 1)) or ((6527 - 3117) > (4069 + 47))) then
				v35 = EpicSettings.Toggles['dpsform'];
				v36 = EpicSettings.Toggles['healing'];
				if (v13:IsDeadOrGhost() or ((3172 - 2269) >= (78 + 2981))) then
					return;
				end
				if (v13:AffectingCombat() or v43 or ((4027 - (12 + 39)) < (2658 + 199))) then
					local v227 = v43 and v100.NaturesCure:IsReady() and v32;
					if (((15260 - 10330) > (8216 - 5909)) and v99.IsTankBelowHealthPercentage(v68, 6 + 14, v100.Regrowth) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) then
						local v237 = v99.FocusUnit(v227, nil, nil, "TANK", 11 + 9, v100.Regrowth);
						if (v237 or ((10259 - 6213) < (860 + 431))) then
							return v237;
						end
					elseif (((v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) or ((20495 - 16254) == (5255 - (1596 + 114)))) then
						local v240 = 0 - 0;
						local v241;
						while true do
							if ((v240 == (713 - (164 + 549))) or ((5486 - (1059 + 379)) > (5254 - 1022))) then
								v241 = v99.FocusUnit(v227, nil, nil, "HEALER", 11 + 9, v100.Regrowth);
								if (v241 or ((295 + 1455) >= (3865 - (145 + 247)))) then
									return v241;
								end
								break;
							end
						end
					else
						local v242 = v99.FocusUnit(v227, nil, nil, nil, 17 + 3, v100.Regrowth);
						if (((1463 + 1703) == (9385 - 6219)) and v242) then
							return v242;
						end
					end
				end
				v167 = 1 + 2;
			end
			if (((1519 + 244) < (6046 - 2322)) and (v167 == (725 - (254 + 466)))) then
				if (((617 - (544 + 16)) <= (8653 - 5930)) and v36 and (v13:AffectingCombat() or v29)) then
					local v228 = 628 - (294 + 334);
					local v229;
					while true do
						if ((v228 == (253 - (236 + 17))) or ((893 + 1177) == (345 + 98))) then
							v229 = v138();
							if (v229 or ((10187 - 7482) == (6595 - 5202))) then
								return v229;
							end
							v228 = 1 + 0;
						end
						if ((v228 == (1 + 0)) or ((5395 - (413 + 381)) < (3 + 58))) then
							v229 = v139();
							if (v229 or ((2956 - 1566) >= (12322 - 7578))) then
								return v229;
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((3973 - (582 + 1388)) > (6532 - 2698))) then
					if (v13:AffectingCombat() or ((112 + 44) > (4277 - (326 + 38)))) then
						local v238 = 0 - 0;
						local v239;
						while true do
							if (((278 - 83) == (815 - (47 + 573))) and (v238 == (0 + 0))) then
								v239 = v140();
								if (((13187 - 10082) >= (2914 - 1118)) and v239) then
									return v239;
								end
								break;
							end
						end
					elseif (((6043 - (1269 + 395)) >= (2623 - (76 + 416))) and v29) then
						local v243 = v141();
						if (((4287 - (319 + 124)) >= (4669 - 2626)) and v243) then
							return v243;
						end
					end
				end
				break;
			end
			if ((v167 == (1011 - (564 + 443))) or ((8947 - 5715) <= (3189 - (337 + 121)))) then
				if (((14372 - 9467) == (16339 - 11434)) and (v99.TargetIsValid() or v13:AffectingCombat())) then
					local v230 = 1911 - (1261 + 650);
					while true do
						if ((v230 == (0 + 0)) or ((6590 - 2454) >= (6228 - (772 + 1045)))) then
							v107 = v9.BossFightRemains(nil, true);
							v108 = v107;
							v230 = 1 + 0;
						end
						if ((v230 == (145 - (102 + 42))) or ((4802 - (1524 + 320)) == (5287 - (1049 + 221)))) then
							if (((1384 - (18 + 138)) >= (1989 - 1176)) and (v108 == (12213 - (67 + 1035)))) then
								v108 = v9.FightRemains(v105, false);
							end
							break;
						end
					end
				end
				if (v47 or ((3803 - (136 + 212)) > (17210 - 13160))) then
					local v231 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 33 + 7);
					if (((225 + 18) == (1847 - (240 + 1364))) and v231) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 1122 - (1050 + 32), true);
					if (v231 or ((967 - 696) > (930 + 642))) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 1095 - (331 + 724));
					if (((222 + 2517) < (3937 - (269 + 375))) and v231) then
						return v231;
					end
					local v231 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 765 - (267 + 458), true);
					if (v231 or ((1226 + 2716) < (2180 - 1046))) then
						return v231;
					end
				end
				if (v48 or ((3511 - (667 + 151)) == (6470 - (1410 + 87)))) then
					local v232 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 1937 - (1504 + 393));
					if (((5800 - 3654) == (5567 - 3421)) and v232) then
						return v232;
					end
					local v232 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 836 - (461 + 335), true);
					if (v232 or ((287 + 1957) == (4985 - (1730 + 31)))) then
						return v232;
					end
					local v232 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 1707 - (728 + 939));
					if (v232 or ((17368 - 12464) <= (3885 - 1969))) then
						return v232;
					end
					local v232 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 91 - 51, true);
					if (((1158 - (138 + 930)) <= (974 + 91)) and v232) then
						return v232;
					end
				end
				if (((3755 + 1047) == (4116 + 686)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) then
					local v233 = v99.DeadFriendlyUnitsCount();
					if (v13:AffectingCombat() or ((9309 - 7029) <= (2277 - (459 + 1307)))) then
						if (v100.Rebirth:IsReady() or ((3546 - (474 + 1396)) <= (808 - 345))) then
							if (((3627 + 242) == (13 + 3856)) and v24(v100.Rebirth, nil, true)) then
								return "rebirth";
							end
						end
					elseif (((3316 - 2158) <= (332 + 2281)) and (v233 > (3 - 2))) then
						if (v24(v100.Revitalize, nil, true) or ((10309 - 7945) <= (2590 - (562 + 29)))) then
							return "revitalize";
						end
					elseif (v24(v100.Revive, not v15:IsInRange(35 + 5), true) or ((6341 - (374 + 1045)) < (154 + 40))) then
						return "revive";
					end
				end
				v167 = 15 - 10;
			end
			if ((v167 == (641 - (448 + 190))) or ((676 + 1415) < (14 + 17))) then
				if (v13:IsMounted() or ((1584 + 846) >= (18731 - 13859))) then
					return;
				end
				if (v13:IsMoving() or ((14821 - 10051) < (3229 - (1307 + 187)))) then
					v104 = GetTime();
				end
				if (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm) or ((17602 - 13163) <= (5502 - 3152))) then
					if (((GetTime() - v104) < (2 - 1)) or ((5162 - (232 + 451)) < (4265 + 201))) then
						return;
					end
				end
				if (((2250 + 297) > (1789 - (510 + 54))) and v30) then
					v105 = v15:GetEnemiesInSplashRange(15 - 7);
					v106 = #v105;
				else
					local v234 = 36 - (13 + 23);
					while true do
						if (((9105 - 4434) > (3842 - 1168)) and ((0 - 0) == v234)) then
							v105 = {};
							v106 = 1089 - (830 + 258);
							break;
						end
					end
				end
				v167 = 14 - 10;
			end
		end
	end
	local function v145()
		v22.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v119();
	end
	v22.SetAPL(66 + 39, v144, v145);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

