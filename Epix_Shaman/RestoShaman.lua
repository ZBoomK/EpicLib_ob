local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (118 - (29 + 88))) or ((3577 - (1561 + 386)) > (1434 + 2764))) then
			return v6(...);
		end
		if (((2760 - 1706) == (5249 - 4195)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2455 - 1779) >= (584 + 1058))) then
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
	local v118 = 32972 - 21861;
	local v119 = 6081 + 5030;
	local v120;
	v10:RegisterForEvent(function()
		local v140 = 0 - 0;
		while true do
			if (((2735 + 1401) > (1334 + 1063)) and (v140 == (0 + 0))) then
				v118 = 9330 + 1781;
				v119 = 10871 + 240;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v18.Shaman.Restoration;
	local v122 = v25.Shaman.Restoration;
	local v123 = v20.Shaman.Restoration;
	local v124 = {};
	local v125 = v22.Commons.Everyone;
	local v126 = v22.Commons.Shaman;
	local function v127()
		if (v121.ImprovedPurifySpirit:IsAvailable() or ((4767 - (153 + 280)) == (12257 - 8012))) then
			v125.DispellableDebuffs = v21.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (5 + 0));
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1 + 0)) or ((3881 + 395) <= (2197 + 834))) then
				if ((v123.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((7280 - 2498) <= (742 + 457))) then
					if (v24(v122.Healthstone) or ((5531 - (89 + 578)) < (1359 + 543))) then
						return "healthstone defensive 3";
					end
				end
				if (((10059 - 5220) >= (4749 - (572 + 477))) and v38 and (v13:HealthPercentage() <= v39)) then
					local v240 = 0 + 0;
					while true do
						if ((v240 == (0 + 0)) or ((129 + 946) > (2004 - (84 + 2)))) then
							if (((652 - 256) <= (2741 + 1063)) and (v40 == "Refreshing Healing Potion")) then
								if (v123.RefreshingHealingPotion:IsReady() or ((5011 - (497 + 345)) == (56 + 2131))) then
									if (((238 + 1168) == (2739 - (605 + 728))) and v24(v122.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((1093 + 438) < (9495 - 5224)) and (v40 == "Dreamwalker's Healing Potion")) then
								if (((30 + 605) == (2347 - 1712)) and v123.DreamwalkersHealingPotion:IsReady()) then
									if (((3041 + 332) <= (9851 - 6295)) and v24(v122.RefreshingHealingPotion)) then
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
			if ((v142 == (0 + 0)) or ((3780 - (457 + 32)) < (1392 + 1888))) then
				if (((5788 - (832 + 570)) >= (823 + 50)) and v92 and v121.AstralShift:IsReady()) then
					if (((241 + 680) <= (3899 - 2797)) and (v13:HealthPercentage() <= v58)) then
						if (((2267 + 2439) >= (1759 - (588 + 208))) and v24(v121.AstralShift, not v15:IsInRange(107 - 67))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v95 and v121.EarthElemental:IsReady()) or ((2760 - (884 + 916)) <= (1833 - 957))) then
					if ((v13:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67) or ((1198 + 868) == (1585 - (232 + 421)))) then
						if (((6714 - (1569 + 320)) < (1189 + 3654)) and v24(v121.EarthElemental, not v15:IsInRange(8 + 32))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 3 - 2;
			end
		end
	end
	local function v130()
		local v143 = 605 - (316 + 289);
		while true do
			if ((v143 == (5 - 3)) or ((180 + 3697) >= (5990 - (666 + 787)))) then
				if (v43 or ((4740 - (360 + 65)) < (1614 + 112))) then
					v29 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 294 - (79 + 175));
					if (v29 or ((5800 - 2121) < (488 + 137))) then
						return v29;
					end
					v29 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 122 - 82);
					if (v29 or ((8907 - 4282) < (1531 - (503 + 396)))) then
						return v29;
					end
					v29 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 221 - (92 + 89));
					if (v29 or ((160 - 77) > (913 + 867))) then
						return v29;
					end
					v29 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 24 + 16);
					if (((2138 - 1592) <= (148 + 929)) and v29) then
						return v29;
					end
				end
				if (v44 or ((2270 - 1274) > (3753 + 548))) then
					local v241 = 0 + 0;
					while true do
						if (((12395 - 8325) > (86 + 601)) and (v241 == (2 - 0))) then
							v29 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 1284 - (485 + 759));
							if (v29 or ((1517 - 861) >= (4519 - (442 + 747)))) then
								return v29;
							end
							v241 = 1138 - (832 + 303);
						end
						if ((v241 == (947 - (88 + 858))) or ((760 + 1732) <= (278 + 57))) then
							v29 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 2 + 38);
							if (((5111 - (766 + 23)) >= (12647 - 10085)) and v29) then
								return v29;
							end
							v241 = 2 - 0;
						end
						if ((v241 == (0 - 0)) or ((12343 - 8706) >= (4843 - (1036 + 37)))) then
							v29 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 29 + 11);
							if (v29 or ((4632 - 2253) > (3602 + 976))) then
								return v29;
							end
							v241 = 1481 - (641 + 839);
						end
						if ((v241 == (916 - (910 + 3))) or ((1231 - 748) > (2427 - (1466 + 218)))) then
							v29 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 19 + 21);
							if (((3602 - (556 + 592)) > (206 + 372)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1738 - (329 + 479)) < (5312 - (174 + 680))) and (v143 == (0 - 0))) then
				if (((1371 - 709) <= (694 + 278)) and v113) then
					local v242 = 739 - (396 + 343);
					while true do
						if (((387 + 3983) == (5847 - (29 + 1448))) and (v242 == (1389 - (135 + 1254)))) then
							v29 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 113 - 83, true);
							if (v29 or ((22234 - 17472) <= (574 + 287))) then
								return v29;
							end
							break;
						end
					end
				end
				if (v112 or ((2939 - (389 + 1138)) == (4838 - (102 + 472)))) then
					v29 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 29 + 1);
					if (v29 or ((1757 + 1411) < (2008 + 145))) then
						return v29;
					end
					if (v114 or ((6521 - (320 + 1225)) < (2370 - 1038))) then
						v29 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 19 + 11);
						if (((6092 - (157 + 1307)) == (6487 - (821 + 1038))) and v29) then
							return v29;
						end
					end
					if (v115 or ((134 - 80) == (44 + 351))) then
						local v249 = 0 - 0;
						while true do
							if (((31 + 51) == (202 - 120)) and (v249 == (1026 - (834 + 192)))) then
								v29 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 2 + 28);
								if (v29 or ((150 + 431) < (7 + 275))) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v143 = 1 - 0;
			end
			if ((v143 == (305 - (300 + 4))) or ((1231 + 3378) < (6531 - 4036))) then
				if (((1514 - (112 + 250)) == (460 + 692)) and v41) then
					v29 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 100 - 60);
					if (((1087 + 809) <= (1770 + 1652)) and v29) then
						return v29;
					end
					v29 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 30 + 10);
					if (v29 or ((491 + 499) > (1204 + 416))) then
						return v29;
					end
				end
				if (v42 or ((2291 - (1001 + 413)) > (10469 - 5774))) then
					local v243 = 882 - (244 + 638);
					while true do
						if (((3384 - (627 + 66)) >= (5515 - 3664)) and (v243 == (603 - (512 + 90)))) then
							v29 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 1946 - (1665 + 241));
							if (v29 or ((3702 - (373 + 344)) >= (2191 + 2665))) then
								return v29;
							end
							v243 = 1 + 1;
						end
						if (((11278 - 7002) >= (2021 - 826)) and (v243 == (1101 - (35 + 1064)))) then
							v29 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 30 + 10);
							if (((6914 - 3682) <= (19 + 4671)) and v29) then
								return v29;
							end
							v243 = 1239 - (298 + 938);
						end
						if (((1259 - (233 + 1026)) == v243) or ((2562 - (636 + 1030)) >= (1609 + 1537))) then
							v29 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 40 + 0);
							if (((910 + 2151) >= (200 + 2758)) and v29) then
								return v29;
							end
							v243 = 222 - (55 + 166);
						end
						if (((618 + 2569) >= (65 + 579)) and (v243 == (11 - 8))) then
							v29 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 337 - (36 + 261));
							if (((1126 - 482) <= (2072 - (34 + 1334))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v143 = 1 + 1;
			end
		end
	end
	local function v131()
		local v144 = 0 + 0;
		while true do
			if (((2241 - (1035 + 248)) > (968 - (20 + 1))) and (v144 == (2 + 1))) then
				if (((4811 - (134 + 185)) >= (3787 - (549 + 584))) and v90 and v125.AreUnitsBelowHealthPercentage(v52, v51) and v121.AncestralGuidance:IsReady()) then
					if (((4127 - (314 + 371)) >= (5159 - 3656)) and v24(v121.AncestralGuidance, not v15:IsInRange(1008 - (478 + 490)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v91 and v125.AreUnitsBelowHealthPercentage(v57, v56) and v121.Ascendance:IsReady()) or ((1680 + 1490) <= (2636 - (786 + 386)))) then
					if (v24(v121.Ascendance, not v15:IsInRange(129 - 89)) or ((6176 - (1055 + 324)) == (5728 - (1093 + 247)))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 4 + 0;
			end
			if (((58 + 493) <= (2703 - 2022)) and (v144 == (13 - 9))) then
				if (((9324 - 6047) > (1022 - 615)) and v101 and (v13:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) then
					if (((1671 + 3024) >= (5451 - 4036)) and v24(v121.ManaTideTotem, not v15:IsInRange(137 - 97))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v108 and v31) or not v108)) or ((2422 + 790) <= (2413 - 1469))) then
					local v244 = 688 - (364 + 324);
					while true do
						if ((v244 == (2 - 1)) or ((7428 - 4332) <= (596 + 1202))) then
							if (((14799 - 11262) == (5663 - 2126)) and v121.Berserking:IsReady()) then
								if (((11653 - 7816) >= (2838 - (1249 + 19))) and v24(v121.Berserking, not v15:IsInRange(37 + 3))) then
									return "Berserking cooldowns";
								end
							end
							if (v121.BloodFury:IsReady() or ((11482 - 8532) == (4898 - (686 + 400)))) then
								if (((3706 + 1017) >= (2547 - (73 + 156))) and v24(v121.BloodFury, not v15:IsInRange(1 + 39))) then
									return "BloodFury cooldowns";
								end
							end
							v244 = 813 - (721 + 90);
						end
						if ((v244 == (0 + 0)) or ((6581 - 4554) > (3322 - (224 + 246)))) then
							if (v121.AncestralCall:IsReady() or ((1840 - 704) > (7948 - 3631))) then
								if (((862 + 3886) == (113 + 4635)) and v24(v121.AncestralCall, not v15:IsInRange(30 + 10))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((7427 - 3691) <= (15773 - 11033)) and v121.BagofTricks:IsReady()) then
								if (v24(v121.BagofTricks, not v15:IsInRange(553 - (203 + 310))) or ((5383 - (1238 + 755)) <= (214 + 2846))) then
									return "BagofTricks cooldowns";
								end
							end
							v244 = 1535 - (709 + 825);
						end
						if (((3 - 1) == v244) or ((1454 - 455) > (3557 - (196 + 668)))) then
							if (((1827 - 1364) < (1244 - 643)) and v121.Fireblood:IsReady()) then
								if (v24(v121.Fireblood, not v15:IsInRange(873 - (171 + 662))) or ((2276 - (4 + 89)) < (2407 - 1720))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1657 + 2892) == (19980 - 15431)) and (v144 == (0 + 0))) then
				if (((6158 - (35 + 1451)) == (6125 - (28 + 1425))) and v110 and ((v31 and v109) or not v109)) then
					v29 = v125.HandleTopTrinket(v124, v31, 2033 - (941 + 1052), nil);
					if (v29 or ((3518 + 150) < (1909 - (822 + 692)))) then
						return v29;
					end
					v29 = v125.HandleBottomTrinket(v124, v31, 57 - 17, nil);
					if (v29 or ((1963 + 2203) == (752 - (45 + 252)))) then
						return v29;
					end
				end
				if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((4402 + 47) == (917 + 1746))) then
					if (((v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) or ((10408 - 6131) < (3422 - (114 + 319)))) then
						if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((1249 - 379) >= (5315 - 1166))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 1 + 0;
			end
			if (((3294 - 1082) < (6668 - 3485)) and (v144 == (1965 - (556 + 1407)))) then
				if (((5852 - (741 + 465)) > (3457 - (170 + 295))) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77) and v121.HealingTideTotem:IsReady()) then
					if (((756 + 678) < (2853 + 253)) and v24(v121.HealingTideTotem, not v15:IsInRange(98 - 58))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((652 + 134) < (1939 + 1084)) and v125.AreUnitsBelowHealthPercentage(v54, v53) and v121.AncestralProtectionTotem:IsReady()) then
					if ((v55 == "Player") or ((1383 + 1059) < (1304 - (957 + 273)))) then
						if (((1213 + 3322) == (1816 + 2719)) and v24(v122.AncestralProtectionTotemPlayer, not v15:IsInRange(152 - 112))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v55 == "Friendly under Cursor") or ((7929 - 4920) <= (6429 - 4324))) then
						if (((9061 - 7231) < (5449 - (389 + 1391))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v122.AncestralProtectionTotemCursor, not v15:IsInRange(26 + 14)) or ((149 + 1281) >= (8222 - 4610))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((3634 - (783 + 168)) >= (8256 - 5796)) and (v55 == "Confirmation")) then
						if (v24(v121.AncestralProtectionTotem, not v15:IsInRange(40 + 0)) or ((2115 - (309 + 2)) >= (10057 - 6782))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 1215 - (1090 + 122);
			end
			if ((v144 == (1 + 0)) or ((4758 - 3341) > (2484 + 1145))) then
				if (((5913 - (628 + 490)) > (73 + 329)) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
					if (((11916 - 7103) > (16292 - 12727)) and (v17:HealthPercentage() <= v82)) then
						if (((4686 - (431 + 343)) == (7900 - 3988)) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((8160 - 5339) <= (3811 + 1013)) and v125.AreUnitsBelowHealthPercentage(v85, v84) and v121.SpiritLinkTotem:IsReady()) then
					if (((223 + 1515) <= (3890 - (556 + 1139))) and (v86 == "Player")) then
						if (((56 - (6 + 9)) <= (553 + 2465)) and v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(21 + 19))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((2314 - (28 + 141)) <= (1590 + 2514)) and (v86 == "Friendly under Cursor")) then
						if (((3318 - 629) < (3432 + 1413)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(1357 - (486 + 831))) or ((6042 - 3720) > (9230 - 6608))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v86 == "Confirmation") or ((857 + 3677) == (6583 - 4501))) then
						if (v24(v121.SpiritLinkTotem, not v15:IsInRange(1303 - (668 + 595))) or ((1414 + 157) > (377 + 1490))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 5 - 3;
			end
		end
	end
	local function v132()
		if ((v93 and v125.AreUnitsBelowHealthPercentage(385 - (23 + 267), 1947 - (1129 + 815)) and v121.ChainHeal:IsReady() and v13:BuffUp(v121.HighTide)) or ((3041 - (371 + 16)) >= (4746 - (1326 + 424)))) then
			if (((7533 - 3555) > (7688 - 5584)) and v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((3113 - (88 + 30)) > (2312 - (720 + 51))) and v100 and (v17:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (33 - 18))) then
			if (((5025 - (421 + 1355)) > (1572 - 619)) and v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((1608 + 1665) > (5656 - (286 + 797)))) then
			if (((v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) or ((11518 - 8367) < (2126 - 842))) then
				if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((2289 - (397 + 42)) == (478 + 1051))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if (((1621 - (24 + 776)) < (3270 - 1147)) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((1687 - (222 + 563)) < (5122 - 2797)) and (v17:HealthPercentage() <= v82)) then
				if (((618 + 240) <= (3152 - (23 + 167))) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v104 and v121.UnleashLife:IsReady()) or ((5744 - (690 + 1108)) < (465 + 823))) then
			if ((v17:HealthPercentage() <= v89) or ((2675 + 567) == (1415 - (40 + 808)))) then
				if (v24(v121.UnleashLife, not v17:IsSpellInRange(v121.UnleashLife)) or ((140 + 707) >= (4829 - 3566))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71)) or ((2154 + 99) == (980 + 871))) then
			if (v24(v122.HealingRainCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2658 - (47 + 524)) > (1540 + 832))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v72, v71) and v121.HealingRain:IsReady()) or ((12150 - 7705) < (6203 - 2054))) then
			if ((v73 == "Player") or ((4145 - 2327) == (1811 - (1165 + 561)))) then
				if (((19 + 611) < (6587 - 4460)) and v24(v122.HealingRainPlayer, not v15:IsInRange(16 + 24), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif ((v73 == "Friendly under Cursor") or ((2417 - (341 + 138)) == (679 + 1835))) then
				if (((8781 - 4526) >= (381 - (89 + 237))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((9647 - 6648) > (2433 - 1277)) and v24(v122.HealingRainCursor, not v15:IsInRange(921 - (581 + 300)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((3570 - (855 + 365)) > (2743 - 1588)) and (v73 == "Enemy under Cursor")) then
				if (((1316 + 2713) <= (6088 - (1030 + 205))) and v16:Exists() and v13:CanAttack(v16)) then
					if (v24(v122.HealingRainCursor, not v15:IsInRange(38 + 2), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((481 + 35) > (3720 - (156 + 130)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((9193 - 5147) >= (5111 - 2078)) and (v73 == "Confirmation")) then
				if (v24(v121.HealingRain, not v15:IsInRange(81 - 41), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((717 + 2002) <= (844 + 603))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v69, v68) and v121.EarthenWallTotem:IsReady()) or ((4203 - (10 + 59)) < (1111 + 2815))) then
			if ((v70 == "Player") or ((807 - 643) >= (3948 - (671 + 492)))) then
				if (v24(v122.EarthenWallTotemPlayer, not v15:IsInRange(32 + 8)) or ((1740 - (369 + 846)) == (559 + 1550))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((29 + 4) == (1978 - (1036 + 909))) and (v70 == "Friendly under Cursor")) then
				if (((2429 + 625) <= (6740 - 2725)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((2074 - (11 + 192)) < (1710 + 1672)) and v24(v122.EarthenWallTotemCursor, not v15:IsInRange(215 - (135 + 40)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((3132 - 1839) <= (1306 + 860)) and (v70 == "Confirmation")) then
				if (v24(v121.EarthenWallTotem, not v15:IsInRange(88 - 48)) or ((3865 - 1286) < (299 - (50 + 126)))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v64, v63) and v121.Downpour:IsReady()) or ((2355 - 1509) >= (525 + 1843))) then
			if ((v65 == "Player") or ((5425 - (1233 + 180)) <= (4327 - (522 + 447)))) then
				if (((2915 - (107 + 1314)) <= (1395 + 1610)) and v24(v122.DownpourPlayer, not v15:IsInRange(121 - 81), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v65 == "Friendly under Cursor") or ((1322 + 1789) == (4237 - 2103))) then
				if (((9317 - 6962) == (4265 - (716 + 1194))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v122.DownpourCursor, not v15:IsInRange(1 + 39), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((63 + 525) <= (935 - (74 + 429)))) then
						return "downpour healingaoe";
					end
				end
			elseif (((9253 - 4456) >= (1931 + 1964)) and (v65 == "Confirmation")) then
				if (((8187 - 4610) == (2531 + 1046)) and v24(v121.Downpour, not v15:IsInRange(123 - 83), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((9380 - 5586) > (4126 - (279 + 154))) and v94 and v125.AreUnitsBelowHealthPercentage(v62, v61) and v121.CloudburstTotem:IsReady()) then
			if (v24(v121.CloudburstTotem) or ((2053 - (454 + 324)) == (3226 + 874))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v105 and v125.AreUnitsBelowHealthPercentage(v107, v106) and v121.Wellspring:IsReady()) or ((1608 - (12 + 5)) >= (1931 + 1649))) then
			if (((2504 - 1521) <= (669 + 1139)) and v24(v121.Wellspring, not v15:IsInRange(1133 - (277 + 816)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if ((v93 and v125.AreUnitsBelowHealthPercentage(v60, v59) and v121.ChainHeal:IsReady()) or ((9187 - 7037) <= (2380 - (1058 + 125)))) then
			if (((707 + 3062) >= (2148 - (815 + 160))) and v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if (((6371 - 4886) == (3525 - 2040)) and v103 and v13:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87) and v121.SpiritwalkersGrace:IsReady()) then
			if (v24(v121.SpiritwalkersGrace, nil) or ((791 + 2524) <= (8132 - 5350))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74) and v121.HealingStreamTotem:IsReady()) or ((2774 - (41 + 1857)) >= (4857 - (1222 + 671)))) then
			if (v24(v121.HealingStreamTotem, nil) or ((5768 - 3536) > (3589 - 1092))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v133()
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((3292 - (229 + 953)) <= (2106 - (1111 + 663)))) then
			if (((5265 - (874 + 705)) > (445 + 2727)) and (v17:HealthPercentage() <= v82)) then
				if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((3053 + 1421) < (1704 - 884))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((121 + 4158) >= (3561 - (642 + 37))) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) or ((463 + 1566) >= (564 + 2957))) then
				if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((5114 - 3077) >= (5096 - (233 + 221)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((3977 - 2257) < (3924 + 534)) and v121.ElementalOrbit:IsAvailable() and v13:BuffDown(v121.EarthShieldBuff) and not v15:IsAPlayer()) then
			if (v24(v121.EarthShield) or ((1977 - (718 + 823)) > (1902 + 1119))) then
				return "earth_shield player healingst";
			end
		end
		if (((1518 - (266 + 539)) <= (2398 - 1551)) and v121.ElementalOrbit:IsAvailable() and v13:BuffUp(v121.EarthShieldBuff)) then
			if (((3379 - (636 + 589)) <= (9568 - 5537)) and v125.IsSoloMode()) then
				if (((9518 - 4903) == (3658 + 957)) and v121.LightningShield:IsReady() and v13:BuffDown(v121.LightningShield)) then
					if (v24(v121.LightningShield) or ((1377 + 2413) == (1515 - (657 + 358)))) then
						return "lightning_shield healingst";
					end
				end
			elseif (((235 - 146) < (503 - 282)) and v121.WaterShield:IsReady() and v13:BuffDown(v121.WaterShield)) then
				if (((3241 - (1151 + 36)) >= (1373 + 48)) and v24(v121.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if (((182 + 510) < (9132 - 6074)) and v98 and v121.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v76) or ((5086 - (1552 + 280)) == (2489 - (64 + 770)))) then
				if (v24(v122.HealingSurgeFocus, not v17:IsSpellInRange(v121.HealingSurge), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((880 + 416) == (11146 - 6236))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((598 + 2770) == (4611 - (157 + 1086))) and v100 and v121.HealingWave:IsReady()) then
			if (((5290 - 2647) < (16708 - 12893)) and (v17:HealthPercentage() <= v79)) then
				if (((2933 - 1020) > (672 - 179)) and v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v134()
		if (((5574 - (599 + 220)) > (6826 - 3398)) and v121.Stormkeeper:IsReady()) then
			if (((3312 - (1813 + 118)) <= (1732 + 637)) and v24(v121.Stormkeeper, not v15:IsInRange(1257 - (841 + 376)))) then
				return "stormkeeper damage";
			end
		end
		if ((math.max(#v13:GetEnemiesInRange(28 - 8), v13:GetEnemiesInSplashRangeCount(2 + 6)) > (5 - 3)) or ((5702 - (464 + 395)) == (10480 - 6396))) then
			if (((2243 + 2426) > (1200 - (467 + 370))) and v121.ChainLightning:IsReady()) then
				if (v24(v121.ChainLightning, not v15:IsSpellInRange(v121.ChainLightning), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3878 - 2001) >= (2304 + 834))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((16255 - 11513) >= (566 + 3060)) and v121.FlameShock:IsReady()) then
			if (v125.CastCycle(v121.FlameShock, v13:GetEnemiesInRange(93 - 53), v128, not v15:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil) or ((5060 - (150 + 370)) == (2198 - (74 + 1208)))) then
				return "flame_shock_cycle damage";
			end
			if (v24(v121.FlameShock, not v15:IsSpellInRange(v121.FlameShock)) or ((2843 - 1687) > (20606 - 16261))) then
				return "flame_shock damage";
			end
		end
		if (((1592 + 645) < (4639 - (14 + 376))) and v121.LavaBurst:IsReady()) then
			if (v24(v121.LavaBurst, not v15:IsSpellInRange(v121.LavaBurst), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4653 - 1970) < (15 + 8))) then
				return "lava_burst damage";
			end
		end
		if (((613 + 84) <= (788 + 38)) and v121.LightningBolt:IsReady()) then
			if (((3237 - 2132) <= (885 + 291)) and v24(v121.LightningBolt, not v15:IsSpellInRange(v121.LightningBolt), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v135()
		local v145 = 78 - (23 + 55);
		while true do
			if (((8007 - 4628) <= (2544 + 1268)) and (v145 == (4 + 0))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['RiptideHP'];
				v83 = EpicSettings.Settings['RiptideTankHP'];
				v145 = 7 - 2;
			end
			if (((3 + 4) == v145) or ((1689 - (652 + 249)) >= (4324 - 2708))) then
				v99 = EpicSettings.Settings['UseHealingTideTotem'];
				v100 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v102 = EpicSettings.Settings['UseRiptide'];
				v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v145 = 1876 - (708 + 1160);
			end
			if (((5032 - 3178) <= (6160 - 2781)) and (v145 == (30 - (10 + 17)))) then
				v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v75 = EpicSettings.Settings['HealingStreamTotemHP'];
				v76 = EpicSettings.Settings['HealingSurgeHP'];
				v77 = EpicSettings.Settings['HealingTideTotemGroup'];
				v78 = EpicSettings.Settings['HealingTideTotemHP'];
				v79 = EpicSettings.Settings['HealingWaveHP'];
				v145 = 1 + 3;
			end
			if (((6281 - (1400 + 332)) == (8724 - 4175)) and (v145 == (1910 - (242 + 1666)))) then
				v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v71 = EpicSettings.Settings['HealingRainGroup'];
				v72 = EpicSettings.Settings['HealingRainHP'];
				v73 = EpicSettings.Settings['HealingRainUsage'];
				v145 = 2 + 1;
			end
			if ((v145 == (2 + 3)) or ((2576 + 446) >= (3964 - (850 + 90)))) then
				v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v89 = EpicSettings.Settings['UnleashLifeHP'];
				v145 = 9 - 3;
			end
			if (((6210 - (360 + 1030)) > (1946 + 252)) and (v145 == (22 - 14))) then
				v104 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v145 == (0 - 0)) or ((2722 - (909 + 752)) >= (6114 - (109 + 1114)))) then
				v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v59 = EpicSettings.Settings['ChainHealGroup'];
				v60 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v145 = 1 - 0;
			end
			if (((531 + 833) <= (4715 - (6 + 236))) and (v145 == (1 + 0))) then
				v46 = EpicSettings.Settings['DispelBuffs'];
				v63 = EpicSettings.Settings['DownpourGroup'];
				v64 = EpicSettings.Settings['DownpourHP'];
				v65 = EpicSettings.Settings['DownpourUsage'];
				v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v69 = EpicSettings.Settings['EarthenWallTotemHP'];
				v145 = 2 + 0;
			end
			if (((13 - 7) == v145) or ((6279 - 2684) <= (1136 - (1076 + 57)))) then
				v93 = EpicSettings.Settings['UseChainHeal'];
				v94 = EpicSettings.Settings['UseCloudburstTotem'];
				v96 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v97 = EpicSettings.Settings['UseHealingStreamTotem'];
				v98 = EpicSettings.Settings['UseHealingSurge'];
				v145 = 2 + 5;
			end
		end
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
		v35 = EpicSettings.Settings['useRacials'];
		v109 = EpicSettings.Settings['trinketsWithCD'];
		v110 = EpicSettings.Settings['useTrinkets'];
		v111 = EpicSettings.Settings['fightRemainsCheck'];
		v112 = EpicSettings.Settings['handleAfflicted'];
		v113 = EpicSettings.Settings['HandleIncorporeal'];
		v41 = EpicSettings.Settings['HandleChromie'];
		v43 = EpicSettings.Settings['HandleCharredBrambles'];
		v42 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleFyrakkNPC'];
		v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local v137 = 689 - (579 + 110);
	local function v138()
		local v180 = 0 + 0;
		local v181;
		while true do
			if ((v180 == (3 + 0)) or ((2480 + 2192) == (4259 - (174 + 233)))) then
				if (((4354 - 2795) == (2735 - 1176)) and (v125.TargetIsValid() or v13:AffectingCombat())) then
					v120 = v13:GetEnemiesInRange(18 + 22);
					v118 = v10.BossFightRemains(nil, true);
					v119 = v118;
					if ((v119 == (12285 - (663 + 511))) or ((1563 + 189) <= (172 + 616))) then
						v119 = v10.FightRemains(v120, false);
					end
				end
				if (not v13:AffectingCombat() or ((12044 - 8137) == (108 + 69))) then
					if (((8169 - 4699) > (1343 - 788)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v250 = v125.DeadFriendlyUnitsCount();
						if ((v250 > (1 + 0)) or ((1891 - 919) == (460 + 185))) then
							if (((291 + 2891) >= (2837 - (478 + 244))) and v24(v121.AncestralVision, nil, v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (((4410 - (440 + 77)) < (2014 + 2415)) and v24(v122.AncestralSpiritMouseover, not v15:IsInRange(146 - 106), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v181 = v130();
				v180 = 1560 - (655 + 901);
			end
			if ((v180 == (0 + 0)) or ((2195 + 672) < (1287 + 618))) then
				v135();
				v136();
				v30 = EpicSettings.Toggles['ooc'];
				v180 = 3 - 2;
			end
			if ((v180 == (1447 - (695 + 750))) or ((6132 - 4336) >= (6251 - 2200))) then
				v34 = EpicSettings.Toggles['dps'];
				v181 = nil;
				if (((6511 - 4892) <= (4107 - (285 + 66))) and v13:IsDeadOrGhost()) then
					return;
				end
				v180 = 6 - 3;
			end
			if (((1914 - (682 + 628)) == (98 + 506)) and (v180 == (303 - (176 + 123)))) then
				if (v181 or ((1876 + 2608) == (653 + 247))) then
					return v181;
				end
				if (v13:AffectingCombat() or v30 or ((4728 - (239 + 30)) <= (303 + 810))) then
					local v245 = 0 + 0;
					local v246;
					while true do
						if (((6428 - 2796) > (10601 - 7203)) and ((315 - (306 + 9)) == v245)) then
							v246 = v45 and v121.PurifySpirit:IsReady() and v32;
							if (((14244 - 10162) <= (856 + 4061)) and v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 16 + 9) < (1 + 0))) then
								local v251 = 0 - 0;
								while true do
									if (((6207 - (1140 + 235)) >= (883 + 503)) and ((1 + 0) == v251)) then
										if (((36 + 101) == (189 - (33 + 19))) and (v125.UnitGroupRole(v17) == "TANK")) then
											if (v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield)) or ((567 + 1003) >= (12983 - 8651))) then
												return "earth_shield_tank main apl 1";
											end
										end
										break;
									end
									if ((v251 == (0 + 0)) or ((7969 - 3905) <= (1706 + 113))) then
										v29 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 704 - (586 + 103), 4 + 36, "TANK", true, 76 - 51);
										if (v29 or ((6474 - (1309 + 179)) < (2841 - 1267))) then
											return v29;
										end
										v251 = 1 + 0;
									end
								end
							end
							v245 = 2 - 1;
						end
						if (((3344 + 1082) > (365 - 193)) and ((1 - 0) == v245)) then
							if (((1195 - (295 + 314)) > (1117 - 662)) and (not v17:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v17) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 1987 - (1300 + 662)) >= (3 - 2)))) then
								local v252 = 1755 - (1178 + 577);
								while true do
									if (((429 + 397) == (2441 - 1615)) and (v252 == (1405 - (851 + 554)))) then
										v29 = v125.FocusUnit(v246, nil, nil, nil);
										if (v29 or ((3554 + 465) > (12316 - 7875))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((4380 - 2363) < (4563 - (115 + 187))) and v121.EarthShield:IsCastable() and v96 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(31 + 9) and (v125.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v121.EarthShield))) then
					if (((4465 + 251) > (315 - 235)) and v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v180 = 1166 - (160 + 1001);
			end
			if (((5 + 0) == v180) or ((2420 + 1087) == (6697 - 3425))) then
				if ((v13:AffectingCombat() and v125.TargetIsValid()) or ((1234 - (237 + 121)) >= (3972 - (525 + 372)))) then
					local v247 = 0 - 0;
					while true do
						if (((14298 - 9946) > (2696 - (96 + 46))) and (v247 == (778 - (643 + 134)))) then
							if (v29 or ((1591 + 2815) < (9693 - 5650))) then
								return v29;
							end
							v29 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 111 - 81, nil, v16);
							if (v29 or ((1812 + 77) >= (6638 - 3255))) then
								return v29;
							end
							v181 = v129();
							v247 = 3 - 1;
						end
						if (((2611 - (316 + 403)) <= (1818 + 916)) and (v247 == (5 - 3))) then
							if (((695 + 1228) < (5585 - 3367)) and v181) then
								return v181;
							end
							if (((1540 + 633) > (123 + 256)) and v121.GreaterPurge:IsAvailable() and v47 and v121.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
								if (v24(v121.GreaterPurge, not v15:IsSpellInRange(v121.GreaterPurge)) or ((8977 - 6386) == (16280 - 12871))) then
									return "greater_purge utility";
								end
							end
							if (((9376 - 4862) > (191 + 3133)) and v121.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
								if (v24(v121.Purge, not v15:IsSpellInRange(v121.Purge)) or ((408 - 200) >= (236 + 4592))) then
									return "purge utility";
								end
							end
							if ((v119 > v111) or ((4657 - 3074) > (3584 - (12 + 5)))) then
								v181 = v131();
								if (v181 or ((5099 - 3786) == (1693 - 899))) then
									return v181;
								end
							end
							break;
						end
						if (((6746 - 3572) > (7196 - 4294)) and (v247 == (0 + 0))) then
							if (((6093 - (1656 + 317)) <= (3797 + 463)) and v116 and v123.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v117)) then
								if (v24(v122.ManaPotion, nil) or ((708 + 175) > (12704 - 7926))) then
									return "Mana Potion main";
								end
							end
							v29 = v125.Interrupt(v121.WindShear, 147 - 117, true);
							if (v29 or ((3974 - (5 + 349)) >= (23231 - 18340))) then
								return v29;
							end
							v29 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 1301 - (266 + 1005), true, v16);
							v247 = 1 + 0;
						end
					end
				end
				if (((14528 - 10270) > (1233 - 296)) and (v30 or v13:AffectingCombat())) then
					local v248 = 1696 - (561 + 1135);
					while true do
						if ((v248 == (1 - 0)) or ((16004 - 11135) < (1972 - (507 + 559)))) then
							if (((v17:HealthPercentage() < v81) and v17:BuffDown(v121.Riptide)) or ((3073 - 1848) > (13075 - 8847))) then
								if (((3716 - (212 + 176)) > (3143 - (250 + 655))) and v121.PrimordialWaveResto:IsCastable()) then
									if (((10468 - 6629) > (2455 - 1050)) and v24(v122.PrimordialWaveFocus, not v17:IsSpellInRange(v121.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							if (v33 or ((2022 - 729) <= (2463 - (1869 + 87)))) then
								v181 = v132();
								if (v181 or ((10044 - 7148) < (2706 - (484 + 1417)))) then
									return v181;
								end
								v181 = v133();
								if (((4964 - 2648) == (3880 - 1564)) and v181) then
									return v181;
								end
							end
							v248 = 775 - (48 + 725);
						end
						if ((v248 == (2 - 0)) or ((6895 - 4325) == (891 + 642))) then
							if (v34 or ((2359 - 1476) == (409 + 1051))) then
								if (v125.TargetIsValid() or ((1347 + 3272) <= (1852 - (152 + 701)))) then
									v181 = v134();
									if (v181 or ((4721 - (430 + 881)) > (1577 + 2539))) then
										return v181;
									end
								end
							end
							break;
						end
						if ((v248 == (895 - (557 + 338))) or ((267 + 636) >= (8619 - 5560))) then
							if ((v32 and v45) or ((13922 - 9946) < (7589 - 4732))) then
								if (((10624 - 5694) > (3108 - (499 + 302))) and (v121.Bursting:MaxDebuffStack() > (870 - (39 + 827)))) then
									local v254 = 0 - 0;
									while true do
										if (((0 - 0) == v254) or ((16070 - 12024) < (1981 - 690))) then
											v29 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
											if (v29 or ((364 + 3877) == (10375 - 6830))) then
												return v29;
											end
											break;
										end
									end
								end
								if (v17 or ((648 + 3400) > (6696 - 2464))) then
									if ((v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(129 - (103 + 1))) or ((2304 - (475 + 79)) >= (7507 - 4034))) then
										if (((10131 - 6965) == (410 + 2756)) and (v137 == (0 + 0))) then
											v137 = GetTime();
										end
										if (((3266 - (1395 + 108)) < (10836 - 7112)) and v125.Wait(1704 - (7 + 1197), v137)) then
											local v255 = 0 + 0;
											while true do
												if (((20 + 37) <= (3042 - (27 + 292))) and (v255 == (0 - 0))) then
													if (v24(v122.PurifySpiritFocus, not v17:IsSpellInRange(v121.PurifySpirit)) or ((2639 - 569) == (1857 - 1414))) then
														return "purify_spirit dispel focus";
													end
													v137 = 0 - 0;
													break;
												end
											end
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and (v125.UnitHasMagicDebuff(v16) or (v125.UnitHasCurseDebuff(v16) and v121.ImprovedPurifySpirit:IsAvailable()))) or ((5151 - 2446) == (1532 - (43 + 96)))) then
									if (v121.PurifySpirit:IsReady() or ((18767 - 14166) < (137 - 76))) then
										if (v24(v122.PurifySpiritMouseover, not v16:IsSpellInRange(v121.PurifySpirit)) or ((1154 + 236) >= (1340 + 3404))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
							end
							if ((v121.Bursting:AuraActiveCount() > (5 - 2)) or ((768 + 1235) > (7184 - 3350))) then
								local v253 = 0 + 0;
								while true do
									if (((0 + 0) == v253) or ((1907 - (1414 + 337)) > (5853 - (1642 + 298)))) then
										if (((508 - 313) == (560 - 365)) and (v121.Bursting:MaxDebuffStack() > (14 - 9)) and v121.SpiritLinkTotem:IsReady()) then
											if (((1022 + 2083) >= (1398 + 398)) and (v86 == "Player")) then
												if (((5351 - (357 + 615)) >= (1496 + 635)) and v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(98 - 58))) then
													return "spirit_link_totem bursting";
												end
											elseif (((3294 + 550) >= (4377 - 2334)) and (v86 == "Friendly under Cursor")) then
												if ((v16:Exists() and not v13:CanAttack(v16)) or ((2585 + 647) <= (186 + 2545))) then
													if (((3084 + 1821) == (6206 - (384 + 917))) and v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(737 - (128 + 569)))) then
														return "spirit_link_totem bursting";
													end
												end
											elseif ((v86 == "Confirmation") or ((5679 - (1407 + 136)) >= (6298 - (687 + 1200)))) then
												if (v24(v121.SpiritLinkTotem, not v15:IsInRange(1750 - (556 + 1154))) or ((10406 - 7448) == (4112 - (9 + 86)))) then
													return "spirit_link_totem bursting";
												end
											end
										end
										if (((1649 - (275 + 146)) >= (133 + 680)) and v93 and v121.ChainHeal:IsReady()) then
											if (v24(v122.ChainHealFocus, nil) or ((3519 - (29 + 35)) > (17949 - 13899))) then
												return "Chain Heal Spam because of Bursting";
											end
										end
										break;
									end
								end
							end
							v248 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((1072 - 829) == (159 + 84)) and (v180 == (1013 - (53 + 959)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v180 = 410 - (312 + 96);
			end
		end
	end
	local function v139()
		v127();
		v121.Bursting:RegisterAuraTracking();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(457 - 193, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

