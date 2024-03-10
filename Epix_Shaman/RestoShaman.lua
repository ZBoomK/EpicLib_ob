local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5818 - 4246) >= (4096 - 2565)) and ((541 - (133 + 407)) == v5)) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((6825 - 2138) < (1185 + 3357))) then
			v6 = v0[v4];
			if (((11646 - 8355) > (803 + 864)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 797 - (588 + 208);
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
	local v119 = 29946 - 18835;
	local v120 = 12911 - (884 + 916);
	local v121;
	v10:RegisterForEvent(function()
		v119 = 23261 - 12150;
		v120 = 6443 + 4668;
	end, "PLAYER_REGEN_ENABLED");
	local v122 = v18.Shaman.Restoration;
	local v123 = v25.Shaman.Restoration;
	local v124 = v20.Shaman.Restoration;
	local v125 = {};
	local v126 = v22.Commons.Everyone;
	local v127 = v22.Commons.Shaman;
	local function v128()
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((1526 - (232 + 421)) == (3923 - (1569 + 320)))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v141)
		return v141:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (2 + 3));
	end
	local function v130()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (3 - 2)) or ((3421 - (316 + 289)) < (28 - 17))) then
				if (((171 + 3528) < (6159 - (666 + 787))) and v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
					if (((3071 - (360 + 65)) >= (819 + 57)) and v24(v123.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((868 - (79 + 175)) <= (5019 - 1835)) and v38 and (v13:HealthPercentage() <= v39)) then
					local v253 = 0 + 0;
					while true do
						if (((9581 - 6455) == (6019 - 2893)) and (v253 == (899 - (503 + 396)))) then
							if ((v40 == "Refreshing Healing Potion") or ((2368 - (92 + 89)) >= (9610 - 4656))) then
								if (v124.RefreshingHealingPotion:IsReady() or ((1989 + 1888) == (2116 + 1459))) then
									if (((2768 - 2061) > (87 + 545)) and v24(v123.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v40 == "Dreamwalker's Healing Potion") or ((1244 - 698) >= (2342 + 342))) then
								if (((700 + 765) <= (13099 - 8798)) and v124.DreamwalkersHealingPotion:IsReady()) then
									if (((213 + 1491) > (2173 - 748)) and v24(v123.RefreshingHealingPotion)) then
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
			if (((1244 - (485 + 759)) == v142) or ((1589 - 902) == (5423 - (442 + 747)))) then
				if ((v93 and v122.AstralShift:IsReady()) or ((4465 - (832 + 303)) < (2375 - (88 + 858)))) then
					if (((350 + 797) >= (278 + 57)) and (v13:HealthPercentage() <= v59)) then
						if (((142 + 3293) > (2886 - (766 + 23))) and v24(v122.AstralShift, not v15:IsInRange(197 - 157))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v96 and v122.EarthElemental:IsReady()) or ((5156 - 1386) >= (10646 - 6605))) then
					if ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 84 - 59, v122.ChainHeal) or ((4864 - (1036 + 37)) <= (1143 + 468))) then
						if (v24(v122.EarthElemental, not v15:IsInRange(77 - 37)) or ((3602 + 976) <= (3488 - (641 + 839)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 914 - (910 + 3);
			end
		end
	end
	local function v131()
		if (((2867 - 1742) <= (3760 - (1466 + 218))) and v114) then
			v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 14 + 16, true);
			if (v29 or ((1891 - (556 + 592)) >= (1565 + 2834))) then
				return v29;
			end
		end
		if (((1963 - (329 + 479)) < (2527 - (174 + 680))) and v113) then
			local v241 = 0 - 0;
			while true do
				if ((v241 == (0 - 0)) or ((1660 + 664) <= (1317 - (396 + 343)))) then
					v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 3 + 27);
					if (((5244 - (29 + 1448)) == (5156 - (135 + 1254))) and v29) then
						return v29;
					end
					v241 = 3 - 2;
				end
				if (((19091 - 15002) == (2726 + 1363)) and (v241 == (1528 - (389 + 1138)))) then
					if (((5032 - (102 + 472)) >= (1580 + 94)) and v115) then
						local v258 = 0 + 0;
						while true do
							if (((907 + 65) <= (2963 - (320 + 1225))) and (v258 == (0 - 0))) then
								v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 19 + 11);
								if (v29 or ((6402 - (157 + 1307)) < (6621 - (821 + 1038)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (v116 or ((6247 - 3743) > (467 + 3797))) then
						local v259 = 0 - 0;
						while true do
							if (((802 + 1351) == (5336 - 3183)) and (v259 == (1026 - (834 + 192)))) then
								v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 2 + 28);
								if (v29 or ((131 + 376) >= (56 + 2535))) then
									return v29;
								end
								break;
							end
						end
					end
					v241 = 2 - 0;
				end
				if (((4785 - (300 + 4)) == (1197 + 3284)) and (v241 == (5 - 3))) then
					if (v122.PurifySpirit:CooldownRemains() or ((2690 - (112 + 250)) < (277 + 416))) then
						local v260 = 0 - 0;
						while true do
							if (((2480 + 1848) == (2239 + 2089)) and (v260 == (0 + 0))) then
								v29 = v126.HandleAfflicted(v122.HealingSurge, v123.HealingSurgeMouseover, 15 + 15);
								if (((1180 + 408) >= (2746 - (1001 + 413))) and v29) then
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
		if (v41 or ((9307 - 5133) > (5130 - (244 + 638)))) then
			local v242 = 693 - (627 + 66);
			while true do
				if ((v242 == (2 - 1)) or ((5188 - (512 + 90)) <= (1988 - (1665 + 241)))) then
					v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 757 - (373 + 344));
					if (((1743 + 2120) == (1023 + 2840)) and v29) then
						return v29;
					end
					break;
				end
				if ((v242 == (0 - 0)) or ((476 - 194) <= (1141 - (35 + 1064)))) then
					v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 30 + 10);
					if (((9860 - 5251) >= (4 + 762)) and v29) then
						return v29;
					end
					v242 = 1237 - (298 + 938);
				end
			end
		end
		if (v42 or ((2411 - (233 + 1026)) == (4154 - (636 + 1030)))) then
			local v243 = 0 + 0;
			while true do
				if (((3343 + 79) > (996 + 2354)) and (v243 == (1 + 1))) then
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 261 - (55 + 166));
					if (((170 + 707) > (38 + 338)) and v29) then
						return v29;
					end
					v243 = 11 - 8;
				end
				if ((v243 == (300 - (36 + 261))) or ((5452 - 2334) <= (3219 - (34 + 1334)))) then
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 16 + 24);
					if (v29 or ((129 + 36) >= (4775 - (1035 + 248)))) then
						return v29;
					end
					break;
				end
				if (((3970 - (20 + 1)) < (2530 + 2326)) and (v243 == (319 - (134 + 185)))) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 1173 - (549 + 584));
					if (v29 or ((4961 - (314 + 371)) < (10353 - 7337))) then
						return v29;
					end
					v243 = 969 - (478 + 490);
				end
				if (((2485 + 2205) > (5297 - (786 + 386))) and (v243 == (3 - 2))) then
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 1419 - (1055 + 324));
					if (v29 or ((1390 - (1093 + 247)) >= (797 + 99))) then
						return v29;
					end
					v243 = 1 + 1;
				end
			end
		end
		if (v43 or ((6804 - 5090) >= (10038 - 7080))) then
			v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 113 - 73);
			if (v29 or ((3746 - 2255) < (230 + 414))) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 154 - 114);
			if (((2426 - 1722) < (745 + 242)) and v29) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 102 - 62);
			if (((4406 - (364 + 324)) > (5224 - 3318)) and v29) then
				return v29;
			end
			v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 95 - 55);
			if (v29 or ((318 + 640) > (15209 - 11574))) then
				return v29;
			end
		end
		if (((5606 - 2105) <= (13642 - 9150)) and v44) then
			local v244 = 1268 - (1249 + 19);
			while true do
				if ((v244 == (0 + 0)) or ((13397 - 9955) < (3634 - (686 + 400)))) then
					v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 32 + 8);
					if (((3104 - (73 + 156)) >= (7 + 1457)) and v29) then
						return v29;
					end
					v244 = 812 - (721 + 90);
				end
				if ((v244 == (1 + 0)) or ((15575 - 10778) >= (5363 - (224 + 246)))) then
					v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 64 - 24);
					if (v29 or ((1014 - 463) > (376 + 1692))) then
						return v29;
					end
					v244 = 1 + 1;
				end
				if (((1553 + 561) > (1876 - 932)) and (v244 == (6 - 4))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 553 - (203 + 310));
					if (v29 or ((4255 - (1238 + 755)) >= (217 + 2879))) then
						return v29;
					end
					v244 = 1537 - (709 + 825);
				end
				if ((v244 == (4 - 1)) or ((3284 - 1029) >= (4401 - (196 + 668)))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 157 - 117);
					if (v29 or ((7947 - 4110) < (2139 - (171 + 662)))) then
						return v29;
					end
					break;
				end
			end
		end
	end
	local function v132()
		local v143 = 93 - (4 + 89);
		while true do
			if (((10339 - 7389) == (1075 + 1875)) and (v143 == (4 - 3))) then
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1853 + 2870) < (4784 - (35 + 1451)))) then
					if (((2589 - (28 + 1425)) >= (2147 - (941 + 1052))) and (v17:HealthPercentage() <= v83)) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((260 + 11) > (6262 - (822 + 692)))) then
							return "riptide healingcd";
						end
					end
				end
				if (((6767 - 2027) >= (1485 + 1667)) and v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) then
					if ((v87 == "Player") or ((2875 - (45 + 252)) >= (3355 + 35))) then
						if (((15 + 26) <= (4042 - 2381)) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(473 - (114 + 319)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((862 - 261) < (4561 - 1001)) and (v87 == "Friendly under Cursor")) then
						if (((150 + 85) < (1022 - 335)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((9531 - 4982) > (3116 - (556 + 1407))) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(1246 - (741 + 465)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v87 == "Confirmation") or ((5139 - (170 + 295)) < (2462 + 2210))) then
						if (((3370 + 298) < (11229 - 6668)) and v24(v122.SpiritLinkTotem, not v15:IsInRange(34 + 6))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v143 = 2 + 0;
			end
			if ((v143 == (0 + 0)) or ((1685 - (957 + 273)) == (965 + 2640))) then
				if ((v111 and ((v31 and v110) or not v110)) or ((1067 + 1596) == (12620 - 9308))) then
					local v254 = 0 - 0;
					while true do
						if (((13063 - 8786) <= (22158 - 17683)) and (v254 == (1780 - (389 + 1391)))) then
							v29 = v126.HandleTopTrinket(v125, v31, 26 + 14, nil);
							if (v29 or ((91 + 779) == (2706 - 1517))) then
								return v29;
							end
							v254 = 952 - (783 + 168);
						end
						if (((5211 - 3658) <= (3082 + 51)) and (v254 == (312 - (309 + 2)))) then
							v29 = v126.HandleBottomTrinket(v125, v31, 122 - 82, nil);
							if (v29 or ((3449 - (1090 + 122)) >= (1139 + 2372))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((4446 - 3122) > (2067 + 953))) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((4110 - (628 + 490)) == (338 + 1543))) then
						if (((7689 - 4583) > (6973 - 5447)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingcd tank";
						end
					end
				end
				v143 = 775 - (431 + 343);
			end
			if (((6105 - 3082) < (11195 - 7325)) and (v143 == (4 + 0))) then
				if (((19 + 124) > (1769 - (556 + 1139))) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
					if (((33 - (6 + 9)) < (387 + 1725)) and v24(v122.ManaTideTotem, not v15:IsInRange(21 + 19))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((1266 - (28 + 141)) <= (631 + 997)) and v35 and ((v109 and v31) or not v109)) then
					local v255 = 0 - 0;
					while true do
						if (((3280 + 1350) == (5947 - (486 + 831))) and (v255 == (5 - 3))) then
							if (((12463 - 8923) > (507 + 2176)) and v122.Fireblood:IsReady()) then
								if (((15158 - 10364) >= (4538 - (668 + 595))) and v24(v122.Fireblood, not v15:IsInRange(36 + 4))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((300 + 1184) == (4046 - 2562)) and (v255 == (291 - (23 + 267)))) then
							if (((3376 - (1129 + 815)) < (3942 - (371 + 16))) and v122.Berserking:IsReady()) then
								if (v24(v122.Berserking, not v15:IsInRange(1790 - (1326 + 424))) or ((2016 - 951) > (13074 - 9496))) then
									return "Berserking cooldowns";
								end
							end
							if (v122.BloodFury:IsReady() or ((4913 - (88 + 30)) < (2178 - (720 + 51)))) then
								if (((4121 - 2268) < (6589 - (421 + 1355))) and v24(v122.BloodFury, not v15:IsInRange(65 - 25))) then
									return "BloodFury cooldowns";
								end
							end
							v255 = 1 + 1;
						end
						if ((v255 == (1083 - (286 + 797))) or ((10312 - 7491) < (4026 - 1595))) then
							if (v122.AncestralCall:IsReady() or ((3313 - (397 + 42)) < (682 + 1499))) then
								if (v24(v122.AncestralCall, not v15:IsInRange(840 - (24 + 776))) or ((4142 - 1453) <= (1128 - (222 + 563)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v122.BagofTricks:IsReady() or ((4117 - 2248) == (1447 + 562))) then
								if (v24(v122.BagofTricks, not v15:IsInRange(230 - (23 + 167))) or ((5344 - (690 + 1108)) < (838 + 1484))) then
									return "BagofTricks cooldowns";
								end
							end
							v255 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v143 == (850 - (40 + 808))) or ((343 + 1739) == (18251 - 13478))) then
				if (((3101 + 143) > (559 + 496)) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) then
					if (v24(v122.HealingTideTotem, not v15:IsInRange(22 + 18)) or ((3884 - (47 + 524)) <= (1154 + 624))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) or ((3884 - 2463) >= (3145 - 1041))) then
					if (((4132 - 2320) <= (4975 - (1165 + 561))) and (v56 == "Player")) then
						if (((49 + 1574) <= (6061 - 4104)) and v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(16 + 24))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((4891 - (341 + 138)) == (1191 + 3221)) and (v56 == "Friendly under Cursor")) then
						if (((3611 - 1861) >= (1168 - (89 + 237))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((14064 - 9692) > (3894 - 2044)) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(921 - (581 + 300)))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((1452 - (855 + 365)) < (1949 - 1128)) and (v56 == "Confirmation")) then
						if (((170 + 348) < (2137 - (1030 + 205))) and v24(v122.AncestralProtectionTotem, not v15:IsInRange(38 + 2))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v143 = 3 + 0;
			end
			if (((3280 - (156 + 130)) > (1949 - 1091)) and (v143 == (4 - 1))) then
				if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) or ((7690 - 3935) <= (242 + 673))) then
					if (((2302 + 1644) > (3812 - (10 + 59))) and v24(v122.AncestralGuidance, not v15:IsInRange(12 + 28))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) or ((6574 - 5239) >= (4469 - (671 + 492)))) then
					if (((3857 + 987) > (3468 - (369 + 846))) and v24(v122.Ascendance, not v15:IsInRange(11 + 29))) then
						return "ascendance cooldowns";
					end
				end
				v143 = 4 + 0;
			end
		end
	end
	local function v133()
		if (((2397 - (1036 + 909)) == (360 + 92)) and v94 and v126.AreUnitsBelowHealthPercentage(159 - 64, 206 - (11 + 192), v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
			if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2303 + 2254) < (2262 - (135 + 40)))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((9386 - 5512) == (2336 + 1538)) and v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (32 - 17))) then
			if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2905 - 967) > (5111 - (50 + 126)))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((11848 - 7593) < (758 + 2665))) then
			if (((2867 - (1233 + 180)) <= (3460 - (522 + 447))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((5578 - (107 + 1314)) <= (1301 + 1502))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if (((14787 - 9934) >= (1267 + 1715)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((8208 - 4074) > (13282 - 9925)) and (v17:HealthPercentage() <= v83)) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((5327 - (716 + 1194)) < (44 + 2490))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v105 and v122.UnleashLife:IsReady()) or ((292 + 2430) <= (667 - (74 + 429)))) then
			if ((v13:HealthPercentage() <= v90) or ((4644 - 2236) < (1046 + 1063))) then
				if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((75 - 42) == (1030 + 425))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) or ((1365 - 922) >= (9927 - 5912))) then
			if (((3815 - (279 + 154)) > (944 - (454 + 324))) and v24(v123.HealingRainCursor, not v15:IsInRange(32 + 8), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) or ((297 - (12 + 5)) == (1650 + 1409))) then
			if (((4792 - 2911) > (478 + 815)) and (v74 == "Player")) then
				if (((3450 - (277 + 816)) == (10071 - 7714)) and v24(v123.HealingRainPlayer, not v15:IsInRange(1223 - (1058 + 125)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif (((24 + 99) == (1098 - (815 + 160))) and (v74 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((4530 - 3474) >= (8051 - 4659))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(10 + 30), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3159 - 2078) < (2973 - (41 + 1857)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v74 == "Enemy under Cursor") or ((2942 - (1222 + 671)) >= (11454 - 7022))) then
				if ((v16:Exists() and v13:CanAttack(v16)) or ((6853 - 2085) <= (2028 - (229 + 953)))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(1814 - (1111 + 663)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4937 - (874 + 705)) <= (199 + 1221))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v74 == "Confirmation") or ((2552 + 1187) <= (6246 - 3241))) then
				if (v24(v122.HealingRain, not v15:IsInRange(2 + 38), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2338 - (642 + 37)) >= (487 + 1647))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) or ((522 + 2738) < (5912 - 3557))) then
			if ((v71 == "Player") or ((1123 - (233 + 221)) == (9765 - 5542))) then
				if (v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(36 + 4)) or ((3233 - (718 + 823)) < (371 + 217))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v71 == "Friendly under Cursor") or ((5602 - (266 + 539)) < (10336 - 6685))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((5402 - (636 + 589)) > (11512 - 6662))) then
					if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(82 - 42)) or ((317 + 83) > (404 + 707))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((4066 - (657 + 358)) > (2661 - 1656)) and (v71 == "Confirmation")) then
				if (((8413 - 4720) <= (5569 - (1151 + 36))) and v24(v122.EarthenWallTotem, not v15:IsInRange(39 + 1))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) or ((863 + 2419) > (12244 - 8144))) then
			if ((v66 == "Player") or ((5412 - (1552 + 280)) < (3678 - (64 + 770)))) then
				if (((61 + 28) < (10192 - 5702)) and v24(v123.DownpourPlayer, not v15:IsInRange(8 + 32), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v66 == "Friendly under Cursor") or ((6226 - (157 + 1086)) < (3618 - 1810))) then
				if (((16769 - 12940) > (5780 - 2011)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((2026 - 541) <= (3723 - (599 + 220))) and v24(v123.DownpourCursor, not v15:IsInRange(79 - 39), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif (((6200 - (1813 + 118)) == (3121 + 1148)) and (v66 == "Confirmation")) then
				if (((1604 - (841 + 376)) <= (3897 - 1115)) and v24(v122.Downpour, not v15:IsInRange(10 + 30), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (27 - 17))) or ((2758 - (464 + 395)) <= (2353 - 1436))) then
			if (v24(v122.CloudburstTotem) or ((2071 + 2241) <= (1713 - (467 + 370)))) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((4612 - 2380) <= (1906 + 690)) and v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) then
			if (((7181 - 5086) < (576 + 3110)) and v24(v122.Wellspring, not v15:IsInRange(93 - 53), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) or ((2115 - (150 + 370)) >= (5756 - (74 + 1208)))) then
			if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((11360 - 6741) < (13668 - 10786))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) or ((210 + 84) >= (5221 - (14 + 376)))) then
			if (((3518 - 1489) <= (1996 + 1088)) and v24(v122.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) or ((1790 + 247) == (2308 + 112))) then
			if (((13062 - 8604) > (2937 + 967)) and v24(v122.HealingStreamTotem, nil)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v134()
		local v144 = 78 - (23 + 55);
		while true do
			if (((1033 - 597) >= (83 + 40)) and (v144 == (0 + 0))) then
				if (((775 - 275) < (572 + 1244)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((4475 - (652 + 249)) == (9564 - 5990)) and (v17:HealthPercentage() <= v83)) then
						if (((2089 - (708 + 1160)) < (1058 - 668)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((4034 - 1821) <= (1448 - (10 + 17)))) then
					if (((687 + 2371) < (6592 - (1400 + 332))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((2485 - 1189) >= (6354 - (242 + 1666)))) then
							return "riptide healingaoe";
						end
					end
				end
				v144 = 1 + 0;
			end
			if ((v144 == (1 + 0)) or ((1188 + 205) > (5429 - (850 + 90)))) then
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) or ((7748 - 3324) < (1417 - (360 + 1030)))) then
					if (v24(v122.EarthShield) or ((1768 + 229) > (10767 - 6952))) then
						return "earth_shield player healingst";
					end
				end
				if (((4766 - 1301) > (3574 - (909 + 752))) and v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) then
					if (((1956 - (109 + 1114)) < (3329 - 1510)) and v126.IsSoloMode()) then
						if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((1711 + 2684) == (4997 - (6 + 236)))) then
							if (v24(v122.LightningShield) or ((2390 + 1403) < (1907 + 462))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) or ((9631 - 5547) == (462 - 197))) then
						if (((5491 - (1076 + 57)) == (717 + 3641)) and v24(v122.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v144 = 691 - (579 + 110);
			end
			if (((1 + 1) == v144) or ((2775 + 363) < (528 + 465))) then
				if (((3737 - (174 + 233)) > (6488 - 4165)) and v99 and v122.HealingSurge:IsReady()) then
					if ((v17:HealthPercentage() <= v77) or ((6364 - 2738) == (1774 + 2215))) then
						if (v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2090 - (663 + 511)) == (2383 + 288))) then
							return "healing_surge healingst";
						end
					end
				end
				if (((60 + 212) == (838 - 566)) and v101 and v122.HealingWave:IsReady()) then
					if (((2574 + 1675) <= (11392 - 6553)) and (v17:HealthPercentage() <= v80)) then
						if (((6722 - 3945) < (1527 + 1673)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v145 = 0 - 0;
		while true do
			if (((68 + 27) < (179 + 1778)) and (v145 == (723 - (478 + 244)))) then
				if (((1343 - (440 + 77)) < (781 + 936)) and v122.FlameShock:IsReady()) then
					local v256 = 0 - 0;
					while true do
						if (((2982 - (655 + 901)) >= (205 + 900)) and (v256 == (0 + 0))) then
							if (((1860 + 894) <= (13612 - 10233)) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(1485 - (695 + 750)), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock)) or ((13409 - 9482) == (2179 - 766))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v122.LavaBurst:IsReady() or ((4640 - 3486) <= (1139 - (285 + 66)))) then
					if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3829 - 2186) > (4689 - (682 + 628)))) then
						return "lava_burst damage";
					end
				end
				v145 = 1 + 1;
			end
			if (((299 - (176 + 123)) == v145) or ((1173 + 1630) > (3300 + 1249))) then
				if (v122.Stormkeeper:IsReady() or ((489 - (239 + 30)) >= (822 + 2200))) then
					if (((2713 + 109) == (4994 - 2172)) and v24(v122.Stormkeeper, not v15:IsInRange(124 - 84))) then
						return "stormkeeper damage";
					end
				end
				if ((math.max(#v13:GetEnemiesInRange(335 - (306 + 9)), v13:GetEnemiesInSplashRangeCount(27 - 19)) > (1 + 1)) or ((651 + 410) == (894 + 963))) then
					if (((7892 - 5132) > (2739 - (1140 + 235))) and v122.ChainLightning:IsReady()) then
						if (v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3120 + 1782) <= (3297 + 298))) then
							return "chain_lightning damage";
						end
					end
				end
				v145 = 1 + 0;
			end
			if ((v145 == (54 - (33 + 19))) or ((1391 + 2461) == (878 - 585))) then
				if (v122.LightningBolt:IsReady() or ((687 + 872) == (8997 - 4409))) then
					if (v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4205 + 279) == (1477 - (586 + 103)))) then
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
		local v235;
		if (((14063 - 9495) >= (5395 - (1309 + 179))) and v13:IsDeadOrGhost()) then
			return;
		end
		if (((2249 - 1003) < (1511 + 1959)) and (v126.TargetIsValid() or v13:AffectingCombat())) then
			local v245 = 0 - 0;
			while true do
				if (((3073 + 995) >= (2064 - 1092)) and (v245 == (0 - 0))) then
					v121 = v13:GetEnemiesInRange(649 - (295 + 314));
					v119 = v10.BossFightRemains(nil, true);
					v245 = 2 - 1;
				end
				if (((2455 - (1300 + 662)) < (12224 - 8331)) and ((1756 - (1178 + 577)) == v245)) then
					v120 = v119;
					if ((v120 == (5771 + 5340)) or ((4354 - 2881) >= (4737 - (851 + 554)))) then
						v120 = v10.FightRemains(v121, false);
					end
					break;
				end
			end
		end
		if (not v13:AffectingCombat() or ((3583 + 468) <= (3208 - 2051))) then
			if (((1311 - 707) < (3183 - (115 + 187))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v248 = 0 + 0;
				local v249;
				while true do
					if ((v248 == (0 + 0)) or ((3546 - 2646) == (4538 - (160 + 1001)))) then
						v249 = v126.DeadFriendlyUnitsCount();
						if (((3901 + 558) > (408 + 183)) and (v249 > (1 - 0))) then
							if (((3756 - (237 + 121)) >= (3292 - (525 + 372))) and v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (v24(v123.AncestralSpiritMouseover, not v15:IsInRange(75 - 35), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((7172 - 4989) >= (2966 - (96 + 46)))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v235 = v131();
		if (((2713 - (643 + 134)) == (699 + 1237)) and v235) then
			return v235;
		end
		if (v13:AffectingCombat() or v30 or ((11585 - 6753) < (16012 - 11699))) then
			local v246 = v45 and v122.PurifySpirit:IsReady() and v32;
			if (((3921 + 167) > (7602 - 3728)) and v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 51 - 26) < (720 - (316 + 403)))) then
				v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 10 + 5, 109 - 69, "TANK", true, 10 + 15, v122.ChainHeal);
				if (((10909 - 6577) == (3070 + 1262)) and v29) then
					return v29;
				end
				if (((1289 + 2710) >= (10048 - 7148)) and (v126.UnitGroupRole(v17) == "TANK")) then
					if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((12059 - 9534) > (8442 - 4378))) then
						return "earth_shield_tank main apl 1";
					end
				end
			end
			if (((251 + 4120) == (8604 - 4233)) and (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 2 + 23) >= (2 - 1)))) then
				local v250 = 17 - (12 + 5);
				while true do
					if ((v250 == (0 - 0)) or ((566 - 300) > (10598 - 5612))) then
						v29 = v126.FocusUnit(v246, nil, 99 - 59, nil, 6 + 19, v122.ChainHeal);
						if (((3964 - (1656 + 317)) >= (825 + 100)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if (((365 + 90) < (5458 - 3405)) and v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(196 - 156) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) then
			if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((1180 - (5 + 349)) == (23041 - 18190))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if (((1454 - (266 + 1005)) == (121 + 62)) and v13:AffectingCombat() and v126.TargetIsValid()) then
			local v247 = 0 - 0;
			while true do
				if (((1525 - 366) <= (3484 - (561 + 1135))) and (v247 == (1 - 0))) then
					v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 98 - 68, true, v16);
					if (v29 or ((4573 - (507 + 559)) > (10835 - 6517))) then
						return v29;
					end
					v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 92 - 62, nil, v16);
					if (v29 or ((3463 - (212 + 176)) <= (3870 - (250 + 655)))) then
						return v29;
					end
					v247 = 5 - 3;
				end
				if (((2385 - 1020) <= (3146 - 1135)) and (v247 == (1958 - (1869 + 87)))) then
					v235 = v130();
					if (v235 or ((9628 - 6852) > (5476 - (484 + 1417)))) then
						return v235;
					end
					if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((5473 - 2919) == (8050 - 3246))) then
						if (((3350 - (48 + 725)) == (4209 - 1632)) and v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge))) then
							return "greater_purge utility";
						end
					end
					if ((v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((15 - 9) >= (1098 + 791))) then
						if (((1352 - 846) <= (530 + 1362)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
							return "purge utility";
						end
					end
					v247 = 1 + 2;
				end
				if ((v247 == (856 - (152 + 701))) or ((3319 - (430 + 881)) > (850 + 1368))) then
					if (((1274 - (557 + 338)) <= (1226 + 2921)) and (v120 > v112)) then
						v235 = v132();
						if (v235 or ((12720 - 8206) <= (3533 - 2524))) then
							return v235;
						end
					end
					break;
				end
				if ((v247 == (0 - 0)) or ((7534 - 4038) == (1993 - (499 + 302)))) then
					if ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady() or ((1074 - (39 + 827)) == (8168 - 5209))) then
						if (((9551 - 5274) >= (5215 - 3902)) and v24(v123.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((3971 - 1384) < (272 + 2902)) and v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) then
						if (v24(v123.ManaPotion, nil) or ((12058 - 7938) <= (352 + 1846))) then
							return "Mana Potion main";
						end
					end
					v29 = v126.Interrupt(v122.WindShear, 47 - 17, true);
					if (v29 or ((1700 - (103 + 1)) == (1412 - (475 + 79)))) then
						return v29;
					end
					v247 = 2 - 1;
				end
			end
		end
		if (((10304 - 7084) == (417 + 2803)) and (v30 or v13:AffectingCombat())) then
			if ((v32 and v45) or ((1234 + 168) > (5123 - (1395 + 108)))) then
				local v251 = 0 - 0;
				while true do
					if (((3778 - (7 + 1197)) == (1123 + 1451)) and (v251 == (0 + 0))) then
						if (((2117 - (27 + 292)) < (8078 - 5321)) and (v122.Bursting:MaxDebuffStack() > (4 - 0))) then
							local v261 = 0 - 0;
							while true do
								if ((v261 == (0 - 0)) or ((717 - 340) > (2743 - (43 + 96)))) then
									v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
									if (((2316 - 1748) < (2059 - 1148)) and v29) then
										return v29;
									end
									break;
								end
							end
						end
						if (((2726 + 559) < (1194 + 3034)) and v17) then
							if (((7739 - 3823) > (1276 + 2052)) and v122.PurifySpirit:IsReady() and v126.UnitHasDispellableDebuffByPlayer(v17)) then
								local v263 = 0 - 0;
								while true do
									if (((788 + 1712) < (282 + 3557)) and ((1751 - (1414 + 337)) == v263)) then
										if (((2447 - (1642 + 298)) == (1321 - 814)) and (v138 == (0 - 0))) then
											v138 = GetTime();
										end
										if (((712 - 472) <= (1042 + 2123)) and v126.Wait(390 + 110, v138)) then
											local v264 = 972 - (357 + 615);
											while true do
												if (((586 + 248) >= (1974 - 1169)) and ((0 + 0) == v264)) then
													if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((8169 - 4357) < (1853 + 463))) then
														return "purify_spirit dispel focus";
													end
													v138 = 0 + 0;
													break;
												end
											end
										end
										break;
									end
								end
							end
						end
						v251 = 1 + 0;
					end
					if ((v251 == (1302 - (384 + 917))) or ((3349 - (128 + 569)) <= (3076 - (1407 + 136)))) then
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((5485 - (687 + 1200)) < (3170 - (556 + 1154)))) then
							if (v122.PurifySpirit:IsCastable() or ((14480 - 10364) < (1287 - (9 + 86)))) then
								if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((3798 - (275 + 146)) <= (147 + 756))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
			if (((4040 - (29 + 35)) >= (1945 - 1506)) and (v122.Bursting:AuraActiveCount() > (8 - 5))) then
				if (((16563 - 12811) == (2444 + 1308)) and (v122.Bursting:MaxDebuffStack() > (1017 - (53 + 959))) and v122.SpiritLinkTotem:IsReady()) then
					if (((4454 - (312 + 96)) > (4677 - 1982)) and (v87 == "Player")) then
						if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(325 - (147 + 138))) or ((4444 - (813 + 86)) == (2890 + 307))) then
							return "spirit_link_totem bursting";
						end
					elseif (((4435 - 2041) > (865 - (18 + 474))) and (v87 == "Friendly under Cursor")) then
						if (((1402 + 2753) <= (13812 - 9580)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(1126 - (860 + 226))) or ((3884 - (121 + 182)) == (428 + 3045))) then
								return "spirit_link_totem bursting";
							end
						end
					elseif (((6235 - (988 + 252)) > (379 + 2969)) and (v87 == "Confirmation")) then
						if (v24(v122.SpiritLinkTotem, not v15:IsInRange(13 + 27)) or ((2724 - (49 + 1921)) > (4614 - (223 + 667)))) then
							return "spirit_link_totem bursting";
						end
					end
				end
				if (((269 - (51 + 1)) >= (97 - 40)) and v94 and v122.ChainHeal:IsReady()) then
					if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal)) or ((4432 - 2362) >= (5162 - (146 + 979)))) then
						return "Chain Heal Spam because of Bursting";
					end
				end
			end
			if (((764 + 1941) == (3310 - (311 + 294))) and (v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) then
				if (((170 - 109) == (26 + 35)) and v122.PrimordialWaveResto:IsCastable()) then
					if (v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto)) or ((2142 - (496 + 947)) >= (2654 - (1233 + 125)))) then
						return "primordial_wave main";
					end
				end
			end
			if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (2 + 1)))) or ((1600 + 183) >= (688 + 2928))) then
				if (v24(v122.TotemicRecall, nil) or ((5558 - (963 + 682)) > (3778 + 749))) then
					return "totemic_recall main";
				end
			end
			if (((5880 - (504 + 1000)) > (551 + 266)) and v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) then
				if (((4427 + 434) > (78 + 746)) and v24(v122.NaturesSwiftness, nil)) then
					return "natures_swiftness main";
				end
			end
			if (v33 or ((2039 - 656) >= (1821 + 310))) then
				local v252 = 0 + 0;
				while true do
					if ((v252 == (183 - (156 + 26))) or ((1081 + 795) >= (3975 - 1434))) then
						if (((1946 - (149 + 15)) <= (4732 - (890 + 70))) and v235) then
							return v235;
						end
						v235 = v134();
						v252 = 119 - (39 + 78);
					end
					if (((482 - (14 + 468)) == v252) or ((10335 - 5635) < (2272 - 1459))) then
						if (((1651 + 1548) < (2433 + 1617)) and v15:Exists() and not v13:CanAttack(v15)) then
							local v262 = 0 + 0;
							while true do
								if ((v262 == (0 + 0)) or ((1298 + 3653) < (8479 - 4049))) then
									if (((95 + 1) == (337 - 241)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
										if ((v15:HealthPercentage() <= v83) or ((70 + 2669) > (4059 - (12 + 39)))) then
											if (v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide)) or ((22 + 1) == (3509 - 2375))) then
												return "riptide healing target";
											end
										end
									end
									if ((v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) or ((9590 - 6897) >= (1219 + 2892))) then
										if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((2272 + 2044) <= (5441 - 3295))) then
											return "unleash_life healing target";
										end
									end
									v262 = 1 + 0;
								end
								if ((v262 == (4 - 3)) or ((5256 - (1596 + 114)) <= (7333 - 4524))) then
									if (((5617 - (164 + 549)) > (3604 - (1059 + 379))) and v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) then
										if (((134 - 25) >= (47 + 43)) and v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
											return "chain_heal healing target";
										end
									end
									if (((840 + 4138) > (3297 - (145 + 247))) and v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) then
										if (v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2483 + 543) <= (1054 + 1226))) then
											return "healing_wave healing target";
										end
									end
									break;
								end
							end
						end
						v235 = v133();
						v252 = 2 - 1;
					end
					if ((v252 == (1 + 1)) or ((1424 + 229) <= (1798 - 690))) then
						if (((3629 - (254 + 466)) > (3169 - (544 + 16))) and v235) then
							return v235;
						end
						break;
					end
				end
			end
			if (((2405 - 1648) > (822 - (294 + 334))) and v34) then
				if (v126.TargetIsValid() or ((284 - (236 + 17)) >= (603 + 795))) then
					local v257 = 0 + 0;
					while true do
						if (((12036 - 8840) <= (23066 - 18194)) and ((0 + 0) == v257)) then
							v235 = v135();
							if (((2740 + 586) == (4120 - (413 + 381))) and v235) then
								return v235;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v140()
		local v236 = 0 + 0;
		while true do
			if (((3047 - 1614) <= (10073 - 6195)) and ((1971 - (582 + 1388)) == v236)) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
			if ((v236 == (0 - 0)) or ((1134 + 449) == (2099 - (326 + 38)))) then
				v128();
				v122.Bursting:RegisterAuraTracking();
				v236 = 2 - 1;
			end
		end
	end
	v22.SetAPL(376 - 112, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

