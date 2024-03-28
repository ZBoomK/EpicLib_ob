local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((879 + 27) >= (2741 - (409 + 103)))) then
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
	local v104 = 236 - (46 + 190);
	local v105, v106;
	local v107 = 11206 - (51 + 44);
	local v108 = 3134 + 7977;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = false;
	local v116 = v13:GetEquipment();
	local v117 = (v116[1330 - (1114 + 203)] and v20(v116[739 - (228 + 498)])) or v20(0 + 0);
	local v118 = (v116[8 + 6] and v20(v116[677 - (174 + 489)])) or v20(0 - 0);
	v9:RegisterForEvent(function()
		v116 = v13:GetEquipment();
		v117 = (v116[1918 - (830 + 1075)] and v20(v116[537 - (303 + 221)])) or v20(1269 - (231 + 1038));
		v118 = (v116[12 + 2] and v20(v116[1176 - (171 + 991)])) or v20(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 0 - 0;
		while true do
			if (((3213 - 1925) > (1002 + 249)) and (v146 == (0 - 0))) then
				v107 = 32052 - 20941;
				v108 = 17910 - 6799;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v119()
		if (v100.ImprovedNaturesCure:IsAvailable() or ((13950 - 9437) < (4600 - (111 + 1137)))) then
			local v190 = 158 - (91 + 67);
			while true do
				if ((v190 == (0 - 0)) or ((516 + 1549) >= (3719 - (423 + 100)))) then
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
		v113 = (not v109 and (((v100.Starfire:Count() == (0 + 0)) and (v100.Wrath:Count() > (771 - (326 + 445)))) or v13:IsCasting(v100.Wrath))) or v112;
		v114 = (not v109 and (((v100.Wrath:Count() == (0 - 0)) and (v100.Starfire:Count() > (0 - 0))) or v13:IsCasting(v100.Starfire))) or v111;
		v115 = not v109 and (v100.Wrath:Count() > (0 - 0)) and (v100.Starfire:Count() > (711 - (530 + 181)));
	end
	local function v122(v147)
		return v147:DebuffRefreshable(v100.SunfireDebuff) and (v108 > (886 - (614 + 267)));
	end
	local function v123(v148)
		return (v148:DebuffRefreshable(v100.MoonfireDebuff) and (v108 > (44 - (19 + 13))) and ((((v106 <= (6 - 2)) or (v13:Energy() < (116 - 66))) and v13:BuffDown(v100.HeartOfTheWild)) or (((v106 <= (11 - 7)) or (v13:Energy() < (13 + 37))) and v13:BuffUp(v100.HeartOfTheWild))) and v148:DebuffDown(v100.MoonfireDebuff)) or (v13:PrevGCD(1 - 0, v100.Sunfire) and ((v148:DebuffUp(v100.MoonfireDebuff) and (v148:DebuffRemains(v100.MoonfireDebuff) < (v148:DebuffDuration(v100.MoonfireDebuff) * (0.8 - 0)))) or v148:DebuffDown(v100.MoonfireDebuff)) and (v106 == (1813 - (1293 + 519))));
	end
	local function v124(v149)
		return v149:DebuffRefreshable(v100.MoonfireDebuff) and (v149:TimeToDie() > (10 - 5));
	end
	local function v125(v150)
		return ((v150:DebuffRefreshable(v100.Rip) or ((v13:Energy() > (234 - 144)) and (v150:DebuffRemains(v100.Rip) <= (19 - 9)))) and (((v13:ComboPoints() == (21 - 16)) and (v150:TimeToDie() > (v150:DebuffRemains(v100.Rip) + (56 - 32)))) or (((v150:DebuffRemains(v100.Rip) + (v13:ComboPoints() * (3 + 1))) < v150:TimeToDie()) and ((v150:DebuffRemains(v100.Rip) + 1 + 3 + (v13:ComboPoints() * (9 - 5))) > v150:TimeToDie())))) or (v150:DebuffDown(v100.Rip) and (v13:ComboPoints() > (1 + 1 + (v106 * (1 + 1)))));
	end
	local function v126(v151)
		return (v151:DebuffDown(v100.RakeDebuff) or v151:DebuffRefreshable(v100.RakeDebuff)) and (v151:TimeToDie() > (7 + 3)) and (v13:ComboPoints() < (1101 - (709 + 387)));
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
		local v154 = 1858 - (673 + 1185);
		local v155;
		while true do
			if ((v154 == (2 - 1)) or ((14051 - 9675) <= (2436 - 955))) then
				v155 = v99.HandleBottomTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 29 + 11, nil);
				if (v155 or ((2535 + 857) >= (6400 - 1659))) then
					return v155;
				end
				break;
			end
			if (((817 + 2508) >= (4294 - 2140)) and (v154 == (0 - 0))) then
				v155 = v99.HandleTopTrinket(v102, v31 and (v13:BuffUp(v100.HeartOfTheWild) or v13:BuffUp(v100.IncarnationBuff)), 1920 - (446 + 1434), nil);
				if (v155 or ((2578 - (1040 + 243)) >= (9649 - 6416))) then
					return v155;
				end
				v154 = 1848 - (559 + 1288);
			end
		end
	end
	local function v132()
		local v156 = 1931 - (609 + 1322);
		while true do
			if (((4831 - (13 + 441)) > (6135 - 4493)) and (v156 == (10 - 6))) then
				if (((23522 - 18799) > (51 + 1305)) and v100.Rip:IsAvailable() and v100.Rip:IsReady() and (v106 < (39 - 28)) and v125(v15)) then
					if (v24(v100.Rip, not v15:IsInMeleeRange(2 + 3)) or ((1813 + 2323) <= (10187 - 6754))) then
						return "rip cat 34";
					end
				end
				if (((2323 + 1922) <= (8517 - 3886)) and v100.Thrash:IsReady() and (v106 >= (2 + 0)) and v15:DebuffRefreshable(v100.ThrashDebuff)) then
					if (((2379 + 1897) >= (2813 + 1101)) and v24(v100.Thrash, not v15:IsInMeleeRange(7 + 1))) then
						return "thrash cat";
					end
				end
				if (((194 + 4) <= (4798 - (153 + 280))) and v100.Rake:IsReady() and v126(v15)) then
					if (((13808 - 9026) > (4199 + 477)) and v24(v100.Rake, not v15:IsInMeleeRange(2 + 3))) then
						return "rake cat 36";
					end
				end
				v156 = 3 + 2;
			end
			if (((4414 + 450) > (1592 + 605)) and (v156 == (4 - 1))) then
				if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (19 + 11)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild) and v15:DebuffUp(v100.SunfireDebuff) and (v15:DebuffUp(v100.MoonfireDebuff) or (v106 > (671 - (89 + 578))))) or ((2644 + 1056) == (5211 - 2704))) then
					if (((5523 - (572 + 477)) >= (37 + 237)) and v24(v100.HeartOfTheWild)) then
						return "heart_of_the_wild cat 26";
					end
				end
				if ((v100.CatForm:IsReady() and v13:BuffDown(v100.CatForm) and (v13:Energy() >= (19 + 11)) and v35) or ((227 + 1667) <= (1492 - (84 + 2)))) then
					if (((2590 - 1018) >= (1103 + 428)) and v24(v100.CatForm)) then
						return "cat_form cat 28";
					end
				end
				if ((v100.FerociousBite:IsReady() and (((v13:ComboPoints() > (845 - (497 + 345))) and (v15:TimeToDie() < (1 + 9))) or ((v13:ComboPoints() == (1 + 4)) and (v13:Energy() >= (1358 - (605 + 728))) and (not v100.Rip:IsAvailable() or (v15:DebuffRemains(v100.Rip) > (4 + 1)))))) or ((10419 - 5732) < (209 + 4333))) then
					if (((12167 - 8876) > (1503 + 164)) and v24(v100.FerociousBite, not v15:IsInMeleeRange(13 - 8))) then
						return "ferocious_bite cat 32";
					end
				end
				v156 = 4 + 0;
			end
			if ((v156 == (489 - (457 + 32))) or ((371 + 502) == (3436 - (832 + 570)))) then
				if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((2653 + 163) < (3 + 8))) then
					if (((13089 - 9390) < (2267 + 2439)) and v24(v100.Rake, not v15:IsInMeleeRange(806 - (588 + 208)))) then
						return "rake cat 2";
					end
				end
				if (((7131 - 4485) >= (2676 - (884 + 916))) and v38 and not v13:StealthUp(false, true)) then
					local v225 = v131();
					if (((1285 - 671) <= (1847 + 1337)) and v225) then
						return v225;
					end
				end
				if (((3779 - (232 + 421)) == (5015 - (1569 + 320))) and v100.AdaptiveSwarm:IsCastable()) then
					if (v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm)) or ((537 + 1650) >= (942 + 4012))) then
						return "adaptive_swarm cat";
					end
				end
				v156 = 3 - 2;
			end
			if (((610 - (316 + 289)) == v156) or ((10148 - 6271) == (166 + 3409))) then
				if (((2160 - (666 + 787)) > (1057 - (360 + 65))) and v100.Rake:IsReady() and ((v13:ComboPoints() < (5 + 0)) or (v13:Energy() > (344 - (79 + 175)))) and (v15:PMultiplier(v100.Rake) <= v13:PMultiplier(v100.Rake)) and v127(v15)) then
					if (v24(v100.Rake, not v15:IsInMeleeRange(7 - 2)) or ((427 + 119) >= (8227 - 5543))) then
						return "rake cat 40";
					end
				end
				if (((2821 - 1356) <= (5200 - (503 + 396))) and v100.Swipe:IsReady() and (v106 >= (183 - (92 + 89)))) then
					if (((3305 - 1601) > (731 + 694)) and v24(v100.Swipe, not v15:IsInMeleeRange(5 + 3))) then
						return "swipe cat 38";
					end
				end
				if ((v100.Shred:IsReady() and ((v13:ComboPoints() < (19 - 14)) or (v13:Energy() > (13 + 77)))) or ((1566 - 879) == (3695 + 539))) then
					if (v24(v100.Shred, not v15:IsInMeleeRange(3 + 2)) or ((10142 - 6812) < (179 + 1250))) then
						return "shred cat 42";
					end
				end
				break;
			end
			if (((1748 - 601) >= (1579 - (485 + 759))) and (v156 == (4 - 2))) then
				if (((4624 - (442 + 747)) > (3232 - (832 + 303))) and v100.Sunfire:IsReady() and v15:DebuffDown(v100.SunfireDebuff) and (v15:TimeToDie() > (951 - (88 + 858)))) then
					if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((1150 + 2620) >= (3345 + 696))) then
						return "sunfire cat 24";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and v15:DebuffDown(v100.MoonfireDebuff) and (v15:TimeToDie() > (1 + 4))) or ((4580 - (766 + 23)) <= (7953 - 6342))) then
					if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((6260 - 1682) <= (5290 - 3282))) then
						return "moonfire cat 24";
					end
				end
				if (((3818 - 2693) <= (3149 - (1036 + 37))) and v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) then
					if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((527 + 216) >= (8566 - 4167))) then
						return "starsurge cat 26";
					end
				end
				v156 = 3 + 0;
			end
			if (((2635 - (641 + 839)) < (2586 - (910 + 3))) and (v156 == (2 - 1))) then
				if ((v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) or ((4008 - (1466 + 218)) <= (266 + 312))) then
					if (((4915 - (556 + 592)) == (1340 + 2427)) and v13:BuffUp(v100.CatForm)) then
						if (((4897 - (329 + 479)) == (4943 - (174 + 680))) and (v13:BuffUp(v100.HeartOfTheWild) or (v100.HeartOfTheWild:CooldownRemains() > (206 - 146)) or not v100.HeartOfTheWild:IsAvailable()) and (v13:Energy() < (103 - 53)) and (((v13:ComboPoints() < (4 + 1)) and (v15:DebuffRemains(v100.Rip) > (744 - (396 + 343)))) or (v106 > (1 + 0)))) then
							if (((5935 - (29 + 1448)) >= (3063 - (135 + 1254))) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(113 - 83))) then
								return "convoke_the_spirits cat 18";
							end
						end
					end
				end
				if (((4538 - 3566) <= (946 + 472)) and v100.Sunfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (1532 - (389 + 1138))) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (604 - (102 + 472))))) then
					if (v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover) or ((4660 + 278) < (2641 + 2121))) then
						return "sunfire cat 20";
					end
				end
				if ((v100.Moonfire:IsReady() and v13:BuffDown(v100.CatForm) and (v15:TimeToDie() > (5 + 0)) and (not v100.Rip:IsAvailable() or v15:DebuffUp(v100.Rip) or (v13:Energy() < (1575 - (320 + 1225))))) or ((4457 - 1953) > (2609 + 1655))) then
					if (((3617 - (157 + 1307)) == (4012 - (821 + 1038))) and v99.CastCycle(v100.Moonfire, v105, v123, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
						return "moonfire cat 22";
					end
				end
				v156 = 4 - 2;
			end
		end
	end
	local function v133()
		if ((v100.HeartOfTheWild:IsCastable() and v31 and ((v100.ConvokeTheSpirits:CooldownRemains() < (4 + 26)) or (v100.ConvokeTheSpirits:CooldownRemains() > (159 - 69)) or not v100.ConvokeTheSpirits:IsAvailable()) and v13:BuffDown(v100.HeartOfTheWild)) or ((189 + 318) >= (6421 - 3830))) then
			if (((5507 - (834 + 192)) == (285 + 4196)) and v24(v100.HeartOfTheWild)) then
				return "heart_of_the_wild owl 2";
			end
		end
		if ((v100.MoonkinForm:IsReady() and (v13:BuffDown(v100.MoonkinForm)) and v35) or ((598 + 1730) < (15 + 678))) then
			if (((6704 - 2376) == (4632 - (300 + 4))) and v24(v100.MoonkinForm)) then
				return "moonkin_form owl 4";
			end
		end
		if (((425 + 1163) >= (3486 - 2154)) and v100.Starsurge:IsReady() and ((v106 < (368 - (112 + 250))) or (not v111 and (v106 < (4 + 4)))) and v35) then
			if (v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge)) or ((10456 - 6282) > (2434 + 1814))) then
				return "starsurge owl 8";
			end
		end
		if ((v100.Moonfire:IsReady() and ((v106 < (3 + 2)) or (not v111 and (v106 < (6 + 1))))) or ((2274 + 2312) <= (61 + 21))) then
			if (((5277 - (1001 + 413)) == (8614 - 4751)) and v99.CastCycle(v100.Moonfire, v105, v124, not v15:IsSpellInRange(v100.Moonfire), nil, nil, v103.MoonfireMouseover)) then
				return "moonfire owl 10";
			end
		end
		if (v100.Sunfire:IsReady() or ((1164 - (244 + 638)) <= (735 - (627 + 66)))) then
			if (((13732 - 9123) >= (1368 - (512 + 90))) and v99.CastCycle(v100.Sunfire, v105, v122, not v15:IsSpellInRange(v100.Sunfire), nil, nil, v103.SunfireMouseover)) then
				return "sunfire owl 12";
			end
		end
		if ((v52 and v31 and v100.ConvokeTheSpirits:IsCastable()) or ((3058 - (1665 + 241)) == (3205 - (373 + 344)))) then
			if (((1544 + 1878) > (887 + 2463)) and v13:BuffUp(v100.MoonkinForm)) then
				if (((2313 - 1436) > (635 - 259)) and v24(v100.ConvokeTheSpirits, not v15:IsInRange(1129 - (35 + 1064)))) then
					return "convoke_the_spirits moonkin 18";
				end
			end
		end
		if ((v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(6 + 2)) and ((v112 and (v106 == (2 - 1))) or v113 or (v115 and (v106 > (1 + 0))))) or ((4354 - (298 + 938)) <= (3110 - (233 + 1026)))) then
			if (v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true) or ((1831 - (636 + 1030)) >= (1786 + 1706))) then
				return "wrath owl 14";
			end
		end
		if (((3858 + 91) < (1443 + 3413)) and v100.Starfire:IsReady()) then
			if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((289 + 3987) < (3237 - (55 + 166)))) then
				return "starfire owl 16";
			end
		end
	end
	local function v134()
		local v157 = 0 + 0;
		local v158;
		local v159;
		while true do
			if (((472 + 4218) > (15753 - 11628)) and (v157 == (299 - (36 + 261)))) then
				v159 = 0 - 0;
				if (v100.Rip:IsAvailable() or ((1418 - (34 + 1334)) >= (345 + 551))) then
					v159 = v159 + 1 + 0;
				end
				if (v100.Rake:IsAvailable() or ((2997 - (1035 + 248)) >= (2979 - (20 + 1)))) then
					v159 = v159 + 1 + 0;
				end
				v157 = 322 - (134 + 185);
			end
			if ((v157 == (1136 - (549 + 584))) or ((2176 - (314 + 371)) < (2210 - 1566))) then
				if (((1672 - (478 + 490)) < (523 + 464)) and v100.Thrash:IsAvailable()) then
					v159 = v159 + (1173 - (786 + 386));
				end
				if (((12042 - 8324) > (3285 - (1055 + 324))) and (v159 >= (1342 - (1093 + 247))) and v15:IsInMeleeRange(8 + 0)) then
					local v226 = 0 + 0;
					local v227;
					while true do
						if ((v226 == (0 - 0)) or ((3251 - 2293) > (10343 - 6708))) then
							v227 = v132();
							if (((8797 - 5296) <= (1598 + 2894)) and v227) then
								return v227;
							end
							break;
						end
					end
				end
				if (v100.AdaptiveSwarm:IsCastable() or ((13259 - 9817) < (8782 - 6234))) then
					if (((2168 + 707) >= (3743 - 2279)) and v24(v100.AdaptiveSwarm, not v15:IsSpellInRange(v100.AdaptiveSwarm))) then
						return "adaptive_swarm main";
					end
				end
				v157 = 692 - (364 + 324);
			end
			if ((v157 == (13 - 8)) or ((11510 - 6713) >= (1622 + 3271))) then
				if ((v100.Starsurge:IsReady() and (v13:BuffDown(v100.CatForm))) or ((2305 - 1754) > (3311 - 1243))) then
					if (((6420 - 4306) > (2212 - (1249 + 19))) and v24(v100.Starsurge, not v15:IsSpellInRange(v100.Starsurge))) then
						return "starsurge main 28";
					end
				end
				if ((v100.Starfire:IsReady() and (v106 > (2 + 0))) or ((8804 - 6542) >= (4182 - (686 + 400)))) then
					if (v24(v100.Starfire, not v15:IsSpellInRange(v100.Starfire), true) or ((1770 + 485) >= (3766 - (73 + 156)))) then
						return "starfire owl 16";
					end
				end
				if ((v100.Wrath:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(1 + 7))) or ((4648 - (721 + 90)) < (15 + 1291))) then
					if (((9578 - 6628) == (3420 - (224 + 246))) and v24(v100.Wrath, not v15:IsSpellInRange(v100.Wrath), true)) then
						return "wrath main 30";
					end
				end
				v157 = 9 - 3;
			end
			if ((v157 == (6 - 2)) or ((857 + 3866) < (79 + 3219))) then
				if (((835 + 301) >= (305 - 151)) and v100.MoonkinForm:IsAvailable()) then
					local v228 = v133();
					if (v228 or ((901 - 630) > (5261 - (203 + 310)))) then
						return v228;
					end
				end
				if (((6733 - (1238 + 755)) >= (221 + 2931)) and v100.Sunfire:IsReady() and (v15:DebuffRefreshable(v100.SunfireDebuff))) then
					if (v24(v100.Sunfire, not v15:IsSpellInRange(v100.Sunfire)) or ((4112 - (709 + 825)) >= (6246 - 2856))) then
						return "sunfire main 24";
					end
				end
				if (((59 - 18) <= (2525 - (196 + 668))) and v100.Moonfire:IsReady() and (v15:DebuffRefreshable(v100.MoonfireDebuff))) then
					if (((2372 - 1771) < (7374 - 3814)) and v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire))) then
						return "moonfire main 26";
					end
				end
				v157 = 838 - (171 + 662);
			end
			if (((328 - (4 + 89)) < (2407 - 1720)) and ((1 + 0) == v157)) then
				v158 = v99.InterruptWithStun(v100.MightyBash, 35 - 27);
				if (((1784 + 2765) > (2639 - (35 + 1451))) and v158) then
					return v158;
				end
				v121();
				v157 = 1455 - (28 + 1425);
			end
			if ((v157 == (1999 - (941 + 1052))) or ((4482 + 192) < (6186 - (822 + 692)))) then
				if (((5236 - 1568) < (2149 + 2412)) and v100.Moonfire:IsReady() and (v13:BuffDown(v100.CatForm) or not v15:IsInMeleeRange(305 - (45 + 252)))) then
					if (v24(v100.Moonfire, not v15:IsSpellInRange(v100.Moonfire)) or ((451 + 4) == (1241 + 2364))) then
						return "moonfire main 32";
					end
				end
				if (true or ((6480 - 3817) == (3745 - (114 + 319)))) then
					if (((6140 - 1863) <= (5734 - 1259)) and v24(v100.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v157 == (0 + 0)) or ((1296 - 426) == (2490 - 1301))) then
				v158 = v99.InterruptWithStun(v100.IncapacitatingRoar, 1971 - (556 + 1407));
				if (((2759 - (741 + 465)) <= (3598 - (170 + 295))) and v158) then
					return v158;
				end
				if ((v13:BuffUp(v100.CatForm) and (v13:ComboPoints() > (0 + 0))) or ((2055 + 182) >= (8644 - 5133))) then
					v158 = v99.InterruptWithStun(v100.Maim, 7 + 1);
					if (v158 or ((850 + 474) > (1711 + 1309))) then
						return v158;
					end
				end
				v157 = 1231 - (957 + 273);
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		if ((v16 and (v99.UnitHasDispellableDebuffByPlayer(v16) or v99.DispellableFriendlyUnit(11 + 14)) and v100.NaturesCure:IsReady()) or ((11400 - 8408) == (4956 - 3075))) then
			if (((9487 - 6381) > (7556 - 6030)) and (v135 == (1780 - (389 + 1391)))) then
				v135 = GetTime();
			end
			if (((1897 + 1126) < (403 + 3467)) and v99.Wait(1138 - 638, v135)) then
				if (((1094 - (783 + 168)) > (248 - 174)) and v24(v103.NaturesCureFocus)) then
					return "natures_cure dispel 2";
				end
				v135 = 0 + 0;
			end
		end
	end
	local function v137()
		local v160 = 311 - (309 + 2);
		while true do
			if (((55 - 37) < (3324 - (1090 + 122))) and (v160 == (0 + 0))) then
				if (((3684 - 2587) <= (1115 + 513)) and (v13:HealthPercentage() <= v95) and v96 and v100.Barkskin:IsReady()) then
					if (((5748 - (628 + 490)) == (831 + 3799)) and v24(v100.Barkskin, nil, nil, true)) then
						return "barkskin defensive 2";
					end
				end
				if (((8764 - 5224) > (12261 - 9578)) and (v13:HealthPercentage() <= v97) and v98 and v100.Renewal:IsReady()) then
					if (((5568 - (431 + 343)) >= (6614 - 3339)) and v24(v100.Renewal, nil, nil, true)) then
						return "renewal defensive 2";
					end
				end
				v160 = 2 - 1;
			end
			if (((1173 + 311) == (190 + 1294)) and (v160 == (1696 - (556 + 1139)))) then
				if (((1447 - (6 + 9)) < (651 + 2904)) and v101.Healthstone:IsReady() and v45 and (v13:HealthPercentage() <= v46)) then
					if (v24(v103.Healthstone, nil, nil, true) or ((546 + 519) > (3747 - (28 + 141)))) then
						return "healthstone defensive 3";
					end
				end
				if ((v39 and (v13:HealthPercentage() <= v41)) or ((1858 + 2937) < (1736 - 329))) then
					if (((1313 + 540) < (6130 - (486 + 831))) and (v40 == "Refreshing Healing Potion")) then
						if (v101.RefreshingHealingPotion:IsReady() or ((7340 - 4519) < (8558 - 6127))) then
							if (v24(v103.RefreshingHealingPotion, nil, nil, true) or ((544 + 2330) < (6896 - 4715))) then
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
		local v161 = 1263 - (668 + 595);
		while true do
			if ((v161 == (1 + 0)) or ((543 + 2146) <= (935 - 592))) then
				if ((v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady()) or ((2159 - (23 + 267)) == (3953 - (1129 + 815)))) then
					if (v24(v103.WildgrowthFocus, nil, true) or ((3933 - (371 + 16)) < (4072 - (1326 + 424)))) then
						return "wildgrowth ramp";
					end
				end
				if ((v100.Innervate:IsReady() and v13:BuffDown(v100.Innervate)) or ((3942 - 1860) == (17441 - 12668))) then
					if (((3362 - (88 + 30)) > (1826 - (720 + 51))) and v24(v103.InnervatePlayer, nil, nil, true)) then
						return "innervate ramp";
					end
				end
				v161 = 4 - 2;
			end
			if ((v161 == (1778 - (421 + 1355))) or ((5465 - 2152) <= (874 + 904))) then
				if ((v13:BuffUp(v100.Innervate) and (v129() > (1083 - (286 + 797))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((5194 - 3773) >= (3484 - 1380))) then
					if (((2251 - (397 + 42)) <= (1015 + 2234)) and v24(v103.RejuvenationMouseover)) then
						return "rejuvenation_cycle ramp";
					end
				end
				break;
			end
			if (((2423 - (24 + 776)) <= (3014 - 1057)) and (v161 == (785 - (222 + 563)))) then
				if (((9720 - 5308) == (3177 + 1235)) and v100.Swiftmend:IsReady() and not v130(v16) and v13:BuffDown(v100.SoulOfTheForestBuff)) then
					if (((1940 - (23 + 167)) >= (2640 - (690 + 1108))) and v24(v103.RejuvenationFocus)) then
						return "rejuvenation ramp";
					end
				end
				if (((1578 + 2794) > (1526 + 324)) and v100.Swiftmend:IsReady() and v130(v16)) then
					if (((1080 - (40 + 808)) < (136 + 685)) and v24(v103.SwiftmendFocus)) then
						return "swiftmend ramp";
					end
				end
				v161 = 3 - 2;
			end
		end
	end
	local function v139()
		if (((496 + 22) < (478 + 424)) and v36) then
			if (((1642 + 1352) > (1429 - (47 + 524))) and v38) then
				local v219 = 0 + 0;
				local v220;
				while true do
					if ((v219 == (0 - 0)) or ((5614 - 1859) <= (2086 - 1171))) then
						v220 = v131();
						if (((5672 - (1165 + 561)) > (112 + 3631)) and v220) then
							return v220;
						end
						break;
					end
				end
			end
			if ((v53 and v31 and v13:AffectingCombat() and (v128() > (9 - 6)) and v100.NaturesVigil:IsReady()) or ((510 + 825) >= (3785 - (341 + 138)))) then
				if (((1308 + 3536) > (4649 - 2396)) and v24(v100.NaturesVigil, nil, nil, true)) then
					return "natures_vigil healing";
				end
			end
			if (((778 - (89 + 237)) == (1453 - 1001)) and v100.Swiftmend:IsReady() and v81 and v13:BuffDown(v100.SoulOfTheForestBuff) and v130(v16) and (v16:HealthPercentage() <= v82)) then
				if (v24(v103.SwiftmendFocus) or ((9593 - 5036) < (2968 - (581 + 300)))) then
					return "swiftmend healing";
				end
			end
			if (((5094 - (855 + 365)) == (9201 - 5327)) and v13:BuffUp(v100.SoulOfTheForestBuff) and v100.Wildgrowth:IsReady() and v99.AreUnitsBelowHealthPercentage(v90, v91, v100.Regrowth)) then
				if (v24(v103.WildgrowthFocus, nil, true) or ((633 + 1305) > (6170 - (1030 + 205)))) then
					return "wildgrowth_sotf healing";
				end
			end
			if ((v56 and v100.GroveGuardians:IsReady() and (v100.GroveGuardians:TimeSinceLastCast() > (5 + 0)) and v99.AreUnitsBelowHealthPercentage(v57, v58, v100.Regrowth)) or ((3959 + 296) < (3709 - (156 + 130)))) then
				if (((3303 - 1849) <= (4197 - 1706)) and v24(v103.GroveGuardiansFocus, nil, nil)) then
					return "grove_guardians healing";
				end
			end
			if ((v13:AffectingCombat() and v31 and v100.Flourish:IsReady() and v13:BuffDown(v100.Flourish) and (v128() > (7 - 3)) and v99.AreUnitsBelowHealthPercentage(v65, v66, v100.Regrowth)) or ((1096 + 3061) <= (1635 + 1168))) then
				if (((4922 - (10 + 59)) >= (844 + 2138)) and v24(v100.Flourish, nil, nil, true)) then
					return "flourish healing";
				end
			end
			if (((20359 - 16225) > (4520 - (671 + 492))) and v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v99.AreUnitsBelowHealthPercentage(v84, v85, v100.Regrowth)) then
				if (v24(v100.Tranquility, nil, true) or ((2721 + 696) < (3749 - (369 + 846)))) then
					return "tranquility healing";
				end
			end
			if ((v13:AffectingCombat() and v31 and v100.Tranquility:IsReady() and v13:BuffUp(v100.IncarnationBuff) and v99.AreUnitsBelowHealthPercentage(v87, v88, v100.Regrowth)) or ((721 + 2001) <= (140 + 24))) then
				if (v24(v100.Tranquility, nil, true) or ((4353 - (1036 + 909)) < (1677 + 432))) then
					return "tranquility_tree healing";
				end
			end
			if ((v13:AffectingCombat() and v31 and v100.ConvokeTheSpirits:IsReady() and v99.AreUnitsBelowHealthPercentage(v62, v63, v100.Regrowth)) or ((55 - 22) == (1658 - (11 + 192)))) then
				if (v24(v100.ConvokeTheSpirits) or ((224 + 219) >= (4190 - (135 + 40)))) then
					return "convoke_the_spirits healing";
				end
			end
			if (((8193 - 4811) > (101 + 65)) and v100.CenarionWard:IsReady() and v59 and (v16:HealthPercentage() <= v60)) then
				if (v24(v103.CenarionWardFocus) or ((616 - 336) == (4585 - 1526))) then
					return "cenarion_ward healing";
				end
			end
			if (((2057 - (50 + 126)) > (3600 - 2307)) and v13:BuffUp(v100.NaturesSwiftness) and v100.Regrowth:IsCastable()) then
				if (((522 + 1835) == (3770 - (1233 + 180))) and v24(v103.RegrowthFocus)) then
					return "regrowth_swiftness healing";
				end
			end
			if (((1092 - (522 + 447)) == (1544 - (107 + 1314))) and v100.NaturesSwiftness:IsReady() and v73 and (v16:HealthPercentage() <= v74)) then
				if (v24(v100.NaturesSwiftness) or ((491 + 565) >= (10335 - 6943))) then
					return "natures_swiftness healing";
				end
			end
			if ((v67 == "Anyone") or ((460 + 621) < (2134 - 1059))) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68)) or ((4150 - 3101) >= (6342 - (716 + 1194)))) then
					if (v24(v103.IronBarkFocus) or ((82 + 4686) <= (91 + 755))) then
						return "iron_bark healing";
					end
				end
			elseif ((v67 == "Tank Only") or ((3861 - (74 + 429)) <= (2739 - 1319))) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and (v99.UnitGroupRole(v16) == "TANK")) or ((1854 + 1885) <= (6878 - 3873))) then
					if (v24(v103.IronBarkFocus) or ((1174 + 485) >= (6578 - 4444))) then
						return "iron_bark healing";
					end
				end
			elseif ((v67 == "Tank and Self") or ((8060 - 4800) < (2788 - (279 + 154)))) then
				if ((v100.IronBark:IsReady() and (v16:HealthPercentage() <= v68) and ((v99.UnitGroupRole(v16) == "TANK") or (v99.UnitGroupRole(v16) == "HEALER"))) or ((1447 - (454 + 324)) == (3323 + 900))) then
					if (v24(v103.IronBarkFocus) or ((1709 - (12 + 5)) < (318 + 270))) then
						return "iron_bark healing";
					end
				end
			end
			if ((v100.AdaptiveSwarm:IsCastable() and v13:AffectingCombat()) or ((12222 - 7425) < (1350 + 2301))) then
				if (v24(v103.AdaptiveSwarmFocus) or ((5270 - (277 + 816)) > (20724 - 15874))) then
					return "adaptive_swarm healing";
				end
			end
			if ((v13:AffectingCombat() and v69 and (v99.UnitGroupRole(v16) == "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, true, false) < (1184 - (1058 + 125))) and (v16:HealthPercentage() <= (v70 - (v26(v13:BuffUp(v100.CatForm)) * (3 + 12)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) or ((1375 - (815 + 160)) > (4766 - 3655))) then
				if (((7242 - 4191) > (240 + 765)) and v24(v103.LifebloomFocus)) then
					return "lifebloom healing";
				end
			end
			if (((10795 - 7102) <= (6280 - (41 + 1857))) and v13:AffectingCombat() and v71 and (v99.UnitGroupRole(v16) ~= "TANK") and (v99.FriendlyUnitsWithBuffCount(v100.Lifebloom, false, true) < (1894 - (1222 + 671))) and (v100.Undergrowth:IsAvailable() or v99.IsSoloMode()) and (v16:HealthPercentage() <= (v72 - (v26(v13:BuffUp(v100.CatForm)) * (38 - 23)))) and v100.Lifebloom:IsCastable() and v16:BuffRefreshable(v100.Lifebloom)) then
				if (v24(v103.LifebloomFocus) or ((4717 - 1435) > (5282 - (229 + 953)))) then
					return "lifebloom healing";
				end
			end
			if ((v54 == "Player") or ((5354 - (1111 + 663)) < (4423 - (874 + 705)))) then
				if (((13 + 76) < (3064 + 1426)) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (31 - 16))) then
					if (v24(v103.EfflorescencePlayer) or ((141 + 4842) < (2487 - (642 + 37)))) then
						return "efflorescence healing player";
					end
				end
			elseif (((874 + 2955) > (603 + 3166)) and (v54 == "Cursor")) then
				if (((3728 - 2243) <= (3358 - (233 + 221))) and v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (34 - 19))) then
					if (((3758 + 511) == (5810 - (718 + 823))) and v24(v103.EfflorescenceCursor)) then
						return "efflorescence healing cursor";
					end
				end
			elseif (((244 + 143) <= (3587 - (266 + 539))) and (v54 == "Confirmation")) then
				if ((v13:AffectingCombat() and (v100.Efflorescence:TimeSinceLastCast() > (42 - 27))) or ((3124 - (636 + 589)) <= (2176 - 1259))) then
					if (v24(v100.Efflorescence) or ((8893 - 4581) <= (695 + 181))) then
						return "efflorescence healing confirmation";
					end
				end
			end
			if (((811 + 1421) <= (3611 - (657 + 358))) and v100.Wildgrowth:IsReady() and v92 and v99.AreUnitsBelowHealthPercentage(v93, v94, v100.Regrowth) and (not v100.Swiftmend:IsAvailable() or not v100.Swiftmend:IsReady())) then
				if (((5547 - 3452) < (8397 - 4711)) and v24(v103.WildgrowthFocus, nil, true)) then
					return "wildgrowth healing";
				end
			end
			if ((v100.Regrowth:IsCastable() and v75 and (v16:HealthPercentage() <= v76)) or ((2782 - (1151 + 36)) >= (4321 + 153))) then
				if (v24(v103.RegrowthFocus, nil, true) or ((1215 + 3404) < (8606 - 5724))) then
					return "regrowth healing";
				end
			end
			if ((v13:BuffUp(v100.Innervate) and (v129() > (1832 - (1552 + 280))) and v17 and v17:Exists() and v17:BuffRefreshable(v100.Rejuvenation)) or ((1128 - (64 + 770)) >= (3280 + 1551))) then
				if (((4605 - 2576) <= (548 + 2536)) and v24(v103.RejuvenationMouseover)) then
					return "rejuvenation_cycle healing";
				end
			end
			if ((v100.Rejuvenation:IsCastable() and v79 and v16:BuffRefreshable(v100.Rejuvenation) and (v16:HealthPercentage() <= v80)) or ((3280 - (157 + 1086)) == (4843 - 2423))) then
				if (((19524 - 15066) > (5988 - 2084)) and v24(v103.RejuvenationFocus)) then
					return "rejuvenation healing";
				end
			end
			if (((594 - 158) >= (942 - (599 + 220))) and v100.Regrowth:IsCastable() and v77 and v16:BuffUp(v100.Rejuvenation) and (v16:HealthPercentage() <= v78)) then
				if (((995 - 495) < (3747 - (1813 + 118))) and v24(v103.RegrowthFocus, nil, true)) then
					return "regrowth healing";
				end
			end
		end
	end
	local function v140()
		if (((2613 + 961) == (4791 - (841 + 376))) and (v44 or v43) and v32) then
			local v193 = v136();
			if (((309 - 88) < (91 + 299)) and v193) then
				return v193;
			end
		end
		local v162 = v137();
		if (v162 or ((6040 - 3827) <= (2280 - (464 + 395)))) then
			return v162;
		end
		if (((7847 - 4789) < (2334 + 2526)) and v33) then
			local v194 = 837 - (467 + 370);
			local v195;
			while true do
				if ((v194 == (0 - 0)) or ((952 + 344) >= (15240 - 10794))) then
					v195 = v138();
					if (v195 or ((218 + 1175) > (10443 - 5954))) then
						return v195;
					end
					break;
				end
			end
		end
		local v162 = v139();
		if (v162 or ((4944 - (150 + 370)) < (1309 - (74 + 1208)))) then
			return v162;
		end
		if ((v99.TargetIsValid() and v34) or ((4911 - 2914) > (18092 - 14277))) then
			local v196 = 0 + 0;
			while true do
				if (((3855 - (14 + 376)) > (3317 - 1404)) and ((0 + 0) == v196)) then
					v162 = v134();
					if (((644 + 89) < (1735 + 84)) and v162) then
						return v162;
					end
					break;
				end
			end
		end
	end
	local function v141()
		local v163 = 0 - 0;
		while true do
			if ((v163 == (1 + 0)) or ((4473 - (23 + 55)) == (11269 - 6514))) then
				if ((v42 and v100.MarkOfTheWild:IsCastable() and (v13:BuffDown(v100.MarkOfTheWild, true) or v99.GroupBuffMissing(v100.MarkOfTheWild))) or ((2532 + 1261) < (2128 + 241))) then
					if (v24(v103.MarkOfTheWildPlayer) or ((6331 - 2247) == (84 + 181))) then
						return "mark_of_the_wild";
					end
				end
				if (((5259 - (652 + 249)) == (11662 - 7304)) and v99.TargetIsValid()) then
					if ((v100.Rake:IsReady() and (v13:StealthUp(false, true))) or ((5006 - (708 + 1160)) < (2695 - 1702))) then
						if (((6071 - 2741) > (2350 - (10 + 17))) and v24(v100.Rake, not v15:IsInMeleeRange(3 + 7))) then
							return "rake";
						end
					end
				end
				v163 = 1734 - (1400 + 332);
			end
			if (((0 - 0) == v163) or ((5534 - (242 + 1666)) == (1707 + 2282))) then
				if (((v44 or v43) and v32) or ((336 + 580) == (2277 + 394))) then
					local v229 = v136();
					if (((1212 - (850 + 90)) == (475 - 203)) and v229) then
						return v229;
					end
				end
				if (((5639 - (360 + 1030)) <= (4283 + 556)) and v29 and v36) then
					local v230 = v139();
					if (((7838 - 5061) < (4402 - 1202)) and v230) then
						return v230;
					end
				end
				v163 = 1662 - (909 + 752);
			end
			if (((1318 - (109 + 1114)) < (3582 - 1625)) and (v163 == (1 + 1))) then
				if (((1068 - (6 + 236)) < (1082 + 635)) and v99.TargetIsValid() and v34) then
					local v231 = 0 + 0;
					local v232;
					while true do
						if (((3362 - 1936) >= (1930 - 825)) and (v231 == (1133 - (1076 + 57)))) then
							v232 = v134();
							if (((453 + 2301) <= (4068 - (579 + 110))) and v232) then
								return v232;
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
		v41 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v42 = EpicSettings.Settings['UseMarkOfTheWild'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v44 = EpicSettings.Settings['DispelBuffs'];
		v45 = EpicSettings.Settings['UseHealthstone'];
		v46 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v47 = EpicSettings.Settings['HandleCharredTreant'];
		v48 = EpicSettings.Settings['HandleCharredBrambles'];
		v49 = EpicSettings.Settings['InterruptWithStun'];
		v50 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v51 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v52 = EpicSettings.Settings['UseDamageConvokeTheSpirits'];
		v53 = EpicSettings.Settings['UseDamageNaturesVigil'];
		v54 = EpicSettings.Settings['EfflorescenceUsage'] or "";
		v55 = EpicSettings.Settings['EfflorescenceHP'] or (407 - (174 + 233));
		v56 = EpicSettings.Settings['UseGroveGuardians'];
		v57 = EpicSettings.Settings['GroveGuardiansHP'] or (0 - 0);
		v58 = EpicSettings.Settings['GroveGuardiansGroup'] or (0 - 0);
		v59 = EpicSettings.Settings['UseCenarionWard'];
		v60 = EpicSettings.Settings['CenarionWardHP'] or (0 + 0);
		v61 = EpicSettings.Settings['UseConvokeTheSpirits'];
		v62 = EpicSettings.Settings['ConvokeTheSpiritsHP'] or (1174 - (663 + 511));
		v63 = EpicSettings.Settings['ConvokeTheSpiritsGroup'] or (0 + 0);
		v64 = EpicSettings.Settings['UseFlourish'];
		v65 = EpicSettings.Settings['FlourishHP'] or (0 + 0);
		v66 = EpicSettings.Settings['FlourishGroup'] or (0 - 0);
		v67 = EpicSettings.Settings['IronBarkUsage'] or "";
		v68 = EpicSettings.Settings['IronBarkHP'] or (0 + 0);
	end
	local function v143()
		local v181 = 0 - 0;
		while true do
			if (((0 - 0) == v181) or ((1874 + 2053) == (2749 - 1336))) then
				v69 = EpicSettings.Settings['UseLifebloomTank'];
				v70 = EpicSettings.Settings['LifebloomTankHP'] or (0 + 0);
				v71 = EpicSettings.Settings['UseLifebloom'];
				v72 = EpicSettings.Settings['LifebloomHP'] or (0 + 0);
				v181 = 723 - (478 + 244);
			end
			if ((v181 == (522 - (440 + 77))) or ((525 + 629) <= (2883 - 2095))) then
				v89 = EpicSettings.Settings['UseWildgrowthSotF'];
				v90 = EpicSettings.Settings['WildgrowthSotFHP'] or (1556 - (655 + 901));
				v91 = EpicSettings.Settings['WildgrowthSotFGroup'] or (0 + 0);
				v92 = EpicSettings.Settings['UseWildgrowth'];
				v181 = 5 + 1;
			end
			if ((v181 == (3 + 0)) or ((6618 - 4975) > (4824 - (695 + 750)))) then
				v81 = EpicSettings.Settings['UseSwiftmend'];
				v82 = EpicSettings.Settings['SwiftmendHP'] or (0 - 0);
				v83 = EpicSettings.Settings['UseTranquility'];
				v84 = EpicSettings.Settings['TranquilityHP'] or (0 - 0);
				v181 = 15 - 11;
			end
			if (((352 - (285 + 66)) == v181) or ((6533 - 3730) > (5859 - (682 + 628)))) then
				v73 = EpicSettings.Settings['UseNaturesSwiftness'];
				v74 = EpicSettings.Settings['NaturesSwiftnessHP'] or (0 + 0);
				v75 = EpicSettings.Settings['UseRegrowth'];
				v76 = EpicSettings.Settings['RegrowthHP'] or (299 - (176 + 123));
				v181 = 1 + 1;
			end
			if ((v181 == (5 + 1)) or ((489 - (239 + 30)) >= (822 + 2200))) then
				v93 = EpicSettings.Settings['WildgrowthHP'] or (0 + 0);
				v94 = EpicSettings.Settings['WildgrowthGroup'] or (0 - 0);
				v95 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
				v96 = EpicSettings.Settings['UseBarkskin'];
				v181 = 322 - (306 + 9);
			end
			if (((9847 - 7025) == (491 + 2331)) and (v181 == (5 + 2))) then
				v97 = EpicSettings.Settings['RenewalHP'] or (0 + 0);
				v98 = EpicSettings.Settings['UseRenewal'];
				break;
			end
			if (((11 - 7) == v181) or ((2436 - (1140 + 235)) == (1182 + 675))) then
				v85 = EpicSettings.Settings['TranquilityGroup'] or (0 + 0);
				v86 = EpicSettings.Settings['UseTranquilityTree'];
				v87 = EpicSettings.Settings['TranquilityTreeHP'] or (0 + 0);
				v88 = EpicSettings.Settings['TranquilityTreeGroup'] or (52 - (33 + 19));
				v181 = 2 + 3;
			end
			if (((8272 - 5512) > (601 + 763)) and (v181 == (3 - 1))) then
				v77 = EpicSettings.Settings['UseRegrowthRefresh'];
				v78 = EpicSettings.Settings['RegrowthRefreshHP'] or (0 + 0);
				v79 = EpicSettings.Settings['UseRejuvenation'];
				v80 = EpicSettings.Settings['RejuvenationHP'] or (689 - (586 + 103));
				v181 = 1 + 2;
			end
		end
	end
	local function v144()
		v142();
		v143();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['ramp'];
		v34 = EpicSettings.Toggles['dps'];
		v35 = EpicSettings.Toggles['dpsform'];
		v36 = EpicSettings.Toggles['healing'];
		if (v13:IsDeadOrGhost() or ((15091 - 10189) <= (5083 - (1309 + 179)))) then
			return;
		end
		if (v13:AffectingCombat() or v43 or ((6953 - 3101) == (128 + 165))) then
			local v197 = v43 and v100.NaturesCure:IsReady() and v32;
			if ((v99.IsTankBelowHealthPercentage(v68, 53 - 33, v100.Regrowth) and v100.IronBark:IsReady() and ((v67 == "Tank Only") or (v67 == "Tank and Self"))) or ((1178 + 381) == (9747 - 5159))) then
				local v221 = 0 - 0;
				local v222;
				while true do
					if ((v221 == (609 - (295 + 314))) or ((11013 - 6529) == (2750 - (1300 + 662)))) then
						v222 = v99.FocusUnit(v197, nil, nil, "TANK", 62 - 42, v100.Regrowth);
						if (((6323 - (1178 + 577)) >= (2030 + 1877)) and v222) then
							return v222;
						end
						break;
					end
				end
			elseif (((3683 - 2437) < (4875 - (851 + 554))) and (v13:HealthPercentage() < v68) and v100.IronBark:IsReady() and (v67 == "Tank and Self")) then
				local v233 = v99.FocusUnit(v197, nil, nil, "HEALER", 18 + 2, v100.Regrowth);
				if (((11281 - 7213) >= (2110 - 1138)) and v233) then
					return v233;
				end
			else
				local v234 = v99.FocusUnit(v197, nil, nil, nil, 322 - (115 + 187), v100.Regrowth);
				if (((378 + 115) < (3686 + 207)) and v234) then
					return v234;
				end
			end
		end
		if (v13:IsMounted() or ((5804 - 4331) >= (4493 - (160 + 1001)))) then
			return;
		end
		if (v13:IsMoving() or ((3544 + 507) <= (799 + 358))) then
			v104 = GetTime();
		end
		if (((1235 - 631) < (3239 - (237 + 121))) and (v13:BuffUp(v100.TravelForm) or v13:BuffUp(v100.BearForm) or v13:BuffUp(v100.CatForm))) then
			if (((GetTime() - v104) < (898 - (525 + 372))) or ((1706 - 806) == (11095 - 7718))) then
				return;
			end
		end
		if (((4601 - (96 + 46)) > (1368 - (643 + 134))) and v30) then
			v105 = v15:GetEnemiesInSplashRange(3 + 5);
			v106 = #v105;
		else
			local v198 = 0 - 0;
			while true do
				if (((12615 - 9217) >= (2297 + 98)) and (v198 == (0 - 0))) then
					v105 = {};
					v106 = 1 - 0;
					break;
				end
			end
		end
		if (v99.TargetIsValid() or v13:AffectingCombat() or ((2902 - (316 + 403)) >= (1878 + 946))) then
			local v199 = 0 - 0;
			while true do
				if (((700 + 1236) == (4875 - 2939)) and (v199 == (1 + 0))) then
					if ((v108 == (3581 + 7530)) or ((16742 - 11910) < (20598 - 16285))) then
						v108 = v9.FightRemains(v105, false);
					end
					break;
				end
				if (((8492 - 4404) > (222 + 3652)) and (v199 == (0 - 0))) then
					v107 = v9.BossFightRemains(nil, true);
					v108 = v107;
					v199 = 1 + 0;
				end
			end
		end
		if (((12745 - 8413) == (4349 - (12 + 5))) and v47) then
			local v200 = v99.HandleCharredTreant(v100.Rejuvenation, v103.RejuvenationMouseover, 155 - 115);
			if (((8531 - 4532) >= (6164 - 3264)) and v200) then
				return v200;
			end
			local v200 = v99.HandleCharredTreant(v100.Regrowth, v103.RegrowthMouseover, 99 - 59, true);
			if (v200 or ((513 + 2012) > (6037 - (1656 + 317)))) then
				return v200;
			end
			local v200 = v99.HandleCharredTreant(v100.Swiftmend, v103.SwiftmendMouseover, 36 + 4);
			if (((3503 + 868) == (11622 - 7251)) and v200) then
				return v200;
			end
			local v200 = v99.HandleCharredTreant(v100.Wildgrowth, v103.WildgrowthMouseover, 196 - 156, true);
			if (v200 or ((620 - (5 + 349)) > (23682 - 18696))) then
				return v200;
			end
		end
		if (((3262 - (266 + 1005)) >= (610 + 315)) and v48) then
			local v201 = 0 - 0;
			local v202;
			while true do
				if (((599 - 144) < (3749 - (561 + 1135))) and (v201 == (1 - 0))) then
					v202 = v99.HandleCharredBrambles(v100.Regrowth, v103.RegrowthMouseover, 131 - 91, true);
					if (v202 or ((1892 - (507 + 559)) == (12172 - 7321))) then
						return v202;
					end
					v201 = 6 - 4;
				end
				if (((571 - (212 + 176)) == (1088 - (250 + 655))) and (v201 == (8 - 5))) then
					v202 = v99.HandleCharredBrambles(v100.Wildgrowth, v103.WildgrowthMouseover, 69 - 29, true);
					if (((1812 - 653) <= (3744 - (1869 + 87))) and v202) then
						return v202;
					end
					break;
				end
				if ((v201 == (6 - 4)) or ((5408 - (484 + 1417)) > (9254 - 4936))) then
					v202 = v99.HandleCharredBrambles(v100.Swiftmend, v103.SwiftmendMouseover, 67 - 27);
					if (v202 or ((3848 - (48 + 725)) <= (4843 - 1878))) then
						return v202;
					end
					v201 = 7 - 4;
				end
				if (((794 + 571) <= (5374 - 3363)) and (v201 == (0 + 0))) then
					v202 = v99.HandleCharredBrambles(v100.Rejuvenation, v103.RejuvenationMouseover, 12 + 28);
					if (v202 or ((3629 - (152 + 701)) > (4886 - (430 + 881)))) then
						return v202;
					end
					v201 = 1 + 0;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15) and not v13:AffectingCombat() and v29) or ((3449 - (557 + 338)) == (1420 + 3384))) then
			local v203 = v99.DeadFriendlyUnitsCount();
			if (((7261 - 4684) == (9024 - 6447)) and v13:AffectingCombat()) then
				if (v100.Rebirth:IsReady() or ((15 - 9) >= (4070 - 2181))) then
					if (((1307 - (499 + 302)) <= (2758 - (39 + 827))) and v24(v100.Rebirth, nil, true)) then
						return "rebirth";
					end
				end
			elseif ((v203 > (2 - 1)) or ((4484 - 2476) > (8809 - 6591))) then
				if (((581 - 202) <= (356 + 3791)) and v24(v100.Revitalize, nil, true)) then
					return "revitalize";
				end
			elseif (v24(v100.Revive, not v15:IsInRange(117 - 77), true) or ((723 + 3791) <= (1596 - 587))) then
				return "revive";
			end
		end
		if ((v36 and (v13:AffectingCombat() or v29)) or ((3600 - (103 + 1)) == (1746 - (475 + 79)))) then
			local v204 = 0 - 0;
			local v205;
			while true do
				if ((v204 == (3 - 2)) or ((27 + 181) == (2605 + 354))) then
					v205 = v139();
					if (((5780 - (1395 + 108)) >= (3820 - 2507)) and v205) then
						return v205;
					end
					break;
				end
				if (((3791 - (7 + 1197)) < (1384 + 1790)) and (v204 == (0 + 0))) then
					v205 = v138();
					if (v205 or ((4439 - (27 + 292)) <= (6440 - 4242))) then
						return v205;
					end
					v204 = 1 - 0;
				end
			end
		end
		if (not v13:IsChanneling() or ((6693 - 5097) == (1691 - 833))) then
			if (((6132 - 2912) == (3359 - (43 + 96))) and v13:AffectingCombat()) then
				local v223 = v140();
				if (v223 or ((5718 - 4316) > (8184 - 4564))) then
					return v223;
				end
			elseif (((2136 + 438) == (727 + 1847)) and v29) then
				local v235 = 0 - 0;
				local v236;
				while true do
					if (((690 + 1108) < (5166 - 2409)) and (v235 == (0 + 0))) then
						v236 = v141();
						if (v236 or ((28 + 349) > (4355 - (1414 + 337)))) then
							return v236;
						end
						break;
					end
				end
			end
		end
	end
	local function v145()
		v22.Print("Restoration Druid Rotation by Epic.");
		EpicSettings.SetupVersion("Restoration Druid X v 10.2.01 By Gojira");
		v119();
	end
	v22.SetAPL(2045 - (1642 + 298), v144, v145);
end;
return v0["Epix_Druid_RestoDruid.lua"]();

