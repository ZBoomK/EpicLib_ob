local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4523 - (692 + 120)) > (2578 + 777)) and not v5) then
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
	local v111 = 1826 + 9285;
	local v112 = 2397 + 8714;
	local v113;
	v9:RegisterForEvent(function()
		v111 = 30910 - 19799;
		v112 = 37052 - 25941;
	end, "PLAYER_REGEN_ENABLED");
	local v114 = v17.Shaman.Restoration;
	local v115 = v24.Shaman.Restoration;
	local v116 = v19.Shaman.Restoration;
	local v117 = {};
	local v118 = v21.Commons.Everyone;
	local v119 = v21.Commons.Shaman;
	local function v120()
		if (v114.ImprovedPurifySpirit:IsAvailable() or ((325 + 581) >= (908 + 1321))) then
			v118.DispellableDebuffs = v20.MergeTable(v118.DispellableMagicDebuffs, v118.DispellableCurseDebuffs);
		else
			v118.DispellableDebuffs = v118.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v120();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v121(v132)
		return v132:DebuffRefreshable(v114.FlameShockDebuff) and (v112 > (5 + 0));
	end
	local function v122()
		local v133 = 0 + 0;
		while true do
			if (((602 + 686) > (2684 - (797 + 636))) and (v133 == (4 - 3))) then
				if ((v116.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((6132 - (1427 + 192)) < (1162 + 2190))) then
					if (v23(v115.Healthstone) or ((4794 - 2729) >= (2873 + 323))) then
						return "healthstone defensive 3";
					end
				end
				if ((v37 and (v12:HealthPercentage() <= v38)) or ((1984 + 2392) <= (1807 - (192 + 134)))) then
					if ((v39 == "Refreshing Healing Potion") or ((4668 - (316 + 960)) >= (2639 + 2102))) then
						if (((2566 + 759) >= (1991 + 163)) and v116.RefreshingHealingPotion:IsReady()) then
							if (v23(v115.RefreshingHealingPotion) or ((4950 - 3655) >= (3784 - (83 + 468)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((6183 - (1202 + 604)) > (7665 - 6023)) and (v39 == "Dreamwalker's Healing Potion")) then
						if (((7859 - 3136) > (3754 - 2398)) and v116.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v115.RefreshingHealingPotion) or ((4461 - (45 + 280)) <= (3314 + 119))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((3709 + 536) <= (1691 + 2940)) and (v133 == (0 + 0))) then
				if (((753 + 3523) >= (7247 - 3333)) and v87 and v114.AstralShift:IsReady()) then
					if (((2109 - (340 + 1571)) <= (1722 + 2643)) and (v12:HealthPercentage() <= v53)) then
						if (((6554 - (1733 + 39)) > (12849 - 8173)) and v23(v114.AstralShift, not v14:IsInRange(1074 - (125 + 909)))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((6812 - (1096 + 852)) > (986 + 1211)) and v90 and v114.EarthElemental:IsReady()) then
					if ((v12:HealthPercentage() <= v61) or v118.IsTankBelowHealthPercentage(v62) or ((5283 - 1583) == (2432 + 75))) then
						if (((4986 - (409 + 103)) >= (510 - (46 + 190))) and v23(v114.EarthElemental, not v14:IsInRange(135 - (51 + 44)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v123()
		if (v40 or ((3211 - (1114 + 203)) <= (2132 - (228 + 498)))) then
			local v196 = 0 + 0;
			while true do
				if (((869 + 703) >= (2194 - (174 + 489))) and (v196 == (0 - 0))) then
					v28 = v118.HandleCharredTreant(v114.Riptide, v115.RiptideMouseover, 1945 - (830 + 1075));
					if (v28 or ((5211 - (303 + 221)) < (5811 - (231 + 1038)))) then
						return v28;
					end
					v196 = 1 + 0;
				end
				if (((4453 - (171 + 991)) > (6870 - 5203)) and (v196 == (2 - 1))) then
					v28 = v118.HandleCharredTreant(v114.HealingSurge, v115.HealingSurgeMouseover, 99 - 59);
					if (v28 or ((699 + 174) == (7129 - 5095))) then
						return v28;
					end
					v196 = 5 - 3;
				end
				if ((v196 == (2 - 0)) or ((8704 - 5888) < (1259 - (111 + 1137)))) then
					v28 = v118.HandleCharredTreant(v114.HealingWave, v115.HealingWaveMouseover, 198 - (91 + 67));
					if (((11009 - 7310) < (1175 + 3531)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((3169 - (423 + 100)) >= (7 + 869)) and v41) then
			v28 = v118.HandleCharredBrambles(v114.Riptide, v115.RiptideMouseover, 110 - 70);
			if (((321 + 293) <= (3955 - (326 + 445))) and v28) then
				return v28;
			end
			v28 = v118.HandleCharredBrambles(v114.HealingSurge, v115.HealingSurgeMouseover, 174 - 134);
			if (((6963 - 3837) == (7296 - 4170)) and v28) then
				return v28;
			end
			v28 = v118.HandleCharredBrambles(v114.HealingWave, v115.HealingWaveMouseover, 751 - (530 + 181));
			if (v28 or ((3068 - (614 + 267)) >= (4986 - (19 + 13)))) then
				return v28;
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (0 - 0)) or ((11075 - 7198) == (929 + 2646))) then
				if (((1243 - 536) > (1310 - 678)) and v105 and ((v30 and v104) or not v104)) then
					v28 = v118.HandleTopTrinket(v117, v30, 1852 - (1293 + 519), nil);
					if (v28 or ((1113 - 567) >= (7007 - 4323))) then
						return v28;
					end
					v28 = v118.HandleBottomTrinket(v117, v30, 76 - 36, nil);
					if (((6317 - 4852) <= (10131 - 5830)) and v28) then
						return v28;
					end
				end
				if (((903 + 801) > (291 + 1134)) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
					if ((v16:HealthPercentage() <= v77) or ((1596 - 909) == (979 + 3255))) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((1107 + 2223) < (894 + 535))) then
							return "riptide healingcd";
						end
					end
				end
				v134 = 1097 - (709 + 387);
			end
			if (((3005 - (673 + 1185)) >= (971 - 636)) and (v134 == (9 - 6))) then
				if (((5651 - 2216) > (1500 + 597)) and v85 and v118.AreUnitsBelowHealthPercentage(v47, v46) and v114.AncestralGuidance:IsReady()) then
					if (v23(v114.AncestralGuidance, not v14:IsInRange(30 + 10)) or ((5090 - 1320) >= (993 + 3048))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v86 and v118.AreUnitsBelowHealthPercentage(v52, v51) and v114.Ascendance:IsReady()) or ((7558 - 3767) <= (3162 - 1551))) then
					if (v23(v114.Ascendance, not v14:IsInRange(1920 - (446 + 1434))) or ((5861 - (1040 + 243)) <= (5993 - 3985))) then
						return "ascendance cooldowns";
					end
				end
				v134 = 1851 - (559 + 1288);
			end
			if (((3056 - (609 + 1322)) <= (2530 - (13 + 441))) and (v134 == (3 - 2))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((1946 - 1203) >= (21908 - 17509))) then
					if (((44 + 1111) < (6075 - 4402)) and (v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((826 + 1498) <= (254 + 324))) then
							return "riptide healingcd";
						end
					end
				end
				if (((11178 - 7411) == (2062 + 1705)) and v118.AreUnitsBelowHealthPercentage(v80, v79) and v114.SpiritLinkTotem:IsReady()) then
					if (((7520 - 3431) == (2704 + 1385)) and (v81 == "Player")) then
						if (((2480 + 1978) >= (1203 + 471)) and v23(v115.SpiritLinkTotemPlayer, not v14:IsInRange(34 + 6))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((951 + 21) <= (1851 - (153 + 280))) and (v81 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((14258 - 9320) < (4276 + 486))) then
							if (v23(v115.SpiritLinkTotemCursor, not v14:IsInRange(16 + 24)) or ((1311 + 1193) > (3870 + 394))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((1561 + 592) == (3278 - 1125)) and (v81 == "Confirmation")) then
						if (v23(v114.SpiritLinkTotem, not v14:IsInRange(25 + 15)) or ((1174 - (89 + 578)) >= (1851 + 740))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v134 = 3 - 1;
			end
			if (((5530 - (572 + 477)) == (605 + 3876)) and (v134 == (3 + 1))) then
				if ((v96 and (v12:Mana() <= v75) and v114.ManaTideTotem:IsReady()) or ((278 + 2050) < (779 - (84 + 2)))) then
					if (((7132 - 2804) == (3118 + 1210)) and v23(v114.ManaTideTotem, not v14:IsInRange(882 - (497 + 345)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((41 + 1547) >= (226 + 1106)) and v34 and ((v103 and v30) or not v103)) then
					local v230 = 1333 - (605 + 728);
					while true do
						if ((v230 == (1 + 0)) or ((9279 - 5105) > (195 + 4053))) then
							if (v114.Berserking:IsReady() or ((16955 - 12369) <= (74 + 8))) then
								if (((10702 - 6839) == (2917 + 946)) and v23(v114.Berserking, not v14:IsInRange(529 - (457 + 32)))) then
									return "Berserking cooldowns";
								end
							end
							if (v114.BloodFury:IsReady() or ((120 + 162) <= (1444 - (832 + 570)))) then
								if (((4343 + 266) >= (200 + 566)) and v23(v114.BloodFury, not v14:IsInRange(141 - 101))) then
									return "BloodFury cooldowns";
								end
							end
							v230 = 1 + 1;
						end
						if (((796 - (588 + 208)) == v230) or ((3104 - 1952) == (4288 - (884 + 916)))) then
							if (((7163 - 3741) > (1943 + 1407)) and v114.AncestralCall:IsReady()) then
								if (((1530 - (232 + 421)) > (2265 - (1569 + 320))) and v23(v114.AncestralCall, not v14:IsInRange(10 + 30))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v114.BagofTricks:IsReady() or ((593 + 2525) <= (6237 - 4386))) then
								if (v23(v114.BagofTricks, not v14:IsInRange(645 - (316 + 289))) or ((431 - 266) >= (162 + 3330))) then
									return "BagofTricks cooldowns";
								end
							end
							v230 = 1454 - (666 + 787);
						end
						if (((4374 - (360 + 65)) < (4539 + 317)) and (v230 == (256 - (79 + 175)))) then
							if (v114.Fireblood:IsReady() or ((6742 - 2466) < (2354 + 662))) then
								if (((14376 - 9686) > (7944 - 3819)) and v23(v114.Fireblood, not v14:IsInRange(939 - (503 + 396)))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v134 == (183 - (92 + 89))) or ((96 - 46) >= (460 + 436))) then
				if ((v94 and v118.AreUnitsBelowHealthPercentage(v73, v72) and v114.HealingTideTotem:IsReady()) or ((1015 + 699) >= (11583 - 8625))) then
					if (v23(v114.HealingTideTotem, not v14:IsInRange(6 + 34)) or ((3399 - 1908) < (562 + 82))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((337 + 367) < (3006 - 2019)) and v118.AreUnitsBelowHealthPercentage(v49, v48) and v114.AncestralProtectionTotem:IsReady()) then
					if (((465 + 3253) > (2906 - 1000)) and (v50 == "Player")) then
						if (v23(v115.AncestralProtectionTotemPlayer, not v14:IsInRange(1284 - (485 + 759))) or ((2216 - 1258) > (4824 - (442 + 747)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((4636 - (832 + 303)) <= (5438 - (88 + 858))) and (v50 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((1050 + 2392) < (2109 + 439))) then
							if (((119 + 2756) >= (2253 - (766 + 23))) and v23(v115.AncestralProtectionTotemCursor, not v14:IsInRange(197 - 157))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v50 == "Confirmation") or ((6560 - 1763) >= (12891 - 7998))) then
						if (v23(v114.AncestralProtectionTotem, not v14:IsInRange(135 - 95)) or ((1624 - (1036 + 37)) > (1467 + 601))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v134 = 5 - 2;
			end
		end
	end
	local function v125()
		local v135 = 0 + 0;
		while true do
			if (((3594 - (641 + 839)) > (1857 - (910 + 3))) and (v135 == (4 - 2))) then
				if ((v118.AreUnitsBelowHealthPercentage(v67, v66) and v114.HealingRain:IsReady()) or ((3946 - (1466 + 218)) >= (1423 + 1673))) then
					if ((v68 == "Player") or ((3403 - (556 + 592)) >= (1258 + 2279))) then
						if (v23(v115.HealingRainPlayer, not v14:IsInRange(848 - (329 + 479)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((4691 - (174 + 680)) < (4487 - 3181))) then
							return "healing_rain healingaoe";
						end
					elseif (((6114 - 3164) == (2107 + 843)) and (v68 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((5462 - (396 + 343)) < (292 + 3006))) then
							if (((2613 - (29 + 1448)) >= (1543 - (135 + 1254))) and v23(v115.HealingRainCursor, not v14:IsInRange(150 - 110), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v68 == "Enemy under Cursor") or ((1265 - 994) > (3165 + 1583))) then
						if (((6267 - (389 + 1138)) >= (3726 - (102 + 472))) and v15:Exists() and v12:CanAttack(v15)) then
							if (v23(v115.HealingRainCursor, not v14:IsInRange(38 + 2), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((1430 + 1148) >= (3161 + 229))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((1586 - (320 + 1225)) <= (2956 - 1295)) and (v68 == "Confirmation")) then
						if (((368 + 233) < (5024 - (157 + 1307))) and v23(v114.HealingRain, not v14:IsInRange(1899 - (821 + 1038)), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((586 - 351) < (76 + 611)) and v118.AreUnitsBelowHealthPercentage(v64, v63) and v114.EarthenWallTotem:IsReady()) then
					if (((8079 - 3530) > (429 + 724)) and (v65 == "Player")) then
						if (v23(v115.EarthenWallTotemPlayer, not v14:IsInRange(99 - 59)) or ((5700 - (834 + 192)) < (298 + 4374))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((942 + 2726) < (98 + 4463)) and (v65 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((704 - 249) == (3909 - (300 + 4)))) then
							if (v23(v115.EarthenWallTotemCursor, not v14:IsInRange(11 + 29)) or ((6971 - 4308) == (3674 - (112 + 250)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((1705 + 2572) <= (11211 - 6736)) and (v65 == "Confirmation")) then
						if (v23(v114.EarthenWallTotem, not v14:IsInRange(23 + 17)) or ((450 + 420) == (890 + 299))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((771 + 782) <= (2328 + 805)) and v118.AreUnitsBelowHealthPercentage(v59, v58) and v114.Downpour:IsReady()) then
					if ((v60 == "Player") or ((3651 - (1001 + 413)) >= (7829 - 4318))) then
						if (v23(v115.DownpourPlayer, not v14:IsInRange(922 - (244 + 638)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2017 - (627 + 66)) > (8998 - 5978))) then
							return "downpour healingaoe";
						end
					elseif ((v60 == "Friendly under Cursor") or ((3594 - (512 + 90)) == (3787 - (1665 + 241)))) then
						if (((3823 - (373 + 344)) > (689 + 837)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((800 + 2223) < (10207 - 6337)) and v23(v115.DownpourCursor, not v14:IsInRange(67 - 27), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((1242 - (35 + 1064)) > (54 + 20)) and (v60 == "Confirmation")) then
						if (((38 - 20) < (9 + 2103)) and v23(v114.Downpour, not v14:IsInRange(1276 - (298 + 938)), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				v135 = 1262 - (233 + 1026);
			end
			if (((2763 - (636 + 1030)) <= (833 + 795)) and ((4 + 0) == v135)) then
				if (((1376 + 3254) == (313 + 4317)) and v98 and v12:IsMoving() and v118.AreUnitsBelowHealthPercentage(v83, v82) and v114.SpiritwalkersGrace:IsReady()) then
					if (((3761 - (55 + 166)) > (520 + 2163)) and v23(v114.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((483 + 4311) >= (12507 - 9232)) and v92 and v118.AreUnitsBelowHealthPercentage(v70, v69) and v114.HealingStreamTotem:IsReady()) then
					if (((1781 - (36 + 261)) == (2595 - 1111)) and v23(v114.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((2800 - (34 + 1334)) < (1367 + 2188)) and (v135 == (3 + 0))) then
				if ((v89 and v118.AreUnitsBelowHealthPercentage(v57, v56) and v114.CloudburstTotem:IsReady()) or ((2348 - (1035 + 248)) > (3599 - (20 + 1)))) then
					if (v23(v114.CloudburstTotem) or ((2499 + 2296) < (1726 - (134 + 185)))) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((2986 - (549 + 584)) < (5498 - (314 + 371))) and v100 and v118.AreUnitsBelowHealthPercentage(v102, v101) and v114.Wellspring:IsReady()) then
					if (v23(v114.Wellspring, not v14:IsInRange(137 - 97), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3789 - (478 + 490)) < (1288 + 1143))) then
						return "wellspring healingaoe";
					end
				end
				if ((v88 and v118.AreUnitsBelowHealthPercentage(v55, v54) and v114.ChainHeal:IsReady()) or ((4046 - (786 + 386)) < (7064 - 4883))) then
					if (v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((4068 - (1055 + 324)) <= (1683 - (1093 + 247)))) then
						return "chain_heal healingaoe";
					end
				end
				v135 = 4 + 0;
			end
			if ((v135 == (1 + 0)) or ((7420 - 5551) == (6817 - 4808))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((10090 - 6544) < (5834 - 3512))) then
					if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((741 + 1341) == (18387 - 13614))) then
						if (((11181 - 7937) > (796 + 259)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v99 and v114.UnleashLife:IsReady()) or ((8472 - 5159) <= (2466 - (364 + 324)))) then
					if ((v16:HealthPercentage() <= v84) or ((3895 - 2474) >= (5048 - 2944))) then
						if (((601 + 1211) <= (13594 - 10345)) and v23(v114.UnleashLife, not v16:IsSpellInRange(v114.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((2599 - 976) <= (5943 - 3986)) and (v68 == "Cursor") and v114.HealingRain:IsReady()) then
					if (((5680 - (1249 + 19)) == (3983 + 429)) and v23(v115.HealingRainCursor, not v14:IsInRange(155 - 115), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v135 = 1088 - (686 + 400);
			end
			if (((1374 + 376) >= (1071 - (73 + 156))) and ((0 + 0) == v135)) then
				if (((5183 - (721 + 90)) > (21 + 1829)) and v88 and v118.AreUnitsBelowHealthPercentage(308 - 213, 473 - (224 + 246)) and v114.ChainHeal:IsReady() and v12:BuffUp(v114.HighTide)) then
					if (((375 - 143) < (1511 - 690)) and v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((94 + 424) < (22 + 880)) and v95 and (v16:HealthPercentage() <= v74) and v114.HealingWave:IsReady() and (v114.PrimordialWave:TimeSinceLastCast() < (12 + 3))) then
					if (((5952 - 2958) > (2855 - 1997)) and v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((4268 - (203 + 310)) <= (2908 - (1238 + 755)))) then
					if (((276 + 3670) > (5277 - (709 + 825))) and (v16:HealthPercentage() <= v77)) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((2459 - 1124) >= (4815 - 1509))) then
							return "riptide healingaoe";
						end
					end
				end
				v135 = 865 - (196 + 668);
			end
		end
	end
	local function v126()
		local v136 = 0 - 0;
		while true do
			if (((10033 - 5189) > (3086 - (171 + 662))) and (v136 == (94 - (4 + 89)))) then
				if (((1584 - 1132) == (165 + 287)) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
					if ((v16:HealthPercentage() <= v77) or (v16:HealthPercentage() <= v77) or ((20015 - 15458) < (819 + 1268))) then
						if (((5360 - (35 + 1451)) == (5327 - (28 + 1425))) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v114.ElementalOrbit:IsAvailable() and v12:BuffDown(v114.EarthShieldBuff)) or ((3931 - (941 + 1052)) > (4732 + 203))) then
					if (v23(v114.EarthShield) or ((5769 - (822 + 692)) < (4886 - 1463))) then
						return "earth_shield healingst";
					end
				end
				v136 = 1 + 1;
			end
			if (((1751 - (45 + 252)) <= (2465 + 26)) and (v136 == (0 + 0))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((10116 - 5959) <= (3236 - (114 + 319)))) then
					if (((6967 - 2114) >= (3820 - 838)) and (v16:HealthPercentage() <= v77)) then
						if (((2636 + 1498) > (5000 - 1643)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((7159 - 3742) < (4497 - (556 + 1407)))) then
					if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((3928 - (741 + 465)) <= (629 - (170 + 295)))) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((1269 + 1139) < (1938 + 171))) then
							return "riptide healingaoe";
						end
					end
				end
				v136 = 2 - 1;
			end
			if ((v136 == (3 + 0)) or ((22 + 11) == (824 + 631))) then
				if ((v95 and v114.HealingWave:IsReady()) or ((1673 - (957 + 273)) >= (1074 + 2941))) then
					if (((1354 + 2028) > (632 - 466)) and (v16:HealthPercentage() <= v74)) then
						if (v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((737 - 457) == (9343 - 6284))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((9314 - 7433) > (3073 - (389 + 1391))) and (v136 == (2 + 0))) then
				if (((246 + 2111) == (5365 - 3008)) and v114.ElementalOrbit:IsAvailable() and v12:BuffUp(v114.EarthShieldBuff)) then
					if (((1074 - (783 + 168)) == (412 - 289)) and v118.IsSoloMode()) then
						if ((v114.LightningShield:IsReady() and v12:BuffDown(v114.LightningShield)) or ((1039 + 17) >= (3703 - (309 + 2)))) then
							if (v23(v114.LightningShield) or ((3319 - 2238) < (2287 - (1090 + 122)))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v114.WaterShield:IsReady() and v12:BuffDown(v114.WaterShield)) or ((341 + 708) >= (14884 - 10452))) then
						if (v23(v114.WaterShield) or ((3264 + 1504) <= (1964 - (628 + 490)))) then
							return "water_shield healingst";
						end
					end
				end
				if ((v93 and v114.HealingSurge:IsReady()) or ((603 + 2755) <= (3515 - 2095))) then
					if ((v16:HealthPercentage() <= v71) or ((17087 - 13348) <= (3779 - (431 + 343)))) then
						if (v23(v115.HealingSurgeFocus, not v16:IsSpellInRange(v114.HealingSurge), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3350 - 1691) >= (6173 - 4039))) then
							return "healing_surge healingst";
						end
					end
				end
				v136 = 3 + 0;
			end
		end
	end
	local function v127()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (1696 - (556 + 1139))) or ((3275 - (6 + 9)) < (432 + 1923))) then
				if (v114.Stormkeeper:IsReady() or ((343 + 326) == (4392 - (28 + 141)))) then
					if (v23(v114.Stormkeeper, not v14:IsInRange(16 + 24)) or ((2088 - 396) < (417 + 171))) then
						return "stormkeeper damage";
					end
				end
				if ((#v12:GetEnemiesInRange(1357 - (486 + 831)) < (7 - 4)) or ((16888 - 12091) < (690 + 2961))) then
					if (v114.LightningBolt:IsReady() or ((13207 - 9030) > (6113 - (668 + 595)))) then
						if (v23(v114.LightningBolt, not v14:IsSpellInRange(v114.LightningBolt), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((360 + 40) > (225 + 886))) then
							return "lightning_bolt damage";
						end
					end
				elseif (((8320 - 5269) > (1295 - (23 + 267))) and v114.ChainLightning:IsReady()) then
					if (((5637 - (1129 + 815)) <= (4769 - (371 + 16))) and v23(v114.ChainLightning, not v14:IsSpellInRange(v114.ChainLightning), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
			if ((v137 == (1750 - (1326 + 424))) or ((6215 - 2933) > (14982 - 10882))) then
				if (v114.FlameShock:IsReady() or ((3698 - (88 + 30)) < (3615 - (720 + 51)))) then
					if (((197 - 108) < (6266 - (421 + 1355))) and v118.CastCycle(v114.FlameShock, v12:GetEnemiesInRange(65 - 25), v121, not v14:IsSpellInRange(v114.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (v23(v114.FlameShock, not v14:IsSpellInRange(v114.FlameShock)) or ((2448 + 2535) < (2891 - (286 + 797)))) then
						return "flame_shock damage";
					end
				end
				if (((13997 - 10168) > (6242 - 2473)) and v114.LavaBurst:IsReady()) then
					if (((1924 - (397 + 42)) <= (907 + 1997)) and v23(v114.LavaBurst, not v14:IsSpellInRange(v114.LavaBurst), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v137 = 801 - (24 + 776);
			end
		end
	end
	local function v128()
		v48 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v49 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v50 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v54 = EpicSettings.Settings['ChainHealGroup'];
		v55 = EpicSettings.Settings['ChainHealHP'];
		v42 = EpicSettings.Settings['DispelDebuffs'];
		v58 = EpicSettings.Settings['DownpourGroup'];
		v59 = EpicSettings.Settings['DownpourHP'];
		v60 = EpicSettings.Settings['DownpourUsage'];
		v63 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v64 = EpicSettings.Settings['EarthenWallTotemHP'];
		v65 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v41 = EpicSettings.Settings['HandleCharredBrambles'];
		v40 = EpicSettings.Settings['HandleCharredTreant'];
		v38 = EpicSettings.Settings['HealingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v66 = EpicSettings.Settings['HealingRainGroup'];
		v67 = EpicSettings.Settings['HealingRainHP'];
		v68 = EpicSettings.Settings['HealingRainUsage'];
		v69 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v70 = EpicSettings.Settings['HealingStreamTotemHP'];
		v71 = EpicSettings.Settings['HealingSurgeHP'];
		v72 = EpicSettings.Settings['HealingTideTotemGroup'];
		v73 = EpicSettings.Settings['HealingTideTotemHP'];
		v74 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v77 = EpicSettings.Settings['RiptideHP'];
		v78 = EpicSettings.Settings['RiptideTankHP'];
		v79 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v80 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v81 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v82 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v83 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v84 = EpicSettings.Settings['UnleashLifeHP'];
		v88 = EpicSettings.Settings['UseChainHeal'];
		v89 = EpicSettings.Settings['UseCloudburstTotem'];
		v91 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v92 = EpicSettings.Settings['UseHealingStreamTotem'];
		v93 = EpicSettings.Settings['UseHealingSurge'];
		v94 = EpicSettings.Settings['UseHealingTideTotem'];
		v95 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v97 = EpicSettings.Settings['UseRiptide'];
		v98 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v99 = EpicSettings.Settings['UseUnleashLife'];
		v109 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v110 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v129()
		local v189 = 0 - 0;
		while true do
			if (((5054 - (222 + 563)) == (9405 - 5136)) and (v189 == (0 + 0))) then
				v46 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v47 = EpicSettings.Settings['AncestralGuidanceHP'];
				v51 = EpicSettings.Settings['AscendanceGroup'];
				v189 = 191 - (23 + 167);
			end
			if (((2185 - (690 + 1108)) <= (1004 + 1778)) and (v189 == (3 + 0))) then
				v75 = EpicSettings.Settings['ManaTideTotemMana'];
				v76 = EpicSettings.Settings['PrimordialWaveHP'];
				v85 = EpicSettings.Settings['UseAncestralGuidance'];
				v189 = 852 - (40 + 808);
			end
			if ((v189 == (2 + 5)) or ((7261 - 5362) <= (877 + 40))) then
				v104 = EpicSettings.Settings['trinketsWithCD'];
				v105 = EpicSettings.Settings['useTrinkets'];
				v106 = EpicSettings.Settings['fightRemainsCheck'];
				v189 = 5 + 3;
			end
			if ((v189 == (4 + 2)) or ((4883 - (47 + 524)) <= (569 + 307))) then
				v101 = EpicSettings.Settings['WellspringGroup'];
				v102 = EpicSettings.Settings['WellspringHP'];
				v103 = EpicSettings.Settings['racialsWithCD'];
				v189 = 19 - 12;
			end
			if (((3336 - 1104) <= (5920 - 3324)) and (v189 == (1731 - (1165 + 561)))) then
				v96 = EpicSettings.Settings['UseManaTideTotem'];
				v34 = EpicSettings.Settings['UseRacials'];
				v100 = EpicSettings.Settings['UseWellspring'];
				v189 = 1 + 5;
			end
			if (((6488 - 4393) < (1407 + 2279)) and (v189 == (488 - (341 + 138)))) then
				v110 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v189 == (2 + 2)) or ((3291 - 1696) >= (4800 - (89 + 237)))) then
				v86 = EpicSettings.Settings['UseAscendance'];
				v87 = EpicSettings.Settings['UseAstralShift'];
				v90 = EpicSettings.Settings['UseEarthElemental'];
				v189 = 16 - 11;
			end
			if ((v189 == (3 - 1)) or ((5500 - (581 + 300)) < (4102 - (855 + 365)))) then
				v57 = EpicSettings.Settings['CloudburstTotemHP'];
				v61 = EpicSettings.Settings['EarthElementalHP'];
				v62 = EpicSettings.Settings['EarthElementalTankHP'];
				v189 = 6 - 3;
			end
			if ((v189 == (3 + 5)) or ((1529 - (1030 + 205)) >= (4536 + 295))) then
				v107 = EpicSettings.Settings['handleAfflicted'];
				v108 = EpicSettings.Settings['HandleIncorporeal'];
				v109 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v189 = 9 + 0;
			end
			if (((2315 - (156 + 130)) <= (7007 - 3923)) and (v189 == (1 - 0))) then
				v52 = EpicSettings.Settings['AscendanceHP'];
				v53 = EpicSettings.Settings['AstralShiftHP'];
				v56 = EpicSettings.Settings['CloudburstTotemGroup'];
				v189 = 3 - 1;
			end
		end
	end
	local function v130()
		local v190 = 0 + 0;
		local v191;
		while true do
			if ((v190 == (0 + 0)) or ((2106 - (10 + 59)) == (685 + 1735))) then
				v128();
				v129();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v190 = 4 - 3;
			end
			if (((5621 - (671 + 492)) > (3108 + 796)) and (v190 == (1216 - (369 + 846)))) then
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v33 = EpicSettings.Toggles['dps'];
				if (((116 + 320) >= (105 + 18)) and v12:IsDeadOrGhost()) then
					return;
				end
				v190 = 1947 - (1036 + 909);
			end
			if (((398 + 102) < (3048 - 1232)) and ((205 - (11 + 192)) == v190)) then
				if (((1807 + 1767) == (3749 - (135 + 40))) and (v12:AffectingCombat() or v29)) then
					local v231 = 0 - 0;
					local v232;
					while true do
						if (((134 + 87) < (859 - 469)) and (v231 == (0 - 0))) then
							v232 = v42 and v114.PurifySpirit:IsReady() and v31;
							if ((v114.EarthShield:IsReady() and v91 and (v118.FriendlyUnitsWithBuffCount(v114.EarthShield, true) < (177 - (50 + 126)))) or ((6162 - 3949) <= (315 + 1106))) then
								v28 = v118.FocusUnitRefreshableBuff(v114.EarthShield, 1428 - (1233 + 180), 1009 - (522 + 447), "TANK");
								if (((4479 - (107 + 1314)) < (2256 + 2604)) and v28) then
									return v28;
								end
								if ((v118.UnitGroupRole(v16) == "TANK") or ((3948 - 2652) >= (1889 + 2557))) then
									if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((2766 - 1373) > (17761 - 13272))) then
										return "earth_shield_tank main apl";
									end
								end
							end
							v231 = 1911 - (716 + 1194);
						end
						if ((v231 == (1 + 0)) or ((474 + 3950) < (530 - (74 + 429)))) then
							if (not v16:BuffDown(v114.EarthShield) or (v118.UnitGroupRole(v16) ~= "TANK") or not v91 or ((3852 - 1855) > (1891 + 1924))) then
								v28 = v118.FocusUnit(v232, nil, nil, nil);
								if (((7931 - 4466) > (1354 + 559)) and v28) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if (((2259 - 1526) < (4497 - 2678)) and v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(473 - (279 + 154)) and (v118.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v114.EarthShield))) then
					if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((5173 - (454 + 324)) == (3742 + 1013))) then
						return "earth_shield_tank main apl";
					end
				end
				v191 = nil;
				if (not v12:AffectingCombat() or ((3810 - (12 + 5)) < (1278 + 1091))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((10406 - 6322) == (98 + 167))) then
						local v234 = v118.DeadFriendlyUnitsCount();
						if (((5451 - (277 + 816)) == (18622 - 14264)) and (v234 > (1184 - (1058 + 125)))) then
							if (v23(v114.AncestralVision, nil, v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((589 + 2549) < (1968 - (815 + 160)))) then
								return "ancestral_vision";
							end
						elseif (((14287 - 10957) > (5514 - 3191)) and v23(v115.AncestralSpiritMouseover, not v14:IsInRange(10 + 30), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v190 = 8 - 5;
			end
			if ((v190 == (1901 - (41 + 1857))) or ((5519 - (1222 + 671)) == (10309 - 6320))) then
				if ((v12:AffectingCombat() and v118.TargetIsValid()) or ((1315 - 399) == (3853 - (229 + 953)))) then
					v113 = v12:GetEnemiesInRange(1814 - (1111 + 663));
					v111 = v9.BossFightRemains(nil, true);
					v112 = v111;
					if (((1851 - (874 + 705)) == (39 + 233)) and (v112 == (7581 + 3530))) then
						v112 = v9.FightRemains(v113, false);
					end
					v28 = v118.Interrupt(v114.WindShear, 62 - 32, true);
					if (((120 + 4129) <= (5518 - (642 + 37))) and v28) then
						return v28;
					end
					v28 = v118.InterruptCursor(v114.WindShear, v115.WindShearMouseover, 7 + 23, true, v15);
					if (((445 + 2332) < (8034 - 4834)) and v28) then
						return v28;
					end
					v28 = v118.InterruptWithStunCursor(v114.CapacitorTotem, v115.CapacitorTotemCursor, 484 - (233 + 221), nil, v15);
					if (((219 - 124) < (1723 + 234)) and v28) then
						return v28;
					end
					if (((2367 - (718 + 823)) < (1081 + 636)) and v108) then
						v28 = v118.HandleIncorporeal(v114.Hex, v115.HexMouseOver, 835 - (266 + 539), true);
						if (((4036 - 2610) >= (2330 - (636 + 589))) and v28) then
							return v28;
						end
					end
					if (((6536 - 3782) <= (6968 - 3589)) and v107) then
						local v235 = 0 + 0;
						while true do
							if ((v235 == (1 + 0)) or ((4942 - (657 + 358)) == (3741 - 2328))) then
								if (v109 or ((2628 - 1474) <= (1975 - (1151 + 36)))) then
									v28 = v118.HandleAfflicted(v114.TremorTotem, v114.TremorTotem, 29 + 1);
									if (v28 or ((432 + 1211) > (10091 - 6712))) then
										return v28;
									end
								end
								if (v110 or ((4635 - (1552 + 280)) > (5383 - (64 + 770)))) then
									local v237 = 0 + 0;
									while true do
										if (((0 - 0) == v237) or ((40 + 180) >= (4265 - (157 + 1086)))) then
											v28 = v118.HandleAfflicted(v114.PoisonCleansingTotem, v114.PoisonCleansingTotem, 60 - 30);
											if (((12359 - 9537) == (4328 - 1506)) and v28) then
												return v28;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v235 == (0 - 0)) or ((1880 - (599 + 220)) == (3697 - 1840))) then
								v28 = v118.HandleAfflicted(v114.PurifySpirit, v115.PurifySpiritMouseover, 1961 - (1813 + 118));
								if (((2018 + 742) > (2581 - (841 + 376))) and v28) then
									return v28;
								end
								v235 = 1 - 0;
							end
						end
					end
					v191 = v122();
					if (v191 or ((1139 + 3763) <= (9812 - 6217))) then
						return v191;
					end
					if ((v112 > v106) or ((4711 - (464 + 395)) == (751 - 458))) then
						local v236 = 0 + 0;
						while true do
							if ((v236 == (837 - (467 + 370))) or ((3221 - 1662) == (3368 + 1220))) then
								v191 = v124();
								if (v191 or ((15371 - 10887) == (123 + 665))) then
									return v191;
								end
								break;
							end
						end
					end
				end
				if (((10627 - 6059) >= (4427 - (150 + 370))) and (v29 or v12:AffectingCombat())) then
					local v233 = 1282 - (74 + 1208);
					while true do
						if (((3064 - 1818) < (16456 - 12986)) and (v233 == (2 + 0))) then
							if (((4458 - (14 + 376)) >= (1685 - 713)) and v191) then
								return v191;
							end
							if (((320 + 173) < (3420 + 473)) and v32) then
								v191 = v125();
								if (v191 or ((1405 + 68) >= (9763 - 6431))) then
									return v191;
								end
								v191 = v126();
								if (v191 or ((3048 + 1003) <= (1235 - (23 + 55)))) then
									return v191;
								end
							end
							v233 = 6 - 3;
						end
						if (((404 + 200) < (2588 + 293)) and ((4 - 1) == v233)) then
							if (v33 or ((284 + 616) == (4278 - (652 + 249)))) then
								if (((11932 - 7473) > (2459 - (708 + 1160))) and v118.TargetIsValid()) then
									local v238 = 0 - 0;
									while true do
										if (((6195 - 2797) >= (2422 - (10 + 17))) and (v238 == (0 + 0))) then
											v191 = v127();
											if (v191 or ((3915 - (1400 + 332)) >= (5416 - 2592))) then
												return v191;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((3844 - (242 + 1666)) == (829 + 1107)) and (v233 == (0 + 0))) then
							if (v31 or ((4119 + 713) < (5253 - (850 + 90)))) then
								if (((7159 - 3071) > (5264 - (360 + 1030))) and v16 and v42) then
									if (((3834 + 498) == (12226 - 7894)) and v114.PurifySpirit:IsReady() and v118.DispellableFriendlyUnit(33 - 8)) then
										if (((5660 - (909 + 752)) >= (4123 - (109 + 1114))) and v23(v115.PurifySpiritFocus, not v16:IsSpellInRange(v114.PurifySpirit))) then
											return "purify_spirit dispel";
										end
									end
								end
							end
							if (((v16:HealthPercentage() < v76) and v16:BuffDown(v114.Riptide)) or ((4622 - 2097) > (1582 + 2482))) then
								if (((4613 - (6 + 236)) == (2754 + 1617)) and v114.PrimordialWave:IsCastable()) then
									if (v23(v115.PrimordialWaveFocus, not v16:IsSpellInRange(v114.PrimordialWave)) or ((215 + 51) > (11758 - 6772))) then
										return "primordial_wave main";
									end
								end
							end
							v233 = 1 - 0;
						end
						if (((3124 - (1076 + 57)) >= (153 + 772)) and (v233 == (690 - (579 + 110)))) then
							if (((36 + 419) < (1816 + 237)) and v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(22 + 18) and (v118.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v114.EarthShield)) then
								if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((1233 - (174 + 233)) == (13550 - 8699))) then
									return "earth_shield_tank main fight";
								end
							end
							v191 = v123();
							v233 = 3 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v192 = 0 + 0;
		while true do
			if (((1357 - (663 + 511)) == (164 + 19)) and (v192 == (0 + 0))) then
				v120();
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(813 - 549, v130, v131);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

