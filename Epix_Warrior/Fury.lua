local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1632 - (228 + 498)) >= (483 + 1746))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Fury.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
	local v31;
	local v32;
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
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91 = v19.Commons.Everyone;
	local v92 = v17.Warrior.Fury;
	local v93 = v18.Warrior.Fury;
	local v94 = v22.Warrior.Fury;
	local v95 = {};
	local v96 = 6139 + 4972;
	local v97 = 11774 - (174 + 489);
	v9:RegisterForEvent(function()
		local v114 = 0 - 0;
		while true do
			if (((3193 - (830 + 1075)) > (1775 - (303 + 221))) and (v114 == (1269 - (231 + 1038)))) then
				v96 = 9259 + 1852;
				v97 = 12273 - (171 + 991);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v115 = 0 - 0;
		local v116;
		while true do
			if ((v115 == (0 - 0)) or ((11261 - 6748) < (2683 + 669))) then
				v116 = UnitGetTotalAbsorbs(v14:ID());
				if ((v116 > (0 - 0)) or ((5957 - 3892) >= (5151 - 1955))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		local v117 = 0 - 0;
		while true do
			if ((v117 == (1250 - (111 + 1137))) or ((4534 - (91 + 67)) <= (4407 - 2926))) then
				if ((v92.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((847 + 2545) >= (5264 - (423 + 100)))) then
					if (((24 + 3301) >= (5963 - 3809)) and v23(v94.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v92.DefensiveStance:IsCastable() and v68 and (v13:HealthPercentage() <= v78) and v13:BuffDown(v92.DefensiveStance, true)) or ((675 + 620) >= (4004 - (326 + 445)))) then
					if (((19100 - 14723) > (3657 - 2015)) and v23(v92.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v117 = 6 - 3;
			end
			if (((5434 - (530 + 181)) > (2237 - (614 + 267))) and (v117 == (32 - (19 + 13)))) then
				if ((v92.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) or ((6731 - 2595) <= (7999 - 4566))) then
					if (((12126 - 7881) <= (1203 + 3428)) and v23(v92.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((7519 - 3243) >= (8116 - 4202)) and v92.EnragedRegeneration:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
					if (((2010 - (1293 + 519)) <= (8905 - 4540)) and v23(v92.EnragedRegeneration)) then
						return "enraged_regeneration defensive";
					end
				end
				v117 = 2 - 1;
			end
			if (((9144 - 4362) > (20163 - 15487)) and (v117 == (6 - 3))) then
				if (((2577 + 2287) > (449 + 1748)) and v92.BerserkerStance:IsCastable() and v68 and (v13:HealthPercentage() > v81) and v13:BuffDown(v92.BerserkerStance, true)) then
					if (v23(v92.BerserkerStance) or ((8597 - 4897) == (580 + 1927))) then
						return "berserker_stance after defensive stance defensive";
					end
				end
				if (((1487 + 2987) >= (172 + 102)) and v93.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) then
					if (v23(v94.Healthstone) or ((2990 - (709 + 387)) <= (3264 - (673 + 1185)))) then
						return "healthstone defensive 3";
					end
				end
				v117 = 11 - 7;
			end
			if (((5047 - 3475) >= (2518 - 987)) and (v117 == (3 + 1))) then
				if ((v70 and (v13:HealthPercentage() <= v80)) or ((3503 + 1184) < (6131 - 1589))) then
					if (((809 + 2482) > (3323 - 1656)) and (v86 == "Refreshing Healing Potion")) then
						if (v93.RefreshingHealingPotion:IsReady() or ((1713 - 840) == (3914 - (446 + 1434)))) then
							if (v23(v94.RefreshingHealingPotion) or ((4099 - (1040 + 243)) < (32 - 21))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((5546 - (559 + 1288)) < (6637 - (609 + 1322))) and (v86 == "Dreamwalker's Healing Potion")) then
						if (((3100 - (13 + 441)) >= (3273 - 2397)) and v93.DreamwalkersHealingPotion:IsReady()) then
							if (((1608 - 994) <= (15857 - 12673)) and v23(v94.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					if (((117 + 3009) == (11352 - 8226)) and (v86 == "Potion of Withering Dreams")) then
						if (v93.PotionOfWitheringDreams:IsReady() or ((777 + 1410) >= (2171 + 2783))) then
							if (v23(v94.RefreshingHealingPotion) or ((11505 - 7628) == (1957 + 1618))) then
								return "potion of withering dreams defensive";
							end
						end
					end
				end
				break;
			end
			if (((1300 - 593) > (418 + 214)) and (v117 == (1 + 0))) then
				if ((v92.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) or ((393 + 153) >= (2254 + 430))) then
					if (((1434 + 31) <= (4734 - (153 + 280))) and v23(v92.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if (((4920 - 3216) > (1280 + 145)) and v92.RallyingCry:IsCastable() and v66 and v13:BuffDown(v92.AspectsFavorBuff) and v13:BuffDown(v92.RallyingCry) and (((v13:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76, v92.Intervene))) then
					if (v23(v92.RallyingCry) or ((272 + 415) == (2216 + 2018))) then
						return "rallying_cry defensive";
					end
				end
				v117 = 2 + 0;
			end
		end
	end
	local function v103()
		local v118 = 0 + 0;
		while true do
			if (((1 - 0) == v118) or ((2059 + 1271) < (2096 - (89 + 578)))) then
				v26 = v91.HandleBottomTrinket(v95, v29, 29 + 11, nil);
				if (((2384 - 1237) >= (1384 - (572 + 477))) and v26) then
					return v26;
				end
				break;
			end
			if (((464 + 2971) > (1259 + 838)) and (v118 == (0 + 0))) then
				v26 = v91.HandleTopTrinket(v95, v29, 126 - (84 + 2), nil);
				if (v26 or ((6213 - 2443) >= (2912 + 1129))) then
					return v26;
				end
				v118 = 843 - (497 + 345);
			end
		end
	end
	local function v104()
		if ((v31 and ((v52 and v29) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) or ((97 + 3694) <= (273 + 1338))) then
			if (v23(v92.Avatar, not v100) or ((5911 - (605 + 728)) <= (1433 + 575))) then
				return "avatar precombat 6";
			end
		end
		if (((2501 - 1376) <= (96 + 1980)) and v44 and ((v55 and v29) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) then
			if (v23(v92.Recklessness, not v100) or ((2746 - 2003) >= (3966 + 433))) then
				return "recklessness precombat 8";
			end
		end
		if (((3199 - 2044) < (1264 + 409)) and v92.Bloodthirst:IsCastable() and v34 and v100) then
			if (v23(v92.Bloodthirst, not v100) or ((2813 - (457 + 32)) <= (246 + 332))) then
				return "bloodthirst precombat 10";
			end
		end
		if (((5169 - (832 + 570)) == (3549 + 218)) and v35 and v92.Charge:IsReady() and not v100) then
			if (((1067 + 3022) == (14469 - 10380)) and v23(v92.Charge, not v14:IsSpellInRange(v92.Charge))) then
				return "charge precombat 12";
			end
		end
	end
	local function v105()
		if (((2148 + 2310) >= (2470 - (588 + 208))) and not v13:AffectingCombat()) then
			if (((2619 - 1647) <= (3218 - (884 + 916))) and v92.BerserkerStance:IsCastable() and v13:BuffDown(v92.BerserkerStance, true)) then
				if (v23(v92.BerserkerStance) or ((10337 - 5399) < (2762 + 2000))) then
					return "berserker_stance";
				end
			end
			if ((v92.BattleShout:IsCastable() and v32 and (v13:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) or ((3157 - (232 + 421)) > (6153 - (1569 + 320)))) then
				if (((529 + 1624) == (410 + 1743)) and v23(v92.BattleShout)) then
					return "battle_shout precombat";
				end
			end
		end
		if ((v91.TargetIsValid() and v27) or ((1708 - 1201) >= (3196 - (316 + 289)))) then
			if (((11729 - 7248) == (207 + 4274)) and not v13:AffectingCombat()) then
				local v178 = 1453 - (666 + 787);
				while true do
					if ((v178 == (425 - (360 + 65))) or ((2176 + 152) < (947 - (79 + 175)))) then
						v26 = v104();
						if (((6824 - 2496) == (3378 + 950)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v106()
		local v119 = 0 - 0;
		local v120;
		while true do
			if (((3058 - 1470) >= (2231 - (503 + 396))) and ((182 - (92 + 89)) == v119)) then
				if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (164 - 79)))) or ((2141 + 2033) > (2515 + 1733))) then
					if (v23(v92.Rampage, not v100) or ((17959 - 13373) <= (12 + 70))) then
						return "rampage multi_target 10";
					end
				end
				if (((8807 - 4944) == (3371 + 492)) and v92.ThunderousRoar:IsCastable() and ((v57 and v29) or not v57) and v47 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.ThunderousRoar, not v14:IsInMeleeRange(4 + 4)) or ((858 - 576) <= (6 + 36))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if (((7028 - 2419) >= (2010 - (485 + 759))) and v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (2 - 1)) and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.OdynsFury, not v14:IsInMeleeRange(1197 - (442 + 747))) or ((2287 - (832 + 303)) == (3434 - (88 + 858)))) then
						return "odyns_fury multi_target 12";
					end
				end
				if (((1043 + 2379) > (2773 + 577)) and v92.Whirlwind:IsCastable() and v48 and (v13:BuffStack(v92.MeatCleaverBuff) == (1 + 0)) and v13:BuffUp(v92.HurricaneBuff) and (v13:Rage() < (869 - (766 + 23))) and (v13:Rage() > (296 - 236))) then
					if (((1199 - 322) > (990 - 614)) and v23(v92.Whirlwind, not v14:IsInMeleeRange(27 - 19))) then
						return "whirlwind multi_target 14";
					end
				end
				v119 = 1075 - (1036 + 37);
			end
			if (((5 + 2) == v119) or ((6071 - 2953) <= (1457 + 394))) then
				if ((v92.RagingBlow:IsCastable() and v41) or ((1645 - (641 + 839)) >= (4405 - (910 + 3)))) then
					if (((10066 - 6117) < (6540 - (1466 + 218))) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 48";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36) or ((1966 + 2310) < (4164 - (556 + 592)))) then
					if (((1668 + 3022) > (4933 - (329 + 479))) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 50";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34) or ((904 - (174 + 680)) >= (3078 - 2182))) then
					if (v23(v92.Bloodthirst, not v100) or ((3552 - 1838) >= (2112 + 846))) then
						return "bloodthirst multi_target 52";
					end
				end
				if ((v92.Whirlwind:IsCastable() and v48) or ((2230 - (396 + 343)) < (57 + 587))) then
					if (((2181 - (29 + 1448)) < (2376 - (135 + 1254))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(30 - 22))) then
						return "whirlwind multi_target 54";
					end
				end
				break;
			end
			if (((17359 - 13641) > (1271 + 635)) and (v119 == (1532 - (389 + 1138)))) then
				if ((v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (575 - (102 + 472))) and v92.WrathandFury:IsAvailable()) or ((905 + 53) > (2016 + 1619))) then
					if (((3265 + 236) <= (6037 - (320 + 1225))) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) or ((6126 - 2684) < (1560 + 988))) then
					if (((4339 - (157 + 1307)) >= (3323 - (821 + 1038))) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 34";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) or ((11968 - 7171) >= (536 + 4357))) then
					if (v23(v92.CrushingBlow, not v100) or ((978 - 427) > (770 + 1298))) then
						return "crushing_blow multi_target 36";
					end
				end
				if (((5239 - 3125) > (1970 - (834 + 192))) and v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) then
					if (v23(v92.Bloodthirst, not v100) or ((144 + 2118) >= (795 + 2301))) then
						return "bloodthirst multi_target 38";
					end
				end
				v119 = 1 + 5;
			end
			if ((v119 == (5 - 1)) or ((2559 - (300 + 4)) >= (945 + 2592))) then
				if ((v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff)))) or ((10044 - 6207) < (1668 - (112 + 250)))) then
					if (((1176 + 1774) == (7390 - 4440)) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst multi_target 26";
					end
				end
				if ((v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v13:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) or ((2706 + 2017) < (1706 + 1592))) then
					if (((850 + 286) >= (77 + 77)) and v23(v92.Onslaught, not v100)) then
						return "onslaught multi_target 28";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) or ((202 + 69) > (6162 - (1001 + 413)))) then
					if (((10570 - 5830) >= (4034 - (244 + 638))) and v23(v92.Execute, not v100)) then
						return "execute multi_target 30";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (694 - (627 + 66))) and v92.WrathandFury:IsAvailable()) or ((7681 - 5103) >= (3992 - (512 + 90)))) then
					if (((1947 - (1665 + 241)) <= (2378 - (373 + 344))) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 30";
					end
				end
				v119 = 3 + 2;
			end
			if (((160 + 441) < (9390 - 5830)) and (v119 == (9 - 3))) then
				if (((1334 - (35 + 1064)) < (500 + 187)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (2 - 1))) then
					if (((19 + 4530) > (2389 - (298 + 938))) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 40";
					end
				end
				if ((v92.Rampage:IsReady() and v42) or ((5933 - (233 + 1026)) < (6338 - (636 + 1030)))) then
					if (((1876 + 1792) < (4456 + 105)) and v23(v92.Rampage, not v100)) then
						return "rampage multi_target 42";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((136 + 319) == (244 + 3361))) then
					if (v23(v92.Slam, not v100) or ((2884 - (55 + 166)) == (642 + 2670))) then
						return "slam multi_target 44";
					end
				end
				if (((431 + 3846) <= (17090 - 12615)) and v92.Bloodbath:IsCastable() and v33) then
					if (v23(v92.Bloodbath, not v100) or ((1167 - (36 + 261)) == (2078 - 889))) then
						return "bloodbath multi_target 46";
					end
				end
				v119 = 1375 - (34 + 1334);
			end
			if (((598 + 955) <= (2435 + 698)) and (v119 == (1283 - (1035 + 248)))) then
				if ((v92.Recklessness:IsCastable() and ((v55 and v29) or not v55) and v44 and (v90 < v97) and ((v99 > (22 - (20 + 1))) or (v97 < (7 + 5)))) or ((2556 - (134 + 185)) >= (4644 - (549 + 584)))) then
					if (v23(v92.Recklessness, not v100) or ((2009 - (314 + 371)) > (10367 - 7347))) then
						return "recklessness multi_target 2";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (969 - (478 + 490))) and v92.TitanicRage:IsAvailable() and (v13:BuffDown(v92.MeatCleaverBuff) or v13:BuffUp(v92.AvatarBuff) or v13:BuffUp(v92.RecklessnessBuff))) or ((1585 + 1407) == (3053 - (786 + 386)))) then
					if (((10060 - 6954) > (2905 - (1055 + 324))) and v23(v92.OdynsFury, not v14:IsInMeleeRange(1348 - (1093 + 247)))) then
						return "odyns_fury multi_target 4";
					end
				end
				if (((2687 + 336) < (407 + 3463)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (3 - 2)) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) then
					if (((484 - 341) > (210 - 136)) and v23(v92.Whirlwind, not v14:IsInMeleeRange(19 - 11))) then
						return "whirlwind multi_target 6";
					end
				end
				if (((7 + 11) < (8136 - 6024)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) then
					if (((3781 - 2684) <= (1228 + 400)) and v23(v92.Execute, not v100)) then
						return "execute multi_target 8";
					end
				end
				v119 = 2 - 1;
			end
			if (((5318 - (364 + 324)) == (12692 - 8062)) and (v119 == (6 - 3))) then
				if (((1174 + 2366) > (11226 - 8543)) and v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) then
					if (((7677 - 2883) >= (9946 - 6671)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(1276 - (1249 + 19)))) then
						return "odyns_fury multi_target 18";
					end
				end
				if (((1340 + 144) == (5776 - 4292)) and v92.Rampage:IsReady() and v42 and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (1196 - (686 + 400))) and v92.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (63 + 17)) and not v92.OverwhelmingRage:IsAvailable()))) then
					if (((1661 - (73 + 156)) < (17 + 3538)) and v23(v92.Rampage, not v100)) then
						return "rampage multi_target 20";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((1876 - (721 + 90)) > (41 + 3537))) then
					if (v23(v92.Bloodbath, not v100) or ((15568 - 10773) < (1877 - (224 + 246)))) then
						return "bloodbath multi_target 24";
					end
				end
				if (((3001 - 1148) < (8861 - 4048)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff) and v92.AshenJuggernaut:IsAvailable()) then
					if (v23(v92.Execute, not v100) or ((512 + 2309) < (58 + 2373))) then
						return "execute multi_target 26";
					end
				end
				v119 = 3 + 1;
			end
			if ((v119 == (3 - 1)) or ((9563 - 6689) < (2694 - (203 + 310)))) then
				v120 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (2013 - (1238 + 755))) + (v13:BuffStack(v92.MercilessAssaultBuff) * (1 + 9)) + (v13:BuffStack(v92.BloodcrazeBuff) * (1549 - (709 + 825)));
				if ((v92.Bloodbath:IsCastable() and v33 and ((v13:HasTier(55 - 25, 5 - 1) and (v120 >= (959 - (196 + 668)))) or v13:HasTier(122 - 91, 7 - 3))) or ((3522 - (171 + 662)) <= (436 - (4 + 89)))) then
					if (v23(v92.Bloodbath, not v100) or ((6550 - 4681) == (732 + 1277))) then
						return "bloodbath multi_target 16";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(131 - 101, 2 + 2) and (v120 >= (1581 - (35 + 1451)))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff)))) or ((4999 - (28 + 1425)) < (4315 - (941 + 1052)))) then
					if (v23(v92.Bloodthirst, not v100) or ((1997 + 85) == (6287 - (822 + 692)))) then
						return "bloodthirst multi_target 16";
					end
				end
				if (((4631 - 1387) > (497 + 558)) and v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.CrushingBlow, not v100) or ((3610 - (45 + 252)) <= (1760 + 18))) then
						return "crushing_blow multi_target 14";
					end
				end
				v119 = 2 + 1;
			end
		end
	end
	local function v107()
		local v121 = 0 - 0;
		local v122;
		while true do
			if ((v121 == (436 - (114 + 319))) or ((2039 - 618) >= (2695 - 591))) then
				if (((1156 + 656) <= (4839 - 1590)) and v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff))) and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((3400 - 1777) <= (3920 - (556 + 1407))) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 34";
					end
				end
				if (((5618 - (741 + 465)) == (4877 - (170 + 295))) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable()) then
					if (((1608 + 142) >= (2072 - 1230)) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 36";
					end
				end
				if (((3625 + 747) > (1187 + 663)) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((1462 - (957 + 273)) < (220 + 601)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 38";
					end
				end
				if (((208 + 310) < (3436 - 2534)) and v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (((7889 - 4895) > (2620 - 1762)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 40";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((18593 - 14838) <= (2695 - (389 + 1391)))) then
					if (((2476 + 1470) > (390 + 3353)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((3039 - 1704) >= (4257 - (783 + 168)))) then
					if (((16257 - 11413) > (2217 + 36)) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 44";
					end
				end
				v121 = 315 - (309 + 2);
			end
			if (((1387 - 935) == (1664 - (1090 + 122))) and (v121 == (1 + 1))) then
				if ((v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (285 - 200)))) or ((3119 + 1438) < (3205 - (628 + 490)))) then
					if (((695 + 3179) == (9591 - 5717)) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 24";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) or ((8856 - 6918) > (5709 - (431 + 343)))) then
					if (v23(v92.Execute, not v100) or ((8593 - 4338) < (9902 - 6479))) then
						return "execute single_target 26";
					end
				end
				if (((1149 + 305) <= (319 + 2172)) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) then
					if (v23(v92.Rampage, not v100) or ((5852 - (556 + 1139)) <= (2818 - (6 + 9)))) then
						return "rampage single_target 28";
					end
				end
				if (((889 + 3964) >= (1528 + 1454)) and v92.Execute:IsReady() and v37) then
					if (((4303 - (28 + 141)) > (1301 + 2056)) and v23(v92.Execute, not v100)) then
						return "execute single_target 29";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((4217 - 800) < (1795 + 739))) then
					if (v23(v92.Bloodbath, not v100) or ((4039 - (486 + 831)) <= (426 - 262))) then
						return "bloodbath single_target 30";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and (v14:HealthPercentage() < (123 - 88)) and v92.Massacre:IsAvailable()) or ((456 + 1952) < (6668 - 4559))) then
					if (v23(v92.Rampage, not v100) or ((1296 - (668 + 595)) == (1310 + 145))) then
						return "rampage single_target 32";
					end
				end
				v121 = 1 + 2;
			end
			if ((v121 == (13 - 8)) or ((733 - (23 + 267)) >= (5959 - (1129 + 815)))) then
				if (((3769 - (371 + 16)) > (1916 - (1326 + 424))) and v92.Bloodthirst:IsCastable() and v34) then
					if (v23(v92.Bloodthirst, not v100) or ((530 - 250) == (11178 - 8119))) then
						return "bloodthirst single_target 56";
					end
				end
				if (((1999 - (88 + 30)) > (2064 - (720 + 51))) and v28 and v92.Whirlwind:IsCastable() and v48) then
					if (((5243 - 2886) == (4133 - (421 + 1355))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(13 - 5))) then
						return "whirlwind single_target 58";
					end
				end
				if (((61 + 62) == (1206 - (286 + 797))) and v92.WreckingThrow:IsCastable() and v49 and v101()) then
					if (v23(v92.WreckingThrow, not v100) or ((3860 - 2804) >= (5617 - 2225))) then
						return "wrecking_throw single_target 60";
					end
				end
				break;
			end
			if ((v121 == (443 - (397 + 42))) or ((338 + 743) < (1875 - (24 + 776)))) then
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 - 0))) or ((1834 - (222 + 563)) >= (9764 - 5332))) then
					if (v23(v92.RagingBlow, not v100) or ((3433 + 1335) <= (1036 - (23 + 167)))) then
						return "raging_blow single_target 46";
					end
				end
				if ((v92.Rampage:IsReady() and v42) or ((5156 - (690 + 1108)) <= (513 + 907))) then
					if (v23(v92.Rampage, not v100) or ((3085 + 654) <= (3853 - (40 + 808)))) then
						return "rampage single_target 47";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((274 + 1385) >= (8160 - 6026))) then
					if (v23(v92.Slam, not v100) or ((3116 + 144) < (1246 + 1109))) then
						return "slam single_target 48";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33) or ((367 + 302) == (4794 - (47 + 524)))) then
					if (v23(v92.Bloodbath, not v100) or ((1099 + 593) < (1607 - 1019))) then
						return "bloodbath single_target 50";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41) or ((7172 - 2375) < (8326 - 4675))) then
					if (v23(v92.RagingBlow, not v100) or ((5903 - (1165 + 561)) > (145 + 4705))) then
						return "raging_blow single_target 52";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((1238 - 838) > (424 + 687))) then
					if (((3530 - (341 + 138)) > (272 + 733)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 54";
					end
				end
				v121 = 10 - 5;
			end
			if (((4019 - (89 + 237)) <= (14096 - 9714)) and (v121 == (0 - 0))) then
				if ((v92.Whirlwind:IsCastable() and v48 and (v99 > (882 - (581 + 300))) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) or ((4502 - (855 + 365)) > (9738 - 5638))) then
					if (v23(v92.Whirlwind, not v14:IsInMeleeRange(3 + 5)) or ((4815 - (1030 + 205)) < (2670 + 174))) then
						return "whirlwind single_target 2";
					end
				end
				if (((83 + 6) < (4776 - (156 + 130))) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) then
					if (v23(v92.Execute, not v100) or ((11322 - 6339) < (3047 - 1239))) then
						return "execute single_target 4";
					end
				end
				if (((7841 - 4012) > (994 + 2775)) and v39 and ((v53 and v29) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v13:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v13:BuffRemains(v92.DancingBladesBuff) < (3 + 2))) or not v92.DancingBlades:IsAvailable())) then
					if (((1554 - (10 + 59)) <= (822 + 2082)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(39 - 31))) then
						return "odyns_fury single_target 6";
					end
				end
				if (((5432 - (671 + 492)) == (3399 + 870)) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (1300 - (369 + 846))))) then
					if (((103 + 284) <= (2375 + 407)) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 8";
					end
				end
				v122 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (1965 - (1036 + 909))) + (v13:BuffStack(v92.MercilessAssaultBuff) * (8 + 2)) + (v13:BuffStack(v92.BloodcrazeBuff) * (25 - 10));
				if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(233 - (11 + 192), 3 + 1) and (v122 >= (270 - (135 + 40)))) or ((4600 - 2701) <= (553 + 364))) then
					if (v23(v92.Bloodbath, not v100) or ((9499 - 5187) <= (1312 - 436))) then
						return "bloodbath single_target 10";
					end
				end
				v121 = 177 - (50 + 126);
			end
			if (((6215 - 3983) <= (575 + 2021)) and (v121 == (1414 - (1233 + 180)))) then
				if (((3064 - (522 + 447)) < (5107 - (107 + 1314))) and v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(14 + 16, 11 - 7) and (v122 >= (41 + 54))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff) and (v14:DebuffDown(v92.GushingWoundDebuff) or v13:BuffUp(v92.ElysianMightBuff))))) then
					if (v23(v92.Bloodthirst, not v100) or ((3167 - 1572) >= (17701 - 13227))) then
						return "bloodthirst single_target 12";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(1941 - (716 + 1194), 1 + 1)) or ((495 + 4124) < (3385 - (74 + 429)))) then
					if (v23(v92.Bloodbath, not v100) or ((566 - 272) >= (2395 + 2436))) then
						return "bloodbath single_target 14";
					end
				end
				if (((4644 - 2615) <= (2182 + 902)) and v47 and ((v57 and v29) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.ThunderousRoar, not v14:IsInMeleeRange(24 - 16)) or ((5036 - 2999) == (2853 - (279 + 154)))) then
						return "thunderous_roar single_target 16";
					end
				end
				if (((5236 - (454 + 324)) > (3072 + 832)) and v92.Onslaught:IsReady() and v40 and (v13:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) then
					if (((453 - (12 + 5)) >= (67 + 56)) and v23(v92.Onslaught, not v100)) then
						return "onslaught single_target 18";
					end
				end
				if (((1274 - 774) < (672 + 1144)) and v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((4667 - (277 + 816)) == (15271 - 11697)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 20";
					end
				end
				if (((1404 - (1058 + 125)) < (74 + 316)) and v92.Execute:IsReady() and v37 and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.AshenJuggernautBuff)) or ((v13:BuffRemains(v92.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (1010 - (815 + 160))) and v92.Massacre:IsAvailable()) or (v14:HealthPercentage() > (85 - 65)))))) then
					if (v23(v92.Execute, not v100) or ((5253 - 3040) <= (339 + 1082))) then
						return "execute single_target 22";
					end
				end
				v121 = 5 - 3;
			end
		end
	end
	local function v108()
		v26 = v102();
		if (((4956 - (41 + 1857)) < (6753 - (1222 + 671))) and v26) then
			return v26;
		end
		if (v85 or ((3349 - 2053) >= (6390 - 1944))) then
			local v152 = 1182 - (229 + 953);
			while true do
				if ((v152 == (1775 - (1111 + 663))) or ((2972 - (874 + 705)) > (629 + 3860))) then
					v26 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 6 + 2, true);
					if (v26 or ((9195 - 4771) < (1 + 26))) then
						return v26;
					end
					break;
				end
				if ((v152 == (679 - (642 + 37))) or ((456 + 1541) > (611 + 3204))) then
					v26 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 50 - 30, true);
					if (((3919 - (233 + 221)) > (4423 - 2510)) and v26) then
						return v26;
					end
					v152 = 1 + 0;
				end
			end
		end
		if (((2274 - (718 + 823)) < (1145 + 674)) and v91.TargetIsValid()) then
			local v153 = 805 - (266 + 539);
			local v154;
			while true do
				if ((v153 == (5 - 3)) or ((5620 - (636 + 589)) == (11287 - 6532))) then
					if ((v38 and v92.HeroicThrow:IsCastable() and not v14:IsInRange(51 - 26) and v13:CanAttack(v14)) or ((3006 + 787) < (861 + 1508))) then
						if (v23(v92.HeroicThrow, not v14:IsSpellInRange(v92.HeroicThrow)) or ((5099 - (657 + 358)) == (701 - 436))) then
							return "heroic_throw main";
						end
					end
					if (((9928 - 5570) == (5545 - (1151 + 36))) and v92.WreckingThrow:IsCastable() and v49 and v101() and v13:CanAttack(v14)) then
						if (v23(v92.WreckingThrow, not v14:IsSpellInRange(v92.WreckingThrow)) or ((3031 + 107) < (262 + 731))) then
							return "wrecking_throw main";
						end
					end
					if (((9944 - 6614) > (4155 - (1552 + 280))) and v28 and (v99 >= (836 - (64 + 770)))) then
						v26 = v106();
						if (v26 or ((2462 + 1164) == (9055 - 5066))) then
							return v26;
						end
					end
					v26 = v107();
					v153 = 1 + 2;
				end
				if (((1244 - (157 + 1086)) == v153) or ((1833 - 917) == (11698 - 9027))) then
					if (((416 - 144) == (370 - 98)) and v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (822 - (599 + 220))) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (19 - 9)))) then
						if (((6180 - (1813 + 118)) <= (3538 + 1301)) and v23(v94.RavagerPlayer, not v100)) then
							return "ravager main 4";
						end
					end
					if (((3994 - (841 + 376)) < (4484 - 1284)) and v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (1 + 2)) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (27 - 17)))) then
						if (((954 - (464 + 395)) < (5022 - 3065)) and v23(v94.RavagerCursor, not v14:IsInRange(10 + 10))) then
							return "ravager main 6";
						end
					end
					if (((1663 - (467 + 370)) < (3548 - 1831)) and (v90 < v97) and v50 and ((v58 and v29) or not v58)) then
						if (((1047 + 379) >= (3787 - 2682)) and v92.BloodFury:IsCastable()) then
							if (((430 + 2324) <= (7861 - 4482)) and v23(v92.BloodFury, not v100)) then
								return "blood_fury main 12";
							end
						end
						if ((v92.Berserking:IsCastable() and v13:BuffUp(v92.RecklessnessBuff)) or ((4447 - (150 + 370)) == (2695 - (74 + 1208)))) then
							if (v23(v92.Berserking, not v100) or ((2837 - 1683) <= (3737 - 2949))) then
								return "berserking main 14";
							end
						end
						if ((v92.LightsJudgment:IsCastable() and v13:BuffDown(v92.RecklessnessBuff)) or ((1170 + 473) > (3769 - (14 + 376)))) then
							if (v23(v92.LightsJudgment, not v14:IsSpellInRange(v92.LightsJudgment)) or ((4861 - 2058) > (2944 + 1605))) then
								return "lights_judgment main 16";
							end
						end
						if (v92.Fireblood:IsCastable() or ((194 + 26) >= (2883 + 139))) then
							if (((8268 - 5446) == (2123 + 699)) and v23(v92.Fireblood, not v100)) then
								return "fireblood main 18";
							end
						end
						if (v92.AncestralCall:IsCastable() or ((1139 - (23 + 55)) == (4400 - 2543))) then
							if (((1842 + 918) > (1225 + 139)) and v23(v92.AncestralCall, not v100)) then
								return "ancestral_call main 20";
							end
						end
						if ((v92.BagofTricks:IsCastable() and v13:BuffDown(v92.RecklessnessBuff) and v13:BuffUp(v92.EnrageBuff)) or ((7600 - 2698) <= (1131 + 2464))) then
							if (v23(v92.BagofTricks, not v14:IsSpellInRange(v92.BagofTricks)) or ((4753 - (652 + 249)) == (784 - 491))) then
								return "bag_of_tricks main 22";
							end
						end
					end
					if ((v90 < v97) or ((3427 - (708 + 1160)) == (12453 - 7865))) then
						local v180 = 0 - 0;
						while true do
							if (((29 - (10 + 17)) == v180) or ((1008 + 3476) == (2520 - (1400 + 332)))) then
								if (((8761 - 4193) >= (5815 - (242 + 1666))) and v92.ChampionsSpear:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v29) or not v56) and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (9 + 11)) or (v99 > (1 + 0)) or not v13:HasTier(27 + 4, 942 - (850 + 90)))) then
									if (((2181 - 935) < (4860 - (360 + 1030))) and v23(v94.ChampionsSpearCursor, not v14:IsInRange(27 + 3))) then
										return "spear_of_bastion main 31";
									end
								end
								break;
							end
							if (((11481 - 7413) >= (1336 - 364)) and (v180 == (1662 - (909 + 752)))) then
								if (((1716 - (109 + 1114)) < (7127 - 3234)) and v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and (not v92.Annihilator:IsAvailable() or (v97 < (5 + 7)))) then
									if (v23(v92.Recklessness, not v100) or ((1715 - (6 + 236)) >= (2100 + 1232))) then
										return "recklessness main 27";
									end
								end
								if ((v92.ChampionsSpear:IsCastable() and (v84 == "player") and v46 and ((v56 and v29) or not v56) and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (17 + 3)) or (v99 > (2 - 1)) or not v13:HasTier(54 - 23, 1135 - (1076 + 57)))) or ((667 + 3384) <= (1846 - (579 + 110)))) then
									if (((48 + 556) < (2548 + 333)) and v23(v94.ChampionsSpearPlayer, not v100)) then
										return "spear_of_bastion main 30";
									end
								end
								v180 = 2 + 0;
							end
							if ((v180 == (407 - (174 + 233))) or ((2513 - 1613) == (5926 - 2549))) then
								if (((1983 + 2476) > (1765 - (663 + 511))) and v92.Avatar:IsCastable() and v31 and ((v52 and v29) or not v52) and ((v92.TitansTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.AvatarBuff) and v92.OdynsFury:CooldownDown()) or (v92.BerserkersTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v97 < (18 + 2)))))) then
									if (((738 + 2660) >= (7383 - 4988)) and v23(v92.Avatar, not v100)) then
										return "avatar main 24";
									end
								end
								if ((v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and ((v92.Annihilator:IsAvailable() and (v92.ChampionsSpear:CooldownRemains() < (1 + 0))) or (v92.Avatar:CooldownRemains() > (94 - 54)) or not v92.Avatar:IsAvailable() or (v97 < (28 - 16)))) or ((1042 + 1141) >= (5496 - 2672))) then
									if (((1380 + 556) == (177 + 1759)) and v23(v92.Recklessness, not v100)) then
										return "recklessness main 26";
									end
								end
								v180 = 723 - (478 + 244);
							end
						end
					end
					v153 = 519 - (440 + 77);
				end
				if ((v153 == (0 + 0)) or ((17685 - 12853) < (5869 - (655 + 901)))) then
					if (((759 + 3329) > (2966 + 908)) and v35 and v92.Charge:IsCastable()) then
						if (((2926 + 1406) == (17451 - 13119)) and v23(v92.Charge, not v14:IsSpellInRange(v92.Charge))) then
							return "charge main 2";
						end
					end
					v154 = v91.HandleDPSPotion(v14:BuffUp(v92.RecklessnessBuff));
					if (((5444 - (695 + 750)) >= (9902 - 7002)) and v154) then
						return v154;
					end
					if ((v90 < v97) or ((3896 - 1371) > (16344 - 12280))) then
						if (((4722 - (285 + 66)) == (10188 - 5817)) and v51 and ((v29 and v59) or not v59)) then
							v26 = v103();
							if (v26 or ((1576 - (682 + 628)) > (804 + 4182))) then
								return v26;
							end
						end
						if (((2290 - (176 + 123)) >= (387 + 538)) and v29 and v93.FyralathTheDreamrender:IsEquippedAndReady() and v30) then
							if (((331 + 124) < (2322 - (239 + 30))) and v23(v94.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					v153 = 1 + 0;
				end
				if ((v153 == (3 + 0)) or ((1461 - 635) == (15134 - 10283))) then
					if (((498 - (306 + 9)) == (638 - 455)) and v26) then
						return v26;
					end
					break;
				end
			end
		end
	end
	local function v109()
		v30 = EpicSettings.Settings['useWeapon'];
		v32 = EpicSettings.Settings['useBattleShout'];
		v33 = EpicSettings.Settings['useBloodbath'];
		v34 = EpicSettings.Settings['useBloodthirst'];
		v35 = EpicSettings.Settings['useCharge'];
		v36 = EpicSettings.Settings['useCrushingBlow'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v40 = EpicSettings.Settings['useOnslaught'];
		v41 = EpicSettings.Settings['useRagingBlow'];
		v42 = EpicSettings.Settings['useRampage'];
		v45 = EpicSettings.Settings['useSlam'];
		v48 = EpicSettings.Settings['useWhirlwind'];
		v49 = EpicSettings.Settings['useWreckingThrow'];
		v31 = EpicSettings.Settings['useAvatar'];
		v39 = EpicSettings.Settings['useOdynsFury'];
		v43 = EpicSettings.Settings['useRavager'];
		v44 = EpicSettings.Settings['useRecklessness'];
		v46 = EpicSettings.Settings['useChampionsSpear'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v52 = EpicSettings.Settings['avatarWithCD'];
		v53 = EpicSettings.Settings['odynFuryWithCD'];
		v54 = EpicSettings.Settings['ravagerWithCD'];
		v55 = EpicSettings.Settings['recklessnessWithCD'];
		v56 = EpicSettings.Settings['championsSpearWithCD'];
		v57 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v110()
		local v149 = 0 + 0;
		while true do
			if (((712 + 447) <= (861 + 927)) and ((0 - 0) == v149)) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v149 = 1376 - (1140 + 235);
			end
			if ((v149 == (3 + 1)) or ((3216 + 291) > (1109 + 3209))) then
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (52 - (33 + 19));
				v81 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v83 = EpicSettings.Settings['ravagerSetting'] or "player";
				v149 = 3 + 2;
			end
			if (((5 - 2) == v149) or ((2884 + 191) <= (3654 - (586 + 103)))) then
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (1488 - (1309 + 179));
				v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v149 = 2 + 2;
			end
			if (((3665 - 2300) <= (1519 + 492)) and ((3 - 1) == v149)) then
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v73 = EpicSettings.Settings['enragedRegenerationHP'] or (609 - (295 + 314));
				v149 = 6 - 3;
			end
			if (((1963 - (1300 + 662)) == v149) or ((8716 - 5940) > (5330 - (1178 + 577)))) then
				v64 = EpicSettings.Settings['useEnragedRegeneration'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v67 = EpicSettings.Settings['useIntervene'];
				v149 = 2 + 0;
			end
			if ((v149 == (14 - 9)) or ((3959 - (851 + 554)) == (4249 + 555))) then
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
		end
	end
	local function v111()
		local v150 = 0 - 0;
		while true do
			if (((5596 - 3019) == (2879 - (115 + 187))) and (v150 == (4 + 0))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v150 == (3 + 0)) or ((23 - 17) >= (3050 - (160 + 1001)))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v150 = 7 - 3;
			end
			if (((864 - (237 + 121)) <= (2789 - (525 + 372))) and ((3 - 1) == v150)) then
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v150 = 9 - 6;
			end
			if ((v150 == (143 - (96 + 46))) or ((2785 - (643 + 134)) > (801 + 1417))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v51 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v150 = 4 - 2;
			end
			if (((1406 - 1027) <= (3978 + 169)) and ((0 - 0) == v150)) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v150 = 720 - (316 + 403);
			end
		end
	end
	local function v112()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (0 - 0)) or ((1632 + 2882) <= (2540 - 1531))) then
				v110();
				v109();
				v111();
				v151 = 1 + 0;
			end
			if ((v151 == (1 + 1)) or ((12113 - 8617) == (5692 - 4500))) then
				if (v13:IsDeadOrGhost() or ((431 - 223) == (170 + 2789))) then
					return v26;
				end
				if (((8419 - 4142) >= (65 + 1248)) and v28) then
					v98 = v13:GetEnemiesInMeleeRange(23 - 15);
					v99 = #v98;
				else
					v99 = 18 - (12 + 5);
				end
				v100 = v14:IsInMeleeRange(19 - 14);
				v151 = 5 - 2;
			end
			if (((5498 - 2911) < (7870 - 4696)) and (v151 == (1 + 0))) then
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v151 = 1975 - (1656 + 317);
			end
			if ((v151 == (3 + 0)) or ((3302 + 818) <= (5844 - 3646))) then
				if (v91.TargetIsValid() or v13:AffectingCombat() or ((7854 - 6258) == (1212 - (5 + 349)))) then
					local v179 = 0 - 0;
					while true do
						if (((4491 - (266 + 1005)) == (2122 + 1098)) and (v179 == (3 - 2))) then
							if ((v97 == (14628 - 3517)) or ((3098 - (561 + 1135)) > (4717 - 1097))) then
								v97 = v9.FightRemains(v98, false);
							end
							break;
						end
						if (((8460 - 5886) == (3640 - (507 + 559))) and (v179 == (0 - 0))) then
							v96 = v9.BossFightRemains(nil, true);
							v97 = v96;
							v179 = 3 - 2;
						end
					end
				end
				if (((2186 - (212 + 176)) < (3662 - (250 + 655))) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((1028 - 651) > (4549 - 1945))) then
						v26 = v108();
						if (((888 - 320) < (2867 - (1869 + 87))) and v26) then
							return v26;
						end
					else
						v26 = v105();
						if (((11393 - 8108) < (6129 - (484 + 1417))) and v26) then
							return v26;
						end
					end
				end
				break;
			end
		end
	end
	local function v113()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(154 - 82, v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

