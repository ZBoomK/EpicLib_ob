local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1161 - 765) <= (5029 - (942 + 283))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((5265 - (709 + 387)) == (4045 - (673 + 1185)))) then
			v6 = v0[v4];
			if (((4077 - 2671) == (4514 - 3108)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
	local v113 = 7948 + 3163;
	local v114 = 8303 + 2808;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 0 - 0;
		while true do
			if (((377 + 1154) < (8515 - 4244)) and (v134 == (0 - 0))) then
				v113 = 12991 - (446 + 1434);
				v114 = 12394 - (1040 + 243);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v116 = v18.Shaman.Restoration;
	local v117 = v25.Shaman.Restoration;
	local v118 = v20.Shaman.Restoration;
	local v119 = {};
	local v120 = v22.Commons.Everyone;
	local v121 = v22.Commons.Shaman;
	local function v122()
		if (((1895 - 1260) == (2482 - (559 + 1288))) and v116.ImprovedPurifySpirit:IsAvailable()) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellableCurseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123(v135)
		return v135:DebuffRefreshable(v116.FlameShockDebuff) and (v114 > (1936 - (609 + 1322)));
	end
	local function v124()
		local v136 = 454 - (13 + 441);
		while true do
			if (((12604 - 9231) <= (9314 - 5758)) and (v136 == (4 - 3))) then
				if ((v118.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((123 + 3168) < (11912 - 8632))) then
					if (((1558 + 2828) >= (383 + 490)) and v24(v117.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((2733 - 1812) <= (604 + 498)) and v38 and (v13:HealthPercentage() <= v39)) then
					local v234 = 0 - 0;
					while true do
						if (((3112 + 1594) >= (536 + 427)) and (v234 == (0 + 0))) then
							if ((v40 == "Refreshing Healing Potion") or ((807 + 153) <= (858 + 18))) then
								if (v118.RefreshingHealingPotion:IsReady() or ((2499 - (153 + 280)) == (2690 - 1758))) then
									if (((4332 + 493) < (1913 + 2930)) and v24(v117.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v40 == "Dreamwalker's Healing Potion") or ((2029 + 1848) >= (4118 + 419))) then
								if (v118.DreamwalkersHealingPotion:IsReady() or ((3127 + 1188) < (2627 - 901))) then
									if (v24(v117.RefreshingHealingPotion) or ((2274 + 1405) < (1292 - (89 + 578)))) then
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
			if ((v136 == (0 + 0)) or ((9614 - 4989) < (1681 - (572 + 477)))) then
				if ((v89 and v116.AstralShift:IsReady()) or ((12 + 71) > (1069 + 711))) then
					if (((66 + 480) <= (1163 - (84 + 2))) and (v13:HealthPercentage() <= v55)) then
						if (v24(v116.AstralShift, not v15:IsInRange(65 - 25)) or ((718 + 278) > (5143 - (497 + 345)))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((105 + 3965) > (117 + 570)) and v92 and v116.EarthElemental:IsReady()) then
					if ((v13:HealthPercentage() <= v63) or v120.IsTankBelowHealthPercentage(v64) or ((1989 - (605 + 728)) >= (2376 + 954))) then
						if (v24(v116.EarthElemental, not v15:IsInRange(88 - 48)) or ((115 + 2377) <= (1238 - 903))) then
							return "earth_elemental defensives";
						end
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v125()
		local v137 = 0 - 0;
		while true do
			if (((3264 + 1058) >= (3051 - (457 + 32))) and (v137 == (0 + 0))) then
				if (v41 or ((5039 - (832 + 570)) >= (3552 + 218))) then
					local v235 = 0 + 0;
					while true do
						if (((3 - 2) == v235) or ((1146 + 1233) > (5374 - (588 + 208)))) then
							v29 = v120.HandleCharredTreant(v116.HealingSurge, v117.HealingSurgeMouseover, 107 - 67);
							if (v29 or ((2283 - (884 + 916)) > (1555 - 812))) then
								return v29;
							end
							v235 = 2 + 0;
						end
						if (((3107 - (232 + 421)) > (2467 - (1569 + 320))) and (v235 == (0 + 0))) then
							v29 = v120.HandleCharredTreant(v116.Riptide, v117.RiptideMouseover, 8 + 32);
							if (((3133 - 2203) < (5063 - (316 + 289))) and v29) then
								return v29;
							end
							v235 = 2 - 1;
						end
						if (((31 + 631) <= (2425 - (666 + 787))) and (v235 == (427 - (360 + 65)))) then
							v29 = v120.HandleCharredTreant(v116.HealingWave, v117.HealingWaveMouseover, 38 + 2);
							if (((4624 - (79 + 175)) == (6890 - 2520)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v42 or ((3716 + 1046) <= (2639 - 1778))) then
					local v236 = 0 - 0;
					while true do
						if ((v236 == (900 - (503 + 396))) or ((1593 - (92 + 89)) == (8271 - 4007))) then
							v29 = v120.HandleCharredBrambles(v116.HealingSurge, v117.HealingSurgeMouseover, 21 + 19);
							if (v29 or ((1875 + 1293) < (8431 - 6278))) then
								return v29;
							end
							v236 = 1 + 1;
						end
						if ((v236 == (0 - 0)) or ((4342 + 634) < (637 + 695))) then
							v29 = v120.HandleCharredBrambles(v116.Riptide, v117.RiptideMouseover, 121 - 81);
							if (((578 + 4050) == (7057 - 2429)) and v29) then
								return v29;
							end
							v236 = 1245 - (485 + 759);
						end
						if ((v236 == (4 - 2)) or ((1243 - (442 + 747)) == (1530 - (832 + 303)))) then
							v29 = v120.HandleCharredBrambles(v116.HealingWave, v117.HealingWaveMouseover, 986 - (88 + 858));
							if (((25 + 57) == (68 + 14)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (790 - (766 + 23))) or ((2868 - 2287) < (385 - 103))) then
				if (v43 or ((12143 - 7534) < (8468 - 5973))) then
					local v237 = 1073 - (1036 + 37);
					while true do
						if (((817 + 335) == (2243 - 1091)) and (v237 == (2 + 0))) then
							v29 = v120.HandleFyrakkNPC(v116.HealingWave, v117.HealingWaveMouseover, 1520 - (641 + 839));
							if (((2809 - (910 + 3)) <= (8723 - 5301)) and v29) then
								return v29;
							end
							break;
						end
						if ((v237 == (1685 - (1466 + 218))) or ((455 + 535) > (2768 - (556 + 592)))) then
							v29 = v120.HandleFyrakkNPC(v116.HealingSurge, v117.HealingSurgeMouseover, 15 + 25);
							if (v29 or ((1685 - (329 + 479)) > (5549 - (174 + 680)))) then
								return v29;
							end
							v237 = 6 - 4;
						end
						if (((5577 - 2886) >= (1322 + 529)) and (v237 == (739 - (396 + 343)))) then
							v29 = v120.HandleFyrakkNPC(v116.Riptide, v117.RiptideMouseover, 4 + 36);
							if (v29 or ((4462 - (29 + 1448)) >= (6245 - (135 + 1254)))) then
								return v29;
							end
							v237 = 3 - 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v138 = 0 - 0;
		while true do
			if (((2850 + 1426) >= (2722 - (389 + 1138))) and (v138 == (574 - (102 + 472)))) then
				if (((3051 + 181) <= (2601 + 2089)) and v107 and ((v31 and v106) or not v106)) then
					v29 = v120.HandleTopTrinket(v119, v31, 38 + 2, nil);
					if (v29 or ((2441 - (320 + 1225)) >= (5600 - 2454))) then
						return v29;
					end
					v29 = v120.HandleBottomTrinket(v119, v31, 25 + 15, nil);
					if (((4525 - (157 + 1307)) >= (4817 - (821 + 1038))) and v29) then
						return v29;
					end
				end
				if (((7951 - 4764) >= (71 + 573)) and v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) then
					if (((1143 - 499) <= (262 + 442)) and (v17:HealthPercentage() <= v79)) then
						if (((2374 - 1416) > (1973 - (834 + 192))) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((1153 + 3339) >= (57 + 2597)) and (v138 == (5 - 1))) then
				if (((3746 - (300 + 4)) >= (402 + 1101)) and v98 and (v13:Mana() <= v77) and v116.ManaTideTotem:IsReady()) then
					if (v24(v116.ManaTideTotem, not v15:IsInRange(104 - 64)) or ((3532 - (112 + 250)) <= (584 + 880))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v105 and v31) or not v105)) or ((12017 - 7220) == (2514 + 1874))) then
					local v238 = 0 + 0;
					while true do
						if (((413 + 138) <= (338 + 343)) and (v238 == (1 + 0))) then
							if (((4691 - (1001 + 413)) > (907 - 500)) and v116.Berserking:IsReady()) then
								if (((5577 - (244 + 638)) >= (2108 - (627 + 66))) and v24(v116.Berserking, not v15:IsInRange(119 - 79))) then
									return "Berserking cooldowns";
								end
							end
							if (v116.BloodFury:IsReady() or ((3814 - (512 + 90)) <= (2850 - (1665 + 241)))) then
								if (v24(v116.BloodFury, not v15:IsInRange(757 - (373 + 344))) or ((1397 + 1699) <= (476 + 1322))) then
									return "BloodFury cooldowns";
								end
							end
							v238 = 5 - 3;
						end
						if (((5985 - 2448) == (4636 - (35 + 1064))) and ((0 + 0) == v238)) then
							if (((8209 - 4372) >= (7 + 1563)) and v116.AncestralCall:IsReady()) then
								if (v24(v116.AncestralCall, not v15:IsInRange(1276 - (298 + 938))) or ((4209 - (233 + 1026)) == (5478 - (636 + 1030)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((2415 + 2308) >= (2265 + 53)) and v116.BagofTricks:IsReady()) then
								if (v24(v116.BagofTricks, not v15:IsInRange(12 + 28)) or ((137 + 1890) > (3073 - (55 + 166)))) then
									return "BagofTricks cooldowns";
								end
							end
							v238 = 1 + 0;
						end
						if ((v238 == (1 + 1)) or ((4338 - 3202) > (4614 - (36 + 261)))) then
							if (((8303 - 3555) == (6116 - (34 + 1334))) and v116.Fireblood:IsReady()) then
								if (((1437 + 2299) <= (3683 + 1057)) and v24(v116.Fireblood, not v15:IsInRange(1323 - (1035 + 248)))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v138 == (22 - (20 + 1))) or ((1767 + 1623) <= (3379 - (134 + 185)))) then
				if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((2132 - (549 + 584)) > (3378 - (314 + 371)))) then
					if (((1589 - 1126) < (1569 - (478 + 490))) and (v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) then
						if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((1157 + 1026) < (1859 - (786 + 386)))) then
							return "riptide healingcd";
						end
					end
				end
				if (((14733 - 10184) == (5928 - (1055 + 324))) and v120.AreUnitsBelowHealthPercentage(v82, v81) and v116.SpiritLinkTotem:IsReady()) then
					if (((6012 - (1093 + 247)) == (4152 + 520)) and (v83 == "Player")) then
						if (v24(v117.SpiritLinkTotemPlayer, not v15:IsInRange(5 + 35)) or ((14562 - 10894) < (1340 - 945))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v83 == "Friendly under Cursor") or ((11854 - 7688) == (1143 - 688))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1583 + 2866) == (10258 - 7595))) then
							if (v24(v117.SpiritLinkTotemCursor, not v15:IsInRange(137 - 97)) or ((3225 + 1052) < (7643 - 4654))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v83 == "Confirmation") or ((1558 - (364 + 324)) >= (11373 - 7224))) then
						if (((5307 - 3095) < (1055 + 2128)) and v24(v116.SpiritLinkTotem, not v15:IsInRange(167 - 127))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v138 = 2 - 0;
			end
			if (((14110 - 9464) > (4260 - (1249 + 19))) and (v138 == (2 + 0))) then
				if (((5581 - 4147) < (4192 - (686 + 400))) and v96 and v120.AreUnitsBelowHealthPercentage(v75, v74) and v116.HealingTideTotem:IsReady()) then
					if (((617 + 169) < (3252 - (73 + 156))) and v24(v116.HealingTideTotem, not v15:IsInRange(1 + 39))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v120.AreUnitsBelowHealthPercentage(v51, v50) and v116.AncestralProtectionTotem:IsReady()) or ((3253 - (721 + 90)) < (1 + 73))) then
					if (((14724 - 10189) == (5005 - (224 + 246))) and (v52 == "Player")) then
						if (v24(v117.AncestralProtectionTotemPlayer, not v15:IsInRange(64 - 24)) or ((5539 - 2530) <= (382 + 1723))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((44 + 1786) < (2695 + 974)) and (v52 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2843 - 1413) >= (12019 - 8407))) then
							if (((3196 - (203 + 310)) >= (4453 - (1238 + 755))) and v24(v117.AncestralProtectionTotemCursor, not v15:IsInRange(3 + 37))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v52 == "Confirmation") or ((3338 - (709 + 825)) >= (6034 - 2759))) then
						if (v24(v116.AncestralProtectionTotem, not v15:IsInRange(58 - 18)) or ((2281 - (196 + 668)) > (14328 - 10699))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v138 = 5 - 2;
			end
			if (((5628 - (171 + 662)) > (495 - (4 + 89))) and (v138 == (10 - 7))) then
				if (((1753 + 3060) > (15658 - 12093)) and v87 and v120.AreUnitsBelowHealthPercentage(v49, v48) and v116.AncestralGuidance:IsReady()) then
					if (((1535 + 2377) == (5398 - (35 + 1451))) and v24(v116.AncestralGuidance, not v15:IsInRange(1493 - (28 + 1425)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((4814 - (941 + 1052)) <= (4626 + 198)) and v88 and v120.AreUnitsBelowHealthPercentage(v54, v53) and v116.Ascendance:IsReady()) then
					if (((3252 - (822 + 692)) <= (3133 - 938)) and v24(v116.Ascendance, not v15:IsInRange(19 + 21))) then
						return "ascendance cooldowns";
					end
				end
				v138 = 301 - (45 + 252);
			end
		end
	end
	local function v127()
		local v139 = 0 + 0;
		while true do
			if (((15 + 26) <= (7344 - 4326)) and (v139 == (436 - (114 + 319)))) then
				if (((3079 - 934) <= (5258 - 1154)) and v91 and v120.AreUnitsBelowHealthPercentage(v59, v58) and v116.CloudburstTotem:IsReady()) then
					if (((1715 + 974) < (7218 - 2373)) and v24(v116.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v102 and v120.AreUnitsBelowHealthPercentage(v104, v103) and v116.Wellspring:IsReady()) or ((4864 - 2542) > (4585 - (556 + 1407)))) then
					if (v24(v116.Wellspring, not v15:IsInRange(1246 - (741 + 465)), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((4999 - (170 + 295)) == (1097 + 985))) then
						return "wellspring healingaoe";
					end
				end
				if ((v90 and v120.AreUnitsBelowHealthPercentage(v57, v56) and v116.ChainHeal:IsReady()) or ((1444 + 127) > (4596 - 2729))) then
					if (v24(v117.ChainHealFocus, not v17:IsSpellInRange(v116.ChainHeal), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((2201 + 453) >= (1922 + 1074))) then
						return "chain_heal healingaoe";
					end
				end
				v139 = 3 + 1;
			end
			if (((5208 - (957 + 273)) > (563 + 1541)) and (v139 == (0 + 0))) then
				if (((11412 - 8417) > (4060 - 2519)) and v90 and v120.AreUnitsBelowHealthPercentage(290 - 195, 14 - 11) and v116.ChainHeal:IsReady() and v13:BuffUp(v116.HighTide)) then
					if (((5029 - (389 + 1391)) > (598 + 355)) and v24(v117.ChainHealFocus, not v17:IsSpellInRange(v116.ChainHeal), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v97 and (v17:HealthPercentage() <= v76) and v116.HealingWave:IsReady() and (v116.PrimordialWaveResto:TimeSinceLastCast() < (2 + 13))) or ((7451 - 4178) > (5524 - (783 + 168)))) then
					if (v24(v117.HealingWaveFocus, not v17:IsSpellInRange(v116.HealingWave), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((10575 - 7424) < (1263 + 21))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((2161 - (309 + 2)) == (4695 - 3166))) then
					if (((2033 - (1090 + 122)) < (689 + 1434)) and (v17:HealthPercentage() <= v79)) then
						if (((3029 - 2127) < (1592 + 733)) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v139 = 1119 - (628 + 490);
			end
			if (((154 + 704) <= (7333 - 4371)) and (v139 == (4 - 3))) then
				if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((4720 - (431 + 343)) < (2601 - 1313))) then
					if (((v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) or ((9378 - 6136) == (448 + 119))) then
						if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((109 + 738) >= (2958 - (556 + 1139)))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v101 and v116.UnleashLife:IsReady()) or ((2268 - (6 + 9)) == (339 + 1512))) then
					if ((v17:HealthPercentage() <= v86) or ((1070 + 1017) > (2541 - (28 + 141)))) then
						if (v24(v116.UnleashLife, not v17:IsSpellInRange(v116.UnleashLife)) or ((1722 + 2723) < (5120 - 971))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v70 == "Cursor") and v116.HealingRain:IsReady()) or ((1288 + 530) == (1402 - (486 + 831)))) then
					if (((1639 - 1009) < (7488 - 5361)) and v24(v117.HealingRainCursor, not v15:IsInRange(8 + 32), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v139 = 6 - 4;
			end
			if ((v139 == (1267 - (668 + 595))) or ((1744 + 194) == (507 + 2007))) then
				if (((11603 - 7348) >= (345 - (23 + 267))) and v100 and v13:IsMoving() and v120.AreUnitsBelowHealthPercentage(v85, v84) and v116.SpiritwalkersGrace:IsReady()) then
					if (((4943 - (1129 + 815)) > (1543 - (371 + 16))) and v24(v116.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((4100 - (1326 + 424)) > (2187 - 1032)) and v94 and v120.AreUnitsBelowHealthPercentage(v72, v71) and v116.HealingStreamTotem:IsReady()) then
					if (((14722 - 10693) <= (4971 - (88 + 30))) and v24(v116.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v139 == (773 - (720 + 51))) or ((1147 - 631) > (5210 - (421 + 1355)))) then
				if (((6674 - 2628) >= (1490 + 1543)) and v120.AreUnitsBelowHealthPercentage(v69, v68) and v116.HealingRain:IsReady()) then
					if ((v70 == "Player") or ((3802 - (286 + 797)) <= (5289 - 3842))) then
						if (v24(v117.HealingRainPlayer, not v15:IsInRange(66 - 26), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((4573 - (397 + 42)) < (1227 + 2699))) then
							return "healing_rain healingaoe";
						end
					elseif ((v70 == "Friendly under Cursor") or ((964 - (24 + 776)) >= (4290 - 1505))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1310 - (222 + 563)) == (4646 - 2537))) then
							if (((24 + 9) == (223 - (23 + 167))) and v24(v117.HealingRainCursor, not v15:IsInRange(1838 - (690 + 1108)), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((1102 + 1952) <= (3312 + 703)) and (v70 == "Enemy under Cursor")) then
						if (((2719 - (40 + 808)) < (557 + 2825)) and v16:Exists() and v13:CanAttack(v16)) then
							if (((4944 - 3651) <= (2071 + 95)) and v24(v117.HealingRainCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((1415 + 1164) < (694 - (47 + 524)))) then
						if (v24(v116.HealingRain, not v15:IsInRange(26 + 14), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((2312 - 1466) >= (3540 - 1172))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v120.AreUnitsBelowHealthPercentage(v66, v65) and v116.EarthenWallTotem:IsReady()) or ((9149 - 5137) <= (5084 - (1165 + 561)))) then
					if (((45 + 1449) <= (9307 - 6302)) and (v67 == "Player")) then
						if (v24(v117.EarthenWallTotemPlayer, not v15:IsInRange(16 + 24)) or ((3590 - (341 + 138)) == (577 + 1557))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((4860 - 2505) == (2681 - (89 + 237))) and (v67 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1891 - 1303) <= (909 - 477))) then
							if (((5678 - (581 + 300)) >= (5115 - (855 + 365))) and v24(v117.EarthenWallTotemCursor, not v15:IsInRange(95 - 55))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((1168 + 2409) == (4812 - (1030 + 205))) and (v67 == "Confirmation")) then
						if (((3562 + 232) > (3436 + 257)) and v24(v116.EarthenWallTotem, not v15:IsInRange(326 - (156 + 130)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if ((v120.AreUnitsBelowHealthPercentage(v61, v60) and v116.Downpour:IsReady()) or ((2897 - 1622) == (6910 - 2810))) then
					if ((v62 == "Player") or ((3258 - 1667) >= (944 + 2636))) then
						if (((574 + 409) <= (1877 - (10 + 59))) and v24(v117.DownpourPlayer, not v15:IsInRange(12 + 28), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v62 == "Friendly under Cursor") or ((10588 - 8438) <= (2360 - (671 + 492)))) then
						if (((3001 + 768) >= (2388 - (369 + 846))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((394 + 1091) == (1268 + 217)) and v24(v117.DownpourCursor, not v15:IsInRange(1985 - (1036 + 909)), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v62 == "Confirmation") or ((2636 + 679) <= (4670 - 1888))) then
						if (v24(v116.Downpour, not v15:IsInRange(243 - (11 + 192)), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((443 + 433) >= (3139 - (135 + 40)))) then
							return "downpour healingaoe";
						end
					end
				end
				v139 = 6 - 3;
			end
		end
	end
	local function v128()
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((1346 + 886) > (5500 - 3003))) then
			if ((v17:HealthPercentage() <= v79) or ((3163 - 1053) <= (508 - (50 + 126)))) then
				if (((10263 - 6577) > (703 + 2469)) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((5887 - (1233 + 180)) < (1789 - (522 + 447)))) then
			if (((5700 - (107 + 1314)) >= (1338 + 1544)) and (v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) then
				if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((6182 - 4153) >= (1496 + 2025))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((4044 - 2007) >= (18366 - 13724))) then
			if (((3630 - (716 + 1194)) < (77 + 4381)) and ((v17:HealthPercentage() <= v79) or (v17:HealthPercentage() <= v79))) then
				if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((47 + 389) > (3524 - (74 + 429)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1374 - 661) <= (420 + 427)) and v116.ElementalOrbit:IsAvailable() and v13:BuffDown(v116.EarthShieldBuff)) then
			if (((4930 - 2776) <= (2852 + 1179)) and v24(v116.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((14227 - 9612) == (11410 - 6795)) and v116.ElementalOrbit:IsAvailable() and v13:BuffUp(v116.EarthShieldBuff)) then
			if (v120.IsSoloMode() or ((4223 - (279 + 154)) == (1278 - (454 + 324)))) then
				if (((71 + 18) < (238 - (12 + 5))) and v116.LightningShield:IsReady() and v13:BuffDown(v116.LightningShield)) then
					if (((1108 + 946) >= (3620 - 2199)) and v24(v116.LightningShield)) then
						return "lightning_shield healingst";
					end
				end
			elseif (((256 + 436) < (4151 - (277 + 816))) and v116.WaterShield:IsReady() and v13:BuffDown(v116.WaterShield)) then
				if (v24(v116.WaterShield) or ((13904 - 10650) == (2838 - (1058 + 125)))) then
					return "water_shield healingst";
				end
			end
		end
		if ((v95 and v116.HealingSurge:IsReady()) or ((243 + 1053) == (5885 - (815 + 160)))) then
			if (((14450 - 11082) == (7995 - 4627)) and (v17:HealthPercentage() <= v73)) then
				if (((631 + 2012) < (11151 - 7336)) and v24(v117.HealingSurgeFocus, not v17:IsSpellInRange(v116.HealingSurge), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((3811 - (41 + 1857)) > (2386 - (1222 + 671))) and v97 and v116.HealingWave:IsReady()) then
			if (((12289 - 7534) > (4927 - 1499)) and (v17:HealthPercentage() <= v76)) then
				if (((2563 - (229 + 953)) <= (4143 - (1111 + 663))) and v24(v117.HealingWaveFocus, not v17:IsSpellInRange(v116.HealingWave), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v129()
		local v140 = 1579 - (874 + 705);
		while true do
			if (((1 + 0) == v140) or ((3305 + 1538) == (8488 - 4404))) then
				if (((132 + 4537) > (1042 - (642 + 37))) and v116.FlameShock:IsReady()) then
					if (v120.CastCycle(v116.FlameShock, v13:GetEnemiesInRange(10 + 30), v123, not v15:IsSpellInRange(v116.FlameShock), nil, nil, nil, nil) or ((301 + 1576) >= (7878 - 4740))) then
						return "flame_shock_cycle damage";
					end
					if (((5196 - (233 + 221)) >= (8384 - 4758)) and v24(v116.FlameShock, not v15:IsSpellInRange(v116.FlameShock))) then
						return "flame_shock damage";
					end
				end
				if (v116.LavaBurst:IsReady() or ((3996 + 544) == (2457 - (718 + 823)))) then
					if (v24(v116.LavaBurst, not v15:IsSpellInRange(v116.LavaBurst), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((728 + 428) > (5150 - (266 + 539)))) then
						return "lava_burst damage";
					end
				end
				v140 = 5 - 3;
			end
			if (((3462 - (636 + 589)) < (10085 - 5836)) and (v140 == (3 - 1))) then
				if (v116.LightningBolt:IsReady() or ((2127 + 556) < (9 + 14))) then
					if (((1712 - (657 + 358)) <= (2186 - 1360)) and v24(v116.LightningBolt, not v15:IsSpellInRange(v116.LightningBolt), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if (((2517 - 1412) <= (2363 - (1151 + 36))) and (v140 == (0 + 0))) then
				if (((889 + 2490) <= (11384 - 7572)) and v116.Stormkeeper:IsReady()) then
					if (v24(v116.Stormkeeper, not v15:IsInRange(1872 - (1552 + 280))) or ((1622 - (64 + 770)) >= (1098 + 518))) then
						return "stormkeeper damage";
					end
				end
				if (((4208 - 2354) <= (600 + 2779)) and (#v13:GetEnemiesInRange(1283 - (157 + 1086)) > (1 - 0))) then
					if (((19923 - 15374) == (6977 - 2428)) and v116.ChainLightning:IsReady()) then
						if (v24(v116.ChainLightning, not v15:IsSpellInRange(v116.ChainLightning), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((4124 - 1102) >= (3843 - (599 + 220)))) then
							return "chain_lightning damage";
						end
					end
				end
				v140 = 1 - 0;
			end
		end
	end
	local function v130()
		v50 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v51 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v52 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v56 = EpicSettings.Settings['ChainHealGroup'];
		v57 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v60 = EpicSettings.Settings['DownpourGroup'];
		v61 = EpicSettings.Settings['DownpourHP'];
		v62 = EpicSettings.Settings['DownpourUsage'];
		v65 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v66 = EpicSettings.Settings['EarthenWallTotemHP'];
		v67 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v43 = EpicSettings.Settings['HandleFyrakkNPC'];
		v39 = EpicSettings.Settings['HealingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v68 = EpicSettings.Settings['HealingRainGroup'];
		v69 = EpicSettings.Settings['HealingRainHP'];
		v70 = EpicSettings.Settings['HealingRainUsage'];
		v71 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v72 = EpicSettings.Settings['HealingStreamTotemHP'];
		v73 = EpicSettings.Settings['HealingSurgeHP'];
		v74 = EpicSettings.Settings['HealingTideTotemGroup'];
		v75 = EpicSettings.Settings['HealingTideTotemHP'];
		v76 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v47 = EpicSettings.Settings['InterruptThreshold'];
		v45 = EpicSettings.Settings['InterruptWithStun'];
		v79 = EpicSettings.Settings['RiptideHP'];
		v80 = EpicSettings.Settings['RiptideTankHP'];
		v81 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v82 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v83 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v84 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v85 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v86 = EpicSettings.Settings['UnleashLifeHP'];
		v90 = EpicSettings.Settings['UseChainHeal'];
		v91 = EpicSettings.Settings['UseCloudburstTotem'];
		v93 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['UseHealingPotion'];
		v94 = EpicSettings.Settings['UseHealingStreamTotem'];
		v95 = EpicSettings.Settings['UseHealingSurge'];
		v96 = EpicSettings.Settings['UseHealingTideTotem'];
		v97 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v99 = EpicSettings.Settings['UseRiptide'];
		v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v101 = EpicSettings.Settings['UseUnleashLife'];
		v111 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v112 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v131()
		local v193 = 1931 - (1813 + 118);
		while true do
			if (((3524 + 1296) > (3415 - (841 + 376))) and (v193 == (7 - 1))) then
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v193 == (1 + 2)) or ((2895 - 1834) >= (5750 - (464 + 395)))) then
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v193 = 10 - 6;
			end
			if (((656 + 708) <= (5310 - (467 + 370))) and (v193 == (8 - 4))) then
				v35 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['UseWellspring'];
				v103 = EpicSettings.Settings['WellspringGroup'];
				v104 = EpicSettings.Settings['WellspringHP'];
				v193 = 4 + 1;
			end
			if ((v193 == (3 - 2)) or ((561 + 3034) <= (6 - 3))) then
				v55 = EpicSettings.Settings['AstralShiftHP'];
				v58 = EpicSettings.Settings['CloudburstTotemGroup'];
				v59 = EpicSettings.Settings['CloudburstTotemHP'];
				v63 = EpicSettings.Settings['EarthElementalHP'];
				v193 = 522 - (150 + 370);
			end
			if ((v193 == (1287 - (74 + 1208))) or ((11490 - 6818) == (18268 - 14416))) then
				v105 = EpicSettings.Settings['racialsWithCD'];
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v193 = 5 + 1;
			end
			if (((1949 - (14 + 376)) == (2703 - 1144)) and (v193 == (2 + 0))) then
				v64 = EpicSettings.Settings['EarthElementalTankHP'];
				v77 = EpicSettings.Settings['ManaTideTotemMana'];
				v78 = EpicSettings.Settings['PrimordialWaveHP'];
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v193 = 3 + 0;
			end
			if ((v193 == (0 + 0)) or ((5133 - 3381) <= (593 + 195))) then
				v48 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v49 = EpicSettings.Settings['AncestralGuidanceHP'];
				v53 = EpicSettings.Settings['AscendanceGroup'];
				v54 = EpicSettings.Settings['AscendanceHP'];
				v193 = 79 - (23 + 55);
			end
		end
	end
	local function v132()
		local v194 = 0 - 0;
		local v195;
		while true do
			if ((v194 == (3 + 1)) or ((3509 + 398) == (274 - 97))) then
				if (((1092 + 2378) > (1456 - (652 + 249))) and (v120.TargetIsValid() or v13:AffectingCombat())) then
					local v239 = 0 - 0;
					while true do
						if ((v239 == (1869 - (708 + 1160))) or ((2638 - 1666) == (1175 - 530))) then
							v114 = v113;
							if (((3209 - (10 + 17)) >= (476 + 1639)) and (v114 == (12843 - (1400 + 332)))) then
								v114 = v10.FightRemains(v115, false);
							end
							break;
						end
						if (((7466 - 3573) < (6337 - (242 + 1666))) and (v239 == (0 + 0))) then
							v115 = v13:GetEnemiesInRange(15 + 25);
							v113 = v10.BossFightRemains(nil, true);
							v239 = 1 + 0;
						end
					end
				end
				if ((v13:AffectingCombat() and v120.TargetIsValid()) or ((3807 - (850 + 90)) < (3336 - 1431))) then
					v29 = v120.Interrupt(v116.WindShear, 1420 - (360 + 1030), true);
					if (v29 or ((1590 + 206) >= (11433 - 7382))) then
						return v29;
					end
					v29 = v120.InterruptCursor(v116.WindShear, v117.WindShearMouseover, 41 - 11, true, v16);
					if (((3280 - (909 + 752)) <= (4979 - (109 + 1114))) and v29) then
						return v29;
					end
					v29 = v120.InterruptWithStunCursor(v116.CapacitorTotem, v117.CapacitorTotemCursor, 54 - 24, nil, v16);
					if (((236 + 368) == (846 - (6 + 236))) and v29) then
						return v29;
					end
					if (v110 or ((2826 + 1658) == (725 + 175))) then
						local v242 = 0 - 0;
						while true do
							if ((v242 == (0 - 0)) or ((5592 - (1076 + 57)) <= (184 + 929))) then
								v29 = v120.HandleIncorporeal(v116.Hex, v117.HexMouseOver, 719 - (579 + 110), true);
								if (((287 + 3345) > (3005 + 393)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (((2167 + 1915) <= (5324 - (174 + 233))) and v109) then
						local v243 = 0 - 0;
						while true do
							if (((8480 - 3648) >= (617 + 769)) and (v243 == (1175 - (663 + 511)))) then
								if (((123 + 14) == (30 + 107)) and v111) then
									v29 = v120.HandleAfflicted(v116.TremorTotem, v116.TremorTotem, 92 - 62);
									if (v29 or ((951 + 619) >= (10198 - 5866))) then
										return v29;
									end
								end
								if (v112 or ((9837 - 5773) <= (868 + 951))) then
									local v251 = 0 - 0;
									while true do
										if ((v251 == (0 + 0)) or ((456 + 4530) < (2296 - (478 + 244)))) then
											v29 = v120.HandleAfflicted(v116.PoisonCleansingTotem, v116.PoisonCleansingTotem, 547 - (440 + 77));
											if (((2013 + 2413) > (629 - 457)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								break;
							end
							if (((2142 - (655 + 901)) > (85 + 370)) and (v243 == (0 + 0))) then
								v29 = v120.HandleAfflicted(v116.PurifySpirit, v117.PurifySpiritMouseover, 21 + 9);
								if (((3327 - 2501) == (2271 - (695 + 750))) and v29) then
									return v29;
								end
								v243 = 3 - 2;
							end
						end
					end
					v195 = v124();
					if (v195 or ((6201 - 2182) > (17860 - 13419))) then
						return v195;
					end
					if (((2368 - (285 + 66)) < (9932 - 5671)) and (v114 > v108)) then
						local v244 = 1310 - (682 + 628);
						while true do
							if (((761 + 3955) > (379 - (176 + 123))) and (v244 == (0 + 0))) then
								v195 = v126();
								if (v195 or ((2544 + 963) == (3541 - (239 + 30)))) then
									return v195;
								end
								break;
							end
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((239 + 637) >= (2956 + 119))) then
					if (((7702 - 3350) > (7968 - 5414)) and v32) then
						if ((v17 and v44) or ((4721 - (306 + 9)) < (14108 - 10065))) then
							if ((v116.PurifySpirit:IsReady() and v120.DispellableFriendlyUnit(5 + 20)) or ((1159 + 730) >= (1629 + 1754))) then
								if (((5410 - 3518) <= (4109 - (1140 + 235))) and v24(v117.PurifySpiritFocus, not v17:IsSpellInRange(v116.PurifySpirit))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					if (((1224 + 699) < (2034 + 184)) and (v17:HealthPercentage() < v78) and v17:BuffDown(v116.Riptide)) then
						if (((558 + 1615) > (431 - (33 + 19))) and v116.PrimordialWaveResto:IsCastable()) then
							if (v24(v117.PrimordialWaveFocus, not v17:IsSpellInRange(v116.PrimordialWaveResto)) or ((936 + 1655) == (10217 - 6808))) then
								return "primordial_wave main";
							end
						end
					end
					if (((1989 + 2525) > (6518 - 3194)) and v116.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(38 + 2) and (v120.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v116.EarthShield)) then
						if (v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield)) or ((897 - (586 + 103)) >= (440 + 4388))) then
							return "earth_shield_tank main fight";
						end
					end
					v195 = v125();
					if (v195 or ((4873 - 3290) > (5055 - (1309 + 179)))) then
						return v195;
					end
					if (v33 or ((2370 - 1057) == (346 + 448))) then
						local v245 = 0 - 0;
						while true do
							if (((2398 + 776) > (6165 - 3263)) and (v245 == (0 - 0))) then
								v195 = v127();
								if (((4729 - (295 + 314)) <= (10463 - 6203)) and v195) then
									return v195;
								end
								v245 = 1963 - (1300 + 662);
							end
							if ((v245 == (3 - 2)) or ((2638 - (1178 + 577)) > (2482 + 2296))) then
								v195 = v128();
								if (v195 or ((10701 - 7081) >= (6296 - (851 + 554)))) then
									return v195;
								end
								break;
							end
						end
					end
					if (((3766 + 492) > (2598 - 1661)) and v34) then
						if (v120.TargetIsValid() or ((10574 - 5705) < (1208 - (115 + 187)))) then
							local v248 = 0 + 0;
							while true do
								if ((v248 == (0 + 0)) or ((4827 - 3602) > (5389 - (160 + 1001)))) then
									v195 = v129();
									if (((2912 + 416) > (1545 + 693)) and v195) then
										return v195;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if (((7858 - 4019) > (1763 - (237 + 121))) and (v194 == (897 - (525 + 372)))) then
				v130();
				v131();
				v30 = EpicSettings.Toggles['ooc'];
				v194 = 1 - 0;
			end
			if ((v194 == (9 - 6)) or ((1435 - (96 + 46)) <= (1284 - (643 + 134)))) then
				if ((v116.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(15 + 25) and (v120.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v116.EarthShield))) or ((6943 - 4047) < (2988 - 2183))) then
					if (((2222 + 94) == (4545 - 2229)) and v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v195 = nil;
				if (not v13:AffectingCombat() or ((5253 - 2683) == (2252 - (316 + 403)))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((587 + 296) == (4014 - 2554))) then
						local v246 = 0 + 0;
						local v247;
						while true do
							if (((0 - 0) == v246) or ((3274 + 1345) <= (322 + 677))) then
								v247 = v120.DeadFriendlyUnitsCount();
								if ((v247 > (3 - 2)) or ((16285 - 12875) > (8550 - 4434))) then
									if (v24(v116.AncestralVision, nil, v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((52 + 851) >= (6021 - 2962))) then
										return "ancestral_vision";
									end
								elseif (v24(v117.AncestralSpiritMouseover, not v15:IsInRange(2 + 38), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((11697 - 7721) < (2874 - (12 + 5)))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v194 = 15 - 11;
			end
			if (((10518 - 5588) > (4903 - 2596)) and (v194 == (4 - 2))) then
				v34 = EpicSettings.Toggles['dps'];
				if (v13:IsDeadOrGhost() or ((822 + 3224) < (3264 - (1656 + 317)))) then
					return;
				end
				if (v13:AffectingCombat() or v30 or ((3780 + 461) == (2841 + 704))) then
					local v240 = 0 - 0;
					local v241;
					while true do
						if ((v240 == (0 - 0)) or ((4402 - (5 + 349)) > (20101 - 15869))) then
							v241 = v44 and v116.PurifySpirit:IsReady() and v32;
							if ((v116.EarthShield:IsReady() and v93 and (v120.FriendlyUnitsWithBuffCount(v116.EarthShield, true, false, 1296 - (266 + 1005)) < (1 + 0))) or ((5971 - 4221) >= (4571 - 1098))) then
								local v249 = 1696 - (561 + 1135);
								while true do
									if (((4125 - 959) == (10406 - 7240)) and (v249 == (1067 - (507 + 559)))) then
										if (((4423 - 2660) < (11516 - 7792)) and (v120.UnitGroupRole(v17) == "TANK")) then
											if (((445 - (212 + 176)) <= (3628 - (250 + 655))) and v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield))) then
												return "earth_shield_tank main apl";
											end
										end
										break;
									end
									if (((0 - 0) == v249) or ((3617 - 1547) == (692 - 249))) then
										v29 = v120.FocusUnitRefreshableBuff(v116.EarthShield, 1971 - (1869 + 87), 138 - 98, "TANK", true, 1926 - (484 + 1417));
										if (v29 or ((5797 - 3092) == (2333 - 940))) then
											return v29;
										end
										v249 = 774 - (48 + 725);
									end
								end
							end
							v240 = 1 - 0;
						end
						if ((v240 == (2 - 1)) or ((2674 + 1927) < (162 - 101))) then
							if (not v17:BuffDown(v116.EarthShield) or (v120.UnitGroupRole(v17) ~= "TANK") or not v93 or (v120.FriendlyUnitsWithBuffCount(v116.EarthShield, true, false, 7 + 18) >= (1 + 0)) or ((2243 - (152 + 701)) >= (6055 - (430 + 881)))) then
								local v250 = 0 + 0;
								while true do
									if ((v250 == (895 - (557 + 338))) or ((593 + 1410) > (10803 - 6969))) then
										v29 = v120.FocusUnit(v241, nil, nil, nil);
										if (v29 or ((545 - 389) > (10395 - 6482))) then
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
				v194 = 6 - 3;
			end
			if (((996 - (499 + 302)) == (1061 - (39 + 827))) and (v194 == (2 - 1))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v194 = 4 - 2;
			end
		end
	end
	local function v133()
		local v196 = 0 - 0;
		while true do
			if (((4766 - 1661) >= (154 + 1642)) and (v196 == (0 - 0))) then
				v122();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(43 + 221, v132, v133);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

