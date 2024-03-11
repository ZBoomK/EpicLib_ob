local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((751 + 821) > (11801 - 7926))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
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
	local v27 = GetNumGroupMembers;
	local v28;
	local v29 = false;
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
	local v110 = 1387 + 9724;
	local v111 = 16944 - 5833;
	local v112;
	local v113 = v17.Monk.Mistweaver;
	local v114 = v19.Monk.Mistweaver;
	local v115 = v24.Monk.Mistweaver;
	local v116 = {};
	local v117;
	local v118;
	local v119 = v21.Commons.Everyone;
	local v120 = v21.Commons.Monk;
	local function v121()
		if (((5786 - (485 + 759)) == (10509 - 5967)) and v113.ImprovedDetox:IsAvailable()) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellablePoisonDebuffs, v119.DispellableDiseaseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		if ((v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) or ((3859 - (442 + 747)) < (2874 - (832 + 303)))) then
			if (v23(v113.DampenHarm, nil) or ((1278 - (88 + 858)) >= (1221 + 2782))) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((2724 + 567) <= (136 + 3144))) then
			if (((5175 - (766 + 23)) >= (4309 - 3436)) and v23(v113.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((1259 - 338) <= (2903 - 1801)) and v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) then
			if (((15972 - 11266) >= (2036 - (1036 + 37))) and v23(v113.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) or ((681 + 279) <= (1705 - 829))) then
			if (v23(v115.Healthstone) or ((1626 + 440) == (2412 - (641 + 839)))) then
				return "healthstone defensive 4";
			end
		end
		if (((5738 - (910 + 3)) < (12346 - 7503)) and v85 and (v12:HealthPercentage() <= v86)) then
			if ((v87 == "Refreshing Healing Potion") or ((5561 - (1466 + 218)) >= (2086 + 2451))) then
				if ((v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) or ((5463 - (556 + 592)) < (614 + 1112))) then
					if (v23(v115.RefreshingHealingPotion) or ((4487 - (329 + 479)) < (1479 - (174 + 680)))) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if ((v87 == "Dreamwalker's Healing Potion") or ((15892 - 11267) < (1309 - 677))) then
				if ((v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) or ((60 + 23) > (2519 - (396 + 343)))) then
					if (((49 + 497) <= (2554 - (29 + 1448))) and v23(v115.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v123()
		local v137 = 1389 - (135 + 1254);
		while true do
			if ((v137 == (0 - 0)) or ((4650 - 3654) > (2867 + 1434))) then
				if (((5597 - (389 + 1138)) > (1261 - (102 + 472))) and v101) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (0 + 0)) or ((612 + 44) >= (4875 - (320 + 1225)))) then
							v28 = v119.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 53 - 23, true);
							if (v28 or ((1525 + 967) <= (1799 - (157 + 1307)))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((6181 - (821 + 1038)) >= (6391 - 3829)) and v100) then
					v28 = v119.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 4 + 26);
					if (v28 or ((6460 - 2823) >= (1403 + 2367))) then
						return v28;
					end
					if (v113.Detox:CooldownRemains() or ((5896 - 3517) > (5604 - (834 + 192)))) then
						local v243 = 0 + 0;
						while true do
							if ((v243 == (0 + 0)) or ((11 + 472) > (1150 - 407))) then
								v28 = v119.HandleAfflicted(v113.Vivify, v115.VivifyMouseover, 334 - (300 + 4));
								if (((656 + 1798) > (1513 - 935)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v137 = 363 - (112 + 250);
			end
			if (((371 + 559) < (11168 - 6710)) and (v137 == (1 + 0))) then
				if (((343 + 319) <= (727 + 245)) and v102) then
					local v234 = 0 + 0;
					while true do
						if (((3247 + 1123) == (5784 - (1001 + 413))) and (v234 == (2 - 1))) then
							v28 = v119.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 922 - (244 + 638));
							if (v28 or ((5455 - (627 + 66)) <= (2565 - 1704))) then
								return v28;
							end
							break;
						end
						if ((v234 == (602 - (512 + 90))) or ((3318 - (1665 + 241)) == (4981 - (373 + 344)))) then
							v28 = v119.HandleChromie(v113.Riptide, v115.RiptideMouseover, 19 + 21);
							if (v28 or ((839 + 2329) < (5678 - 3525))) then
								return v28;
							end
							v234 = 1 - 0;
						end
					end
				end
				if (v103 or ((6075 - (35 + 1064)) < (970 + 362))) then
					v28 = v119.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 85 - 45);
					if (((19 + 4609) == (5864 - (298 + 938))) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 1299 - (233 + 1026));
					if (v28 or ((1720 - (636 + 1030)) == (202 + 193))) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 40 + 0);
					if (((25 + 57) == (6 + 76)) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 261 - (55 + 166));
					if (v28 or ((113 + 468) < (29 + 253))) then
						return v28;
					end
				end
				v137 = 7 - 5;
			end
			if ((v137 == (299 - (36 + 261))) or ((8059 - 3450) < (3863 - (34 + 1334)))) then
				if (((443 + 709) == (896 + 256)) and v104) then
					local v235 = 1283 - (1035 + 248);
					while true do
						if (((1917 - (20 + 1)) <= (1783 + 1639)) and ((321 - (134 + 185)) == v235)) then
							v28 = v119.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 1173 - (549 + 584));
							if (v28 or ((1675 - (314 + 371)) > (5561 - 3941))) then
								return v28;
							end
							v235 = 971 - (478 + 490);
						end
						if ((v235 == (2 + 1)) or ((2049 - (786 + 386)) > (15206 - 10511))) then
							v28 = v119.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1419 - (1055 + 324));
							if (((4031 - (1093 + 247)) >= (1645 + 206)) and v28) then
								return v28;
							end
							break;
						end
						if ((v235 == (0 + 0)) or ((11850 - 8865) >= (16479 - 11623))) then
							v28 = v119.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 113 - 73);
							if (((10745 - 6469) >= (426 + 769)) and v28) then
								return v28;
							end
							v235 = 3 - 2;
						end
						if (((11139 - 7907) <= (3537 + 1153)) and (v235 == (2 - 1))) then
							v28 = v119.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 728 - (364 + 324));
							if (v28 or ((2455 - 1559) >= (7548 - 4402))) then
								return v28;
							end
							v235 = 1 + 1;
						end
					end
				end
				if (((12808 - 9747) >= (4737 - 1779)) and v105) then
					local v236 = 0 - 0;
					while true do
						if (((4455 - (1249 + 19)) >= (582 + 62)) and ((7 - 5) == v236)) then
							v28 = v119.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 1126 - (686 + 400));
							if (((506 + 138) <= (933 - (73 + 156))) and v28) then
								return v28;
							end
							v236 = 1 + 2;
						end
						if (((1769 - (721 + 90)) > (11 + 936)) and ((9 - 6) == v236)) then
							v28 = v119.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 510 - (224 + 246));
							if (((7276 - 2784) >= (4886 - 2232)) and v28) then
								return v28;
							end
							break;
						end
						if (((625 + 2817) >= (36 + 1467)) and (v236 == (1 + 0))) then
							v28 = v119.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 79 - 39);
							if (v28 or ((10549 - 7379) <= (1977 - (203 + 310)))) then
								return v28;
							end
							v236 = 1995 - (1238 + 755);
						end
						if ((v236 == (0 + 0)) or ((6331 - (709 + 825)) == (8085 - 3697))) then
							v28 = v119.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 58 - 18);
							if (((1415 - (196 + 668)) <= (2688 - 2007)) and v28) then
								return v28;
							end
							v236 = 1 - 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v138 = 833 - (171 + 662);
		while true do
			if (((3370 - (4 + 89)) > (1426 - 1019)) and ((1 + 0) == v138)) then
				if (((20621 - 15926) >= (555 + 860)) and v113.TigerPalm:IsCastable() and v47) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(1491 - (35 + 1451))) or ((4665 - (28 + 1425)) <= (2937 - (941 + 1052)))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if ((v138 == (0 + 0)) or ((4610 - (822 + 692)) <= (2566 - 768))) then
				if (((1666 + 1871) == (3834 - (45 + 252))) and v113.ChiBurst:IsCastable() and v49) then
					if (((3797 + 40) >= (541 + 1029)) and v23(v113.ChiBurst, not v14:IsInRange(97 - 57))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (435 - (114 + 319)))) or ((4235 - 1285) == (4884 - 1072))) then
					if (((3011 + 1712) >= (3453 - 1135)) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(16 - 8))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v138 = 1964 - (556 + 1407);
			end
		end
	end
	local function v125()
		local v139 = 1206 - (741 + 465);
		while true do
			if ((v139 == (465 - (170 + 295))) or ((1069 + 958) > (2620 + 232))) then
				if ((v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (7 - 4)) and v43) or ((942 + 194) > (2769 + 1548))) then
					if (((2689 + 2059) == (5978 - (957 + 273))) and (v42 == "Player")) then
						if (((1000 + 2736) <= (1898 + 2842)) and v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(152 - 112))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v42 == "Cursor") or ((8933 - 5543) <= (9346 - 6286))) then
						if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(198 - 158)) or ((2779 - (389 + 1391)) > (1690 + 1003))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((49 + 414) < (1368 - 767)) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
						if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(991 - (783 + 168))) or ((7326 - 5143) < (676 + 11))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((4860 - (309 + 2)) == (13969 - 9420)) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
						if (((5884 - (1090 + 122)) == (1515 + 3157)) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(134 - 94))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v42 == "Confirmation") or ((2511 + 1157) < (1513 - (628 + 490)))) then
						if (v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(8 + 32)) or ((10314 - 6148) == (2079 - 1624))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v113.TouchofDeath:IsCastable() and v50) or ((5223 - (431 + 343)) == (5378 - 2715))) then
					if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(14 - 9)) or ((3379 + 898) < (383 + 2606))) then
						return "touch_of_death aoe 2";
					end
				end
				v139 = 1696 - (556 + 1139);
			end
			if ((v139 == (18 - (6 + 9))) or ((160 + 710) >= (2126 + 2023))) then
				if (((2381 - (28 + 141)) < (1233 + 1950)) and v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (0 - 0)) and v47 and (v118 >= (3 + 0))) then
					if (((5963 - (486 + 831)) > (7785 - 4793)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(17 - 12))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((271 + 1163) < (9820 - 6714)) and v113.SpinningCraneKick:IsCastable() and v45) then
					if (((2049 - (668 + 595)) < (2721 + 302)) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(2 + 6))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if ((v139 == (5 - 3)) or ((2732 - (23 + 267)) < (2018 - (1129 + 815)))) then
				if (((4922 - (371 + 16)) == (6285 - (1326 + 424))) and v113.SpinningCraneKick:IsCastable() and v45 and (v14:DebuffDown(v113.MysticTouchDebuff) or (v119.EnemiesWithDebuffCount(v113.MysticTouchDebuff) <= (v117 - (1 - 0)))) and v113.MysticTouch:IsAvailable()) then
					if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(29 - 21)) or ((3127 - (88 + 30)) <= (2876 - (720 + 51)))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((4070 - 2240) < (5445 - (421 + 1355))) and v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (4 - 1))) then
					if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(3 + 2)) or ((2513 - (286 + 797)) >= (13204 - 9592))) then
						return "blackout_kick aoe 6";
					end
				end
				v139 = 4 - 1;
			end
			if (((3122 - (397 + 42)) >= (769 + 1691)) and (v139 == (801 - (24 + 776)))) then
				if ((v113.JadefireStomp:IsReady() and v48) or ((2778 - 974) >= (4060 - (222 + 563)))) then
					if (v23(v113.JadefireStomp, not v14:IsInMeleeRange(17 - 9)) or ((1021 + 396) > (3819 - (23 + 167)))) then
						return "JadefireStomp aoe3";
					end
				end
				if (((6593 - (690 + 1108)) > (146 + 256)) and v113.ChiBurst:IsCastable() and v49) then
					if (((3970 + 843) > (4413 - (40 + 808))) and v23(v113.ChiBurst, not v14:IsInRange(7 + 33))) then
						return "chi_burst aoe 4";
					end
				end
				v139 = 7 - 5;
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if (((2070 + 1842) == (2146 + 1766)) and (v140 == (572 - (47 + 524)))) then
				if (((1831 + 990) <= (13186 - 8362)) and v113.RisingSunKick:IsReady() and v46) then
					if (((2598 - 860) <= (5006 - 2811)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(1731 - (1165 + 561)))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((2 + 39) <= (9347 - 6329)) and v113.ChiBurst:IsCastable() and v49) then
					if (((819 + 1326) <= (4583 - (341 + 138))) and v23(v113.ChiBurst, not v14:IsInRange(11 + 29))) then
						return "chi_burst st 4";
					end
				end
				v140 = 3 - 1;
			end
			if (((3015 - (89 + 237)) < (15586 - 10741)) and (v140 == (3 - 1))) then
				if ((v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (884 - (581 + 300))) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) or ((3542 - (855 + 365)) > (6227 - 3605))) then
					if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(2 + 3)) or ((5769 - (1030 + 205)) == (1955 + 127))) then
						return "blackout_kick st 5";
					end
				end
				if ((v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (3 + 0)) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (288 - (156 + 130)))) and v47) or ((3569 - 1998) > (3145 - 1278))) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(10 - 5)) or ((700 + 1954) >= (1748 + 1248))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if (((4047 - (10 + 59)) > (596 + 1508)) and (v140 == (0 - 0))) then
				if (((4158 - (671 + 492)) > (1227 + 314)) and v113.TouchofDeath:IsCastable() and v50) then
					if (((4464 - (369 + 846)) > (253 + 700)) and v23(v113.TouchofDeath, not v14:IsInMeleeRange(5 + 0))) then
						return "touch_of_death st 1";
					end
				end
				if ((v113.JadefireStomp:IsReady() and v48) or ((5218 - (1036 + 909)) > (3636 + 937))) then
					if (v23(v113.JadefireStomp, nil) or ((5289 - 2138) < (1487 - (11 + 192)))) then
						return "JadefireStomp st 2";
					end
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v127()
		local v141 = 175 - (135 + 40);
		while true do
			if ((v141 == (4 - 2)) or ((1116 + 734) == (3368 - 1839))) then
				if (((1230 - 409) < (2299 - (50 + 126))) and v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) then
					if (((2511 - 1609) < (515 + 1810)) and (v16:HealthPercentage() <= v60)) then
						if (((2271 - (1233 + 180)) <= (3931 - (522 + 447))) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if ((v141 == (1421 - (107 + 1314))) or ((1832 + 2114) < (3924 - 2636))) then
				if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (1.8 + 0))) or ((6437 - 3195) == (2243 - 1676))) then
					if ((v16:HealthPercentage() <= v52) or ((2757 - (716 + 1194)) >= (22 + 1241))) then
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((242 + 2011) == (2354 - (74 + 429)))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 48 - 23) > (1 + 0))) or ((4776 - 2689) > (1679 + 693))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(15 - 10)) or ((10990 - 6545) < (4582 - (279 + 154)))) then
						return "RisingSunKick healing st";
					end
				end
				v141 = 779 - (454 + 324);
			end
			if ((v141 == (1 + 0)) or ((1835 - (12 + 5)) == (46 + 39))) then
				if (((1605 - 975) < (786 + 1341)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) then
					if ((v16:HealthPercentage() <= v52) or ((3031 - (277 + 816)) == (10742 - 8228))) then
						if (((5438 - (1058 + 125)) >= (11 + 44)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((3974 - (815 + 160)) > (4959 - 3803)) and v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) then
					if (((5578 - 3228) > (276 + 879)) and (v16:HealthPercentage() <= v56)) then
						if (((11777 - 7748) <= (6751 - (41 + 1857))) and v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v141 = 1895 - (1222 + 671);
			end
		end
	end
	local function v128()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (0 - 0)) or ((1698 - (229 + 953)) > (5208 - (1111 + 663)))) then
				if (((5625 - (874 + 705)) >= (425 + 2608)) and v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 18 + 7) > (1 - 0))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1 + 4)) or ((3398 - (642 + 37)) <= (330 + 1117))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v119.AreUnitsBelowHealthPercentage(v63, v62, v113.EnvelopingMist) or ((662 + 3472) < (9857 - 5931))) then
					local v237 = 454 - (233 + 221);
					while true do
						if ((v237 == (0 - 0)) or ((145 + 19) >= (4326 - (718 + 823)))) then
							if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((331 + 194) == (2914 - (266 + 539)))) then
								if (((93 - 60) == (1258 - (636 + 589))) and v23(v113.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((7249 - 4195) <= (8280 - 4265)) and v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) then
								if (((1483 + 388) < (1229 + 2153)) and v23(v113.ThunderFocusTea, nil)) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v237 = 1016 - (657 + 358);
						end
						if (((3423 - 2130) <= (4934 - 2768)) and (v237 == (1188 - (1151 + 36)))) then
							if ((v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (8 + 0)))) or ((679 + 1900) < (367 - 244))) then
								if (v23(v113.EssenceFont, nil) or ((2678 - (1552 + 280)) >= (3202 - (64 + 770)))) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) or ((2724 + 1288) <= (7622 - 4264))) then
								if (((266 + 1228) <= (4248 - (157 + 1086))) and v23(v113.EssenceFont, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
					end
				end
				v142 = 1 - 0;
			end
			if ((v142 == (4 - 3)) or ((4771 - 1660) == (2912 - 778))) then
				if (((3174 - (599 + 220)) == (4689 - 2334)) and v66 and v113.ZenPulse:IsReady() and v119.AreUnitsBelowHealthPercentage(v68, v67, v113.EnvelopingMist)) then
					if (v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse)) or ((2519 - (1813 + 118)) <= (316 + 116))) then
						return "ZenPulse healing aoe";
					end
				end
				if (((6014 - (841 + 376)) >= (5457 - 1562)) and v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v119.AreUnitsBelowHealthPercentage(v71, v70, v113.EnvelopingMist)) then
					if (((831 + 2746) == (9763 - 6186)) and v23(v113.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v129()
		local v143 = 859 - (464 + 395);
		while true do
			if (((9736 - 5942) > (1774 + 1919)) and (v143 == (837 - (467 + 370)))) then
				if ((v57 and v113.EnvelopingMist:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 51 - 26) < (3 + 0))) or ((4370 - 3095) == (640 + 3460))) then
					v28 = v119.FocusUnitRefreshableBuff(v113.EnvelopingMist, 4 - 2, 560 - (150 + 370), nil, false, 1307 - (74 + 1208), v113.EnvelopingMist);
					if (v28 or ((3912 - 2321) >= (16978 - 13398))) then
						return v28;
					end
					if (((700 + 283) <= (2198 - (14 + 376))) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
				end
				if ((v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 43 - 18) > (2 + 0))) or ((1889 + 261) <= (1142 + 55))) then
					if (((11043 - 7274) >= (883 + 290)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(83 - (23 + 55)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v143 = 2 - 1;
			end
			if (((991 + 494) == (1334 + 151)) and (v143 == (1 - 0))) then
				if ((v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) or ((1043 + 2272) <= (3683 - (652 + 249)))) then
					if (v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist)) or ((2344 - 1468) >= (4832 - (708 + 1160)))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v130()
		if ((v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (8 - 5))) or ((4068 - 1836) > (2524 - (10 + 17)))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(2 + 3)) or ((3842 - (1400 + 332)) <= (636 - 304))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((5594 - (242 + 1666)) > (1358 + 1814)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (2 + 1))) then
			if ((v16:HealthPercentage() <= v58) or ((3813 + 661) < (1760 - (850 + 90)))) then
				if (((7493 - 3214) >= (4272 - (360 + 1030))) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v46 and v113.RisingSunKick:IsReady()) or ((1796 + 233) >= (9937 - 6416))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(6 - 1)) or ((3698 - (909 + 752)) >= (5865 - (109 + 1114)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((3149 - 1429) < (1736 + 2722)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (244 - (6 + 236)))) then
			if ((v16:HealthPercentage() <= v58) or ((275 + 161) > (2432 + 589))) then
				if (((1681 - 968) <= (1479 - 632)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if (((3287 - (1076 + 57)) <= (663 + 3368)) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) then
			if (((5304 - (579 + 110)) == (365 + 4250)) and v23(v113.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v131()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (0 + 0)) or ((4197 - (174 + 233)) == (1396 - 896))) then
				if (((155 - 66) < (99 + 122)) and v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
					if (((3228 - (663 + 511)) >= (1268 + 153)) and v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if (((151 + 541) < (9427 - 6369)) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) then
					if (v23(v113.Revival, nil) or ((1971 + 1283) == (3896 - 2241))) then
						return "Revival CD";
					end
				end
				v144 = 2 - 1;
			end
			if ((v144 == (1 + 0)) or ((2522 - 1226) == (3500 + 1410))) then
				if (((308 + 3060) == (4090 - (478 + 244))) and v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) then
					if (((3160 - (440 + 77)) < (1735 + 2080)) and v23(v113.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((7001 - 5088) > (2049 - (655 + 901))) and v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v119.AreUnitsBelowHealthPercentage(v74, v73, v113.EnvelopingMist)) then
					local v238 = 0 + 0;
					while true do
						if (((3641 + 1114) > (2315 + 1113)) and ((3 - 2) == v238)) then
							if (((2826 - (695 + 750)) <= (8089 - 5720)) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (30 - 10))) then
								if (v23(v113.SheilunsGift, nil) or ((19477 - 14634) == (4435 - (285 + 66)))) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if (((10883 - 6214) > (1673 - (682 + 628))) and v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((303 - (176 + 123)) * v12:GCD()))) then
								if (v23(v113.InvokeYulonTheJadeSerpent, nil) or ((786 + 1091) >= (2277 + 861))) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
						if (((5011 - (239 + 30)) >= (986 + 2640)) and (v238 == (0 + 0))) then
							if ((v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 - 0))) or ((14164 - 9624) == (1231 - (306 + 9)))) then
								local v251 = 0 - 0;
								while true do
									if ((v251 == (0 + 0)) or ((710 + 446) > (2092 + 2253))) then
										v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 16 - 10, 1415 - (1140 + 235), nil, false, 16 + 9, v113.EnvelopingMist);
										if (((2052 + 185) < (1091 + 3158)) and v28) then
											return v28;
										end
										v251 = 53 - (33 + 19);
									end
									if ((v251 == (1 + 0)) or ((8041 - 5358) < (11 + 12))) then
										if (((1366 - 669) <= (775 + 51)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
											return "Renewing Mist YuLon prep";
										end
										break;
									end
								end
							end
							if (((1794 - (586 + 103)) <= (108 + 1068)) and v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (9 - 6)) and v12:BuffDown(v113.ManaTeaBuff)) then
								if (((4867 - (1309 + 179)) <= (6881 - 3069)) and v23(v113.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v238 = 1 + 0;
						end
					end
				end
				v144 = 5 - 3;
			end
			if (((3 + 0) == v144) or ((1673 - 885) >= (3219 - 1603))) then
				if (((2463 - (295 + 314)) <= (8299 - 4920)) and (v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1987 - (1300 + 662)))) then
					local v239 = 0 - 0;
					while true do
						if (((6304 - (1178 + 577)) == (2363 + 2186)) and (v239 == (0 - 0))) then
							v28 = v130();
							if (v28 or ((4427 - (851 + 554)) >= (2675 + 349))) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
			if (((13367 - 8547) > (4773 - 2575)) and ((304 - (115 + 187)) == v144)) then
				if ((v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (20 + 5)) or ((1005 + 56) >= (19273 - 14382))) then
					local v240 = 1161 - (160 + 1001);
					while true do
						if (((1194 + 170) <= (3087 + 1386)) and (v240 == (0 - 0))) then
							v28 = v129();
							if (v28 or ((3953 - (237 + 121)) <= (900 - (525 + 372)))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v77, v76, v113.EnvelopingMist)) or ((8857 - 4185) == (12655 - 8803))) then
					if (((1701 - (96 + 46)) == (2336 - (643 + 134))) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 + 0))) then
						v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 14 - 8, 148 - 108, nil, false, 24 + 1, v113.EnvelopingMist);
						if (v28 or ((3438 - 1686) <= (1610 - 822))) then
							return v28;
						end
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((4626 - (316 + 403)) == (118 + 59))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if (((9540 - 6070) > (201 + 354)) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (50 - 30))) then
						if (v23(v113.SheilunsGift, nil) or ((689 + 283) == (208 + 437))) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					if (((11025 - 7843) >= (10100 - 7985)) and v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 - 0)) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (1 + 2)) and (v113.SheilunsGift:TimeSinceLastCast() < ((7 - 3) * v12:GCD()))) then
						if (((191 + 3702) < (13030 - 8601)) and v23(v113.InvokeChiJiTheRedCrane, nil)) then
							return "Invoke Chi'ji GO";
						end
					end
				end
				v144 = 20 - (12 + 5);
			end
		end
	end
	local function v132()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (8 - 4)) or ((6093 - 3226) < (4724 - 2819))) then
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v145 = 2 + 3;
			end
			if ((v145 == (1975 - (1656 + 317))) or ((1601 + 195) >= (3247 + 804))) then
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v145 = 7 - 4;
			end
			if (((7967 - 6348) <= (4110 - (5 + 349))) and ((14 - 11) == v145)) then
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v145 = 1275 - (266 + 1005);
			end
			if (((399 + 205) == (2060 - 1456)) and (v145 == (0 - 0))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v145 = 1697 - (561 + 1135);
			end
			if ((v145 == (6 - 1)) or ((14739 - 10255) == (1966 - (507 + 559)))) then
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v145 = 14 - 8;
			end
			if ((v145 == (18 - 12)) or ((4847 - (212 + 176)) <= (2018 - (250 + 655)))) then
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v145 = 19 - 12;
			end
			if (((6345 - 2713) > (5315 - 1917)) and (v145 == (1963 - (1869 + 87)))) then
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((14158 - 10076) <= (6818 - (484 + 1417))) and (v145 == (2 - 1))) then
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v145 = 2 - 0;
			end
		end
	end
	local function v133()
		local v146 = 773 - (48 + 725);
		while true do
			if (((7893 - 3061) >= (3718 - 2332)) and (v146 == (4 + 2))) then
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((365 - 228) == (39 + 98)) and (v146 == (1 + 0))) then
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v146 = 855 - (152 + 701);
			end
			if ((v146 == (1311 - (430 + 881))) or ((602 + 968) >= (5227 - (557 + 338)))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v99 = EpicSettings.Settings['useWeapon'];
				v146 = 1 + 0;
			end
			if (((14 - 9) == v146) or ((14231 - 10167) <= (4832 - 3013))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v146 = 12 - 6;
			end
			if ((v146 == (804 - (499 + 302))) or ((5852 - (39 + 827)) < (4344 - 2770))) then
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleChromie'];
				v146 = 8 - 4;
			end
			if (((17579 - 13153) > (263 - 91)) and (v146 == (1 + 1))) then
				v106 = EpicSettings.Settings['useManaPotion'];
				v107 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['RevivalBurstingGroup'];
				v109 = EpicSettings.Settings['RevivalBurstingStacks'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v146 = 8 - 5;
			end
			if (((94 + 492) > (719 - 264)) and (v146 == (108 - (103 + 1)))) then
				v104 = EpicSettings.Settings['HandleCharredBrambles'];
				v103 = EpicSettings.Settings['HandleCharredTreant'];
				v105 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v146 = 559 - (475 + 79);
			end
		end
	end
	local v134 = 0 - 0;
	local function v135()
		local v147 = 0 - 0;
		while true do
			if (((107 + 719) == (727 + 99)) and (v147 == (1507 - (1395 + 108)))) then
				v28 = v123();
				if (v28 or ((11694 - 7675) > (5645 - (7 + 1197)))) then
					return v28;
				end
				if (((880 + 1137) < (1487 + 2774)) and (v12:AffectingCombat() or v29)) then
					local v241 = v88 and v113.Detox:IsReady() and v32;
					v28 = v119.FocusUnit(v241, nil, 359 - (27 + 292), nil, 72 - 47, v113.EnvelopingMist);
					if (((6013 - 1297) > (335 - 255)) and v28) then
						return v28;
					end
					if ((v32 and v88) or ((6915 - 3408) == (6231 - 2959))) then
						local v244 = 139 - (43 + 96);
						while true do
							if ((v244 == (0 - 0)) or ((1980 - 1104) >= (2552 + 523))) then
								if (((1229 + 3123) > (5047 - 2493)) and v16 and v16:Exists() and v16:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v16)) then
									if (v113.Detox:IsCastable() or ((1689 + 2717) < (7576 - 3533))) then
										local v252 = 0 + 0;
										while true do
											if ((v252 == (0 + 0)) or ((3640 - (1414 + 337)) >= (5323 - (1642 + 298)))) then
												if (((4931 - 3039) <= (7865 - 5131)) and (v134 == (0 - 0))) then
													v134 = GetTime();
												end
												if (((633 + 1290) < (1726 + 492)) and v119.Wait(1472 - (357 + 615), v134)) then
													local v253 = 0 + 0;
													while true do
														if (((5331 - 3158) > (325 + 54)) and ((0 - 0) == v253)) then
															if (v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox)) or ((2073 + 518) == (232 + 3177))) then
																return "detox dispel focus";
															end
															v134 = 0 + 0;
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								if (((5815 - (384 + 917)) > (4021 - (128 + 569))) and v15 and v15:Exists() and v15:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v15)) then
									if (v113.Detox:IsCastable() or ((1751 - (1407 + 136)) >= (6715 - (687 + 1200)))) then
										if (v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox)) or ((3293 - (556 + 1154)) > (12548 - 8981))) then
											return "detox dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
				end
				v147 = 100 - (9 + 86);
			end
			if ((v147 == (427 - (275 + 146))) or ((214 + 1099) == (858 - (29 + 35)))) then
				if (((14066 - 10892) > (8667 - 5765)) and (v29 or v12:AffectingCombat()) and v119.TargetIsValid() and v12:CanAttack(v14)) then
					v28 = v122();
					if (((18187 - 14067) <= (2775 + 1485)) and v28) then
						return v28;
					end
					if ((v96 and ((v31 and v97) or not v97)) or ((1895 - (53 + 959)) > (5186 - (312 + 96)))) then
						local v245 = 0 - 0;
						while true do
							if (((285 - (147 + 138)) == v245) or ((4519 - (813 + 86)) >= (4420 + 471))) then
								v28 = v119.HandleTopTrinket(v116, v31, 74 - 34, nil);
								if (((4750 - (18 + 474)) > (317 + 620)) and v28) then
									return v28;
								end
								v245 = 3 - 2;
							end
							if ((v245 == (1087 - (860 + 226))) or ((5172 - (121 + 182)) < (112 + 794))) then
								v28 = v119.HandleBottomTrinket(v116, v31, 1280 - (988 + 252), nil);
								if (v28 or ((139 + 1086) > (1325 + 2903))) then
									return v28;
								end
								break;
							end
						end
					end
					if (((5298 - (49 + 1921)) > (3128 - (223 + 667))) and v34) then
						if (((3891 - (51 + 1)) > (2418 - 1013)) and v94 and ((v31 and v95) or not v95) and (v111 < (38 - 20))) then
							if (v113.BloodFury:IsCastable() or ((2418 - (146 + 979)) <= (144 + 363))) then
								if (v23(v113.BloodFury, nil) or ((3501 - (311 + 294)) < (2244 - 1439))) then
									return "blood_fury main 4";
								end
							end
							if (((982 + 1334) == (3759 - (496 + 947))) and v113.Berserking:IsCastable()) then
								if (v23(v113.Berserking, nil) or ((3928 - (1233 + 125)) == (623 + 910))) then
									return "berserking main 6";
								end
							end
							if (v113.LightsJudgment:IsCastable() or ((793 + 90) == (278 + 1182))) then
								if (v23(v113.LightsJudgment, not v14:IsInRange(1685 - (963 + 682))) or ((3855 + 764) <= (2503 - (504 + 1000)))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((2297 + 1113) > (3749 + 367))) then
								if (v23(v113.Fireblood, nil) or ((86 + 817) >= (4510 - 1451))) then
									return "fireblood main 10";
								end
							end
							if (v113.AncestralCall:IsCastable() or ((3397 + 579) < (1662 + 1195))) then
								if (((5112 - (156 + 26)) > (1330 + 977)) and v23(v113.AncestralCall, nil)) then
									return "ancestral_call main 12";
								end
							end
							if (v113.BagofTricks:IsCastable() or ((6329 - 2283) < (1455 - (149 + 15)))) then
								if (v23(v113.BagofTricks, not v14:IsInRange(1000 - (890 + 70))) or ((4358 - (39 + 78)) == (4027 - (14 + 468)))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if ((v37 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) or ((8901 - 4853) > (11828 - 7596))) then
							if (v23(v113.ThunderFocusTea, nil) or ((903 + 847) >= (2086 + 1387))) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((673 + 2493) == (1430 + 1736)) and (v118 >= (1 + 2)) and v30) then
							local v249 = 0 - 0;
							while true do
								if (((1743 + 20) < (13085 - 9361)) and (v249 == (0 + 0))) then
									v28 = v125();
									if (((108 - (12 + 39)) <= (2534 + 189)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if ((v118 < (9 - 6)) or ((7372 - 5302) == (132 + 311))) then
							local v250 = 0 + 0;
							while true do
								if (((0 - 0) == v250) or ((1802 + 903) == (6732 - 5339))) then
									v28 = v126();
									if (v28 or ((6311 - (1596 + 114)) < (159 - 98))) then
										return v28;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if ((v147 == (716 - (164 + 549))) or ((2828 - (1059 + 379)) >= (5890 - 1146))) then
				v117 = v12:GetEnemiesInMeleeRange(5 + 3);
				if (v30 or ((338 + 1665) > (4226 - (145 + 247)))) then
					v118 = #v117;
				else
					v118 = 1 + 0;
				end
				if (v119.TargetIsValid() or v12:AffectingCombat() or ((73 + 83) > (11600 - 7687))) then
					v112 = v12:GetEnemiesInRange(8 + 32);
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					if (((168 + 27) == (316 - 121)) and (v111 == (11831 - (254 + 466)))) then
						v111 = v9.FightRemains(v112, false);
					end
				end
				v147 = 564 - (544 + 16);
			end
			if (((9867 - 6762) >= (2424 - (294 + 334))) and (v147 == (253 - (236 + 17)))) then
				v132();
				v133();
				v29 = EpicSettings.Toggles['ooc'];
				v147 = 1 + 0;
			end
			if (((3409 + 970) >= (8025 - 5894)) and (v147 == (4 - 3))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v147 = 2 + 0;
			end
			if (((3166 + 678) >= (2837 - (413 + 381))) and (v147 == (1 + 4))) then
				if (not v12:AffectingCombat() or ((6873 - 3641) <= (7093 - 4362))) then
					if (((6875 - (582 + 1388)) == (8356 - 3451)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v246 = 0 + 0;
						local v247;
						while true do
							if (((364 - (326 + 38)) == v246) or ((12234 - 8098) >= (6296 - 1885))) then
								v247 = v119.DeadFriendlyUnitsCount();
								if ((v247 > (621 - (47 + 573))) or ((1043 + 1915) == (17060 - 13043))) then
									if (((1992 - 764) >= (2477 - (1269 + 395))) and v23(v113.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (v23(v115.ResuscitateMouseover, not v14:IsInRange(532 - (76 + 416))) or ((3898 - (319 + 124)) > (9257 - 5207))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if (((1250 - (564 + 443)) == (672 - 429)) and not v12:AffectingCombat() and v29) then
					local v242 = 458 - (337 + 121);
					while true do
						if (((0 - 0) == v242) or ((902 - 631) > (3483 - (1261 + 650)))) then
							v28 = v124();
							if (((1159 + 1580) < (5247 - 1954)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v29 or v12:AffectingCombat() or ((5759 - (772 + 1045)) < (160 + 974))) then
					if ((v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) or ((2837 - (102 + 42)) == (6817 - (1524 + 320)))) then
						if (((3416 - (1049 + 221)) == (2302 - (18 + 138))) and v23(v115.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if ((v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) or ((5492 - 3248) == (4326 - (67 + 1035)))) then
						if (v23(v115.ManaPotion, nil) or ((5252 - (136 + 212)) <= (8141 - 6225))) then
							return "Mana Potion main";
						end
					end
					if (((73 + 17) <= (982 + 83)) and (v12:DebuffStack(v113.Bursting) > (1609 - (240 + 1364)))) then
						if (((5884 - (1050 + 32)) == (17145 - 12343)) and v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) then
							if (v23(v113.DiffuseMagic, nil) or ((1349 + 931) <= (1566 - (331 + 724)))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					if (((v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) or ((136 + 1540) <= (1107 - (269 + 375)))) then
						if (((4594 - (267 + 458)) == (1204 + 2665)) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) then
							if (((2226 - 1068) <= (3431 - (667 + 151))) and v23(v113.Revival, nil)) then
								return "Revival Bursting";
							end
						end
					end
					if (v33 or ((3861 - (1410 + 87)) <= (3896 - (1504 + 393)))) then
						local v248 = 0 - 0;
						while true do
							if ((v248 == (0 - 0)) or ((5718 - (461 + 335)) < (25 + 169))) then
								if ((v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (1851 - (1730 + 31))) and v65) or ((3758 - (728 + 939)) < (109 - 78))) then
									if ((v64 == "Player") or ((4929 - 2499) >= (11162 - 6290))) then
										if (v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(1108 - (138 + 930))) or ((4359 + 411) < (1357 + 378))) then
											return "jade serpent main player";
										end
									elseif ((v64 == "Cursor") or ((3805 + 634) <= (9595 - 7245))) then
										if (v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(1806 - (459 + 1307))) or ((6349 - (474 + 1396)) < (7798 - 3332))) then
											return "jade serpent main cursor";
										end
									elseif (((2388 + 159) > (5 + 1220)) and (v64 == "Confirmation")) then
										if (((13379 - 8708) > (339 + 2335)) and v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(133 - 93))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if ((v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) or ((16118 - 12422) < (3918 - (562 + 29)))) then
									if ((v14:HealthPercentage() <= v52) or ((3873 + 669) == (4389 - (374 + 1045)))) then
										if (((200 + 52) <= (6138 - 4161)) and v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist))) then
											return "RenewingMist main";
										end
									end
								end
								v248 = 639 - (448 + 190);
							end
							if ((v248 == (1 + 0)) or ((649 + 787) == (2460 + 1315))) then
								if ((v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) or ((6220 - 4602) < (2889 - 1959))) then
									if (((6217 - (1307 + 187)) > (16468 - 12315)) and (v14:HealthPercentage() <= v60)) then
										if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((8555 - 4901) >= (14269 - 9615))) then
											return "SoothingMist main";
										end
									end
								end
								if (((1634 - (232 + 451)) <= (1429 + 67)) and v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (16 + 2)) and v113.ManaTea:IsCastable()) then
									if (v23(v113.ManaTea, nil) or ((2300 - (510 + 54)) == (1150 - 579))) then
										return "Mana Tea main avoid overcap";
									end
								end
								v248 = 38 - (13 + 23);
							end
							if ((v248 == (3 - 1)) or ((1286 - 390) > (8664 - 3895))) then
								if (((v111 > v98) and v31 and v12:AffectingCombat()) or ((2133 - (830 + 258)) <= (3598 - 2578))) then
									v28 = v131();
									if (v28 or ((726 + 434) <= (280 + 48))) then
										return v28;
									end
								end
								if (((5249 - (860 + 581)) > (10785 - 7861)) and v30) then
									v28 = v128();
									if (((3089 + 802) < (5160 - (237 + 4))) and v28) then
										return v28;
									end
								end
								v248 = 6 - 3;
							end
							if ((v248 == (6 - 3)) or ((4235 - 2001) <= (1230 + 272))) then
								v28 = v127();
								if (v28 or ((1443 + 1069) < (1630 - 1198))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v147 = 3 + 3;
			end
			if ((v147 == (2 + 0)) or ((3274 - (85 + 1341)) == (1476 - 611))) then
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (v12:IsDeadOrGhost() or ((13222 - 8540) <= (4913 - (45 + 327)))) then
					return;
				end
				v147 = 5 - 2;
			end
		end
	end
	local function v136()
		local v148 = 502 - (444 + 58);
		while true do
			if ((v148 == (1 + 0)) or ((521 + 2505) >= (1978 + 2068))) then
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
			if (((5818 - 3810) > (2370 - (64 + 1668))) and ((1973 - (1227 + 746)) == v148)) then
				v121();
				v113.Bursting:RegisterAuraTracking();
				v148 = 2 - 1;
			end
		end
	end
	v21.SetAPL(501 - 231, v135, v136);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

