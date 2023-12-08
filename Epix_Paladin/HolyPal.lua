local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1321 + 2339) <= (3566 - 1501))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_HolyPal.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Focus;
	local v14 = v12.Player;
	local v15 = v12.MouseOver;
	local v16 = v12.Target;
	local v17 = v12.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Press;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = math.floor;
	local v27 = string.format;
	local v28 = GetTotemInfo;
	local v29 = GetTime;
	local v30 = v18.Paladin.Holy;
	local v31 = v19.Paladin.Holy;
	local v32 = v22.Paladin.Holy;
	local v33;
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
	local v67;
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
	local v117 = false;
	local v118 = false;
	local v119 = false;
	local v120 = false;
	local v121 = false;
	local v122 = false;
	local v123 = {};
	local v124;
	local v125;
	local v126 = v20.Commons.Everyone;
	local function v127(v148)
		return v148:DebuffRefreshable(v30.JudgmentDebuff);
	end
	local function v128()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (0 + 0)) or ((9137 - 5027) > (201 + 4175))) then
				for v225 = 3 - 2, 4 + 0 do
					local v226 = 0 - 0;
					local v227;
					local v228;
					local v229;
					local v230;
					while true do
						if ((v226 == (0 + 0)) or ((2119 - (457 + 32)) > (1782 + 2416))) then
							v227, v228, v229, v230 = v28(v225);
							if (((2456 - (832 + 570)) == (993 + 61)) and (v228 == v30.Consecration:Name())) then
								return (v26(((v229 + v230) - v29()) + 0.5 + 0)) or (0 - 0);
							end
							break;
						end
					end
				end
				return 0 + 0;
			end
		end
	end
	local function v129(v150)
		return v150:DebuffRefreshable(v30.GlimmerofLightBuff) or not v60;
	end
	local function v130()
		if ((v30.BlessingofSummer:IsCastable() and v14:IsInParty() and not v14:IsInRaid()) or ((1472 - (588 + 208)) >= (4425 - 2783))) then
			if (((5936 - (884 + 916)) > (5017 - 2620)) and v13 and v13:Exists() and (v126.UnitGroupRole(v13) == "DAMAGER")) then
				if (v23(v32.BlessingofSummerFocus) or ((2513 + 1821) == (4898 - (232 + 421)))) then
					return "blessing_of_summer";
				end
			end
		end
		local v151 = {v30.BlessingofSpring,v30.BlessingofSummer,v30.BlessingofAutumn,v30.BlessingofWinter};
		for v195, v196 in pairs(v151) do
			if (v196:IsCastable() or ((4881 - (316 + 289)) <= (7934 - 4903))) then
				if (v23(v32.BlessingofSummerPlayer) or ((221 + 4561) <= (2652 - (666 + 787)))) then
					return "blessing_of_the_seasons";
				end
			end
		end
	end
	local function v131()
		local v152 = 425 - (360 + 65);
		while true do
			if ((v152 == (1 + 0)) or ((5118 - (79 + 175)) < (2998 - 1096))) then
				ShouldReturn = v126.HandleBottomTrinket(v123, v118, 32 + 8, nil);
				if (((14832 - 9993) >= (7125 - 3425)) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
			if ((v152 == (899 - (503 + 396))) or ((1256 - (92 + 89)) > (3720 - 1802))) then
				ShouldReturn = v126.HandleTopTrinket(v123, v118, 21 + 19, nil);
				if (((235 + 161) <= (14896 - 11092)) and ShouldReturn) then
					return ShouldReturn;
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v132()
		if ((not v14:IsCasting() and not v14:IsChanneling()) or ((9505 - 5336) == (1909 + 278))) then
			local v197 = 0 + 0;
			local v198;
			while true do
				if (((4281 - 2875) == (176 + 1230)) and (v197 == (1 - 0))) then
					v198 = v126.InterruptWithStun(v30.HammerofJustice, 1252 - (485 + 759));
					if (((3542 - 2011) < (5460 - (442 + 747))) and v198) then
						return v198;
					end
					break;
				end
				if (((1770 - (832 + 303)) == (1581 - (88 + 858))) and (v197 == (0 + 0))) then
					v198 = v126.Interrupt(v30.Rebuke, 5 + 0, true);
					if (((139 + 3234) <= (4345 - (766 + 23))) and v198) then
						return v198;
					end
					v197 = 4 - 3;
				end
			end
		end
	end
	local function v133()
		if (not v13 or not v13:Exists() or not v13:IsInRange(54 - 14) or not v126.DispellableFriendlyUnit() or ((8670 - 5379) < (11132 - 7852))) then
			return;
		end
		if (((5459 - (1036 + 37)) >= (619 + 254)) and v30.Cleanse:IsReady()) then
			if (((1793 - 872) <= (867 + 235)) and v23(v32.CleanseFocus)) then
				return "cleanse dispel";
			end
		end
	end
	local function v134()
		local v153 = 1480 - (641 + 839);
		while true do
			if (((5619 - (910 + 3)) >= (2454 - 1491)) and ((1684 - (1466 + 218)) == v153)) then
				if ((v30.Consecration:IsCastable() and v16:IsInMeleeRange(3 + 2)) or ((2108 - (556 + 592)) <= (312 + 564))) then
					if (v23(v30.Consecration) or ((2874 - (329 + 479)) == (1786 - (174 + 680)))) then
						return "consecrate precombat 4";
					end
				end
				if (((16579 - 11754) < (10037 - 5194)) and v30.Judgment:IsReady()) then
					if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((2769 + 1108) >= (5276 - (396 + 343)))) then
						return "judgment precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v135()
		if (((v14:HealthPercentage() <= v62) and v61 and v30.LayonHands:IsCastable()) or ((382 + 3933) < (3203 - (29 + 1448)))) then
			if (v23(v32.LayonHandsPlayer) or ((5068 - (135 + 1254)) < (2354 - 1729))) then
				return "lay_on_hands defensive";
			end
		end
		if ((v30.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v66) and v65) or ((21594 - 16969) < (422 + 210))) then
			if (v23(v30.DivineProtection) or ((1610 - (389 + 1138)) > (2354 - (102 + 472)))) then
				return "divine protection";
			end
		end
		if (((516 + 30) <= (598 + 479)) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (3 + 0)) and (v14:HealthPercentage() <= v84) and v67 and not v14:HealingAbsorbed()) then
			if (v23(v32.WordofGloryPlayer) or ((2541 - (320 + 1225)) > (7656 - 3355))) then
				return "WOG self";
			end
		end
		if (((2491 + 1579) > (2151 - (157 + 1307))) and v31.Healthstone:IsReady() and v53 and (v14:HealthPercentage() <= v54)) then
			if (v23(v32.Healthstone, nil, nil, true) or ((2515 - (821 + 1038)) >= (8308 - 4978))) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v14:HealthPercentage() <= v36)) or ((273 + 2219) <= (594 - 259))) then
			if (((1609 + 2713) >= (6349 - 3787)) and (v35 == "Refreshing Healing Potion")) then
				if (v31.RefreshingHealingPotion:IsReady() or ((4663 - (834 + 192)) >= (240 + 3530))) then
					if (v23(v32.RefreshingHealingPotion, nil, nil, true) or ((611 + 1768) > (99 + 4479))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v136()
		if ((v55 and v118 and v30.AvengingWrath:IsReady() and not v14:BuffUp(v30.AvengingWrathBuff)) or ((748 - 265) > (1047 - (300 + 4)))) then
			if (((656 + 1798) > (1513 - 935)) and v23(v30.AvengingWrath)) then
				return "avenging_wrath cooldowns 4";
			end
		end
		local v154 = v130();
		if (((1292 - (112 + 250)) < (1778 + 2680)) and v154) then
			return v154;
		end
		if (((1658 - 996) <= (557 + 415)) and v56 and v118 and v30.DivineToll:IsCastable() and v14:BuffUp(v30.AvengingWrathBuff)) then
			if (((2260 + 2110) == (3269 + 1101)) and v23(v30.DivineToll)) then
				return "divine_toll cooldowns 8";
			end
		end
		if (v30.BloodFury:IsCastable() or ((2362 + 2400) <= (640 + 221))) then
			if (v23(v30.BloodFury) or ((2826 - (1001 + 413)) == (9508 - 5244))) then
				return "blood_fury cooldowns 12";
			end
		end
		if (v30.Berserking:IsCastable() or ((4050 - (244 + 638)) < (2846 - (627 + 66)))) then
			if (v23(v30.Berserking) or ((14826 - 9850) < (1934 - (512 + 90)))) then
				return "berserking cooldowns 14";
			end
		end
		if (((6534 - (1665 + 241)) == (5345 - (373 + 344))) and v30.HolyAvenger:IsCastable()) then
			if (v23(v30.HolyAvenger) or ((25 + 29) == (105 + 290))) then
				return "holy_avenger cooldowns 16";
			end
		end
		v154 = v126.HandleTopTrinket(v123, v118, 105 - 65, nil);
		if (((138 - 56) == (1181 - (35 + 1064))) and v154) then
			return v154;
		end
		v154 = v126.HandleBottomTrinket(v123, v118, 30 + 10, nil);
		if (v154 or ((1242 - 661) < (2 + 280))) then
			return v154;
		end
		if (v30.Seraphim:IsReady() or ((5845 - (298 + 938)) < (3754 - (233 + 1026)))) then
			if (((2818 - (636 + 1030)) == (589 + 563)) and v23(v30.Seraphim)) then
				return "seraphim cooldowns 18";
			end
		end
	end
	local function v137()
		if (((1852 + 44) <= (1017 + 2405)) and v118) then
			local v199 = 0 + 0;
			local v200;
			while true do
				if (((221 - (55 + 166)) == v199) or ((192 + 798) > (163 + 1457))) then
					v200 = v136();
					if (v200 or ((3349 - 2472) > (4992 - (36 + 261)))) then
						return v200;
					end
					break;
				end
			end
		end
		if (((4705 - 2014) >= (3219 - (34 + 1334))) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:BuffUp(v30.AvengingWrathBuff) or v14:BuffUp(v30.HolyAvenger) or not v30.Awakening:IsAvailable())) then
			if (v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(2 + 3)) or ((2320 + 665) >= (6139 - (1035 + 248)))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if (((4297 - (20 + 1)) >= (623 + 572)) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:HolyPower() >= (322 - (134 + 185))) and (v126.LowestFriendlyUnit(1173 - (549 + 584), nil, 705 - (314 + 371)):HealthPercentage() > v68) and (v126.FriendlyUnitsBelowHealthPercentageCount(v89) < v90)) then
			if (((11095 - 7863) <= (5658 - (478 + 490))) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(3 + 2))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if ((v30.HammerofWrath:IsReady() and (v14:HolyPower() < (1177 - (786 + 386))) and (v125 == (6 - 4))) or ((2275 - (1055 + 324)) >= (4486 - (1093 + 247)))) then
			if (((2721 + 340) >= (312 + 2646)) and v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath))) then
				return "hammer_of_wrath priority 4";
			end
		end
		if (((12652 - 9465) >= (2185 - 1541)) and (LightsHammerLightsHammerUsage == "Player")) then
			if (((1832 - 1188) <= (1768 - 1064)) and v30.LightsHammer:IsCastable() and (v125 >= (1 + 1))) then
				if (((3690 - 2732) > (3264 - 2317)) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(7 + 1))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((11487 - 6995) >= (3342 - (364 + 324))) and (LightsHammerLightsHammerUsage == "Cursor")) then
			if (((9435 - 5993) >= (3606 - 2103)) and v30.LightsHammer:IsCastable()) then
				if (v23(v32.LightsHammercursor) or ((1051 + 2119) <= (6125 - 4661))) then
					return "lights_hammer priority 6";
				end
			end
		elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((7681 - 2884) == (13326 - 8938))) then
			if (((1819 - (1249 + 19)) <= (615 + 66)) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
				if (((12755 - 9478) > (1493 - (686 + 400))) and v23(v32.LightsHammercursor)) then
					return "lights_hammer priority 6";
				end
			end
		end
		if (((3684 + 1011) >= (1644 - (73 + 156))) and v30.Consecration:IsCastable() and (v125 >= (1 + 1)) and (v128() <= (811 - (721 + 90)))) then
			if (v23(v30.Consecration, not v16:IsInMeleeRange(1 + 4)) or ((10428 - 7216) <= (1414 - (224 + 246)))) then
				return "consecration priority 8";
			end
		end
		if ((v30.LightofDawn:IsReady() and v122 and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or ((v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (2 - 0)) and ((v14:HolyPower() >= (9 - 4)) or (v14:BuffUp(v30.HolyAvenger) and (v14:HolyPower() >= (1 + 2))))))) or ((74 + 3022) <= (1321 + 477))) then
			if (((7031 - 3494) == (11770 - 8233)) and v23(v30.LightofDawn)) then
				return "light_of_dawn priority 10";
			end
		end
		if (((4350 - (203 + 310)) >= (3563 - (1238 + 755))) and v30.ShieldoftheRighteousHoly:IsReady() and (v125 > (1 + 2))) then
			if (v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(1539 - (709 + 825))) or ((5436 - 2486) == (5552 - 1740))) then
				return "shield_of_the_righteous priority 12";
			end
		end
		if (((5587 - (196 + 668)) >= (9151 - 6833)) and v30.HammerofWrath:IsReady()) then
			if (v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath)) or ((4198 - 2171) > (3685 - (171 + 662)))) then
				return "hammer_of_wrath priority 14";
			end
		end
		if (v30.Judgment:IsReady() or ((1229 - (4 + 89)) > (15130 - 10813))) then
			if (((1729 + 3019) == (20854 - 16106)) and v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment))) then
				return "judgment priority 16";
			end
		end
		if (((1466 + 2270) <= (6226 - (35 + 1451))) and (LightsHammer == "Player")) then
			if (v30.LightsHammer:IsCastable() or ((4843 - (28 + 1425)) <= (5053 - (941 + 1052)))) then
				if (v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(8 + 0)) or ((2513 - (822 + 692)) > (3843 - 1150))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((219 + 244) < (898 - (45 + 252))) and (LightsHammer == "Cursor")) then
			if (v30.LightsHammer:IsCastable() or ((2160 + 23) < (237 + 450))) then
				if (((11070 - 6521) == (4982 - (114 + 319))) and v23(v32.LightsHammercursor)) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((6707 - 2035) == (5986 - 1314)) and (LightsHammer == "Enemy Under Cursor")) then
			if ((v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) or ((2339 + 1329) < (588 - 193))) then
				if (v23(v32.LightsHammercursor) or ((8728 - 4562) == (2418 - (556 + 1407)))) then
					return "lights_hammer priority 6";
				end
			end
		end
		if ((v30.Consecration:IsCastable() and (v128() <= (1206 - (741 + 465)))) or ((4914 - (170 + 295)) == (1404 + 1259))) then
			if (v23(v30.Consecration, not v16:IsInMeleeRange(5 + 0)) or ((10530 - 6253) < (2478 + 511))) then
				return "consecration priority 20";
			end
		end
		if ((v57 and v30.HolyShock:IsReady() and v16:DebuffDown(v30.GlimmerofLightBuff) and (not v30.GlimmerofLight:IsAvailable() or v129(v16))) or ((558 + 312) >= (2350 + 1799))) then
			if (((3442 - (957 + 273)) < (852 + 2331)) and v23(v30.HolyShock, not v16:IsSpellInRange(v30.HolyShock))) then
				return "holy_shock damage";
			end
		end
		if (((1860 + 2786) > (11400 - 8408)) and v57 and v58 and v30.HolyShock:IsReady() and (v126.EnemiesWithDebuffCount(v30.GlimmerofLightBuff, 105 - 65) < v59) and v121) then
			if (((4379 - 2945) < (15379 - 12273)) and v126.CastCycle(v30.HolyShock, v124, v129, not v16:IsSpellInRange(v30.HolyShock), nil, nil, v32.HolyShockMouseover)) then
				return "holy_shock_cycle damage";
			end
		end
		if (((2566 - (389 + 1391)) < (1897 + 1126)) and v30.CrusaderStrike:IsReady() and (v30.CrusaderStrike:Charges() == (1 + 1))) then
			if (v23(v30.CrusaderStrike, not v16:IsInMeleeRange(11 - 6)) or ((3393 - (783 + 168)) < (248 - 174))) then
				return "crusader_strike priority 24";
			end
		end
		if (((4461 + 74) == (4846 - (309 + 2))) and v30.HolyPrism:IsReady() and (v125 >= (5 - 3)) and v95) then
			if (v23(v32.HolyPrismPlayer) or ((4221 - (1090 + 122)) <= (683 + 1422))) then
				return "holy_prism on self priority 26";
			end
		end
		if (((6146 - 4316) < (2511 + 1158)) and v30.HolyPrism:IsReady() and v95) then
			if (v23(v30.HolyPrism, not v16:IsSpellInRange(v30.HolyPrism)) or ((2548 - (628 + 490)) >= (648 + 2964))) then
				return "holy_prism priority 28";
			end
		end
		if (((6642 - 3959) >= (11242 - 8782)) and v30.ArcaneTorrent:IsCastable()) then
			if (v23(v30.ArcaneTorrent) or ((2578 - (431 + 343)) >= (6614 - 3339))) then
				return "arcane_torrent priority 30";
			end
		end
		if ((v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (8 - 5)) and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (2 + 0)))) or ((182 + 1235) > (5324 - (556 + 1139)))) then
			if (((4810 - (6 + 9)) > (74 + 328)) and v23(v30.LightofDawn, not v16:IsSpellInRange(v30.LightofDawn))) then
				return "light_of_dawn priority 32";
			end
		end
		if (((2466 + 2347) > (3734 - (28 + 141))) and v30.CrusaderStrike:IsReady()) then
			if (((1516 + 2396) == (4828 - 916)) and v23(v30.CrusaderStrike, not v16:IsInMeleeRange(4 + 1))) then
				return "crusader_strike priority 34";
			end
		end
		if (((4138 - (486 + 831)) <= (12553 - 7729)) and v30.Consecration:IsReady()) then
			if (((6118 - 4380) <= (415 + 1780)) and v23(v30.Consecration, not v16:IsInMeleeRange(15 - 10))) then
				return "consecration priority 36";
			end
		end
	end
	local function v138()
		if (((1304 - (668 + 595)) <= (2716 + 302)) and (not v13 or not v13:Exists() or not v13:IsInRange(9 + 31))) then
			return;
		end
		if (((5849 - 3704) <= (4394 - (23 + 267))) and v30.LayonHands:IsCastable() and (v13:HealthPercentage() <= v62) and v61) then
			if (((4633 - (1129 + 815)) < (5232 - (371 + 16))) and v23(v32.LayonHandsFocus)) then
				return "lay_on_hands cooldown_healing";
			end
		end
		if ((v100 == "Not Tank") or ((4072 - (1326 + 424)) > (4965 - 2343))) then
			if ((v30.BlessingofProtection:IsCastable() and (v13:HealthPercentage() <= v101) and (not v126.UnitGroupRole(v13) == "TANK")) or ((16568 - 12034) == (2200 - (88 + 30)))) then
				if (v23(v32.BlessingofProtectionFocus) or ((2342 - (720 + 51)) > (4153 - 2286))) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		elseif ((v100 == "Player") or ((4430 - (421 + 1355)) >= (4942 - 1946))) then
			if (((1955 + 2023) > (3187 - (286 + 797))) and v30.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v101)) then
				if (((10948 - 7953) > (2552 - 1011)) and v23(v32.BlessingofProtectionplayer)) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		end
		if (((3688 - (397 + 42)) > (298 + 655)) and v30.AuraMastery:IsCastable() and v126.AreUnitsBelowHealthPercentage(v73, v74) and v72) then
			if (v23(v30.AuraMastery) or ((4073 - (24 + 776)) > (7044 - 2471))) then
				return "aura_mastery cooldown_healing";
			end
		end
		if ((v30.AvengingWrath:IsCastable() and not v14:BuffUp(v30.AvengingWrathBuff) and v126.AreUnitsBelowHealthPercentage(v70, v71) and v69) or ((3936 - (222 + 563)) < (2828 - 1544))) then
			if (v23(v30.AvengingWrath) or ((1332 + 518) == (1719 - (23 + 167)))) then
				return "avenging_wrath cooldown_healing";
			end
		end
		if (((2619 - (690 + 1108)) < (766 + 1357)) and v30.TyrsDeliverance:IsCastable() and v107 and v126.AreUnitsBelowHealthPercentage(v108, v109)) then
			if (((745 + 157) < (3173 - (40 + 808))) and v23(v30.TyrsDeliverance)) then
				return "tyrs_deliverance cooldown_healing";
			end
		end
		if (((142 + 716) <= (11326 - 8364)) and v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) then
			if (v23(v32.BeaconofVirtueFocus) or ((3772 + 174) < (682 + 606))) then
				return "beacon_of_virtue cooldown_healing";
			end
		end
		if ((v30.Daybreak:IsReady() and (v126.FriendlyUnitsWithBuffCount(v30.GlimmerofLightBuff, false, false) > v106) and (v126.AreUnitsBelowHealthPercentage(v104, v105) or (v14:ManaPercentage() <= v103)) and v102) or ((1778 + 1464) == (1138 - (47 + 524)))) then
			if (v23(v30.Daybreak) or ((550 + 297) >= (3452 - 2189))) then
				return "daybreak cooldown_healing";
			end
		end
		if ((v30.HandofDivinity:IsReady() and v126.AreUnitsBelowHealthPercentage(v111, v112) and v110) or ((3368 - 1115) == (4221 - 2370))) then
			if (v23(v30.HandofDivinity) or ((3813 - (1165 + 561)) > (71 + 2301))) then
				return "divine_toll cooldown_healing";
			end
		end
		if ((v30.DivineToll:IsReady() and v126.AreUnitsBelowHealthPercentage(v92, v93) and v91) or ((13766 - 9321) < (1584 + 2565))) then
			if (v23(v32.DivineTollFocus) or ((2297 - (341 + 138)) == (23 + 62))) then
				return "divine_toll cooldown_healing";
			end
		end
		if (((1300 - 670) < (2453 - (89 + 237))) and v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) then
			if (v23(v32.HolyShockFocus) or ((6234 - 4296) == (5292 - 2778))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((5136 - (581 + 300)) >= (1275 - (855 + 365))) and v30.BlessingofSacrifice:IsReady() and (v13:GUID() ~= v14:GUID()) and (v13:HealthPercentage() <= v76) and v75) then
			if (((7123 - 4124) > (378 + 778)) and v23(v32.BlessingofSacrificeFocus)) then
				return "blessing_of_sacrifice cooldown_healing";
			end
		end
	end
	local function v139()
		local v155 = 1235 - (1030 + 205);
		while true do
			if (((2207 + 143) > (1075 + 80)) and ((288 - (156 + 130)) == v155)) then
				if (((9154 - 5125) <= (8179 - 3326)) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (5 - 2)) and (v13:HealthPercentage() <= v84) and UseWodOfGlory and (v126.FriendlyUnitsBelowHealthPercentageCount(v84) < (1 + 2))) then
					if (v23(v32.WordofGloryFocus) or ((301 + 215) > (3503 - (10 + 59)))) then
						return "word_of_glory aoe_healing";
					end
				end
				if (((1145 + 2901) >= (14936 - 11903)) and v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (v23(v32.LightoftheMartyrFocus) or ((3882 - (671 + 492)) <= (1152 + 295))) then
						return "holy_shock cooldown_healing";
					end
				end
				v155 = 1218 - (369 + 846);
			end
			if ((v155 == (1 + 0)) or ((3528 + 606) < (5871 - (1036 + 909)))) then
				if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (3 + 0)) and v14:BuffUp(v30.UnendingLightBuff) and (v13:HealthPercentage() <= v84) and v67) or ((274 - 110) >= (2988 - (11 + 192)))) then
					if (v23(v32.WordofGloryFocus) or ((266 + 259) == (2284 - (135 + 40)))) then
						return "word_of_glory aoe_healing";
					end
				end
				if (((79 - 46) == (20 + 13)) and v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (6 - 3)) and (v126.AreUnitsBelowHealthPercentage(v89, v90) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (2 - 0)))) then
					if (((3230 - (50 + 126)) <= (11179 - 7164)) and v23(v30.LightofDawn)) then
						return "light_of_dawn aoe_healing";
					end
				end
				v155 = 1 + 1;
			end
			if (((3284 - (1233 + 180)) < (4351 - (522 + 447))) and (v155 == (1424 - (107 + 1314)))) then
				if (((601 + 692) <= (6599 - 4433)) and v126.TargetIsValid()) then
					local v231 = 0 + 0;
					while true do
						if (((1 - 0) == v231) or ((10204 - 7625) < (2033 - (716 + 1194)))) then
							if (v126.AreUnitsBelowHealthPercentage(v98, v99) or ((15 + 831) >= (254 + 2114))) then
								if ((LightsHammerLightsHammerUsage == "Player") or ((4515 - (74 + 429)) <= (6477 - 3119))) then
									if (((741 + 753) <= (6878 - 3873)) and v30.LightsHammer:IsCastable()) then
										if (v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(6 + 2)) or ((9590 - 6479) == (5276 - 3142))) then
											return "lights_hammer priority 6";
										end
									end
								elseif (((2788 - (279 + 154)) == (3133 - (454 + 324))) and (LightsHammerLightsHammerUsage == "Cursor")) then
									if (v30.LightsHammer:IsCastable() or ((463 + 125) <= (449 - (12 + 5)))) then
										if (((2587 + 2210) >= (9924 - 6029)) and v23(v32.LightsHammercursor)) then
											return "lights_hammer priority 6";
										end
									end
								elseif (((1322 + 2255) == (4670 - (277 + 816))) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
									if (((16212 - 12418) > (4876 - (1058 + 125))) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
										if (v23(v32.LightsHammercursor) or ((240 + 1035) == (5075 - (815 + 160)))) then
											return "lights_hammer priority 6";
										end
									end
								end
							end
							break;
						end
						if ((v231 == (0 - 0)) or ((3776 - 2185) >= (855 + 2725))) then
							if (((2873 - 1890) <= (3706 - (41 + 1857))) and v30.Consecration:IsCastable() and v30.GoldenPath:IsAvailable() and (v128() <= (1893 - (1222 + 671)))) then
								if (v23(v30.Consecration, not v16:IsInMeleeRange(12 - 7)) or ((3090 - 940) <= (2379 - (229 + 953)))) then
									return "consecration aoe_healing";
								end
							end
							if (((5543 - (1111 + 663)) >= (2752 - (874 + 705))) and v30.Judgment:IsReady() and v30.JudgmentofLight:IsAvailable() and v16:DebuffDown(v30.JudgmentofLightDebuff)) then
								if (((208 + 1277) == (1014 + 471)) and v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment))) then
									return "judgment aoe_healing";
								end
							end
							v231 = 1 - 0;
						end
					end
				end
				break;
			end
			if ((v155 == (0 + 0)) or ((3994 - (642 + 37)) <= (635 + 2147))) then
				if ((v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) or ((141 + 735) >= (7441 - 4477))) then
					if (v23(v32.BeaconofVirtueFocus) or ((2686 - (233 + 221)) > (5773 - 3276))) then
						return "beacon_of_virtue aoe_healing";
					end
				end
				if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (3 + 0)) and v14:BuffUp(v30.EmpyreanLegacyBuff) and (((v13:HealthPercentage() <= v84) and v67) or v126.AreUnitsBelowHealthPercentage(v89, v90))) or ((3651 - (718 + 823)) <= (209 + 123))) then
					if (((4491 - (266 + 539)) > (8980 - 5808)) and v23(v32.WordofGloryFocus)) then
						return "word_of_glory aoe_healing";
					end
				end
				v155 = 1226 - (636 + 589);
			end
		end
	end
	local function v140()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (1 - 0)) or ((3546 + 928) < (298 + 522))) then
				if (((5294 - (657 + 358)) >= (7630 - 4748)) and v30.DivineFavor:IsReady() and (v13:HealthPercentage() <= v83) and v82) then
					if (v23(v30.DivineFavor) or ((4622 - 2593) >= (4708 - (1151 + 36)))) then
						return "divine_favor st_healing";
					end
				end
				if ((v30.FlashofLight:IsCastable() and (v13:HealthPercentage() <= v80) and v79) or ((1968 + 69) >= (1221 + 3421))) then
					if (((5136 - 3416) < (6290 - (1552 + 280))) and v23(v32.FlashofLightFocus, nil, true)) then
						return "flash_of_light st_healing";
					end
				end
				v156 = 836 - (64 + 770);
			end
			if ((v156 == (0 + 0)) or ((989 - 553) > (537 + 2484))) then
				if (((1956 - (157 + 1086)) <= (1694 - 847)) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (13 - 10)) and (v13:HealthPercentage() <= v84) and v67) then
					if (((3304 - 1150) <= (5501 - 1470)) and v23(v32.WordofGloryFocus)) then
						return "word_of_glory st_healing";
					end
				end
				if (((5434 - (599 + 220)) == (9189 - 4574)) and v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) then
					if (v23(v32.HolyShockFocus) or ((5721 - (1813 + 118)) == (366 + 134))) then
						return "holy_shock st_healing";
					end
				end
				v156 = 1218 - (841 + 376);
			end
			if (((124 - 35) < (52 + 169)) and (v156 == (8 - 5))) then
				if (((2913 - (464 + 395)) >= (3646 - 2225)) and v30.FlashofLight:IsCastable() and v14:BuffUp(v30.InfusionofLightBuff) and (v13:HealthPercentage() <= v81) and v79) then
					if (((333 + 359) < (3895 - (467 + 370))) and v23(v32.FlashofLightFocus, nil, true)) then
						return "flash_of_light st_healing";
					end
				end
				if ((v30.HolyPrism:IsReady() and (v13:HealthPercentage() <= v96) and v94) or ((6724 - 3470) == (1215 + 440))) then
					if (v23(v32.HolyPrismPlayer) or ((4442 - 3146) == (767 + 4143))) then
						return "holy_prism on self priority 26";
					end
				end
				v156 = 8 - 4;
			end
			if (((3888 - (150 + 370)) == (4650 - (74 + 1208))) and (v156 == (4 - 2))) then
				if (((12534 - 9891) < (2715 + 1100)) and v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (((2303 - (14 + 376)) > (854 - 361)) and v23(v32.LightoftheMartyrFocus)) then
						return "holy_shock cooldown_healing";
					end
				end
				if (((3077 + 1678) > (3012 + 416)) and v30.BarrierofFaith:IsCastable() and (v13:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) then
					if (((1318 + 63) <= (6941 - 4572)) and v23(v32.BarrierofFaith, nil, true)) then
						return "barrier_of_faith st_healing";
					end
				end
				v156 = 3 + 0;
			end
			if ((v156 == (82 - (23 + 55))) or ((11477 - 6634) == (2726 + 1358))) then
				if (((4193 + 476) > (562 - 199)) and v30.HolyLight:IsCastable() and (v13:HealthPercentage() <= v83) and v82) then
					if (v23(v32.HolyLightFocus, nil, true) or ((591 + 1286) >= (4039 - (652 + 249)))) then
						return "holy_light st_healing";
					end
				end
				if (((12690 - 7948) >= (5494 - (708 + 1160))) and v126.AreUnitsBelowHealthPercentage(v98, v99)) then
					if ((v97 == "Player") or ((12323 - 7783) == (1669 - 753))) then
						if (v30.LightsHammer:IsCastable() or ((1183 - (10 + 17)) > (976 + 3369))) then
							if (((3969 - (1400 + 332)) < (8149 - 3900)) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(1916 - (242 + 1666)))) then
								return "lights_hammer priority 6";
							end
						end
					elseif ((v97 == "Cursor") or ((1149 + 1534) < (9 + 14))) then
						if (((595 + 102) <= (1766 - (850 + 90))) and v30.LightsHammer:IsCastable()) then
							if (((1934 - 829) <= (2566 - (360 + 1030))) and v23(v32.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					elseif (((2991 + 388) <= (10759 - 6947)) and (v97 == "Enemy Under Cursor")) then
						if ((v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) or ((1083 - 295) >= (3277 - (909 + 752)))) then
							if (((3077 - (109 + 1114)) <= (6185 - 2806)) and v23(v32.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v157 = 0 + 0;
		local v158;
		while true do
			if (((4791 - (6 + 236)) == (2867 + 1682)) and (v157 == (1 + 0))) then
				if (v158 or ((7126 - 4104) >= (5281 - 2257))) then
					return v158;
				end
				v158 = v140();
				v157 = 1135 - (1076 + 57);
			end
			if (((793 + 4027) > (2887 - (579 + 110))) and (v157 == (1 + 1))) then
				if (v158 or ((939 + 122) >= (2596 + 2295))) then
					return v158;
				end
				break;
			end
			if (((1771 - (174 + 233)) <= (12494 - 8021)) and (v157 == (0 - 0))) then
				if (not v13 or not v13:Exists() or not v13:IsInRange(18 + 22) or ((4769 - (663 + 511)) <= (3 + 0))) then
					return;
				end
				v158 = v139();
				v157 = 1 + 0;
			end
		end
	end
	local function v142()
		if ((v126.GetCastingEnemy(v30.BlackoutBarrelDebuff) and v30.BlessingofFreedom:IsReady()) or ((14403 - 9731) == (2333 + 1519))) then
			local v201 = 0 - 0;
			local v202;
			while true do
				if (((3773 - 2214) == (744 + 815)) and (v201 == (1 - 0))) then
					if ((v13 and UnitIsUnit(v13:ID(), v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)):ID())) or ((1249 + 503) <= (73 + 715))) then
						if (v23(v32.BlessingofFreedomFocus) or ((4629 - (478 + 244)) == (694 - (440 + 77)))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if (((1578 + 1892) > (2031 - 1476)) and (v201 == (1556 - (655 + 901)))) then
					v202 = v126.FocusSpecifiedUnit(v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)), 8 + 32);
					if (v202 or ((745 + 227) == (436 + 209))) then
						return v202;
					end
					v201 = 3 - 2;
				end
			end
		end
		local v159 = v126.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 1485 - (695 + 750), 68 - 48);
		if (((4910 - 1728) >= (8506 - 6391)) and v159) then
			return v159;
		end
		if (((4244 - (285 + 66)) < (10324 - 5895)) and v30.BlessingofFreedom:IsReady() and v126.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
			if (v23(v32.BlessingofFreedomFocus) or ((4177 - (682 + 628)) < (308 + 1597))) then
				return "blessing_of_freedom combat";
			end
		end
		if (v41 or ((2095 - (176 + 123)) >= (1695 + 2356))) then
			local v203 = 0 + 0;
			while true do
				if (((1888 - (239 + 30)) <= (1022 + 2734)) and ((0 + 0) == v203)) then
					v159 = v133();
					if (((1068 - 464) == (1884 - 1280)) and v159) then
						return v159;
					end
					break;
				end
			end
		end
		if (v45 or ((4799 - (306 + 9)) == (3140 - 2240))) then
			if ((v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) or ((776 + 3683) <= (683 + 430))) then
				if (((1749 + 1883) > (9716 - 6318)) and v23(v32.BlessingofFreedomPlayer)) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((5457 - (1140 + 235)) <= (3130 + 1787)) and (v115 ~= "None")) then
			if (((4432 + 400) >= (356 + 1030)) and v30.BeaconofLight:IsCastable() and (v126.NamedUnit(92 - (33 + 19), v115, 11 + 19) ~= nil) and v126.NamedUnit(119 - 79, v115, 14 + 16):BuffDown(v30.BeaconofLight)) then
				if (((268 - 131) == (129 + 8)) and v23(v32.BeaconofLightMacro)) then
					return "beacon_of_light combat";
				end
			end
		end
		if ((v116 ~= "None") or ((2259 - (586 + 103)) >= (395 + 3937))) then
			if ((v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(123 - 83, v116, 1518 - (1309 + 179)) ~= nil) and v126.NamedUnit(72 - 32, v116, 14 + 16):BuffDown(v30.BeaconofFaith)) or ((10914 - 6850) <= (1374 + 445))) then
				if (v23(v32.BeaconofFaithMacro) or ((10593 - 5607) < (3135 - 1561))) then
					return "beacon_of_faith combat";
				end
			end
		end
		local v159 = v135();
		if (((5035 - (295 + 314)) > (422 - 250)) and v159) then
			return v159;
		end
		v159 = v138();
		if (((2548 - (1300 + 662)) > (1428 - 973)) and v159) then
			return v159;
		end
		v159 = v132();
		if (((2581 - (1178 + 577)) == (429 + 397)) and v159) then
			return v159;
		end
		v159 = v141();
		if (v159 or ((11880 - 7861) > (5846 - (851 + 554)))) then
			return v159;
		end
		if (((1784 + 233) < (11817 - 7556)) and v126.TargetIsValid()) then
			local v204 = 0 - 0;
			while true do
				if (((5018 - (115 + 187)) > (62 + 18)) and (v204 == (1 + 0))) then
					v159 = v137();
					if (v159 or ((13819 - 10312) == (4433 - (160 + 1001)))) then
						return v159;
					end
					break;
				end
				if (((0 + 0) == v204) or ((605 + 271) >= (6294 - 3219))) then
					v159 = v136();
					if (((4710 - (237 + 121)) > (3451 - (525 + 372))) and v159) then
						return v159;
					end
					v204 = 1 - 0;
				end
			end
		end
	end
	local function v143()
		local v160 = 0 - 0;
		while true do
			if ((v160 == (142 - (96 + 46))) or ((5183 - (643 + 134)) < (1460 + 2583))) then
				if (v41 or ((4529 - 2640) >= (12560 - 9177))) then
					local v232 = 0 + 0;
					while true do
						if (((3712 - 1820) <= (5588 - 2854)) and ((719 - (316 + 403)) == v232)) then
							ShouldReturn = v133();
							if (((1279 + 644) < (6098 - 3880)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((786 + 1387) > (954 - 575)) and v45) then
					if ((v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) or ((1837 + 754) == (1099 + 2310))) then
						if (((15640 - 11126) > (15874 - 12550)) and v23(v32.BlessingofFreedomPlayer)) then
							return "blessing_of_freedom out of combat";
						end
					end
				end
				v160 = 1 - 0;
			end
			if ((v160 == (1 + 1)) or ((408 - 200) >= (236 + 4592))) then
				if (v126.TargetIsValid() or ((4657 - 3074) > (3584 - (12 + 5)))) then
					local v233 = 0 - 0;
					local v234;
					while true do
						if ((v233 == (0 - 0)) or ((2790 - 1477) == (1968 - 1174))) then
							v234 = v134();
							if (((645 + 2529) > (4875 - (1656 + 317))) and v234) then
								return v234;
							end
							break;
						end
					end
				end
				break;
			end
			if (((3672 + 448) <= (3414 + 846)) and (v160 == (2 - 1))) then
				if (v117 or ((4345 - 3462) > (5132 - (5 + 349)))) then
					if ((v115 ~= "None") or ((17194 - 13574) >= (6162 - (266 + 1005)))) then
						if (((2806 + 1452) > (3197 - 2260)) and v30.BeaconofLight:IsCastable() and (v126.NamedUnit(52 - 12, v115, 1726 - (561 + 1135)) ~= nil) and v126.NamedUnit(52 - 12, v115, 98 - 68):BuffDown(v30.BeaconofLight)) then
							if (v23(v32.BeaconofLightMacro) or ((5935 - (507 + 559)) < (2273 - 1367))) then
								return "beacon_of_light combat";
							end
						end
					end
					if ((v116 ~= "None") or ((3788 - 2563) > (4616 - (212 + 176)))) then
						if (((4233 - (250 + 655)) > (6102 - 3864)) and v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(69 - 29, v116, 46 - 16) ~= nil) and v126.NamedUnit(1996 - (1869 + 87), v116, 104 - 74):BuffDown(v30.BeaconofFaith)) then
							if (((5740 - (484 + 1417)) > (3011 - 1606)) and v23(v32.BeaconofFaithMacro)) then
								return "beacon_of_faith combat";
							end
						end
					end
					local v235 = v141();
					if (v235 or ((2166 - 873) <= (1280 - (48 + 725)))) then
						return v235;
					end
				end
				if ((v30.DevotionAura:IsCastable() and v14:BuffDown(v30.DevotionAura)) or ((4730 - 1834) < (2159 - 1354))) then
					if (((1346 + 970) == (6189 - 3873)) and v23(v30.DevotionAura)) then
						return "devotion_aura";
					end
				end
				v160 = 1 + 1;
			end
		end
	end
	local function v144()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (853 - (152 + 701));
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleCharredBrambles'];
		v45 = EpicSettings.Settings['HandleEntangling'];
		v46 = EpicSettings.Settings['InterruptWithStun'];
		v47 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v48 = EpicSettings.Settings['InterruptThreshold'] or (1311 - (430 + 881));
		v53 = EpicSettings.Settings['UseHealthstone'];
		v54 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v55 = EpicSettings.Settings['UseAvengingWrathOffensively'];
		v56 = EpicSettings.Settings['UseDivineTollOffensively'];
		v57 = EpicSettings.Settings['UseHolyShockOffensively'];
		v58 = EpicSettings.Settings['UseHolyShockCycle'];
		v59 = EpicSettings.Settings['UseHolyShockGroup'] or (895 - (557 + 338));
		v60 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
		v61 = EpicSettings.Settings['UseLayOnHands'];
		v62 = EpicSettings.Settings['LayOnHandsHP'] or (0 + 0);
		v63 = EpicSettings.Settings['UseDivineProtection'];
		v64 = EpicSettings.Settings['DivineProtectionHP'] or (0 - 0);
		v65 = EpicSettings.Settings['UseDivineShield'];
		v66 = EpicSettings.Settings['DivineShieldHP'] or (0 - 0);
		v67 = EpicSettings.Settings['UseWordOfGlory'];
		v68 = EpicSettings.Settings['WordofGlorydHP'] or (0 - 0);
		v69 = EpicSettings.Settings['UseAvengingWrath'];
		v70 = EpicSettings.Settings['AvengingWrathHP'] or (0 - 0);
		v71 = EpicSettings.Settings['AvengingWrathGroup'] or (801 - (499 + 302));
		v72 = EpicSettings.Settings['UseAuraMastery'];
		v73 = EpicSettings.Settings['AuraMasteryhHP'] or (866 - (39 + 827));
		v74 = EpicSettings.Settings['AuraMasteryGroup'] or (0 - 0);
		v75 = EpicSettings.Settings['UseBlessingOfSacrifice'];
		v76 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (0 - 0);
		v77 = EpicSettings.Settings['UseHolyShock'];
		v78 = EpicSettings.Settings['HolyShockHP'] or (0 - 0);
	end
	local function v145()
		local v187 = 0 - 0;
		while true do
			if ((v187 == (1 + 5)) or ((7522 - 4952) == (246 + 1287))) then
				v102 = EpicSettings.Settings['UseDaybreak'];
				v103 = EpicSettings.Settings['DaybreakMana'] or (0 - 0);
				v104 = EpicSettings.Settings['DaybreakHP'] or (104 - (103 + 1));
				v105 = EpicSettings.Settings['DaybreakHGroup'] or (554 - (475 + 79));
				v187 = 14 - 7;
			end
			if ((v187 == (6 - 4)) or ((115 + 768) == (1285 + 175))) then
				v86 = EpicSettings.Settings['BeaconOfVirtueHP'] or (1503 - (1395 + 108));
				v87 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (0 - 0);
				v88 = EpicSettings.Settings['UseLightOfDawn'];
				v89 = EpicSettings.Settings['LightOfDawnhHP'] or (1204 - (7 + 1197));
				v187 = 2 + 1;
			end
			if (((1 + 0) == v187) or ((4938 - (27 + 292)) <= (2927 - 1928))) then
				v83 = EpicSettings.Settings['HolyLightHP'] or (0 - 0);
				v67 = EpicSettings.Settings['UseWordOfGlory'];
				v84 = EpicSettings.Settings['WordOfGloryHP'] or (0 - 0);
				v85 = EpicSettings.Settings['UseBeaconOfVirtue'];
				v187 = 3 - 1;
			end
			if ((v187 == (9 - 4)) or ((3549 - (43 + 96)) > (16789 - 12673))) then
				v98 = EpicSettings.Settings['LightsHammerHP'] or (0 - 0);
				v99 = EpicSettings.Settings['LightsHammerGroup'] or (0 + 0);
				v100 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
				v101 = EpicSettings.Settings['BlessingOfProtection'] or (0 + 0);
				v187 = 11 - 5;
			end
			if (((0 + 0) == v187) or ((1692 - 789) >= (964 + 2095))) then
				v79 = EpicSettings.Settings['UseFlashOfLight'];
				v80 = EpicSettings.Settings['FlashOfLightHP'] or (0 + 0);
				v81 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (1751 - (1414 + 337));
				v82 = EpicSettings.Settings['UseHolyLight'];
				v187 = 1941 - (1642 + 298);
			end
			if ((v187 == (23 - 14)) or ((11438 - 7462) < (8478 - 5621))) then
				v114 = EpicSettings.Settings['BarrierOfFaithHP'] or (0 + 0);
				v115 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
				v116 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
				break;
			end
			if (((3836 + 1094) > (3279 - (357 + 615))) and (v187 == (5 + 2))) then
				v106 = EpicSettings.Settings['DaybreakGroup'] or (0 - 0);
				v107 = EpicSettings.Settings['UseTyrsDeliverance'];
				v108 = EpicSettings.Settings['TyrsDeliveranceHP'] or (0 + 0);
				v109 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (0 - 0);
				v187 = 7 + 1;
			end
			if ((v187 == (1 + 2)) or ((2544 + 1502) < (2592 - (384 + 917)))) then
				v90 = EpicSettings.Settings['LightOfDawnGroup'] or (697 - (128 + 569));
				v91 = EpicSettings.Settings['UseDivineToll'];
				v92 = EpicSettings.Settings['DivineTollHP'] or (1543 - (1407 + 136));
				v93 = EpicSettings.Settings['DivineTollGroup'] or (1887 - (687 + 1200));
				v187 = 1714 - (556 + 1154);
			end
			if (((28 - 20) == v187) or ((4336 - (9 + 86)) == (3966 - (275 + 146)))) then
				v110 = EpicSettings.Settings['UseHandOfDivinity'];
				v111 = EpicSettings.Settings['HandOfDivinityHP'] or (0 + 0);
				v112 = EpicSettings.Settings['HandOfDivinityGroup'] or (64 - (29 + 35));
				v113 = EpicSettings.Settings['UseBarrierOfFaith'];
				v187 = 39 - 30;
			end
			if ((v187 == (11 - 7)) or ((17869 - 13821) > (2757 + 1475))) then
				v94 = EpicSettings.Settings['UseHolyPrism'];
				v95 = EpicSettings.Settings['UseHolyPrismOffensively'];
				v96 = EpicSettings.Settings['HolyPrismHP'] or (1012 - (53 + 959));
				v97 = EpicSettings.Settings['LightsHammerUsage'] or "";
				v187 = 413 - (312 + 96);
			end
		end
	end
	local function v146()
		v144();
		v145();
		v117 = EpicSettings.Toggles['ooc'];
		v118 = EpicSettings.Toggles['cds'];
		v119 = EpicSettings.Toggles['dispel'];
		v120 = EpicSettings.Toggles['spread'];
		v121 = EpicSettings.Toggles['cycle'];
		v122 = EpicSettings.Toggles['lod'];
		if (v14:IsMounted() or ((3037 - 1287) >= (3758 - (147 + 138)))) then
			return;
		end
		if (((4065 - (813 + 86)) == (2862 + 304)) and v14:IsDeadOrGhost()) then
			return;
		end
		if (((3265 - 1502) < (4216 - (18 + 474))) and v43) then
			local v205 = 0 + 0;
			while true do
				if (((185 - 128) <= (3809 - (860 + 226))) and (v205 == (303 - (121 + 182)))) then
					ShouldReturn = v126.HandleCharredTreant(v30.HolyShock, v32.HolyShockMouseover, 5 + 35);
					if (ShouldReturn or ((3310 - (988 + 252)) == (51 + 392))) then
						return ShouldReturn;
					end
					v205 = 1 + 0;
				end
				if ((v205 == (1972 - (49 + 1921))) or ((3595 - (223 + 667)) == (1445 - (51 + 1)))) then
					ShouldReturn = v126.HandleCharredTreant(v30.FlashofLight, v32.FlashofLightMouseover, 68 - 28);
					if (ShouldReturn or ((9852 - 5251) < (1186 - (146 + 979)))) then
						return ShouldReturn;
					end
					v205 = 1 + 2;
				end
				if ((v205 == (608 - (311 + 294))) or ((3876 - 2486) >= (2010 + 2734))) then
					ShouldReturn = v126.HandleCharredTreant(v30.HolyLight, v32.HolyLightMouseover, 1483 - (496 + 947));
					if (ShouldReturn or ((3361 - (1233 + 125)) > (1556 + 2278))) then
						return ShouldReturn;
					end
					break;
				end
				if ((v205 == (1 + 0)) or ((30 + 126) > (5558 - (963 + 682)))) then
					ShouldReturn = v126.HandleCharredTreant(v30.WordofGlory, v32.WordofGloryMouseover, 34 + 6);
					if (((1699 - (504 + 1000)) == (132 + 63)) and ShouldReturn) then
						return ShouldReturn;
					end
					v205 = 2 + 0;
				end
			end
		end
		if (((294 + 2811) >= (2648 - 852)) and v44) then
			ShouldReturn = v126.HandleCharredBrambles(v30.HolyShock, v32.HolyShockMouseover, 35 + 5);
			if (((2547 + 1832) >= (2313 - (156 + 26))) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v126.HandleCharredBrambles(v30.WordofGlory, v32.WordofGloryMouseover, 24 + 16);
			if (((6014 - 2170) >= (2207 - (149 + 15))) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v126.HandleCharredBrambles(v30.FlashofLight, v32.FlashofLightMouseover, 1000 - (890 + 70));
			if (ShouldReturn or ((3349 - (39 + 78)) <= (3213 - (14 + 468)))) then
				return ShouldReturn;
			end
			ShouldReturn = v126.HandleCharredBrambles(v30.HolyLight, v32.HolyLightMouseover, 87 - 47);
			if (((13709 - 8804) == (2531 + 2374)) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((2484 + 1652) >= (938 + 3473))) then
			local v206 = v126.DeadFriendlyUnitsCount();
			if (v14:AffectingCombat() or ((1336 + 1622) == (1053 + 2964))) then
				if (((2350 - 1122) >= (804 + 9)) and v30.Intercession:IsCastable()) then
					if (v23(v30.Intercession, nil, true) or ((12140 - 8685) > (103 + 3947))) then
						return "intercession";
					end
				end
			elseif (((294 - (12 + 39)) == (227 + 16)) and (v206 > (2 - 1))) then
				if (v23(v30.Absolution, nil, true) or ((965 - 694) > (467 + 1105))) then
					return "absolution";
				end
			elseif (((1442 + 1297) < (8350 - 5057)) and v23(v30.Redemption, not v16:IsInRange(27 + 13), true)) then
				return "redemption";
			end
		end
		if (v14:AffectingCombat() or (v41 and v119) or ((19050 - 15108) < (2844 - (1596 + 114)))) then
			local v207 = 0 - 0;
			local v208;
			local v209;
			while true do
				if ((v207 == (714 - (164 + 549))) or ((4131 - (1059 + 379)) == (6174 - 1201))) then
					if (((1113 + 1033) == (362 + 1784)) and v209) then
						return v209;
					end
					break;
				end
				if ((v207 == (392 - (145 + 247))) or ((1842 + 402) == (1490 + 1734))) then
					v208 = v41 and v30.Cleanse:IsReady();
					v209 = v126.FocusUnit(v208, v32, 59 - 39);
					v207 = 1 + 0;
				end
			end
		end
		v124 = v14:GetEnemiesInMeleeRange(7 + 1);
		if (AOE or ((7962 - 3058) <= (2636 - (254 + 466)))) then
			v125 = #v124;
		else
			v125 = 561 - (544 + 16);
		end
		if (((286 - 196) <= (1693 - (294 + 334))) and not v14:IsChanneling()) then
			if (((5055 - (236 + 17)) == (2071 + 2731)) and (v117 or v14:AffectingCombat())) then
				if (v14:AffectingCombat() or ((1775 + 505) <= (1924 - 1413))) then
					local v236 = 0 - 0;
					local v237;
					while true do
						if ((v236 == (0 + 0)) or ((1381 + 295) <= (1257 - (413 + 381)))) then
							v237 = v142();
							if (((163 + 3706) == (8228 - 4359)) and v237) then
								return v237;
							end
							break;
						end
					end
				else
					local v238 = 0 - 0;
					local v239;
					while true do
						if (((3128 - (582 + 1388)) <= (4451 - 1838)) and (v238 == (0 + 0))) then
							v239 = v143();
							if (v239 or ((2728 - (326 + 38)) <= (5913 - 3914))) then
								return v239;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v147()
		local v194 = 0 - 0;
		while true do
			if ((v194 == (621 - (47 + 573))) or ((1736 + 3186) < (823 - 629))) then
				v126.DispellableDebuffs = v11.MergeTable(v126.DispellableDebuffs, v126.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.01 By BoomK");
				break;
			end
			if ((v194 == (0 - 0)) or ((3755 - (1269 + 395)) < (523 - (76 + 416)))) then
				v20.Print("Holy Paladin by Epic.");
				v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
				v194 = 444 - (319 + 124);
			end
		end
	end
	v20.SetAPL(148 - 83, v146, v147);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

