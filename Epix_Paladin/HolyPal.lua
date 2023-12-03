local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 229 - (73 + 156);
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((3190 - (721 + 90)) >= (52 + 4526))) then
			v6 = v0[v4];
			if (not v6 or ((1568 - 1085) > (1213 - (224 + 246)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((4517 - 2063) > (105 + 473)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Paladin_HolyPal.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Focus;
	local v15 = v13.Player;
	local v16 = v13.MouseOver;
	local v17 = v13.Target;
	local v18 = v13.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.floor;
	local v28 = string.format;
	local v29 = GetTotemInfo;
	local v30 = GetTime;
	local v31 = v19.Paladin.Holy;
	local v32 = v20.Paladin.Holy;
	local v33 = v23.Paladin.Holy;
	local v34;
	local v35;
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
	local v68;
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
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111;
	local v112;
	local v113;
	local v114;
	local v115;
	local v116;
	local v117;
	local v118 = false;
	local v119 = false;
	local v120 = false;
	local v121 = false;
	local v122 = false;
	local v123 = false;
	local v124 = {};
	local v125;
	local v126;
	local v127 = v21.Commons.Everyone;
	local function v128(v149)
		return v149:DebuffRefreshable(v31.JudgmentDebuff);
	end
	local function v129()
		for v182 = 1 + 0, 7 - 3 do
			local v183 = 0 - 0;
			local v184;
			local v185;
			local v186;
			local v187;
			while true do
				if (((1443 - (203 + 310)) < (6451 - (1238 + 755))) and (v183 == (0 + 0))) then
					v184, v185, v186, v187 = v29(v182);
					if (((2196 - (709 + 825)) <= (1790 - 818)) and (v185 == v31.Consecration:Name())) then
						return (v27(((v186 + v187) - v30()) + (0.5 - 0))) or (864 - (196 + 668));
					end
					break;
				end
			end
		end
		return 0 - 0;
	end
	local function v130(v150)
		return v150:DebuffRefreshable(v31.GlimmerofLightBuff) or not v61;
	end
	local function v131()
		local v151 = 0 - 0;
		local v152;
		while true do
			if (((5203 - (171 + 662)) == (4463 - (4 + 89))) and (v151 == (3 - 2))) then
				for v226, v227 in pairs(v152) do
					if (v227:IsCastable() or ((1734 + 3028) <= (3781 - 2920))) then
						if (v24(v33.BlessingofSummerPlayer) or ((554 + 858) == (5750 - (35 + 1451)))) then
							return "blessing_of_the_seasons";
						end
					end
				end
				break;
			end
			if ((v151 == (1453 - (28 + 1425))) or ((5161 - (941 + 1052)) < (2065 + 88))) then
				if ((v31.BlessingofSummer:IsCastable() and v15:IsInParty() and not v15:IsInRaid()) or ((6490 - (822 + 692)) < (1901 - 569))) then
					if (((2180 + 2448) == (4925 - (45 + 252))) and v14 and v14:Exists() and (v127.UnitGroupRole(v14) == "DAMAGER")) then
						if (v24(v33.BlessingofSummerFocus) or ((54 + 0) == (136 + 259))) then
							return "blessing_of_summer";
						end
					end
				end
				v152 = {v31.BlessingofSpring,v31.BlessingofSummer,v31.BlessingofAutumn,v31.BlessingofWinter};
				v151 = 1 + 0;
			end
		end
	end
	local function v132()
		local v153 = 0 - 0;
		while true do
			if (((171 - 89) == (2045 - (556 + 1407))) and (v153 == (1206 - (741 + 465)))) then
				ShouldReturn = v127.HandleTopTrinket(v124, v119, 505 - (170 + 295), nil);
				if (ShouldReturn or ((307 + 274) < (260 + 22))) then
					return ShouldReturn;
				end
				v153 = 2 - 1;
			end
			if ((v153 == (1 + 0)) or ((2956 + 1653) < (1413 + 1082))) then
				ShouldReturn = v127.HandleBottomTrinket(v124, v119, 1270 - (957 + 273), nil);
				if (((309 + 843) == (462 + 690)) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v133()
		if (((7224 - 5328) <= (9017 - 5595)) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v189 = 0 - 0;
			local v190;
			while true do
				if ((v189 == (4 - 3)) or ((2770 - (389 + 1391)) > (1017 + 603))) then
					v190 = v127.InterruptWithStun(v31.HammerofJustice, 1 + 7);
					if (v190 or ((1996 - 1119) > (5646 - (783 + 168)))) then
						return v190;
					end
					break;
				end
				if (((9031 - 6340) >= (1821 + 30)) and (v189 == (311 - (309 + 2)))) then
					v190 = v127.Interrupt(v31.Rebuke, 15 - 10, true);
					if (v190 or ((4197 - (1090 + 122)) >= (1575 + 3281))) then
						return v190;
					end
					v189 = 3 - 2;
				end
			end
		end
	end
	local function v134()
		local v154 = 0 + 0;
		while true do
			if (((5394 - (628 + 490)) >= (215 + 980)) and (v154 == (0 - 0))) then
				if (((14770 - 11538) <= (5464 - (431 + 343))) and (not v14 or not v14:Exists() or not v14:IsInRange(80 - 40) or not v127.DispellableFriendlyUnit())) then
					return;
				end
				if (v31.Cleanse:IsReady() or ((2591 - 1695) >= (2486 + 660))) then
					if (((392 + 2669) >= (4653 - (556 + 1139))) and v24(v33.CleanseFocus)) then
						return "cleanse dispel";
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v155 = 15 - (6 + 9);
		while true do
			if (((584 + 2603) >= (330 + 314)) and (v155 == (169 - (28 + 141)))) then
				if (((250 + 394) <= (868 - 164)) and v31.Consecration:IsCastable() and v17:IsInMeleeRange(4 + 1)) then
					if (((2275 - (486 + 831)) > (2464 - 1517)) and v24(v31.Consecration)) then
						return "consecrate precombat 4";
					end
				end
				if (((15814 - 11322) >= (502 + 2152)) and v31.Judgment:IsReady()) then
					if (((10883 - 7441) >= (2766 - (668 + 595))) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
						return "judgment precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v136()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (1 + 1)) or ((8644 - 5474) <= (1754 - (23 + 267)))) then
				if ((v35 and (v15:HealthPercentage() <= v37)) or ((6741 - (1129 + 815)) == (4775 - (371 + 16)))) then
					if (((2301 - (1326 + 424)) <= (1289 - 608)) and (v36 == "Refreshing Healing Potion")) then
						if (((11974 - 8697) > (525 - (88 + 30))) and v32.RefreshingHealingPotion:IsReady()) then
							if (((5466 - (720 + 51)) >= (3147 - 1732)) and v24(v33.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v156 == (1776 - (421 + 1355))) or ((5298 - 2086) <= (464 + 480))) then
				if (((v15:HealthPercentage() <= v63) and v62 and v31.LayonHands:IsCastable()) or ((4179 - (286 + 797)) <= (6572 - 4774))) then
					if (((5858 - 2321) == (3976 - (397 + 42))) and v24(v33.LayonHandsPlayer)) then
						return "lay_on_hands defensive";
					end
				end
				if (((1199 + 2638) >= (2370 - (24 + 776))) and v31.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67) and v66) then
					if (v24(v31.DivineProtection) or ((4544 - 1594) == (4597 - (222 + 563)))) then
						return "divine protection";
					end
				end
				v156 = 1 - 0;
			end
			if (((3401 + 1322) >= (2508 - (23 + 167))) and (v156 == (1799 - (690 + 1108)))) then
				if ((v31.WordofGlory:IsReady() and (v15:HolyPower() >= (2 + 1)) and (v15:HealthPercentage() <= v85) and v68 and not v15:HealingAbsorbed()) or ((1672 + 355) > (3700 - (40 + 808)))) then
					if (v24(v33.WordofGloryPlayer) or ((188 + 948) > (16508 - 12191))) then
						return "WOG self";
					end
				end
				if (((4539 + 209) == (2512 + 2236)) and v32.Healthstone:IsReady() and v54 and (v15:HealthPercentage() <= v55)) then
					if (((2049 + 1687) <= (5311 - (47 + 524))) and v24(v33.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v156 = 2 + 0;
			end
		end
	end
	local function v137()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((2 - 0) == v157) or ((7731 - 4341) <= (4786 - (1165 + 561)))) then
				if (v158 or ((30 + 969) > (8340 - 5647))) then
					return v158;
				end
				v158 = v127.HandleBottomTrinket(v124, v119, 16 + 24, nil);
				if (((942 - (341 + 138)) < (163 + 438)) and v158) then
					return v158;
				end
				if (v31.Seraphim:IsReady() or ((4504 - 2321) < (1013 - (89 + 237)))) then
					if (((14633 - 10084) == (9576 - 5027)) and v24(v31.Seraphim)) then
						return "seraphim cooldowns 18";
					end
				end
				break;
			end
			if (((5553 - (581 + 300)) == (5892 - (855 + 365))) and (v157 == (2 - 1))) then
				if (v31.BloodFury:IsCastable() or ((1198 + 2470) < (1630 - (1030 + 205)))) then
					if (v24(v31.BloodFury) or ((3912 + 254) == (424 + 31))) then
						return "blood_fury cooldowns 12";
					end
				end
				if (v31.Berserking:IsCastable() or ((4735 - (156 + 130)) == (6050 - 3387))) then
					if (v24(v31.Berserking) or ((7207 - 2930) < (6121 - 3132))) then
						return "berserking cooldowns 14";
					end
				end
				if (v31.HolyAvenger:IsCastable() or ((230 + 640) >= (2420 + 1729))) then
					if (((2281 - (10 + 59)) < (901 + 2282)) and v24(v31.HolyAvenger)) then
						return "holy_avenger cooldowns 16";
					end
				end
				v158 = v127.HandleTopTrinket(v124, v119, 196 - 156, nil);
				v157 = 1165 - (671 + 492);
			end
			if (((3699 + 947) > (4207 - (369 + 846))) and (v157 == (0 + 0))) then
				if (((1224 + 210) < (5051 - (1036 + 909))) and v56 and v119 and v31.AvengingWrath:IsReady() and not v15:BuffUp(v31.AvengingWrathBuff)) then
					if (((625 + 161) < (5075 - 2052)) and v24(v31.AvengingWrath)) then
						return "avenging_wrath cooldowns 4";
					end
				end
				v158 = v131();
				if (v158 or ((2645 - (11 + 192)) < (38 + 36))) then
					return v158;
				end
				if (((4710 - (135 + 40)) == (10987 - 6452)) and v57 and v119 and v31.DivineToll:IsCastable() and v15:BuffUp(v31.AvengingWrathBuff)) then
					if (v24(v31.DivineToll) or ((1814 + 1195) <= (4637 - 2532))) then
						return "divine_toll cooldowns 8";
					end
				end
				v157 = 1 - 0;
			end
		end
	end
	local function v138()
		local v159 = 176 - (50 + 126);
		while true do
			if (((5095 - 3265) < (813 + 2856)) and (v159 == (1413 - (1233 + 180)))) then
				if (v119 or ((2399 - (522 + 447)) >= (5033 - (107 + 1314)))) then
					local v228 = 0 + 0;
					local v229;
					while true do
						if (((8175 - 5492) >= (1045 + 1415)) and (v228 == (0 - 0))) then
							v229 = v137();
							if (v229 or ((7137 - 5333) >= (5185 - (716 + 1194)))) then
								return v229;
							end
							break;
						end
					end
				end
				if ((v31.ShieldoftheRighteousHoly:IsReady() and (v15:BuffUp(v31.AvengingWrathBuff) or v15:BuffUp(v31.HolyAvenger) or not v31.Awakening:IsAvailable())) or ((25 + 1392) > (389 + 3240))) then
					if (((5298 - (74 + 429)) > (775 - 373)) and v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(3 + 2))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((11017 - 6204) > (2523 + 1042)) and v31.ShieldoftheRighteousHoly:IsReady() and (HolyPower >= (8 - 5)) and (v127.HealthPercentage > v69) and (v127.FriendlyUnitsBelowHealthPercentageCount(v90) < v91)) then
					if (((9672 - 5760) == (4345 - (279 + 154))) and v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(783 - (454 + 324)))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((2220 + 601) <= (4841 - (12 + 5))) and v31.HammerofWrath:IsReady() and (v15:HolyPower() < (3 + 2)) and (v126 == (4 - 2))) then
					if (((643 + 1095) <= (3288 - (277 + 816))) and v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath))) then
						return "hammer_of_wrath priority 4";
					end
				end
				v159 = 4 - 3;
			end
			if (((1224 - (1058 + 125)) <= (566 + 2452)) and (v159 == (980 - (815 + 160)))) then
				if (((9203 - 7058) <= (9742 - 5638)) and v31.Consecration:IsReady()) then
					if (((642 + 2047) < (14162 - 9317)) and v24(v31.Consecration, not v17:IsInMeleeRange(1903 - (41 + 1857)))) then
						return "consecration priority 36";
					end
				end
				break;
			end
			if (((1897 - (1222 + 671)) == v159) or ((6001 - 3679) > (3768 - 1146))) then
				if ((v31.HolyPrism:IsReady() and v96) or ((5716 - (229 + 953)) == (3856 - (1111 + 663)))) then
					if (v24(v31.HolyPrism, not v17:IsSpellInRange(v31.HolyPrism)) or ((3150 - (874 + 705)) > (262 + 1605))) then
						return "holy_prism priority 28";
					end
				end
				if (v31.ArcaneTorrent:IsCastable() or ((1811 + 843) >= (6227 - 3231))) then
					if (((112 + 3866) > (2783 - (642 + 37))) and v24(v31.ArcaneTorrent)) then
						return "arcane_torrent priority 30";
					end
				end
				if (((683 + 2312) > (247 + 1294)) and v31.LightofDawn:IsReady() and v123 and (v15:HolyPower() >= (7 - 4)) and ((v31.Awakening:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (456 - (233 + 221))))) then
					if (((7512 - 4263) > (839 + 114)) and v24(v31.LightofDawn, not v17:IsSpellInRange(v31.LightofDawn))) then
						return "light_of_dawn priority 32";
					end
				end
				if (v31.CrusaderStrike:IsReady() or ((4814 - (718 + 823)) > (2878 + 1695))) then
					if (v24(v31.CrusaderStrike, not v17:IsInMeleeRange(810 - (266 + 539))) or ((8921 - 5770) < (2509 - (636 + 589)))) then
						return "crusader_strike priority 34";
					end
				end
				v159 = 11 - 6;
			end
			if ((v159 == (5 - 2)) or ((1467 + 383) == (556 + 973))) then
				if (((1836 - (657 + 358)) < (5621 - 3498)) and v58 and v31.HolyShock:IsReady() and v17:DebuffDown(v31.GlimmerofLightBuff) and (not v31.GlimmerofLight:IsAvailable() or v130(v17))) then
					if (((2054 - 1152) < (3512 - (1151 + 36))) and v24(v31.HolyShock, not v17:IsSpellInRange(v31.HolyShock))) then
						return "holy_shock damage";
					end
				end
				if (((829 + 29) <= (779 + 2183)) and v58 and v59 and v31.HolyShock:IsReady() and (v127.EnemiesWithDebuffCount(v31.GlimmerofLightBuff, 119 - 79) < v60) and v122) then
					if (v127.CastCycle(v31.HolyShock, v125, v130, not v17:IsSpellInRange(v31.HolyShock), nil, nil, v33.HolyShockMouseover) or ((5778 - (1552 + 280)) < (2122 - (64 + 770)))) then
						return "holy_shock_cycle damage";
					end
				end
				if ((v31.CrusaderStrike:IsReady() and (v31.CrusaderStrike:Charges() == (2 + 0))) or ((7359 - 4117) == (101 + 466))) then
					if (v24(v31.CrusaderStrike, not v17:IsInMeleeRange(1248 - (157 + 1086))) or ((1694 - 847) >= (5531 - 4268))) then
						return "crusader_strike priority 24";
					end
				end
				if ((v31.HolyPrism:IsReady() and (v126 >= (2 - 0)) and v96) or ((3074 - 821) == (2670 - (599 + 220)))) then
					if (v24(v33.HolyPrismPlayer) or ((4155 - 2068) > (4303 - (1813 + 118)))) then
						return "holy_prism on self priority 26";
					end
				end
				v159 = 3 + 1;
			end
			if (((1219 - (841 + 376)) == v159) or ((6228 - 1783) < (964 + 3185))) then
				if (v31.HammerofWrath:IsReady() or ((4962 - 3144) == (944 - (464 + 395)))) then
					if (((1616 - 986) < (1022 + 1105)) and v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath))) then
						return "hammer_of_wrath priority 14";
					end
				end
				if (v31.Judgment:IsReady() or ((2775 - (467 + 370)) == (5195 - 2681))) then
					if (((3124 + 1131) >= (188 - 133)) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
						return "judgment priority 16";
					end
				end
				if (((468 + 2531) > (2689 - 1533)) and (LightsHammer == "Player")) then
					if (((2870 - (150 + 370)) > (2437 - (74 + 1208))) and v31.LightsHammer:IsCastable()) then
						if (((9909 - 5880) <= (23015 - 18162)) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(6 + 2))) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammer == "Cursor") or ((906 - (14 + 376)) > (5955 - 2521))) then
					if (((2619 + 1427) >= (2665 + 368)) and v31.LightsHammer:IsCastable()) then
						if (v24(v33.LightsHammercursor) or ((2594 + 125) <= (4239 - 2792))) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammer == "Enemy Under Cursor") or ((3110 + 1024) < (4004 - (23 + 55)))) then
					if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((388 - 224) >= (1859 + 926))) then
						if (v24(v33.LightsHammercursor) or ((472 + 53) == (3269 - 1160))) then
							return "lights_hammer priority 6";
						end
					end
				end
				if (((11 + 22) == (934 - (652 + 249))) and v31.Consecration:IsCastable() and (v129() <= (0 - 0))) then
					if (((4922 - (708 + 1160)) <= (10898 - 6883)) and v24(v31.Consecration, not v17:IsInMeleeRange(9 - 4))) then
						return "consecration priority 20";
					end
				end
				v159 = 30 - (10 + 17);
			end
			if (((421 + 1450) < (5114 - (1400 + 332))) and (v159 == (1 - 0))) then
				if (((3201 - (242 + 1666)) <= (927 + 1239)) and (LightsHammerLightsHammerUsage == "Player")) then
					if ((v31.LightsHammer:IsCastable() and (v126 >= (1 + 1))) or ((2198 + 381) < (1063 - (850 + 90)))) then
						if (v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(13 - 5)) or ((2236 - (360 + 1030)) >= (2096 + 272))) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammerLightsHammerUsage == "Cursor") or ((11323 - 7311) <= (4619 - 1261))) then
					if (((3155 - (909 + 752)) <= (4228 - (109 + 1114))) and v31.LightsHammer:IsCastable()) then
						if (v24(v33.LightsHammercursor) or ((5695 - 2584) == (831 + 1303))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((2597 - (6 + 236)) == (1484 + 871)) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
					if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((474 + 114) <= (1018 - 586))) then
						if (((8378 - 3581) >= (5028 - (1076 + 57))) and v24(v33.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				end
				if (((589 + 2988) == (4266 - (579 + 110))) and v31.Consecration:IsCastable() and (v126 >= (1 + 1)) and (v129() <= (0 + 0))) then
					if (((2014 + 1780) > (4100 - (174 + 233))) and v24(v31.Consecration, not v17:IsInMeleeRange(13 - 8))) then
						return "consecration priority 8";
					end
				end
				if ((v31.LightofDawn:IsReady() and v123 and ((v31.Awakening:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or ((v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (3 - 1)) and ((v15:HolyPower() >= (3 + 2)) or (v15:BuffUp(v31.HolyAvenger) and (v15:HolyPower() >= (1177 - (663 + 511)))))))) or ((1138 + 137) == (891 + 3209))) then
					if (v24(v31.LightofDawn) or ((4904 - 3313) >= (2168 + 1412))) then
						return "light_of_dawn priority 10";
					end
				end
				if (((2313 - 1330) <= (4376 - 2568)) and v31.ShieldoftheRighteousHoly:IsReady() and (v126 > (2 + 1))) then
					if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(9 - 4)) or ((1533 + 617) <= (110 + 1087))) then
						return "shield_of_the_righteous priority 12";
					end
				end
				v159 = 724 - (478 + 244);
			end
		end
	end
	local function v139()
		if (((4286 - (440 + 77)) >= (534 + 639)) and (not v14 or not v14:Exists() or not v14:IsInRange(146 - 106))) then
			return;
		end
		if (((3041 - (655 + 901)) == (276 + 1209)) and v31.LayonHands:IsCastable() and (v14:HealthPercentage() <= v63) and v62) then
			if (v24(v33.LayonHandsFocus) or ((2538 + 777) <= (1879 + 903))) then
				return "lay_on_hands cooldown_healing";
			end
		end
		if ((v101 == "Not Tank") or ((3529 - 2653) >= (4409 - (695 + 750)))) then
			if ((v31.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v102) and (not v127.UnitGroupRole(v14) == "TANK")) or ((7621 - 5389) > (3853 - 1356))) then
				if (v24(v33.BlessingofProtectionFocus) or ((8485 - 6375) <= (683 - (285 + 66)))) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		elseif (((8592 - 4906) > (4482 - (682 + 628))) and (v101 == "Player")) then
			if ((v31.BlessingofProtection:IsCastable() and (v15:HealthPercentage() <= v102)) or ((722 + 3752) < (1119 - (176 + 123)))) then
				if (((1790 + 2489) >= (2091 + 791)) and v24(v33.BlessingofProtectionplayer)) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		end
		if ((v31.AuraMastery:IsCastable() and v127.AreUnitsBelowHealthPercentage(v74, v75) and v73) or ((2298 - (239 + 30)) >= (958 + 2563))) then
			if (v24(v31.AuraMastery) or ((1958 + 79) >= (8215 - 3573))) then
				return "aura_mastery cooldown_healing";
			end
		end
		if (((5366 - 3646) < (4773 - (306 + 9))) and v31.AvengingWrath:IsCastable() and not v15:BuffUp(v31.AvengingWrathBuff) and v127.AreUnitsBelowHealthPercentage(v71, v72) and v70) then
			if (v24(v31.AvengingWrath) or ((1521 - 1085) > (526 + 2495))) then
				return "avenging_wrath cooldown_healing";
			end
		end
		if (((438 + 275) <= (408 + 439)) and v31.TyrsDeliverance:IsCastable() and v108 and v127.AreUnitsBelowHealthPercentage(v109, v110)) then
			if (((6159 - 4005) <= (5406 - (1140 + 235))) and v24(v31.TyrsDeliverance)) then
				return "tyrs_deliverance cooldown_healing";
			end
		end
		if (((2937 + 1678) == (4233 + 382)) and v31.BeaconofVirtue:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) then
			if (v24(v33.BeaconofVirtueFocus) or ((973 + 2817) == (552 - (33 + 19)))) then
				return "beacon_of_virtue cooldown_healing";
			end
		end
		if (((33 + 56) < (662 - 441)) and v31.Daybreak:IsReady() and (v127.FriendlyUnitsWithBuffCount(v31.GlimmerofLightBuff, false, false) > v107) and (v127.AreUnitsBelowHealthPercentage(v105, v106) or (v15:ManaPercentage() <= v104)) and v103) then
			if (((905 + 1149) >= (2786 - 1365)) and v24(v31.Daybreak)) then
				return "daybreak cooldown_healing";
			end
		end
		if (((649 + 43) < (3747 - (586 + 103))) and v31.HandofDivinity:IsReady() and v127.AreUnitsBelowHealthPercentage(v112, v113) and v111) then
			if (v24(v31.HandofDivinity) or ((297 + 2957) == (5095 - 3440))) then
				return "divine_toll cooldown_healing";
			end
		end
		if ((v31.DivineToll:IsReady() and v127.AreUnitsBelowHealthPercentage(v93, v94) and v92) or ((2784 - (1309 + 179)) == (8864 - 3954))) then
			if (((1466 + 1902) == (9044 - 5676)) and v24(v33.DivineTollFocus)) then
				return "divine_toll cooldown_healing";
			end
		end
		if (((1997 + 646) < (8105 - 4290)) and v31.HolyShock:IsReady() and (v14:HealthPercentage() <= v79) and v78) then
			if (((3811 - 1898) > (1102 - (295 + 314))) and v24(v33.HolyShockFocus)) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((11679 - 6924) > (5390 - (1300 + 662))) and v31.BlessingofSacrifice:IsReady() and (v14:GUID() ~= v15:GUID()) and (v14:HealthPercentage() <= v77) and v76) then
			if (((4336 - 2955) <= (4124 - (1178 + 577))) and v24(v33.BlessingofSacrificeFocus)) then
				return "blessing_of_sacrifice cooldown_healing";
			end
		end
	end
	local function v140()
		local v160 = 0 + 0;
		while true do
			if ((v160 == (8 - 5)) or ((6248 - (851 + 554)) == (3612 + 472))) then
				if (((12948 - 8279) > (788 - 425)) and v127.TargetIsValid()) then
					local v230 = 302 - (115 + 187);
					while true do
						if ((v230 == (0 + 0)) or ((1777 + 100) >= (12365 - 9227))) then
							if (((5903 - (160 + 1001)) >= (3173 + 453)) and v31.Consecration:IsCastable() and v31.GoldenPath:IsAvailable() and (v129() <= (0 + 0))) then
								if (v24(v31.Consecration, not v17:IsInMeleeRange(10 - 5)) or ((4898 - (237 + 121)) == (1813 - (525 + 372)))) then
									return "consecration aoe_healing";
								end
							end
							if ((v31.Judgment:IsReady() and v31.JudgmentofLight:IsAvailable() and v17:DebuffDown(v31.JudgmentofLightDebuff)) or ((2191 - 1035) > (14276 - 9931))) then
								if (((2379 - (96 + 46)) < (5026 - (643 + 134))) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
									return "judgment aoe_healing";
								end
							end
							v230 = 1 + 0;
						end
						if (((2 - 1) == v230) or ((9961 - 7278) < (23 + 0))) then
							if (((1367 - 670) <= (1688 - 862)) and v127.AreUnitsBelowHealthPercentage(v99, v100)) then
								if (((1824 - (316 + 403)) <= (782 + 394)) and (LightsHammerLightsHammerUsage == "Player")) then
									if (((9290 - 5911) <= (1378 + 2434)) and v31.LightsHammer:IsCastable()) then
										if (v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(20 - 12)) or ((559 + 229) >= (521 + 1095))) then
											return "lights_hammer priority 6";
										end
									end
								elseif (((6423 - 4569) <= (16137 - 12758)) and (LightsHammerLightsHammerUsage == "Cursor")) then
									if (((9449 - 4900) == (261 + 4288)) and v31.LightsHammer:IsCastable()) then
										if (v24(v33.LightsHammercursor) or ((5948 - 2926) >= (148 + 2876))) then
											return "lights_hammer priority 6";
										end
									end
								elseif (((14180 - 9360) > (2215 - (12 + 5))) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
									if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((4120 - 3059) >= (10435 - 5544))) then
										if (((2899 - 1535) <= (11092 - 6619)) and v24(v33.LightsHammercursor)) then
											return "lights_hammer priority 6";
										end
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v160 == (1 + 1)) or ((5568 - (1656 + 317)) <= (3 + 0))) then
				if ((v31.WordofGlory:IsReady() and (v15:HolyPower() >= (3 + 0)) and (v14:HealthPercentage() <= v85) and UseWodOfGlory and (v127.FriendlyUnitsBelowHealthPercentageCount(v85) < (7 - 4))) or ((22993 - 18321) == (4206 - (5 + 349)))) then
					if (((7404 - 5845) == (2830 - (266 + 1005))) and v24(v33.WordofGloryFocus)) then
						return "word_of_glory aoe_healing";
					end
				end
				if ((v31.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) or ((1155 + 597) <= (2688 - 1900))) then
					if (v24(v33.LightoftheMartyrFocus) or ((5143 - 1236) == (1873 - (561 + 1135)))) then
						return "holy_shock cooldown_healing";
					end
				end
				v160 = 3 - 0;
			end
			if (((11406 - 7936) > (1621 - (507 + 559))) and (v160 == (0 - 0))) then
				if ((v31.BeaconofVirtue:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) or ((3005 - 2033) == (1033 - (212 + 176)))) then
					if (((4087 - (250 + 655)) >= (5767 - 3652)) and v24(v33.BeaconofVirtueFocus)) then
						return "beacon_of_virtue aoe_healing";
					end
				end
				if (((6802 - 2909) < (6928 - 2499)) and v31.WordofGlory:IsReady() and (v15:HolyPower() >= (1959 - (1869 + 87))) and v15:BuffUp(v31.EmpyreanLegacyBuff) and (((v14:HealthPercentage() <= v85) and v68) or v127.AreUnitsBelowHealthPercentage(v90, v91))) then
					if (v24(v33.WordofGloryFocus) or ((9943 - 7076) < (3806 - (484 + 1417)))) then
						return "word_of_glory aoe_healing";
					end
				end
				v160 = 2 - 1;
			end
			if ((v160 == (1 - 0)) or ((2569 - (48 + 725)) >= (6617 - 2566))) then
				if (((4343 - 2724) <= (2183 + 1573)) and v31.WordofGlory:IsReady() and (v15:HolyPower() >= (7 - 4)) and v15:BuffUp(v31.UnendingLightBuff) and (v14:HealthPercentage() <= v85) and v68) then
					if (((170 + 434) == (177 + 427)) and v24(v33.WordofGloryFocus)) then
						return "word_of_glory aoe_healing";
					end
				end
				if ((v31.LightofDawn:IsReady() and v123 and (v15:HolyPower() >= (856 - (152 + 701))) and (v127.AreUnitsBelowHealthPercentage(v90, v91) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (1313 - (430 + 881))))) or ((1718 + 2766) == (1795 - (557 + 338)))) then
					if (v24(v31.LightofDawn) or ((1318 + 3141) <= (3136 - 2023))) then
						return "light_of_dawn aoe_healing";
					end
				end
				v160 = 6 - 4;
			end
		end
	end
	local function v141()
		local v161 = 0 - 0;
		while true do
			if (((7827 - 4195) > (4199 - (499 + 302))) and (v161 == (870 - (39 + 827)))) then
				if (((11268 - 7186) <= (10981 - 6064)) and v31.HolyLight:IsCastable() and (v14:HealthPercentage() <= v84) and v83) then
					if (((19191 - 14359) >= (2127 - 741)) and v24(v33.HolyLightFocus, nil, true)) then
						return "holy_light st_healing";
					end
				end
				if (((12 + 125) == (400 - 263)) and v127.AreUnitsBelowHealthPercentage(v99, v100)) then
					if ((v98 == "Player") or ((252 + 1318) >= (6854 - 2522))) then
						if (v31.LightsHammer:IsCastable() or ((4168 - (103 + 1)) <= (2373 - (475 + 79)))) then
							if (v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(17 - 9)) or ((15955 - 10969) < (204 + 1370))) then
								return "lights_hammer priority 6";
							end
						end
					elseif (((3896 + 530) > (1675 - (1395 + 108))) and (v98 == "Cursor")) then
						if (((1705 - 1119) > (1659 - (7 + 1197))) and v31.LightsHammer:IsCastable()) then
							if (((361 + 465) == (289 + 537)) and v24(v33.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					elseif ((v98 == "Enemy Under Cursor") or ((4338 - (27 + 292)) > (13013 - 8572))) then
						if (((2571 - 554) < (17869 - 13608)) and v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
							if (((9299 - 4583) > (152 - 72)) and v24(v33.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					end
				end
				break;
			end
			if ((v161 == (139 - (43 + 96))) or ((14305 - 10798) == (7397 - 4125))) then
				if ((v31.WordofGlory:IsReady() and (v15:HolyPower() >= (3 + 0)) and (v14:HealthPercentage() <= v85) and v68) or ((248 + 628) >= (6077 - 3002))) then
					if (((1668 + 2684) > (4786 - 2232)) and v24(v33.WordofGloryFocus)) then
						return "word_of_glory st_healing";
					end
				end
				if ((v31.HolyShock:IsReady() and (v14:HealthPercentage() <= v79) and v78) or ((1388 + 3018) < (297 + 3746))) then
					if (v24(v33.HolyShockFocus) or ((3640 - (1414 + 337)) >= (5323 - (1642 + 298)))) then
						return "holy_shock st_healing";
					end
				end
				v161 = 2 - 1;
			end
			if (((5442 - 3550) <= (8113 - 5379)) and (v161 == (1 + 1))) then
				if (((1497 + 426) < (3190 - (357 + 615))) and v31.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (((1526 + 647) > (929 - 550)) and v24(v33.LightoftheMartyrFocus)) then
						return "holy_shock cooldown_healing";
					end
				end
				if ((v31.BarrierofFaith:IsCastable() and (v14:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) or ((2221 + 370) == (7305 - 3896))) then
					if (((3611 + 903) > (226 + 3098)) and v24(v33.BarrierofFaith, nil, true)) then
						return "barrier_of_faith st_healing";
					end
				end
				v161 = 2 + 1;
			end
			if ((v161 == (1304 - (384 + 917))) or ((905 - (128 + 569)) >= (6371 - (1407 + 136)))) then
				if ((v31.FlashofLight:IsCastable() and v15:BuffUp(v31.InfusionofLightBuff) and (v14:HealthPercentage() <= v82) and v80) or ((3470 - (687 + 1200)) > (5277 - (556 + 1154)))) then
					if (v24(v33.FlashofLightFocus, nil, true) or ((4619 - 3306) == (889 - (9 + 86)))) then
						return "flash_of_light st_healing";
					end
				end
				if (((3595 - (275 + 146)) > (472 + 2430)) and v31.HolyPrism:IsReady() and (v14:HealthPercentage() <= v97) and v95) then
					if (((4184 - (29 + 35)) <= (18880 - 14620)) and v24(v33.HolyPrismPlayer)) then
						return "holy_prism on self priority 26";
					end
				end
				v161 = 11 - 7;
			end
			if ((v161 == (4 - 3)) or ((576 + 307) > (5790 - (53 + 959)))) then
				if ((v31.DivineFavor:IsReady() and (v14:HealthPercentage() <= v84) and v83) or ((4028 - (312 + 96)) >= (8488 - 3597))) then
					if (((4543 - (147 + 138)) > (1836 - (813 + 86))) and v24(v31.DivineFavor)) then
						return "divine_favor st_healing";
					end
				end
				if ((v31.FlashofLight:IsCastable() and (v14:HealthPercentage() <= v81) and v80) or ((4400 + 469) < (1677 - 771))) then
					if (v24(v33.FlashofLightFocus, nil, true) or ((1717 - (18 + 474)) > (1427 + 2801))) then
						return "flash_of_light st_healing";
					end
				end
				v161 = 6 - 4;
			end
		end
	end
	local function v142()
		local v162 = 1086 - (860 + 226);
		local v163;
		while true do
			if (((3631 - (121 + 182)) > (276 + 1962)) and (v162 == (1241 - (988 + 252)))) then
				if (((434 + 3405) > (441 + 964)) and v163) then
					return v163;
				end
				v163 = v141();
				v162 = 1972 - (49 + 1921);
			end
			if ((v162 == (890 - (223 + 667))) or ((1345 - (51 + 1)) <= (872 - 365))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(85 - 45) or ((4021 - (146 + 979)) < (228 + 577))) then
					return;
				end
				v163 = v140();
				v162 = 606 - (311 + 294);
			end
			if (((6458 - 4142) == (982 + 1334)) and (v162 == (1445 - (496 + 947)))) then
				if (v163 or ((3928 - (1233 + 125)) == (623 + 910))) then
					return v163;
				end
				break;
			end
		end
	end
	local function v143()
		local v164 = 0 + 0;
		local v165;
		while true do
			if ((v164 == (2 + 5)) or ((2528 - (963 + 682)) == (1219 + 241))) then
				if (v127.TargetIsValid() or ((6123 - (504 + 1000)) <= (673 + 326))) then
					local v231 = 0 + 0;
					while true do
						if ((v231 == (0 + 0)) or ((5028 - 1618) > (3517 + 599))) then
							v165 = v137();
							if (v165 or ((526 + 377) >= (3241 - (156 + 26)))) then
								return v165;
							end
							v231 = 1 + 0;
						end
						if ((v231 == (1 - 0)) or ((4140 - (149 + 15)) < (3817 - (890 + 70)))) then
							v165 = v138();
							if (((5047 - (39 + 78)) > (2789 - (14 + 468))) and v165) then
								return v165;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v164 == (4 - 2)) or ((11308 - 7262) < (667 + 624))) then
				v165 = v127.HandleChromie(v31.HolyShock, v33.HolyShockMouseover, 25 + 15);
				if (v165 or ((901 + 3340) == (1602 + 1943))) then
					return v165;
				end
				v165 = v127.HandleChromie(v31.WordofGlory, v33.WordofGloryMouseover, 11 + 29);
				if (v165 or ((7748 - 3700) > (4183 + 49))) then
					return v165;
				end
				v164 = 10 - 7;
			end
			if ((v164 == (1 + 0)) or ((1801 - (12 + 39)) >= (3232 + 241))) then
				if (((9799 - 6633) == (11275 - 8109)) and v42) then
					v165 = v134();
					if (((523 + 1240) < (1961 + 1763)) and v165) then
						return v165;
					end
				end
				if (((144 - 87) <= (1814 + 909)) and v44) then
					local v232 = 0 - 0;
					while true do
						if ((v232 == (1714 - (1596 + 114))) or ((5404 - 3334) == (1156 - (164 + 549)))) then
							v165 = v127.HandleAfflicted(v31.HolyLight, v33.HolyLightMouseover, 1478 - (1059 + 379));
							if (v165 or ((3358 - 653) == (722 + 671))) then
								return v165;
							end
							break;
						end
						if ((v232 == (1 + 1)) or ((4993 - (145 + 247)) < (51 + 10))) then
							v165 = v127.HandleAfflicted(v31.WordofGlory, v33.WordofGloryMouseover, 19 + 21);
							if (v165 or ((4121 - 2731) >= (911 + 3833))) then
								return v165;
							end
							v232 = 3 + 0;
						end
						if ((v232 == (4 - 1)) or ((2723 - (254 + 466)) > (4394 - (544 + 16)))) then
							v165 = v127.HandleAfflicted(v31.FlashofLight, v33.FlashofLightMouseover, 127 - 87);
							if (v165 or ((784 - (294 + 334)) > (4166 - (236 + 17)))) then
								return v165;
							end
							v232 = 2 + 2;
						end
						if (((152 + 43) == (734 - 539)) and (v232 == (0 - 0))) then
							v165 = v127.HandleAfflicted(v31.Cleanse, v33.CleanseMouseover, 21 + 19);
							if (((2558 + 547) >= (2590 - (413 + 381))) and v165) then
								return v165;
							end
							v232 = 1 + 0;
						end
						if (((9312 - 4933) >= (5535 - 3404)) and (v232 == (1971 - (582 + 1388)))) then
							v165 = v127.HandleAfflicted(v31.HolyShock, v33.HolyShockMouseover, 68 - 28);
							if (((2752 + 1092) >= (2407 - (326 + 38))) and v165) then
								return v165;
							end
							v232 = 5 - 3;
						end
					end
				end
				v165 = v127.HandleChromie(v31.Cleanse, v33.CleanseMouseover, 57 - 17);
				if (v165 or ((3852 - (47 + 573)) <= (963 + 1768))) then
					return v165;
				end
				v164 = 8 - 6;
			end
			if (((7961 - 3056) == (6569 - (1269 + 395))) and (v164 == (495 - (76 + 416)))) then
				v165 = v127.HandleChromie(v31.FlashofLight, v33.FlashofLightMouseover, 483 - (319 + 124));
				if (v165 or ((9454 - 5318) >= (5418 - (564 + 443)))) then
					return v165;
				end
				v165 = v127.HandleChromie(v31.HolyLight, v33.HolyLightMouseover, 110 - 70);
				if (v165 or ((3416 - (337 + 121)) == (11769 - 7752))) then
					return v165;
				end
				v164 = 13 - 9;
			end
			if (((3139 - (1261 + 650)) >= (344 + 469)) and (v164 == (0 - 0))) then
				if ((v127.GetCastingEnemy(v31.BlackoutBarrelDebuff) and v31.BlessingofFreedom:IsReady()) or ((5272 - (772 + 1045)) > (572 + 3478))) then
					local v233 = v127.FocusSpecifiedUnit(v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)), 184 - (102 + 42));
					if (((2087 - (1524 + 320)) == (1513 - (1049 + 221))) and v233) then
						return v233;
					end
					if ((v14 and UnitIsUnit(v14:ID(), v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)):ID())) or ((427 - (18 + 138)) > (3847 - 2275))) then
						if (((3841 - (67 + 1035)) < (3641 - (136 + 212))) and v24(v33.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v165 = v127.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 169 - 129, 17 + 3);
				if (v165 or ((3634 + 308) < (2738 - (240 + 1364)))) then
					return v165;
				end
				if ((v31.BlessingofFreedom:IsReady() and v127.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((3775 - (1050 + 32)) == (17756 - 12783))) then
					if (((1270 + 876) == (3201 - (331 + 724))) and v24(v33.BlessingofFreedomFocus)) then
						return "blessing_of_freedom combat";
					end
				end
				v164 = 1 + 0;
			end
			if ((v164 == (650 - (269 + 375))) or ((2969 - (267 + 458)) == (1003 + 2221))) then
				v165 = v133();
				if (v165 or ((9430 - 4526) <= (2734 - (667 + 151)))) then
					return v165;
				end
				v165 = v142();
				if (((1587 - (1410 + 87)) <= (2962 - (1504 + 393))) and v165) then
					return v165;
				end
				v164 = 18 - 11;
			end
			if (((12458 - 7656) == (5598 - (461 + 335))) and ((1 + 3) == v164)) then
				if (v45 or ((4041 - (1730 + 31)) <= (2178 - (728 + 939)))) then
					local v234 = 0 - 0;
					while true do
						if (((0 - 0) == v234) or ((3839 - 2163) <= (1531 - (138 + 930)))) then
							v165 = v127.HandleIncorporeal(v31.Repentance, v33.RepentanceMouseover, 28 + 2, true);
							if (((3025 + 844) == (3316 + 553)) and v165) then
								return v165;
							end
							v234 = 4 - 3;
						end
						if (((2924 - (459 + 1307)) <= (4483 - (474 + 1396))) and (v234 == (1 - 0))) then
							v165 = v127.HandleIncorporeal(v31.TurnEvil, v33.TurnEvilMouseover, 29 + 1, true);
							if (v165 or ((8 + 2356) <= (5725 - 3726))) then
								return v165;
							end
							break;
						end
					end
				end
				if (v46 or ((624 + 4298) < (647 - 453))) then
					if ((v15:DebuffUp(v31.Entangled) and v31.BlessingofFreedom:IsReady()) or ((9119 - 7028) < (622 - (562 + 29)))) then
						if (v24(v33.BlessingofFreedomPlayer) or ((2072 + 358) >= (6291 - (374 + 1045)))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if ((v116 ~= "None") or ((3776 + 994) < (5387 - 3652))) then
					if ((v31.BeaconofLight:IsCastable() and (v127.NamedUnit(678 - (448 + 190), v116, 10 + 20) ~= nil) and v127.NamedUnit(19 + 21, v116, 20 + 10):BuffDown(v31.BeaconofLight)) or ((17067 - 12628) <= (7302 - 4952))) then
						if (v24(v33.BeaconofLightMacro) or ((5973 - (1307 + 187)) < (17710 - 13244))) then
							return "beacon_of_light combat";
						end
					end
				end
				if (((5963 - 3416) > (3756 - 2531)) and (v117 ~= "None")) then
					if (((5354 - (232 + 451)) > (2554 + 120)) and v31.BeaconofFaith:IsCastable() and (v127.NamedUnit(36 + 4, v117, 594 - (510 + 54)) ~= nil) and v127.NamedUnit(80 - 40, v117, 66 - (13 + 23)):BuffDown(v31.BeaconofFaith)) then
						if (v24(v33.BeaconofFaithMacro) or ((7204 - 3508) < (4780 - 1453))) then
							return "beacon_of_faith combat";
						end
					end
				end
				v164 = 8 - 3;
			end
			if (((1093 - (830 + 258)) == v164) or ((16022 - 11480) == (1859 + 1111))) then
				v165 = v136();
				if (((215 + 37) <= (3418 - (860 + 581))) and v165) then
					return v165;
				end
				v165 = v139();
				if (v165 or ((5296 - 3860) == (2996 + 779))) then
					return v165;
				end
				v164 = 247 - (237 + 4);
			end
		end
	end
	local function v144()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (0 - 0)) or ((3067 - 1449) < (762 + 168))) then
				if (((2713 + 2010) > (15679 - 11526)) and v42) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (0 + 0)) or ((5080 - (85 + 1341)) >= (7940 - 3286))) then
							ShouldReturn = v134();
							if (((2685 - 1734) <= (1868 - (45 + 327))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (v44 or ((3275 - 1539) == (1073 - (444 + 58)))) then
					local v236 = 0 + 0;
					while true do
						if ((v236 == (1 + 3)) or ((439 + 457) > (13820 - 9051))) then
							ShouldReturn = v127.HandleAfflicted(v31.HolyLight, v33.HolyLightMouseover, 1772 - (64 + 1668));
							if (ShouldReturn or ((3018 - (1227 + 746)) <= (3135 - 2115))) then
								return ShouldReturn;
							end
							break;
						end
						if ((v236 == (3 - 1)) or ((1654 - (415 + 79)) <= (9 + 319))) then
							ShouldReturn = v127.HandleAfflicted(v31.WordofGlory, v33.WordofGloryMouseover, 531 - (142 + 349));
							if (((1632 + 2176) > (4020 - 1096)) and ShouldReturn) then
								return ShouldReturn;
							end
							v236 = 2 + 1;
						end
						if (((2742 + 1149) < (13395 - 8476)) and (v236 == (1867 - (1710 + 154)))) then
							ShouldReturn = v127.HandleAfflicted(v31.FlashofLight, v33.FlashofLightMouseover, 358 - (200 + 118));
							if (ShouldReturn or ((886 + 1348) <= (2625 - 1123))) then
								return ShouldReturn;
							end
							v236 = 5 - 1;
						end
						if ((v236 == (0 + 0)) or ((2485 + 27) < (232 + 200))) then
							ShouldReturn = v127.HandleAfflicted(v31.Cleanse, v33.CleanseMouseover, 7 + 33);
							if (ShouldReturn or ((4003 - 2155) == (2115 - (363 + 887)))) then
								return ShouldReturn;
							end
							v236 = 1 - 0;
						end
						if ((v236 == (4 - 3)) or ((723 + 3959) <= (10625 - 6084))) then
							ShouldReturn = v127.HandleAfflicted(v31.HolyShock, v33.HolyShockMouseover, 28 + 12);
							if (ShouldReturn or ((4690 - (674 + 990)) >= (1160 + 2886))) then
								return ShouldReturn;
							end
							v236 = 1 + 1;
						end
					end
				end
				ShouldReturn = v127.HandleChromie(v31.Cleanse, v33.CleanseMouseover, 63 - 23);
				if (((3063 - (507 + 548)) > (1475 - (289 + 548))) and ShouldReturn) then
					return ShouldReturn;
				end
				v166 = 1819 - (821 + 997);
			end
			if (((2030 - (195 + 60)) <= (870 + 2363)) and (v166 == (1502 - (251 + 1250)))) then
				ShouldReturn = v127.HandleChromie(v31.HolyShock, v33.HolyShockMouseover, 117 - 77);
				if (ShouldReturn or ((3122 + 1421) == (3029 - (809 + 223)))) then
					return ShouldReturn;
				end
				ShouldReturn = v127.HandleChromie(v31.WordofGlory, v33.WordofGloryMouseover, 58 - 18);
				if (ShouldReturn or ((9315 - 6213) < (2406 - 1678))) then
					return ShouldReturn;
				end
				v166 = 2 + 0;
			end
			if (((181 + 164) == (962 - (14 + 603))) and ((133 - (118 + 11)) == v166)) then
				if (v127.TargetIsValid() or ((458 + 2369) < (315 + 63))) then
					local v237 = 0 - 0;
					local v238;
					while true do
						if ((v237 == (949 - (551 + 398))) or ((2197 + 1279) < (925 + 1672))) then
							v238 = v135();
							if (((2503 + 576) < (17829 - 13035)) and v238) then
								return v238;
							end
							break;
						end
					end
				end
				break;
			end
			if (((11184 - 6330) > (1447 + 3017)) and (v166 == (11 - 8))) then
				if (v45 or ((1357 + 3555) == (3847 - (40 + 49)))) then
					local v239 = 0 - 0;
					while true do
						if (((616 - (99 + 391)) <= (2881 + 601)) and (v239 == (4 - 3))) then
							ShouldReturn = v127.HandleIncorporeal(v31.TurnEvil, v33.TurnEvilMouseover, 74 - 44, true);
							if (ShouldReturn or ((2313 + 61) == (11509 - 7135))) then
								return ShouldReturn;
							end
							break;
						end
						if (((3179 - (1032 + 572)) == (1992 - (203 + 214))) and (v239 == (1817 - (568 + 1249)))) then
							ShouldReturn = v127.HandleIncorporeal(v31.Repentance, v33.RepentanceMouseover, 24 + 6, true);
							if (ShouldReturn or ((5365 - 3131) == (5620 - 4165))) then
								return ShouldReturn;
							end
							v239 = 1307 - (913 + 393);
						end
					end
				end
				if (v46 or ((3013 - 1946) > (2513 - 734))) then
					if (((2571 - (269 + 141)) >= (2076 - 1142)) and v15:DebuffUp(v31.Entangled) and v31.BlessingofFreedom:IsReady()) then
						if (((3593 - (362 + 1619)) == (3237 - (950 + 675))) and v24(v33.BlessingofFreedomPlayer)) then
							return "blessing_of_freedom out of combat";
						end
					end
				end
				if (((1678 + 2674) >= (4012 - (216 + 963))) and v118) then
					local v240 = 1287 - (485 + 802);
					local v241;
					while true do
						if (((559 - (432 + 127)) == v240) or ((4295 - (1065 + 8)) < (1707 + 1366))) then
							if (((2345 - (635 + 966)) <= (2116 + 826)) and (v116 ~= "None")) then
								if ((v31.BeaconofLight:IsCastable() and (v127.NamedUnit(82 - (5 + 37), v116, 74 - 44) ~= nil) and v127.NamedUnit(17 + 23, v116, 47 - 17):BuffDown(v31.BeaconofLight)) or ((858 + 975) <= (2746 - 1424))) then
									if (v24(v33.BeaconofLightMacro) or ((13144 - 9677) <= (1989 - 934))) then
										return "beacon_of_light combat";
									end
								end
							end
							if (((8466 - 4925) == (2547 + 994)) and (v117 ~= "None")) then
								if ((v31.BeaconofFaith:IsCastable() and (v127.NamedUnit(569 - (318 + 211), v117, 147 - 117) ~= nil) and v127.NamedUnit(1627 - (963 + 624), v117, 13 + 17):BuffDown(v31.BeaconofFaith)) or ((4403 - (518 + 328)) >= (9331 - 5328))) then
									if (v24(v33.BeaconofFaithMacro) or ((1050 - 393) >= (1985 - (301 + 16)))) then
										return "beacon_of_faith combat";
									end
								end
							end
							v240 = 2 - 1;
						end
						if ((v240 == (2 - 1)) or ((2679 - 1652) > (3495 + 363))) then
							v241 = v142();
							if (v241 or ((2075 + 1579) < (960 - 510))) then
								return v241;
							end
							break;
						end
					end
				end
				if (((1138 + 753) < (424 + 4029)) and v31.DevotionAura:IsCastable() and v15:BuffDown(v31.DevotionAura)) then
					if (v24(v31.DevotionAura) or ((9983 - 6843) < (688 + 1441))) then
						return "devotion_aura";
					end
				end
				v166 = 1023 - (829 + 190);
			end
			if ((v166 == (7 - 5)) or ((3232 - 677) < (1714 - 474))) then
				ShouldReturn = v127.HandleChromie(v31.FlashofLight, v33.FlashofLightMouseover, 99 - 59);
				if (ShouldReturn or ((1121 + 3606) <= (1543 + 3179))) then
					return ShouldReturn;
				end
				ShouldReturn = v127.HandleChromie(v31.HolyLight, v33.HolyLightMouseover, 121 - 81);
				if (((699 + 41) < (5550 - (520 + 93))) and ShouldReturn) then
					return ShouldReturn;
				end
				v166 = 279 - (259 + 17);
			end
		end
	end
	local function v145()
		local v167 = 0 + 0;
		while true do
			if (((1317 + 2341) >= (947 - 667)) and (v167 == (598 - (396 + 195)))) then
				v66 = EpicSettings.Settings['UseDivineShield'];
				v67 = EpicSettings.Settings['DivineShieldHP'] or (0 - 0);
				v68 = EpicSettings.Settings['UseWordOfGlory'];
				v69 = EpicSettings.Settings['WordofGlorydHP'] or (1761 - (440 + 1321));
				v167 = 1837 - (1059 + 770);
			end
			if ((v167 == (41 - 32)) or ((1430 - (424 + 121)) >= (188 + 843))) then
				v74 = EpicSettings.Settings['AuraMasteryhHP'] or (1347 - (641 + 706));
				v75 = EpicSettings.Settings['AuraMasteryGroup'] or (0 + 0);
				v76 = EpicSettings.Settings['UseBlessingOfSacrifice'];
				v77 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (440 - (249 + 191));
				v167 = 43 - 33;
			end
			if (((1588 + 1966) >= (2023 - 1498)) and ((435 - (183 + 244)) == v167)) then
				v70 = EpicSettings.Settings['UseAvengingWrath'];
				v71 = EpicSettings.Settings['AvengingWrathHP'] or (0 + 0);
				v72 = EpicSettings.Settings['AvengingWrathGroup'] or (730 - (434 + 296));
				v73 = EpicSettings.Settings['UseAuraMastery'];
				v167 = 28 - 19;
			end
			if (((2926 - (169 + 343)) <= (2606 + 366)) and (v167 == (17 - 7))) then
				v78 = EpicSettings.Settings['UseHolyShock'];
				v79 = EpicSettings.Settings['HolyShockHP'] or (0 - 0);
				break;
			end
			if (((2892 + 637) <= (10033 - 6495)) and (v167 == (1129 - (651 + 472)))) then
				v62 = EpicSettings.Settings['UseLayOnHands'];
				v63 = EpicSettings.Settings['LayOnHandsHP'] or (0 + 0);
				v64 = EpicSettings.Settings['UseDivineProtection'];
				v65 = EpicSettings.Settings['DivineProtectionHP'] or (0 + 0);
				v167 = 8 - 1;
			end
			if ((v167 == (486 - (397 + 86))) or ((3737 - (423 + 453)) < (47 + 411))) then
				v46 = EpicSettings.Settings['HandleEntangling'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v167 = 4 + 0;
			end
			if (((1371 + 346) <= (4043 + 482)) and (v167 == (1194 - (50 + 1140)))) then
				v54 = EpicSettings.Settings['UseHealthstone'];
				v55 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v56 = EpicSettings.Settings['UseAvengingWrathOffensively'];
				v57 = EpicSettings.Settings['UseDivineTollOffensively'];
				v167 = 3 + 2;
			end
			if ((v167 == (1 + 0)) or ((4563 - 1385) <= (1103 + 421))) then
				v38 = EpicSettings.Settings['UsePowerWordFortitude'];
				v39 = EpicSettings.Settings['UseAngelicFeather'];
				v40 = EpicSettings.Settings['UseBodyAndSoul'];
				v41 = EpicSettings.Settings['MovementDelay'] or (596 - (157 + 439));
				v167 = 2 - 0;
			end
			if (((14134 - 9880) > (1094 - 724)) and (v167 == (923 - (782 + 136)))) then
				v58 = EpicSettings.Settings['UseHolyShockOffensively'];
				v59 = EpicSettings.Settings['UseHolyShockCycle'];
				v60 = EpicSettings.Settings['UseHolyShockGroup'] or (855 - (112 + 743));
				v61 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
				v167 = 1177 - (1026 + 145);
			end
			if (((1 + 1) == v167) or ((2353 - (493 + 225)) == (6531 - 4754))) then
				v42 = EpicSettings.Settings['DispelDebuffs'];
				v43 = EpicSettings.Settings['DispelBuffs'];
				v44 = EpicSettings.Settings['HandleAfflicted'];
				v45 = EpicSettings.Settings['HandleIncorporeal'];
				v167 = 2 + 1;
			end
			if ((v167 == (0 - 0)) or ((64 + 3274) >= (11411 - 7418))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or "";
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v167 = 1 - 0;
			end
		end
	end
	local function v146()
		v80 = EpicSettings.Settings['UseFlashOfLight'];
		v81 = EpicSettings.Settings['FlashOfLightHP'] or (1595 - (210 + 1385));
		v82 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (1689 - (1201 + 488));
		v83 = EpicSettings.Settings['UseHolyLight'];
		v84 = EpicSettings.Settings['HolyLightHP'] or (0 + 0);
		v68 = EpicSettings.Settings['UseWordOfGlory'];
		v85 = EpicSettings.Settings['WordOfGloryHP'] or (0 - 0);
		v86 = EpicSettings.Settings['UseBeaconOfVirtue'];
		v87 = EpicSettings.Settings['BeaconOfVirtueHP'] or (0 - 0);
		v88 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (585 - (352 + 233));
		v89 = EpicSettings.Settings['UseLightOfDawn'];
		v90 = EpicSettings.Settings['LightOfDawnhHP'] or (0 - 0);
		v91 = EpicSettings.Settings['LightOfDawnGroup'] or (0 + 0);
		v92 = EpicSettings.Settings['UseDivineToll'];
		v93 = EpicSettings.Settings['DivineTollHP'] or (0 - 0);
		v94 = EpicSettings.Settings['DivineTollGroup'] or (574 - (489 + 85));
		v95 = EpicSettings.Settings['UseHolyPrism'];
		v96 = EpicSettings.Settings['UseHolyPrismOffensively'];
		v97 = EpicSettings.Settings['HolyPrismHP'] or (1501 - (277 + 1224));
		v98 = EpicSettings.Settings['LightsHammerUsage'] or "";
		v99 = EpicSettings.Settings['LightsHammerHP'] or (1493 - (663 + 830));
		v100 = EpicSettings.Settings['LightsHammerGroup'] or (0 + 0);
		v101 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
		v102 = EpicSettings.Settings['BlessingOfProtection'] or (0 - 0);
		v103 = EpicSettings.Settings['UseDaybreak'];
		v104 = EpicSettings.Settings['DaybreakMana'] or (875 - (461 + 414));
		v105 = EpicSettings.Settings['DaybreakHP'] or (0 + 0);
		v106 = EpicSettings.Settings['DaybreakHGroup'] or (0 + 0);
		v107 = EpicSettings.Settings['DaybreakGroup'] or (0 + 0);
		v108 = EpicSettings.Settings['UseTyrsDeliverance'];
		v109 = EpicSettings.Settings['TyrsDeliveranceHP'] or (0 + 0);
		v110 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (250 - (172 + 78));
		v111 = EpicSettings.Settings['UseHandOfDivinity'];
		v112 = EpicSettings.Settings['HandOfDivinityHP'] or (0 - 0);
		v113 = EpicSettings.Settings['HandOfDivinityGroup'] or (0 + 0);
		v114 = EpicSettings.Settings['UseBarrierOfFaith'];
		v115 = EpicSettings.Settings['BarrierOfFaithHP'] or (0 - 0);
		v116 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
		v117 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
	end
	local function v147()
		local v180 = 0 + 0;
		while true do
			if (((386 + 768) <= (2471 - 996)) and (v180 == (0 - 0))) then
				v145();
				v146();
				v118 = EpicSettings.Toggles['ooc'];
				v180 = 1 + 0;
			end
			if ((v180 == (3 + 1)) or ((929 + 1681) < (4896 - 3666))) then
				v125 = v15:GetEnemiesInMeleeRange(18 - 10);
				if (AOE or ((445 + 1003) == (1761 + 1322))) then
					v126 = #v125;
				else
					v126 = 448 - (133 + 314);
				end
				if (((546 + 2593) > (1129 - (199 + 14))) and not v15:IsChanneling()) then
					if (((10574 - 7620) == (4503 - (647 + 902))) and (v118 or v15:AffectingCombat())) then
						if (((351 - 234) <= (3125 - (85 + 148))) and v15:AffectingCombat()) then
							local v246 = 1289 - (426 + 863);
							local v247;
							while true do
								if ((v246 == (0 - 0)) or ((2107 - (873 + 781)) > (6242 - 1580))) then
									v247 = v143();
									if (((3564 - 2244) > (247 + 348)) and v247) then
										return v247;
									end
									break;
								end
							end
						else
							local v248 = 0 - 0;
							local v249;
							while true do
								if ((v248 == (0 - 0)) or ((9498 - 6299) < (2537 - (414 + 1533)))) then
									v249 = v144();
									if (v249 or ((4156 + 637) < (585 - (443 + 112)))) then
										return v249;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if ((v180 == (1481 - (888 + 591))) or ((4382 - 2686) <= (61 + 998))) then
				v122 = EpicSettings.Toggles['cycle'];
				v123 = EpicSettings.Toggles['lod'];
				if (((8824 - 6481) == (915 + 1428)) and v15:IsMounted()) then
					return;
				end
				v180 = 2 + 1;
			end
			if ((v180 == (1 + 0)) or ((1987 - 944) > (6651 - 3060))) then
				v119 = EpicSettings.Toggles['cds'];
				v120 = EpicSettings.Toggles['dispel'];
				v121 = EpicSettings.Toggles['spread'];
				v180 = 1680 - (136 + 1542);
			end
			if (((9 - 6) == v180) or ((2869 + 21) >= (6485 - 2406))) then
				if (((3238 + 1236) <= (5256 - (68 + 418))) and v15:IsDeadOrGhost()) then
					return;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((13396 - 8454) == (7081 - 3178))) then
					local v242 = v127.DeadFriendlyUnitsCount();
					if (v15:AffectingCombat() or ((215 + 33) > (5937 - (770 + 322)))) then
						if (((91 + 1478) == (454 + 1115)) and v31.Intercession:IsCastable()) then
							if (v24(v31.Intercession, nil, true) or ((673 + 4254) <= (4608 - 1387))) then
								return "intercession";
							end
						end
					elseif ((v242 > (1 - 0)) or ((4847 - 3067) > (10251 - 7464))) then
						if (v24(v31.Absolution, nil, true) or ((2193 + 1744) <= (1842 - 612))) then
							return "absolution";
						end
					elseif (v24(v31.Redemption, not v17:IsInRange(20 + 20), true) or ((1617 + 1020) < (1337 + 369))) then
						return "redemption";
					end
				end
				if (v15:AffectingCombat() or (v42 and v120) or ((10050 - 7381) <= (3345 - 936))) then
					local v243 = 0 + 0;
					local v244;
					local v245;
					while true do
						if (((4 - 3) == v243) or ((4631 - 3230) > (1932 + 2764))) then
							if (v245 or ((16230 - 12950) < (2152 - (762 + 69)))) then
								return v245;
							end
							break;
						end
						if (((15954 - 11027) >= (1985 + 318)) and (v243 == (0 + 0))) then
							v244 = v42 and v31.Cleanse:IsReady();
							v245 = v127.FocusUnit(v244, v33, 48 - 28);
							v243 = 1 + 0;
						end
					end
				end
				v180 = 1 + 3;
			end
		end
	end
	local function v148()
		local v181 = 0 - 0;
		while true do
			if (((3619 - (8 + 149)) >= (2352 - (1199 + 121))) and (v181 == (1 - 0))) then
				v127.DispellableDebuffs = v12.MergeTable(v127.DispellableDebuffs, v127.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.00 By BoomK");
				break;
			end
			if ((v181 == (0 - 0)) or ((444 + 633) >= (7178 - 5167))) then
				v21.Print("Holy Paladin by Epic.");
				v127.DispellableDebuffs = v127.DispellableMagicDebuffs;
				v181 = 2 - 1;
			end
		end
	end
	v21.SetAPL(58 + 7, v147, v148);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

