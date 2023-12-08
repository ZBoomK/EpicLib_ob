local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 798 - (230 + 568);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((2344 - (572 + 477)) >= (437 + 2796))) then
			return v6(...);
		end
		if (((2627 + 1750) > (196 + 1446)) and (v5 == (86 - (84 + 2)))) then
			v6 = v0[v4];
			if (((7783 - 3060) > (977 + 379)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 843 - (497 + 345);
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
	local v31 = Everyone.LowestFriendlyUnit(2 + 38, nil, 4 + 16);
	local v32 = v19.Paladin.Holy;
	local v33 = v20.Paladin.Holy;
	local v34 = v23.Paladin.Holy;
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
	local v85;
	local v69;
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
	local v118;
	local v119 = false;
	local v120 = false;
	local v121 = false;
	local v122 = false;
	local v123 = false;
	local v124 = false;
	local v125 = {};
	local v126;
	local v127;
	local v128 = v21.Commons.Everyone;
	local function v129(v150)
		return v150:DebuffRefreshable(v32.JudgmentDebuff);
	end
	local function v130()
		for v164 = 1334 - (605 + 728), 3 + 1 do
			local v165 = 0 - 0;
			local v166;
			local v167;
			local v168;
			local v169;
			while true do
				if ((v165 == (0 + 0)) or ((15291 - 11155) <= (3095 + 338))) then
					v166, v167, v168, v169 = v29(v164);
					if (((11761 - 7516) <= (3497 + 1134)) and (v167 == v32.Consecration:Name())) then
						return (v27(((v168 + v169) - v30()) + (489.5 - (457 + 32)))) or (0 + 0);
					end
					break;
				end
			end
		end
		return 1402 - (832 + 570);
	end
	local function v131(v151)
		return v151:DebuffRefreshable(v32.GlimmerofLightBuff) or not v62;
	end
	local function v132()
		if (((4029 + 247) >= (1021 + 2893)) and v32.BlessingofSummer:IsCastable() and v15:IsInParty() and not v15:IsInRaid()) then
			if (((700 - 502) <= (2103 + 2262)) and v14 and v14:Exists() and (v128.UnitGroupRole(v14) == "DAMAGER")) then
				if (((5578 - (588 + 208)) > (12602 - 7926)) and v24(v34.BlessingofSummerFocus)) then
					return "blessing_of_summer";
				end
			end
		end
		local v152 = {v32.BlessingofSpring,v32.BlessingofSummer,v32.BlessingofAutumn,v32.BlessingofWinter};
		for v170, v171 in pairs(v152) do
			if (((6753 - (1569 + 320)) > (540 + 1657)) and v171:IsCastable()) then
				if (v24(v34.BlessingofSummerPlayer) or ((703 + 2997) == (8447 - 5940))) then
					return "blessing_of_the_seasons";
				end
			end
		end
	end
	local function v133()
		ShouldReturn = v128.HandleTopTrinket(v125, v120, 645 - (316 + 289), nil);
		if (((11711 - 7237) >= (13 + 261)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v128.HandleBottomTrinket(v125, v120, 1493 - (666 + 787), nil);
		if (ShouldReturn or ((2319 - (360 + 65)) <= (1314 + 92))) then
			return ShouldReturn;
		end
	end
	local function v134()
		if (((1826 - (79 + 175)) >= (2413 - 882)) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v173 = 0 + 0;
			local v174;
			while true do
				if ((v173 == (2 - 1)) or ((9025 - 4338) < (5441 - (503 + 396)))) then
					v174 = v128.InterruptWithStun(v32.HammerofJustice, 189 - (92 + 89));
					if (((6384 - 3093) > (855 + 812)) and v174) then
						return v174;
					end
					break;
				end
				if ((v173 == (0 + 0)) or ((3418 - 2545) == (279 + 1755))) then
					v174 = v128.Interrupt(v32.Rebuke, 11 - 6, true);
					if (v174 or ((2457 + 359) < (6 + 5))) then
						return v174;
					end
					v173 = 2 - 1;
				end
			end
		end
	end
	local function v135()
		if (((462 + 3237) < (7176 - 2470)) and (not v14 or not v14:Exists() or not v14:IsInRange(1284 - (485 + 759)) or not v128.DispellableFriendlyUnit())) then
			return;
		end
		if (((6122 - 3476) >= (2065 - (442 + 747))) and v32.Cleanse:IsReady()) then
			if (((1749 - (832 + 303)) <= (4130 - (88 + 858))) and v24(v34.CleanseFocus)) then
				return "cleanse dispel";
			end
		end
	end
	local function v136()
		if (((953 + 2173) == (2588 + 538)) and v32.Consecration:IsCastable() and v17:IsInMeleeRange(1 + 4)) then
			if (v24(v32.Consecration) or ((2976 - (766 + 23)) >= (24456 - 19502))) then
				return "consecrate precombat 4";
			end
		end
		if (v32.Judgment:IsReady() or ((5302 - 1425) == (9419 - 5844))) then
			if (((2399 - 1692) > (1705 - (1036 + 37))) and v24(v32.Judgment, not v17:IsSpellInRange(v32.Judgment))) then
				return "judgment precombat 6";
			end
		end
	end
	local function v137()
		if (((v15:HealthPercentage() <= v64) and v63 and v32.LayonHands:IsCastable()) or ((388 + 158) >= (5226 - 2542))) then
			if (((1153 + 312) <= (5781 - (641 + 839))) and v24(v34.LayonHandsPlayer)) then
				return "lay_on_hands defensive";
			end
		end
		if (((2617 - (910 + 3)) > (3632 - 2207)) and v32.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v68) and v67) then
			if (v24(v32.DivineProtection) or ((2371 - (1466 + 218)) == (1946 + 2288))) then
				return "divine protection";
			end
		end
		if ((v32.WordofGlory:IsReady() and (v15:HolyPower() >= (1151 - (556 + 592))) and (v15:HealthPercentage() <= v86) and v69 and not v15:HealingAbsorbed()) or ((1185 + 2145) < (2237 - (329 + 479)))) then
			if (((2001 - (174 + 680)) >= (1151 - 816)) and v24(v34.WordofGloryPlayer)) then
				return "WOG self";
			end
		end
		if (((7119 - 3684) > (1498 + 599)) and v33.Healthstone:IsReady() and v55 and (v15:HealthPercentage() <= v56)) then
			if (v24(v34.Healthstone, nil, nil, true) or ((4509 - (396 + 343)) >= (358 + 3683))) then
				return "healthstone defensive 3";
			end
		end
		if ((v36 and (v15:HealthPercentage() <= v38)) or ((5268 - (29 + 1448)) <= (3000 - (135 + 1254)))) then
			if ((v37 == "Refreshing Healing Potion") or ((17246 - 12668) <= (9375 - 7367))) then
				if (((750 + 375) <= (3603 - (389 + 1138))) and v33.RefreshingHealingPotion:IsReady()) then
					if (v24(v34.RefreshingHealingPotion, nil, nil, true) or ((1317 - (102 + 472)) >= (4152 + 247))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v138()
		local v153 = 0 + 0;
		local v154;
		while true do
			if (((1077 + 78) < (3218 - (320 + 1225))) and (v153 == (2 - 0))) then
				if (v32.HolyAvenger:IsCastable() or ((1422 + 902) <= (2042 - (157 + 1307)))) then
					if (((5626 - (821 + 1038)) == (9398 - 5631)) and v24(v32.HolyAvenger)) then
						return "holy_avenger cooldowns 16";
					end
				end
				v154 = v128.HandleTopTrinket(v125, v120, 5 + 35, nil);
				if (((7262 - 3173) == (1522 + 2567)) and v154) then
					return v154;
				end
				v153 = 7 - 4;
			end
			if (((5484 - (834 + 192)) >= (107 + 1567)) and ((1 + 2) == v153)) then
				v154 = v128.HandleBottomTrinket(v125, v120, 1 + 39, nil);
				if (((1505 - 533) <= (1722 - (300 + 4))) and v154) then
					return v154;
				end
				if (v32.Seraphim:IsReady() or ((1319 + 3619) < (12465 - 7703))) then
					if (v24(v32.Seraphim) or ((2866 - (112 + 250)) > (1700 + 2564))) then
						return "seraphim cooldowns 18";
					end
				end
				break;
			end
			if (((5393 - 3240) == (1234 + 919)) and (v153 == (1 + 0))) then
				if ((v58 and v120 and v32.DivineToll:IsCastable() and v15:BuffUp(v32.AvengingWrathBuff)) or ((380 + 127) >= (1285 + 1306))) then
					if (((3329 + 1152) == (5895 - (1001 + 413))) and v24(v32.DivineToll)) then
						return "divine_toll cooldowns 8";
					end
				end
				if (v32.BloodFury:IsCastable() or ((5191 - 2863) < (1575 - (244 + 638)))) then
					if (((5021 - (627 + 66)) == (12895 - 8567)) and v24(v32.BloodFury)) then
						return "blood_fury cooldowns 12";
					end
				end
				if (((2190 - (512 + 90)) >= (3238 - (1665 + 241))) and v32.Berserking:IsCastable()) then
					if (v24(v32.Berserking) or ((4891 - (373 + 344)) > (1916 + 2332))) then
						return "berserking cooldowns 14";
					end
				end
				v153 = 1 + 1;
			end
			if ((v153 == (0 - 0)) or ((7760 - 3174) <= (1181 - (35 + 1064)))) then
				if (((2811 + 1052) == (8264 - 4401)) and v57 and v120 and v32.AvengingWrath:IsReady() and not v15:BuffUp(v32.AvengingWrathBuff)) then
					if (v24(v32.AvengingWrath) or ((2 + 280) <= (1278 - (298 + 938)))) then
						return "avenging_wrath cooldowns 4";
					end
				end
				v154 = v132();
				if (((5868 - (233 + 1026)) >= (2432 - (636 + 1030))) and v154) then
					return v154;
				end
				v153 = 1 + 0;
			end
		end
	end
	local function v139()
		if (v120 or ((1126 + 26) == (740 + 1748))) then
			local v175 = 0 + 0;
			local v176;
			while true do
				if (((3643 - (55 + 166)) > (650 + 2700)) and (v175 == (0 + 0))) then
					v176 = v138();
					if (((3349 - 2472) > (673 - (36 + 261))) and v176) then
						return v176;
					end
					break;
				end
			end
		end
		if ((v32.ShieldoftheRighteousHoly:IsReady() and (v15:BuffUp(v32.AvengingWrathBuff) or v15:BuffUp(v32.HolyAvenger) or not v32.Awakening:IsAvailable())) or ((5452 - 2334) <= (3219 - (34 + 1334)))) then
			if (v24(v32.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(2 + 3)) or ((129 + 36) >= (4775 - (1035 + 248)))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if (((3970 - (20 + 1)) < (2530 + 2326)) and v32.ShieldoftheRighteousHoly:IsReady() and (v15:HolyPower() >= (322 - (134 + 185))) and (v31:HealthPercentage() > v70) and (v128.FriendlyUnitsBelowHealthPercentageCount(v91) < v92)) then
			if (v24(v32.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(1138 - (549 + 584))) or ((4961 - (314 + 371)) < (10353 - 7337))) then
				return "shield_of_the_righteous priority 2";
			end
		end
		if (((5658 - (478 + 490)) > (2186 + 1939)) and v32.HammerofWrath:IsReady() and (v15:HolyPower() < (1177 - (786 + 386))) and (v127 == (6 - 4))) then
			if (v24(v32.HammerofWrath, not v17:IsSpellInRange(v32.HammerofWrath)) or ((1429 - (1055 + 324)) >= (2236 - (1093 + 247)))) then
				return "hammer_of_wrath priority 4";
			end
		end
		if ((LightsHammerLightsHammerUsage == "Player") or ((1524 + 190) >= (312 + 2646))) then
			if ((v32.LightsHammer:IsCastable() and (v127 >= (7 - 5))) or ((5060 - 3569) < (1832 - 1188))) then
				if (((1768 - 1064) < (352 + 635)) and v24(v34.LightsHammerPlayer, not v17:IsInMeleeRange(30 - 22))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((12815 - 9097) > (1438 + 468)) and (LightsHammerLightsHammerUsage == "Cursor")) then
			if (v32.LightsHammer:IsCastable() or ((2449 - 1491) > (4323 - (364 + 324)))) then
				if (((9597 - 6096) <= (10778 - 6286)) and v24(v34.LightsHammercursor)) then
					return "lights_hammer priority 6";
				end
			end
		elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((1141 + 2301) < (10661 - 8113))) then
			if (((4604 - 1729) >= (4446 - 2982)) and v32.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
				if (v24(v34.LightsHammercursor) or ((6065 - (1249 + 19)) >= (4417 + 476))) then
					return "lights_hammer priority 6";
				end
			end
		end
		if ((v32.Consecration:IsCastable() and (v127 >= (7 - 5)) and (v130() <= (1086 - (686 + 400)))) or ((433 + 118) > (2297 - (73 + 156)))) then
			if (((10 + 2104) > (1755 - (721 + 90))) and v24(v32.Consecration, not v17:IsInMeleeRange(1 + 4))) then
				return "consecration priority 8";
			end
		end
		if ((v32.LightofDawn:IsReady() and v124 and ((v32.Awakening:IsAvailable() and v128.AreUnitsBelowHealthPercentage(v91, v92)) or ((v128.FriendlyUnitsBelowHealthPercentageCount(v86) > (6 - 4)) and ((v15:HolyPower() >= (475 - (224 + 246))) or (v15:BuffUp(v32.HolyAvenger) and (v15:HolyPower() >= (4 - 1))))))) or ((4164 - 1902) >= (562 + 2534))) then
			if (v24(v32.LightofDawn) or ((54 + 2201) >= (2598 + 939))) then
				return "light_of_dawn priority 10";
			end
		end
		if ((v32.ShieldoftheRighteousHoly:IsReady() and (v127 > (5 - 2))) or ((12768 - 8931) < (1819 - (203 + 310)))) then
			if (((4943 - (1238 + 755)) == (207 + 2743)) and v24(v32.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(1539 - (709 + 825)))) then
				return "shield_of_the_righteous priority 12";
			end
		end
		if (v32.HammerofWrath:IsReady() or ((8702 - 3979) < (4803 - 1505))) then
			if (((2000 - (196 + 668)) >= (607 - 453)) and v24(v32.HammerofWrath, not v17:IsSpellInRange(v32.HammerofWrath))) then
				return "hammer_of_wrath priority 14";
			end
		end
		if (v32.Judgment:IsReady() or ((561 - 290) > (5581 - (171 + 662)))) then
			if (((4833 - (4 + 89)) >= (11047 - 7895)) and v24(v32.Judgment, not v17:IsSpellInRange(v32.Judgment))) then
				return "judgment priority 16";
			end
		end
		if ((LightsHammer == "Player") or ((939 + 1639) >= (14889 - 11499))) then
			if (((17 + 24) <= (3147 - (35 + 1451))) and v32.LightsHammer:IsCastable()) then
				if (((2054 - (28 + 1425)) < (5553 - (941 + 1052))) and v24(v34.LightsHammerPlayer, not v17:IsInMeleeRange(8 + 0))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((1749 - (822 + 692)) < (980 - 293)) and (LightsHammer == "Cursor")) then
			if (((2143 + 2406) > (1450 - (45 + 252))) and v32.LightsHammer:IsCastable()) then
				if (v24(v34.LightsHammercursor) or ((4625 + 49) < (1608 + 3064))) then
					return "lights_hammer priority 6";
				end
			end
		elseif (((8926 - 5258) < (4994 - (114 + 319))) and (LightsHammer == "Enemy Under Cursor")) then
			if ((v32.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((652 - 197) == (4619 - 1014))) then
				if (v24(v34.LightsHammercursor) or ((1698 + 965) == (4933 - 1621))) then
					return "lights_hammer priority 6";
				end
			end
		end
		if (((8961 - 4684) <= (6438 - (556 + 1407))) and v32.Consecration:IsCastable() and (v130() <= (1206 - (741 + 465)))) then
			if (v24(v32.Consecration, not v17:IsInMeleeRange(470 - (170 + 295))) or ((459 + 411) == (1093 + 96))) then
				return "consecration priority 20";
			end
		end
		if (((3823 - 2270) <= (2598 + 535)) and v59 and v32.HolyShock:IsReady() and v17:DebuffDown(v32.GlimmerofLightBuff) and (not v32.GlimmerofLight:IsAvailable() or v131(v17))) then
			if (v24(v32.HolyShock, not v17:IsSpellInRange(v32.HolyShock)) or ((1435 + 802) >= (1989 + 1522))) then
				return "holy_shock damage";
			end
		end
		if ((v59 and v60 and v32.HolyShock:IsReady() and (v128.EnemiesWithDebuffCount(v32.GlimmerofLightBuff, 1270 - (957 + 273)) < v61) and v123) or ((355 + 969) > (1209 + 1811))) then
			if (v128.CastCycle(v32.HolyShock, v126, v131, not v17:IsSpellInRange(v32.HolyShock), nil, nil, v34.HolyShockMouseover) or ((11400 - 8408) == (4956 - 3075))) then
				return "holy_shock_cycle damage";
			end
		end
		if (((9487 - 6381) > (7556 - 6030)) and v32.CrusaderStrike:IsReady() and (v32.CrusaderStrike:Charges() == (1782 - (389 + 1391)))) then
			if (((1897 + 1126) < (403 + 3467)) and v24(v32.CrusaderStrike, not v17:IsInMeleeRange(11 - 6))) then
				return "crusader_strike priority 24";
			end
		end
		if (((1094 - (783 + 168)) > (248 - 174)) and v32.HolyPrism:IsReady() and (v127 >= (2 + 0)) and v97) then
			if (((329 - (309 + 2)) < (6485 - 4373)) and v24(v34.HolyPrismPlayer)) then
				return "holy_prism on self priority 26";
			end
		end
		if (((2309 - (1090 + 122)) <= (528 + 1100)) and v32.HolyPrism:IsReady() and v97) then
			if (((15549 - 10919) == (3169 + 1461)) and v24(v32.HolyPrism, not v17:IsSpellInRange(v32.HolyPrism))) then
				return "holy_prism priority 28";
			end
		end
		if (((4658 - (628 + 490)) > (482 + 2201)) and v32.ArcaneTorrent:IsCastable()) then
			if (((11869 - 7075) >= (14966 - 11691)) and v24(v32.ArcaneTorrent)) then
				return "arcane_torrent priority 30";
			end
		end
		if (((2258 - (431 + 343)) == (2996 - 1512)) and v32.LightofDawn:IsReady() and v124 and (v15:HolyPower() >= (8 - 5)) and ((v32.Awakening:IsAvailable() and v128.AreUnitsBelowHealthPercentage(v91, v92)) or (v128.FriendlyUnitsBelowHealthPercentageCount(v86) > (2 + 0)))) then
			if (((184 + 1248) < (5250 - (556 + 1139))) and v24(v32.LightofDawn, not v17:IsSpellInRange(v32.LightofDawn))) then
				return "light_of_dawn priority 32";
			end
		end
		if (v32.CrusaderStrike:IsReady() or ((1080 - (6 + 9)) > (656 + 2922))) then
			if (v24(v32.CrusaderStrike, not v17:IsInMeleeRange(3 + 2)) or ((4964 - (28 + 141)) < (545 + 862))) then
				return "crusader_strike priority 34";
			end
		end
		if (((2286 - 433) < (3409 + 1404)) and v32.Consecration:IsReady()) then
			if (v24(v32.Consecration, not v17:IsInMeleeRange(1322 - (486 + 831))) or ((7340 - 4519) < (8558 - 6127))) then
				return "consecration priority 36";
			end
		end
	end
	local function v140()
		local v155 = 0 + 0;
		while true do
			if ((v155 == (3 - 2)) or ((4137 - (668 + 595)) < (1963 + 218))) then
				if ((v32.AuraMastery:IsCastable() and v128.AreUnitsBelowHealthPercentage(v75, v76) and v74) or ((543 + 2146) <= (935 - 592))) then
					if (v24(v32.AuraMastery) or ((2159 - (23 + 267)) == (3953 - (1129 + 815)))) then
						return "aura_mastery cooldown_healing";
					end
				end
				if ((v32.AvengingWrath:IsCastable() and not v15:BuffUp(v32.AvengingWrathBuff) and v128.AreUnitsBelowHealthPercentage(v72, v73) and v71) or ((3933 - (371 + 16)) < (4072 - (1326 + 424)))) then
					if (v24(v32.AvengingWrath) or ((3942 - 1860) == (17441 - 12668))) then
						return "avenging_wrath cooldown_healing";
					end
				end
				if (((3362 - (88 + 30)) > (1826 - (720 + 51))) and v32.TyrsDeliverance:IsCastable() and v109 and v128.AreUnitsBelowHealthPercentage(v110, v111)) then
					if (v24(v32.TyrsDeliverance) or ((7369 - 4056) <= (3554 - (421 + 1355)))) then
						return "tyrs_deliverance cooldown_healing";
					end
				end
				v155 = 2 - 0;
			end
			if (((0 + 0) == v155) or ((2504 - (286 + 797)) >= (7691 - 5587))) then
				if (((3000 - 1188) <= (3688 - (397 + 42))) and (not v14 or not v14:Exists() or not v14:IsInRange(13 + 27))) then
					return;
				end
				if (((2423 - (24 + 776)) <= (3014 - 1057)) and v32.LayonHands:IsCastable() and (v14:HealthPercentage() <= v64) and v63) then
					if (((5197 - (222 + 563)) == (9720 - 5308)) and v24(v34.LayonHandsFocus)) then
						return "lay_on_hands cooldown_healing";
					end
				end
				if (((1260 + 490) >= (1032 - (23 + 167))) and (v102 == "Not Tank")) then
					if (((6170 - (690 + 1108)) > (668 + 1182)) and v32.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v103) and (not v128.UnitGroupRole(v14) == "TANK")) then
						if (((192 + 40) < (1669 - (40 + 808))) and v24(v34.BlessingofProtectionFocus)) then
							return "blessing_of_protection cooldown_healing";
						end
					end
				elseif (((86 + 432) < (3449 - 2547)) and (v102 == "Player")) then
					if (((2862 + 132) > (454 + 404)) and v32.BlessingofProtection:IsCastable() and (v15:HealthPercentage() <= v103)) then
						if (v24(v34.BlessingofProtectionplayer) or ((2060 + 1695) <= (1486 - (47 + 524)))) then
							return "blessing_of_protection cooldown_healing";
						end
					end
				end
				v155 = 1 + 0;
			end
			if (((10786 - 6840) > (5596 - 1853)) and (v155 == (4 - 2))) then
				if ((v32.BeaconofVirtue:IsReady() and v128.AreUnitsBelowHealthPercentage(v88, v89) and v87) or ((3061 - (1165 + 561)) >= (99 + 3207))) then
					if (((15002 - 10158) > (860 + 1393)) and v24(v34.BeaconofVirtueFocus)) then
						return "beacon_of_virtue cooldown_healing";
					end
				end
				if (((931 - (341 + 138)) == (123 + 329)) and v32.Daybreak:IsReady() and (v128.FriendlyUnitsWithBuffCount(v32.GlimmerofLightBuff, false, false) > v108) and (v128.AreUnitsBelowHealthPercentage(v106, v107) or (v15:ManaPercentage() <= v105)) and v104) then
					if (v24(v32.Daybreak) or ((9404 - 4847) < (2413 - (89 + 237)))) then
						return "daybreak cooldown_healing";
					end
				end
				if (((12462 - 8588) == (8155 - 4281)) and v32.HandofDivinity:IsReady() and v128.AreUnitsBelowHealthPercentage(v113, v114) and v112) then
					if (v24(v32.HandofDivinity) or ((2819 - (581 + 300)) > (6155 - (855 + 365)))) then
						return "divine_toll cooldown_healing";
					end
				end
				v155 = 6 - 3;
			end
			if ((v155 == (1 + 2)) or ((5490 - (1030 + 205)) < (3214 + 209))) then
				if (((1353 + 101) <= (2777 - (156 + 130))) and v32.DivineToll:IsReady() and v128.AreUnitsBelowHealthPercentage(v94, v95) and v93) then
					if (v24(v34.DivineTollFocus) or ((9445 - 5288) <= (4724 - 1921))) then
						return "divine_toll cooldown_healing";
					end
				end
				if (((9939 - 5086) >= (786 + 2196)) and v32.HolyShock:IsReady() and (v14:HealthPercentage() <= v80) and v79) then
					if (((2411 + 1723) > (3426 - (10 + 59))) and v24(v34.HolyShockFocus)) then
						return "holy_shock cooldown_healing";
					end
				end
				if ((v32.BlessingofSacrifice:IsReady() and (v14:GUID() ~= v15:GUID()) and (v14:HealthPercentage() <= v78) and v77) or ((967 + 2450) < (12479 - 9945))) then
					if (v24(v34.BlessingofSacrificeFocus) or ((3885 - (671 + 492)) <= (131 + 33))) then
						return "blessing_of_sacrifice cooldown_healing";
					end
				end
				break;
			end
		end
	end
	local function v141()
		if ((v32.BeaconofVirtue:IsReady() and v128.AreUnitsBelowHealthPercentage(v88, v89) and v87) or ((3623 - (369 + 846)) < (559 + 1550))) then
			if (v24(v34.BeaconofVirtueFocus) or ((29 + 4) == (3400 - (1036 + 909)))) then
				return "beacon_of_virtue aoe_healing";
			end
		end
		if ((v32.WordofGlory:IsReady() and (v15:HolyPower() >= (3 + 0)) and v15:BuffUp(v32.EmpyreanLegacyBuff) and (((v14:HealthPercentage() <= v86) and v69) or v128.AreUnitsBelowHealthPercentage(v91, v92))) or ((743 - 300) >= (4218 - (11 + 192)))) then
			if (((1710 + 1672) > (341 - (135 + 40))) and v24(v34.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v32.WordofGlory:IsReady() and (v15:HolyPower() >= (6 - 3)) and v15:BuffUp(v32.UnendingLightBuff) and (v14:HealthPercentage() <= v86) and v69) or ((169 + 111) == (6738 - 3679))) then
			if (((2819 - 938) > (1469 - (50 + 126))) and v24(v34.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if (((6563 - 4206) == (522 + 1835)) and v32.LightofDawn:IsReady() and v124 and (v15:HolyPower() >= (1416 - (1233 + 180))) and (v128.AreUnitsBelowHealthPercentage(v91, v92) or (v128.FriendlyUnitsBelowHealthPercentageCount(v86) > (971 - (522 + 447))))) then
			if (((1544 - (107 + 1314)) == (58 + 65)) and v24(v32.LightofDawn)) then
				return "light_of_dawn aoe_healing";
			end
		end
		if ((v32.WordofGlory:IsReady() and (v15:HolyPower() >= (8 - 5)) and (v14:HealthPercentage() <= v86) and UseWodOfGlory and (v128.FriendlyUnitsBelowHealthPercentageCount(v86) < (2 + 1))) or ((2096 - 1040) >= (13420 - 10028))) then
			if (v24(v34.WordofGloryFocus) or ((2991 - (716 + 1194)) < (19 + 1056))) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v32.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) or ((113 + 936) >= (4935 - (74 + 429)))) then
			if (v24(v34.LightoftheMartyrFocus) or ((9197 - 4429) <= (420 + 426))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (v128.TargetIsValid() or ((7686 - 4328) <= (1005 + 415))) then
			if ((v32.Consecration:IsCastable() and v32.GoldenPath:IsAvailable() and (v130() <= (0 - 0))) or ((9244 - 5505) <= (3438 - (279 + 154)))) then
				if (v24(v32.Consecration, not v17:IsInMeleeRange(783 - (454 + 324))) or ((1306 + 353) >= (2151 - (12 + 5)))) then
					return "consecration aoe_healing";
				end
			end
			if ((v32.Judgment:IsReady() and v32.JudgmentofLight:IsAvailable() and v17:DebuffDown(v32.JudgmentofLightDebuff)) or ((1758 + 1502) < (6000 - 3645))) then
				if (v24(v32.Judgment, not v17:IsSpellInRange(v32.Judgment)) or ((248 + 421) == (5316 - (277 + 816)))) then
					return "judgment aoe_healing";
				end
			end
			if (v128.AreUnitsBelowHealthPercentage(v100, v101) or ((7229 - 5537) < (1771 - (1058 + 125)))) then
				if ((LightsHammerLightsHammerUsage == "Player") or ((900 + 3897) < (4626 - (815 + 160)))) then
					if (v32.LightsHammer:IsCastable() or ((17921 - 13744) > (11513 - 6663))) then
						if (v24(v34.LightsHammerPlayer, not v17:IsInMeleeRange(2 + 6)) or ((1169 - 769) > (3009 - (41 + 1857)))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((4944 - (1222 + 671)) > (2597 - 1592)) and (LightsHammerLightsHammerUsage == "Cursor")) then
					if (((5307 - 1614) <= (5564 - (229 + 953))) and v32.LightsHammer:IsCastable()) then
						if (v24(v34.LightsHammercursor) or ((5056 - (1111 + 663)) > (5679 - (874 + 705)))) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((502 + 3078) < (1941 + 903))) then
					if (((184 - 95) < (127 + 4363)) and v32.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
						if (v24(v34.LightsHammercursor) or ((5662 - (642 + 37)) < (413 + 1395))) then
							return "lights_hammer priority 6";
						end
					end
				end
			end
		end
	end
	local function v142()
		local v156 = 0 + 0;
		while true do
			if (((9613 - 5784) > (4223 - (233 + 221))) and (v156 == (4 - 2))) then
				if (((1308 + 177) <= (4445 - (718 + 823))) and v32.LightoftheMartyr:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (((2687 + 1582) == (5074 - (266 + 539))) and v24(v34.LightoftheMartyrFocus)) then
						return "holy_shock cooldown_healing";
					end
				end
				if (((1095 - 708) <= (4007 - (636 + 589))) and v32.BarrierofFaith:IsCastable() and (v14:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) then
					if (v24(v34.BarrierofFaith, nil, true) or ((4507 - 2608) <= (1891 - 974))) then
						return "barrier_of_faith st_healing";
					end
				end
				v156 = 3 + 0;
			end
			if (((1 + 0) == v156) or ((5327 - (657 + 358)) <= (2319 - 1443))) then
				if (((5084 - 2852) <= (3783 - (1151 + 36))) and v32.DivineFavor:IsReady() and (v14:HealthPercentage() <= v85) and v84) then
					if (((2024 + 71) < (970 + 2716)) and v24(v32.DivineFavor)) then
						return "divine_favor st_healing";
					end
				end
				if ((v32.FlashofLight:IsCastable() and (v14:HealthPercentage() <= v82) and v81) or ((4763 - 3168) >= (6306 - (1552 + 280)))) then
					if (v24(v34.FlashofLightFocus, nil, true) or ((5453 - (64 + 770)) < (1957 + 925))) then
						return "flash_of_light st_healing";
					end
				end
				v156 = 4 - 2;
			end
			if ((v156 == (0 + 0)) or ((1537 - (157 + 1086)) >= (9669 - 4838))) then
				if (((8886 - 6857) <= (4730 - 1646)) and v32.WordofGlory:IsReady() and (v15:HolyPower() >= (3 - 0)) and (v14:HealthPercentage() <= v86) and v69) then
					if (v24(v34.WordofGloryFocus) or ((2856 - (599 + 220)) == (4819 - 2399))) then
						return "word_of_glory st_healing";
					end
				end
				if (((6389 - (1813 + 118)) > (2854 + 1050)) and v32.HolyShock:IsReady() and (v14:HealthPercentage() <= v80) and v79) then
					if (((1653 - (841 + 376)) >= (171 - 48)) and v24(v34.HolyShockFocus)) then
						return "holy_shock st_healing";
					end
				end
				v156 = 1 + 0;
			end
			if (((1364 - 864) < (2675 - (464 + 395))) and (v156 == (10 - 6))) then
				if (((1717 + 1857) == (4411 - (467 + 370))) and v32.HolyLight:IsCastable() and (v14:HealthPercentage() <= v85) and v84) then
					if (((456 - 235) < (287 + 103)) and v24(v34.HolyLightFocus, nil, true)) then
						return "holy_light st_healing";
					end
				end
				if (v128.AreUnitsBelowHealthPercentage(v100, v101) or ((7586 - 5373) <= (222 + 1199))) then
					if (((7114 - 4056) < (5380 - (150 + 370))) and (v99 == "Player")) then
						if (v32.LightsHammer:IsCastable() or ((2578 - (74 + 1208)) >= (10935 - 6489))) then
							if (v24(v34.LightsHammerPlayer, not v17:IsInMeleeRange(37 - 29)) or ((992 + 401) > (4879 - (14 + 376)))) then
								return "lights_hammer priority 6";
							end
						end
					elseif ((v99 == "Cursor") or ((7672 - 3248) < (18 + 9))) then
						if (v32.LightsHammer:IsCastable() or ((1755 + 242) > (3639 + 176))) then
							if (((10152 - 6687) > (1440 + 473)) and v24(v34.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					elseif (((811 - (23 + 55)) < (4310 - 2491)) and (v99 == "Enemy Under Cursor")) then
						if ((v32.LightsHammer:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or ((2933 + 1462) == (4270 + 485))) then
							if (v24(v34.LightsHammercursor) or ((5880 - 2087) < (746 + 1623))) then
								return "lights_hammer priority 6";
							end
						end
					end
				end
				break;
			end
			if ((v156 == (904 - (652 + 249))) or ((10929 - 6845) == (2133 - (708 + 1160)))) then
				if (((11829 - 7471) == (7945 - 3587)) and v32.FlashofLight:IsCastable() and v15:BuffUp(v32.InfusionofLightBuff) and (v14:HealthPercentage() <= v83) and v81) then
					if (v24(v34.FlashofLightFocus, nil, true) or ((3165 - (10 + 17)) < (224 + 769))) then
						return "flash_of_light st_healing";
					end
				end
				if (((5062 - (1400 + 332)) > (4455 - 2132)) and v32.HolyPrism:IsReady() and (v14:HealthPercentage() <= v98) and v96) then
					if (v24(v34.HolyPrismPlayer) or ((5534 - (242 + 1666)) == (1707 + 2282))) then
						return "holy_prism on self priority 26";
					end
				end
				v156 = 2 + 2;
			end
		end
	end
	local function v143()
		if (not v14 or not v14:Exists() or not v14:IsInRange(35 + 5) or ((1856 - (850 + 90)) == (4677 - 2006))) then
			return;
		end
		local v157 = v141();
		if (((1662 - (360 + 1030)) == (241 + 31)) and v157) then
			return v157;
		end
		v157 = v142();
		if (((11992 - 7743) <= (6657 - 1818)) and v157) then
			return v157;
		end
	end
	local function v144()
		local v158 = 1661 - (909 + 752);
		local v159;
		while true do
			if (((4000 - (109 + 1114)) < (5858 - 2658)) and (v158 == (1 + 1))) then
				if (((337 - (6 + 236)) < (1233 + 724)) and (v117 ~= "None")) then
					if (((665 + 161) < (4048 - 2331)) and v32.BeaconofLight:IsCastable() and (v128.NamedUnit(69 - 29, v117, 1163 - (1076 + 57)) ~= nil) and v128.NamedUnit(7 + 33, v117, 719 - (579 + 110)):BuffDown(v32.BeaconofLight)) then
						if (((113 + 1313) >= (977 + 128)) and v24(v34.BeaconofLightMacro)) then
							return "beacon_of_light combat";
						end
					end
				end
				if (((1462 + 1292) <= (3786 - (174 + 233))) and (v118 ~= "None")) then
					if ((v32.BeaconofFaith:IsCastable() and (v128.NamedUnit(111 - 71, v118, 52 - 22) ~= nil) and v128.NamedUnit(18 + 22, v118, 1204 - (663 + 511)):BuffDown(v32.BeaconofFaith)) or ((3504 + 423) == (307 + 1106))) then
						if (v24(v34.BeaconofFaithMacro) or ((3557 - 2403) <= (478 + 310))) then
							return "beacon_of_faith combat";
						end
					end
				end
				v159 = v137();
				v158 = 6 - 3;
			end
			if ((v158 == (0 - 0)) or ((785 + 858) > (6576 - 3197))) then
				if ((v128.GetCastingEnemy(v32.BlackoutBarrelDebuff) and v32.BlessingofFreedom:IsReady()) or ((1998 + 805) > (416 + 4133))) then
					local v228 = v128.FocusSpecifiedUnit(v128.GetUnitsTargetFriendly(v128.GetCastingEnemy(v32.BlackoutBarrelDebuff)), 762 - (478 + 244));
					if (v228 or ((737 - (440 + 77)) >= (1375 + 1647))) then
						return v228;
					end
					if (((10328 - 7506) == (4378 - (655 + 901))) and v14 and UnitIsUnit(v14:ID(), v128.GetUnitsTargetFriendly(v128.GetCastingEnemy(v32.BlackoutBarrelDebuff)):ID())) then
						if (v24(v34.BlessingofFreedomFocus) or ((197 + 864) == (1422 + 435))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v159 = v128.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 28 + 12, 80 - 60);
				if (((4205 - (695 + 750)) > (4657 - 3293)) and v159) then
					return v159;
				end
				v158 = 1 - 0;
			end
			if ((v158 == (3 - 2)) or ((5253 - (285 + 66)) <= (8380 - 4785))) then
				if ((v32.BlessingofFreedom:IsReady() and v128.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((5162 - (682 + 628)) == (48 + 245))) then
					if (v24(v34.BlessingofFreedomFocus) or ((1858 - (176 + 123)) == (1920 + 2668))) then
						return "blessing_of_freedom combat";
					end
				end
				if (v43 or ((3253 + 1231) == (1057 - (239 + 30)))) then
					v159 = v135();
					if (((1242 + 3326) >= (3756 + 151)) and v159) then
						return v159;
					end
				end
				if (((2204 - 958) < (10826 - 7356)) and v47) then
					if (((4383 - (306 + 9)) >= (3391 - 2419)) and v15:DebuffUp(v32.Entangled) and v32.BlessingofFreedom:IsReady()) then
						if (((86 + 407) < (2389 + 1504)) and v24(v34.BlessingofFreedomPlayer)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v158 = 1 + 1;
			end
			if ((v158 == (11 - 7)) or ((2848 - (1140 + 235)) >= (2121 + 1211))) then
				v159 = v134();
				if (v159 or ((3715 + 336) <= (297 + 860))) then
					return v159;
				end
				v159 = v143();
				v158 = 57 - (33 + 19);
			end
			if (((219 + 385) < (8635 - 5754)) and (v158 == (2 + 1))) then
				if (v159 or ((1764 - 864) == (3167 + 210))) then
					return v159;
				end
				v159 = v140();
				if (((5148 - (586 + 103)) > (54 + 537)) and v159) then
					return v159;
				end
				v158 = 12 - 8;
			end
			if (((4886 - (1309 + 179)) >= (4323 - 1928)) and (v158 == (3 + 2))) then
				if (v159 or ((5862 - 3679) >= (2134 + 690))) then
					return v159;
				end
				if (((4113 - 2177) == (3857 - 1921)) and v128.TargetIsValid()) then
					v159 = v138();
					if (v159 or ((5441 - (295 + 314)) < (10593 - 6280))) then
						return v159;
					end
					v159 = v139();
					if (((6050 - (1300 + 662)) > (12164 - 8290)) and v159) then
						return v159;
					end
				end
				break;
			end
		end
	end
	local function v145()
		if (((6087 - (1178 + 577)) == (2250 + 2082)) and v43) then
			ShouldReturn = v135();
			if (((11821 - 7822) >= (4305 - (851 + 554))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if (v47 or ((2233 + 292) > (11270 - 7206))) then
			if (((9492 - 5121) == (4673 - (115 + 187))) and v15:DebuffUp(v32.Entangled) and v32.BlessingofFreedom:IsReady()) then
				if (v24(v34.BlessingofFreedomPlayer) or ((204 + 62) > (4721 + 265))) then
					return "blessing_of_freedom out of combat";
				end
			end
		end
		if (((7845 - 5854) >= (2086 - (160 + 1001))) and v119) then
			local v177 = 0 + 0;
			local v178;
			while true do
				if (((314 + 141) < (4202 - 2149)) and (v177 == (359 - (237 + 121)))) then
					v178 = v143();
					if (v178 or ((1723 - (525 + 372)) == (9196 - 4345))) then
						return v178;
					end
					break;
				end
				if (((601 - 418) == (325 - (96 + 46))) and ((777 - (643 + 134)) == v177)) then
					if (((419 + 740) <= (4287 - 2499)) and (v117 ~= "None")) then
						if ((v32.BeaconofLight:IsCastable() and (v128.NamedUnit(148 - 108, v117, 29 + 1) ~= nil) and v128.NamedUnit(78 - 38, v117, 61 - 31):BuffDown(v32.BeaconofLight)) or ((4226 - (316 + 403)) > (2871 + 1447))) then
							if (v24(v34.BeaconofLightMacro) or ((8454 - 5379) <= (1072 + 1893))) then
								return "beacon_of_light combat";
							end
						end
					end
					if (((3437 - 2072) <= (1426 + 585)) and (v118 ~= "None")) then
						if ((v32.BeaconofFaith:IsCastable() and (v128.NamedUnit(13 + 27, v118, 103 - 73) ~= nil) and v128.NamedUnit(191 - 151, v118, 62 - 32):BuffDown(v32.BeaconofFaith)) or ((159 + 2617) > (7037 - 3462))) then
							if (v24(v34.BeaconofFaithMacro) or ((125 + 2429) == (14133 - 9329))) then
								return "beacon_of_faith combat";
							end
						end
					end
					v177 = 18 - (12 + 5);
				end
			end
		end
		if (((10009 - 7432) == (5498 - 2921)) and v32.DevotionAura:IsCastable() and v15:BuffDown(v32.DevotionAura)) then
			if (v24(v32.DevotionAura) or ((12 - 6) >= (4684 - 2795))) then
				return "devotion_aura";
			end
		end
		if (((103 + 403) <= (3865 - (1656 + 317))) and v128.TargetIsValid()) then
			local v179 = 0 + 0;
			local v180;
			while true do
				if ((v179 == (0 + 0)) or ((5339 - 3331) > (10915 - 8697))) then
					v180 = v136();
					if (((733 - (5 + 349)) <= (19697 - 15550)) and v180) then
						return v180;
					end
					break;
				end
			end
		end
	end
	local function v146()
		local v160 = 1271 - (266 + 1005);
		while true do
			if ((v160 == (0 + 0)) or ((15402 - 10888) <= (1327 - 318))) then
				v35 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or "";
				v38 = EpicSettings.Settings['HealingPotionHP'] or (1696 - (561 + 1135));
				v160 = 1 - 0;
			end
			if ((v160 == (16 - 11)) or ((4562 - (507 + 559)) == (2990 - 1798))) then
				v59 = EpicSettings.Settings['UseHolyShockOffensively'];
				v60 = EpicSettings.Settings['UseHolyShockCycle'];
				v61 = EpicSettings.Settings['UseHolyShockGroup'] or (0 - 0);
				v62 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
				v160 = 394 - (212 + 176);
			end
			if ((v160 == (909 - (250 + 655))) or ((567 - 359) == (5169 - 2210))) then
				v55 = EpicSettings.Settings['UseHealthstone'];
				v56 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v57 = EpicSettings.Settings['UseAvengingWrathOffensively'];
				v58 = EpicSettings.Settings['UseDivineTollOffensively'];
				v160 = 1961 - (1869 + 87);
			end
			if (((14834 - 10557) >= (3214 - (484 + 1417))) and ((14 - 7) == v160)) then
				v67 = EpicSettings.Settings['UseDivineShield'];
				v68 = EpicSettings.Settings['DivineShieldHP'] or (0 - 0);
				v69 = EpicSettings.Settings['UseWordOfGlory'];
				v70 = EpicSettings.Settings['WordofGlorydHP'] or (773 - (48 + 725));
				v160 = 12 - 4;
			end
			if (((6940 - 4353) < (1845 + 1329)) and ((23 - 14) == v160)) then
				v75 = EpicSettings.Settings['AuraMasteryhHP'] or (0 + 0);
				v76 = EpicSettings.Settings['AuraMasteryGroup'] or (0 + 0);
				v77 = EpicSettings.Settings['UseBlessingOfSacrifice'];
				v78 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (853 - (152 + 701));
				v160 = 1321 - (430 + 881);
			end
			if ((v160 == (1 + 0)) or ((5015 - (557 + 338)) <= (650 + 1548))) then
				v39 = EpicSettings.Settings['UsePowerWordFortitude'];
				v40 = EpicSettings.Settings['UseAngelicFeather'];
				v41 = EpicSettings.Settings['UseBodyAndSoul'];
				v42 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
				v160 = 6 - 4;
			end
			if (((21 - 13) == v160) or ((3439 - 1843) == (1659 - (499 + 302)))) then
				v71 = EpicSettings.Settings['UseAvengingWrath'];
				v72 = EpicSettings.Settings['AvengingWrathHP'] or (866 - (39 + 827));
				v73 = EpicSettings.Settings['AvengingWrathGroup'] or (0 - 0);
				v74 = EpicSettings.Settings['UseAuraMastery'];
				v160 = 19 - 10;
			end
			if (((12789 - 9569) == (4943 - 1723)) and (v160 == (1 + 2))) then
				v47 = EpicSettings.Settings['HandleEntangling'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v160 = 1 + 3;
			end
			if (((15 - 5) == v160) or ((1506 - (103 + 1)) > (4174 - (475 + 79)))) then
				v79 = EpicSettings.Settings['UseHolyShock'];
				v80 = EpicSettings.Settings['HolyShockHP'] or (0 - 0);
				break;
			end
			if (((8236 - 5662) == (333 + 2241)) and (v160 == (2 + 0))) then
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v45 = EpicSettings.Settings['HandleCharredTreant'];
				v46 = EpicSettings.Settings['HandleCharredBrambles'];
				v160 = 1506 - (1395 + 108);
			end
			if (((5232 - 3434) < (3961 - (7 + 1197))) and (v160 == (3 + 3))) then
				v63 = EpicSettings.Settings['UseLayOnHands'];
				v64 = EpicSettings.Settings['LayOnHandsHP'] or (0 + 0);
				v65 = EpicSettings.Settings['UseDivineProtection'];
				v66 = EpicSettings.Settings['DivineProtectionHP'] or (319 - (27 + 292));
				v160 = 20 - 13;
			end
		end
	end
	local function v147()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (29 - 22)) or ((743 - 366) > (4958 - 2354))) then
				v115 = EpicSettings.Settings['UseBarrierOfFaith'];
				v116 = EpicSettings.Settings['BarrierOfFaithHP'] or (139 - (43 + 96));
				v117 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
				v118 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
				break;
			end
			if (((2316 - 1748) < (2059 - 1148)) and (v161 == (3 + 0))) then
				v95 = EpicSettings.Settings['DivineTollGroup'] or (0 + 0);
				v96 = EpicSettings.Settings['UseHolyPrism'];
				v97 = EpicSettings.Settings['UseHolyPrismOffensively'];
				v98 = EpicSettings.Settings['HolyPrismHP'] or (0 - 0);
				v99 = EpicSettings.Settings['LightsHammerUsage'] or "";
				v161 = 2 + 2;
			end
			if (((6156 - 2871) < (1332 + 2896)) and ((1 + 3) == v161)) then
				v100 = EpicSettings.Settings['LightsHammerHP'] or (1751 - (1414 + 337));
				v101 = EpicSettings.Settings['LightsHammerGroup'] or (1940 - (1642 + 298));
				v102 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
				v103 = EpicSettings.Settings['BlessingOfProtection'] or (0 - 0);
				v104 = EpicSettings.Settings['UseDaybreak'];
				v161 = 14 - 9;
			end
			if (((11620 - 7704) > (1096 + 2232)) and (v161 == (0 + 0))) then
				v81 = EpicSettings.Settings['UseFlashOfLight'];
				v82 = EpicSettings.Settings['FlashOfLightHP'] or (972 - (357 + 615));
				v83 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (0 + 0);
				v84 = EpicSettings.Settings['UseHolyLight'];
				v85 = EpicSettings.Settings['HolyLightHP'] or (0 - 0);
				v161 = 1 + 0;
			end
			if (((5357 - 2857) < (3071 + 768)) and (v161 == (1 + 1))) then
				v90 = EpicSettings.Settings['UseLightOfDawn'];
				v91 = EpicSettings.Settings['LightOfDawnhHP'] or (0 + 0);
				v92 = EpicSettings.Settings['LightOfDawnGroup'] or (1301 - (384 + 917));
				v93 = EpicSettings.Settings['UseDivineToll'];
				v94 = EpicSettings.Settings['DivineTollHP'] or (697 - (128 + 569));
				v161 = 1546 - (1407 + 136);
			end
			if (((2394 - (687 + 1200)) == (2217 - (556 + 1154))) and ((17 - 12) == v161)) then
				v105 = EpicSettings.Settings['DaybreakMana'] or (95 - (9 + 86));
				v106 = EpicSettings.Settings['DaybreakHP'] or (421 - (275 + 146));
				v107 = EpicSettings.Settings['DaybreakHGroup'] or (0 + 0);
				v108 = EpicSettings.Settings['DaybreakGroup'] or (64 - (29 + 35));
				v109 = EpicSettings.Settings['UseTyrsDeliverance'];
				v161 = 26 - 20;
			end
			if (((716 - 476) <= (13971 - 10806)) and (v161 == (4 + 2))) then
				v110 = EpicSettings.Settings['TyrsDeliveranceHP'] or (1012 - (53 + 959));
				v111 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (408 - (312 + 96));
				v112 = EpicSettings.Settings['UseHandOfDivinity'];
				v113 = EpicSettings.Settings['HandOfDivinityHP'] or (0 - 0);
				v114 = EpicSettings.Settings['HandOfDivinityGroup'] or (285 - (147 + 138));
				v161 = 906 - (813 + 86);
			end
			if (((754 + 80) >= (1491 - 686)) and (v161 == (493 - (18 + 474)))) then
				v69 = EpicSettings.Settings['UseWordOfGlory'];
				v86 = EpicSettings.Settings['WordOfGloryHP'] or (0 + 0);
				v87 = EpicSettings.Settings['UseBeaconOfVirtue'];
				v88 = EpicSettings.Settings['BeaconOfVirtueHP'] or (0 - 0);
				v89 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (1086 - (860 + 226));
				v161 = 305 - (121 + 182);
			end
		end
	end
	local function v148()
		local v162 = 0 + 0;
		while true do
			if ((v162 == (1241 - (988 + 252))) or ((431 + 3381) < (726 + 1590))) then
				v121 = EpicSettings.Toggles['dispel'];
				v122 = EpicSettings.Toggles['spread'];
				v123 = EpicSettings.Toggles['cycle'];
				v124 = EpicSettings.Toggles['lod'];
				v162 = 1972 - (49 + 1921);
			end
			if ((v162 == (890 - (223 + 667))) or ((2704 - (51 + 1)) <= (2638 - 1105))) then
				v146();
				v147();
				v119 = EpicSettings.Toggles['ooc'];
				v120 = EpicSettings.Toggles['cds'];
				v162 = 1 - 0;
			end
			if ((v162 == (1129 - (146 + 979))) or ((1016 + 2582) < (2065 - (311 + 294)))) then
				if (not v15:IsChanneling() or ((11478 - 7362) < (505 + 687))) then
					if (v119 or v15:AffectingCombat() or ((4820 - (496 + 947)) <= (2261 - (1233 + 125)))) then
						if (((1614 + 2362) >= (394 + 45)) and v15:AffectingCombat()) then
							local v233 = 0 + 0;
							local v234;
							while true do
								if (((5397 - (963 + 682)) == (3132 + 620)) and ((1504 - (504 + 1000)) == v233)) then
									v234 = v144();
									if (((2725 + 1321) > (2455 + 240)) and v234) then
										return v234;
									end
									break;
								end
							end
						else
							local v235 = 0 + 0;
							local v236;
							while true do
								if (((0 - 0) == v235) or ((3029 + 516) == (1860 + 1337))) then
									v236 = v145();
									if (((2576 - (156 + 26)) > (215 + 158)) and v236) then
										return v236;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if (((6500 - 2345) <= (4396 - (149 + 15))) and (v162 == (962 - (890 + 70)))) then
				if (v15:IsMounted() or ((3698 - (39 + 78)) == (3955 - (14 + 468)))) then
					return;
				end
				if (((10984 - 5989) > (9357 - 6009)) and v15:IsDeadOrGhost()) then
					return;
				end
				if (v45 or ((390 + 364) > (2237 + 1487))) then
					local v229 = 0 + 0;
					while true do
						if (((99 + 118) >= (15 + 42)) and (v229 == (3 - 1))) then
							ShouldReturn = v128.HandleCharredTreant(v32.FlashofLight, v34.FlashofLightMouseover, 40 + 0);
							if (ShouldReturn or ((7274 - 5204) >= (102 + 3935))) then
								return ShouldReturn;
							end
							v229 = 54 - (12 + 39);
						end
						if (((2517 + 188) == (8372 - 5667)) and (v229 == (0 - 0))) then
							ShouldReturn = v128.HandleCharredTreant(v32.HolyShock, v34.HolyShockMouseover, 12 + 28);
							if (((33 + 28) == (154 - 93)) and ShouldReturn) then
								return ShouldReturn;
							end
							v229 = 1 + 0;
						end
						if ((v229 == (4 - 3)) or ((2409 - (1596 + 114)) >= (3383 - 2087))) then
							ShouldReturn = v128.HandleCharredTreant(v32.WordofGlory, v34.WordofGloryMouseover, 753 - (164 + 549));
							if (ShouldReturn or ((3221 - (1059 + 379)) >= (4489 - 873))) then
								return ShouldReturn;
							end
							v229 = 2 + 0;
						end
						if ((v229 == (1 + 2)) or ((4305 - (145 + 247)) > (3715 + 812))) then
							ShouldReturn = v128.HandleCharredTreant(v32.HolyLight, v34.HolyLightMouseover, 19 + 21);
							if (((12973 - 8597) > (157 + 660)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((4188 + 673) > (1337 - 513)) and v46) then
					ShouldReturn = v128.HandleCharredBrambles(v32.HolyShock, v34.HolyShockMouseover, 760 - (254 + 466));
					if (ShouldReturn or ((1943 - (544 + 16)) >= (6772 - 4641))) then
						return ShouldReturn;
					end
					ShouldReturn = v128.HandleCharredBrambles(v32.WordofGlory, v34.WordofGloryMouseover, 668 - (294 + 334));
					if (ShouldReturn or ((2129 - (236 + 17)) >= (1096 + 1445))) then
						return ShouldReturn;
					end
					ShouldReturn = v128.HandleCharredBrambles(v32.FlashofLight, v34.FlashofLightMouseover, 32 + 8);
					if (((6711 - 4929) <= (17858 - 14086)) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v128.HandleCharredBrambles(v32.HolyLight, v34.HolyLightMouseover, 21 + 19);
					if (ShouldReturn or ((3871 + 829) < (1607 - (413 + 381)))) then
						return ShouldReturn;
					end
				end
				v162 = 1 + 2;
			end
			if (((6803 - 3604) < (10520 - 6470)) and (v162 == (1973 - (582 + 1388)))) then
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((8435 - 3484) < (3172 + 1258))) then
					local v230 = v128.DeadFriendlyUnitsCount();
					if (((460 - (326 + 38)) == (283 - 187)) and v15:AffectingCombat()) then
						if (v32.Intercession:IsCastable() or ((3909 - 1170) > (4628 - (47 + 573)))) then
							if (v24(v32.Intercession, nil, true) or ((9 + 14) == (4816 - 3682))) then
								return "intercession";
							end
						end
					elseif ((v230 > (1 - 0)) or ((4357 - (1269 + 395)) >= (4603 - (76 + 416)))) then
						if (v24(v32.Absolution, nil, true) or ((4759 - (319 + 124)) <= (4905 - 2759))) then
							return "absolution";
						end
					elseif (v24(v32.Redemption, not v17:IsInRange(1047 - (564 + 443)), true) or ((9816 - 6270) <= (3267 - (337 + 121)))) then
						return "redemption";
					end
				end
				if (((14368 - 9464) > (7214 - 5048)) and (v15:AffectingCombat() or (v43 and v121))) then
					local v231 = v43 and v32.Cleanse:IsReady();
					local v232 = v128.FocusUnit(v231, v34, 1931 - (1261 + 650));
					if (((47 + 62) >= (143 - 53)) and v232) then
						return v232;
					end
				end
				v126 = v15:GetEnemiesInMeleeRange(1825 - (772 + 1045));
				if (((703 + 4275) > (3049 - (102 + 42))) and AOE) then
					v127 = #v126;
				else
					v127 = 1845 - (1524 + 320);
				end
				v162 = 1274 - (1049 + 221);
			end
		end
	end
	local function v149()
		local v163 = 156 - (18 + 138);
		while true do
			if ((v163 == (0 - 0)) or ((4128 - (67 + 1035)) <= (2628 - (136 + 212)))) then
				v21.Print("Holy Paladin by Epic.");
				v128.DispellableDebuffs = v128.DispellableMagicDebuffs;
				v163 = 4 - 3;
			end
			if ((v163 == (1 + 0)) or ((1524 + 129) <= (2712 - (240 + 1364)))) then
				v128.DispellableDebuffs = v12.MergeTable(v128.DispellableDebuffs, v128.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v21.SetAPL(1147 - (1050 + 32), v148, v149);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

