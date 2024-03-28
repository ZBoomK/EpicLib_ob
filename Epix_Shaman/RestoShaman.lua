local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3279 - (29 + 88)) == (5109 - (1561 + 386))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((11798 - 9429) > (165 + 4264))) then
			v6 = v0[v4];
			if (((14872 - 10777) >= (1131 + 2052)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v119 = 32972 - 21861;
	local v120 = 6081 + 5030;
	local v121;
	v10:RegisterForEvent(function()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (0 + 0)) or ((2064 + 1647) < (725 + 283))) then
				v119 = 9330 + 1781;
				v120 = 10871 + 240;
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
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((1482 - (153 + 280)) <= (2615 - 1709))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v142)
		return v142:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (5 + 0));
	end
	local function v130()
		if (((1782 + 2731) > (1427 + 1299)) and v93 and v122.AstralShift:IsReady()) then
			if ((v13:HealthPercentage() <= v59) or ((1344 + 137) >= (1926 + 732))) then
				if (v24(v122.AstralShift, not v15:IsInRange(60 - 20)) or ((1991 + 1229) == (2031 - (89 + 578)))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v96 and v122.EarthElemental:IsReady()) or ((753 + 301) > (7051 - 3659))) then
			if ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 1074 - (572 + 477), v122.ChainHeal) or ((92 + 584) >= (986 + 656))) then
				if (((494 + 3642) > (2483 - (84 + 2))) and v24(v122.EarthElemental, not v15:IsInRange(65 - 25))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((3123 + 1211) == (5087 - (497 + 345)))) then
			if (v24(v123.Healthstone) or ((110 + 4166) <= (513 + 2518))) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((6115 - (605 + 728)) <= (856 + 343))) then
			if ((v40 == "Refreshing Healing Potion") or ((10813 - 5949) < (88 + 1814))) then
				if (((17890 - 13051) >= (3336 + 364)) and v124.RefreshingHealingPotion:IsReady()) then
					if (v24(v123.RefreshingHealingPotion) or ((2978 - 1903) > (1449 + 469))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((885 - (457 + 32)) <= (1614 + 2190)) and (v40 == "Dreamwalker's Healing Potion")) then
				if (v124.DreamwalkersHealingPotion:IsReady() or ((5571 - (832 + 570)) == (2061 + 126))) then
					if (((367 + 1039) == (4975 - 3569)) and v24(v123.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v131()
		local v143 = 0 + 0;
		while true do
			if (((2327 - (588 + 208)) < (11511 - 7240)) and (v143 == (1801 - (884 + 916)))) then
				if (((1329 - 694) == (369 + 266)) and v41) then
					v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 693 - (232 + 421));
					if (((5262 - (1569 + 320)) <= (873 + 2683)) and v29) then
						return v29;
					end
					v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 8 + 32);
					if (v29 or ((11089 - 7798) < (3885 - (316 + 289)))) then
						return v29;
					end
				end
				if (((11481 - 7095) >= (41 + 832)) and v42) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 1493 - (666 + 787));
					if (((1346 - (360 + 65)) <= (1030 + 72)) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 294 - (79 + 175));
					if (((7420 - 2714) >= (752 + 211)) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 122 - 82);
					if (v29 or ((1848 - 888) <= (1775 - (503 + 396)))) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 221 - (92 + 89));
					if (v29 or ((4007 - 1941) == (478 + 454))) then
						return v29;
					end
				end
				v143 = 2 + 0;
			end
			if (((18895 - 14070) < (663 + 4180)) and (v143 == (4 - 2))) then
				if (v43 or ((3383 + 494) >= (2168 + 2369))) then
					local v247 = 0 - 0;
					while true do
						if ((v247 == (1 + 0)) or ((6580 - 2265) < (2970 - (485 + 759)))) then
							v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 92 - 52);
							if (v29 or ((4868 - (442 + 747)) < (1760 - (832 + 303)))) then
								return v29;
							end
							v247 = 948 - (88 + 858);
						end
						if ((v247 == (1 + 2)) or ((3828 + 797) < (27 + 605))) then
							v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 829 - (766 + 23));
							if (v29 or ((409 - 326) > (2434 - 654))) then
								return v29;
							end
							break;
						end
						if (((1438 - 892) <= (3655 - 2578)) and ((1073 - (1036 + 37)) == v247)) then
							v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 29 + 11);
							if (v29 or ((1939 - 943) > (3384 + 917))) then
								return v29;
							end
							v247 = 1481 - (641 + 839);
						end
						if (((4983 - (910 + 3)) > (1751 - 1064)) and (v247 == (1686 - (1466 + 218)))) then
							v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 19 + 21);
							if (v29 or ((1804 - (556 + 592)) >= (1185 + 2145))) then
								return v29;
							end
							v247 = 811 - (329 + 479);
						end
					end
				end
				if (v44 or ((3346 - (174 + 680)) <= (1151 - 816))) then
					v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 82 - 42);
					if (((3086 + 1236) >= (3301 - (396 + 343))) and v29) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 4 + 36);
					if (v29 or ((5114 - (29 + 1448)) >= (5159 - (135 + 1254)))) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 150 - 110);
					if (v29 or ((11107 - 8728) > (3051 + 1527))) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 1567 - (389 + 1138));
					if (v29 or ((1057 - (102 + 472)) > (702 + 41))) then
						return v29;
					end
				end
				break;
			end
			if (((1361 + 1093) > (539 + 39)) and (v143 == (1545 - (320 + 1225)))) then
				if (((1655 - 725) < (2728 + 1730)) and v114) then
					local v248 = 1464 - (157 + 1307);
					while true do
						if (((2521 - (821 + 1038)) <= (2424 - 1452)) and (v248 == (0 + 0))) then
							v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 53 - 23, true);
							if (((1626 + 2744) == (10831 - 6461)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v113 or ((5788 - (834 + 192)) <= (55 + 806))) then
					v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 8 + 22);
					if (v29 or ((31 + 1381) == (6605 - 2341))) then
						return v29;
					end
					if (v115 or ((3472 - (300 + 4)) < (575 + 1578))) then
						local v253 = 0 - 0;
						while true do
							if (((362 - (112 + 250)) == v253) or ((1984 + 2992) < (3336 - 2004))) then
								v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 18 + 12);
								if (((2394 + 2234) == (3462 + 1166)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (v116 or ((27 + 27) == (294 + 101))) then
						v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 1444 - (1001 + 413));
						if (((182 - 100) == (964 - (244 + 638))) and v29) then
							return v29;
						end
					end
					if (v122.PurifySpirit:CooldownRemains() or ((1274 - (627 + 66)) < (840 - 558))) then
						v29 = v126.HandleAfflicted(v122.HealingSurge, v123.HealingSurgeMouseover, 632 - (512 + 90));
						if (v29 or ((6515 - (1665 + 241)) < (3212 - (373 + 344)))) then
							return v29;
						end
					end
				end
				v143 = 1 + 0;
			end
		end
	end
	local function v132()
		local v144 = 0 + 0;
		while true do
			if (((3038 - 1886) == (1949 - 797)) and ((1102 - (35 + 1064)) == v144)) then
				if (((1380 + 516) <= (7321 - 3899)) and v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) then
					if (v24(v122.AncestralGuidance, not v15:IsInRange(1 + 39)) or ((2226 - (298 + 938)) > (2879 - (233 + 1026)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) or ((2543 - (636 + 1030)) > (2401 + 2294))) then
					if (((2629 + 62) >= (550 + 1301)) and v24(v122.Ascendance, not v15:IsInRange(3 + 37))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 225 - (55 + 166);
			end
			if ((v144 == (1 + 3)) or ((301 + 2684) >= (18545 - 13689))) then
				if (((4573 - (36 + 261)) >= (2089 - 894)) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
					if (((4600 - (34 + 1334)) <= (1803 + 2887)) and v24(v122.ManaTideTotem, not v15:IsInRange(32 + 8))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v109 and v31) or not v109)) or ((2179 - (1035 + 248)) >= (3167 - (20 + 1)))) then
					if (((1595 + 1466) >= (3277 - (134 + 185))) and v122.AncestralCall:IsReady()) then
						if (((4320 - (549 + 584)) >= (1329 - (314 + 371))) and v24(v122.AncestralCall, not v15:IsInRange(137 - 97))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((1612 - (478 + 490)) <= (373 + 331)) and v122.BagofTricks:IsReady()) then
						if (((2130 - (786 + 386)) > (3067 - 2120)) and v24(v122.BagofTricks, not v15:IsInRange(1419 - (1055 + 324)))) then
							return "BagofTricks cooldowns";
						end
					end
					if (((5832 - (1093 + 247)) >= (2359 + 295)) and v122.Berserking:IsReady()) then
						if (((362 + 3080) >= (5967 - 4464)) and v24(v122.Berserking, not v15:IsInRange(135 - 95))) then
							return "Berserking cooldowns";
						end
					end
					if (v122.BloodFury:IsReady() or ((9020 - 5850) <= (3678 - 2214))) then
						if (v24(v122.BloodFury, not v15:IsInRange(15 + 25)) or ((18480 - 13683) == (15124 - 10736))) then
							return "BloodFury cooldowns";
						end
					end
					if (((416 + 135) <= (1741 - 1060)) and v122.Fireblood:IsReady()) then
						if (((3965 - (364 + 324)) > (1115 - 708)) and v24(v122.Fireblood, not v15:IsInRange(95 - 55))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if (((1557 + 3138) >= (5920 - 4505)) and (v144 == (1 - 0))) then
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((9755 - 6543) <= (2212 - (1249 + 19)))) then
					if ((v17:HealthPercentage() <= v83) or ((2795 + 301) <= (6998 - 5200))) then
						if (((4623 - (686 + 400)) == (2776 + 761)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((4066 - (73 + 156)) >= (8 + 1562)) and v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) then
					if ((v87 == "Player") or ((3761 - (721 + 90)) == (43 + 3769))) then
						if (((15334 - 10611) >= (2788 - (224 + 246))) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(64 - 24))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v87 == "Friendly under Cursor") or ((3731 - 1704) > (518 + 2334))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((28 + 1108) > (3171 + 1146))) then
							if (((9439 - 4691) == (15800 - 11052)) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(553 - (203 + 310)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((5729 - (1238 + 755)) <= (332 + 4408)) and (v87 == "Confirmation")) then
						if (v24(v122.SpiritLinkTotem, not v15:IsInRange(1574 - (709 + 825))) or ((6246 - 2856) <= (4457 - 1397))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 866 - (196 + 668);
			end
			if ((v144 == (0 - 0)) or ((2068 - 1069) > (3526 - (171 + 662)))) then
				if (((556 - (4 + 89)) < (2106 - 1505)) and v111 and ((v31 and v110) or not v110)) then
					local v249 = 0 + 0;
					while true do
						if ((v249 == (4 - 3)) or ((857 + 1326) < (2173 - (35 + 1451)))) then
							v29 = v126.HandleBottomTrinket(v125, v31, 1493 - (28 + 1425), nil);
							if (((6542 - (941 + 1052)) == (4362 + 187)) and v29) then
								return v29;
							end
							break;
						end
						if (((6186 - (822 + 692)) == (6669 - 1997)) and (v249 == (0 + 0))) then
							v29 = v126.HandleTopTrinket(v125, v31, 337 - (45 + 252), nil);
							if (v29 or ((3630 + 38) < (136 + 259))) then
								return v29;
							end
							v249 = 2 - 1;
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((4599 - (114 + 319)) == (652 - 197))) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((5700 - 1251) == (1698 + 965))) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((6371 - 2094) < (6262 - 3273))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 1964 - (556 + 1407);
			end
			if ((v144 == (1208 - (741 + 465))) or ((1335 - (170 + 295)) >= (2187 + 1962))) then
				if (((2032 + 180) < (7836 - 4653)) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) then
					if (((3852 + 794) > (1919 + 1073)) and v24(v122.HealingTideTotem, not v15:IsInRange(23 + 17))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((2664 - (957 + 273)) < (831 + 2275)) and v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) then
					if (((315 + 471) < (11518 - 8495)) and (v56 == "Player")) then
						if (v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(105 - 65)) or ((7458 - 5016) < (366 - 292))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((6315 - (389 + 1391)) == (2846 + 1689)) and (v56 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((314 + 2695) <= (4792 - 2687))) then
							if (((2781 - (783 + 168)) < (12313 - 8644)) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(40 + 0))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v56 == "Confirmation") or ((1741 - (309 + 2)) >= (11091 - 7479))) then
						if (((3895 - (1090 + 122)) >= (798 + 1662)) and v24(v122.AncestralProtectionTotem, not v15:IsInRange(134 - 94))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 3 + 0;
			end
		end
	end
	local function v133()
		if ((v94 and v126.AreUnitsBelowHealthPercentage(1213 - (628 + 490), 1 + 2, v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) or ((4466 - 2662) >= (14966 - 11691))) then
			if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2191 - (431 + 343)) > (7328 - 3699))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((13871 - 9076) > (318 + 84)) and v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (2 + 13))) then
			if (((6508 - (556 + 1139)) > (3580 - (6 + 9))) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if (((717 + 3195) == (2005 + 1907)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((2990 - (28 + 141)) <= (1869 + 2955)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (((2144 - 406) <= (1555 + 640)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if (((1358 - (486 + 831)) <= (7853 - 4835)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((7551 - 5406) <= (776 + 3328)) and (v17:HealthPercentage() <= v83)) then
				if (((8502 - 5813) < (6108 - (668 + 595))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v105 and v122.UnleashLife:IsReady()) or ((2090 + 232) > (529 + 2093))) then
			if ((v13:HealthPercentage() <= v90) or ((12364 - 7830) == (2372 - (23 + 267)))) then
				if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((3515 - (1129 + 815)) > (2254 - (371 + 16)))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) or ((4404 - (1326 + 424)) >= (5673 - 2677))) then
			if (((14536 - 10558) > (2222 - (88 + 30))) and v24(v123.HealingRainCursor, not v15:IsInRange(811 - (720 + 51)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if (((6662 - 3667) > (3317 - (421 + 1355))) and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) then
			if (((5359 - 2110) > (469 + 484)) and (v74 == "Player")) then
				if (v24(v123.HealingRainPlayer, not v15:IsInRange(1123 - (286 + 797)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((11964 - 8691) > (7573 - 3000))) then
					return "healing_rain healingaoe";
				end
			elseif ((v74 == "Friendly under Cursor") or ((3590 - (397 + 42)) < (402 + 882))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((2650 - (24 + 776)) == (2355 - 826))) then
					if (((1606 - (222 + 563)) < (4677 - 2554)) and v24(v123.HealingRainCursor, not v15:IsInRange(29 + 11), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((1092 - (23 + 167)) < (4123 - (690 + 1108))) and (v74 == "Enemy under Cursor")) then
				if (((310 + 548) <= (2444 + 518)) and v16:Exists() and v13:CanAttack(v16)) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(888 - (40 + 808)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((650 + 3296) < (4925 - 3637))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v74 == "Confirmation") or ((3099 + 143) == (300 + 267))) then
				if (v24(v122.HealingRain, not v15:IsInRange(22 + 18), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1418 - (47 + 524)) >= (820 + 443))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) or ((6158 - 3905) == (2767 - 916))) then
			if ((v71 == "Player") or ((4759 - 2672) > (4098 - (1165 + 561)))) then
				if (v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(2 + 38)) or ((13766 - 9321) < (1584 + 2565))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v71 == "Friendly under Cursor") or ((2297 - (341 + 138)) == (23 + 62))) then
				if (((1300 - 670) < (2453 - (89 + 237))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(128 - 88)) or ((4080 - 2142) == (3395 - (581 + 300)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((5475 - (855 + 365)) >= (130 - 75)) and (v71 == "Confirmation")) then
				if (((980 + 2019) > (2391 - (1030 + 205))) and v24(v122.EarthenWallTotem, not v15:IsInRange(38 + 2))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((2187 + 163) > (1441 - (156 + 130))) and v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) then
			if (((9154 - 5125) <= (8179 - 3326)) and (v66 == "Player")) then
				if (v24(v123.DownpourPlayer, not v15:IsInRange(81 - 41), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((136 + 380) > (2003 + 1431))) then
					return "downpour healingaoe";
				end
			elseif (((4115 - (10 + 59)) >= (858 + 2175)) and (v66 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((13390 - 10671) <= (2610 - (671 + 492)))) then
					if (v24(v123.DownpourCursor, not v15:IsInRange(32 + 8), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((5349 - (369 + 846)) < (1040 + 2886))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v66 == "Confirmation") or ((140 + 24) >= (4730 - (1036 + 909)))) then
				if (v24(v122.Downpour, not v15:IsInRange(32 + 8), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((881 - 356) == (2312 - (11 + 192)))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((17 + 16) == (208 - (135 + 40))) and v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (24 - 14))) then
			if (((1841 + 1213) <= (8844 - 4829)) and v24(v122.CloudburstTotem)) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((2804 - 933) < (3558 - (50 + 126))) and v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) then
			if (((3600 - 2307) <= (480 + 1686)) and v24(v122.Wellspring, not v15:IsInRange(1453 - (1233 + 180)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) or ((3548 - (522 + 447)) < (1544 - (107 + 1314)))) then
			if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((393 + 453) >= (7215 - 4847))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) or ((1705 + 2307) <= (6668 - 3310))) then
			if (((5911 - 4417) <= (4915 - (716 + 1194))) and v24(v122.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) or ((54 + 3057) == (229 + 1905))) then
			if (((2858 - (74 + 429)) == (4543 - 2188)) and v24(v122.HealingStreamTotem, nil)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v134()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (2 - 1)) or ((416 + 172) <= (1331 - 899))) then
				if (((11860 - 7063) >= (4328 - (279 + 154))) and v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) then
					if (((4355 - (454 + 324)) == (2815 + 762)) and v24(v122.EarthShield)) then
						return "earth_shield player healingst";
					end
				end
				if (((3811 - (12 + 5)) > (1992 + 1701)) and v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) then
					if (v126.IsSoloMode() or ((3248 - 1973) == (1516 + 2584))) then
						if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((2684 - (277 + 816)) >= (15297 - 11717))) then
							if (((2166 - (1058 + 125)) <= (339 + 1469)) and v24(v122.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) or ((3125 - (815 + 160)) <= (5135 - 3938))) then
						if (((8946 - 5177) >= (280 + 893)) and v24(v122.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v145 = 5 - 3;
			end
			if (((3383 - (41 + 1857)) == (3378 - (1222 + 671))) and (v145 == (5 - 3))) then
				if ((v99 and v122.HealingSurge:IsReady()) or ((4764 - 1449) <= (3964 - (229 + 953)))) then
					if ((v17:HealthPercentage() <= v77) or ((2650 - (1111 + 663)) >= (4543 - (874 + 705)))) then
						if (v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((313 + 1919) > (1704 + 793))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v101 and v122.HealingWave:IsReady()) or ((4385 - 2275) <= (10 + 322))) then
					if (((4365 - (642 + 37)) > (724 + 2448)) and (v17:HealthPercentage() <= v80)) then
						if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((716 + 3758) < (2058 - 1238))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((4733 - (233 + 221)) >= (6664 - 3782)) and (v145 == (0 + 0))) then
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((3570 - (718 + 823)) >= (2216 + 1305))) then
					if ((v17:HealthPercentage() <= v83) or ((2842 - (266 + 539)) >= (13142 - 8500))) then
						if (((2945 - (636 + 589)) < (10581 - 6123)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((898 - 462) > (2395 + 626))) then
					if (((260 + 453) <= (1862 - (657 + 358))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (((5702 - 3548) <= (9183 - 5152)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 1188 - (1151 + 36);
			end
		end
	end
	local function v135()
		local v146 = 0 + 0;
		while true do
			if (((1214 + 3401) == (13782 - 9167)) and (v146 == (1833 - (1552 + 280)))) then
				if (v122.FlameShock:IsReady() or ((4624 - (64 + 770)) == (340 + 160))) then
					local v250 = 0 - 0;
					while true do
						if (((16 + 73) < (1464 - (157 + 1086))) and (v250 == (0 - 0))) then
							if (((8995 - 6941) >= (2179 - 758)) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(54 - 14), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (((1511 - (599 + 220)) < (6089 - 3031)) and v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v122.LavaBurst:IsReady() or ((5185 - (1813 + 118)) == (1210 + 445))) then
					if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2513 - (841 + 376)) == (6880 - 1970))) then
						return "lava_burst damage";
					end
				end
				v146 = 1 + 1;
			end
			if (((9192 - 5824) == (4227 - (464 + 395))) and (v146 == (0 - 0))) then
				if (((1270 + 1373) < (4652 - (467 + 370))) and v122.Stormkeeper:IsReady()) then
					if (((3952 - 2039) > (362 + 131)) and v24(v122.Stormkeeper, not v15:IsInRange(137 - 97))) then
						return "stormkeeper damage";
					end
				end
				if (((742 + 4013) > (7975 - 4547)) and (math.max(#v13:GetEnemiesInRange(540 - (150 + 370)), v13:GetEnemiesInSplashRangeCount(1290 - (74 + 1208))) > (4 - 2))) then
					if (((6549 - 5168) <= (1686 + 683)) and v122.ChainLightning:IsReady()) then
						if (v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((5233 - (14 + 376)) == (7083 - 2999))) then
							return "chain_lightning damage";
						end
					end
				end
				v146 = 1 + 0;
			end
			if (((4102 + 567) > (347 + 16)) and (v146 == (5 - 3))) then
				if (v122.LightningBolt:IsReady() or ((1413 + 464) >= (3216 - (23 + 55)))) then
					if (((11237 - 6495) >= (2420 + 1206)) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v136()
		v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v60 = EpicSettings.Settings['ChainHealGroup'];
		v61 = EpicSettings.Settings['ChainHealHP'];
		v45 = EpicSettings.Settings['DispelDebuffs'];
		v46 = EpicSettings.Settings['DispelBuffs'];
		v64 = EpicSettings.Settings['DownpourGroup'];
		v65 = EpicSettings.Settings['DownpourHP'];
		v66 = EpicSettings.Settings['DownpourUsage'];
		v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v70 = EpicSettings.Settings['EarthenWallTotemHP'];
		v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v39 = EpicSettings.Settings['healingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v72 = EpicSettings.Settings['HealingRainGroup'];
		v73 = EpicSettings.Settings['HealingRainHP'];
		v74 = EpicSettings.Settings['HealingRainUsage'];
		v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v76 = EpicSettings.Settings['HealingStreamTotemHP'];
		v77 = EpicSettings.Settings['HealingSurgeHP'];
		v78 = EpicSettings.Settings['HealingTideTotemGroup'];
		v79 = EpicSettings.Settings['HealingTideTotemHP'];
		v80 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v50 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['InterruptWithStun'];
		v83 = EpicSettings.Settings['RiptideHP'];
		v84 = EpicSettings.Settings['RiptideTankHP'];
		v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v90 = EpicSettings.Settings['UnleashLifeHP'];
		v94 = EpicSettings.Settings['UseChainHeal'];
		v95 = EpicSettings.Settings['UseCloudburstTotem'];
		v97 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['useHealingPotion'];
		v98 = EpicSettings.Settings['UseHealingStreamTotem'];
		v99 = EpicSettings.Settings['UseHealingSurge'];
		v100 = EpicSettings.Settings['UseHealingTideTotem'];
		v101 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v47 = EpicSettings.Settings['UsePurgeTarget'];
		v103 = EpicSettings.Settings['UseRiptide'];
		v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v105 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v137()
		v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v53 = EpicSettings.Settings['AncestralGuidanceHP'];
		v57 = EpicSettings.Settings['AscendanceGroup'];
		v58 = EpicSettings.Settings['AscendanceHP'];
		v59 = EpicSettings.Settings['AstralShiftHP'];
		v62 = EpicSettings.Settings['CloudburstTotemGroup'];
		v63 = EpicSettings.Settings['CloudburstTotemHP'];
		v67 = EpicSettings.Settings['EarthElementalHP'];
		v68 = EpicSettings.Settings['EarthElementalTankHP'];
		v81 = EpicSettings.Settings['ManaTideTotemMana'];
		v82 = EpicSettings.Settings['PrimordialWaveHP'];
		v91 = EpicSettings.Settings['UseAncestralGuidance'];
		v92 = EpicSettings.Settings['UseAscendance'];
		v93 = EpicSettings.Settings['UseAstralShift'];
		v96 = EpicSettings.Settings['UseEarthElemental'];
		v102 = EpicSettings.Settings['UseManaTideTotem'];
		v106 = EpicSettings.Settings['UseWellspring'];
		v107 = EpicSettings.Settings['WellspringGroup'];
		v108 = EpicSettings.Settings['WellspringHP'];
		v117 = EpicSettings.Settings['useManaPotion'];
		v118 = EpicSettings.Settings['manaPotionSlider'];
		v109 = EpicSettings.Settings['racialsWithCD'];
		v35 = EpicSettings.Settings['useRacials'];
		v110 = EpicSettings.Settings['trinketsWithCD'];
		v111 = EpicSettings.Settings['useTrinkets'];
		v112 = EpicSettings.Settings['fightRemainsCheck'];
		v51 = EpicSettings.Settings['useWeapon'];
		v113 = EpicSettings.Settings['handleAfflicted'];
		v114 = EpicSettings.Settings['HandleIncorporeal'];
		v41 = EpicSettings.Settings['HandleChromie'];
		v43 = EpicSettings.Settings['HandleCharredBrambles'];
		v42 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleFyrakkNPC'];
		v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local v138 = 0 + 0;
	local function v139()
		v136();
		v137();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		local v236;
		if (v13:IsDeadOrGhost() or ((7039 - 2499) == (289 + 627))) then
			return;
		end
		if (v126.TargetIsValid() or v13:AffectingCombat() or ((2057 - (652 + 249)) > (11627 - 7282))) then
			v121 = v13:GetEnemiesInRange(1908 - (708 + 1160));
			v119 = v10.BossFightRemains(nil, true);
			v120 = v119;
			if (((6072 - 3835) < (7746 - 3497)) and (v120 == (11138 - (10 + 17)))) then
				v120 = v10.FightRemains(v121, false);
			end
		end
		if (not v13:AffectingCombat() or ((603 + 2080) < (1755 - (1400 + 332)))) then
			if (((1336 - 639) <= (2734 - (242 + 1666))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v244 = 0 + 0;
				local v245;
				while true do
					if (((405 + 700) <= (1003 + 173)) and (v244 == (940 - (850 + 90)))) then
						v245 = v126.DeadFriendlyUnitsCount();
						if (((5917 - 2538) <= (5202 - (360 + 1030))) and (v245 > (1 + 0))) then
							if (v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2223 - 1435) >= (2222 - 606))) then
								return "ancestral_vision";
							end
						elseif (((3515 - (909 + 752)) <= (4602 - (109 + 1114))) and v24(v123.AncestralSpiritMouseover, not v15:IsInRange(73 - 33), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v236 = v131();
		if (((1771 + 2778) == (4791 - (6 + 236))) and v236) then
			return v236;
		end
		if (v13:AffectingCombat() or v30 or ((1904 + 1118) >= (2435 + 589))) then
			local v241 = 0 - 0;
			local v242;
			while true do
				if (((8419 - 3599) > (3331 - (1076 + 57))) and (v241 == (1 + 0))) then
					if (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 714 - (579 + 110)) >= (1 + 0)) or ((939 + 122) >= (2596 + 2295))) then
						local v254 = 407 - (174 + 233);
						while true do
							if (((3809 - 2445) <= (7850 - 3377)) and ((0 + 0) == v254)) then
								v29 = v126.FocusUnit(v242, nil, 1214 - (663 + 511), nil, 23 + 2, v122.ChainHeal);
								if (v29 or ((781 + 2814) <= (9 - 6))) then
									return v29;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v241 == (0 + 0)) or ((10999 - 6327) == (9324 - 5472))) then
					v242 = v45 and v122.PurifySpirit:IsReady() and v32;
					if (((744 + 815) == (3033 - 1474)) and v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 18 + 7) < (1 + 0))) then
						local v255 = 722 - (478 + 244);
						while true do
							if ((v255 == (517 - (440 + 77))) or ((797 + 955) <= (2883 - 2095))) then
								v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 1571 - (655 + 901), 8 + 32, "TANK", true, 20 + 5, v122.ChainHeal);
								if (v29 or ((2639 + 1268) == (712 - 535))) then
									return v29;
								end
								v255 = 1446 - (695 + 750);
							end
							if (((11849 - 8379) > (856 - 301)) and (v255 == (3 - 2))) then
								if ((v126.UnitGroupRole(v17) == "TANK") or ((1323 - (285 + 66)) == (1503 - 858))) then
									if (((4492 - (682 + 628)) >= (341 + 1774)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
										return "earth_shield_tank main apl 1";
									end
								end
								break;
							end
						end
					end
					v241 = 300 - (176 + 123);
				end
			end
		end
		if (((1629 + 2264) < (3213 + 1216)) and v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(309 - (239 + 30)) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) then
			if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((780 + 2087) < (1831 + 74))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if ((v13:AffectingCombat() and v126.TargetIsValid()) or ((3178 - 1382) >= (12638 - 8587))) then
			local v243 = 315 - (306 + 9);
			while true do
				if (((5649 - 4030) <= (654 + 3102)) and ((2 + 1) == v243)) then
					if (((291 + 313) == (1726 - 1122)) and (v120 > v112)) then
						v236 = v132();
						if (v236 or ((5859 - (1140 + 235)) == (573 + 327))) then
							return v236;
						end
					end
					break;
				end
				if (((1 + 0) == v243) or ((1145 + 3314) <= (1165 - (33 + 19)))) then
					v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 11 + 19, true, v16);
					if (((10885 - 7253) > (1497 + 1901)) and v29) then
						return v29;
					end
					v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 58 - 28, nil, v16);
					if (((3828 + 254) <= (5606 - (586 + 103))) and v29) then
						return v29;
					end
					v243 = 1 + 1;
				end
				if (((14875 - 10043) >= (2874 - (1309 + 179))) and ((0 - 0) == v243)) then
					if (((60 + 77) == (367 - 230)) and ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady())) then
						if (v24(v123.UseWeapon, nil) or ((1186 + 384) >= (9203 - 4871))) then
							return "Using Weapon Macro";
						end
					end
					if ((v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) or ((8097 - 4033) <= (2428 - (295 + 314)))) then
						if (v24(v123.ManaPotion, nil) or ((12246 - 7260) < (3536 - (1300 + 662)))) then
							return "Mana Potion main";
						end
					end
					v29 = v126.Interrupt(v122.WindShear, 94 - 64, true);
					if (((6181 - (1178 + 577)) > (90 + 82)) and v29) then
						return v29;
					end
					v243 = 2 - 1;
				end
				if (((1991 - (851 + 554)) > (403 + 52)) and ((5 - 3) == v243)) then
					v236 = v130();
					if (((1793 - 967) == (1128 - (115 + 187))) and v236) then
						return v236;
					end
					if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((3078 + 941) > (4205 + 236))) then
						if (((7948 - 5931) < (5422 - (160 + 1001))) and v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge))) then
							return "greater_purge utility";
						end
					end
					if (((4126 + 590) > (56 + 24)) and v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) then
						if (v24(v122.Purge, not v15:IsSpellInRange(v122.Purge)) or ((7178 - 3671) == (3630 - (237 + 121)))) then
							return "purge utility";
						end
					end
					v243 = 900 - (525 + 372);
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((1660 - 784) >= (10103 - 7028))) then
			if (((4494 - (96 + 46)) > (3331 - (643 + 134))) and v32 and v45) then
				if ((v122.Bursting:MaxDebuffStack() > (2 + 2)) or ((10564 - 6158) < (15010 - 10967))) then
					local v251 = 0 + 0;
					while true do
						if ((v251 == (0 - 0)) or ((3860 - 1971) >= (4102 - (316 + 403)))) then
							v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
							if (((1258 + 634) <= (7516 - 4782)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((695 + 1228) < (5585 - 3367)) and v16 and v16:Exists() and v16:IsAPlayer()) then
					if (((1540 + 633) > (123 + 256)) and v126.UnitHasPoisonDebuff(v16)) then
						if (v122.PoisonCleansingTotem:IsCastable() or ((8977 - 6386) == (16280 - 12871))) then
							if (((9376 - 4862) > (191 + 3133)) and v24(v122.PoisonCleansingTotem, nil)) then
								return "poison_cleansing_totem dispel mouseover";
							end
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and (v126.UnitHasDispellableDebuffByPlayer(v17) or v126.DispellableFriendlyUnit(49 - 24))) or ((11 + 197) >= (14204 - 9376))) then
					if (v122.PurifySpirit:IsCastable() or ((1600 - (12 + 5)) > (13854 - 10287))) then
						local v256 = 0 - 0;
						while true do
							if ((v256 == (0 - 0)) or ((3255 - 1942) == (162 + 632))) then
								if (((5147 - (1656 + 317)) > (2586 + 316)) and (v138 == (0 + 0))) then
									v138 = GetTime();
								end
								if (((10955 - 6835) <= (20965 - 16705)) and v126.Wait(854 - (5 + 349), v138)) then
									if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((4194 - 3311) > (6049 - (266 + 1005)))) then
										return "purify_spirit dispel focus";
									end
									v138 = 0 + 0;
								end
								break;
							end
						end
					end
				end
				if ((v16 and v16:Exists() and not v13:CanAttack(v16) and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((12351 - 8731) >= (6439 - 1548))) then
					if (((5954 - (561 + 1135)) > (1220 - 283)) and v122.PurifySpirit:IsCastable()) then
						if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((16004 - 11135) < (1972 - (507 + 559)))) then
							return "purify_spirit dispel mouseover";
						end
					end
				end
			end
			if ((v122.Bursting:AuraActiveCount() > (7 - 4)) or ((3788 - 2563) > (4616 - (212 + 176)))) then
				local v246 = 905 - (250 + 655);
				while true do
					if (((9075 - 5747) > (3910 - 1672)) and (v246 == (0 - 0))) then
						if (((5795 - (1869 + 87)) > (4873 - 3468)) and (v122.Bursting:MaxDebuffStack() > (1906 - (484 + 1417))) and v122.SpiritLinkTotem:IsReady()) then
							if ((v87 == "Player") or ((2771 - 1478) <= (849 - 342))) then
								if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(813 - (48 + 725))) or ((4730 - 1834) < (2159 - 1354))) then
									return "spirit_link_totem bursting";
								end
							elseif (((1346 + 970) == (6189 - 3873)) and (v87 == "Friendly under Cursor")) then
								if ((v16:Exists() and not v13:CanAttack(v16)) or ((720 + 1850) == (447 + 1086))) then
									if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(893 - (152 + 701))) or ((2194 - (430 + 881)) == (560 + 900))) then
										return "spirit_link_totem bursting";
									end
								end
							elseif ((v87 == "Confirmation") or ((5514 - (557 + 338)) <= (296 + 703))) then
								if (v24(v122.SpiritLinkTotem, not v15:IsInRange(112 - 72)) or ((11941 - 8531) > (10935 - 6819))) then
									return "spirit_link_totem bursting";
								end
							end
						end
						if ((v94 and v122.ChainHeal:IsReady()) or ((1945 - 1042) >= (3860 - (499 + 302)))) then
							if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal)) or ((4842 - (39 + 827)) < (7886 - 5029))) then
								return "Chain Heal Spam because of Bursting";
							end
						end
						break;
					end
				end
			end
			if (((11010 - 6080) > (9162 - 6855)) and v17:Exists() and (v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) then
				if (v122.PrimordialWaveResto:IsCastable() or ((6211 - 2165) < (111 + 1180))) then
					if (v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto)) or ((12412 - 8171) == (568 + 2977))) then
						return "primordial_wave main";
					end
				end
			end
			if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (4 - 1)))) or ((4152 - (103 + 1)) > (4786 - (475 + 79)))) then
				if (v24(v122.TotemicRecall, nil) or ((3783 - 2033) >= (11113 - 7640))) then
					return "totemic_recall main";
				end
			end
			if (((410 + 2756) == (2787 + 379)) and v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) then
				if (((3266 - (1395 + 108)) < (10836 - 7112)) and v24(v122.NaturesSwiftness, nil)) then
					return "natures_swiftness main";
				end
			end
			if (((1261 - (7 + 1197)) <= (1188 + 1535)) and v33) then
				if ((v15:Exists() and not v13:CanAttack(v15)) or ((723 + 1347) == (762 - (27 + 292)))) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (1 - 0)) or ((11344 - 8639) == (2746 - 1353))) then
							if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((8762 - 4161) < (200 - (43 + 96)))) then
								if (v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((5669 - 4279) >= (10725 - 5981))) then
									return "chain_heal healing target";
								end
							end
							if ((v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) or ((1663 + 340) > (1083 + 2751))) then
								if (v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((308 - 152) > (1500 + 2413))) then
									return "healing_wave healing target";
								end
							end
							break;
						end
						if (((365 - 170) == (62 + 133)) and (v252 == (0 + 0))) then
							if (((4856 - (1414 + 337)) >= (3736 - (1642 + 298))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
								if (((11415 - 7036) >= (6130 - 3999)) and (v15:HealthPercentage() <= v83)) then
									if (((11407 - 7563) >= (673 + 1370)) and v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide))) then
										return "riptide healing target";
									end
								end
							end
							if ((v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) or ((2515 + 717) <= (3703 - (357 + 615)))) then
								if (((3444 + 1461) == (12035 - 7130)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
									return "unleash_life healing target";
								end
							end
							v252 = 1 + 0;
						end
					end
				end
				v236 = v133();
				if (v236 or ((8863 - 4727) >= (3528 + 883))) then
					return v236;
				end
				v236 = v134();
				if (v236 or ((201 + 2757) == (2525 + 1492))) then
					return v236;
				end
			end
			if (((2529 - (384 + 917)) >= (1510 - (128 + 569))) and v34) then
				if (v126.TargetIsValid() or ((4998 - (1407 + 136)) > (5937 - (687 + 1200)))) then
					v236 = v135();
					if (((1953 - (556 + 1154)) == (854 - 611)) and v236) then
						return v236;
					end
				end
			end
		end
	end
	local function v140()
		v128();
		v122.Bursting:RegisterAuraTracking();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(359 - (9 + 86), v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

