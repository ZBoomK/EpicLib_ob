local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1953 - (457 + 32)) <= (1858 + 2519)) and not v5) then
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
	local v110 = 12513 - (832 + 570);
	local v111 = 10468 + 643;
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
		if (((702 + 1987) < (16713 - 11990)) and v113.ImprovedDetox:IsAvailable()) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellablePoisonDebuffs, v119.DispellableDiseaseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		local v137 = 0 + 0;
		while true do
			if (((4932 - (588 + 208)) >= (6460 - 4063)) and (v137 == (1802 - (884 + 916)))) then
				if ((v85 and (v12:HealthPercentage() <= v86)) or ((9073 - 4739) == (2462 + 1783))) then
					local v236 = 653 - (232 + 421);
					while true do
						if ((v236 == (1889 - (1569 + 320))) or ((1050 + 3226) <= (576 + 2455))) then
							if ((v87 == "Refreshing Healing Potion") or ((16114 - 11332) <= (1804 - (316 + 289)))) then
								if ((v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) or ((12732 - 7868) < (88 + 1814))) then
									if (((6292 - (666 + 787)) >= (4125 - (360 + 65))) and v23(v115.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if ((v87 == "Dreamwalker's Healing Potion") or ((1005 + 70) > (2172 - (79 + 175)))) then
								if (((624 - 228) <= (2969 + 835)) and v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) then
									if (v23(v115.RefreshingHealingPotion) or ((12778 - 8609) == (4211 - 2024))) then
										return "dreamwalkers healing potion defensive 5";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((2305 - (503 + 396)) == (1587 - (92 + 89))) and (v137 == (1 - 0))) then
				if (((786 + 745) < (2528 + 1743)) and v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) then
					if (((2486 - 1851) == (87 + 548)) and v23(v113.ExpelHarm, nil)) then
						return "expel_harm defensives 3";
					end
				end
				if (((7690 - 4317) <= (3103 + 453)) and v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) then
					if (v23(v115.Healthstone) or ((1572 + 1719) < (9989 - 6709))) then
						return "healthstone defensive 4";
					end
				end
				v137 = 1 + 1;
			end
			if (((6688 - 2302) >= (2117 - (485 + 759))) and (v137 == (0 - 0))) then
				if (((2110 - (442 + 747)) <= (2237 - (832 + 303))) and v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
					if (((5652 - (88 + 858)) >= (294 + 669)) and v23(v113.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((795 + 165) <= (37 + 839))) then
					if (v23(v113.FortifyingBrew, nil) or ((2855 - (766 + 23)) == (4601 - 3669))) then
						return "fortifying_brew defensives 2";
					end
				end
				v137 = 1 - 0;
			end
		end
	end
	local function v123()
		local v138 = 0 - 0;
		while true do
			if (((16376 - 11551) < (5916 - (1036 + 37))) and (v138 == (1 + 0))) then
				if (v102 or ((7549 - 3672) >= (3569 + 968))) then
					local v237 = 1480 - (641 + 839);
					while true do
						if ((v237 == (913 - (910 + 3))) or ((11000 - 6685) < (3410 - (1466 + 218)))) then
							v28 = v119.HandleChromie(v113.Riptide, v115.RiptideMouseover, 19 + 21);
							if (v28 or ((4827 - (556 + 592)) < (223 + 402))) then
								return v28;
							end
							v237 = 809 - (329 + 479);
						end
						if ((v237 == (855 - (174 + 680))) or ((15892 - 11267) < (1309 - 677))) then
							v28 = v119.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 29 + 11);
							if (v28 or ((822 - (396 + 343)) > (158 + 1622))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((2023 - (29 + 1448)) <= (2466 - (135 + 1254))) and v103) then
					v28 = v119.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 150 - 110);
					if (v28 or ((4650 - 3654) > (2867 + 1434))) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 1567 - (389 + 1138));
					if (((4644 - (102 + 472)) > (649 + 38)) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 23 + 17);
					if (v28 or ((612 + 44) >= (4875 - (320 + 1225)))) then
						return v28;
					end
					v28 = v119.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 71 - 31);
					if (v28 or ((1525 + 967) <= (1799 - (157 + 1307)))) then
						return v28;
					end
				end
				v138 = 1861 - (821 + 1038);
			end
			if (((10783 - 6461) >= (281 + 2281)) and (v138 == (3 - 1))) then
				if (v104 or ((1354 + 2283) >= (9344 - 5574))) then
					v28 = v119.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 1066 - (834 + 192));
					if (v28 or ((152 + 2227) > (1176 + 3402))) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 1 + 39);
					if (v28 or ((748 - 265) > (1047 - (300 + 4)))) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 11 + 29);
					if (((6423 - 3969) > (940 - (112 + 250))) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 16 + 24);
					if (((2329 - 1399) < (2554 + 1904)) and v28) then
						return v28;
					end
				end
				if (((343 + 319) <= (727 + 245)) and v105) then
					local v238 = 0 + 0;
					while true do
						if (((3247 + 1123) == (5784 - (1001 + 413))) and ((2 - 1) == v238)) then
							v28 = v119.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 922 - (244 + 638));
							if (v28 or ((5455 - (627 + 66)) <= (2565 - 1704))) then
								return v28;
							end
							v238 = 604 - (512 + 90);
						end
						if ((v238 == (1906 - (1665 + 241))) or ((2129 - (373 + 344)) == (1924 + 2340))) then
							v28 = v119.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 11 + 29);
							if (v28 or ((8356 - 5188) < (3642 - 1489))) then
								return v28;
							end
							v238 = 1100 - (35 + 1064);
						end
						if (((3 + 0) == v238) or ((10646 - 5670) < (6 + 1326))) then
							v28 = v119.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1276 - (298 + 938));
							if (((5887 - (233 + 1026)) == (6294 - (636 + 1030))) and v28) then
								return v28;
							end
							break;
						end
						if ((v238 == (2 + 0)) or ((53 + 1) == (118 + 277))) then
							v28 = v119.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 3 + 37);
							if (((303 - (55 + 166)) == (16 + 66)) and v28) then
								return v28;
							end
							v238 = 1 + 2;
						end
					end
				end
				break;
			end
			if ((v138 == (0 - 0)) or ((878 - (36 + 261)) < (492 - 210))) then
				if (v101 or ((5977 - (34 + 1334)) < (960 + 1535))) then
					local v239 = 0 + 0;
					while true do
						if (((2435 - (1035 + 248)) == (1173 - (20 + 1))) and (v239 == (0 + 0))) then
							v28 = v119.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 349 - (134 + 185), true);
							if (((3029 - (549 + 584)) <= (4107 - (314 + 371))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v100 or ((3398 - 2408) > (2588 - (478 + 490)))) then
					local v240 = 0 + 0;
					while true do
						if ((v240 == (1172 - (786 + 386))) or ((2840 - 1963) > (6074 - (1055 + 324)))) then
							v28 = v119.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 1370 - (1093 + 247));
							if (((2392 + 299) >= (195 + 1656)) and v28) then
								return v28;
							end
							v240 = 3 - 2;
						end
						if ((v240 == (3 - 2)) or ((8493 - 5508) >= (12202 - 7346))) then
							if (((1522 + 2754) >= (4603 - 3408)) and v113.Detox:CooldownRemains()) then
								local v244 = 0 - 0;
								while true do
									if (((2438 + 794) <= (11994 - 7304)) and (v244 == (688 - (364 + 324)))) then
										v28 = v119.HandleAfflicted(v113.Vivify, v115.VivifyMouseover, 82 - 52);
										if (v28 or ((2149 - 1253) >= (1043 + 2103))) then
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
				v138 = 4 - 3;
			end
		end
	end
	local function v124()
		if (((4901 - 1840) >= (8983 - 6025)) and v113.ChiBurst:IsCastable() and v49) then
			if (((4455 - (1249 + 19)) >= (582 + 62)) and v23(v113.ChiBurst, not v14:IsInRange(155 - 115))) then
				return "chi_burst precombat 4";
			end
		end
		if (((1730 - (686 + 400)) <= (553 + 151)) and v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (231 - (73 + 156)))) then
			if (((5 + 953) > (1758 - (721 + 90))) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(1 + 7))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if (((14584 - 10092) >= (3124 - (224 + 246))) and v113.TigerPalm:IsCastable() and v47) then
			if (((5575 - 2133) >= (2766 - 1263)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(1 + 4))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v125()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (3 + 1)) or ((6302 - 3132) <= (4871 - 3407))) then
				if ((v113.SpinningCraneKick:IsCastable() and v45) or ((5310 - (203 + 310)) == (6381 - (1238 + 755)))) then
					if (((39 + 512) <= (2215 - (709 + 825))) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(14 - 6))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((4773 - 1496) > (1271 - (196 + 668))) and (v139 == (7 - 5))) then
				if (((9725 - 5030) >= (2248 - (171 + 662))) and v113.SpinningCraneKick:IsCastable() and v45 and (v14:DebuffDown(v113.MysticTouchDebuff) or (v119.EnemiesWithDebuffCount(v113.MysticTouchDebuff) <= (v118 - (94 - (4 + 89))))) and v113.MysticTouch:IsAvailable()) then
					if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(27 - 19)) or ((1170 + 2042) <= (4146 - 3202))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (2 + 1))) or ((4582 - (35 + 1451)) <= (3251 - (28 + 1425)))) then
					if (((5530 - (941 + 1052)) == (3392 + 145)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(1519 - (822 + 692)))) then
						return "blackout_kick aoe 6";
					end
				end
				v139 = 3 - 0;
			end
			if (((1808 + 2029) >= (1867 - (45 + 252))) and (v139 == (3 + 0))) then
				if ((v113.BlackoutKick:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (1 + 1)) and v44) or ((7179 - 4229) == (4245 - (114 + 319)))) then
					if (((6780 - 2057) >= (2969 - 651)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(4 + 1))) then
						return "blackout_kick aoe 8";
					end
				end
				if ((v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (0 - 0)) and v47 and (v118 >= (5 - 2))) or ((3990 - (556 + 1407)) > (4058 - (741 + 465)))) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(470 - (170 + 295))) or ((599 + 537) > (3966 + 351))) then
						return "tiger_palm aoe 7";
					end
				end
				v139 = 9 - 5;
			end
			if (((3936 + 812) == (3045 + 1703)) and (v139 == (0 + 0))) then
				if (((4966 - (957 + 273)) <= (1268 + 3472)) and v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (2 + 1)) and v43) then
					if ((v42 == "Player") or ((12917 - 9527) <= (8063 - 5003))) then
						if (v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(122 - 82)) or ((4946 - 3947) > (4473 - (389 + 1391)))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((291 + 172) < (63 + 538)) and (v42 == "Cursor")) then
						if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(91 - 51)) or ((3134 - (783 + 168)) < (2305 - 1618))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((4475 + 74) == (4860 - (309 + 2))) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
						if (((14346 - 9674) == (5884 - (1090 + 122))) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(13 + 27))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) or ((12318 - 8650) < (271 + 124))) then
						if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(1158 - (628 + 490))) or ((748 + 3418) == (1126 - 671))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v42 == "Confirmation") or ((20331 - 15882) == (3437 - (431 + 343)))) then
						if (v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(80 - 40)) or ((12372 - 8095) < (2362 + 627))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v113.TouchofDeath:IsCastable() and v50) or ((112 + 758) >= (5844 - (556 + 1139)))) then
					if (((2227 - (6 + 9)) < (583 + 2600)) and v23(v113.TouchofDeath, not v14:IsInMeleeRange(3 + 2))) then
						return "touch_of_death aoe 2";
					end
				end
				v139 = 170 - (28 + 141);
			end
			if (((1800 + 2846) > (3692 - 700)) and (v139 == (1 + 0))) then
				if (((2751 - (486 + 831)) < (8082 - 4976)) and v113.JadefireStomp:IsReady() and v48) then
					if (((2767 - 1981) < (572 + 2451)) and v23(v113.JadefireStomp, not v14:IsInMeleeRange(25 - 17))) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v113.ChiBurst:IsCastable() and v49) or ((3705 - (668 + 595)) < (67 + 7))) then
					if (((915 + 3620) == (12367 - 7832)) and v23(v113.ChiBurst, not v14:IsInRange(330 - (23 + 267)))) then
						return "chi_burst aoe 4";
					end
				end
				v139 = 1946 - (1129 + 815);
			end
		end
	end
	local function v126()
		local v140 = 387 - (371 + 16);
		while true do
			if ((v140 == (1752 - (1326 + 424))) or ((5698 - 2689) <= (7692 - 5587))) then
				if (((1948 - (88 + 30)) < (4440 - (720 + 51))) and v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (6 - 3)) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
					if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(1781 - (421 + 1355))) or ((2359 - 929) >= (1775 + 1837))) then
						return "blackout_kick st 5";
					end
				end
				if (((3766 - (286 + 797)) >= (8992 - 6532)) and v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (4 - 1)) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (441 - (397 + 42)))) and v113.TeachingsoftheMonastery:IsAvailable() and v47) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(2 + 3)) or ((2604 - (24 + 776)) >= (5045 - 1770))) then
						return "tiger_palm st 6";
					end
				end
				v140 = 788 - (222 + 563);
			end
			if ((v140 == (6 - 3)) or ((1021 + 396) > (3819 - (23 + 167)))) then
				if (((6593 - (690 + 1108)) > (146 + 256)) and v113.BlackoutKick:IsCastable() and not v113.TeachingsoftheMonastery:IsAvailable() and v44) then
					if (((3970 + 843) > (4413 - (40 + 808))) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(1 + 4))) then
						return "blackout_kick st 7";
					end
				end
				if (((14959 - 11047) == (3739 + 173)) and v113.TigerPalm:IsCastable() and v47) then
					if (((1493 + 1328) <= (2646 + 2178)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(576 - (47 + 524)))) then
						return "tiger_palm st 8";
					end
				end
				break;
			end
			if (((1128 + 610) <= (6000 - 3805)) and (v140 == (0 - 0))) then
				if (((93 - 52) <= (4744 - (1165 + 561))) and v113.TouchofDeath:IsCastable() and v50) then
					if (((64 + 2081) <= (12710 - 8606)) and v23(v113.TouchofDeath, not v14:IsInMeleeRange(2 + 3))) then
						return "touch_of_death st 1";
					end
				end
				if (((3168 - (341 + 138)) < (1308 + 3537)) and v113.JadefireStomp:IsReady() and v48) then
					if (v23(v113.JadefireStomp, nil) or ((4791 - 2469) > (2948 - (89 + 237)))) then
						return "JadefireStomp st 2";
					end
				end
				v140 = 3 - 2;
			end
			if ((v140 == (1 - 0)) or ((5415 - (581 + 300)) == (3302 - (855 + 365)))) then
				if ((v113.RisingSunKick:IsReady() and v46) or ((3731 - 2160) > (610 + 1257))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1240 - (1030 + 205))) or ((2492 + 162) >= (2788 + 208))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((4264 - (156 + 130)) > (4780 - 2676)) and v113.ChiBurst:IsCastable() and v49) then
					if (((5047 - 2052) > (3155 - 1614)) and v23(v113.ChiBurst, not v14:IsInRange(11 + 29))) then
						return "chi_burst st 4";
					end
				end
				v140 = 2 + 0;
			end
		end
	end
	local function v127()
		local v141 = 69 - (10 + 59);
		while true do
			if (((919 + 2330) > (4693 - 3740)) and (v141 == (1165 - (671 + 492)))) then
				if ((v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) or ((2606 + 667) > (5788 - (369 + 846)))) then
					if ((v16:HealthPercentage() <= v60) or ((835 + 2316) < (1096 + 188))) then
						if (v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist)) or ((3795 - (1036 + 909)) == (1216 + 313))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((1378 - 557) < (2326 - (11 + 192))) and ((1 + 0) == v141)) then
				if (((1077 - (135 + 40)) < (5633 - 3308)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) then
					if (((518 + 340) <= (6525 - 3563)) and (v16:HealthPercentage() <= v52)) then
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((5915 - 1969) < (1464 - (50 + 126)))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) or ((9027 - 5785) == (126 + 441))) then
					if ((v16:HealthPercentage() <= v56) or ((2260 - (1233 + 180)) >= (2232 - (522 + 447)))) then
						if (v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify)) or ((3674 - (107 + 1314)) == (859 + 992))) then
							return "Vivify instant healing st";
						end
					end
				end
				v141 = 5 - 3;
			end
			if ((v141 == (0 + 0)) or ((4143 - 2056) > (9385 - 7013))) then
				if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (1911.8 - (716 + 1194)))) or ((76 + 4369) < (445 + 3704))) then
					if ((v16:HealthPercentage() <= v52) or ((2321 - (74 + 429)) == (163 - 78))) then
						if (((313 + 317) < (4868 - 2741)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 18 + 7) > (2 - 1))) or ((4791 - 2853) == (2947 - (279 + 154)))) then
					if (((5033 - (454 + 324)) >= (44 + 11)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(22 - (12 + 5)))) then
						return "RisingSunKick healing st";
					end
				end
				v141 = 1 + 0;
			end
		end
	end
	local function v128()
		local v142 = 0 - 0;
		while true do
			if (((1109 + 1890) > (2249 - (277 + 816))) and (v142 == (4 - 3))) then
				if (((3533 - (1058 + 125)) > (217 + 938)) and v66 and v113.ZenPulse:IsReady() and v119.AreUnitsBelowHealthPercentage(v68, v67, v113.EnvelopingMist)) then
					if (((5004 - (815 + 160)) <= (20822 - 15969)) and v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v119.AreUnitsBelowHealthPercentage(v71, v70, v113.EnvelopingMist)) or ((1224 - 708) > (820 + 2614))) then
					if (((11827 - 7781) >= (4931 - (41 + 1857))) and v23(v113.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if ((v142 == (1893 - (1222 + 671))) or ((7027 - 4308) <= (2079 - 632))) then
				if ((v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 1207 - (229 + 953)) > (1775 - (1111 + 663)))) or ((5713 - (874 + 705)) < (550 + 3376))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(4 + 1)) or ((340 - 176) >= (79 + 2706))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v119.AreUnitsBelowHealthPercentage(v63, v62, v113.EnvelopingMist) or ((1204 - (642 + 37)) == (481 + 1628))) then
					if (((6 + 27) == (82 - 49)) and v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) then
						if (((3508 - (233 + 221)) <= (9284 - 5269)) and v23(v113.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((1647 + 224) < (4923 - (718 + 823))) and v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) then
						if (((814 + 479) <= (2971 - (266 + 539))) and v23(v113.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if ((v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (22 - 14)))) or ((3804 - (636 + 589)) < (291 - 168))) then
						if (v23(v113.EssenceFont, nil) or ((1744 - 898) >= (1877 + 491))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) or ((1458 + 2554) <= (4373 - (657 + 358)))) then
						if (((3955 - 2461) <= (6846 - 3841)) and v23(v113.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v142 = 1188 - (1151 + 36);
			end
		end
	end
	local function v129()
		local v143 = 0 + 0;
		while true do
			if (((0 + 0) == v143) or ((9290 - 6179) == (3966 - (1552 + 280)))) then
				if (((3189 - (64 + 770)) == (1599 + 756)) and v57 and v113.EnvelopingMist:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 56 - 31) < (1 + 2))) then
					v28 = v119.FocusUnitRefreshableBuff(v113.EnvelopingMist, 1245 - (157 + 1086), 80 - 40, nil, false, 109 - 84, v113.EnvelopingMist);
					if (v28 or ((901 - 313) <= (589 - 157))) then
						return v28;
					end
					if (((5616 - (599 + 220)) >= (7756 - 3861)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
				end
				if (((5508 - (1813 + 118)) == (2615 + 962)) and v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 1242 - (841 + 376)) > (2 - 0))) then
					if (((882 + 2912) > (10080 - 6387)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(864 - (464 + 395)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v143 = 2 - 1;
			end
			if (((1 + 0) == v143) or ((2112 - (467 + 370)) == (8472 - 4372))) then
				if ((v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) or ((1168 + 423) >= (12272 - 8692))) then
					if (((154 + 829) <= (4206 - 2398)) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v130()
		if ((v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (523 - (150 + 370)))) or ((3432 - (74 + 1208)) <= (2943 - 1746))) then
			if (((17874 - 14105) >= (835 + 338)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(395 - (14 + 376)))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((2575 - 1090) == (961 + 524)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (3 + 0))) then
			if ((v16:HealthPercentage() <= v58) or ((3162 + 153) <= (8151 - 5369))) then
				if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((660 + 216) >= (3042 - (23 + 55)))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v46 and v113.RisingSunKick:IsReady()) or ((5289 - 3057) > (1667 + 830))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(5 + 0)) or ((3271 - 1161) <= (105 + 227))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((4587 - (652 + 249)) > (8488 - 5316)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (1870 - (708 + 1160)))) then
			if ((v16:HealthPercentage() <= v58) or ((12144 - 7670) < (1495 - 675))) then
				if (((4306 - (10 + 17)) >= (648 + 2234)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) or ((3761 - (1400 + 332)) >= (6753 - 3232))) then
			if (v23(v113.EssenceFont, nil) or ((3945 - (242 + 1666)) >= (1987 + 2655))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v131()
		local v144 = 0 + 0;
		while true do
			if (((1466 + 254) < (5398 - (850 + 90))) and ((4 - 1) == v144)) then
				if ((v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1415 - (360 + 1030))) or ((386 + 50) > (8526 - 5505))) then
					v28 = v130();
					if (((980 - 267) <= (2508 - (909 + 752))) and v28) then
						return v28;
					end
				end
				break;
			end
			if (((3377 - (109 + 1114)) <= (7379 - 3348)) and ((1 + 0) == v144)) then
				if (((4857 - (6 + 236)) == (2908 + 1707)) and v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) then
					if (v23(v113.Restoral, nil) or ((3051 + 739) == (1179 - 679))) then
						return "Restoral CD";
					end
				end
				if (((154 - 65) < (1354 - (1076 + 57))) and v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v119.AreUnitsBelowHealthPercentage(v74, v73, v113.EnvelopingMist)) then
					if (((338 + 1716) >= (2110 - (579 + 110))) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 + 0))) then
						v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 6 + 0, 22 + 18, nil, false, 432 - (174 + 233), v113.EnvelopingMist);
						if (((1932 - 1240) < (5366 - 2308)) and v28) then
							return v28;
						end
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((1447 + 1807) == (2829 - (663 + 511)))) then
							return "Renewing Mist YuLon prep";
						end
					end
					if ((v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (3 + 0)) and v12:BuffDown(v113.ManaTeaBuff)) or ((282 + 1014) == (15137 - 10227))) then
						if (((2040 + 1328) == (7929 - 4561)) and v23(v113.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if (((6398 - 3755) < (1821 + 1994)) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (38 - 18))) then
						if (((1364 + 549) > (46 + 447)) and v23(v113.SheilunsGift, nil)) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if (((5477 - (478 + 244)) > (3945 - (440 + 77))) and v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((14 - 10) * v12:GCD()))) then
						if (((2937 - (655 + 901)) <= (440 + 1929)) and v23(v113.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v144 = 2 + 0;
			end
			if (((0 + 0) == v144) or ((19510 - 14667) == (5529 - (695 + 750)))) then
				if (((15943 - 11274) > (559 - 196)) and v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
					if (v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon)) or ((7548 - 5671) >= (3489 - (285 + 66)))) then
						return "Life Cocoon CD";
					end
				end
				if (((11053 - 6311) >= (4936 - (682 + 628))) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) then
					if (v23(v113.Revival, nil) or ((732 + 3808) == (1215 - (176 + 123)))) then
						return "Revival CD";
					end
				end
				v144 = 1 + 0;
			end
			if (((2 + 0) == v144) or ((1425 - (239 + 30)) > (1182 + 3163))) then
				if (((2151 + 86) < (7520 - 3271)) and (v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (77 - 52))) then
					v28 = v129();
					if (v28 or ((2998 - (306 + 9)) < (80 - 57))) then
						return v28;
					end
				end
				if (((122 + 575) <= (507 + 319)) and v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v77, v76, v113.EnvelopingMist)) then
					if (((532 + 573) <= (3362 - 2186)) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1376 - (1140 + 235)))) then
						v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 4 + 2, 37 + 3, nil, false, 7 + 18, v113.EnvelopingMist);
						if (((3431 - (33 + 19)) <= (1377 + 2435)) and v28) then
							return v28;
						end
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((2361 - 1573) >= (712 + 904))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if (((3635 - 1781) <= (3169 + 210)) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (709 - (586 + 103)))) then
						if (((415 + 4134) == (14004 - 9455)) and v23(v113.SheilunsGift, nil)) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					if ((v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1489 - (1309 + 179))) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (5 - 2)) and (v113.SheilunsGift:TimeSinceLastCast() < ((2 + 2) * v12:GCD()))) or ((8115 - 5093) >= (2285 + 739))) then
						if (((10240 - 5420) > (4379 - 2181)) and v23(v113.InvokeChiJiTheRedCrane, nil)) then
							return "Invoke Chi'ji GO";
						end
					end
				end
				v144 = 612 - (295 + 314);
			end
		end
	end
	local function v132()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (1969 - (1300 + 662))) or ((3331 - 2270) >= (6646 - (1178 + 577)))) then
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v145 = 5 + 3;
			end
			if (((4032 - 2668) <= (5878 - (851 + 554))) and ((3 + 0) == v145)) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v145 = 10 - 6;
			end
			if ((v145 == (0 - 0)) or ((3897 - (115 + 187)) <= (3 + 0))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v145 = 1 + 0;
			end
			if ((v145 == (31 - 23)) or ((5833 - (160 + 1001)) == (3370 + 482))) then
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v145 = 7 + 2;
			end
			if (((3190 - 1631) == (1917 - (237 + 121))) and (v145 == (901 - (525 + 372)))) then
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v145 = 9 - 4;
			end
			if (((16 - 11) == v145) or ((1894 - (96 + 46)) <= (1565 - (643 + 134)))) then
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v145 = 3 + 3;
			end
			if ((v145 == (2 - 1)) or ((14505 - 10598) == (170 + 7))) then
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v145 = 3 - 1;
			end
			if (((7093 - 3623) > (1274 - (316 + 403))) and (v145 == (2 + 0))) then
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v145 = 8 - 5;
			end
			if ((v145 == (4 + 5)) or ((2447 - 1475) == (458 + 187))) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((1026 + 2156) >= (7328 - 5213)) and (v145 == (28 - 22))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v145 = 14 - 7;
			end
		end
	end
	local function v133()
		v95 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useRacials'];
		v97 = EpicSettings.Settings['trinketsWithCD'];
		v96 = EpicSettings.Settings['useTrinkets'];
		v98 = EpicSettings.Settings['fightRemainsCheck'];
		v99 = EpicSettings.Settings['useWeapon'];
		v88 = EpicSettings.Settings['dispelDebuffs'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v86 = EpicSettings.Settings['healingPotionHP'];
		v87 = EpicSettings.Settings['HealingPotionName'];
		v83 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['healthstoneHP'];
		v106 = EpicSettings.Settings['useManaPotion'];
		v107 = EpicSettings.Settings['manaPotionSlider'];
		v108 = EpicSettings.Settings['RevivalBurstingGroup'];
		v109 = EpicSettings.Settings['RevivalBurstingStacks'];
		v91 = EpicSettings.Settings['InterruptThreshold'];
		v89 = EpicSettings.Settings['InterruptWithStun'];
		v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v92 = EpicSettings.Settings['useSpearHandStrike'];
		v93 = EpicSettings.Settings['useLegSweep'];
		v100 = EpicSettings.Settings['handleAfflicted'];
		v101 = EpicSettings.Settings['HandleIncorporeal'];
		v102 = EpicSettings.Settings['HandleChromie'];
		v104 = EpicSettings.Settings['HandleCharredBrambles'];
		v103 = EpicSettings.Settings['HandleCharredTreant'];
		v105 = EpicSettings.Settings['HandleFyrakkNPC'];
		v72 = EpicSettings.Settings['UseInvokeYulon'];
		v74 = EpicSettings.Settings['InvokeYulonHP'];
		v73 = EpicSettings.Settings['InvokeYulonGroup'];
		v75 = EpicSettings.Settings['UseInvokeChiJi'];
		v77 = EpicSettings.Settings['InvokeChiJiHP'];
		v76 = EpicSettings.Settings['InvokeChiJiGroup'];
		v78 = EpicSettings.Settings['UseLifeCocoon'];
		v79 = EpicSettings.Settings['LifeCocoonHP'];
		v80 = EpicSettings.Settings['UseRevival'];
		v82 = EpicSettings.Settings['RevivalHP'];
		v81 = EpicSettings.Settings['RevivalGroup'];
	end
	local v134 = 0 + 0;
	local function v135()
		v132();
		v133();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		if (((7663 - 3770) < (217 + 4212)) and v12:IsDeadOrGhost()) then
			return;
		end
		v117 = v12:GetEnemiesInMeleeRange(23 - 15);
		if (v30 or ((2884 - (12 + 5)) < (7399 - 5494))) then
			v118 = #v117;
		else
			v118 = 1 - 0;
		end
		if (v119.TargetIsValid() or v12:AffectingCombat() or ((3817 - 2021) >= (10045 - 5994))) then
			local v193 = 0 + 0;
			while true do
				if (((3592 - (1656 + 317)) <= (3347 + 409)) and (v193 == (1 + 0))) then
					v111 = v110;
					if (((1605 - 1001) == (2972 - 2368)) and (v111 == (11465 - (5 + 349)))) then
						v111 = v9.FightRemains(v112, false);
					end
					break;
				end
				if ((v193 == (0 - 0)) or ((5755 - (266 + 1005)) == (594 + 306))) then
					v112 = v12:GetEnemiesInRange(136 - 96);
					v110 = v9.BossFightRemains(nil, true);
					v193 = 1 - 0;
				end
			end
		end
		v28 = v123();
		if (v28 or ((6155 - (561 + 1135)) <= (1449 - 336))) then
			return v28;
		end
		if (((11938 - 8306) > (4464 - (507 + 559))) and (v12:AffectingCombat() or v29)) then
			local v194 = 0 - 0;
			local v195;
			while true do
				if (((12624 - 8542) <= (5305 - (212 + 176))) and (v194 == (905 - (250 + 655)))) then
					v195 = v88 and v113.Detox:IsReady() and v32;
					v28 = v119.FocusUnit(v195, nil, 109 - 69, nil, 43 - 18, v113.EnvelopingMist);
					v194 = 1 - 0;
				end
				if (((6788 - (1869 + 87)) >= (4807 - 3421)) and (v194 == (1902 - (484 + 1417)))) then
					if (((293 - 156) == (229 - 92)) and v28) then
						return v28;
					end
					if ((v32 and v88) or ((2343 - (48 + 725)) >= (7076 - 2744))) then
						local v241 = 0 - 0;
						while true do
							if ((v241 == (0 + 0)) or ((10860 - 6796) <= (510 + 1309))) then
								if ((v16 and v16:Exists() and v16:IsAPlayer() and (v119.UnitHasDispellableDebuffByPlayer(v16) or v119.DispellableFriendlyUnit(8 + 17))) or ((5839 - (152 + 701)) < (2885 - (430 + 881)))) then
									if (((1695 + 2731) > (1067 - (557 + 338))) and v113.Detox:IsCastable()) then
										if (((174 + 412) > (1282 - 827)) and (v134 == (0 - 0))) then
											v134 = GetTime();
										end
										if (((2194 - 1368) == (1779 - 953)) and v119.Wait(1301 - (499 + 302), v134)) then
											if (v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox)) or ((4885 - (39 + 827)) > (12259 - 7818))) then
												return "detox dispel focus";
											end
											v134 = 0 - 0;
										end
									end
								end
								if (((8011 - 5994) < (6541 - 2280)) and v15 and v15:Exists() and not v12:CanAttack(v15) and v119.UnitHasDispellableDebuffByPlayer(v15)) then
									if (((404 + 4312) > (234 - 154)) and v113.Detox:IsCastable()) then
										if (v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox)) or ((562 + 2945) == (5176 - 1904))) then
											return "detox dispel mouseover";
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
		if (not v12:AffectingCombat() or ((980 - (103 + 1)) >= (3629 - (475 + 79)))) then
			if (((9407 - 5055) > (8172 - 5618)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v234 = v119.DeadFriendlyUnitsCount();
				if ((v234 > (1 + 0)) or ((3878 + 528) < (5546 - (1395 + 108)))) then
					if (v23(v113.Reawaken, nil) or ((5496 - 3607) >= (4587 - (7 + 1197)))) then
						return "reawaken";
					end
				elseif (((825 + 1067) <= (954 + 1780)) and v23(v115.ResuscitateMouseover, not v14:IsInRange(359 - (27 + 292)))) then
					return "resuscitate";
				end
			end
		end
		if (((5634 - 3711) < (2827 - 609)) and not v12:AffectingCombat() and v29) then
			v28 = v124();
			if (((9113 - 6940) > (746 - 367)) and v28) then
				return v28;
			end
		end
		if (v29 or v12:AffectingCombat() or ((4934 - 2343) == (3548 - (43 + 96)))) then
			if (((18412 - 13898) > (7514 - 4190)) and v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) then
				if (v23(v115.UseWeapon, nil) or ((173 + 35) >= (1364 + 3464))) then
					return "Using Weapon Macro";
				end
			end
			if ((v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) or ((3128 - 1545) > (1368 + 2199))) then
				if (v23(v115.ManaPotion, nil) or ((2460 - 1147) == (250 + 544))) then
					return "Mana Potion main";
				end
			end
			if (((233 + 2941) > (4653 - (1414 + 337))) and (v12:DebuffStack(v113.Bursting) > (1945 - (1642 + 298)))) then
				if (((10740 - 6620) <= (12255 - 7995)) and v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) then
					if (v23(v113.DiffuseMagic, nil) or ((2620 - 1737) > (1573 + 3205))) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) or ((2817 + 803) >= (5863 - (357 + 615)))) then
				if (((2989 + 1269) > (2299 - 1362)) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) then
					if (v23(v113.Revival, nil) or ((4172 + 697) < (1941 - 1035))) then
						return "Revival Bursting";
					end
				end
			end
			if ((v32 and v88) or ((980 + 245) > (288 + 3940))) then
				if (((2092 + 1236) > (3539 - (384 + 917))) and v113.TigersLust:IsReady() and v119.UnitHasDebuffFromList(v12, v119.DispellableRootDebuffs) and v12:CanAttack(v14)) then
					if (((4536 - (128 + 569)) > (2948 - (1407 + 136))) and v23(v113.TigersLust, nil)) then
						return "Tigers Lust Roots";
					end
				end
			end
			if (v33 or ((3180 - (687 + 1200)) <= (2217 - (556 + 1154)))) then
				local v235 = 0 - 0;
				while true do
					if ((v235 == (97 - (9 + 86))) or ((3317 - (275 + 146)) < (131 + 674))) then
						if (((2380 - (29 + 35)) == (10264 - 7948)) and (v111 > v98) and v31 and v12:AffectingCombat()) then
							v28 = v131();
							if (v28 or ((7676 - 5106) == (6767 - 5234))) then
								return v28;
							end
						end
						if (v30 or ((576 + 307) == (2472 - (53 + 959)))) then
							v28 = v128();
							if (v28 or ((5027 - (312 + 96)) <= (1733 - 734))) then
								return v28;
							end
						end
						v235 = 288 - (147 + 138);
					end
					if ((v235 == (899 - (813 + 86))) or ((3082 + 328) > (7625 - 3509))) then
						if ((v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (582 - (18 + 474))) and v65) or ((305 + 598) >= (9983 - 6924))) then
							if ((v64 == "Player") or ((5062 - (860 + 226)) < (3160 - (121 + 182)))) then
								if (((607 + 4323) > (3547 - (988 + 252))) and v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(5 + 35))) then
									return "jade serpent main player";
								end
							elseif ((v64 == "Cursor") or ((1268 + 2778) < (3261 - (49 + 1921)))) then
								if (v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(930 - (223 + 667))) or ((4293 - (51 + 1)) == (6101 - 2556))) then
									return "jade serpent main cursor";
								end
							elseif ((v64 == "Confirmation") or ((8668 - 4620) > (5357 - (146 + 979)))) then
								if (v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(12 + 28)) or ((2355 - (311 + 294)) >= (9685 - 6212))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((1342 + 1824) == (4609 - (496 + 947))) and v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) then
							if (((3121 - (1233 + 125)) < (1512 + 2212)) and (v14:HealthPercentage() <= v52)) then
								if (((52 + 5) <= (518 + 2205)) and v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist))) then
									return "RenewingMist main";
								end
							end
						end
						v235 = 1646 - (963 + 682);
					end
					if ((v235 == (1 + 0)) or ((3574 - (504 + 1000)) == (299 + 144))) then
						if ((v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) or ((2464 + 241) == (132 + 1261))) then
							if ((v14:HealthPercentage() <= v60) or ((6784 - 2183) < (53 + 8))) then
								if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((809 + 581) >= (4926 - (156 + 26)))) then
									return "SoothingMist main";
								end
							end
						end
						if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (11 + 7)) and v113.ManaTea:IsCastable()) or ((3132 - 1129) > (3998 - (149 + 15)))) then
							if (v23(v113.ManaTea, nil) or ((1116 - (890 + 70)) > (4030 - (39 + 78)))) then
								return "Mana Tea main avoid overcap";
							end
						end
						v235 = 484 - (14 + 468);
					end
					if (((428 - 233) == (545 - 350)) and (v235 == (2 + 1))) then
						v28 = v127();
						if (((1865 + 1240) >= (382 + 1414)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
		end
		if (((1978 + 2401) >= (559 + 1572)) and (v29 or v12:AffectingCombat()) and v119.TargetIsValid() and v12:CanAttack(v14) and not v14:IsDeadOrGhost()) then
			local v196 = 0 - 0;
			while true do
				if (((3800 + 44) >= (7178 - 5135)) and (v196 == (1 + 0))) then
					if ((v96 and ((v31 and v97) or not v97)) or ((3283 - (12 + 39)) <= (2541 + 190))) then
						local v242 = 0 - 0;
						while true do
							if (((17469 - 12564) == (1455 + 3450)) and (v242 == (0 + 0))) then
								v28 = v119.HandleTopTrinket(v116, v31, 101 - 61, nil);
								if (v28 or ((2755 + 1381) >= (21317 - 16906))) then
									return v28;
								end
								v242 = 1711 - (1596 + 114);
							end
							if ((v242 == (2 - 1)) or ((3671 - (164 + 549)) == (5455 - (1059 + 379)))) then
								v28 = v119.HandleBottomTrinket(v116, v31, 49 - 9, nil);
								if (((637 + 591) >= (138 + 675)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if (v34 or ((3847 - (145 + 247)) > (3324 + 726))) then
						if (((113 + 130) == (719 - 476)) and v94 and ((v31 and v95) or not v95) and (v111 < (4 + 14))) then
							if (v113.BloodFury:IsCastable() or ((234 + 37) > (2551 - 979))) then
								if (((3459 - (254 + 466)) < (3853 - (544 + 16))) and v23(v113.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (v113.Berserking:IsCastable() or ((12527 - 8585) < (1762 - (294 + 334)))) then
								if (v23(v113.Berserking, nil) or ((2946 - (236 + 17)) == (2144 + 2829))) then
									return "berserking main 6";
								end
							end
							if (((1671 + 475) == (8081 - 5935)) and v113.LightsJudgment:IsCastable()) then
								if (v23(v113.LightsJudgment, not v14:IsInRange(189 - 149)) or ((1156 + 1088) == (2656 + 568))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((5698 - (413 + 381)) <= (81 + 1835))) then
								if (((191 - 101) <= (2766 - 1701)) and v23(v113.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							if (((6772 - (582 + 1388)) == (8181 - 3379)) and v113.AncestralCall:IsCastable()) then
								if (v23(v113.AncestralCall, nil) or ((1633 + 647) <= (875 - (326 + 38)))) then
									return "ancestral_call main 12";
								end
							end
							if (v113.BagofTricks:IsCastable() or ((4957 - 3281) <= (660 - 197))) then
								if (((4489 - (47 + 573)) == (1364 + 2505)) and v23(v113.BagofTricks, not v14:IsInRange(169 - 129))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if (((1879 - 721) <= (4277 - (1269 + 395))) and v37 and v113.ThunderFocusTea:IsReady() and (not v113.EssenceFont:IsAvailable() or not v119.AreUnitsBelowHealthPercentage(v63, v62, v113.EnvelopingMist)) and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) then
							if (v23(v113.ThunderFocusTea, nil) or ((2856 - (76 + 416)) <= (2442 - (319 + 124)))) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((v118 >= (6 - 3)) and v30) or ((5929 - (564 + 443)) < (536 - 342))) then
							local v243 = 458 - (337 + 121);
							while true do
								if ((v243 == (0 - 0)) or ((6965 - 4874) < (1942 - (1261 + 650)))) then
									v28 = v125();
									if (v28 or ((1029 + 1401) >= (7764 - 2892))) then
										return v28;
									end
									break;
								end
							end
						end
						if ((v118 < (1820 - (772 + 1045))) or ((673 + 4097) < (1879 - (102 + 42)))) then
							v28 = v126();
							if (v28 or ((6283 - (1524 + 320)) <= (3620 - (1049 + 221)))) then
								return v28;
							end
						end
					end
					break;
				end
				if (((156 - (18 + 138)) == v196) or ((10963 - 6484) < (5568 - (67 + 1035)))) then
					v28 = v122();
					if (((2895 - (136 + 212)) > (5205 - 3980)) and v28) then
						return v28;
					end
					v196 = 1 + 0;
				end
			end
		end
	end
	local function v136()
		v121();
		v113.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(249 + 21, v135, v136);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

