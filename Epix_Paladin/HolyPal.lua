local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2117 - (410 + 658)) <= (1573 - (89 + 578)))) then
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
			if (((9381 - 4868) > (3775 - (572 + 477))) and (v149 == (0 + 0))) then
				for v219 = 1 + 0, 1 + 3 do
					local v220 = 86 - (84 + 2);
					local v221;
					local v222;
					local v223;
					local v224;
					while true do
						if ((v220 == (0 - 0)) or ((1067 + 414) >= (3500 - (497 + 345)))) then
							v221, v222, v223, v224 = v28(v219);
							if ((v222 == v30.Consecration:Name()) or ((83 + 3137) == (231 + 1133))) then
								return (v26(((v223 + v224) - v29()) + (1333.5 - (605 + 728)))) or (0 + 0);
							end
							break;
						end
					end
				end
				return 0 - 0;
			end
		end
	end
	local function v129(v150)
		return v150:DebuffRefreshable(v30.GlimmerofLightBuff) or not v60;
	end
	local function v130()
		if ((v30.BlessingofSummer:IsCastable() and v14:IsInParty() and not v14:IsInRaid()) or ((49 + 1005) > (12540 - 9148))) then
			if ((v13 and v13:Exists() and (v126.UnitGroupRole(v13) == "DAMAGER")) or ((610 + 66) >= (4549 - 2907))) then
				if (((3123 + 1013) > (2886 - (457 + 32))) and v23(v32.BlessingofSummerFocus)) then
					return "blessing_of_summer";
				end
			end
		end
		local v151 = {v30.BlessingofSpring,v30.BlessingofSummer,v30.BlessingofAutumn,v30.BlessingofWinter};
		for v191, v192 in pairs(v151) do
			if (v192:IsCastable() or ((15336 - 11002) == (2045 + 2200))) then
				if (v23(v32.BlessingofSummerPlayer) or ((5072 - (588 + 208)) <= (8169 - 5138))) then
					return "blessing_of_the_seasons";
				end
			end
		end
	end
	local function v131()
		local v152 = 1800 - (884 + 916);
		while true do
			if ((v152 == (1 - 0)) or ((2773 + 2009) <= (1852 - (232 + 421)))) then
				ShouldReturn = v126.HandleBottomTrinket(v123, v118, 1929 - (1569 + 320), nil);
				if (ShouldReturn or ((1194 + 3670) < (362 + 1540))) then
					return ShouldReturn;
				end
				break;
			end
			if (((16306 - 11467) >= (4305 - (316 + 289))) and (v152 == (0 - 0))) then
				ShouldReturn = v126.HandleTopTrinket(v123, v118, 2 + 38, nil);
				if (ShouldReturn or ((2528 - (666 + 787)) > (2343 - (360 + 65)))) then
					return ShouldReturn;
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v132()
		if (((650 - (79 + 175)) <= (5997 - 2193)) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v193 = 0 + 0;
			local v194;
			while true do
				if ((v193 == (2 - 1)) or ((8028 - 3859) == (3086 - (503 + 396)))) then
					v194 = v126.InterruptWithStun(v30.HammerofJustice, 189 - (92 + 89));
					if (((2726 - 1320) == (722 + 684)) and v194) then
						return v194;
					end
					break;
				end
				if (((907 + 624) < (16725 - 12454)) and (v193 == (0 + 0))) then
					v194 = v126.Interrupt(v30.Rebuke, 11 - 6, true);
					if (((555 + 80) == (304 + 331)) and v194) then
						return v194;
					end
					v193 = 2 - 1;
				end
			end
		end
	end
	local function v133()
		local v153 = 0 + 0;
		while true do
			if (((5143 - 1770) <= (4800 - (485 + 759))) and (v153 == (0 - 0))) then
				if (not v13 or not v13:Exists() or not v13:IsInRange(1229 - (442 + 747)) or not v126.DispellableFriendlyUnit() or ((4426 - (832 + 303)) < (4226 - (88 + 858)))) then
					return;
				end
				if (((1337 + 3049) >= (723 + 150)) and v30.Cleanse:IsReady()) then
					if (((38 + 883) <= (1891 - (766 + 23))) and v23(v32.CleanseFocus)) then
						return "cleanse dispel";
					end
				end
				break;
			end
		end
	end
	local function v134()
		local v154 = 0 - 0;
		while true do
			if (((6435 - 1729) >= (2537 - 1574)) and ((0 - 0) == v154)) then
				if ((v30.Consecration:IsCastable() and v16:IsInMeleeRange(1078 - (1036 + 37))) or ((681 + 279) <= (1705 - 829))) then
					if (v23(v30.Consecration) or ((1626 + 440) == (2412 - (641 + 839)))) then
						return "consecrate precombat 4";
					end
				end
				if (((5738 - (910 + 3)) < (12346 - 7503)) and v30.Judgment:IsReady()) then
					if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((5561 - (1466 + 218)) >= (2086 + 2451))) then
						return "judgment precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v135()
		if (((v14:HealthPercentage() <= v62) and v61 and v30.LayonHands:IsCastable()) or ((5463 - (556 + 592)) < (614 + 1112))) then
			if (v23(v32.LayonHandsPlayer) or ((4487 - (329 + 479)) < (1479 - (174 + 680)))) then
				return "lay_on_hands defensive";
			end
		end
		if ((v30.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v66) and v65) or ((15892 - 11267) < (1309 - 677))) then
			if (v23(v30.DivineProtection) or ((60 + 23) > (2519 - (396 + 343)))) then
				return "divine protection";
			end
		end
		if (((49 + 497) <= (2554 - (29 + 1448))) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (1392 - (135 + 1254))) and (v14:HealthPercentage() <= v84) and v67 and not v14:HealingAbsorbed()) then
			if (v23(v32.WordofGloryPlayer) or ((3752 - 2756) > (20081 - 15780))) then
				return "WOG self";
			end
		end
		if (((2713 + 1357) > (2214 - (389 + 1138))) and v31.Healthstone:IsReady() and v53 and (v14:HealthPercentage() <= v54)) then
			if (v23(v32.Healthstone, nil, nil, true) or ((1230 - (102 + 472)) >= (3143 + 187))) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v14:HealthPercentage() <= v36)) or ((1382 + 1110) <= (313 + 22))) then
			if (((5867 - (320 + 1225)) >= (4560 - 1998)) and (v35 == "Refreshing Healing Potion")) then
				if (v31.RefreshingHealingPotion:IsReady() or ((2226 + 1411) >= (5234 - (157 + 1307)))) then
					if (v23(v32.RefreshingHealingPotion, nil, nil, true) or ((4238 - (821 + 1038)) > (11422 - 6844))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v136()
		local v155 = 0 + 0;
		local v156;
		while true do
			if ((v155 == (3 - 1)) or ((180 + 303) > (1841 - 1098))) then
				if (((3480 - (834 + 192)) > (37 + 541)) and v30.HolyAvenger:IsCastable()) then
					if (((239 + 691) < (96 + 4362)) and v23(v30.HolyAvenger)) then
						return "holy_avenger cooldowns 16";
					end
				end
				v156 = v126.HandleTopTrinket(v123, v118, 61 - 21, nil);
				if (((966 - (300 + 4)) <= (260 + 712)) and v156) then
					return v156;
				end
				v155 = 7 - 4;
			end
			if (((4732 - (112 + 250)) == (1743 + 2627)) and (v155 == (2 - 1))) then
				if ((v56 and v118 and v30.DivineToll:IsCastable() and v14:BuffUp(v30.AvengingWrathBuff)) or ((2729 + 2033) <= (446 + 415))) then
					if (v23(v30.DivineToll) or ((1057 + 355) == (2115 + 2149))) then
						return "divine_toll cooldowns 8";
					end
				end
				if (v30.BloodFury:IsCastable() or ((2354 + 814) < (3567 - (1001 + 413)))) then
					if (v23(v30.BloodFury) or ((11096 - 6120) < (2214 - (244 + 638)))) then
						return "blood_fury cooldowns 12";
					end
				end
				if (((5321 - (627 + 66)) == (13789 - 9161)) and v30.Berserking:IsCastable()) then
					if (v23(v30.Berserking) or ((656 - (512 + 90)) == (2301 - (1665 + 241)))) then
						return "berserking cooldowns 14";
					end
				end
				v155 = 719 - (373 + 344);
			end
			if (((37 + 45) == (22 + 60)) and (v155 == (7 - 4))) then
				v156 = v126.HandleBottomTrinket(v123, v118, 67 - 27, nil);
				if (v156 or ((1680 - (35 + 1064)) < (206 + 76))) then
					return v156;
				end
				if (v30.Seraphim:IsReady() or ((9860 - 5251) < (10 + 2485))) then
					if (((2388 - (298 + 938)) == (2411 - (233 + 1026))) and v23(v30.Seraphim)) then
						return "seraphim cooldowns 18";
					end
				end
				break;
			end
			if (((3562 - (636 + 1030)) <= (1750 + 1672)) and (v155 == (0 + 0))) then
				if ((v55 and v118 and v30.AvengingWrath:IsReady() and not v14:BuffUp(v30.AvengingWrathBuff)) or ((295 + 695) > (110 + 1510))) then
					if (v23(v30.AvengingWrath) or ((1098 - (55 + 166)) > (910 + 3785))) then
						return "avenging_wrath cooldowns 4";
					end
				end
				v156 = v130();
				if (((271 + 2420) >= (7069 - 5218)) and v156) then
					return v156;
				end
				v155 = 298 - (36 + 261);
			end
		end
	end
	local function v137()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (1368 - (34 + 1334))) or ((1148 + 1837) >= (3774 + 1082))) then
				if (((5559 - (1035 + 248)) >= (1216 - (20 + 1))) and v118) then
					local v225 = 0 + 0;
					local v226;
					while true do
						if (((3551 - (134 + 185)) <= (5823 - (549 + 584))) and (v225 == (685 - (314 + 371)))) then
							v226 = v136();
							if (v226 or ((3075 - 2179) >= (4114 - (478 + 490)))) then
								return v226;
							end
							break;
						end
					end
				end
				if (((1622 + 1439) >= (4130 - (786 + 386))) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:BuffUp(v30.AvengingWrathBuff) or v14:BuffUp(v30.HolyAvenger) or not v30.Awakening:IsAvailable())) then
					if (((10322 - 7135) >= (2023 - (1055 + 324))) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(1345 - (1093 + 247)))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((573 + 71) <= (75 + 629)) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:HolyPower() >= (11 - 8)) and (v126.HealthPercentage > v68) and (v126.FriendlyUnitsBelowHealthPercentageCount(v89) < v90)) then
					if (((3251 - 2293) > (2694 - 1747)) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(12 - 7))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((1598 + 2894) >= (10224 - 7570)) and v30.HammerofWrath:IsReady() and (v14:HolyPower() < (17 - 12)) and (v125 == (2 + 0))) then
					if (((8802 - 5360) >= (2191 - (364 + 324))) and v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath))) then
						return "hammer_of_wrath priority 4";
					end
				end
				v157 = 2 - 1;
			end
			if ((v157 == (11 - 6)) or ((1051 + 2119) <= (6125 - 4661))) then
				if (v30.Consecration:IsReady() or ((7681 - 2884) == (13326 - 8938))) then
					if (((1819 - (1249 + 19)) <= (615 + 66)) and v23(v30.Consecration, not v16:IsInMeleeRange(19 - 14))) then
						return "consecration priority 36";
					end
				end
				break;
			end
			if (((4363 - (686 + 400)) > (320 + 87)) and ((233 - (73 + 156)) == v157)) then
				if (((23 + 4672) >= (2226 - (721 + 90))) and v30.HolyPrism:IsReady() and v95) then
					if (v23(v30.HolyPrism, not v16:IsSpellInRange(v30.HolyPrism)) or ((37 + 3175) <= (3064 - 2120))) then
						return "holy_prism priority 28";
					end
				end
				if (v30.ArcaneTorrent:IsCastable() or ((3566 - (224 + 246)) <= (2912 - 1114))) then
					if (((6512 - 2975) == (642 + 2895)) and v23(v30.ArcaneTorrent)) then
						return "arcane_torrent priority 30";
					end
				end
				if (((92 + 3745) >= (1154 + 416)) and v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (5 - 2)) and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (6 - 4)))) then
					if (v23(v30.LightofDawn, not v16:IsSpellInRange(v30.LightofDawn)) or ((3463 - (203 + 310)) == (5805 - (1238 + 755)))) then
						return "light_of_dawn priority 32";
					end
				end
				if (((330 + 4393) >= (3852 - (709 + 825))) and v30.CrusaderStrike:IsReady()) then
					if (v23(v30.CrusaderStrike, not v16:IsInMeleeRange(8 - 3)) or ((2952 - 925) > (3716 - (196 + 668)))) then
						return "crusader_strike priority 34";
					end
				end
				v157 = 19 - 14;
			end
			if ((v157 == (5 - 2)) or ((1969 - (171 + 662)) > (4410 - (4 + 89)))) then
				if (((16641 - 11893) == (1729 + 3019)) and v57 and v30.HolyShock:IsReady() and v16:DebuffDown(v30.GlimmerofLightBuff) and (not v30.GlimmerofLight:IsAvailable() or v129(v16))) then
					if (((16409 - 12673) <= (1859 + 2881)) and v23(v30.HolyShock, not v16:IsSpellInRange(v30.HolyShock))) then
						return "holy_shock damage";
					end
				end
				if ((v57 and v58 and v30.HolyShock:IsReady() and (v126.EnemiesWithDebuffCount(v30.GlimmerofLightBuff, 1526 - (35 + 1451)) < v59) and v121) or ((4843 - (28 + 1425)) <= (5053 - (941 + 1052)))) then
					if (v126.CastCycle(v30.HolyShock, v124, v129, not v16:IsSpellInRange(v30.HolyShock), nil, nil, v32.HolyShockMouseover) or ((958 + 41) > (4207 - (822 + 692)))) then
						return "holy_shock_cycle damage";
					end
				end
				if (((660 - 197) < (284 + 317)) and v30.CrusaderStrike:IsReady() and (v30.CrusaderStrike:Charges() == (299 - (45 + 252)))) then
					if (v23(v30.CrusaderStrike, not v16:IsInMeleeRange(5 + 0)) or ((752 + 1431) < (1671 - 984))) then
						return "crusader_strike priority 24";
					end
				end
				if (((4982 - (114 + 319)) == (6530 - 1981)) and v30.HolyPrism:IsReady() and (v125 >= (2 - 0)) and v95) then
					if (((2979 + 1693) == (6959 - 2287)) and v23(v32.HolyPrismPlayer)) then
						return "holy_prism on self priority 26";
					end
				end
				v157 = 8 - 4;
			end
			if (((1965 - (556 + 1407)) == v157) or ((4874 - (741 + 465)) < (860 - (170 + 295)))) then
				if (v30.HammerofWrath:IsReady() or ((2196 + 1970) == (418 + 37))) then
					if (v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath)) or ((10953 - 6504) == (2208 + 455))) then
						return "hammer_of_wrath priority 14";
					end
				end
				if (v30.Judgment:IsReady() or ((2743 + 1534) < (1693 + 1296))) then
					if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((2100 - (957 + 273)) >= (1110 + 3039))) then
						return "judgment priority 16";
					end
				end
				if (((886 + 1326) < (12128 - 8945)) and (LightsHammer == "Player")) then
					if (((12243 - 7597) > (9138 - 6146)) and v30.LightsHammer:IsCastable()) then
						if (((7100 - 5666) < (4886 - (389 + 1391))) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(6 + 2))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((82 + 704) < (6882 - 3859)) and (LightsHammer == "Cursor")) then
					if (v30.LightsHammer:IsCastable() or ((3393 - (783 + 168)) < (248 - 174))) then
						if (((4461 + 74) == (4846 - (309 + 2))) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammer == "Enemy Under Cursor") or ((9240 - 6231) <= (3317 - (1090 + 122)))) then
					if (((594 + 1236) < (12322 - 8653)) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
						if (v23(v32.LightsHammercursor) or ((979 + 451) >= (4730 - (628 + 490)))) then
							return "lights_hammer priority 6";
						end
					end
				end
				if (((482 + 2201) >= (6090 - 3630)) and v30.Consecration:IsCastable() and (v128() <= (0 - 0))) then
					if (v23(v30.Consecration, not v16:IsInMeleeRange(779 - (431 + 343))) or ((3643 - 1839) >= (9474 - 6199))) then
						return "consecration priority 20";
					end
				end
				v157 = 3 + 0;
			end
			if ((v157 == (1 + 0)) or ((3112 - (556 + 1139)) > (3644 - (6 + 9)))) then
				if (((878 + 3917) > (206 + 196)) and (LightsHammerLightsHammerUsage == "Player")) then
					if (((4982 - (28 + 141)) > (1381 + 2184)) and v30.LightsHammer:IsCastable() and (v125 >= (2 - 0))) then
						if (((2771 + 1141) == (5229 - (486 + 831))) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(20 - 12))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((9931 - 7110) <= (912 + 3912)) and (LightsHammerLightsHammerUsage == "Cursor")) then
					if (((5495 - 3757) <= (3458 - (668 + 595))) and v30.LightsHammer:IsCastable()) then
						if (((37 + 4) <= (609 + 2409)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((5849 - 3704) <= (4394 - (23 + 267))) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
					if (((4633 - (1129 + 815)) < (5232 - (371 + 16))) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
						if (v23(v32.LightsHammercursor) or ((4072 - (1326 + 424)) > (4965 - 2343))) then
							return "lights_hammer priority 6";
						end
					end
				end
				if ((v30.Consecration:IsCastable() and (v125 >= (7 - 5)) and (v128() <= (118 - (88 + 30)))) or ((5305 - (720 + 51)) == (4631 - 2549))) then
					if (v23(v30.Consecration, not v16:IsInMeleeRange(1781 - (421 + 1355))) or ((2591 - 1020) > (918 + 949))) then
						return "consecration priority 8";
					end
				end
				if ((v30.LightofDawn:IsReady() and v122 and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or ((v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (1085 - (286 + 797))) and ((v14:HolyPower() >= (18 - 13)) or (v14:BuffUp(v30.HolyAvenger) and (v14:HolyPower() >= (4 - 1))))))) or ((3093 - (397 + 42)) >= (936 + 2060))) then
					if (((4778 - (24 + 776)) > (3240 - 1136)) and v23(v30.LightofDawn)) then
						return "light_of_dawn priority 10";
					end
				end
				if (((3780 - (222 + 563)) > (3395 - 1854)) and v30.ShieldoftheRighteousHoly:IsReady() and (v125 > (3 + 0))) then
					if (((3439 - (23 + 167)) > (2751 - (690 + 1108))) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(2 + 3))) then
						return "shield_of_the_righteous priority 12";
					end
				end
				v157 = 2 + 0;
			end
		end
	end
	local function v138()
		if (not v13 or not v13:Exists() or not v13:IsInRange(888 - (40 + 808)) or ((539 + 2734) > (17486 - 12913))) then
			return;
		end
		if ((v30.LayonHands:IsCastable() and (v13:HealthPercentage() <= v62) and v61) or ((3012 + 139) < (680 + 604))) then
			if (v23(v32.LayonHandsFocus) or ((1015 + 835) == (2100 - (47 + 524)))) then
				return "lay_on_hands cooldown_healing";
			end
		end
		if (((533 + 288) < (5803 - 3680)) and (v100 == "Not Tank")) then
			if (((1348 - 446) < (5302 - 2977)) and v30.BlessingofProtection:IsCastable() and (v13:HealthPercentage() <= v101) and (not v126.UnitGroupRole(v13) == "TANK")) then
				if (((2584 - (1165 + 561)) <= (88 + 2874)) and v23(v32.BlessingofProtectionFocus)) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		elseif ((v100 == "Player") or ((12221 - 8275) < (492 + 796))) then
			if ((v30.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v101)) or ((3721 - (341 + 138)) == (154 + 413))) then
				if (v23(v32.BlessingofProtectionplayer) or ((1747 - 900) >= (1589 - (89 + 237)))) then
					return "blessing_of_protection cooldown_healing";
				end
			end
		end
		if ((v30.AuraMastery:IsCastable() and v126.AreUnitsBelowHealthPercentage(v73, v74) and v72) or ((7247 - 4994) == (3896 - 2045))) then
			if (v23(v30.AuraMastery) or ((2968 - (581 + 300)) > (3592 - (855 + 365)))) then
				return "aura_mastery cooldown_healing";
			end
		end
		if ((v30.AvengingWrath:IsCastable() and not v14:BuffUp(v30.AvengingWrathBuff) and v126.AreUnitsBelowHealthPercentage(v70, v71) and v69) or ((10557 - 6112) < (1355 + 2794))) then
			if (v23(v30.AvengingWrath) or ((3053 - (1030 + 205)) == (80 + 5))) then
				return "avenging_wrath cooldown_healing";
			end
		end
		if (((587 + 43) < (2413 - (156 + 130))) and v30.TyrsDeliverance:IsCastable() and v107 and v126.AreUnitsBelowHealthPercentage(v108, v109)) then
			if (v23(v30.TyrsDeliverance) or ((4403 - 2465) == (4236 - 1722))) then
				return "tyrs_deliverance cooldown_healing";
			end
		end
		if (((8714 - 4459) >= (15 + 40)) and v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) then
			if (((1749 + 1250) > (1225 - (10 + 59))) and v23(v32.BeaconofVirtueFocus)) then
				return "beacon_of_virtue cooldown_healing";
			end
		end
		if (((665 + 1685) > (5688 - 4533)) and v30.Daybreak:IsReady() and (v126.FriendlyUnitsWithBuffCount(v30.GlimmerofLightBuff, false, false) > v106) and (v126.AreUnitsBelowHealthPercentage(v104, v105) or (v14:ManaPercentage() <= v103)) and v102) then
			if (((5192 - (671 + 492)) <= (3864 + 989)) and v23(v30.Daybreak)) then
				return "daybreak cooldown_healing";
			end
		end
		if ((v30.HandofDivinity:IsReady() and v126.AreUnitsBelowHealthPercentage(v111, v112) and v110) or ((1731 - (369 + 846)) > (910 + 2524))) then
			if (((3453 + 593) >= (4978 - (1036 + 909))) and v23(v30.HandofDivinity)) then
				return "divine_toll cooldown_healing";
			end
		end
		if ((v30.DivineToll:IsReady() and v126.AreUnitsBelowHealthPercentage(v92, v93) and v91) or ((2162 + 557) <= (2428 - 981))) then
			if (v23(v32.DivineTollFocus) or ((4337 - (11 + 192)) < (1985 + 1941))) then
				return "divine_toll cooldown_healing";
			end
		end
		if ((v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) or ((339 - (135 + 40)) >= (6747 - 3962))) then
			if (v23(v32.HolyShockFocus) or ((317 + 208) == (4645 - 2536))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((49 - 16) == (209 - (50 + 126))) and v30.BlessingofSacrifice:IsReady() and (v13:GUID() ~= v14:GUID()) and (v13:HealthPercentage() <= v76) and v75) then
			if (((8503 - 5449) <= (889 + 3126)) and v23(v32.BlessingofSacrificeFocus)) then
				return "blessing_of_sacrifice cooldown_healing";
			end
		end
	end
	local function v139()
		if (((3284 - (1233 + 180)) < (4351 - (522 + 447))) and v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) then
			if (((2714 - (107 + 1314)) <= (1006 + 1160)) and v23(v32.BeaconofVirtueFocus)) then
				return "beacon_of_virtue aoe_healing";
			end
		end
		if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (8 - 5)) and v14:BuffUp(v30.EmpyreanLegacyBuff) and (((v13:HealthPercentage() <= v84) and v67) or v126.AreUnitsBelowHealthPercentage(v89, v90))) or ((1096 + 1483) < (244 - 121))) then
			if (v23(v32.WordofGloryFocus) or ((3347 - 2501) >= (4278 - (716 + 1194)))) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (1 + 2)) and v14:BuffUp(v30.UnendingLightBuff) and (v13:HealthPercentage() <= v84) and v67) or ((430 + 3582) <= (3861 - (74 + 429)))) then
			if (((2881 - 1387) <= (1490 + 1515)) and v23(v32.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (6 - 3)) and (v126.AreUnitsBelowHealthPercentage(v89, v90) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (2 + 0)))) or ((9590 - 6479) == (5276 - 3142))) then
			if (((2788 - (279 + 154)) == (3133 - (454 + 324))) and v23(v30.LightofDawn)) then
				return "light_of_dawn aoe_healing";
			end
		end
		if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (3 + 0)) and (v13:HealthPercentage() <= v84) and UseWodOfGlory and (v126.FriendlyUnitsBelowHealthPercentageCount(v84) < (20 - (12 + 5)))) or ((318 + 270) <= (1100 - 668))) then
			if (((1773 + 3024) >= (4988 - (277 + 816))) and v23(v32.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if (((15284 - 11707) == (4760 - (1058 + 125))) and v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
			if (((712 + 3082) > (4668 - (815 + 160))) and v23(v32.LightoftheMartyrFocus)) then
				return "holy_shock cooldown_healing";
			end
		end
		if (v126.TargetIsValid() or ((5470 - 4195) == (9732 - 5632))) then
			local v195 = 0 + 0;
			while true do
				if ((v195 == (2 - 1)) or ((3489 - (41 + 1857)) >= (5473 - (1222 + 671)))) then
					if (((2540 - 1557) <= (2598 - 790)) and v126.AreUnitsBelowHealthPercentage(v98, v99)) then
						if ((LightsHammerLightsHammerUsage == "Player") or ((3332 - (229 + 953)) <= (2971 - (1111 + 663)))) then
							if (((5348 - (874 + 705)) >= (165 + 1008)) and v30.LightsHammer:IsCastable()) then
								if (((1014 + 471) == (3086 - 1601)) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(1 + 7))) then
									return "lights_hammer priority 6";
								end
							end
						elseif ((LightsHammerLightsHammerUsage == "Cursor") or ((3994 - (642 + 37)) <= (635 + 2147))) then
							if (v30.LightsHammer:IsCastable() or ((141 + 735) >= (7441 - 4477))) then
								if (v23(v32.LightsHammercursor) or ((2686 - (233 + 221)) > (5773 - 3276))) then
									return "lights_hammer priority 6";
								end
							end
						elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((1858 + 252) <= (1873 - (718 + 823)))) then
							if (((2320 + 1366) > (3977 - (266 + 539))) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
								if (v23(v32.LightsHammercursor) or ((12666 - 8192) < (2045 - (636 + 589)))) then
									return "lights_hammer priority 6";
								end
							end
						end
					end
					break;
				end
				if (((10156 - 5877) >= (5943 - 3061)) and (v195 == (0 + 0))) then
					if ((v30.Consecration:IsCastable() and v30.GoldenPath:IsAvailable() and (v128() <= (0 + 0))) or ((3044 - (657 + 358)) >= (9322 - 5801))) then
						if (v23(v30.Consecration, not v16:IsInMeleeRange(11 - 6)) or ((3224 - (1151 + 36)) >= (4483 + 159))) then
							return "consecration aoe_healing";
						end
					end
					if (((453 + 1267) < (13313 - 8855)) and v30.Judgment:IsReady() and v30.JudgmentofLight:IsAvailable() and v16:DebuffDown(v30.JudgmentofLightDebuff)) then
						if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((2268 - (1552 + 280)) > (3855 - (64 + 770)))) then
							return "judgment aoe_healing";
						end
					end
					v195 = 1 + 0;
				end
			end
		end
	end
	local function v140()
		if (((1618 - 905) <= (151 + 696)) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (1246 - (157 + 1086))) and (v13:HealthPercentage() <= v84) and v67) then
			if (((4311 - 2157) <= (17654 - 13623)) and v23(v32.WordofGloryFocus)) then
				return "word_of_glory st_healing";
			end
		end
		if (((7078 - 2463) == (6298 - 1683)) and v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) then
			if (v23(v32.HolyShockFocus) or ((4609 - (599 + 220)) == (995 - 495))) then
				return "holy_shock st_healing";
			end
		end
		if (((2020 - (1813 + 118)) < (162 + 59)) and v30.DivineFavor:IsReady() and (v13:HealthPercentage() <= v83) and v82) then
			if (((3271 - (841 + 376)) >= (1990 - 569)) and v23(v30.DivineFavor)) then
				return "divine_favor st_healing";
			end
		end
		if (((161 + 531) < (8346 - 5288)) and v30.FlashofLight:IsCastable() and (v13:HealthPercentage() <= v80) and v79) then
			if (v23(v32.FlashofLightFocus, nil, true) or ((4113 - (464 + 395)) == (4247 - 2592))) then
				return "flash_of_light st_healing";
			end
		end
		if ((v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) or ((623 + 673) == (5747 - (467 + 370)))) then
			if (((6959 - 3591) == (2473 + 895)) and v23(v32.LightoftheMartyrFocus)) then
				return "holy_shock cooldown_healing";
			end
		end
		if (((9060 - 6417) < (596 + 3219)) and v30.BarrierofFaith:IsCastable() and (v13:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) then
			if (((4450 - 2537) > (1013 - (150 + 370))) and v23(v32.BarrierofFaith, nil, true)) then
				return "barrier_of_faith st_healing";
			end
		end
		if (((6037 - (74 + 1208)) > (8431 - 5003)) and v30.FlashofLight:IsCastable() and v14:BuffUp(v30.InfusionofLightBuff) and (v13:HealthPercentage() <= v81) and v79) then
			if (((6549 - 5168) <= (1686 + 683)) and v23(v32.FlashofLightFocus, nil, true)) then
				return "flash_of_light st_healing";
			end
		end
		if ((v30.HolyPrism:IsReady() and (v13:HealthPercentage() <= v96) and v94) or ((5233 - (14 + 376)) == (7083 - 2999))) then
			if (((3022 + 1647) > (319 + 44)) and v23(v32.HolyPrismPlayer)) then
				return "holy_prism on self priority 26";
			end
		end
		if ((v30.HolyLight:IsCastable() and (v13:HealthPercentage() <= v83) and v82) or ((1791 + 86) >= (9194 - 6056))) then
			if (((3568 + 1174) >= (3704 - (23 + 55))) and v23(v32.HolyLightFocus, nil, true)) then
				return "holy_light st_healing";
			end
		end
		if (v126.AreUnitsBelowHealthPercentage(v98, v99) or ((10759 - 6219) == (612 + 304))) then
			if ((v97 == "Player") or ((1039 + 117) > (6736 - 2391))) then
				if (((704 + 1533) < (5150 - (652 + 249))) and v30.LightsHammer:IsCastable()) then
					if (v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(21 - 13)) or ((4551 - (708 + 1160)) < (62 - 39))) then
						return "lights_hammer priority 6";
					end
				end
			elseif (((1270 - 573) <= (853 - (10 + 17))) and (v97 == "Cursor")) then
				if (((249 + 856) <= (2908 - (1400 + 332))) and v30.LightsHammer:IsCastable()) then
					if (((6480 - 3101) <= (5720 - (242 + 1666))) and v23(v32.LightsHammercursor)) then
						return "lights_hammer priority 6";
					end
				end
			elseif ((v97 == "Enemy Under Cursor") or ((338 + 450) >= (593 + 1023))) then
				if (((1581 + 273) <= (4319 - (850 + 90))) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
					if (((7966 - 3417) == (5939 - (360 + 1030))) and v23(v32.LightsHammercursor)) then
						return "lights_hammer priority 6";
					end
				end
			end
		end
	end
	local function v141()
		local v158 = 0 + 0;
		local v159;
		while true do
			if ((v158 == (0 - 0)) or ((4157 - 1135) >= (4685 - (909 + 752)))) then
				if (((6043 - (109 + 1114)) > (4024 - 1826)) and (not v13 or not v13:Exists() or not v13:IsInRange(16 + 24))) then
					return;
				end
				v159 = v139();
				v158 = 243 - (6 + 236);
			end
			if ((v158 == (2 + 0)) or ((855 + 206) >= (11534 - 6643))) then
				if (((2381 - 1017) <= (5606 - (1076 + 57))) and v159) then
					return v159;
				end
				break;
			end
			if ((v158 == (1 + 0)) or ((4284 - (579 + 110)) <= (1 + 2))) then
				if (v159 or ((4131 + 541) == (2045 + 1807))) then
					return v159;
				end
				v159 = v140();
				v158 = 409 - (174 + 233);
			end
		end
	end
	local function v142()
		if (((4354 - 2795) == (2735 - 1176)) and v126.GetCastingEnemy(v30.BlackoutBarrelDebuff) and v30.BlessingofFreedom:IsReady()) then
			local v196 = 0 + 0;
			local v197;
			while true do
				if ((v196 == (1174 - (663 + 511))) or ((1563 + 189) <= (172 + 616))) then
					v197 = v126.FocusSpecifiedUnit(v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)), 123 - 83);
					if (v197 or ((2366 + 1541) == (416 - 239))) then
						return v197;
					end
					v196 = 2 - 1;
				end
				if (((1656 + 1814) > (1080 - 525)) and ((1 + 0) == v196)) then
					if ((v13 and UnitIsUnit(v13:ID(), v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)):ID())) or ((89 + 883) == (1367 - (478 + 244)))) then
						if (((3699 - (440 + 77)) >= (962 + 1153)) and v23(v32.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		local v160 = v126.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 146 - 106, 1576 - (655 + 901));
		if (((722 + 3171) < (3391 + 1038)) and v160) then
			return v160;
		end
		if ((v30.BlessingofFreedom:IsReady() and v126.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((1936 + 931) < (7674 - 5769))) then
			if (v23(v32.BlessingofFreedomFocus) or ((3241 - (695 + 750)) >= (13832 - 9781))) then
				return "blessing_of_freedom combat";
			end
		end
		if (((2497 - 878) <= (15105 - 11349)) and v41) then
			v160 = v133();
			if (((955 - (285 + 66)) == (1407 - 803)) and v160) then
				return v160;
			end
		end
		if (v45 or ((5794 - (682 + 628)) == (146 + 754))) then
			if ((v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) or ((4758 - (176 + 123)) <= (466 + 647))) then
				if (((2635 + 997) > (3667 - (239 + 30))) and v23(v32.BlessingofFreedomPlayer)) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((1110 + 2972) <= (4726 + 191)) and (v115 ~= "None")) then
			if (((8551 - 3719) >= (4323 - 2937)) and v30.BeaconofLight:IsCastable() and (v126.NamedUnit(355 - (306 + 9), v115, 104 - 74) ~= nil) and v126.NamedUnit(7 + 33, v115, 19 + 11):BuffDown(v30.BeaconofLight)) then
				if (((66 + 71) == (391 - 254)) and v23(v32.BeaconofLightMacro)) then
					return "beacon_of_light combat";
				end
			end
		end
		if ((v116 ~= "None") or ((2945 - (1140 + 235)) >= (2757 + 1575))) then
			if ((v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(37 + 3, v116, 8 + 22) ~= nil) and v126.NamedUnit(92 - (33 + 19), v116, 11 + 19):BuffDown(v30.BeaconofFaith)) or ((12180 - 8116) <= (802 + 1017))) then
				if (v23(v32.BeaconofFaithMacro) or ((9777 - 4791) < (1476 + 98))) then
					return "beacon_of_faith combat";
				end
			end
		end
		local v160 = v135();
		if (((5115 - (586 + 103)) > (16 + 156)) and v160) then
			return v160;
		end
		v160 = v138();
		if (((1803 - 1217) > (1943 - (1309 + 179))) and v160) then
			return v160;
		end
		v160 = v132();
		if (((1490 - 664) == (360 + 466)) and v160) then
			return v160;
		end
		v160 = v141();
		if (v160 or ((10793 - 6774) > (3355 + 1086))) then
			return v160;
		end
		if (((4285 - 2268) < (8490 - 4229)) and v126.TargetIsValid()) then
			v160 = v136();
			if (((5325 - (295 + 314)) > (196 - 116)) and v160) then
				return v160;
			end
			v160 = v137();
			if (v160 or ((5469 - (1300 + 662)) == (10274 - 7002))) then
				return v160;
			end
		end
	end
	local function v143()
		local v161 = 1755 - (1178 + 577);
		while true do
			if ((v161 == (2 + 0)) or ((2589 - 1713) >= (4480 - (851 + 554)))) then
				if (((3849 + 503) > (7082 - 4528)) and v126.TargetIsValid()) then
					local v227 = 0 - 0;
					local v228;
					while true do
						if (((302 - (115 + 187)) == v227) or ((3375 + 1031) < (3828 + 215))) then
							v228 = v134();
							if (v228 or ((7443 - 5554) >= (4544 - (160 + 1001)))) then
								return v228;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1656 + 236) <= (1887 + 847)) and (v161 == (1 - 0))) then
				if (((2281 - (237 + 121)) < (3115 - (525 + 372))) and v117) then
					if (((4119 - 1946) > (1244 - 865)) and (v115 ~= "None")) then
						if ((v30.BeaconofLight:IsCastable() and (v126.NamedUnit(182 - (96 + 46), v115, 807 - (643 + 134)) ~= nil) and v126.NamedUnit(15 + 25, v115, 71 - 41):BuffDown(v30.BeaconofLight)) or ((9619 - 7028) == (3270 + 139))) then
							if (((8858 - 4344) > (6794 - 3470)) and v23(v32.BeaconofLightMacro)) then
								return "beacon_of_light combat";
							end
						end
					end
					if ((v116 ~= "None") or ((927 - (316 + 403)) >= (3210 + 1618))) then
						if ((v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(109 - 69, v116, 11 + 19) ~= nil) and v126.NamedUnit(100 - 60, v116, 22 + 8):BuffDown(v30.BeaconofFaith)) or ((511 + 1072) > (12359 - 8792))) then
							if (v23(v32.BeaconofFaithMacro) or ((6270 - 4957) == (1648 - 854))) then
								return "beacon_of_faith combat";
							end
						end
					end
					local v229 = v141();
					if (((182 + 2992) > (5712 - 2810)) and v229) then
						return v229;
					end
				end
				if (((202 + 3918) <= (12533 - 8273)) and v30.DevotionAura:IsCastable() and v14:BuffDown(v30.DevotionAura)) then
					if (v23(v30.DevotionAura) or ((900 - (12 + 5)) > (18557 - 13779))) then
						return "devotion_aura";
					end
				end
				v161 = 3 - 1;
			end
			if ((v161 == (0 - 0)) or ((8977 - 5357) >= (993 + 3898))) then
				if (((6231 - (1656 + 317)) > (835 + 102)) and v41) then
					local v230 = 0 + 0;
					while true do
						if ((v230 == (0 - 0)) or ((23962 - 19093) < (1260 - (5 + 349)))) then
							ShouldReturn = v133();
							if (ShouldReturn or ((5818 - 4593) > (5499 - (266 + 1005)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((2194 + 1134) > (7636 - 5398)) and v45) then
					if (((5053 - 1214) > (3101 - (561 + 1135))) and v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) then
						if (v23(v32.BlessingofFreedomPlayer) or ((1684 - 391) <= (1666 - 1159))) then
							return "blessing_of_freedom out of combat";
						end
					end
				end
				v161 = 1067 - (507 + 559);
			end
		end
	end
	local function v144()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleCharredBrambles'];
		v45 = EpicSettings.Settings['HandleEntangling'];
		v46 = EpicSettings.Settings['InterruptWithStun'];
		v47 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v48 = EpicSettings.Settings['InterruptThreshold'] or (388 - (212 + 176));
		v53 = EpicSettings.Settings['UseHealthstone'];
		v54 = EpicSettings.Settings['HealthstoneHP'] or (905 - (250 + 655));
		v55 = EpicSettings.Settings['UseAvengingWrathOffensively'];
		v56 = EpicSettings.Settings['UseDivineTollOffensively'];
		v57 = EpicSettings.Settings['UseHolyShockOffensively'];
		v58 = EpicSettings.Settings['UseHolyShockCycle'];
		v59 = EpicSettings.Settings['UseHolyShockGroup'] or (0 - 0);
		v60 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
		v61 = EpicSettings.Settings['UseLayOnHands'];
		v62 = EpicSettings.Settings['LayOnHandsHP'] or (0 - 0);
		v63 = EpicSettings.Settings['UseDivineProtection'];
		v64 = EpicSettings.Settings['DivineProtectionHP'] or (0 - 0);
		v65 = EpicSettings.Settings['UseDivineShield'];
		v66 = EpicSettings.Settings['DivineShieldHP'] or (1956 - (1869 + 87));
		v67 = EpicSettings.Settings['UseWordOfGlory'];
		v68 = EpicSettings.Settings['WordofGlorydHP'] or (0 - 0);
		v69 = EpicSettings.Settings['UseAvengingWrath'];
		v70 = EpicSettings.Settings['AvengingWrathHP'] or (1901 - (484 + 1417));
		v71 = EpicSettings.Settings['AvengingWrathGroup'] or (0 - 0);
		v72 = EpicSettings.Settings['UseAuraMastery'];
		v73 = EpicSettings.Settings['AuraMasteryhHP'] or (0 - 0);
		v74 = EpicSettings.Settings['AuraMasteryGroup'] or (773 - (48 + 725));
		v75 = EpicSettings.Settings['UseBlessingOfSacrifice'];
		v76 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (0 - 0);
		v77 = EpicSettings.Settings['UseHolyShock'];
		v78 = EpicSettings.Settings['HolyShockHP'] or (0 - 0);
	end
	local function v145()
		local v188 = 0 + 0;
		while true do
			if ((v188 == (18 - 11)) or ((811 + 2085) < (235 + 570))) then
				v113 = EpicSettings.Settings['UseBarrierOfFaith'];
				v114 = EpicSettings.Settings['BarrierOfFaithHP'] or (853 - (152 + 701));
				v115 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
				v116 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
				break;
			end
			if (((3627 - (430 + 881)) == (887 + 1429)) and ((898 - (557 + 338)) == v188)) then
				v93 = EpicSettings.Settings['DivineTollGroup'] or (0 + 0);
				v94 = EpicSettings.Settings['UseHolyPrism'];
				v95 = EpicSettings.Settings['UseHolyPrismOffensively'];
				v96 = EpicSettings.Settings['HolyPrismHP'] or (0 - 0);
				v97 = EpicSettings.Settings['LightsHammerUsage'] or "";
				v188 = 13 - 9;
			end
			if ((v188 == (0 - 0)) or ((5538 - 2968) == (2334 - (499 + 302)))) then
				v79 = EpicSettings.Settings['UseFlashOfLight'];
				v80 = EpicSettings.Settings['FlashOfLightHP'] or (866 - (39 + 827));
				v81 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (0 - 0);
				v82 = EpicSettings.Settings['UseHolyLight'];
				v83 = EpicSettings.Settings['HolyLightHP'] or (0 - 0);
				v188 = 3 - 2;
			end
			if (((1 - 0) == v188) or ((76 + 807) == (4273 - 2813))) then
				v67 = EpicSettings.Settings['UseWordOfGlory'];
				v84 = EpicSettings.Settings['WordOfGloryHP'] or (0 + 0);
				v85 = EpicSettings.Settings['UseBeaconOfVirtue'];
				v86 = EpicSettings.Settings['BeaconOfVirtueHP'] or (0 - 0);
				v87 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (104 - (103 + 1));
				v188 = 556 - (475 + 79);
			end
			if (((4 - 2) == v188) or ((14780 - 10161) <= (130 + 869))) then
				v88 = EpicSettings.Settings['UseLightOfDawn'];
				v89 = EpicSettings.Settings['LightOfDawnhHP'] or (0 + 0);
				v90 = EpicSettings.Settings['LightOfDawnGroup'] or (1503 - (1395 + 108));
				v91 = EpicSettings.Settings['UseDivineToll'];
				v92 = EpicSettings.Settings['DivineTollHP'] or (0 - 0);
				v188 = 1207 - (7 + 1197);
			end
			if ((v188 == (3 + 3)) or ((1190 + 2220) > (4435 - (27 + 292)))) then
				v108 = EpicSettings.Settings['TyrsDeliveranceHP'] or (0 - 0);
				v109 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (0 - 0);
				v110 = EpicSettings.Settings['UseHandOfDivinity'];
				v111 = EpicSettings.Settings['HandOfDivinityHP'] or (0 - 0);
				v112 = EpicSettings.Settings['HandOfDivinityGroup'] or (0 - 0);
				v188 = 13 - 6;
			end
			if ((v188 == (144 - (43 + 96))) or ((3683 - 2780) >= (6915 - 3856))) then
				v103 = EpicSettings.Settings['DaybreakMana'] or (0 + 0);
				v104 = EpicSettings.Settings['DaybreakHP'] or (0 + 0);
				v105 = EpicSettings.Settings['DaybreakHGroup'] or (0 - 0);
				v106 = EpicSettings.Settings['DaybreakGroup'] or (0 + 0);
				v107 = EpicSettings.Settings['UseTyrsDeliverance'];
				v188 = 10 - 4;
			end
			if (((2 + 2) == v188) or ((292 + 3684) < (4608 - (1414 + 337)))) then
				v98 = EpicSettings.Settings['LightsHammerHP'] or (1940 - (1642 + 298));
				v99 = EpicSettings.Settings['LightsHammerGroup'] or (0 - 0);
				v100 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
				v101 = EpicSettings.Settings['BlessingOfProtection'] or (0 - 0);
				v102 = EpicSettings.Settings['UseDaybreak'];
				v188 = 14 - 9;
			end
		end
	end
	local function v146()
		local v189 = 0 + 0;
		while true do
			if (((3836 + 1094) > (3279 - (357 + 615))) and (v189 == (3 + 1))) then
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((9927 - 5881) < (1107 + 184))) then
					local v231 = 0 - 0;
					local v232;
					while true do
						if ((v231 == (0 + 0)) or ((289 + 3952) == (2229 + 1316))) then
							v232 = v126.DeadFriendlyUnitsCount();
							if (v14:AffectingCombat() or ((5349 - (384 + 917)) > (4929 - (128 + 569)))) then
								if (v30.Intercession:IsCastable() or ((3293 - (1407 + 136)) >= (5360 - (687 + 1200)))) then
									if (((4876 - (556 + 1154)) == (11138 - 7972)) and v23(v30.Intercession, nil, true)) then
										return "intercession";
									end
								end
							elseif (((1858 - (9 + 86)) < (4145 - (275 + 146))) and (v232 > (1 + 0))) then
								if (((121 - (29 + 35)) <= (12068 - 9345)) and v23(v30.Absolution, nil, true)) then
									return "absolution";
								end
							elseif (v23(v30.Redemption, not v16:IsInRange(119 - 79), true) or ((9138 - 7068) == (289 + 154))) then
								return "redemption";
							end
							break;
						end
					end
				end
				if (v14:AffectingCombat() or (v41 and v119) or ((3717 - (53 + 959)) == (1801 - (312 + 96)))) then
					local v233 = v41 and v30.Cleanse:IsReady();
					local v234 = v126.FocusUnit(v233, v32, 34 - 14);
					if (v234 or ((4886 - (147 + 138)) < (960 - (813 + 86)))) then
						return v234;
					end
				end
				v124 = v14:GetEnemiesInMeleeRange(8 + 0);
				v189 = 8 - 3;
			end
			if (((492 - (18 + 474)) == v189) or ((469 + 921) >= (15483 - 10739))) then
				v144();
				v145();
				v117 = EpicSettings.Toggles['ooc'];
				v189 = 1087 - (860 + 226);
			end
			if ((v189 == (305 - (121 + 182))) or ((247 + 1756) > (5074 - (988 + 252)))) then
				v121 = EpicSettings.Toggles['cycle'];
				v122 = EpicSettings.Toggles['lod'];
				if (v14:IsMounted() or ((18 + 138) > (1226 + 2687))) then
					return;
				end
				v189 = 1973 - (49 + 1921);
			end
			if (((1085 - (223 + 667)) == (247 - (51 + 1))) and (v189 == (5 - 2))) then
				if (((6648 - 3543) >= (2921 - (146 + 979))) and v14:IsDeadOrGhost()) then
					return;
				end
				if (((1236 + 3143) >= (2736 - (311 + 294))) and v43) then
					ShouldReturn = v126.HandleCharredTreant(v30.HolyShock, v32.HolyShockMouseover, 111 - 71);
					if (((1629 + 2215) >= (3486 - (496 + 947))) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredTreant(v30.WordofGlory, v32.WordofGloryMouseover, 1398 - (1233 + 125));
					if (ShouldReturn or ((1312 + 1920) <= (2451 + 280))) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredTreant(v30.FlashofLight, v32.FlashofLightMouseover, 8 + 32);
					if (((6550 - (963 + 682)) == (4094 + 811)) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredTreant(v30.HolyLight, v32.HolyLightMouseover, 1544 - (504 + 1000));
					if (ShouldReturn or ((2786 + 1350) >= (4017 + 394))) then
						return ShouldReturn;
					end
				end
				if (v44 or ((280 + 2678) == (5922 - 1905))) then
					ShouldReturn = v126.HandleCharredBrambles(v30.HolyShock, v32.HolyShockMouseover, 35 + 5);
					if (((715 + 513) >= (995 - (156 + 26))) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredBrambles(v30.WordofGlory, v32.WordofGloryMouseover, 24 + 16);
					if (ShouldReturn or ((5405 - 1950) > (4214 - (149 + 15)))) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredBrambles(v30.FlashofLight, v32.FlashofLightMouseover, 1000 - (890 + 70));
					if (((360 - (39 + 78)) == (725 - (14 + 468))) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v126.HandleCharredBrambles(v30.HolyLight, v32.HolyLightMouseover, 87 - 47);
					if (ShouldReturn or ((757 - 486) > (812 + 760))) then
						return ShouldReturn;
					end
				end
				v189 = 3 + 1;
			end
			if (((582 + 2157) < (1488 + 1805)) and (v189 == (2 + 3))) then
				if (AOE or ((7545 - 3603) < (1121 + 13))) then
					v125 = #v124;
				else
					v125 = 3 - 2;
				end
				if (not v14:IsChanneling() or ((68 + 2625) == (5024 - (12 + 39)))) then
					if (((1997 + 149) == (6642 - 4496)) and (v117 or v14:AffectingCombat())) then
						if (v14:AffectingCombat() or ((7992 - 5748) == (956 + 2268))) then
							local v235 = v142();
							if (v235 or ((2582 + 2322) <= (4858 - 2942))) then
								return v235;
							end
						else
							local v236 = 0 + 0;
							local v237;
							while true do
								if (((434 - 344) <= (2775 - (1596 + 114))) and (v236 == (0 - 0))) then
									v237 = v143();
									if (((5515 - (164 + 549)) == (6240 - (1059 + 379))) and v237) then
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
			if ((v189 == (1 - 0)) or ((1182 + 1098) <= (87 + 424))) then
				v118 = EpicSettings.Toggles['cds'];
				v119 = EpicSettings.Toggles['dispel'];
				v120 = EpicSettings.Toggles['spread'];
				v189 = 394 - (145 + 247);
			end
		end
	end
	local function v147()
		local v190 = 0 + 0;
		while true do
			if ((v190 == (1 + 0)) or ((4968 - 3292) <= (89 + 374))) then
				v126.DispellableDebuffs = v11.MergeTable(v126.DispellableDebuffs, v126.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.01 By BoomK");
				break;
			end
			if (((3333 + 536) == (6281 - 2412)) and (v190 == (720 - (254 + 466)))) then
				v20.Print("Holy Paladin by Epic.");
				v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
				v190 = 561 - (544 + 16);
			end
		end
	end
	v20.SetAPL(206 - 141, v146, v147);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

