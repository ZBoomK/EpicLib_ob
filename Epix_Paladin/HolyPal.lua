local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((477 + 393) >= (5656 - 2580))) then
			v6 = v0[v4];
			if (((1077 + 552) > (669 + 533)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((847 + 161) < (3631 + 80)) and (v5 == (434 - (153 + 280)))) then
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
		for v175 = 2 - 1, 4 + 0 do
			local v176 = 0 + 0;
			local v177;
			local v178;
			local v179;
			local v180;
			while true do
				if ((v176 == (0 + 0)) or ((952 + 97) <= (657 + 249))) then
					v177, v178, v179, v180 = v29(v175);
					if (((6871 - 2358) > (1685 + 1041)) and (v178 == v31.Consecration:Name())) then
						return (v27(((v179 + v180) - v30()) + (667.5 - (89 + 578)))) or (0 + 0);
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
		local v151 = 1049 - (572 + 477);
		local v152;
		while true do
			if (((1 + 0) == v151) or ((889 + 592) >= (318 + 2340))) then
				for v226, v227 in pairs(v152) do
					if (v227:IsCastable() or ((3306 - (84 + 2)) == (2247 - 883))) then
						if (v24(v33.BlessingofSummerPlayer) or ((760 + 294) > (4234 - (497 + 345)))) then
							return "blessing_of_the_seasons";
						end
					end
				end
				break;
			end
			if ((v151 == (0 + 0)) or ((115 + 561) >= (2975 - (605 + 728)))) then
				if (((2951 + 1185) > (5328 - 2931)) and v31.BlessingofSummer:IsCastable() and v15:IsInParty() and not v15:IsInRaid()) then
					if ((v14 and v14:Exists() and (v127.UnitGroupRole(v14) == "DAMAGER")) or ((199 + 4135) == (15694 - 11449))) then
						if (v24(v33.BlessingofSummerFocus) or ((3855 + 421) <= (8397 - 5366))) then
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
		local v153 = 0 + 0;
		while true do
			if ((v153 == (3 - 2)) or ((2304 + 2478) <= (1995 - (588 + 208)))) then
				ShouldReturn = v127.HandleBottomTrinket(v124, v119, 107 - 67, nil);
				if (ShouldReturn or ((6664 - (884 + 916)) < (3981 - 2079))) then
					return ShouldReturn;
				end
				break;
			end
			if (((2806 + 2033) >= (4353 - (232 + 421))) and (v153 == (1889 - (1569 + 320)))) then
				ShouldReturn = v127.HandleTopTrinket(v124, v119, 10 + 30, nil);
				if (ShouldReturn or ((205 + 870) > (6463 - 4545))) then
					return ShouldReturn;
				end
				v153 = 606 - (316 + 289);
			end
		end
	end
	local function v133()
		if (((1036 - 640) <= (176 + 3628)) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v182 = 1453 - (666 + 787);
			local v183;
			while true do
				if ((v182 == (426 - (360 + 65))) or ((3897 + 272) == (2441 - (79 + 175)))) then
					v183 = v127.InterruptWithStun(v31.HammerofJustice, 12 - 4);
					if (((1098 + 308) == (4309 - 2903)) and v183) then
						return v183;
					end
					break;
				end
				if (((2948 - 1417) < (5170 - (503 + 396))) and (v182 == (181 - (92 + 89)))) then
					v183 = v127.Interrupt(v31.Rebuke, 9 - 4, true);
					if (((326 + 309) == (376 + 259)) and v183) then
						return v183;
					end
					v182 = 3 - 2;
				end
			end
		end
	end
	local function v134()
		local v154 = 0 + 0;
		while true do
			if (((7690 - 4317) <= (3103 + 453)) and (v154 == (0 + 0))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(121 - 81) or not v127.DispellableFriendlyUnit() or ((411 + 2880) < (5002 - 1722))) then
					return;
				end
				if (((5630 - (485 + 759)) >= (2019 - 1146)) and v31.Cleanse:IsReady()) then
					if (((2110 - (442 + 747)) <= (2237 - (832 + 303))) and v24(v33.CleanseFocus)) then
						return "cleanse dispel";
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v155 = 946 - (88 + 858);
		while true do
			if (((1435 + 3271) >= (797 + 166)) and (v155 == (0 + 0))) then
				if ((v31.Consecration:IsCastable() and v17:IsInMeleeRange(794 - (766 + 23))) or ((4739 - 3779) <= (1197 - 321))) then
					if (v24(v31.Consecration) or ((5443 - 3377) == (3163 - 2231))) then
						return "consecrate precombat 4";
					end
				end
				if (((5898 - (1036 + 37)) < (3434 + 1409)) and v31.Judgment:IsReady()) then
					if (v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment)) or ((7549 - 3672) >= (3569 + 968))) then
						return "judgment precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v136()
		if (((v15:HealthPercentage() <= v63) and v62 and v31.LayonHands:IsCastable()) or ((5795 - (641 + 839)) < (2639 - (910 + 3)))) then
			if (v24(v33.LayonHandsPlayer) or ((9378 - 5699) < (2309 - (1466 + 218)))) then
				return "lay_on_hands defensive";
			end
		end
		if ((v31.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67) and v66) or ((2126 + 2499) < (1780 - (556 + 592)))) then
			if (v24(v31.DivineProtection) or ((30 + 53) > (2588 - (329 + 479)))) then
				return "divine protection";
			end
		end
		if (((1400 - (174 + 680)) <= (3700 - 2623)) and v31.WordofGlory:IsReady() and (v15:HolyPower() >= (5 - 2)) and (v15:HealthPercentage() <= v85) and v68 and not v15:HealingAbsorbed()) then
			if (v24(v33.WordofGloryPlayer) or ((712 + 284) > (5040 - (396 + 343)))) then
				return "WOG self";
			end
		end
		if (((361 + 3709) > (2164 - (29 + 1448))) and v32.Healthstone:IsReady() and v54 and (v15:HealthPercentage() <= v55)) then
			if (v24(v33.Healthstone, nil, nil, true) or ((2045 - (135 + 1254)) >= (12544 - 9214))) then
				return "healthstone defensive 3";
			end
		end
		if ((v35 and (v15:HealthPercentage() <= v37)) or ((11635 - 9143) <= (224 + 111))) then
			if (((5849 - (389 + 1138)) >= (3136 - (102 + 472))) and (v36 == "Refreshing Healing Potion")) then
				if (v32.RefreshingHealingPotion:IsReady() or ((3433 + 204) >= (2091 + 1679))) then
					if (v24(v33.RefreshingHealingPotion, nil, nil, true) or ((2219 + 160) > (6123 - (320 + 1225)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v137()
		if ((v56 and v119 and v31.AvengingWrath:IsReady() and not v15:BuffUp(v31.AvengingWrathBuff)) or ((859 - 376) > (455 + 288))) then
			if (((3918 - (157 + 1307)) > (2437 - (821 + 1038))) and v24(v31.AvengingWrath)) then
				return "avenging_wrath cooldowns 4";
			end
		end
		local v156 = v131();
		if (((2320 - 1390) < (488 + 3970)) and v156) then
			return v156;
		end
		if (((1175 - 513) <= (362 + 610)) and v57 and v119 and v31.DivineToll:IsCastable() and v15:BuffUp(v31.AvengingWrathBuff)) then
			if (((10831 - 6461) == (5396 - (834 + 192))) and v24(v31.DivineToll)) then
				return "divine_toll cooldowns 8";
			end
		end
		if (v31.BloodFury:IsCastable() or ((303 + 4459) <= (221 + 640))) then
			if (v24(v31.BloodFury) or ((31 + 1381) == (6605 - 2341))) then
				return "blood_fury cooldowns 12";
			end
		end
		if (v31.Berserking:IsCastable() or ((3472 - (300 + 4)) < (575 + 1578))) then
			if (v24(v31.Berserking) or ((13025 - 8049) < (1694 - (112 + 250)))) then
				return "berserking cooldowns 14";
			end
		end
		if (((1845 + 2783) == (11593 - 6965)) and v31.HolyAvenger:IsCastable()) then
			if (v24(v31.HolyAvenger) or ((31 + 23) == (205 + 190))) then
				return "holy_avenger cooldowns 16";
			end
		end
		v156 = v127.HandleTopTrinket(v124, v119, 30 + 10, nil);
		if (((41 + 41) == (61 + 21)) and v156) then
			return v156;
		end
		v156 = v127.HandleBottomTrinket(v124, v119, 1454 - (1001 + 413), nil);
		if (v156 or ((1295 - 714) < (1164 - (244 + 638)))) then
			return v156;
		end
		if (v31.Seraphim:IsReady() or ((5302 - (627 + 66)) < (7434 - 4939))) then
			if (((1754 - (512 + 90)) == (3058 - (1665 + 241))) and v24(v31.Seraphim)) then
				return "seraphim cooldowns 18";
			end
		end
	end
	local function v138()
		if (((2613 - (373 + 344)) <= (1544 + 1878)) and v119) then
			local v184 = 0 + 0;
			local v185;
			while true do
				if ((v184 == (0 - 0)) or ((1675 - 685) > (2719 - (35 + 1064)))) then
					v185 = v137();
					if (v185 or ((639 + 238) > (10045 - 5350))) then
						return v185;
					end
					break;
				end
			end
		end
		if (((11 + 2680) >= (3087 - (298 + 938))) and v31.ShieldoftheRighteousHoly:IsReady() and (v15:BuffUp(v31.AvengingWrathBuff) or v15:BuffUp(v31.HolyAvenger) or not v31.Awakening:IsAvailable())) then
			if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(1264 - (233 + 1026))) or ((4651 - (636 + 1030)) >= (2483 + 2373))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if (((4177 + 99) >= (355 + 840)) and v31.ShieldoftheRighteousHoly:IsReady() and (v15:HolyPower() >= (1 + 2)) and (v127.LowestFriendlyUnit:HealthPercentage() > v69) and (v127.FriendlyUnitsBelowHealthPercentageCount(v90) < v91)) then
			if (((3453 - (55 + 166)) <= (909 + 3781)) and v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(1 + 4))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if ((v31.HammerofWrath:IsReady() and (v15:HolyPower() < (18 - 13)) and (v126 == (299 - (36 + 261)))) or ((1566 - 670) >= (4514 - (34 + 1334)))) then
			if (((1177 + 1884) >= (2299 + 659)) and v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath))) then
				return "hammer_of_wrath priority 4";
			end
		end
		if (((4470 - (1035 + 248)) >= (665 - (20 + 1))) and (LightsHammerLightsHammerUsage == "Player")) then
			if (((336 + 308) <= (1023 - (134 + 185))) and v31.LightsHammer:IsCastable() and (v126 >= (1135 - (549 + 584)))) then
				if (((1643 - (314 + 371)) > (3250 - 2303)) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(976 - (478 + 490)))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((2380 + 2112) >= (3826 - (786 + 386))) and (LightsHammerLightsHammerUsage == "Cursor")) then
			if (((11148 - 7706) >= (2882 - (1055 + 324))) and v31.LightsHammer:IsCastable()) then
				if (v24(v33.LightsHammercursor) or ((4510 - (1093 + 247)) <= (1301 + 163))) then
					return "lights_hammer priority 6";
				end
			end
		elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((505 + 4292) == (17421 - 13033))) then
			if (((1869 - 1318) <= (1937 - 1256)) and v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
				if (((8234 - 4957) > (145 + 262)) and v24(v33.LightsHammercursor)) then
					return "lights_hammer priority 6";
				end
			end
		end
		if (((18087 - 13392) >= (4877 - 3462)) and v31.Consecration:IsCastable() and (v126 >= (2 + 0)) and (v129() <= (0 - 0))) then
			if (v24(v31.Consecration, not v17:IsInMeleeRange(693 - (364 + 324))) or ((8804 - 5592) <= (2265 - 1321))) then
				return "consecration priority 8";
			end
		end
		if ((v31.LightofDawn:IsReady() and v123 and ((v31.Awakening:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or ((v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (1 + 1)) and ((v15:HolyPower() >= (20 - 15)) or (v15:BuffUp(v31.HolyAvenger) and (v15:HolyPower() >= (4 - 1))))))) or ((9402 - 6306) <= (3066 - (1249 + 19)))) then
			if (((3193 + 344) == (13767 - 10230)) and v24(v31.LightofDawn)) then
				return "light_of_dawn priority 10";
			end
		end
		if (((4923 - (686 + 400)) >= (1232 + 338)) and v31.ShieldoftheRighteousHoly:IsReady() and (v126 > (232 - (73 + 156)))) then
			if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(1 + 4)) or ((3761 - (721 + 90)) == (43 + 3769))) then
				return "shield_of_the_righteous priority 12";
			end
		end
		if (((15334 - 10611) >= (2788 - (224 + 246))) and v31.HammerofWrath:IsReady()) then
			if (v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath)) or ((3283 - 1256) > (5250 - 2398))) then
				return "hammer_of_wrath priority 14";
			end
		end
		if (v31.Judgment:IsReady() or ((207 + 929) > (103 + 4214))) then
			if (((3488 + 1260) == (9439 - 4691)) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
				return "judgment priority 16";
			end
		end
		if (((12432 - 8696) <= (5253 - (203 + 310))) and (LightsHammer == "Player")) then
			if (v31.LightsHammer:IsCastable() or ((5383 - (1238 + 755)) <= (214 + 2846))) then
				if (v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(1542 - (709 + 825))) or ((1840 - 841) > (3922 - 1229))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((1327 - (196 + 668)) < (2372 - 1771)) and (LightsHammer == "Cursor")) then
			if (v31.LightsHammer:IsCastable() or ((4521 - 2338) < (1520 - (171 + 662)))) then
				if (((4642 - (4 + 89)) == (15943 - 11394)) and v24(v33.LightsHammercursor)) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((1702 + 2970) == (20520 - 15848)) and (LightsHammer == "Enemy Under Cursor")) then
			if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((1439 + 2229) < (1881 - (35 + 1451)))) then
				if (v24(v33.LightsHammercursor) or ((5619 - (28 + 1425)) == (2448 - (941 + 1052)))) then
					return "lights_hammer priority 6";
				end
			end
		end
		if ((v31.Consecration:IsCastable() and (v129() <= (0 + 0))) or ((5963 - (822 + 692)) == (3801 - 1138))) then
			if (v24(v31.Consecration, not v17:IsInMeleeRange(3 + 2)) or ((4574 - (45 + 252)) < (2958 + 31))) then
				return "consecration priority 20";
			end
		end
		if ((v58 and v31.HolyShock:IsReady() and v17:DebuffDown(v31.GlimmerofLightBuff) and (not v31.GlimmerofLight:IsAvailable() or v130(v17))) or ((300 + 570) >= (10097 - 5948))) then
			if (((2645 - (114 + 319)) < (4569 - 1386)) and v24(v31.HolyShock, not v17:IsSpellInRange(v31.HolyShock))) then
				return "holy_shock damage";
			end
		end
		if (((5953 - 1307) > (1908 + 1084)) and v58 and v59 and v31.HolyShock:IsReady() and (v127.EnemiesWithDebuffCount(v31.GlimmerofLightBuff, 59 - 19) < v60) and v122) then
			if (((3004 - 1570) < (5069 - (556 + 1407))) and v127.CastCycle(v31.HolyShock, v125, v130, not v17:IsSpellInRange(v31.HolyShock), nil, nil, v33.HolyShockMouseover)) then
				return "holy_shock_cycle damage";
			end
		end
		if (((1992 - (741 + 465)) < (3488 - (170 + 295))) and v31.CrusaderStrike:IsReady() and (v31.CrusaderStrike:Charges() == (2 + 0))) then
			if (v24(v31.CrusaderStrike, not v17:IsInMeleeRange(5 + 0)) or ((6012 - 3570) < (62 + 12))) then
				return "crusader_strike priority 24";
			end
		end
		if (((2909 + 1626) == (2569 + 1966)) and v31.HolyPrism:IsReady() and (v126 >= (1232 - (957 + 273))) and v96) then
			if (v24(v33.HolyPrismPlayer) or ((805 + 2204) <= (843 + 1262))) then
				return "holy_prism on self priority 26";
			end
		end
		if (((6973 - 5143) < (9668 - 5999)) and v31.HolyPrism:IsReady() and v96) then
			if (v24(v31.HolyPrism, not v17:IsSpellInRange(v31.HolyPrism)) or ((4367 - 2937) >= (17885 - 14273))) then
				return "holy_prism priority 28";
			end
		end
		if (((4463 - (389 + 1391)) >= (1544 + 916)) and v31.ArcaneTorrent:IsCastable()) then
			if (v24(v31.ArcaneTorrent) or ((188 + 1616) >= (7455 - 4180))) then
				return "arcane_torrent priority 30";
			end
		end
		if ((v31.LightofDawn:IsReady() and v123 and (v15:HolyPower() >= (954 - (783 + 168))) and ((v31.Awakening:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (6 - 4)))) or ((1394 + 23) > (3940 - (309 + 2)))) then
			if (((14725 - 9930) > (1614 - (1090 + 122))) and v24(v31.LightofDawn, not v17:IsSpellInRange(v31.LightofDawn))) then
				return "light_of_dawn priority 32";
			end
		end
		if (((1561 + 3252) > (11972 - 8407)) and v31.CrusaderStrike:IsReady()) then
			if (((2678 + 1234) == (5030 - (628 + 490))) and v24(v31.CrusaderStrike, not v17:IsInMeleeRange(1 + 4))) then
				return "crusader_strike priority 34";
			end
		end
		if (((6984 - 4163) <= (22045 - 17221)) and v31.Consecration:IsReady()) then
			if (((2512 - (431 + 343)) <= (4433 - 2238)) and v24(v31.Consecration, not v17:IsInMeleeRange(14 - 9))) then
				return "consecration priority 36";
			end
		end
	end
	local function v139()
		if (((33 + 8) <= (387 + 2631)) and (not v14 or not v14:Exists() or not v14:IsInRange(1735 - (556 + 1139)))) then
			return;
		end
		if (((2160 - (6 + 9)) <= (752 + 3352)) and v31.LayonHands:IsCastable() and (v14:HealthPercentage() <= v63) and v62) then
			if (((1378 + 1311) < (5014 - (28 + 141))) and v24(v33.LayonHandsFocus)) then
				return "lay_on_hands cooldown_healing";
			end
		end
		if ((v101 == "Not Tank") or ((900 + 1422) > (3236 - 614))) then
			if ((v31.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v102) and (not v127.UnitGroupRole(v14) == "TANK")) or ((3212 + 1322) == (3399 - (486 + 831)))) then
				if (v24(v33.BlessingofProtectionFocus) or ((4088 - 2517) > (6572 - 4705))) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		elseif ((v101 == "Player") or ((502 + 2152) >= (9473 - 6477))) then
			if (((5241 - (668 + 595)) > (1894 + 210)) and v31.BlessingofProtection:IsCastable() and (v15:HealthPercentage() <= v102)) then
				if (((604 + 2391) > (4202 - 2661)) and v24(v33.BlessingofProtectionplayer)) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		end
		if (((3539 - (23 + 267)) > (2897 - (1129 + 815))) and v31.AuraMastery:IsCastable() and v127.AreUnitsBelowHealthPercentage(v74, v75) and v73) then
			if (v24(v31.AuraMastery) or ((3660 - (371 + 16)) > (6323 - (1326 + 424)))) then
				return "aura_mastery cooldown_healing";
			end
		end
		if ((v31.AvengingWrath:IsCastable() and not v15:BuffUp(v31.AvengingWrathBuff) and v127.AreUnitsBelowHealthPercentage(v71, v72) and v70) or ((5967 - 2816) < (4692 - 3408))) then
			if (v24(v31.AvengingWrath) or ((1968 - (88 + 30)) == (2300 - (720 + 51)))) then
				return "avenging_wrath cooldown_healing";
			end
		end
		if (((1826 - 1005) < (3899 - (421 + 1355))) and v31.TyrsDeliverance:IsCastable() and v108 and v127.AreUnitsBelowHealthPercentage(v109, v110)) then
			if (((1487 - 585) < (1143 + 1182)) and v24(v31.TyrsDeliverance)) then
				return "tyrs_deliverance cooldown_healing";
			end
		end
		if (((1941 - (286 + 797)) <= (10827 - 7865)) and v31.BeaconofVirtue:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) then
			if (v24(v33.BeaconofVirtueFocus) or ((6535 - 2589) < (1727 - (397 + 42)))) then
				return "beacon_of_virtue cooldown_healing";
			end
		end
		if ((v31.Daybreak:IsReady() and (v127.FriendlyUnitsWithBuffCount(v31.GlimmerofLightBuff, false, false) > v107) and (v127.AreUnitsBelowHealthPercentage(v105, v106) or (v15:ManaPercentage() <= v104)) and v103) or ((1013 + 2229) == (1367 - (24 + 776)))) then
			if (v24(v31.Daybreak) or ((1304 - 457) >= (2048 - (222 + 563)))) then
				return "daybreak cooldown_healing";
			end
		end
		if ((v31.HandofDivinity:IsReady() and v127.AreUnitsBelowHealthPercentage(v112, v113) and v111) or ((4963 - 2710) == (1333 + 518))) then
			if (v24(v31.HandofDivinity) or ((2277 - (23 + 167)) > (4170 - (690 + 1108)))) then
				return "divine_toll cooldown_healing";
			end
		end
		if ((v31.DivineToll:IsReady() and v127.AreUnitsBelowHealthPercentage(v93, v94) and v92) or ((1604 + 2841) < (3423 + 726))) then
			if (v24(v33.DivineTollFocus) or ((2666 - (40 + 808)) == (14 + 71))) then
				return "divine_toll cooldown_healing";
			end
		end
		if (((2409 - 1779) < (2033 + 94)) and v31.HolyShock:IsReady() and (v14:HealthPercentage() <= v79) and v78) then
			if (v24(v33.HolyShockFocus) or ((1026 + 912) == (1379 + 1135))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((4826 - (47 + 524)) >= (36 + 19)) and v31.BlessingofSacrifice:IsReady() and (v14:GUID() ~= v15:GUID()) and (v14:HealthPercentage() <= v77) and v76) then
			if (((8197 - 5198) > (1728 - 572)) and v24(v33.BlessingofSacrificeFocus)) then
				return "blessing_of_sacrifice cooldown_healing";
			end
		end
	end
	local function v140()
		if (((5359 - 3009) > (2881 - (1165 + 561))) and v31.BeaconofVirtue:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) then
			if (((120 + 3909) <= (15030 - 10177)) and v24(v33.BeaconofVirtueFocus)) then
				return "beacon_of_virtue aoe_healing";
			end
		end
		if ((v31.WordofGlory:IsReady() and (v15:HolyPower() >= (2 + 1)) and v15:BuffUp(v31.EmpyreanLegacyBuff) and (((v14:HealthPercentage() <= v85) and v68) or v127.AreUnitsBelowHealthPercentage(v90, v91))) or ((995 - (341 + 138)) > (927 + 2507))) then
			if (((8349 - 4303) >= (3359 - (89 + 237))) and v24(v33.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v31.WordofGlory:IsReady() and (v15:HolyPower() >= (9 - 6)) and v15:BuffUp(v31.UnendingLightBuff) and (v14:HealthPercentage() <= v85) and v68) or ((5724 - 3005) <= (2328 - (581 + 300)))) then
			if (v24(v33.WordofGloryFocus) or ((5354 - (855 + 365)) < (9324 - 5398))) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v31.LightofDawn:IsReady() and v123 and (v15:HolyPower() >= (1 + 2)) and (v127.AreUnitsBelowHealthPercentage(v90, v91) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > (1237 - (1030 + 205))))) or ((154 + 10) >= (2591 + 194))) then
			if (v24(v31.LightofDawn) or ((811 - (156 + 130)) == (4791 - 2682))) then
				return "light_of_dawn aoe_healing";
			end
		end
		if (((55 - 22) == (67 - 34)) and v31.WordofGlory:IsReady() and (v15:HolyPower() >= (1 + 2)) and (v14:HealthPercentage() <= v85) and UseWodOfGlory and (v127.FriendlyUnitsBelowHealthPercentageCount(v85) < (2 + 1))) then
			if (((3123 - (10 + 59)) <= (1136 + 2879)) and v24(v33.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if (((9214 - 7343) < (4545 - (671 + 492))) and v31.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
			if (((1030 + 263) <= (3381 - (369 + 846))) and v24(v33.LightoftheMartyrFocus)) then
				return "holy_shock cooldown_healing";
			end
		end
		if (v127.TargetIsValid() or ((683 + 1896) < (105 + 18))) then
			if ((v31.Consecration:IsCastable() and v31.GoldenPath:IsAvailable() and (v129() <= (1945 - (1036 + 909)))) or ((673 + 173) >= (3975 - 1607))) then
				if (v24(v31.Consecration, not v17:IsInMeleeRange(208 - (11 + 192))) or ((2028 + 1984) <= (3533 - (135 + 40)))) then
					return "consecration aoe_healing";
				end
			end
			if (((3619 - 2125) <= (1812 + 1193)) and v31.Judgment:IsReady() and v31.JudgmentofLight:IsAvailable() and v17:DebuffDown(v31.JudgmentofLightDebuff)) then
				if (v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment)) or ((6853 - 3742) == (3198 - 1064))) then
					return "judgment aoe_healing";
				end
			end
			if (((2531 - (50 + 126)) == (6557 - 4202)) and v127.AreUnitsBelowHealthPercentage(v99, v100)) then
				if ((LightsHammerLightsHammerUsage == "Player") or ((131 + 457) <= (1845 - (1233 + 180)))) then
					if (((5766 - (522 + 447)) >= (5316 - (107 + 1314))) and v31.LightsHammer:IsCastable()) then
						if (((1660 + 1917) == (10899 - 7322)) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(4 + 4))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((7533 - 3739) > (14611 - 10918)) and (LightsHammerLightsHammerUsage == "Cursor")) then
					if (v31.LightsHammer:IsCastable() or ((3185 - (716 + 1194)) == (71 + 4029))) then
						if (v24(v33.LightsHammercursor) or ((171 + 1420) >= (4083 - (74 + 429)))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((1895 - 912) <= (897 + 911)) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
					if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((4921 - 2771) <= (847 + 350))) then
						if (((11619 - 7850) >= (2900 - 1727)) and v24(v33.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				end
			end
		end
	end
	local function v141()
		if (((1918 - (279 + 154)) == (2263 - (454 + 324))) and v31.WordofGlory:IsReady() and (v15:HolyPower() >= (3 + 0)) and (v14:HealthPercentage() <= v85) and v68) then
			if (v24(v33.WordofGloryFocus) or ((3332 - (12 + 5)) <= (1500 + 1282))) then
				return "word_of_glory st_healing";
			end
		end
		if ((v31.HolyShock:IsReady() and (v14:HealthPercentage() <= v79) and v78) or ((2231 - 1355) >= (1096 + 1868))) then
			if (v24(v33.HolyShockFocus) or ((3325 - (277 + 816)) > (10669 - 8172))) then
				return "holy_shock st_healing";
			end
		end
		if ((v31.DivineFavor:IsReady() and (v14:HealthPercentage() <= v84) and v83) or ((3293 - (1058 + 125)) <= (63 + 269))) then
			if (((4661 - (815 + 160)) > (13609 - 10437)) and v24(v31.DivineFavor)) then
				return "divine_favor st_healing";
			end
		end
		if ((v31.FlashofLight:IsCastable() and (v14:HealthPercentage() <= v81) and v80) or ((10620 - 6146) < (196 + 624))) then
			if (((12508 - 8229) >= (4780 - (41 + 1857))) and v24(v33.FlashofLightFocus, nil, true)) then
				return "flash_of_light st_healing";
			end
		end
		if ((v31.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) or ((3922 - (1222 + 671)) >= (9100 - 5579))) then
			if (v24(v33.LightoftheMartyrFocus) or ((2927 - 890) >= (5824 - (229 + 953)))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((3494 - (1111 + 663)) < (6037 - (874 + 705))) and v31.BarrierofFaith:IsCastable() and (v14:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) then
			if (v24(v33.BarrierofFaith, nil, true) or ((62 + 374) > (2062 + 959))) then
				return "barrier_of_faith st_healing";
			end
		end
		if (((1481 - 768) <= (24 + 823)) and v31.FlashofLight:IsCastable() and v15:BuffUp(v31.InfusionofLightBuff) and (v14:HealthPercentage() <= v82) and v80) then
			if (((2833 - (642 + 37)) <= (920 + 3111)) and v24(v33.FlashofLightFocus, nil, true)) then
				return "flash_of_light st_healing";
			end
		end
		if (((739 + 3876) == (11587 - 6972)) and v31.HolyPrism:IsReady() and (v14:HealthPercentage() <= v97) and v95) then
			if (v24(v33.HolyPrismPlayer) or ((4244 - (233 + 221)) == (1156 - 656))) then
				return "holy_prism on self priority 26";
			end
		end
		if (((79 + 10) < (1762 - (718 + 823))) and v31.HolyLight:IsCastable() and (v14:HealthPercentage() <= v84) and v83) then
			if (((1293 + 761) >= (2226 - (266 + 539))) and v24(v33.HolyLightFocus, nil, true)) then
				return "holy_light st_healing";
			end
		end
		if (((1958 - 1266) < (4283 - (636 + 589))) and v127.AreUnitsBelowHealthPercentage(v99, v100)) then
			if ((v98 == "Player") or ((7723 - 4469) == (3413 - 1758))) then
				if (v31.LightsHammer:IsCastable() or ((1028 + 268) == (1784 + 3126))) then
					if (((4383 - (657 + 358)) == (8917 - 5549)) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(18 - 10))) then
						return "lights_hammer priority 6";
					end
				end
			elseif (((3830 - (1151 + 36)) < (3685 + 130)) and (v98 == "Cursor")) then
				if (((503 + 1410) > (1472 - 979)) and v31.LightsHammer:IsCastable()) then
					if (((6587 - (1552 + 280)) > (4262 - (64 + 770))) and v24(v33.LightsHammercursor)) then
						return "lights_hammer priority 6";
					end
				end
			elseif (((938 + 443) <= (5377 - 3008)) and (v98 == "Enemy Under Cursor")) then
				if ((v31.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((860 + 3983) == (5327 - (157 + 1086)))) then
					if (((9345 - 4676) > (1589 - 1226)) and v24(v33.LightsHammercursor)) then
						return "lights_hammer priority 6";
					end
				end
			end
		end
	end
	local function v142()
		local v157 = 0 - 0;
		local v158;
		while true do
			if ((v157 == (1 - 0)) or ((2696 - (599 + 220)) >= (6248 - 3110))) then
				if (((6673 - (1813 + 118)) >= (2651 + 975)) and v158) then
					return v158;
				end
				v158 = v141();
				v157 = 1219 - (841 + 376);
			end
			if ((v157 == (2 - 0)) or ((1055 + 3485) == (2500 - 1584))) then
				if (v158 or ((2015 - (464 + 395)) > (11150 - 6805))) then
					return v158;
				end
				break;
			end
			if (((1075 + 1162) < (5086 - (467 + 370))) and (v157 == (0 - 0))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(30 + 10) or ((9197 - 6514) < (4 + 19))) then
					return;
				end
				v158 = v140();
				v157 = 2 - 1;
			end
		end
	end
	local function v143()
		if (((1217 - (150 + 370)) <= (2108 - (74 + 1208))) and v127.GetCastingEnemy(v31.BlackoutBarrelDebuff) and v31.BlessingofFreedom:IsReady()) then
			local v186 = v127.FocusSpecifiedUnit(v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)), 98 - 58);
			if (((5240 - 4135) <= (837 + 339)) and v186) then
				return v186;
			end
			if (((3769 - (14 + 376)) <= (6611 - 2799)) and v14 and UnitIsUnit(v14:ID(), v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)):ID())) then
				if (v24(v33.BlessingofFreedomFocus) or ((510 + 278) >= (1420 + 196))) then
					return "blessing_of_freedom combat";
				end
			end
		end
		local v159 = v127.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 39 + 1, 58 - 38);
		if (((1395 + 459) <= (3457 - (23 + 55))) and v159) then
			return v159;
		end
		if (((10780 - 6231) == (3036 + 1513)) and v31.BlessingofFreedom:IsReady() and v127.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
			if (v24(v33.BlessingofFreedomFocus) or ((2714 + 308) >= (4688 - 1664))) then
				return "blessing_of_freedom combat";
			end
		end
		if (((1517 + 3303) > (3099 - (652 + 249))) and v42) then
			local v187 = 0 - 0;
			while true do
				if ((v187 == (1868 - (708 + 1160))) or ((2879 - 1818) >= (8917 - 4026))) then
					v159 = v134();
					if (((1391 - (10 + 17)) <= (1005 + 3468)) and v159) then
						return v159;
					end
					break;
				end
			end
		end
		if (v46 or ((5327 - (1400 + 332)) <= (5 - 2))) then
			if ((v15:DebuffUp(v31.Entangled) and v31.BlessingofFreedom:IsReady()) or ((6580 - (242 + 1666)) == (1649 + 2203))) then
				if (((572 + 987) == (1329 + 230)) and v24(v33.BlessingofFreedomPlayer)) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if ((v116 ~= "None") or ((2692 - (850 + 90)) <= (1379 - 591))) then
			if ((v31.BeaconofLight:IsCastable() and (v127.NamedUnit(1430 - (360 + 1030), v116, 27 + 3) ~= nil) and v127.NamedUnit(112 - 72, v116, 41 - 11):BuffDown(v31.BeaconofLight)) or ((5568 - (909 + 752)) == (1400 - (109 + 1114)))) then
				if (((6353 - 2883) > (217 + 338)) and v24(v33.BeaconofLightMacro)) then
					return "beacon_of_light combat";
				end
			end
		end
		if ((v117 ~= "None") or ((1214 - (6 + 236)) == (407 + 238))) then
			if (((2562 + 620) >= (4988 - 2873)) and v31.BeaconofFaith:IsCastable() and (v127.NamedUnit(69 - 29, v117, 1163 - (1076 + 57)) ~= nil) and v127.NamedUnit(7 + 33, v117, 719 - (579 + 110)):BuffDown(v31.BeaconofFaith)) then
				if (((308 + 3585) < (3916 + 513)) and v24(v33.BeaconofFaithMacro)) then
					return "beacon_of_faith combat";
				end
			end
		end
		local v159 = v136();
		if (v159 or ((1522 + 1345) < (2312 - (174 + 233)))) then
			return v159;
		end
		v159 = v139();
		if (v159 or ((5016 - 3220) >= (7110 - 3059))) then
			return v159;
		end
		v159 = v133();
		if (((720 + 899) <= (4930 - (663 + 511))) and v159) then
			return v159;
		end
		v159 = v142();
		if (((539 + 65) == (132 + 472)) and v159) then
			return v159;
		end
		if (v127.TargetIsValid() or ((13823 - 9339) == (545 + 355))) then
			v159 = v137();
			if (v159 or ((10497 - 6038) <= (2694 - 1581))) then
				return v159;
			end
			v159 = v138();
			if (((1734 + 1898) > (6613 - 3215)) and v159) then
				return v159;
			end
		end
	end
	local function v144()
		if (((2910 + 1172) <= (450 + 4467)) and v42) then
			ShouldReturn = v134();
			if (((5554 - (478 + 244)) >= (1903 - (440 + 77))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if (((63 + 74) == (501 - 364)) and v46) then
			if ((v15:DebuffUp(v31.Entangled) and v31.BlessingofFreedom:IsReady()) or ((3126 - (655 + 901)) >= (804 + 3528))) then
				if (v24(v33.BlessingofFreedomPlayer) or ((3112 + 952) <= (1229 + 590))) then
					return "blessing_of_freedom out of combat";
				end
			end
		end
		if (v118 or ((20086 - 15100) < (3019 - (695 + 750)))) then
			local v188 = 0 - 0;
			local v189;
			while true do
				if (((6829 - 2403) > (691 - 519)) and (v188 == (351 - (285 + 66)))) then
					if (((1365 - 779) > (1765 - (682 + 628))) and (v116 ~= "None")) then
						if (((134 + 692) == (1125 - (176 + 123))) and v31.BeaconofLight:IsCastable() and (v127.NamedUnit(17 + 23, v116, 22 + 8) ~= nil) and v127.NamedUnit(309 - (239 + 30), v116, 9 + 21):BuffDown(v31.BeaconofLight)) then
							if (v24(v33.BeaconofLightMacro) or ((3863 + 156) > (7860 - 3419))) then
								return "beacon_of_light combat";
							end
						end
					end
					if (((6292 - 4275) < (4576 - (306 + 9))) and (v117 ~= "None")) then
						if (((16456 - 11740) > (14 + 66)) and v31.BeaconofFaith:IsCastable() and (v127.NamedUnit(25 + 15, v117, 15 + 15) ~= nil) and v127.NamedUnit(114 - 74, v117, 1405 - (1140 + 235)):BuffDown(v31.BeaconofFaith)) then
							if (v24(v33.BeaconofFaithMacro) or ((2232 + 1275) == (3001 + 271))) then
								return "beacon_of_faith combat";
							end
						end
					end
					v188 = 1 + 0;
				end
				if ((v188 == (53 - (33 + 19))) or ((317 + 559) >= (9216 - 6141))) then
					v189 = v142();
					if (((1918 + 2434) > (5008 - 2454)) and v189) then
						return v189;
					end
					break;
				end
			end
		end
		if ((v31.DevotionAura:IsCastable() and v15:BuffDown(v31.DevotionAura)) or ((4132 + 274) < (4732 - (586 + 103)))) then
			if (v24(v31.DevotionAura) or ((172 + 1717) >= (10415 - 7032))) then
				return "devotion_aura";
			end
		end
		if (((3380 - (1309 + 179)) <= (4935 - 2201)) and v127.TargetIsValid()) then
			local v190 = v135();
			if (((837 + 1086) < (5956 - 3738)) and v190) then
				return v190;
			end
		end
	end
	local function v145()
		local v160 = 0 + 0;
		while true do
			if (((4616 - 2443) > (754 - 375)) and (v160 == (610 - (295 + 314)))) then
				v39 = EpicSettings.Settings['UseAngelicFeather'];
				v40 = EpicSettings.Settings['UseBodyAndSoul'];
				v41 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
				v42 = EpicSettings.Settings['DispelDebuffs'];
				v43 = EpicSettings.Settings['DispelBuffs'];
				v160 = 1964 - (1300 + 662);
			end
			if ((v160 == (18 - 12)) or ((4346 - (1178 + 577)) == (1771 + 1638))) then
				v68 = EpicSettings.Settings['UseWordOfGlory'];
				v69 = EpicSettings.Settings['WordofGlorydHP'] or (0 - 0);
				v70 = EpicSettings.Settings['UseAvengingWrath'];
				v71 = EpicSettings.Settings['AvengingWrathHP'] or (1405 - (851 + 554));
				v72 = EpicSettings.Settings['AvengingWrathGroup'] or (0 + 0);
				v160 = 19 - 12;
			end
			if (((9803 - 5289) > (3626 - (115 + 187))) and (v160 == (0 + 0))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or "";
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v38 = EpicSettings.Settings['UsePowerWordFortitude'];
				v160 = 3 - 2;
			end
			if ((v160 == (1169 - (160 + 1001))) or ((182 + 26) >= (3332 + 1496))) then
				v78 = EpicSettings.Settings['UseHolyShock'];
				v79 = EpicSettings.Settings['HolyShockHP'] or (0 - 0);
				break;
			end
			if ((v160 == (362 - (237 + 121))) or ((2480 - (525 + 372)) > (6762 - 3195))) then
				v58 = EpicSettings.Settings['UseHolyShockOffensively'];
				v59 = EpicSettings.Settings['UseHolyShockCycle'];
				v60 = EpicSettings.Settings['UseHolyShockGroup'] or (0 - 0);
				v61 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
				v62 = EpicSettings.Settings['UseLayOnHands'];
				v160 = 147 - (96 + 46);
			end
			if ((v160 == (784 - (643 + 134))) or ((474 + 839) == (1903 - 1109))) then
				v73 = EpicSettings.Settings['UseAuraMastery'];
				v74 = EpicSettings.Settings['AuraMasteryhHP'] or (0 - 0);
				v75 = EpicSettings.Settings['AuraMasteryGroup'] or (0 + 0);
				v76 = EpicSettings.Settings['UseBlessingOfSacrifice'];
				v77 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (0 - 0);
				v160 = 16 - 8;
			end
			if (((3893 - (316 + 403)) > (1929 + 973)) and (v160 == (13 - 8))) then
				v63 = EpicSettings.Settings['LayOnHandsHP'] or (0 + 0);
				v64 = EpicSettings.Settings['UseDivineProtection'];
				v65 = EpicSettings.Settings['DivineProtectionHP'] or (0 - 0);
				v66 = EpicSettings.Settings['UseDivineShield'];
				v67 = EpicSettings.Settings['DivineShieldHP'] or (0 + 0);
				v160 = 2 + 4;
			end
			if (((14275 - 10155) <= (20345 - 16085)) and (v160 == (3 - 1))) then
				v44 = EpicSettings.Settings['HandleCharredTreant'];
				v45 = EpicSettings.Settings['HandleCharredBrambles'];
				v46 = EpicSettings.Settings['HandleEntangling'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v160 = 1 + 2;
			end
			if ((v160 == (5 - 2)) or ((44 + 839) > (14057 - 9279))) then
				v49 = EpicSettings.Settings['InterruptThreshold'] or (17 - (12 + 5));
				v54 = EpicSettings.Settings['UseHealthstone'];
				v55 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v56 = EpicSettings.Settings['UseAvengingWrathOffensively'];
				v57 = EpicSettings.Settings['UseDivineTollOffensively'];
				v160 = 8 - 4;
			end
		end
	end
	local function v146()
		v80 = EpicSettings.Settings['UseFlashOfLight'];
		v81 = EpicSettings.Settings['FlashOfLightHP'] or (0 - 0);
		v82 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (0 - 0);
		v83 = EpicSettings.Settings['UseHolyLight'];
		v84 = EpicSettings.Settings['HolyLightHP'] or (0 + 0);
		v68 = EpicSettings.Settings['UseWordOfGlory'];
		v85 = EpicSettings.Settings['WordOfGloryHP'] or (1973 - (1656 + 317));
		v86 = EpicSettings.Settings['UseBeaconOfVirtue'];
		v87 = EpicSettings.Settings['BeaconOfVirtueHP'] or (0 + 0);
		v88 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (0 + 0);
		v89 = EpicSettings.Settings['UseLightOfDawn'];
		v90 = EpicSettings.Settings['LightOfDawnhHP'] or (0 - 0);
		v91 = EpicSettings.Settings['LightOfDawnGroup'] or (0 - 0);
		v92 = EpicSettings.Settings['UseDivineToll'];
		v93 = EpicSettings.Settings['DivineTollHP'] or (354 - (5 + 349));
		v94 = EpicSettings.Settings['DivineTollGroup'] or (0 - 0);
		v95 = EpicSettings.Settings['UseHolyPrism'];
		v96 = EpicSettings.Settings['UseHolyPrismOffensively'];
		v97 = EpicSettings.Settings['HolyPrismHP'] or (1271 - (266 + 1005));
		v98 = EpicSettings.Settings['LightsHammerUsage'] or "";
		v99 = EpicSettings.Settings['LightsHammerHP'] or (0 + 0);
		v100 = EpicSettings.Settings['LightsHammerGroup'] or (0 - 0);
		v101 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
		v102 = EpicSettings.Settings['BlessingOfProtection'] or (0 - 0);
		v103 = EpicSettings.Settings['UseDaybreak'];
		v104 = EpicSettings.Settings['DaybreakMana'] or (1696 - (561 + 1135));
		v105 = EpicSettings.Settings['DaybreakHP'] or (0 - 0);
		v106 = EpicSettings.Settings['DaybreakHGroup'] or (0 - 0);
		v107 = EpicSettings.Settings['DaybreakGroup'] or (1066 - (507 + 559));
		v108 = EpicSettings.Settings['UseTyrsDeliverance'];
		v109 = EpicSettings.Settings['TyrsDeliveranceHP'] or (0 - 0);
		v110 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (0 - 0);
		v111 = EpicSettings.Settings['UseHandOfDivinity'];
		v112 = EpicSettings.Settings['HandOfDivinityHP'] or (388 - (212 + 176));
		v113 = EpicSettings.Settings['HandOfDivinityGroup'] or (905 - (250 + 655));
		v114 = EpicSettings.Settings['UseBarrierOfFaith'];
		v115 = EpicSettings.Settings['BarrierOfFaithHP'] or (0 - 0);
		v116 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
		v117 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
	end
	local function v147()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (2 - 0)) or ((5576 - (1869 + 87)) >= (16964 - 12073))) then
				v122 = EpicSettings.Toggles['cycle'];
				v123 = EpicSettings.Toggles['lod'];
				if (((6159 - (484 + 1417)) > (2008 - 1071)) and v15:IsMounted()) then
					return;
				end
				v173 = 4 - 1;
			end
			if ((v173 == (778 - (48 + 725))) or ((7953 - 3084) < (2430 - 1524))) then
				if (AOE or ((712 + 513) > (11298 - 7070))) then
					v126 = #v125;
				else
					v126 = 1 + 0;
				end
				if (((970 + 2358) > (3091 - (152 + 701))) and not v15:IsChanneling()) then
					if (((5150 - (430 + 881)) > (539 + 866)) and (v118 or v15:AffectingCombat())) then
						if (v15:AffectingCombat() or ((2188 - (557 + 338)) <= (150 + 357))) then
							local v234 = 0 - 0;
							local v235;
							while true do
								if (((0 - 0) == v234) or ((7693 - 4797) < (1734 - 929))) then
									v235 = v143();
									if (((3117 - (499 + 302)) == (3182 - (39 + 827))) and v235) then
										return v235;
									end
									break;
								end
							end
						else
							local v236 = 0 - 0;
							local v237;
							while true do
								if ((v236 == (0 - 0)) or ((10207 - 7637) == (2352 - 819))) then
									v237 = v144();
									if (v237 or ((76 + 807) == (4273 - 2813))) then
										return v237;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if ((v173 == (1 + 3)) or ((7308 - 2689) <= (1103 - (103 + 1)))) then
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((3964 - (475 + 79)) > (8897 - 4781))) then
					local v228 = 0 - 0;
					local v229;
					while true do
						if ((v228 == (0 + 0)) or ((795 + 108) >= (4562 - (1395 + 108)))) then
							v229 = v127.DeadFriendlyUnitsCount();
							if (v15:AffectingCombat() or ((11569 - 7593) < (4061 - (7 + 1197)))) then
								if (((2150 + 2780) > (805 + 1502)) and v31.Intercession:IsCastable()) then
									if (v24(v31.Intercession, nil, true) or ((4365 - (27 + 292)) < (3782 - 2491))) then
										return "intercession";
									end
								end
							elseif ((v229 > (1 - 0)) or ((17785 - 13544) == (6990 - 3445))) then
								if (v24(v31.Absolution, nil, true) or ((7709 - 3661) > (4371 - (43 + 96)))) then
									return "absolution";
								end
							elseif (v24(v31.Redemption, not v17:IsInRange(163 - 123), true) or ((3956 - 2206) >= (2882 + 591))) then
								return "redemption";
							end
							break;
						end
					end
				end
				if (((894 + 2272) == (6257 - 3091)) and (v15:AffectingCombat() or (v42 and v120))) then
					local v230 = v42 and v31.Cleanse:IsReady();
					local v231 = v127.FocusUnit(v230, v33, 8 + 12);
					if (((3303 - 1540) < (1173 + 2551)) and v231) then
						return v231;
					end
				end
				v125 = v15:GetEnemiesInMeleeRange(1 + 7);
				v173 = 1756 - (1414 + 337);
			end
			if (((1997 - (1642 + 298)) <= (7098 - 4375)) and (v173 == (8 - 5))) then
				if (v15:IsDeadOrGhost() or ((6142 - 4072) == (146 + 297))) then
					return;
				end
				if (v44 or ((2105 + 600) == (2365 - (357 + 615)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (6 - 3)) or ((3943 + 658) < (130 - 69))) then
							ShouldReturn = v127.HandleCharredTreant(v31.HolyLight, v33.HolyLightMouseover, 32 + 8);
							if (ShouldReturn or ((95 + 1295) >= (2982 + 1762))) then
								return ShouldReturn;
							end
							break;
						end
						if (((1301 - (384 + 917)) == v232) or ((2700 - (128 + 569)) > (5377 - (1407 + 136)))) then
							ShouldReturn = v127.HandleCharredTreant(v31.HolyShock, v33.HolyShockMouseover, 1927 - (687 + 1200));
							if (ShouldReturn or ((1866 - (556 + 1154)) > (13766 - 9853))) then
								return ShouldReturn;
							end
							v232 = 96 - (9 + 86);
						end
						if (((616 - (275 + 146)) == (32 + 163)) and (v232 == (66 - (29 + 35)))) then
							ShouldReturn = v127.HandleCharredTreant(v31.FlashofLight, v33.FlashofLightMouseover, 177 - 137);
							if (((9274 - 6169) >= (7928 - 6132)) and ShouldReturn) then
								return ShouldReturn;
							end
							v232 = 2 + 1;
						end
						if (((5391 - (53 + 959)) >= (2539 - (312 + 96))) and (v232 == (1 - 0))) then
							ShouldReturn = v127.HandleCharredTreant(v31.WordofGlory, v33.WordofGloryMouseover, 325 - (147 + 138));
							if (((4743 - (813 + 86)) >= (1847 + 196)) and ShouldReturn) then
								return ShouldReturn;
							end
							v232 = 3 - 1;
						end
					end
				end
				if (v45 or ((3724 - (18 + 474)) <= (922 + 1809))) then
					local v233 = 0 - 0;
					while true do
						if (((5991 - (860 + 226)) == (5208 - (121 + 182))) and (v233 == (1 + 1))) then
							ShouldReturn = v127.HandleCharredBrambles(v31.FlashofLight, v33.FlashofLightMouseover, 1280 - (988 + 252));
							if (ShouldReturn or ((468 + 3668) >= (1382 + 3029))) then
								return ShouldReturn;
							end
							v233 = 1973 - (49 + 1921);
						end
						if ((v233 == (890 - (223 + 667))) or ((3010 - (51 + 1)) == (6913 - 2896))) then
							ShouldReturn = v127.HandleCharredBrambles(v31.HolyShock, v33.HolyShockMouseover, 85 - 45);
							if (((2353 - (146 + 979)) >= (230 + 583)) and ShouldReturn) then
								return ShouldReturn;
							end
							v233 = 606 - (311 + 294);
						end
						if (((8 - 5) == v233) or ((1464 + 1991) > (5493 - (496 + 947)))) then
							ShouldReturn = v127.HandleCharredBrambles(v31.HolyLight, v33.HolyLightMouseover, 1398 - (1233 + 125));
							if (((99 + 144) == (219 + 24)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v233 == (1 + 0)) or ((1916 - (963 + 682)) > (1312 + 260))) then
							ShouldReturn = v127.HandleCharredBrambles(v31.WordofGlory, v33.WordofGloryMouseover, 1544 - (504 + 1000));
							if (((1845 + 894) < (2999 + 294)) and ShouldReturn) then
								return ShouldReturn;
							end
							v233 = 1 + 1;
						end
					end
				end
				v173 = 5 - 1;
			end
			if ((v173 == (1 + 0)) or ((2293 + 1649) < (1316 - (156 + 26)))) then
				v119 = EpicSettings.Toggles['cds'];
				v120 = EpicSettings.Toggles['dispel'];
				v121 = EpicSettings.Toggles['spread'];
				v173 = 2 + 0;
			end
			if ((v173 == (0 - 0)) or ((2857 - (149 + 15)) == (5933 - (890 + 70)))) then
				v145();
				v146();
				v118 = EpicSettings.Toggles['ooc'];
				v173 = 118 - (39 + 78);
			end
		end
	end
	local function v148()
		local v174 = 482 - (14 + 468);
		while true do
			if (((4719 - 2573) == (5998 - 3852)) and (v174 == (1 + 0))) then
				v127.DispellableDebuffs = v12.MergeTable(v127.DispellableDebuffs, v127.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.01 By BoomK");
				break;
			end
			if ((v174 == (0 + 0)) or ((477 + 1767) == (1457 + 1767))) then
				v21.Print("Holy Paladin by Epic.");
				v127.DispellableDebuffs = v127.DispellableMagicDebuffs;
				v174 = 1 + 0;
			end
		end
	end
	v21.SetAPL(124 - 59, v147, v148);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

