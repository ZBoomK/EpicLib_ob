local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3450 - 1296) >= (5272 - (1561 + 386)))) then
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
	local v118 = 3794 + 7317;
	local v119 = 29103 - 17992;
	local v120;
	v9:RegisterForEvent(function()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (0 + 0)) or ((4703 - 3408) >= (1149 + 2084))) then
				v118 = 4869 + 6242;
				v119 = 32972 - 21861;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v17.Shaman.Restoration;
	local v122 = v24.Shaman.Restoration;
	local v123 = v19.Shaman.Restoration;
	local v124 = {};
	local v125 = v21.Commons.Everyone;
	local v126 = v21.Commons.Shaman;
	local function v127()
		if (((2396 + 1981) > (3019 - 1377)) and v121.ImprovedPurifySpirit:IsAvailable()) then
			v125.DispellableDebuffs = v20.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (4 + 1));
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if (((3394 + 1329) > (1139 + 217)) and (v142 == (1 + 0))) then
				if ((v123.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((4569 - (153 + 280)) <= (9913 - 6480))) then
					if (((3812 + 433) <= (1829 + 2802)) and v23(v122.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((2238 + 2038) >= (3552 + 362)) and v37 and (v12:HealthPercentage() <= v38)) then
					if (((144 + 54) <= (6646 - 2281)) and (v39 == "Refreshing Healing Potion")) then
						if (((2956 + 1826) > (5343 - (89 + 578))) and v123.RefreshingHealingPotion:IsReady()) then
							if (((3475 + 1389) > (4567 - 2370)) and v23(v122.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((4749 - (572 + 477)) == (339 + 2168))) then
						if (((2685 + 1789) >= (33 + 241)) and v123.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v122.RefreshingHealingPotion) or ((1980 - (84 + 2)) <= (2316 - 910))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1133 + 439) >= (2373 - (497 + 345))) and (v142 == (0 + 0))) then
				if ((v92 and v121.AstralShift:IsReady()) or ((793 + 3894) < (5875 - (605 + 728)))) then
					if (((2349 + 942) > (3705 - 2038)) and (v12:HealthPercentage() <= v58)) then
						if (v23(v121.AstralShift, not v14:IsInRange(2 + 38)) or ((3227 - 2354) == (1834 + 200))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v95 and v121.EarthElemental:IsReady()) or ((7801 - 4985) < (9 + 2))) then
					if (((4188 - (457 + 32)) < (1997 + 2709)) and ((v12:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67))) then
						if (((4048 - (832 + 570)) >= (826 + 50)) and v23(v121.EarthElemental, not v14:IsInRange(11 + 29))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 3 - 2;
			end
		end
	end
	local function v130()
		local v143 = 0 + 0;
		while true do
			if (((1410 - (588 + 208)) <= (8581 - 5397)) and (v143 == (1801 - (884 + 916)))) then
				if (((6544 - 3418) == (1813 + 1313)) and v40) then
					local v246 = 653 - (232 + 421);
					while true do
						if ((v246 == (1889 - (1569 + 320))) or ((537 + 1650) >= (942 + 4012))) then
							v28 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 134 - 94);
							if (v28 or ((4482 - (316 + 289)) == (9358 - 5783))) then
								return v28;
							end
							v246 = 1 + 0;
						end
						if (((2160 - (666 + 787)) > (1057 - (360 + 65))) and ((1 + 0) == v246)) then
							v28 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 294 - (79 + 175));
							if (v28 or ((860 - 314) >= (2095 + 589))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((4490 - 3025) <= (8282 - 3981)) and v41) then
					v28 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 939 - (503 + 396));
					if (((1885 - (92 + 89)) > (2764 - 1339)) and v28) then
						return v28;
					end
					v28 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 21 + 19);
					if (v28 or ((407 + 280) == (16580 - 12346))) then
						return v28;
					end
					v28 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 6 + 34);
					if (v28 or ((7592 - 4262) < (1247 + 182))) then
						return v28;
					end
					v28 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 20 + 20);
					if (((3493 - 2346) >= (42 + 293)) and v28) then
						return v28;
					end
				end
				v143 = 2 - 0;
			end
			if (((4679 - (485 + 759)) > (4852 - 2755)) and (v143 == (1191 - (442 + 747)))) then
				if (v42 or ((4905 - (832 + 303)) >= (4987 - (88 + 858)))) then
					local v247 = 0 + 0;
					while true do
						if ((v247 == (2 + 0)) or ((157 + 3634) <= (2400 - (766 + 23)))) then
							v28 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 197 - 157);
							if (v28 or ((6260 - 1682) <= (5290 - 3282))) then
								return v28;
							end
							v247 = 10 - 7;
						end
						if (((2198 - (1036 + 37)) <= (1472 + 604)) and (v247 == (0 - 0))) then
							v28 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 32 + 8);
							if (v28 or ((2223 - (641 + 839)) >= (5312 - (910 + 3)))) then
								return v28;
							end
							v247 = 2 - 1;
						end
						if (((2839 - (1466 + 218)) < (769 + 904)) and ((1151 - (556 + 592)) == v247)) then
							v28 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 15 + 25);
							if (v28 or ((3132 - (329 + 479)) <= (1432 - (174 + 680)))) then
								return v28;
							end
							break;
						end
						if (((12943 - 9176) == (7807 - 4040)) and (v247 == (1 + 0))) then
							v28 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 779 - (396 + 343));
							if (((362 + 3727) == (5566 - (29 + 1448))) and v28) then
								return v28;
							end
							v247 = 1391 - (135 + 1254);
						end
					end
				end
				if (((16794 - 12336) >= (7816 - 6142)) and v43) then
					local v248 = 0 + 0;
					while true do
						if (((2499 - (389 + 1138)) <= (1992 - (102 + 472))) and (v248 == (1 + 0))) then
							v28 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 23 + 17);
							if (v28 or ((4605 + 333) < (6307 - (320 + 1225)))) then
								return v28;
							end
							v248 = 2 - 0;
						end
						if ((v248 == (0 + 0)) or ((3968 - (157 + 1307)) > (6123 - (821 + 1038)))) then
							v28 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 99 - 59);
							if (((236 + 1917) == (3823 - 1670)) and v28) then
								return v28;
							end
							v248 = 1 + 0;
						end
						if ((v248 == (7 - 4)) or ((1533 - (834 + 192)) >= (165 + 2426))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 11 + 29);
							if (((97 + 4384) == (6941 - 2460)) and v28) then
								return v28;
							end
							break;
						end
						if ((v248 == (306 - (300 + 4))) or ((622 + 1706) < (1814 - 1121))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 402 - (112 + 250));
							if (((1726 + 2602) == (10842 - 6514)) and v28) then
								return v28;
							end
							v248 = 2 + 1;
						end
					end
				end
				break;
			end
			if (((822 + 766) >= (997 + 335)) and (v143 == (0 + 0))) then
				if (v113 or ((3101 + 1073) > (5662 - (1001 + 413)))) then
					v28 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 66 - 36, true);
					if (v28 or ((5468 - (244 + 638)) <= (775 - (627 + 66)))) then
						return v28;
					end
				end
				if (((11510 - 7647) == (4465 - (512 + 90))) and v112) then
					local v249 = 1906 - (1665 + 241);
					while true do
						if ((v249 == (717 - (373 + 344))) or ((128 + 154) <= (12 + 30))) then
							v28 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 79 - 49);
							if (((7799 - 3190) >= (1865 - (35 + 1064))) and v28) then
								return v28;
							end
							v249 = 1 + 0;
						end
						if ((v249 == (2 - 1)) or ((5 + 1147) == (3724 - (298 + 938)))) then
							if (((4681 - (233 + 1026)) > (5016 - (636 + 1030))) and v114) then
								local v257 = 0 + 0;
								while true do
									if (((857 + 20) > (112 + 264)) and (v257 == (0 + 0))) then
										v28 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 251 - (55 + 166));
										if (v28 or ((605 + 2513) <= (187 + 1664))) then
											return v28;
										end
										break;
									end
								end
							end
							if (v115 or ((629 - 464) >= (3789 - (36 + 261)))) then
								local v258 = 0 - 0;
								while true do
									if (((5317 - (34 + 1334)) < (1867 + 2989)) and (v258 == (0 + 0))) then
										v28 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 1313 - (1035 + 248));
										if (v28 or ((4297 - (20 + 1)) < (1572 + 1444))) then
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
				v143 = 320 - (134 + 185);
			end
		end
	end
	local function v131()
		local v144 = 1133 - (549 + 584);
		while true do
			if (((5375 - (314 + 371)) > (14160 - 10035)) and (v144 == (969 - (478 + 490)))) then
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((27 + 23) >= (2068 - (786 + 386)))) then
					if ((v16:HealthPercentage() <= v82) or ((5551 - 3837) >= (4337 - (1055 + 324)))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((2831 - (1093 + 247)) < (573 + 71))) then
							return "riptide healingcd";
						end
					end
				end
				if (((75 + 629) < (3918 - 2931)) and v125.AreUnitsBelowHealthPercentage(v85, v84) and v121.SpiritLinkTotem:IsReady()) then
					if (((12617 - 8899) > (5423 - 3517)) and (v86 == "Player")) then
						if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(100 - 60)) or ((341 + 617) > (14003 - 10368))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((12067 - 8566) <= (3388 + 1104)) and (v86 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((8802 - 5360) < (3236 - (364 + 324)))) then
							if (((7881 - 5006) >= (3512 - 2048)) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(14 + 26))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v86 == "Confirmation") or ((20072 - 15275) >= (7836 - 2943))) then
						if (v23(v121.SpiritLinkTotem, not v14:IsInRange(121 - 81)) or ((1819 - (1249 + 19)) > (1867 + 201))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 7 - 5;
			end
			if (((3200 - (686 + 400)) > (741 + 203)) and (v144 == (229 - (73 + 156)))) then
				if ((v110 and ((v30 and v109) or not v109)) or ((11 + 2251) >= (3907 - (721 + 90)))) then
					v28 = v125.HandleTopTrinket(v124, v30, 1 + 39, nil);
					if (v28 or ((7321 - 5066) >= (4007 - (224 + 246)))) then
						return v28;
					end
					v28 = v125.HandleBottomTrinket(v124, v30, 64 - 24, nil);
					if (v28 or ((7064 - 3227) < (237 + 1069))) then
						return v28;
					end
				end
				if (((71 + 2879) == (2167 + 783)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((9389 - 4666) < (10974 - 7676))) then
						if (((1649 - (203 + 310)) >= (2147 - (1238 + 755))) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 1 + 0;
			end
			if ((v144 == (1537 - (709 + 825))) or ((499 - 228) > (6916 - 2168))) then
				if (((5604 - (196 + 668)) >= (12444 - 9292)) and v90 and v125.AreUnitsBelowHealthPercentage(v52, v51) and v121.AncestralGuidance:IsReady()) then
					if (v23(v121.AncestralGuidance, not v14:IsInRange(82 - 42)) or ((3411 - (171 + 662)) >= (3483 - (4 + 89)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((143 - 102) <= (605 + 1056)) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56) and v121.Ascendance:IsReady()) then
					if (((2639 - 2038) < (1397 + 2163)) and v23(v121.Ascendance, not v14:IsInRange(1526 - (35 + 1451)))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 1457 - (28 + 1425);
			end
			if (((2228 - (941 + 1052)) < (659 + 28)) and (v144 == (1516 - (822 + 692)))) then
				if (((6493 - 1944) > (544 + 609)) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77) and v121.HealingTideTotem:IsReady()) then
					if (v23(v121.HealingTideTotem, not v14:IsInRange(337 - (45 + 252))) or ((4625 + 49) < (1608 + 3064))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((8926 - 5258) < (4994 - (114 + 319))) and v125.AreUnitsBelowHealthPercentage(v54, v53) and v121.AncestralProtectionTotem:IsReady()) then
					if ((v55 == "Player") or ((652 - 197) == (4619 - 1014))) then
						if (v23(v122.AncestralProtectionTotemPlayer, not v14:IsInRange(26 + 14)) or ((3967 - 1304) == (6939 - 3627))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((6240 - (556 + 1407)) <= (5681 - (741 + 465))) and (v55 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((1335 - (170 + 295)) == (627 + 562))) then
							if (((1427 + 126) <= (7713 - 4580)) and v23(v122.AncestralProtectionTotemCursor, not v14:IsInRange(34 + 6))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v55 == "Confirmation") or ((1435 + 802) >= (1989 + 1522))) then
						if (v23(v121.AncestralProtectionTotem, not v14:IsInRange(1270 - (957 + 273))) or ((355 + 969) > (1209 + 1811))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 11 - 8;
			end
			if ((v144 == (10 - 6)) or ((9138 - 6146) == (9314 - 7433))) then
				if (((4886 - (389 + 1391)) > (958 + 568)) and v101 and (v12:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) then
					if (((315 + 2708) < (8810 - 4940)) and v23(v121.ManaTideTotem, not v14:IsInRange(991 - (783 + 168)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((479 - 336) > (73 + 1)) and v34 and ((v108 and v30) or not v108)) then
					local v250 = 311 - (309 + 2);
					while true do
						if (((55 - 37) < (3324 - (1090 + 122))) and (v250 == (0 + 0))) then
							if (((3684 - 2587) <= (1115 + 513)) and v121.AncestralCall:IsReady()) then
								if (((5748 - (628 + 490)) == (831 + 3799)) and v23(v121.AncestralCall, not v14:IsInRange(99 - 59))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((16177 - 12637) > (3457 - (431 + 343))) and v121.BagofTricks:IsReady()) then
								if (((9681 - 4887) >= (9474 - 6199)) and v23(v121.BagofTricks, not v14:IsInRange(32 + 8))) then
									return "BagofTricks cooldowns";
								end
							end
							v250 = 1 + 0;
						end
						if (((3179 - (556 + 1139)) == (1499 - (6 + 9))) and (v250 == (1 + 0))) then
							if (((734 + 698) < (3724 - (28 + 141))) and v121.Berserking:IsReady()) then
								if (v23(v121.Berserking, not v14:IsInRange(16 + 24)) or ((1314 - 249) > (2535 + 1043))) then
									return "Berserking cooldowns";
								end
							end
							if (v121.BloodFury:IsReady() or ((6112 - (486 + 831)) < (3661 - 2254))) then
								if (((6523 - 4670) < (910 + 3903)) and v23(v121.BloodFury, not v14:IsInRange(126 - 86))) then
									return "BloodFury cooldowns";
								end
							end
							v250 = 1265 - (668 + 595);
						end
						if ((v250 == (2 + 0)) or ((569 + 2252) < (6629 - 4198))) then
							if (v121.Fireblood:IsReady() or ((3164 - (23 + 267)) < (4125 - (1129 + 815)))) then
								if (v23(v121.Fireblood, not v14:IsInRange(427 - (371 + 16))) or ((4439 - (1326 + 424)) <= (649 - 306))) then
									return "Fireblood cooldowns";
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
	local function v132()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (119 - (88 + 30))) or ((2640 - (720 + 51)) == (4468 - 2459))) then
				if ((v104 and v121.UnleashLife:IsReady()) or ((5322 - (421 + 1355)) < (3829 - 1507))) then
					if ((v12:HealthPercentage() <= v89) or ((1023 + 1059) == (5856 - (286 + 797)))) then
						if (((11858 - 8614) > (1747 - 692)) and v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71)) or ((3752 - (397 + 42)) <= (556 + 1222))) then
					if (v23(v122.HealingRainCursor, not v14:IsInRange(840 - (24 + 776)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2188 - 767) >= (2889 - (222 + 563)))) then
						return "healing_rain healingaoe";
					end
				end
				if (((3991 - 2179) <= (2340 + 909)) and v125.AreUnitsBelowHealthPercentage(v72, v71) and v121.HealingRain:IsReady()) then
					if (((1813 - (23 + 167)) <= (3755 - (690 + 1108))) and (v73 == "Player")) then
						if (((1592 + 2820) == (3640 + 772)) and v23(v122.HealingRainPlayer, not v14:IsInRange(888 - (40 + 808)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((289 + 1461) >= (3219 - 2377)) and (v73 == "Friendly under Cursor")) then
						if (((4179 + 193) > (979 + 871)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((128 + 104) < (1392 - (47 + 524))) and v23(v122.HealingRainCursor, not v14:IsInRange(26 + 14), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((1415 - 897) < (1348 - 446)) and (v73 == "Enemy under Cursor")) then
						if (((6827 - 3833) > (2584 - (1165 + 561))) and v15:Exists() and v12:CanAttack(v15)) then
							if (v23(v122.HealingRainCursor, not v14:IsInRange(2 + 38), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((11629 - 7874) <= (350 + 565))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((4425 - (341 + 138)) > (1011 + 2732)) and (v73 == "Confirmation")) then
						if (v23(v121.HealingRain, not v14:IsInRange(82 - 42), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1661 - (89 + 237)) >= (10635 - 7329))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((10197 - 5353) > (3134 - (581 + 300))) and v125.AreUnitsBelowHealthPercentage(v69, v68) and v121.EarthenWallTotem:IsReady()) then
					if (((1672 - (855 + 365)) == (1073 - 621)) and (v70 == "Player")) then
						if (v23(v122.EarthenWallTotemPlayer, not v14:IsInRange(14 + 26)) or ((5792 - (1030 + 205)) < (1960 + 127))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((3604 + 270) == (4160 - (156 + 130))) and (v70 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((4403 - 2465) > (8317 - 3382))) then
							if (v23(v122.EarthenWallTotemCursor, not v14:IsInRange(81 - 41)) or ((1122 + 3133) < (1997 + 1426))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((1523 - (10 + 59)) <= (705 + 1786)) and (v70 == "Confirmation")) then
						if (v23(v121.EarthenWallTotem, not v14:IsInRange(196 - 156)) or ((5320 - (671 + 492)) <= (2232 + 571))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v145 = 1217 - (369 + 846);
			end
			if (((1285 + 3568) >= (2545 + 437)) and (v145 == (1945 - (1036 + 909)))) then
				if (((3287 + 847) > (5635 - 2278)) and v93 and v125.AreUnitsBelowHealthPercentage(298 - (11 + 192), 2 + 1) and v121.ChainHeal:IsReady() and v12:BuffUp(v121.HighTide)) then
					if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3592 - (135 + 40)) < (6139 - 3605))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v100 and (v16:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (10 + 5))) or ((5996 - 3274) <= (245 - 81))) then
					if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2584 - (50 + 126)) < (5872 - 3763))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((8 + 25) == (2868 - (1233 + 180)))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((1412 - (522 + 447)) >= (5436 - (107 + 1314)))) then
						if (((1570 + 1812) > (505 - 339)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((119 + 161) == (6074 - 3015))) then
					if (((7442 - 5561) > (3203 - (716 + 1194))) and (v16:HealthPercentage() <= v82)) then
						if (((41 + 2316) == (253 + 2104)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 504 - (74 + 429);
			end
			if (((236 - 113) == (61 + 62)) and (v145 == (4 - 2))) then
				if ((v125.AreUnitsBelowHealthPercentage(v64, v63) and v121.Downpour:IsReady()) or ((748 + 308) >= (10457 - 7065))) then
					if ((v65 == "Player") or ((2672 - 1591) < (1508 - (279 + 154)))) then
						if (v23(v122.DownpourPlayer, not v14:IsInRange(818 - (454 + 324)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((826 + 223) >= (4449 - (12 + 5)))) then
							return "downpour healingaoe";
						end
					elseif ((v65 == "Friendly under Cursor") or ((2571 + 2197) <= (2155 - 1309))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((1241 + 2117) <= (2513 - (277 + 816)))) then
							if (v23(v122.DownpourCursor, not v14:IsInRange(170 - 130), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4922 - (1058 + 125)) <= (564 + 2441))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v65 == "Confirmation") or ((2634 - (815 + 160)) >= (9156 - 7022))) then
						if (v23(v121.Downpour, not v14:IsInRange(94 - 54), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((778 + 2482) < (6884 - 4529))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v94 and v125.AreUnitsBelowHealthPercentage(v62, v61) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (1908 - (41 + 1857)))) or ((2562 - (1222 + 671)) == (10914 - 6691))) then
					if (v23(v121.CloudburstTotem) or ((2431 - 739) < (1770 - (229 + 953)))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v105 and v125.AreUnitsBelowHealthPercentage(v107, v106) and v121.Wellspring:IsReady()) or ((6571 - (1111 + 663)) < (5230 - (874 + 705)))) then
					if (v23(v121.Wellspring, not v14:IsInRange(6 + 34), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2850 + 1327) > (10081 - 5231))) then
						return "wellspring healingaoe";
					end
				end
				if ((v93 and v125.AreUnitsBelowHealthPercentage(v60, v59) and v121.ChainHeal:IsReady()) or ((12 + 388) > (1790 - (642 + 37)))) then
					if (((696 + 2355) > (161 + 844)) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v145 = 7 - 4;
			end
			if (((4147 - (233 + 221)) <= (10132 - 5750)) and (v145 == (3 + 0))) then
				if ((v103 and v12:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87) and v121.SpiritwalkersGrace:IsReady()) or ((4823 - (718 + 823)) > (2580 + 1520))) then
					if (v23(v121.SpiritwalkersGrace, nil) or ((4385 - (266 + 539)) < (8051 - 5207))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((1314 - (636 + 589)) < (10658 - 6168)) and v97 and v125.AreUnitsBelowHealthPercentage(v75, v74) and v121.HealingStreamTotem:IsReady()) then
					if (v23(v121.HealingStreamTotem, nil) or ((10277 - 5294) < (1433 + 375))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
		end
	end
	local function v133()
		local v146 = 0 + 0;
		while true do
			if (((4844 - (657 + 358)) > (9979 - 6210)) and ((4 - 2) == v146)) then
				if (((2672 - (1151 + 36)) <= (2805 + 99)) and v98 and v121.HealingSurge:IsReady()) then
					if (((1123 + 3146) == (12748 - 8479)) and (v16:HealthPercentage() <= v76)) then
						if (((2219 - (1552 + 280)) <= (3616 - (64 + 770))) and v23(v122.HealingSurgeFocus, not v16:IsSpellInRange(v121.HealingSurge), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v100 and v121.HealingWave:IsReady()) or ((1290 + 609) <= (2081 - 1164))) then
					if ((v16:HealthPercentage() <= v79) or ((766 + 3546) <= (2119 - (157 + 1086)))) then
						if (((4466 - 2234) <= (11369 - 8773)) and v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((3213 - 1118) < (5030 - 1344)) and (v146 == (820 - (599 + 220)))) then
				if ((v121.ElementalOrbit:IsAvailable() and v12:BuffDown(v121.EarthShieldBuff) and not v14:IsAPlayer() and v121.EarthShield:IsCastable() and v96) or ((3175 - 1580) >= (6405 - (1813 + 118)))) then
					v28 = v125.FocusSpecifiedUnit(v125.NamedUnit(30 + 10, v12:Name(), 1242 - (841 + 376)), 42 - 12);
					if (v28 or ((1074 + 3545) < (7866 - 4984))) then
						return v28;
					end
					if (v23(v122.EarthShieldFocus) or ((1153 - (464 + 395)) >= (12398 - 7567))) then
						return "earth_shield player healingst";
					end
				end
				if (((975 + 1054) <= (3921 - (467 + 370))) and v121.ElementalOrbit:IsAvailable() and v12:BuffUp(v121.EarthShieldBuff)) then
					if (v125.IsSoloMode() or ((4209 - 2172) == (1777 + 643))) then
						if (((15282 - 10824) > (610 + 3294)) and v121.LightningShield:IsReady() and v12:BuffDown(v121.LightningShield)) then
							if (((1014 - 578) >= (643 - (150 + 370))) and v23(v121.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif (((1782 - (74 + 1208)) < (4466 - 2650)) and v121.WaterShield:IsReady() and v12:BuffDown(v121.WaterShield)) then
						if (((16950 - 13376) == (2544 + 1030)) and v23(v121.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v146 = 392 - (14 + 376);
			end
			if (((383 - 162) < (253 + 137)) and (v146 == (0 + 0))) then
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2111 + 102) <= (4163 - 2742))) then
					if (((2301 + 757) < (4938 - (23 + 55))) and (v16:HealthPercentage() <= v82)) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((3071 - 1775) >= (2967 + 1479))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((1251 + 142) > (6959 - 2470))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((1392 + 3032) < (928 - (652 + 249)))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((5344 - 3347) > (5683 - (708 + 1160)))) then
							return "riptide healingaoe";
						end
					end
				end
				v146 = 2 - 1;
			end
		end
	end
	local function v134()
		local v147 = 0 - 0;
		while true do
			if (((3492 - (10 + 17)) > (430 + 1483)) and ((1734 - (1400 + 332)) == v147)) then
				if (((1405 - 672) < (3727 - (242 + 1666))) and v121.LightningBolt:IsReady()) then
					if (v23(v121.LightningBolt, not v14:IsSpellInRange(v121.LightningBolt), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1881 + 2514) == (1743 + 3012))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v147 == (1 + 0)) or ((4733 - (850 + 90)) < (4148 - 1779))) then
				if (v121.FlameShock:IsReady() or ((5474 - (360 + 1030)) == (235 + 30))) then
					local v251 = 0 - 0;
					while true do
						if (((5995 - 1637) == (6019 - (909 + 752))) and (v251 == (1223 - (109 + 1114)))) then
							if (v125.CastCycle(v121.FlameShock, v12:GetEnemiesInRange(73 - 33), v128, not v14:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil) or ((1222 + 1916) < (1235 - (6 + 236)))) then
								return "flame_shock_cycle damage";
							end
							if (((2099 + 1231) > (1870 + 453)) and v23(v121.FlameShock, not v14:IsSpellInRange(v121.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v121.LavaBurst:IsReady() or ((8551 - 4925) == (6967 - 2978))) then
					if (v23(v121.LavaBurst, not v14:IsSpellInRange(v121.LavaBurst), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2049 - (1076 + 57)) == (440 + 2231))) then
						return "lava_burst damage";
					end
				end
				v147 = 691 - (579 + 110);
			end
			if (((22 + 250) == (241 + 31)) and (v147 == (0 + 0))) then
				if (((4656 - (174 + 233)) <= (13516 - 8677)) and v121.Stormkeeper:IsReady()) then
					if (((4873 - 2096) < (1423 + 1777)) and v23(v121.Stormkeeper, not v14:IsInRange(1214 - (663 + 511)))) then
						return "stormkeeper damage";
					end
				end
				if (((85 + 10) < (425 + 1532)) and (math.max(#v12:GetEnemiesInRange(61 - 41), v12:GetEnemiesInSplashRangeCount(5 + 3)) > (4 - 2))) then
					if (((1999 - 1173) < (820 + 897)) and v121.ChainLightning:IsReady()) then
						if (((2775 - 1349) >= (788 + 317)) and v23(v121.ChainLightning, not v14:IsSpellInRange(v121.ChainLightning), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v147 = 1 + 0;
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
	local v137 = 722 - (478 + 244);
	local function v138()
		v135();
		v136();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['dispel'];
		v32 = EpicSettings.Toggles['healing'];
		v33 = EpicSettings.Toggles['dps'];
		local v237;
		if (((3271 - (440 + 77)) <= (1537 + 1842)) and v12:IsDeadOrGhost()) then
			return;
		end
		if (v125.TargetIsValid() or v12:AffectingCombat() or ((14373 - 10446) == (2969 - (655 + 901)))) then
			v120 = v12:GetEnemiesInRange(8 + 32);
			v118 = v9.BossFightRemains(nil, true);
			v119 = v118;
			if ((v119 == (8507 + 2604)) or ((780 + 374) <= (3174 - 2386))) then
				v119 = v9.FightRemains(v120, false);
			end
		end
		if (not v12:AffectingCombat() or ((3088 - (695 + 750)) > (11538 - 8159))) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((4325 - 1522) > (18294 - 13745))) then
				local v245 = v125.DeadFriendlyUnitsCount();
				if ((v245 > (352 - (285 + 66))) or ((512 - 292) >= (4332 - (682 + 628)))) then
					if (((455 + 2367) == (3121 - (176 + 123))) and v23(v121.AncestralVision, nil, v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "ancestral_vision";
					end
				elseif (v23(v122.AncestralSpiritMouseover, not v14:IsInRange(17 + 23), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((770 + 291) == (2126 - (239 + 30)))) then
					return "ancestral_spirit";
				end
			end
		end
		v237 = v130();
		if (((751 + 2009) > (1311 + 53)) and v237) then
			return v237;
		end
		if (v12:AffectingCombat() or v29 or ((8675 - 3773) <= (11215 - 7620))) then
			local v242 = 315 - (306 + 9);
			local v243;
			while true do
				if ((v242 == (0 - 0)) or ((670 + 3182) == (180 + 113))) then
					v243 = v44 and v121.PurifySpirit:IsReady() and v31;
					if ((v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 13 + 12) < (2 - 1))) or ((2934 - (1140 + 235)) == (2920 + 1668))) then
						local v252 = 0 + 0;
						while true do
							if (((0 + 0) == v252) or ((4536 - (33 + 19)) == (285 + 503))) then
								v28 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 44 - 29, 18 + 22, "TANK", true, 48 - 23);
								if (((4284 + 284) >= (4596 - (586 + 103))) and v28) then
									return v28;
								end
								v252 = 1 + 0;
							end
							if (((3835 - 2589) < (4958 - (1309 + 179))) and (v252 == (1 - 0))) then
								if (((1771 + 2297) >= (2610 - 1638)) and (v125.UnitGroupRole(v16) == "TANK")) then
									if (((373 + 120) < (8270 - 4377)) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
										return "earth_shield_tank main apl 1";
									end
								end
								break;
							end
						end
					end
					v242 = 1 - 0;
				end
				if ((v242 == (611 - (295 + 314))) or ((3617 - 2144) >= (5294 - (1300 + 662)))) then
					if (v28 or ((12720 - 8669) <= (2912 - (1178 + 577)))) then
						return v28;
					end
					break;
				end
				if (((314 + 290) < (8516 - 5635)) and (v242 == (1406 - (851 + 554)))) then
					if (not v16:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v16) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 23 + 2) >= (2 - 1)) or ((1954 - 1054) == (3679 - (115 + 187)))) then
						v28 = v125.FocusUnit(v243, nil, 31 + 9, nil, 24 + 1);
						if (((17571 - 13112) > (1752 - (160 + 1001))) and v28) then
							return v28;
						end
					end
					v28 = v125.FocusSpecifiedUnit(v125.FriendlyUnitWithHealAbsorb(35 + 5, nil, 18 + 7), 61 - 31);
					v242 = 360 - (237 + 121);
				end
			end
		end
		if (((4295 - (525 + 372)) >= (4540 - 2145)) and v121.EarthShield:IsCastable() and v96 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(131 - 91) and (v125.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v121.EarthShield))) then
			if (v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield)) or ((2325 - (96 + 46)) >= (3601 - (643 + 134)))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if (((699 + 1237) == (4641 - 2705)) and v12:AffectingCombat() and v125.TargetIsValid()) then
			if ((v30 and v50 and v123.Dreambinder:IsEquippedAndReady()) or v123.Iridal:IsEquippedAndReady() or ((17939 - 13107) < (4137 + 176))) then
				if (((8022 - 3934) > (7918 - 4044)) and v23(v122.UseWeapon, nil)) then
					return "Using Weapon Macro";
				end
			end
			if (((5051 - (316 + 403)) == (2880 + 1452)) and v116 and v123.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v117)) then
				if (((10994 - 6995) >= (1049 + 1851)) and v23(v122.ManaPotion, nil)) then
					return "Mana Potion main";
				end
			end
			v28 = v125.Interrupt(v121.WindShear, 75 - 45, true);
			if (v28 or ((1790 + 735) > (1310 + 2754))) then
				return v28;
			end
			v28 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 103 - 73, true, v15);
			if (((20875 - 16504) == (9080 - 4709)) and v28) then
				return v28;
			end
			v28 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 2 + 28, nil, v15);
			if (v28 or ((523 - 257) > (244 + 4742))) then
				return v28;
			end
			v237 = v129();
			if (((5857 - 3866) >= (942 - (12 + 5))) and v237) then
				return v237;
			end
			if (((1767 - 1312) < (4379 - 2326)) and v121.GreaterPurge:IsAvailable() and v46 and v121.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) then
				if (v23(v121.GreaterPurge, not v14:IsSpellInRange(v121.GreaterPurge)) or ((1755 - 929) == (12029 - 7178))) then
					return "greater_purge utility";
				end
			end
			if (((38 + 145) == (2156 - (1656 + 317))) and v121.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) then
				if (((1033 + 126) <= (1433 + 355)) and v23(v121.Purge, not v14:IsSpellInRange(v121.Purge))) then
					return "purge utility";
				end
			end
			if ((v119 > v111) or ((9324 - 5817) > (21251 - 16933))) then
				v237 = v131();
				if (v237 or ((3429 - (5 + 349)) <= (14083 - 11118))) then
					return v237;
				end
			end
		end
		if (((2636 - (266 + 1005)) <= (1326 + 685)) and (v29 or v12:AffectingCombat())) then
			local v244 = 0 - 0;
			while true do
				if (((0 - 0) == v244) or ((4472 - (561 + 1135)) > (4658 - 1083))) then
					if ((v31 and v44) or ((8395 - 5841) == (5870 - (507 + 559)))) then
						local v253 = 0 - 0;
						while true do
							if (((7969 - 5392) == (2965 - (212 + 176))) and (v253 == (906 - (250 + 655)))) then
								if ((v15 and v15:Exists() and v15:IsAPlayer() and v125.UnitHasDispellableDebuffByPlayer(v15)) or ((16 - 10) >= (3300 - 1411))) then
									if (((791 - 285) <= (3848 - (1869 + 87))) and v121.PurifySpirit:IsCastable()) then
										if (v23(v122.PurifySpiritMouseover, not v15:IsSpellInRange(v121.PurifySpirit)) or ((6964 - 4956) > (4119 - (484 + 1417)))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
							if (((811 - 432) <= (6949 - 2802)) and (v253 == (773 - (48 + 725)))) then
								if ((v121.Bursting:MaxDebuffStack() > (5 - 1)) or ((12110 - 7596) <= (587 + 422))) then
									v28 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
									if (v28 or ((9342 - 5846) == (334 + 858))) then
										return v28;
									end
								end
								if (v16 or ((61 + 147) == (3812 - (152 + 701)))) then
									if (((5588 - (430 + 881)) >= (503 + 810)) and v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(920 - (557 + 338))) then
										local v259 = 0 + 0;
										while true do
											if (((7290 - 4703) < (11114 - 7940)) and (v259 == (0 - 0))) then
												if ((v137 == (0 - 0)) or ((4921 - (499 + 302)) <= (3064 - (39 + 827)))) then
													v137 = GetTime();
												end
												if (v125.Wait(1380 - 880, v137) or ((3564 - 1968) == (3407 - 2549))) then
													local v260 = 0 - 0;
													while true do
														if (((276 + 2944) == (9424 - 6204)) and (v260 == (0 + 0))) then
															if (v23(v122.PurifySpiritFocus, not v16:IsSpellInRange(v121.PurifySpirit)) or ((2217 - 815) > (3724 - (103 + 1)))) then
																return "purify_spirit dispel focus";
															end
															v137 = 554 - (475 + 79);
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								v253 = 2 - 1;
							end
						end
					end
					if (((8236 - 5662) == (333 + 2241)) and (v121.Bursting:AuraActiveCount() > (3 + 0))) then
						local v254 = 1503 - (1395 + 108);
						while true do
							if (((5232 - 3434) < (3961 - (7 + 1197))) and (v254 == (0 + 0))) then
								if (((v121.Bursting:MaxDebuffStack() > (2 + 3)) and v121.SpiritLinkTotem:IsReady()) or ((696 - (27 + 292)) > (7630 - 5026))) then
									if (((723 - 155) < (3820 - 2909)) and (v86 == "Player")) then
										if (((6477 - 3192) < (8051 - 3823)) and v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(179 - (43 + 96)))) then
											return "spirit_link_totem bursting";
										end
									elseif (((15973 - 12057) > (7524 - 4196)) and (v86 == "Friendly under Cursor")) then
										if (((2075 + 425) < (1084 + 2755)) and v15:Exists() and not v12:CanAttack(v15)) then
											if (((1001 - 494) == (195 + 312)) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(74 - 34))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif (((76 + 164) <= (233 + 2932)) and (v86 == "Confirmation")) then
										if (((2585 - (1414 + 337)) >= (2745 - (1642 + 298))) and v23(v121.SpiritLinkTotem, not v14:IsInRange(104 - 64))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v93 and v121.ChainHeal:IsReady()) or ((10966 - 7154) < (6872 - 4556))) then
									if (v23(v122.ChainHealFocus, nil) or ((873 + 1779) <= (1193 + 340))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
								break;
							end
						end
					end
					v244 = 973 - (357 + 615);
				end
				if ((v244 == (2 + 0)) or ((8828 - 5230) < (1251 + 209))) then
					if (v32 or ((8820 - 4704) < (954 + 238))) then
						if ((v14:Exists() and not v12:CanAttack(v14)) or ((230 + 3147) <= (568 + 335))) then
							local v255 = 1301 - (384 + 917);
							while true do
								if (((4673 - (128 + 569)) >= (1982 - (1407 + 136))) and (v255 == (1887 - (687 + 1200)))) then
									if (((5462 - (556 + 1154)) == (13199 - 9447)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v14:BuffDown(v121.Riptide)) then
										if (((4141 - (9 + 86)) > (3116 - (275 + 146))) and (v14:HealthPercentage() <= v82)) then
											if (v23(v121.Riptide, not v16:IsSpellInRange(v121.Riptide)) or ((577 + 2968) == (3261 - (29 + 35)))) then
												return "riptide healing target";
											end
										end
									end
									if (((10609 - 8215) > (1113 - 740)) and v104 and v121.UnleashLife:IsReady() and (v14:HealthPercentage() <= v89)) then
										if (((18342 - 14187) <= (2757 + 1475)) and v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife))) then
											return "unleash_life healing target";
										end
									end
									v255 = 1013 - (53 + 959);
								end
								if ((v255 == (409 - (312 + 96))) or ((6215 - 2634) == (3758 - (147 + 138)))) then
									if (((5894 - (813 + 86)) > (3026 + 322)) and v93 and (v14:HealthPercentage() <= v60) and v121.ChainHeal:IsReady() and (v12:IsInParty() or v12:IsInRaid() or v125.TargetIsValidHealableNpc() or v12:BuffUp(v121.HighTide))) then
										if (v23(v121.ChainHeal, not v14:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1396 - 642) > (4216 - (18 + 474)))) then
											return "chain_heal healing target";
										end
									end
									if (((74 + 143) >= (185 - 128)) and v100 and (v14:HealthPercentage() <= v79) and v121.HealingWave:IsReady()) then
										if (v23(v121.HealingWave, not v14:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3156 - (860 + 226)) >= (4340 - (121 + 182)))) then
											return "healing_wave healing target";
										end
									end
									break;
								end
							end
						end
						v237 = v132();
						if (((333 + 2372) == (3945 - (988 + 252))) and v237) then
							return v237;
						end
						v237 = v133();
						if (((7 + 54) == (20 + 41)) and v237) then
							return v237;
						end
					end
					if (v33 or ((2669 - (49 + 1921)) >= (2186 - (223 + 667)))) then
						if (v125.TargetIsValid() or ((1835 - (51 + 1)) >= (6223 - 2607))) then
							local v256 = 0 - 0;
							while true do
								if ((v256 == (1125 - (146 + 979))) or ((1105 + 2808) > (5132 - (311 + 294)))) then
									v237 = v134();
									if (((12203 - 7827) > (347 + 470)) and v237) then
										return v237;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if (((6304 - (496 + 947)) > (2182 - (1233 + 125))) and (v244 == (1 + 0))) then
					if (((v16:HealthPercentage() < v81) and v16:BuffDown(v121.Riptide)) or ((1241 + 142) >= (405 + 1726))) then
						if (v121.PrimordialWaveResto:IsCastable() or ((3521 - (963 + 682)) >= (2121 + 420))) then
							if (((3286 - (504 + 1000)) <= (2541 + 1231)) and v23(v122.PrimordialWaveFocus, not v16:IsSpellInRange(v121.PrimordialWaveResto))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v12:GCD() * (3 + 0)))) or ((444 + 4256) < (1198 - 385))) then
						if (((2734 + 465) < (2356 + 1694)) and v23(v121.TotemicRecall, nil)) then
							return "totemic_recall main";
						end
					end
					v244 = 184 - (156 + 26);
				end
			end
		end
	end
	local function v139()
		local v238 = 0 + 0;
		while true do
			if (((1 - 0) == v238) or ((5115 - (149 + 15)) < (5390 - (890 + 70)))) then
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
			if (((213 - (39 + 78)) == (578 - (14 + 468))) and (v238 == (0 - 0))) then
				v127();
				v121.Bursting:RegisterAuraTracking();
				v238 = 2 - 1;
			end
		end
	end
	v21.SetAPL(137 + 127, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

