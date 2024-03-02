local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2805 - (1714 + 185)) >= (1609 + 620))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_RestoShaman.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.min;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v118 = 31739 - 20628;
	local v119 = 2886 + 8225;
	local v120;
	v9:RegisterForEvent(function()
		v118 = 19540 - 8429;
		v119 = 23042 - 11931;
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v17.Shaman.Restoration;
	local v122 = v24.Shaman.Restoration;
	local v123 = v19.Shaman.Restoration;
	local v124 = {};
	local v125 = v21.Commons.Everyone;
	local v126 = v21.Commons.Shaman;
	local function v127()
		if (((3100 - (1293 + 519)) > (2552 - 1301)) and v121.ImprovedPurifySpirit:IsAvailable()) then
			v125.DispellableDebuffs = v20.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v140)
		return v140:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (13 - 8));
	end
	local function v129()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (0 - 0)) or ((10631 - 6118) < (1776 + 1576))) then
				if ((v92 and v121.AstralShift:IsReady()) or ((422 + 1643) >= (7425 - 4229))) then
					if ((v12:HealthPercentage() <= v58) or ((1012 + 3364) <= (492 + 989))) then
						if (v23(v121.AstralShift, not v14:IsInRange(25 + 15)) or ((4488 - (709 + 387)) >= (6599 - (673 + 1185)))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((9642 - 6317) >= (6916 - 4762)) and v95 and v121.EarthElemental:IsReady()) then
					if ((v12:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67) or ((2130 - 835) >= (2313 + 920))) then
						if (((3271 + 1106) > (2216 - 574)) and v23(v121.EarthElemental, not v14:IsInRange(10 + 30))) then
							return "earth_elemental defensives";
						end
					end
				end
				v141 = 1 - 0;
			end
			if (((9270 - 4547) > (3236 - (446 + 1434))) and (v141 == (1284 - (1040 + 243)))) then
				if ((v123.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((12344 - 8208) <= (5280 - (559 + 1288)))) then
					if (((6176 - (609 + 1322)) <= (5085 - (13 + 441))) and v23(v122.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((15978 - 11702) >= (10252 - 6338)) and v37 and (v12:HealthPercentage() <= v38)) then
					local v241 = 0 - 0;
					while true do
						if (((8 + 190) <= (15852 - 11487)) and (v241 == (0 + 0))) then
							if (((2096 + 2686) > (13876 - 9200)) and (v39 == "Refreshing Healing Potion")) then
								if (((2662 + 2202) > (4040 - 1843)) and v123.RefreshingHealingPotion:IsReady()) then
									if (v23(v122.RefreshingHealingPotion) or ((2447 + 1253) == (1395 + 1112))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3215 + 1259) >= (231 + 43)) and (v39 == "Dreamwalker's Healing Potion")) then
								if (v123.DreamwalkersHealingPotion:IsReady() or ((1854 + 40) <= (1839 - (153 + 280)))) then
									if (((4538 - 2966) >= (1375 + 156)) and v23(v122.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1 + 0)) or ((4254 + 433) < (3292 + 1250))) then
				if (((5010 - 1719) > (1031 + 636)) and v40) then
					v28 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 707 - (89 + 578));
					if (v28 or ((624 + 249) == (4228 - 2194))) then
						return v28;
					end
					v28 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 1089 - (572 + 477));
					if (v28 or ((380 + 2436) < (7 + 4))) then
						return v28;
					end
				end
				if (((442 + 3257) < (4792 - (84 + 2))) and v41) then
					local v242 = 0 - 0;
					while true do
						if (((1907 + 739) >= (1718 - (497 + 345))) and (v242 == (1 + 1))) then
							v28 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 7 + 33);
							if (((1947 - (605 + 728)) <= (2272 + 912)) and v28) then
								return v28;
							end
							v242 = 6 - 3;
						end
						if (((144 + 2982) == (11557 - 8431)) and (v242 == (0 + 0))) then
							v28 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 110 - 70);
							if (v28 or ((1652 + 535) >= (5443 - (457 + 32)))) then
								return v28;
							end
							v242 = 1 + 0;
						end
						if ((v242 == (1405 - (832 + 570))) or ((3653 + 224) == (933 + 2642))) then
							v28 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 141 - 101);
							if (((341 + 366) > (1428 - (588 + 208))) and v28) then
								return v28;
							end
							break;
						end
						if ((v242 == (2 - 1)) or ((2346 - (884 + 916)) >= (5618 - 2934))) then
							v28 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 24 + 16);
							if (((2118 - (232 + 421)) <= (6190 - (1569 + 320))) and v28) then
								return v28;
							end
							v242 = 1 + 1;
						end
					end
				end
				v142 = 1 + 1;
			end
			if (((5741 - 4037) > (2030 - (316 + 289))) and (v142 == (5 - 3))) then
				if (v42 or ((32 + 655) == (5687 - (666 + 787)))) then
					local v243 = 425 - (360 + 65);
					while true do
						if ((v243 == (1 + 0)) or ((3584 - (79 + 175)) < (2252 - 823))) then
							v28 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 32 + 8);
							if (((3515 - 2368) >= (645 - 310)) and v28) then
								return v28;
							end
							v243 = 901 - (503 + 396);
						end
						if (((3616 - (92 + 89)) > (4068 - 1971)) and (v243 == (2 + 0))) then
							v28 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 24 + 16);
							if (v28 or ((14763 - 10993) >= (553 + 3488))) then
								return v28;
							end
							v243 = 6 - 3;
						end
						if ((v243 == (3 + 0)) or ((1811 + 1980) <= (4906 - 3295))) then
							v28 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 5 + 35);
							if (v28 or ((6981 - 2403) <= (3252 - (485 + 759)))) then
								return v28;
							end
							break;
						end
						if (((2603 - 1478) <= (3265 - (442 + 747))) and (v243 == (1135 - (832 + 303)))) then
							v28 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 986 - (88 + 858));
							if (v28 or ((227 + 516) >= (3641 + 758))) then
								return v28;
							end
							v243 = 1 + 0;
						end
					end
				end
				if (((1944 - (766 + 23)) < (8259 - 6586)) and v43) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (0 - 0)) or ((7887 - 5563) <= (1651 - (1036 + 37)))) then
							v28 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 29 + 11);
							if (((7335 - 3568) == (2964 + 803)) and v28) then
								return v28;
							end
							v244 = 1481 - (641 + 839);
						end
						if (((5002 - (910 + 3)) == (10423 - 6334)) and (v244 == (1687 - (1466 + 218)))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 19 + 21);
							if (((5606 - (556 + 592)) >= (596 + 1078)) and v28) then
								return v28;
							end
							break;
						end
						if (((1780 - (329 + 479)) <= (2272 - (174 + 680))) and (v244 == (6 - 4))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 82 - 42);
							if (v28 or ((3526 + 1412) < (5501 - (396 + 343)))) then
								return v28;
							end
							v244 = 1 + 2;
						end
						if ((v244 == (1478 - (29 + 1448))) or ((3893 - (135 + 1254)) > (16063 - 11799))) then
							v28 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 186 - 146);
							if (((1435 + 718) == (3680 - (389 + 1138))) and v28) then
								return v28;
							end
							v244 = 576 - (102 + 472);
						end
					end
				end
				break;
			end
			if ((v142 == (0 + 0)) or ((282 + 225) >= (2416 + 175))) then
				if (((6026 - (320 + 1225)) == (7976 - 3495)) and v113) then
					v28 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 19 + 11, true);
					if (v28 or ((3792 - (157 + 1307)) < (2552 - (821 + 1038)))) then
						return v28;
					end
				end
				if (((10798 - 6470) == (474 + 3854)) and v112) then
					v28 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 53 - 23);
					if (((591 + 997) >= (3301 - 1969)) and v28) then
						return v28;
					end
					if (v114 or ((5200 - (834 + 192)) > (271 + 3977))) then
						v28 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 8 + 22);
						if (v28 or ((99 + 4487) <= (126 - 44))) then
							return v28;
						end
					end
					if (((4167 - (300 + 4)) == (1032 + 2831)) and v115) then
						local v249 = 0 - 0;
						while true do
							if ((v249 == (362 - (112 + 250))) or ((113 + 169) <= (104 - 62))) then
								v28 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 18 + 12);
								if (((2384 + 2225) >= (573 + 193)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v131()
		if ((v110 and ((v30 and v109) or not v109)) or ((856 + 296) == (3902 - (1001 + 413)))) then
			local v234 = 0 - 0;
			while true do
				if (((4304 - (244 + 638)) > (4043 - (627 + 66))) and (v234 == (2 - 1))) then
					v28 = v125.HandleBottomTrinket(v124, v30, 642 - (512 + 90), nil);
					if (((2783 - (1665 + 241)) > (1093 - (373 + 344))) and v28) then
						return v28;
					end
					break;
				end
				if ((v234 == (0 + 0)) or ((825 + 2293) <= (4882 - 3031))) then
					v28 = v125.HandleTopTrinket(v124, v30, 67 - 27, nil);
					if (v28 or ((1264 - (35 + 1064)) >= (2541 + 951))) then
						return v28;
					end
					v234 = 2 - 1;
				end
			end
		end
		if (((16 + 3933) < (6092 - (298 + 938))) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
			if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((5535 - (233 + 1026)) < (4682 - (636 + 1030)))) then
				if (((2398 + 2292) > (4030 + 95)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
					return "riptide healingcd tank";
				end
			end
		end
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((15 + 35) >= (61 + 835))) then
			if ((v16:HealthPercentage() <= v82) or ((1935 - (55 + 166)) >= (574 + 2384))) then
				if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((150 + 1341) < (2459 - 1815))) then
					return "riptide healingcd";
				end
			end
		end
		if (((1001 - (36 + 261)) < (1726 - 739)) and v125.AreUnitsBelowHealthPercentage(v85, v84, v121.ChainHeal) and v121.SpiritLinkTotem:IsReady()) then
			if (((5086 - (34 + 1334)) > (733 + 1173)) and (v86 == "Player")) then
				if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(32 + 8)) or ((2241 - (1035 + 248)) > (3656 - (20 + 1)))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((1824 + 1677) <= (4811 - (134 + 185))) and (v86 == "Friendly under Cursor")) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((4575 - (549 + 584)) < (3233 - (314 + 371)))) then
					if (((9869 - 6994) >= (2432 - (478 + 490))) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(22 + 18))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v86 == "Confirmation") or ((5969 - (786 + 386)) >= (15848 - 10955))) then
				if (v23(v121.SpiritLinkTotem, not v14:IsInRange(1419 - (1055 + 324))) or ((1891 - (1093 + 247)) > (1838 + 230))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((223 + 1891) > (3747 - 2803)) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77, v121.ChainHeal) and v121.HealingTideTotem:IsReady()) then
			if (v23(v121.HealingTideTotem, not v14:IsInRange(135 - 95)) or ((6436 - 4174) >= (7779 - 4683))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v54, v53, v121.ChainHeal) and v121.AncestralProtectionTotem:IsReady()) or ((803 + 1452) >= (13626 - 10089))) then
			if ((v55 == "Player") or ((13225 - 9388) < (985 + 321))) then
				if (((7544 - 4594) == (3638 - (364 + 324))) and v23(v122.AncestralProtectionTotemPlayer, not v14:IsInRange(109 - 69))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v55 == "Friendly under Cursor") or ((11333 - 6610) < (1094 + 2204))) then
				if (((4753 - 3617) >= (246 - 92)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v122.AncestralProtectionTotemCursor, not v14:IsInRange(121 - 81)) or ((1539 - (1249 + 19)) > (4286 + 462))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((18450 - 13710) >= (4238 - (686 + 400))) and (v55 == "Confirmation")) then
				if (v23(v121.AncestralProtectionTotem, not v14:IsInRange(32 + 8)) or ((2807 - (73 + 156)) >= (17 + 3373))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((852 - (721 + 90)) <= (19 + 1642)) and v90 and v125.AreUnitsBelowHealthPercentage(v52, v51, v121.ChainHeal) and v121.AncestralGuidance:IsReady()) then
			if (((1951 - 1350) < (4030 - (224 + 246))) and v23(v121.AncestralGuidance, not v14:IsInRange(64 - 24))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((432 - 197) < (125 + 562)) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56, v121.ChainHeal) and v121.Ascendance:IsReady()) then
			if (((109 + 4440) > (847 + 306)) and v23(v121.Ascendance, not v14:IsInRange(79 - 39))) then
				return "ascendance cooldowns";
			end
		end
		if ((v101 and (v12:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) or ((15553 - 10879) < (5185 - (203 + 310)))) then
			if (((5661 - (1238 + 755)) < (319 + 4242)) and v23(v121.ManaTideTotem, not v14:IsInRange(1574 - (709 + 825)))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v34 and ((v108 and v30) or not v108)) or ((838 - 383) == (5250 - 1645))) then
			local v235 = 864 - (196 + 668);
			while true do
				if ((v235 == (0 - 0)) or ((5515 - 2852) == (4145 - (171 + 662)))) then
					if (((4370 - (4 + 89)) <= (15684 - 11209)) and v121.AncestralCall:IsReady()) then
						if (v23(v121.AncestralCall, not v14:IsInRange(15 + 25)) or ((3821 - 2951) == (467 + 722))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((3039 - (35 + 1451)) <= (4586 - (28 + 1425))) and v121.BagofTricks:IsReady()) then
						if (v23(v121.BagofTricks, not v14:IsInRange(2033 - (941 + 1052))) or ((2145 + 92) >= (5025 - (822 + 692)))) then
							return "BagofTricks cooldowns";
						end
					end
					v235 = 1 - 0;
				end
				if ((v235 == (1 + 1)) or ((1621 - (45 + 252)) > (2989 + 31))) then
					if (v121.Fireblood:IsReady() or ((1030 + 1962) == (4577 - 2696))) then
						if (((3539 - (114 + 319)) > (2190 - 664)) and v23(v121.Fireblood, not v14:IsInRange(51 - 11))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
				if (((1928 + 1095) < (5765 - 1895)) and (v235 == (1 - 0))) then
					if (((2106 - (556 + 1407)) > (1280 - (741 + 465))) and v121.Berserking:IsReady()) then
						if (((483 - (170 + 295)) < (1113 + 999)) and v23(v121.Berserking, not v14:IsInRange(37 + 3))) then
							return "Berserking cooldowns";
						end
					end
					if (((2700 - 1603) <= (1350 + 278)) and v121.BloodFury:IsReady()) then
						if (((2970 + 1660) == (2622 + 2008)) and v23(v121.BloodFury, not v14:IsInRange(1270 - (957 + 273)))) then
							return "BloodFury cooldowns";
						end
					end
					v235 = 1 + 1;
				end
			end
		end
	end
	local function v132()
		if (((1418 + 2122) > (10223 - 7540)) and v93 and v125.AreUnitsBelowHealthPercentage(250 - 155, 9 - 6, v121.ChainHeal) and v121.ChainHeal:IsReady() and v12:BuffUp(v121.HighTide)) then
			if (((23738 - 18944) >= (5055 - (389 + 1391))) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((932 + 552) == (155 + 1329)) and v100 and (v16:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (34 - 19))) then
			if (((2383 - (783 + 168)) < (11931 - 8376)) and v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((1048 + 17) > (3889 - (309 + 2)))) then
			if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((14725 - 9930) < (2619 - (1090 + 122)))) then
				if (((601 + 1252) < (16164 - 11351)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((1931 + 890) < (3549 - (628 + 490)))) then
			if ((v16:HealthPercentage() <= v82) or ((516 + 2358) < (5399 - 3218))) then
				if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((12288 - 9599) <= (1117 - (431 + 343)))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v104 and v121.UnleashLife:IsReady()) or ((3774 - 1905) == (5811 - 3802))) then
			if ((v12:HealthPercentage() <= v89) or ((2802 + 744) < (297 + 2025))) then
				if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((3777 - (556 + 1139)) == (4788 - (6 + 9)))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((594 + 2650) > (541 + 514)) and (v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal)) then
			if (v23(v122.HealingRainCursor, not v14:IsInRange(209 - (28 + 141)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1284 + 2029) <= (2194 - 416))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal) and v121.HealingRain:IsReady()) or ((1007 + 414) >= (3421 - (486 + 831)))) then
			if (((4715 - 2903) <= (11438 - 8189)) and (v73 == "Player")) then
				if (((307 + 1316) <= (6187 - 4230)) and v23(v122.HealingRainPlayer, not v14:IsInRange(1303 - (668 + 595)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif (((3971 + 441) == (890 + 3522)) and (v73 == "Friendly under Cursor")) then
				if (((4772 - 3022) >= (1132 - (23 + 267))) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((6316 - (1129 + 815)) > (2237 - (371 + 16))) and v23(v122.HealingRainCursor, not v14:IsInRange(1790 - (1326 + 424)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((439 - 207) < (3000 - 2179)) and (v73 == "Enemy under Cursor")) then
				if (((636 - (88 + 30)) < (1673 - (720 + 51))) and v15:Exists() and v12:CanAttack(v15)) then
					if (((6659 - 3665) > (2634 - (421 + 1355))) and v23(v122.HealingRainCursor, not v14:IsInRange(65 - 25), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v73 == "Confirmation") or ((1845 + 1910) <= (1998 - (286 + 797)))) then
				if (((14425 - 10479) > (6199 - 2456)) and v23(v121.HealingRain, not v14:IsInRange(479 - (397 + 42)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v69, v68, v121.ChainHeal) and v121.EarthenWallTotem:IsReady()) or ((417 + 918) >= (4106 - (24 + 776)))) then
			if (((7462 - 2618) > (3038 - (222 + 563))) and (v70 == "Player")) then
				if (((995 - 543) == (326 + 126)) and v23(v122.EarthenWallTotemPlayer, not v14:IsInRange(230 - (23 + 167)))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v70 == "Friendly under Cursor") or ((6355 - (690 + 1108)) < (753 + 1334))) then
				if (((3196 + 678) == (4722 - (40 + 808))) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v122.EarthenWallTotemCursor, not v14:IsInRange(7 + 33)) or ((7410 - 5472) > (4717 + 218))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v70 == "Confirmation") or ((2251 + 2004) < (1878 + 1545))) then
				if (((2025 - (47 + 524)) <= (1617 + 874)) and v23(v121.EarthenWallTotem, not v14:IsInRange(109 - 69))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v64, v63, v121.ChainHeal) and v121.Downpour:IsReady()) or ((6215 - 2058) <= (6392 - 3589))) then
			if (((6579 - (1165 + 561)) >= (89 + 2893)) and (v65 == "Player")) then
				if (((12803 - 8669) > (1281 + 2076)) and v23(v122.DownpourPlayer, not v14:IsInRange(519 - (341 + 138)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v65 == "Friendly under Cursor") or ((923 + 2494) < (5228 - 2694))) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((3048 - (89 + 237)) <= (527 - 363))) then
					if (v23(v122.DownpourCursor, not v14:IsInRange(84 - 44), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3289 - (581 + 300)) < (3329 - (855 + 365)))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v65 == "Confirmation") or ((78 - 45) == (476 + 979))) then
				if (v23(v121.Downpour, not v14:IsInRange(1275 - (1030 + 205)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((416 + 27) >= (3736 + 279))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((3668 - (156 + 130)) > (377 - 211)) and v94 and v125.AreUnitsBelowHealthPercentage(v62, v61, v121.ChainHeal) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (16 - 6))) then
			if (v23(v121.CloudburstTotem) or ((573 - 293) == (807 + 2252))) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((1097 + 784) > (1362 - (10 + 59))) and v105 and v125.AreUnitsBelowHealthPercentage(v107, v106, v121.ChainHeal) and v121.Wellspring:IsReady()) then
			if (((667 + 1690) == (11607 - 9250)) and v23(v121.Wellspring, not v14:IsInRange(1203 - (671 + 492)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if (((98 + 25) == (1338 - (369 + 846))) and v93 and v125.AreUnitsBelowHealthPercentage(v60, v59, v121.ChainHeal) and v121.ChainHeal:IsReady()) then
			if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((280 + 776) >= (2895 + 497))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v103 and v12:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87, v121.ChainHeal) and v121.SpiritwalkersGrace:IsReady()) or ((3026 - (1036 + 909)) < (855 + 220))) then
			if (v23(v121.SpiritwalkersGrace, nil) or ((1760 - 711) >= (4635 - (11 + 192)))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74, v121.ChainHeal) and v121.HealingStreamTotem:IsReady()) or ((2410 + 2358) <= (1021 - (135 + 40)))) then
			if (v23(v121.HealingStreamTotem, nil) or ((8135 - 4777) <= (856 + 564))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v133()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (0 - 0)) or ((3915 - (50 + 126)) <= (8367 - 5362))) then
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((368 + 1291) >= (3547 - (1233 + 180)))) then
					if ((v16:HealthPercentage() <= v82) or ((4229 - (522 + 447)) < (3776 - (107 + 1314)))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((311 + 358) == (12867 - 8644))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((719 + 973) < (1167 - 579))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((18979 - 14182) < (5561 - (716 + 1194)))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((72 + 4105) > (520 + 4330))) then
							return "riptide healingaoe";
						end
					end
				end
				v143 = 504 - (74 + 429);
			end
			if ((v143 == (3 - 1)) or ((199 + 201) > (2542 - 1431))) then
				if (((2159 + 892) > (3098 - 2093)) and v98 and v121.HealingSurge:IsReady()) then
					if (((9131 - 5438) <= (4815 - (279 + 154))) and (v16:HealthPercentage() <= v76)) then
						if (v23(v122.HealingSurgeFocus, not v16:IsSpellInRange(v121.HealingSurge), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4060 - (454 + 324)) > (3226 + 874))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v100 and v121.HealingWave:IsReady()) or ((3597 - (12 + 5)) < (1534 + 1310))) then
					if (((226 - 137) < (1660 + 2830)) and (v16:HealthPercentage() <= v79)) then
						if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((6076 - (277 + 816)) < (7725 - 5917))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((5012 - (1058 + 125)) > (707 + 3062)) and ((976 - (815 + 160)) == v143)) then
				if (((6371 - 4886) <= (6893 - 3989)) and v121.ElementalOrbit:IsAvailable() and v12:BuffDown(v121.EarthShieldBuff) and not v14:IsAPlayer() and v121.EarthShield:IsCastable() and v96 and v12:CanAttack(v14)) then
					if (((1019 + 3250) == (12478 - 8209)) and v23(v121.EarthShield)) then
						return "earth_shield player healingst";
					end
				end
				if (((2285 - (41 + 1857)) <= (4675 - (1222 + 671))) and v121.ElementalOrbit:IsAvailable() and v12:BuffUp(v121.EarthShieldBuff)) then
					if (v125.IsSoloMode() or ((4907 - 3008) <= (1318 - 401))) then
						if ((v121.LightningShield:IsReady() and v12:BuffDown(v121.LightningShield)) or ((5494 - (229 + 953)) <= (2650 - (1111 + 663)))) then
							if (((3811 - (874 + 705)) <= (364 + 2232)) and v23(v121.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif (((1430 + 665) < (7661 - 3975)) and v121.WaterShield:IsReady() and v12:BuffDown(v121.WaterShield)) then
						if (v23(v121.WaterShield) or ((45 + 1550) >= (5153 - (642 + 37)))) then
							return "water_shield healingst";
						end
					end
				end
				v143 = 1 + 1;
			end
		end
	end
	local function v134()
		if (v121.Stormkeeper:IsReady() or ((739 + 3880) < (7235 - 4353))) then
			if (v23(v121.Stormkeeper, not v14:IsInRange(494 - (233 + 221))) or ((679 - 385) >= (4253 + 578))) then
				return "stormkeeper damage";
			end
		end
		if (((3570 - (718 + 823)) <= (1941 + 1143)) and (math.max(#v12:GetEnemiesInRange(825 - (266 + 539)), v12:GetEnemiesInSplashRangeCount(22 - 14)) > (1227 - (636 + 589)))) then
			if (v121.ChainLightning:IsReady() or ((4835 - 2798) == (4991 - 2571))) then
				if (((3533 + 925) > (1419 + 2485)) and v23(v121.ChainLightning, not v14:IsSpellInRange(v121.ChainLightning), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((1451 - (657 + 358)) >= (325 - 202)) and v121.FlameShock:IsReady()) then
			if (((1139 - 639) < (3003 - (1151 + 36))) and v125.CastCycle(v121.FlameShock, v12:GetEnemiesInRange(39 + 1), v128, not v14:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil)) then
				return "flame_shock_cycle damage";
			end
			if (((940 + 2634) == (10673 - 7099)) and v23(v121.FlameShock, not v14:IsSpellInRange(v121.FlameShock))) then
				return "flame_shock damage";
			end
		end
		if (((2053 - (1552 + 280)) < (1224 - (64 + 770))) and v121.LavaBurst:IsReady()) then
			if (v23(v121.LavaBurst, not v14:IsSpellInRange(v121.LavaBurst), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1503 + 710) <= (3225 - 1804))) then
				return "lava_burst damage";
			end
		end
		if (((543 + 2515) < (6103 - (157 + 1086))) and v121.LightningBolt:IsReady()) then
			if (v23(v121.LightningBolt, not v14:IsSpellInRange(v121.LightningBolt), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2593 - 1297) >= (19472 - 15026))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v135()
		v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v59 = EpicSettings.Settings['ChainHealGroup'];
		v60 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v63 = EpicSettings.Settings['DownpourGroup'];
		v64 = EpicSettings.Settings['DownpourHP'];
		v65 = EpicSettings.Settings['DownpourUsage'];
		v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v69 = EpicSettings.Settings['EarthenWallTotemHP'];
		v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v38 = EpicSettings.Settings['healingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v71 = EpicSettings.Settings['HealingRainGroup'];
		v72 = EpicSettings.Settings['HealingRainHP'];
		v73 = EpicSettings.Settings['HealingRainUsage'];
		v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v75 = EpicSettings.Settings['HealingStreamTotemHP'];
		v76 = EpicSettings.Settings['HealingSurgeHP'];
		v77 = EpicSettings.Settings['HealingTideTotemGroup'];
		v78 = EpicSettings.Settings['HealingTideTotemHP'];
		v79 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v49 = EpicSettings.Settings['InterruptThreshold'];
		v47 = EpicSettings.Settings['InterruptWithStun'];
		v82 = EpicSettings.Settings['RiptideHP'];
		v83 = EpicSettings.Settings['RiptideTankHP'];
		v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v89 = EpicSettings.Settings['UnleashLifeHP'];
		v93 = EpicSettings.Settings['UseChainHeal'];
		v94 = EpicSettings.Settings['UseCloudburstTotem'];
		v96 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['useHealingPotion'];
		v97 = EpicSettings.Settings['UseHealingStreamTotem'];
		v98 = EpicSettings.Settings['UseHealingSurge'];
		v99 = EpicSettings.Settings['UseHealingTideTotem'];
		v100 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v46 = EpicSettings.Settings['UsePurgeTarget'];
		v102 = EpicSettings.Settings['UseRiptide'];
		v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v104 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v136()
		v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v52 = EpicSettings.Settings['AncestralGuidanceHP'];
		v56 = EpicSettings.Settings['AscendanceGroup'];
		v57 = EpicSettings.Settings['AscendanceHP'];
		v58 = EpicSettings.Settings['AstralShiftHP'];
		v61 = EpicSettings.Settings['CloudburstTotemGroup'];
		v62 = EpicSettings.Settings['CloudburstTotemHP'];
		v66 = EpicSettings.Settings['EarthElementalHP'];
		v67 = EpicSettings.Settings['EarthElementalTankHP'];
		v80 = EpicSettings.Settings['ManaTideTotemMana'];
		v81 = EpicSettings.Settings['PrimordialWaveHP'];
		v90 = EpicSettings.Settings['UseAncestralGuidance'];
		v91 = EpicSettings.Settings['UseAscendance'];
		v92 = EpicSettings.Settings['UseAstralShift'];
		v95 = EpicSettings.Settings['UseEarthElemental'];
		v101 = EpicSettings.Settings['UseManaTideTotem'];
		v105 = EpicSettings.Settings['UseWellspring'];
		v106 = EpicSettings.Settings['WellspringGroup'];
		v107 = EpicSettings.Settings['WellspringHP'];
		v116 = EpicSettings.Settings['useManaPotion'];
		v117 = EpicSettings.Settings['manaPotionSlider'];
		v108 = EpicSettings.Settings['racialsWithCD'];
		v34 = EpicSettings.Settings['useRacials'];
		v109 = EpicSettings.Settings['trinketsWithCD'];
		v110 = EpicSettings.Settings['useTrinkets'];
		v111 = EpicSettings.Settings['fightRemainsCheck'];
		v50 = EpicSettings.Settings['useWeapon'];
		v112 = EpicSettings.Settings['handleAfflicted'];
		v113 = EpicSettings.Settings['HandleIncorporeal'];
		v40 = EpicSettings.Settings['HandleChromie'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v43 = EpicSettings.Settings['HandleFyrakkNPC'];
		v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local v137 = 0 - 0;
	local function v138()
		local v228 = 0 - 0;
		local v229;
		while true do
			if ((v228 == (819 - (599 + 220))) or ((2773 - 1380) > (6420 - (1813 + 118)))) then
				v135();
				v136();
				v29 = EpicSettings.Toggles['ooc'];
				v228 = 1 + 0;
			end
			if ((v228 == (1220 - (841 + 376))) or ((6198 - 1774) < (7 + 20))) then
				if (v125.TargetIsValid() or v12:AffectingCombat() or ((5450 - 3453) > (4674 - (464 + 395)))) then
					local v245 = 0 - 0;
					while true do
						if (((1665 + 1800) > (2750 - (467 + 370))) and ((0 - 0) == v245)) then
							v120 = v12:GetEnemiesInRange(30 + 10);
							v118 = v9.BossFightRemains(nil, true);
							v245 = 3 - 2;
						end
						if (((115 + 618) < (4231 - 2412)) and ((521 - (150 + 370)) == v245)) then
							v119 = v118;
							if ((v119 == (12393 - (74 + 1208))) or ((10810 - 6415) == (22550 - 17795))) then
								v119 = v9.FightRemains(v120, false);
							end
							break;
						end
					end
				end
				if (not v12:AffectingCombat() or ((2699 + 1094) < (2759 - (14 + 376)))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((7083 - 2999) == (172 + 93))) then
						local v250 = 0 + 0;
						local v251;
						while true do
							if (((4157 + 201) == (12769 - 8411)) and (v250 == (0 + 0))) then
								v251 = v125.DeadFriendlyUnitsCount();
								if ((v251 > (79 - (23 + 55))) or ((7436 - 4298) < (663 + 330))) then
									if (((2991 + 339) > (3601 - 1278)) and v23(v121.AncestralVision, nil, v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (v23(v122.AncestralSpiritMouseover, not v14:IsInRange(13 + 27), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4527 - (652 + 249)) == (10675 - 6686))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v229 = v130();
				v228 = 1872 - (708 + 1160);
			end
			if (((13 - 8) == v228) or ((1669 - 753) == (2698 - (10 + 17)))) then
				if (((62 + 210) == (2004 - (1400 + 332))) and v12:AffectingCombat() and v125.TargetIsValid()) then
					if (((8149 - 3900) <= (6747 - (242 + 1666))) and ((v30 and v50 and v123.Dreambinder:IsEquippedAndReady()) or v123.Iridal:IsEquippedAndReady())) then
						if (((1189 + 1588) < (1173 + 2027)) and v23(v122.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((81 + 14) < (2897 - (850 + 90))) and v116 and v123.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v117)) then
						if (((1446 - 620) < (3107 - (360 + 1030))) and v23(v122.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					v28 = v125.Interrupt(v121.WindShear, 27 + 3, true);
					if (((4024 - 2598) >= (1519 - 414)) and v28) then
						return v28;
					end
					v28 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 1691 - (909 + 752), true, v15);
					if (((3977 - (109 + 1114)) <= (6185 - 2806)) and v28) then
						return v28;
					end
					v28 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 12 + 18, nil, v15);
					if (v28 or ((4169 - (6 + 236)) == (891 + 522))) then
						return v28;
					end
					v229 = v129();
					if (v229 or ((929 + 225) <= (1858 - 1070))) then
						return v229;
					end
					if ((v121.GreaterPurge:IsAvailable() and v46 and v121.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((2869 - 1226) > (4512 - (1076 + 57)))) then
						if (v23(v121.GreaterPurge, not v14:IsSpellInRange(v121.GreaterPurge)) or ((461 + 2342) > (5238 - (579 + 110)))) then
							return "greater_purge utility";
						end
					end
					if ((v121.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((18 + 202) >= (2672 + 350))) then
						if (((1498 + 1324) == (3229 - (174 + 233))) and v23(v121.Purge, not v14:IsSpellInRange(v121.Purge))) then
							return "purge utility";
						end
					end
					if ((v119 > v111) or ((2963 - 1902) == (3259 - 1402))) then
						local v252 = 0 + 0;
						while true do
							if (((3934 - (663 + 511)) > (1217 + 147)) and ((0 + 0) == v252)) then
								v229 = v131();
								if (v229 or ((15112 - 10210) <= (2177 + 1418))) then
									return v229;
								end
								break;
							end
						end
					end
				end
				if (v29 or v12:AffectingCombat() or ((9068 - 5216) == (709 - 416))) then
					local v246 = 0 + 0;
					while true do
						if (((0 - 0) == v246) or ((1112 + 447) == (420 + 4168))) then
							if ((v31 and v44) or ((5206 - (478 + 244)) == (1305 - (440 + 77)))) then
								local v253 = 0 + 0;
								while true do
									if (((16719 - 12151) >= (5463 - (655 + 901))) and (v253 == (1 + 0))) then
										if (((954 + 292) < (2344 + 1126)) and v15 and v15:Exists() and v15:IsAPlayer() and v125.UnitHasDispellableDebuffByPlayer(v15)) then
											if (((16388 - 12320) >= (2417 - (695 + 750))) and v121.PurifySpirit:IsCastable()) then
												if (((1683 - 1190) < (6007 - 2114)) and v23(v122.PurifySpiritMouseover, not v15:IsSpellInRange(v121.PurifySpirit))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
									if ((v253 == (0 - 0)) or ((1824 - (285 + 66)) >= (7766 - 4434))) then
										if ((v121.Bursting:MaxDebuffStack() > (1314 - (682 + 628))) or ((653 + 3398) <= (1456 - (176 + 123)))) then
											v28 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
											if (((253 + 351) < (2090 + 791)) and v28) then
												return v28;
											end
										end
										if (v16 or ((1169 - (239 + 30)) == (919 + 2458))) then
											if (((4286 + 173) > (1045 - 454)) and v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(77 - 52)) then
												local v255 = 315 - (306 + 9);
												while true do
													if (((11857 - 8459) >= (417 + 1978)) and (v255 == (0 + 0))) then
														if ((v137 == (0 + 0)) or ((6242 - 4059) >= (4199 - (1140 + 235)))) then
															v137 = GetTime();
														end
														if (((1233 + 703) == (1776 + 160)) and v125.Wait(129 + 371, v137)) then
															if (v23(v122.PurifySpiritFocus, not v16:IsSpellInRange(v121.PurifySpirit)) or ((4884 - (33 + 19)) < (1558 + 2755))) then
																return "purify_spirit dispel focus";
															end
															v137 = 0 - 0;
														end
														break;
													end
												end
											end
										end
										v253 = 1 + 0;
									end
								end
							end
							if (((8016 - 3928) > (3633 + 241)) and (v121.Bursting:AuraActiveCount() > (692 - (586 + 103)))) then
								if (((395 + 3937) == (13336 - 9004)) and (v121.Bursting:MaxDebuffStack() > (1493 - (1309 + 179))) and v121.SpiritLinkTotem:IsReady()) then
									if (((7218 - 3219) >= (1263 + 1637)) and (v86 == "Player")) then
										if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(107 - 67)) or ((1908 + 617) > (8634 - 4570))) then
											return "spirit_link_totem bursting";
										end
									elseif (((8709 - 4338) == (4980 - (295 + 314))) and (v86 == "Friendly under Cursor")) then
										if ((v15:Exists() and not v12:CanAttack(v15)) or ((653 - 387) > (6948 - (1300 + 662)))) then
											if (((6251 - 4260) >= (2680 - (1178 + 577))) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(21 + 19))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif (((1344 - 889) < (3458 - (851 + 554))) and (v86 == "Confirmation")) then
										if (v23(v121.SpiritLinkTotem, not v14:IsInRange(36 + 4)) or ((2290 - 1464) == (10535 - 5684))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if (((485 - (115 + 187)) == (141 + 42)) and v93 and v121.ChainHeal:IsReady()) then
									if (((1098 + 61) <= (7045 - 5257)) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
							end
							v246 = 1162 - (160 + 1001);
						end
						if ((v246 == (1 + 0)) or ((2420 + 1087) > (8839 - 4521))) then
							if (((v16:HealthPercentage() < v81) and v16:BuffDown(v121.Riptide)) or ((3433 - (237 + 121)) <= (3862 - (525 + 372)))) then
								if (((2587 - 1222) <= (6607 - 4596)) and v121.PrimordialWaveResto:IsCastable()) then
									if (v23(v122.PrimordialWaveFocus, not v16:IsSpellInRange(v121.PrimordialWaveResto)) or ((2918 - (96 + 46)) > (4352 - (643 + 134)))) then
										return "primordial_wave main";
									end
								end
							end
							if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v12:GCD() * (2 + 1)))) or ((6123 - 3569) == (17835 - 13031))) then
								if (((2472 + 105) == (5057 - 2480)) and v23(v121.TotemicRecall, nil)) then
									return "totemic_recall main";
								end
							end
							v246 = 3 - 1;
						end
						if ((v246 == (721 - (316 + 403))) or ((4 + 2) >= (5193 - 3304))) then
							if (((183 + 323) <= (4764 - 2872)) and v121.NaturesSwiftness:IsReady() and v121.Riptide:CooldownRemains() and v121.UnleashLife:CooldownRemains()) then
								if (v23(v121.NaturesSwiftness, nil) or ((1423 + 585) > (715 + 1503))) then
									return "natures_swiftness main";
								end
							end
							if (((1312 - 933) <= (19805 - 15658)) and v32) then
								if ((v14:Exists() and not v12:CanAttack(v14)) or ((9376 - 4862) <= (58 + 951))) then
									if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v14:BuffDown(v121.Riptide)) or ((6882 - 3386) == (59 + 1133))) then
										if ((v14:HealthPercentage() <= v82) or ((611 - 403) == (2976 - (12 + 5)))) then
											if (((16611 - 12334) >= (2800 - 1487)) and v23(v121.Riptide, not v16:IsSpellInRange(v121.Riptide))) then
												return "riptide healing target";
											end
										end
									end
									if (((5498 - 2911) < (7870 - 4696)) and v104 and v121.UnleashLife:IsReady() and (v14:HealthPercentage() <= v89)) then
										if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((837 + 3283) <= (4171 - (1656 + 317)))) then
											return "unleash_life healing target";
										end
									end
									if ((v93 and (v14:HealthPercentage() <= v60) and v121.ChainHeal:IsReady() and (v12:IsInParty() or v12:IsInRaid() or v125.TargetIsValidHealableNpc() or v12:BuffUp(v121.HighTide))) or ((1423 + 173) == (688 + 170))) then
										if (((8562 - 5342) == (15847 - 12627)) and v23(v121.ChainHeal, not v14:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
											return "chain_heal healing target";
										end
									end
									if ((v100 and (v14:HealthPercentage() <= v79) and v121.HealingWave:IsReady()) or ((1756 - (5 + 349)) > (17194 - 13574))) then
										if (((3845 - (266 + 1005)) == (1697 + 877)) and v23(v121.HealingWave, not v14:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
											return "healing_wave healing target";
										end
									end
								end
								v229 = v132();
								if (((6134 - 4336) < (3629 - 872)) and v229) then
									return v229;
								end
								v229 = v133();
								if (v229 or ((2073 - (561 + 1135)) > (3393 - 789))) then
									return v229;
								end
							end
							v246 = 9 - 6;
						end
						if (((1634 - (507 + 559)) < (2285 - 1374)) and (v246 == (9 - 6))) then
							if (((3673 - (212 + 176)) < (5133 - (250 + 655))) and v33) then
								if (((10678 - 6762) > (5815 - 2487)) and v125.TargetIsValid()) then
									local v254 = 0 - 0;
									while true do
										if (((4456 - (1869 + 87)) < (13315 - 9476)) and (v254 == (1901 - (484 + 1417)))) then
											v229 = v134();
											if (((1086 - 579) == (849 - 342)) and v229) then
												return v229;
											end
											break;
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
			if (((1013 - (48 + 725)) <= (5170 - 2005)) and (v228 == (5 - 3))) then
				v33 = EpicSettings.Toggles['dps'];
				v229 = nil;
				if (((485 + 349) >= (2151 - 1346)) and v12:IsDeadOrGhost()) then
					return;
				end
				v228 = 1 + 2;
			end
			if ((v228 == (2 + 2)) or ((4665 - (152 + 701)) < (3627 - (430 + 881)))) then
				if (v229 or ((1016 + 1636) <= (2428 - (557 + 338)))) then
					return v229;
				end
				if (v12:AffectingCombat() or v29 or ((1064 + 2534) < (4114 - 2654))) then
					local v247 = 0 - 0;
					local v248;
					while true do
						if ((v247 == (0 - 0)) or ((8870 - 4754) < (1993 - (499 + 302)))) then
							v248 = v44 and v121.PurifySpirit:IsReady() and v31;
							if ((v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 891 - (39 + 827)) < (2 - 1))) or ((7541 - 4164) <= (3586 - 2683))) then
								v28 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 22 - 7, 4 + 36, "TANK", true, 73 - 48, v121.ChainHeal);
								if (((637 + 3339) >= (694 - 255)) and v28) then
									return v28;
								end
								if (((3856 - (103 + 1)) == (4306 - (475 + 79))) and (v125.UnitGroupRole(v16) == "TANK")) then
									if (((8746 - 4700) > (8624 - 5929)) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
										return "earth_shield_tank main apl 1";
									end
								end
							end
							v247 = 1 + 0;
						end
						if ((v247 == (1 + 0)) or ((5048 - (1395 + 108)) == (9302 - 6105))) then
							if (((3598 - (7 + 1197)) > (163 + 210)) and (not v16:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v16) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 9 + 16) >= (320 - (27 + 292))))) then
								v28 = v125.FocusUnit(v248, nil, 117 - 77, nil, 31 - 6, v121.ChainHeal);
								if (((17425 - 13270) <= (8345 - 4113)) and v28) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if ((v121.EarthShield:IsCastable() and v96 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(76 - 36) and (v125.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v121.EarthShield))) or ((3720 - (43 + 96)) == (14166 - 10693))) then
					if (((11293 - 6298) > (2779 + 569)) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v228 = 2 + 3;
			end
			if ((v228 == (1 - 0)) or ((289 + 465) > (6978 - 3254))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v228 = 1 + 1;
			end
		end
	end
	local function v139()
		local v230 = 0 + 0;
		while true do
			if (((1968 - (1414 + 337)) >= (1997 - (1642 + 298))) and (v230 == (0 - 0))) then
				v127();
				v121.Bursting:RegisterAuraTracking();
				v230 = 2 - 1;
			end
			if ((v230 == (2 - 1)) or ((682 + 1388) >= (3141 + 896))) then
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(1236 - (357 + 615), v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

