local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1469 - (1269 + 200);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((1873 - (98 + 717)) >= (2028 - (802 + 24)))) then
			return v6(...);
		end
		if (((6399 - 2688) > (4237 - 882)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((697 + 209) >= (367 + 1862))) then
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
	local v112 = 30910 - 19799;
	local v113 = 37052 - 25941;
	local v114;
	v10:RegisterForEvent(function()
		v112 = 3975 + 7136;
		v113 = 4523 + 6588;
	end, "PLAYER_REGEN_ENABLED");
	local v115 = v18.Shaman.Restoration;
	local v116 = v25.Shaman.Restoration;
	local v117 = v20.Shaman.Restoration;
	local v118 = {};
	local v119 = v22.Commons.Everyone;
	local v120 = v22.Commons.Shaman;
	local function v121()
		if (((1063 + 225) > (910 + 341)) and v115.ImprovedPurifySpirit:IsAvailable()) then
			v119.DispellableDebuffs = v21.MergeTable(v119.DispellableMagicDebuffs, v119.DispellableCurseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122(v133)
		return v133:DebuffRefreshable(v115.FlameShockDebuff) and (v113 > (3 + 2));
	end
	local function v123()
		if ((v88 and v115.AstralShift:IsReady()) or ((5946 - (797 + 636)) < (16275 - 12923))) then
			if ((v13:HealthPercentage() <= v54) or ((3684 - (1427 + 192)) >= (1108 + 2088))) then
				if (v24(v115.AstralShift, not v15:IsInRange(92 - 52)) or ((3934 + 442) <= (672 + 809))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v91 and v115.EarthElemental:IsReady()) or ((3718 - (192 + 134)) >= (6017 - (316 + 960)))) then
			if (((1851 + 1474) >= (1663 + 491)) and ((v13:HealthPercentage() <= v62) or v119.IsTankBelowHealthPercentage(v63))) then
				if (v24(v115.EarthElemental, not v15:IsInRange(37 + 3)) or ((4950 - 3655) >= (3784 - (83 + 468)))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((6183 - (1202 + 604)) > (7665 - 6023)) and v117.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (((7859 - 3136) > (3754 - 2398)) and v24(v116.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((4461 - (45 + 280)) <= (3314 + 119))) then
			if (((3709 + 536) <= (1691 + 2940)) and (v40 == "Refreshing Healing Potion")) then
				if (((2367 + 1909) >= (689 + 3225)) and v117.RefreshingHealingPotion:IsReady()) then
					if (((366 - 168) <= (6276 - (340 + 1571))) and v24(v116.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((1887 + 2895) > (6448 - (1733 + 39))) and (v40 == "Dreamwalker's Healing Potion")) then
				if (((13365 - 8501) > (3231 - (125 + 909))) and v117.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v116.RefreshingHealingPotion) or ((5648 - (1096 + 852)) == (1125 + 1382))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		while true do
			if (((4340 + 134) >= (786 - (409 + 103))) and (v134 == (236 - (46 + 190)))) then
				if (v41 or ((1989 - (51 + 44)) <= (397 + 1009))) then
					v29 = v119.HandleCharredTreant(v115.Riptide, v116.RiptideMouseover, 1357 - (1114 + 203));
					if (((2298 - (228 + 498)) >= (332 + 1199)) and v29) then
						return v29;
					end
					v29 = v119.HandleCharredTreant(v115.HealingSurge, v116.HealingSurgeMouseover, 23 + 17);
					if (v29 or ((5350 - (174 + 489)) < (11833 - 7291))) then
						return v29;
					end
					v29 = v119.HandleCharredTreant(v115.HealingWave, v116.HealingWaveMouseover, 1945 - (830 + 1075));
					if (((3815 - (303 + 221)) > (2936 - (231 + 1038))) and v29) then
						return v29;
					end
				end
				if (v42 or ((728 + 145) == (3196 - (171 + 991)))) then
					v29 = v119.HandleCharredBrambles(v115.Riptide, v116.RiptideMouseover, 164 - 124);
					if (v29 or ((7561 - 4745) < (27 - 16))) then
						return v29;
					end
					v29 = v119.HandleCharredBrambles(v115.HealingSurge, v116.HealingSurgeMouseover, 33 + 7);
					if (((12966 - 9267) < (13575 - 8869)) and v29) then
						return v29;
					end
					v29 = v119.HandleCharredBrambles(v115.HealingWave, v116.HealingWaveMouseover, 64 - 24);
					if (((8179 - 5533) >= (2124 - (111 + 1137))) and v29) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v135 = 158 - (91 + 67);
		while true do
			if (((1827 - 1213) <= (795 + 2389)) and (v135 == (525 - (423 + 100)))) then
				if (((22 + 3104) == (8654 - 5528)) and v95 and v119.AreUnitsBelowHealthPercentage(v74, v73) and v115.HealingTideTotem:IsReady()) then
					if (v24(v115.HealingTideTotem, not v15:IsInRange(21 + 19)) or ((2958 - (326 + 445)) >= (21619 - 16665))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v50, v49) and v115.AncestralProtectionTotem:IsReady()) or ((8637 - 4760) == (8344 - 4769))) then
					if (((1418 - (530 + 181)) > (1513 - (614 + 267))) and (v51 == "Player")) then
						if (v24(v116.AncestralProtectionTotemPlayer, not v15:IsInRange(72 - (19 + 13))) or ((887 - 341) >= (6254 - 3570))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((4184 - 2719) <= (1118 + 3183)) and (v51 == "Friendly under Cursor")) then
						if (((2996 - 1292) > (2955 - 1530)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v116.AncestralProtectionTotemCursor, not v15:IsInRange(1852 - (1293 + 519))) or ((1401 - 714) == (11054 - 6820))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v51 == "Confirmation") or ((6368 - 3038) < (6161 - 4732))) then
						if (((2701 - 1554) >= (178 + 157)) and v24(v115.AncestralProtectionTotem, not v15:IsInRange(9 + 31))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v135 = 6 - 3;
			end
			if (((794 + 2641) > (697 + 1400)) and (v135 == (0 + 0))) then
				if ((v106 and ((v31 and v105) or not v105)) or ((4866 - (709 + 387)) >= (5899 - (673 + 1185)))) then
					local v230 = 0 - 0;
					while true do
						if (((3 - 2) == v230) or ((6237 - 2446) <= (1153 + 458))) then
							v29 = v119.HandleBottomTrinket(v118, v31, 30 + 10, nil);
							if (v29 or ((6180 - 1602) <= (494 + 1514))) then
								return v29;
							end
							break;
						end
						if (((2243 - 1118) <= (4074 - 1998)) and (v230 == (1880 - (446 + 1434)))) then
							v29 = v119.HandleTopTrinket(v118, v31, 1323 - (1040 + 243), nil);
							if (v29 or ((2217 - 1474) >= (6246 - (559 + 1288)))) then
								return v29;
							end
							v230 = 1932 - (609 + 1322);
						end
					end
				end
				if (((1609 - (13 + 441)) < (6251 - 4578)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
					if ((v17:HealthPercentage() <= v78) or ((6087 - 3763) <= (2878 - 2300))) then
						if (((141 + 3626) == (13680 - 9913)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v135 = 1 + 0;
			end
			if (((1792 + 2297) == (12134 - 8045)) and (v135 == (2 + 1))) then
				if (((8198 - 3740) >= (1107 + 567)) and v86 and v119.AreUnitsBelowHealthPercentage(v48, v47) and v115.AncestralGuidance:IsReady()) then
					if (((541 + 431) <= (1019 + 399)) and v24(v115.AncestralGuidance, not v15:IsInRange(34 + 6))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v87 and v119.AreUnitsBelowHealthPercentage(v53, v52) and v115.Ascendance:IsReady()) or ((4832 + 106) < (5195 - (153 + 280)))) then
					if (v24(v115.Ascendance, not v15:IsInRange(115 - 75)) or ((2249 + 255) > (1684 + 2580))) then
						return "ascendance cooldowns";
					end
				end
				v135 = 3 + 1;
			end
			if (((1954 + 199) == (1561 + 592)) and (v135 == (5 - 1))) then
				if ((v97 and (v13:Mana() <= v76) and v115.ManaTideTotem:IsReady()) or ((314 + 193) >= (3258 - (89 + 578)))) then
					if (((3202 + 1279) == (9315 - 4834)) and v24(v115.ManaTideTotem, not v15:IsInRange(1089 - (572 + 477)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v104 and v31) or not v104)) or ((314 + 2014) < (416 + 277))) then
					local v231 = 0 + 0;
					while true do
						if (((4414 - (84 + 2)) == (7132 - 2804)) and (v231 == (2 + 0))) then
							if (((2430 - (497 + 345)) >= (35 + 1297)) and v115.Fireblood:IsReady()) then
								if (v24(v115.Fireblood, not v15:IsInRange(7 + 33)) or ((5507 - (605 + 728)) > (3031 + 1217))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if ((v231 == (1 - 0)) or ((211 + 4375) <= (303 - 221))) then
							if (((3483 + 380) == (10702 - 6839)) and v115.Berserking:IsReady()) then
								if (v24(v115.Berserking, not v15:IsInRange(31 + 9)) or ((771 - (457 + 32)) <= (18 + 24))) then
									return "Berserking cooldowns";
								end
							end
							if (((6011 - (832 + 570)) >= (722 + 44)) and v115.BloodFury:IsReady()) then
								if (v24(v115.BloodFury, not v15:IsInRange(11 + 29)) or ((4076 - 2924) == (1199 + 1289))) then
									return "BloodFury cooldowns";
								end
							end
							v231 = 798 - (588 + 208);
						end
						if (((9222 - 5800) > (5150 - (884 + 916))) and (v231 == (0 - 0))) then
							if (((509 + 368) > (1029 - (232 + 421))) and v115.AncestralCall:IsReady()) then
								if (v24(v115.AncestralCall, not v15:IsInRange(1929 - (1569 + 320))) or ((765 + 2353) <= (352 + 1499))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v115.BagofTricks:IsReady() or ((556 - 391) >= (4097 - (316 + 289)))) then
								if (((10336 - 6387) < (225 + 4631)) and v24(v115.BagofTricks, not v15:IsInRange(1493 - (666 + 787)))) then
									return "BagofTricks cooldowns";
								end
							end
							v231 = 426 - (360 + 65);
						end
					end
				end
				break;
			end
			if ((v135 == (1 + 0)) or ((4530 - (79 + 175)) < (4755 - 1739))) then
				if (((3660 + 1030) > (12644 - 8519)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
					if (((v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) or ((96 - 46) >= (1795 - (503 + 396)))) then
						if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((1895 - (92 + 89)) >= (5738 - 2780))) then
							return "riptide healingcd";
						end
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v81, v80) and v115.SpiritLinkTotem:IsReady()) or ((765 + 726) < (382 + 262))) then
					if (((2756 - 2052) < (135 + 852)) and (v82 == "Player")) then
						if (((8477 - 4759) > (1663 + 243)) and v24(v116.SpiritLinkTotemPlayer, not v15:IsInRange(20 + 20))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v82 == "Friendly under Cursor") or ((2917 - 1959) > (454 + 3181))) then
						if (((5338 - 1837) <= (5736 - (485 + 759))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v116.SpiritLinkTotemCursor, not v15:IsInRange(92 - 52)) or ((4631 - (442 + 747)) < (3683 - (832 + 303)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((3821 - (88 + 858)) >= (447 + 1017)) and (v82 == "Confirmation")) then
						if (v24(v115.SpiritLinkTotem, not v15:IsInRange(34 + 6)) or ((198 + 4599) >= (5682 - (766 + 23)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v135 = 9 - 7;
			end
		end
	end
	local function v126()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (2 - 1)) or ((1870 - 1319) > (3141 - (1036 + 37)))) then
				if (((1499 + 615) > (1837 - 893)) and v100 and v115.UnleashLife:IsReady()) then
					if ((v17:HealthPercentage() <= v85) or ((1780 + 482) >= (4576 - (641 + 839)))) then
						if (v24(v115.UnleashLife, not v17:IsSpellInRange(v115.UnleashLife)) or ((3168 - (910 + 3)) >= (9016 - 5479))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v69 == "Cursor") and v115.HealingRain:IsReady()) or ((5521 - (1466 + 218)) < (601 + 705))) then
					if (((4098 - (556 + 592)) == (1050 + 1900)) and v24(v116.HealingRainCursor, not v15:IsInRange(848 - (329 + 479)), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v68, v67) and v115.HealingRain:IsReady()) or ((5577 - (174 + 680)) < (11332 - 8034))) then
					if (((2354 - 1218) >= (110 + 44)) and (v69 == "Player")) then
						if (v24(v116.HealingRainPlayer, not v15:IsInRange(779 - (396 + 343)), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((24 + 247) > (6225 - (29 + 1448)))) then
							return "healing_rain healingaoe";
						end
					elseif (((6129 - (135 + 1254)) >= (11874 - 8722)) and (v69 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((12036 - 9458) >= (2260 + 1130))) then
							if (((1568 - (389 + 1138)) <= (2235 - (102 + 472))) and v24(v116.HealingRainCursor, not v15:IsInRange(38 + 2), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((334 + 267) < (3320 + 240)) and (v69 == "Enemy under Cursor")) then
						if (((1780 - (320 + 1225)) < (1222 - 535)) and v16:Exists() and v13:CanAttack(v16)) then
							if (((2784 + 1765) > (2617 - (157 + 1307))) and v24(v116.HealingRainCursor, not v15:IsInRange(1899 - (821 + 1038)), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v69 == "Confirmation") or ((11661 - 6987) < (511 + 4161))) then
						if (((6515 - 2847) < (1697 + 2864)) and v24(v115.HealingRain, not v15:IsInRange(99 - 59), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v65, v64) and v115.EarthenWallTotem:IsReady()) or ((1481 - (834 + 192)) == (230 + 3375))) then
					if ((v66 == "Player") or ((684 + 1979) == (72 + 3240))) then
						if (((6625 - 2348) <= (4779 - (300 + 4))) and v24(v116.EarthenWallTotemPlayer, not v15:IsInRange(11 + 29))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v66 == "Friendly under Cursor") or ((2277 - 1407) == (1551 - (112 + 250)))) then
						if (((620 + 933) <= (7848 - 4715)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v116.EarthenWallTotemCursor, not v15:IsInRange(23 + 17)) or ((1157 + 1080) >= (2626 + 885))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v66 == "Confirmation") or ((657 + 667) > (2244 + 776))) then
						if (v24(v115.EarthenWallTotem, not v15:IsInRange(1454 - (1001 + 413))) or ((6671 - 3679) == (2763 - (244 + 638)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v136 = 695 - (627 + 66);
			end
			if (((9254 - 6148) > (2128 - (512 + 90))) and (v136 == (1908 - (1665 + 241)))) then
				if (((3740 - (373 + 344)) < (1746 + 2124)) and v119.AreUnitsBelowHealthPercentage(v60, v59) and v115.Downpour:IsReady()) then
					if (((38 + 105) > (195 - 121)) and (v61 == "Player")) then
						if (((30 - 12) < (3211 - (35 + 1064))) and v24(v116.DownpourPlayer, not v15:IsInRange(30 + 10), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif (((2346 - 1249) <= (7 + 1621)) and (v61 == "Friendly under Cursor")) then
						if (((5866 - (298 + 938)) == (5889 - (233 + 1026))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((5206 - (636 + 1030)) > (1372 + 1311)) and v24(v116.DownpourCursor, not v15:IsInRange(40 + 0), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((1425 + 3369) >= (222 + 3053)) and (v61 == "Confirmation")) then
						if (((1705 - (55 + 166)) == (288 + 1196)) and v24(v115.Downpour, not v15:IsInRange(5 + 35), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				if (((5468 - 4036) < (3852 - (36 + 261))) and v90 and v119.AreUnitsBelowHealthPercentage(v58, v57) and v115.CloudburstTotem:IsReady()) then
					if (v24(v115.CloudburstTotem) or ((1862 - 797) > (4946 - (34 + 1334)))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v101 and v119.AreUnitsBelowHealthPercentage(v103, v102) and v115.Wellspring:IsReady()) or ((1844 + 2951) < (1094 + 313))) then
					if (((3136 - (1035 + 248)) < (4834 - (20 + 1))) and v24(v115.Wellspring, not v15:IsInRange(21 + 19), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if ((v89 and v119.AreUnitsBelowHealthPercentage(v56, v55) and v115.ChainHeal:IsReady()) or ((3140 - (134 + 185)) < (3564 - (549 + 584)))) then
					if (v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3559 - (314 + 371)) < (7487 - 5306))) then
						return "chain_heal healingaoe";
					end
				end
				v136 = 971 - (478 + 490);
			end
			if ((v136 == (2 + 1)) or ((3861 - (786 + 386)) <= (1110 - 767))) then
				if ((v99 and v13:IsMoving() and v119.AreUnitsBelowHealthPercentage(v84, v83) and v115.SpiritwalkersGrace:IsReady()) or ((3248 - (1055 + 324)) == (3349 - (1093 + 247)))) then
					if (v24(v115.SpiritwalkersGrace, nil) or ((3152 + 394) < (245 + 2077))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v93 and v119.AreUnitsBelowHealthPercentage(v71, v70) and v115.HealingStreamTotem:IsReady()) or ((8265 - 6183) == (16198 - 11425))) then
					if (((9230 - 5986) > (2651 - 1596)) and v24(v115.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v136 == (0 + 0)) or ((12762 - 9449) <= (6128 - 4350))) then
				if ((v89 and v119.AreUnitsBelowHealthPercentage(72 + 23, 7 - 4) and v115.ChainHeal:IsReady() and v13:BuffUp(v115.HighTide)) or ((2109 - (364 + 324)) >= (5767 - 3663))) then
					if (((4347 - 2535) <= (1077 + 2172)) and v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((6790 - 5167) <= (3133 - 1176)) and v96 and (v17:HealthPercentage() <= v75) and v115.HealingWave:IsReady() and (v115.PrimordialWaveResto:TimeSinceLastCast() < (45 - 30))) then
					if (((5680 - (1249 + 19)) == (3983 + 429)) and v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((6811 - 5061) >= (1928 - (686 + 400))) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
					if (((3431 + 941) > (2079 - (73 + 156))) and (v17:HealthPercentage() <= v78)) then
						if (((2 + 230) < (1632 - (721 + 90))) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((6 + 512) < (2928 - 2026)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
					if (((3464 - (224 + 246)) > (1389 - 531)) and (v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) then
						if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((6913 - 3158) <= (166 + 749))) then
							return "riptide healingaoe";
						end
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v127()
		if (((2899 + 1047) > (7441 - 3698)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if ((v17:HealthPercentage() <= v78) or ((4442 - 3107) >= (3819 - (203 + 310)))) then
				if (((6837 - (1238 + 755)) > (158 + 2095)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1986 - (709 + 825)) == (832 - 380)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if (((v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) or ((6638 - 2081) < (2951 - (196 + 668)))) then
				if (((15295 - 11421) == (8024 - 4150)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((2771 - (171 + 662)) > (5028 - (4 + 89)))) then
			if ((v17:HealthPercentage() <= v78) or (v17:HealthPercentage() <= v78) or ((14913 - 10658) < (1247 + 2176))) then
				if (((6386 - 4932) <= (977 + 1514)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v115.ElementalOrbit:IsAvailable() and v13:BuffDown(v115.EarthShieldBuff)) or ((5643 - (35 + 1451)) <= (4256 - (28 + 1425)))) then
			if (((6846 - (941 + 1052)) >= (2860 + 122)) and v24(v115.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((5648 - (822 + 692)) > (4792 - 1435)) and v115.ElementalOrbit:IsAvailable() and v13:BuffUp(v115.EarthShieldBuff)) then
			if (v119.IsSoloMode() or ((1610 + 1807) < (2831 - (45 + 252)))) then
				if ((v115.LightningShield:IsReady() and v13:BuffDown(v115.LightningShield)) or ((2694 + 28) <= (57 + 107))) then
					if (v24(v115.LightningShield) or ((5860 - 3452) < (2542 - (114 + 319)))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v115.WaterShield:IsReady() and v13:BuffDown(v115.WaterShield)) or ((46 - 13) == (1864 - 409))) then
				if (v24(v115.WaterShield) or ((283 + 160) >= (5981 - 1966))) then
					return "water_shield healingst";
				end
			end
		end
		if (((7085 - 3703) > (2129 - (556 + 1407))) and v94 and v115.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v72) or ((1486 - (741 + 465)) == (3524 - (170 + 295)))) then
				if (((992 + 889) > (1188 + 105)) and v24(v116.HealingSurgeFocus, not v17:IsSpellInRange(v115.HealingSurge), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((5803 - 3446) == (1954 + 403)) and v96 and v115.HealingWave:IsReady()) then
			if (((79 + 44) == (70 + 53)) and (v17:HealthPercentage() <= v75)) then
				if (v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2286 - (957 + 273)) >= (908 + 2484))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v128()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (0 - 0)) or ((2848 - 1767) < (3283 - 2208))) then
				if (v115.FlameShock:IsReady() or ((5194 - 4145) >= (6212 - (389 + 1391)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (0 + 0)) or ((10854 - 6086) <= (1797 - (783 + 168)))) then
							if (v119.CastCycle(v115.FlameShock, v13:GetEnemiesInRange(134 - 94), v122, not v15:IsSpellInRange(v115.FlameShock), nil, nil, nil, nil) or ((3304 + 54) <= (1731 - (309 + 2)))) then
								return "flame_shock_cycle damage";
							end
							if (v24(v115.FlameShock, not v15:IsSpellInRange(v115.FlameShock)) or ((11481 - 7742) <= (4217 - (1090 + 122)))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v115.LavaBurst:IsReady() or ((538 + 1121) >= (7166 - 5032))) then
					if (v24(v115.LavaBurst, not v15:IsSpellInRange(v115.LavaBurst), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2232 + 1028) < (3473 - (628 + 490)))) then
						return "lava_burst damage";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (2 - 1)) or ((3057 - 2388) == (4997 - (431 + 343)))) then
				if (v115.Stormkeeper:IsReady() or ((3416 - 1724) < (1700 - 1112))) then
					if (v24(v115.Stormkeeper, not v15:IsInRange(32 + 8)) or ((614 + 4183) < (5346 - (556 + 1139)))) then
						return "stormkeeper damage";
					end
				end
				if ((#v13:GetEnemiesInRange(55 - (6 + 9)) < (1 + 2)) or ((2140 + 2037) > (5019 - (28 + 141)))) then
					if (v115.LightningBolt:IsReady() or ((155 + 245) > (1371 - 260))) then
						if (((2161 + 890) > (2322 - (486 + 831))) and v24(v115.LightningBolt, not v15:IsSpellInRange(v115.LightningBolt), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "lightning_bolt damage";
						end
					end
				elseif (((9609 - 5916) <= (15427 - 11045)) and v115.ChainLightning:IsReady()) then
					if (v24(v115.ChainLightning, not v15:IsSpellInRange(v115.ChainLightning), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((621 + 2661) > (12964 - 8864))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
		end
	end
	local function v129()
		local v138 = 1263 - (668 + 595);
		while true do
			if ((v138 == (0 + 0)) or ((722 + 2858) < (7755 - 4911))) then
				v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v55 = EpicSettings.Settings['ChainHealGroup'];
				v56 = EpicSettings.Settings['ChainHealHP'];
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v138 = 291 - (23 + 267);
			end
			if (((2033 - (1129 + 815)) < (4877 - (371 + 16))) and (v138 == (1757 - (1326 + 424)))) then
				v94 = EpicSettings.Settings['UseHealingSurge'];
				v95 = EpicSettings.Settings['UseHealingTideTotem'];
				v96 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v98 = EpicSettings.Settings['UseRiptide'];
				v99 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v138 = 14 - 6;
			end
			if ((v138 == (10 - 7)) or ((5101 - (88 + 30)) < (2579 - (720 + 51)))) then
				v69 = EpicSettings.Settings['HealingRainUsage'];
				v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v71 = EpicSettings.Settings['HealingStreamTotemHP'];
				v72 = EpicSettings.Settings['HealingSurgeHP'];
				v73 = EpicSettings.Settings['HealingTideTotemGroup'];
				v74 = EpicSettings.Settings['HealingTideTotemHP'];
				v138 = 8 - 4;
			end
			if (((5605 - (421 + 1355)) > (6217 - 2448)) and (v138 == (1 + 0))) then
				v59 = EpicSettings.Settings['DownpourGroup'];
				v60 = EpicSettings.Settings['DownpourHP'];
				v61 = EpicSettings.Settings['DownpourUsage'];
				v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v65 = EpicSettings.Settings['EarthenWallTotemHP'];
				v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v138 = 1085 - (286 + 797);
			end
			if (((5428 - 3943) <= (4809 - 1905)) and (v138 == (443 - (397 + 42)))) then
				v75 = EpicSettings.Settings['HealingWaveHP'];
				v37 = EpicSettings.Settings['healthstoneHP'];
				v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v46 = EpicSettings.Settings['InterruptThreshold'];
				v44 = EpicSettings.Settings['InterruptWithStun'];
				v78 = EpicSettings.Settings['RiptideHP'];
				v138 = 2 + 3;
			end
			if (((5069 - (24 + 776)) == (6576 - 2307)) and (v138 == (790 - (222 + 563)))) then
				v79 = EpicSettings.Settings['RiptideTankHP'];
				v80 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v81 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v82 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v83 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v84 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v138 = 12 - 6;
			end
			if (((279 + 108) <= (2972 - (23 + 167))) and (v138 == (1806 - (690 + 1108)))) then
				v100 = EpicSettings.Settings['UseUnleashLife'];
				v110 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
				v111 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v138 == (3 + 3)) or ((1567 + 332) <= (1765 - (40 + 808)))) then
				v85 = EpicSettings.Settings['UnleashLifeHP'];
				v89 = EpicSettings.Settings['UseChainHeal'];
				v90 = EpicSettings.Settings['UseCloudburstTotem'];
				v92 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['UseHealingPotion'];
				v93 = EpicSettings.Settings['UseHealingStreamTotem'];
				v138 = 2 + 5;
			end
			if ((v138 == (7 - 5)) or ((4122 + 190) <= (464 + 412))) then
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v39 = EpicSettings.Settings['HealingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v67 = EpicSettings.Settings['HealingRainGroup'];
				v68 = EpicSettings.Settings['HealingRainHP'];
				v138 = 2 + 1;
			end
		end
	end
	local function v130()
		v47 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v48 = EpicSettings.Settings['AncestralGuidanceHP'];
		v52 = EpicSettings.Settings['AscendanceGroup'];
		v53 = EpicSettings.Settings['AscendanceHP'];
		v54 = EpicSettings.Settings['AstralShiftHP'];
		v57 = EpicSettings.Settings['CloudburstTotemGroup'];
		v58 = EpicSettings.Settings['CloudburstTotemHP'];
		v62 = EpicSettings.Settings['EarthElementalHP'];
		v63 = EpicSettings.Settings['EarthElementalTankHP'];
		v76 = EpicSettings.Settings['ManaTideTotemMana'];
		v77 = EpicSettings.Settings['PrimordialWaveHP'];
		v86 = EpicSettings.Settings['UseAncestralGuidance'];
		v87 = EpicSettings.Settings['UseAscendance'];
		v88 = EpicSettings.Settings['UseAstralShift'];
		v91 = EpicSettings.Settings['UseEarthElemental'];
		v97 = EpicSettings.Settings['UseManaTideTotem'];
		v35 = EpicSettings.Settings['UseRacials'];
		v101 = EpicSettings.Settings['UseWellspring'];
		v102 = EpicSettings.Settings['WellspringGroup'];
		v103 = EpicSettings.Settings['WellspringHP'];
		v104 = EpicSettings.Settings['racialsWithCD'];
		v105 = EpicSettings.Settings['trinketsWithCD'];
		v106 = EpicSettings.Settings['useTrinkets'];
		v107 = EpicSettings.Settings['fightRemainsCheck'];
		v108 = EpicSettings.Settings['handleAfflicted'];
		v109 = EpicSettings.Settings['HandleIncorporeal'];
		v110 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v111 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v131()
		local v167 = 571 - (47 + 524);
		local v168;
		while true do
			if (((1449 + 783) <= (7096 - 4500)) and (v167 == (2 - 0))) then
				v34 = EpicSettings.Toggles['dps'];
				if (((4777 - 2682) < (5412 - (1165 + 561))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v13:AffectingCombat() or v30 or ((48 + 1547) >= (13856 - 9382))) then
					local v233 = v43 and v115.PurifySpirit:IsReady() and v32;
					if ((v115.EarthShield:IsReady() and v92 and (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true) < (1 + 0))) or ((5098 - (341 + 138)) < (778 + 2104))) then
						local v235 = 0 - 0;
						while true do
							if (((327 - (89 + 237)) == v235) or ((945 - 651) >= (10170 - 5339))) then
								if (((2910 - (581 + 300)) <= (4304 - (855 + 365))) and (v119.UnitGroupRole(v17) == "TANK")) then
									if (v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield)) or ((4838 - 2801) == (791 + 1629))) then
										return "earth_shield_tank main apl";
									end
								end
								break;
							end
							if (((5693 - (1030 + 205)) > (3666 + 238)) and (v235 == (0 + 0))) then
								v29 = v119.FocusUnitRefreshableBuff(v115.EarthShield, 301 - (156 + 130), 90 - 50, "TANK");
								if (((734 - 298) >= (251 - 128)) and v29) then
									return v29;
								end
								v235 = 1 + 0;
							end
						end
					end
					if (((292 + 208) < (1885 - (10 + 59))) and (not v17:BuffDown(v115.EarthShield) or (v119.UnitGroupRole(v17) ~= "TANK") or not v92)) then
						local v236 = 0 + 0;
						while true do
							if (((17601 - 14027) == (4737 - (671 + 492))) and ((0 + 0) == v236)) then
								v29 = v119.FocusUnit(v233, nil, nil, nil);
								if (((1436 - (369 + 846)) < (104 + 286)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v167 = 3 + 0;
			end
			if ((v167 == (1946 - (1036 + 909))) or ((1760 + 453) <= (2385 - 964))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v167 = 205 - (11 + 192);
			end
			if (((1546 + 1512) < (5035 - (135 + 40))) and (v167 == (9 - 5))) then
				if ((v13:AffectingCombat() and v119.TargetIsValid()) or ((782 + 514) >= (9794 - 5348))) then
					local v234 = 0 - 0;
					while true do
						if ((v234 == (178 - (50 + 126))) or ((3878 - 2485) > (994 + 3495))) then
							v29 = v119.InterruptWithStunCursor(v115.CapacitorTotem, v116.CapacitorTotemCursor, 1443 - (1233 + 180), nil, v16);
							if (v29 or ((5393 - (522 + 447)) < (1448 - (107 + 1314)))) then
								return v29;
							end
							if (v109 or ((927 + 1070) > (11624 - 7809))) then
								v29 = v119.HandleIncorporeal(v115.Hex, v116.HexMouseOver, 13 + 17, true);
								if (((6880 - 3415) > (7568 - 5655)) and v29) then
									return v29;
								end
							end
							if (((2643 - (716 + 1194)) < (32 + 1787)) and v108) then
								v29 = v119.HandleAfflicted(v115.PurifySpirit, v116.PurifySpiritMouseover, 4 + 26);
								if (v29 or ((4898 - (74 + 429)) == (9172 - 4417))) then
									return v29;
								end
								if (v110 or ((1880 + 1913) < (5422 - 3053))) then
									local v240 = 0 + 0;
									while true do
										if (((0 - 0) == v240) or ((10097 - 6013) == (698 - (279 + 154)))) then
											v29 = v119.HandleAfflicted(v115.TremorTotem, v115.TremorTotem, 808 - (454 + 324));
											if (((3429 + 929) == (4375 - (12 + 5))) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if (v111 or ((1692 + 1446) < (2529 - 1536))) then
									local v241 = 0 + 0;
									while true do
										if (((4423 - (277 + 816)) > (9926 - 7603)) and (v241 == (1183 - (1058 + 125)))) then
											v29 = v119.HandleAfflicted(v115.PoisonCleansingTotem, v115.PoisonCleansingTotem, 6 + 24);
											if (v29 or ((4601 - (815 + 160)) == (17115 - 13126))) then
												return v29;
											end
											break;
										end
									end
								end
							end
							v234 = 7 - 4;
						end
						if ((v234 == (1 + 2)) or ((2677 - 1761) == (4569 - (41 + 1857)))) then
							v168 = v123();
							if (((2165 - (1222 + 671)) == (702 - 430)) and v168) then
								return v168;
							end
							if (((6106 - 1857) <= (6021 - (229 + 953))) and (v113 > v107)) then
								v168 = v125();
								if (((4551 - (1111 + 663)) < (4779 - (874 + 705))) and v168) then
									return v168;
								end
							end
							break;
						end
						if (((14 + 81) < (1336 + 621)) and (v234 == (1 - 0))) then
							v29 = v119.Interrupt(v115.WindShear, 1 + 29, true);
							if (((1505 - (642 + 37)) < (392 + 1325)) and v29) then
								return v29;
							end
							v29 = v119.InterruptCursor(v115.WindShear, v116.WindShearMouseover, 5 + 25, true, v16);
							if (((3580 - 2154) >= (1559 - (233 + 221))) and v29) then
								return v29;
							end
							v234 = 4 - 2;
						end
						if (((2424 + 330) <= (4920 - (718 + 823))) and ((0 + 0) == v234)) then
							v114 = v13:GetEnemiesInRange(845 - (266 + 539));
							v112 = v10.BossFightRemains(nil, true);
							v113 = v112;
							if ((v113 == (31457 - 20346)) or ((5152 - (636 + 589)) == (3353 - 1940))) then
								v113 = v10.FightRemains(v114, false);
							end
							v234 = 1 - 0;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((915 + 239) <= (287 + 501))) then
					if (v32 or ((2658 - (657 + 358)) > (8946 - 5567))) then
						if ((v17 and v43) or ((6385 - 3582) > (5736 - (1151 + 36)))) then
							if ((v115.PurifySpirit:IsReady() and v119.DispellableFriendlyUnit(25 + 0)) or ((58 + 162) >= (9024 - 6002))) then
								if (((4654 - (1552 + 280)) == (3656 - (64 + 770))) and v24(v116.PurifySpiritFocus, not v17:IsSpellInRange(v115.PurifySpirit))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					if (((v17:HealthPercentage() < v77) and v17:BuffDown(v115.Riptide)) or ((721 + 340) == (4215 - 2358))) then
						if (((491 + 2269) > (2607 - (157 + 1086))) and v115.PrimordialWaveResto:IsCastable()) then
							if (v24(v116.PrimordialWaveFocus, not v17:IsSpellInRange(v115.PrimordialWaveResto)) or ((9811 - 4909) <= (15745 - 12150))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(61 - 21) and (v119.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v115.EarthShield)) or ((5256 - 1404) == (1112 - (599 + 220)))) then
						if (v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield)) or ((3104 - 1545) == (6519 - (1813 + 118)))) then
							return "earth_shield_tank main fight";
						end
					end
					v168 = v124();
					if (v168 or ((3278 + 1206) == (2005 - (841 + 376)))) then
						return v168;
					end
					if (((6400 - 1832) >= (908 + 2999)) and v33) then
						local v237 = 0 - 0;
						while true do
							if (((2105 - (464 + 395)) < (8905 - 5435)) and (v237 == (1 + 0))) then
								v168 = v127();
								if (((4905 - (467 + 370)) >= (2008 - 1036)) and v168) then
									return v168;
								end
								break;
							end
							if (((362 + 131) < (13345 - 9452)) and (v237 == (0 + 0))) then
								v168 = v126();
								if (v168 or ((3426 - 1953) >= (3852 - (150 + 370)))) then
									return v168;
								end
								v237 = 1283 - (74 + 1208);
							end
						end
					end
					if (v34 or ((9963 - 5912) <= (5487 - 4330))) then
						if (((430 + 174) < (3271 - (14 + 376))) and v119.TargetIsValid()) then
							local v239 = 0 - 0;
							while true do
								if ((v239 == (0 + 0)) or ((791 + 109) == (3221 + 156))) then
									v168 = v128();
									if (((13065 - 8606) > (445 + 146)) and v168) then
										return v168;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if (((3476 - (23 + 55)) >= (5676 - 3281)) and (v167 == (0 + 0))) then
				v129();
				v130();
				v30 = EpicSettings.Toggles['ooc'];
				v167 = 1 + 0;
			end
			if ((v167 == (4 - 1)) or ((687 + 1496) >= (3725 - (652 + 249)))) then
				if (((5180 - 3244) == (3804 - (708 + 1160))) and v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(108 - 68) and (v119.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v115.EarthShield))) then
					if (v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield)) or ((8809 - 3977) < (4340 - (10 + 17)))) then
						return "earth_shield_tank main apl";
					end
				end
				v168 = nil;
				if (((919 + 3169) > (5606 - (1400 + 332))) and not v13:AffectingCombat()) then
					if (((8308 - 3976) == (6240 - (242 + 1666))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v238 = v119.DeadFriendlyUnitsCount();
						if (((1712 + 2287) >= (1063 + 1837)) and (v238 > (1 + 0))) then
							if (v24(v115.AncestralVision, nil, v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3465 - (850 + 90)) > (7117 - 3053))) then
								return "ancestral_vision";
							end
						elseif (((5761 - (360 + 1030)) == (3869 + 502)) and v24(v116.AncestralSpiritMouseover, not v15:IsInRange(112 - 72), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v167 = 5 - 1;
			end
		end
	end
	local function v132()
		local v169 = 1661 - (909 + 752);
		while true do
			if ((v169 == (1223 - (109 + 1114))) or ((486 - 220) > (1941 + 3045))) then
				v121();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(506 - (6 + 236), v131, v132);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

