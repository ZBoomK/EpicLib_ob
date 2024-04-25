local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5710 - (605 + 728)) > (1172 + 470)) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if (((217 + 4506) > (5013 - 3657)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((11458 - 7322) <= (2593 + 840))) then
				return v1(v4, ...);
			end
			v5 = 490 - (457 + 32);
		end
	end
end
v0["Epix_Shaman_RestoShaman.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Utils;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.Macro;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = math.min;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v119 = 4715 + 6396;
	local v120 = 12513 - (832 + 570);
	local v121;
	v10:RegisterForEvent(function()
		local v141 = 0 + 0;
		while true do
			if (((1107 + 3138) <= (16388 - 11757)) and (v141 == (0 + 0))) then
				v119 = 11907 - (588 + 208);
				v120 = 29946 - 18835;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v122 = v18.Shaman.Restoration;
	local v123 = v25.Shaman.Restoration;
	local v124 = v20.Shaman.Restoration;
	local v125 = {};
	local v126 = v22.Commons.Everyone;
	local v127 = v22.Commons.Shaman;
	local function v128()
		if (((6076 - (884 + 916)) >= (8193 - 4279)) and v122.ImprovedPurifySpirit:IsAvailable()) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v142)
		return v142:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (3 + 2));
	end
	local function v130()
		if (((851 - (232 + 421)) <= (6254 - (1569 + 320))) and v93 and v122.AstralShift:IsReady()) then
			if (((1174 + 3608) > (889 + 3787)) and (v13:HealthPercentage() <= v59)) then
				if (((16390 - 11526) > (2802 - (316 + 289))) and v24(v122.AstralShift, not v15:IsInRange(104 - 64))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v96 and v122.EarthElemental:IsReady()) or ((171 + 3529) == (3960 - (666 + 787)))) then
			if (((4899 - (360 + 65)) >= (257 + 17)) and ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 279 - (79 + 175), v122.ChainHeal))) then
				if (v24(v122.EarthElemental, not v15:IsInRange(63 - 23)) or ((1478 + 416) <= (4309 - 2903))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((3026 - 1454) >= (2430 - (503 + 396))) and v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (v24(v123.Healthstone) or ((4868 - (92 + 89)) < (8810 - 4268))) then
				return "healthstone defensive 3";
			end
		end
		if (((1688 + 1603) > (987 + 680)) and v38 and (v13:HealthPercentage() <= v39)) then
			if ((v40 == "Refreshing Healing Potion") or ((3418 - 2545) == (279 + 1755))) then
				if (v124.RefreshingHealingPotion:IsReady() or ((6420 - 3604) < (10 + 1))) then
					if (((1767 + 1932) < (14332 - 9626)) and v24(v123.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((331 + 2315) >= (1335 - 459)) and (v40 == "Dreamwalker's Healing Potion")) then
				if (((1858 - (485 + 759)) <= (7367 - 4183)) and v124.DreamwalkersHealingPotion:IsReady()) then
					if (((4315 - (442 + 747)) == (4261 - (832 + 303))) and v24(v123.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v131()
		if (v114 or ((3133 - (88 + 858)) >= (1510 + 3444))) then
			v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 25 + 5, true);
			if (v29 or ((160 + 3717) == (4364 - (766 + 23)))) then
				return v29;
			end
		end
		if (((3490 - 2783) > (863 - 231)) and v113) then
			v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 79 - 49);
			if (v29 or ((1853 - 1307) >= (3757 - (1036 + 37)))) then
				return v29;
			end
			if (((1039 + 426) <= (8375 - 4074)) and v115) then
				local v246 = 0 + 0;
				while true do
					if (((3184 - (641 + 839)) > (2338 - (910 + 3))) and (v246 == (0 - 0))) then
						v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 1714 - (1466 + 218));
						if (v29 or ((316 + 371) == (5382 - (556 + 592)))) then
							return v29;
						end
						break;
					end
				end
			end
			if (v116 or ((1185 + 2145) < (2237 - (329 + 479)))) then
				local v247 = 854 - (174 + 680);
				while true do
					if (((3941 - 2794) >= (694 - 359)) and (v247 == (0 + 0))) then
						v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 769 - (396 + 343));
						if (((304 + 3131) > (3574 - (29 + 1448))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if (v122.PurifySpirit:CooldownRemains() or ((5159 - (135 + 1254)) >= (15223 - 11182))) then
				v29 = v126.HandleAfflicted(v122.HealingSurge, v123.HealingSurgeMouseover, 140 - 110);
				if (v29 or ((2527 + 1264) <= (3138 - (389 + 1138)))) then
					return v29;
				end
			end
		end
		if (v41 or ((5152 - (102 + 472)) <= (1895 + 113))) then
			v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 23 + 17);
			if (((1049 + 76) <= (3621 - (320 + 1225))) and v29) then
				return v29;
			end
			v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 71 - 31);
			if (v29 or ((455 + 288) >= (5863 - (157 + 1307)))) then
				return v29;
			end
		end
		if (((3014 - (821 + 1038)) < (4174 - 2501)) and v42) then
			local v153 = 0 + 0;
			while true do
				if ((v153 == (0 - 0)) or ((865 + 1459) <= (1432 - 854))) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 1066 - (834 + 192));
					if (((240 + 3527) == (967 + 2800)) and v29) then
						return v29;
					end
					v153 = 1 + 0;
				end
				if (((6334 - 2245) == (4393 - (300 + 4))) and (v153 == (1 + 2))) then
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 104 - 64);
					if (((4820 - (112 + 250)) >= (668 + 1006)) and v29) then
						return v29;
					end
					break;
				end
				if (((2434 - 1462) <= (813 + 605)) and (v153 == (2 + 0))) then
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 30 + 10);
					if (v29 or ((2449 + 2489) < (3538 + 1224))) then
						return v29;
					end
					v153 = 1417 - (1001 + 413);
				end
				if ((v153 == (2 - 1)) or ((3386 - (244 + 638)) > (4957 - (627 + 66)))) then
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 119 - 79);
					if (((2755 - (512 + 90)) == (4059 - (1665 + 241))) and v29) then
						return v29;
					end
					v153 = 719 - (373 + 344);
				end
			end
		end
		if (v43 or ((229 + 278) >= (686 + 1905))) then
			v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 105 - 65);
			if (((7582 - 3101) == (5580 - (35 + 1064))) and v29) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 30 + 10);
			if (v29 or ((4980 - 2652) < (3 + 690))) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 1276 - (298 + 938));
			if (((5587 - (233 + 1026)) == (5994 - (636 + 1030))) and v29) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 21 + 19);
			if (((1552 + 36) >= (396 + 936)) and v29) then
				return v29;
			end
		end
		if (v44 or ((283 + 3891) > (4469 - (55 + 166)))) then
			local v154 = 0 + 0;
			while true do
				if ((v154 == (1 + 1)) or ((17514 - 12928) <= (379 - (36 + 261)))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 69 - 29);
					if (((5231 - (34 + 1334)) == (1486 + 2377)) and v29) then
						return v29;
					end
					v154 = 3 + 0;
				end
				if ((v154 == (1283 - (1035 + 248))) or ((303 - (20 + 1)) <= (22 + 20))) then
					v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 359 - (134 + 185));
					if (((5742 - (549 + 584)) >= (1451 - (314 + 371))) and v29) then
						return v29;
					end
					v154 = 3 - 2;
				end
				if ((v154 == (971 - (478 + 490))) or ((611 + 541) == (3660 - (786 + 386)))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 129 - 89);
					if (((4801 - (1055 + 324)) > (4690 - (1093 + 247))) and v29) then
						return v29;
					end
					break;
				end
				if (((780 + 97) > (40 + 336)) and (v154 == (3 - 2))) then
					v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 135 - 95);
					if (v29 or ((8871 - 5753) <= (4651 - 2800))) then
						return v29;
					end
					v154 = 1 + 1;
				end
			end
		end
	end
	local function v132()
		if ((v111 and ((v31 and v110) or not v110)) or ((635 - 470) >= (12036 - 8544))) then
			local v155 = 0 + 0;
			while true do
				if (((10098 - 6149) < (5544 - (364 + 324))) and (v155 == (0 - 0))) then
					v29 = v126.HandleTopTrinket(v125, v31, 95 - 55, nil);
					if (v29 or ((1418 + 2858) < (12619 - 9603))) then
						return v29;
					end
					v155 = 1 - 0;
				end
				if (((14244 - 9554) > (5393 - (1249 + 19))) and (v155 == (1 + 0))) then
					v29 = v126.HandleBottomTrinket(v125, v31, 155 - 115, nil);
					if (v29 or ((1136 - (686 + 400)) >= (704 + 192))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1943 - (73 + 156)) >= (14 + 2944))) then
			if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((2302 - (721 + 90)) < (8 + 636))) then
				if (((2285 - 1581) < (1457 - (224 + 246))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingcd tank";
				end
			end
		end
		if (((6022 - 2304) > (3509 - 1603)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if ((v17:HealthPercentage() <= v83) or ((174 + 784) > (87 + 3548))) then
				if (((2572 + 929) <= (8930 - 4438)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) or ((11454 - 8012) < (3061 - (203 + 310)))) then
			if (((4868 - (1238 + 755)) >= (103 + 1361)) and (v87 == "Player")) then
				if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(1574 - (709 + 825))) or ((8839 - 4042) >= (7126 - 2233))) then
					return "spirit_link_totem cooldowns";
				end
			elseif ((v87 == "Friendly under Cursor") or ((1415 - (196 + 668)) > (8164 - 6096))) then
				if (((4378 - 2264) > (1777 - (171 + 662))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(133 - (4 + 89))) or ((7928 - 5666) >= (1128 + 1968))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v87 == "Confirmation") or ((9904 - 7649) >= (1388 + 2149))) then
				if (v24(v122.SpiritLinkTotem, not v15:IsInRange(1526 - (35 + 1451))) or ((5290 - (28 + 1425)) < (3299 - (941 + 1052)))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((2829 + 121) == (4464 - (822 + 692))) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) then
			if (v24(v122.HealingTideTotem, not v15:IsInRange(57 - 17)) or ((2225 + 2498) < (3595 - (45 + 252)))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((1124 + 12) >= (53 + 101)) and v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) then
			if ((v56 == "Player") or ((659 - 388) > (5181 - (114 + 319)))) then
				if (((6805 - 2065) >= (4038 - 886)) and v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(26 + 14))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v56 == "Friendly under Cursor") or ((3840 - 1262) >= (7102 - 3712))) then
				if (((2004 - (556 + 1407)) <= (2867 - (741 + 465))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((1066 - (170 + 295)) < (1876 + 1684)) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(37 + 3))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((578 - 343) < (570 + 117)) and (v56 == "Confirmation")) then
				if (((2918 + 1631) > (653 + 500)) and v24(v122.AncestralProtectionTotem, not v15:IsInRange(1270 - (957 + 273)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) or ((1251 + 3423) < (1871 + 2801))) then
			if (((13976 - 10308) < (12019 - 7458)) and v24(v122.AncestralGuidance, not v15:IsInRange(122 - 82))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if ((v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) or ((2253 - 1798) == (5385 - (389 + 1391)))) then
			if (v24(v122.Ascendance, not v15:IsInRange(26 + 14)) or ((278 + 2385) == (7539 - 4227))) then
				return "ascendance cooldowns";
			end
		end
		if (((5228 - (783 + 168)) <= (15018 - 10543)) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
			if (v24(v122.ManaTideTotem, not v15:IsInRange(40 + 0)) or ((1181 - (309 + 2)) == (3651 - 2462))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((2765 - (1090 + 122)) <= (1016 + 2117)) and v35 and ((v109 and v31) or not v109)) then
			local v156 = 0 - 0;
			while true do
				if (((0 + 0) == v156) or ((3355 - (628 + 490)) >= (630 + 2881))) then
					if (v122.AncestralCall:IsReady() or ((3277 - 1953) > (13801 - 10781))) then
						if (v24(v122.AncestralCall, not v15:IsInRange(814 - (431 + 343))) or ((6042 - 3050) == (5441 - 3560))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((2454 + 652) > (196 + 1330)) and v122.BagofTricks:IsReady()) then
						if (((4718 - (556 + 1139)) < (3885 - (6 + 9))) and v24(v122.BagofTricks, not v15:IsInRange(8 + 32))) then
							return "BagofTricks cooldowns";
						end
					end
					v156 = 1 + 0;
				end
				if (((312 - (28 + 141)) > (29 + 45)) and ((2 - 0) == v156)) then
					if (((13 + 5) < (3429 - (486 + 831))) and v122.Fireblood:IsReady()) then
						if (((2854 - 1757) <= (5731 - 4103)) and v24(v122.Fireblood, not v15:IsInRange(8 + 32))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
				if (((14639 - 10009) == (5893 - (668 + 595))) and (v156 == (1 + 0))) then
					if (((714 + 2826) > (7316 - 4633)) and v122.Berserking:IsReady()) then
						if (((5084 - (23 + 267)) >= (5219 - (1129 + 815))) and v24(v122.Berserking, not v15:IsInRange(427 - (371 + 16)))) then
							return "Berserking cooldowns";
						end
					end
					if (((3234 - (1326 + 424)) == (2810 - 1326)) and v122.BloodFury:IsReady()) then
						if (((5232 - 3800) < (3673 - (88 + 30))) and v24(v122.BloodFury, not v15:IsInRange(811 - (720 + 51)))) then
							return "BloodFury cooldowns";
						end
					end
					v156 = 4 - 2;
				end
			end
		end
	end
	local function v133()
		local v143 = 1776 - (421 + 1355);
		while true do
			if ((v143 == (1 - 0)) or ((524 + 541) > (4661 - (286 + 797)))) then
				if ((v105 and v122.UnleashLife:IsReady()) or ((17528 - 12733) < (2330 - 923))) then
					if (((2292 - (397 + 42)) < (1504 + 3309)) and (v13:HealthPercentage() <= v90)) then
						if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((3621 - (24 + 776)) < (3744 - 1313))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) or ((3659 - (222 + 563)) < (4805 - 2624))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(29 + 11), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2879 - (23 + 167)) <= (2141 - (690 + 1108)))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) or ((675 + 1194) == (1658 + 351))) then
					if ((v74 == "Player") or ((4394 - (40 + 808)) < (383 + 1939))) then
						if (v24(v123.HealingRainPlayer, not v15:IsInRange(152 - 112), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1990 + 92) == (2526 + 2247))) then
							return "healing_rain healingaoe";
						end
					elseif (((1779 + 1465) > (1626 - (47 + 524))) and (v74 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2150 + 1163) <= (4860 - 3082))) then
							if (v24(v123.HealingRainCursor, not v15:IsInRange(59 - 19), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3240 - 1819) >= (3830 - (1165 + 561)))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((54 + 1758) <= (10062 - 6813)) and (v74 == "Enemy under Cursor")) then
						if (((620 + 1003) <= (2436 - (341 + 138))) and v16:Exists() and v13:CanAttack(v16)) then
							if (((1191 + 3221) == (9104 - 4692)) and v24(v123.HealingRainCursor, not v15:IsInRange(366 - (89 + 237)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((5629 - 3879) >= (1772 - 930)) and (v74 == "Confirmation")) then
						if (((5253 - (581 + 300)) > (3070 - (855 + 365))) and v24(v122.HealingRain, not v15:IsInRange(95 - 55), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((76 + 156) < (2056 - (1030 + 205))) and v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) then
					if (((487 + 31) < (840 + 62)) and (v71 == "Player")) then
						if (((3280 - (156 + 130)) > (1949 - 1091)) and v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(67 - 27))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v71 == "Friendly under Cursor") or ((7690 - 3935) <= (242 + 673))) then
						if (((2302 + 1644) > (3812 - (10 + 59))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(12 + 28)) or ((6574 - 5239) >= (4469 - (671 + 492)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((3857 + 987) > (3468 - (369 + 846))) and (v71 == "Confirmation")) then
						if (((120 + 332) == (386 + 66)) and v24(v122.EarthenWallTotem, not v15:IsInRange(1985 - (1036 + 909)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v143 = 2 + 0;
			end
			if ((v143 == (0 - 0)) or ((4760 - (11 + 192)) < (1055 + 1032))) then
				if (((4049 - (135 + 40)) == (9386 - 5512)) and v94 and v126.AreUnitsBelowHealthPercentage(58 + 37, 6 - 3, v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
					if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2905 - 967) > (5111 - (50 + 126)))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (41 - 26))) or ((942 + 3313) < (4836 - (1233 + 180)))) then
					if (((2423 - (522 + 447)) <= (3912 - (107 + 1314))) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1930 + 2227) <= (8540 - 5737))) then
					if (((2062 + 2791) >= (5921 - 2939)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (((16356 - 12222) > (5267 - (716 + 1194))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((59 + 3358) < (272 + 2262))) then
					if ((v17:HealthPercentage() <= v83) or ((3225 - (74 + 429)) <= (315 - 151))) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((1194 + 1214) < (4827 - 2718))) then
							return "riptide healingaoe";
						end
					end
				end
				v143 = 1 + 0;
			end
			if ((v143 == (8 - 5)) or ((81 - 48) == (1888 - (279 + 154)))) then
				if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) or ((1221 - (454 + 324)) >= (3159 + 856))) then
					if (((3399 - (12 + 5)) > (90 + 76)) and v24(v122.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) or ((713 - 433) == (1131 + 1928))) then
					if (((2974 - (277 + 816)) > (5524 - 4231)) and v24(v122.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((3540 - (1058 + 125)) == (442 + 1915)) and (v143 == (977 - (815 + 160)))) then
				if (((527 - 404) == (291 - 168)) and v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) then
					if ((v66 == "Player") or ((252 + 804) >= (9915 - 6523))) then
						if (v24(v123.DownpourPlayer, not v15:IsInRange(1938 - (41 + 1857)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2974 - (1222 + 671)) < (2778 - 1703))) then
							return "downpour healingaoe";
						end
					elseif ((v66 == "Friendly under Cursor") or ((1507 - 458) >= (5614 - (229 + 953)))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((6542 - (1111 + 663)) <= (2425 - (874 + 705)))) then
							if (v24(v123.DownpourCursor, not v15:IsInRange(6 + 34), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2292 + 1066) <= (2951 - 1531))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v66 == "Confirmation") or ((106 + 3633) <= (3684 - (642 + 37)))) then
						if (v24(v122.Downpour, not v15:IsInRange(10 + 30), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((266 + 1393) >= (5357 - 3223))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (464 - (233 + 221)))) or ((7538 - 4278) < (2073 + 282))) then
					if (v24(v122.CloudburstTotem) or ((2210 - (718 + 823)) == (2658 + 1565))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) or ((2497 - (266 + 539)) < (1664 - 1076))) then
					if (v24(v122.Wellspring, not v15:IsInRange(1265 - (636 + 589)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((11386 - 6589) < (7530 - 3879))) then
						return "wellspring healingaoe";
					end
				end
				if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) or ((3311 + 866) > (1762 + 3088))) then
					if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1415 - (657 + 358)) > (2941 - 1830))) then
						return "chain_heal healingaoe";
					end
				end
				v143 = 6 - 3;
			end
		end
	end
	local function v134()
		if (((4238 - (1151 + 36)) > (971 + 34)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((971 + 2722) <= (13086 - 8704)) and (v17:HealthPercentage() <= v83)) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((5114 - (1552 + 280)) > (4934 - (64 + 770)))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((2431 + 1149) < (6455 - 3611))) then
			if (((16 + 73) < (5733 - (157 + 1086))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((9973 - 4990) < (7918 - 6110))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((5872 - 2043) > (5143 - 1374)) and v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) then
			if (((2304 - (599 + 220)) <= (5782 - 2878)) and v24(v122.EarthShield)) then
				return "earth_shield player healingst";
			end
		end
		if (((6200 - (1813 + 118)) == (3121 + 1148)) and v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) then
			if (((1604 - (841 + 376)) <= (3897 - 1115)) and v126.IsSoloMode()) then
				if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((442 + 1457) <= (2502 - 1585))) then
					if (v24(v122.LightningShield) or ((5171 - (464 + 395)) <= (2248 - 1372))) then
						return "lightning_shield healingst";
					end
				end
			elseif (((1072 + 1160) <= (3433 - (467 + 370))) and v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) then
				if (((4328 - 2233) < (2706 + 980)) and v24(v122.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v99 and v122.HealingSurge:IsReady()) or ((5467 - 3872) >= (698 + 3776))) then
			if ((v17:HealthPercentage() <= v77) or ((10745 - 6126) < (3402 - (150 + 370)))) then
				if (v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1576 - (74 + 1208)) >= (11882 - 7051))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((9622 - 7593) <= (2195 + 889)) and v101 and v122.HealingWave:IsReady()) then
			if ((v17:HealthPercentage() <= v80) or ((2427 - (14 + 376)) == (4197 - 1777))) then
				if (((2885 + 1573) > (3430 + 474)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v135()
		if (((416 + 20) >= (360 - 237)) and v122.Stormkeeper:IsReady()) then
			if (((377 + 123) < (1894 - (23 + 55))) and v24(v122.Stormkeeper, not v15:IsInRange(94 - 54))) then
				return "stormkeeper damage";
			end
		end
		if (((2385 + 1189) == (3210 + 364)) and (math.max(#v13:GetEnemiesInRange(31 - 11), v13:GetEnemiesInSplashRangeCount(3 + 5)) > (903 - (652 + 249)))) then
			if (((591 - 370) < (2258 - (708 + 1160))) and v122.ChainLightning:IsReady()) then
				if (v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((6006 - 3793) <= (2590 - 1169))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((3085 - (10 + 17)) < (1092 + 3768)) and v122.FlameShock:IsReady()) then
			if (v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(1772 - (1400 + 332)), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil) or ((2485 - 1189) >= (6354 - (242 + 1666)))) then
				return "flame_shock_cycle damage";
			end
			if (v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock)) or ((597 + 796) > (1646 + 2843))) then
				return "flame_shock damage";
			end
		end
		if (v122.LavaBurst:IsReady() or ((3771 + 653) < (967 - (850 + 90)))) then
			if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3497 - 1500) > (5205 - (360 + 1030)))) then
				return "lava_burst damage";
			end
		end
		if (((3067 + 398) > (5398 - 3485)) and v122.LightningBolt:IsReady()) then
			if (((1007 - 274) < (3480 - (909 + 752))) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v136()
		local v144 = 1223 - (109 + 1114);
		while true do
			if ((v144 == (16 - 7)) or ((1711 + 2684) == (4997 - (6 + 236)))) then
				v94 = EpicSettings.Settings['UseChainHeal'];
				v95 = EpicSettings.Settings['UseCloudburstTotem'];
				v97 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v144 = 7 + 3;
			end
			if ((v144 == (5 + 1)) or ((8945 - 5152) < (4137 - 1768))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v144 = 1140 - (1076 + 57);
			end
			if ((v144 == (2 + 6)) or ((4773 - (579 + 110)) == (21 + 244))) then
				v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v90 = EpicSettings.Settings['UnleashLifeHP'];
				v144 = 8 + 1;
			end
			if (((2313 + 2045) == (4765 - (174 + 233))) and (v144 == (33 - 21))) then
				v105 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v144 == (1 - 0)) or ((1396 + 1742) < (2167 - (663 + 511)))) then
				v61 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v46 = EpicSettings.Settings['DispelBuffs'];
				v64 = EpicSettings.Settings['DownpourGroup'];
				v144 = 2 + 0;
			end
			if (((723 + 2607) > (7161 - 4838)) and (v144 == (0 + 0))) then
				v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v60 = EpicSettings.Settings['ChainHealGroup'];
				v144 = 2 - 1;
			end
			if ((v144 == (12 - 7)) or ((1731 + 1895) == (7763 - 3774))) then
				v77 = EpicSettings.Settings['HealingSurgeHP'];
				v78 = EpicSettings.Settings['HealingTideTotemGroup'];
				v79 = EpicSettings.Settings['HealingTideTotemHP'];
				v80 = EpicSettings.Settings['HealingWaveHP'];
				v144 = 5 + 1;
			end
			if ((v144 == (2 + 9)) or ((1638 - (478 + 244)) == (3188 - (440 + 77)))) then
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v103 = EpicSettings.Settings['UseRiptide'];
				v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v144 = 6 + 6;
			end
			if (((995 - 723) == (1828 - (655 + 901))) and (v144 == (1 + 3))) then
				v73 = EpicSettings.Settings['HealingRainHP'];
				v74 = EpicSettings.Settings['HealingRainUsage'];
				v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v76 = EpicSettings.Settings['HealingStreamTotemHP'];
				v144 = 4 + 1;
			end
			if (((2870 + 1379) <= (19494 - 14655)) and (v144 == (1455 - (695 + 750)))) then
				v98 = EpicSettings.Settings['UseHealingStreamTotem'];
				v99 = EpicSettings.Settings['UseHealingSurge'];
				v100 = EpicSettings.Settings['UseHealingTideTotem'];
				v101 = EpicSettings.Settings['UseHealingWave'];
				v144 = 37 - 26;
			end
			if (((4285 - 1508) < (12869 - 9669)) and (v144 == (353 - (285 + 66)))) then
				v65 = EpicSettings.Settings['DownpourHP'];
				v66 = EpicSettings.Settings['DownpourUsage'];
				v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v70 = EpicSettings.Settings['EarthenWallTotemHP'];
				v144 = 6 - 3;
			end
			if (((1405 - (682 + 628)) < (316 + 1641)) and (v144 == (306 - (176 + 123)))) then
				v83 = EpicSettings.Settings['RiptideHP'];
				v84 = EpicSettings.Settings['RiptideTankHP'];
				v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v144 = 4 + 4;
			end
			if (((600 + 226) < (1986 - (239 + 30))) and (v144 == (1 + 2))) then
				v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v72 = EpicSettings.Settings['HealingRainGroup'];
				v144 = 4 + 0;
			end
		end
	end
	local function v137()
		local v145 = 0 - 0;
		while true do
			if (((4448 - 3022) >= (1420 - (306 + 9))) and (v145 == (13 - 9))) then
				v106 = EpicSettings.Settings['UseWellspring'];
				v107 = EpicSettings.Settings['WellspringGroup'];
				v108 = EpicSettings.Settings['WellspringHP'];
				v117 = EpicSettings.Settings['useManaPotion'];
				v145 = 1 + 4;
			end
			if (((1690 + 1064) <= (1627 + 1752)) and (v145 == (19 - 12))) then
				v114 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v145 = 1383 - (1140 + 235);
			end
			if ((v145 == (4 + 2)) or ((3602 + 325) == (363 + 1050))) then
				v111 = EpicSettings.Settings['useTrinkets'];
				v112 = EpicSettings.Settings['fightRemainsCheck'];
				v51 = EpicSettings.Settings['useWeapon'];
				v113 = EpicSettings.Settings['handleAfflicted'];
				v145 = 59 - (33 + 19);
			end
			if ((v145 == (2 + 1)) or ((3458 - 2304) <= (348 + 440))) then
				v92 = EpicSettings.Settings['UseAscendance'];
				v93 = EpicSettings.Settings['UseAstralShift'];
				v96 = EpicSettings.Settings['UseEarthElemental'];
				v102 = EpicSettings.Settings['UseManaTideTotem'];
				v145 = 7 - 3;
			end
			if ((v145 == (8 + 0)) or ((2332 - (586 + 103)) > (308 + 3071))) then
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((5 - 3) == v145) or ((4291 - (1309 + 179)) > (8211 - 3662))) then
				v68 = EpicSettings.Settings['EarthElementalTankHP'];
				v81 = EpicSettings.Settings['ManaTideTotemMana'];
				v82 = EpicSettings.Settings['PrimordialWaveHP'];
				v91 = EpicSettings.Settings['UseAncestralGuidance'];
				v145 = 2 + 1;
			end
			if (((2 - 1) == v145) or ((167 + 53) >= (6420 - 3398))) then
				v59 = EpicSettings.Settings['AstralShiftHP'];
				v62 = EpicSettings.Settings['CloudburstTotemGroup'];
				v63 = EpicSettings.Settings['CloudburstTotemHP'];
				v67 = EpicSettings.Settings['EarthElementalHP'];
				v145 = 3 - 1;
			end
			if (((3431 - (295 + 314)) == (6931 - 4109)) and ((1962 - (1300 + 662)) == v145)) then
				v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v53 = EpicSettings.Settings['AncestralGuidanceHP'];
				v57 = EpicSettings.Settings['AscendanceGroup'];
				v58 = EpicSettings.Settings['AscendanceHP'];
				v145 = 3 - 2;
			end
			if ((v145 == (1760 - (1178 + 577))) or ((552 + 509) == (5489 - 3632))) then
				v118 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v110 = EpicSettings.Settings['trinketsWithCD'];
				v145 = 1411 - (851 + 554);
			end
		end
	end
	local v138 = 0 + 0;
	local function v139()
		local v146 = 0 - 0;
		local v147;
		while true do
			if (((5994 - 3234) > (1666 - (115 + 187))) and ((0 + 0) == v146)) then
				v136();
				v137();
				v30 = EpicSettings.Toggles['ooc'];
				v146 = 1 + 0;
			end
			if ((v146 == (15 - 11)) or ((6063 - (160 + 1001)) <= (3146 + 449))) then
				if (v147 or ((2658 + 1194) == (599 - 306))) then
					return v147;
				end
				if (v13:AffectingCombat() or v30 or ((1917 - (237 + 121)) == (5485 - (525 + 372)))) then
					local v248 = v45 and v122.PurifySpirit:IsReady() and v32;
					if ((v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 47 - 22) < (3 - 2))) or ((4626 - (96 + 46)) == (1565 - (643 + 134)))) then
						v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 6 + 9, 95 - 55, "TANK", true, 92 - 67, v122.ChainHeal);
						if (((4381 + 187) >= (7667 - 3760)) and v29) then
							return v29;
						end
						if (((2546 - 1300) < (4189 - (316 + 403))) and (v126.UnitGroupRole(v17) == "TANK")) then
							if (((2704 + 1364) >= (2672 - 1700)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					if (((179 + 314) < (9803 - 5910)) and (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 18 + 7) >= (1 + 0)))) then
						v29 = v126.FocusUnit(v248, nil, 138 - 98, nil, 119 - 94, v122.ChainHeal);
						if (v29 or ((3059 - 1586) >= (191 + 3141))) then
							return v29;
						end
					end
				end
				if ((v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(78 - 38) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) or ((198 + 3853) <= (3403 - 2246))) then
					if (((621 - (12 + 5)) < (11189 - 8308)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v146 = 10 - 5;
			end
			if ((v146 == (1 - 0)) or ((2231 - 1331) == (686 + 2691))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v146 = 1975 - (1656 + 317);
			end
			if (((3974 + 485) > (474 + 117)) and (v146 == (7 - 4))) then
				if (((16723 - 13325) >= (2749 - (5 + 349))) and (v126.TargetIsValid() or v13:AffectingCombat())) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (1272 - (266 + 1005))) or ((1439 + 744) >= (9635 - 6811))) then
							v120 = v119;
							if (((2548 - 612) == (3632 - (561 + 1135))) and (v120 == (14479 - 3368))) then
								v120 = v10.FightRemains(v121, false);
							end
							break;
						end
						if ((v249 == (0 - 0)) or ((5898 - (507 + 559)) < (10822 - 6509))) then
							v121 = v13:GetEnemiesInRange(123 - 83);
							v119 = v10.BossFightRemains(nil, true);
							v249 = 389 - (212 + 176);
						end
					end
				end
				if (((4993 - (250 + 655)) > (10563 - 6689)) and not v13:AffectingCombat()) then
					if (((7568 - 3236) == (6777 - 2445)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v251 = v126.DeadFriendlyUnitsCount();
						if (((5955 - (1869 + 87)) >= (10058 - 7158)) and (v251 > (1902 - (484 + 1417)))) then
							if (v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((5412 - 2887) > (6810 - 2746))) then
								return "ancestral_vision";
							end
						elseif (((5144 - (48 + 725)) == (7140 - 2769)) and v24(v123.AncestralSpiritMouseover, not v15:IsInRange(107 - 67), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v147 = v131();
				v146 = 3 + 1;
			end
			if ((v146 == (13 - 8)) or ((75 + 191) > (1454 + 3532))) then
				if (((2844 - (152 + 701)) >= (2236 - (430 + 881))) and v13:AffectingCombat() and v126.TargetIsValid()) then
					if (((175 + 280) < (2948 - (557 + 338))) and ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady())) then
						if (v24(v123.UseWeapon, nil) or ((245 + 581) == (13670 - 8819))) then
							return "Using Weapon Macro";
						end
					end
					if (((640 - 457) == (486 - 303)) and v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) then
						if (((2497 - 1338) <= (2589 - (499 + 302))) and v24(v123.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					v29 = v126.Interrupt(v122.WindShear, 896 - (39 + 827), true);
					if (v29 or ((9681 - 6174) > (9643 - 5325))) then
						return v29;
					end
					v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 119 - 89, true, v16);
					if (v29 or ((4720 - 1645) <= (254 + 2711))) then
						return v29;
					end
					v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 87 - 57, nil, v16);
					if (((219 + 1146) <= (3181 - 1170)) and v29) then
						return v29;
					end
					v147 = v130();
					if (v147 or ((2880 - (103 + 1)) > (4129 - (475 + 79)))) then
						return v147;
					end
					if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((5520 - 2966) == (15372 - 10568))) then
						if (((334 + 2243) == (2268 + 309)) and v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge))) then
							return "greater_purge utility";
						end
					end
					if ((v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((1509 - (1395 + 108)) >= (5496 - 3607))) then
						if (((1710 - (7 + 1197)) <= (825 + 1067)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
							return "purge utility";
						end
					end
					if ((v120 > v112) or ((701 + 1307) > (2537 - (27 + 292)))) then
						v147 = v132();
						if (((1110 - 731) <= (5288 - 1141)) and v147) then
							return v147;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((18930 - 14416) <= (1989 - 980))) then
					local v250 = 0 - 0;
					while true do
						if ((v250 == (141 - (43 + 96))) or ((14260 - 10764) == (2694 - 1502))) then
							if ((v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) or ((173 + 35) == (836 + 2123))) then
								if (((8452 - 4175) >= (504 + 809)) and v24(v122.NaturesSwiftness, nil)) then
									return "natures_swiftness main";
								end
							end
							if (((4847 - 2260) < (1000 + 2174)) and v33) then
								if ((v15:Exists() and not v13:CanAttack(v15)) or ((303 + 3817) <= (3949 - (1414 + 337)))) then
									local v253 = 1940 - (1642 + 298);
									while true do
										if ((v253 == (0 - 0)) or ((4591 - 2995) == (2546 - 1688))) then
											if (((1060 + 2160) == (2506 + 714)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
												if ((v15:HealthPercentage() <= v83) or ((2374 - (357 + 615)) > (2542 + 1078))) then
													if (((6315 - 3741) == (2206 + 368)) and v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide))) then
														return "riptide healing target";
													end
												end
											end
											if (((3852 - 2054) < (2206 + 551)) and v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) then
												if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((26 + 351) > (1637 + 967))) then
													return "unleash_life healing target";
												end
											end
											v253 = 1302 - (384 + 917);
										end
										if (((1265 - (128 + 569)) < (2454 - (1407 + 136))) and (v253 == (1888 - (687 + 1200)))) then
											if (((4995 - (556 + 1154)) < (14874 - 10646)) and v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) then
												if (((4011 - (9 + 86)) > (3749 - (275 + 146))) and v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
													return "chain_heal healing target";
												end
											end
											if (((407 + 2093) < (3903 - (29 + 35))) and v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) then
												if (((2246 - 1739) == (1514 - 1007)) and v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
													return "healing_wave healing target";
												end
											end
											break;
										end
									end
								end
								v147 = v133();
								if (((1059 - 819) <= (2062 + 1103)) and v147) then
									return v147;
								end
								v147 = v134();
								if (((1846 - (53 + 959)) >= (1213 - (312 + 96))) and v147) then
									return v147;
								end
							end
							v250 = 4 - 1;
						end
						if ((v250 == (285 - (147 + 138))) or ((4711 - (813 + 86)) < (2093 + 223))) then
							if ((v32 and v45) or ((4913 - 2261) <= (2025 - (18 + 474)))) then
								local v252 = 0 + 0;
								while true do
									if ((v252 == (0 - 0)) or ((4684 - (860 + 226)) < (1763 - (121 + 182)))) then
										if ((v122.Bursting:MaxDebuffStack() > (1 + 3)) or ((5356 - (988 + 252)) < (135 + 1057))) then
											v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
											if (v29 or ((1058 + 2319) <= (2873 - (49 + 1921)))) then
												return v29;
											end
										end
										if (((4866 - (223 + 667)) >= (491 - (51 + 1))) and v16 and v16:Exists() and v16:IsAPlayer()) then
											if (((6457 - 2705) == (8033 - 4281)) and v126.UnitHasPoisonDebuff(v16)) then
												if (((5171 - (146 + 979)) > (761 + 1934)) and v122.PoisonCleansingTotem:IsCastable()) then
													if (v24(v122.PoisonCleansingTotem, nil) or ((4150 - (311 + 294)) == (8915 - 5718))) then
														return "poison_cleansing_totem dispel mouseover";
													end
												end
											end
										end
										v252 = 1 + 0;
									end
									if (((3837 - (496 + 947)) > (1731 - (1233 + 125))) and (v252 == (1 + 0))) then
										if (((3728 + 427) <= (805 + 3427)) and v17 and v17:Exists() and v17:IsAPlayer() and (v126.UnitHasDispellableDebuffByPlayer(v17) or v126.DispellableFriendlyUnit(1670 - (963 + 682)) or v126.UnitHasMagicDebuff(v17) or (v126.UnitHasCurseDebuff(v17) and v122.ImprovedPurifySpirit:IsAvailable()))) then
											if (v122.PurifySpirit:IsCastable() or ((2989 + 592) == (4977 - (504 + 1000)))) then
												local v254 = 0 + 0;
												while true do
													if (((4549 + 446) > (316 + 3032)) and (v254 == (0 - 0))) then
														if ((v138 == (0 + 0)) or ((439 + 315) > (3906 - (156 + 26)))) then
															v138 = GetTime();
														end
														if (((126 + 91) >= (89 - 32)) and v126.Wait(664 - (149 + 15), v138)) then
															if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((3030 - (890 + 70)) >= (4154 - (39 + 78)))) then
																return "purify_spirit dispel focus";
															end
															v138 = 482 - (14 + 468);
														end
														break;
													end
												end
											end
										end
										if (((5948 - 3243) == (7560 - 4855)) and v16 and v16:Exists() and not v13:CanAttack(v16) and (v126.UnitHasDispellableDebuffByPlayer(v16) or v126.UnitHasMagicDebuff(v16) or (v126.UnitHasCurseDebuff(v16) and v122.ImprovedPurifySpirit:IsAvailable()))) then
											if (((32 + 29) == (37 + 24)) and v122.PurifySpirit:IsCastable()) then
												if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((149 + 550) >= (586 + 710))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							if ((v122.Bursting:AuraActiveCount() > (1 + 2)) or ((3412 - 1629) >= (3574 + 42))) then
								if (((v122.Bursting:MaxDebuffStack() > (17 - 12)) and v122.SpiritLinkTotem:IsReady()) or ((99 + 3814) > (4578 - (12 + 39)))) then
									if (((4072 + 304) > (2528 - 1711)) and (v87 == "Player")) then
										if (((17312 - 12451) > (245 + 579)) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(22 + 18))) then
											return "spirit_link_totem bursting";
										end
									elseif ((v87 == "Friendly under Cursor") or ((3506 - 2123) >= (1420 + 711))) then
										if ((v16:Exists() and not v13:CanAttack(v16)) or ((9066 - 7190) >= (4251 - (1596 + 114)))) then
											if (((4652 - 2870) <= (4485 - (164 + 549))) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(1478 - (1059 + 379)))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif ((v87 == "Confirmation") or ((5836 - 1136) < (422 + 391))) then
										if (((540 + 2659) < (4442 - (145 + 247))) and v24(v122.SpiritLinkTotem, not v15:IsInRange(33 + 7))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v94 and v122.ChainHeal:IsReady()) or ((2288 + 2663) < (13133 - 8703))) then
									if (((19 + 77) == (83 + 13)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
							end
							v250 = 1 - 0;
						end
						if ((v250 == (723 - (254 + 466))) or ((3299 - (544 + 16)) > (12737 - 8729))) then
							if (v34 or ((651 - (294 + 334)) == (1387 - (236 + 17)))) then
								if (v126.TargetIsValid() or ((1161 + 1532) >= (3201 + 910))) then
									v147 = v135();
									if (v147 or ((16254 - 11938) <= (10160 - 8014))) then
										return v147;
									end
								end
							end
							break;
						end
						if ((v250 == (1 + 0)) or ((2921 + 625) <= (3603 - (413 + 381)))) then
							if (((207 + 4697) > (4606 - 2440)) and v17:Exists() and (v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) then
								if (((282 - 173) >= (2060 - (582 + 1388))) and v122.PrimordialWaveResto:IsCastable()) then
									if (((8481 - 3503) > (2080 + 825)) and v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (367 - (326 + 38))))) or ((8951 - 5925) <= (3254 - 974))) then
								if (v24(v122.TotemicRecall, nil) or ((2273 - (47 + 573)) <= (391 + 717))) then
									return "totemic_recall main";
								end
							end
							v250 = 8 - 6;
						end
					end
				end
				break;
			end
			if (((4720 - 1811) > (4273 - (1269 + 395))) and (v146 == (494 - (76 + 416)))) then
				v34 = EpicSettings.Toggles['dps'];
				v147 = nil;
				if (((1200 - (319 + 124)) > (443 - 249)) and v13:IsDeadOrGhost()) then
					return;
				end
				v146 = 1010 - (564 + 443);
			end
		end
	end
	local function v140()
		local v148 = 0 - 0;
		while true do
			if ((v148 == (458 - (337 + 121))) or ((90 - 59) >= (4656 - 3258))) then
				v128();
				v122.Bursting:RegisterAuraTracking();
				v148 = 1912 - (1261 + 650);
			end
			if (((1353 + 1843) <= (7764 - 2892)) and (v148 == (1818 - (772 + 1045)))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(38 + 226, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

