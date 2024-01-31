local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((8715 - 5757) < (5129 - (512 + 114))) and not v5) then
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
	local v115 = 28967 - 17856;
	local v116 = 22970 - 11859;
	local v117;
	v9:RegisterForEvent(function()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (0 + 0)) or ((512 + 2223) == (1138 + 171))) then
				v115 = 37476 - 26365;
				v116 = 13105 - (109 + 1885);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v118 = v17.Shaman.Restoration;
	local v119 = v24.Shaman.Restoration;
	local v120 = v19.Shaman.Restoration;
	local v121 = {};
	local v122 = v21.Commons.Everyone;
	local v123 = v21.Commons.Shaman;
	local function v124()
		if (v118.ImprovedPurifySpirit:IsAvailable() or ((5599 - (1269 + 200)) <= (5663 - 2708))) then
			v122.DispellableDebuffs = v20.MergeTable(v122.DispellableMagicDebuffs, v122.DispellableCurseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125(v137)
		return v137:DebuffRefreshable(v118.FlameShockDebuff) and (v116 > (820 - (98 + 717)));
	end
	local function v126()
		if ((v91 and v118.AstralShift:IsReady()) or ((2790 - (802 + 24)) <= (2310 - 970))) then
			if (((3155 - 656) == (370 + 2129)) and (v12:HealthPercentage() <= v57)) then
				if (v23(v118.AstralShift, not v14:IsInRange(31 + 9)) or ((371 + 1884) < (5 + 17))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v94 and v118.EarthElemental:IsReady()) or ((3021 - 1935) >= (4685 - 3280))) then
			if ((v12:HealthPercentage() <= v65) or v122.IsTankBelowHealthPercentage(v66) or ((848 + 1521) == (174 + 252))) then
				if (v23(v118.EarthElemental, not v14:IsInRange(33 + 7)) or ((2237 + 839) > (1487 + 1696))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((2635 - (797 + 636)) > (5136 - 4078)) and v120.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) then
			if (((5330 - (1427 + 192)) > (1163 + 2192)) and v23(v119.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v37 and (v12:HealthPercentage() <= v38)) or ((2103 - 1197) >= (2004 + 225))) then
			local v232 = 0 + 0;
			while true do
				if (((1614 - (192 + 134)) > (2527 - (316 + 960))) and (v232 == (0 + 0))) then
					if ((v39 == "Refreshing Healing Potion") or ((3483 + 1030) < (3099 + 253))) then
						if (v120.RefreshingHealingPotion:IsReady() or ((7894 - 5829) >= (3747 - (83 + 468)))) then
							if (v23(v119.RefreshingHealingPotion) or ((6182 - (1202 + 604)) <= (6913 - 5432))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((5644 - 2252) >= (13126 - 8385))) then
						if (((3650 - (45 + 280)) >= (2080 + 74)) and v120.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v119.RefreshingHealingPotion) or ((1132 + 163) >= (1181 + 2052))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v138 = 0 + 0;
		while true do
			if (((770 + 3607) > (3040 - 1398)) and (v138 == (1912 - (340 + 1571)))) then
				if (((1863 + 2860) > (3128 - (1733 + 39))) and v40) then
					v28 = v122.HandleChromie(v118.Riptide, v119.RiptideMouseover, 109 - 69);
					if (v28 or ((5170 - (125 + 909)) <= (5381 - (1096 + 852)))) then
						return v28;
					end
					v28 = v122.HandleChromie(v118.HealingSurge, v119.HealingSurgeMouseover, 18 + 22);
					if (((6061 - 1816) <= (4492 + 139)) and v28) then
						return v28;
					end
				end
				if (((4788 - (409 + 103)) >= (4150 - (46 + 190))) and v41) then
					v28 = v122.HandleCharredTreant(v118.Riptide, v119.RiptideMouseover, 135 - (51 + 44));
					if (((56 + 142) <= (5682 - (1114 + 203))) and v28) then
						return v28;
					end
					v28 = v122.HandleCharredTreant(v118.ChainHeal, v119.ChainHealMouseover, 766 - (228 + 498));
					if (((1037 + 3745) > (2584 + 2092)) and v28) then
						return v28;
					end
					v28 = v122.HandleCharredTreant(v118.HealingSurge, v119.HealingSurgeMouseover, 703 - (174 + 489));
					if (((12672 - 7808) > (4102 - (830 + 1075))) and v28) then
						return v28;
					end
					v28 = v122.HandleCharredTreant(v118.HealingWave, v119.HealingWaveMouseover, 564 - (303 + 221));
					if (v28 or ((4969 - (231 + 1038)) == (2090 + 417))) then
						return v28;
					end
				end
				v138 = 1164 - (171 + 991);
			end
			if (((18438 - 13964) >= (735 - 461)) and (v138 == (0 - 0))) then
				if (v112 or ((1516 + 378) <= (4928 - 3522))) then
					local v239 = 0 - 0;
					while true do
						if (((2533 - 961) >= (4732 - 3201)) and (v239 == (1248 - (111 + 1137)))) then
							v28 = v122.HandleIncorporeal(v118.Hex, v119.HexMouseOver, 188 - (91 + 67), true);
							if (v28 or ((13949 - 9262) < (1134 + 3408))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((3814 - (423 + 100)) > (12 + 1655)) and v111) then
					local v240 = 0 - 0;
					while true do
						if ((v240 == (0 + 0)) or ((1644 - (326 + 445)) == (8876 - 6842))) then
							v28 = v122.HandleAfflicted(v118.PurifySpirit, v119.PurifySpiritMouseover, 66 - 36);
							if (v28 or ((6572 - 3756) < (722 - (530 + 181)))) then
								return v28;
							end
							v240 = 882 - (614 + 267);
						end
						if (((3731 - (19 + 13)) < (7658 - 2952)) and (v240 == (2 - 1))) then
							if (((7558 - 4912) >= (228 + 648)) and v113) then
								v28 = v122.HandleAfflicted(v118.TremorTotem, v118.TremorTotem, 52 - 22);
								if (((1272 - 658) <= (4996 - (1293 + 519))) and v28) then
									return v28;
								end
							end
							if (((6377 - 3251) == (8161 - 5035)) and v114) then
								local v244 = 0 - 0;
								while true do
									if ((v244 == (0 - 0)) or ((5151 - 2964) >= (2624 + 2330))) then
										v28 = v122.HandleAfflicted(v118.PoisonCleansingTotem, v118.PoisonCleansingTotem, 7 + 23);
										if (v28 or ((9008 - 5131) == (827 + 2748))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((442 + 265) > (1728 - (709 + 387))) and (v138 == (1860 - (673 + 1185)))) then
				if (v42 or ((1583 - 1037) >= (8618 - 5934))) then
					v28 = v122.HandleCharredBrambles(v118.Riptide, v119.RiptideMouseover, 65 - 25);
					if (((1048 + 417) <= (3214 + 1087)) and v28) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.ChainHeal, v119.ChainHealMouseover, 54 - 14);
					if (((419 + 1285) > (2841 - 1416)) and v28) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.HealingSurge, v119.HealingSurgeMouseover, 78 - 38);
					if (v28 or ((2567 - (446 + 1434)) == (5517 - (1040 + 243)))) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.HealingWave, v119.HealingWaveMouseover, 119 - 79);
					if (v28 or ((5177 - (559 + 1288)) < (3360 - (609 + 1322)))) then
						return v28;
					end
				end
				if (((1601 - (13 + 441)) >= (1251 - 916)) and v43) then
					local v241 = 0 - 0;
					while true do
						if (((17107 - 13672) > (79 + 2018)) and (v241 == (3 - 2))) then
							v28 = v122.HandleFyrakkNPC(v118.ChainHeal, v119.ChainHealMouseover, 15 + 25);
							if (v28 or ((1652 + 2118) >= (11991 - 7950))) then
								return v28;
							end
							v241 = 2 + 0;
						end
						if (((4 - 1) == v241) or ((2507 + 1284) <= (897 + 714))) then
							v28 = v122.HandleFyrakkNPC(v118.HealingWave, v119.HealingWaveMouseover, 29 + 11);
							if (v28 or ((3844 + 734) <= (1965 + 43))) then
								return v28;
							end
							break;
						end
						if (((1558 - (153 + 280)) <= (5994 - 3918)) and (v241 == (0 + 0))) then
							v28 = v122.HandleFyrakkNPC(v118.Riptide, v119.RiptideMouseover, 16 + 24);
							if (v28 or ((389 + 354) >= (3993 + 406))) then
								return v28;
							end
							v241 = 1 + 0;
						end
						if (((1758 - 603) < (1035 + 638)) and (v241 == (669 - (89 + 578)))) then
							v28 = v122.HandleFyrakkNPC(v118.HealingSurge, v119.HealingSurgeMouseover, 29 + 11);
							if (v28 or ((4831 - 2507) <= (1627 - (572 + 477)))) then
								return v28;
							end
							v241 = 1 + 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v139 = 0 + 0;
		while true do
			if (((450 + 3317) == (3853 - (84 + 2))) and (v139 == (0 - 0))) then
				if (((2946 + 1143) == (4931 - (497 + 345))) and v109 and ((v30 and v108) or not v108)) then
					local v242 = 0 + 0;
					while true do
						if (((754 + 3704) >= (3007 - (605 + 728))) and (v242 == (0 + 0))) then
							v28 = v122.HandleTopTrinket(v121, v30, 88 - 48, nil);
							if (((45 + 927) <= (5242 - 3824)) and v28) then
								return v28;
							end
							v242 = 1 + 0;
						end
						if ((v242 == (2 - 1)) or ((3729 + 1209) < (5251 - (457 + 32)))) then
							v28 = v122.HandleBottomTrinket(v121, v30, 17 + 23, nil);
							if (v28 or ((3906 - (832 + 570)) > (4018 + 246))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((562 + 1591) == (7618 - 5465)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
					if ((v16:HealthPercentage() <= v81) or ((245 + 262) >= (3387 - (588 + 208)))) then
						if (((12077 - 7596) == (6281 - (884 + 916))) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v139 = 1 - 0;
			end
			if (((2 + 0) == v139) or ((2981 - (232 + 421)) < (2582 - (1569 + 320)))) then
				if (((1062 + 3266) == (823 + 3505)) and v98 and v122.AreUnitsBelowHealthPercentage(v77, v76) and v118.HealingTideTotem:IsReady()) then
					if (((5351 - 3763) >= (1937 - (316 + 289))) and v23(v118.HealingTideTotem, not v14:IsInRange(104 - 64))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v53, v52) and v118.AncestralProtectionTotem:IsReady()) or ((193 + 3981) > (5701 - (666 + 787)))) then
					if ((v54 == "Player") or ((5011 - (360 + 65)) <= (77 + 5))) then
						if (((4117 - (79 + 175)) == (6090 - 2227)) and v23(v119.AncestralProtectionTotemPlayer, not v14:IsInRange(32 + 8))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v54 == "Friendly under Cursor") or ((864 - 582) <= (80 - 38))) then
						if (((5508 - (503 + 396)) >= (947 - (92 + 89))) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v119.AncestralProtectionTotemCursor, not v14:IsInRange(77 - 37)) or ((591 + 561) == (1473 + 1015))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((13400 - 9978) > (459 + 2891)) and (v54 == "Confirmation")) then
						if (((1999 - 1122) > (329 + 47)) and v23(v118.AncestralProtectionTotem, not v14:IsInRange(20 + 20))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v139 = 8 - 5;
			end
			if ((v139 == (1 + 3)) or ((4754 - 1636) <= (3095 - (485 + 759)))) then
				if ((v100 and (v12:ManaPercentage() <= v79) and v118.ManaTideTotem:IsReady()) or ((381 - 216) >= (4681 - (442 + 747)))) then
					if (((5084 - (832 + 303)) < (5802 - (88 + 858))) and v23(v118.ManaTideTotem, not v14:IsInRange(13 + 27))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v34 and ((v107 and v30) or not v107)) or ((3539 + 737) < (125 + 2891))) then
					local v243 = 789 - (766 + 23);
					while true do
						if (((23153 - 18463) > (5641 - 1516)) and (v243 == (2 - 1))) then
							if (v118.Berserking:IsReady() or ((169 - 119) >= (1969 - (1036 + 37)))) then
								if (v23(v118.Berserking, not v14:IsInRange(29 + 11)) or ((3337 - 1623) >= (2327 + 631))) then
									return "Berserking cooldowns";
								end
							end
							if (v118.BloodFury:IsReady() or ((2971 - (641 + 839)) < (1557 - (910 + 3)))) then
								if (((1794 - 1090) < (2671 - (1466 + 218))) and v23(v118.BloodFury, not v14:IsInRange(19 + 21))) then
									return "BloodFury cooldowns";
								end
							end
							v243 = 1150 - (556 + 592);
						end
						if (((1323 + 2395) > (2714 - (329 + 479))) and (v243 == (856 - (174 + 680)))) then
							if (v118.Fireblood:IsReady() or ((3291 - 2333) > (7534 - 3899))) then
								if (((2500 + 1001) <= (5231 - (396 + 343))) and v23(v118.Fireblood, not v14:IsInRange(4 + 36))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if ((v243 == (1477 - (29 + 1448))) or ((4831 - (135 + 1254)) < (9598 - 7050))) then
							if (((13423 - 10548) >= (976 + 488)) and v118.AncestralCall:IsReady()) then
								if (v23(v118.AncestralCall, not v14:IsInRange(1567 - (389 + 1138))) or ((5371 - (102 + 472)) >= (4618 + 275))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v118.BagofTricks:IsReady() or ((306 + 245) > (1929 + 139))) then
								if (((3659 - (320 + 1225)) > (1680 - 736)) and v23(v118.BagofTricks, not v14:IsInRange(25 + 15))) then
									return "BagofTricks cooldowns";
								end
							end
							v243 = 1465 - (157 + 1307);
						end
					end
				end
				break;
			end
			if ((v139 == (1860 - (821 + 1038))) or ((5643 - 3381) >= (339 + 2757))) then
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((4005 - 1750) >= (1316 + 2221))) then
					if (((v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) or ((9510 - 5673) < (2332 - (834 + 192)))) then
						if (((188 + 2762) == (758 + 2192)) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v84, v83) and v118.SpiritLinkTotem:IsReady()) or ((102 + 4621) < (5109 - 1811))) then
					if (((1440 - (300 + 4)) >= (42 + 112)) and (v85 == "Player")) then
						if (v23(v119.SpiritLinkTotemPlayer, not v14:IsInRange(104 - 64)) or ((633 - (112 + 250)) > (1893 + 2855))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((11874 - 7134) >= (1806 + 1346)) and (v85 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((1334 + 1244) >= (2536 + 854))) then
							if (((21 + 20) <= (1234 + 427)) and v23(v119.SpiritLinkTotemCursor, not v14:IsInRange(1454 - (1001 + 413)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((1340 - 739) < (4442 - (244 + 638))) and (v85 == "Confirmation")) then
						if (((928 - (627 + 66)) < (2046 - 1359)) and v23(v118.SpiritLinkTotem, not v14:IsInRange(642 - (512 + 90)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v139 = 1908 - (1665 + 241);
			end
			if (((5266 - (373 + 344)) > (521 + 632)) and (v139 == (1 + 2))) then
				if ((v89 and v122.AreUnitsBelowHealthPercentage(v51, v50) and v118.AncestralGuidance:IsReady()) or ((12328 - 7654) < (7905 - 3233))) then
					if (((4767 - (35 + 1064)) < (3319 + 1242)) and v23(v118.AncestralGuidance, not v14:IsInRange(85 - 45))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v90 and v122.AreUnitsBelowHealthPercentage(v56, v55) and v118.Ascendance:IsReady()) or ((2 + 453) == (4841 - (298 + 938)))) then
					if (v23(v118.Ascendance, not v14:IsInRange(1299 - (233 + 1026))) or ((4329 - (636 + 1030)) == (1694 + 1618))) then
						return "ascendance cooldowns";
					end
				end
				v139 = 4 + 0;
			end
		end
	end
	local function v129()
		local v140 = 0 + 0;
		while true do
			if (((289 + 3988) <= (4696 - (55 + 166))) and (v140 == (0 + 0))) then
				if ((v92 and v122.AreUnitsBelowHealthPercentage(10 + 85, 11 - 8) and v118.ChainHeal:IsReady() and v12:BuffUp(v118.HighTide)) or ((1167 - (36 + 261)) == (2078 - 889))) then
					if (((2921 - (34 + 1334)) <= (1205 + 1928)) and v23(v119.ChainHealFocus, not v16:IsSpellInRange(v118.ChainHeal), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v99 and (v16:HealthPercentage() <= v78) and v118.HealingWave:IsReady() and (v118.PrimordialWaveResto:TimeSinceLastCast() < (12 + 3))) or ((3520 - (1035 + 248)) >= (3532 - (20 + 1)))) then
					if (v23(v119.HealingWaveFocus, not v16:IsSpellInRange(v118.HealingWave), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((690 + 634) > (3339 - (134 + 185)))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((4125 - (549 + 584)) == (2566 - (314 + 371)))) then
					if (((10662 - 7556) > (2494 - (478 + 490))) and (v16:HealthPercentage() <= v81)) then
						if (((1602 + 1421) < (5042 - (786 + 386))) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v140 = 3 - 2;
			end
			if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and (v140 == (3 + 0))) then
				if (((2 + 16) < (8385 - 6273)) and v93 and v122.AreUnitsBelowHealthPercentage(v61, v60) and v118.CloudburstTotem:IsReady()) then
					if (((3722 - 2625) <= (4632 - 3004)) and v23(v118.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((11634 - 7004) == (1648 + 2982)) and v104 and v122.AreUnitsBelowHealthPercentage(v106, v105) and v118.Wellspring:IsReady()) then
					if (((13637 - 10097) > (9247 - 6564)) and v23(v118.Wellspring, not v14:IsInRange(31 + 9), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if (((12259 - 7465) >= (3963 - (364 + 324))) and v92 and v122.AreUnitsBelowHealthPercentage(v59, v58) and v118.ChainHeal:IsReady()) then
					if (((4068 - 2584) == (3560 - 2076)) and v23(v119.ChainHealFocus, not v16:IsSpellInRange(v118.ChainHeal), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v140 = 2 + 2;
			end
			if (((5991 - 4559) < (5693 - 2138)) and (v140 == (5 - 3))) then
				if ((v122.AreUnitsBelowHealthPercentage(v71, v70) and v118.HealingRain:IsReady()) or ((2333 - (1249 + 19)) > (3230 + 348))) then
					if ((v72 == "Player") or ((18664 - 13869) < (2493 - (686 + 400)))) then
						if (((1454 + 399) < (5042 - (73 + 156))) and v23(v119.HealingRainPlayer, not v14:IsInRange(1 + 39), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif ((v72 == "Friendly under Cursor") or ((3632 - (721 + 90)) < (28 + 2403))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((9331 - 6457) < (2651 - (224 + 246)))) then
							if (v23(v119.HealingRainCursor, not v14:IsInRange(64 - 24), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4950 - 2261) <= (63 + 280))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Enemy under Cursor") or ((45 + 1824) == (1476 + 533))) then
						if ((v15:Exists() and v12:CanAttack(v15)) or ((7049 - 3503) < (7727 - 5405))) then
							if (v23(v119.HealingRainCursor, not v14:IsInRange(553 - (203 + 310)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4075 - (1238 + 755)) == (334 + 4439))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((4778 - (709 + 825)) > (1943 - 888)) and (v72 == "Confirmation")) then
						if (v23(v118.HealingRain, not v14:IsInRange(58 - 18), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4177 - (196 + 668)) <= (7019 - 5241))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v68, v67) and v118.EarthenWallTotem:IsReady()) or ((2943 - 1522) >= (2937 - (171 + 662)))) then
					if (((1905 - (4 + 89)) <= (11387 - 8138)) and (v69 == "Player")) then
						if (((591 + 1032) <= (8595 - 6638)) and v23(v119.EarthenWallTotemPlayer, not v14:IsInRange(16 + 24))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((5898 - (35 + 1451)) == (5865 - (28 + 1425))) and (v69 == "Friendly under Cursor")) then
						if (((3743 - (941 + 1052)) >= (808 + 34)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((5886 - (822 + 692)) > (2641 - 791)) and v23(v119.EarthenWallTotemCursor, not v14:IsInRange(19 + 21))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((529 - (45 + 252)) < (813 + 8)) and (v69 == "Confirmation")) then
						if (((179 + 339) < (2194 - 1292)) and v23(v118.EarthenWallTotem, not v14:IsInRange(473 - (114 + 319)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((4298 - 1304) > (1098 - 240)) and v122.AreUnitsBelowHealthPercentage(v63, v62) and v118.Downpour:IsReady()) then
					if ((v64 == "Player") or ((2394 + 1361) <= (1363 - 448))) then
						if (((8267 - 4321) > (5706 - (556 + 1407))) and v23(v119.DownpourPlayer, not v14:IsInRange(1246 - (741 + 465)), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v64 == "Friendly under Cursor") or ((1800 - (170 + 295)) >= (1742 + 1564))) then
						if (((4450 + 394) > (5546 - 3293)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((375 + 77) == (290 + 162)) and v23(v119.DownpourCursor, not v14:IsInRange(23 + 17), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v64 == "Confirmation") or ((5787 - (957 + 273)) < (559 + 1528))) then
						if (((1551 + 2323) == (14761 - 10887)) and v23(v118.Downpour, not v14:IsInRange(105 - 65), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				v140 = 9 - 6;
			end
			if ((v140 == (19 - 15)) or ((3718 - (389 + 1391)) > (3097 + 1838))) then
				if ((v102 and v12:IsMoving() and v122.AreUnitsBelowHealthPercentage(v87, v86) and v118.SpiritwalkersGrace:IsReady()) or ((443 + 3812) < (7792 - 4369))) then
					if (((2405 - (783 + 168)) <= (8360 - 5869)) and v23(v118.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v96 and v122.AreUnitsBelowHealthPercentage(v74, v73) and v118.HealingStreamTotem:IsReady()) or ((4089 + 68) <= (3114 - (309 + 2)))) then
					if (((14903 - 10050) >= (4194 - (1090 + 122))) and v23(v118.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((1341 + 2793) > (11274 - 7917)) and (v140 == (1 + 0))) then
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((4535 - (628 + 490)) < (455 + 2079))) then
					if (((v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) or ((6738 - 4016) <= (749 - 585))) then
						if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((3182 - (431 + 343)) < (4258 - 2149))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v103 and v118.UnleashLife:IsReady()) or ((95 - 62) == (1150 + 305))) then
					if ((v16:HealthPercentage() <= v88) or ((57 + 386) >= (5710 - (556 + 1139)))) then
						if (((3397 - (6 + 9)) > (31 + 135)) and v23(v118.UnleashLife, not v16:IsSpellInRange(v118.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v72 == "Cursor") and v118.HealingRain:IsReady()) or ((144 + 136) == (3228 - (28 + 141)))) then
					if (((729 + 1152) > (1595 - 302)) and v23(v119.HealingRainCursor, not v14:IsInRange(29 + 11), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v140 = 1319 - (486 + 831);
			end
		end
	end
	local function v130()
		if (((6133 - 3776) == (8297 - 5940)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
			if (((24 + 99) == (388 - 265)) and (v16:HealthPercentage() <= v81)) then
				if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((2319 - (668 + 595)) >= (3053 + 339))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((218 + 863) < (2931 - 1856))) then
			if (((v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) or ((1339 - (23 + 267)) >= (6376 - (1129 + 815)))) then
				if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((5155 - (371 + 16)) <= (2596 - (1326 + 424)))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((6359 - 3001) <= (5189 - 3769))) then
			if ((v16:HealthPercentage() <= v81) or (v16:HealthPercentage() <= v81) or ((3857 - (88 + 30)) <= (3776 - (720 + 51)))) then
				if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((3690 - 2031) >= (3910 - (421 + 1355)))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v118.ElementalOrbit:IsAvailable() and v12:BuffDown(v118.EarthShieldBuff)) or ((5378 - 2118) < (1157 + 1198))) then
			if (v23(v118.EarthShield) or ((1752 - (286 + 797)) == (15437 - 11214))) then
				return "earth_shield healingst";
			end
		end
		if ((v118.ElementalOrbit:IsAvailable() and v12:BuffUp(v118.EarthShieldBuff)) or ((2802 - 1110) < (1027 - (397 + 42)))) then
			if (v122.IsSoloMode() or ((1499 + 3298) < (4451 - (24 + 776)))) then
				if ((v118.LightningShield:IsReady() and v12:BuffDown(v118.LightningShield)) or ((6434 - 2257) > (5635 - (222 + 563)))) then
					if (v23(v118.LightningShield) or ((881 - 481) > (800 + 311))) then
						return "lightning_shield healingst";
					end
				end
			elseif (((3241 - (23 + 167)) > (2803 - (690 + 1108))) and v118.WaterShield:IsReady() and v12:BuffDown(v118.WaterShield)) then
				if (((1333 + 2360) <= (3615 + 767)) and v23(v118.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v97 and v118.HealingSurge:IsReady()) or ((4130 - (40 + 808)) > (676 + 3424))) then
			if ((v16:HealthPercentage() <= v75) or ((13689 - 10109) < (2719 + 125))) then
				if (((48 + 41) < (2463 + 2027)) and v23(v119.HealingSurgeFocus, not v16:IsSpellInRange(v118.HealingSurge), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v99 and v118.HealingWave:IsReady()) or ((5554 - (47 + 524)) < (1174 + 634))) then
			if (((10466 - 6637) > (5635 - 1866)) and (v16:HealthPercentage() <= v78)) then
				if (((3386 - 1901) <= (4630 - (1165 + 561))) and v23(v119.HealingWaveFocus, not v16:IsSpellInRange(v118.HealingWave), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v131()
		if (((127 + 4142) == (13221 - 8952)) and v118.Stormkeeper:IsReady()) then
			if (((148 + 239) <= (3261 - (341 + 138))) and v23(v118.Stormkeeper, not v14:IsInRange(11 + 29))) then
				return "stormkeeper damage";
			end
		end
		if ((#v12:GetEnemiesInRange(82 - 42) > (327 - (89 + 237))) or ((6108 - 4209) <= (1930 - 1013))) then
			if (v118.ChainLightning:IsReady() or ((5193 - (581 + 300)) <= (2096 - (855 + 365)))) then
				if (((5301 - 3069) <= (848 + 1748)) and v23(v118.ChainLightning, not v14:IsSpellInRange(v118.ChainLightning), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((3330 - (1030 + 205)) < (3461 + 225)) and v118.FlameShock:IsReady()) then
			if (v122.CastCycle(v118.FlameShock, v12:GetEnemiesInRange(38 + 2), v125, not v14:IsSpellInRange(v118.FlameShock), nil, nil, nil, nil) or ((1881 - (156 + 130)) >= (10165 - 5691))) then
				return "flame_shock_cycle damage";
			end
			if (v23(v118.FlameShock, not v14:IsSpellInRange(v118.FlameShock)) or ((7784 - 3165) < (5902 - 3020))) then
				return "flame_shock damage";
			end
		end
		if (v118.LavaBurst:IsReady() or ((78 + 216) >= (2818 + 2013))) then
			if (((2098 - (10 + 59)) <= (873 + 2211)) and v23(v118.LavaBurst, not v14:IsSpellInRange(v118.LavaBurst), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
				return "lava_burst damage";
			end
		end
		if (v118.LightningBolt:IsReady() or ((10031 - 7994) == (3583 - (671 + 492)))) then
			if (((3549 + 909) > (5119 - (369 + 846))) and v23(v118.LightningBolt, not v14:IsSpellInRange(v118.LightningBolt), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v132()
		v52 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v53 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v54 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v58 = EpicSettings.Settings['ChainHealGroup'];
		v59 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v62 = EpicSettings.Settings['DownpourGroup'];
		v63 = EpicSettings.Settings['DownpourHP'];
		v64 = EpicSettings.Settings['DownpourUsage'];
		v67 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v68 = EpicSettings.Settings['EarthenWallTotemHP'];
		v69 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v38 = EpicSettings.Settings['healingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v70 = EpicSettings.Settings['HealingRainGroup'];
		v71 = EpicSettings.Settings['HealingRainHP'];
		v72 = EpicSettings.Settings['HealingRainUsage'];
		v73 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v74 = EpicSettings.Settings['HealingStreamTotemHP'];
		v75 = EpicSettings.Settings['HealingSurgeHP'];
		v76 = EpicSettings.Settings['HealingTideTotemGroup'];
		v77 = EpicSettings.Settings['HealingTideTotemHP'];
		v78 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v49 = EpicSettings.Settings['InterruptThreshold'];
		v47 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['RiptideHP'];
		v82 = EpicSettings.Settings['RiptideTankHP'];
		v83 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v84 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v85 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v86 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v87 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v88 = EpicSettings.Settings['UnleashLifeHP'];
		v92 = EpicSettings.Settings['UseChainHeal'];
		v93 = EpicSettings.Settings['UseCloudburstTotem'];
		v95 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['UseHealingStreamTotem'];
		v97 = EpicSettings.Settings['UseHealingSurge'];
		v98 = EpicSettings.Settings['UseHealingTideTotem'];
		v99 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v46 = EpicSettings.Settings['UsePurgeTarget'];
		v101 = EpicSettings.Settings['UseRiptide'];
		v102 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v103 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v133()
		v50 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v51 = EpicSettings.Settings['AncestralGuidanceHP'];
		v55 = EpicSettings.Settings['AscendanceGroup'];
		v56 = EpicSettings.Settings['AscendanceHP'];
		v57 = EpicSettings.Settings['AstralShiftHP'];
		v60 = EpicSettings.Settings['CloudburstTotemGroup'];
		v61 = EpicSettings.Settings['CloudburstTotemHP'];
		v65 = EpicSettings.Settings['EarthElementalHP'];
		v66 = EpicSettings.Settings['EarthElementalTankHP'];
		v79 = EpicSettings.Settings['ManaTideTotemMana'];
		v80 = EpicSettings.Settings['PrimordialWaveHP'];
		v89 = EpicSettings.Settings['UseAncestralGuidance'];
		v90 = EpicSettings.Settings['UseAscendance'];
		v91 = EpicSettings.Settings['UseAstralShift'];
		v94 = EpicSettings.Settings['UseEarthElemental'];
		v100 = EpicSettings.Settings['UseManaTideTotem'];
		v104 = EpicSettings.Settings['UseWellspring'];
		v105 = EpicSettings.Settings['WellspringGroup'];
		v106 = EpicSettings.Settings['WellspringHP'];
		v107 = EpicSettings.Settings['racialsWithCD'];
		v34 = EpicSettings.Settings['useRacials'];
		v108 = EpicSettings.Settings['trinketsWithCD'];
		v109 = EpicSettings.Settings['useTrinkets'];
		v110 = EpicSettings.Settings['fightRemainsCheck'];
		v111 = EpicSettings.Settings['handleAfflicted'];
		v112 = EpicSettings.Settings['HandleIncorporeal'];
		v40 = EpicSettings.Settings['HandleChromie'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v43 = EpicSettings.Settings['HandleFyrakkNPC'];
		v113 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v114 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v134()
		v132();
		v133();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['dispel'];
		v32 = EpicSettings.Toggles['healing'];
		v33 = EpicSettings.Toggles['dps'];
		local v227;
		if (((116 + 320) >= (105 + 18)) and v12:IsDeadOrGhost()) then
			return;
		end
		if (((2445 - (1036 + 909)) < (1444 + 372)) and (v122.TargetIsValid() or v12:AffectingCombat())) then
			v117 = v12:GetEnemiesInRange(67 - 27);
			v115 = v9.BossFightRemains(nil, true);
			v116 = v115;
			if (((3777 - (11 + 192)) == (1807 + 1767)) and (v116 == (11286 - (135 + 40)))) then
				v116 = v9.FightRemains(v117, false);
			end
		end
		v227 = v127();
		if (((535 - 314) < (236 + 154)) and v227) then
			return v227;
		end
		if (v12:AffectingCombat() or v29 or ((4874 - 2661) <= (2129 - 708))) then
			local v233 = v44 and v118.PurifySpirit:IsReady() and v31;
			if (((3234 - (50 + 126)) < (13532 - 8672)) and v118.EarthShield:IsReady() and v95 and (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 6 + 19) < (1414 - (1233 + 180)))) then
				v28 = v122.FocusUnitRefreshableBuff(v118.EarthShield, 984 - (522 + 447), 1461 - (107 + 1314), "TANK", true, 12 + 13);
				if (v28 or ((3948 - 2652) >= (1889 + 2557))) then
					return v28;
				end
				if ((v122.UnitGroupRole(v16) == "TANK") or ((2766 - 1373) > (17761 - 13272))) then
					if (v23(v119.EarthShieldFocus, not v16:IsSpellInRange(v118.EarthShield)) or ((6334 - (716 + 1194)) < (1 + 26))) then
						return "earth_shield_tank main apl";
					end
				end
			end
			if (not v16:BuffDown(v118.EarthShield) or (v122.UnitGroupRole(v16) ~= "TANK") or not v95 or (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 3 + 22) >= (504 - (74 + 429))) or ((3852 - 1855) > (1891 + 1924))) then
				local v234 = 0 - 0;
				while true do
					if (((2452 + 1013) > (5897 - 3984)) and (v234 == (0 - 0))) then
						v28 = v122.FocusUnit(v233, nil, nil, nil);
						if (((1166 - (279 + 154)) < (2597 - (454 + 324))) and v28) then
							return v28;
						end
						break;
					end
				end
			end
		end
		if ((v118.EarthShield:IsCastable() and v95 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(32 + 8) and (v122.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v118.EarthShield))) or ((4412 - (12 + 5)) == (2564 + 2191))) then
			if (v23(v119.EarthShieldFocus, not v16:IsSpellInRange(v118.EarthShield)) or ((9664 - 5871) < (876 + 1493))) then
				return "earth_shield_tank main apl";
			end
		end
		if (not v12:AffectingCombat() or ((5177 - (277 + 816)) == (1132 - 867))) then
			if (((5541 - (1058 + 125)) == (818 + 3540)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v235 = 975 - (815 + 160);
				local v236;
				while true do
					if ((v235 == (0 - 0)) or ((7449 - 4311) < (237 + 756))) then
						v236 = v122.DeadFriendlyUnitsCount();
						if (((9734 - 6404) > (4221 - (41 + 1857))) and (v236 > (1894 - (1222 + 671)))) then
							if (v23(v118.AncestralVision, nil, v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((9371 - 5745) == (5733 - 1744))) then
								return "ancestral_vision";
							end
						elseif (v23(v119.AncestralSpiritMouseover, not v14:IsInRange(1222 - (229 + 953)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2690 - (1111 + 663)) == (4250 - (874 + 705)))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		if (((39 + 233) == (186 + 86)) and v12:AffectingCombat() and v122.TargetIsValid()) then
			v28 = v122.Interrupt(v118.WindShear, 62 - 32, true);
			if (((120 + 4129) <= (5518 - (642 + 37))) and v28) then
				return v28;
			end
			v28 = v122.InterruptCursor(v118.WindShear, v119.WindShearMouseover, 7 + 23, true, v15);
			if (((445 + 2332) < (8034 - 4834)) and v28) then
				return v28;
			end
			v28 = v122.InterruptWithStunCursor(v118.CapacitorTotem, v119.CapacitorTotemCursor, 484 - (233 + 221), nil, v15);
			if (((219 - 124) < (1723 + 234)) and v28) then
				return v28;
			end
			v227 = v126();
			if (((2367 - (718 + 823)) < (1081 + 636)) and v227) then
				return v227;
			end
			if (((2231 - (266 + 539)) >= (3128 - 2023)) and v118.GreaterPurge:IsAvailable() and v46 and v118.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v122.UnitHasMagicBuff(v14)) then
				if (((3979 - (636 + 589)) <= (8020 - 4641)) and v23(v118.GreaterPurge, not v14:IsSpellInRange(v118.GreaterPurge))) then
					return "greater_purge utility";
				end
			end
			if ((v118.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v122.UnitHasMagicBuff(v14)) or ((8099 - 4172) == (1120 + 293))) then
				if (v23(v118.Purge, not v14:IsSpellInRange(v118.Purge)) or ((420 + 734) <= (1803 - (657 + 358)))) then
					return "purge utility";
				end
			end
			if ((v116 > v110) or ((4350 - 2707) > (7698 - 4319))) then
				local v237 = 1187 - (1151 + 36);
				while true do
					if ((v237 == (0 + 0)) or ((737 + 2066) > (13585 - 9036))) then
						v227 = v128();
						if (v227 or ((2052 - (1552 + 280)) >= (3856 - (64 + 770)))) then
							return v227;
						end
						break;
					end
				end
			end
		end
		if (((1916 + 906) == (6405 - 3583)) and (v29 or v12:AffectingCombat())) then
			if ((v31 and v44) or ((189 + 872) == (3100 - (157 + 1086)))) then
				local v238 = 0 - 0;
				while true do
					if (((12088 - 9328) > (2092 - 728)) and ((0 - 0) == v238)) then
						if (v16 or ((5721 - (599 + 220)) <= (7158 - 3563))) then
							if ((v118.PurifySpirit:IsReady() and v122.DispellableFriendlyUnit(1956 - (1813 + 118))) or ((2816 + 1036) == (1510 - (841 + 376)))) then
								v122.Wait(1 - 0);
								if (v23(v119.PurifySpiritFocus, not v16:IsSpellInRange(v118.PurifySpirit)) or ((363 + 1196) == (12522 - 7934))) then
									return "purify_spirit dispel focus";
								end
							end
						end
						if ((v15 and v15:Exists() and v15:IsAPlayer() and (v122.UnitHasMagicDebuff(v15) or (v122.UnitHasCurseDebuff(v15) and v118.ImprovedPurifySpirit:IsAvailable()))) or ((5343 - (464 + 395)) == (2022 - 1234))) then
							if (((2194 + 2374) >= (4744 - (467 + 370))) and v118.PurifySpirit:IsReady()) then
								if (((2574 - 1328) < (2548 + 922)) and v23(v119.PurifySpiritMouseover, not v15:IsSpellInRange(v118.PurifySpirit))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
			if (((13945 - 9877) >= (152 + 820)) and (v16:HealthPercentage() < v80) and v16:BuffDown(v118.Riptide)) then
				if (((1146 - 653) < (4413 - (150 + 370))) and v118.PrimordialWaveResto:IsCastable()) then
					if (v23(v119.PrimordialWaveFocus, not v16:IsSpellInRange(v118.PrimordialWaveResto)) or ((2755 - (74 + 1208)) >= (8194 - 4862))) then
						return "primordial_wave main";
					end
				end
			end
			if (v32 or ((19212 - 15161) <= (824 + 333))) then
				v227 = v129();
				if (((994 - (14 + 376)) < (4996 - 2115)) and v227) then
					return v227;
				end
				v227 = v130();
				if (v227 or ((583 + 317) == (2967 + 410))) then
					return v227;
				end
			end
			if (((4253 + 206) > (1731 - 1140)) and v33) then
				if (((2557 + 841) >= (2473 - (23 + 55))) and v122.TargetIsValid()) then
					v227 = v131();
					if (v227 or ((5173 - 2990) >= (1885 + 939))) then
						return v227;
					end
				end
			end
		end
	end
	local function v135()
		local v228 = 0 + 0;
		while true do
			if (((3001 - 1065) == (609 + 1327)) and (v228 == (901 - (652 + 249)))) then
				v124();
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(706 - 442, v134, v135);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

